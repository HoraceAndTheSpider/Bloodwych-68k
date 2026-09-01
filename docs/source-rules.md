# Spreadsheet-owned EQU definitions and source rules

`segments.xlsx` keeps the protected version-specific labels and binary resource
ranges. Source constants and instruction comments are maintained in the
separate `cleanup.xlsx` workbook, in its `EQUATES` and `COMMENTS` worksheets.
Each EQUATES row defines an EQU and may also identify one confirmed instruction
where it replaces a literal or misleading disassembly label.

The columns are `profile`, `equ_name`, `equ_value`, `scope_start`, `scope_end`,
`source_match`, `expected_opcode`, `source_replace`, `expected_matches`,
`status`, `source_comment`, and optional `notes`.

The Relabel step treats the cleanup workbook as optional. A project without it
continues to use the original label workflow.

Only rows marked `verified` affect generated source. Use `proposed` only for a
specific unresolved live-data, emulator, or controlled-binary check, and record
that check and its promotion criterion in `notes`. `disabled` rows are retained
but ignored.

## Stable instruction matching

Rules never use source line numbers. Each verified replacement specifies:

1. start and end labels defining a narrow source scope;
2. the complete original instruction;
3. the original opcode bytes from the disassembly comment;
4. the complete replacement instruction containing the named EQU;
5. the number of expected matches within the scope.

`expected_matches` defaults to `1` when blank. Set it above `1` only when every
matching instruction is independently confirmed to use the same EQU. Relabel
aborts if a scope label is missing, the match count differs, or the opcode
fingerprint has changed. This prevents
a contextual value such as `#$40` from being replaced globally when only one
occurrence denotes the Zendik character form.

An EQU-only row leaves the scope/source fields blank. Repeating the same
`equ_name` and value is allowed when several independently scoped uses have
been confirmed.

Verified EQU definitions are inserted after the original source EQU header.
The final Formatting pass moves that complete static header into the sibling
`Bloodwych439_equates.asm` file and replaces it with an `INCLUDE`. Original
system definitions remain first; the definitions already present in the final
source are separated into families using the part of each name before its first
underscore (for example `ChampionPocket`, `InterfaceAction`, and `MonsterLive`).
This is a source-formatting operation: EQU definitions and comments are moved
from `_relabel_data.asm` without loading or regenerating their values or comments
from the EQUATES worksheet. EQU aliases such as `equ *-2` that depend on their
position in the main source remain inline. If the main source already contains
its `INCLUDE`, the Formatting pass refreshes the existing include in place.

`equ_value` remains a numeric field for now. Supporting expressions such as
`Object_Food_First = Object_Arrows_Last+1` will also require undefined-name and
dependency-cycle checks, plus dependency-aware output ordering, before those
expressions can safely become authoritative cleanup metadata.

Scoped operand substitutions are applied after ordinary label relabelling, so
rules should use the labels present in the final relabelled source.

The initial verified rule replaces the false `adrL_0186A0` address reference
in the disk DMA wait loop with `DiskReadTimeoutCount`. Once the operand no
longer references the internal label, Inspect can safely replace the complete
monster-data allocation.
