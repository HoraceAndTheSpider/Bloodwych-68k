"""Shared character/monster editor semantics for map and data viewers."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Iterable, Sequence

from tools.map_editor.model import MonsterRecord


MONSTER_TYPE_NAMES = {
    0: "FIGHTER",
    1: "SPELL-CASTING FIGHTER",
    2: "DRONE",
    3: "SPELL-CASTING DRONE",
    4: "ARC-BOLT SHOOTER",
}

LARGE_MONSTER_NAMES = {
    0x64: "SUMMON",
    0x65: "SUMMON VARIANT",
    0x66: "BEHOLDER",
    0x67: "BEHEMOTH",
    0x68: "CRAB",
    0x69: "LARGE DRAGON",
    0x6A: "SMALL DRAGON",
    0x6B: "ENTROPY",
}


@dataclass(frozen=True)
class MonsterTeam:
    """One authored four-slot team reconstructed from packed ``KL`` bytes."""

    group: int
    members: tuple[int | None, int | None, int | None, int | None]


def champion_edit_allowed(*, has_save: bool, selected_tower: int, active_tower: int | None) -> bool:
    """Apply the AMOS champion-edit boundary for game and save projects."""

    return selected_tower == (active_tower if has_save else 0)


def monster_form_name(form: int) -> str:
    """Name source-rendered large forms and identify character-table forms."""

    if form in LARGE_MONSTER_NAMES:
        return LARGE_MONSTER_NAMES[form]
    if 0 <= form <= 0x55:
        return f"CHARACTER FORM ${form:02X}"
    if 0x80 <= form <= 0x8F:
        return f"AIRBORNE SPELL ${form:02X}"
    return f"FORM ${form:02X}"


def monster_teams(records: Iterable[MonsterRecord]) -> tuple[MonsterTeam, ...]:
    """Expose the deeper 25x4 team index represented by packed ``KL``."""

    groups: dict[int, list[int | None]] = {}
    for record in records:
        if record.team == 0xFF:
            continue
        group = record.team >> 2
        slot = record.team & 3
        groups.setdefault(group, [None, None, None, None])[slot] = record.index
    return tuple(
        MonsterTeam(group, tuple(members))
        for group, members in sorted(groups.items())
    )


def monster_indices_at_cell(
    records: Iterable[MonsterRecord], floor: int, x: int, y: int
) -> tuple[int, ...]:
    """Return source record indices at a cell, including resolved followers."""

    return tuple(
        record.index
        for record in records
        if record.has_position
        and (record.floor, record.x, record.y) == (floor, x, y)
        and not record.is_spell
    )


def cycle_monster_index(candidates: Sequence[int], current: int) -> int | None:
    if not candidates:
        return None
    try:
        position = candidates.index(current)
    except ValueError:
        return candidates[0]
    return candidates[(position + 1) % len(candidates)]


def next_team_assignment(records: Sequence[MonsterRecord], index: int) -> tuple[int, int]:
    """Choose the group/slot used by an AMOS-style JOIN PREVIOUS action.

    Existing predecessor teams are extended in their first empty slot.  A
    predecessor without ``KL`` starts the first unused group at slot zero and
    the selected record occupies slot one.
    """

    if not 0 < index < len(records):
        raise ValueError("a monster can only join a preceding record")
    previous = records[index - 1]
    teams = {team.group: team for team in monster_teams(records)}
    if previous.team != 0xFF:
        group = previous.team >> 2
        members = teams[group].members
        for slot, member in enumerate(members):
            if member is None:
                return group, slot
        raise ValueError("the preceding monster's team already has four members")
    used = set(teams)
    group = next((candidate for candidate in range(25) if candidate not in used), None)
    if group is None:
        raise ValueError("the 25-group monster team table is full")
    return group, 1
