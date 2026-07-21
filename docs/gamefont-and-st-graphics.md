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

## Avatar and Beholder preview proof

The avatar sizes are defined by the 68k drawing code:

- `Avatars_Large.gfx` contains 16 images of 32 x 30 pixels. Each image is
  480 bytes (`2 words * 30 rows * 8 bytes`).
- `Shield_Avatars.gfx` contains 16 images of 32 x 16 pixels. Each image is
  256 bytes (`2 words * 16 rows * 8 bytes`).

Both files partition exactly at those boundaries and every decoded image
encodes back to its original byte range.

The corrected Beholder extraction is also lossless. Concatenating, in order,
`Beholder_Body.gfx`, `Beholder_UpperEyes.gfx`,
`Beholder_CentralEye_Near.gfx`, and `Beholder_CentralEye_Far.gfx` produces the
same 1,792 bytes as concatenating the older `Beholder_01.gfx` through
`Beholder_10.gfx` extraction.

`tools/graphics_preview.py` reproduces the assembly renderer's component
selection for all six distance levels and four facings. It uses the extracted:

- component lookup offsets and height-minus-one tables;
- composite and component position tables;
- Beholder colour-grade lookup and monster palette table;
- `FloorCeiling.gfx` for the 128 x 76 fake game window.

The floor/ceiling layout is defined directly by `Draw_FloorAndCeiling` at the
original `adrCd00B7F4`: 23 rows of ceiling, 19 cleared rows, then 34 rows of
floor. The 3,648-byte source is therefore one 128 x 57 four-plane image whose
two sections fit the game viewport exactly when the clear gap is inserted.

The game's colour-mask routine does not recolour every indexed pixel. It
replaces only template indices 0, 4, 8, and 12 with a selected four-byte
monster palette; all other indices retain their original colour. Index 15 is
the transparent mask colour for composition.

Run the proof renderer with:

```text
python tools/graphics_preview.py outputs/graphics-preview --scale 4
```

It writes avatar sheets, all 24 Beholder window combinations, a Beholder
contact sheet, exact component PNGs, red-border guide templates, and JSON
metadata. The one-pixel red border is outside the editable image. Metadata
records the editable rectangle as `[1, 1, width, height]`, so a future importer
can crop the guide away before validating palette indices and encoding planar
bytes. The border PNG is therefore a drawing aid; the adjacent borderless PNG
is the exact native-size asset.

This establishes the model for a preview/editor GUI: controls can vary monster
distance, facing, animation frame, colour grade, and screen anchor without
changing source bytes. Import should create a structured replacement for the
authoritative `.gfx` range and regenerate the preview; it should not store or
patch the contact sheet or precomposed monster image.

## Initial graphics viewer

The Pygame launcher now includes **Graphics Viewer**, also available directly:

```text
python main.py graphics
```

The initial category is Monsters and lists type codes `$64` through `$6C`.
`$64` and `$65` share the Summon graphics, while `$69` and `$6A` share the
Dragon block. `$6C` is shown as an Extended Levels expectation and is not part
of the Bloodwych 4.39 dispatch table.

Beholders are currently the only complete live renderer. Other selections
show their available `.gfx` files and the provisional `.offsets`, `.heights`,
and `.positions` companions still required. This lets metadata be extracted
incrementally without pretending that a raw `.gfx` file is independently
renderable.

The viewer exposes four facings, the eight clamped colour-grade steps, two
animation frames, and one-pixel X/Y adjustment. Image size and base screen
position are now selected through an overhead dungeon navigator rather than a
raw image-slot control.

That navigator reproduces the relevant lookups in
`Prepare_Monster_ScreenPosition`:

- `adrEA00B8AE` supplies nineteen player-relative dungeon cells. Facing north,
  these are the five cells at distance four, five at distance three, three at
  distance two, three at distance one, and the player's own cell.
- `adrB_00993B` assigns the renderer depth for each view cell.
- `adrB_009936` advances the rear formation pair by one renderer depth.
- `adrEA018A84` supplies a signed screen X position for each of four formation
  mini-spaces plus the centred/full-cell position. `$FF` means that position is
  not drawable.
- `adrB_00994E` converts the resulting depth to one of the six graphic slots,
  and `adrB_009956` supplies its base screen Y position.

The lookup confirms the asymmetric edge cases visible in the original game.
At one space to either side only two diagonal mini-spaces are drawable. At two
spaces to the side three table entries are drawable, including one rear entry
whose negative or edge X coordinate permits partial visibility depending on
the sprite and facing. At the outer edge of distance four only one or two
mini-spaces survive. The viewer renders these exact choices in blue and shows
the selected creature's facing with an arrow.

For now `tools/monster_view.py` contains a named Bloodwych 4.39 snapshot of
these small lookup tables, with the source labels and proposed extracted
filenames beside each one. They should become version-profile resources once
the corresponding rows are added to `segments.xlsx`; the GUI-facing resolver
API can remain unchanged when that loader is introduced.
