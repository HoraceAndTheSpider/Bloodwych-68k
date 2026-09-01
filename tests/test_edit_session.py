from __future__ import annotations

import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from tools.binary_identity import identify_binary, identify_bytes
from tools.champion_data import ChampionAssets
from tools.edit_session import EditSession, resource_specs
from tools.graphics_preview import CharacterAssets
from tools.interface_data import InterfaceProject
from tools.map_editor.model import MapProject, MapCell, TOWERS
from tools.object_data import ObjectAssets
from tools.tool_common import BINARIES_DIR, DATA_DIR, ToolError, get_profile


class BinaryIdentityTests(unittest.TestCase):
    def test_renamed_references_are_classified_by_contents(self):
        with tempfile.TemporaryDirectory() as temporary:
            path = Path(temporary) / "BLOODWYCH439"
            for name in ("BLOODWYCH439", "BLOODWYCH102", "BLOODWYCH1927", "BEXT43", "AtariST_DEMO_CODE"):
                with self.subTest(name=name):
                    path.write_bytes((BINARIES_DIR / name).read_bytes())
                    self.assertEqual(identify_binary(path).family, name)
                    self.assertEqual(get_profile(str(path)).family, name)

    def test_renamed_book_of_skulls_needs_no_profile_entry(self):
        with tempfile.TemporaryDirectory() as temporary:
            path = Path(temporary) / "my-edited-game"
            path.write_bytes((BINARIES_DIR / "BookOfSkulls_P_Beta5").read_bytes())
            self.assertEqual(identify_binary(path).family, "BLOODWYCH439")
            self.assertTrue(identify_binary(path).layout_compatible)
            self.assertEqual(get_profile(str(path)).segment_sheet, "BLOODWYCH439")

    def test_larger_book_is_recognised_but_not_assigned_fixed_layout(self):
        path = BINARIES_DIR / "NewBookOfSkulls_P_Beta5"
        if not path.exists():
            self.skipTest("User-supplied extended binary is not available")
        identity = identify_binary(path)
        self.assertEqual(identity.family, "BLOODWYCH439")
        self.assertFalse(identity.layout_compatible)

    def test_same_sized_code_changes_do_not_prove_layout_compatibility(self):
        data = bytearray((BINARIES_DIR / "BLOODWYCH439").read_bytes())
        data[0x80] ^= 1
        result = identify_bytes(data)
        self.assertEqual(result.family, "BLOODWYCH439")
        self.assertFalse(result.layout_compatible)

    def test_unrecognised_and_ambiguous_inputs_fail_closed(self):
        with self.assertRaises(ToolError):
            identify_bytes(bytes(364644))
        a = (BINARIES_DIR / "BLOODWYCH439").read_bytes()
        b = (BINARIES_DIR / "BLOODWYCH1927").read_bytes()
        mixed = bytearray(a)
        differing = [i for i in range(len(a)) if a[i] != b[i]]
        for i in differing[::2]:
            mixed[i] = b[i]
        with self.assertRaisesRegex(ToolError, "Ambiguous"):
            identify_bytes(mixed)


class EditSessionTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.session = EditSession(modified_root=self.root / "modified")

    def test_viewer_resource_specs_do_not_validate_extract_grouping(self):
        segments = self.root / "segments.csv"
        segments.write_text(
            "label,name,offset,size,data_action\n"
            "Interior,data/example.bin,$10,$02,data_append\n"
        )

        specs = resource_specs("BLOODWYCH439", segments)

        self.assertEqual(specs["data/example.bin"].offset, 0x10)

    def test_baseline_comes_from_binary_and_ignores_unimported_modified_data(self):
        name = "data/characters.heads"
        path = self.session.modified_root / name
        path.parent.mkdir(parents=True)
        path.write_bytes(b"wrong")
        self.assertEqual(self.session.read(name), self.session.baseline(name))
        self.assertEqual(MapProject.from_session(self.session).resource_bytes(name), self.session.baseline(name))

    def test_loading_binary_routes_exports_to_its_own_project(self):
        # Use normal profile-derived folders inside a temporary data tree.
        with patch("tools.tool_common.DATA_DIR", self.root / "data"):
            session = EditSession()
            previous_folder = session.modified_root
            previous_file = previous_folder / "data/characters.heads"
            previous_file.parent.mkdir(parents=True)
            previous_file.write_bytes(b"keep earlier export")
            book_folder = self.root / "data/BookOfSkulls_P_Beta5-modified"
            book_file = book_folder / "data/characters.heads"
            book_file.parent.mkdir(parents=True)
            book_file.write_bytes(b"do not auto-import this")

            session.import_binary(BINARIES_DIR / "BookOfSkulls_P_Beta5")
            self.assertEqual(session.modified_root, book_folder)
            self.assertEqual(session.profile.filename, "BookOfSkulls_P_Beta5")
            self.assertNotEqual(session.read("data/characters.heads"), book_file.read_bytes())
            self.assertEqual(previous_file.read_bytes(), b"keep earlier export")
            self.assertEqual(book_file.read_bytes(), b"do not auto-import this")

            written = session.export()
            self.assertTrue(written)
            self.assertTrue(all(book_folder in path.parents for path in written))
            self.assertTrue((book_folder / ".edit-session.json").is_file())
            self.assertEqual(previous_file.read_bytes(), b"keep earlier export")

            session.select_save(Path(__file__).resolve().parents[1] / "whdload/bloodsave0")
            self.assertEqual(session.modified_root, book_folder)
            session.select_save(None)
            session.import_binary(BINARIES_DIR / "BLOODWYCH439")
            self.assertEqual(session.modified_root, previous_folder)

    def test_rejected_binary_does_not_switch_export_folder(self):
        session = EditSession("BookOfSkulls_P_Beta5")
        folder, profile, data = session.modified_root, session.profile, session.binary_data
        with self.assertRaises(ToolError):
            session.import_binary(BINARIES_DIR / "BLOODWYCH1927")
        self.assertEqual(session.modified_root, folder)
        self.assertEqual(session.profile, profile)
        self.assertEqual(session.binary_data, data)

    def test_map_champion_edit_is_visible_to_data_and_interface_consumers(self):
        project = MapProject.from_session(self.session)
        before = project.champion_pocket_bytes(0)
        value = 0x50 if before[4] != 0x50 else 0x51
        project.set_champion_pocket_byte(0, 0, 4, value)
        project.sync_session()
        self.assertEqual(ChampionAssets(self.session.root).pocket_record(0)[4], value)
        interface = InterfaceProject(self.session.clean_root, session=self.session)
        self.assertEqual(interface.champion_pockets[0][4], value)
        self.assertFalse(self.session.modified_root.exists())

    def test_character_design_change_is_visible_without_export(self):
        project = MapProject.from_session(self.session)
        original = project.character_design(0)[0]
        project.set_character_design(0, head=(original + 1) % 8)
        project.sync_session()
        assets = CharacterAssets(self.session.root / "data", self.session.root / "gfx")
        self.assertEqual(assets.head_design(0), (original + 1) % 8)

    def test_reload_is_scoped_and_reset_restores_canonical_original(self):
        one, two = TOWERS[0].map_name, TOWERS[1].map_name
        self.session.write(one, self.session.read(one)[:-1] + b"\x23")
        self.session.write(two, self.session.read(two)[:-1] + b"\x34")
        self.session.reload([one])
        self.assertEqual(self.session.read(one), self.session.baseline(one))
        self.assertNotEqual(self.session.read(two), self.session.baseline(two))
        self.session.reset()
        self.assertEqual(self.session.changed_resources, {})

    def test_whole_export_round_trip_and_reset_snapshot_dont_resurrect_stale_files(self):
        name = "data/characters.heads"
        self.session.write(name, bytes([0]) + self.session.read(name)[1:])
        self.session.export()
        fresh = EditSession(modified_root=self.session.modified_root)
        fresh.import_modified()
        self.assertEqual(fresh.read(name), self.session.read(name))
        fresh.reset()
        fresh.export()
        again = EditSession(modified_root=self.session.modified_root)
        again.import_modified()
        self.assertEqual(again.changed_resources, {})

    def test_book_snapshot_preserves_unmapped_code_and_resource_reverts(self):
        self.session.import_binary(BINARIES_DIR / "BookOfSkulls_P_Beta5")
        self.assertEqual(self.session.modified_root, self.root / "modified")
        name = next(iter(self.session.changed_resources))
        self.session.reload([name])
        expected = self.session.build_patch()
        spec = self.session.specs[name]
        self.assertEqual(expected[spec.offset:spec.offset + spec.size], self.session.baseline(name))
        self.session.export()
        restored = EditSession(modified_root=self.session.modified_root)
        restored.import_modified()
        self.assertEqual(restored.build_patch(), expected)
        self.session.reset()
        self.assertEqual(self.session.build_patch(), self.session.original)

    def test_oversized_grade_blocks_patch_before_any_output_is_created(self):
        name = "monsters/beholder.colours"
        self.session.write(name, self.session.read(name) * 2)
        with patch("tools.edit_session.BINARIES_DIR", self.root / "binaries"):
            with self.assertRaisesRegex(ToolError, "Source rebuild needed"):
                self.session.patch()
        self.assertFalse((self.root / "binaries").exists())

    def test_build_patch_changes_only_the_requested_fixed_size_resource(self):
        name = "data/characters.heads"
        changed = bytes([0]) + self.session.read(name)[1:]
        self.session.write(name, changed)
        expected = bytearray(self.session.original)
        spec = self.session.specs[name]
        expected[spec.offset:spec.offset + spec.size] = changed
        self.assertEqual(self.session.build_patch(), expected)

    def test_save_champion_and_map_edits_share_state_and_reset_reloads_save(self):
        save = self.root / "bloodsave0"
        save.write_bytes((Path(__file__).resolve().parents[1] / "whdload/bloodsave0").read_bytes())
        original = save.read_bytes()
        self.session.select_save(save)
        project = MapProject.from_session(self.session)
        project.set_champion_pocket_byte(0, 0, 4, 0x50)
        project.set_cell(0, 3, 1, 1, MapCell(0x12, 0x34))
        project.sync_session()
        project.set_champion_pocket_byte(0, 0, 5, 0x51)
        project.sync_session()
        fresh = MapProject.from_session(self.session)
        self.assertEqual(fresh.maps[0].cell(3, 1, 1), MapCell(0x12, 0x34))
        self.assertEqual(ChampionAssets(self.session.root).pocket_record(0)[4:6], bytes([0x50, 0x51]))
        self.assertEqual(save.read_bytes(), original)
        with self.assertRaisesRegex(ToolError, "Confirm"):
            self.session.patch()
        self.session.export()
        restored = EditSession(modified_root=self.session.modified_root, savegame_path=save)
        restored.import_modified()
        self.assertEqual(restored.build_patch(), self.session.build_patch())
        self.session.reset()
        self.assertEqual(self.session.build_patch(), original)

    def test_save_rejects_extended_levels_and_truncated_files_without_state_changes(self):
        for name in ("bextsave0", "bextsave2", "bextsave3", "bextsave7", "bextsave8"):
            path = Path(__file__).resolve().parents[1] / "whdload" / name
            if path.exists():
                with self.assertRaises(ToolError):
                    self.session.select_save(path)
        path = self.root / "short"
        path.write_bytes(b"\0" * 100)
        with self.assertRaises(ToolError):
            self.session.select_save(path)
        self.assertIsNone(self.session.save_path)

    def test_playtest_fork_is_isolated_and_cannot_export(self):
        name = "data/characters.heads"
        bubble = self.session.fork()
        bubble.write(name, b"\0" * len(bubble.read(name)))
        self.assertNotEqual(bubble.read(name), self.session.read(name))
        with self.assertRaisesRegex(ToolError, "bubbles"):
            bubble.export()
        with self.assertRaisesRegex(ToolError, "bubbles"):
            bubble.build_patch()

    def test_read_only_aggregate_uses_live_component_bytes(self):
        self.session.write("maps/mod0.monstercount", b"\0\x04")
        self.assertEqual(self.session.read("maps/monsters.totals")[:2], b"\0\x04")
        with self.assertRaisesRegex(ToolError, "Not an editable resource"):
            self.session.write("maps/monsters.totals", b"\0" * 12)

    def test_changed_snapshot_is_rejected_before_touching_session(self):
        name = "data/characters.heads"
        self.session.write(name, bytes([0]) + self.session.read(name)[1:])
        self.session.export()
        (self.session.modified_root / name).write_bytes(b"broken snapshot")
        restored = EditSession(modified_root=self.session.modified_root)
        with self.assertRaisesRegex(ToolError, "changed export snapshot"):
            restored.import_modified()
        self.assertEqual(restored.changed_resources, {})

    def test_unmapped_import_files_cannot_be_silently_omitted_from_patch(self):
        file = self.session.modified_root / "monsters/new.colours"
        file.parent.mkdir(parents=True)
        file.write_bytes(b"\0")
        self.session.import_modified()
        self.assertIn("Unmapped imported resource", self.session.patch_blockers()[0])
        with self.assertRaisesRegex(ToolError, "Unmapped"):
            self.session.export()
        self.session.reset()
        self.assertEqual(self.session.patch_blockers(), ())

    def test_save_patch_keeps_input_and_prior_output_immutable(self):
        save = self.root / "bloodsave0"
        original = (Path(__file__).resolve().parents[1] / "whdload/bloodsave0").read_bytes()
        save.write_bytes(original)
        self.session.select_save(save)
        self.session.write("data/champions.pockets", b"\x50" + self.session.read("data/champions.pockets")[1:])
        destination = self.session.modified_root / "whdload" / save.name
        destination.parent.mkdir(parents=True)
        destination.write_bytes(b"keep previous output")
        output = self.session.patch(confirm_save=True)
        self.assertNotEqual(output, destination)
        self.assertEqual(output.read_bytes(), self.session.build_patch())
        self.assertEqual(save.read_bytes(), original)
        self.assertEqual(destination.read_bytes(), b"keep previous output")

    def test_extraction_preflights_all_clean_files_without_overwriting(self):
        from types import SimpleNamespace
        from tools.edit_session import ResourceSpec
        from tools.tool_extract import extract_segments
        source = self.root / "source"
        source.write_bytes(b"123456")
        clean = self.root / "clean"
        clean.mkdir()
        conflict = clean / "second"
        conflict.write_bytes(b"user data")
        with (
            patch("tools.tool_extract.get_profile", return_value=SimpleNamespace(clean_dir=clean)),
            patch("tools.tool_extract.binary_path", return_value=source),
            patch("tools.tool_extract.resource_specs", return_value={
                "first": ResourceSpec("first", 0, 3), "second": ResourceSpec("second", 3, 3)}),
        ):
            with self.assertRaisesRegex(ToolError, "cannot be overwritten"):
                extract_segments("fixture", self.root / "unused.xlsx")
        self.assertFalse((clean / "first").exists())
        self.assertEqual(conflict.read_bytes(), b"user data")
        self.assertEqual(source.read_bytes(), b"123456")

    def test_missing_book_split_tables_are_not_needed(self):
        session = EditSession("BookOfSkulls_P_Beta5", modified_root=self.root)
        assets = ObjectAssets(session.root)
        for object_code in range(0x6E):
            assets.pocket_sprite(object_code)
            assets.floor_preview(object_code)


if __name__ == "__main__":
    unittest.main()
