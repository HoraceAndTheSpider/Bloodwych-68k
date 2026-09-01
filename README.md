# Bloodwych-68k
Re-sourcing of the Amiga RPG Bloodwych

This project is an attempt to rebuild the source code of the classic Amiga and Atari ST RPG "Bloodwych" by Anthony Taglioni and Pete James.

This fondly remembered game bought a lot of joy to its fans, in no small part due to its multiplayer gameplay, and it's the intention of this project to help those fans rekindle their love for the game.


By producing this Reverse Engineered code, it might be used for new maps, an enhanced version, or remakes or ports for modern platforms. 

The main code has been produced using the Amiga ReSource software and at its rawest compiles back to its original form. For both Bloodwych (BW) and the Extended Levels (BEXT) there are three versions of the Source Code included:
Although the original ReSource (.rs) files are included here, the source has had manual fixes applied to it since, and further changes to assist the readability of the code are stored via an included Excel spreadsheet, 

- BW_###.asm / BEXT_###.asm 
- BW_###_relabelled.asm / BEXT_###_relabelled.asm 
- BW_###_relabelled_data.asm / BEXT_###_relabelled_data.asm 

The first source is based on the original ReSeoure with manual labelling and adjustments made.
The second source (marked "relabelled") has had additional labels added to it through Excel VBA macros
The final source (marked "data") also replaces a large number of data blocks (e.g. graphics and maps) with external files. 


**Compiling**

The source code can be compiled using DevPac 3.18 on the Amiga, or a suitable emulator such as FS-UAE. There are no additional dependencies other than the files in this archive.

By default, DevPac will have enabled "Line Debug" and "Debug Symbols" in its Compiling Optioms (Settings: Assembler : Control) and these should be set to "None"

The nature of re-sourcing has produced some minor differences in the compiled code (particularly on BEXT) which are slowly being rectified as part of this project. However, a functioning compile is possible for both Bloodwych and the Extended Levels. 

 
**Tools Used**

ReSource (Code Extraction) 
Action Replay III (Memory Debugger)
AMOS Professional (Data/Graphics Extraction) 
DevPac 3.18 (Compiling)
FS-UAE Amiga Emulator (Running the above and Testing)

**Further Information**

The Wiki section of this Project documents the findings of all investigations of the Bloodwych Data formats and when possibly refers back directly to the source code included.

## SuperApp foundation

The root `main.py` and reusable modules in `tools/` form the initial foundation
for a unified extraction, editing, graphics, source, and build application.
They use the repository itself as the project workspace:

```text
segments.xlsx                 binary regions and source labels
asm/                          original, relabelled, and data-linked 68k source
binaries/                     supported original executables and build outputs
data/<binary>-clean/          extracted source data
data/<binary>-modified/       edited fixed-size replacement blocks
tools/                        reusable Python and graphics conversion code
whdload/                      save data and WHDLoad support
```

The supported reference binary families are:

```text
BLOODWYCH439
BLOODWYCH102
BLOODWYCH1927
BEXT43
AtariST_DEMO_CODE
```

`BLOODWYCH439` has the complete Python extraction profile. Edited binaries,
including BookOfSkulls, are identified by their contents rather than a special
profile entry. Recognition does not imply a compatible resource layout: the
larger NewBookOfSkulls is recognised as based on 439 but requires relocation and
layout support before import or patching. See [shared editing sessions](docs/edit-session.md).

### Python commands

```text
python main.py
python main.py profiles
python main.py paths
python main.py graphics
python main.py maps
python main.py interface
python main.py maps --savegame whdload/bloodsave0
python main.py --master BLOODWYCH439 extract
python main.py --master BLOODWYCH439 inspect
python main.py --master BLOODWYCH439 relabel
python main.py --master BLOODWYCH439 patch
```

A bare `python main.py` launch opens the Pygame command chooser. Supplying a
data-processing subcommand bypasses the launcher, which keeps the same core
tools usable in terminals, tests, build workers, and the future web
application. The `graphics` subcommand opens the Pygame data viewer directly.
The `maps` subcommand opens the map workspace; its optional `--savegame`
argument reads the maps and other later resources from a WHDLoad save overlay.
The `interface` subcommand opens the source-led Interface Viewer / Editor with
dialogue-text colour-ramp editing and hitbox overlays. The graphical launcher groups
source/data operations in its left column and viewers/editors in its right
column.
All viewers share a live session while the launcher is open. **DATA / FILES**
provides RESET, section RELOAD, whole-session EXPORT, validated PATCH and IMPORT,
plus a binary/save catalogue. Modified data is imported explicitly; there is no
separate artwork overlay state. Exports go to `-modified`; patching writes a
separate executable or save copy and never overwrites an input. Export before
quitting: sessions are held in memory. See [the action semantics and limits](docs/edit-session.md).

**Define Joypad Buttons** on the launcher, or **JOYPAD (F8)** in a viewer,
opens device-specific controller setup. It opens automatically for a connected
device without a matching layout. Define six movement controls and optional
pointer, fire and three panel actions; movement works across all five map modes,
and the configured pointer is visible on the front menu and other screens. See
[joypad setup and layout files](docs/joypad-controls.md).
On macOS, use the project environment (`.venv/bin/python main.py`) with the
`pygame-ce` dependency from `requirements.txt`; an older global Pygame/SDL can
miss Bluetooth gamepads that macOS itself can see.

The graphics tools can losslessly convert the 128-glyph `GameFont` and Atari
ST-style four-plane graphics with extracted `.offsets` and `.positions`
metadata. See `docs/gamefont-and-st-graphics.md` for the currently understood
formats and round-trip guarantees.

The launcher now includes a graphical viewer for monster types `$64` upwards.
It renders the complete Beholder data live and reports missing companion
metadata for the other extracted monster graphics. Its overhead navigator
uses the original 19-cell view cone and mini-space position tables, so choosing
a square resolves the same image slot and screen anchor as the 68k renderer.

The extracted avatar and Beholder data can also be exported and verified over
the native 128 x 76 floor/ceiling window with:

```text
python tools/graphics_preview.py outputs/graphics-preview --scale 4
```

This also exports exact indexed component PNGs, red-border drawing guides, and
JSON metadata for template editing and the future re-import stage.

The optional `data_action` column in `segments.xlsx` can now split one
contiguous ASM data region into several labelled INCBIN files without
hard-coded Python ranges. See `docs/resource-layouts.md` for the
`data_start`, `data_append`, and `extract_only` conventions and validation
rules.
