#!/usr/bin/env python3
"""Source-led SPS 439 interface geometry, actions, colours and assets."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import random
import struct

from tools.champion_data import ChampionAssets, PocketsAssets, ScrollEdgeAssets
from tools.data_overlay import data_overlay_root, related_data_roots
from tools.dungeon_view import (
    DungeonAssets,
    DungeonPlacement,
    load_dungeon_background,
    render_dungeon_scene,
)
from tools.gamefont_converter import read_font
from tools.graphics_preview import blit


INTERFACE_WIDTH = 320
PLAYER_PANEL_HEIGHT = 96
INTERFACE_HEIGHT = PLAYER_PANEL_HEIGHT * 2
SCREEN_ROW_BYTES = INTERFACE_WIDTH // 8
POCKETS_MEMORY_ADDRESS = 0x4C702
POCKETS_BINARY_OFFSET = 0x4C37E
POCKETS_IMAGE_SIZE = 32000
POCKETS_SHEET_ROW_BYTES = 160
POCKETS_TRAILING_MEMORY_ADDRESS = POCKETS_MEMORY_ADDRESS + POCKETS_IMAGE_SIZE
POCKETS_TRAILING_BINARY_OFFSET = POCKETS_BINARY_OFFSET + POCKETS_IMAGE_SIZE
GFX_POCKETS_CHAIN_CONTINUOUS_OFFSET = 0x3C00
GFX_POCKETS_CHAIN_WITH_AVATARS_OFFSET = 0x3C30
GFX_POCKETS_CHAIN_COMMAND_OFFSET = 0x3C60
GFX_POCKETS_SELECTED_PARTY_SHIELD_OFFSET = 0x5070
PLAYER_POINTER_Y_OFFSETS = (0x0000, 0x0060)
PLAYER_SCREEN_BYTE_OFFSETS = (0x0000, 0x0F00)
DIALOGUE_TEXT_PALETTE_INDEX = 0x0F
PLAYER_DATA_UI_PRIMARY_COLOUR_OFFSET = 0x10
PLAYER_DATA_UI_SECONDARY_COLOUR_OFFSET = 0x12
PLAYER_UI_PRIMARY_COLOUR_INDICES = (0x07, 0x09)
PLAYER_UI_SECONDARY_COLOUR_INDICES = (0x08, 0x0C)
INTERFACE_ACTION_SPELL_BOOK = 0x00
INTERFACE_ACTION_STATS = 0x01
INTERFACE_ACTION_MULTI_FUNCTION = 0x02
INTERFACE_ACTION_INVENTORY = 0x03
INTERFACE_ACTION_DISPLAY = 0x10
INTERFACE_ACTION_COMMS_AND_OPTIONS = 0x1A
INTERFACE_ACTION_PAUSE = 0x1C
INTERFACE_ACTION_LOAD_SAVE = 0x1D
INTERFACE_ACTION_SLEEP_PARTY = 0x1E
INTERFACE_ACTION_SHOW_TEAM_AVATARS = 0x1F
INTERFACE_ACTION_PARTY_COMMAND_MODE = 0x20
INTERFACE_ACTION_PARTY_COMMAND_SELECTION = 0x21
COMPACT_STATS_BAR_COUNT = 3
PLAYER_COMPACT_STATS_COLOUR_INDICES = (0x07, 0x0C)
STATS_FRAME_HORIZONTAL_LINES = (
    (0x36, 0x0A, 0x25, 0x01),
    (0x34, 0x0B, 0x29, 0x02),
    (0x33, 0x0C, 0x2B, 0x03),
    (0x34, 0x0D, 0x2B, 0x04),
    (0x34, 0x0E, 0x2B, 0x01),
    (0x33, 0x31, 0x2B, 0x01),
    (0x33, 0x32, 0x2B, 0x04),
    (0x33, 0x33, 0x2B, 0x03),
    (0x34, 0x34, 0x29, 0x02),
    (0x36, 0x35, 0x25, 0x01),
)
STATS_FRAME_VERTICAL_LINES = (
    (0x34, 0x10, 0x20, 0x01),
    (0x5C, 0x10, 0x20, 0x01),
)
# Draw_CompactStatsFrame's outer fill uses palette index $02.
STATS_FRAME_FILL = (0x35, 0x10, 0x27, 0x20, 0x02)
# Draw_MainPlayerInterface then fills the smaller rectangle directly behind
# the three statistics bars with palette index $03 at memory address $80E8.
STATS_BARS_BACKGROUND = (0x36, 0x17, 0x25, 0x17, 0x03)
STATS_BAR_RECTS = ((0x37, 0x19, 0x23, 0x05),) * COMPACT_STATS_BAR_COUNT
STATS_BAR_Y_STEP = 0x07
LARGE_AVATAR_PANEL_FILL = (0x00, 0x0A, 0x30, 0x2C, 0x01)
LARGE_AVATAR_PANEL_FRAMES = (
    (0x01, 0x0B, 0x2E, 0x2A, 0x02),
    (0x02, 0x0C, 0x2C, 0x28, 0x03),
    (0x03, 0x0D, 0x2A, 0x26, 0x04),
)
LARGE_AVATAR_RECT = (0x08, 0x11, 0x20, 0x1E)
LARGE_AVATAR_INNER_FRAME = (0x06, 0x0F, 0x24, 0x22, 0x01)
# Draw_PartyCommandMenu starts at the lower edge of the large avatar panel.
# These are rendered extents, not the descriptor-stream DBRA counts: each bar
# begins three pixels below the avatar border, is seven pixels high, and ends
# at X=$5D. Draw_PartyCommandMenu subsequently draws black vertical lines at
# X=$5E and X=$5F, leaving two clear pixels before the viewport at X=$60.
COMMUNICATION_BUTTON_TOP = 0x39
COMMUNICATION_BUTTON_HEIGHT = 0x07
COMMUNICATION_BUTTON_ROW_STEP = 0x08
COMMUNICATION_BUTTON_RIGHT_EDGE = 0x5D
COMMUNICATION_BACKGROUND_COLOUR_INDEX = 0x02
COPPER_PLAYER_RASTER_SPLIT_Y = 0x98
COPPER_FRAME_WRAP_Y = 0xFF

# Native player-local geometry confirmed by adrCd008FA4 / adrCd002734: the
# viewport clear and sleep frame both begin at ($60,$0C), two pixels below the
# compact-stats top decoration at y=$0A. The dungeon and fixed control bank do
# not move when the left panel toggles.
DUNGEON_VIEW_RECT = (96, 12, 128, 76)
LEFT_PANEL_RECT = (0, 7, 96, 89)
RIGHT_PANEL_X = 224

HITBOX_RECORD_SIZE = 8
HITBOX_TABLES = (
    ("main", "data/Interface_Hitboxes_Main.lookup", 0x00, 17, "Interface_Hitboxes_Main"),
    (
        "command",
        "data/Interface_Hitboxes_Command.lookup",
        0x1C,
        6,
        "Interface_Hitboxes_Command",
    ),
    (
        "display",
        "data/Interface_Hitboxes_Display.lookup",
        0x22,
        3,
        "Interface_Hitboxes_Display",
    ),
)

ACTION_NAMES = (
    "Open spell book",
    "Show statistics",
    "Multi-function control",
    "Open inventory",
    "Primary attack",
    "Centre/display attack",
    "Select front-left champion",
    "Select front-right champion",
    "Select back-right champion",
    "Select back-left champion",
    "Move forwards",
    "Move backwards",
    "Move left",
    "Move right",
    "Rotate left",
    "Rotate right",
    "Click dungeon display",
    "Redraw inventory",
    "Select inventory object",
    "Use inventory potion/item",
    "No action (return)",
    "Launch selected spell",
    "View selected spell",
    "Turn spell-book page forwards",
    "Close current page",
    "Turn spell-book page backwards",
    "Open communications/options",
    "No action (return)",
    "Pause game",
    "Load/save game",
    "Sleep party",
    "Show team avatars",
    "Toggle party-command row",
    "Select party-command entry",
    "Resolve display-area action",
    "Handle wall-feature click",
    "Resolve wall-feature context",
)

# These are the verified labels in BLOODWYCH439_relabel_data.asm's
# DungeonInterfaceActionTable. Keep the action number and handler together so
# the viewer cannot silently drift back to an action-number-only description.
ACTION_ROUTINES = {
    INTERFACE_ACTION_SPELL_BOOK: "Click_OpenSpellBook",
    INTERFACE_ACTION_STATS: "Click_ShowStats",
    INTERFACE_ACTION_MULTI_FUNCTION: "Click_MultiFunctionButton",
    INTERFACE_ACTION_INVENTORY: "Click_OpenInventory",
    INTERFACE_ACTION_DISPLAY: "Click_Display",
    INTERFACE_ACTION_COMMS_AND_OPTIONS: "Click_CommsAndOptions",
    INTERFACE_ACTION_PAUSE: "Click_PauseGame",
    INTERFACE_ACTION_LOAD_SAVE: "Click_LoadSaveGame",
    INTERFACE_ACTION_SLEEP_PARTY: "Click_SleepParty",
    INTERFACE_ACTION_SHOW_TEAM_AVATARS: "Click_ShowTeamAvatars",
    INTERFACE_ACTION_PARTY_COMMAND_MODE: "Click_TogglePartyCommandRow",
    INTERFACE_ACTION_PARTY_COMMAND_SELECTION: "PartyCommand_DispatchSelection",
}


@dataclass(frozen=True)
class InterfaceSourceRef:
    original_label: str
    human_label: str
    memory_address: int
    purpose: str


SOURCE_REFS = (
    InterfaceSourceRef(
        "adrB_0081CA",
        "ChampionClassBarColours",
        0x81CA,
        "Maps the four champion professions to their main-panel status-bar palette indices.",
    ),
    InterfaceSourceRef(
        "adrCd0058EA",
        "Return_WallFeatureClick",
        0x58EA,
        "Returns from wall-feature handling when no supported contextual action resolves.",
    ),
    InterfaceSourceRef(
        "adrJA004DAA",
        "Begin_HitTestMainInterfaceActions",
        0x4DAA,
        "Selects the 17-record main hitbox table before entering the shared hit tester.",
    ),
    InterfaceSourceRef(
        "adrCd0080CA",
        "Draw_MainPlayerInterface",
        0x80CA,
        "Draws the ordinary player panel when the party-command state is negative.",
    ),
    InterfaceSourceRef(
        "adrW_00EE86",
        "Player1_InterfaceScreenBufferOffset",
        0xEE86,
        "Stores Player 1's screen-buffer destination offset; the following record words include the primary and secondary interface colour indices.",
    ),
    InterfaceSourceRef(
        "adrCd007B50",
        "Draw_PartyCommandInterface",
        0x7B50,
        "Clears and composes the party-command panel for the current command state.",
    ),
    InterfaceSourceRef(
        "adrCd007B2E",
        "Draw_PartyCommandPanelEdge",
        0x7B2E,
        "Builds the command-panel edge with repeated horizontal lines before the menu contents are drawn.",
    ),
    InterfaceSourceRef(
        "adrCd007D6C",
        "Draw_PartyCommandMenu",
        0x7D6C,
        "Selects a command descriptor stream and draws its selectable rows and text.",
    ),
    InterfaceSourceRef(
        "adrCd008258",
        "Draw_ChampionNamePanelBackground",
        0x8258,
        "Clears the right-hand name/display panel with a source-sized bar before its decorative frame is added.",
    ),
    InterfaceSourceRef(
        "adrCd008278",
        "Draw_ChampionNamePanelFrame",
        0x8278,
        "Draws the right-hand name-panel bevel, primary-colour name strip, and lower frame lines.",
    ),
    InterfaceSourceRef(
        "adrCd0082BA",
        "Draw_ChampionNamePanelLowerEdge",
        0x82BA,
        "Draws the lower decorative edge and the adjacent packed status graphics for the right panel.",
    ),
    InterfaceSourceRef(
        "adrCd00833C",
        "Draw_DungeonDisplayLowerEdge",
        0x833C,
        "Completes the lower display edge with procedural lines before drawing the continuous chain strip.",
    ),
    InterfaceSourceRef(
        "adrCd00C9BC",
        "Draw_InventoryPocketSlots",
        0xC9BC,
        "Draws the selected champion's twelve inventory pocket slots.",
    ),
    InterfaceSourceRef(
        "adrCd00CAEA",
        "Draw_PocketGraphic",
        0xCAEA,
        "Converts a pocket-picture index into a GFX_Pockets address and draws it.",
    ),
    InterfaceSourceRef(
        "adrCd00CE28",
        "Draw_PlanarGraphicCore",
        0xCE28,
        "Draws packed four-plane graphic rows and applies the supplied template colour index before writing the screen planes.",
    ),
    InterfaceSourceRef(
        "adrCd00CE86",
        "Replace_PlanarInk15WithColour",
        0xCE86,
        "Replaces source pixels at palette index 15 with the four-bit colour index supplied in D3.",
    ),
    InterfaceSourceRef(
        "adrLp00811E",
        "Draw_CompactStatsBarsLoop",
        0x811E,
        "Draws the three compact player statistics bars using the player-specific hard-coded bar colour.",
    ),
    InterfaceSourceRef(
        "adrCd007FF8",
        "Draw_CompactStatsFrame",
        0x7FF8,
        "Builds the compact statistics-panel frame from horizontal/vertical lines, a lower fill bar, and the STATS graphic.",
    ),
    InterfaceSourceRef(
        "adrCd00C0BA",
        "Draw_BevelledPanelFrame",
        0xC0BA,
        "Fills a panel rectangle and draws three successively inset grey frame outlines.",
    ),
    InterfaceSourceRef(
        "adrCd00CCBE",
        "Draw_MainChampionAvatarPanel",
        0xCCBE,
        "Composes the large champion panel from its outer bevel, portrait graphic, and optional inner frame.",
    ),
    InterfaceSourceRef(
        "adrCd00CCD8",
        "Draw_MainChampionAvatarInnerFrame",
        0xCCD8,
        "Draws the inner large-avatar outline unless the player state suppresses it.",
    ),
    InterfaceSourceRef(
        "adrCd00CA14",
        "Select_EmptyInventorySlotGraphic",
        0xCA14,
        "Selects the semantic empty hand, armour, shield, or pocket picture and the player's secondary UI colour.",
    ),
    InterfaceSourceRef(
        "adrCd00C7C8",
        "Prepare_AndDrawSpellBookSurface",
        0xC7C8,
        "Draws the packed spell-book surface and selects the current champion record.",
    ),
    InterfaceSourceRef(
        "adrCd00C7FC",
        "Clear_SpellBookPanel",
        0xC7FC,
        "Clears the 96-pixel spell-book panel before redrawing it.",
    ),
    InterfaceSourceRef(
        "adrCd00C812",
        "Draw_SpellPointValues",
        0xC812,
        "Formats and prints the current and maximum spell-point values.",
    ),
    InterfaceSourceRef(
        "adrCd00C86A",
        "Draw_SpellBookRunePage",
        0xC86A,
        "Draws one rune page from SpellBookRunes.",
    ),
    InterfaceSourceRef(
        "adrCd00C3DE",
        "Draw_SelectedSpellMarker",
        0xC3DE,
        "Draws the selected spell-column marker from GFX_Pockets+$4130.",
    ),
    InterfaceSourceRef(
        "adrJA004C10",
        "Click_TogglePartyCommandRow",
        0x4C10,
        "Toggles the visible party-command row when communication mode is active.",
    ),
    InterfaceSourceRef(
        "adrCd008B72",
        "Update_PlayerDialogueTextColour",
        0x8B72,
        "Selects a six-step dialogue-text fade ramp and writes hardware colour 15.",
    ),
    InterfaceSourceRef(
        "adrCd008BE8",
        "PlayerColourRampLookupBase_Exit",
        0x8BE8,
        "Serves as both the dialogue-colour update return and the historic PC-relative lookup base.",
    ),
    InterfaceSourceRef(
        "adrCd008C40",
        "Handle_CopperRasterInterrupt",
        0x8C40,
        "Alternates the Copper-scheduled raster interrupt between Player 2 colour service and the Player 1 frame service.",
    ),
    InterfaceSourceRef(
        "adrCd008C62",
        "Handle_Player1RasterAndFrameUpdate",
        0x8C62,
        "Updates Player 1 dialogue colour 15, timers, input, and frame-buffer state at the second raster interrupt.",
    ),
    InterfaceSourceRef(
        "adrEA005864",
        "Interface_Hitboxes_Display",
        0x5864,
        "Contains the three inclusive display/context hitbox records for actions $22-$24.",
    ),
    InterfaceSourceRef(
        "adrEA007C0E",
        "PartyCommandDescriptorStream_Mode0",
        0x7C0E,
        "Contains the static party-command menu descriptor stream selected by menu mode 0.",
    ),
    InterfaceSourceRef(
        "adrEA007C2C",
        "PartyCommandDescriptorStream_Mode4",
        0x7C2C,
        "Contains the static party-command menu descriptor stream selected by menu mode 4.",
    ),
    InterfaceSourceRef(
        "adrEA007C3A",
        "PartyCommandDescriptorStream_Mode5",
        0x7C3A,
        "Contains the static party-command menu descriptor stream selected by menu mode 5.",
    ),
    InterfaceSourceRef(
        "adrEA007C4D",
        "PartyCommandDescriptorStream_Mode6",
        0x7C4D,
        "Contains the static party-command menu descriptor stream selected by menu mode 6.",
    ),
    InterfaceSourceRef(
        "adrEA007C6F",
        "PartyCommandDescriptorStream_Mode7",
        0x7C6F,
        "Contains the static party-command menu descriptor stream selected by menu mode 7.",
    ),
    InterfaceSourceRef(
        "adrEA007C87",
        "PartyCommandDescriptorStream_Mode8",
        0x7C87,
        "Contains the static party-command menu descriptor stream selected by menu mode 8.",
    ),
    InterfaceSourceRef(
        "adrEA007C93",
        "PartyCommandDescriptorStream_Mode9",
        0x7C93,
        "Contains the static party-command menu descriptor stream selected by menu mode 9.",
    ),
    InterfaceSourceRef(
        "adrEA00EA72",
        "Interface_Hitboxes_Main",
        0xEA72,
        "Contains the 17 inclusive main-interface hitbox records for actions $00-$10.",
    ),
    InterfaceSourceRef(
        "adrEA00EAFA",
        "Interface_Hitboxes_Command",
        0xEAFA,
        "Contains the six inclusive command-interface hitbox records for actions $1C-$21.",
    ),
    InterfaceSourceRef(
        "adrJA006684",
        "Click_OpenSpellBook",
        0x6684,
        "Opens and composes the selected champion's spell-book interface page.",
    ),
    InterfaceSourceRef(
        "adrJA006616",
        "Click_ShowStats",
        0x6616,
        "Selects statistics mode and draws the full champion statistics page.",
    ),
    InterfaceSourceRef(
        "adrJA00425E",
        "Click_PauseGame",
        0x425E,
        "Pauses the game until either player's pending input resumes it.",
    ),
    InterfaceSourceRef(
        "adrJA00432A",
        "Click_LoadSaveGame",
        0x432A,
        "Replaces the player display with the load/save function-key prompt.",
    ),
    InterfaceSourceRef(
        "adrJA004536",
        "Click_SleepParty",
        0x4536,
        "Clears the dungeon view, draws the sleep frame, and prints THOU ART ASLEEP.",
    ),
    InterfaceSourceRef(
        "adrJA0032DE",
        "Click_ShowTeamAvatars",
        0x32DE,
        "Updates the party-command display and refreshes the team-avatar view.",
    ),
    InterfaceSourceRef(
        "adrCd002734",
        "Clear_DungeonViewWithFrames",
        0x2734,
        "Clears the dungeon view and draws the nested frame used by dead and sleep screens.",
    ),
)


@dataclass(frozen=True)
class InterfaceMode:
    key: str
    label: str
    hitbox_groups: tuple[str, ...]
    status: str
    source_labels: tuple[str, ...]
    active_actions: tuple[int, ...]


INTERFACE_MODES = (
    InterfaceMode(
        "main",
        "Dungeon / stats",
        ("main", "display"),
        "observed layout",
        ("Draw_MainPlayerInterface", "Draw_CompactStatsFrame", "DungeonInterfaceActionTable"),
        tuple(range(0x00, 0x11)) + tuple(range(0x22, 0x25)),
    ),
    InterfaceMode(
        "inventory",
        "Inventory",
        ("main",),
        "source-led",
        ("Click_OpenInventory", "Draw_InventoryPocketSlots", "Draw_PocketGraphic"),
        (0x00, 0x01, 0x02, 0x03),
    ),
    InterfaceMode(
        "stats",
        "Statistics",
        ("main",),
        "source-led",
        ("Click_ShowStats", "Draw_ChampionStats", "Draw_ScrollFrame"),
        (INTERFACE_ACTION_SPELL_BOOK, INTERFACE_ACTION_STATS, INTERFACE_ACTION_MULTI_FUNCTION, INTERFACE_ACTION_INVENTORY),
    ),
    InterfaceMode(
        "spellbook",
        "Spell book",
        ("main",),
        "source-led",
        ("Prepare_AndDrawSpellBookSurface", "Draw_SpellBookRunePage"),
        (0x00, 0x01, 0x02, 0x03),
    ),
    InterfaceMode(
        "comms",
        "Dungeon / commands",
        ("command",),
        "observed layout",
        ("Draw_PartyCommandInterface", "Draw_PartyCommandMenu"),
        (
            INTERFACE_ACTION_PAUSE,
            INTERFACE_ACTION_LOAD_SAVE,
            INTERFACE_ACTION_SLEEP_PARTY,
            INTERFACE_ACTION_SHOW_TEAM_AVATARS,
            INTERFACE_ACTION_PARTY_COMMAND_MODE,
        ),
    ),
)


@dataclass(frozen=True)
class InterfaceHitbox:
    group: str
    action: int
    x_min: int
    x_max: int
    y_min: int
    y_max: int
    source_label: str

    @property
    def width(self) -> int:
        return self.x_max - self.x_min + 1

    @property
    def height(self) -> int:
        return self.y_max - self.y_min + 1

    @property
    def action_name(self) -> str:
        return ACTION_NAMES[self.action]

    @property
    def handler_name(self) -> str:
        return ACTION_ROUTINES.get(self.action, "Unlabelled action")

    def contains(self, x: int, y: int) -> bool:
        return self.x_min <= x <= self.x_max and self.y_min <= y <= self.y_max


@dataclass(frozen=True)
class CommunicationButton:
    """One source-ordered party-command menu control in player-local pixels."""

    state: int
    word_index: int
    label: str
    x_min: int
    x_max: int
    y_min: int
    y_max: int
    text_x: int

    @property
    def width(self) -> int:
        return self.x_max - self.x_min + 1

    @property
    def height(self) -> int:
        return self.y_max - self.y_min + 1

    def contains(self, x: int, y: int) -> bool:
        return self.x_min <= x <= self.x_max and self.y_min <= y <= self.y_max


# WordsText entries $10-$16 and PartyCommand_HandlerOffsets states 1-$07.
# The visible fills omit source-drawn black borders/separators. The packed
# source stream advances one 8-pixel character cell before each right word;
# the viewer's literal GameFont renderer needs a verified two-pixel correction
# so the visible right text ends at the coloured bar edge rather than trailing
# over the source's black X=$5E/$5F border.
COMMUNICATION_BUTTONS = (
    CommunicationButton(1, 0x10, "COMMUNICATE", 1, COMMUNICATION_BUTTON_RIGHT_EDGE, COMMUNICATION_BUTTON_TOP, COMMUNICATION_BUTTON_TOP + COMMUNICATION_BUTTON_HEIGHT - 1, 0),
    CommunicationButton(2, 0x11, "COMMEND", 1, 59, COMMUNICATION_BUTTON_TOP + COMMUNICATION_BUTTON_ROW_STEP, COMMUNICATION_BUTTON_TOP + COMMUNICATION_BUTTON_ROW_STEP + COMMUNICATION_BUTTON_HEIGHT - 1, 0),
    CommunicationButton(3, 0x12, "VIEW", 61, COMMUNICATION_BUTTON_RIGHT_EDGE, COMMUNICATION_BUTTON_TOP + COMMUNICATION_BUTTON_ROW_STEP, COMMUNICATION_BUTTON_TOP + COMMUNICATION_BUTTON_ROW_STEP + COMMUNICATION_BUTTON_HEIGHT - 1, 62),
    CommunicationButton(4, 0x13, "WAIT", 1, 35, COMMUNICATION_BUTTON_TOP + COMMUNICATION_BUTTON_ROW_STEP * 2, COMMUNICATION_BUTTON_TOP + COMMUNICATION_BUTTON_ROW_STEP * 2 + COMMUNICATION_BUTTON_HEIGHT - 1, 0),
    CommunicationButton(5, 0x14, "CORRECT", 37, COMMUNICATION_BUTTON_RIGHT_EDGE, COMMUNICATION_BUTTON_TOP + COMMUNICATION_BUTTON_ROW_STEP * 2, COMMUNICATION_BUTTON_TOP + COMMUNICATION_BUTTON_ROW_STEP * 2 + COMMUNICATION_BUTTON_HEIGHT - 1, 38),
    CommunicationButton(6, 0x15, "DISMISS", 1, 59, COMMUNICATION_BUTTON_TOP + COMMUNICATION_BUTTON_ROW_STEP * 3, COMMUNICATION_BUTTON_TOP + COMMUNICATION_BUTTON_ROW_STEP * 3 + COMMUNICATION_BUTTON_HEIGHT - 1, 0),
    CommunicationButton(7, 0x16, "CALL", 61, COMMUNICATION_BUTTON_RIGHT_EDGE, COMMUNICATION_BUTTON_TOP + COMMUNICATION_BUTTON_ROW_STEP * 3, COMMUNICATION_BUTTON_TOP + COMMUNICATION_BUTTON_ROW_STEP * 3 + COMMUNICATION_BUTTON_HEIGHT - 1, 62),
)


def communication_button_at(x: int, y: int) -> CommunicationButton | None:
    """Return the visible party-command control at a player-local coordinate."""
    return next(
        (button for button in COMMUNICATION_BUTTONS if button.contains(x, y)), None
    )


def communication_button_handler(
    button: CommunicationButton, *, character_in_front: bool
) -> str:
    """Resolve the source dispatcher branch for a communication button click."""
    if button.state == 1:
        return (
            "Comms_StartWithTarget (Greeting)"
            if character_in_front
            else "Interface_ReportCommunicationTargetUnavailable"
        )
    return f"PartyCommand_{button.label.title()}"


def decode_hitboxes(
    raw: bytes, *, group: str, first_action: int, source_label: str
) -> tuple[InterfaceHitbox, ...]:
    if len(raw) % HITBOX_RECORD_SIZE:
        raise ValueError(f"{group} hitboxes are not a whole number of eight-byte records")
    records = []
    for index, values in enumerate(struct.iter_unpack(">4H", raw)):
        records.append(
            InterfaceHitbox(group, first_action + index, *values, source_label)
        )
    return tuple(records)


def screen_byte_offset_to_xy(offset: int) -> tuple[int, int]:
    """Convert a four-plane screen-buffer byte offset into native X/Y."""
    y, row_offset = divmod(offset, SCREEN_ROW_BYTES)
    return row_offset * 8, y


def amiga_colour_to_rgb(word: int) -> tuple[int, int, int]:
    """Convert an Amiga $0RGB colour word into 8-bit RGB channels."""
    return ((word >> 8 & 0xF) * 17, (word >> 4 & 0xF) * 17, (word & 0xF) * 17)


def replace_colour_nibble(word: int, channel: int, value: int) -> int:
    if channel not in (0, 1, 2):
        raise ValueError("channel must be 0 (red), 1 (green), or 2 (blue)")
    value = max(0, min(15, value))
    shift = (2 - channel) * 4
    return (word & ~(0xF << shift)) | value << shift


def remap_ui_template_colour(
    pixels: Sequence[Sequence[int]], colour_index: int
) -> list[list[int]]:
    """Apply Draw_PocketGraphic's palette-$F replacement to indexed pixels."""
    if not 0 <= colour_index <= 0x0F:
        raise ValueError("colour index must be 0..15")
    return [
        [colour_index if pixel == 0x0F else pixel for pixel in row]
        for row in pixels
    ]


def colour_ramp_index(player: int, alternate: bool, step: int) -> int:
    if player not in (0, 1):
        raise ValueError("player must be 0 or 1")
    if not 0 <= step < 6:
        raise ValueError("colour-ramp step must be 0..5")
    return player * 12 + (6 if alternate else 0) + step


class InterfaceDataError(RuntimeError):
    pass


class InterfaceProject:
    """Load interface resources through the clean/modified overlay."""

    def __init__(self, data_root: Path, *, prefer_modified: bool = False):
        self.clean_root, self.modified_root, supplied_modified = related_data_roots(data_root)
        self.use_modified = prefer_modified or supplied_modified
        self.preview_character_ids = tuple(random.sample(range(16), 4))
        self.reload(self.use_modified)

    def reload(self, use_modified: bool) -> None:
        self.use_modified = use_modified
        self.root = data_overlay_root(
            self.clean_root, self.modified_root, enabled=self.use_modified
        )
        try:
            self.pockets = PocketsAssets(self.root / "gfx/Pockets.gfx")
            self.scroll_edges = ScrollEdgeAssets(self.root / "gfx")
            self.game_font = read_font(self.root / "gfx/GameFont")
            self.champions = ChampionAssets(self.root)
            dungeon_assets = DungeonAssets(self.root / "gfx")
            dungeon_background = load_dungeon_background(self.root / "gfx")
            corridor = {
                index: DungeonPlacement("stone")
                for index in (0, 2, 3, 5, 6, 7, 9, 10, 12, 13)
            }
            corridor[15] = DungeonPlacement("door_portcullis")
            self.dungeon_preview, _ = render_dungeon_scene(
                dungeon_background,
                dungeon_assets,
                corridor,
            )
            pocket_records = (self.root / "data/champions.pockets").read_bytes()
            if len(pocket_records) != 0x100:
                raise ValueError(
                    f"champions.pockets must be 256 bytes, got {len(pocket_records)}"
                )
            self.champion_pockets = tuple(
                pocket_records[index : index + 0x10]
                for index in range(0, len(pocket_records), 0x10)
            )
            object_definitions = (
                self.root / "data/objectdefinitions.block"
            ).read_bytes()
            if len(object_definitions) != 0x6E * 4:
                raise ValueError(
                    "objectdefinitions.block must contain 110 four-byte records"
                )
            self.object_definitions = object_definitions
            colour_raw = (self.root / "gfx-data/PlayerColourRamps.colours").read_bytes()
            if len(colour_raw) != 48:
                raise ValueError(
                    f"PlayerColourRamps.colours must be 48 bytes, got {len(colour_raw)}"
                )
            self.colour_words = list(struct.unpack(">24H", colour_raw))
            self.hitboxes = {}
            for group, relative, first_action, count, source_label in HITBOX_TABLES:
                records = decode_hitboxes(
                    (self.root / relative).read_bytes(),
                    group=group,
                    first_action=first_action,
                    source_label=source_label,
                )
                if len(records) != count:
                    raise ValueError(
                        f"{source_label}: expected {count} records, got {len(records)}"
                    )
                self.hitboxes[group] = records
        except (OSError, ValueError) as error:
            raise InterfaceDataError(str(error)) from error

    def mode_hitboxes(self, mode: InterfaceMode) -> tuple[InterfaceHitbox, ...]:
        return tuple(
            hitbox
            for group in mode.hitbox_groups
            for hitbox in self.hitboxes[group]
            if hitbox.action in mode.active_actions
        )

    def colour_word(self, player: int, alternate: bool, step: int) -> int:
        return self.colour_words[colour_ramp_index(player, alternate, step)]

    def set_colour_word(
        self, player: int, alternate: bool, step: int, word: int
    ) -> None:
        self.colour_words[colour_ramp_index(player, alternate, step)] = word & 0x0FFF

    def object_pocket_pixels(self, object_code: int) -> list[list[int]]:
        if not 0 <= object_code < 0x6E:
            object_code = 0
        definition_offset = object_code * 4
        icon = self.object_definitions[definition_offset]
        colour = self.object_definitions[definition_offset + 1] & 0x0F
        source = self.pockets.icon(icon)
        return [
            [colour if pixel == 0x0F else pixel for pixel in row]
            for row in source.pixels
        ]

    def inventory_slot_pixels(
        self, champion: int, slot: int, *, ui_colour_index: int | None = None
    ) -> list[list[int]]:
        """Return an occupied object or the game's semantic empty-slot picture."""
        if not 0 <= champion < len(self.champion_pockets):
            raise ValueError("champion must be 0..15")
        if not 0 <= slot < 12:
            raise ValueError("inventory slot must be 0..11")
        object_code = self.champion_pockets[champion][slot]
        if object_code:
            return self.object_pocket_pixels(object_code)

        return self.empty_inventory_slot_pixels(
            champion, slot, ui_colour_index=ui_colour_index
        )

    def selected_party_shield_pixels(self, champion: int) -> list[list[int]]:
        """Compose the active-living shield surround without altering its face."""
        pixels = [
            list(row)
            for row in self.champions.shield_avatar(
                champion,
                ink15_colour=self.champions.party_shield_ink_colour(champion),
            ).pixels
        ]
        y, in_row = divmod(
            GFX_POCKETS_SELECTED_PARTY_SHIELD_OFFSET, POCKETS_SHEET_ROW_BYTES
        )
        x = in_row // 8 * 16
        frame = self.pockets.crop("selected_party_shield", x, y, 32, 41)
        blit(pixels, frame.pixels, 0, 0, transparent_index=0)
        return pixels

    def empty_inventory_slot_pixels(
        self, champion: int, slot: int, *, ui_colour_index: int | None = None
    ) -> list[list[int]]:
        """Return the semantic empty picture selected for an inventory slot."""
        if not 0 <= champion < len(self.champion_pockets):
            raise ValueError("champion must be 0..15")
        if not 0 <= slot < 12:
            raise ValueError("inventory slot must be 0..11")

        if slot < 2:
            worn_hand_armour = self.champions.record(champion).byte(0x12)
            if worn_hand_armour:
                definition_offset = worn_hand_armour * 4
                colour = self.object_definitions[definition_offset + 1] & 0x0F
                source = self.pockets.icon(0x1A + slot)
                return [
                    [colour if pixel == 0x0F else pixel for pixel in row]
                    for row in source.pixels
                ]

        placeholder = 0x6C + slot
        if slot == 3 and champion & 1:
            placeholder += 1
        pixels = self.pockets.icon(placeholder).pixels
        if ui_colour_index is not None:
            return remap_ui_template_colour(pixels, ui_colour_index)
        return pixels

    def save_colour_ramps(self) -> Path:
        destination = self.modified_root / "gfx-data/PlayerColourRamps.colours"
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_bytes(struct.pack(">24H", *self.colour_words))
        return destination
