#!/usr/bin/env python3
"""Top-level command entry point for the Bloodwych ReSource SuperApp."""

from __future__ import annotations

import argparse
from pathlib import Path
import sys

from tools.tool_common import (
    DEFAULT_CLEANUP_FILE,
    DEFAULT_SEGMENTS_FILE,
    PROFILES,
    PROJECT_ROOT,
    WHDLOAD_DIR,
    ToolError,
    asm_path,
    get_profile,
)
from tools.tool_extract import extract_segments
from tools.tool_inspect import inspect_source
from tools.tool_patch import patch_segments
from tools.tool_relabel import build_asmfix, relabel_segments
from tools.source_formatter import format_relabel_data
from tools.pygame_window import is_fullscreen, set_display_mode, set_scaled_fullscreen, set_windowed


DATA_GUI_COMMANDS = ("extract", "asmfix", "relabel", "inspect", "format", "patch")
VIEWER_GUI_COMMANDS = ("graphics", "maps", "interface", "files")
GUI_COMMANDS = DATA_GUI_COMMANDS + VIEWER_GUI_COMMANDS
GUI_LABELS = {
    "extract": "Extract Binary Data",
    "relabel": "Relabel",
    "asmfix": "ASM Fix",
    "inspect": "Inspect / Data",
    "format": "Format Source",
    "patch": "Patch",
    "files": "Binaries / Saves / Data",
    "graphics": "Data Viewer",
    "maps": "Map Viewer / Editor",
    "interface": "Interface Viewer / Editor",
}


def launch_gui(
    screenshot_path: Path | None = None,
    *,
    profile_name: str = "BLOODWYCH439",
) -> str | None:
    """Show the legacy Pygame command chooser for a bare ``main.py`` launch."""
    try:
        import pygame
    except ImportError as error:
        raise ToolError(
            "Pygame is required for the graphical launcher. "
            "Install requirements.txt or run an explicit CLI command."
        ) from error

    pygame.init()
    from tools.session_panel import SessionPanel
    from tools.joypad_panel import JoypadControls
    try:
        window_size = (620, 450)
        surface = set_display_mode(pygame, window_size)
        joypad = JoypadControls(pygame)
        fullscreen = is_fullscreen()
        display_mode_rect = pygame.Rect(window_size[0] - 55, 8, 48, 24)
        quit_rect = pygame.Rect(window_size[0] - 78, window_size[1] - 34, 68, 26)
        pygame.display.set_caption("Bloodwych ReSource")
        title_font = pygame.font.SysFont(None, 28)
        font = pygame.font.SysFont(None, 24)
        heading_font = pygame.font.SysFont(None, 21)
        button_width, button_height, spacing = 240, 44, 10
        start_y = 82
        column_x = (55, 325)
        buttons = []
        for column, commands in enumerate((DATA_GUI_COMMANDS, VIEWER_GUI_COMMANDS)):
            buttons.extend(
                (
                    pygame.Rect(
                        column_x[column],
                        start_y + index * (button_height + spacing),
                        button_width,
                        button_height,
                    ),
                    command,
                )
                for index, command in enumerate(commands)
            )
        clock = pygame.time.Clock()

        while True:
            mouse_position = joypad.pointer_position()
            surface.fill((30, 30, 30))
            pygame.draw.rect(surface, (65, 70, 82), display_mode_rect, border_radius=4)
            mode_label = font.render("WIN" if fullscreen else "FULL", True, (245, 245, 245))
            surface.blit(mode_label, mode_label.get_rect(center=display_mode_rect.center))
            pygame.draw.rect(surface, (105, 55, 60), quit_rect, border_radius=4)
            quit_label = font.render("QUIT", True, (255, 245, 245))
            surface.blit(quit_label, quit_label.get_rect(center=quit_rect.center))
            title = title_font.render("Bloodwych ReSource", True, (245, 245, 248))
            surface.blit(title, title.get_rect(center=(window_size[0] // 2, 25)))
            profile_lines = profile_name.split(" | ", 1)
            for index, line in enumerate(profile_lines):
                text = ("PROFILE: " if index == 0 else "INPUT: ") + line
                profile_label = heading_font.render(
                    SessionPanel._fit_path(heading_font, text, quit_rect.left - 20), True, (175, 180, 190)
                )
                surface.blit(profile_label, (10, window_size[1] - 42 + index * 21))
            for x, label in zip(column_x, ("SOURCE & DATA", "VIEWERS & EDITORS")):
                heading = heading_font.render(label, True, (175, 180, 190))
                surface.blit(heading, heading.get_rect(center=(x + button_width // 2, 58)))
            for rectangle, command in buttons:
                colour = (80, 80, 240) if rectangle.collidepoint(mouse_position) else (50, 50, 200)
                pygame.draw.rect(surface, colour, rectangle)
                label = font.render(GUI_LABELS[command], True, (255, 255, 255))
                surface.blit(label, label.get_rect(center=rectangle.center))
            joypad.draw(surface, button_rect=(325, 298, 240, 44))
            pygame.display.flip()
            if screenshot_path is not None:
                screenshot_path.parent.mkdir(parents=True, exist_ok=True)
                pygame.image.save(surface, str(screenshot_path))
                return None

            for event in joypad.events(pygame.event.get(), surface):
                if event.type == pygame.QUIT:
                    return None
                if event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
                    if display_mode_rect.collidepoint(event.pos):
                        fullscreen = not fullscreen
                        surface = set_scaled_fullscreen(pygame, window_size) if fullscreen else set_windowed(pygame, window_size)
                        continue
                    if quit_rect.collidepoint(event.pos):
                        return None
                    for rectangle, command in buttons:
                        if rectangle.collidepoint(event.pos):
                            return command
            clock.tick(60)
    finally:
        pygame.quit()


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Bloodwych ReSource: extract, inspect, relabel, and rebuild game data"
    )
    parser.add_argument(
        "-m",
        "--master",
        default="BLOODWYCH439",
        help="Binary filename or path; edited versions are identified by content",
    )
    parser.add_argument(
        "-s",
        "--sheet",
        default=str(DEFAULT_SEGMENTS_FILE),
        help="segments.xlsx or compatible CSV definition",
    )
    parser.add_argument(
        "--cleanup",
        default=None,
        help=(
            "EQUATES/COMMENTS workbook (default: cleanup.xlsx when present; "
            f"expected at {DEFAULT_CLEANUP_FILE})"
        ),
    )
    parser.add_argument(
        "--savegame",
        type=Path,
        default=None,
        help="overlay a WHDLoad save across the viewers (for example whdload/bloodsave0)",
    )
    subparsers = parser.add_subparsers(dest="command")

    extract = subparsers.add_parser("extract", help="Extract configured segments")
    extract.add_argument("-n", "--name", help="Extract one exact segment name")
    extract.add_argument("--debug", action="store_true")

    patch = subparsers.add_parser("patch", help="Create a fixed-size patched binary")
    patch.add_argument("-n", "--name", help="Patch one exact segment name")
    patch.add_argument("--debug", action="store_true")

    inspect = subparsers.add_parser("inspect", help="Validate extracted data against ASM")
    inspect.add_argument("-n", "--name", help="Inspect one exact segment name")
    inspect.add_argument("label", nargs="?", help="Inspect one exact ASM label")
    inspect.add_argument("--debug", action="store_true")

    subparsers.add_parser("relabel", help="Generate asm/<binary>_relabel.asm")
    subparsers.add_parser(
        "asmfix",
        help="Generate asm/<source>_asmfix.asm for Relabel to consume",
    )
    subparsers.add_parser(
        "format",
        help=(
            "Format asm/<binary>_relabel_data.asm and generate its EQU include"
        ),
    )
    graphics = subparsers.add_parser("graphics", help="Open the extracted graphics viewer")
    graphics.add_argument(
        "--modified",
        action="store_true",
        help="start with the sparse modified-data overlay enabled",
    )
    maps = subparsers.add_parser("maps", help="Open the map viewer/editor")
    maps.add_argument("--modified", action="store_true", help="import the modified-data folder into the shared session")
    for viewer in (graphics, maps):
        viewer.add_argument(
            "--savegame",
            type=Path,
            default=argparse.SUPPRESS,
            help="overlay a WHDLoad save over extracted resources",
        )
    interface = subparsers.add_parser(
        "interface", help="Open the source-led interface viewer/editor"
    )
    interface.add_argument(
        "--modified",
        action="store_true",
        help="start with the sparse modified-data overlay enabled",
    )
    interface.add_argument(
        "--savegame",
        type=Path,
        default=argparse.SUPPRESS,
        help="overlay a WHDLoad save over extracted resources",
    )
    subparsers.add_parser("profiles", help="List supported binary families")
    subparsers.add_parser("files", help="Open the shared binary/save catalogue")
    identify = subparsers.add_parser("identify", help="Identify a binary by content without extracting it")
    identify.add_argument("binary", type=Path)
    subparsers.add_parser("paths", help="Show the canonical project paths")
    return parser


def viewer_session(args):
    from tools.edit_session import EditSession
    if getattr(args, "_session", None) is None:
        try:
            args._session = EditSession(args.master, sheet=Path(args.sheet),
                                        savegame_path=getattr(args, "savegame", None),
                                        prefer_modified=getattr(args, "modified", False))
        except (OSError, ValueError) as error:
            raise ToolError(str(error)) from error
    return args._session


def active_profile_name(args):
    session = getattr(args, "_session", None)
    if session is None:
        return get_profile(args.master).filename
    name = f"{session.family} | {session.binary_name}"
    if session.save_path is not None:
        name += f" | SAVE: {session.save_path.name}"
    return name


def run(args: argparse.Namespace, parser: argparse.ArgumentParser) -> int:
    if args.command == "extract":
        extract_segments(
            args.master,
            args.sheet,
            getattr(args, "name", None),
            getattr(args, "debug", False),
        )
    elif args.command == "patch":
        patch_segments(
            args.master,
            args.sheet,
            getattr(args, "name", None),
            getattr(args, "debug", False),
        )
    elif args.command == "inspect":
        inspect_source(
            args.master,
            args.sheet,
            getattr(args, "name", None),
            getattr(args, "label", None),
            getattr(args, "debug", False),
        )
    elif args.command == "relabel":
        relabel_segments(args.master, args.sheet, args.cleanup)
    elif args.command == "asmfix":
        build_asmfix(args.master, args.sheet, args.cleanup)
    elif args.command == "format":
        try:
            destination = format_relabel_data(
                asm_path(args.master, "data"), args.sheet, args.master, args.cleanup
            )
        except FileNotFoundError as error:
            raise ToolError(str(error)) from error
        print(f"Formatted ASM source at '{destination}'")
    elif args.command == "graphics":
        from tools.graphics_viewer import GraphicsViewerError, launch_graphics_viewer

        try:
            launch_graphics_viewer(
                get_profile(args.master).clean_dir,
                session=viewer_session(args),
                prefer_modified=getattr(args, "modified", False),
                **(
                    {"savegame_path": args.savegame}
                    if getattr(args, "savegame", None) is not None
                    else {}
                ),
            )
        except GraphicsViewerError as error:
            raise ToolError(str(error)) from error
    elif args.command == "maps":
        from tools.map_editor.app import MapEditorError, launch_map_editor

        try:
            launch_map_editor(
                get_profile(args.master).clean_dir,
                session=viewer_session(args),
                savegame_path=getattr(args, "savegame", None),
            )
        except MapEditorError as error:
            raise ToolError(str(error)) from error
    elif args.command == "interface":
        from tools.interface_viewer import InterfaceViewerError, launch_interface_viewer

        try:
            launch_interface_viewer(
                get_profile(args.master).clean_dir,
                session=viewer_session(args),
                prefer_modified=getattr(args, "modified", False),
                **(
                    {"savegame_path": args.savegame}
                    if getattr(args, "savegame", None) is not None
                    else {}
                ),
            )
        except InterfaceViewerError as error:
            raise ToolError(str(error)) from error
    elif args.command == "files":
        from tools.session_panel import launch_session_browser
        launch_session_browser(viewer_session(args))
    elif args.command == "identify":
        from tools.binary_identity import identify_binary
        identity = identify_binary(args.binary, sheet=Path(args.sheet))
        print(f"{args.binary.name}: {identity.family} — {identity.reason}")
    elif args.command == "profiles":
        for profile in PROFILES:
            sheet = profile.segment_sheet or "not yet mapped"
            print(
                f"{profile.filename:18} {profile.platform:8} "
                f"{profile.product:15} segments={sheet}"
            )
    elif args.command == "paths":
        for name in ("asm", "binaries", "data", "tools"):
            print(f"{name:10} {PROJECT_ROOT / name}")
        print(f"{'whdload':10} {WHDLOAD_DIR}")
        print(f"segments   {Path(args.sheet)}")
    else:
        parser.print_help()
    return 0


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()
    if args.command is not None:
        try:
            return run(args, parser)
        except ToolError as error:
            parser.exit(2, f"Error: {error}\n")

    while True:
        profile = get_profile(args.master)
        selected = launch_gui(profile_name=active_profile_name(args))
        if selected is None:
            return 0
        args.command = selected
        try:
            if selected in {"graphics", "maps", "interface", "files"}:
                if selected == "files":
                    from tools.session_panel import launch_session_browser
                    launch_session_browser(viewer_session(args))
                    continue
                if selected == "maps":
                    from tools.map_editor.app import MapEditorError, launch_map_editor

                    try:
                        kwargs = (
                            {"savegame_path": args.savegame}
                            if getattr(args, "savegame", None) is not None
                            else {}
                        )
                        launch_map_editor(profile.clean_dir, session=viewer_session(args), **kwargs)
                    except MapEditorError as error:
                        raise ToolError(str(error)) from error
                    continue
                if selected == "interface":
                    from tools.interface_viewer import (
                        InterfaceViewerError,
                        launch_interface_viewer,
                    )

                    try:
                        kwargs = (
                            {"savegame_path": args.savegame}
                            if getattr(args, "savegame", None) is not None
                            else {}
                        )
                        launch_interface_viewer(profile.clean_dir, session=viewer_session(args), **kwargs)
                    except InterfaceViewerError as error:
                        raise ToolError(str(error)) from error
                    continue
                from tools.graphics_viewer import GraphicsViewerError, launch_graphics_viewer

                try:
                    kwargs = (
                        {"savegame_path": args.savegame}
                        if getattr(args, "savegame", None) is not None
                        else {}
                    )
                    launch_graphics_viewer(profile.clean_dir, session=viewer_session(args), **kwargs)
                except GraphicsViewerError as error:
                    raise ToolError(str(error)) from error
                continue
            if selected == "patch":
                from tools.session_panel import launch_session_browser
                launch_session_browser(viewer_session(args))
                continue
            run(args, parser)
        except ToolError as error:
            print(f"Error: {error}", file=sys.stderr)
        finally:
            # Commands selected from the launcher are one-shot jobs. Reset the
            # parsed command so errors and successful runs both return to the
            # front menu; explicit CLI commands still exit normally.
            args.command = None


if __name__ == "__main__":
    raise SystemExit(main())
