#!/usr/bin/env python3
"""Decode Bloodwych Atari ST 4-plane assets using game metadata tables.

The companion `.offsets` file contains big-endian 16-bit byte offsets.  Each
four-byte `.positions` entry contains x/2, y, width-in-16px-words minus one,
and height minus one.  These tables are authoritative game data, not editor
geometry.
"""

from __future__ import annotations

import argparse
import json
import struct
import zlib
from pathlib import Path


GAME_PALETTE_WORDS = (
    0x0000, 0x0444, 0x0666, 0x0888,
    0x0AAA, 0x0292, 0x01C1, 0x000E,
    0x048E, 0x0821, 0x0B31, 0x0E96,
    0x0D00, 0x0FD0, 0x0EEE, 0x0C08,
)


def amiga_12bit_to_rgb8(word: int) -> tuple[int, int, int]:
    """Expand an Amiga $0RGB colour word to exact 8-bit RGB channels."""
    return ((word >> 8 & 0xF) * 17, (word >> 4 & 0xF) * 17, (word & 0xF) * 17)


GAME_PALETTE_RGB8 = tuple(amiga_12bit_to_rgb8(word) for word in GAME_PALETTE_WORDS)


def png_chunk(kind: bytes, payload: bytes) -> bytes:
    crc = zlib.crc32(kind + payload) & 0xFFFFFFFF
    return struct.pack(">I", len(payload)) + kind + payload + struct.pack(">I", crc)


def write_indexed_png(
    path: Path,
    pixels: list[list[int]],
    *,
    scale: int = 1,
    transparent_index: int | None = None,
) -> None:
    source_height = len(pixels)
    source_width = len(pixels[0]) if pixels else 0
    scanlines = bytearray()
    for row in pixels:
        expanded = bytes(value for value in row for _ in range(scale))
        for _ in range(scale):
            scanlines.append(0)
            scanlines.extend(expanded)
    png = bytearray(b"\x89PNG\r\n\x1a\n")
    png += png_chunk(
        b"IHDR",
        struct.pack(">IIBBBBB", source_width * scale, source_height * scale, 8, 3, 0, 0, 0),
    )
    png += png_chunk(b"PLTE", bytes(channel for rgb in GAME_PALETTE_RGB8 for channel in rgb))
    if transparent_index is not None:
        alpha = bytearray((255,) * 16)
        alpha[transparent_index] = 0
        png += png_chunk(b"tRNS", bytes(alpha))
    png += png_chunk(b"IDAT", zlib.compress(bytes(scanlines), 9))
    png += png_chunk(b"IEND", b"")
    path.write_bytes(png)


def decode_planar(data: bytes, width_words: int, height: int) -> list[list[int]]:
    expected = width_words * height * 8
    if len(data) != expected:
        raise ValueError(f"asset needs {expected} bytes, got {len(data)}")
    pixels: list[list[int]] = []
    cursor = 0
    for _ in range(height):
        row: list[int] = []
        for _ in range(width_words):
            planes = struct.unpack_from(">4H", data, cursor)
            cursor += 8
            for bit in range(15, -1, -1):
                row.append(sum(((plane >> bit) & 1) << index for index, plane in enumerate(planes)))
        pixels.append(row)
    return pixels


def encode_planar(pixels: list[list[int]]) -> bytes:
    if not pixels or len(pixels[0]) % 16:
        raise ValueError("pixel width must be a non-zero multiple of 16")
    width = len(pixels[0])
    if any(len(row) != width for row in pixels):
        raise ValueError("all rows must have the same width")
    output = bytearray()
    for row in pixels:
        for start in range(0, width, 16):
            planes = [0, 0, 0, 0]
            for x, colour in enumerate(row[start : start + 16]):
                if not 0 <= colour <= 15:
                    raise ValueError(f"palette index out of range: {colour}")
                bit = 15 - x
                for plane in range(4):
                    planes[plane] |= ((colour >> plane) & 1) << bit
            output += struct.pack(">4H", *planes)
    return bytes(output)


def read_tables(gfx_path: Path, offsets_path: Path, positions_path: Path) -> tuple[bytes, list[int], list[tuple[int, int, int, int]]]:
    gfx = gfx_path.read_bytes()
    offsets_data = offsets_path.read_bytes()
    positions_data = positions_path.read_bytes()
    if len(offsets_data) % 2 or len(positions_data) % 4:
        raise ValueError("offset table must be word-aligned and position table must be longword-aligned")
    offsets = list(struct.unpack(f">{len(offsets_data) // 2}H", offsets_data))
    positions = [entry for entry in struct.iter_unpack(">4B", positions_data)]
    if len(offsets) != len(positions):
        raise ValueError(f"{len(offsets)} offsets but {len(positions)} positions")
    return gfx, offsets, positions


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("gfx", type=Path)
    parser.add_argument("offsets", type=Path)
    parser.add_argument("positions", type=Path)
    parser.add_argument("output_dir", type=Path)
    parser.add_argument("--scale", type=int, default=2)
    parser.add_argument("--transparent-index", type=int, default=None)
    args = parser.parse_args()
    if args.scale < 1 or (args.transparent_index is not None and not 0 <= args.transparent_index <= 15):
        parser.error("invalid scale or transparent index")

    gfx, offsets, positions = read_tables(args.gfx, args.offsets, args.positions)
    sprites_dir = args.output_dir / "sprites"
    sprites_dir.mkdir(parents=True, exist_ok=True)
    decoded: list[tuple[dict[str, object], list[list[int]]]] = []

    for index, (offset, (x_half, y, width_minus_1, height_minus_1)) in enumerate(zip(offsets, positions)):
        width_words, height = width_minus_1 + 1, height_minus_1 + 1
        byte_size = width_words * height * 8
        expected_end = offsets[index + 1] if index + 1 < len(offsets) else len(gfx)
        if offset + byte_size != expected_end:
            raise ValueError(
                f"asset {index}: geometry ends at {offset + byte_size:#x}, next boundary is {expected_end:#x}"
            )
        raw = gfx[offset:expected_end]
        pixels = decode_planar(raw, width_words, height)
        if encode_planar(pixels) != raw:
            raise RuntimeError(f"asset {index}: codec round trip failed")
        filename = f"{index:02d}.png"
        write_indexed_png(
            sprites_dir / filename,
            pixels,
            scale=args.scale,
            transparent_index=args.transparent_index,
        )
        record: dict[str, object] = {
            "index": index,
            "byte_offset": offset,
            "byte_size": byte_size,
            "x_half": x_half,
            "x_pixels": x_half * 2,
            "y_pixels": y,
            "width_words": width_words,
            "width_pixels": width_words * 16,
            "height_pixels": height,
            "file": f"sprites/{filename}",
        }
        decoded.append((record, pixels))

    canvas_width = max(int(record["x_pixels"]) + int(record["width_pixels"]) for record, _ in decoded)
    canvas_height = max(int(record["y_pixels"]) + int(record["height_pixels"]) for record, _ in decoded)
    canvas = [[args.transparent_index if args.transparent_index is not None else 0] * canvas_width for _ in range(canvas_height)]
    for record, pixels in decoded:
        x, y = int(record["x_pixels"]), int(record["y_pixels"])
        for row_number, row in enumerate(pixels):
            for column, colour in enumerate(row):
                if args.transparent_index is None or colour != args.transparent_index:
                    canvas[y + row_number][x + column] = colour
    write_indexed_png(
        args.output_dir / "composite.png",
        canvas,
        scale=args.scale,
        transparent_index=args.transparent_index,
    )

    metadata = {
        "format": "bloodwych-st-planar-assets-v1",
        "source": args.gfx.name,
        "source_size": len(gfx),
        "asset_count": len(decoded),
        "pixel_encoding": "four big-endian 16-bit plane words per 16 pixels; plane 0 is colour bit 0",
        "position_encoding": "x/2, y, width_words_minus_1, height_minus_1",
        "palette": {
            "name": "Bloodwych GamePalette",
            "encoding": "Amiga 12-bit $0RGB expanded to 8-bit channels with nibble * 17",
            "words_hex": [f"{word:03X}" for word in GAME_PALETTE_WORDS],
            "rgb8": [list(rgb) for rgb in GAME_PALETTE_RGB8],
        },
        "transparent_index": args.transparent_index,
        "scale": args.scale,
        "assets": [record for record, _ in decoded],
    }
    (args.output_dir / "assets.json").write_text(json.dumps(metadata, indent=2) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
