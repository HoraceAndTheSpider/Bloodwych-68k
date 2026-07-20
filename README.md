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

The configured executable names currently present in the repository are:

```text
BLOODWYCH439
BLOODWYCH102
BLOODWYCH1927
BEXT43
AtariST_DEMO_CODE
```

Only `BLOODWYCH439` currently has a segment worksheet and complete Python
extraction profile. The other executables are recognised explicitly so their
profiles can be added without changing the directory contract.

### Python commands

```text
python main.py
python main.py profiles
python main.py paths
python main.py --master BLOODWYCH439 extract
python main.py --master BLOODWYCH439 inspect
python main.py --master BLOODWYCH439 relabel
python main.py --master BLOODWYCH439 patch
```

A bare `python main.py` launch opens the Pygame command chooser. Supplying an
explicit subcommand bypasses Pygame, which keeps the same core tools usable in
terminals, tests, build workers, and the future web application.

The graphics tools can losslessly convert the 128-glyph `GameFont` and Atari
ST-style four-plane graphics with extracted `.offsets` and `.positions`
metadata. See `docs/gamefont-and-st-graphics.md` for the currently understood
formats and round-trip guarantees.
