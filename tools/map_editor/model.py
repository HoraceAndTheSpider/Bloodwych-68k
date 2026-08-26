"""Binary models shared by the Bloodwych map viewer and editors."""

from __future__ import annotations

from dataclasses import dataclass, replace
from pathlib import Path
from typing import Iterable

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

        base = {
            0x66: 4,  # beholder
            0x67: 6,  # behemoth
            0x68: 2,  # crab
            0x69: 9,  # large dragon
            0x6A: 3,  # little dragon
            0x64: 2,  # summon / illusion
            0x65: 2,
        }.get(self.form, 0)
        return max(0, (self.level & 0x7F) - base)


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
