# Map viewer and editor

The map workspace is a separate top-level SuperApp section because its five
working modes share a selected tower, floor and map location but require much
more space than a Data Viewer tab:

1. Viewer and overlays
2. Map-cell editor
3. Object-stack editor
4. Character and monster editor
5. Floor-layout editor

The current vertical slice implements the first two modes. The remaining mode
tabs are deliberately visible but disabled so their eventual placement and
shared state do not require another UI redesign.

## Authoritative map resource

Each Bloodwych tower owns one fixed `$1000`-byte `.map` resource. Its `$38`-byte
header contains eight widths, eight heights, eight big-endian data offsets,
eight X alignment values, eight Y alignment values, the special-floor
width/height/offset triplet and the top-floor number. The remaining `$FC8`
bytes hold two bytes per map location.

The Python `TowerMap` model retains the complete resource as a `bytearray`.
Reading and writing an ordinary map cell therefore changes exactly two bytes;
unknown bits and all unused capacity remain untouched. The four AMOS editor
nibbles are exposed as `A`, `B`, `C`, and `D`, while the visible map type is the
bottom three bits of `D`.

The displayed map follows the AMOS high-resolution geometry: one logical cell
is 16×8 pixels, with each logical Y pixel shown two physical pixels high. This
produces square 16×16 screen cells without changing the source coordinates.
The grid owns logical row 0 and column 0. `_DRAWICON` receives the inset bounds
`INX/INY = cell origin + (1,1)` and `OUTX/OUTY = cell origin + (15,7)`, so the
actual icon area is 15×7 logical pixels. Wall furniture, doors, stairs,
pads/pits and magic squares use those bounds exactly; treating all 16×8 pixels
as drawable makes the symbols too large and pushes them against the grid.
The extracted five-row `GameFont` is currently reserved for authentic map
symbols. In particular, beds use the original `B` glyph and spell-fizzle zones
use `F`; the surrounding modern application interface uses the system font.
This keeps the data view readable without implying that every SuperApp label
is part of an emulated Bloodwych screen.

The view can be zoomed from 1× to 4× with nearest-neighbour pixels. At enlarged
scales it can be panned with the on-screen controls, Shift+arrow keys, or by
dragging with the middle/right mouse button. Map coordinates and the floor's
X/Y alignment remain authoritative; zoom and pan are preview state only.
The chosen zoom level persists when changing floor or tower; the pan position
returns to the new map's origin so its initial cursor remains visible. `FIT`
is the explicit control which returns both zoom and pan to their defaults.

## First-person cursor view

Viewer mode includes a live 128×76 Bloodwych dungeon view at the map cursor.
It uses the same extracted `.gfx`, `.offsets`, `.positions`, palette masks and
source-derived 19-cell visibility tables as the Dungeon Graphics data viewer.
The map translation covers stone walls and their facing features, independent
N/E/S/W wooden walls and doors, beds, pillars, stairs, large doors, pits, pads,
ceiling holes, Firepaths, Mindrocks and Formwalls. It does not substitute
newly drawn editor artwork.

`Q` and `E` turn left/right by 90 degrees. `W` and `S` move forward/backward;
`A` and `D` strafe left/right relative to the current facing. Arrow keys remain
absolute map-cursor movement. The small line inside the cycling cursor shows
the current facing. Cursor movement is intentionally an editor navigation
operation and is not blocked by game collision rules.

The live preview also reproduces the game's movement texture parity,
`(X + Y + facing) & 1`. Each one-cell move or 90-degree turn alternates the
floor/ceiling orientation and the paired main stone-wall picture set, giving
the same interpreted impression of movement as the original renderer.

Every visible coordinate outside the current floor is supplied to the renderer
as an opaque stone wall. Consequently a view from a map edge is sealed rather
than exposing empty floor/ceiling beyond the resource. The player/current cell
is view cell 18 and is composited after the eighteen cells ahead and beside it.
This supplies the source's inside-cell wooden side walls, open large-door and
stair structures, trigger pads, floor pits, and ceiling holes.

Object and monster buttons remain visible but disabled. Their map locations
and first-person composition will be enabled only after the Objects and
Character/Monster editors share verified decoded models with the Data Viewer.

## Clean and modified data

Ordinary editing loads a tower from its matching modified map when one already
exists, otherwise it falls back to the clean extraction. Saving writes only
the dirty `$1000` map resource to:

```text
data/BLOODWYCH439-modified/maps/<tower>.map
```

The original file in `BLOODWYCH439-clean` is never altered. Existing Extract,
Inspect and Patch tools can consequently validate and patch the replacement by
the same spreadsheet-defined resource name.

## WHDLoad save overlay

The AMOS editor loads a Bloodwych save at the binary address represented by
`Character_Stats_DataTable`. Resources later in the binary are therefore found
at a stable save offset:

```text
save offset = resource binary offset - Character_Stats_DataTable binary offset
```

The map project resolves both addresses from `segments.xlsx`; no map or save
address is hard-coded in Python. Maps, object blocks, packed monster blocks and
monster counts are within the save overlay. Switch and trigger definition
tables precede the champion table, so they continue to come from the extracted
game data.

Launching with:

```text
python main.py maps --savegame whdload/bloodsave0
```

reads map state from that save. Saving copies the complete save, patches only
the dirty map slices and writes it to:

```text
data/BLOODWYCH439-modified/whdload/bloodsave0
```

The supplied WHDLoad save is never overwritten.

## Viewer overlays

The two verified overlays can be toggled independently:

- Switch references are recovered from type-1 map cells. Their action and
  target coordinates come from the tower's 16 four-byte switch definitions.
- Trigger references are recovered from type-6 pad cells. Their action and
  optional floor/X/Y target come from the tower's 32 four-byte trigger
  definitions.
The Monsters and Objects buttons remain visible but disabled. Their markers
are not drawn until their respective packed/variable-length layouts,
coordinate conversion, and graphical editors are reviewed together; the
present decoders are retained only as backend groundwork for those tasks.

This separation is important: a map cell stores a switch or trigger reference,
not the complete action. The target data is shared by every use of that
reference and, for switches, can intentionally be reused across floors.

Trigger reference 0 is the null/no-event record. The overlay deliberately
does not number it. For non-zero triggers whose action uses X/Y coordinates,
the overlay links the numbered source cell to a numbered target cell and boxes
the affected location, recreating the relationship shown by the AMOS editor
rather than presenting the pad reference in isolation.

## Semantic map controls

The Maps tab retains the raw two-byte and four-nibble display for diagnosis,
but normal editing uses controls derived from the AMOS `_DESC0` to `_DESC7`
meanings. These include wall feature/facing/state, four independent wooden
sides, bed/pillar, stair direction and elevation, metal-door construction and
lock, floor/ceiling-hole combinations, and magic kind/power. Changing a map
type creates a valid visible default rather than carrying unrelated nibbles
from the old type.

Switch and trigger controls change the map cell's shared reference. The viewer
also decodes and reports the referenced action and target from the companion
table. In an ordinary game-map project, action and target controls edit the
shared four-byte record and save the named `.switches` or `.triggers` resource
to the modified tree. The UI identifies this as a shared change because every
cell using that reference is affected. These controls are read-only when a
WHDLoad save is overlaid: the tables precede the saved block and are not
present in the save, so Save continues to alter only the copied save file.

## Follow-on modes

The object mode will edit complete variable-length stacks and write the
existing fixed `$402` resource only after validating its `$400`-byte payload
capacity. Character/monster pop-ups will distinguish hero records and pockets
from packed or live monster records; editing a graphic definition remains a
separate shared-resource operation. The layout mode will rebuild all eight
floor offsets after a width/height change, enforce the `$FC8` total map-data
capacity, and preview aligned floors above and below.

Once those structured editors are stable, the existing dungeon renderer can
be attached to the selected cell and direction to provide a walkable pseudo
game view without introducing a second map-data interpretation.
