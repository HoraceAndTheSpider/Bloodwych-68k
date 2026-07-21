from __future__ import annotations

import unittest

from tools.gamefont_converter import EXPECTED_SIZE, glyph_pixels, read_font
from tools.graphics_preview import (
    BeholderAssets,
    CharacterAssets,
    decode_fixed_sprites,
    load_floor_ceiling_background,
    remap_template_colours,
    render_beholder,
    render_character_preview,
)
from tools.st_planar_assets import decode_planar, encode_planar, read_tables
from tools.graphics_viewer import (
    CATEGORY_NAMES,
    MONSTERS,
    inspect_monster_files,
    load_character_assets,
    load_renderer_assets,
    render_monster_preview,
)
from tools.tool_common import BINARIES_DIR, DATA_DIR


GFX_DIR = DATA_DIR / "BLOODWYCH439-clean" / "gfx"
MONSTERS_DIR = DATA_DIR / "BLOODWYCH439-clean" / "monsters"
CHARACTER_DATA_DIR = DATA_DIR / "BLOODWYCH439-clean" / "data"


class GraphicsCodecTests(unittest.TestCase):
    def test_characters_are_the_first_graphics_viewer_category(self) -> None:
        self.assertEqual(CATEGORY_NAMES[:2], ("Characters", "Monsters"))
        assets, error = load_character_assets(DATA_DIR / "BLOODWYCH439-clean")
        self.assertIsNotNone(assets)
        self.assertIsNone(error)

    def test_gamefont_layout_and_known_a_glyph(self) -> None:
        data = read_font(GFX_DIR / "GameFont")
        self.assertEqual(len(data), EXPECTED_SIZE)
        self.assertEqual(
            data[ord("A") * 5 : (ord("A") + 1) * 5],
            bytes.fromhex("0c123f2133"),
        )
        self.assertEqual(len(glyph_pixels(data, ord("A"))), 5)

    def test_main_walls_tables_partition_and_round_trip(self) -> None:
        gfx, offsets, positions = read_tables(
            GFX_DIR / "Main_Walls.gfx",
            GFX_DIR / "Main_Walls.offsets",
            GFX_DIR / "Main_Walls.positions",
        )
        self.assertEqual(len(offsets), 28)
        self.assertEqual(len(positions), 28)

        for index, (offset, (_, _, width_minus_1, height_minus_1)) in enumerate(
            zip(offsets, positions)
        ):
            width_words = width_minus_1 + 1
            height = height_minus_1 + 1
            end = offsets[index + 1] if index + 1 < len(offsets) else len(gfx)
            raw = gfx[offset:end]
            self.assertEqual(len(raw), width_words * height * 8)
            self.assertEqual(encode_planar(decode_planar(raw, width_words, height)), raw)

    def test_large_and_shield_avatars_partition_and_round_trip(self) -> None:
        large = decode_fixed_sprites(
            GFX_DIR / "Avatars_Large.gfx",
            width_words=2,
            height=30,
            count=16,
            name_prefix="large",
        )
        shield = decode_fixed_sprites(
            GFX_DIR / "Shield_Avatars.gfx",
            width_words=2,
            height=16,
            count=16,
            name_prefix="shield",
        )
        self.assertEqual([(sprite.width, sprite.height) for sprite in large], [(32, 30)] * 16)
        self.assertEqual([(sprite.width, sprite.height) for sprite in shield], [(32, 16)] * 16)
        self.assertEqual(
            b"".join(encode_planar(sprite.pixels) for sprite in large),
            (GFX_DIR / "Avatars_Large.gfx").read_bytes(),
        )
        self.assertEqual(
            b"".join(encode_planar(sprite.pixels) for sprite in shield),
            (GFX_DIR / "Shield_Avatars.gfx").read_bytes(),
        )

    def test_all_character_records_build_from_five_source_parts(self) -> None:
        assets = CharacterAssets(CHARACTER_DATA_DIR, GFX_DIR)
        self.assertEqual(len(set(assets.body_selections)), 11)
        self.assertEqual(max(assets.body_selections), 13)
        self.assertEqual(len(set(assets.head_selections)), 18)
        for character in range(0x56):
            with self.subTest(character=f"${character:02X}"):
                operations = assets.draw_operations(character)
                self.assertEqual(
                    [operation.part for operation in operations],
                    ["legs", "torso", "head", "left_arm", "right_arm"],
                )
                self.assertFalse(operations[3].operation.mirrored)
                self.assertTrue(operations[4].operation.mirrored)
                for distance in range(6):
                    for facing in range(4):
                        view = assets.draw_operations(
                            character,
                            distance=distance,
                            facing=facing,
                            render_flags=3,
                        )
                        self.assertTrue(view)
                        if distance >= 4:
                            self.assertEqual(
                                [operation.part for operation in view], ["distant"]
                            )
                            self.assertEqual(
                                view[0].operation.mirrored,
                                facing == 3,
                            )
                        for component in view:
                            source = (
                                GFX_DIR / component.operation.sprite.source_file
                            ).read_bytes()
                            start = component.operation.sprite.byte_offset
                            end = start + component.operation.sprite.byte_size
                            self.assertEqual(
                                encode_planar(component.operation.sprite.pixels),
                                source[start:end],
                            )

    def test_character_middle_distances_use_smaller_source_strips(self) -> None:
        assets = CharacterAssets(CHARACTER_DATA_DIR, GFX_DIR)
        heights = []
        for distance in range(4):
            legs = next(
                operation
                for operation in assets.draw_operations(0, distance=distance)
                if operation.part == "legs"
            )
            heights.append(legs.operation.sprite.height)
        self.assertEqual(heights, [26, 22, 18, 15])

    def test_character_companion_tables_match_the_439_binary(self) -> None:
        binary = (BINARIES_DIR / "BLOODWYCH439").read_bytes()
        resources = {
            "characters-body-definitions.layout": (0xA50A, 0x8C),
            "characters-render-table-offsets.lookup": (0xA5EC, 0x14),
            "characters-part-variants.lookup": (0xA600, 0x14),
            "characters-arm-animation.positions": (0xA778, 0x48),
            "characters-standard-render.layout": (0x18480, 0x130),
            "characters-standard-distant-4.positions": (0x185B0, 8),
            "characters-standard-distant-5.positions": (0x185B8, 8),
            "characters-alternate-render.layout": (0x185C0, 0x130),
            "characters-alternate-distant-4.positions": (0x186F0, 8),
            "characters-alternate-distant-5.positions": (0x186F8, 8),
        }
        for filename, (offset, size) in resources.items():
            with self.subTest(filename=filename):
                self.assertEqual(
                    (CHARACTER_DATA_DIR / filename).read_bytes(),
                    binary[offset : offset + size],
                )

    def test_character_arm_animation_selects_variant_two(self) -> None:
        assets = CharacterAssets(CHARACTER_DATA_DIR, GFX_DIR)
        still = assets.draw_operations(0, distance=1, facing=0, render_flags=0)
        animated = assets.draw_operations(0, distance=1, facing=0, render_flags=3)
        still_arms = [item.operation.sprite.byte_offset for item in still if "arm" in item.part]
        animated_arms = [
            item.operation.sprite.byte_offset for item in animated if "arm" in item.part
        ]
        self.assertNotEqual(still_arms, animated_arms)
        animated_near = assets.draw_operations(
            0, distance=0, facing=0, render_flags=3
        )
        near_positions = [
            (item.operation.x, item.operation.y)
            for item in animated_near
            if "arm" in item.part
        ]
        self.assertEqual(near_positions, [(-8, -19), (9, -19)])

    def test_character_colours_are_five_independent_four_colour_masks(self) -> None:
        assets = CharacterAssets(CHARACTER_DATA_DIR, GFX_DIR)
        self.assertEqual(
            assets.palettes(0),
            (
                (0, 4, 8, 0),
                (14, 4, 8, 3),
                (14, 4, 8, 3),
                (4, 8, 4, 14),
                (8, 8, 4, 4),
            ),
        )

    def test_compact_character_bodies_apply_the_source_head_position(self) -> None:
        assets = CharacterAssets(CHARACTER_DATA_DIR, GFX_DIR)
        normal = assets.draw_operations(0)
        compact_character = assets.body_selections.index(4)
        compact = assets.draw_operations(compact_character)
        normal_head = next(operation for operation in normal if operation.part == "head")
        compact_head = next(operation for operation in compact if operation.part == "head")
        self.assertEqual(
            (normal_head.operation.x, normal_head.operation.y),
            (3, -20),
        )
        self.assertEqual(
            (compact_head.operation.x, compact_head.operation.y),
            (3, -17),
        )

    def test_character_preview_uses_native_game_window_and_anchor(self) -> None:
        assets = CharacterAssets(CHARACTER_DATA_DIR, GFX_DIR)
        background = load_floor_ceiling_background(GFX_DIR)
        pixels, metadata = render_character_preview(
            background,
            assets,
            0,
            anchor_x=56,
            anchor_y=39,
        )
        self.assertEqual((len(pixels[0]), len(pixels)), (128, 76))
        self.assertEqual(metadata["requested_game_anchor"], [56, 39])
        self.assertEqual(metadata["body_design"], 0)
        self.assertEqual(metadata["head_design"], 15)
        self.assertEqual(len(metadata["operations"]), 5)

    def test_new_beholder_split_partitions_and_round_trips(self) -> None:
        assets = BeholderAssets(MONSTERS_DIR)
        self.assertEqual(
            [len(assets.body), len(assets.upper), len(assets.near), len(assets.far)],
            [6, 4, 16, 4],
        )
        for sprite in assets.all_sprites():
            source = (MONSTERS_DIR / sprite.source_file).read_bytes()
            self.assertEqual(
                encode_planar(sprite.pixels),
                source[sprite.byte_offset : sprite.byte_offset + sprite.byte_size],
            )

    def test_beholder_colour_substitution_matches_template_indices(self) -> None:
        pixels = [[0, 1, 4, 5, 8, 9, 12, 13, 15]]
        self.assertEqual(
            remap_template_colours(pixels, [2, 3, 6, 7]),
            [[2, 1, 3, 5, 6, 9, 7, 13, 15]],
        )

    def test_beholder_previews_are_native_game_window_size(self) -> None:
        background = load_floor_ceiling_background(GFX_DIR)
        self.assertEqual((len(background[0]), len(background)), (128, 76))
        assets = BeholderAssets(MONSTERS_DIR)
        for distance in range(6):
            for facing in range(4):
                pixels, metadata = render_beholder(background, assets, distance, facing)
                self.assertEqual((len(pixels[0]), len(pixels)), (128, 76))
                self.assertEqual(metadata["distance"], distance)
                self.assertEqual(metadata["facing"], facing)

    def test_floor_ceiling_native_layout_matches_draw_routine(self) -> None:
        source = decode_planar((GFX_DIR / "FloorCeiling.gfx").read_bytes(), 8, 57)
        background = load_floor_ceiling_background(GFX_DIR)
        self.assertEqual(background[:23], source[:23])
        self.assertEqual(background[23:42], [[0] * 128 for _ in range(19)])
        self.assertEqual(background[42:], source[23:])

    def test_beholder_accepts_the_games_screen_anchor(self) -> None:
        background = load_floor_ceiling_background(GFX_DIR)
        assets = BeholderAssets(MONSTERS_DIR)
        _pixels, metadata = render_beholder(
            background,
            assets,
            2,
            0,
            anchor_x=74,
            anchor_y=36,
        )
        self.assertEqual(metadata["positioning_mode"], "game-anchor")
        self.assertEqual(metadata["requested_game_anchor"], [74, 36])
        self.assertEqual(metadata["anchor_shift"], [74, 36])

    def test_all_configured_monsters_have_renderable_files(self) -> None:
        for monster in MONSTERS:
            with self.subTest(monster=monster.display_name):
                self.assertTrue(inspect_monster_files(monster, MONSTERS_DIR).ready)

    def test_all_configured_monsters_render_each_distance_and_facing(self) -> None:
        background = load_floor_ceiling_background(GFX_DIR)
        assets, errors = load_renderer_assets(MONSTERS_DIR)
        self.assertFalse(errors)
        for monster in MONSTERS:
            for distance in range(6):
                for facing in range(4):
                    with self.subTest(
                        monster=monster.display_name,
                        distance=distance,
                        facing=facing,
                    ):
                        pixels, metadata = render_monster_preview(
                            background,
                            monster,
                            assets,
                            distance=distance,
                            facing=facing,
                            grade_step=0,
                            animation_frame=1,
                            anchor_x=56,
                            anchor_y=36,
                        )
                        self.assertEqual((len(pixels[0]), len(pixels)), (128, 76))
                        self.assertTrue(metadata["operations"])

    def test_summon_arms_include_the_post_body_x_adjustment(self) -> None:
        assets, errors = load_renderer_assets(MONSTERS_DIR)
        self.assertFalse(errors)
        operations = assets["summon"].draw_operations(0, 0, render_flags=0)
        arms = [operation for operation in operations if "_Arm_" in operation.sprite.name]
        self.assertEqual([(arm.x, arm.y) for arm in arms], [(-6, -13), (9, -13)])

    def test_behemoth_composite_body_uses_viewport_y_coordinates(self) -> None:
        assets, errors = load_renderer_assets(MONSTERS_DIR)
        self.assertFalse(errors)
        operations = assets["behemoth"].draw_operations(0, 0, render_flags=0)
        bodies = [operation for operation in operations if "_Body_" in operation.sprite.name]
        claws = [operation for operation in operations if "_Limb_" in operation.sprite.name]
        self.assertEqual([body.y for body in bodies], [-23, -23])
        self.assertEqual([claw.y for claw in claws], [-13, -13])

    def test_crab_front_components_follow_separate_source_indexes(self) -> None:
        assets, errors = load_renderer_assets(MONSTERS_DIR)
        self.assertFalse(errors)
        operations = assets["crab"].draw_operations(0, 0, render_flags=0)
        face = next(operation for operation in operations if "_Face_" in operation.sprite.name)
        claws = [
            operation
            for operation in operations
            if "_BehemothClaw_" in operation.sprite.name
        ]
        self.assertEqual((face.x, face.y), (0, 7))
        self.assertEqual([(claw.x, claw.y) for claw in claws], [(-16, 6), (16, 6)])

    def test_crab_back_and_side_claws_follow_source_mirroring(self) -> None:
        assets, errors = load_renderer_assets(MONSTERS_DIR)
        self.assertFalse(errors)
        crab = assets["crab"]

        back = crab.draw_operations(0, 2, render_flags=3)
        back_claws = [operation for operation in back if "_BackClaw_" in operation.sprite.name]
        self.assertEqual([claw.mirrored for claw in back_claws], [True, False])

        side_left = crab.draw_operations(0, 1, render_flags=3)
        side_right = crab.draw_operations(0, 3, render_flags=3)
        left_claw = next(
            operation for operation in side_left if "_SideNear_" in operation.sprite.name
        )
        right_claw = next(
            operation for operation in side_right if "_SideNear_" in operation.sprite.name
        )
        left_face = next(
            operation for operation in side_left if operation.sprite.name == "Crab_SideClaw"
        )
        right_face = next(
            operation for operation in side_right if operation.sprite.name == "Crab_SideClaw"
        )
        self.assertEqual((left_face.x, left_face.mirrored), (-20, True))
        self.assertEqual((right_face.x, right_face.mirrored), (20, False))
        self.assertTrue(left_claw.mirrored)
        self.assertFalse(right_claw.mirrored)

    def test_small_dragon_uses_next_shared_graphics_distance(self) -> None:
        assets, errors = load_renderer_assets(MONSTERS_DIR)
        self.assertFalse(errors)
        dragon = assets["dragon"]
        small = dragon.draw_operations(0, 0, small=True, render_flags=0)
        large_next = dragon.draw_operations(2, 0, small=False, render_flags=0)
        self.assertEqual(
            [operation.sprite.name for operation in small],
            [operation.sprite.name for operation in large_next],
        )
        self.assertEqual(small[0].sprite.name, "Dragon_Body_03")


if __name__ == "__main__":
    unittest.main()
