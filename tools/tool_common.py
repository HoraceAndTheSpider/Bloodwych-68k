"""Shared paths, profiles, and spreadsheet helpers for Bloodwych ReSource."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

import pandas as pd


PROJECT_ROOT = Path(__file__).resolve().parents[1]
ASM_DIR = PROJECT_ROOT / "asm"
BINARIES_DIR = PROJECT_ROOT / "binaries"
DATA_DIR = PROJECT_ROOT / "data"
WHDLOAD_DIR = PROJECT_ROOT / "whdload"
DEFAULT_SEGMENTS_FILE = PROJECT_ROOT / "segments.xlsx"


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
    """Parse spreadsheet decimal, ``0x`` hexadecimal, or Amiga ``$`` values."""
    try:
        if pd.isna(value):
            return None
        if isinstance(value, str):
            text = value.strip()
            if not text:
                return None
            if text.startswith("$"):
                return int(text[1:], 16)
            if text.lower().startswith("0x"):
                return int(text, 16)
            return int(text)
        return int(value)
    except (TypeError, ValueError, OverflowError):
        return None


def get_profile(master: str) -> BinaryProfile:
    """Resolve a configured binary by filename, alias, or path basename."""
    supplied = Path(master).name
    supplied_stem = Path(supplied).stem
    candidates = {supplied.casefold(), supplied_stem.casefold()}
    for profile in PROFILES:
        names = {profile.filename.casefold(), *(alias.casefold() for alias in profile.aliases)}
        if candidates & names:
            return profile
    known = ", ".join(profile.filename for profile in PROFILES)
    raise ToolError(f"Unknown binary '{master}'. Known binaries: {known}")


def resolve_project_path(path: str | Path) -> Path:
    value = Path(path)
    return value if value.is_absolute() else PROJECT_ROOT / value


def binary_path(master: str) -> Path:
    supplied = Path(master)
    if supplied.is_absolute():
        return supplied
    return BINARIES_DIR / get_profile(master).filename


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
        if not profile.segment_sheet:
            raise ToolError(
                f"No segments.xlsx sheet is configured yet for {profile.filename}"
            )
        book = pd.ExcelFile(path)
        sheet_name = next(
            (name for name in book.sheet_names if name.casefold() == profile.segment_sheet.casefold()),
            None,
        )
        if sheet_name is None:
            raise ToolError(
                f"Workbook {path.name} has no '{profile.segment_sheet}' sheet for {profile.filename}"
            )
        frame = pd.read_excel(book, sheet_name=sheet_name)

    frame.columns = [str(column).strip().casefold() for column in frame.columns]
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
