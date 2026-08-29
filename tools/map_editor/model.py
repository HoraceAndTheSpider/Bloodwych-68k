"""Binary models shared by the Bloodwych map viewer and editors."""

from __future__ import annotations

from dataclasses import dataclass, replace
from pathlib import Path
from typing import Iterable, Sequence

from tools.data_overlay import related_data_roots
from tools.savegame_overlay import load_savegame_overlay
from tools.tool_common import DEFAULT_SEGMENTS_FILE


MAP_RESOURCE_SIZE = 0x1000
MAP_HEADER_SIZE = 0x38
FLOOR_COUNT = 8

# These offsets are relative to the start of an SPS 439 WHDLoad save, whose
# first byte is ``data/champions.stats``.  They are runtime state, rather than
# extracted resources, and are documented by the AMOS editor and Wiki.
SAVE_CURRENT_TOWER_OFFSET = 0x305
SAVE_PLAYER_MODE_OFFSET = 0x306
SAVE_PLAYER_ONE_POSITION_OFFSET = 0x36E
SAVE_PLAYER_ONE_DIRECTION_OFFSET = 0x373
SAVE_PLAYER_ONE_FLOOR_OFFSET = 0x3AA
SAVE_PLAYER_TWO_POSITION_OFFSET = 0x3D0
SAVE_PLAYER_TWO_DIRECTION_OFFSET = 0x3D5
SAVE_PLAYER_TWO_FLOOR_OFFSET = 0x40C
# ``Player1_Data+$26`` and ``Player2_Data+$26``.  These are four champion
# IDs, not pointers: the renderer indexes them directly when drawing a party.
SAVE_PLAYER_ONE_TEAM_OFFSET = 0x378
SAVE_PLAYER_TWO_TEAM_OFFSET = 0x3DA
SAVE_UNPACKED_MONSTER_COUNT_OFFSET = 0x8052
SAVE_UNPACKED_MONSTERS_OFFSET = 0x8054
LIVE_MONSTER_RECORD_SIZE = 0x10
LIVE_MONSTER_CAPACITY = 0x80
CHAMPION_RECORD_SIZE = 0x20
CHAMPION_POCKET_RECORD_SIZE = 0x10
# The portable save begins at Character_Stats_DataTable ($EB2A).  The source
# reaches Spells_Practiced_DataTable ($1694C) with the same $7E22 displacement
# used by Calculate_SpellCastingQuality.
SAVE_SPELL_PRACTICE_OFFSET = 0x7E22
SPELL_PRACTICE_CHAMPION_SIZE = 0x20
LARGE_MONSTER_GRADE_BASES = {
    0x64: 2,  # summon
    0x65: 2,  # illusion summon
    0x66: 4,  # beholder
    0x67: 6,  # behemoth
    0x68: 2,  # crab
    0x69: 9,  # large dragon
    0x6A: 3,  # little dragon
}

# QkPly1_Start and QkPly2_Start set these teams and their lead champion's
# location. The standard character data supplies their unchanged floor 3.
QUICKSTART_TOWER = 0
QUICKSTART_FLOOR = 3
QUICKSTART_PARTIES = (
    ((0, 14, 5, 3), 12, 23),
    ((4, 6, 13, 15), 14, 23),
)


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


def resolve_contiguous_reference(
    tower: int,
    reference: int,
    table_lengths: Iterable[int],
) -> tuple[int, int] | None:
    """Resolve an overflowing index into the following contiguous tower table.

    Bloodwych's switch tables are adjacent in the executable.  A map cell in
    towers 0--4 can therefore deliberately use switch references 16--31 to
    address entries 0--15 of the following tower.  The last tower cannot
    safely overflow because the following bytes are not another switch table.
    """

    lengths = tuple(table_lengths)
    if not 0 <= tower < len(lengths) or reference < 0:
        return None
    resolved_tower = tower
    resolved_reference = reference
    while resolved_tower < len(lengths):
        length = lengths[resolved_tower]
        if resolved_reference < length:
            return resolved_tower, resolved_reference
        resolved_reference -= length
        resolved_tower += 1
    return None


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
    def special_floor_index(self) -> int | None:
        """Return the floor duplicated by the AMOS special-floor triplet.

        Header words $30/$32/$34 duplicate width, height and data offset.
        Every original SPS 439 map matches one of its eight floor records.
        The 68000 loader copies the whole header, but only the first two words
        initially occupy live geometry fields; the $34 word has no exact
        SPS 439 instruction reference and floor selection loads its active
        offset separately.
        """

        special = self.special_floor
        return next(
            (
                floor
                for floor in range(FLOOR_COUNT)
                if (
                    self.widths[floor],
                    self.heights[floor],
                    self.data_offsets[floor],
                )
                == special
            ),
            None,
        )

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
        width, height = self.widths[floor], self.heights[floor]
        if not width or not height:
            return False
        end = MAP_HEADER_SIZE + self.data_offsets[floor] + width * height * 2
        return end <= MAP_RESOURCE_SIZE

    def has_valid_layout(self) -> bool:
        """Return whether every populated floor fits within this map resource."""

        return all(
            not self.widths[floor] or not self.heights[floor] or self.floor_exists(floor)
            for floor in range(FLOOR_COUNT)
        )

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

    def set_floor_dimensions(self, floor: int, width: int, height: int) -> None:
        """Resize one floor and safely repack all eight sequential cell grids.

        Cells which remain inside a floor retain their X/Y coordinates.  New
        cells are cleared, later floors move to their recalculated offsets,
        and bytes outside the newly used map span remain untouched.
        """

        self._validate_floor(floor)
        if not 0 <= width <= 31 or not 0 <= height <= 31:
            raise ValueError("floor width and height must be between 0 and 31")
        old_widths = self.widths
        old_heights = self.heights
        old_offsets = self.data_offsets
        old_special_floor = self.special_floor_index
        widths = list(old_widths)
        heights = list(old_heights)
        widths[floor] = width
        heights[floor] = height
        used = sum(w * h * 2 for w, h in zip(widths, heights))
        if used > MAP_RESOURCE_SIZE - MAP_HEADER_SIZE:
            raise ValueError(
                f"map needs ${used:03X} cell bytes; fixed resource holds "
                f"${MAP_RESOURCE_SIZE - MAP_HEADER_SIZE:03X}"
            )

        old_cells: list[list[list[bytes]]] = []
        for old_floor, (old_width, old_height, old_offset) in enumerate(
            zip(old_widths, old_heights, old_offsets)
        ):
            rows = []
            for y in range(old_height):
                row = []
                for x in range(old_width):
                    start = MAP_HEADER_SIZE + old_offset + (y * old_width + x) * 2
                    row.append(bytes(self.data[start : start + 2]))
                rows.append(row)
            old_cells.append(rows)

        offsets = []
        cursor = 0
        for floor_width, floor_height in zip(widths, heights):
            offsets.append(cursor)
            cursor += floor_width * floor_height * 2

        replacement = bytearray(self.data)
        replacement[0:8] = bytes(widths)
        replacement[8:16] = bytes(heights)
        replacement[0x20 + floor] = min(self.x_offsets[floor], 31 - width)
        replacement[0x28 + floor] = min(self.y_offsets[floor], 31 - height)
        for index, offset in enumerate(offsets):
            replacement[16 + index * 2 : 18 + index * 2] = offset.to_bytes(2, "big")
        for new_floor, (new_width, new_height, new_offset) in enumerate(
            zip(widths, heights, offsets)
        ):
            for y in range(new_height):
                for x in range(new_width):
                    value = (
                        old_cells[new_floor][y][x]
                        if y < old_heights[new_floor] and x < old_widths[new_floor]
                        else b"\0\0"
                    )
                    start = MAP_HEADER_SIZE + new_offset + (y * new_width + x) * 2
                    replacement[start : start + 2] = value

        self.data = replacement
        if old_special_floor is not None:
            self.set_special_floor(old_special_floor)

    def set_floor_alignment(self, floor: int, x_offset: int, y_offset: int) -> None:
        self._validate_floor(floor)
        if not 0 <= x_offset <= 31 - self.widths[floor]:
            raise ValueError("floor X offset places its width beyond cell 31")
        if not 0 <= y_offset <= 31 - self.heights[floor]:
            raise ValueError("floor Y offset places its height beyond cell 31")
        self.data[0x20 + floor] = x_offset
        self.data[0x28 + floor] = y_offset

    def set_special_floor(self, floor: int) -> None:
        self._validate_floor(floor)
        values = (
            self.widths[floor],
            self.heights[floor],
            self.data_offsets[floor],
        )
        for offset, value in zip((0x30, 0x32, 0x34), values):
            self.data[offset : offset + 2] = value.to_bytes(2, "big")

    def set_top_floor(self, floor: int) -> None:
        self._validate_floor(floor)
        self.data[0x36:0x38] = floor.to_bytes(2, "big")

    def floor_from_map_index(self, map_index: int) -> tuple[int, int, int] | None:
        """Convert an object stack's map-data byte offset into floor/X/Y.

        Object records retain the byte offset used by the original map lookup:
        the relevant floor's ``data_offset`` plus two bytes per map cell.  It
        is not a sequential cell number, so offsets must not be halved until
        after the containing floor has been located.
        """

        for floor, (offset, width, height) in enumerate(
            zip(self.data_offsets, self.widths, self.heights)
        ):
            start = offset
            end = start + width * height * 2
            if width and height and start <= map_index < end:
                relative_bytes = map_index - start
                if relative_bytes & 1:
                    return None
                relative = relative_bytes // 2
                return floor, relative % width, relative // width
        return None

    def map_index(self, floor: int, x: int, y: int) -> int:
        """Return the packed object-location byte offset for one map cell."""

        self.cell_offset(floor, x, y)
        return self.data_offsets[floor] + (y * self.widths[floor] + x) * 2

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
    source: str = "packed"
    facing: int = 0
    has_position: bool = True
    formation_slot: int | None = None
    formation_facing: int = 0

    @property
    def is_spell(self) -> bool:
        """Whether the record is one of the airborne-spell forms."""

        return self.form >= 0x80

    @property
    def is_illusion(self) -> bool:
        """Whether a summon uses the source's negative-level illusion ink."""

        return self.form in {0x64, 0x65} and bool(self.level & 0x80)

    @property
    def colour_grade_step(self) -> int:
        """Convert the actor's absolute grade to its renderer palette row.

        Each large-creature renderer subtracts a different base grade before
        indexing its colour table.  The live record's byte $06 is the value
        used by ``MonsterColourGrading``; packed records retain the same byte
        at offset $03 after unpacking.
        """

        return max(0, (self.level & 0x7F) - self.colour_grade_base)

    @property
    def colour_grade_base(self) -> int:
        """Return the renderer's source-derived minimum absolute grade."""

        return LARGE_MONSTER_GRADE_BASES.get(self.form, 0)


@dataclass(frozen=True)
class ChampionMapRecord:
    """A champion position and decoded render state for the map viewer."""

    index: int
    floor: int
    x: int
    y: int
    facing: int
    formation_slot: int


@dataclass(frozen=True)
class PlayerMapRecord:
    """One player-party map position from a WHDLoad savegame."""

    index: int
    floor: int
    x: int
    y: int


@dataclass(frozen=True)
class PlayerPartyMapRecord:
    """A player marker and the champion IDs rendered at that map location."""

    index: int
    floor: int
    x: int
    y: int
    champions: tuple[int, ...]
    source: str
    facing: int


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
        save_map_fallbacks: Iterable[int] = (),
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
        self.save_map_fallbacks = frozenset(save_map_fallbacks)
        self.dirty_towers: set[int] = set()
        self.resource_data: dict[str, bytearray] = {}
        self.dirty_resources: set[str] = set()
        self.dirty_save = False

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
        clean_root, modified_root, save_bytes, segment_offsets, save_base = load_savegame_overlay(
            data_root, save_path, master=master, sheet=sheet
        )
        maps = []
        save_map_fallbacks = []
        for tower_index, tower in enumerate(TOWERS):
            segment = segment_offsets.get(tower.map_name)
            if segment is None:
                raise ValueError(f"segments.xlsx has no {tower.map_name} resource")
            start = segment[0] - save_base
            end = start + segment[1]
            if start < 0 or end > len(save_bytes):
                raise ValueError(
                    f"save file does not contain the complete {tower.map_name} resource"
                )
            saved_map = TowerMap(save_bytes[start:end], name=tower.name)
            if saved_map.has_valid_layout():
                maps.append(saved_map)
                continue
            clean_path = clean_root / tower.map_name
            maps.append(TowerMap(clean_path.read_bytes(), name=tower.name))
            save_map_fallbacks.append(tower_index)
        return cls(
            clean_root,
            modified_root,
            maps,
            segment_offsets=segment_offsets,
            save_data=save_bytes,
            save_base_offset=save_base,
            save_name=Path(save_path).name,
            save_map_fallbacks=save_map_fallbacks,
        )

    @property
    def source_description(self) -> str:
        if self.save_name is None:
            return "GAME MAPS"
        if not self.save_map_fallbacks:
            return self.save_name.upper()
        names = ", ".join(TOWERS[index].name for index in self.save_map_fallbacks)
        return f"{self.save_name.upper()} + CLEAN {names}"

    def set_cell(self, tower: int, floor: int, x: int, y: int, cell: MapCell) -> None:
        if tower in self.save_map_fallbacks:
            raise ValueError(
                f"{TOWERS[tower].name} is not stored as a valid map in this save and cannot be edited"
            )
        self.maps[tower].set_cell(floor, x, y, cell)
        self.dirty_towers.add(tower)

    def set_floor_dimensions(
        self, tower: int, floor: int, width: int, height: int
    ) -> None:
        """Resize a floor while retaining cells and object-stack locations."""

        if tower in self.save_map_fallbacks:
            raise ValueError(
                f"{TOWERS[tower].name} is not stored as a valid map in this save and cannot be edited"
            )
        tower_map = self.maps[tower]
        if (width, height) == (tower_map.widths[floor], tower_map.heights[floor]):
            return
        stacks = self.object_stacks(tower)
        locations = tuple(tower_map.floor_from_map_index(stack.map_index) for stack in stacks)
        cropped = next(
            (
                location
                for location in locations
                if location is not None
                and location[0] == floor
                and (location[1] >= width or location[2] >= height)
            ),
            None,
        )
        if cropped is not None:
            _, x, y = cropped
            raise ValueError(
                f"resize would exclude an object stack at floor {floor}, X {x}, Y {y}"
            )

        # A layout change moves the sequential byte offsets of later floors.
        # Ensure the companion object resource can follow those moves before
        # mutating either in-memory resource.
        name = f"maps/{TOWERS[tower].stem}.obj"
        if any(location is not None for location in locations):
            if not self.resource_is_editable(name):
                raise ValueError(
                    "resizing this floor would move read-only object locations"
                )

        tower_map.set_floor_dimensions(floor, width, height)
        moved = tuple(
            replace(
                stack,
                map_index=tower_map.map_index(*location),
            )
            if location is not None
            else stack
            for stack, location in zip(stacks, locations)
        )
        if moved != stacks:
            self.set_object_stacks(tower, moved)
        self.dirty_towers.add(tower)

    def set_floor_alignment(
        self, tower: int, floor: int, x_offset: int, y_offset: int
    ) -> None:
        if tower in self.save_map_fallbacks:
            raise ValueError(
                f"{TOWERS[tower].name} is not stored as a valid map in this save and cannot be edited"
            )
        self.maps[tower].set_floor_alignment(floor, x_offset, y_offset)
        self.dirty_towers.add(tower)

    def set_special_floor(self, tower: int, floor: int) -> None:
        if tower in self.save_map_fallbacks:
            raise ValueError(
                f"{TOWERS[tower].name} is not stored as a valid map in this save and cannot be edited"
            )
        self.maps[tower].set_special_floor(floor)
        self.dirty_towers.add(tower)

    def set_top_floor(self, tower: int, floor: int) -> None:
        if tower in self.save_map_fallbacks:
            raise ValueError(
                f"{TOWERS[tower].name} is not stored as a valid map in this save and cannot be edited"
            )
        self.maps[tower].set_top_floor(floor)
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
        return bool(self.dirty_towers or self.dirty_resources or self.dirty_save)

    def editable_resource(self, relative_name: str) -> bytearray:
        if self.save_data is not None:
            if not self.resource_is_editable(relative_name):
                raise ValueError(f"{relative_name} is outside the save overlay and cannot be edited")
        return self.resource_data.setdefault(relative_name, bytearray(self.resource_bytes(relative_name)))

    def resource_is_editable(self, relative_name: str) -> bool:
        """Return whether a resource can be written to this project target."""

        if self.save_data is None:
            return True
        if self.save_base_offset is None:
            return False
        segment = self.segment_offsets.get(relative_name)
        if segment is None:
            return False
        start = segment[0] - self.save_base_offset
        return 0 <= start and start + segment[1] <= len(self.save_data)

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
        for relative_name in self.dirty_resources:
            offset, size = self.segment_offsets[relative_name]
            start = offset - self.save_base_offset
            data = self.resource_data[relative_name]
            if len(data) != size:
                raise ValueError(
                    f"{relative_name} changed size inside a fixed-size save segment"
                )
            self.save_data[start : start + size] = data
        destination = self.modified_root / "whdload" / self.save_name
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_bytes(self.save_data)
        self.dirty_towers.clear()
        self.dirty_resources.clear()
        self.dirty_save = False
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
        """Return the selected tower's persistent six-byte monster records."""

        data = self.resource_bytes(f"maps/{TOWERS[tower].stem}.monsters")
        count_data = self.resource_bytes(f"maps/{TOWERS[tower].stem}.monstercount")
        last_index = int.from_bytes(count_data[:2], "big")
        count = (
            0
            if last_index == 0xFFFF
            else min(last_index + 1, len(data) // 6)
        )
        return tuple(
            MonsterRecord(
                index,
                data[index * 6] >> 4,
                (data[index * 6] & 0x0F) - 1,
                data[index * 6 + 1] & 0x7F,
                data[index * 6 + 2],
                data[index * 6 + 3],
                data[index * 6 + 4],
                data[index * 6 + 5],
                has_position=data[index * 6 + 1] != 0xFF,
            )
            for index in range(count)
        )

    def packed_monster_editable(self, tower: int) -> bool:
        """Packed actors are editable except where live save state supersedes them."""

        return self.current_tower != tower

    def set_packed_monster(
        self,
        tower: int,
        index: int,
        *,
        category: int | None = None,
        floor: int | None = None,
        x: int | None = None,
        y: int | None = None,
        level: int | None = None,
        form: int | None = None,
        team: int | None = None,
    ) -> MonsterRecord:
        """Edit fields in one persistent six-byte monster record."""

        if not self.packed_monster_editable(tower):
            raise ValueError("the active save tower uses read-only live monster data")
        if not 0 <= index < len(self.monsters(tower)):
            raise IndexError("monster index is outside the authored tower records")
        name = f"maps/{TOWERS[tower].stem}.monsters"
        if self.save_data is None:
            data = self.editable_resource(name)
            save_start = None
        else:
            segment = self.segment_offsets.get(name)
            if segment is None or self.save_base_offset is None:
                raise ValueError(f"the save has no {name} segment")
            save_start = segment[0] - self.save_base_offset
            data = self.save_data
        offset = (save_start or 0) + index * 6
        if not 0 <= offset <= len(data) - 6:
            raise IndexError("monster index is outside the tower block")
        if category is not None or floor is not None:
            old = data[offset]
            packed_category = old >> 4 if category is None else category
            packed_floor = (old & 0x0F) - 1 if floor is None else floor
            if not 0 <= packed_category <= 0x0F or not 0 <= packed_floor <= 7:
                raise ValueError("monster category/floor is outside its packed range")
            data[offset] = (packed_category << 4) | (packed_floor + 1)
        for relative, value in ((1, x), (2, y), (3, level), (4, form), (5, team)):
            if value is not None:
                if not 0 <= value <= 0xFF:
                    raise ValueError("monster fields must be byte values")
                data[offset + relative] = value
        if self.save_data is None:
            self.dirty_resources.add(name)
        else:
            self.dirty_save = True
        return self.monsters(tower)[index]

    def _reorder_packed_monsters(
        self, tower: int, ordered_indices: Sequence[int]
    ) -> tuple[MonsterRecord, ...]:
        """Rewrite the active packed records in a validated source-index order."""

        records = self.monsters(tower)
        if sorted(ordered_indices) != list(range(len(records))):
            raise ValueError("monster reorder must include every packed record once")
        name = f"maps/{TOWERS[tower].stem}.monsters"
        if self.save_data is None:
            data = self.editable_resource(name)
            start = 0
        else:
            segment = self.segment_offsets.get(name)
            if segment is None or self.save_base_offset is None:
                raise ValueError(f"the save has no {name} segment")
            start = segment[0] - self.save_base_offset
            data = self.save_data
        chunks = [bytes(data[start + index * 6 : start + index * 6 + 6]) for index in range(len(records))]
        data[start : start + len(records) * 6] = b"".join(
            chunks[index] for index in ordered_indices
        )
        if self.save_data is None:
            self.dirty_resources.add(name)
        else:
            self.dirty_save = True
        return self.monsters(tower)

    def join_monster_to_previous_team(self, tower: int, index: int) -> tuple[MonsterRecord, ...]:
        """Author both packed ``KL`` entries needed to rebuild the runtime team."""

        if index <= 0:
            raise ValueError("a monster can only join a preceding record")
        return self.join_monster_to_team(tower, index, index - 1)

    def join_monster_to_team(
        self, tower: int, index: int, target_index: int
    ) -> tuple[MonsterRecord, ...]:
        """Join one packed monster to the target's reconstructed four-slot team."""

        from tools.map_editor.actor_editor import monster_teams

        records = self.monsters(tower)
        if not 0 <= index < len(records) or not 0 <= target_index < len(records):
            raise IndexError("monster index is outside the authored tower records")
        if index == target_index:
            raise ValueError("a monster cannot join itself")
        selected = records[index]
        target = records[target_index]
        if selected.form >= 0x67 or target.form >= 0x67:
            raise ValueError("large monster forms $67 and above cannot join parties")
        if selected.team != 0xFF:
            raise ValueError("remove the selected monster from its current party first")

        teams = {team.group: team for team in monster_teams(records)}
        if target.team == 0xFF:
            used_groups = set(teams)
            group = next(
                (candidate for candidate in range(25) if candidate not in used_groups),
                None,
            )
            if group is None:
                raise ValueError("the 25-group monster party table is full")
            slot = 1
            self.set_packed_monster(tower, target_index, team=group << 2)
        else:
            group = target.team >> 2
            team = teams.get(group)
            if team is None:
                raise ValueError("the target's packed party ID has no party-table entry")
            slot = next(
                (position for position, member in enumerate(team.members) if member is None),
                None,
            )
            if slot is None:
                raise ValueError("the target monster's party already has four members")

        resolved = self.render_occupants(tower)
        target_position = next(
            (record for record in resolved if record.index == target_index), None
        )
        if target_position is None or not target_position.has_position:
            raise ValueError("the target monster has no resolved map location")
        self.set_packed_monster(
            tower,
            index,
            floor=target_position.floor,
            x=0xFF,
            y=target_position.y,
            team=(group << 2) | slot,
        )
        joined = self.monsters(tower)
        joined_team = next(
            team for team in monster_teams(joined) if team.group == group
        )
        member_indices = tuple(
            member for member in joined_team.members if member is not None
        )
        # Runtime traversal reads the KL slots, but keeping the corresponding
        # packed records contiguous also matches the original editor's list
        # convention and prevents a newly joined member being stranded elsewhere.
        insertion_index = min(member_indices)
        remaining = [
            record_index
            for record_index in range(len(joined))
            if record_index not in member_indices
        ]
        insertion_position = sum(
            record_index < insertion_index for record_index in remaining
        )
        ordered_indices = (
            remaining[:insertion_position]
            + list(member_indices)
            + remaining[insertion_position:]
        )
        return self._reorder_packed_monsters(tower, ordered_indices)

    def remove_monster_from_team(self, tower: int, index: int) -> tuple[MonsterRecord, ...]:
        records = self.render_occupants(tower)
        if not 0 <= index < len(records):
            raise IndexError("monster index is outside the tower block")
        record = records[index]
        self.set_packed_monster(
            tower, index, floor=record.floor, x=record.x, y=record.y, team=0xFF
        )
        return self.monsters(tower)

    def champion_record_bytes(self, index: int) -> bytes:
        if not 0 <= index < 16:
            raise IndexError("champion index must be 0..15")
        data = self.save_data if self.save_data is not None else self.resource_bytes("data/champions.stats")
        start = index * CHAMPION_RECORD_SIZE
        return bytes(data[start : start + CHAMPION_RECORD_SIZE])

    def champion_pocket_bytes(self, index: int) -> bytes:
        if not 0 <= index < 16:
            raise IndexError("champion index must be 0..15")
        if self.save_data is not None:
            start = 0x200 + index * CHAMPION_POCKET_RECORD_SIZE
            data = self.save_data
        else:
            start = index * CHAMPION_POCKET_RECORD_SIZE
            data = self.resource_bytes("data/champions.pockets")
        return bytes(data[start : start + CHAMPION_POCKET_RECORD_SIZE])

    def set_champion_byte(self, tower: int, index: int, offset: int, value: int) -> None:
        """Edit champion state only in mod0 or the active save tower."""

        expected = self.current_tower if self.save_data is not None else 0
        if tower != expected:
            raise ValueError("champions are editable only on mod0 or the active save tower")
        if not 0 <= index < 16 or not 0 <= offset < CHAMPION_RECORD_SIZE:
            raise IndexError("champion record address is outside its table")
        if not 0 <= value <= 0xFF:
            raise ValueError("champion fields must be byte values")
        if self.save_data is not None:
            self.save_data[index * CHAMPION_RECORD_SIZE + offset] = value
            self.dirty_save = True
        else:
            data = self.editable_resource("data/champions.stats")
            data[index * CHAMPION_RECORD_SIZE + offset] = value
            self.dirty_resources.add("data/champions.stats")

    def set_champion_pocket_byte(self, tower: int, index: int, offset: int, value: int) -> None:
        expected = self.current_tower if self.save_data is not None else 0
        if tower != expected:
            raise ValueError("champions are editable only on mod0 or the active save tower")
        if not 0 <= index < 16 or not 0 <= offset < CHAMPION_POCKET_RECORD_SIZE:
            raise IndexError("champion pocket address is outside its table")
        if not 0 <= value <= 0xFF:
            raise ValueError("pocket fields must be byte values")
        if self.save_data is not None:
            self.save_data[0x200 + index * CHAMPION_POCKET_RECORD_SIZE + offset] = value
            self.dirty_save = True
        else:
            data = self.editable_resource("data/champions.pockets")
            data[index * CHAMPION_POCKET_RECORD_SIZE + offset] = value
            self.dirty_resources.add("data/champions.pockets")

    def spell_practice(self, champion: int, spell: int) -> int | None:
        """Return a save's runtime per-champion, per-spell practice byte."""

        if self.save_data is None:
            return None
        if not 0 <= champion < 16 or not 0 <= spell < 32:
            raise IndexError("spell practice requires champion 0..15 and spell 0..31")
        offset = SAVE_SPELL_PRACTICE_OFFSET + champion * SPELL_PRACTICE_CHAMPION_SIZE + spell
        if offset >= len(self.save_data):
            return None
        return self.save_data[offset]

    def set_spell_practice(
        self, tower: int, champion: int, spell: int, value: int
    ) -> None:
        """Edit runtime spell practice when viewing the save's active tower."""

        if self.save_data is None or tower != self.current_tower:
            raise ValueError("spell practice is editable only on the active save tower")
        if not 0 <= champion < 16 or not 0 <= spell < 32:
            raise IndexError("spell practice requires champion 0..15 and spell 0..31")
        if not 0 <= value <= 0xFF:
            raise ValueError("spell practice must be a byte value")
        offset = SAVE_SPELL_PRACTICE_OFFSET + champion * SPELL_PRACTICE_CHAMPION_SIZE + spell
        if offset >= len(self.save_data):
            raise ValueError("the selected save does not contain spell-practice data")
        self.save_data[offset] = value
        self.dirty_save = True

    def character_design(self, form: int) -> tuple[int, int, tuple[tuple[int, ...], ...]]:
        """Return source-extracted head, body and five four-ink palettes."""

        if not 0 <= form <= 0x55:
            raise ValueError("character form must be $00..$55")
        heads = self.resource_bytes("data/characters.heads")
        bodies = self.resource_bytes("data/characters.bodies")
        colours = self.resource_bytes("data/characters.colours")
        start = form * 20
        palettes = tuple(
            tuple(colours[start + group * 4 : start + group * 4 + 4])
            for group in range(5)
        )
        return heads[form], bodies[form], palettes

    def set_character_design(
        self,
        form: int,
        *,
        head: int | None = None,
        body: int | None = None,
        colour_group: int | None = None,
        colour_slot: int | None = None,
        ink: int | None = None,
    ) -> None:
        """Edit the shared character-form tables used by map and Data Viewer."""

        if self.save_data is not None:
            raise ValueError("shared character designs are not stored in a portable save")
        if not 0 <= form <= 0x55:
            raise ValueError("character form must be $00..$55")
        if head is not None:
            head_count = len(self.resource_bytes("gfx/HeadParts.gfx")) // 0x378
            if not 0 <= head < head_count:
                raise ValueError("head design references an unknown source definition")
            data = self.editable_resource("data/characters.heads")
            data[form] = head
            self.dirty_resources.add("data/characters.heads")
        if body is not None:
            body_count = len(self.resource_bytes("data/characters-body-definitions.layout")) // 10
            if not 0 <= body < body_count:
                raise ValueError("body design references an unknown source definition")
            data = self.editable_resource("data/characters.bodies")
            data[form] = body
            self.dirty_resources.add("data/characters.bodies")
        if ink is not None:
            if colour_group is None or colour_slot is None:
                raise ValueError("a colour edit requires a palette group and slot")
            if not 0 <= colour_group < 5 or not 0 <= colour_slot < 4 or not 0 <= ink < 16:
                raise ValueError("character colour address is outside its source table")
            data = self.editable_resource("data/characters.colours")
            data[form * 20 + colour_group * 4 + colour_slot] = ink
            self.dirty_resources.add("data/characters.colours")
    @property
    def current_tower(self) -> int | None:
        """Return the savegame's current tower, when this is a valid SPS 439 save."""

        if self.save_data is None or len(self.save_data) <= SAVE_CURRENT_TOWER_OFFSET:
            return None
        tower = self.save_data[SAVE_CURRENT_TOWER_OFFSET]
        return tower if 0 <= tower < len(TOWERS) else None

    def live_monsters(self) -> tuple[MonsterRecord, ...]:
        """Decode the current tower's 16-byte live actor workspace from a save.

        The workspace contains both monster forms and airborne spell forms.
        Its count word is authoritative; the allocated 128-record capacity is
        only a hard safety ceiling.
        """

        if self.save_data is None:
            return ()
        count_end = SAVE_UNPACKED_MONSTER_COUNT_OFFSET + 2
        if count_end > len(self.save_data):
            return ()
        available = max(0, (len(self.save_data) - SAVE_UNPACKED_MONSTERS_OFFSET) // LIVE_MONSTER_RECORD_SIZE)
        last_index = int.from_bytes(
            self.save_data[SAVE_UNPACKED_MONSTER_COUNT_OFFSET:count_end], "big"
        )
        count = (
            0
            if last_index == 0xFFFF
            else min(last_index + 1, LIVE_MONSTER_CAPACITY, available)
        )
        records = []
        for index in range(count):
            offset = SAVE_UNPACKED_MONSTERS_OFFSET + index * LIVE_MONSTER_RECORD_SIZE
            x = self.save_data[offset]
            records.append(
                MonsterRecord(
                    index=index,
                    category=self.save_data[offset + 0x0A],
                    floor=self.save_data[offset + 0x04],
                    x=x & 0x7F,
                    y=self.save_data[offset + 0x01],
                    # MonsterColourGrading reads this live byte directly.
                    # +$07 is the base grade and would make each renderer
                    # select palettes too high.
                    level=self.save_data[offset + 0x06],
                    form=self.save_data[offset + 0x0B],
                    team=self.save_data[offset + 0x0D],
                    source="live",
                    # The low two bits select artwork direction. Bits 4-5
                    # select a stable floor mini-space, which the renderer
                    # rotates relative to the viewer.
                    facing=self.save_data[offset + 0x02],
                    has_position=x != 0xFF,
                )
            )
        return tuple(records)

    def occupants(self, tower: int) -> tuple[MonsterRecord, ...]:
        """Use live state only for the tower active in the selected save.

        This is the same packed/live choice made by the original AMOS editor:
        other towers retain their persistent packed state while the active
        tower reads the runtime workspace saved by WHDLoad.
        """

        if self.current_tower == tower:
            return self.live_monsters()
        return self.monsters(tower)

    def render_occupants(self, tower: int) -> tuple[MonsterRecord, ...]:
        """Resolve no-position team members for the dungeon actor renderer.

        AMOS map markers intentionally omit packed records whose X byte is
        ``$FF``.  In the game, though, ``Draw_DungeonCellOccupants`` finds a
        positioned team lead and expands the group through
        ``MonsterTeamIndexTable``.  The second through fourth records share
        that lead's location and must be supplied to the 3D compositor.
        """

        records = self.occupants(tower)
        if self.current_tower == tower:
            return self._resolve_live_team_positions(records)
        return self._resolve_packed_team_positions(records)

    @staticmethod
    def _at_team_position(
        record: MonsterRecord,
        leader: MonsterRecord,
    ) -> MonsterRecord:
        return replace(
            record,
            floor=leader.floor,
            x=leader.x,
            y=leader.y,
            has_position=True,
            formation_facing=leader.facing & 0x03,
        )

    def _resolve_packed_team_positions(
        self,
        records: tuple[MonsterRecord, ...],
    ) -> tuple[MonsterRecord, ...]:
        """Expand packed ``KL`` groups, whose low bits are member slots."""

        leaders = {
            record.team >> 2: record
            for record in records
            if record.team != 0xFF and record.has_position
        }
        return tuple(
            replace(
                self._at_team_position(record, leaders[record.team >> 2])
                if not record.has_position
                else record,
                # KL's low two bits are the authored, stable team-member
                # slots. Keep them separate from live byte $02, whose low
                # bits select artwork direction.
                formation_slot=record.team & 0x03,
                formation_facing=leaders[record.team >> 2].facing & 0x03,
            )
            if record.team != 0xFF and record.team >> 2 in leaders
            else record
            for record in records
        )

    def _resolve_live_team_positions(
        self,
        records: tuple[MonsterRecord, ...],
    ) -> tuple[MonsterRecord, ...]:
        """Expand the compacted save representation of adjacent team records.

        Live byte ``$0D`` retains the group only on the positioned lead; the
        later members keep the ``$FF`` X sentinel.  The pack/unpack sequence
        retains those members immediately after their lead, with the shared
        floor/Y values, so this is the faithful save-side equivalent when the
        runtime index table itself is not part of the portable save overlay.
        """

        result = list(records)
        for index, leader in enumerate(records):
            if leader.team == 0xFF or not leader.has_position:
                continue
            # The source's runtime table has lost the packed slot nibble in a
            # portable save. Retain the compacted lead-first order as stable
            # formation slots until that runtime table is made save-readable.
            result[index] = replace(
                result[index],
                formation_slot=0,
                formation_facing=leader.facing & 0x03,
            )
            follower = index + 1
            slot = 1
            while follower < len(records):
                member = records[follower]
                if member.has_position or member.floor != leader.floor or member.y != leader.y:
                    break
                result[follower] = replace(
                    self._at_team_position(member, leader),
                    formation_slot=slot,
                    formation_facing=leader.facing & 0x03,
                )
                follower += 1
                slot += 1
        return tuple(result)

    def champions(self, tower: int) -> tuple[ChampionMapRecord, ...]:
        """Return in-dungeon champion positions for the standard save's Keep."""

        if self.save_data is None or tower != 0:
            return ()
        records = []
        for index in range(16):
            offset = index * 0x20
            if offset + 0x1B > len(self.save_data):
                break
            x = self.save_data[offset + 0x16]
            if x == 0xFF:
                continue
            render_state = self.save_data[offset + 0x18]
            records.append(
                ChampionMapRecord(
                    index=index,
                    x=x & 0x7F,
                    y=self.save_data[offset + 0x17],
                    floor=self.save_data[offset + 0x1A],
                    # Draw_DungeonCellOccupants splits champion byte $18:
                    # the low bits choose character direction, while bits
                    # 4-5 anchor one of the four floor mini-spaces.
                    facing=render_state & 0x03,
                    formation_slot=(render_state >> 4) & 0x03,
                )
            )
        return tuple(records)

    def original_champions(self, tower: int) -> tuple[ChampionMapRecord, ...]:
        """Return all sixteen clean-game champion placements in the Keep."""

        if tower != QUICKSTART_TOWER:
            return ()
        path = self.clean_root / "data" / "champions.stats"
        if not path.is_file():
            return ()
        data = path.read_bytes()
        records = []
        for index in range(min(16, len(data) // 0x20)):
            offset = index * 0x20
            x = data[offset + 0x16]
            if x == 0xFF:
                continue
            render_state = data[offset + 0x18]
            records.append(
                ChampionMapRecord(
                    index=index,
                    x=x & 0x7F,
                    y=data[offset + 0x17],
                    facing=render_state & 0x03,
                    formation_slot=(render_state >> 4) & 0x03,
                    floor=data[offset + 0x1A],
                )
            )
        return tuple(records)

    def viewer_champions(
        self,
        tower: int,
        *,
        quickstart_teams: bool = True,
    ) -> tuple[ChampionMapRecord, ...]:
        """Return save placements or either requested raw-game champion view."""

        if self.save_data is not None:
            return self.champions(tower)
        records = self.original_champions(tower)
        if not quickstart_teams or tower != QUICKSTART_TOWER:
            return records
        quickstart_locations = {
            champion: (QUICKSTART_FLOOR, x, y)
            for champions, x, y in QUICKSTART_PARTIES
            for champion in champions
        }
        result = []
        for record in records:
            floor, x, y = quickstart_locations.get(
                record.index, (record.floor, record.x, record.y)
            )
            result.append(
                ChampionMapRecord(
                    index=record.index,
                    floor=floor,
                    x=x,
                    y=y,
                    facing=record.facing,
                    formation_slot=record.formation_slot,
                )
            )
        return tuple(result)

    def champion_direction(self, index: int) -> int:
        """Return a champion's saved `$18` direction for either data source."""

        if not 0 <= index < 16:
            return 0
        if self.save_data is not None:
            offset = index * 0x20 + 0x18
            if offset < len(self.save_data):
                return self.save_data[offset] & 0x03
            return 0
        path = self.clean_root / "data" / "champions.stats"
        offset = index * 0x20 + 0x18
        if path.is_file():
            data = path.read_bytes()
            if offset < len(data):
                return data[offset] & 0x03
        return 0

    def players(self, tower: int) -> tuple[PlayerMapRecord, ...]:
        """Return the one or two player-party positions for their current tower."""

        if self.current_tower != tower or self.save_data is None:
            return ()

        def player(index: int, position_offset: int, floor_offset: int) -> PlayerMapRecord | None:
            if floor_offset + 2 > len(self.save_data) or position_offset + 4 > len(self.save_data):
                return None
            return PlayerMapRecord(
                index=index,
                x=int.from_bytes(self.save_data[position_offset : position_offset + 2], "big"),
                y=int.from_bytes(self.save_data[position_offset + 2 : position_offset + 4], "big"),
                floor=int.from_bytes(self.save_data[floor_offset : floor_offset + 2], "big"),
            )

        result = [player(0, SAVE_PLAYER_ONE_POSITION_OFFSET, SAVE_PLAYER_ONE_FLOOR_OFFSET)]
        one_player = (
            SAVE_PLAYER_MODE_OFFSET + 2 <= len(self.save_data)
            and int.from_bytes(self.save_data[SAVE_PLAYER_MODE_OFFSET : SAVE_PLAYER_MODE_OFFSET + 2], "big") == 0xFFFF
        )
        if not one_player:
            result.append(player(1, SAVE_PLAYER_TWO_POSITION_OFFSET, SAVE_PLAYER_TWO_FLOOR_OFFSET))
        return tuple(item for item in result if item is not None)

    def player_parties(self, tower: int) -> tuple[PlayerPartyMapRecord, ...]:
        """Return live ``P`` parties or the two no-save Quickstart ``Q`` teams."""

        if self.save_data is None:
            if tower != QUICKSTART_TOWER:
                return ()
            return tuple(
                PlayerPartyMapRecord(
                    index=index,
                    floor=QUICKSTART_FLOOR,
                    x=x,
                    y=y,
                    champions=champions,
                    source="quickstart",
                    facing=0,
                )
                for index, (champions, x, y) in enumerate(QUICKSTART_PARTIES)
            )

        team_offsets = (SAVE_PLAYER_ONE_TEAM_OFFSET, SAVE_PLAYER_TWO_TEAM_OFFSET)
        direction_offsets = (
            SAVE_PLAYER_ONE_DIRECTION_OFFSET,
            SAVE_PLAYER_TWO_DIRECTION_OFFSET,
        )
        result = []
        for player, team_offset, direction_offset in zip(
            self.players(tower), team_offsets, direction_offsets
        ):
            if team_offset + 4 > len(self.save_data):
                champions = ()
            else:
                champions = tuple(
                    champion
                    for champion in self.save_data[team_offset : team_offset + 4]
                    if champion < 16
                )
            result.append(
                PlayerPartyMapRecord(
                    index=player.index,
                    floor=player.floor,
                    x=player.x,
                    y=player.y,
                    champions=champions,
                    source="save",
                    # Draw_PlayerOccupant reads the low byte of the player's
                    # direction word at PlayerData+$21 for every party member.
                    facing=(
                        self.save_data[direction_offset] & 0x03
                        if direction_offset < len(self.save_data)
                        else 0
                    ),
                )
            )
        return tuple(result)

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

    def set_object_stacks(
        self,
        tower: int,
        stacks: Iterable[ObjectStack],
    ) -> tuple[ObjectStack, ...]:
        """Replace one tower's packed object-stack records without resizing it."""

        name = f"maps/{TOWERS[tower].stem}.obj"
        data = self.editable_resource(name)
        validated = tuple(stacks)
        encoded = bytearray()
        for stack in validated:
            if stack.position not in (0, 4, 8, 12):
                raise ValueError("object stack position must be 0, 4, 8, or 12")
            if not 0 <= stack.map_index <= 0x0FFF:
                raise ValueError("object stack map index must fit in twelve bits")
            if not 1 <= len(stack.items) <= 0x100:
                raise ValueError("object stack must contain between 1 and 256 items")
            location = (stack.position << 12) | stack.map_index
            encoded.extend(location.to_bytes(2, "big"))
            encoded.append(len(stack.items) - 1)
            for code, quantity in stack.items:
                if not 0 <= code <= 0xFF or not 1 <= quantity <= 0xFF:
                    raise ValueError("object code and quantity must be byte values; quantity cannot be zero")
                encoded.extend((code, quantity))
        if len(encoded) > len(data) - 2:
            raise ValueError(
                f"source build required: object stacks need {len(encoded)} bytes; "
                f"fixed tower resource has {len(data) - 2}"
            )
        data[:2] = len(encoded).to_bytes(2, "big")
        data[2 : 2 + len(encoded)] = encoded
        self.dirty_resources.add(name)
        return validated
