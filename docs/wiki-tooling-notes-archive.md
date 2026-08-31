# Historical tooling passages moved out of the Wiki

These passages were preserved during the 31 August 2026 editorial review.
They describe application ideas, extraction/workbook workflows, or historical
implementation changes, rather than the original game's mechanics.

**Archive only:** this is not a current user guide, an approved implementation
plan, or a spreadsheet handoff. In particular, the old instruction to keep
EQUATES in `segments.xlsx` is obsolete: current project instructions place
maintenance metadata in `cleanup.xlsx`. Follow `AGENTS.md` and current
application documentation, not these historical excerpts.

Source: Wiki commit `0f579d7`, before the editorial repair.
Some complete sections are retained for context even where their source-format
explanations remain on the Wiki.

## 1. Monster-Graphics-Renderer.md

The Super App can treat this as a copy-on-write alias.

The Super App can treat this as a copy-on-write alias. An unchanged project continues to use the Behemoth data. If the user supplies different Crab claws, a source/relocation build can materialise `Crab_FrontClaws.gfx`, generate normalised offsets, and redirect the Crab renderer's graphic and offset-table references.

## 2. Monster-Graphics-Renderer.md

The X/Y and component-layout values are useful advanced editing controls.

The X/Y and component-layout values are useful advanced editing controls. The picture offsets should normally be regenerated from imported artwork.

## 3. Monster-Graphics-Renderer.md

## What should be editable?

## What should be editable?

* Keep the shared `gfx-data/` view, facing, distance, and animation mappings fixed in the normal editor. They should still be extracted and displayed for diagnosis.
* Expose monster-specific `.positions` and parsed `.layout` fields as advanced controls with an immediate viewport preview.
* Recalculate `.offsets`, `.heights`, and other dimensions when importing templates, then validate them against the original structure.
* Allow `.colours` grade selections and palette data to be edited with strict palette-index validation.

## 4. Character-Definitions.md

The internal source label at the second word is represented as:

The internal source label at the second word is represented as:

```text
_Offset_Character_RenderTableOffsets_0x02
```

The relabeller can then rewrite references to `Character_RenderTableOffsets+$02`, while the source build inserts the whole 20-byte lookup only once at `Character_RenderTableOffsets`.

## 5. Character-Definitions.md

## Source labels and spreadsheet treatment

## Source labels and spreadsheet treatment

The relevant code entry point is `Draw_CharacterComponent` at the former label `adrCd00A998`. It is a function label, not data, so its spreadsheet row needs a relabel and source comment but no extracted filename or data action.

The extracted tables should use normal data rows, producing one `INCBIN` for each non-overlapping source block. The symbolic `+2` label inside `Character_RenderTableOffsets` is the exception: it has no file and no data action because it names an address within the preceding resource.

## Modification implications

* Character colours, head selection, and body selection are naturally editable per character.
* Layout positions are shared by every body using the same standard or alternate family. They are useful advanced controls but a change affects several character types.
* A new body can reuse an existing layout while selecting different legs, torso, arms, and distant graphic bases.
* New or resized pictures require regenerated source offsets and heights, plus enough relocated space for the graphic data and any expanded definition tables.
* The 14 body records and two layout families should remain explicit project data rather than hard-coded knowledge in a graphics editor.

## 6. Dungeon-Graphics-Components-and-Planar-Compositor.md

## Editing implications

## Editing implications

For a normal graphics edit, keep the resource family together:

```text
picture pixels       .gfx
picture selection    .offsets
screen rectangle     .positions / .heights / .widths
colour substitution  .colours
renderer behaviour   .lookup / .flags / .layout
```

Changing a `.gfx` picture without checking its offsets can select the wrong picture. Changing a position without checking its width and height can corrupt the neighbouring destination rows. Changing a colour record changes bitplane substitution, not the master RGB palette. Changing a transform flag can alter mirroring, edge passes, or perspective trimming for an entire face family.

The shared renderer tables are valuable extracted diagnostic resources, but they should normally be treated as expert data. Feature artwork and its direct companion tables are safer editor targets. Packed monster `.layout` regions require additional care because several original tables can be contiguous or share bytes; they should not be split merely to create convenient labels.

## 7. Dungeon-Graphics-Renderer.md

Historical extraction-size corrections

Two historical extraction lengths omitted final inside-view source pixels:

| Resource | SPS 439 start | Correct size | Previous size |
|---|---:|---:|---:|
| `Door_Open.gfx` | `$02D2DC` | `$1B68` (7016) | `$1B60` (7008) |
| `Ceiling_Hole.gfx` | `$031BE4` | `$01B8` (440) | `$0190` (400) |

## 8. Dungeon-Graphics-Renderer.md

## Proposed SPS 439 shared-table extracts

## Proposed SPS 439 shared-table extracts

These shared rules belong under `gfx-data/`. Whether they are editable is independent of whether they replace source data: tables with an exact source label should use the normal blank `data_action`, allowing Inspect / Data to replace their `dc.*` blocks with `INCBIN` resources.

The coordinate and two mask tables are one contiguous source region. They should use `data_start` followed by two `data_append` rows, all anchored at the existing `adrEA00B8AE` label. This produces three named external files without requiring new source labels at `$00B946` and `$00B992`.

## 9. Dungeon-Graphics-Renderer.md

Previous extraction-planning table

| Memory address | SPS 439 file position | Size | Proposed label | Extracted file | `data_action` |
|---:|---:|---:|---|---|---|
| `$0094D4` | `$09150` | `$08` | `GFX_Firepath_ColourMasks` | `gfx-data/Firepath.colours` | blank |
| `$0095C0` | `$0923C` | `$14` | `GFX_CentredDungeonComponent_SpriteMirrorTable` | `gfx-data/Dungeon_CentredComponents.lookup` | blank |
| `$00B2BA` | `$0AF36` | `$1C` | `GFX_Main_Wall_SpriteTable` | `gfx-data/Dungeon_MainWall_SpriteSelection.lookup` | blank |
| `$00B43C` | `$0B0B8` | `$1C` | `GFX_WallComponent_SpriteMirrorTable` | `gfx-data/Dungeon_WallComponents.lookup` | blank |
| `$00B4C4` | `$0B140` | `$1C` | `GFX_WallComponent_DrawTransformFlags` | `gfx-data/Dungeon_WallComponent_DrawTransform.flags` | blank |
| `$00B558` | `$0B1D4` | `$08` | `GFX_WallComponent_PerspectiveTrimLookup` | `gfx-data/Dungeon_WallComponent_PerspectiveTrim.lookup` | blank |
| `$00B64A` | `$0B2C6` | `$1C` | `GFX_Main_Wall_DrawTransformFlags` | `gfx-data/Dungeon_MainWall_DrawTransform.flags` | blank |
| `$00B6F2` | `$0B36E` | `$08` | `GFX_Main_Wall_PerspectiveTrimLookup` | `gfx-data/Dungeon_MainWall_PerspectiveTrim.lookup` | blank |
| `$00B8AE` | `$0B52A` | `$98` | `Dungeon_ViewCell_RelativeCoordinates` | `gfx-data/Dungeon_ViewCell_RelativeCoordinates.positions` | `data_start` |
| `$00B946` | `$0B5C2` | `$4C` | `Dungeon_ViewCell_OcclusionMasks` | `gfx-data/Dungeon_ViewCell_Occlusion.flags` | `data_append` |
| `$00B992` | `$0B60E` | `$4C` | `Dungeon_ViewCell_VisibleFaceMasks` | `gfx-data/Dungeon_ViewCell_VisibleFaces.flags` | `data_append` |
| `$00B9DE` | `$0B65A` | `$14` | `Dungeon_ViewCell_CentredSlots` | `gfx-data/Dungeon_ViewCell_CentredSlots.lookup` | blank |
| `$00B9F2` | `$0B66E` | `$4C` | `Dungeon_ViewCell_WallFaceSlots` | `gfx-data/Dungeon_ViewCell_WallFaces.lookup` | blank |

## 10. Dungeon-Graphics-Renderer.md

The `data_append` rows repeat

The `data_append` rows repeat `adrEA00B8AE` in the spreadsheet `label` column. Their unique `relabel` values become the generated labels before their respective `INCBIN` statements.

Existing labels `$00B98E` and `$00B9DA` identify the final longword of the two mask blocks and are referenced by the reverse traversal. Before replacing the group, those labels should be converted to `Dungeon_ViewCell_OcclusionMasks+$48` and `Dungeon_ViewCell_VisibleFaceMasks+$48` using the spreadsheet's `_offset_..._0x48` convention. This preserves the code references without retaining labels inside either included file.

`Door_Lock_Colours` at memory `$00B2D6` / SPS 439 file position `$0AF52` is already extracted as `data/Door_Lock.colours`; it is adjacent renderer data but does not need a duplicate row.

## 11. Dungeon-Graphics-Renderer.md

The editor’s object preview removes

The editor’s object preview removes the ceiling portion of the normal
floor/ceiling window and shows all five source projections together. Its
preview origin includes the game’s floor-crop origin and a two-pixel display
correction so that the projected objects sit on the same floor lines as the
source view. This correction belongs to the preview composition; it does not
alter the extracted game tables or the binary data.

## 12. Extracted-Data-File-Types.md

Extraction workflow and app treatment (historical)

# Extracted data folders and file types

The files produced from `segments.xlsx` are byte-for-byte extracts from a supported game binary. Most do not contain a header, filename, dimensions, or other self-description. Their folder and faux-extension therefore describe how Bloodwych ReSource interprets the bytes.

The faux-extension is documentation rather than a new file format: renaming a file does not change its contents.

## Folders

| Folder | Purpose |
|---|---|
| `data/` | General game tables which are not graphical resources, maps, or sound. |
| `gfx/` | General graphics and their companion tables: walls, floor and ceiling artwork, interface pieces, doors, objects, avatars, and similar resources. |
| `gfx-data/` | Shared graphics-renderer and viewport tables used by several resource types. These are primarily extracted for decoding, validation, and documentation and are not normally presented as editable artwork. |
| `monsters/` | Graphics and companion data belonging to a particular large monster: graphic blocks, component layout, picture offsets, colour grades, and palettes. |
| `maps/` | Tower maps and their switches, triggers, objects, monsters, entrances, and related data. |

### Object and floor-rendering resources

The object viewer uses one four-byte record per object in
`data/objectdefinitions.block`. This is the complete `$00-$6D` table,
including the empty-pocket record at `$00`; it replaces the older partial
`objectpocketicons.block` extraction.

The floor-object renderer uses several small parallel tables. The projection
tables describe how a map view cell and one of its four mini-spaces become one
of the five visible distances. `ObjectsOnFloor_ViewY.positions`,
`ObjectsOnFloor_XPositions.positions`, and
`ObjectsOnFloor_YAdjustments.positions` provide the source screen anchors and
shape-specific adjustments. `ObjectsOnFloor_SubpositionRotation.lookup`,
`ObjectsOnFloor_SubpositionDepthBias.lookup`,
`ObjectsOnFloor_ViewCellDepthBase.lookup`, and
`ObjectsOnFloor_ProjectionGroups.lookup` provide the selection logic.

These tables are renderer data rather than a second object-definition list.
The graphic bytes remain in `gfx/ObjectsOnFloor.gfx`, with offsets and heights
in their companion resources. The viewer preserves all five distance views
and applies the source Y adjustments when composing its floor preview.
| `sfx/` | Sound data. |

`segments.xlsx` uses the `Type` value as the folder name and `DATA BLOCK FILE` as the filename. The resulting `name` is normally `Type/DATA BLOCK FILE`.

## Graphics-related faux-extensions

| Extension | Meaning | Normal treatment in the Super App |
|---|---|---|
| `.gfx` | Raw Atari ST four-plane graphical data as stored by the game. It contains no dimensions or picture directory of its own. | Editable through graphical export/import tools. |
| `.offsets` | Big-endian word offsets locating individual pictures inside an associated `.gfx` block. This is the table that divides or selects pictures in sequential graphic data. | Generated and validated when graphics are imported; not normally hand-edited. |
| `.positions` | Signed screen X positions, Y positions, or packed X/Y pairs used when drawing a picture or component. | Advanced editable layout data with a live preview. |
| `.heights` | Stored picture heights used by the strip renderer. In several routines zero represents one drawn line because the value is used as a loop count. | Normally generated or validated against imported artwork. |
| `.layout` | A packed, resource-specific mixture of component dimensions, positions, graphic bases, spacing, or mirroring rules which cannot be separated cleanly without changing the original layout. This replaces the ambiguous `.renderdata` name. | Parsed into named fields and exposed through an advanced component-layout editor. |
| `.lookup` | A value-remapping table, such as view distance to graphic size or facing direction to a graphic variant. Unlike `.offsets`, its values are not necessarily byte positions in a `.gfx` file. | Usually fixed when shared by the renderer; monster-specific lookups may be regenerated with artwork. |
| `.flags` | Bit or word values which enable rendering behaviour such as animation or mirroring. | Normally fixed or expert-only. |
| `.colours` | A monster's ordered selections from the master monster palette, used for colour grades. | Editable with palette-index validation. |
| `.palette` | Palette entries or groups of palette indices. | Editable with format and range validation. |

## Other common faux-extensions

| Extension | Meaning |
|---|---|
| `.font` | Raw game-font data. |
| `.sound` | Extracted sound sample data. |
| `.block` | A fixed-size binary structure which has not yet been given a narrower file type. |
| `.locations` | Encoded map or game locations. |
| `.map` | One tower's packed map data. |
| `.switches`, `.triggers`, `.obj`, `.monsters` | The corresponding fixed-capacity tower data block. |

## Editability is not encoded in the filename

All extracted files are ordinary binary files and can technically be changed. The Super App decides which files receive an editor and which are treated as read-only engine data. Shared renderer tables are kept in `gfx-data/`; monster-specific companion data is kept beside its `.gfx` file in `monsters/`.

The spreadsheet's `extract_only` action has a different meaning: it allows a useful sub-block to be extracted without replacing that exact source span with an `INCBIN`. It does not by itself mean that the data is editable or read-only.

## Contiguous source layouts

Some adjacent source tables form one logical replacement even though they are extracted into several named files. The first spreadsheet row uses `data_start`; immediately following components use `data_append`. Their offsets and sizes must be exactly contiguous.

Column A on a `data_append` row may either repeat the `data_start` anchor (the original convention) or contain the real internal source label where that component begins. Using the internal label is preferable when it exists: the same row then both relabels the original source and emits the component in the generated data source. A separate duplicate relabel row is not required.

### Labels before and after INCBIN generation

When a `data_append` row repeats the group anchor, its new component label does
not exist in the original disassembly. This matters when code has already been
rewritten to reference that component by name: the relabelled source must still
compile before Inspect replaces the data with several labelled `INCBIN`
resources.

ReSource therefore derives a temporary `EQU` from the component offsets. For
example, the dungeon view tables use:

```asm
Dungeon_ViewCell_OcclusionMasks:
        equ Dungeon_ViewCell_RelativeCoordinates+$98

Dungeon_ViewCell_VisibleFaceMasks:
        equ Dungeon_ViewCell_RelativeCoordinates+$E4
```

These aliases produce the same addresses as the unsplit source block. When the
whole grouped replacement validates, Inspect removes the temporary aliases and
the generated `INCBIN` layout defines real labels at those boundaries. If
validation fails, the aliases remain with the original data so the retained
source still compiles.

The alias values are calculated from the existing `offset` fields; they are not
additional spreadsheet data and must not be entered as `_delete` rows.

## Odd-length resources and Devpac

Devpac forces every `INCBIN` to an even boundary and appends a zero byte when the included file has an odd length. This changes the executable if an odd-sized source table is replaced directly by `INCBIN`.

The ReSource inspector therefore emits:

* even-sized external resources as `INCBIN`;
* odd-sized external resources as generated `dc.b` lines containing the exact file bytes.

The extracted file remains authoritative in both cases. Rerunning Inspect / Data regenerates the assembly after the file is edited. This was confirmed with `Monster_SubPosition_DepthAdjustments.positions` (five bytes) and `Monster_ViewCell_DepthSlots.lookup` (19 bytes): using two direct `INCBIN` statements inserted two unwanted zero bytes, whereas generated `dc.b` data produced a byte-identical SPS 439 executable.

See also:

* [Atari ST Raw Data Format](https://github.com/HoraceAndTheSpider/Bloodwych-68k/wiki/Atari-ST-Raw-Data-Format)
* [Dungeon Graphics Renderer](https://github.com/HoraceAndTheSpider/Bloodwych-68k/wiki/Dungeon-Graphics-Renderer)
* [Dungeon Graphics Components and Planar Compositor](https://github.com/HoraceAndTheSpider/Bloodwych-68k/wiki/Dungeon-Graphics-Components-and-Planar-Compositor)
* [Monster Graphics Renderer](https://github.com/HoraceAndTheSpider/Bloodwych-68k/wiki/Monster-Graphics-Renderer)
* [Character Definitions and Graphics Renderer](https://github.com/HoraceAndTheSpider/Bloodwych-68k/wiki/Character-Definitions)
* [Source Equates and Scoped Replacements](https://github.com/HoraceAndTheSpider/Bloodwych-68k/wiki/Source-Equates-and-Scoped-Replacements)

## 13. Source-Equates-and-Scoped-Replacements.md

Historical worksheet and generation instructions

A constant must therefore never be replaced globally merely because its value
matches. A confirmed replacement records:

* the executable profile;
* the EQU name and value;
* the labels bounding the relevant routine or source region;
* the complete original instruction;
* its encoded opcode bytes;
* the replacement instruction; and
* whether the finding is verified, proposed or disabled.

The bounding labels remain stable when source line numbers change. The opcode
acts as a byte-level fingerprint. Relabel stops if the labels are missing, the
instruction is not found exactly once, or the opcode differs.

## `EQUATES` worksheet

These findings are recorded on the optional `EQUATES` worksheet in
`segments.xlsx`:

| Column | Purpose |
|---|---|
| `profile` | Executable profile to which the finding applies. |
| `equ_name` | Human-readable source constant. |
| `equ_value` | Original numeric value. |
| `scope_start`, `scope_end` | Labels bounding the confirmed use. |
| `source_match` | Complete instruction in the original disassembly. |
| `expected_opcode` | Original encoded instruction bytes. |
| `source_replace` | Complete instruction using the EQU. |
| `status` | `verified`, `proposed` or `disabled`. |
| `source_comment` | Concise explanation suitable for generated source. |
| `notes` | Optional research notes. |

Rows marked `proposed` document a possible meaning but do not change generated
source. The same EQU name and value may be repeated when several independent
uses have been confirmed in different routines.

An EQU with no identified instruction may leave the scope and instruction
fields blank. It remains documented without causing a source rewrite.

## Relationship to extracted data

Correcting false references is important before replacing data with `INCBIN`.
Inspector deliberately retains a source data block if an internal label still
appears to be referenced by code that will remain. Once a false operand has
been converted to its genuine constant, that safety check can distinguish real
references from disassembly artefacts and remove the complete validated block.

This is separate from the temporary aliases used for `data_start` /
`data_append` layouts. Those aliases represent genuine addresses inside a
contiguous data block and exist only until the split `INCBIN` labels are
generated.

## 14. Airbourne-Spells.md

Stationary-table extraction workflow

These 30 bytes are one contiguous source region. In `segments.xlsx`, the distance mapping is `data_start`; the offset and layout rows are `data_append`. The append rows use their real internal labels (`adrW_009360` and `adrB_009368`), so no duplicate relabel rows are needed.
