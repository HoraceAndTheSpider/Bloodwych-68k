# Dungeon graphics renderer

The Data Viewer's dungeon tab renders SPS 439 graphics into the same native
128×76 floor/ceiling viewport used by characters and monsters.  Extracted
`.gfx`, `.offsets`, `.positions`, and `.colours` resources remain authoritative;
the Python layer currently names the compact source tables which are not yet
separate extracted files.

The viewer presents the actual map-space types 0–7 first.  Selecting a type
then exposes only its valid alternatives: for example type 3 offers pillar or
bed, while type 1 offers the plain stone block and its shelf, sign, switch, and
socket treatments.  These alternatives are editor interpretations of the
bits and associated data belonging to that map type; they are not additional
map types.

The source-view grid can also hold a small temporary scene.  Each occupied
cell retains its own map option, facing, variant, wooden N/E/S/W states, and
preview adjustment.  Cells are rendered in the game's view-cell traversal
order.  Type-1 stone locations contribute their occlusion masks to one shared
wall-face mask, so a nearer stone wall hides faces belonging to farther cells.
The directional line-of-sight rule for type-2 wooden walls is not yet included
in scene occlusion; their independently selected sides are still drawn in the
correct source order.

## Source structure

Bloodwych does not calculate wall perspective from a formula.  The renderer
uses nineteen player-relative view cells and twenty-eight possible wall-face
slots.  Two 32-bit masks per view cell select candidate faces and remove faces
occluded by an opaque map location.  A four-byte record per view cell then
maps its N/E/S/W faces to those slots.

The four face entries are processed in source-table order, not numeric sprite
slot order.  For the player cell this draws the retained rear face before the
side faces.  A stone-wall location always evaluates all four candidate sides
and the visibility masks suppress only the sides which cannot be seen.  Wooden
walls differ: their four two-bit values can independently omit a side or select
a solid wall, open doorway, or closed door.

The viewer exposes those two choices separately: each side has a wall on/off
control and a door control which adds a closed door and then toggles it
open/closed. This is only a clearer UI over the same two-bit value; it does not
change the stored map format.

Wall-position entries are packed as `x / 2`, `y`, `width words - 1`, and
`height - 1`.  Source picture selection is independent of screen placement:

* `GFX_Main_Wall_SpriteTable` maps the 28 slots to the stone-wall pictures.
* the table currently labelled `GFX_Wall_Signs_SpriteTable_TBC` maps slots to
  wall components, wooden walls, wooden doors, stairs, signs, shelves,
  switches, and sockets; bit 7 requests horizontal mirroring;
* `GFX_Misc_Pillar_SpriteTable` selects centred pillar, pit, and pad pictures;
  its high bit has the same mirroring meaning.

The main-wall draw path always passes each source row through the game's bit
reversal lookup before writing it from right to left.  Consequently the raw
ST-format wall pictures require a horizontal mirror at render time even though
`GFX_Main_Wall_SpriteTable` contains plain source indexes rather than mirror
flags.  Omitting this step reverses the masonry perspective on both near side
walls.

For the four nearest central wall slots, source pictures 12–15 contain one
half of the final picture.  The renderer draws the source half and a mirrored
copy at `128 - x - width`.  This is why treating a `.positions` record as one
complete picture produces a visibly half-finished stair, door, or wall
decoration.

## Wooden walls and doors

The first map byte contains four two-bit N/E/S/W values:

| Value | Meaning |
|---|---|
| 0 | no wall or door |
| 1 | wooden wall |
| 2 | open wooden door |
| 3 | closed wooden door |

`Wooden_Wall.gfx` contains two equal `$2498`-byte sets.  The first is the
solid wall; the second is the open-door frame.  A closed door draws that second
set and then overlays the selected `Wooden_Doors.gfx` picture.

## Wall overlays and large doors

Shelves, signs, switches, and sockets are drawn on one selected N/E/S/W stone
wall face. A switch's used/dim state transforms its ordinary four-colour mask
from `[a,b,c,d]` to `[0,d,0,c]`. An empty socket keeps the socket artwork but
clears the fourth replacement colour, removing the inserted gem. The socket
colour sets identify the four tower crystals (Serpent green, Chaos yellow,
Dragon red, and Moon blue) plus the remaining teleport/unused gem schemes.

Sign references 1–4 select the Serpent, Dragon, Moon, and Chaos emblem sheets.
A reference of 5 or more identifies wall-scroll handling instead of an emblem
overlay; its colour is derived from location data.

Large metal doors and portcullises use the same perspective position table.
The open state draws `Door_Open.gfx`; the closed state draws the selected door
sheet. Its lock colour is selected from the eight-byte table at `$00B2D6`.

## Pits, pads, and ceiling holes

Map type 6 contains independent floor and ceiling information. The ceiling bit
is processed first, so a ceiling hole can coexist with either a floor pit or a
trigger pad.

The extracted filenames are historically easy to misread:

* `Pad_Trigger.gfx` is the **ceiling-hole** artwork;
* `Pad_Pit_High.gfx` is the recolourable **trigger-pad** template;
* `Pad_Pit_Low.gfx` is the **floor-pit** artwork.

The ordinary trigger pad uses the immediate replacement mask `[1,5,4,6]` set
by the type-6 preparation routine at `$0094DC`.

## Proposed extracted renderer tables

These are shared renderer rules under `gfx-data/`. Tables with an exact source
label should use the ordinary blank `data_action`, allowing Inspect / Data to
replace their `dc.*` data with `INCBIN`. Existing graphics, offset, position,
and colour resources listed in `segments.xlsx` do not need duplicating.

| Source address | Proposed label | File | SPS 439 file position | Size |
|---|---|---|---:|---:|
| `$0095C0` | `GFX_CentredDungeonComponent_SpriteMirrorTable` | `Dungeon_CentredComponents.lookup` | `$923C` | `$14` |
| `$00B2BA` | `GFX_Main_Wall_SpriteTable` | `Dungeon_MainWall_SpriteSelection.lookup` | `$AF36` | `$1C` |
| `$00B2D6` | `Door_Lock_Colours` | `Door_Lock.colours` | `$AF52` | `$08` |
| `$00B43C` | `GFX_WallComponent_SpriteMirrorTable` | `Dungeon_WallComponents.lookup` | `$B0B8` | `$1C` |
| `$00B4C4` | `GFX_WallComponent_DrawTransformFlags` | `Dungeon_WallComponent_DrawTransform.flags` | `$B140` | `$1C` |
| `$00B558` | `GFX_WallComponent_PerspectiveTrimLookup` | `Dungeon_WallComponent_PerspectiveTrim.lookup` | `$B1D4` | `$08` |
| `$00B64A` | `GFX_Main_Wall_DrawTransformFlags` | `Dungeon_MainWall_DrawTransform.flags` | `$B2C6` | `$1C` |
| `$00B6F2` | `GFX_Main_Wall_PerspectiveTrimLookup` | `Dungeon_MainWall_PerspectiveTrim.lookup` | `$B36E` | `$08` |
| `$00B8AE` | `Dungeon_ViewCell_RelativeCoordinates` | `Dungeon_ViewCell_RelativeCoordinates.positions` | `$B52A` | `$98` |
| `$00B946` | `Dungeon_ViewCell_OcclusionMasks` | `Dungeon_ViewCell_Occlusion.flags` | `$B5C2` | `$4C` |
| `$00B992` | `Dungeon_ViewCell_VisibleFaceMasks` | `Dungeon_ViewCell_VisibleFaces.flags` | `$B60E` | `$4C` |
| `$00B9DE` | `Dungeon_ViewCell_CentredSlots` | `Dungeon_ViewCell_CentredSlots.lookup` | `$B65A` | `$14` |
| `$00B9F2` | `Dungeon_ViewCell_WallFaceSlots` | `Dungeon_ViewCell_WallFaces.lookup` | `$B66E` | `$4C` |

The blocks at `$00B8AE`, `$00B946`, and `$00B992` are contiguous and should be
one `data_start`/`data_append` group anchored at `adrEA00B8AE`. Existing labels
at `$00B98E` and `$00B9DA` point to the last longword of the mask blocks; their
references should become the generated mask label plus `$48` before the group
is replaced.

The two draw-transform tables contain one byte for each of the 28 wall-face
slots.  Their flag bits select the ordinary bit-reversed row writer or the
perspective edge/cropping path, including its before/after adjustments.  The
main-wall and wall-component tables differ at slots 6 and 18 and should remain
separate resources.

## Magic locations

Map type 7 describes Firepath, Mindrock, and Formwall logic. These are not
three independent graphic sheets:

* Firepath reuses the trigger-pad template and flashes between the two
  four-colour masks stored at `$0094D4`: `[9,12,11,13]` and
  `[9,10,11,13]`.
* Mindrock follows the stone-wall render path when it is visible. Its flashing
  behaviour is logical rather than a separate extracted wall graphic.
* Formwall is rendered as a solid stone wall.

For editor clarity, the Data Viewer applies direct palette-index substitutions
to the ordinary stone wall. Formwall changes only the two middle greys (indices
2 and 3) to the game's dark and bright greens (5 and 6). Mindrock changes the
darkest grey (1) to dark blue (7) and white (14) to light blue (8). All other
wall shades remain unchanged. These are explicit preview customisations, not
the game's four-colour mask routine or palette tables read from SPS 439.
Firepath, by contrast, uses the original two source masks exactly.

The Firepath masks are a genuine eight-byte source table and are suitable for
ordinary extraction/`INCBIN` replacement:

| Source address | Proposed label | File | SPS 439 file position | Size |
|---|---|---|---:|---:|
| `$0094D4` | `GFX_Firepath_ColourMasks` | `Firepath.colours` | `$9150` | `$08` |

The trigger-pad mask at `$0094DC` is an immediate value loaded by code, not a
standalone data block. Relabel `adrCd0094DC` as
`Set_TriggerPad_ColourMask`; the immediate `$01050406` can later become the
named constant `TriggerPad_ColourMask EQU $01050406`.

The two values in `GFX_Firepath_ColourMasks` may likewise be expressed as
`Firepath_ColourMask_Frame1 EQU $090C0B0D` and
`Firepath_ColourMask_Frame2 EQU $090A0B0D`. The eight table bytes must still
exist because the game selects them with an indexed memory read. Therefore the
EQUs can document values used by a `dc.l` source representation, while an
`INCBIN "gfx-data/Firepath.colours"` remains the compact data-driven option.
