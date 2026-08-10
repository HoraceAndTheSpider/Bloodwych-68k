# Bloodwych ReSource — Agent Instructions

This file provides durable project context for Codex and other coding agents. Read it before making changes in this repository.

## Project purpose

This repository is becoming the Bloodwych “SuperApp”: one environment for identifying a user-supplied Bloodwych executable, extracting its data and indexed graphics, viewing and editing structured resources, and then either patching fixed-size changes or rebuilding a compatible 68000 source tree when sizes or addresses change.

The original binary must remain immutable. Editors work with extracted project data; only the build system may patch or create an executable.

The primary supported variant is SPS **439**, written `BLOODWYCH439`. SPS identifiers are whole numbers: use **439**, **1927**, and **43**—never “4.39”, “19.27”, or “4.3”. `BEXT43` is the Extended Levels release. Other known inputs are `BLOODWYCH102`, `BLOODWYCH1927`, and `AtariST_DEMO_CODE`.

## Start every task safely

1. Run `git status --short --branch` before changing anything.
2. Treat all existing modifications and untracked files as belonging to the user unless the task clearly created them.
3. Read the relevant source, documentation, spreadsheet rows, and tests before implementing a fix.
4. Use `rg`/`rg --files` for repository searches.
5. Make the smallest coherent change and test it in proportion to its risk.
6. Do not commit or push unless the user explicitly asks. When asked, stage only the intended files.

Never discard, overwrite, reformat, or stage unrelated user work. In particular, do not modify `segments.xlsx` unless the user explicitly authorises spreadsheet editing in the current task.

## Canonical repository layout

- `segments.xlsx` — master version-specific addresses, names, extraction definitions, source comments, resource layouts, and scoped equates.
- `main.py` — top-level CLI and Pygame launcher.
- `asm/` — reverse-engineered source. The usual sequence is `BINARY.asm`, `BINARY_relabel.asm`, then `BINARY_relabel_data.asm`.
- `binaries/` — original game binaries.
- `data/<PROFILE>-clean/` — authoritative extractions from an original binary.
- `data/<PROFILE>-modified/` — user-edited overlay files.
- `tools/` — reusable extraction, relabelling, inspection, patching, rendering, and editor code.
- `tests/` — automated tests.
- `whdload/` — save data and WHDLoad patch material.
- `_archive/` — historical/reference material, including AMOS editor source.

Preserve the spelling and case of paths already used by the repository. Do not invent a parallel directory convention.

## Sources of truth

Use this priority when evidence conflicts:

1. Observed behaviour from the original game or editor and controlled binary comparisons.
2. The original executable and `asm/BLOODWYCH439.asm`.
3. The generated relabelled source, after confirming how its labels were produced.
4. `_archive/AMOS code/BloodwychEditor2-7_026.txt` and other original AMOS tools.
5. The GitHub Wiki and repository documentation.
6. Existing Python previews or earlier inferences.

The Python viewer is a consumer of the decoded game rules, not evidence that an interpretation is correct. Prefer source-derived geometry, palette selection, mirroring, and table meanings over manual visual corrections. If a temporary viewer-only adjustment is necessary, identify it clearly.

## Normal tool sequence

The user-facing order is:

1. **Extract**
2. **Relabel**
3. **Inspect / Data**
4. **Patch**

`Relabel` generates `_relabel.asm`. `Inspect / Data` validates source replacements and generates `_relabel_data.asm`. GUI-launched operations should return to the main menu when complete rather than terminating the whole application.

Generated `_relabel.asm` and `_relabel_data.asm` files are outputs. Never fix a generation defect by editing only a generated ASM file: correct the spreadsheet or Python generator, regenerate it, and test the regenerated result.

For an unchanged SPS 439 project, binaries compiled from the original, `_relabel`, and `_relabel_data` sources must be byte-identical. Size equality alone is insufficient. The established Amiga reference assembler is Devpac 3.18. Be alert to assembler alignment bytes after odd-length `INCBIN` data.

## Clean and modified data

`-clean` files are immutable extracted originals. Saving an editor change writes to the corresponding `-modified` tree.

The modified-data toggle is a file-by-file overlay:

- use the modified file when present;
- otherwise fall back to the clean file;
- refresh decoded graphics/data immediately when the toggle or file selection changes.

Do not patch a modified resource into an incompatible binary profile. Larger resources, such as Book of Skulls data with additional monster grades, require a matching spreadsheet layout and usually a relocation/source-build route.

## Spreadsheet collaboration

The user generally prefers to enter spreadsheet changes manually. When proposing additions, provide a complete, copy-ready table using the exact columns of the relevant sheet, including blank cells. Do not provide a shortened selection of columns that makes duplicate anchors or actions ambiguous.

For label/relabel proposals on a profile sheet, include every column from column A (`label`) through column K (`source_comment`), retaining any blank cells between them. For `BLOODWYCH439`, the required chat-table columns are:

```text
label | relabel | Type | DATA BLOCK FILE | name | BW439 Position | offset | size | Length (Hexidecimal) | data_action | source_comment
```

Do not shorten label proposals to only the populated columns, and do not include the trailing blank, separator, or `Unnamed` spreadsheet columns after `source_comment`.

For each extractable resource, propose:

- a human-readable relabel;
- its logical folder;
- filename;
- full relative output path;
- verified binary offset and size;
- the appropriate `data_action`;
- a plain-English `source_comment`;
- any cautions or unresolved interpretation in notes.

If an extracted asset or table is discovered to have a misleading name, explicitly flag it to the user before silently updating code or Wiki documentation. The spreadsheet should be corrected so that filenames describe the real content.

### Deep-dive investigation handoff

After any deep-dive reverse-engineering or data-flow investigation, provide the user with copy-ready spreadsheet proposals in the exact format of the relevant sheet. The output must be literal tab-separated values (TSV) in a plain code block: one header row, one data row per line, real tab characters between cells, blank cells preserved as empty fields, and no Markdown table pipes or explanatory text inside the TSV block. For `BLOODWYCH439` profile-sheet findings, include every column from `label` through `source_comment` (columns A-K), including blank cells, and include verified labels, relevant scoped-EQU proposals, evidence locations, and cautions about unresolved interpretations. For `EQUATES`, use every maintained column from `profile` through `notes` in its exact order. Do this proactively in the same response; the user should not need to ask for the spreadsheet table separately. Do not edit `segments.xlsx` unless the user explicitly authorises spreadsheet editing.

Before proposing any relabel, trace the original source label and inspect the existing profile-sheet mapping. Verify every symbol by exact-text search in the original ASM before putting it in a table; never infer a label prefix or construct a symbol from its address and nearby routine names. A symbol that is already a relabel of an original label must be reported as an existing mapping/reference, not proposed again as a new relabel. For example, if `adrJT0057CE` already maps to `InterfaceButtons`, do not emit a new row with `InterfaceButtons` as though it were the original label. Preserve the original-label-to-relabel chain in all investigation tables and explanations; if the chain is uncertain, mark it unresolved rather than silently substituting a relabel as the original anchor. If an earlier table contains a symbol that fails exact-text verification, call out and correct that error before presenting the next handoff. In `EQUATES`, an EQU-only row must leave `scope_start`, `scope_end`, `source_match`, and `source_replace` all blank. Never provide `source_match` without a complete same-mnemonic `source_replace`; a verified scoped rule must populate all four fields and use valid start/end labels.

### Resource actions

Resource layout is spreadsheet-driven. Do not introduce hard-coded ASM line ranges or resource ranges into Python.

- `data_start` starts a grouped source replacement and emits the first labelled resource.
- `data_append` appends another separately labelled resource at the same grouped source location.
- `extract_only` extracts a resource but intentionally does not replace its source bytes.

Do not default meaningful tables to `extract_only`. Shared or normally non-editable renderer tables can still be useful as `INCBIN` resources because this reduces ASM size and makes the data independently inspectable. Use `extract_only` only when reinsertion is genuinely unsafe or inappropriate.

Avoid two authoritative editable copies of the same bytes. If a block cannot safely be reinserted, prefer a source label, an offset label, or a scoped EQU instead of maintaining an extracted file that appears editable but is ignored by builds.

Generated `INCBIN` paths use the established leading slash form, for example:

```asm
INCBIN "/data/BLOODWYCH439-clean/gfx-data/example.lookup"
```

### Interior/offset labels

Labels cannot be physically inserted inside an `INCBIN`. When code refers to an address within an extracted block, retain one base label and express interior references as a named offset from that base. Do not split the file solely to manufacture an interior ASM label unless it is a genuine resource boundary.

### Scoped equates

The `Equates` sheet is for semantic constants and stable source substitutions that are not necessarily disassembly address labels. Its maintained columns are:

```text
profile | equ_name | equ_value | scope_start | scope_end | source_match | expected_opcode | source_replace | status | source_comment | notes
```

Use stable routine labels plus an exact source/instruction match; never use mutable ASM line numbers. A literal such as `#$40` must not be replaced globally because it may mean Zendik in one routine and an unrelated value elsewhere.

Only `verified` rows should affect generated source. `proposed` rows document candidates; `disabled` rows are retained but inactive. Repeating an `equ_name` for several verified uses is acceptable when the value is consistent and each source occurrence is independently scoped.

Use an EQU for meaningful IDs, thresholds, table lengths, hard-coded render adjustments, flags, and special-case values. Temporary working variables or runtime state may deserve labels but normally do not deserve extracted data files.

### Source comments

`source_comment` is the spreadsheet-controlled comment attached to a table, function, or label. Comments should explain what the code/data does in plain English, not narrate the reverse-engineering process. Apostrophes in comments must remain valid.

## Resource naming

Use faux extensions consistently:

- `.gfx` — indexed Atari ST-style four-plane graphical pixel data.
- `.offsets` — lookup/divider data that locates pictures or strips inside packed `.gfx` data. Reserve this term for data addressing, not screen placement.
- `.positions` — X/Y screen drawing positions or comparable placement coordinates.
- `.lookup` — a general mapping/index table where a more precise convention does not apply.
- `.layout` — component assembly or render-layout definitions.
- `.heights`, `.widths` — explicit dimensional tables.
- `.flags` — bit flags or per-entry boolean behaviour.
- `.palette` — palette entries; `.colours` — palette-selection/recolour data.

Put shared renderer and geometry tables under `gfx-data/`. Put monster-specific graphics and their companion data under `monsters/`. Put non-graphical game structures under `data/`. Avoid names such as `.RenderData` or `.facing` that do not match the agreed conventions.

## Binary/source safety rules

- All offsets, sizes, and boundaries must be verified against the original binary or original source.
- Source replacement must fail closed if blocks overlap, are non-contiguous, cross a declared end, remove a referenced label, or cannot reproduce exact bytes.
- Deletions must remove the intended source bytes, not merely the label line.
- Preserve references when replacing a large source block; create offset aliases/EQU expressions where required.
- Sequential resources must reproduce original alignment exactly. Never allow an implicit assembler pad byte to masquerade as resource data.
- Fixed-size compatible changes may use binary patching. Size-changing data requires complete pointer/relocation knowledge or a matching source rebuild.
- Do not patch unsupported modified layouts into an original executable.

## Graphics fundamentals

Bloodwych graphics are indexed. Preserve palette indices through decoding and editing rather than flattening them prematurely to RGB.

The canonical 16-colour game palette words are:

```text
$0000 $0444 $0666 $0888 $0AAA $0292 $01C1 $000E
$048E $0821 $0B31 $0E96 $0D00 $0FD0 $0EEE $0C08
```

Convert each Amiga RGB nibble to 8-bit RGB by multiplying it by 17. A likely hardware-pointer palette also exists near the pointer data; verify its use from source before treating it as general UI colour data.

Other durable facts:

- The native dungeon viewport is 128×76 pixels.
- Internal `.gfx` images use Atari ST-style four-plane indexed data.
- `Pockets.gfx` is mostly a 16×16 sprite grid: icon 0 starts at `(0,0)`, icon 1 at `(16,0)`, continuing across the row before advancing 16 pixels. Its lower portion also contains irregularly sized interface graphics.
- `GameFont` contains the game glyphs. Ordinary readable game text is normally uppercase; lower-case glyph positions are also used for runes/symbols.
- The AMOS map view uses high-resolution, tall/rectangular pixels; its popup editors use low-resolution square pixels. Account for this when translating procedural drawing coordinates.
- The first three BOBs are a small square cursor and the two original mouse cursors. The remaining BOB bank is principally pre-rendered coloured sprites and can be regenerated dynamically from original data.
- Monster palette variants are called **grades** in user-facing text.

Graphics generated for viewers are disposable derivatives. Wherever possible, decode them from the user’s uploaded/extracted game so modified graphics automatically appear in the application.

## Viewer and editor principles

- Keep decoding, rendering, editing, and executable building separate.
- Retain raw bytes and unknown bits alongside decoded fields; do not destroy information merely because it is not yet understood.
- Viewer controls should expose game concepts rather than raw nibbles where those concepts are known.
- Never display guessed object or monster locations as fact. Disable an overlay until its records are correctly decoded.
- Preserve zoom when changing towers or floors. Moving a keyboard-controlled cursor should pan a zoomed viewport when necessary.
- Treat outside-map dungeon space as solid stone walls in the first-person preview.
- The map subsystem is divided into Viewer, Maps, Objects, Characters/Monsters, and Layout. Avoid duplicating separate models for the same floor or cell across those sections.
- Save editor output to `-modified`; do not overwrite `-clean`.

## Wiki standards

The GitHub Wiki documents verified mechanics, data formats, renderer behaviour, and source structure. It must not read like a development diary.

Do include:

- plain-English explanations of tables and algorithms;
- verified record layouts and value meanings;
- relevant formulas with practical examples;
- source labels/addresses only where they help readers understand the structure;
- limitations and genuinely unresolved details.

Do not include:

- viewer implementation notes unless the page is specifically about the viewer;
- future relabelling proposals or spreadsheet to-do lists;
- a chronology of exploration;
- unrelated mechanics on a narrowly scoped lookup-table page;
- assumptions presented as confirmed behaviour.

The Wiki is a separate Git repository from the main code repository. Commit and push Wiki changes separately, and only when requested. Images that materially explain a format or mechanic may be placed in the Wiki’s `wiki/` asset folder; the user has authorised this.

## Testing and handoff

Before reporting a code change complete:

1. Run the focused tests for the changed subsystem.
2. Run the broader test suite where practical, normally `python -m unittest discover -s tests`.
3. Regenerate outputs when the generator changed; do not rely on a hand-edited generated file.
4. For relabelling/data-layout work, inspect the generated ASM and verify unchanged compiled binaries byte-for-byte when the Amiga compile result is available.
5. Review `git diff --check`, `git status`, and the exact staged set.
6. State clearly what was changed, what was tested, and what still requires user/Amiga verification.

Do not commit assembler listings, locally compiled binaries, temporary screenshots, macOS `Icon?` metadata, or generated outputs that are not intentionally versioned. Direct work on `master` is normal for this repository when the user explicitly asks to commit/push; do not create a pull request unless requested.
