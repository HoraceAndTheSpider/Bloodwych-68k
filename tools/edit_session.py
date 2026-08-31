"""One live resource session shared by viewers; original inputs are immutable."""
from __future__ import annotations

from dataclasses import dataclass
import copy
import hashlib
import json
import tempfile
from pathlib import Path, PurePosixPath
from types import SimpleNamespace

from tools.data_overlay import related_data_roots
from tools.resource_layout import EXTRACT_ONLY, data_action, resource_layouts, resource_name
from tools.tool_common import (BINARIES_DIR, DEFAULT_SEGMENTS_FILE, ToolError,
                               binary_path, get_profile, load_segments, parse_int)


@dataclass(frozen=True)
class ResourceSpec:
    name: str
    offset: int
    size: int
    extract_only: bool = False


def resource_specs(master: str, sheet: Path = DEFAULT_SEGMENTS_FILE) -> dict[str, ResourceSpec]:
    frame = load_segments(sheet, master)
    resource_layouts(frame)
    specs = {}
    for _, row in frame.iterrows():
        name = resource_name(row)
        if not name:
            continue
        path = PurePosixPath(name)
        offset, size = parse_int(row.get("offset")), parse_int(row.get("size"))
        if path.is_absolute() or ".." in path.parts or "\\" in name:
            raise ToolError(f"Unsafe resource path: {name}")
        if offset is None:
            continue  # Named metadata without a mapped address is not editable.
        if size is None or offset < 0 or size <= 0:
            raise ToolError(f"Invalid resource offset/size: {name}")
        spec = ResourceSpec(name, offset, size, data_action(row) == EXTRACT_ONLY)
        if name in specs and specs[name] != spec:
            raise ToolError(f"Conflicting resource definitions: {name}")
        specs[name] = spec
    editable = sorted((spec for spec in specs.values() if not spec.extract_only), key=lambda spec: spec.offset)
    for previous, current in zip(editable, editable[1:]):
        if previous.offset + previous.size > current.offset:
            raise ToolError(f"Overlapping editable resources: {previous.name}, {current.name}")
    return specs


@dataclass(frozen=True)
class SessionPath:
    session: EditSession
    relative: str = ""

    def __truediv__(self, child: str | Path) -> SessionPath:
        return SessionPath(self.session, str(PurePosixPath(self.relative) / str(child)))

    @property
    def name(self):
        return PurePosixPath(self.relative).name if self.relative else self.session.clean_root.name

    @property
    def resolved_path(self):
        return self.session.clean_root / self.relative

    @property
    def uses_modified(self):
        return (self.relative in self.session.specs
                and self.session.read(self.relative) != self.session.baseline(self.relative))

    def read_bytes(self):
        return self.session.read(self.relative)

    def exists(self):
        return self.is_file() or self.is_dir()

    def is_file(self):
        return self.relative in self.session.specs or self.relative in self.session.changes or self.resolved_path.is_file()

    def is_dir(self):
        prefix = self.relative.rstrip("/") + "/" if self.relative else ""
        return any(name.startswith(prefix) for name in self.session.specs) or self.resolved_path.is_dir()

    def stat(self):
        return SimpleNamespace(st_size=len(self.read_bytes())) if self.is_file() else self.resolved_path.stat()

    def __str__(self):
        return str(self.resolved_path)


class EditSession:
    """Raw resources are authoritative; decoded viewer models can be discarded.

    A fork owns independent bytes and has no output authority. It is the future
    play-test bubble; simulation must never mutate this session in place.
    """

    def __init__(self, master: str = "BLOODWYCH439", *, sheet: Path = DEFAULT_SEGMENTS_FILE,
                 clean_root: Path | None = None, modified_root: Path | None = None,
                 savegame_path: Path | None = None, prefer_modified: bool = False):
        from tools.binary_identity import identify_binary
        self.sheet = Path(sheet)
        self.profile = get_profile(master)
        self.family = self.profile.family
        source = binary_path(master)
        self.identity = identify_binary(source, sheet=self.sheet)
        if self.identity.family != self.family:
            raise ToolError(f"{source.name} contains {self.identity.family}, not {self.family}")
        if not self.identity.layout_compatible:
            raise ToolError(f"{source.name}: {self.identity.family}. {self.identity.reason}")
        self.specs = resource_specs(self.family, self.sheet)
        reference = get_profile(self.family)
        self.clean_root = clean_root or reference.clean_dir
        self.modified_root = modified_root or self.profile.modified_dir
        from tools.binary_identity import _reference
        self.original = _reference(self.family)
        self.original_digest = hashlib.sha256(self.original).hexdigest()
        self.binary_data = self.original
        self.binary_name = source.name
        self.binary_source = source.resolve()
        self.changes: dict[str, bytes] = {}
        self.revision = 0
        self.is_bubble = False
        self.unmapped_imports: tuple[str, ...] = ()
        self.save_path: Path | None = None
        self.last_save_path: Path | None = None
        self.save_original: bytes | None = None
        self.save_data: bytearray | None = None
        self.save_base = self.specs["data/champions.stats"].offset
        self.root = SessionPath(self)
        for spec in self.specs.values():
            if spec.offset + spec.size > len(self.original):
                raise ToolError(f"Resource exceeds original binary: {spec.name}")
        if source.read_bytes() != self.original:
            self.import_binary(source)
        if savegame_path is not None:
            self.select_save(savegame_path)
        if prefer_modified:
            self.import_modified()

    @classmethod
    def for_data_root(cls, data_root: Path, **kwargs) -> EditSession:
        clean, modified, supplied_modified = related_data_roots(Path(data_root))
        name = clean.name.removesuffix("-clean")
        kwargs["prefer_modified"] = kwargs.get("prefer_modified", False) or supplied_modified
        return cls(name, clean_root=clean, modified_root=modified, **kwargs)

    def _changed(self):
        self.revision += 1

    def baseline(self, name: str) -> bytes:
        spec = self.specs.get(name)
        if spec is not None:
            start = spec.offset - self.save_base
            if self.save_original is not None and 0 <= start and start + spec.size <= len(self.save_original):
                return self.save_original[start:start + spec.size]
            return self.original[spec.offset:spec.offset + spec.size]
        return (self.clean_root / name).read_bytes()

    def read(self, name: str) -> bytes:
        if name in self.changes:
            return bytes(self.changes[name])
        spec = self.specs.get(name)
        if spec:
            if spec.extract_only:
                raw = bytearray(self.binary_data[spec.offset:spec.offset + spec.size])
                start = spec.offset - self.save_base
                if self.save_data is not None and 0 <= start and start + spec.size <= len(self.save_data):
                    raw = bytearray(self.save_data[start:start + spec.size])
                for other in self.specs.values():
                    left = max(spec.offset, other.offset)
                    right = min(spec.offset + spec.size, other.offset + other.size)
                    if not other.extract_only and left < right:
                        raw[left - spec.offset:right - spec.offset] = self.read(other.name)[left - other.offset:right - other.offset]
                return bytes(raw)
            start = spec.offset - self.save_base
            if self.save_data is not None and 0 <= start and start + spec.size <= len(self.save_data):
                return bytes(self.save_data[start:start + spec.size])
            return self.binary_data[spec.offset:spec.offset + spec.size]
        return (self.clean_root / name).read_bytes()

    def write(self, name: str, data: bytes):
        spec = self.specs.get(name)
        if spec is None or spec.extract_only:
            raise ToolError(f"Not an editable resource: {name}")
        data = bytes(data)
        if self.read(name) == data:
            return
        if self.save_data is not None:
            start = spec.offset - self.save_base
            if 0 <= start and start + spec.size <= len(self.save_data) and len(data) == spec.size:
                self.save_data[start:start + spec.size] = data
                self.changes.pop(name, None)
            else:
                self.changes[name] = data
        else:
            self.changes[name] = data
        self._changed()

    @property
    def changed_resources(self) -> dict[str, bytes]:
        return {name: self.read(name) for name, spec in self.specs.items()
                if not spec.extract_only and self.read(name) != self.baseline(name)}

    def select_save(self, path: Path | None):
        if path is None:
            self.save_path = self.save_original = self.save_data = None
        else:
            data = Path(path).read_bytes()
            # The mapped 439 WHDLoad slice must contain every tower and runtime
            # monster state. Size alone cannot distinguish Extended Levels saves.
            required = 0x1600 * 9  # Original AMOS SAVEGAME_TO_DISK Bsave length.
            if self.family != "BLOODWYCH439" or len(data) != required:
                raise ToolError(f"Unsupported save layout: expected {required} bytes for SPS 439, found {len(data)}")
            if data[0x305] not in range(6):
                raise ToolError("Save does not have a valid SPS 439 current-tower field; possibly Extended Levels")
            self.save_path = Path(path).resolve()
            self.last_save_path = self.save_path
            self.save_original = data
            self.save_data = bytearray(data)
        self.changes.clear()
        self.unmapped_imports = ()
        self._changed()

    def reset(self):
        # Read/validate first: a missing save must not half-reset the session.
        save_path = self.save_path
        self.select_save(save_path)
        self.binary_data = self.original
        self.binary_name = self.family
        self.binary_source = (BINARIES_DIR / self.family).resolve()
        self._changed()

    def reload(self, names):
        for name in tuple(names):
            if name in self.specs and not self.specs[name].extract_only:
                self.write(name, self.baseline(name))
        self._changed()

    def import_binary(self, path: Path):
        from tools.binary_identity import identify_bytes
        path = Path(path)
        data = Path(path).read_bytes()
        identity = identify_bytes(data, sheet=self.sheet)
        if identity.family != self.family or not identity.layout_compatible:
            raise ToolError(f"Cannot import {path.name}: {identity.family}. {identity.reason}")
        if self.save_path is not None:
            raise ToolError("Switch Save Data OFF before loading a binary; export save edits first if needed")
        profile = get_profile(str(path))
        # Follow the newly loaded binary for normal project outputs. Preserve
        # an explicitly supplied custom output directory (e.g. isolated tools).
        if self.modified_root.resolve() == self.profile.modified_dir.resolve():
            self.modified_root = profile.modified_dir
        self.profile = profile
        self.identity = identity
        self.binary_data = data
        self.binary_name = Path(path).name
        self.binary_source = Path(path).resolve()
        self.changes.clear()
        self.unmapped_imports = ()
        self._changed()

    def import_modified(self, directory: Path | None = None):
        directory = Path(directory or self.modified_root)
        if not directory.is_dir():
            raise ToolError(f"Modified resource folder not found: {directory}")
        manifest_path = directory / ".edit-session.json"
        manifest = json.loads(manifest_path.read_text()) if manifest_path.exists() else None
        if manifest is not None:
            if not isinstance(manifest, dict) or not isinstance(manifest.get("resources"), list):
                raise ToolError("Invalid session export manifest")
            if "sha256" in manifest and not isinstance(manifest["sha256"], dict):
                raise ToolError("Invalid resource checksums in export manifest")
            output_name = manifest.get("binary_name", self.family)
            if not isinstance(output_name, str) or Path(output_name).name != output_name or output_name in (".", ".."):
                raise ToolError("Invalid binary name in export manifest")
            if manifest.get("family") != self.family or manifest.get("original_sha256") != self.original_digest:
                raise ToolError("Export belongs to an incompatible binary project")
            if manifest.get("save_sha256") != (hashlib.sha256(self.save_original).hexdigest() if self.save_original else None):
                raise ToolError("Export belongs to a different binary/save target")
            names = manifest["resources"]
        else:
            names = [name for name, spec in self.specs.items()
                     if not spec.extract_only and (directory / name).is_file()]
        unmapped = ()
        if manifest is None:
            unmapped = tuple(sorted(p.relative_to(directory).as_posix()
                             for subdir in ("data", "maps", "gfx", "gfx-data", "monsters")
                             for p in (directory / subdir).rglob("*")
                             if p.is_file() and not p.name.startswith(".") and p.relative_to(directory).as_posix() not in self.specs))
        pending = {}
        for name in names:
            if not isinstance(name, str) or name not in self.specs or self.specs[name].extract_only:
                raise ToolError(f"Unknown or read-only imported resource: {name}")
            pending[name] = (directory / name).read_bytes()
            if manifest and "sha256" in manifest:
                if hashlib.sha256(pending[name]).hexdigest() != manifest["sha256"].get(name):
                    raise ToolError(f"Incomplete or changed export snapshot: {name}")
        imported_binary = None
        if manifest and manifest.get("binary_state"):
            from tools.binary_identity import identify_bytes
            imported_binary = (directory / ".edit-binary-state.bin").read_bytes()
            identity = identify_bytes(imported_binary, sheet=self.sheet)
            if identity.family != self.family or not identity.layout_compatible:
                raise ToolError("Exported executable has an incompatible layout")
        saved = None
        if manifest and manifest.get("runtime_state"):
            saved = (directory / ".edit-save-state.bin").read_bytes()
            if self.save_original is None or len(saved) != len(self.save_original):
                raise ToolError("Imported runtime state has an incompatible size")
        if manifest and imported_binary is not None and "binary_state_sha256" in manifest:
            if hashlib.sha256(imported_binary).hexdigest() != manifest["binary_state_sha256"]:
                raise ToolError("Incomplete or changed executable export snapshot")
        if manifest and saved is not None and "save_state_sha256" in manifest:
            if hashlib.sha256(saved).hexdigest() != manifest["save_state_sha256"]:
                raise ToolError("Incomplete or changed save export snapshot")
        if manifest is not None:
            # A manifest is a complete session snapshot, not a partial merge.
            self.changes.clear()
            self.binary_data = imported_binary if imported_binary is not None else self.original
            self.binary_name = output_name
            self.binary_source = ((directory / ".edit-binary-state.bin") if imported_binary is not None
                                  else (BINARIES_DIR / self.family)).resolve()
        if saved is not None:
            self.save_data = bytearray(saved)
        for name, data in pending.items():
            self.write(name, data)
        self.unmapped_imports = unmapped
        self._changed()

    def export(self) -> tuple[Path, ...]:
        if self.unmapped_imports:
            raise ToolError("Unmapped import files must be resolved before export: " + ", ".join(self.unmapped_imports))
        if self.is_bubble:
            raise ToolError("Play-test bubbles cannot export or patch")
        changed = self.changed_resources
        paths = []
        # Publish the manifest last. It records the exact snapshot, so files
        # left from older exports cannot silently reappear on the next import.
        for name, data in changed.items():
            destination = self.modified_root / name
            self._write_output(destination, data)
            paths.append(destination)
        if self.save_data is not None:
            self._write_output(self.modified_root / ".edit-save-state.bin", bytes(self.save_data))
        if self.binary_data != self.original:
            self._write_output(self.modified_root / ".edit-binary-state.bin", self.binary_data)
        # Include explicit reverts over an imported binary: a sparse diff
        # against the original alone would lose them when restoring its code.
        for name, data in self.changes.items():
            if name not in changed:
                self._write_output(self.modified_root / name, data)
                changed[name] = data
                paths.append(self.modified_root / name)
        manifest = {"binary_state": self.binary_data != self.original,
                    "binary_name": self.binary_name,
                    "family": self.family, "original_sha256": self.original_digest,
                    "save_sha256": hashlib.sha256(self.save_original).hexdigest() if self.save_original else None,
                    "resources": sorted(changed), "runtime_state": self.save_data is not None,
                    "sha256": {name: hashlib.sha256(data).hexdigest() for name, data in changed.items()},
                    "binary_state_sha256": hashlib.sha256(self.binary_data).hexdigest(),
                    "save_state_sha256": hashlib.sha256(self.save_data).hexdigest() if self.save_data is not None else None}
        self._write_output(self.modified_root / ".edit-session.json", json.dumps(manifest, indent=2).encode())
        return tuple(paths)

    @property
    def has_changes(self) -> bool:
        return bool(self.changed_resources or self.binary_data != self.original
                    or self.save_data != self.save_original)

    def patch_blockers(self) -> tuple[str, ...]:
        blockers = [f"Unmapped imported resource: {name}" for name in self.unmapped_imports]
        if self.is_bubble:
            return ("Play-test bubbles cannot export or patch",)
        for name, data in self.changed_resources.items():
            spec = self.specs[name]
            if len(data) != spec.size:
                blockers.append(f"{name}: {len(data)} bytes; requires {spec.size}. Source rebuild needed.")
            if self.save_data is not None:
                start = spec.offset - self.save_base
                if start < 0 or start + spec.size > len(self.save_data):
                    blockers.append(f"{name} is outside this save; export it for a binary project")
        return tuple(blockers)

    def build_patch(self) -> bytes:
        blockers = self.patch_blockers()
        if blockers:
            raise ToolError("; ".join(blockers))
        output = bytearray(self.save_data if self.save_data is not None else self.binary_data)
        pending = self.changed_resources if self.save_data is not None else self.changes
        for name, data in pending.items():
            spec = self.specs[name]
            start = spec.offset - (self.save_base if self.save_data is not None else 0)
            output[start:start + spec.size] = data
        return bytes(output)

    def patch(self, *, confirm_save: bool = False) -> Path:
        if self.save_data is not None and not confirm_save:
            raise ToolError("Confirm writing a modified save copy; the loaded save stays untouched")
        output = self.build_patch()  # Validate every change before creating any output.
        destination = (self.modified_root / "whdload" / self.save_path.name
                       if self.save_path else BINARIES_DIR / f"{self.binary_name}-modified")
        return self._write_output(destination, output, exclusive=True)

    def _write_output(self, destination: Path, data: bytes, *, exclusive: bool = False):
        resolved = destination.resolve()
        if not (self.modified_root.resolve() in resolved.parents or BINARIES_DIR.resolve() == resolved.parent):
            raise ToolError("Output path escapes the project output folders")
        if resolved == (BINARIES_DIR / self.family).resolve() or (self.save_path and resolved == self.save_path):
            raise ToolError("Refusing to overwrite an original input")
        if self.clean_root.resolve() in resolved.parents:
            raise ToolError("Refusing to write into clean data")
        destination.parent.mkdir(parents=True, exist_ok=True)
        if exclusive:
            # Never clobber an earlier binary/save result or another input.
            stem = destination.name
            serial = 1
            while destination.exists():
                destination = destination.with_name(f"{stem}.{serial}")
                serial += 1
            with destination.open("xb") as handle:
                handle.write(data)
            self.last_output = destination
        else:
            temporary = None
            try:
                with tempfile.NamedTemporaryFile(dir=destination.parent, prefix=".export-", delete=False) as handle:
                    temporary = Path(handle.name)
                    handle.write(data)
                temporary.replace(destination)
            finally:
                if temporary is not None and temporary.exists():
                    temporary.unlink()
        return destination

    def fork(self) -> EditSession:
        bubble = copy.copy(self)
        bubble.changes = dict(self.changes)
        bubble.save_data = bytearray(self.save_data) if self.save_data is not None else None
        bubble.root = SessionPath(bubble)
        bubble.is_bubble = True
        return bubble
