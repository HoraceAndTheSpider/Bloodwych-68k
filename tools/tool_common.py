"""Shared paths, profiles, and spreadsheet helpers for Bloodwych ReSource."""

from __future__ import annotations

from dataclasses import dataclass, replace
import hashlib
from pathlib import Path
from typing import Iterable

import pandas as pd


PROJECT_ROOT = Path(__file__).resolve().parents[1]
ASM_DIR = PROJECT_ROOT / "asm"
BINARIES_DIR = PROJECT_ROOT / "binaries"
DATA_DIR = PROJECT_ROOT / "data"
WHDLOAD_DIR = PROJECT_ROOT / "whdload"
DEFAULT_SEGMENTS_FILE = PROJECT_ROOT / "segments.xlsx"
DEFAULT_CLEANUP_FILE = PROJECT_ROOT / "cleanup.xlsx"


class ToolError(RuntimeError):
    """A user-facing project/tool error."""


@dataclass(frozen=True)
class BinaryProfile:
    filename: str
    data_name: str
    platform: str
    product: str
    segment_sheet: str | None = None
    source_asm: str | None = None
    relabel_asm: str | None = None
    aliases: tuple[str, ...] = ()
    reference_name: str | None = None
    layout_compatible: bool = True

    @property
    def family(self) -> str:
        return self.reference_name or self.filename

    @property
    def clean_dir(self) -> Path:
        return DATA_DIR / f"{self.data_name}-clean"

    @property
    def modified_dir(self) -> Path:
        return DATA_DIR / f"{self.data_name}-modified"


PROFILES = (
    BinaryProfile(
        "BLOODWYCH439",
        "BLOODWYCH439",
        "Amiga",
        "Bloodwych",
        "BLOODWYCH439",
        "Bloodwych439.asm",
        "BLOODWYCH439_relabel.asm",
        ("Bloodwych439",),
    ),
    BinaryProfile("BLOODWYCH102", "BLOODWYCH102", "Amiga", "Bloodwych"),
    BinaryProfile("BLOODWYCH1927", "BLOODWYCH1927", "Amiga", "Bloodwych"),
    BinaryProfile("BEXT43", "BEXT43", "Amiga", "Extended Levels", aliases=("Bext43",)),
    BinaryProfile("AtariST_DEMO_CODE", "AtariST_DEMO_CODE", "Atari ST", "Bloodwych demo"),
)


def parse_int(value: object) -> int | None:
    """Parse signed spreadsheet decimal, ``0x`` hex, or Amiga ``$`` values."""
    try:
        if pd.isna(value):
            return None
        if isinstance(value, str):
            text = value.strip()
            if not text:
                return None
            sign = 1
            if text[0] in "+-":
                if text[0] == "-":
                    sign = -1
                text = text[1:].strip()
                if not text:
                    return None
            if text.startswith("$"):
                return sign * int(text[1:], 16)
            if text.lower().startswith("0x"):
                return sign * int(text, 16)
            if sign < 0:
                text = f"-{text}"
            return int(text)
        return int(value)
    except (TypeError, ValueError, OverflowError):
        return None


def get_profile(master: str) -> BinaryProfile:
    """Resolve a configured binary by filename, alias, or path basename."""
    supplied_path = Path(master)
    supplied = supplied_path.name
    candidates = {supplied.casefold(), supplied_path.stem.casefold()}
    matched = next((profile for profile in PROFILES
                    if candidates & {profile.filename.casefold(), *(alias.casefold() for alias in profile.aliases)}), None)
    path = supplied_path if supplied_path.is_file() else BINARIES_DIR / supplied_path
    if not path.is_file() and matched is not None:
        path = BINARIES_DIR / matched.filename
    if path.is_file():
        from .binary_identity import identify_binary
        identity = identify_binary(path)
        reference = next(profile for profile in PROFILES if profile.filename == identity.family)
        if identity.exact and path.resolve() == (BINARIES_DIR / reference.filename).resolve():
            return reference
        data_name = path.name
        if path.resolve() != (BINARIES_DIR / path.name).resolve():
            data_name += "-" + hashlib.sha256(path.read_bytes()).hexdigest()[:10]
        return replace(reference, filename=path.name, data_name=data_name,
                       source_asm=None, relabel_asm=None, aliases=(),
                       reference_name=reference.filename,
                       layout_compatible=identity.layout_compatible)
    if matched is not None:
        return matched
    known = ", ".join(profile.filename for profile in PROFILES)
    raise ToolError(f"Unknown binary '{master}'. Supply a binary path or one of: {known}")



def resolve_project_path(path: str | Path) -> Path:
    value = Path(path)
    return value if value.is_absolute() else PROJECT_ROOT / value


def resolve_cleanup_path(
    sheet: str | Path,
    cleanup: str | Path | None = None,
) -> Path:
    """Resolve the EQUATES/COMMENTS workbook for a project operation."""

    if cleanup is not None:
        path = resolve_project_path(cleanup)
        if not path.is_file():
            raise ToolError(f"Cleanup workbook not found: {path}")
        return path
    sheet_path = resolve_project_path(sheet)
    sibling = sheet_path.with_name(DEFAULT_CLEANUP_FILE.name)
    if sibling.is_file():
        return sibling
    # Compatibility fallback for older workbooks and isolated test fixtures.
    return sheet_path


def binary_path(master: str) -> Path:
    supplied = Path(master)
    if supplied.is_absolute() or supplied.is_file():
        return supplied.resolve()
    candidate = BINARIES_DIR / supplied
    return candidate if candidate.is_file() else BINARIES_DIR / get_profile(master).filename


def asm_path(master: str, stage: str = "source") -> Path:
    profile = get_profile(master)
    if stage == "source":
        filename = profile.source_asm
    elif stage == "relabel":
        filename = profile.relabel_asm
    elif stage == "data":
        filename = (
            f"{Path(profile.relabel_asm).stem}_data.asm" if profile.relabel_asm else None
        )
    elif stage == "asmfix":
        filename = (
            f"{Path(profile.source_asm).stem}_asmfix.asm"
            if profile.source_asm
            else None
        )
    else:
        raise ToolError(f"Unknown ASM stage '{stage}'")
    if not filename:
        raise ToolError(f"No {stage} ASM source is configured for {profile.filename}")
    return ASM_DIR / filename


def load_segments(sheet: str | Path, master: str) -> pd.DataFrame:
    """Load and normalise the correct segment sheet for a binary profile."""
    path = resolve_project_path(sheet)
    if not path.is_file():
        raise ToolError(f"Segment definition file not found: {path}")

    if path.suffix.casefold() == ".csv":
        frame = pd.read_csv(path)
    else:
        profile = get_profile(master)
        if not profile.layout_compatible:
            raise ToolError(f"{profile.filename} is based on {profile.family}, but its resource layout is not verified")
        if not profile.segment_sheet:
            raise ToolError(
                f"No segments.xlsx sheet is configured yet for {profile.filename}"
            )
        with pd.ExcelFile(path) as book:
            sheet_name = next(
                (
                    name
                    for name in book.sheet_names
                    if name.casefold() == profile.segment_sheet.casefold()
                ),
                None,
            )
            if sheet_name is None:
                raise ToolError(
                    f"Workbook {path.name} has no '{profile.segment_sheet}' sheet "
                    f"for {profile.filename}"
                )
            frame = pd.read_excel(book, sheet_name=sheet_name)

    frame.columns = [str(column).strip().casefold() for column in frame.columns]

    def repeated_header(row: pd.Series) -> bool:
        populated = 0
        for column, value in row.items():
            if value is None or pd.isna(value):
                continue
            text = str(value).strip().casefold()
            if not text:
                continue
            populated += 1
            if text != column:
                return False
        return populated >= 2

    # Long maintained sheets may repeat their headings before a new section.
    # Keep original indices so later validation still reports the real Excel row.
    frame = frame.loc[~frame.apply(repeated_header, axis=1)]
    return frame


def require_columns(frame: pd.DataFrame, columns: Iterable[str]) -> None:
    missing = [column for column in columns if column not in frame.columns]
    if missing:
        raise ToolError(f"Missing spreadsheet column(s): {', '.join(missing)}")


def relative_to_root(path: Path) -> str:
    try:
        return path.resolve().relative_to(PROJECT_ROOT.resolve()).as_posix()
    except ValueError:
        return path.resolve().as_posix()
