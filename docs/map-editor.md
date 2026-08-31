# Map viewer and editor

The map workspace is a separate top-level SuperApp section because its five
working modes share a selected tower, floor and map location but require much
more space than a Data Viewer tab:

1. Viewer and overlays
2. Map-cell editor
3. Object-stack editor
4. Character and monster editor
5. Floor-layout editor

All five modes are implemented. Layout exposes the source map header while
keeping the same tower/floor selection, zoom and pan state as the other tabs.

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
`A` and `D` strafe left/right relative to the current facing. These controls and
mapped joypad movement work in **all five map modes**. Arrow keys remain
absolute map-cursor movement, or edit the selected property; Escape deselects
that property. Moving the cursor pans it into view without changing zoom.
Use **JOYPAD (F8)** to [define device-specific movement, pointer and fire controls](joypad-controls.md).
The small line inside the cycling cursor shows
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

Actor markers and the first-person composition pass are shared by Viewer,
Objects, and Characters / Monsters rather than being maintained as separate
map models.

## Floor layout and elevation checks

Layout edits each floor's width, height, X/Y placement and the tower's highest
floor index. The original header calls the latter the top floor; its stored
value is an index from 0 to 7, so the displayed floor count is that value plus
one. Width, height and alignment follow the AMOS editor's 31-cell layout space.

Changing a dimension safely repacks all eight sequential cell grids. Cells
inside the old and new bounds retain their X/Y coordinates, new cells are
cleared, and every later floor offset is recalculated. Object-stack map indices
are moved with their floors. A shrink is rejected when it would exclude an
existing object stack, rather than silently moving that stack to another floor.
The fixed-size editor continues to enforce the original `$FC8`-byte cell-data
capacity inside each `$1000` map resource. **Clear Floor** is a two-click
operation which zeros every map cell on the selected floor without changing its
size, alignment or the separate object-stack resource.

Header words `$30`, `$32` and `$34` are the AMOS editor's **special floor**
width, height and data offset. Every original SPS 439 tower duplicates one
ordinary floor record there, but it is not an entrance/exit coordinate. The
game copies the complete `$38`-byte header into runtime state when loading a
tower, which initially places the special width and height in the live geometry
fields. Exact-text source tracing finds no SPS 439 instruction that reads the
word copied from `$34`; floor selection instead loads the live data offset from
the ordinary eight-entry table and replaces the active width and height at the
same time. The triplet is therefore best treated as a bootstrap/legacy floor
descriptor maintained by the AMOS tool, not as a gameplay in/out point. Layout
preserves these source bytes but does not expose them as a user control.

There is only one shared live geometry area. Player and character operations
load the floor number from the relevant record before using map coordinates;
player floor is read from player-data offset `$58`. Two players on different
floors are therefore handled serially by loading each player's floor geometry,
not by assigning either player to the legacy header triplet.

The map area follows the original Layout view by hiding ordinary walls and
objects and retaining only stairs, floor pits and ceiling holes. Above and below
previews start enabled and can be toggled independently. Their translucent grids
and elevation symbols use small opposing pixel shifts, so their X/Y alignment
remains visible. Red outlines identify elevation links
which need review. Pits require a ceiling hole at the same world X/Y on the
floor below, and ceiling holes require the corresponding pit above. The stair
check follows the movement source: a transition changes one floor and advances
twice through the stair's permitted movement direction, so the matching
opposite stair is two world cells forward and faces back toward the source. The
optional green link-line overlay joins only stair pairs which pass that check.
Unusual intentional stair tricks remain editable; red is guidance, not a save
blocker.

The source does directly encode the map/object boundary. Runtime routines start
object records at `$0FCA` bytes after the `$38`-byte map header, which is
`$1002` from the map base: the fixed `$1000` map followed by the object's
two-byte used-length word. A source build that increases map capacity must at
least turn that displacement into a shared EQU and give every tower the same
padded map allocation. Object locations retain a 14-bit map-data byte offset in
the 68000 source (`and.w #$3FFF`), so `$1000` is not the encoding's fundamental
ceiling. It is nevertheless not a one-EQU change: the six tower block addresses
use a word-sized `LevelDataOffsets` table, and a substantial increase can push
later tower displacements beyond its positive word range. The Python object
codec also deliberately enforces the original 12-bit range until this relocated
source format exists.

The `$402` object files have a `$400` payload reserve in the original binary,
but the game traverses their stored used length and tower addresses are
assembled from labels; there is no equivalent game instruction whose value must
equal the longest object block. Larger object blocks still change all following
addresses, the word-sized tower offsets, and the save layout, so they require a
source build and cannot use fixed-size binary patching. The object editor now
reports that boundary explicitly as **source build required** instead of
silently overfilling the resource.

## Shared session data

Maps, actors, objects and artwork read one live editing session. Modified files
are imported explicitly through **DATA / FILES**. There is no independent art
clean/modified toggle. Returning to the launcher and opening another viewer
retains edits without saving. **EXPORT ALL** writes the whole session to
`-modified`; **PATCH** validates fixed sizes and writes a separate binary/save
copy. Clean resources and original inputs remain immutable.

See [shared editing sessions](edit-session.md) for RESET, section RELOAD,
snapshot imports, save compatibility and future play-test isolation.

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

reads map state from that save. EXPORT preserves a resumable session snapshot.
PATCH, after confirmation, copies the complete save and applies changes only
within its fixed bounds. The output is:

```text
data/BLOODWYCH439-modified/whdload/bloodsave0
```

The supplied WHDLoad save is never overwritten; if the output exists, a numbered
successor is written.
Object stacks and packed monsters can therefore be edited where their resource
segments are present. Switches, triggers, and shared character-design tables
remain read-only because they are outside the portable save block.

## Viewer overlays

The map overlays can be toggled independently:

- Switch references are recovered from type-1 map cells. Their action and
  target coordinates come from the tower's 16 four-byte switch definitions.
- Trigger references are recovered from type-6 pad cells. Their action and
  optional floor/X/Y target come from the tower's 32 four-byte trigger
  definitions.
- Champion, monster, spell, and player markers reproduce the AMOS viewer's
  inset map legend: champions are yellow `C`; monster forms are red `M`
  (darker above `$64`); airborne spell forms are blue `S`; player 1 and 2 are
  blue and red `P` respectively. Without a save overlay, blue and red `Q`
  markers identify the Player 1 and Player 2 Quickstart locations instead.
- The Objects overlay adds a small white `X` at each variable-length object
  stack's authored NW/NE/SW/SE corner. Named keys add a centred
  four-pixel dot using their extracted floor-palette ink; common keys retain
  the plain stack marker.
- In a raw-game view, `QS TEAMS` chooses between the two Quickstart parties
  plus the other eight champions at their original placements, and all sixteen
  champions at their original placements. It starts off and is disabled for
  saves, whose champion and party records are already live state.

For extracted game data, monster markers use the per-tower packed six-byte
records. With a WHDLoad save, the project reads the current-tower byte from
the save and uses its live 16-byte workspace for that tower only; all other
towers retain their packed records. This matches the AMOS editor and avoids
presenting initial placements as live state. The current save also supplies
player positions and the Keep's champion positions. Its four player-team
slots are used to place each active champion at the corresponding `P` location
in the first-person view. In no-save mode, `QkPly1_Start` and `QkPly2_Start`
provide equivalent Quickstart teams and locations for `Q` markers and preview.
When Quickstart teams are off, the raw `champions.stats` records provide all
sixteen original Keep positions instead.

For a raw champion placement, champion stat byte `$18` contains both values
used by `Draw_DungeonCellOccupants`: low bits 0-1 supply the character artwork
direction and bits 4-5 select one of four stable floor mini-spaces. The latter
is rotated into the viewer frame before screen placement. Active player-party
members instead share their player's direction from `PlayerData+$21`, while
their party slots choose the formation positions. Both Quickstart players
begin facing North.

The AMOS map marker intentionally skips records with an X byte of `$FF`.
That sentinel is used by the second through fourth members of a monster team:
they share their team's lead location rather than owning another map marker.
The first-person renderer expands those members at the lead position, matching
the game's `Draw_DungeonCellOccupants` team-table traversal, so their character
or monster graphics are all composited. For a raw packed group, the `KL` low
two bits supply its stable authored member slots; Quickstart uses the same
fixed four-byte team order. The packed monster-count word is a final record
index, so the viewer includes that entry rather than treating it as a total.

The cursor's first-person preview uses the existing Character, large-monster,
and Airbourne-spell renderers wherever the form has a verified graphics
definition. It places them through the source 19-cell and mini-space lookup
tables at the original renderer's actor call sites: empty space, stairs, main
doors and pits/pads render actors after their feature. Wooden walls are more
specific: `Resolve_WoodenWallFace` calls the actor routine inside its four-face
loop, after the rear faces and before the foreground face selected by the
source's `d5` branch. Stone, beds/pillars and magic cells have no actor call.
Packed records do
not retain a heading: their
cleared runtime state selects the source-default artwork. In live record byte
`$02`, the low bits select artwork direction and bits 4-5 select the stable
floor mini-space that is rotated into the viewer frame.

Large-monster palette selection uses the actor's current grade byte and each
renderer subtracts its own base grade before indexing its palette rows. A
Summon's illusion palette is selected by the negative flag in that grade byte,
not merely because it uses form `$65`.

When Objects is enabled, the same preview reads every visible object stack and
uses the original five `ObjectsOnFloor` projections, rotated mini-space table,
and X/Y placement tables. Shelf stacks take the source routine's separate
placement path, rather than being treated as floor-centre objects. A shelf has
two levels: its absolute map facing selects the valid encoded pair (North 0/4,
East 4/12, South 8/12, West 8/0) and their lower/upper meanings. The Object
tab consolidates stack selection, named item graphics, quantity and semantic
position editing, including adjacent-item swaps through `SEQUENCE`. Map clicks
cycle multiple stacks at one location unless `AUTO SELECT` is disabled, which
leaves the current stack selected while a new cursor position is chosen.
`FIND STACK` moves the cursor, including its floor, to the selected stack, while
`PLACE HERE` relocates it to the cursor and converts its mini-position to a
valid floor corner or shelf level. Counted object previews draw their quantity
over the source icon at the original above/below placement, capped visually at
99 without changing a larger stored byte. Named-key dots slowly cycle the
distinct extracted key colours when a location contains several named keys. In the
current map cell, the source tables expose the two forward/reachable object spaces;
the two nearer spaces in the cell ahead remain available through its normal
object projection. Floor objects are drawn at the source's pre-feature call
site. Shelf objects are placed immediately after their selected shelf face,
then before later, nearer map cells draw. The shelf items remain visible, but
an intervening wall face or nearer character or monster can naturally obscure
them; side-on or occluded shelves do not leave their items embedded in a wall.

The Characters / Monsters tab reuses the Data Viewer's champion scroll,
spellbook, inventory, object definitions and actor renderers. Game projects
edit champions only on mod0; save projects edit them only while the viewed
tower matches the save's active tower. The active save tower exposes its live
16-byte monster workspace read-only, while other towers use editable packed
six-byte records. Clicking a monster marker cycles all resolved team members
at that cell and replaces the selected marker's red fill with the normal
flashing editor highlight. Humanoid design editing changes the shared extracted
head, body and colour tables used by both viewers. The editor shows the full
champion or monster figure beside the reused Data Viewer panel. Full figures
retain whole source pixels, include their feet, and apply the same worn body
armour override as the Data Viewer. `FIND` moves the cursor and floor to the
selected actor's resolved location, while `PLACE HERE` is shared terminology
for actor and object placement. Monster map clicks can be switched between
`SELECT` and `JOIN`: join mode preserves the edited monster and joins it to the
party at the clicked location only when both packed `KL` IDs and the reconstructed
25-by-4 party table have room. Forms `$67` and above cannot join parties.
When a selected monster belongs to a party, the preview shows the other members
in authored `KL` slot order at half opacity; the selected member retains the
flashing highlight, and clicking a translucent member selects it. Joining
rewrites the packed record order so all members of the resulting party are
adjacent in `KL` slot order as well as represented in the reconstructed team
table. The design preview temporarily hides the other party members, can be
viewed as a compact strip of five representative grid depths, and no longer
needs a distance selector. The strip uses source graphics slots 0, 1, 2, 4 and
5: slot 3 is the rear mini-position at the same grid range as slot 2, while
slots 4 and 5 retain both small source-distant composites. The editor also
exposes all four inks in the selected palette together.
The shared palette order is Head, Legs, Torso, Arms and Distant, matching the
extracted `characters.colours` records. Save projects also
expose each champion's 32 spell-practice bytes alongside the learned-spell
flags. Large-monster design mode edits the packed record's available colour
grade; its minimum grade constants remain source/EQU work and are not guessed
or rewritten by the UI. Monster levels above an extracted renderer's final
colour grade use that final grade in both the Data Viewer and dungeon preview,
rather than making the graphical preview unavailable.

Large-monster design previews share one integer pixel scale across all five
distances. Widths follow the source sprites, with wrapping onto a second row
when needed; distant sprites are never independently enlarged to fill a slot.
The preview area extends downwards only in large-monster design mode.

`MINI-PALETTE` selects the predefined four-ink palette for the displayed
family/grade. Its four `SHARED INK` controls edit that palette in
`monsters/monsters.palette`, affecting **every monster using it**, even across
families. Changing the selector affects every instance of that family/grade;
large and small dragons share `dragon.colours`. Both edits are shared game
resources, unavailable in save mode, and are included in the design section's
session export/reset. Unsaved changes refresh the design and dungeon previews.
Illusions use their separate fixed palette and Entropy bypasses grade selection.

In SPS 439, original routine `adrCd009E94` subtracts the renderer's grade base,
clamps to 0–7, reads one byte from the family's colour lookup, multiplies it
by four and selects four ink indices from `adrEA009E60` (`monsters.palette`).
The extracted bank contains 13 mini-palettes. The controls derive counts from
the extracted resources, but adding palettes or 16-grade tables to an original
game still requires a compatible layout/source rebuild, including changing that
source clamp; the editor does not expand or relocate these resources.

Editable `-` / `+` controls repeat after a short press-and-hold delay, then
advance at a deliberately limited rate. Champion stats, pockets and spellbook
panels use a uniform whole-number scale so their source pixels are not warped.
Selecting a counted pocket object whose shared count is zero initializes it to
one, ensuring coin and arrow graphics become visible. Inventory quantities over
99 are displayed as 99 without changing their shared byte. Worn body armour
uses the original component-mask routing: the torso and body parts receive the
material recolour while the head keeps its normal character palette. A normal
click still changes exactly
one step.

The map cursor may be placed in a type-1 main wall even though normal game
movement cannot do so. In that invalid preview state the current cell is sealed
as opaque stone: it does not render an inner shelf, sign, switch, or socket,
and object sprites are suppressed behind it.

This separation is important: a map cell stores a switch or trigger reference,
not the complete action. The target data is shared by every use of that
reference and, for switches, can intentionally be reused across floors.

Switches and triggers use the AMOS editor's transparent two-digit reference
numbers rather than invented letter icons. Trigger reference 0 is the
null/no-event record and is deliberately not numbered. For non-zero triggers
whose action uses X/Y coordinates, the overlay boxes the affected location;
it does not draw a modern connecting line or add a second trigger icon there.

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

## Build boundary

The current editors intentionally write fixed-size resources suitable for the
existing extraction, inspection and binary-patch route. An object payload over
`$400` bytes or map cell data over `$FC8` bytes is a relocation/source-format
change, not a larger fixed-size edit. Supporting either requires coordinated
source EQU/table changes, revised resource layouts and a full compile; a
modified resource must never be patched into the original fixed SPS 439 block.
