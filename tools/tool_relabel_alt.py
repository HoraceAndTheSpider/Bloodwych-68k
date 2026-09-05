"""Indexed comparison implementation of the Bloodwych Relabel pipeline."""

from __future__ import annotations

from pathlib import Path
from time import perf_counter

import pandas as pd

from .asm_index import AsmDocument, casefold_definition_index
from .fix_labels import (
    FIX_LABELS_SHEET,
    apply_fix_label_rules,
    load_fix_label_metadata,
)
from .resource_aliases import insert_temporary_aliases
from .resource_layout import (
    DATA_APPEND,
    EXTRACT_ONLY,
    cell_text,
    data_action,
    resource_layouts,
)
from .source_comments import apply_source_comments
from .source_notes import (
    SOURCE_NOTES_SHEET,
    apply_source_notes,
    load_source_note_metadata,
)
from .source_rules import (
    EQUATES_SHEET,
    SourceRuleMetrics,
    apply_source_rules_indexed,
    insert_generated_equates,
    load_source_metadata,
)
from .tool_common import (
    ToolError,
    asm_path,
    load_segments,
    require_columns,
    resolve_cleanup_path,
)
from .tool_relabel import _conflicting_relabel_targets, _undefined_legacy_labels


def _default_alt_destination(master: str) -> Path:
    return asm_path(master, "relabel")


def _cleanup_frames(
    sheet: str | Path, cleanup: str | Path | None
) -> dict[str, pd.DataFrame]:
    """Load all ALT cleanup metadata through one workbook open."""

    path = resolve_cleanup_path(sheet, cleanup)
    frames = {
        "equates": pd.DataFrame(),
        "fix_labels": pd.DataFrame(),
        "source_notes": pd.DataFrame(),
    }
    if not path.is_file() or path.suffix.casefold() == ".csv":
        return frames

    with pd.ExcelFile(path) as book:
        sheet_names = {name.casefold(): name for name in book.sheet_names}

        def read(name: str) -> pd.DataFrame:
            actual = sheet_names.get(name.casefold())
            if actual is None:
                return pd.DataFrame()
            return pd.read_excel(book, sheet_name=actual)

        frames["equates"] = read(EQUATES_SHEET)
        frames["fix_labels"] = read(FIX_LABELS_SHEET)
        frames["source_notes"] = read(SOURCE_NOTES_SHEET)
    return frames


def _print_timings(timings: list[tuple[str, float]], total: float) -> None:
    print("ALT Relabel timings:")
    for label, elapsed in timings:
        print(f"  {label:<24} {elapsed:.2f}s")
    print(f"  {'TOTAL':<24} {total:.2f}s")


def _print_source_rule_metrics(metrics: SourceRuleMetrics) -> None:
    print("Source rule ALT timings:")
    print(f"  index build:            {metrics.index_build_seconds:.3f}s")
    print(
        "  operand regex build:    "
        f"{metrics.operand_relabel_build_seconds:.3f}s"
    )
    print(f"  verified rules:         {metrics.verified_rules:5d}")
    print(f"  indexed candidates:     {metrics.indexed_candidates:5d}")
    print(f"  rewritten lines:        {metrics.rewritten_lines:5d}")
    print(f"  selective O2 lines:     {metrics.selective_o2_lines:5d}")
    print(f"  failed safely:          {metrics.failed_rules:5d}")
    print(f"  rule processing:        {metrics.rule_processing_seconds:.3f}s")


def relabel_segments_alt(
    master: str,
    sheet: str | Path,
    cleanup: str | Path | None = None,
    *,
    source: str | Path | None = None,
    destination: str | Path | None = None,
) -> Path:
    """Build an indexed Relabel output while preserving legacy pass order."""

    total_started = perf_counter()
    phase_started = total_started
    timings: list[tuple[str, float]] = []

    frame = load_segments(sheet, master)
    require_columns(frame, ("label", "relabel"))
    cleanup_frames = _cleanup_frames(sheet, cleanup)
    equates, source_rules = load_source_metadata(
        sheet, master, cleanup, frame=cleanup_frames["equates"]
    )
    fix_label_rules = load_fix_label_metadata(
        sheet, master, cleanup, frame=cleanup_frames["fix_labels"]
    )
    source_notes = load_source_note_metadata(
        sheet, master, cleanup, frame=cleanup_frames["source_notes"]
    )
    timings.append(("metadata", perf_counter() - phase_started))

    phase_started = perf_counter()
    original = Path(source) if source is not None else asm_path(master, "asmfix")
    if not original.is_file():
        raise ToolError(
            f"ASM Fix source not found: {original}. Run ASM Fix before Relabel."
        )
    output = (
        Path(destination)
        if destination is not None
        else _default_alt_destination(master)
    )
    print(f"Building indexed relabel copy '{output}'")
    lines = original.read_text(encoding="utf-8", errors="ignore").splitlines()
    layouts = resource_layouts(frame)
    internal_append_indices = {
        index
        for layout in layouts
        for index, row in layout.rows[1:]
        if cell_text(row, "label") != layout.source_label
    }

    rows: list[tuple[str, str]] = []
    for index, row in frame.iterrows():
        action = data_action(row)
        if action == EXTRACT_ONLY:
            continue
        if action == DATA_APPEND and index not in internal_append_indices:
            continue
        label = cell_text(row, "label")
        new_label = cell_text(row, "relabel")
        if label and new_label and new_label != label:
            rows.append((label, new_label))

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
    timings.append(("source/layout", perf_counter() - phase_started))

    phase_started = perf_counter()
    document = AsmDocument(lines, tracked_symbols={label for label, _ in rows})
    for label, new_label in rows:
        if not new_label.casefold().startswith("_delete"):
            continue
        matches = document.definition_indices(label)
        if len(matches) == 1 and ";" not in document.get_line(matches[0]):
            print(f"Deleting '{label}' at line {matches[0] + 1}")
            document.delete_line(matches[0])
        else:
            print(f"Cannot safely delete '{label}': {len(matches)} definition(s)")

    for label, new_label in rows:
        if not new_label.casefold().startswith("_offset_"):
            continue
        parts = new_label.split("_")
        if len(parts) < 4 or not parts[-1].casefold().startswith("0x"):
            print(f"Invalid offset format '{new_label}', skipping")
            continue
        replacement = f"{'_'.join(parts[2:-1]).rstrip('_')}+${parts[-1][2:]}"
        matches = document.definition_indices(label)
        if len(matches) == 1 and ";" not in document.get_line(matches[0]):
            document.delete_line(matches[0])
        else:
            print(
                f"Cannot safely delete definition '{label}'; "
                "skipping offset replacement"
            )
            continue
        document.replace_symbol(label, replacement)
        print(f"Replaced '{label}' references with '{replacement}'")
    lines = document.materialize()
    timings.append(("delete/offset indexed", perf_counter() - phase_started))

    phase_started = perf_counter()
    lines, _ = apply_fix_label_rules(lines, fix_label_rules)
    lines = apply_source_notes(lines, source_notes, continue_on_error=True)
    timings.append(("fix labels/source notes", perf_counter() - phase_started))

    phase_started = perf_counter()
    normal_rows = [
        (label, new_label)
        for label, new_label in rows
        if not new_label.casefold().startswith(("_delete", "_offset_"))
    ]
    document = AsmDocument(
        lines, tracked_symbols={label for label, _ in normal_rows}
    )
    for label, new_label in normal_rows:
        if not document.definition_indices(label):
            print(f"Label '{label}' not found, skipping")
            continue
        document.replace_symbol(label, new_label)
        print(f"Relabeled '{label}' to '{new_label}'")
    lines = document.materialize()
    timings.append(("ordinary relabel indexed", perf_counter() - phase_started))

    phase_started = perf_counter()
    label_relabels = {label: new_label for label, new_label in normal_rows}
    definitions = casefold_definition_index(lines)
    label_lookup = lambda label: definitions.get(label.casefold(), ())
    source_rule_metrics = SourceRuleMetrics()
    lines = apply_source_rules_indexed(
        lines,
        equates,
        source_rules,
        label_relabels=label_relabels,
        continue_on_error=True,
        label_lookup=label_lookup,
        metrics=source_rule_metrics,
    )
    _print_source_rule_metrics(source_rule_metrics)
    lines = insert_generated_equates(lines, equates)
    timings.append(("source rules/equates", perf_counter() - phase_started))

    phase_started = perf_counter()
    definitions = casefold_definition_index(lines)
    label_lookup = lambda label: definitions.get(label.casefold(), ())
    lines = apply_source_comments(lines, frame, label_lookup=label_lookup)
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
    output.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Saved indexed relabeled ASM to '{output}'")
    timings.append(("comments/final", perf_counter() - phase_started))
    _print_timings(timings, perf_counter() - total_started)
    return output
