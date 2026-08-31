"""Write a fixed-size output using the same preflight as the shared session."""
from __future__ import annotations

from pathlib import Path

from .edit_session import EditSession
from .tool_common import ToolError


def patch_segments(
    master: str,
    sheet: str | Path,
    name_filter: str | None = None,
    debug: bool = False,
) -> Path:
    session = EditSession(master, sheet=Path(sheet))
    session.import_modified()
    if name_filter:
        selected = next((name for name in session.specs if name.casefold() == name_filter.casefold()), None)
        if selected is None or selected not in session.changed_resources:
            raise ToolError(f"No modified segment named '{name_filter}' was found")
        # Filtering is explicit; all remaining output bytes come from the
        # selected input binary, including its unmapped executable edits.
        data = session.read(selected)
        session.changes.clear()
        session.write(selected, data)
    if debug:
        for name in session.changed_resources:
            print(f"Validated '{name}'")
    destination = session.patch()
    print(f"Patched {len(session.changed_resources)} resource(s) into {destination}")
    return destination
