
	INCLUDE	"Bloodwych439_equates.asm"

****************************************************************************

; Fixed for Devpac:
;	SECTION	BW_002rs000000,CODE,CHIP
	SECTION	BW_002rs000000,CODE_C
ProgStart:
; Resource's Origin set to $03A4 ($04000 - $005C)
; Positions offset $005C at $0400 which is where the
; game code starts.
; Allows Resource to recognise the absolute addresses.
;  
	ORG		$03A4
;  
	move.w	#$7FFF,_custom+intena.l
	move.w	#$7FFF,_custom+intreq.l
;  
; Copies 40 bytes of code starting at CodeMover to $00000090
;  
	lea		CodeMover(pc),a0
	lea		$00000090.l,a1
	moveq	#$28,d0
.loop:
	move.b	(a0)+,(a1)+
	dbra	d0,.loop
;  
; Cache the game code start address in A6
;  
	lea		GameStart(pc),a6
;  
; Put the address of the moved code into the trap vector
;  
	move.l	#$00000090,tv_TrapInstrVects.l
;  
; Trigger the trap...
;  
	trap	#$00
;  
; This gets executed for trap #$00.
; On entry, A6 holds the address of GameStart when the code was loaded.
; Now gets relocated to $0400.
;  
CodeMover:
	move.l	#$0005909C,d0
	move.w	#$7FFF,_custom+intreq.l
	lea		GameStart.l,a0
.loop:
	move.b	(a6)+,(a0)+
	subq.l	#$01,d0
	bcc.s	.loop
	move.w	#$7FFF,_custom+intreq.l
;  
; The code is now in its proper place.
; So just jump on in.  All labels will now reslve to their
; correct absolute addresses.
;  
	jmp		GameStart.l

;fiX Label expected
	dc.w	$0000	;0000

GameStart:
	move.w	#$7FFF,_custom+intena.l
	move.w	#$7FFF,_custom+intreq.l
	lea		$0005FFFC.l,sp
	clr.b	InputProcessingEnabledFlag.l
	bsr		Init_CustomChipRegisters
	clr.b	TextDoubleWidthFlag.l
	clr.w	FrameSyncFlag.l
	bsr		Init_BitReverseTableAndSpellPracticeData
	bsr		MainMenu
	jsr		Clear_DisplayBuffer.l
	jsr		Clear_DrawBuffer.l
	moveq	#Sound_SwitchClick,d0												;Selects the initial switch or interface click sound.
	jsr		PlaySound.l
	tst.w	MainMenuBuffer.l
	bmi.s	Start_GameAfterMainMenu
	beq.s	Apply_ChampionSelectionAndStartGame
	bra		InitialiseActivePlayerData

Apply_ChampionSelectionAndStartGame:		; Memory Address ($0456) and binary offset [$00D2]
	; Copies the selected champion state into both player records before entering
	; game setup.
	jsr		ChampionSelection_Main.l
	move.b	Player1_ChampionCount_PendingCommit.l,Player1_ChampionCount.l
	move.b	Player2_ChampionCount.l,Player2_ChampionPointer.l
	move.l	Player1_ChampionCount.l,Player1_ChampionPointer.l
	move.l	Player2_ChampionPointer.l,Player2_ChampionRosterShadowCopy.l
	moveq	#$0F,d0
DBFWait1a:		; Memory Address ($0486) and binary offset [$0102]
	dbra	d1,DBFWait1a
	dbra	d0,DBFWait1a
Start_GameAfterMainMenu:		; Memory Address ($048E) and binary offset [$010A]
	; Transfers control from the main-menu result to the common game-start path.
	bra		InitialiseNewGameSession

Init_CustomChipRegisters:		; Memory Address ($0492) and binary offset [$010E]
	; Programs the game palette and display-window, bitplane, Copper-list, and
	; hardware-sprite state during display initialisation.
	jsr		Load_GamePaletteIntoColourRegisters.l
	move.w	#$4200,_custom+bplcon0.l
	move.w	#$0000,_custom+bplcon1.l
	move.w	#$0024,_custom+bplcon2.l
	move.w	#$0000,_custom+bpl1mod.l
	move.w	#$0000,_custom+bpl2mod.l
	move.w	#$0038,_custom+ddfstrt.l
	move.w	#$00D0,_custom+ddfstop.l
	move.w	#$3781,_custom+diwstrt.l
	move.w	#$FFC1,_custom+diwstop.l
	move.l	#CopperList_00,_custom+cop1lc.l
	move.l	#$00060000,screen_ptr.l
	jsr		Update_CopperBitplanePointersForOppositeScreenBuffer.l
	lea		CopperList_01.l,a0
	lea		Copper_SpriteOffsetTable.l,a1
	lea		Sprite_PositionPointerTable.l,a2
	moveq	#$07,d1
Initialise_CopperSpritePointersLoop:		; Memory Address ($050E) and binary offset [$018A]
	; Writes eight sprite pointer pairs into the Copper list.
	moveq	#$00,d0
	move.b	$00(a1,d1.w),d0
	add.w	d0,d0
	add.w	d0,d0
	move.l	$00(a2,d0.w),d0
	move.w	d0,$0006(a0)
	swap	d0
	move.w	d0,$0002(a0)
	addq.w	#$08,a0
	dbra	d1,Initialise_CopperSpritePointersLoop
	move.l	#adrL_008CC8,d0
	lea		$0060.w,a0															;Short Absolute replaced by symbol!
	moveq	#$07,d1
Initialise_InterruptVectorsLoop:		; Memory Address ($0538) and binary offset [$01B4]
	; Initialises the eight autovector entries before installing the game handlers.
	move.l	d0,(a0)+
	dbra	d1,Initialise_InterruptVectorsLoop
	move.l	#VerticalBlankInterupt,$006C.w										;Short Absolute converted to symbol!
	move.l	#Level_2_Interrupt,$0068.w											;Short Absolute converted to symbol!
	move.l	#adrL_0088A4,$0070.w												;Short Absolute converted to symbol!
	move.w	#$7FFF,_custom+intena.l
	move.b	_ciaa+ciacra.l,d0
	move.b	#$21,_ciaa+ciacra.l
	move.b	#$7F,_ciaa+ciaicr.l
	move.b	_ciaa+ciaicr.l,d0
	move.b	#$88,_ciaa+ciaicr.l
	move.w	_custom+copjmp1.l,d0
	move.w	#$7FFF,_custom+dmacon.l
	move.w	#$83A0,_custom+dmacon.l
	move.w	#$7FFF,_custom+intreq.l
	move.w	#$C038,_custom+intena.l
	rts		

Copper_SpriteOffsetTable:		; Memory Address ($05AA) and binary offset [$0226]
	; Per-sprite offsets used while initialising Copper sprite-pointer words.
	dc.w	$0404	;0404
	dc.w	$0403	;0403
	dc.w	$0402	;0402
	dc.w	$0100	;0100
Sprite_PositionPointerTable:		; Memory Address ($05B2) and binary offset [$022E]
	; Pointers to the hardware sprite-position records installed into the Copper
	; list.
	dc.l	SpritePosition_00	;00008E84
	dc.l	SpritePosition_01	;00008F14
	dc.l	SpritePosition_04	;00008ECC
	dc.l	SpritePosition_02	;00008F5C
	dc.l	SpritePosition_03	;00008EC8
	dc.w	$0000	;0000
Level2Int_LastKeyScratch:		; Memory Address ($05C8) and binary offset [$0244]
	; Scratch byte holding the raw key code captured by the level-two keyboard
	; interrupt.
	ds.b	$1
KeyboardKeyCode:		; Memory Address ($05C9) and binary offset [$0245]
	ds.b	$5
Level_2_Interrupt:		; Memory Address ($05CE) and binary offset [$024A]
	movem.l	d0/d1/a0,-(sp)
	lea		_ciaa.l,a0
	move.b	$0C00(a0),d0
	ror.b	#$01,d0
	not.b	d0
	move.b	d0,KeyboardKeyCode.w												;Short Absolute converted to symbol!
	or.b	#$40,$0E00(a0)
	clr.b	$0C00(a0)
	move.b	$0100(a0),d1
	bsr.s	CheckKeyboard
	moveq	#$2D,d0
.L2InteruptLoop:		; Memory Address ($05F6) and binary offset [$0272]
	dbra	d0,.L2InteruptLoop
	lea		_ciaa.l,a0
	move.b	$0D00(a0),d0
	and.b	#$BF,$0E00(a0)
	move.b	d0,Level2Int_LastKeyScratch.w										;Short Absolute converted to symbol!
	movem.l	(sp)+,d0/d1/a0
	move.w	#$0008,_custom+intreq.l
	rte		

CheckKeyboard:		; Memory Address ($061C) and binary offset [$0298]
	; Scans the 12-entry raw-key table for the keyboard interrupt's input code and
	; dispatches the matching keyboard action; unmatched keys are ignored.
	lea		RawKeyCodes.l,a0
	moveq	#$0B,d1
.keyboardloop:		; Memory Address ($0624) and binary offset [$02A0]
	cmp.b	(a0)+,d0
	beq.s	KeyboardAction
	dbra	d1,.keyboardloop
	rts		

KeyboardAction:		; Memory Address ($062E) and binary offset [$02AA]
	lea		Player1_Data.l,a0
	subq.w	#$06,d1
	bcc.s	KeyboardAction_StorePendingAction
	addq.w	#$06,d1
	lea		Player2_Data.l,a0
KeyboardAction_StorePendingAction:		; Memory Address ($0640) and binary offset [$02BC]
	add.w	#InterfaceAction_MoveForward,d1										;Base dungeon action added to the raw-key index so keyboard movement begins with Move Forward.
	move.b	d1,PlayerData_PendingAction(a0)										;Offset of the pending action byte written by keyboard input.
	rts		

RawKeyCodes:
	dc.b	$5F	;5F
	dc.b	$46	;46
	dc.b	$4E	;4E
	dc.b	$4F	;4F
	dc.b	$4D	;4D
	dc.b	$4C	;4C
	dc.b	$12	;12
	dc.b	$10	;10
	dc.b	$22	;22
	dc.b	$20	;20
	dc.b	$21	;21
	dc.b	$11	;11

MainMenuBuffer:
	ds.b	$2
MainMenuInitColours:		; Memory Address ($0658) and binary offset [$02D4]
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$FD	;FD
	dc.b	$00	;00
	dc.b	$F0	;F0
MainMenuText:		; Memory Address ($065D) and binary offset [$02D9]
	dc.b	$FE	;FE
	dc.b	$0C	;0C
	dc.b	$FC	;FC
	dc.b	$0F	;0F
	dc.b	$02	;02
	dc.b	'BLOODWYCH'
	dc.b	$FE	;FE
	dc.b	$06	;06
	dc.b	$FC	;FC
	dc.b	$04	;04
	dc.b	$06	;06
	dc.b	'F1   START ONE PLAYER GAME'
	dc.b	$FC	;FC
	dc.b	$04	;04
	dc.b	$08	;08
	dc.b	'F2   START TWO PLAYER GAME'
	dc.b	$FC	;FC
	dc.b	$04	;04
	dc.b	$0B	;0B
	dc.b	'F3   QUICKSTART ONE PLAYER GAME'
	dc.b	$FC	;FC
	dc.b	$04	;04
	dc.b	$0D	;0D
	dc.b	'F4   QUICKSTART TWO PLAYER GAME'
	dc.b	$FC	;FC
	dc.b	$04	;04
	dc.b	$10	;10
	dc.b	'F9   LOAD ONE PLAYER POSITION'
	dc.b	$FC	;FC
	dc.b	$04	;04
	dc.b	$12	;12
	dc.b	'F10  LOAD TWO PLAYER POSITION'
	dc.b	$FE	;FE
	dc.b	$03	;03
	dc.b	$FC	;FC
	dc.b	$0A	;0A
	dc.b	$18	;18
	dc.b	'(C) MIRRORSOFT 1989'

	; USED TO CHECK IF GAME IS RELOCATABLE
	; dc.b    'TEST'

	dc.b	$FE	;FE
	dc.b	$06	;06
	dc.b	$FF	;FF

	EVEN	
MainMenu:		; Memory Address ($0746) and binary offset [$03C2]
	; Draws the text title menu and dispatches its raw function-key choices for
	; normal start, Quickstart, and loading a saved game.
	clr.w	MainMenuBuffer.w													;Short Absolute converted to symbol!
	clr.w	MultiPlayer.l
	jsr		Clear_DisplayBuffer.l
	jsr		Clear_DrawBuffer.l
	lea		MainMenuText.w,a6													;Short Absolute converted to symbol!
	tst.w	MainMenuInitColours.w												;Short Absolute converted to symbol!
	bne.s	.menuscreen
	subq.w	#$03,a6
.menuscreen:		; Memory Address ($0768) and binary offset [$03E4]
	lea		Player1_Data.l,a5
	jsr		Print_fflim_text.l
	jsr		Swap_DisplayAndDrawBuffers.l
	tst.w	MainMenuInitColours.w												;Short Absolute converted to symbol!
	bne.s	MenuKeyboard
	move.w	#$FFFF,MainMenuInitColours.w										;Short Absolute converted to symbol!
	jsr		Select_FloppyDrive0.l
MenuKeyboard:
	clr.b	KeyboardKeyCode.w													;Short Absolute converted to symbol!
.menukeyboardloop:
	move.b	KeyboardKeyCode.w,d0												;Short Absolute converted to symbol!
	sub.b	#$50,d0
	beq		Ply1_Start
	subq.b	#$01,d0
	beq		Ply2_Start
	subq.b	#$01,d0
	beq		QkPly1_Start
	subq.b	#$01,d0
	beq		QkPly2_Start
	cmpi.b	#$06,d0
	beq.s	LoadGameFromMenu
	subq.b	#$05,d0
	bne.s	.menukeyboardloop
	move.w	#$FFFF,MultiPlayer.l
LoadGameFromMenu:
	move.l	#$00067D00,screen_ptr.l
	move.l	#$00060000,framebuffer_ptr.l
	jsr		Clear_DisplayBuffer.l
	move.l	screen_ptr.l,a0
	add.w	#$0E10,a0
	lea		Msg_InstertLoadDisk.l,a6
	jsr		Print_fflim_text.l
	jsr		Swap_DisplayAndDrawBuffers.l
	clr.b	KeyboardKeyCode.w													;Short Absolute converted to symbol!
	bsr		LoadSaveGame_Loop
	bcs		MainMenu
	bsr		LoadSaveGame_Action
	bsr		LoadGame_ReadChampionDataFromDisk
	cmp.b	#$FF,Character_Stats_DataTable+$11.l
	beq		MainMenu
	bsr		Select_CurrentTowerMapData
	move.w	#$0001,MainMenuBuffer.w												;Short Absolute converted to symbol!
	rts		

Ply1_Start:
	move.w	#$FFFF,MultiPlayer.l
	rts		

Ply2_Start:
	clr.w	MultiPlayer.l
	rts		

QkPly1_Start:
	; Initialises Player 1's fixed Quickstart party: forces single-player mode and
	; Quickstart menu state, writes champion IDs 0, 14, 5 and 3 into both party
	; arrays, sets champion 0's stored X, Y and direction, and marks champions 3, 5
	; and 14 with X=$FF so normal champion selection treats them as already placed.
	; QkPly2_Start calls this routine before initialising Player 2's fixed
	; Quickstart party.
	move.w	#$FFFF,MultiPlayer.l
	move.w	#$FFFF,MainMenuBuffer.w												;Short Absolute converted to symbol!
	move.l	#Quickstart_Player1ChampionRoster,PlayerData_ChampionSlotsOffset(a5)	;Initialises Player 1's four Quickstart champion slots in the authored party order 0, 14, 5, 3.
	move.l	PlayerData_ChampionSlotsOffset(a5),PlayerData_FormationSlotsOffset(a5)
	clr.w	PlayerData_CurrentChampionNumber(a5)
	lea		Character_Stats_DataTable.l,a0
	move.b	#$0C,ChampionStat_XPosition(a0)
	move.b	#$17,ChampionStat_YPosition(a0)
	clr.b	ChampionStat_Direction(a0)											;Sets the selected Quickstart lead champion's saved direction to North before its start position is transferred to the player record.
	moveq	#-$01,d0
	move.b	d0,ChampionIndex_Hengist*ChampionStat_RecordSize+ChampionStat_XPosition(a0)	;Sets Hengist's ChampionStat_XPosition to $FF so the Quickstart follower has no independent saved map position.
	move.b	d0,ChampionIndex_Zothen*ChampionStat_RecordSize+ChampionStat_XPosition(a0)	;Sets Zothen's ChampionStat_XPosition to $FF so the Quickstart follower has no independent saved map position.
	move.b	d0,ChampionIndex_Rosanne*ChampionStat_RecordSize+ChampionStat_XPosition(a0)	;Sets Rosanne's ChampionStat_XPosition to $FF so the Quickstart follower has no independent saved map position.
	rts		

QkPly2_Start:
	bsr.s	QkPly1_Start
	clr.w	MultiPlayer.l
	move.l	#Quickstart_Player2ChampionRoster,Player2_ChampionPointer.l			;Initialises Player 2's four Quickstart champion slots in the authored party order 4, 6, 13, 15.
	move.l	#Quickstart_Player2ChampionRoster,Player2_ChampionRosterShadowCopy.l
	move.w	#ChampionIndex_Astroth,Player2_CurrentChampionNumber.l
	lea		Character_Stats_DataTable+$80.l,a0
	move.b	#$0E,ChampionStat_XPosition(a0)
	move.b	#$17,ChampionStat_YPosition(a0)
	clr.b	ChampionStat_Direction(a0)
	moveq	#-$01,d0
	move.b	d0,(ChampionIndex_Baldrick-ChampionIndex_Astroth)*ChampionStat_RecordSize+ChampionStat_XPosition(a0)	;Sets Baldrick's ChampionStat_XPosition to $FF so the Quickstart follower has no independent saved map position.
	move.b	d0,(ChampionIndex_Zastaph-ChampionIndex_Astroth)*ChampionStat_RecordSize+ChampionStat_XPosition(a0)	;Sets Zastaph's ChampionStat_XPosition to $FF so the Quickstart follower has no independent saved map position.
	move.b	d0,(ChampionIndex_ThaiChang-ChampionIndex_Astroth)*ChampionStat_RecordSize+ChampionStat_XPosition(a0)	;Sets Thai Chang's ChampionStat_XPosition to $FF so the Quickstart follower has no independent saved map position.
	rts		

Init_BitReverseTableAndSpellPracticeData:		; Memory Address ($08C4) and binary offset [$0540]
	; Builds the 256-byte bit-reversal lookup and clears the 512-byte
	; spell-practice table for a new game.
	lea		BitReverse_LookupBuffer.l,a0
	move.w	#$00FF,d7
Build_BitReverseLookupLoop:		; Memory Address ($08CE) and binary offset [$054A]
	; Builds one reversed-bit output byte for each input byte value.
	move.w	d7,d0
	moveq	#$07,d6
Reverse_ByteBitsLoop:		; Memory Address ($08D2) and binary offset [$054E]
	; Shifts eight source bits into their reversed order.
	lsr.b	#$01,d0
	addx.b	d1,d1
	dbra	d6,Reverse_ByteBitsLoop
	move.b	d1,$00(a0,d7.w)
	dbra	d7,Build_BitReverseLookupLoop
	lea		Spells_Practiced_DataTable.l,a0
	moveq	#$7F,d0
Clear_SpellPracticeTableLoop:		; Memory Address ($08EA) and binary offset [$0566]
	; Clears the 512-byte spell-practice table after building the bit-reversal
	; lookup.
	clr.l	(a0)+
	dbra	d0,Clear_SpellPracticeTableLoop
	rts		

Initialize_SpellPracticeThresholds:		; Memory Address ($08F2) and binary offset [$056E]
	; Initialises calculated spell-practice values for all sixteen champion
	; records.
	moveq	#Champion_Count-1,d7
SpellPractice_ThresholdLoop:		; Memory Address ($08F4) and binary offset [$0570]
	move.w	d7,d0
	bsr		Calculate_SpellPracticeThreshold
	move.b	d0,ChampionStat_SpellPointsCurrent(a4)
	dbra	d7,SpellPractice_ThresholdLoop
	rts		

Calculate_SpellPracticeThreshold:		; Memory Address ($0904) and binary offset [$0580]
	; Calculates a champion's spell-practice threshold from Wizard-weighted level
	; and half Intelligence, clamped to $63.
	move.w	d0,d1
	bsr		Load_ChampionStatRecord
	bsr.s	Calculate_WizardLevelContribution
	asl.w	#$02,d0
	move.b	ChampionStat_Intelligence(a4),d1
	lsr.b	#$01,d1
	add.b	d1,d0
	cmpi.b	#$64,d0
	bcs.s	SpellPractice_StoreThreshold
	moveq	#$63,d0
SpellPractice_StoreThreshold:		; Memory Address ($091E) and binary offset [$059A]
	; Stores the calculated spell-practice threshold in the champion record.
	move.b	d0,ChampionStat_SpellPointsMaximum(a4)
	rts		

Calculate_WarriorLevelContribution:		; Memory Address ($0924) and binary offset [$05A0]
	; Calculates the Warrior-weighted contribution of a champion's level.
	and.w	#$0003,d1
	move.b	WarriorLevel_ChampionTypeShifts(pc,d1.w),d1
	bpl.s	Calculate_ShiftedChampionLevel
	moveq	#$00,d0
	OPT		O2+
	move.b	ChampionStat_Level(a4),d0
	OPT		O2-
	add.w	d0,d0
	OPT		O2+
	add.b	ChampionStat_Level(a4),d0
	OPT		O2-
	lsr.w	#$02,d0
	rts		

WarriorLevel_ChampionTypeShifts:		; Memory Address ($093A) and binary offset [$05B6]
	; Selects full, quarter or special three-quarter level weighting for each
	; champion type.
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$FF	;FF
	dc.b	$02	;02

Calculate_WizardLevelContribution:		; Memory Address ($093E) and binary offset [$05BA]
	; Calculates the Wizard-weighted contribution of a champion's level.
	and.w	#$0003,d1
	move.b	WizardLevel_ChampionTypeShifts(pc,d1.w),d1
	bra.s	Calculate_ShiftedChampionLevel

WizardLevel_ChampionTypeShifts:		; Memory Address ($0948) and binary offset [$05C4]
	; Selects quarter, full or half Wizard-level weighting for each champion type.
	dc.b	$02	;02
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02

Calculate_CutpurseLevelContribution:		; Memory Address ($094C) and binary offset [$05C8]
	; Calculates the Cutpurse-weighted contribution of a champion's level.
	and.w	#$0003,d1
	move.b	CutpurseLevel_ChampionTypeShifts(pc,d1.w),d1
Calculate_ShiftedChampionLevel:		; Memory Address ($0954) and binary offset [$05D0]
	; Loads the champion's level and applies the selected right-shift weighting.
	moveq	#$00,d0
	OPT		O2+
	move.b	ChampionStat_Level(a4),d0
	OPT		O2-
	lsr.w	d1,d0
	rts		

CutpurseLevel_ChampionTypeShifts:		; Memory Address ($095C) and binary offset [$05D8]
	; Selects quarter, half or full Cutpurse-level weighting for each champion
	; type.
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$00	;00

Mark_CurrentTowerTrapCells:		; Memory Address ($0960) and binary offset [$05DC]
	; Marks map cells referenced by the current tower’s trap list before monster
	; unpacking.
	moveq	#$00,d7
	moveq	#$00,d6
	move.l	Current_TowerMapDataBase.l,a6
	lea		Map_ResourceSize-Map_HeaderSize+ObjectData_LengthBytes(a6),a0		;Fixed map allocation; object records begin after this map and the two-byte object-length word.
Mark_CurrentTowerTrapCellsLoop:		; Memory Address ($096E) and binary offset [$05EA]
	; Iterates variable-length trap records and marks each referenced cell.
	cmp.w	-$0002(a0),d7
	bcc.s	Return_FromMarkCurrentTowerTrapCells
	move.b	$00(a0,d7.w),d0
	rol.w	#$08,d0
	move.b	$01(a0,d7.w),d0
	and.w	#ObjectStack_MapOffsetMask,d0										;Retains the 14-bit map-payload byte offset; bits 15-14 encode the object mini-space.
	bset	#MapCell_ObjectPresentBit,$01(a6,d0.w)								;Marks map cells that have a floor or shelf object stack.
	move.b	ObjectStack_CountMinusOneOffset(a0,d7.w),d6							;Loads the number of additional two-byte object/quantity pairs.
	add.w	d6,d6
	addq.w	#ObjectStack_MinimumBytes,d6										;Minimum record is location word, count-minus-one byte, and one object/quantity pair.
	add.w	d6,d7
	bra.s	Mark_CurrentTowerTrapCellsLoop

Return_FromMarkCurrentTowerTrapCells:		; Memory Address ($0994) and binary offset [$0610]
	; Returns after all current-tower trap cells have been marked.
	rts		

PrepareCharacters:
	; Initialises all sixteen champion-stat records for the current tower,
	; recalculates derived values, and marks placed champions on the working map.
	bsr		Select_CurrentTowerMapData											;Selects the current tower header and cell-data base before champion coordinates are converted to map cells.
	lea		Character_Stats_DataTable.l,a4										;Loads a4 with the base of the champion-stat table; all ChampionStat fields below are relative to this record.
	moveq	#Champion_Count-1,d6												;Initialises the reverse champion loop for all sixteen champion records; d6 counts down from the last slot.
PrepareCharacters_ChampionLoop:
	; Processes the sixteen champion records in table order.
	clr.b	ChampionStat_WornSpell(a4)											;Clears the champion's currently worn spell so no spell remains equipped at tower start.
	move.b	#$FF,ChampionStat_SpellToCast(a4)									;Sets the spell-to-cast field to $FF, meaning that no spell-casting request is pending.
	clr.b	ChampionStat_FairySpellCount(a4)									;Clears the fairy-spell purchase count so tower-start setup begins with no queued purchases.
	clr.b	ChampionStat_ActionState(a4)										;Clears the champion's physical-attack cooldown before play begins.
	move.b	#$FF,ChampionStat_XPToNextLevel(a4)									;Sets the experience threshold field to $FF, the start-of-game sentinel for experience-to-next-level handling.
	move.w	d6,d0																;Copies the reverse loop counter into d0 so the champion's logical table index can be calculated.
	eor.b	#Champion_Count-1,d0												;Reverses the countdown index, turning the backward loop position into the champion number expected by stat calculation.
	bsr		Recalculate_CharacterDerivedStats									;Recalculates derived champion statistics using the selected champion record and its logical index.
	move.b	ChampionStat_SpellPointsMaximum(a4),ChampionStat_SpellPointsCurrent(a4)	;Copies maximum spell points into current spell points, filling the starting spell-point reserve.
	moveq	#$00,d0																;Clears d0 before loading the champion's floor number for map-context selection.
	move.b	ChampionStat_Floor(a4),d0											;Loads the champion's tower-floor field into d0 for the floor/map lookup.
	jsr		Select_FloorMapByIndex.l											;Resolves the floor-specific map context used by subsequent coordinate-to-cell conversion.
	moveq	#$00,d7																;Clears d7, which will hold the champion's packed start coordinate.
	move.b	ChampionStat_XPosition(a4),d7										;Loads the champion's X coordinate into the low byte of d7 as the first half of the packed map position.
	bmi.s	.PrepareCharacters_NextChampion										;Skips map marking when the X coordinate is negative, the sentinel for a champion without a saved start position.
	swap	d7																	;Moves the staged X coordinate into the high word of d7 so the Y coordinate can occupy the low word.
	move.b	ChampionStat_YPosition(a4),d7										;Loads the champion's Y coordinate into the low byte of d7, completing the packed X/Y position.
	bsr		CoordToMap															;Converts the packed champion X/Y position into a current-map cell index in d0.
	bset	#$07,$01(a6,d0.w)													;Sets the occupied-by-champion bit in the selected map cell, preventing another placement from using it.
.PrepareCharacters_NextChampion:		; Memory Address ($09EE) and binary offset [$066A]
	; Advances to the next champion record after the optional map update.
	add.w	#ChampionStat_RecordSize,a4											;Advances a4 by one $20-byte champion record to reach the next champion's fields.
	dbra	d6,PrepareCharacters_ChampionLoop									;Repeats champion setup until the reverse champion counter has processed every record.
UnpackTowerMonsters:		; Memory Address ($09F6) and binary offset [$0672]
	; Clears transient state and expands the current tower’s packed monster records
	; into live records.
	bsr		Mark_CurrentTowerTrapCells											;Initialises the trap-processing state before monster placement changes the current tower map.
	lea		MonsterTeamIndexTable.l,a4											;Loads a4 with the monster team-index table, whose entries point from team slots to live monster records.
	moveq	#-$01,d6															;Creates the $FF empty/sentinel value used to clear team data and mark missing entries.
	move.w	d6,MonsterTeamIndexTable_CountOffset(a4)							;Sets the last team-row index to $FFFF: no teams yet.
	moveq	#MonsterTeamIndexTable_LongwordCount-1,d0							;Sets the team-table clearing loop to cover all twenty-five four-member team records.
.ClearMonsterTeamIndexLoop:		; Memory Address ($0A08) and binary offset [$0684]
	; Clears the twenty-five four-member team slots.
	move.l	d6,(a4)+															;Writes the empty sentinel into the current team-table longword and advances to the next slot.
	dbra	d0,.ClearMonsterTeamIndexLoop										;Clears every team-table longword before rebuilding team membership from packed monster data.
	lea		UnpackedMonsters.l,a4												;Loads a4 with the base of the live, unpacked monster-record workspace.
	move.w	#LiveActorRecord_WorkspaceLongwordCount-1,d0						;Sets the clearing loop to cover 512 longwords, the full $800-byte live-monster workspace.
.ClearLiveMonsterRecordsLoop:
	; Clears the live-monster workspace before unpacking.
	move.l	d6,(a4)+															;Fills the current live-monster longword with the empty sentinel and advances through the workspace.
	dbra	d0,.ClearLiveMonsterRecordsLoop										;Clears all live monster records before unpacking the selected tower's packed records.
	move.w	CurrentTower.l,d0													;Reads the selected tower number into d0 to choose its monster count and packed block.
	move.w	d0,d1																;Copies the tower number to d1 because d0 will be reused to form a table offset.
	add.w	d0,d0																;Doubles the tower number to address the word-sized monster-count entry for that tower.
	lea		MonsterTotalsCounts_mod0.l,a4										;Loads the table of per-tower monster totals.
	move.w	$00(a4,d0.w),d6														;Reads this tower's last packed-record index for the DBRA loop.
	lea		UnpackedMonsters.l,a4												;Restores a4 to the live-monster base so the count and records use the same workspace.
	move.w	d6,LiveActorRecord_CountOffset(a4)									;Stores the last live-record index at offset -2; $FFFF means none.
	bmi		Trigger_00_t00_Null													;Exits through the null-trigger path when this tower contains no monsters.
	add.w	d1,d0																;Forms three times the tower index before multiplying by $100.
	asl.w	#PackedMonster_TowerBlockShift,d0									;Produces tower * $300, the byte offset of its packed block.
	lea		MonsterBlock_mod0.l,a3												;Loads a3 with the base of the packed monster-block table.
	add.w	d0,a3																;Moves a3 to the selected tower's packed six-byte monster records.
	moveq	#$00,d4																;Initialises d4 as the zero-based packed/live monster ordinal used in team-table entries.
UnpackNextMonsterRecord:
	; Expands one packed six-byte monster record into a sixteen-byte live record.
	clr.b	ActorRecord_ActionState(a4)											;Clears the live action/status byte before copying data into this monster record.
	clr.b	ActorRecord_RotationAndSpace(a4)									;Clears the live rotation/occupied-space byte because it is rebuilt later by movement logic.
	move.b	(a3)+,d0															;Reads the packed type-and-floor byte and advances a3 to the packed X coordinate.
	subq.b	#PackedMonster_FloorEncodingBias,d0									;Removes the packed floor encoding bias before splitting type and floor.
	move.b	d0,d1																;Copies the adjusted packed byte into d1 so its high nibble can be extracted without losing the floor nibble.
	lsr.b	#PackedMonster_TypeShift,d1											;Shifts the packed high nibble down to produce the monster type code.
	move.b	d1,ActorRecord_BehaviourType(a4)									;Stores the decoded monster type in the live record's type field.
	and.w	#PackedMonster_NibbleMask,d0										;Masks off the high nibble, retaining the packed floor number in d0.
	move.b	d0,ActorRecord_Floor(a4)											;Stores the decoded floor number in the live monster record.
	bsr		Select_FloorMapByIndex												;Selects the floor-specific map context used for this monster's coordinate conversion.
	moveq	#$00,d7																;Clears d7 before assembling the packed live X/Y coordinate.
	move.b	(a3)+,d7															;Reads the packed X byte into the high-byte staging register d7 and advances to packed Y.
	move.b	d7,ActorRecord_XPosition(a4)										;Stores the decoded X coordinate in the live monster record.
	swap	d7																	;Swaps d7 so the staged X coordinate occupies the high word while Y is appended below it.
	move.b	(a3)+,d7															;Reads the packed X byte into the high-byte staging register d7 and advances to packed Y.
	move.b	d7,ActorRecord_YPosition(a4)										;Stores the decoded Y coordinate in the live monster record.
	btst	#$17,d7																;Tests X bit 7; set means no separate map-cell occupancy mark.
	bne.s	.MonsterPositionHandled												;Skips map occupancy marking when this monster has no valid starting position.
	bsr		CoordToMap															;Converts the decoded monster X/Y coordinate into a map-cell index.
	bset	#$07,$01(a6,d0.w)													;Sets the occupied-by-monster bit in the corresponding current-map cell.
.MonsterPositionHandled:		; Memory Address ($0A8E) and binary offset [$070A]
	; Continues after packed-coordinate map handling.
	moveq	#$00,d0																;Clears d0 before reading the packed monster level.
	move.b	(a3)+,d0															;Reads the packed level byte and advances a3 to the packed monster form.
	move.b	d0,MonsterRecord_BaseLevel(a4)										;Stores the level used by the monster's current behaviour and hit-point calculations.
	move.b	d0,MonsterRecord_EffectiveLevel(a4)									;Stores the original unpacked level as the monster's base level for later progression.
	moveq	#$0E,d1																;Loads 14 as the starting value for the level-derived action-countdown calculation.
	sub.b	d0,d1																;Subtracts the monster level from the countdown base; d1 becomes the encoded action delay.
	bcs.s	.UseMinimumActionCountdown											;Uses the minimum-delay path when the subtraction underflows or produces a value below the supported range.
	cmpi.b	#$08,d1																;Checks whether the calculated delay has reached the minimum supported countdown value.
	bcc.s	.StoreActionCountdown												;Keeps the calculated delay when it is at least the minimum and branches to its common storage path.
.UseMinimumActionCountdown:		; Memory Address ($0AA6) and binary offset [$0722]
	; Uses the minimum encoded action countdown.
	moveq	#$08,d1																;Loads the minimum action-countdown level used for high-level monsters.
.StoreActionCountdown:		; Memory Address ($0AA8) and binary offset [$0724]
	; Stores the level-derived action countdown.
	asl.b	#$04,d1																;Shifts the delay into the high nibble used by the live action-countdown field.
	move.b	d1,MonsterRecord_ActionCycleTimer(a4)								;Stores the level-derived action countdown in the live monster record.
	move.w	#$0190,d1															;Loads the default high-level hit-point multiplier into d1.
	cmpi.b	#$19,d0																;Checks whether the monster level is below the high-level multiplier range.
	bcc.s	.StoreStartingHitPoints												;Uses the selected multiplier to calculate hit points once the high-level range has been reached.
	move.w	#$00FA,d1															;Loads the default middle-level hit-point multiplier for levels below the high-level range.
	cmpi.b	#$10,d0																;Checks whether the monster level is below the middle-level multiplier range.
	bcc.s	.StoreStartingHitPoints												;Uses the selected multiplier to calculate hit points once the high-level range has been reached.
	move.b	MonsterLevelHitPointMultipliers(pc,d0.w),d1							;Loads the table-defined lower-level hit-point multiplier indexed by the monster level.
.StoreStartingHitPoints:		; Memory Address ($0AC6) and binary offset [$0742]
	; Calculates starting hit points from the monster level.
	mulu	d1,d0																;Multiplies the monster level by its selected hit-point multiplier.
	add.w	#$0019,d0															;Adds the fixed base hit-point bonus to the scaled level result.
	move.w	d0,ActorRecord_HitPoints(a4)										;Stores the calculated starting hit points in the live monster record.
	move.b	(a3)+,ActorRecord_Form(a4)											;Reads the packed monster form/graphic identifier into the live record.
	bpl.s	CheckMonsterFormForCarriedObject									;Branches to the Zendik special-case check only for non-negative, ordinary monster forms.
	move.b	#$10,MonsterRecord_ActionCycleTimer(a4)								;Gives a negative/special form the fixed action countdown used by that special behaviour.
	bra.s	StoreTeamData														;Skips the Zendik object check and continues with packed team-data processing.

CheckMonsterFormForCarriedObject:
	; Handles the monster-form special case that assigns a fixed carried object.
	cmp.b	#MonsterForm_Zendik,ActorRecord_Form(a4)
	bne.s	StoreTeamData														;Continues normal unpacking when the form is not the Zendik special case.
	move.b	#Object_AceOfSwords,MonsterRecord_CarriedObject(a4)					;Assigns the Ace of Swords object to Zendik's carried-object field for the unique drop encounter.
StoreTeamData:		; Memory Address ($0AEC) and binary offset [$0768]
	; Stores the team-group index derived from packed team-data.
	moveq	#$00,d0																;Clears d0 before reading the packed team byte.
	move.b	(a3)+,d0															;Reads the packed team byte and advances a3 to the next monster record.
	cmpi.b	#PackedMonster_NoTeamData,d0										;Checks for $FF, the packed marker meaning that this monster has no team data.
	beq.s	.AdvanceToNextMonster												;Skips team-table insertion for a monster without packed team data.
	lea		MonsterTeamIndexTable.l,a0											;Loads the base of the team-index table used to map packed team slots to live records.
	move.b	d4,$00(a0,d0.w)														;Stores this monster's ordinal in the team slot selected by the packed team byte.
	move.b	d0,d1																;Copies the packed team byte into d1 for slot and group extraction.
	and.b	#MonsterTeamMember_SlotMask,d1										;Masks the low two bits to select one of the four member slots in the team.
	tst.b	ActorRecord_XPosition(a4)											;Tests X bit 7 to distinguish a positioned leader from a follower.
	bmi.s	.AdvanceToNextMonster												;Leaves a follower in its table slot, but skips live group assignment.
	addq.w	#$01,MonsterTeamIndexTable_CountOffset(a0)							;Increments the last team-row index once for this positioned leader.
	lsr.b	#MonsterTeamData_GroupShift,d0										;Shifts away the member-slot bits, leaving the packed team group number.
	move.b	d0,MonsterRecord_TeamGroupIndex(a4)									;Stores the group on the positioned leader; followers keep $FF.
.AdvanceToNextMonster:		; Memory Address ($0B16) and binary offset [$0792]
	; Advances to the next packed and live monster record.
	add.w	#ActorRecord_Size,a4												;Advances a4 by the $10-byte live monster record size.
	addq.w	#$01,d4																;Increments the zero-based monster ordinal used by team-table entries.
	dbra	d6,UnpackNextMonsterRecord											;Repeats unpacking until d6 has processed every packed monster in this tower.
	rts																			;Returns after all packed monster records have been expanded and team membership has been rebuilt.

MonsterLevelHitPointMultipliers:		; Memory Address ($0B22) and binary offset [$079E]
	; Per-level hit-point multipliers for lower monster levels.
	dc.b	$00	;00
	dc.b	$32	;32
	dc.b	$37	;37
	dc.b	$3E	;3E
	dc.b	$46	;46
	dc.b	$4B	;4B
	dc.b	$50	;50
	dc.b	$55	;55
	dc.b	$5A	;5A
	dc.b	$78	;78
	dc.b	$8C	;8C
	dc.b	$A0	;A0
	dc.b	$B4	;B4
	dc.b	$BE	;BE
	dc.b	$C8	;C8
	dc.b	$DC	;DC

TransferChampionStartPosition:		; Memory Address ($0B32) and binary offset [$07AE]
	; Copies champion bytes $16/$17/$18/$1A as X, Y, direction, and floor into the
	; active player record, then marks the champion's stored X and Y as $FF so the
	; start position cannot be claimed again.
	bsr		Load_CurrentChampionStatRecord										;Loads the current champion's stat record into a4; a5 points to the active player record receiving the data.
	moveq	#$00,d0																;Clears d0 before reading the saved champion X coordinate.
	move.b	ChampionStat_XPosition(a4),d0										;Loads the saved champion X coordinate for transfer into the active player position.
	bmi.s	.NoChampionStartPosition											;Returns without copying a position when X is negative, the no-start-position sentinel.
	move.b	#$FF,ChampionStat_XPosition(a4)										;Marks the champion's saved X coordinate consumed so it cannot be reused on the next transfer.
	move.w	d0,PlayerData_XPosition(a5)											;Copies the X coordinate into the active player record's start-position word at offset $1C.
	move.b	ChampionStat_YPosition(a4),d0										;Loads the saved champion Y coordinate into d0.
	move.b	#$FF,ChampionStat_YPosition(a4)										;Marks the champion's saved Y coordinate consumed after it has been selected.
	move.w	d0,PlayerData_YPosition(a5)											;Copies the Y coordinate into the active player record's start-position word at offset $1E.
	move.b	ChampionStat_Direction(a4),d0										;Loads the champion's saved facing/direction byte.
	move.w	d0,PlayerData_Direction(a5)											;Copies the direction into the active player record's orientation field at offset $20.
	move.b	ChampionStat_Floor(a4),d0											;Loads the champion's saved floor byte.
	move.w	d0,PlayerData_Floor(a5)												;Copies the champion floor into the active player floor word at offset $58.
.NoChampionStartPosition:		; Memory Address ($0B66) and binary offset [$07E2]
	; Returns when the champion has no saved position.
	rts																			;Returns to the player-initialisation loop after a valid or absent champion position has been handled.

Select_CurrentTowerMapData:		; Memory Address ($0B68) and binary offset [$07E4]
	; Copies the selected tower’s map-pointer block into working memory.
	move.w	CurrentTower.l,d0													;Reads the selected tower index for the relative map-offset lookup.
	add.w	d0,d0																;Converts the tower number into a word offset for the tower-offset table.
	lea		Current_TowerMapOffsets.l,a0										;Loads assembled word differences from MapData1 to the six tower map blocks.
	lea		MapData1.l,a6														;Loads a6 with the first tower map-data block, the base used by the relative offset.
	add.w	$00(a0,d0.w),a6														;Adds the signed word-relative tower offset to MapData1; larger tower layouts must remain representable by this addressing mode.
	lea		Current_TowerMapHeaderCache.l,a0									;Loads the working cache for the selected tower 56-byte map header; this is not a table of pointers.
	moveq	#(Map_HeaderSize/4)-1,d0											;Sets fourteen longword iterations to copy the complete 56-byte map header.
.CopyCurrentTowerMapPointerLoop:		; Memory Address ($0B88) and binary offset [$0804]
	; Copies the fourteen map pointers for the selected tower.
	move.l	(a6)+,(a0)+															;Copies four bytes of map header data and advances the source and runtime-cache pointers.
	dbra	d0,.CopyCurrentTowerMapPointerLoop									;Repeats until all fourteen header longwords have been copied.
	move.l	a6,Current_TowerMapDataBase.l										;Stores the first cell-data address after the header copy has advanced A6 by 56 bytes.
	rts																			;Returns with the cached tower header and first map-cell address ready.

Current_TowerMapOffsets:
	; Six word offsets selecting the map resource for CurrentTower values 0 through
	; 5. The offsets are relative to MapData1 and include the intervening
	; tower-specific object data. Relative offsets from MapData1 to each tower
	; map-pointer block.
	dc.w	MapData1-MapData1	;0000
	dc.w	MapData2-MapData1	;1402
	dc.w	MapData3-MapData1	;2804
	dc.w	MapData4-MapData1	;3C06
	dc.w	MapData5-MapData1	;5008
	dc.w	MapData6-MapData1	;640A

InitialiseNewGameSession:		; Memory Address ($0BA2) and binary offset [$081E]
	; Prepares champion records and enters the shared active-player session
	; initialisation.
	bsr		PrepareCharacters													;Prepares champion records and map occupancy before entering active-player initialisation.
InitialiseActivePlayerData:		; Memory Address ($0BA6) and binary offset [$0822]
	; Initialises the active player structures after champion preparation or when
	; resuming through the shared entry point.
	clr.w	FrameSyncFlag.l														;Clears the frame-synchronisation flag before constructing the player state.
	move.b	#$FF,ChampionSelectionLiveActionFlag.l								;Sets the shared player/session state byte to its inactive sentinel value.
	lea		Player1_Data.l,a5													;Loads a5 with the first player's data record.
	move.l	#$00F00020,PlayerData_MousePosition(a5)								;Initialises the first player's packed state/position word with its single-player defaults.
	move.w	#$5601,PlayerData_MouseYClampBounds(a5)								;Initialises the first player's control and interface state word.
	tst.w	MultiPlayer.l														;Checks whether the session is running in multiplayer mode.
	beq.s	InitialisePlayer2Data												;Takes the single-player path into the shared second-player/default setup block.
	move.w	#$8223,PlayerData_MouseYClampBounds(a5)								;Replaces the first player's control state with the multiplayer configuration.
	move.l	#$FFFFFFFF,Player2_ChampionPointer.l								;Invalidates the second player's champion pointer until multiplayer selection supplies it.
	move.w	#$0027,PlayerData_InterfacePanelYOffset(a5)							;Initialises the first player's multiplayer start-position word.
	move.w	#$0618,PlayerData_InterfaceScreenBufferOffset(a5)					;Initialises the first player's multiplayer map/viewport word.
	clr.l	Player2_MousePosition.l												;Clears the shared second-player/session scratch longword.
	moveq	#$00,d7																;Sets d7 to zero so the shared player loop handles only the active first player on this path.
	bra.s	InitialisePlayerDataLoop											;Jumps into the common player-record initialisation loop.

InitialisePlayer2Data:		; Memory Address ($0BF6) and binary offset [$0872]
	; Initialises the second player structure for a two-player session.
	lea		Player2_Data.l,a5													;Loads a5 with the second player's data record.
	move.l	#$00F00088,PlayerData_MousePosition(a5)								;Initialises the second player's packed state/position word for the two-player path.
	move.w	#$BE68,PlayerData_MouseYClampBounds(a5)								;Initialises the second player's control and interface state word.
	move.w	#$0068,PlayerData_InterfacePanelYOffset(a5)							;Initialises the second player's start-position word.
	move.w	#$1040,PlayerData_InterfaceScreenBufferOffset(a5)					;Initialises the second player's map/viewport word.
	moveq	#$01,d7																;Sets d7 to one so the common loop processes both player records.
InitialisePlayerDataLoop:		; Memory Address ($0C18) and binary offset [$0894]
	; Initialises each active player structure and transfers its saved champion
	; start position.
	clr.w	$0014(a5)															;Clears the active player's transient action/state word before input processing begins.
	move.w	#$FFFF,PlayerData_PartyCommandState(a5)								;Initialises the party-command/interface state word to $FFFF, meaning no numbered command state is active.
	move.w	#$FFFF,PlayerData_PartyCommandSelection(a5)							;Sets the command-type/state word to $FFFF, meaning no command is pending.
	bsr		TransferChampionStartPosition										;Transfers the active player's saved champion start position into the player record.
	bset	#PlayerData_ChampionSlots_CorrectedBit,PlayerData_ChampionSlotsOffset(a5)	;Sets the active-player flag bit used to mark the player record as initialised/available.
	lea		Player1_Data.l,a5													;Resets a5 to Player1_Data so the next loop iteration starts from the first player record.
	dbra	d7,InitialisePlayerDataLoop											;Repeats player initialisation for the remaining player selected by d7.
	bsr		Draw_InitialGameInterface											;Runs the shared post-player setup routine after all player records are initialised.
	move.w	#$FFFF,FrameSyncFlag.l												;Sets the frame-synchronisation flag to release the subsequent frame-wait logic.
Wait_ForFrameSyncClear:		; Memory Address ($0C48) and binary offset [$08C4]
	; Waits for the interrupt-updated frame synchronisation byte to clear.
	tst.b	FrameSyncFlag.l
	bne.s	Wait_ForFrameSyncClear
MainGame_PlayerUpdateLoop:		; Memory Address ($0C50) and binary offset [$08CC]
	; Runs the per-frame input and interface update path for each active player.
	lea		Player1_Data.l,a5
	bsr		Select_ActivePlayerFloorMap											;Loads geometry for the player currently addressed by A5; repeated separately for Player 1 and Player 2.
	bsr		Scan_PlayerInterfaceActions
	bsr		Dispatch_PlayerInterfaceActionGuarded
	tst.w	MultiPlayer.l
	bne.s	Finish_PlayerUpdatePass
	lea		Player2_Data.l,a5
	bsr		Select_ActivePlayerFloorMap											;Loads geometry for the player currently addressed by A5; repeated separately for Player 1 and Player 2.
	bsr		Scan_PlayerInterfaceActions
	bsr		Dispatch_PlayerInterfaceActionGuarded
	jsr		Refresh_ActivePlayerDungeonViewport.l
	lea		Player1_Data.l,a5
Finish_PlayerUpdatePass:		; Memory Address ($0C88) and binary offset [$0904]
	; Finishes player drawing, requests the next frame and continues periodic
	; game-state processing.
	jsr		Refresh_ActivePlayerDungeonViewport.l
	move.b	#$FF,FrameSyncFlag.l
MainGameLoop_WaitFrameSync:		; Memory Address ($0C96) and binary offset [$0912]
	tst.b	FrameSyncFlag.l
	bne.s	MainGameLoop_WaitFrameSync
	bsr.s	Flush_DirtyUIRegions_BothPlayers
	move.b	Player1_ChampionCount.l,d0
	and.b	Player2_ChampionPointer.l,d0
	btst	#$06,d0
	beq.s	MainGameLoop_ArmConflictFlagAndTick
	bsr.s	NoChampions_DelayAndFallbackToLoadGame
MainGameLoop_ArmConflictFlagAndTick:		; Memory Address ($0CB4) and binary offset [$0930]
	move.w	#$0001,SpellEntity_PlacementConflictFlag.l
	bsr		Run_300TickPeriodicUpdates
	bra.s	MainGame_PlayerUpdateLoop

NoChampions_DelayAndFallbackToLoadGame:		; Memory Address ($0CC2) and binary offset [$093E]
	; Handles an invalid no-champion setup by delaying, resetting shield-highlight
	; timers, redrawing the interface, and opening Load Game.
	move.l	WorldTick_300UnitCountdown.l,-(sp)
	moveq	#$14,d0
DBFWait1b:		; Memory Address ($0CCA) and binary offset [$0946]
	dbra	d1,DBFWait1b
	dbra	d0,DBFWait1b
	move.l	#$FFFFFFFF,Player1_ShieldHighlightCountdowns.l
	move.l	#$FFFFFFFF,Player2_ShieldHighlightCountdowns.l
	clr.w	FrameSyncFlag.l
	bsr		Draw_InitialGameInterface
	clr.w	FrameSyncFlag.l
	moveq	#$14,d0
DBFWait1c:		; Memory Address ($0CF8) and binary offset [$0974]
	dbra	d1,DBFWait1c
	dbra	d0,DBFWait1c
	bra		LoadGame

Flush_DirtyUIRegions_BothPlayers:		; Memory Address ($0D04) and binary offset [$0980]
	; Flushes dirty interface regions for Player 1 and then Player 2 once per
	; main-loop pass.
	lea		Player1_Data.l,a5
	bsr.s	Flush_DirtyUIRegions
	lea		Player2_Data.l,a5
Flush_DirtyUIRegions:		; Memory Address ($0D12) and binary offset [$098E]
	; Copies only the player interface regions selected by the dirty-region byte
	; from the draw buffer to the visible buffer.
	and.b	#$7F,PlayerData_DialogueColourState(a5)
	move.b	PlayerData_UIDirtyRegionFlags(a5),d3
	clr.b	PlayerData_UIDirtyRegionFlags(a5)
	move.w	PlayerData_InterfaceScreenBufferOffset(a5),d0
	move.w	d0,d6
	bsr.s	Copy_VariableHeightScreenBand
	move.w	d6,d0
	add.w	#$001C,d0
	bsr.s	Copy_VariableHeightScreenBand
	lsr.b	#$01,d3
	bcc.s	Apply_MiddleViewportRefreshStrip
	move.w	d6,d0
	add.w	#$0DCC,d0
	bsr.s	Copy_8RowScreenBand
Apply_MiddleViewportRefreshStrip:		; Memory Address ($0D3C) and binary offset [$09B8]
	; Tests the next refresh-mask bit and copies the corresponding middle viewport
	; strip when set.
	move.w	d6,d0
	lsr.b	#$01,d3
	bcc.s	Apply_LowerViewportRefreshStrip
	add.w	#$000C,d0
	bsr.s	Copy_8RowScreenBand
Apply_LowerViewportRefreshStrip:		; Memory Address ($0D48) and binary offset [$09C4]
	; Tests the final refresh-mask bit and selects the corresponding lower viewport
	; copy region.
	move.w	d6,d0
	lsr.b	#$01,d3
	bcc		ScreenBandCopy_SharedReturn
	add.w	#$01EC,d0
	move.l	screen_ptr.l,a0
	move.l	framebuffer_ptr.l,a1
	add.w	d0,a1
	add.w	d0,a0
	bra		PlayerHeightCheck_MainViewportRowCount

Copy_8RowScreenBand:		; Memory Address ($0D68) and binary offset [$09E4]
	; Copies a fixed eight-row, four-plane screen band from the draw buffer to the
	; visible buffer.
	move.l	screen_ptr.l,a0
	move.l	framebuffer_ptr.l,a1
	add.w	d0,a1
	add.w	d0,a0
	moveq	#$07,d0
	bra		ScreenBandCopy_SharedRowLoop

Copy_VariableHeightScreenBand:		; Memory Address ($0D7E) and binary offset [$09FA]
	; Copies a dirty-region-selected variable-height screen band from the draw
	; buffer to the visible buffer.
	moveq	#$06,d2
	btst	#$05,d3
	bne.s	CopyVariableHeightScreenBand_TestRowBit0
	moveq	#-$01,d2
	add.w	#$0118,d0
CopyVariableHeightScreenBand_TestRowBit0:		; Memory Address ($0D8C) and binary offset [$0A08]
	lsr.b	#$01,d3
	bcc.s	CopyVariableHeightScreenBand_TestRowBit1
	add.w	#$0051,d2
CopyVariableHeightScreenBand_TestRowBit1:		; Memory Address ($0D94) and binary offset [$0A10]
	lsr.b	#$01,d3
	bcc.s	CopyVariableHeightScreenBand_CheckRowCount
	addq.w	#$08,d2
CopyVariableHeightScreenBand_CheckRowCount:		; Memory Address ($0D9A) and binary offset [$0A16]
	tst.w	d2
	bmi.s	ScreenBandCopy_SharedReturn
	move.l	screen_ptr.l,a0
	move.l	framebuffer_ptr.l,a1
	add.w	d0,a1
	add.w	d0,a0
CopyVariableHeightScreenBand_RowCopyLoop:		; Memory Address ($0DAE) and binary offset [$0A2A]
	lea		Screen_Bitplane3Offset(a1),a3
	lea		Screen_Bitplane3Offset(a0),a2
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	lea		Screen_Bitplane2Offset(a1),a3
	lea		Screen_Bitplane2Offset(a0),a2
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	lea		Screen_BitplaneSize(a1),a3
	lea		Screen_BitplaneSize(a0),a2
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	lea		ScreenBand_12ByteRowSkip(a0),a0
	lea		ScreenBand_12ByteRowSkip(a1),a1
	dbra	d2,CopyVariableHeightScreenBand_RowCopyLoop
ScreenBandCopy_SharedReturn:		; Memory Address ($0DEA) and binary offset [$0A66]
	rts		

PlayerHeightCheck_MainViewportRowCount:		; Memory Address ($0DEC) and binary offset [$0A68]
	moveq	#$4B,d0
ScreenBandCopy_SharedRowLoop:		; Memory Address ($0DEE) and binary offset [$0A6A]
	lea		Screen_Bitplane3Offset(a1),a3
	lea		Screen_Bitplane3Offset(a0),a2
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	lea		Screen_Bitplane2Offset(a1),a3
	lea		Screen_Bitplane2Offset(a0),a2
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	lea		Screen_BitplaneSize(a1),a3
	lea		Screen_BitplaneSize(a0),a2
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	lea		ScreenBand_16ByteRowSkip(a0),a0
	lea		ScreenBand_16ByteRowSkip(a1),a1
	dbra	d0,ScreenBandCopy_SharedRowLoop
	rts		

Update_ChampionStatRegeneration:		; Memory Address ($0E34) and binary offset [$0AB0]
	; Resolves a champion and owner, skips an ineligible dead record, and enters
	; spell-point, hit-point, food, and vitality regeneration.
	move.l	a4,d0
	sub.l	#Character_Stats_DataTable,d0
	lsr.w	#$01,d0
	lea		Character_Pockets_DataTable.l,a0
	add.w	d0,a0
	lsr.w	#ChampionPocket_RecordSizeShift,d0
	move.w	d0,d7
	movem.l	d0/d1/d7/a5,-(sp)
	bsr		Find_ChampionOwner
	tst.w	d1
	bmi.s	Update_ChampionSpellPoints
	btst	#$06,$18(a5,d1.w)
	beq.s	Update_ChampionSpellPoints
	movem.l	(sp)+,d0/d1/d7/a5
	rts		

Update_ChampionSpellPoints:		; Memory Address ($0E64) and binary offset [$0AE0]
	; Increments current spell points toward the maximum, then continues into
	; hit-point recovery.
	movem.l	(sp)+,d0/d1/d7/a5
	move.b	ChampionStat_SpellPointsCurrent(a4),d0
	cmp.b	ChampionStat_SpellPointsMaximum(a4),d0
	beq.s	Update_ChampionHitPointRecovery
	addq.b	#$01,ChampionStat_SpellPointsCurrent(a4)
Update_ChampionHitPointRecovery:		; Memory Address ($0E76) and binary offset [$0AF2]
	; Recovers hit points from champion level, doubles the rate when object $5B is
	; in either leading pocket, and clamps to maximum.
	OPT		O2+
	move.b	ChampionStat_Level(a4),d0
	OPT		O2-
	lsr.b	#$01,d0
	OPT		O2+
	cmp.b	#Object_HealWand,ChampionPocket_LeftHand(a0)
	OPT		O2-
	beq.s	HitPointRecovery_AddToCurrentHP
	cmp.b	#Object_HealWand,ChampionPocket_RightHand(a0)
	beq.s	HitPointRecovery_AddToCurrentHP
	lsr.b	#$01,d0
HitPointRecovery_AddToCurrentHP:		; Memory Address ($0E8A) and binary offset [$0B06]
	addq.b	#$01,d0
	add.b	ChampionStat_HitPointsCurrent(a4),d0
	bcc.s	Clamp_AIProgressToMaximum
	moveq	#-$01,d0
Clamp_AIProgressToMaximum:		; Memory Address ($0E94) and binary offset [$0B10]
	; Caps the newly accumulated progress byte at the record-specific maximum in
	; byte $06, then stores it in byte $05.
	cmp.b	ChampionStat_HitPointsMaximum(a4),d0
	bcs.s	ClampAIProgressToMaximum_StoreHP
	move.b	ChampionStat_HitPointsMaximum(a4),d0
ClampAIProgressToMaximum_StoreHP:		; Memory Address ($0E9E) and binary offset [$0B1A]
	move.b	d0,ChampionStat_HitPointsCurrent(a4)
	tst.b	ChampionStat_VitalityCurrent(a4)
	bne.s	Update_ChampionFoodAndVitality
	movem.l	d7/a4/a5,-(sp)
	bsr		RandomGen_BytewithOffset
	and.w	#$0007,d0
	add.b	(a4),d0
	cmp.b	$0005(a4),d0
	bcs.s	Apply_StarvationDamage
	move.b	$0005(a4),d0
	beq.s	StarvationCheck_RestoreRegsAndContinue
Apply_StarvationDamage:		; Memory Address ($0EC2) and binary offset [$0B3E]
	; Applies a random level-influenced hit-point loss when food exhaustion has
	; already reduced vitality to zero.
	move.w	d0,d5
	move.w	d7,d0
	bsr		Apply_AttackDamage
StarvationCheck_RestoreRegsAndContinue:		; Memory Address ($0ECA) and binary offset [$0B46]
	movem.l	(sp)+,d7/a4/a5
Update_ChampionFoodAndVitality:		; Memory Address ($0ECE) and binary offset [$0B4A]
	; Recovers vitality according to food level or decrements vitality while
	; starving.
	move.b	ChampionStat_FoodLevel(a4),d0
	bne.s	FoodAndVitality_RecoverFromFood
	subq.b	#$01,ChampionStat_VitalityCurrent(a4)
	bcc.s	UpdateChampionFoodAndVitality_Return
	clr.b	ChampionStat_VitalityCurrent(a4)
	bra.s	UpdateChampionFoodAndVitality_Return

FoodAndVitality_RecoverFromFood:		; Memory Address ($0EE0) and binary offset [$0B5C]
	lsr.b	#$06,d0
	addq.b	#$01,d0
	add.b	ChampionStat_VitalityCurrent(a4),d0
	cmp.b	ChampionStat_VitalityMaximum(a4),d0
	bcs.s	FoodAndVitality_StoreClampedVitality
	move.b	ChampionStat_VitalityMaximum(a4),d0
FoodAndVitality_StoreClampedVitality:		; Memory Address ($0EF2) and binary offset [$0B6E]
	move.b	d0,ChampionStat_VitalityCurrent(a4)
UpdateChampionFoodAndVitality_Return:		; Memory Address ($0EF6) and binary offset [$0B72]
	rts		

Stat_UpdateLoop:		; Memory Address ($0EF8) and binary offset [$0B74]
	; Runs the slow global cycle for champion regeneration, party food drain, and
	; worn-spell decay.
	lea		Character_Stats_DataTable.l,a4
	moveq	#Champion_Count-1,d7
StatUpdateLoop_PerChampionLoop:		; Memory Address ($0F00) and binary offset [$0B7C]
	movem.l	d7/a4,-(sp)
	bsr		Update_ChampionStatRegeneration
	movem.l	(sp)+,d7/a4
	add.w	#ChampionStat_RecordSize,a4
	dbra	d7,StatUpdateLoop_PerChampionLoop
	subq.b	#$01,WornSpellDecayGraceCountdown.l
	lea		Player1_Data.l,a5
	bsr		Drain_PartyFoodLevel
	lea		Player2_Data.l,a5
	bsr		Drain_PartyFoodLevel
	tst.b	WornSpellDecayGraceCountdown.l
	bpl.s	Return_CharacterMaintenance
	clr.b	WornSpellDecayGraceCountdown.l
Return_CharacterMaintenance:		; Memory Address ($0F3C) and binary offset [$0BB8]
	; Returns after completing the character and player status-maintenance pass.
	rts		

Drain_PartyFoodLevel:		; Memory Address ($0F3E) and binary offset [$0BBA]
	; Drains one food point from each eligible party member before entering the
	; worn-spell decay pass.
	tst.b	WornSpellDecayGraceCountdown.l
	bpl		PlayerTick_DrawInterfaceAndDispatchPanel
	moveq	#$00,d6
	moveq	#$03,d7
DrainPartyFoodLevel_SlotLoop:		; Memory Address ($0F4C) and binary offset [$0BC8]
	move.b	$18(a5,d7.w),d0
	bmi.s	DrainPartyFoodLevel_SlotLoopTail
	btst	#$06,d0
	bne.s	DrainPartyFoodLevel_SlotLoopTail
	and.w	#$000F,d0
	move.w	d0,d1
	bsr		Load_ChampionStatRecord
	btst	#$02,(a5)
	bne.s	Process_ChampionWornSpellTimer
	btst	#$06,$18(a5,d7.w)
	bne.s	Process_ChampionWornSpellTimer
	cmpi.b	#$0B,d1
	beq.s	Process_ChampionWornSpellTimer
	subq.b	#$01,ChampionStat_FoodLevel(a4)
	bcc.s	Process_ChampionWornSpellTimer
	clr.b	ChampionStat_FoodLevel(a4)
Process_ChampionWornSpellTimer:		; Memory Address ($0F80) and binary offset [$0BFC]
	; Ages the champion's worn-spell timer and records shield-slot redraws when it
	; expires.
	move.b	ChampionStat_WornSpell(a4),d0
	and.w	#$0007,d0
	beq.s	DrainPartyFoodLevel_SlotLoopTail
	subq.b	#$08,ChampionStat_WornSpell(a4)
	bcc.s	DrainPartyFoodLevel_SlotLoopTail
	clr.b	ChampionStat_WornSpell(a4)
	tst.w	d7
	bne.s	TeamAvatarUpdateLoop_CheckSlotBit
	addq.b	#$01,d6
TeamAvatarUpdateLoop_CheckSlotBit:		; Memory Address ($0F9A) and binary offset [$0C16]
	btst	d7,$003E(a5)
	bne.s	DrainPartyFoodLevel_SlotLoopTail
	tst.w	d7
	beq.s	Redraw_FirstChampionShieldSlot
	tst.w	$0042(a5)
	bpl.s	DrainPartyFoodLevel_SlotLoopTail
Redraw_FirstChampionShieldSlot:		; Memory Address ($0FAA) and binary offset [$0C26]
	; Redraws an expired shield for the first party slot when the interface state
	; permits it.
	movem.w	d6/d7,-(sp)
	bsr		Refresh_PartyShieldSlotIfDirty
	movem.w	(sp)+,d6/d7
	bset	d7,d6
DrainPartyFoodLevel_SlotLoopTail:		; Memory Address ($0FB8) and binary offset [$0C34]
	dbra	d7,DrainPartyFoodLevel_SlotLoop
	btst	#$00,d6
	beq.s	Redraw_RemainingChampionShieldSlots
	tst.b	$0015(a5)
	bne.s	Redraw_RemainingChampionShieldSlots
	move.w	d6,-(sp)
	bsr		Refresh_CurrentChampionMapPositionIcon
	move.w	(sp)+,d6
Redraw_RemainingChampionShieldSlots:		; Memory Address ($0FD0) and binary offset [$0C4C]
	; Redraws expired shield slots two through four when any changed.
	and.w	#$000E,d6
	beq.s	PlayerTick_DrawInterfaceAndDispatchPanel
	bsr		Draw_PartyShieldChainStrip
	bra.s	PlayerTick_DrawInterfaceAndDispatchPanel

FloorTrigger_Handler:		; Memory Address ($0FDC) and binary offset [$0C58]
	; Detects the forward regeneration floor feature and runs one or two
	; stat-regeneration passes for each party slot.
	btst	#$02,(a5)
	beq		PeriodicTick_SharedEarlyReturn
	clr.w	FloorTriggerDetectedFlag.l
	bsr		Select_ActivePlayerFloorMap
	bsr		ForwardCellToMapOffset
	move.w	$00(a6,d0.w),d1
	and.w	#$0007,d1
	subq.w	#$03,d1
	bne.s	FloorTriggerHandler_InitSlotLoop
	tst.b	$00(a6,d0.w)
	bne.s	FloorTriggerHandler_InitSlotLoop
	move.w	#$FFFF,FloorTriggerDetectedFlag.l
FloorTriggerHandler_InitSlotLoop:		; Memory Address ($100C) and binary offset [$0C88]
	moveq	#$03,d7
FloorTriggerHandler_SlotLoop:		; Memory Address ($100E) and binary offset [$0C8A]
	move.b	$18(a5,d7.w),d0
	and.w	#$00E0,d0
	bne.s	FloorTriggerHandler_SlotLoopTail
	move.b	$18(a5,d7.w),d0
	bsr		Load_ChampionStatRecord
	subq.b	#$06,ChampionStat_SpellCooldown(a4)
	bcc.s	FloorTriggerHandler_ApplyRegeneration
	clr.b	ChampionStat_SpellCooldown(a4)
FloorTriggerHandler_ApplyRegeneration:		; Memory Address ($102A) and binary offset [$0CA6]
	movem.l	d7/a5,-(sp)
	bsr		Update_ChampionStatRegeneration
	tst.w	FloorTriggerDetectedFlag.l
	beq.s	FloorTriggerHandler_RestoreLoopRegs
	subq.b	#$01,ChampionStat_SpellPointsCurrent(a4)
	bsr		Update_ChampionStatRegeneration
FloorTriggerHandler_RestoreLoopRegs:		; Memory Address ($1042) and binary offset [$0CBE]
	movem.l	(sp)+,d7/a5
FloorTriggerHandler_SlotLoopTail:		; Memory Address ($1046) and binary offset [$0CC2]
	dbra	d7,FloorTriggerHandler_SlotLoop
PlayerTick_DrawInterfaceAndDispatchPanel:		; Memory Address ($104A) and binary offset [$0CC6]
	bsr		Draw_MainPlayerInterface
	move.w	$0014(a5),d1
	subq.w	#$01,d1
	beq		Click_ShowStats
	subq.b	#$01,d1
	bne.s	PeriodicTick_SharedEarlyReturn
	jmp		Draw_SpellPointValues.l

FloorTriggerDetectedFlag:		; Memory Address ($1062) and binary offset [$0CDE]
	; Set when the forward map cell is the regeneration floor feature and consumed
	; by the same stat-update pulse.
	ds.b	$2
Decay_CastingFatigue:		; Memory Address ($1064) and binary offset [$0CE0]
	; Decrements every champion's casting-fatigue byte once per eight engine
	; subcycles and clamps it at zero.
	subq.b	#$01,CastingFatigueSubcycleCountdown.l
	bpl.s	PeriodicTick_SharedEarlyReturn
	move.b	#$07,CastingFatigueSubcycleCountdown.l
	moveq	#Champion_Count-1,d7
	lea		Character_Stats_DataTable.l,a4
DecayCastingFatigue_ChampionLoop:		; Memory Address ($107C) and binary offset [$0CF8]
	subq.b	#$01,ChampionStat_SpellCooldown(a4)
	bcc.s	DecayCastingFatigue_AdvanceRecord
	clr.b	ChampionStat_SpellCooldown(a4)
DecayCastingFatigue_AdvanceRecord:		; Memory Address ($1086) and binary offset [$0D02]
	add.w	#ChampionStat_RecordSize,a4
	dbra	d7,DecayCastingFatigue_ChampionLoop
PeriodicTick_SharedEarlyReturn:		; Memory Address ($108E) and binary offset [$0D0A]
	rts		

Maintain_MonsterGroupFormation:		; Memory Address ($1090) and binary offset [$0D0C]
	; Rebuilds live monster-team membership and dissolves a group when only one
	; living member remains.
	moveq	#$00,d6
	lea		UnpackedMonsters.l,a3
	lea		MonsterTeamIndexTable.l,a0
	move.w	MonsterTeamIndexTable_CountOffset(a0),d7
	bmi.s	PeriodicTick_SharedEarlyReturn
MaintainMonsterGroupFormation_GroupLoop:		; Memory Address ($10A4) and binary offset [$0D20]
	cmp.l	#$FFFFFFFF,(a0)
	beq.s	MaintainMonsterGroupFormation_RemoveGroupEntry
	moveq	#-$01,d4
	moveq	#MonsterTeamMember_Count-1,d1
MaintainMonsterGroupFormation_MemberLoop:		; Memory Address ($10B0) and binary offset [$0D2C]
	moveq	#$00,d2
	move.b	$00(a0,d1.w),d2
	bmi.s	MaintainMonsterGroupFormation_MemberLoopTail
	addq.w	#$01,d4
	asl.w	#$04,d2
	move.b	MonsterRecord_TeamGroupIndex(a3,d2.w),d3
	bmi.s	MaintainMonsterGroupFormation_MemberLoopTail
	sub.b	d6,d3
	move.b	d3,MonsterRecord_TeamGroupIndex(a3,d2.w)
	move.w	d2,d5
MaintainMonsterGroupFormation_MemberLoopTail:		; Memory Address ($10CA) and binary offset [$0D46]
	dbra	d1,MaintainMonsterGroupFormation_MemberLoop
	tst.w	d4
	bne.s	MaintainMonsterGroupFormation_TestGroupFlags
	move.b	#MonsterRecord_NoTeamGroup,MonsterRecord_TeamGroupIndex(a3,d5.w)
	move.b	ActorRecord_RotationAndSpace(a3,d5.w),d4
	and.w	#$0003,d4
	move.w	d4,d2
	asl.w	#$04,d4
	or.w	d4,d2
	move.b	d2,$02(a3,d5.w)
MaintainMonsterGroupFormation_RemoveGroupEntry:		; Memory Address ($10EA) and binary offset [$0D66]
	lea		$0004(a0),a1
	lea		(a0),a2
	move.w	d7,d1
	bra.s	MaintainMonsterGroupFormation_ShiftLoopTail

MaintainMonsterGroupFormation_ShiftLoop:		; Memory Address ($10F4) and binary offset [$0D70]
	move.l	(a1)+,(a2)+
MaintainMonsterGroupFormation_ShiftLoopTail:		; Memory Address ($10F6) and binary offset [$0D72]
	dbra	d1,MaintainMonsterGroupFormation_ShiftLoop
	move.l	#$FFFFFFFF,(a2)
	subq.w	#$01,MonsterTeamGroupCount.l
	addq.w	#$01,d6
	bra.s	MaintainMonsterGroupFormation_GroupLoopTail

MaintainMonsterGroupFormation_TestGroupFlags:		; Memory Address ($110A) and binary offset [$0D86]
	move.w	(a0),d0
	and.w	#$8080,d0
	beq.s	MaintainMonsterGroupFormation_AdvanceEntry
	move.b	$0003(a0),d2
	bmi.s	MaintainMonsterGroupFormation_SelectAltSlot
	move.b	#$FF,$0003(a0)
	bra.s	MaintainMonsterGroupFormation_StoreSlotValue

MaintainMonsterGroupFormation_SelectAltSlot:		; Memory Address ($1120) and binary offset [$0D9C]
	move.b	$0002(a0),d2
	move.b	#$FF,$0002(a0)
MaintainMonsterGroupFormation_StoreSlotValue:		; Memory Address ($112A) and binary offset [$0DA6]
	moveq	#$01,d1
	tst.b	d0
	bmi.s	MaintainMonsterGroupFormation_RelocateRecord
	moveq	#$00,d1
MaintainMonsterGroupFormation_RelocateRecord:		; Memory Address ($1132) and binary offset [$0DAE]
	move.b	d2,$00(a0,d1.w)
	move.w	d5,d3
	lsr.w	#$04,d3
	cmp.b	(a0),d3
	beq.s	MaintainMonsterGroupFormation_AdvanceEntry
	move.b	(a0),d3
	asl.w	#$04,d3
	move.b	ActorRecord_XPosition(a3,d5.w),ActorRecord_XPosition(a3,d3.w)
	move.b	ActorRecord_YPosition(a3,d5.w),ActorRecord_YPosition(a3,d3.w)
	move.b	ActorRecord_Floor(a3,d5.w),ActorRecord_Floor(a3,d3.w)
	move.b	#$FF,$00(a3,d5.w)
	move.b	ActorRecord_RotationAndSpace(a3,d5.w),ActorRecord_RotationAndSpace(a3,d3.w)
	move.b	MonsterRecord_TeamGroupIndex(a3,d5.w),MonsterRecord_TeamGroupIndex(a3,d3.w)
	move.b	#MonsterRecord_NoTeamGroup,MonsterRecord_TeamGroupIndex(a3,d5.w)
MaintainMonsterGroupFormation_AdvanceEntry:		; Memory Address ($116C) and binary offset [$0DE8]
	addq.w	#$04,a0
MaintainMonsterGroupFormation_GroupLoopTail:		; Memory Address ($116E) and binary offset [$0DEA]
	dbra	d7,MaintainMonsterGroupFormation_GroupLoop
	rts		

Decay_LinkedMagicRecords:		; Memory Address ($1174) and binary offset [$0DF0]
	; Ages linked-magic records, removes expired entries, and applies periodic
	; occupant damage for damaging records.
	clr.w	ResistanceCheckPower.l
	moveq	#$00,d1
	move.l	Current_TowerMapDataBase.l,a6
	lea		LinkedMagicRecordList.l,a0
DecayLinkedMagicRecords_ScanLoop:		; Memory Address ($1188) and binary offset [$0E04]
	cmp.w	-$0002(a0),d1
	bcs.s	DecayLinkedMagicRecords_ProcessRecord
	rts		

DecayLinkedMagicRecords_ProcessRecord:		; Memory Address ($1190) and binary offset [$0E0C]
	; Reduces a linked magic record's first byte by four on each 300-raster-unit
	; update, removes the record on underflow, and applies the kind-1 occupant
	; effect unless party levitation suppresses it.
	move.w	$02(a0,d1.w),d0
	subq.b	#$04,$00(a6,d0.w)
	bcs.s	DecayLinkedMagicRecords_RemoveAndContinue
	cmp.b	#$01,$00(a0,d1.w)
	bne.s	DecayLinkedMagicRecords_NextRecord
	tst.b	$01(a6,d0.w)
	bpl.s	DecayLinkedMagicRecords_NextRecord
	move.b	$01(a0,d1.w),SpellEntity_CasterIndex.l
	bsr.s	Damage_LinkedMagicCellOccupant
DecayLinkedMagicRecords_NextRecord:		; Memory Address ($11B2) and binary offset [$0E2E]
	addq.w	#$04,d1
	bra.s	DecayLinkedMagicRecords_ScanLoop

DecayLinkedMagicRecords_RemoveAndContinue:		; Memory Address ($11B6) and binary offset [$0E32]
	bsr.s	Remove_LinkedMagicRecord
	bra.s	DecayLinkedMagicRecords_ScanLoop

Damage_LinkedMagicCellOccupant:		; Memory Address ($11BA) and binary offset [$0E36]
	; Resolves the occupant of a damaging linked-magic cell and applies the
	; appropriate champion, party, or monster damage path.
	movem.l	d1/a0/a5/a6,-(sp)
	move.b	$00(a6,d0.w),d1
	lsr.b	#$02,d1
	movem.w	d0/d1,-(sp)
	jsr		Resolve_DiagonalCellAndFindOccupant.l
	bcc.s	DamageLinkedMagicOccupant_Return
	tst.b	d0
	bmi.s	LinkedMagicDamage_PartyLevitateCheck
	cmpi.b	#$10,d0
	bcs.s	LinkedMagicDamage_HitSingleOccupant
	tst.b	$000B(a1)
	bmi.s	DamageLinkedMagicOccupant_Return
LinkedMagicDamage_HitSingleOccupant:		; Memory Address ($11E0) and binary offset [$0E5C]
	move.w	$0002(sp),d7
	bsr		Roll_AndStagePartyDamage
	move.w	(sp),d0
	bsr		Apply_SpellImpactAtOccupant
	bra.s	DamageLinkedMagicOccupant_Return

LinkedMagicDamage_PartyLevitateCheck:		; Memory Address ($11F0) and binary offset [$0E6C]
	move.l	a1,a5
	moveq	#$05,d1
	bsr		Find_HighestRankedPartyMemberByCategory
	tst.w	d3
	bpl.s	DamageLinkedMagicOccupant_Return
	move.w	$0002(sp),d7
	bsr		Roll_AndStagePartyDamage
	bsr		Apply_PartyDamage
DamageLinkedMagicOccupant_Return:		; Memory Address ($1208) and binary offset [$0E84]
	movem.w	(sp)+,d0/d1
	movem.l	(sp)+,d1/a0/a5/a6
	rts		

Remove_LinkedMagicRecord:		; Memory Address ($1212) and binary offset [$0E8E]
	; Clears a cell's linked-magic type, compacts the linked-record list, and
	; decrements its count.
	and.w	#$00F8,$00(a6,d0.w)
	lea		$00(a0,d1.w),a1
	lea		$0004(a1),a2
	move.w	-$0002(a0),d0
	sub.w	d1,d0
	lsr.w	#$02,d0
	subq.w	#$01,d0
	bra.s	RemoveLinkedMagicRecord_ShiftLoopTail

RemoveLinkedMagicRecord_ShiftLoop:		; Memory Address ($122C) and binary offset [$0EA8]
	move.l	(a2)+,(a1)+
RemoveLinkedMagicRecord_ShiftLoopTail:		; Memory Address ($122E) and binary offset [$0EAA]
	dbra	d0,RemoveLinkedMagicRecord_ShiftLoop
	subq.w	#$04,-$0002(a0)
	rts		

Run_300TickPeriodicUpdates:		; Memory Address ($1238) and binary offset [$0EB4]
	; Reloads the 300-tick counter and runs linked-magic decay, floor-trigger
	; checks, navigation rebuilds, and party maintenance.
	tst.w	WorldTick_300UnitCountdown.l
	bne.s	Run300UnitGameTick_ActionSubcycleEntry
	move.w	#$012C,WorldTick_300UnitCountdown.l
	bsr		Decay_LinkedMagicRecords
	lea		Player1_Data.l,a5
	bsr		FloorTrigger_Handler
	lea		ReserveSpace_1.l,a6
	bsr		Build_PartyNavigationField
	lea		Player2_Data.l,a5
	bsr		FloorTrigger_Handler
	lea		ReserveSpace_2.l,a6
	bsr		Build_PartyNavigationField
	bsr		Maintain_MonsterGroupFormation
	bchg	#$01,StatUpdateLoop_AlternateTickGate.l
	beq.s	Run300UnitGameTick_ActionSubcycleEntry
	bsr		Stat_UpdateLoop
Run300UnitGameTick_ActionSubcycleEntry:		; Memory Address ($1286) and binary offset [$0F02]
	tst.w	ActionSubcycleCountdown.l
	bne		SharedEarlyReturn_Rts
	move.w	#$0007,ActionSubcycleCountdown.l
	bsr		Decay_CastingFatigue
	lea		MapCellImpactList.l,a0
	lea		-$0002(a0),a1
	move.l	Current_TowerMapDataBase.l,a6
	move.w	-$0002(a0),d7
	bra.s	MapCellImpactList_DecayLoopEnd

MapCellImpactList_DecayLoop:		; Memory Address ($12B2) and binary offset [$0F2E]
	; Decrements each impact record's phase once per global subcycle; phases 2, 1
	; and 0 remain drawable, and the record is removed when the three-bit phase
	; underflows.
	move.w	(a0)+,d0
	subq.w	#$01,(a0)
	move.w	(a0)+,d1
	not.w	d1
	and.w	#$0003,d1
	bne.s	MapCellImpactList_DecayLoopEnd
	bclr	#$05,$01(a6,d0.w)
	subq.w	#$04,a0
	lea		(a0),a2
	lea		$0004(a0),a3
	move.w	d7,d1
	bra.s	MapCellImpactList_CompactLoopEnd

MapCellImpactList_CompactLoop:		; Memory Address ($12D2) and binary offset [$0F4E]
	move.l	(a3)+,(a2)+
MapCellImpactList_CompactLoopEnd:		; Memory Address ($12D4) and binary offset [$0F50]
	dbra	d1,MapCellImpactList_CompactLoop
	subq.w	#$01,(a1)
MapCellImpactList_DecayLoopEnd:		; Memory Address ($12DA) and binary offset [$0F56]
	dbra	d7,MapCellImpactList_DecayLoop
	lea		Player1_Data.l,a5
	bsr		Run_PlayerPeriodicMaintenance
	lea		Player2_Data.l,a5
	bsr		Run_PlayerPeriodicMaintenance
	moveq	#$00,d7
	move.w	#$FFFF,ActorScanRecordIndex.l
	clr.w	PartyFormationActivationFlag.l
	lea		Character_Stats_DataTable.l,a4
ChampionCooldown_ScanLoop:		; Memory Address ($1308) and binary offset [$0F84]
	move.w	d7,-(sp)
	move.w	d7,d0
	move.w	d7,ActorScanRecordIndex.l
	bsr		Find_ChampionOwner
	tst.w	d1
	bpl.s	ChampionCooldown_ScanContinue
	moveq	#$16,d4
	bsr		Update_CharacterCooldownIfCurrentTower
ChampionCooldown_ScanContinue:		; Memory Address ($1320) and binary offset [$0F9C]
	add.w	#$0020,a4
	move.w	(sp)+,d7
	addq.w	#$01,d7
	cmpi.w	#$0010,d7
	bcs.s	ChampionCooldown_ScanLoop
	lea		UnpackedMonsters.l,a4
	move.w	-$0002(a4),d7
	bmi.s	Dispatch_PartyShieldHighlightDecay
UnpackedMonsters_AnimationAgeLoop:		; Memory Address ($133A) and binary offset [$0FB6]
	; Scans the allocation-ordered monster, Summon and spell records once per actor
	; update; records created during the scan resolve their initial collision but
	; do not receive another scheduled move in the same pass.
	move.w	d7,-(sp)
	addq.w	#$01,ActorScanRecordIndex.l
	moveq	#$00,d4
	bsr		Age_CharacterAnimationTimer
	add.w	#$0010,a4
	move.w	(sp)+,d7
	dbra	d7,UnpackedMonsters_AnimationAgeLoop
Dispatch_PartyShieldHighlightDecay:		; Memory Address ($1352) and binary offset [$0FCE]
	lea		Player1_Data.l,a5
	bsr.s	Decay_PartyShieldHighlightTimer
	lea		Player2_Data.l,a5
Decay_PartyShieldHighlightTimer:		; Memory Address ($1360) and binary offset [$0FDC]
	; Ages the four party-shield highlight timers and redraws any slot whose timer
	; expires.
	moveq	#$03,d7
	moveq	#$00,d6
PartyShieldHighlightTimer_SlotLoop:		; Memory Address ($1364) and binary offset [$0FE0]
	tst.b	$5A(a5,d7.w)
	bmi.s	PartyShieldHighlightTimer_SlotLoopEnd
	subq.b	#$01,$5A(a5,d7.w)
	bpl.s	PartyShieldHighlightTimer_SlotLoopEnd
	moveq	#$01,d6
	movem.w	d6/d7,-(sp)
	bsr		Refresh_PartyShieldSlotIfDirty
	movem.w	(sp)+,d6/d7
PartyShieldHighlightTimer_SlotLoopEnd:		; Memory Address ($137E) and binary offset [$0FFA]
	dbra	d7,PartyShieldHighlightTimer_SlotLoop
	tst.w	d6
	beq		CombatOutcomeSlotDecay_Init
	bsr		Draw_PartyShieldChainStrip
CombatOutcomeSlotDecay_Init:		; Memory Address ($138C) and binary offset [$1008]
	moveq	#$03,d7
CombatOutcomeSlotDecay_Loop:		; Memory Address ($138E) and binary offset [$100A]
	; Decrements one formation slot's combat-outcome lifetime during the main actor
	; scan and clears/redraws the slot when the counter underflows.
	tst.b	$5E(a5,d7.w)
	bmi.s	CombatOutcomeSlotDecay_LoopEnd
	subq.b	#$01,$5E(a5,d7.w)
	bpl.s	CombatOutcomeSlotDecay_LoopEnd
	move.w	d7,-(sp)
	bsr		Redraw_CombatOutcomeSlot
	move.w	(sp)+,d7
CombatOutcomeSlotDecay_LoopEnd:		; Memory Address ($13A2) and binary offset [$101E]
	dbra	d7,CombatOutcomeSlotDecay_Loop
	rts		

Calculate_ManhattanDistance:		; Memory Address ($13A8) and binary offset [$1024]
	; Returns the sum of the absolute X and Y differences between two packed
	; coordinates.
	sub.w	d1,d0
	move.w	d0,d1
	bpl.s	Calculate_ManhattanDistance_AbsDeltaX
	neg.w	d0
Calculate_ManhattanDistance_AbsDeltaX:		; Memory Address ($13B0) and binary offset [$102C]
	move.w	d0,d2
	swap	d0
	swap	d1
	sub.w	d1,d0
	move.w	d0,d1
	bpl.s	Calculate_ManhattanDistance_AbsDeltaY
	neg.w	d0
Calculate_ManhattanDistance_AbsDeltaY:		; Memory Address ($13BE) and binary offset [$103A]
	add.w	d0,d2
SharedEarlyReturn_Rts:		; Memory Address ($13C0) and binary offset [$103C]
	rts		

ActorScanRecordIndex:		; Memory Address ($13C2) and binary offset [$103E]
	; Current live monster-record index during the actor scan; $FFFF marks no
	; active record.
	ds.b	$2
PartyFormationActivationFlag:		; Memory Address ($13C4) and binary offset [$1040]
	; Distinguishes activation through a party formation slot from activation
	; during the ordinary monster scan.
	ds.b	$2
Update_CharacterCooldownIfCurrentTower:		; Memory Address ($13C6) and binary offset [$1042]
	; Updates a champion's attack cooldown only when their record belongs to the
	; current tower, then continues actor activation.
	move.w	CurrentTower.l,d0
	cmp.b	$001F(a4),d0
	bne.s	SharedEarlyReturn_Rts
	bsr		Update_CharacterAttackCooldown
	bra.s	ActorScan_ActivationGate

Age_CharacterAnimationTimer:		; Memory Address ($13D8) and binary offset [$1054]
	; Decrements the animation timer while preserving Confuse and Terror bits, then
	; continues actor activation.
	move.b	$0005(a4),d0
	bsr		Decrement_CharacterTimerLowBits
	move.b	$0005(a4),d1
	and.b	#$60,d1
	or.b	d1,d0
	move.b	d0,$0005(a4)
ActorScan_ActivationGate:		; Memory Address ($13EE) and binary offset [$106A]
	move.b	$04(a4,d4.w),d0
	cmp.b	AttackTypeNoSpells_FixedOriginFormCode.l,d0
	beq.s	FixedOriginForm_CooldownDecrement
	cmp.b	AttackTypeArcBoltMachine_FixedOriginFormCode.l,d0
	bne.s	FixedOriginForm_EarlyReturn
FixedOriginForm_CooldownDecrement:		; Memory Address ($1402) and binary offset [$107E]
	; Handles completion of the stored low-nibble cooldown: a starting value of one
	; decrements to zero and returns, while a starting zero underflows into the
	; completion path.
	move.b	$03(a4,d4.w),d7
	move.w	d7,d1
	and.w	#$000F,d1
	subq.w	#$01,d1
	bcs.s	Confuse_RecoveryTick
	subq.b	#$01,$03(a4,d4.w)
FixedOriginForm_EarlyReturn:		; Memory Address ($1414) and binary offset [$1090]
	rts		

Confuse_RecoveryTick:		; Memory Address ($1416) and binary offset [$1092]
	move.w	d7,d1
	lsr.b	#$04,d1
	or.b	d7,d1
	move.b	d1,$03(a4,d4.w)
	btst	#$06,$05(a4,d4.w)
	beq.s	Terror_RecoveryTick
	move.w	#$001E,ResistanceCheckPower.l
	bsr		Test_LevelResistanceRoll_FromPointer
	tst.w	d5
	bne.s	Terror_RecoveryTick
	bclr	#$06,$05(a4,d4.w)
Terror_RecoveryTick:		; Memory Address ($143E) and binary offset [$10BA]
	btst	#$05,$05(a4,d4.w)
	beq.s	Paralyze_RecoveryTick
	and.b	#$F0,$03(a4,d4.w)
	or.b	#$02,$03(a4,d4.w)
	move.w	#$0028,ResistanceCheckPower.l
	bsr		Test_LevelResistanceRoll_FromPointer
	tst.w	d5
	bne.s	Paralyze_RecoveryTick
	bclr	#$05,$05(a4,d4.w)
	or.b	#$0F,$03(a4,d4.w)
Paralyze_RecoveryTick:		; Memory Address ($146E) and binary offset [$10EA]
	tst.b	$05(a4,d4.w)
	bpl.s	ActorScan_ResolveOwnPositionGate
	move.w	#$0014,ResistanceCheckPower.l
	bsr		Test_LevelResistanceRoll_FromPointer
	and.b	#$7F,$05(a4,d4.w)
	tst.w	d5
	beq.s	ActorScan_ResolveOwnPositionGate
	or.b	#$0F,$03(a4,d4.w)
	bset	#$07,$05(a4,d4.w)
Paralyze_RemainsActive_EarlyReturn:		; Memory Address ($1496) and binary offset [$1112]
	rts		

ActorScan_ResolveOwnPositionGate:		; Memory Address ($1498) and binary offset [$1114]
	moveq	#$00,d7
	move.b	$00(a4,d4.w),d7
	bmi		FixedOriginForm_EarlyReturn
	swap	d7
	move.b	$01(a4,d4.w),d7
	moveq	#$00,d0
	move.b	$04(a4,d4.w),d0
	bsr		Select_FloorMapByIndex
	bsr		CoordToMap
	move.b	$01(a6,d0.w),d1
	bpl.s	Paralyze_RemainsActive_EarlyReturn
	cmpi.w	#$0000,d4
	beq.s	Begin_MonsterAttackBehaviour
	bsr		Read_MonsterMovementTableEntry
	bpl		Store_MonsterRotationByte
	tst.w	PartyFormationActivationFlag.w										;Short Absolute converted to symbol!
	beq		AttackType_Drone
	lea		ReserveSpace_1.l,a6
	btst	#$00,(a5)
	beq.s	FormationSlot_SelectReserveSpace
	lea		ReserveSpace_2.l,a6
FormationSlot_SelectReserveSpace:		; Memory Address ($14E4) and binary offset [$1160]
	bra		Use_SelectedMonsterNavigationMap

Test_LevelResistanceRoll_FromPointer:		; Memory Address ($14E8) and binary offset [$1164]
	; Converts a monster or champion record pointer to the actor identifier
	; expected by the shared level-resistance test.
	move.l	a4,a1
	move.l	a1,d0
	cmpi.w	#$0000,d4
	bne.s	Test_LevelResistanceRoll_FromPointer_ChampionIndex
	sub.l	#UnpackedMonsters,d0
	lsr.w	#$04,d0
	add.w	#$0010,d0
	bra.s	Test_LevelResistanceRoll_FromPointer_TailJump

Test_LevelResistanceRoll_FromPointer_ChampionIndex:		; Memory Address ($1500) and binary offset [$117C]
	sub.l	#Character_Stats_DataTable,d0
	lsr.w	#$05,d0
Test_LevelResistanceRoll_FromPointer_TailJump:		; Memory Address ($1508) and binary offset [$1184]
	bra		Test_LevelResistanceRoll

Begin_MonsterAttackBehaviour:		; Memory Address ($150C) and binary offset [$1188]
	; Loads the live monster form and enters special-form or ordinary attack
	; processing.
	move.b	ActorRecord_Form(a4),d2
	bmi		Handle_SpecialMonsterFormMovement
	cmpi.b	#$40,d2
	beq.s	Normalise_MonsterFacingState
	cmpi.b	#$67,d2
	bcc.s	Normalise_MonsterFacingState
	tst.b	$000D(a4)
	bmi.s	Dispatch_MonsterActionState
Normalise_MonsterFacingState:		; Memory Address ($1526) and binary offset [$11A2]
	; Copies the current facing into both nibbles of the live monster
	; rotation/state byte when its form requires normalisation.
	and.b	#$03,$0002(a4)
	move.b	$0002(a4),d6
	asl.b	#$04,d6
	or.b	$0002(a4),d6
	move.b	d6,$0002(a4)
Dispatch_MonsterActionState:		; Memory Address ($153A) and binary offset [$11B6]
	; Checks the movement table, protected player actors, action state and level
	; before choosing the monster attack behaviour.
	bsr		Read_MonsterMovementTableEntry
	bpl		Store_MonsterRotationByte
	move.w	ActorScanRecordIndex.w,d1											;Short Absolute converted to symbol!
	cmp.b	Player1_ControlledActorScanIndex.l,d1
	beq		Return_MonsterBehaviour
	cmp.b	Player2_ControlledActorScanIndex.l,d1
	beq		Return_MonsterBehaviour
	move.b	$0005(a4),d1
	and.w	#$0060,d1
	bne		AttackType_Drone
	move.b	$0006(a4),d0
	move.b	$0007(a4),d1
	and.w	#$007F,d1
	and.w	#$007F,d0
	cmp.w	d0,d1
	bcc.s	Select_MonsterAttackType
	move.l	a4,a1
	clr.w	ResistanceCheckPower.l
	bsr		Test_LevelResistanceRoll
	tst.w	d5
	beq.s	Select_MonsterAttackType
	bchg	#$07,$0007(a4)
	beq.s	Select_MonsterAttackType
	addq.b	#$01,$0007(a4)
Select_MonsterAttackType:		; Memory Address ($1596) and binary offset [$1212]
	; Dispatches live monster type byte $0A through the five-entry attack-type
	; table.
	move.b	ActorRecord_BehaviourType(a4),d1									;Loads the live monster attack-type index.
	add.w	d1,d1																;Converts the attack-type index into a word-table byte offset.
	lea		AttackType_NoSpells.l,a1
	lea		MonsterAttackTypeTable.l,a0
	add.w	$00(a0,d1.w),a1														;Adds the selected signed displacement to the shared no-spells base.
	jmp		(a1)

MonsterAttackTypeTable:		; Memory Address ($15AE) and binary offset [$122A]
	; Five signed displacements for No Spells, Spells, Drone, Drone Spells and Arc
	; Bolt Machine behaviours.
	dc.w	AttackType_NoSpells-AttackType_NoSpells	;0000
	dc.w	AttackType_Spells-AttackType_NoSpells	;FF6C
	dc.w	AttackType_Drone-AttackType_NoSpells	;00F0
	dc.w	AttackType_DroneSpells-AttackType_NoSpells	;FF4E
	dc.w	AttackType_ArcBoltMachine-AttackType_NoSpells	;FFFA

AttackType_DroneSpells:		; Memory Address ($15B8) and binary offset [$1234]
	; Gives a spellcasting drone a one-in-sixteen chance to enter spell selection;
	; otherwise it uses Drone movement.
	bsr		RandomGen_BytewithOffset
	and.w	#MonsterAttackSpell_IndexMask,d0
	bne		AttackType_Drone													;Spellcasting drones move normally on fifteen of sixteen random rolls.
	bra.s	Select_MonsterAttackSpell

MonsterAttackSpells:		; Memory Address ($15C6) and binary offset [$1242]
	; Sixteen raw monster-spell selectors or complete airborne entity codes used by
	; the spellcasting attack types.
	INCBIN "/data/BLOODWYCH439-clean/data/monsters.spellbook.lookup"

AttackType_Spells:		; Memory Address ($15D6) and binary offset [$1252]
	; Allows a normal spellcasting monster to select a spell on two outcomes of the
	; shared random test; all other outcomes use no-spells behaviour.
	bsr		RandomGen_SixSidedRoll
	subq.b	#$02,d0																;Only random results zero and one proceed to spell selection; all others use no-spells behavior.
	bcc		AttackType_NoSpells
Select_MonsterAttackSpell:		; Memory Address ($15E0) and binary offset [$125C]
	; Selects one of sixteen monster spellbook entries, biasing lower-level
	; monsters toward earlier entries.
	bsr		RandomGen_BytewithOffset
	and.w	#MonsterAttackSpell_IndexMask,d0
	move.b	MonsterRecord_EffectiveLevel(a4),d3									;Uses the monster's base level as the spell-power seed.
	and.w	#$007F,d3
	cmpi.b	#$08,d3
	bcc.s	Create_MonsterAttackSpell
	lsr.w	#$01,d0																;Biases lower-level monsters toward earlier entries in the attack-spell table.
	cmpi.b	#$05,d3
	bcc.s	Create_MonsterAttackSpell
	lsr.w	#$01,d0																;Biases lower-level monsters toward earlier entries in the attack-spell table.
	cmpi.b	#$04,d3
	bcc.s	Create_MonsterAttackSpell
	lsr.w	#$01,d0																;Biases lower-level monsters toward earlier entries in the attack-spell table.
Create_MonsterAttackSpell:		; Memory Address ($1608) and binary offset [$1284]
	; Normalises the selected airborne code and calculates the projectile power
	; from the supplied seed.
	move.b	MonsterAttackSpells(pc,d0.w),d0										;Loads the raw spell selector or complete airborne code from the monster spellbook.
	move.w	d0,d4
	or.w	#AirbourneSpell_CodeBase,d4											;Normalises low selectors into the airborne spell-code range.
	move.w	d3,d6
	and.w	#MonsterAttackSpell_HighPowerFlag,d0
	or.b	d0,d3
	add.w	d3,d3																;Begins the shared three-times power calculation.
	add.b	d6,d3																;Completes three times the original power seed.
	cmpi.b	#$81,d4
	beq.s	Initialise_MonsterAttackSpellEntity
	cmpi.b	#$8E,d4
	beq.s	Initialise_MonsterAttackSpellEntity
	lsr.b	#$01,d3																;Applies normal three-halves projectile scaling; Wychwind and Spelltap retain triple power.
Initialise_MonsterAttackSpellEntity:		; Memory Address ($162C) and binary offset [$12A8]
	; Packs the live monster's facing, floor and X/Y position and calls the common
	; live-entity constructor.
	move.b	ActorRecord_RotationAndSpace(a4),d0									;Loads the casting monster's facing from the live record.
	and.w	#$0003,d0
	move.w	d0,d6
	swap	d6
	move.w	d0,d6
	moveq	#$00,d5
	move.b	ActorRecord_Floor(a4),d5											;Passes the caster's floor to the shared live spell-entity constructor.
	moveq	#$00,d7
	move.b	ActorRecord_XPosition(a4),d7
	swap	d7
	move.b	ActorRecord_YPosition(a4),d7
	move.b	#CharacterActionState_MonsterSpellStart,ActorRecord_ActionState(a4)	;Marks the monster as having launched a spell before allocating the projectile.
	move.l	a4,-(sp)
	move.b	#$FF,SpellEntity_CasterIndex.l
	bsr		SpellEntity_CheckPlacement
	move.l	(sp)+,a4
	rts		

AttackType_ArcBoltMachine:		; Memory Address ($1664) and binary offset [$12E0]
	; Fixed type-4 attack entry: selects monster spellbook index $0B with base
	; power $0C, producing Arc Bolt code $82 at final power $12.
	moveq	#ArcBoltMachine_BasePower,d3										;Supplies base power twelve; normal scaling stores final projectile power eighteen ($12).
	moveq	#MonsterAttackSpell_ArcBoltIndex,d0									;Selects spellbook entry eleven, whose raw $02 selector becomes Arc Bolt code $82.
	bra.s	Create_MonsterAttackSpell

AttackType_NoSpells:		; Memory Address ($166A) and binary offset [$12E6]
	; Begins pursuit logic by measuring the monster against the first fixed player
	; origin when the floor matches.
	moveq	#-$01,d2															;Initialises the first fixed-origin distance as unavailable.
	move.b	ActorRecord_Floor(a4),d1
	cmp.b	AttackTypeNoSpells_FixedOriginFormCode.l,d1
	bne.s	Check_SecondFixedMonsterOrigin
	move.l	AttackTypeNoSpells_FixedOriginPosition.l,d0
	move.l	d7,d1
	bsr		Calculate_ManhattanDistance											;Calculates distance from the monster to the first configured fixed origin when its form matches.
Check_SecondFixedMonsterOrigin:		; Memory Address ($1684) and binary offset [$1300]
	; Preserves the first fixed-origin distance and measures the second; this is
	; shared logic, not the Arc Bolt machine entry.
	move.w	d2,d3																;Preserves the first fixed-origin distance while checking the second origin.
	moveq	#-$01,d2
	move.b	ActorRecord_Floor(a4),d1
	cmp.b	AttackTypeArcBoltMachine_FixedOriginFormCode.l,d1
	bne.s	Choose_MonsterNavigationMap
	move.l	AttackTypeArcBoltMachine_FixedOriginPosition.l,d0
	move.l	d7,d1
	bsr		Calculate_ManhattanDistance											;Calculates distance from the monster to the second configured fixed origin when its form matches.
Choose_MonsterNavigationMap:		; Memory Address ($16A0) and binary offset [$131C]
	; Adjusts a valid second-origin distance and prepares selection of the nearer
	; fixed-origin navigation field.
	moveq	#$00,d4
	tst.w	d2
	bmi.s	Select_MonsterNavigationMapByDistance
	move.l	a4,d0
	sub.l	#MonsterBlock_mod0,d0
	lsr.w	#$04,d0
	add.b	$000B(a4),d0
	add.b	$0006(a4),d0
	and.w	#$0001,d0
	add.w	d0,d2
Select_MonsterNavigationMapByDistance:		; Memory Address ($16BE) and binary offset [$133A]
	; Selects the navigation field associated with the nearer valid fixed player
	; origin.
	lea		ReserveSpace_1.l,a6
	cmp.w	d2,d3																;Chooses the navigation field belonging to the nearer valid fixed origin.
	bcs.s	Use_SelectedMonsterNavigationMap
	lea		ReserveSpace_2.l,a6
Use_SelectedMonsterNavigationMap:		; Memory Address ($16CE) and binary offset [$134A]
	; Reads the selected navigation direction and turns or advances the live
	; monster accordingly.
	move.w	d7,d0
	mulu	CurrentFloorWidth.l,d0
	swap	d7
	add.w	d7,d0
	swap	d7
	move.b	$00(a6,d0.w),d0
	beq.s	AttackType_Drone
	cmpi.b	#$FF,d0
	beq.s	AttackType_Drone
	and.w	#$0003,d0
	move.b	$02(a4,d4.w),d6
	and.w	#$0003,d6
	cmp.w	d0,d6
	beq.s	AttackType_Drone
	eor.w	d0,d6
	subq.w	#$02,d6
	beq		AttackType_DroneBlockedTurn
	move.b	$02(a4,d4.w),d6
	bra		Normalise_MonsterFacing

Handle_SpecialMonsterFormMovement:		; Memory Address ($1708) and binary offset [$1384]
	; Handles the special movement preparation used by airborne entity forms $84
	; and $88.
	sub.b	#$84,d2
	bcs.s	AttackType_Drone
	beq.s	Validate_SpecialMonsterDestination
	subq.b	#$03,d2
	bne.s	AttackType_Drone
Validate_SpecialMonsterDestination:		; Memory Address ($1714) and binary offset [$1390]
	; Accepts eligible empty or matching destination-cell states for special-form
	; movement.
	not.w	d1
	and.w	#$0007,d1
	beq.s	Convert_SpecialMonsterCellToMagicFeature
	cmpi.w	#$0007,d1
	bne.s	AttackType_Drone
	tst.b	$00(a6,d0.w)
	bne.s	AttackType_Drone
Convert_SpecialMonsterCellToMagicFeature:		; Memory Address ($1728) and binary offset [$13A4]
	; Marks the destination cell and derives its stored feature power from the live
	; entity.
	or.b	#$07,$01(a6,d0.w)
	moveq	#$00,d1
	move.b	$0006(a4),d1
	cmp.b	#$84,$000B(a4)
	bne.s	Store_SpecialMonsterFeaturePower
	add.b	d1,d1
	cmpi.b	#$40,d1
	bcs.s	Store_SpecialMonsterFeaturePower
	moveq	#$3F,d1
Store_SpecialMonsterFeaturePower:		; Memory Address ($1746) and binary offset [$13C2]
	; Clamps and stores special feature power before removing the source live
	; entity.
	asl.b	#$02,d1
	addq.b	#$01,d1
	move.b	d1,$00(a6,d0.w)
	move.w	#$0100,d1
	move.b	$000C(a4),d1
	bsr		Formwall_PrepareLinkedFeature
AttackType_Drone:		; Memory Address ($175A) and binary offset [$13D6]
	; Attempts forward movement using the live monster facing and enters the
	; blocked-turn path if movement fails.
	move.b	$02(a4,d4.w),d6
	and.w	#$0003,d6
	bsr		Try_EnterMapCell
	bcs		Handle_MonsterMovementBlocked
	cmpi.w	#$0000,d4
	bne.s	Commit_MonsterMovementAndRotation
	cmp.b	#$85,$000B(a4)
	beq.s	Handle_Form85BlockedMovement
Commit_MonsterMovementAndRotation:		; Memory Address ($1778) and binary offset [$13F4]
	; Writes the new packed coordinate, refreshes movement-table state and commits
	; the resulting rotation byte.
	move.b	d7,$01(a4,d4.w)
	swap	d7
	move.b	d7,$00(a4,d4.w)
	swap	d7
	bsr		Read_MonsterMovementTableEntry
	and.w	#$0030,d0
	bsr		Store_MonsterRotationByte
	cmpi.b	#$00,d4
	bne.s	Resolve_MonsterEnteredCell
	tst.b	$000B(a4)
	bmi.s	Return_MonsterMovement
Resolve_MonsterEnteredCell:		; Memory Address ($179C) and binary offset [$1418]
	; Checks the entered cell for a linked feature record and dispatches its
	; interaction.
	bsr		CoordToMap
	move.w	$00(a6,d0.w),d1
	not.w	d1
	and.w	#$0007,d1
	bne.s	Return_MonsterMovement
	move.b	$00(a6,d0.w),d1
	move.w	d1,d7
	and.w	#$0003,d1
	subq.b	#$01,d1
	bne.s	Return_MonsterMovement
	lea		LinkedMagicRecordList.l,a0
	moveq	#-$04,d1
Find_MonsterLinkedFeatureLoop:		; Memory Address ($17C2) and binary offset [$143E]
	; Scans linked feature records for the map offset of the monster's entered
	; cell.
	addq.w	#$04,d1
	cmp.w	-$0002(a0),d1
	bcc.s	Return_MonsterMovement
	cmp.w	$02(a0,d1.w),d0
	bne.s	Find_MonsterLinkedFeatureLoop
	move.b	$01(a0,d1.w),SpellEntity_CasterIndex.l
	lsr.b	#$02,d7
	move.l	a4,-(sp)
	bsr		Roll_AndStagePartyDamage
	clr.w	ResistanceCheckPower.l
	bsr		Apply_SpellImpactAtOccupant
	move.l	(sp)+,a4
Return_MonsterMovement:		; Memory Address ($17EC) and binary offset [$1468]
	; Returns after the monster movement or entered-cell processing path.
	rts		

Handle_Form85BlockedMovement:		; Memory Address ($17EE) and binary offset [$146A]
	; Handles form $85 movement when the first destination cannot accept it.
	move.w	$00(a6,d0.w),d1
	not.b	d1
	and.w	#$0007,d1
	bne.s	Check_Form85AlternateCell
	move.b	$00(a6,d0.w),d1
	and.w	#$0003,d1
	subq.w	#$01,d1
	beq		Commit_MonsterMovementAndRotation
Check_Form85AlternateCell:		; Memory Address ($1808) and binary offset [$1484]
	; Checks the alternate map cell and converts the form to $80 when it cannot
	; move there.
	move.w	$00(a6,d2.w),d1
	not.b	d1
	and.w	#$0007,d1
	beq.s	Swap_Form85CellOccupancy
	move.b	#$80,$000B(a4)
	bra		Commit_MonsterMovementAndRotation

Swap_Form85CellOccupancy:		; Memory Address ($181E) and binary offset [$149A]
	; Moves form $85 occupancy between the two map cells and reverses its facing.
	bclr	#$07,$01(a6,d0.w)
	bset	#$07,$01(a6,d2.w)
	eor.b	#$02,$0002(a4)
	rts		

Monster_Movement_DataTable:		; Memory Address ($1832) and binary offset [$14AE]
	; Sixteen movement/rotation decisions indexed by current facing and the high
	; nibble of the live movement byte.
	dc.b	$B0	;B0
	dc.b	$A0	;A0
	dc.b	$10	;10
	dc.b	$00	;00
	dc.b	$10	;10
	dc.b	$80	;80
	dc.b	$B0	;B0
	dc.b	$20	;20
	dc.b	$30	;30
	dc.b	$20	;20
	dc.b	$90	;90
	dc.b	$80	;80
	dc.b	$90	;90
	dc.b	$00	;00
	dc.b	$30	;30
	dc.b	$A0	;A0

Read_MonsterMovementTableEntry:		; Memory Address ($1842) and binary offset [$14BE]
	; Builds a movement-table index from the live monster state and returns the
	; corresponding movement value.
	moveq	#$00,d6
	move.b	$02(a4,d4.w),d6
	move.w	d6,d0
	and.w	#$0003,d6
	move.w	d6,d2
	asl.w	#$02,d2
	lsr.w	#$04,d0
	add.w	d0,d2
	move.b	Monster_Movement_DataTable(pc,d2.w),d0								;Returns the movement/rotation decision for the live monster's state and facing.
	rts		

AttackType_ResolveForwardOccupant:		; Memory Address ($185C) and binary offset [$14D8]
	; Resolves the occupant of the monster's forward cell and dispatches attack,
	; joining or blocked-turn handling.
	clr.w	PhysicalAttack_DoubleDefenceFlag.l
	jsr		Resolve_DiagonalCellAndFindOccupant.l								;Resolves the actor or monster occupying the live monster's forward cell.
	bcc		AttackType_DroneBlockedTurn
	tst.b	d0
	bmi		Resolve_PlayerTargetAttack
	cmpi.b	#$10,d0
	bcs		CheckMonsterHeldObject
	move.b	$000B(a4),d2
	bmi		CheckMonsterHeldObject
	cmpi.b	#$64,d2
	bne.s	Resolve_MonsterTargetType
	move.b	$000C(a4),SpellEntity_CasterIndex.l
	bra		CheckMonsterHeldObject

Resolve_MonsterTargetType:		; Memory Address ($1894) and binary offset [$1510]
	; Distinguishes ordinary monsters, grouped monsters and eligible airborne
	; targets in the forward cell.
	cmp.b	#$64,$000B(a1)
	beq		CheckMonsterHeldObject
	cmpi.b	#$40,d2
	beq		AttackType_DroneBlockedTurn
	cmpi.b	#$67,d2
	bcc		AttackType_DroneBlockedTurn
	move.b	$000B(a1),d2
	bpl.s	Add_MonsterToTargetTeam
	cmpi.b	#$85,d2
	bne		AttackType_DroneBlockedTurn
	move.l	a4,-(sp)
	moveq	#$00,d7
	move.b	$0000(a4),d7
	swap	d7
	move.b	$0001(a4),d7
	bsr		CoordToMap
	bclr	#$07,$01(a6,d0.w)
	moveq	#$00,d7
	move.b	$0000(a1),d7
	move.b	d7,$0000(a4)
	swap	d7
	move.b	$0001(a1),d7
	move.b	d7,$0001(a4)
	bsr		CoordToMap
	move.l	a1,a4
	bsr		Gate_AirborneEntityFormRange
	move.l	(sp)+,a4
	rts		

Add_MonsterToTargetTeam:		; Memory Address ($18F6) and binary offset [$1572]
	; Creates or extends a target monster team when the attacker can join it.
	cmpi.b	#$40,d2
	beq		AttackType_DroneBlockedTurn
	cmpi.b	#$67,d2
	bcc		AttackType_DroneBlockedTurn
	tst.b	$000D(a4)
	bpl		AttackType_DroneBlockedTurn
	moveq	#$00,d3
	move.b	$000D(a1),d3
	bpl.s	Find_EmptyTargetTeamSlot
	lea		MonsterTeamIndexTable.l,a0
	addq.w	#$01,-$0002(a0)
	move.w	-$0002(a0),d3
	move.b	d3,$000D(a1)
	asl.w	#$02,d3
	sub.w	#$0010,d0
	move.l	#$FFFFFFFF,$00(a0,d3.w)
	move.b	d0,$00(a0,d3.w)
	lsr.w	#$02,d3
Find_EmptyTargetTeamSlot:		; Memory Address ($193C) and binary offset [$15B8]
	; Prepares the four-slot target-team record scan.
	asl.w	#$02,d3
	lea		MonsterTeamIndexTable.l,a0
	add.w	d3,a0
	moveq	#$03,d2
Find_EmptyTargetTeamSlotLoop:		; Memory Address ($1948) and binary offset [$15C4]
	; Scans the target monster team for an unused member slot.
	tst.b	$00(a0,d2.w)
	bmi.s	Move_MonsterIntoTargetTeam
	dbra	d2,Find_EmptyTargetTeamSlotLoop
	bra		AttackType_DroneBlockedTurn

Move_MonsterIntoTargetTeam:		; Memory Address ($1956) and binary offset [$15D2]
	; Stores the attacker in the target team, clears its map-cell occupancy and
	; removes its standalone position.
	move.l	a4,d0
	sub.l	#UnpackedMonsters,d0
	lsr.w	#$04,d0
	move.b	d0,$00(a0,d2.w)
	moveq	#$00,d7
	move.b	$0000(a4),d7
	swap	d7
	move.b	$0001(a4),d7
	move.b	#$FF,$0000(a4)
	bsr		CoordToMap
	bclr	#$07,$01(a6,d0.w)
	rts		

CheckMonsterHeldObject:		; Memory Address ($1982) and binary offset [$15FE]
	; Preserves the resolved target identifier before checking whether the
	; attacking entity can process it.
	move.w	d0,d1																;Copies the caller's interaction/level value into d1 because d0 is reused for monster-form tests.
CheckMonsterHeldObjectByLevel:		; Memory Address ($1984) and binary offset [$1600]
	; Routes ordinary monsters to team/melee handling and airborne entities to
	; held-object or worn-spell handling.
	move.b	ActorRecord_Form(a4),d0												;Loads the live monster form/graphic identifier into d0.
	bpl		Attack_TargetMonsterTeam											;Skips special held-object processing for a non-negative, ordinary monster form.
	cmpi.b	#$10,d1																;Checks whether the caller's level or interaction value is below the special-processing threshold $10.
	bcs.s	Resolve_MonsterHeldObjectTarget										;Enters the carried-object resolution path for values below the threshold.
	tst.b	MonsterRecord_CarriedObject(a4)										;Tests whether the monster's carried-object byte is negative, meaning no object has been assigned.
	bpl		Attack_TargetMonsterTeam											;Skips special held-object processing for a non-negative, ordinary monster form.
	rts																			;Returns without changing the monster when no special held-object action is required.

Resolve_MonsterHeldObjectTarget:		; Memory Address ($199C) and binary offset [$1618]
	; Resolves a champion target through its party slot and substitutes an
	; applicable held-object result.
	movem.l	d1/a5,-(sp)															;Saves d1 and a5 while the object/character lookup routines temporarily reuse them.
	move.w	d1,d0																;Passes the interaction/level value to the lookup routine in its expected argument register d0.
	bsr		Find_ChampionOwner													;Resolves the current interaction or level against the supporting object/character lookup data.
	tst.w	d1																	;Tests whether the lookup returned a valid result in d1.
	bmi.s	Restore_MonsterHeldObjectContext									;Falls back to the alternate result path when the first lookup failed.
	moveq	#$01,d1																;Selects the standard lookup variant used to resolve the monster's special interaction.
	move.l	a4,-(sp)															;Saves the live monster pointer before the lookup routine changes a4.
	bsr		Find_HighestRankedPartyMemberByCategory								;Performs the special object/character lookup using the selected interaction value.
	move.l	(sp)+,a4															;Restores a4 so subsequent field accesses again address the live monster record.
	tst.w	d3																	;Tests the secondary lookup result returned in d3.
	bmi.s	Restore_MonsterHeldObjectContext									;Falls back to the alternate result path when the first lookup failed.
	swap	d3																	;Swaps d3 so the resolved result word is available to the common path.
	movem.l	(sp)+,d1/a5															;Restores the saved interaction value and player pointer registers.
	move.w	d3,d1																;Copies the resolved interaction/character index into d1 for champion-record selection.
	bra.s	Check_TargetWornSpell												;Branches to the common champion-record processing path.

Restore_MonsterHeldObjectContext:		; Memory Address ($19C2) and binary offset [$163E]
	; Restores target and player context after the held-object lookup fails.
	movem.l	(sp)+,d1/a5															;Restores the saved interaction value and player pointer after the fallback lookup path.
Check_TargetWornSpell:		; Memory Address ($19C6) and binary offset [$1642]
	; Checks whether the target's worn-spell state launches an airborne entity back
	; toward the attacker.
	move.w	d1,d0																;Copies the selected champion/interaction index into d0 for record loading.
	move.l	a4,a2																;Preserves the live monster pointer in a2 while a4 is temporarily used for the champion record.
	bsr		Load_ChampionStatRecord												;Loads the selected champion's stat record into a4.
	exg		a4,a2																;Swaps a4 and a2 so a4 again addresses the monster and a2 addresses the selected champion.
	move.b	ChampionStat_WornSpell(a2),d0										;Reads the selected champion's worn-spell field.
	and.w	#$0007,d0															;Masks the spell field to its low three-bit spell code.
	subq.w	#$01,d0																;Normalises the spell code around the first spell entry before testing the required spell.
	bne.s	Attack_TargetMonsterTeam											;Skips the special action when the selected champion is not wearing the required spell.
	move.b	#$01,ChampionStat_WornSpell(a2)										;Sets the selected champion's worn-spell field to the required spell code.
	moveq	#$00,d7																;Clears d7 before assembling the monster's map coordinate.
	move.b	$0000(a4),d7														;Loads the monster X coordinate into the high-byte staging register d7.
	swap	d7																	;Moves the X coordinate into the high word so Y can be appended.
	move.b	$0001(a4),d7														;Loads the monster Y coordinate into the low byte of d7.
	bsr		CoordToMap															;Converts the monster coordinate into the current-map cell index.
	tst.b	$01(a6,d0.w)														;Tests the map cell's occupancy/visibility byte before attempting the special action.
	bpl.s	Launch_MonsterHeldSpell												;Continues when the target map cell is available for the action.
	move.w	d1,-(sp)															;Saves the resolved interaction/level value while checking the map cell occupant.
	bsr		Resolve_DiagonalCellAndFindOccupant									;Checks the selected map cell for an occupying character or monster.
	move.w	(sp)+,d1															;Restores the resolved interaction/level value after the occupancy check.
	tst.b	d0																	;Tests the occupancy result returned in d0.
	bmi		Attack_TargetMonsterTeam											;Aborts the special action when the map-cell check reports a blocking occupant.
Launch_MonsterHeldSpell:		; Memory Address ($1A06) and binary offset [$1682]
	; Builds and launches the reflected or worn airborne spell from the target
	; toward the attacker.
	moveq	#$00,d4																;Clears d4 before loading the monster form used by the movement/render calculation.
	move.b	$000B(a4),d4														;Loads the monster form/graphic identifier for downstream movement or effect selection.
	move.b	$0002(a4),d0														;Loads the live rotation/occupied-space byte into d0.
	and.w	#$0003,d0															;Masks d0 to the four facing/space variants represented by the low two bits.
	lea		MovementOffsetTable.l,a0											;Loads eight signed X deltas followed by eight signed Y deltas; entries zero through three are cardinal movement.
	add.b	$08(a0,d0.w),d7														;Adds the direction-specific Y adjustment to the packed monster coordinate.
	swap	d7																	;Swaps d7 to adjust the X half of the packed coordinate.
	add.b	$00(a0,d0.w),d7														;Adds the direction-specific X adjustment from the movement table.
	swap	d7																	;Swaps d7 to adjust the X half of the packed coordinate.
	eor.b	#$02,d0																;Toggles the direction bit used by the alternate movement/render variant.
	move.w	d0,d6																;Copies the direction variant into d6 for the following packed-coordinate setup.
	swap	d6																	;Moves the direction variant into the high word of d6.
	move.w	d0,d6																;Copies the direction variant into d6 for the following packed-coordinate setup.
	moveq	#$00,d5																;Clears d5 before loading the monster floor.
	move.b	$0004(a4),d5														;Loads the monster floor used by the downstream map/effect lookup.
	move.b	$0006(a4),d3														;Loads the monster's current level for the level-dependent lookup.
	and.w	#$007F,d3															;Masks the level to the supported seven-bit level range.
	add.w	d3,d3																;Doubles the level to form a word-table index.
	move.b	d1,SpellEntity_CasterIndex.l										;Stores the resolved level/index value in the shared special-object scratch byte.
	bra		SpellEntity_CheckPlacement											;Branches to the common special-object handling routine with the prepared registers.

Attack_TargetMonsterTeam:		; Memory Address ($1A4A) and binary offset [$16C6]
	; Applies the attack to one or two live members of the target monster team.
	moveq	#$00,d3
	move.b	$000D(a4),d3
	bmi.s	AttackType_MonsterMelee
	move.l	a4,-(sp)
	asl.w	#$02,d3
	lea		MonsterTeamIndexTable.l,a0
	add.w	d3,a0
	moveq	#$01,d0
Attack_TargetMonsterTeamLoop:		; Memory Address ($1A60) and binary offset [$16DC]
	; Iterates the target team member slots selected for the attack.
	moveq	#$00,d3
	move.b	$00(a0,d0.w),d3
	bmi.s	Advance_TargetMonsterTeamSlot
	movem.l	d0/d1/a0,-(sp)
	lea		UnpackedMonsters.l,a4
	asl.w	#$04,d3
	add.w	d3,a4
	bsr.s	AttackType_MonsterMelee
	movem.l	(sp)+,d0/d1/a0
Advance_TargetMonsterTeamSlot:		; Memory Address ($1A7C) and binary offset [$16F8]
	; Advances to the next selected target-team member.
	dbra	d0,Attack_TargetMonsterTeamLoop
	move.l	(sp)+,a4
	rts		

AttackType_MonsterMelee:		; Memory Address ($1A84) and binary offset [$1700]
	; Runs monster melee through the shared physical-attack and damage pipeline
	; with backstabbing disabled.
	move.l	a4,d3
	sub.l	#UnpackedMonsters,d3
	lsr.w	#$04,d3
	add.w	#$0010,d3
	move.b	#$07,$0005(a4)
	move.l	a4,-(sp)
	move.w	d1,-(sp)
	move.w	#$FFFF,PhysicalAttack_BackstabState.l
	bsr		Resolve_PhysicalAttack												;Runs the monster's physical attack through the common combat resolver.
	move.w	(sp)+,d0
	move.w	$0000(a6),d5
	bsr		Apply_AttackDamage
	move.l	(sp)+,a4
	rts		

Resolve_PlayerTargetAttack:		; Memory Address ($1AB6) and binary offset [$1732]
	; Resolves the forward player target and clears its queued attack state before
	; applying the monster or entity attack.
	bsr		RandomGen_BytewithOffset
	move.w	d0,d2
	and.w	#$0001,d2
	moveq	#$00,d0
	move.b	$0002(a4),d0
	bsr		Select_MonsterMeleePartyTarget
	tst.b	$000B(a4)
	bpl		CheckMonsterHeldObjectByLevel
	movem.l	d0/d1/a5,-(sp)
	move.l	a1,a5
	move.w	d1,d0
	bsr		Find_ChampionInPlayerSlots
	bclr	d1,$003C(a5)
	clr.w	PhysicalAttack_DoubleDefenceFlag.l
	movem.l	(sp)+,d0/d1/a5
	bra		CheckMonsterHeldObjectByLevel

Handle_MonsterMovementBlocked:		; Memory Address ($1AF0) and binary offset [$176C]
	; Handles blocked monster movement, party-member separation, doors, occupants
	; and random turns.
	move.w	ActorScanRecordIndex.w,d1											;Short Absolute converted to symbol!
	cmp.b	Player1_ControlledActorScanIndex.l,d1
	beq		Return_MonsterBehaviour
	cmp.b	Player2_ControlledActorScanIndex.l,d1
	beq		Return_MonsterBehaviour
	cmpi.w	#$0000,d4
	beq.s	Handle_BlockedMonsterAtDoor
	tst.w	PartyFormationActivationFlag.w										;Short Absolute converted to symbol!
	beq		AttackType_DroneBlockedTurn
	movem.w	d0/d2,-(sp)
	bsr		Resolve_DiagonalCellAndFindOccupant
	movem.w	(sp)+,d1/d2
	tst.b	d0
	bpl		AttackType_DroneBlockedTurn
	cmp.l	a1,a5
	bne		AttackType_DroneBlockedTurn
	bclr	#$07,$01(a6,d2.w)
	move.l	a4,d0
	sub.l	#Character_Stats_DataTable,d0
	lsr.w	#$05,d0
	bsr		Find_ChampionInPlayerSlots
	bclr	#$05,$18(a5,d1.w)
	move.b	d0,$0034(a5)
	cmp.b	$0053(a5),d0
	bne.s	Find_FreePartyAvatarSlot
	move.b	#$FF,$0053(a5)
	clr.b	$0014(a5)
Find_FreePartyAvatarSlot:		; Memory Address ($1B5C) and binary offset [$17D8]
	; Prepares the scan for a free separated-party-member slot.
	moveq	#$03,d7
Find_FreePartyAvatarSlotLoop:		; Memory Address ($1B5E) and binary offset [$17DA]
	; Scans the four separated-party-member slots for an unused entry.
	tst.b	$26(a5,d7.w)
	bmi.s	Store_SeparatedChampion
	dbra	d7,Find_FreePartyAvatarSlotLoop
Store_SeparatedChampion:		; Memory Address ($1B68) and binary offset [$17E4]
	; Stores the separated champion index and removes its current live actor
	; record.
	move.b	d0,$26(a5,d7.w)
	move.b	#$FF,$0016(a4)
	rts		

Handle_BlockedMonsterAtDoor:		; Memory Address ($1B74) and binary offset [$17F0]
	; Routes a blocked ordinary monster through door opening, actor collision or
	; airborne collision handling.
	tst.b	$000B(a4)
	bmi		Resolve_AirborneEntityCollisionForm
	cmp.b	#$15,$000B(a4)
	beq.s	AttackType_DroneBlockedTurn
	cmp.b	#$16,$000B(a4)
	beq.s	AttackType_DroneBlockedTurn
	cmp.w	d2,d0
	bne.s	Check_BlockedDestinationOccupant
	move.w	$00(a6,d0.w),d1
	and.w	#$0007,d1
	subq.w	#$02,d1
	bne		ClearAdjacentCellStateBit_IfNotBlocked
	bra.s	Open_DoorForMonster

Check_BlockedDestinationOccupant:		; Memory Address ($1BA0) and binary offset [$181C]
	; Checks whether another occupant, rather than a closed door, caused the
	; blocked move.
	move.b	$01(a6,d0.w),d2
	bpl.s	AttackType_DroneBlockedTurn
	move.b	#$FF,SpellEntity_CasterIndex.l
	and.w	#$0007,d2
	subq.w	#$01,d2
	bne		AttackType_ResolveForwardOccupant
AttackType_DroneBlockedTurn:		; Memory Address ($1BB8) and binary offset [$1834]
	; Chooses a random left or right quarter-turn when Drone movement is blocked.
	bsr		RandomGen_BytewithOffset
	or.w	#$0001,d0
	move.b	$02(a4,d4.w),d6
	add.w	d6,d0
Normalise_MonsterFacing:		; Memory Address ($1BC6) and binary offset [$1842]
	; Reduces the proposed facing to two bits before merging it into the live
	; rotation byte.
	and.w	#$0003,d0
	and.w	#$00F0,d6
Store_MonsterRotationByte:		; Memory Address ($1BCE) and binary offset [$184A]
	; Merges the new facing with preserved rotation/state bits and stores the live
	; monster rotation byte.
	or.b	d6,d0
	move.b	d0,$02(a4,d4.w)
Return_MonsterBehaviour:		; Memory Address ($1BD4) and binary offset [$1850]
	; Returns from the current monster behaviour without another action.
	rts		

Open_DoorForMonster:		; Memory Address ($1BD6) and binary offset [$1852]
	; Clears the relevant closed-door edge bit when the blocked monster is allowed
	; to open the door.
	move.b	$0002(a4),d6
	and.w	#$0003,d6
	move.b	$00(a6,d0.w),d1
	add.w	d6,d6
	addq.w	#$01,d6
	btst	d6,$00(a6,d0.w)
	beq.s	ClearAdjacentCellStateBit_IfNotBlocked
	subq.w	#$01,d6
	btst	d6,$00(a6,d0.w)
	beq.s	ClearAdjacentCellStateBit_IfNotBlocked
	btst	#$04,$01(a6,d0.w)
	bne.s	AttackType_DroneBlockedTurn
	bclr	d6,$00(a6,d0.w)
	rts		

ClearAdjacentCellStateBit_IfNotBlocked:		; Memory Address ($1C02) and binary offset [$187E]
	moveq	#$00,d7
	move.b	$0000(a4),d7
	swap	d7
	move.b	$0001(a4),d7
	move.b	$0002(a4),d0
	and.w	#$0003,d0
	move.w	d0,d6
	bsr		AdjacentCoordToMapOffset
	move.w	$00(a6,d0.w),d1
	and.w	#$0007,d1
	subq.w	#$02,d1
	bne.s	AttackType_DroneBlockedTurn
	btst	#$04,$01(a6,d0.w)
	bne.s	AttackType_DroneBlockedTurn
	eor.b	#$02,d6
	add.w	d6,d6
	addq.w	#$01,d6
	btst	d6,$00(a6,d0.w)
	beq		AttackType_DroneBlockedTurn
	subq.w	#$01,d6
	bclr	d6,$00(a6,d0.w)
	rts		

AirborneEntity_CheckCoordMatch:		; Memory Address ($1C48) and binary offset [$18C4]
	cmp.w	d0,d2
	bne		AirborneEntity_AllocateImpactCheckOccupant
AirborneEntity_ComputeDropDirection:		; Memory Address ($1C4E) and binary offset [$18CA]
	; Handles projectile forms $88-$8A: forms $88 and $89 drop objects $03 and $04
	; at the direction-derived corner, while form $8A maps to object $05 but
	; deliberately skips the drop call.
	move.b	$0002(a4),d6
	and.w	#$0003,d6
	cmpi.w	#$0002,d6
	bcs.s	AirborneEntity_DropObjectAndRemoveMonster
	eor.w	#$0001,d6
AirborneEntity_DropObjectAndRemoveMonster:		; Memory Address ($1C60) and binary offset [$18DC]
	moveq	#$00,d1
	move.b	$000B(a4),d1
	sub.b	#$85,d1
	movem.w	d0/d1/d6,-(sp)
	bsr		Remove_MonsterRecord
	movem.w	(sp)+,d0/d1/d6
	cmpi.w	#$0005,d1
	beq.s	AirborneEntity_SharedReturn
	moveq	#$01,d5
	swap	d5
	move.w	d1,d5
	bra		Add_FloorObjectToStack

AirborneEntity_AllocateImpactCheckOccupant:		; Memory Address ($1C86) and binary offset [$1902]
	moveq	#$00,d7
	move.b	$000B(a4),d7
	bsr		Queue_MapCellEffect
	tst.b	$01(a6,d0.w)
	bmi.s	ResolvePhysicalDamage_FromScratchRecord
	eor.b	#$02,$0002(a4)
	bra.s	AirborneEntity_ComputeDropDirection

ResolvePhysicalDamage_FromScratchRecord:		; Memory Address ($1C9E) and binary offset [$191A]
	; Builds the temporary projectile attacker record, preserving projectile power
	; as its monster-level input before entering the physical-damage resolver.
	movem.l	a4/a5,-(sp)
	lea		ProjectileImpact_MonsterRecordScratch.l,a0
	moveq	#$03,d1
CopyMonsterRecord_ToScratchLoop:		; Memory Address ($1CAA) and binary offset [$1926]
	move.l	(a4)+,(a0)+
	dbra	d1,CopyMonsterRecord_ToScratchLoop
	sub.w	#$0010,a4
	move.w	d0,d4
	bsr		Remove_MonsterRecord
	move.w	d4,d0
	lea		ProjectileImpact_MonsterRecordScratch.l,a4
	move.b	$000C(a4),SpellEntity_CasterIndex.l
	bsr		AttackType_ResolveForwardOccupant
	movem.l	(sp)+,a4/a5
AirborneEntity_SharedReturn:		; Memory Address ($1CD2) and binary offset [$194E]
	rts		

Move_AirborneEntityAfterDeflection:		; Memory Address ($1CD4) and binary offset [$1950]
	; Turns an airborne entity, validates the new cell and commits its coordinate
	; when clear.
	bsr		AttackType_DroneBlockedTurn
	move.w	d0,d6
	and.w	#$0003,d6
	bsr		Try_EnterMapCell
	bcs.s	Reverse_HeadOnAirborneEntity
	move.b	d7,$0001(a4)
	swap	d7
	move.b	d7,$0000(a4)
	rts		

Reverse_HeadOnAirborneEntity:		; Memory Address ($1CF0) and binary offset [$196C]
	; Reverses the airborne entity when the collision is with its current
	; destination cell.
	cmp.w	d0,d2
	bne.s	Resolve_AirborneEntityCollisionForm
	eor.b	#$02,$0002(a4)
	rts		

Resolve_AirborneEntityCollisionForm:		; Memory Address ($1CFC) and binary offset [$1978]
	; Converts form $84 to $85 with increased power or routes other airborne
	; collision forms.
	cmp.b	#$84,$000B(a4)
	bne.s	Resolve_AirborneEntityCollision
	move.b	#$85,$000B(a4)
	move.b	$0006(a4),d1
	addq.w	#$04,d1
	asl.w	#$02,d1
	move.b	d1,$0006(a4)
Reverse_AirborneEntityDirection:		; Memory Address ($1D16) and binary offset [$1992]
	; Reverses the live airborne entity's facing and returns.
	eor.b	#$02,$0002(a4)
	rts		

Resolve_AirborneEntityCollision:		; Memory Address ($1D1E) and binary offset [$199A]
	; Selects deflection, reversal or impact behaviour from the colliding entity
	; form and cell.
	cmp.w	d2,d0
	bne.s	Validate_Form85CollisionCell
	cmp.b	#$85,$000B(a4)
	beq.s	Reverse_AirborneEntityDirection
	cmp.b	#$82,$000B(a4)
	beq.s	Move_AirborneEntityAfterDeflection
Validate_Form85CollisionCell:		; Memory Address ($1D32) and binary offset [$19AE]
	; Checks whether form $85 may persist in the collided map cell.
	cmp.b	#$85,$000B(a4)
	bne.s	Clear_AirborneDestinationOccupancy
	move.w	$00(a6,d0.w),d1
	not.b	d1
	and.w	#$0007,d1
	bne.s	Reverse_AirborneEntityDirection
	move.b	$00(a6,d0.w),d1
	and.w	#$0003,d1
	subq.w	#$01,d1
	bne.s	Reverse_AirborneEntityDirection
Clear_AirborneDestinationOccupancy:		; Memory Address ($1D52) and binary offset [$19CE]
	; Clears the destination-cell occupancy bit before resolving the airborne
	; entity impact.
	bclr	#$07,$01(a6,d2.w)
Gate_AirborneEntityFormRange:		; Memory Address ($1D58) and binary offset [$19D4]
	; Routes airborne entity forms $88-$8A to the special impact path and forms $8B
	; or above to the alternate dispatch.
	cmp.b	#$88,$000B(a4)
	bcs.s	Pack_AirborneImpactCodeAndPower
	cmp.b	#$8B,$000B(a4)
	bcs		AirborneEntity_CheckCoordMatch
Pack_AirborneImpactCodeAndPower:		; Memory Address ($1D6A) and binary offset [$19E6]
	; Packs live airborne power and form into the impact value, clearing power for
	; non-airborne forms.
	moveq	#$00,d7
	move.b	$0006(a4),d7
	swap	d7
	move.b	$000B(a4),d7
	bmi.s	Dispatch_AirborneEntityImpact
	clr.w	d7
Dispatch_AirborneEntityImpact:		; Memory Address ($1D7A) and binary offset [$19F6]
	; Sets floor, caster and sound context before resolving the live airborne
	; entity's cell impact.
	moveq	#$00,d1
	move.b	$0004(a4),d1
	move.w	d0,d4
	move.b	$000C(a4),SpellEntity_CasterIndex.l
	bmi.s	PrepareTeleportOrEquip_RemoveThenResolve
	movem.l	d0/a0,-(sp)
	cmpi.b	#$83,d7
	beq.s	PrepareTeleportOrEquip_LoadAltSpellSound
	moveq	#$04,d0
	cmpi.b	#$8B,d7
	bcs.s	PrepareTeleportOrEquip_PlaySelectedSound
PrepareTeleportOrEquip_LoadAltSpellSound:		; Memory Address ($1D9E) and binary offset [$1A1A]
	moveq	#Sound_AlternativeSpell,d0
PrepareTeleportOrEquip_PlaySelectedSound:		; Memory Address ($1DA0) and binary offset [$1A1C]
	jsr		PlaySound.l
	movem.l	(sp)+,d0/a0
PrepareTeleportOrEquip_RemoveThenResolve:		; Memory Address ($1DAA) and binary offset [$1A26]
	bsr		Remove_MonsterRecord
	move.w	d4,d0
	move.l	a4,-(sp)
	bsr.s	Resolve_AirborneSpellCellEntry
	move.l	(sp)+,a4
	sub.w	#$0010,a4
TeleportOrSpellEntry_SharedReturn:		; Memory Address ($1DBA) and binary offset [$1A36]
	rts		

Queue_MapCellEffect:		; Memory Address ($1DBC) and binary offset [$1A38]
	; Sets the pending-effect bit on a map cell and appends its map offset and
	; encoded effect value to the cell-effect queue.
	bset	#$05,$01(a6,d0.w)
	asl.b	#$02,d7
	addq.w	#$02,d7
	lea		MapCellImpactList.l,a0
	move.w	-$0002(a0),d2
	addq.w	#$01,-$0002(a0)
	asl.w	#$02,d2
	move.w	d0,$00(a0,d2.w)
	move.w	d7,$02(a0,d2.w)
	rts		

Resolve_AirborneSpellCellEntry:		; Memory Address ($1DE0) and binary offset [$1A5C]
	; Queues an airborne-spell impact, resolves eligible cell occupants, and
	; handles the empty or blocked-cell sound path.
	bsr.s	Queue_MapCellEffect
	swap	d7
	move.b	$01(a6,d0.w),d5
	bpl.s	TeleportOrSpellEntry_SharedReturn
	and.w	#$0007,d5
	subq.w	#$01,d5
	beq.s	TeleportOrSpellEntry_SharedReturn
	movem.l	d0-d7/a0-a6,-(sp)
	bsr		Resolve_DiagonalCellAndFindOccupant
	bcs.s	AirborneSpell_PlayWallBounceSound
	movem.l	(sp)+,d0-d7/a0-a6
	bclr	#$07,$01(a6,d0.w)
	bra.s	TeleportOrSpellEntry_SharedReturn

AirborneSpell_PlayWallBounceSound:		; Memory Address ($1E08) and binary offset [$1A84]
	tst.b	d0
	bpl.s	AirborneSpell_RestoreAndDispatchDamage
	swap	d7
	move.b	d7,d5
	swap	d7
	lsr.b	#$02,d5
	cmpi.b	#$03,d5
	beq.s	AirborneSpell_RestoreAndDispatchDamage
	cmpi.b	#$0B,d5
	bcc.s	AirborneSpell_RestoreAndDispatchDamage
	moveq	#Sound_SpellRoar,d0
	jsr		PlaySound.l
AirborneSpell_RestoreAndDispatchDamage:		; Memory Address ($1E28) and binary offset [$1AA4]
	movem.l	(sp)+,d0-d7/a0-a6
	move.b	d7,d5
	and.w	#$007F,d5
	move.w	d5,ResistanceCheckPower.l
	tst.b	d7
	bmi.s	AirborneSpell_DispatchSpecialForm
	bsr.s	Roll_AndStagePartyDamage
	bra		Apply_SpellImpactAtOccupant

Roll_AndStagePartyDamage:		; Memory Address ($1E42) and binary offset [$1ABE]
	; Rolls (power+1) six-sided values in the range 0-5, adds a further (power+1),
	; clamps the result to $FD, and stages the same damage byte for all four party
	; slots.
	move.w	#$FFFF,AirborneSpellSplashFlag.l
	move.w	d0,-(sp)
	move.w	d7,d5
	addq.w	#$01,d5
SpellPartyDamage_DiceRollLoop:		; Memory Address ($1E50) and binary offset [$1ACC]
	bsr		RandomGen_SixSidedRoll
	add.w	d0,d5
	dbra	d7,SpellPartyDamage_DiceRollLoop
	move.w	(sp)+,d0
	move.w	d5,-(sp)
	cmpi.w	#$0100,d5
	bcs.s	SpellPartyDamage_BeginScratchStore
	move.w	#$00FD,d5
SpellPartyDamage_BeginScratchStore:		; Memory Address ($1E68) and binary offset [$1AE4]
	moveq	#$03,d1
	lea		FormationSlot_ScratchBytes.l,a0
SpellPartyDamage_StoreScratchLoop:		; Memory Address ($1E70) and binary offset [$1AEC]
	move.b	d5,$00(a0,d1.w)
	dbra	d1,SpellPartyDamage_StoreScratchLoop
	move.w	(sp)+,d5
	swap	d5
	move.w	#$FFFF,d5
	swap	d5
	rts		

AirborneSpell_DispatchSpecialForm:		; Memory Address ($1E84) and binary offset [$1B00]
	swap	d7
	lsr.b	#$02,d7
	cmpi.b	#$03,d7
	beq		Apply_DisruptEffect
	cmpi.b	#$0B,d7
	beq		ConfuseSpell_ForwardCellEntry
	cmpi.b	#$0C,d7
	beq		AirborneSpell_ResolveOccupantForParalyze
	cmpi.b	#$0F,d7
	beq		AirborneSpell_ResolveOccupantForFear
	cmpi.b	#$0E,d7
	beq.s	AirborneSpell_HalveStatWithResistanceRoll
	rts		

AirborneSpell_HalveStatWithResistanceRoll:		; Memory Address ($1EB0) and binary offset [$1B2C]
	bsr		Resolve_DiagonalCellAndFindOccupant
	bcc.s	AirborneSpell_HalveStat_SharedReturn
	tst.b	d0
	bmi.s	SpelltapEffect_ApplyToWholeParty_Begin
	cmpi.b	#$10,d0
	bcs.s	Apply_SpelltapEffect
	move.b	$0007(a1),d5
	and.b	#$7F,d5
	lsr.b	#$01,d5
	move.b	d5,$0007(a1)
	bsr		Test_LevelResistanceRoll
	tst.w	d5
	beq.s	AirborneSpell_HalveStat_SharedReturn
	clr.b	$0007(a1)
AirborneSpell_HalveStat_SharedReturn:		; Memory Address ($1EDA) and binary offset [$1B56]
	rts		

Apply_SpelltapEffect:		; Memory Address ($1EDC) and binary offset [$1B58]
	; Clears worn magic, rolls resistance, drains spell points, and adds the drain
	; to casting fatigue with a cap of 100.
	clr.b	ChampionStat_WornSpell(a1)											;Clears the champion's worn-spell effect before applying Spelltap resistance and drain.
	move.w	ResistanceCheckPower.l,d5
	bsr		Resolve_LevelResistanceRoll
	move.b	ChampionStat_SpellPointsCurrent(a1),d1
	sub.b	d5,d1
	bcc.s	SpelltapEffect_ClampSPAtZero
	moveq	#$00,d1
SpelltapEffect_ClampSPAtZero:		; Memory Address ($1EF4) and binary offset [$1B70]
	move.b	d1,ChampionStat_SpellPointsCurrent(a1)
	move.b	ChampionStat_SpellCooldown(a1),d1
	add.b	d5,d1
	cmpi.b	#$64,d1
	bcs.s	SpelltapEffect_ClampFatigueAt100
	moveq	#$64,d1
SpelltapEffect_ClampFatigueAt100:		; Memory Address ($1F06) and binary offset [$1B82]
	move.b	d1,ChampionStat_SpellCooldown(a1)
	rts		

SpelltapEffect_ApplyToWholeParty_Begin:		; Memory Address ($1F0C) and binary offset [$1B88]
	moveq	#$03,d7
	moveq	#$05,d0
	jsr		PlaySound.l
SpelltapEffect_PartyMemberLoop:		; Memory Address ($1F16) and binary offset [$1B92]
	moveq	#$00,d0
	move.b	$18(a1,d7.w),d0
	move.w	d0,d1
	and.w	#$00E0,d0
	bne.s	SpelltapEffect_PartyLoopIterationEnd
	and.w	#$000F,d1
	move.w	d1,d0
	bsr		Load_ChampionStatRecord
	move.w	d1,d0
	exg		a1,a4
	bsr.s	Apply_SpelltapEffect
	exg		a1,a4
SpelltapEffect_PartyLoopIterationEnd:		; Memory Address ($1F36) and binary offset [$1BB2]
	dbra	d7,SpelltapEffect_PartyMemberLoop
	move.l	a5,-(sp)
	move.l	a1,a5
	bsr		Draw_PartyCommandInterface
	bsr		Refresh_CurrentChampionMapPositionIcon
	move.l	(sp)+,a5
	rts		

AirborneSpell_ResolveOccupantForFear:		; Memory Address ($1F4A) and binary offset [$1BC6]
	bsr		Resolve_DiagonalCellAndFindOccupant
	bcc.s	ThreatFear_SharedReturn
Comms_ApplyThreatFear:		; Memory Address ($1F50) and binary offset [$1BCC]
	; Clears the target's speed nibble, applies Confuse, then converts the same
	; champion or monster status byte from Confuse to Terror; dormant monsters
	; receive no status conversion.
	moveq	#ChampionStat_ActionCycleTimer,d4
	tst.b	d0
	bmi.s	ThreatFear_SharedReturn
	cmpi.b	#$10,d0
	bcs.s	ThreatFear_ConvertConfuseBitToTerror
	moveq	#MonsterRecord_ActionCycleTimer,d4
ThreatFear_ConvertConfuseBitToTerror:		; Memory Address ($1F5E) and binary offset [$1BDA]
	and.b	#CharacterActionTimer_ReloadMask,$00(a1,d4.w)
	bsr		Apply_ConfuseEffect
	bclr	#CharacterActionState_ConfuseBit,CharacterState_ActionStateFromFacingOffset(a1,d4.w)
	beq.s	ThreatFear_SharedReturn
	bset	#CharacterActionState_TerrorBit,CharacterState_ActionStateFromFacingOffset(a1,d4.w)
ThreatFear_SharedReturn:		; Memory Address ($1F76) and binary offset [$1BF2]
	rts		

AirborneSpell_ResolveOccupantForParalyze:		; Memory Address ($1F78) and binary offset [$1BF4]
	bsr		Resolve_DiagonalCellAndFindOccupant
	bcc.s	ParalyzeEffect_SharedReturn
	moveq	#CharacterState_ChampionRecordBias,d4
	tst.b	d0
	bmi.s	ParalyzeEffect_ApplyToWholeParty_Begin
	cmpi.b	#$10,d0
	bcs.s	Apply_ParalyzeEffect
	moveq	#$00,d4
Apply_ParalyzeEffect:		; Memory Address ($1F8C) and binary offset [$1C08]
	; Runs the target resistance roll and sets paralysis plus the maximum
	; action-delay nibble when resistance fails.
	bsr		Test_LevelResistanceRoll
	tst.w	d5
	beq.s	ParalyzeEffect_SharedReturn
	bset	#CharacterActionState_ParalyzeBit,ActorRecord_ActionState(a1,d4.w)	;Sets Paralyse in the action-state byte selected for either a monster or champion record.
	or.b	#CharacterActionTimer_MaxCountdown,MonsterRecord_ActionCycleTimer(a1,d4.w)	;Forces the matching monster or champion action-cycle countdown to its maximum without changing the reload nibble.
ParalyzeEffect_SharedReturn:		; Memory Address ($1FA0) and binary offset [$1C1C]
	rts		

ParalyzeEffect_ApplyToWholeParty_Begin:		; Memory Address ($1FA2) and binary offset [$1C1E]
	moveq	#$03,d7
	moveq	#$05,d0
	jsr		PlaySound.l
ParalyzeWholeParty_LoopHead:		; Memory Address ($1FAC) and binary offset [$1C28]
	moveq	#$00,d0
	move.b	$18(a1,d7.w),d0
	move.w	d0,d1
	and.w	#$00E0,d0
	bne.s	ParalyzeWholeParty_LoopSkipSlot
	and.w	#$000F,d1
	move.w	d1,d0
	bsr		Load_ChampionStatRecord
	move.w	d1,d0
	exg		a1,a4
	bsr.s	Apply_ParalyzeEffect
	exg		a1,a4
ParalyzeWholeParty_LoopSkipSlot:		; Memory Address ($1FCC) and binary offset [$1C48]
	dbra	d7,ParalyzeWholeParty_LoopHead
	rts		

Apply_DisruptEffect:		; Memory Address ($1FD2) and binary offset [$1C4E]
	move.w	#$FFFF,AirborneSpellSplashFlag.l
	movem.w	d0/d1,-(sp)
	moveq	#-$01,d5
	bsr		Resolve_DiagonalCellAndFindOccupant
	bcc.s	Seed_DisruptDamage_EarlyReturn
	move.w	d0,-(sp)
	bsr.s	Seed_DisruptDamage
	move.w	(sp),d0
	tst.b	d0
	bmi.s	DisruptEffect_TwoResistancePassTail
	cmpi.b	#$10,d0
	bcs.s	DisruptEffect_OneResistancePassTail
	addq.w	#$02,sp
	move.b	$0006(a1),d7
	lsr.b	#$02,d7
	beq.s	DisruptEffect_DispatchImpact
	move.w	d0,-(sp)
	subq.b	#$01,d7
	beq.s	DisruptEffect_OneResistancePassTail
	subq.b	#$01,d7
	beq.s	DisruptEffect_TwoResistancePassTail
	bsr		Resolve_LevelResistanceRoll
	move.w	(sp),d0
DisruptEffect_TwoResistancePassTail:		; Memory Address ($2010) and binary offset [$1C8C]
	bsr		Resolve_LevelResistanceRoll
DisruptEffect_OneResistancePassTail:		; Memory Address ($2014) and binary offset [$1C90]
	movem.w	(sp)+,d0
	bsr		Resolve_LevelResistanceRoll
DisruptEffect_DispatchImpact:		; Memory Address ($201C) and binary offset [$1C98]
	movem.w	(sp)+,d0/d1
	bra		Apply_SpellImpactAtOccupant

Seed_DisruptDamage:		; Memory Address ($2024) and binary offset [$1CA0]
	; Seeds Disrupt damage from the target's hit points and level before its tiered
	; resistance passes.
	tst.b	d0
	bmi.s	Seed_DisruptDamage_PartyEntry
	cmpi.b	#$10,d0
	bcs.s	Seed_DisruptDamage_ChampionHP
	clr.w	d5
	cmp.b	#$15,$0006(a1)
	bcc.s	Seed_DisruptDamage_EarlyReturn
	move.w	$0008(a1),d5
	addq.w	#$01,d5
Seed_DisruptDamage_EarlyReturn:		; Memory Address ($203E) and binary offset [$1CBA]
	rts		

Seed_DisruptDamage_ChampionHP:		; Memory Address ($2040) and binary offset [$1CBC]
	clr.w	d5
	move.b	ChampionStat_HitPointsCurrent(a1),d5
	addq.b	#$01,d5
	rts		

Seed_DisruptDamage_PartyEntry:		; Memory Address ($204A) and binary offset [$1CC6]
	moveq	#$05,d0
	jsr		PlaySound.l
	moveq	#$01,d2
	lea		FormationSlot_ScratchBytes.l,a0
	clr.l	(a0)
	move.l	a4,-(sp)
	moveq	#$03,d7
Seed_DisruptDamage_PartyLoopHead:		; Memory Address ($2060) and binary offset [$1CDC]
	moveq	#$00,d0
	move.b	$18(a1,d7.w),d0
	and.w	#$00E0,d0
	bne.s	Seed_DisruptDamage_PartyLoopSkip
	move.b	$18(a1,d7.w),d0
	bsr		Load_ChampionStatRecord
	move.b	ChampionStat_HitPointsCurrent(a4),$00(a0,d7.w)
	addq.b	#$01,$00(a0,d7.w)
Seed_DisruptDamage_PartyLoopSkip:		; Memory Address ($207E) and binary offset [$1CFA]
	dbra	d7,Seed_DisruptDamage_PartyLoopHead
	move.l	(sp)+,a4
Seed_DisruptDamage_PartyLoopReturn:		; Memory Address ($2084) and binary offset [$1D00]
	rts		

ConfuseSpell_ForwardCellEntry:		; Memory Address ($2086) and binary offset [$1D02]
	bsr		Resolve_DiagonalCellAndFindOccupant
	bcc.s	Seed_DisruptDamage_PartyLoopReturn
Apply_ConfuseEffect:		; Memory Address ($208C) and binary offset [$1D08]
	; Resolves a champion or monster facing change and records the persistent
	; Confuse flag.
	tst.b	d0
	bmi.s	ConfuseEffect_PlayerFacingDispatch
	moveq	#CharacterState_ChampionRecordBias+ActorRecord_RotationAndSpace,d4
	cmpi.b	#$10,d0
	bcs.s	ConfuseEffect_ApplyFacingChange
	tst.b	$000B(a1)
	bmi.s	ConfuseFacingRoll_NoChangeReturn
	moveq	#ActorRecord_RotationAndSpace,d4
ConfuseEffect_ApplyFacingChange:		; Memory Address ($20A0) and binary offset [$1D1C]
	move.b	$00(a1,d4.w),d7
	bsr.s	Resolve_ConfuseFacingRoll
	cmp.b	$00(a1,d4.w),d7
	beq.s	ConfuseFacingRoll_NoChangeReturn
	move.b	d7,$00(a1,d4.w)
	bset	#CharacterActionState_ConfuseBit,CharacterState_ActionStateFromFacingOffset(a1,d4.w)
	rts		

Resolve_ConfuseFacingRoll:		; Memory Address ($20B8) and binary offset [$1D34]
	; Uses up to two resistance rolls to determine which facing bits Confuse
	; toggles.
	move.w	d0,d6
	bsr		Test_LevelResistanceRoll
	tst.w	d5
	beq.s	ConfuseFacingRoll_NoChangeReturn
	eor.b	#$02,d7
	move.w	d6,d0
	bsr		Test_LevelResistanceRoll
	tst.w	d5
	bne.s	ConfuseFacingRoll_NoChangeReturn
	eor.b	#$01,d7
ConfuseFacingRoll_NoChangeReturn:		; Memory Address ($20D4) and binary offset [$1D50]
	rts		

ConfuseEffect_PlayerFacingDispatch:		; Memory Address ($20D6) and binary offset [$1D52]
	bsr		Load_CurrentChampionStatRecord
	moveq	#$05,d0
	jsr		PlaySound.l
	exg		a4,a1
	move.w	$0006(a4),d0
	move.w	$0020(a4),d7
	bsr.s	Resolve_ConfuseFacingRoll
	move.w	d7,$0020(a4)
	rts		

ResistanceCheckPower:		; Memory Address ($20F4) and binary offset [$1D70]
	; Scratch word holding the signed effect power used by the shared
	; level-resistance calculation.
	ds.b	$2
Test_LevelResistanceRoll:		; Memory Address ($20F6) and binary offset [$1D72]
	; Seeds D5 with 1 and enters the shared resistance roll, returning D5=0 when
	; resistance succeeds and D5=1 when the effect should be applied.
	moveq	#$01,d5
Resolve_LevelResistanceRoll:		; Memory Address ($20F8) and binary offset [$1D74]
	; Runs the shared champion, monster, or Antimage level-versus-power resistance
	; check. Its ordinary threshold is 8*level+100-2*power, with negative results
	; replaced by 10; a random byte at or below the threshold halves D5.
	tst.b	d0
	bmi.s	Dispatch_AntimageResistancePasses
	cmpi.b	#$10,d0
	bcs.s	Load_ChampionLevelForResistanceRoll
	move.b	$0006(a1),d2
	and.w	#$007F,d2
ResistanceRoll_ComputeThreshold:		; Memory Address ($210A) and binary offset [$1D86]
	asl.w	#$03,d2
	add.w	#$0064,d2
	move.w	ResistanceCheckPower.w,d0											;Short Absolute converted to symbol!
	add.w	d0,d0
	sub.w	d0,d2
	bpl.s	ResistanceRoll_RollAndCompare
	moveq	#$0A,d2
ResistanceRoll_RollAndCompare:		; Memory Address ($211C) and binary offset [$1D98]
	bsr		RandomGen_BytewithOffset
	cmp.w	d0,d2
	bcs.s	Resolve_LevelResistanceRoll_Return
	lsr.w	#$01,d5
Resolve_LevelResistanceRoll_Return:		; Memory Address ($2126) and binary offset [$1DA2]
	rts		

Load_ChampionLevelForResistanceRoll:		; Memory Address ($2128) and binary offset [$1DA4]
	; Loads a champion level and joins the shared resistance-threshold and
	; random-roll calculation.
	moveq	#$00,d2
	OPT		O2+
	move.b	ChampionStat_Level(a1),d2
	OPT		O2-
	bra.s	ResistanceRoll_ComputeThreshold

Dispatch_AntimageResistancePasses:		; Memory Address ($212E) and binary offset [$1DAA]
	moveq	#$06,d1
	movem.l	a4/a5,-(sp)
	move.l	a1,a5
	bsr		Find_HighestRankedPartyMemberByCategory
	movem.l	(sp)+,a4/a5
	tst.w	d3
	bmi.s	Run_AntimageResistancePass
	move.w	#$FF80,ResistanceCheckPower.w										;Short Absolute converted to symbol!
	move.w	d3,-(sp)
	bsr.s	Run_AntimageResistancePass
	move.w	(sp)+,d3
	move.w	d3,d7
	addq.w	#$02,d3
	asl.w	#$03,d3
	neg.w	d3
	move.w	d3,ResistanceCheckPower.w											;Short Absolute converted to symbol!
	lsr.w	#$02,d7
	addq.w	#$01,d7
AntimageResistancePasses_LoopHead:		; Memory Address ($215E) and binary offset [$1DDA]
	move.w	d7,-(sp)
	bsr.s	Run_AntimageResistancePass
	move.w	(sp)+,d7
	dbra	d7,AntimageResistancePasses_LoopHead
	rts		

Run_AntimageResistancePass:		; Memory Address ($216A) and binary offset [$1DE6]
	; Runs one Antimage resistance pass across all four formation slots using the
	; currently staged power.
	lea		FormationSlot_ScratchBytes.l,a0
	move.l	a4,-(sp)
	clr.w	d5
	moveq	#$03,d7
Run_AntimageResistancePass_LoopHead:		; Memory Address ($2176) and binary offset [$1DF2]
	move.b	$18(a1,d7.w),d0
	bsr		Load_ChampionStatRecord
	move.b	$00(a0,d7.w),d5
	exg		a1,a4
	bsr.s	Load_ChampionLevelForResistanceRoll
	exg		a1,a4
	move.b	d5,$00(a0,d7.w)
	dbra	d7,Run_AntimageResistancePass_LoopHead
	move.l	(sp)+,a4
Run_AntimageResistancePass_Return:		; Memory Address ($2192) and binary offset [$1E0E]
	rts		

Award_MonsterDamageExperienceAndKillBonus:		; Memory Address ($2194) and binary offset [$1E10]
	; Awards damage-derived progress before monster HP is reduced and, on a lethal
	; hit, applies the surviving party's level-based bonus.
	move.b	$000B(a1),d0
	bmi.s	Run_AntimageResistancePass_Return
	sub.b	#$64,d0
	beq.s	Run_AntimageResistancePass_Return
	move.b	SpellEntity_CasterIndex.l,d0
	cmpi.b	#$10,d0
	bcc.s	Run_AntimageResistancePass_Return
	bsr		Load_ChampionStatRecord
	cmp.b	#$EC,ChampionStat_LevelProgress(a4)
	bcc.s	KillExperience_OwnerPartyXPEntry
	move.w	$001C(a4),d2														;Reads the packed LevelProgress/XPToNextLevel word beginning at ChampionStat_LevelProgress.
	move.w	d5,d1
	cmp.w	$0008(a1),d1
	bcs.s	KillExperience_ApplySoloHalving
	move.w	$0008(a1),d1
	addq.w	#$01,d1
KillExperience_ApplySoloHalving:		; Memory Address ($21CA) and binary offset [$1E46]
	; Applies the single-player experience adjustment; the multiplayer-zero path
	; skips the halving step.
	tst.w	MultiPlayer.l
	beq.s	KillExperience_LowLevelDoubleXP
	addq.w	#$01,d1
	lsr.w	#$01,d1
KillExperience_LowLevelDoubleXP:		; Memory Address ($21D6) and binary offset [$1E52]
	sub.w	d1,d2
	bcs.s	KillExperience_StoreAndGrantFairy
	cmp.b	#$09,$0006(a1)
	bcc.s	KillExperience_StoreAndGrantFairy
	sub.w	d1,d2
KillExperience_StoreAndGrantFairy:		; Memory Address ($21E4) and binary offset [$1E60]
	move.w	d2,$001C(a4)														;Stores the updated packed LevelProgress/XPToNextLevel word.
	bsr		Mark_PendingFairySpellOffer
KillExperience_OwnerPartyXPEntry:		; Memory Address ($21EC) and binary offset [$1E68]
	move.l	a5,a2
	move.b	SpellEntity_CasterIndex.l,d0
	and.w	#$000F,d0
	bsr		Find_ChampionOwner
	exg		a5,a2
	tst.w	d1
	bmi.s	Run_AntimageResistancePass_Return
	move.w	$0008(a1),d1
	sub.w	d5,d1
	bcc.s	Apply_KillExperience_Return
	move.b	$0006(a1),d1
	and.w	#$007F,d1
	moveq	#$03,d7
KillExperience_OwnerPartyXPLoopHead:		; Memory Address ($2214) and binary offset [$1E90]
	move.b	$18(a2,d7.w),d0
	and.w	#$00E0,d0
	bne.s	KillExperience_OwnerPartyXPLoopSkip
	move.b	$18(a2,d7.w),d0
	bsr		Load_ChampionStatRecord
	move.b	ChampionStat_LevelProgress(a4),d0
	cmpi.b	#$EC,d0
	bcc.s	KillExperience_OwnerPartyXPLoopSkip
	moveq	#$00,d2
	move.b	d1,d2
	OPT		O2+
	sub.b	ChampionStat_Level(a4),d2
	OPT		O2-
	addq.b	#$02,d2
	bmi.s	KillExperience_OwnerPartyXPLoopSkip
	asl.w	#$07,d2
	move.w	$001C(a4),d0														;Reads the packed LevelProgress/XPToNextLevel word for the party kill bonus.
	tst.w	MultiPlayer.l
	bne.s	KillExperience_OwnerXPSubtractMerge
	add.w	d2,d2
KillExperience_OwnerXPSubtractMerge:		; Memory Address ($224A) and binary offset [$1EC6]
	sub.w	d2,d0
	move.w	d0,$001C(a4)														;Stores the party champion's updated packed LevelProgress/XPToNextLevel word.
	bsr.s	Mark_PendingFairySpellOffer
KillExperience_OwnerPartyXPLoopSkip:		; Memory Address ($2252) and binary offset [$1ECE]
	dbra	d7,KillExperience_OwnerPartyXPLoopHead
Apply_KillExperience_Return:		; Memory Address ($2256) and binary offset [$1ED2]
	rts		

Mark_PendingFairySpellOffer:		; Memory Address ($2258) and binary offset [$1ED4]
	; For a champion at least halfway to the next level and without an existing
	; pending offer, marks a fairy-spell offer with $81; professions 1-2 always
	; qualify, while professions 0 and 3 qualify only at even levels.
	tst.b	ChampionStat_FairySpellCount(a4)
	bmi.s	Grant_PendingFairySpellFlag_Return
	moveq	#$00,d2
	OPT		O2+
	move.b	ChampionStat_Level(a4),d2
	OPT		O2-
	lea		LevelUpXPThresholdTable.l,a0
	move.b	$00(a0,d2.w),d3
	lsr.b	#$01,d3
	cmp.b	ChampionStat_LevelProgress(a4),d3
	bcs.s	Grant_PendingFairySpellFlag_Return
	move.l	a4,d3
	sub.l	#Character_Stats_DataTable,d3
	lsr.b	#$05,d3
	and.w	#$0003,d3
	beq.s	FairySpellGrant_EvenLevelCheck
	cmpi.w	#$0003,d3
	bcs.s	FairySpellFlag_MarkPending
FairySpellGrant_EvenLevelCheck:		; Memory Address ($228A) and binary offset [$1F06]
	btst	#$00,d2
	bne.s	Grant_PendingFairySpellFlag_Return
FairySpellFlag_MarkPending:		; Memory Address ($2290) and binary offset [$1F0C]
	add.b	#$81,ChampionStat_FairySpellCount(a4)
Grant_PendingFairySpellFlag_Return:		; Memory Address ($2296) and binary offset [$1F12]
	rts		

Apply_AttackDamage:		; Memory Address ($2298) and binary offset [$1F14]
	; Applies D5 damage to target D0, dispatching values $10 and above to monster
	; hit-point handling and lower values to champion hit-point handling.
	swap	d5
	clr.w	d5
	swap	d5
	cmpi.w	#$0010,d0
	bcs.s	AttackDamage_ChampionTargetDispatch
	move.w	d0,d1
	sub.w	#$0010,d0
	asl.w	#$04,d0
	lea		UnpackedMonsters.l,a1
	add.w	d0,a1
	moveq	#$00,d7
	move.b	$0000(a1),d7
	swap	d7
	move.b	$0001(a1),d7
	bsr		CoordToMap
	move.w	d0,d4
	move.w	d1,d0
	bra.s	MonsterHit_SplashDispatch

AttackDamage_ChampionTargetDispatch:		; Memory Address ($22CA) and binary offset [$1F46]
	move.w	d0,d3
	bsr		Load_ChampionStatRecord
	move.l	a4,a1
	moveq	#$00,d7
	move.b	$0016(a1),d7
	bpl.s	AttackDamage_StandingChampionHit
	move.w	d3,d0
	bsr		Find_ChampionOwner
	tst.w	d1
	bmi		TeleportOrSpellEntry_SharedReturn
	move.l	a5,a1
	lea		FormationSlot_ScratchBytes.l,a0
	clr.l	(a0)
	move.b	d5,$00(a0,d1.w)
	bra		Apply_PartyDamage

AttackDamage_StandingChampionHit:		; Memory Address ($22F8) and binary offset [$1F74]
	swap	d7
	move.b	$0017(a1),d7
	bsr		CoordToMap
	move.w	d0,d4
	move.w	d3,d0
	bra		Apply_StandingChampionDamage

AirborneSpellSplashFlag:		; Memory Address ($230A) and binary offset [$1F86]
	; When nonzero, an airborne spell impact is spread across the target monster
	; group instead of one occupant.
	ds.b	$2
Apply_SpellImpactAtOccupant:		; Memory Address ($230C) and binary offset [$1F88]
	; Finds the target-cell occupant and dispatches the staged spell impact to a
	; champion, party, monster, or monster group.
	move.w	d0,d4
	bsr		Resolve_DiagonalCellAndFindOccupant
	bcs.s	SpellImpact_TargetTypeDispatch
	rts		

SpellImpact_TargetTypeDispatch:		; Memory Address ($2316) and binary offset [$1F92]
	tst.b	d0
	bmi		Apply_PartyDamage
	cmpi.w	#$0010,d0
	bcs		Apply_StandingChampionDamage
MonsterHit_SplashDispatch:		; Memory Address ($2324) and binary offset [$1FA0]
	tst.w	AirborneSpellSplashFlag.w											;Short Absolute converted to symbol!
	beq.s	Apply_MonsterDamage
	moveq	#$00,d1
	move.b	$000D(a1),d1
	bmi.s	Apply_MonsterDamage
	asl.w	#$02,d1
	lea		MonsterTeamIndexTable.l,a0
	add.w	d1,a0
	moveq	#$03,d7
SplashDamage_TeamLoopHead:		; Memory Address ($233E) and binary offset [$1FBA]
	moveq	#$00,d1
	move.b	$00(a0,d7.w),d1
	bmi.s	SplashDamage_LoopTailCheck
	move.w	d1,d0
	add.w	#$0010,d0
	asl.w	#$04,d1
	lea		UnpackedMonsters.l,a1
	add.w	d1,a1
	movem.l	d4/d5/d7/a0/a6,-(sp)
	bsr.s	Apply_MonsterDamage
	movem.l	(sp)+,d4/d5/d7/a0/a6
SplashDamage_LoopTailCheck:		; Memory Address ($2360) and binary offset [$1FDC]
	dbra	d7,SplashDamage_TeamLoopHead
	cmp.l	#$FFFFFFFF,(a0)
	beq.s	MonsterDamage_ReturnAlive
	bset	#$07,$01(a6,d4.w)
	rts		

Apply_MonsterDamage:		; Memory Address ($2374) and binary offset [$1FF0]
	; Applies resistance when requested, awards attack progress, subtracts monster
	; hit points, and enters the death path on underflow.
	movem.w	d0/d4,-(sp)
	tst.l	d5
	bpl.s	ApplyMonsterDamage_CallKillExperience
	bsr		Resolve_LevelResistanceRoll
ApplyMonsterDamage_CallKillExperience:		; Memory Address ($2380) and binary offset [$1FFC]
	bsr		Award_MonsterDamageExperienceAndKillBonus
	movem.w	(sp)+,d0/d4
	move.w	$0008(a1),d1
	sub.w	d5,d1
	bcs.s	Apply_MonsterDeath
	move.w	d1,$0008(a1)
MonsterDamage_ReturnAlive:		; Memory Address ($2394) and binary offset [$2010]
	rts		

Apply_MonsterDeath:		; Memory Address ($2396) and binary offset [$2012]
	; Resolves monster death and loot: damage must exceed the remaining HP, special
	; forms select fixed or no drops, other forms roll the drop table, and any
	; dropped object is placed in corner 0 of the slain monster's cell.
	moveq	#$00,d2
	move.b	$000C(a1),d2
	swap	d2
	move.b	$000B(a1),d2
	move.l	d2,-(sp)
	bsr		Despawn_MonsterAndClearMapCell
	move.w	d4,d0
	moveq	#$01,d7
	bsr		Queue_MapCellEffect
	move.l	(sp)+,d2
	tst.b	d2
	bmi.s	MonsterDamage_ReturnAlive
	moveq	#$01,d5
	swap	d5
	cmpi.b	#$64,d2
	beq.s	MonsterDamage_ReturnAlive
	move.w	#$0056,d5
	cmpi.b	#$6B,d2
	beq.s	_DropTheObject
	cmpi.b	#$40,d2
	bne.s	MonsterDeath_RollLootTable
	swap	d2
	move.w	d2,d5
	bra.s	_DropTheObject

MonsterDeath_RollLootTable:		; Memory Address ($23D6) and binary offset [$2052]
	bsr		RandomGen_BytewithOffset
	and.w	#$000F,d0
	move.b	DroppedObjects_DataTable(pc,d0.w),d5
	beq.s	MonsterDamage_ReturnAlive
	cmpi.w	#$0005,d5
	bcc.s	_DropTheObject
	bsr		RandomGen_BytewithOffset
	and.w	#$0007,d0
	swap	d0
	add.l	d0,d5
_DropTheObject:		; Memory Address ($23F6) and binary offset [$2072]
	move.w	d4,d0
	move.l	Current_TowerMapDataBase.l,a6
	moveq	#$00,d6
	bra		Add_FloorObjectToStack

DroppedObjects_DataTable:		; Memory Address ($2404) and binary offset [$2080]
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$04	;04
	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$0D	;0D
	dc.b	$14	;14
	dc.b	$07	;07
	dc.b	$10	;10
	dc.b	$13	;13
	dc.b	$01	;01
	dc.b	$0A	;0A
	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$0C	;0C
	dc.b	$03	;03

Apply_StandingChampionDamage:		; Memory Address ($2414) and binary offset [$2090]
	tst.l	d5
	bpl.s	StandingChampionDamage_Subtract
	move.w	d0,-(sp)
	bsr		Resolve_LevelResistanceRoll
	move.w	(sp)+,d0
StandingChampionDamage_Subtract:		; Memory Address ($2420) and binary offset [$209C]
	moveq	#$00,d1
	move.b	$0005(a1),d1
	sub.w	d5,d1
	bcs.s	Apply_StandingChampionDeath
	move.b	d1,$0005(a1)
	rts		

Apply_StandingChampionDeath:		; Memory Address ($2430) and binary offset [$20AC]
	; Handles lethal damage to a standing champion by clearing current HP and
	; vitality, dropping the champion's remains object at the stored map position,
	; and refreshing affected party-shield slots.
	clr.b	$0005(a1)
	clr.b	$0007(a1)
	move.l	a5,-(sp)
	bsr		Find_ChampionOwner
	tst.w	d1
	bmi.s	ChampionDeath_FinalizeAndDropRemains
	bset	#$06,$18(a5,d1.w)
	tst.w	$0042(a5)
	bpl.s	ChampionDeath_FinalizeAndDropRemains
	movem.l	d4/a1,-(sp)
	move.w	d1,d7
	bsr		Refresh_PartyShieldSlotIfDirty
	bsr		Draw_PartyShieldChainStrip
	movem.l	(sp)+,d4/a1
ChampionDeath_FinalizeAndDropRemains:		; Memory Address ($2460) and binary offset [$20DC]
	move.l	(sp)+,a5
	move.b	#$FF,$0016(a1)
	move.l	Current_TowerMapDataBase.l,a6
	move.w	d4,d0
	bclr	#$07,$01(a6,d0.w)
	move.l	a1,d5
	sub.l	#Character_Stats_DataTable,d5
	lsr.w	#$05,d5
	add.l	#$10040,d5
	moveq	#$00,d6
	bra		Add_FloorObjectToStack

Apply_PartyDamage:		; Memory Address ($248C) and binary offset [$2108]
	; Applies a staged byte-sized damage value across the four party formation
	; slots, with the shared Antimage resistance path when requested.
	or.b	#$0F,$003E(a1)
	bclr	#$02,(a1)
	beq.s	PartyDamage_AntimageResistanceCheck
	clr.w	$0014(a1)
PartyDamage_AntimageResistanceCheck:		; Memory Address ($249C) and binary offset [$2118]
	tst.l	d5
	bpl.s	PartyDamage_FormationLoopSetup
	moveq	#-$01,d0
	bsr		Resolve_LevelResistanceRoll
PartyDamage_FormationLoopSetup:		; Memory Address ($24A6) and binary offset [$2122]
	moveq	#$03,d1
	lea		FormationSlot_ScratchBytes.l,a0
PartyDamage_FormationLoopHead:		; Memory Address ($24AE) and binary offset [$212A]
	move.b	$18(a1,d1.w),d0
	and.w	#$00E0,d0
	beq.s	ApplyPartyDamage_DamageSlotAndFlagDeath
	clr.b	$00(a0,d1.w)
	bra.s	ApplyPartyDamage_SlotLoopTail

ApplyPartyDamage_DamageSlotAndFlagDeath:		; Memory Address ($24BE) and binary offset [$213A]
	; Marks an in-party champion dead after HP underflow, clears worn and selected
	; spells, leaves the champion record available to the party, and plays the
	; character-death sound.
	move.b	$18(a1,d1.w),d0
	bsr		Load_ChampionStatRecord
	move.b	$0005(a4),d0
	sub.b	$00(a0,d1.w),d0
	bcc.s	ApplyPartyDamage_StoreSlotHP
	or.b	#$40,$18(a1,d1.w)
	clr.b	$0011(a4)
	move.b	#$FF,$0013(a4)
	move.l	a0,-(sp)
	moveq	#Sound_CharacterDeath,d0
	jsr		PlaySound.l
	move.l	(sp)+,a0
	moveq	#$00,d0
ApplyPartyDamage_StoreSlotHP:		; Memory Address ($24EE) and binary offset [$216A]
	move.b	d0,$0005(a4)
ApplyPartyDamage_SlotLoopTail:		; Memory Address ($24F2) and binary offset [$216E]
	dbra	d1,PartyDamage_FormationLoopHead
	move.l	a5,-(sp)
	move.l	a1,a5
	moveq	#$03,d1
PartyDamage_ClearDeadMemberSlotLoop:		; Memory Address ($24FC) and binary offset [$2178]
	move.b	$18(a5,d1.w),d0
	bmi.s	Advance_DepartedChampionSlotScan
	btst	#$06,d0
	beq.s	Advance_DepartedChampionSlotScan
	btst	#$05,d0
	bne.s	Advance_DepartedChampionSlotScan
	and.w	#$000F,d0
	bsr		Find_ChampionFormationSlot
	tst.w	d2
	bmi.s	Advance_DepartedChampionSlotScan
	move.b	#$FF,$26(a5,d2.w)
Advance_DepartedChampionSlotScan:		; Memory Address ($2520) and binary offset [$219C]
	; Advances the scan that marks champion slots affected by party-member
	; departure.
	dbra	d1,PartyDamage_ClearDeadMemberSlotLoop
	btst	#$06,$0018(a5)
	bne.s	Choose_DepartedChampionReplacement
	bsr		Refresh_ModeDependentChampionDisplay
	bra		Finalise_DepartedPartyUpdate

Choose_DepartedChampionReplacement:		; Memory Address ($2534) and binary offset [$21B0]
	; Begins selection of a replacement when the active party slot departs.
	moveq	#$00,d1
	moveq	#$00,d0
Find_ActiveChampionReplacementLoop:		; Memory Address ($2538) and binary offset [$21B4]
	; Scans the four party slots for an eligible replacement active champion.
	move.b	$18(a5,d1.w),d0
	and.w	#$00E0,d0
	bne.s	Advance_ActiveChampionReplacementCandidate
	move.b	$18(a5,d1.w),d0
	and.w	#$000F,d0
	move.b	$0018(a5),$18(a5,d1.w)
	move.b	d0,$0018(a5)
	bset	#$04,$0018(a5)
	move.w	d0,$0006(a5)
	bsr.s	Swap_FormationSlotEntries
	bra		Reset_DepartedPartyState

Swap_FormationSlotEntries:		; Memory Address ($2564) and binary offset [$21E0]
	; Swaps formation-slot scratch entries when party leader or survivor ordering
	; changes.
	lea		FormationSlot_ScratchBytes.l,a0
	move.b	(a0),d0
	move.b	$00(a0,d1.w),(a0)
	move.b	d0,$00(a0,d1.w)
	rts		

Advance_ActiveChampionReplacementCandidate:		; Memory Address ($2576) and binary offset [$21F2]
	; Advances or falls back after a party slot cannot replace the departed active
	; champion.
	addq.w	#$01,d1
	cmpi.w	#$0004,d1
	bcs.s	Find_ActiveChampionReplacementLoop
	and.b	#$01,(a5)
	moveq	#$03,d1
AdjustInventoryIndex_FindLeaderCandidateLoop:		; Memory Address ($2584) and binary offset [$2200]
	move.b	$18(a5,d1.w),d0
	btst	#$05,d0
	beq.s	Continue_DepartedChampionSelectionScan
	btst	#$06,d0
	beq.s	Install_ActiveChampionReplacement
Continue_DepartedChampionSelectionScan:		; Memory Address ($2594) and binary offset [$2210]
	; Continues the fallback scan while the current slot remains unsuitable.
	dbra	d1,AdjustInventoryIndex_FindLeaderCandidateLoop
	bra.s	Handle_NoActiveChampionReplacement

Install_ActiveChampionReplacement:		; Memory Address ($259A) and binary offset [$2216]
	; Moves the selected champion into the active slot and transfers the associated
	; party state.
	move.b	$0018(a5),$18(a5,d1.w)
	move.b	d0,$0018(a5)
	bset	#$04,$0018(a5)
	and.w	#$000F,d0
	move.w	d0,$0006(a5)
	bsr.s	Swap_FormationSlotEntries
	bsr		Externalise_WipedParty_Remains
	bclr	#$05,$0018(a5)
	bsr		Load_CurrentChampionStatRecord
	move.b	$0016(a4),$001D(a5)
	move.b	$0017(a4),$001F(a5)
	move.b	$001A(a4),$0059(a5)
	move.b	$0018(a4),$0021(a5)
	move.b	#$FF,$0016(a4)
	move.b	$0018(a5),$0026(a5)
	and.b	#$0F,$0026(a5)
	bra.s	Reset_DepartedPartyState

Handle_NoActiveChampionReplacement:		; Memory Address ($25EE) and binary offset [$226A]
	; Externalises the remaining party members when no eligible active replacement
	; exists.
	bsr.s	Externalise_WipedParty_Remains
	move.b	#$FF,$001D(a5)
	bsr		Draw_PlayerDeathMessage
	and.b	#$01,(a5)
Reset_DepartedPartyState:		; Memory Address ($25FE) and binary offset [$227A]
	; Clears transient party selection and interface state after departure
	; handling.
	clr.w	$0014(a5)
	clr.b	$003E(a5)
	bsr		Draw_ChampionNamePanelFrame
Finalise_DepartedPartyUpdate:		; Memory Address ($260A) and binary offset [$2286]
	; Resets selection words, redraws the interface and updates party hit-number
	; displays.
	move.w	#$FFFF,$0042(a5)
	move.w	#$FFFF,$0040(a5)
	move.b	#$FF,$0035(a5)
	bsr		Refresh_DirtyPartyShieldSlots
	bsr		Loop_TeamAvatarSlots
	move.l	(sp)+,a5
	rts		

Externalise_WipedParty_Remains:		; Memory Address ($2628) and binary offset [$22A4]
	; Clears the wiped party's map occupancy and converts each occupied champion
	; slot into externally recoverable remains.
	bsr		PlayerPositionToMapOffset
	bclr	#$07,$01(a6,d0.w)
	moveq	#$03,d1
Externalise_WipedParty_SlotLoop:		; Memory Address ($2634) and binary offset [$22B0]
	moveq	#$01,d5
	swap	d5
	move.b	$18(a5,d1.w),d5
	bmi.s	Advance_RemainsExternalisationLoop
	bset	#$05,$18(a5,d1.w)
	bne.s	Advance_RemainsExternalisationLoop
	and.w	#$000F,d5
	add.w	#$0040,d5
	moveq	#$00,d6
	movem.l	d0/d1,-(sp)
	bsr		Add_FloorObjectToStack
	movem.l	(sp)+,d0/d1
Advance_RemainsExternalisationLoop:		; Memory Address ($265C) and binary offset [$22D8]
	; Advances the loop that converts departed champions into recoverable remains.
	dbra	d1,Externalise_WipedParty_SlotLoop
	rts		

Loop_TeamAvatarSlots:		; Memory Address ($2662) and binary offset [$22DE]
	; Scans all four formation slots and draws pending wound-flash numbers for
	; flagged slots.
	moveq	#$03,d7
TeamAvatarSlots_ScanFlagLoop:		; Memory Address ($2664) and binary offset [$22E0]
	move.b	$18(a5,d7.w),d0
	bmi.s	Advance_PartyHitNumberLoop
	moveq	#$00,d0
	move.b	FormationSlot_ScratchBytes(pc,d7.w),d0
	beq.s	Advance_PartyHitNumberLoop
	move.w	d7,-(sp)
	bsr		Draw_CombatWoundFlashNumber
	move.w	(sp)+,d7
Advance_PartyHitNumberLoop:		; Memory Address ($267A) and binary offset [$22F6]
	; Advances the loop that redraws nonzero party damage counters.
	dbra	d7,TeamAvatarSlots_ScanFlagLoop
	rts		

FormationSlot_ScratchBytes:		; Memory Address ($2680) and binary offset [$22FC]
	; Four reusable per-formation-slot scratch bytes shared by resistance, damage
	; staging, leader swapping, and wound-flash paths.
	ds.b	$4
Draw_CombatWoundFlashNumber:		; Memory Address ($2684) and binary offset [$2300]
	; Draws the wound-flash backing sprite and one-to-three-digit hit count, then
	; arms the slot highlight timer.
	move.w	d0,-(sp)
	move.l	#$000D000C,CurrentTextInk.l
	lea		GFX_Pockets+$7688.l,a1
	move.b	#$07,$5A(a5,d7.w)
	move.w	d7,d0
	move.l	#$1000A,d7
	add.w	d0,d0
	add.w	d0,d0
	move.w	WoundFlashPopup_XOffsetTable(pc,d0.w),d4
	move.w	WoundFlashPopup_YOffsetTable(pc,d0.w),d5
	add.w	$0008(a5),d5
	movem.l	d4/d5,-(sp)
	moveq	#$00,d6
	jsr		Draw_PlanarSprite_RowsReversed.l
	movem.l	(sp)+,d4/d5
	move.w	(sp)+,d0
	addq.w	#$04,d4
	addq.w	#$03,d5
	lea		Notice_NumberOfHits.l,a6
	moveq	#$00,d2
	bsr		Convert_ThreeDigitDecimalText
	moveq	#$08,d0
	move.w	d2,d1
	beq.s	WoundFlashNumber_ApplyDigitXOffset
	subq.w	#$04,d0
	subq.w	#$01,d2
	beq.s	WoundFlashNumber_ApplyDigitXOffset
	subq.w	#$04,d0
WoundFlashNumber_ApplyDigitXOffset:		; Memory Address ($26E4) and binary offset [$2360]
	add.w	d0,d4
WoundFlashNumber_DrawDigitLoop:		; Memory Address ($26E6) and binary offset [$2362]
	move.b	(a6)+,d0
	movem.l	d1/d4/d5/a6,-(sp)
	jsr		Draw_woundflash_digit.l
	movem.l	(sp)+,d1/d4/d5/a6
	addq.w	#$08,d4
	dbra	d1,WoundFlashNumber_DrawDigitLoop
	rts		

WoundFlashPopup_XOffsetTable:		; Memory Address ($26FE) and binary offset [$237A]
	; Alternate base into the interleaved wound-flash origin table; indexed by slot
	; times four to read each X coordinate.
	dc.w	$000B	;000B
WoundFlashPopup_YOffsetTable:		; Memory Address ($2700) and binary offset [$237C]
	; Alternate base into the interleaved wound-flash origin table; indexed by slot
	; times four to read each Y coordinate.
	dc.w	$0013	;0013
	dc.w	$0000	;0000
	dc.w	$0040	;0040
	dc.w	$0020	;0020
	dc.w	$0040	;0040
	dc.w	$0040	;0040
	dc.w	$0040	;0040

Draw_PlayerDeathMessage:		; Memory Address ($270E) and binary offset [$238A]
	; Draws the player's death frame and prints the two-line THOU / ART DEAD
	; message when no living replacement leader remains.
	bsr.s	Draw_ViewportMessageFrame
	lea		ThouArtDead.l,a6
	jmp		Print_fflim_text.l

ThouArtDead:		; Memory Address ($271C) and binary offset [$2398]
	dc.b	$FC		;FC
	dc.b	$12		;12
	dc.b	$04		;04
	dc.b	$FE		;FE
	dc.b	$04		;04
	dc.b	$FD		;FD
	dc.b	$00		;00
	dc.b	'THOU'
	dc.b	$FC		;FC
	dc.b	$10		;10
	dc.b	$06		;06
	dc.b	'ART DEAD'
	dc.b	$FF		;FF
	dc.b	$00		;00

Draw_ViewportMessageFrame:		; Memory Address ($2734) and binary offset [$23B0]
	; Clears the dungeon viewport and draws the nested frame used for death, sleep,
	; and completion messages.
	or.b	#$40,$0054(a5)
	moveq	#$00,d3
	bsr		Clear_ViewportMessageBackground
	move.l	#$004B000C,d5
	add.w	$0008(a5),d5
	move.l	#$007F0060,d4
	moveq	#$04,d3
	moveq	#$02,d2
	bra.s	ViewportMessageFrame_DrawFramePass

ViewportMessageFrame_ShrinkHeightStep:		; Memory Address ($2756) and binary offset [$23D2]
	add.w	d2,d5
	swap	d5
	sub.w	d2,d5
	subq.w	#$01,d5
	swap	d5
ViewportMessageFrame_DrawFramePass:		; Memory Address ($2760) and binary offset [$23DC]
	movem.l	d2-d5,-(sp)
	jsr		BW_draw_frame.l
	movem.l	(sp)+,d2-d5
	eor.w	#$0006,d3
	add.l	#$FFFE0001,d4
	dbra	d2,ViewportMessageFrame_ShrinkHeightStep
	rts		

Purge_TransientSummonsBeforeAllocation:		; Memory Address ($277E) and binary offset [$23FA]
	; Removes dormant or transient summon records on the target floor before a new
	; spell entity is allocated.
	movem.l	d0-d7/a0-a6,-(sp)
	lea		UnpackedMonsters.l,a4
	move.w	-$0002(a4),d6
PurgeTransientSummons_ScanLoop:		; Memory Address ($278C) and binary offset [$2408]
	move.w	d6,d0
	asl.w	#$04,d0
	lea		$00(a4,d0.w),a3
	move.b	$000B(a3),d0
	bmi.s	PurgeTransientSummons_DespawnEntry
	cmpi.b	#$64,d0
	bne.s	PurgeTransientSummons_LoopTail
PurgeTransientSummons_DespawnEntry:		; Memory Address ($27A0) and binary offset [$241C]
	moveq	#$00,d0
	move.b	$0004(a3),d0
	bsr		Select_FloorMapByIndex
	moveq	#$00,d7
	move.b	$0000(a3),d7
	bmi.s	PurgeTransientSummons_LoopTail
	swap	d7
	move.b	$0001(a3),d7
	bsr		CoordToMap
	move.w	d0,d4
	move.w	d6,d0
	add.w	#$0010,d0
	bsr.s	Despawn_MonsterAndClearMapCell
PurgeTransientSummons_LoopTail:		; Memory Address ($27C6) and binary offset [$2442]
	dbra	d6,PurgeTransientSummons_ScanLoop
	movem.l	(sp),d0-d7/a0-a6
	move.w	d2,d0
	bsr		Resolve_DiagonalPillarSourceCell
	move.w	d1,d0
	bsr		Select_FloorMapByIndex
	movem.l	(sp)+,d0-d7/a0-a6
	rts		

Remove_MonsterRecord:		; Memory Address ($27E0) and binary offset [$245C]
	; Updates references to the selected monster, removes its live record, compacts
	; the remaining array, and clears the vacated final record.
	move.l	a4,d0
	sub.l	#UnpackedMonsters,d0
	lsr.w	#ActorRecord_SizeShift,d0
	add.w	#ActorRecord_Size,d0
	bra.s	RemoveMonsterRecord_BeginCompaction

Despawn_MonsterAndClearMapCell:		; Memory Address ($27F0) and binary offset [$246C]
	; Clears the monster's map occupancy and enters the shared record-compaction
	; and reference-cleanup path.
	bclr	#$07,$01(a6,d4.w)
RemoveMonsterRecord_BeginCompaction:		; Memory Address ($27F6) and binary offset [$2472]
	bsr.s	Cleanup_MonsterReferencesAfterRemoval
	lea		UnpackedMonsters.l,a2
	move.w	LiveActorRecord_CountOffset(a2),d2
	subq.w	#$01,LiveActorRecord_CountOffset(a2)
	sub.w	d0,d2
	asl.w	#ActorRecord_SizeShift,d0
	lea		$00(a2,d0.w),a2
	lea		ActorRecord_Size(a2),a3
	bra.s	RemoveMonsterRecord_CopyLoopCheck

RemoveMonsterRecord_CompactionCopyLoop:		; Memory Address ($2814) and binary offset [$2490]
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
RemoveMonsterRecord_CopyLoopCheck:		; Memory Address ($281C) and binary offset [$2498]
	dbra	d2,RemoveMonsterRecord_CompactionCopyLoop
	moveq	#-$01,d2
	move.l	d2,(a2)+
	move.l	d2,(a2)+
	move.l	d2,(a2)+
	move.l	d2,(a2)
MonsterRemoval_SharedReturn:		; Memory Address ($282A) and binary offset [$24A6]
	rts		

Adjust_PlayerTargetIndexAfterRemoval:		; Memory Address ($282C) and binary offset [$24A8]
	; Clears or decrements a player's targeted-monster index after the live monster
	; array is compacted.
	tst.b	$0035(a0)
	bmi.s	MonsterRemoval_SharedReturn
	cmp.b	$0035(a0),d0
	bne.s	AdjustPlayerTargetIndex_DecrementIfLater
	move.b	#$FF,$0035(a0)
	rts		

AdjustPlayerTargetIndex_DecrementIfLater:		; Memory Address ($2840) and binary offset [$24BC]
	bcc.s	MonsterRemoval_SharedReturn
	subq.b	#$01,$0035(a0)
	rts		

Cleanup_MonsterReferencesAfterRemoval:		; Memory Address ($2848) and binary offset [$24C4]
	; Repairs both players' target indices and all monster-team member indices
	; after a live monster record is removed.
	lea		Player1_Data.l,a0
	bsr.s	Adjust_PlayerTargetIndexAfterRemoval
	lea		Player2_Data.l,a0
	bsr.s	Adjust_PlayerTargetIndexAfterRemoval
	sub.w	#ActorRecord_Size,d0
	lea		MonsterTeamIndexTable.l,a0
	move.w	MonsterTeamIndexTable_CountOffset(a0),d2
	bmi.s	MonsterRemoval_SharedReturn
	move.w	d5,-(sp)
CleanUpMonsterRefs_GroupTableLoop:		; Memory Address ($286A) and binary offset [$24E6]
	movem.w	d0/d2,-(sp)
	bsr.s	Adjust_MonsterTeamMemberIndexAfterRemoval
	movem.w	(sp)+,d0/d2
	dbra	d2,CleanUpMonsterRefs_GroupTableLoop
	move.w	(sp)+,d5
	rts		

Adjust_MonsterTeamMemberIndexAfterRemoval:		; Memory Address ($287C) and binary offset [$24F8]
	; Clears or decrements one monster team's member indices after the live monster
	; array is compacted.
	moveq	#MonsterTeamMember_Count-1,d3
	moveq	#$00,d2
AdjustMonsterTeamMemberIndex_ScanLoop:		; Memory Address ($2880) and binary offset [$24FC]
	move.b	$00(a0,d3.w),d5
	bmi.s	AdjustMonsterTeamMemberIndex_LoopTail
	cmp.b	d5,d0
	bcs.s	AdjustMonsterTeamMemberIndex_Decrement
	bne.s	AdjustMonsterTeamMemberIndex_LoopTail
	clr.b	$00(a0,d3.w)
	moveq	#$01,d2
AdjustMonsterTeamMemberIndex_Decrement:		; Memory Address ($2892) and binary offset [$250E]
	subq.b	#$01,$00(a0,d3.w)
AdjustMonsterTeamMemberIndex_LoopTail:		; Memory Address ($2896) and binary offset [$2512]
	dbra	d3,AdjustMonsterTeamMemberIndex_ScanLoop
	tst.w	d2
	beq.s	MonsterGroupCleanup_AdvanceAndReturn
	lea		UnpackedMonsters.l,a2
	asl.w	#ActorRecord_SizeShift,d0
	tst.b	$0D(a2,d0.w)
	bmi.s	MonsterGroupCleanup_AdvanceAndReturn
	moveq	#MonsterTeamMember_Count-1,d3
MonsterGroupCleanup_FindReplacementLoop:		; Memory Address ($28AE) and binary offset [$252A]
	tst.b	$00(a0,d3.w)
	bpl.s	MonsterGroupCleanup_PromoteReplacementMember
	dbra	d3,MonsterGroupCleanup_FindReplacementLoop
MonsterGroupCleanup_AdvanceAndReturn:		; Memory Address ($28B8) and binary offset [$2534]
	addq.w	#$04,a0
	rts		

MonsterGroupCleanup_PromoteReplacementMember:		; Memory Address ($28BC) and binary offset [$2538]
	bset	#$07,$01(a6,d4.w)
	move.b	$00(a0,d3.w),d3
	asl.w	#$04,d3
	cmp.w	d0,d3
	bcs.s	MonsterGroupCleanup_CopyToReplacement
	add.w	#$0010,d3
MonsterGroupCleanup_CopyToReplacement:		; Memory Address ($28D0) and binary offset [$254C]
	lea		$00(a2,d3.w),a3
	lea		$00(a2,d0.w),a2
	move.b	ActorRecord_XPosition(a2),ActorRecord_XPosition(a3)
	move.b	ActorRecord_YPosition(a2),ActorRecord_YPosition(a3)
	move.b	ActorRecord_Floor(a2),ActorRecord_Floor(a3)
	move.b	ActorRecord_RotationAndSpace(a2),ActorRecord_RotationAndSpace(a3)
	move.b	MonsterRecord_TeamGroupIndex(a2),MonsterRecord_TeamGroupIndex(a3)
	move.b	#MonsterRecord_NoTeamGroup,MonsterRecord_TeamGroupIndex(a2)
	move.b	#ActorRecord_NoPosition,ActorRecord_XPosition(a2)
	bra.s	MonsterGroupCleanup_AdvanceAndReturn

Run_PlayerPeriodicMaintenance:		; Memory Address ($2904) and binary offset [$2580]
	; Conditionally redraws the casting bar, selects the player's floor, advances
	; communications, and refreshes formation-member state.
	cmp.b	#$02,$0015(a5)
	bne.s	PlayerSpellBarTick_SkipCastBarDraw
	bsr		Load_CurrentChampionStatRecord
	tst.b	$0013(a4)
	bmi.s	PlayerSpellBarTick_SkipCastBarDraw
	bsr		Draw_SpellCastingBar
PlayerSpellBarTick_SkipCastBarDraw:		; Memory Address ($291A) and binary offset [$2596]
	bsr		Select_ActivePlayerFloorMap
	bsr		Comms_RunPeriodicTickIfActive
	move.b	#$FF,$0034(a5)
	moveq	#$03,d7
PlayerSpellBarTick_MemberLoop:		; Memory Address ($292A) and binary offset [$25A6]
	moveq	#$00,d0
	move.b	$18(a5,d7.w),d0
	move.w	d0,d3
	and.w	#$000F,d3
	and.w	#$00E0,d0
	beq.s	PlayerSpellBarTick_UpdateActionTimers
	tst.b	$0050(a5)
	beq.s	PlayerSpellBarTick_MemberLoopTail
	cmpi.b	#$20,d0
	bne.s	PlayerSpellBarTick_MemberLoopTail
	move.w	d3,d0
	move.w	d7,-(sp)
	bsr		Load_ChampionStatRecord
	moveq	#$16,d4
	move.w	#$FFFF,PartyFormationActivationFlag.w								;Short Absolute converted to symbol!
	bsr		Update_CharacterCooldownIfCurrentTower
	move.w	(sp)+,d7
	bra.s	PlayerSpellBarTick_MemberLoopTail

PlayerSpellBarTick_UpdateActionTimers:		; Memory Address ($2960) and binary offset [$25DC]
	move.w	d3,d0
	bsr		Load_ChampionStatRecord
	move.w	d7,-(sp)
	bsr.s	Update_CharacterActionTimers
	move.w	(sp)+,d7
PlayerSpellBarTick_MemberLoopTail:		; Memory Address ($296C) and binary offset [$25E8]
	dbra	d7,PlayerSpellBarTick_MemberLoop
	rts		

Decrement_CharacterTimerLowBits:		; Memory Address ($2972) and binary offset [$25EE]
	; Decrements the low three-bit character timer while preserving its control
	; bits.
	move.b	d0,d1
	bmi.s	CharacterTimer_DecrementReturn
	and.w	#CharacterActionState_CountdownMask,d1
	subq.b	#$01,d0
	subq.w	#$01,d1
	bcc.s	CharacterTimer_DecrementReturn
	moveq	#$00,d0
CharacterTimer_DecrementReturn:		; Memory Address ($2982) and binary offset [$25FE]
	rts		

Update_CharacterAttackCooldown:		; Memory Address ($2984) and binary offset [$2600]
	; Updates the physical-attack cooldown stored at champion byte $1B while
	; preserving bit 5.
	move.b	ChampionStat_ActionState(a4),d0
	bsr.s	Decrement_CharacterTimerLowBits
	move.b	ChampionStat_ActionState(a4),d1
	and.b	#1<<CharacterActionState_TerrorBit,d1
	or.b	d1,d0
	move.b	d0,ChampionStat_ActionState(a4)
	rts		

Update_CharacterActionTimers:		; Memory Address ($299A) and binary offset [$2616]
	; Updates the champion attack cooldown and general action-speed countdown.
	bsr.s	Update_CharacterAttackCooldown
	move.b	ChampionStat_ActionCycleTimer(a4),d0
	move.b	d0,d1
	and.w	#CharacterActionTimer_CountdownMask,d1
	subq.w	#$01,d1
	bcs.s	Reload_ChampionAttackTimer
	subq.b	#$01,ChampionStat_ActionCycleTimer(a4)
CharacterActionTimer_SharedReturn:		; Memory Address ($29AE) and binary offset [$262A]
	rts		

Reload_ChampionAttackTimer:		; Memory Address ($29B0) and binary offset [$262C]
	; Reloads the champion's cyclic action timer and dispatches a queued attack
	; when present.
	move.b	d0,d1
	lsr.b	#CharacterActionTimer_ReloadShift,d1
	or.b	d0,d1
	move.b	d1,ChampionStat_ActionCycleTimer(a4)
	moveq	#$04,d4
	bclr	d7,PlayerData_PendingAttackSlotFlags(a5)
	bne		Resolve_ChampionPhysicalAttack
	move.b	(a5),d0
	and.w	#$000A,d0
	beq.s	CharacterActionTimer_SharedReturn
	tst.w	d7
	bne.s	CheckDoorToggle_DispatchAttackOrSpell
	cmp.b	#$02,$0015(a5)
	bcc.s	CharacterActionTimer_SharedReturn
CheckDoorToggle_DispatchAttackOrSpell:		; Memory Address ($29D8) and binary offset [$2654]
	move.w	d3,d0
	move.b	d3,SpellEntity_CasterIndex.l
	bsr		Load_ChampionStatRecord
	tst.b	$0013(a4)
	bpl		PostAttack_CheckSpellSelected
	move.w	d3,d0
	bsr		Find_ChampionFormationSlot
	movem.w	d2/d3/d7,-(sp)
	bsr		PostDoorToggle_Enter
	bmi.s	Restore_ChampionAttackRegisters
	bsr		Interface_CheckSelectedCellInteraction
	bcs.s	CheckDoorToggle_PostInteractionCheck
Restore_ChampionAttackRegisters:		; Memory Address ($2A02) and binary offset [$267E]
	; Restores target, champion and party-slot registers after a rejected
	; attack-clearance check.
	movem.w	(sp)+,d2/d3/d7
Handle_RejectedChampionAttack:		; Memory Address ($2A06) and binary offset [$2682]
	; Cancels or returns from a champion attack that cannot proceed.
	tst.w	d7
	bne		Prepare_RangedAttackFromPockets
	and.b	#$01,(a5)
	bra		Prepare_RangedAttackFromPockets

CheckDoorToggle_PostInteractionCheck:		; Memory Address ($2A14) and binary offset [$2690]
	movem.w	(sp)+,d2/d3/d7
	tst.b	d0
	bmi.s	CheckDoorToggle_MeleeOrRangedGate
	cmpi.b	#$10,d0
	bcs.s	CheckDoorToggle_MeleeOrRangedGate
	tst.b	$000B(a1)
	bmi.s	Handle_RejectedChampionAttack
CheckDoorToggle_MeleeOrRangedGate:		; Memory Address ($2A28) and binary offset [$26A4]
	cmpi.w	#$0002,d2
	bcc		Prepare_RangedAttackFromPockets
	movem.l	a4/a5,-(sp)
	bsr		Prepare_PhysicalAttackContext
	movem.l	(sp)+,a4/a5
	move.w	PhysicalAttack_WorkingValues.l,d5
	moveq	#$00,d4
Resolve_ChampionPhysicalAttack:		; Memory Address ($2A44) and binary offset [$26C0]
	; Runs a queued champion physical attack through the common combat and message
	; paths.
	move.w	$0004(sp),d7
	movem.w	d4-d7,-(sp)
	tst.w	d7
	bne.s	DoorToggleRoutine_DrawOutcomeGlyph
	bsr		Refresh_CurrentChampionMapPositionIcon
	movem.w	(sp),d4-d7
DoorToggleRoutine_DrawOutcomeGlyph:		; Memory Address ($2A58) and binary offset [$26D4]
	bsr		Draw_CombatOutcomeProfessionGlyph
	movem.w	(sp)+,d4-d7
	bra		FormatPartySlotCombatOutcome_Entry

PostDoorToggle_Enter:		; Memory Address ($2A64) and binary offset [$26E0]
	; Checks the current and forward map cells for a facing-matched door during the
	; multifunction action path.
	bsr		PlayerPositionToMapOffset
	move.w	$00(a6,d0.w),d1
	and.w	#$0007,d1
	subq.w	#$02,d1
	bne.s	Check_ForwardAttackClearance
	move.w	$0020(a5),d1
	add.w	d1,d1
	btst	d1,$00(a6,d0.w)
	bne.s	Return_AttackBlocked
Check_ForwardAttackClearance:		; Memory Address ($2A80) and binary offset [$26FC]
	; Validates map bounds and the opposite door edge for an attack into the
	; forward cell.
	bsr		ForwardCellToMapOffset
	cmp.w	CurrentFloorHeight.l,d7
	bcc.s	Return_AttackBlocked
	swap	d7
	cmp.w	CurrentFloorWidth.l,d7
	bcc.s	Return_AttackBlocked
	move.w	$00(a6,d0.w),d1
	and.w	#$0007,d1
	subq.w	#$02,d1
	bne.s	Return_AttackClear
	move.w	$0020(a5),d1
	eor.w	#$0002,d1
	add.w	d1,d1
	btst	d1,$00(a6,d0.w)
	bne.s	Return_AttackBlocked
Return_AttackClear:		; Memory Address ($2AB2) and binary offset [$272E]
	; Returns zero to report that the champion's forward attack path is clear.
	moveq	#$00,d1
	rts		

Return_AttackBlocked:		; Memory Address ($2AB6) and binary offset [$2732]
	; Returns minus one to report that the champion's forward attack path is
	; blocked.
	moveq	#-$01,d1
	rts		

Prepare_PhysicalAttackContext:		; Memory Address ($2ABA) and binary offset [$2736]
	; Derives the attack-facing state and defence conditions before resolving a
	; physical attack.
	clr.w	PhysicalAttack_DoubleDefenceFlag.l
	move.w	$0020(a5),d1
	tst.b	d0
	bpl.s	PhysicalAttack_TargetFacingPath
	sub.w	$0020(a1),d1
	move.w	d1,PhysicalAttack_BackstabState.l
	move.w	$0020(a5),d0
	bsr		Select_MonsterMeleePartyTarget
	bra.s	Apply_CutpurseBackstabEligibility

PhysicalAttack_TargetFacingPath:		; Memory Address ($2ADC) and binary offset [$2758]
	; Calculates the relative attack direction using the target's facing or
	; sub-position.
	move.b	$0002(a1),d2
	cmpi.b	#$10,d0
	bcc.s	PhysicalAttack_FacingByteMerge
	move.b	$0018(a1),d2
PhysicalAttack_FacingByteMerge:		; Memory Address ($2AEA) and binary offset [$2766]
	and.w	#$0003,d2
	sub.w	d2,d1
	move.w	d1,PhysicalAttack_BackstabState.l
	move.w	d0,d1
Apply_CutpurseBackstabEligibility:		; Memory Address ($2AF8) and binary offset [$2774]
	; Retains a possible rear attack only when the attacker's profession index is
	; 3: Cutpurse.
	move.w	d3,d0
	not.w	d0
	and.w	#Character_ProfessionMask,d0										;Low two bits used to select one of the four character professions.
	beq.s	Execute_PhysicalAttack
	move.w	#$FFFF,PhysicalAttack_BackstabState.l
Execute_PhysicalAttack:		; Memory Address ($2B0A) and binary offset [$2786]
	; Sets the attack cooldown, resolves physical combat and applies the resulting
	; damage.
	move.b	#CharacterActionState_PhysicalAttackStart,ChampionStat_ActionState(a4)	;Initial cooldown written whenever a champion performs a physical attack.
	move.l	a4,-(sp)
	move.w	d1,-(sp)
	bsr		Resolve_PhysicalAttack
	move.w	(sp)+,d0
	move.w	$0000(a6),d5
	bsr		Apply_AttackDamage
	move.l	(sp)+,a4
	rts		

Prepare_RangedAttackFromPockets:		; Memory Address ($2B26) and binary offset [$27A2]
	; Calculates the attacker's level contribution, scans the relevant pockets for
	; bow and arrow candidates, and prepares ranged-attack state.
	move.w	d3,d1
	move.w	d1,d2
	bsr		Calculate_CutpurseLevelContribution
	lea		Character_Pockets_DataTable.l,a0
	asl.w	#$04,d2
	add.w	d2,a0
	moveq	#-$01,d4
	moveq	#-$01,d5
	moveq	#$01,d3
ResolveRangedAttack_PocketScanLoop:		; Memory Address ($2B3E) and binary offset [$27BA]
	bsr.s	Record_BowAndArrowPocketCandidates
	dbra	d3,ResolveRangedAttack_PocketScanLoop
	move.w	d4,d3
	or.w	d5,d3
	tst.w	d3
	bmi.s	PostAttack_CheckSpellSelected
	move.b	$00(a0,d4.w),d2
	subq.b	#$01,$0B(a0,d2.w)
	bcs.s	RangedAttack_ClearBowAndAmmoSlots
	subq.b	#$03,d2
	move.w	#$0088,d4
	add.w	d2,d4
	add.b	d2,d0
	move.b	$00(a0,d5.w),d5
	sub.w	#$005C,d5
	move.b	Bow_ActionBitShiftCounts(pc,d5.w),d2
	lsr.w	d2,d0
	add.b	Bow_ActionValueAdjustments(pc,d5.w),d0
	add.w	d0,d0
	move.w	d0,d7
	bsr		SpellEntity_PrepareDirection
	moveq	#$01,d4
	bra		Resolve_ChampionPhysicalAttack

Bow_ActionBitShiftCounts:		; Memory Address ($2B80) and binary offset [$27FC]
	; Selects the bit shift applied by each of the three bow object types.
	dc.b	$01,$00,$01
Bow_ActionValueAdjustments:		; Memory Address ($2B83) and binary offset [$27FF]
	; Adds the final per-bow adjustment after the bow action value is shifted.
	dc.b	$00,$00,$01

RangedAttack_ClearBowAndAmmoSlots:		; Memory Address ($2B86) and binary offset [$2802]
	clr.b	$00(a0,d4.w)
	clr.b	$0B(a0,d2.w)
	rts		

Record_BowAndArrowPocketCandidates:		; Memory Address ($2B90) and binary offset [$280C]
	; Tests one pocket and records candidate bow and arrow slots for the
	; ranged-attack setup.
	move.b	$00(a0,d3.w),d2
	cmpi.b	#$05,d2
	bcc.s	CheckPocketForBowOrArrow_ArrowRangeCheck
	cmpi.b	#$03,d2
	bcs.s	CheckPocketForBowOrArrow_Return
	move.w	d3,d4
CheckPocketForBowOrArrow_Return:		; Memory Address ($2BA2) and binary offset [$281E]
	rts		

CheckPocketForBowOrArrow_ArrowRangeCheck:		; Memory Address ($2BA4) and binary offset [$2820]
	cmpi.b	#$5C,d2
	bcs.s	CheckPocketForBowOrArrow_Return
	cmpi.b	#$5F,d2
	bcc.s	CheckPocketForBowOrArrow_Return
	move.w	d3,d5
	rts		

PostAttack_CheckSpellSelected:		; Memory Address ($2BB4) and binary offset [$2830]
	tst.b	$0013(a4)
	bmi.s	CommsPeriodicTick_EarlyReturn
	bsr		CastSpell_ValidateSelection
	moveq	#$03,d4
	tst.b	$0013(a4)
	bmi		Resolve_ChampionPhysicalAttack
	addq.b	#$04,$0007(a4)
	rts		

Comms_RunPeriodicTickIfActive:		; Memory Address ($2BCE) and binary offset [$284A]
	; Runs the communications periodic update only while the party-command state is
	; Communication.
	cmp.w	#$0008,$0042(a5)
	beq.s	Comms_PeriodicTick
CommsPeriodicTick_EarlyReturn:		; Memory Address ($2BD6) and binary offset [$2852]
	rts		

Comms_PeriodicTick:		; Memory Address ($2BD8) and binary offset [$2854]
	; Advances communications state once per engine pulse: normalises attitude,
	; counts down delayed replies, rotates the action history when due, and applies
	; the Threat fear roll to the active player's currently selected occupant.
	bsr		Comms_GetState
	and.b	#$3F,$0006(a4)
	subq.b	#$01,$0004(a4)
	bne.s	CommsPeriodicTick_EarlyReturn
	tst.b	$0005(a4)
	bmi.s	CommsPeriodicTick_EarlyReturn
	move.b	$0002(a4),d0
	move.b	$0003(a4),$0002(a4)
	move.b	d0,$0003(a4)
	moveq	#$00,d0
	move.b	$0000(a4),d0
	cmpi.b	#$09,d0
	bne.s	CommsPeriodicTick_DispatchResponse
	movem.l	d0/a4/a5,-(sp)
	bsr		Interface_CheckSelectedCellInteraction
	bcc.s	CommsPeriodicTick_RestoreRegisters
	tst.b	d0
	bmi.s	CommsPeriodicTick_RestoreRegisters
	moveq	#$00,d1
	move.b	$0006(a4),d1
	sub.w	#$000A,d1
	neg.w	d1
	add.w	d1,d1
	move.w	d1,ResistanceCheckPower.w											;Short Absolute converted to symbol!
	bsr		Comms_ApplyThreatFear
	btst	#$05,$03(a1,d4.w)
	beq.s	CommsPeriodicTick_RestoreRegisters
	movem.l	(sp)+,d0/a4/a5
	bra		Click_ShowTeamAvatars

CommsPeriodicTick_RestoreRegisters:		; Memory Address ($2C3C) and binary offset [$28B8]
	movem.l	(sp)+,d0/a4/a5
CommsPeriodicTick_DispatchResponse:		; Memory Address ($2C40) and binary offset [$28BC]
	tst.b	$0006(a4)
	beq		Reset_PartyCommandStateAndRedrawMenu
	lea		Comms_Respond_Recruit.l,a0
	add.w	d0,d0
	add.w	Comms_ResponseHandlerOffsets(pc,d0.w),a0
	move.l	a4,-(sp)
	moveq	#$00,d0
	move.b	$0035(a5),d0
	jsr		(a0)
	move.l	(sp)+,a4
	moveq	#$00,d0
	move.b	$0003(a4),d0
	move.b	$0002(a4),$0003(a4)
	move.b	d0,$0002(a4)
	move.b	$0001(a4),$0000(a4)
	or.b	#$40,$0052(a5)
	move.b	$0035(a5),d0
	cmpi.b	#$10,d0
	bcs.s	CommsPeriodicTick_SetMonsterActionCooldown
	bsr		Load_ChampionStatRecord
	and.b	#$F0,$0019(a4)
	or.b	#$0A,$0019(a4)
Comms_NoOpResponseHandler:		; Memory Address ($2C96) and binary offset [$2912]
	rts		

CommsPeriodicTick_SetMonsterActionCooldown:		; Memory Address ($2C98) and binary offset [$2914]
	lea		BigMonsterList.l,a4
	asl.w	#$04,d0
	and.b	#$F0,$0003(a4)
	or.b	#$0A,$0003(a4)
	rts		

Comms_ResponseHandlerOffsets:		; Memory Address ($2CAE) and binary offset [$292A]
	; Selects the response handler for the other character's preceding
	; communication action.
	dc.w	Comms_Respond_Recruit-Comms_Respond_Recruit	;0000
	dc.w	Comms_NoOpResponseHandler-Comms_Respond_Recruit	;FFB2
	dc.w	Comms_NoOpResponseHandler-Comms_Respond_Recruit	;FFB2
	dc.w	Comms_RespondWithRetort-Comms_Respond_Recruit	;00C2
	dc.w	Comms_NoOpResponseHandler-Comms_Respond_Recruit	;FFB2
	dc.w	Comms_NoOpResponseHandler-Comms_Respond_Recruit	;FFB2
	dc.w	Comms_RespondWithRetort-Comms_Respond_Recruit	;00C2
	dc.w	Comms_RespondWithRetort-Comms_Respond_Recruit	;00C2
	dc.w	Comms_RespondWithRetort-Comms_Respond_Recruit	;00C2
	dc.w	Comms_Respond_LowAttitude-Comms_Respond_Recruit	;00C8
	dc.w	Comms_Respond_WhoGoesOrNameSelf-Comms_Respond_Recruit	;00DA
	dc.w	Comms_Respond_ThyTradeOrRevealSelf-Comms_Respond_Recruit	;010A
	dc.w	Comms_Respond_WhoGoesOrNameSelf-Comms_Respond_Recruit	;00DA
	dc.w	Comms_Respond_ThyTradeOrRevealSelf-Comms_Respond_Recruit	;010A
	dc.w	Comms_RespondWithRetort-Comms_Respond_Recruit	;00C2
	dc.w	Comms_RespondWithRetort-Comms_Respond_Recruit	;00C2
	dc.w	Comms_RespondWithRetort-Comms_Respond_Recruit	;00C2
	dc.w	Comms_Respond_Persons-Comms_Respond_Recruit	;0114
	dc.w	Comms_Respond_Offer-Comms_Respond_Recruit	;012E
	dc.w	Comms_Respond_Purchase-Comms_Respond_Recruit	;0240
	dc.w	Comms_Respond_Exchange-Comms_Respond_Recruit	;026C
	dc.w	Comms_Respond_Sell-Comms_Respond_Recruit	;02E0
	dc.w	Comms_Respond_Praise-Comms_Respond_Recruit	;039A
	dc.w	Comms_Respond_Curse-Comms_Respond_Recruit	;03B6
	dc.w	Comms_Respond_Boast-Comms_Respond_Recruit	;03D0
	dc.w	Comms_RespondWithRetort-Comms_Respond_Recruit	;00C2
	dc.w	Comms_Respond_Greeting-Comms_Respond_Recruit	;03EE

Comms_Respond_Recruit:		; Memory Address ($2CE4) and binary offset [$2960]
	; Handles the other character's response to Recruit, including attitude,
	; patience and party-capacity checks.
	tst.b	$0007(a4)
	bmi		Comms_RespondWithRetort
	cmpi.b	#$10,d0
	bcs.s	Comms_Respond_RecruitChampion
	cmp.b	#$07,$0006(a4)
	bcs		Comms_RespondWithRetort
Comms_PrintRecruitRefusal:		; Memory Address ($2CFC) and binary offset [$2978]
	; Prints the standard recruitment refusal, including the case where the target
	; champion already belongs to the other player.
	lea		Msg_Recruit_Refusal.l,a6
	bra.s	Comms_PrintMessageAndReturn

Comms_Respond_RecruitChampion:		; Memory Address ($2D04) and binary offset [$2980]
	; Resolves recruitment of a champion target: silently returns if already owned
	; by the caller, refuses if owned by the other player, and otherwise continues
	; to the attitude test.
	move.l	a5,-(sp)
	bsr		Find_ChampionOwner
	move.l	a5,a1
	move.l	(sp)+,a5
	tst.w	d1
	bmi.s	Comms_Respond_RecruitThreshold
	cmp.l	a1,a5
	bne.s	Comms_PrintRecruitRefusal
	move.b	#$FF,$0050(a5)
	rts		

Comms_Respond_RecruitThreshold:		; Memory Address ($2D1E) and binary offset [$299A]
	; Selects the recruitment response from attitude: 10 or more succeeds, 5-9 asks
	; the player to continue talking, and below 5 produces a retort.
	cmp.b	#$0A,$0006(a4)
	bcc.s	Comms_Respond_RecruitSuccess
	cmp.b	#$05,$0006(a4)
	bcs.s	Comms_RespondWithRetort
	lea		Msg_Recruit_KeepTalking.l,a6
Comms_PrintMessageAndReturn:		; Memory Address ($2D34) and binary offset [$29B0]
	; Prints the message addressed by A6 and returns; this shared tail serves
	; several communications responses.
	jmp		WriteMessage.l

Comms_Respond_RecruitSuccess:		; Memory Address ($2D3A) and binary offset [$29B6]
	; Completes a successful recruitment when the party has room: prints
	; acceptance, removes the champion's standing-world position and cell
	; occupancy, and assigns the champion to the caller's ownership and formation
	; arrays.
	bsr		Find_FreeOwnershipSlot
	tst.b	$18(a5,d1.w)
	bpl.s	Comms_Respond_RecruitPartyFull
	lea		NumericMessageScratchBuffer.l,a6
	move.w	#$45FF,(a6)
	jsr		Print_npc_message.l
	move.b	$0003(a4),d0
	and.w	#$000F,d0
	move.w	d0,d2
	bsr		Load_ChampionStatRecord
	moveq	#$00,d7
	move.b	$0016(a4),d7
	swap	d7
	move.b	$0017(a4),d7
	move.b	#$FF,$0016(a4)
	bsr		CoordToMap
	bclr	#$07,$01(a6,d0.w)
	bsr		Find_FreeOwnershipSlot
	move.b	d2,$18(a5,d1.w)
	moveq	#$03,d0
CommsRecruit_FindFreeSlotLoop:		; Memory Address ($2D88) and binary offset [$2A04]
	; Scans formation slots 3 down to 0 for a vacant entry to receive a newly
	; recruited champion.
	tst.b	$26(a5,d0.w)
	bmi.s	Comms_WriteFormationSlot
	dbra	d0,CommsRecruit_FindFreeSlotLoop
Comms_WriteFormationSlot:		; Memory Address ($2D92) and binary offset [$2A0E]
	; Writes the recruited champion into the vacant formation slot, closes
	; communications, and returns to the party-command interface.
	move.b	d2,$26(a5,d0.w)
	bsr		Reset_PartyCommandStateAndRedrawMenu
	bra		Refresh_ModeDependentChampionDisplay

Comms_Respond_RecruitPartyFull:		; Memory Address ($2D9E) and binary offset [$2A1A]
	; Prints the party-full response when recruitment cannot add another member.
	lea		Msg_Recruit_PartyFull.l,a6
	bra.s	Comms_PrintMessageAndReturn

Comms_RespondWithRetort:
	; Routes an action to the contextual Retort reply generator.
	moveq	#CommsAction_Retort,d1												;Communication action selected for a contextual Retort.
Run_SelectedCommsAction:		; Memory Address ($2DA8) and binary offset [$2A24]
	; Shared communications response trampoline that enters Comms_RunAction with
	; the action selected in D1.
	bra		Comms_RunAction

Comms_Respond_LowAttitude:		; Memory Address ($2DAC) and binary offset [$2A28]
	; Selects a hostile or dismissive response when attitude is low.
	moveq	#CommsAction_Threat,d1												;Communication action selected by Threat.
	tst.b	$0007(a4)
	bmi.s	Run_SelectedCommsAction
	cmp.b	#$0A,$0006(a4)
	bcs.s	Run_SelectedCommsAction
	bra.s	Comms_RespondWithRetort

Comms_Respond_WhoGoesOrNameSelf:		; Memory Address ($2DBE) and binary offset [$2A3A]
	; Responds to identity questions, revealing a champion name or special monster
	; identity when permitted.
	moveq	#CommsAction_NameSelf,d1											;Communication action selected by Name Self.
	cmpi.b	#$10,d0
	bcs.s	Run_SelectedCommsAction
	cmp.b	#$05,$0006(a4)
	bcs.s	Comms_RespondWithRetort
	lea		Msg_WhoGoes_NameUnimportant.l,a6
	lea		BigMonsterList.l,a1
	asl.w	#$04,d0
Zendik_Named:
	cmp.b	#$40,$0B(a1,d0.w)
	bne.s	NotNamed
	lea		Msg_WhoGoes_Zendik.l,a6
NotNamed:
	bra		Comms_PrintMessageAndReturn

Comms_Respond_ThyTradeOrRevealSelf:		; Memory Address ($2DEE) and binary offset [$2A6A]
	; Responds to profession questions, revealing a champion profession when
	; applicable.
	cmpi.b	#$10,d0
	bcc.s	Comms_RespondWithRetort
	moveq	#CommsAction_RevealSelf,d1											;Communication action selected by Reveal Self.
	bra.s	Run_SelectedCommsAction

Comms_Respond_Persons:		; Memory Address ($2DF8) and binary offset [$2A74]
	; Selects the response to the Persons inquiry according to attitude and
	; randomness.
	moveq	#-$02,d0
	cmp.b	#$0A,$0006(a4)
	bcs.s	Persons_RandomBoastOrRetort
	bra		Comms_Action_Praise

Persons_RandomBoastOrRetort:		; Memory Address ($2E06) and binary offset [$2A82]
	bsr		RandomGen_BytewithOffset
	moveq	#CommsAction_Boast,d1												;Communication action selected by Boast.
	tst.b	d0
	bmi.s	Run_SelectedCommsAction
	bra.s	Comms_RespondWithRetort

Comms_Respond_Offer:		; Memory Address ($2E12) and binary offset [$2A8E]
	; Handles acceptance and transfer of an offered held object or coinage.
	cmpi.b	#$10,d0
	bcs.s	Comms_RespondWithRetort
	move.w	HeldItem_ObjectCodeOffset(a5),d1									;Offset of the currently held object code in the interface state.
	cmp.b	$000A(a4),d1
	bne		Trade_DecrementPatience_RipOffPath
	tst.w	d1
	beq.s	Offer_CoinageOffered_SetFlagAndRetort
	cmpi.b	#Object_Permit,d1													;Permit object and exclusive end of bows.
	beq.s	Offer_DispatchByTradeMode
	cmpi.b	#Object_Remains_First,d1											;First champion-remains object and first normally non-tradable object.
	bcc		Comms_RejectUntradeableObject
Offer_DispatchByTradeMode:		; Memory Address ($2E36) and binary offset [$2AB2]
	moveq	#$00,d2
	move.b	$0008(a4),d2
	lea		Comms_AcceptOfferedObject.l,a0
	add.w	d2,d2
	add.w	Comms_TradeModeHandlerOffsets(pc,d2.w),a0
	jmp		(a0)

Comms_TradeModeHandlerOffsets:		; Memory Address ($2E4A) and binary offset [$2AC6]
	; Selects transfer behaviour for the active purchase, exchange or sell mode.
	dc.w	Comms_AcceptOfferedObject-Comms_AcceptOfferedObject	;0000
	dc.w	Comms_BuyOfferedObject-Comms_AcceptOfferedObject	;0026
	dc.w	Comms_ExchangeOfferedObject-Comms_AcceptOfferedObject	;0088
	dc.w	Comms_AcceptOfferedObject-Comms_AcceptOfferedObject	;0000

Offer_CoinageOffered_SetFlagAndRetort:		; Memory Address ($2E52) and binary offset [$2ACE]
	move.b	#$08,$0000(a4)
	bra		Comms_RespondWithRetort

Comms_AcceptOfferedObject:		; Memory Address ($2E5C) and binary offset [$2AD8]
	; Accepts an offered object after its tradeability has been checked.
	cmpi.b	#Object_Permit,d1													;Permit object and exclusive end of bows.
	beq.s	AcceptOffer_ClearHeldItemState
	sub.w	#Object_TradeValueTable_First,d1									;First object represented by the trade-value lookup table.
	bcs.s	AcceptOffer_ClearHeldItemState
	lea		Comms_ObjectTradeValues.l,a0
	tst.b	$00(a0,d1.w)
	bmi		Comms_RejectUntradeableObject
AcceptOffer_ClearHeldItemState:		; Memory Address ($2E76) and binary offset [$2AF2]
	clr.l	HeldItem_StateOffset(a5)											;Offset of the combined held-item quantity and object-code state.
Trade_FinishExchangeAndRefreshDisplay:		; Memory Address ($2E7A) and binary offset [$2AF6]
	bsr		Comms_FinishTradeExchange
	bra		Refresh_HeldItemDisplay

Comms_BuyOfferedObject:		; Memory Address ($2E82) and binary offset [$2AFE]
	; Calculates the attitude-adjusted purchase price of an object offered by the
	; player.
	move.w	$002C(a5),d4
	cmp.b	$0009(a4),d4
	bcs		Trade_DecrementPatience_RipOffPath
	bsr		Comms_GetMonsterTradeObject
	move.w	$002C(a5),d4
	move.w	d0,d3
	moveq	#$01,d2
	sub.b	#$14,d3
	bcs.s	BuyOffer_ClampAttitudeMultiplier
	cmpi.b	#$5F,d0
	bne.s	BuyOffer_LookupObjectBaseValue
	moveq	#$5A,d2
	bra.s	BuyOffer_ClampAttitudeMultiplier

BuyOffer_LookupObjectBaseValue:		; Memory Address ($2EAA) and binary offset [$2B26]
	lea		Comms_ObjectTradeValues.l,a1
	move.b	$00(a1,d3.w),d2
BuyOffer_ClampAttitudeMultiplier:		; Memory Address ($2EB4) and binary offset [$2B30]
	moveq	#$6E,d3
	sub.b	$0006(a4),d3
	cmp.b	#$50,d3
	bcc.s	BuyOffer_ComparePriceToThreshold
	moveq	#$50,d3
BuyOffer_ComparePriceToThreshold:		; Memory Address ($2EC2) and binary offset [$2B3E]
	mulu	d3,d2
	divu	#$0064,d2
	cmp.b	d2,d4
	bcs.s	BuyOffer_PriceTooLow_RespondNo
	move.b	#$06,$0C(a0,d1.w)
Comms_AcceptTrade_StoreNewHeldItem:		; Memory Address ($2ED2) and binary offset [$2B4E]
	move.b	d0,$002F(a5)
	move.w	#$0001,$002C(a5)
	bra.s	Trade_FinishExchangeAndRefreshDisplay

BuyOffer_PriceTooLow_RespondNo:		; Memory Address ($2EDE) and binary offset [$2B5A]
	moveq	#$07,d1
	bra		Run_SelectedCommsAction

Comms_ExchangeOfferedObject:		; Memory Address ($2EE4) and binary offset [$2B60]
	; Compares offered-object values and completes an acceptable exchange.
	lea		Comms_ObjectTradeValues.l,a1
	moveq	#$02,d2
	sub.w	#$0014,d1
	bcs.s	ExchangeOffer_GetMonsterItemValue
	cmpi.b	#$4B,d1
	bne.s	ExchangeOffer_LookupOfferedItemValue
	moveq	#$5A,d2
	bra.s	ExchangeOffer_GetMonsterItemValue

ExchangeOffer_LookupOfferedItemValue:		; Memory Address ($2EFC) and binary offset [$2B78]
	move.b	$00(a1,d1.w),d2
	bmi		Trade_ClearModeBeforeRejectUntradeable
ExchangeOffer_GetMonsterItemValue:		; Memory Address ($2F04) and binary offset [$2B80]
	bsr		Comms_GetMonsterTradeObject
	move.w	d0,d4
	moveq	#$02,d3
	sub.w	#$0014,d4
	bcs.s	ExchangeOffer_CompareItemValues
	move.b	$00(a1,d4.w),d3
ExchangeOffer_CompareItemValues:		; Memory Address ($2F16) and binary offset [$2B92]
	cmp.b	d3,d2
	bcs		Trade_RespondOfferTooLow
	move.b	$002F(a5),$0C(a0,d1.w)
	bra.s	Comms_AcceptTrade_StoreNewHeldItem

Comms_Respond_Purchase:		; Memory Address ($2F24) and binary offset [$2BA0]
	; Selects trader merchandise and produces the response to Purchase.
	cmpi.b	#$10,d0
	bcs		Comms_RespondWithRetort
Comms_SelectTraderStock:
	; Uses the monster type to select or initialise the object offered for sale.
	bsr		Comms_GetMonsterTradeObject
	lea		$00(a0,d1.w),a1
	cmp.b	#$15,$000B(a1)
	bcs.s	Comms_PrintPurchaseObject
	cmp.b	#$17,$000B(a1)
	bcc.s	Comms_PrintPurchaseObject
	bsr		Comms_InitialiseMonsterTrader
	move.b	$000C(a1),d0
Comms_PrintPurchaseObject:
	; Builds the purchase response using the monster's currently offered object.
	bra		TradeMessage_PrepareHeldItemTemplate

Comms_Respond_Exchange:
	; Compares the offered and requested object values and begins an exchange when
	; acceptable.
	cmpi.b	#$10,d0
	bcs		Comms_RespondWithRetort
	move.w	$002E(a5),d1
	cmp.b	$000A(a4),d1
	bne		Trade_DecrementPatience_RipOffPath
	tst.w	d1
	beq.s	Comms_SelectTraderStock
	lea		Comms_ObjectTradeValues.l,a1
	cmpi.b	#$5F,d1
	bne.s	Comms_CompareExchangeObject
	moveq	#$5A,d2
	bra.s	RespondExchange_GetCounterItemValue

Comms_CompareExchangeObject:
	; Loads the trade value of the held object for an exchange comparison.
	cmpi.b	#$40,d1
	bcc		Comms_RejectUntradeableObject
	moveq	#$02,d2
	sub.w	#$0014,d1
	bcs.s	RespondExchange_GetCounterItemValue
	move.b	$00(a1,d1.w),d2
	bmi		Trade_ClearModeBeforeRejectUntradeable
RespondExchange_GetCounterItemValue:		; Memory Address ($2F90) and binary offset [$2C0C]
	bsr		Comms_GetMonsterTradeObject
	move.w	d0,d1
	moveq	#$02,d3
	sub.w	#$0014,d1
	bcs.s	RespondExchange_AcceptAndDispatchOffer
	move.b	$00(a1,d1.w),d3
RespondExchange_AcceptAndDispatchOffer:		; Memory Address ($2FA2) and binary offset [$2C1E]
	cmp.b	d3,d2
	bcs.s	Trade_RespondOfferTooLow
	move.b	#$12,$0001(a4)
	bra		TradeItem_CheckIfCoinage

Trade_RespondOfferTooLow:		; Memory Address ($2FB0) and binary offset [$2C2C]
	lea		Msg_Trade_OfferTooLow.l,a6
	jmp		Print_npc_message.l

Sell_NoItemOffered_ClearModeAndRetort:		; Memory Address ($2FBC) and binary offset [$2C38]
	clr.b	$0008(a4)
	bra		Comms_RespondWithRetort

Comms_Respond_Sell:		; Memory Address ($2FC4) and binary offset [$2C40]
	; Handles the response to Sell and validates the held object and quoted value.
	cmpi.b	#$10,d0
	bcs		Comms_RespondWithRetort
	move.w	$002E(a5),d0
	beq.s	Sell_NoItemOffered_ClearModeAndRetort
	cmp.b	$000A(a4),d0
	beq.s	Sell_HandlePermitObject
Trade_DecrementPatience_RipOffPath:		; Memory Address ($2FD8) and binary offset [$2C54]
	subq.b	#$05,$0006(a4)
	bpl.s	Trade_PrintRipOffMessage
	clr.b	$0006(a4)
Trade_PrintRipOffMessage:		; Memory Address ($2FE2) and binary offset [$2C5E]
	lea		Msg_Trade_RipOff.l,a6
	jmp		WriteMessage.l

Sell_HandlePermitObject:		; Memory Address ($2FEE) and binary offset [$2C6A]
	cmpi.b	#$5F,d0
	bne.s	Sell_CheckObjectValueRange
	moveq	#$5A,d0
	bra.s	Sell_ComputeDefaultGoldOffer

Sell_CheckObjectValueRange:		; Memory Address ($2FF8) and binary offset [$2C74]
	cmpi.b	#$40,d0
	bcc.s	Comms_RejectUntradeableObject
	sub.b	#$14,d0
	bcc.s	Sell_LookupObjectBaseValue
	moveq	#$01,d0
	bra		Comms_PrintGoldOffer

Sell_LookupObjectBaseValue:		; Memory Address ($300A) and binary offset [$2C86]
	lea		Comms_ObjectTradeValues.l,a0
	move.b	$00(a0,d0.w),d0
	bmi.s	Trade_ClearModeBeforeRejectUntradeable
Sell_ComputeDefaultGoldOffer:		; Memory Address ($3016) and binary offset [$2C92]
	moveq	#$00,d2
	move.b	$0009(a4),d2
	bne.s	Sell_CheckIfPriceTooGreedy
	moveq	#$00,d1
	move.b	$0006(a4),d1
	sub.w	#$000A,d1
	add.w	#$003C,d1
	cmp.w	#$0064,d1
	bcc		Comms_PrintGoldOffer
	mulu	d1,d0
	divu	#$0064,d0
	bra		Comms_PrintGoldOffer

Sell_CheckIfPriceTooGreedy:		; Memory Address ($303E) and binary offset [$2CBA]
	bpl.s	Sell_ComputeHighAttitudeGoldOffer
	clr.b	$0008(a4)
	lea		Msg_Trade_TooGreedy.l,a6
	move.b	#$19,$0001(a4)
	bra		Comms_PrintMessageAndReturn

Sell_ComputeHighAttitudeGoldOffer:		; Memory Address ($3054) and binary offset [$2CD0]
	cmp.b	#$0F,$0006(a4)
	bcs.s	Comms_VeryLowAttitude_DispatchCurse
	sub.b	d2,d0
	lsr.b	#$01,d0
	add.b	d2,d0
	bset	#$07,d0
	bra		Comms_PrintGoldOffer

Trade_ClearModeBeforeRejectUntradeable:		; Memory Address ($306A) and binary offset [$2CE6]
	clr.b	$0008(a4)
Comms_RejectUntradeableObject:
	; Rejects an object that cannot safely participate in trading.
	move.b	#$07,$0001(a4)
	lea		Msg_Trade_UnnaturalObject.l,a6
	bra		Comms_PrintMessageAndReturn

Comms_Respond_Praise:		; Memory Address ($307E) and binary offset [$2CFA]
	; Selects a complimentary, neutral or hostile response to Praise from the
	; current attitude.
	moveq	#CommsAction_Praise,d1												;Communication action selected by Praise.
	cmp.b	#$0A,$0006(a4)
	bcc		Run_SelectedCommsAction
	cmp.b	#$05,$0006(a4)
	bcc		Comms_RespondWithRetort
Comms_VeryLowAttitude_DispatchCurse:		; Memory Address ($3094) and binary offset [$2D10]
	moveq	#$17,d1
	bra		Run_SelectedCommsAction

Comms_Respond_Curse:		; Memory Address ($309A) and binary offset [$2D16]
	; Selects a curse, retort or threat response according to attitude and
	; patience.
	moveq	#CommsAction_Curse,d1												;Communication action selected by Curse.
	cmp.b	#$05,$0006(a4)
	bcc		Run_SelectedCommsAction
	tst.b	$0007(a4)
	bpl		Comms_RespondWithRetort
	moveq	#$09,d1
	bra		Run_SelectedCommsAction

Comms_Respond_Boast:		; Memory Address ($30B4) and binary offset [$2D30]
	; Selects a praise, boast, retort or hostile response to Boast.
	cmp.b	#$0A,$0006(a4)
	bcc.s	Comms_Respond_Praise
	moveq	#CommsAction_Boast,d1												;Communication action selected by Boast.
	cmp.b	#$07,$0006(a4)
	bcc		Run_SelectedCommsAction
	tst.b	$0007(a4)
	bmi.s	Comms_Respond_Curse
	bra		Comms_RespondWithRetort

Comms_Respond_Greeting:		; Memory Address ($30D2) and binary offset [$2D4E]
	; Selects the initial reply, ranging from hostility to an identity or
	; profession question.
	cmp.b	#$02,$0006(a4)
	bcs		Comms_Respond_LowAttitude
	cmp.b	#$05,$0006(a4)
	bcs.s	Comms_Respond_Curse
	cmp.b	#$08,$0006(a4)
	bcs		Comms_RespondWithRetort
	bsr		RandomGen_BytewithOffset
	moveq	#CommsAction_WhoGoes,d1												;Communication action selected by Who Goes.
	tst.b	d0
	bmi		Run_SelectedCommsAction
	moveq	#CommsAction_ThyTrade,d1											;Communication action selected by Thy Trade.
	bra		Run_SelectedCommsAction

Msg_Recruit_PartyFull:
	; Character response when Recruit succeeds on attitude but the party has no
	; free slot.
	dc.b	'THY PARTY IS FULL'
	dc.b	$FF	;FF
Msg_Trade_RipOff:
	; Character response when the held object or trade state no longer matches the
	; proposed deal.
	dc.b	'WOULDST THOU RIP ME OFF?'
	dc.b	$FF	;FF
Msg_Trade_UnnaturalObject:
	; Character response rejecting an untradeable or unnatural object.
	dc.b	'I NEVER TRUST THE UNNATURAL'
	dc.b	$FF	;FF
Msg_Recruit_KeepTalking:
	; Character response when Recruit attitude is promising but below the joining
	; threshold.
	dc.b	'KEEP TALKING AND WE''LL SEE'
	dc.b	$FF	;FF
Msg_Recruit_Refusal:
	; Character response refusing recruitment or interaction.
	dc.b	'I THINK NOT MY FRIEND'
	dc.b	$FF	;FF
Msg_WhoGoes_NameUnimportant:
	; Monster response refusing to reveal a name.
	dc.b	'MY NAME IS NOT IMPORTANT'
	dc.b	$FF	;FF
Msg_WhoGoes_Zendik:
	; Special identity response used when the addressed monster is Zendik.
	dc.b	'I AM ZENDIK THE MASTER OF CREATION'
	dc.b	$FF	;FF
Msg_Trade_TooGreedy:
	; Character response when a trade request becomes too greedy.
	dc.b	'METHINKS THOU ART TOO GREEDY!'
	dc.b	$FF	;FF
Msg_Trade_OfferTooLow:		; Memory Address ($31D2) and binary offset [$2E4E]
	; Packed-word character response rejecting an inadequate trade offer.
	dc.b	$1A	;1A
	dc.b	$19	;19
	dc.b	$61	;61
	dc.b	$8D	;8D
	dc.b	$B1	;B1
	dc.b	$51	;51
	dc.b	$FF	;FF
Msg_Trade_GoldOfferTemplate:		; Memory Address ($31D9) and binary offset [$2E55]
	; Writable packed-word template used to communicate a generated amount of gold.
	dc.b	$CC	;CC
	dc.b	$1A	;1A
	dc.b	$1D	;1D
	dc.b	$FA	;FA
	dc.b	$20	;20
	dc.b	$FA	;FA
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
Comms_ObjectTradeValues:		; Memory Address ($31E6) and binary offset [$2E62]
	; Trade values for object codes $14-$3F; $FF marks objects rejected by the
	; trading logic.
	dc.b	$04	;04
	dc.b	$04	;04
	dc.b	$06	;06
	dc.b	$0A	;0A
	dc.b	$0F	;0F
	dc.b	$08	;08
	dc.b	$0C	;0C
	dc.b	$07	;07
	dc.b	$0C	;0C
	dc.b	$10	;10
	dc.b	$14	;14
	dc.b	$19	;19
	dc.b	$20	;20
	dc.b	$27	;27
	dc.b	$2B	;2B
	dc.b	$32	;32
	dc.b	$06	;06
	dc.b	$0A	;0A
	dc.b	$19	;19
	dc.b	$0F	;0F
	dc.b	$14	;14
	dc.b	$1E	;1E
	dc.b	$28	;28
	dc.b	$FF	;FF
	dc.b	$0A	;0A
	dc.b	$12	;12
	dc.b	$1B	;1B
	dc.b	$23	;23
	dc.b	$05	;05
	dc.b	$14	;14
	dc.b	$0A	;0A
	dc.b	$0A	;0A
	dc.b	$0F	;0F
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$5A	;5A
	dc.b	$0C	;0C
	dc.b	$14	;14
	dc.b	$19	;19
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$08	;08
	dc.b	$0F	;0F
	dc.b	$FF	;FF
Comms_TraderStockObjects:
	; Object-code pool used to choose merchandise for non-potion monster traders.
	dc.b	$3D	;3D
	dc.b	$33	;33
	dc.b	$24	;24
	dc.b	$25	;25
	dc.b	$30	;30
	dc.b	$1B	;1B
	dc.b	$1C	;1C
	dc.b	$32	;32
	dc.b	$2C	;2C
	dc.b	$27	;27
	dc.b	$38	;38
	dc.b	$1D	;1D
	dc.b	$2C	;2C
	dc.b	$27	;27
	dc.b	$38	;38
	dc.b	$1D	;1D
	dc.b	$2D	;2D
	dc.b	$14	;14
	dc.b	$34	;34
	dc.b	$1E	;1E
	dc.b	$39	;39
	dc.b	$39	;39
	dc.b	$34	;34
	dc.b	$2D	;2D
	dc.b	$3E	;3E
	dc.b	$1E	;1E
	dc.b	$1F	;1F
	dc.b	$15	;15
	dc.b	$1F	;1F
	dc.b	$16	;16
	dc.b	$3E	;3E
	dc.b	$1F	;1F

Comms_GetMonsterTradeObject:		; Memory Address ($3232) and binary offset [$2EAE]
	; Returns the object stored in byte $0C of the selected monster record.
	move.w	d0,d1
	lea		BigMonsterList.l,a0
	asl.w	#$04,d1
	move.b	$0C(a0,d1.w),d0
	rts		

Comms_PrintGoldOffer:
	; Formats a calculated trade value into the packed gold-offer message.
	move.b	d0,$0009(a4)
	and.w	#$007F,d0
	jsr		Convert_ByteToDecimalText.l
	lea		Msg_Trade_GoldOfferTemplate.w,a6									;Short Absolute converted to symbol!
	moveq	#$06,d2
	ror.w	#$08,d1
	cmpi.b	#$30,d1
	beq.s	GoldOffer_WriteOnesDigitAndFinish
	move.b	d1,$00(a6,d2.w)
	move.b	#$FA,$01(a6,d2.w)
	addq.w	#$02,d2
GoldOffer_WriteOnesDigitAndFinish:		; Memory Address ($326A) and binary offset [$2EE6]
	ror.w	#$08,d1
	move.b	d1,$00(a6,d2.w)
	move.b	#$54,$01(a6,d2.w)
	addq.w	#$02,d2
	bra		TradeMessage_AppendSuffixAndPrint

Comms_InitialiseMonsterTrader:
	; Initialises monster-trader stock and applies the monster's initial attitude
	; penalty.
	movem.w	d0/d1,-(sp)
	move.b	#$03,$0006(a4)
	cmp.b	#$40,$000B(a1)
	beq.s	InitialiseMonsterTrader_RestoreAndReturn
	bsr		RandomGen_BytewithOffset
	cmp.b	#$16,$000B(a1)
	bne.s	.Trader_NotPotionsButArms
	and.w	#$0003,d0
	add.w	#$0017,d0
	move.b	d0,$000C(a1)
	bra.s	InitialiseMonsterTrader_RestoreAndReturn

.Trader_NotPotionsButArms:		; Memory Address ($32A8) and binary offset [$2F24]
	and.w	#$001F,d0
	move.b	$0006(a1),d1
	cmpi.b	#$08,d1
	bcc.s	.DontDivideList
	lsr.w	#$01,d0
	cmpi.b	#$04,d1
	bcc.s	.DontDivideList
	lsr.w	#$01,d0
.DontDivideList:		; Memory Address ($32C0) and binary offset [$2F3C]
	lea		Comms_TraderStockObjects.w,a0										;Short Absolute converted to symbol!
	move.b	$00(a0,d0.w),$000C(a1)
	move.b	$0006(a1),d0
	and.w	#$007F,d0
	neg.b	d0
	move.b	d0,$0006(a4)
InitialiseMonsterTrader_RestoreAndReturn:		; Memory Address ($32D8) and binary offset [$2F54]
	movem.w	(sp)+,d0/d1
	rts		

Click_ShowTeamAvatars:		; Memory Address ($32DE) and binary offset [$2F5A]
	; Clears the command-selection state and redraws the ordinary party
	; shield/avatar presentation; it does not open a separate team screen.
	move.b	#$01,$0052(a5)
	clr.b	$004A(a5)
	tst.b	$004B(a5)
	bmi.s	ShowTeamAvatars_CheckCommandState
	move.w	#$00FF,$004A(a5)
ShowTeamAvatars_CheckCommandState:		; Memory Address ($32F4) and binary offset [$2F70]
	cmp.w	#$0008,$0042(a5)
	beq.s	CommsWait_CheckCounterThreshold
	tst.w	$0042(a5)
	bne.s	Reset_PartyCommandStateAndRedrawMenu
	move.w	#$FFFF,$0042(a5)													;Enters the negative team-avatar state consumed by Draw_PartyCommandInterface; the dirty slot renderer then uses each selected-slot bit to choose full-length drawing.
	move.w	#$FFFF,$0040(a5)
	bra		Draw_PartyCommandInterface

CommsWait_CheckCounterThreshold:		; Memory Address ($3312) and binary offset [$2F8E]
	cmp.w	#$0006,$0044(a5)
	bcs.s	Reset_PartyCommandStateAndRedrawMenu
Advance_CommsWaitIndicatorAndDraw:		; Memory Address ($331A) and binary offset [$2F96]
	; Advances the communications response-wait animation divider, redraws its
	; icons, and returns to the command menu.
	lsr.w	$0044(a5)
	addq.w	#$01,$0044(a5)
	bsr		Draw_CommsWaitIndicatorIcons
	bra		Draw_PartyCommandMenu

Reset_PartyCommandStateAndRedrawMenu:		; Memory Address ($332A) and binary offset [$2FA6]
	; Clears the party-command state, substate, and selected target before
	; restoring the command-menu graphics.
	clr.w	$0042(a5)
	clr.w	$0044(a5)
	move.b	#$FF,$0035(a5)
Draw_BlankCommandIconsAndMenu:		; Memory Address ($3338) and binary offset [$2FB4]
	; Draws the two blank command-panel icons and returns to the root party-command
	; menu.
	move.l	#$003B003B,d7
	bsr.s	Draw_CommandPanelIconPair
	bra		Draw_PartyCommandMenu

Draw_CommsWaitIndicatorIcons:		; Memory Address ($3344) and binary offset [$2FC0]
	; Loads pocket icon codes $76 and $75 and enters the shared icon-pair renderer
	; for the communications-wait state.
	move.l	#$00760075,d7
Draw_CommandPanelIconPair:		; Memory Address ($334A) and binary offset [$2FC6]
	; Draws the two command-panel pocket graphics packed into D7 at the active
	; player's panel position.
	move.l	screen_ptr.l,a0
	add.w	#$0647,a0
	add.w	$000A(a5),a0
	move.w	d7,d0
	swap	d7
	jsr		Draw_PocketGraphic.l
	move.w	d7,d0
	jmp		Draw_PocketGraphic.l

PartyCommand_DispatchSelection:		; Memory Address ($336A) and binary offset [$2FE6]
	; Decodes the selected party-command button from the interface selection bytes
	; and dispatches the current party-command state.
	move.l	$0046(a5),a6														;Loads the packed command-row definition used to translate the selected button into a party-command index.
	moveq	#$00,d1
	move.b	$0040(a5),d0
	and.w	#$0003,d0
	subq.b	#$01,d0
	bcs.s	DispatchSelection_FinalizeButtonIndex
DispatchSelection_CountValidButtonsLoop:		; Memory Address ($337C) and binary offset [$2FF8]
	addq.w	#$01,d1
	cmp.b	#$5F,(a6)+															;Command descriptors below $5F consume an additional position while the visible command rows are flattened into one index.
	bcc.s	DispatchSelection_LoopContinue
	addq.w	#$01,d1
DispatchSelection_LoopContinue:		; Memory Address ($3386) and binary offset [$3002]
	dbra	d0,DispatchSelection_CountValidButtonsLoop
DispatchSelection_FinalizeButtonIndex:		; Memory Address ($338A) and binary offset [$3006]
	add.b	$0041(a5),d1														;Adds the selected command sub-index to the command index derived from the packed row definition.
PartyCommand_DispatchState:		; Memory Address ($338E) and binary offset [$300A]
	; Dispatches party-command states 0 through 8 through
	; PartyCommand_HandlerOffsets: resolve selection, Communicate, Commend, View,
	; Wait, Correct, Dismiss, Call, or handle the active communication menu.
	move.w	$0042(a5),d0														;Loads party-command state 0 through 8 for dispatch through the handler-offset table.
	add.w	d0,d0
	lea		PartyCommand_ResolveSelection.l,a0
	add.w	PartyCommand_HandlerOffsets(pc,d0.w),a0								;Adds the selected word-relative offset to the common table base to obtain the party-command handler address.
	jmp		(a0)

PartyCommand_HandlerOffsets:		; Memory Address ($33A0) and binary offset [$301C]
	; Nine word-relative handler offsets for party-command states 0 through 8:
	; resolve selection, Communicate, Commend, View, Wait, Correct, Dismiss, Call,
	; and the active communication menu.
	dc.w	PartyCommand_ResolveSelection-PartyCommand_ResolveSelection	;0000
	dc.w	PartyCommand_Communicate-PartyCommand_ResolveSelection	;003C
	dc.w	PartyCommand_Commend-PartyCommand_ResolveSelection	;0D9E
	dc.w	PartyCommand_View-PartyCommand_ResolveSelection	;0D32
	dc.w	PartyCommand_Wait-PartyCommand_ResolveSelection	;0BAE
	dc.w	PartyCommand_Correct-PartyCommand_ResolveSelection	;0D92
	dc.w	PartyCommand_Dismiss-PartyCommand_ResolveSelection	;0BAA
	dc.w	PartyCommand_Call-PartyCommand_ResolveSelection	;0AEA
	dc.w	Comms_HandleMenuSelection-PartyCommand_ResolveSelection	;011A

PartyCommand_ResolveSelection:		; Memory Address ($33B2) and binary offset [$302E]
	; Clears the pending target-selection flag, converts the decoded button number
	; to party-command state 1 through 8, stores it, and redispatches.
	clr.b	$004E(a5)															;Clears the party-member target-selection flag before entering the chosen command handler.
	addq.w	#$01,d1																;Converts the decoded zero-based command index into party-command state 1 through 8.
	move.w	d1,$0042(a5)														;Stores the selected party-command state for immediate redispatch.
	bra.s	PartyCommand_DispatchState

Interface_CheckSelectedCellInteraction:		; Memory Address ($33BE) and binary offset [$303A]
	; Checks map bounds and selected-cell metadata, then resolves an interaction
	; target; Communicate uses its carry result, but this helper is also called by
	; other interface paths.
	bsr		ForwardCellToMapOffset
	move.l	d7,d2
	cmp.w	CurrentFloorHeight.l,d7
	bcc.s	CheckCellInteraction_NoTargetReturn
	swap	d7
	cmp.w	CurrentFloorWidth.l,d7
	bcc.s	CheckCellInteraction_NoTargetReturn
	move.b	$01(a6,d0.w),d1
	bpl.s	CheckCellInteraction_NoTargetReturn
	and.w	#$0007,d1
	subq.w	#$01,d1
	beq.s	CheckCellInteraction_NoTargetReturn
	move.w	PlayerData_Floor(a5),d1												;Player record word selecting the active floor, not a map-cell offset.
	bra		Find_DungeonCellOccupant

CheckCellInteraction_NoTargetReturn:		; Memory Address ($33EC) and binary offset [$3068]
	rts		

PartyCommand_Communicate:		; Memory Address ($33EE) and binary offset [$306A]
	; Resolves a valid character or monster at the selected map cell and starts
	; communication through Comms_StartWithTarget; otherwise displays "THERE IS
	; NOBODY HERE".
	bsr.s	Interface_CheckSelectedCellInteraction								;Resolves a character or monster at the selected dungeon cell.
	bcs.s	Comms_StartWithTarget												;Carry set identifies a valid interaction target and begins communication with it.
Interface_ReportCommunicationTargetUnavailable:		; Memory Address ($33F2) and binary offset [$306E]
	; Prints the unavailable-target notice and clears the interface page state.
	lea		Notice_Communicate_NobodyHere.l,a6									;Selects the packed Communicate failure notice "THERE IS NOBODY HERE".
	clr.w	$0042(a5)															;Returns the party-command dispatcher to its initial state after Communicate finds no target.
	jmp		Print_timed_message.l

Comms_StartWithTarget:		; Memory Address ($3402) and binary offset [$307E]
	; Initialises communication state for the selected champion or monster and
	; prints the greeting.
	move.w	d0,d1
	bsr		Load_CurrentChampionStatRecord
	move.b	#CharacterActionState_CommunicationStart,ChampionStat_ActionState(a4)
	move.w	d1,d0
	bsr		Comms_GetState
	clr.b	$0006(a4)
	move.b	#CommsAction_Greeting,CommsState_PreviousActionOffset(a4)			;Initial communication action used when a conversation begins.
	bclr	#$07,$0005(a4)
	tst.b	d0
	bmi.s	StartComms_InitNewCommsRecord
	move.w	$0020(a5),d1
	eor.w	#$0002,d1
	moveq	#$18,d4
	cmpi.w	#$0010,d0
	bcs.s	StartComms_ApplyTargetStateFlags
	tst.b	$000B(a1)
	bmi.s	Interface_ReportCommunicationTargetUnavailable
	bsr		Comms_InitialiseMonsterTrader
	moveq	#$02,d4
StartComms_ApplyTargetStateFlags:		; Memory Address ($3444) and binary offset [$30C0]
	and.b	#$F0,$00(a1,d4.w)
	or.b	$00(a1,d4.w),d1
	move.b	d1,$00(a1,d4.w)
	move.b	d0,$0035(a5)
	bra.s	StartComms_InitialiseCommsFields

StartComms_InitNewCommsRecord:		; Memory Address ($3458) and binary offset [$30D4]
	bset	#$07,$0005(a4)
	move.w	$0006(a1),d0
StartComms_InitialiseCommsFields:		; Memory Address ($3462) and binary offset [$30DE]
	move.b	$0007(a5),$0003(a4)
	and.w	#$007F,d0
	move.b	d0,$0002(a4)
	move.l	a4,-(sp)
	bsr		Load_CurrentChampionStatRecord
	move.b	ChampionStat_Charisma(a4),d2										;Offset of Charisma in a thirty-two-byte champion-stat record.
	move.l	(sp)+,a4
	bsr		RandomGen_BytewithOffset
	and.w	#$0007,d0
	addq.w	#$02,d0
	sub.b	#Comms_CharismaBaseline,d2											;Charisma receives no initial communication bonus at or below this value.
	bcc.s	StartComms_ApplyCharismaBonus
	moveq	#$00,d2
StartComms_ApplyCharismaBonus:		; Memory Address ($348E) and binary offset [$310A]
	lsr.b	#Comms_CharismaShift,d2												;Right shift converting excess Charisma into an initial attitude bonus.
	add.b	d2,d0
	add.b	CommsState_AttitudeOffset(a4),d0									;Offset of mutable communication attitude or rapport.
	bpl.s	StartComms_StoreInitialAttitude
	moveq	#$00,d0
StartComms_StoreInitialAttitude:		; Memory Address ($349A) and binary offset [$3116]
	move.b	d0,CommsState_AttitudeOffset(a4)									;Offset of mutable communication attitude or rapport.
	bsr		RandomGen_BytewithOffset
	and.w	#$0007,d0
	addq.w	#$08,d0
	move.b	d0,CommsState_PatienceOffset(a4)									;Offset of communication patience or remaining engagement.
	move.b	#$14,$0004(a4)
	clr.b	$0008(a4)
	lea		Msg_Greeting.l,a6
	jsr		Print_npc_message.l
	move.w	#$0004,$0044(a5)
	bra		Comms_FinishAction_RedrawMenu

Comms_HandleMenuSelection:		; Memory Address ($34CC) and binary offset [$3148]
	; Converts the visible communication menu and button into an action and runs
	; it.
	move.w	InterfaceState_MenuOffset(a5),d0
	subq.w	#$04,d0
	beq.s	HandleMenuSelection_ResolveAndRunAction
	addq.w	#$04,d1
	subq.w	#$01,d0
	beq.s	HandleMenuSelection_ResolveAndRunAction
	addq.w	#$02,d1
	asl.w	#$02,d0
	add.w	d0,d1
HandleMenuSelection_ResolveAndRunAction:		; Memory Address ($34E0) and binary offset [$315C]
	bsr		Comms_GetState
	addq.b	#$01,CommsState_AttitudeOffset(a4)									;Offset of mutable communication attitude or rapport.
	bsr.s	Comms_RunAction
	cmp.w	#$0006,InterfaceState_MenuOffset(a5)
	bcs.s	HandleMenuSelection_FinalizeAction
	cmp.b	#$06,$0001(a4)
	bcs.s	HandleMenuSelection_Return
	bsr		Advance_CommsWaitIndicatorAndDraw
HandleMenuSelection_FinalizeAction:		; Memory Address ($34FE) and binary offset [$317A]
	move.b	#$14,$0004(a4)
	move.b	CommsState_CurrentActionOffset(a4),CommsState_PreviousActionOffset(a4)	;Offset of the communication action currently being performed.
	subq.b	#$01,CommsState_PatienceOffset(a4)									;Offset of communication patience or remaining engagement.
HandleMenuSelection_Return:		; Memory Address ($350E) and binary offset [$318A]
	rts		

Comms_RunAction:		; Memory Address ($3510) and binary offset [$318C]
	; Stores and dispatches one communication action.
	move.b	d1,CommsState_CurrentActionOffset(a4)								;Offset of the communication action currently being performed.
	add.w	d1,d1
	lea		Comms_Action_Recruit.l,a0
	add.w	Comms_ActionHandlerOffsets(pc,d1.w),a0
	bsr		RandomGen_BytewithOffset
	jmp		(a0)

Comms_ActionHandlerOffsets:		; Memory Address ($3526) and binary offset [$31A2]
	; Ordered handlers for communication action identifiers $00-$1A.
	dc.w	Comms_Action_Recruit-Comms_Action_Recruit	;0000
	dc.w	Comms_Action_Identify-Comms_Action_Recruit	;000E
	dc.w	Comms_Action_Inquiry-Comms_Action_Recruit	;0016
	dc.w	Comms_Action_Whereabouts-Comms_Action_Recruit	;001E
	dc.w	Comms_Action_Trading-Comms_Action_Recruit	;002A
	dc.w	Comms_Action_Smalltalk-Comms_Action_Recruit	;0032
	dc.w	Comms_Action_Yes-Comms_Action_Recruit	;003A
	dc.w	Comms_Action_No-Comms_Action_Recruit	;00A8
	dc.w	Comms_Action_Bribe-Comms_Action_Recruit	;00E2
	dc.w	Comms_Action_Threat-Comms_Action_Recruit	;00EE
	dc.w	Comms_Action_WhoGoes-Comms_Action_Recruit	;0194
	dc.w	Comms_Action_ThyTrade-Comms_Action_Recruit	;01A0
	dc.w	Comms_Action_NameSelf-Comms_Action_Recruit	;01C2
	dc.w	Comms_Action_RevealSelf-Comms_Action_Recruit	;01E8
	dc.w	Comms_Action_FolkLore-Comms_Action_Recruit	;0216
	dc.w	Comms_Action_MagicItems-Comms_Action_Recruit	;0222
	dc.w	Comms_Action_Objects-Comms_Action_Recruit	;022E
	dc.w	Comms_Action_Persons-Comms_Action_Recruit	;023A
	dc.w	Comms_Action_Offer-Comms_Action_Recruit	;02D0
	dc.w	Comms_Action_Purchase-Comms_Action_Recruit	;0348
	dc.w	Comms_Action_Exchange-Comms_Action_Recruit	;035A
	dc.w	Comms_Action_Sell-Comms_Action_Recruit	;0318
	dc.w	Comms_Action_Praise-Comms_Action_Recruit	;03BC
	dc.w	Comms_Action_Curse-Comms_Action_Recruit	;03C8
	dc.w	Comms_Action_Boast-Comms_Action_Recruit	;04B2
	dc.w	Comms_Action_Retort-Comms_Action_Recruit	;04F6
	dc.w	Comms_Action_None-Comms_Action_Recruit	;000C

Comms_Action_Recruit:		; Memory Address ($355C) and binary offset [$31D8]
	; Communicates the Recruit request.
	lea		Msg_Recruit.l,a6
	jmp		WriteMessage.l

Comms_Action_None:		; Memory Address ($3568) and binary offset [$31E4]
	; No-operation handler used by the final communication action slot.
	rts		

Comms_Action_Identify:		; Memory Address ($356A) and binary offset [$31E6]
	; Opens the Identify communication submenu.
	addq.w	#$02,$0044(a5)
	bra		Draw_BlankCommandIconsAndMenu

Comms_Action_Inquiry:		; Memory Address ($3572) and binary offset [$31EE]
	; Opens the Inquiry communication submenu.
	addq.w	#$03,$0044(a5)
	bra		Draw_BlankCommandIconsAndMenu

Comms_Action_Whereabouts:		; Memory Address ($357A) and binary offset [$31F6]
	; Communicates the Whereabouts question.
	lea		Msg_Whereabouts.l,a6
	jmp		WriteMessage.l

Comms_Action_Trading:		; Memory Address ($3586) and binary offset [$3202]
	; Opens the Trading communication submenu.
	addq.w	#$03,$0044(a5)
	bra		Draw_BlankCommandIconsAndMenu

Comms_Action_Smalltalk:		; Memory Address ($358E) and binary offset [$320A]
	; Opens the Smalltalk communication submenu.
	addq.w	#$04,$0044(a5)
	bra		Draw_BlankCommandIconsAndMenu

Comms_Action_Yes:		; Memory Address ($3596) and binary offset [$3212]
	; Communicates Yes and completes an accepted object or coinage transfer when
	; one is pending.
	move.b	$0008(a4),d2
	subq.b	#CommsTradeMode_Exchange,d2											;Exchange communication mode.
	bcs.s	Trade_LoadWrapupMessage
	bne.s	ActionYes_CompleteSaleForGold
	cmp.b	#CommsAction_Offer,CommsState_PreviousActionOffset(a4)				;Communication action selected by Offer.
	bne.s	Trade_LoadWrapupMessage
	move.w	$002E(a5),d0
	cmp.b	$000A(a4),d0
	bne.s	Comms_FinishTradeExchange
	move.b	$0035(a5),d0
	cmpi.b	#$10,d0
	bcs.s	Trade_LoadWrapupMessage
	bsr		Comms_GetMonsterTradeObject
	move.b	$002F(a5),$0C(a0,d1.w)
	move.b	d0,$002F(a5)
	move.w	#$0001,$002C(a5)
ActionYes_SetBoastAndFinishTrade:		; Memory Address ($35D0) and binary offset [$324C]
	move.b	#CommsAction_Boast,CommsState_CurrentActionOffset(a4)				;Communication action selected by Boast.
	bsr.s	Comms_FinishTradeExchange
	bra		Refresh_HeldItemDisplay

ActionYes_CompleteSaleForGold:		; Memory Address ($35DC) and binary offset [$3258]
	move.b	$000A(a4),d0
	cmp.b	$002F(a5),d0
	bne.s	Comms_FinishTradeExchange
	and.b	#$7F,$0009(a4)
	move.b	$0009(a4),$002D(a5)
	move.w	#$0001,$002E(a5)
	bra.s	ActionYes_SetBoastAndFinishTrade

Comms_FinishTradeExchange:		; Memory Address ($35FA) and binary offset [$3276]
	; Clears trading mode, selects the completion message, reduces attitude, and
	; prints the NPC response.
	clr.b	$0008(a4)
Trade_LoadWrapupMessage:		; Memory Address ($35FE) and binary offset [$327A]
	move.w	#$45FF,d0
	bra.s	Decrease_CommsAttitudeAndPrintMessage

Comms_Action_No:		; Memory Address ($3604) and binary offset [$3280]
	; Communicates No and cancels or refuses the active trading mode.
	move.w	#$3DFF,d0
	move.b	$0008(a4),d1
	beq.s	Decrease_CommsAttitudeAndPrintMessage
	add.b	#CommsAction_Offer,d1												;Communication action selected by Offer.
	move.b	d1,$0001(a4)
	cmpi.b	#CommsAction_Sell,d1												;Communication action selected by Sell.
	bne.s	Decrease_CommsAttitudeAndPrintMessage
	subq.b	#$04,CommsState_AttitudeOffset(a4)									;Offset of mutable communication attitude or rapport.
	bpl.s	Decrease_CommsAttitudeAndPrintMessage
	clr.b	$0006(a4)
Decrease_CommsAttitudeAndPrintMessage:		; Memory Address ($3626) and binary offset [$32A2]
	; Decrements the NPC attitude with a zero clamp, stages the selected response
	; text, and prints the NPC message.
	subq.b	#$01,CommsState_AttitudeOffset(a4)									;Offset of mutable communication attitude or rapport.
	bpl.s	Comms_PrintBufferedNumericMessage
	clr.b	$0006(a4)
Comms_PrintBufferedNumericMessage:		; Memory Address ($3630) and binary offset [$32AC]
	lea		NumericMessageScratchBuffer.l,a6
	move.w	d0,(a6)
	jmp		Print_npc_message.l

Comms_Action_Bribe:		; Memory Address ($363E) and binary offset [$32BA]
	; Communicates the Bribe question.
	lea		Msg_Bribe.l,a6
	jmp		Print_npc_message.l

Comms_Action_Threat:		; Memory Address ($364A) and binary offset [$32C6]
	; Builds a randomized threat and reduces attitude.
	lea		Comms_MessageBuffer.l,a6
	and.w	#$0003,d0
	lea		Comms_ThreatOpeningFragments.l,a3
	bsr		Comms_CopyThreatFragment
	move.b	CommsState_AttitudeOffset(a4),d0									;Offset of mutable communication attitude or rapport.
	subq.b	#$03,CommsState_AttitudeOffset(a4)									;Offset of mutable communication attitude or rapport.
	bpl.s	Threat_CheckOriginalAttitudeLevel
	clr.b	$0006(a4)
Threat_CheckOriginalAttitudeLevel:		; Memory Address ($366C) and binary offset [$32E8]
	cmpi.b	#$0A,d0
	bcs.s	Threat_AppendConsequenceFragment
Threat_SelectFragmentBySpecialFlag:		; Memory Address ($3672) and binary offset [$32EE]
	move.b	$0002(a4),d0
	bpl.s	Threat_ChooseAddresseeTitleWord
	and.w	#$000F,d0
	move.b	d0,(a6)+
	bra.s	Threat_TerminateAndPrint

Threat_ChooseAddresseeTitleWord:		; Memory Address ($3680) and binary offset [$32FC]
	move.b	#$99,(a6)+
	move.b	#$C3,d1
	btst	#$06,d0
	beq.s	Threat_AppendChosenTitleWord
	move.b	#$9E,d1
	and.w	#$0003,d0
	beq.s	Threat_AppendChosenTitleWord
	add.b	#$5B,d0
	move.b	d0,d1
Threat_AppendChosenTitleWord:		; Memory Address ($369E) and binary offset [$331A]
	move.b	d1,(a6)+
	bra.s	Threat_TerminateAndPrint

Threat_AppendConsequenceFragment:		; Memory Address ($36A2) and binary offset [$331E]
	move.b	#$62,(a6)+
	bsr		RandomGen_BytewithOffset
	and.w	#$0003,d0
	lea		Comms_ThreatConsequenceFragments.l,a3
	bsr.s	Comms_CopyThreatFragment
	cmp.b	#$06,$0006(a4)
	bcc.s	Threat_SelectFragmentBySpecialFlag
	move.b	#$1A,(a6)+
	bsr		RandomGen_BytewithOffset
	and.w	#$0007,d0
	add.b	#$B6,d0
	move.b	d0,(a6)+
Threat_TerminateAndPrint:		; Memory Address ($36D0) and binary offset [$334C]
	move.b	#$FF,(a6)
	lea		Comms_MessageBuffer.l,a6
	jmp		Print_npc_message.l

Comms_CopyThreatFragment:		; Memory Address ($36E0) and binary offset [$335C]
	; Copies one length-prefixed threat fragment into the communication message
	; buffer.
	jsr		Proceed_in_stringtable.l
	subq.w	#$01,d5
CopyThreatFragment_ByteLoop:		; Memory Address ($36E8) and binary offset [$3364]
	move.b	(a3)+,(a6)+
	dbra	d5,CopyThreatFragment_ByteLoop
	rts		

Comms_Action_WhoGoes:		; Memory Address ($36F0) and binary offset [$336C]
	; Communicates the Who Goes identity question.
	lea		Msg_WhoGoes.l,a6
	jmp		Print_npc_message.l

Comms_Action_ThyTrade:		; Memory Address ($36FC) and binary offset [$3378]
	; Communicates the Thy Trade profession question.
	lea		Msg_ThyTrade.l,a6
	jmp		WriteMessage.l

Msg_ThyTrade:
	; Question communicated by the Thy Trade button.
	dc.b	'WHAT BE THY BUSINESS?'
	dc.b	$FF	;FF

Comms_Action_NameSelf:		; Memory Address ($371E) and binary offset [$339A]
	; Builds a message revealing the speaker's name and title.
	lea		Msg_NameSelfTemplate.l,a6
	move.b	$0003(a4),d1
	or.b	#$80,$0003(a4)
	and.w	#$000F,d1
	move.b	d1,$0003(a6)
	add.w	#$0064,d1
	move.b	d1,$0004(a6)
	jmp		Print_npc_message.l

Comms_Action_RevealSelf:		; Memory Address ($3744) and binary offset [$33C0]
	; Builds a message revealing the speaker's profession.
	lea		Msg_RevealSelfTemplate.l,a6
	move.b	$0003(a4),d0
	or.b	#$40,$0003(a4)
	and.w	#$000F,d0
	move.b	#$9E,$0006(a6)
	and.w	#$0003,d0
	beq.s	RevealSelf_PrintMessage
	add.w	#$005B,d0
	move.b	d0,$0006(a6)
RevealSelf_PrintMessage:		; Memory Address ($376C) and binary offset [$33E8]
	jmp		Print_npc_message.l

Comms_Action_FolkLore:		; Memory Address ($3772) and binary offset [$33EE]
	; Communicates the Folk Lore inquiry.
	lea		Msg_FolkLore.l,a6
	jmp		WriteMessage.l

Comms_Action_MagicItems:		; Memory Address ($377E) and binary offset [$33FA]
	; Communicates the Magic Items inquiry.
	lea		Msg_MagicItems.l,a6
	jmp		WriteMessage.l

Comms_Action_Objects:		; Memory Address ($378A) and binary offset [$3406]
	; Communicates the Objects inquiry.
	lea		Msg_Objects.l,a6
	jmp		WriteMessage.l

Comms_Action_Persons:		; Memory Address ($3796) and binary offset [$3412]
	; Communicates the Persons inquiry.
	lea		Msg_Persons.l,a6
	jmp		WriteMessage.l

Msg_FolkLore:
	; Question communicated by the Folk Lore button.
	dc.b	'HAST THOU HEARD ANY LEGENDS?'
	dc.b	$FF	;FF
Msg_MagicItems:
	; Question communicated by the Magic Items button.
	dc.b	'KNOWEST THOU OF ANY ENCHANTED ITEMS?'
	dc.b	$FF	;FF
Msg_Objects:
	; Question communicated by the Objects button.
	dc.b	'KNOWEST THOU OF ANY WEAPONS OF NOTE?'
	dc.b	$FF	;FF
Msg_Persons:
	; Question communicated by the Persons button.
	dc.b	'HAST HEARD OF ANY POWERFUL BEINGS?'
	dc.b	$FF	;FF

Comms_Action_Offer:		; Memory Address ($382C) and binary offset [$34A8]
	; Builds the Offer message from held coinage, a held object or the empty-hand
	; template.
	move.w	HeldItem_ObjectCodeOffset(a5),d0									;Offset of the currently held object code in the interface state.
	move.b	d0,$000A(a4)
	bne.s	TradeItem_CheckIfCoinage
	clr.b	$0008(a4)
	moveq	#$2E,d0
	bra.s	TradeMessage_PrintEmptyHandOffer

TradeItem_CheckIfCoinage:		; Memory Address ($383E) and binary offset [$34BA]
	cmpi.w	#Object_Coinage,d0													;Coinage object code.
	bne.s	Offer_PromotePurchaseToExchange
	move.w	HeldItem_StateOffset(a5),d0											;Offset of the combined held-item quantity and object-code state.
	cmp.b	#$02,$0008(a4)
	bne		Comms_PrintGoldOffer
	move.b	#$01,$0008(a4)
	bra		Comms_PrintGoldOffer

Offer_PromotePurchaseToExchange:		; Memory Address ($385C) and binary offset [$34D8]
	cmp.b	#$01,$0008(a4)
	bne.s	Offer_PrepareHeldItemMessage
	move.b	#$02,$0008(a4)
Offer_PrepareHeldItemMessage:		; Memory Address ($386A) and binary offset [$34E6]
	lea		Msg_OfferHeldItemTemplate.l,a6
	moveq	#$05,d2
	bra.s	TradeMessage_AppendObjectName

Comms_Action_Sell:		; Memory Address ($3874) and binary offset [$34F0]
	; Builds the Sell message and records the held object for the proposed trade.
	move.b	#$03,$0008(a4)
	clr.b	$0009(a4)
	move.w	HeldItem_ObjectCodeOffset(a5),d0									;Offset of the currently held object code in the interface state.
	beq.s	Sell_SetEmptyHandWordCode
	move.b	d0,$000A(a4)
	lea		Msg_SellHeldItemTemplate.l,a6
	moveq	#$05,d2
	bra.s	TradeMessage_AppendObjectName

Sell_SetEmptyHandWordCode:		; Memory Address ($3892) and binary offset [$350E]
	moveq	#$57,d0
TradeMessage_PrintEmptyHandOffer:		; Memory Address ($3894) and binary offset [$3510]
	lea		Msg_OfferOrSellTemplate.l,a6
	move.b	d0,$0005(a6)
	jmp		Print_npc_message.l

Comms_Action_Purchase:		; Memory Address ($38A4) and binary offset [$3520]
	; Communicates the Purchase question and enters purchase mode.
	lea		Msg_Purchase.l,a6
	move.b	#$01,$0008(a4)
	jmp		Print_npc_message.l

Comms_Action_Exchange:		; Memory Address ($38B6) and binary offset [$3532]
	; Builds the Exchange question and enters exchange mode.
	move.b	#$02,$0008(a4)
	move.w	HeldItem_ObjectCodeOffset(a5),d0									;Offset of the currently held object code in the interface state.
	move.b	d0,$000A(a4)
	bne.s	TradeMessage_PrepareHeldItemTemplate
	lea		Msg_Exchange.l,a6
	jmp		Print_npc_message.l

TradeMessage_PrepareHeldItemTemplate:		; Memory Address ($38D2) and binary offset [$354E]
	lea		Msg_ExchangeHeldItemTemplate.l,a6
	moveq	#$0B,d2
TradeMessage_AppendObjectName:		; Memory Address ($38DA) and binary offset [$3556]
	bsr.s	Comms_AppendObjectName
TradeMessage_AppendSuffixAndPrint:		; Memory Address ($38DC) and binary offset [$3558]
	move.b	#$FA,$00(a6,d2.w)
	move.b	#$3F,$01(a6,d2.w)
	move.b	#$FF,$02(a6,d2.w)
	jmp		Print_npc_message.l

Comms_AppendObjectName:		; Memory Address ($38F4) and binary offset [$3570]
	; Appends an object's one- or two-part display name to a packed communication
	; message.
	lea		Object_Definition_Table+$02.l,a0
	add.w	d0,d0
	add.w	d0,d0
	add.w	d0,a0
	move.b	(a0)+,$00(a6,d2.w)
	addq.w	#$01,d2
	move.b	(a0),d0
	bmi.s	AppendObjectName_Exit
	move.b	#$FE,$00(a6,d2.w)
	move.b	d0,$01(a6,d2.w)
	addq.w	#$02,d2
AppendObjectName_Exit:		; Memory Address ($3916) and binary offset [$3592]
	rts		

Comms_Action_Praise:		; Memory Address ($3918) and binary offset [$3594]
	; Builds a randomized compliment and raises attitude.
	addq.b	#$01,CommsState_AttitudeOffset(a4)									;Offset of mutable communication attitude or rapport.
	lea		Comms_PraiseWordRanges.l,a0
	bra.s	PraiseCurse_BuildSmalltalkWords

Comms_Action_Curse:		; Memory Address ($3924) and binary offset [$35A0]
	; Builds a randomized insult and reduces attitude.
	subq.b	#$04,CommsState_AttitudeOffset(a4)									;Offset of mutable communication attitude or rapport.
	bpl.s	Curse_LoadWordRanges
	clr.b	$0006(a4)
Curse_LoadWordRanges:		; Memory Address ($392E) and binary offset [$35AA]
	lea		Comms_CurseWordRanges.l,a0
PraiseCurse_BuildSmalltalkWords:		; Memory Address ($3934) and binary offset [$35B0]
	bsr.s	Comms_BuildSmalltalk
	moveq	#$02,d4
Smalltalk_OptionalWordLoop:		; Memory Address ($3938) and binary offset [$35B4]
	asr.w	#$01,d7
	bcc.s	Smalltalk_AdvanceWordRange
	bsr.s	Comms_AppendSmalltalkWord
Smalltalk_AdvanceWordRange:		; Memory Address ($393E) and binary offset [$35BA]
	addq.w	#$02,a0
	dbra	d4,Smalltalk_OptionalWordLoop
	move.b	#$FF,$00(a6,d2.w)
	jmp		Print_npc_message.l

Comms_AppendSmalltalkWord:		; Memory Address ($3950) and binary offset [$35CC]
	; Selects and appends one optional word from a praise or curse word range.
	bsr		RandomGen_BytewithOffset
	and.w	#$0007,d0
	tst.w	d7
	bpl.s	Smalltalk_AppendRangeWord
	cmp.b	(a0),d0
	bcs.s	Smalltalk_ClearQualifierFlag
	move.b	#$FA,$00(a6,d2.w)
	move.b	#$4E,$01(a6,d2.w)
	addq.w	#$02,d2
Smalltalk_ClearQualifierFlag:		; Memory Address ($396E) and binary offset [$35EA]
	and.w	#$00FF,d7
Smalltalk_AppendRangeWord:		; Memory Address ($3972) and binary offset [$35EE]
	add.b	$0001(a0),d0
	move.b	d0,$00(a6,d2.w)
	addq.w	#$01,d2
	rts		

Comms_BuildSmalltalk:		; Memory Address ($397E) and binary offset [$35FA]
	; Builds a randomized praise or curse from a sentence pattern and three word
	; ranges.
	and.w	#$00FE,d0
	moveq	#$00,d7
Smalltalk_FindPatternBandLoop:		; Memory Address ($3984) and binary offset [$3600]
	cmp.b	Comms_SmalltalkPatternBands(pc,d7.w),d0
	bcs.s	Smalltalk_SelectPattern
	addq.w	#$02,d7
	bra.s	Smalltalk_FindPatternBandLoop

Smalltalk_SelectPattern:		; Memory Address ($398E) and binary offset [$360A]
	move.b	Comms_SmalltalkPatternIndexTable(pc,d7.w),d7
	lea		Comms_MessageBuffer.l,a6
	move.b	#$1A,(a6)
	moveq	#$01,d2
	lsr.w	#$01,d7
	bcc.s	Smalltalk_CheckTrailingModifier
	cmp.b	#$03,$0001(a4)
	bne.s	Smalltalk_RollSubjectWordIndex
	bsr		RandomGen_SixSidedRoll
	addq.w	#$02,d0
	bra.s	Smalltalk_StoreSubjectWord

Smalltalk_RollSubjectWordIndex:		; Memory Address ($39B2) and binary offset [$362E]
	bsr		RandomGen_BytewithOffset
	and.w	#$0007,d0
Smalltalk_StoreSubjectWord:		; Memory Address ($39BA) and binary offset [$3636]
	move.w	#$0084,d1
	add.w	d0,d1
	move.b	d1,$0001(a6)
	moveq	#$02,d2
	cmpi.w	#$0007,d0
	beq.s	Smalltalk_CheckTrailingModifier
	move.b	#$FA,$0002(a6)
	move.b	#$53,$0003(a6)
	moveq	#$04,d2
Smalltalk_CheckTrailingModifier:		; Memory Address ($39DA) and binary offset [$3656]
	ror.w	#$01,d7
	bpl.s	Smalltalk_Return
	cmpi.w	#$0005,d0
	bcc.s	Smalltalk_AppendTrailingWord
	move.b	#$8C,$00(a6,d2.w)
	addq.w	#$01,d2
Smalltalk_AppendTrailingWord:		; Memory Address ($39EC) and binary offset [$3668]
	move.b	#$8D,$00(a6,d2.w)
	addq.w	#$01,d2
Smalltalk_Return:		; Memory Address ($39F4) and binary offset [$3670]
	rts		

Comms_SmalltalkPatternBands:		; Memory Address ($39F6) and binary offset [$3672]
	; Upper bounds and bit masks selecting randomized smalltalk sentence patterns.
	dc.b	$0C	;0C
Comms_SmalltalkPatternIndexTable:		; Memory Address ($39F7) and binary offset [$3673]
	; Maps the selected smalltalk probability band to the sentence-pattern index
	; used by communications.
	dc.b	$10	;10
	dc.b	$32	;32
	dc.b	$1C	;1C
	dc.b	$5A	;5A
	dc.b	$09	;09
	dc.b	$80	;80
	dc.b	$0D	;0D
	dc.b	$AF	;AF
	dc.b	$13	;13
	dc.b	$FF	;FF
	dc.b	$1B	;1B
Comms_PraiseWordRanges:		; Memory Address ($3A02) and binary offset [$367E]
	; Three threshold and starting-word pairs for praise adverbs, adjectives and
	; nouns.
	dc.w	$048E	;048E
	dc.w	$0796	;0796
	dc.w	$079E	;079E
Comms_CurseWordRanges:		; Memory Address ($3A08) and binary offset [$3684]
	; Three threshold and starting-word pairs for curse adverbs, adjectives and
	; nouns.
	dc.w	$03A6	;03A6
	dc.w	$07AE	;07AE
	dc.w	$07B6	;07B6

Comms_Action_Boast:		; Memory Address ($3A0E) and binary offset [$368A]
	; Builds a boast from a randomized personal attribute and superlative.
	lea		Msg_BoastTemplate.l,a6
	and.w	#$0007,d0
	add.w	#$0074,d0
	move.b	d0,$0002(a6)
	bsr		RandomGen_BytewithOffset
	and.w	#$0007,d0
	add.w	#$007C,d0
	move.b	d0,$0004(a6)
	jmp		Print_npc_message.l

Comms_ActionReplyIndexes:		; Memory Address ($3A36) and binary offset [$36B2]
	; Maps each preceding communication action to its contextual fixed-reply entry.
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$05	;05
	dc.b	$06	;06
	dc.b	$07	;07
	dc.b	$08	;08
	dc.b	$09	;09
	dc.b	$0A	;0A
	dc.b	$0B	;0B
	dc.b	$0C	;0C
	dc.b	$0D	;0D
	dc.b	$0E	;0E
	dc.b	$0F	;0F
	dc.b	$10	;10
	dc.b	$11	;11
	dc.b	$12	;12
	dc.b	$13	;13
	dc.b	$14	;14
	dc.b	$15	;15
	dc.b	$16	;16
	dc.b	$00	;00

Comms_Action_Retort:		; Memory Address ($3A52) and binary offset [$36CE]
	; Selects the contextual fixed reply or a randomized agreement fallback.
	moveq	#$00,d0
	move.b	$0000(a4),d0
	move.b	Comms_ActionReplyIndexes(pc,d0.w),d0
	add.w	d0,d0
	lea		Msg_Reply_Recruit.l,a6
	add.w	Msg_ActionReplyOffsets(pc,d0.w),a6
	tst.b	(a6)
	bpl.s	Comms_PrintActionReply
	lea		Msg_Agreement_00.l,a6
	bsr		RandomGen_BytewithOffset
	and.w	#$0006,d0
	add.w	Msg_AgreementOffsets(pc,d0.w),a6
Comms_PrintActionReply:
	; Prints the fixed or fallback reply selected for the preceding communication
	; action.
	jmp		WriteMessage.l

Msg_AgreementOffsets:
	; Offsets of the four randomized agreement fallback messages.
	dc.w	Msg_Agreement_00-Msg_Agreement_00	;0000
	dc.w	Msg_Agreement_01-Msg_Agreement_00	;0015
	dc.w	Msg_Agreement_02-Msg_Agreement_00	;0028
	dc.w	Msg_Agreement_03-Msg_Agreement_00	;003F
Msg_ActionReplyOffsets:
	; Offsets of contextual fixed replies indexed by Comms_ActionReplyIndexes.
	dc.w	Msg_Reply_Recruit-Msg_Reply_Recruit	;0000
	dc.w	Msg_Reply_Whereabouts-Msg_Reply_Recruit	;0022
	dc.w	Msg_Reply_Yes_UseAgreement-Msg_Reply_Recruit	;003F
	dc.w	Msg_Reply_No-Msg_Reply_Recruit	;0040
	dc.w	Msg_Reply_Bribe-Msg_Reply_Recruit	;004B
	dc.w	Msg_Reply_Threat-Msg_Reply_Recruit	;005D
	dc.w	Msg_Reply_WhoGoes-Msg_Reply_Recruit	;0084
	dc.w	Msg_Reply_ThyTrade-Msg_Reply_Recruit	;009D
	dc.w	Msg_Reply_NameSelf_UseAgreement-Msg_Reply_Recruit	;00BB
	dc.w	Msg_Reply_RevealSelf_UseAgreement-Msg_Reply_Recruit	;00BC
	dc.w	Msg_Reply_FolkLore-Msg_Reply_Recruit	;00BD
	dc.w	Msg_Reply_MagicItems-Msg_Reply_Recruit	;00DB
	dc.w	Msg_Reply_Objects-Msg_Reply_Recruit	;00FD
	dc.w	Msg_Reply_Persons-Msg_Reply_Recruit	;011A
	dc.w	Msg_Reply_Offer-Msg_Reply_Recruit	;013D
	dc.w	Msg_Reply_Purchase-Msg_Reply_Recruit	;014D
	dc.w	Msg_Reply_Exchange-Msg_Reply_Recruit	;016C
	dc.w	Msg_Reply_Sell-Msg_Reply_Recruit	;0187
	dc.w	Msg_Reply_Praise_UseAgreement-Msg_Reply_Recruit	;019C
	dc.w	Msg_Reply_Curse-Msg_Reply_Recruit	;019D
	dc.w	Msg_Reply_Boast-Msg_Reply_Recruit	;01C4
	dc.w	Msg_Reply_Retort_UseAgreement-Msg_Reply_Recruit	;01DE
	dc.w	Msg_Reply_Greeting-Msg_Reply_Recruit	;01DF
Msg_Agreement_00:
	; Randomized agreement fallback: THAT'S VERY POSSIBLE.
	dc.b	'THAT''S VERY POSSIBLE'
	dc.b	$FF	;FF
Msg_Agreement_01:
	; Randomized agreement fallback: I CANNOT BUT AGREE.
	dc.b	'I CANNOT BUT AGREE'
	dc.b	$FF	;FF
Msg_Agreement_02:
	; Randomized agreement fallback: THAT SEEMS VERY LIKELY.
	dc.b	'THAT SEEMS VERY LIKELY'
	dc.b	$FF	;FF
Msg_Agreement_03:
	; Randomized agreement fallback: I'M NOT ABOUT TO ARGUE WITH THEE.
	dc.b	'I''M NOT ABOUT TO ARGUE WITH THEE'
	dc.b	$FF	;FF
Msg_Reply_Recruit:
	; Contextual reply to Recruit.
	dc.b	'I DON''T KEEP COMPANY WITH MAGGOTS'
	dc.b	$FF	;FF
Msg_Reply_Whereabouts:
	; Contextual reply to Whereabouts.
	dc.b	'LOOK TO THE TOWERS MY FRIEND'
	dc.b	$FF	;FF
Msg_Reply_Yes_UseAgreement:
	; $FF sentinel selecting a randomized agreement after Yes.
	dc.b	$FF	;FF
Msg_Reply_No:
	; Contextual reply to No.
	dc.b	'INDEED NOT'
	dc.b	$FF	;FF
Msg_Reply_Bribe:
	; Contextual reply to Bribe.
	dc.b	'MAKE ME THY OFFER'
	dc.b	$FF	;FF
Msg_Reply_Threat:
	; Contextual reply to Threat.
	dc.b	'PICK ON SOMEONE THY OWN SIZE THOU SLUG'
	dc.b	$FF	;FF
Msg_Reply_WhoGoes:
	; Contextual reply to Who Goes.
	dc.b	'I AM THY WORST NIGHTMARE'
	dc.b	$FF	;FF
Msg_Reply_ThyTrade:
	; Contextual reply to Thy Trade.
	dc.b	'NONE OF THY BUSINESS I''M SURE'
	dc.b	$FF	;FF
Msg_Reply_NameSelf_UseAgreement:
	; $FF sentinel selecting a randomized agreement after Name Self.
	dc.b	$FF	;FF
Msg_Reply_RevealSelf_UseAgreement:
	; $FF sentinel selecting a randomized agreement after Reveal Self.
	dc.b	$FF	;FF
Msg_Reply_FolkLore:
	; Contextual reply to Folk Lore.
	dc.b	'NEWS IS SCARCE IN THESE PARTS'
	dc.b	$FF	;FF
Msg_Reply_MagicItems:
	; Contextual reply to Magic Items.
	dc.b	'I HEAR CRYSTALS ARE WORTH SEEKING'
	dc.b	$FF	;FF
Msg_Reply_Objects:
	; Contextual reply to Objects.
	dc.b	'WHO CAN SAY WHAT IS OF NOTE?'
	dc.b	$FF	;FF
Msg_Reply_Persons:
	; Contextual reply to Persons.
	dc.b	'I HEAR ZENDIK IS NOT WHOLLY A WORM'
	dc.b	$FF	;FF
Msg_Reply_Offer:
	; Contextual reply to Offer.
	dc.b	'GIVE ME A BREAK'
	dc.b	$FF	;FF
Msg_Reply_Purchase:
	; Contextual reply to Purchase.
	dc.b	'THY COINAGE IS WORTHLESS TO ME'
	dc.b	$FF	;FF
Msg_Reply_Exchange:
	; Contextual reply to Exchange.
	dc.b	'I DO NOT TRADE IN TRINKETS'
	dc.b	$FF	;FF
Msg_Reply_Sell:
	; Contextual reply to Sell.
	dc.b	'I NEED NOT THY TRASH'
	dc.b	$FF	;FF
Msg_Reply_Praise_UseAgreement:
	; $FF sentinel selecting a randomized agreement after Praise.
	dc.b	$FF	;FF
Msg_Reply_Curse:
	; Contextual reply to Curse.
	dc.b	'MAYBE TRUE BUT THOU SHOULD BE SO LUCKY'
	dc.b	$FF	;FF
Msg_Reply_Boast:
	; Contextual reply to Boast.
	dc.b	'I TRUST THIS PLEASES THEE'
	dc.b	$FF	;FF
Msg_Reply_Retort_UseAgreement:
	; $FF sentinel selecting a randomized agreement after Retort.
	dc.b	$FF	;FF
Msg_Reply_Greeting:
	; Contextual dismissive reply to the initial Greeting.
	dc.b	'WHY DOST BURDEN ME WITH THY COMPANY?'
	dc.b	$FF	;FF

	lea		Comms_MessageBuffer.l,a6
	move.b	#$33,(a6)
	move.b	#$5F,$0001(a6)
	move.b	#$FE,$0002(a6)
	moveq	#$03,d2
	move.w	$0006(a5),d1
	asl.w	#$04,d1
	lea		Character_Pockets_DataTable.l,a0
	move.b	$00(a0,d1.w),d1
	bne.s	PocketItemMessage_AppendObjectName
	move.b	#$44,$00(a6,d2.w)
	addq.w	#$01,d2
	bra.s	PocketItemMessage_AppendWordAndPrint

PocketItemMessage_AppendObjectName:		; Memory Address ($3D52) and binary offset [$39CE]
	lea		Object_Definition_Table+$02.l,a0
	add.w	d1,d1
	add.w	d1,d1
	add.w	d1,a0
	move.b	(a0)+,$00(a6,d2.w)
	addq.w	#$01,d2
	move.b	(a0),d0
	bmi.s	PocketItemMessage_AppendWordAndPrint
	move.b	#$FE,$00(a6,d2.w)
	move.b	d0,$01(a6,d2.w)
	addq.w	#$02,d2
PocketItemMessage_AppendWordAndPrint:		; Memory Address ($3D74) and binary offset [$39F0]
	move.b	#$35,$00(a6,d2.w)
	bsr		RandomGen_BytewithOffset
	and.w	#$0007,d0
	add.w	#$007C,d0
	move.b	d0,$01(a6,d2.w)
	move.b	#$FF,$02(a6,d2.w)
	jsr		Print_npc_message.l
	move.w	#$0006,$0044(a5)
Comms_FinishAction_RedrawMenu:		; Memory Address ($3D9C) and binary offset [$3A18]
	move.w	#$0008,$0042(a5)
	bsr		Draw_CommsWaitIndicatorIcons
	bra		Draw_PartyCommandMenu

Msg_NameSelfTemplate:		; Memory Address ($3DAA) and binary offset [$3A26]
	; Packed-word template patched with the speaker's name and title.
	dc.w	$5F4B	;5F4B
	dc.w	$3500	;3500
	dc.w	$00FF	;00FF
	dc.w	$4BFA	;4BFA
	dc.w	$5329	;5329
	dc.w	$1C25	;1C25
	dc.w	$FA45	;FA45
	dc.w	$00FF	;00FF
Msg_BoastTemplate:		; Memory Address ($3DBA) and binary offset [$3A36]
	; Packed-word template patched with a personal attribute and superlative.
	dc.w	$335F	;335F
	dc.w	$0035	;0035
	dc.w	$00FF	;00FF
Comms_MessageBuffer:		; Memory Address ($3DC0) and binary offset [$3A3C]
	; Thirty-byte writable buffer used to assemble dynamic communication messages.
	ds.b	$1E
Comms_ThreatOpeningFragments:		; Memory Address ($3DDE) and binary offset [$3A5A]
	; Length-prefixed threat openings: BE ASIDE, DEPART, BEGONE and GO AWAY.
	dc.w	$02BE	;02BE
	dc.w	$BF01	;BF01
	dc.w	$3007	;3007
	dc.w	$29FB	;29FB
	dc.w	$31FA	;31FA
	dc.w	$4EFA	;4EFA
	dc.w	$4502	;4502
	dc.w	$3163	;3163
Comms_ThreatConsequenceFragments:		; Memory Address ($3DEE) and binary offset [$3A6A]
	; Length-prefixed threat consequences: SUFFER, DIE, BE SORRY and FIGHT.
	dc.b	$01	;01
	dc.b	$C0	;C0
	dc.b	$01	;01
	dc.b	$C1	;C1
	dc.b	$02	;02
	dc.b	$29	;29
	dc.b	$C2	;C2
	dc.b	$01	;01
	dc.b	$84	;84
Msg_Greeting:		; Memory Address ($3DF7) and binary offset [$3A73]
	; Packed-word initial GREETINGS message.
	dc.b	$49	;49
	dc.b	$FB	;FB
	dc.b	$4A	;4A
	dc.b	$FA	;FA
	dc.b	$53	;53
	dc.b	$FF	;FF
Msg_WhoGoes:		; Memory Address ($3DFD) and binary offset [$3A79]
	; Packed-word question communicated by the Who Goes button.
	dc.b	$18	;18
	dc.b	$8B	;8B
	dc.b	$1A	;1A
	dc.b	$FA	;FA
	dc.b	$3F	;3F
	dc.b	$FF	;FF
Msg_RevealSelfTemplate:		; Memory Address ($3E03) and binary offset [$3A7F]
	; Packed-word profession statement patched for Wizard, Adventurer, Cutpurse or
	; Warrior.
	dc.b	$CE	;CE
	dc.b	$8D	;8D
	dc.b	$FA	;FA
	dc.b	$4D	;4D
	dc.b	$8D	;8D
	dc.b	$99	;99
	dc.b	$00	;00
	dc.b	$FF	;FF
Msg_Exchange:		; Memory Address ($3E0B) and binary offset [$3A87]
	; Packed-word Exchange question used when no object is held.
	dc.b	$27	;27
	dc.b	$1A	;1A
	dc.b	$60	;60
	dc.b	$22	;22
	dc.b	$42	;42
	dc.b	$FA	;FA
	dc.b	$45	;45
	dc.b	$FA	;FA
	dc.b	$3F	;3F
	dc.b	$FF	;FF
Msg_ExchangeHeldItemTemplate:		; Memory Address ($3E15) and binary offset [$3A91]
	; Packed-word Exchange question patched with the held object name.
	dc.b	$18	;18
	dc.b	$FB	;FB
	dc.b	$FA	;FA
	dc.b	$41	;41
	dc.b	$FA	;FA
	dc.b	$54	;54
	dc.b	$19	;19
	dc.b	$61	;61
	dc.b	$22	;22
	dc.b	$5F	;5F
	dc.b	$FE	;FE
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
Msg_Bribe:		; Memory Address ($3E26) and binary offset [$3AA2]
	; Packed-word question communicated by the Bribe button.
	dc.b	$CC	;CC
	dc.b	$1A	;1A
	dc.b	$1D	;1D
	dc.b	$2F	;2F
	dc.b	$43	;43
	dc.b	$CD	;CD
	dc.b	$FA	;FA
	dc.b	$3F	;3F
	dc.b	$FF	;FF
Msg_Whereabouts:
	; Question communicated by the Whereabouts button.
	dc.b	'WHERE IS THIS OF WHICH THOU HAST SPOKEN?'
	dc.b	$FF	;FF
Msg_OfferOrSellTemplate:		; Memory Address ($3E58) and binary offset [$3AD4]
	; Packed-word template patched to ask about giving or selling an unspecified
	; object.
	dc.b	$2D	;2D
	dc.b	$5F	;5F
	dc.b	$FB	;FB
	dc.b	$FA	;FA
	dc.b	$45	;45
	dc.b	$00	;00
	dc.b	$25	;25
	dc.b	$FA	;FA
	dc.b	$45	;45
	dc.b	$2F	;2F
	dc.b	$FB	;FB
	dc.b	$CB	;CB
	dc.b	$FF	;FF
Msg_OfferHeldItemTemplate:		; Memory Address ($3E65) and binary offset [$3AE1]
	; Packed-word Offer question patched with the held object name.
	dc.b	$CC	;CC
	dc.b	$1A	;1A
	dc.b	$1D	;1D
	dc.b	$5F	;5F
	dc.b	$FE	;FE
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
Msg_SellHeldItemTemplate:		; Memory Address ($3E70) and binary offset [$3AEC]
	; Packed-word Sell question patched with the held object name.
	dc.b	$CC	;CC
	dc.b	$1A	;1A
	dc.b	$55	;55
	dc.b	$5F	;5F
	dc.b	$FE	;FE
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
Msg_Purchase:		; Memory Address ($3E7B) and binary offset [$3AF7]
	; Packed-word question communicated by the Purchase button.
	dc.b	$27	;27
	dc.b	$1A	;1A
	dc.b	$60	;60
	dc.b	$1C	;1C
	dc.b	$57	;57
	dc.b	$FA	;FA
	dc.b	$3F	;3F
	dc.b	$FF	;FF
Msg_Recruit:
	; Request communicated by the Recruit button.
	dc.b	'COME JOIN MY MERRY BAND'
	dc.b	$FF	;FF
	dc.b	$00	;00

PartyCommand_Call:		; Memory Address ($3E9C) and binary offset [$3B18]
	; Displays "THOU DOST CALL OUT" and, when the other player is active on the
	; same map, builds a direction-and-distance call notice for that player.
	lea		Notice_Call_Out.l,a6												;Selects the packed Call notice "THOU DOST CALL OUT".
	jsr		Print_timed_message.l
	move.b	#$FF,$0050(a5)
	lea		Player1_Data.l,a1
	btst	#$00,(a5)															;Uses the current-player selector bit to choose the other player's state record.
	bne.s	Call_ValidateOtherPlayerTarget
	lea		Player2_Data.l,a1
Call_ValidateOtherPlayerTarget:		; Memory Address ($3EC0) and binary offset [$3B3C]
	btst	#$06,$0018(a1)
	bne		Call_FinishNotice
	move.b	(a1),d0
	and.b	#$FE,d0
	bne		Call_FinishNotice
	move.w	$0058(a5),d0
	cmp.w	$0058(a1),d0														;Only builds the second-player proximity notice when both players have the same map index.
	bne		Call_FinishNotice
	lea		Comms_MessageBuffer.w,a6											;Short Absolute converted to symbol!
	move.b	#$CA,(a6)+
	move.b	#$C4,(a6)+
	move.l	$001C(a1),d1
	move.l	$001C(a5),d0
	bsr		Calculate_ManhattanDistance
	cmpi.w	#$0005,d2
	bcs.s	Call_AppendCallToThePhrase
	cmpi.w	#$0009,d2
	bcs.s	Call_AppendDistantWord
	move.b	#$8E,(a6)+
Call_AppendDistantWord:		; Memory Address ($3F08) and binary offset [$3B84]
	move.b	#$C5,(a6)+
Call_AppendCallToThePhrase:		; Memory Address ($3F0C) and binary offset [$3B88]
	move.b	#$16,(a6)+															;Appends the packed-word token for CALL to the dynamically generated other-player notice.
	move.b	#$FA,(a6)+
	move.b	#$53,(a6)+
	move.b	#$1C,(a6)+
	move.b	#$25,(a6)+
	moveq	#$00,d3
	move.w	d0,d2
	swap	d0
	cmp.w	d0,d2
	bcs.s	Call_SelectAxisComponent
	moveq	#$01,d3
	swap	d1
Call_SelectAxisComponent:		; Memory Address ($3F2E) and binary offset [$3BAA]
	swap	d1
	tst.w	d1
	bmi.s	Call_ResolveDirectionWord
	addq.b	#$02,d3
Call_ResolveDirectionWord:		; Memory Address ($3F36) and binary offset [$3BB2]
	add.w	$0020(a1),d3														;Rotates the relative direction by the other player's facing direction.
	and.w	#$0003,d3															;Wraps the facing-relative direction to one of four directions.
	add.w	#$00C6,d3															;Converts direction 0 through 3 into the corresponding packed direction-word token.
	move.b	d3,(a6)+
	move.b	#$FF,(a6)
	lea		Comms_MessageBuffer.w,a6											;Short Absolute converted to symbol!
	move.l	a5,-(sp)
	move.l	a1,a5
	jsr		Print_timed_message.l
	move.l	(sp)+,a5
Call_FinishNotice:		; Memory Address ($3F58) and binary offset [$3BD4]
	bra		Reset_PartyCommandStateAndRedrawMenu

PartyCommand_Dismiss:		; Memory Address ($3F5C) and binary offset [$3BD8]
	; Opens party-member selection for Dismiss or removes the selected member from
	; the active party; displays "<NAME> LEAVES THE PARTY" or "<NAME> IS UNABLE TO
	; DEPART".
	moveq	#$15,d7																;Selects packed action token $15, DISMISS, for prompts and result handling.
	bra.s	Interface_ProcessSelectedInventoryAction

PartyCommand_Wait:		; Memory Address ($3F60) and binary offset [$3BDC]
	; Opens party-member selection for Wait or removes and marks the selected
	; member as waiting; displays "<NAME> WAITS" or "<NAME> IS UNABLE TO DEPART".
	clr.b	$0050(a5)
	moveq	#$13,d7																;Selects packed action token $13, WAIT, for prompts and result handling.
Interface_ProcessSelectedInventoryAction:		; Memory Address ($3F66) and binary offset [$3BE2]
	; Maps the selected inventory entry, tests the destination cell, removes or
	; applies the object, and prints success or blocked notices.
	tst.b	$004E(a5)															;A clear target-selection flag opens the party-member selector; a set flag processes the chosen member.
	beq		Interface_OpenInventoryActionSelector
	bsr		Interface_MapSelectedAction
	move.w	d7,-(sp)
	move.b	d0,$004F(a5)
	move.l	$001C(a5),d7
	move.w	$0020(a5),d6
	bsr		Try_EnterMapCell
	bcc.s	Interface_FinalizeSelectedWorldAction								;Carry clear indicates that the selected party member can be placed at the party's current location.
	addq.w	#$02,sp
	lea		Notice_PartyCommand_UnableToDepart.l,a6								;Selects "<NAME> IS UNABLE TO DEPART" when the selected member cannot be placed outside the active party.
	move.b	$004F(a5),(a6)
	jsr		Print_timed_message.l
	bra		Reset_PartyCommandStateAndRedrawMenu

Interface_FinalizeSelectedWorldAction:		; Memory Address ($3F9C) and binary offset [$3C18]
	; Completes a valid selected-object world action, updates the champion record,
	; and displays the resulting notice.
	bset	#$07,$01(a6,d2.w)
	move.b	$004F(a5),d0
	bsr		Interface_RemoveSelectedInventoryObject
	lea		Notice_Dismiss_PartyMemberLeaves.l,a6
	move.w	(sp)+,d1
	cmpi.w	#$0015,d1															;Distinguishes Dismiss from Wait after the selected member has been removed from the active party.
	beq.s	FinalizeWorldAction_PatchNoticeChampion
	bsr		Find_FreeOwnershipSlot
	move.b	$004F(a5),d0
	bset	#$05,d0																;Marks a Wait target as waiting so View can select that party member later.
	move.b	d0,$18(a5,d1.w)
	lea		Notice_Wait_PartyMemberWaits.l,a6
FinalizeWorldAction_PatchNoticeChampion:		; Memory Address ($3FCE) and binary offset [$3C4A]
	move.b	$004F(a5),d0
	move.b	d0,(a6)																;Patches the first packed-word token of the Wait or Dismiss result with the selected party member's name.
	bsr		Load_ChampionStatRecord
	move.b	d7,$0017(a4)
	swap	d7
	move.b	d7,$0016(a4)
	move.b	$0059(a5),$001A(a4)
	move.b	$0021(a5),$0018(a4)
	move.b	CurrentTower+$01.l,$001F(a4)
	jsr		Print_timed_message.l
	bsr		Refresh_ModeDependentChampionDisplay
	bra		Reset_PartyCommandStateAndRedrawMenu

Interface_RemoveSelectedInventoryObject:		; Memory Address ($4004) and binary offset [$3C80]
	; Removes the selected inventory object, compacts the pocket flags, and
	; refreshes inventory state.
	bsr		Find_ChampionFormationSlot
	move.b	#$FF,$26(a5,d2.w)
	cmp.w	$0016(a5),d2
	bne.s	RemoveSelectedChampion_FindSlot
	move.w	#$FFFF,$0016(a5)
RemoveSelectedChampion_FindSlot:		; Memory Address ($401A) and binary offset [$3C96]
	bsr		Find_ChampionInPlayerSlots
	move.w	d1,d3
RemoveSelectedChampion_CompactSlotsLoop:		; Memory Address ($4020) and binary offset [$3C9C]
	move.b	$19(a5,d1.w),$18(a5,d1.w)
	addq.w	#$01,d1
	cmpi.w	#$0003,d1
	bcs.s	RemoveSelectedChampion_CompactSlotsLoop
	move.b	#$FF,$001B(a5)
	cmp.b	#$03,$0015(a5)
	bne.s	RemoveSelectedChampion_Return
	cmp.b	$000F(a5),d3
	bne.s	RemoveSelectedChampion_AdjustViewIndex
	move.l	d7,-(sp)
	bsr		Click_OpenInventory
	move.l	(sp)+,d7
	rts		

RemoveSelectedChampion_AdjustViewIndex:		; Memory Address ($404C) and binary offset [$3CC8]
	bcc.s	RemoveSelectedChampion_Return
	subq.b	#$01,$000F(a5)
RemoveSelectedChampion_Return:		; Memory Address ($4052) and binary offset [$3CCE]
	rts		

Find_FreeOwnershipSlot:		; Memory Address ($4054) and binary offset [$3CD0]
	; Searches the ownership table for the first unused entry and returns its slot.
	moveq	#$00,d1
FindFreeOwnershipSlot_ScanLoop:		; Memory Address ($4056) and binary offset [$3CD2]
	tst.b	$18(a5,d1.w)
	bmi.s	OwnershipSlotScan_Return
	addq.w	#$01,d1
	cmpi.w	#$0003,d1
	bcs.s	FindFreeOwnershipSlot_ScanLoop
OwnershipSlotScan_Return:		; Memory Address ($4064) and binary offset [$3CE0]
	rts		

Find_ChampionOwner:		; Memory Address ($4066) and binary offset [$3CE2]
	; Searches the ownership table for the player that currently owns the selected
	; champion.
	lea		Player1_Data.l,a5
	bsr.s	Find_ChampionInPlayerSlots
	tst.w	d1
	bpl.s	OwnershipSlotScan_Return
	lea		Player2_Data.l,a5
Find_ChampionInPlayerSlots:		; Memory Address ($4078) and binary offset [$3CF4]
	; Searches a player's champion slots for the selected champion index.
	move.w	d2,-(sp)
	moveq	#$03,d1
FindChampionInPlayerSlots_ScanLoop:		; Memory Address ($407C) and binary offset [$3CF8]
	move.b	$18(a5,d1.w),d2
	bmi.s	FindChampionInPlayerSlots_NextSlot
	and.w	#$000F,d2
	cmp.b	d2,d0
	beq.s	FindChampionInPlayerSlots_Return
FindChampionInPlayerSlots_NextSlot:		; Memory Address ($408A) and binary offset [$3D06]
	dbra	d1,FindChampionInPlayerSlots_ScanLoop
FindChampionInPlayerSlots_Return:		; Memory Address ($408E) and binary offset [$3D0A]
	move.w	(sp)+,d2
	rts		

Find_ChampionFormationSlot:		; Memory Address ($4092) and binary offset [$3D0E]
	; Searches a player's four formation positions for the selected champion index.
	moveq	#$03,d2
FindChampionFormationSlot_ScanLoop:		; Memory Address ($4094) and binary offset [$3D10]
	cmp.b	$26(a5,d2.w),d0
	beq.s	FindChampionFormationSlot_Return
	dbra	d2,FindChampionFormationSlot_ScanLoop
FindChampionFormationSlot_Return:		; Memory Address ($409E) and binary offset [$3D1A]
	rts		

Interface_OpenInventoryActionSelector:		; Memory Address ($40A0) and binary offset [$3D1C]
	; Builds the selectable inventory-object list and either opens selection or
	; displays the supplied no-selection notice.
	bsr		Build_EligibleCompanionList
	tst.w	d2
	bne.s	InventoryActionSelector_OpenSelection
	lea		Notice_PartyCommand_NoTarget.l,a6
	move.b	d7,$0005(a6)														;Patches "THOU HAST NONE PRESENT TO <ACTION>" with the current party-command word token.
Interface_ShowInventoryActionNotice:		; Memory Address ($40B2) and binary offset [$3D2E]
	; Clears the page state and prints a fixed inventory/action notice.
	clr.w	$0042(a5)
	jmp		Print_timed_message.l

InventoryActionSelector_OpenSelection:		; Memory Address ($40BC) and binary offset [$3D38]
	move.w	#$0001,$0044(a5)
	bra.s	Interface_InitInventoryActionSelector

Interface_OpenInventorySelection:		; Memory Address ($40C4) and binary offset [$3D40]
	; Selects the inventory-selection page and enters the common selection-prompt
	; path.
	move.w	#$0003,$0044(a5)
Interface_InitInventoryActionSelector:		; Memory Address ($40CA) and binary offset [$3D46]
	; Marks selection as active, patches the prompt template with the action value,
	; and opens the fixed-message selector.
	move.b	#$01,$004E(a5)
	lea		Notice_PartyCommand_SelectTarget.l,a6
	move.b	d7,$0007(a6)														;Patches "WHOM DOST THOU WISH TO <ACTION>?" with the current party-command word token.
	jsr		Print_fix_message.l
	bra		Draw_PartyCommandMenu

PartyCommand_View:		; Memory Address ($40E4) and binary offset [$3D60]
	; Opens selection for an eligible waiting party member and switches the
	; viewpoint through that member; otherwise displays "EVERYONE IS PRESENT".
	tst.b	$004E(a5)
	bne.s	Interface_CommitSelectedInventoryAction
	moveq	#$12,d7
	moveq	#$03,d1
	moveq	#$00,d2
PartyCommand_View_CountEligibleLoop:		; Memory Address ($40F0) and binary offset [$3D6C]
	move.b	$18(a5,d1.w),d0
	bmi.s	PartyCommand_View_SlotScanContinue
	btst	#$06,d0
	bne.s	PartyCommand_View_SlotScanContinue
	btst	#$05,d0																;Only party entries marked as waiting are eligible for View.
	beq.s	PartyCommand_View_SlotScanContinue
	addq.w	#$01,d2
PartyCommand_View_SlotScanContinue:		; Memory Address ($4104) and binary offset [$3D80]
	dbra	d1,PartyCommand_View_CountEligibleLoop
	tst.w	d2
	bne.s	Interface_OpenInventorySelection
	lea		Notice_View_EveryonePresent.l,a6									;Selects "EVERYONE IS PRESENT" when no waiting party member is available to View.
	bra.s	Interface_ShowInventoryActionNotice

Interface_CommitSelectedInventoryAction:		; Memory Address ($4114) and binary offset [$3D90]
	; Stores the selected inventory action nibble, patches its notice template, and
	; commits the pending action.
	bsr		Interface_MapSelectedAction
	move.b	d0,$0053(a5)
	and.b	#$0F,$0053(a5)														;Retains the selected champion index while discarding the party-entry state flags.
	move.b	#$01,$0014(a5)														;Marks the selected waiting champion as the active remote viewpoint.
	lea		Notice_View_ThroughPartyMember.l,a6
	move.b	$0053(a5),$0004(a6)													;Patches "VIEWING THROUGH <NAME>" with the selected champion's name token.
	jsr		Print_fix_message.l
	move.w	#$0101,$0040(a5)
	bra		Reset_PartyCommandStateAndRedrawMenu

PartyCommand_Correct:		; Memory Address ($4144) and binary offset [$3DC0]
	; Opens party-member selection for Correct or sets bit 4 in the selected
	; member's stored party-state byte; displays "<NAME> APOLOGISES FOR BREATHING".
	moveq	#$14,d7																;Selects packed action token $14, CORRECT, for the target prompt.
	lea		Notice_Correct_Apology.l,a6
	moveq	#$10,d3																;Supplies bit 4 so Correct records the correction state on the selected party entry.
	bra.s	Interface_CommitSelectedObjectFlags

PartyCommand_Commend:		; Memory Address ($4150) and binary offset [$3DCC]
	; Opens party-member selection for Commend or clears bit 4 in the selected
	; member's stored party-state byte; displays "<NAME> ACCEPTS THY HONOUR".
	lea		Notice_Commend_Accepted.l,a6
	moveq	#$11,d7																;Selects packed action token $11, COMMEND, for the target prompt.
	moveq	#$00,d3																;Supplies a clear bit 4 so Commend removes the selected party entry's correction state.
Interface_CommitSelectedObjectFlags:		; Memory Address ($415A) and binary offset [$3DD6]
	; Maps the selected object, clears its active flag, updates the pocket flags,
	; and prints the action notice.
	tst.b	$004E(a5)
	beq		Interface_OpenInventoryActionSelector
	bsr.s	Interface_MapSelectedAction
	bclr	#$04,$19(a5,d2.w)													;Clears the existing correction-state bit before applying the Correct or Commend value.
	or.b	$19(a5,d2.w),d3
	move.b	d3,$19(a5,d2.w)
	move.b	d0,(a6)																;Patches the Correct or Commend result template with the selected party member's name token.
	jsr		Print_timed_message.l
	bra		Reset_PartyCommandStateAndRedrawMenu

Interface_MapSelectedAction:		; Memory Address ($417E) and binary offset [$3DFA]
	; Maps the selected button index through the runtime action-selection scratch
	; entries at $7C24; negative entries return the existing
	; Return_InvalidPlayerAction path.
	lea		Interface_ActionSelectionScratchEntries.l,a1
	and.w	#$0003,d1
	move.w	d1,d2
	add.w	d1,d1
	move.b	$00(a1,d1.w),d0
	bmi.s	Return_InvalidPlayerAction
	lsr.w	#$01,d1
	rts		

Return_InvalidPlayerAction:		; Memory Address ($451A) and binary offset [$4196]
	; Returns from invalid or unavailable player-action processing.
	move.w	#$FFFF,$000C(a5)
	addq.w	#$04,sp
	rts		

Notice_PartyCommand_SelectTarget:		; Memory Address ($41A0) and binary offset [$3E1C]
	; Packed-word prompt displayed as "WHOM DOST THOU WISH TO <ACTION>?"; the
	; action word is patched at runtime.
	dc.b	$18	;18
	dc.b	$FA	;FA
	dc.b	$4D	;4D
	dc.b	$19	;19
	dc.b	$1A	;1A
	dc.b	$1B	;1B
	dc.b	$1C	;1C
	dc.b	$00	;00
	dc.b	$FA	;FA
	dc.b	$3F	;3F
	dc.b	$FF	;FF
Notice_Commend_Accepted:		; Memory Address ($41AB) and binary offset [$3E27]
	; Packed-word Commend result displayed as "<NAME> ACCEPTS THY HONOUR"; the
	; selected party-member token replaces the default BLODWYN token.
	dc.b	$00	;00
	dc.b	$1D	;1D
	dc.b	$FA	;FA
	dc.b	$53	;53
	dc.b	$1E	;1E
	dc.b	$1F	;1F
	dc.b	$FF	;FF
Notice_Correct_Apology:		; Memory Address ($41B2) and binary offset [$3E2E]
	; Packed-word Correct result displayed as "<NAME> APOLOGISES FOR BREATHING";
	; the selected party-member token replaces the default BLODWYN token.
	dc.b	$00	;00
	dc.b	$21	;21
	dc.b	$FA	;FA
	dc.b	$53	;53
	dc.b	$22	;22
	dc.b	$23	;23
	dc.b	$FB	;FB
	dc.b	$4A	;4A
	dc.b	$FF	;FF
Notice_PartyCommand_UnableToDepart:		; Memory Address ($41BB) and binary offset [$3E37]
	; Packed-word Wait or Dismiss failure displayed as "<NAME> IS UNABLE TO
	; DEPART"; the selected party-member token replaces the default BLODWYN token.
	dc.b	$00	;00
	dc.b	$35	;35
	dc.b	$17	;17
	dc.b	$1C	;1C
	dc.b	$30	;30
	dc.b	$FF	;FF
Notice_Wait_PartyMemberWaits:		; Memory Address ($41C1) and binary offset [$3E3D]
	; Packed-word Wait result displayed as "<NAME> WAITS"; the selected
	; party-member token replaces the default BLODWYN token.
	dc.b	$00	;00
	dc.b	$13	;13
	dc.b	$FA	;FA
	dc.b	$53	;53
	dc.b	$FF	;FF
Notice_Dismiss_PartyMemberLeaves:		; Memory Address ($41C6) and binary offset [$3E42]
	; Packed-word Dismiss result displayed as "<NAME> LEAVES THE PARTY"; the
	; selected party-member token replaces the default BLODWYN token.
	dc.b	$00	;00
	dc.b	$24	;24
	dc.b	$FA	;FA
	dc.b	$53	;53
	dc.b	$25	;25
	dc.b	$26	;26
	dc.b	$FF	;FF
Notice_PartyCommand_NoTarget:		; Memory Address ($41CD) and binary offset [$3E49]
	; Packed-word result displayed as "THOU HAST NONE PRESENT TO <ACTION>"; the
	; action word is patched at runtime.
	dc.b	$1A	;1A
	dc.b	$27	;27
	dc.b	$28	;28
	dc.b	$36	;36
	dc.b	$1C	;1C
	dc.b	$00	;00
	dc.b	$FF	;FF
Notice_Call_Out:		; Memory Address ($41D4) and binary offset [$3E50]
	; Contains the packed phrase "THOU DOST CALL OUT", followed by a second
	; terminated phrase "<NAME> DEPARTS"; only the first phrase is directly
	; referenced here and use of the second remains unresolved.
	dc.b	$1A	;1A
	dc.b	$19	;19
	dc.b	$16	;16
	dc.b	$2A	;2A
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$30	;30
	dc.b	$FA	;FA
	dc.b	$53	;53
	dc.b	$FF	;FF
Notice_PartyMemberRejoins:		; Memory Address ($41DE) and binary offset [$3E5A]
	; Packed-word party-management result displayed as "<NAME> REJOINS THE PARTY";
	; the party-member token replaces the default BLODWYN token at runtime.
	dc.b	$00	;00
	dc.b	$32	;32
	dc.b	$25	;25
	dc.b	$26	;26
	dc.b	$FF	;FF
Notice_View_ThroughPartyMember:		; Memory Address ($41E3) and binary offset [$3E5F]
	; Packed-word View notice displayed as "VIEWING THROUGH <NAME>"; the viewed
	; party-member token replaces the default BLODWYN token at runtime.
	dc.b	$12	;12
	dc.b	$FB	;FB
	dc.b	$4A	;4A
	dc.b	$34	;34
	dc.b	$00	;00
	dc.b	$FF	;FF
Notice_View_EveryonePresent:		; Memory Address ($41E9) and binary offset [$3E65]
	; Packed-word View notice displayed as "EVERYONE IS PRESENT".
	dc.b	$20	;20
	dc.b	$35	;35
	dc.b	$36	;36
	dc.b	$FF	;FF
Notice_View_NormalRestored:		; Memory Address ($41ED) and binary offset [$3E69]
	; Packed-word View notice displayed as "NORMAL VIEWING RESTORED".
	dc.b	$37	;37
	dc.b	$12	;12
	dc.b	$FB	;FB
	dc.b	$4A	;4A
	dc.b	$38	;38
	dc.b	$FF	;FF
Notice_Communicate_NobodyHere:		; Memory Address ($41F3) and binary offset [$3E6F]
	; Packed-word Communicate failure displayed as "THERE IS NOBODY HERE".
	dc.b	$39	;39
	dc.b	$35	;35
	dc.b	$3D	;3D
	dc.b	$FB	;FB
	dc.b	$3A	;3A
	dc.b	$3B	;3B
	dc.b	$FF	;FF

Comms_GetState:		; Memory Address ($41FA) and binary offset [$3E76]
	; Returns the active player's sixteen-byte communication state record.
	lea		Comms_StateRecords.l,a4
	btst	#$00,(a5)
	beq.s	Return_CommsState
	add.w	#$0010,a4
Return_CommsState:		; Memory Address ($420A) and binary offset [$3E86]
	; Return from communication-state record selection; bit 0 has already selected
	; the active record.
	rts		

Click_ChampionPresentationOrPartyCommand:		; Memory Address ($420C) and binary offset [$3E88]
	; Handles a lower champion shield click or the compact-stat command-region
	; click.
	move.w	$0004(a5),d1														;Reads the pointer Y coordinate before converting it to player-local panel coordinates.
	sub.w	$0008(a5),d1														;Subtracts the player screen Y offset so the following hit tests use native interface coordinates.
	cmpi.w	#PartyPresentation_LowerFirstY,d1									;Separates lower shield clicks from the main-avatar and party-command region above.
	bcs.s	Enter_PartyCommandInterface
	move.w	$0002(a5),d1
	lsr.w	#$05,d1																;Converts the lower shield-click X coordinate to a 32-pixel column index; the following add selects PlayerData_AvatarPresentationState bits one through three.
	and.w	#$0003,d1															;Keeps the three lower shield columns after the X-coordinate conversion.
	addq.w	#$01,d1
Toggle_ChampionPresentation:		; Memory Address ($4226) and binary offset [$3EA2]
	; Toggles the selected champion presentation-state bit at PlayerData+$3E and
	; redraws the interface.
	bchg	d1,PlayerData_AvatarPresentationState(a5)							;Toggles only the clicked left-side avatar's presentation bit. This is independent of right-side Click_PartyMember actions $06-$09.
	move.w	d1,d7
	bsr		Refresh_PartyShieldSlotIfDirty										;Refreshes the clicked party shield slot after changing its presentation bit; the selected living path draws the one-step-away full character.
	bra		Draw_PartyShieldChainStrip

Enter_PartyCommandInterface:		; Memory Address ($4234) and binary offset [$3EB0]
	; Opens the party command interface only when lower champion presentation bits
	; 1-3 are all clear; otherwise returns without opening it.
	moveq	#$00,d1
	cmp.w	#PartyPresentation_StatsXFirst,$0002(a5)							;Treats the compact-statistics area as the party-command request; clicks to its left toggle the main avatar instead.
	bcs.s	Toggle_ChampionPresentation
	move.b	$003E(a5),d0
	and.b	#PartyPresentation_LowerSlotMask,d0									;Prevents party-command entry while any of the three lower shield presentation bits is set, including invisible dead or vacant-slot toggles.
	bne.s	Return_PartyCommandEntry
	clr.w	$0042(a5)															;Clears the party-command page/depth state before rebuilding the top-level command interface.
	clr.w	$0044(a5)
	move.w	#$FFFF,$0040(a5)													;Marks the party-command selection as unset before the command panel is drawn.
	clr.b	$003E(a5)															;Clears all four party presentation bits after command entry is accepted, restoring every avatar state underneath the command surface.
	bra		Draw_PartyCommandInterface

Click_PauseGame:		; Memory Address ($425E) and binary offset [$3EDA]
	; Pauses the shared game clock, marks the game paused, changes hardware palette
	; entries 0 and 15 to red, waits for either player's resume input, then
	; restores the clock, palette, pause flags, and both pending actions.
	move.l	WorldTick_300UnitCountdown.l,d1
	move.w	#$FFFF,Paused_Marker.l
	lea		_custom+color.l,a0
	move.w	#$0400,(a0)
	move.w	#$0400,$001E(a0)
Pause_WaitForInput_Loop:		; Memory Address ($427C) and binary offset [$3EF8]
	; Waits until either pause-input flag becomes negative before restoring display
	; state.
	move.b	Player1_PauseInputFlag.l,d0
	or.b	Player2_PauseInputFlag.l,d0
	bpl.s	Pause_WaitForInput_Loop
	clr.w	(a0)
	clr.w	$001E(a0)
	move.l	d1,WorldTick_300UnitCountdown.l
	and.b	#$7F,Player1_PauseInputFlag.l
	and.b	#$7F,Player2_PauseInputFlag.l
	clr.b	Player1_PendingAction.l
	clr.b	Player2_PendingAction.l
	clr.w	Paused_Marker.l
Return_PartyCommandEntry:		; Memory Address ($42B8) and binary offset [$3F34]
	; Return path used when the party-command entry gate is not satisfied.
	rts		

Draw_InitialGameInterface:		; Memory Address ($42BA) and binary offset [$3F36]
	; Initialises and draws each active player's interface and death state, then
	; presents the completed frame.
	lea		Player1_Data.l,a5
	bsr		Reset_PlayerActionState
	bsr		Redraw_GameInterfaceFromScratch
	btst	#$06,$0018(a5)
	beq.s	Draw_InitialGameInterface_Player2Gate
	bsr		Draw_PlayerDeathMessage
Draw_InitialGameInterface_Player2Gate:		; Memory Address ($42D4) and binary offset [$3F50]
	tst.w	MultiPlayer.l
	bmi.s	Draw_InitialGameInterface_PreSwapJoin
	lea		Player2_Data.l,a5
	bsr		Reset_PlayerActionState
	bsr		Draw_PlayerInterfaceAndDungeonViewport
	btst	#$06,$0018(a5)
	beq.s	Draw_InitialGameInterface_PreSwapJoin
	bsr		Draw_PlayerDeathMessage
Draw_InitialGameInterface_PreSwapJoin:		; Memory Address ($42F6) and binary offset [$3F72]
	jsr		Swap_DisplayAndDrawBuffers.l
	bsr		Copy_DrawBufferToDisplayBuffer
	move.w	#$FFFF,FrameSyncFlag.l
	rts		

Reset_PlayerActionState:		; Memory Address ($468E) and binary offset [$430A]
	; Resets per-player interface state, clears the active action, and restores the
	; invalid-action value.
	and.b	#$01,(a5)
	clr.b	$0056(a5)
	clr.w	$0014(a5)
	clr.b	$003C(a5)
	clr.b	$003E(a5)
	clr.b	$0050(a5)
	move.w	#Player_ActionInvalid,$000C(a5)										;Value meaning no active action.
	rts		

Click_LoadSaveGame:		; Memory Address ($432A) and binary offset [$3FA6]
	; Pauses world updates, presents the load/save function-key prompt for the
	; active player panels, dispatches F1 to load and F2 to save, and restores the
	; game interface when F10 exits.
	move.l	WorldTick_300UnitCountdown.l,-(sp)
	clr.w	FrameSyncFlag.l
	move.l	#$00067D00,screen_ptr.l
	move.l	#$00060000,framebuffer_ptr.l
	lea		Player1_Data.l,a5
	lea		Msg_LoadSaveFunctionKeys.l,a6
	jsr		WriteText.l
	tst.w	MultiPlayer.l
	bne.s	Click_LoadSaveGame_AfterPlayerPrompts
	lea		Player2_Data.l,a5
	lea		Msg_LoadSaveFunctionKeys.l,a6
	jsr		WriteText.l
Click_LoadSaveGame_AfterPlayerPrompts:		; Memory Address ($4376) and binary offset [$3FF2]
	clr.b	KeyboardKeyCode.w													;Short Absolute converted to symbol!
	bsr		Swap_DisplayAndDrawBuffers
.PickLoadSaveGame_Loop:		; Memory Address ($437E) and binary offset [$3FFA]
	move.b	KeyboardKeyCode.w,d0												;Short Absolute converted to symbol!
	cmpi.b	#$50,d0
	beq.s	LoadGame
	cmpi.b	#$51,d0
	beq		SaveGame
	cmpi.b	#$59,d0
	bne.s	.PickLoadSaveGame_Loop
Finish_LoadSaveAndRedrawInterface:		; Memory Address ($4396) and binary offset [$4012]
	; Restores the saved periodic counter, clears the keyboard code, and redraws
	; the initial game interface after load, save, or cancel.
	move.l	(sp)+,WorldTick_300UnitCountdown.l
	clr.b	KeyboardKeyCode.w													;Short Absolute converted to symbol!
	bra		Draw_InitialGameInterface

LoadGame:		; Memory Address ($43A4) and binary offset [$4020]
	moveq	#$00,d0
	bsr		Show_LoadSaveDiskPrompt
	bcs.s	Finish_LoadSaveAndRedrawInterface
	bsr		LoadGame_ReadChampionDataFromDisk
	tst.l	d0
	bmi.s	LoadGame
	bsr		Select_CurrentTowerMapData
	bra.s	Finish_LoadSaveAndRedrawInterface

SaveGame:		; Memory Address ($43BA) and binary offset [$4036]
	moveq	#$01,d0
	bsr		Show_LoadSaveDiskPrompt
	bcs.s	Finish_LoadSaveAndRedrawInterface
	bsr		SaveGame_WriteChampionDataToDisk
	tst.l	d0
	bmi.s	SaveGame
	bra.s	Finish_LoadSaveAndRedrawInterface

AwaitDisk:		; Memory Address ($43CC) and binary offset [$4048]
	; Selects the insert-disk prompt for loading or saving and tail-calls the text
	; printer.
	lea		Msg_InstertLoadDisk.l,a6
	tst.w	d0
	beq.s	.PickLoadSaveMessage
	lea		Msg_InstertSaveDisk.l,a6
.PickLoadSaveMessage:		; Memory Address ($43DC) and binary offset [$4058]
	jmp		WriteText.l

Show_LoadSaveDiskPrompt:		; Memory Address ($43E2) and binary offset [$405E]
	; Shows the load/save disk prompt for each active player, presents it, and
	; enters the keyboard-confirmation loop.
	lea		Player1_Data.l,a5
	tst.w	MultiPlayer.l
	bne.s	Show_LoadSaveDiskPrompt_AwaitCurrentPlayer
	move.w	d0,-(sp)
	bsr.s	AwaitDisk
	move.w	(sp)+,d0
	lea		Player2_Data.l,a5
Show_LoadSaveDiskPrompt_AwaitCurrentPlayer:		; Memory Address ($43FC) and binary offset [$4078]
	bsr.s	AwaitDisk
	clr.b	KeyboardKeyCode.w													;Short Absolute converted to symbol!
	bsr		Swap_DisplayAndDrawBuffers
LoadSaveGame_Loop:		; Memory Address ($4406) and binary offset [$4082]
	; Polls the keyboard during the load/save menu until a load, save, or exit key
	; is received, returning the result to the caller.
	move.b	KeyboardKeyCode.w,d0												;Short Absolute converted to symbol!
	cmpi.b	#$44,d0
	beq.s	LoadSaveGame_Action
	cmpi.b	#$43,d0
	beq.s	LoadSaveGame_Action
	cmpi.b	#$59,d0
	bne.s	LoadSaveGame_Loop
	sub.b	#$FF,d0
	rts		

LoadSaveGame_Action:		; Memory Address ($4422) and binary offset [$409E]
	; Selects save-data start track $3C in single-player mode or $46 in two-player
	; mode for the following disk read or write.
	moveq	#$3C,d0
	tst.w	MultiPlayer.l
	beq.s	LoadSaveGame_Action_ApplyTrackSectorCount
	moveq	#$46,d0
LoadSaveGame_Action_ApplyTrackSectorCount:		; Memory Address ($442E) and binary offset [$40AA]
	move.w	d0,SaveData_StartTrackNumber.l
	rts		

DiskIO_CopyProtectionFail_ReturnError:		; Memory Address ($4436) and binary offset [$40B2]
	jsr		Select_FloppyDrive0.l
	moveq	#-$01,d0
	rts		

LoadGame_ReadChampionDataFromDisk:		; Memory Address ($4440) and binary offset [$40BC]
	; Performs the protected save-disk setup and reads the champion records through
	; the raw floppy-track decoder.
	jsr		CopyProtection.l
	tst.l	d0
	beq.s	DiskIO_CopyProtectionFail_ReturnError
	move.l	screen_ptr.l,SavedScreenPointer.l
	jsr		Select_FloppySideSignalHigh.l
	move.w	SaveData_StartTrackNumber.l,d7
	jsr		Seek_FloppyToTrack.l
	lea		Character_Stats_DataTable.l,a0
	moveq	#$08,d0
	jsr		Read_FloppyTrackSequence.l
	jsr		Select_FloppyDrive0.l
	moveq	#$00,d0
	rts		

SaveData_StartTrackNumber:		; Memory Address ($447E) and binary offset [$40FA]
	; Starting floppy track for champion save data: $3C in one-player mode and $46
	; in two-player mode.
	ds.b	$2
SaveGame_WriteChampionDataToDisk:		; Memory Address ($4480) and binary offset [$40FC]
	; Performs the protected save-disk setup and writes the champion records
	; through the raw floppy-track encoder.
	jsr		CopyProtection.l
	tst.l	d0
	beq.s	DiskIO_CopyProtectionFail_ReturnError
	move.l	screen_ptr.l,SavedScreenPointer.l
	jsr		Select_FloppySideSignalHigh.l
	move.w	SaveData_StartTrackNumber.w,d7										;Short Absolute converted to symbol!
	jsr		Seek_FloppyToTrack.l
	lea		Character_Stats_DataTable.l,a0
	moveq	#$00,d0
	move.w	SaveData_StartTrackNumber.w,d0										;Short Absolute converted to symbol!
	moveq	#$00,d1
	moveq	#$08,d7
	jsr		Write_FloppyTrackSequence.l
	jsr		Select_FloppyDrive0.l
	moveq	#$00,d0
	rts		

Msg_LoadSaveFunctionKeys:
	dc.b	'F1 - LOAD, F2 - SAVE, F10 - EXIT'
	dc.b	$FF	;FF
Msg_InstertLoadDisk:
	dc.b	'INSERT LOAD DISK AND RETURN, F10 - EXIT'
	dc.b	$FF	;FF
Msg_InstertSaveDisk:
	dc.b	'INSERT SAVE DISK AND RETURN, F10 - EXIT'
	dc.b	$FF	;FF
	dc.b	$00	;00

Click_SleepParty:		; Memory Address ($4536) and binary offset [$41B2]
	move.b	#$03,PlayerData_InteractionPartySlotIndex(a5)
	clr.w	$0014(a5)
	move.w	#$FFFF,PlayerData_PartyCommandState(a5)
	move.w	#$FFFF,PlayerData_PartyCommandSelection(a5)
	move.b	#$FF,PlayerData_EngagedActorIndex(a5)
	moveq	#$03,d7
Click_SleepParty_ResetSpellStateLoop:		; Memory Address ($4554) and binary offset [$41D0]
	; Initialises each active new-party member's spell state by clearing the worn
	; spell and cast power and setting the selected spell to $FF.
	move.b	$18(a5,d7.w),d0
	and.w	#$00C0,d0
	bne.s	Click_SleepParty_SkipUnusedSlot
	move.b	$18(a5,d7.w),d0
	bsr		Load_ChampionStatRecord
	clr.b	ChampionStat_WornSpell(a4)
	move.b	#$FF,ChampionStat_SpellToCast(a4)
	clr.b	ChampionStat_SpellPowerBoost(a4)
Click_SleepParty_SkipUnusedSlot:		; Memory Address ($4574) and binary offset [$41F0]
	dbra	d7,Click_SleepParty_ResetSpellStateLoop
	bsr		Draw_PartyCommandInterface
	bsr		Draw_ChampionNamePanelFrame
ShowAsleepNotice_ResetPageState:		; Memory Address ($4580) and binary offset [$41FC]
	bsr		Draw_ViewportMessageFrame
	and.b	#$01,(a5)
	OPT		O2+
	bset	#PlayerData_StateFlags_SleepingBit,PlayerData_StateFlags(a5)
	OPT		O2-
	move.b	#$32,PlayerData_FairyOfferDelayCountdown(a5)
	move.b	#$02,PlayerData_InterfaceContextState(a5)
	clr.b	PlayerData_InteractionSelectionStage(a5)
	move.b	#$01,PlayerData_DialogueColourState(a5)
	clr.b	PlayerData_DialogueFadeStepCountdown(a5)
	tst.b	PlayerData_DialogueFadeRampStep(a5)
	bmi.s	ShowAsleepNotice_PrintText
	move.w	#$00FF,$004A(a5)
ShowAsleepNotice_PrintText:		; Memory Address ($45B2) and binary offset [$422E]
	lea		ThouArtAsleep.l,a6
	jsr		Print_fflim_text.l
	jmp		Clear_LowerTextStrip.l

ThouArtAsleep:		; Memory Address ($45C4) and binary offset [$4240]
	dc.b	$FC	;FC
	dc.b	$10	;10
	dc.b	$04	;04
	dc.b	$FE	;FE
	dc.b	$0A	;0A
	dc.b	$FD	;FD
	dc.b	$00	;00
	dc.b	'THOU ART'
	dc.b	$FC	;FC
	dc.b	$11	;11
	dc.b	$06	;06
	dc.b	'ASLEEP'
	dc.b	$FF	;FF
	dc.b	$00	;00

Draw_Fairy:		; Memory Address ($45DE) and binary offset [$425A]
	; Draws the mirrored fairy portrait used by the spell-shop interface.
	move.l	a4,-(sp)
	asl.w	#$02,d0
	lea		GFX_Fairy_ColourVariants.l,a6
	add.w	d0,a6
	link	a3,#-$0020
	move.l	screen_ptr.l,a0
	add.w	$000A(a5),a0
	add.w	#$01EC,a0
	move.l	a0,-$0008(a3)
	lea		GFX_Fairy.l,a1
	moveq	#$08,d4
	moveq	#$05,d5
	moveq	#$28,d7
	moveq	#$00,d6
	bsr		Draw_Monster_16PixelStrip
	lea		GFX_Fairy.l,a1
	moveq	#$17,d4
	moveq	#$05,d5
	moveq	#$28,d7
	moveq	#-$01,d6
	bsr		Draw_Monster_16PixelStrip
	unlk	a3
	move.l	(sp)+,a4
	rts		

GFX_Fairy_ColourVariants:		; Memory Address ($462A) and binary offset [$42A6]
	dc.w	$0504	;0504
	dc.w	$0806	;0806
	dc.w	$0B04	;0B04
	dc.w	$080D	;080D
	dc.w	$0904	;0904
	dc.w	$080C	;080C
	dc.w	$0704	;0704
	dc.w	$0808	;0808
adrEA00463A:
	dc.w	$060D	;060D
	dc.w	$0C08	;0C08
SpellShop_CandidateSpellBitTable:		; Memory Address ($463E) and binary offset [$42BA]
	; Eight candidate spell-bit identifiers per class, scanned by the Fairy
	; spell-shop to offer the first spell the champion does not know.
	dc.w	$1C1B	;1C1B
	dc.w	$1107	;1107
	dc.w	$0D16	;0D16
	dc.w	$0A00	;0A00
	dc.w	$1812	;1812
	dc.w	$1D0B	;1D0B
	dc.w	$170E	;170E
	dc.w	$0104	;0104
	dc.w	$1E0F	;1E0F
	dc.w	$1419	;1419
	dc.w	$1302	;1302
	dc.w	$0508	;0508
	dc.w	$1A1F	;1A1F
	dc.w	$1509	;1509
	dc.w	$1006	;1006
	dc.w	$0C03	;0C03

FairyShop_DispatchByState:		; Memory Address ($465E) and binary offset [$42DA]
	move.b	PlayerData_InteractionSelectionStage(a5),d0
	beq.s	FairyShop_WaitForNoticeTimerExpiry
	subq.b	#$01,d0
	beq		FairyShop_HandleClassSelectionClick
	subq.b	#$01,d0
	beq		FairyShop_HandleSpellOfferClick
	bra		FairyShop_HandleLearnConfirmClick

FairyShop_WaitForNoticeTimerExpiry:		; Memory Address ($4674) and binary offset [$42F0]
	tst.b	$003F(a5)
	bmi		FairyShop_ResetInterfaceStateOnExit
	subq.b	#$01,$003F(a5)
	bpl		FairyShop_ResetInterfaceStateOnExit
	moveq	#$00,d7
FairyShop_ScanChampionSlotsLoop:		; Memory Address ($4686) and binary offset [$4302]
	move.b	PlayerData_InteractionPartySlotIndex(a5),d7
	bmi		FairyShop_ResetInterfaceStateOnExit
	move.b	$18(a5,d7.w),d0
	and.w	#$00E0,d0
	bne.s	FairyShop_AdvanceToNextChampionSlot
	move.b	$18(a5,d7.w),d0
	and.w	#$000F,d0
	lea		SpellShop_ChampionIndexScratch.l,a6
	move.b	d0,(a6)
	bsr		Load_ChampionStatRecord
	cmp.b	#$EC,ChampionStat_LevelProgress(a4)
	bcs.s	FairyShop_CheckChampionEligibleCount
	OPT		O2+
	cmp.b	#$0E,ChampionStat_Level(a4)
	OPT		O2-
	bcs		FairyShop_GrantLevelUp
FairyShop_CheckChampionEligibleCount:		; Memory Address ($46BC) and binary offset [$4338]
	move.b	ChampionStat_FairySpellCount(a4),d0
	and.w	#$007F,d0
	bne.s	FairyShop_ShowSpellPickPrompt
FairyShop_AdvanceToNextChampionSlot:		; Memory Address ($46C6) and binary offset [$4342]
	subq.b	#$01,$004F(a5)
	bra.s	FairyShop_ScanChampionSlotsLoop

FairyShop_ShowSpellPickPrompt:		; Memory Address ($46CC) and binary offset [$4348]
	bsr		Draw_ViewportMessageFrame
	jsr		Clear_LowerTextStrip.l
	move.l	screen_ptr.l,a0
	add.w	$000A(a5),a0
	add.w	#$0A86,a0
	moveq	#$03,d7
FairyShop_DrawClassIconRow:		; Memory Address ($46E6) and binary offset [$4362]
	move.w	d7,d0
	eor.w	#$0003,d0
	add.w	#$0064,d0
	jsr		Draw_PocketGraphic.l
	dbra	d7,FairyShop_DrawClassIconRow
	moveq	#$74,d0
	addq.w	#$02,a0
	move.w	$0012(a5),d3
	jsr		Draw_PocketGraphic.l
	moveq	#$04,d0
	bsr		Draw_Fairy
	or.b	#$40,$0054(a5)
	jsr		InitialiseText.l
	moveq	#$00,d7
	move.b	$004F(a5),d7
	move.b	$18(a5,d7.w),d0
	and.w	#$000F,d0
	clr.b	$0052(a5)
	jsr		Print_wordstext.l
	lea		MayBuySpellMsg.l,a6
	jsr		Print_TextCharacterLoop.l
	move.b	#$01,$004E(a5)
	bra		FairyShop_ResetInterfaceStateOnExit

FairyShop_HandleClassSelectionClick:		; Memory Address ($4748) and binary offset [$43C4]
	bclr	#$07,$0001(a5)
	beq		FairyShop_ResetInterfaceStateOnExit
	move.l	$0002(a5),d1
	sub.w	$0008(a5),d1
	cmpi.b	#$42,d1
	bcs		FairyShop_ResetInterfaceStateOnExit
	cmpi.b	#$54,d1
	bcc		FairyShop_ResetInterfaceStateOnExit
	swap	d1
	sub.b	#$70,d1
	bcs		FairyShop_ResetInterfaceStateOnExit
	cmpi.b	#$40,d1
	bcs.s	FairyShop_OnClassSelected
	sub.b	#$50,d1
	bcs		FairyShop_ResetInterfaceStateOnExit
	cmpi.b	#$10,d1
	bcc		FairyShop_ResetInterfaceStateOnExit
	subq.b	#$01,$004F(a5)
	bra		ShowAsleepNotice_ResetPageState

FairyShop_OnClassSelected:		; Memory Address ($4792) and binary offset [$440E]
	lsr.w	#$04,d1
	move.w	d1,-(sp)
	bsr		Draw_ViewportMessageFrame
	move.l	screen_ptr.l,a0
	add.w	$000A(a5),a0
	add.w	#$0A90,a0
	moveq	#$74,d0
	move.w	$0012(a5),d3
	jsr		Draw_PocketGraphic.l
	move.w	(sp),d0
	bsr		Draw_Fairy
	moveq	#$00,d0
	move.b	$004F(a5),d0
	move.b	$18(a5,d0.w),d0
	bsr		Load_ChampionStatRecord
	move.l	ChampionStat_KnownSpellMask(a4),d7
	lea		SpellShop_CandidateSpellBitTable.w,a6								;Short Absolute converted to symbol!
	move.w	(sp),d1
	asl.w	#$03,d1
	add.w	d1,a6
	moveq	#$00,d0
	moveq	#-$01,d2
	moveq	#$07,d1
FairyShop_ScanCandidateSpellBitsLoop:		; Memory Address ($47DC) and binary offset [$4458]
	move.b	$00(a6,d1.w),d0
	eor.b	#$1F,d0
	btst	d0,d7
	bne.s	FairyShop_CandidateSpellLoopContinue
	eor.b	#$1F,d0
	move.w	d0,d2
	tst.l	d2
	bpl.s	FairyShop_StoreCandidateSpellChoice
	swap	d2
FairyShop_CandidateSpellLoopContinue:		; Memory Address ($47F4) and binary offset [$4470]
	dbra	d1,FairyShop_ScanCandidateSpellBitsLoop
	move.w	#$FFFF,$0044(a5)
	tst.l	d2
	bmi.s	FairyShop_AllSpellsKnownMessage
FairyShop_StoreCandidateSpellChoice:		; Memory Address ($4802) and binary offset [$447E]
	move.b	d2,$0045(a5)
	swap	d2
	move.b	d2,$0044(a5)
	lea		SelectNewSpellMsg.l,a6
	bra.s	FairyShop_ShowSpellOfferResult

FairyShop_AllSpellsKnownMessage:		; Memory Address ($4814) and binary offset [$4490]
	lea		ThouHastAllMsg.l,a6
FairyShop_ShowSpellOfferResult:		; Memory Address ($481A) and binary offset [$4496]
	bsr		Print_FormationSlotChampionName
	move.w	(sp)+,d1
	lea		adrEA00463A.w,a6													;Short Absolute converted to symbol!
	move.b	$00(a6,d1.w),CurrentTextInk_LowByte.l
	move.l	screen_ptr.l,a0
	add.w	$000A(a5),a0
	add.w	#$03D2,a0
	move.b	$0044(a5),d0
	bsr		Print_SelectedSpellListEntry
	move.b	$0045(a5),d0
	bsr		Print_SelectedSpellListEntry
	move.b	#$02,$004E(a5)
	rts		

Print_SelectedSpellListEntry:		; Memory Address ($4852) and binary offset [$44CE]
	; Prints the selected spell name when the entry is valid and advances the
	; destination to the next spell-list row.
	tst.b	d0
	bmi.s	Return_SkipSpellListEntryPrint
	and.w	#$00FF,d0
	move.l	a0,-(sp)
	bsr		Get_SelectedSpellName
	moveq	#$07,d6
	jsr		Print_TextCharacterLoop.l
	move.l	(sp)+,a0
	add.w	#$01B8,a0
Return_SkipSpellListEntryPrint:		; Memory Address ($486E) and binary offset [$44EA]
	rts		

FairyShop_HandleSpellOfferClick:		; Memory Address ($4870) and binary offset [$44EC]
	bclr	#$07,$0001(a5)
	beq.s	Return_SkipSpellListEntryPrint
	move.l	$0002(a5),d1
	sub.w	$0008(a5),d1
	cmpi.w	#$0018,d1
	bcs.s	Return_SkipSpellListEntryPrint
	cmpi.w	#$0027,d1
	bcs.s	FairyShop_ProcessSpellSelectionClick
	sub.b	#$42,d1
	bcs.s	Return_SkipSpellListEntryPrint
	cmpi.b	#$10,d1
	bcc.s	Return_SkipSpellListEntryPrint
	swap	d1
	sub.w	#$00C0,d1
	bcs.s	Return_SkipSpellListEntryPrint
	cmpi.b	#$10,d1
	bcc.s	Return_SkipSpellListEntryPrint
	bra		FairyShop_ShowSpellPickPrompt

FairyShop_ProcessSpellSelectionClick:		; Memory Address ($48AA) and binary offset [$4526]
	swap	d1
	sub.b	#$90,d1
	bcs.s	Return_SkipSpellListEntryPrint
	cmpi.b	#$40,d1
	bcc.s	Return_SkipSpellListEntryPrint
	swap	d1
	sub.w	#$0018,d1
	lsr.w	#$03,d1
	move.b	$44(a5,d1.w),d0
	bmi.s	Return_SkipSpellListEntryPrint
	move.b	d0,$0044(a5)
	jsr		InitialiseText.l
	lea		SpellDescriptions.l,a3
	moveq	#$00,d0
	move.b	$0044(a5),d0
	jsr		Print_word.l
	jsr		TerminateText.l
	move.l	#$00100018,d5
	add.w	$0008(a5),d5
	move.l	#$003F0090,d4
	moveq	#$00,d3
	jsr		BW_draw_bar.l
	move.b	$0044(a5),d0
	bsr		Character_GetClassIndex
	lea		adrEA00463A.w,a6													;Short Absolute converted to symbol!
	move.b	$00(a6,d0.w),CurrentTextInk_LowByte.l
	add.w	#$0064,d0
	move.l	screen_ptr.l,a0
	add.w	$000A(a5),a0
	add.w	#$0A86,a0
	jsr		Draw_PocketGraphic.l
	move.l	screen_ptr.l,a0
	add.w	$000A(a5),a0
	add.w	#$03D2,a0
	moveq	#$00,d0
	move.b	$0044(a5),d0
	bsr		Print_SelectedSpellListEntry
	bsr		Calculate_SpellCastingCost
	lea		SpellPurchasePromptTemplate.l,a6
	add.w	#$0030,d1
	move.b	d1,$000E(a6)
	jsr		Convert_ByteToDecimalText.l
	move.w	d1,$0012(a6)
	jsr		Print_fflim_text.l
	moveq	#$00,d0
	move.b	$004F(a5),d0
	move.b	$18(a5,d0.w),d0
	bsr		Load_ChampionStatRecord
	move.b	$0044(a5),ChampionStat_SpellToCast(a4)
	clr.b	ChampionStat_SpellCooldown(a4)
	bsr		Show_SpellCastPrompt
	move.b	#$FF,ChampionStat_SpellToCast(a4)
	or.b	#$40,$0054(a5)
	move.b	#$03,$004E(a5)
FairyShop_StateHandlerReturn:		; Memory Address ($4994) and binary offset [$4610]
	rts		

Calculate_SpellCastingCost:		; Memory Address ($4996) and binary offset [$4612]
	; Returns five times the selected spell's raw cost-table byte.
	lea		SpellCost_DataTable.l,a0
	moveq	#$00,d7
	move.b	$0044(a5),d7
	move.b	$00(a0,d7.w),d0
	move.b	d0,d1
	asl.b	#$02,d0
	add.b	d1,d0
	rts		

Print_FormationSlotChampionName:		; Memory Address ($49AE) and binary offset [$462A]
	; Resolves the selected formation slot's champion identifier and prints that
	; champion's name.
	jsr		InitialiseText.l
	jsr		Print_fflim_text.l
	moveq	#$00,d0
	move.b	$004F(a5),d0
	move.b	$18(a5,d0.w),d0
	and.w	#$000F,d0
	moveq	#$11,d6
	jsr		Print_wordstext.l
	jmp		TerminateText.l

FairyShop_HandleLearnConfirmClick:		; Memory Address ($49D6) and binary offset [$4652]
	bclr	#$07,$0001(a5)
	beq.s	FairyShop_StateHandlerReturn
	move.l	$0002(a5),d1
	sub.w	$0008(a5),d1
	sub.b	#$42,d1
	bcs.s	FairyShop_StateHandlerReturn
	cmpi.b	#$10,d1
	bcc.s	FairyShop_StateHandlerReturn
	swap	d1
	sub.w	#$0070,d1
	bcs.s	FairyShop_StateHandlerReturn
	cmpi.w	#$0010,d1
	bcs.s	FairyShop_DeductSpellCostAndLearn
	cmpi.w	#$0050,d1
	bcs.s	FairyShop_StateHandlerReturn
	cmpi.w	#$0060,d1
	bcc.s	FairyShop_StateHandlerReturn
	bra		FairyShop_ShowSpellPickPrompt

FairyShop_DeductSpellCostAndLearn:		; Memory Address ($4A10) and binary offset [$468C]
	bsr.s	Calculate_SpellCastingCost
	move.w	d0,d2
	moveq	#$00,d1
	move.b	$004F(a5),d1
	move.b	$18(a5,d1.w),d0
	move.b	d0,d1
	asl.b	#$04,d1
	lea		Character_Pockets_DataTable.l,a4
	add.w	d1,a4
	move.b	$000C(a4),d3
	sub.b	d2,d3
	bcs.s	FairyShop_InsufficientGoldMessage
	move.b	d3,$000C(a4)
	bsr		Load_ChampionStatRecord
	eor.b	#$1F,d7
	move.l	ChampionStat_KnownSpellMask(a4),d0
	bset	d7,d0
	move.l	d0,ChampionStat_KnownSpellMask(a4)
	subq.b	#$01,ChampionStat_FairySpellCount(a4)
	subq.b	#$01,$004F(a5)
	bra		ShowAsleepNotice_ResetPageState

FairyShop_InsufficientGoldMessage:		; Memory Address ($4A54) and binary offset [$46D0]
	lea		PauperMsg.l,a6
	bra		Print_FormationSlotChampionName

SpellPurchasePromptTemplate:		; Memory Address ($4A5E) and binary offset [$46DA]
	; Mutable spell-purchase prompt containing LEVEL, GOLD, and confirmation fields
	; patched before display.
	dc.b	$FC	;FC
	dc.b	$12	;12
	dc.b	$04	;04
	dc.b	$FE	;FE
	dc.b	$04	;04
	dc.b	'LEVEL  '
	dc.b	$FE	;FE
	dc.b	$0E	;0E
	dc.b	' '
	dc.b	$FC	;FC
	dc.b	$12	;12
	dc.b	$05	;05
	dc.b	'  '
	dc.b	$FE	;FE
	dc.b	$04	;04
	dc.b	'  GOLD'
	dc.b	$FC	;FC
	dc.b	$12	;12
	dc.b	$09	;09
	dc.b	$FE	;FE
	dc.b	$0C	;0C
	dc.b	'OK ?'
	dc.b	$FF	;FF
MayBuySpellMsg:
	dc.b	' MAY BUY A SPELL-PICK A CLASS'
	dc.b	$FF	;FF
SelectNewSpellMsg:
	dc.b	'SELECT THY NEW SPELL, '
	dc.b	$FF	;FF
ThouHastAllMsg:
	dc.b	'THOU HAST ALL I GIVE, '
	dc.b	$FF	;FF
PauperMsg:
	dc.b	'I FIND THEE A PAUPER, '
	dc.b	$FF	;FF
	dc.b	$00	;00

FairyShop_GrantLevelUp:		; Memory Address ($4AE8) and binary offset [$4764]
	moveq	#$00,d0
	move.b	(a6),d0
	move.l	a6,-(sp)
	bsr.s	Advance_ChampionLevelAndGrowStats
	move.l	(sp)+,a6
	jsr		Print_timed_message.l
	move.b	#$32,$003F(a5)
FairyShop_ResetInterfaceStateOnExit:		; Memory Address ($4AFE) and binary offset [$477A]
	bclr	#$07,$0001(a5)
	beq.s	Return_FairyShopStateMachine
	clr.w	$0014(a5)
	and.b	#$01,(a5)
	clr.b	$0056(a5)
Return_FairyShopStateMachine:		; Memory Address ($4B12) and binary offset [$478E]
	rts		

SpellShop_ChampionIndexScratch:		; Memory Address ($4B14) and binary offset [$4790]
	; Stores the selected spell-shop champion identifier and is read back by the
	; level-growth continuation at $4AE8.
	dc.w	$002B	;002B
	dc.w	$8D2C	;8D2C
	dc.w	$FF00	;FF00
LevelUpXPThresholdTable:		; Memory Address ($4B1A) and binary offset [$4796]
	; Byte-indexed experience thresholds reloaded on level-up and halved for Fairy
	; spell-offer eligibility.
	dc.w	$000B	;000B
	dc.w	$1828	;1828
	dc.w	$3235	;3235
	dc.w	$3C41	;3C41
	dc.w	$4641	;4641
	dc.w	$4146	;4146
	dc.w	$78B4	;78B4

Advance_ChampionLevelAndGrowStats:		; Memory Address ($4B28) and binary offset [$47A4]
	; Increments champion level, reloads level progress, and applies the dice-based
	; hit-point and vitality growth.
	OPT		O2+
	addq.b	#$01,ChampionStat_Level(a4)
	OPT		O2-
	moveq	#$00,d1
	OPT		O2+
	move.b	ChampionStat_Level(a4),d1
	OPT		O2-
	move.b	LevelUpXPThresholdTable(pc,d1.w),ChampionStat_LevelProgress(a4)
	move.w	d0,d4
	bsr		RandomGen_BytewithOffset
	and.w	#$000F,d0
	move.w	d4,d1
	and.w	#$0001,d1
	beq.s	LevelUp_ComputeHitPointsIncrease
	lsr.w	#$01,d0
LevelUp_ComputeHitPointsIncrease:		; Memory Address ($4B48) and binary offset [$47C4]
	add.w	#$0009,d0
	add.b	ChampionStat_HitPointsMaximum(a4),d0
	bcc.s	LevelUp_StoreClampedHitPoints
	move.b	#$FD,d0
LevelUp_StoreClampedHitPoints:		; Memory Address ($4B56) and binary offset [$47D2]
	move.b	d0,ChampionStat_HitPointsMaximum(a4)
	bsr		RandomGen_BytewithOffset
	and.w	#$0007,d0
	addq.w	#$01,d0
	add.b	ChampionStat_VitalityMaximum(a4),d0
	cmpi.w	#$0064,d0
	bcs.s	LevelUp_StoreClampedVitality
	moveq	#$63,d0
LevelUp_StoreClampedVitality:		; Memory Address ($4B70) and binary offset [$47EC]
	move.b	d0,ChampionStat_VitalityMaximum(a4)
	lea		ChampionLevelUp_StatGrowthDieTable.l,a2
	move.w	d4,d0
	and.w	#$0003,d0
	asl.w	#$02,d0
	add.w	d0,a2
	moveq	#$03,d6
LevelUp_StatGrowthRollLoop:		; Memory Address ($4B86) and binary offset [$4802]
	cmp.b	#$06,(a2)
	bne.s	LevelUp_RollStandardStatGrowth
	bsr		RandomGen_SixSidedRoll
	bra.s	LevelUp_ApplyStatGrowthRoll

LevelUp_RollStandardStatGrowth:		; Memory Address ($4B92) and binary offset [$480E]
	bsr		RandomGen_BytewithOffset
	and.w	#$0007,d0
	cmp.b	#$04,(a2)
	bne.s	LevelUp_ApplyStatGrowthRoll
	lsr.w	#$01,d0
LevelUp_ApplyStatGrowthRoll:		; Memory Address ($4BA2) and binary offset [$481E]
	addq.w	#$01,d0
	add.b	$01(a4,d6.w),d0														;D6 walks Charisma, Intelligence, Agility and Strength backwards through ChampionStat offsets $04-$01.
	cmpi.b	#$64,d0
	bcs.s	LevelUp_StoreClampedStatGrowth
	moveq	#$63,d0
LevelUp_StoreClampedStatGrowth:		; Memory Address ($4BB0) and binary offset [$482C]
	move.b	d0,$01(a4,d6.w)														;Stores the grown primary statistic selected by D6: Charisma, Intelligence, Agility or Strength.
	addq.w	#$01,a2
	dbra	d6,LevelUp_StatGrowthRollLoop
	bclr	#$07,ChampionStat_FairySpellCount(a4)
	move.w	d4,d0
	and.w	#$0003,d4
	subq.w	#$01,d4
	bne.s	Recalculate_CharacterDerivedStats
	addq.b	#$01,ChampionStat_FairySpellCount(a4)
Recalculate_CharacterDerivedStats:		; Memory Address ($4BCE) and binary offset [$484A]
	; Recalculates derived champion values including spell thresholds and the
	; Level/Agility action-speed reload.
	bsr		Calculate_SpellPracticeThreshold
	moveq	#$00,d2
	OPT		O2+
	move.b	ChampionStat_Level(a4),d2
	OPT		O2-
	lea		LevelUpXPThresholdTable.w,a6										;Short Absolute converted to symbol!
	move.b	$00(a6,d2.w),ChampionStat_LevelProgress(a4)
	move.b	ChampionStat_Agility(a4),d1
	lsr.b	#$04,d1
	lsr.b	#$01,d2
	add.b	d2,d1
	sub.b	#$0F,d1
	neg.b	d1
	cmpi.b	#$08,d1
	bcc.s	Recalculate_ClampAndStoreActionSpeed
	moveq	#$08,d1
Recalculate_ClampAndStoreActionSpeed:		; Memory Address ($4BF8) and binary offset [$4874]
	asl.b	#CharacterActionTimer_ReloadShift,d1
	move.b	d1,ChampionStat_ActionCycleTimer(a4)
	rts		

ChampionLevelUp_StatGrowthDieTable:		; Memory Address ($4C00) and binary offset [$487C]
	; Per-class, per-stat die selectors used when growing champion statistics on
	; level-up.
	dc.w	$0404	;0404
	dc.w	$0608	;0608
	dc.w	$0408	;0408
	dc.w	$0604	;0604
	dc.w	$0806	;0806
	dc.w	$0606	;0606
	dc.w	$0404	;0404
	dc.w	$0806	;0806

Click_TogglePartyCommandRow:		; Memory Address ($4C10) and binary offset [$488C]
	; Toggles the visible party-command row when communication mode is active.
	cmp.w	#$0008,$0042(a5)
	bne.s	Return_PartyCommandRowIdle
	cmp.w	#$0006,$0044(a5)
	bcc.s	Return_PartyCommandRowIdle
	eor.w	#$0001,$0044(a5)
	bra		Draw_PartyCommandMenu

PartyCommandRow_DispatchByPageState:		; Memory Address ($4C2A) and binary offset [$48A6]
	tst.w	$0042(a5)
	bpl.s	PartyCommandRow_HitTestCommandButtons
	bclr	#$07,$0001(a5)
	beq.s	Return_PartyCommandRowIdle
	move.w	#$001A,$000C(a5)
Return_PartyCommandRowIdle:		; Memory Address ($4C3E) and binary offset [$48BA]
	rts		

PartyCommandRow_HitTestCommandButtons:		; Memory Address ($4C40) and binary offset [$48BC]
	bclr	#$07,$0001(a5)
	beq.s	PartyCommandRow_ComputeHoverHighlight
	lea		Interface_Hitboxes_Command.l,a6
	moveq	#$1C,d0																;Starts the command-row hitbox scan at action ID $1C.
	moveq	#$22,d2																;Sets the exclusive upper bound for the six command-row hitboxes, covering action IDs $1C-$21.
	bra		HitTest_PlayerInterfaceActions

PartyCommandRow_ComputeHoverHighlight:		; Memory Address ($4C56) and binary offset [$48D2]
	moveq	#-$01,d0
	move.l	$0002(a5),d1
	sub.w	$0008(a5),d1
	sub.w	#$003A,d1
	bcs.s	PartyCommandRow_CompareHighlightChanged
	lsr.w	#$03,d1
	and.w	#$0003,d1
	move.w	d1,d0
	swap	d1
	move.l	$0046(a5),a0
	cmp.b	$00(a0,d0.w),d1
	bcs.s	PartyCommandRow_PackHighlightIndex
	add.w	#$0100,d0
PartyCommandRow_PackHighlightIndex:		; Memory Address ($4C7E) and binary offset [$48FA]
	ror.w	#$08,d0
PartyCommandRow_CompareHighlightChanged:		; Memory Address ($4C80) and binary offset [$48FC]
	cmp.w	$0040(a5),d0
	bne.s	PartyCommandRow_SetHighlightAndRedraw
	rts		

PartyCommandRow_SetHighlightAndRedraw:		; Memory Address ($4C88) and binary offset [$4904]
	move.w	d0,$0040(a5)
	bra		Draw_PartyCommandMenu

Scan_PlayerInterfaceActions:		; Memory Address ($5014) and binary offset [$4C90]
	; Scans interface state and resolves direct or pending player actions.
	move.w	#$FFFF,$000C(a5)
	move.w	$0022(a5),$0024(a5)
	btst	#$06,$0018(a5)
	bne.s	Return_PartyCommandRowIdle
	tst.b	$003D(a5)
	bmi.s	DetectStairsCell_RepositionPartyLeader
	move.b	#$FF,$003D(a5)
	bra.s	Validate_CommsTargetThenDispatchPlayerAction

DetectStairsCell_RepositionPartyLeader:		; Memory Address ($4CB2) and binary offset [$492E]
	moveq	#$05,d1
	bsr		Find_HighestRankedPartyMemberByCategory
	tst.b	d3
	bpl.s	Validate_CommsTargetThenDispatchPlayerAction
	bsr		PlayerPositionToMapOffset
	move.w	$00(a6,d0.w),d1
	and.w	#Dungeon_CellTypeMask,d1											;Retains the three-bit cell type while ignoring map-cell flags.
	cmpi.w	#MapCell_FloorFeatureType,d1										;Selects floor-feature cells before testing the pit subtype.
	bne.s	Validate_CommsTargetThenDispatchPlayerAction
	move.b	$00(a6,d0.w),d1
	and.w	#FloorFeature_SubtypeMask,d1										;Extracts the floor feature independently of the ceiling-hole flag.
	subq.w	#$01,d1
	bne.s	Validate_CommsTargetThenDispatchPlayerAction
	bclr	#MapCell_OccupiedBit,$01(a6,d0.w)									;Map-cell occupied flag updated when a player changes floor.
	move.w	PlayerData_Floor(a5),d2												;Player record word selecting the active floor, not a map-cell offset.
	move.w	d2,d1
	subq.w	#$01,d1
	move.w	d1,PlayerData_Floor(a5)												;Player record word selecting the active floor, not a map-cell offset.
	bsr		Compute_StairAlignedDestination										;Keeps world X/Y unchanged while falling one floor; the lower cell is not required to carry a ceiling-hole flag.
	move.l	d7,$001C(a5)
	bsr		Select_ActivePlayerFloorMap
	bsr		PlayerPositionToMapOffset
	bset	#MapCell_OccupiedBit,$01(a6,d0.w)									;Map-cell occupied flag updated when a player changes floor.
	move.b	#$02,$003D(a5)
Validate_CommsTargetThenDispatchPlayerAction:		; Memory Address ($4D08) and binary offset [$4984]
	; Cancels an invalid communications target when necessary, then dispatches the
	; active player's pending interface action.
	cmp.w	#$0008,$0042(a5)
	bne.s	DispatchPanelMode_PendingAction
	bsr		Interface_CheckSelectedCellInteraction
	bcs.s	DispatchPanelMode_PendingAction
	bsr		Reset_PartyCommandStateAndRedrawMenu
DispatchPanelMode_PendingAction:		; Memory Address ($4D1A) and binary offset [$4996]
	move.b	$0014(a5),d0
	beq.s	Consume_PlayerPendingAction
	cmpi.b	#$01,d0
	beq.s	PendingMode1_RestoreNormalView
	cmpi.b	#$02,d0
	beq		FairyShop_DispatchByState
	bra		Resolve_PlayerContextAction

Consume_PlayerPendingAction:		; Memory Address ($50B6) and binary offset [$4D32]
	; Copies PlayerX_Data+$56 into PlayerX_Data+$0C, then clears the pending byte.
	moveq	#$00,d0
	move.b	PlayerData_PendingAction(a5),d0										;Offset read when transferring a pending action into the active command.
	beq.s	PendingAction_RoutePointerX
	move.w	d0,PlayerData_ActionCommand(a5)										;Offset of the active per-player interface command.
	clr.b	$0056(a5)
	cmp.w	#$0004,$0014(a5)
	bne.s	PendingAction_RoutePointerX
	bsr		Click_CloseCurrentPage
PendingAction_RoutePointerX:		; Memory Address ($4D4E) and binary offset [$49CA]
	cmp.w	#$005E,$0002(a5)
	bcs		PartyCommandRow_DispatchByPageState
	moveq	#-$01,d0
	tst.w	$0040(a5)
	bpl		PartyCommandRow_SetHighlightAndRedraw
	bclr	#$07,$0001(a5)
	beq.s	PlayerInterfaceFlag_EarlyReturn
	moveq	#$00,d0
	move.b	$0015(a5),d0
	asl.w	#$02,d0
	move.l	MainInterfacePanelModeJumpTable(pc,d0.w),a0
	jmp		(a0)

MainInterfacePanelModeJumpTable:		; Memory Address ($4D78) and binary offset [$49F4]
	; Five-entry dispatch table indexed by the active main-interface panel mode.
	dc.l	Begin_HitTestMainInterfaceActions	;00004DAA
	dc.l	Click_CloseCurrentPage	;000057A4
	dc.l	Resolve_PlayerContextAction	;00004DEA
	dc.l	Resolve_SpellCastingGridClick	;00005628
	dc.l	Click_CloseCurrentPage	;000057A4

PendingMode1_RestoreNormalView:		; Memory Address ($4D8C) and binary offset [$4A08]
	bclr	#$07,$0001(a5)
	beq.s	PlayerInterfaceFlag_EarlyReturn
	clr.b	$0014(a5)
	move.b	#$FF,$0053(a5)
	lea		Notice_View_NormalRestored.w,a6										;Short Absolute converted to symbol!
	jmp		Print_timed_message.l

PlayerInterfaceFlag_EarlyReturn:		; Memory Address ($4DA8) and binary offset [$4A24]
	rts		

Begin_HitTestMainInterfaceActions:		; Memory Address ($4DAA) and binary offset [$4A26]
	; Selects the 17-record main hitbox table before entering the shared hit
	; tester.
	lea		Interface_Hitboxes_Main.l,a6
	moveq	#$00,d0
	moveq	#$11,d2																;Sets the exclusive upper bound for the 17-record main player-interface hitbox scan, covering action IDs $00-$10.
HitTest_PlayerInterfaceActions:		; Memory Address ($5138) and binary offset [$4DB4]
	; Tests pointer coordinates against interface rectangles and writes the
	; resulting action directly to PlayerX_Data+$0C.
	move.l	$0002(a5),d1
	sub.w	$0008(a5),d1														;Subtracts the active player's horizontal interface offset before comparing the pointer X coordinate with a hitbox.
HitTest_CompareYRange:		; Memory Address ($4DBC) and binary offset [$4A38]
	cmp.w	$0004(a6),d1
	bcs.s	HitTest_AdvanceToNextHitbox
	cmp.w	$0006(a6),d1
	beq.s	HitTest_CompareXRange
	bcc.s	HitTest_AdvanceToNextHitbox
HitTest_CompareXRange:		; Memory Address ($4DCA) and binary offset [$4A46]
	swap	d1
	cmp.w	(a6),d1
	bcs.s	HitTest_RestoreYWord
	cmp.w	$0002(a6),d1
	beq.s	Store_HitTestActionCommand
	bcc.s	HitTest_RestoreYWord
Store_HitTestActionCommand:		; Memory Address ($515C) and binary offset [$4DD8]
	; Stores the action number selected by the interface hit test.
	move.w	d0,$000C(a5)														;Stores the zero-based interface action selected by the first matching rectangle in PlayerX_Data.
	rts		

HitTest_RestoreYWord:		; Memory Address ($4DDE) and binary offset [$4A5A]
	swap	d1
HitTest_AdvanceToNextHitbox:		; Memory Address ($4DE0) and binary offset [$4A5C]
	addq.w	#$08,a6																;Advances to the next eight-byte interface hitbox record after a failed rectangle comparison.
	addq.w	#$01,d0
	cmp.w	d2,d0
	bcs.s	HitTest_CompareYRange
	rts		

Resolve_PlayerContextAction:		; Memory Address ($516E) and binary offset [$4DEA]
	; Resolves context-dependent actions and may invoke the display-action hit-test
	; routine.
	moveq	#$00,d0
	move.b	$0014(a5),d0
	bne.s	StoreContextAction_Return
	moveq	#-$01,d2
	bsr		HitTest_SpellBookControls
	bmi.s	ResolvePlayerContext_CheckCastPowerRegion
	move.w	#$0002,$0014(a5)
	move.w	$000C(a5),d0
	add.w	#$0011,d0
	move.b	d0,$0014(a5)
StoreContextAction_Return:		; Memory Address ($4E0C) and binary offset [$4A88]
	move.w	d0,$000C(a5)
	rts		

ResolvePlayerContext_CheckCastPowerRegion:		; Memory Address ($4E12) and binary offset [$4A8E]
	bsr		HitTest_DisplayAction
	tst.w	$000C(a5)
	bpl.s	ResolveContextAction_NoMatchReturn
	bsr		Load_CurrentChampionStatRecord
	tst.b	$0013(a4)
	bmi.s	ResolveContextAction_NoMatchReturn
	cmpi.w	#$0048,d1
	bcs.s	ResolveContextAction_NoMatchReturn
	cmpi.w	#$0058,d1
	bcc.s	ResolveContextAction_NoMatchReturn
	swap	d1
	cmpi.w	#$00E0,d1
	bcs.s	ResolveContextAction_NoMatchReturn
	cmpi.w	#$00F0,d1
	bcs.s	SetAction_CastPowerDisplayHit
	cmpi.w	#$0132,d1
	bcs.s	CastPowerControls_CheckArrowBands
SetAction_CastPowerDisplayHit:		; Memory Address ($4E46) and binary offset [$4AC2]
	move.w	#$0015,$000C(a5)
ResolveContextAction_NoMatchReturn:		; Memory Address ($4E4C) and binary offset [$4AC8]
	rts		

CastPowerControls_CheckArrowBands:		; Memory Address ($4E4E) and binary offset [$4ACA]
	swap	d1
	cmpi.w	#$0050,d1
	bcs.s	ResolveContextAction_NoMatchReturn
	swap	d1
	cmpi.w	#$0128,d1
	bcc.s	DecrementCastPower_DownArrowHit
	cmpi.w	#$011A,d1
	bcc.s	ResolveContextAction_NoMatchReturn
	cmpi.w	#$0110,d1
	bcs.s	ResolveContextAction_NoMatchReturn
	addq.b	#$01,$0014(a4)
	bra		Refresh_SpellCastCostDisplay

DecrementCastPower_DownArrowHit:		; Memory Address ($4E72) and binary offset [$4AEE]
	subq.b	#$01,$0014(a4)
	bra		Refresh_SpellCastCostDisplay

Click_LaunchSpellFromBook:		; Memory Address ($4E7A) and binary offset [$4AF6]
	bsr.s	Cast_SelectedChampionSpell
	bne.s	AfterCastAttempt_SetContextActionMode
	bsr		Draw_SelectedSpellDetails
	bsr		Draw_SpellBookPageSpread
AfterCastAttempt_SetContextActionMode:		; Memory Address ($4E86) and binary offset [$4B02]
	move.w	#$0002,$0014(a5)
CastSpell_EarlyReturn:		; Memory Address ($4E8C) and binary offset [$4B08]
	rts		

Cast_SelectedChampionSpell:		; Memory Address ($5212) and binary offset [$4E8E]
	; Validates and charges the selected champion spell, performs its cast check,
	; dispatches the spell handler, records practice, and reports failure.
	bsr		Load_CurrentChampionStatRecord
	clr.w	SpellEntity_PlacementConflictFlag.l
	move.b	$0007(a5),SpellEntity_CasterIndex.l
CastSpell_ValidateSelection:		; Memory Address ($5224) and binary offset [$4EA0]
	; Rejects an empty spell selection and closes communication mode before every
	; spell except Beguile.
	move.b	ChampionStat_SpellToCast(a4),d0										;Loads the selected zero-based spell index; $FF means that no spell is queued.
	bmi.s	CastSpell_EarlyReturn
	subq.b	#$03,d0																;Tests spell index 3, Beguile, which is allowed to preserve communication mode.
	beq.s	CastSpell_ApplyVitalityCost
	cmp.w	#$0008,$0042(a5)
	bne.s	CastSpell_ApplyVitalityCost
	movem.l	d0-d7/a0-a6,-(sp)
	bsr		Reset_PartyCommandStateAndRedrawMenu								;Closes the current interface mode before casting any spell other than Beguile.
	movem.l	(sp)+,d0-d7/a0-a6
CastSpell_ApplyVitalityCost:		; Memory Address ($5242) and binary offset [$4EBE]
	; Removes four vitality for the cast attempt and clamps the champion's current
	; vitality to zero.
	subq.b	#SpellCasting_VitalityCost,ChampionStat_VitalityCurrent(a4)			;Vitality removed when a champion launches a spell.
	bcc.s	CastSpell_ApplySpellPointCost
	clr.b	ChampionStat_VitalityCurrent(a4)
CastSpell_ApplySpellPointCost:		; Memory Address ($524C) and binary offset [$4EC8]
	; Applies action state, calculates spell-point cost, consumes ring-assisted
	; casts, and rejects insufficient spell points.
	move.b	#CharacterActionState_ChampionSpellStart,ChampionStat_ActionState(a4)	;Applies the champion action cooldown as soon as the cast attempt is committed.
	clr.b	ChampionStat_WornSpell(a4)											;Removes the champion's currently worn spell before resolving the new cast.
	bsr		Calculate_SpellPointCost											;Calculates the spell-point cost, including ring-based free casting and the champion's power setting.
	move.b	ChampionStat_SpellPointsCurrent(a4),d1
	sub.b	d0,d1																;Subtracts the calculated cost from current spell points; borrow rejects the cast.
	bcs		CastSpell_RejectInsufficientSpellPoints
	move.b	d1,ChampionStat_SpellPointsCurrent(a4)
	tst.b	d0
	bne.s	CastSpell_CalculateQualityAndCooldown
	move.b	ChampionStat_SpellToCast(a4),d0
	bsr		Character_GetClassIndex
	lea		RingUses.l,a0
	subq.b	#$01,$00(a0,d0.w)													;Consumes one use from the matching magic ring when it reduced the spell-point cost to zero.
CastSpell_CalculateQualityAndCooldown:		; Memory Address ($527E) and binary offset [$4EFA]
	; Calculates signed casting quality before adding this attempt's fatigue, then
	; accumulates the selected spell's cooldown up to 100.
	bsr		Draw_MainPlayerInterface
	bsr		Calculate_SpellCastingQuality										;Builds signed casting quality from practice, profession, level, power, equipment and spell difficulty.
	moveq	#$00,d0
	move.b	ChampionStat_SpellToCast(a4),d0
	lea		SpellCost_DataTable.l,a6
	move.b	$00(a6,d0.w),d1
	addq.b	#SpellCasting_CooldownBaseIncrement,d1								;Adds the fixed cooldown increment after loading the selected spell cost value.
	add.b	ChampionStat_SpellCooldown(a4),d1									;Accumulates the selected spell's base delay onto the champion's current spell cooldown.
	cmpi.b	#SpellCasting_CooldownMaximum,d1									;Clamps accumulated spell cooldown to 100.
	bcs.s	CastSpell_SelectHandler
	moveq	#$64,d1
CastSpell_SelectHandler:		; Memory Address ($52A4) and binary offset [$4F20]
	; Loads the selected spell routine from the thirty-two-entry relative-offset
	; dispatch table and performs the final cast roll.
	move.b	d1,ChampionStat_SpellCooldown(a4)
	add.w	d0,d0
	lea		Spells_01_Armour.l,a0
	lea		Spells_LookupTable.l,a6
	add.w	$00(a6,d0.w),a0														;Selects the spell handler from the 32-entry relative-offset table.
	bsr		CastSpell_QualityRoll												;Rolls three six-sided random values plus the routine's base of three for the final cast check.
	add.b	d0,d7																;Adds the 3d6 roll to signed casting quality; a negative result produces SPELL FAILED.
	bmi.s	CastSpell_SelectFailedNotice
	move.w	d7,-(sp)
	bsr		PlayerPositionToMapOffset
	move.w	(sp)+,d7
	move.w	$00(a6,d0.w),d1
	and.w	#$0007,d1
	subq.w	#$06,d1
	bne.s	CastSpell_ExecuteHandler
	move.b	$00(a6,d0.w),d1
	and.w	#$0003,d1
	beq		CastSpell_SelectFizzledNotice
CastSpell_ExecuteHandler:		; Memory Address ($52E2) and binary offset [$4F5E]
	; Executes the selected spell handler and refreshes champion or player state
	; after the effect is applied.
	move.l	a4,-(sp)
	jsr		(a0)																;Executes the selected spell handler with D7 carrying the successful cast's effective power.
	moveq	#$00,d0
	move.b	SpellEntity_CasterIndex.l,d0
	bsr		Find_ChampionInPlayerSlots
	tst.w	d1
	bmi.s	CastSpell_RecordPractice
	beq.s	CastSpell_RefreshChampionStatus
	move.w	d1,d7
	tst.w	$0042(a5)
	bpl.s	CastSpell_RecordPractice
	bsr		Refresh_PartyShieldSlotIfDirty
	bsr		Draw_PartyShieldChainStrip
	bra.s	CastSpell_RecordPractice

CastSpell_RefreshChampionStatus:		; Memory Address ($530A) and binary offset [$4F86]
	; Refreshes the selected champion's displayed status when the post-spell party
	; lookup returns the active slot.
	move.w	PlayerData_CurrentChampionNumber(a5),d7
	bsr		Draw_MainChampionAvatarInnerFrame
CastSpell_RecordPractice:		; Memory Address ($5312) and binary offset [$4F8E]
	; Increments the casting champion's per-spell practice counter with saturation
	; at $FF.
	move.l	(sp)+,a4
	move.l	#adrL_007E22,a0
	add.l	a4,a0
	moveq	#$00,d0
	move.b	ChampionStat_SpellToCast(a4),d0
	addq.b	#$01,$00(a0,d0.w)													;Increments this champion's per-spell practice counter after the handler runs.
	bcc.s	CastSpell_Complete
	subq.b	#$01,$00(a0,d0.w)													;Restores a saturated practice counter to $FF after byte overflow.
CastSpell_Complete:		; Memory Address ($532C) and binary offset [$4FA8]
	; Selects the empty notice after a successful spell before common cast
	; finalisation.
	lea		NullString.l,a6
	bra.s	CastSpell_Finalize

CastSpell_SelectFailedNotice:		; Memory Address ($5334) and binary offset [$4FB0]
	; Selects SPELL FAILED and its message-state value after a negative
	; casting-quality result.
	lea		Notice_SpellFailed.l,a6
	move.w	#$0004,CurrentTextInk.l
CastSpell_Finalize:		; Memory Address ($5342) and binary offset [$4FBE]
	; Clears the queued spell and displays the selected result notice when message
	; output is enabled.
	move.b	#$FF,ChampionStat_SpellToCast(a4)									;Clears the queued spell index when the cast succeeds, fails or fizzles.
	tst.b	SpellEntity_BackgroundOriginFlag.l
	bne.s	Return_CastSpell
	jsr		LowerText.l
	moveq	#$00,d0
Return_CastSpell:		; Memory Address ($5358) and binary offset [$4FD4]
	; Shared return from spell-cast success and notice handling.
	rts		

CastSpell_RejectInsufficientSpellPoints:		; Memory Address ($535A) and binary offset [$4FD6]
	; Displays the cost-too-high notice and returns one when the champion cannot
	; pay the spell-point cost.
	tst.b	SpellEntity_BackgroundOriginFlag.l
	bne.s	Return_CastSpell
	lea		Msg_CostTooHigh.l,a6
	jsr		LowerText.l
	moveq	#$01,d0
	rts		

CastSpell_SelectFizzledNotice:		; Memory Address ($5372) and binary offset [$4FEE]
	; Selects SPELL FIZZLED and its message-state value when the target cell
	; suppresses the spell.
	lea		Notice_SpellFizzle.l,a6
	move.w	#$0008,CurrentTextInk.l
	bra.s	CastSpell_Finalize

Notice_SpellFizzle:
	dc.b	'SPELL FIZZLED'
	dc.b	$FF	;FF
Spells_LookupTable:		; Memory Address ($500C) and binary offset [$4C88]
	dc.w	Spells_01_Armour-Spells_01_Armour	;0000
	dc.w	Spells_02_Terror-Spells_01_Armour	;0022
	dc.w	Spells_03_Vitalise-Spells_01_Armour	;002A
	dc.w	Spells_04_Beguile-Spells_01_Armour	;0032
	dc.w	Spells_05_Deflect-Spells_01_Armour	;0062
	dc.w	Spells_06_Magelock-Spells_01_Armour	;0066
	dc.w	Spells_07_Conceal-Spells_01_Armour	;00DA
	dc.w	Spells_08_Warpower-Spells_01_Armour	;00F6
	dc.w	Spells_09_Missle-Spells_01_Armour	;00FC
	dc.w	Spells_10_Vanish-Spells_01_Armour	;0106
	dc.w	Spells_11_Paralyze-Spells_01_Armour	;010C
	dc.w	Spells_12_Alchemy-Spells_01_Armour	;0114
	dc.w	Spells_13_Confuse-Spells_01_Armour	;0174
	dc.w	Spells_14_Levitate-Spells_01_Armour	;017C
	dc.w	Spells_15_Antimage-Spells_01_Armour	;0182
	dc.w	Spells_16_Recharge-Spells_01_Armour	;0188
	dc.w	Spells_17_Trueview-Spells_01_Armour	;01CA
	dc.w	Spells_18_Renew-Spells_01_Armour	;01D0
	dc.w	Spells_19_Vivify-Spells_01_Armour	;0222
	dc.w	Spells_20_Dispell-Spells_01_Armour	;0258
	dc.w	Spells_21_Firepath-Spells_01_Armour	;0298
	dc.w	Spells_22_Illusion-Spells_01_Armour	;02A0
	dc.w	Spells_23_Compass-Spells_01_Armour	;02A6
	dc.w	Spells_24_Spelltap-Spells_01_Armour	;02AC
	dc.w	Spells_25_Disrupt-Spells_01_Armour	;02B2
	dc.w	Spells_26_Fireball-Spells_01_Armour	;02C0
	dc.w	Spells_27_Wychwind-Spells_01_Armour	;03C0
	dc.w	Spells_28_ArcBolt-Spells_01_Armour	;0412
	dc.w	Spells_29_Formwall-Spells_01_Armour	;041A
	dc.w	Spells_30_Summon-Spells_01_Armour	;048A
	dc.w	Spells_31_Blaze-Spells_01_Armour	;0490
	dc.w	Spells_32_Mindrock-Spells_01_Armour	;049E
Notice_SpellFailed:
	dc.b	'SPELL FAILED'
	dc.b	$FF	;FF
	dc.b	$00	;00
SpellEntity_PlacementConflictFlag:		; Memory Address ($53DE) and binary offset [$505A]
	; Working flag set when spell-entity placement crosses or conflicts with the
	; resolved map destination.
	ds.b	$1
SpellEntity_BackgroundOriginFlag:		; Memory Address ($505B) and binary offset [$4CD7]
	; Low byte of the spell-creation context word; copied into live entity byte $03
	; and used to suppress interactive casting notices.
	ds.b	$1
Spells_01_Armour:		; Memory Address ($505C) and binary offset [$4CD8]
	moveq	#WornSpell_Armour,d4
	addq.w	#$02,d7
StoreWornSpell_ClampPower:		; Memory Address ($53E4) and binary offset [$5060]
	; Clamps worn-spell power to sixty-three before packing it with the low
	; three-bit spell type.
	cmpi.w	#$0040,d7
	bcs.s	StoreWornSpell
	moveq	#WornSpell_PowerMaximum,d7
StoreWornSpell:		; Memory Address ($53EC) and binary offset [$5068]
	; Packs worn-spell power and type into the champion record and requests a
	; status refresh.
	asl.w	#WornSpell_PowerShift,d7
	and.w	#~WornSpell_TypeMask&$FF,d7											;Keeps the packed power bits while clearing the low three bits reserved for worn-spell type.
	add.b	d4,d7																;Packs the selected worn-spell type into the low three bits of the scaled power.
	move.b	d7,$0011(a4)														;Stores the packed worn-spell type and power on the casting champion.
	move.b	#$02,WornSpellDecayGraceCountdown.l
	rts		

Spells_02_Terror:		; Memory Address ($507E) and binary offset [$4CFA]
	move.w	#AirbourneSpell_Terror,d4
	bra		SpellEntity_SetPowerFlag

Spells_03_Vitalise:		; Memory Address ($5086) and binary offset [$4D02]
	moveq	#$07,d4
	lsr.w	#$02,d7
	bra		RestorePartyStat_CalculateAmount

Spells_04_Beguile:		; Memory Address ($508E) and binary offset [$4D0A]
	; While communication is active, adds floor(spell power / 4) + 1 to both
	; attitude and patience.
	cmp.w	#InterfaceMode_Communication,$0042(a5)								;Interface mode value active while communicating with another character.
	bne.s	Return_Beguile
	lsr.b	#WornSpell_Beguile_PowerShift,d7									;Right shift converting Beguile spell power into its communication bonus.
	addq.w	#WornSpell_Beguile_BaseBonus,d7										;Minimum attitude and patience bonus supplied by a successful Beguile spell.
	bsr		Comms_GetState
	move.w	d7,d0
	add.b	CommsState_AttitudeOffset(a4),d7									;Offset of mutable communication attitude or rapport.
	move.b	d7,CommsState_AttitudeOffset(a4)									;Offset of mutable communication attitude or rapport.
	add.b	CommsState_PatienceOffset(a4),d0									;Offset of communication patience or remaining engagement.
	move.b	d0,CommsState_PatienceOffset(a4)									;Offset of communication patience or remaining engagement.
	bsr		ForwardCellToMapOffset
	move.w	#AirbourneSpell_Beguile,d7
	bra		Queue_MapCellEffect

Return_Beguile:		; Memory Address ($5440) and binary offset [$50BC]
	; Returns without changing communication state when Beguile is cast outside
	; communication mode.
	rts		

Spells_05_Deflect:		; Memory Address ($50BE) and binary offset [$4D3A]
	moveq	#WornSpell_Deflect,d4
	bra.s	StoreWornSpell_ClampPower

Spells_06_Magelock:		; Memory Address ($50C2) and binary offset [$4D3E]
	; Validates the facing wooden edge and the opposite edge of the forward cell
	; before placing Magelock, rejecting solid edges and incompatible keyed-door
	; configurations.
	bsr		PlayerPositionToMapOffset
	move.b	$01(a6,d0.w),d1
	and.w	#$0007,d1
	subq.w	#$02,d1
	bne.s	Magelock_CheckTargetCell
	move.w	$0020(a5),d2
	add.w	d2,d2
	addq.w	#$01,d2
	btst	d2,$00(a6,d0.w)
	bne.s	Magelock_ToggleLock
	subq.w	#$01,d2
	btst	d2,$00(a6,d0.w)
	bne.s	Return_Magelock
Magelock_CheckTargetCell:		; Memory Address ($546C) and binary offset [$50E8]
	; Checks the cell in front of the party and validates a door side before
	; changing its Magelock flag.
	bsr		ForwardCellToMapOffset
	cmp.w	CurrentFloorHeight.l,d7
	bcc.s	Return_Magelock
	swap	d7
	cmp.w	CurrentFloorWidth.l,d7
	bcc.s	Return_Magelock
	move.b	$01(a6,d0.w),d1
	and.w	#$0007,d1
	cmpi.w	#$0002,d1
	beq.s	Magelock_CheckOppositeDoorSide
	cmpi.w	#$0005,d1
	bne.s	Return_Magelock
	move.b	$00(a6,d0.w),d1
	lsr.b	#$04,d1
	beq.s	Magelock_ToggleLock
	rts		

Magelock_CheckOppositeDoorSide:		; Memory Address ($54A0) and binary offset [$511C]
	; Checks the opposite side of a door cell against the party's facing direction.
	move.w	$0020(a5),d2
	eor.w	#$0002,d2
	add.w	d2,d2
	addq.w	#$01,d2
	btst	d2,$00(a6,d0.w)
	beq.s	Return_Magelock
Magelock_ToggleLock:		; Memory Address ($54B2) and binary offset [$512E]
	; Toggles bit four of the validated door cell's state byte.
	bchg	#MapCell_MagelockedBit,$01(a6,d0.w)									;Toggles the lock flag only after the target is confirmed as the relevant side of a door cell.
Return_Magelock:		; Memory Address ($54B8) and binary offset [$5134]
	; Shared return for rejected and completed Magelock operations.
	rts		

Spells_07_Conceal:		; Memory Address ($5136) and binary offset [$4DB2]
	bsr		ForwardCellToMapOffset
	cmp.w	CurrentFloorHeight.l,d7
	bcc.s	Conceal_Return
	cmp.w	CurrentFloorWidth.l,d7
	bcc.s	Conceal_Return
	bset	#MapCell_ConcealedBit,$01(a6,d0.w)
Conceal_Return:		; Memory Address ($5150) and binary offset [$4DCC]
	rts		

Spells_08_Warpower:		; Memory Address ($5152) and binary offset [$4DCE]
	moveq	#WornSpell_Warpower,d4												;Low three-bit worn-spell type used for Warpower.
	bra		StoreWornSpell_ClampPower

Spells_09_Missle:		; Memory Address ($5158) and binary offset [$4DD4]
	move.w	#AirbourneSpell_Missile,d4
	lsr.w	#$01,d7
	bra		SpellEntity_PrepareDirection

Spells_10_Vanish:		; Memory Address ($5162) and binary offset [$4DDE]
	moveq	#WornSpell_Vanish,d4
	bra		StoreWornSpell_ClampPower

Spells_11_Paralyze:		; Memory Address ($5168) and binary offset [$4DE4]
	move.w	#AirbourneSpell_Paralyze,d4
	bra		SpellEntity_SetPowerFlag

Spells_12_Alchemy:		; Memory Address ($5170) and binary offset [$4DEC]
	moveq	#$00,d0
	move.b	SpellEntity_CasterIndex.l,d0
	asl.w	#$04,d0
	lea		Character_Pockets_DataTable.l,a0
	add.w	d0,a0
	moveq	#$00,d0
	move.b	(a0),d1
	cmpi.b	#Object_Armour_First,d1												;Only objects from the armour/weapon range can be converted into coinage.
	bcs.s	Alchemy_CheckRightHand
	cmpi.b	#Object_PowerStaff,d1												;Power Staff and later object codes are excluded from Alchemy conversion.
	bcs.s	Alchemy_ConvertHeldItemToCoinage
Alchemy_CheckRightHand:		; Memory Address ($5516) and binary offset [$5192]
	; Checks the right hand when the left-hand object is outside Alchemy's
	; convertible range.
	move.b	$0001(a0),d1
	moveq	#$01,d0
	cmpi.b	#Object_Armour_First,d1												;Only objects from the armour/weapon range can be converted into coinage.
	bcs.s	Return_Alchemy
	cmpi.b	#Object_PowerStaff,d1												;Power Staff and later object codes are excluded from Alchemy conversion.
	bcc.s	Return_Alchemy
Alchemy_ConvertHeldItemToCoinage:		; Memory Address ($5528) and binary offset [$51A4]
	; Adds five plus spell power to coinage, clamps the quantity to ninety-nine,
	; and prepares the hand conversion.
	addq.w	#Alchemy_BaseCoinageGain,d7											;Adds five coinage before adding the existing counted-coin quantity.
	add.b	$000C(a0),d7
	cmpi.b	#$64,d7
	bcs.s	Alchemy_StoreCoinage
	moveq	#Object_StackMaximum,d7
Alchemy_StoreCoinage:		; Memory Address ($5536) and binary offset [$51B2]
	; Stores the updated coinage quantity and removes duplicate coinage object
	; slots.
	move.b	d7,$000C(a0)
	moveq	#$0B,d2
Alchemy_RemoveDuplicateCoinageLoop:		; Memory Address ($553C) and binary offset [$51B8]
	; Scans all twelve ordinary pockets and clears existing coinage object slots.
	cmp.b	#$01,$00(a0,d2.w)
	bne.s	Alchemy_CoinageLoop_Decrement
	clr.b	$00(a0,d2.w)
Alchemy_CoinageLoop_Decrement:		; Memory Address ($51C4) and binary offset [$4E40]
	dbra	d2,Alchemy_RemoveDuplicateCoinageLoop
	move.b	#Object_Coinage,$00(a0,d0.w)										;Replaces the converted hand object with the single authoritative coinage slot.
Return_Alchemy:		; Memory Address ($5552) and binary offset [$51CE]
	; Returns after Alchemy conversion or when neither hand contains an eligible
	; object.
	rts		

Spells_13_Confuse:		; Memory Address ($51D0) and binary offset [$4E4C]
	move.w	#AirbourneSpell_Confuse,d4
	bra		SpellEntity_SetPowerFlag

Spells_14_Levitate:		; Memory Address ($51D8) and binary offset [$4E54]
	moveq	#WornSpell_Levitate,d4
	bra		StoreWornSpell_ClampPower

Spells_15_Antimage:		; Memory Address ($51DE) and binary offset [$4E5A]
	moveq	#WornSpell_Antimage,d4
	bra		StoreWornSpell_ClampPower

Spells_16_Recharge:		; Memory Address ($51E4) and binary offset [$4E60]
	moveq	#$00,d0
	move.b	SpellEntity_CasterIndex.l,d0
	asl.w	#$04,d0
	lea		Character_Pockets_DataTable.l,a0
	add.w	d0,a0
	move.b	(a0),d0
	cmpi.b	#Object_MagicRings_First,d0
	bcs.s	Recharge_CheckRightHand
	cmpi.b	#Object_BookOfSkulls,d0
	bcs.s	Recharge_SelectedRing
Recharge_CheckRightHand:		; Memory Address ($5588) and binary offset [$5204]
	; Checks the right hand when the left hand does not contain one of the four
	; rechargeable magic rings.
	move.b	$0001(a0),d0
	cmpi.b	#Object_MagicRings_First,d0
	bcs.s	Return_Recharge
	cmpi.b	#Object_BookOfSkulls,d0
	bcc.s	Return_Recharge
Recharge_SelectedRing:		; Memory Address ($5598) and binary offset [$5214]
	; Maps the selected magic-ring object to RingUses and replaces its uses with
	; spell power divided by eight.
	sub.w	#Object_MagicRings_First,d0											;Converts magic-ring object codes $69-$6C into the four-entry ring-use index.
	lea		RingUses.l,a0
	lsr.w	#Recharge_PowerShift,d7												;Sets replacement ring uses to floor(effective spell power / 8).
	move.b	d7,$00(a0,d0.w)
Return_Recharge:		; Memory Address ($55A8) and binary offset [$5224]
	; Returns after Recharge or when neither hand contains a rechargeable ring.
	rts		

Spells_17_Trueview:		; Memory Address ($5226) and binary offset [$4EA2]
	moveq	#WornSpell_Trueview,d4
	bra		StoreWornSpell_ClampPower

Spells_18_Renew:		; Memory Address ($522C) and binary offset [$4EA8]
	move.w	d7,d4
	add.w	d7,d7
	add.w	d4,d7																;Forms three times the effective spell power before division by sixteen.
	lsr.w	#$04,d7
	moveq	#$05,d4
RestorePartyStat_CalculateAmount:		; Memory Address ($55BA) and binary offset [$5236]
	; Adds random variation to Vitalise or Renew's base amount and clamps the
	; restoration value to one byte.
	move.w	d7,d5
RestorePartyStat_RandomiseLoop:		; Memory Address ($55BC) and binary offset [$5238]
	; Accumulates the spell-power-controlled sequence of six-sided random values.
	bsr		RandomGen_SixSidedRoll
	add.w	d0,d5
	dbra	d7,RestorePartyStat_RandomiseLoop
	cmpi.w	#$0100,d5
	bcs.s	RestorePartyStat_BeginChampionLoop
	moveq	#-$01,d5
RestorePartyStat_BeginChampionLoop:		; Memory Address ($55CE) and binary offset [$524A]
	; Initialises the four-slot active-party scan for Vitalise and Renew.
	moveq	#$03,d1
RestorePartyStat_ChampionLoop:		; Memory Address ($55D0) and binary offset [$524C]
	; Applies the restoration to each occupied active-party slot and clamps current
	; stat to maximum.
	move.b	$18(a5,d1.w),d0
	and.w	#$00E0,d0
	bne.s	RestorePartyStat_NextChampion
	move.b	$18(a5,d1.w),d0
	bsr		Load_ChampionStatRecord
	move.b	$00(a4,d4.w),d0														;Loads each active champion's selected current stat: hit points for Renew or vitality for Vitalise.
	add.b	d5,d0
	bcc.s	RestorePartyStat_ClampOverflow
	moveq	#-$01,d0
RestorePartyStat_ClampOverflow:		; Memory Address ($55EC) and binary offset [$5268]
	; Converts byte overflow in the restored current stat to $FF before
	; maximum-stat clamping.
	cmp.b	$01(a4,d4.w),d0														;Clamps the restored current stat to its adjacent maximum-stat byte.
	bcs.s	RestorePartyStat_StoreCurrent
	move.b	$01(a4,d4.w),d0														;Loads the following maximum-statistic byte for the D4-selected current statistic.
RestorePartyStat_StoreCurrent:		; Memory Address ($55F6) and binary offset [$5272]
	; Stores the clamped current hit-point or vitality value for one active
	; champion.
	move.b	d0,$00(a4,d4.w)														;Stores the restored D4-selected current statistic.
RestorePartyStat_NextChampion:		; Memory Address ($55FA) and binary offset [$5276]
	; Advances the active-party restoration loop and refreshes the champion display
	; when complete.
	dbra	d1,RestorePartyStat_ChampionLoop
	bra		Draw_MainPlayerInterface

Spells_19_Vivify:		; Memory Address ($527E) and binary offset [$4EFA]
	bsr		PlayerPositionToMapOffset
	bsr		VivifyInternal_ReviveOwnPartyMembers
	bsr		Interface_CheckSelectedCellInteraction
	bcc.s	Vivify_ResolveTargetCell
	tst.b	d0
	bpl.s	Return_Vivify
	move.l	a5,-(sp)
	move.l	a1,a5
	bsr		PlayerPositionToMapOffset
	bsr		VivifyInternal_ReviveOwnPartyMembers
	move.l	(sp)+,a5
Return_Vivify:		; Memory Address ($5622) and binary offset [$529E]
	; Returns after Vivify has resolved its selected cell or linked player context.
	rts		

Vivify_ResolveTargetCell:		; Memory Address ($5624) and binary offset [$52A0]
	; Checks the target cell type and enters the shared Vivify-machine or
	; cell-resolution path when appropriate.
	bsr		ForwardCellToMapOffset
	move.b	$01(a6,d0.w),d1
	and.w	#$0007,d1
	subq.w	#$01,d1
	beq.s	Return_Vivify
	bra		VivifyExternal_SearchRevivalCell

Spells_20_Dispell:		; Memory Address ($52B4) and binary offset [$4F30]
	bsr		ForwardCellToMapOffset
	bclr	#MapCell_ConcealedBit,$01(a6,d0.w)									;Always removes Conceal from the target cell before considering linked feature removal.
	move.b	$01(a6,d0.w),d1
	not.b	d1
	and.w	#$0007,d1
	bne.s	Return_Dispel
	btst	#$00,$00(a6,d0.w)
	bne.s	Dispel_FindLinkedFeature
Dispel_ClearCellFeature:		; Memory Address ($5656) and binary offset [$52D2]
	; Clears the target cell's feature bits after any linked feature record has
	; been removed.
	and.w	#$00F8,$00(a6,d0.w)
Return_Dispel:		; Memory Address ($565C) and binary offset [$52D8]
	; Returns when Dispel has no linked target or after the target has been
	; cleared.
	rts		

Dispel_FindLinkedFeature:		; Memory Address ($565E) and binary offset [$52DA]
	; Initialises the scan for a four-byte linked feature record associated with
	; the target map cell.
	lea		LinkedMagicRecordList.l,a0
	moveq	#-$04,d1
Dispel_FindLinkedFeatureLoop:		; Memory Address ($5666) and binary offset [$52E2]
	; Scans linked feature records and removes the matching target record when
	; found.
	addq.w	#$04,d1
	cmp.w	-$0002(a0),d1
	bcc.s	Dispel_ClearCellFeature
	cmp.w	$02(a0,d1.w),d0
	bne.s	Dispel_FindLinkedFeatureLoop
	bra		Remove_LinkedMagicRecord

Spells_21_Firepath:		; Memory Address ($52F4) and binary offset [$4F70]
	move.w	#AirbourneSpell_Firepath,d4
	addq.w	#$02,d7
	bra.s	SpellEntity_SetPowerFlag

Spells_22_Illusion:		; Memory Address ($52FC) and binary offset [$4F78]
	moveq	#$65,d4
	bra		SpellEntity_PrepareDirection

Spells_23_Compass:		; Memory Address ($5302) and binary offset [$4F7E]
	moveq	#WornSpell_Compass,d4
	bra		StoreWornSpell_ClampPower

Spells_24_Spelltap:		; Memory Address ($5308) and binary offset [$4F84]
	move.w	#AirbourneSpell_Spelltap,d4
	bra.s	SpellEntity_SetPowerFlag

Spells_25_Disrupt:		; Memory Address ($530E) and binary offset [$4F8A]
	move.w	#AirbourneSpell_Disrupt,d4
	addq.w	#$05,d7
	add.w	d7,d7
SpellEntity_SetPowerFlag:		; Memory Address ($569A) and binary offset [$5316]
	; Sets the high spell-power flag used by Terror, Paralyze, Firepath, Spelltap,
	; and Disrupt before entity creation.
	bset	#$08,d7
	bra.s	SpellEntity_PrepareDirection

Spells_26_Fireball:		; Memory Address ($531C) and binary offset [$4F98]
	move.w	#AirbourneSpell_Fireball,d4
SpellEntity_ScalePowerThreeHalves:		; Memory Address ($56A4) and binary offset [$5320]
	; Scales Fireball and Arc Bolt effective power to three halves before creating
	; the live spell entity.
	move.w	d7,d3
	add.w	d7,d7
	add.w	d3,d7
	lsr.w	#$01,d7
SpellEntity_PrepareDirection:		; Memory Address ($56AC) and binary offset [$5328]
	; Packs the player's facing direction for the shared spell, Illusion, and
	; Summon entity creator.
	move.w	$0020(a5),d6
	swap	d6
	move.w	$0020(a5),d6
CreateSpellEntity:		; Memory Address ($56B6) and binary offset [$5332]
	; Creates an airborne spell, Illusion, or Summon entity at the resolved map
	; position.
	move.w	d7,d3
	move.l	$001C(a5),d7
	move.w	$0058(a5),d5
SpellEntity_CheckPlacement:		; Memory Address ($56C0) and binary offset [$533C]
	; Resolves the destination map cell and records whether placement crossed a map
	; boundary or conflict.
	move.w	d5,-(sp)
	bsr		Try_EnterMapCell
	bcc.s	SpellEntity_PlacementInsideMap
	move.w	(sp)+,d5
	move.b	#$FF,SpellEntity_PlacementConflictFlag.w							;Short Absolute converted to symbol!
	cmp.w	d0,d2
	bne.s	SpellEntity_MarkMapCell
	rts		

SpellEntity_PlacementInsideMap:		; Memory Address ($56D6) and binary offset [$5352]
	; Clears the placement-conflict flag when the destination lies inside the
	; current map.
	clr.b	SpellEntity_PlacementConflictFlag.w									;Short Absolute converted to symbol!
	move.w	(sp)+,d5
SpellEntity_MarkMapCell:		; Memory Address ($56DC) and binary offset [$5358]
	; Marks the destination cell as containing a live spell or summoned entity.
	bset	#MapCell_SpellEntityBit,$01(a6,d2.w)								;Marks the resolved destination cell before allocating the overloaded live-entity record.
SpellEntity_AllocateRecord:		; Memory Address ($56E2) and binary offset [$535E]
	; Allocates a sixteen-byte record in the overloaded live-monster workspace,
	; freeing one when the spell-entity limit is reached.
	lea		UnpackedMonsters.l,a4												;Uses the live-monster workspace for spell entities, Illusion and Summon.
	addq.w	#$01,-$0002(a4)
	move.w	-$0002(a4),d1
	cmpi.w	#$007D,d1
	bcs.s	SpellEntity_InitialiseRecord
	subq.w	#$01,-$0002(a4)
	bsr		Purge_TransientSummonsBeforeAllocation
	bra.s	SpellEntity_AllocateRecord

SpellEntity_InitialiseRecord:		; Memory Address ($5700) and binary offset [$537C]
	; Initialises position, facing, floor, caster, form, power, state, and team
	; fields for a new spell entity.
	asl.w	#ActorRecord_SizeShift,d1
	add.w	d1,a4
	move.b	d7,ActorRecord_YPosition(a4)
	swap	d7
	move.b	d7,ActorRecord_XPosition(a4)
	swap	d6
	move.b	d6,ActorRecord_RotationAndSpace(a4)
	move.b	d5,ActorRecord_Floor(a4)
	swap	d5
	move.b	SpellEntity_CasterIndex.l,SpellEntity_CasterIndexOffset(a4)
	move.b	d4,ActorRecord_Form(a4)												;Stores the spell/entity form code in the overloaded live-record form byte.
	move.b	SpellEntity_BackgroundOriginFlag.w,$0003(a4)						;Short Absolute converted to symbol!
	clr.w	ActorRecord_HitPoints(a4)
	clr.b	ActorRecord_ActionState(a4)
	move.b	#$03,ActorRecord_BehaviourType(a4)
	move.b	#MonsterRecord_NoTeamGroup,MonsterRecord_TeamGroupIndex(a4)
	tst.b	d4
	bmi.s	SpellEntity_InitialiseAirbourne
	move.b	#ActorForm_MonsterRendererFirst,ActorRecord_Form(a4)
	cmpi.b	#$65,d4
	beq.s	SpellEntity_InitialiseIllusion
	moveq	#$06,d4
	add.w	d3,d4
	asl.w	#$03,d4
	move.w	d4,$0008(a4)
SpellEntity_InitialiseIllusion:		; Memory Address ($575A) and binary offset [$53D6]
	; Applies Illusion's special power flag before common monster-like entity
	; initialisation.
	lsr.w	#$02,d3
	cmpi.b	#$65,d4
	bne.s	SpellEntity_InitialiseMonsterLike
	bset	#$07,d3
SpellEntity_InitialiseMonsterLike:		; Memory Address ($5766) and binary offset [$53E2]
	; Initialises the level and state fields shared by Illusion and Summon
	; entities.
	addq.w	#$02,d3
	move.b	d3,SpellEntity_PowerOffset(a4)
	and.w	#$007F,d3
	move.b	d3,MonsterRecord_EffectiveLevel(a4)
	move.b	#$80,MonsterRecord_ActionCycleTimer(a4)
	move.b	#CharacterActionState_MonsterSpellStart,ActorRecord_ActionState(a4)
	bra.s	SpellEntity_FinalizeCreation

SpellEntity_InitialiseAirbourne:		; Memory Address ($5782) and binary offset [$53FE]
	; Initialises airborne-spell power fields and transfers the high spell-power
	; flag into the record.
	move.b	d3,SpellEntity_PowerOffset(a4)
	clr.b	$0007(a4)
	btst	#$08,d3
	beq.s	SpellEntity_FinalizeCreation
	bset	#$07,$0006(a4)
SpellEntity_FinalizeCreation:		; Memory Address ($5796) and binary offset [$5412]
	; Runs the placement-conflict follow-up when required and otherwise returns
	; from entity creation.
	tst.b	SpellEntity_PlacementConflictFlag.w									;Short Absolute converted to symbol!
	bne		Gate_AirborneEntityFormRange
	rts		

Spells_27_Wychwind:		; Memory Address ($541C) and binary offset [$5098]
	add.w	#Wychwind_PowerBonus,d7
	add.w	d7,d7
	moveq	#Wychwind_ProjectileCount-1,d5										;Runs once for each of the eight surrounding projectile directions.
.Wychwind_SpawnProjectileLoop:		; Memory Address ($57A8) and binary offset [$5424]
	; Creates one Wychwind projectile for each of the eight directions around the
	; caster.
	movem.w	d5/d7,-(sp)
	move.w	#AirbourneSpell_Wychwind,d4
	move.w	$0020(a5),d6
	add.b	.Wychwind_DirectionAdjustments(pc,d5.w),d6							;Rotates the projectile's facing with the mechanic-owned eight-byte direction-adjustment table.
	and.w	#$0003,d6
	swap	d6
	move.w	d5,d6
	cmpi.w	#$0004,d6
	bcc.s	.Wychwind_RotateSecondDirectionGroup
	add.w	$0020(a5),d6
	and.w	#$0003,d6
	bra.s	.Wychwind_CreateProjectile

.Wychwind_RotateSecondDirectionGroup:		; Memory Address ($57D0) and binary offset [$544C]
	; Normalises Wychwind directions four through seven before applying the party
	; facing.
	subq.w	#$04,d6
	add.w	$0020(a5),d6
	and.w	#$0003,d6
	addq.w	#$04,d6
.Wychwind_CreateProjectile:		; Memory Address ($57DC) and binary offset [$5458]
	; Calls the shared spell-entity creator with one Wychwind direction and
	; restores loop state.
	bsr		CreateSpellEntity
	movem.w	(sp)+,d5/d7
	dbra	d5,.Wychwind_SpawnProjectileLoop
	rts		

.Wychwind_DirectionAdjustments:		; Memory Address ($57EA) and binary offset [$5466]
	; Eight mechanic-owned direction adjustments used to rotate Wychwind's radial
	; projectiles; retained in source rather than extracted.
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$00	;00

Spells_28_ArcBolt:		; Memory Address ($546E) and binary offset [$50EA]
	move.w	#AirbourneSpell_ArcBolt,d4
	bra		SpellEntity_ScalePowerThreeHalves

Spells_29_Formwall:		; Memory Address ($5476) and binary offset [$50F2]
	moveq	#MagicFeature_Formwall,d4
CreateMagicWallFeature:		; Memory Address ($57FC) and binary offset [$5478]
	; Creates a power-scaled Formwall or Mindrock in an empty map cell directly in
	; front of the party.
	move.w	d7,d3
	addq.w	#$02,d3
	asl.w	#$02,d3
	bsr		ForwardCellToMapOffset
	cmp.w	CurrentFloorHeight.l,d7
	bcc.s	Return_CreateMagicWallFeature
	swap	d7
	cmp.w	CurrentFloorWidth.l,d7
	bcc.s	Return_CreateMagicWallFeature
	move.b	$01(a6,d0.w),d1
	bmi.s	Return_CreateMagicWallFeature
	and.w	#$0007,d1
	bne.s	Return_CreateMagicWallFeature
	tst.b	$00(a6,d0.w)
	bne.s	Return_CreateMagicWallFeature
	or.b	#MapCell_MagicFeatureType,$01(a6,d0.w)								;Changes an empty target cell to map type 7, the shared magic-feature type.
	or.b	d3,d4																;Packs spell-power bands above the low two-bit Formwall or Mindrock subtype.
	move.b	d4,$00(a6,d0.w)
	and.w	#$0003,d4
	subq.b	#$03,d4
	bne.s	Return_CreateMagicWallFeature
	move.w	#$03FF,d1
Formwall_PrepareLinkedFeature:		; Memory Address ($5842) and binary offset [$54BE]
	; Builds the packed map-position key used to register a Formwall in the linked
	; feature list.
	lea		LinkedMagicRecordList.l,a0
	swap	d0
	move.w	d1,d0
	swap	d0
	moveq	#$00,d1
Formwall_FindLinkedFeatureLoop:		; Memory Address ($5850) and binary offset [$54CC]
	; Searches the linked feature list for the Formwall's packed map-position key.
	cmp.w	-$0002(a0),d1
	bcc.s	Formwall_AppendLinkedFeature
	cmp.w	$02(a0,d1.w),d0
	beq.s	Formwall_StoreLinkedFeature
	addq.w	#$04,d1
	bra.s	Formwall_FindLinkedFeatureLoop

Formwall_AppendLinkedFeature:		; Memory Address ($5860) and binary offset [$54DC]
	; Extends the linked feature list when the Formwall's map-position key is not
	; already present.
	addq.w	#$04,-$0002(a0)
Formwall_StoreLinkedFeature:		; Memory Address ($5864) and binary offset [$54E0]
	; Stores the Formwall's packed map-position key in the linked feature list.
	move.l	d0,$00(a0,d1.w)
Return_CreateMagicWallFeature:		; Memory Address ($5868) and binary offset [$54E4]
	; Returns after Formwall or Mindrock creation or when the target cell is
	; unsuitable.
	rts		

Spells_30_Summon:		; Memory Address ($54E6) and binary offset [$5162]
	moveq	#$64,d4
	bra		SpellEntity_PrepareDirection

Spells_31_Blaze:		; Memory Address ($54EC) and binary offset [$5168]
	move.w	#AirbourneSpell_Blaze,d4
	add.w	#$000A,d7
	lsr.w	#$01,d7
	bra		SpellEntity_PrepareDirection

Spells_32_Mindrock:		; Memory Address ($54FA) and binary offset [$5176]
	moveq	#MagicFeature_Mindrock,d4
	bra		CreateMagicWallFeature

Find_HighestRankedPartyMemberByCategory:		; Memory Address ($5500) and binary offset [$517C]
	; Scans eligible champions owned by the active player for worn-spell bytes
	; whose low three bits match D1 and returns in D3 the matching champion with
	; the highest upper-five-bit magnitude.
	moveq	#-$01,d3
	moveq	#$03,d2
FindHighestRankedMember_ScanLoop:		; Memory Address ($5504) and binary offset [$5180]
	move.b	$18(a5,d2.w),d0
	and.w	#$00E0,d0
	bne.s	FindHighestRankedMember_LoopContinue
	move.b	$18(a5,d2.w),d0
	bsr		Load_ChampionStatRecord
	move.b	$0011(a4),d0
	and.w	#$0007,d0
	sub.w	d1,d0
	bne.s	FindHighestRankedMember_LoopContinue
	move.b	$0011(a4),d0
	lsr.b	#$03,d0
	tst.b	d3
	bpl.s	FindHighestRankedMember_CompareCandidate
	moveq	#$00,d3
FindHighestRankedMember_CompareCandidate:		; Memory Address ($552E) and binary offset [$51AA]
	cmp.b	d3,d0
	bcs.s	FindHighestRankedMember_LoopContinue
	move.b	d0,d3
	swap	d3
	move.b	$18(a5,d2.w),d3
	and.w	#$000F,d3
	swap	d3
FindHighestRankedMember_LoopContinue:		; Memory Address ($5540) and binary offset [$51BC]
	dbra	d2,FindHighestRankedMember_ScanLoop
	rts		

CastSpell_QualityRoll:		; Memory Address ($5546) and binary offset [$51C2]
	; Rolls three values from 0 to 5 and adds 3, producing the spell-casting
	; quality roll range 3-18.
	moveq	#$03,d6
	moveq	#$02,d5
QualityRoll_SumDiceLoop:		; Memory Address ($554A) and binary offset [$51C6]
	bsr.s	RandomGen_SixSidedRoll
	add.w	d0,d6
	dbra	d5,QualityRoll_SumDiceLoop
	move.w	d6,d0
	rts		

RandomGen_SixSidedRoll:		; Memory Address ($5556) and binary offset [$51D2]
	; Advances the adjacent two-byte six-sided seed state and returns a remainder
	; from 0 to 5; updating that word also changes RandomOffsetValue.
	move.w	SixSidedRollSeed.l,d0
	addq.w	#$01,d0
	mulu	#$B640,d0
	move.l	d0,d1
	asl.l	#$04,d0
	add.l	d1,d0
	move.w	#$0511,d1
	moveq	#$00,d3
SixSidedRoll_DivideBy1297:		; Memory Address ($556E) and binary offset [$51EA]
	divu	d1,d0
	bvc.s	SixSidedRoll_StoreNewSeed
	move.w	d0,d2
	clr.w	d0
	swap	d0
	divu	d1,d0
	move.w	d0,d3
	move.w	d2,d0
	bra.s	SixSidedRoll_DivideBy1297

SixSidedRoll_StoreNewSeed:		; Memory Address ($5580) and binary offset [$51FC]
	subq.w	#$01,d1
	swap	d0
	move.w	d3,d0
	swap	d0
	divu	d1,d0
	clr.w	d0
	swap	d0
	move.w	d0,SixSidedRollSeed.l
	moveq	#$06,d1
SixSidedRoll_DivideBySix:		; Memory Address ($5596) and binary offset [$5212]
	divu	d1,d0
	bvc.s	SixSidedRoll_ReturnRemainder
	move.w	d0,d2
	clr.w	d0
	swap	d0
	divu	d1,d0
	move.w	d2,d0
	bra.s	SixSidedRoll_DivideBySix

SixSidedRoll_ReturnRemainder:		; Memory Address ($55A6) and binary offset [$5222]
	swap	d0
	rts		

SixSidedRollSeed:		; Memory Address ($55AA) and binary offset [$5226]
	dc.b	$03	;03
RandomOffsetValue:		; Memory Address ($55AB) and binary offset [$5227]
	dc.b	$E1	;E1

RandomGen_BytewithOffset:		; Memory Address ($55AC) and binary offset [$5228]
	; Generates a full-range random byte and adds the current RandomOffsetValue
	; byte.
	moveq	#$01,d1
	bsr.s	RandomGen
	swap	d0
	add.b	RandomOffsetValue(pc),d0
	rts		

RandomGen_100:		; Memory Address ($55B8) and binary offset [$5234]
	; Requests range 100 from the core generator and returns a value from 0 to 99.
	move.w	#$6400,d1
RandomGen:		; Memory Address ($55BC) and binary offset [$5238]
	; Advances the persistent eight-bit pseudo-random seed with a shift/XOR/rotate
	; step and scales it to the caller-supplied range as floor(seed*range/256).
	swap	d1
	moveq	#$00,d0
	move.b	RandomSeed.l,d0
	move.w	d0,d1
	lsr.b	#$03,d1
	eor.b	d0,d1
	lsr.b	#$01,d1
	roxr.b	#$01,d0
	move.b	d0,RandomSeed.l
	swap	d1
	mulu	d1,d0
	swap	d0
	rts		

RandomSeed:		; Memory Address ($55DE) and binary offset [$525A]
	; Persistent byte seed updated by the game random-number generator.
	dc.b	$FF	;FF
	dc.b	$FF	;FF

Click_ViewSpell:		; Memory Address ($55E0) and binary offset [$525C]
	move.w	#$0002,$0014(a5)
	bsr		Select_SpellBookRune
	bpl.s	ClickViewSpell_InitCastPower
	bsr		Draw_SelectedSpellDetails
	bsr		Clear_LowerTextStrip
	bra.s	ClickViewSpell_RedrawPageSpread

ClickViewSpell_InitCastPower:		; Memory Address ($55F6) and binary offset [$5272]
	move.l	a6,-(sp)
	bsr		Calculate_SpellCastingQuality
	addq.b	#$03,d7
	bmi.s	ClickViewSpell_DrawDetails
	lea		SpellCost_DataTable.l,a0
	move.b	$00(a0,d6.w),d0
	add.w	d0,d0
	addq.b	#$01,d0
	cmp.b	d7,d0
	bcs.s	ClickViewSpell_NegateStoreCastPower
	move.b	d7,d0
ClickViewSpell_NegateStoreCastPower:		; Memory Address ($5614) and binary offset [$5290]
	neg.b	d0
	move.b	d0,$0014(a4)
ClickViewSpell_DrawDetails:		; Memory Address ($561A) and binary offset [$5296]
	bsr		Draw_SelectedSpellDetails
	move.l	(sp)+,a6
	bsr		Print_SelectedSpellNameWarmOrange
ClickViewSpell_RedrawPageSpread:		; Memory Address ($5624) and binary offset [$52A0]
	bra		Draw_SpellBookPageSpread

Resolve_SpellCastingGridClick:		; Memory Address ($5628) and binary offset [$52A4]
	move.w	$000E(a5),d7
	moveq	#-$01,d2
	bsr		HitTest_SpellGridCell
	bpl.s	SetActionCommand_SpellGridCellHit
	bsr		HitTest_DisplayAction
	tst.w	$000C(a5)
	bpl.s	NoMatch_SharedReturn
	cmpi.w	#$0048,d1
	bcs.s	NoMatch_SharedReturn
	cmpi.w	#$0058,d1
	bcc.s	NoMatch_SharedReturn
	swap	d1
	sub.w	#$00E0,d1
	bcs.s	NoMatch_SharedReturn
	lsr.w	#$04,d1
	cmpi.w	#$0005,d1
	beq		Click_CloseCurrentPage
	cmpi.w	#$0004,d1
	beq.s	SetActionCommand_13
	move.b	$18(a5,d1.w),d0
	and.w	#$00A0,d0
	bne.s	NoMatch_SharedReturn
	move.w	#$0011,$000C(a5)
	move.w	d1,$000E(a5)
NoMatch_SharedReturn:		; Memory Address ($5676) and binary offset [$52F2]
	rts		

SetActionCommand_13:		; Memory Address ($5678) and binary offset [$52F4]
	move.w	#$0013,$000C(a5)
	rts		

SetActionCommand_SpellGridCellHit:		; Memory Address ($5680) and binary offset [$52FC]
	move.w	#$0012,$000C(a5)
	move.b	d7,$000E(a5)
	rts		

PartyNavigationField_CellPassabilityTable:		; Memory Address ($568C) and binary offset [$5308]
	; Maps the three-bit map-cell type to passable or blocked during party
	; navigation-field expansion.
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00

Build_PartyNavigationField:		; Memory Address ($5694) and binary offset [$5310]
	; Builds the active party's breadth-first navigation or scent field for up to
	; 12 layers, reducing the range by 2*(the strongest Vanish magnitude+1).
	bsr		Select_ActivePlayerFloorMap
	moveq	#$03,d1
	bsr		Find_HighestRankedPartyMemberByCategory
	moveq	#$0B,d2
	tst.w	d3
	bmi.s	BuildNavigationField_InitCellScan
	addq.w	#$01,d3
	add.w	d3,d3
	sub.w	d3,d2
	bcs.s	NoMatch_SharedReturn
BuildNavigationField_InitCellScan:		; Memory Address ($56AC) and binary offset [$5328]
	move.l	Current_TowerMapDataBase.l,a2
	add.w	Live_PlayerPosition.l,a2
	move.l	a6,a3
	move.w	CurrentFloorHeight.l,d0
	mulu	CurrentFloorWidth.l,d0
	subq.w	#$01,d0
BuildNavigationField_ScanCellsLoop:		; Memory Address ($56C8) and binary offset [$5344]
	move.w	(a2)+,d1
	and.w	#$0007,d1
	cmpi.b	#$02,d1
	bne.s	BuildNavigationField_CheckType7Override
	btst	#$04,-$0001(a2)
	bne.s	BuildNavigationField_ForcePassable
BuildNavigationField_CheckType7Override:		; Memory Address ($56DC) and binary offset [$5358]
	cmpi.b	#$07,d1
	bne.s	BuildNavigationField_WriteCellPassability
	move.b	-$0002(a2),d1
	and.w	#$0003,d1
	subq.w	#$01,d1
	beq.s	BuildNavigationField_WriteCellPassability
BuildNavigationField_ForcePassable:		; Memory Address ($56EE) and binary offset [$536A]
	moveq	#$01,d1
BuildNavigationField_WriteCellPassability:		; Memory Address ($56F0) and binary offset [$536C]
	move.b	PartyNavigationField_CellPassabilityTable(pc,d1.w),(a3)+
	dbra	d0,BuildNavigationField_ScanCellsLoop
	lea		PartyNavigationField_FrontierBufferA.l,a2
	lea		PartyNavigationField_FrontierBufferB.l,a3
	move.b	$001F(a5),$0001(a2)
	move.b	$001D(a5),(a2)
	move.b	#$FF,$0002(a2)
BuildNavigationField_FrontierLayerLoop:		; Memory Address ($5714) and binary offset [$5390]
	move.l	a2,a0
	move.l	a3,a1
BuildNavigationField_FrontierEntryLoop:		; Memory Address ($5718) and binary offset [$5394]
	moveq	#$00,d7
	move.b	(a0)+,d7
	bmi.s	BuildNavigationField_EndOfFrontierLayer
	swap	d7
	move.b	(a0)+,d7
	subq.w	#$01,d7
	bcs.s	BuildNavigationField_TestDirection0
	moveq	#$02,d1
	bsr.s	Mark_NavigationFieldNeighbor
BuildNavigationField_TestDirection0:		; Memory Address ($572A) and binary offset [$53A6]
	addq.w	#$02,d7
	cmp.w	CurrentFloorHeight.l,d7
	bcc.s	BuildNavigationField_TestDirection3
	moveq	#$00,d1
	bsr.s	Mark_NavigationFieldNeighbor
BuildNavigationField_TestDirection3:		; Memory Address ($5738) and binary offset [$53B4]
	subq.w	#$01,d7
	swap	d7
	addq.w	#$01,d7
	cmp.w	CurrentFloorWidth.l,d7
	bcc.s	BuildNavigationField_TestDirection1
	swap	d7
	moveq	#$03,d1
	bsr.s	Mark_NavigationFieldNeighbor
	swap	d7
BuildNavigationField_TestDirection1:		; Memory Address ($574E) and binary offset [$53CA]
	subq.w	#$02,d7
	bcs.s	BuildNavigationField_FrontierEntryLoop
	swap	d7
	moveq	#$01,d1
	bsr.s	Mark_NavigationFieldNeighbor
	bra.s	BuildNavigationField_FrontierEntryLoop

BuildNavigationField_EndOfFrontierLayer:		; Memory Address ($575A) and binary offset [$53D6]
	cmp.l	a1,a3
	beq.s	Return_ActionDispatchBlocked
	move.b	#$FF,(a1)
	exg		a2,a3
	dbra	d2,BuildNavigationField_FrontierLayerLoop
	rts		

Mark_NavigationFieldNeighbor:		; Memory Address ($576A) and binary offset [$53E6]
	; For one cardinal neighbour, computes Y*width+X; if its field byte is zero,
	; stores direction|$80 and appends the packed coordinate to the next BFS
	; frontier. Negative or other nonzero cells are skipped.
	move.w	d7,d0
	mulu	CurrentFloorWidth.l,d0
	swap	d7
	add.w	d7,d0
	swap	d7
	tst.b	$00(a6,d0.w)
	bmi.s	Return_ActionDispatchBlocked
	beq.s	MarkNavigationFieldNeighbor_MarkVisited
	rts		

MarkNavigationFieldNeighbor_MarkVisited:		; Memory Address ($5782) and binary offset [$53FE]
	or.b	#$80,d1
	move.b	d1,$00(a6,d0.w)
	swap	d7
	move.b	d7,(a1)+
	swap	d7
	move.b	d7,(a1)+
Return_ActionDispatchBlocked:		; Memory Address ($5B16) and binary offset [$5792]
	; Exit used when interface-action dispatch is blocked by player state.
	rts		

MovementOffsetTable:		; Memory Address ($5794) and binary offset [$5410]
	dc.w	$0001	;0001
	dc.w	$00FF	;00FF
	dc.w	$0101	;0101
	dc.w	$FFFF	;FFFF
	dc.w	$FF00	;FF00
	dc.w	$0100	;0100
	dc.w	$FF01	;FF01
	dc.w	$01FF	;01FF

Click_CloseCurrentPage:		; Memory Address ($57A4) and binary offset [$5420]
	; Returns the current UI page to the default page and redraws the champion-name
	; panel frame.
	clr.w	$0014(a5)
	bra		Draw_ChampionNamePanelFrame

Dispatch_PlayerInterfaceActionGuarded:		; Memory Address ($5B30) and binary offset [$57AC]
	; Checks player state before dispatching the active action.
	btst	#$06,$0018(a5)
	bne.s	Return_ActionDispatchBlocked
	pea		adrL_008226.l
Dispatch_PlayerInterfaceAction:		; Memory Address ($5B3E) and binary offset [$57BA]
	; Indexes the dungeon InterfaceButtons jump table using PlayerX_Data+$0C.
	move.w	PlayerData_ActionCommand(a5),d0										;Offset used to dispatch the active player interface command.
	bmi.s	Return_ActionDispatchBlocked
	asl.w	#InterfaceAction_TableEntryShift,d0									;Shift count converting an interface action index into a four-byte jump-table offset.
	lea		DungeonInterfaceActionTable.l,a0
	move.l	$00(a0,d0.w),a0
	jmp		(a0)

DungeonInterfaceActionTable:		; Memory Address ($5B52) and binary offset [$57CE]
	; Dungeon action jump table indexed by PlayerX_Data+$0C.
	dc.l	Click_OpenSpellBook	;00006684
	dc.l	Click_ShowStats	;00006616
	dc.l	Click_MultiFunctionButton	;000064AA
	dc.l	Click_OpenInventory	;00006BF0
	dc.l	Handle_PrimaryAttackAction	;00005F9E
	dc.l	Click_Display_Centre	;00005F94
	dc.l	Click_PartyMember	;000065B2
	dc.l	Click_PartyMember	;000065B2
	dc.l	Click_PartyMember	;000065B2
	dc.l	Click_PartyMember	;000065B2
	dc.l	Click_MoveForwards	;00006DEE
	dc.l	Click_MoveBackwards	;00006DF2
	dc.l	Click_MoveLeft	;00006DF6
	dc.l	Click_MoveRight	;00006DFA
	dc.l	Click_RotateLeft	;00006F5A
	dc.l	Click_RotateRight	;00006F68
	dc.l	Click_Display	;0000588E
	dc.l	Redraw_Inventory	;00006C0A
	dc.l	Click_ObjectInInventory	;00006A46
	dc.l	Click_Item_17_to_1A_Potions	;00006914
	dc.l	Return_NoDisplayContextAction	;00005862
	dc.l	Click_LaunchSpellFromBook	;00004E7A
	dc.l	Click_ViewSpell	;000055E0
	dc.l	Click_TurnSpellBookPage	;0000C2EA
	dc.l	Click_CloseCurrentPage	;000057A4
	dc.l	Click_TurnSpellBookPage	;0000C2EA
	dc.l	Click_ChampionPresentationOrPartyCommand	;0000420C
	dc.l	Return_NoDisplayContextAction	;00005862
	dc.l	Click_PauseGame	;0000425E
	dc.l	Click_LoadSaveGame	;0000432A
	dc.l	Click_SleepParty	;00004536
	dc.l	Click_ShowTeamAvatars	;000032DE
	dc.l	Click_TogglePartyCommandRow	;00004C10
	dc.l	PartyCommand_DispatchSelection	;0000336A
	dc.l	PickupOrDropFloorObjectFromDisplay	;00005D3E
	dc.l	Handle_WallFeatureClick	;00005894
	dc.l	Resolve_WallFeatureContext	;000064D0

Return_NoDisplayContextAction:		; Memory Address ($5862) and binary offset [$54DE]
	; Returns without performing a display-context action when the current context
	; has no applicable handler.
	rts		

Interface_Hitboxes_Display:		; Memory Address ($5864) and binary offset [$54E0]
	; Existing mapping: three inclusive X/Y display-context hitbox records for
	; actions $22-$24.
	INCBIN "/data/BLOODWYCH439-clean/Interface_Hitboxes_Display"

HitTest_DisplayAction:		; Memory Address ($587C) and binary offset [$54F8]
	; Existing mapping: clears the pending action and scans display-context hitbox
	; records $22-$24.
	moveq	#$22,d0																;Starts the display/context hitbox scan at action ID $22.
	moveq	#$26,d2
	lea		Interface_Hitboxes_Display.w,a6										;Short Absolute converted to symbol!
	move.w	#$FFFF,$000C(a5)													;Clears the pending interface action before testing the display/context rectangles.
	bra		HitTest_PlayerInterfaceActions

Click_Display:		; Memory Address ($588E) and binary offset [$550A]
	; Existing mapping: broad dungeon-display action which performs the
	; second-stage context hit test then dispatches it.
	bsr.s	HitTest_DisplayAction
	bra		Dispatch_PlayerInterfaceAction

Handle_WallFeatureClick:		; Memory Address ($5894) and binary offset [$5510]
	; Existing mapping: handles type-1 wall features; non-type-1 cells branch to
	; adrJA0064D0.
	bsr		ForwardCellToMapOffset
	cmp.w	CurrentFloorHeight.l,d7
	bcc.s	Return_WallFeatureClick
	swap	d7
	cmp.w	CurrentFloorWidth.l,d7
	bcc.s	Return_WallFeatureClick
	swap	d7
	move.w	$00(a6,d0.w),d2
	move.w	d2,d3
	and.w	#$0007,d2
	subq.w	#$01,d2
	bne		Resolve_WallFeatureContext
	tst.b	d3
	bpl.s	Return_WallFeatureClick
	move.b	$01(a6,d0.w),d3
	lsr.w	#$04,d3
	and.w	#$0003,d3
	eor.w	#$0002,d3
	cmp.w	$0020(a5),d3
	bne.s	Return_WallFeatureClick
	move.b	$00(a6,d0.w),d3
	and.w	#$0003,d3
	add.w	d3,d3
	lea		MainWall_Action_01_Shelf.l,a0
	add.w	MainWall_Action_LookupTable(pc,d3.w),a0
	jmp		(a0)

Return_WallFeatureClick:		; Memory Address ($58EA) and binary offset [$5566]
	; Existing mapping: return when a wall-feature click has no supported action.
	rts		

MainWall_Action_LookupTable:		; Memory Address ($58EC) and binary offset [$5568]
	; Proposed: four relative offsets for shelf, decoration, switch and socket
	; click handlers.
	INCBIN "/data/BLOODWYCH439-clean/MainWall_Action_LookupTable"

MainWall_Action_01_Shelf:		; Memory Address ($58F4) and binary offset [$5570]
	; Maps the clicked shelf height to one of the two shelf object subpositions
	; before shared object handling.
	move.w	$0004(a5),d1
	sub.w	$0008(a5),d1
	moveq	#$02,d6
	cmpi.w	#$0033,d1
	bcs		PickupFloorObject_RefreshUI_SharedEntry
	moveq	#$03,d6
	bra		PickupFloorObject_RefreshUI_SharedEntry

MainWall_Action_02_WallDecoration:		; Memory Address ($590C) and binary offset [$5588]
	; Accepts scroll-bearing wall decorations and converts their subtype into a
	; scroll index.
	moveq	#$00,d1
	move.b	$00(a6,d0.w),d1
	lsr.b	#$02,d1
	subq.b	#$05,d1
	bcc.s	MainWall_Action_02_Scrolls
	rts		

MainWall_Action_02_Scrolls:		; Memory Address ($591A) and binary offset [$5596]
	; Draws the scroll frame, resolves the tower-specific scroll text, and prints
	; it in the interface.
	move.w	d1,-(sp)
	moveq	#$38,d5
	bsr		Draw_ScrollFrame
	move.w	(sp)+,d1
	move.w	CurrentTower.l,d0
	add.b	Scroll_TowerOffsets_DataTable(pc,d0.w),d1
	lea		Scroll_Offsets.l,a0
	lea		$0092(a0),a6
	add.w	d1,d1
	add.w	$00(a0,d1.w),a6
	move.w	#$0004,$0014(a5)
	move.l	#$00000003,CurrentTextInk.l
	bra		Print_fflim_text

Scroll_TowerOffsets_DataTable:		; Memory Address ($5952) and binary offset [$55CE]
	INCBIN "/data/BLOODWYCH439-clean/data/scrollstowers.data"

MainWall_Action_04_Sockets:		; Memory Address ($5958) and binary offset [$55D4]
	; Places a held crystal or gem into a wall socket, or dispatches the action for
	; an occupied socket.
	moveq	#$00,d1
	move.b	$00(a6,d0.w),d1
	btst	#$02,d1
	bne.s	Sockets_Actions
	tst.w	$002E(a5)
	bne.s	Socket_ClickExit
	lsr.w	#$03,d1
	add.w	#$0060,d1
	move.w	d1,$002E(a5)
	move.w	#$0001,$002C(a5)
	bset	#$02,$00(a6,d0.w)
	bra		Refresh_UIAfterSocketAction

Socket_ClickExit:		; Memory Address ($5984) and binary offset [$5600]
	rts		

Sockets_Actions:		; Memory Address ($5986) and binary offset [$5602]
	; Verifies the held object matches the occupied socket and dispatches the
	; crystal or gem-specific effect.
	lsr.w	#$03,d1
	add.w	#$0060,d1
	cmp.w	$002E(a5),d1
	bne.s	Socket_ClickExit
	clr.l	$002C(a5)
	movem.l	d0/a6,-(sp)
	bsr		Refresh_UIAfterSocketAction
	movem.l	(sp)+,d0/a6
	move.b	$00(a6,d0.w),d1
	lsr.w	#$02,d1
	and.w	#$000E,d1
	lea		SocketActions_SerpentCrystal.l,a0
	add.w	Sockets_LookupTable(pc,d1.w),a0
	jsr		(a0)
	moveq	#Sound_AlternativeSpell,d0
	bra		PlaySound

Sockets_LookupTable:		; Memory Address ($59BE) and binary offset [$563A]
	dc.w	SocketActions_SerpentCrystal-SocketActions_SerpentCrystal	;0000
	dc.w	SocketActions_ChaosCrystal-SocketActions_SerpentCrystal	;0024
	dc.w	SocketActions_DragonCrystal-SocketActions_SerpentCrystal	;006A
	dc.w	SocketActions_MoonCrystal-SocketActions_SerpentCrystal	;008A
	dc.w	Exit_SocketAction-SocketActions_SerpentCrystal	;0022
	dc.w	SocketActions_BluishGem-SocketActions_SerpentCrystal	;00E0
	dc.w	Exit_SocketAction-SocketActions_SerpentCrystal	;0022
	dc.w	SocketActions_TanGem-SocketActions_SerpentCrystal	;00D8

SocketActions_SerpentCrystal:
	moveq	#$05,d4
	moveq	#$12,d6
	bsr		SocketActions_RestorePartyStatToMax
	cmp.w	#$0005,CurrentTower.l
	bne.s	Exit_SocketAction
	move.l	#$00090001,d7
Last_CrystalAction:
	; Converts D7 to a map offset and clears the cell's low three feature-type bits
	; after the Dragon or Moon crystal socket effect resolves.
	bsr		CoordToMap
	and.w	#$00F8,$00(a6,d0.w)
Exit_SocketAction:
	rts		

SocketActions_ChaosCrystal:		; Memory Address ($59F2) and binary offset [$566E]
	bclr	#$02,$00(a6,d0.w)
	bsr		PlayerPositionToMapOffset
	bsr		VivifyInternal_ReviveOwnPartyMembers
	cmp.w	#$0005,CurrentTower.l
	bne.s	Exit_SocketAction
	lea		UnpackedMonsters.l,a0
	cmp.b	#$6B,$000B(a0)
	bne.s	.EntropySummoned
	tst.b	(a0)
	bpl.s	.EntropySummoned
	and.b	#$7F,(a0)
	move.l	#$00090008,d7
	bsr		CoordToMap
	bset	#$07,$01(a6,d0.w)
.EntropySummoned:		; Memory Address ($5A30) and binary offset [$56AC]
	move.l	#$00090003,d7
	bra.s	Last_CrystalAction

SocketActions_DragonCrystal:		; Memory Address ($5A38) and binary offset [$56B4]
	moveq	#$07,d4
	moveq	#$11,d6
	bsr.s	SocketActions_RestorePartyStatToMax
	cmp.w	#$0005,CurrentTower.l
	bne.s	Exit_SocketAction
	move.l	#$00100008,d7
	bsr.s	Last_CrystalAction
	move.l	#$00040008,d7
	bra.s	Last_CrystalAction

SocketActions_MoonCrystal:		; Memory Address ($5A58) and binary offset [$56D4]
	moveq	#$09,d4
	moveq	#$13,d6
	bsr.s	SocketActions_RestorePartyStatToMax
	cmp.w	#$0005,CurrentTower.l
	bne.s	Exit_SocketAction
	move.l	#$00030009,d7														;Long Addr replaced with Symbol
	bsr		Last_CrystalAction
	move.l	#$000F0009,d7
	bra		Last_CrystalAction

SocketActions_RestorePartyStatToMax:		; Memory Address ($5A7C) and binary offset [$56F8]
	; Restores the stat selected by D4 to its maximum for every occupied party
	; slot; the three crystal handlers select hit points, vitality, or spell
	; points.
	bclr	#$02,$00(a6,d0.w)
	moveq	#$03,d7
RestorePartyStatToMax_ScanLoop:		; Memory Address ($5A84) and binary offset [$5700]
	move.b	$18(a5,d7.w),d0
	bmi.s	RestorePartyStatToMax_LoopContinue
	bsr		Load_ChampionStatRecord
	move.b	$01(a4,d4.w),$00(a4,d4.w)											;Restores the D4-selected current statistic from its following maximum-statistic byte.
RestorePartyStatToMax_LoopContinue:		; Memory Address ($5A94) and binary offset [$5710]
	dbra	d7,RestorePartyStatToMax_ScanLoop
	bsr		PlayerPositionToMapOffset
	move.w	d6,d7
	bsr		Queue_MapCellEffect
	bra		Draw_CompactStatsFrame

SocketActions_TanGem:		; Memory Address ($5AA6) and binary offset [$5722]
	lea		TanGemLocs.l,a0
	bra.s	TeleportGem

SocketActions_BluishGem:		; Memory Address ($5AAE) and binary offset [$572A]
	lea		BlueGemLocs.l,a0
TeleportGem:		; Memory Address ($5AB4) and binary offset [$5730]
	move.w	CurrentTower.l,d1
	asl.w	#$02,d1
	add.w	d1,a0
	moveq	#$00,d6
	move.b	(a0)+,d6
	swap	d6
	move.b	(a0)+,d6
	cmp.l	$001C(a5),d6
	bne.s	TeleportGem_ApplyDestination
	move.b	(a0)+,d6
	swap	d6
	move.b	(a0),d6
TeleportGem_ApplyDestination:		; Memory Address ($5AD2) and binary offset [$574E]
	bsr		PlayerPositionToMapOffset
	bclr	#$07,$01(a6,d0.w)
	move.l	d6,$001C(a5)
	bsr		ForwardCellToMapOffset
	bchg	#$02,$00(a6,d0.w)
	bsr		PlayerPositionToMapOffset
	bset	#$07,$01(a6,d0.w)
	moveq	#$10,d7
	bra		Queue_MapCellEffect

TanGemLocs:		; Memory Address ($5AFA) and binary offset [$5776]
	INCBIN "/data/BLOODWYCH439-clean/maps/gem-tan.locations"
BlueGemLocs:		; Memory Address ($5B12) and binary offset [$578E]
	INCBIN "/data/BLOODWYCH439-clean/maps/gem-blu.locations"

MainWall_Action_03_Switches:		; Memory Address ($5B2A) and binary offset [$57A6]
	; Toggles the switch display bit and dispatches the tower-specific four-byte
	; switch record; byte 0 is an even offset into the eight-entry handler table
	; and bytes 2-3 provide target X/Y.
	moveq	#$00,d1																;Clear the switch-reference accumulator.
	move.b	$00(a6,d0.w),d1														;Read the clicked wall's first byte.
	and.w	#WallSwitch_IndexMask,d1											;Keep the switch reference in bits 3-7.
	beq.s	Switch_00_s00_Null													;Reference zero does nothing, including no click or light change.
	bchg	#WallSwitch_DimBit,$00(a6,d0.w)										;Flip the switch's lit/dim state before running its action.
	lsr.b	#$01,d1																;Convert the encoded reference to a four-byte record offset.
	move.w	CurrentTower.l,d0													;Read the current tower number.
	asl.w	#WallSwitch_TowerStrideShift,d0										;Select its 64-byte switch-record block.
	lea		SwitchData_1.l,a1													;Start from the Keep's switch definitions.
	add.w	d0,a1																;Advance to this tower's switch definitions.
	moveq	#$00,d0																;Clear D0 for the next lookup: action dispatch or switch-click playback.
	move.b	$00(a1,d1.w),d0														;Read the action byte, already a word-table byte offset.
	lea		Switch_00_s00_Null.l,a0												;Load the base used by the signed handler displacements.
	add.w	Switches_LookupTable(pc,d0.w),a0									;Add the selected handler's signed displacement.
	jsr		(a0)																;Run the switch action with A1/D1 selecting its record.
	moveq	#$00,d0																;Clear D0 for the next lookup: action dispatch or switch-click playback.
	bra		PlaySound															;Play the switch click and return directly to the caller.

Switch_00_s00_Null:		; Memory Address ($5B66) and binary offset [$57E2]
	rts																			;Return without performing a switch action.

Switches_LookupTable:		; Memory Address ($5B68) and binary offset [$57E4]
	dc.w	Switch_00_s00_Null-Switch_00_s00_Null	;0000
	dc.w	Switch_01_s02_Trigger_11_t16_RemoveXY-Switch_00_s00_Null	;01AC
	dc.w	Switch_02_s04_Trigger_23_t2E_ToggleWall_XY-Switch_00_s00_Null	;0196
	dc.w	Switch_03_s06_Trigger_03_t06_OpenLockedDoor_XY-Switch_00_s00_Null	;1BE0
	dc.w	Switch_04_s08_Trigger_22_t2C_RotateWall_XY-Switch_00_s00_Null	;1B4E
	dc.w	Switch_05_s0A_Trigger_13_t1A_TogglePillar_XY-Switch_00_s00_Null	;1C06
	dc.w	Switch_06_s0C_Trigger_18_t24_CreatePillar_XY-Switch_00_s00_Null	;1C02
	dc.w	Trigger_Action36_RotateWoodEdges-Switch_00_s00_Null	;1BF2
SwitchData_1:		; Memory Address ($5B78) and binary offset [$57F4]
	INCBIN "/data/BLOODWYCH439-clean/maps/mod0.switches"
SwitchData_2:		; Memory Address ($5BB8) and binary offset [$5834]
	INCBIN "/data/BLOODWYCH439-clean/maps/serp.switches"
SwitchData_3:		; Memory Address ($5BF8) and binary offset [$5874]
	INCBIN "/data/BLOODWYCH439-clean/maps/moon.switches"
SwitchData_4:		; Memory Address ($5C38) and binary offset [$58B4]
	INCBIN "/data/BLOODWYCH439-clean/maps/drag.switches"
SwitchData_5:		; Memory Address ($5C78) and binary offset [$58F4]
	INCBIN "/data/BLOODWYCH439-clean/maps/chaos.switches"
SwitchData_6:		; Memory Address ($5CB8) and binary offset [$5934]
	INCBIN "/data/BLOODWYCH439-clean/maps/zendik.switches"

Trigger_15_t1E_CreateWall_XY:		; Memory Address ($5CF8) and binary offset [$5974]
	; Runs the target-removal preparation used by action $16, then falls through to
	; the shared record-target wall/space toggle for action $1E.
	bsr		Switch_01_s02_Trigger_11_t16_RemoveXY								;Remove the target feature before falling through to create a wall.
Switch_02_s04_Trigger_23_t2E_ToggleWall_XY:		; Memory Address ($5CFC) and binary offset [$5978]
	; Resolves the record's target cell, ignores an occupied target, clears its
	; first byte, and toggles the wall/space bit while preserving unrelated
	; second-byte flags.
	bsr.s	Resolve_ActionTargetXY												;Resolve the record's X/Y to A6/D0 on the active floor.
	tst.b	$01(a6,d0.w)														;Test the target's occupied or decorated-wall flag.
	bmi.s	Return_WallToggle													;Leave a flagged target unchanged.
	and.w	#MapCell_WallTogglePreserveMask,$00(a6,d0.w)						;Clear the first byte and type bits 1-2; retain other second-byte flags.
	eor.b	#$01,$01(a6,d0.w)													;Toggle the remaining type bit between space and stone wall.
Return_WallToggle:		; Memory Address ($5D10) and binary offset [$598C]
	rts																			;Return after the wall-toggle attempt.

Switch_01_s02_Trigger_11_t16_RemoveXY:		; Memory Address ($5D12) and binary offset [$598E]
	; Resolves the record's target cell and clears its low feature-type bits, with
	; an additional flag cleanup for the affected cell type.
	bsr.s	Resolve_ActionTargetXY												;Resolve the record's X/Y to A6/D0 on the active floor.
	move.b	$01(a6,d0.w),d2														;Read the target's type and flags.
	and.w	#MapCell_TypeMask,d2												;Keep the three-bit map-cell type.
	subq.w	#$01,d2																;Check whether the target is a stone wall.
	bne.s	Clear_TargetMapCellType												;For other types, retain the existing second-byte flags.
	and.b	#StoneWall_RemoveFeatureMask,$01(a6,d0.w)							;Remove the stone-wall decoration flag and facing bits.
Clear_TargetMapCellType:		; Memory Address ($5D26) and binary offset [$59A2]
	and.b	#MapCell_ClearTypeMask,$01(a6,d0.w)									;Change the target to space without clearing its remaining flags.
	rts																			;Return with A6/D0 still addressing the target cell.

Resolve_ActionTargetXY:		; Memory Address ($5D2E) and binary offset [$59AA]
	; Packs trigger-record bytes 2 and 3 as target X and Y and converts that
	; coordinate to the current-floor map offset.
	moveq	#$00,d7																;Clear both coordinate words before loading byte-sized X/Y.
	move.b	$02(a1,d1.w),d7														;Load the record's target X coordinate.
	swap	d7																	;Place X in D7's high word.
	move.b	$03(a1,d1.w),d7														;Load Y into D7's low word.
	bra		CoordToMap															;Return A6/D0 for this X/Y using the currently loaded floor geometry.

PickupOrDropFloorObjectFromDisplay:		; Memory Address ($5D3E) and binary offset [$59BA]
	; Converts a display click into a target cell and one of its four object
	; subpositions, then enters the shared floor-object pickup/drop handler.
	bsr.s	HitTest_PickupDropQuadrant
Refresh_UIAfterSocketAction:		; Memory Address ($5D40) and binary offset [$59BC]
	; Refreshes the held-item panel or description after a crystal or gem socket
	; action.
	cmp.w	#$0003,$0014(a5)
	beq		Refresh_HeldItemDisplay
	bra		Draw_HeldObjectDescription

PickupFloorObject_RefreshUI_SharedEntry:		; Memory Address ($5D4E) and binary offset [$59CA]
	bsr.s	PickupFloorObjectAtResolvedCorner
	bra.s	Refresh_UIAfterSocketAction

HitTest_PickupDropQuadrant:		; Memory Address ($5D52) and binary offset [$59CE]
	; Converts the player-relative pointer position into one of four pickup or drop
	; quadrants.
	move.l	$0002(a5),d1
	sub.w	$0008(a5),d1
	moveq	#$02,d6
	cmpi.w	#$0051,d1
	bcs.s	HitTest_PickupDropQuadrant_TestY
	subq.w	#$02,d6
HitTest_PickupDropQuadrant_TestY:		; Memory Address ($5D64) and binary offset [$59E0]
	swap	d1
	cmpi.w	#$00A0,d1
	bcs.s	HitTest_PickupDropQuadrant_ApplyFacing
	addq.w	#$01,d6
HitTest_PickupDropQuadrant_ApplyFacing:		; Memory Address ($5D6E) and binary offset [$59EA]
	move.l	$001C(a5),d7
	cmpi.w	#$0002,d6
	bcc.s	PickupDrop_ResolveFarQuadrantCell
	bsr		CoordToMap
	bra.s	PickupFloorObjectAtResolvedCorner

PickupDrop_ResolveFarQuadrantCell:		; Memory Address ($5D7E) and binary offset [$59FA]
	bsr		StepCoordForwardToMapOffset
	cmp.w	CurrentFloorHeight.l,d7
	bcc.s	PickupDrop_NoActionReturn
	swap	d7
	cmp.w	CurrentFloorWidth.l,d7
	bcc.s	PickupDrop_NoActionReturn
	swap	d7
	bsr		Resolve_PickupDropTargetCell
	bcc.s	PickupFloorObjectAtResolvedCorner
PickupDrop_NoActionReturn:		; Memory Address ($5D9C) and binary offset [$5A18]
	rts		

PickupFloorObjectAtResolvedCorner:		; Memory Address ($5D9E) and binary offset [$5A1A]
	; With an empty hand, removes the top object from the selected cell/subposition
	; stack, caps counted-object quantity at $63, and compacts or removes the
	; variable-length record when exhausted.
	bclr	#$03,$01(a6,d0.w)
	tst.w	$002E(a5)
	bne		DropHeldObject_AtResolvedCorner
	btst	#$06,$01(a6,d0.w)
	beq.s	PickupDrop_NoActionReturn
	bsr		Rotate_ObjectSubpositionByPlayerFacing
	bsr		Find_FloorObjectStackAtCellSubposition
	bne.s	PickupDrop_NoActionReturn
	lea		$03(a0,d7.w),a1
	moveq	#$00,d3
	move.b	-$0001(a1),d3
	add.w	d3,d3
	moveq	#$00,d1
	move.b	$00(a1,d3.w),d1
	move.w	d1,$002E(a5)
	move.b	$01(a1,d3.w),d1
	moveq	#$01,d2
	cmp.w	#$0005,$002E(a5)
	bcc.s	PickupFloorObject_ApplyTakeQuantity
	move.w	d1,d2
	cmpi.b	#$64,d2
	bcs.s	PickupFloorObject_ApplyTakeQuantity
	moveq	#$63,d2
PickupFloorObject_ApplyTakeQuantity:		; Memory Address ($5DEC) and binary offset [$5A68]
	move.w	d2,$002C(a5)
	sub.b	d2,d1
	move.b	d1,$01(a1,d3.w)
	bne.s	PickupDrop_NoActionReturn
Remove_FloorObjectStackEntry:		; Memory Address ($5DF8) and binary offset [$5A74]
	; Removes one floor-object stack entry and compacts the following entries or
	; enclosing record when necessary.
	subq.b	#$01,-$0001(a1)
	bcs.s	RemoveFloorObjectStackEntry_RemoveRecord
	lea		$00(a1,d3.w),a1
	lea		$0002(a1),a2
	add.w	d3,d7
	addq.w	#$03,d7
	subq.w	#$02,-$0002(a0)
ShiftDown_FloorObjectEntries:		; Memory Address ($5E0E) and binary offset [$5A8A]
	; Compacts the remaining floor-object bytes after an entry or record is
	; removed.
	move.w	-$0002(a0),d2
	sub.w	d7,d2
	bra.s	ShiftDownFloorObjectEntries_LoopTest

ShiftDownFloorObjectEntries_CopyByte:		; Memory Address ($5E16) and binary offset [$5A92]
	move.b	(a2)+,(a1)+
ShiftDownFloorObjectEntries_LoopTest:		; Memory Address ($5E18) and binary offset [$5A94]
	dbra	d2,ShiftDownFloorObjectEntries_CopyByte
	rts		

RemoveFloorObjectStackEntry_RemoveRecord:		; Memory Address ($5E1E) and binary offset [$5A9A]
	lea		$00(a0,d7.w),a1
	lea		$0005(a1),a2
	subq.w	#$05,-$0002(a0)
	bsr.s	ShiftDown_FloorObjectEntries
	moveq	#$03,d5
FindFloorObjectStack_ScanSubpositions:		; Memory Address ($5E2E) and binary offset [$5AAA]
	move.w	d5,d6
	bsr		Find_FloorObjectStackAtCellSubposition
	beq.s	RemoveFloorObjectStackEntry_ClearFlagReturn
	dbra	d5,FindFloorObjectStack_ScanSubpositions
	bclr	#$06,$01(a6,d0.w)
RemoveFloorObjectStackEntry_ClearFlagReturn:		; Memory Address ($5E40) and binary offset [$5ABC]
	rts		

Resolve_PickupDropTargetCell:		; Memory Address ($5E42) and binary offset [$5ABE]
	; Converts the selected quadrant and facing into a map cell and validates its
	; wooden traversal edge.
	swap	d6
	move.w	$0020(a5),d6
	move.w	d0,d2
	bsr		PlayerPositionToMapOffset
	bsr		Check_WoodCellTraversal
	bcs.s	ResolvePickupDropTargetCell_Exit
	move.w	d2,d0
	move.b	$01(a6,d0.w),d1
	and.w	#$0007,d1
	subq.w	#$01,d1
	beq.s	ResolvePickupDropTargetCell_RestoreTypeCode
	subq.w	#$01,d1
	bne.s	ResolvePickupDropTargetCell_NormalReturn
	eor.w	#$0002,d6
	bsr		Test_WoodTraversalEdge
	bcs.s	ResolvePickupDropTargetCell_Exit
ResolvePickupDropTargetCell_NormalReturn:		; Memory Address ($5E70) and binary offset [$5AEC]
	move.w	d2,d0
	swap	d6
	rts		

ResolvePickupDropTargetCell_RestoreTypeCode:		; Memory Address ($5E76) and binary offset [$5AF2]
	sub.b	#$FF,d1
ResolvePickupDropTargetCell_Exit:		; Memory Address ($5E7A) and binary offset [$5AF6]
	rts		

DropHeldObject_AtResolvedCorner:		; Memory Address ($5E7C) and binary offset [$5AF8]
	move.l	$002C(a5),d5
	clr.l	$002C(a5)
	bsr		Rotate_ObjectSubpositionByPlayerFacing
Add_FloorObjectToStack:		; Memory Address ($5E88) and binary offset [$5B04]
	; Finds or creates a floor-object stack entry and merges or appends the dropped
	; object.
	bclr	#$03,$01(a6,d0.w)
	bsr		Find_FloorObjectStackAtCellSubposition
	bne		AddFloorObjectToStack_CreateNewStack
	lea		$03(a0,d7.w),a1
	moveq	#$00,d3
	move.b	-$0001(a1),d3
	add.w	d3,d3
AddFloorObjectToStack_ScanMatchLoop:		; Memory Address ($5EA2) and binary offset [$5B1E]
	cmp.b	$00(a1,d3.w),d5
	beq.s	AddFloorObjectToStack_CombineMatchedQuantity
	subq.w	#$02,d3
	bcc.s	AddFloorObjectToStack_ScanMatchLoop
AddFloorObjectToStack_InsertNewEntry:		; Memory Address ($5EAC) and binary offset [$5B28]
	move.w	-$0002(a0),d2
	addq.w	#ObjectStack_ItemBytes,-$0002(a0)									;Grows the used object payload by one code/quantity pair without comparing against the allocation capacity.
	addq.b	#$01,-$0001(a1)
	moveq	#$00,d3
	move.b	-$0001(a1),d3
	add.w	d3,d3
	lea		$00(a0,d2.w),a0
	lea		$0002(a0),a2
	add.w	d3,d7
	addq.w	#$03,d7
	sub.w	d7,d2
	bra.s	AddFloorObjectToStack_ShiftUpLoopTest

AddFloorObjectToStack_ShiftUpLoop:		; Memory Address ($5ED0) and binary offset [$5B4C]
	move.b	-(a0),-(a2)
AddFloorObjectToStack_ShiftUpLoopTest:		; Memory Address ($5ED2) and binary offset [$5B4E]
	dbra	d2,AddFloorObjectToStack_ShiftUpLoop
	move.b	d5,$00(a1,d3.w)
	swap	d5
	move.b	d5,$01(a1,d3.w)
	rts		

AddFloorObjectToStack_CombineMatchedQuantity:		; Memory Address ($5EE2) and binary offset [$5B5E]
	swap	d5
	add.b	$01(a1,d3.w),d5
	tst.b	-$0001(a1)
	bne.s	AddFloorObjectToStack_ReinsertMergedEntry
	move.b	d5,$01(a1,d3.w)
	rts		

AddFloorObjectToStack_ReinsertMergedEntry:		; Memory Address ($5EF4) and binary offset [$5B70]
	swap	d5
	move.w	d7,d1
	bsr		Remove_FloorObjectStackEntry
	move.w	d1,d7
	lea		$03(a0,d7.w),a1
	bra.s	AddFloorObjectToStack_InsertNewEntry

AddFloorObjectToStack_CreateNewStack:		; Memory Address ($5F04) and binary offset [$5B80]
	bset	#MapCell_ObjectPresentBit,$01(a6,d0.w)								;Marks the map cell when its first object stack is appended.
	addq.w	#ObjectStack_MinimumBytes,-$0002(a0)								;Grows the used payload by one minimum stack record without an allocation-capacity comparison.
	move.w	d0,d1
	move.b	d1,$01(a0,d7.w)
	ror.w	#$08,d1
	or.b	d6,d1
	move.b	d1,$00(a0,d7.w)
	move.b	#$00,$02(a0,d7.w)
	move.b	d5,$03(a0,d7.w)
	swap	d5
	move.b	d5,$04(a0,d7.w)
	rts		

Rotate_ObjectSubpositionByPlayerFacing:		; Memory Address ($5F2E) and binary offset [$5BAA]
	; Rotates absolute cell subposition D6 into the player's view according to the
	; player's facing and a 4x4 permutation table.
	move.w	$0020(a5),d1
	add.w	d1,d1
	add.w	d1,d1
	add.w	d6,d1
	move.b	ObjectSubpositionRotationTable(pc,d1.w),d6							;Maps facing * 4 + relative drop corner to the stored map mini-space.
	rts		

ObjectSubpositionRotationTable:		; Memory Address ($5F3E) and binary offset [$5BBA]
	; Maps an absolute floor-object corner to its player-relative corner after
	; facing rotation.
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$01	;01
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$01	;01

Find_FloorObjectRecordByMapLink:		; Memory Address ($5F4E) and binary offset [$5BCA]
	; Walks variable-length floor-object records until their leading map-link word
	; matches D0, returning A0 at the matching record.
	lea		MapCellImpactList.l,a0
FindFloorObjectRecordByMapLink_ScanLoop:		; Memory Address ($5F54) and binary offset [$5BD0]
	cmp.w	(a0),d0
	beq.s	FindFloorObjectStack_SharedReturn
	addq.w	#$04,a0
	bra.s	FindFloorObjectRecordByMapLink_ScanLoop

Find_FloorObjectStackAtCellSubposition:		; Memory Address ($5F5C) and binary offset [$5BD8]
	; Searches the tower's variable-length floor-object stacks for the selected
	; cell key and rotated subposition, returning the matching record and condition
	; state.
	move.l	Current_TowerMapDataBase.l,a0
	add.w	#Map_ResourceSize-Map_HeaderSize+ObjectData_LengthBytes,a0			;Fixed map allocation; object records begin after this map and the two-byte object-length word.
	move.w	d0,d1
	ror.w	#$08,d1
	ror.b	#$02,d6
	or.b	d6,d1
	moveq	#$00,d7
	moveq	#$00,d2
FindFloorObjectStack_ScanLoop:		; Memory Address ($5F72) and binary offset [$5BEE]
	cmp.w	-$0002(a0),d7
	bcc.s	FindFloorObjectStack_NotFoundFlag
	cmp.b	$01(a0,d7.w),d0
	bne.s	FindFloorObjectStack_AdvanceRecord
	cmp.b	$00(a0,d7.w),d1
	beq.s	FindFloorObjectStack_SharedReturn
FindFloorObjectStack_AdvanceRecord:		; Memory Address ($5F84) and binary offset [$5C00]
	move.b	ObjectStack_CountMinusOneOffset(a0,d7.w),d2							;Loads the record count-minus-one byte for scanning.
	add.w	d2,d2
	add.w	d2,d7
	addq.w	#ObjectStack_MinimumBytes,d7										;Adds the fixed part of each variable-length object stack.
	bra.s	FindFloorObjectStack_ScanLoop

FindFloorObjectStack_NotFoundFlag:		; Memory Address ($5F90) and binary offset [$5C0C]
	moveq	#$01,d1
FindFloorObjectStack_SharedReturn:		; Memory Address ($5F92) and binary offset [$5C0E]
	rts		

Click_Display_Centre:		; Memory Address ($5F94) and binary offset [$5C10]
	; Arms player command bit 3 and enters the shared acting-champion selection
	; path; combat uses this command state when deciding whether to double defence.
	and.b	#$01,(a5)
	bset	#$03,(a5)
	bra.s	Select_AttackingChampion

Handle_PrimaryAttackAction:		; Memory Address ($6322) and binary offset [$5F9E]
	; Primary attack action handler; sets the primary attack state bit and
	; continues through the common attack routine.
	and.b	#$01,(a5)
	bset	#PlayerData_StateFlags_PrimaryAttackBit,(a5)						;State bit set by the primary attack handler.
Select_AttackingChampion:		; Memory Address ($632A) and binary offset [$5FA6]
	; Common attack setup that selects the active champion/action participant.
	moveq	#$03,d1
	bsr		Find_HighestRankedPartyMemberByCategory
	tst.w	d3
	bmi.s	FindFloorObjectStack_SharedReturn
	swap	d3
	move.w	d3,d0
	bsr		Load_ChampionStatRecord
	clr.b	$0011(a4)
	bsr		Refresh_CurrentChampionMapPositionIcon
	bra		Draw_PartyCommandInterface

Draw_CombatOutcomeProfessionGlyph:		; Memory Address ($5FC4) and binary offset [$5C40]
	; Draws the profession-specific glyph used beside a combat-outcome message and
	; applies its colour mask.
	lea		GFX_Pockets+$6508.l,a1
	move.l	screen_ptr.l,a0
	add.w	$000A(a5),a0
	moveq	#$00,d0
	move.b	$18(a5,d7.w),d0
	move.w	d0,d1
	and.w	#$000F,d1
	and.w	#$00E0,d0
	bne.s	FindFloorObjectStack_SharedReturn
	move.w	d1,d0
	and.w	#$0003,d1
	mulu	#$0460,d1
	add.w	d1,a1
	bsr		Character_GetClassIndex
	move.b	ProfessionGlyphClassInkTable(pc,d0.w),d3
	move.w	d7,d0
	add.w	d0,d0
	add.w	ProfessionGlyphScreenOffsetTable(pc,d0.w),a0
	move.l	#$00000006,-(sp)
	bra		Draw_PlanarGraphicCore_WithStride98

ProfessionGlyphClassInkTable:		; Memory Address ($600C) and binary offset [$5C88]
	; Maps champion profession class to the ink used for combat-outcome profession
	; glyphs.
	dc.b	$06	;06
	dc.b	$0D	;0D
	dc.b	$0C	;0C
	dc.b	$08	;08
ProfessionGlyphScreenOffsetTable:		; Memory Address ($6010) and binary offset [$5C8C]
	; Per-formation-slot framebuffer offsets for combat-outcome profession glyphs.
	dc.w	$0DF4	;0DF4
	dc.w	$0000	;0000
	dc.w	$000D	;000D
	dc.w	$001B	;001B

Select_MonsterMeleePartyTarget:		; Memory Address ($6018) and binary offset [$5C94]
	; Selects a party target for monster melee from the exposed formation side,
	; tries the paired slot if vacant, falls back to the active champion, and
	; prepares the defender and double-defence state.
	sub.w	$0020(a1),d0
	addq.w	#$02,d0
	eor.w	#$0001,d2
	add.w	d2,d0
	and.w	#$0003,d0
	moveq	#$00,d1
	move.b	$26(a1,d0.w),d1
	bpl.s	SelectMeleeTarget_ResolveDefender
	sub.w	d2,d0
	eor.w	#$0001,d2
	add.w	d2,d0
	and.w	#$0003,d0
	move.b	$26(a1,d0.w),d1
	bpl.s	SelectMeleeTarget_ResolveDefender
	move.w	$0006(a1),d1
SelectMeleeTarget_ResolveDefender:		; Memory Address ($6046) and binary offset [$5CC2]
	; Determines whether the selected champion receives double defence from
	; persistent command bits 1/3, formation-slot bit 4, and current HP at or below
	; half maximum.
	and.w	#$000F,d1
	clr.w	PhysicalAttack_DoubleDefenceFlag.l
	movem.l	d0/d1/a1/a4/a5,-(sp)
	move.w	d1,d0
	move.l	a1,a5
	bsr		Find_ChampionInPlayerSlots
	move.b	(a5),d2
	and.w	#$000A,d2
	beq.s	SelectMeleeTarget_SetDoubleDefence
	btst	#$04,$18(a5,d1.w)
	beq.s	SelectMeleeTarget_CheckHalfHP
	and.w	#$0008,d2
	beq.s	SelectMeleeTarget_RestoreRegisters
	bra.s	SelectMeleeTarget_SetDoubleDefence

SelectMeleeTarget_CheckHalfHP:		; Memory Address ($6074) and binary offset [$5CF0]
	bsr		Load_ChampionStatRecord
	move.b	$0006(a4),d0
	lsr.b	#$01,d0
	cmp.b	$0005(a4),d0
	bcs.s	SelectMeleeTarget_RestoreRegisters
SelectMeleeTarget_SetDoubleDefence:		; Memory Address ($6084) and binary offset [$5D00]
	move.w	#$FFFF,PhysicalAttack_DoubleDefenceFlag.l
	bset	d1,$003C(a5)
SelectMeleeTarget_RestoreRegisters:		; Memory Address ($6090) and binary offset [$5D0C]
	movem.l	(sp)+,d0/d1/a1/a4/a5
SelectMeleeTarget_Return:		; Memory Address ($6094) and binary offset [$5D10]
	rts		

Redraw_CombatOutcomeSlot:		; Memory Address ($6096) and binary offset [$5D12]
	; Clears and redraws one formation slot's combat-outcome area when its display
	; timer expires.
	tst.b	d7
	bne.s	RedrawCombatOutcomeSlot_DrawBar
	cmp.b	#$02,$0015(a5)
	bcc.s	SelectMeleeTarget_Return
RedrawCombatOutcomeSlot_DrawBar:		; Memory Address ($60A2) and binary offset [$5D1E]
	or.b	#$B0,$0054(a5)
	moveq	#$67,d4
	moveq	#$06,d5
	swap	d4
	swap	d5
	move.b	CombatOutcomeSlotPositionTableX(pc,d7.w),d4
	move.b	CombatOutcomeSlotPositionTableY(pc,d7.w),d5
	add.w	$0008(a5),d5
	moveq	#$00,d3
	bra		BW_draw_bar

CombatOutcomeSlotPositionTableX:		; Memory Address ($60C2) and binary offset [$5D3E]
	; Per-formation-slot X positions for combat-outcome background redraws.
	dc.b	$60	;60
	dc.b	$00	;00
	dc.b	$68	;68
	dc.b	$D8	;D8
CombatOutcomeSlotPositionTableY:		; Memory Address ($60C6) and binary offset [$5D42]
	; Per-formation-slot Y positions paired with the combat-outcome X table.
	dc.b	$59	;59
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00

FormatPartySlotCombatOutcome_Entry:		; Memory Address ($60CA) and binary offset [$5D46]
	move.l	screen_ptr.l,a0
	add.w	$000A(a5),a0
	move.l	a4,-(sp)
	move.b	$18(a5,d7.w),d0
	bsr		Load_ChampionStatRecord
	move.b	$0019(a4),d0
	move.l	(sp)+,a4
	lsr.b	#$04,d0
	subq.b	#$02,d0
	move.b	d0,$5E(a5,d7.w)
	add.w	d7,d7
	add.w	CombatOutcomeText_ScreenOffsetTable(pc,d7.w),a0
	moveq	#$0B,d6
	tst.w	d7
	bne.s	FormatCombatOutcome_CompanionFlag
	moveq	#$0E,d6
	or.b	#$10,$0054(a5)
	bra.s	FormatCombatOutcome_SetupTextInk

FormatCombatOutcome_CompanionFlag:		; Memory Address ($6102) and binary offset [$5D7E]
	or.b	#$A0,$0054(a5)
FormatCombatOutcome_SetupTextInk:		; Memory Address ($6108) and binary offset [$5D84]
	move.l	#$000D0000,CurrentTextInk.l
	lea		OutcomeMsgs_0.l,a6
	move.b	OutcomeMsgOffsets(pc,d4.w),d4
	bne.s	FormatCombatOutcome_ApplyMessageOffset
	move.w	d5,d0
	beq.s	FormatCombatOutcome_PrintMessage
	lea		OutcomeMsgs_5.l,a6
	moveq	#$09,d2
	bsr.s	Convert_ThreeDigitDecimalText
	moveq	#$00,d4
FormatCombatOutcome_ApplyMessageOffset:		; Memory Address ($612E) and binary offset [$5DAA]
	add.w	d4,a6
FormatCombatOutcome_PrintMessage:		; Memory Address ($6130) and binary offset [$5DAC]
	bra		Print_TextCharacterLoop

CombatOutcomeText_ScreenOffsetTable:		; Memory Address ($6134) and binary offset [$5DB0]
	; Per-formation-slot framebuffer destinations for combat-outcome text.
	dc.w	$0E1D	;0E1D
	dc.w	$0029	;0029
	dc.w	$0036	;0036
	dc.w	$0044	;0044
OutcomeMsgOffsets:
	dc.b	OutcomeMsgs_0-OutcomeMsgs_0	;00
	dc.b	OutcomeMsgs_1-OutcomeMsgs_0	;07
	dc.b	OutcomeMsgs_2-OutcomeMsgs_0	;0E
	dc.b	OutcomeMsgs_3-OutcomeMsgs_0	;15
	dc.b	OutcomeMsgs_4-OutcomeMsgs_0	;21
	dc.b	OutcomeMsgs_5-OutcomeMsgs_0	;29
OutcomeMsgs_0:
	dc.b	'MISSES'
	dc.b	$FF	;FF
OutcomeMsgs_1:
	dc.b	'SHOOTS'
	dc.b	$FF	;FF
OutcomeMsgs_2:
	dc.b	'CHANTS'
	dc.b	$FF	;FF
OutcomeMsgs_3:
	dc.b	'CASTS SPELL'
	dc.b	$FF	;FF
OutcomeMsgs_4:
	dc.b	'DEFENDS'
	dc.b	$FF	;FF
OutcomeMsgs_5:
	dc.b	'HITS FOR '
Notice_NumberOfHits:
	dc.b	'000'
	dc.b	$FF	;FF

Convert_ThreeDigitDecimalText:		; Memory Address ($6178) and binary offset [$5DF4]
	; Formats an unsigned value from 0 to 999 with an optional hundreds digit and
	; two decimal digits.
	move.w	d0,d1
	moveq	#$00,d0
	move.w	d1,d0
	divu	#$0064,d0
	move.w	d0,d3
	beq.s	ConvertThreeDigitDecimalText_FormatRemainder
	add.b	#$30,d0
	move.b	d0,$00(a6,d2.w)
	addq.w	#$01,d2
ConvertThreeDigitDecimalText_FormatRemainder:		; Memory Address ($6190) and binary offset [$5E0C]
	swap	d0
	bsr		Convert_ByteToDecimalText
	move.b	d1,d0
	ror.w	#$08,d1
	tst.w	d3
	bne.s	ConvertThreeDigitDecimalText_WriteTensDigit
	cmpi.b	#$30,d1
	beq.s	ConvertThreeDigitDecimalText_WriteOnesDigit
ConvertThreeDigitDecimalText_WriteTensDigit:		; Memory Address ($61A4) and binary offset [$5E20]
	move.b	d1,$00(a6,d2.w)
	addq.w	#$01,d2
ConvertThreeDigitDecimalText_WriteOnesDigit:		; Memory Address ($61AA) and binary offset [$5E26]
	move.b	d0,$00(a6,d2.w)
	move.b	#$FF,$01(a6,d2.w)
	rts		

Close_AttackedChampionCommunicationPanels:		; Memory Address ($61B6) and binary offset [$5E32]
	; Closes either player's communication panel when its selected target is the
	; champion being attacked.
	movem.l	d1/d3/a5,-(sp)
	lea		Player1_Data.l,a5
	bsr.s	Close_PlayerCommunicationIfTargetAttacked
	lea		Player2_Data.l,a5
	bsr.s	Close_PlayerCommunicationIfTargetAttacked
	movem.l	(sp)+,d1/d3/a5
	rts		

Close_PlayerCommunicationIfTargetAttacked:		; Memory Address ($61D0) and binary offset [$5E4C]
	; Clears one player's communication state when the attacked champion matches
	; the selected target.
	cmp.b	$0035(a5),d1
	beq		Reset_PartyCommandStateAndRedrawMenu
	rts		

Resolve_PhysicalAttack:		; Memory Address ($61DA) and binary offset [$5E56]
	; Performs the opposed attack roll, calculates weapon damage, subtracts armour
	; and applies the hit-quality multiplier.
	moveq	#Sound_AttackClink,d0												;Selects the fighting clink played when a physical attack begins.
	bsr		PlaySound
	bsr.s	Close_AttackedChampionCommunicationPanels
	bsr		Prepare_AttackAndDefenceScores
	clr.w	$0000(a6)
	clr.w	AirborneSpellSplashFlag.w											;Short Absolute converted to symbol!
	bsr		RandomGen_100
	add.w	$0002(a6),d0
	move.w	d0,d2
	bsr		RandomGen_100
	add.w	$0004(a6),d0
	sub.w	d0,d2
	bmi.s	PhysicalAttack_HandleDefenderRollWin
	move.w	d2,d0
	moveq	#$40,d2
	sub.w	d0,d2
	bpl.s	PhysicalAttack_CalculateDamage
	moveq	#$01,d2
	bra.s	PhysicalAttack_CalculateDamage

PhysicalAttack_HandleDefenderRollWin:		; Memory Address ($6210) and binary offset [$5E8C]
	; Handles the narrow defender-roll win while retaining damage tier $40, so the
	; subsequent damage multiplier remains x1.
	neg.w	d2
	move.w	d2,d0
	moveq	#$40,d2
	cmp.w	d2,d0
	bpl		PhysicalAttack_Return
PhysicalAttack_CalculateDamage:		; Memory Address ($621C) and binary offset [$5E98]
	; Calculates base physical damage from a 0..range-1 weapon roll, level and
	; fixed weapon bonuses using byte addition, then adds the effective-Strength
	; contribution before backstab, armour, and hit-quality adjustments.
	move.w	$0006(a6),d1
	bsr		RandomGen
	addq.w	#$01,d0
	add.b	$0008(a6),d0
	add.b	$000A(a6),d0
	moveq	#$00,d1
	move.b	$0009(a6),d1
	sub.w	#$0014,d1
	bcs.s	PhysicalAttack_ApplyBackstabDamage
	lsr.w	#$03,d1
	add.w	d1,d0
PhysicalAttack_ApplyBackstabDamage:		; Memory Address ($623E) and binary offset [$5EBA]
	; Triples damage when the attack retains backstab eligibility.
	tst.w	PhysicalAttack_BackstabState.l
	bne.s	PhysicalAttack_CalculateArmourReduction
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
PhysicalAttack_CalculateArmourReduction:		; Memory Address ($624C) and binary offset [$5EC8]
	; Calculates the defender's armour reduction, including conditional upward
	; rounding.
	moveq	#$00,d4
	move.b	$000D(a6),d4
	lsr.b	#$01,d4
	bcc.s	PhysicalAttack_ApplyArmourReduction
	move.w	d2,d1
	and.w	#$000F,d1
	beq.s	PhysicalAttack_RoundArmourReductionUp
	subq.w	#$08,d1
	bcs.s	PhysicalAttack_ApplyArmourReduction
PhysicalAttack_RoundArmourReductionUp:		; Memory Address ($6262) and binary offset [$5EDE]
	addq.w	#$01,d4
PhysicalAttack_ApplyArmourReduction:		; Memory Address ($6264) and binary offset [$5EE0]
	; Subtracts effective armour before applying hit-quality damage multipliers.
	sub.w	d4,d0
	bcs.s	PhysicalAttack_Return
	beq.s	PhysicalAttack_Return
	move.w	d0,d1
	cmpi.w	#$0028,d2
	bcc.s	PhysicalAttack_StoreDamage
	add.w	d1,d0
	cmpi.w	#$0019,d2
	bcc.s	PhysicalAttack_StoreDamage
	add.w	d1,d0
	cmpi.w	#$000A,d2
	bcc.s	PhysicalAttack_StoreDamage
	add.w	d1,d0
PhysicalAttack_StoreDamage:		; Memory Address ($6284) and binary offset [$5F00]
	; Stores the final positive damage in the physical-attack working values.
	move.w	d0,$0000(a6)
PhysicalAttack_Return:		; Memory Address ($6288) and binary offset [$5F04]
	rts		

PhysicalAttack_BackstabState:		; Memory Address ($628A) and binary offset [$5F06]
	; Temporary attack-direction state: zero enables the Cutpurse backstab;
	; non-zero or $FFFF disables it.
	ds.b	$2
Load_CombatantCombatValues:		; Memory Address ($628C) and binary offset [$5F08]
	; Loads champion or monster combat statistics and applies equipment and
	; active-spell modifiers.
	moveq	#$00,d4
	moveq	#$00,d5
	moveq	#$00,d6
	moveq	#$00,d7
	cmpi.w	#$0010,d0
	bcs.s	Load_ChampionCombatValues
	sub.w	#$0010,d0
	asl.w	#$04,d0
	lea		UnpackedMonsters.l,a4
	add.w	d0,a4
	moveq	#$1E,d1
	moveq	#$14,d2
	move.b	$0006(a4),d0
	and.w	#$007F,d0
	move.w	d0,d3
	add.w	d3,d3
	add.w	d3,d1
	add.w	d3,d1
	add.w	d3,d2
	add.w	d0,d3
	lsr.w	#$01,d3
	moveq	#$08,d4
	rts		

Load_ChampionCombatValues:		; Memory Address ($62C6) and binary offset [$5F42]
	; Loads the champion's combat values and subtracts the fixed physical-combat
	; cost of 3 vitality, clamping underflow to zero; this also occurs when loading
	; a defending champion.
	move.w	d0,d1
	bsr		Load_ChampionStatRecord
	subq.b	#PhysicalAttack_VitalityCost,ChampionStat_VitalityCurrent(a4)		;Vitality removed when champion combat values are loaded for physical combat.
	bcc.s	Apply_ChampionCombatModifiers
	clr.b	ChampionStat_VitalityCurrent(a4)
Apply_ChampionCombatModifiers:		; Memory Address ($62D6) and binary offset [$5F52]
	; Applies armour, held weapon and active worn-spell modifiers to champion
	; combat values.
	move.w	d1,d0
	bsr.s	Calculate_CharacterArmourLevel
	bsr		Calculate_WeaponCombatBonuses
	bsr		Calculate_WarriorLevelContribution
	tst.w	PhysicalAttack_BackstabState.w										;Short Absolute converted to symbol!
	bne.s	Apply_WarpowerCombatModifiers
	OPT		O2+
	move.b	ChampionStat_Level(a4),d0
	OPT		O2-
Apply_WarpowerCombatModifiers:		; Memory Address ($62EA) and binary offset [$5F66]
	; Applies Warpower magnitude to effective Level, Strength and Agility.
	moveq	#$00,d1
	move.b	ChampionStat_WornSpell(a4),d1
	move.w	d1,d2
	and.w	#$0007,d2
	subq.b	#WornSpell_Warpower,d2												;Low three-bit worn-spell type used for Warpower.
	bne.s	Load_NormalChampionCombatStats
	lsr.b	#$03,d1
	move.w	d1,d2
	lsr.w	#$02,d2
	addq.w	#$01,d2
	add.w	d2,d0
	move.w	d1,d2
	add.b	ChampionStat_Strength(a4),d1
	addq.b	#Combat_StrengthBias,d1												;Internal Strength bias applied before physical-combat thresholds.
	add.b	ChampionStat_Agility(a4),d2
	rts		

Load_NormalChampionCombatStats:		; Memory Address ($6312) and binary offset [$5F8E]
	; Loads normal Strength and Agility when Warpower is not active.
	move.b	ChampionStat_Strength(a4),d1
	addq.b	#Combat_StrengthBias,d1												;Internal Strength bias applied before physical-combat thresholds.
	move.b	ChampionStat_Agility(a4),d2
	rts		

Calculate_CharacterArmourLevel:		; Memory Address ($631E) and binary offset [$5F9A]
	; Combines body armour, worn gloves and shield values into the character's
	; effective armour level.
	lea		Character_Pockets_DataTable.l,a1
	asl.w	#$04,d0
	add.w	d0,a1
	move.b	ChampionStat_WornSpell(a4),d3
	move.w	d3,d2
	lsr.b	#$03,d2
	and.w	#$0007,d3
	beq.s	Armour_SelectInnateOrSpellValue
	moveq	#$00,d2
Armour_SelectInnateOrSpellValue:		; Memory Address ($6338) and binary offset [$5FB4]
	; Selects the greater of innate armour and an active Armour-spell magnitude.
	move.b	ChampionStat_ArmourLevel(a4),d3
	cmp.b	d3,d2
	bcs.s	Armour_ApplyBodyArmour
	move.b	d2,d3
Armour_ApplyBodyArmour:		; Memory Address ($6342) and binary offset [$5FBE]
	; Replaces the base armour value when the worn body armour provides greater
	; protection.
	move.b	$0002(a1),d2														;Reads the selected champion's body-armour pocket before converting body armour object IDs into armour protection.
	beq.s	Armour_ApplyWornHandArmour
	sub.b	#$1B,d2
	add.b	d2,d2
	addq.b	#$03,d2
	cmp.b	d2,d3
	bcc.s	Armour_ApplyWornHandArmour
	move.b	d2,d3
Armour_ApplyWornHandArmour:		; Memory Address ($6356) and binary offset [$5FD2]
	; Adds the contribution of the champion's worn hand-armour object.
	move.b	ChampionStat_WornHandArmour(a4),d2									;Reads the worn-hand-armour object and adds its source-defined protection after body and spell protection have been resolved.
	beq.s	Armour_ApplyShield
	sub.b	#$2B,d2
	add.b	d2,d3
Armour_ApplyShield:		; Memory Address ($6362) and binary offset [$5FDE]
	; Adds the equipped shield's armour contribution.
	moveq	#$00,d2
	move.b	$0003(a1),d2														;Reads the shield pocket and adds the matching protection byte only for object IDs $24 through $2A.
	sub.b	#$24,d2
	bcs.s	Armour_Return
	cmpi.w	#$0007,d2
	bcc.s	Armour_Return
	add.b	Shield_ArmourBonuses(pc,d2.w),d3
Armour_Return:		; Memory Address ($6378) and binary offset [$5FF4]
	rts		

Shield_ArmourBonuses:		; Memory Address ($637A) and binary offset [$5FF6]
	; Maps shield objects $24-$2A to armour contributions; the eighth byte is
	; unused by the seven-entry range.
	INCBIN "/data/BLOODWYCH439-clean/data/Shield_ArmourBonuses.lookup"

Calculate_WeaponCombatBonuses:		; Memory Address ($6382) and binary offset [$5FFE]
	; Checks the two held-object slots for weapon objects $30-$3F and loads their
	; combat adjustments.
	moveq	#$00,d0
	move.b	(a1),d0
	sub.b	#Object_Blades_First,d0												;First blade object and exclusive end of gloves.
	bcs.s	Weapon_CheckRightHand
	cmpi.b	#Weapon_CombatModifierRecordCount,d0								;Number of four-byte records in Weapon_CombatModifiers.
	bcs.s	Weapon_LoadCombatModifiers
Weapon_CheckRightHand:		; Memory Address ($6392) and binary offset [$600E]
	; Checks the right-hand pocket after the left hand does not contain a
	; recognised weapon.
	move.b	$0001(a1),d0
	sub.b	#Object_Blades_First,d0												;First blade object and exclusive end of gloves.
	bcs.s	Weapon_ReturnCombatModifiers
	cmpi.b	#Weapon_CombatModifierRecordCount,d0								;Number of four-byte records in Weapon_CombatModifiers.
	bcc.s	Weapon_ReturnCombatModifiers
Weapon_LoadCombatModifiers:		; Memory Address ($63A2) and binary offset [$601E]
	; Loads random damage, fixed damage, attack and defence modifiers from the
	; selected weapon record.
	lea		Weapon_CombatModifiers.l,a0
	asl.w	#$02,d0
	add.w	d0,a0
	move.b	(a0)+,d4
	move.b	(a0)+,d5
	move.b	(a0)+,d6
	move.b	(a0)+,d7
	tst.w	PhysicalAttack_BackstabState.w										;Short Absolute converted to symbol!
	bne.s	Weapon_ApplyAceOfSwordsRestriction
	cmpi.b	#Weapon_BackstabEligibleByteLimit,d0								;Exclusive byte-offset limit for weapon records which preserve a Cutpurse backstab.
	bcs.s	Weapon_ApplyAceOfSwordsRestriction
	move.w	#$FFFF,PhysicalAttack_BackstabState.w								;Short Absolute converted to symbol!
Weapon_ApplyAceOfSwordsRestriction:		; Memory Address ($63C6) and binary offset [$6042]
	; Reduces the Ace of Swords combat modifiers unless Chaos Gloves are worn.
	cmpi.b	#Weapon_AceOfSwordsRecordOffset,d0									;Byte offset of the Ace of Swords record within Weapon_CombatModifiers.
	bne.s	Weapon_ReturnCombatModifiers
	cmp.b	#Object_ChaosGloves,$0012(a4)										;Chaos Gloves object code.
	beq.s	Weapon_ReturnCombatModifiers
	moveq	#$05,d6
	moveq	#$05,d7
	moveq	#$00,d5
Weapon_ReturnCombatModifiers:		; Memory Address ($63DA) and binary offset [$6056]
	rts		

Weapon_CombatModifiers:		; Memory Address ($63DC) and binary offset [$6058]
	; Sixteen four-byte records for weapons $30-$3F: random damage range, fixed
	; damage bonus, attack bonus and defence bonus.
	INCBIN "/data/BLOODWYCH439-clean/data/Weapon_CombatModifiers.lookup"

Prepare_AttackAndDefenceScores:		; Memory Address ($641C) and binary offset [$6098]
	; Builds the attacker score and defender score, including weapon attack, weapon
	; defence and effective armour values.
	lea		PhysicalAttack_WorkingValues.l,a6
	move.w	d1,-(sp)
	move.w	d3,d0
	bsr		Calculate_AttackerCombatScore
	move.w	(sp)+,d0
	bsr		Load_CombatantCombatValues
	move.b	d7,$000C(a6)
	move.b	d3,$000D(a6)
	lsr.w	#$03,d2
	add.w	d2,d0
	move.w	d0,d1
	asl.w	#$02,d0
	add.w	d1,d0
	move.b	$000C(a6),d1
	add.w	d1,d0
	tst.w	PhysicalAttack_DoubleDefenceFlag.l
	beq.s	DefenderScore_StoreResult
	add.w	d0,d0
DefenderScore_StoreResult:		; Memory Address ($6452) and binary offset [$60CE]
	; Stores the completed defender score in the physical-attack working values.
	move.w	d0,$0004(a6)
	rts		

PhysicalAttack_DoubleDefenceFlag:		; Memory Address ($6458) and binary offset [$60D4]
	; Temporary flag which doubles the calculated defender score when set.
	ds.b	$2
Calculate_AttackerCombatScore:		; Memory Address ($645A) and binary offset [$60D6]
	; Calculates an attacker score from level, strength, agility and the equipped
	; weapon’s attack bonus.
	bsr		Load_CombatantCombatValues
	move.b	d6,$000B(a6)
	move.b	d5,$000A(a6)
	move.b	d4,$0006(a6)
	clr.b	$0007(a6)
	move.b	d0,$0008(a6)
	move.b	d1,$0009(a6)
	add.w	d0,d0
	sub.w	#$0010,d1
	bcc.s	AttackerScore_AddStrengthContribution
	moveq	#$00,d1
AttackerScore_AddStrengthContribution:		; Memory Address ($6480) and binary offset [$60FC]
	; Adds the thresholded effective-Strength contribution to the attacker score.
	lsr.w	#$04,d1
	add.w	d1,d0
	sub.w	#$0014,d2
	bcc.s	AttackerScore_AddAgilityContribution
	moveq	#$00,d2
AttackerScore_AddAgilityContribution:		; Memory Address ($648C) and binary offset [$6108]
	; Adds the thresholded effective-Agility contribution to the attacker score.
	lsr.w	#$04,d2
	add.w	d2,d0
	move.w	d0,d1
	asl.w	#$02,d0
	add.w	d1,d0
	move.b	$000B(a6),d1
	add.w	d1,d0
	tst.w	PhysicalAttack_BackstabState.w										;Short Absolute converted to symbol!
	bne.s	AttackerScore_StoreResult
	add.w	d0,d0
AttackerScore_StoreResult:		; Memory Address ($64A4) and binary offset [$6120]
	; Stores the completed attacker score in the physical-attack working values.
	move.w	d0,$0002(a6)
	rts		

Click_MultiFunctionButton:		; Memory Address ($64AA) and binary offset [$6126]
	; Handles the context-sensitive command button: clears an active selected
	; state, casts the selected champion's spell when appropriate, or resolves and
	; toggles a usable facing wall feature or door before refreshing the champion
	; map-position icon.
	bsr		Load_CurrentChampionStatRecord
	tst.b	ChampionStat_WornSpell(a4)
	beq.s	Resolve_MultiFunctionContext
	clr.b	ChampionStat_WornSpell(a4)
	move.w	$0006(a5),d7
	bsr		Draw_MainChampionAvatarInnerFrame
	bra.s	Load_MapPositionAfterMultiFunction

Resolve_MultiFunctionContext:		; Memory Address ($6846) and binary offset [$64C2]
	; Continuation of the multi-function handler; selects interaction, spell, or
	; map-AI behaviour from context.
	tst.b	ChampionStat_SpellToCast(a4)
	bmi.s	Resolve_WallFeatureContext
	bsr		Cast_SelectedChampionSpell
Load_MapPositionAfterMultiFunction:		; Memory Address ($64CC) and binary offset [$6148]
	; Continues after multifunction or shelf interaction handling by refreshing the
	; current champion's map-position icon.
	bra		Refresh_CurrentChampionMapPositionIcon

Resolve_WallFeatureContext:		; Memory Address ($64D0) and binary offset [$614C]
	; Resolves the contextual wall-feature or door action, toggling valid targets
	; or reporting a locked door.
	moveq	#$02,d3
	move.w	$0020(a5),d2
	add.w	d2,d2
	addq.w	#$01,d2
	bsr		PlayerPositionToMapOffset
	move.b	$01(a6,d0.w),d1
	and.w	#$0007,d1
	cmpi.b	#$02,d1
	bne.s	Check_FrontWallFeature
	btst	d2,$00(a6,d0.w)
	bne.s	Toggle_WallFeatureOrReportLocked
Check_FrontWallFeature:		; Memory Address ($64F2) and binary offset [$616E]
	; Resolves and validates the facing cell as a wooden edge or large door,
	; rejecting out-of-bounds, occupied, unusable, and incorrectly keyed targets
	; before state toggling.
	bsr		StepCoordForwardToMapOffset
	cmp.w	CurrentFloorHeight.l,d7
	bcc.s	Return_NoWallFeatureToToggle
	swap	d7
	cmp.w	CurrentFloorWidth.l,d7
	bcc.s	Return_NoWallFeatureToToggle
	eor.w	#$0004,d2
	move.b	$01(a6,d0.w),d1
	and.w	#$0007,d1
	cmpi.b	#$02,d1
	beq.s	Check_FrontWoodDoorEdge
	cmpi.b	#$05,d1
	bne.s	Return_NoWallFeatureToToggle
	tst.b	$01(a6,d0.w)
	bmi.s	Return_NoWallFeatureToToggle
	btst	#$03,$00(a6,d0.w)
	bne.s	Return_WallFeatureLocked
	moveq	#$01,d2
	move.b	$00(a6,d0.w),d3
	lsr.b	#$04,d3
	beq.s	Toggle_ValidatedWallFeatureState
	add.w	#$004F,d3
	cmp.w	$002E(a5),d3
	bne.s	Return_WallFeatureLocked
	and.b	#$0F,$00(a6,d0.w)
	bra.s	Toggle_WallFeatureOrReportLocked

Check_FrontWoodDoorEdge:		; Memory Address ($654A) and binary offset [$61C6]
	; Tests the opposite wooden-door edge and enters common state toggling only
	; when that edge is present.
	btst	d2,$00(a6,d0.w)
	bne.s	Toggle_WallFeatureOrReportLocked
Return_NoWallFeatureToToggle:		; Memory Address ($6550) and binary offset [$61CC]
	; Returns when neither the current cell nor the facing cell contains a usable
	; wall feature or door.
	rts		

Toggle_WallFeatureOrReportLocked:		; Memory Address ($68D6) and binary offset [$6552]
	; Consumes a matching common or named key when required, toggles the target
	; lock bit, and either reports that the door remains locked or continues to
	; toggle the validated wooden edge or large door.
	cmp.w	$002E(a5),d3
	bne.s	Toggle_ValidatedWallFeatureState
	subq.w	#$01,$002C(a5)
	bne.s	Toggle_MapCellMagelockState
	clr.w	$002E(a5)
Toggle_MapCellMagelockState:		; Memory Address ($6562) and binary offset [$61DE]
	; Toggles lock bit 4 in the target cell's second byte and redraws the held-item
	; panel when inventory mode is active.
	bchg	#$04,$01(a6,d0.w)
	cmp.w	#$0003,$0014(a5)
	bne.s	Toggle_ValidatedWallFeatureState
	movem.l	d0/d2/a6,-(sp)
	bsr		Draw_HeldItemPanel
	movem.l	(sp)+,d0/d2/a6
Toggle_ValidatedWallFeatureState:		; Memory Address ($657C) and binary offset [$61F8]
	; Rejects a still-locked target or toggles the validated wooden edge or
	; large-door bit, plays the door click, and clears the lower text strip.
	subq.w	#$01,d2
	btst	#$04,$01(a6,d0.w)
	bne.s	Return_WallFeatureLocked
	bchg	d2,$00(a6,d0.w)
	moveq	#Sound_DoorClick,d0													;Selects the click played when a wall feature or door changes state.
	bsr		PlaySound
	bra		Clear_LowerTextStrip

Return_WallFeatureLocked:		; Memory Address ($6594) and binary offset [$6210]
	; Loads THE DOOR IS LOCKED and enters the timed top-strip text writer.
	lea		Notice_DoorLocked.l,a6
	bra		WriteTimedText

Notice_DoorLocked:
	dc.b	'THE DOOR IS LOCKED'
	dc.b	$FF	;FF
	dc.b	$00	;00

Click_PartyMember:		; Memory Address ($65B2) and binary offset [$622E]
	lsr.w	#$02,d0																;Converts the dispatch-table byte offset into action number $06-$09 before calculating the party-slot index.
	subq.w	#$06,d0																;Converts party-member action $06-$09 to PlayerX_Data party slot $00-$03.
	tst.w	$0016(a5)															;Tests the pending party-slot selection. A negative value means this is the first click.
	bpl.s	ClickPartyMember_SwapOrConfirmSlot
	tst.b	$26(a5,d0.w)														;Tests for an empty destination only when no party slot is pending. Once a living slot is pending, the later byte-exchange path permits moving it into an empty profession-icon slot.
	bpl.s	ClickPartyMember_SetSelectedSlot
	rts		

ClickPartyMember_SetSelectedSlot:		; Memory Address ($65C4) and binary offset [$6240]
	move.w	d0,$0016(a5)														;Stores the first-click party-slot index as the pending selection, then redraws the party command interface.
	bra		Draw_PartyProfessionIconGrid

ClickPartyMember_SwapOrConfirmSlot:		; Memory Address ($65CC) and binary offset [$6248]
	cmp.w	$0016(a5),d0														;A second click on the same pending slot commits that champion as current; a different slot instead enters the reorder path.
	beq.s	ClickPartyMember_ActivateSelectedChampion
	move.b	$26(a5,d0.w),d1														;Loads the clicked party-position entry before exchanging it with the entry from the initially selected slot.
	move.w	$0016(a5),d2
	move.b	$26(a5,d2.w),$26(a5,d0.w)											;Moves the initially selected party-position entry into the different clicked slot; the next instruction writes the saved entry back, completing the swap.
	move.b	d1,$26(a5,d2.w)
	moveq	#-$01,d0															;Marks the pending selection invalid after a party-position swap; it does not change the current champion.
	bra.s	ClickPartyMember_SetSelectedSlot

ClickPartyMember_ActivateSelectedChampion:		; Memory Address ($65E8) and binary offset [$6264]
	move.b	$26(a5,d0.w),d0														;Loads the champion ID from the committed party slot before making it the current champion.
	bmi.s	ClickPartyMember_ClearSelectionAndRedraw
	move.w	$0006(a5),d2
	move.w	d0,$0006(a5)														;Stores the selected champion ID as PlayerX_Data current champion, driving the name panel and large avatar.
	bsr		Find_ChampionInPlayerSlots											;Finds the selected champion's current left avatar slot in PlayerX_Data+$18 before replacing the current leader.
	move.b	d2,$18(a5,d1.w)														;Writes the former leader into the selected champion's previous left avatar slot, refreshing the lower avatar arrangement after a confirmed lead change.
	move.b	d0,$0018(a5)														;Writes the confirmed new leader into the large-avatar slot at PlayerX_Data+$18; this is separate from the right-side profession-order bytes at $26.
	bset	#$04,$0018(a5)														;Marks the new large-avatar slot active after its champion ID has been written.
ClickPartyMember_ClearSelectionAndRedraw:		; Memory Address ($6608) and binary offset [$6284]
	move.w	#$FFFF,$0016(a5)													;Clears the pending party-slot selection after committing the current champion.
	bsr		Draw_ChampionNamePanelFrame
	bra		Draw_PartyCommandInterface

Click_ShowStats:		; Memory Address ($6616) and binary offset [$6292]
	; Selects statistics mode, draws the tall scroll using D5=$38, prints
	; ChampionStatsScroll_FoodTextTemplate and draws the champion food bar from
	; record byte $10.
	move.w	#$0001,$0014(a5)
	moveq	#$38,d5																;Supplies Draw_ChampionStats with the scroll's DBRA height $38; Draw_ScrollFrame uses this to fill the 57-row centre between its 15-row caps.
	bsr		Draw_ChampionStats
	lea		ChampionStatsScroll_FoodTextTemplate.l,a6							;Selects the FOOD Print_fflim_text stream: heading row $08 followed by end-cap glyph row $09, each printer row eight pixels apart.
	bsr		Print_fflim_text
	asl.w	#$05,d7
	lea		Character_Stats_DataTable.l,a6
	moveq	#$00,d0
	move.b	$10(a6,d7.w),d0
	beq.s	LoadChampionStatRecord_Return
	move.w	#$00C7,d1															;Sets $C7 as the champion food-byte value that represents a completely filled food bar.
	moveq	#$30,d2																;Sets the food bar's maximum scaled length to $30, yielding 48 rendered pixels.
	move.l	#$002F00F9,d4														;Supplies BW_draw_bar with X=$F9 and DBRA width $2F, drawing the food fill across 48 pixels through X=$128.
	bsr		Scale_ValueToBarLength
	move.l	#$0004004A,d5														;Supplies BW_draw_bar with Y=$4A and DBRA height $04, drawing a five-row food bar through Y=$4E.
	add.w	$0008(a5),d5
	moveq	#$09,d3																;Selects palette index $09 for the scaled champion food-bar fill.
	bra		BW_draw_bar

Load_CurrentChampionStatRecord:		; Memory Address ($665C) and binary offset [$62D8]
	; Loads the current player champion number before resolving its statistics
	; record.
	move.w	PlayerData_CurrentChampionNumber(a5),d0
Load_ChampionStatRecord:		; Memory Address ($6660) and binary offset [$62DC]
	; Converts champion number D0 into a pointer to its 32-byte statistics record
	; in A4.
	and.w	#Champion_Count-1,d0
	asl.w	#ChampionStat_RecordSizeShift,d0
	lea		Character_Stats_DataTable.l,a4
	add.w	d0,a4
LoadChampionStatRecord_Return:		; Memory Address ($666E) and binary offset [$62EA]
	rts		

Select_SpellBookPageForSelectedSpell:		; Memory Address ($6670) and binary offset [$62EC]
	; Selects the two-page spellbook spread containing the champion's currently
	; selected spell.
	clr.w	$002A(a5)
	move.b	$0013(a4),d0
	bmi.s	SelectSpellBookPage_Return
	lsr.b	#$03,d0
	add.b	d0,d0
	move.b	d0,$002B(a5)
SelectSpellBookPage_Return:		; Memory Address ($6682) and binary offset [$62FE]
	rts		

Click_OpenSpellBook:		; Memory Address ($6684) and binary offset [$6300]
	; Opens and composes the selected champion's spell-book interface page.
	bsr		Draw_ChampionNamePanelBackground
	bsr		Prepare_AndDrawSpellBookSurface
	bsr.s	Select_SpellBookPageForSelectedSpell
	bsr		Draw_SpellBookPageSpread
	move.w	#$0002,$0014(a5)
Draw_SelectedSpellDetails:		; Memory Address ($6698) and binary offset [$6314]
	; Draws selected spell stars, name, COST text, and the CAST display.
	bsr		Draw_SpellPointValues
	sub.w	#$02DC,a0															;Rebases the completed SP.PTS text cursor from $0E38 to $0B5C, the first lower spell-book decoration slot.
	move.b	$0013(a4),d0
	bpl.s	Draw_SelectedSpellClassIcons
	bsr.s	Draw_EmptySpellSelectionEdgeIcon
	moveq	#$68,d7
Draw_EmptySpellSelectionInnerIcons:		; Memory Address ($66AA) and binary offset [$6326]
	; Draws the empty spell-selection row as pocket icons $4F,$68,$69,$6A,$6B,$4F
	; across the six fixed positions.
	move.w	d7,d0
	bsr		Draw_PocketGraphic
	addq.w	#$01,d7
	cmpi.w	#$006C,d7
	bcs.s	Draw_EmptySpellSelectionInnerIcons
Draw_EmptySpellSelectionEdgeIcon:		; Memory Address ($66B8) and binary offset [$6334]
	moveq	#$4F,d0
	bra		Draw_PocketGraphic

Draw_SelectedSpellClassIcons:		; Memory Address ($66BE) and binary offset [$633A]
	; Draws the selected spell's class-symbol icons and four $3B separators using
	; their native pocket-graphic colours.
	bsr		Character_GetClassIndex
	add.w	#$0064,d0
	bsr		Draw_PocketGraphic
	moveq	#$03,d7
DrawSelectedSpellClassIcons_SeparatorLoop:		; Memory Address ($66CC) and binary offset [$6348]
	move.w	#$003B,d0
	bsr		Draw_PocketGraphic
	dbra	d7,DrawSelectedSpellClassIcons_SeparatorLoop
	move.b	$0013(a4),d0
	bsr		Character_GetClassIndex
	add.w	#$0064,d0
	bsr		Draw_PocketGraphic
	moveq	#$00,d0
	move.b	$0013(a4),d0
	bsr		Get_SelectedSpellName
	bsr		Print_SelectedSpellNameWarmOrange									;Prints the selected spell name from its fixed eight-character SpellNames record using the spell-book name origin.
Refresh_SpellCastCostDisplay:		; Memory Address ($66F6) and binary offset [$6372]
	or.b	#$04,$0054(a5)
	bsr		Calculate_SpellPointCost
	lea		CostMessageTemplate.l,a6											;Selects the COST text stream. Its FC ($1E,$0A) position plus the text renderer base $0050 places visible glyphs at X=$F0, Y=$52.
	bsr		Convert_ByteToDecimalText
	move.w	d1,$0010(a6)
	bsr		Print_fflim_text
Show_SpellCastPrompt:		; Memory Address ($6712) and binary offset [$638E]
	; Prints the cast prompt, clears casting quality, and enters the
	; casting-percentage bar renderer.
	lea		CastQualityMessageTemplate.l,a6
	bsr		LowerText
	clr.b	$0057(a5)
Draw_SpellCastingBar:		; Memory Address ($6720) and binary offset [$639C]
	; Converts signed casting quality into the five-pixel-high CAST bar.
	tst.b	$0057(a5)
	bmi.s	Draw_SpellCastingBar_EarlyReturn
	or.b	#$10,$0054(a5)
	bsr		Calculate_SpellCastingQuality
	neg.b	d7
	bpl.s	Draw_SpellCastingBar_CheckIndexRange
	moveq	#$00,d7
Draw_SpellCastingBar_CheckIndexRange:		; Memory Address ($6736) and binary offset [$63B2]
	cmpi.b	#$13,d7
	bcc.s	Draw_SpellCastingBar_EarlyReturn
	move.b	SpellCasting_CastBarPercentages(pc,d7.w),d0							;Converts the clamped negated cast score to one of 20 percentage values used to scale the 52-pixel CAST bar.
	moveq	#$64,d1
	moveq	#SpellCasting_CastBarMaximumWidth,d2								;Supplies C8144 with the 52-pixel maximum CAST bar width before percentage scaling.
	move.l	#$0004005A,d5														;Long Addr replaced with Symbol
	add.w	$0008(a5),d5
	move.l	#$0033009F,d4
	bsr		Scale_ValueToBarLength
	moveq	#$0C,d3
	bra		BW_draw_bar

Draw_SpellCastingBar_EarlyReturn:		; Memory Address ($675E) and binary offset [$63DA]
	rts		

SpellCasting_CastBarPercentages:		; Memory Address ($6760) and binary offset [$63DC]
	; Twenty percentages indexed by the clamped negated casting-quality score to
	; scale the 52-pixel CAST bar.
	INCBIN "/data/BLOODWYCH439-clean/data/SpellCasting_CastBarPercentages.lookup"

	bsr		Load_ChampionStatRecord
Calculate_SpellCastingQuality:		; Memory Address ($6778) and binary offset [$63F4]
	; Existing mapping; calculates signed spell quality from class, practice,
	; level, power, equipment, cooldown, and difficulty.
	move.b	ChampionStat_SpellToCast(a4),d0
	bsr		Character_GetClassIndex
	move.w	d0,-(sp)
	move.l	a4,d0
	sub.l	#Character_Stats_DataTable,d0
	lea		Character_Pockets_DataTable.l,a0
	lsr.w	#$01,d0
	add.w	d0,a0
	lsr.w	#$04,d0
	move.w	d0,d1
	bsr		Character_GetClassIndex
	moveq	#$00,d7
	cmp.w	(sp),d0
	bne.s	SpellCastQuality_AfterClassBonus
	move.w	d1,d2
	and.w	#$0003,d2
	move.b	SpellCasting_ProfessionBaseBonuses(pc,d2.w),d7
SpellCastQuality_AfterClassBonus:		; Memory Address ($67AC) and binary offset [$6428]
	move.l	#adrL_007E22,a1
	add.l	a4,a1
	moveq	#$00,d6
	move.b	ChampionStat_SpellToCast(a4),d6
	move.b	$00(a1,d6.w),d0														;Loads the selected spell's per-champion success-practice count from the runtime 16 by 32 practice area.
	moveq	#SpellCasting_PracticeFirstThreshold,d2								;Starts the matching spell-practice curve at five successes; the non-matching path doubles this to ten.
	moveq	#$00,d3
	tst.w	d7
	bne.s	SpellCastQuality_ThresholdLoopHead
	move.w	(sp),d4
	add.w	#$0057,d4
	cmp.b	(a0),d4
	beq.s	SpellCastQuality_ApplyWandBonus
	cmp.b	$0001(a0),d4
	bne.s	Double_SpellQualityThresholdAndAdvanceTier
SpellCastQuality_ApplyWandBonus:		; Memory Address ($67D6) and binary offset [$6452]
	addq.b	#SpellCasting_MatchingWandBonus,d7									;Awards the matching-wand quality bonus when the champion class itself does not match.
SpellCastQuality_ThresholdLoopHead:		; Memory Address ($67D8) and binary offset [$6454]
	cmp.w	d2,d0
	bcs.s	SpellCastQuality_ApplyPracticeBonus
	addq.w	#$05,d7
	sub.w	d2,d0
Double_SpellQualityThresholdAndAdvanceTier:		; Memory Address ($67E0) and binary offset [$645C]
	; Doubles the current spell-practice threshold, advances its tier counter, and
	; loops to the next quality comparison.
	add.w	d2,d2																;Doubles the practice threshold after each band and increments the companion right-shift count.
	addq.w	#$01,d3
	bra.s	SpellCastQuality_ThresholdLoopHead

SpellCasting_ProfessionBaseBonuses:		; Memory Address ($67E6) and binary offset [$6462]
	; Four profession-indexed casting bonuses used when the selected spell class
	; matches the champion profession.
	INCBIN "/data/BLOODWYCH439-clean/data/SpellCasting_ProfessionBaseBonuses.lookup"

SpellCastQuality_ApplyPracticeBonus:		; Memory Address ($67EA) and binary offset [$6466]
	lsr.w	d3,d0
	add.w	d0,d7
	move.w	d1,d4
	bsr		Calculate_WizardLevelContribution
	add.b	d0,d7
	add.b	d0,d7
	add.b	ChampionStat_SpellPowerBoost(a4),d7
	move.w	d4,d0
	move.w	d6,d4
	bsr		Character_GetClassIndex
	move.w	d4,d6
	cmp.w	(sp)+,d0
	bne.s	SpellCastQuality_ClearHandShift
	add.w	#$0057,d0
	moveq	#$01,d1
	cmp.b	(a0),d0
	beq.s	Apply_PowerStaffSpellCastingBonus
	cmp.b	$0001(a0),d0
	beq.s	Apply_PowerStaffSpellCastingBonus
SpellCastQuality_ClearHandShift:		; Memory Address ($681A) and binary offset [$6496]
	moveq	#$00,d1
Apply_PowerStaffSpellCastingBonus:		; Memory Address ($681C) and binary offset [$6498]
	; Adds the Power Staff casting bonus when the object is held in either hand.
	move.b	$0015(a4),d0														;Loads champion byte $15, the spell cooldown penalty; matching champion and spell classes halve it.
	lsr.b	d1,d0																;Halves cooldown only when the repeated champion/spell class comparison set D1 to one.
	sub.b	d0,d7
	moveq	#PowerStaff_SpellCastingBonus,d0									;Spell-casting quality bonus supplied by a held Power Staff.
	cmp.b	#Object_PowerStaff,(a0)												;Power Staff object code.
	beq.s	SpellCastQuality_ApplyStaffBonusAndPenalty
	cmp.b	#Object_PowerStaff,$0001(a0)										;Power Staff object code.
	beq.s	SpellCastQuality_ApplyStaffBonusAndPenalty
	moveq	#$00,d0
SpellCastQuality_ApplyStaffBonusAndPenalty:		; Memory Address ($6836) and binary offset [$64B2]
	add.b	d0,d7
	sub.b	SpellCasting_SpellDifficultyPenalties(pc,d6.w),d7					;Subtracts the source difficulty-penalty byte for the selected spell before Draw_SpellCastingBar maps the negated score to the CAST bar.
	rts		

SpellCasting_SpellDifficultyPenalties:		; Memory Address ($683E) and binary offset [$64BA]
	; 32 spell-indexed difficulty penalty bytes; spell indices 0–31.
	INCBIN "/data/BLOODWYCH439-clean/data/SpellCasting_SpellDifficultyPenalties.lookup"
SpellCost_DataTable:		; Memory Address ($685E) and binary offset [$64DA]
	; Existing mapping; one base spell-cost value for each SPS 439 spell.
	INCBIN "/data/BLOODWYCH439-clean/data/SpellCasting_CostValues.lookup"
SpellCasting_CastPowerCostAdjustments:		; Memory Address ($687E) and binary offset [$64FA]
	; Additional mana costs for non-negative prepared cast-power values $00–$0D.
	INCBIN "/data/BLOODWYCH439-clean/data/SpellCasting_CastPowerCostAdjustments.lookup"

Calculate_SpellPointCost:		; Memory Address ($688C) and binary offset [$6508]
	; Calculates COST, handles charged matching rings, and normalises byte $14 to
	; costs $01–$63.
	move.l	a4,d0
	sub.l	#Character_Stats_DataTable,d0
	lsr.w	#$01,d0
	lea		Character_Pockets_DataTable.l,a0
	add.w	d0,a0
	moveq	#$00,d0
	move.b	ChampionStat_SpellToCast(a4),d0
	bsr.s	Character_GetClassIndex
	add.w	#$0069,d0
	cmp.b	(a0),d0
	beq.s	SpellPointCost_FreeRingCast
	cmp.b	$0001(a0),d0
	bne.s	SpellPointCost_ComputeAdjustment
SpellPointCost_FreeRingCast:		; Memory Address ($68B4) and binary offset [$6530]
	; Checks and consumes depletable-ring charges; a zero count still permits a
	; power-zero cast and then wraps to $FF, which later calls reject.
	sub.w	#$0069,d0
	lea		RingUses.l,a0
	tst.b	$00(a0,d0.w)
	bmi.s	SpellPointCost_ComputeAdjustment
	moveq	#$00,d0
	move.b	d0,ChampionStat_SpellPowerBoost(a4)
	rts		

SpellPointCost_ReducePowerLoop:		; Memory Address ($68CC) and binary offset [$6548]
	subq.b	#$01,ChampionStat_SpellPowerBoost(a4)
SpellPointCost_ComputeAdjustment:		; Memory Address ($68D0) and binary offset [$654C]
	move.b	ChampionStat_SpellPowerBoost(a4),d1
	ext.w	d1
	bmi.s	SpellPointCost_AddBaseCost											;Uses negative byte $14 values directly as low-cost penalties instead of indexing the non-negative extra-mana curve.
	move.b	SpellCasting_CastPowerCostAdjustments(pc,d1.w),d1
SpellPointCost_AddBaseCost:		; Memory Address ($68DC) and binary offset [$6558]
	moveq	#$00,d0
	move.b	ChampionStat_SpellToCast(a4),d0										;Loads the selected spell index from champion byte $13 before choosing its base SpellCost_DataTable entry.
	lea		SpellCost_DataTable.w,a0											;Short Absolute converted to symbol!
	move.b	$00(a0,d0.w),d0
	addq.w	#$01,d0																;Increments the stored base spell cost before doubling it, so the base contribution is twice (the table value plus one).
	add.w	d0,d0																;Doubles the adjusted base spell cost before the cast-power adjustment is added.
	add.w	d1,d0																;Adds the source cast-power curve adjustment to form the COST +nn+ value.
	bne.s	SpellPointCost_ClampToMaximum
	addq.b	#$01,ChampionStat_SpellPowerBoost(a4)								;Reverses the final decrement when cost normalisation reaches zero, preserving the one-point minimum.
	moveq	#SpellCasting_ManaCostMinimum,d0
SpellPointCost_ClampToMaximum:		; Memory Address ($68F8) and binary offset [$6574]
	cmpi.w	#SpellCasting_ManaCostMaximum,d0									;Rejects a cast-power setting when the calculated spell-point cost reaches $64; displayed costs are therefore limited to $01-$63.
	bcc.s	SpellPointCost_ReducePowerLoop
	rts		

Character_GetClassIndex:		; Memory Address ($6900) and binary offset [$657C]
	; Converts a champion or character number into one of the four class indices.
	move.w	d0,d6
	cmpi.b	#$10,d0
	bcs.s	Character_GetClassIndex_CombineBits
	not.w	d0																	;Folds spell indices $10-$1F before deriving their mirrored magic-class order.
Character_GetClassIndex_CombineBits:		; Memory Address ($690A) and binary offset [$6586]
	; Combines the character-number bit groups before applying the four-profession
	; mask.
	lsr.w	#$02,d0
	add.w	d6,d0
	and.w	#Character_ProfessionMask,d0										;Low two bits used to select one of the four character professions.
Return_CharacterOrHeldItemAction:		; Memory Address ($6912) and binary offset [$658E]
	; Shared return used by character-class calculation and rejected held-item
	; actions.
	rts		

Click_Item_17_to_1A_Potions:		; Memory Address ($6914) and binary offset [$6590]
	; Dispatches held food, counted objects and potions; potions $17-$1A are
	; removed before applying their character-stat effect.
	move.w	HeldItem_ObjectCodeOffset(a5),d0									;Reads the currently held object code.
	beq.s	Return_CharacterOrHeldItemAction
	cmpi.w	#Object_Armour_First,d0												;Exclusive upper boundary of the potion range.
	bcc.s	Return_CharacterOrHeldItemAction
	cmpi.w	#Object_Potions_First,d0											;Separates potion objects from food and counted objects.
	bcs.s	Use_FoodOrCountedObject
	sub.w	#Object_Potions_First,d0											;Converts potion object code `$17-$1A` into lookup index `0-3`.
	move.w	d0,d1
	clr.l	HeldItem_StateOffset(a5)											;Consumes the complete held potion before applying its effect.
	move.b	$000F(a5),d0
	move.b	$18(a5,d0.w),d0
	bsr		Load_ChampionStatRecord
	lea		Potion_1_SerpentSlime.l,a0
	add.w	d1,d1
	add.w	Potion_LookupTable(pc,d1.w),a0
	jsr		(a0)
	bsr		Draw_CompactStatsFrame
	bra		Refresh_HeldItemDisplay

Potion_LookupTable:		; Memory Address ($6952) and binary offset [$65CE]
	; Four relative routine offsets for Serpent Slime, Brimstone Broth, Dragon Ale
	; and Moon Elixir.
	dc.w	Potion_1_SerpentSlime-Potion_1_SerpentSlime	;0000
	dc.w	Potion_2_BrimstoneBroth-Potion_1_SerpentSlime	;001C
	dc.w	Potion_3_DragonAle-Potion_1_SerpentSlime	;0008
	dc.w	Potion_4_MoonElixir-Potion_1_SerpentSlime	;0010

Potion_1_SerpentSlime:		; Memory Address ($695A) and binary offset [$65D6]
	; Restores current hit points to the character's maximum hit points.
	move.b	ChampionStat_HitPointsMaximum(a4),ChampionStat_HitPointsCurrent(a4)	;Restores current hit points to maximum.
	rts		

Potion_3_DragonAle:		; Memory Address ($6962) and binary offset [$65DE]
	; Restores current vitality to the character's maximum vitality.
	move.b	ChampionStat_VitalityMaximum(a4),ChampionStat_VitalityCurrent(a4)	;Restores current vitality to maximum.
	rts		

Potion_4_MoonElixir:		; Memory Address ($696A) and binary offset [$65E6]
	; Restores current spell points to maximum and clears the spell cooldown.
	move.b	ChampionStat_SpellPointsMaximum(a4),ChampionStat_SpellPointsCurrent(a4)	;Restores current spell points to maximum.
	clr.b	ChampionStat_SpellCooldown(a4)										;Moon Elixir clears spell cooldown.
	rts		

Potion_2_BrimstoneBroth:		; Memory Address ($6976) and binary offset [$65F2]
	; Clears spell cooldown and restores half of each HP, vitality and spell-point
	; deficit, rounded upward.
	clr.b	ChampionStat_SpellCooldown(a4)										;Brimstone Broth clears spell cooldown.
	moveq	#ChampionStat_HitPointsCurrent,d4									;Selects the current/max hit-point pair for halfway restoration.
	bsr.s	Potion_2_RestoreStatHalfway
	moveq	#ChampionStat_VitalityCurrent,d4									;Selects the current/max vitality pair for halfway restoration.
	bsr.s	Potion_2_RestoreStatHalfway
	moveq	#ChampionStat_SpellPointsCurrent,d4									;Selects the current/max spell-point pair for halfway restoration.
Potion_2_RestoreStatHalfway:		; Memory Address ($6984) and binary offset [$6600]
	; Moves one current statistic halfway towards its following maximum-statistic
	; byte, rounding upward.
	move.b	$01(a4,d4.w),d0														;Loads the maximum value paired with the D4-selected current champion statistic.
	sub.b	$00(a4,d4.w),d0														;Calculates the deficit of the D4-selected current champion statistic.
	addq.b	#$01,d0
	lsr.b	#$01,d0
	add.b	$00(a4,d4.w),d0														;Adds half the deficit back to the D4-selected current champion statistic.
	move.b	d0,$00(a4,d4.w)														;Stores the halfway-restored D4-selected current champion statistic.
	rts		

Use_FoodOrCountedObject:		; Memory Address ($699A) and binary offset [$6616]
	; Dispatches counted objects below $05, three-stage food $05-$13 and whole
	; N'Egg food $14-$16.
	cmpi.w	#Object_Food_First,d0												;Objects below `$05` use counted-object logic.
	bcs		Click_CountedObject
	cmpi.w	#Object_Neggs_First,d0												;Separates three-stage food from whole N'Egg food.
	bcs.s	Click_PortionedFood
	moveq	#$00,d1
	sub.w	#Object_Neggs_First,d0												;Converts N'Egg object code to whole-food size index.
WholeFood_AddValueLoop:		; Memory Address ($69AE) and binary offset [$662A]
	; Adds one $42 food-value step for each N'Egg size before consuming it
	; completely.
	add.w	#Food_WholeValueStep,d1												;Adds one food-value step for each N'Egg size.
	dbra	d0,WholeFood_AddValueLoop
	moveq	#$00,d0
	bra.s	ConsumeFood_StoreRemainingObject

Click_PortionedFood:		; Memory Address ($69BA) and binary offset [$6636]
	; Consumes one third of food or drink, selects its food-value increase and
	; resolves the remaining object stage.
	moveq	#Food_DrinkPortionValue,d1											;Default portion value for Mead and Water.
	cmpi.w	#Object_Drinks_First,d0												;Separates solid-food portions from drink portions.
	bcc.s	PortionedFood_SelectNextObject
	moveq	#Food_SolidPortionValue,d1											;Selects the larger solid-food portion value.
PortionedFood_SelectNextObject:		; Memory Address ($69C4) and binary offset [$6640]
	; Starts resolution of the previous portion graphic or the empty-object result.
	move.w	d0,d2
	subq.w	#Object_Food_First,d0												;Normalises the portioned-food object code to a zero-based group offset.
	beq.s	ConsumeFood_StoreRemainingObject
PortionedFood_FindGroupStartLoop:		; Memory Address ($69CA) and binary offset [$6646]
	; Tests three-object portion groups; each group start becomes empty and other
	; stages decrement.
	subq.w	#Food_PortionGroupSize,d0											;Finds whether the selected object is the first stage of a three-object food group.
	beq.s	ConsumeFood_StoreRemainingObject
	bcc.s	PortionedFood_FindGroupStartLoop
	move.w	d2,d0
	subq.w	#$01,d0
ConsumeFood_StoreRemainingObject:		; Memory Address ($69D4) and binary offset [$6650]
	; Stores the remaining portion object, or $00 when the food has been completely
	; consumed.
	move.w	d0,HeldItem_ObjectCodeOffset(a5)									;Stores the decremented portion or empty object code.
	move.b	$000F(a5),d0
	move.b	$18(a5,d0.w),d0
	bsr		Load_ChampionStatRecord
	add.b	ChampionStat_FoodLevel(a4),d1										;Adds the consumed food value to the character's current food level.
	bcs.s	ConsumeFood_ClampLevel
	cmpi.w	#Food_LevelLimitExclusive,d1										;Tests whether food level must be clamped.
	bcs.s	ConsumeFood_StoreLevel
ConsumeFood_ClampLevel:		; Memory Address ($69F0) and binary offset [$666C]
	; Clamps food level to $C7 when addition carries or reaches the exclusive $C8
	; limit.
	move.b	#Food_LevelMaximum,d1												;Clamps food level to its maximum.
ConsumeFood_StoreLevel:		; Memory Address ($69F4) and binary offset [$6670]
	; Stores the updated food level and redraws the remaining held object.
	move.b	d1,ChampionStat_FoodLevel(a4)										;Stores the updated food level.
	move.l	screen_ptr.l,a0
	add.w	#$0B64,a0
	add.w	$000A(a5),a0
	move.w	HeldItem_ObjectCodeOffset(a5),d0									;Offset of the currently held object code in the interface state.
	bsr		ObjectGraphic
	bsr		Draw_SelectedInventorySlotFrame
	bra		Draw_FoodLevelBar

Click_CountedObject:		; Memory Address ($6A16) and binary offset [$6692]
	; Transfers one counted coin, key or arrow between the character count table
	; and the held stack.
	moveq	#$00,d7
	move.b	$000F(a5),d7
	move.b	$18(a5,d7.w),d7
	asl.b	#$04,d7
	lea		Character_Pockets_DataTable.l,a6
	add.w	d7,a6
	subq.b	#$01,$0B(a6,d0.w)
	bcc.s	Stack_ObjectFromInventory
Cancel_CountedObjectTransfer:		; Memory Address ($6A30) and binary offset [$66AC]
	; Restores a counted-object quantity when the transfer cannot proceed.
	addq.b	#$01,$0B(a6,d0.w)
	rts		

Stack_ObjectFromInventory:		; Memory Address ($6A36) and binary offset [$66B2]
	; Transfers one counted object from the champion count table to the held stack,
	; provided the held quantity is below $63.
	cmp.w	#Object_StackMaximum,HeldItem_QuantityOffset(a5)					;Offset of the held-object quantity word.
	bcc.s	Cancel_CountedObjectTransfer
	addq.w	#$01,HeldItem_QuantityOffset(a5)									;Offset of the held-object quantity word.
	bra		Redraw_Inventory

Click_ObjectInInventory:		; Memory Address ($6A46) and binary offset [$66C2]
	; Handles inventory-slot selection, counted stacks, armour restrictions, worn
	; hand armour and held-object swapping.
	moveq	#$00,d7
	move.b	$000E(a5),d7
	moveq	#$00,d0
	move.b	$18(a5,d7.w),d0
	move.w	d0,d2
	and.w	#$000F,d2
	asl.b	#$04,d0
	lea		Character_Pockets_DataTable.l,a6
	add.w	d0,a6
	lea		Character_Stats_DataTable.l,a4
	add.w	d0,d0
	add.w	d0,a4
	moveq	#$00,d0
	move.b	$000F(a5),d0
	move.w	HeldItem_ObjectCodeOffset(a5),d1									;Offset of the currently held object code in the interface state.
	beq.s	Check_BodyArmourInventorySlot
	cmpi.b	#ChampionPocket_Shield,d0											;Offset of the dedicated shield pocket.
	bne.s	Check_BodyArmourInventorySlot
	cmpi.w	#Object_SmallShields_First,d1										;First small-shield object and exclusive end of body armour.
	bcs.s	Reject_InventorySlotAction
	cmpi.w	#Object_Gloves_First,d1												;First glove object and exclusive end of all shields.
	bcc.s	Reject_InventorySlotAction
	btst	#$00,d2
	beq.s	Handle_SelectedPocketObject
	cmpi.w	#Object_LargeShields_First,d1										;First large-shield object.
	bcs.s	Handle_SelectedPocketObject
	bra.s	Reject_InventorySlotAction

Check_BodyArmourInventorySlot:		; Memory Address ($6A98) and binary offset [$6714]
	; Allows only body-armour objects $1B-$23 in the dedicated body-armour slot.
	cmpi.b	#ChampionPocket_BodyArmour,d0										;Offset of the dedicated body-armour pocket.
	bne.s	Check_WornHandArmourSlot
	tst.w	d1
	beq.s	Handle_SelectedPocketObject
	cmpi.w	#Object_Armour_First,d1												;First body-armour object and exclusive end of potions.
	bcs.s	Reject_InventorySlotAction
	cmpi.w	#Object_SmallShields_First,d1										;First small-shield object and exclusive end of body armour.
	bcs.s	Handle_SelectedPocketObject
Reject_InventorySlotAction:		; Memory Address ($6AAE) and binary offset [$672A]
	; Leaves the objects unchanged, selects the clicked inventory slot and returns.
	move.w	d7,$000E(a5)
	rts		

Check_WornHandArmourSlot:		; Memory Address ($6AB4) and binary offset [$6730]
	; Handles Chaos Gloves and other worn hand-armour exchanges involving the two
	; hand pockets.
	bcc.s	Handle_SelectedPocketObject
	cmp.w	#Object_Gloves_First,HeldItem_ObjectCodeOffset(a5)					;Offset of the currently held object code in the interface state.
	bcs.s	Unequip_WornHandArmourToEmptyHand
	cmp.w	#Object_Blades_First,HeldItem_ObjectCodeOffset(a5)					;Offset of the currently held object code in the interface state.
	bcc.s	Unequip_WornHandArmourToEmptyHand
	move.b	ChampionStat_WornHandArmour(a4),d1									;Offset of the worn hand-armour object in a champion-stat record.
	move.b	HeldItem_ObjectCodeByteOffset(a5),ChampionStat_WornHandArmour(a4)	;Offset of the low byte of the held object code.
	move.b	d1,HeldItem_ObjectCodeByteOffset(a5)								;Offset of the low byte of the held object code.
	bne.s	Handle_SelectedPocketObject
	clr.w	HeldItem_QuantityOffset(a5)											;Offset of the held-object quantity word.
	bra.s	Handle_SelectedPocketObject

Unequip_WornHandArmourToEmptyHand:		; Memory Address ($6ADC) and binary offset [$6758]
	; Moves worn hand armour into an empty hand pocket when no object is currently
	; held.
	tst.b	$00(a6,d0.w)
	bne.s	Handle_SelectedPocketObject
	tst.w	HeldItem_ObjectCodeOffset(a5)										;Offset of the currently held object code in the interface state.
	bne.s	Handle_SelectedPocketObject
	move.b	ChampionStat_WornHandArmour(a4),$00(a6,d0.w)						;Offset of the worn hand-armour object in a champion-stat record.
	clr.b	ChampionStat_WornHandArmour(a4)										;Offset of the worn hand-armour object in a champion-stat record.
Handle_SelectedPocketObject:		; Memory Address ($6AF2) and binary offset [$676E]
	; Processes the object in the selected champion pocket, including
	; counted-object pickup, merging and ordinary held-object swapping.
	moveq	#$00,d1
	move.b	$00(a6,d0.w),d1
	beq		Return_HeldCountedObjectToInventory
	cmpi.w	#Object_Food_First,d1												;First food object and exclusive end of counted objects.
	bcc		Return_HeldCountedObjectToInventory
	move.w	HeldItem_ObjectCodeOffset(a5),d3									;Offset of the currently held object code in the interface state.
	bne.s	Swap_HeldObjectForCountedStack
	move.w	d1,HeldItem_ObjectCodeOffset(a5)									;Offset of the currently held object code in the interface state.
	move.w	#$0001,HeldItem_QuantityOffset(a5)									;Offset of the held-object quantity word.
	subq.b	#$01,$0B(a6,d1.w)
	bra		Refresh_InventoryAfterObjectChange

Swap_HeldObjectForCountedStack:		; Memory Address ($6B1C) and binary offset [$6798]
	; Picks up a complete counted-object stack while placing the previously held
	; non-counted object into the pocket.
	cmpi.w	#Object_Food_First,d3												;First food object and exclusive end of counted objects.
	bcs.s	Merge_MatchingCountedObjectStack
	move.b	ChampionPocket_CountedObjectCountsOffset(a6,d1.w),HeldItem_QuantityByteOffset(a5)	;Offset of the low byte of the held-object quantity.
	clr.b	$0B(a6,d1.w)
	bra		Swap_HeldObjectWithPocket

Merge_MatchingCountedObjectStack:		; Memory Address ($6B30) and binary offset [$67AC]
	; Merges held and inventory quantities when both represent the same counted
	; object.
	cmp.w	d1,d3
	bne.s	Merge_DifferentCountedObjectStack
	move.b	$0B(a6,d1.w),d2
	add.b	HeldItem_QuantityByteOffset(a5),d2									;Offset of the low byte of the held-object quantity.
	move.b	d2,$0B(a6,d1.w)
	cmpi.b	#Object_StackLimitExclusive,d2										;Exclusive counted-object quantity limit.
	bcc.s	Clamp_MatchingCountedObjectStack
	clr.l	HeldItem_StateOffset(a5)											;Offset of the complete four-byte held-item state.
	bra.s	Refresh_InventoryAfterObjectChange

Clamp_MatchingCountedObjectStack:		; Memory Address ($6B4C) and binary offset [$67C8]
	; Clamps the merged inventory quantity to $63.
	move.b	#Object_StackMaximum,ChampionPocket_CountedObjectCountsOffset(a6,d1.w)	;Highest stored quantity for a counted object.
	bra.s	Store_CountedObjectRemainder

Merge_DifferentCountedObjectStack:		; Memory Address ($6B54) and binary offset [$67D0]
	; Adds the held quantity to its existing global count before picking up a
	; different counted stack.
	move.b	$0B(a6,d3.w),d2
	add.b	HeldItem_QuantityByteOffset(a5),d2									;Offset of the low byte of the held-object quantity.
	cmpi.b	#Object_StackLimitExclusive,d2										;Exclusive counted-object quantity limit.
	bcc.s	Clamp_CountedObjectStack
	move.b	d2,$0B(a6,d3.w)
	move.b	ChampionPocket_CountedObjectCountsOffset(a6,d1.w),HeldItem_QuantityByteOffset(a5)	;Offset of the low byte of the held-object quantity.
	clr.b	$0B(a6,d1.w)
	bra.s	Remove_DuplicateCountedObjectSlots

Clamp_CountedObjectStack:		; Memory Address ($6B72) and binary offset [$67EE]
	; Clamps a counted-object total to $63 before retaining the excess.
	move.b	#Object_StackMaximum,ChampionPocket_CountedObjectCountsOffset(a6,d3.w)	;Highest stored quantity for a counted object.
Store_CountedObjectRemainder:		; Memory Address ($6B78) and binary offset [$67F4]
	; Stores quantity remaining above the $63 inventory-count limit in the held
	; stack.
	sub.b	#Object_StackMaximum,d2												;Highest stored quantity for a counted object.
	move.b	d2,HeldItem_QuantityByteOffset(a5)									;Offset of the low byte of the held-object quantity.
	bra.s	Refresh_InventoryAfterObjectChange

Return_HeldCountedObjectToInventory:		; Memory Address ($6B82) and binary offset [$67FE]
	; Returns a held counted stack to its global character count.
	move.w	HeldItem_ObjectCodeOffset(a5),d3									;Offset of the currently held object code in the interface state.
	beq.s	Swap_HeldObjectWithPocket
	cmpi.w	#Object_Food_First,d3												;First food object and exclusive end of counted objects.
	bcc.s	Swap_HeldObjectWithPocket
	move.b	$0B(a6,d3.w),d2
	add.b	HeldItem_QuantityByteOffset(a5),d2									;Offset of the low byte of the held-object quantity.
	move.b	d2,$0B(a6,d3.w)
	cmpi.b	#Object_StackLimitExclusive,d2										;Exclusive counted-object quantity limit.
	bcc.s	Clamp_CountedObjectStack
Remove_DuplicateCountedObjectSlots:		; Memory Address ($6BA0) and binary offset [$681C]
	; Removes redundant pocket entries for a counted object after returning its
	; quantity.
	moveq	#ChampionPocket_LastIndex,d2										;Highest ordinary pocket index in the twelve-pocket scan.
Remove_DuplicateCountedObjectSlots_Loop:		; Memory Address ($6BA2) and binary offset [$681E]
	; Scans all twelve character pockets for duplicate counted-object codes.
	cmp.b	$00(a6,d2.w),d3
	bne.s	Remove_DuplicateCountedObjectSlots_Next
	clr.b	$00(a6,d2.w)
Remove_DuplicateCountedObjectSlots_Next:		; Memory Address ($6BAC) and binary offset [$6828]
	; Advances the duplicate counted-object pocket scan.
	dbra	d2,Remove_DuplicateCountedObjectSlots_Loop
Swap_HeldObjectWithPocket:		; Memory Address ($6BB0) and binary offset [$682C]
	; Stores the previous held object in the selected pocket and makes the pocket
	; object the new held object.
	move.b	d3,$00(a6,d0.w)
	move.w	d1,HeldItem_ObjectCodeOffset(a5)									;Offset of the currently held object code in the interface state.
Refresh_InventoryAfterObjectChange:		; Memory Address ($6BB8) and binary offset [$6834]
	; Refreshes selection and inventory graphics after an object transfer.
	cmp.b	#$02,$000F(a5)
	bne.s	Finalize_InventoryObjectChange
	btst	d7,$003E(a5)
	beq.s	Finalize_InventoryObjectChange
	move.w	d7,-(sp)
	bsr		Refresh_PartyShieldSlotIfDirty
	tst.w	$0002(sp)
	beq.s	Restore_SelectedInventorySlot
	bsr		Draw_PartyShieldChainStrip
Restore_SelectedInventorySlot:		; Memory Address ($6BD6) and binary offset [$6852]
	; Restores the selected slot number after auxiliary inventory handling.
	move.w	(sp)+,d7
Finalize_InventoryObjectChange:		; Memory Address ($6BD8) and binary offset [$6854]
	; Normalises held counted-object state and redraws the inventory.
	move.w	d7,$000E(a5)
	move.w	HeldItem_ObjectCodeOffset(a5),d0									;Offset of the currently held object code in the interface state.
	beq.s	Normalize_HeldNonCountedObjectQuantity
	cmpi.w	#Object_Food_First,d0												;First food object and exclusive end of counted objects.
	bcs.s	Redraw_Inventory
Normalize_HeldNonCountedObjectQuantity:		; Memory Address ($6BE8) and binary offset [$6864]
	; Sets the held quantity to one when the resulting held state is empty or
	; contains a non-counted object.
	move.w	#$0001,HeldItem_QuantityOffset(a5)									;Offset of the held-object quantity word.
	bra.s	Redraw_Inventory

Click_OpenInventory:		; Memory Address ($6BF0) and binary offset [$686C]
	; Resets the inspected party slot and draws the lower inventory background
	; before the shared inventory redraw path.
	clr.w	$000E(a5)															;Resets the inspected party-slot index to the first slot when inventory is opened.
	move.l	#$005E00E1,d4														;Sets the lower inventory background rectangle X=$E1 with DBRA width $5E, producing 95 pixels.
	move.l	#$00070040,d5														;Sets the lower inventory background rectangle at player-local Y=$40 with DBRA height $07, producing eight rows.
	add.w	$0008(a5),d5
	moveq	#$03,d3
	bsr		BW_draw_bar
Redraw_Inventory:		; Memory Address ($6C0A) and binary offset [$6886]
	; Resolves the inspected champion, redraws its twelve inventory slots, armour
	; value, name display, and held-item panel.
	move.w	$000E(a5),d7
	move.b	$18(a5,d7.w),d7														;Resolves the inspected party slot to its champion-state byte before selecting the champion record.
	and.w	#$000F,d7															;Extracts the champion ID from the low nibble of the occupied party-slot state.
	bsr		Draw_InventoryPocketSlots											;Draws the selected champion's hand, armour, shield, and eight pocket positions before title and armour text are overlaid.
	move.l	#$000D0003,CurrentTextInk.l
	bsr		Draw_InventoryArmourRating
	move.w	d7,d0
	bsr		Print_ChampionNamePanelGivenName
	move.w	#$0003,$0014(a5)													;Sets interface mode $03 so subsequent redraw paths remain in the inventory view.
Refresh_HeldItemDisplay:		; Memory Address ($6C34) and binary offset [$68B0]
	; Updates the held-item description, graphic, quantity and optional food bar.
	bsr		Draw_HeldObjectDescription
	cmp.b	#$03,$0015(a5)
	bne		Trigger_00_t00_Null
Draw_HeldItemPanel:		; Memory Address ($6C42) and binary offset [$68BE]
	; Draws the held-item panel pieces followed by the held object's pocket graphic
	; and quantity.
	or.b	#$04,$0054(a5)
	move.l	screen_ptr.l,a0
	add.w	#$0B5C,a0															;Starts the lower inventory panel at player-local X=$E0/Y=$48, after the page has supplied the shared lower chain strip.
	add.w	$000A(a5),a0
	moveq	#$00,d7																;Initialises the four-position inventory profession-icon loop.
Draw_HeldItemPanelPieces_Loop:		; Memory Address ($6C58) and binary offset [$68D4]
	; Draws the four vacant, dead, or profession-coloured party-member slot icons
	; shown beside the held-item panel.
	bsr		Draw_PartyMemberSlotIcon
	addq.w	#$01,d7
	cmpi.w	#$0004,d7
	bcs.s	Draw_HeldItemPanelPieces_Loop
	move.w	HeldItem_ObjectCodeOffset(a5),d0									;Offset of the currently held object code in the interface state.
	move.w	HeldItem_QuantityOffset(a5),d1										;Offset of the held-object quantity word.
	bsr		ObjectGraphic
	move.w	$0012(a5),d3
	moveq	#$74,d0																;Selects the fixed empty held-item pocket graphic placed after the four profession positions.
	bsr		Draw_PocketGraphic
	bsr		Draw_SelectedInventorySlotFrame										;Draws the yellow 16 by 15 selection frame around the party position stored at PlayerX_Data+$000F.
	move.w	HeldItem_ObjectCodeOffset(a5),d0									;Offset of the currently held object code in the interface state.
	beq.s	Return_FromHeldItemDisplay
	cmpi.w	#Object_Food_First,d0												;First food object and exclusive end of counted objects.
	bcs.s	Return_FromHeldItemDisplay
	cmpi.w	#Object_Potions_First,d0											;First potion object and exclusive end of food.
	bcs.s	Draw_FoodStatus
Return_FromHeldItemDisplay:		; Memory Address ($6C90) and binary offset [$690C]
	; Returns when the held item does not require the food-status display.
	rts		

Draw_FoodStatus:		; Memory Address ($6C92) and binary offset [$690E]
	; Draws the FOOD label and the food-level bar scaled against the $00-$C7 food
	; value.
	lea		FoodStatusMessageTemplate.l,a6
	bsr		Print_fflim_text
Draw_FoodLevelBar:		; Memory Address ($6C9C) and binary offset [$6918]
	; Reads champion food byte $10 and draws its bar scaled from $00 to $C7.
	or.b	#$14,$0054(a5)
	move.w	$000E(a5),d0
	move.b	$18(a5,d0.w),d0
	bsr		Load_ChampionStatRecord
	move.b	ChampionStat_FoodLevel(a4),d0										;Offset of food level in a character-stat record.
	move.w	#Food_LevelMaximum,d1												;Highest stored character food level.
	moveq	#$3A,d2
	move.l	#$0004005A,d5														;Long Addr replaced with Symbol
	add.w	$0008(a5),d5
	move.l	#$00390098,d4
	bsr		Scale_ValueToBarLength
	moveq	#$09,d3
	bra		BW_draw_bar

Draw_HeldObjectDescription:		; Memory Address ($6CD2) and binary offset [$694E]
	; Prints an empty description or prepares the selected held object's
	; description.
	move.w	HeldItem_ObjectCodeOffset(a5),d0									;Offset of the currently held object code in the interface state.
	bne.s	Prepare_HeldObjectDescription
	lea		NullString.l,a6
	bra		LowerText

Prepare_HeldObjectDescription:		; Memory Address ($6CE2) and binary offset [$695E]
	; Handles champion-remains ownership before resolving and printing the held
	; object's description.
	move.w	d0,d1
	sub.w	#Object_Remains_First,d1											;First champion-remains object.
	bcs.s	Resolve_HeldObjectDescription
	cmpi.w	#Champion_Count,d1													;Number of standard champions and champion-remains objects.
	bcc.s	Resolve_HeldObjectDescription
	move.w	d1,d0
	bsr		Find_ChampionInPlayerSlots
	move.w	HeldItem_ObjectCodeOffset(a5),d0									;Offset of the currently held object code in the interface state.
	tst.w	d1
	bmi.s	Resolve_HeldObjectDescription
	bclr	#$05,$18(a5,d1.w)
	clr.l	HeldItem_StateOffset(a5)											;Offset of the complete four-byte held-item state.
Resolve_HeldObjectDescription:		; Memory Address ($6D08) and binary offset [$6984]
	; Resolves the normal object-definition text after optional champion-remains
	; ownership handling.
	lea		Object_Definition_Table+$02.l,a6
	asl.w	#$02,d0
	add.w	d0,a6
	move.w	#$0006,CurrentTextInk.l
	bra		Print_item_desc_fresh

Draw_SelectedInventorySlotFrame:		; Memory Address ($6D1E) and binary offset [$699A]
	; Draws the highlight frame around the selected character inventory slot.
	moveq	#$0D,d3
	move.l	#$000E0049,d5														;Sets the inventory profession-selection frame's DBRA height $0E and Y=$49, one pixel below the lower strip's Y=$48 anchor.
	add.w	$0008(a5),d5
	moveq	#$0F,d4
	swap	d4
	move.b	$000F(a5),d4
	asl.w	#$04,d4
	add.w	#$00E1,d4															;Places the selection frame at X=$E1 plus sixteen pixels per selected party position.
	bra		BW_draw_frame

Update_IdlePanelAnimation:		; Memory Address ($6D3C) and binary offset [$69B8]
	; Ages the active player's idle timer and alternates the default-panel
	; animation when it expires.
	subq.b	#$01,$0055(a5)
	bpl.s	IdlePanelAnimation_CheckPanelView
IdlePanelAnimation_EarlyReturn:		; Memory Address ($6D42) and binary offset [$69BE]
	rts		

IdlePanelAnimation_CheckPanelView:		; Memory Address ($6D44) and binary offset [$69C0]
	tst.b	$0015(a5)
	bne.s	IdlePanelAnimation_EarlyReturn
	or.b	#$04,$0054(a5)
	move.l	screen_ptr.l,a0
	add.w	$000A(a5),a0
	add.w	#$097C,a0
	lea		GFX_Pockets+$6A60.l,a1
	btst	#$00,(a5)
	bne.s	IdlePanelAnimation_DrawFrame
	lea		$0020(a1),a1
IdlePanelAnimation_DrawFrame:		; Memory Address ($6D6E) and binary offset [$69EA]
	move.l	#$00020016,d5														;Long Addr replaced with Symbol
	move.l	#$00000088,a3
	bra		Draw_PlanarGraphic

Arrow_Highlights_Y_Offsets:		; Memory Address ($6D7E) and binary offset [$69FA]
	dc.w	$0050	;0050
	dc.w	$0268	;0268
	dc.w	$01D8	;01D8
	dc.w	$0180	;0180
	dc.w	$0000	;0000
	dc.w	$00E0	;00E0
Arrow_Highlights_X_Positions:		; Memory Address ($6D8A) and binary offset [$6A06]
	dc.w	$00A0	;00A0
	dc.w	$0284	;0284
	dc.w	$02D0	;02D0
	dc.w	$0280	;0280
	dc.w	$00A0	;00A0
	dc.w	$00A2	;00A2
Arrow_Highlights_Offsets:		; Memory Address ($6D96) and binary offset [$6A12]
	dc.b	$01	;01
	dc.b	$08	;08
	dc.b	$00	;00
	dc.b	$0A	;0A
	dc.b	$01	;01
	dc.b	$08	;08
	dc.b	$00	;00
	dc.b	$0A	;0A
	dc.b	$00	;00
	dc.b	$09	;09
	dc.b	$01	;01
	dc.b	$09	;09

Draw_Arrow_Highlights:		; Memory Address ($6DA2) and binary offset [$6A1E]
	; Draws the temporary highlight for one of the six movement controls using
	; direction-specific destination, source-offset, width and height tables, then
	; restores the normal pad after its countdown expires.
	tst.b	$0015(a5)
	bne		Return_PartyCommandRowIdle
	or.b	#$04,$0054(a5)
	move.b	#$81,$0055(a5)
	move.l	screen_ptr.l,a0
	add.w	$000A(a5),a0
	add.w	#$08DC,a0
	add.w	d0,d0
	add.w	Arrow_Highlights_X_Positions(pc,d0.w),a0
	lea		GFX_ButtonHighlights.l,a1
	add.w	Arrow_Highlights_Y_Offsets(pc,d0.w),a1
	moveq	#$00,d5
	moveq	#$00,d3
	move.b	Arrow_Highlights_Offsets(pc,d0.w),d5
	move.b	d5,d3
	swap	d5
	move.b	Arrow_Highlights_Offsets+$01(pc,d0.w),d5
	addq.w	#$01,d3
	add.w	d3,d3
	swap	d3
	bra		Draw_WallSprite_Normal

Click_MoveForwards:		; Memory Address ($6DEE) and binary offset [$6A6A]
	moveq	#$00,d0
	bra.s	_MoveParty

Click_MoveBackwards:		; Memory Address ($6DF2) and binary offset [$6A6E]
	moveq	#$02,d0
	bra.s	_MoveParty

Click_MoveLeft:		; Memory Address ($6DF6) and binary offset [$6A72]
	moveq	#$03,d0
	bra.s	_MoveParty

Click_MoveRight:		; Memory Address ($6DFA) and binary offset [$6A76]
	moveq	#$01,d0
_MoveParty:		; Memory Address ($6DFC) and binary offset [$6A78]
	; Draws the movement highlight, calculates the destination cell, and dispatches
	; the party movement and collision handling.
	and.b	#$01,(a5)
	move.w	d0,-(sp)
	bsr.s	Draw_Arrow_Highlights
	move.w	(sp)+,d6
	move.l	$001C(a5),d7
	add.w	$0020(a5),d6
	and.w	#$0003,d6
	bsr		Try_EnterMapCell
	bcc		Process_PlayerMoveDestination
	cmp.w	d0,d2
	bne.s	Return_PlayerMoveRejected
	move.w	$00(a6,d0.w),d1
	and.w	#Dungeon_CellTypeMask,d1											;Retains the three-bit cell type while ignoring map-cell flags.
	cmpi.w	#MapCell_StairsType,d1												;Selects the stair transition path.
	bne.s	Return_PlayerMoveRejected
	move.b	$00(a6,d0.w),d1
	lsr.b	#$01,d1
	eor.b	#Direction_OppositeMask,d1											;Reverses the stored stair facing to obtain the permitted travel direction.
	cmp.b	d1,d6
	beq		Begin_PlayerStairTransition
Return_PlayerMoveRejected:		; Memory Address ($71C0) and binary offset [$6E3C]
	; Shared rejected-player-move return after destination entry fails or the
	; resolved target is not a usable stair transition.
	rts		

Process_PlayerMoveDestination:		; Memory Address ($71C2) and binary offset [$6E3E]
	; Player-only continuation after Try_EnterMapCell; processes type-6/type-7
	; destination effects, stairs, trigger state, redraw/load work, then stores
	; player position.
	move.w	$00(a6,d0.w),d1
	and.w	#$0007,d1
	subq.w	#$06,d1
	bcs.s	Refresh_AfterPlayerMove
	beq.s	Process_PlayerMoveFloorFeature
	move.b	$00(a6,d0.w),d1
	move.w	d1,d2
	and.w	#$0003,d2
	subq.w	#$01,d2
	bne.s	Refresh_AfterPlayerMove
	move.l	d7,$001C(a5)
	movem.w	d0/d1,-(sp)
	moveq	#$05,d1
	bsr		Find_HighestRankedPartyMemberByCategory
	movem.w	(sp)+,d0/d1
	tst.w	d3
	bpl.s	Return_PlayerMoveRejected
	lsr.b	#$02,d1
	move.w	d1,d7
	movem.l	d0/a6,-(sp)
	bsr		Roll_AndStagePartyDamage
	movem.l	(sp)+,d0/a6
	move.l	a5,-(sp)
	move.l	a5,a1
	clr.w	ResistanceCheckPower.w												;Short Absolute converted to symbol!
	bsr		Apply_PartyDamage
	move.l	(sp)+,a5
	rts		

Process_PlayerMoveFloorFeature:		; Memory Address ($6E90) and binary offset [$6B0C]
	; A6/D0: type-6 destination. Subtype 0 clears living champions worn spells;
	; subtype 1 skips trigger dispatch; subtypes 2/3 execute the pad.
	move.b	$00(a6,d0.w),d1														;Read the destination floor feature's subtype byte.
	and.w	#$0003,d1															;Keep the subtype, excluding ceiling-hole and trigger-reference bits.
	bne.s	Dispatch_PlayerMoveTriggerPad										;Subtypes other than spell-fizzle continue to the pit/pad check.
	bsr		Clear_PartyWornSpellsOnFloorTransition								;Remove worn spells from the party's living champions.
	bra.s	Refresh_AfterPlayerMove												;Continue the normal destination refresh.

Dispatch_PlayerMoveTriggerPad:		; Memory Address ($6EA0) and binary offset [$6B1C]
	; D1: nonzero floor subtype. Skip pit subtype 1; dispatch visible/invisible
	; pads 2/3 using the destination in A6/D0.
	subq.w	#$01,d1																;Test for the pit subtype after excluding spell-fizzle.
	beq.s	Refresh_AfterPlayerMove												;A pit does not dispatch a trigger here.
	bsr		Execute_FloorTrigger												;Execute the visible or invisible trigger pad at A6/D0.
Refresh_AfterPlayerMove:		; Memory Address ($722C) and binary offset [$6EA8]
	; Reloads the destination map position, handles stair setup where required,
	; then continues to player-position storage.
	movem.l	d0/d7/a6,-(sp)
	bsr		Refresh_CurrentChampionMapPositionIcon
	movem.l	(sp)+,d0/d7/a6
	move.w	$00(a6,d0.w),d1
	and.w	#Dungeon_CellTypeMask,d1											;Retains the three-bit cell type while ignoring map-cell flags.
	cmpi.w	#MapCell_StairsType,d1												;Selects the stair transition path.
	bne		Store_PlayerMovePosition
	moveq	#$00,d6
	move.b	$00(a6,d0.w),d6
	lsr.b	#$01,d6
	eor.b	#Direction_OppositeMask,d6											;Reverses the stored stair facing to obtain the permitted travel direction.
Begin_PlayerStairTransition:		; Memory Address ($6ED0) and binary offset [$6B4C]
	; Clears the source stair occupancy and derives the destination floor from the
	; stair direction.
	bclr	#MapCell_OccupiedBit,$01(a6,d0.w)									;Map-cell occupied flag updated when a player changes floor.
	move.w	PlayerData_Floor(a5),d2												;Player record word selecting the active floor, not a map-cell offset.
	move.w	d2,d1
	addq.w	#$01,d1
	btst	#Stair_DownBit,$00(a6,d0.w)											;A clear bit ascends one floor; a set bit descends one floor.
	beq.s	Resolve_PlayerStairDestination
	subq.w	#$02,d1
Resolve_PlayerStairDestination:		; Memory Address ($6EE8) and binary offset [$6B64]
	; Calculates the paired stair coordinate and tests whether the destination is
	; occupied.
	bsr		Compute_StairAlignedDestination
	move.w	d1,d0
	bsr		Select_FloorMapByIndex
	lea		MovementOffsetTable.w,a0											;Short Absolute converted to symbol!
	add.b	MovementOffset_YTableOffset(a0,d6.w),d7								;Each addition advances one cell in Y; the consecutive pair advances two cells.
	add.b	MovementOffset_YTableOffset(a0,d6.w),d7								;Each addition advances one cell in Y; the consecutive pair advances two cells.
	swap	d7
	add.b	$00(a0,d6.w),d7														;Each addition advances one cell in X; the consecutive pair advances two cells.
	add.b	$00(a0,d6.w),d7														;Each addition advances one cell in X; the consecutive pair advances two cells.
	swap	d7
	bsr		CoordToMap
	tst.b	$01(a6,d0.w)														;Tests only the occupied flag at the landing; no matching-stair type or direction is required by this check.
	bpl.s	Commit_PlayerStairTransition
	bsr		Select_ActivePlayerFloorMap											;Restores the old player floor geometry when the landing is occupied; the player floor has not yet been committed.
	bsr		PlayerPositionToMapOffset
	bset	#MapCell_OccupiedBit,$01(a6,d0.w)									;Map-cell occupied flag updated when a player changes floor.
	rts		

Commit_PlayerStairTransition:		; Memory Address ($6F24) and binary offset [$6BA0]
	; Stores the new floor, occupancy, facing and packed player coordinate after
	; stair movement.
	move.w	d1,PlayerData_Floor(a5)												;Player record word selecting the active floor, not a map-cell offset.
	bset	#MapCell_OccupiedBit,$01(a6,d0.w)									;Map-cell occupied flag updated when a player changes floor.
	move.b	$00(a6,d0.w),d0														;Uses the landing cell first byte as the source of the new facing, even for intentionally nonstandard stair destinations.
	lsr.b	#$01,d0
	move.b	d0,PlayerData_Direction+1(a5)										;Stores the landing-cell direction in the low byte of the player facing word.
Store_PlayerMovePosition:		; Memory Address ($72BC) and binary offset [$6F38]
	; Stores the accepted player X/Y position and clears active avatar-presentation
	; state when necessary.
	move.l	d7,$001C(a5)
	tst.b	$003E(a5)
	beq.s	Check_PlayerMoveTeamPad
	clr.b	$003E(a5)															;After a successful movement, clears all four avatar presentation bits and redraws the party-command interface when presentation state was active.
	bsr		Draw_PartyCommandInterface
Check_PlayerMoveTeamPad:		; Memory Address ($72CE) and binary offset [$6F4A]
	; Checks the resulting player destination against the team-pad/party-avatar
	; state before returning.
	move.w	PlayerData_PartyCommandState(a5),d0									;Checks party-command state after movement; negative and states below eight return, rather than testing a map pad.
	bmi.s	Return_PlayerMoveProcessed
	cmpi.w	#$0008,d0
	bcc		Click_ShowTeamAvatars
Return_PlayerMoveProcessed:		; Memory Address ($72DC) and binary offset [$6F58]
	; Return after accepted player movement and destination processing.
	rts		

Click_RotateLeft:		; Memory Address ($6F5A) and binary offset [$6BD6]
	subq.w	#$01,$0020(a5)
	and.w	#$0003,$0020(a5)
	moveq	#$04,d0
	bra.s	Execute_Rotation

Click_RotateRight:		; Memory Address ($6F68) and binary offset [$6BE4]
	addq.w	#$01,$0020(a5)
	and.w	#$0003,$0020(a5)
	moveq	#$05,d0
Execute_Rotation:		; Memory Address ($6F74) and binary offset [$6BF0]
	bsr		Draw_Arrow_Highlights
	bsr		PlayerPositionToMapOffset
	bra		Refresh_AfterPlayerMove

Clear_PartyWornSpellsOnFloorTransition:		; Memory Address ($6F80) and binary offset [$6BFC]
	; Clears worn spells from every present party member after stair or team-pad
	; travel, then redraws the party commands.
	movem.l	d0/d7/a6,-(sp)														;Save the movement cell, coordinates and map base.
	moveq	#$03,d7																;Start with the last of the four party slots.
Clear_PartyWornSpells_NextSlot:		; Memory Address ($6F86) and binary offset [$6C02]
	move.b	$18(a5,d7.w),d1														;Read this party slot's champion number and state flags.
	move.w	d1,d0																;Pass the champion number to the stat-record lookup.
	and.w	#PartyShieldStatusBar_SuppressionMask,d1							;Keep flags that identify dead or unavailable party slots.
	bne.s	Clear_PartyWornSpells_Continue										;Skip a slot without a living champion.
	bsr		Load_ChampionStatRecord												;Resolve the living champion's stat record in A4.
	clr.b	ChampionStat_WornSpell(a4)											;Remove this champion's worn spell.
Clear_PartyWornSpells_Continue:		; Memory Address ($6F9A) and binary offset [$6C16]
	dbra	d7,Clear_PartyWornSpells_NextSlot									;Repeat for the remaining party slots.
	bsr		Draw_PartyCommandInterface											;Redraw the party command panel after removing worn spells.
	movem.l	(sp)+,d0/d7/a6														;Restore the movement cell, coordinates and map base.
	rts																			;Return to destination processing.

Trigger_WaitFlag:		; Memory Address ($6FA8) and binary offset [$6C24]
	; Pending trigger delay word; $FFFF means no delayed action, while small
	; positive values defer sound/effect completion.
	dc.w	$FFFF	;FFFF

Execute_FloorTrigger:		; Memory Address ($6FAA) and binary offset [$6C26]
	; Reads the current floor-trigger record and dispatches its even action byte
	; through the 31-entry trigger-action table.
	move.w	#TriggerSound_None,Trigger_WaitFlag.w								;Default to no sound after this trigger.
	move.b	$00(a6,d0.w),d1														;Read the destination floor feature's first byte.
	and.w	#FloorFeature_SubtypeMask,d1										;Keep the visible/invisible pad subtype.
	subq.w	#FloorFeature_VisiblePadSubtype,d1									;Test for a visible green pad.
	bne.s	Resolve_FloorTriggerRecord											;Invisible pads retain the no-sound default.
	clr.w	Trigger_WaitFlag.w													;Visible pads default to the switch-click sound.
Resolve_FloorTriggerRecord:		; Memory Address ($6FC0) and binary offset [$6C3C]
	move.b	$00(a6,d0.w),d1														;Read the pad's encoded trigger reference.
	and.w	#FloorTrigger_IndexMask,d1											;Keep trigger-reference bits 3-7.
	lsr.b	#$01,d1																;Convert the reference to a four-byte record offset.
	lea		TriggersData_1.l,a1													;Start from the Keep's trigger definitions.
	move.w	CurrentTower.l,d2													;Read the current tower number.
	asl.w	#FloorTrigger_TowerStrideShift,d2									;Select its 128-byte trigger-record block.
	add.w	d2,a1																;Advance to this tower's trigger definitions.
	moveq	#$00,d2																;Clear the action accumulator before loading one byte.
	move.b	$00(a1,d1.w),d2														;Read the action byte, already a word-table byte offset.
	cmpi.b	#TriggerAction_VivifyExternal,d2									;Check for the external Vivify pad action.
	beq.s	Select_TriggerSpellSound											;Use the alternative spell sound for this Vivify action.
	cmpi.b	#TriggerAction_VivifyInternal,d2									;Check for the internal Vivify pad action.
	beq.s	Select_TriggerSpellSound											;Use the alternative spell sound for this Vivify action.
	cmpi.b	#TriggerAction_FlashTeleport,d2										;Check for the flashing teleport action.
	bne.s	Dispatch_TriggerAndPlaySound										;Other actions keep the pad's default sound.
Select_TriggerSpellSound:		; Memory Address ($6FF2) and binary offset [$6C6E]
	move.w	#Sound_AlternativeSpell,Trigger_WaitFlag.w							;Select the alternative spell sound for this effect.
Dispatch_TriggerAndPlaySound:		; Memory Address ($6FF8) and binary offset [$6C74]
	lea		Trigger_00_t00_Null.l,a0											;Load the base used by the signed handler displacements.
	add.w	Triggers_LookupTable(pc,d2.w),a0									;Add the displacement selected by the action byte.
	movem.l	d0/d7/a6,-(sp)														;Save the movement cell, packed X/Y and map base for the return path.
	jsr		(a0)																;Run the selected trigger with A1/D1 selecting its record.
	move.w	Trigger_WaitFlag.w,d0												;Read the sound selected by the pad or its handler.
	bmi.s	Restore_TriggerMovementState										;A negative sound selector suppresses playback.
	bsr		PlaySound															;Play the selected sound once the handler finishes.
Restore_TriggerMovementState:		; Memory Address ($7012) and binary offset [$6C8E]
	movem.l	(sp)+,d0/d7/a6														;Restore the saved movement state, including any teleport edits to it.
Trigger_00_t00_Null:		; Memory Address ($7016) and binary offset [$6C92]
	; Null floor-trigger action; performs no map or player change.
	rts																			;Return without another trigger action.

Triggers_LookupTable:		; Memory Address ($7018) and binary offset [$6C94]
	dc.w	Trigger_00_t00_Null-Trigger_00_t00_Null	;0000
	dc.w	Trigger_01_t02_Spinner180-Trigger_00_t00_Null	;06FC
	dc.w	Trigger_02_t04_SpinnerRandom-Trigger_00_t00_Null	;0704
	dc.w	Switch_03_s06_Trigger_03_t06_OpenLockedDoor_XY-Trigger_00_t00_Null	;0730
	dc.w	Trigger_04_t08_Vivify_Machine_External-Trigger_00_t00_Null	;07EA
	dc.w	Trigger_05_t0A_Vivify_Machine_Internal-Trigger_00_t00_Null	;08DA
	dc.w	Trigger_06_t0C_WoodTrap1-Trigger_00_t00_Null	;06BC
	dc.w	Trigger_07_t0E_WoodTrap2-Trigger_00_t00_Null	;06D4
	dc.w	Trigger_08_t10_Trader_DoorCloser-Trigger_00_t00_Null	;06EC
	dc.w	Trigger_09_t12_Tower_Entrance_SidePad-Trigger_00_t00_Null	;043E
	dc.w	Trigger_10_t14_Tower_Entrance_CentrePad-Trigger_00_t00_Null	;03D0
	dc.w	Switch_01_s02_Trigger_11_t16_RemoveXY-Trigger_00_t00_Null	;ECFC
	dc.w	Trigger_12_t18_Close_VoidLock_Door_XY-Trigger_00_t00_Null	;071E
	dc.w	Switch_05_s0A_Trigger_13_t1A_TogglePillar_XY-Trigger_00_t00_Null	;0756
	dc.w	Trigger_14_t1C_SetFloorTypeBits_XY-Trigger_00_t00_Null	;0768

	dc.w	Trigger_15_t1E_CreateWall_XY-Trigger_00_t00_Null	;ECE2
	dc.w	Trigger_16_t20_ToggleNeighbourFloorType-Trigger_00_t00_Null	;0780
	dc.w	Trigger_17_t22_MovePillar_NorthWestToNorth-Trigger_00_t00_Null	;07C0
	dc.w	Switch_06_s0C_Trigger_18_t24_CreatePillar_XY-Trigger_00_t00_Null	;0752

	dc.w	Trigger_19_t26_Keep_Entrance_SidePad-Trigger_00_t00_Null	;0370
	dc.w	Trigger_20_t28_Keep_Entrance_CentrePad-Trigger_00_t00_Null	;0340
	dc.w	Trigger_21_t2A_Flash_Teleport_FXY-Trigger_00_t00_Null	;0670
	dc.w	Switch_04_s08_Trigger_22_t2C_RotateWall_XY-Trigger_00_t00_Null	;069E

	dc.w	Switch_02_s04_Trigger_23_t2E_ToggleWall_XY-Trigger_00_t00_Null	;ECE6
	dc.w	Trigger_24_t30_SpinnerRight90-Trigger_00_t00_Null	;0712
	dc.w	Trigger_25_t32_Teleport_FXY-Trigger_00_t00_Null	;0626
	dc.w	Trigger_26_t34_ToggleFloorTypeBits_XY-Trigger_00_t00_Null	;0774

	dc.w	Trigger_Action36_RotateWoodEdges-Trigger_00_t00_Null	;0742
	dc.w	Trigger_Action38_ToggleCellTypeLowBits-Trigger_00_t00_Null	;061A
	dc.w	Trigger_29_t3A_GameCompletion-Trigger_00_t00_Null	;0504
	dc.w	Trigger_30_t3C_RemoveXY_IfPuzzleBitsSet-Trigger_00_t00_Null	;04EC
TriggersData_1:		; Memory Address ($7056) and binary offset [$6CD2]
	INCBIN "/data/BLOODWYCH439-clean/maps/mod0.triggers"
TriggersData_2:		; Memory Address ($70D6) and binary offset [$6D52]
	INCBIN "/data/BLOODWYCH439-clean/maps/serp.triggers"
TriggersData_3:		; Memory Address ($7156) and binary offset [$6DD2]
	INCBIN "/data/BLOODWYCH439-clean/maps/moon.triggers"
TriggersData_4:		; Memory Address ($71D6) and binary offset [$6E52]
	INCBIN "/data/BLOODWYCH439-clean/maps/drag.triggers"
TriggersData_5:		; Memory Address ($7256) and binary offset [$6ED2]
	INCBIN "/data/BLOODWYCH439-clean/maps/chaos.triggers"
TriggersData_6:		; Memory Address ($72D6) and binary offset [$6F52]
	INCBIN "/data/BLOODWYCH439-clean/maps/zendik.triggers"

Trigger_20_t28_Keep_Entrance_CentrePad:		; Memory Address ($7356) and binary offset [$6FD2]
	; Handles the single-player tower-to-Keep entrance pad, selecting the
	; destination Keep floor and midpoint from current-tower lookup tables.
	tst.w	MultiPlayer.l														;Test the game mode before using the central return pad.
	beq		Return_TowerEntrance												;Two-party mode uses the paired side pads instead.
	pea		$00(a1,d1.w)														;Save the trigger-record address across tower-state packing.
	bsr		Pack_CurrentTowerMonsterBlock										;Save outgoing tower state and finish its pending effects.
	move.l	(sp)+,a2															;Recover the trigger-record address in A2.
	move.w	CurrentTower.l,d2													;Use the tower being left to select the Keep arrival pair.
	moveq	#$00,d1																;Clear the destination-floor accumulator.
	move.b	Keep_Start_Floors_DataTable(pc,d2.w),d1								;Read the Keep arrival floor for this tower.
	asl.w	#$02,d2																;Convert the tower number to a four-byte arrival-pair offset.
	lea		Keep_Start_XY_DataTable.l,a0										;Load the Keep arrival coordinate table.
	add.w	d2,a0																;Select this tower's two Keep arrival positions.
	moveq	#$00,d0																;Select tower zero, the Keep.
	bra		Enter_TowerAtArrivalMidpoint										;Move the party to the midpoint of the arrival pair.

Trigger_19_t26_Keep_Entrance_SidePad:		; Memory Address ($7386) and binary offset [$7002]
	tst.w	MultiPlayer.l														;Test the game mode before using a side return pad.
	bne		Return_TowerEntrance												;Single-party mode uses the central return pad instead.
	pea		$00(a1,d1.w)														;Save the trigger-record address while checking the opposite pad.
	bsr		Resolve_ActionTargetXY												;Resolve the opposite pad's X/Y on the active floor.
	bsr		Resolve_DiagonalCellAndFindOccupant									;Find the occupant of that map cell.
	bcc.s	Return_KeepEntrancePartnerMissing									;Do nothing if no occupant was found.
	tst.b	d0																	;Distinguish a player party from a champion or monster.
	bmi.s	Prepare_KeepEntranceArrivalPair										;Continue only when a player party occupies the opposite pad.
Return_KeepEntrancePartnerMissing:		; Memory Address ($73A2) and binary offset [$701E]
	addq.w	#$04,sp																;Discard the saved record pointer after a failed partner check.
	rts																			;Return without changing towers.

Prepare_KeepEntranceArrivalPair:		; Memory Address ($73A6) and binary offset [$7022]
	move.l	a1,-(sp)															;Save the partner party's record pointer.
	bsr		Pack_CurrentTowerMonsterBlock										;Save outgoing tower state and finish its pending effects.
	movem.l	(sp)+,a1/a2															;Restore partner party A1 and trigger record A2.
	move.w	CurrentTower.l,d2													;Select the Keep arrival pair for the tower being left.
	moveq	#$00,d1																;Clear the destination-floor accumulator.
	move.b	Keep_Start_Floors_DataTable(pc,d2.w),d1								;Read this tower's Keep arrival floor.
	asl.w	#$02,d2																;Convert the tower number to a four-byte arrival-pair offset.
	lea		Keep_Start_XY_DataTable.l,a0										;Load the Keep arrival coordinate table.
	add.w	d2,a0																;Select the two arrival positions.
	moveq	#$00,d0																;Start with the first arrival position in the Keep.
	bra		Enter_TowerAtPairedArrivals											;Move both parties to the paired arrival positions.

Keep_Start_Floors_DataTable:		; Memory Address ($73CC) and binary offset [$7048]
	INCBIN "/data/BLOODWYCH439-clean/maps/keep.floors"
Keep_Start_XY_DataTable:		; Memory Address ($73CE) and binary offset [$704A]
	INCBIN "/data/BLOODWYCH439-clean/maps/keep.entrances"

Trigger_10_t14_Tower_Entrance_CentrePad:		; Memory Address ($73E6) and binary offset [$7062]
	; Handles the single-player Keep-to-tower entrance pad, using trigger-record
	; byte 1 to select the authored tower and midpoint.
	tst.w	MultiPlayer.l														;Test the game mode before using the central entrance pad.
	beq		Return_TowerEntrance												;Two-party mode uses the paired side pads instead.
	pea		$00(a1,d1.w)														;Save the trigger-record address across tower-state packing.
	bsr		Pack_CurrentTowerMonsterBlock										;Save outgoing tower state and finish its pending effects.
	move.l	(sp)+,a2															;Recover the trigger-record address in A2.
	moveq	#$00,d0																;Clear the destination-pair accumulator.
	move.b	$0001(a2),d0														;Read BB as the arrival-pair byte offset, not a floor number.
	lea		Tower_Start_XY_DataTable.l,a0										;Load the tower arrival coordinate pairs.
	moveq	#$00,d1																;New towers are entered on floor zero.
Enter_TowerAtArrivalMidpoint:		; Memory Address ($7408) and binary offset [$7084]
	moveq	#$00,d2																;Clear the packed destination coordinates.
	move.b	$00(a0,d0.w),d2														;Read the first arrival X coordinate.
	add.b	$02(a0,d0.w),d2														;Add the second arrival X coordinate.
	lsr.w	#$01,d2																;Halve the summed coordinate to place the party midway between arrivals.
	swap	d2																	;Place X in the high word.
	move.b	$01(a0,d0.w),d2														;Read the first arrival Y coordinate.
	add.b	$03(a0,d0.w),d2														;Add the second arrival Y coordinate.
	lsr.w	#$01,d2																;Halve the summed coordinate to place the party midway between arrivals.
	move.l	d2,$001C(a5)														;Store the party's new packed X/Y.
	move.w	d1,$0058(a5)														;Store the destination floor.
	lsr.b	#$02,d0																;Convert the arrival-pair byte offset to a tower number.
	move.w	d0,CurrentTower.l													;Make that tower current.
	bsr		Select_CurrentTowerMapData											;Select the destination tower's map data.
	bsr		Select_ActivePlayerFloorMap											;Load geometry for the party's destination floor.
	bsr		PlayerPositionToMapOffset											;Resolve the party's new X/Y to its map cell.
	move.l	d0,$0004(sp)														;Replace the dispatcher's saved cell offset with the arrival cell.
	move.l	$001C(a5),$0008(sp)													;Replace the dispatcher's saved X/Y with the arrival coordinates.
	move.l	a6,$000C(sp)														;Replace the dispatcher's saved map base with the destination tower.
	bset	#$07,$01(a6,d0.w)													;Mark the arrival cell occupied.
	bra		UnpackTowerMonsters													;Load the destination tower's live monsters and return.

Trigger_09_t12_Tower_Entrance_SidePad:		; Memory Address ($7454) and binary offset [$70D0]
	tst.w	MultiPlayer.l														;Test the game mode before checking the opposite side pad.
	bmi.s	Return_TowerEntrance												;A negative mode value suppresses this entrance.
	pea		$00(a1,d1.w)														;Save the trigger-record address while checking the opposite pad.
	bsr		Resolve_ActionTargetXY												;Resolve the opposite pad's X/Y on the active floor.
	bsr		Resolve_DiagonalCellAndFindOccupant									;Find the occupant of that map cell.
	bcc.s	Discard_TowerEntranceRecord											;Do nothing if no occupant was found.
	tst.b	d0																	;Distinguish a player party from a champion or monster.
	bmi.s	Prepare_TowerEntranceArrivalPair									;Continue only when a player party occupies the opposite pad.
Discard_TowerEntranceRecord:		; Memory Address ($746E) and binary offset [$70EA]
	addq.w	#$04,sp																;Discard the saved record pointer after a failed partner check.
Return_TowerEntrance:		; Memory Address ($7470) and binary offset [$70EC]
	rts																			;Return without changing towers.

Prepare_TowerEntranceArrivalPair:		; Memory Address ($7472) and binary offset [$70EE]
	move.l	a1,-(sp)															;Save the partner party's record pointer.
	bsr		Pack_CurrentTowerMonsterBlock										;Save outgoing tower state and finish its pending effects.
	movem.l	(sp)+,a1/a2															;Restore partner party A1 and trigger record A2.
	moveq	#$00,d0																;Clear the arrival-position accumulator.
	move.b	$0001(a2),d0														;Read BB as the arrival-side index.
	add.w	d0,d0																;Convert that index to a two-byte X/Y-pair offset.
	lea		Tower_Start_XY_DataTable.l,a0										;Load the tower arrival coordinate pairs.
	moveq	#$00,d1																;New towers are entered on floor zero.
Enter_TowerAtPairedArrivals:		; Memory Address ($748C) and binary offset [$7108]
	move.b	$00(a0,d0.w),$001D(a5)												;Store the active party's arrival X byte.
	move.b	$01(a0,d0.w),$001F(a5)												;Store the active party's arrival Y byte.
	move.w	d1,$0058(a5)														;Store the active party's destination floor.
	eor.b	#$02,d0																;Select the other side of the arrival pair.
	move.b	$00(a0,d0.w),$001D(a1)												;Store the partner party's arrival X byte.
	move.b	$01(a0,d0.w),$001F(a1)												;Store the partner party's arrival Y byte.
	move.w	d1,$0058(a1)														;Store the partner party's destination floor.
	lsr.b	#$02,d0																;Convert the arrival-pair byte offset to a tower number.
	move.w	d0,CurrentTower.l													;Make that tower current.
	bsr		Select_CurrentTowerMapData											;Select the destination tower's map data.
	bsr		Select_ActivePlayerFloorMap											;Load geometry for the destination floor.
	bsr		PlayerPositionToMapOffset											;Resolve the arrival cell of the party currently selected by A5.
	move.l	d0,$0004(sp)														;Replace the dispatcher's saved cell offset with the arrival cell.
	move.l	$001C(a5),$0008(sp)													;Replace the dispatcher's saved X/Y with the arrival coordinates.
	move.l	a6,$000C(sp)														;Replace the dispatcher's saved map base with the destination tower.
	bset	#$07,$01(a6,d0.w)													;Mark this party's arrival cell occupied.
	exg		a1,a5																;Temporarily select the partner party, then restore the active party.
	bsr		PlayerPositionToMapOffset											;Resolve the arrival cell of the party currently selected by A5.
	bset	#$07,$01(a6,d0.w)													;Mark this party's arrival cell occupied.
	exg		a1,a5																;Temporarily select the partner party, then restore the active party.
	bra		UnpackTowerMonsters													;Load the destination tower's live monsters and return.

Tower_Start_XY_DataTable:		; Memory Address ($74EA) and binary offset [$7166]
	INCBIN "/data/BLOODWYCH439-clean/data/tower.entrances"

Trigger_30_t3C_RemoveXY_IfPuzzleBitsSet:		; Memory Address ($7502) and binary offset [$717E]
	; For action $3C, tests the paired authored gate cells and removes the record's
	; target only after both gate flag bits are set.
	move.l	Current_TowerMapDataBase.l,a6										;Load the current tower's map-cell data base.
	move.b	$0014(a6),d0														;Read the first fixed puzzle cell's first byte at offset $14.
	and.b	$001C(a6),d0														;Keep bits also set in the second fixed cell's first byte at offset $1C.
	btst	#$00,d0																;Test whether both fixed cells have bit zero set.
	bne		Switch_01_s02_Trigger_11_t16_RemoveXY								;If both bits are set, remove the record's X/Y target.
	rts																			;Otherwise leave the target unchanged.

Trigger_29_t3A_GameCompletion:		; Memory Address ($751A) and binary offset [$7196]
	; Handles action $3A by running the complete game-ending picture,
	; party-interface reset, text, and frame-synchronisation sequence.
	move.l	a5,-(sp)
	bsr.s	GameEndPicture
	clr.w	FrameSyncFlag.l
	bsr		Swap_DisplayAndDrawBuffers
	bsr		Copy_DrawBufferToDisplayBuffer
	moveq	#$4B,d0
DBFWait1d:		; Memory Address ($752E) and binary offset [$71AA]
	dbra	d1,DBFWait1d
	dbra	d0,DBFWait1d
	lea		Player1_Data.l,a5
	bsr		Clear_LowerTextStrip
	lea		NullString.l,a6
	bsr		WriteText
	tst.w	MultiPlayer.l
	bne.s	.Player2Skip
	lea		Player2_Data.l,a5
	bsr		Clear_LowerTextStrip
	lea		NullString.l,a6
	bsr		WriteText
.Player2Skip:		; Memory Address ($7566) and binary offset [$71E2]
	bsr		Swap_DisplayAndDrawBuffers
	bsr		Copy_DrawBufferToDisplayBuffer
	move.w	#$FFFF,FrameSyncFlag.l
GameCompletion_WaitForFrameSync:		; Memory Address ($7576) and binary offset [$71F2]
	tst.b	FrameSyncFlag.l
	bne.s	GameCompletion_WaitForFrameSync
	move.l	(sp)+,a5
	rts		

GameEndPicture:
	; Resets both players' applicable interface state, redraws the party and
	; bordered message presentation, and draws the ending picture used by the
	; game-completion trigger.
	lea		Player1_Data.l,a5
	tst.w	MultiPlayer.l
	bne.s	.GameEnd_repeat
	bsr.s	.GameEnd_repeat
	lea		Player2_Data.l,a5
.GameEnd_repeat:
	clr.w	$0014(a5)
	move.w	#$FFFF,$0042(a5)
	bsr		Draw_PartyCommandInterface
	bsr		Draw_ChampionNamePanelFrame
	bsr		Draw_ViewportMessageFrame
	movem.l	d0-d7/a0-a6,-(sp)
	link	a3,#-$0020
	move.l	screen_ptr.l,a0
	add.w	$000A(a5),a0
	add.w	#$01EC,a0
	move.l	a0,-$0008(a3)
	clr.b	-$0015(a3)
	moveq	#$00,d0
	moveq	#$00,d1
	moveq	#$28,d5
	moveq	#$36,d4
	bsr		Draw_Entropy
	unlk	a3
	lea		AccursedBloodwychMsg.l,a6
	bsr		WriteText
	lea		CongratsText.l,a6
	bsr		LowerText
	movem.l	(sp)+,d0-d7/a0-a6
	rts		

AccursedBloodwychMsg:
	dc.b	'ACCURSED BLOODWYCH! WE SHALL MEET AGAIN'
	dc.b	$FF	;FF
CongratsText:
	dc.b	$FE	;FE
	dc.b	$0B	;0B
	dc.b	'CONGRATULATIONS!'
	dc.b	$FF	;FF
	dc.b	$00	;00

Trigger_Action38_ToggleCellTypeLowBits:		; Memory Address ($7630) and binary offset [$72AC]
	; Trigger action $38 XORs bits 0-1 of the target map cell type while preserving
	; the other cell bits.
	bsr		Resolve_ActionTargetXY												;Resolve the record's X/Y to A6/D0 on the active floor.
	eor.b	#FloorFeature_SubtypeMask,$00(a6,d0.w)								;Flip subtype bits 0-1; ceiling-hole and reference bits stay unchanged.
	rts																			;Return after changing the target's first byte.

Trigger_25_t32_Teleport_FXY:		; Memory Address ($763C) and binary offset [$72B8]
	; Teleports to the trigger record's floor/X/Y destination, falling back one
	; cell north when the target cell is occupied.
	moveq	#$00,d0																;Clear the destination-floor accumulator.
	move.b	$01(a1,d1.w),d0														;Read the destination floor from BB.
	move.w	d0,d6																;Keep the destination floor for the eventual player update.
	bsr		Select_FloorMapByIndex												;Load destination-floor geometry without yet moving the player.
	bsr		Resolve_ActionTargetXY												;Resolve the record's destination X/Y on that floor.
	tst.b	$01(a6,d0.w)														;Test this candidate destination for an occupied cell.
	bpl.s	Commit_TeleportWithoutFlash											;Commit this candidate destination if it is free.
	subq.w	#$01,d7																;Try the cell one step north when the requested cell is occupied.
	bsr		CoordToMap															;Resolve that alternate X/Y to its map cell.
	tst.b	$01(a6,d0.w)														;Test this candidate destination for an occupied cell.
	bpl.s	Commit_TeleportWithoutFlash											;Commit this candidate destination if it is free.
	rts																			;Both destinations are occupied; leave the player position unchanged.

Commit_TeleportWithoutFlash:		; Memory Address ($7660) and binary offset [$72DC]
	bsr.s	Commit_PlayerTeleportDestination									;Commit the destination and rewrite the dispatcher's saved movement state.
	rts																			;Return without adding the teleport flash.

Commit_PlayerTeleportDestination:		; Memory Address ($7664) and binary offset [$72E0]
	; Updates map occupancy and writes the active player's teleported floor and
	; packed coordinate.
	bset	#$07,$01(a6,d0.w)													;Mark the destination cell occupied.
	move.l	TriggerTeleportStack_CellOffset(sp),d1								;Read the departure cell offset saved by the trigger dispatcher.
	bclr	#$07,$01(a6,d1.w)													;Clear the departure cell's occupied flag.
	move.w	d6,$0058(a5)														;Store the destination floor in the player record.
	move.l	d7,$001C(a5)														;Store the destination X/Y in the player record.
	move.l	d7,TriggerTeleportStack_PackedXYOffset(sp)							;Replace the dispatcher's saved X/Y with the destination coordinates.
	move.l	d0,TriggerTeleportStack_CellOffset(sp)								;Replace the dispatcher's saved cell offset with the destination cell.
	rts																			;Return to the teleport handler; A6 still addresses the same tower.

Trigger_21_t2A_Flash_Teleport_FXY:		; Memory Address ($7686) and binary offset [$7302]
	; Performs the flash teleport to the record's floor/X/Y destination, falling
	; back one cell east when occupied and queueing the associated impact effect.
	moveq	#$00,d0																;Clear the destination-floor accumulator.
	move.b	$01(a1,d1.w),d0														;Read the destination floor from BB.
	move.w	d0,d6																;Keep the destination floor for the eventual player update.
	bsr		Select_FloorMapByIndex												;Load destination-floor geometry without yet moving the player.
	bsr		Resolve_ActionTargetXY												;Resolve the record's destination X/Y on that floor.
	tst.b	$01(a6,d0.w)														;Test this candidate destination for an occupied cell.
	bpl.s	Commit_TeleportAndQueueFlash										;Commit this candidate destination if it is free.
	addq.w	#$02,d0																;Try the next map cell when the requested cell is occupied.
	swap	d7																	;Swap coordinate words around the alternate destination X adjustment.
	addq.w	#$01,d7																;Move the alternate destination one step east.
	swap	d7																	;Swap coordinate words around the alternate destination X adjustment.
	tst.b	$01(a6,d0.w)														;Test this candidate destination for an occupied cell.
	bpl.s	Commit_TeleportAndQueueFlash										;Commit this candidate destination if it is free.
	rts																			;Both destinations are occupied; leave the player position unchanged.

Commit_TeleportAndQueueFlash:		; Memory Address ($76AC) and binary offset [$7328]
	bsr.s	Commit_PlayerTeleportDestination									;Commit the destination and rewrite the dispatcher's saved movement state.
	moveq	#CellEffect_TeleportFlash,d7										;Select the teleport-flash effect code.
	bra		Queue_MapCellEffect													;Queue the flash at the destination and return.

Switch_04_s08_Trigger_22_t2C_RotateWall_XY:		; Memory Address ($76B4) and binary offset [$7330]
	; Resolves the trigger target and advances its two direction bits by one
	; quarter-turn while preserving the other cell flags.
	bsr		Resolve_ActionTargetXY												;Resolve the record's X/Y to A6/D0 on the active floor.
	move.b	$01(a6,d0.w),d1														;Read the target wall's facing and flags.
	move.w	d1,d2																;Save a copy so unrelated flags can be preserved.
	and.b	#StoneWall_FacingPreserveMask,d2									;Clear only the wall-facing bits in that copy.
	add.w	#StoneWall_FacingStep,d1											;Advance the wall facing by one quarter turn.
	and.w	#StoneWall_FacingMask,d1											;Wrap the new facing within its two-bit field.
	or.b	d1,d2																;Combine the new facing with the preserved flags.
	move.b	d2,$01(a6,d0.w)														;Write the updated facing and flags to the target.
	rts																			;Return after rotating the wall feature.

Trigger_06_t0C_WoodTrap1:		; Memory Address ($76D2) and binary offset [$734E]
	; Applies the first fixed wooden-trap map mutation to its authored target
	; cells.
	move.l	#$000D000C,d7														;Select the fixed first wood-trap location X=13, Y=12.
	bsr		CoordToMap															;Resolve that location on the currently loaded floor.
	bset	#$02,$00(a6,d0.w)													;Set the east-edge bit at the first cell.
	bclr	#$06,$02(a6,d0.w)													;Clear the west-edge bit at its eastern neighbour.
	rts																			;Return after changing the paired wooden edges.

Trigger_07_t0E_WoodTrap2:		; Memory Address ($76EA) and binary offset [$7366]
	; Applies the second fixed wooden-trap map mutation to its authored target
	; cells.
	move.l	#$00030000,d7														;Select the fixed second wood-trap location X=3, Y=0.
	bsr		CoordToMap															;Resolve that location on the currently loaded floor.
	bclr	#$02,$00(a6,d0.w)													;Clear the east-edge bit at the first cell.
	bset	#$06,$02(a6,d0.w)													;Set the west-edge bit at its eastern neighbour.
	rts																			;Return after changing the paired wooden edges.

Trigger_08_t10_Trader_DoorCloser:		; Memory Address ($7702) and binary offset [$737E]
	; Closes the trader's target door when the doorway is not occupied.
	subq.w	#$02,d0																;Select the map cell immediately west of the trigger.
	tst.b	$01(a6,d0.w)														;Test that cell's occupied flag.
	bmi.s	Return_TraderDoorCloser												;Do not close the door while the cell is occupied.
	bset	#$00,$00(a6,d0.w)													;Set the north-edge closed bit of the wooden door.
Return_TraderDoorCloser:		; Memory Address ($7710) and binary offset [$738C]
	rts																			;Return after the trader-door check.

Trigger_01_t02_Spinner180:		; Memory Address ($7712) and binary offset [$738E]
	; Rotates the activating player's facing by 180 degrees.
	eor.w	#Direction_HalfTurn,$0020(a5)										;Reverse the party's facing by 180 degrees.
	rts																			;Return with the party still on the same cell.

Trigger_02_t04_SpinnerRandom:		; Memory Address ($771A) and binary offset [$7396]
	; Sets the activating player's facing to a pseudo-random direction from 0 to 3.
	bsr		RandomGen_BytewithOffset											;Get the next random value for the spinner.
	and.w	#Direction_Mask,d0													;Reduce it to one of the four compass directions.
	move.w	d0,$0020(a5)														;Store the new party facing.
	rts																			;Return with the party still on the same cell.

Trigger_24_t30_SpinnerRight90:		; Memory Address ($7728) and binary offset [$73A4]
	; Rotates the activating player's facing 90 degrees to the right.
	addq.w	#$01,$0020(a5)														;Turn the party one quarter turn to the right.
	and.w	#Direction_Mask,$0020(a5)											;Wrap the facing from west back to north.
	rts																			;Return with the party still on the same cell.

Trigger_12_t18_Close_VoidLock_Door_XY:		; Memory Address ($7734) and binary offset [$73B0]
	; Resolves the target cell, closes its Voidlock door, and applies the one-step
	; trigger delay.
	bsr		Resolve_ActionTargetXY												;Resolve the record's X/Y to A6/D0 on the active floor.
	bset	#$00,$00(a6,d0.w)													;Set the metal door's closed bit without changing its lock field.
	move.w	#Sound_DoorClick,Trigger_WaitFlag.w									;Request the door-click sound after trigger dispatch.
	rts																			;Return after closing the target door.

Switch_03_s06_Trigger_03_t06_OpenLockedDoor_XY:		; Memory Address ($7746) and binary offset [$73C2]
	; Resolves the target cell, opens its locked door, and applies the one-step
	; trigger delay.
	bsr		Resolve_ActionTargetXY												;Resolve the record's X/Y to A6/D0 on the active floor.
	bclr	#$00,$00(a6,d0.w)													;Clear the metal door's closed bit without changing its lock field.
	move.w	#Sound_DoorClick,Trigger_WaitFlag.w									;Request the door-click sound after trigger dispatch.
	rts																			;Return after opening the target door.

Trigger_Action36_RotateWoodEdges:		; Memory Address ($7758) and binary offset [$73D4]
	; Trigger action $36 rotates the four two-bit wooden-edge fields in the target
	; cell byte by one side.
	bsr		Resolve_ActionTargetXY												;Resolve the record's X/Y to A6/D0 on the active floor.
	move.b	$00(a6,d0.w),d1														;Read the four two-bit wooden-edge definitions.
	ror.b	#WoodEdges_QuarterTurnBits,d1										;Rotate every edge one side counterclockwise.
	move.b	d1,$00(a6,d0.w)														;Write the rotated edge definitions back.
	rts																			;Return after rotating the wooden walls and doors.

Switch_06_s0C_Trigger_18_t24_CreatePillar_XY:		; Memory Address ($7768) and binary offset [$73E4]
	; Clears the record target through the shared removal path, then creates the
	; target pillar using the shared pillar-state handler.
	bsr		Switch_01_s02_Trigger_11_t16_RemoveXY								;Remove the target feature before falling through to create a pillar.
Switch_05_s0A_Trigger_13_t1A_TogglePillar_XY:		; Memory Address ($776C) and binary offset [$73E8]
	; Resolves the target cell, sets its feature base state, and toggles the low
	; pillar-state bits.
	bsr		Resolve_ActionTargetXY												;Resolve the record's X/Y to A6/D0 on the active floor.
	move.b	#$01,$00(a6,d0.w)													;Set the target's first byte to the pillar form.
	eor.b	#$03,$01(a6,d0.w)													;Toggle type bits 0-1, normally switching space and pillar.
	rts																			;Return after changing the target pillar state.

Trigger_14_t1C_SetFloorTypeBits_XY:		; Memory Address ($777E) and binary offset [$73FA]
	; Creates a pad at the record's target by preserving the first byte and setting
	; feature-type bits 1 and 2 in the second byte.
	bsr		Resolve_ActionTargetXY												;Resolve the record's X/Y to A6/D0 on the active floor.
	or.b	#MapCell_FloorFeatureType,$01(a6,d0.w)								;Set type bits 1-2; retain the first byte and all other flags.
	rts																			;Return after setting the target's floor-feature type bits.

Trigger_26_t34_ToggleFloorTypeBits_XY:		; Memory Address ($778A) and binary offset [$7406]
	; Resolves the target cell and toggles second-byte feature bits 1 and 2 for
	; action $34.
	bsr		Resolve_ActionTargetXY												;Resolve the record's X/Y to A6/D0 on the active floor.
	eor.b	#MapCell_FloorFeatureType,$01(a6,d0.w)								;Toggle type bits 1-2; BB, first-byte subtype and reference stay unchanged.
	rts																			;Return after toggling the target type bits.

Trigger_16_t20_ToggleNeighbourFloorType:		; Memory Address ($7796) and binary offset [$7412]
	; Uses record byte 1 to select a neighbouring direction and toggles that cell's
	; pad-type bits, removing the original target when the neighbour cannot be
	; changed.
	moveq	#$00,d6																;Clear the direction accumulator.
	move.b	$01(a1,d1.w),d6														;Read BB as a movement-vector index, not a floor number.
	move.w	d1,-(sp)															;Save the trigger-record offset while decoding the current cell.
	bsr		Resolve_DiagonalPillarSourceCell									;Recover the triggering cell's floor and packed X/Y.
	move.w	(sp)+,d1															;Restore the trigger-record offset for the fallback target.
	move.l	d2,d7																;Use the triggering cell as the movement origin.
	lea		MovementOffsetTable.w,a0											;Load the signed X/Y movement vectors.
	add.b	$08(a0,d6.w),d7														;Apply the direction's Y step to the triggering cell.
	cmp.w	CurrentFloorHeight.l,d7												;Compare the resulting Y with the active floor height.
	bcc		Switch_01_s02_Trigger_11_t16_RemoveXY								;An out-of-bounds neighbour removes the record target instead.
	swap	d7																	;Swap coordinate words around the neighbour X adjustment.
	add.b	$00(a0,d6.w),d7														;Apply the direction's X step to the triggering cell.
	cmp.w	CurrentFloorWidth.l,d7												;Compare the resulting X with the active floor width.
	bcc		Switch_01_s02_Trigger_11_t16_RemoveXY								;An out-of-bounds neighbour removes the record target instead.
	swap	d7																	;Swap coordinate words around the neighbour X adjustment.
	bsr		CoordToMap															;Resolve the in-bounds neighbouring cell.
	eor.b	#MapCell_FloorFeatureType,$01(a6,d0.w)								;Toggle that neighbour's type bits 1-2.
	rts																			;Return without changing floors or moving the player.

Trigger_17_t22_MovePillar_NorthWestToNorth:		; Memory Address ($77D6) and binary offset [$7452]
	; Moves a pillar from the northwest diagonal cell to the north cell relative to
	; the activating pad.
	bsr		Resolve_DiagonalPillarSourceCell									;Recover the triggering cell's floor and packed X/Y.
	move.l	d2,d7																;Use the triggering cell as the puzzle origin.
	subq.b	#$01,d7																;Subtract one from Y first, then from X, to visit north then northwest.
	bsr		CoordToMap															;Resolve the selected puzzle cell on the active floor.
	and.w	#MapCell_ClearFeatureWordMask,$00(a6,d0.w)							;Clear its first byte and type, preserving second-byte flags.
	or.w	#MapCell_PillarWord,$00(a6,d0.w)									;Create a pillar at that northern cell.
	swap	d7																	;Swap coordinate words around the northwest X adjustment.
	subq.b	#$01,d7																;Subtract one from Y first, then from X, to visit north then northwest.
	swap	d7																	;Swap coordinate words around the northwest X adjustment.
	bsr		CoordToMap															;Resolve the selected puzzle cell on the active floor.
	and.w	#MapCell_ClearFeatureWordMask,$00(a6,d0.w)							;Clear its first byte and type, preserving second-byte flags.
	rts																			;Return after moving the puzzle pillar from northwest to north.

Trigger_04_t08_Vivify_Machine_External:		; Memory Address ($7800) and binary offset [$747C]
	; Runs the external Vivify machine: enforces its raster gate, creates the
	; impact, finds matching remains, and revives or relocates the affected unowned
	; or owned champion at the machine target.
	addq.w	#$02,d0																;Advance east one cell: first to the doorway, then to the revival cell.
	tst.b	$01(a6,d0.w)														;Test that cell's occupied flag.
	bmi		Trigger_00_t00_Null													;Leave the machine unchanged if its doorway is occupied.
	bset	#$00,$00(a6,d0.w)													;Set the doorway's closed bit.
	addq.w	#$02,d0																;Advance east one cell: first to the doorway, then to the revival cell.
VivifyExternal_SearchRevivalCell:		; Memory Address ($7812) and binary offset [$748E]
	move.w	#CellEffect_Vivify,d7												;Select the Vivify cell-effect code.
	bsr		Queue_MapCellEffect													;Queue the machine effect at the revival cell.
	tst.b	$01(a6,d0.w)														;Test whether the revival cell is occupied.
	bmi.s	Return_VivifyExternalNoRemains										;Do not place another champion in an occupied cell.
	btst	#$06,$01(a6,d0.w)													;Test whether the cell has any ground objects.
	beq.s	Return_VivifyExternalNoRemains										;Return if there are no remains to search.
	moveq	#$03,d4																;Start with the last of four object-stack corners.
VivifyExternal_FindCornerStack:		; Memory Address ($782A) and binary offset [$74A6]
	move.w	d4,d6																;Pass this corner number to the object-stack lookup.
	bsr		Find_FloorObjectStackAtCellSubposition								;Find the object stack at the revival cell and corner.
	beq.s	VivifyExternal_PrepareRemainsScan									;Search a matching stack for champion remains.
VivifyExternal_NextCorner:		; Memory Address ($7832) and binary offset [$74AE]
	dbra	d4,VivifyExternal_FindCornerStack									;Try the next corner when no suitable remains were found.
Return_VivifyExternalNoRemains:		; Memory Address ($7836) and binary offset [$74B2]
	rts																			;Return without reviving a champion from ground remains.

VivifyExternal_PrepareRemainsScan:		; Memory Address ($7838) and binary offset [$74B4]
	lea		$03(a0,d7.w),a1														;Point A1 at the matching stack's object-code/quantity pairs.
	moveq	#$00,d3																;Clear the object-pair offset accumulator.
	move.b	-$0001(a1),d3														;Read the stack's last object-pair index.
	add.w	d3,d3																;Convert the index to a two-byte pair offset.
VivifyExternal_CheckRemainsCode:		; Memory Address ($7844) and binary offset [$74C0]
	move.b	$00(a1,d3.w),d2														;Read this object's code from the stack.
	sub.b	#Object_ChampionRemainsFirst,d2										;Convert remains codes starting at $40 to champion numbers.
	bcs.s	VivifyExternal_PreviousObject										;Codes below $40 are not champion remains.
	cmpi.b	#Champion_Count,d2													;Check that the champion number is within the sixteen champions.
	bcs.s	VivifyExternal_ConsumeRemains										;Use this remains object when its champion number is valid.
VivifyExternal_PreviousObject:		; Memory Address ($7854) and binary offset [$74D0]
	subq.w	#$02,d3																;Step back to the preceding object pair.
	bcc.s	VivifyExternal_CheckRemainsCode										;Continue until the first object pair has been checked.
	bra.s	VivifyExternal_NextCorner											;Try another corner after exhausting this stack.

VivifyExternal_ConsumeRemains:		; Memory Address ($785A) and binary offset [$74D6]
	bset	#$07,$01(a6,d0.w)													;Reserve the revival cell by marking it occupied.
	move.w	d2,-(sp)															;Save the champion number while removing its remains.
	bsr		Remove_FloorObjectStackEntry										;Remove the selected remains object from the ground stack.
	bsr		Resolve_DiagonalPillarSourceCell									;Recover the revival cell's floor and packed X/Y.
	move.w	d1,d3																;Keep the revival floor for the champion or party update.
	move.w	(sp)+,d0															;Recover the champion number.
	and.w	#$000F,d0															;Keep only the champion-number bits.
	move.l	a5,-(sp)															;Save the party that activated the machine.
	bsr		Find_ChampionOwner													;Find which player party contains this champion, if any.
	tst.w	d1																	;Test the returned party-slot index.
	bpl.s	Restore_VivifiedOwnedChampionToParty								;Handle a champion already associated with a player party.
	move.l	(sp)+,a5															;Restore the activating party for an unassigned champion.
Restore_VivifiedExternalChampionAtTarget:		; Memory Address ($787E) and binary offset [$74FA]
	; Restores an unowned champion record at the Vivify target coordinate, facing,
	; floor, and current tower.
	bsr		Load_ChampionStatRecord												;Resolve this champion's stat record in A4.
	move.b	d2,ChampionStat_YPosition(a4)										;Store the revival Y coordinate.
	swap	d2																	;Bring the revival X coordinate into the low word.
	move.b	d2,ChampionStat_XPosition(a4)										;Store the revival X coordinate.
	move.b	d3,ChampionStat_Floor(a4)											;Store the revival floor.
	move.b	#$03,ChampionStat_Direction(a4)										;Face the revived champion west.
	move.b	CurrentTower+$01.l,ChampionStat_Tower(a4)							;Stores the current tower in the revived champion record.
	rts																			;Return after placing the champion at the revival cell.

Restore_VivifiedOwnedChampionToParty:		; Memory Address ($78A0) and binary offset [$751C]
	; Clears the owned champion's dead state and either restores a party slot or
	; promotes and relocates the player leader.
	bclr	#$06,$18(a5,d1.w)													;Clear the dead flag in the champion's party slot.
	tst.w	d1																	;Check whether the revived champion is the party leader.
	beq.s	VivifyExternal_InstallRevivedLeader									;A revived leader takes the party to the revival cell.
	btst	#$06,$0018(a5)														;Check whether the existing party leader is dead.
	bne.s	VivifyExternal_ReplaceDeadLeader									;Replace a dead leader with the revived champion.
	bsr.s	Restore_VivifiedExternalChampionAtTarget							;Place a revived non-leader at the machine as a champion record.
	bra.s	VivifyExternal_RefreshParty											;Refresh the party panels after revival.

VivifyExternal_ReplaceDeadLeader:		; Memory Address ($78B6) and binary offset [$7532]
	move.b	$0018(a5),$18(a5,d1.w)												;Move the former leader into the revived champion's old slot.
	move.w	d0,$0006(a5)														;Make the revived champion the selected champion.
VivifyExternal_InstallRevivedLeader:		; Memory Address ($78C0) and binary offset [$753C]
	move.b	d0,$0018(a5)														;Put the revived champion in the leader slot.
	bset	#$04,$0018(a5)														;Set the leader slot's active-party flag.
	move.l	d2,$001C(a5)														;Move the party to the revival X/Y.
	move.w	d3,$0058(a5)														;Store the party's revival floor.
	move.w	#$0003,$0020(a5)													;Face the revived party west.
	move.b	d0,$0026(a5)														;Put the revived champion first in the displayed champion order.
	bsr		Draw_ChampionNamePanelFrame											;Redraw the selected champion's name panel.
	clr.b	$0056(a5)															;Clear the party's byte at +$56 after replacing the leader.
VivifyExternal_RefreshParty:		; Memory Address ($78E4) and binary offset [$7560]
	bsr		Draw_PartyCommandInterface											;Redraw the party command panel.
	bsr		Refresh_ModeDependentChampionDisplay								;Refresh the party's champion display after revival.
	move.l	(sp)+,a5															;Restore the party that activated the machine.
	rts																			;Return from the external Vivify action.

Trigger_05_t0A_Vivify_Machine_Internal:		; Memory Address ($78F0) and binary offset [$756C]
	; Revives a dead member of the caster's own party with current HP and vitality
	; set to 5 and restores the champion to an available formation slot.
	subq.w	#$02,d0																;Select the doorway immediately west of the internal pad.
	bset	#$00,$00(a6,d0.w)													;Set the doorway's closed bit.
	addq.w	#$02,d0																;Return the cell offset to the internal pad.
VivifyInternal_ReviveOwnPartyMembers:		; Memory Address ($78FA) and binary offset [$7576]
	; Queues the Vivify impact and sound, revives eligible dead members of the
	; active party, and redraws the party interface.
	move.w	#CellEffect_Vivify,d7												;Select the Vivify cell-effect code.
	bsr		Queue_MapCellEffect													;Queue the machine effect at the internal pad.
	moveq	#Sound_AlternativeSpell,d0											;Select the alternative spell sound.
	bsr		PlaySound															;Play the revival sound here, before scanning the party.
	move.w	#TriggerSound_None,Trigger_WaitFlag.w								;Suppress the dispatcher's later sound to avoid playing it twice.
	moveq	#$03,d0																;Start with the last of the four party slots.
VivifyInternal_ReviveNextSlot:		; Memory Address ($7910) and binary offset [$758C]
	tst.b	$18(a5,d0.w)														;Read this party slot's sign flag.
	bmi.s	VivifyInternal_FinishParty											;Skip an empty slot.
	btst	#$05,$18(a5,d0.w)													;Test the slot's unavailable flag.
	bne.s	VivifyInternal_FinishParty											;Skip unavailable slots.
	bclr	#$06,$18(a5,d0.w)													;Clear the dead flag, retaining its old value for the branch.
	beq.s	VivifyInternal_FinishParty											;Skip champions who were already alive.
	move.w	d0,-(sp)															;Save the party-slot index while looking up the champion.
	move.b	$18(a5,d0.w),d0														;Read the champion number and remaining slot flags.
	bsr		Load_ChampionStatRecord												;Resolve the champion's stat record in A4.
	move.b	#$05,ChampionStat_VitalityCurrent(a4)								;Restore five vitality points.
	move.b	#$05,ChampionStat_HitPointsCurrent(a4)								;Restore five hit points.
	move.w	(sp)+,d0															;Recover the party-slot index.
	moveq	#$03,d1																;Search the displayed champion order from its last slot.
VivifyInternal_FindDisplaySlot:		; Memory Address ($7940) and binary offset [$75BC]
	tst.b	$26(a5,d1.w)														;Test for a free display-order slot.
	bmi.s	VivifyInternal_InsertDisplayChampion								;Use the first free slot found by the backward scan.
	dbra	d1,VivifyInternal_FindDisplaySlot									;Continue searching the four display-order slots.
	moveq	#$00,d1																;If none is free, replace display-order slot zero.
VivifyInternal_InsertDisplayChampion:		; Memory Address ($794C) and binary offset [$75C8]
	and.b	#$0F,$18(a5,d0.w)													;Remove party-state flags, leaving just the champion number.
	move.b	$18(a5,d0.w),$26(a5,d1.w)											;Insert the revived champion into the selected display-order slot.
VivifyInternal_FinishParty:		; Memory Address ($7958) and binary offset [$75D4]
	dbra	d0,VivifyInternal_ReviveNextSlot									;Repeat for all remaining party slots.
	move.w	#$FFFF,$0042(a5)													;Reset the party-command state after revival.
	move.w	#$FFFF,$0040(a5)													;Reset the companion party-command state word.
	clr.b	$003E(a5)															;Clear avatar presentation state.
	bsr		Draw_PartyCommandInterface											;Redraw the party command panel.
	bra		Refresh_ModeDependentChampionDisplay								;Refresh the party's champion display and return.

Pack_CurrentTowerMonsterBlock:		; Memory Address ($7974) and binary offset [$75F0]
	; Serialises the live monster records into the current tower's compact monster
	; block and stores its last live-record index.
	bsr		Maintain_MonsterGroupFormation
	move.w	CurrentTower.l,d0
	move.w	d0,d1
	add.w	d0,d0
	add.w	d0,d1
	asl.w	#PackedMonster_TowerBlockShift,d1
	lea		MonsterBlock_mod0.l,a3
	add.w	d1,a3
	lea		UnpackedMonsters.l,a4
	move.w	LiveActorRecord_CountOffset(a4),d1
	lea		MonsterTotalsCounts_mod0.l,a0
	move.w	d1,$00(a0,d0.w)
	bmi.s	PackTowerBlock_ClearImpactListInit
	move.l	a3,a0
	move.w	#PackedMonster_TowerBlockLongwordCount-1,d0
	moveq	#-$01,d2
PackTowerBlock_FillNegativeOnesLoop:		; Memory Address ($79AC) and binary offset [$7628]
	move.l	d2,(a0)+
	dbra	d0,PackTowerBlock_FillNegativeOnesLoop
	move.l	a3,a0
PackTowerBlock_WriteRecordsLoop:		; Memory Address ($79B4) and binary offset [$7630]
	move.b	ActorRecord_BehaviourType(a4),d2
	asl.b	#$04,d2
	move.b	ActorRecord_Floor(a4),d3
	addq.w	#$01,d3
	and.w	#$000F,d3
	or.b	d2,d3
	move.b	d3,(a3)+
	move.b	ActorRecord_XPosition(a4),(a3)+
	move.b	ActorRecord_YPosition(a4),(a3)+
	move.b	MonsterRecord_BaseLevel(a4),(a3)+
	move.b	ActorRecord_Form(a4),(a3)+
	move.b	MonsterRecord_TeamGroupIndex(a4),d3
	bmi.s	PackTowerBlock_AdvanceRecordLoop
	lea		MonsterTeamIndexTable.l,a6
	asl.w	#$02,d3
	add.w	d3,a6
	moveq	#MonsterTeamMember_Count-1,d2
PackTowerBlock_TeamMemberLoop:		; Memory Address ($79EA) and binary offset [$7666]
	moveq	#$00,d0
	move.b	$00(a6,d2.w),d0
	bmi.s	PackTowerBlock_TeamMemberLoopStep
	add.b	d0,d0
	add.b	$00(a6,d2.w),d0
	add.w	d0,d0
	move.b	d3,d4
	add.b	d2,d4
	move.b	d4,PackedMonster_TeamDataOffset(a0,d0.w)
PackTowerBlock_TeamMemberLoopStep:		; Memory Address ($7A02) and binary offset [$767E]
	dbra	d2,PackTowerBlock_TeamMemberLoop
PackTowerBlock_AdvanceRecordLoop:		; Memory Address ($7A06) and binary offset [$7682]
	addq.w	#$01,a3
	add.w	#$0010,a4
	dbra	d1,PackTowerBlock_WriteRecordsLoop
PackTowerBlock_ClearImpactListInit:		; Memory Address ($7A10) and binary offset [$768C]
	lea		MapCellImpactList.l,a0
	move.l	Current_TowerMapDataBase.l,a6
	move.w	-$0002(a0),d7
	clr.w	-$0002(a0)
	bra.s	PackTowerBlock_ClearImpactListCheck

PackTowerBlock_ClearImpactListLoop:		; Memory Address ($7A26) and binary offset [$76A2]
	move.w	(a0),d0
	bclr	#$05,$01(a6,d0.w)
	clr.l	(a0)+
PackTowerBlock_ClearImpactListCheck:		; Memory Address ($7A30) and binary offset [$76AC]
	dbra	d7,PackTowerBlock_ClearImpactListLoop
Pack_CurrentTowerMonsterBlock_DecayMagicLoop:		; Memory Address ($7A34) and binary offset [$76B0]
	tst.w	LinkedMagicRecordListLength.l
	beq.s	Pack_CurrentTowerMonsterBlock_Return
	bsr		Decay_LinkedMagicRecords
	bra.s	Pack_CurrentTowerMonsterBlock_DecayMagicLoop

Pack_CurrentTowerMonsterBlock_Return:		; Memory Address ($7A42) and binary offset [$76BE]
	rts		

Try_EnterMapCell:		; Memory Address ($7DC8) and binary offset [$7A44]
	; Shared traversal gate for player, monster and map-targeting callers:
	; validates destination bounds/type/wood edge and commits source/destination
	; occupancy bit 7 only on success.
	move.l	d7,d5
	bsr		CoordToMap
	move.w	d0,d2
	bsr		Check_WoodCellTraversal
	bcs		Restore_TraversalStateAndReturn
	move.w	d6,d0
	bsr		AdjacentCoordToMapOffset
	cmp.w	CurrentFloorHeight.l,d7
	bcc.s	Reject_MapCellEntry
	swap	d7
	cmp.w	CurrentFloorWidth.l,d7
	bcc.s	Reject_MapCellEntry
	swap	d7
	move.b	$01(a6,d0.w),d1
	bpl.s	Evaluate_MapCellTraversalType
	and.w	#$0007,d1
	subq.b	#$01,d1
	beq.s	Reject_MapCellEntry
	subq.b	#$01,d1
	bne.s	Restore_TraversalStateAndReturn
	eor.w	#$0002,d6
	bsr.s	Test_WoodTraversalEdge
	bcs.s	Reverse_TraversalDirectionAndReject
	eor.w	#$0002,d6
	bra.s	Restore_TraversalStateAndReturn

Evaluate_MapCellTraversalType:		; Memory Address ($7E12) and binary offset [$7A8E]
	; Uses the map-cell type dispatch value to accept, reject, or run
	; direction-sensitive wooden traversal checks.
	and.w	#$0007,d1
	move.b	MapType_TraversalDispatch(pc,d1.w),d1
	beq.s	Commit_MapCellEntry
	bpl.s	Check_ReversedWoodTraversalEdge
	addq.b	#$01,d1
	beq.s	Reject_MapCellEntry
	addq.b	#$01,d1
	beq.s	Restore_TraversalStateAndReturn
	move.b	$00(a6,d0.w),d1
	not.b	d1
	and.b	#$03,d1
	beq.s	Reject_MapCellEntry
	bra.s	Commit_MapCellEntry

Check_ReversedWoodTraversalEdge:		; Memory Address ($7E34) and binary offset [$7AB0]
	; Reverses direction before testing the destination wooden edge where traversal
	; uses the opposite face.
	eor.w	#$0002,d6
	subq.b	#$01,d1
	bne.s	Check_WoodTraversalEdge
	bsr.s	Test_DirectedWoodEdge
	bra.s	Finish_WoodTraversalCheck

Check_WoodTraversalEdge:		; Memory Address ($7E40) and binary offset [$7ABC]
	; Tests the direction-selected wooden edge before accepting traversal.
	bsr.s	Test_WoodTraversalEdge
Finish_WoodTraversalCheck:		; Memory Address ($7E42) and binary offset [$7ABE]
	; Branch point which rejects entry when the selected wooden edge test fails.
	bcs.s	Reverse_TraversalDirectionAndReject
Commit_MapCellEntry:		; Memory Address ($7E44) and binary offset [$7AC0]
	; Clears map-byte-2 bit 7 on the source cell and sets it on the accepted
	; destination cell.
	bclr	#$07,$01(a6,d2.w)
	bset	#$07,$01(a6,d0.w)
	swap	d1
	rts		

MapType_TraversalDispatch:		; Memory Address ($7AD0) and binary offset [$774C]
	; Eight signed dispatch values indexed by map-cell type during
	; Try_EnterMapCell.
	INCBIN "/data/BLOODWYCH439-clean/MapType_TraversalDispatch"

Reverse_TraversalDirectionAndReject:		; Memory Address ($7E5C) and binary offset [$7AD8]
	; Reverses the working direction before the common rejected-entry return.
	eor.w	#$0002,d6
Reject_MapCellEntry:		; Memory Address ($7E60) and binary offset [$7ADC]
	; Restores the original/current map index as the rejected traversal result.
	move.w	d2,d0
Restore_TraversalStateAndReturn:		; Memory Address ($7E62) and binary offset [$7ADE]
	; Restores target coordinates and returns with the traversal result flags.
	move.l	d5,d7
	sub.w	#$FFFF,d1
	rts		

Check_WoodCellTraversal:		; Memory Address ($7E6A) and binary offset [$7AE6]
	; Detects map type 2 and enters its direction-derived wooden-edge test; other
	; map types return to the caller.
	move.b	$01(a6,d0.w),d1
	and.w	#$0007,d1
	cmpi.b	#$02,d1
	bne.s	Accept_WoodCellTraversal
Test_WoodTraversalEdge:		; Memory Address ($7E78) and binary offset [$7AF4]
	; Converts direction to the two-bit wooden-edge selector before testing the map
	; cell.
	move.w	d6,d1
	add.w	d1,d1
Test_DirectedWoodEdge:		; Memory Address ($7E7C) and binary offset [$7AF8]
	; Tests the selected wooden-wall/door edge bit and returns the resulting
	; traversal condition.
	btst	d1,$00(a6,d0.w)
	beq.s	Accept_WoodCellTraversal
	sub.b	#$FF,d1
	rts		

Accept_WoodCellTraversal:		; Memory Address ($7B04) and binary offset [$7780]
	swap	d1
	rts		

Redraw_GameInterfaceFromScratch:		; Memory Address ($7B08) and binary offset [$7784]
	; Clears the display and reconstructs the active game interface before
	; continuing into the player panel and viewport.
	bsr		Clear_DisplayBuffer
	moveq	#$00,d4
	moveq	#$60,d5
	tst.w	MultiPlayer.l
	beq.s	Redraw_GameInterface_DrawPlayer1Edge
	moveq	#$1F,d5
	bsr.s	Draw_PartyCommandPanelEdge
	move.w	#$0090,d5
Redraw_GameInterface_DrawPlayer1Edge:		; Memory Address ($7B20) and binary offset [$779C]
	bsr.s	Draw_PartyCommandPanelEdge
Draw_PlayerInterfaceAndDungeonViewport:		; Memory Address ($7B22) and binary offset [$779E]
	; Draws the champion name panel and party commands, then refreshes the active
	; player's dungeon viewport.
	bsr		Draw_ChampionNamePanelFrame
	bsr		Draw_PartyCommandInterface
	bra		Refresh_ActivePlayerDungeonViewport

Draw_PartyCommandPanelEdge:		; Memory Address ($7B2E) and binary offset [$77AA]
	; Builds the procedural edge around the party-command panel using repeated
	; horizontal lines.
	move.l	#$013F0001,d3
Draw_PartyCommandPanelEdge_GrowLoop:		; Memory Address ($7B34) and binary offset [$77B0]
	bsr		BW_blit_horiz_line
	addq.w	#$01,d5
	addq.w	#$01,d3
	cmpi.w	#$0005,d3
	bcs.s	Draw_PartyCommandPanelEdge_GrowLoop
	subq.w	#$02,d3
Draw_PartyCommandPanelEdge_ShrinkLoop:		; Memory Address ($7B44) and binary offset [$77C0]
	bsr		BW_blit_horiz_line
	addq.w	#$01,d5
	subq.w	#$01,d3
	bne.s	Draw_PartyCommandPanelEdge_ShrinkLoop
	rts		

Draw_PartyCommandInterface:		; Memory Address ($7B50) and binary offset [$77CC]
	; Clears and composes the party-command panel for the current command state.
	tst.w	$0042(a5)															;Tests PlayerX_Data party-command state: a non-negative value takes the ordinary compact portrait/shield redraw path, while $FFFF enters the dirty selected-character redraw path.
	bmi		Refresh_DirtyPartyShieldSlots										;Branches only for the negative team-avatar state, allowing individually selected living slots to use Draw_Character rather than their compact avatar graphics.
	or.b	#$03,$0054(a5)
	move.l	#$005F0000,d4														;Clears the 96 by 89 player-local party-command panel before drawing the avatar, command pockets, menu rows, and chain strip.
	move.l	#$00580007,d5
	add.w	$0008(a5),d5														;Applies the active player's screen-buffer Y offset to this player-local drawing coordinate.
	moveq	#$00,d3
	bsr		BW_draw_bar
	move.l	#$FFFFFFFF,$005A(a5)
	bsr		Draw_MainChampionAvatarPanel										;Draws the default large 32 by 30 avatar panel before any full-length party-character rendering is requested.
	moveq	#$0A,d5																;Sets player-local Y=$0A for the outer pair of command-pocket decoration lines.
	add.w	$0008(a5),d5														;Applies the active player's screen-buffer Y offset to this player-local drawing coordinate.
	moveq	#$32,d4																;Sets the outer-left command-pocket decoration line at player-local X=$32.
	move.l	#$002B0002,d3														;Sets the outer-line DBRA count to $2B (44 rendered pixels) and the shared grey palette index to $02.
	bsr		BW_blit_vertical_line												;Draws one of the four command-pocket decoration lines using D4 X, D5 Y, the high-word DBRA count in D3, and the low-word palette index in D3.
	moveq	#$5D,d4																;Sets the outer-right command-pocket decoration line at player-local X=$5D.
	bsr		BW_blit_vertical_line												;Draws one of the four command-pocket decoration lines using D4 X, D5 Y, the high-word DBRA count in D3, and the low-word palette index in D3.
	addq.w	#$02,d5																;Moves the inner decoration pair two pixels down to player-local Y=$0C.
	sub.l	#$00040000,d3														;Reduces the high-word DBRA count from $2B to $27, making each inner line 40 pixels—four pixels shorter than the outer pair.
	moveq	#$5B,d4																;Sets the inner-right command-pocket decoration line at player-local X=$5B.
	bsr		BW_blit_vertical_line												;Draws one of the four command-pocket decoration lines using D4 X, D5 Y, the high-word DBRA count in D3, and the low-word palette index in D3.
	moveq	#$34,d4																;Sets the inner-left command-pocket decoration line at player-local X=$34.
	bsr		BW_blit_vertical_line												;Draws one of the four command-pocket decoration lines using D4 X, D5 Y, the high-word DBRA count in D3, and the low-word palette index in D3.
	move.l	screen_ptr.l,a0														;Loads the screen base before positioning the first pair of Pockets command icons.
	add.w	#$0147,a0															;Positions A0 at the player-local destination for the first two command-pocket icons.
	add.w	$000A(a5),a0														;Applies the active player's screen-buffer byte offset to the command-pocket icon destination.
	moveq	#$71,d7																;Seeds D7 with Pockets icon $71. The loop draws icon IDs $71-$74 in two-icon rows, and only draws $75-$76 when the interface is in active Communication state $08.
	move.w	$0012(a5),d3														;Loads the active player's secondary UI colour before drawing the six command/toggle pocket graphics.
Draw_PartyCommandIconStrip:		; Memory Address ($7BC0) and binary offset [$783C]
	; Draws paired GFX_Pockets command icons into successive rows of the
	; party-command panel.
	move.w	d7,d0																;Passes the current Pockets icon ID from D7 to Draw_PocketGraphic; each loop pass draws two consecutive IDs.
	bsr		Draw_PocketGraphic													;Draws the current player-coloured Pockets icon selected by D7/D0 at the destination in A0.
	addq.w	#$01,d7																;Advances D7 to the next Pockets icon ID; the loop covers $71 through $74 unconditionally, then $75 and $76 only in communication state.
	move.w	d7,d0																;Passes the current Pockets icon ID from D7 to Draw_PocketGraphic; each loop pass draws two consecutive IDs.
	bsr		Draw_PocketGraphic													;Draws the current player-coloured Pockets icon selected by D7/D0 at the destination in A0.
	addq.w	#$01,d7																;Advances D7 to the next Pockets icon ID; the loop covers $71 through $74 unconditionally, then $75 and $76 only in communication state.
	add.w	#$027C,a0															;Advances the drawing destination from one two-icon row to the next command-pocket row.
	cmpi.w	#$0075,d7															;Repeats the two-icon drawing loop until the always-visible Pockets icons $71 through $74 have been drawn.
	bcs.s	Draw_PartyCommandIconStrip
	cmp.w	#$0008,$0042(a5)													;Tests for active communication state $08; other party-command states skip the final wide-toggle icon pair.
	bne.s	Draw_PartyCommandMenuAndContinuousChain
	cmpi.w	#$0077,d7															;Continues the loop only until the active-communication-only Pockets icons $75 and $76 have also been drawn.
	bcs.s	Draw_PartyCommandIconStrip
Draw_PartyCommandMenuAndContinuousChain:		; Memory Address ($7BE8) and binary offset [$7864]
	; Draws the party-command menu text followed by the continuous bottom-chain
	; strip from GFX_Pockets+$3C60.
	bsr		Draw_PartyCommandMenu
	lea		GFX_Pockets+GFX_Pockets_ChainStripCommandPanelOffset.l,a1			;Selects the continuous 96 by 7 chain strip drawn beneath the party-command menu.
	move.l	#$00050006,d5														;Long Addr replaced with Symbol
	move.l	screen_ptr.l,a0
	add.w	#$0DE8,a0
	add.w	$000A(a5),a0
	lea		$0070.w,a3
	bra		Draw_PlanarGraphic

PartyCommandDescriptorStream_Mode0:		; Memory Address ($7C0E) and binary offset [$788A]
	; Contains the static party-command menu descriptor stream selected by menu
	; mode 0.
	dc.b	$5F	;5F
	dc.b	$3C	;3C
	dc.b	$24	;24
	dc.b	$3C	;3C
	dc.b	$10	;10
	dc.b	$FF	;FF
	dc.b	$11	;11
	dc.b	$FC	;FC
	dc.b	$12	;12
	dc.b	$FF	;FF
	dc.b	$13	;13
	dc.b	$FC	;FC
	dc.b	$14	;14
	dc.b	$FF	;FF
	dc.b	$15	;15
	dc.b	$FC	;FC
	dc.b	$16	;16
	dc.b	$FF	;FF
Interface_ActionSelectionScratchBuffer:		; Memory Address ($7C20) and binary offset [$789C]
	; Runtime scratch buffer initialised by adrCd007D06 for up to four
	; inventory/action choices; it is not a static extractable table.
	dc.b	$5F	;5F
	dc.b	$5F	;5F
	dc.b	$5F	;5F
	dc.b	$5F	;5F
Interface_ActionSelectionScratchEntries:		; Memory Address ($7C24) and binary offset [$78A0]
	; Interior four-entry action/object list populated by adrJA007CA6 and read by
	; Interface_MapSelectedAction; values change with inventory contents.
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$FF	;FF
PartyCommandDescriptorStream_Mode4:		; Memory Address ($7C2C) and binary offset [$78A8]
	; Contains the static party-command menu descriptor stream selected by menu
	; mode 4.
	dc.b	$5F	;5F
	dc.b	$5F	;5F
	dc.b	$5F	;5F
	dc.b	$5F	;5F
	dc.b	$3C	;3C
	dc.b	$FF	;FF
	dc.b	$3E	;3E
	dc.b	$FF	;FF
	dc.b	$3F	;3F
	dc.b	$FF	;FF
	dc.b	$40	;40
	dc.b	$FB	;FB
	dc.b	$41	;41
	dc.b	$FF	;FF
PartyCommandDescriptorStream_Mode5:		; Memory Address ($7C3A) and binary offset [$78B6]
	; Contains the static party-command menu descriptor stream selected by menu
	; mode 5.
	dc.b	$5F	;5F
	dc.b	$5F	;5F
	dc.b	$2C	;2C
	dc.b	$2C	;2C
	dc.b	$42	;42
	dc.b	$4A	;4A
	dc.b	$FF	;FF
	dc.b	$43	;43
	dc.b	$FB	;FB
	dc.b	$44	;44
	dc.b	$FF	;FF
	dc.b	$45	;45
	dc.b	$FC	;FC
	dc.b	$46	;46
	dc.b	$FF	;FF
	dc.b	$47	;47
	dc.b	$FC	;FC
	dc.b	$48	;48
	dc.b	$FF	;FF
PartyCommandDescriptorStream_Mode6:		; Memory Address ($7C4D) and binary offset [$78C9]
	; Contains the static party-command menu descriptor stream selected by menu
	; mode 6.
	dc.b	$5F	;5F
	dc.b	$5F	;5F
	dc.b	$5F	;5F
	dc.b	$5F	;5F
	dc.b	$18	;18
	dc.b	$FA	;FA
	dc.b	$20	;20
	dc.b	$31	;31
	dc.b	$FA	;FA
	dc.b	$45	;45
	dc.b	$FA	;FA
	dc.b	$53	;53
	dc.b	$FA	;FA
	dc.b	$3F	;3F
	dc.b	$FF	;FF
	dc.b	$1E	;1E
	dc.b	$FA	;FA
	dc.b	$20	;20
	dc.b	$42	;42
	dc.b	$FA	;FA
	dc.b	$45	;45
	dc.b	$FA	;FA
	dc.b	$3F	;3F
	dc.b	$FF	;FF
	dc.b	$4B	;4B
	dc.b	$FA	;FA
	dc.b	$20	;20
	dc.b	$4C	;4C
	dc.b	$FF	;FF
	dc.b	$4D	;4D
	dc.b	$FA	;FA
	dc.b	$20	;20
	dc.b	$4C	;4C
	dc.b	$FF	;FF
PartyCommandDescriptorStream_Mode7:		; Memory Address ($7C6F) and binary offset [$78EB]
	; Contains the static party-command menu descriptor stream selected by menu
	; mode 7.
	dc.b	$5F	;5F
	dc.b	$5F	;5F
	dc.b	$5F	;5F
	dc.b	$5F	;5F
	dc.b	$4E	;4E
	dc.b	$FA	;FA
	dc.b	$20	;20
	dc.b	$4F	;4F
	dc.b	$FF	;FF
	dc.b	$50	;50
	dc.b	$FA	;FA
	dc.b	$20	;20
	dc.b	$51	;51
	dc.b	$FA	;FA
	dc.b	$53	;53
	dc.b	$FF	;FF
	dc.b	$52	;52
	dc.b	$FA	;FA
	dc.b	$53	;53
	dc.b	$FF	;FF
	dc.b	$53	;53
	dc.b	$FA	;FA
	dc.b	$53	;53
	dc.b	$FF	;FF
PartyCommandDescriptorStream_Mode8:		; Memory Address ($7C87) and binary offset [$7903]
	; Contains the static party-command menu descriptor stream selected by menu
	; mode 8.
	dc.b	$5F	;5F
	dc.b	$5F	;5F
	dc.b	$5F	;5F
	dc.b	$5F	;5F
	dc.b	$61	;61
	dc.b	$FF	;FF
	dc.b	$55	;55
	dc.b	$FF	;FF
	dc.b	$56	;56
	dc.b	$FF	;FF
	dc.b	$57	;57
	dc.b	$FF	;FF
PartyCommandDescriptorStream_Mode9:		; Memory Address ($7C93) and binary offset [$790F]
	; Contains the static party-command menu descriptor stream selected by menu
	; mode 9.
	dc.b	$5F	;5F
	dc.b	$5F	;5F
	dc.b	$5F	;5F
	dc.b	$5F	;5F
	dc.b	$58	;58
	dc.b	$FF	;FF
	dc.b	$59	;59
	dc.b	$FF	;FF
	dc.b	$5A	;5A
	dc.b	$FF	;FF
	dc.b	$5B	;5B
	dc.b	$FF	;FF
	dc.b	$00	;00

Select_PartyCommandDescriptorStream_Mode0:		; Memory Address ($7CA0) and binary offset [$791C]
	lea		PartyCommandDescriptorStream_Mode0.w,a6								;Short Absolute converted to symbol!
	rts		

Build_EligibleCompanionList:		; Memory Address ($7CA6) and binary offset [$7922]
	; Builds the selectable companion list from present party members who are
	; neither waiting nor dead.
	bsr.s	Reset_ActionSelectionScratchBuffer
	moveq	#$01,d1
	moveq	#$00,d3
Build_EligibleCompanionList_ScanLoop:		; Memory Address ($7CAC) and binary offset [$7928]
	move.b	$18(a5,d1.w),d0
	and.w	#$00E0,d0
	bne.s	Build_EligibleCompanionList_NextSlot
	move.b	$18(a5,d1.w),d0
	and.w	#$000F,d0
	move.b	d0,$04(a6,d2.w)
	move.b	#$5F,$00(a6,d3.w)
	addq.w	#$01,d3
	addq.w	#$02,d2
Build_EligibleCompanionList_NextSlot:		; Memory Address ($7CCC) and binary offset [$7948]
	addq.w	#$01,d1
	cmpi.w	#$0004,d1
	bcs.s	Build_EligibleCompanionList_ScanLoop
	rts		

Build_EligibleCompanionList_Reversed:		; Memory Address ($7CD6) and binary offset [$7952]
	bsr.s	Reset_ActionSelectionScratchBuffer
	moveq	#$02,d1
	moveq	#$00,d3
Build_EligibleCompanionList_Reversed_ScanLoop:		; Memory Address ($7CDC) and binary offset [$7958]
	move.b	$19(a5,d1.w),d0
	bmi.s	Build_EligibleCompanionList_Reversed_NextSlot
	btst	#$05,d0
	beq.s	Build_EligibleCompanionList_Reversed_NextSlot
	btst	#$06,d0
	bne.s	Build_EligibleCompanionList_Reversed_NextSlot
	and.w	#$000F,d0
	move.b	d0,$04(a6,d2.w)
	move.b	#$5F,$00(a6,d3.w)
	addq.w	#$02,d2
	addq.w	#$01,d3
Build_EligibleCompanionList_Reversed_NextSlot:		; Memory Address ($7D00) and binary offset [$797C]
	dbra	d1,Build_EligibleCompanionList_Reversed_ScanLoop
	rts		

Reset_ActionSelectionScratchBuffer:		; Memory Address ($7D06) and binary offset [$7982]
	; Resets the four action-selection entries and their row markers before an
	; eligible-target list is built.
	lea		Interface_ActionSelectionScratchBuffer.w,a6							;Short Absolute converted to symbol!
	move.b	#$FC,d0
	moveq	#$08,d2
Reset_ActionSelectionScratchBuffer_FillLoop:		; Memory Address ($7D10) and binary offset [$798C]
	move.b	d0,$02(a6,d2.w)
	subq.w	#$02,d2
	bne.s	Reset_ActionSelectionScratchBuffer_FillLoop
	move.l	#$FFFFFFFF,(a6)
	rts		

Select_PartyCommandDescriptorStream_Mode4:		; Memory Address ($7D20) and binary offset [$799C]
	lea		PartyCommandDescriptorStream_Mode4.w,a6								;Short Absolute converted to symbol!
	rts		

Select_PartyCommandDescriptorStream_Mode5:		; Memory Address ($7D26) and binary offset [$79A2]
	lea		PartyCommandDescriptorStream_Mode5.w,a6								;Short Absolute converted to symbol!
	rts		

Select_PartyCommandDescriptorStream_Mode6:		; Memory Address ($7D2C) and binary offset [$79A8]
	lea		PartyCommandDescriptorStream_Mode6.w,a6								;Short Absolute converted to symbol!
	rts		

Select_PartyCommandDescriptorStream_Mode7:		; Memory Address ($7D32) and binary offset [$79AE]
	lea		PartyCommandDescriptorStream_Mode7.w,a6								;Short Absolute converted to symbol!
	rts		

Select_PartyCommandDescriptorStream_Mode8:		; Memory Address ($7D38) and binary offset [$79B4]
	lea		PartyCommandDescriptorStream_Mode8.w,a6								;Short Absolute converted to symbol!
	rts		

Select_PartyCommandDescriptorStream_Mode9:		; Memory Address ($7D3E) and binary offset [$79BA]
	lea		PartyCommandDescriptorStream_Mode9.w,a6								;Short Absolute converted to symbol!
	rts		

PartyCommandMenu_ModeJumpTable:		; Memory Address ($7D44) and binary offset [$79C0]
	; Mode-indexed pointer table selecting the party-command descriptor stream.
	dc.l	Select_PartyCommandDescriptorStream_Mode0	;00007CA0
	dc.l	Build_EligibleCompanionList	;00007CA6
	dc.l	$00000000	;00000000
	dc.l	Build_EligibleCompanionList_Reversed	;00007CD6
	dc.l	Select_PartyCommandDescriptorStream_Mode4	;00007D20
	dc.l	Select_PartyCommandDescriptorStream_Mode5	;00007D26
	dc.l	Select_PartyCommandDescriptorStream_Mode6	;00007D2C
	dc.l	Select_PartyCommandDescriptorStream_Mode7	;00007D32
	dc.l	Select_PartyCommandDescriptorStream_Mode8	;00007D38
	dc.l	Select_PartyCommandDescriptorStream_Mode9	;00007D3E

Draw_PartyCommandMenu:		; Memory Address ($7D6C) and binary offset [$79E8]
	; Selects a command descriptor stream and draws its selectable rows and text.
	or.b	#$01,$0054(a5)
	move.w	$0044(a5),d0														;Loads the active party-command menu descriptor-stream index before selecting its stream through the ten-entry jump table.
	asl.w	#$02,d0
	move.l	PartyCommandMenu_ModeJumpTable(pc,d0.w),a0
	jsr		(a0)
	move.l	a6,$0046(a5)
	move.l	#$00060039,d5														;Initialises a seven-pixel-tall menu bar at player-local Y=$39; each of the four rows advances by eight pixels, leaving a one-pixel black separator.
	add.w	$0008(a5),d5
	moveq	#$00,d7
Draw_PartyCommandMenu_RowLoop:		; Memory Address ($7D8E) and binary offset [$7A0A]
	moveq	#$02,d3
	moveq	#$00,d4
	move.b	$00(a6,d7.w),d4														;Loads the descriptor byte that sets the current row's left bar extent; the remaining width is drawn as the right bar with the separating vertical line retained.
	bpl.s	Draw_PartyCommandMenu_RowLoop_TestSelectedRow
	moveq	#$5F,d4
	bra.s	Draw_PartyCommandMenu_RowLoop_DrawLeftBar

Draw_PartyCommandMenu_RowLoop_TestSelectedRow:		; Memory Address ($7D9C) and binary offset [$7A18]
	cmp.b	$0040(a5),d7
	bne.s	Draw_PartyCommandMenu_RowLoop_DrawLeftBar
	tst.b	$0041(a5)
	bne.s	Draw_PartyCommandMenu_RowLoop_DrawLeftBar
	move.w	$0010(a5),d3														;Uses the active player's primary UI colour for either selected party-command row state.
Draw_PartyCommandMenu_RowLoop_DrawLeftBar:		; Memory Address ($7DAC) and binary offset [$7A28]
	subq.w	#$01,d4
	swap	d4
	movem.l	d4/d5/d7,-(sp)
	bsr		BW_draw_bar
	subq.w	#$07,d5
	swap	d4
	addq.w	#$01,d4
	move.l	#$00060000,d3
	bsr		BW_blit_vertical_line
	movem.l	(sp),d4/d5/d7
	swap	d4
	addq.w	#$02,d4
	moveq	#$5D,d0
	sub.w	d4,d0
	bcs.s	Draw_PartyCommandMenu_RowLoop_NextRow
	swap	d4
	move.w	d0,d4
	swap	d4
	moveq	#$02,d3
	cmp.b	$0040(a5),d7
	bne.s	Draw_PartyCommandMenu_RowLoop_DrawRightBar
	tst.b	$0041(a5)
	beq.s	Draw_PartyCommandMenu_RowLoop_DrawRightBar
	move.w	$0010(a5),d3														;Uses the active player's primary UI colour for either selected party-command row state.
Draw_PartyCommandMenu_RowLoop_DrawRightBar:		; Memory Address ($7DEE) and binary offset [$7A6A]
	bsr		BW_draw_bar
Draw_PartyCommandMenu_RowLoop_NextRow:		; Memory Address ($7DF2) and binary offset [$7A6E]
	movem.l	(sp)+,d4/d5/d7
	addq.w	#$08,d5																;Moves to the next of four menu rows: seven bar pixels plus one black separator pixel.
	addq.w	#$01,d7
	cmpi.w	#$0004,d7
	bcs.s	Draw_PartyCommandMenu_RowLoop
	move.l	screen_ptr.l,a0
	add.w	$000A(a5),a0
	add.w	#$0910,a0
	addq.w	#$04,a6																;Skips the four row-layout descriptor bytes before consuming the packed text entries for the same four visible rows.
	moveq	#$00,d7
Draw_PartyCommandMenu_PrintEntriesLoop:		; Memory Address ($7E12) and binary offset [$7A8E]
	move.l	a0,-(sp)
	bsr		Print_com_menu_entry												;Prints one packed party-command text row; four passes consume the descriptor stream entries in display order.
	clr.b	TextDoubleWidthFlag.l
	move.l	(sp)+,a0
	add.w	#$0140,a0
adrL_007E22:						equ	*-2	; Memory Address ($7E22) and binary offset [$7A9E]
	addq.w	#$01,d7
	cmpi.w	#$0004,d7
	bcs.s	Draw_PartyCommandMenu_PrintEntriesLoop
	moveq	#$00,d4
	moveq	#$39,d5
	add.w	$0008(a5),d5
	move.l	#$001E0000,d3
	bsr		BW_blit_vertical_line
	moveq	#$5E,d4
	bsr		BW_blit_vertical_line
	addq.w	#$01,d4
	bra		BW_blit_vertical_line

Draw_SelectedLeaderChainStrip:		; Memory Address ($7E4A) and binary offset [$7AC6]
	; Draws one side of the chain surround used by the selected leader
	; presentation.
	add.l	screen_ptr.l,a0
	add.w	$000A(a5),a0
	lea		GFX_Pockets+$6500.l,a1
	move.l	#$00000024,-(sp)
	moveq	#$00,d3
Draw_PlanarGraphicCore_WithStride98:		; Memory Address ($7E62) and binary offset [$7ADE]
	lea		$0098.w,a3
	bra		Draw_PlanarGraphicCore

Draw_ActivePartyChampionInShield:		; Memory Address ($7E6A) and binary offset [$7AE6]
	; Validate an active living party slot and draw its character inside the
	; selected shield surround.
	btst	d7,$003E(a5)														;Continues only for a party slot marked as the active selected member.
	beq.s	Draw_ActivePartyChampionInShield_EarlyReturn
	move.b	$18(a5,d7.w),d1														;Loads the party-slot state byte: low nibble is champion ID; bits $20/$40 suppress the living full-character rendering.
	move.b	d1,d0
	and.w	#$000F,d0
	and.w	#$00E0,d1
	beq.s	Draw_ActivePartyChampionInShield_Render
Draw_ActivePartyChampionInShield_EarlyReturn:		; Memory Address ($7E80) and binary offset [$7AFC]
	rts		

Draw_ActivePartyChampionInShield_Render:		; Memory Address ($7E82) and binary offset [$7AFE]
	move.b	d0,-$0017(a3)
	move.w	d7,d0
	add.w	d7,d7
	add.w	d0,d7
	add.w	d7,d7
	move.w	ActivePartyChampionShieldDrawParameters(pc,d7.w),d4					;Loads the selected champion X anchor: $11 for upper slot, then $08, $28 and $48 for the three shield slots.
	move.w	ActivePartyChampionShieldDrawParameters_YField(pc,d7.w),d5			;Loads the selected champion Y anchor: $1C for upper slot or $48 for a lower shield slot.
	move.w	ActivePartyChampionShieldDrawParameters_DistField(pc,d7.w),d1		;Loads Draw_Character distance: $00 for the upper full-size champion and $01 for the lower one-step-away champion.
	moveq	#$00,d0
	move.w	#$FFFF,MonsterStrip_BottomY.l
	bra		Draw_Character														;Tail-calls the multipart character renderer after passing front-facing direction, selected slot anchor, and distance.

ActivePartyChampionShieldDrawParameters:		; Memory Address ($7EA8) and binary offset [$7B24]
	; Four six-byte records supplying character-render X, Y, and display parameters
	; for the party slots.
	dc.w	$0011	;0011
ActivePartyChampionShieldDrawParameters_YField:		; Memory Address ($7EAA) and binary offset [$7B26]
	; Interior alias for the Y field of each six-byte active-party shield
	; draw-parameter record.
	dc.w	$001C	;001C
ActivePartyChampionShieldDrawParameters_DistField:		; Memory Address ($7EAC) and binary offset [$7B28]
	; Interior alias for the distance field of each six-byte active-party shield
	; draw-parameter record.
	dc.w	$0000	;0000
	dc.w	$0008	;0008
	dc.w	$0048	;0048
	dc.w	$0001	;0001
	dc.w	$0028	;0028
	dc.w	$0048	;0048
	dc.w	$0001	;0001
	dc.w	$0048	;0048
	dc.w	$0048	;0048
	dc.w	$0001	;0001

Refresh_DirtyPartyShieldSlots:		; Memory Address ($7EC0) and binary offset [$7B3C]
	; Visit all four party slots and redraw those marked dirty.
	moveq	#$03,d7
Refresh_DirtyPartyShieldSlots_Loop:		; Memory Address ($7EC2) and binary offset [$7B3E]
	; Four-slot dirty-shield refresh loop.
	move.w	d7,-(sp)
	bsr		Refresh_PartyShieldSlotIfDirty
	move.w	(sp)+,d7
	dbra	d7,Refresh_DirtyPartyShieldSlots_Loop
	bsr		Draw_CompactStatsFrame
Draw_PartyShieldChainStrip:		; Memory Address ($7ED2) and binary offset [$7B4E]
	; Draw the Pockets.gfx chain strip whose gaps accommodate the shield slots.
	lea		GFX_Pockets+GFX_Pockets_ChainStripShieldGapsOffset.l,a1				;Selects the 96 by 7 chain strip whose gaps accommodate the four party shields.
	move.l	#$00050006,d5														;Long Addr replaced with Symbol
	move.l	screen_ptr.l,a0
	add.w	#$0DE8,a0
	add.w	$000A(a5),a0
	bra		Blit_MaskedPocketsOverlayLoop

Refresh_PartyShieldSlotIfDirty:		; Memory Address ($7EF0) and binary offset [$7B6C]
	; Return unless the selected party slot is marked for redraw.
	tst.b	$5A(a5,d7.w)
	bmi.s	Refresh_PartyShieldSlotIfDirty_Dispatch
	rts		

Refresh_PartyShieldSlotIfDirty_Dispatch:		; Memory Address ($7EF8) and binary offset [$7B74]
	or.b	#$03,$0054(a5)
	tst.w	d7
	beq.s	Draw_LeaderPanelPresentation
	clr.w	adrW_00EE2A.l
	bra.s	Draw_PartyShieldSlot

Draw_LeaderPanelPresentation:		; Memory Address ($7F0A) and binary offset [$7B86]
	; Selects between the compact leader portrait/statistics presentation and the
	; full-body party-leader presentation.
	tst.w	$0042(a5)
	bpl		Draw_MainChampionAvatarPanel
	moveq	#$00,d3
	moveq	#$5F,d4
	swap	d4
	move.l	#$002E0007,d5
	add.w	$0008(a5),d5
	bsr		BW_draw_bar
	btst	#$00,$003E(a5)
	bne.s	Draw_SelectedLeaderBodyPresentation
	bsr		Draw_MainChampionAvatarPanel
	bra		Draw_CompactStatsFrame

Draw_SelectedLeaderBodyPresentation:		; Memory Address ($7F36) and binary offset [$7BB2]
	; Draws the selected leader's full-body composition with its two chain strips
	; while retaining the compact statistics frame.
	move.l	#$00000230,a0
	bsr		Draw_SelectedLeaderChainStrip
	move.l	#$00000235,a0
	bsr		Draw_SelectedLeaderChainStrip
	moveq	#$00,d7
	bsr		Draw_SelectedPartyChampionInShield
	bra		Draw_CompactStatsFrame

Draw_PartyShieldSlot:		; Memory Address ($7F54) and binary offset [$7BD0]
	; Choose vacant, selected-living, ordinary, or dead rendering for one party
	; shield slot.
	move.l	screen_ptr.l,a0
	add.w	#$0898,a0
	add.w	$000A(a5),a0
	move.w	d7,d0
	subq.w	#$01,d7
	asl.w	#$02,d7
	add.w	d7,a0
	move.b	$18(a5,d0.w),d7														;Loads the selected party-slot state byte; a negative value denotes a vacant slot and the low nibble identifies an occupied champion.
	bpl.s	Select_OccupiedPartyShieldRendering
	lea		GFX_Shield_Clicked.l,a1
	sub.l	a3,a3
	move.l	#$00010028,d5														;Long Addr replaced with Symbol
	move.w	$0012(a5),d3
	bra		Draw_ShieldPlanarGraphic

Select_OccupiedPartyShieldRendering:		; Memory Address ($7F86) and binary offset [$7C02]
	; Distinguish the selected living slot from ordinary and dead occupied slots.
	btst	d0,$003E(a5)														;Tests whether this party slot is the active selected member before choosing its shield-rendering path.
	beq.s	Select_PartyShieldClassColours
	btst	#$05,d7
	bne.s	Select_PartyShieldClassColours
	btst	#$06,d7
	bne.s	Use_DeadPartyShieldClassColours
	move.w	d0,-(sp)
	lea		GFX_Pockets+GFX_Pockets_SelectedPartyShieldFrameOffset.l,a1			;Selects the 32x41 light-grey shield surround used for the active living party member.
	move.l	#$00010028,d5														;Long Addr replaced with Symbol
	move.l	#PartyShieldFrameSourceRowSkip,a3									;Skips the unused remainder of each Pockets.gfx source row after drawing the two-word-wide shield surround.
	bsr		Draw_PlanarGraphic
	move.w	(sp)+,d7
Draw_SelectedPartyChampionInShield:		; Memory Address ($7FB2) and binary offset [$7C2E]
	; Prepare the character-render work area and draw the active living champion
	; inside the selected surround.
	link	a3,#-$0020
	move.b	#$FF,-$0019(a3)
	clr.b	-$0015(a3)
	move.l	screen_ptr.l,a0
	add.w	$000A(a5),a0
	move.l	a0,-$0008(a3)
	bsr		Draw_ActivePartyChampionInShield									;Draws the active champion as a full multipart character inside the already drawn selected shield surround.
	unlk	a3
Return_PartyShieldDrawing:		; Memory Address ($7FD4) and binary offset [$7C50]
	; Shared return for party-shield rendering paths.
	rts		

Select_PartyShieldClassColours:		; Memory Address ($7FD6) and binary offset [$7C52]
	; Select normal class colours or the fixed dead-state class mask.
	moveq	#$04,d3
	btst	#$06,d7																;Tests the avatar-state dead flag. A dead member uses the fixed dead shield colours and is not eligible for selected living-character drawing.
	beq.s	Prepare_ComposedPartyShieldAvatar
Use_DeadPartyShieldClassColours:		; Memory Address ($7FDE) and binary offset [$7C5A]
	; Set D3 to zero, selecting black surround ink and the fixed dead
	; professional-symbol mask.
	moveq	#$00,d3																;Selects black for shield ink $F and retains the fixed dead-state professional-symbol colour mask.
Prepare_ComposedPartyShieldAvatar:		; Memory Address ($7FE0) and binary offset [$7C5C]
	; Resolve the champion ID and living shield ink before entering the common
	; shield compositor.
	and.w	#$000F,d7
	tst.w	d3
	beq.s	Draw_ComposedPartyShieldAvatar
	bsr		Select_ChampionShieldInkColour
	cmpi.w	#$0008,d3
	bne.s	Draw_ComposedPartyShieldAvatar
	subq.w	#$01,d3
Draw_ComposedPartyShieldAvatar:		; Memory Address ($7FF4) and binary offset [$7C70]
	; Tail-call Draw_ShieldAvatar with the selected living or dead colour state.
	bra		Draw_ShieldAvatar

Draw_CompactStatsFrame:		; Memory Address ($7FF8) and binary offset [$7C74]
	; Builds the compact statistics panel from procedural lines, a background
	; rectangle, and the packed STATS title graphic.
	tst.w	$0042(a5)
	bpl.s	Return_PartyShieldDrawing
	moveq	#$36,d4																;Sets the compact STATS frame's upper bevel left edge to player-local X=$36.
	moveq	#$0A,d5																;Sets the compact STATS frame's upper bevel to player-local Y=$0A before the player screen Y offset is added.
	add.w	$0008(a5),d5														;Applies the active player's screen Y offset to the current drawing coordinate.
	move.l	#$00240001,d3														;Top stats-frame line: DBRA terminal count $24 draws $25 pixels using palette index $01.
	bsr		BW_blit_horiz_line													;Calls the horizontal-line drawing routine for one bevel edge segment.
	addq.w	#$01,d5
	subq.w	#$02,d4
	add.l	#$00040001,d3														;Second top frame line expands by four pixels and uses palette index $02.
	bsr		BW_blit_horiz_line													;Calls the horizontal-line drawing routine for one bevel edge segment.
	addq.w	#$01,d5
	subq.w	#$01,d4
	add.l	#$00020001,d3														;Third top frame line expands by two pixels and uses palette index $03.
	bsr		BW_blit_horiz_line													;Calls the horizontal-line drawing routine for one bevel edge segment.
	addq.w	#$01,d5
	addq.w	#$01,d3																;Fourth top frame line keeps the width and advances to palette index $04.
	bsr		BW_blit_horiz_line													;Calls the horizontal-line drawing routine for one bevel edge segment.
	addq.w	#$01,d5
	subq.w	#$03,d3																;Fifth top frame line returns the packed colour to palette index $01.
	bsr		BW_blit_horiz_line													;Calls the horizontal-line drawing routine for one bevel edge segment.
	moveq	#$31,d5																;Sets the first lower STATS-frame bevel line to player-local Y=$31.
	add.w	$0008(a5),d5														;Applies the active player's screen Y offset to the current drawing coordinate.
	moveq	#$33,d4																;Sets the first lower STATS-frame bevel line to player-local X=$33.
	move.l	#$002A0001,d3														;First lower stats-frame line: DBRA terminal count $2A draws $2B pixels using palette index $01.
	bsr		BW_blit_horiz_line													;Calls the horizontal-line drawing routine for one bevel edge segment.
	addq.w	#$01,d5
	addq.w	#$03,d3																;Second lower frame line advances to palette index $04.
	bsr		BW_blit_horiz_line													;Calls the horizontal-line drawing routine for one bevel edge segment.
	addq.w	#$01,d5
	subq.w	#$01,d3																;Third lower frame line advances back to palette index $03.
	bsr		BW_blit_horiz_line													;Calls the horizontal-line drawing routine for one bevel edge segment.
	addq.w	#$01,d4
	addq.w	#$01,d5
	sub.l	#$00020001,d3														;Fourth lower frame line shortens by two pixels and uses palette index $02.
	bsr		BW_blit_horiz_line													;Calls the horizontal-line drawing routine for one bevel edge segment.
	addq.w	#$02,d4
	addq.w	#$01,d5
	sub.l	#$00040001,d3														;Fifth lower frame line shortens by four pixels and uses palette index $01.
	bsr		BW_blit_horiz_line													;Calls the horizontal-line drawing routine for one bevel edge segment.
	moveq	#$10,d5																;Sets the two vertical STATS-frame side lines to start at player-local Y=$10.
	add.w	$0008(a5),d5														;Applies the active player's screen Y offset to the current drawing coordinate.
	moveq	#$34,d4																;Sets the left vertical STATS-frame side line to player-local X=$34.
	move.l	#$001F0001,d3														;Side frame lines use terminal count $1F, drawing $20 pixels in palette index $01.
	bsr		BW_blit_vertical_line												;Calls the vertical-line drawing routine for a STATS-frame side edge.
	moveq	#$5C,d4																;Sets the right vertical STATS-frame side line to player-local X=$5C.
	bsr		BW_blit_vertical_line												;Calls the vertical-line drawing routine for a STATS-frame side edge.
	swap	d5
	move.w	#$001F,d5															;Sets the STATS background rectangle to player-local Y=$1F after packing its height into D5.
	swap	d5
	move.l	#$00260035,d4														;Stats background packs X=$35 with horizontal terminal count $26, drawing $27 pixels wide.
	moveq	#$02,d3																;Stats background uses palette index $02, the light-grey panel fill.
	bsr		BW_draw_bar															;Draws the stats background rectangle using the dimensions in D4 and the current palette index in D3.
	lea		GFX_Pockets+GFX_Pockets_StatsTitleOffset.l,a1						;Selects the pre-drawn 48 by 6 STATS title graphic from GFX_Pockets.
	move.l	#$00000088,a3
	move.l	screen_ptr.l,a0														;Starts from the player framebuffer before positioning the packed STATS title graphic.
	add.w	$000A(a5),a0
	add.w	#$0286,a0															;Places the packed STATS title graphic at its native compact-panel framebuffer offset.
	move.l	#$00020005,d5														;Draws the `<STATS>` graphic with its source dimensions and destination parameters.
	bsr		Draw_PlanarGraphic													;Calls the common four-plane graphic renderer for the pre-drawn STATS title.
Draw_MainPlayerInterface:		; Memory Address ($80CA) and binary offset [$7D46]
	; Draws the ordinary player interface, including exactly three compact
	; statistics bars.
	tst.w	$0042(a5)
	bpl		Return_NoPanelUpdateNeeded
	or.b	#$01,$0054(a5)
	move.l	#$00240036,d4														;Packs compact-bar background X=$36 and horizontal terminal count $24, producing a 37-pixel-wide rectangle.
	move.l	#$00160017,d5														;Packs compact-bar background Y=$17 and vertical terminal count $16, producing 23 rows.
	add.w	$0008(a5),d5
	moveq	#$03,d3																;The $80E8 stats-bar background call uses palette index $03, the lighter panel fill.
	bsr		BW_draw_bar															;Draws the stats-bar background rectangle using D4 dimensions and D3.
	btst	#$00,$003E(a5)														;Chooses individual compact stats when no champion presentation is expanded; otherwise enters the party-shield status-bar path.
	bne		Draw_PartyShieldStatusBars
	move.w	$0006(a5),d7														;Loads the current leader champion ID for the ordinary three-bar compact-stat display.
	asl.w	#$05,d7																;Converts the champion ID to its 32-byte Character_Stats_DataTable record offset.
	lea		Character_Stats_DataTable.l,a6
	lea		$05(a6,d7.w),a6														;Points A6 at the first current/maximum statistic pair used by the three compact bars.
	move.l	#$00040019,d5														;Packs the first compact-stat bar Y=$19 and its five-pixel terminal height.
	add.w	$0008(a5),d5
	moveq	#CompactStatsBar_LastIndex,d6										;Sets a DBRA terminal index of two, so the compact player panel draws exactly three statistics bars.
	moveq	#Player1_CompactStatsColourIndex,d3									;Selects hard-coded palette index $07 for Player 1's three compact statistics bars.
	btst	#$00,(a5)
	beq.s	Draw_CompactStatsBarsLoop
	moveq	#Player2_CompactStatsColourIndex,d3									;Selects hard-coded palette index $0C for Player 2's three compact statistics bars.
Draw_CompactStatsBarsLoop:		; Memory Address ($811E) and binary offset [$7D9A]
	; Draws the three compact player statistics bars using the player-specific
	; hard-coded colour.
	move.b	(a6)+,d0															;Loads the current statistic value and advances A6 to its maximum-value byte.
	beq.s	Advance_CompactStatsBarRow
	move.b	(a6),d1																;Loads the maximum statistic value used to scale the current bar length.
	bsr.s	Prepare_CompactStatBarLength										;Prepares the compact-bar geometry and scales current D0 against maximum D1.
	movem.l	d3-d6,-(sp)
	bsr		BW_draw_bar															;Calls the filled-rectangle drawing routine for one of the three compact statistic bars.
	movem.l	(sp)+,d3-d6
Advance_CompactStatsBarRow:		; Memory Address ($8132) and binary offset [$7DAE]
	; Advances the ordinary compact-stat renderer to the next statistic pair and
	; the next seven-pixel bar row.
	addq.w	#$07,d5																;Moves the next compact-stat bar down seven pixels, leaving its one-pixel inter-bar gap.
	addq.w	#$01,a6																;Advances from the current/maximum pair just consumed to the next pair.
	dbra	d6,Draw_CompactStatsBarsLoop
	rts		

Prepare_CompactStatBarLength:		; Memory Address ($813C) and binary offset [$7DB8]
	; Sets compact-stat bar geometry and maximum pixel length before entering the
	; common value-to-bar scaler.
	move.l	#$00220037,d4														;Sets compact-stat bar X=$37 and its maximum terminal width $22 before scaling.
	moveq	#$23,d2																;Sets the compact-stat bar maximum drawable length to $23 pixels.
Scale_ValueToBarLength:		; Memory Address ($8144) and binary offset [$7DC0]
	; Scales D0 against maximum D1 to a D2-pixel bar length; the caller retains the
	; full-value terminal length separately.
	swap	d4
	cmp.b	d1,d0																;Avoids division when the current value is already at or above its maximum; the bar remains full width.
	bcc.s	Return_ScaledBarLength
	and.w	#$00FF,d0
	and.w	#$00FF,d1
	mulu	d2,d0																;Multiplies the current value by the target pixel length before integer division by the maximum.
	divu	d1,d0																;Divides the scaled current value by the maximum to obtain the bar length in pixels.
	move.w	d0,d4
Return_ScaledBarLength:		; Memory Address ($8158) and binary offset [$7DD4]
	; Return from bar-length scaling.
	swap	d4
	rts		

Draw_PartyShieldStatusBars:		; Memory Address ($815C) and binary offset [$7DD8]
	; Draws one vertical hit-point bar for each party slot. Suppressed entries skip
	; drawing; full health uses the 21-pixel terminal height and other values scale
	; against 21 pixels.
	moveq	#$0E,d3																;Initialises the party-shield status-bar fallback colour before each living champion's class colour is selected.
	lea		Character_Stats_DataTable+$05.l,a6									;Uses offset $05 within each character record as the first current/maximum value pair for shield status bars.
	moveq	#PartyShieldStatusBar_LastSlot,d6									;Uses the last-slot index to visit all four party shield slots with DBRA.
	move.l	#$00060052,d5
Draw_PartyShieldStatusBarsLoop:		; Memory Address ($816C) and binary offset [$7DE8]
	; Iterates party slots 3 down to 0, drawing or skipping each shield hit-point
	; bar.
	move.b	$18(a5,d6.w),d0														;Loads or reloads the current party-slot state byte for suppression checks and champion selection.
	move.w	d0,d1
	and.w	#PartyShieldStatusBar_SuppressionMask,d1							;Tests the party-slot vacant and dead suppression bits before drawing a status bar.
	bne.s	Advance_PartyShieldStatusBarRow
	and.w	#$000F,d0
	asl.w	#$05,d0																;Converts the occupied slot's champion ID to its 32-byte character-stat record offset.
	move.b	$01(a6,d0.w),d1
	move.b	$00(a6,d0.w),d0
	beq.s	Advance_PartyShieldStatusBarRow
	and.w	#$00FF,d0
	moveq	#$14,d4																;Seeds the full-HP bar with terminal height $14; BW_draw_bar therefore fills 21 rows.
	swap	d4
	moveq	#PartyShieldStatusBar_ScaleHeight,d2								;Uses $15 only as the scale target when current HP is below maximum; it does not set the full-HP bar height.
	bsr.s	Scale_ValueToBarLength												;Calls the common scaler to convert the selected champion's current value into a shield-bar width.
	swap	d4
	moveq	#$2C,d2
	sub.w	d4,d2
	swap	d4
	move.w	d2,d4
	movem.l	d3-d6,-(sp)
	exg		d4,d5
	add.w	$0008(a5),d5
	move.b	$18(a5,d6.w),d0														;Loads or reloads the current party-slot state byte for suppression checks and champion selection.
	and.w	#$000F,d0
	bsr		Character_GetClassIndex												;Selects the champion magic-alignment/class index used for the full-length-avatar HP-bar colour.
	move.b	ChampionClassBarColours(pc,d0.w),d3									;Maps the champion magic-alignment/class index through the four-entry party HP-bar palette table.
	bsr		BW_draw_bar															;Calls the filled-rectangle drawing routine for one occupied party-shield status bar.
	movem.l	(sp)+,d3-d6
Advance_PartyShieldStatusBarRow:		; Memory Address ($81C0) and binary offset [$7E3C]
	; Advances to the next shield status-bar column after a drawn or suppressed
	; party slot.
	sub.w	#$0009,d5															;Moves to the next party-shield status-bar X position, nine pixels left of the current bar.
	dbra	d6,Draw_PartyShieldStatusBarsLoop
Return_PartyShieldStatusBars:		; Memory Address ($81C8) and binary offset [$7E44]
	; Return from the party shield hit-point bar renderer.
	rts		

ChampionClassBarColours:		; Memory Address ($81CA) and binary offset [$7E46]
	; Maps champion magic-alignment/class indices 0-3 to status-bar palette
	; indices: $06, $0D, $0C, $07.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/ChampionClassBarColours.lookup"

Refresh_CurrentChampionMapPositionIcon:		; Memory Address ($81CE) and binary offset [$7E4A]
	; Selects and schedules the active champion's current map-position icon after
	; movement or interface refresh.
	tst.w	$0014(a5)
	bne.s	Return_PartyShieldStatusBars
	or.b	#$04,$0054(a5)
	move.l	screen_ptr.l,a0
	add.w	#$054C,a0
	add.w	$000A(a5),a0
	bsr		Load_CurrentChampionStatRecord
	moveq	#$63,d0
	moveq	#$00,d2
	move.b	ChampionStat_WornSpell(a4),d2
	bne.s	Refresh_MapPositionIcon_WornItemIcon
	move.b	ChampionStat_SpellToCast(a4),d2
	bmi.s	Refresh_MapPositionIcon_DrawIcon
	move.w	d2,d0
	bsr		Character_GetClassIndex
	add.w	#$0064,d0
Refresh_MapPositionIcon_DrawIcon:		; Memory Address ($8206) and binary offset [$7E82]
	bra		Draw_PocketGraphic

Refresh_MapPositionIcon_WornItemIcon:		; Memory Address ($820A) and binary offset [$7E86]
	and.w	#$0007,d2
	move.b	PocketIconCodeTable(pc,d2.w),d0
	cmpi.w	#$0040,d0
	bne.s	Refresh_MapPositionIcon_DrawIcon
	add.w	$0020(a5),d0
	bra.s	Refresh_MapPositionIcon_DrawIcon

PocketIconCodeTable:		; Memory Address ($821E) and binary offset [$7E9A]
	; Maps a pocket-slot index to the icon code drawn for that slot.
	dc.b	$3C	;3C
	dc.b	$3D	;3D
	dc.b	$3E	;3E
	dc.b	$3F	;3F
	dc.b	$40	;40
	dc.b	$44	;44
	dc.b	$45	;45
	dc.b	$46	;46

adrL_008226:		; Memory Address ($8226) and binary offset [$7EA2]
	tst.b	$0055(a5)
	bpl.s	Show_QueuedPartyRejoinNotice
	bsr		Update_IdlePanelAnimation
Show_QueuedPartyRejoinNotice:		; Memory Address ($8230) and binary offset [$7EAC]
	move.b	$0034(a5),d0
	bmi.s	Return_NoPanelUpdateNeeded
	move.b	#$FF,$0034(a5)
	lea		Notice_PartyMemberRejoins.w,a6										;Short Absolute converted to symbol!
	move.b	d0,(a6)
	bsr		Print_timed_message
Refresh_ModeDependentChampionDisplay:		; Memory Address ($8246) and binary offset [$7EC2]
	; Refreshes the party-formation display in interface mode zero or the held-item
	; display in mode three; other modes return unchanged.
	moveq	#$00,d0
	move.b	$0015(a5),d0
	beq		Draw_PartyProfessionIconGrid
	subq.b	#$03,d0
	beq		Refresh_HeldItemDisplay
Return_NoPanelUpdateNeeded:		; Memory Address ($8256) and binary offset [$7ED2]
	rts		

Draw_ChampionNamePanelBackground:		; Memory Address ($8258) and binary offset [$7ED4]
	; Clears the right-hand champion name and display panel before its decorative
	; frame is drawn.
	or.b	#$0C,$0054(a5)
	bsr		Clear_LowerTextStrip
	move.l	#$005E00E1,d4														;Supplies BW_draw_bar with X=$E1 and DBRA width $5E, clearing a 95-pixel-wide right-hand panel from X=$E1 through $13F.
	move.l	#$00560009,d5														;Supplies BW_draw_bar with Y=$09 and DBRA height $56, clearing 87 rows through player-local Y=$5F.
	add.w	$0008(a5),d5
	moveq	#$00,d3																;Uses palette index $00 to clear the champion-name panel background before the decorative frame is drawn.
	bra		BW_draw_bar															;Fills the source-sized name/display panel rectangle using the packed dimensions in D4 and D5.

Draw_ChampionNamePanelFrame:		; Memory Address ($8278) and binary offset [$7EF4]
	; Draws the champion name-panel bevel, primary-colour name strip, and lower
	; frame lines.
	bsr.s	Draw_ChampionNamePanelBackground
	move.w	#$00E2,d4															;Sets the bevel-line X coordinate to $E2, one pixel inside the cleared panel's left edge.
	moveq	#$0A,d5																;Starts the five-scanline upper grey bevel at player-local Y=$0A.
	add.w	$0008(a5),d5
	move.l	#$005D0001,d3														;Sets DBRA width $5D (94 pixels) and the first upper-bevel colour index $01.
Draw_ChampionNamePanelUpperBevelLoop:		; Memory Address ($828A) and binary offset [$7F06]
	; Draws the five-line upper champion-name bevel, progressively changing the
	; grey palette index.
	bsr		BW_blit_horiz_line													;Draws an upper champion-name bevel scanline; the loop produces colours $01-$04 and the final call closes it with colour $01.
	addq.w	#$01,d5
	addq.w	#$01,d3																;Advances the packed bevel palette index on each successive horizontal line, creating the four-shade grey fade.
	cmpi.w	#$0005,d3															;Stops the upper bevel ramp after palette indices $01 through $04 have been drawn.
	bcs.s	Draw_ChampionNamePanelUpperBevelLoop
	subq.w	#$04,d3																;Restores palette index $01 for the closing lower edge of the upper bevel.
	bsr		BW_blit_horiz_line													;Draws an upper champion-name bevel scanline; the loop produces colours $01-$04 and the final call closes it with colour $01.
	move.l	#$00070010,d5														;Supplies BW_draw_bar with the primary-colour name strip's Y=$10 and DBRA height $07, producing eight rows Y=$10-$17.
	add.w	$0008(a5),d5
	move.l	#$005D00E2,d4														;Supplies the primary-colour name strip's X=$E2 and DBRA width $5D, producing 94 pixels through X=$13F.
	move.w	$0010(a5),d3														;Loads the active player's primary UI colour for the champion-name background block.
	bsr		BW_draw_bar															;Fills the complete primary-colour champion-name strip before the lower grey bevel starts.
	move.w	#$0001,d3
Draw_ChampionNamePanelLowerEdge:		; Memory Address ($82BA) and binary offset [$7F36]
	; Draws the lower decorative edge and adjacent packed status graphics for the
	; champion name panel.
	addq.w	#$01,d5																;Advances from the name bar's final Y=$17 to the lower bevel's first scanline at Y=$19, leaving Y=$18 as background.
	bsr		BW_blit_horiz_line													;Draws one scanline of the lower champion-name bevel; the loop repeats it for palette colours $01-$04.
	addq.w	#$01,d3
	cmpi.w	#$0005,d3
	bcs.s	Draw_ChampionNamePanelLowerEdge
	move.w	$0006(a5),d0
	bsr		Print_ChampionNamePanelGivenName
	move.l	screen_ptr.l,a0
	add.w	#$0544,a0
	add.w	$000A(a5),a0
	lea		GFX_Pockets+GFX_Pockets_StatusPanelOffset.l,a1						;Selects the 64 by 22 status-panel graphic containing the book and ledger icons.
	move.l	#$00000080,a3
	move.l	#$00030015,d5														;Long Addr replaced with Symbol
	bsr		Draw_PlanarGraphic
	add.w	#$0028,a0
	lea		GFX_Pockets+GFX_Pockets_CommandPadPlayer2Offset.l,a1				;Starts from the Player 2 command-pad source; Player 1 applies the following $20 adjustment.
	btst	#PlayerData_StateFlags_PlayerIdentityBit,(a5)						;Player 2's set identity bit retains the $67E0 command pad; Player 1 falls through to the $20 source adjustment.
	bne.s	Draw_NamePanelControlPadSprite
	add.w	#GFX_Pockets_CommandPadPlayer1Offset-GFX_Pockets_CommandPadPlayer2Offset,a1	;Selects the Player 1 command-pad source by advancing from $67E0 to $6800.
Draw_NamePanelControlPadSprite:		; Memory Address ($8308) and binary offset [$7F84]
	move.l	#$0003001E,d5														;Long Addr replaced with Symbol
	bsr		Draw_PlanarGraphic
	bsr		Refresh_CurrentChampionMapPositionIcon
	move.w	#$0062,d0
	bsr		Draw_PocketGraphic
	moveq	#$20,d5																;Sets the mini status-icon bevel's first horizontal line to player-local Y=$20.
	add.w	$0008(a5),d5
	move.w	#$0120,d4															;Sets the mini status-icon bevel's X coordinate to $120, immediately right of the 64-pixel status graphic.
	move.l	#$001F0001,d3														;Sets the mini bevel's DBRA width $1F (32 pixels) and initial grey colour index $01.
	bsr		BW_blit_horiz_line													;Draws the mini bevel's top line at Y=$20 and its icon-height divider at Y=$31.
	add.w	#$0011,d5															;Moves from the top mini-bevel line to Y=$31, immediately below the 16-pixel status-icon row.
	bsr		BW_blit_horiz_line													;Draws the mini bevel's top line at Y=$20 and its icon-height divider at Y=$31.
	addq.w	#$02,d5																;Moves from the divider to player-local Y=$33 for the stepped lower part of the mini bevel.
Draw_DungeonDisplayLowerEdge:		; Memory Address ($833C) and binary offset [$7FB8]
	; Completes the lower dungeon-display edge with procedural lines before drawing
	; the continuous chain strip.
	bsr		BW_blit_horiz_line													;Draws a lower mini-bevel scanline; the loop produces colours $01-$04 and the final call closes it with colour $01.
	addq.w	#$01,d5
	addq.w	#$01,d3
	cmpi.w	#$0005,d3
	bcs.s	Draw_DungeonDisplayLowerEdge
	subq.w	#$04,d3
	bsr		BW_blit_horiz_line													;Draws a lower mini-bevel scanline; the loop produces colours $01-$04 and the final call closes it with colour $01.
	bsr.s	Draw_PartyProfessionIconGrid
	move.l	#$00000E04,a0														;Long Addr replaced with Symbol
Draw_InventoryPanelChainStrip:		; Memory Address ($8358) and binary offset [$7FD4]
	; Draws the inventory panel's chain-strip artwork at the caller-supplied
	; framebuffer offset.
	move.l	#$00000070,a3
	lea		GFX_Pockets+GFX_Pockets_ChainStripContinuousOffset.l,a1				;Selects the continuous 96 by 7 chain strip used at the dungeon-display lower edge and in the inventory presentation.
	move.l	#$00050006,d5														;Sets the chain-strip DBRA dimensions used for both inventory decoration anchors.
	add.l	screen_ptr.l,a0
	add.w	$000A(a5),a0
	bra		Draw_PlanarGraphic

;fiX Label expected
	move.w	d0,d2
	and.w	#$0003,d0
	asl.w	#$02,d0
	and.w	#$000C,d2
	lsr.w	#$02,d2
	add.w	d2,d0
	add.w	#$0050,d0
Draw_PartyProfessionIconGrid_EarlyReturn:		; Memory Address ($838C) and binary offset [$8008]
	rts		

ProfessionIconGrid_ScreenOffsetTable:		; Memory Address ($838E) and binary offset [$800A]
	; Raw framebuffer byte offsets for the four profession-icon grid positions.
	dc.w	$08E4	;08E4
	dc.w	$0000	;0000
	dc.w	$0256	;0256
	dc.w	$FFFC	;FFFC

Draw_PartyProfessionIconGrid:		; Memory Address ($8396) and binary offset [$8012]
	; Draws the four-position profession-icon grid and frames the active lead
	; champion's position.
	btst	#$06,$0018(a5)
	bne.s	Draw_PartyProfessionIconGrid_EarlyReturn
	or.b	#$04,$0054(a5)
	move.l	screen_ptr.l,a0
	add.w	$000A(a5),a0
	moveq	#$00,d7																;Starts the four party-position profession-control loop at slot zero.
Draw_PartyProfessionIconGrid_SlotLoop:		; Memory Address ($83B0) and binary offset [$802C]
	move.w	d7,d2
	add.w	d2,d2
	add.w	ProfessionIconGrid_ScreenOffsetTable(pc,d2.w),a0					;Applies the compact four-slot screen-offset sequence for profession controls: upper-left, upper-right, lower-right, lower-left.
	move.b	$26(a5,d7.w),d0														;Loads the champion assigned to this party position; a negative entry selects the empty profession-control icon.
	bpl.s	Draw_PartyProfessionIconGrid_CheckDeadSlot
	bsr		Draw_VacantPartySlotIcon
	bra.s	Draw_PartyProfessionIconGrid_NextSlot

Draw_PartyProfessionIconGrid_CheckDeadSlot:		; Memory Address ($83C4) and binary offset [$8040]
	cmp.w	$0016(a5),d7														;Tests whether this party position is the pending first click; that path draws its profession icon with the neutral grey mask.
	beq.s	Draw_PartyProfessionIconGrid_DeadSlotColour
	bsr		Select_LivingMemberClassColour										;Draws an occupied party position's $4B-$4E profession icon using the assigned champion's class colour mask.
	bra.s	Draw_PartyProfessionIconGrid_NextSlot

Draw_PartyProfessionIconGrid_DeadSlotColour:		; Memory Address ($83D0) and binary offset [$804C]
	bsr		Select_NeutralProfessionIconMask									;Draws the pending selected position's profession icon using the neutral mask at adrEA00846A, making it grey.
Draw_PartyProfessionIconGrid_NextSlot:		; Memory Address ($83D4) and binary offset [$8050]
	addq.w	#$01,d7
	cmpi.w	#$0004,d7
	bcs.s	Draw_PartyProfessionIconGrid_SlotLoop
	move.w	$0006(a5),d0
	bsr		Find_ChampionFormationSlot
	move.w	$0010(a5),d3														;Loads the active player's primary UI colour for the selected team-member frame.
	move.l	#$000F0121,d4														;Supplies the lead-profession frame's DBRA width $0F and base X=$121; the slot lookup shifts right-hand frames to X=$131.
	move.l	#$000D0039,d5														;Supplies the lead-profession frame's DBRA height $0D and upper-row Y=$39; lower slots are shifted to Y=$48.
	add.w	$0008(a5),d5
	btst	#$01,d2
	beq.s	ProfessionIconGrid_ColumnLookup
	add.w	#$000F,d5
ProfessionIconGrid_ColumnLookup:		; Memory Address ($8402) and binary offset [$807E]
	move.b	GridSlotColumnShiftTable(pc,d2.w),d2
	beq.s	ProfessionIconGrid_DrawSelectionFrame
	sub.l	#$0000FFF0,d4														;Long Addr replaced with Symbol
ProfessionIconGrid_DrawSelectionFrame:		; Memory Address ($840E) and binary offset [$808A]
	bra		BW_draw_frame														;Draws the 16 by 14 primary-colour frame identifying the current lead champion's profession control.

GridSlotColumnShiftTable:		; Memory Address ($8412) and binary offset [$808E]
	; Maps the four formation positions to the left or right column of the
	; profession-icon grid.
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$00	;00

Draw_PartyMemberSlotIcon:		; Memory Address ($8416) and binary offset [$8092]
	; Draws a vacant, dead, or living profession icon for one party position.
	move.b	$18(a5,d7.w),d0
	and.w	#$00EF,d0
	bmi.s	Draw_VacantPartySlotIcon
	btst	#$05,d0
	bne.s	Draw_VacantPartySlotIcon
	btst	#$06,d0
	beq.s	Select_LivingMemberClassColour
Select_NeutralProfessionIconMask:		; Memory Address ($842C) and binary offset [$80A8]
	; Selects the neutral recolouring mask used for dead or pending-selected
	; profession icons.
	moveq	#$00,d6
	bra.s	Draw_RecolouredPartyProfessionIcon

Select_LivingMemberClassColour:		; Memory Address ($8430) and binary offset [$80AC]
	; Selects the profession colour mask for a living party member's icon.
	move.w	d0,d1
	bsr		Character_GetClassIndex
	move.w	d0,d6
	move.w	d1,d0
	addq.w	#$01,d6
	asl.w	#$02,d6
Draw_RecolouredPartyProfessionIcon:		; Memory Address ($843E) and binary offset [$80BA]
	; Draws the selected party profession icon with the prepared four-colour
	; replacement mask.
	lea		PartyIcon_DeadMemberColourMask.l,a6
	add.w	d6,a6
	and.w	#$0003,d0
	add.w	#$004B,d0
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l
	bsr		Draw_PocketGraphic
	clr.w	Buffer_Colour_Mask_Toggle.l
	rts		

Draw_VacantPartySlotIcon:		; Memory Address ($8462) and binary offset [$80DE]
	; Draws the fixed vacant-party-position icon.
	move.w	#$003B,d0															;Selects Pockets icon $3B for an empty party position.
	bra		Draw_PocketGraphic

PartyIcon_DeadMemberColourMask:		; Memory Address ($846A) and binary offset [$80E6]
	; Four-colour replacement mask used for dead or neutral party profession icons.
	dc.w	$0004	;0004
	dc.w	$030E	;030E
ClassColours:		; Memory Address ($846E) and binary offset [$80EA]
	; Four colour-mask records used when composing champion shield avatars.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Champion_Class.colours"

ForwardCellToMapOffset:		; Memory Address ($847E) and binary offset [$80FA]
	; Applies the player's facing vector to the packed position and converts the
	; forward cell to a map offset.
	move.l	PlayerData_XPosition(a5),d7											;Loads adjacent player X and Y words as packed X-high/Y-low coordinates.
StepCoordForwardToMapOffset:		; Memory Address ($8482) and binary offset [$80FE]
	; Steps the supplied packed coordinate in the active player's facing direction
	; and converts it to a map offset.
	move.w	PlayerData_Direction(a5),d0											;Loads the player facing direction for the forward-cell lookup.
AdjacentCoordToMapOffset:		; Memory Address ($8486) and binary offset [$8102]
	; Applies the direction-indexed movement vector to a packed coordinate and
	; converts the adjacent cell to a map offset.
	lea		MovementOffsetTable.w,a0											;Short Absolute converted to symbol!
	add.b	MovementOffset_YTableOffset(a0,d0.w),d7								;Adds the Y component of the selected movement vector.
	swap	d7
	add.b	$00(a0,d0.w),d7
	swap	d7
	bra.s	CoordToMap

PlayerPositionToMapOffset:		; Memory Address ($8498) and binary offset [$8114]
	; Converts the player's packed X and Y position to an offset in the selected
	; floor map.
	move.l	PlayerData_XPosition(a5),d7											;Loads adjacent player X and Y words as packed X-high/Y-low coordinates.
CoordToMap:
	; Sets A6 to the current tower's map-data base and converts packed coordinate
	; D7 to the current-floor map-cell offset using Y*width+X.
	move.l	Current_TowerMapDataBase.l,a6
Calculate_MapOffsetFromPackedCoordinate:		; Memory Address ($84A2) and binary offset [$811E]
	; Calculates the selected floor's byte offset for a packed X and Y coordinate,
	; assuming the tower map base is already loaded.
	move.w	d7,d0
	mulu	CurrentFloorWidth.l,d0
	swap	d7
	add.w	d7,d0
	swap	d7
	add.w	d0,d0																;Converts the row-major cell index to a byte offset because each map cell occupies two bytes.
	add.w	Live_PlayerPosition.l,d0											;Adds the selected floor offset relative to the tower cell-data base, not the map-header base.
	rts		

Compute_StairAlignedDestination:		; Memory Address ($84BA) and binary offset [$8136]
	; Calculates the aligned destination coordinate and facing used when moving
	; between paired stair cells.
	lea		Compute_StairAlignedDestination_ScratchTable.l,a0
	add.b	Map_AlignmentYArrayOffset(a0,d2.w),d7								;Y-alignment bytes start eight bytes after the X-alignment bytes.
	swap	d7
	add.b	$00(a0,d2.w),d7														;Adds old-floor X alignment to form the shared-world coordinate.
	sub.b	$00(a0,d1.w),d7														;Subtracts destination-floor X alignment to recover its local coordinate.
	swap	d7
	sub.b	Map_AlignmentYArrayOffset(a0,d1.w),d7								;Y-alignment bytes start eight bytes after the X-alignment bytes.
	rts		

Select_ActivePlayerFloorMap:		; Memory Address ($84D6) and binary offset [$8152]
	; Selects the floor map identified by the active player's independent floor
	; number.
	move.w	PlayerData_Floor(a5),d0												;Player record word selecting the active floor, not a map-cell offset.
Select_FloorMapByIndex:		; Memory Address ($84DA) and binary offset [$8156]
	; Selects a floor by index and caches its dimensions and map-data offset.
	lea		Current_TowerMapHeaderCache.l,a0
	move.b	$00(a0,d0.w),CurrentFloorWidth_LowByte.l							;Replaces the bootstrap width with the selected floor width; its high byte remains zero.
	move.b	Map_FloorHeightsOffset(a0,d0.w),CurrentFloorHeight_LowByte.l		;Offset of the eight height bytes in the map header.
	add.w	d0,d0
	move.w	Map_FloorDataOffsetsOffset(a0,d0.w),Live_PlayerPosition.l			;Offset of the eight big-endian floor cell-data offsets in the header.
	rts		

Resolve_DiagonalPillarSourceCell:		; Memory Address ($84FC) and binary offset [$8178]
	; Reconstructs X/Y from the selected-floor and current-cell offsets to locate
	; the diagonal source cell used by pillar movement.
	moveq	#-$01,d1
	moveq	#$00,d2
	move.w	Live_PlayerPosition.l,d2
	lea		Resolve_DiagonalPillarSourceCell_ScratchTable.l,a0
Resolve_DiagonalPillarSourceCell_SearchLoop:		; Memory Address ($850C) and binary offset [$8188]
	addq.w	#$01,d1
	cmp.w	(a0)+,d2
	bne.s	Resolve_DiagonalPillarSourceCell_SearchLoop
	sub.w	d0,d2
	neg.w	d2
	lsr.w	#Map_CellByteShift,d2												;Converts the floor-relative two-byte map offset to a cell number before division by width.
	divu	CurrentFloorWidth.l,d2												;Divides by active width: quotient is Y in the low word and remainder is X in the high word.
	rts		

SavedScreenPointer:		; Memory Address ($8520) and binary offset [$819C]
	; Temporarily preserves screen_ptr while the screen buffer is reused for raw
	; floppy-track transfers.
	ds.b	$4
Write_FloppyTrackSequence:		; Memory Address ($8524) and binary offset [$81A0]
	; Encodes, writes, and advances across the requested sequence of raw floppy
	; tracks.
	bsr		Encode_FloppyTrackForWrite
	bsr		FloppyDrive_StepPulse
	addq.w	#$02,d0
	dbra	d7,Write_FloppyTrackSequence
	rts		

Encode_FloppyTrackForWrite:		; Memory Address ($8534) and binary offset [$81B0]
	; Builds and MFM-encodes an eleven-sector raw floppy track, writes it through
	; disk DMA, and waits for completion.
	movem.l	d0-d7/a1-a4,-(sp)
	move.l	SavedScreenPointer.l,a1
	move.w	#$00F9,d6
Encode_FloppyTrackForWrite_FillGapLoop:		; Memory Address ($8542) and binary offset [$81BE]
	move.l	#$AAAAAAAA,(a1)+
	dbra	d6,Encode_FloppyTrackForWrite_FillGapLoop
	moveq	#$0A,d3
	moveq	#$0B,d2
Encode_FloppyTrackForWrite_SectorLoop:		; Memory Address ($8550) and binary offset [$81CC]
	move.l	a1,a6
	move.l	#$AAAAAAAA,(a1)+
	move.l	#$44894489,(a1)+
	move.b	#$FF,d7
	asl.l	#$08,d7
	move.b	d0,d7
	asl.l	#$08,d7
	move.b	d1,d7
	asl.l	#$08,d7
	move.b	d2,d7
	move.l	a1,a2
	move.l	d7,d6
	and.l	#$AAAAAAAA,d6
	lsr.l	#$01,d6
	move.l	d6,(a1)+
	and.l	#$55555555,d7
	move.l	d7,(a1)+
	moveq	#$01,d5
	bsr		Encode_MFMClockBits
	eor.l	d6,d7
	move.l	a1,a2
	clr.l	(a1)+
	clr.l	(a1)+
	clr.l	(a1)+
	clr.l	(a1)+
	clr.l	(a1)+
	clr.l	(a1)+
	clr.l	(a1)+
	clr.l	(a1)+
	move.l	d7,d6
	and.l	#$AAAAAAAA,d6
	lsr.l	#$01,d6
	move.l	d6,(a1)+
	and.l	#$55555555,d7
	move.l	d7,(a1)+
	moveq	#$05,d5
	bsr		Encode_MFMClockBits
	move.l	a1,a3
	addq.l	#$08,a1
	move.l	a1,a4
	moveq	#$7F,d5
	moveq	#$00,d4
Encode_FloppyTrackForWrite_SectorDataLoop:		; Memory Address ($85C2) and binary offset [$823E]
	move.l	(a0)+,d7
	move.l	d7,d6
	and.l	#$AAAAAAAA,d6
	lsr.l	#$01,d6
	and.l	#$55555555,d7
	move.l	d7,$0200(a1)
	move.l	d6,(a1)+
	eor.l	d6,d4
	eor.l	d7,d4
	dbra	d5,Encode_FloppyTrackForWrite_SectorDataLoop
	move.l	d4,d7
	and.l	#$AAAAAAAA,d4
	lsr.l	#$01,d4
	and.l	#$55555555,d7
	move.l	a3,a2
	move.l	d4,(a3)+
	move.l	d7,(a3)
	moveq	#$01,d5
	bsr		Encode_MFMClockBits
	move.l	a4,a2
	move.w	#$0080,d5
	bsr		Encode_MFMClockBits
	addq.b	#$01,d1
	subq.b	#$01,d2
	add.l	#$00000200,a1
	dbra	d3,Encode_FloppyTrackForWrite_SectorLoop
	move.l	#$AAAAAAAA,(a1)
	move.w	#$0002,_custom+intreq.l
	move.l	SavedScreenPointer.l,a1
	move.l	a1,_custom+dskpt.l
	move.w	#$8210,_custom+dmacon.l
	move.w	#$7700,_custom+adkcon.l
	move.w	#$9100,_custom+adkcon.l
	move.w	#$4000,_custom+dsklen.l
	move.b	_ciab+ciaicr.l,d0
Encode_FloppyTrackForWrite_WaitIndexPulse:		; Memory Address ($8656) and binary offset [$82D2]
	move.b	_ciab+ciaicr.l,d0
	btst	#$04,d0
	beq.s	Encode_FloppyTrackForWrite_WaitIndexPulse
	move.w	#$D955,_custom+dsklen.l
	move.w	#$D955,_custom+dsklen.l
Encode_FloppyTrackForWrite_WaitDmaComplete:		; Memory Address ($8672) and binary offset [$82EE]
	move.w	_custom+intreqr.l,d0
	btst	#$01,d0
	beq.s	Encode_FloppyTrackForWrite_WaitDmaComplete
	movem.l	(sp)+,d0-d7/a1-a4
	bsr		Delay_FloppyControllerSettle
	bra		Wait_ForFloppyDriveReady

Encode_MFMClockBits:		; Memory Address ($868A) and binary offset [$8306]
	; Adds legal MFM clock bits to the in-memory floppy data stream while
	; preserving spacing across longword boundaries.
	movem.l	d0-d5/a2,-(sp)
	add.w	d5,d5
	subq.w	#$01,d5
	move.b	-$0001(a2),d0
Encode_MFMClockBits_FixupLoop:		; Memory Address ($8696) and binary offset [$8312]
	move.l	(a2),d4
	move.l	d4,d1
	move.l	d4,d2
	not.l	d1
	and.l	#$55555555,d1
	asl.l	#$01,d1
	move.l	d1,d3
	roxr.b	#$01,d0
	roxr.l	#$01,d4
	eor.l	d4,d1
	and.l	d3,d1
	or.l	d1,d2
	move.l	d2,(a2)+
	move.b	d2,d0
	dbra	d5,Encode_MFMClockBits_FixupLoop
	movem.l	(sp)+,d0-d5/a2
	rts		

Read_FloppyTrackSequence:		; Memory Address ($86C0) and binary offset [$833C]
	; Reads, decodes, and advances across the requested sequence of raw floppy
	; tracks.
	move.l	a0,-(sp)
LoadGame_ReadTracksLoop_StepPulseLoop:		; Memory Address ($86C2) and binary offset [$833E]
	bsr		Read_AndDecodeFloppyTrack
	bsr		FloppyDrive_StepPulse
	dbra	d0,LoadGame_ReadTracksLoop_StepPulseLoop
	move.l	(sp)+,a0
	rts		

Wait_ForFloppyDriveReady:		; Memory Address ($86D2) and binary offset [$834E]
	; Polls the CIAA ready-sense bit until the selected floppy drive reports ready.
	btst	#$05,_ciaa.l
	bne.s	Wait_ForFloppyDriveReady
	rts		

;fiX Label expected
	st		FloppySideSelectFlag.l
	move.b	#$79,_ciab+ciaprb.l
	nop		
	nop		
	move.b	#$71,_ciab+ciaprb.l
	move.w	#$B000,d0
SelectDrive0_SetDirTrue_SettleLoop:		; Memory Address ($86FC) and binary offset [$8378]
	dbra	d0,SelectDrive0_SetDirTrue_SettleLoop
	rts		

Select_FloppySideSignalHigh:		; Memory Address ($8702) and binary offset [$837E]
	; Selects drive zero with the floppy side-control signal high and waits for the
	; hardware to settle.
	clr.b	FloppySideSelectFlag.l												;Clears the cached floppy-side state before pulsing DF0 select with the CIAB side-select bit set.
	move.b	#$7D,_ciab+ciaprb.l
	nop		
	nop		
	move.b	#$75,_ciab+ciaprb.l
	move.w	#$B000,d0

SelectDrive0_ClearDirFalse_SettleLoop:		; Memory Address ($8720) and binary offset [$839C]
	dbra	d0,SelectDrive0_ClearDirFalse_SettleLoop
	rts		

FloppyDrive_StepPulse:		; Memory Address ($8726) and binary offset [$83A2]
	; Issues the active-low floppy step pulse using the current driver state, waits
	; for the controller, and resumes the floppy operation.
	tst.b	FloppySideSelectFlag.l												;Chooses the CIAB head-step control pattern from the cached floppy-side state.
	beq.s	StepPulse_EmitDir1Pulse
	move.b	#$70,_ciab+ciaprb.l
	nop		
	nop		
	move.b	#$71,_ciab+ciaprb.l
	bra.s	StepPulse_SettleAndWaitReady

StepPulse_EmitDir1Pulse:		; Memory Address ($8744) and binary offset [$83C0]
	move.b	#$74,_ciab+ciaprb.l
	nop		
	nop		
	move.b	#$75,_ciab+ciaprb.l
StepPulse_SettleAndWaitReady:		; Memory Address ($8758) and binary offset [$83D4]
	bsr		Delay_FloppyControllerSettle
	bra		Wait_ForFloppyDriveReady

FloppyDrive_OppositeDirectionStepPulse:		; Memory Address ($8760) and binary offset [$83DC]
	; Issues a floppy head-step pulse in the direction opposite to the normal
	; track-advance routine.
	tst.b	FloppySideSelectFlag.l
	beq.s	SeekPulse_EmitDir1Pulse
	move.b	#$72,_ciab+ciaprb.l
	nop		
	nop		
	move.b	#$73,_ciab+ciaprb.l
	bra.s	SeekPulse_SettleAndWaitReady

SeekPulse_EmitDir1Pulse:		; Memory Address ($877E) and binary offset [$83FA]
	move.b	#$76,_ciab+ciaprb.l
	nop		
	nop		
	move.b	#$77,_ciab+ciaprb.l
SeekPulse_SettleAndWaitReady:		; Memory Address ($8792) and binary offset [$840E]
	bsr		Delay_FloppyControllerSettle
	bra		Wait_ForFloppyDriveReady

;fiX Label expected
	subq.w	#$01,d6
	beq		StartDMA_Cleanup_SharedExit
	bsr		Delay_FloppyControllerSettle
	bra.s	StartDMA_ProgramDiskRegisters

Read_AndDecodeFloppyTrack:		; Memory Address ($87A6) and binary offset [$8422]
	; Starts raw-track disk DMA, waits with a timeout, and decodes all eleven MFM
	; sectors into the destination buffer.
	movem.l	d0-d2/d5/d6/a1,-(sp)
	moveq	#$03,d6																;Initialises the disk-read retry counter to three attempts; the internal entry at $879A decrements it before restarting DMA setup.
StartDMA_ProgramDiskRegisters:		; Memory Address ($87AC) and binary offset [$8428]
	move.w	#$0002,_custom+intreq.l
	move.l	SavedScreenPointer.l,a1
	clr.l	$0002(a1)
	move.l	a1,_custom+dskpt.l
	move.w	#$8010,_custom+dmacon.l
	move.w	#$4489,_custom+dsksync.l
	move.w	#$9500,_custom+adkcon.l
	move.w	#$4000,_custom+dsklen.l
	move.b	_ciab+ciaicr.l,d0
StartDMA_WaitIndexPulse:		; Memory Address ($87EA) and binary offset [$8466]
	move.b	_ciab+ciaicr.l,d0
	btst	#$04,d0
	beq.s	StartDMA_WaitIndexPulse
	move.w	#$9F40,_custom+dsklen.l
	move.w	#$9F40,_custom+dsklen.l
	move.l	#DiskReadTimeoutCount,d1											;Disk-read timeout counter used while waiting for DMA completion.
StartDMA_WaitDiskBlockOrTimeout:		; Memory Address ($880C) and binary offset [$8488]
	move.w	_custom+intreqr.l,d0
	btst	#$01,d0
	bne.s	StartDMA_BeginTrackDecode
	subq.l	#$01,d1
	bne.s	StartDMA_WaitDiskBlockOrTimeout
StartDMA_BeginTrackDecode:		; Memory Address ($881C) and binary offset [$8498]
	moveq	#$0A,d5
	lea		$003A(a1),a1
StartDMA_DecodeSectorLoop:		; Memory Address ($8822) and binary offset [$849E]
	moveq	#$7F,d6
StartDMA_DecodeSectorLongwordLoop:		; Memory Address ($8824) and binary offset [$84A0]
	move.l	$0200(a1),d1
	move.l	(a1)+,d0
	asl.l	#$01,d0
	and.l	#$AAAAAAAA,d0
	and.l	#$55555555,d1
	or.l	d1,d0
	move.l	d0,(a0)+
	dbra	d6,StartDMA_DecodeSectorLongwordLoop
	add.l	#$00000240,a1
	dbra	d5,StartDMA_DecodeSectorLoop
StartDMA_Cleanup_SharedExit:		; Memory Address ($884A) and binary offset [$84C6]
	movem.l	(sp)+,d0-d2/d5/d6/a1
	rts		

FloppyDrive_SeekToTrackZero:		; Memory Address ($8850) and binary offset [$84CC]
	; Pulses the floppy head toward track zero until the track-zero sense line is
	; asserted.
	move.b	_ciaa.l,d0
	btst	#$04,d0
	beq.s	SeekToTrackZero_AtZero_WaitReady
	bsr		FloppyDrive_OppositeDirectionStepPulse
	bsr		Delay_FloppyControllerSettle
	bra.s	FloppyDrive_SeekToTrackZero

SeekToTrackZero_AtZero_WaitReady:		; Memory Address ($8866) and binary offset [$84E2]
	bra		Wait_ForFloppyDriveReady

Delay_FloppyControllerSettle:		; Memory Address ($886A) and binary offset [$84E6]
	; Provides the fixed hardware delay used between floppy-controller CIA
	; operations.
	move.l	d7,-(sp)
	move.w	#$0960,d7
SettleDelay_CountdownLoop:		; Memory Address ($8870) and binary offset [$84EC]
	dbra	d7,SettleDelay_CountdownLoop
	move.l	(sp)+,d7
	rts		

Select_FloppyDrive0:		; Memory Address ($8878) and binary offset [$84F4]
	; Programs CIAB port B to select floppy drive zero using its active-low select
	; line.
	move.b	#$FD,_ciab+ciaprb.l
	nop		
	nop		
	move.b	#$F5,_ciab+ciaprb.l
	rts		

Seek_FloppyToTrack:		; Memory Address ($888E) and binary offset [$850A]
	; Recalibrates to track zero and then steps the requested number of tracks.
	move.l	d7,-(sp)
	bsr.s	FloppyDrive_SeekToTrackZero
	subq.w	#$01,d7
	bcs.s	SeekTrackZero_StepForward_Exit
SeekTrackZero_StepForwardLoop:		; Memory Address ($8896) and binary offset [$8512]
	bsr		FloppyDrive_StepPulse
	dbra	d7,SeekTrackZero_StepForwardLoop
SeekTrackZero_StepForward_Exit:		; Memory Address ($889E) and binary offset [$851A]
	move.l	(sp)+,d7
	rts		

FloppySideSelectFlag:		; Memory Address ($88A2) and binary offset [$851E]
	; Selects which CIAB side-control pulse pattern the low-level floppy step and
	; seek routines emit.
	ds.b	$2
adrL_0088A4:		; Memory Address ($88A4) and binary offset [$8520]
	move.w	#$0001,_custom+dmacon.l
	move.w	#$0080,_custom+intena.l
	move.w	#$0080,_custom+intreq.l
	rte		
	
PlaySound:
	; Sound playback routine. D0 selects one of six sound effects; the routine
	; resolves the selected sample and offset, programs Paula audio channel 0,
	; performs timed DMA playback, and restores the interrupted sound-control
	; state.
	move.w	d1,-(sp)
	move.w	#$0001,_custom+dmacon.l
	move.w	#$0080,_custom+intena.l
	asl.w	#$02,d0																;Converts the zero-based sound ID into a four-byte index for the sample-offset and playback-period table.
	lea		SFX_AudioSample_1.l,a0
	add.w	AudioSampleOffsets(pc,d0.w),a0										;Adds the selected sample base offset to locate the sound data.
	move.w	AudioSampleOffsets+$2(pc,d0.w),d0									;Loads the selected Paula playback-period value.
	lea		$0030(a0),a0														;Skips the 8SVX header and points Paula at the sample body.
	move.w	-$0002(a0),d1														;Reads the sample-body length stored immediately before the sample data.
	lsr.w	#$01,d1
	asl.w	#$02,d0																;Converts the zero-based sound ID into a four-byte index for the sample-offset and playback-period table.
	move.l	a0,_custom+aud.l
	move.w	d1,_custom+aud0+ac_len.l											;Programs Paula channel 0 with the selected sample length.
	move.w	#$0040,_custom+aud0+ac_vol.l										;Sets Paula channel 0 to maximum volume used by this routine.
	move.w	d0,_custom+aud0+ac_per.l											;Programs the selected sample playback period.
	move.w	(a0),_custom+aud0+ac_dat.l											;Loads the first sample word into Paula channel 0's data register.
	move.w	#$0078,d1
.soundloop1:		; Memory Address ($8910) and binary offset [$858C]
	dbra	d1,.soundloop1
	move.w	#$8001,_custom+dmacon.l												;Enables DMA for Paula channel 0 and its audio master control.
	move.w	#$0078,d1
.soundloop2:		; Memory Address ($8920) and binary offset [$859C]
	dbra	d1,.soundloop2
	move.w	#$0080,_custom+intreq.l												;Clears the pending audio interrupt request after playback.
	move.w	#$8080,_custom+intena.l
	move.w	(sp)+,d1
	rts		

AudioSampleOffsets:		; Memory Address ($8938) and binary offset [$85B4]
	; Six pairs of sound-data offsets and playback periods indexed by D0*4. IDs 0
	; and 1 use different offsets within sample 1; IDs 2 through 5 select samples 2
	; through 5.
	dc.w	SFX_AudioSample_1-SFX_AudioSample_1	;0000
	dc.w	$0028				;0028
	dc.w	SFX_AudioSample_1-SFX_AudioSample_1	;0000
	dc.w	$009B				;009B
	dc.w	SFX_AudioSample_2-SFX_AudioSample_1	;0084
	dc.w	$005D				;005D
	dc.w	SFX_AudioSample_3-SFX_AudioSample_1	;0646
	dc.w	$0028				;0028
	dc.w	SFX_AudioSample_4-SFX_AudioSample_1	;1ECE
	dc.w	$0049				;0049
	dc.w	SFX_AudioSample_5-SFX_AudioSample_1	;3684
	dc.w	$0049				;0049

MouseControl_PreviousJoyState:		; Memory Address ($8950) and binary offset [$85CC]
	; Previous JOY0DAT sample retained so mouse counter movement can be decoded on
	; the next poll.
	ds.b	$2
MouseControl:		; Memory Address ($8952) and binary offset [$85CE]
	move.w	_custom+joy0dat.l,d0
	move.w	MouseControl_PreviousJoyState.l,d1
	move.w	d0,MouseControl_PreviousJoyState.l
	bsr		Calculate_WrappedMouseCounterDelta
	ror.w	#$08,d0
	ror.w	#$08,d1
	bsr		Calculate_WrappedMouseCounterDelta
	lea		Player1_Data.l,a5
	move.w	$0004(a5),d1
	moveq	#$00,d2
	move.b	d0,d2
	ext.w	d2
	add.w	d2,d1
	bpl.s	MouseControl_YFloorClamp
	moveq	#$00,d1
MouseControl_YFloorClamp:		; Memory Address ($8986) and binary offset [$8602]
	cmp.b	$003B(a5),d1
	bcc.s	MouseControl_YUpperBoundClamp
	move.b	$003B(a5),d1
MouseControl_YUpperBoundClamp:		; Memory Address ($8990) and binary offset [$860C]
	cmp.b	$003A(a5),d1
	bcs.s	MouseControl_YClampDone_BeginX
	move.b	$003A(a5),d1
MouseControl_YClampDone_BeginX:		; Memory Address ($899A) and binary offset [$8616]
	move.w	d1,$0004(a5)
	lsr.w	#$08,d0
	ext.w	d0
	move.w	$0002(a5),d1
	add.w	d0,d1
	bpl.s	MouseControl_XNegativeWrapAdd
	add.w	#$0140,d1
MouseControl_XNegativeWrapAdd:		; Memory Address ($89AE) and binary offset [$862A]
	cmpi.w	#$0140,d1
	bcs.s	MouseControl_XWrapClamp_Store
	sub.w	#$0140,d1
MouseControl_XWrapClamp_Store:		; Memory Address ($89B8) and binary offset [$8634]
	move.w	d1,$0002(a5)
	move.l	$0002(a5),d1
	lea		SpritePosition_00.l,a0
	bsr		Encode_HardwareSpritePositionWords
	lea		SpritePosition_01.l,a0
	move.l	#$FF81FFC9,d1
	bsr		Encode_HardwareSpritePositionWords
	move.b	_ciaa.l,d1
	not.b	d1
	and.w	#$0040,d1
	rol.b	#$01,d1
	lea		PreviousFireButtonState.l,a0
	tst.b	d1
	bpl.s	MouseFireButton_StoreStateAndEdgeCheck
	tst.b	(a0)
	bmi.s	MouseControl_ButtonEdgeExit
MouseFireButton_StoreStateAndEdgeCheck:		; Memory Address ($89F6) and binary offset [$8672]
	move.b	d1,(a0)
	tst.b	d1
	bpl.s	MouseControl_ButtonEdgeExit
	tst.b	$0001(a5)
	bmi.s	MouseControl_ButtonEdgeExit
	bset	#$07,$0001(a5)
MouseControl_ButtonEdgeExit:		; Memory Address ($8A08) and binary offset [$8684]
	rts		

Calculate_WrappedMouseCounterDelta:		; Memory Address ($8A0A) and binary offset [$8686]
	; Converts the difference between two eight-bit mouse counters into the signed
	; wrapped movement delta.
	sub.b	d1,d0
	bcc.s	CalcMouseDelta_TestSignNoBorrow
	tst.b	d0
	bmi.s	CalcMouseDelta_ReturnAbs
	bra.s	CalcMouseDelta_NegateResult

CalcMouseDelta_TestSignNoBorrow:		; Memory Address ($8A14) and binary offset [$8690]
	tst.b	d0
	bpl.s	CalcMouseDelta_ReturnAbs
CalcMouseDelta_NegateResult:		; Memory Address ($8A18) and binary offset [$8694]
	neg.b	d0
CalcMouseDelta_ReturnAbs:		; Memory Address ($8A1A) and binary offset [$8696]
	rts		

InputControls:		; Memory Address ($8A1C) and binary offset [$8698]
	; Per-frame input dispatcher: in two-player mode it reads the mouse path; in
	; single-player mode it reads both joystick ports, updates the associated
	; player cursor positions, and rewrites their hardware-sprite position words.
	tst.w	MultiPlayer.l
	bne		MouseControl
	bsr		JoystickControl
	move.w	(a0),d0
	lea		Player2_Data.l,a5
	bsr		Update_JoystickCursorPosition
	lea		SpritePosition_01.l,a0
	bsr.s	Encode_HardwareSpritePositionWords
	lsr.w	#$08,d0
	lea		Player1_Data.l,a5
	bsr		Update_JoystickCursorPosition
	lea		SpritePosition_00.l,a0
Encode_HardwareSpritePositionWords:		; Memory Address ($8A50) and binary offset [$86CC]
	; Encodes the horizontal and vertical position and control bytes for a player
	; pointer's Amiga hardware sprite data.
	add.w	#$0037,d1
	move.b	d1,(a0)
	move.b	d1,$0048(a0)
	move.w	d1,d2
	add.w	#$0010,d1
	move.b	d1,$0002(a0)
	move.b	d1,$004A(a0)
	ror.w	#$07,d1
	ror.w	#$06,d2
	and.w	#$0004,d2
	and.w	#$0002,d1
	or.b	d1,d2
	swap	d1
	add.w	#$0080,d1
	ror.w	#$01,d1
	move.b	d1,$0001(a0)
	move.b	d1,$0049(a0)
	rol.w	#$01,d1
	and.w	#$0001,d1
	or.b	d2,d1
	move.b	d1,$0003(a0)
	move.b	d1,$004B(a0)
	rts		

Update_JoystickCursorPosition:		; Memory Address ($8A98) and binary offset [$8714]
	; Applies decoded joystick direction bits to a player's pointer, clamping
	; vertical movement and wrapping horizontal movement.
	move.l	$0002(a5),d1
	lsr.b	#$01,d0
	bcc.s	ClampCursor_AfterYDecrementClamp
	subq.w	#$02,d1
	cmp.b	$003B(a5),d1
	bcc.s	ClampCursor_AfterYDecrementClamp
	addq.w	#$02,d1
ClampCursor_AfterYDecrementClamp:		; Memory Address ($8AAA) and binary offset [$8726]
	lsr.b	#$01,d0
	bcc.s	ClampCursor_AfterYIncrementClamp
	addq.w	#$02,d1
	cmp.b	$003A(a5),d1
	bcs.s	ClampCursor_AfterYIncrementClamp
	subq.w	#$02,d1
ClampCursor_AfterYIncrementClamp:		; Memory Address ($8AB8) and binary offset [$8734]
	swap	d1
	lsr.b	#$01,d0
	bcc.s	ClampCursor_AfterXDecrementWrap
	subq.w	#$02,d1
	bcc.s	ClampCursor_AfterXDecrementWrap
	add.w	#$0140,d1
ClampCursor_AfterXDecrementWrap:		; Memory Address ($8AC6) and binary offset [$8742]
	lsr.b	#$01,d0
	bcc.s	ClampCursor_BeforeXWrapCheck
	addq.w	#$02,d1
ClampCursor_BeforeXWrapCheck:		; Memory Address ($8ACC) and binary offset [$8748]
	cmpi.w	#$0140,d1
	bcs.s	ClampCursor_AfterXWrapCheck
	sub.w	#$0140,d1
ClampCursor_AfterXWrapCheck:		; Memory Address ($8AD6) and binary offset [$8752]
	swap	d1
	move.l	d1,$0002(a5)
	rts		

Decode_JoystickDirectionBits:		; Memory Address ($8ADE) and binary offset [$875A]
	; Converts the Amiga joystick quadrature bits into the four directional flags
	; consumed by pointer movement.
	move.w	d0,d1
	ror.w	#$01,d0
	eor.w	d0,d1
	moveq	#$00,d2
	lsr.w	#$01,d0
	addx.b	d2,d2
	add.b	d0,d0
	addx.b	d2,d2
	lsr.w	#$01,d1
	addx.b	d2,d2
	add.b	d1,d1
	addx.b	d2,d2
	move.w	d2,d0
	rts		

JoystickControl_PreviousButtonStateBase:		; Memory Address ($8AFA) and binary offset [$8776]
	; Base used by JoystickControl to index the per-player previous fire-button
	; bytes.
	ds.b	$2
PreviousFireButtonState:		; Memory Address ($8AFC) and binary offset [$8778]
	; Per-player fire-button edge-latch bytes used by joystick and mouse control.
	ds.b	$2
JoystickControl:		; Memory Address ($8AFE) and binary offset [$877A]
	; Reads both joystick/mouse-counter ports and CIAA fire-button bits, decodes
	; their directional deltas, and stores the combined per-player movement and
	; button state.
	move.w	_custom+joy0dat.l,d0
	bsr.s	Decode_JoystickDirectionBits
	move.b	_ciaa.l,d1
	not.b	d1
	and.w	#$0040,d1
	rol.b	#$01,d1
	or.b	d1,d0
	swap	d0
	move.w	_custom+joy1dat.l,d0
	bsr.s	Decode_JoystickDirectionBits
	move.b	_ciaa.l,d1
	not.b	d1
	and.b	#$80,d1
	or.b	d1,d0
	lea		JoystickControl_PreviousButtonStateBase.l,a0
	lea		Player2_Data.l,a5
	moveq	#$01,d1
JoystickControl_PerPlayerLoop:		; Memory Address ($8B3C) and binary offset [$87B8]
	tst.b	$02(a0,d1.w)
	bpl.s	JoystickControl_StoreNewButtonState
	move.b	d0,$02(a0,d1.w)
	and.b	#$7F,d0
	bra.s	JoystickControl_StoreDeltaAndCheckEdge

JoystickControl_StoreNewButtonState:		; Memory Address ($8B4C) and binary offset [$87C8]
	move.b	d0,$02(a0,d1.w)
JoystickControl_StoreDeltaAndCheckEdge:		; Memory Address ($8B50) and binary offset [$87CC]
	move.b	d0,$00(a0,d1.w)
	tst.b	d0
	bpl.s	JoystickControl_LoopTail_NextPlayer
	tst.b	$0001(a5)
	bmi.s	JoystickControl_LoopTail_NextPlayer
	bset	#$07,$0001(a5)
JoystickControl_LoopTail_NextPlayer:		; Memory Address ($8B64) and binary offset [$87E0]
	lea		Player1_Data.l,a5
	swap	d0
	dbra	d1,JoystickControl_PerPlayerLoop
	rts		

Update_PlayerDialogueTextColour:		; Memory Address ($8B72) and binary offset [$87EE]
	; Selects the active player's six-step dialogue-text fade ramp and writes
	; hardware palette index 15.
	tst.w	Paused_Marker.l
	bne.s	PlayerColourRampLookupBase_Exit
	tst.b	$0052(a5)
	bmi.s	Restore_PlayerDialogueTextColour
	moveq	#$00,d0
	move.b	$004B(a5),d0
	bne.s	DialogueColour_ComputeRampIndex
	move.b	$0052(a5),d0
	and.w	#$003F,d0
	beq.s	Restore_PlayerDialogueTextColour
	move.w	#$90FF,$004A(a5)
	bra.s	Restore_PlayerDialogueTextColour

DialogueColour_ComputeRampIndex:		; Memory Address ($8B9A) and binary offset [$8816]
	tst.b	$004A(a5)
	bne.s	DialogueColour_DecrementHoldCounter
	tst.b	d0
	bpl.s	DialogueColour_ApplyPlayerRampOffset
	cmpi.w	#$00F9,d0
	beq.s	Restore_PlayerDialogueTextColour
	neg.b	d0
DialogueColour_ApplyPlayerRampOffset:		; Memory Address ($8BAC) and binary offset [$8828]
	subq.b	#$01,$004B(a5)
	move.b	#$02,$004A(a5)
	btst	#$00,(a5)
	beq.s	DialogueColour_ApplyAltRampOffset
	add.w	#$000C,d0															;Selects Player 2's orange dialogue-ramp family by adding $0C to the table index; doubling then produces a 24-byte displacement.
DialogueColour_ApplyAltRampOffset:		; Memory Address ($8BC0) and binary offset [$883C]
	btst	#$06,$0052(a5)														;Tests the dialogue state bit that selects the shared red monster/alternate-speaker ramp.
	beq.s	DialogueColour_LookupAndWriteRamp
	addq.w	#$06,d0
DialogueColour_LookupAndWriteRamp:		; Memory Address ($8BCA) and binary offset [$8846]
	add.w	d0,d0
	move.w	PlayerColourRampTable-2(pc,d0.w),d0									;Uses PlayerColourRampTable-2 as the preserved $8BE8 PC-relative base; indices 1-24 address the green, red, orange, and red dialogue fades at $8BEA.

	move.w	d0,_custom+color+$0000001E.l										;Writes the active player's dialogue ink to hardware colour register 15 for the current Copper-scheduled raster region.
	move.w	d0,$004C(a5)														;Stores the selected hardware dialogue-text colour 15 word in the active PlayerX_Data record.
	rts		

DialogueColour_DecrementHoldCounter:		; Memory Address ($8BDC) and binary offset [$8858]
	subq.b	#$01,$004A(a5)
Restore_PlayerDialogueTextColour:		; Memory Address ($8BE0) and binary offset [$885C]
	; Restores the active player's cached dialogue colour to hardware palette
	; register 15.
	move.w	$004C(a5),_custom+color+$0000001E.l									;Restores the active player's current dialogue colour 15 at this Copper-scheduled raster region when no fade step advances.
PlayerColourRampLookupBase_Exit:		; Memory Address ($8BE8) and binary offset [$8864]
	; Exit point and preserved PC-relative lookup base used by the dialogue-text
	; colour update routine.
	rts		

PlayerColourRampTable:		; Memory Address ($8BEA) and binary offset [$8866]
	; 24 hardware colour words forming green Player 1, orange Player 2, and shared
	; red alternate dialogue fades; the preceding RTS at $8BE8 is outside the
	; resource.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/PlayerColourRamps.colours"
VBI_Marker:		; Memory Address ($8C1A) and binary offset [$8896]
	ds.b	$2
Paused_Marker:		; Memory Address ($8C1C) and binary offset [$8898]
	ds.b	$2
FrameSyncFlag:		; Memory Address ($8C1E) and binary offset [$889A]
	; Frame-ready byte polled and cleared by render/raster paths; word writes at
	; this address also modify the adjacent input-enable flag.
	ds.b	$1
InputProcessingEnabledFlag:		; Memory Address ($8C1F) and binary offset [$889B]
	; Enables per-frame input dispatch after champion selection reaches live play.
	dc.b	$FF	;FF

VerticalBlankInterupt:		; Memory Address ($8C20) and binary offset [$889C]
	move.w	d0,-(sp)
	move.w	_custom+intreqr.l,d0
	and.w	#$0020,d0
	beq.s	Handle_CopperRasterInterrupt
	move.w	(sp)+,d0
	move.w	#$0020,_custom+intreq.l
	clr.w	VBI_Marker.l
	rte		

Handle_CopperRasterInterrupt:		; Memory Address ($8C40) and binary offset [$88BC]
	; Handles Copper-triggered raster interrupts, alternating Player 2
	; dialogue-colour service with the Player 1 frame service.
	move.w	(sp)+,d0
	eor.w	#$0001,VBI_Marker.l
	beq.s	Handle_Player1RasterAndFrameUpdate
	movem.l	d0/a5,-(sp)
	lea		Player2_Data.l,a5													;Selects Player 2 for the first Copper-scheduled dialogue-colour raster service.
	bsr		Update_PlayerDialogueTextColour										;Updates hardware colour 15 from Player 2's dialogue fade state for the lower player region.
	movem.l	(sp)+,d0/a5
	bra		RasterInterrupt_SignalDoneAndExit_SharedTail

Handle_Player1RasterAndFrameUpdate:		; Memory Address ($8C62) and binary offset [$88DE]
	; Runs Player 1 dialogue-colour service and the normal timing, input, and frame
	; update at the second Copper interrupt.
	movem.l	d0-d7/a0-a6,-(sp)
	subq.w	#$01,RasterInterruptCountdownA.l
	bcc.s	FrameUpdate_ClampCountdownB_Stage
	clr.w	RasterInterruptCountdownA.l
FrameUpdate_ClampCountdownB_Stage:		; Memory Address ($8C74) and binary offset [$88F0]
	subq.w	#$01,RasterInterruptCountdownB.l
	bcc.s	FrameUpdate_BeginWorldTickClampLoop
	clr.w	RasterInterruptCountdownB.l
FrameUpdate_BeginWorldTickClampLoop:		; Memory Address ($8C82) and binary offset [$88FE]
	lea		WorldTick_300UnitCountdown.l,a0
	moveq	#$02,d0
FrameUpdate_WorldTickClampLoop:		; Memory Address ($8C8A) and binary offset [$8906]
	subq.w	#$01,(a0)+
	bcc.s	FrameUpdate_WorldTickClamp_Continue
	clr.w	-$0002(a0)
FrameUpdate_WorldTickClamp_Continue:		; Memory Address ($8C92) and binary offset [$890E]
	dbra	d0,FrameUpdate_WorldTickClampLoop
	lea		Player1_Data.l,a5													;Selects Player 1 for the second Copper-scheduled dialogue-colour service and frame update.
	bsr		Update_PlayerDialogueTextColour										;Updates hardware colour 15 from Player 1's dialogue fade state after the raster/frame wrap.
	tst.b	InputProcessingEnabledFlag.l
	beq.s	FrameUpdate_RestoreRegs_SharedExit
	bsr		InputControls
	tst.b	FrameSyncFlag.l
	beq.s	FrameUpdate_RestoreRegs_SharedExit
	clr.b	FrameSyncFlag.l
	bsr.s	Swap_DisplayAndDrawBuffers
FrameUpdate_RestoreRegs_SharedExit:		; Memory Address ($8CBC) and binary offset [$8938]
	movem.l	(sp)+,d0-d7/a0-a6
RasterInterrupt_SignalDoneAndExit_SharedTail:		; Memory Address ($8CC0) and binary offset [$893C]
	move.w	#$0010,_custom+intreq.l
adrL_008CC8:		; Memory Address ($8CC8) and binary offset [$8944]
	rte		

Swap_DisplayAndDrawBuffers:		; Memory Address ($8CCA) and binary offset [$8946]
	; Swaps the display and drawing screen buffers and updates all four Copper
	; bitplane pointers.
	cmp.l	#$00060000,screen_ptr.l
	bne.s	SwapBuffers_SelectPrimaryScreen
	move.l	#$00067D00,screen_ptr.l
	move.l	#$00060000,framebuffer_ptr.l
	bra.s	Update_CopperBitplanePointersForOppositeScreenBuffer

SwapBuffers_SelectPrimaryScreen:		; Memory Address ($8CEC) and binary offset [$8968]
	move.l	#$00060000,screen_ptr.l
	move.l	#$00067D00,framebuffer_ptr.l
Update_CopperBitplanePointersForOppositeScreenBuffer:		; Memory Address ($8D00) and binary offset [$897C]
	; Rewrites the four Copper bitplane pointers to the screen buffer opposite the
	; current drawing buffer.
	lea		CopperList_00.l,a0
	move.l	#$00060000,d0
	cmp.l	screen_ptr.l,d0
	bne.s	SwapBuffers_InitPlaneCounter
	move.l	#$00067D00,d0
SwapBuffers_InitPlaneCounter:		; Memory Address ($8D1A) and binary offset [$8996]
	moveq	#$03,d1
SwapBuffers_CopperPointerLoop:		; Memory Address ($8D1C) and binary offset [$8998]
	move.w	d0,$0006(a0)
	swap	d0
	move.w	d0,$0002(a0)
	swap	d0
	add.l	#$00001F40,d0														;Long Addr replaced with Symbol
	addq.w	#$08,a0
	dbra	d1,SwapBuffers_CopperPointerLoop
	rts		

screen_ptr:
	dc.l	$00060000	;00060000
framebuffer_ptr:
	dc.l	$00067D00	;00067D00

Blit_MaskedPocketsOverlayLoop:		; Memory Address ($8D3E) and binary offset [$89BA]
	; Applies a row-based AND and OR mask while copying an overlay crop from the
	; Pockets graphics sheet.
	swap	d5
	move.w	d5,d4
Blit_MaskedPocketsOverlayLoop_RowLoop:		; Memory Address ($8D42) and binary offset [$89BE]
	move.w	(a0),d2
	or.w	$1F40(a0),d2
	or.w	$3E80(a0),d2
	or.w	$5DC0(a0),d2
	not.w	d2
	move.l	(a1)+,d0
	move.l	(a1)+,d1
	and.w	d2,d1
	or.w	d1,$5DC0(a0)
	swap	d1
	and.w	d2,d1
	or.w	d1,$3E80(a0)
	and.w	d2,d0
	or.w	d0,$1F40(a0)
	swap	d0
	and.w	d2,d0
	or.w	d0,(a0)+
	dbra	d4,Blit_MaskedPocketsOverlayLoop_RowLoop
	sub.w	d5,a0
	sub.w	d5,a0
	lea		$0026(a0),a0
	lea		$0070(a1),a1
	swap	d5
	dbra	d5,Blit_MaskedPocketsOverlayLoop
	rts		

Copy_DrawBufferToDisplayBuffer:		; Memory Address ($8D88) and binary offset [$8A04]
	; Copies the complete 320 by 200 four-plane drawing buffer to the display
	; buffer.
	move.l	screen_ptr.l,a1
	move.l	framebuffer_ptr.l,a0
	move.w	#$1F3F,d0
Copy_DrawBufferToDisplayBuffer_CopyLoop:		; Memory Address ($8D98) and binary offset [$8A14]
	move.l	(a0)+,(a1)+
	dbra	d0,Copy_DrawBufferToDisplayBuffer_CopyLoop
	rts		

Clear_DrawBuffer:		; Memory Address ($8DA0) and binary offset [$8A1C]
	; Selects and clears the complete drawing screen buffer.
	move.l	framebuffer_ptr.l,a0
	bra.s	ClearFourPlaneBuffer_SharedEntry

Clear_DisplayBuffer:		; Memory Address ($8DA8) and binary offset [$8A24]
	; Selects and clears the complete display screen buffer through the shared
	; clearing loop.
	move.l	screen_ptr.l,a0
ClearFourPlaneBuffer_SharedEntry:		; Memory Address ($8DAE) and binary offset [$8A2A]
	move.w	#$1F3F,d0
ClearFourPlaneBuffer_ClearLoop:		; Memory Address ($8DB2) and binary offset [$8A2E]
	clr.l	(a0)+
	dbra	d0,ClearFourPlaneBuffer_ClearLoop
	rts		

Load_GamePaletteIntoColourRegisters:		; Memory Address ($8DBA) and binary offset [$8A36]
	; Copies all 32 game palette words into the Amiga custom colour registers.
	lea		_custom+color.l,a1
	lea		GamePalette.l,a0
	moveq	#$1F,d0
Load_GamePalette_CopyLoop:		; Memory Address ($8DC8) and binary offset [$8A44]
	move.w	(a0)+,(a1)+
	dbra	d0,Load_GamePalette_CopyLoop
	rts		

GamePalette:		; Memory Address ($8DD0) and binary offset [$8A4C]
	; Thirty-two Amiga colour-register words: the first sixteen are the main game
	; palette and the remaining entries support the hardware display palette.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/GamePalette.palette"
CopperList_00:
	dc.w	$00E0	;00E0
	dc.w	$0007	;0007
	dc.w	$00E2	;00E2
	dc.w	$0000	;0000
	dc.w	$00E4	;00E4
	dc.w	$0007	;0007
	dc.w	$00E6	;00E6
	dc.w	$2000	;2000
	dc.w	$00E8	;00E8
	dc.w	$0007	;0007
	dc.w	$00EA	;00EA
	dc.w	$4000	;4000
	dc.w	$00EC	;00EC
	dc.w	$0007	;0007
	dc.w	$00EE	;00EE
	dc.w	$6000	;6000
CopperList_01:
	dc.w	$0120	;0120
	dc.w	$0000	;0000
	dc.w	$0122	;0122
	dc.w	$0000	;0000
	dc.w	$0124	;0124
	dc.w	$0000	;0000
	dc.w	$0126	;0126
	dc.w	$0000	;0000
	dc.w	$0128	;0128
	dc.w	$0000	;0000
	dc.w	$012A	;012A
	dc.w	$0000	;0000
	dc.w	$012C	;012C
	dc.w	$0000	;0000
	dc.w	$012E	;012E
	dc.w	$0000	;0000
	dc.w	$0130	;0130
	dc.w	$0000	;0000
	dc.w	$0132	;0132
	dc.w	$0000	;0000
	dc.w	$0134	;0134
	dc.w	$0000	;0000
	dc.w	$0136	;0136
	dc.w	$0000	;0000
	dc.w	$0138	;0138
	dc.w	$0000	;0000
	dc.w	$013A	;013A
	dc.w	$0000	;0000
	dc.w	$013C	;013C
	dc.w	$0000	;0000
	dc.w	$013E	;013E
	dc.w	$0000	;0000
	dc.w	$9801	;9801
	dc.w	$FF00	;FF00
	dc.w	$009C	;009C
	dc.w	$8010	;8010
	dc.w	$FF01	;FF01
	dc.w	$FF00	;FF00
	dc.w	$009C	;009C
	dc.w	$8010	;8010
	dc.w	$FFFF	;FFFF
	dc.w	$FFFE	;FFFE
SpritePosition_00:		; Memory Address ($8E84) and binary offset [$8B00]
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C000	;C000
	dc.w	$0000	;0000
	dc.w	$A000	;A000
	dc.w	$0000	;0000
	dc.w	$9000	;9000
	dc.w	$0000	;0000
	dc.w	$8800	;8800
	dc.w	$0000	;0000
	dc.w	$8400	;8400
	dc.w	$0000	;0000
	dc.w	$8200	;8200
	dc.w	$0000	;0000
	dc.w	$8100	;8100
	dc.w	$0000	;0000
	dc.w	$8080	;8080
	dc.w	$0000	;0000
	dc.w	$8040	;8040
	dc.w	$0000	;0000
	dc.w	$8380	;8380
	dc.w	$0000	;0000
	dc.w	$9200	;9200
	dc.w	$0000	;0000
	dc.w	$A900	;A900
	dc.w	$0000	;0000
	dc.w	$4900	;4900
	dc.w	$0000	;0000
	dc.w	$0480	;0480
	dc.w	$0000	;0000
	dc.w	$0480	;0480
	dc.w	$0000	;0000
	dc.w	$0300	;0300
	dc.w	$0000	;0000
SpritePosition_03:		; Memory Address ($8EC8) and binary offset [$8B44]
	; Two-word hardware sprite-position record referenced as sprite channel 3
	; during Copper initialisation.
	ds.b	$4
SpritePosition_04:		; Memory Address ($8ECC) and binary offset [$8B48]
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4000	;4000
	dc.w	$0000	;0000
	dc.w	$6000	;6000
	dc.w	$0000	;0000
	dc.w	$5000	;5000
	dc.w	$2000	;2000
	dc.w	$4800	;4800
	dc.w	$3000	;3000
	dc.w	$5400	;5400
	dc.w	$3800	;3800
	dc.w	$5A00	;5A00
	dc.w	$3C00	;3C00
	dc.w	$5D00	;5D00
	dc.w	$3E00	;3E00
	dc.w	$5080	;5080
	dc.w	$3F00	;3F00
	dc.w	$4000	;4000
	dc.w	$3C00	;3C00
	dc.w	$4400	;4400
	dc.w	$2C00	;2C00
	dc.w	$4000	;4000
	dc.w	$0600	;0600
	dc.w	$0200	;0200
	dc.w	$0600	;0600
	dc.w	$0100	;0100
	dc.w	$0200	;0200
	dc.w	$0300	;0300
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
SpritePosition_01:		; Memory Address ($8F14) and binary offset [$8B90]
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C000	;C000
	dc.w	$0000	;0000
	dc.w	$A000	;A000
	dc.w	$0000	;0000
	dc.w	$9000	;9000
	dc.w	$0000	;0000
	dc.w	$8800	;8800
	dc.w	$0000	;0000
	dc.w	$8400	;8400
	dc.w	$0000	;0000
	dc.w	$8200	;8200
	dc.w	$0000	;0000
	dc.w	$8100	;8100
	dc.w	$0000	;0000
	dc.w	$8080	;8080
	dc.w	$0000	;0000
	dc.w	$8040	;8040
	dc.w	$0000	;0000
	dc.w	$8380	;8380
	dc.w	$0000	;0000
	dc.w	$9200	;9200
	dc.w	$0000	;0000
	dc.w	$A900	;A900
	dc.w	$0000	;0000
	dc.w	$4900	;4900
	dc.w	$0000	;0000
	dc.w	$0480	;0480
	dc.w	$0000	;0000
	dc.w	$0480	;0480
	dc.w	$0000	;0000
	dc.w	$0300	;0300
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
SpritePosition_02:		; Memory Address ($8F5C) and binary offset [$8BD8]
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4000	;4000
	dc.w	$0000	;0000
	dc.w	$6000	;6000
	dc.w	$0000	;0000
	dc.w	$5000	;5000
	dc.w	$2000	;2000
	dc.w	$4800	;4800
	dc.w	$3000	;3000
	dc.w	$5400	;5400
	dc.w	$3800	;3800
	dc.w	$5A00	;5A00
	dc.w	$3C00	;3C00
	dc.w	$5D00	;5D00
	dc.w	$3E00	;3E00
	dc.w	$5080	;5080
	dc.w	$3F00	;3F00
	dc.w	$4000	;4000
	dc.w	$3C00	;3C00
	dc.w	$4400	;4400
	dc.w	$2C00	;2C00
	dc.w	$4000	;4000
	dc.w	$0600	;0600
	dc.w	$0200	;0200
	dc.w	$0600	;0600
	dc.w	$0100	;0100
	dc.w	$0200	;0200
	dc.w	$0300	;0300
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000

Clear_ViewportMessageBackground:		; Memory Address ($8FA4) and binary offset [$8C20]
	; Clears the active player's framed viewport-message area before sleep, death,
	; or completion text is drawn.
	move.l	#$007F0060,d4
	move.l	#$004B000C,d5
	add.w	$0008(a5),d5
	bra		BW_draw_bar

Refresh_ActivePlayerDungeonViewport:		; Memory Address ($8FB8) and binary offset [$8C34]
	; Skips unavailable player states, resolves the viewer record and perception,
	; and redraws the active player's dungeon viewport.
	btst	#$06,$0018(a5)
	bne.s	Calculate_ViewerObjectPerception_ZeroExit
	btst	#$02,(a5)
	bne.s	Calculate_ViewerObjectPerception_ZeroExit
	move.b	PlayerData_ViewportFillInk(a5),d3
	bpl.s	Clear_ViewportMessageBackground
	move.b	PlayerData_RemoteViewerChampionIndex(a5),d0
	bmi.s	ViewportInk_CurrentChampionSetup
	bsr		Load_ChampionStatRecord
	link	a3,#-$0020
	moveq	#$00,d0
	move.b	ChampionStat_XPosition(a4),d0
	move.w	d0,-$0004(a3)
	move.b	ChampionStat_YPosition(a4),d0
	move.w	d0,-$0002(a3)
	move.b	ChampionStat_Direction(a4),d0
	and.w	#$0003,d0
	move.w	d0,-$000A(a3)
	bsr.s	Calculate_ViewerObjectPerception
	move.b	ChampionStat_Floor(a4),d0
	bra.s	ViewportInk_AfterPerception_LookupTile

Calculate_ViewerObjectPerception:		; Memory Address ($9000) and binary offset [$8C7C]
	; Calculates the active viewer's nonzero perception value used when deciding
	; whether concealed cell contents are visible.
	moveq	#$00,d1
	move.b	ChampionStat_WornSpell(a4),d0
	and.w	#$0007,d0
	subq.b	#$07,d0
	beq.s	Calculate_ViewerObjectPerception_Trueview
	move.l	a4,d0
	sub.l	#Character_Stats_DataTable,d0
	lsr.w	#$05,d0
	move.w	d0,d2
	and.w	#$0003,d2
	cmpi.b	#$03,d2
	bne.s	Calculate_ViewerObjectPerception_ZeroExit
	bsr		RandomGen_BytewithOffset
	OPT		O2+
	move.b	ChampionStat_Level(a4),d2
	OPT		O2-
	asl.b	#$04,d2
	moveq	#$00,d1
	cmp.b	d0,d2
	bcs.s	Calculate_ViewerObjectPerception_ZeroExit
	OPT		O2+
	move.b	ChampionStat_Level(a4),d1
	OPT		O2-
	add.w	d1,d1
Calculate_ViewerObjectPerception_ZeroExit:		; Memory Address ($9036) and binary offset [$8CB2]
	rts		

Calculate_ViewerObjectPerception_Trueview:		; Memory Address ($9038) and binary offset [$8CB4]
	move.b	$0011(a4),d1
	lsr.b	#$03,d1
	addq.w	#$01,d1
	rts		

ViewportInk_CurrentChampionSetup:		; Memory Address ($9042) and binary offset [$8CBE]
	link	a3,#-$0020
	move.l	$001C(a5),-$0004(a3)
	move.w	$0020(a5),-$000A(a3)
	bsr		Load_CurrentChampionStatRecord
	bsr.s	Calculate_ViewerObjectPerception
	move.w	$0058(a5),d0
ViewportInk_AfterPerception_LookupTile:		; Memory Address ($905C) and binary offset [$8CD8]
	move.w	d0,-$001E(a3)
	move.b	d1,-$001F(a3)
	bsr		Select_FloorMapByIndex
	move.l	-$0004(a3),d7
	bsr		CoordToMap
	btst	#$05,$01(a6,d0.w)
	beq.s	Draw_DungeonViewport
	bsr		Find_FloorObjectRecordByMapLink
	move.w	$0002(a0),d1
	move.w	d1,d0
	and.w	#$0003,d1
	cmpi.w	#$0002,d1
	bcc.s	Draw_DungeonViewport
	and.w	#$00FC,d0
	cmpi.w	#$002C,d0
	bcc.s	ViewportInk_LookupColumnInkByte
	cmpi.w	#$0020,d0
	bcc.s	Draw_DungeonViewport
ViewportInk_LookupColumnInkByte:		; Memory Address ($909C) and binary offset [$8D18]
	lsr.w	#$01,d0
	add.w	d0,d1
	move.b	DungeonViewportColumnInkTable(pc,d1.w),$003D(a5)
	unlk	a3
	bra		Refresh_ActivePlayerDungeonViewport

DungeonViewportColumnInkTable:		; Memory Address ($90AC) and binary offset [$8D28]
	; Maps a dungeon-view column key to the player-state ink used before viewport
	; drawing.
	dc.b	$0E	;0E
	dc.b	$0C	;0C
	dc.b	$0E	;0E
	dc.b	$07	;07
	dc.b	$0E	;0E
	dc.b	$06	;06
	dc.b	$00	;00
	dc.b	$0D	;0D
	dc.b	$0E	;0E
	dc.b	$0A	;0A
	dc.b	$0E	;0E
	dc.b	$0C	;0C
	dc.b	$0E	;0E
	dc.b	$0D	;0D
	dc.b	$0E	;0E
	dc.b	$0B	;0B
	dc.b	$0E	;0E
	dc.b	$09	;09
	dc.b	$0E	;0E
	dc.b	$05	;05
	dc.b	$0E	;0E
	dc.b	$0C	;0C
	dc.b	$07	;07
	dc.b	$00	;00
	dc.b	$06	;06
	dc.b	$0D	;0D
	dc.b	$08	;08
	dc.b	$04	;04
	dc.b	$0D	;0D
	dc.b	$0A	;0A
	dc.b	$0D	;0D
	dc.b	$0B	;0B
	dc.b	$00	;00
	dc.b	$0E	;0E
	dc.b	$0E	;0E
	dc.b	$0C	;0C
	dc.b	$0E	;0E
	dc.b	$06	;06
	dc.b	$0E	;0E
	dc.b	$08	;08

Draw_DungeonViewport:		; Memory Address ($90D4) and binary offset [$8D50]
	; Scans the 19 relative dungeon cells, builds the visibility and occlusion
	; masks, then draws the surviving cells.
	move.l	screen_ptr.l,a0
	add.w	#$01EC,a0
	add.w	$000A(a5),a0
	move.l	a0,-$0008(a3)
	move.w	-$0004(a3),d0
	add.w	-$0002(a3),d0
	add.w	-$000A(a3),d0
	and.w	#$0001,d0
	move.w	d0,-$000C(a3)
	bsr		Draw_FloorAndCeiling
	move.w	-$000A(a3),d0
	move.w	d0,d1
	ror.b	#$03,d0
	add.w	d1,d1
	add.w	d1,d0
	add.w	d1,d1
	add.w	d1,d0
	lea		Dungeon_ViewCell_RelativeCoordinates.l,a0
	add.w	d0,a0
	move.l	a0,-$0010(a3)
	move.l	CurrentFloorWidth.l,d1
	move.w	d1,d2
	swap	d1
	move.l	-$0004(a3),d3
	move.l	Current_TowerMapDataBase.l,a6
	moveq	#$00,d6
Build_DungeonVisibilityMasks_Loop:		; Memory Address ($9130) and binary offset [$8DAC]
	; Scans one player-relative view cell and records whether its map contents
	; block or contribute visible faces.
	lsr.l	#$01,d5
	lsr.l	#$01,d4
	move.l	d3,d7
	add.b	$0001(a0),d7
	cmp.w	d2,d7
	bcc		Build_DungeonVisibilityMasks_MarkCellVisible
	swap	d7
	add.b	(a0),d7
	cmp.w	d1,d7
	bcc.s	Build_DungeonVisibilityMasks_MarkCellVisible
	swap	d7
	bsr		Calculate_MapOffsetFromPackedCoordinate
	move.w	$00(a6,d0.w),d0
	tst.b	d0
	beq.s	Build_DungeonVisibilityMasks_NextCell
	and.b	#$07,d0
	beq.s	Build_DungeonVisibilityMasks_MarkCellOpaque
	cmpi.b	#Dungeon_MapCell_MainWallType,d0
	beq.s	Build_DungeonVisibilityMasks_MarkCellVisible
	cmpi.b	#$07,d0
	bne.s	Build_DungeonVisibilityMasks_CheckWallType2
	lsr.w	#$08,d0
	and.w	#$0003,d0
	cmpi.b	#$02,d0
	bcs.s	Build_DungeonVisibilityMasks_MarkCellOpaque
	bne.s	Build_DungeonVisibilityMasks_MarkCellVisible
	tst.b	-$001F(a3)
	beq.s	Build_DungeonVisibilityMasks_MarkCellVisible
	bra.s	Build_DungeonVisibilityMasks_MarkCellOpaque

Build_DungeonVisibilityMasks_CheckWallType2:		; Memory Address ($917E) and binary offset [$8DFA]
	cmpi.b	#$02,d0
	bne.s	Build_DungeonVisibilityMasks_MarkCellOpaque
	move.w	-$000A(a3),d7
	cmpi.w	#Dungeon_ViewCell_LastIndex,d6
	beq.s	Build_DungeonVisibilityMasks_TestFacingBit
	addq.w	#$02,d7
	and.w	#$0003,d7
Build_DungeonVisibilityMasks_TestFacingBit:		; Memory Address ($9194) and binary offset [$8E10]
	add.w	d7,d7
	addq.w	#$08,d7
	btst	d7,d0
	beq.s	Build_DungeonVisibilityMasks_MarkCellOpaque
	cmpi.w	#$000E,d6
	bcc.s	Build_DungeonVisibilityMasks_MarkCellVisible
	move.w	-$000A(a3),d7
	addq.w	#$01,d7
	cmpi.w	#$0007,d6
	bcs.s	Build_DungeonVisibilityMasks_TestFacingBit2
	addq.w	#$02,d7
Build_DungeonVisibilityMasks_TestFacingBit2:		; Memory Address ($91B0) and binary offset [$8E2C]
	and.w	#$0003,d7
	add.w	d7,d7
	addq.w	#$08,d7
	btst	d7,d0
	bne.s	Build_DungeonVisibilityMasks_MarkCellVisible
Build_DungeonVisibilityMasks_MarkCellOpaque:		; Memory Address ($91BC) and binary offset [$8E38]
	bset	#$1F,d4
Build_DungeonVisibilityMasks_MarkCellVisible:		; Memory Address ($91C0) and binary offset [$8E3C]
	bset	#$1F,d5
Build_DungeonVisibilityMasks_NextCell:		; Memory Address ($91C4) and binary offset [$8E40]
	addq.w	#$02,a0
	addq.w	#$01,d6
	cmpi.w	#$0013,d6
	bcs		Build_DungeonVisibilityMasks_Loop
	rol.l	#$03,d5
	swap	d5
	rol.l	#$03,d4
	swap	d4
	lea		Dungeon_ViewCell_VisibleFaceMasks+$48.l,a6
	lea		Dungeon_ViewCell_OcclusionMasks+$48.l,a4
	moveq	#$00,d7
	moveq	#-$01,d0
	moveq	#Dungeon_ViewCell_LastIndex,d6
Apply_DungeonOcclusionMasks_Loop:		; Memory Address ($91EA) and binary offset [$8E66]
	; Combines the per-cell visible-face and occlusion masks from farthest view
	; cell to nearest.
	btst	d6,d5
	beq.s	Apply_DungeonOcclusionMasks_NextCell
	or.l	(a6),d7
	btst	d6,d4
	bne.s	Apply_DungeonOcclusionMasks_NextCell
	and.l	(a4),d0
Apply_DungeonOcclusionMasks_NextCell:		; Memory Address ($91F6) and binary offset [$8E72]
	subq.w	#$04,a6
	subq.w	#$04,a4
	dbra	d6,Apply_DungeonOcclusionMasks_Loop
	and.l	d0,d7
	moveq	#$00,d6
Draw_VisibleDungeonCells_Loop:		; Memory Address ($9202) and binary offset [$8E7E]
	; Visits each visible player-relative cell and calls the per-cell dungeon
	; renderer.
	btst	d6,d5
	beq.s	Draw_VisibleDungeonCells_NextCell
	movem.l	d5-d7,-(sp)
	bsr		Draw_DungeonViewCell
	movem.l	(sp)+,d5-d7
Draw_VisibleDungeonCells_NextCell:		; Memory Address ($9212) and binary offset [$8E8E]
	addq.w	#$01,d6
	cmpi.b	#Dungeon_ViewCell_Count,d6											;Continues through all nineteen player-relative view cells.
	bcs.s	Draw_VisibleDungeonCells_Loop
	unlk	a3
	rts		

Draw_DungeonViewCell:		; Memory Address ($921E) and binary offset [$8E9A]
	; Resolves and draws one player-relative dungeon view cell.
	move.b	d6,-$0016(a3)
	move.l	-$0010(a3),a0
	add.w	d6,d6
	add.w	d6,a0
	moveq	#$01,d1
	move.l	-$0004(a3),d5
	swap	d5
	add.b	(a0)+,d5
	move.b	d5,-$0019(a3)
	cmp.w	CurrentFloorWidth.l,d5
	beq.s	Process_DungeonViewCellContents
	bcs.s	Draw_DungeonViewCell_CheckYBounds
	addq.b	#$01,d5
	beq.s	Process_DungeonViewCellContents
	rts		

Draw_DungeonViewCell_CheckYBounds:		; Memory Address ($9248) and binary offset [$8EC4]
	swap	d5
	add.b	(a0),d5
	move.b	d5,-$001A(a3)
	cmp.w	CurrentFloorHeight.l,d5
	beq.s	Process_DungeonViewCellContents
	bcs.s	Draw_DungeonViewCell_LookupMapContent
	addq.b	#$01,d5
	beq.s	Process_DungeonViewCellContents
	rts		

Draw_DungeonViewCell_LookupMapContent:		; Memory Address ($9260) and binary offset [$8EDC]
	exg		d5,d7
	bsr		CoordToMap
	exg		d5,d7
	move.w	$00(a6,d0.w),d1
Process_DungeonViewCellContents:		; Memory Address ($926C) and binary offset [$8EE8]
	; Processes floor objects, stationary spells, wall geometry, and occupants for
	; the resolved view cell.
	clr.b	-$0013(a3)
	move.w	d1,-$0012(a3)
	btst	#$06,d1
	beq.s	Draw_DungeonCellFeatureAndOccupants
	movem.l	d0/d1/d6/d7,-(sp)
	bsr		Draw_DungeonCellFloorObjects
	movem.l	(sp)+,d0/d1/d6/d7
Draw_DungeonCellFeatureAndOccupants:		; Memory Address ($9286) and binary offset [$8F02]
	; Dispatches a dungeon cell's structural feature and then draws its remaining
	; occupants and contents.
	btst	#$05,d1
	beq		Dispatch_DungeonCellType
	move.w	d1,d2
	and.w	#$0007,d2
	subq.w	#$01,d2
	beq		Dispatch_DungeonCellType
	move.w	d0,-(sp)
	bsr		Dispatch_DungeonCellType
	move.w	(sp)+,d0
	bsr		Find_FloorObjectRecordByMapLink
	move.w	$0002(a0),d1
	move.w	d1,d2
	and.w	#$0003,d2
	cmpi.w	#$0002,d2
	bne		DungeonCellFeature_DrawSpellObject
	lsr.b	#$02,d1
	add.w	#$0080,d1
	move.b	d1,-$0017(a3)
	moveq	#$04,d1
	cmp.b	#$12,-$0016(a3)
	bne		Draw_DungeonOccupant_ResolvePosition
	subq.b	#$01,-$0016(a3)
	move.l	-$0004(a3),d7
	move.w	-$000A(a3),d0
	bsr		AdjacentCoordToMapOffset
	tst.b	$01(a6,d0.w)
	bmi		Draw_DungeonOccupant_ResolvePosition
	rts		

DungeonCellFeature_DrawSpellObject:		; Memory Address ($92E8) and binary offset [$8F64]
	; Draws stationary impact phases 1 and 0 from the same source picture for forms
	; below $1C; phase 2 uses the airborne-form path selected earlier.
	and.w	#$00FC,d1
	cmpi.w	#$001C,d1
	bcc.s	DungeonCellFeature_SpellObjectExit
	move.w	d1,-(sp)
	bsr		Prepare_CentredMonster_ScreenPosition
	move.w	(sp)+,d0
	addq.b	#$01,d1
	beq.s	DungeonCellFeature_SpellObjectExit
	subq.b	#$01,d1
	move.b	GFX_StationarySpell_DistanceGroups(pc,d1.w),d1
	add.w	d1,d1
	lea		GFX_AirbourneSpells.l,a1
	add.w	GFX_StationarySpell_LookupTable(pc,d1.w),a1
	add.w	d1,d1
	add.b	GFX_StationarySpell_RenderLayout(pc,d1.w),d4
	add.b	GFX_StationarySpell_RenderLayout+$1(pc,d1.w),d5
	moveq	#$00,d7
	move.b	GFX_StationarySpell_RenderLayout+$2(pc,d1.w),d7
	swap	d7
	move.b	GFX_StationarySpell_RenderLayout+$3(pc,d1.w),d7
	add.w	$0008(a5),d5
	move.b	d4,d6
	add.b	#$60,d4
	ext.w	d6
	asr.w	#$04,d6
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l
	lea		GFX_Spell_ColourMasks.l,a0
	move.l	$00(a0,d0.w),Buffer_Colour_Mask.l
	move.l	a3,-(sp)
	bsr		Draw_PlanarSprite_Normal
	move.l	(sp)+,a3
	clr.w	Buffer_Colour_Mask_Toggle.l
DungeonCellFeature_SpellObjectExit:		; Memory Address ($9358) and binary offset [$8FD4]
	rts		

GFX_StationarySpell_DistanceGroups:		; Memory Address ($935A) and binary offset [$8FD6]
	; Maps six visible distances to four stationary-spell graphical sizes:
	; 0,0,1,1,2,3.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/AirbourneSpells_Stationary_DistanceGroups.lookup"
GFX_StationarySpell_LookupTable:		; Memory Address ($9360) and binary offset [$8FDC]
	; Four big-endian source offsets into the stationary portion of
	; AirbourneSpells.gfx.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/AirbourneSpells_Stationary.offsets"
GFX_StationarySpell_RenderLayout:		; Memory Address ($9368) and binary offset [$8FE4]
	; Four packed records containing signed X, signed Y, width-minus-one and
	; height-minus-one.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/AirbourneSpells_Stationary.positions"

Dispatch_DungeonCellType:		; Memory Address ($9378) and binary offset [$8FF4]
	; Masks the map-cell type and dispatches non-empty cells to the
	; dungeon-location renderer.
	and.w	#Dungeon_CellTypeMask,d1											;Retains only the three map bits that select the dungeon cell renderer.
	bne.s	Draw_DungeonLocation_ByType
	tst.b	-$0011(a3)
	bmi		Draw_DungeonCellOccupants
	rts		

Draw_DungeonLocation_ByType:		; Memory Address ($9388) and binary offset [$9004]
	; Dispatches the current map type and iterates its candidate wall faces.
	lea		Dungeon_ViewCell_WallFaceSlots.l,a6
	add.w	d6,d6
	add.w	d6,a6
	moveq	#$03,d5
	subq.b	#$01,d1
	beq.s	Draw_DungeonWallFaces_Loop
	subq.b	#$01,d1
	beq.s	Prepare_WoodenWallFaceIteration
	subq.b	#$01,d1
	beq		Draw_BedOrPillar
	cmpi.b	#$03,d1
	beq		Set_TriggerPad_ColourMask
	cmpi.b	#$04,d1
	beq		Draw_FirepathCell
	move.b	d1,-$0013(a3)
	addq.w	#$02,a6
	moveq	#$01,d5
	bra.s	Draw_DungeonWallFaces_Loop

Prepare_WoodenWallFaceIteration:		; Memory Address ($93BC) and binary offset [$9038]
	; Selects wooden-wall handling before the candidate face loop.
	move.b	#$FF,-$0013(a3)
Draw_DungeonWallFaces_Loop:		; Memory Address ($93C2) and binary offset [$903E]
	; Iterates the candidate projected faces for the current dungeon cell and draws
	; those surviving visibility tests.
	moveq	#$00,d6
	move.b	(a6)+,d6
	bmi.s	Draw_NextDungeonWallFace
	btst	d6,d7
	beq.s	Draw_NextDungeonWallFace
	clr.b	-$0014(a3)
	clr.b	-$0015(a3)
	bsr		Resolve_DungeonWallFaceDirection
	tst.b	-$0013(a3)
	bmi.s	Resolve_WoodenWallFace
	beq.s	Draw_StoneWallFace
	bra		Draw_DoorOrStairsFace

Resolve_WoodenWallFace:		; Memory Address ($93E4) and binary offset [$9060]
	; Resolves whether a wooden wall or doorway face is visible from the current
	; candidate direction.
	cmpi.w	#$0002,d5
	bcc.s	Resolve_WoodenWallFaceState
	tst.w	d5
	beq.s	Test_NearWoodenWallFace
	cmp.b	#$0E,-$0016(a3)
	bcc.s	Resolve_WoodenWallFaceState
	bra.s	Draw_Occupants_BeforeWoodenForegroundFace

Test_NearWoodenWallFace:		; Memory Address ($93F8) and binary offset [$9074]
	; Applies the nearest wooden-face visibility condition.
	cmp.b	#$0E,-$0016(a3)
	bcs.s	Resolve_WoodenWallFaceState
Draw_Occupants_BeforeWoodenForegroundFace:		; Memory Address ($9400) and binary offset [$907C]
	; Calls the occupant compositor between rear wooden faces and the foreground
	; face.
	tst.b	-$0011(a3)
	bpl.s	Resolve_WoodenWallFaceState
	movem.l	d1/d5-d7/a6,-(sp)
	bsr		Draw_DungeonCellOccupants											;Draws centred occupants between the wooden wall's rear faces and the selected foreground face; this is the source-defined wooden-wall occlusion order.
	movem.l	(sp)+,d1/d5-d7/a6
Resolve_WoodenWallFaceState:		; Memory Address ($9412) and binary offset [$908E]
	; Decodes the selected wooden face state before drawing its components.
	add.w	d1,d1
	move.b	-$0012(a3),d0
	lsr.w	d1,d0
	and.w	#$0003,d0
	beq.s	Draw_NextDungeonWallFace
	subq.w	#$01,d0
	beq.s	Draw_WoodenWallFace
	move.b	d0,-$0014(a3)
	subq.w	#$01,d0
	move.b	d0,-$0015(a3)
Draw_WoodenWallFace:		; Memory Address ($942E) and binary offset [$90AA]
	; Draws the selected wooden wall or door face.
	movem.l	d5/a6,-(sp)
	bsr		Draw_WoodenWallOrDoorFace
	movem.l	(sp)+,d5/a6
Draw_NextDungeonWallFace:		; Memory Address ($943A) and binary offset [$90B6]
	; Advances the four-face dungeon-wall loop.
	dbra	d5,Draw_DungeonWallFaces_Loop
	rts		

Draw_StoneWallFace:		; Memory Address ($9440) and binary offset [$90BC]
	; Selects the projected stone-wall face and any main-wall overlay for the
	; current direction.
	move.b	-$0011(a3),d0
	bpl.s	Draw_StoneWallFace_CallMainFace
	lsr.b	#$04,d0
	and.w	#$0003,d0
	cmp.b	d0,d1
	bne.s	Draw_StoneWallFace_CallMainFace
	move.b	-$0012(a3),d0
	move.b	#$FF,-$0015(a3)
	and.w	#$0003,d0
	beq.s	Draw_StoneWallFace_CallMainFace
	subq.b	#$01,-$0015(a3)
	subq.w	#$01,d0
	beq.s	Draw_StoneWallFace_CallMainFace
	subq.b	#$01,-$0015(a3)
	subq.w	#$01,d0
	beq.s	Draw_StoneWallFace_CallMainFace
	subq.b	#$01,-$0015(a3)
Draw_StoneWallFace_CallMainFace:		; Memory Address ($9474) and binary offset [$90F0]
	movem.l	d5/a6,-(sp)
	bsr		Draw_MainWallFace_ByPatternParity
	movem.l	(sp)+,d5/a6
	bra.s	Draw_NextDungeonWallFace

Draw_DoorOrStairsFace:		; Memory Address ($9482) and binary offset [$90FE]
	; Resolves the visible face slot before dispatching the shared main-door or
	; stairs renderer.
	bsr		Resolve_DungeonCellCentredSlot
	bmi		Draw_Main_Door_Or_Stairs
	btst	d1,d7
	beq		Draw_Main_Door_Or_Stairs
	move.w	d1,d6
	bra		Draw_Main_Door_Or_Stairs

Draw_FirepathCell:		; Memory Address ($9496) and binary offset [$9112]
	; Interprets the Firepath cell state and selects its ordinary or randomly
	; varied colour mask.
	move.b	-$0012(a3),d1
	and.w	#$0003,d1
	beq.s	Draw_FirepathCell_Inactive
	cmpi.w	#$0001,d1
	beq.s	Select_Firepath_ColourMask
	cmpi.b	#$03,d1
	beq.s	Draw_FirepathCell_ReprocessAsType1
	tst.b	-$001F(a3)
	beq.s	Draw_FirepathCell_ReprocessAsType1
Draw_FirepathCell_Inactive:		; Memory Address ($94B2) and binary offset [$912E]
	rts		

Draw_FirepathCell_ReprocessAsType1:		; Memory Address ($94B4) and binary offset [$9130]
	lsr.w	#$01,d6
	moveq	#$01,d1
	bra		Process_DungeonViewCellContents

Select_Firepath_ColourMask:		; Memory Address ($94BC) and binary offset [$9138]
	; Selects one of two Firepath colour masks using the random-value bit at offset
	; four.
	bsr		RandomGen_BytewithOffset
	and.w	#$0004,d0
	move.l	GFX_Firepath_ColourMasks(pc,d0.w),Buffer_Colour_Mask.l
	move.b	#$02,-$0012(a3)
	bra.s	Draw_FloorFeature

GFX_Firepath_ColourMasks:		; Memory Address ($94D4) and binary offset [$9150]
	; Two four-byte colour masks selected by the Firepath renderer after the random
	; colour choice.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Dungeon_Firepath.colours"

Set_TriggerPad_ColourMask:		; Memory Address ($94DC) and binary offset [$9158]
	move.l	#$01050406,Buffer_Colour_Mask.l
Draw_FloorFeature:		; Memory Address ($94E6) and binary offset [$9162]
	; Checks centred-slot visibility before composing ceiling holes, floor pits, or
	; trigger pads.
	bsr		Resolve_DungeonCellCentredSlot
	cmpi.w	#$0012,d0
	beq.s	Draw_CeilingHole
	tst.b	d1
	bmi.s	Draw_FloorFeature_SharedExit
	btst	d1,d7
	beq.s	Draw_FloorFeature_SharedExit
Draw_CeilingHole:		; Memory Address ($94F8) and binary offset [$9174]
	; Draws the ceiling-hole component when requested, then continues with the
	; corresponding floor feature.
	move.b	-$0012(a3),d1
	move.w	d0,d6
	btst	#$02,d1
	beq.s	Draw_FloorPitOrTriggerPad
	movem.l	d1/d6,-(sp)
	lea		GFX_Ceiling_Hole.l,a1
	lea		GFX_Ceiling_Hole_Positions.l,a2
	lea		GFX_Ceiling_Hole_Offsets.l,a0
	bsr		Draw_CentredDungeonComponent
	movem.l	(sp)+,d1/d6
Draw_FloorPitOrTriggerPad:		; Memory Address ($9522) and binary offset [$919E]
	; Selects floor-pit or trigger-pad artwork and applies the temporary
	; trigger-pad colour mask.
	lea		GFX_FloorPit_TriggerPad_Offsets.l,a0
	lea		GFX_FloorPit_TriggerPad_Positions.l,a2
	lea		GFX_Floor_Pit.l,a1
	and.w	#$0003,d1
	beq.s	Draw_FloorPitOrTriggerPad_CheckOccupants
	cmpi.w	#$0003,d1
	beq.s	Draw_FloorPitOrTriggerPad_CheckOccupants
	btst	#$00,d1
	bne.s	Draw_FloorPitOrTriggerPad_DrawFloorPit
	lea		GFX_Trigger_Pad.l,a1
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l
	bsr.s	Draw_CentredDungeonComponent
	clr.w	Buffer_Colour_Mask_Toggle.l
	bra.s	Draw_FloorPitOrTriggerPad_CheckOccupants

Draw_FloorPitOrTriggerPad_DrawFloorPit:		; Memory Address ($955E) and binary offset [$91DA]
	bsr.s	Draw_CentredDungeonComponent
Draw_FloorPitOrTriggerPad_CheckOccupants:		; Memory Address ($9560) and binary offset [$91DC]
	tst.b	-$0011(a3)
	bmi		Draw_DungeonCellOccupants
Draw_FloorFeature_SharedExit:		; Memory Address ($9568) and binary offset [$91E4]
	rts		

Draw_BedOrPillar:		; Memory Address ($956A) and binary offset [$91E6]
	; Selects the bed or pillar graphics, offsets, and projected positions for a
	; centred dungeon cell.
	bsr		Resolve_DungeonCellCentredSlot
	bmi.s	Draw_BedOrPillar_Return
	btst	d1,d7
	beq.s	Draw_BedOrPillar_Return
	cmp.b	#$01,-$0012(a3)
	beq.s	Draw_Pillar
	lea		GFX_Misc_Bed_Offsets.l,a0
	lea		GFX_Misc_Bed_Positions.l,a2
	lea		GFX_Bed.l,a1
	move.w	d0,d6
Draw_Wall_Sprite:		; Memory Address ($9590) and binary offset [$920C]
	; Prepares and draws a centred dungeon component through the ordinary planar
	; wall-sprite compositor.
	bsr		Prepare_WallSpriteDraw
	swap	d3
	move.l	a3,-(sp)
	bsr		Draw_WallSprite_Normal
	move.l	(sp)+,a3
Draw_BedOrPillar_Return:		; Memory Address ($959E) and binary offset [$921A]
	rts		

Draw_Pillar:		; Memory Address ($95A0) and binary offset [$921C]
	; Selects the pillar graphics tables before entering the centred-component
	; drawing path.
	lea		GFX_Misc_Pillar_Offsets.l,a0
	lea		GFX_Misc_Pillar_Positions.l,a2
	lea		GFX_Pillar.l,a1
	move.w	d0,d6
Draw_CentredDungeonComponent:		; Memory Address ($95B4) and binary offset [$9230]
	; Maps a centred view cell to a component picture and chooses its normal or
	; mirrored drawing path.
	moveq	#$00,d0
	move.b	GFX_CentredDungeonComponent_SpriteMirrorTable(pc,d6.w),d0
	bpl.s	Draw_Wall_Sprite
	bra		Flip_Sprite

GFX_CentredDungeonComponent_SpriteMirrorTable:		; Memory Address ($95C0) and binary offset [$923C]
	; Maps the 19 viewport cells to centred dungeon sprite numbers; bit 7 selects
	; horizontal mirroring. The twentieth byte is spare.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Dungeon_CentredComponents.lookup"

Resolve_DungeonWallFaceDirection:		; Memory Address ($95D4) and binary offset [$9250]
	; Converts the current candidate face and player facing into the corresponding
	; N/E/S/W direction.
	move.w	d5,d1
	cmp.b	#$07,-$0016(a3)
	bcc.s	Resolve_DungeonWallFaceDirection_HighFacing
	btst	#$00,d1
	bne.s	Resolve_DungeonWallFaceDirection_MirrorFace
	eor.w	#$0001,d1
	bra.s	Resolve_DungeonWallFaceDirection_ApplyOffset

Resolve_DungeonWallFaceDirection_HighFacing:		; Memory Address ($95EA) and binary offset [$9266]
	cmp.b	#$0E,-$0016(a3)
	bcs.s	Resolve_DungeonWallFaceDirection_MirrorFace
	btst	#$01,d1
	bne.s	Resolve_DungeonWallFaceDirection_MirrorFace
	eor.w	#$0001,d1
Resolve_DungeonWallFaceDirection_MirrorFace:		; Memory Address ($95FC) and binary offset [$9278]
	eor.w	#$0003,d1
Resolve_DungeonWallFaceDirection_ApplyOffset:		; Memory Address ($9600) and binary offset [$927C]
	add.w	-$000A(a3),d1
	and.w	#$0003,d1
	rts		

Draw_DungeonCellFloorObjects:		; Memory Address ($960A) and binary offset [$9286]
	; Checks floor-object visibility and walks the four rotated object subpositions
	; in the current dungeon cell.
	tst.b	-$001F(a3)
	bne.s	DungeonFloorObjects_ProcessSubpositions
	btst	#$03,$01(a6,d0.w)
	beq.s	DungeonFloorObjects_ProcessSubpositions
	rts		

DungeonFloorObjects_ProcessSubpositions:		; Memory Address ($961A) and binary offset [$9296]
	move.w	d1,d2
	and.w	#$0007,d2
	cmpi.w	#$0006,d2
	beq.s	Draw_Type6CellFeatureBeforeFloorObjects
	subq.w	#$01,d2
	bne.s	DungeonFloorObjects_InitSubpositionLoop
	lsr.w	#$04,d1
	and.w	#$0003,d1
	eor.w	#$0002,d1
	cmp.w	-$000A(a3),d1
	bne.s	DrawDungeonFloorObjects_SharedReturn
Draw_Type6CellFeatureBeforeFloorObjects:		; Memory Address ($963A) and binary offset [$92B6]
	; Draws a type-six cell feature before resuming the ordinary floor-object pass
	; so its items remain visible on top.
	addq.w	#$04,sp
	movem.l	(sp),d0/d1/d6/d7
	bsr		Draw_DungeonCellFeatureAndOccupants
	movem.l	(sp)+,d0/d1/d6/d7
DungeonFloorObjects_InitSubpositionLoop:		; Memory Address ($9648) and binary offset [$92C4]
	moveq	#$00,d1
Draw_DungeonCellObjectSubpositions_Loop:		; Memory Address ($964A) and binary offset [$92C6]
	; Iterates the four object subpositions after rotating them into the
	; player-relative facing.
	move.w	d1,-(sp)
	move.w	d1,d6
	bsr		Rotate_ObjectSubpositionByPlayerFacing
	bsr		Find_FloorObjectStackAtCellSubposition
	bne.s	Draw_DungeonCellObjectSubpositions_Advance
	rol.b	#$02,d6
	lea		$02(a0,d7.w),a0
	moveq	#$00,d7
	move.b	(a0)+,d7
Draw_DungeonCellObjects_Loop:		; Memory Address ($9662) and binary offset [$92DE]
	; Draws every object record attached to the current floor subposition.
	movem.l	d0/d6/d7/a0/a3,-(sp)
	moveq	#$00,d2
	move.b	(a0),d2
	bsr.s	Draw_ObjectOnFloor													;Draws every record attached to the selected rotated object mini-space before advancing to the next mini-space.
	movem.l	(sp)+,d0/d6/d7/a0/a3
	addq.w	#$02,a0
	dbra	d7,Draw_DungeonCellObjects_Loop
Draw_DungeonCellObjectSubpositions_Advance:		; Memory Address ($9676) and binary offset [$92F2]
	move.w	(sp)+,d1
	addq.w	#$01,d1
	cmpi.w	#ObjectFloor_SubpositionCount,d1
	bcs.s	Draw_DungeonCellObjectSubpositions_Loop
DrawDungeonFloorObjects_SharedReturn:		; Memory Address ($9680) and binary offset [$92FC]
	rts		

GFX_ObjectsOnFloor_SubpositionRotation:		; Memory Address ($9682) and binary offset [$92FE]
	; Combined floor-object projection layout containing sub-position rotation,
	; depth bias, view-cell depth, projection groups, base Y positions and
	; shelf/special Y adjustments.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/ObjectsOnFloor_Projection.layout"

Draw_ObjectOnFloor:		; Memory Address ($96BE) and binary offset [$933A]
	; Resolves object mini-space, view cell and distance into one of five projected
	; floor graphics and its screen position.
	move.w	-$000A(a3),d0
	add.w	d0,d0
	add.w	d0,d0
	add.w	d6,d0
	move.b	GFX_ObjectsOnFloor_SubpositionRotation(pc,d0.w),d6					;Rotates the stored NW/NE/SW/SE object mini-space into the viewer-relative mini-space.
	moveq	#$00,d1
	move.b	-$0016(a3),d1
	move.b	GFX_ObjectsOnFloor_SubpositionRotation+$14(pc,d1.w),d0
	bmi.s	DrawDungeonFloorObjects_SharedReturn
	add.b	GFX_ObjectsOnFloor_SubpositionRotation+$10(pc,d6.w),d0
	move.b	GFX_ObjectsOnFloor_SubpositionRotation+$27(pc,d0.w),d0
	bmi.s	DrawDungeonFloorObjects_SharedReturn
	asl.w	#$02,d1
	add.w	d6,d1
	moveq	#$00,d5
	moveq	#$00,d4
	move.b	GFX_ObjectsOnFloor_SubpositionRotation+$2F(pc,d0.w),d5
	add.w	$0008(a5),d5
	lea		GFX_ObjectsOnFloor_XPositions.l,a0
	move.b	$00(a0,d1.w),d4
	move.w	-$0012(a3),d3
	and.w	#$0007,d3
	subq.w	#Dungeon_MapCell_MainWallType,d3									;A zero result selects the shelf-specific X-position and Y-adjustment path; other map-cell types use floor placement.
	bne.s	Draw_ObjectOnFloor_ResolveGraphic
	subq.w	#$04,d6
	move.w	d0,d3
	add.w	d3,d3
	add.w	d6,d3
	sub.b	GFX_ObjectsOnFloor_SubpositionRotation+$34(pc,d3.w),d5
	lea		GFX_ObjectsOnFloor_SpecialXPositions.l,a0
	move.b	-$0016(a3),d3
	move.b	$00(a0,d3.w),d4
Draw_ObjectOnFloor_ResolveGraphic:		; Memory Address ($9722) and binary offset [$939E]
	; Loads the object's floor shape, recolour definition, graphics offset and
	; selected projection.
	cmpi.b	#ObjectFloor_HiddenXPosition,d4										;Skips this object mini-space when its source X-position entry is the hidden sentinel.
	beq		DrawDungeonFloorObjects_SharedReturn
	lea		Object_Floor_Colours.l,a6
	moveq	#$00,d3
	move.b	$00(a6,d2.w),d3
	asl.w	#$02,d3
	lea		Object_Floor_Palettes.l,a6
	move.l	$00(a6,d3.w),Buffer_Colour_Mask.l
	lea		Object_Floor_DataTable.l,a0
	move.b	$00(a0,d2.w),d3
	move.w	d3,d6
	asl.w	#$02,d6
	add.w	d3,d6
	add.w	d0,d6
	add.w	d6,d6
	lea		GFX_ObjectsOnFloor_Offsets.l,a0
	lea		GFX_ObjectsOnFloor.l,a1
	add.w	$00(a0,d6.w),a1
	cmpi.b	#ObjectFloor_WideShapeFirst,d3										;Selects the wide graphics bank and explicit width selector for the wide floor-object shapes.
	bcs.s	Draw_ObjectOnFloor_ResolveWidth
	add.w	#ObjectFloor_WideGraphicsOffset,a1									;Moves the sprite pointer from ordinary ObjectsOnFloor pictures to the wide-shape graphics bank.
Draw_ObjectOnFloor_ResolveWidth:		; Memory Address ($9774) and binary offset [$93F0]
	; Selects the normal or wide floor-object drawing width.
	moveq	#$00,d7
	cmpi.b	#ObjectFloor_WideShapeFirst,d3										;Selects the wide graphics bank and explicit width selector for the wide floor-object shapes.
	bcs.s	Draw_ObjectOnFloor_Blit
	move.b	GFX_ObjectsOnFloor_Widths(pc,d0.w),d7
Draw_ObjectOnFloor_Blit:		; Memory Address ($9780) and binary offset [$93FC]
	; Applies the shape-specific Y adjustment and draws the recoloured floor-object
	; graphic.
	swap	d7
	lsr.w	#$01,d6
	lea		GFX_ObjectsOnFloor_Heights.l,a0
	move.b	$00(a0,d6.w),d7
	lea		GFX_ObjectsOnFloor_YAdjustments.l,a0
	add.b	$00(a0,d6.w),d5
	move.b	d4,d6
	add.b	#$60,d4
	ext.w	d6
	asr.w	#$04,d6
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l
	bsr		Draw_PlanarSprite_Normal
	clr.w	Buffer_Colour_Mask_Toggle.l
	rts		

GFX_ObjectsOnFloor_Widths:		; Memory Address ($97B6) and binary offset [$9432]
	; Per-projection width selectors used by the wide floor-object graphic shapes.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/ObjectsOnFloor_Widths.widths"
GFX_ObjectsOnFloor_XPositions:		; Memory Address ($97BC) and binary offset [$9438]
	; X positions for 19 view cells multiplied by four rotated object mini-spaces;
	; $80 suppresses drawing.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/ObjectsOnFloor_XPositions.positions"
GFX_ObjectsOnFloor_SpecialXPositions:		; Memory Address ($9808) and binary offset [$9484]
	; Alternative X positions used by the special floor-object placement path.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/ObjectsOnFloor_SpecialXPositions.positions"
GFX_ObjectsOnFloor_YAdjustments:		; Memory Address ($981C) and binary offset [$9498]
	; Per-shape and per-projection Y adjustments: 27 shapes multiplied by five
	; views, followed by one spare byte.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/ObjectsOnFloor_YAdjustments.positions"

Resolve_DiagonalCellAndFindOccupant:		; Memory Address ($98A4) and binary offset [$9520]
	; Resolves the caller's diagonal cell coordinates and continues into the shared
	; dungeon-cell occupant search.
	bsr		Resolve_DiagonalPillarSourceCell
Find_DungeonCellOccupant:		; Memory Address ($98A8) and binary offset [$9524]
	; Searches a requested tower/floor coordinate in strict priority order: Player
	; 1, Player 2, standing champions, then unpacked monsters, returning the first
	; matching occupant.
	move.w	#$0080,d0
	lea		Player1_Data.l,a1
	cmp.w	$0058(a1),d1
	bne.s	Find_DungeonCellOccupant_CheckPlayer2
	cmp.l	$001C(a1),d2
	beq.s	Find_DungeonCellOccupant_Found
Find_DungeonCellOccupant_CheckPlayer2:		; Memory Address ($98BE) and binary offset [$953A]
	addq.b	#$01,d0
	lea		Player2_Data.l,a1
	cmp.w	$0058(a1),d1
	bne.s	Find_DungeonCellOccupant_ChampionSearchInit
	cmp.l	$001C(a1),d2
	beq.s	Find_DungeonCellOccupant_Found
Find_DungeonCellOccupant_ChampionSearchInit:		; Memory Address ($98D2) and binary offset [$954E]
	lea		Character_Stats_DataTable.l,a1
	move.b	d2,d0
	swap	d2
	rol.w	#$08,d2
	move.b	d0,d2
	move.w	CurrentTower.l,d3
	moveq	#Champion_Count-1,d0
Find_DungeonCellOccupant_ChampionLoop:		; Memory Address ($98E8) and binary offset [$9564]
	cmp.b	ChampionStat_Tower(a1),d3
	bne.s	Find_DungeonCellOccupant_ChampionLoop_Next
	cmp.b	ChampionStat_Floor(a1),d1
	bne.s	Find_DungeonCellOccupant_ChampionLoop_Next
	cmp.w	ChampionStat_XPosition(a1),d2
	beq.s	Find_DungeonCellOccupant_ChampionFound
Find_DungeonCellOccupant_ChampionLoop_Next:		; Memory Address ($98FA) and binary offset [$9576]
	add.w	#$0020,a1
	dbra	d0,Find_DungeonCellOccupant_ChampionLoop
	moveq	#$10,d0
	lea		UnpackedMonsters.l,a1
	move.w	LiveActorRecord_CountOffset(a1),d3
	bmi.s	Find_DungeonCellOccupant_NotFound
Find_DungeonCellOccupant_MonsterLoop:		; Memory Address ($9910) and binary offset [$958C]
	cmp.b	ActorRecord_Floor(a1),d1
	bne.s	Find_DungeonCellOccupant_MonsterLoop_Next
	cmp.w	ActorRecord_XPosition(a1),d2
	beq.s	Find_DungeonCellOccupant_Found
Find_DungeonCellOccupant_MonsterLoop_Next:		; Memory Address ($991C) and binary offset [$9598]
	addq.w	#$01,d0
	add.w	#ActorRecord_Size,a1
	dbra	d3,Find_DungeonCellOccupant_MonsterLoop
Find_DungeonCellOccupant_NotFound:		; Memory Address ($9926) and binary offset [$95A2]
	swap	d1
	rts		

Find_DungeonCellOccupant_ChampionFound:		; Memory Address ($992A) and binary offset [$95A6]
	not.b	d0
	and.w	#$000F,d0
Find_DungeonCellOccupant_Found:		; Memory Address ($9930) and binary offset [$95AC]
	ori.b	#$01,ccr
	rts		

Monster_SubPosition_DepthAdjustments:		; Memory Address ($9936) and binary offset [$95B2]
	; Adjusts monster team mini-spaces before distance selection.
	dc.b	$00,$00,$01,$01,$00
Monster_ViewCell_DepthSlots:		; Memory Address ($993B) and binary offset [$95B7]
	; Maps dungeon view cells to monster depth slots.
	dc.b	$06,$06,$FF,$04,$02,$00,$FF,$06,$06,$FF,$04,$02,$00,$FF,$06,$04
	dc.b	$02,$00,$FF
Monster_Depth_GfxSlots:		; Memory Address ($994E) and binary offset [$95CA]
	; Maps projected depth slots to monster graphics-distance slots.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Monster_Depth_GfxSlots.lookup"
Monster_GfxSlot_YPositions:		; Memory Address ($9956) and binary offset [$95D2]
	; Provides the base vertical screen position for each monster graphics-distance
	; slot.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Monster_GfxSlot_Y.positions"

Prepare_CentredMonster_ScreenPosition:		; Memory Address ($995C) and binary offset [$95D8]
	; Entry point for centrally positioned monsters; forces the centre sub-position
	; before using Prepare_Monster_ScreenPosition.
	moveq	#$04,d1
Prepare_Monster_ScreenPosition:		; Memory Address ($995E) and binary offset [$95DA]
	; Converts a visible monster's view cell and sub-position into its graphics
	; distance, screen coordinates, and strip height.
	move.w	d1,d2
	move.w	#$004B,MonsterStrip_BottomY.l
	moveq	#$00,d0
	moveq	#$00,d4
	move.b	-$0016(a3),d0
	move.b	Monster_ViewCell_DepthSlots(pc,d0.w),d1
	bmi.s	Prepare_Monster_ScreenPosition_Return
	add.b	Monster_SubPosition_DepthAdjustments(pc,d2.w),d1
	move.w	d0,d5
	asl.w	#$02,d0
	add.w	d5,d0
	add.w	d2,d0
	move.w	d1,d2
	lea		Monster_ViewCell_SubPosition_XPositions.l,a0
	move.b	$00(a0,d0.w),d4
	cmpi.b	#$FF,d4
	beq.s	Prepare_Monster_ScreenPosition_InvalidSlotReturn
	move.b	Monster_Depth_GfxSlots(pc,d2.w),d1
	move.b	Monster_GfxSlot_YPositions(pc,d1.w),d5
	move.w	-$0012(a3),d0
	and.w	#$0007,d0
	cmpi.w	#$0004,d0
	bne.s	Prepare_Monster_ScreenPosition_Return
	move.b	Monster_StairDepthSlot_XAdjustments(pc,d2.w),d0
	move.b	Monster_StairDepthSlot_YPositions(pc,d2.w),d2
	btst	#$00,-$0012(a3)
	bne.s	Prepare_Monster_ScreenPosition_ApplyDepth4Offset
	neg.b	d0
	moveq	#$4B,d2
Prepare_Monster_ScreenPosition_ApplyDepth4Offset:		; Memory Address ($99BE) and binary offset [$963A]
	add.b	d0,d5
	move.w	d2,MonsterStrip_BottomY.l
Prepare_Monster_ScreenPosition_Return:		; Memory Address ($99C6) and binary offset [$9642]
	rts		

Prepare_Monster_ScreenPosition_InvalidSlotReturn:		; Memory Address ($99C8) and binary offset [$9644]
	moveq	#-$01,d1
	rts		

Monster_StairDepthSlot_XAdjustments:		; Memory Address ($99CC) and binary offset [$9648]
	; Eight signed X adjustments used when placing an occupant in a type-4 stair
	; cell.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Monster_StairDepthSlot_XAdjustments.positions"
Monster_StairDepthSlot_YPositions:		; Memory Address ($99D4) and binary offset [$9650]
	; Eight Y positions paired with the stair depth-slot X adjustments.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Monster_StairDepthSlot_YPositions.positions"

Resolve_DungeonCellCentredSlot:		; Memory Address ($99DC) and binary offset [$9658]
	; Maps the current view cell to its centred visibility bit and projected slot.
	moveq	#$00,d0
	moveq	#$00,d1
	lea		Dungeon_ViewCell_CentredSlots.l,a0
	move.b	-$0016(a3),d0
	move.b	$00(a0,d0.w),d1
Return_FromDungeonCellOccupants:		; Memory Address ($99EE) and binary offset [$966A]
	; Common return when the centred occupant slot is unavailable or empty.
	rts		

Draw_DungeonCellOccupants:		; Memory Address ($99F0) and binary offset [$966C]
	; Finds and draws players, champions, or monsters occupying the visible centred
	; slot.
	bsr.s	Resolve_DungeonCellCentredSlot
	bmi.s	Return_FromDungeonCellOccupants
	btst	d1,d7
	beq.s	Return_FromDungeonCellOccupants
	moveq	#$00,d2
	move.b	-$0019(a3),d2
	swap	d2
	move.b	-$001A(a3),d2
	move.w	-$001E(a3),d1
	bsr		Find_DungeonCellOccupant											;Finds the player, champion, or unpacked monster occupying the current visible map coordinates before selecting its renderer.
	bcc.s	Return_FromDungeonCellOccupants
	tst.b	d0
	bmi		Draw_PlayerOccupant
	cmpi.w	#$0010,d0
	bcc.s	Draw_MonsterTeamOccupants
	move.b	d0,-$0017(a3)
	move.b	$001B(a1),d0
	move.b	$0018(a1),d1
	bra		Calculate_MonsterViewerRelativeFacing

Draw_MonsterTeamOccupants:		; Memory Address ($9A2A) and binary offset [$96A6]
	; Resolves and draws the members of a live monster team.
	moveq	#$00,d0
	move.b	$000D(a1),d0
	bmi.s	Load_SingleMonsterRotationAndSpace
	move.b	$0002(a1),d2
	and.w	#$0003,d2
	asl.w	#$02,d0
	lea		MonsterTeamIndexTable.l,a1
	add.w	d0,a1
	moveq	#$03,d1
Draw_MonsterTeamMemberLoop:		; Memory Address ($9A46) and binary offset [$96C2]
	; Rotates and resolves one authored monster-team mini-space.
	move.w	d1,d3
	addq.w	#$02,d3
	add.w	-$000A(a3),d3
	sub.w	d2,d3
	and.w	#$0003,d3
	moveq	#$00,d0
	move.b	$00(a1,d3.w),d0
	bmi.s	Draw_NextMonsterTeamMember
	movem.l	d1/d2/a1,-(sp)
	asl.w	#$04,d0
	lea		UnpackedMonsters.l,a1
	add.w	d0,a1
	add.w	d2,d3
	and.w	#$0003,d3
	asl.w	#$04,d3
	or.b	d2,d3
	move.w	d3,d1
	bsr.s	Prepare_MonsterOccupantRender
	movem.l	(sp)+,d1/d2/a1
Draw_NextMonsterTeamMember:		; Memory Address ($9A7C) and binary offset [$96F8]
	; Advances the four-member live monster-team loop.
	dbra	d1,Draw_MonsterTeamMemberLoop
	rts		

Load_SingleMonsterRotationAndSpace:		; Memory Address ($9A82) and binary offset [$96FE]
	; Uses the live monster rotation-and-mini-space byte for a non-team monster.
	move.b	$0002(a1),d1
Prepare_MonsterOccupantRender:		; Memory Address ($9A86) and binary offset [$9702]
	; Loads monster form and handles its render-specific special cases.
	move.b	$000B(a1),-$0017(a3)
	cmp.b	#$1A,-$0017(a3)
	bne.s	Load_MonsterRenderState
	move.w	d1,d3
	bsr		RandomGen_BytewithOffset
	move.w	d3,d1
	and.w	#$0001,d0
	add.w	#$001A,d0
	move.b	d0,-$0017(a3)
Load_MonsterRenderState:		; Memory Address ($9AA8) and binary offset [$9724]
	; Loads monster animation state and current grade before rendering.
	move.b	$0005(a1),d0
	move.b	$0006(a1),-$0018(a3)
Calculate_MonsterViewerRelativeFacing:		; Memory Address ($9AB2) and binary offset [$972E]
	; Converts live rotation into viewer-relative facing and mini-space.
	bsr		Decode_Monster_RenderFlags
	move.b	d1,d2
	and.b	#$03,d2
	move.b	d2,-$001B(a3)
	lsr.b	#ActorRecord_MiniSpaceShift,d1
	subq.w	#$02,d1
	sub.w	-$000A(a3),d1														;Converts the actor's rotation nibble to viewer-relative artwork direction by subtracting the player facing, then wrapping it to two bits.
	and.w	#$0003,d1
	cmp.b	#$15,-$0017(a3)
	beq.s	.CentralPosition
	cmp.b	#$16,-$0017(a3)
	beq.s	.CentralPosition
	cmp.b	#$40,-$0017(a3)
	beq.s	.CentralPosition
	cmp.b	#$67,-$0017(a3)
	bcc.s	.CentralPosition
	tst.b	-$0017(a3)
	bpl		Draw_DungeonOccupant_ResolvePosition
.CentralPosition:
	moveq	#$04,d1
	bra		Draw_DungeonOccupant_ResolvePosition

Draw_PlayerOccupant:		; Memory Address ($9AFA) and binary offset [$9776]
	; Resolves the active player occupant branch.
	move.b	$0021(a1),-$001B(a3)
	move.l	a5,-(sp)
	move.l	a1,a5
	moveq	#$03,d1
	bsr		Find_HighestRankedPartyMemberByCategory
	move.l	(sp)+,a5
	tst.w	d3
	bmi.s	Draw_PlayerPartyOccupants
	move.b	-$001F(a3),d2
	cmp.b	d2,d3
	bcs.s	Draw_PlayerPartyOccupants
	rts		

Draw_PlayerPartyOccupants:		; Memory Address ($9B1A) and binary offset [$9796]
	; Draws party champions at an active player’s occupied dungeon cell.
	moveq	#$04,d1
	moveq	#$02,d0
	moveq	#$00,d2
Count_VisiblePlayerPartySlots:		; Memory Address ($9B20) and binary offset [$979C]
	; Counts present party slots before choosing the player-party render path.
	tst.b	$27(a1,d0.w)
	bmi.s	Count_NextVisiblePlayerPartySlot
	addq.w	#$01,d2
Count_NextVisiblePlayerPartySlot:		; Memory Address ($9B28) and binary offset [$97A4]
	; Advances the party-slot count loop.
	dbra	d0,Count_VisiblePlayerPartySlots
	move.w	$0006(a1),d0
	tst.w	d2
	beq		Draw_PlayerPartyChampion
	moveq	#$03,d1
Draw_PlayerPartyMemberLoop:		; Memory Address ($9B38) and binary offset [$97B4]
	; Draws present members of another player's party in back-to-front formation
	; order, rotating each draw slot by (2-partyFacing+viewerFacing+drawSlot)&3.
	moveq	#$02,d0
	sub.w	$0020(a1),d0
	add.w	-$000A(a3),d0
	add.w	d1,d0
	and.w	#$0003,d0
	move.b	$26(a1,d0.w),d0
	bmi.s	Draw_NextPlayerPartyMember
	movem.l	d1/a1,-(sp)
	bsr.s	Draw_PlayerPartyChampion
	movem.l	(sp)+,d1/a1
Draw_NextPlayerPartyMember:		; Memory Address ($9B58) and binary offset [$97D4]
	; Advances the player-party member loop.
	dbra	d1,Draw_PlayerPartyMemberLoop
	rts		

Draw_PlayerPartyChampion:		; Memory Address ($9B5E) and binary offset [$97DA]
	; Loads and draws one champion from the active player party.
	move.b	d0,-$0017(a3)
	bsr		Load_ChampionStatRecord
	move.b	ChampionStat_ActionState(a4),d0
	bsr.s	Decode_Monster_RenderFlags
	bra		Draw_DungeonOccupant_ResolvePosition

GFX_Spell_ColourMasks:		; Memory Address ($9B70) and binary offset [$97EC]
	; Four colour-mask indices per spell code. The first 16 records cover $80–$8F;
	; the final four $90–$93 records have no confirmed gameplay effect but are
	; retained for byte-exact source reproduction.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/AirbourneSpells.colours"

Decode_Monster_RenderFlags:		; Memory Address ($9BC0) and binary offset [$983C]
	; Masks a monster render state to five bits and uses the resulting lookup entry
	; for arm or claw animation flags.
	clr.b	-$0015(a3)
	and.w	#CharacterActionState_RenderIndexMask,d0							;Keeps only the five bits used to choose monster arm or claw animation flags.
	move.b	Monster_RenderFlags_LookupTable(pc,d0.w),-$0015(a3)
	rts		

Monster_RenderFlags_LookupTable:		; Memory Address ($9BD0) and binary offset [$984C]
	; Maps low render-state bits to arm/claw animation flags.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Monster_RenderFlags.lookup"

Draw_AirbourneSpell:		; Memory Address ($9BF0) and binary offset [$986C]
	; Selects the distance group, graphical family and colour mask used to render
	; flying spell codes $80+.
	lea		GFX_AirbourneSpell_DistanceGroups.l,a1
	move.b	$00(a1,d1.w),d1
	add.w	d1,d1
	lea		GFX_FireBall.l,a1
	lea		GFX_AirbourneFireball_RenderLayout.l,a2
	cmpi.b	#AirbourneSpell_GeneralFirstCode,d0									;Separates fireball codes from the general airborne-spell graphic family.
	bcs.s	.RenderSelectedLayout
	add.w	#$0798,a1
	lea		GFX_AirbourneSpells_RenderLayout.l,a2
.RenderSelectedLayout:		; Memory Address ($9C18) and binary offset [$9894]
	; Shared rendering path after selecting either the Fireball or general
	; Airbourne-spell layout.
	add.w	$00(a2,d1.w),a1
	add.w	d1,d1
	add.b	$08(a2,d1.w),d4
	add.b	$09(a2,d1.w),d5
	moveq	#$00,d7
	move.b	$0A(a2,d1.w),d7
	swap	d7
	move.b	$0B(a2,d1.w),d7
	add.w	$0008(a5),d5
	move.b	d4,d6
	add.b	#$60,d4
	ext.w	d6
	asr.w	#$04,d6
	move.l	a3,-(sp)
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l
	lea		GFX_Spell_ColourMasks.l,a0
	asl.b	#$02,d0
	move.l	$00(a0,d0.w),Buffer_Colour_Mask.l
	bsr		Draw_PlanarSprite_Normal
	clr.w	Buffer_Colour_Mask_Toggle.l
	move.l	(sp)+,a3
	rts		

GFX_AirbourneSpell_DistanceGroups:		; Memory Address ($9C68) and binary offset [$98E4]
	; Maps the six visible source distances to four graphical sizes: 0,0,1,1,2,3.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/AirbourneSpell_DistanceGroups.lookup"
GFX_AirbourneFireball_RenderLayout:		; Memory Address ($9C6E) and binary offset [$98EA]
	; Four source offsets followed by four packed X, Y, width-minus-one and
	; height-minus-one records for spell codes $80–$85.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/AirbourneFireball.layout"
GFX_AirbourneSpells_RenderLayout:		; Memory Address ($9C86) and binary offset [$9902]
	; Four source offsets followed by four packed X, Y, width-minus-one and
	; height-minus-one records for spell codes $86–$8F. Offsets are relative to the
	; flying-spell pictures at AirbourneSpells.gfx+$4E0.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/AirbourneSpells_Flying.layout"
Monster_Facing_GfxVariants_LookupTable:		; Memory Address ($9C9E) and binary offset [$991A]
	; Maps facing to front, side, back, or mirrored-side graphics.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Monster_Facing_GfxVariants.lookup"

Resolve_MonsterBodyPoseGeometry:		; Memory Address ($9CA2) and binary offset [$991E]
	; Resolves facing, mirroring, source offset, position, and dimensions for a
	; monster body pose.
	move.w	d1,d2
	add.w	d2,d2
	add.w	d1,d2
	moveq	#$00,d6
	move.b	Monster_Facing_GfxVariants_LookupTable(pc,d0.w),d3
	bpl.s	Resolve_MonsterBodyPoseGeometry_MaskVariantFlag
	moveq	#-$01,d6
Resolve_MonsterBodyPoseGeometry_MaskVariantFlag:		; Memory Address ($9CB2) and binary offset [$992E]
	and.w	#$007F,d3
	add.w	d3,d2
	moveq	#$00,d7
	move.b	$0A(a0,d2.w),d7
	swap	d7
	add.w	d2,d2
	move.w	$00(a2,d2.w),d2
	add.w	d2,a1
	sub.b	$00(a0,d1.w),d5
	move.b	$06(a0,d1.w),d7
	rts		

Draw_Summon:		; Memory Address ($9CD2) and binary offset [$994E]
	; Composes Summon forms $64 and $65 from the main body and two independently
	; selected appendages, using Illusion palettes when the colour-grade byte is
	; negative.
	lea		GFX_Summon_LookupTable.l,a2
	lea		GFX_Summon_Body_Layout.l,a0
	lea		GFX_Summon.l,a1
	bsr.s	Resolve_MonsterBodyPoseGeometry
	lea		Illusion_Palettes.l,a6
	tst.b	-$0018(a3)
	bmi.s	.IllusionSkip
	lea		Monster_Summon_Colours.l,a0
	moveq	#$02,d3
	bsr		MonsterColourGrading
.IllusionSkip:		; Memory Address ($9CFE) and binary offset [$997A]
	movem.w	d0/d1/d4/d5/d7,-(sp)
	move.l	a1,-(sp)
	bsr		Draw_Monster_16PixelStrip
	move.l	(sp)+,a1
	movem.w	(sp)+,d0/d1/d4/d5/d7
	addq.b	#$03,d4
	tst.w	d1
	bne.s	Draw_Summon_BeginArmSetup
	btst	#$00,d0
	bne.s	Draw_Summon_BeginArmSetup
	moveq	#-$01,d6
	movem.w	d0/d1/d4/d5,-(sp)
	bsr		Draw_Monster_16PixelStrip
	movem.w	(sp)+,d0/d1/d4/d5
Draw_Summon_BeginArmSetup:		; Memory Address ($9D28) and binary offset [$99A4]
	cmpi.w	#$0004,d1
	bcc		Draw_Summon_End
	lea		GFX_Summon_PrimaryArm_Positions.l,a2
	movem.w	d0/d1/d4/d5,-(sp)
	moveq	#$00,d6
	moveq	#$00,d2
	bsr		Draw_Summon_AppendageSelect
	movem.w	(sp)+,d0/d1/d4/d5
	lea		GFX_Summon_SecondaryArm_Positions.l,a2
	moveq	#-$01,d6
	moveq	#$01,d2
Draw_Summon_AppendageSelect:		; Memory Address ($9D50) and binary offset [$99CC]
	; Selects each Summon appendage's normal or raised sprite and position from
	; animation bits, distance, facing, and mirror-aware layout tables.
	lea		GFX_Summon_ArmVariants_LookupTable.l,a0
	move.b	$00(a0,d0.w),d3
	bpl.s	Draw_Summon_AppendageSelect_MaskVariantFlag
	not.w	d6
Draw_Summon_AppendageSelect_MaskVariantFlag:		; Memory Address ($9D5E) and binary offset [$99DA]
	and.w	#$007F,d3
	btst	d2,-$0015(a3)
	beq.s	Draw_Summon_AppendageSelect_AfterRaisedCheck
	moveq	#$02,d3
Draw_Summon_AppendageSelect_AfterRaisedCheck:		; Memory Address ($9D6A) and binary offset [$99E6]
	move.w	d1,d2
	add.w	d2,d2
	add.w	d1,d2
	add.w	d3,d2
	moveq	#$00,d7
	lea		GFX_Summon_Arm_Heights.l,a0
	move.b	$00(a0,d2.w),d7
	add.w	d2,d2
	lea		GFX_Summon_Arms_LookupTable.l,a0
	lea		GFX_Summon.l,a1
	add.w	$00(a0,d2.w),a1
	move.w	d1,d2
	asl.w	#$02,d2
	add.w	d0,d2
	add.w	d2,d2
	cmpi.b	#$02,d3
	bne.s	Draw_Summon_AppendageSelect_AfterTableOffset
	add.w	#$0040,a2
Draw_Summon_AppendageSelect_AfterTableOffset:		; Memory Address ($9DA2) and binary offset [$9A1E]
	cmp.w	#$FFFF,$00(a2,d2.w)
	beq.s	Draw_Summon_End
	sub.b	$00(a2,d2.w),d4
	sub.b	$01(a2,d2.w),d5
	bra		Draw_Monster_16PixelStrip

Draw_Summon_End:		; Memory Address ($9DB6) and binary offset [$9A32]
	; Completes the Summon compositor after its body and appendage draws.
	rts		

Monster_Summon_Colours:		; Memory Address ($9DB8) and binary offset [$9A34]
	INCBIN "/data/BLOODWYCH439-clean/monsters/summon.colours"
GFX_Summon_Body_Layout:		; Memory Address ($9DC0) and binary offset [$9A3C]
	; Contains Summon body vertical adjustments and heights; its final bytes also
	; begin the packed body-width data.
	INCBIN "/data/BLOODWYCH439-clean/monsters/Summon_Body.layout"
GFX_Summon_ArmVariants_LookupTable:		; Memory Address ($9DCC) and binary offset [$9A48]
	; Maps Summon facing direction to an arm graphic variant and mirroring; it also
	; forms part of the packed body-width data.
	INCBIN "/data/BLOODWYCH439-clean/monsters/Summon_ArmVariants.lookup"
GFX_Summon_Arm_Heights:		; Memory Address ($9DD0) and binary offset [$9A4C]
	; Provides Summon arm heights and completes the packed body-width table.
	INCBIN "/data/BLOODWYCH439-clean/monsters/Summon_Arms.heights"
GFX_Summon_PrimaryArm_Positions:		; Memory Address ($9DDC) and binary offset [$9A58]
	; Packed X and Y drawing positions for the primary Summon arm; $FFFF suppresses
	; an unavailable component.
	INCBIN "/data/BLOODWYCH439-clean/monsters/Summon_PrimaryArm.positions"
GFX_Summon_SecondaryArm_Positions:		; Memory Address ($9DFC) and binary offset [$9A78]
	; Packed X and Y drawing positions for the secondary Summon arm; $FFFF
	; suppresses an unavailable component.
	INCBIN "/data/BLOODWYCH439-clean/monsters/Summon_SecondaryArm.positions"
Illusion_Palettes:		; Memory Address ($9E5C) and binary offset [$9AD8]
	INCBIN "/data/BLOODWYCH439-clean/monsters/illusion.palette"
Monster_Palettes:		; Memory Address ($9E60) and binary offset [$9ADC]
	INCBIN "/data/BLOODWYCH439-clean/monsters/monsters.palette"

MonsterColourGrading:		; Memory Address ($9E94) and binary offset [$9B10]
	; Selects the monster colour-grade mask from the active grade and the
	; monster-specific palette table.
	moveq	#$00,d2
	move.b	-$0018(a3),d2
	sub.b	d3,d2
	bcc.s	.gradelower
	moveq	#$00,d2
.gradelower:		; Memory Address ($9EA0) and binary offset [$9B1C]
	cmpi.b	#Monster_ColourGradeCount,d2										;Clamps the colour-grade index to the eight palette grades available in the SPS 439 monster renderer.
	bcs.s	.gradeupper
	moveq	#$07,d2
.gradeupper:		; Memory Address ($9EA8) and binary offset [$9B24]
	move.b	$00(a0,d2.w),d2
	asl.w	#$02,d2
	lea		Monster_Palettes.l,a6
	add.w	d2,a6
	move.l	(a6),Buffer_Colour_Mask.l
	rts		

GFX_Summon_LookupTable:		; Memory Address ($9EBE) and binary offset [$9B3A]
	; Offsets of the 18 Summon body pictures in Summon.gfx: six distances by three
	; facing variants.
	INCBIN "/data/BLOODWYCH439-clean/monsters/Summon.offsets"
GFX_Summon_Arms_LookupTable:		; Memory Address ($9EE2) and binary offset [$9B5E]
	; Offsets of the 12 Summon arm pictures in Summon.gfx: four distances by three
	; arm variants.
	INCBIN "/data/BLOODWYCH439-clean/monsters/Summon_Arms.offsets"

Draw_Crab:		; Memory Address ($9EFA) and binary offset [$9B76]
	; Entry point for the table-driven Crab body and detail compositor.
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l
	lea		Monster_Crabs_Colours.l,a0
	moveq	#$02,d3
	bsr.s	MonsterColourGrading
	bsr		Draw_Crab_Body
	lea		Buffer_Colour_Mask.l,a6
	bsr.s	Draw_Crab_DetailDispatch
	clr.w	Buffer_Colour_Mask_Toggle.l
	rts		

Monster_Crabs_Colours:		; Memory Address ($9F20) and binary offset [$9B9C]
	INCBIN "/data/BLOODWYCH439-clean/monsters/crab.colours"

Draw_Crab_DetailDispatch:		; Memory Address ($9F28) and binary offset [$9BA4]
	; Selects the Crab's front, side, or claw detail path for the current distance
	; class.
	cmpi.b	#$02,d1
	bcc.s	Draw_Crab_DetailDispatch_ByPose
	bsr		Draw_Crab_DetailDispatch_Front
Draw_Crab_DetailDispatch_ByPose:		; Memory Address ($9F32) and binary offset [$9BAE]
	cmpi.b	#$02,d0
	beq.s	Draw_Crab_DetailDispatch_Return
	tst.b	d0
	bne		Draw_Crab_SidePoseSelect
	cmpi.b	#$02,d1
	bcs.s	Draw_CrabCloseFrontClaw_BehemothReuse
	subq.w	#$02,d1
	lea		GFX_Crab_FarSideClaw_MirroredSourceOffsets.l,a2
	bsr		Draw_Crab_SideClaw
	moveq	#$00,d7
	move.b	CrabFarSideClaw_StripHeightMinusOneTable(pc,d1.w),d7
	add.b	CrabFarSideClaw_YOffsetTable(pc,d1.w),d5
	moveq	#$00,d6
	add.w	d1,d1
	movem.l	d0/d1/d4/d5/d7/a1,-(sp)
	add.b	CrabFarSideClaw_XOffsetTableA(pc,d1.w),d4
	bsr		Draw_Monster_16PixelStrip
	movem.l	(sp)+,d0/d1/d4/d5/d7/a1
	moveq	#-$01,d6
	add.b	CrabFarSideClaw_XOffsetTableB(pc,d1.w),d4
	bra		Draw_Monster_16PixelStrip

Draw_Crab_DetailDispatch_Return:		; Memory Address ($9F78) and binary offset [$9BF4]
	rts		

CrabFarSideClaw_YOffsetTable:		; Memory Address ($9F7A) and binary offset [$9BF6]
	; Signed Y adjustments for the Crab far-side claw strip at the two far distance
	; groups.
	dc.b	$F8	;F8
	dc.b	$F7	;F7
CrabFarSideClaw_XOffsetTableA:		; Memory Address ($9F7C) and binary offset [$9BF8]
	; First alternate base for signed X adjustments used by the normal Crab
	; far-side claw pass.
	dc.b	$F8	;F8
CrabFarSideClaw_XOffsetTableB:		; Memory Address ($9F7D) and binary offset [$9BF9]
	; Second alternate base for signed X adjustments used by the mirrored Crab
	; far-side claw pass.
	dc.b	$04	;04
	dc.b	$F9	;F9
	dc.b	$FF	;FF
CrabFarSideClaw_StripHeightMinusOneTable:		; Memory Address ($9F80) and binary offset [$9BFC]
	; DBRA height-minus-one values for the Crab far-side claw strip at the two far
	; distance groups.
	dc.b	$09	;09
	dc.b	$07	;07
BehemothClawStrip_YOffsetTable:		; Memory Address ($9F82) and binary offset [$9BFE]
	; Signed Y adjustments used when drawing the reused Behemoth claw strips.
	dc.b	$FD	;FD
	dc.b	$EF	;EF
	dc.b	$FA	;FA
	dc.b	$F1	;F1
BehemothClawStrip_XOffsetTable:		; Memory Address ($9F86) and binary offset [$9C02]
	; Signed X adjustments used when drawing the normal or mirrored Behemoth claw
	; strips.
	dc.b	$F0	;F0
	dc.b	$10	;10
	dc.b	$F6	;F6
	dc.b	$04	;04
CrabCloseFrontClaw_StripHeightMinusOneTable:		; Memory Address ($9F8A) and binary offset [$9C06]
	; DBRA height-minus-one values for the closest front-facing Crab claw strip.
	dc.b	$14	;14
	dc.b	$0D	;0D

Draw_CrabCloseFrontClaw_BehemothReuse:		; Memory Address ($9F8C) and binary offset [$9C08]
	moveq	#$00,d7
	move.b	CrabCloseFrontClaw_StripHeightMinusOneTable(pc,d1.w),d7
	moveq	#$00,d2
	moveq	#$00,d6
	bsr		Draw_BehemothClawStrip
	moveq	#$01,d2
	moveq	#-$01,d6
Draw_BehemothClawStrip:		; Memory Address ($9F9E) and binary offset [$9C1A]
	; Selects and draws one Behemoth claw strip with its projected position and
	; occlusion variant.
	lea		GFX_Behemoth_Claw_LookupTable.l,a2
	lea		GFX_Behemoth.l,a1
	movem.w	d0/d1/d4/d5/d7,-(sp)
	add.w	d1,d1
	move.w	d1,d3
	add.w	d2,d3
	add.b	BehemothClawStrip_XOffsetTable(pc,d3.w),d4
	move.w	d1,d3
	btst	d2,-$0015(a3)
	beq.s	Draw_BehemothClawStrip_AfterOcclusionCheck
	addq.w	#$01,d3
	addq.w	#$02,a2
Draw_BehemothClawStrip_AfterOcclusionCheck:		; Memory Address ($9FC4) and binary offset [$9C40]
	add.b	BehemothClawStrip_YOffsetTable(pc,d3.w),d5
	add.w	d1,d1
	add.w	$00(a2,d1.w),a1
	bsr		Draw_Monster_16PixelStrip
	movem.w	(sp)+,d0/d1/d4/d5/d7
	rts		

adrB_009FD8:
	dc.b	$08	;08
	dc.b	$12	;12
	dc.b	$07	;07
	dc.b	$0E	;0E
GFX_Crab_SideDetail_XAdjust:		; Memory Address ($9FDC) and binary offset [$9C58]
	dc.b	$E6	;E6
	dc.b	$E5	;E5
	dc.b	$1A	;1A
	dc.b	$1B	;1B
	dc.b	$EF	;EF
	dc.b	$EF	;EF
	dc.b	$0B	;0B
	dc.b	$0B	;0B
GFX_Crab_SideDetail_YAdjust:		; Memory Address ($9FE4) and binary offset [$9C60]
	dc.b	$02	;02
	dc.b	$F1	;F1
	dc.b	$FB	;FB
	dc.b	$F0	;F0

Draw_Crab_SidePoseSelect:		; Memory Address ($9FE8) and binary offset [$9C64]
	; Selects the Crab's normal or attacking side/claw pose from its animation bit.
	cmpi.b	#$02,d1
	bcc.s	Draw_Crab_DetailDispatch_Far
	lea		GFX_Crab_SideDetail_SourceOffsets.l,a2
	add.w	d1,d1
	moveq	#-$01,d6
	lsr.b	#$01,d0
	beq.s	Draw_Crab_SidePoseSelect_MergeMirrorFlag
	moveq	#$00,d6
Draw_Crab_SidePoseSelect_MergeMirrorFlag:		; Memory Address ($9FFE) and binary offset [$9C7A]
	move.w	d1,d2
	add.w	d0,d2
	add.w	d2,d2
	eor.b	#$01,d0
	btst	d0,-$0015(a3)
	beq.s	Draw_Crab_SidePoseSelect_DrawDetail
	addq.w	#$01,d1
	addq.w	#$01,d2
Draw_Crab_SidePoseSelect_DrawDetail:		; Memory Address ($A012) and binary offset [$9C8E]
	moveq	#$00,d7
	move.b	adrB_009FD8(pc,d1.w),d7
	add.b	GFX_Crab_SideDetail_XAdjust(pc,d2.w),d4
	add.b	GFX_Crab_SideDetail_YAdjust(pc,d1.w),d5
	bsr		Draw_Crab_SideClaw
	bra		Draw_Monster_16PixelStrip

CrabDetailDispatchFar_StripHeightMinusOneTable:		; Memory Address ($A028) and binary offset [$9CA4]
	; DBRA height-minus-one values used by the far-distance Crab detail strip.
	dc.b	$08	;08
	dc.b	$06	;06
GFX_Crab_SideDetail_Coords1:		; Memory Address ($A02A) and binary offset [$9CA6]
	dc.b	$F3	;F3
	dc.b	$09	;09
	dc.b	$F2	;F2
	dc.b	$06	;06
GFX_Crab_SideY_Table:		; Memory Address ($A02E) and binary offset [$9CAA]
	dc.b	$F8	;F8
	dc.b	$F7	;F7

Draw_Crab_DetailDispatch_Far:		; Memory Address ($A030) and binary offset [$9CAC]
	; Continues Crab detail selection for the far-distance classes.
	subq.b	#$02,d1
	moveq	#$00,d7
	move.b	CrabDetailDispatchFar_StripHeightMinusOneTable(pc,d1.w),d7
	add.b	GFX_Crab_SideY_Table(pc,d1.w),d5
	lea		GFX_Crab_DetailDispatchFar_SourceOffsets.l,a2
	bsr		Draw_Crab_SideClaw
	add.w	d1,d1
	moveq	#-$01,d6
	lsr.b	#$01,d0
	beq.s	Draw_Crab_DetailDispatch_Far_ApplyXOffset
	moveq	#$00,d6
	addq.w	#$01,d1
Draw_Crab_DetailDispatch_Far_ApplyXOffset:		; Memory Address ($A052) and binary offset [$9CCE]
	add.b	GFX_Crab_SideDetail_Coords1(pc,d1.w),d4
	bra		Draw_Monster_16PixelStrip

CrabDetailDispatchFront_StripHeightMinusOneTable:		; Memory Address ($A05A) and binary offset [$9CD6]
	; DBRA height-minus-one values used by the front Crab detail strip.
	dc.b	$0B	;0B
	dc.b	$07	;07
GFX_CrabFace_Position:		; Memory Address ($A05C) and binary offset [$9CD8]
	dc.b	$FE	;FE
	dc.b	$FB	;FB
GFX_Crab_SideDetail_Coords2:		; Memory Address ($A05E) and binary offset [$9CDA]
	dc.b	$EC	;EC
	dc.b	$14	;14

Draw_Crab_DetailDispatch_Front:		; Memory Address ($A060) and binary offset [$9CDC]
	; Draws the Crab's front-view side detail or dispatches to the rear-view detail
	; path.
	tst.b	d0
	bne.s	Draw_Crab_DetailDispatch_Rear
	moveq	#$00,d6
	lea		GFX_Crab_FrontClawSourceOffsets.l,a2
	movem.w	d0/d1/d4/d5,-(sp)
	move.b	CrabDetailDispatchFront_StripHeightMinusOneTable(pc,d1.w),d7
	bsr		Draw_Crab_SideClaw
	add.b	GFX_CrabFace_Position(pc,d1.w),d5
Draw_CrabDetail_SharedDrawStrip:		; Memory Address ($A07C) and binary offset [$9CF8]
	bsr		Draw_Monster_16PixelStrip
	movem.w	(sp)+,d0/d1/d4/d5
Draw_CrabDetail_SharedReturn:		; Memory Address ($A084) and binary offset [$9D00]
	rts		

Draw_Crab_DetailDispatch_Rear:		; Memory Address ($A086) and binary offset [$9D02]
	; Continues Crab detail selection for the rear orientation.
	cmpi.b	#$02,d0
	beq.s	Draw_Crab_HiddenClaws
	tst.b	d1
	bne.s	Draw_CrabDetail_SharedReturn
	lea		GFX_CrabClaw.l,a1
	movem.w	d0/d1/d4/d5,-(sp)
	moveq	#$07,d7
	subq.b	#$03,d5
	moveq	#-$01,d6
	lsr.b	#$01,d0
	beq.s	Draw_Crab_DetailDispatch_Rear_ApplyXOffset
	moveq	#$00,d6
Draw_Crab_DetailDispatch_Rear_ApplyXOffset:		; Memory Address ($A0A6) and binary offset [$9D22]
	add.b	GFX_Crab_SideDetail_Coords2(pc,d0.w),d4
	bra.s	Draw_CrabDetail_SharedDrawStrip

BeholderEye_XOffsetTable:		; Memory Address ($A0AC) and binary offset [$9D28]
	; Signed X adjustments for either of the two optional Beholder eye components;
	; also reused by the Crab rear-detail path.
	dc.b	$07	;07
	dc.b	$F9	;F9
	dc.b	$FE	;FE
	dc.b	$FC	;FC
BeholderEye_YOffsetTable:		; Memory Address ($A0B0) and binary offset [$9D2C]
	; Signed Y adjustments for the optional Beholder eye-component strips; also
	; reused by the Crab rear-detail path.
	dc.b	$EF	;EF
	dc.b	$F1	;F1
CrabHiddenClaws_StripHeightMinusOneTable:		; Memory Address ($A0B2) and binary offset [$9D2E]
	; DBRA height-minus-one values for the Crab hidden-claw strips drawn through
	; the shared Beholder component helper.
	dc.b	$07	;07
	dc.b	$04	;04

Draw_Crab_HiddenClaws:		; Memory Address ($A0B4) and binary offset [$9D30]
	; Draws the Crab's rear base strip and overlays up to two independently
	; animated hidden-claw strips when their animation bits are set.
	tst.b	-$0015(a3)
	beq.s	Draw_CrabDetail_SharedReturn
	lea		GFX_Crab_HiddenClawSourceOffsets.l,a2
	bsr.s	Draw_Crab_SideClaw
	moveq	#$00,d7
	move.b	CrabHiddenClaws_StripHeightMinusOneTable(pc,d1.w),d7
	moveq	#-$01,d6
	moveq	#$00,d2
	bsr.s	GFX_Beholder
	moveq	#$00,d6
	moveq	#$01,d2
GFX_Beholder:		; Memory Address ($A0D2) and binary offset [$9D4E]
	; Draws the Beholder's optional eye components selected by its render flags.
	btst	d2,-$0015(a3)
	beq.s	GFX_Beholder_Return
	movem.w	d0/d1/d4/d5/d7,-(sp)
	move.l	a1,-(sp)
	add.b	BeholderEye_YOffsetTable(pc,d1.w),d5
	add.w	d1,d1
	add.w	d2,d1
	add.b	BeholderEye_XOffsetTable(pc,d1.w),d4
	bsr		Draw_Monster_16PixelStrip
	move.l	(sp)+,a1
	movem.w	(sp)+,d0/d1/d4/d5/d7
GFX_Beholder_Return:		; Memory Address ($A0F4) and binary offset [$9D70]
	rts		

Draw_Crab_SideClaw:		; Memory Address ($A0F6) and binary offset [$9D72]
	; Draws the Crab's selected side/claw strip through the common 16-pixel
	; monster-strip renderer.
	lea		GFX_Crab.l,a1
	move.w	d1,d2
	add.w	d2,d2
	add.w	$00(a2,d2.w),a1
	rts		

Draw_Crab_Body:		; Memory Address ($A106) and binary offset [$9D82]
	; Draws the Crab shell/body sprite selected by the shared distance-group
	; lookup.
	lea		Monster_DistanceGroups_LookupTable.l,a0
	move.b	$00(a0,d1.w),d1
	lea		GFX_Crab_BodySourceOffsets.l,a2
	lea		CrabBody_DistanceRenderParameters.l,a0
	add.b	$00(a0,d1.w),d5
	moveq	#$00,d7
	move.b	$04(a0,d1.w),d7
	swap	d7
	move.b	$08(a0,d1.w),d7
	bsr.s	Draw_Crab_SideClaw
	movem.l	d0-d2/d4/d5/d7,-(sp)
	move.l	a1,-(sp)
	add.b	CrabBody_XOffsetTableA(pc,d2.w),d4
	moveq	#$00,d6
	bsr		Draw_Monster_CompositeBitmap
	move.l	(sp)+,a1
	movem.l	(sp),d0-d2/d4/d5/d7
	moveq	#-$01,d6
	add.b	CrabBody_XOffsetTableB(pc,d2.w),d4
	bsr		Draw_Monster_CompositeBitmap
	movem.l	(sp)+,d0-d2/d4/d5/d7
	rts		

CrabBody_XOffsetTableA:		; Memory Address ($A154) and binary offset [$9DD0]
	; Alternate base of the first-pass Crab body X-adjustment table.
	dc.b	$EC	;EC
CrabBody_XOffsetTableB:		; Memory Address ($A155) and binary offset [$9DD1]
	; Alternate base of the mirrored second-pass Crab body X-adjustment table.
	dc.b	$04	;04
	dc.b	$F2	;F2
	dc.b	$F8	;F8
	dc.b	$F8	;F8
	dc.b	$04	;04
	dc.b	$F9	;F9
	dc.b	$FF	;FF
CrabBody_DistanceRenderParameters:		; Memory Address ($A15C) and binary offset [$9DD8]
	; Parallel per-distance Crab body Y-adjustment, width-minus-one, and
	; height-minus-one values.
	dc.w	$080B	;080B
	dc.w	$1714	;1714
	dc.w	$0101	;0101
	dc.w	$0000	;0000
	dc.w	$1C12	;1C12
	dc.w	$0C09	;0C09
GFX_Crab_BodySourceOffsets:		; Memory Address ($A168) and binary offset [$9DE4]
	; Source offsets within GFX_Crab used for the Crab body strips.
	dc.w	$0000	;0000
	dc.w	$01D0	;01D0
	dc.w	$0300	;0300
	dc.w	$0368	;0368
GFX_Crab_FrontClawSourceOffsets:		; Memory Address ($A170) and binary offset [$9DEC]
	; Source offsets within GFX_Crab used for the front claw strips.
	dc.w	$03B8	;03B8
	dc.w	$0418	;0418
	dc.w	$0458	;0458
GFX_Crab_HiddenClawSourceOffsets:		; Memory Address ($A176) and binary offset [$9DF2]
	; Source offsets within GFX_Crab used for the hidden claw strips.
	dc.w	$0498	;0498
	dc.w	$04D8	;04D8
GFX_Crab_FarSideClaw_MirroredSourceOffsets:		; Memory Address ($A17A) and binary offset [$9DF6]
	; Source offsets within GFX_Crab used for the mirrored far-side claw strips.
	dc.w	$0500	;0500
	dc.w	$0550	;0550
GFX_Crab_SideDetail_SourceOffsets:		; Memory Address ($A17E) and binary offset [$9DFA]
	dc.w	$0590	;0590
	dc.w	$05D8	;05D8
	dc.w	$0670	;0670
	dc.w	$06B0	;06B0
GFX_Crab_DetailDispatchFar_SourceOffsets:		; Memory Address ($A186) and binary offset [$9E02]
	; Source offsets within GFX_Crab used by the far-distance detail dispatcher.
	dc.w	$0728	;0728
	dc.w	$0770	;0770

Draw_Beholder:		; Memory Address ($A18A) and binary offset [$9E06]
	; Selects the Beholder colour route and composes its body, upper eyes, and
	; large lower eye/details for the current distance and facing.
	moveq	#$04,d3
	lea		Monster_Beholder_Colours.l,a0
	bsr		MonsterColourGrading
	bsr		Draw_Beholder_BodyAndUpperEyes
	cmpi.b	#$02,d0
	beq.s	Draw_Beholder_Exit
	bsr		Draw_Beholder_CentralEye
Draw_Beholder_Exit:		; Memory Address ($A1A4) and binary offset [$9E20]
	clr.w	Buffer_Colour_Mask_Toggle.l
	rts		

Monster_Beholder_Colours:		; Memory Address ($A1AC) and binary offset [$9E28]
	INCBIN "/data/BLOODWYCH439-clean/monsters/beholder.colours"
GFX_Beholder_CentralEye_Near_Front_Heights:		; Memory Address ($A1B4) and binary offset [$9E30]
	; Front-facing central-eye heights
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_CentralEye_Near_Front.heights"
GFX_Beholder_CentralEye_Near_YPositions:		; Memory Address ($A1B8) and binary offset [$9E34]
	; Shared near-eye vertical placement
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_CentralEye_Near_Y.positions"

Draw_Beholder_CentralEye:		; Memory Address ($A1BC) and binary offset [$9E38]
	; Draws the Beholder's large lower-eye assembly and its optional near-distance
	; detail components, mirroring the appropriate side.
	cmpi.b	#$04,d1
	bcc.s	Draw_Beholder_CentralEye_Far
	lea		GFX_Beholder_CentralEye_Near_LookupTable.l,a2
	moveq	#$00,d7
	add.b	GFX_Beholder_CentralEye_Near_YPositions(pc,d1.w),d5
	move.w	d1,d2
	add.w	d2,d2
	btst	#$01,-$0015(a3)
	beq.s	Draw_Beholder_CentralEye_MergeIndexBit
	addq.w	#$01,d2
Draw_Beholder_CentralEye_MergeIndexBit:		; Memory Address ($A1DC) and binary offset [$9E58]
	add.w	d2,d2
	lea		GFX_Beholder_Body.l,a1
	tst.b	d0
	bne.s	Draw_Beholder_CentralEye_NearSide
	move.b	GFX_Beholder_CentralEye_Near_Front_Heights(pc,d1.w),d7
	add.w	$00(a2,d2.w),a1
	bra		Draw_Beholder_Component

GFX_Beholder_CentralEye_Near_Side_Heights:		; Memory Address ($A1F4) and binary offset [$9E70]
	; Side-facing central-eye heights
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_CentralEye_Near_Side.heights"
GFX_Beholder_CentralEye_Near_Side_Mirrored_XPositions:		; Memory Address ($A1F8) and binary offset [$9E74]
	; X correction for the mirrored side
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_CentralEye_Near_Side_Mirrored_X.positions"
GFX_Beholder_CentralEye_Near_Side_YPositions:		; Memory Address ($A1FC) and binary offset [$9E78]
	; Additional side-view Y correction
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_CentralEye_Near_Side_Y.positions"

Draw_Beholder_CentralEye_NearSide:		; Memory Address ($A200) and binary offset [$9E7C]
	add.w	#$0010,a2
	add.w	$00(a2,d2.w),a1
	move.b	GFX_Beholder_CentralEye_Near_Side_Heights(pc,d1.w),d7
	add.b	GFX_Beholder_CentralEye_Near_Side_YPositions(pc,d1.w),d5
	moveq	#$00,d6
	lsr.b	#$01,d0
	beq		Draw_Monster_16PixelStrip
	add.b	GFX_Beholder_CentralEye_Near_Side_Mirrored_XPositions(pc,d1.w),d4
	moveq	#-$01,d6
	bra		Draw_Monster_16PixelStrip

GFX_Beholder_CentralEye_Far_YPositions:		; Memory Address ($A222) and binary offset [$9E9E]
	; Far-eye Y placement
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_CentralEye_Far_Y.positions"
GFX_Beholder_CentralEye_Far_Side_Mirrored_XPositions:		; Memory Address ($A224) and binary offset [$9EA0]
	; Mirrored far-side X correction
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_CentralEye_Far_Side_Mirrored_X.positions"

Draw_Beholder_CentralEye_Far:		; Memory Address ($A226) and binary offset [$9EA2]
	; Draws the smaller far-distance form of the Beholder's large lower eye.
	lea		GFX_Beholder_CentralEye_Far_LookupTable.l,a2
	subq.w	#$04,d1
	move.w	d1,d2
	moveq	#$02,d7
	add.b	GFX_Beholder_CentralEye_Far_YPositions(pc,d1.w),d5
	moveq	#$00,d6
	tst.b	d0
	beq.s	Draw_Beholder_CentralEye_Far_DrawStrip
	addq.w	#$02,d2
	lsr.b	#$01,d0
	beq.s	Draw_Beholder_CentralEye_Far_DrawStrip
	moveq	#-$01,d6
	add.b	GFX_Beholder_CentralEye_Far_Side_Mirrored_XPositions(pc,d1.w),d4
Draw_Beholder_CentralEye_Far_DrawStrip:		; Memory Address ($A248) and binary offset [$9EC4]
	add.w	d2,d2
	lea		GFX_Beholder_Body.l,a1
	add.w	$00(a2,d2.w),a1
	bra		Draw_Monster_16PixelStrip

GFX_Beholder_Body_Heights:		; Memory Address ($A258) and binary offset [$9ED4]
	; Body heights, stored as pixels minus one
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_Body.heights"
GFX_Beholder_Composite_XPositions:		; Memory Address ($A25E) and binary offset [$9EDA]
	; Whole composite’s base X adjustment
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_Composite_X.positions"
GFX_Beholder_Composite_YPositions:		; Memory Address ($A264) and binary offset [$9EE0]
	; Whole composite’s base Y adjustment
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_Composite_Y.positions"
GFX_Beholder_UpperEyes_Heights:		; Memory Address ($A26A) and binary offset [$9EE6]
	; Upper-eye height and vertical displacement
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_UpperEyes.heights"

Draw_Beholder_BodyAndUpperEyes:		; Memory Address ($A26E) and binary offset [$9EEA]
	; Draws the Beholder body and upper eye-stalk components, including the
	; mirrored near-distance copy.
	moveq	#$00,d7
	move.b	GFX_Beholder_Body_Heights(pc,d1.w),d7
	add.b	GFX_Beholder_Composite_XPositions(pc,d1.w),d4
	add.b	GFX_Beholder_Composite_YPositions(pc,d1.w),d5
	lea		GFX_Beholder_Body_LookupTable.l,a2
	bsr		Select_Beholder_GfxFromLookup
	bsr		Draw_Beholder_Component
	cmpi.b	#$04,d1
	bcc.s	Draw_Beholder_BodyAndUpperEyes_Return
	lea		GFX_Beholder_UpperEyes_LookupTable.l,a2
	bsr		Select_Beholder_GfxFromLookup
	move.w	d5,-(sp)
	moveq	#$00,d7
	move.b	GFX_Beholder_UpperEyes_Heights(pc,d1.w),d7
	sub.b	d7,d5
	move.b	-$0015(a3),d2
	not.b	d2
	and.w	#$0001,d2
	sub.b	d2,d5
	bsr.s	Draw_Beholder_Component
	move.w	(sp)+,d5
Draw_Beholder_BodyAndUpperEyes_Return:		; Memory Address ($A2B4) and binary offset [$9F30]
	rts		

Draw_Beholder_Component:		; Memory Address ($A2B6) and binary offset [$9F32]
	; Draws one Beholder component with the source offset, placement, and optional
	; mirroring selected by the caller.
	movem.w	d0/d1/d4/d5/d7,-(sp)
	move.l	a1,-(sp)
	moveq	#$00,d6
	bsr		Draw_Monster_16PixelStrip
	move.l	(sp)+,a1
	movem.w	(sp)+,d0/d1/d4/d5/d7
	cmpi.b	#$02,d1
	bcc.s	Draw_Beholder_BodyAndUpperEyes_Return
	moveq	#-$01,d6
	movem.w	d0/d1/d4/d5/d7,-(sp)
	add.b	GFX_Beholder_Near_MirroredHalf_XPositions(pc,d1.w),d4
	bsr		Draw_Monster_16PixelStrip
	movem.w	(sp)+,d0/d1/d4/d5/d7
	rts		

GFX_Beholder_Near_MirroredHalf_XPositions:		; Memory Address ($A2E2) and binary offset [$9F5E]
	; Spacing of mirrored halves at the two nearest sizes
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_Near_MirroredHalf_X.positions"

Select_Beholder_GfxFromLookup:		; Memory Address ($A2E4) and binary offset [$9F60]
	; Converts a Beholder component index into an offset from the packed Beholder
	; graphic bank.
	move.w	d1,d2
	add.w	d2,d2
	lea		GFX_Beholder_Body.l,a1
	add.w	$00(a2,d2.w),a1
	rts		

GFX_Beholder_Body_LookupTable:		; Memory Address ($A2F4) and binary offset [$9F70]
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_Body.offsets"
GFX_Beholder_UpperEyes_LookupTable:		; Memory Address ($A300) and binary offset [$9F7C]
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_UpperEyes.offsets"
GFX_Beholder_CentralEye_Near_LookupTable:		; Memory Address ($A308) and binary offset [$9F84]
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_CentralEye_Near.offsets"
GFX_Beholder_CentralEye_Far_LookupTable:		; Memory Address ($A328) and binary offset [$9FA4]
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_CentralEye_Far.offsets"

Draw_LittleDragon:		; Memory Address ($A330) and binary offset [$9FAC]
	moveq	#$01,d2
	lea		GFX_LittleDragon_SourceOffsets.l,a2
	moveq	#$03,d3
	bra.s	Draw_Dragon_ComputeBodyPosition

GFX_LittleDragon_SourceOffsets:		; Memory Address ($A33C) and binary offset [$9FB8]
	; Source offsets within GFX_Dragon used by the Little Dragon renderer.
	dc.w	$F1F5	;F1F5
	dc.w	$FBFA	;FBFA
	dc.w	$FD01	;FD01
	dc.w	$0E0D	;0E0D
BigDragon_Table_Unknown:		; Memory Address ($A344) and binary offset [$9FC0]
	dc.w	$E8EE	;E8EE
	dc.w	$F6F9	;F6F9
	dc.w	$F0F8	;F0F8
	dc.w	$0909	;0909

Draw_BigDragon:		; Memory Address ($A34C) and binary offset [$9FC8]
	moveq	#$00,d2
	lea		BigDragon_Table_Unknown.l,a2
	moveq	#$09,d3
Draw_Dragon_ComputeBodyPosition:		; Memory Address ($A356) and binary offset [$9FD2]
	lea		Monster_DistanceGroups_LookupTable.l,a0
	move.b	$00(a0,d1.w),d1
	add.b	$00(a2,d1.w),d4
	add.b	$04(a2,d1.w),d5
	add.w	d2,d1
	btst	#$00,d0
	beq.s	Draw_Dragon_ColourAndDetailDraw
	move.w	d0,d2
	lsr.w	#$01,d2
	add.w	d1,d2
	add.w	d1,d2
	add.b	GFX_Dragon_Side_XPositions(pc,d2.w),d4
Draw_Dragon_ColourAndDetailDraw:		; Memory Address ($A37C) and binary offset [$9FF8]
	lea		Monster_Dragon_Colours.l,a0
	bsr		MonsterColourGrading
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l
	bsr		Draw_DragonSideDetail
	bsr.s	Draw_DragonSideDetail_Conditional
	clr.w	Buffer_Colour_Mask_Toggle.l
Draw_Dragon_Return:		; Memory Address ($A39A) and binary offset [$A016]
	rts		

GFX_Dragon_Side_XPositions:		; Memory Address ($A39C) and binary offset [$A018]
	; Additional horizontal shifts for side-facing Dragons by size group and side.
	INCBIN "/data/BLOODWYCH439-clean/monsters/Dragon_Side_X.positions"
Monster_Dragon_Colours:		; Memory Address ($A3A6) and binary offset [$A022]
	INCBIN "/data/BLOODWYCH439-clean/monsters/dragon.colours"

Draw_DragonSideDetail_Conditional:		; Memory Address ($A3AE) and binary offset [$A02A]
	; Conditionally selects and draws the Dragon's second side-detail pass for
	; eligible poses and facings.
	cmpi.b	#$02,d0
	beq.s	Draw_Dragon_Return
	cmpi.b	#$03,d1
	bcc.s	Draw_Dragon_Return
	moveq	#$00,d2
	moveq	#$00,d6
	movem.w	d0/d1/d4/d5,-(sp)
	bsr.s	Select_DragonDetailVariant
	movem.w	(sp)+,d0/d1/d4/d5
	tst.w	d0
	bne.s	Draw_Dragon_Return
	moveq	#-$01,d6
	moveq	#$01,d2
Select_DragonDetailVariant:		; Memory Address ($A3D0) and binary offset [$A04C]
	; Selects the Dragon detail frame, mirroring state, and projected offsets from
	; pose, facing, and occlusion.
	move.w	d1,d3
	asl.w	#$02,d3
	move.w	d0,d7
	beq.s	Select_DragonDetailVariant_MergeIndex
	addq.w	#$02,d3
	lsr.w	#$01,d7
	bne.s	Select_DragonDetailVariant_MergeIndex
	not.l	d6
Select_DragonDetailVariant_MergeIndex:		; Memory Address ($A3E0) and binary offset [$A05C]
	btst	d2,-$0015(a3)
	beq.s	Select_DragonDetailVariant_LoadFrame
	addq.w	#$01,d3
Select_DragonDetailVariant_LoadFrame:		; Memory Address ($A3E8) and binary offset [$A064]
	moveq	#$00,d7
	move.b	DragonDetail_WidthMinusOneTable(pc,d3.w),d7
	swap	d7
	move.b	DragonDetail_HeightMinusOneTable(pc,d3.w),d7
	add.b	DragonDetailYOffsetTable(pc,d3.w),d5
	add.w	d3,d3
	lea		GFX_Dragon_DetailSourceOffsets.l,a2
	lea		GFX_Dragon.l,a1
	add.w	$00(a2,d3.w),a1
	tst.w	d6
	bpl.s	Select_DragonDetailVariant_ApplyXOffset
	addq.w	#$01,d3
Select_DragonDetailVariant_ApplyXOffset:		; Memory Address ($A410) and binary offset [$A08C]
	add.b	DragonDetailXOffsetTable(pc,d3.w),d4
	bra		Draw_Monster_CompositeBitmap

DragonDetail_WidthMinusOneTable:		; Memory Address ($A418) and binary offset [$A094]
	; Width-minus-one values packed into the high word of D7 for Dragon detail
	; bitmap draws.
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
DragonDetail_HeightMinusOneTable:		; Memory Address ($A424) and binary offset [$A0A0]
	; Height-minus-one values packed into the low word of D7 for Dragon detail
	; bitmap draws.
	dc.b	$14	;14
	dc.b	$16	;16
	dc.b	$12	;12
	dc.b	$15	;15
	dc.b	$0F	;0F
	dc.b	$0F	;0F
	dc.b	$0C	;0C
	dc.b	$0E	;0E
	dc.b	$0A	;0A
	dc.b	$0A	;0A
	dc.b	$09	;09
	dc.b	$0A	;0A
DragonDetailYOffsetTable:		; Memory Address ($A430) and binary offset [$A0AC]
	; Signed Y adjustments for table-driven Dragon detail bitmap draws.
	dc.b	$22	;22
	dc.b	$14	;14
	dc.b	$24	;24
	dc.b	$14	;14
	dc.b	$17	;17
	dc.b	$0E	;0E
	dc.b	$1A	;1A
	dc.b	$0F	;0F
	dc.b	$11	;11
	dc.b	$0A	;0A
	dc.b	$12	;12
	dc.b	$0A	;0A
DragonDetailXOffsetTable:		; Memory Address ($A43C) and binary offset [$A0B8]
	; Signed X adjustments for normal and mirrored Dragon detail bitmap draws.
	dc.b	$05	;05
	dc.b	$2B	;2B
	dc.b	$04	;04
	dc.b	$2C	;2C
	dc.b	$2B	;2B
	dc.b	$05	;05
	dc.b	$2B	;2B
	dc.b	$05	;05
	dc.b	$04	;04
	dc.b	$1A	;1A
	dc.b	$04	;04
	dc.b	$1A	;1A
	dc.b	$25	;25
	dc.b	$FB	;FB
	dc.b	$25	;25
	dc.b	$0B	;0B
	dc.b	$01	;01
	dc.b	$0F	;0F
	dc.b	$01	;01
	dc.b	$0F	;0F
	dc.b	$1C	;1C
	dc.b	$04	;04
	dc.b	$1C	;1C
	dc.b	$04	;04
DragonSideDetail_WidthMinusOneTable:		; Memory Address ($A454) and binary offset [$A0D0]
	; Width-minus-one values packed into the high word of D7 for Dragon side-detail
	; bitmap draws.
	dc.b	$01	;01
	dc.b	$04	;04
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$03	;03
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$00	;00
DragonSideDetailVariantOffsetTable:		; Memory Address ($A463) and binary offset [$A0DF]
	; Selects a Dragon side-detail variant and uses bit 7 to request the mirrored
	; alternative.
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$81	;81
DragonSideDetail_HeightMinusOneTable:		; Memory Address ($A467) and binary offset [$A0E3]
	; Height-minus-one values packed into the low word of D7 for Dragon side-detail
	; bitmap draws.
	dc.b	$31	;31
	dc.b	$36	;36
	dc.b	$35	;35
	dc.b	$23	;23
	dc.b	$26	;26
	dc.b	$26	;26
	dc.b	$1B	;1B
	dc.b	$1B	;1B
	dc.b	$1B	;1B
	dc.b	$14	;14
	dc.b	$14	;14
	dc.b	$13	;13
	dc.b	$0F	;0F
	dc.b	$0F	;0F
	dc.b	$0F	;0F

Draw_DragonSideDetail:		; Memory Address ($A476) and binary offset [$A0F2]
	; Selects and draws the Dragon's first table-driven side-detail pass.
	move.w	d1,d2
	add.w	d2,d2
	add.w	d1,d2
	moveq	#$00,d6
	move.b	DragonSideDetailVariantOffsetTable(pc,d0.w),d3
	bpl.s	Draw_DragonSideDetail_MergeVariantIndex
	moveq	#-$01,d6
	moveq	#$01,d3
Draw_DragonSideDetail_MergeVariantIndex:		; Memory Address ($A488) and binary offset [$A104]
	add.b	d3,d2
	moveq	#$00,d7
	move.b	DragonSideDetail_WidthMinusOneTable(pc,d2.w),d7
	swap	d7
	move.b	DragonSideDetail_HeightMinusOneTable(pc,d2.w),d7
	add.w	d2,d2
	lea		GFX_Dragon_SideDetailSourceOffsets.l,a2
	lea		GFX_Dragon.l,a1
	add.w	$00(a2,d2.w),a1
	movem.l	d0/d1/d4/d5/d7/a1,-(sp)
	bsr		Draw_Monster_CompositeBitmap
	movem.l	(sp)+,d0/d1/d4/d5/d7/a1
	btst	#$00,d0
	bne.s	Draw_DragonSideDetail_Return
	moveq	#-$01,d6
	movem.w	d0/d1/d4/d5,-(sp)
	add.b	GFX_Dragon_MirroredHalf_XPositions(pc,d1.w),d4
	bsr		Draw_Monster_CompositeBitmap
	movem.w	(sp)+,d0/d1/d4/d5
Draw_DragonSideDetail_Return:		; Memory Address ($A4CC) and binary offset [$A148]
	rts		

GFX_Dragon_MirroredHalf_XPositions:		; Memory Address ($A4CE) and binary offset [$A14A]
	; Horizontal spacing used when the Dragon body is completed by drawing a
	; mirrored second half.
	INCBIN "/data/BLOODWYCH439-clean/monsters/Dragon_MirroredHalf_X.positions"
GFX_Dragon_SideDetailSourceOffsets:		; Memory Address ($A4D4) and binary offset [$A150]
	; Source offsets within GFX_Dragon used by the first side-detail renderer.
	dc.w	$0000	;0000
	dc.w	$0320	;0320
	dc.w	$0BB8	;0BB8
	dc.w	$0F18	;0F18
	dc.w	$1158	;1158
	dc.w	$1638	;1638
	dc.w	$18A8	;18A8
	dc.w	$1988	;1988
	dc.w	$1C28	;1C28
	dc.w	$1D08	;1D08
	dc.w	$1DB0	;1DB0
	dc.w	$1F00	;1F00
	dc.w	$1FA0	;1FA0
	dc.w	$2020	;2020
	dc.w	$2120	;2120
GFX_Dragon_DetailSourceOffsets:		; Memory Address ($A4F2) and binary offset [$A16E]
	; Source offsets within GFX_Dragon used by the conditional detail renderer.
	dc.w	$21A0	;21A0
	dc.w	$2248	;2248
	dc.w	$2300	;2300
	dc.w	$2430	;2430
	dc.w	$2590	;2590
	dc.w	$2610	;2610
	dc.w	$2690	;2690
	dc.w	$2760	;2760
	dc.w	$27D8	;27D8
	dc.w	$2830	;2830
	dc.w	$2888	;2888
	dc.w	$28D8	;28D8

Draw_Behemoth:		; Memory Address ($A50A) and binary offset [$A186]
	; Composes the Behemoth from its family-specific layout data.
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l
	lea		Monster_Behemoth_Colours.l,a0
	moveq	#$06,d3
	bsr		MonsterColourGrading
	lea		GFX_Behemoth_Layout.l,a0
	bsr.s	Draw_LargeMonster_Body
	clr.w	Buffer_Colour_Mask_Toggle.l
	rts		

Monster_Behemoth_Colours:		; Memory Address ($A52E) and binary offset [$A1AA]
	INCBIN "/data/BLOODWYCH439-clean/monsters/behemoth.colours"
Monster_DistanceGroups_LookupTable:		; Memory Address ($A536) and binary offset [$A1B2]
	; Maps six visible distance slots to four stored size groups used by centred
	; large monsters.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Monster_DistanceGroups.lookup"

Draw_Entropy:		; Memory Address ($A53C) and binary offset [$A1B8]
	; Composes Entropy using its family layout and the identity colour route rather
	; than a monster-grade colour table.
	move.l	#$04080C,Buffer_Colour_Mask.l
	lea		GFX_Entropy_Layout.l,a0
Draw_LargeMonster_Body:		; Memory Address ($A54C) and binary offset [$A1C8]
	; Shared body-and-arm compositor for Behemoth and Entropy, driven by the
	; selected family's layout structure.
	move.b	Monster_DistanceGroups_LookupTable(pc,d1.w),d1
	lea		$0042(a0),a2

	move.l	$003E(a0),a1														;2268003E    *Fix stored address **

	bsr		Resolve_MonsterBodyPoseGeometry
	add.b	$16(a0,d1.w),d4
	move.w	d0,d2
	lsr.w	#$01,d2
	bcc.s	Draw_LargeMonster_Body_DrawBody
	add.w	d1,d2
	add.w	d1,d2
	add.b	$1A(a0,d2.w),d4
Draw_LargeMonster_Body_DrawBody:		; Memory Address ($A56E) and binary offset [$A1EA]
	movem.l	d0/d1/d4/d5/d7/a0/a1,-(sp)
	bsr		Draw_Monster_CompositeBitmap
	movem.l	(sp),d0/d1/d4/d5/d7/a0/a1
	btst	#$00,d0
	bne.s	Draw_LargeMonster_Body_AfterBodyDraw
	moveq	#-$01,d6
	add.b	$22(a0,d1.w),d4
	bsr		Draw_Monster_CompositeBitmap
Draw_LargeMonster_Body_AfterBodyDraw:		; Memory Address ($A58A) and binary offset [$A206]
	movem.l	(sp)+,d0/d1/d4/d5/d7/a0/a1
	cmpi.b	#$02,d1
	bcc.s	Draw_LargeMonster_Body_Return
	lea		Buffer_Colour_Mask.l,a6
	moveq	#$00,d2
	moveq	#$00,d6
	move.l	a0,-(sp)
	bsr.s	Resolve_CreatureLimbOffset
	move.l	(sp)+,a0
	btst	#$00,d0
	bne.s	Draw_LargeMonster_Body_Return
	moveq	#$01,d2
	moveq	#-$01,d6
Resolve_CreatureLimbOffset:		; Memory Address ($A5AE) and binary offset [$A22A]
	; Resolves a generic creature-limb source offset, projected position,
	; dimensions, and mirrored variant.
	movem.w	d0/d1/d4/d5,-(sp)
	move.l	$003E(a0),a1
	add.w	d1,d1
	moveq	#$00,d3
	btst	d2,-$0015(a3)
	beq.s	Resolve_CreatureLimbOffset_AfterOcclusion
	addq.w	#$01,d1
	moveq	#-$01,d3
Resolve_CreatureLimbOffset_AfterOcclusion:		; Memory Address ($A5C4) and binary offset [$A240]
	moveq	#$00,d7
	move.b	$2A(a0,d1.w),d7
	add.b	$26(a0,d1.w),d5
	add.w	d1,d1
	add.w	$5A(a0,d1.w),a1
	add.w	d1,d1
	lsr.w	#$01,d0
	bcc.s	Resolve_CreatureLimbOffset_MirrorAdjustIndex
	addq.w	#$02,d1
	tst.w	d3
	bpl.s	Resolve_CreatureLimbOffset_ToggleMirrorByFacing
	tst.w	-$0002(a0)
	beq.s	Resolve_CreatureLimbOffset_ToggleMirrorByFacing
	not.w	d6
Resolve_CreatureLimbOffset_ToggleMirrorByFacing:		; Memory Address ($A5E8) and binary offset [$A264]
	tst.w	d0
	bne.s	Resolve_CreatureLimbOffset_MirrorAdjustIndex
	not.w	d6
Resolve_CreatureLimbOffset_MirrorAdjustIndex:		; Memory Address ($A5EE) and binary offset [$A26A]
	tst.w	d6
	beq.s	Resolve_CreatureLimbOffset_DrawStrip
	addq.w	#$01,d1
Resolve_CreatureLimbOffset_DrawStrip:		; Memory Address ($A5F4) and binary offset [$A270]
	add.b	$2E(a0,d1.w),d4
	bsr		Draw_Monster_16PixelStrip
	movem.w	(sp)+,d0/d1/d4/d5
Draw_LargeMonster_Body_Return:		; Memory Address ($A600) and binary offset [$A27C]
	rts		

;fiX Label expected
	dc.w	$FFFF	;FFFF
GFX_Entropy_Layout:		; Memory Address ($A604) and binary offset [$A280]
	; Packed Entropy body and limb dimensions, positions, and mirroring rules.
	INCBIN "/data/BLOODWYCH439-clean/monsters/Entropy.layout"


	; dc.w    $0004   ;0004
	; dc.w    $B290   ;B290
	dc.l	GFX_Entropy
	
	dc.w	$0000	;0000
	dc.w	$0198	;0198
	dc.w	$0660	;0660
	dc.w	$07F8	;07F8
	dc.w	$0918	;0918
	dc.w	$0B58	;0B58
	dc.w	$0C78	;0C78
	dc.w	$0D50	;0D50
	dc.w	$0F00	;0F00
	dc.w	$0FD8	;0FD8
	dc.w	$1080	;1080
	dc.w	$1128	;1128
	dc.w	$11D0	;11D0
	dc.w	$12A0	;12A0
	dc.w	$1348	;1348
	dc.w	$13D8	;13D8
	dc.w	$0000	;0000
GFX_Behemoth_Layout:		; Memory Address ($A668) and binary offset [$A2E4]
	; Packed Behemoth body and claw dimensions, positions, and mirroring rules.
	INCBIN "/data/BLOODWYCH439-clean/monsters/Behemoth.layout"

	; dc.w    $0004   ;0004
	; dc.w    $66D0   ;66D0
	; Behemoth Graphic Fix
	dc.l	GFX_Behemoth

	dc.w	$0000	;0000
	dc.w	$02C0	;02C0
	dc.w	$06E0	;06E0
	dc.w	$09A0	;09A0
	dc.w	$0A98	;0A98
	dc.w	$0C88	;0C88
	dc.w	$0D80	;0D80
	dc.w	$0E28	;0E28
	dc.w	$0F78	;0F78
	dc.w	$1020	;1020
	dc.w	$10A8	;10A8
	dc.w	$1130	;1130
GFX_Behemoth_Claw_LookupTable:		; Memory Address ($A6C2) and binary offset [$A33E]
	; Offsets of four Behemoth claw pictures; the closest front-facing Crab reuses
	; these graphics.
	INCBIN "/data/BLOODWYCH439-clean/monsters/Behemoth_Claws.offsets"

Draw_Monster_CompositeBitmap:		; Memory Address ($A6CA) and binary offset [$A346]
	; Dispatches a monster component to the normal or off-screen drawing path after
	; applying its screen offset.
	add.w	$0008(a5),d5
	move.b	d4,d6
	add.b	#$60,d4
	ext.w	d6
	asr.w	#$04,d6
	move.l	a3,-(sp)
	tst.l	d6
	bmi.s	Draw_Monster_CompositeBitmap_BitReversedPath
	bsr		Draw_PlanarSprite_Normal
	bra.s	Draw_Monster_CompositeBitmap_Return

Draw_Monster_CompositeBitmap_BitReversedPath:		; Memory Address ($A6E4) and binary offset [$A360]
	bsr		Draw_PlanarSprite_BitReversed
Draw_Monster_CompositeBitmap_Return:		; Memory Address ($A6E8) and binary offset [$A364]
	move.l	(sp)+,a3
	rts		

Draw_DungeonOccupant_ResolvePosition:		; Memory Address ($A6EC) and binary offset [$A368]
	bsr		Prepare_Monster_ScreenPosition
	tst.b	d1
	bpl.s	Draw_DungeonOccupant_CheckAirborneSpell
	rts		

Draw_DungeonOccupant_CheckAirborneSpell:		; Memory Address ($A6F6) and binary offset [$A372]
	move.b	-$0017(a3),d0
	bmi		Draw_AirbourneSpell
	move.w	-$000A(a3),d0
	btst	#$00,d0
	bne.s	Draw_DungeonOccupant_DispatchByType
	addq.w	#$02,d0
Draw_DungeonOccupant_DispatchByType:		; Memory Address ($A70A) and binary offset [$A386]
	add.b	-$001B(a3),d0
	and.w	#$0003,d0
	moveq	#$00,d2
	move.b	-$0017(a3),d2
	sub.b	#ActorForm_MonsterRendererFirst,d2									;Converts the monster type code into the renderer dispatch index; codes below the first monster type continue to character drawing.
	bcs.s	Draw_Character
	cmpi.b	#$02,d2
	beq		Draw_Beholder
	bcs		Draw_Summon
	subq.b	#$03,d2
	lea		Creatures_LookupTable.l,a1
	add.w	d2,d2
	add.w	$00(a1,d2.w),a1
	jmp		(a1)

Creatures_LookupTable:		; Memory Address ($A73A) and binary offset [$A3B6]
	dc.w	Draw_Behemoth-Creatures_LookupTable	;FDD0
	dc.w	Draw_Crab-Creatures_LookupTable	;F7C0
	dc.w	Draw_BigDragon-Creatures_LookupTable	;FC12
	dc.w	Draw_LittleDragon-Creatures_LookupTable	;FBF6
	dc.w	Draw_Entropy-Creatures_LookupTable	;FE02

Draw_Character:		; Memory Address ($A744) and binary offset [$A3C0]
	; Composes a character from five near-view body parts or dispatches to the
	; single-sprite distant-view path.
	moveq	#$00,d2
	move.b	-$0017(a3),d2
	lea		CharacterHeadSel.l,a0
	move.b	$00(a0,d2.w),-$0018(a3)
	move.w	d1,d2
	asl.w	#$02,d2
	add.w	d0,d2
	add.w	d2,d2
	move.w	d2,d3
	asl.w	#$02,d2
	add.w	d3,d2
	moveq	#$00,d6
	move.b	-$0017(a3),d3
	cmpi.b	#$10,d3
	bcc		Select_CharacterBodyArmourCategory
	move.w	d3,d7
	asl.b	#$04,d7
	lea		Character_Pockets_DataTable+$02.l,a0
	move.b	$00(a0,d7.w),d7
	cmpi.w	#$0024,d7
	bcc.s	Select_CharacterBodyArmourCategory
	sub.w	#$001B,d7
	bcs.s	Select_CharacterBodyArmourCategory
	move.b	Character_WornArmour_RenderOverrides(pc,d7.w),d6
	bra.s	Select_CharacterBodyArmourCategory

Character_WornArmour_RenderOverrides:		; Memory Address ($A792) and binary offset [$A40E]
	; Maps worn body armour $1B-$23 to the alternate character body and colour
	; override flags.
	dc.b	$01,$02,$03,$42,$43,$82,$83,$C2,$C3
	dc.b	$00	;00
CharacterBodySel:		; Memory Address ($A79C) and binary offset [$A418]
	INCBIN "/data/BLOODWYCH439-clean/data/characters.bodies"

Select_CharacterBodyArmourCategory:		; Memory Address ($A7F2) and binary offset [$A46E]
	; Selects the character body/armour category, flooring nonzero armoured bases
	; at category 3 before applying the armour override.
	move.b	CharacterBodySel(pc,d3.w),d3
	beq.s	CharacterBodyArmourCategory_ResolveLayout
	tst.w	d6
	beq.s	CharacterBodyArmourCategory_ResolveLayout
	cmpi.w	#$0003,d3
	bcc.s	Draw_Character_ArmourCategoryShift
	moveq	#$03,d3
Draw_Character_ArmourCategoryShift:		; Memory Address ($A804) and binary offset [$A480]
	; Applies the armour-category adjustment as (max(base,3)+2*override)&$0F when
	; an armour override is present.
	add.b	d6,d3
	add.b	d6,d3
CharacterBodyArmourCategory_ResolveLayout:		; Memory Address ($A808) and binary offset [$A484]
	move.b	d6,-$001C(a3)
	lea		Character_BodyDefinitions.l,a0
	and.w	#$000F,d3
	mulu	#$000A,d3
	lea		$02(a0,d3.w),a0
	lea		Character_RenderLayout_Standard.l,a1
	tst.w	-$0002(a0)
	beq.s	Draw_Character_SelectRenderLayout
	lea		Character_RenderLayout_Alternate.l,a1
Draw_Character_SelectRenderLayout:		; Memory Address ($A830) and binary offset [$A4AC]
	move.l	a0,-(sp)
	move.l	a1,-(sp)
	move.w	d2,-(sp)
	move.w	d5,-(sp)
	move.w	d4,-(sp)
	move.w	d1,-(sp)
	move.w	d0,-(sp)
	cmpi.w	#$0004,d1
	beq		Draw_Character_Distant4
	cmpi.w	#$0005,d1
	beq		Draw_Character_Distant5
	tst.b	-$0019(a3)
	bmi.s	Draw_Character_BeginPartLoop
	cmpi.w	#$0003,d1
	bcc.s	Draw_Character_BeginPartLoop
	bsr		RandomGen_BytewithOffset
	move.b	d0,d1
	and.w	#$000C,d1
	bne.s	Draw_Character_BeginPartLoop
	and.w	#$0003,d0
	beq.s	Draw_Character_BeginPartLoop
	subq.w	#$02,d0
	add.b	$0005(sp),d0
	move.b	d0,$0005(sp)
Draw_Character_BeginPartLoop:		; Memory Address ($A876) and binary offset [$A4F2]
	moveq	#$00,d0
Draw_Character_PartLoop:		; Memory Address ($A878) and binary offset [$A4F4]
	; Runs the five-part near-character draw loop for legs, torso, head, and arms.
	move.w	d0,-(sp)
	bsr		Draw_CharacterComponent
	move.w	(sp)+,d0
	addq.w	#$01,d0
	cmpi.w	#$0005,d0
	bcs.s	Draw_Character_PartLoop
	add.w	#$0012,sp
	rts		

Character_BodyDefinitions:		; Memory Address ($A88E) and binary offset [$A50A]
	; Fourteen 10-byte records containing a layout selector and BodyParts.gfx bases
	; for legs, torso, arms and the distant composite.
	INCBIN "/data/BLOODWYCH439-clean/data/characters-body-definitions.layout"
CharacterHeadSel:		; Memory Address ($A91A) and binary offset [$A596]
	INCBIN "/data/BLOODWYCH439-clean/data/characters.heads"
Character_RenderTableOffsets:		; Memory Address ($A970) and binary offset [$A5EC]
	; Interleaved five-entry lookup containing the height-table and
	; graphics-source-table offsets for each rendered character part.
	INCBIN "/data/BLOODWYCH439-clean/data/characters-render-table-offsets.lookup"
Character_PartFacingVariants:		; Memory Address ($A984) and binary offset [$A600]
	; Five parts × four facings; bit 7 means mirror and $FF suppresses that part.
	INCBIN "/data/BLOODWYCH439-clean/data/characters-part-variants.lookup"

Draw_CharacterComponent:		; Memory Address ($A998) and binary offset [$A614]
	; Draws one character component by selecting its distance, facing and animation
	; variant, resolving its height and graphics source, applying its colour mask,
	; and positioning or mirroring the 16-pixel strip.
	move.w	d0,d2
	asl.w	#$02,d2
	move.w	Character_RenderTableOffsets(pc,d2.w),d1
	move.w	Character_RenderTableOffsets+$02(pc,d2.w),d3
	move.l	$0010(sp),a0
	lea		$00(a0,d1.w),a1
	lea		$00(a0,d3.w),a2
	add.w	$000E(sp),a0
	add.w	$0006(sp),d2
	moveq	#$00,d6
	move.b	Character_PartFacingVariants(pc,d2.w),d2
	bpl.s	Draw_CharacterComponent_CheckSuppressed
	subq.w	#$01,d6
Draw_CharacterComponent_CheckSuppressed:		; Memory Address ($A9C2) and binary offset [$A63E]
	cmpi.b	#$FF,d2
	bne.s	Draw_CharacterComponent_CheckArmAnimation
	rts		

Draw_CharacterComponent_CheckArmAnimation:		; Memory Address ($A9CA) and binary offset [$A646]
	cmpi.w	#$0003,d0
	bcs.s	Draw_CharacterComponent_ResolveFrameIndex
	move.w	d0,d1
	subq.w	#$03,d1
	btst	d1,-$0015(a3)
	beq.s	Draw_CharacterComponent_ResolveFrameIndex
	moveq	#$02,d2
Draw_CharacterComponent_ResolveFrameIndex:		; Memory Address ($A9DC) and binary offset [$A658]
	and.w	#$007F,d2
	move.w	$0008(sp),d1
	add.w	d1,d1
	add.w	$0008(sp),d1
	add.w	d1,d2
	moveq	#$00,d7
	move.b	$00(a1,d2.w),d7
	add.w	d2,d2
	moveq	#$00,d1
	move.w	$00(a2,d2.w),d1
	cmpi.w	#$0002,d0
	bne.s	Draw_CharacterComponent_ClampGroupIndex
	move.b	-$0018(a3),d0
	mulu	#$0378,d0
	lea		$FFFFC190.l,a1
	add.w	d0,d1
	add.w	d1,a1
	bra.s	Draw_CharacterComponent_PartOffsetAndColourGroup

Draw_CharacterComponent_ClampGroupIndex:		; Memory Address ($AA14) and binary offset [$A690]
	bcs.s	Draw_CharacterComponent_LoadGroupOffset
	moveq	#$02,d0
Draw_CharacterComponent_LoadGroupOffset:		; Memory Address ($AA18) and binary offset [$A694]
	move.l	$0014(sp),a1
	add.w	d0,d0
	add.w	$00(a1,d0.w),d1
	move.l	d1,a1
Draw_CharacterComponent_PartOffsetAndColourGroup:		; Memory Address ($AA24) and binary offset [$A6A0]
	; Loads one character part's X/Y placement and selects its colour group before
	; drawing the component.
	move.w	$000C(sp),d5
	move.w	$000A(sp),d4
	move.w	$0004(sp),d0
	add.w	d0,d0
	add.b	$00(a0,d0.w),d4
	add.b	$01(a0,d0.w),d5
	lea		CharacterPart_DefaultColourMaskTable.l,a6
	cmpi.w	#$0004,d0
	bcs.s	Draw_CharacterComponent_ColourGroupContinue
	bne.s	Draw_CharacterComponent_CheckArmAnimFlag
	moveq	#$00,d0
	bra		CharacterComponent_ColourOffset_SharedTail

Draw_CharacterComponent_CheckArmAnimFlag:		; Memory Address ($AA4E) and binary offset [$A6CA]
	move.w	$0004(sp),d1
	subq.w	#$03,d1
	btst	d1,-$0015(a3)
	beq.s	Draw_CharacterComponent_ArmColourGroup
	move.w	$0008(sp),d1
	subq.w	#$06,d0
	add.w	d0,d0
	lea		Character_ArmAnimationPositions.l,a0
	cmp.l	#Character_RenderLayout_Alternate,$0010(sp)
	bne.s	Draw_CharacterComponent_ApplyArmAnimOffset
	add.w	#$0024,a0
Draw_CharacterComponent_ApplyArmAnimOffset:		; Memory Address ($AA76) and binary offset [$A6F2]
	sub.b	$00(a0,d1.w),d5
	addq.w	#$04,a0
	asl.w	#$03,d1
	add.w	$0006(sp),d1
	add.w	d1,d0
	add.b	$00(a0,d0.w),d4
	btst	#$00,d1
	beq.s	Draw_CharacterComponent_ArmColourGroup
	not.w	d6
Draw_CharacterComponent_ArmColourGroup:		; Memory Address ($AA90) and binary offset [$A70C]
	; Selects the arm-specific colour group before the shared material-tier mask
	; lookup.
	moveq	#$04,d0
Draw_CharacterComponent_ColourGroupContinue:		; Memory Address ($AA92) and binary offset [$A70E]
	; Reads the shared colour-group/material index used to recolour the selected
	; character component.
	moveq	#$00,d1
	move.b	-$001C(a3),d1
	beq		CharacterComponent_NoArmourColourOverride
	subq.b	#$01,d1
	move.b	d1,d2
	asl.b	#$03,d1
	add.b	d2,d1
	asl.b	#$02,d1
	move.l	$0014(sp),a6
	addq.w	#$08,d1
	tst.w	-$0002(a6)
	bne.s	CharacterComponent_ArmourColourMaskLookup
	subq.w	#$04,d1
	cmp.w	#$2BE0,(a6)
	bne.s	CharacterComponent_ArmourColourMaskLookup
	subq.w	#$04,d1
CharacterComponent_ArmourColourMaskLookup:		; Memory Address ($AABC) and binary offset [$A738]
	lea		Character_ArmourColourMask_Table.l,a0
	add.w	d1,a0
	move.w	d0,d1
	add.w	d1,d1
	add.w	d0,d1
	add.w	d1,d1
	cmp.b	#$FF,$00(a0,d1.w)
	beq.s	CharacterComponent_NoArmourColourOverride
	bsr.s	Prepare_CharacterComponentColourMask
	bra.s	Draw_CharacterComponent_DispatchStripDraw

CharacterComponent_NoArmourColourOverride:		; Memory Address ($AAD8) and binary offset [$A754]
	add.w	d0,d0
	addq.w	#$04,d0
CharacterComponent_ColourOffset_SharedTail:		; Memory Address ($AADC) and binary offset [$A758]
	moveq	#$00,d1
	move.b	-$0017(a3),d1
	asl.w	#$02,d1
	moveq	#$00,d2
	move.b	-$0017(a3),d2
	add.w	d2,d1
	asl.w	#$02,d1
	add.w	d1,d0
	lea		CharacterColours.l,a6
	add.w	d0,a6
Draw_CharacterComponent_DispatchStripDraw:		; Memory Address ($AAF8) and binary offset [$A774]
	bra		Draw_Monster_16PixelStrip_FromBodies

Character_ArmAnimationPositions:		; Memory Address ($AAFC) and binary offset [$A778]
	; Standard and alternate animated-arm Y corrections and facing-specific X
	; corrections.
	INCBIN "/data/BLOODWYCH439-clean/data/characters-arm-animation.positions"

Prepare_CharacterComponentColourMask:		; Memory Address ($AB44) and binary offset [$A7C0]
	; Builds a character-component colour mask and applies worn-armour material and
	; character-specific palette substitutions.
	lea		Buffer_Colour_Mask.l,a6
	move.l	$00(a0,d1.w),(a6)
	move.b	-$001C(a3),d1
	rol.b	#$02,d1
	and.w	#$0003,d1
	beq.s	PrepareColourMask_RaceColourSetup
	move.b	Character_ArmourMaterial_PalettePairEnds(pc,d1.w),d1
	moveq	#$03,d2
PrepareColourMask_MaterialTintLoop:		; Memory Address ($AB60) and binary offset [$A7DC]
	move.b	d1,d3
	cmp.b	#$04,$00(a6,d2.w)
	beq.s	PrepareColourMask_WriteMaterialTint
	subq.b	#$01,d3
	cmp.b	#$03,$00(a6,d2.w)
	bne.s	PrepareColourMask_MaterialTintLoop_Next
PrepareColourMask_WriteMaterialTint:		; Memory Address ($AB74) and binary offset [$A7F0]
	move.b	d3,$00(a6,d2.w)
PrepareColourMask_MaterialTintLoop_Next:		; Memory Address ($AB78) and binary offset [$A7F4]
	dbra	d2,PrepareColourMask_MaterialTintLoop
PrepareColourMask_RaceColourSetup:		; Memory Address ($AB7C) and binary offset [$A7F8]
	lea		Character_ArmourRaceColour_Table.l,a0
	move.b	-$0018(a3),d1
	asl.w	#$02,d1
	add.w	d1,a0
	moveq	#$03,d2
PrepareColourMask_RaceTintLoop:		; Memory Address ($AB8C) and binary offset [$A808]
	move.b	$00(a6,d2.w),d1
	bpl.s	PrepareColourMask_RaceTintLoop_Next
	and.w	#$0003,d1
	move.b	$00(a0,d1.w),$00(a6,d2.w)
PrepareColourMask_RaceTintLoop_Next:		; Memory Address ($AB9C) and binary offset [$A818]
	dbra	d2,PrepareColourMask_RaceTintLoop
	rts		

Character_ArmourMaterial_PalettePairEnds:		; Memory Address ($ABA2) and binary offset [$A81E]
	; Maps ordinary, Mithril, Adamant and Crystal armour material codes to the
	; brighter palette index of each adjacent dark/light colour pair.
	INCBIN "/data/BLOODWYCH439-clean/data/characters-armour-material.palette"
Character_ArmourColourMask_Table:		; Memory Address ($ABA6) and binary offset [$A822]
	dc.b	$0B	;0B
	dc.b	$0A	;0A
	dc.b	$09	;09
	dc.b	$0B	;0B
	dc.b	$09	;09
	dc.b	$0A	;0A
	dc.b	$0B	;0B
	dc.b	$00	;00
	dc.b	$82	;82
	dc.b	$83	;83
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$0B	;0B
	dc.b	$0A	;0A
	dc.b	$09	;09
	dc.b	$0B	;0B
	dc.b	$09	;09
	dc.b	$0A	;0A
	dc.b	$0B	;0B
	dc.b	$81	;81
	dc.b	$09	;09
	dc.b	$0A	;0A
	dc.b	$0B	;0B
	dc.b	$00	;00
	dc.b	$81	;81
	dc.b	$09	;09
	dc.b	$0A	;0A
	dc.b	$0B	;0B
	dc.b	$80	;80
	dc.b	$09	;09
	dc.b	$0A	;0A
	dc.b	$0B	;0B
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$0E	;0E
	dc.b	$04	;04
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$82	;82
	dc.b	$04	;04
	dc.b	$02	;02
	dc.b	$83	;83
	dc.b	$82	;82
	dc.b	$04	;04
	dc.b	$83	;83
	dc.b	$0C	;0C
	dc.b	$0E	;0E
	dc.b	$04	;04
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$81	;81
	dc.b	$04	;04
	dc.b	$02	;02
	dc.b	$80	;80
	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$0E	;0E
	dc.b	$00	;00
	dc.b	$81	;81
	dc.b	$02	;02
	dc.b	$04	;04
	dc.b	$0E	;0E
	dc.b	$80	;80
	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$0E	;0E
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$0E	;0E
	dc.b	$04	;04
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$82	;82
	dc.b	$04	;04
	dc.b	$04	;04
	dc.b	$83	;83
CharacterPart_DefaultColourMaskTable:		; Memory Address ($ABF6) and binary offset [$A872]
	; Base of four-byte planar recolour masks; the wound-flash digit path uses its
	; leading identity mask.
	dc.b	$00	;00
	dc.b	$04	;04
	dc.b	$08	;08
	dc.b	$0C	;0C
	dc.b	$0E	;0E
	dc.b	$04	;04
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$81	;81
	dc.b	$04	;04
	dc.b	$04	;04
	dc.b	$80	;80
	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$0E	;0E
	dc.b	$00	;00
	dc.b	$81	;81
	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$0E	;0E
	dc.b	$80	;80
	dc.b	$02	;02
	dc.b	$04	;04
	dc.b	$0E	;0E
	dc.b	$0B	;0B
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$04	;04
Character_ArmourRaceColour_Table:		; Memory Address ($AC12) and binary offset [$A88E]
	dc.b	$0B	;0B
	dc.b	$0A	;0A
	dc.b	$07	;07
	dc.b	$08	;08
	dc.b	$06	;06
	dc.b	$05	;05
	dc.b	$0B	;0B
	dc.b	$0D	;0D
	dc.b	$0B	;0B
	dc.b	$0A	;0A
	dc.b	$09	;09
	dc.b	$0C	;0C
	dc.b	$06	;06
	dc.b	$05	;05
	dc.b	$05	;05
	dc.b	$06	;06
	dc.b	$0B	;0B
	dc.b	$0A	;0A
	dc.b	$09	;09
	dc.b	$0C	;0C
	dc.b	$0E	;0E
	dc.b	$00	;00
	dc.b	$0B	;0B
	dc.b	$0D	;0D
	dc.b	$0B	;0B
	dc.b	$0A	;0A
	dc.b	$05	;05
	dc.b	$06	;06
	dc.b	$0B	;0B
	dc.b	$0A	;0A
	dc.b	$07	;07
	dc.b	$08	;08
	dc.b	$0B	;0B
	dc.b	$0A	;0A
	dc.b	$0B	;0B
	dc.b	$0D	;0D
	dc.b	$0B	;0B
	dc.b	$0A	;0A
	dc.b	$05	;05
	dc.b	$06	;06
	dc.b	$0B	;0B
	dc.b	$0A	;0A
	dc.b	$09	;09
	dc.b	$0C	;0C
	dc.b	$0B	;0B
	dc.b	$0A	;0A
	dc.b	$05	;05
	dc.b	$06	;06
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$07	;07
	dc.b	$08	;08
	dc.b	$09	;09
	dc.b	$00	;00
	dc.b	$07	;07
	dc.b	$08	;08
	dc.b	$09	;09
	dc.b	$00	;00
	dc.b	$09	;09
	dc.b	$0C	;0C
	dc.b	$08	;08
	dc.b	$04	;04
	dc.b	$04	;04
	dc.b	$04	;04
DistantCharacter_FrontColourMaskTable:		; Memory Address ($AC52) and binary offset [$A8CE]
	; Four-byte colour masks selected for distant front-facing character components
	; before armour and race substitutions.
	dc.b	$0B	;0B
	dc.b	$0A	;0A
	dc.b	$0B	;0B
	dc.b	$0D	;0D
	dc.b	$81	;81
	dc.b	$0A	;0A
	dc.b	$09	;09
	dc.b	$09	;09
	dc.b	$81	;81
	dc.b	$02	;02
	dc.b	$04	;04
	dc.b	$82	;82
DistantCharacter_SideColourMaskTable:		; Memory Address ($AC5E) and binary offset [$A8DA]
	; Four-byte colour masks selected for distant side-facing character components
	; before armour and race substitutions.
	dc.b	$81	;81
	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$82	;82
	dc.b	$82	;82
	dc.b	$09	;09
	dc.b	$80	;80
	dc.b	$0A	;0A
	dc.b	$82	;82
	dc.b	$04	;04
	dc.b	$80	;80
	dc.b	$0E	;0E
	dc.b	$00	;00
	dc.b	$04	;04
	dc.b	$80	;80
	dc.b	$0C	;0C

Draw_Character_Distant4:		; Memory Address ($AC6E) and binary offset [$A8EA]
	; Draws the character's single-sprite portrait for distance class 4.
	move.w	-$0002(a0),-(sp)
	moveq	#$00,d3
	move.w	$0006(a0),d3
	tst.w	(sp)
	beq.s	Draw_CharacterDistant4_StandardPositions
	moveq	#$14,d7
	move.w	#$00A8,d2
	lea		Character_Distant4_Positions_Alternate.l,a0
	bra		DistantCharacter_PositionOffset_SharedTail

Draw_CharacterDistant4_StandardPositions:		; Memory Address ($AC8C) and binary offset [$A908]
	moveq	#$15,d7
	move.w	#$00B0,d2
	lea		Character_Distant4_Positions_Standard.l,a0
	bra		DistantCharacter_PositionOffset_SharedTail

Draw_Character_Distant5:		; Memory Address ($AC9C) and binary offset [$A918]
	; Draws the character's single-sprite portrait for distance class 5.
	move.w	-$0002(a0),-(sp)
	moveq	#$00,d3
	move.w	$0006(a0),d3
	tst.w	(sp)
	beq.s	Draw_CharacterDistant5_StandardPositions
	moveq	#$0F,d7
	move.w	#$0080,d2
	lea		Character_Distant5_Positions_Alternate.l,a0
	add.w	#$01F8,d3
	bra.s	DistantCharacter_PositionOffset_SharedTail

Draw_CharacterDistant5_StandardPositions:		; Memory Address ($ACBC) and binary offset [$A938]
	moveq	#$10,d7
	move.w	#$0088,d2
	lea		Character_Distant5_Positions_Standard.l,a0
	add.w	#$0210,d3
DistantCharacter_PositionOffset_SharedTail:		; Memory Address ($ACCC) and binary offset [$A948]
	move.l	d3,a1
	add.w	d0,d0
	add.b	$00(a0,d0.w),d4
	add.b	$01(a0,d0.w),d5
	moveq	#$00,d6
	cmpi.w	#$0006,d0
	bne.s	DistantCharacter_ScalePositionOffset
	subq.w	#$01,d6
	subq.w	#$04,d0
DistantCharacter_ScalePositionOffset:		; Memory Address ($ACE4) and binary offset [$A960]
	lsr.w	#$01,d0
	mulu	d0,d2
	add.w	d2,a1
	moveq	#$00,d1
	move.b	-$001C(a3),d1
	beq.s	DistantCharacter_DefaultColourTable
	and.w	#$0003,d1
	asl.w	#$02,d1
	lea		DistantCharacter_FrontColourMaskTable.l,a0
	tst.w	(sp)
	beq.s	DistantCharacter_PrepareColourMask
	lea		DistantCharacter_SideColourMaskTable.l,a0
DistantCharacter_PrepareColourMask:		; Memory Address ($AD08) and binary offset [$A984]
	bsr		Prepare_CharacterComponentColourMask
	bra.s	DistantCharacter_DrawStrip_SharedTail

DistantCharacter_DefaultColourTable:		; Memory Address ($AD0E) and binary offset [$A98A]
	move.b	-$0017(a3),d1
	asl.w	#$02,d1
	moveq	#$00,d0
	move.b	-$0017(a3),d0
	add.w	d0,d1
	asl.w	#$02,d1
	lea		CharacterColours+$10.l,a6
	add.w	d1,a6
DistantCharacter_DrawStrip_SharedTail:		; Memory Address ($AD26) and binary offset [$A9A2]
	bsr.s	Draw_Monster_16PixelStrip_FromBodies
	add.w	#$0014,sp
	rts		

Draw_Monster_16PixelStrip_FromBodies:		; Memory Address ($AD2E) and binary offset [$A9AA]
	; Adds the Bodies graphics base to a relative source offset and enters the
	; shared monster-strip blitter.
	add.l	#GFX_BodyParts,a1													;Long Addr replaced with Symbol
Draw_Monster_16PixelStrip:		; Memory Address ($AD34) and binary offset [$A9B0]
	; Writes one 16-pixel planar monster strip into the dungeon viewport, applying
	; mirroring and colour substitution.
	move.w	d5,d0
	add.w	d7,d0
	sub.w	MonsterStrip_BottomY.l,d0
	bcs.s	MonsterStrip_AfterBottomYClip
	sub.w	d0,d7
MonsterStrip_AfterBottomYClip:		; Memory Address ($AD42) and binary offset [$A9BE]
	swap	d7
	move.b	d4,d7
	ext.w	d7
	move.l	-$0008(a3),a0
	mulu	#$0028,d5
	and.w	#$FFF0,d7
	asr.w	#$03,d7
	add.w	d7,d5
	add.w	d5,a0
	asr.w	#$01,d7
	move.l	a3,-(sp)
	bsr.s	Draw_MonsterStrip_Shifted
	move.l	(sp)+,a3
	rts		

MonsterStrip_BottomY:		; Memory Address ($AD64) and binary offset [$A9E0]
	; Mutable lower Y clipping boundary used by the 16-pixel monster-strip
	; renderer.
	dc.w	$004B	;004B

Reverse_PlanarLongwordBits:		; Memory Address ($AD66) and binary offset [$A9E2]
	; Loads the byte-reversal lookup and reverses all 32 bits of a planar source
	; longword.
	lea		BitReverse_LookupBuffer.l,a6
Reverse_PlanarLongwordBits_WithLookup:		; Memory Address ($AD6C) and binary offset [$A9E8]
	; Reverses a planar source longword using four byte lookups when the lookup
	; base is already loaded.
	moveq	#$00,d2
	move.b	d0,d2
	move.b	$00(a6,d2.w),d0
	ror.w	#$08,d0
	move.b	d0,d2
	move.b	$00(a6,d2.w),d0
	swap	d0
	move.b	d0,d2
	move.b	$00(a6,d2.w),d0
	ror.w	#$08,d0
	move.b	d0,d2
	move.b	$00(a6,d2.w),d0
	swap	d0
	rts		

Draw_MonsterStrip_Shifted:		; Memory Address ($AD90) and binary offset [$AA0C]
	; Shifts, clips, mirrors when requested, recolours, and merges a monster strip
	; into the dungeon viewport.
	and.w	#$000F,d4
	swap	d6
	move.w	d7,d6
	moveq	#-$01,d5
	lsr.w	d4,d5
	move.w	d5,d0
	swap	d5
	move.w	d0,d5
	swap	d7
Draw_MonsterStrip_Shifted_RowLoop:		; Memory Address ($ADA4) and binary offset [$AA20]
	swap	d7
	move.w	d6,d7
	move.l	(a1)+,d0
	move.l	(a1)+,d1
	tst.l	d6
	bpl.s	Draw_MonsterStrip_Shifted_AfterMirror
	move.l	a6,a2
	bsr.s	Reverse_PlanarLongwordBits
	exg		d0,d1
	bsr.s	Reverse_PlanarLongwordBits_WithLookup
	exg		d0,d1
	move.l	a2,a6
Draw_MonsterStrip_Shifted_AfterMirror:		; Memory Address ($ADBC) and binary offset [$AA38]
	ror.l	d4,d0
	ror.l	d4,d1
	move.l	d0,a2
	move.l	d1,a3
	and.l	d5,d0
	and.l	d5,d1
	not.l	d5
	or.l	d5,d0
	or.l	d5,d1
	bsr		Composite_PlanarSpriteWord_IfVisible
	addq.w	#$01,d7
	move.l	a2,d0
	move.l	a3,d1
	and.l	d5,d0
	and.l	d5,d1
	not.l	d5
	or.l	d5,d0
	or.l	d5,d1
	swap	d0
	swap	d1
	move.l	d0,d2
	and.l	d1,d2
	addq.l	#$01,d2
	bne.s	Merge_ShiftedSpriteTrailingWord
	addq.w	#$02,a0
	bra.s	Advance_ShiftedSpriteRow

Merge_ShiftedSpriteTrailingWord:		; Memory Address ($ADF2) and binary offset [$AA6E]
	bsr		Composite_PlanarSpriteWord_IfVisible
Advance_ShiftedSpriteRow:		; Memory Address ($ADF6) and binary offset [$AA72]
	add.w	#$0024,a0
	swap	d7
	dbra	d7,Draw_MonsterStrip_Shifted_RowLoop
	rts		

Merge_PlanarSpriteWord_IfVisible:		; Memory Address ($AE02) and binary offset [$AA7E]
	; Skips destination word columns outside the eight-word dungeon viewport and
	; otherwise enters the transparent four-plane word merger.
	cmpi.w	#$0008,d6
	bcc.s	Skip_ClippedPlanarSpriteWord
	bra.s	Merge_PlanarSpriteWord

Composite_PlanarSpriteWord_IfVisible:		; Memory Address ($AE0A) and binary offset [$AA86]
	; Skips horizontally clipped words and otherwise recolours and merges one
	; planar sprite word.
	cmpi.w	#$0008,d7
	bcc.s	Skip_ClippedPlanarSpriteWord
	bsr		Remap_PlanarSpriteColours
Merge_PlanarSpriteWord:		; Memory Address ($AE14) and binary offset [$AA90]
	; Builds the transparent-pixel mask and merges one sprite word into all four
	; destination bitplanes.
	move.l	d1,d2
	and.l	d0,d2
	swap	d2
	and.l	d0,d2
	and.l	d1,d2
	not.l	d2
	and.l	d2,d0
	and.l	d2,d1
	not.l	d2
	move.w	$5DC0(a0),d3
	and.w	d2,d3
	or.w	d1,d3
	move.w	d3,$5DC0(a0)
	swap	d1
	move.w	$3E80(a0),d3
	and.w	d2,d3
	or.w	d1,d3
	move.w	d3,$3E80(a0)
	move.w	$1F40(a0),d3
	and.w	d2,d3
	or.w	d0,d3
	move.w	d3,$1F40(a0)
	swap	d0
	move.w	(a0),d3
	and.w	d2,d3
	or.w	d0,d3
	move.w	d3,(a0)+
	rts		

Skip_ClippedPlanarSpriteWord:		; Memory Address ($AE58) and binary offset [$AAD4]
	addq.w	#$02,a0
	rts		

PlanarSprite_ReverseRowOrderFlag:		; Memory Address ($AE5C) and binary offset [$AAD8]
	ds.b	$2
Draw_PlanarSprite_Normal:		; Memory Address ($AE5E) and binary offset [$AADA]
	; Initialises and draws an ordinary aligned or shifted planar sprite into the
	; screen bitplanes.
	clr.w	PlanarSprite_ReverseRowOrderFlag.l
	bra.s	Draw_PlanarSprite_Normal_Setup

Draw_PlanarSprite_RowsReversed:		; Memory Address ($AE66) and binary offset [$AAE2]
	; Selects reverse source-row traversal before the normal aligned/shifted sprite
	; setup; horizontal bit reversal is handled later.
	move.w	#$FFFF,PlanarSprite_ReverseRowOrderFlag.l
Draw_PlanarSprite_Normal_Setup:		; Memory Address ($AE6E) and binary offset [$AAEA]
	; Calculates the destination address and horizontal shift before entering the
	; normal planar sprite loops.
	move.w	d4,d1
	and.w	#$FFF7,d4
	bsr		BW_xy_to_offset
	move.w	d1,d4
	move.l	screen_ptr.l,a0
	add.w	d0,a0
	and.w	#$000F,d4
	moveq	#-$01,d5
	lsr.w	d4,d5
	move.w	d5,d0
	swap	d5
	move.w	d0,d5
	not.l	d5
	lea		Buffer_Colour_Mask.l,a6
Draw_PlanarSprite_Normal_RowLoop:		; Memory Address ($AE98) and binary offset [$AB14]
	swap	d7
	move.w	d6,-(sp)
	move.w	d7,-(sp)
	move.l	d5,d2
	move.l	d5,d3
Draw_PlanarSprite_Normal_WordLoop:		; Memory Address ($AEA2) and binary offset [$AB1E]
	move.l	(a1)+,d0
	move.l	(a1)+,d1
	tst.w	Buffer_Colour_Mask_Toggle.l
	beq.s	Draw_PlanarSprite_Normal_AfterColourRemap
	bsr		Remap_PlanarSpriteColours
Draw_PlanarSprite_Normal_AfterColourRemap:		; Memory Address ($AEB2) and binary offset [$AB2E]
	ror.l	d4,d0
	ror.l	d4,d1
	move.l	d0,a2
	move.l	d1,a3
	not.l	d5
	and.l	d5,d0
	and.l	d5,d1
	not.l	d5
	or.l	d2,d0
	or.l	d3,d1
	bsr		Merge_PlanarSpriteWord_IfVisible
	addq.w	#$01,d6
	move.l	a2,d2
	move.l	a3,d3
	and.l	d5,d2
	and.l	d5,d3
	swap	d2
	swap	d3
	dbra	d7,Draw_PlanarSprite_Normal_WordLoop
	move.w	(sp)+,d7
	not.l	d5
	or.l	d5,d2
	or.l	d5,d3
	not.l	d5
	move.l	d2,d0
	move.l	d3,d1
	and.l	d3,d2
	addq.l	#$01,d2
	bne.s	Merge_NormalSpriteTrailingWord
	addq.w	#$02,a0
	bra.s	Advance_NormalSpriteRow

Merge_NormalSpriteTrailingWord:		; Memory Address ($AEF4) and binary offset [$AB70]
	bsr		Merge_PlanarSpriteWord_IfVisible
Advance_NormalSpriteRow:		; Memory Address ($AEF8) and binary offset [$AB74]
	move.w	d7,d0
	add.w	d0,d0
	tst.w	PlanarSprite_ReverseRowOrderFlag.l
	beq.s	Advance_NormalSpriteDestinationRow
	add.w	#$0098,a1
	move.w	d0,d6
	asl.w	#$02,d6
	sub.w	d6,a1
Advance_NormalSpriteDestinationRow:		; Memory Address ($AF0E) and binary offset [$AB8A]
	lea		$0024(a0),a0
	sub.w	d0,a0
	move.w	(sp)+,d6
	swap	d7
	dbra	d7,Draw_PlanarSprite_Normal_RowLoop
	rts		

Draw_PlanarSprite_BitReversed:		; Memory Address ($AF1E) and binary offset [$AB9A]
	; Draws a horizontally reversed aligned or shifted planar sprite into the
	; screen bitplanes.
	move.w	d4,d1
	and.w	#$FFF7,d4
	bsr		BW_xy_to_offset
	move.w	d1,d4
	move.l	screen_ptr.l,a0
	add.w	d0,a0
	and.w	#$000F,d4
	moveq	#-$01,d5
	lsr.w	d4,d5
	move.w	d5,d0
	swap	d5
	move.w	d0,d5
	not.l	d5
Draw_PlanarSprite_BitReversed_RowLoop:		; Memory Address ($AF42) and binary offset [$ABBE]
	swap	d7
	move.w	d6,-(sp)
	move.w	d7,-(sp)
	move.w	d7,d2
	addq.w	#$01,d2
	asl.w	#$03,d2
	add.w	d2,a1
	move.l	d5,d2
	move.l	d5,d3
Draw_PlanarSprite_BitReversed_WordLoop:		; Memory Address ($AF54) and binary offset [$ABD0]
	move.l	d2,a2
	move.l	-(a1),d0
	bsr		Reverse_PlanarLongwordBits
	move.l	d0,d1
	move.l	-(a1),d0
	bsr		Reverse_PlanarLongwordBits_WithLookup
	move.l	a2,d2
	lea		Buffer_Colour_Mask.l,a6
	bsr		Remap_PlanarSpriteColours
	ror.l	d4,d0
	ror.l	d4,d1
	move.l	d0,a2
	move.l	d1,a3
	not.l	d5
	and.l	d5,d0
	and.l	d5,d1
	not.l	d5
	or.l	d2,d0
	or.l	d3,d1
	bsr		Merge_PlanarSpriteWord_IfVisible
	addq.w	#$01,d6
	move.l	a2,d2
	move.l	a3,d3
	and.l	d5,d2
	and.l	d5,d3
	swap	d2
	swap	d3
	dbra	d7,Draw_PlanarSprite_BitReversed_WordLoop
	move.w	(sp)+,d7
	not.l	d5
	or.l	d5,d2
	or.l	d5,d3
	not.l	d5
	move.l	d2,d0
	move.l	d3,d1
	and.l	d3,d2
	addq.l	#$01,d2
	bne.s	Merge_BitReversedSpriteTrailingWord
	addq.w	#$02,a0
	bra.s	Advance_BitReversedSpriteRow

Merge_BitReversedSpriteTrailingWord:		; Memory Address ($AFB2) and binary offset [$AC2E]
	bsr		Merge_PlanarSpriteWord_IfVisible
Advance_BitReversedSpriteRow:		; Memory Address ($AFB6) and binary offset [$AC32]
	move.w	d7,d0
	addq.w	#$01,d0
	add.w	d0,d0
	lea		$0026(a0),a0
	sub.w	d0,a0
	asl.w	#$02,d0
	add.w	d0,a1
	move.w	(sp)+,d6
	swap	d7
	dbra	d7,Draw_PlanarSprite_BitReversed_RowLoop
	rts		

Remap_PlanarSpriteColours:		; Memory Address ($AFD0) and binary offset [$AC4C]
	; Remaps the planar source colour indices through the active four-byte
	; colour-mask table.
	movem.l	d2-d7,-(sp)
	move.l	d0,d2
	swap	d2
	or.l	d0,d2
	not.l	d2
	beq.s	Remap_PlanarSpriteColours_Exit
	move.l	d0,-(sp)
	moveq	#$00,d4
	moveq	#$00,d5
	move.w	d5,d7
	move.l	d1,d3
	swap	d3
	or.l	d1,d3
	not.l	d3
	and.l	d2,d3
	beq.s	Remap_PlanarSpriteColours_AfterColour0
	bsr.s	Accumulate_PlanarColourMask
Remap_PlanarSpriteColours_AfterColour0:		; Memory Address ($AFF4) and binary offset [$AC70]
	addq.w	#$01,d7
	move.l	d3,d0
	not.l	d0
	move.w	d1,d3
	swap	d3
	move.w	d1,d3
	not.l	d3
	and.l	d0,d3
	and.l	d2,d3
	beq.s	Remap_PlanarSpriteColours_AfterColour1
	bsr.s	Accumulate_PlanarColourMask
Remap_PlanarSpriteColours_AfterColour1:		; Memory Address ($B00A) and binary offset [$AC86]
	addq.w	#$01,d7
	move.l	d1,d3
	swap	d1
	move.w	d1,d3
	not.l	d3
	and.l	d0,d3
	and.l	d2,d3
	beq.s	Remap_PlanarSpriteColours_AfterColour2
	bsr.s	Accumulate_PlanarColourMask
Remap_PlanarSpriteColours_AfterColour2:		; Memory Address ($B01C) and binary offset [$AC98]
	addq.w	#$01,d7
	move.l	d1,d3
	swap	d1
	and.l	d1,d3
	and.l	d2,d3
	beq.s	Remap_PlanarSpriteColours_AfterColour3
	bsr.s	Accumulate_PlanarColourMask
Remap_PlanarSpriteColours_AfterColour3:		; Memory Address ($B02A) and binary offset [$ACA6]
	not.l	d2
	move.l	(sp)+,d0
	and.l	d2,d0
	or.l	d4,d0
	and.l	d2,d1
	or.l	d5,d1
Remap_PlanarSpriteColours_Exit:		; Memory Address ($B036) and binary offset [$ACB2]
	movem.l	(sp)+,d2-d7
	rts		

Accumulate_PlanarColourMask:		; Memory Address ($B03C) and binary offset [$ACB8]
	; Accumulates destination bitplane bits for one populated source-colour
	; combination.
	move.b	$00(a6,d7.w),d6
	beq.s	Accumulate_PlanarColourMask_SharedReturn
	add.w	d6,d6
	add.w	d6,d6
	and.w	#PlanarColourMask_IndexMask,d6										;Converts each two-bit destination colour pair into one of four longword plane masks.
	move.l	Bitplane_Mask(pc,d6.w),d6
	and.l	d3,d6
	or.l	d6,d4
	move.b	$00(a6,d7.w),d6
	and.w	#PlanarColourMask_IndexMask,d6										;Converts each two-bit destination colour pair into one of four longword plane masks.
	move.l	Bitplane_Mask(pc,d6.w),d6
	and.l	d3,d6
	or.l	d6,d5
Accumulate_PlanarColourMask_SharedReturn:		; Memory Address ($B062) and binary offset [$ACDE]
	rts		

Bitplane_Mask:		; Memory Address ($B064) and binary offset [$ACE0]
	; Four 32-bit plane-write masks selected by a two-bit colour value during
	; planar graphic composition.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Dungeon_BitplaneMasks.lookup"

Draw_MainWallFace_ByPatternParity:		; Memory Address ($B074) and binary offset [$ACF0]
	; Dispatches one main-wall face through the ordinary or
	; lookup-selected/bit-reversed path according to (player X + player Y + facing)
	; & 1.
	tst.w	-$000C(a3)
	bne		Draw_MainWallFace
	move.w	d6,d0
	bsr		Select_MainWallGraphicTables
	swap	d3
	move.l	a3,-(sp)
	bsr		Draw_WallComponent_Transformed
	move.l	(sp)+,a3
Draw_Main_Object_Overlay:		; Memory Address ($B08C) and binary offset [$AD08]
	; Draws the selected wall overlay and dispatches switch, sign, shelf, socket,
	; or other wall-feature artwork.
	tst.b	-$0015(a3)
	beq.s	Accumulate_PlanarColourMask_SharedReturn
	addq.b	#$01,-$0015(a3)
	beq		Draw_Main_Shelf_Overlay
	addq.b	#$01,-$0015(a3)
	beq		Draw_Main_Sign_Overlay
	addq.b	#$01,-$0015(a3)
	beq.s	Draw_Main_Switch_Overlay
	lea		GFX_Main_Slots_Offsets.l,a0
	lea		GFX_Main_Slots_Positions.l,a2
	lea		GFX_Slots.l,a1
	lea		GFX_Main_Slots_Palette.l,a6
	move.b	-$0012(a3),d1
	lsr.w	#$03,d1
	bsr		Load_WallOverlay_ColourMask
	btst	#$02,-$0012(a3)
	beq.s	Draw_Main_Slot_Overlay
	clr.b	d0
Draw_Main_Slot_Overlay:		; Memory Address ($B0D4) and binary offset [$AD50]
	; Applies the selected socket or lock-slot colour mask and draws the main-wall
	; slot component.
	move.l	d0,Buffer_Colour_Mask.l
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l
	bsr		Draw_WallComponentFace
	clr.w	Buffer_Colour_Mask_Toggle.l
	rts		

Draw_Main_Switch_Overlay:		; Memory Address ($B0EE) and binary offset [$AD6A]
	; Selects the main-wall switch graphic and builds its state-dependent colour
	; mask.
	lea		GFX_Main_Switches_Offsets.l,a0
	lea		GFX_Main_Switches_Positions.l,a2
	lea		GFX_Switches.l,a1
	moveq	#$00,d0
	move.b	-$0012(a3),d1
	and.w	#$00F8,d1
	beq.s	Draw_Main_Switch_Overlay_WithColourMask
	bsr		Select_MainSwitch_ColourMask
	btst	#$02,-$0012(a3)
	beq.s	Draw_Main_Switch_Overlay_WithColourMask
	and.w	#$00FF,d0
	swap	d0
	move.b	$02(a6,d1.w),d0
Draw_Main_Switch_Overlay_WithColourMask:		; Memory Address ($B122) and binary offset [$AD9E]
	; Applies the resolved switch-state colour mask and draws the main-wall switch
	; component.
	move.l	d0,Buffer_Colour_Mask.l
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l
	bsr		Draw_WallComponentFace
	clr.w	Buffer_Colour_Mask_Toggle.l
	rts		

Draw_Main_Sign_Overlay:		; Memory Address ($B13C) and binary offset [$ADB8]
	; Draws a recoloured wall sign followed by its directional generated-symbol
	; overlay when applicable.
	move.w	d6,-(sp)
	lea		GFX_Main_Sign_Offsets.l,a0
	lea		GFX_Main_Sign_Positions.l,a2
	lea		GFX_Sign.l,a1
	lea		GFX_Main_Sign_Colours.l,a6
	move.b	-$0012(a3),d1
	lsr.b	#$02,d1
	beq.s	Select_Main_Sign_MapColour
	cmpi.b	#$05,d1
	bcc.s	Select_Main_Sign_MapColour
	subq.b	#$01,d1
	bsr		Load_WallOverlay_ColourMask
	bra.s	Draw_Main_Sign_Base

Select_Main_Sign_MapColour:		; Memory Address ($B16C) and binary offset [$ADE8]
	; Falls back to a coordinate-derived colour for sign types without a fixed
	; colour entry.
	bsr.s	Calculate_WallOverlay_ColourIndex
Draw_Main_Sign_Base:		; Memory Address ($B16E) and binary offset [$ADEA]
	; Draws the recoloured sign base before selecting its directional sign-overlay
	; picture.
	move.l	d0,Buffer_Colour_Mask.l
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l
	bsr		Draw_WallComponentFace
	clr.w	Buffer_Colour_Mask_Toggle.l
	move.w	(sp)+,d6
	move.b	-$0012(a3),d1
	lsr.b	#$02,d1
	beq.s	Select_Main_SignOverlay_Direction
	cmpi.b	#$05,d1
	bcc.s	MainWallOverlay_SharedReturn
	subq.b	#$01,d1
	bra.s	Draw_Main_SignOverlay

Select_Main_SignOverlay_Direction:		; Memory Address ($B19A) and binary offset [$AE16]
	; Derives the generated sign-overlay direction from the map coordinates.
	move.b	-$0019(a3),d1
	add.w	d1,d1
	sub.b	-$001A(a3),d1
Draw_Main_SignOverlay:		; Memory Address ($B1A4) and binary offset [$AE20]
	; Selects and draws one of the four directional pictures from SignOverlay.gfx.
	and.w	#$0003,d1
	mulu	#$0610,d1
	lea		GFX_SignOverlay.l,a1
	add.w	d1,a1
	lea		GFX_Main_Signoverlay_Positions.l,a2
	lea		GFX_Main_Signoverlay_Offsets.l,a0
	bsr		Draw_WallComponentFace
MainWallOverlay_SharedReturn:		; Memory Address ($B1C4) and binary offset [$AE40]
	rts		

Select_MainSwitch_ColourMask:		; Memory Address ($B1C6) and binary offset [$AE42]
	; Selects the switch colour table before falling through to the
	; coordinate-derived colour-mask lookup.
	lea		GFX_Switches_Colours.l,a6
Calculate_WallOverlay_ColourIndex:		; Memory Address ($B1CC) and binary offset [$AE48]
	; Calculates map X plus map Y for generated signs, wall scrolls and non-zero
	; switch colour selection.
	move.b	-$0019(a3),d1
	add.b	-$001A(a3),d1
Load_WallOverlay_ColourMask:		; Memory Address ($B1D4) and binary offset [$AE50]
	; Masks the colour index to eight entries, multiplies it by four and loads the
	; selected four-byte colour mask.
	and.w	#WallOverlay_ColourIndexMask,d1										;Wraps coordinate-derived and fixed colour selections to the eight available masks.
	asl.w	#WallOverlay_ColourEntryShift,d1									;Converts the colour index into a byte offset for four-byte mask records.
	move.l	$00(a6,d1.w),d0
	rts		

Draw_Main_Shelf_Overlay:		; Memory Address ($B1E0) and binary offset [$AE5C]
	; Suppresses an occluded shelf where necessary and otherwise draws the
	; projected shelf component.
	tst.b	-$001F(a3)
	bne.s	Draw_Main_Shelf_Visible
	btst	#$03,-$0011(a3)														;In the normal player-view context, suppresses a shelf whose selected wall face is hidden by the current visibility mask.
	bne.s	MainWallOverlay_SharedReturn
Draw_Main_Shelf_Visible:		; Memory Address ($B1EE) and binary offset [$AE6A]
	; Loads the shelf graphics tables and draws the shelf when its wall-face
	; visibility conditions permit.
	lea		GFX_Main_Shelf_Offsets.l,a0
	lea		GFX_Main_Shelf_Positions.l,a2
	lea		GFX_Shelf.l,a1
	bra		Draw_WallComponentFace

GFX_Main_Slots_Palette:		; Memory Address ($B204) and binary offset [$AE80]
	; Supplies the colour selections.
	INCBIN "/data/BLOODWYCH439-clean/gfx/Main_Slots.colours"
GFX_Main_Slots_Offsets:		; Memory Address ($B224) and binary offset [$AEA0]
	; Selects individual socket pictures.
	INCBIN "/data/BLOODWYCH439-clean/gfx/Main_Slots.offsets"
GFX_Switches_Colours:		; Memory Address ($B244) and binary offset [$AEC0]
	; Eight four-byte colour masks used to recolour switch artwork according to
	; position and state.
	INCBIN "/data/BLOODWYCH439-clean/gfx/Switches.colours"
GFX_Main_Sign_Colours:		; Memory Address ($B264) and binary offset [$AEE0]
	; Eight four-byte colour masks used for fixed and coordinate-derived main-wall
	; sign colours.
	INCBIN "/data/BLOODWYCH439-clean/gfx/Main_Sign.colours"
GFX_Main_Signoverlay_Offsets:		; Memory Address ($B284) and binary offset [$AF00]
	; Sixteen big-endian offsets selecting directional pictures from
	; SignOverlay.gfx.
	INCBIN "/data/BLOODWYCH439-clean/gfx/Main_SignOverlay.offsets"

Draw_MainWallFace:		; Memory Address ($B2A4) and binary offset [$AF20]
	; Selects and draws one projected stone-wall face. Selects the parity-1
	; main-wall picture using GFX_Main_Wall_SpriteTable and draws it through the
	; bit-reversed path.
	moveq	#$00,d0
	move.b	GFX_Main_Wall_SpriteTable(pc,d6.w),d0
	bsr		Select_MainWallGraphicTables
	add.w	d3,a0
	swap	d3
	bsr		Draw_MainWall_Transformed
	bra		Draw_Main_Object_Overlay

GFX_Main_Wall_SpriteTable:		; Memory Address ($B2BA) and binary offset [$AF36]
	; Maps each of the 28 projected wall-face slots to a picture in Main_Walls.gfx.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Dungeon_MainWall_SpriteSelection.lookup"
Door_Lock_Colours:		; Memory Address ($B2D6) and binary offset [$AF52]
	; Eight recolour values selected from the door-state high nibble for
	; locked-door artwork.
	INCBIN "/data/BLOODWYCH439-clean/data/Door_Lock.colours"

Draw_Main_Door_Or_Stairs:		; Memory Address ($B2DE) and binary offset [$AF5A]
	; Applies the large-door lock mask and selects open, metal or portcullis
	; artwork, or dispatches the shared stairs path.
	cmp.b	#$01,-$0013(a3)
	beq		Draw_Main_Stairs
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l
	move.l	#$0004000C,Buffer_Colour_Mask.l										;Long Addr replaced with Symbol
	moveq	#$00,d0
	move.b	-$0012(a3),d0
	btst	#$03,d0
	bne.s	Select_Main_Door_Graphic
	lsr.b	#$04,d0
	move.b	Door_Lock_Colours(pc,d0.w),d0
	move.b	d0,Buffer_Colour_Mask+$02.l
Select_Main_Door_Graphic:		; Memory Address ($B312) and binary offset [$AF8E]
	; Selects open-door, metal-door, or portcullis artwork from the door-state
	; bits.
	lea		GFX_Door_Offsets.l,a0
	lea		GFX_Door_Positions.l,a2
	lea		GFX_Door_Open.l,a1
	btst	#$00,-$0012(a3)
	beq.s	Draw_Main_Door_ByViewCell
	lea		GFX_Door_Metal.l,a1
	btst	#$01,-$0012(a3)
	beq.s	Draw_Main_Door_ByViewCell
	lea		GFX_Door_PortCullis.l,a1
Draw_Main_Door_ByViewCell:		; Memory Address ($B340) and binary offset [$AFBC]
	; Chooses the side-face component path or centred two-half construction for the
	; current view cell.
	move.b	-$0016(a3),d6
	cmpi.b	#$0E,d6
	bcc.s	Draw_Main_Door_CentredFace
	bsr		Draw_CentredDungeonComponent
	bra.s	Draw_MainDoor_CheckOccupants_SharedTail

Draw_Main_Door_CentredFace:		; Memory Address ($B350) and binary offset [$AFCC]
	; Adjusts the centred door slot and orientation before constructing the door
	; from two reflected halves.
	move.w	d6,d0
	subq.w	#$07,d0
	cmpi.w	#$000B,d0
	bne.s	Draw_Main_Door_Centred_TwoHalves
	move.w	-$000A(a3),d1
	asl.w	#$02,d1
	eor.b	d1,-$0012(a3)
	btst	#$02,-$0012(a3)
	beq.s	Draw_Main_Door_Centred_TwoHalves
	addq.w	#$01,d6
	addq.w	#$01,d0
Draw_Main_Door_Centred_TwoHalves:		; Memory Address ($B370) and binary offset [$AFEC]
	; Draws a centred main door from its source half and reflected partner.
	bsr		Draw_WallComponent_TwoHalves
Draw_MainDoor_CheckOccupants_SharedTail:		; Memory Address ($B374) and binary offset [$AFF0]
	clr.w	Buffer_Colour_Mask_Toggle.l
	tst.b	-$0011(a3)
	bmi		Draw_DungeonCellOccupants
	rts		

Draw_Main_Stairs:		; Memory Address ($B384) and binary offset [$B000]
	; Selects ascending or descending stairs graphics, offsets, and projected
	; positions.
	lea		GFX_Stairs_Up.l,a1
	lea		GFX_Stairs_Up_Offsets.l,a0
	lea		GFX_Stairs_Up_Positions.l,a2
	btst	#$00,-$0012(a3)
	beq.s	Draw_Main_Stairs_ByViewCell
	lea		GFX_Stairs_Down.l,a1
	lea		GFX_Stairs_Down_Offsets.l,a0
	lea		GFX_Stairs_Down_Positions.l,a2
Draw_Main_Stairs_ByViewCell:		; Memory Address ($B3B0) and binary offset [$B02C]
	; Chooses the side-face path, suppresses the farthest central slot, or
	; constructs centred stairs from two halves.
	cmp.b	#$0E,-$0016(a3)
	bcs.s	Draw_Main_Stairs_SideFace
	beq.s	Draw_MainStairs_CheckOccupants_SharedTail
	move.b	-$0016(a3),d6
	move.w	d6,d0
	add.w	#$000A,d6
	subq.w	#$02,d0
	bsr		Draw_WallComponent_TwoHalves
	bra.s	Draw_MainStairs_CheckOccupants_SharedTail

Draw_Main_Stairs_SideFace:		; Memory Address ($B3CC) and binary offset [$B048]
	; Draws the complete stairs component for a side view cell.
	bsr.s	Draw_WallComponentFace
Draw_MainStairs_CheckOccupants_SharedTail:		; Memory Address ($B3CE) and binary offset [$B04A]
	tst.b	-$0011(a3)
	bmi		Draw_DungeonCellOccupants
	rts		

Draw_WoodenWallOrDoorFace:		; Memory Address ($B3D8) and binary offset [$B054]
	; Selects a solid wooden wall, open doorway frame and optional closed-door
	; overlay.
	lea		GFX_WoodenWalls.l,a1
	lea		GFX_Wooden_Wall_Offsets.l,a0
	lea		GFX_Wooden_Wall_Positions.l,a2
	tst.b	-$0014(a3)
	beq.s	Draw_Selected_WoodenWallOrDoorComponent
	add.w	#$2498,a1
	bsr.s	Draw_WallComponentFace
	tst.b	-$0015(a3)
	beq.s	Draw_WallComponentFace_SharedReturn
	lea		GFX_Wooden_Doors_Offsets.l,a0
	lea		GFX_Wooden_Doors_Positions.l,a2
	lea		GFX_WoodDoors.l,a1
Draw_Selected_WoodenWallOrDoorComponent:		; Memory Address ($B40E) and binary offset [$B08A]
	; Draws the selected solid wall, doorway frame, or closed wooden-door
	; component.
	nop		
Draw_WallComponentFace:		; Memory Address ($B410) and binary offset [$B08C]
	; Selects a wall-component picture and chooses its normal, mirrored or two-half
	; drawing path.
	moveq	#$00,d0
	move.b	GFX_WallComponent_SpriteMirrorTable(pc,d6.w),d0
	bmi.s	Flip_Sprite
	cmpi.b	#$0C,d0
	bcc		Draw_WallComponent_TwoHalves
	bsr.s	Prepare_WallSpriteDraw
	swap	d3
	move.l	a3,-(sp)
	bsr		Draw_WallSprite_Normal
	move.l	(sp)+,a3
Draw_WallComponentFace_SharedReturn:		; Memory Address ($B42C) and binary offset [$B0A8]
	rts		

Flip_Sprite:		; Memory Address ($B42E) and binary offset [$B0AA]
	; Clears the component mirror flag, resolves its geometry, and draws it through
	; the bit-reversed path.
	and.w	#WallSprite_IndexMask,d0											;Removes the mirror flag while retaining the component picture index.
	bsr.s	Prepare_WallSpriteDraw
	add.w	d3,a0
	swap	d3
	bra		Draw_WallSprite_BitReversed

GFX_WallComponent_SpriteMirrorTable:		; Memory Address ($B43C) and binary offset [$B0B8]
	; Maps the 28 wall-face slots to component pictures; bit 7 selects the
	; horizontally mirrored drawing path.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Dungeon_WallComponents.lookup"

Draw_WallComponent_TwoHalves:		; Memory Address ($B458) and binary offset [$B0D4]
	; Draws one source half and its reflected partner to construct a complete
	; central component.
	bsr.s	Prepare_WallSpriteDraw
	swap	d3
	movem.l	d1/d3/d5/a0/a1/a3,-(sp)
	bsr		Draw_WallSprite_Normal
	movem.l	(sp)+,d1/d3/d5/a0/a1/a3
	add.w	#$0010,a0
	add.w	d1,d1
	sub.w	d1,a0
	bra		Draw_WallSprite_BitReversed

Select_MainWallGraphicTables:		; Memory Address ($B474) and binary offset [$B0F0]
	; Selects the Main_Walls graphics, picture offsets and packed position tables.
	lea		GFX_Main_Walls_Positions.l,a2
	lea		GFX_Main_Walls_Offsets.l,a0
	lea		GFX_MainWalls.l,a1
Prepare_WallSpriteDraw:		; Memory Address ($B486) and binary offset [$B102]
	; Resolves a picture offset and packed position into source pointer,
	; destination pointer, width and height.
	add.w	d0,d0
	add.w	$00(a0,d0.w),a1
	move.w	d6,d0
	asl.w	#$02,d0
	add.w	d0,a2
	moveq	#$00,d1
	move.b	(a2)+,d1
	swap	d1
	move.b	(a2)+,d1
	move.w	d1,d0
	asl.w	#$02,d1
	add.w	d1,d0
	asl.w	#$03,d0
	swap	d1
	lsr.w	#$02,d1
	add.w	d1,d0
	move.l	-$0008(a3),a0
	add.w	d0,a0
	moveq	#$00,d5
	move.b	(a2)+,d5
	move.w	d5,d3
	swap	d5
	move.b	(a2),d5
	addq.w	#$01,d3
	add.w	d3,d3
	rts		

Buffer_Colour_Mask_Toggle:		; Memory Address ($B4BE) and binary offset [$B13A]
	ds.b	$2
Buffer_Colour_Mask:		; Memory Address ($B4C0) and binary offset [$B13C]
	dc.w	$0004	;0004
	dc.b	$08	;08
	dc.b	$0C	;0C
GFX_WallComponent_DrawTransformFlags:		; Memory Address ($B4C4) and binary offset [$B140]
	; Per-face transformation flags used by wall components, wooden walls, doors
	; and stairs. Bits 0 and 2 select edge passes; bit 1 selects the perspective
	; centre path.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Dungeon_WallComponent_DrawTransform.flags"

Draw_WallComponent_Transformed:		; Memory Address ($B4E0) and binary offset [$B15C]
	; Applies wall-component transformation flags and perspective trimming.
	lea		GFX_WallComponent_DrawTransformFlags.l,a2
	add.w	d6,a2
	btst	#$01,(a2)
	beq		Draw_WallSprite_Normal
	swap	d6
	btst	#$00,(a2)
	beq.s	WallComponentTransformed_PerspectiveTrim
	bsr.s	Draw_WallComponent_EdgeTransform
WallComponentTransformed_PerspectiveTrim:		; Memory Address ($B4FA) and binary offset [$B176]
	move.b	(a2),d6
	and.w	#WallTransform_FlagMask,d6											;Retains the edge and perspective controls used to index the component trim table.
	swap	d3
	moveq	#Screen_BitplaneRowBytes,d2											;Uses the forty-byte single-bitplane screen-row stride when advancing transformed component rows.
	sub.w	d3,d2
	swap	d3
	move.w	d5,d4
	swap	d5
	move.b	GFX_WallComponent_PerspectiveTrimLookup(pc,d6.w),d6
	sub.w	d6,d5
	add.w	d6,d6
	add.w	d6,d2
	movem.l	a0/a1,-(sp)
WallComponentTransformed_RowLoop:		; Memory Address ($B51A) and binary offset [$B196]
	move.w	d5,d3
WallComponentTransformed_ColumnLoop:		; Memory Address ($B51C) and binary offset [$B198]
	move.w	(a1)+,(a0)+
	move.w	(a1)+,$1F3E(a0)
	move.w	(a1)+,$3E7E(a0)
	move.w	(a1)+,$5DBE(a0)
	dbra	d3,WallComponentTransformed_ColumnLoop
	move.w	d6,d3
	asl.w	#$02,d3
	add.w	d3,a1
	add.w	d2,a0
	dbra	d4,WallComponentTransformed_RowLoop
	movem.l	(sp)+,a0/a1
	swap	d5
	swap	d3
	sub.w	d3,d6
	sub.w	d6,a0
	asl.w	#$02,d6
	sub.w	d6,a1
	swap	d3
	btst	#$02,(a2)
	beq.s	WallComponentTransformed_Finish
	bsr.s	Draw_WallComponent_EdgeTransform
WallComponentTransformed_Finish:		; Memory Address ($B554) and binary offset [$B1D0]
	swap	d6
	rts		

GFX_WallComponent_PerspectiveTrimLookup:		; Memory Address ($B558) and binary offset [$B1D4]
	; Maps the low three component-transform flag bits to zero, one or two source
	; word-columns trimmed during perspective drawing.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Dungeon_WallComponent_PerspectiveTrim.lookup"

Draw_WallComponent_EdgeTransform:		; Memory Address ($B560) and binary offset [$B1DC]
	; Draws the extra perspective edge pass for a wall component.
	movem.l	a0/a1,-(sp)
	swap	d3
	move.w	d3,d6
	subq.w	#$02,d6
	asl.w	#$02,d6
	swap	d3
	move.w	d5,d3
Draw_WallComponent_EdgeTransform_RowLoop:		; Memory Address ($B570) and binary offset [$B1EC]
	move.l	(a1)+,d0
	move.l	(a1)+,d1
	move.l	d1,d2
	and.l	d0,d2
	swap	d2
	and.l	d0,d2
	and.l	d1,d2
	not.l	d2
	and.l	d2,d0
	and.l	d2,d1
	not.l	d2
	move.w	$5DC0(a0),d4
	and.w	d2,d4
	or.w	d1,d4
	move.w	d4,$5DC0(a0)
	swap	d1
	move.w	$3E80(a0),d4
	and.w	d2,d4
	or.w	d1,d4
	move.w	d4,$3E80(a0)
	move.w	$1F40(a0),d4
	and.w	d2,d4
	or.w	d0,d4
	move.w	d4,$1F40(a0)
	swap	d0
	move.w	(a0),d4
	and.w	d2,d4
	or.w	d0,d4
	move.w	d4,(a0)+
	add.w	#$0026,a0
	add.w	d6,a1
	dbra	d3,Draw_WallComponent_EdgeTransform_RowLoop
	movem.l	(sp)+,a0/a1
	addq.w	#$02,a0
	addq.w	#$08,a1
	rts		

Draw_WallSprite_Normal:		; Memory Address ($B5CA) and binary offset [$B246]
	; Initialises the normal wall-sprite source-row stride before entering the
	; shared planar compositor.
	sub.w	a3,a3
Draw_WallSprite_Rows_Loop:		; Memory Address ($B5CC) and binary offset [$B248]
	; Iterates the source rows and words of an ordinary planar wall or wall-feature
	; sprite.
	swap	d5
	move.w	d5,d3
Draw_WallSprite_Normal_WordLoop:		; Memory Address ($B5D0) and binary offset [$B24C]
	move.l	(a1)+,d0
	move.l	(a1)+,d1
	tst.w	Buffer_Colour_Mask_Toggle.l
	beq.s	Composite_WallSprite_Row
	lea		Buffer_Colour_Mask.l,a6
	bsr		Remap_PlanarSpriteColours
Composite_WallSprite_Row:		; Memory Address ($B5E6) and binary offset [$B262]
	; Builds the transparency mask and merges one ordinary planar sprite word into
	; all four destination bitplanes.
	move.l	d1,d2
	and.l	d0,d2
	addq.l	#$01,d2
	beq.s	Draw_WallSprite_Normal_SkipTransparentWord
	subq.l	#$01,d2
	swap	d2
	and.l	d0,d2
	and.l	d1,d2
	not.l	d2
	and.l	d2,d0
	and.l	d2,d1
	not.l	d2
	move.w	$5DC0(a0),d4
	and.w	d2,d4
	or.w	d1,d4
	move.w	d4,$5DC0(a0)
	swap	d1
	move.w	$3E80(a0),d4
	and.w	d2,d4
	or.w	d1,d4
	move.w	d4,$3E80(a0)
	move.w	$1F40(a0),d4
	and.w	d2,d4
	or.w	d0,d4
	move.w	d4,$1F40(a0)
	swap	d0
	move.w	(a0),d4
	and.w	d2,d4
	or.w	d0,d4
	move.w	d4,(a0)+
	bra.s	Draw_WallSprite_Normal_WordLoop_Next

Draw_WallSprite_Normal_SkipTransparentWord:		; Memory Address ($B630) and binary offset [$B2AC]
	addq.w	#$02,a0
Draw_WallSprite_Normal_WordLoop_Next:		; Memory Address ($B632) and binary offset [$B2AE]
	dbra	d3,Draw_WallSprite_Normal_WordLoop
	swap	d3
	sub.w	d3,a0
	swap	d3
	add.w	#$0028,a0
	add.w	a3,a1
	swap	d5
	dbra	d5,Draw_WallSprite_Rows_Loop
	rts		

GFX_Main_Wall_DrawTransformFlags:		; Memory Address ($B64A) and binary offset [$B2C6]
	; Per-face transformation flags for stone-wall graphics. This differs from the
	; component table at wall-face slots 6 and 18.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Dungeon_MainWall_DrawTransform.flags"

Draw_MainWall_Transformed:		; Memory Address ($B666) and binary offset [$B2E2]
	; Applies main-wall transformation flags, horizontal bit reversal and
	; perspective trimming.
	lea		GFX_Main_Wall_DrawTransformFlags.l,a2
	add.w	d6,a2
	btst	#$01,(a2)
	beq		Draw_WallSprite_BitReversed
	swap	d6
	btst	#$00,(a2)
	beq.s	MainWallTransformed_PerspectiveTrim
	bsr.s	Draw_MainWall_EdgeTransform
MainWallTransformed_PerspectiveTrim:		; Memory Address ($B680) and binary offset [$B2FC]
	movem.l	d7/a0/a1,-(sp)
	move.b	(a2),d6
	and.w	#WallTransform_FlagMask,d6											;Retains the edge and perspective controls used to index the main-wall trim table.
	swap	d3
	move.w	#Screen_BitplaneRowBytes,d7											;Uses the forty-byte single-bitplane screen-row stride when advancing transformed wall rows.
	add.w	d3,d7
	swap	d3
	move.w	d5,d4
	swap	d5
	move.b	GFX_Main_Wall_PerspectiveTrimLookup(pc,d6.w),d6
	sub.w	d6,d5
	add.w	d6,d6
	sub.w	d6,d7
MainWallTransformed_RowLoop:		; Memory Address ($B6A2) and binary offset [$B31E]
	move.w	d5,d3
MainWallTransformed_ColumnLoop:		; Memory Address ($B6A4) and binary offset [$B320]
	move.l	(a1)+,d1
	move.l	(a1)+,d0
	bsr		Reverse_PlanarLongwordBits
	exg		d0,d1
	bsr		Reverse_PlanarLongwordBits
	move.w	d1,$5DBE(a0)
	swap	d1
	move.w	d1,$3E7E(a0)
	move.w	d0,$1F3E(a0)
	swap	d0
	move.w	d0,-(a0)
	dbra	d3,MainWallTransformed_ColumnLoop
	move.w	d6,d3
	asl.w	#$02,d3
	add.w	d3,a1
	add.w	d7,a0
	dbra	d4,MainWallTransformed_RowLoop
	movem.l	(sp)+,d7/a0/a1
	swap	d5
	swap	d3
	sub.w	d3,d6
	add.w	d6,a0
	asl.w	#$02,d6
	sub.w	d6,a1
	swap	d3
	btst	#$02,(a2)
	beq.s	MainWallTransformed_Finish
	bsr.s	Draw_MainWall_EdgeTransform
MainWallTransformed_Finish:		; Memory Address ($B6EE) and binary offset [$B36A]
	swap	d6
	rts		

GFX_Main_Wall_PerspectiveTrimLookup:		; Memory Address ($B6F2) and binary offset [$B36E]
	; Maps the low three main-wall transform flag bits to zero, one or two source
	; word-columns trimmed during perspective drawing.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Dungeon_MainWall_PerspectiveTrim.lookup"

Draw_MainWall_EdgeTransform:		; Memory Address ($B6FA) and binary offset [$B376]
	; Draws the horizontally reversed perspective edge pass for a stone wall.
	movem.l	a0/a1,-(sp)
	swap	d3
	move.w	d3,d6
	subq.w	#$02,d6
	asl.w	#$02,d6
	swap	d3
	move.w	d5,d3
Draw_MainWall_EdgeTransform_RowLoop:		; Memory Address ($B70A) and binary offset [$B386]
	move.l	(a1)+,d1
	move.l	(a1)+,d0
	bsr		Reverse_PlanarLongwordBits
	exg		d0,d1
	bsr		Reverse_PlanarLongwordBits
	move.l	d1,d2
	and.l	d0,d2
	swap	d2
	and.l	d0,d2
	and.l	d1,d2
	not.l	d2
	and.l	d2,d0
	and.l	d2,d1
	not.l	d2
	move.w	$5DBE(a0),d4
	and.w	d2,d4
	or.w	d1,d4
	move.w	d4,$5DBE(a0)
	swap	d1
	move.w	$3E7E(a0),d4
	and.w	d2,d4
	or.w	d1,d4
	move.w	d4,$3E7E(a0)
	move.w	$1F3E(a0),d4
	and.w	d2,d4
	or.w	d0,d4
	move.w	d4,$1F3E(a0)
	swap	d0
	move.w	-(a0),d4
	and.w	d2,d4
	or.w	d0,d4
	move.w	d4,(a0)
	add.w	#$002A,a0
	add.w	d6,a1
	dbra	d3,Draw_MainWall_EdgeTransform_RowLoop
	movem.l	(sp)+,a0/a1
	subq.w	#$02,a0
	addq.w	#$08,a1
	rts		

Draw_WallSprite_BitReversed:		; Memory Address ($B76E) and binary offset [$B3EA]
	; Writes normal wall rows after horizontally reversing their planar source
	; bits.
	swap	d5
	move.w	d5,d3
Draw_WallSprite_BitReversed_Rows_Loop:		; Memory Address ($B772) and binary offset [$B3EE]
	; Iterates a horizontally bit-reversed wall sprite through its planar source
	; rows and words.
	move.l	(a1)+,d1
	move.l	(a1)+,d0
	bsr		Reverse_PlanarLongwordBits
	exg		d0,d1
	bsr		Reverse_PlanarLongwordBits
	tst.w	Buffer_Colour_Mask_Toggle.l
	beq.s	Composite_BitReversedWallSprite_Row
	lea		Buffer_Colour_Mask.l,a6
	bsr		Remap_PlanarSpriteColours
Composite_BitReversedWallSprite_Row:		; Memory Address ($B792) and binary offset [$B40E]
	; Builds the transparency mask and merges one bit-reversed sprite word into all
	; four destination bitplanes.
	move.l	d1,d2
	and.l	d0,d2
	addq.l	#$01,d2
	beq.s	WallSpriteBitReversed_SkipTransparentWord
	subq.l	#$01,d2
	swap	d2
	and.l	d0,d2
	and.l	d1,d2
	not.l	d2
	and.l	d2,d0
	and.l	d2,d1
	not.l	d2
	move.w	$5DBE(a0),d4
	and.w	d2,d4
	or.w	d1,d4
	move.w	d4,$5DBE(a0)
	swap	d1
	move.w	$3E7E(a0),d4
	and.w	d2,d4
	or.w	d1,d4
	move.w	d4,$3E7E(a0)
	move.w	$1F3E(a0),d4
	and.w	d2,d4
	or.w	d0,d4
	move.w	d4,$1F3E(a0)
	swap	d0
	move.w	-(a0),d4
	and.w	d2,d4
	or.w	d0,d4
	move.w	d4,(a0)
	bra.s	CompositeBitReversedWallSprite_LoopTail

WallSpriteBitReversed_SkipTransparentWord:		; Memory Address ($B7DC) and binary offset [$B458]
	subq.w	#$02,a0
CompositeBitReversedWallSprite_LoopTail:		; Memory Address ($B7DE) and binary offset [$B45A]
	dbra	d3,Draw_WallSprite_BitReversed_Rows_Loop
	swap	d3
	add.w	d3,a0
	swap	d3
	add.w	#$0028,a0
	swap	d5
	dbra	d5,Draw_WallSprite_BitReversed
	rts		

Draw_FloorAndCeiling:		; Memory Address ($B7F4) and binary offset [$B470]
	; Draws the floor and ceiling bands used by the dungeon viewport. Selects the
	; ordinary or horizontally bit-reversed floor/ceiling renderer according to the
	; dungeon pattern parity.
	lea		GFX_FloorCeiling.l,a1
	move.l	-$0008(a3),a0
	tst.w	-$000C(a3)
	beq.s	Draw_FloorAndCeiling_BitReversed
	moveq	#$16,d0
	bsr.s	Draw_FloorAndCeiling_CopyRows_Loop
	bsr.s	Clear_FloorCeiling_ViewGap
	moveq	#$21,d0
Draw_FloorAndCeiling_CopyRows_Loop:		; Memory Address ($B80C) and binary offset [$B488]
	; Copies source rows into the floor and ceiling areas of the dungeon viewport.
	; Copies the parity-1 floor and ceiling rows directly into the dungeon
	; viewport.
	moveq	#$07,d1
Draw_FloorAndCeiling_CopyRows_PlanesLoop:		; Memory Address ($B80E) and binary offset [$B48A]
	move.w	(a1)+,(a0)+
	move.w	(a1)+,$1F3E(a0)
	move.w	(a1)+,$3E7E(a0)
	move.w	(a1)+,$5DBE(a0)
	dbra	d1,Draw_FloorAndCeiling_CopyRows_PlanesLoop
	lea		$0018(a0),a0
	dbra	d0,Draw_FloorAndCeiling_CopyRows_Loop
	rts		

Clear_FloorCeiling_ViewGap:		; Memory Address ($B82A) and binary offset [$B4A6]
	; Clears the nineteen-rowhorizontal  view area between the ceiling and floor
	; bands.
	moveq	#$12,d0
	moveq	#$00,d1
Clear_FloorCeiling_ViewGap_RowLoop:		; Memory Address ($B82E) and binary offset [$B4AA]
	lea		$1F40(a0),a2
	move.l	d1,(a2)+
	move.l	d1,(a2)+
	move.l	d1,(a2)+
	move.l	d1,(a2)+
	lea		$3E80(a0),a2
	move.l	d1,(a2)+
	move.l	d1,(a2)+
	move.l	d1,(a2)+
	move.l	d1,(a2)+
	lea		$5DC0(a0),a2
	move.l	d1,(a2)+
	move.l	d1,(a2)+
	move.l	d1,(a2)+
	move.l	d1,(a2)+
	move.l	d1,(a0)+
	move.l	d1,(a0)+
	move.l	d1,(a0)+
	move.l	d1,(a0)+
	lea		$0018(a0),a0
	dbra	d0,Clear_FloorCeiling_ViewGap_RowLoop
	rts		

Draw_FloorAndCeiling_BitReversed:		; Memory Address ($B864) and binary offset [$B4E0]
	; Draws the horizontally bit-reversed floor and ceiling bands for parity 0.
	lea		BitReverse_LookupBuffer.l,a6
	lea		$0010(a0),a0
	moveq	#$16,d7
	bsr.s	Draw_FloorAndCeiling_BitReversed_Loop
	sub.w	#$0010,a0
	bsr.s	Clear_FloorCeiling_ViewGap
	lea		$0010(a0),a0
	moveq	#$21,d7
Draw_FloorAndCeiling_BitReversed_Loop:		; Memory Address ($B87E) and binary offset [$B4FA]
	; Loop used to write the bit-reversed floor and ceiling rows. Bit-reverses and
	; writes each floor/ceiling source row from the opposite side of the viewport.
	moveq	#$07,d3
Draw_FloorAndCeiling_BitReversed_PlanesLoop:		; Memory Address ($B880) and binary offset [$B4FC]
	move.l	(a1)+,d0
	bsr		Reverse_PlanarLongwordBits_WithLookup
	move.l	d0,d1
	move.l	(a1)+,d0
	bsr		Reverse_PlanarLongwordBits_WithLookup
	move.w	d0,$5DBE(a0)
	swap	d0
	move.w	d0,$3E7E(a0)
	move.w	d1,$1F3E(a0)
	swap	d1
	move.w	d1,-(a0)
	dbra	d3,Draw_FloorAndCeiling_BitReversed_PlanesLoop
	lea		$0038(a0),a0
	dbra	d7,Draw_FloorAndCeiling_BitReversed_Loop
	rts		

Dungeon_ViewCell_RelativeCoordinates:		; Memory Address ($B8AE) and binary offset [$B52A]
	; Four player-facing groups of 19 signed relative X/Y coordinate words defining
	; the dungeon cells examined by the renderer.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Dungeon_ViewCell_RelativeCoordinates.positions"
Dungeon_ViewCell_OcclusionMasks:		; Memory Address ($B946) and binary offset [$B5C2]
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Dungeon_ViewCell_Occlusion.flags"
Dungeon_ViewCell_VisibleFaceMasks:		; Memory Address ($B992) and binary offset [$B60E]
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Dungeon_ViewCell_VisibleFaces.flags"
Dungeon_ViewCell_CentredSlots:		; Memory Address ($B9DE) and binary offset [$B65A]
	; Maps the 19 view cells to centred projected slots used by pillars, beds, pits
	; and pads; FF means unavailable. The twentieth byte is spare.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Dungeon_ViewCell_CentredSlots.lookup"
Dungeon_ViewCell_WallFaceSlots:		; Memory Address ($B9F2) and binary offset [$B66E]
	; Four N/E/S/W wall-face slot numbers per view cell; FF means that face is
	; unavailable from that cell.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Dungeon_ViewCell_WallFaces.lookup"
GFX_Main_Walls_Positions:		; Memory Address ($BA3E) and binary offset [$B6BA]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Main_Walls.positions"
GFX_Wooden_Wall_Positions:		; Memory Address ($BAAE) and binary offset [$B72A]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Wooden_Wall.positions"
GFX_Stairs_Up_Positions:		; Memory Address ($BB1E) and binary offset [$B79A]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Stairs_Up.positions"
GFX_Stairs_Down_Positions:		; Memory Address ($BB92) and binary offset [$B80E]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Stairs_Down.positions"
GFX_Misc_Pillar_Positions:		; Memory Address ($BC06) and binary offset [$B882]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Misc_Pillar.positions"
GFX_Door_Positions:		; Memory Address ($BC4E) and binary offset [$B8CA]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Door.Positions"
GFX_Misc_Bed_Positions:		; Memory Address ($BC9E) and binary offset [$B91A]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Misc_Bed.positions"
GFX_Main_Shelf_Positions:		; Memory Address ($BCE6) and binary offset [$B962]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Main_Shelf.positions"
GFX_Main_Sign_Positions:		; Memory Address ($BD56) and binary offset [$B9D2]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Main_Sign.positions"
GFX_Main_Signoverlay_Positions:		; Memory Address ($BDC6) and binary offset [$BA42]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Main_SignOverlay.positions"
GFX_Main_Slots_Positions:		; Memory Address ($BE36) and binary offset [$BAB2]
	; Contains the exact X/Y/width/height rectangle for each projected wall view.
	INCBIN "/data/BLOODWYCH439-clean/gfx/Main_Slots.positions"
GFX_Main_Switches_Positions:		; Memory Address ($BEA6) and binary offset [$BB22]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Main_Switches.positions"
GFX_FloorPit_TriggerPad_Positions:		; Memory Address ($BF16) and binary offset [$BB92]
	; Shared projected positions for floor pits and trigger pads, including the
	; current-player square.
	INCBIN "/data/BLOODWYCH439-clean/gfx/FloorPit_TriggerPad.positions"
GFX_Ceiling_Hole_Positions:		; Memory Address ($BF62) and binary offset [$BBDE]
	; Projected ceiling-hole positions, including the current-player square.
	INCBIN "/data/BLOODWYCH439-clean/gfx/Ceiling_Hole.positions"
GFX_Wooden_Doors_Positions:		; Memory Address ($BFAE) and binary offset [$BC2A]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Wooden_Doors.positions"

Draw_ChampionSelectionDetailsPanel:		; Memory Address ($C01E) and binary offset [$BC9A]
	; Draws the portrait bevel, name strip, statistics scroll, and separators in
	; the champion-selection details panel.
	lea		Notice_SelectChampions.l,a6
	tst.w	MultiPlayer.l
	beq.s	ChampionSelectionDetailsPanel_NoticeMerge
	move.b	#$2E,$001B(a6)
ChampionSelectionDetailsPanel_NoticeMerge:		; Memory Address ($C032) and binary offset [$BCAE]
	move.l	screen_ptr.l,a0
	add.w	#$0050,a0
	move.l	#$000F0000,CurrentTextInk.l
	bsr		Print_fflim_text
	lea		Player1_Data.l,a5
	tst.w	MultiPlayer.l
	bmi.s	Draw_ChampionSelectionDefaultPanel
	bsr.s	Draw_ChampionSelectionDefaultPanel
	lea		Player2_Data.l,a5
Draw_ChampionSelectionDefaultPanel:		; Memory Address ($C060) and binary offset [$BCDC]
	; Resets champion selection to its default mode and draws the initial framed
	; panel, armour bar, and scroll.
	clr.w	$0014(a5)
	move.l	#$002F00A8,d4
	moveq	#$09,d5
	bsr.s	Draw_BevelledPanelFrame
	move.l	#$009700A8,d4
	move.l	#$00070058,d5
	add.w	$0008(a5),d5
	move.w	$0010(a5),d3
	bsr		BW_draw_bar
	moveq	#$2A,d5
	bsr		Draw_ScrollFrame
	move.l	#$00970001,d3
	move.w	#$00A8,d4
	moveq	#$54,d5
	add.w	$0008(a5),d5
ChampionPanel_NameStrip_TopLines_Loop:		; Memory Address ($C09C) and binary offset [$BD18]
	; Draws the name strip's four upper edge lines across X=168-319 at Y=84-87 in
	; colours 1-4 before the following loop draws the lower edge in reverse colour
	; order.
	bsr		BW_blit_horiz_line
	addq.w	#$01,d5
	addq.w	#$01,d3
	cmpi.w	#$0005,d3
	bcs.s	ChampionPanel_NameStrip_TopLines_Loop
	addq.w	#$08,d5
	subq.w	#$01,d3
ChampionPanel_NameStrip_BottomLines_Loop:		; Memory Address ($C0AE) and binary offset [$BD2A]
	bsr		BW_blit_horiz_line
	addq.w	#$01,d5
	subq.w	#$01,d3
	bne.s	ChampionPanel_NameStrip_BottomLines_Loop
	rts		

Draw_BevelledPanelFrame:		; Memory Address ($C0BA) and binary offset [$BD36]
	; Fills a panel rectangle and draws three successively inset grey frame
	; outlines.
	add.w	$0008(a5),d5
	swap	d5
	move.w	#$002B,d5															;Sets vertical terminal count $2B; the panel fill therefore spans $2C rows.
	swap	d5
	moveq	#$01,d3																;Selects palette index $01 for the initial filled panel rectangle.
	movem.l	d3-d5,-(sp)
	bsr		BW_draw_bar
	movem.l	(sp)+,d3-d5
Draw_BevelledPanelFrame_InsetOutlines_Loop:		; Memory Address ($C0D4) and binary offset [$BD50]
	addq.w	#$01,d4
	addq.w	#$01,d5
	sub.l	#$00020000,d5														;Long Addr replaced with Symbol
	sub.l	#$00020000,d4														;Long Addr replaced with Symbol
	addq.w	#$01,d3																;Advances through the three grey outline colours as the frame moves inward.
	movem.l	d3-d5,-(sp)
	bsr		BW_draw_frame
	movem.l	(sp)+,d3-d5
	cmpi.w	#$0004,d3
	bne.s	Draw_BevelledPanelFrame_InsetOutlines_Loop
	rts		

ChampionSelection_Main:		; Memory Address ($C0FA) and binary offset [$BD76]
	; Initialises the champion-selection panels, moves the single-player panel 38
	; pixels lower, draws the roster and detail views into both buffers as
	; applicable, enables input, and services the players until the selection-mode
	; state signals exit.
	moveq	#-$01,d0
	move.w	d0,ChampionSelectionHeaderEnabledFlag.l
	move.b	d0,Player1_ChampionCount_PendingCommit.l
	move.b	d0,Player2_ChampionCount.l
	move.l	#$00B00040,Player1_MousePosition.l
	move.l	#$00B00078,Player2_MousePosition.l
	clr.b	Player1_DialogueFadeControl.l
	move.w	#$BA02,d0
	move.w	d0,Player1_MouseYClampBounds.l
	move.w	d0,Player2_MouseYClampBounds.l
	tst.w	MultiPlayer.l
	beq.s	ChampionSelection_Main_AfterSetup
	clr.w	ChampionSelectionHeaderEnabledFlag.l
	move.w	#$FFFF,Player2_SelectionUIMode.l
	move.l	#$00D80000,Player2_MousePosition.l
	move.w	#$0026,Player1_InterfacePanelYOffset.l
	move.w	#$05F0,Player1_InterfaceScreenBufferOffset.l
ChampionSelection_Main_AfterSetup:		; Memory Address ($C168) and binary offset [$BDE4]
	bsr		ChampionSelection
	bsr		Draw_ChampionSelectionDetailsPanel
	bsr		Swap_DisplayAndDrawBuffers
	bsr		ChampionSelection
	bsr		Draw_ChampionSelectionDetailsPanel
	move.w	#$0005,Player1_DialogueFadeTimer.l
	move.b	#$01,InputProcessingEnabledFlag.l
	jsr		Initialize_SpellPracticeThresholds.w								;Short Absolute converted to symbol!
ChampionSelection_Main_ProcessLoop:		; Memory Address ($C190) and binary offset [$BE0C]
	move.w	Player2_SelectionUIMode.l,d1
	lea		Player1_Data.l,a5
	and.w	$0014(a5),d1
	bmi.s	ExitOrLoop
	clr.b	ChampionSelectionLiveActionFlag.l
	bsr		HitTest_ChampionSelectionPanel
	bsr		Process_ChampionSelectionAction
	lea		Player2_Data.l,a5
	bsr		HitTest_ChampionSelectionPanel
	bsr		Process_ChampionSelectionAction
	move.b	#$FF,FrameSyncFlag.l
ChampionSelection_Main_WaitForFrameSync:		; Memory Address ($C1C6) and binary offset [$BE42]
	tst.b	FrameSyncFlag.l
	bne.s	ChampionSelection_Main_WaitForFrameSync
	move.b	#$01,ChampionSelectionLiveActionFlag.l
	lea		Player1_Data.l,a5
	bsr		Process_ChampionSelectionAction
	clr.w	$000C(a5)
	lea		Player2_Data.l,a5
	bsr		Process_ChampionSelectionAction
	clr.w	$000C(a5)
	bra.s	ChampionSelection_Main_ProcessLoop

ExitOrLoop:		; Memory Address ($C1F4) and binary offset [$BE70]
	rts		

HitTest_ChampionSelectionPanel:		; Memory Address ($C1F6) and binary offset [$BE72]
	; Dispatches champion-selection clicks through roster, selection, object-view,
	; spell-preview, and spellbook controls.
	move.w	$0022(a5),$0024(a5)
	bclr	#$07,$0001(a5)
	beq.s	ExitOrLoop
	move.w	$0014(a5),d0
	bmi.s	ExitOrLoop
	cmpi.b	#$03,d0
	beq.s	ExitOrLoop
	bsr		HitTest_ChampionRosterRow
	bpl.s	ExitOrLoop
	tst.b	$0007(a5)
	bmi.s	ExitOrLoop
	bsr		HitTest_SelectChampionRegion
	bpl.s	ExitOrLoop
	bsr		HitTest_ViewObjectRegion
	bpl.s	ExitOrLoop
	bsr		HitTest_PreviewSpellRegion
	bpl.s	ExitOrLoop
	bra		HitTest_SpellBookControls

Process_ChampionSelectionAction:		; Memory Address ($C5B6) and binary offset [$C232]
	; Processes the champion-selection screen's separate action state.
	move.w	$0014(a5),d0
	bmi.s	ExitOrLoop
	cmpi.b	#$03,d0
	bne.s	Dispatch_ChampionSelectionAction
	lsr.w	#$08,d0
	cmpi.w	#$0007,d0
	bne.s	Process_ChampionSelectionAction_StoreIndex
	move.w	#$0002,$0014(a5)
	rts		

Process_ChampionSelectionAction_StoreIndex:		; Memory Address ($C24E) and binary offset [$BECA]
	move.w	d0,$000C(a5)
Dispatch_ChampionSelectionAction:		; Memory Address ($C5D6) and binary offset [$C252]
	; Dispatches champion-selection actions through the local preview/action table.
	move.w	$000C(a5),d0
	beq.s	ExitOrLoop
	asl.w	#$02,d0
	lea		ChampionSelection_ActionHandlers.l,a0
	move.l	$00(a0,d0.w),a0
ChampionSelection_ActionHandlers:	equ	*-2	; Memory Address ($C5E6) and binary offset [$C262]
	; Champion-selection action handler table; its numeric meanings differ from
	; dungeon InterfaceButtons.
	jmp		(a0)

ChampionPreviews_LookupTable:		; Memory Address ($C266) and binary offset [$BEE2]
	dc.l	Click_SelectionAvatar	;0000C53C
	dc.l	Click_SwitchView	;0000C436
	dc.l	Click_SelectChampion	;0000C490
	dc.l	Click_ViewObject	;0000C516
	dc.l	Click_PreviewSpell	;0000C286
	dc.l	Click_TurnSpellBookPage	;0000C2EA
	dc.l	ExitOrLoop	;0000C1F4
	dc.l	Click_TurnSpellBookPage	;0000C2EA

Click_PreviewSpell:		; Memory Address ($C286) and binary offset [$BF02]
	bsr		Select_SpellBookRune
	bpl.s	Click_PreviewSpell_PrintSpellName
	move.w	$0006(a5),d7
	bsr		Print_ChampionSelectionFullName
	bra		Draw_SpellBookPageSpread

Click_PreviewSpell_PrintSpellName:		; Memory Address ($C298) and binary offset [$BF14]
	moveq	#$07,d6
	bsr		Position_NameFieldTextCursor
	bsr		Print_TextCharacterLoop
	moveq	#$0A,d6
	bsr		TerminateText
	bra		Draw_SpellBookPageSpread

Select_SpellBookRune:		; Memory Address ($C2AC) and binary offset [$BF28]
	; Tests the clicked ownership bit, loads an owned spell, or clears the queued
	; spell.
	bsr		Load_CurrentChampionStatRecord
	move.w	PlayerData_SpellBookPageSpread(a5),d0
	move.w	d0,d2
	asl.w	#$02,d2
	lsr.w	#$01,d0
	move.w	d0,d3
	move.w	$000E(a5),d0
	btst	d0,ChampionStat_KnownSpellMask(a4,d3.w)								;Tests the clicked rune entry against its page nibble; a clear bit deselects the currently loaded spell instead of selecting that rune.
	beq.s	Select_SpellBookRune_ClearSelection
	eor.w	#$0007,d0
	add.w	d2,d0
	move.b	d0,ChampionStat_SpellToCast(a4)
	clr.b	ChampionStat_SpellPowerBoost(a4)
Get_SelectedSpellName:		; Memory Address ($C2D4) and binary offset [$BF50]
	; Resolves the selected spell’s fixed eight-character SpellNames record.
	asl.w	#$03,d0
	lea		SpellNames.l,a6
	add.w	d0,a6
	rts		

Select_SpellBookRune_ClearSelection:		; Memory Address ($C2E0) and binary offset [$BF5C]
	move.b	#$FF,ChampionStat_SpellToCast(a4)
	moveq	#-$01,d0
SpellBookRune_SharedTail:		; Memory Address ($C2E8) and binary offset [$BF64]
	rts		

Click_TurnSpellBookPage:		; Memory Address ($C2EA) and binary offset [$BF66]
	tst.w	$0024(a5)
	bne.s	SpellBookRune_SharedTail
	tst.b	$000F(a5)
	bpl.s	Draw_SpellBookPageTurn
	tst.b	$000E(a5)
	bmi.s	Click_TurnSpellBookPage_AfterPageAdvance
	addq.w	#SpellBook_PageSpreadIncrement,$002A(a5)
	and.w	#$0007,$002A(a5)
	move.w	#$FFFF,$000E(a5)
Click_TurnSpellBookPage_AfterPageAdvance:		; Memory Address ($C30C) and binary offset [$BF88]
	tst.b	ChampionSelectionLiveActionFlag.l
	beq.s	Click_TurnSpellBookPage_PrepareRedraw
	move.w	#$0002,$0014(a5)
Click_TurnSpellBookPage_PrepareRedraw:		; Memory Address ($C31A) and binary offset [$BF96]
	bsr		Prepare_AndDrawSpellBookSurface
	bra		Draw_SpellBookPageSpread

Draw_SpellBookPageTurn:		; Memory Address ($C322) and binary offset [$BF9E]
	; Redraws spellbook content through four overlapping 32x56 page-turn frames;
	; previous-page animation uses phases 0-3 and next-page animation uses phases
	; 3-0 before committing the spread.
	bsr		Prepare_AndDrawSpellBookSurface
	move.w	$002A(a5),d0
	bsr		Draw_SpellBookRunePage
	move.w	$000E(a5),d1
	bpl.s	Draw_SpellBookPageTurn_ResolvePhase
	eor.w	#$0003,d1
Draw_SpellBookPageTurn_ResolvePhase:		; Memory Address ($C338) and binary offset [$BFB4]
	and.w	#$0003,d1
	move.w	$002A(a5),d0
	cmpi.w	#$0003,d1															;At the final page-turn phase, redraws the adjacent page before the rightmost rune-column overlay is added.
	bne.s	Draw_SpellBookPageTurn_DrawReplacementPage
	addq.w	#$01,d0
	bsr		Draw_SpellBookRunePage
	move.w	$002A(a5),d0
	addq.w	#$03,d0
	and.w	#$0007,d0
	move.w	d0,d7
	asl.w	#$04,d0
	lea		SpellBookRunes+$03.l,a6												;Selects the offset-three rune stream for four rightmost-column glyph stamps during the final page-turn phase.
	add.w	d0,a6
	move.l	screen_ptr.l,a0
	add.w	#$0436,a0
	add.w	$000A(a5),a0
	move.l	a4,a3
	move.w	d7,d0
	lsr.w	#$01,d0
	add.w	d0,a3
	asl.w	#$02,d7
	swap	d7
	move.w	#$0003,d7
Draw_SpellBookPageTurn_ReplacementRuneLoop:		; Memory Address ($C380) and binary offset [$BFFC]
	; Replaces the rightmost phase-3 rune over a freshly restored bare spellbook
	; cell so the opaque glyph write preserves the underlying page artwork.
	bsr		Select_SpellRuneInk
	move.w	d6,CurrentTextInk.l
	move.b	(a6),d0
	bsr		Draw_TextGlyph
	addq.w	#$04,a6
	add.w	#$013F,a0
	dbra	d7,Draw_SpellBookPageTurn_ReplacementRuneLoop
	bra.s	Build_SpellBookPageTurnColourMask

Draw_SpellBookPageTurn_DrawReplacementPage:		; Memory Address ($C39C) and binary offset [$C018]
	addq.w	#$03,d0
	and.w	#$0007,d0
	bsr		Draw_SpellBookRunePage
Build_SpellBookPageTurnColourMask:		; Memory Address ($C3A6) and binary offset [$C022]
	; Builds the four rune-class inks used by the page-turn overlay.
	move.w	$002A(a5),d7
	addq.w	#$02,d7
	and.w	#$0007,d7
	move.w	d7,d0
	lsr.w	#$01,d0
	move.l	a4,a3
	add.w	d0,a3
	asl.w	#$02,d7
	swap	d7
	move.w	#$0007,d7
	lea		Buffer_Colour_Mask.l,a6
	moveq	#$03,d5
Build_SpellBookPageTurnColourMask_Loop:		; Memory Address ($C3C8) and binary offset [$C044]
	bsr		Select_SpellRuneInk
	move.b	d6,(a6)+															;Builds the four-entry colour mask used when the spell-book overlay is drawn.
	subq.w	#$01,d7
	dbra	d5,Build_SpellBookPageTurnColourMask_Loop
	move.w	$000E(a5),d0
	bpl.s	Draw_SelectedSpellMarker
	eor.w	#$0003,d0
Draw_SelectedSpellMarker:		; Memory Address ($C3DE) and binary offset [$C05A]
	; Draws the selected spell-column marker from GFX_Pockets+$4130.
	and.w	#$0003,d0
	move.l	screen_ptr.l,a0
	add.w	#$0186,a0
	add.w	$000A(a5),a0
	lea		GFX_Pockets+$4130.l,a1
	add.w	d0,d0
	add.w	d0,a0
	asl.w	#$03,d0																;After screen-address doubling, converts the frame index to its 16-byte GFX_Pockets+$4130 source offset (32 pixels per frame).
	add.w	d0,a1
	move.l	#$00010037,d5														;Long Addr replaced with Symbol
	move.w	#$0004,d3
	swap	d3
	move.l	#$00000090,a3
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l
	bsr		Draw_WallSprite_Rows_Loop
	clr.w	Buffer_Colour_Mask_Toggle.l
	tst.b	ChampionSelectionLiveActionFlag.l
	beq.s	Draw_SelectedSpellMarker_Return
	subq.b	#$01,$000F(a5)
	move.w	#$0006,$0022(a5)
Draw_SelectedSpellMarker_Return:		; Memory Address ($C434) and binary offset [$C0B0]
	rts		

Click_SwitchView:		; Memory Address ($C436) and binary offset [$C0B2]
	; Cycles the champion-selection view through inventory, spellbook, and
	; statistics states and redraws the corresponding pocket icon.
	move.w	$0006(a5),d7
	bsr		Print_ChampionSelectionFullName
Draw_ChampionSelectionModePanel:		; Memory Address ($C43E) and binary offset [$C0BA]
	; Draws the current champion-selection mode icon and dispatches its inventory,
	; spellbook, or statistics panel.
	move.w	$0014(a5),d0
	add.w	#$0060,d0
	move.l	screen_ptr.l,a0
	add.w	#$0A16,a0
	add.w	$000A(a5),a0
	bsr		Draw_PocketGraphic
	move.w	$0014(a5),d0
	asl.w	#$02,d0
	lea		ChampionSelectionModeJumpTable.l,a0
	move.l	$00(a0,d0.w),a0
	jsr		(a0)
	tst.b	ChampionSelectionLiveActionFlag.l
	beq.s	Draw_ChampionSelectionModePanel_Return
	addq.w	#$01,$0014(a5)
	cmp.w	#$0003,$0014(a5)
	bcs.s	Draw_ChampionSelectionModePanel_Return
	clr.w	$0014(a5)
Draw_ChampionSelectionModePanel_Return:		; Memory Address ($C482) and binary offset [$C0FE]
	rts		

ChampionSelectionModeJumpTable:		; Memory Address ($C484) and binary offset [$C100]
	; Three-entry dispatch table for inventory, spellbook, and statistics
	; champion-selection panels.
	dc.l	Draw_InventoryPanel	;0000C938
	dc.l	Draw_SpellBookPanel	;0000C852
	dc.l	Draw_ChampionStats_DefaultPosition	;0000CB28

Click_SelectChampion:		; Memory Address ($C490) and binary offset [$C10C]
	; Draws the champion-selection confirmation heading and BEGIN GAME scroll;
	; during the live-action pass it marks that player's selection mode complete
	; and suppresses the heading on subsequent use.
	clr.w	Player1_DialogueRampColour.l
	move.l	screen_ptr.l,a0
	add.w	#$0050,a0
	lea		Notice_SelectChampion.l,a6
	moveq	#$27,d6
	tst.w	ChampionSelectionHeaderEnabledFlag.l
	bne.s	Click_SelectChampion_PatchPlayerNumber
	move.w	#$00FF,Player1_DialogueFadeTimer.l
	bra.s	Click_SelectChampion_DrawReadyScroll

Click_SelectChampion_PatchPlayerNumber:		; Memory Address ($C4BA) and binary offset [$C136]
	move.b	(a5),d0
	not.w	d0
	and.w	#$0001,d0
	add.b	#$31,d0
	move.b	d0,$0007(a6)
	move.l	#$000F0000,CurrentTextInk.l
	bsr		Print_fflim_text
	move.w	#$0005,Player1_DialogueFadeTimer.l
Click_SelectChampion_DrawReadyScroll:		; Memory Address ($C4E0) and binary offset [$C15C]
	moveq	#$2A,d5
	bsr		Draw_ScrollFrame
	move.b	(a5),d0
	and.w	#$0001,d0
	add.b	#$31,d0
	lea		BeginGameScroll.l,a6
	move.b	d0,$000E(a6)
	bsr		Print_fflim_text
	tst.b	ChampionSelectionLiveActionFlag.l
	beq.s	Click_SelectChampion_Return
	move.w	#$FFFF,$0014(a5)
	clr.w	ChampionSelectionHeaderEnabledFlag.l
Click_SelectChampion_Return:		; Memory Address ($C512) and binary offset [$C18E]
	rts		

ChampionSelectionHeaderEnabledFlag:		; Memory Address ($C514) and binary offset [$C190]
	; Nonzero makes Click_SelectChampion print the SELECT CHAMPION heading;
	; multiplayer setup and a committed live selection clear it.
	dc.w	$FFFF	;FFFF

Click_ViewObject:		; Memory Address ($C516) and binary offset [$C192]
	move.w	$0006(a5),d0
	asl.w	#$04,d0
	lea		Character_Pockets_DataTable.l,a6
	add.w	d0,a6
	move.w	$000E(a5),d0
	move.b	$00(a6,d0.w),d0
	lea		Object_Definition_Table+$02.l,a6
	add.w	d0,d0
	add.w	d0,d0
	add.w	d0,a6
	bra		InventoryItem_Description

Click_SelectionAvatar:		; Memory Address ($C53C) and binary offset [$C1B8]
	move.w	$0006(a5),d7
	move.w	d7,-(sp)
	bsr		Draw_Select_Avatars
	move.w	$000E(a5),d7
	move.w	d7,$0006(a5)
	move.w	$0012(a5),d3
	bsr		Draw_SelectedChampionClickedShield
	clr.w	d4
	move.l	#$00000296,a0
	move.w	$0006(a5),d7
	bsr		Draw_ChampionLargeAvatar
	bsr		Print_ChampionSelectionFullName
	bsr		Load_CurrentChampionStatRecord
	move.b	#$FF,$0013(a4)
	move.l	screen_ptr.l,a0
	add.w	#$0A19,a0
	add.w	$000A(a5),a0
	move.w	d7,d0
	bsr		Select_LivingMemberClassColour
	tst.b	$0001(sp)
	bpl.s	Click_SelectionAvatar_AfterButtonFrames
	bsr.s	Draw_ChampionSelectionCommandButtonFrames
Click_SelectionAvatar_AfterButtonFrames:		; Memory Address ($C590) and binary offset [$C20C]
	tst.b	ChampionSelectionLiveActionFlag.l
	bne.s	Click_SelectionAvatar_DrawModePanel
	subq.w	#$01,$0014(a5)
	bcc.s	Click_SelectionAvatar_DrawModePanel
	move.w	#$0002,$0014(a5)
Click_SelectionAvatar_DrawModePanel:		; Memory Address ($C5A4) and binary offset [$C220]
	bsr		Draw_ChampionSelectionModePanel
	move.w	(sp)+,d7
	tst.b	ChampionSelectionLiveActionFlag.l
	bne.s	Click_SelectionAvatar_Return
	move.w	d7,$0006(a5)
Click_SelectionAvatar_Return:		; Memory Address ($C5B6) and binary offset [$C232]
	rts		

Draw_ChampionSelectionCommandButtonFrames:		; Memory Address ($C5B8) and binary offset [$C234]
	; Draws the two nested outline frames for the champion-selection command
	; buttons.
	move.l	#$001700AD,d4
	bsr.s	Draw_ChampionSelectionButtonFrame
	move.l	#$001700C5,d4
Draw_ChampionSelectionButtonFrame:		; Memory Address ($C5C6) and binary offset [$C242]
	; Draws the nested outer and inner frames for one champion-selection command
	; button.
	move.l	#$0013003E,d5
	moveq	#$02,d3
	add.w	$0008(a5),d5
	movem.l	d4/d5,-(sp)
	bsr		BW_cs_draw_frame
	movem.l	(sp)+,d4/d5
	addq.w	#$01,d4
	sub.l	#$00020000,d4														;Long Addr replaced with Symbol
	sub.l	#$00020000,d5														;Long Addr replaced with Symbol
	addq.w	#$01,d5
	moveq	#$04,d3
	bra		BW_draw_frame

HitTest_SelectChampionRegion:		; Memory Address ($C5F4) and binary offset [$C270]
	; Tests the Select Champion button rectangle and records its action index on a
	; hit.
	move.l	$0002(a5),d1
	sub.w	$0008(a5),d1
	cmpi.w	#$0040,d1
	bcs.s	HitTest_SelectChampionRegion_Return
	cmpi.w	#$0050,d1
	bcc.s	HitTest_SelectChampionRegion_Return
	swap	d1
	cmpi.w	#$00AF,d1
	bcs.s	HitTest_SelectChampionRegion_Return
	cmpi.w	#$00C3,d1
	bcc.s	HitTest_SelectChampionRegion_Return
	move.w	#$0002,$000C(a5)
	clr.w	d2
HitTest_SelectChampionRegion_Return:		; Memory Address ($C61E) and binary offset [$C29A]
	tst.w	d2
	rts		

HitTest_ViewObjectRegion:		; Memory Address ($C622) and binary offset [$C29E]
	; Tests the View Object button rectangle and records its action index on a hit.
	move.l	$0002(a5),d1
	sub.w	$0008(a5),d1
	cmpi.w	#$0040,d1
	bcs.s	HitTest_ChampionSelectionPanel_NoHitReturn
	cmpi.w	#$0050,d1
	bcc.s	HitTest_ChampionSelectionPanel_NoHitReturn
	swap	d1
	cmpi.w	#$00C6,d1
	bcs.s	HitTest_ChampionSelectionPanel_NoHitReturn
	cmpi.w	#$00DA,d1
	bcc.s	HitTest_ChampionSelectionPanel_NoHitReturn
	move.w	#$0003,$000C(a5)
	clr.w	d2
HitTest_ChampionSelectionPanel_NoHitReturn:		; Memory Address ($C64C) and binary offset [$C2C8]
	tst.w	d2
	rts		

HitTest_SpellBookControls:		; Memory Address ($C650) and binary offset [$C2CC]
	; Resolves the spell-book top controls and eight rune hit targets.
	cmp.w	#$0002,$0014(a5)
	bne.s	HitTest_ChampionSelectionPanel_NoHitReturn
	move.l	$0002(a5),d1
	sub.w	$0008(a5),d1
	sub.w	#$0018,d1
	bcs.s	HitTest_SpellBookControls_TestExtraButtons
	cmpi.w	#$0020,d1
	bcc.s	HitTest_ChampionSelectionPanel_NoHitReturn
	swap	d1
	sub.w	#$00E8,d1
	bcs.s	HitTest_ChampionSelectionPanel_NoHitReturn
	moveq	#$00,d0
	sub.w	#$0020,d1
	bcs.s	HitTest_SpellBookControls_ResolvePageArrow
	sub.w	#$0010,d1
	bcs.s	HitTest_ChampionSelectionPanel_NoHitReturn
	addq.w	#$04,d0
HitTest_SpellBookControls_ResolvePageArrow:		; Memory Address ($C684) and binary offset [$C300]
	swap	d1
	lsr.w	#$03,d1
	add.w	d1,d0
	eor.w	#$0007,d0
	move.w	#$0005,$000C(a5)
	move.w	d0,$000E(a5)
	moveq	#$00,d2
	rts		

HitTest_SpellBookControls_TestExtraButtons:		; Memory Address ($C69C) and binary offset [$C318]
	add.w	#$0018,d1
	cmpi.w	#$0007,d1															;Rejects top-control Y values below $07; the following comparison limits the band to $07-$0F before the X hit tests.
	bcs.s	HitTest_SpellBookControls_Return
	cmpi.w	#$0010,d1
	bcc.s	HitTest_SpellBookControls_Return
	swap	d1
	cmpi.w	#$00E8,d1
	bcs.s	HitTest_SpellBookControls_Return
	moveq	#$06,d0
	cmpi.w	#$00F8,d1
	bcs.s	HitTest_SpellBookControls_StoreButtonHit
	cmpi.w	#$0100,d1
	bcs.s	HitTest_SpellBookControls_Return
	moveq	#$07,d0
	cmpi.w	#$0120,d1
	bcs.s	HitTest_SpellBookControls_StoreButtonHit
	cmpi.w	#$0128,d1
	bcs.s	HitTest_SpellBookControls_Return
	moveq	#$08,d0
	cmpi.w	#$0138,d1
	bcc.s	HitTest_SpellBookControls_Return
HitTest_SpellBookControls_StoreButtonHit:		; Memory Address ($C6D8) and binary offset [$C354]
	move.w	d0,$000C(a5)
	moveq	#$03,d2
	cmpi.w	#$0006,d0
	bne.s	HitTest_SpellBookControls_SetHitMode
	subq.w	#$02,$002A(a5)
	and.w	#$0007,$002A(a5)
	move.w	#$8003,d2
HitTest_SpellBookControls_SetHitMode:		; Memory Address ($C6F2) and binary offset [$C36E]
	rol.w	#$08,d0
	move.b	#$03,d0
	move.w	d0,$0014(a5)
	move.w	d2,$000E(a5)
	move.w	#$0008,$0022(a5)
	move.w	d0,d2
HitTest_SpellBookControls_Return:		; Memory Address ($C708) and binary offset [$C384]
	tst.w	d2
	rts		

HitTest_PreviewSpellRegion:		; Memory Address ($C70C) and binary offset [$C388]
	; Runs the spell-grid hit test only while champion selection is in spellbook
	; mode.
	cmp.w	#$0001,$0014(a5)
	bne.s	HitTest_SpellGridCell_Return
HitTest_SpellGridCell:		; Memory Address ($C714) and binary offset [$C390]
	; Tests the spell-rune grid and returns the selected row and column while
	; recording the preview action.
	move.l	$0002(a5),d1
	sub.w	$0008(a5),d1
	sub.w	#$0020,d1
	bcs.s	HitTest_SpellGridCell_Return
	cmpi.w	#$0020,d1
	bcc.s	HitTest_SpellGridCell_Return
	swap	d1
	sub.w	#$00E0,d1
	bcs.s	HitTest_SpellGridCell_Return
	move.w	#$0004,$000C(a5)
	lsr.w	#$04,d1
	move.w	d1,d2
	swap	d1
	sub.w	#$0010,d1
	bcs.s	HitTest_SpellGridCell_ResolveRow
	addq.w	#$06,d2
HitTest_SpellGridCell_ResolveRow:		; Memory Address ($C744) and binary offset [$C3C0]
	move.w	d2,$000E(a5)
HitTest_SpellGridCell_Return:		; Memory Address ($C748) and binary offset [$C3C4]
	tst.w	d2
	rts		

HitTest_ChampionRosterRow:		; Memory Address ($C74C) and binary offset [$C3C8]
	; Resolves the champion roster row under the pointer and rejects gaps or
	; positions outside the roster.
	move.l	$0002(a5),d1
	moveq	#-$01,d2
	moveq	#$0E,d3
HitTest_ChampionRosterRow_BandScanLoop:		; Memory Address ($C754) and binary offset [$C3D0]
	cmp.w	d3,d1
	bcs.s	HitTest_ChampionRosterRow_CheckRowRange
	addq.w	#$01,d2
	add.w	#$0030,d3
	bra.s	HitTest_ChampionRosterRow_BandScanLoop

HitTest_ChampionRosterRow_CheckRowRange:		; Memory Address ($C760) and binary offset [$C3DC]
	tst.w	d2
	bmi.s	HitTest_ChampionRosterRow_Return
	subq.w	#$07,d3
	cmp.w	d3,d1
	bcc.s	HitTest_ChampionRosterRow_SwapResult
	swap	d1
	cmpi.w	#$009E,d1
	bcc.s	HitTest_ChampionRosterRow_SwapResult
	moveq	#$27,d3
HitTest_ChampionRosterRow_ColumnScanLoop:		; Memory Address ($C774) and binary offset [$C3F0]
	cmp.w	d3,d1
	bcs.s	HitTest_ChampionRosterRow_RejectClaimed
	addq.w	#$04,d2
	add.w	#$0028,d3
	bra.s	HitTest_ChampionRosterRow_ColumnScanLoop

HitTest_ChampionRosterRow_RejectClaimed:		; Memory Address ($C780) and binary offset [$C3FC]
	sub.w	#$0009,d3
	cmp.w	d3,d1
	bcc.s	HitTest_ChampionRosterRow_SwapResult
	cmp.w	Player2_CurrentChampionNumber.l,d2
	beq.s	HitTest_ChampionRosterRow_Return
	cmp.w	Player1_CurrentChampionNumber.l,d2
	beq.s	HitTest_ChampionRosterRow_Return
	move.l	a5,d0
	eor.l	#Player1_Data,d0
	eor.l	#Player2_Data,d0
	move.l	d0,a0
	cmp.w	#$0001,$000C(a0)
	bne.s	HitTest_ChampionRosterRow_SetHitAction
	cmp.w	$000E(a0),d2
	beq.s	HitTest_ChampionRosterRow_Return
HitTest_ChampionRosterRow_SetHitAction:		; Memory Address ($C7B6) and binary offset [$C432]
	move.w	d2,$000E(a5)
	move.w	#$0001,$000C(a5)
	moveq	#$00,d2
HitTest_ChampionRosterRow_SwapResult:		; Memory Address ($C7C2) and binary offset [$C43E]
	swap	d2
HitTest_ChampionRosterRow_Return:		; Memory Address ($C7C4) and binary offset [$C440]
	tst.w	d2
	rts		

Prepare_AndDrawSpellBookSurface:		; Memory Address ($C7C8) and binary offset [$C444]
	; Draws the packed spell-book surface and selects the current champion record.
	move.w	$0006(a5),d7
	move.l	screen_ptr.l,a0
	add.w	#$0184,a0
	add.w	$000A(a5),a0
	move.l	#$00000070,a3
	move.l	#$0005003D,d5														;Long Addr replaced with Symbol
	lea		GFX_Pockets+$4100.l,a1
	bsr		Draw_PlanarGraphic
	asl.w	#$05,d7
	lea		Character_Stats_DataTable.l,a4
	add.w	d7,a4
	rts		

Clear_SpellBookPanel:		; Memory Address ($C7FC) and binary offset [$C478]
	; Clears the 96-pixel spell-book panel before redrawing it.
	move.l	#$005E00E0,d4
	move.l	#$00480009,d5
	add.w	$0008(a5),d5
	moveq	#$00,d3
	bra		BW_draw_bar

Draw_SpellPointValues:		; Memory Address ($C812) and binary offset [$C48E]
	; Formats and prints the current and maximum spell-point values.
	move.l	screen_ptr.l,a0
	add.w	#$0E2C,a0
	add.w	$000A(a5),a0
Print_SpellPointsText:		; Memory Address ($C820) and binary offset [$C49C]
	; Formats and prints the selected champion's current and maximum spell points.
	bsr		Load_CurrentChampionStatRecord
	or.b	#$0C,$0054(a5)
	move.b	ChampionStat_SpellPointsCurrent(a4),d0								;Loads the champion's current spell points for the SP.PTS value.
	bsr		Convert_ByteToDecimalText
	move.b	ChampionStat_SpellPointsMaximum(a4),d0								;Loads the champion's maximum spell points for the SP.PTS value.
	lea		SpellPointsMessageTemplate.l,a6
	move.b	d1,$000E(a6)
	ror.w	#$08,d1
	move.b	d1,$000D(a6)
	bsr		Convert_ByteToDecimalText
	move.w	d1,$0010(a6)
	bra		Print_fflim_text

Draw_SpellBookPanel:		; Memory Address ($C852) and binary offset [$C4CE]
	; Draws the champion-selection spellbook panel and prints the spell-points
	; label below it; this path omits the in-game casting/detail icon row.
	bsr.s	Clear_SpellBookPanel
	bsr		Prepare_AndDrawSpellBookSurface
	add.w	#$00A0,a0
	bsr.s	Print_SpellPointsText
Draw_SpellBookPageSpread:		; Memory Address ($C85E) and binary offset [$C4DA]
	; Draws both rune pages in the currently selected spellbook spread.
	move.w	$002A(a5),d0
	bsr.s	Draw_SpellBookRunePage
	move.w	$002A(a5),d0
	addq.w	#$01,d0
Draw_SpellBookRunePage:		; Memory Address ($C86A) and binary offset [$C4E6]
	; Draws one of eight 16-byte rune pages as four rows of four lowercase GameFont
	; glyphs, using champion ownership bits to choose missing, selected, or
	; profession-coloured ink.
	or.b	#$04,$0054(a5)
	move.w	d0,d7
	asl.w	#$04,d0
	lea		SpellBookRunes.l,a6
	add.w	d0,a6
	move.l	screen_ptr.l,a0
	add.w	#$042D,a0
	add.w	$000A(a5),a0
	move.w	#$0003,CurrentTextBackgroundInk.l
	move.w	d7,d0
	lsr.w	#$01,d0
	move.l	a4,a3
	add.w	d0,a3
	move.w	d7,d0
	asl.w	#$02,d7
	swap	d7
	and.w	#$0001,d0
	bne.s	Draw_SpellBookRunePage_RightColumnSetup
	move.w	#$0007,d7
Draw_SpellBookRunePage_LeftColumnRowLoop:		; Memory Address ($C8AA) and binary offset [$C526]
	bsr.s	Select_SpellRuneInk
	move.w	d6,CurrentTextInk.l
	moveq	#$02,d6
Draw_SpellBookRunePage_LeftColumn_GlyphLoop:		; Memory Address ($C8B4) and binary offset [$C530]
	move.b	(a6)+,d0
	bsr		Draw_TextGlyph
	dbra	d6,Draw_SpellBookRunePage_LeftColumn_GlyphLoop
	sub.w	#$0028,a0
	move.b	(a6)+,d0
	bsr		Draw_TextGlyph
	add.w	#$0164,a0															;Moves from one left-page rune entry to the next: eight screen rows down and back to the left text column.
	subq.w	#$01,d7
	cmpi.w	#$0004,d7
	bcc.s	Draw_SpellBookRunePage_LeftColumnRowLoop
	rts		

Draw_SpellBookRunePage_RightColumnSetup:		; Memory Address ($C8D6) and binary offset [$C552]
	sub.w	#$0022,a0
	move.w	#$0003,d7
Draw_SpellBookRunePage_RightColumnRowLoop:		; Memory Address ($C8DE) and binary offset [$C55A]
	bsr.s	Select_SpellRuneInk
	move.w	d6,CurrentTextInk.l
	move.b	(a6)+,d0
	bsr		Draw_TextGlyph
	add.w	#$0028,a0
	moveq	#$02,d6
Draw_SpellBookRunePage_RightColumn_GlyphLoop:		; Memory Address ($C8F2) and binary offset [$C56E]
	move.b	(a6)+,d0
	bsr		Draw_TextGlyph
	dbra	d6,Draw_SpellBookRunePage_RightColumn_GlyphLoop
	add.w	#$0114,a0															;Moves from one right-page rune entry to the next after the separately placed first rune glyph.
	dbra	d7,Draw_SpellBookRunePage_RightColumnRowLoop
	rts		

Select_SpellRuneInk:		; Memory Address ($C906) and binary offset [$C582]
	; Returns the missing-rune ink, selected-rune ink, or spell-class ink for a
	; spell-book rune glyph.
	moveq	#$01,d6
	btst	d7,$000C(a3)														;Tests this page entry's ownership bit in the champion's four spell-book bytes at $0C-$0F; clear entries use grey ink.
	beq.s	Select_SpellRuneInk_Exit
	swap	d7
	move.w	d7,d6
	swap	d7
	move.w	d7,d0
	not.w	d0
	and.w	#$0003,d0
	add.w	d6,d0
	and.w	#$001F,d0
	moveq	#$0E,d6
	cmp.b	$0013(a4),d0
	beq.s	Select_SpellRuneInk_Exit
	bsr		Character_GetClassIndex
	move.b	SpellClassInkTable(pc,d0.w),d6										;Maps Serpent, Chaos, Dragon and Moon class indices to palette inks $06, $0D, $0C and $07 for available runes.
Select_SpellRuneInk_Exit:		; Memory Address ($C932) and binary offset [$C5AE]
	rts		

SpellClassInkTable:		; Memory Address ($C934) and binary offset [$C5B0]
	; Four profession-class ink values used when drawing spellbook rune glyphs.
	dc.b	$06	;06
	dc.b	$0D	;0D
	dc.b	$0C	;0C
	dc.b	$07	;07

Draw_InventoryPanel:		; Memory Address ($C938) and binary offset [$C5B4]
	; Clears the spell-book panel, draws inventory title and armour bars with chain
	; decorations, then composes pockets and the inspected champion name.
	move.w	d7,-(sp)
	bsr		Clear_SpellBookPanel												;Clears the mutually exclusive spell-book panel before composing the inventory panel.
	move.l	#$005D00E2,d4														;Supplies BW_draw_bar with the inventory title bar X=$E2 and DBRA width $5D, producing 94 pixels through X=$13F.
	move.l	#$00070018,d5														;Supplies the inventory title bar Y=$18 and DBRA height $07, producing eight rows through Y=$1F.
	add.w	$0008(a5),d5
	moveq	#$03,d3
	bsr		BW_draw_bar
	move.w	#$0040,d5															;Selects the armour bar Y=$40 after the title bar has been drawn.
	add.w	$0008(a5),d5
	bsr		BW_draw_bar
	move.w	(sp)+,d7
	move.l	#$0000029C,a0														;Uses screen offset $029C for the upper GFX_Pockets inventory-chain strip; this resolves to player-local X=$E0/Y=$10.
	bsr		Draw_InventoryPanelChainStrip
	move.l	#$00000B5C,a0														;Uses screen offset $0B5C for the lower GFX_Pockets inventory-chain strip; this resolves to player-local X=$E0/Y=$48.
	bsr		Draw_InventoryPanelChainStrip
	bsr		Draw_InventoryPocketSlots											;Draws all twelve inventory positions after the title, armour bar, and two chain decorations are established.
	lea		InventoryPanelHeaderTemplate.l,a6									;Selects the inventory title Print_fflim_text template. Its text cell is later overwritten with the inspected champion name by the inventory redraw path.
	bsr		Print_fflim_text
Draw_InventoryArmourRating:		; Memory Address ($C984) and binary offset [$C600]
	; Calculates the inspected champion’s armour modifier and formats its signed
	; ARMOUR value for printing.
	move.w	d7,d0
	bsr		Load_ChampionStatRecord
	move.w	d7,d0
	bsr		Calculate_CharacterArmourLevel										;Calculates the selected champion's effective armour level before the inventory modifier is formatted.
	move.b	#$2B,d1																;Initialises the armour modifier sign character to '+'.
	moveq	#$0A,d0																;Starts the displayed armour modifier from baseline 10; the calculated armour level is subtracted to produce the signed three-character result.
	sub.b	d3,d0
	bpl.s	InventoryArmourRating_FormatValue
	move.b	#$2D,d1																;Uses '-' instead when the calculated armour modifier is negative.
	neg.b	d0
InventoryArmourRating_FormatValue:		; Memory Address ($C9A0) and binary offset [$C61C]
	lea		ArmourHeaderMessageTemplate.l,a6									;Selects the writable ARMOUR text template whose last three characters receive the sign and decimal digits.
	move.b	d1,$000C(a6)
	bsr		Convert_ByteToDecimalText											;Converts the absolute armour difference into the two decimal characters stored in the inventory ARMOUR template.
	move.b	d1,$000E(a6)
	ror.w	#$08,d1
	move.b	d1,$000D(a6)
	bra		Print_fflim_text

Draw_InventoryPocketSlots:		; Memory Address ($C9BC) and binary offset [$C638]
	; Draws the selected champion's twelve inventory pocket slots.
	move.l	a4,-(sp)
	move.l	screen_ptr.l,a0
	add.w	#$051C,a0															;Starts the first six inventory slots at screen offset $051C, player-local X=$E0/Y=$20.
	add.w	$000A(a5),a0
	move.w	d7,d0
	asl.w	#$04,d0																;Converts the champion ID to its 16-byte PocketContents record offset.
	lea		Character_Pockets_DataTable.l,a4
	add.w	d0,a4
	swap	d7
	clr.w	d7
Draw_InventoryPocketSlotLoop:		; Memory Address ($C9DC) and binary offset [$C658]
	; Iterates over the selected champion’s twelve inventory positions, choosing an
	; empty-slot template or the contained object graphic.
	moveq	#$00,d0
	move.b	$00(a4,d7.w),d0
	bne.s	InventoryPocketSlot_CheckItemCount
	cmpi.w	#$0002,d7
	bcc.s	Select_EmptyInventorySlotGraphic
	swap	d7
	move.w	d7,d0
	swap	d7
	asl.w	#$05,d0
	lea		Character_Stats_DataTable.l,a1
	add.w	d0,a1
	moveq	#$00,d0
	move.b	$0012(a1),d0
	beq.s	Select_EmptyInventorySlotGraphic
	lea		Object_Definition_Table+$01.l,a1
	asl.w	#$02,d0
	move.b	$00(a1,d0.w),d3
	moveq	#$1A,d0
	add.w	d7,d0
	bra.s	InventoryPocketSlot_DrawGraphic

Select_EmptyInventorySlotGraphic:		; Memory Address ($CA14) and binary offset [$C690]
	; Selects the semantic empty hand, armour, shield, or pocket picture and the
	; player secondary UI colour.
	move.w	$0012(a5),d3														;Loads the secondary UI colour used to recolour empty hand, armour, shield, and pocket template graphics.
	cmpi.w	#$0004,d7
	bcc.s	InventoryPocketSlot_DrawGraphic
	move.w	d7,d0
	cmpi.w	#$0003,d7
	bne.s	EmptyInventorySlot_AddGraphicBankOffset
	btst	#$10,d7
	beq.s	EmptyInventorySlot_AddGraphicBankOffset
	addq.w	#$01,d0
EmptyInventorySlot_AddGraphicBankOffset:		; Memory Address ($CA2E) and binary offset [$C6AA]
	add.w	#$006C,d0
InventoryPocketSlot_DrawGraphic:		; Memory Address ($CA32) and binary offset [$C6AE]
	bsr		Draw_PocketGraphic
	bra.s	InventoryPocketSlotLoop_AdvanceIndex

InventoryPocketSlot_CheckItemCount:		; Memory Address ($CA38) and binary offset [$C6B4]
	cmpi.w	#$0005,d0
	bcc.s	InventoryPocketSlot_DrawItemGraphic
	move.b	$0B(a4,d0.w),d1
	bne.s	InventoryPocketSlot_DrawItemGraphic
	clr.b	$00(a4,d7.w)
	bra.s	Draw_InventoryPocketSlotLoop

InventoryPocketSlot_DrawItemGraphic:		; Memory Address ($CA4A) and binary offset [$C6C6]
	bsr.s	ObjectGraphic
InventoryPocketSlotLoop_AdvanceIndex:		; Memory Address ($CA4C) and binary offset [$C6C8]
	addq.w	#$01,d7
	cmpi.w	#$0006,d7															;After six slots, advances the destination to the second inventory row.
	bne.s	InventoryPocketSlotLoop_CheckDone
	add.w	#$0274,a0															;After the sixth 16-pixel pocket, advances to the second six-slot row at player-local Y=$30.
InventoryPocketSlotLoop_CheckDone:		; Memory Address ($CA58) and binary offset [$C6D4]
	cmpi.w	#$000C,d7															;Ends the loop after rendering the twelve hand, armour, shield, and ordinary pocket slots.
	bcs		Draw_InventoryPocketSlotLoop
	swap	d7
	move.l	(sp)+,a4
	rts		

ObjectGraphic:		; Memory Address ($CA66) and binary offset [$C6E2]
	; Resolves and draws a held or pocket object's graphic, including the
	; empty-slot image, counted objects, and substitution of a depleted ring's
	; generic used-up sprite.
	tst.w	d0
	beq		Draw_PocketGraphic
	cmpi.w	#$0005,d0
	bcs.s	NumberedObject
	cmpi.w	#$0069,d0
	bcs.s	.SkipRings
	cmpi.w	#$006D,d0
	bcc.s	.SkipRings
	move.w	d0,d3
	sub.w	#$0069,d3
	lea		RingUses.l,a1
	tst.b	$00(a1,d3.w)
	bpl.s	.SkipRings
	moveq	#$68,d0
.SkipRings:		; Memory Address ($CA92) and binary offset [$C70E]
	asl.w	#$02,d0
	lea		Object_Definition_Table.l,a1
	moveq	#$00,d3
	move.b	$01(a1,d0.w),d3
	move.b	$00(a1,d0.w),d0
	bra.s	Draw_PocketGraphic

NumberedObject:		; Memory Address ($CAA6) and binary offset [$C722]
	move.l	a0,-(sp)
	move.w	d0,-(sp)
	move.b	d1,d0
	bsr		Convert_ByteToDecimalText
	move.w	d1,NumericMessageScratchBuffer.l
	move.w	(sp),d0
	bsr.s	Draw_PocketGraphic
	move.l	$0002(sp),a0
	add.w	#$0050,a0
	cmp.w	#$0003,(sp)+
	bcs.s	NumberedObject_PrintCountText
	add.w	#$0118,a0
NumberedObject_PrintCountText:		; Memory Address ($CACC) and binary offset [$C748]
	lea		NumericMessageScratchBuffer.l,a6
	move.l	#$00060000,CurrentTextInk.l
	bsr		Print_fflim_text
	move.l	(sp)+,a0
	addq.w	#$02,a0
	rts		

NumericMessageScratchBuffer:		; Memory Address ($CAE6) and binary offset [$C762]
	; Small shared text buffer used for patched decimal output and short generated
	; messages.
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
NullString:
	dc.b	$FF	;FF

Draw_PocketGraphic:		; Memory Address ($CAEA) and binary offset [$C766]
	; Resolves a GFX_Pockets picture index and enters the common four-plane
	; renderer.
	move.l	#$00000098,a3
	lea		GFX_Pockets.l,a1
	and.w	#$00FF,d0
Select_PocketGraphicBank:		; Memory Address ($CAFA) and binary offset [$C776]
	; Locates the containing 20-picture GFX_Pockets bank for a requested pocket
	; graphic before calculating its source offset.
	cmpi.b	#$14,d0																;Splits the Pockets.gfx picture index into 20-icon banks before converting the in-bank index to a source offset.
	bcs.s	PocketGraphicBank_ComputeOffsetAndDraw
	add.w	#$0A00,a1															;Advances one 20-icon Pockets.gfx bank (20 x $80 bytes) for picture indices at or above $14.
	sub.w	#$0014,d0
	bra.s	Select_PocketGraphicBank

PocketGraphicBank_ComputeOffsetAndDraw:		; Memory Address ($CB0A) and binary offset [$C786]
	asl.w	#$03,d0																;Converts the in-bank picture index to its 16x16 four-plane source offset.
	add.w	d0,a1
	movem.l	a0/a6,-(sp)
	bsr.s	Draw_ChampionStatsScrollDecoration
	movem.l	(sp)+,a0/a6
	addq.w	#$02,a0
	rts		

Draw_ChampionStatsScrollDecoration:		; Memory Address ($CB1C) and binary offset [$C798]
	; Supplies a 15-row height and tail-calls the planar graphic renderer for the
	; champion-statistics scroll decoration.
	move.l	#$0000000F,-(sp)
	jmp		Draw_PlanarGraphicCore.l

Draw_ChampionStats_DefaultPosition:		; Memory Address ($CB28) and binary offset [$C7A4]
	; Sets the default scroll Y position to $2A, then enters Draw_ChampionStats.
	moveq	#$2A,d5
Draw_ChampionStats:		; Memory Address ($CB2A) and binary offset [$C7A6]
	; Draws the scroll frame, inserts fields from the selected 32-byte champion
	; record into ChampionStatsScroll_TextTemplate, then calls Print_fflim_text. D5
	; supplies the scroll Y position.
	move.w	PlayerData_CurrentChampionNumber(a5),-(sp)							;Saves the current leader champion ID while the generic scroll frame is drawn.
	bsr		Draw_ScrollFrame													;Calls the shared scroll-frame drawing routine before printing champion statistics.
	move.w	(sp),d0
	lea		ChampionStatsScroll_TextTemplate.l,a6								;Selects the stats Print_fflim_text stream. Its $FC commands place LEVEL and the ST, IN, HP, and VI rows at consecutive eight-pixel text rows $03-$07.
	asl.w	#ChampionStat_RecordSizeShift,d0									;Converts the champion ID to its 32-byte Character_Stats_DataTable record offset.
	lea		Character_Stats_DataTable.l,a0
	add.w	d0,a0
	lea		ChampionStatsScroll_FieldAndTextOffsets.l,a2
	moveq	#ChampionStatsScroll_FieldCount-1,d7
	moveq	#$00,d0
ChampionStats_InsertFieldsLoop:		; Memory Address ($CB4E) and binary offset [$C7CA]
	; Copies seven champion fields into their corresponding positions within the
	; writable formatted-text template.
	move.b	$00(a2,d7.w),d0														;Loads one source-field offset from the seven-entry champion-statistics scroll lookup table.
	move.b	$00(a0,d0.w),d0														;Reads the selected champion statistic identified by the lookup entry.
	bsr		Convert_ByteToDecimalText											;Converts the binary champion statistic to its printable decimal digits.
	move.b	$07(a2,d7.w),d0
	move.b	d1,$01(a6,d0.w)
	ror.w	#$08,d1
	move.b	d1,$00(a6,d0.w)
	dbra	d7,ChampionStats_InsertFieldsLoop									;Repeats for all seven lookup-defined champion-statistic fields.
	move.w	(sp)+,d7
	move.b	ChampionStat_HitPointsCurrent(a0),d0
	divu	#$0064,d0
	tst.w	d0
	bne.s	ChampionStats_HPCurrent_HundredsToAscii
	move.b	#$F0,d0
ChampionStats_HPCurrent_HundredsToAscii:		; Memory Address ($CB7E) and binary offset [$C7FA]
	add.b	#$30,d0
	move.b	d0,$0049(a6)
	swap	d0
	bsr		Convert_ByteToDecimalText
	move.w	d1,$004A(a6)
	move.b	#$20,$0053(a6)
	moveq	#$51,d2
	moveq	#$00,d0
	move.b	ChampionStat_HitPointsMaximum(a0),d0
	divu	#$0064,d0
	tst.b	d0
	beq.s	ChampionStats_HPMax_WriteDigitPair
	add.b	#$30,d0
	move.b	d0,$00(a6,d2.w)
	addq.w	#$01,d2
ChampionStats_HPMax_WriteDigitPair:		; Memory Address ($CBB0) and binary offset [$C82C]
	swap	d0
	bsr		Convert_ByteToDecimalText
	move.b	d1,$01(a6,d2.w)
	ror.w	#$08,d1
	move.b	d1,$00(a6,d2.w)
	bra		Print_fflim_text													;Prints the completed champion-statistics scroll text template after all values have been inserted.

ChampionStatsScroll_FieldAndTextOffsets:		; Memory Address ($CBC4) and binary offset [$C840]
	; Two parallel seven-byte tables: champion-record field offsets followed by
	; destination offsets within ChampionStatsScroll_TextTemplate.
	INCBIN "/data/BLOODWYCH439-clean/data/champion-stats-scroll.lookup"
ChampionStatsScroll_TextTemplate:		; Memory Address ($CBD2) and binary offset [$C84E]
	; Writable Print_fflim_text command stream for the stats scroll. $FC sets
	; coordinates, $FE ink, $FD background and $FF terminates; runtime code inserts
	; the selected champion’s values.
	INCBIN "/data/BLOODWYCH439-clean/data/champion-stats-scroll.text"

Draw_ScrollFrame:		; Memory Address ($CC3A) and binary offset [$C8B6]
	; Generic scroll-frame renderer used outside the champion screen too. Draws
	; colour-$3 background, 96x15 caps and 16x58 sides at X offsets 0 and 80;
	; applies player-specific screen offsets.
	or.b	#$0C,$0054(a5)
	swap	d5
	move.w	#$0018,d5															;Sets the scroll-frame background rectangle to player-local Y=$18 while preserving the caller-provided scroll Y in the other word of D5.
	add.w	$0008(a5),d5
	move.l	#$003F00F0,d4														;Packs the scroll-frame background X=$F0 and horizontal terminal count $3F, producing a 64-pixel-wide fill.
	moveq	#$03,d3
	bsr		BW_draw_bar															;Calls the filled-rectangle drawing routine for the scroll-frame background.
	sub.l	a3,a3
	lea		GFX_Scroll_Edge_Left.l,a1											;Selects the pre-drawn left scroll edge graphic.
	move.l	screen_ptr.l,a0
	add.w	#$03DC,a0															;Positions the left scroll edge at its player-local framebuffer offset.
	add.w	$000A(a5),a0
	clr.w	d5
	swap	d5
	move.l	d5,-(sp)
	bsr.s	Draw_PlanarGraphic													;Calls the common four-plane graphic renderer for one scroll-frame edge or cap.
	move.l	(sp)+,d5
	lea		GFX_Scroll_Edge_Right.l,a1											;Selects the pre-drawn right scroll edge graphic.
	move.l	screen_ptr.l,a0
	add.w	#$03E6,a0															;Positions the right scroll edge at its player-local framebuffer offset.
	add.w	$000A(a5),a0
	bsr.s	Draw_PlanarGraphic													;Calls the common four-plane graphic renderer for one scroll-frame edge or cap.
	sub.w	#$000A,a0
	lea		GFX_Scroll_Edge_Bottom.l,a1											;Selects the pre-drawn bottom scroll cap graphic.
	move.l	#$0005000E,d5														;Long Addr replaced with Symbol
	bsr.s	Draw_PlanarGraphic													;Calls the common four-plane graphic renderer for one scroll-frame edge or cap.
	lea		GFX_Scroll_Edge_Top.l,a1											;Selects the pre-drawn top scroll cap graphic.
	move.l	screen_ptr.l,a0
	add.w	#$0184,a0
	add.w	$000A(a5),a0
	move.l	#$0005000E,d5														;Long Addr replaced with Symbol
Draw_PlanarGraphic:		; Memory Address ($CCB8) and binary offset [$C934]
	; Pushes the packed DBRA width/height counts from D5 and enters the generic
	; four-plane graphic renderer.
	move.l	d5,-(sp)
	bra		Draw_PlanarGraphicCore

Draw_MainChampionAvatarPanel:		; Memory Address ($CCBE) and binary offset [$C93A]
	; Composes the main champion panel from its outer bevel, large portrait, and
	; optional inner frame.
	move.l	#$002F0000,d4														;Sets outer avatar-panel X=$00 and horizontal terminal count $2F, producing a $30-pixel width.
	moveq	#$0A,d5																;Sets the outer avatar-panel top edge to player-local Y=$0A.
	bsr		Draw_BevelledPanelFrame												;Calls the shared bevelled-panel renderer for the large avatar background and three inset grey outlines.
	move.w	$0006(a5),d7														;Loads the current leader champion ID for the large-avatar graphic selection.
	moveq	#-$01,d4															;Passes the large-avatar rendering sentinel to the avatar compositor.
	move.l	#MainChampionAvatar_ScreenByteOffset,a0								;Selects screen byte offset $02A9, which resolves to player-local portrait coordinate ($08,$11).
	bsr.s	Draw_ChampionLargeAvatar											;Draws only the 32 by 30 champion portrait; the surrounding frames are separate procedural stages.
Draw_MainChampionAvatarInnerFrame:		; Memory Address ($CCD8) and binary offset [$C954]
	; Draws the inner large-avatar outline unless the current player state
	; suppresses it.
	btst	#$00,$003E(a5)														;Suppresses the large-avatar inner frame while the main champion presentation bit is active.
	bne.s	AvatarFrame_SharedSkipReturn
	or.b	#$01,$0054(a5)
	move.l	#$0021000F,d5														;Sets inner-frame Y=$0F and vertical terminal count $21, producing a $22-pixel height.
	add.w	$0008(a5),d5
	move.l	#$00230006,d4														;Sets inner-frame X=$06 and horizontal terminal count $23, producing a $24-pixel width.
	moveq	#$01,d3
	bsr.s	Select_ChampionShieldInkColour										;Obtains the leader class colour used for the optional large-avatar inner-frame ink.
	bra		BW_draw_frame														;Draws the optional inner outline after the portrait, using the default or worn-spell-selected ink.

Select_ChampionShieldInkColour:		; Memory Address ($CCFE) and binary offset [$C97A]
	; Map champion-record byte $11 to the palette ink replacing shield-surround
	; index $F.
	move.w	d7,d0
	bsr		Load_ChampionStatRecord
	move.b	ChampionStat_WornSpell(a4),d0										;Reads the currently worn spell; zero leaves the normal light-grey shield-surround ink unchanged.
	beq.s	AvatarFrame_SharedSkipReturn
	and.w	#$0007,d0															;Uses the worn spell's low three bits to select one of eight shield-surround ink colours.
	move.b	ChampionShieldInkColourLookup(pc,d0.w),d3
AvatarFrame_SharedSkipReturn:		; Memory Address ($CD12) and binary offset [$C98E]
	rts		

ChampionShieldInkColourLookup:		; Memory Address ($CD14) and binary offset [$C990]
	; Eight palette indices selected using the low three bits of champion-record
	; byte $11.
	dc.b	$06	;06
	dc.b	$0D	;0D
	dc.b	$06	;06
	dc.b	$08	;08
	dc.b	$06	;06
	dc.b	$06	;06
	dc.b	$0D	;0D
	dc.b	$08	;08

Draw_ChampionLargeAvatar:		; Memory Address ($CD1C) and binary offset [$C998]
	; Selects and draws one 32×30 large champion avatar.
	add.l	screen_ptr.l,a0														;Converts the avatar-local framebuffer offset to an address in the active player screen buffer.
	add.w	$000A(a5),a0
	lea		GFX_Avatars_Large.l,a1												;Selects the packed large champion portrait graphics source.
	move.w	d7,d0
	asl.w	#$05,d0																;Begins converting the champion ID to its portrait-record source offset.
	sub.w	d7,d0
	sub.w	d7,d0
	asl.w	#$04,d0
	add.w	d0,a1
	move.l	#ChampionLargeAvatar_DrawDimensions,-(sp)							;Supplies the large portrait renderer with a two-word-wide, 30-row graphic size.
	sub.l	a3,a3
	tst.w	d4
	bne		Draw_PlanarGraphicCore
	bra		Draw_PlanarGraphicCore												;Enters the common four-plane renderer with the resolved avatar source and destination.

Get_ChampionShieldScreenPosition:		; Memory Address ($CD4A) and binary offset [$C9C6]
	; Calculates the screen destination for a champion shield/avatar slot.
	move.w	d7,d5
	and.w	#$0003,d5
	move.w	d5,d0
	add.w	d0,d5
	add.w	d0,d5
	asl.w	#$04,d5
	add.w	#$000F,d5
	mulu	#$0028,d5
	move.w	d7,d0
	and.w	#$000C,d0
	move.w	d0,d1
	lsr.w	#$02,d1
	add.w	d1,d0
	add.w	d5,d0
	move.l	screen_ptr.l,a0
	add.w	d0,a0
	rts		

Draw_SelectedChampionClickedShield:		; Memory Address ($CD78) and binary offset [$C9F4]
	; Draws the opaque clicked-shield template for the newly selected champion.
	lea		GFX_Shield_Clicked.l,a1
	sub.l	a3,a3
	bsr.s	Get_ChampionShieldScreenPosition
	move.l	#$00010028,d5														;Long Addr replaced with Symbol
	bra		Draw_ShieldPlanarGraphic

ChampionSelection:		; Memory Address ($CD8C) and binary offset [$CA08]
	; Iterates champion indices 15 down to 0 and draws all sixteen shield portraits
	; at their selection-screen positions.
	moveq	#$0F,d7
.ChampionSelection_Loop:		; Memory Address ($CD8E) and binary offset [$CA0A]
	bsr.s	Draw_Select_Avatars
	dbra	d7,.ChampionSelection_Loop
ExitAvatarDrawing:		; Memory Address ($CD94) and binary offset [$CA10]
	rts		

Draw_Select_Avatars:
	; Rejects champion indices outside 0-15, otherwise resolves the shield position
	; and enters the champion-selection avatar renderer.
	cmpi.w	#$0010,d7
	bcc.s	ExitAvatarDrawing
	bsr.s	Get_ChampionShieldScreenPosition
	moveq	#$04,d3
Draw_ShieldAvatar:		; Memory Address ($CDA0) and binary offset [$CA1C]
	; Composes a champion shield avatar from its top, avatar, class-mask, and
	; bottom planar components.
	move.l	#DeadPartyShieldClassColourMask,d0									;Long Addr replaced with Symbol
	tst.w	d3																	;Keeps the fixed dead mask when D3 is zero; living shields replace it with a ClassColours record.
	beq.s	Store_ShieldClassColourMask
	lea		ClassColours.l,a6
	move.w	d7,d0
	bsr		Character_GetClassIndex
	asl.w	#$02,d0
	move.l	$00(a6,d0.w),d0
Store_ShieldClassColourMask:		; Memory Address ($CDBC) and binary offset [$CA38]
	; Store the normal professional-symbol mask or fixed dead mask before drawing
	; the shield components.
	lea		Buffer_Colour_Mask.l,a6
	move.l	d0,(a6)
	sub.l	a3,a3
	lea		GFX_Shield_Top.l,a1
	move.l	#$00010004,d5														;Long Addr replaced with Symbol
	bsr		Draw_ShieldPlanarGraphic
	lea		GFX_Avatars_Small.l,a1
	move.w	d7,d0
	asl.w	#$08,d0
	add.w	d0,a1
	move.l	#$0001000F,d5														;Long Addr replaced with Symbol
	bsr.s	Draw_ShieldPlanarGraphic
	lea		GFX_Shield_Classes.l,a1
	move.w	d7,d0
	and.w	#$0003,d0
	move.w	d0,d1
	asl.w	#$03,d0
	add.w	d1,d0
	add.w	d1,d0
	add.w	d1,d0
	asl.w	#$04,d0
	add.w	d0,a1
	move.l	#$1000A,d5
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l									;Enables four-colour remapping only for the professional symbol; the face avatar is never passed through this mask.
	bsr.s	Draw_ShieldPlanarGraphic
	clr.w	Buffer_Colour_Mask_Toggle.l											;Disables four-colour remapping immediately after the professional symbol has been drawn.
	lea		GFX_Shield_Bottom.l,a1
	move.l	#$00010008,d5														;Long Addr replaced with Symbol
Draw_ShieldPlanarGraphic:		; Memory Address ($CE26) and binary offset [$CAA2]
	; Enters the generic template-colour planar renderer after preserving the
	; packed shield width and height counts.
	move.l	d5,-(sp)
Draw_PlanarGraphicCore:		; Memory Address ($CE28) and binary offset [$CAA4]
	; Draws packed four-plane graphic rows and applies the supplied template colour
	; index.
	move.l	(sp)+,d5
PlanarGraphicCore_RowLoop:		; Memory Address ($CE2A) and binary offset [$CAA6]
	swap	d5
	move.w	d5,-(sp)
PlanarGraphicCore_ColumnLoop:		; Memory Address ($CE2E) and binary offset [$CAAA]
	move.l	(a1)+,d0
	move.l	(a1)+,d1
	tst.w	Buffer_Colour_Mask_Toggle.l
	beq.s	PlanarGraphicCore_ReplaceInk15
	bsr		Remap_PlanarSpriteColours
PlanarGraphicCore_ReplaceInk15:		; Memory Address ($CE3E) and binary offset [$CABA]
	bsr		Replace_PlanarInk15WithColour
	move.b	d1,$5DC1(a0)
	swap	d1
	move.b	d1,$3E81(a0)
	ror.l	#$08,d1
	move.b	d1,$3E80(a0)
	swap	d1
	move.b	d1,$5DC0(a0)
	move.b	d0,$1F41(a0)
	swap	d0
	move.b	d0,$0001(a0)
	ror.l	#$08,d0
	move.b	d0,(a0)
	swap	d0
	move.b	d0,$1F40(a0)
	addq.w	#$02,a0
	dbra	d5,PlanarGraphicCore_ColumnLoop
	move.w	(sp)+,d5
	sub.w	d5,a0
	sub.w	d5,a0
	add.w	#$0026,a0
	add.w	a3,a1
	swap	d5
	dbra	d5,PlanarGraphicCore_RowLoop
	rts		

Replace_PlanarInk15WithColour:		; Memory Address ($CE86) and binary offset [$CB02]
	; Replaces source palette-index $F pixels with the four-bit colour index
	; supplied in D3.
	move.l	d1,d2
	and.l	d0,d2
	swap	d2
	and.l	d0,d2
	and.l	d1,d2
	lea		Bitplane_Mask.l,a2
	move.w	d3,d6																;Begins converting the supplied colour index into bitplane masks that replace source ink $F pixels.
	and.w	#$000C,d6
	move.l	$00(a2,d6.w),d6
	move.w	d3,d4
	asl.w	#$02,d4
	and.w	#$000C,d4
	move.l	$00(a2,d4.w),d4
	and.l	d2,d4
	and.l	d2,d6
	not.l	d2
	and.l	d2,d0
	and.l	d2,d1
	or.l	d4,d0
	or.l	d6,d1
	rts		

ConvertByteToDecimal_HighNibbleAdjustments:		; Memory Address ($CEBC) and binary offset [$CB38]
	; Adjustment table used while converting a binary byte into printable decimal
	; digits.
	dc.b	$00	;00
	dc.b	$16	;16
	dc.b	$32	;32
	dc.b	$48	;48
	dc.b	$64	;64
	dc.b	$80	;80
	dc.b	$96	;96
	dc.b	$00	;00

Convert_ByteToDecimalText:		; Memory Address ($CEC4) and binary offset [$CB40]
	; Converts the byte in D0 into two ASCII decimal digits returned in D1 for
	; insertion into formatted text.
	move.b	d0,d1
	lsr.b	#$04,d1
	and.w	#$000F,d1
	move.b	ConvertByteToDecimal_HighNibbleAdjustments(pc,d1.w),d1
	and.w	#$000F,d0
	move.w	#$0004,ccr
	abcd	d1,d0
	clr.b	d1
	abcd	d1,d0
	bra.s	Convert_PackedBCDToASCII

;fiX Label expected
	move.w	d0,-(sp)
	ror.w	#$08,d0
	bsr.s	Convert_PackedBCDToASCII
	swap	d1
	move.w	(sp)+,d0
Convert_PackedBCDToASCII:		; Memory Address ($CEEA) and binary offset [$CB66]
	; Converts both nibbles of the packed value into ASCII characters.
	move.b	d0,d1
	ror.b	#$04,d1
	bsr.s	Convert_NibbleToASCII
	rol.w	#$08,d1
	move.b	d0,d1
Convert_NibbleToASCII:		; Memory Address ($CEF4) and binary offset [$CB70]
	; Converts a hexadecimal nibble to its ASCII character representation.
	and.b	#$0F,d1
	cmpi.b	#$0A,d1
	bcs.s	ConvertNibbleToASCII_ApplyOffset
	add.b	#$07,d1
ConvertNibbleToASCII_ApplyOffset:		; Memory Address ($CF02) and binary offset [$CB7E]
	add.b	#$30,d1
	rts		

Print_ChampionNamePanelGivenName:		; Memory Address ($CF08) and binary offset [$CB84]
	; Prints the champion's given name in the in-dungeon name panel using the
	; active player's panel background colour.
	move.l	screen_ptr.l,a0
	add.w	$000A(a5),a0
	add.w	#$02EC,a0
	move.w	#$000D,CurrentTextInk.l
	move.w	$0010(a5),CurrentTextBackgroundInk.l
	moveq	#$0B,d6
	and.w	#$000F,d0
	bsr		Print_wordstext
	bsr		TerminateText
	move.w	#$00E0,d4
	moveq	#$12,d5
	add.w	$0008(a5),d5
	move.l	#$00040000,d3														;Long Addr replaced with Symbol
	bsr		BW_blit_vertical_line
	addq.w	#$01,d4
	bra		BW_blit_vertical_line

Clear_LowerTextBackground:		; Memory Address ($CF4E) and binary offset [$CBCA]
	; Clears the two lower-text background words across all four bitplanes and
	; resets text state.
	or.b	#$10,$0054(a5)
	move.b	#$FF,$0057(a5)
	move.l	screen_ptr.l,a0
	add.w	#$0DF4,a0
	add.w	$000A(a5),a0
	clr.w	(a0)
	clr.w	$1F40(a0)
	clr.w	$3E80(a0)
	clr.w	$5DC0(a0)
	add.w	#$00F0,a0
	clr.w	(a0)
	clr.w	$1F40(a0)
	clr.w	$3E80(a0)
	clr.w	$5DC0(a0)
	sub.w	#$00C8,a0
	clr.w	CurrentTextBackgroundInk.l
	moveq	#$0F,d6
	rts		

Clear_LowerTextStrip:		; Memory Address ($CF96) and binary offset [$CC12]
	; Clears the active player's shared lower text area and marks its associated
	; interface state for refresh.
	move.l	#$007F0060,d4
	move.l	#$00060059,d5
	add.w	$0008(a5),d5
	moveq	#$00,d3
	or.b	#$10,$0054(a5)
	move.b	#$FF,$0057(a5)
	bra		BW_draw_bar

LowerText:
	; Clears the shared lower message strip and prints the text stream addressed by
	; A6.
	bsr.s	Clear_LowerTextBackground
	bra.s	Print_TextCharacterLoop

Print_SelectedSpellNameWarmOrange:		; Memory Address ($CFBC) and binary offset [$CC38]
	; Positions and prints the selected spell name using warm-orange foreground
	; ink.
	move.l	screen_ptr.l,a0
	add.w	#$0BAE,a0															;Sets the selected-spell name raster origin to X=$F0, Y=$4A: $0BAE is 74 rows of $28 bytes plus 30 bytes.
	add.w	$000A(a5),a0
	moveq	#$07,d6																;Uses DBRA terminal index seven so the selected spell-name printer emits exactly eight characters from its fixed SpellNames record.
	move.l	#$000B0000,CurrentTextInk.l
	bra.s	Print_TextCharacterLoop

;fiX Label expected
	bsr.s	Prepare_19CharacterPanelTextCursor
Print_TextCharacterLoop:		; Memory Address ($CFDA) and binary offset [$CC56]
	; Consumes text bytes, dispatches extension commands, and draws ordinary glyphs
	; until termination or width exhaustion.
	move.b	(a6)+,d0
	bpl.s	PrintTextCharacterLoop_DrawGlyph
	bsr		Exec_char_extensions
	bcc.s	Print_TextCharacterLoop
	bra.s	TerminateText

PrintTextCharacterLoop_DrawGlyph:		; Memory Address ($CFE6) and binary offset [$CC62]
	bsr		Draw_TextGlyph
	dbra	d6,Print_TextCharacterLoop
	rts		

Print_ChampionSelectionFullName:		; Memory Address ($CFF0) and binary offset [$CC6C]
	; Prints the champion's given and second names on the champion-selection
	; screen.
	bsr.s	Prepare_19CharacterPanelTextCursor
	move.w	d7,d0
	bsr		Print_wordstext
	moveq	#$20,d0
	bsr		Draw_TextGlyph
	subq.w	#$01,d6
	moveq	#$64,d0
	add.w	d7,d0
	bsr		Print_wordstext
TerminateText:		; Memory Address ($D008) and binary offset [$CC84]
	; Pads the remainder of the current text field with D6+1 blank glyphs, or
	; returns immediately when the field is already full.
	tst.w	d6
	bmi.s	TerminateText_Exit
TerminateText_PadLoop:		; Memory Address ($D00C) and binary offset [$CC88]
	moveq	#$20,d0
	bsr		Draw_TextGlyph
	dbra	d6,TerminateText_PadLoop
TerminateText_Exit:		; Memory Address ($D016) and binary offset [$CC92]
	rts		

Prepare_19CharacterPanelTextCursor:		; Memory Address ($D018) and binary offset [$CC94]
	; Initialises the nineteen-character text budget, panel cursor, foreground ink,
	; and player-coloured background used by names and item descriptions.
	moveq	#$12,d6
Position_NameFieldTextCursor:		; Memory Address ($D01A) and binary offset [$CC96]
	; Positions the shared name-like text cursor and applies the panel width and
	; player-coloured background.
	move.l	screen_ptr.l,a0
	add.w	#$0E25,a0
	add.w	$000A(a5),a0
	move.w	#$000D,CurrentTextInk.l
	move.w	$0010(a5),CurrentTextBackgroundInk.l
	rts		

WriteMessage:
	move.b	#$81,d2
	bra.s	WriteMessage_SwitchToOtherPlayerContext

;fiX Label expected
	moveq	#$00,d2																;ASM_RECOVERY: write_message_default | 7400

WriteMessage_SwitchToOtherPlayerContext:		; Memory Address ($D042) and binary offset [$CCBE]
	tst.b	$0005(a4)
	bpl.s	WriteFText
	movem.l	d2/a6,-(sp)
	bsr.s	WriteFText
	movem.l	(sp)+,d2/a6
	lea		Player1_Data.l,a0
	btst	#$00,(a5)
	bne.s	.continuedcode_001
	lea		Player2_Data.l,a0
.continuedcode_001:		; Memory Address ($D064) and binary offset [$CCE0]
	movem.l	a4/a5,-(sp)
	move.l	a0,a5
	move.b	$0001(a4),d0
	jsr		Comms_GetState.w													;Short Absolute converted to symbol!
	tst.b	$0005(a4)
	bpl.s	WriteMessage_RelayToOtherPlayer
	move.b	d0,$0000(a4)
WriteMessage_RelayToOtherPlayer:		; Memory Address ($D07C) and binary offset [$CCF8]
	or.b	#$40,d2
	bsr.s	WriteFText
	movem.l	(sp)+,a4/a5
	rts		

WriteTimedText:		; Memory Address ($D088) and binary offset [$CD04]
	; Selects timed/fading text state $81 and enters the shared top-strip text
	; writer.
	move.b	#$81,d2
	bra.s	WriteFText

WriteText:
	; Selects fixed ink and enters WriteFText to print the A6 text stream in the
	; top text strip.
	moveq	#$00,d2
WriteFText:		; Memory Address ($D090) and binary offset [$CD0C]
	; Stores the requested ink, initialises the top text strip, and prints the text
	; stream addressed by A6.
	move.b	d2,$0052(a5)
	bsr.s	InitialiseText
	bra		Print_TextCharacterLoop

InitialiseText:		; Memory Address ($D09A) and binary offset [$CD16]
	; Initialises a fresh 40-character top text strip, resets its cursor and redraw
	; state, and arms the timed colour-fade state.
	or.b	#$A0,$0054(a5)
	move.l	screen_ptr.l,a0
	add.w	$000A(a5),a0
	add.w	#$0050,a0
	move.l	#$000F0000,CurrentTextInk.l											;Sets ordinary dialogue foreground ink to palette index 15; raster interrupts supply its player/monster RGB value.
	clr.w	$004C(a5)
	moveq	#$27,d6
	move.w	#$0105,$004A(a5)
	rts		

Print_fflim_text:		; Memory Address ($D0C6) and binary offset [$CD42]
	; Prints an A6 byte stream character by character, dispatching bytes $80 and
	; above through the text escape-code handler.
	move.b	(a6)+,d0
	bpl.s	.continuedcode_002
	bsr.s	Exec_char_extensions
	bcc.s	Print_fflim_text
	rts		

.continuedcode_002:		; Memory Address ($D0D0) and binary offset [$CD4C]
	bsr		Draw_TextGlyph
	bra.s	Print_fflim_text

Exec_char_extensions:		; Memory Address ($D0D6) and binary offset [$CD52]
	; Handles text-stream escape codes for foreground ink, background ink, cursor
	; X/Y, and inline copy-protection; unsupported codes signal the caller to stop.
	cmpi.b	#$F0,d0
	beq		.Call_F0_Function
	moveq	#$00,d1
	move.b	(a6)+,d1
	cmpi.b	#$FE,d0
	beq.s	.SetTextColour
	cmpi.b	#$FD,d0
	beq.s	.SetBackgroundTextColour
	cmpi.b	#$FC,d0
	beq.s	.SetXYPosition
	moveq	#$00,d0
	subq.w	#$01,d0
	rts		

.SetTextColour:		; Memory Address ($D0FA) and binary offset [$CD76]
	move.w	d1,CurrentTextInk.l
	rts		

.SetBackgroundTextColour:		; Memory Address ($D102) and binary offset [$CD7E]
	move.w	d1,CurrentTextBackgroundInk.l
	rts		

.SetXYPosition:		; Memory Address ($D10A) and binary offset [$CD86]
	move.w	d1,d4
	clr.w	d5
	move.b	(a6)+,d5
	asl.w	#$03,d4																;The FC text extension converts its byte column to native 8-pixel X coordinates before calculating the text origin.
	asl.w	#$03,d5
	bsr		BW_xy_to_offset
	move.l	screen_ptr.l,a0
	add.w	$000A(a5),a0
	add.w	d0,a0
	add.w	#$0050,a0
.Exit:		; Memory Address ($D128) and binary offset [$CDA4]
	rts		

.Call_F0_Function:		; Memory Address ($D12A) and binary offset [$CDA6]
	bsr.s	CopyProtection
	tst.l	d0
	beq.s	.Exit
	lea		MainGame_PlayerUpdateLoop.w,a0										;Short Absolute converted to symbol!
	bra		ClearFourPlaneBuffer_SharedEntry

CopyProtection:
	; Preserves A4-A6 and enters the executable's copy-protection check, used from
	; the text escape-code dispatcher and disk load/save paths.
	movem.l	a4-a6,-(sp)
	bra		CopyProtection_SaveStateAndReenter
;	move.l	#$8488ffc4,$24.w
;	moveq	#0,d0
;	rts


;fiX Label expected
; SOURCE_NOTE: COPY_PROTECTION_INTERNAL ($D140): Reserved workspace leading into the saved-register area.
; COPY_PROTECTION_INTERNAL ($D140): Reserved workspace leading into the saved-register area.
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
IllegalTrap_RegisterSaveArea:		; Memory Address ($D186) and binary offset [$CE02]
	; Register-save and working area used by the illegal-instruction
	; copy-protection handler.
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
TraceCipher_ActiveInstructionState:		; Memory Address ($D1F0) and binary offset [$CE6C]
	; Address and original-longword state for the trace-vector instruction
	; decrypt/re-encrypt mechanism.
	ds.b	$8
adrL_00D1F8:		; Memory Address ($D1F8) and binary offset [$CE74]
	dc.l	$FFFFFFFF	;FFFFFFFF

CopyProtection_SaveStateAndReenter:		; Memory Address ($D1FC) and binary offset [$CE78]
	move.l	a6,-(sp)
	lea		IllegalTrap_RegisterSaveArea(pc),a6
	movem.l	d0-d7/a0-a7,(a6)
	lea		$0040(a6),a6
	move.l	(sp)+,-$0008(a6)
	move.l	$00000010.l,d1
; A PC relative Short Absolute outside of the program!
	dc.l	$487A000A
;	pea	$000A.l(pc)	;487A000A	;replaced by dc.l above
	move.l	(sp)+,$00000010.l
	illegal	
;fiX Label expected
; SOURCE_NOTE: COPY_PROTECTION_INTERNAL ($D21C): Opaque instruction/data stream entered through the deliberate exception path.
; COPY_PROTECTION_INTERNAL ($D21C): Opaque instruction/data stream entered through the deliberate exception path.
	dc.w	$487A	;487A
	dc.w	$001C	;001C
	dc.w	$23DF	;23DF
	dc.w	$0000	;0000
	dc.w	$0010	;0010
	dc.w	$224F	;224F
	dc.w	$4E7A	;4E7A
	dc.w	$0002	;0002
	dc.w	$41FA	;41FA
	dc.w	$FFC6	;FFC6
	dc.w	$2080	;2080
	dc.w	$0880	;0880
	dc.w	$0000	;0000
	dc.w	$4E7B	;4E7B
	dc.w	$0002	;0002
	dc.w	$2E49	;2E49
	dc.w	$23C1	;23C1
	dc.w	$0000	;0000
	dc.w	$0010	;0010
	dc.w	$4CF9	;4CF9
	dc.w	$00FF	;00FF
	dc.w	$0000	;0000
	dc.w	$0008	;0008
	dc.w	$48D6	;48D6
	dc.w	$00FF	;00FF
	dc.w	$41FA	;41FA
	dc.w	$007E	;007E
	dc.w	$23C8	;23C8
	dc.w	$0000	;0000
	dc.w	$0010	;0010
	dc.w	$4AFC	;4AFC
	dc.w	$D503	;D503
	dc.w	$FFE1	;FFE1
	dc.w	$601E	;601E
	dc.w	$2AC6	;2AC6
	dc.w	$B539	;B539
	dc.w	$9F83	;9F83
	dc.w	$007C	;007C
	dc.w	$4ACC	;4ACC
	dc.w	$D533	;D533
	dc.w	$FF89	;FF89
	dc.w	$6076	;6076
	dc.w	$2AD6	;2AD6
	dc.w	$B529	;B529
	dc.w	$9FAB	;9FAB
	dc.w	$0054	;0054
	dc.w	$4A84	;4A84
	dc.w	$D57B	;D57B
	dc.w	$0049	;0049
	dc.w	$9FB6	;9FB6
	dc.w	$2A82	;2A82
	dc.w	$B57D	;B57D
	dc.w	$6047	;6047
	dc.w	$FFB8	;FFB8
	dc.w	$4A98	;4A98
	dc.w	$D567	;D567
	dc.w	$0071	;0071
	dc.w	$9F8E	;9F8E
	dc.w	$2AB6	;2AB6
	dc.w	$B549	;B549
	dc.w	$6063	;6063
	dc.w	$FF9C	;FF9C
	dc.w	$B554	;B554
	dc.w	$2AAB	;2AAB
	dc.w	$FF81	;FF81
	dc.w	$607E	;607E
	dc.w	$D5C0	;D5C0
	dc.w	$4A3F	;4A3F
	dc.w	$9F87	;9F87
	dc.w	$0078	;0078
	dc.w	$4A7E	;4A7E
	dc.w	$D581	;D581
	dc.w	$FF81	;FF81
	dc.w	$607E	;607E
	dc.w	$D5CC	;D5CC
	dc.w	$4A33	;4A33
	dc.w	$603B	;603B
	dc.w	$FFC4	;FFC4
	dc.w	$4A06	;4A06
	dc.w	$D5F9	;D5F9
	dc.w	$FFE9	;FFE9
	dc.w	$6016	;6016
	dc.w	$D5E8	;D5E8
	dc.w	$4A17	;4A17
	dc.w	$601F	;601F
	dc.w	$FFE0	;FFE0
	dc.w	$4A3E	;4A3E
	dc.w	$D5C1	;D5C1
	dc.w	$FFF5	;FFF5

Install_TraceCipherExceptionVectors:		; Memory Address ($D2D2) and binary offset [$CF4E]
	movem.l	d0/a0/a1,-(sp)
	lea		TraceCipher_StepDecryptNextInstruction(pc),a0
	move.l	a0,$00000024.l
	lea		TraceCipher_PrivilegeViolationHandler(pc),a0
	move.l	a0,$00000020.l
TraceCipher_ArmOrDisarmTraceBit:		; Memory Address ($D2EA) and binary offset [$CF66]
	add.l	#$00000002,$000E(sp)
	or.b	#$07,$000C(sp)
	bchg	#$07,$000C(sp)
	lea		TraceCipher_ActiveInstructionState(pc),a1
	beq.s	TraceCipher_LoadNextInstructionAddress
	move.l	(a1),a0
	move.l	$0004(a1),(a0)
	bra.s	TraceCipher_RestoreAndReturn

TraceCipher_StepDecryptNextInstruction:		; Memory Address ($D30C) and binary offset [$CF88]
	andi.w	#$F8FF,sr
	movem.l	d0/a0/a1,-(sp)
	lea		TraceCipher_ActiveInstructionState(pc),a1
	move.l	(a1),a0
	move.l	$0004(a1),(a0)
TraceCipher_LoadNextInstructionAddress:		; Memory Address ($D31E) and binary offset [$CF9A]
	move.l	$000E(sp),a0
TraceCipher_DecryptNextInstruction:		; Memory Address ($D322) and binary offset [$CF9E]
	move.l	a0,(a1)
	move.l	(a0),$0004(a1)
	move.l	-$0004(a0),d0
	not.l	d0
	swap	d0
	eor.l	d0,(a0)
TraceCipher_RestoreAndReturn:		; Memory Address ($D332) and binary offset [$CFAE]
	movem.l	(sp)+,d0/a0/a1
	rte		

;fiX Label expected
; SOURCE_NOTE: COPY_PROTECTION_INTERNAL ($D338): Opaque word stream following the exception-handler return.
; COPY_PROTECTION_INTERNAL ($D338): Opaque word stream following the exception-handler return.
	dc.w	$F076	;F076
	dc.w	$FCE0	;FCE0
	dc.w	$40E6	;40E6
	dc.w	$0F89	;0F89
	dc.w	$0008	;0008
	dc.w	$BA0D	;BA0D
	dc.w	$0ECE	;0ECE
	dc.w	$8136	;8136
	dc.w	$0CC9	;0CC9
	dc.w	$C12E	;C12E
	dc.w	$EC5B	;EC5B
	dc.w	$3165	;3165
	dc.w	$9F52	;9F52
	dc.w	$EC52	;EC52
	dc.w	$73AD	;73AD
	dc.w	$60BF	;60BF
	dc.w	$05C4	;05C4
	dc.w	$0544	;0544
	dc.w	$00D6	;00D6
	dc.w	$0604	;0604
	dc.w	$0644	;0644
	dc.w	$06C4	;06C4
	dc.w	$0544	;0544
	dc.w	$0110	;0110
	dc.w	$BD15	;BD15
	dc.w	$04E7	;04E7
	dc.w	$B9B1	;B9B1
	dc.w	$42F6	;42F6
	dc.w	$DC09	;DC09
	dc.w	$46D6	;46D6
	dc.w	$DE29	;DE29
	dc.w	$2064	;2064
	dc.w	$AB9D	;AB9D
	dc.w	$07E0	;07E0
	dc.w	$9F7F	;9F7F
	dc.w	$217A	;217A
	dc.w	$05DF	;05DF
	dc.w	$8A25	;8A25
	dc.w	$14DA	;14DA
	dc.w	$FAE8	;FAE8
	dc.w	$2317	;2317
	dc.w	$ACEC	;ACEC
	dc.w	$3213	;3213
	dc.w	$DC28	;DC28
	dc.w	$01D7	;01D7
	dc.w	$DE2B	;DE2B
	dc.w	$4088	;4088
	dc.w	$D495	;D495
	dc.w	$5B6C	;5B6C
	dc.w	$C593	;C593
	dc.w	$2BD8	;2BD8
	dc.w	$F624	;F624
	dc.w	$688B	;688B
	dc.w	$FCA2	;FCA2
	dc.w	$0FCD	;0FCD
	dc.w	$C51B	;C51B
	dc.w	$6220	;6220
	dc.w	$FB11	;FB11
	dc.w	$0846	;0846
	dc.w	$D3B0	;D3B0
	dc.w	$7274	;7274
	dc.w	$0004	;0004
	dc.w	$993F	;993F
	dc.w	$6A68	;6A68
	dc.w	$979E	;979E
	dc.w	$6E20	;6E20
	dc.w	$0008	;0008
	dc.w	$994D	;994D
	dc.w	$6A1A	;6A1A
	dc.w	$BC98	;BC98
	dc.w	$6D70	;6D70
	dc.w	$000C	;000C
	dc.w	$9943	;9943
	dc.w	$14B9	;14B9
	dc.w	$C90E	;C90E
	dc.w	$E668	;E668
	dc.w	$FA0F	;FA0F
	dc.w	$5439	;5439
	dc.w	$E66D	;E66D
	dc.w	$5A68	;5A68
	dc.w	$5628	;5628
	dc.w	$787E	;787E
	dc.w	$A58B	;A58B
	dc.w	$6E4E	;6E4E
	dc.w	$798F	;798F
	dc.w	$E770	;E770
	dc.w	$93B3	;93B3
	dc.w	$0D4C	;0D4C
	dc.w	$1943	;1943
	dc.w	$C686	;C686
	dc.w	$0F45	;0F45
	dc.w	$90BA	;90BA
	dc.w	$3A61	;3A61
	dc.w	$551F	;551F
	dc.w	$C1F0	;C1F0
	dc.w	$FEF3	;FEF3
	dc.w	$AA84	;AA84
	dc.w	$D5BA	;D5BA
	dc.w	$9A79	;9A79
	dc.w	$5578	;5578
	dc.w	$C783	;C783
	dc.w	$487C	;487C
	dc.w	$F9F6	;F9F6
	dc.w	$76F6	;76F6
	dc.w	$C77C	;C77C
	dc.w	$4E80	;4E80
	dc.w	$D07F	;D07F
	dc.w	$3911	;3911
	dc.w	$A0CA	;A0CA
	dc.w	$2B35	;2B35
	dc.w	$B5CA	;B5CA
	dc.w	$5EE5	;5EE5
	dc.w	$C706	;C706
	dc.w	$7903	;7903
	dc.w	$5C3E	;5C3E
	dc.w	$D7C3	;D7C3
	dc.w	$1806	;1806
	dc.w	$A2A3	;A2A3
	dc.w	$3C5C	;3C5C
	dc.w	$E751	;E751
	dc.w	$7E8C	;7E8C
	dc.w	$D0B9	;D0B9
	dc.w	$E75A	;E75A
	dc.w	$2C9F	;2C9F
	dc.w	$D2F8	;D2F8
	dc.w	$4C07	;4C07
	dc.w	$D2D2	;D2D2
	dc.w	$4C2D	;4C2D
	dc.w	$B284	;B284
	dc.w	$0C81	;0C81
	dc.w	$4E7C	;4E7C
	dc.w	$B7D3	;B7D3
	dc.w	$F37F	;F37F
	dc.w	$0ED0	;0ED0
	dc.w	$482F	;482F
	dc.w	$E61B	;E61B
	dc.w	$0EEB	;0EEB
	dc.w	$8114	;8114
	dc.w	$309E	;309E
	dc.w	$8786	;8786
	dc.w	$9E2B	;9E2B
	dc.w	$0084	;0084
	dc.w	$DB7B	;DB7B
	dc.w	$0493	;0493
	dc.w	$B896	;B896
	dc.w	$25AE	;25AE
	dc.w	$39D9	;39D9
	dc.w	$F617	;F617
	dc.w	$D251	;D251
	dc.w	$0FAE	;0FAE
	dc.w	$D050	;D050
	dc.w	$4EC9	;4EC9
	dc.w	$D6CC	;D6CC
	dc.w	$07B3	;07B3
	dc.w	$C85C	;C85C
	dc.w	$82E3	;82E3
	dc.w	$7F5C	;7F5C
	dc.w	$62F6	;62F6
	dc.w	$FBE7	;FBE7
	dc.w	$2650	;2650
	dc.w	$93F7	;93F7
	dc.w	$1E03	;1E03
	dc.w	$C1E4	;C1E4
	dc.w	$5F1B	;5F1B
	dc.w	$E1F2	;E1F2
	dc.w	$2CCD	;2CCD
	dc.w	$82FB	;82FB
	dc.w	$E1FB	;E1FB
	dc.w	$52DB	;52DB
	dc.w	$7E03	;7E03
	dc.w	$CF89	;CF89
	dc.w	$7891	;7891
	dc.w	$E1FC	;E1FC
	dc.w	$3C03	;3C03
	dc.w	$B7F3	;B7F3
	dc.w	$AD9D	;AD9D
	dc.w	$B1F2	;B1F2
	dc.w	$1FC7	;1FC7
	dc.w	$AD98	;AD98
	dc.w	$1EB8	;1EB8
	dc.w	$E03E	;E03E
	dc.w	$51B4	;51B4
	dc.w	$E6AC	;E6AC
	dc.w	$7FC1	;7FC1
	dc.w	$C87E	;C87E
	dc.w	$1381	;1381
	dc.w	$9E71	;9E71
	dc.w	$8406	;8406
	dc.w	$986B	;986B
	dc.w	$0298	;0298
	dc.w	$F567	;F567
	dc.w	$6796	;6796
	dc.w	$FE63	;FE63
	dc.w	$095C	;095C
	dc.w	$9868	;9868
	dc.w	$0793	;0793
	dc.w	$F0AC	;F0AC
	dc.w	$6797	;6797
	dc.w	$C9A1	;C9A1
	dc.w	$F0BB	;F0BB
	dc.w	$439B	;439B
	dc.w	$3658	;3658
	dc.w	$87D2	;87D2
	dc.w	$30CA	;30CA
	dc.w	$B167	;B167
	dc.w	$6CD0	;6CD0
	dc.w	$D2D6	;D2D6
	dc.w	$4E47	;4E47
	dc.w	$F000	;F000
	dc.w	$3EBF	;3EBF
	dc.w	$B1C6	;B1C6
	dc.w	$2F39	;2F39
	dc.w	$C0AC	;C0AC
	dc.w	$0E2F	;0E2F
	dc.w	$90C6	;90C6
	dc.w	$0024	;0024
	dc.w	$DE92	;DE92
	dc.w	$6F19	;6F19
	dc.w	$A19A	;A19A
	dc.w	$476D	;476D
	dc.w	$009E	;009E
	dc.w	$CE1D	;CE1D
	dc.w	$2D92	;2D92
	dc.w	$009E	;009E
	dc.w	$CE1D	;CE1D
	dc.w	$527D	;527D
	dc.w	$0096	;0096
	dc.w	$CE15	;CE15
	dc.w	$AD80	;AD80
	dc.w	$009C	;009C
	dc.w	$9E63	;9E63
	dc.w	$526F	;526F
	dc.w	$9CEC	;9CEC
	dc.w	$659C	;659C
	dc.w	$009E	;009E
	dc.w	$B5E1	;B5E1
	dc.w	$06C1	;06C1
	dc.w	$FC7F	;FC7F
	dc.w	$4DF5	;4DF5
	dc.w	$F8F6	;F8F6
	dc.w	$4A39	;4A39
	dc.w	$00BF	;00BF
	dc.w	$DD00	;DD00

CopyProtection_WaitIndexPulse:		; Memory Address ($D51E) and binary offset [$D19A]
	btst	#$04,_ciab+ciaicr.l
	beq.s	CopyProtection_WaitIndexPulse
	move.w	#$8000,$0024(a0)
	move.w	#$8000,$0024(a0)
	moveq	#$00,d1
	move.l	#$00061A80,d2
CopyProtection_WaitSyncBitOrTimeout:		; Memory Address ($D53C) and binary offset [$D1B8]
	subq.l	#$01,d2
	beq.s	CopyProtection_ResolvePulseCountResult
	move.b	$001A(a0),d0
	btst	#$04,d0
	beq.s	CopyProtection_WaitSyncBitOrTimeout
	moveq	#$31,d2
CopyProtection_CaptureTrackBytes:		; Memory Address ($D54C) and binary offset [$D1C8]
	addq.l	#$01,d1
	move.w	$001A(a0),d0
	bpl.s	CopyProtection_CaptureTrackBytes
	move.b	d0,(a1)+
	dbra	d2,CopyProtection_CaptureTrackBytes
	move.w	#$03CD,d2
CopyProtection_SkipRemainingPulses:		; Memory Address ($D55E) and binary offset [$D1DA]
	addq.l	#$01,d1
	move.w	$001A(a0),d0
	bpl.s	CopyProtection_SkipRemainingPulses
	dbra	d2,CopyProtection_SkipRemainingPulses
CopyProtection_ResolvePulseCountResult:		; Memory Address ($D56A) and binary offset [$D1E6]
	move.w	$001E(a0),d0
	move.w	#$0002,$009C(a0)
	move.w	#$4000,$0024(a0)
	btst	#$01,d0
	bne.s	CopyProtection_TrapWithPulseCount
	moveq	#$00,d1
	bra.s	CopyProtection_TrapWithPulseCount

;fiX Label expected
; SOURCE_NOTE: COPY_PROTECTION_INTERNAL ($D584): Encoded word block deliberately skipped by the visible execution paths.
; COPY_PROTECTION_INTERNAL ($D584): Encoded word block deliberately skipped by the visible execution paths.
	dc.w	$8A91	;8A91
	dc.w	$8A44	;8A44
	dc.w	$8A45	;8A45
	dc.w	$8A51	;8A51
	dc.w	$8912	;8912
	dc.w	$8911	;8911
	dc.w	$8914	;8914
	dc.w	$8915	;8915
	dc.w	$8944	;8944
	dc.w	$8945	;8945
	dc.w	$8951	;8951

CopyProtection_TrapWithPulseCount:		; Memory Address ($D59A) and binary offset [$D216]
	move.l	d1,d0
	illegal	
;fiX Label expected
; SOURCE_NOTE: COPY_PROTECTION_INTERNAL ($D59E): Opaque stream following the deliberate illegal instruction; retained as raw words.
; COPY_PROTECTION_INTERNAL ($D59E): Opaque stream following the deliberate illegal instruction; retained as raw words.
	dc.w	$FB76	;FB76
	dc.w	$7676	;7676
	dc.w	$8108	;8108
	dc.w	$048E	;048E
	dc.w	$9A7F	;9A7F
	dc.w	$45BC	;45BC
	dc.w	$FB78	;FB78
	dc.w	$27C0	;27C0
	dc.w	$B93F	;B93F
	dc.w	$05D7	;05D7
	dc.w	$9A3E	;9A3E
	dc.w	$173E	;173E
	dc.w	$A938	;A938
	dc.w	$657E	;657E
	dc.w	$D100	;D100
	dc.w	$3E7E	;3E7E
	dc.w	$F1BB	;F1BB
	dc.w	$D2D5	;D2D5
	dc.w	$7BAA	;7BAA
	dc.w	$85D4	;85D4
	dc.w	$6AAA	;6AAA
	dc.w	$DB20	;DB20
	dc.w	$6526	;6526
	dc.w	$95EA	;95EA
	dc.w	$E001	;E001
	dc.w	$3FC2	;3FC2
	dc.w	$6A15	;6A15
	dc.w	$061A	;061A
	dc.w	$F1F5	;F1F5
	dc.w	$95EF	;95EF
	dc.w	$0D16	;0D16
	dc.w	$A169	;A169
	dc.w	$3460	;3460
	dc.w	$85EA	;85EA
	dc.w	$0A15	;0A15
	dc.w	$BB9F	;BB9F
	dc.w	$0C87	;0C87
	dc.w	$89EA	;89EA
	dc.w	$4C17	;4C17
	dc.w	$D2E8	;D2E8
	dc.w	$76CB	;76CB
	dc.w	$8B71	;8B71
	dc.w	$2D68	;2D68
	dc.w	$B59B	;B59B
	dc.w	$7A5E	;7A5E
	dc.w	$2965	;2965
	dc.w	$B79A	;B79A
	dc.w	$859B	;859B
	dc.w	$4265	;4265
	dc.w	$D792	;D792
	dc.w	$496D	;496D
	dc.w	$BDA4	;BDA4
	dc.w	$2473	;2473
	dc.w	$A38C	;A38C
	dc.w	$E637	;E637
	dc.w	$7EC6	;7EC6
	dc.w	$EC3F	;EC3F
	dc.w	$72B0	;72B0
	dc.w	$DFCB	;DFCB
	dc.w	$40C0	;40C0
	dc.w	$DE59	;DE59
	dc.w	$7222	;7222
	dc.w	$ED33	;ED33
	dc.w	$73CC	;73CC
	dc.w	$8D73	;8D73
	dc.w	$42B6	;42B6
	dc.w	$77FB	;77FB
	dc.w	$6B4C	;6B4C
	dc.w	$D549	;D549
	dc.w	$73BA	;73BA
	dc.w	$BDC1	;BDC1
	dc.w	$2AB6	;2AB6
	dc.w	$A549	;A549
	dc.w	$1669	;1669
	dc.w	$D577	;D577
	dc.w	$64FD	;64FD
	dc.w	$784A	;784A
	dc.w	$C64F	;C64F
	dc.w	$60AE	;60AE
	dc.w	$AD61	;AD61
	dc.w	$39B0	;39B0
	dc.w	$883A	;883A
	dc.w	$3F22	;3F22
	dc.w	$BE4F	;BE4F
	dc.w	$39E5	;39E5
	dc.w	$CE23	;CE23
	dc.w	$41B4	;41B4
	dc.w	$00BF	;00BF
	dc.w	$E001	;E001
	dc.w	$78F2	;78F2
	dc.w	$E60D	;E60D
	dc.w	$1FD4	;1FD4
	dc.w	$B1E7	;B1E7
	dc.w	$E602	;E602
	dc.w	$6902	;6902
	dc.w	$F6E7	;F6E7
	dc.w	$3922	;3922
	dc.w	$6D77	;6D77
	dc.w	$71C0	;71C0
	dc.w	$CFC5	;CFC5
	dc.w	$6908	;6908
	dc.w	$D487	;D487
	dc.w	$303A	;303A
	dc.w	$BF90	;BF90
	dc.w	$D0EB	;D0EB
	dc.w	$6EEE	;6EEE
	dc.w	$BB13	;BB13
	dc.w	$746C	;746C
	dc.w	$FB93	;FB93
	dc.w	$48B3	;48B3
	dc.w	$8B8D	;8B8D
	dc.w	$3A07	;3A07
	dc.w	$B1F9	;B1F9
	dc.w	$2E04	;2E04
	dc.w	$A5FB	;A5FB
	dc.w	$6A3E	;6A3E
	dc.w	$2A9F	;2A9F
	dc.w	$E75A	;E75A
	dc.w	$6EA3	;6EA3
	dc.w	$8765	;8765
	dc.w	$181A	;181A
	dc.w	$D100	;D100
	dc.w	$2EFC	;2EFC
	dc.w	$E79A	;E79A
	dc.w	$1E65	;1E65
	dc.w	$D100	;D100
	dc.w	$2F7C	;2F7C
	dc.w	$D483	;D483
	dc.w	$2EFC	;2EFC
	dc.w	$9B02	;9B02
	dc.w	$03F9	;03F9
	dc.w	$F485	;F485
	dc.w	$64FF	;64FF
	dc.w	$D102	;D102
	dc.w	$48F9	;48F9
	dc.w	$BF85	;BF85
	dc.w	$2EFC	;2EFC
	dc.w	$D980	;D980
	dc.w	$407A	;407A
	dc.w	$AC46	;AC46
	dc.w	$26C0	;26C0
	dc.w	$D100	;D100
	dc.w	$263C	;263C
	dc.w	$D93F	;D93F
	dc.w	$3503	;3503
	dc.w	$D97C	;D97C
	dc.w	$D100	;D100
	dc.w	$0EC3	;0EC3
	dc.w	$2683	;2683
	dc.w	$0BB8	;0BB8
	dc.w	$9473	;9473
	dc.w	$5BB6	;5BB6
	dc.w	$0F5B	;0F5B
	dc.w	$C29E	;C29E
	dc.w	$5F53	;5F53
	dc.w	$9FAE	;9FAE
	dc.w	$7468	;7468
	dc.w	$A013	;A013
	dc.w	$D100	;D100
	dc.w	$2EFD	;2EFD
	dc.w	$5F93	;5F93
	dc.w	$A66C	;A66C
	dc.w	$D101	;D101
	dc.w	$2F7C	;2F7C
	dc.w	$D483	;D483
	dc.w	$2EFD	;2EFD
	dc.w	$9B03	;9B03
	dc.w	$03F8	;03F8
	dc.w	$F485	;F485
	dc.w	$64FE	;64FE
	dc.w	$88C3	;88C3
	dc.w	$0BC5	;0BC5
	dc.w	$D100	;D100
	dc.w	$0EC3	;0EC3
	dc.w	$F43A	;F43A
	dc.w	$05DC	;05DC
	dc.w	$CE3C	;CE3C
	dc.w	$DB4B	;DB4B
	dc.w	$7734	;7734
	dc.w	$EE37	;EE37
	dc.w	$5FBD	;5FBD
	dc.w	$E1B8	;E1B8
	dc.w	$EBB4	;EBB4
	dc.w	$34CB	;34CB
	dc.w	$87CE	;87CE
	dc.w	$14B4	;14B4
	dc.w	$FAB4	;FAB4
	dc.w	$2572	;2572
	dc.w	$EB4B	;EB4B
	dc.w	$0004	;0004
	dc.w	$DDFB	;DDFB
	dc.w	$63FE	;63FE
	dc.w	$FFD9	;FFD9
	dc.w	$2F6E	;2F6E
	dc.w	$9C03	;9C03
	dc.w	$2900	;2900
	dc.w	$203A	;203A
	dc.w	$FAD0	;FAD0
	dc.w	$6B04	;6B04
	dc.w	$4E7B	;4E7B
	dc.w	$0002	;0002
	dc.w	$48F9	;48F9
	dc.w	$00FF	;00FF
	dc.w	$0000	;0000
	dc.w	$0008	;0008
	dc.w	$4CFA	;4CFA
	dc.w	$7FFF	;7FFF
	dc.w	$FA4A	;FA4A

	rte		

TraceCipher_PrivilegeViolationHandler:		; Memory Address ($D740) and binary offset [$D3BC]
	movem.l	(sp)+,a4-a6
	sub.l	#$8488FFC4,d0
	rts		

Print_com_menu_entry:		; Memory Address ($D74C) and binary offset [$D3C8]
	; Prints one party-command menu row, choosing normal or hovered inks and
	; interpreting its word-stream separators, literal characters, and WordsText
	; references.
	move.l	#$000D0002,CurrentTextInk.l
	cmp.b	$0040(a5),d7
	bne.s	.continuedcode_005
	tst.b	$0041(a5)
	bne.s	.continuedcode_005
	move.w	$0010(a5),CurrentTextBackgroundInk.l
	move.w	#$000E,CurrentTextInk.l
.continuedcode_005:		; Memory Address ($D772) and binary offset [$D3EE]
	move.b	(a6)+,d0
	cmpi.b	#$FA,d0
	beq.s	.PrintLiteralCharacterToken
	bcc.s	.HandleCommandColumnSeparator
	bsr.s	Print_wordstext
	bra.s	.continuedcode_005

.PrintLiteralCharacterToken:		; Memory Address ($D780) and binary offset [$D3FC]
	; Consumes the next text-stream byte as a literal glyph and resumes descriptor
	; parsing after drawing it.
	move.b	(a6)+,d0
	bsr		Draw_TextGlyph
	bra.s	.continuedcode_005

.HandleCommandColumnSeparator:		; Memory Address ($D788) and binary offset [$D404]
	; Handles the command-menu column-separator token and records the alternate
	; column geometry for following glyphs.
	cmpi.b	#$FF,d0
	beq.s	Print_LineEnd
	cmpi.b	#$FC,d0
	bne.s	.continuedcode_005
	addq.w	#$01,a0
	move.b	#$FF,TextDoubleWidthFlag.l
	move.l	#$000D0002,CurrentTextInk.l
	cmp.b	$0040(a5),d7
	bne.s	.continuedcode_005
	tst.b	$0041(a5)
	beq.s	.continuedcode_005
	move.w	$0010(a5),CurrentTextBackgroundInk.l
	move.w	#$000E,CurrentTextInk.l
	bra.s	.continuedcode_005

Select_WordsTextTable:		; Memory Address ($D7C6) and binary offset [$D442]
	; Selects the WordsText string table and enters the shared indexed-string
	; lookup.
	lea		WordsText.l,a3
Proceed_in_stringtable:		; Memory Address ($D7CC) and binary offset [$D448]
	; Walks a length-prefixed string table to entry D0 and returns A3 at the entry
	; text with its character count in D5.
	and.w	#$00FF,d0
	moveq	#$00,d5
.continuedcode_006:		; Memory Address ($D7D2) and binary offset [$D44E]
	add.w	d5,a3
	move.b	(a3)+,d5
	dbra	d0,.continuedcode_006
Print_LineEnd:		; Memory Address ($D7DA) and binary offset [$D456]
	rts		

Print_item_name:		; Memory Address ($D7DC) and binary offset [$D458]
	; Selects Objects_Texts and enters the shared word printer to draw object name
	; D0.
	lea		Objects_Texts.l,a3
Print_word:		; Memory Address ($D7E2) and binary offset [$D45E]
	bsr.s	Proceed_in_stringtable
	bra.s	Print_nchars

Print_wordstext:		; Memory Address ($D7E6) and binary offset [$D462]
	; Looks up word D0 in WordsText and enters the shared counted-character
	; printer.
	bsr.s	Select_WordsTextTable
Print_nchars:		; Memory Address ($D7E8) and binary offset [$D464]
	; Draws D5+1 characters from A3 and reduces the caller's remaining field-width
	; counter accordingly.
	sub.w	d5,d6
	subq.w	#$01,d5
.continuedcode_007:		; Memory Address ($D7EC) and binary offset [$D468]
	move.b	(a3)+,d0
	bsr		Draw_TextGlyph
	dbra	d5,.continuedcode_007
	rts		

InventoryItem_Description:		; Memory Address ($D7F8) and binary offset [$D474]
	bsr		Prepare_19CharacterPanelTextCursor
	bra.s	Print_item_desc

Print_item_desc_fresh:		; Memory Address ($D7FE) and binary offset [$D47A]
	bsr		Clear_LowerTextBackground
Print_item_desc:		; Memory Address ($D802) and binary offset [$D47E]
	move.b	(a6)+,d0
	bsr.s	Print_item_name
	subq.w	#$01,d6
	moveq	#$20,d0
	bsr		Draw_TextGlyph
	move.b	(a6),d0
	bmi.s	.continuedcode_008
	bsr.s	Print_item_name
.continuedcode_008:		; Memory Address ($D814) and binary offset [$D490]
	tst.w	d6
	bpl		TerminateText
	rts		

Print_npc_message:		; Memory Address ($D81C) and binary offset [$D498]
	move.b	#$81,d2
	bra.s	.continuedcode_009

;fiX Label expected
	moveq	#$00,d2																;ASM_RECOVERY: npc_message_default | 7400

.continuedcode_009:		; Memory Address ($D824) and binary offset [$D4A0]
	tst.b	$0005(a4)
	bpl.s	Print_message
	movem.l	d2/a6,-(sp)
	bsr.s	Print_message
	movem.l	(sp)+,d2/a6
	lea		Player1_Data.l,a0
	btst	#$00,(a5)
	bne.s	PrintMessage_SwitchToOtherPlayerContext
	lea		Player2_Data.l,a0
PrintMessage_SwitchToOtherPlayerContext:		; Memory Address ($D846) and binary offset [$D4C2]
	movem.l	a4/a5,-(sp)
	move.l	a0,a5
	move.b	$0001(a4),d0
	jsr		Comms_GetState.w													;Short Absolute converted to symbol!
	tst.b	$0005(a4)
	bpl.s	PrintMessage_RelayToOtherPlayer
	move.b	d0,$0000(a4)
PrintMessage_RelayToOtherPlayer:		; Memory Address ($D85E) and binary offset [$D4DA]
	or.b	#$40,d2
	bsr.s	Print_message
	movem.l	(sp)+,a4/a5
	rts		

Print_timed_message:		; Memory Address ($D86A) and binary offset [$D4E6]
	; Selects timed/fading ink state $81 and enters the shared top-strip message
	; printer.
	move.b	#$81,d2
	bra.s	Print_message

Print_fix_message:		; Memory Address ($D870) and binary offset [$D4EC]
	moveq	#$00,d2
Print_message:		; Memory Address ($D872) and binary offset [$D4EE]
	; Stores the message ink and timing flag, initialises the top text strip, and
	; prints the word-stream addressed by A6.
	move.b	d2,$0052(a5)
	bsr		InitialiseText
Print_NewLine:		; Memory Address ($D87A) and binary offset [$D4F6]
	move.b	(a6)+,d0
	cmpi.b	#$FA,d0
	bcc.s	PrintNewLine_DispatchControlCode
	bsr		Print_wordstext
PrintNewLine_SpaceOrTerminate:		; Memory Address ($D886) and binary offset [$D502]
	tst.w	d6
	bmi		TerminateText
	moveq	#$20,d0
	bsr.s	Draw_TextGlyph
	subq.w	#$01,d6
	bra.s	Print_NewLine

PrintNewLine_DispatchControlCode:		; Memory Address ($D894) and binary offset [$D510]
	beq.s	PrintNewLine_DrawLiteralGlyph
	cmpi.b	#$FF,d0
	beq		TerminateText
	cmpi.b	#$FB,d0
	beq.s	Print_FB_Function
	cmpi.b	#$FE,d0
	bne.s	Print_NewLine
	move.b	(a6)+,d0
	bsr		Print_item_name
	bra.s	PrintNewLine_SpaceOrTerminate

Print_FB_Function:		; Memory Address ($D8B2) and binary offset [$D52E]
	addq.w	#$01,d6
	subq.w	#$01,a0
	bra.s	Print_NewLine

PrintNewLine_DrawLiteralGlyph:		; Memory Address ($D8B8) and binary offset [$D534]
	subq.w	#$01,a0
	move.b	(a6)+,d0
	bsr.s	Draw_TextGlyph
	bra.s	PrintNewLine_SpaceOrTerminate

Draw_TextGlyph:		; Memory Address ($D8C0) and binary offset [$D53C]
	; Selects the five-row font glyph, draws it into the enabled colour planes, and
	; advances the text cursor by one character cell.
	move.l	a0,-(sp)
	lea		GameFont.l,a1
	moveq	#$00,d1
	move.b	d0,d1
	move.w	d1,d0
	asl.w	#$02,d0
	add.w	d1,d0
	add.w	d0,a1
	moveq	#$04,d0
Print_GlyphRowsWithOptionalColumnShift:		; Memory Address ($D8D6) and binary offset [$D552]
	; Draws the glyph rows and applies the command-column horizontal shift when the
	; separator flag is set.
	move.b	(a1),d1
	swap	d1
	move.b	(a1)+,d1
	tst.b	TextDoubleWidthFlag.l
	beq.s	DrawTextGlyph_InvertRowByte
	add.l	d1,d1
	add.l	d1,d1
DrawTextGlyph_InvertRowByte:		; Memory Address ($D8E8) and binary offset [$D564]
	not.b	d1
	swap	d0
	move.w	#$0003,d0
	move.w	#$5DC0,d4
DrawTextGlyph_SelectBackgroundPlaneBit:		; Memory Address ($D8F4) and binary offset [$D570]
	move.b	d1,d3
	btst	d0,CurrentTextBackgroundInk_LowByte(pc)
	bne.s	DrawTextGlyph_SelectForegroundPlaneBit
	clr.b	d3
DrawTextGlyph_SelectForegroundPlaneBit:		; Memory Address ($D8FE) and binary offset [$D57A]
	swap	d1
	move.b	d1,d2
	swap	d1
	btst	d0,CurrentTextInk_LowByte(pc)
	bne.s	DrawTextGlyph_WriteCombinedPlaneByte
	clr.b	d2
DrawTextGlyph_WriteCombinedPlaneByte:		; Memory Address ($D90C) and binary offset [$D588]
	or.b	d3,d2
	move.b	d2,$00(a0,d4.w)
	sub.w	#$1F40,d4
	dbra	d0,DrawTextGlyph_SelectBackgroundPlaneBit
	swap	d0
	add.w	#$0028,a0
	dbra	d0,Print_GlyphRowsWithOptionalColumnShift
	move.l	(sp)+,a0
	addq.w	#$01,a0
	rts		

CurrentTextInk:		; Memory Address ($D92A) and binary offset [$D5A6]
	; Current text foreground ink word consumed by the text and glyph blitters.
	ds.b	$1
CurrentTextInk_LowByte:		; Memory Address ($D92B) and binary offset [$D5A7]
	; Low-byte alias of the current text foreground ink word.
	dc.b	$01	;01
CurrentTextBackgroundInk:		; Memory Address ($D92C) and binary offset [$D5A8]
	; Current text background ink word set by the text-extension command stream.
	ds.b	$1
CurrentTextBackgroundInk_LowByte:		; Memory Address ($D92D) and binary offset [$D5A9]
	; Low-byte alias of the current text background ink word.
	ds.b	$1
Draw_woundflash_digit:		; Memory Address ($D92E) and binary offset [$D5AA]
	move.w	#$000F,CurrentTextBackgroundInk.l
	movem.l	d4/d5,-(sp)
	lea		Data_Woundflash.l,a0
	move.l	a0,a1
	moveq	#$09,d2
	moveq	#-$01,d1
.continuedcode_011:		; Memory Address ($D946) and binary offset [$D5C2]
	move.l	d1,(a1)+
	dbra	d2,.continuedcode_011
	move.b	#$FF,TextDoubleWidthFlag.l
	bsr		BW_Blitchar
	clr.b	TextDoubleWidthFlag.l
	movem.l	(sp)+,d4/d5
	move.l	a0,a1
	move.w	d4,d1
	and.w	#$FFF7,d4
	bsr		BW_xy_to_offset
	move.w	d1,d4
	move.l	screen_ptr.l,a0
	add.w	d0,a0
	lea		CharacterPart_DefaultColourMaskTable.l,a6
	moveq	#$04,d7
	swap	d7
	moveq	#$00,d6
	bra		Draw_MonsterStrip_Shifted

Data_Woundflash:		; Memory Address ($D988) and binary offset [$D604]
	ds.b	$28
BW_Blitchar:
	; Blits one GameFont character using the current foreground/background colour
	; masks; this standalone path draws combat wound-flash digits.
	lea		GameFont.l,a1
	move.l	a0,-(sp)
	and.w	#$007F,d0
	move.w	d0,d2
	asl.w	#$02,d0
	add.w	d2,d0
	add.w	d0,a1
	move.l	CurrentTextInk.l,d2
	lea		BW_blitchar_data.l,a2
	asl.w	#$02,d2
	move.l	$00(a2,d2.w),d3
	swap	d2
	asl.w	#$02,d2
	move.l	$00(a2,d2.w),d2
	moveq	#$04,d1
.loop:
	move.b	(a1),d0
	asl.w	#$08,d0
	move.b	(a1)+,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	d0,d4
	swap	d0
	move.w	d4,d0
	move.l	d0,d4
	not.l	d0
	and.l	d3,d0
	and.l	d2,d4
	or.l	d4,d0
	move.b	d0,$0006(a0)
	swap	d0
	move.b	d0,$0002(a0)
	lsr.l	#$08,d0
	move.b	d0,(a0)
	swap	d0
	move.b	d0,$0004(a0)
	addq.w	#$08,a0
	dbra	d1,.loop
	move.l	(sp)+,a0
	rts		

BW_blitchar_data:
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FF00	;FF00
	dc.w	$0000	;0000
	dc.w	$00FF	;00FF
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FF00	;FF00
	dc.w	$FF00	;FF00
	dc.w	$FF00	;FF00
	dc.w	$00FF	;00FF
	dc.w	$FF00	;FF00
	dc.w	$FFFF	;FFFF
	dc.w	$FF00	;FF00
	dc.w	$0000	;0000
	dc.w	$00FF	;00FF
	dc.w	$FF00	;FF00
	dc.w	$00FF	;00FF
	dc.w	$00FF	;00FF
	dc.w	$00FF	;00FF
	dc.w	$FFFF	;FFFF
	dc.w	$00FF	;00FF
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$FF00	;FF00
	dc.w	$FFFF	;FFFF
	dc.w	$00FF	;00FF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	swap	d3																	;ASM_RECOVERY: draw_square | 4843
	swap	d4																	;ASM_RECOVERY: draw_square | 4844
	swap	d5																	;ASM_RECOVERY: draw_square | 4845
	move.w	d3,d4																;ASM_RECOVERY: draw_square | 3803
	move.w	d3,d5																;ASM_RECOVERY: draw_square | 3A03
	swap	d3																	;ASM_RECOVERY: draw_square | 4843
	swap	d4																	;ASM_RECOVERY: draw_square | 4844
	swap	d5																	;ASM_RECOVERY: draw_square | 4845

BW_draw_bar:
	; Fills a solid rectangle by drawing one horizontal line for each row using
	; inclusive width and height extents.
	swap	d4
	swap	d3
	move.w	d4,d3
	swap	d4
	swap	d3
	swap	d5
	move.w	d5,d7
	swap	d5
.drawbar_loop:
	bsr		BW_blit_horiz_line
	addq.w	#$01,d5
	dbra	d7,.drawbar_loop
	rts		

BW_cs_draw_frame:
	; Draws the champion-selection variant of a four-sided rectangle frame using
	; horizontal and vertical line primitives.
	addq.w	#$01,d4
	swap	d4
	swap	d3
	move.w	d4,d3
	subq.w	#$02,d3
	swap	d4
	swap	d3
	bsr		BW_blit_horiz_line
	swap	d5
	move.w	d5,d7
	swap	d5
	add.w	d7,d5
	bsr		BW_blit_horiz_line
	sub.w	d7,d5
	subq.w	#$01,d4
	addq.w	#$01,d5
	swap	d5
	swap	d3
	move.w	d5,d3
	subq.w	#$02,d3
	swap	d3
	swap	d5
	bsr		BW_blit_vertical_line
	swap	d4
	move.w	d4,d7
	swap	d4
	add.w	d7,d4
	bra		BW_blit_vertical_line

;fiX Label expected
	swap	d3
	swap	d4
	swap	d5
	move.w	d3,d4
	move.w	d3,d5
	swap	d3
	swap	d4
	swap	d5
BW_draw_frame:
	; Draws a generic four-sided rectangle outline from two horizontal and two
	; vertical lines.
	swap	d4
	swap	d3
	move.w	d4,d3
	swap	d4
	swap	d3
	bsr		BW_blit_horiz_line
	swap	d5
	move.w	d5,d7
	swap	d5
	add.w	d7,d5
	bsr		BW_blit_horiz_line
	sub.w	d7,d5
	swap	d5
	swap	d3
	move.w	d5,d3
	swap	d5
	swap	d3
	bsr.s	BW_blit_vertical_line
	swap	d4
	move.w	d4,d7
	swap	d4
	add.w	d7,d4
BW_blit_vertical_line:
	; Draws one clipped vertical line across all four bitplanes with a masked
	; AND/OR write on each screen row.
	bsr		BW_xy_to_offset
	move.l	screen_ptr.l,a0
	add.w	d0,a0
	moveq	#$00,d0
	moveq	#$00,d1
	move.b	d3,d1
	lsr.b	#$01,d1
	roxr.b	#$01,d0
	ror.w	#$01,d1
	swap	d0
	lsr.b	#$01,d1
	roxr.b	#$01,d0
	lsr.b	#$01,d1
	swap	d1
	roxr.w	#$01,d1
	or.l	d1,d0
	swap	d0
	move.b	#$7F,d1
	move.w	d4,d7
	and.w	#$0007,d7
	ror.b	d7,d1
	ror.l	d7,d0
	move.l	d3,d2
	swap	d2
.vertical_loop:
	move.b	(a0),d7
	and.b	d1,d7
	or.b	d0,d7
	move.b	d7,(a0)
	swap	d0
	move.b	$3E80(a0),d7
	and.b	d1,d7
	or.b	d0,d7
	move.b	d7,$3E80(a0)
	ror.l	#$08,d0
	move.b	$5DC0(a0),d7
	and.b	d1,d7
	or.b	d0,d7
	move.b	d7,$5DC0(a0)
	swap	d0
	move.b	$1F40(a0),d7
	and.b	d1,d7
	or.b	d0,d7
	move.b	d7,$1F40(a0)
	rol.l	#$08,d0
	add.w	#$0028,a0
	dbra	d2,.vertical_loop
	rts		

hline_data:
	dc.w	$0000	;0000
	dc.w	$00FF	;00FF
	dc.w	$FF00	;FF00
	dc.w	$FFFF	;FFFF

BW_blit_horiz_line:
	; Draws one clipped horizontal span using edge masks and the shared masked-byte
	; writer across all four bitplanes.
	movem.l	d3-d5,-(sp)
	bsr		BW_xy_to_offset
	move.l	screen_ptr.l,a0
	add.w	d0,a0
	lea		hline_data.l,a1
	move.w	d3,d0
	and.w	#$000C,d0
	lsr.w	#$01,d0
	move.w	$00(a1,d0.w),d0
	swap	d0
	add.w	d3,d3
	and.w	#$0006,d3
	move.w	$00(a1,d3.w),d0
	swap	d3
	addq.w	#$01,d3
	move.w	d4,d2
	and.w	#$0007,d2
	beq.s	BlitHorizLine_SetupFullByteRun
	subq.w	#$08,d2
	neg.w	d2
	cmp.w	d2,d3
	bgt.s	BlitHorizLine_DrawLeftEdgeByte
	moveq	#-$01,d2
	and.w	#$0007,d4
	lsr.b	d3,d2
	not.b	d2
	lsr.b	d4,d2
	move.b	d2,d3
	not.b	d3
	bsr		Blit_MaskedByteAcrossPlanes
	bra.s	BlitHorizLine_RestoreAndReturn

Blit_MaskedByteAcrossPlanes:		; Memory Address ($DBDC) and binary offset [$D858]
	; Combines one masked source byte with the existing destination byte across all
	; four screen bitplanes.
	move.l	d0,d6
	moveq	#$03,d5
	moveq	#$00,d4
.horiz_loop:
	move.b	$00(a0,d4.w),d1
	and.b	d2,d0
	and.b	d3,d1
	or.b	d0,d1
	move.b	d1,$00(a0,d4.w)
	ror.l	#$08,d0
	add.w	#$1F40,d4
	dbra	d5,.horiz_loop
	move.l	d6,d0
	rts		

BlitHorizLine_DrawLeftEdgeByte:		; Memory Address ($DBFE) and binary offset [$D87A]
	sub.w	d2,d3
	swap	d3
	and.w	#$0007,d4
	moveq	#-$01,d2
	lsr.b	d4,d2
	move.b	d2,d3
	not.b	d3
	bsr.s	Blit_MaskedByteAcrossPlanes
	swap	d3
	addq.w	#$01,a0
BlitHorizLine_SetupFullByteRun:		; Memory Address ($DC14) and binary offset [$D890]
	move.w	d3,d4
	lsr.w	#$03,d3
	beq.s	BlitHorizLine_DrawRightEdgeByte
	subq.w	#$01,d3
	move.l	a0,a1
	moveq	#$00,d2
	moveq	#$03,d5
BlitHorizLine_PlaneFillLoop:		; Memory Address ($DC22) and binary offset [$D89E]
	move.l	a1,a0
	add.w	d2,a0
	move.w	d3,d1
BlitHorizLine_FillByteRun:		; Memory Address ($DC28) and binary offset [$D8A4]
	move.b	d0,(a0)+
	dbra	d1,BlitHorizLine_FillByteRun
	ror.l	#$08,d0
	add.w	#$1F40,d2
	dbra	d5,BlitHorizLine_PlaneFillLoop
	sub.w	#$1F40,d2
	sub.w	d2,a0
BlitHorizLine_DrawRightEdgeByte:		; Memory Address ($DC3E) and binary offset [$D8BA]
	and.w	#$0007,d4
	beq.s	BlitHorizLine_RestoreAndReturn
	moveq	#-$01,d3
	lsr.b	d4,d3
	move.b	d3,d2
	not.b	d2
	bsr.s	Blit_MaskedByteAcrossPlanes
BlitHorizLine_RestoreAndReturn:		; Memory Address ($DC4E) and binary offset [$D8CA]
	movem.l	(sp)+,d3-d5
	rts		

BW_xy_to_offset:
	; Converts screen X in D4 and Y in D5 to the byte offset (Y*320+X)/8 used by
	; the planar drawing primitives.
	move.w	d5,d0
	add.w	d0,d0
	add.w	d0,d0
	add.w	d5,d0
	asl.w	#$06,d0
	add.w	d4,d0
	lsr.w	#$03,d0
	rts		

WordsText:
	dc.b	$07	;07
	dc.b	'BLODWYN'
	dc.b	$07	;07
	dc.b	'MURLOCK'
	dc.b	$07	;07
	dc.b	'ELEANOR'
	dc.b	$07	;07
	dc.b	'ROSANNE'
	dc.b	$07	;07
	dc.b	'ASTROTH'
	dc.b	$06	;06
	dc.b	'ZOTHEN'
	dc.b	$08	;08
	dc.b	'BALDRICK'
	dc.b	$06	;06
	dc.b	'ELFRIC'
	dc.b	$0A	;0A
	dc.b	'SIR EDWARD'
	dc.b	$06	;06
	dc.b	'MEGRIM'
	dc.b	$06	;06
	dc.b	'SETHRA'
	dc.b	$07	;07
	dc.b	'MR.FLAY'
	dc.b	$06	;06
	dc.b	'ULRICH'
	dc.b	$07	;07
	dc.b	'ZASTAPH'
	dc.b	$07	;07
	dc.b	'HENGIST'
	dc.b	$0A	;0A
	dc.b	'THAI CHANG'
	dc.b	$0B	;0B
	dc.b	'COMMUNICATE'
	dc.b	$07	;07
	dc.b	'COMMEND'
	dc.b	$04	;04
	dc.b	'VIEW'
	dc.b	$04	;04
	dc.b	'WAIT'
	dc.b	$07	;07
	dc.b	'CORRECT'
	dc.b	$07	;07
	dc.b	'DISMISS'
	dc.b	$04	;04
	dc.b	'CALL'
	dc.b	$06	;06
	dc.b	'UNABLE'
	dc.b	$03	;03
	dc.b	'WHO'
	dc.b	$04	;04
	dc.b	'DOST'
	dc.b	$04	;04
	dc.b	'THOU'
	dc.b	$04	;04
	dc.b	'WISH'
	dc.b	$02	;02
	dc.b	'TO'
	dc.b	$06	;06
	dc.b	'ACCEPT'
	dc.b	$03	;03
	dc.b	'THY'
	dc.b	$06	;06
	dc.b	'HONOUR'
	dc.b	$08	;08
	dc.b	'EVERYONE'
	dc.b	$09	;09
	dc.b	'APOLOGISE'
	dc.b	$03	;03
	dc.b	'FOR'
	dc.b	$06	;06
	dc.b	'BREATH'
	dc.b	$05	;05
	dc.b	'LEAVE'
	dc.b	$03	;03
	dc.b	'THE'
	dc.b	$05	;05
	dc.b	'PARTY'
	dc.b	$04	;04
	dc.b	'HAST'
	dc.b	$04	;04
	dc.b	'NONE'
	dc.b	$02	;02
	dc.b	'BE'
	dc.b	$03	;03
	dc.b	'OUT'
	dc.b	$06	;06
	dc.b	'GAINED'
	dc.b	$05	;05
	dc.b	'LEVEL'
	dc.b	$03	;03
	dc.b	'LET'
	dc.b	$04	;04
	dc.b	'GIVE'
	dc.b	$04	;04
	dc.b	'SOME'
	dc.b	$06	;06
	dc.b	'DEPART'
	dc.b	$02	;02
	dc.b	'GO'
	dc.b	$07	;07
	dc.b	'REJOINS'
	dc.b	$05	;05
	dc.b	'TRULY'
	dc.b	$07	;07
	dc.b	'THROUGH'
	dc.b	$02	;02
	dc.b	'IS'
	dc.b	$07	;07
	dc.b	'PRESENT'
	dc.b	$06	;06
	dc.b	'NORMAL'
	dc.b	$08	;08
	dc.b	'RESTORED'
	dc.b	$05	;05
	dc.b	'THERE'
	dc.b	$04	;04
	dc.b	'BODY'
	dc.b	$04	;04
	dc.b	'HERE'
	dc.b	$07	;07
	dc.b	'RECRUIT'
	dc.b	$02	;02
	dc.b	'NO'
	dc.b	$08	;08
	dc.b	'IDENTIFY'
	dc.b	$07	;07
	dc.b	'INQUIRY'
	dc.b	$05	;05
	dc.b	'WHERE'
	dc.b	$06	;06
	dc.b	'ABOUTS'
	dc.b	$04	;04
	dc.b	'TRAD'
	dc.b	$05	;05
	dc.b	'SMALL'
	dc.b	$04	;04
	dc.b	'TALK'
	dc.b	$05	;05
	dc.b	'YES  '
	dc.b	$06	;06
	dc.b	'    NO'
	dc.b	$05	;05
	dc.b	'BRIBE'
	dc.b	$06	;06
	dc.b	'THREAT'
	dc.b	$05	;05
	dc.b	'GREET'
	dc.b	$03	;03
	dc.b	'ING'
	dc.b	$04	;04
	dc.b	'NAME'
	dc.b	$04	;04
	dc.b	'SELF'
	dc.b	$06	;06
	dc.b	'REVEAL'
	dc.b	$04	;04
	dc.b	'FOLK'
	dc.b	$04	;04
	dc.b	'LORE'
	dc.b	$05	;05
	dc.b	'MAGIC'
	dc.b	$04	;04
	dc.b	'ITEM'
	dc.b	$06	;06
	dc.b	'OBJECT'
	dc.b	$06	;06
	dc.b	'PERSON'
	dc.b	$04	;04
	dc.b	'GOLD'
	dc.b	$08	;08
	dc.b	'PURCHASE'
	dc.b	$08	;08
	dc.b	'EXCHANGE'
	dc.b	$04	;04
	dc.b	'SELL'
	dc.b	$06	;06
	dc.b	'PRAISE'
	dc.b	$05	;05
	dc.b	'CURSE'
	dc.b	$05	;05
	dc.b	'BOAST'
	dc.b	$06	;06
	dc.b	'RETORT'
	dc.b	$06	;06
	dc.b	'WIZARD'
	dc.b	$0A	;0A
	dc.b	'ADVENTURER'
	dc.b	$08	;08
	dc.b	'CUTPURSE'
	dc.b	$02	;02
	dc.b	'MY'
	dc.b	$05	;05
	dc.b	'AUGHT'
	dc.b	$05	;05
	dc.b	'OFFER'
	dc.b	$02	;02
	dc.b	'OR'
	dc.b	$04	;04
	dc.b	'AWAY'
	dc.b	$0B	;0B
	dc.b	'STONEMAIDEN'
	dc.b	$09	;09
	dc.b	'DARKHEART'
	dc.b	$09	;09
	dc.b	'OF AVALON'
	dc.b	$09	;09
	dc.b	'SWIFTHAND'
	dc.b	$09	;09
	dc.b	'SLAEMWORT'
	dc.b	$0A	;0A
	dc.b	'RUNECASTER'
	dc.b	$08	;08
	dc.b	'THE DUNG'
	dc.b	$09	;09
	dc.b	'FALAENDOR'
	dc.b	$04	;04
	dc.b	'LION'
	dc.b	$0B	;0B
	dc.b	'OF MOONWYCH'
	dc.b	$09	;09
	dc.b	'BHOAGHAIL'
	dc.b	$0A	;0A
	dc.b	'SEPULCRAST'
	dc.b	$08	;08
	dc.b	'STERNAXE'
	dc.b	$07	;07
	dc.b	'MANTRIC'
	dc.b	$09	;09
	dc.b	'MELDANASH'
	dc.b	$07	;07
	dc.b	'OF YINN'
	dc.b	$07	;07
	dc.b	'COURAGE'
	dc.b	$08	;08
	dc.b	'STRENGTH'
	dc.b	$07	;07
	dc.b	'PROWESS'
	dc.b	$08	;08
	dc.b	'ANCESTRY'
	dc.b	$04	;04
	dc.b	'FAME'
	dc.b	$07	;07
	dc.b	'ABILITY'
	dc.b	$09	;09
	dc.b	'KNOWLEDGE'
	dc.b	$05	;05
	dc.b	'SPEED'
	dc.b	$0B	;0B
	dc.b	'UNSURPASSED'
	dc.b	$09	;09
	dc.b	'UNRIVALED'
	dc.b	$0A	;0A
	dc.b	'INCREDIBLE'
	dc.b	$0A	;0A
	dc.b	'STUPENDOUS'
	dc.b	$07	;07
	dc.b	'GODLIKE'
	dc.b	$0A	;0A
	dc.b	'UNDISPUTED'
	dc.b	$0A	;0A
	dc.b	'UNEQUALLED'
	dc.b	$08	;08
	dc.b	'RENOWNED'
	dc.b	$05	;05
	dc.b	'FIGHT'
	dc.b	$04	;04
	dc.b	'TALK'
	dc.b	$05	;05
	dc.b	'SOUND'
	dc.b	$06	;06
	dc.b	'BEHAVE'
	dc.b	$04	;04
	dc.b	'LOOK'
	dc.b	$06	;06
	dc.b	'APPEAR'
	dc.b	$04	;04
	dc.b	'SEEM'
	dc.b	$03	;03
	dc.b	'ART'
	dc.b	$04	;04
	dc.b	'LIKE'
	dc.b	$01	;01
	dc.b	'A'
	dc.b	$04	;04
	dc.b	'VERY'
	dc.b	$09	;09
	dc.b	'STRANGELY'
	dc.b	$08	;08
	dc.b	'MIGHTILY'
	dc.b	$06	;06
	dc.b	'HUGELY'
	dc.b	$0A	;0A
	dc.b	'INCREDIBLY'
	dc.b	$0A	;0A
	dc.b	'ESPECIALLY'
	dc.b	$09	;09
	dc.b	'IMMENSELY'
	dc.b	$05	;05
	dc.b	'ODDLY'
	dc.b	$06	;06
	dc.b	'STRONG'
	dc.b	$05	;05
	dc.b	'BRAVE'
	dc.b	$08	;08
	dc.b	'POWERFUL'
	dc.b	$05	;05
	dc.b	'NOBLE'
	dc.b	$04	;04
	dc.b	'WISE'
	dc.b	$04	;04
	dc.b	'FINE'
	dc.b	$08	;08
	dc.b	'SPLENDID'
	dc.b	$07	;07
	dc.b	'AWESOME'
	dc.b	$07	;07
	dc.b	'WARRIOR'
	dc.b	$04	;04
	dc.b	'SAGE'
	dc.b	$04	;04
	dc.b	'HERO'
	dc.b	$06	;06
	dc.b	'LEADER'
	dc.b	$06	;06
	dc.b	'MASTER'
	dc.b	$06	;06
	dc.b	'FRIEND'
	dc.b	$07	;07
	dc.b	'SCHOLAR'
	dc.b	$06	;06
	dc.b	'EXPERT'
	dc.b	$0C	;0C
	dc.b	'DISGUSTINGLY'
	dc.b	$0B	;0B
	dc.b	'GROTESQUELY'
	dc.b	$0B	;0B
	dc.b	'SICKENINGLY'
	dc.b	$07	;07
	dc.b	'UTTERLY'
	dc.b	$0C	;0C
	dc.b	'UNBELIEVABLY'
	dc.b	$0B	;0B
	dc.b	'ABHORRENTLY'
	dc.b	$0B	;0B
	dc.b	'APPALLINGLY'
	dc.b	$0D	;0D
	dc.b	'INDESCRIBABLY'
	dc.b	$06	;06
	dc.b	'SMELLY'
	dc.b	$05	;05
	dc.b	'GROSS'
	dc.b	$06	;06
	dc.b	'STUPID'
	dc.b	$08	;08
	dc.b	'PATHETIC'
	dc.b	$08	;08
	dc.b	'GORMLESS'
	dc.b	$06	;06
	dc.b	'FEEBLE'
	dc.b	$05	;05
	dc.b	'WARTY'
	dc.b	$04	;04
	dc.b	'UGLY'
	dc.b	$04	;04
	dc.b	'SLUG'
	dc.b	$04	;04
	dc.b	'TOAD'
	dc.b	$04	;04
	dc.b	'CLOD'
	dc.b	$06	;06
	dc.b	'MAGGOT'
	dc.b	$06	;06
	dc.b	'COWARD'
	dc.b	$06	;06
	dc.b	'ZOMBIE'
	dc.b	$0A	;0A
	dc.b	'BUMBLEFOOT'
	dc.b	$03	;03
	dc.b	'OAF'
	dc.b	$04	;04
	dc.b	'STEP'
	dc.b	$05	;05
	dc.b	'ASIDE'
	dc.b	$06	;06
	dc.b	'SUFFER'
	dc.b	$03	;03
	dc.b	'DIE'
	dc.b	$05	;05
	dc.b	'SORRY'
	dc.b	$03	;03
	dc.b	'ONE'
	dc.b	$04	;04
	dc.b	'HEAR'
	dc.b	$07	;07
	dc.b	'DISTANT'
	dc.b	$05	;05
	dc.b	'FRONT'
	dc.b	$04	;04
	dc.b	'LEFT'
	dc.b	$04	;04
	dc.b	'REAR'
	dc.b	$05	;05
	dc.b	'RIGHT'
	dc.b	$03	;03
	dc.b	'YOU'
	dc.b	$05	;05
	dc.b	'THING'
	dc.b	$04	;04
	dc.b	'WILT'
	dc.b	$05	;05
	dc.b	'TOKEN'
	dc.b	$01	;01
	dc.b	'I'
Objects_Texts:		; Memory Address ($E21E) and binary offset [$DE9A]
	INCBIN "/data/BLOODWYCH439-clean/data/objecttext.block"
Notice_SelectChampions:
	dc.b	'PLEASE SELECT YOUR CHAMPIONS...'
	dc.b	$FF	;FF
Notice_SelectChampion:
	dc.b	'PLAYER 0 SELECT THY CHAMPION....'
	dc.b	$FF	;FF
	dc.b	$00	;00
Object_Definition_Table:		; Memory Address ($E4C2) and binary offset [$E13E]
	; Complete $6E × 4 object-definition table: pocket graphic, pocket colour,
	; first name word and second name word.
	INCBIN "/data/BLOODWYCH439-clean/data/objectdefinitions.block"
Object_Floor_DataTable:		; Memory Address ($E67A) and binary offset [$E2F6]
	INCBIN "/data/BLOODWYCH439-clean/data/objectflooricons.block"
GFX_ObjectsOnFloor_Heights:		; Memory Address ($E6E8) and binary offset [$E364]
	INCBIN "/data/BLOODWYCH439-clean/gfx/ObjectsOnFloor.heights"
Object_Floor_Colours:		; Memory Address ($E770) and binary offset [$E3EC]
	INCBIN "/data/BLOODWYCH439-clean/data/objectfloor.colours"
Object_Floor_Palettes:		; Memory Address ($E7DE) and binary offset [$E45A]
	INCBIN "/data/BLOODWYCH439-clean/data/objectfloor.palette"
GFX_ObjectsOnFloor_Offsets:		; Memory Address ($E88A) and binary offset [$E506]
	INCBIN "/data/BLOODWYCH439-clean/gfx/ObjectsOnFloor.offsets"
FoodStatusMessageTemplate:		; Memory Address ($E998) and binary offset [$E614]
	; Mutable colour-and-text stream used by the food-status display.
	dc.b	$FC	;FC
	dc.b	$12	;12
	dc.b	$0B	;0B
	dc.b	$FE	;FE
	dc.b	$04	;04
	dc.b	$02	;02
	dc.b	'       '
	dc.b	$03	;03
	dc.b	$FF	;FF
	dc.b	$00	;00
BeginGameScroll:		; Memory Address ($E9A8) and binary offset [$E624]
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$03	;03
	dc.b	$FE	;FE
	dc.b	$0D	;0D
	dc.b	$FD	;FD
	dc.b	$03	;03
	dc.b	'PLAYER 0'
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	$FE	;FE
	dc.b	$00	;00
	dc.b	'THOU ART'
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'NOW READY'
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'TO BEGIN'
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'THY QUEST'
	dc.b	$FF	;FF
ChampionStatsScroll_FoodTextTemplate:		; Memory Address ($E9E8) and binary offset [$E664]
	; Print_fflim_text stream for FOOD. Uses ink $D for the heading and ink $4 for
	; raw GameFont glyphs $02/$03 surrounding six bar cells.
	INCBIN "/data/BLOODWYCH439-clean/data/champion-stats-scroll-food.text"
SpellPointsMessageTemplate:		; Memory Address ($EA00) and binary offset [$E67C]
	; Mutable SP.PTS colour-and-text stream containing current and maximum
	; spell-point fields.
	dc.b	$FE	;FE
	dc.b	$0B	;0B
	dc.b	$FD	;FD
	dc.b	$00	;00
	dc.b	'SP.PTS '
	dc.b	$FE	;FE
	dc.b	$06	;06
	dc.b	'  /  '
	dc.b	$FF	;FF
	dc.b	$00	;00
InventoryPanelHeaderTemplate:		; Memory Address ($EA14) and binary offset [$E690]
	; Colour-and-text stream for the INVENTORY panel heading.
	dc.b	$FC	;FC
	dc.b	$1D	;1D
	dc.b	$03	;03
	dc.b	$FE	;FE
	dc.b	$0D	;0D
	dc.b	$FD	;FD
	dc.b	$03	;03
	dc.b	'INVENTORY'
	dc.b	$FF	;FF
ArmourHeaderMessageTemplate:		; Memory Address ($EA25) and binary offset [$E6A1]
	; Colour-and-text stream for the ARMOUR heading and value field.
	dc.b	$FC	;FC
	dc.b	$1D	;1D
	dc.b	$08	;08
	dc.b	'ARMOUR:'
	dc.b	$FE	;FE
	dc.b	$0E	;0E
	dc.b	'   '
	dc.b	$FF	;FF
	dc.b	$00	;00
CostMessageTemplate:		; Memory Address ($EA36) and binary offset [$E6B2]
	; Mutable COST colour-and-text stream containing the patched two-digit value.
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$0A	;0A
	dc.b	$FE	;FE
	dc.b	$0D	;0D
	dc.b	$FD	;FD
	dc.b	$00	;00
	dc.b	'COST'
	dc.b	$FE	;FE
	dc.b	$0C	;0C
	dc.b	$04	;04
	dc.b	$FE	;FE
	dc.b	$0D	;0D
	dc.b	'00'
	dc.b	$FE	;FE
	dc.b	$0C	;0C
	dc.b	$05	;05
	dc.b	$FF	;FF
CastQualityMessageTemplate:		; Memory Address ($EA4C) and binary offset [$E6C8]
	; Mutable CAST percentage colour-and-text stream containing the patched quality
	; field.
	dc.b	$FE	;FE
	dc.b	$0D	;0D
	dc.b	'CAST % '
	dc.b	$FE	;FE
	dc.b	$04	;04
	dc.b	$02	;02
	dc.b	'      '
	dc.b	$03	;03
	dc.b	' '
	dc.b	$FF	;FF
	dc.b	$00	;00
Msg_CostTooHigh:		; Memory Address ($EA62) and binary offset [$E6DE]
	dc.b	$FE	;FE
	dc.b	$0C	;0C
	dc.b	'COST TOO HIGH'
	dc.b	$FF	;FF
Interface_Hitboxes_Main:		; Memory Address ($EA72) and binary offset [$E6EE]
	; Seventeen main player-interface hitbox records for action IDs $00-$10; each
	; record is X minimum, X maximum, Y minimum and Y maximum.
	INCBIN "/data/BLOODWYCH439-clean/data/Interface_Hitboxes_Main.lookup"
Interface_Hitboxes_Command:		; Memory Address ($EAFA) and binary offset [$E776]
	; Six communications/options hitbox records for action IDs $1C-$21, stored as
	; inclusive X/Y rectangle words.
	INCBIN "/data/BLOODWYCH439-clean/data/Interface_Hitboxes_Command.lookup"
Character_Stats_DataTable:		; Memory Address ($EB2A) and binary offset [$E7A6]
	; Sixteen 32-byte champion-stat records, including original placement and
	; facing byte $18.
	INCBIN "/data/BLOODWYCH439-clean/data/champions.stats"
Character_Pockets_DataTable:		; Memory Address ($ED2A) and binary offset [$E9A6]
	INCBIN "/data/BLOODWYCH439-clean/data/champions.pockets"
adrW_00EE2A:		; Memory Address ($EE2A) and binary offset [$EAA6]
	ds.b	$2
ChampionSelectionLiveActionFlag:		; Memory Address ($EE2C) and binary offset [$EAA8]
	; Distinguishes the champion-selection confirmation pass from the live action
	; that exits into play.
	ds.b	$1
TextDoubleWidthFlag:		; Memory Address ($EE2D) and binary offset [$EAA9]
	; When set, the text blitter doubles the glyph column bit spacing; used by
	; large hit numbers and the $FC text control.
	ds.b	$1
CurrentTower:
	ds.b	$2
MultiPlayer:
	dc.w	$FFFF	;FFFF
RingUses:		; Memory Address ($EE32) and binary offset [$EAAE]
	dc.w	$0102	;0102
	dc.w	$0303	;0303
WorldTick_300UnitCountdown:		; Memory Address ($EE36) and binary offset [$EAB2]
	; Reloaded to 300 to gate linked-magic decay, floor-trigger work, navigation
	; rebuilds, and party maintenance.
	ds.b	$2
ActionSubcycleCountdown:		; Memory Address ($EE38) and binary offset [$EAB4]
	; Seven-unit divider controlling party timers and the full unpacked-actor
	; traversal.
	ds.b	$4
WornSpellDecayGraceCountdown:		; Memory Address ($EE3C) and binary offset [$EAB8]
	; Grace countdown that temporarily suppresses party food drain and worn-spell
	; decay.
	ds.b	$1
CastingFatigueSubcycleCountdown:		; Memory Address ($EE3D) and binary offset [$EAB9]
	; Subcycle countdown controlling how often casting-fatigue recovery runs.
	dc.b	$01	;01
SpellEntity_CasterIndex:		; Memory Address ($EE3E) and binary offset [$EABA]
	; Working caster index copied into byte $0C of newly allocated live entities;
	; $FF denotes a monster or non-champion source.
	ds.b	$1
StatUpdateLoop_AlternateTickGate:		; Memory Address ($EE3F) and binary offset [$EABB]
	; Bit gate toggled by actor scans so the slow stat-update loop runs on
	; alternate passes.
	ds.b	$1
Current_TowerMapHeaderCache:		; Memory Address ($EE40) and binary offset [$EABC]
	; Runtime copy of the selected tower's $38-byte map header. It supplies floor
	; dimensions, cell-data offsets, coordinate offsets, and special-floor values
	; to map routines.
	ds.b	$10
Resolve_DiagonalPillarSourceCell_ScratchTable:		; Memory Address ($EE50) and binary offset [$EACC]
	; Indexed scratch words used by Resolve_DiagonalPillarSourceCell.
	ds.b	$10
Compute_StairAlignedDestination_ScratchTable:		; Memory Address ($EE60) and binary offset [$EADC]
	; Indexed scratch words used by Compute_StairAlignedDestination.
	ds.b	$10
CurrentFloorWidth:		; Memory Address ($EE70) and binary offset [$EAEC]
	; Word-sized cached width of the currently selected floor.
	ds.b	$1
CurrentFloorWidth_LowByte:		; Memory Address ($EE71) and binary offset [$EAED]
	; Low-byte alias written when caching the selected floor width.
	ds.b	$1
CurrentFloorHeight:		; Memory Address ($EE72) and binary offset [$EAEE]
	; Word-sized cached height of the currently selected floor.
	ds.b	$1
CurrentFloorHeight_LowByte:		; Memory Address ($EE73) and binary offset [$EAEF]
	; Low-byte alias written when caching the selected floor height.
	ds.b	$3
Live_PlayerPosition:		; Memory Address ($EE76) and binary offset [$EAF2]
	ds.b	$2
Current_TowerMapDataBase:		; Memory Address ($EE78) and binary offset [$EAF4]
	; Pointer to the currently selected tower's map resource immediately after its
	; $38-byte header. Map-cell and object/trap routines use this as their shared
	; data base.
	dc.l	MapData1+Map_HeaderSize	;0000EF78	;Long Addr replaced with Symbol *Fix stored address **
Player1_Data:
	ds.b	$1
Player1_PauseInputFlag:		; Memory Address ($EE7D) and binary offset [$EAF9]
	; Player 1 pause wake flag; bit 7 resumes the paused input loop.
	ds.b	$1
Player1_MousePosition:		; Memory Address ($EE7E) and binary offset [$EAFA]
	; Player 1 packed mouse position, with X in the high word and Y in the low
	; word.
	ds.b	$4
Player1_CurrentChampionNumber:		; Memory Address ($EE82) and binary offset [$EAFE]
	; Word-valued Player 1 active champion number; its low byte is reused as
	; selection-stage count state.
	ds.b	$1
Player1_ChampionCount_PendingCommit:		; Memory Address ($EE83) and binary offset [$EAFF]
	; Low byte staged during champion selection and copied to Player1_ChampionCount
	; when setup completes.
	ds.b	$1
Player1_InterfacePanelYOffset:		; Memory Address ($EE84) and binary offset [$EB00]
	; Player 1 vertical panel offset added to interface drawing and hit-test
	; coordinates.
	ds.b	$2
Player1_InterfaceScreenBufferOffset:		; Memory Address ($EE86) and binary offset [$EB02]
	; Player 1 framebuffer destination offset; later Player1_Data words at +$10 and
	; +$12 hold the primary and secondary UI colour indices.
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0007	;0007
	dc.w	$0008	;0008
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
Player1_ChampionCount:		; Memory Address ($EE94) and binary offset [$EB10]
	dc.l	$FFFFFFFF	;FFFFFFFF
AttackTypeNoSpells_FixedOriginPosition:		; Memory Address ($EE98) and binary offset [$EB14]
	; Packed fixed-origin coordinate substituted by AttackType_NoSpells for the
	; configured monster form.
	ds.b	$6
RasterInterruptCountdownA:		; Memory Address ($EE9E) and binary offset [$EB1A]
	; First raster-interrupt countdown, decremented and clamped at zero each Player
	; 1 frame service.
	ds.b	$4
Player1_ChampionPointer:		; Memory Address ($EEA2) and binary offset [$EB1E]
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.b	$FF	;FF
Player1_ControlledActorScanIndex:		; Memory Address ($EEB1) and binary offset [$EB2D]
	; Player 1 controlled-actor scan index; matching actor records skip their
	; ordinary attack processing.
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
Player1_MouseYClampBounds:		; Memory Address ($EEB6) and binary offset [$EB32]
	; Player 1 packed maximum/minimum mouse-Y clamp bounds.
	dc.w	$0000	;0000
	dc.w	$00FF	;00FF
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
Player1_DialogueFadeTimer:		; Memory Address ($EEC6) and binary offset [$EB42]
	; Player 1 dialogue colour-ramp step countdown.
	ds.b	$2
Player1_DialogueRampColour:		; Memory Address ($EEC8) and binary offset [$EB44]
	; Player 1 cached dialogue-ramp colour written to hardware palette register 15.
	ds.b	$6
Player1_DialogueFadeControl:		; Memory Address ($EECE) and binary offset [$EB4A]
	; Player 1 dialogue-fade control byte; bit 7 disables the fade path.
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
Player1_PendingAction:		; Memory Address ($F256) and binary offset [$EED2]
	; Pending action byte for player 1; keyboard and external overlays can write
	; here before the player loop consumes it.
	ds.b	$3
AttackTypeNoSpells_FixedOriginFormCode:		; Memory Address ($EED5) and binary offset [$EB51]
	; Monster form code that enables AttackType_NoSpells fixed-origin distance
	; checks.
	ds.b	$1
Player1_ShieldHighlightCountdowns:		; Memory Address ($EED6) and binary offset [$EB52]
	; Base of Player 1 per-formation-slot shield-highlight countdown bytes.
	dc.l	$FFFFFFFF	;FFFFFFFF
	dc.l	$FFFFFFFF	;FFFFFFFF
Player2_Data:
	dc.b	$01	;01
Player2_PauseInputFlag:		; Memory Address ($EEDF) and binary offset [$EB5B]
	; Player 2 pause wake flag; bit 7 resumes the paused input loop.
	ds.b	$1
Player2_MousePosition:		; Memory Address ($EEE0) and binary offset [$EB5C]
	; Player 2 packed mouse position, with X in the high word and Y in the low
	; word.
	ds.b	$4
Player2_CurrentChampionNumber:		; Memory Address ($EEE4) and binary offset [$EB60]
	; Word-valued Player 2 active champion number.
	ds.b	$1
Player2_ChampionCount:		; Memory Address ($EEE5) and binary offset [$EB61]
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$60	;60
	dc.b	$0F	;0F
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$09	;09
	dc.b	$00	;00
	dc.b	$0C	;0C
Player2_SelectionUIMode:		; Memory Address ($EEF2) and binary offset [$EB6E]
	; Player 2 champion-selection panel mode word; -1 marks inactive or
	; ready-to-exit.
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
Player2_ChampionPointer:		; Memory Address ($EEF6) and binary offset [$EB72]
	dc.l	$FFFFFFFF	;FFFFFFFF
AttackTypeArcBoltMachine_FixedOriginPosition:		; Memory Address ($EEFA) and binary offset [$EB76]
	; Packed fixed-origin coordinate substituted by AttackType_ArcBoltMachine for
	; the configured monster form.
	ds.b	$6
RasterInterruptCountdownB:		; Memory Address ($EF00) and binary offset [$EB7C]
	; Second raster-interrupt countdown, decremented and clamped at zero beside the
	; first.
	ds.b	$4
Player2_ChampionRosterShadowCopy:		; Memory Address ($EF04) and binary offset [$EB80]
	; Shadow copy of the packed Player 2 champion roster written during normal and
	; quick-start setup.
	dc.l	$FFFFFFFF	;FFFFFFFF
	dc.l	$00000000	;00000000
	dc.l	$0000FFFF	;0000FFFF	;Long Addr replaced with Symbol
	dc.w	$FFFF	;FFFF
	dc.b	$FF	;FF
Player2_ControlledActorScanIndex:		; Memory Address ($EF13) and binary offset [$EB8F]
	; Player 2 controlled-actor scan index; matching actor records skip their
	; ordinary attack processing.
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
Player2_MouseYClampBounds:		; Memory Address ($EF18) and binary offset [$EB94]
	; Player 2 packed maximum/minimum mouse-Y clamp bounds.
	dc.w	$0000	;0000
	dc.w	$00FF	;00FF
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00FF	;00FF
	dc.w	$0000	;0000
Player2_PendingAction:		; Memory Address ($F2B8) and binary offset [$EF34]
	; Pending action byte for player 2; keyboard and external overlays can write
	; here before the player loop consumes it.
	ds.b	$3
AttackTypeArcBoltMachine_FixedOriginFormCode:		; Memory Address ($EF37) and binary offset [$EBB3]
	; Monster form code that enables AttackType_ArcBoltMachine fixed-origin
	; distance checks.
	ds.b	$1
Player2_ShieldHighlightCountdowns:		; Memory Address ($EF38) and binary offset [$EBB4]
	; Base of Player 2 per-formation-slot shield-highlight countdown bytes.
	dc.l	$FFFFFFFF	;FFFFFFFF
	dc.l	$FFFFFFFF	;FFFFFFFF
MapData1:		; Memory Address ($EF40) and binary offset [$EBBC]
	INCBIN "/data/BLOODWYCH439-clean/maps/mod0.map"

ObjectData_1:		; Memory Address ($FF40) and binary offset [$FBBC]
	INCBIN "/data/BLOODWYCH439-clean/maps/mod0.obj"
MapData2:		; Memory Address ($10342) and binary offset [$FFBE]
	INCBIN "/data/BLOODWYCH439-clean/maps/serp.map"
ObjectData_2:		; Memory Address ($11342) and binary offset [$10FBE]
	INCBIN "/data/BLOODWYCH439-clean/maps/serp.obj"
MapData3:		; Memory Address ($11744) and binary offset [$113C0]
	INCBIN "/data/BLOODWYCH439-clean/maps/moon.map"
ObjectData_3:		; Memory Address ($12744) and binary offset [$123C0]
	INCBIN "/data/BLOODWYCH439-clean/maps/moon.obj"
MapData4:		; Memory Address ($12B46) and binary offset [$127C2]
	INCBIN "/data/BLOODWYCH439-clean/maps/drag.map"
ObjectData_4:		; Memory Address ($13B46) and binary offset [$137C2]
	INCBIN "/data/BLOODWYCH439-clean/maps/drag.obj"
MapData5:		; Memory Address ($13F48) and binary offset [$13BC4]
	INCBIN "/data/BLOODWYCH439-clean/maps/chaos.map"
ObjectData_5:		; Memory Address ($14F48) and binary offset [$14BC4]
	INCBIN "/data/BLOODWYCH439-clean/maps/chaos.obj"
MapData6:		; Memory Address ($1534A) and binary offset [$14FC6]
	INCBIN "/data/BLOODWYCH439-clean/maps/zendik.map"
ObjectData_6:		; Memory Address ($1634A) and binary offset [$15FC6]
	INCBIN "/data/BLOODWYCH439-clean/maps/zendik.obj"
PartyNavigationField_FrontierBufferA:		; Memory Address ($1674C) and binary offset [$163C8]
	; First breadth-first navigation frontier buffer, ping-ponged with the second
	; buffer each expansion layer.
	ds.b	$80
PartyNavigationField_FrontierBufferB:		; Memory Address ($167CC) and binary offset [$16448]
	; Second breadth-first navigation frontier buffer, ping-ponged with the first
	; buffer each expansion layer.
	ds.b	$80
BitReverse_LookupBuffer:		; Memory Address ($1684C) and binary offset [$164C8]
	; Working lookup buffer containing bit-reversed byte values used by the floor
	; and ceiling renderer.
	ds.b	$100
Spells_Practiced_DataTable:		; Memory Address ($1694C) and binary offset [$165C8]
	ds.b	$132
BigMonsterList:
	ds.b	$CE
Comms_StateRecords:		; Memory Address ($16B4C) and binary offset [$167C8]
	; Two sixteen-byte communication state records, one for each player.
	ds.b	$20
PhysicalAttack_WorkingValues:		; Memory Address ($16B6C) and binary offset [$167E8]
	; Temporary physical-attack result, attacker, defender, weapon and armour
	; values.
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
UnpackedMonsters:
	; Live monster workspace at $16B7E, preceded by a two-byte count.
	ds.b	$800
ProjectileImpact_MonsterRecordScratch:		; Memory Address ($1737E) and binary offset [$16FFA]
	; Sixteen-byte projectile monster-record copy retained while the live record is
	; removed and impact damage is resolved.
	ds.b	$10
MonsterTeamGroupCount:		; Memory Address ($1738E) and binary offset [$1700A]
	; Count of populated team groups in MonsterTeamIndexTable.
	dc.w	$FFFF	;FFFF
MonsterTeamIndexTable:		; Memory Address ($17390) and binary offset [$1700C]
	; Twenty-five four-byte team groups; $FF marks an empty member slot.
	ds.b	$64
LinkedMagicRecordListLength:		; Memory Address ($173F4) and binary offset [$17070]
	; Active byte length of the four-byte linked-magic record list.
	ds.b	$2
LinkedMagicRecordList:		; Memory Address ($173F6) and binary offset [$17072]
	; Four-byte linked-magic records containing map offset and lifetime or kind
	; state.
	ds.b	$102
MapCellImpactList:		; Memory Address ($174F8) and binary offset [$17174]
	; Spell and attack impact records allocated per map cell, aged by the engine,
	; and rendered in phases 2, 1, and 0.
	ds.b	$80
MonsterTotalsCounts_mod0:		; Memory Address ($17578) and binary offset [$171F4]
	; Six DBRA terminal indices for packed monster records; $FFFF means no records.
	INCBIN "/data/BLOODWYCH439-clean/maps/mod0.monstercount"
MonsterTotalsCounts_serp:		; Memory Address ($1757A) and binary offset [$171F6]
	INCBIN "/data/BLOODWYCH439-clean/maps/serp.monstercount"
MonsterTotalsCounts_moon:		; Memory Address ($1757C) and binary offset [$171F8]
	INCBIN "/data/BLOODWYCH439-clean/maps/moon.monstercount"
MonsterTotalsCounts_drag:		; Memory Address ($1757E) and binary offset [$171FA]
	INCBIN "/data/BLOODWYCH439-clean/maps/drag.monstercount"
MonsterTotalsCounts_chaos:		; Memory Address ($17580) and binary offset [$171FC]
	INCBIN "/data/BLOODWYCH439-clean/maps/chaos.monstercount"
MonsterTotalsCounts_zendik:		; Memory Address ($17582) and binary offset [$171FE]
	INCBIN "/data/BLOODWYCH439-clean/maps/zendik.monstercount"
MonsterBlock_mod0:		; Memory Address ($17584) and binary offset [$17200]
	; The Keep’s 128-slot packed monster block.
	INCBIN "/data/BLOODWYCH439-clean/maps/mod0.monsters"
MonsteBlock_serp:		; Memory Address ($17884) and binary offset [$17500]
	INCBIN "/data/BLOODWYCH439-clean/maps/serp.monsters"
MonsterBlock_moon:		; Memory Address ($17B84) and binary offset [$17800]
	INCBIN "/data/BLOODWYCH439-clean/maps/moon.monsters"
MonsterBlock_drag:		; Memory Address ($17E84) and binary offset [$17B00]
	INCBIN "/data/BLOODWYCH439-clean/maps/drag.monsters"
MonsterBlock_chaos:		; Memory Address ($18184) and binary offset [$17E00]
	INCBIN "/data/BLOODWYCH439-clean/maps/chaos.monsters"
MonsterBlock_zendik:		; Memory Address ($18484) and binary offset [$18100]
	INCBIN "/data/BLOODWYCH439-clean/maps/zendik.monsters"
SpellBookRunes:
	dc.b	'mar'
	dc.b	'yhadalittlelaaneeitwerraguddutnerewanzednowtecozzitwerawuddunwhyamistillhavintotypethiscrapwhithoughtidfinishacoupleoflinesq'	;79686164616C6974746C656C61616E6565697477657272616775646475746E65726577616E7A65646E6F777465636F7A7A6974776572617775646
*56E776879616D697374696C6C686176696E746F74797065746869736372617077686974686F75676874696466696E69736861636F75706C656F666C696E657371
	dc.b	'x'
Character_RenderLayout_Standard:		; Memory Address ($18804) and binary offset [$18480]
	INCBIN "/data/BLOODWYCH439-clean/data/characters-standard-render.layout"
Character_Distant4_Positions_Standard:		; Memory Address ($18934) and binary offset [$185B0]
	; Four signed XY pairs for the corresponding distant graphics slot.
	INCBIN "/data/BLOODWYCH439-clean/data/characters-standard-distant-4.positions"
Character_Distant5_Positions_Standard:		; Memory Address ($1893C) and binary offset [$185B8]
	; Four signed XY pairs for the corresponding distant graphics slot.
	INCBIN "/data/BLOODWYCH439-clean/data/characters-standard-distant-5.positions"
Character_RenderLayout_Alternate:		; Memory Address ($18944) and binary offset [$185C0]
	INCBIN "/data/BLOODWYCH439-clean/data/characters-alternate-render.layout"
Character_Distant4_Positions_Alternate:		; Memory Address ($18A74) and binary offset [$186F0]
	; Four signed XY pairs for the corresponding distant graphics slot.
	INCBIN "/data/BLOODWYCH439-clean/data/characters-alternate-distant-4.positions"
Character_Distant5_Positions_Alternate:		; Memory Address ($18A7C) and binary offset [$186F8]
	; Four signed XY pairs for the corresponding distant graphics slot.
	INCBIN "/data/BLOODWYCH439-clean/data/characters-alternate-distant-5.positions"
Monster_ViewCell_SubPosition_XPositions:		; Memory Address ($18A84) and binary offset [$18700]
	; Provides screen X positions for view-cell and mini-space combinations.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Monster_ViewCell_SubPosition_X.positions"
GFX_Main_Walls_Offsets:		; Memory Address ($18ADE) and binary offset [$1875A]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Main_Walls.offsets"
GFX_Misc_Pillar_Offsets:		; Memory Address ($18B16) and binary offset [$18792]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Misc_Pillar.offsets"
GFX_Misc_Bed_Offsets:		; Memory Address ($18B2C) and binary offset [$187A8]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Misc_Bed.offsets"
GFX_Wooden_Doors_Offsets:		; Memory Address ($18B50) and binary offset [$187CC]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Wooden_Doors.offsets"
GFX_Wooden_Wall_Offsets:		; Memory Address ($18B70) and binary offset [$187EC]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Wooden_Wall.offsets"
GFX_Main_Shelf_Offsets:		; Memory Address ($18B90) and binary offset [$1880C]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Main_Shelf.offsets"
GFX_Main_Sign_Offsets:		; Memory Address ($18BB0) and binary offset [$1882C]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Main_Sign.offsets"
GFX_Stairs_Up_Offsets:		; Memory Address ($18BD0) and binary offset [$1884C]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Stairs_Up.offsets"
GFX_Stairs_Down_Offsets:		; Memory Address ($18BF2) and binary offset [$1886E]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Stairs_Down.offsets"
GFX_Door_Offsets:		; Memory Address ($18C14) and binary offset [$18890]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Door.offsets"
GFX_Main_Switches_Offsets:		; Memory Address ($18C2E) and binary offset [$188AA]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Main_Switches.offsets"
GFX_FloorPit_TriggerPad_Offsets:		; Memory Address ($18C4E) and binary offset [$188CA]
	; Shared picture offsets for floor-pit and trigger-pad artwork.
	INCBIN "/data/BLOODWYCH439-clean/gfx/FloorPit_TriggerPad.offsets"
GFX_Ceiling_Hole_Offsets:		; Memory Address ($18C66) and binary offset [$188E2]
	; Picture offsets for ceiling-hole artwork.
	INCBIN "/data/BLOODWYCH439-clean/gfx/Ceiling_Hole.offsets"
GameFont:		; Memory Address ($18C7E) and binary offset [$188FA]
	; Packed four-plane glyph sheet used by the text renderer, including readable
	; glyphs and rune/symbol positions.
	INCBIN "/data/BLOODWYCH439-clean/gfx/GameFont"
GFX_ButtonHighlights:		; Memory Address ($18EFE) and binary offset [$18B7A]
	INCBIN "/data/BLOODWYCH439-clean/gfx/ButtonHighlights.gfx"
GFX_Scroll_Edge_Top:		; Memory Address ($191BE) and binary offset [$18E3A]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Scroll_Edge_Top.gfx"
GFX_Scroll_Edge_Bottom:		; Memory Address ($1948E) and binary offset [$1910A]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Scroll_Edge_Bottom.gfx"
GFX_Scroll_Edge_Left:		; Memory Address ($1975E) and binary offset [$193DA]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Scroll_Edge_Left.gfx"
GFX_Scroll_Edge_Right:		; Memory Address ($1992E) and binary offset [$195AA]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Scroll_Edge_Right.gfx"
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$5FFF	;5FFF
	dc.w	$5FFF	;5FFF
	dc.w	$5FFF	;5FFF
	dc.w	$1FFF	;1FFF
	dc.w	$6FFF	;6FFF
	dc.w	$6FFF	;6FFF
	dc.w	$6FFF	;6FFF
	dc.w	$0FFF	;0FFF
	dc.w	$57FF	;57FF
	dc.w	$57FF	;57FF
	dc.w	$57FF	;57FF
	dc.w	$27FF	;27FF
	dc.w	$4BFF	;4BFF
	dc.w	$4BFF	;4BFF
	dc.w	$4BFF	;4BFF
	dc.w	$33FF	;33FF
	dc.w	$45FF	;45FF
	dc.w	$55FF	;55FF
	dc.w	$55FF	;55FF
	dc.w	$39FF	;39FF
	dc.w	$42FF	;42FF
	dc.w	$5AFF	;5AFF
	dc.w	$5AFF	;5AFF
	dc.w	$3CFF	;3CFF
	dc.w	$417F	;417F
	dc.w	$5D7F	;5D7F
	dc.w	$5D7F	;5D7F
	dc.w	$3E7F	;3E7F
	dc.w	$40BF	;40BF
	dc.w	$50BF	;50BF
	dc.w	$50BF	;50BF
	dc.w	$3F3F	;3F3F
	dc.w	$407F	;407F
	dc.w	$407F	;407F
	dc.w	$407F	;407F
	dc.w	$3C7F	;3C7F
	dc.w	$41FF	;41FF
	dc.w	$45FF	;45FF
	dc.w	$45FF	;45FF
	dc.w	$2DFF	;2DFF
	dc.w	$50FF	;50FF
	dc.w	$50FF	;50FF
	dc.w	$50FF	;50FF
	dc.w	$16FF	;16FF
	dc.w	$B0FF	;B0FF
	dc.w	$B2FF	;B2FF
	dc.w	$B2FF	;B2FF
	dc.w	$B6FF	;B6FF
	dc.w	$F97F	;F97F
	dc.w	$F97F	;F97F
	dc.w	$F97F	;F97F
	dc.w	$FA7F	;FA7F
	dc.w	$FB7F	;FB7F
	dc.w	$FB7F	;FB7F
	dc.w	$FB7F	;FB7F
	dc.w	$F87F	;F87F
	dc.w	$FCFF	;FCFF
	dc.w	$FCFF	;FCFF
	dc.w	$FCFF	;FCFF
	dc.w	$FCFF	;FCFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$5FFF	;5FFF
	dc.w	$5FFF	;5FFF
	dc.w	$0FFF	;0FFF
	dc.w	$0FFF	;0FFF
	dc.w	$6FFF	;6FFF
	dc.w	$6FFF	;6FFF
	dc.w	$27FF	;27FF
	dc.w	$27FF	;27FF
	dc.w	$57FF	;57FF
	dc.w	$77FF	;77FF
	dc.w	$33FF	;33FF
	dc.w	$33FF	;33FF
	dc.w	$4BFF	;4BFF
	dc.w	$7BFF	;7BFF
	dc.w	$29FF	;29FF
	dc.w	$39FF	;39FF
	dc.w	$55FF	;55FF
	dc.w	$7DFF	;7DFF
	dc.w	$24FF	;24FF
	dc.w	$3CFF	;3CFF
	dc.w	$5AFF	;5AFF
	dc.w	$7EFF	;7EFF
	dc.w	$227F	;227F
	dc.w	$3E7F	;3E7F
	dc.w	$5D7F	;5D7F
	dc.w	$7F7F	;7F7F
	dc.w	$2F3F	;2F3F
	dc.w	$3F3F	;3F3F
	dc.w	$50BF	;50BF
	dc.w	$7FBF	;7FBF
	dc.w	$3C7F	;3C7F
	dc.w	$3C7F	;3C7F
	dc.w	$407F	;407F
	dc.w	$7C7F	;7C7F
	dc.w	$29FF	;29FF
	dc.w	$2DFF	;2DFF
	dc.w	$45FF	;45FF
	dc.w	$6DFF	;6DFF
	dc.w	$16FF	;16FF
	dc.w	$16FF	;16FF
	dc.w	$50FF	;50FF
	dc.w	$56FF	;56FF
	dc.w	$B4FF	;B4FF
	dc.w	$B6FF	;B6FF
	dc.w	$B2FF	;B2FF
	dc.w	$B6FF	;B6FF
	dc.w	$FA7F	;FA7F
	dc.w	$FA7F	;FA7F
	dc.w	$F97F	;F97F
	dc.w	$FB7F	;FB7F
	dc.w	$F87F	;F87F
	dc.w	$F87F	;F87F
	dc.w	$FB7F	;FB7F
	dc.w	$FB7F	;FB7F
	dc.w	$FCFF	;FCFF
	dc.w	$FCFF	;FCFF
	dc.w	$FCFF	;FCFF
	dc.w	$FCFF	;FCFF
GFX_Shield_Clicked:		; Memory Address ($19BFE) and binary offset [$1987A]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Shield_Clicked.gfx"
SpellNames:		; Memory Address ($19E8E) and binary offset [$19B0A]
	dc.b	'ARMOUR  TERROR  VITALISEBEGUILE DEFLECT MAGELOCKCONCEAL WARPOWERMISSILE VANISH  PARALYZEALCHEMY CONFUSE LEVITATEANTIMAGERECH'	;41524D4F55522020544552524F522020564954414C49534542454755494C45204445464C454354204D4147454C4F434B434F4E4345414C2057415
*04F5745524D495353494C452056414E4953482020504152414C595A45414C4348454D5920434F4E46555345204C45564954415445414E54494D41474552454348
	dc.b	'ARGETRUEVIEWRENEW   VIVIFY  DISPELL FIREPATHILLUSIONCOMPASS SPELLTAPDISRUPT FIREBALLWYCHWINDARC BOLTFORMWALLSUMMON  BLAZE   '	;41524745545255455649455752454E4557202020564956494659202044495350454C4C204649524550415448494C4C5553494F4E434F4D5041535
*05350454C4C54415044495352555054204649524542414C4C5759434857494E4441524320424F4C54464F524D57414C4C53554D4D4F4E2020424C415A45202020
	dc.b	'MINDROCK'
SpellDescriptions:		; Memory Address ($19F8F) and binary offset [$19C0B]
	dc.b	$1A	;1A
	dc.b	'WEAR THIS SPELL WITH PRIDE'
	dc.b	$04	;04
	dc.b	'BOO!'
	dc.b	$19	;19
	dc.b	'YOU''LL NEVER FEEL SO GOOD'
	dc.b	$1B	;1B
	dc.b	'COAT THY TONGUE WITH SILVER'
	dc.b	$21	;21
	dc.b	'A SPELL A DAY KEEPS AN ARROW AWAY'
	dc.b	$25	;25
	dc.b	'WHY BOTHER WITH ALL THOSE SILLY KEYS?'
	dc.b	$24	;24
	dc.b	'WHAT CANNOT BE SEEN CANNOT BE STOLEN'
	dc.b	$24	;24
	dc.b	'YOU TOO CAN HAVE THE STRENGTH OF TEN'
	dc.b	$1A	;1A
	dc.b	'ONE IN THE EYE FOR ARCHERS'
	dc.b	$1E	;1E
	dc.b	'NOW YOU SEE ME...NOW YOU DON''T'
	dc.b	$25	;25
	dc.b	'A FROZEN LIFE MAY WELL BE A SHORT ONE'
	dc.b	$11	;11
	dc.b	'THE HAND OF MIDAS'
	dc.b	$1D	;1D
	dc.b	'THEY WON''T KNOW WHAT HIT THEM'
	dc.b	$17	;17
	dc.b	'A GENUINELY LIGHT SPELL'
	dc.b	$22	;22
	dc.b	'NEVERMORE WORRY ABOUT SPELLCASTERS'
	dc.b	$1C	;1C
	dc.b	'BOOSTS THE FLATTEST OF RINGS'
	dc.b	$21	;21
	dc.b	'NEVER AGAIN LOSE AT HIDE AND SEEK'
	dc.b	$1D	;1D
	dc.b	'CURES EVERYTHING EXCEPT CRAMP'
	dc.b	$25	;25
	dc.b	'MAKES DEATH BUT A MINOR INCONVENIENCE'
	dc.b	$23	;23
	dc.b	'WHAT MAGIC MAKES, MAGIC CAN DESTROY'
	dc.b	$17	;17
	dc.b	'LAY DOWN THE RED CARPET'
	dc.b	$14	;14
	dc.b	'REAL ENOUGH TO HURT!'
	dc.b	$14	;14
	dc.b	'NEVER GET LOST AGAIN'
	dc.b	$1B	;1B
	dc.b	'THE BANE OF ALL MAGIC USERS'
	dc.b	$1C	;1C
	dc.b	'KNOWN TO SOME AS DEATHSTRIKE'
	dc.b	$12	;12
	dc.b	'A BLAST AT PARTIES'
	dc.b	$13	;13
	dc.b	'JUST BLOW THEM AWAY'
	dc.b	$1A	;1A
	dc.b	'AN ELECTRIFYING EXPERIENCE'
	dc.b	$18	;18
	dc.b	'FOR THOSE WHO LOVE WALLS'
	dc.b	$17	;17
	dc.b	'YOU''LL NEVER WALK ALONE'
	dc.b	$20	;20
	dc.b	'NONE SHALL PASS THIS FIERY BLAST'
	dc.b	$23	;23
	dc.b	'FOR THOSE WHO THINK THEY LOVE WALLS',0
Scroll_Offsets:		; Memory Address ($1A31C) and binary offset [$19F98]
	INCBIN "/data/BLOODWYCH439-clean/data/scrolls.offsets"
Scroll_Texts:		; Memory Address ($1A3AE) and binary offset [$1A02A]
	INCBIN "/data/BLOODWYCH439-clean/data/scrolls.text"
GFX_MainWalls:		; Memory Address ($1B050) and binary offset [$1ACCC]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Main_Walls.gfx"
GFX_WoodenWalls:		; Memory Address ($1F980) and binary offset [$1F5FC]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Wooden_Wall.gfx"
GFX_WoodDoors:		; Memory Address ($242B0) and binary offset [$23F2C]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Wooden_Doors.gfx"
GFX_Shelf:		; Memory Address ($25490) and binary offset [$2510C]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Main_Shelf.gfx"
GFX_Sign:		; Memory Address ($25CD8) and binary offset [$25954]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Main_Sign.gfx"
GFX_SignOverlay:		; Memory Address ($26CA8) and binary offset [$26924]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Main_SignOverlay.gfx"
GFX_Switches:		; Memory Address ($284E8) and binary offset [$28164]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Main_Switches.gfx"
GFX_Slots:		; Memory Address ($287A0) and binary offset [$2841C]
	; Raw socket pixels
	INCBIN "/data/BLOODWYCH439-clean/gfx/Main_Slots.gfx"
GFX_Bed:		; Memory Address ($28C28) and binary offset [$288A4]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Misc_Bed.gfx"
GFX_Pillar:		; Memory Address ($296A0) and binary offset [$2931C]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Misc_Pillar.gfx"
GFX_Stairs_Up:		; Memory Address ($2AB38) and binary offset [$2A7B4]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Stairs_Up.gfx"
GFX_Stairs_Down:		; Memory Address ($2C9E0) and binary offset [$2C65C]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Stairs_Down.gfx"
GFX_Door_Open:		; Memory Address ($2D660) and binary offset [$2D2DC]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Door_Open.gfx"
GFX_Door_Metal:		; Memory Address ($2F1C8) and binary offset [$2EE44]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Door_Metal.gfx"
GFX_Door_PortCullis:		; Memory Address ($30650) and binary offset [$302CC]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Door_PortCullis.gfx"
GFX_Floor_Pit:		; Memory Address ($31AD8) and binary offset [$31754]
	; Floor-pit artwork used for type-6 floor holes.
	INCBIN "/data/BLOODWYCH439-clean/gfx/Floor_Pit.gfx"
GFX_Trigger_Pad:		; Memory Address ($31D20) and binary offset [$3199C]
	; Recolourable trigger-pad template, also reused by Firepath.
	INCBIN "/data/BLOODWYCH439-clean/gfx/Trigger_Pad.gfx"
GFX_Ceiling_Hole:		; Memory Address ($31F68) and binary offset [$31BE4]
	; Ceiling-hole artwork; may coexist with a floor pit or trigger pad.
	INCBIN "/data/BLOODWYCH439-clean/gfx/Ceiling_Hole.gfx"
GFX_FloorCeiling:		; Memory Address ($32120) and binary offset [$31D9C]
	; 128x76 floor-and-ceiling source copied into the dungeon viewport by the
	; parity-dependent renderer.
	INCBIN "/data/BLOODWYCH439-clean/gfx/FloorCeiling.gfx"
GFX_ObjectsOnFloor:		; Memory Address ($32F60) and binary offset [$32BDC]
	; Packed planar floor-object graphics selected by the object shape, colour, and
	; projection tables.
	INCBIN "/data/BLOODWYCH439-clean/gfx/ObjectsOnFloor.gfx"
GFX_FireBall:		; Memory Address ($34778) and binary offset [$343F4]
	; Packed planar fireball pictures used for airborne spell codes $80-$85.
	INCBIN "/data/BLOODWYCH439-clean/gfx/AirbourneFireball.gfx"
GFX_AirbourneSpells:		; Memory Address ($34A30) and binary offset [$346AC]
	; Packed planar airborne-spell pictures; the renderer uses separate stationary
	; and flying layout tables.
	INCBIN "/data/BLOODWYCH439-clean/gfx/AirbourneSpells.gfx"
CharacterColours:		; Memory Address ($351C8) and binary offset [$34E44]
	INCBIN "/data/BLOODWYCH439-clean/data/characters.colours"
GFX_HeadParts:		; Memory Address ($35880) and binary offset [$354FC]
	INCBIN "/data/BLOODWYCH439-clean/gfx/HeadParts.gfx"
GFX_BodyParts:		; Memory Address ($396F0) and binary offset [$3936C]
	INCBIN "/data/BLOODWYCH439-clean/gfx/BodyParts.gfx"
GFX_Avatars_Large:		; Memory Address ($41D30) and binary offset [$419AC]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Avatars_Large.gfx"
GFX_Avatars_Small:		; Memory Address ($43B30) and binary offset [$437AC]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Shield_Avatars.gfx"
GFX_Shield_Top:		; Memory Address ($44B30) and binary offset [$447AC]
	INCBIN "/data/BLOODWYCH439-clean/gfx/ShieldTop.gfx"
GFX_Shield_Bottom:		; Memory Address ($44B80) and binary offset [$447FC]
	INCBIN "/data/BLOODWYCH439-clean/gfx/ShieldBottom.gfx"
GFX_Shield_Classes:		; Memory Address ($44C10) and binary offset [$4488C]
	INCBIN "/data/BLOODWYCH439-clean/gfx/ShieldClasses.gfx"
GFX_Fairy:		; Memory Address ($44ED0) and binary offset [$44B4C]
	INCBIN "/data/BLOODWYCH439-clean/gfx/Fairy.gfx"
GFX_Summon:		; Memory Address ($45018) and binary offset [$44C94]
	; Packed Summon body and arm pictures shared by the distance, facing, and
	; arm-variant tables.
	INCBIN "/data/BLOODWYCH439-clean/monsters/Summon.gfx"
GFX_Behemoth:		; Memory Address ($466D0) and binary offset [$4634C]
	; Packed Behemoth body and claw pictures selected by the Behemoth and Entropy
	; render layouts.
	INCBIN "/data/BLOODWYCH439-clean/monsters/Behemoth.gfx"
GFX_Crab:		; Memory Address ($47AB8) and binary offset [$47734]
	; Packed Crab body and face pictures selected by the Crab render layouts.
	INCBIN "/data/BLOODWYCH439-clean/monsters/Crab.gfx"
GFX_CrabClaw:		; Memory Address ($47F10) and binary offset [$47B8C]
	INCBIN "/data/BLOODWYCH439-clean/monsters/CrabClaw.gfx"
GFX_Beholder_Body:		; Memory Address ($48260) and binary offset [$47EDC]
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_Body.gfx"
GFX_Beholder_UpperEyes:		; Memory Address ($48500) and binary offset [$4817C]
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_UpperEyes.gfx"
GFX_Beholder_CentralEye_Near:		; Memory Address ($485A0) and binary offset [$4821C]
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_CentralEye_Near.gfx"
GFX_Beholder_CentralEye_Far:		; Memory Address ($48900) and binary offset [$4857C]
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_CentralEye_Far.gfx"
GFX_Dragon:		; Memory Address ($48960) and binary offset [$485DC]
	; Packed Dragon body and claw pictures selected by the Dragon render layouts.
	INCBIN "/data/BLOODWYCH439-clean/monsters/Dragon.gfx"

GFX_Entropy:		; Memory Address ($4B290) and binary offset [$4AF0C]
	; Packed Entropy body and limb pictures selected by the shared Behemoth/Entropy
	; renderer.
	INCBIN "/data/BLOODWYCH439-clean/monsters/Entropy.gfx"
GFX_Pockets:		; Memory Address ($4C702) and binary offset [$4C37E]
	; Packed pocket/object picture bank addressed in 20-picture banks by the object
	; graphic selector.
	INCBIN "/data/BLOODWYCH439-clean/gfx/Pockets.gfx"
SFX_AudioSample_1:		; Memory Address ($54422) and binary offset [$5409E]
	; First packed 8SVX sound sample. Contains the switch/click sound data and the
	; second sound selected by ID 1.
	INCBIN "/data/BLOODWYCH439-clean/sfx/sample1.sound"
SFX_AudioSample_2:		; Memory Address ($544A6) and binary offset [$54122]
	; 8SVX fighting or attack-clink sound data selected by sound ID 2.
	INCBIN "/data/BLOODWYCH439-clean/sfx/sample2.sound"
SFX_AudioSample_3:		; Memory Address ($54A68) and binary offset [$546E4]
	; 8SVX character-death sound data selected by sound ID 3.
	INCBIN "/data/BLOODWYCH439-clean/sfx/sample3.sound"
SFX_AudioSample_4:		; Memory Address ($562F0) and binary offset [$55F6C]
	; 8SVX spell or fireball sound data selected by sound ID 4.
	INCBIN "/data/BLOODWYCH439-clean/sfx/sample4.sound"
SFX_AudioSample_5:		; Memory Address ($57AA6) and binary offset [$57722]
	; 8SVX alternative spell sound data selected by sound ID 5.
	INCBIN "/data/BLOODWYCH439-clean/sfx/sample5.sound"
ReserveSpace_1:		; Memory Address ($58C10) and binary offset [$5888C]
	ds.b	$3E8
ReserveSpace_2:		; Memory Address ($58828) and binary offset [$584A4]
	ds.b	$7D4
GameEnd:

	end		
