# Bloodwych GameFont and Atari ST graphics findings

## GameFont

The Bloodwych 4.39 `GameFont` file is a headerless 640-byte bitmap table:

- 128 glyphs, addressed by `character_code & 0x7f`.
- Five bytes per glyph (`character_code * 5`).
- Each byte is one horizontal scanline, top to bottom.
- All eight bits form an eight-pixel scanline, bit 7 through bit 0 from left
  to right. Most printable designs occupy only the lower six or seven bits.
- The resulting storage/rendering cell is 8 x 5 pixels.

The 68k routines at `GameFont` calculate `code * 5`, loop five times, and
advance the screen destination by one scanline after each byte. The data also
validates the interpretation directly: character `A` is represented by rows
`0c 12 3f 21 33`.

`tools/gamefont_converter.py` generates an indexed, transparent PNG sheet,
JSON metadata, and a byte-identical reconstructed font. The JSON retains all
eight bits of every original row. That makes the conversion safe for future
editing and binary re-export.

A spritesheet is preferable to TTF/WOFF as the canonical representation. A
normal outline webfont adds hinting, baseline, spacing, and resampling concerns
that do not exist in the game. The browser should render the indexed sheet with
nearest-neighbour scaling. A generated OpenType bitmap wrapper could later be
offered for convenience, but it should remain a derivative asset rather than
the editable source.

## Atari ST four-plane graphics

The AMOS graphics loader correctly decodes the native repeating unit:

```text
offset + 0: plane 0, big-endian 16-bit word
offset + 2: plane 1, big-endian 16-bit word
offset + 4: plane 2, big-endian 16-bit word
offset + 6: plane 3, big-endian 16-bit word
```

Each eight-byte unit produces 16 indexed pixels. For pixel `x`, with bit
`15 - x` from each plane, the palette index is:

```text
p0 | (p1 << 1) | (p2 << 2) | (p3 << 3)
```

The AMOS write routine performs the exact inverse operation, so the codec can
support edited graphics and byte-for-byte round trips. This codec should be a
small shared core service, usable in both Python and TypeScript test vectors.

Bloodwych's main palette is stored as 16 Amiga `$0RGB` words. Each four-bit
channel expands exactly to eight bits by multiplying by 17. The indexed PNG
outputs use this palette and can retain index 15 (`$C08`) as transparent for
assets whose game blitter treats all four set plane bits as the mask colour.

A second 16-word table is a strong hardware-sprite palette candidate. Its two
non-zero colour groups are `[22E, 48E, EEE]` and `[E00, E83, EEE]`, each
preceded by a zero/transparent entry. This matches the Amiga hardware-sprite
organisation into four-colour groups, but remains marked probable until the
68k register-write path or cursor data reference is labelled.

The hard-coded AMOS `Data` sections do not describe the pixel encoding. They
are a hand-transcribed approximation of metadata that is itself stored in the
game. The `Main_Walls` case has two authoritative companion tables:

- `.offsets`: big-endian 16-bit byte offsets into `.gfx`.
- `.positions`: four-byte records containing `x/2`, `y`,
  `width_in_16px_words - 1`, and `height - 1`.

For `Main_Walls`, all 28 offset and position records exactly partition the
18,736-byte graphics block. This also proves that the second number in each old
AMOS pair was total strip count, not height: height was implicitly total strips
divided by strip width. Several hand-entered AMOS values differ from the game
tables, while the extracted position geometry matches every byte boundary.

The app should therefore extract these tables from the executable and derive
descriptors from them, rather than maintain independent geometry JSON as an
authority. Versioned JSON remains useful as generated project metadata and for
human-readable names or roles. A generated descriptor should record:

```json
{
  "id": "head_parts_00",
  "segment": "Head_Parts",
  "byte_offset": 0,
  "width_pixels": 16,
  "height_pixels": 111,
  "palette": "characters",
  "transparent_index": 15,
  "role": "character-template"
}
```

Offsets should be read from the extracted offset table and checked against the
size calculated from the corresponding position record. Width must be a
multiple of 16 for the raw planar layer. Optional `.heights` tables should be
modelled as another game-owned metadata source for formats whose position
records do not contain sufficient vertical geometry. Visual crops, hotspots,
semantic names, and composition roles can remain as separate annotations.

## Place in the super app

The recommended asset flow is:

```text
uploaded executable
  -> version profile and segment manifest
  -> immutable planar bytes plus offset/position/height tables
  -> shared indexed-pixel decoder
  -> named sprite/template descriptors
  -> palette substitution and composition
  -> cached previews/spritesheets
  -> edited indexed pixels
  -> planar encoder
  -> structured change record and build planner
```

`bobs.abk` should be treated as a cache, not authoritative input. The AMOS
editor already builds its colour character and monster BOBs from templates and
game palette tables. A modern browser can do this on demand and cache results.
BOBs 1-3 are exceptions only in provenance: a small editor cursor and two game
mouse cursors. The latter should be identified in the executable/source and
decoded through the same planar pipeline; the editor-only square can be drawn
procedurally.

Generated colour sprites should never be patched back directly unless they map
to an authoritative game segment. Edits should target the source template,
palette table, or original planar segment, then regenerate all dependent
previews. This is what allows modified game graphics to be loaded, displayed,
edited, and rebuilt consistently.
