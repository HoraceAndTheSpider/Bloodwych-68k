"""Read extracted resources with a WHDLoad savegame layered over them."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path

from tools.data_overlay import related_data_roots
from tools.tool_common import DEFAULT_SEGMENTS_FILE, load_segments, parse_int


@dataclass(frozen=True)
class SavegameOverlayPath:
    """A read-only Path-like view that substitutes resources held in a save.

    WHDLoad saves are a contiguous slice beginning at ``champions.stats``.
    Resources before that point, or beyond the supplied save, deliberately
    continue to come from the clean extracted project.
    """

    clean_path: Path
    save_data: bytes
    segment_offsets: dict[str, tuple[int, int]]
    save_base_offset: int
    relative_name: str = ""

    def __truediv__(self, child: str | Path) -> SavegameOverlayPath:
        child_name = Path(child).as_posix()
        relative_name = "/".join(
            part for part in (self.relative_name, child_name) if part
        )
        return SavegameOverlayPath(
            self.clean_path / child,
            self.save_data,
            self.segment_offsets,
            self.save_base_offset,
            relative_name,
        )

    @property
    def name(self) -> str:
        return self.clean_path.name

    @property
    def resolved_path(self) -> Path:
        """The on-disk fallback, for consumers that need a display name/stat."""
        return self.clean_path

    def exists(self) -> bool:
        return self.clean_path.exists()

    def is_file(self) -> bool:
        return self.clean_path.is_file()

    def is_dir(self) -> bool:
        return self.clean_path.is_dir()

    def stat(self):
        return self.clean_path.stat()

    def read_bytes(self) -> bytes:
        segment = self.segment_offsets.get(self.relative_name)
        if segment is not None:
            offset, size = segment
            start = offset - self.save_base_offset
            end = start + size
            if 0 <= start <= end <= len(self.save_data):
                return self.save_data[start:end]
        return self.clean_path.read_bytes()

    def __str__(self) -> str:
        return str(self.clean_path)


def load_savegame_overlay(
    data_root: Path,
    save_path: Path,
    *,
    master: str = "BLOODWYCH439",
    sheet: Path = DEFAULT_SEGMENTS_FILE,
) -> tuple[Path, Path, bytes, dict[str, tuple[int, int]], int]:
    """Load a save and its spreadsheet-defined resource address map."""
    clean_root, modified_root, _ = related_data_roots(Path(data_root))
    frame = load_segments(sheet, master)
    segment_offsets: dict[str, tuple[int, int]] = {}
    for _, row in frame.iterrows():
        name = str(row.get("name", "")).strip()
        offset = parse_int(row.get("offset"))
        size = parse_int(row.get("size"))
        if name and name != "nan" and offset is not None and size is not None:
            segment_offsets.setdefault(name, (offset, size))

    stats = segment_offsets.get("data/champions.stats")
    if stats is None:
        raise ValueError("segments.xlsx has no data/champions.stats resource")
    return clean_root, modified_root, Path(save_path).read_bytes(), segment_offsets, stats[0]


def savegame_overlay_root(
    data_root: Path,
    save_path: Path,
    *,
    master: str = "BLOODWYCH439",
    sheet: Path = DEFAULT_SEGMENTS_FILE,
) -> SavegameOverlayPath:
    """Create a clean-data view with resources from ``save_path`` substituted."""
    clean_root, _, save_data, segment_offsets, save_base = load_savegame_overlay(
        data_root, save_path, master=master, sheet=sheet
    )
    return SavegameOverlayPath(clean_root, save_data, segment_offsets, save_base)
