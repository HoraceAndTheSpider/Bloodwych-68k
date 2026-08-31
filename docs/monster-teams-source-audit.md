# Monster teams: source verification and Wiki reconciliation

This follow-up resolves the pending Monster Data Structure draft from the Wiki
editorial review. The existing packed/live pages are retained; no duplicate
monster-layout page is introduced.

Published as Wiki commit `02b3350`. The sibling local Wiki checkout was
fast-forwarded to the same revision. Its superseded draft is recoverable in
Git stash `ec0f6176518c742123a4310980b57706fe900741`, named
`Monster wiki draft preserved before verified team reconciliation 02b3350`.
The cleanup metadata and this audit remain uncommitted in the main repository.

## Findings

The packed `KL` byte is a byte offset into a separate, four-slots-per-team
runtime table. It is not copied unchanged to live record byte $0D. The positioned
leader receives the group number there; followers remain $FF and are found
through the table.

Verified against the original SPS 439 source:

- `adrCd0009F6` initialises the team count to $FFFF. `adrLp000A08`
  fills 25 longwords, establishing 100 slot bytes.
- `adrCd000AEC` writes the live ordinal to table[KL] before testing X bit 7.
  Only a positioned member increments the group-count word and receives KL >> 2.
- `adrW_01738E` is therefore a terminal index (team count minus one),
  not a member count. The existing label `MonsterTeamGroupCount` is retained.
- `adrCd009A2A` / `adrLp009A46` resolve team members from a positioned
  occupant and use the shared visible map-cell context. They do not position
  a follower from its stored Y byte.
- `adrCd002848` / `adrCd00287C` update table indices after removing
  a live record. `adrCd0028BC` transfers a removed leader's position,
  floor, facing and group to another member.
- `adrCd001090` compacts team rows and dissolves one-member groups.
- `adrCd007974` / `adrLp0079B4` / `adrLp0079EA` rebuild packed KL
  values from the runtime rows.

The packed tower addresses previously shown without a qualifier are file
offsets: MonsterTotalsCounts is file $171F4, runtime $17578; TheMonsterBlock
is file $17200, runtime $17584.

The existing live-page HP explanation incorrectly described a type-dependent
multiplier. The unpacking code at `adrCd000AA8`–`adrCd000AC6` selects
the multiplier from the level, then stores the HP word at live +$08.

## Original-data checks

All six towers were checked directly against binaries/BLOODWYCH439: 461 packed
records, containing 96 team groups. Each original group has exactly one
positioned leader, unique member slots, and a contiguous group-number range
starting at zero within its tower.

Original record totals are 73, 78, 84, 68, 80 and 78. Original team totals
are 4, 14, 19, 15, 20 and 24.

The Keep table reconstructs as:

```text
0B 0C FF FF
12 13 FF FF
3A 3B FF FF
3D 3E 3F FF
```

Its team-count word is $0003; remaining slots are $FF.

The Serpent group $0B records are:

```text
14 09 02 04 38 2C
04 FF 0A 03 34 2D
04 FF 12 04 32 2E
```

These demonstrate why the draft's requirement to copy the leader's Y was
removed. The three Y bytes differ; membership and shared drawing location
come from the team lookup. No original data was changed.

## Maintained metadata

Corrected 19 existing source-comment cells in cleanup.xlsx, reusing its
existing EQU names. No EQU values, opcode checks, scopes, instructions or
replacements changed. This is nine EQUATES comments (K229:K233 and
K287:K290) and ten COMMENTS cells (E297, E309, E311, E313:E314, E334,
E375:E377, E379).

The spreadsheet exporter changed unrelated cell formatting on a trial output.
That output was not installed. Only its 19 authored text values were
transplanted into the original XLSX container; all other values, formulas,
styles, workbook parts and existing modifications were verified unchanged.

No new source labels or extracted resources are needed for the Wiki explanation.
The runtime Teams table is derived workspace, not a second authoritative
editable monster-placement resource.

### Protected-sheet comment correction

segments.xlsx remains untouched. The following is a correction to the
source_comment of an **existing** mapping on BLOODWYCH439, row 2579—not a
new relabel or extraction proposal. The original symbol has been checked by
exact-text search in the original ASM. Blank fields are intentionally blank.

```tsv
label	relabel	Type	DATA BLOCK FILE	name	BW439 Position	offset	size	Length (Hexidecimal)	data_action	source_comment
adrW_01738E	MonsterTeamGroupCount									Last team-row index, stored as team count minus one; $FFFF means no teams.
```

## Verification boundary

This is source and original-data verification, plus Wiki/metadata checks.
No application code, original binary, clean extraction or generated ASM was
modified. No relabel, inspect, format or assembly build was run.
