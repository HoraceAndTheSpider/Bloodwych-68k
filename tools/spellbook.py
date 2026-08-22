"""Shared SPS 439 spell-book definitions and source-derived cost calculation."""

from __future__ import annotations

from dataclasses import dataclass


# SpellNames at $B87E: 32 fixed, eight-character records.
SPELL_NAMES = (
    "ARMOUR", "TERROR", "VITALISE", "BEGUILE", "DEFLECT", "MAGELOCK",
    "CONCEAL", "WARPOWER", "MISSILE", "VANISH", "PARALYZE", "ALCHEMY",
    "CONFUSE", "LEVITATE", "ANTIMAGE", "RECHARGE", "TRUEVIEW", "RENEW",
    "VIVIFY", "DISPELL", "FIREPATH", "ILLUSION", "COMPASS", "SPELLTAP",
    "DISRUPT", "FIREBALL", "WYCHWIND", "ARC BOLT", "FORMWALL", "SUMMON",
    "BLAZE", "MINDROCK",
)

# SpellCost_DataTable at $685E.  C688C displays twice (stored cost + 1).
SPELL_COST_VALUES = (
    1, 2, 2, 1, 1, 2, 2, 3, 1, 3, 2, 5, 2, 2, 4, 5,
    3, 3, 7, 3, 4, 4, 2, 5, 8, 3, 7, 4, 5, 6, 6, 4,
)

# adrB_00687E maps the non-negative champion $14 cast-power setting before
# C688C adds it to the displayed spell-point cost.
CAST_POWER_COST_ADJUSTMENTS = (0, 3, 6, 10, 15, 21, 28, 36, 45, 55, 66, 78, 91, 105)


@dataclass(frozen=True)
class SpellBookSelection:
    """Display-ready state shared by the interface and data viewers."""

    spell_index: int
    name: str
    magic_class: int
    cost: int


def spellbook_magic_class_index(spell_index: int) -> int:
    """Reproduce C6900's Serpent/Chaos/Dragon/Moon selector."""
    if not 0 <= spell_index < len(SPELL_NAMES):
        raise ValueError("spell index must be 0..31")
    folded_index = spell_index if spell_index < 16 else (~spell_index & 0xFFFF)
    return (spell_index + (folded_index >> 2)) & 3


def spellbook_cost(spell_index: int, cast_power: int = 0) -> int:
    """Return C688C's displayed spell-point cost for a selected spell.

    A negative ``cast_power`` is already an adjustment (as stored by
    Click_ViewSpell); non-negative values use the source's curved lookup.
    """
    if not 0 <= spell_index < len(SPELL_COST_VALUES):
        raise ValueError("spell index must be 0..31")
    adjustment = (
        CAST_POWER_COST_ADJUSTMENTS[cast_power]
        if 0 <= cast_power < len(CAST_POWER_COST_ADJUSTMENTS)
        else cast_power
    )
    return 2 * (SPELL_COST_VALUES[spell_index] + 1) + adjustment


def spellbook_selection(spell_index: int, cast_power: int = 0) -> SpellBookSelection:
    """Build one reusable status record for the selected spell."""
    return SpellBookSelection(
        spell_index=spell_index,
        name=SPELL_NAMES[spell_index],
        magic_class=spellbook_magic_class_index(spell_index),
        cost=spellbook_cost(spell_index, cast_power),
    )


def format_spell_points(current: int, maximum: int) -> str:
    """Format Draw_SpellPointValues' fixed two-digit current/maximum pair."""
    return f"{current:02d}/{maximum:02d}"
