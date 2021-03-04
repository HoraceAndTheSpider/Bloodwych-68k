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

The nature of re-sourcing has produced some minor differences in the compiled code (particularly on BEXT) which are slowly being rectified as part of this project. However, a functioning compile is possible for bothe Bloodwych and the Entended Levels. 

 
**Tools Used**

ReSource (Code Extraction) 
Action Replay III (Memory Debugger)
AMOS Professional (Data/Graphics Extraction) 
DevPac 3.18 (Compiling)
FS-UAE Amiga Emulator (Running the above and Testing)

**Further Information**

The Wiki section of this Project documents the findings of all investigations of the Bloodwych Data formats and when possibly refers back directly to the source code included.
