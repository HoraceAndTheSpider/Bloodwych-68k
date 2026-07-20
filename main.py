#!/usr/bin/env python3
"""Top-level command entry point for the Bloodwych ReSource SuperApp."""

from __future__ import annotations

import argparse
from pathlib import Path

from tools.tool_common import (
    DEFAULT_SEGMENTS_FILE,
    PROFILES,
    PROJECT_ROOT,
    WHDLOAD_DIR,
    ToolError,
    get_profile,
)
from tools.tool_extract import extract_segments
from tools.tool_inspect import inspect_source
from tools.tool_patch import patch_segments
from tools.tool_relabel import relabel_segments


GUI_COMMANDS = ("extract", "relabel", "inspect", "patch", "graphics")
GUI_LABELS = {
    "extract": "Extract",
    "relabel": "Relabel",
    "inspect": "Inspect / Data",
    "patch": "Patch",
    "graphics": "Graphics Viewer",
}


def launch_gui() -> str | None:
    """Show the legacy Pygame command chooser for a bare ``main.py`` launch."""
    try:
        import pygame
    except ImportError as error:
        raise ToolError(
            "Pygame is required for the graphical launcher. "
            "Install requirements.txt or run an explicit CLI command."
        ) from error

    pygame.init()
    try:
        surface = pygame.display.set_mode((400, 300))
        pygame.display.set_caption("Bloodwych ReSource")
        font = pygame.font.SysFont(None, 24)
        button_width, button_height, spacing = 180, 40, 10
        total_height = len(GUI_COMMANDS) * (button_height + spacing) - spacing
        start_y = (300 - total_height) // 2
        buttons = [
            (
                pygame.Rect(
                    (400 - button_width) // 2,
                    start_y + index * (button_height + spacing),
                    button_width,
                    button_height,
                ),
                command,
            )
            for index, command in enumerate(GUI_COMMANDS)
        ]
        clock = pygame.time.Clock()

        while True:
            mouse_position = pygame.mouse.get_pos()
            surface.fill((30, 30, 30))
            for rectangle, command in buttons:
                colour = (80, 80, 240) if rectangle.collidepoint(mouse_position) else (50, 50, 200)
                pygame.draw.rect(surface, colour, rectangle)
                label = font.render(GUI_LABELS[command], True, (255, 255, 255))
                surface.blit(label, label.get_rect(center=rectangle.center))
            pygame.display.flip()

            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    return None
                if event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
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
        help="Configured binary filename (default: BLOODWYCH439)",
    )
    parser.add_argument(
        "-s",
        "--sheet",
        default=str(DEFAULT_SEGMENTS_FILE),
        help="segments.xlsx or compatible CSV definition",
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
    subparsers.add_parser("graphics", help="Open the extracted graphics viewer")
    subparsers.add_parser("profiles", help="List configured game binaries")
    subparsers.add_parser("paths", help="Show the canonical project paths")
    return parser


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
        relabel_segments(args.master, args.sheet)
    elif args.command == "graphics":
        from tools.graphics_viewer import GraphicsViewerError, launch_graphics_viewer

        try:
            launch_graphics_viewer(get_profile(args.master).clean_dir)
        except GraphicsViewerError as error:
            raise ToolError(str(error)) from error
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
    try:
        while args.command is None:
            selected = launch_gui()
            if selected is None:
                return 0
            if selected == "graphics":
                from tools.graphics_viewer import GraphicsViewerError, launch_graphics_viewer

                try:
                    launch_graphics_viewer()
                except GraphicsViewerError as error:
                    raise ToolError(str(error)) from error
                continue
            args.command = selected
        return run(args, parser)
    except ToolError as error:
        parser.exit(2, f"Error: {error}\n")


if __name__ == "__main__":
    raise SystemExit(main())
