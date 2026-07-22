"""Binary models shared by the Bloodwych map viewer and editors."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

from tools.data_overlay import related_data_roots
from tools.tool_common import DEFAULT_SEGMENTS_FILE, load_segments, parse_int


MAP_RESOURCE_SIZE = 0x1000
MAP_HEADER_SIZE = 0x38
FLOOR_COUNT = 8


@dataclass(frozen=True)
class TowerDefinition:
    name: str
    stem: str

    @property
    def map_name(self) -> str:
        return f"maps/{self.stem}.map"


TOWERS = (
    TowerDefinition("THE KEEP", "mod0"),
    TowerDefinition("SERPENT TOWER", "serp"),
    TowerDefinition("MOON TOWER", "moon"),
    TowerDefinition("DRAGON TOWER", "drag"),
    TowerDefinition("CHAOS TOWER", "chaos"),
    TowerDefinition("ZENDIK'S TOWER", "zendik"),
)


@dataclass(frozen=True)
class MapCell:
    """One two-byte map location, exposed as the AMOS AA/BB/CC/DD nibbles."""

    first: int
    second: int

    def __post_init__(self) -> None:
        if not 0 <= self.first <= 0xFF or not 0 <= self.second <= 0xFF:
            raise ValueError("map-cell bytes must be between 0 and 255")

    @property
    def a(self) -> int:
        return self.first >> 4

    @property
    def b(self) -> int:
        return self.first & 0x0F

    @property
    def c(self) -> int:
        return self.second >> 4

    @property
    def d(self) -> int:
        return self.second & 0x0F

    @property
    def map_type(self) -> int:
        return self.second & 0x07

    def replace_nibble(self, name: str, value: int) -> MapCell:
        value &= 0x0F
        if name == "a":
            return MapCell((value << 4) | self.b, self.second)
        if name == "b":
            return MapCell((self.a << 4) | value, self.second)
        if name == "c":
            return MapCell(self.first, (value << 4) | self.d)
        if name == "d":
            return MapCell(self.first, (self.c << 4) | value)
        raise ValueError(f"unknown map-cell nibble '{name}'")

    def replace_type(self, map_type: int) -> MapCell:
        return MapCell(self.first, (self.second & 0xF8) | (map_type & 0x07))


class TowerMap:
    """A byte-exact `$1000` tower map resource."""

    def __init__(self, data: bytes, *, name: str = "") -> None:
        if len(data) != MAP_RESOURCE_SIZE:
            raise ValueError(
                f"{name or 'map'} must be {MAP_RESOURCE_SIZE} bytes, got {len(data)}"
            )
        self.name = name
        self.data = bytearray(data)

    @property
    def widths(self) -> tuple[int, ...]:
        return tuple(self.data[0:8])

    @property
    def heights(self) -> tuple[int, ...]:
        return tuple(self.data[8:16])

    @property
    def data_offsets(self) -> tuple[int, ...]:
        return tuple(
            int.from_bytes(self.data[16 + index * 2 : 18 + index * 2], "big")
            for index in range(FLOOR_COUNT)
        )

    @property
    def x_offsets(self) -> tuple[int, ...]:
        return tuple(self.data[0x20:0x28])

    @property
    def y_offsets(self) -> tuple[int, ...]:
        return tuple(self.data[0x28:0x30])

    @property
    def special_floor(self) -> tuple[int, int, int]:
        return tuple(
            int.from_bytes(self.data[offset : offset + 2], "big")
            for offset in (0x30, 0x32, 0x34)
        )  # type: ignore[return-value]

    @property
    def top_floor(self) -> int:
        return int.from_bytes(self.data[0x36:0x38], "big")

    @property
    def used_map_bytes(self) -> int:
        return sum(
            width * height * 2
            for width, height in zip(self.widths, self.heights)
        )

    @property
    def free_map_bytes(self) -> int:
        return MAP_RESOURCE_SIZE - MAP_HEADER_SIZE - self.used_map_bytes

    def floor_exists(self, floor: int) -> bool:
        self._validate_floor(floor)
        return self.widths[floor] > 0 and self.heights[floor] > 0

    def cell_offset(self, floor: int, x: int, y: int) -> int:
        self._validate_floor(floor)
        width, height = self.widths[floor], self.heights[floor]
        if not 0 <= x < width or not 0 <= y < height:
            raise IndexError(
                f"cell ({x}, {y}) is outside floor {floor} ({width} x {height})"
            )
        offset = MAP_HEADER_SIZE + self.data_offsets[floor] + ((y * width + x) * 2)
        if offset + 2 > MAP_RESOURCE_SIZE:
            raise ValueError(f"floor {floor} cell data extends beyond the map resource")
        return offset

    def cell(self, floor: int, x: int, y: int) -> MapCell:
        offset = self.cell_offset(floor, x, y)
        return MapCell(self.data[offset], self.data[offset + 1])

    def set_cell(self, floor: int, x: int, y: int, cell: MapCell) -> None:
        offset = self.cell_offset(floor, x, y)
        self.data[offset : offset + 2] = bytes((cell.first, cell.second))

    def floor_from_map_index(self, map_index: int) -> tuple[int, int, int] | None:
        """Convert the 12-bit object-stack index into floor/x/y coordinates."""

        for floor, (offset, width, height) in enumerate(
            zip(self.data_offsets, self.widths, self.heights)
        ):
            start = offset // 2
            end = start + width * height
            if width and height and start <= map_index < end:
                relative = map_index - start
                return floor, relative % width, relative // width
        return None

    def to_bytes(self) -> bytes:
        return bytes(self.data)

    @staticmethod
    def _validate_floor(floor: int) -> None:
        if not 0 <= floor < FLOOR_COUNT:
            raise IndexError(f"floor must be between 0 and {FLOOR_COUNT - 1}")


@dataclass(frozen=True)
class SwitchRecord:
    reference: int
    action: int
    x: int
    y: int


@dataclass(frozen=True)
class TriggerRecord:
    reference: int
    action: int
    floor: int
    x: int
    y: int


@dataclass(frozen=True)
class MonsterRecord:
    index: int
    category: int
    floor: int
    x: int
    y: int
    level: int
    form: int
    team: int


@dataclass(frozen=True)
class ObjectStack:
    position: int
    map_index: int
    items: tuple[tuple[int, int], ...]


class MapProject:
    """Editable maps sourced from extracted files or a WHDLoad save overlay."""

    def __init__(
        self,
        clean_root: Path,
        modified_root: Path,
        maps: Iterable[TowerMap],
        *,
        segment_offsets: dict[str, tuple[int, int]] | None = None,
        save_data: bytes | None = None,
        save_base_offset: int | None = None,
        save_name: str | None = None,
    ) -> None:
        self.clean_root = clean_root
        self.modified_root = modified_root
        self.maps = list(maps)
        if len(self.maps) != len(TOWERS):
            raise ValueError(f"expected {len(TOWERS)} tower maps")
        self.segment_offsets = segment_offsets or {}
        self.save_data = bytearray(save_data) if save_data is not None else None
        self.save_base_offset = save_base_offset
        self.save_name = save_name
        self.dirty_towers: set[int] = set()
        self.resource_data: dict[str, bytearray] = {}
        self.dirty_resources: set[str] = set()

    @classmethod
    def from_extracted(cls, data_root: Path) -> MapProject:
        clean_root, modified_root, _ = related_data_roots(Path(data_root))
        maps = []
        for tower in TOWERS:
            clean_path = clean_root / tower.map_name
            modified_path = modified_root / tower.map_name
            source = modified_path if modified_path.is_file() else clean_path
            if not source.is_file():
                raise FileNotFoundError(f"map resource not found: {source}")
            maps.append(TowerMap(source.read_bytes(), name=tower.name))
        return cls(clean_root, modified_root, maps)

    @classmethod
    def from_savegame(
        cls,
        data_root: Path,
        save_path: Path,
        *,
        master: str = "BLOODWYCH439",
        sheet: Path = DEFAULT_SEGMENTS_FILE,
    ) -> MapProject:
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
        save_base = stats[0]
        save_bytes = Path(save_path).read_bytes()
        maps = []
        for tower in TOWERS:
            segment = segment_offsets.get(tower.map_name)
            if segment is None:
                raise ValueError(f"segments.xlsx has no {tower.map_name} resource")
            start = segment[0] - save_base
            end = start + segment[1]
            if start < 0 or end > len(save_bytes):
                raise ValueError(
                    f"save file does not contain the complete {tower.map_name} resource"
                )
            maps.append(TowerMap(save_bytes[start:end], name=tower.name))
        return cls(
            clean_root,
            modified_root,
            maps,
            segment_offsets=segment_offsets,
            save_data=save_bytes,
            save_base_offset=save_base,
            save_name=Path(save_path).name,
        )

    @property
    def source_description(self) -> str:
        return self.save_name.upper() if self.save_name else "GAME MAPS"

    def set_cell(self, tower: int, floor: int, x: int, y: int, cell: MapCell) -> None:
        self.maps[tower].set_cell(floor, x, y, cell)
        self.dirty_towers.add(tower)

    def resource_bytes(self, relative_name: str) -> bytes:
        if relative_name in self.resource_data:
            return bytes(self.resource_data[relative_name])
        if self.save_data is not None and self.save_base_offset is not None:
            segment = self.segment_offsets.get(relative_name)
            if segment is not None:
                start = segment[0] - self.save_base_offset
                end = start + segment[1]
                if 0 <= start < end <= len(self.save_data):
                    return bytes(self.save_data[start:end])
        modified_path = self.modified_root / relative_name
        clean_path = self.clean_root / relative_name
        source = modified_path if modified_path.is_file() else clean_path
        return source.read_bytes()

    @property
    def has_changes(self) -> bool:
        return bool(self.dirty_towers or self.dirty_resources)

    def editable_resource(self, relative_name: str) -> bytearray:
        if self.save_data is not None:
            raise ValueError("shared game tables cannot be edited in a save overlay")
        return self.resource_data.setdefault(relative_name, bytearray(self.resource_bytes(relative_name)))

    def save(self) -> tuple[Path, ...]:
        if not self.has_changes:
            return ()
        if self.save_data is not None:
            return (self._save_savegame(),)

        written = []
        for tower_index in sorted(self.dirty_towers):
            destination = self.modified_root / TOWERS[tower_index].map_name
            destination.parent.mkdir(parents=True, exist_ok=True)
            destination.write_bytes(self.maps[tower_index].to_bytes())
            written.append(destination)
        for relative_name in sorted(self.dirty_resources):
            destination = self.modified_root / relative_name
            destination.parent.mkdir(parents=True, exist_ok=True)
            destination.write_bytes(self.resource_data[relative_name])
            written.append(destination)
        self.dirty_towers.clear()
        self.dirty_resources.clear()
        return tuple(written)

    def _save_savegame(self) -> Path:
        assert self.save_data is not None
        assert self.save_base_offset is not None
        assert self.save_name is not None
        for tower_index in self.dirty_towers:
            name = TOWERS[tower_index].map_name
            offset, size = self.segment_offsets[name]
            start = offset - self.save_base_offset
            self.save_data[start : start + size] = self.maps[tower_index].to_bytes()
        destination = self.modified_root / "whdload" / self.save_name
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_bytes(self.save_data)
        self.dirty_towers.clear()
        return destination

    def switches(self, tower: int) -> tuple[SwitchRecord, ...]:
        data = self.resource_bytes(f"maps/{TOWERS[tower].stem}.switches")
        return tuple(
            SwitchRecord(index, data[index * 4], data[index * 4 + 2], data[index * 4 + 3])
            for index in range(len(data) // 4)
        )

    def set_switch(
        self,
        tower: int,
        reference: int,
        *,
        action: int | None = None,
        x: int | None = None,
        y: int | None = None,
    ) -> SwitchRecord:
        name = f"maps/{TOWERS[tower].stem}.switches"
        data = self.editable_resource(name)
        offset = reference * 4
        if not 0 <= offset <= len(data) - 4:
            raise IndexError("switch reference is outside the tower switch table")
        if action is not None:
            data[offset] = action & 0xFF
        if x is not None:
            data[offset + 2] = x & 0xFF
        if y is not None:
            data[offset + 3] = y & 0xFF
        self.dirty_resources.add(name)
        return SwitchRecord(reference, data[offset], data[offset + 2], data[offset + 3])

    def triggers(self, tower: int) -> tuple[TriggerRecord, ...]:
        data = self.resource_bytes(f"maps/{TOWERS[tower].stem}.triggers")
        return tuple(
            TriggerRecord(
                index,
                data[index * 4],
                data[index * 4 + 1],
                data[index * 4 + 2],
                data[index * 4 + 3],
            )
            for index in range(len(data) // 4)
        )

    def set_trigger(
        self,
        tower: int,
        reference: int,
        *,
        action: int | None = None,
        floor: int | None = None,
        x: int | None = None,
        y: int | None = None,
    ) -> TriggerRecord:
        name = f"maps/{TOWERS[tower].stem}.triggers"
        data = self.editable_resource(name)
        offset = reference * 4
        if not 0 <= offset <= len(data) - 4:
            raise IndexError("trigger reference is outside the tower trigger table")
        values = (action, floor, x, y)
        for index, value in enumerate(values):
            if value is not None:
                data[offset + index] = value & 0xFF
        self.dirty_resources.add(name)
        return TriggerRecord(reference, data[offset], data[offset + 1], data[offset + 2], data[offset + 3])

    def monsters(self, tower: int) -> tuple[MonsterRecord, ...]:
        data = self.resource_bytes(f"maps/{TOWERS[tower].stem}.monsters")
        count_data = self.resource_bytes(f"maps/{TOWERS[tower].stem}.monstercount")
        count = min(int.from_bytes(count_data[:2], "big"), len(data) // 6)
        return tuple(
            MonsterRecord(
                index,
                data[index * 6] >> 4,
                data[index * 6] & 0x0F,
                data[index * 6 + 1],
                data[index * 6 + 2],
                data[index * 6 + 3],
                data[index * 6 + 4],
                data[index * 6 + 5],
            )
            for index in range(count)
        )

    def object_stacks(self, tower: int) -> tuple[ObjectStack, ...]:
        data = self.resource_bytes(f"maps/{TOWERS[tower].stem}.obj")
        if len(data) < 2:
            return ()
        used = min(int.from_bytes(data[:2], "big"), len(data) - 2)
        cursor, end = 2, 2 + used
        stacks = []
        while cursor + 5 <= end:
            location = int.from_bytes(data[cursor : cursor + 2], "big")
            item_count = data[cursor + 2] + 1
            record_end = cursor + 3 + item_count * 2
            if record_end > end:
                break
            items = tuple(
                (data[cursor + 3 + item * 2], data[cursor + 4 + item * 2])
                for item in range(item_count)
            )
            stacks.append(ObjectStack(location >> 12, location & 0x0FFF, items))
            cursor = record_end
        return tuple(stacks)
