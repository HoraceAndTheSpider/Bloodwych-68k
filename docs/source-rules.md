# Spreadsheet-owned EQU definitions and source rules

`segments.xlsx` keeps binary resource ranges on the version sheet and source
constants on one optional `EQUATES` worksheet. Each row defines an EQU and may
also identify one confirmed instruction where it replaces a literal or
misleading disassembly label.

The columns are `profile`, `equ_name`, `equ_value`, `scope_start`, `scope_end`,
`source_match`, `expected_opcode`, `source_replace`, `status`,
`source_comment`, and optional `notes`.

The Relabel step treats this worksheet as optional. A workbook without it
continues to use the original label workflow.

Only rows marked `verified` affect generated source. `proposed` rows remain
visible for research and `disabled` rows are retained but ignored.

## Stable instruction matching

Rules never use source line numbers. Each verified replacement specifies:

1. start and end labels defining a narrow source scope;
2. the complete original instruction;
3. the original opcode bytes from the disassembly comment;
4. the complete replacement instruction containing the named EQU.

Every rule must match exactly once. Relabel aborts if a scope label is missing,
the match count differs, or the opcode fingerprint has changed. This prevents
a contextual value such as `#$40` from being replaced globally when only one
occurrence denotes the Zendik character form.

An EQU-only row leaves the scope/source fields blank. Repeating the same
`equ_name` and value is allowed when several independently scoped uses have
been confirmed.

Verified EQU definitions are inserted after the original source EQU header.
Scoped operand substitutions are applied after ordinary label relabelling, so
rules should use the labels present in the final relabelled source.

The initial verified rule replaces the false `adrL_0186A0` address reference
in the disk DMA wait loop with `DiskReadTimeoutCount`. Once the operand no
longer references the internal label, Inspect can safely replace the complete
monster-data allocation.
