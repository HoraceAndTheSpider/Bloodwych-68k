# Wiki editorial review — 31 August 2026

## Scope

This is a repository maintenance note, not a Wiki page or an application guide.

Published the 16-page repair as Wiki commit `31f25ea` on `master`.
The AGENTS update and these review/archive notes remain uncommitted in the
main repository; no unrelated main-repository changes were staged.

Compared the Wiki at `0f579d7` with its 20 July 2026 snapshot `9a4a102`,
and compared the five layout-related pages with `0f579d7^` to isolate the
latest rewrite. The older snapshot has 35 pages; the current Wiki has 50.
Since that snapshot, 20 existing pages changed and 15 pages were added;
15 existing pages were unchanged.

The review checks preservation of explanations, examples, tone and the
boundary between game/source documentation and application instructions.
It is not a fresh reverse-engineering or byte-identical build certification
of every claim on all 50 pages.

## Repairs

- **Map Data Structure:** restored the plain introduction, original location
  list and annotated Keep header. Kept local factual corrections, including
  payload-relative offsets, zero-based floors, and the distinction between the
  shared working header and each player's floor.
- **Stairs:** restored the bit-by-bit explanation, facing list and Keep/Chaos
  example. Kept the source-derived two-cell transition and the fact that the
  game does not require a reciprocal stair.
- **Pads, Triggers & Holes:** retained the original structure; put additional
  source details after it. Removed editor-warning and label-proposal language.
- **Object Location Data Structure:** restored the AB/CD walkthrough and all
  three apple/key/dagger examples. Kept the 14-bit offset and capacity findings.
- **Player Location Data:** restored separate Blue/Red Player and save-offset
  lists, with the verified Player 2 floor correction. Added source detail
  after the accessible explanation.
- **Spell Casting Mechanics:** restored the colour-matching explanation,
  Vanish cost example, negative power examples and individual BEXT spell list.
  Moved champion-record offsets and the exact casting sequence below the
  main explanation. Did not restore the incorrect shared-practice counter,
  127 limit, old practice formula or spell-number-as-difficulty column.
- **Airbourne Spells:** restored individual entries 90–98 and their original
  uncertainties instead of collapsing them into ranges. Kept SPS 439 and BEXT
  limitations distinct; removed spreadsheet workflow.
- **Monster Data Structure (Live):** restored the reported paralysis byte
  observation as unresolved evidence. Removed byte 09 from the uncertainty
  list because the existing layout identifies it as part of the HP word.
- **Monster Graphics Renderer; Character Definitions; Dungeon Graphics
  Renderer; Dungeon Graphics Components and Planar Compositor:** preserved
  the source explanations while removing editor controls, future editing
  plans, extraction actions and spreadsheet instructions. Corrected the
  compositor's four-plane size explanation from one longword to four words,
  read as two longwords.
- **Extracted Data File Types:** retained the resource-format reference,
  aliases and alignment explanation; removed the SuperApp treatment column
  and workbook/Inspect instructions.
- **Source Equates and Scoped Replacements:** retained the disk-timeout
  example and constant-versus-address explanation; removed worksheet schema
  and application validation behaviour.
- **Magic Locations; Object Definitions:** removed proposal/app terminology
  without rewriting their mechanics.

## Other pages

The following changed pages did not need a repair for the issues identified:
Archery Mechanics, Armour Mechanics, Atari ST Raw Data Format, Bloodwych
Pockets Data Structure, Communication and Trading, Fighting Mechanics,
Game Font, General Overview, Home, Metal Doors, Stone Walls, Wooden Walls,
Object Lookup Table, Party Avatar Presentation and Command Gate, Quickstart
Party Setup, Sound Effects and PlaySound, Spell Book Interface, and Spell
Effects and Handlers. Changes were new source explanations, additions,
links, or minor corrections rather than lost original examples.

The 15 pages unchanged since the baseline were: Bloodwych Champion Data
Structure; Bloodwych Extended Levels Champion Data Structure; Colouring Large
Monsters; Game Palette; Icon List; Keyboard Controls; Keyboard Reading
Routines; Map Location Data (3) Misc; Map Location Data (0) Spaces; Monster
Attack Spells; Monster Lookup Table; Pad / Floor Traps & Triggers;
Teleportation Gems; Tower & Dungeon Entrances and Exits; Wall Switches.

The Game Font decoder example already exists in the older material; it was
not removed merely for mentioning Python/TypeScript. References to the
original game's renderer, interface and Quickstart behaviour are also in scope
for the Wiki, unlike SuperApp controls.

### Existing Monster Data Structure draft

The sibling Wiki checkout has an uncommitted `Monster-Data-Structure.md`
draft. Neither that draft nor the published page was changed in this repair.
The published page retains the eight-record example and per-field
explanation, but the older raw six-tower count example was removed.
That example can be restored when reconciling the draft. The old two-team
example should not be restored unchanged: values 00/01 and 02/03 are slots
in the same four-member group, not separate groups.

The draft also contains an editor-specific “join previous” paragraph. Its
game-team explanation belongs in the Wiki; the control-specific instruction
belongs in application documentation. This is recorded rather than silently
altering the user's pending work.

Follow-up: the user subsequently authorised reconciliation of this draft.
The packed and live monster pages now retain the original examples and add
the team-byte explanation, runtime table layout and original-data examples.
The same-Y assumption was corrected using the original Serpent Tower records.
See [monster-teams-source-audit.md](monster-teams-source-audit.md) for the
source verification and metadata corrections. The deferral above is resolved.

## Checks and boundaries

- All 41 `adr...` symbols occurring in the repaired pages exist exactly as
  labels in the original `asm/Bloodwych439.asm`; this is a label-existence
  check, not a new verification of every routine's meaning.
- The compositor at `adrLp00ADA4` reads two longwords, and
  `adrCd00AE14` writes the four plane words separately.
- Retained the verified numeric spell tables; restored examples are arithmetic
  illustrations of those tables.
- Checked the Keep header and original object examples against the existing
  source/binary evidence.
- Reviewed Markdown tables, links, and `git diff --check`.
- No workbook, application code, generated ASM, original binary or extracted
  clean resource was changed by this editorial repair.
- `AGENTS.md` now explicitly requires preserving the author's accessible
  explanations and keeping SuperApp user guidance out of the Wiki.
- Wiki publication is separate from the main repository. Existing main-repo
  changes and the sibling Wiki draft are not staged or committed.

Removed tooling passages are preserved in
[wiki-tooling-notes-archive.md](wiki-tooling-notes-archive.md).
