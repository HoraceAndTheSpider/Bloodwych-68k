"""Read an extracted data set with optional per-file modified overrides."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class DataOverlayPath:
    """A small read-only, Path-like view of clean and modified data.

    When the overlay is enabled, an existing modified file wins.  Missing
    modified files fall back to the corresponding clean file.  Directories are
    considered present when either side exists, allowing sparse overlays.
    """

    clean_path: Path
    modified_path: Path | None = None
    modified_enabled: bool = False

    def __truediv__(self, child: str | Path) -> DataOverlayPath:
        return DataOverlayPath(
            self.clean_path / child,
            self.modified_path / child if self.modified_path is not None else None,
            self.modified_enabled,
        )

    @property
    def name(self) -> str:
        return self.clean_path.name

    @property
    def resolved_path(self) -> Path:
        if (
            self.modified_enabled
            and self.modified_path is not None
            and self.modified_path.exists()
        ):
            return self.modified_path
        return self.clean_path

    @property
    def uses_modified(self) -> bool:
        return (
            self.modified_enabled
            and self.modified_path is not None
            and self.modified_path.is_file()
        )

    def exists(self) -> bool:
        return self.resolved_path.exists()

    def is_file(self) -> bool:
        return self.resolved_path.is_file()

    def is_dir(self) -> bool:
        if self.clean_path.is_dir():
            return True
        return bool(
            self.modified_enabled
            and self.modified_path is not None
            and self.modified_path.is_dir()
        )

    def read_bytes(self) -> bytes:
        return self.resolved_path.read_bytes()

    def stat(self):
        return self.resolved_path.stat()

    def __str__(self) -> str:
        return str(self.resolved_path)


def related_data_roots(data_root: Path) -> tuple[Path, Path, bool]:
    """Return clean root, modified root, and whether the supplied root was modified."""
    if data_root.name.endswith("-modified"):
        stem = data_root.name[: -len("-modified")]
        return data_root.with_name(f"{stem}-clean"), data_root, True
    if data_root.name.endswith("-clean"):
        stem = data_root.name[: -len("-clean")]
        return data_root, data_root.with_name(f"{stem}-modified"), False
    return data_root, data_root.with_name(f"{data_root.name}-modified"), False


def data_overlay_root(
    clean_root: Path, modified_root: Path, *, enabled: bool
) -> DataOverlayPath:
    """Create a read-only overlay root for one extracted data set."""
    return DataOverlayPath(clean_root, modified_root, enabled)
