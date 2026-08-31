"""Content-based identification; family recognition is not relocation knowledge."""
from __future__ import annotations

from dataclasses import dataclass
from functools import lru_cache
import hashlib
import re
from pathlib import Path

from tools.tool_common import BINARIES_DIR, DEFAULT_SEGMENTS_FILE, PROFILES, ToolError

# Digests of the immutable reference inputs, not names of user modifications.
REFERENCE_DIGESTS = {
    "BLOODWYCH439": "ebc4b3116cb850b4fa81886e4c1c668cd8992f299b40f994c9a40c84009c8f15",
    "BLOODWYCH102": "781b690bb787eb906ec2e6b09f04f9b6bb1dcc7d0f31b6938d9ae65c0e3275c4",
    "BLOODWYCH1927": "48f645320ae5a2f93d43679fd1b72d3a4282ba3a035a9366ca34246db3a96780",
    "BEXT43": "2bd7cb30c832a733069c472ece9b1a53978caa01dd847aa2198b5573f508ccec",
    "AtariST_DEMO_CODE": "6a220a30b638d54be68c2703e5975f8a5e91f0d7bfe2282cb69d303a09b59f86",
}


@dataclass(frozen=True)
class BinaryIdentity:
    family: str
    exact: bool
    similarity: float
    layout_compatible: bool
    reason: str


@lru_cache(maxsize=8)
def _reference(name: str) -> bytes:
    data = (BINARIES_DIR / name).read_bytes()
    if hashlib.sha256(data).hexdigest() != REFERENCE_DIGESTS[name]:
        raise ToolError(f"Reference binary {name} has changed; identification is disabled")
    return data


def resource_mask(sheet: Path = DEFAULT_SEGMENTS_FILE) -> bytes:
    from tools.tool_common import load_segments, parse_int
    from tools.resource_layout import resource_name

    mask = bytearray(len(_reference("BLOODWYCH439")))
    for _, row in load_segments(sheet, "BLOODWYCH439").iterrows():
        offset, size = parse_int(row.get("offset")), parse_int(row.get("size"))
        if resource_name(row) and offset is not None and size is not None:
            if 0 <= offset <= offset + size <= len(mask):
                mask[offset:offset + size] = b"\1" * size
    return bytes(mask)


@lru_cache(maxsize=1)
def _default_mask() -> bytes:
    return resource_mask()


@lru_cache(maxsize=1)
def _coordinate_operands() -> tuple[tuple[int, int], ...]:
    """Locate source-verified crystal-action X/Y immediates, not addresses.

    These world coordinates are outside today's extracted resources. Edited
    towers can change them without relocating data. Every other unmapped byte
    must remain identical before the fixed resource layout is accepted.
    """
    from tools.tool_common import ASM_DIR
    source_name = next(profile.source_asm for profile in PROFILES if profile.filename == "BLOODWYCH439")
    source = (ASM_DIR / source_name).read_text()
    if "\nCrystalActions:" not in source or "\nadrCd005A7C:" not in source:
        raise ToolError("Original crystal-coordinate source scopes are missing")
    scope = source.split("\nCrystalActions:", 1)[1].split("\nadrCd005A7C:", 1)[0]
    reference = _reference("BLOODWYCH439")
    operands = []
    for line in scope.splitlines():
        match = re.match(r"\s*move\.l\s+#\$[0-9A-Fa-f]{8},d7\s*;([0-9A-Fa-f]{12})(?:\s|;|$)", line)
        if match:
            opcode = bytes.fromhex(match.group(1))
            if reference.count(opcode) != 1:
                raise ToolError("Cannot uniquely verify a crystal coordinate instruction")
            start = reference.index(opcode) + 2
            operands.append((start, start + 4))
    if len(operands) != 7:
        raise ToolError("Original crystal-coordinate evidence is incomplete")
    return tuple(operands)


def fixed_layout_matches(data: bytes, reference: bytes, mask: bytes) -> bool:
    if len(data) != len(reference) or data[:32] != reference[:32] or data[-4:] != reference[-4:]:
        return False
    allowed = bytearray(mask)
    for start, end in _coordinate_operands():
        if int.from_bytes(data[start:start + 2], "big") > 31 or int.from_bytes(data[start + 2:end], "big") > 31:
            return False
        allowed[start:end] = b"\1" * (end - start)
    return all(a == b or allowed[index] for index, (a, b) in enumerate(zip(data, reference)))


def identify_bytes(data: bytes, *, sheet: Path = DEFAULT_SEGMENTS_FILE) -> BinaryIdentity:
    digest = hashlib.sha256(data).hexdigest()
    for family, expected in REFERENCE_DIGESTS.items():
        if digest == expected:
            return BinaryIdentity(family, True, 1.0, family == "BLOODWYCH439",
                                  "Verified reference" if family == "BLOODWYCH439" else "Resource layout not yet mapped")

    # Ignore editable data when comparing code at its original file positions.
    # 1927 differs from 439 by only 223 bytes, so a percentage threshold alone
    # is insufficient: require positive evidence at distinguishing positions.
    mask = _default_mask() if Path(sheet) == DEFAULT_SEGMENTS_FILE else resource_mask(sheet)
    candidates = []
    for profile in PROFILES:
        reference = _reference(profile.filename)
        positions = [i for i in range(min(len(reference), len(data)))
                     if i >= len(mask) or not mask[i]]
        if len(data) < len(reference) or not positions:
            continue
        score = sum(data[i] == reference[i] for i in positions) / len(positions)
        if score >= 0.99:
            candidates.append((score, profile.filename, reference))
    if not candidates:
        raise ToolError("Unrecognised binary: no supported reference has matching code")
    candidates.sort(reverse=True)
    score, family, reference = candidates[0]
    for _, other_family, other in candidates[1:]:
        different = [i for i in range(min(len(reference), len(other), len(data)))
                     if reference[i] != other[i] and (i >= len(mask) or not mask[i])]
        support = sum(data[i] == reference[i] for i in different)
        opposition = sum(data[i] == other[i] for i in different)
        if not different or support < len(different) * 0.6 or support <= opposition * 2:
            raise ToolError(f"Ambiguous binary: cannot distinguish {family} from {other_family}")
    compatible = family == "BLOODWYCH439" and fixed_layout_matches(data, reference, mask)
    reason = ("Verified unchanged resource placement; edited SPS 439 data"
              if compatible else "Recognised family only; changed size, unmapped code, or unmapped resource layout requires source/relocation work")
    return BinaryIdentity(family, False, score, compatible, reason)


def identify_binary(path: Path, *, sheet: Path = DEFAULT_SEGMENTS_FILE) -> BinaryIdentity:
    return identify_bytes(Path(path).read_bytes(), sheet=sheet)


def binary_catalog(directory: Path = BINARIES_DIR) -> tuple[tuple[Path, BinaryIdentity | None, str], ...]:
    entries = []
    for path in sorted(directory.iterdir()):
        if path.is_file() and not path.name.startswith("."):
            try:
                identity = identify_binary(path)
                entries.append((path, identity, identity.reason))
            except (OSError, ToolError) as error:
                entries.append((path, None, str(error)))
    return tuple(entries)
