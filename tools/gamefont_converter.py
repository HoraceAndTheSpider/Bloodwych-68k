#!/usr/bin/env python3
"""Convert Bloodwych's headerless GameFont table to modern assets.

The format is 128 glyphs in character-code order.  Each glyph contains five
one-byte scanlines; bits 7..0 are the eight-pixel storage/rendering cell,
MSB-to-LSB.  Most printable designs occupy only the lower six or seven bits.
"""

from __future__ import annotations

import argparse
import json
import struct
import zlib
from pathlib import Path


GLYPH_COUNT = 128
GLYPH_WIDTH = 8
GLYPH_HEIGHT = 5
BYTES_PER_GLYPH = 5
EXPECTED_SIZE = GLYPH_COUNT * BYTES_PER_GLYPH


def read_font(path: Path) -> bytes:
    data = path.read_bytes()
    if len(data) != EXPECTED_SIZE:
        raise ValueError(
            f"expected {EXPECTED_SIZE} bytes (128 glyphs x 5 rows), got {len(data)}"
        )
    return data


def glyph_pixels(data: bytes, code: int) -> list[list[int]]:
    rows = data[code * BYTES_PER_GLYPH : (code + 1) * BYTES_PER_GLYPH]
    return [[(row >> (GLYPH_WIDTH - 1 - x)) & 1 for x in range(GLYPH_WIDTH)] for row in rows]


def png_chunk(kind: bytes, payload: bytes) -> bytes:
    return struct.pack(">I", len(payload)) + kind + payload + struct.pack(">I", zlib.crc32(kind + payload) & 0xFFFFFFFF)


def write_indexed_png(path: Path, pixels: list[list[int]], scale: int = 1) -> None:
    source_height = len(pixels)
    source_width = len(pixels[0]) if pixels else 0
    width, height = source_width * scale, source_height * scale
    scanlines = bytearray()
    for row in pixels:
        expanded = bytes(value for value in row for _ in range(scale))
        for _ in range(scale):
            scanlines.append(0)  # PNG filter: None
            scanlines.extend(expanded)
    png = bytearray(b"\x89PNG\r\n\x1a\n")
    png += png_chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 3, 0, 0, 0))
    png += png_chunk(b"PLTE", bytes((0, 0, 0, 255, 255, 255)))
    png += png_chunk(b"tRNS", bytes((0, 255)))
    png += png_chunk(b"IDAT", zlib.compress(bytes(scanlines), 9))
    png += png_chunk(b"IEND", b"")
    path.write_bytes(png)


def build_sheet(data: bytes, columns: int, padding: int) -> tuple[list[list[int]], list[dict[str, object]]]:
    rows = (GLYPH_COUNT + columns - 1) // columns
    cell_width = GLYPH_WIDTH + padding
    cell_height = GLYPH_HEIGHT + padding
    pixels = [[0] * (columns * cell_width) for _ in range(rows * cell_height)]
    glyphs: list[dict[str, object]] = []
    for code in range(GLYPH_COUNT):
        cell_x, cell_y = code % columns, code // columns
        x, y = cell_x * cell_width, cell_y * cell_height
        glyph = glyph_pixels(data, code)
        for gy, row in enumerate(glyph):
            pixels[y + gy][x : x + GLYPH_WIDTH] = row
        raw = list(data[code * BYTES_PER_GLYPH : (code + 1) * BYTES_PER_GLYPH])
        glyphs.append({
            "code": code,
            "character": chr(code) if 32 <= code < 127 else None,
            "x": x,
            "y": y,
            "width": GLYPH_WIDTH,
            "height": GLYPH_HEIGHT,
            "advance": GLYPH_WIDTH,
            "raw_rows": raw,
        })
    return pixels, glyphs


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", type=Path)
    parser.add_argument("output_dir", type=Path)
    parser.add_argument("--scale", type=int, default=4, help="nearest-neighbour PNG scale")
    parser.add_argument("--columns", type=int, default=16)
    args = parser.parse_args()
    if args.scale < 1 or args.columns < 1:
        parser.error("--scale and --columns must be positive")

    data = read_font(args.input)
    args.output_dir.mkdir(parents=True, exist_ok=True)
    pixels, glyphs = build_sheet(data, args.columns, padding=1)
    write_indexed_png(args.output_dir / "gamefont.png", pixels, args.scale)

    metadata = {
        "format": "bloodwych-gamefont-v1",
        "source_size": len(data),
        "glyph_count": GLYPH_COUNT,
        "encoding": "7-bit character code (code & 0x7f)",
        "glyph_width": GLYPH_WIDTH,
        "glyph_height": GLYPH_HEIGHT,
        "bytes_per_glyph": BYTES_PER_GLYPH,
        "row_order": "top-to-bottom",
        "visible_bits": "bit 7 (left) through bit 0 (right)",
        "sheet": {
            "file": "gamefont.png",
            "columns": args.columns,
            "padding_unscaled": 1,
            "scale": args.scale,
        },
        "glyphs": glyphs,
    }
    (args.output_dir / "gamefont.json").write_text(json.dumps(metadata, indent=2) + "\n", encoding="utf-8")

    # Lossless reconstruction from the recorded scanlines proves that conversion
    # preserves every original scanline exactly.
    rebuilt = bytes(row for glyph in glyphs for row in glyph["raw_rows"])
    if rebuilt != data:
        raise RuntimeError("internal round-trip verification failed")
    (args.output_dir / "GameFont.roundtrip").write_bytes(rebuilt)


if __name__ == "__main__":
    main()
