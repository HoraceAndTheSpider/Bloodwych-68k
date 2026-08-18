"""Source-led empty champion inventory shared by the two viewer surfaces."""

from __future__ import annotations

from typing import Callable, Sequence

from tools.champion_data import CLASS_COLOUR_MASKS
from tools.gamefont_converter import glyph_pixels
from tools.graphics_preview import remap_template_colours


CHAMPION_INVENTORY_SIZE = (96, 89)
INVENTORY_CHAIN_OFFSET = 0x3C00
INVENTORY_CHAIN_SIZE = (96, 7)
INVENTORY_NAME_BAR_RECT = (2, 17, 94, 8)
INVENTORY_SLOT_ORIGIN = (0, 25)
INVENTORY_SLOT_COLUMNS = 6
INVENTORY_SLOT_SIZE = 16
INVENTORY_ARMOUR_BAR_RECT = (1, 57, 95, 8)
INVENTORY_PARTY_ORIGIN = (0, 65)
INVENTORY_HELD_SLOT_POSITION = (64, 65)
INVENTORY_SELECTED_SLOT_FRAME = (1, 66, 16, 15)
INVENTORY_HELD_SLOT_PICTURE = 0x74
INVENTORY_EMPTY_PROFESSION_PICTURE = 0x3B
INVENTORY_PROFESSION_PICTURE_BASE = 0x4B
INVENTORY_ARMOUR_PROTECTION_LOOKUP = (1, 2, 4, 3, 4, 5, 7)


def _indexed_surface(
    pygame: object,
    pixels: Sequence[Sequence[int]],
    palette: Sequence[tuple[int, int, int]],
    *,
    transparent_index: int | None = None,
) -> object:
    width = len(pixels[0]) if pixels else 0
    height = len(pixels)
    if transparent_index is None:
        data = bytes(
            channel
            for row in pixels
            for index in row
            for channel in palette[index]
        )
        return pygame.image.fromstring(data, (width, height), "RGB")
    data = bytes(
        channel
        for row in pixels
        for index in row
        for channel in (*palette[index], 0 if index == transparent_index else 255)
    )
    return pygame.image.fromstring(data, (width, height), "RGBA")


def _draw_indexed(
    pygame: object,
    surface: object,
    pixels: Sequence[Sequence[int]],
    position: tuple[int, int],
    palette: Sequence[tuple[int, int, int]],
    *,
    transparent_index: int | None = None,
) -> None:
    surface.blit(
        _indexed_surface(
            pygame, pixels, palette, transparent_index=transparent_index
        ),
        position,
    )


def _draw_text(
    surface: object,
    font_data: bytes,
    text: str,
    x: int,
    y: int,
    colour: tuple[int, int, int],
) -> None:
    for character in text.upper():
        for row, values in enumerate(glyph_pixels(font_data, ord(character) & 0x7F)):
            for column, value in enumerate(values):
                if value:
                    surface.set_at((x + column, y + row), colour)
        x += 8


def _inventory_chain_pixels(pockets: object) -> Sequence[Sequence[int]]:
    """Return the `$3C00` strip used at the inventory's two source anchors."""
    row_bytes = 160
    y, in_row = divmod(INVENTORY_CHAIN_OFFSET, row_bytes)
    x = in_row // 8 * 16
    return pockets.crop(
        "inventory_chain", x, y, *INVENTORY_CHAIN_SIZE
    ).pixels


def champion_armour_level(record: object, pocket_record: bytes) -> int:
    """Reproduce `adrCd00631E` / Calculate_ChampionArmourLevel exactly.

    The source starts with the champion's base and worn-spell protection,
    applies body and hand equipment, then adds the shield lookup for object
    IDs `$24` through `$2A`.  It deliberately returns a level rather than the
    signed number displayed on the inventory panel.
    """
    if len(pocket_record) < 4:
        raise ValueError("pocket_record must contain the first four inventory bytes")

    worn_spell = record.byte(0x11)
    spell_armour = worn_spell >> 3 if (worn_spell & 0x07) == 0 else 0
    armour = max(record.byte(0x0B), spell_armour)

    body_armour = pocket_record[2]
    if body_armour:
        armour = max(armour, (body_armour - 0x1B) * 2 + 3)

    hand_armour = record.byte(0x12)
    if hand_armour:
        armour += hand_armour - 0x2B

    shield = pocket_record[3] - 0x24
    if 0 <= shield < len(INVENTORY_ARMOUR_PROTECTION_LOOKUP):
        armour += INVENTORY_ARMOUR_PROTECTION_LOOKUP[shield]
    return armour


def champion_armour_modifier_text(record: object, pocket_record: bytes) -> str:
    """Format the three writable characters in `Inventory_ArmourTextTemplate`."""
    difference = 10 - champion_armour_level(record, pocket_record)
    return f"{'+' if difference >= 0 else '-'}{abs(difference):02d}"


def render_empty_champion_inventory(
    pygame: object,
    *,
    pockets: object,
    font_data: bytes,
    record: object,
    champion: int,
    pocket_record: bytes,
    party_members: Sequence[int | None],
    selected_party_slot: int,
    secondary_colour_index: int,
    palette: Sequence[tuple[int, int, int]],
    is_dead: Callable[[int | None], bool] | None = None,
) -> object:
    """Render the empty page produced by the inventory draw/update routines.

    This intentionally does not draw stored objects.  The twelve semantic
    empty pictures come from `Draw_InventoryPocketSlots`; item overlays can be
    added in a later pass without changing this shared, source-sized surface.
    """
    if not 0 <= selected_party_slot < 4:
        raise ValueError("selected_party_slot must be 0..3")
    if not 0 <= secondary_colour_index <= 0x0F:
        raise ValueError("secondary_colour_index must be 0..15")
    if is_dead is None:
        is_dead = lambda _champion: False

    surface = pygame.Surface(CHAMPION_INVENTORY_SIZE)
    surface.fill(palette[0])

    # Draw_InventoryPanel ($C938) reaches the same GFX_Pockets+$3C00 strip
    # through adrCd008358 at screen offsets $029C (Y=16) and $0B5C (Y=72).
    # Its two scaled bars are x=$E2/y=$18 and x=$E1/y=$40 respectively.
    chain = _inventory_chain_pixels(pockets)
    _draw_indexed(pygame, surface, chain, (0, 9), palette)
    pygame.draw.rect(surface, palette[3], INVENTORY_NAME_BAR_RECT)
    _draw_indexed(pygame, surface, chain, INVENTORY_PARTY_ORIGIN, palette)

    # Redraw_Inventory ($6C0A) puts the currently inspected champion's name
    # back into the title cell.  It does not make that champion the party lead.
    _draw_text(surface, font_data, record.given_name[:7], 8, 17, palette[13])

    for slot in range(12):
        picture = 0x6C + slot
        if slot == 3 and champion & 1:
            picture += 1
        pixels = pockets.icon(picture).pixels
        pixels = [
            [secondary_colour_index if pixel == 0x0F else pixel for pixel in row]
            for row in pixels
        ]
        x = INVENTORY_SLOT_ORIGIN[0] + (slot % INVENTORY_SLOT_COLUMNS) * INVENTORY_SLOT_SIZE
        y = INVENTORY_SLOT_ORIGIN[1] + (slot // INVENTORY_SLOT_COLUMNS) * INVENTORY_SLOT_SIZE
        _draw_indexed(pygame, surface, pixels, (x, y), palette, transparent_index=0)

    pygame.draw.rect(surface, palette[3], INVENTORY_ARMOUR_BAR_RECT)
    _draw_text(surface, font_data, "ARMOUR:", 8, 57, palette[13])
    _draw_text(
        surface,
        font_data,
        champion_armour_modifier_text(record, pocket_record),
        64,
        57,
        palette[14],
    )

    # adrCd006C58 repeats adrCd008416 for the four PlayerX_Data+$18 members.
    # Its destination is $0B5C, so the four 16-pixel pictures precede the
    # fixed empty held-item picture ($74) at x=$120.
    for slot in range(4):
        party_champion = party_members[slot] if slot < len(party_members) else None
        if party_champion is None or is_dead(party_champion):
            pixels = pockets.icon(INVENTORY_EMPTY_PROFESSION_PICTURE).pixels
        else:
            pixels = remap_template_colours(
                pockets.icon(INVENTORY_PROFESSION_PICTURE_BASE + (party_champion & 3)).pixels,
                CLASS_COLOUR_MASKS[(party_champion + party_champion // 4) & 3],
            )
        _draw_indexed(
            pygame,
            surface,
            pixels,
            (INVENTORY_PARTY_ORIGIN[0] + slot * INVENTORY_SLOT_SIZE, INVENTORY_PARTY_ORIGIN[1]),
            palette,
            transparent_index=0,
        )

    held_pixels = pockets.icon(INVENTORY_HELD_SLOT_PICTURE).pixels
    held_pixels = [
        [secondary_colour_index if pixel == 0x0F else pixel for pixel in row]
        for row in held_pixels
    ]
    _draw_indexed(
        pygame,
        surface,
        held_pixels,
        INVENTORY_HELD_SLOT_POSITION,
        palette,
        transparent_index=0,
    )
    frame_x, frame_y, frame_width, frame_height = INVENTORY_SELECTED_SLOT_FRAME
    pygame.draw.rect(
        surface,
        palette[13],
        (frame_x + selected_party_slot * INVENTORY_SLOT_SIZE, frame_y, frame_width, frame_height),
        1,
    )
    return surface
