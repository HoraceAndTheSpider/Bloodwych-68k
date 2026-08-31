# SPS 439 layout/map source verification

This handoff covers the Layout investigation: tower headers, floor geometry,
stairs, pits, adjacent floor-feature dispatch, and map/object allocation. It is
not an assertion that every remaining `adr` or `AI` label in the entire game
has been resolved, or that an enlarged resource layout has been proven safe.

The protected `segments.xlsx`, original executable and original ASM were not
edited. No project ASM regeneration or 68000 assembly was performed.

## Protected-sheet handoff

[layout-map-segments.tsv](layout-map-segments.tsv) contains all 69 copy-ready
rows, with the exact eleven columns from A through K and explicit empty cells:

```text
label | relabel | Type | DATA BLOCK FILE | name | BW439 Position | offset | size | Length (Hexidecimal) | data_action | source_comment
```

Update existing rows by the original `label` key; do not append duplicates.
Some rows retain an existing relabel and correct only its comment, extraction
definition, or address fields. `MovementOffsetTable`, for example, is already
the relabel of `adrEA005794`, not an original source label to propose again.
`LevelDataOffsets` already maps to `Current_TowerMapOffsets`.

`BW439 Position` and `offset` in this handoff are original-executable **file
offsets**, not runtime addresses. Runtime addresses in the original source are
file offsets plus `$384`. This corrects in-scope movement rows that previously
put runtime addresses in those columns. Every proposed original label was
exact-text checked, and its source hex bytes were compared with the executable
at the stated offset. No symbol was invented from an address.

The machine-readable evidence is in
`outputs/layout-map-source-audit/verification.json`. The companion
`label-mapping-history.json` preserves the original → existing → proposed name
chain, including unchanged mappings and the 15 replaced `AI_TBC` names.

## Cleanup metadata

`cleanup.xlsx` now contains:

- 53 appended EQUATES rows (540–592): 22 new constant names and eight reused
  names across 52 scoped rules and one EQU-only definition. The rules cover
  54 original instruction/data sites, preserving mnemonics, operand values,
  explicit addressing sizes and expected opcodes.
- 66 appended COMMENTS rows (895–960), plus 24 corrected or re-anchored
  existing rows. All 90 affected rows were checked against the final
  instruction text after EQU substitution.
- The three obsolete `Player_MapIndexOffset` rules are retained as disabled.
  Player-record offset `$58` is a floor number; the verified `PlayerData_Floor`
  definition is reused.

Reused constants include `PlayerData_Floor`, `PlayerData_StartXPosition`,
`PlayerData_Direction`, `Dungeon_CellTypeMask`, `ChampionStat_WornSpell`,
`PartyShieldStatusBar_SuppressionMask`, `Sound_AlternativeSpell`, and
`PlayerData_PartyCommandStateOffset`.

The spreadsheet edit preserved unrelated cell values, styles, sheet order,
column widths, merged ranges and freeze panes. All five sheets received a
visual check; the candidate workbook also passed the source-metadata loader.
The formatter still preserves handwritten instruction comments, as required;
a matching COMMENTS row does not authorise replacing an existing handwritten
annotation.

## Verified findings

### Header and player floors

Original `adrCd000B68` copies fourteen longwords: the 56-byte map header,
not fourteen pointers. `adrCd0084D6` reads the particular player's floor at
record +`$58`, then `adrCd0084DA` selects its width, height and cell-data offset.
The main player loop calls that selector separately for each player.

Header +`$30` and +`$32` initially populate the working width and height.
Header +`$34` is the legacy floor offset copied by AMOS `_EDITKEYS5`; no
direct instruction reader of its cached bytes at `$EE74` was identified.
There is no original `adrW_00EE74` label, so none is proposed. The cached
header +`$36` word becomes the active floor-data offset during selection.
The header triplet is not an entrance or an assignment of both players to
one floor. Its bytes remain preserved.

Player 2's floor word is `$EEDE + $58 = $EF36`, not the old Wiki's `$EF3E`.

### Elevation transitions

`adrCd0084BA` converts local coordinates using old alignment minus new
alignment. `adrCd006EE8` then applies the travel vector twice for a stair
landing. `adrCd004CB2` falls one floor without a horizontal step for pits.

The stair landing tests occupancy, not reciprocal stair type/direction. The
pit landing does not require a ceiling-hole flag. Ordinary reciprocal-pair
warnings and link lines are authoring guidance; intentional tricks remain
possible. A stair landing also derives facing from the destination detail
byte even if it is not a stair.

### Adjacent floor-feature branches

The old `TeamAvatar_Loop*` names at `adrCd006F80`, `adrLp006F86` and
`adrCd006F9A` actually clear worn spells on spell-fizzle tiles. The old
`Trigger_WaitFlag_AI_TBC` at `adrEA006FA8` is a sound selector consumed by
`PlaySound`, not a wait flag. The trigger dispatcher uses 32 four-byte
records per tower, indexed by the cell's high five detail bits.

`adrCd006E90` and `adrCd006EA0` are type-6 floor-feature/trigger branches,
not stair/team-pad handlers. The post-move test at `adrCd006F4A` reads the
signed party-command state, not a map pad. The handoff corrects those names
and descriptions alongside the stair transition labels and object loops.

### Allocation and relocation

The two object-access operands at `adrCd000960` and `adrCd005F5C` encode:

```asm
Map_ResourceSize-Map_HeaderSize+ObjectData_LengthBytes ; $1000-$38+2 = $0FCA
```

The initial pointer at `adrL_00EE78` is now expressed by a scoped rule as:

```asm
dc.l MapData1+Map_HeaderSize ; original value $0000EF78
```

These changes remove verified magic operands while retaining the original
values. `LevelDataOffsets` must remain assembled map-label differences so
later towers follow layout changes; it is not an extraction candidate.

The stock map has `$FC8` cell bytes (2,020 cells) after its header. Object
files are `$402` bytes: a two-byte used-length word and `$400` of capacity.
Object stack locations mask with `$3FFF`, retaining a 14-bit **byte offset**.
Record size is `5 + 2 * count_minus_one`.

The object insertion paths at `adrCd005EAC` and `adrCd005F04` grow the used
length by two or five without an allocation-capacity comparison. No
longest-object-file EQU is consumed by these paths. A larger resource needs
a source rebuild, not an overlength binary patch. Signed word tower
displacements, word map offsets, 14-bit object locations, short absolute/PC
addressing, coordinate limits, save layout and working buffers still need
an enlarged-layout audit. A one-EQU change cannot certify those constraints.

## Data extraction candidates

Both complete declarations are in the eleven-column TSV, with `data_start`:

- `adrEA005794` → existing `MovementOffsetTable`: 16 bytes at file `$5410`,
  runtime `$5794`, ending at `adrJA0057A4`. Eight signed X deltas precede
  eight signed Y deltas. Resource: `data/Movement_Deltas.lookup`.
- `adrB_005F3E` → `ObjectDrop_MiniSpaceRotation`: 16 bytes at file `$5BBA`,
  runtime `$5F3E`, ending at `adrCd005F4E`. Four facing rows map relative
  drop corners to stored mini-spaces. Resource: `data/Object_DropMiniSpaces.lookup`.

Both blocks match the binary exactly, have no internal labels and do not
overlap existing extracted resources. Their output paths would be
`data/BLOODWYCH439-clean/data/Movement_Deltas.lookup` and
`data/BLOODWYCH439-clean/data/Object_DropMiniSpaces.lookup` on extraction;
edits belong under the corresponding `-modified` tree. Those files have not
been written into the immutable clean tree by this audit.

All twelve existing map/object extractions also match their original bytes.
Stair, pit and ceiling-hole artwork and the six trigger tables already have
extracted resources; no additional graphics block was found by this work.
The shared header, active geometry and trigger sound selector are runtime
state and must not become duplicate editable assets.

## Source-rule integration and checks

`tools/source_rules.py` previously resolved relabels only in the instruction
being matched, not in replacement operands. That could reintroduce an
undefined original `adr` name after these mappings were adopted. It now
resolves replacement operands through the same mapping. Two regression tests
cover both current/proposed map destinations and symbolic data expressions.

Focused source-rule, formatter and map-editor tests: 104 passed.
Full suite: 372 passed. Tests that exercise source generators use temporary
fixtures; the project ASM outputs were not regenerated.

An additional in-memory integration check applied all 52 new scoped rules
and checked all 66 new comment rows against both current and proposed label
mappings. Both passes succeeded without reintroducing retired labels.

The five relevant Wiki pages were committed and pushed separately as
`0f579d7` (Map Data Structure, Stairs, Pads/Triggers/Holes, Object Location
Data Structure, and Player Location Data). The existing uncommitted
`Monster-Data-Structure.md` in the sibling Wiki checkout was not included.

The raw-source diagnostic also encountered two unrelated pre-existing rules
that did not match its input: EQUATES row 88 (`CommsAction_Retort`) and row
500 (`GFX_Pockets_SelectedPartyShieldFrameOffset`). They were not changed or
counted as verified by this investigation. The changed/new rule checks pass;
this report does not certify the entire workbook's unrelated rules.

Before this audit the original-input SHA-256 values were:

```text
segments.xlsx: 6036a8619f0a87a71af62ac1fcdf443b6a0ace008c134e479e81b71067c8c184
binaries/BLOODWYCH439: ebc4b3116cb850b4fa81886e4c1c668cd8992f299b40f994c9a40c84009c8f15
asm/Bloodwych439.asm: 5d9f8c2177cf187a750421a9459bbdc730416a729c1c6deec7d480fde28505ba
```

## Remaining user-controlled build verification

Adopt the protected-sheet rows, extract the two approved lookup resources,
then regenerate through the normal source pipeline when ready. The original,
relabelled and relabel-data Devpac builds must still be compared byte-for-byte.
No claim of a new 100%-identical compiled binary or unrestricted relocation is
made without that check.

`AGENTS.md` was read and its protected-sheet schema, original-label checks,
clean-data immutability and user-controlled rebuild boundary were followed.
No change to those instructions was necessary.
