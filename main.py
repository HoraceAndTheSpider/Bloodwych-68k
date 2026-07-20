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
)
from tools.tool_extract import extract_segments
from tools.tool_inspect import inspect_source
from tools.tool_patch import patch_segments
from tools.tool_relabel import relabel_segments


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
    subparsers.add_parser("profiles", help="List configured game binaries")
    subparsers.add_parser("paths", help="Show the canonical project paths")
    return parser


def run(args: argparse.Namespace, parser: argparse.ArgumentParser) -> int:
    if args.command == "extract":
        extract_segments(args.master, args.sheet, args.name, args.debug)
    elif args.command == "patch":
        patch_segments(args.master, args.sheet, args.name, args.debug)
    elif args.command == "inspect":
        inspect_source(args.master, args.sheet, args.name, args.label, args.debug)
    elif args.command == "relabel":
        relabel_segments(args.master, args.sheet)
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
        return run(args, parser)
    except ToolError as error:
        parser.exit(2, f"Error: {error}\n")


if __name__ == "__main__":
    raise SystemExit(main())
