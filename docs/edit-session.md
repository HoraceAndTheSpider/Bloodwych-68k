# Shared editing session

The launcher owns one in-memory session. Data Viewer, Map Viewer / Editor and
Interface Viewer / Editor all read its resources. Returning to the launcher
and opening another viewer retains edits without an intervening export.
Starting a separate CLI process starts a separate session.

Use **DATA / FILES** in any viewer, or **Binaries / Saves / Data** on the launcher.

| Action | Behaviour |
| --- | --- |
| RESET | Restore resources from the original SPS 439 binary; reread the selected save if there is one. Previously exported files stay on disk. |
| RELOAD | Restore the section named in **RELOAD SCOPE** from that baseline. Disabled from the front menu. Map sections restore the selected tower's map, objects, packed monsters, counts, switches and triggers; the champion-owning tower also restores champion stats and pockets. Monster design mode restores its shared design/grade resources instead. |
| EXPORT | After confirmation, write the entire session's changed resources to its `-modified` folder, with an exact-snapshot manifest. Earlier exports there may be replaced. Does not patch an executable or the supplied save. |
| PATCH | Validate every changed resource and write a separate modified executable or save copy. Disabled for oversized resources or unmapped imports. Save output requires an in-app confirmation. Existing outputs get a numbered successor rather than being overwritten. |
| IMPORT | Read a resource folder or a compatible modified executable into memory. With an empty path field, read the current project's `-modified` folder. |

The action-help card is always visible. Hovering a button explains its effect,
including why it is disabled; after a click, its help remains visible alongside
a separate status/confirmation message. RESET, RELOAD, EXPORT, IMPORT, loading a
file and switching Save Data require a second click on the same control.

**Extract Binary Data** on the front menu reads configured resources from a
binary into its clean extraction. It is different from **EXPORT**, which only
writes the current session's changed resources and resume metadata.

**Loaded input** identifies the file currently in use. Loading another binary
changes **Export folder** to that binary's own `-modified` directory: for example,
loading `BookOfSkulls_P_Beta5` selects `data/BookOfSkulls_P_Beta5-modified/`.
Existing exports stay where they are and are not automatically imported.
Loading a save or importing resource blocks keeps the current export folder.
**Import source** is a pending file/folder selection, not the loaded
input: select a row, then confirm **LOAD BINARY** or **LOAD SAVE** to use it.
The front-page profile/input status follows the active session too.
Use the up/down arrows beside the list or the mouse wheel to browse binaries
and saves. An arrow is disabled when there are no more files in its direction.

**Save Data: ON/OFF** switches between the loaded save overlay and the binary's
data. Load a save once to enable this toggle. Switching OFF discards in-memory
edits; switching ON rereads the last selected save, also discarding in-memory
edits. Export first to retain them. Neither switch writes to disk. **PATCH**
creates a separate save copy under `-modified/whdload/`; it never patches the
supplied save in place.

The old independent artwork/data overlay toggles are removed. Importing a
modified resource changes the data used by every viewer, including graphics
used by the map preview. The map editor's existing save shortcuts now mean
**EXPORT ALL**. Export before quitting the application; edits are not autosaved.

`--modified` is an explicit startup import. A legacy folder without a manifest
uses a file-by-file overlay. Unmapped files under resource directories block
export and patch rather than silently disappearing. A new export includes
`.edit-session.json`; subsequent imports use exactly the listed files, so stale
files from an older export cannot resurrect reverted changes. SHA-256 checks
reject an incomplete or externally changed snapshot before modifying memory.
To import externally edited loose blocks, use a separate resource folder
without a session manifest.

For save sessions, `.edit-save-state.bin` preserves runtime state that is not
represented by extracted resources. For imported executables,
`.edit-binary-state.bin` preserves unmapped executable changes. These are session
snapshot inputs, not extra editable copies. Resource files remain authoritative
for the mapped blocks. Export snapshots are tied to the original binary and,
when applicable, the original selected save's digest.

## Binary recognition and compatibility

BookOfSkulls is no longer a configured game family. The supported reference
families are `BLOODWYCH439`, `BLOODWYCH102`, `BLOODWYCH1927`, `BEXT43` and
`AtariST_DEMO_CODE`. Reference digests identify exact inputs even when renamed.
Edited inputs are compared at their original code positions, excluding
spreadsheet-defined resource bytes. A distinguishing-byte check prevents the
very similar 1927 reference from being accepted as 439 on similarity alone.
Ambiguous inputs are rejected.

Family identification and resource-layout compatibility are separate results.
The 439 fixed layout requires identical file/container size and identical
unmapped bytes, except seven source-verified crystal-action X/Y immediates.
Those instructions are located using their original ASM byte evidence, not
hard-coded binary offsets. Coordinate changes do not relocate resources.
Changed code, shifted data, and unknown layouts are rejected for import and
patching, even when the file is recognisable as based on 439.

The supplied BookOfSkulls executable passes these checks. The larger
NewBookOfSkulls executable is identified as based on 439 but is **not** assigned
the original resource layout: its additional data/code needs a mapped layout
and relocation/source-build support. Its extra grades are not silently truncated.

Examples:

```text
python main.py identify binaries/BookOfSkulls_P_Beta5
python main.py --master /path/to/an-edited-binary graphics
python main.py files
```

The catalogue lists local binaries and WHDLoad saves. Unmapped binaries appear
in red with an **UNMAPPED** label. Selecting one reports its family and missing
layout support, with LOAD BINARY disabled. External inputs with
colliding filenames get distinct data directory names. Extraction checks every
range and existing destination before writing; it cannot replace a differing
clean file. No viewer writes into a clean extraction or original executable.

## Save scope and future play testing

Only SPS 439 save layouts are supported. The portable save is `$1600 * 9` bytes,
as written by the original AMOS editor, and uses the 439 current-tower field.
The supplied Extended Levels saves are rejected. Raw saves have no reliable
universal variant signature: the checks do not claim to identify every possible
edited save. Do not select saves from an unmapped game variant.

Mapped blocks use spreadsheet addresses relative to `champions.stats`.
Unrecognised runtime bytes are preserved. Map sections already absent or invalid
in a save retain their read-only baseline preview. Shared artwork, switches and
triggers outside the save cannot be written into it. If another editor changes
such a resource, export it for a binary project; PATCH explains the incompatibility.

`EditSession.fork()` supplies independent mutable state for a future play-test
bubble and explicitly forbids export/patch from that bubble. No movement,
door/key simulation, stairs/pits, pickup/use, or fast-kill mode is added here.
ADF save extraction and the other game variants' resource layouts remain outside
the implemented scope.
