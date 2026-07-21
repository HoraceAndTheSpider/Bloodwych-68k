# Spreadsheet resource layouts

`segments.xlsx` can describe several extracted files that replace one
contiguous `dc.*` region in the generated ASM. Add one optional column named
exactly `data_action` to the existing version worksheet; its position does not
matter.

The supported values are:

| `data_action` | Meaning |
|---|---|
| blank | Existing one-row/one-file behaviour. |
| `data_start` | First file in a grouped source replacement. |
| `data_append` | Next file in that replacement. It must immediately follow the previous group row. |
| `extract_only` | Extract this overlapping view, but never use it for ASM replacement or binary patching. |

For a grouped replacement:

1. Repeat the same original ASM `label` on the `data_start` row and every
   immediately following `data_append` row.
2. Give every row a unique `relabel`. These become labels in the generated
   source.
3. Put the files in output order. Spreadsheet order is INCBIN order.
4. Provide `offset` and `size` on every row. The ranges must be exactly
   contiguous.
5. Ensure every extracted file exists and exactly matches its declared size.

`inspect` concatenates all files in the group and compares every byte against
the source. It consumes the declared number of `dc.b`, `dc.w`, and `dc.l`
bytes, crossing any obsolete internal source labels. Only an exact match is
replaced. A missing file, size mismatch, offset gap/overlap, source parse
failure, byte mismatch, duplicate output label, or overlapping replacement
leaves the source data intact.

The inspector also checks labels removed from inside the consumed source span.
If any such label is still referenced by source that will remain in the output,
the grouped replacement is rejected. This makes linked lookup-table conversion
safe: the graphics group is emitted only when references to its obsolete
internal labels were also removed by other successfully validated INCBIN
replacements.

The relabel process now has explicit passes:

1. `_delete` label definitions.
2. `_offset_..._0x...` conversions.
3. Ordinary relabels and `data_start` anchors.

`_delete` still removes only a label-definition line; it does not delete the
following data. Grouped resource layouts do not require `_delete` rows because
`inspect` removes the complete, byte-counted source span when it emits the
INCBINs.

## Commands

Run the normal pipeline after editing and saving the workbook:

```text
python main.py --master BLOODWYCH439 extract
python main.py --master BLOODWYCH439 relabel
python main.py --master BLOODWYCH439 inspect --debug
```

Review the inspection summary and generated
`asm/BLOODWYCH439_relabel_data.asm`. A successful grouped resource is counted
as one validated replacement, regardless of how many INCBIN files it emits.

Fixed-size patching uses the same component rows:

```text
python main.py --master BLOODWYCH439 patch --debug
```

`extract_only` rows are deliberately skipped by `patch`, preventing an
overlapping aggregate file from overwriting edits made to component files.

## Bloodwych 439 examples

Replace the ten existing `_GFX_Beholder_0` through `_GFX_Beholder_9` fragment
rows with these four rows. The repeated original label is the one source
anchor; the relabel column supplies the four generated labels.

| label | relabel | Type | DATA BLOCK FILE | name | BW439 Position | offset | size | Length (Hexidecimal) | data_action |
|---|---|---|---|---|---:|---:|---:|---:|---|
| `_GFX_Beholder_0` | `GFX_Beholder_Body` | monsters | `Beholder_Body.gfx` | `monsters/Beholder_Body.gfx` | `$47EDC` | 294620 | 672 | `2A0` | `data_start` |
| `_GFX_Beholder_0` | `GFX_Beholder_UpperEyes` | monsters | `Beholder_UpperEyes.gfx` | `monsters/Beholder_UpperEyes.gfx` | `$4817C` | 295292 | 160 | `A0` | `data_append` |
| `_GFX_Beholder_0` | `GFX_Beholder_CentralEye_Near` | monsters | `Beholder_CentralEye_Near.gfx` | `monsters/Beholder_CentralEye_Near.gfx` | `$4821C` | 295452 | 864 | `360` | `data_append` |
| `_GFX_Beholder_0` | `GFX_Beholder_CentralEye_Far` | monsters | `Beholder_CentralEye_Far.gfx` | `monsters/Beholder_CentralEye_Far.gfx` | `$4857C` | 296316 | 96 | `60` | `data_append` |

The four sizes total `$700`, so the consumed source span ends at `$485DC`, the
start of `GFX_Dragon`. Do not add `_delete` rows for `_GFX_Beholder_1` through
`_GFX_Beholder_9`. Their definitions are inside the byte-counted span. The four
Beholder `.offsets` lookup rows must also validate successfully, because those
source expressions reference the old internal labels.

`MonsterTotalsCounts` is six two-byte big-endian words, not six one-byte
blocks. Keep the existing aggregate extraction row but mark it `extract_only`,
then use the six component rows as one layout:

| label | relabel | Type | DATA BLOCK FILE | name | BW439 Position | offset | size | Length (Hexidecimal) | data_action |
|---|---|---|---|---|---:|---:|---:|---:|---|
| `Ignore` | `MonsterTotalsCounts` | maps | `monsters.totals` | `maps/monsters.totals` | `$171F4` | 94708 | 12 | `C` | `extract_only` |
| `MonsterTotalsCounts` | `MonsterTotalsCounts` | maps | `mod0.monstercount` | `maps/mod0.monstercount` | `$171F4` | 94708 | 2 | `2` | `data_start` |
| `MonsterTotalsCounts` | `MonsterTotalsCounts_Serp` | maps | `serp.monstercount` | `maps/serp.monstercount` | `$171F6` | 94710 | 2 | `2` | `data_append` |
| `MonsterTotalsCounts` | `MonsterTotalsCounts_Moon` | maps | `moon.monstercount` | `maps/moon.monstercount` | `$171F8` | 94712 | 2 | `2` | `data_append` |
| `MonsterTotalsCounts` | `MonsterTotalsCounts_Drag` | maps | `drag.monstercount` | `maps/drag.monstercount` | `$171FA` | 94714 | 2 | `2` | `data_append` |
| `MonsterTotalsCounts` | `MonsterTotalsCounts_Chaos` | maps | `chaos.monstercount` | `maps/chaos.monstercount` | `$171FC` | 94716 | 2 | `2` | `data_append` |
| `MonsterTotalsCounts` | `MonsterTotalsCounts_Zendik` | maps | `zendik.monstercount` | `maps/zendik.monstercount` | `$171FE` | 94718 | 2 | `2` | `data_append` |
