"""Apply labels from segments.xlsx to a reverse-engineered 68k source file."""

from __future__ import annotations

import re
from collections import defaultdict
from pathlib import Path

from .asm_recovery import apply_asm_recoveries, load_asm_recovery_metadata
from .fix_labels import (
    apply_fix_label_rules,
    load_fix_label_metadata,
)
from .resource_layout import (
    DATA_APPEND,
    EXTRACT_ONLY,
    cell_text,
    data_action,
    resource_layouts,
)
from .resource_aliases import insert_temporary_aliases
from .source_comments import apply_source_comments
from .source_notes import apply_source_notes, load_source_note_metadata
from .source_rules import (
    apply_source_rules,
    insert_generated_equates,
    load_source_metadata,
)
from .tool_common import ToolError, asm_path, load_segments, require_columns


def _reference_pattern(label: str) -> str:
    """Match one assembler label, including legacy names ending in ``?``.

    A dot is deliberately *not* an identifier boundary character here. In the
    Devpac source, ``.b``, ``.w`` and ``.l`` immediately following a symbol are
    operand-size suffixes (for example ``adrEA00D988.l``), not part of that
    symbol. Treating the dot as an identifier character renames the definition
    while leaving these references behind, producing an undefined symbol.
    """

    identifier_character = r"A-Za-z0-9_$?"
    return (
        rf"(?<![{identifier_character}])"
        rf"{re.escape(label)}"
        rf"(?![{identifier_character}])"
    )


def _undefined_legacy_labels(lines: list[str]) -> list[str]:
    """Return referenced ``adr...`` symbols which no longer have definitions."""

    symbol_pattern = r"adr[A-Za-z0-9_?]+"
    definitions: set[str] = set()
    references: set[str] = set()
    for line in lines:
        code = line.split(";", 1)[0]
        definition = re.match(rf"\s*({symbol_pattern})\s*(?::|\bequ\b)", code)
        if definition:
            definitions.add(definition.group(1))
        references.update(
            re.findall(
                rf"(?<![A-Za-z0-9_$?])({symbol_pattern})(?![A-Za-z0-9_$?])",
                code,
            )
        )
    return sorted(references - definitions)


def _conflicting_relabel_targets(
    lines: list[str], rows: list[tuple[str, str]]
) -> dict[str, tuple[str, ...]]:
    """Find output labels claimed by multiple source definitions in one scope.

    Only labels defined in the source being relabelled participate.  This
    avoids treating aliases emitted later by the data-inspection pass as a
    collision, while ensuring that a bad spreadsheet mapping cannot produce
    two same-named assembler labels. Devpac labels beginning with ``.`` are
    local to the preceding non-local label, so repeated local names collide
    only when their definitions have the same effective parent.
    """
    definitions = [
        match.group(1)
        for line in lines
        if (match := re.match(r"^\s*([^\s:;]+)\s*:", line))
    ]
    defined_names = {label.casefold() for label in definitions}
    applicable_rows = [
        (source_label, output_label)
        for source_label, output_label in rows
        if source_label.casefold() in defined_names
    ]

    # Non-local labels occupy the global namespace regardless of where they
    # appear. Resolve those collisions first because skipped global relabels
    # retain their original names and therefore establish distinct local-label
    # scopes below.
    global_targets: dict[str, list[str]] = defaultdict(list)
    names: dict[str, str] = {}
    for source_label, output_label in applicable_rows:
        if output_label.startswith("."):
            continue
        key = output_label.casefold()
        global_targets[key].append(source_label)
        names.setdefault(key, output_label)
    conflicts = {
        names[key]: tuple(source_labels)
        for key, source_labels in global_targets.items()
        if len(source_labels) > 1
    }
    conflicting_global_sources = {
        source_label.casefold()
        for source_labels in conflicts.values()
        for source_label in source_labels
    }

    relabels = {
        source_label.casefold(): output_label
        for source_label, output_label in applicable_rows
    }
    local_targets: dict[tuple[str | None, str], list[str]] = defaultdict(list)
    local_names: dict[tuple[str | None, str], str] = {}
    parent_label: str | None = None
    for source_label in definitions:
        source_key = source_label.casefold()
        output_label = relabels.get(source_key, source_label)
        if output_label.casefold().startswith(("_delete", "_offset_")):
            continue
        if source_key in conflicting_global_sources:
            output_label = source_label
        if not output_label.startswith("."):
            parent_label = output_label.casefold()
            continue
        target_key = (parent_label, output_label.casefold())
        local_targets[target_key].append(source_label)
        local_names.setdefault(target_key, output_label)

    for key, source_labels in local_targets.items():
        if len(source_labels) < 2:
            continue
        target = local_names[key]
        conflicts.setdefault(target, tuple())
        conflicts[target] += tuple(source_labels)
    return conflicts


def relabel_segments(
    master: str,
    sheet: str | Path,
    cleanup: str | Path | None = None,
    *,
    source: str | Path | None = None,
    destination: str | Path | None = None,
) -> Path:
    frame = load_segments(sheet, master)
    require_columns(frame, ("label", "relabel"))
    equates, source_rules = load_source_metadata(sheet, master, cleanup)
    fix_label_rules = load_fix_label_metadata(sheet, master, cleanup)
    source_notes = load_source_note_metadata(sheet, master, cleanup)
    original = Path(source) if source is not None else asm_path(master, "asmfix")
    if not original.is_file():
        raise ToolError(
            f"ASM Fix source not found: {original}. Run ASM Fix before Relabel."
        )
    destination = (
        Path(destination) if destination is not None else asm_path(master, "relabel")
    )
    print(f"Building relabel copy '{destination}'")

    # Work in memory and only replace the generated file after every relabel and
    # integrity check succeeds. A failed run must not leave an original or
    # partially relabelled source masquerading as the generated output.
    lines = original.read_text(encoding="utf-8", errors="ignore").splitlines()
    layouts = resource_layouts(frame)  # Validate before changing the source.
    internal_append_indices = {
        index
        for layout in layouts
        for index, row in layout.rows[1:]
        if cell_text(row, "label") != layout.source_label
    }

    def relabel_rows():
        for index, row in frame.iterrows():
            action = data_action(row)
            if action == EXTRACT_ONLY:
                continue
            # Legacy grouped rows repeat the data_start anchor and their labels
            # are emitted later by inspect_source. A data_append row carrying a
            # distinct internal source label is renamed normally, allowing one
            # spreadsheet row to describe both that label and its INCBIN part.
            if action == DATA_APPEND and index not in internal_append_indices:
                continue
            label = cell_text(row, "label")
            new_label = cell_text(row, "relabel")
            if not label or not new_label or new_label == label:
                continue
            yield label, new_label

    # Explicit pass 1: remove labels deliberately marked for deletion. Only the
    # definition line is removed; grouped layouts do not depend on this action.
    rows = list(relabel_rows())
    conflicting_targets = _conflicting_relabel_targets(lines, rows)
    if conflicting_targets:
        skipped_sources = {
            source_label.casefold()
            for source_labels in conflicting_targets.values()
            for source_label in source_labels
        }
        for target, source_labels in conflicting_targets.items():
            print(
                "WARNING: Multiple source labels map to "
                f"'{target}' in the same Devpac scope "
                f"({', '.join(source_labels)}); skipping those relabels to "
                "avoid duplicate ASM definitions."
            )
        rows = [
            (label, new_label)
            for label, new_label in rows
            if label.casefold() not in skipped_sources
        ]
    for label, new_label in rows:
        if not new_label.casefold().startswith("_delete"):
            continue
        definition_pattern = rf"^\s*{re.escape(label)}\s*:"
        matches = [i for i, line in enumerate(lines) if re.match(definition_pattern, line)]
        if len(matches) == 1 and ";" not in lines[matches[0]]:
            print(f"Deleting '{label}' at line {matches[0] + 1}")
            lines.pop(matches[0])
        else:
            print(f"Cannot safely delete '{label}': {len(matches)} definition(s)")

    # Explicit pass 2: convert labels into base-label-plus-offset references.
    for label, new_label in rows:
        if not new_label.casefold().startswith("_offset_"):
            continue
        definition_pattern = rf"^\s*{re.escape(label)}\s*:"
        parts = new_label.split("_")
        if len(parts) < 4 or not parts[-1].casefold().startswith("0x"):
            print(f"Invalid offset format '{new_label}', skipping")
            continue
        replacement = f"{'_'.join(parts[2:-1]).rstrip('_')}+${parts[-1][2:]}"
        matches = [i for i, line in enumerate(lines) if re.match(definition_pattern, line)]
        if len(matches) == 1 and ";" not in lines[matches[0]]:
            lines.pop(matches[0])
        else:
            print(f"Cannot safely delete definition '{label}'; skipping offset replacement")
            continue
        reference_pattern = _reference_pattern(label)
        lines = [re.sub(reference_pattern, replacement, line) for line in lines]
        print(f"Replaced '{label}' references with '{replacement}'")

    # Explicit pass 3: apply separately maintained fix-label rules before
    # ordinary relabels. This keeps an inserted data label independent from
    # the existing code label used to locate the source boundary. No rule is
    # inferred from address adjacency.
    lines, _ = apply_fix_label_rules(lines, fix_label_rules)

    # Explicit pass 3a: add spreadsheet-owned standalone notes at marked raw
    # source boundaries. These are annotations only; they neither add labels
    # nor rewrite the preserved dc.* declarations.
    lines = apply_source_notes(lines, source_notes, continue_on_error=True)

    # Explicit pass 4: ordinary labels and data_start anchors are renamed after
    # all definition deletions and fix-label insertions. data_append labels are
    # emitted by inspect_source.
    for label, new_label in rows:
        if new_label.casefold().startswith(("_delete", "_offset_")):
            continue
        definition_pattern = rf"^\s*{re.escape(label)}\s*:"
        if not any(re.match(definition_pattern, line) for line in lines):
            print(f"Label '{label}' not found, skipping")
            continue
        reference_pattern = _reference_pattern(label)
        lines = [re.sub(reference_pattern, new_label, line) for line in lines]
        print(f"Relabeled '{label}' to '{new_label}'")

    label_relabels = {
        label: new_label
        for label, new_label in rows
        if not new_label.casefold().startswith(("_delete", "_offset_"))
    }
    lines = apply_source_rules(
        lines,
        equates,
        source_rules,
        label_relabels=label_relabels,
        continue_on_error=True,
    )
    lines = insert_generated_equates(lines, equates)
    lines = apply_source_comments(lines, frame)
    lines = insert_temporary_aliases(lines, layouts)
    undefined_legacy_labels = _undefined_legacy_labels(lines)
    if undefined_legacy_labels:
        preview = ", ".join(undefined_legacy_labels[:10])
        remainder = len(undefined_legacy_labels) - 10
        if remainder > 0:
            preview += f", ... ({remainder} more)"
        raise ToolError(
            "Relabel integrity check found referenced legacy labels without "
            f"definitions: {preview}"
        )
    destination.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Saved relabeled ASM to '{destination}'")
    return destination


def build_asmfix(
    master: str,
    sheet: str | Path,
    cleanup: str | Path | None = None,
) -> Path:
    """Recover verified instructions into the source used by Relabel."""
    recovery_rules = load_asm_recovery_metadata(sheet, master, cleanup)
    original = asm_path(master, "source")
    if not original.is_file():
        raise ToolError(f"ASM source not found: {original}")
    recovered_source = asm_path(master, "asmfix")
    lines = original.read_text(encoding="utf-8", errors="ignore").splitlines()
    lines, applied = apply_asm_recoveries(lines, recovery_rules)
    if not applied:
        raise ToolError("ASM Fix found no verified recovery groups to apply")
    recovered_source.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Saved pass-0 ASM recovery source to '{recovered_source}'")
    return recovered_source
