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
INVENTORY_SELECTION_TITLE_Y = 19
INVENTORY_SLOT_ORIGIN = (0, 25)
INVENTORY_SLOT_COLUMNS = 6
INVENTORY_SLOT_SIZE = 16
INVENTORY_SLOT_COUNT = 12
# `NumberedObject` restores the original pocket address before drawing the
# digits.  The glyph routine starts at that address, so quantities are aligned
# with the cell's left edge rather than being horizontally inset.
INVENTORY_QUANTITY_X_OFFSET = 0
# `adrCd00C9DC` uses the object ID as an index from byte $0B of the same
# 16-byte pocket record.  IDs $01-$04 therefore share their counters in
# $0C-$0F, rather than storing a quantity per visible slot.
INVENTORY_COUNTED_OBJECT_FIRST = 0x01
INVENTORY_COUNTED_OBJECT_LAST = 0x04
INVENTORY_COUNT_OFFSET = 0x0B
INVENTORY_ARMOUR_BAR_RECT = (1, 57, 95, 8)
INVENTORY_ARMOUR_TEXT_Y = 59
INVENTORY_PARTY_ORIGIN = (0, 65)
INVENTORY_HELD_SLOT_POSITION = (64, 65)
INVENTORY_EXIT_SLOT_POSITION = (80, 65)
INVENTORY_SELECTED_SLOT_FRAME = (1, 66, 16, 15)
# In `adrCd00CAEA`, picture $00 is the actual empty-pocket graphic.  Pictures
# $6C-$6F are the hand/body/shield placeholders, and picture $74 is the exit
# control drawn after the held-item pocket by `adrCd006C42`.
INVENTORY_EMPTY_POCKET_PICTURE = 0x00
INVENTORY_EXIT_PICTURE = 0x74
INVENTORY_EMPTY_PROFESSION_PICTURE = 0x3B
INVENTORY_PROFESSION_PICTURE_BASE = 0x4B
INVENTORY_ARMOUR_PROTECTION_LOOKUP = (1, 2, 4, 3, 4, 5, 7)
INVENTORY_INGAME_CONTENT_RECT = (0, 22, 96, 60)


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


def _template_colour_pixels(
    pockets: object,
    picture: int,
    secondary_colour_index: int,
) -> list[list[int]]:
    """Return a Pockets.gfx picture with UI-template ink recoloured."""
    return [
        [secondary_colour_index if pixel == 0x0F else pixel for pixel in row]
        for row in pockets.icon(picture).pixels
    ]


def inventory_object_quantity(pocket_record: bytes, object_code: int) -> int | None:
    """Return the shared quantity for a counted object, if it has one.

    Coinage, common keys, regular arrows and elf arrows are object IDs
    `$01` through `$04`.  The game prevents normal play from placing one in
    more than one pocket, but every forced duplicate reads the same counter.
    """
    if not INVENTORY_COUNTED_OBJECT_FIRST <= object_code <= INVENTORY_COUNTED_OBJECT_LAST:
        return None
    count_index = INVENTORY_COUNT_OFFSET + object_code
    if len(pocket_record) <= count_index:
        raise ValueError("pocket_record must contain the four shared quantity bytes")
    return pocket_record[count_index]


def inventory_quantity_text(quantity: int) -> str:
    """Return the two-glyph inventory count without altering the stored byte."""

    if not 0 <= quantity <= 0xFF:
        raise ValueError("inventory quantity must be a byte value")
    return f"{min(quantity, 99):02d}"


def visible_inventory_object_code(pocket_record: bytes, slot: int) -> int:
    """Return a slot's object ID after the game's zero-count validation."""
    if not 0 <= slot < INVENTORY_SLOT_COUNT:
        raise ValueError("slot must be 0..11")
    if len(pocket_record) <= slot:
        raise ValueError("pocket_record must contain the twelve inventory slots")
    object_code = pocket_record[slot]
    quantity = inventory_object_quantity(pocket_record, object_code)
    # `adrCd00CA38` clears a counted object's slot when its shared counter is
    # zero before falling through to the empty-pocket rendering path.
    return 0 if quantity == 0 else object_code


def _draw_inventory_slots(
    pygame: object,
    surface: object,
    *,
    pockets: object,
    font_data: bytes,
    champion: int,
    pocket_record: bytes,
    secondary_colour_index: int,
    palette: Sequence[tuple[int, int, int]],
    slot_pixels: Callable[[int, int], Sequence[Sequence[int]] | None] | None = None,
) -> None:
    """Draw source-sized inventory slots, their objects and shared quantities."""
    for slot in range(INVENTORY_SLOT_COUNT):
        # `adrCd00C9BC` uses the $6C-$6F equipment outlines for the first
        # four cells.  Its `bcc adrCd00CA32` path deliberately leaves d0 at
        # its per-iteration zero value for all eight ordinary empty pockets.
        x = INVENTORY_SLOT_ORIGIN[0] + (slot % INVENTORY_SLOT_COLUMNS) * INVENTORY_SLOT_SIZE
        y = INVENTORY_SLOT_ORIGIN[1] + (slot // INVENTORY_SLOT_COLUMNS) * INVENTORY_SLOT_SIZE
        object_code = visible_inventory_object_code(pocket_record, slot)
        pixels = slot_pixels(slot, object_code) if slot_pixels is not None else None
        if pixels is None:
            picture = 0x6C + slot if slot < 4 else INVENTORY_EMPTY_POCKET_PICTURE
            if slot == 3 and champion & 1:
                picture += 1
            pixels = _template_colour_pixels(pockets, picture, secondary_colour_index)
        _draw_indexed(
            pygame,
            surface,
            pixels,
            (x, y),
            palette,
            transparent_index=0,
        )
        quantity = inventory_object_quantity(pocket_record, object_code)
        if quantity is not None:
            # `adrCd00CAA6` converts the shared byte to two decimal glyphs,
            # then offsets its destination by $50 (Y+2) or $168 (Y+9).  Its
            # restored source address has no horizontal offset.  This is
            # deliberately repeated for every
            # forced duplicate of a counted object.
            quantity_y = y + (2 if object_code < 3 else 9)
            _draw_text(
                surface,
                font_data,
                inventory_quantity_text(quantity),
                x + INVENTORY_QUANTITY_X_OFFSET,
                quantity_y,
                palette[6],
            )


def _draw_inventory_party_and_held_row(
    pygame: object,
    surface: object,
    *,
    pockets: object,
    party_members: Sequence[int | None],
    selected_party_slot: int,
    secondary_colour_index: int,
    palette: Sequence[tuple[int, int, int]],
    is_dead: Callable[[int | None], bool],
) -> None:
    """Draw `adrCd006C42`'s party buttons, held pocket and exit control."""
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

    # `adrCd006C42` first calls adrCd00CA66 for the held object.  With no
    # object selected that invokes adrCd00CAEA with d0=0 at x=$120.  Only then
    # does it draw the fixed $74 exit picture at x=$130.
    _draw_indexed(
        pygame,
        surface,
        pockets.icon(INVENTORY_EMPTY_POCKET_PICTURE).pixels,
        INVENTORY_HELD_SLOT_POSITION,
        palette,
        transparent_index=0,
    )
    _draw_indexed(
        pygame,
        surface,
        _template_colour_pixels(pockets, INVENTORY_EXIT_PICTURE, secondary_colour_index),
        INVENTORY_EXIT_SLOT_POSITION,
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
    slot_pixels: Callable[[int, int], Sequence[Sequence[int]] | None] | None = None,
) -> object:
    """Render the two-chain inventory page used by the selection/Data Viewer.

    This is `adrJA00C938` / Draw_InventoryPanel, rather than the in-game
    `Click_OpenInventory` view.  Its optional slot resolver supplies the
    source-derived object sprites without coupling this shared renderer to a
    particular viewer's asset loader.
    """
    if not 0 <= selected_party_slot < 4:
        raise ValueError("selected_party_slot must be 0..3")
    if not 0 <= secondary_colour_index <= 0x0F:
        raise ValueError("secondary_colour_index must be 0..15")
    if is_dead is None:
        is_dead = lambda _champion: False

    surface = pygame.Surface(CHAMPION_INVENTORY_SIZE)
    surface.fill(palette[0])

    # Draw_InventoryPanel ($C938) reaches GFX_Pockets+$3C00 through
    # adrCd008358 at screen offsets $029C (Y=16) and $0B5C (Y=72).  Its two
    # scaled bars are x=$E2/y=$18 and x=$E1/y=$40 respectively.
    chain = _inventory_chain_pixels(pockets)
    _draw_indexed(pygame, surface, chain, (0, 9), palette)
    pygame.draw.rect(surface, palette[3], INVENTORY_NAME_BAR_RECT)
    _draw_indexed(pygame, surface, chain, INVENTORY_PARTY_ORIGIN, palette)

    _draw_text(
        surface,
        font_data,
        "INVENTORY",
        8,
        INVENTORY_SELECTION_TITLE_Y,
        palette[13],
    )
    _draw_inventory_slots(
        pygame,
        surface,
        pockets=pockets,
        font_data=font_data,
        champion=champion,
        pocket_record=pocket_record,
        secondary_colour_index=secondary_colour_index,
        palette=palette,
        slot_pixels=slot_pixels,
    )

    pygame.draw.rect(surface, palette[3], INVENTORY_ARMOUR_BAR_RECT)
    _draw_text(surface, font_data, "ARMOUR:", 8, INVENTORY_ARMOUR_TEXT_Y, palette[13])
    _draw_text(
        surface,
        font_data,
        champion_armour_modifier_text(record, pocket_record),
        64,
        INVENTORY_ARMOUR_TEXT_Y,
        palette[14],
    )

    # The Data Viewer selection layout ends at the lower chain.  Unlike the
    # in-game inventory, it has no party-selector, held-item, or exit row.
    return surface


def render_empty_ingame_champion_inventory(
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
    slot_pixels: Callable[[int, int], Sequence[Sequence[int]] | None] | None = None,
) -> object:
    """Render in-game inventory content without replacing its name frame.

    `Click_OpenInventory` ($6BF0) runs on top of the normal movement panel.
    Consequently it must leave the upper name-frame bevel and the bottom
    GFX_Pockets+$3C00 chain intact; only Y=29..88 is cleared and redrawn.
    """
    if not 0 <= selected_party_slot < 4:
        raise ValueError("selected_party_slot must be 0..3")
    if not 0 <= secondary_colour_index <= 0x0F:
        raise ValueError("secondary_colour_index must be 0..15")
    if is_dead is None:
        is_dead = lambda _champion: False

    # This is an opaque work surface.  The caller blits only
    # INVENTORY_INGAME_CONTENT_RECT, preserving the normal name frame above
    # and the continuous chain below without a full-panel alpha composite.
    surface = pygame.Surface(CHAMPION_INVENTORY_SIZE)
    surface.fill(palette[0])
    _draw_inventory_slots(
        pygame,
        surface,
        pockets=pockets,
        font_data=font_data,
        champion=champion,
        pocket_record=pocket_record,
        secondary_colour_index=secondary_colour_index,
        palette=palette,
        slot_pixels=slot_pixels,
    )
    pygame.draw.rect(surface, palette[3], INVENTORY_ARMOUR_BAR_RECT)
    _draw_text(surface, font_data, "ARMOUR:", 8, INVENTORY_ARMOUR_TEXT_Y, palette[13])
    _draw_text(
        surface,
        font_data,
        champion_armour_modifier_text(record, pocket_record),
        64,
        INVENTORY_ARMOUR_TEXT_Y,
        palette[14],
    )
    _draw_inventory_party_and_held_row(
        pygame,
        surface,
        pockets=pockets,
        party_members=party_members,
        selected_party_slot=selected_party_slot,
        secondary_colour_index=secondary_colour_index,
        palette=palette,
        is_dead=is_dead,
    )
    return surface
