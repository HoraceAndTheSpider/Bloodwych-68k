#!/usr/bin/env python3
"""Pygame data viewer for extracted Bloodwych graphics."""

from __future__ import annotations

import argparse
from dataclasses import dataclass
from pathlib import Path
from typing import Mapping, Sequence

from tools.data_overlay import (
    DataOverlayPath,
    data_overlay_root,
    related_data_roots,
)
from tools.dungeon_view import (
    DIRECTION_NAMES,
    DUNGEON_FEATURES,
    DUNGEON_SPACE_TYPES,
    WOOD_STATE_NAMES,
    DungeonAssets,
    DungeonPlacement,
    dungeon_features_for_map_type,
    dungeon_state_name,
    dungeon_variant_name,
    render_dungeon_scene,
)
from tools.graphics_preview import (
    AirbourneSpellAssets,
    BeholderAssets,
    CharacterAssets,
    CrabAssets,
    DragonAssets,
    LargeMonsterAssets,
    SummonAssets,
    VIEW_HEIGHT,
    VIEW_WIDTH,
    load_floor_ceiling_background,
    render_airbourne_spell,
    render_beholder,
    render_character_preview,
    render_monster_operations,
)
from tools.monster_view import (
    CENTRED_SUBPOSITIONS,
    FORMATION_SUBPOSITIONS,
    VIEW_CELL_COORDINATES,
    resolve_monster_screen_position,
    visible_subpositions,
)
from tools.st_planar_assets import GAME_PALETTE_RGB8


DATA_DIR = Path(__file__).resolve().parents[1] / "data"


class GraphicsViewerError(RuntimeError):
    """Raised when the viewer cannot load its optional runtime or data."""


WINDOW_SIZE = (1220, 760)
PREVIEW_SCALE = 5
FACING_NAMES = ("Front", "Side", "Back", "Mirrored side")
CATEGORY_NAMES = (
    "Character/Monster Graphics",
    "Dungeon Graphics",
    "Avatars",
    "Icons",
)
# The unmirrored Beholder side eye points screen-left; facing 3 mirrors it.
FACING_ARROW_DIRECTIONS = ((0, 1), (-1, 0), (0, -1), (1, 0))
# A dungeon overlay attached to a south-facing wall looks back north into the
# cell.  The arrow therefore shows the direction in which the visible face
# points, which is opposite the labelled N/E/S/W map side.
DUNGEON_DIRECTION_ARROW_DIRECTIONS = ((0, 1), (-1, 0), (0, -1), (1, 0))

CHARACTER_FILES = (
    "data/characters.heads",
    "data/characters.bodies",
    "data/characters.colours",
    "gfx/HeadParts.gfx",
    "gfx/BodyParts.gfx",
    "data/characters-body-definitions.layout",
    "data/characters-arm-animation.positions",
    "data/characters-render-table-offsets.lookup",
    "data/characters-part-variants.lookup",
    "data/characters-standard-render.layout",
    "data/characters-standard-distant-4.positions",
    "data/characters-standard-distant-5.positions",
    "data/characters-alternate-render.layout",
    "data/characters-alternate-distant-4.positions",
    "data/characters-alternate-distant-5.positions",
)

AIRBOURNE_SPELL_FILES = (
    "gfx/AirbourneFireball.gfx",
    "gfx/AirbourneSpells.gfx",
)


@dataclass(frozen=True)
class MonsterDefinition:
    code: int
    name: str
    gfx_files: tuple[str, ...]
    companion_files: tuple[str, ...]
    renderer: str | None = None
    note: str = ""
    version: str = "BLOODWYCH439"

    @property
    def display_name(self) -> str:
        return f"${self.code:02X}  {self.name}"

    @property
    def subpositions(self) -> tuple[int, ...]:
        # Draw_Character and monster codes below $67 preserve the four-person
        # formation. Draw_Behemoth onwards force d1=4, the centred position.
        return FORMATION_SUBPOSITIONS if self.code < 0x67 else CENTRED_SUBPOSITIONS


@dataclass(frozen=True)
class MonsterFileStatus:
    existing_gfx: tuple[str, ...]
    missing_gfx: tuple[str, ...]
    existing_companions: tuple[str, ...]
    missing_companions: tuple[str, ...]

    @property
    def ready(self) -> bool:
        return not self.missing_gfx and not self.missing_companions


@dataclass(frozen=True)
class AirbourneSpellDefinition:
    code: int
    name: str
    note: str = ""
    version: str = "BLOODWYCH439"
    false_data: bool = False


@dataclass(frozen=True)
class DungeonSelection:
    view_cell: int
    dungeon_x: int
    forward_distance: int
    screen_x: int = 0
    screen_y: int = 0
    gfx_slot: int = 0
    subposition_name: str = "whole cell"


BEHOLDER_COMPANIONS = (
    "Beholder_Body.offsets",
    "Beholder_Body.heights",
    "Beholder_UpperEyes.offsets",
    "Beholder_UpperEyes.heights",
    "Beholder_CentralEye_Near.offsets",
    "Beholder_CentralEye_Near_Front.heights",
    "Beholder_CentralEye_Near_Side.heights",
    "Beholder_CentralEye_Near_Y.positions",
    "Beholder_CentralEye_Near_Side_Y.positions",
    "Beholder_CentralEye_Near_Side_Mirrored_X.positions",
    "Beholder_CentralEye_Far.offsets",
    "Beholder_CentralEye_Far_Y.positions",
    "Beholder_CentralEye_Far_Side_Mirrored_X.positions",
    "Beholder_Composite_X.positions",
    "Beholder_Composite_Y.positions",
    "Beholder_Near_MirroredHalf_X.positions",
    "beholder.colours",
    "monsters.palette",
)

SUMMON_COMPANIONS = (
    "Summon.offsets",
    "Summon_Arms.offsets",
    "Summon_Body.layout",
    "Summon_ArmVariants.lookup",
    "Summon_Arms.heights",
    "Summon_PrimaryArm.positions",
    "Summon_SecondaryArm.positions",
    "summon.colours",
    "illusion.palette",
    "monsters.palette",
)

BEHEMOTH_COMPANIONS = (
    "Behemoth.offsets",
    "Behemoth_Claws.offsets",
    "Behemoth.layout",
    "Behemoth_LimbMirroring.flags",
    "behemoth.colours",
    "monsters.palette",
)

CRAB_COMPANIONS = (
    "Crab.offsets",
    "Crab_Front.layout",
    "Crab_SideNear.layout",
    "Crab_SideFar.layout",
    "Crab_FaceAndSideClaw.layout",
    "Crab_BackClaw.layout",
    "Crab_Body.layout",
    "Behemoth_Claws.offsets",
    "crab.colours",
    "monsters.palette",
)

DRAGON_COMPANIONS = (
    "Dragon.offsets",
    "Dragon_Body.layout",
    "Dragon_Claws.layout",
    "Dragon_Composite_XY.positions",
    "Dragon_Side_X.positions",
    "Dragon_MirroredHalf_X.positions",
    "dragon.colours",
    "monsters.palette",
)

ENTROPY_COMPANIONS = (
    "Entropy.offsets",
    "Entropy.layout",
    "Entropy_LimbMirroring.flags",
)


MONSTERS = (
    MonsterDefinition(
        0x64,
        "Summon",
        ("Summon.gfx",),
        SUMMON_COMPANIONS,
        renderer="summon",
        note="$64 and $65 share the Summon graphics renderer.",
    ),
    MonsterDefinition(
        0x65,
        "Summon variant",
        ("Summon.gfx",),
        SUMMON_COMPANIONS,
        renderer="summon",
        note="Uses the same graphics as $64; game state selects its variant.",
    ),
    MonsterDefinition(
        0x66,
        "Beholder",
        (
            "Beholder_Body.gfx",
            "Beholder_UpperEyes.gfx",
            "Beholder_CentralEye_Near.gfx",
            "Beholder_CentralEye_Far.gfx",
        ),
        BEHOLDER_COMPANIONS,
        renderer="beholder",
        note="Complete component, position, animation, and grade metadata.",
    ),
    MonsterDefinition(
        0x67,
        "Behemoth",
        ("Behemoth.gfx",),
        BEHEMOTH_COMPANIONS,
        renderer="behemoth",
    ),
    MonsterDefinition(
        0x68,
        "Crab",
        ("Crab.gfx", "CrabClaw.gfx", "Behemoth.gfx"),
        CRAB_COMPANIONS,
        renderer="crab",
    ),
    MonsterDefinition(
        0x69,
        "Large dragon",
        ("Dragon.gfx",),
        DRAGON_COMPANIONS,
        renderer="dragon_large",
        note="$69 and $6A share the extracted Dragon graphics block.",
    ),
    MonsterDefinition(
        0x6A,
        "Small dragon",
        ("Dragon.gfx",),
        DRAGON_COMPANIONS,
        renderer="dragon_small",
        note="$69 and $6A share the extracted Dragon graphics block.",
    ),
    MonsterDefinition(
        0x6B,
        "Entropy",
        ("Entropy.gfx",),
        ENTROPY_COMPANIONS,
        renderer="entropy",
    ),
    MonsterDefinition(
        0x6C,
        "Extended Entropy",
        ("Entropy.gfx",),
        ENTROPY_COMPANIONS,
        renderer="entropy",
        note="Expected in BEXT; not dispatched by the Bloodwych SPS 439 monster table.",
        version="BEXT43",
    ),
)


AIRBOURNE_SPELLS = (
    AirbourneSpellDefinition(0x80, "Fireball"),
    AirbourneSpellDefinition(0x81, "Wychwind"),
    AirbourneSpellDefinition(0x82, "Arc Bolt"),
    AirbourneSpellDefinition(0x83, "Disrupt"),
    AirbourneSpellDefinition(0x84, "Blaze"),
    AirbourneSpellDefinition(0x85, "Fireball"),
    AirbourneSpellDefinition(0x86, "Flying Vivify"),
    AirbourneSpellDefinition(0x87, "Firepath"),
    AirbourneSpellDefinition(0x88, "Arrow"),
    AirbourneSpellDefinition(0x89, "Elf Arrow"),
    AirbourneSpellDefinition(0x8A, "Missile"),
    AirbourneSpellDefinition(0x8B, "Confuse"),
    AirbourneSpellDefinition(0x8C, "Paralyze"),
    AirbourneSpellDefinition(0x8D, "Bigile"),
    AirbourneSpellDefinition(0x8E, "Full Spelltap"),
    AirbourneSpellDefinition(0x8F, "Terror"),
    AirbourneSpellDefinition(
        0x90,
        "Unknown black/white spell",
        note="No known gameplay effect; beyond the logical SPS 439 spell range.",
        false_data=True,
    ),
    AirbourneSpellDefinition(
        0x91,
        "Unknown red/yellow spell",
        note="No known gameplay effect; beyond the logical SPS 439 spell range.",
        false_data=True,
    ),
    AirbourneSpellDefinition(
        0x92,
        "Unknown green/yellow spell",
        note="No known gameplay effect; beyond the logical SPS 439 spell range.",
        false_data=True,
    ),
    AirbourneSpellDefinition(
        0x93,
        "Unknown blue/yellow spell",
        note="No known gameplay effect; beyond the logical SPS 439 spell range.",
        false_data=True,
    ),
    AirbourneSpellDefinition(0x94, "Vortex", version="BEXT43"),
    AirbourneSpellDefinition(0x95, "Spray", version="BEXT43"),
    AirbourneSpellDefinition(0x96, "Nullify", version="BEXT43"),
    AirbourneSpellDefinition(
        0x97,
        "Unknown BEXT spell",
        note="No confirmed gameplay effect.",
        version="BEXT43",
    ),
    AirbourneSpellDefinition(0x98, "Inferno", version="BEXT43"),
)


def is_bext_data_set(data_root: Path) -> bool:
    """Return whether the selected extracted data belongs to Extended Levels."""
    return data_root.name.upper().startswith("BEXT")


def monster_is_selectable(definition: MonsterDefinition, *, bext_loaded: bool) -> bool:
    return definition.version != "BEXT43" or bext_loaded


def spell_is_selectable(
    definition: AirbourneSpellDefinition, *, bext_loaded: bool
) -> bool:
    if definition.false_data:
        return False
    return definition.version != "BEXT43" or bext_loaded


def inspect_monster_files(definition: MonsterDefinition, monsters_dir: Path) -> MonsterFileStatus:
    def split(files: Sequence[str]) -> tuple[tuple[str, ...], tuple[str, ...]]:
        existing = tuple(name for name in files if (monsters_dir / name).is_file())
        missing = tuple(name for name in files if name not in existing)
        return existing, missing

    existing_gfx, missing_gfx = split(definition.gfx_files)
    existing_companions, missing_companions = split(definition.companion_files)
    return MonsterFileStatus(
        existing_gfx,
        missing_gfx,
        existing_companions,
        missing_companions,
    )


def modified_overrides(
    data_root: Path | DataOverlayPath, relative_files: Sequence[str]
) -> tuple[str, ...]:
    """Return the requested files currently supplied by the modified overlay."""
    overrides = []
    for name in relative_files:
        path = data_root / name
        if isinstance(path, DataOverlayPath) and path.uses_modified:
            overrides.append(name)
    return tuple(overrides)


def monster_grade_count(
    definition: MonsterDefinition, monsters_dir: Path | DataOverlayPath
) -> int:
    """Return the number of colour-grade steps available to one renderer."""
    if definition.code == 0x65 or definition.renderer == "entropy":
        return 1
    lookup_files = {
        "summon": "summon.colours",
        "beholder": "beholder.colours",
        "behemoth": "behemoth.colours",
        "crab": "crab.colours",
        "dragon_large": "dragon.colours",
        "dragon_small": "dragon.colours",
    }
    filename = lookup_files.get(definition.renderer)
    if filename is None:
        return 1
    try:
        return max(1, len((monsters_dir / filename).read_bytes()))
    except OSError:
        return 1


def indexed_to_surface(pygame: object, pixels: Sequence[Sequence[int]]) -> object:
    width = len(pixels[0]) if pixels else 0
    height = len(pixels)
    rgb = bytes(
        channel
        for row in pixels
        for index in row
        for channel in GAME_PALETTE_RGB8[index]
    )
    return pygame.image.fromstring(rgb, (width, height), "RGB")


def wrap_text(font: object, text: str, width: int) -> list[str]:
    lines: list[str] = []
    for paragraph in text.splitlines() or ("",):
        words = paragraph.split()
        current = ""
        for word in words:
            candidate = f"{current} {word}".strip()
            if current and font.size(candidate)[0] > width:
                lines.append(current)
                current = word
            else:
                current = candidate
        lines.append(current)
    return lines


def load_renderer_assets(monsters_dir: Path) -> tuple[dict[str, object], dict[str, str]]:
    """Load each shared renderer independently so one bad table does not hide the rest."""
    factories = {
        "beholder": lambda: BeholderAssets(monsters_dir),
        "summon": lambda: SummonAssets(monsters_dir),
        "behemoth": lambda: LargeMonsterAssets(monsters_dir, "Behemoth"),
        "entropy": lambda: LargeMonsterAssets(monsters_dir, "Entropy"),
        "crab": lambda: CrabAssets(monsters_dir),
        "dragon": lambda: DragonAssets(monsters_dir),
    }
    assets: dict[str, object] = {}
    errors: dict[str, str] = {}
    for name, factory in factories.items():
        try:
            assets[name] = factory()
        except (OSError, ValueError, RuntimeError) as error:
            errors[name] = str(error)
    return assets, errors


def load_character_assets(data_root: Path) -> tuple[CharacterAssets | None, str | None]:
    try:
        return CharacterAssets(data_root / "data", data_root / "gfx"), None
    except (OSError, ValueError, RuntimeError) as error:
        return None, str(error)


def load_airbourne_spell_assets(
    gfx_dir: Path | DataOverlayPath,
) -> tuple[AirbourneSpellAssets | None, str | None]:
    try:
        return AirbourneSpellAssets(gfx_dir), None
    except (OSError, ValueError, RuntimeError) as error:
        return None, str(error)


def render_monster_preview(
    background: Sequence[Sequence[int]],
    definition: MonsterDefinition,
    assets: dict[str, object],
    *,
    distance: int,
    facing: int,
    grade_step: int,
    animation_frame: int,
    anchor_x: int,
    anchor_y: int,
) -> tuple[list[list[int]], dict[str, object]]:
    """Dispatch one selected monster through its source-derived renderer."""
    render_flags = 3 if animation_frame else 0
    renderer = definition.renderer
    if renderer == "beholder":
        return render_beholder(
            background,
            assets["beholder"],
            distance,
            facing,
            grade_step=grade_step,
            animation_frame=animation_frame,
            anchor_x=anchor_x,
            anchor_y=anchor_y,
        )
    if renderer == "summon":
        summon = assets["summon"]
        operations = summon.draw_operations(distance, facing, render_flags=render_flags)
        palette = summon.replacement_palette(
            grade_step, illusion=definition.code == 0x65
        )
    elif renderer in {"behemoth", "entropy"}:
        large = assets[renderer]
        operations = large.draw_operations(distance, facing, render_flags=render_flags)
        palette = large.replacement_palette(grade_step)
    elif renderer == "crab":
        crab = assets["crab"]
        operations = crab.draw_operations(distance, facing, render_flags=render_flags)
        palette = crab.replacement_palette(grade_step)
    elif renderer in {"dragon_large", "dragon_small"}:
        dragon = assets["dragon"]
        operations = dragon.draw_operations(
            distance,
            facing,
            small=renderer == "dragon_small",
            render_flags=render_flags,
        )
        palette = dragon.replacement_palette(grade_step)
    else:
        raise ValueError(f"No renderer is configured for {definition.display_name}")
    return render_monster_operations(
        background,
        operations,
        palette,
        monster=definition.name,
        distance=distance,
        facing=facing,
        grade_step=grade_step,
        render_flags=render_flags,
        anchor_x=anchor_x,
        anchor_y=anchor_y,
    )


def launch_graphics_viewer(
    data_root: Path | None = None,
    *,
    screenshot_path: Path | None = None,
    prefer_modified: bool = False,
    initial_category: str = "character",
    initial_dungeon_feature: str = "stone",
    initial_dungeon_scene: Mapping[int, DungeonPlacement] | None = None,
    initial_dungeon_view_cell: int = 17,
) -> None:
    """Open the first SuperApp graphics viewer and return when it closes."""
    try:
        import pygame
    except ImportError as error:
        raise GraphicsViewerError(
            "Pygame is required for the graphics viewer. Install requirements.txt."
        ) from error

    requested_root = data_root or DATA_DIR / "BLOODWYCH439-clean"
    clean_root, modified_root, supplied_modified = related_data_roots(requested_root)
    if not (clean_root / "gfx").is_dir() or not (clean_root / "monsters").is_dir():
        raise GraphicsViewerError(f"Clean graphics viewer data is missing below {clean_root}")
    modified_available = modified_root.is_dir()
    use_modified = modified_available and (prefer_modified or supplied_modified)
    bext_loaded = is_bext_data_set(clean_root)

    def load_dataset(enabled: bool) -> tuple[
        DataOverlayPath,
        DataOverlayPath,
        DataOverlayPath,
        list[list[int]],
        dict[str, object],
        dict[str, str],
        CharacterAssets | None,
        str | None,
        AirbourneSpellAssets | None,
        str | None,
        DungeonAssets,
    ]:
        root = data_overlay_root(clean_root, modified_root, enabled=enabled)
        current_gfx_dir = root / "gfx"
        current_monsters_dir = root / "monsters"
        current_background = load_floor_ceiling_background(current_gfx_dir)
        current_renderers, current_renderer_errors = load_renderer_assets(
            current_monsters_dir
        )
        current_characters, current_character_error = load_character_assets(root)
        current_spells, current_spell_error = load_airbourne_spell_assets(
            current_gfx_dir
        )
        current_dungeon = DungeonAssets(current_gfx_dir)
        return (
            root,
            current_gfx_dir,
            current_monsters_dir,
            current_background,
            current_renderers,
            current_renderer_errors,
            current_characters,
            current_character_error,
            current_spells,
            current_spell_error,
            current_dungeon,
        )

    (
        dataset_root,
        gfx_dir,
        monsters_dir,
        background,
        renderer_assets,
        renderer_errors,
        character_assets,
        character_error,
        spell_assets,
        spell_error,
        dungeon_assets,
    ) = load_dataset(use_modified)

    pygame.init()
    pygame.key.set_repeat(250, 45)
    try:
        screen = pygame.display.set_mode(WINDOW_SIZE)
        pygame.display.set_caption("Bloodwych ReSource - Data Viewer")
        title_font = pygame.font.SysFont(None, 30)
        font = pygame.font.SysFont(None, 22)
        small_font = pygame.font.SysFont(None, 18)
        clock = pygame.time.Clock()

        selected_category = 1 if initial_category == "dungeon" else 0
        selected_index = 2
        selected_character = 0
        selected_spell_index = 0
        selected_dungeon_index = next(
            (
                index
                for index, feature in enumerate(DUNGEON_FEATURES)
                if feature.key == initial_dungeon_feature
            ),
            1,
        )
        selected_dungeon_map_type = int(
            DUNGEON_FEATURES[selected_dungeon_index].map_type or 0
        )
        selected_graphic_type = "dungeon" if initial_category == "dungeon" else "character"
        selected_view_cell = (
            initial_dungeon_view_cell
            if 0 <= initial_dungeon_view_cell < 18
            else 17
        )
        selected_subposition = 0
        facing = 0
        grade_step = 0
        animation_frame = 0
        dungeon_variant = 0
        dungeon_active = True
        dungeon_ceiling_hole = False
        wood_states = [0, 0, 3, 0]
        nudge_x = 0
        nudge_y = 0
        dungeon_scene: dict[int, DungeonPlacement] = {}
        if DUNGEON_FEATURES[selected_dungeon_index].key != "space":
            dungeon_scene[selected_view_cell] = DungeonPlacement(
                DUNGEON_FEATURES[selected_dungeon_index].key,
                facing,
                dungeon_variant,
                dungeon_active,
                tuple(wood_states),
            )
        if initial_dungeon_scene is not None:
            dungeon_scene = dict(initial_dungeon_scene)
            initial_placement = dungeon_scene.get(selected_view_cell)
            if initial_placement is not None:
                placed_feature = next(
                    feature
                    for feature in DUNGEON_FEATURES
                    if feature.key == initial_placement.feature_key
                )
                selected_dungeon_index = DUNGEON_FEATURES.index(placed_feature)
                selected_dungeon_map_type = int(placed_feature.map_type or 0)
                facing = initial_placement.direction
                dungeon_variant = initial_placement.variant
                dungeon_active = initial_placement.active
                dungeon_ceiling_hole = initial_placement.ceiling_hole
                wood_states = list(initial_placement.wood_states)
                nudge_x = initial_placement.nudge_x
                nudge_y = initial_placement.nudge_y
        overlay_error: str | None = None

        category_rects = (
            pygame.Rect(20, 52, 250, 34),
            pygame.Rect(280, 52, 190, 34),
            pygame.Rect(480, 52, 142, 34),
            pygame.Rect(632, 52, 142, 34),
        )
        overlay_rect = pygame.Rect(935, 52, 255, 34)
        character_rects = [
            pygame.Rect(20 + (index % 8) * 27, 112 + (index // 8) * 32, 25, 28)
            for index in range(0x56)
        ]
        reserved_character_rects = [
            (
                code,
                pygame.Rect(
                    20 + (code % 8) * 27,
                    112 + (code // 8) * 32,
                    25,
                    28,
                ),
            )
            for code in range(0x56, 0x64)
        ]
        monster_rects = [
            pygame.Rect(
                20 + (index % 8) * 27,
                112 + (13 + index // 8) * 32,
                25,
                28,
            )
            for index in range(len(MONSTERS))
        ]
        spell_rects = [
            pygame.Rect(
                20 + (index % 8) * 27,
                112 + (15 + index // 8) * 32,
                25,
                28,
            )
            for index in range(len(AIRBOURNE_SPELLS))
        ]
        dungeon_type_rects = [
            pygame.Rect(20, 128 + index * 39, 210, 34)
            for index in range(len(DUNGEON_SPACE_TYPES))
        ]
        control_specs = (
            ("facing_down", "Facing -", (270, 540, 90, 34)),
            ("facing_up", "Facing +", (366, 540, 90, 34)),
            ("grade_down", "Grade -", (468, 540, 88, 34)),
            ("grade_up", "Grade +", (562, 540, 88, 34)),
            ("state", "State", (662, 540, 120, 34)),
            ("frame", "Animate", (790, 540, 120, 34)),
            ("left", "X -", (270, 628, 70, 34)),
            ("right", "X +", (346, 628, 70, 34)),
            ("up", "Y -", (422, 628, 70, 34)),
            ("down", "Y +", (498, 628, 70, 34)),
            ("reset", "Reset offset", (574, 628, 112, 34)),
            ("back", "Back", (20, 724, 100, 30)),
        )
        controls = {
            name: (pygame.Rect(rectangle), label)
            for name, label, rectangle in control_specs
        }
        wood_control_rects = tuple(
            (
                direction_index,
                pygame.Rect(24, 514 + direction_index * 42, 98, 34),
                pygame.Rect(128, 514 + direction_index * 42, 104, 34),
            )
            for direction_index in range(4)
        )

        def current_dungeon_placement() -> DungeonPlacement:
            return DungeonPlacement(
                DUNGEON_FEATURES[selected_dungeon_index].key,
                facing,
                dungeon_variant,
                dungeon_active,
                tuple(wood_states),
                nudge_x,
                nudge_y,
                dungeon_ceiling_hole,
            )

        def adjust(action: str) -> bool:
            nonlocal facing, grade_step, animation_frame, nudge_x, nudge_y
            nonlocal dungeon_variant, dungeon_active, dungeon_ceiling_hole
            nonlocal wood_states
            if selected_graphic_type == "dungeon":
                feature = DUNGEON_FEATURES[selected_dungeon_index]
                if action == "facing_down":
                    facing = (facing - 1) % 4
                elif action == "facing_up":
                    facing = (facing + 1) % 4
                elif action == "grade_down":
                    dungeon_variant = (dungeon_variant - 1) % feature.variants
                elif action == "grade_up":
                    dungeon_variant = (dungeon_variant + 1) % feature.variants
                elif action == "state":
                    if feature.key in {"pit", "pad"}:
                        dungeon_ceiling_hole = not dungeon_ceiling_hole
                    elif feature.key in {
                        "shelf",
                        "switch",
                        "socket",
                        "door_metal",
                        "door_portcullis",
                    }:
                        dungeon_active = not dungeon_active
                    else:
                        return True
                elif action == "frame":
                    if selected_view_cell in dungeon_scene:
                        del dungeon_scene[selected_view_cell]
                    elif feature.key != "space":
                        dungeon_scene[selected_view_cell] = current_dungeon_placement()
                    return True
                elif action.startswith("wood_wall_"):
                    direction_index = int(action.rsplit("_", 1)[-1])
                    wood_states[direction_index] = (
                        0 if wood_states[direction_index] == 1 else 1
                    )
                elif action.startswith("wood_door_"):
                    direction_index = int(action.rsplit("_", 1)[-1])
                    wood_states[direction_index] = {
                        2: 3,
                        3: 2,
                    }.get(wood_states[direction_index], 3)
                elif action == "left":
                    nudge_x -= 1
                elif action == "right":
                    nudge_x += 1
                elif action == "up":
                    nudge_y -= 1
                elif action == "down":
                    nudge_y += 1
                elif action == "reset":
                    if feature.key == "wood":
                        wood_states = [0, 0, 3, 0]
                    else:
                        nudge_x = nudge_y = 0
                elif action == "back":
                    return False
                if selected_view_cell in dungeon_scene:
                    dungeon_scene[selected_view_cell] = current_dungeon_placement()
                return True
            if selected_graphic_type != "monster":
                if action in {"grade_down", "grade_up"}:
                    return True
            if selected_graphic_type == "spell" and action in {
                "facing_down",
                "facing_up",
                "frame",
            }:
                return True
            if action == "facing_down":
                facing = (facing - 1) % 4
            elif action == "facing_up":
                facing = (facing + 1) % 4
            elif action == "grade_down":
                grade_step = max(0, grade_step - 1)
            elif action == "grade_up":
                grade_step = min(
                    monster_grade_count(MONSTERS[selected_index], monsters_dir) - 1,
                    grade_step + 1,
                )
            elif action == "left":
                nudge_x -= 1
            elif action == "right":
                nudge_x += 1
            elif action == "up":
                nudge_y -= 1
            elif action == "down":
                nudge_y += 1
            elif action == "reset":
                nudge_x = nudge_y = 0
            elif action == "frame":
                animation_frame ^= 1
            elif action == "back":
                return False
            return True

        def reload_dataset(enabled: bool) -> None:
            nonlocal dataset_root, gfx_dir, monsters_dir, background
            nonlocal renderer_assets, renderer_errors
            nonlocal character_assets, character_error
            nonlocal spell_assets, spell_error
            nonlocal dungeon_assets
            nonlocal use_modified, grade_step, nudge_x, nudge_y, overlay_error
            (
                dataset_root,
                gfx_dir,
                monsters_dir,
                background,
                renderer_assets,
                renderer_errors,
                character_assets,
                character_error,
                spell_assets,
                spell_error,
                dungeon_assets,
            ) = load_dataset(enabled)
            use_modified = enabled
            grade_step = min(
                grade_step,
                monster_grade_count(MONSTERS[selected_index], monsters_dir) - 1,
            )
            nudge_x = nudge_y = 0
            overlay_error = None

        def choose_valid_subposition(subpositions: tuple[int, ...]) -> None:
            nonlocal selected_view_cell, selected_subposition, nudge_x, nudge_y
            available = visible_subpositions(selected_view_cell, subpositions)
            if selected_graphic_type == "character":
                available = tuple(
                    subposition
                    for subposition in available
                    if (
                        resolve_monster_screen_position(
                            selected_view_cell, subposition
                        ).gfx_slot
                        in range(6)
                    )
                )
            if selected_subposition in available:
                return
            preferred_cells = (16, 17, 15, 14) + tuple(range(18))
            for cell in preferred_cells:
                available = visible_subpositions(cell, subpositions)
                if selected_graphic_type == "character":
                    available = tuple(
                        subposition
                        for subposition in available
                        if resolve_monster_screen_position(cell, subposition).gfx_slot
                        in range(6)
                    )
                if available:
                    selected_view_cell = cell
                    selected_subposition = available[0]
                    break
            nudge_x = nudge_y = 0

        running = True
        while running:
            characters_active = selected_graphic_type == "character"
            monsters_active = selected_graphic_type == "monster"
            spells_active = selected_graphic_type == "spell"
            dungeons_active = selected_graphic_type == "dungeon"
            definition = MONSTERS[selected_index]
            spell_definition = AIRBOURNE_SPELLS[selected_spell_index]
            dungeon_definition = DUNGEON_FEATURES[selected_dungeon_index]
            dungeon_options = dungeon_features_for_map_type(
                selected_dungeon_map_type
            )
            dungeon_option_rects = [
                pygame.Rect(20, 470 + index * 38, 210, 34)
                for index in range(len(dungeon_options))
            ]
            if monsters_active:
                grade_step = min(
                    grade_step,
                    monster_grade_count(definition, monsters_dir) - 1,
                )
            if dungeons_active:
                subpositions = CENTRED_SUBPOSITIONS
            elif characters_active:
                subpositions = FORMATION_SUBPOSITIONS
            elif monsters_active:
                subpositions = definition.subpositions
            else:
                subpositions = CENTRED_SUBPOSITIONS
            if dungeons_active:
                dungeon_x, dungeon_y = VIEW_CELL_COORDINATES[selected_view_cell]
                screen_position = DungeonSelection(
                    selected_view_cell,
                    dungeon_x,
                    -dungeon_y,
                )
            else:
                choose_valid_subposition(subpositions)
                screen_position = resolve_monster_screen_position(
                    selected_view_cell, selected_subposition
                )
            if screen_position is None:
                raise GraphicsViewerError("No valid monster view position is available")
            preview_pixels = [row[:] for row in background]
            preview_metadata: dict[str, object] | None = None
            preview_error: str | None = None
            status = inspect_monster_files(definition, monsters_dir)
            renderer_key = None
            if dungeons_active:
                try:
                    preview_pixels, preview_metadata = render_dungeon_scene(
                        background,
                        dungeon_assets,
                        dungeon_scene,
                    )
                except (OSError, ValueError, RuntimeError, IndexError) as error:
                    preview_error = str(error)
            elif characters_active and character_assets is not None:
                try:
                    preview_pixels, preview_metadata = render_character_preview(
                        background,
                        character_assets,
                        selected_character,
                        distance=screen_position.gfx_slot,
                        facing=facing,
                        render_flags=3 if animation_frame else 0,
                        anchor_x=screen_position.screen_x + nudge_x,
                        anchor_y=screen_position.screen_y + nudge_y,
                    )
                except (OSError, ValueError, RuntimeError, IndexError) as error:
                    preview_error = str(error)
            elif characters_active:
                preview_error = character_error
            elif monsters_active:
                renderer_key = (
                    "dragon"
                    if definition.renderer in {"dragon_large", "dragon_small"}
                    else definition.renderer
                )
                if status.ready and renderer_key in renderer_assets:
                    try:
                        preview_pixels, preview_metadata = render_monster_preview(
                            background,
                            definition,
                            renderer_assets,
                            distance=screen_position.gfx_slot,
                            facing=facing,
                            grade_step=grade_step,
                            animation_frame=animation_frame,
                            anchor_x=screen_position.screen_x + nudge_x,
                            anchor_y=screen_position.screen_y + nudge_y,
                        )
                    except (OSError, ValueError, RuntimeError, IndexError) as error:
                        preview_error = str(error)
                elif renderer_key in renderer_errors:
                    preview_error = renderer_errors[renderer_key]
            elif spell_definition.code <= 0x8F and spell_assets is not None:
                try:
                    preview_pixels, preview_metadata = render_airbourne_spell(
                        background,
                        spell_assets,
                        spell_definition.code,
                        distance=screen_position.gfx_slot,
                        anchor_x=screen_position.screen_x + nudge_x,
                        anchor_y=screen_position.screen_y + nudge_y,
                    )
                except (OSError, ValueError, RuntimeError, IndexError) as error:
                    preview_error = str(error)
            elif spell_definition.code <= 0x8F:
                preview_error = spell_error
            else:
                preview_error = (
                    "BEXT flying-spell rendering requires the matching extracted "
                    "Extended Levels graphics data."
                )

            mouse = pygame.mouse.get_pos()
            screen.fill((24, 26, 31))
            screen.blit(
                title_font.render("Bloodwych Data Viewer", True, (240, 240, 245)),
                (20, 16),
            )

            for index, (name, rectangle) in enumerate(zip(CATEGORY_NAMES, category_rects)):
                active = index == selected_category
                colour = (54, 105, 170) if active else (52, 55, 63)
                pygame.draw.rect(screen, colour, rectangle, border_radius=4)
                suffix = " (planned)" if index >= 2 else ""
                text_colour = (245, 245, 245) if active else (150, 150, 155)
                label = small_font.render(name + suffix, True, text_colour)
                screen.blit(label, label.get_rect(center=rectangle.center))

            overlay_hovered = overlay_rect.collidepoint(mouse)
            if not modified_available:
                overlay_colour = (45, 47, 54)
                overlay_text = "Modified overlay unavailable"
                overlay_text_colour = (128, 130, 137)
            else:
                overlay_colour = (
                    (52, 126, 83)
                    if use_modified
                    else ((69, 112, 169) if overlay_hovered else (52, 76, 108))
                )
                overlay_text = (
                    "Modified overlay: ON" if use_modified else "Modified overlay: OFF"
                )
                overlay_text_colour = (250, 250, 250)
            pygame.draw.rect(screen, overlay_colour, overlay_rect, border_radius=4)
            overlay_label = small_font.render(
                overlay_text, True, overlay_text_colour
            )
            screen.blit(overlay_label, overlay_label.get_rect(center=overlay_rect.center))

            if use_modified:
                overlay_notice = (
                    "Sparse modified preview: missing files use clean data; patching still "
                    "requires a matching layout."
                )
                screen.blit(
                    small_font.render(overlay_notice, True, (230, 184, 105)),
                    (270, 91),
                )
            elif overlay_error:
                screen.blit(
                    small_font.render(
                        f"Could not load modified overlay: {overlay_error}",
                        True,
                        (244, 148, 135),
                    ),
                    (270, 91),
                )

            for character, rectangle in enumerate(character_rects):
                selected = characters_active and character == selected_character
                hovered = rectangle.collidepoint(mouse)
                colour = (
                    (61, 110, 174)
                    if selected
                    else ((58, 61, 70) if hovered else (43, 46, 54))
                )
                pygame.draw.rect(screen, colour, rectangle, border_radius=3)
                label = small_font.render(f"{character:02X}", True, (244, 244, 248))
                screen.blit(label, label.get_rect(center=rectangle.center))

            for code, rectangle in reserved_character_rects:
                pygame.draw.rect(screen, (35, 37, 43), rectangle, border_radius=3)
                label = small_font.render(f"{code:02X}", True, (91, 94, 102))
                screen.blit(label, label.get_rect(center=rectangle.center))

            for index, (definition_item, rectangle) in enumerate(
                zip(MONSTERS, monster_rects)
            ):
                enabled = monster_is_selectable(
                    definition_item, bext_loaded=bext_loaded
                )
                selected = monsters_active and index == selected_index
                hovered = rectangle.collidepoint(mouse)
                colour = (
                    (61, 110, 174)
                    if selected
                    else (
                        ((58, 61, 70) if hovered else (43, 46, 54))
                        if enabled
                        else (35, 37, 43)
                    )
                )
                pygame.draw.rect(screen, colour, rectangle, border_radius=3)
                label = small_font.render(
                    f"{definition_item.code:02X}",
                    True,
                    (244, 244, 248) if enabled else (91, 94, 102),
                )
                screen.blit(label, label.get_rect(center=rectangle.center))

            for index, (spell_item, rectangle) in enumerate(
                zip(AIRBOURNE_SPELLS, spell_rects)
            ):
                enabled = spell_is_selectable(spell_item, bext_loaded=bext_loaded)
                selected = spells_active and index == selected_spell_index
                hovered = rectangle.collidepoint(mouse)
                colour = (
                    (61, 110, 174)
                    if selected
                    else (
                        ((58, 61, 70) if hovered else (43, 46, 54))
                        if enabled
                        else (35, 37, 43)
                    )
                )
                pygame.draw.rect(screen, colour, rectangle, border_radius=3)
                label = small_font.render(
                    f"{spell_item.code:02X}",
                    True,
                    (244, 244, 248) if enabled else (91, 94, 102),
                )
                screen.blit(label, label.get_rect(center=rectangle.center))

            if dungeons_active:
                pygame.draw.rect(screen, (24, 26, 31), pygame.Rect(16, 100, 224, 610))
                screen.blit(
                    small_font.render("Space types", True, (178, 181, 189)),
                    (20, 106),
                )
                for space_type, rectangle in zip(
                    DUNGEON_SPACE_TYPES, dungeon_type_rects
                ):
                    selected = space_type.map_type == selected_dungeon_map_type
                    hovered = rectangle.collidepoint(mouse)
                    colour = (
                        (61, 110, 174)
                        if selected
                        else ((58, 61, 70) if hovered else (43, 46, 54))
                    )
                    pygame.draw.rect(screen, colour, rectangle, border_radius=3)
                    label = small_font.render(
                        f"{space_type.name} ({space_type.map_type})",
                        True,
                        (244, 244, 248),
                    )
                    screen.blit(label, label.get_rect(center=rectangle.center))
                screen.blit(
                    small_font.render("Options", True, (178, 181, 189)),
                    (20, 448),
                )
                for feature_item, rectangle in zip(
                    dungeon_options, dungeon_option_rects
                ):
                    selected = feature_item is dungeon_definition
                    hovered = rectangle.collidepoint(mouse)
                    colour = (
                        (61, 110, 174)
                        if selected
                        else ((58, 61, 70) if hovered else (43, 46, 54))
                    )
                    pygame.draw.rect(screen, colour, rectangle, border_radius=3)
                    label = small_font.render(
                        feature_item.name, True, (244, 244, 248)
                    )
                    screen.blit(label, label.get_rect(center=rectangle.center))
                if dungeon_definition.key == "wood":
                    for direction_index, wall_rect, door_rect in wood_control_rects:
                        state = wood_states[direction_index]
                        direction = DIRECTION_NAMES[direction_index][0]
                        wall_label = f"{direction} wall {'ON' if state == 1 else 'OFF'}"
                        door_state = {
                            2: "OPEN",
                            3: "CLOSED",
                        }.get(state, "ADD")
                        door_label = f"{direction} door {door_state}"
                        for rectangle, text, selected in (
                            (wall_rect, wall_label, state == 1),
                            (door_rect, door_label, state in {2, 3}),
                        ):
                            hovered = rectangle.collidepoint(mouse)
                            colour = (
                                (61, 110, 174)
                                if selected
                                else ((58, 61, 70) if hovered else (43, 46, 54))
                            )
                            pygame.draw.rect(screen, colour, rectangle, border_radius=3)
                            label = small_font.render(text, True, (244, 244, 248))
                            screen.blit(label, label.get_rect(center=rectangle.center))

            preview_rect = pygame.Rect(
                270,
                112,
                VIEW_WIDTH * PREVIEW_SCALE,
                VIEW_HEIGHT * PREVIEW_SCALE,
            )
            pygame.draw.rect(screen, (8, 8, 10), preview_rect.inflate(6, 6))
            native_surface = indexed_to_surface(pygame, preview_pixels)
            scaled_surface = pygame.transform.scale(native_surface, preview_rect.size)
            screen.blit(scaled_surface, preview_rect)

            if preview_metadata is None:
                overlay = pygame.Surface(preview_rect.size, pygame.SRCALPHA)
                overlay.fill((0, 0, 0, 125))
                screen.blit(overlay, preview_rect)
                message = "Renderer unavailable: required source data is listed on the right."
                if preview_error:
                    message = f"Renderer error: {preview_error}"
                y = preview_rect.centery - 22
                for line in wrap_text(font, message, preview_rect.width - 60):
                    text_surface = font.render(line, True, (255, 220, 145))
                    screen.blit(
                        text_surface,
                        text_surface.get_rect(center=(preview_rect.centerx, y)),
                    )
                    y += 24

            lane_name = (
                "centre lane"
                if screen_position.dungeon_x == 0
                else f"lane {screen_position.dungeon_x:+d}"
            )
            if dungeons_active:
                status_text = (
                    f"{dungeon_definition.name}  |  "
                    f"{screen_position.forward_distance} ahead, {lane_name}  |  "
                    f"view cell {selected_view_cell}  |  "
                    f"{DIRECTION_NAMES[facing]}"
                )
            elif characters_active and preview_metadata:
                status_text = (
                    f"${selected_character:02X} character  |  "
                    f"body ${preview_metadata['body_design']:02X}  |  "
                    f"head ${preview_metadata['head_design']:02X}  |  "
                    f"anchor ({screen_position.screen_x + nudge_x}, "
                    f"{screen_position.screen_y + nudge_y})"
                )
            elif spells_active:
                status_text = (
                    f"${spell_definition.code:02X} {spell_definition.name}  |  "
                    f"{screen_position.forward_distance} ahead, {lane_name}  |  "
                    f"image {screen_position.gfx_slot}  |  "
                    f"anchor ({screen_position.screen_x + nudge_x}, "
                    f"{screen_position.screen_y + nudge_y})"
                )
            else:
                status_text = (
                    f"{screen_position.forward_distance} ahead, {lane_name}  |  "
                    f"{screen_position.subposition_name}  |  image {screen_position.gfx_slot}  |  "
                    f"anchor ({screen_position.screen_x + nudge_x}, "
                    f"{screen_position.screen_y + nudge_y})"
                )
            screen.blit(font.render(status_text, True, (225, 225, 230)), (270, 503))

            for action, (rectangle, label_text) in controls.items():
                if dungeons_active:
                    state_labels = {
                        "shelf": "Conceal shelf" if dungeon_active else "Show shelf",
                        "switch": "Set dim" if dungeon_active else "Set lit",
                        "socket": "Remove gem" if dungeon_active else "Insert gem",
                        "door_metal": "Open door" if dungeon_active else "Close door",
                        "door_portcullis": "Open door" if dungeon_active else "Close door",
                        "pit": (
                            "Remove ceiling" if dungeon_ceiling_hole else "Add ceiling"
                        ),
                        "pad": (
                            "Remove ceiling" if dungeon_ceiling_hole else "Add ceiling"
                        ),
                    }
                    dungeon_labels = {
                        "facing_down": "Rotate -",
                        "facing_up": "Rotate +",
                        "grade_down": "Variant -",
                        "grade_up": "Variant +",
                        "state": state_labels.get(dungeon_definition.key, "No state"),
                        "frame": (
                            "Clear cell"
                            if selected_view_cell in dungeon_scene
                            else "Place cell"
                        ),
                        "left": "X -",
                        "right": "X +",
                        "up": "Y -",
                        "down": "Y +",
                        "reset": "Reset sides" if dungeon_definition.key == "wood" else "Reset offset",
                        "back": "Back",
                    }
                    label_text = dungeon_labels[action]
                hovered = rectangle.collidepoint(mouse)
                disabled = (
                    characters_active and action in {"grade_down", "grade_up"}
                ) or (
                    spells_active
                    and action
                    in {
                        "facing_down",
                        "facing_up",
                        "grade_down",
                        "grade_up",
                        "frame",
                    }
                ) or (
                    dungeons_active
                    and action in {"grade_down", "grade_up"}
                    and dungeon_definition.variants <= 1
                ) or (
                    dungeons_active
                    and action == "state"
                    and dungeon_definition.key
                    not in {
                        "shelf",
                        "switch",
                        "socket",
                        "door_metal",
                        "door_portcullis",
                        "pit",
                        "pad",
                    }
                )
                colour = (
                    (45, 47, 54)
                    if disabled
                    else ((69, 112, 169) if hovered else (52, 76, 108))
                )
                pygame.draw.rect(screen, colour, rectangle, border_radius=4)
                text_colour = (128, 130, 137) if disabled else (250, 250, 250)
                label = font.render(label_text, True, text_colour)
                screen.blit(label, label.get_rect(center=rectangle.center))

            if dungeons_active:
                if dungeon_definition.key == "wood":
                    states = " | ".join(
                        f"{direction[0]}: {WOOD_STATE_NAMES[state]}"
                        for direction, state in zip(DIRECTION_NAMES, wood_states)
                    )
                    help_text = (
                        "Wall toggles that side on/off; Door adds a closed door, "
                        "then switches it open/closed. " + states
                    )
                else:
                    help_text = (
                        "Select a cell, choose an option, then Place/Clear cell. "
                        "Occupied cells retain their own direction and variant."
                    )
            elif characters_active:
                help_text = (
                    "All six source distances and four facings. Animate toggles "
                    "the independent arm variants."
                )
            elif monsters_active:
                help_text = (
                    f"Facing: {FACING_NAMES[facing]}  |  grade: base +{grade_step}.  "
                    "Click a mini-space; arrow keys apply a one-pixel preview offset."
                )
            else:
                help_text = (
                    "Source distance geometry and spell colour mask. Click a visible "
                    "space; arrow keys apply a one-pixel preview offset."
                )
            screen.blit(small_font.render(help_text, True, (178, 181, 189)), (270, 590))

            details_x = 935
            screen.blit(
                font.render(
                    (
                        "Dungeon source view position"
                        if dungeons_active
                        else (
                            "Character source view position"
                            if characters_active
                            else (
                                "Spell source view position"
                                if spells_active
                                else "Source-verified view position"
                            )
                        )
                    ),
                    True,
                    (240, 240, 245),
                ),
                (details_x, 112),
            )

            grid_left = 946
            grid_top = 142
            cell_size = 43
            slot_margin = 3
            slot_gap = 2
            slot_size = (cell_size - slot_margin * 2 - slot_gap) // 2
            slot_quadrants = {
                2: (0, 0),  # rear left
                3: (1, 0),  # rear right
                1: (0, 1),  # near left
                0: (1, 1),  # near right
            }
            slot_hit_rects: list[tuple[object, int, int]] = []

            for column, lane in enumerate(("-2", "-1", "0", "+1", "+2")):
                label = small_font.render(lane, True, (142, 147, 157))
                label_x = grid_left + column * cell_size + (cell_size - 2) // 2
                screen.blit(label, label.get_rect(center=(label_x, grid_top - 7)))
            for forward_distance in range(4, 0, -1):
                label_y = grid_top + (4 - forward_distance) * cell_size + 12
                screen.blit(
                    small_font.render(str(forward_distance), True, (142, 147, 157)),
                    (grid_left - 11, label_y),
                )

            def draw_facing_arrow(rectangle: object) -> None:
                displayed_facing = facing
                directions = (
                    DUNGEON_DIRECTION_ARROW_DIRECTIONS
                    if dungeons_active
                    else FACING_ARROW_DIRECTIONS
                )
                direction_x, direction_y = directions[displayed_facing]
                centre = pygame.Vector2(rectangle.center)
                direction = pygame.Vector2(direction_x, direction_y)
                start = centre - direction * 4
                end = centre + direction * 6
                pygame.draw.line(screen, (255, 238, 120), start, end, 2)
                perpendicular = pygame.Vector2(-direction_y, direction_x)
                points = (
                    end,
                    end - direction * 4 + perpendicular * 3,
                    end - direction * 4 - perpendicular * 3,
                )
                pygame.draw.polygon(screen, (255, 238, 120), points)

            for view_cell, (dungeon_x, dungeon_y) in enumerate(VIEW_CELL_COORDINATES[:18]):
                forward_distance = -dungeon_y
                if not 1 <= forward_distance <= 4:
                    continue
                cell_rect = pygame.Rect(
                    grid_left + (dungeon_x + 2) * cell_size,
                    grid_top + (4 - forward_distance) * cell_size,
                    cell_size - 2,
                    cell_size - 2,
                )
                available = visible_subpositions(view_cell, subpositions)
                if dungeons_active:
                    available = (4,)
                elif characters_active:
                    available = tuple(
                        subposition
                        for subposition in available
                        if resolve_monster_screen_position(view_cell, subposition).gfx_slot
                        in range(6)
                    )
                cell_colour = (41, 47, 57) if available else (29, 32, 38)
                pygame.draw.rect(screen, cell_colour, cell_rect)
                pygame.draw.rect(screen, (73, 81, 95), cell_rect, 1)

                if subpositions == CENTRED_SUBPOSITIONS:
                    centre_rect = pygame.Rect(0, 0, 17, 17)
                    centre_rect.center = cell_rect.center
                    if 4 in available:
                        selected = selected_view_cell == view_cell
                        placement = dungeon_scene.get(view_cell) if dungeons_active else None
                        colour = (222, 116, 55) if selected else (65, 113, 167)
                        if placement is not None:
                            pygame.draw.rect(screen, colour, centre_rect, border_radius=3)
                            placed_feature = next(
                                item
                                for item in DUNGEON_FEATURES
                                if item.key == placement.feature_key
                            )
                            type_label = small_font.render(
                                str(placed_feature.map_type), True, (250, 250, 250)
                            )
                            screen.blit(
                                type_label,
                                type_label.get_rect(center=centre_rect.center),
                            )
                        else:
                            pygame.draw.ellipse(screen, colour, centre_rect, 2)
                        slot_hit_rects.append((centre_rect, view_cell, 4))
                        if selected and not spells_active:
                            draw_facing_arrow(centre_rect)
                    continue

                for subposition, (column, row) in slot_quadrants.items():
                    slot_rect = pygame.Rect(
                        cell_rect.x + slot_margin + column * (slot_size + slot_gap),
                        cell_rect.y + slot_margin + row * (slot_size + slot_gap),
                        slot_size,
                        slot_size,
                    )
                    if subposition in available:
                        selected = (
                            selected_view_cell == view_cell
                            and selected_subposition == subposition
                        )
                        colour = (222, 116, 55) if selected else (65, 113, 167)
                        if slot_rect.collidepoint(mouse) and not selected:
                            colour = (80, 137, 199)
                        pygame.draw.rect(screen, colour, slot_rect, border_radius=2)
                        slot_hit_rects.append((slot_rect, view_cell, subposition))
                        if selected:
                            draw_facing_arrow(slot_rect)
                    else:
                        pygame.draw.rect(screen, (24, 27, 32), slot_rect, 1)

            player_rect = pygame.Rect(
                grid_left + 2 * cell_size + 10,
                grid_top + 4 * cell_size + 4,
                20,
                20,
            )
            pygame.draw.rect(screen, (202, 98, 48), player_rect, border_radius=4)
            pygame.draw.line(
                screen,
                (255, 230, 100),
                (player_rect.centerx, player_rect.y + 4),
                (player_rect.centerx, player_rect.y - 5),
                2,
            )
            pygame.draw.polygon(
                screen,
                (255, 230, 100),
                (
                    (player_rect.centerx, player_rect.y - 8),
                    (player_rect.centerx - 4, player_rect.y - 2),
                    (player_rect.centerx + 4, player_rect.y - 2),
                ),
            )
            screen.blit(
                small_font.render(
                    (
                        "Blue = cells  |  orange = feature direction"
                        if dungeons_active
                        else (
                            "Blue = available  |  orange arrow = character facing"
                            if characters_active
                            else (
                                "Blue = visible  |  orange = selected spell position"
                                if spells_active
                                else "Blue = visible  |  orange arrow = monster facing"
                            )
                        )
                    ),
                    True,
                    (178, 181, 189),
                ),
                (details_x, 345),
            )

            details_title = (
                dungeon_definition.name
                if dungeons_active
                else (
                    f"${selected_character:02X}  Character"
                    if characters_active
                    else (
                        f"${spell_definition.code:02X}  Airbourne spell"
                        if spells_active
                        else f"${definition.code:02X}  Monster"
                    )
                )
            )
            screen.blit(
                title_font.render(details_title, True, (240, 240, 245)),
                (details_x, 374),
            )
            details_y = 408

            def detail_block(
                title: str,
                values: Sequence[str],
                colour: tuple[int, int, int],
            ) -> None:
                nonlocal details_y
                if details_y > WINDOW_SIZE[1] - 24:
                    return
                screen.blit(font.render(title, True, colour), (details_x, details_y))
                details_y += 22
                if not values:
                    values = ("None",)
                for value in values:
                    for line in wrap_text(small_font, value, 255):
                        if details_y > WINDOW_SIZE[1] - 20:
                            return
                        screen.blit(
                            small_font.render(line, True, (204, 206, 212)),
                            (details_x + 8, details_y),
                        )
                        details_y += 18
                details_y += 7

            if dungeons_active:
                existing_files = tuple(
                    name
                    for name in dungeon_definition.files
                    if (gfx_dir / name).is_file()
                )
                missing_files = tuple(
                    name
                    for name in dungeon_definition.files
                    if name not in existing_files
                )
                detail_block(
                    "Source data",
                    (f"{len(existing_files)} files present",),
                    (126, 218, 151),
                )
                detail_block("Missing data", missing_files, (244, 148, 135))
                if use_modified:
                    overrides = modified_overrides(
                        dataset_root,
                        tuple(f"gfx/{name}" for name in dungeon_definition.files),
                    )
                    detail_block(
                        "Modified overlay",
                        (f"{len(overrides)} files; remaining files are clean",),
                        (230, 184, 105),
                    )
                map_type = (
                    "Logical/non-static"
                    if dungeon_definition.map_type is None
                    else f"Map type {dungeon_definition.map_type}"
                )
                detail_block(
                    "Map definition",
                    (
                        f"{map_type}: {DUNGEON_SPACE_TYPES[selected_dungeon_map_type].name}",
                        f"Option: {dungeon_definition.name}",
                        f"Direction: {DIRECTION_NAMES[facing]}",
                        (
                            f"Variant: {dungeon_variant % dungeon_definition.variants} "
                            f"({dungeon_variant_name(dungeon_definition, dungeon_variant)})"
                        ),
                        (
                            "State: "
                            + dungeon_state_name(
                                dungeon_definition,
                                dungeon_active,
                                ceiling_hole=dungeon_ceiling_hole,
                            )
                        ),
                    ),
                    (155, 188, 239),
                )
                selected_placement = dungeon_scene.get(selected_view_cell)
                detail_block(
                    "Scene",
                    (
                        f"{len(dungeon_scene)} occupied cells",
                        (
                            f"Selected cell: {selected_placement.feature_key}"
                            if selected_placement is not None
                            else "Selected cell: empty"
                        ),
                    ),
                    (155, 188, 239),
                )
                if dungeon_definition.key == "wood":
                    detail_block(
                        "N/E/S/W sides",
                        tuple(
                            f"{direction}: {WOOD_STATE_NAMES[state]}"
                            for direction, state in zip(DIRECTION_NAMES, wood_states)
                        ),
                        (155, 188, 239),
                    )
                detail_block(
                    "Notes", (dungeon_definition.note,), (155, 188, 239)
                )
                if preview_error:
                    detail_block("Renderer error", (preview_error,), (244, 184, 115))
            elif characters_active:
                existing_character_files = tuple(
                    name for name in CHARACTER_FILES if (dataset_root / name).is_file()
                )
                missing_character_files = tuple(
                    name for name in CHARACTER_FILES if name not in existing_character_files
                )
                detail_block(
                    "Character data",
                    (f"{len(existing_character_files)} files present",),
                    (126, 218, 151),
                )
                detail_block(
                    "Missing data",
                    missing_character_files,
                    (244, 148, 135),
                )
                if use_modified:
                    overrides = modified_overrides(dataset_root, CHARACTER_FILES)
                    detail_block(
                        "Modified overlay",
                        (f"{len(overrides)} files; remaining files are clean",),
                        (230, 184, 105),
                    )
                if preview_metadata:
                    body_design = int(preview_metadata["body_design"])
                    body_layout = str(preview_metadata["body_layout"])
                    detail_block(
                        "Selections",
                        (
                            f"Body design ${body_design:02X} ({body_layout})",
                            f"Head design ${int(preview_metadata['head_design']):02X}",
                        ),
                        (155, 188, 239),
                    )
                    palette_names = ("head", "legs", "torso", "arms", "distant")
                    palettes = tuple(
                        f"{name}: {values}"
                        for name, values in zip(
                            palette_names, preview_metadata["palettes"]
                        )
                    )
                    detail_block("Colour masks", palettes, (155, 188, 239))
                if preview_error:
                    detail_block("Renderer error", (preview_error,), (244, 184, 115))
            elif monsters_active:
                graphics_present = status.existing_gfx
                if len(graphics_present) > 2:
                    graphics_present = (f"{len(graphics_present)} files",)
                detail_block("Graphics present", graphics_present, (126, 218, 151))
                detail_block("Graphics missing", status.missing_gfx, (244, 148, 135))
                companion_summary = status.existing_companions
                if len(companion_summary) > 6:
                    companion_summary = (f"{len(companion_summary)} files (complete)",)
                detail_block("Companions present", companion_summary, (126, 218, 151))
                detail_block("Companions missing", status.missing_companions, (244, 184, 115))
                if use_modified:
                    monster_files = tuple(
                        f"monsters/{name}"
                        for name in definition.gfx_files + definition.companion_files
                    )
                    overrides = modified_overrides(dataset_root, monster_files)
                    detail_block(
                        "Modified overlay",
                        (f"{len(overrides)} files; remaining files are clean",),
                        (230, 184, 105),
                    )
                notes = (f"Name: {definition.name}",)
                if definition.note:
                    notes += (definition.note,)
                detail_block("Notes", notes, (155, 188, 239))
                if definition.version != "BLOODWYCH439":
                    detail_block("Version", (definition.version,), (155, 188, 239))
                if preview_metadata:
                    palette = preview_metadata["replacement_palette_indices"]
                    detail_block("Selected palette", (str(palette),), (155, 188, 239))
            else:
                existing_spell_files = tuple(
                    name for name in AIRBOURNE_SPELL_FILES if (dataset_root / name).is_file()
                )
                missing_spell_files = tuple(
                    name for name in AIRBOURNE_SPELL_FILES if name not in existing_spell_files
                )
                detail_block(
                    "Spell graphics",
                    existing_spell_files,
                    (126, 218, 151),
                )
                detail_block("Missing data", missing_spell_files, (244, 148, 135))
                if use_modified:
                    overrides = modified_overrides(dataset_root, AIRBOURNE_SPELL_FILES)
                    detail_block(
                        "Modified overlay",
                        (f"{len(overrides)} files; remaining files are clean",),
                        (230, 184, 105),
                    )
                notes = (f"Name: {spell_definition.name}",)
                if spell_definition.note:
                    notes += (spell_definition.note,)
                detail_block("Notes", notes, (155, 188, 239))
                if spell_definition.version != "BLOODWYCH439":
                    detail_block(
                        "Version", (spell_definition.version,), (155, 188, 239)
                    )
                if preview_metadata:
                    detail_block(
                        "Selected palette",
                        (str(preview_metadata["replacement_palette_indices"]),),
                        (155, 188, 239),
                    )
                if preview_error:
                    detail_block("Renderer error", (preview_error,), (244, 184, 115))

            pygame.display.flip()
            if screenshot_path is not None:
                screenshot_path.parent.mkdir(parents=True, exist_ok=True)
                pygame.image.save(screen, str(screenshot_path))
                running = False
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
                elif event.type == pygame.KEYDOWN:
                    keyboard_actions = {
                        pygame.K_LEFT: "left",
                        pygame.K_RIGHT: "right",
                        pygame.K_UP: "up",
                        pygame.K_DOWN: "down",
                        pygame.K_ESCAPE: "back",
                    }
                    if event.key in keyboard_actions:
                        running = adjust(keyboard_actions[event.key])
                elif event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
                    if overlay_rect.collidepoint(event.pos) and modified_available:
                        try:
                            reload_dataset(not use_modified)
                        except (OSError, ValueError, RuntimeError, IndexError) as error:
                            overlay_error = str(error)
                        continue
                    for index, rectangle in enumerate(category_rects):
                        if rectangle.collidepoint(event.pos) and index in {0, 1}:
                            selected_category = index
                            selected_graphic_type = (
                                "dungeon" if index == 1 else "character"
                            )
                            nudge_x = nudge_y = 0
                            break
                    if dungeons_active:
                        for space_type, rectangle in zip(
                            DUNGEON_SPACE_TYPES, dungeon_type_rects
                        ):
                            if rectangle.collidepoint(event.pos):
                                selected_dungeon_map_type = space_type.map_type
                                first_option = dungeon_features_for_map_type(
                                    selected_dungeon_map_type
                                )[0]
                                selected_dungeon_index = DUNGEON_FEATURES.index(
                                    first_option
                                )
                                selected_graphic_type = "dungeon"
                                dungeon_variant = 0
                                dungeon_active = True
                                dungeon_ceiling_hole = False
                                nudge_x = nudge_y = 0
                                break
                        for feature_item, rectangle in zip(
                            dungeon_options, dungeon_option_rects
                        ):
                            if rectangle.collidepoint(event.pos):
                                selected_dungeon_index = DUNGEON_FEATURES.index(
                                    feature_item
                                )
                                selected_graphic_type = "dungeon"
                                dungeon_variant = 0
                                dungeon_active = True
                                dungeon_ceiling_hole = False
                                nudge_x = nudge_y = 0
                                break
                        if dungeon_definition.key == "wood":
                            for direction_index, wall_rect, door_rect in wood_control_rects:
                                if wall_rect.collidepoint(event.pos):
                                    adjust(f"wood_wall_{direction_index}")
                                    break
                                if door_rect.collidepoint(event.pos):
                                    adjust(f"wood_door_{direction_index}")
                                    break
                    for character, rectangle in enumerate(character_rects):
                        if rectangle.collidepoint(event.pos) and not dungeons_active:
                            selected_character = character
                            selected_graphic_type = "character"
                            nudge_x = nudge_y = 0
                            break
                    for index, (definition_item, rectangle) in enumerate(
                        zip(MONSTERS, monster_rects)
                    ):
                        if (
                            rectangle.collidepoint(event.pos)
                            and not dungeons_active
                            and monster_is_selectable(
                            definition_item, bext_loaded=bext_loaded
                            )
                        ):
                            selected_index = index
                            selected_graphic_type = "monster"
                            nudge_x = nudge_y = 0
                            break
                    for index, (spell_item, rectangle) in enumerate(
                        zip(AIRBOURNE_SPELLS, spell_rects)
                    ):
                        if (
                            rectangle.collidepoint(event.pos)
                            and not dungeons_active
                            and spell_is_selectable(
                            spell_item, bext_loaded=bext_loaded
                            )
                        ):
                            selected_spell_index = index
                            selected_graphic_type = "spell"
                            nudge_x = nudge_y = 0
                            break
                    for rectangle, view_cell, subposition in slot_hit_rects:
                        if rectangle.collidepoint(event.pos):
                            selected_view_cell = view_cell
                            selected_subposition = subposition
                            if dungeons_active and view_cell in dungeon_scene:
                                placement = dungeon_scene[view_cell]
                                placed_feature = next(
                                    item
                                    for item in DUNGEON_FEATURES
                                    if item.key == placement.feature_key
                                )
                                selected_dungeon_index = DUNGEON_FEATURES.index(
                                    placed_feature
                                )
                                selected_dungeon_map_type = int(
                                    placed_feature.map_type or 0
                                )
                                facing = placement.direction
                                dungeon_variant = placement.variant
                                dungeon_active = placement.active
                                dungeon_ceiling_hole = placement.ceiling_hole
                                wood_states = list(placement.wood_states)
                                nudge_x = placement.nudge_x
                                nudge_y = placement.nudge_y
                            else:
                                nudge_x = nudge_y = 0
                            break
                    for action, (rectangle, _) in controls.items():
                        if rectangle.collidepoint(event.pos):
                            running = adjust(action)
                            break
            clock.tick(60)
    finally:
        pygame.quit()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--data-root", type=Path)
    parser.add_argument(
        "--modified",
        action="store_true",
        help="start with the sparse modified-data overlay enabled",
    )
    parser.add_argument(
        "--screenshot",
        type=Path,
        help="save the initial viewer frame and exit (useful for visual testing)",
    )
    parser.add_argument(
        "--dungeon",
        action="store_true",
        help="open the Dungeon Graphics category",
    )
    parser.add_argument(
        "--dungeon-feature",
        choices=tuple(feature.key for feature in DUNGEON_FEATURES),
        default="stone",
        help="initial dungeon option (primarily useful with --screenshot)",
    )
    args = parser.parse_args()
    launch_graphics_viewer(
        args.data_root,
        screenshot_path=args.screenshot,
        prefer_modified=args.modified,
        initial_category="dungeon" if args.dungeon else "character",
        initial_dungeon_feature=args.dungeon_feature,
    )


if __name__ == "__main__":
    main()
