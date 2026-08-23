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

# Calculate_SpellCastingQuality ($6778) subtracts this executable table before
# C6720 maps the negated result through its 20 bar percentages. The Wiki's
# 1--32 difficulty column does not equal this byte-level penalty table.
SPELL_CASTING_PROFESSION_BASE_BONUSES = (3, 5, 4, 4)
SPELL_CASTING_DIFFICULTY_PENALTIES = (
    14, 15, 14, 14, 13, 14, 14, 15, 14, 15, 14, 18, 15, 15, 17, 16,
    15, 15, 16, 36, 16, 17, 19, 14, 18, 24, 16, 22, 16, 17, 19, 18,
)
CAST_BAR_PERCENTAGES = (100, 100, 100, 100, 99, 98, 95, 90, 84, 74, 62, 50, 37, 26, 16, 9, 5, 2, 1, 0)


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


def can_increase_cast_power(spell_index: int, cast_power: int) -> bool:
    """Return whether C688C keeps the next cast-power cost below $64."""
    next_power = cast_power + 1
    return (
        next_power < len(CAST_POWER_COST_ADJUSTMENTS)
        and spellbook_cost(spell_index, next_power) < 0x64
    )


def can_decrease_cast_power(spell_index: int, cast_power: int) -> bool:
    """Return whether C688C permits one lower cast-power setting.

    Click_ViewSpell decrements champion byte $14 without a fixed negative
    limit. C688C restores the byte only when the resulting spell-point cost
    would be zero, leaving one spell point as the source minimum.
    """
    return spellbook_cost(spell_index, cast_power) > 1


def spell_cast_score(
    spell_index: int,
    *,
    champion_index: int,
    level: int,
    cooldown: int,
    pocket_items: bytes,
    spell_practice: int = 0,
    cast_adjustment: int = 0,
) -> int:
    """Reproduce Calculate_SpellCastingQuality before C6720 turns it into a bar.

    ``spell_practice`` is the selected byte in the runtime 16x32 spell-practice
    area. It is not part of extracted champion records, so an unloaded viewer
    correctly begins at zero. The caller supplies ``cast_adjustment`` from
    champion byte $14 when modelling an already prepared cast.
    """
    if not 0 <= champion_index < 16:
        raise ValueError("champion index must be 0..15")
    if not 0 <= spell_index < len(SPELL_CASTING_DIFFICULTY_PENALTIES):
        raise ValueError("spell index must be 0..31")
    if not 0 <= spell_practice <= 0xFF:
        raise ValueError("spell practice must be 0..255")
    spell_class = spellbook_magic_class_index(spell_index)
    champion_class = spellbook_magic_class_index(champion_index)
    class_matches = spell_class == champion_class
    # C67AC/C67D6 distinguish matching and non-matching practice curves. A
    # matching wand supplies +3 and selects the matching curve when the
    # champion's own class does not match.
    has_matching_wand = spell_class + 0x57 in pocket_items[:2]
    if class_matches:
        score = SPELL_CASTING_PROFESSION_BASE_BONUSES[champion_index & 3]
    elif has_matching_wand:
        score = 3
    else:
        score = 0

    remainder = spell_practice
    threshold = 5 if (class_matches or has_matching_wand) else 10
    shift_count = 0 if (class_matches or has_matching_wand) else 1
    while remainder >= threshold:
        score += 5
        remainder -= threshold
        threshold *= 2
        shift_count += 1
    score += remainder >> shift_count
    score += 2 * (level >> (2, 0, 1, 2)[champion_index & 3])
    score += cast_adjustment
    score -= cooldown >> (1 if class_matches else 0)
    if 0x3F in pocket_items[:2]:
        score += 5
    score -= SPELL_CASTING_DIFFICULTY_PENALTIES[spell_index]
    return score


def spell_cast_bar_width(score: int) -> int:
    """Return C6720/C8144's 52-pixel bar width for one casting score."""
    index = min(19, max(0, -score))
    return 52 * CAST_BAR_PERCENTAGES[index] // 100


def format_spell_points(current: int, maximum: int) -> str:
    """Format Draw_SpellPointValues' fixed two-digit current/maximum pair."""
    return f"{current:02d}/{maximum:02d}"
