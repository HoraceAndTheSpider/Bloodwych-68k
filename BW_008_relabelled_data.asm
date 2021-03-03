
dsksync:		equ	$0000007E
copjmp1:		equ	$00000088
aud:			equ	$000000A0
ac_vol:			equ	$00000008
adkcon:			equ	$0000009E
_custom:		equ	$00DFF000
ddfstop:		equ	$00000094
bplcon2:		equ	$00000104
diwstrt:		equ	$0000008E
ac_per:			equ	$00000006
intreq:			equ	$0000009C
bplcon0:		equ	$00000100
bplcon1:		equ	$00000102
aud0:			equ	$000000A0
diwstop:		equ	$00000090
cli_SIZEOF:		equ	$00000040
ddfstrt:		equ	$00000092
SYSBASESIZE:		equ	$00000278
tv_TrapInstrVects:	equ	$00000080
ciaprb:			equ	$00000100
intena:			equ	$0000009A
intreqr:		equ	$0000001E
joy0dat:		equ	$0000000A
ac_dat:			equ	$0000000A
joy1dat:		equ	$0000000C
bpl2mod:		equ	$0000010A
color:			equ	$00000180
bltddat:		equ	$00000000
bpl1mod:		equ	$00000108
ciaicr:			equ	$00000D00
dskpt:			equ	$00000020
cop1lc:			equ	$00000080
_ciaa:			equ	$00BFE001
_ciab:			equ	$00BFD000
dmacon:			equ	$00000096
wd_SIZEOF:		equ	$00000088
dsklen:			equ	$00000024
ac_len:			equ	$00000004
ciacra:			equ	$00000E00
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
	ORG	$03A4
;  
	move.w	#$7FFF,_custom+intena.l	;33FC7FFF00DFF09A
	move.w	#$7FFF,_custom+intreq.l	;33FC7FFF00DFF09C
;  
; Copies 40 bytes of code starting at CodeMover to $00000090
;  
	lea	CodeMover(pc),a0	;41FA0020
	lea	$00000090.l,a1	;43F900000090
	moveq	#$28,d0	;7028
.loop:
	move.b	(a0)+,(a1)+	;12D8
	dbra	d0,.loop	;51C8FFFC
;  
; Cache the game code start address in A6
;  
	lea	GameStart(pc),a6	;4DFA0038
;  
; Put the address of the moved code into the trap vector
;  
	move.l	#$00000090,tv_TrapInstrVects.l	;23FC0000009000000080
;  
; Trigger the trap...
;  
	trap	#$00	;4E40
;  
; This gets executed for trap #$00.
; On entry, A6 holds the address of GameStart when the code was loaded.
; Now gets relocated to $0400.
;  
CodeMover:
	move.l	#$0005909C,d0	;203C0005909C
	move.w	#$7FFF,_custom+intreq.l	;33FC7FFF00DFF09C
	lea	GameStart.l,a0	;41F900000400
.loop:
	move.b	(a6)+,(a0)+	;10DE
	subq.l	#$01,d0	;5380
	bcc.s	.loop	;64FA
	move.w	#$7FFF,_custom+intreq.l	;33FC7FFF00DFF09C
;  
; The code is now in its proper place.
; So just jump on in.  All labels will now reslve to their
; correct absolute addresses.
;  
	jmp	GameStart.l	;4EF900000400

;fiX Label expected
	dc.w	$0000	;0000

GameStart:
	move.w	#$7FFF,_custom+intena.l	;33FC7FFF00DFF09A
	move.w	#$7FFF,_custom+intreq.l	;33FC7FFF00DFF09C
	lea	$0005FFFC.l,sp	;4FF90005FFFC
	clr.b	adrB_008C1F.l	;423900008C1F
	bsr	adrCd000492	;61000074
	clr.b	adrB_00EE2D.l	;42390000EE2D
	clr.w	adrB_008C1E.l	;427900008C1E
	bsr	adrCd0008C4	;61000496
	bsr	MainMenu	;61000314
	jsr	adrCd008DA8.l	;4EB900008DA8
	jsr	adrCd008DA0.l	;4EB900008DA0
	moveq	#$00,d0	;7000
	jsr	PlaySound.l	;4EB9000088BE
	tst.w	MainMenuBuffer.l	;4A7900000656
	bmi.s	adrCd00048E	;6B3E
	beq.s	adrCd000456	;6704
	bra	adrCd000BA6	;60000752

adrCd000456:
	jsr	ChampionSelection_Main.l	;4EB90000C0FA
	move.b	adrB_00EE83.l,adrL_00EE94.l	;13F90000EE830000EE94
	move.b	adrB_00EEE5.l,adrL_00EEF6.l	;13F90000EEE50000EEF6
	move.l	adrL_00EE94.l,adrL_00EEA2.l	;23F90000EE940000EEA2
	move.l	adrL_00EEF6.l,adrL_00EF04.l	;23F90000EEF60000EF04
	moveq	#$0F,d0	;700F
DBFWait1a:
	dbra	d1,DBFWait1a	;51C9FFFE
	dbra	d0,DBFWait1a	;51C8FFFA
adrCd00048E:
	bra	adrCd000BA2	;60000712

adrCd000492:
	jsr	adrCd008DBA.l	;4EB900008DBA
	move.w	#$4200,_custom+bplcon0.l	;33FC420000DFF100
	move.w	#$0000,_custom+bplcon1.l	;33FC000000DFF102
	move.w	#$0024,_custom+bplcon2.l	;33FC002400DFF104
	move.w	#$0000,_custom+bpl1mod.l	;33FC000000DFF108
	move.w	#$0000,_custom+bpl2mod.l	;33FC000000DFF10A
	move.w	#$0038,_custom+ddfstrt.l	;33FC003800DFF092
	move.w	#$00D0,_custom+ddfstop.l	;33FC00D000DFF094
	move.w	#$3781,_custom+diwstrt.l	;33FC378100DFF08E
	move.w	#$FFC1,_custom+diwstop.l	;33FCFFC100DFF090
	move.l	#CopperList_00,_custom+cop1lc.l	;23FC00008E1000DFF080
	move.l	#$00060000,screen_ptr.l	;23FC0006000000008D36
	jsr	adrCd008D00.l	;4EB900008D00
	lea	CopperList_01.l,a0	;41F900008E30
	lea	adrEA0005AA.l,a1	;43F9000005AA
	lea	adrEA0005B2.l,a2	;45F9000005B2
	moveq	#$07,d1	;7207
adrLp00050E:
	moveq	#$00,d0	;7000
	move.b	$00(a1,d1.w),d0	;10311000
	add.w	d0,d0	;D040
	add.w	d0,d0	;D040
	move.l	$00(a2,d0.w),d0	;20320000
	move.w	d0,$0006(a0)	;31400006
	swap	d0	;4840
	move.w	d0,$0002(a0)	;31400002
	addq.w	#$08,a0	;5048
	dbra	d1,adrLp00050E	;51C9FFE4
	move.l	#adrL_008CC8,d0	;203C00008CC8
	lea	$0060.w,a0	;41F80060	;Short Absolute replaced by symbol!
	moveq	#$07,d1	;7207
adrLp000538:
	move.l	d0,(a0)+	;20C0
	dbra	d1,adrLp000538	;51C9FFFC
	move.l	#VerticalBlankInterupt,$006C.w	;21FC00008C20006C	;Short Absolute converted to symbol!
	move.l	#Level_2_Interrupt,$0068.w	;21FC000005CE0068	;Short Absolute converted to symbol!
	move.l	#adrL_0088A4,$0070.w	;21FC000088A40070	;Short Absolute converted to symbol!
	move.w	#$7FFF,_custom+intena.l	;33FC7FFF00DFF09A
	move.b	_ciaa+ciacra.l,d0	;103900BFEE01
	move.b	#$21,_ciaa+ciacra.l	;13FC002100BFEE01
	move.b	#$7F,_ciaa+ciaicr.l	;13FC007F00BFED01
	move.b	_ciaa+ciaicr.l,d0	;103900BFED01
	move.b	#$88,_ciaa+ciaicr.l	;13FC008800BFED01
	move.w	_custom+copjmp1.l,d0	;303900DFF088
	move.w	#$7FFF,_custom+dmacon.l	;33FC7FFF00DFF096
	move.w	#$83A0,_custom+dmacon.l	;33FC83A000DFF096
	move.w	#$7FFF,_custom+intreq.l	;33FC7FFF00DFF09C
	move.w	#$C038,_custom+intena.l	;33FCC03800DFF09A
	rts	;4E75

adrEA0005AA:
	dc.w	$0404	;0404
	dc.w	$0403	;0403
	dc.w	$0402	;0402
	dc.w	$0100	;0100
adrEA0005B2:
	dc.l	SpritePosition_00	;00008E84
	dc.l	SpritePosition_01	;00008F14
	dc.l	SpritePosition_04	;00008ECC
	dc.l	SpritePosition_02	;00008F5C
	dc.l	adrEA008EC8	;00008EC8
	dc.w	$0000	;0000
adrEA0005C8:
	dc.b	$00	;00
KeyboardKeyCode:
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00

Level_2_Interrupt:
	movem.l	d0/d1/a0,-(sp)	;48E7C080
	lea	_ciaa.l,a0	;41F900BFE001
	move.b	$0C00(a0),d0	;10280C00
	ror.b	#$01,d0	;E218
	not.b	d0	;4600
	move.b	d0,KeyboardKeyCode.w	;11C005C9	;Short Absolute converted to symbol!
	or.b	#$40,$0E00(a0)	;002800400E00
	clr.b	$0C00(a0)	;42280C00
	move.b	$0100(a0),d1	;12280100
	bsr.s	CheckKeyboard	;6128
	moveq	#$2D,d0	;702D
.L2InteruptLoop:
	dbra	d0,.L2InteruptLoop	;51C8FFFE
	lea	_ciaa.l,a0	;41F900BFE001
	move.b	$0D00(a0),d0	;10280D00
	and.b	#$BF,$0E00(a0)	;022800BF0E00
	move.b	d0,adrEA0005C8.w	;11C005C8	;Short Absolute converted to symbol!
	movem.l	(sp)+,d0/d1/a0	;4CDF0103
	move.w	#$0008,_custom+intreq.l	;33FC000800DFF09C
	rte	;4E73

CheckKeyboard:
	lea	RawKeyCodes.l,a0	;41F90000064A
	moveq	#$0B,d1	;720B
.keyboardloop:
	cmp.b	(a0)+,d0	;B018
	beq.s	KeyboardAction	;6706
	dbra	d1,.keyboardloop	;51C9FFFA
	rts	;4E75

KeyboardAction:
	lea	Player1_Data.l,a0	;41F90000EE7C
	subq.w	#$06,d1	;5D41
	bcc.s	.skipPlayer2	;6408
	addq.w	#$06,d1	;5C41
	lea	Player2_Data.l,a0	;41F90000EEDE
.skipPlayer2:
	add.w	#$000A,d1	;0641000A
	move.b	d1,$0056(a0)	;11410056
	rts	;4E75

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
	dc.b	$00	;00
	dc.b	$00	;00
MainMenuInitColours:
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$FD	;FD
	dc.b	$00	;00
	dc.b	$F0	;F0
MainMenuText:
	dc.b	$FE	;FE
	dc.b	$0C	;0C
	dc.b	$FC	;FC
	dc.b	$0F	;0F
	dc.b	$02	;02
	dc.b	'BLOODWYCH'	;424C4F4F4457594348
	dc.b	$FE	;FE
	dc.b	$06	;06
	dc.b	$FC	;FC
	dc.b	$04	;04
	dc.b	$06	;06
	dc.b	'F1   START ONE PLAYER GAME'	;46312020205354415254204F4E4520504C415945522047414D45
	dc.b	$FC	;FC
	dc.b	$04	;04
	dc.b	$08	;08
	dc.b	'F2   START TWO PLAYER GAME'	;463220202053544152542054574F20504C415945522047414D45
	dc.b	$FC	;FC
	dc.b	$04	;04
	dc.b	$0B	;0B
	dc.b	'F3   QUICKSTART ONE PLAYER GAME'	;4633202020515549434B5354415254204F4E4520504C415945522047414D45
	dc.b	$FC	;FC
	dc.b	$04	;04
	dc.b	$0D	;0D
	dc.b	'F4   QUICKSTART TWO PLAYER GAME'	;4634202020515549434B53544152542054574F20504C415945522047414D45
	dc.b	$FC	;FC
	dc.b	$04	;04
	dc.b	$10	;10
	dc.b	'F9   LOAD ONE PLAYER POSITION'	;46392020204C4F4144204F4E4520504C4159455220504F534954494F4E
	dc.b	$FC	;FC
	dc.b	$04	;04
	dc.b	$12	;12
	dc.b	'F10  LOAD TWO PLAYER POSITION'	;46313020204C4F41442054574F20504C4159455220504F534954494F4E
	dc.b	$FE	;FE
	dc.b	$03	;03
	dc.b	$FC	;FC
	dc.b	$0A	;0A
	dc.b	$18	;18
	dc.b	'(C) MIRRORSOFT 1989'	;284329204D4952524F52534F46542031393839

	; USED TO CHECK IF GAME IS RELOCATABLE
	dc.b	'TEST'	

	dc.b	$FE	;FE
	dc.b	$06	;06
	dc.b	$FF	;FF

	EVEN
MainMenu:
	clr.w	MainMenuBuffer.w	;42780656	;Short Absolute converted to symbol!
	clr.w	MultiPlayer.l	;42790000EE30
	jsr	adrCd008DA8.l	;4EB900008DA8
	jsr	adrCd008DA0.l	;4EB900008DA0
	lea	MainMenuText.w,a6	;4DF8065D	;Short Absolute converted to symbol!
	tst.w	MainMenuInitColours.w	;4A780658	;Short Absolute converted to symbol!
	bne.s	.menuscreen	;6602
	subq.w	#$03,a6	;574E
.menuscreen:
	lea	Player1_Data.l,a5	;4BF90000EE7C
	jsr	Print_fflim_text.l	;4EB90000D0C6
	jsr	adrCd008CCA.l	;4EB900008CCA
	tst.w	MainMenuInitColours.w	;4A780658	;Short Absolute converted to symbol!
	bne.s	MenuKeyboard	;660C
	move.w	#$FFFF,MainMenuInitColours.w	;31FCFFFF0658	;Short Absolute converted to symbol!
	jsr	adrCd008878.l	;4EB900008878
MenuKeyboard:
	clr.b	KeyboardKeyCode.w	;423805C9	;Short Absolute converted to symbol!
MenuKeyboardLoop:
	move.b	KeyboardKeyCode.w,d0	;103805C9	;Short Absolute converted to symbol!
	sub.b	#$50,d0					;04000050
	beq	Ply1_Start				;67000088
	subq.b	#$01,d0					;5300
	beq	Ply2_Start				;6700008C
	subq.b	#$01,d0					;5300
	beq	QkPly1_Start				;6700008E
	subq.b	#$01,d0					;5300
	beq	QkPly2_Start				;670000CE
	cmpi.b	#$06,d0					;0C000006
	beq.s	LoadGameFromMenu			;670C
	subq.b	#$05,d0					;5B00
	bne.s	MenuKeyboardLoop			;66D8
	move.w	#$FFFF,MultiPlayer.l			;33FCFFFF0000EE30
LoadGameFromMenu:
	move.l	#$00067D00,screen_ptr.l			;23FC00067D0000008D36
	move.l	#$00060000,framebuffer_ptr.l		;23FC0006000000008D3A
	jsr	adrCd008DA8.l				;4EB900008DA8
	move.l	screen_ptr.l,a0				;207900008D36
	add.w	#$0E10,a0				;D0FC0E10
	lea	InsertLoadDiskMsg.l,a6	;		4DF9000044E5
	jsr	Print_fflim_text.l				;4EB90000D0C6
	jsr	adrCd008CCA.l	;4EB900008CCA
	clr.b	KeyboardKeyCode.w	;423805C9	;Short Absolute converted to symbol!
	bsr	LoadSaveGame_Loop	;61003C0A
	bcs	MainMenu	;6500FF46
	bsr	LoadSaveGame_Action	;61003C1E
	bsr	adrCd004440	;61003C38
	cmp.b	#$FF,CharacterStats+$11.l	;0C3900FF0000EB3B
	beq	MainMenu	;6700FF32
	bsr	adrCd000B68	;61000350
	move.w	#$0001,MainMenuBuffer.w	;31FC00010656	;Short Absolute converted to symbol!
	rts	;4E75

Ply1_Start:
	move.w	#$FFFF,MultiPlayer.l	;33FCFFFF0000EE30
	rts	;4E75

Ply2_Start:
	clr.w	MultiPlayer.l	;42790000EE30
	rts	;4E75

QkPly1_Start:
	move.w	#$FFFF,MultiPlayer.l	;33FCFFFF0000EE30
	move.w	#$FFFF,MainMenuBuffer.w	;31FCFFFF0656	;Short Absolute converted to symbol!
	move.l	#$000E0503,$0018(a5)	;2B7C000E05030018
	move.l	$0018(a5),$0026(a5)	;2B6D00180026
	clr.w	$0006(a5)	;426D0006
	lea	CharacterStats.l,a0	;41F90000EB2A
	move.b	#$0C,$0016(a0)	;117C000C0016
	move.b	#$17,$0017(a0)	;117C00170017
	clr.b	$0018(a0)	;42280018
	moveq	#-$01,d0	;70FF
	move.b	d0,$01D6(a0)	;114001D6
	move.b	d0,$00B6(a0)	;114000B6
	move.b	d0,$0076(a0)	;11400076
	rts	;4E75

QkPly2_Start:
	bsr.s	QkPly1_Start	;61B8
	clr.w	MultiPlayer.l	;42790000EE30
	move.l	#$04060D0F,adrL_00EEF6.l	;23FC04060D0F0000EEF6
	move.l	#$04060D0F,adrL_00EF04.l	;23FC04060D0F0000EF04
	move.w	#$0004,adrW_00EEE4.l	;33FC00040000EEE4
	lea	adrEA00EBAA.l,a0	;41F90000EBAA
	move.b	#$0E,$0016(a0)	;117C000E0016
	move.b	#$17,$0017(a0)	;117C00170017
	clr.b	$0018(a0)	;42280018
	moveq	#-$01,d0	;70FF
	move.b	d0,$0056(a0)	;11400056
	move.b	d0,$0136(a0)	;11400136
	move.b	d0,$0176(a0)	;11400176
	rts	;4E75

adrCd0008C4:
	lea	adrEA01684C.l,a0	;41F90001684C
	move.w	#$00FF,d7	;3E3C00FF
adrLp0008CE:
	move.w	d7,d0	;3007
	moveq	#$07,d6	;7C07
adrLp0008D2:
	lsr.b	#$01,d0	;E208
	addx.b	d1,d1	;D301
	dbra	d6,adrLp0008D2	;51CEFFFA
	move.b	d1,$00(a0,d7.w)	;11817000
	dbra	d7,adrLp0008CE	;51CFFFEE
	lea	adrEA01694C.l,a0	;41F90001694C
	moveq	#$7F,d0	;707F
adrLp0008EA:
	clr.l	(a0)+	;4298
	dbra	d0,adrLp0008EA	;51C8FFFC
	rts	;4E75

adrEA0008F2:
	moveq	#$0F,d7	;7E0F
adrLp0008F4:
	move.w	d7,d0	;3007
	bsr	adrCd000904	;6100000C
	move.b	d0,$0009(a4)	;19400009
	dbra	d7,adrLp0008F4	;51CFFFF4
	rts	;4E75

adrCd000904:
	move.w	d0,d1	;3200
	bsr	adrCd006660	;61005D58
	bsr.s	adrCd00093E	;6132
	asl.w	#$02,d0	;E540
	move.b	$0003(a4),d1	;122C0003
	lsr.b	#$01,d1	;E209
	add.b	d1,d0	;D001
	cmpi.b	#$64,d0	;0C000064
	bcs.s	adrCd00091E	;6502
	moveq	#$63,d0	;7063
adrCd00091E:
	move.b	d0,$000A(a4)	;1940000A
	rts	;4E75

adrCd000924:
	and.w	#$0003,d1	;02410003
	move.b	adrB_00093A(pc,d1.w),d1	;123B1010
	bpl.s	adrCd000954	;6A26
	moveq	#$00,d0	;7000
	move.b	(a4),d0	;1014
	add.w	d0,d0	;D040
	add.b	(a4),d0	;D014
	lsr.w	#$02,d0	;E448
	rts	;4E75

adrB_00093A:
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$FF	;FF
	dc.b	$02	;02

adrCd00093E:
	and.w	#$0003,d1	;02410003
	move.b	adrB_000948(pc,d1.w),d1	;123B1004
	bra.s	adrCd000954	;600C

adrB_000948:
	dc.b	$02	;02
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02

adrCd00094C:
	and.w	#$0003,d1	;02410003
	move.b	adrB_00095C(pc,d1.w),d1	;123B100A
adrCd000954:
	moveq	#$00,d0	;7000
	move.b	(a4),d0	;1014
	lsr.w	d1,d0	;E268
	rts	;4E75

adrB_00095C:
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$00	;00

adrCd000960:
	moveq	#$00,d7	;7E00
	moveq	#$00,d6	;7C00
	move.l	adrL_00EE78.l,a6	;2C790000EE78
	lea	$0FCA(a6),a0	;41EE0FCA
adrCd00096E:
	cmp.w	-$0002(a0),d7	;BE68FFFE
	bcc.s	adrCd000994	;6420
	move.b	$00(a0,d7.w),d0	;10307000
	rol.w	#$08,d0	;E158
	move.b	$01(a0,d7.w),d0	;10307001
	and.w	#$3FFF,d0	;02403FFF
	bset	#$06,$01(a6,d0.w)	;08F600060001
	move.b	$02(a0,d7.w),d6	;1C307002
	add.w	d6,d6	;DC46
	addq.w	#$05,d6	;5A46
	add.w	d6,d7	;DE46
	bra.s	adrCd00096E	;60DA

adrCd000994:
	rts	;4E75

PrepareCharacters:
	bsr	adrCd000B68	;610001D0
	lea	CharacterStats.l,a4	;49F90000EB2A
	moveq	#$0F,d6	;7C0F
CharacterFillLoop:
	clr.b	$0011(a4)	;422C0011
	move.b	#$FF,$0013(a4)	;197C00FF0013
	clr.b	$001E(a4)	;422C001E
	clr.b	$001B(a4)	;422C001B
	move.b	#$FF,$001D(a4)	;197C00FF001D
	move.w	d6,d0	;3006
	eor.b	#$0F,d0	;0A00000F
	bsr	adrCd004BCE	;6100420C
	move.b	$000A(a4),$0009(a4)	;196C000A0009
	moveq	#$00,d0	;7000
	move.b	$001A(a4),d0	;102C001A
	jsr	adrCd0084DA.l	;4EB9000084DA
	moveq	#$00,d7	;7E00
	move.b	$0016(a4),d7	;1E2C0016
	bmi.s	adrCd0009EE	;6B10
	swap	d7	;4847
	move.b	$0017(a4),d7	;1E2C0017
	bsr	CoordToMap	;61007AB6
	bset	#$07,$01(a6,d0.w)	;08F600070001
adrCd0009EE:
	add.w	#$0020,a4	;D8FC0020
	dbra	d6,CharacterFillLoop	;51CEFFAE
MonsterTransfer:
	bsr	adrCd000960	;6100FF68
	lea	adrEA017390.l,a4	;49F900017390
	moveq	#-$01,d6	;7CFF
	move.w	d6,-$0002(a4)	;3946FFFE
	moveq	#$18,d0	;7018
adrLp000A08:
	move.l	d6,(a4)+	;28C6
	dbra	d0,adrLp000A08	;51C8FFFC
	lea	UnpackedMonsters.l,a4	;49F900016B7E
	move.w	#$01FF,d0	;303C01FF
.ClearMonstersLoop:
	move.l	d6,(a4)+	;28C6
	dbra	d0,.ClearMonstersLoop	;51C8FFFC
	move.w	CurrentTower.l,d0	;30390000EE2E
	move.w	d0,d1	;3200
	add.w	d0,d0	;D040
	lea	MonsterTotalsCounts.l,a4	;49F900017578
	move.w	$00(a4,d0.w),d6	;3C340000
	lea	UnpackedMonsters.l,a4	;49F900016B7E
	move.w	d6,-$0002(a4)	;3946FFFE
	bmi	Trigger_00_t00_Null	;6B0065D8
	add.w	d1,d0	;D041
	asl.w	#$08,d0	;E140
	lea	MonsterData_1.l,a3	;47F900017584
	add.w	d0,a3	;D6C0
	moveq	#$00,d4	;7800
.FillMonstersLoop:
	clr.b	$0005(a4)	;422C0005
	clr.b	$0002(a4)	;422C0002
	move.b	(a3)+,d0	;101B
	subq.b	#$01,d0	;5300
	move.b	d0,d1	;1200
	lsr.b	#$04,d1	;E809
	move.b	d1,$000A(a4)	;1941000A
	and.w	#$000F,d0	;0240000F
	move.b	d0,$0004(a4)	;19400004
	bsr	adrCd0084DA	;61007A6E
	moveq	#$00,d7	;7E00
	move.b	(a3)+,d7	;1E1B
	move.b	d7,$0000(a4)	;19470000
	swap	d7	;4847
	move.b	(a3)+,d7	;1E1B
	move.b	d7,$0001(a4)	;19470001
	btst	#$17,d7	;08070017
	bne.s	.MarkedOnMap	;660A
	bsr	CoordToMap	;61007A16
	bset	#$07,$01(a6,d0.w)	;08F600070001
.MarkedOnMap:
	moveq	#$00,d0	;7000
	move.b	(a3)+,d0			;101B
	move.b	d0,$0006(a4)			;19400006
	move.b	d0,$0007(a4)			;19400007
	moveq	#$0E,d1				;720E
	sub.b	d0,d1				;9200
	bcs.s	.SkipSomething1_TEMP			;6506
	cmpi.b	#$08,d1				;0C010008
	bcc.s	.SkipSomething2_TEMP		;6402
.SkipSomething1_TEMP:
	moveq	#$08,d1	;7208
.SkipSomething2_TEMP:
	asl.b	#$04,d1	;E901
	move.b	d1,$0003(a4)	;19410003
	move.w	#$0190,d1	;323C0190
	cmpi.b	#$19,d0	;0C000019
	bcc.s	.SkipSomething3_TEMP	;640E
	move.w	#$00FA,d1	;323C00FA
	cmpi.b	#$10,d0	;0C000010
	bcc.s	.SkipSomething3_TEMP	;6404
	move.b	adrB_000B22(pc,d0.w),d1	;123B005E
.SkipSomething3_TEMP:
	mulu	d1,d0	;C0C1
	add.w	#$0019,d0	;06400019
	move.w	d0,$0008(a4)	;39400008
	move.b	(a3)+,$000B(a4)	;195B000B
	bpl.s	.SpecialObjects	;6A08
	move.b	#$10,$0003(a4)	;197C00100003
	bra.s	.SkipSomething4_TEMP	;600E

.SpecialObjects:
	cmp.b	#$40,$000B(a4)	;0C2C0040000B	;
	bne.s	.SkipSomething4_TEMP	;6606
	move.b	#$37,$000C(a4)	;197C0037000C
.SkipSomething4_TEMP:
	moveq	#$00,d0	;7000
	move.b	(a3)+,d0	;101B
	cmpi.b	#$FF,d0	;0C0000FF
	beq.s	.SkipSomething5_TEMP	;6720
	lea	adrEA017390.l,a0	;41F900017390
	move.b	d4,$00(a0,d0.w)	;11840000
	move.b	d0,d1	;1200
	and.b	#$03,d1	;02010003
	tst.b	$0000(a4)	;4A2C0000
	bmi.s	.SkipSomething5_TEMP	;6B0A
	addq.w	#$01,-$0002(a0)	;5268FFFE
	lsr.b	#$02,d0	;E408
	move.b	d0,$000D(a4)	;1940000D
.SkipSomething5_TEMP:
	add.w	#$0010,a4	;D8FC0010
	addq.w	#$01,d4	;5244
	dbra	d6,.FillMonstersLoop	;51CEFF30
	rts	;4E75

adrB_000B22:
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

adrCd000B32:
	bsr	adrCd00665C	;61005B28
	moveq	#$00,d0	;7000
	move.b	$0016(a4),d0	;102C0016
	bmi.s	adrCd000B66	;6B28
	move.b	#$FF,$0016(a4)	;197C00FF0016
	move.w	d0,$001C(a5)	;3B40001C
	move.b	$0017(a4),d0	;102C0017
	move.b	#$FF,$0017(a4)	;197C00FF0017
	move.w	d0,$001E(a5)	;3B40001E
	move.b	$0018(a4),d0	;102C0018
	move.w	d0,$0020(a5)	;3B400020
	move.b	$001A(a4),d0	;102C001A
	move.w	d0,$0058(a5)	;3B400058
adrCd000B66:
	rts	;4E75

adrCd000B68:
	move.w	CurrentTower.l,d0	;30390000EE2E
	add.w	d0,d0	;D040
	lea	LevelData_LookupTable.l,a0	;41F900000B96
	lea	MapData1.l,a6	;4DF90000EF40
	add.w	$00(a0,d0.w),a6	;DCF00000
	lea	adrEA00EE40.l,a0	;41F90000EE40
	moveq	#$0D,d0	;700D
adrLp000B88:
	move.l	(a6)+,(a0)+	;20DE
	dbra	d0,adrLp000B88	;51C8FFFC
	move.l	a6,adrL_00EE78.l	;23CE0000EE78
	rts	;4E75

LevelData_LookupTable:
	dc.w	MapData1-MapData1	;0000
	dc.w	MapData2-MapData1	;1402
	dc.w	MaoData3-MapData1	;2804
	dc.w	MapData4-MapData1	;3C06
	dc.w	MapData5-MapData1	;5008
	dc.w	MapData6-MapData1	;640A

adrCd000BA2:
	bsr	PrepareCharacters	;6100FDF2
adrCd000BA6:
	clr.w	adrB_008C1E.l	;427900008C1E
	move.b	#$FF,adrB_00EE2C.l	;13FC00FF0000EE2C
	lea	Player1_Data.l,a5	;4BF90000EE7C
	move.l	#$00F00020,$0002(a5)	;2B7C00F000200002
	move.w	#$5601,$003A(a5)	;3B7C5601003A
	tst.w	MultiPlayer.l	;4A790000EE30
	beq.s	adrCd000BF6	;6726
	move.w	#$8223,$003A(a5)	;3B7C8223003A
	move.l	#$FFFFFFFF,adrL_00EEF6.l	;23FCFFFFFFFF0000EEF6
	move.w	#$0027,$0008(a5)	;3B7C00270008
	move.w	#$0618,$000A(a5)	;3B7C0618000A
	clr.l	adrL_00EEE0.l	;42B90000EEE0
	moveq	#$00,d7	;7E00
	bra.s	adrLp000C18	;6022

adrCd000BF6:
	lea	Player2_Data.l,a5	;4BF90000EEDE
	move.l	#$00F00088,$0002(a5)	;2B7C00F000880002
	move.w	#$BE68,$003A(a5)	;3B7CBE68003A
	move.w	#$0068,$0008(a5)	;3B7C00680008
	move.w	#$1040,$000A(a5)	;3B7C1040000A
	moveq	#$01,d7	;7E01
adrLp000C18:
	clr.w	$0014(a5)	;426D0014
	move.w	#$FFFF,$0042(a5)	;3B7CFFFF0042
	move.w	#$FFFF,$0040(a5)	;3B7CFFFF0040
	bsr	adrCd000B32	;6100FF08
	bset	#$04,$0018(a5)	;08ED00040018
	lea	Player1_Data.l,a5	;4BF90000EE7C
	dbra	d7,adrLp000C18	;51CFFFDE
	bsr	adrCd0042BA	;6100367C
	move.w	#$FFFF,adrB_008C1E.l	;33FCFFFF00008C1E
adrCd000C48:
	tst.b	adrB_008C1E.l	;4A3900008C1E
	bne.s	adrCd000C48	;66F8
adrCd000C50:
	lea	Player1_Data.l,a5	;4BF90000EE7C
	bsr	adrCd0084D6	;6100787E
	bsr	adrCd004C90	;61004034
	bsr	adrCd0057AC	;61004B4C
	tst.w	MultiPlayer.l	;4A790000EE30
	bne.s	adrCd000C88	;661E
	lea	Player2_Data.l,a5	;4BF90000EEDE
	bsr	adrCd0084D6	;61007864
	bsr	adrCd004C90	;6100401A
	bsr	adrCd0057AC	;61004B32
	jsr	adrCd008FB8.l	;4EB900008FB8
	lea	Player1_Data.l,a5	;4BF90000EE7C
adrCd000C88:
	jsr	adrCd008FB8.l	;4EB900008FB8
	move.b	#$FF,adrB_008C1E.l	;13FC00FF00008C1E
adrCd000C96:
	tst.b	adrB_008C1E.l	;4A3900008C1E
	bne.s	adrCd000C96	;66F8
	bsr.s	adrCd000D04	;6164
	move.b	adrL_00EE94.l,d0	;10390000EE94
	and.b	adrL_00EEF6.l,d0	;C0390000EEF6
	btst	#$06,d0	;08000006
	beq.s	adrCd000CB4	;6702
	bsr.s	adrCd000CC2	;610E
adrCd000CB4:
	move.w	#$0001,adrW_00505A.l	;33FC00010000505A
	bsr	adrCd001238	;6100057A
	bra.s	adrCd000C50	;608E

adrCd000CC2:
	move.l	adrEA00EE36.l,-(sp)	;2F390000EE36
	moveq	#$14,d0	;7014
DBFWait1b:
	dbra	d1,DBFWait1b	;51C9FFFE
	dbra	d0,DBFWait1b	;51C8FFFA
	move.l	#$FFFFFFFF,adrL_00EED6.l	;23FCFFFFFFFF0000EED6
	move.l	#$FFFFFFFF,adrL_00EF38.l	;23FCFFFFFFFF0000EF38
	clr.w	adrB_008C1E.l	;427900008C1E
	bsr	adrCd0042BA	;610035CC
	clr.w	adrB_008C1E.l	;427900008C1E
	moveq	#$14,d0	;7014
DBFWait1c:
	dbra	d1,DBFWait1c	;51C9FFFE
	dbra	d0,DBFWait1c	;51C8FFFA
	bra	LoadGame	;600036A2

adrCd000D04:
	lea	Player1_Data.l,a5	;4BF90000EE7C
	bsr.s	adrCd000D12	;6106
	lea	Player2_Data.l,a5	;4BF90000EEDE
adrCd000D12:
	and.b	#$7F,$0052(a5)	;022D007F0052
	move.b	$0054(a5),d3	;162D0054
	clr.b	$0054(a5)	;422D0054
	move.w	$000A(a5),d0	;302D000A
	move.w	d0,d6	;3C00
	bsr.s	adrCd000D7E	;6156
	move.w	d6,d0	;3006
	add.w	#$001C,d0	;0640001C
	bsr.s	adrCd000D7E	;614E
	lsr.b	#$01,d3	;E20B
	bcc.s	adrCd000D3C	;6408
	move.w	d6,d0	;3006
	add.w	#$0DCC,d0	;06400DCC
	bsr.s	adrCd000D68	;612C
adrCd000D3C:
	move.w	d6,d0	;3006
	lsr.b	#$01,d3	;E20B
	bcc.s	adrCd000D48	;6406
	add.w	#$000C,d0	;0640000C
	bsr.s	adrCd000D68	;6120
adrCd000D48:
	move.w	d6,d0	;3006
	lsr.b	#$01,d3	;E20B
	bcc	adrCd000DEA	;6400009C
	add.w	#$01EC,d0	;064001EC
	move.l	screen_ptr.l,a0	;207900008D36
	move.l	framebuffer_ptr.l,a1	;227900008D3A
	add.w	d0,a1	;D2C0
	add.w	d0,a0	;D0C0
	bra	adrCd000DEC	;60000086

adrCd000D68:
	move.l	screen_ptr.l,a0	;207900008D36
	move.l	framebuffer_ptr.l,a1	;227900008D3A
	add.w	d0,a1	;D2C0
	add.w	d0,a0	;D0C0
	moveq	#$07,d0	;7007
	bra	adrLp000DEE	;60000072

adrCd000D7E:
	moveq	#$06,d2	;7406
	btst	#$05,d3	;08030005
	bne.s	adrCd000D8C	;6606
	moveq	#-$01,d2	;74FF
	add.w	#$0118,d0	;06400118
adrCd000D8C:
	lsr.b	#$01,d3	;E20B
	bcc.s	adrCd000D94	;6404
	add.w	#$0051,d2	;06420051
adrCd000D94:
	lsr.b	#$01,d3	;E20B
	bcc.s	adrCd000D9A	;6402
	addq.w	#$08,d2	;5042
adrCd000D9A:
	tst.w	d2	;4A42
	bmi.s	adrCd000DEA	;6B4C
	move.l	screen_ptr.l,a0	;207900008D36
	move.l	framebuffer_ptr.l,a1	;227900008D3A
	add.w	d0,a1	;D2C0
	add.w	d0,a0	;D0C0
adrLp000DAE:
	lea	$5DC0(a1),a3	;47E95DC0
	lea	$5DC0(a0),a2	;45E85DC0
	move.l	(a3)+,(a2)+	;24DB
	move.l	(a3)+,(a2)+	;24DB
	move.l	(a3)+,(a2)+	;24DB
	lea	$3E80(a1),a3	;47E93E80
	lea	$3E80(a0),a2	;45E83E80
	move.l	(a3)+,(a2)+	;24DB
	move.l	(a3)+,(a2)+	;24DB
	move.l	(a3)+,(a2)+	;24DB
	lea	$1F40(a1),a3	;47E91F40
	lea	$1F40(a0),a2	;45E81F40
	move.l	(a3)+,(a2)+	;24DB
	move.l	(a3)+,(a2)+	;24DB
	move.l	(a3)+,(a2)+	;24DB
	move.l	(a1)+,(a0)+	;20D9
	move.l	(a1)+,(a0)+	;20D9
	move.l	(a1)+,(a0)+	;20D9
	lea	$001C(a0),a0	;41E8001C
	lea	$001C(a1),a1	;43E9001C
	dbra	d2,adrLp000DAE	;51CAFFC6
adrCd000DEA:
	rts	;4E75

adrCd000DEC:
	moveq	#$4B,d0	;704B
adrLp000DEE:
	lea	$5DC0(a1),a3	;47E95DC0
	lea	$5DC0(a0),a2	;45E85DC0
	move.l	(a3)+,(a2)+	;24DB
	move.l	(a3)+,(a2)+	;24DB
	move.l	(a3)+,(a2)+	;24DB
	move.l	(a3)+,(a2)+	;24DB
	lea	$3E80(a1),a3	;47E93E80
	lea	$3E80(a0),a2	;45E83E80
	move.l	(a3)+,(a2)+	;24DB
	move.l	(a3)+,(a2)+	;24DB
	move.l	(a3)+,(a2)+	;24DB
	move.l	(a3)+,(a2)+	;24DB
	lea	$1F40(a1),a3	;47E91F40
	lea	$1F40(a0),a2	;45E81F40
	move.l	(a3)+,(a2)+	;24DB
	move.l	(a3)+,(a2)+	;24DB
	move.l	(a3)+,(a2)+	;24DB
	move.l	(a3)+,(a2)+	;24DB
	move.l	(a1)+,(a0)+	;20D9
	move.l	(a1)+,(a0)+	;20D9
	move.l	(a1)+,(a0)+	;20D9
	move.l	(a1)+,(a0)+	;20D9
	lea	$0018(a0),a0	;41E80018
	lea	$0018(a1),a1	;43E90018
	dbra	d0,adrLp000DEE	;51C8FFBE
	rts	;4E75

adrCd000E34:
	move.l	a4,d0	;200C
	sub.l	#CharacterStats,d0	;04800000EB2A
	lsr.w	#$01,d0	;E248
	lea	PocketContents.l,a0	;41F90000ED2A
	add.w	d0,a0	;D0C0
	lsr.w	#$04,d0	;E848
	move.w	d0,d7	;3E00
	movem.l	d0/d1/d7/a5,-(sp)	;48E7C104
	bsr	adrCd004066	;61003216
	tst.w	d1	;4A41
	bmi.s	adrCd000E64	;6B0E
	btst	#$06,$18(a5,d1.w)	;083500061018
	beq.s	adrCd000E64	;6706
	movem.l	(sp)+,d0/d1/d7/a5	;4CDF2083
	rts	;4E75

adrCd000E64:
	movem.l	(sp)+,d0/d1/d7/a5	;4CDF2083
	move.b	$0009(a4),d0	;102C0009
	cmp.b	$000A(a4),d0	;B02C000A
	beq.s	adrCd000E76	;6704
	addq.b	#$01,$0009(a4)	;522C0009
adrCd000E76:
	move.b	(a4),d0	;1014
	lsr.b	#$01,d0	;E208
	cmp.b	#$5B,(a0)	;0C10005B
	beq.s	adrCd000E8A	;670A
	cmp.b	#$5B,$0001(a0)	;0C28005B0001
	beq.s	adrCd000E8A	;6702
	lsr.b	#$01,d0	;E208
adrCd000E8A:
	addq.b	#$01,d0	;5200
	add.b	$0005(a4),d0	;D02C0005
	bcc.s	adrCd000E94	;6402
	moveq	#-$01,d0	;70FF
adrCd000E94:
	cmp.b	$0006(a4),d0	;B02C0006
	bcs.s	adrCd000E9E	;6504
	move.b	$0006(a4),d0	;102C0006
adrCd000E9E:
	move.b	d0,$0005(a4)	;19400005
	tst.b	$0007(a4)	;4A2C0007
	bne.s	adrCd000ECE	;6626
	movem.l	d7/a4/a5,-(sp)	;48E7010C
	bsr	RandomGen_BytewithOffset	;610046FE
	and.w	#$0007,d0	;02400007
	add.b	(a4),d0	;D014
	cmp.b	$0005(a4),d0	;B02C0005
	bcs.s	adrCd000EC2	;6506
	move.b	$0005(a4),d0	;102C0005
	beq.s	adrCd000ECA	;6708
adrCd000EC2:
	move.w	d0,d5	;3A00
	move.w	d7,d0	;3007
	bsr	adrCd002298	;610013D0
adrCd000ECA:
	movem.l	(sp)+,d7/a4/a5	;4CDF3080
adrCd000ECE:
	move.b	$0010(a4),d0	;102C0010
	bne.s	adrCd000EE0	;660C
	subq.b	#$01,$0007(a4)	;532C0007
	bcc.s	adrCd000EF6	;641C
	clr.b	$0007(a4)	;422C0007
	bra.s	adrCd000EF6	;6016

adrCd000EE0:
	lsr.b	#$06,d0	;EC08
	addq.b	#$01,d0	;5200
	add.b	$0007(a4),d0	;D02C0007
	cmp.b	$0008(a4),d0	;B02C0008
	bcs.s	adrCd000EF2	;6504
	move.b	$0008(a4),d0	;102C0008
adrCd000EF2:
	move.b	d0,$0007(a4)	;19400007
adrCd000EF6:
	rts	;4E75

adrCd000EF8:
	lea	CharacterStats.l,a4	;49F90000EB2A
	moveq	#$0F,d7	;7E0F
adrLp000F00:
	movem.l	d7/a4,-(sp)	;48E70108
	bsr	adrCd000E34	;6100FF2E
	movem.l	(sp)+,d7/a4	;4CDF1080
	add.w	#$0020,a4	;D8FC0020
	dbra	d7,adrLp000F00	;51CFFFEE
	subq.b	#$01,adrB_00EE3C.l	;53390000EE3C
	lea	Player1_Data.l,a5	;4BF90000EE7C
	bsr	adrCd000F3E	;6100001C
	lea	Player2_Data.l,a5	;4BF90000EEDE
	bsr	adrCd000F3E	;61000012
	tst.b	adrB_00EE3C.l	;4A390000EE3C
	bpl.s	adrCd000F3C	;6A06
	clr.b	adrB_00EE3C.l	;42390000EE3C
adrCd000F3C:
	rts	;4E75

adrCd000F3E:
	tst.b	adrB_00EE3C.l	;4A390000EE3C
	bpl	adrCd00104A	;6A000104
	moveq	#$00,d6	;7C00
	moveq	#$03,d7	;7E03
adrLp000F4C:
	move.b	$18(a5,d7.w),d0	;10357018
	bmi.s	adrCd000FB8	;6B66
	btst	#$06,d0	;08000006
	bne.s	adrCd000FB8	;6660
	and.w	#$000F,d0	;0240000F
	move.w	d0,d1	;3200
	bsr	adrCd006660	;61005700
	btst	#$02,(a5)	;08150002
	bne.s	adrCd000F80	;6618
	btst	#$06,$18(a5,d7.w)	;083500067018
	bne.s	adrCd000F80	;6610
	cmpi.b	#$0B,d1	;0C01000B
	beq.s	adrCd000F80	;670A
	subq.b	#$01,$0010(a4)	;532C0010
	bcc.s	adrCd000F80	;6404
	clr.b	$0010(a4)	;422C0010
adrCd000F80:
	move.b	$0011(a4),d0	;102C0011
	and.w	#$0007,d0	;02400007
	beq.s	adrCd000FB8	;672E
	subq.b	#$08,$0011(a4)	;512C0011
	bcc.s	adrCd000FB8	;6428
	clr.b	$0011(a4)	;422C0011
	tst.w	d7	;4A47
	bne.s	adrCd000F9A	;6602
	addq.b	#$01,d6	;5206
adrCd000F9A:
	btst	d7,$003E(a5)	;0F2D003E
	bne.s	adrCd000FB8	;6618
	tst.w	d7	;4A47
	beq.s	adrCd000FAA	;6706
	tst.w	$0042(a5)	;4A6D0042
	bpl.s	adrCd000FB8	;6A0E
adrCd000FAA:
	movem.w	d6/d7,-(sp)	;48A70300
	bsr	adrCd007EF0	;61006F40
	movem.w	(sp)+,d6/d7	;4C9F00C0
	bset	d7,d6	;0FC6
adrCd000FB8:
	dbra	d7,adrLp000F4C	;51CFFF92
	btst	#$00,d6	;08060000
	beq.s	adrCd000FD0	;670E
	tst.b	$0015(a5)	;4A2D0015
	bne.s	adrCd000FD0	;6608
	move.w	d6,-(sp)	;3F06
	bsr	adrCd0081CE	;61007202
	move.w	(sp)+,d6	;3C1F
adrCd000FD0:
	and.w	#$000E,d6	;0246000E
	beq.s	adrCd00104A	;6774
	bsr	adrCd007ED2	;61006EFA
	bra.s	adrCd00104A	;606E

adrCd000FDC:
	btst	#$02,(a5)	;08150002
	beq	adrCd00108E	;670000AC
	clr.w	adrW_001062.l	;427900001062
	bsr	adrCd0084D6	;610074EA
	bsr	adrCd00847E	;6100748E
	move.w	$00(a6,d0.w),d1	;32360000
	and.w	#$0007,d1	;02410007
	subq.w	#$03,d1	;5741
	bne.s	adrCd00100C	;660E
	tst.b	$00(a6,d0.w)	;4A360000
	bne.s	adrCd00100C	;6608
	move.w	#$FFFF,adrW_001062.l	;33FCFFFF00001062
adrCd00100C:
	moveq	#$03,d7	;7E03
adrLp00100E:
	move.b	$18(a5,d7.w),d0	;10357018
	and.w	#$00E0,d0	;024000E0
	bne.s	adrCd001046	;662E
	move.b	$18(a5,d7.w),d0	;10357018
	bsr	adrCd006660	;61005642
	subq.b	#$06,$0015(a4)	;5D2C0015
	bcc.s	adrCd00102A	;6404
	clr.b	$0015(a4)	;422C0015
adrCd00102A:
	movem.l	d7/a5,-(sp)	;48E70104
	bsr	adrCd000E34	;6100FE04
	tst.w	adrW_001062.l	;4A7900001062
	beq.s	adrCd001042	;6708
	subq.b	#$01,$0009(a4)	;532C0009
	bsr	adrCd000E34	;6100FDF4
adrCd001042:
	movem.l	(sp)+,d7/a5	;4CDF2080
adrCd001046:
	dbra	d7,adrLp00100E	;51CFFFC6
adrCd00104A:
	bsr	adrCd0080CA	;6100707E
	move.w	$0014(a5),d1	;322D0014
	subq.w	#$01,d1	;5341
	beq	Click_ShowStats	;670055C0
	subq.b	#$01,d1	;5301
	bne.s	adrCd00108E	;6632
	jmp	adrCd00C812.l	;4EF90000C812

adrW_001062:
	dc.w	$0000	;0000

adrCd001064:
	subq.b	#$01,adrB_00EE3D.l	;53390000EE3D
	bpl.s	adrCd00108E	;6A22
	move.b	#$07,adrB_00EE3D.l	;13FC00070000EE3D
	moveq	#$0F,d7	;7E0F
	lea	CharacterStats.l,a4	;49F90000EB2A
adrLp00107C:
	subq.b	#$01,$0015(a4)	;532C0015
	bcc.s	adrCd001086	;6404
	clr.b	$0015(a4)	;422C0015
adrCd001086:
	add.w	#$0020,a4	;D8FC0020
	dbra	d7,adrLp00107C	;51CFFFF0
adrCd00108E:
	rts	;4E75

adrCd001090:
	moveq	#$00,d6	;7C00
	lea	UnpackedMonsters.l,a3	;47F900016B7E
	lea	adrEA017390.l,a0	;41F900017390
	move.w	-$0002(a0),d7	;3E28FFFE
	bmi.s	adrCd00108E	;6BEA
adrLp0010A4:
	cmp.l	#$FFFFFFFF,(a0)	;0C90FFFFFFFF
	beq.s	adrCd0010EA	;673E
	moveq	#-$01,d4	;78FF
	moveq	#$03,d1	;7203
adrLp0010B0:
	moveq	#$00,d2	;7400
	move.b	$00(a0,d1.w),d2	;14301000
	bmi.s	adrCd0010CA	;6B12
	addq.w	#$01,d4	;5244
	asl.w	#$04,d2	;E942
	move.b	$0D(a3,d2.w),d3	;1633200D
	bmi.s	adrCd0010CA	;6B08
	sub.b	d6,d3	;9606
	move.b	d3,$0D(a3,d2.w)	;1783200D
	move.w	d2,d5	;3A02
adrCd0010CA:
	dbra	d1,adrLp0010B0	;51C9FFE4
	tst.w	d4	;4A44
	bne.s	adrCd00110A	;6638
	move.b	#$FF,$0D(a3,d5.w)	;17BC00FF500D
	move.b	$02(a3,d5.w),d4	;18335002
	and.w	#$0003,d4	;02440003
	move.w	d4,d2	;3404
	asl.w	#$04,d4	;E944
	or.w	d4,d2	;8444
	move.b	d2,$02(a3,d5.w)	;17825002
adrCd0010EA:
	lea	$0004(a0),a1	;43E80004
	lea	(a0),a2	;45D0
	move.w	d7,d1	;3207
	bra.s	adrCd0010F6	;6002

adrLp0010F4:
	move.l	(a1)+,(a2)+	;24D9
adrCd0010F6:
	dbra	d1,adrLp0010F4	;51C9FFFC
	move.l	#$FFFFFFFF,(a2)	;24BCFFFFFFFF
	subq.w	#$01,adrW_01738E.l	;53790001738E
	addq.w	#$01,d6	;5246
	bra.s	adrCd00116E	;6064

adrCd00110A:
	move.w	(a0),d0	;3010
	and.w	#$8080,d0	;02408080
	beq.s	adrCd00116C	;675A
	move.b	$0003(a0),d2	;14280003
	bmi.s	adrCd001120	;6B08
	move.b	#$FF,$0003(a0)	;117C00FF0003
	bra.s	adrCd00112A	;600A

adrCd001120:
	move.b	$0002(a0),d2	;14280002
	move.b	#$FF,$0002(a0)	;117C00FF0002
adrCd00112A:
	moveq	#$01,d1	;7201
	tst.b	d0	;4A00
	bmi.s	adrCd001132	;6B02
	moveq	#$00,d1	;7200
adrCd001132:
	move.b	d2,$00(a0,d1.w)	;11821000
	move.w	d5,d3	;3605
	lsr.w	#$04,d3	;E84B
	cmp.b	(a0),d3	;B610
	beq.s	adrCd00116C	;672E
	move.b	(a0),d3	;1610
	asl.w	#$04,d3	;E943
	move.b	$00(a3,d5.w),$00(a3,d3.w)	;17B350003000
	move.b	$01(a3,d5.w),$01(a3,d3.w)	;17B350013001
	move.b	$04(a3,d5.w),$04(a3,d3.w)	;17B350043004
	move.b	#$FF,$00(a3,d5.w)	;17BC00FF5000
	move.b	$02(a3,d5.w),$02(a3,d3.w)	;17B350023002
	move.b	$0D(a3,d5.w),$0D(a3,d3.w)	;17B3500D300D
	move.b	#$FF,$0D(a3,d5.w)	;17BC00FF500D
adrCd00116C:
	addq.w	#$04,a0	;5848
adrCd00116E:
	dbra	d7,adrLp0010A4	;51CFFF34
	rts	;4E75

adrCd001174:
	clr.w	adrW_0020F4.l	;4279000020F4
	moveq	#$00,d1	;7200
	move.l	adrL_00EE78.l,a6	;2C790000EE78
	lea	adrEA0173F6.l,a0	;41F9000173F6
adrCd001188:
	cmp.w	-$0002(a0),d1	;B268FFFE
	bcs.s	adrCd001190	;6502
	rts	;4E75

adrCd001190:
	move.w	$02(a0,d1.w),d0	;30301002
	subq.b	#$04,$00(a6,d0.w)	;59360000
	bcs.s	adrCd0011B6	;651C
	cmp.b	#$01,$00(a0,d1.w)	;0C3000011000
	bne.s	adrCd0011B2	;6610
	tst.b	$01(a6,d0.w)	;4A360001
	bpl.s	adrCd0011B2	;6A0A
	move.b	$01(a0,d1.w),adrB_00EE3E.l	;13F010010000EE3E
	bsr.s	adrCd0011BA	;6108
adrCd0011B2:
	addq.w	#$04,d1	;5841
	bra.s	adrCd001188	;60D2

adrCd0011B6:
	bsr.s	adrCd001212	;615A
	bra.s	adrCd001188	;60CE

adrCd0011BA:
	movem.l	d1/a0/a5/a6,-(sp)	;48E74086
	move.b	$00(a6,d0.w),d1	;12360000
	lsr.b	#$02,d1	;E409
	movem.w	d0/d1,-(sp)	;48A7C000
	jsr	adrCd0098A4.l	;4EB9000098A4
	bcc.s	adrCd001208	;6438
	tst.b	d0	;4A00
	bmi.s	adrCd0011F0	;6B1C
	cmpi.b	#$10,d0	;0C000010
	bcs.s	adrCd0011E0	;6506
	tst.b	$000B(a1)	;4A29000B
	bmi.s	adrCd001208	;6B28
adrCd0011E0:
	move.w	$0002(sp),d7	;3E2F0002
	bsr	adrCd001E42	;61000C5C
	move.w	(sp),d0	;3017
	bsr	adrCd00230C	;61001120
	bra.s	adrCd001208	;6018

adrCd0011F0:
	move.l	a1,a5	;2A49
	moveq	#$05,d1	;7205
	bsr	adrCd005500	;6100430A
	tst.w	d3	;4A43
	bpl.s	adrCd001208	;6A0C
	move.w	$0002(sp),d7	;3E2F0002
	bsr	adrCd001E42	;61000C40
	bsr	adrCd00248C	;61001286
adrCd001208:
	movem.w	(sp)+,d0/d1	;4C9F0003
	movem.l	(sp)+,d1/a0/a5/a6	;4CDF6102
	rts	;4E75

adrCd001212:
	and.w	#$00F8,$00(a6,d0.w)	;027600F80000
	lea	$00(a0,d1.w),a1	;43F01000
	lea	$0004(a1),a2	;45E90004
	move.w	-$0002(a0),d0	;3028FFFE
	sub.w	d1,d0	;9041
	lsr.w	#$02,d0	;E448
	subq.w	#$01,d0	;5340
	bra.s	adrCd00122E	;6002

adrLp00122C:
	move.l	(a2)+,(a1)+	;22DA
adrCd00122E:
	dbra	d0,adrLp00122C	;51C8FFFC
	subq.w	#$04,-$0002(a0)	;5968FFFE
	rts	;4E75

adrCd001238:
	tst.w	adrEA00EE36.l	;4A790000EE36
	bne.s	adrCd001286	;6646
	move.w	#$012C,adrEA00EE36.l	;33FC012C0000EE36
	bsr	adrCd001174	;6100FF2A
	lea	Player1_Data.l,a5	;4BF90000EE7C
	bsr	adrCd000FDC	;6100FD88
	lea	ReserveSpace_1.l,a6	;4DF900058828
	bsr	adrCd005694	;61004436
	lea	Player2_Data.l,a5	;4BF90000EEDE
	bsr	adrCd000FDC	;6100FD74
	lea	ReserveSpace_2.l,a6	;4DF900058C10
	bsr	adrCd005694	;61004422
	bsr	adrCd001090	;6100FE1A
	bchg	#$01,adrB_00EE3F.l	;087900010000EE3F
	beq.s	adrCd001286	;6704
	bsr	adrCd000EF8	;6100FC74
adrCd001286:
	tst.w	adrW_00EE38.l	;4A790000EE38
	bne	adrCd0013C0	;66000132
	move.w	#$0007,adrW_00EE38.l	;33FC00070000EE38
	bsr	adrCd001064	;6100FDCA
	lea	adrEA0174F8.l,a0	;41F9000174F8
	lea	-$0002(a0),a1	;43E8FFFE
	move.l	adrL_00EE78.l,a6	;2C790000EE78
	move.w	-$0002(a0),d7	;3E28FFFE
	bra.s	adrCd0012DA	;6028

adrLp0012B2:
	move.w	(a0)+,d0	;3018
	subq.w	#$01,(a0)	;5350
	move.w	(a0)+,d1	;3218
	not.w	d1	;4641
	and.w	#$0003,d1	;02410003
	bne.s	adrCd0012DA	;661A
	bclr	#$05,$01(a6,d0.w)	;08B600050001
	subq.w	#$04,a0	;5948
	lea	(a0),a2	;45D0
	lea	$0004(a0),a3	;47E80004
	move.w	d7,d1	;3207
	bra.s	adrCd0012D4	;6002

adrLp0012D2:
	move.l	(a3)+,(a2)+	;24DB
adrCd0012D4:
	dbra	d1,adrLp0012D2	;51C9FFFC
	subq.w	#$01,(a1)	;5351
adrCd0012DA:
	dbra	d7,adrLp0012B2	;51CFFFD6
	lea	Player1_Data.l,a5	;4BF90000EE7C
	bsr	adrCd002904	;6100161E
	lea	Player2_Data.l,a5	;4BF90000EEDE
	bsr	adrCd002904	;61001614
	moveq	#$00,d7	;7E00
	move.w	#$FFFF,adrW_0013C2.l	;33FCFFFF000013C2
	clr.w	adrW_0013C4.l	;4279000013C4
	lea	CharacterStats.l,a4	;49F90000EB2A
adrCd001308:
	move.w	d7,-(sp)	;3F07
	move.w	d7,d0	;3007
	move.w	d7,adrW_0013C2.l	;33C7000013C2
	bsr	adrCd004066	;61002D52
	tst.w	d1	;4A41
	bpl.s	adrCd001320	;6A06
	moveq	#$16,d4	;7816
	bsr	adrCd0013C6	;610000A8
adrCd001320:
	add.w	#$0020,a4	;D8FC0020
	move.w	(sp)+,d7	;3E1F
	addq.w	#$01,d7	;5247
	cmpi.w	#$0010,d7	;0C470010
	bcs.s	adrCd001308	;65DA
	lea	UnpackedMonsters.l,a4	;49F900016B7E
	move.w	-$0002(a4),d7	;3E2CFFFE
	bmi.s	adrCd001352	;6B18
adrLp00133A:
	move.w	d7,-(sp)	;3F07
	addq.w	#$01,adrW_0013C2.l	;5279000013C2
	moveq	#$00,d4	;7800
	bsr	adrCd0013D8	;61000092
	add.w	#$0010,a4	;D8FC0010
	move.w	(sp)+,d7	;3E1F
	dbra	d7,adrLp00133A	;51CFFFEA
adrCd001352:
	lea	Player1_Data.l,a5	;4BF90000EE7C
	bsr.s	adrCd001360	;6106
	lea	Player2_Data.l,a5	;4BF90000EEDE
adrCd001360:
	moveq	#$03,d7	;7E03
	moveq	#$00,d6	;7C00
adrLp001364:
	tst.b	$5A(a5,d7.w)	;4A35705A
	bmi.s	adrCd00137E	;6B14
	subq.b	#$01,$5A(a5,d7.w)	;5335705A
	bpl.s	adrCd00137E	;6A0E
	moveq	#$01,d6	;7C01
	movem.w	d6/d7,-(sp)	;48A70300
	bsr	adrCd007EF0	;61006B78
	movem.w	(sp)+,d6/d7	;4C9F00C0
adrCd00137E:
	dbra	d7,adrLp001364	;51CFFFE4
	tst.w	d6	;4A46
	beq	adrCd00138C	;67000006
	bsr	adrCd007ED2	;61006B48
adrCd00138C:
	moveq	#$03,d7	;7E03
adrLp00138E:
	tst.b	$5E(a5,d7.w)	;4A35705E
	bmi.s	adrCd0013A2	;6B0E
	subq.b	#$01,$5E(a5,d7.w)	;5335705E
	bpl.s	adrCd0013A2	;6A08
	move.w	d7,-(sp)	;3F07
	bsr	adrCd006096	;61004CF8
	move.w	(sp)+,d7	;3E1F
adrCd0013A2:
	dbra	d7,adrLp00138E	;51CFFFEA
	rts	;4E75

adrCd0013A8:
	sub.w	d1,d0	;9041
	move.w	d0,d1	;3200
	bpl.s	adrCd0013B0	;6A02
	neg.w	d0	;4440
adrCd0013B0:
	move.w	d0,d2	;3400
	swap	d0	;4840
	swap	d1	;4841
	sub.w	d1,d0	;9041
	move.w	d0,d1	;3200
	bpl.s	adrCd0013BE	;6A02
	neg.w	d0	;4440
adrCd0013BE:
	add.w	d0,d2	;D440
adrCd0013C0:
	rts	;4E75

adrW_0013C2:
	dc.w	$0000	;0000
adrW_0013C4:
	dc.w	$0000	;0000

adrCd0013C6:
	move.w	CurrentTower.l,d0	;30390000EE2E
	cmp.b	$001F(a4),d0	;B02C001F
	bne.s	adrCd0013C0	;66EE
	bsr	adrCd002984	;610015B0
	bra.s	adrCd0013EE	;6016

adrCd0013D8:
	move.b	$0005(a4),d0	;102C0005
	bsr	adrCd002972	;61001594
	move.b	$0005(a4),d1	;122C0005
	and.b	#$60,d1	;02010060
	or.b	d1,d0	;8001
	move.b	d0,$0005(a4)	;19400005
adrCd0013EE:
	move.b	$04(a4,d4.w),d0	;10344004
	cmp.b	adrB_00EED5.l,d0	;B0390000EED5
	beq.s	adrCd001402	;6708
	cmp.b	adrB_00EF37.l,d0	;B0390000EF37
	bne.s	adrCd001414	;6612
adrCd001402:
	move.b	$03(a4,d4.w),d7	;1E344003
	move.w	d7,d1	;3207
	and.w	#$000F,d1	;0241000F
	subq.w	#$01,d1	;5341
	bcs.s	adrCd001416	;6506
	subq.b	#$01,$03(a4,d4.w)	;53344003
adrCd001414:
	rts	;4E75

adrCd001416:
	move.w	d7,d1	;3207
	lsr.b	#$04,d1	;E809
	or.b	d7,d1	;8207
	move.b	d1,$03(a4,d4.w)	;19814003
	btst	#$06,$05(a4,d4.w)	;083400064005
	beq.s	adrCd00143E	;6716
	move.w	#$001E,adrW_0020F4.l	;33FC001E000020F4
	bsr	adrCd0014E8	;610000B6
	tst.w	d5	;4A45
	bne.s	adrCd00143E	;6606
	bclr	#$06,$05(a4,d4.w)	;08B400064005
adrCd00143E:
	btst	#$05,$05(a4,d4.w)	;083400054005
	beq.s	adrCd00146E	;6728
	and.b	#$F0,$03(a4,d4.w)	;023400F04003
	or.b	#$02,$03(a4,d4.w)	;003400024003
	move.w	#$0028,adrW_0020F4.l	;33FC0028000020F4
	bsr	adrCd0014E8	;6100008C
	tst.w	d5	;4A45
	bne.s	adrCd00146E	;660C
	bclr	#$05,$05(a4,d4.w)	;08B400054005
	or.b	#$0F,$03(a4,d4.w)	;0034000F4003
adrCd00146E:
	tst.b	$05(a4,d4.w)	;4A344005
	bpl.s	adrCd001498	;6A24
	move.w	#$0014,adrW_0020F4.l	;33FC0014000020F4
	bsr	adrCd0014E8	;6100006A
	and.b	#$7F,$05(a4,d4.w)	;0234007F4005
	tst.w	d5	;4A45
	beq.s	adrCd001498	;670E
	or.b	#$0F,$03(a4,d4.w)	;0034000F4003
	bset	#$07,$05(a4,d4.w)	;08F400074005
adrCd001496:
	rts	;4E75

adrCd001498:
	moveq	#$00,d7	;7E00
	move.b	$00(a4,d4.w),d7	;1E344000
	bmi	adrCd001414	;6B00FF74
	swap	d7	;4847
	move.b	$01(a4,d4.w),d7	;1E344001
	moveq	#$00,d0	;7000
	move.b	$04(a4,d4.w),d0	;10344004
	bsr	adrCd0084DA	;6100702A
	bsr	CoordToMap	;61006FE8
	move.b	$01(a6,d0.w),d1	;12360001
	bpl.s	adrCd001496	;6ADA
	cmpi.w	#$0000,d4	;0C440000
	beq.s	adrCd00150C	;674A
	bsr	adrCd001842	;6100037E
	bpl	adrCd001BCE	;6A000706
	tst.w	adrW_0013C4.w	;4A7813C4	;Short Absolute converted to symbol!
	beq	AttackType_Drone	;6700028A
	lea	ReserveSpace_1.l,a6	;4DF900058828
	btst	#$00,(a5)	;08150000
	beq.s	adrCd0014E4	;6706
	lea	ReserveSpace_2.l,a6	;4DF900058C10
adrCd0014E4:
	bra	adrCd0016CE	;600001E8

adrCd0014E8:
	move.l	a4,a1	;224C
	move.l	a1,d0	;2009
	cmpi.w	#$0000,d4	;0C440000
	bne.s	adrCd001500	;660E
	sub.l	#UnpackedMonsters,d0	;048000016B7E
	lsr.w	#$04,d0	;E848
	add.w	#$0010,d0	;06400010
	bra.s	adrCd001508	;6008

adrCd001500:
	sub.l	#CharacterStats,d0	;04800000EB2A
	lsr.w	#$05,d0	;EA48
adrCd001508:
	bra	adrCd0020F6	;60000BEC

adrCd00150C:
	move.b	$000B(a4),d2					;142C000B
	bmi	adrCd001708					;6B0001F6
	cmpi.b	#$40,d2						;0C020040
	beq.s	adrCd001526					;670C
	cmpi.b	#$67,d2						;0C020067
	bcc.s	adrCd001526					;6406
	tst.b	$000D(a4)					;4A2C000D
	bmi.s	adrCd00153A					;6B14
adrCd001526:
	and.b	#$03,$0002(a4)					;022C00030002
	move.b	$0002(a4),d6					;1C2C0002
	asl.b	#$04,d6						;E906
	or.b	$0002(a4),d6					;8C2C0002
	move.b	d6,$0002(a4)					;19460002
adrCd00153A:
	bsr	adrCd001842	;61000306
	bpl	adrCd001BCE	;6A00068E
	move.w	adrW_0013C2.w,d1	;323813C2	;Short Absolute converted to symbol!
	cmp.b	adrB_00EEB1.l,d1	;B2390000EEB1
	beq	adrCd001BD4	;67000686
	cmp.b	adrB_00EF13.l,d1	;B2390000EF13
	beq	adrCd001BD4	;6700067C
	move.b	$0005(a4),d1	;122C0005
	and.w	#$0060,d1	;02410060
	bne	AttackType_Drone	;660001F6
	move.b	$0006(a4),d0	;102C0006
	move.b	$0007(a4),d1	;122C0007
	and.w	#$007F,d1	;0241007F
	and.w	#$007F,d0	;0240007F
	cmp.w	d0,d1	;B240
	bcc.s	adrCd001596	;641C
	move.l	a4,a1	;224C
	clr.w	adrW_0020F4.l	;4279000020F4
	bsr	adrCd0020F6	;61000B72
	tst.w	d5	;4A45
	beq.s	adrCd001596	;670C
	bchg	#$07,$0007(a4)	;086C00070007
	beq.s	adrCd001596	;6704
	addq.b	#$01,$0007(a4)	;522C0007
adrCd001596:
	move.b	$000A(a4),d1	;122C000A
	add.w	d1,d1	;D241
	lea	AttackType_NoSpells.l,a1	;43F90000166A
	lea	MonsterAttackTypeTable.l,a0	;41F9000015AE
	add.w	$00(a0,d1.w),a1	;D2F01000
	jmp	(a1)	;4ED1

MonsterAttackTypeTable:
	dc.w	AttackType_NoSpells-AttackType_NoSpells	;0000
	dc.w	AttackType_Spells-AttackType_NoSpells	;FF6C
	dc.w	AttackType_Drone-AttackType_NoSpells	;00F0
	dc.w	AttackType_DroneSpells-AttackType_NoSpells	;FF4E
	dc.w	AttackType_ArcBoltMachine-AttackType_NoSpells	;FFFA

AttackType_DroneSpells:
	bsr	RandomGen_BytewithOffset	;61003FF2
	and.w	#$000F,d0	;0240000F
	bne	AttackType_Drone	;66000198
	bra.s	adrCd0015E0	;601A

MonsterAttackSpells:
	dc.b	$0A	;0A
	dc.b	$0A	;0A
	dc.b	$00	;00
	dc.b	$8B	;8B
	dc.b	$8B	;8B
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$8E	;8E
	dc.b	$83	;83
	dc.b	$8E	;8E
	dc.b	$8E	;8E
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$83	;83

AttackType_Spells:
	bsr	adrCd005556	;61003F7E
	subq.b	#$02,d0	;5500
	bcc	AttackType_NoSpells	;6400008C
adrCd0015E0:
	bsr	RandomGen_BytewithOffset	;61003FCA
	and.w	#$000F,d0	;0240000F
	move.b	$0007(a4),d3	;162C0007
	and.w	#$007F,d3	;0243007F
	cmpi.b	#$08,d3	;0C030008
	bcc.s	adrCd001608	;6412
	lsr.w	#$01,d0	;E248
	cmpi.b	#$05,d3	;0C030005
	bcc.s	adrCd001608	;640A
	lsr.w	#$01,d0	;E248
	cmpi.b	#$04,d3	;0C030004
	bcc.s	adrCd001608	;6402
	lsr.w	#$01,d0	;E248
adrCd001608:
	move.b	MonsterAttackSpells(pc,d0.w),d0	;103B00BC
	move.w	d0,d4	;3800
	or.w	#$0080,d4	;00440080
	move.w	d3,d6	;3C03
	and.w	#$0080,d0	;02400080
	or.b	d0,d3	;8600
	add.w	d3,d3	;D643
	add.b	d6,d3	;D606
	cmpi.b	#$81,d4	;0C040081
	beq.s	adrCd00162C	;6708
	cmpi.b	#$8E,d4	;0C04008E
	beq.s	adrCd00162C	;6702
	lsr.b	#$01,d3	;E20B
adrCd00162C:
	move.b	$0002(a4),d0	;102C0002
	and.w	#$0003,d0	;02400003
	move.w	d0,d6	;3C00
	swap	d6	;4846
	move.w	d0,d6	;3C00
	moveq	#$00,d5	;7A00
	move.b	$0004(a4),d5	;1A2C0004
	moveq	#$00,d7	;7E00
	move.b	$0000(a4),d7	;1E2C0000
	swap	d7	;4847
	move.b	$0001(a4),d7	;1E2C0001
	move.b	#$1F,$0005(a4)	;197C001F0005
	move.l	a4,-(sp)	;2F0C
	move.b	#$FF,adrB_00EE3E.l	;13FC00FF0000EE3E
	bsr	adrCd00533C	;61003CDE
	move.l	(sp)+,a4	;285F
	rts	;4E75

AttackType_ArcBoltMachine:
	moveq	#$0C,d3	;760C
	moveq	#$0B,d0	;700B
	bra.s	adrCd001608	;609E

AttackType_NoSpells:
	moveq	#-$01,d2	;74FF
	move.b	$0004(a4),d1	;122C0004
	cmp.b	adrB_00EED5.l,d1	;B2390000EED5
	bne.s	adrCd001684	;660C
	move.l	adrL_00EE98.l,d0	;20390000EE98
	move.l	d7,d1	;2207
	bsr	adrCd0013A8	;6100FD26
adrCd001684:
	move.w	d2,d3	;3602
	moveq	#-$01,d2	;74FF
	move.b	$0004(a4),d1	;122C0004
	cmp.b	adrB_00EF37.l,d1	;B2390000EF37
	bne.s	adrCd0016A0	;660C
	move.l	adrL_00EEFA.l,d0	;20390000EEFA
	move.l	d7,d1	;2207
	bsr	adrCd0013A8	;6100FD0A
adrCd0016A0:
	moveq	#$00,d4	;7800
	tst.w	d2	;4A42
	bmi.s	adrCd0016BE	;6B18
	move.l	a4,d0	;200C
	sub.l	#MonsterData_1,d0	;048000017584
	lsr.w	#$04,d0	;E848
	add.b	$000B(a4),d0	;D02C000B
	add.b	$0006(a4),d0	;D02C0006
	and.w	#$0001,d0	;02400001
	add.w	d0,d2	;D440
adrCd0016BE:
	lea	ReserveSpace_1.l,a6	;4DF900058828
	cmp.w	d2,d3	;B642
	bcs.s	adrCd0016CE	;6506
	lea	ReserveSpace_2.l,a6	;4DF900058C10
adrCd0016CE:
	move.w	d7,d0	;3007
	mulu	adrW_00EE70.l,d0			;C0F90000EE70
	swap	d7					;4847
	add.w	d7,d0					;D047
	swap	d7					;4847
	move.b	$00(a6,d0.w),d0				;10360000
	beq.s	AttackType_Drone				;6778
	cmpi.b	#$FF,d0					;0C0000FF
	beq.s	AttackType_Drone				;6772
	and.w	#$0003,d0				;02400003
	move.b	$02(a4,d4.w),d6				;1C344002
	and.w	#$0003,d6				;02460003
	cmp.w	d0,d6					;BC40
	beq.s	AttackType_Drone				;6762
	eor.w	d0,d6					;B146
	subq.w	#$02,d6					;5546
	beq	adrCd001BB8				;670004BA
	move.b	$02(a4,d4.w),d6				;1C344002
	bra	adrCd001BC6				;600004C0

adrCd001708:
	sub.b	#$84,d2					;04020084
	bcs.s	AttackType_Drone				;654C
	beq.s	adrCd001714				;6704
	subq.b	#$03,d2					;5702
	bne.s	AttackType_Drone				;6646
adrCd001714:
	not.w	d1					;4641
	and.w	#$0007,d1				;02410007
	beq.s	adrCd001728				;670C
	cmpi.w	#$0007,d1				;0C410007
	bne.s	AttackType_Drone				;6638
	tst.b	$00(a6,d0.w)				;4A360000
	bne.s	AttackType_Drone				;6632
adrCd001728:
	or.b	#$07,$01(a6,d0.w)			;003600070001
	moveq	#$00,d1					;7200
	move.b	$0006(a4),d1				;122C0006
	cmp.b	#$84,$000B(a4)				;0C2C0084000B
	bne.s	adrCd001746				;660A
	add.b	d1,d1					;D201
	cmpi.b	#$40,d1					;0C010040
	bcs.s	adrCd001746				;6502
	moveq	#$3F,d1					;723F
adrCd001746:
	asl.b	#$02,d1					;E501
	addq.b	#$01,d1					;5201
	move.b	d1,$00(a6,d0.w)	;1D810000
	move.w	#$0100,d1	;323C0100
	move.b	$000C(a4),d1	;122C000C
	bsr	adrCd0054BE	;61003D66
AttackType_Drone:
	move.b	$02(a4,d4.w),d6	;1C344002
	and.w	#$0003,d6	;02460003
	bsr	adrCd007A44	;610062E0
	bcs	adrCd001AF0	;65000388
	cmpi.w	#$0000,d4	;0C440000
	bne.s	adrCd001778	;6608
	cmp.b	#$85,$000B(a4)	;0C2C0085000B
	beq.s	adrCd0017EE	;6776
adrCd001778:
	move.b	d7,$01(a4,d4.w)	;19874001
	swap	d7	;4847
	move.b	d7,$00(a4,d4.w)	;19874000
	swap	d7	;4847
	bsr	adrCd001842	;610000BC
	and.w	#$0030,d0	;02400030
	bsr	adrCd001BCE	;61000440
	cmpi.b	#$00,d4	;0C040000
	bne.s	adrCd00179C	;6606
	tst.b	$000B(a4)	;4A2C000B
	bmi.s	adrCd0017EC	;6B50
adrCd00179C:
	bsr	CoordToMap	;61006CFE
	move.w	$00(a6,d0.w),d1	;32360000
	not.w	d1	;4641
	and.w	#$0007,d1	;02410007
	bne.s	adrCd0017EC	;6640
	move.b	$00(a6,d0.w),d1	;12360000
	move.w	d1,d7	;3E01
	and.w	#$0003,d1	;02410003
	subq.b	#$01,d1	;5301
	bne.s	adrCd0017EC	;6632
	lea	adrEA0173F6.l,a0	;41F9000173F6
	moveq	#-$04,d1	;72FC
adrCd0017C2:
	addq.w	#$04,d1	;5841
	cmp.w	-$0002(a0),d1	;B268FFFE
	bcc.s	adrCd0017EC	;6422
	cmp.w	$02(a0,d1.w),d0	;B0701002
	bne.s	adrCd0017C2	;66F2
	move.b	$01(a0,d1.w),adrB_00EE3E.l	;13F010010000EE3E
	lsr.b	#$02,d7	;E40F
	move.l	a4,-(sp)	;2F0C
	bsr	adrCd001E42	;61000664
	clr.w	adrW_0020F4.l	;4279000020F4
	bsr	adrCd00230C	;61000B24
	move.l	(sp)+,a4	;285F
adrCd0017EC:
	rts	;4E75

adrCd0017EE:
	move.w	$00(a6,d0.w),d1	;32360000
	not.b	d1	;4601
	and.w	#$0007,d1	;02410007
	bne.s	adrCd001808	;660E
	move.b	$00(a6,d0.w),d1	;12360000
	and.w	#$0003,d1	;02410003
	subq.w	#$01,d1	;5341
	beq	adrCd001778	;6700FF72
adrCd001808:
	move.w	$00(a6,d2.w),d1	;32362000
	not.b	d1	;4601
	and.w	#$0007,d1	;02410007
	beq.s	adrCd00181E	;670A
	move.b	#$80,$000B(a4)	;197C0080000B
	bra	adrCd001778	;6000FF5C

adrCd00181E:
	bclr	#$07,$01(a6,d0.w)	;08B600070001
	bset	#$07,$01(a6,d2.w)	;08F600072001
	eor.b	#$02,$0002(a4)	;0A2C00020002
	rts	;4E75

adrB_001832:
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

adrCd001842:
	moveq	#$00,d6	;7C00
	move.b	$02(a4,d4.w),d6	;1C344002
	move.w	d6,d0	;3006
	and.w	#$0003,d6	;02460003
	move.w	d6,d2	;3406
	asl.w	#$02,d2	;E542
	lsr.w	#$04,d0	;E848
	add.w	d0,d2	;D440
	move.b	adrB_001832(pc,d2.w),d0	;103B20DA
	rts	;4E75

adrCd00185C:
	clr.w	adrW_006458.l	;427900006458
	jsr	adrCd0098A4.l	;4EB9000098A4
	bcc	adrCd001BB8	;6400034E
	tst.b	d0	;4A00
	bmi	adrCd001AB6	;6B000246
	cmpi.b	#$10,d0	;0C000010
	bcs	adrCd001982	;6500010A
	move.b	$000B(a4),d2	;142C000B
	bmi	adrCd001982	;6B000102
	cmpi.b	#$64,d2	;0C020064
	bne.s	adrCd001894	;660C
	move.b	$000C(a4),adrB_00EE3E.l	;13EC000C0000EE3E
	bra	adrCd001982	;600000F0

adrCd001894:
	cmp.b	#$64,$000B(a1)				;0C290064000B
	beq	adrCd001982				;670000E6
	cmpi.b	#$40,d2					;0C020040
	beq	adrCd001BB8				;67000314
	cmpi.b	#$67,d2					;0C020067
	bcc	adrCd001BB8				;6400030C
	move.b	$000B(a1),d2				;1429000B
	bpl.s	adrCd0018F6				;6A42
	cmpi.b	#$85,d2					;0C020085
	bne	adrCd001BB8				;660002FE
	move.l	a4,-(sp)				;2F0C
	moveq	#$00,d7					;7E00
	move.b	$0000(a4),d7				;1E2C0000
	swap	d7					;4847
	move.b	$0001(a4),d7				;1E2C0001
	bsr	CoordToMap				;61006BD0
	bclr	#$07,$01(a6,d0.w)			;08B600070001
	moveq	#$00,d7				;7E00
	move.b	$0000(a1),d7			;1E290000
	move.b	d7,$0000(a4)			;19470000
	swap	d7				;4847
	move.b	$0001(a1),d7			;1E290001
	move.b	d7,$0001(a4)			;19470001
	bsr	CoordToMap		;61006BB2
	move.l	a1,a4				;2849
	bsr	adrCd001D58		;61000468
	move.l	(sp)+,a4		;285F
	rts				;4E75

adrCd0018F6:
	cmpi.b	#$40,d2	;0C020040
	beq	adrCd001BB8	;670002BC
	cmpi.b	#$67,d2	;0C020067
	bcc	adrCd001BB8	;640002B4
	tst.b	$000D(a4)	;4A2C000D
	bpl	adrCd001BB8	;6A0002AC
	moveq	#$00,d3	;7600
	move.b	$000D(a1),d3	;1629000D
	bpl.s	adrCd00193C	;6A26
	lea	adrEA017390.l,a0	;41F900017390
	addq.w	#$01,-$0002(a0)	;5268FFFE
	move.w	-$0002(a0),d3	;3628FFFE
	move.b	d3,$000D(a1)	;1343000D
	asl.w	#$02,d3	;E543
	sub.w	#$0010,d0	;04400010
	move.l	#$FFFFFFFF,$00(a0,d3.w)	;21BCFFFFFFFF3000
	move.b	d0,$00(a0,d3.w)	;11803000
	lsr.w	#$02,d3	;E44B
adrCd00193C:
	asl.w	#$02,d3	;E543
	lea	adrEA017390.l,a0	;41F900017390
	add.w	d3,a0	;D0C3
	moveq	#$03,d2	;7403
adrLp001948:
	tst.b	$00(a0,d2.w)	;4A302000
	bmi.s	adrCd001956	;6B08
	dbra	d2,adrLp001948	;51CAFFF8
	bra	adrCd001BB8	;60000264

adrCd001956:
	move.l	a4,d0	;200C
	sub.l	#UnpackedMonsters,d0	;048000016B7E
	lsr.w	#$04,d0	;E848
	move.b	d0,$00(a0,d2.w)	;11802000
	moveq	#$00,d7	;7E00
	move.b	$0000(a4),d7	;1E2C0000
	swap	d7	;4847
	move.b	$0001(a4),d7	;1E2C0001
	move.b	#$FF,$0000(a4)	;197C00FF0000
	bsr	CoordToMap	;61006B24
	bclr	#$07,$01(a6,d0.w)	;08B600070001
	rts	;4E75

adrCd001982:
	move.w	d0,d1	;3200
adrCd001984:
	move.b	$000B(a4),d0	;102C000B
	bpl	adrCd001A4A	;6A0000C0
	cmpi.b	#$10,d1	;0C010010
	bcs.s	adrCd00199C	;650A
	tst.b	$000C(a4)	;4A2C000C
	bpl	adrCd001A4A	;6A0000B2
	rts	;4E75

adrCd00199C:
	movem.l	d1/a5,-(sp)	;48E74004
	move.w	d1,d0	;3001
	bsr	adrCd004066	;610026C2
	tst.w	d1	;4A41
	bmi.s	adrCd0019C2	;6B18
	moveq	#$01,d1	;7201
	move.l	a4,-(sp)	;2F0C
	bsr	adrCd005500	;61003B50
	move.l	(sp)+,a4	;285F
	tst.w	d3	;4A43
	bmi.s	adrCd0019C2	;6B0A
	swap	d3	;4843
	movem.l	(sp)+,d1/a5	;4CDF2002
	move.w	d3,d1	;3203
	bra.s	adrCd0019C6	;6004

adrCd0019C2:
	movem.l	(sp)+,d1/a5			;4CDF2002
adrCd0019C6:
	move.w	d1,d0				;3001
	move.l	a4,a2				;244C
	bsr	adrCd006660			;61004C94
	exg	a4,a2				;C54C
	move.b	$0011(a2),d0			;102A0011
	and.w	#$0007,d0			;02400007
	subq.w	#$01,d0				;5340
	bne.s	adrCd001A4A	;666E
	move.b	#$01,$0011(a2)	;157C00010011
	moveq	#$00,d7	;7E00
	move.b	$0000(a4),d7	;1E2C0000
	swap	d7	;4847
	move.b	$0001(a4),d7	;1E2C0001
	bsr	CoordToMap	;61006AAC
	tst.b	$01(a6,d0.w)	;4A360001
	bpl.s	adrCd001A06	;6A0E
	move.w	d1,-(sp)	;3F01
	bsr	adrCd0098A4	;61007EA8
	move.w	(sp)+,d1	;321F
	tst.b	d0	;4A00
	bmi	adrCd001A4A	;6B000046
adrCd001A06:
	moveq	#$00,d4	;7800
	move.b	$000B(a4),d4	;182C000B
	move.b	$0002(a4),d0	;102C0002
	and.w	#$0003,d0	;02400003
	lea	adrEA005794.l,a0	;41F900005794
	add.b	$08(a0,d0.w),d7	;DE300008
	swap	d7	;4847
	add.b	$00(a0,d0.w),d7	;DE300000
	swap	d7	;4847
	eor.b	#$02,d0	;0A000002
	move.w	d0,d6	;3C00
	swap	d6	;4846
	move.w	d0,d6	;3C00
	moveq	#$00,d5	;7A00
	move.b	$0004(a4),d5	;1A2C0004
	move.b	$0006(a4),d3	;162C0006
	and.w	#$007F,d3	;0243007F
	add.w	d3,d3	;D643
	move.b	d1,adrB_00EE3E.l	;13C10000EE3E
	bra	adrCd00533C	;600038F4

adrCd001A4A:
	moveq	#$00,d3	;7600
	move.b	$000D(a4),d3	;162C000D
	bmi.s	adrCd001A84	;6B32
	move.l	a4,-(sp)	;2F0C
	asl.w	#$02,d3	;E543
	lea	adrEA017390.l,a0	;41F900017390
	add.w	d3,a0	;D0C3
	moveq	#$01,d0	;7001
adrLp001A60:
	moveq	#$00,d3	;7600
	move.b	$00(a0,d0.w),d3	;16300000
	bmi.s	adrCd001A7C	;6B14
	movem.l	d0/d1/a0,-(sp)	;48E7C080
	lea	UnpackedMonsters.l,a4	;49F900016B7E
	asl.w	#$04,d3	;E943
	add.w	d3,a4	;D8C3
	bsr.s	adrCd001A84	;610C
	movem.l	(sp)+,d0/d1/a0	;4CDF0103
adrCd001A7C:
	dbra	d0,adrLp001A60	;51C8FFE2
	move.l	(sp)+,a4	;285F
	rts	;4E75

adrCd001A84:
	move.l	a4,d3	;260C
	sub.l	#UnpackedMonsters,d3	;048300016B7E
	lsr.w	#$04,d3	;E84B
	add.w	#$0010,d3	;06430010
	move.b	#$07,$0005(a4)	;197C00070005
	move.l	a4,-(sp)	;2F0C
	move.w	d1,-(sp)	;3F01
	move.w	#$FFFF,adrW_00628A.l	;33FCFFFF0000628A
	bsr	adrCd0061DA	;61004734
	move.w	(sp)+,d0	;301F
	move.w	$0000(a6),d5	;3A2E0000
	bsr	adrCd002298	;610007E8
	move.l	(sp)+,a4	;285F
	rts	;4E75

adrCd001AB6:
	bsr	RandomGen_BytewithOffset	;61003AF4
	move.w	d0,d2	;3400
	and.w	#$0001,d2	;02420001
	moveq	#$00,d0	;7000
	move.b	$0002(a4),d0	;102C0002
	bsr	adrCd006018	;61004550
	tst.b	$000B(a4)	;4A2C000B
	bpl	adrCd001984	;6A00FEB4
	movem.l	d0/d1/a5,-(sp)	;48E7C004
	move.l	a1,a5	;2A49
	move.w	d1,d0	;3001
	bsr	adrCd004078	;6100259C
	bclr	d1,$003C(a5)	;03AD003C
	clr.w	adrW_006458.l	;427900006458
	movem.l	(sp)+,d0/d1/a5	;4CDF2003
	bra	adrCd001984	;6000FE96

adrCd001AF0:
	move.w	adrW_0013C2.w,d1	;323813C2	;Short Absolute converted to symbol!
	cmp.b	adrB_00EEB1.l,d1	;B2390000EEB1
	beq	adrCd001BD4	;670000D8
	cmp.b	adrB_00EF13.l,d1	;B2390000EF13
	beq	adrCd001BD4	;670000CE
	cmpi.w	#$0000,d4	;0C440000
	beq.s	adrCd001B74	;6766
	tst.w	adrW_0013C4.w	;4A7813C4	;Short Absolute converted to symbol!
	beq	adrCd001BB8	;670000A4
	movem.w	d0/d2,-(sp)	;48A7A000
	bsr	adrCd0098A4	;61007D88
	movem.w	(sp)+,d1/d2	;4C9F0006
	tst.b	d0	;4A00
	bpl	adrCd001BB8	;6A000092
	cmp.l	a1,a5	;BBC9
	bne	adrCd001BB8	;6600008C
	bclr	#$07,$01(a6,d2.w)	;08B600072001
	move.l	a4,d0	;200C
	sub.l	#CharacterStats,d0	;04800000EB2A
	lsr.w	#$05,d0	;EA48
	bsr	adrCd004078	;61002538
	bclr	#$05,$18(a5,d1.w)	;08B500051018
	move.b	d0,$0034(a5)	;1B400034
	cmp.b	$0053(a5),d0	;B02D0053
	bne.s	adrCd001B5C	;660A
	move.b	#$FF,$0053(a5)	;1B7C00FF0053
	clr.b	$0014(a5)	;422D0014
adrCd001B5C:
	moveq	#$03,d7	;7E03
adrLp001B5E:
	tst.b	$26(a5,d7.w)	;4A357026
	bmi.s	adrCd001B68	;6B04
	dbra	d7,adrLp001B5E	;51CFFFF8
adrCd001B68:
	move.b	d0,$26(a5,d7.w)	;1B807026
	move.b	#$FF,$0016(a4)	;197C00FF0016
	rts	;4E75

adrCd001B74:
	tst.b	$000B(a4)	;4A2C000B
	bmi	adrCd001CFC	;6B000182
	cmp.b	#$15,$000B(a4)	;0C2C0015000B
	beq.s	adrCd001BB8	;6734
	cmp.b	#$16,$000B(a4)	;0C2C0016000B
	beq.s	adrCd001BB8	;672C
	cmp.w	d2,d0	;B042
	bne.s	adrCd001BA0	;6610
	move.w	$00(a6,d0.w),d1	;32360000
	and.w	#$0007,d1	;02410007
	subq.w	#$02,d1	;5541
	bne	adrCd001C02	;66000066
	bra.s	adrCd001BD6	;6036

adrCd001BA0:
	move.b	$01(a6,d0.w),d2	;14360001
	bpl.s	adrCd001BB8	;6A12
	move.b	#$FF,adrB_00EE3E.l	;13FC00FF0000EE3E
	and.w	#$0007,d2	;02420007
	subq.w	#$01,d2	;5342
	bne	adrCd00185C	;6600FCA6
adrCd001BB8:
	bsr	RandomGen_BytewithOffset	;610039F2
	or.w	#$0001,d0	;00400001
	move.b	$02(a4,d4.w),d6	;1C344002
	add.w	d6,d0	;D046
adrCd001BC6:
	and.w	#$0003,d0	;02400003
	and.w	#$00F0,d6	;024600F0
adrCd001BCE:
	or.b	d6,d0	;8006
	move.b	d0,$02(a4,d4.w)	;19804002
adrCd001BD4:
	rts	;4E75

adrCd001BD6:
	move.b	$0002(a4),d6	;1C2C0002
	and.w	#$0003,d6	;02460003
	move.b	$00(a6,d0.w),d1	;12360000
	add.w	d6,d6	;DC46
	addq.w	#$01,d6	;5246
	btst	d6,$00(a6,d0.w)	;0D360000
	beq.s	adrCd001C02	;6716
	subq.w	#$01,d6	;5346
	btst	d6,$00(a6,d0.w)	;0D360000
	beq.s	adrCd001C02	;670E
	btst	#$04,$01(a6,d0.w)	;083600040001
	bne.s	adrCd001BB8	;66BC
	bclr	d6,$00(a6,d0.w)	;0DB60000
	rts	;4E75

adrCd001C02:
	moveq	#$00,d7	;7E00
	move.b	$0000(a4),d7	;1E2C0000
	swap	d7	;4847
	move.b	$0001(a4),d7	;1E2C0001
	move.b	$0002(a4),d0	;102C0002
	and.w	#$0003,d0	;02400003
	move.w	d0,d6	;3C00
	bsr	adrCd008486	;6100686C
	move.w	$00(a6,d0.w),d1	;32360000
	and.w	#$0007,d1	;02410007
	subq.w	#$02,d1	;5541
	bne.s	adrCd001BB8	;6690
	btst	#$04,$01(a6,d0.w)	;083600040001
	bne.s	adrCd001BB8	;6688
	eor.b	#$02,d6	;0A060002
	add.w	d6,d6	;DC46
	addq.w	#$01,d6	;5246
	btst	d6,$00(a6,d0.w)	;0D360000
	beq	adrCd001BB8	;6700FF7A
	subq.w	#$01,d6	;5346
	bclr	d6,$00(a6,d0.w)	;0DB60000
	rts	;4E75

adrCd001C48:
	cmp.w	d0,d2	;B440
	bne	adrCd001C86	;6600003A
adrCd001C4E:
	move.b	$0002(a4),d6	;1C2C0002
	and.w	#$0003,d6	;02460003
	cmpi.w	#$0002,d6	;0C460002
	bcs.s	adrCd001C60	;6504
	eor.w	#$0001,d6	;0A460001
adrCd001C60:
	moveq	#$00,d1	;7200
	move.b	$000B(a4),d1	;122C000B
	sub.b	#$85,d1	;04010085
	movem.w	d0/d1/d6,-(sp)	;48A7C200
	bsr	adrCd0027E0	;61000B70
	movem.w	(sp)+,d0/d1/d6	;4C9F0043
	cmpi.w	#$0005,d1	;0C410005
	beq.s	adrCd001CD2	;6756
	moveq	#$01,d5	;7A01
	swap	d5	;4845
	move.w	d1,d5	;3A01
	bra	adrCd005E88	;60004204

adrCd001C86:
	moveq	#$00,d7	;7E00
	move.b	$000B(a4),d7	;1E2C000B
	bsr	adrCd001DBC	;6100012E
	tst.b	$01(a6,d0.w)	;4A360001
	bmi.s	adrCd001C9E	;6B08
	eor.b	#$02,$0002(a4)	;0A2C00020002
	bra.s	adrCd001C4E	;60B0

adrCd001C9E:
	movem.l	a4/a5,-(sp)	;48E7000C
	lea	adrEA01737E.l,a0	;41F90001737E
	moveq	#$03,d1	;7203
adrLp001CAA:
	move.l	(a4)+,(a0)+	;20DC
	dbra	d1,adrLp001CAA	;51C9FFFC
	sub.w	#$0010,a4	;98FC0010
	move.w	d0,d4	;3800
	bsr	adrCd0027E0	;61000B28
	move.w	d4,d0	;3004
	lea	adrEA01737E.l,a4	;49F90001737E
	move.b	$000C(a4),adrB_00EE3E.l	;13EC000C0000EE3E
	bsr	adrCd00185C	;6100FB90
	movem.l	(sp)+,a4/a5	;4CDF3000
adrCd001CD2:
	rts	;4E75

adrCd001CD4:
	bsr	adrCd001BB8	;6100FEE2
	move.w	d0,d6	;3C00
	and.w	#$0003,d6	;02460003
	bsr	adrCd007A44	;61005D64
	bcs.s	adrCd001CF0	;650C
	move.b	d7,$0001(a4)	;19470001
	swap	d7	;4847
	move.b	d7,$0000(a4)	;19470000
	rts	;4E75

adrCd001CF0:
	cmp.w	d0,d2	;B440
	bne.s	adrCd001CFC	;6608
	eor.b	#$02,$0002(a4)	;0A2C00020002
	rts	;4E75

adrCd001CFC:
	cmp.b	#$84,$000B(a4)	;0C2C0084000B
	bne.s	adrCd001D1E	;661A
	move.b	#$85,$000B(a4)	;197C0085000B
	move.b	$0006(a4),d1	;122C0006
	addq.w	#$04,d1	;5841
	asl.w	#$02,d1	;E541
	move.b	d1,$0006(a4)	;19410006
adrCd001D16:
	eor.b	#$02,$0002(a4)	;0A2C00020002
	rts	;4E75

adrCd001D1E:
	cmp.w	d2,d0	;B042
	bne.s	adrCd001D32	;6610
	cmp.b	#$85,$000B(a4)	;0C2C0085000B
	beq.s	adrCd001D16	;67EC
	cmp.b	#$82,$000B(a4)	;0C2C0082000B
	beq.s	adrCd001CD4	;67A2
adrCd001D32:
	cmp.b	#$85,$000B(a4)	;0C2C0085000B
	bne.s	adrCd001D52	;6618
	move.w	$00(a6,d0.w),d1	;32360000
	not.b	d1	;4601
	and.w	#$0007,d1	;02410007
	bne.s	adrCd001D16	;66D0
	move.b	$00(a6,d0.w),d1	;12360000
	and.w	#$0003,d1	;02410003
	subq.w	#$01,d1	;5341
	bne.s	adrCd001D16	;66C4
adrCd001D52:
	bclr	#$07,$01(a6,d2.w)	;08B600072001
adrCd001D58:
	cmp.b	#$88,$000B(a4)	;0C2C0088000B
	bcs.s	adrCd001D6A	;650A
	cmp.b	#$8B,$000B(a4)	;0C2C008B000B
	bcs	adrCd001C48	;6500FEE0
adrCd001D6A:
	moveq	#$00,d7	;7E00
	move.b	$0006(a4),d7	;1E2C0006
	swap	d7	;4847
	move.b	$000B(a4),d7	;1E2C000B
	bmi.s	adrCd001D7A	;6B02
	clr.w	d7	;4247
adrCd001D7A:
	moveq	#$00,d1	;7200
	move.b	$0004(a4),d1	;122C0004
	move.w	d0,d4	;3800
	move.b	$000C(a4),adrB_00EE3E.l	;13EC000C0000EE3E
	bmi.s	adrCd001DAA	;6B1E
	movem.l	d0/a0,-(sp)	;48E78080
	cmpi.b	#$83,d7	;0C070083
	beq.s	adrCd001D9E	;6708
	moveq	#$04,d0	;7004
	cmpi.b	#$8B,d7	;0C07008B
	bcs.s	adrCd001DA0	;6502
adrCd001D9E:
	moveq	#$05,d0	;7005
adrCd001DA0:
	jsr	PlaySound.l	;4EB9000088BE
	movem.l	(sp)+,d0/a0	;4CDF0101
adrCd001DAA:
	bsr	adrCd0027E0	;61000A34
	move.w	d4,d0	;3004
	move.l	a4,-(sp)	;2F0C
	bsr.s	adrCd001DE0	;612C
	move.l	(sp)+,a4	;285F
	sub.w	#$0010,a4	;98FC0010
adrCd001DBA:
	rts	;4E75

adrCd001DBC:
	bset	#$05,$01(a6,d0.w)	;08F600050001
	asl.b	#$02,d7	;E507
	addq.w	#$02,d7	;5447
	lea	adrEA0174F8.l,a0	;41F9000174F8
	move.w	-$0002(a0),d2	;3428FFFE
	addq.w	#$01,-$0002(a0)	;5268FFFE
	asl.w	#$02,d2	;E542
	move.w	d0,$00(a0,d2.w)	;31802000
	move.w	d7,$02(a0,d2.w)	;31872002
	rts	;4E75

adrCd001DE0:
	bsr.s	adrCd001DBC	;61DA
	swap	d7	;4847
	move.b	$01(a6,d0.w),d5	;1A360001
	bpl.s	adrCd001DBA	;6AD0
	and.w	#$0007,d5	;02450007
	subq.w	#$01,d5	;5345
	beq.s	adrCd001DBA	;67C8
	movem.l	d0-d7/a0-a6,-(sp)	;48E7FFFE
	bsr	adrCd0098A4	;61007AAC
	bcs.s	adrCd001E08	;650C
	movem.l	(sp)+,d0-d7/a0-a6	;4CDF7FFF
	bclr	#$07,$01(a6,d0.w)	;08B600070001
	bra.s	adrCd001DBA	;60B2

adrCd001E08:
	tst.b	d0	;4A00
	bpl.s	adrCd001E28	;6A1C
	swap	d7	;4847
	move.b	d7,d5	;1A07
	swap	d7	;4847
	lsr.b	#$02,d5	;E40D
	cmpi.b	#$03,d5	;0C050003
	beq.s	adrCd001E28	;670E
	cmpi.b	#$0B,d5	;0C05000B
	bcc.s	adrCd001E28	;6408
	moveq	#$04,d0	;7004
	jsr	PlaySound.l	;4EB9000088BE
adrCd001E28:
	movem.l	(sp)+,d0-d7/a0-a6	;4CDF7FFF
	move.b	d7,d5	;1A07
	and.w	#$007F,d5	;0245007F
	move.w	d5,adrW_0020F4.l	;33C5000020F4
	tst.b	d7	;4A07
	bmi.s	adrCd001E84	;6B48
	bsr.s	adrCd001E42	;6104
	bra	adrCd00230C	;600004CC

adrCd001E42:
	move.w	#$FFFF,adrW_00230A.l	;33FCFFFF0000230A
	move.w	d0,-(sp)	;3F00
	move.w	d7,d5	;3A07
	addq.w	#$01,d5	;5245
adrLp001E50:
	bsr	adrCd005556	;61003704
	add.w	d0,d5	;DA40
	dbra	d7,adrLp001E50	;51CFFFF8
	move.w	(sp)+,d0	;301F
	move.w	d5,-(sp)	;3F05
	cmpi.w	#$0100,d5	;0C450100
	bcs.s	adrCd001E68	;6504
	move.w	#$00FD,d5	;3A3C00FD
adrCd001E68:
	moveq	#$03,d1	;7203
	lea	adrEA002680.l,a0	;41F900002680
adrLp001E70:
	move.b	d5,$00(a0,d1.w)	;11851000
	dbra	d1,adrLp001E70	;51C9FFFA
	move.w	(sp)+,d5	;3A1F
	swap	d5	;4845
	move.w	#$FFFF,d5	;3A3CFFFF
	swap	d5	;4845
	rts	;4E75

adrCd001E84:
	swap	d7						;4847
	lsr.b	#$02,d7						;E40F
	cmpi.b	#$03,d7						;0C070003
	beq	adrCd001FD2					;67000144
	cmpi.b	#$0B,d7						;0C07000B
	beq	adrCd002086					;670001F0
	cmpi.b	#$0C,d7						;0C07000C
	beq	adrCd001F78					;670000DA
	cmpi.b	#$0F,d7						;0C07000F
	beq	adrCd001F4A					;670000A4
	cmpi.b	#$0E,d7						;0C07000E
	beq.s	adrCd001EB0					;6702
	rts							;4E75

adrCd001EB0:
	bsr	adrCd0098A4	;610079F2
	bcc.s	adrCd001EDA	;6424
	tst.b	d0	;4A00
	bmi.s	adrCd001F0C	;6B52
	cmpi.b	#$10,d0	;0C000010
	bcs.s	adrCd001EDC	;651C
	move.b	$0007(a1),d5	;1A290007
	and.b	#$7F,d5	;0205007F
	lsr.b	#$01,d5	;E20D
	move.b	d5,$0007(a1)	;13450007
	bsr	adrCd0020F6	;61000226
	tst.w	d5	;4A45
	beq.s	adrCd001EDA	;6704
	clr.b	$0007(a1)	;42290007
adrCd001EDA:
	rts	;4E75

adrCd001EDC:
	clr.b	$0011(a1)	;42290011
	move.w	adrW_0020F4.l,d5	;3A39000020F4
	bsr	adrCd0020F8	;61000210
	move.b	$0009(a1),d1	;12290009
	sub.b	d5,d1	;9205
	bcc.s	adrCd001EF4	;6402
	moveq	#$00,d1	;7200
adrCd001EF4:
	move.b	d1,$0009(a1)	;13410009
	move.b	$0015(a1),d1	;12290015
	add.b	d5,d1	;D205
	cmpi.b	#$64,d1	;0C010064
	bcs.s	adrCd001F06	;6502
	moveq	#$64,d1	;7264
adrCd001F06:
	move.b	d1,$0015(a1)	;13410015
	rts	;4E75

adrCd001F0C:
	moveq	#$03,d7	;7E03
	moveq	#$05,d0	;7005
	jsr	PlaySound.l	;4EB9000088BE
adrLp001F16:
	moveq	#$00,d0	;7000
	move.b	$18(a1,d7.w),d0	;10317018
	move.w	d0,d1	;3200
	and.w	#$00E0,d0	;024000E0
	bne.s	adrCd001F36	;6612
	and.w	#$000F,d1	;0241000F
	move.w	d1,d0	;3001
	bsr	adrCd006660	;61004734
	move.w	d1,d0	;3001
	exg	a1,a4	;C949
	bsr.s	adrCd001EDC	;61A8
	exg	a1,a4	;C949
adrCd001F36:
	dbra	d7,adrLp001F16	;51CFFFDE
	move.l	a5,-(sp)	;2F0D
	move.l	a1,a5	;2A49
	bsr	adrCd007B50	;61005C10
	bsr	adrCd0081CE	;6100628A
	move.l	(sp)+,a5	;2A5F
	rts	;4E75

adrCd001F4A:
	bsr	adrCd0098A4	;61007958
	bcc.s	adrCd001F76	;6426
adrCd001F50:
	moveq	#$19,d4	;7819
	tst.b	d0	;4A00
	bmi.s	adrCd001F76	;6B20
	cmpi.b	#$10,d0	;0C000010
	bcs.s	adrCd001F5E	;6502
	moveq	#$03,d4	;7803
adrCd001F5E:
	and.b	#$F0,$00(a1,d4.w)	;023100F04000
	bsr	adrCd00208C	;61000126
	bclr	#$06,$03(a1,d4.w)	;08B100064003
	beq.s	adrCd001F76	;6706
	bset	#$05,$03(a1,d4.w)	;08F100054003
adrCd001F76:
	rts	;4E75

adrCd001F78:
	bsr	adrCd0098A4	;6100792A
	bcc.s	adrCd001FA0	;6422
	moveq	#$16,d4	;7816
	tst.b	d0	;4A00
	bmi.s	adrCd001FA2	;6B1E
	cmpi.b	#$10,d0	;0C000010
	bcs.s	adrCd001F8C	;6502
	moveq	#$00,d4	;7800
adrCd001F8C:
	bsr	adrCd0020F6	;61000168
	tst.w	d5	;4A45
	beq.s	adrCd001FA0	;670C
	bset	#$07,$05(a1,d4.w)	;08F100074005
	or.b	#$0F,$03(a1,d4.w)	;0031000F4003
adrCd001FA0:
	rts	;4E75

adrCd001FA2:
	moveq	#$03,d7	;7E03
	moveq	#$05,d0	;7005
	jsr	PlaySound.l	;4EB9000088BE
adrLp001FAC:
	moveq	#$00,d0	;7000
	move.b	$18(a1,d7.w),d0	;10317018
	move.w	d0,d1	;3200
	and.w	#$00E0,d0	;024000E0
	bne.s	adrCd001FCC	;6612
	and.w	#$000F,d1	;0241000F
	move.w	d1,d0	;3001
	bsr	adrCd006660	;6100469E
	move.w	d1,d0	;3001
	exg	a1,a4	;C949
	bsr.s	adrCd001F8C	;61C2
	exg	a1,a4	;C949
adrCd001FCC:
	dbra	d7,adrLp001FAC	;51CFFFDE
	rts	;4E75

adrCd001FD2:
	move.w	#$FFFF,adrW_00230A.l	;33FCFFFF0000230A
	movem.w	d0/d1,-(sp)	;48A7C000
	moveq	#-$01,d5	;7AFF
	bsr	adrCd0098A4	;610078C2
	bcc.s	adrCd00203E	;6458
	move.w	d0,-(sp)	;3F00
	bsr.s	adrCd002024	;613A
	move.w	(sp),d0	;3017
	tst.b	d0	;4A00
	bmi.s	adrCd002010	;6B20
	cmpi.b	#$10,d0	;0C000010
	bcs.s	adrCd002014	;651E
	addq.w	#$02,sp	;544F
	move.b	$0006(a1),d7	;1E290006
	lsr.b	#$02,d7	;E40F
	beq.s	adrCd00201C	;671C
	move.w	d0,-(sp)	;3F00
	subq.b	#$01,d7	;5307
	beq.s	adrCd002014	;670E
	subq.b	#$01,d7	;5307
	beq.s	adrCd002010	;6706
	bsr	adrCd0020F8	;610000EC
	move.w	(sp),d0	;3017
adrCd002010:
	bsr	adrCd0020F8	;610000E6
adrCd002014:
	movem.w	(sp)+,d0	;4C9F0001
	bsr	adrCd0020F8	;610000DE
adrCd00201C:
	movem.w	(sp)+,d0/d1	;4C9F0003
	bra	adrCd00230C	;600002EA

adrCd002024:
	tst.b	d0	;4A00
	bmi.s	adrCd00204A	;6B22
	cmpi.b	#$10,d0	;0C000010
	bcs.s	adrCd002040	;6512
	clr.w	d5	;4245
	cmp.b	#$15,$0006(a1)	;0C2900150006
	bcc.s	adrCd00203E	;6406
	move.w	$0008(a1),d5	;3A290008
	addq.w	#$01,d5	;5245
adrCd00203E:
	rts	;4E75

adrCd002040:
	clr.w	d5	;4245
	move.b	$0005(a1),d5	;1A290005
	addq.b	#$01,d5	;5205
	rts	;4E75

adrCd00204A:
	moveq	#$05,d0	;7005
	jsr	PlaySound.l	;4EB9000088BE
	moveq	#$01,d2	;7401
	lea	adrEA002680.l,a0	;41F900002680
	clr.l	(a0)	;4290
	move.l	a4,-(sp)	;2F0C
	moveq	#$03,d7	;7E03
adrLp002060:
	moveq	#$00,d0	;7000
	move.b	$18(a1,d7.w),d0	;10317018
	and.w	#$00E0,d0	;024000E0
	bne.s	adrCd00207E	;6612
	move.b	$18(a1,d7.w),d0	;10317018
	bsr	adrCd006660	;610045EE
	move.b	$0005(a4),$00(a0,d7.w)	;11AC00057000
	addq.b	#$01,$00(a0,d7.w)	;52307000
adrCd00207E:
	dbra	d7,adrLp002060	;51CFFFE0
	move.l	(sp)+,a4	;285F
adrCd002084:
	rts	;4E75

adrCd002086:
	bsr	adrCd0098A4	;6100781C
	bcc.s	adrCd002084	;64F8
adrCd00208C:
	tst.b	d0	;4A00
	bmi.s	adrCd0020D6	;6B46
	moveq	#$18,d4	;7818
	cmpi.b	#$10,d0	;0C000010
	bcs.s	adrCd0020A0	;6508
	tst.b	$000B(a1)	;4A29000B
	bmi.s	adrCd0020D4	;6B36
	moveq	#$02,d4	;7802
adrCd0020A0:
	move.b	$00(a1,d4.w),d7	;1E314000
	bsr.s	adrCd0020B8	;6112
	cmp.b	$00(a1,d4.w),d7	;BE314000
	beq.s	adrCd0020D4	;6728
	move.b	d7,$00(a1,d4.w)	;13874000
	bset	#$06,$03(a1,d4.w)	;08F100064003
	rts	;4E75

adrCd0020B8:
	move.w	d0,d6	;3C00
	bsr	adrCd0020F6	;6100003A
	tst.w	d5	;4A45
	beq.s	adrCd0020D4	;6712
	eor.b	#$02,d7	;0A070002
	move.w	d6,d0	;3006
	bsr	adrCd0020F6	;6100002C
	tst.w	d5	;4A45
	bne.s	adrCd0020D4	;6604
	eor.b	#$01,d7	;0A070001
adrCd0020D4:
	rts	;4E75

adrCd0020D6:
	bsr	adrCd00665C	;61004584
	moveq	#$05,d0	;7005
	jsr	PlaySound.l	;4EB9000088BE
	exg	a4,a1	;C34C
	move.w	$0006(a4),d0	;302C0006
	move.w	$0020(a4),d7	;3E2C0020
	bsr.s	adrCd0020B8	;61CA
	move.w	d7,$0020(a4)	;39470020
	rts	;4E75

adrW_0020F4:
	dc.w	$0000	;0000

adrCd0020F6:
	moveq	#$01,d5	;7A01
adrCd0020F8:
	tst.b	d0	;4A00
	bmi.s	adrCd00212E	;6B32
	cmpi.b	#$10,d0	;0C000010
	bcs.s	adrCd002128	;6526
	move.b	$0006(a1),d2	;14290006
	and.w	#$007F,d2	;0242007F
adrCd00210A:
	asl.w	#$03,d2	;E742
	add.w	#$0064,d2	;06420064
	move.w	adrW_0020F4.w,d0	;303820F4	;Short Absolute converted to symbol!
	add.w	d0,d0	;D040
	sub.w	d0,d2	;9440
	bpl.s	adrCd00211C	;6A02
	moveq	#$0A,d2	;740A
adrCd00211C:
	bsr	RandomGen_BytewithOffset	;6100348E
	cmp.w	d0,d2	;B440
	bcs.s	adrCd002126	;6502
	lsr.w	#$01,d5	;E24D
adrCd002126:
	rts	;4E75

adrCd002128:
	moveq	#$00,d2	;7400
	move.b	(a1),d2	;1411
	bra.s	adrCd00210A	;60DC

adrCd00212E:
	moveq	#$06,d1	;7206
	movem.l	a4/a5,-(sp)	;48E7000C
	move.l	a1,a5	;2A49
	bsr	adrCd005500	;610033C8
	movem.l	(sp)+,a4/a5	;4CDF3000
	tst.w	d3	;4A43
	bmi.s	adrCd00216A	;6B28
	move.w	#$FF80,adrW_0020F4.w	;31FCFF8020F4	;Short Absolute converted to symbol!
	move.w	d3,-(sp)	;3F03
	bsr.s	adrCd00216A	;611E
	move.w	(sp)+,d3	;361F
	move.w	d3,d7	;3E03
	addq.w	#$02,d3	;5443
	asl.w	#$03,d3	;E743
	neg.w	d3	;4443
	move.w	d3,adrW_0020F4.w	;31C320F4	;Short Absolute converted to symbol!
	lsr.w	#$02,d7	;E44F
	addq.w	#$01,d7	;5247
adrLp00215E:
	move.w	d7,-(sp)	;3F07
	bsr.s	adrCd00216A	;6108
	move.w	(sp)+,d7	;3E1F
	dbra	d7,adrLp00215E	;51CFFFF8
	rts	;4E75

adrCd00216A:
	lea	adrEA002680.l,a0	;41F900002680
	move.l	a4,-(sp)	;2F0C
	clr.w	d5	;4245
	moveq	#$03,d7	;7E03
adrLp002176:
	move.b	$18(a1,d7.w),d0	;10317018
	bsr	adrCd006660	;610044E4
	move.b	$00(a0,d7.w),d5	;1A307000
	exg	a1,a4	;C949
	bsr.s	adrCd002128	;61A2
	exg	a1,a4	;C949
	move.b	d5,$00(a0,d7.w)	;11857000
	dbra	d7,adrLp002176	;51CFFFE8
	move.l	(sp)+,a4	;285F
adrCd002192:
	rts	;4E75

adrCd002194:
	move.b	$000B(a1),d0	;1029000B
	bmi.s	adrCd002192	;6BF8
	sub.b	#$64,d0	;04000064
	beq.s	adrCd002192	;67F2
	move.b	adrB_00EE3E.l,d0	;10390000EE3E
	cmpi.b	#$10,d0	;0C000010
	bcc.s	adrCd002192	;64E6
	bsr	adrCd006660	;610044B2
	cmp.b	#$EC,$001C(a4)	;0C2C00EC001C
	bcc.s	adrCd0021EC	;6434
	move.w	$001C(a4),d2	;342C001C
	move.w	d5,d1	;3205
	cmp.w	$0008(a1),d1	;B2690008
	bcs.s	adrCd0021CA	;6506
	move.w	$0008(a1),d1	;32290008
	addq.w	#$01,d1	;5241
adrCd0021CA:
	tst.w	MultiPlayer.l	;4A790000EE30
	beq.s	adrCd0021D6	;6704
	addq.w	#$01,d1	;5241
	lsr.w	#$01,d1	;E249
adrCd0021D6:
	sub.w	d1,d2	;9441
	bcs.s	adrCd0021E4	;650A
	cmp.b	#$09,$0006(a1)	;0C2900090006
	bcc.s	adrCd0021E4	;6402
	sub.w	d1,d2	;9441
adrCd0021E4:
	move.w	d2,$001C(a4)	;3942001C
	bsr	adrCd002258	;6100006E
adrCd0021EC:
	move.l	a5,a2	;244D
	move.b	adrB_00EE3E.l,d0	;10390000EE3E
	and.w	#$000F,d0	;0240000F
	bsr	adrCd004066	;61001E6C
	exg	a5,a2	;C54D
	tst.w	d1	;4A41
	bmi.s	adrCd002192	;6B90
	move.w	$0008(a1),d1	;32290008
	sub.w	d5,d1	;9245
	bcc.s	adrCd002256	;644C
	move.b	$0006(a1),d1	;12290006
	and.w	#$007F,d1	;0241007F
	moveq	#$03,d7	;7E03
adrLp002214:
	move.b	$18(a2,d7.w),d0	;10327018
	and.w	#$00E0,d0	;024000E0
	bne.s	adrCd002252	;6634
	move.b	$18(a2,d7.w),d0	;10327018
	bsr	adrCd006660	;6100443C
	move.b	$001C(a4),d0	;102C001C
	cmpi.b	#$EC,d0	;0C0000EC
	bcc.s	adrCd002252	;6422
	moveq	#$00,d2	;7400
	move.b	d1,d2	;1401
	sub.b	(a4),d2	;9414
	addq.b	#$02,d2	;5402
	bmi.s	adrCd002252	;6B18
	asl.w	#$07,d2	;EF42
	move.w	$001C(a4),d0	;302C001C
	tst.w	MultiPlayer.l	;4A790000EE30
	bne.s	adrCd00224A	;6602
	add.w	d2,d2	;D442
adrCd00224A:
	sub.w	d2,d0	;9042
	move.w	d0,$001C(a4)	;3940001C
	bsr.s	adrCd002258	;6106
adrCd002252:
	dbra	d7,adrLp002214	;51CFFFC0
adrCd002256:
	rts	;4E75

adrCd002258:
	tst.b	$001E(a4)	;4A2C001E
	bmi.s	adrCd002296	;6B38
	moveq	#$00,d2	;7400
	move.b	(a4),d2	;1414
	lea	adrEA004B1A.l,a0	;41F900004B1A
	move.b	$00(a0,d2.w),d3	;16302000
	lsr.b	#$01,d3	;E20B
	cmp.b	$001C(a4),d3	;B62C001C
	bcs.s	adrCd002296	;6522
	move.l	a4,d3	;260C
	sub.l	#CharacterStats,d3	;04830000EB2A
	lsr.b	#$05,d3	;EA0B
	and.w	#$0003,d3	;02430003
	beq.s	adrCd00228A	;6706
	cmpi.w	#$0003,d3	;0C430003
	bcs.s	adrCd002290	;6506
adrCd00228A:
	btst	#$00,d2	;08020000
	bne.s	adrCd002296	;6606
adrCd002290:
	add.b	#$81,$001E(a4)	;062C0081001E
adrCd002296:
	rts	;4E75

adrCd002298:
	swap	d5	;4845
	clr.w	d5	;4245
	swap	d5	;4845
	cmpi.w	#$0010,d0	;0C400010
	bcs.s	adrCd0022CA	;6526
	move.w	d0,d1	;3200
	sub.w	#$0010,d0	;04400010
	asl.w	#$04,d0	;E940
	lea	UnpackedMonsters.l,a1	;43F900016B7E
	add.w	d0,a1	;D2C0
	moveq	#$00,d7	;7E00
	move.b	$0000(a1),d7	;1E290000
	swap	d7	;4847
	move.b	$0001(a1),d7	;1E290001
	bsr	CoordToMap	;610061DA
	move.w	d0,d4	;3800
	move.w	d1,d0	;3001
	bra.s	adrCd002324	;605A

adrCd0022CA:
	move.w	d0,d3	;3600
	bsr	adrCd006660	;61004392
	move.l	a4,a1	;224C
	moveq	#$00,d7	;7E00
	move.b	$0016(a1),d7	;1E290016
	bpl.s	adrCd0022F8	;6A1E
	move.w	d3,d0	;3003
	bsr	adrCd004066	;61001D88
	tst.w	d1	;4A41
	bmi	adrCd001DBA	;6B00FAD6
	move.l	a5,a1	;224D
	lea	adrEA002680.l,a0	;41F900002680
	clr.l	(a0)	;4290
	move.b	d5,$00(a0,d1.w)	;11851000
	bra	adrCd00248C	;60000196

adrCd0022F8:
	swap	d7	;4847
	move.b	$0017(a1),d7	;1E290017
	bsr	CoordToMap	;6100619C
	move.w	d0,d4	;3800
	move.w	d3,d0	;3003
	bra	adrCd002414	;6000010C

adrW_00230A:
	dc.w	$0000	;0000

adrCd00230C:
	move.w	d0,d4	;3800
	bsr	adrCd0098A4	;61007594
	bcs.s	adrCd002316	;6502
	rts	;4E75

adrCd002316:
	tst.b	d0	;4A00
	bmi	adrCd00248C	;6B000172
	cmpi.w	#$0010,d0	;0C400010
	bcs	adrCd002414	;650000F2
adrCd002324:
	tst.w	adrW_00230A.w	;4A78230A	;Short Absolute converted to symbol!
	beq.s	adrCd002374	;674A
	moveq	#$00,d1	;7200
	move.b	$000D(a1),d1	;1229000D
	bmi.s	adrCd002374	;6B42
	asl.w	#$02,d1	;E541
	lea	adrEA017390.l,a0	;41F900017390
	add.w	d1,a0	;D0C1
	moveq	#$03,d7	;7E03
adrLp00233E:
	moveq	#$00,d1	;7200
	move.b	$00(a0,d7.w),d1	;12307000
	bmi.s	adrCd002360	;6B1A
	move.w	d1,d0	;3001
	add.w	#$0010,d0	;06400010
	asl.w	#$04,d1	;E941
	lea	UnpackedMonsters.l,a1	;43F900016B7E
	add.w	d1,a1	;D2C1
	movem.l	d4/d5/d7/a0/a6,-(sp)	;48E70D82
	bsr.s	adrCd002374	;6118
	movem.l	(sp)+,d4/d5/d7/a0/a6	;4CDF41B0
adrCd002360:
	dbra	d7,adrLp00233E	;51CFFFDC
	cmp.l	#$FFFFFFFF,(a0)	;0C90FFFFFFFF
	beq.s	adrCd002394	;6728
	bset	#$07,$01(a6,d4.w)	;08F600074001
	rts	;4E75

adrCd002374:
	movem.w	d0/d4,-(sp)	;48A78800
	tst.l	d5	;4A85
	bpl.s	adrCd002380	;6A04
	bsr	adrCd0020F8	;6100FD7A
adrCd002380:
	bsr	adrCd002194	;6100FE12
	movem.w	(sp)+,d0/d4	;4C9F0011
	move.w	$0008(a1),d1	;32290008
	sub.w	d5,d1	;9245
	bcs.s	adrCd002396	;6506
	move.w	d1,$0008(a1)	;33410008
adrCd002394:
	rts	;4E75

adrCd002396:
	moveq	#$00,d2	;7400
	move.b	$000C(a1),d2	;1429000C
	swap	d2	;4842
	move.b	$000B(a1),d2	;1429000B
	move.l	d2,-(sp)	;2F02
	bsr	adrCd0027F0	;6100044A
	move.w	d4,d0	;3004
	moveq	#$01,d7	;7E01
	bsr	adrCd001DBC	;6100FA0E
	move.l	(sp)+,d2	;241F
	tst.b	d2	;4A02
	bmi.s	adrCd002394	;6BDE
	moveq	#$01,d5				;7A01
	swap	d5				;4845
	cmpi.b	#$64,d2				;0C020064
	beq.s	adrCd002394			;67D4
	move.w	#$0056,d5			;3A3C0056
	cmpi.b	#$6B,d2				;0C02006B
	beq.s	adrCd0023F6			;672C
	cmpi.b	#$40,d2				;0C020040
	bne.s	adrCd0023D6			;6606
	swap	d2				;4842
	move.w	d2,d5				;3A02
	bra.s	adrCd0023F6			;6020

adrCd0023D6:
	bsr	RandomGen_BytewithOffset			;610031D4
	and.w	#$000F,d0			;0240000F
	move.b	adrB_002404(pc,d0.w),d5		;1A3B0024
	beq.s	adrCd002394			;67B0
	cmpi.w	#$0005,d5			;0C450005
	bcc.s	adrCd0023F6			;640C
	bsr	RandomGen_BytewithOffset			;610031C0
	and.w	#$0007,d0			;02400007
	swap	d0				;4840
	add.l	d0,d5				;DA80
adrCd0023F6:
	move.w	d4,d0	;3004
	move.l	adrL_00EE78.l,a6	;2C790000EE78
	moveq	#$00,d6	;7C00
	bra	adrCd005E88	;60003A86

adrB_002404:
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

adrCd002414:
	tst.l	d5	;4A85
	bpl.s	adrCd002420	;6A08
	move.w	d0,-(sp)	;3F00
	bsr	adrCd0020F8	;6100FCDC
	move.w	(sp)+,d0	;301F
adrCd002420:
	moveq	#$00,d1	;7200
	move.b	$0005(a1),d1	;12290005
	sub.w	d5,d1	;9245
	bcs.s	adrCd002430	;6506
	move.b	d1,$0005(a1)	;13410005
	rts	;4E75

adrCd002430:
	clr.b	$0005(a1)	;42290005
	clr.b	$0007(a1)	;42290007
	move.l	a5,-(sp)	;2F0D
	bsr	adrCd004066	;61001C2A
	tst.w	d1	;4A41
	bmi.s	adrCd002460	;6B1E
	bset	#$06,$18(a5,d1.w)	;08F500061018
	tst.w	$0042(a5)	;4A6D0042
	bpl.s	adrCd002460	;6A12
	movem.l	d4/a1,-(sp)	;48E70840
	move.w	d1,d7	;3E01
	bsr	adrCd007EF0	;61005A9A
	bsr	adrCd007ED2	;61005A78
	movem.l	(sp)+,d4/a1	;4CDF0210
adrCd002460:
	move.l	(sp)+,a5	;2A5F
	move.b	#$FF,$0016(a1)	;137C00FF0016
	move.l	adrL_00EE78.l,a6	;2C790000EE78
	move.w	d4,d0	;3004
	bclr	#$07,$01(a6,d0.w)	;08B600070001
	move.l	a1,d5	;2A09
	sub.l	#CharacterStats,d5	;04850000EB2A
	lsr.w	#$05,d5	;EA4D
	add.l	#$10040,d5	;068500010040
	moveq	#$00,d6	;7C00
	bra	adrCd005E88	;600039FE

adrCd00248C:
	or.b	#$0F,$003E(a1)	;0029000F003E
	bclr	#$02,(a1)	;08910002
	beq.s	adrCd00249C	;6704
	clr.w	$0014(a1)	;42690014
adrCd00249C:
	tst.l	d5	;4A85
	bpl.s	adrCd0024A6	;6A06
	moveq	#-$01,d0	;70FF
	bsr	adrCd0020F8	;6100FC54
adrCd0024A6:
	moveq	#$03,d1	;7203
	lea	adrEA002680.l,a0	;41F900002680
adrLp0024AE:
	move.b	$18(a1,d1.w),d0	;10311018
	and.w	#$00E0,d0	;024000E0
	beq.s	adrCd0024BE	;6706
	clr.b	$00(a0,d1.w)	;42301000
	bra.s	adrCd0024F2	;6034

adrCd0024BE:
	move.b	$18(a1,d1.w),d0	;10311018
	bsr	adrCd006660	;6100419C
	move.b	$0005(a4),d0	;102C0005
	sub.b	$00(a0,d1.w),d0	;90301000
	bcc.s	adrCd0024EE	;641E
	or.b	#$40,$18(a1,d1.w)	;003100401018
	clr.b	$0011(a4)	;422C0011
	move.b	#$FF,$0013(a4)	;197C00FF0013
	move.l	a0,-(sp)	;2F08
	moveq	#$03,d0	;7003
	jsr	PlaySound.l	;4EB9000088BE
	move.l	(sp)+,a0	;205F
	moveq	#$00,d0	;7000
adrCd0024EE:
	move.b	d0,$0005(a4)	;19400005
adrCd0024F2:
	dbra	d1,adrLp0024AE	;51C9FFBA
	move.l	a5,-(sp)	;2F0D
	move.l	a1,a5	;2A49
	moveq	#$03,d1	;7203
adrLp0024FC:
	move.b	$18(a5,d1.w),d0	;10351018
	bmi.s	adrCd002520	;6B1E
	btst	#$06,d0	;08000006
	beq.s	adrCd002520	;6718
	btst	#$05,d0	;08000005
	bne.s	adrCd002520	;6612
	and.w	#$000F,d0	;0240000F
	bsr	adrCd004092	;61001B7E
	tst.w	d2	;4A42
	bmi.s	adrCd002520	;6B06
	move.b	#$FF,$26(a5,d2.w)	;1BBC00FF2026
adrCd002520:
	dbra	d1,adrLp0024FC	;51C9FFDA
	btst	#$06,$0018(a5)	;082D00060018
	bne.s	adrCd002534	;6608
	bsr	adrCd008246	;61005D18
	bra	adrCd00260A	;600000D8

adrCd002534:
	moveq	#$00,d1	;7200
	moveq	#$00,d0	;7000
adrCd002538:
	move.b	$18(a5,d1.w),d0	;10351018
	and.w	#$00E0,d0	;024000E0
	bne.s	adrCd002576	;6634
	move.b	$18(a5,d1.w),d0	;10351018
	and.w	#$000F,d0	;0240000F
	move.b	$0018(a5),$18(a5,d1.w)	;1BAD00181018
	move.b	d0,$0018(a5)	;1B400018
	bset	#$04,$0018(a5)	;08ED00040018
	move.w	d0,$0006(a5)	;3B400006
	bsr.s	adrCd002564	;6104
	bra	adrCd0025FE	;6000009C

adrCd002564:
	lea	adrEA002680.l,a0	;41F900002680
	move.b	(a0),d0	;1010
	move.b	$00(a0,d1.w),(a0)	;10B01000
	move.b	d0,$00(a0,d1.w)	;11801000
	rts	;4E75

adrCd002576:
	addq.w	#$01,d1	;5241
	cmpi.w	#$0004,d1	;0C410004
	bcs.s	adrCd002538	;65BA
	and.b	#$01,(a5)	;02150001
	moveq	#$03,d1	;7203
adrLp002584:
	move.b	$18(a5,d1.w),d0	;10351018
	btst	#$05,d0	;08000005
	beq.s	adrCd002594	;6706
	btst	#$06,d0	;08000006
	beq.s	adrCd00259A	;6706
adrCd002594:
	dbra	d1,adrLp002584	;51C9FFEE
	bra.s	adrCd0025EE	;6054

adrCd00259A:
	move.b	$0018(a5),$18(a5,d1.w)	;1BAD00181018
	move.b	d0,$0018(a5)	;1B400018
	bset	#$04,$0018(a5)	;08ED00040018
	and.w	#$000F,d0	;0240000F
	move.w	d0,$0006(a5)	;3B400006
	bsr.s	adrCd002564	;61B0
	bsr	adrCd002628	;61000072
	bclr	#$05,$0018(a5)	;08AD00050018
	bsr	adrCd00665C	;6100409C
	move.b	$0016(a4),$001D(a5)	;1B6C0016001D
	move.b	$0017(a4),$001F(a5)	;1B6C0017001F
	move.b	$001A(a4),$0059(a5)	;1B6C001A0059
	move.b	$0018(a4),$0021(a5)	;1B6C00180021
	move.b	#$FF,$0016(a4)	;197C00FF0016
	move.b	$0018(a5),$0026(a5)	;1B6D00180026
	and.b	#$0F,$0026(a5)	;022D000F0026
	bra.s	adrCd0025FE	;6010

adrCd0025EE:
	bsr.s	adrCd002628	;6138
	move.b	#$FF,$001D(a5)	;1B7C00FF001D
	bsr	adrCd00270E	;61000116
	and.b	#$01,(a5)	;02150001
adrCd0025FE:
	clr.w	$0014(a5)	;426D0014
	clr.b	$003E(a5)	;422D003E
	bsr	adrCd008278	;61005C70
adrCd00260A:
	move.w	#$FFFF,$0042(a5)	;3B7CFFFF0042
	move.w	#$FFFF,$0040(a5)	;3B7CFFFF0040
	move.b	#$FF,$0035(a5)	;1B7C00FF0035
	bsr	adrCd007EC0	;610058A2
	bsr	adrCd002662	;61000040
	move.l	(sp)+,a5	;2A5F
	rts	;4E75

adrCd002628:
	bsr	adrCd008498	;61005E6E
	bclr	#$07,$01(a6,d0.w)	;08B600070001
	moveq	#$03,d1	;7203
adrLp002634:
	moveq	#$01,d5	;7A01
	swap	d5	;4845
	move.b	$18(a5,d1.w),d5	;1A351018
	bmi.s	adrCd00265C	;6B1E
	bset	#$05,$18(a5,d1.w)	;08F500051018
	bne.s	adrCd00265C	;6616
	and.w	#$000F,d5	;0245000F
	add.w	#$0040,d5	;06450040
	moveq	#$00,d6	;7C00
	movem.l	d0/d1,-(sp)	;48E7C000
	bsr	adrCd005E88	;61003832
	movem.l	(sp)+,d0/d1	;4CDF0003
adrCd00265C:
	dbra	d1,adrLp002634	;51C9FFD6
	rts	;4E75

adrCd002662:
	moveq	#$03,d7	;7E03
adrLp002664:
	move.b	$18(a5,d7.w),d0	;10357018
	bmi.s	adrCd00267A	;6B10
	moveq	#$00,d0	;7000
	move.b	adrEA002680(pc,d7.w),d0	;103B7012
	beq.s	adrCd00267A	;6708
	move.w	d7,-(sp)	;3F07
	bsr	adrCd002684	;6100000E
	move.w	(sp)+,d7	;3E1F
adrCd00267A:
	dbra	d7,adrLp002664	;51CFFFE8
	rts	;4E75

adrEA002680:
	dc.w	$0000	;0000
	dc.w	$0000	;0000

adrCd002684:
	move.w	d0,-(sp)		;3F00
	move.l	#$000D000C,adrW_00D92A.l	;23FC000D000C0000D92A
	lea	_GFX_Pockets+$7688.l,a1	;43F900053D8A
	move.b	#$07,$5A(a5,d7.w)	;1BBC0007705A
	move.w	d7,d0			;3007
	move.l	#$1000A,d7		;2E3C0001000A
	add.w	d0,d0			;D040
	add.w	d0,d0			;D040
	move.w	adrW_0026FE(pc,d0.w),d4	;383B0054
	move.w	adrW_002700(pc,d0.w),d5	;3A3B0052
	add.w	$0008(a5),d5		;DA6D0008
	movem.l	d4/d5,-(sp)		;48E70C00
	moveq	#$00,d6			;7C00
	jsr	adrCd00AE66.l		;4EB90000AE66
	movem.l	(sp)+,d4/d5		;4CDF0030
	move.w	(sp)+,d0		;301F
	addq.w	#$04,d4			;5844
	addq.w	#$03,d5			;5645
	lea	NumHitsMsg.l,a6		;4DF900006174
	moveq	#$00,d2			;7400
	bsr	adrCd006178		;61003AA4
	moveq	#$08,d0			;7008
	move.w	d2,d1			;3202
	beq.s	adrCd0026E4		;6708
	subq.w	#$04,d0			;5940
	subq.w	#$01,d2			;5342
	beq.s	adrCd0026E4		;6702
	subq.w	#$04,d0			;5940
adrCd0026E4:
	add.w	d0,d4	;D840
adrLp0026E6:
	move.b	(a6)+,d0		;101E
	movem.l	d1/d4/d5/a6,-(sp)	;48E74C02
	jsr	Draw_woundflash_digit.l		;4EB90000D92E
	movem.l	(sp)+,d1/d4/d5/a6	;4CDF4032
	addq.w	#$08,d4			;5044
	dbra	d1,adrLp0026E6		;51C9FFEC
	rts	;4E75

adrW_0026FE:
	dc.w	$000B	;000B
adrW_002700:
	dc.w	$0013	;0013
	dc.w	$0000	;0000
	dc.w	$0040	;0040
	dc.w	$0020	;0020
	dc.w	$0040	;0040
	dc.w	$0040	;0040
	dc.w	$0040	;0040

adrCd00270E:
	bsr.s	adrCd002734		;6124
	lea	ThouArtDead.l,a6	;4DF90000271C
	jmp	Print_fflim_text.l		;4EF90000D0C6

ThouArtDead:
	dc.b	$FC		;FC
	dc.b	$12		;12
	dc.b	$04		;04
	dc.b	$FE		;FE
	dc.b	$04		;04
	dc.b	$FD		;FD
	dc.b	$00		;00
	dc.b	'THOU'		;54484F55
	dc.b	$FC		;FC
	dc.b	$10		;10
	dc.b	$06		;06
	dc.b	'ART DEAD'	;4152542044454144
	dc.b	$FF		;FF
	dc.b	$00		;00

adrCd002734:
	or.b	#$40,$0054(a5)	;002D00400054
	moveq	#$00,d3	;7600
	bsr	adrCd008FA4	;61006866
	move.l	#$004B000C,d5	;2A3C004B000C
	add.w	$0008(a5),d5	;DA6D0008
	move.l	#$007F0060,d4	;283C007F0060
	moveq	#$04,d3	;7604
	moveq	#$02,d2	;7402
	bra.s	adrCd002760	;600A

adrLp002756:
	add.w	d2,d5	;DA42
	swap	d5	;4845
	sub.w	d2,d5	;9A42
	subq.w	#$01,d5	;5345
	swap	d5	;4845
adrCd002760:
	movem.l	d2-d5,-(sp)	;48E73C00
	jsr	BW_draw_frame.l	;4EB90000DAD4
	movem.l	(sp)+,d2-d5	;4CDF003C
	eor.w	#$0006,d3	;0A430006
	add.l	#$FFFE0001,d4	;0684FFFE0001
	dbra	d2,adrLp002756	;51CAFFDC
	rts	;4E75

adrCd00277E:
	movem.l	d0-d7/a0-a6,-(sp)	;48E7FFFE
	lea	UnpackedMonsters.l,a4	;49F900016B7E
	move.w	-$0002(a4),d6	;3C2CFFFE
adrLp00278C:
	move.w	d6,d0	;3006
	asl.w	#$04,d0	;E940
	lea	$00(a4,d0.w),a3	;47F40000
	move.b	$000B(a3),d0	;102B000B
	bmi.s	adrCd0027A0	;6B06
	cmpi.b	#$64,d0	;0C000064
	bne.s	adrCd0027C6	;6626
adrCd0027A0:
	moveq	#$00,d0	;7000
	move.b	$0004(a3),d0	;102B0004
	bsr	adrCd0084DA	;61005D32
	moveq	#$00,d7	;7E00
	move.b	$0000(a3),d7	;1E2B0000
	bmi.s	adrCd0027C6	;6B14
	swap	d7	;4847
	move.b	$0001(a3),d7	;1E2B0001
	bsr	CoordToMap	;61005CE2
	move.w	d0,d4	;3800
	move.w	d6,d0	;3006
	add.w	#$0010,d0	;06400010
	bsr.s	adrCd0027F0	;612A
adrCd0027C6:
	dbra	d6,adrLp00278C	;51CEFFC4
	movem.l	(sp),d0-d7/a0-a6	;4CD77FFF
	move.w	d2,d0	;3002
	bsr	adrCd0084FC	;61005D2A
	move.w	d1,d0	;3001
	bsr	adrCd0084DA	;61005D02
	movem.l	(sp)+,d0-d7/a0-a6	;4CDF7FFF
	rts	;4E75

adrCd0027E0:
	move.l	a4,d0	;200C
	sub.l	#UnpackedMonsters,d0	;048000016B7E
	lsr.w	#$04,d0	;E848
	add.w	#$0010,d0	;06400010
	bra.s	adrCd0027F6	;6006

adrCd0027F0:
	bclr	#$07,$01(a6,d4.w)	;08B600074001
adrCd0027F6:
	bsr.s	adrCd002848	;6150
	lea	UnpackedMonsters.l,a2	;45F900016B7E
	move.w	-$0002(a2),d2	;342AFFFE
	subq.w	#$01,-$0002(a2)	;536AFFFE
	sub.w	d0,d2	;9440
	asl.w	#$04,d0	;E940
	lea	$00(a2,d0.w),a2	;45F20000
	lea	$0010(a2),a3	;47EA0010
	bra.s	adrCd00281C	;6008

adrLp002814:
	move.l	(a3)+,(a2)+	;24DB
	move.l	(a3)+,(a2)+	;24DB
	move.l	(a3)+,(a2)+	;24DB
	move.l	(a3)+,(a2)+	;24DB
adrCd00281C:
	dbra	d2,adrLp002814	;51CAFFF6
	moveq	#-$01,d2	;74FF
	move.l	d2,(a2)+	;24C2
	move.l	d2,(a2)+	;24C2
	move.l	d2,(a2)+	;24C2
	move.l	d2,(a2)	;2482
adrCd00282A:
	rts	;4E75

adrCd00282C:
	tst.b	$0035(a0)	;4A280035
	bmi.s	adrCd00282A	;6BF8
	cmp.b	$0035(a0),d0	;B0280035
	bne.s	adrCd002840	;6608
	move.b	#$FF,$0035(a0)	;117C00FF0035
	rts	;4E75

adrCd002840:
	bcc.s	adrCd00282A	;64E8
	subq.b	#$01,$0035(a0)	;53280035
	rts	;4E75

adrCd002848:
	lea	Player1_Data.l,a0	;41F90000EE7C
	bsr.s	adrCd00282C	;61DC
	lea	Player2_Data.l,a0	;41F90000EEDE
	bsr.s	adrCd00282C	;61D4
	sub.w	#$0010,d0	;04400010
	lea	adrEA017390.l,a0	;41F900017390
	move.w	-$0002(a0),d2	;3428FFFE
	bmi.s	adrCd00282A	;6BC2
	move.w	d5,-(sp)	;3F05
adrLp00286A:
	movem.w	d0/d2,-(sp)	;48A7A000
	bsr.s	adrCd00287C	;610C
	movem.w	(sp)+,d0/d2	;4C9F0005
	dbra	d2,adrLp00286A	;51CAFFF4
	move.w	(sp)+,d5	;3A1F
	rts	;4E75

adrCd00287C:
	moveq	#$03,d3	;7603
	moveq	#$00,d2	;7400
adrLp002880:
	move.b	$00(a0,d3.w),d5	;1A303000
	bmi.s	adrCd002896	;6B10
	cmp.b	d5,d0	;B005
	bcs.s	adrCd002892	;6508
	bne.s	adrCd002896	;660A
	clr.b	$00(a0,d3.w)	;42303000
	moveq	#$01,d2	;7401
adrCd002892:
	subq.b	#$01,$00(a0,d3.w)	;53303000
adrCd002896:
	dbra	d3,adrLp002880	;51CBFFE8
	tst.w	d2	;4A42
	beq.s	adrCd0028B8	;671A
	lea	UnpackedMonsters.l,a2	;45F900016B7E
	asl.w	#$04,d0	;E940
	tst.b	$0D(a2,d0.w)	;4A32000D
	bmi.s	adrCd0028B8	;6B0C
	moveq	#$03,d3	;7603
adrLp0028AE:
	tst.b	$00(a0,d3.w)	;4A303000
	bpl.s	adrCd0028BC	;6A08
	dbra	d3,adrLp0028AE	;51CBFFF8
adrCd0028B8:
	addq.w	#$04,a0	;5848
	rts	;4E75

adrCd0028BC:
	bset	#$07,$01(a6,d4.w)	;08F600074001
	move.b	$00(a0,d3.w),d3	;16303000
	asl.w	#$04,d3	;E943
	cmp.w	d0,d3	;B640
	bcs.s	adrCd0028D0	;6504
	add.w	#$0010,d3	;06430010
adrCd0028D0:
	lea	$00(a2,d3.w),a3	;47F23000
	lea	$00(a2,d0.w),a2	;45F20000
	move.b	$0000(a2),$0000(a3)	;176A00000000
	move.b	$0001(a2),$0001(a3)	;176A00010001
	move.b	$0004(a2),$0004(a3)	;176A00040004
	move.b	$0002(a2),$0002(a3)	;176A00020002
	move.b	$000D(a2),$000D(a3)	;176A000D000D
	move.b	#$FF,$000D(a2)	;157C00FF000D
	move.b	#$FF,$0000(a2)	;157C00FF0000
	bra.s	adrCd0028B8	;60B4

adrCd002904:
	cmp.b	#$02,$0015(a5)	;0C2D00020015
	bne.s	adrCd00291A	;660E
	bsr	adrCd00665C	;61003D4E
	tst.b	$0013(a4)	;4A2C0013
	bmi.s	adrCd00291A	;6B04
	bsr	adrCd006720	;61003E08
adrCd00291A:
	bsr	adrCd0084D6	;61005BBA
	bsr	adrCd002BCE	;610002AE
	move.b	#$FF,$0034(a5)	;1B7C00FF0034
	moveq	#$03,d7	;7E03
adrLp00292A:
	moveq	#$00,d0	;7000
	move.b	$18(a5,d7.w),d0	;10357018
	move.w	d0,d3	;3600
	and.w	#$000F,d3	;0243000F
	and.w	#$00E0,d0	;024000E0
	beq.s	adrCd002960	;6724
	tst.b	$0050(a5)	;4A2D0050
	beq.s	adrCd00296C	;672A
	cmpi.b	#$20,d0	;0C000020
	bne.s	adrCd00296C	;6624
	move.w	d3,d0	;3003
	move.w	d7,-(sp)	;3F07
	bsr	adrCd006660	;61003D12
	moveq	#$16,d4	;7816
	move.w	#$FFFF,adrW_0013C4.w	;31FCFFFF13C4	;Short Absolute converted to symbol!
	bsr	adrCd0013C6	;6100EA6C
	move.w	(sp)+,d7	;3E1F
	bra.s	adrCd00296C	;600C

adrCd002960:
	move.w	d3,d0	;3003
	bsr	adrCd006660	;61003CFC
	move.w	d7,-(sp)	;3F07
	bsr.s	adrCd00299A	;6130
	move.w	(sp)+,d7	;3E1F
adrCd00296C:
	dbra	d7,adrLp00292A	;51CFFFBC
	rts	;4E75

adrCd002972:
	move.b	d0,d1	;1200
	bmi.s	adrCd002982	;6B0C
	and.w	#$0007,d1	;02410007
	subq.b	#$01,d0	;5300
	subq.w	#$01,d1	;5341
	bcc.s	adrCd002982	;6402
	moveq	#$00,d0	;7000
adrCd002982:
	rts	;4E75

adrCd002984:
	move.b	$001B(a4),d0	;102C001B
	bsr.s	adrCd002972	;61E8
	move.b	$001B(a4),d1	;122C001B
	and.b	#$20,d1	;02010020
	or.b	d1,d0	;8001
	move.b	d0,$001B(a4)	;1940001B
	rts	;4E75

adrCd00299A:
	bsr.s	adrCd002984	;61E8
	move.b	$0019(a4),d0	;102C0019
	move.b	d0,d1	;1200
	and.w	#$000F,d1	;0241000F
	subq.w	#$01,d1	;5341
	bcs.s	adrCd0029B0	;6506
	subq.b	#$01,$0019(a4)	;532C0019
adrCd0029AE:
	rts	;4E75

adrCd0029B0:
	move.b	d0,d1	;1200
	lsr.b	#$04,d1	;E809
	or.b	d0,d1	;8200
	move.b	d1,$0019(a4)	;19410019
	moveq	#$04,d4	;7804
	bclr	d7,$003C(a5)	;0FAD003C
	bne	adrCd002A44	;66000082
	move.b	(a5),d0	;1015
	and.w	#$000A,d0	;0240000A
	beq.s	adrCd0029AE	;67E2
	tst.w	d7	;4A47
	bne.s	adrCd0029D8	;6608
	cmp.b	#$02,$0015(a5)	;0C2D00020015
	bcc.s	adrCd0029AE	;64D6
adrCd0029D8:
	move.w	d3,d0	;3003
	move.b	d3,adrB_00EE3E.l	;13C30000EE3E
	bsr	adrCd006660	;61003C7E
	tst.b	$0013(a4)	;4A2C0013
	bpl	adrCd002BB4	;6A0001CA
	move.w	d3,d0	;3003
	bsr	adrCd004092	;610016A2
	movem.w	d2/d3/d7,-(sp)	;48A73100
	bsr	adrCd002A64	;6100006C
	bmi.s	adrCd002A02	;6B06
	bsr	adrCd0033BE	;610009C0
	bcs.s	adrCd002A14	;6512
adrCd002A02:
	movem.w	(sp)+,d2/d3/d7	;4C9F008C
adrCd002A06:
	tst.w	d7	;4A47
	bne	adrCd002B26	;6600011C
	and.b	#$01,(a5)	;02150001
	bra	adrCd002B26	;60000114

adrCd002A14:
	movem.w	(sp)+,d2/d3/d7	;4C9F008C
	tst.b	d0	;4A00
	bmi.s	adrCd002A28	;6B0C
	cmpi.b	#$10,d0	;0C000010
	bcs.s	adrCd002A28	;6506
	tst.b	$000B(a1)	;4A29000B
	bmi.s	adrCd002A06	;6BDE
adrCd002A28:
	cmpi.w	#$0002,d2	;0C420002
	bcc	adrCd002B26	;640000F8
	movem.l	a4/a5,-(sp)	;48E7000C
	bsr	adrCd002ABA	;61000084
	movem.l	(sp)+,a4/a5	;4CDF3000
	move.w	adrEA016B6C.l,d5	;3A3900016B6C
	moveq	#$00,d4	;7800
adrCd002A44:
	move.w	$0004(sp),d7	;3E2F0004
	movem.w	d4-d7,-(sp)	;48A70F00
	tst.w	d7	;4A47
	bne.s	adrCd002A58	;6608
	bsr	adrCd0081CE	;6100577C
	movem.w	(sp),d4-d7	;4C9700F0
adrCd002A58:
	bsr	adrCd005FC4	;6100356A
	movem.w	(sp)+,d4-d7	;4C9F00F0
	bra	adrCd0060CA	;60003668

adrCd002A64:
	bsr	adrCd008498	;61005A32
	move.w	$00(a6,d0.w),d1	;32360000
	and.w	#$0007,d1	;02410007
	subq.w	#$02,d1	;5541
	bne.s	adrCd002A80	;660C
	move.w	$0020(a5),d1	;322D0020
	add.w	d1,d1	;D241
	btst	d1,$00(a6,d0.w)	;03360000
	bne.s	adrCd002AB6	;6636
adrCd002A80:
	bsr	adrCd00847E	;610059FC
	cmp.w	adrW_00EE72.l,d7	;BE790000EE72
	bcc.s	adrCd002AB6	;642A
	swap	d7	;4847
	cmp.w	adrW_00EE70.l,d7	;BE790000EE70
	bcc.s	adrCd002AB6	;6420
	move.w	$00(a6,d0.w),d1	;32360000
	and.w	#$0007,d1	;02410007
	subq.w	#$02,d1	;5541
	bne.s	adrCd002AB2	;6610
	move.w	$0020(a5),d1	;322D0020
	eor.w	#$0002,d1	;0A410002
	add.w	d1,d1	;D241
	btst	d1,$00(a6,d0.w)	;03360000
	bne.s	adrCd002AB6	;6604
adrCd002AB2:
	moveq	#$00,d1	;7200
	rts	;4E75

adrCd002AB6:
	moveq	#-$01,d1	;72FF
	rts	;4E75

adrCd002ABA:
	clr.w	adrW_006458.l	;427900006458
	move.w	$0020(a5),d1	;322D0020
	tst.b	d0	;4A00
	bpl.s	adrCd002ADC	;6A14
	sub.w	$0020(a1),d1	;92690020
	move.w	d1,adrW_00628A.l	;33C10000628A
	move.w	$0020(a5),d0	;302D0020
	bsr	adrCd006018	;61003540
	bra.s	adrCd002AF8	;601C

adrCd002ADC:
	move.b	$0002(a1),d2	;14290002
	cmpi.b	#$10,d0	;0C000010
	bcc.s	adrCd002AEA	;6404
	move.b	$0018(a1),d2	;14290018
adrCd002AEA:
	and.w	#$0003,d2	;02420003
	sub.w	d2,d1	;9242
	move.w	d1,adrW_00628A.l	;33C10000628A
	move.w	d0,d1	;3200
adrCd002AF8:
	move.w	d3,d0	;3003
	not.w	d0	;4640
	and.w	#$0003,d0	;02400003
	beq.s	adrCd002B0A	;6708
	move.w	#$FFFF,adrW_00628A.l	;33FCFFFF0000628A
adrCd002B0A:
	move.b	#$07,$001B(a4)	;197C0007001B
	move.l	a4,-(sp)	;2F0C
	move.w	d1,-(sp)	;3F01
	bsr	adrCd0061DA	;610036C4
	move.w	(sp)+,d0	;301F
	move.w	$0000(a6),d5	;3A2E0000
	bsr	adrCd002298	;6100F778
	move.l	(sp)+,a4	;285F
	rts	;4E75

adrCd002B26:
	move.w	d3,d1	;3203
	move.w	d1,d2	;3401
	bsr	adrCd00094C	;6100DE20
	lea	PocketContents.l,a0	;41F90000ED2A
	asl.w	#$04,d2	;E942
	add.w	d2,a0	;D0C2
	moveq	#-$01,d4	;78FF
	moveq	#-$01,d5	;7AFF
	moveq	#$01,d3	;7601
adrLp002B3E:
	bsr.s	adrCd002B90	;6150
	dbra	d3,adrLp002B3E	;51CBFFFC
	move.w	d4,d3	;3604
	or.w	d5,d3	;8645
	tst.w	d3	;4A43
	bmi.s	adrCd002BB4	;6B68
	move.b	$00(a0,d4.w),d2	;14304000
	subq.b	#$01,$0B(a0,d2.w)	;5330200B
	bcs.s	adrCd002B86	;6530
	subq.b	#$03,d2	;5702
	move.w	#$0088,d4	;383C0088
	add.w	d2,d4	;D842
	add.b	d2,d0	;D002
	move.b	$00(a0,d5.w),d5	;1A305000
	sub.w	#$005C,d5	;0445005C
	move.b	adrB_002B80(pc,d5.w),d2	;143B5016
	lsr.w	d2,d0	;E468
	add.b	adrB_002B83(pc,d5.w),d0	;D03B5013
	add.w	d0,d0	;D040
	move.w	d0,d7	;3E00
	bsr	adrCd005328	;610027B0
	moveq	#$01,d4	;7801
	bra	adrCd002A44	;6000FEC6

adrB_002B80:
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$01	;01
adrB_002B83:
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01

adrCd002B86:
	clr.b	$00(a0,d4.w)	;42304000
	clr.b	$0B(a0,d2.w)	;4230200B
	rts	;4E75

adrCd002B90:
	move.b	$00(a0,d3.w),d2	;14303000
	cmpi.b	#$05,d2	;0C020005
	bcc.s	adrCd002BA4	;640A
	cmpi.b	#$03,d2	;0C020003
	bcs.s	adrCd002BA2	;6502
	move.w	d3,d4	;3803
adrCd002BA2:
	rts	;4E75

adrCd002BA4:
	cmpi.b	#$5C,d2	;0C02005C
	bcs.s	adrCd002BA2	;65F8
	cmpi.b	#$5F,d2	;0C02005F
	bcc.s	adrCd002BA2	;64F2
	move.w	d3,d5	;3A03
	rts	;4E75

adrCd002BB4:
	tst.b	$0013(a4)	;4A2C0013
	bmi.s	adrCd002BD6	;6B1C
	bsr	adrCd004EA0	;610022E4
	moveq	#$03,d4	;7803
	tst.b	$0013(a4)	;4A2C0013
	bmi	adrCd002A44	;6B00FE7E
	addq.b	#$04,$0007(a4)	;582C0007
	rts	;4E75

adrCd002BCE:
	cmp.w	#$0008,$0042(a5)	;0C6D00080042
	beq.s	adrCd002BD8	;6702
adrCd002BD6:
	rts	;4E75

adrCd002BD8:
	bsr	adrCd0041FA	;61001620
	and.b	#$3F,$0006(a4)	;022C003F0006
	subq.b	#$01,$0004(a4)	;532C0004
	bne.s	adrCd002BD6	;66EE
	tst.b	$0005(a4)	;4A2C0005
	bmi.s	adrCd002BD6	;6BE8
	move.b	$0002(a4),d0	;102C0002
	move.b	$0003(a4),$0002(a4)	;196C00030002
	move.b	d0,$0003(a4)	;19400003
	moveq	#$00,d0	;7000
	move.b	$0000(a4),d0	;102C0000
	cmpi.b	#$09,d0	;0C000009
	bne.s	adrCd002C40	;6638
	movem.l	d0/a4/a5,-(sp)	;48E7800C
	bsr	adrCd0033BE	;610007B0
	bcc.s	adrCd002C3C	;642A
	tst.b	d0	;4A00
	bmi.s	adrCd002C3C	;6B26
	moveq	#$00,d1	;7200
	move.b	$0006(a4),d1	;122C0006
	sub.w	#$000A,d1	;0441000A
	neg.w	d1	;4441
	add.w	d1,d1	;D241
	move.w	d1,adrW_0020F4.w	;31C120F4	;Short Absolute converted to symbol!
	bsr	adrCd001F50	;6100F326
	btst	#$05,$03(a1,d4.w)	;083100054003
	beq.s	adrCd002C3C	;6708
	movem.l	(sp)+,d0/a4/a5	;4CDF3001
	bra	Click_ShowTeamAvatars	;600006A4

adrCd002C3C:
	movem.l	(sp)+,d0/a4/a5	;4CDF3001
adrCd002C40:
	tst.b	$0006(a4)	;4A2C0006
	beq	adrCd00332A	;670006E4
	lea	adrJA002CE4.l,a0	;41F900002CE4
	add.w	d0,d0	;D040
	add.w	adrJT002CAE(pc,d0.w),a0	;D0FB005C
	move.l	a4,-(sp)	;2F0C
	moveq	#$00,d0	;7000
	move.b	$0035(a5),d0	;102D0035
	jsr	(a0)	;4E90
	move.l	(sp)+,a4	;285F
	moveq	#$00,d0	;7000
	move.b	$0003(a4),d0	;102C0003
	move.b	$0002(a4),$0003(a4)	;196C00020003
	move.b	d0,$0002(a4)	;19400002
	move.b	$0001(a4),$0000(a4)	;196C00010000
	or.b	#$40,$0052(a5)	;002D00400052
	move.b	$0035(a5),d0	;102D0035
	cmpi.b	#$10,d0	;0C000010
	bcs.s	adrCd002C98	;6512
	bsr	adrCd006660	;610039D8
	and.b	#$F0,$0019(a4)	;022C00F00019
	or.b	#$0A,$0019(a4)	;002C000A0019
adrJA002C96:
	rts	;4E75

adrCd002C98:
	lea	BigMonsterList.l,a4	;49F900016A7E
	asl.w	#$04,d0	;E940
	and.b	#$F0,$0003(a4)	;022C00F00003
	or.b	#$0A,$0003(a4)	;002C000A0003
	rts	;4E75

adrJT002CAE:
	dc.w	adrJA002CE4-adrJA002CE4	;0000
	dc.w	adrJA002C96-adrJA002CE4	;FFB2
	dc.w	adrJA002C96-adrJA002CE4	;FFB2
	dc.w	adrJA002DA6-adrJA002CE4	;00C2
	dc.w	adrJA002C96-adrJA002CE4	;FFB2
	dc.w	adrJA002C96-adrJA002CE4	;FFB2
	dc.w	adrJA002DA6-adrJA002CE4	;00C2
	dc.w	adrJA002DA6-adrJA002CE4	;00C2
	dc.w	adrJA002DA6-adrJA002CE4	;00C2
	dc.w	adrJA002DAC-adrJA002CE4	;00C8
	dc.w	CharacterName-adrJA002CE4	;00DA
	dc.w	adrJA002DEE-adrJA002CE4	;010A
	dc.w	CharacterName-adrJA002CE4	;00DA
	dc.w	adrJA002DEE-adrJA002CE4	;010A
	dc.w	adrJA002DA6-adrJA002CE4	;00C2
	dc.w	adrJA002DA6-adrJA002CE4	;00C2
	dc.w	adrJA002DA6-adrJA002CE4	;00C2
	dc.w	adrJA002DF8-adrJA002CE4	;0114
	dc.w	adrJA002E12-adrJA002CE4	;012E
	dc.w	adrJA002F24-adrJA002CE4	;0240
	dc.w	adrJA002F50-adrJA002CE4	;026C
	dc.w	adrJA002FC4-adrJA002CE4	;02E0
	dc.w	adrJA00307E-adrJA002CE4	;039A
	dc.w	adrJA00309A-adrJA002CE4	;03B6
	dc.w	adrJA0030B4-adrJA002CE4	;03D0
	dc.w	adrJA002DA6-adrJA002CE4	;00C2
	dc.w	adrJA0030D2-adrJA002CE4	;03EE

adrJA002CE4:
	tst.b	$0007(a4)	;4A2C0007
	bmi	adrJA002DA6	;6B0000BC
	cmpi.b	#$10,d0	;0C000010
	bcs.s	adrCd002D04	;6512
	cmp.b	#$07,$0006(a4)	;0C2C00070006
	bcs	adrJA002DA6	;650000AC
adrCd002CFC:
	lea	NotMyFriendMsg.l,a6	;4DF900003162
	bra.s	adrCd002D34	;6030

adrCd002D04:
	move.l	a5,-(sp)	;2F0D
	bsr	adrCd004066	;6100135E
	move.l	a5,a1	;224D
	move.l	(sp)+,a5	;2A5F
	tst.w	d1	;4A41
	bmi.s	adrCd002D1E	;6B0C
	cmp.l	a1,a5	;BBC9
	bne.s	adrCd002CFC	;66E6
	move.b	#$FF,$0050(a5)	;1B7C00FF0050
	rts	;4E75

adrCd002D1E:
	cmp.b	#$0A,$0006(a4)	;0C2C000A0006
	bcc.s	adrCd002D3A	;6414
	cmp.b	#$05,$0006(a4)	;0C2C00050006
	bcs.s	adrJA002DA6	;6578
	lea	KeepTalkingMsg.l,a6	;4DF900003147
adrCd002D34:
	jmp	WriteMessage.l	;4EF90000D03A

adrCd002D3A:
	bsr	adrCd004054	;61001318
	tst.b	$18(a5,d1.w)	;4A351018
	bpl.s	adrCd002D9E	;6A5A
	lea	adrEA00CAE6.l,a6	;4DF90000CAE6
	move.w	#$45FF,(a6)	;3CBC45FF
	jsr	Print_npc_message.l	;4EB90000D81C
	move.b	$0003(a4),d0	;102C0003
	and.w	#$000F,d0	;0240000F
	move.w	d0,d2	;3400
	bsr	adrCd006660	;61003900
	moveq	#$00,d7	;7E00
	move.b	$0016(a4),d7	;1E2C0016
	swap	d7	;4847
	move.b	$0017(a4),d7	;1E2C0017
	move.b	#$FF,$0016(a4)	;197C00FF0016
	bsr	CoordToMap	;61005726
	bclr	#$07,$01(a6,d0.w)	;08B600070001
	bsr	adrCd004054	;610012D4
	move.b	d2,$18(a5,d1.w)	;1B821018
	moveq	#$03,d0	;7003
adrLp002D88:
	tst.b	$26(a5,d0.w)	;4A350026
	bmi.s	adrCd002D92	;6B04
	dbra	d0,adrLp002D88	;51C8FFF8
adrCd002D92:
	move.b	d2,$26(a5,d0.w)	;1B820026
	bsr	adrCd00332A	;61000592
	bra	adrCd008246	;600054AA

adrCd002D9E:
	lea	PartyFullMsg.l,a6	;4DF900003100
	bra.s	adrCd002D34	;608E

adrJA002DA6:
	moveq	#$19,d1	;7219
adrCd002DA8:
	bra	adrCd003510	;60000766

adrJA002DAC:
	moveq	#$09,d1	;7209
	tst.b	$0007(a4)	;4A2C0007
	bmi.s	adrCd002DA8	;6BF4
	cmp.b	#$0A,$0006(a4)	;0C2C000A0006
	bcs.s	adrCd002DA8	;65EC
	bra.s	adrJA002DA6	;60E8

CharacterName:
	moveq	#$0C,d1	;720C
	cmpi.b	#$10,d0	;0C000010
	bcs.s	adrCd002DA8	;65E2
	cmp.b	#$05,$0006(a4)	;0C2C00050006
	bcs.s	adrJA002DA6	;65D8
	lea	NameNotImportantMsg.l,a6	;4DF900003178
	lea	BigMonsterList.l,a1	;43F900016A7E
	asl.w	#$04,d0	;E940
Zendik_Named:
	cmp.b	#$40,$0B(a1,d0.w)	;0C310040000B
	bne.s	NotNamed	;6606
	lea	ZendikMsg.l,a6	;4DF900003191
NotNamed:
	bra	adrCd002D34	;6000FF48

adrJA002DEE:
	cmpi.b	#$10,d0	;0C000010
	bcc.s	adrJA002DA6	;64B2
	moveq	#$0D,d1	;720D
	bra.s	adrCd002DA8	;60B0

adrJA002DF8:
	moveq	#-$02,d0	;70FE
	cmp.b	#$0A,$0006(a4)	;0C2C000A0006
	bcs.s	adrCd002E06	;6504
	bra	adrJA003918	;60000B14

adrCd002E06:
	bsr	RandomGen_BytewithOffset	;610027A4
	moveq	#$18,d1	;7218
	tst.b	d0	;4A00
	bmi.s	adrCd002DA8	;6B98
	bra.s	adrJA002DA6	;6094

adrJA002E12:
	cmpi.b	#$10,d0						;0C000010
	bcs.s	adrJA002DA6					;658E
	move.w	$002E(a5),d1					;322D002E
	cmp.b	$000A(a4),d1					;B22C000A
	bne	adrCd002FD8					;660001B6
	tst.w	d1						;4A41
	beq.s	adrCd002E52					;672A
	cmpi.b	#$5F,d1						;0C01005F
	beq.s	adrCd002E36					;6708
	cmpi.b	#$40,d1						;0C010040
	bcc	ItemNotToTrade					;6400023A
adrCd002E36:
	moveq	#$00,d2	;7400
	move.b	$0008(a4),d2	;142C0008
	lea	adrJB002E5C.l,a0	;41F900002E5C
	add.w	d2,d2	;D442
	add.w	adrJT002E4A(pc,d2.w),a0	;D0FB2004
	jmp	(a0)	;4ED0

adrJT002E4A:
	dc.w	adrJB002E5C-adrJB002E5C	;0000
	dc.w	adrJA002E82-adrJB002E5C	;0026
	dc.w	adrJA002EE4-adrJB002E5C	;0088
	dc.w	adrJB002E5C-adrJB002E5C	;0000

adrCd002E52:
	move.b	#$08,$0000(a4)	;197C00080000
	bra	adrJA002DA6	;6000FF4C

adrJB002E5C:
	cmpi.b	#$5F,d1						;0C01005F
	beq.s	adrCd002E76					;6714
	sub.w	#$0014,d1					;04410014
	bcs.s	adrCd002E76					;650E
	lea	adrEA0031E6.l,a0				;41F9000031E6
	tst.b	$00(a0,d1.w)					;4A301000
	bmi	ItemNotToTrade					;6B0001FA
adrCd002E76:
	clr.l	$002C(a5)					;42AD002C
adrCd002E7A:
	bsr	adrCd0035FA					;6100077E
	bra	adrCd006C34					;60003DB4

adrJA002E82:
	move.w	$002C(a5),d4	;382D002C
	cmp.b	$0009(a4),d4	;B82C0009
	bcs	adrCd002FD8	;6500014C
	bsr	adrCd003232	;610003A2
	move.w	$002C(a5),d4	;382D002C
	move.w	d0,d3	;3600
	moveq	#$01,d2	;7401
	sub.b	#$14,d3	;04030014
	bcs.s	adrCd002EB4	;6514
	cmpi.b	#$5F,d0	;0C00005F
	bne.s	adrCd002EAA	;6604
	moveq	#$5A,d2	;745A
	bra.s	adrCd002EB4	;600A

adrCd002EAA:
	lea	adrEA0031E6.l,a1	;43F9000031E6
	move.b	$00(a1,d3.w),d2	;14313000
adrCd002EB4:
	moveq	#$6E,d3	;766E
	sub.b	$0006(a4),d3	;962C0006
	cmp.b	#$50,d3	;B63C0050
	bcc.s	adrCd002EC2	;6402
	moveq	#$50,d3	;7650
adrCd002EC2:
	mulu	d3,d2	;C4C3
	divu	#$0064,d2	;84FC0064
	cmp.b	d2,d4	;B802
	bcs.s	adrCd002EDE	;6512
	move.b	#$06,$0C(a0,d1.w)	;11BC0006100C
adrCd002ED2:
	move.b	d0,$002F(a5)	;1B40002F
	move.w	#$0001,$002C(a5)	;3B7C0001002C
	bra.s	adrCd002E7A	;609C

adrCd002EDE:
	moveq	#$07,d1	;7207
	bra	adrCd002DA8	;6000FEC6

adrJA002EE4:
	lea	adrEA0031E6.l,a1		;43F9000031E6
	moveq	#$02,d2				;7402
	sub.w	#$0014,d1			;04410014
	bcs.s	adrCd002F04			;6512
	cmpi.b	#$4B,d1				;0C01004B
	bne.s	adrCd002EFC			;6604
	moveq	#$5A,d2				;745A
	bra.s	adrCd002F04			;6008

adrCd002EFC:
	move.b	$00(a1,d1.w),d2	;14311000
	bmi	adrCd00306A	;6B000168
adrCd002F04:
	bsr	adrCd003232	;6100032C
	move.w	d0,d4	;3800
	moveq	#$02,d3	;7602
	sub.w	#$0014,d4	;04440014
	bcs.s	adrCd002F16	;6504
	move.b	$00(a1,d4.w),d3	;16314000
adrCd002F16:
	cmp.b	d3,d2	;B403
	bcs	adrCd002FB0	;65000096
	move.b	$002F(a5),$0C(a0,d1.w)	;11AD002F100C
	bra.s	adrCd002ED2	;60AE

adrJA002F24:
	cmpi.b	#$10,d0	;0C000010
	bcs	adrJA002DA6	;6500FE7C
adrCd002F2C:
	bsr	adrCd003232	;61000304
	lea	$00(a0,d1.w),a1	;43F01000
	cmp.b	#$15,$000B(a1)	;0C290015000B
	bcs.s	adrCd002F4C	;6510
	cmp.b	#$17,$000B(a1)	;0C290017000B
	bcc.s	adrCd002F4C	;6408
	bsr	adrCd00327C	;61000336
	move.b	$000C(a1),d0	;1029000C
adrCd002F4C:
	bra	adrCd0038D2	;60000984

adrJA002F50:
	cmpi.b	#$10,d0	;0C000010
	bcs	adrJA002DA6	;6500FE50
	move.w	$002E(a5),d1	;322D002E
	cmp.b	$000A(a4),d1	;B22C000A
	bne	adrCd002FD8	;66000076
	tst.w	d1	;4A41
	beq.s	adrCd002F2C	;67C4
	lea	adrEA0031E6.l,a1	;43F9000031E6
	cmpi.b	#$5F,d1	;0C01005F
	bne.s	adrCd002F78	;6604
	moveq	#$5A,d2	;745A
	bra.s	adrCd002F90	;6018

adrCd002F78:
	cmpi.b	#$40,d1	;0C010040
	bcc	ItemNotToTrade	;640000F0
	moveq	#$02,d2	;7402
	sub.w	#$0014,d1	;04410014
	bcs.s	adrCd002F90	;6508
	move.b	$00(a1,d1.w),d2	;14311000
	bmi	adrCd00306A	;6B0000DC
adrCd002F90:
	bsr	adrCd003232	;610002A0
	move.w	d0,d1	;3200
	moveq	#$02,d3	;7602
	sub.w	#$0014,d1	;04410014
	bcs.s	adrCd002FA2	;6504
	move.b	$00(a1,d1.w),d3	;16311000
adrCd002FA2:
	cmp.b	d3,d2	;B403
	bcs.s	adrCd002FB0	;650A
	move.b	#$12,$0001(a4)	;197C00120001
	bra	adrCd00383E	;60000890

adrCd002FB0:
	lea	adrEA0031D2.l,a6	;4DF9000031D2
	jmp	Print_npc_message.l	;4EF90000D81C

adrCd002FBC:
	clr.b	$0008(a4)	;422C0008
	bra	adrJA002DA6	;6000FDE4

adrJA002FC4:
	cmpi.b	#$10,d0	;0C000010
	bcs	adrJA002DA6	;6500FDDC
	move.w	$002E(a5),d0	;302D002E
	beq.s	adrCd002FBC	;67EA
	cmp.b	$000A(a4),d0	;B02C000A
	beq.s	adrCd002FEE	;6716
adrCd002FD8:
	subq.b	#$05,$0006(a4)	;5B2C0006
	bpl.s	adrCd002FE2	;6A04
	clr.b	$0006(a4)	;422C0006
adrCd002FE2:
	lea	RipMeOffMsg.l,a6	;4DF900003112
	jmp	WriteMessage.l	;4EF90000D03A

adrCd002FEE:
	cmpi.b	#$5F,d0	;0C00005F
	bne.s	adrCd002FF8	;6604
	moveq	#$5A,d0	;705A
	bra.s	adrCd003016	;601E

adrCd002FF8:
	cmpi.b	#$40,d0	;0C000040
	bcc.s	ItemNotToTrade	;6470
	sub.b	#$14,d0	;04000014
	bcc.s	adrCd00300A	;6406
	moveq	#$01,d0	;7001
	bra	adrCd003242	;6000023A

adrCd00300A:
	lea	adrEA0031E6.l,a0	;41F9000031E6
	move.b	$00(a0,d0.w),d0	;10300000
	bmi.s	adrCd00306A	;6B54
adrCd003016:
	moveq	#$00,d2	;7400
	move.b	$0009(a4),d2	;142C0009
	bne.s	adrCd00303E	;6620
	moveq	#$00,d1	;7200
	move.b	$0006(a4),d1	;122C0006
	sub.w	#$000A,d1	;0441000A
	add.w	#$003C,d1	;0641003C
	cmp.w	#$0064,d1	;B27C0064
	bcc	adrCd003242	;64000210
	mulu	d1,d0	;C0C1
	divu	#$0064,d0	;80FC0064
	bra	adrCd003242	;60000206

adrCd00303E:
	bpl.s	adrCd003054	;6A14
	clr.b	$0008(a4)	;422C0008
	lea	TooGreedyMsg.l,a6	;4DF9000031B4
	move.b	#$19,$0001(a4)	;197C00190001
	bra	adrCd002D34	;6000FCE2

adrCd003054:
	cmp.b	#$0F,$0006(a4)	;0C2C000F0006
	bcs.s	adrCd003094	;6538
	sub.b	d2,d0	;9002
	lsr.b	#$01,d0	;E208
	add.b	d2,d0	;D002
	bset	#$07,d0	;08C00007
	bra	adrCd003242	;600001DA

adrCd00306A:
	clr.b	$0008(a4)	;422C0008
ItemNotToTrade:
	move.b	#$07,$0001(a4)	;197C00070001
	lea	NeverTrustUnnaturalMsg.l,a6	;4DF90000312B
	bra	adrCd002D34	;6000FCB8

adrJA00307E:
	moveq	#$16,d1	;7216
	cmp.b	#$0A,$0006(a4)	;0C2C000A0006
	bcc	adrCd002DA8	;6400FD20
	cmp.b	#$05,$0006(a4)	;0C2C00050006
	bcc	adrJA002DA6	;6400FD14
adrCd003094:
	moveq	#$17,d1	;7217
	bra	adrCd002DA8	;6000FD10

adrJA00309A:
	moveq	#$17,d1	;7217
	cmp.b	#$05,$0006(a4)	;0C2C00050006
	bcc	adrCd002DA8	;6400FD04
	tst.b	$0007(a4)	;4A2C0007
	bpl	adrJA002DA6	;6A00FCFA
	moveq	#$09,d1	;7209
	bra	adrCd002DA8	;6000FCF6

adrJA0030B4:
	cmp.b	#$0A,$0006(a4)	;0C2C000A0006
	bcc.s	adrJA00307E	;64C2
	moveq	#$18,d1	;7218
	cmp.b	#$07,$0006(a4)	;0C2C00070006
	bcc	adrCd002DA8	;6400FCE2
	tst.b	$0007(a4)	;4A2C0007
	bmi.s	adrJA00309A	;6BCC
	bra	adrJA002DA6	;6000FCD6

adrJA0030D2:
	cmp.b	#$02,$0006(a4)	;0C2C00020006
	bcs	adrJA002DAC	;6500FCD2
	cmp.b	#$05,$0006(a4)	;0C2C00050006
	bcs.s	adrJA00309A	;65B6
	cmp.b	#$08,$0006(a4)	;0C2C00080006
	bcs	adrJA002DA6	;6500FCBA
	bsr	RandomGen_BytewithOffset	;610024BC
	moveq	#$0A,d1	;720A
	tst.b	d0	;4A00
	bmi	adrCd002DA8	;6B00FCB0
	moveq	#$0B,d1	;720B
	bra	adrCd002DA8	;6000FCAA

PartyFullMsg:
	dc.b	'THY PARTY IS FULL'	;5448592050415254592049532046554C4C
	dc.b	$FF	;FF
RipMeOffMsg:
	dc.b	'WOULDST THOU RIP ME OFF?'	;574F554C4453542054484F5520524950204D45204F46463F
	dc.b	$FF	;FF
NeverTrustUnnaturalMsg:
	dc.b	'I NEVER TRUST THE UNNATURAL'	;49204E455645522054525553542054484520554E4E41545552414C
	dc.b	$FF	;FF
KeepTalkingMsg:
	dc.b	'KEEP TALKING AND WE''LL SEE'	;4B4545502054414C4B494E4720414E44205745274C4C20534545
	dc.b	$FF	;FF
NotMyFriendMsg:
	dc.b	'I THINK NOT MY FRIEND'	;49205448494E4B204E4F54204D5920465249454E44
	dc.b	$FF	;FF
NameNotImportantMsg:
	dc.b	'MY NAME IS NOT IMPORTANT'	;4D59204E414D45204953204E4F5420494D504F5254414E54
	dc.b	$FF	;FF
ZendikMsg:
	dc.b	'I AM ZENDIK THE MASTER OF CREATION'	;4920414D205A454E44494B20544845204D4153544552204F46204352454154494F4E
	dc.b	$FF	;FF
TooGreedyMsg:
	dc.b	'METHINKS THOU ART TOO GREEDY!'	;4D455448494E4B532054484F552041525420544F4F2047524545445921
	dc.b	$FF	;FF
adrEA0031D2:
	dc.b	$1A	;1A
	dc.b	$19	;19
	dc.b	$61	;61
	dc.b	$8D	;8D
	dc.b	$B1	;B1
	dc.b	$51	;51
	dc.b	$FF	;FF
adrEA0031D9:
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
adrEA0031E6:
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
adrEA003212:
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

adrCd003232:
	move.w	d0,d1	;3200
	lea	BigMonsterList.l,a0	;41F900016A7E
	asl.w	#$04,d1	;E941
	move.b	$0C(a0,d1.w),d0	;1030100C
	rts	;4E75

adrCd003242:
	move.b	d0,$0009(a4)	;19400009
	and.w	#$007F,d0	;0240007F
	jsr	adrCd00CEC4.l	;4EB90000CEC4
	lea	adrEA0031D9.w,a6	;4DF831D9	;Short Absolute converted to symbol!
	moveq	#$06,d2	;7406
	ror.w	#$08,d1	;E059
	cmpi.b	#$30,d1	;0C010030
	beq.s	adrCd00326A	;670C
	move.b	d1,$00(a6,d2.w)	;1D812000
	move.b	#$FA,$01(a6,d2.w)	;1DBC00FA2001
	addq.w	#$02,d2	;5442
adrCd00326A:
	ror.w	#$08,d1	;E059
	move.b	d1,$00(a6,d2.w)	;1D812000
	move.b	#$54,$01(a6,d2.w)	;1DBC00542001
	addq.w	#$02,d2	;5442
	bra	adrCd0038DC	;60000662

adrCd00327C:
	movem.w	d0/d1,-(sp)	;48A7C000
	move.b	#$03,$0006(a4)	;197C00030006
	cmp.b	#$40,$000B(a1)	;0C290040000B
	beq.s	adrCd0032D8	;674A
	bsr	RandomGen_BytewithOffset	;6100231C
	cmp.b	#$16,$000B(a1)	;0C290016000B
	bne.s	adrCd0032A8	;660E
	and.w	#$0003,d0	;02400003
	add.w	#$0017,d0	;06400017
	move.b	d0,$000C(a1)	;1340000C
	bra.s	adrCd0032D8	;6030

adrCd0032A8:
	and.w	#$001F,d0	;0240001F
	move.b	$0006(a1),d1	;12290006
	cmpi.b	#$08,d1	;0C010008
	bcc.s	adrCd0032C0	;640A
	lsr.w	#$01,d0	;E248
	cmpi.b	#$04,d1	;0C010004
	bcc.s	adrCd0032C0	;6402
	lsr.w	#$01,d0	;E248
adrCd0032C0:
	lea	adrEA003212.w,a0	;41F83212	;Short Absolute converted to symbol!
	move.b	$00(a0,d0.w),$000C(a1)	;13700000000C
	move.b	$0006(a1),d0	;10290006
	and.w	#$007F,d0	;0240007F
	neg.b	d0	;4400
	move.b	d0,$0006(a4)	;19400006
adrCd0032D8:
	movem.w	(sp)+,d0/d1	;4C9F0003
	rts	;4E75

Click_ShowTeamAvatars:
	move.b	#$01,$0052(a5)	;1B7C00010052
	clr.b	$004A(a5)	;422D004A
	tst.b	$004B(a5)	;4A2D004B
	bmi.s	adrCd0032F4	;6B06
	move.w	#$00FF,$004A(a5)	;3B7C00FF004A
adrCd0032F4:
	cmp.w	#$0008,$0042(a5)	;0C6D00080042
	beq.s	adrCd003312	;6716
	tst.w	$0042(a5)	;4A6D0042
	bne.s	adrCd00332A	;6628
	move.w	#$FFFF,$0042(a5)	;3B7CFFFF0042
	move.w	#$FFFF,$0040(a5)	;3B7CFFFF0040
	bra	adrCd007B50	;60004840

adrCd003312:
	cmp.w	#$0006,$0044(a5)	;0C6D00060044
	bcs.s	adrCd00332A	;6510
adrCd00331A:
	lsr.w	$0044(a5)	;E2ED0044
	addq.w	#$01,$0044(a5)	;526D0044
	bsr	adrCd003344	;61000020
	bra	adrCd007D6C	;60004A44

adrCd00332A:
	clr.w	$0042(a5)	;426D0042
	clr.w	$0044(a5)	;426D0044
	move.b	#$FF,$0035(a5)	;1B7C00FF0035
adrCd003338:
	move.l	#$003B003B,d7	;2E3C003B003B
	bsr.s	adrCd00334A	;610A
	bra	adrCd007D6C	;60004A2A

adrCd003344:
	move.l	#$00760075,d7	;2E3C00760075
adrCd00334A:
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$0647,a0	;D0FC0647
	add.w	$000A(a5),a0	;D0ED000A
	move.w	d7,d0	;3007
	swap	d7	;4847
	jsr	adrCd00CAEA.l	;4EB90000CAEA
	move.w	d7,d0	;3007
	jmp	adrCd00CAEA.l	;4EF90000CAEA

adrJA00336A:
	move.l	$0046(a5),a6	;2C6D0046
	moveq	#$00,d1	;7200
	move.b	$0040(a5),d0	;102D0040
	and.w	#$0003,d0	;02400003
	subq.b	#$01,d0	;5300
	bcs.s	adrCd00338A	;650E
adrLp00337C:
	addq.w	#$01,d1	;5241
	cmp.b	#$5F,(a6)+	;0C1E005F
	bcc.s	adrCd003386	;6402
	addq.w	#$01,d1	;5241
adrCd003386:
	dbra	d0,adrLp00337C	;51C8FFF4
adrCd00338A:
	add.b	$0041(a5),d1	;D22D0041
adrCd00338E:
	move.w	$0042(a5),d0	;302D0042
	add.w	d0,d0	;D040
	lea	adrJB0033B2.l,a0	;41F9000033B2
	add.w	adrJT0033A0(pc,d0.w),a0	;D0FB0004
	jmp	(a0)	;4ED0

adrJT0033A0:
	dc.w	adrJB0033B2-adrJB0033B2	;0000
	dc.w	adrJA0033EE-adrJB0033B2	;003C
	dc.w	adrJA004150-adrJB0033B2	;0D9E
	dc.w	adrJA0040E4-adrJB0033B2	;0D32
	dc.w	adrJA003F60-adrJB0033B2	;0BAE
	dc.w	adrJA004144-adrJB0033B2	;0D92
	dc.w	adrJA003F5C-adrJB0033B2	;0BAA
	dc.w	adrJA003E9C-adrJB0033B2	;0AEA
	dc.w	adrJA0034CC-adrJB0033B2	;011A

adrJB0033B2:
	clr.b	$004E(a5)	;422D004E
	addq.w	#$01,d1	;5241
	move.w	d1,$0042(a5)	;3B410042
	bra.s	adrCd00338E	;60D0

adrCd0033BE:
	bsr	adrCd00847E	;610050BE
	move.l	d7,d2	;2407
	cmp.w	adrW_00EE72.l,d7	;BE790000EE72
	bcc.s	adrCd0033EC	;6420
	swap	d7	;4847
	cmp.w	adrW_00EE70.l,d7	;BE790000EE70
	bcc.s	adrCd0033EC	;6416
	move.b	$01(a6,d0.w),d1	;12360001
	bpl.s	adrCd0033EC	;6A10
	and.w	#$0007,d1	;02410007
	subq.w	#$01,d1	;5341
	beq.s	adrCd0033EC	;6708
	move.w	$0058(a5),d1	;322D0058
	bra	adrCd0098A8	;600064BE

adrCd0033EC:
	rts	;4E75

adrJA0033EE:
	bsr.s	adrCd0033BE	;61CE
	bcs.s	adrCd003402	;6510
adrCd0033F2:
	lea	adrEA0041F3.l,a6	;4DF9000041F3
	clr.w	$0042(a5)	;426D0042
	jmp	Print_timed_message.l	;4EF90000D86A

adrCd003402:
	move.w	d0,d1	;3200
	bsr	adrCd00665C	;61003256
	move.b	#$17,$001B(a4)	;197C0017001B
	move.w	d1,d0	;3001
	bsr	adrCd0041FA	;61000DE8
	clr.b	$0006(a4)	;422C0006
	move.b	#$1A,$0000(a4)	;197C001A0000
	bclr	#$07,$0005(a4)	;08AC00070005
	tst.b	d0	;4A00
	bmi.s	adrCd003458	;6B30
	move.w	$0020(a5),d1	;322D0020
	eor.w	#$0002,d1	;0A410002
	moveq	#$18,d4	;7818
	cmpi.w	#$0010,d0	;0C400010
	bcs.s	adrCd003444	;650C
	tst.b	$000B(a1)	;4A29000B
	bmi.s	adrCd0033F2	;6BB4
	bsr	adrCd00327C	;6100FE3C
	moveq	#$02,d4	;7802
adrCd003444:
	and.b	#$F0,$00(a1,d4.w)	;023100F04000
	or.b	$00(a1,d4.w),d1	;82314000
	move.b	d1,$00(a1,d4.w)	;13814000
	move.b	d0,$0035(a5)	;1B400035
	bra.s	adrCd003462	;600A

adrCd003458:
	bset	#$07,$0005(a4)	;08EC00070005
	move.w	$0006(a1),d0	;30290006
adrCd003462:
	move.b	$0007(a5),$0003(a4)	;196D00070003
	and.w	#$007F,d0	;0240007F
	move.b	d0,$0002(a4)	;19400002
	move.l	a4,-(sp)	;2F0C
	bsr	adrCd00665C	;610031E8
	move.b	$0004(a4),d2	;142C0004
	move.l	(sp)+,a4	;285F
	bsr	RandomGen_BytewithOffset	;6100212E
	and.w	#$0007,d0	;02400007
	addq.w	#$02,d0	;5440
	sub.b	#$14,d2	;04020014
	bcc.s	adrCd00348E	;6402
	moveq	#$00,d2	;7400
adrCd00348E:
	lsr.b	#$02,d2	;E40A
	add.b	d2,d0	;D002
	add.b	$0006(a4),d0	;D02C0006
	bpl.s	adrCd00349A	;6A02
	moveq	#$00,d0	;7000
adrCd00349A:
	move.b	d0,$0006(a4)	;19400006
	bsr	RandomGen_BytewithOffset	;6100210C
	and.w	#$0007,d0	;02400007
	addq.w	#$08,d0	;5040
	move.b	d0,$0007(a4)	;19400007
	move.b	#$14,$0004(a4)	;197C00140004
	clr.b	$0008(a4)	;422C0008
	lea	adrEA003DF7.l,a6	;4DF900003DF7
	jsr	Print_npc_message.l	;4EB90000D81C
	move.w	#$0004,$0044(a5)	;3B7C00040044
	bra	adrCd003D9C	;600008D2

adrJA0034CC:
	move.w	$0044(a5),d0	;302D0044
	subq.w	#$04,d0	;5940
	beq.s	adrCd0034E0	;670C
	addq.w	#$04,d1	;5841
	subq.w	#$01,d0	;5340
	beq.s	adrCd0034E0	;6706
	addq.w	#$02,d1	;5441
	asl.w	#$02,d0	;E540
	add.w	d0,d1	;D240
adrCd0034E0:
	bsr	adrCd0041FA	;61000D18
	addq.b	#$01,$0006(a4)	;522C0006
	bsr.s	adrCd003510	;6126
	cmp.w	#$0006,$0044(a5)	;0C6D00060044
	bcs.s	adrCd0034FE	;650C
	cmp.b	#$06,$0001(a4)	;0C2C00060001
	bcs.s	adrCd00350E	;6514
	bsr	adrCd00331A	;6100FE1E
adrCd0034FE:
	move.b	#$14,$0004(a4)	;197C00140004
	move.b	$0001(a4),$0000(a4)	;196C00010000
	subq.b	#$01,$0007(a4)	;532C0007
adrCd00350E:
	rts	;4E75

adrCd003510:
	move.b	d1,$0001(a4)	;19410001
	add.w	d1,d1	;D241
	lea	adrJB00355C.l,a0	;41F90000355C
	add.w	adrJT003526(pc,d1.w),a0	;D0FB1008
	bsr	RandomGen_BytewithOffset	;6100208A
	jmp	(a0)	;4ED0

adrJT003526:
	dc.w	adrJB00355C-adrJB00355C	;0000
	dc.w	adrJA00356A-adrJB00355C	;000E
	dc.w	adrJA003572-adrJB00355C	;0016
	dc.w	adrJA00357A-adrJB00355C	;001E
	dc.w	adrJA003586-adrJB00355C	;002A
	dc.w	adrJA00358E-adrJB00355C	;0032
	dc.w	adrJA003596-adrJB00355C	;003A
	dc.w	adrJA003604-adrJB00355C	;00A8
	dc.w	adrJA00363E-adrJB00355C	;00E2
	dc.w	adrJA00364A-adrJB00355C	;00EE
	dc.w	adrJA0036F0-adrJB00355C	;0194
	dc.w	adrJA0036FC-adrJB00355C	;01A0
	dc.w	adrJA00371E-adrJB00355C	;01C2
	dc.w	adrJA003744-adrJB00355C	;01E8
	dc.w	adrJA003772-adrJB00355C	;0216
	dc.w	adrJA00377E-adrJB00355C	;0222
	dc.w	adrJA00378A-adrJB00355C	;022E
	dc.w	adrJA003796-adrJB00355C	;023A
	dc.w	adrJA00382C-adrJB00355C	;02D0
	dc.w	adrJA0038A4-adrJB00355C	;0348
	dc.w	adrJA0038B6-adrJB00355C	;035A
	dc.w	adrJA003874-adrJB00355C	;0318
	dc.w	adrJA003918-adrJB00355C	;03BC
	dc.w	adrJA003924-adrJB00355C	;03C8
	dc.w	adrJA003A0E-adrJB00355C	;04B2
	dc.w	adrJA003A52-adrJB00355C	;04F6
	dc.w	adrJA003568-adrJB00355C	;000C

adrJB00355C:
	lea	ComeJoinMsg.l,a6	;4DF900003E83
	jmp	WriteMessage.l	;4EF90000D03A

adrJA003568:
	rts	;4E75

adrJA00356A:
	addq.w	#$02,$0044(a5)	;546D0044
	bra	adrCd003338	;6000FDC8

adrJA003572:
	addq.w	#$03,$0044(a5)	;566D0044
	bra	adrCd003338	;6000FDC0

adrJA00357A:
	lea	WhereIsThisMsg.l,a6	;4DF900003E2F
	jmp	WriteMessage.l	;4EF90000D03A

adrJA003586:
	addq.w	#$03,$0044(a5)	;566D0044
	bra	adrCd003338	;6000FDAC

adrJA00358E:
	addq.w	#$04,$0044(a5)	;586D0044
	bra	adrCd003338	;6000FDA4

adrJA003596:
	move.b	$0008(a4),d2	;142C0008
	subq.b	#$02,d2	;5502
	bcs.s	adrCd0035FE	;6560
	bne.s	adrCd0035DC	;663C
	cmp.b	#$12,$0000(a4)	;0C2C00120000
	bne.s	adrCd0035FE	;6656
	move.w	$002E(a5),d0	;302D002E
	cmp.b	$000A(a4),d0	;B02C000A
	bne.s	adrCd0035FA	;6648
	move.b	$0035(a5),d0	;102D0035
	cmpi.b	#$10,d0	;0C000010
	bcs.s	adrCd0035FE	;6542
	bsr	adrCd003232	;6100FC74
	move.b	$002F(a5),$0C(a0,d1.w)	;11AD002F100C
	move.b	d0,$002F(a5)	;1B40002F
	move.w	#$0001,$002C(a5)	;3B7C0001002C
adrCd0035D0:
	move.b	#$18,$0001(a4)	;197C00180001
	bsr.s	adrCd0035FA	;6122
	bra	adrCd006C34	;6000365A

adrCd0035DC:
	move.b	$000A(a4),d0	;102C000A
	cmp.b	$002F(a5),d0	;B02D002F
	bne.s	adrCd0035FA	;6614
	and.b	#$7F,$0009(a4)	;022C007F0009
	move.b	$0009(a4),$002D(a5)	;1B6C0009002D
	move.w	#$0001,$002E(a5)	;3B7C0001002E
	bra.s	adrCd0035D0	;60D6

adrCd0035FA:
	clr.b	$0008(a4)	;422C0008
adrCd0035FE:
	move.w	#$45FF,d0	;303C45FF
	bra.s	adrCd003626	;6022

adrJA003604:
	move.w	#$3DFF,d0	;303C3DFF
	move.b	$0008(a4),d1	;122C0008
	beq.s	adrCd003626	;6718
	add.b	#$12,d1	;06010012
	move.b	d1,$0001(a4)	;19410001
	cmpi.b	#$15,d1	;0C010015
	bne.s	adrCd003626	;660A
	subq.b	#$04,$0006(a4)	;592C0006
	bpl.s	adrCd003626	;6A04
	clr.b	$0006(a4)	;422C0006
adrCd003626:
	subq.b	#$01,$0006(a4)	;532C0006
	bpl.s	adrCd003630	;6A04
	clr.b	$0006(a4)	;422C0006
adrCd003630:
	lea	adrEA00CAE6.l,a6	;4DF90000CAE6
	move.w	d0,(a6)	;3C80
	jmp	Print_npc_message.l	;4EF90000D81C

adrJA00363E:
	lea	adrEA003E26.l,a6	;4DF900003E26
	jmp	Print_npc_message.l	;4EF90000D81C

adrJA00364A:
	lea	adrEA003DC0.l,a6	;4DF900003DC0
	and.w	#$0003,d0	;02400003
	lea	adrEA003DDE.l,a3	;47F900003DDE
	bsr	adrCd0036E0	;61000084
	move.b	$0006(a4),d0	;102C0006
	subq.b	#$03,$0006(a4)	;572C0006
	bpl.s	adrCd00366C	;6A04
	clr.b	$0006(a4)	;422C0006
adrCd00366C:
	cmpi.b	#$0A,d0	;0C00000A
	bcs.s	adrCd0036A2	;6530
adrCd003672:
	move.b	$0002(a4),d0	;102C0002
	bpl.s	adrCd003680	;6A08
	and.w	#$000F,d0	;0240000F
	move.b	d0,(a6)+	;1CC0
	bra.s	adrCd0036D0	;6050

adrCd003680:
	move.b	#$99,(a6)+	;1CFC0099
	move.b	#$C3,d1	;123C00C3
	btst	#$06,d0	;08000006
	beq.s	adrCd00369E	;6710
	move.b	#$9E,d1	;123C009E
	and.w	#$0003,d0	;02400003
	beq.s	adrCd00369E	;6706
	add.b	#$5B,d0	;0600005B
	move.b	d0,d1	;1200
adrCd00369E:
	move.b	d1,(a6)+	;1CC1
	bra.s	adrCd0036D0	;602E

adrCd0036A2:
	move.b	#$62,(a6)+	;1CFC0062
	bsr	RandomGen_BytewithOffset	;61001F04
	and.w	#$0003,d0	;02400003
	lea	adrEA003DEE.l,a3	;47F900003DEE
	bsr.s	adrCd0036E0	;612A
	cmp.b	#$06,$0006(a4)	;0C2C00060006
	bcc.s	adrCd003672	;64B4
	move.b	#$1A,(a6)+	;1CFC001A
	bsr	RandomGen_BytewithOffset	;61001EE8
	and.w	#$0007,d0	;02400007
	add.b	#$B6,d0	;060000B6
	move.b	d0,(a6)+	;1CC0
adrCd0036D0:
	move.b	#$FF,(a6)	;1CBC00FF
	lea	adrEA003DC0.l,a6	;4DF900003DC0
	jmp	Print_npc_message.l	;4EF90000D81C

adrCd0036E0:
	jsr	Proceed_in_stringtable.l	;4EB90000D7CC
	subq.w	#$01,d5	;5345
adrLp0036E8:
	move.b	(a3)+,(a6)+	;1CDB
	dbra	d5,adrLp0036E8	;51CDFFFC
	rts	;4E75

adrJA0036F0:
	lea	adrEA003DFD.l,a6	;4DF900003DFD
	jmp	Print_npc_message.l	;4EF90000D81C

adrJA0036FC:
	lea	WhatThyBusinessMsg.l,a6	;4DF900003708
	jmp	WriteMessage.l	;4EF90000D03A

WhatThyBusinessMsg:
	dc.b	'WHAT BE THY BUSINESS?'	;574841542042452054485920425553494E4553533F
	dc.b	$FF	;FF

adrJA00371E:
	lea	adrEA003DAA.l,a6	;4DF900003DAA
	move.b	$0003(a4),d1	;122C0003
	or.b	#$80,$0003(a4)	;002C00800003
	and.w	#$000F,d1	;0241000F
	move.b	d1,$0003(a6)	;1D410003
	add.w	#$0064,d1	;06410064
	move.b	d1,$0004(a6)	;1D410004
	jmp	Print_npc_message.l	;4EF90000D81C

adrJA003744:
	lea	adrEA003E03.l,a6	;4DF900003E03
	move.b	$0003(a4),d0	;102C0003
	or.b	#$40,$0003(a4)	;002C00400003
	and.w	#$000F,d0	;0240000F
	move.b	#$9E,$0006(a6)	;1D7C009E0006
	and.w	#$0003,d0	;02400003
	beq.s	adrCd00376C	;6708
	add.w	#$005B,d0	;0640005B
	move.b	d0,$0006(a6)	;1D400006
adrCd00376C:
	jmp	Print_npc_message.l	;4EF90000D81C

adrJA003772:
	lea	AnyLegendsMsg.l,a6	;4DF9000037A2
	jmp	WriteMessage.l	;4EF90000D03A

adrJA00377E:
	lea	AnyEnchantedMsg.l,a6	;4DF9000037BF
	jmp	WriteMessage.l	;4EF90000D03A

adrJA00378A:
	lea	AnyWeaponsMsg.l,a6	;4DF9000037E4
	jmp	WriteMessage.l	;4EF90000D03A

adrJA003796:
	lea	AnyPowerfulMsg.l,a6	;4DF900003809
	jmp	WriteMessage.l	;4EF90000D03A

AnyLegendsMsg:
	dc.b	'HAST THOU HEARD ANY LEGENDS?'	;484153542054484F5520484541524420414E59204C4547454E44533F
	dc.b	$FF	;FF
AnyEnchantedMsg:
	dc.b	'KNOWEST THOU OF ANY ENCHANTED ITEMS?'	;4B4E4F574553542054484F55204F4620414E5920454E4348414E544544204954454D533F
	dc.b	$FF	;FF
AnyWeaponsMsg:
	dc.b	'KNOWEST THOU OF ANY WEAPONS OF NOTE?'	;4B4E4F574553542054484F55204F4620414E5920574541504F4E53204F46204E4F54453F
	dc.b	$FF	;FF
AnyPowerfulMsg:
	dc.b	'HAST HEARD OF ANY POWERFUL BEINGS?'	;48415354204845415244204F4620414E5920504F57455246554C204245494E47533F
	dc.b	$FF	;FF

adrJA00382C:
	move.w	$002E(a5),d0	;302D002E
	move.b	d0,$000A(a4)	;1940000A
	bne.s	adrCd00383E	;6608
	clr.b	$0008(a4)	;422C0008
	moveq	#$2E,d0	;702E
	bra.s	adrCd003894	;6056

adrCd00383E:
	cmpi.w	#$0001,d0	;0C400001
	bne.s	adrCd00385C	;6618
	move.w	$002C(a5),d0	;302D002C
	cmp.b	#$02,$0008(a4)	;0C2C00020008
	bne	adrCd003242	;6600F9F2
	move.b	#$01,$0008(a4)	;197C00010008
	bra	adrCd003242	;6000F9E8

adrCd00385C:
	cmp.b	#$01,$0008(a4)	;0C2C00010008
	bne.s	adrCd00386A	;6606
	move.b	#$02,$0008(a4)	;197C00020008
adrCd00386A:
	lea	adrEA003E65.l,a6	;4DF900003E65
	moveq	#$05,d2	;7405
	bra.s	adrCd0038DA	;6066

adrJA003874:
	move.b	#$03,$0008(a4)	;197C00030008
	clr.b	$0009(a4)	;422C0009
	move.w	$002E(a5),d0	;302D002E
	beq.s	adrCd003892	;670E
	move.b	d0,$000A(a4)	;1940000A
	lea	adrEA003E70.l,a6	;4DF900003E70
	moveq	#$05,d2	;7405
	bra.s	adrCd0038DA	;6048

adrCd003892:
	moveq	#$57,d0	;7057
adrCd003894:
	lea	adrEA003E58.l,a6	;4DF900003E58
	move.b	d0,$0005(a6)	;1D400005
	jmp	Print_npc_message.l	;4EF90000D81C

adrJA0038A4:
	lea	adrEA003E7B.l,a6	;4DF900003E7B
	move.b	#$01,$0008(a4)	;197C00010008
	jmp	Print_npc_message.l	;4EF90000D81C

adrJA0038B6:
	move.b	#$02,$0008(a4)	;197C00020008
	move.w	$002E(a5),d0	;302D002E
	move.b	d0,$000A(a4)	;1940000A
	bne.s	adrCd0038D2	;660C
	lea	adrEA003E0B.l,a6	;4DF900003E0B
	jmp	Print_npc_message.l	;4EF90000D81C

adrCd0038D2:
	lea	adrEA003E15.l,a6	;4DF900003E15
	moveq	#$0B,d2	;740B
adrCd0038DA:
	bsr.s	adrCd0038F4	;6118
adrCd0038DC:
	move.b	#$FA,$00(a6,d2.w)	;1DBC00FA2000
	move.b	#$3F,$01(a6,d2.w)	;1DBC003F2001
	move.b	#$FF,$02(a6,d2.w)	;1DBC00FF2002
	jmp	Print_npc_message.l	;4EF90000D81C

adrCd0038F4:
	lea	ObjectDefinitionsTable.l,a0	;41F90000E4C4
	add.w	d0,d0	;D040
	add.w	d0,d0	;D040
	add.w	d0,a0	;D0C0
	move.b	(a0)+,$00(a6,d2.w)	;1D982000
	addq.w	#$01,d2	;5242
	move.b	(a0),d0	;1010
	bmi.s	adrCd003916	;6B0C
	move.b	#$FE,$00(a6,d2.w)	;1DBC00FE2000
	move.b	d0,$01(a6,d2.w)	;1D802001
	addq.w	#$02,d2	;5442
adrCd003916:
	rts	;4E75

adrJA003918:
	addq.b	#$01,$0006(a4)	;522C0006
	lea	adrEA003A02.l,a0	;41F900003A02
	bra.s	adrCd003934	;6010

adrJA003924:
	subq.b	#$04,$0006(a4)	;592C0006
	bpl.s	adrCd00392E	;6A04
	clr.b	$0006(a4)	;422C0006
adrCd00392E:
	lea	adrEA003A08.l,a0	;41F900003A08
adrCd003934:
	bsr.s	adrCd00397E	;6148
	moveq	#$02,d4	;7802
adrLp003938:
	asr.w	#$01,d7	;E247
	bcc.s	adrCd00393E	;6402
	bsr.s	adrCd003950	;6112
adrCd00393E:
	addq.w	#$02,a0	;5448
	dbra	d4,adrLp003938	;51CCFFF6
	move.b	#$FF,$00(a6,d2.w)	;1DBC00FF2000
	jmp	Print_npc_message.l	;4EF90000D81C

adrCd003950:
	bsr	RandomGen_BytewithOffset	;61001C5A
	and.w	#$0007,d0	;02400007
	tst.w	d7	;4A47
	bpl.s	adrCd003972	;6A16
	cmp.b	(a0),d0	;B010
	bcs.s	adrCd00396E	;650E
	move.b	#$FA,$00(a6,d2.w)	;1DBC00FA2000
	move.b	#$4E,$01(a6,d2.w)	;1DBC004E2001
	addq.w	#$02,d2	;5442
adrCd00396E:
	and.w	#$00FF,d7	;024700FF
adrCd003972:
	add.b	$0001(a0),d0	;D0280001
	move.b	d0,$00(a6,d2.w)	;1D802000
	addq.w	#$01,d2	;5242
	rts	;4E75

adrCd00397E:
	and.w	#$00FE,d0	;024000FE
	moveq	#$00,d7	;7E00
adrCd003984:
	cmp.b	adrB_0039F6(pc,d7.w),d0	;B03B7070
	bcs.s	adrCd00398E	;6504
	addq.w	#$02,d7	;5447
	bra.s	adrCd003984	;60F6

adrCd00398E:
	move.b	adrB_0039F7(pc,d7.w),d7	;1E3B7067
	lea	adrEA003DC0.l,a6	;4DF900003DC0
	move.b	#$1A,(a6)	;1CBC001A
	moveq	#$01,d2	;7401
	lsr.w	#$01,d7	;E24F
	bcc.s	adrCd0039DA	;6438
	cmp.b	#$03,$0001(a4)	;0C2C00030001
	bne.s	adrCd0039B2	;6608
	bsr	adrCd005556	;61001BAA
	addq.w	#$02,d0	;5440
	bra.s	adrCd0039BA	;6008

adrCd0039B2:
	bsr	RandomGen_BytewithOffset	;61001BF8
	and.w	#$0007,d0	;02400007
adrCd0039BA:
	move.w	#$0084,d1	;323C0084
	add.w	d0,d1	;D240
	move.b	d1,$0001(a6)	;1D410001
	moveq	#$02,d2	;7402
	cmpi.w	#$0007,d0	;0C400007
	beq.s	adrCd0039DA	;670E
	move.b	#$FA,$0002(a6)	;1D7C00FA0002
	move.b	#$53,$0003(a6)	;1D7C00530003
	moveq	#$04,d2	;7404
adrCd0039DA:
	ror.w	#$01,d7	;E25F
	bpl.s	adrCd0039F4	;6A16
	cmpi.w	#$0005,d0	;0C400005
	bcc.s	adrCd0039EC	;6408
	move.b	#$8C,$00(a6,d2.w)	;1DBC008C2000
	addq.w	#$01,d2	;5242
adrCd0039EC:
	move.b	#$8D,$00(a6,d2.w)	;1DBC008D2000
	addq.w	#$01,d2	;5242
adrCd0039F4:
	rts	;4E75

adrB_0039F6:
	dc.b	$0C	;0C
adrB_0039F7:
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
adrEA003A02:
	dc.w	$048E	;048E
	dc.w	$0796	;0796
	dc.w	$079E	;079E
adrEA003A08:
	dc.w	$03A6	;03A6
	dc.w	$07AE	;07AE
	dc.w	$07B6	;07B6

adrJA003A0E:
	lea	adrEA003DBA.l,a6	;4DF900003DBA
	and.w	#$0007,d0	;02400007
	add.w	#$0074,d0	;06400074
	move.b	d0,$0002(a6)	;1D400002
	bsr	RandomGen_BytewithOffset	;61001B8A
	and.w	#$0007,d0	;02400007
	add.w	#$007C,d0	;0640007C
	move.b	d0,$0004(a6)	;1D400004
	jmp	Print_npc_message.l	;4EF90000D81C

adrB_003A36:
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

adrJA003A52:
	moveq	#$00,d0	;7000
	move.b	$0000(a4),d0	;102C0000
	move.b	adrB_003A36(pc,d0.w),d0	;103B00DC
	add.w	d0,d0	;D040
	lea	AnswerList_00.l,a6	;4DF900003B1A
	add.w	AnswerList_Offsets(pc,d0.w),a6	;DCFB0026
	tst.b	(a6)	;4A16
	bpl.s	ReplyToQuestion	;6A12
	lea	VeryPossibleMsg_0.l,a6	;4DF900003ABA
	bsr	RandomGen_BytewithOffset	;61001B38
	and.w	#$0006,d0	;02400006
	add.w	NoAnswerList_Offsets(pc,d0.w),a6	;DCFB0008
ReplyToQuestion:
	jmp	WriteMessage.l	;4EF90000D03A

NoAnswerList_Offsets:
	dc.w	VeryPossibleMsg_0-VeryPossibleMsg_0	;0000
	dc.w	VeryPossibleMsg_1-VeryPossibleMsg_0	;0015
	dc.w	VeryPossibleMsg_2-VeryPossibleMsg_0	;0028
	dc.w	VeryPossibleMsg_3-VeryPossibleMsg_0	;003F
AnswerList_Offsets:
	dc.w	AnswerList_00-AnswerList_00	;0000
	dc.w	AnswerList_01-AnswerList_00	;0022
	dc.w	AnswerList_02-AnswerList_00	;003F
	dc.w	AnswerList_03-AnswerList_00	;0040
	dc.w	AnswerList_04-AnswerList_00	;004B
	dc.w	AnswerList_05-AnswerList_00	;005D
	dc.w	AnswerList_06-AnswerList_00	;0084
	dc.w	AnswerList_07-AnswerList_00	;009D
	dc.w	AnswerList_08-AnswerList_00	;00BB
	dc.w	AnswerList_09-AnswerList_00	;00BC
	dc.w	AnswerList_10-AnswerList_00	;00BD
	dc.w	AnswerList_11-AnswerList_00	;00DB
	dc.w	AnswerList_12-AnswerList_00	;00FD
	dc.w	AnswerList_13-AnswerList_00	;011A
	dc.w	AnswerList_14-AnswerList_00	;013D
	dc.w	AnswerList_15-AnswerList_00	;014D
	dc.w	AnswerList_16-AnswerList_00	;016C
	dc.w	AnswerList_17-AnswerList_00	;0187
	dc.w	AnswerList_18-AnswerList_00	;019C
	dc.w	AnswerList_19-AnswerList_00	;019D
	dc.w	AnswerList_20-AnswerList_00	;01C4
	dc.w	AnswerList_21-AnswerList_00	;01DE
	dc.w	AnswerList_22-AnswerList_00	;01DF
VeryPossibleMsg_0:
	dc.b	'THAT''S VERY POSSIBLE'	;544841542753205645525920504F535349424C45
	dc.b	$FF	;FF
VeryPossibleMsg_1:
	dc.b	'I CANNOT BUT AGREE'	;492043414E4E4F5420425554204147524545
	dc.b	$FF	;FF
VeryPossibleMsg_2:
	dc.b	'THAT SEEMS VERY LIKELY'	;54484154205345454D532056455259204C494B454C59
	dc.b	$FF	;FF
VeryPossibleMsg_3:
	dc.b	'I''M NOT ABOUT TO ARGUE WITH THEE'	;49274D204E4F542041424F555420544F20415247554520574954482054484545
	dc.b	$FF	;FF
AnswerList_00:
	dc.b	'I DON''T KEEP COMPANY WITH MAGGOTS'	;4920444F4E2754204B45455020434F4D50414E592057495448204D4147474F5453
	dc.b	$FF	;FF
AnswerList_01:
	dc.b	'LOOK TO THE TOWERS MY FRIEND'	;4C4F4F4B20544F2054484520544F57455253204D5920465249454E44
	dc.b	$FF	;FF
AnswerList_02:
	dc.b	$FF	;FF
AnswerList_03:
	dc.b	'INDEED NOT'	;494E44454544204E4F54
	dc.b	$FF	;FF
AnswerList_04:
	dc.b	'MAKE ME THY OFFER'	;4D414B45204D4520544859204F46464552
	dc.b	$FF	;FF
AnswerList_05:
	dc.b	'PICK ON SOMEONE THY OWN SIZE THOU SLUG'	;5049434B204F4E20534F4D454F4E4520544859204F574E2053495A452054484F5520534C5547
	dc.b	$FF	;FF
AnswerList_06:
	dc.b	'I AM THY WORST NIGHTMARE'	;4920414D2054485920574F525354204E494748544D415245
	dc.b	$FF	;FF
AnswerList_07:
	dc.b	'NONE OF THY BUSINESS I''M SURE'	;4E4F4E45204F462054485920425553494E4553532049274D2053555245
	dc.b	$FF	;FF
AnswerList_08:
	dc.b	$FF	;FF
AnswerList_09:
	dc.b	$FF	;FF
AnswerList_10:
	dc.b	'NEWS IS SCARCE IN THESE PARTS'	;4E4557532049532053434152434520494E205448455345205041525453
	dc.b	$FF	;FF
AnswerList_11:
	dc.b	'I HEAR CRYSTALS ARE WORTH SEEKING'	;492048454152204352595354414C532041524520574F525448205345454B494E47
	dc.b	$FF	;FF
AnswerList_12:
	dc.b	'WHO CAN SAY WHAT IS OF NOTE?'	;57484F2043414E205341592057484154204953204F46204E4F54453F
	dc.b	$FF	;FF
AnswerList_13:
	dc.b	'I HEAR ZENDIK IS NOT WHOLLY A WORM'	;492048454152205A454E44494B204953204E4F542057484F4C4C59204120574F524D
	dc.b	$FF	;FF
AnswerList_14:
	dc.b	'GIVE ME A BREAK'	;47495645204D45204120425245414B
	dc.b	$FF	;FF
AnswerList_15:
	dc.b	'THY COINAGE IS WORTHLESS TO ME'	;54485920434F494E41474520495320574F5254484C45535320544F204D45
	dc.b	$FF	;FF
AnswerList_16:
	dc.b	'I DO NOT TRADE IN TRINKETS'	;4920444F204E4F5420545241444520494E205452494E4B455453
	dc.b	$FF	;FF
AnswerList_17:
	dc.b	'I NEED NOT THY TRASH'	;49204E454544204E4F5420544859205452415348
	dc.b	$FF	;FF
AnswerList_18:
	dc.b	$FF	;FF
AnswerList_19:
	dc.b	'MAYBE TRUE BUT THOU SHOULD BE SO LUCKY'	;4D415942452054525545204255542054484F552053484F554C4420424520534F204C55434B59
	dc.b	$FF	;FF
AnswerList_20:
	dc.b	'I TRUST THIS PLEASES THEE'	;49205452555354205448495320504C45415345532054484545
	dc.b	$FF	;FF
AnswerList_21:
	dc.b	$FF	;FF
AnswerList_22:
	dc.b	'WHY DOST BURDEN ME WITH THY COMPANY?'	;57485920444F53542042555244454E204D4520574954482054485920434F4D50414E593F
	dc.b	$FF	;FF

	lea	adrEA003DC0.l,a6	;4DF900003DC0
	move.b	#$33,(a6)	;1CBC0033
	move.b	#$5F,$0001(a6)	;1D7C005F0001
	move.b	#$FE,$0002(a6)	;1D7C00FE0002
	moveq	#$03,d2	;7403
	move.w	$0006(a5),d1	;322D0006
	asl.w	#$04,d1	;E941
	lea	PocketContents.l,a0	;41F90000ED2A
	move.b	$00(a0,d1.w),d1	;12301000
	bne.s	adrCd003D52	;660A
	move.b	#$44,$00(a6,d2.w)	;1DBC00442000
	addq.w	#$01,d2	;5242
	bra.s	adrCd003D74	;6022

adrCd003D52:
	lea	ObjectDefinitionsTable.l,a0	;41F90000E4C4
	add.w	d1,d1	;D241
	add.w	d1,d1	;D241
	add.w	d1,a0	;D0C1
	move.b	(a0)+,$00(a6,d2.w)	;1D982000
	addq.w	#$01,d2	;5242
	move.b	(a0),d0	;1010
	bmi.s	adrCd003D74	;6B0C
	move.b	#$FE,$00(a6,d2.w)	;1DBC00FE2000
	move.b	d0,$01(a6,d2.w)	;1D802001
	addq.w	#$02,d2	;5442
adrCd003D74:
	move.b	#$35,$00(a6,d2.w)	;1DBC00352000
	bsr	RandomGen_BytewithOffset	;61001830
	and.w	#$0007,d0	;02400007
	add.w	#$007C,d0	;0640007C
	move.b	d0,$01(a6,d2.w)	;1D802001
	move.b	#$FF,$02(a6,d2.w)	;1DBC00FF2002
	jsr	Print_npc_message.l	;4EB90000D81C
	move.w	#$0006,$0044(a5)	;3B7C00060044
adrCd003D9C:
	move.w	#$0008,$0042(a5)	;3B7C00080042
	bsr	adrCd003344	;6100F5A0
	bra	adrCd007D6C	;60003FC4

adrEA003DAA:
	dc.w	$5F4B	;5F4B
	dc.w	$3500	;3500
	dc.w	$00FF	;00FF
	dc.w	$4BFA	;4BFA
	dc.w	$5329	;5329
	dc.w	$1C25	;1C25
	dc.w	$FA45	;FA45
	dc.w	$00FF	;00FF
adrEA003DBA:
	dc.w	$335F	;335F
	dc.w	$0035	;0035
	dc.w	$00FF	;00FF
adrEA003DC0:
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
adrEA003DDE:
	dc.w	$02BE	;02BE
	dc.w	$BF01	;BF01
	dc.w	$3007	;3007
	dc.w	$29FB	;29FB
	dc.w	$31FA	;31FA
	dc.w	$4EFA	;4EFA
	dc.w	$4502	;4502
	dc.w	$3163	;3163
adrEA003DEE:
	dc.b	$01	;01
	dc.b	$C0	;C0
	dc.b	$01	;01
	dc.b	$C1	;C1
	dc.b	$02	;02
	dc.b	$29	;29
	dc.b	$C2	;C2
	dc.b	$01	;01
	dc.b	$84	;84
adrEA003DF7:
	dc.b	$49	;49
	dc.b	$FB	;FB
	dc.b	$4A	;4A
	dc.b	$FA	;FA
	dc.b	$53	;53
	dc.b	$FF	;FF
adrEA003DFD:
	dc.b	$18	;18
	dc.b	$8B	;8B
	dc.b	$1A	;1A
	dc.b	$FA	;FA
	dc.b	$3F	;3F
	dc.b	$FF	;FF
adrEA003E03:
	dc.b	$CE	;CE
	dc.b	$8D	;8D
	dc.b	$FA	;FA
	dc.b	$4D	;4D
	dc.b	$8D	;8D
	dc.b	$99	;99
	dc.b	$00	;00
	dc.b	$FF	;FF
adrEA003E0B:
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
adrEA003E15:
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
adrEA003E26:
	dc.b	$CC	;CC
	dc.b	$1A	;1A
	dc.b	$1D	;1D
	dc.b	$2F	;2F
	dc.b	$43	;43
	dc.b	$CD	;CD
	dc.b	$FA	;FA
	dc.b	$3F	;3F
	dc.b	$FF	;FF
WhereIsThisMsg:
	dc.b	'WHERE IS THIS OF WHICH THOU HAST SPOKEN?'	;57484552452049532054484953204F462057484943482054484F5520484153542053504F4B454E3F
	dc.b	$FF	;FF
adrEA003E58:
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
adrEA003E65:
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
adrEA003E70:
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
adrEA003E7B:
	dc.b	$27	;27
	dc.b	$1A	;1A
	dc.b	$60	;60
	dc.b	$1C	;1C
	dc.b	$57	;57
	dc.b	$FA	;FA
	dc.b	$3F	;3F
	dc.b	$FF	;FF
ComeJoinMsg:
	dc.b	'COME JOIN MY MERRY BAND'	;434F4D45204A4F494E204D59204D455252592042414E44
	dc.b	$FF	;FF
	dc.b	$00	;00

adrJA003E9C:
	lea	adrEA0041D4.l,a6	;4DF9000041D4
	jsr	Print_timed_message.l	;4EB90000D86A
	move.b	#$FF,$0050(a5)	;1B7C00FF0050
	lea	Player1_Data.l,a1	;43F90000EE7C
	btst	#$00,(a5)	;08150000
	bne.s	adrCd003EC0	;6606
	lea	Player2_Data.l,a1	;43F90000EEDE
adrCd003EC0:
	btst	#$06,$0018(a1)	;082900060018
	bne	adrCd003F58	;66000090
	move.b	(a1),d0	;1011
	and.b	#$FE,d0	;020000FE
	bne	adrCd003F58	;66000086
	move.w	$0058(a5),d0	;302D0058
	cmp.w	$0058(a1),d0	;B0690058
	bne	adrCd003F58	;6600007A
	lea	adrEA003DC0.w,a6	;4DF83DC0	;Short Absolute converted to symbol!
	move.b	#$CA,(a6)+	;1CFC00CA
	move.b	#$C4,(a6)+	;1CFC00C4
	move.l	$001C(a1),d1	;2229001C
	move.l	$001C(a5),d0	;202D001C
	bsr	adrCd0013A8	;6100D4B2
	cmpi.w	#$0005,d2	;0C420005
	bcs.s	adrCd003F0C	;650E
	cmpi.w	#$0009,d2	;0C420009
	bcs.s	adrCd003F08	;6504
	move.b	#$8E,(a6)+	;1CFC008E
adrCd003F08:
	move.b	#$C5,(a6)+	;1CFC00C5
adrCd003F0C:
	move.b	#$16,(a6)+	;1CFC0016
	move.b	#$FA,(a6)+	;1CFC00FA
	move.b	#$53,(a6)+	;1CFC0053
	move.b	#$1C,(a6)+	;1CFC001C
	move.b	#$25,(a6)+	;1CFC0025
	moveq	#$00,d3	;7600
	move.w	d0,d2	;3400
	swap	d0	;4840
	cmp.w	d0,d2	;B440
	bcs.s	adrCd003F2E	;6504
	moveq	#$01,d3	;7601
	swap	d1	;4841
adrCd003F2E:
	swap	d1	;4841
	tst.w	d1	;4A41
	bmi.s	adrCd003F36	;6B02
	addq.b	#$02,d3	;5403
adrCd003F36:
	add.w	$0020(a1),d3	;D6690020
	and.w	#$0003,d3	;02430003
	add.w	#$00C6,d3	;064300C6
	move.b	d3,(a6)+	;1CC3
	move.b	#$FF,(a6)	;1CBC00FF
	lea	adrEA003DC0.w,a6	;4DF83DC0	;Short Absolute converted to symbol!
	move.l	a5,-(sp)	;2F0D
	move.l	a1,a5	;2A49
	jsr	Print_timed_message.l	;4EB90000D86A
	move.l	(sp)+,a5	;2A5F
adrCd003F58:
	bra	adrCd00332A	;6000F3D0

adrJA003F5C:
	moveq	#$15,d7	;7E15
	bra.s	adrCd003F66	;6006

adrJA003F60:
	clr.b	$0050(a5)	;422D0050
	moveq	#$13,d7	;7E13
adrCd003F66:
	tst.b	$004E(a5)	;4A2D004E
	beq	adrCd0040A0	;67000134
	bsr	adrCd00417E	;6100020E
	move.w	d7,-(sp)	;3F07
	move.b	d0,$004F(a5)	;1B40004F
	move.l	$001C(a5),d7	;2E2D001C
	move.w	$0020(a5),d6	;3C2D0020
	bsr	adrCd007A44	;61003AC2
	bcc.s	adrCd003F9C	;6416
	addq.w	#$02,sp	;544F
	lea	adrEA0041BB.l,a6	;4DF9000041BB
	move.b	$004F(a5),(a6)	;1CAD004F
	jsr	Print_timed_message.l	;4EB90000D86A
	bra	adrCd00332A	;6000F390

adrCd003F9C:
	bset	#$07,$01(a6,d2.w)	;08F600072001
	move.b	$004F(a5),d0	;102D004F
	bsr	adrCd004004	;6100005C
	lea	adrEA0041C6.l,a6	;4DF9000041C6
	move.w	(sp)+,d1	;321F
	cmpi.w	#$0015,d1	;0C410015
	beq.s	adrCd003FCE	;6716
	bsr	adrCd004054	;6100009A
	move.b	$004F(a5),d0	;102D004F
	bset	#$05,d0	;08C00005
	move.b	d0,$18(a5,d1.w)	;1B801018
	lea	adrEA0041C1.l,a6	;4DF9000041C1
adrCd003FCE:
	move.b	$004F(a5),d0	;102D004F
	move.b	d0,(a6)	;1C80
	bsr	adrCd006660	;6100268A
	move.b	d7,$0017(a4)	;19470017
	swap	d7	;4847
	move.b	d7,$0016(a4)	;19470016
	move.b	$0059(a5),$001A(a4)	;196D0059001A
	move.b	$0021(a5),$0018(a4)	;196D00210018
	move.b	CurrentTower+$1.l,$001F(a4)	;19790000EE2F001F
	jsr	Print_timed_message.l	;4EB90000D86A
	bsr	adrCd008246	;61004248
	bra	adrCd00332A	;6000F328

adrCd004004:
	bsr	adrCd004092	;6100008C
	move.b	#$FF,$26(a5,d2.w)	;1BBC00FF2026
	cmp.w	$0016(a5),d2	;B46D0016
	bne.s	adrCd00401A	;6606
	move.w	#$FFFF,$0016(a5)	;3B7CFFFF0016
adrCd00401A:
	bsr	adrCd004078	;6100005C
	move.w	d1,d3	;3601
adrCd004020:
	move.b	$19(a5,d1.w),$18(a5,d1.w)	;1BB510191018
	addq.w	#$01,d1	;5241
	cmpi.w	#$0003,d1	;0C410003
	bcs.s	adrCd004020	;65F2
	move.b	#$FF,$001B(a5)	;1B7C00FF001B
	cmp.b	#$03,$0015(a5)	;0C2D00030015
	bne.s	adrCd004052	;6616
	cmp.b	$000F(a5),d3	;B62D000F
	bne.s	adrCd00404C	;660A
	move.l	d7,-(sp)	;2F07
	bsr	Click_OpenInventory	;61002BAA
	move.l	(sp)+,d7	;2E1F
	rts	;4E75

adrCd00404C:
	bcc.s	adrCd004052	;6404
	subq.b	#$01,$000F(a5)	;532D000F
adrCd004052:
	rts	;4E75

adrCd004054:
	moveq	#$00,d1	;7200
adrCd004056:
	tst.b	$18(a5,d1.w)	;4A351018
	bmi.s	adrCd004064	;6B08
	addq.w	#$01,d1	;5241
	cmpi.w	#$0003,d1	;0C410003
	bcs.s	adrCd004056	;65F2
adrCd004064:
	rts	;4E75

adrCd004066:
	lea	Player1_Data.l,a5	;4BF90000EE7C
	bsr.s	adrCd004078	;610A
	tst.w	d1	;4A41
	bpl.s	adrCd004064	;6AF2
	lea	Player2_Data.l,a5	;4BF90000EEDE
adrCd004078:
	move.w	d2,-(sp)	;3F02
	moveq	#$03,d1	;7203
adrLp00407C:
	move.b	$18(a5,d1.w),d2	;14351018
	bmi.s	adrCd00408A	;6B08
	and.w	#$000F,d2	;0242000F
	cmp.b	d2,d0	;B002
	beq.s	adrCd00408E	;6704
adrCd00408A:
	dbra	d1,adrLp00407C	;51C9FFF0
adrCd00408E:
	move.w	(sp)+,d2	;341F
	rts	;4E75

adrCd004092:
	moveq	#$03,d2	;7403
adrLp004094:
	cmp.b	$26(a5,d2.w),d0	;B0352026
	beq.s	adrCd00409E	;6704
	dbra	d2,adrLp004094	;51CAFFF8
adrCd00409E:
	rts	;4E75

adrCd0040A0:
	bsr	adrJA007CA6	;61003C04
	tst.w	d2	;4A42
	bne.s	adrCd0040BC	;6614
	lea	adrEA0041CD.l,a6	;4DF9000041CD
	move.b	d7,$0005(a6)	;1D470005
adrCd0040B2:
	clr.w	$0042(a5)	;426D0042
	jmp	Print_timed_message.l	;4EF90000D86A

adrCd0040BC:
	move.w	#$0001,$0044(a5)	;3B7C00010044
	bra.s	adrCd0040CA	;6006

adrCd0040C4:
	move.w	#$0003,$0044(a5)	;3B7C00030044
adrCd0040CA:
	move.b	#$01,$004E(a5)	;1B7C0001004E
	lea	adrEA0041A0.l,a6	;4DF9000041A0
	move.b	d7,$0007(a6)	;1D470007
	jsr	Print_fix_message.l	;4EB90000D870
	bra	adrCd007D6C	;60003C8A

adrJA0040E4:
	tst.b	$004E(a5)	;4A2D004E
	bne.s	adrCd004114	;662A
	moveq	#$12,d7	;7E12
	moveq	#$03,d1	;7203
	moveq	#$00,d2	;7400
adrLp0040F0:
	move.b	$18(a5,d1.w),d0	;10351018
	bmi.s	adrCd004104	;6B0E
	btst	#$06,d0	;08000006
	bne.s	adrCd004104	;6608
	btst	#$05,d0	;08000005
	beq.s	adrCd004104	;6702
	addq.w	#$01,d2	;5242
adrCd004104:
	dbra	d1,adrLp0040F0	;51C9FFEA
	tst.w	d2	;4A42
	bne.s	adrCd0040C4	;66B8
	lea	adrEA0041E9.l,a6	;4DF9000041E9
	bra.s	adrCd0040B2	;609E

adrCd004114:
	bsr	adrCd00417E	;61000068
	move.b	d0,$0053(a5)	;1B400053
	and.b	#$0F,$0053(a5)	;022D000F0053
	move.b	#$01,$0014(a5)	;1B7C00010014
	lea	adrEA0041E3.l,a6	;4DF9000041E3
	move.b	$0053(a5),$0004(a6)	;1D6D00530004
	jsr	Print_fix_message.l	;4EB90000D870
	move.w	#$0101,$0040(a5)	;3B7C01010040
	bra	adrCd00332A	;6000F1E8

adrJA004144:
	moveq	#$14,d7	;7E14
	lea	adrEA0041B2.l,a6	;4DF9000041B2
	moveq	#$10,d3	;7610
	bra.s	adrCd00415A	;600A

adrJA004150:
	lea	adrEA0041AB.l,a6	;4DF9000041AB
	moveq	#$11,d7	;7E11
	moveq	#$00,d3	;7600
adrCd00415A:
	tst.b	$004E(a5)	;4A2D004E
	beq	adrCd0040A0	;6700FF40
	bsr.s	adrCd00417E	;611A
	bclr	#$04,$19(a5,d2.w)	;08B500042019
	or.b	$19(a5,d2.w),d3	;86352019
	move.b	d3,$19(a5,d2.w)	;1B832019
	move.b	d0,(a6)	;1C80
	jsr	Print_timed_message.l	;4EB90000D86A
	bra	adrCd00332A	;6000F1AE

adrCd00417E:
	lea	adrEA007C24.l,a1	;43F900007C24
	and.w	#$0003,d1	;02410003
	move.w	d1,d2	;3401
	add.w	d1,d1	;D241
	move.b	$00(a1,d1.w),d0	;10311000
	bmi.s	adrCd004196	;6B04
	lsr.w	#$01,d1	;E249
	rts	;4E75

adrCd004196:
	move.w	#$FFFF,$000C(a5)	;3B7CFFFF000C
	addq.w	#$04,sp	;584F
	rts	;4E75

adrEA0041A0:
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
adrEA0041AB:
	dc.b	$00	;00
	dc.b	$1D	;1D
	dc.b	$FA	;FA
	dc.b	$53	;53
	dc.b	$1E	;1E
	dc.b	$1F	;1F
	dc.b	$FF	;FF
adrEA0041B2:
	dc.b	$00	;00
	dc.b	$21	;21
	dc.b	$FA	;FA
	dc.b	$53	;53
	dc.b	$22	;22
	dc.b	$23	;23
	dc.b	$FB	;FB
	dc.b	$4A	;4A
	dc.b	$FF	;FF
adrEA0041BB:
	dc.b	$00	;00
	dc.b	$35	;35
	dc.b	$17	;17
	dc.b	$1C	;1C
	dc.b	$30	;30
	dc.b	$FF	;FF
adrEA0041C1:
	dc.b	$00	;00
	dc.b	$13	;13
	dc.b	$FA	;FA
	dc.b	$53	;53
	dc.b	$FF	;FF
adrEA0041C6:
	dc.b	$00	;00
	dc.b	$24	;24
	dc.b	$FA	;FA
	dc.b	$53	;53
	dc.b	$25	;25
	dc.b	$26	;26
	dc.b	$FF	;FF
adrEA0041CD:
	dc.b	$1A	;1A
	dc.b	$27	;27
	dc.b	$28	;28
	dc.b	$36	;36
	dc.b	$1C	;1C
	dc.b	$00	;00
	dc.b	$FF	;FF
adrEA0041D4:
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
adrEA0041DE:
	dc.b	$00	;00
	dc.b	$32	;32
	dc.b	$25	;25
	dc.b	$26	;26
	dc.b	$FF	;FF
adrEA0041E3:
	dc.b	$12	;12
	dc.b	$FB	;FB
	dc.b	$4A	;4A
	dc.b	$34	;34
	dc.b	$00	;00
	dc.b	$FF	;FF
adrEA0041E9:
	dc.b	$20	;20
	dc.b	$35	;35
	dc.b	$36	;36
	dc.b	$FF	;FF
adrEA0041ED:
	dc.b	$37	;37
	dc.b	$12	;12
	dc.b	$FB	;FB
	dc.b	$4A	;4A
	dc.b	$38	;38
	dc.b	$FF	;FF
adrEA0041F3:
	dc.b	$39	;39
	dc.b	$35	;35
	dc.b	$3D	;3D
	dc.b	$FB	;FB
	dc.b	$3A	;3A
	dc.b	$3B	;3B
	dc.b	$FF	;FF

adrCd0041FA:
	lea	adrEA016B4C.l,a4	;49F900016B4C
	btst	#$00,(a5)	;08150000
	beq.s	adrCd00420A	;6704
	add.w	#$0010,a4	;D8FC0010
adrCd00420A:
	rts	;4E75

Click_CommsAndOptions:
	move.w	$0004(a5),d1	;322D0004
	sub.w	$0008(a5),d1	;926D0008
	cmpi.w	#$0037,d1	;0C410037
	bcs.s	adrCd004234	;651A
	move.w	$0002(a5),d1	;322D0002
	lsr.w	#$05,d1	;EA49
	and.w	#$0003,d1	;02410003
	addq.w	#$01,d1	;5241
adrCd004226:
	bchg	d1,$003E(a5)	;036D003E
	move.w	d1,d7	;3E01
	bsr	adrCd007EF0	;61003CC2
	bra	adrCd007ED2	;60003CA0

adrCd004234:
	moveq	#$00,d1	;7200
	cmp.w	#$0030,$0002(a5)	;0C6D00300002
	bcs.s	adrCd004226	;65E8
	move.b	$003E(a5),d0	;102D003E
	and.b	#$0E,d0	;0200000E
	bne.s	ExitPause	;6670
	clr.w	$0042(a5)	;426D0042
	clr.w	$0044(a5)	;426D0044
	move.w	#$FFFF,$0040(a5)	;3B7CFFFF0040
	clr.b	$003E(a5)	;422D003E
	bra	adrCd007B50	;600038F4

Click_PauseGame:
	move.l	adrEA00EE36.l,d1	;22390000EE36
	move.w	#$FFFF,Paused_Marker.l	;33FCFFFF00008C1C
	lea	_custom+color.l,a0	;41F900DFF180
	move.w	#$0400,(a0)	;30BC0400
	move.w	#$0400,$001E(a0)	;317C0400001E
.PauseLoop:
	move.b	adrB_00EE7D.l,d0	;10390000EE7D
	or.b	adrB_00EEDF.l,d0	;80390000EEDF
	bpl.s	.PauseLoop	;6AF2
	clr.w	(a0)	;4250
	clr.w	$001E(a0)	;4268001E
	move.l	d1,adrEA00EE36.l	;23C10000EE36
	and.b	#$7F,adrB_00EE7D.l	;0239007F0000EE7D
	and.b	#$7F,adrB_00EEDF.l	;0239007F0000EEDF
	clr.b	adrB_00EED2.l	;42390000EED2
	clr.b	adrB_00EF34.l	;42390000EF34
	clr.w	Paused_Marker.l	;427900008C1C
ExitPause:
	rts	;4E75

adrCd0042BA:
	lea	Player1_Data.l,a5	;4BF90000EE7C
	bsr	adrCd00430A	;61000048
	bsr	adrCd007B08	;61003842
	btst	#$06,$0018(a5)	;082D00060018
	beq.s	adrCd0042D4	;6704
	bsr	adrCd00270E	;6100E43C
adrCd0042D4:
	tst.w	MultiPlayer.l	;4A790000EE30
	bmi.s	adrCd0042F6	;6B1A
	lea	Player2_Data.l,a5	;4BF90000EEDE
	bsr	adrCd00430A	;61000026
	bsr	adrCd007B22	;6100383A
	btst	#$06,$0018(a5)	;082D00060018
	beq.s	adrCd0042F6	;6704
	bsr	adrCd00270E	;6100E41A
adrCd0042F6:
	jsr	adrCd008CCA.l	;4EB900008CCA
	bsr	adrCd008D88	;61004A8A
	move.w	#$FFFF,adrB_008C1E.l	;33FCFFFF00008C1E
	rts	;4E75

adrCd00430A:
	and.b	#$01,(a5)	;02150001
	clr.b	$0056(a5)	;422D0056
	clr.w	$0014(a5)	;426D0014
	clr.b	$003C(a5)	;422D003C
	clr.b	$003E(a5)	;422D003E
	clr.b	$0050(a5)	;422D0050
	move.w	#$FFFF,$000C(a5)	;3B7CFFFF000C
	rts	;4E75

Click_LoadSaveGame:
	move.l	adrEA00EE36.l,-(sp)	;2F390000EE36
	clr.w	adrB_008C1E.l	;427900008C1E
	move.l	#$00067D00,screen_ptr.l	;23FC00067D0000008D36
	move.l	#$00060000,framebuffer_ptr.l	;23FC0006000000008D3A
	lea	Player1_Data.l,a5	;4BF90000EE7C
	lea	F1_F2_F10_Msg.l,a6	;4DF9000044C4
	jsr	WriteText.l	;4EB90000D08E
	tst.w	MultiPlayer.l	;4A790000EE30
	bne.s	.skipPlayer2	;6612
	lea	Player2_Data.l,a5	;4BF90000EEDE
	lea	F1_F2_F10_Msg.l,a6	;4DF9000044C4
	jsr	WriteText.l	;4EB90000D08E
.skipPlayer2:
	clr.b	KeyboardKeyCode.w	;423805C9	;Short Absolute converted to symbol!
	bsr	adrCd008CCA	;6100494E
.PickLoadSaveGame_Loop:
	move.b	KeyboardKeyCode.w,d0	;103805C9	;Short Absolute converted to symbol!
	cmpi.b	#$50,d0	;0C000050
	beq.s	LoadGame	;671C
	cmpi.b	#$51,d0	;0C000051
	beq	SaveGame	;6700002C
	cmpi.b	#$59,d0	;0C000059
	bne.s	.PickLoadSaveGame_Loop	;66E8
adrCd004396:
	move.l	(sp)+,adrEA00EE36.l	;23DF0000EE36
	clr.b	KeyboardKeyCode.w	;423805C9	;Short Absolute converted to symbol!
	bra	adrCd0042BA	;6000FF18

LoadGame:
	moveq	#$00,d0	;7000
	bsr	adrCd0043E2	;6100003A
	bcs.s	adrCd004396	;65EA
	bsr	adrCd004440	;61000092
	tst.l	d0	;4A80
	bmi.s	LoadGame	;6BF0
	bsr	adrCd000B68	;6100C7B2
	bra.s	adrCd004396	;60DC

SaveGame:
	moveq	#$01,d0	;7001
	bsr	adrCd0043E2	;61000024
	bcs.s	adrCd004396	;65D4
	bsr	adrCd004480	;610000BC
	tst.l	d0	;4A80
	bmi.s	SaveGame	;6BF0
	bra.s	adrCd004396	;60CA

AwaitDisk:
	lea	InsertLoadDiskMsg.l,a6	;4DF9000044E5
	tst.w	d0	;4A40
	beq.s	.PickLoadSaveMessage	;6706
	lea	InsertSaveDiskMsg.l,a6	;4DF90000450D
.PickLoadSaveMessage:
	jmp	WriteText.l	;4EF90000D08E

adrCd0043E2:
	lea	Player1_Data.l,a5	;4BF90000EE7C
	tst.w	MultiPlayer.l	;4A790000EE30
	bne.s	.skipPlayer2	;660C
	move.w	d0,-(sp)	;3F00
	bsr.s	AwaitDisk	;61D8
	move.w	(sp)+,d0	;301F
	lea	Player2_Data.l,a5	;4BF90000EEDE
.skipPlayer2:
	bsr.s	AwaitDisk	;61CE
	clr.b	KeyboardKeyCode.w	;423805C9	;Short Absolute converted to symbol!
	bsr	adrCd008CCA	;610048C6
LoadSaveGame_Loop:
	move.b	KeyboardKeyCode.w,d0	;103805C9	;Short Absolute converted to symbol!
	cmpi.b	#$44,d0			;0C000044
	beq.s	LoadSaveGame_Action		;6712
	cmpi.b	#$43,d0			;0C000043
	beq.s	LoadSaveGame_Action		;670C
	cmpi.b	#$59,d0			;0C000059
	bne.s	LoadSaveGame_Loop		;66EA
	sub.b	#$FF,d0			;040000FF
	rts				;4E75

LoadSaveGame_Action:
	moveq	#$3C,d0			;703C
	tst.w	MultiPlayer.l		;4A790000EE30
	beq.s	adrCd00442E		;6702
	moveq	#$46,d0			;7046
adrCd00442E:
	move.w	d0,adrW_00447E.l	;33C00000447E
	rts				;4E75

adrCd004436:
	jsr	adrCd008878.l		;4EB900008878
	moveq	#-$01,d0		;70FF
	rts				;4E75

adrCd004440:
	jsr	CopyProtection.l	;4EB90000D138
	tst.l	d0	;4A80
	beq.s	adrCd004436	;67EC
	move.l	screen_ptr.l,adrL_008520.l	;23F900008D3600008520
	jsr	adrCd008702.l	;4EB900008702
	move.w	adrW_00447E.l,d7	;3E390000447E
	jsr	adrCd00888E.l	;4EB90000888E
	lea	CharacterStats.l,a0	;41F90000EB2A
	moveq	#$08,d0	;7008
	jsr	adrCd0086C0.l	;4EB9000086C0
	jsr	adrCd008878.l	;4EB900008878
	moveq	#$00,d0	;7000
	rts	;4E75

adrW_00447E:
	dc.w	$0000	;0000

adrCd004480:
	jsr	CopyProtection.l	;4EB90000D138
	tst.l	d0	;4A80
	beq.s	adrCd004436	;67AC
	move.l	screen_ptr.l,adrL_008520.l	;23F900008D3600008520
	jsr	adrCd008702.l	;4EB900008702
	move.w	adrW_00447E.w,d7	;3E38447E	;Short Absolute converted to symbol!
	jsr	adrCd00888E.l	;4EB90000888E
	lea	CharacterStats.l,a0	;41F90000EB2A
	moveq	#$00,d0	;7000
	move.w	adrW_00447E.w,d0	;3038447E	;Short Absolute converted to symbol!
	moveq	#$00,d1	;7200
	moveq	#$08,d7	;7E08
	jsr	adrLp008524.l	;4EB900008524
	jsr	adrCd008878.l	;4EB900008878
	moveq	#$00,d0	;7000
	rts	;4E75

F1_F2_F10_Msg:
	dc.b	'F1 - LOAD, F2 - SAVE, F10 - EXIT'	;4631202D204C4F41442C204632202D20534156452C20463130202D2045584954
	dc.b	$FF	;FF
InsertLoadDiskMsg:
	dc.b	'INSERT LOAD DISK AND RETURN, F10 - EXIT'	;494E53455254204C4F4144204449534B20414E442052455455524E2C20463130202D2045584954
	dc.b	$FF	;FF
InsertSaveDiskMsg:
	dc.b	'INSERT SAVE DISK AND RETURN, F10 - EXIT'	;494E534552542053415645204449534B20414E442052455455524E2C20463130202D2045584954
	dc.b	$FF	;FF
	dc.b	$00	;00

Click_SleepParty:
	move.b	#$03,$004F(a5)	;1B7C0003004F
	clr.w	$0014(a5)	;426D0014
	move.w	#$FFFF,$0042(a5)	;3B7CFFFF0042
	move.w	#$FFFF,$0040(a5)	;3B7CFFFF0040
	move.b	#$FF,$0035(a5)	;1B7C00FF0035
	moveq	#$03,d7	;7E03
adrLp004554:
	move.b	$18(a5,d7.w),d0	;10357018
	and.w	#$00C0,d0	;024000C0
	bne.s	adrCd004574	;6616
	move.b	$18(a5,d7.w),d0	;10357018
	bsr	adrCd006660	;610020FC
	clr.b	$0011(a4)	;422C0011
	move.b	#$FF,$0013(a4)	;197C00FF0013
	clr.b	$0014(a4)	;422C0014
adrCd004574:
	dbra	d7,adrLp004554	;51CFFFDE
	bsr	adrCd007B50	;610035D6
	bsr	adrCd008278	;61003CFA
adrCd004580:
	bsr	adrCd002734	;6100E1B2
	and.b	#$01,(a5)	;02150001
	bset	#$02,(a5)	;08D50002
	move.b	#$32,$003F(a5)	;1B7C0032003F
	move.b	#$02,$0014(a5)	;1B7C00020014
	clr.b	$004E(a5)	;422D004E
	move.b	#$01,$0052(a5)	;1B7C00010052
	clr.b	$004A(a5)	;422D004A
	tst.b	$004B(a5)	;4A2D004B
	bmi.s	adrCd0045B2	;6B06
	move.w	#$00FF,$004A(a5)	;3B7C00FF004A
adrCd0045B2:
	lea	ThouArtAsleep.l,a6	;4DF9000045C4
	jsr	Print_fflim_text.l	;4EB90000D0C6
	jmp	adrCd00CF96.l	;4EF90000CF96

ThouArtAsleep:
	dc.b	$FC	;FC
	dc.b	$10	;10
	dc.b	$04	;04
	dc.b	$FE	;FE
	dc.b	$0A	;0A
	dc.b	$FD	;FD
	dc.b	$00	;00
	dc.b	'THOU ART'	;54484F5520415254
	dc.b	$FC	;FC
	dc.b	$11	;11
	dc.b	$06	;06
	dc.b	'ASLEEP'	;41534C454550
	dc.b	$FF	;FF
	dc.b	$00	;00

adrCd0045DE:
	move.l	a4,-(sp)	;2F0C
	asl.w	#$02,d0	;E540
	lea	adrEA00462A.l,a6	;4DF90000462A
	add.w	d0,a6	;DCC0
	link	a3,#-$0020	;4E53FFE0
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	$000A(a5),a0	;D0ED000A
	add.w	#$01EC,a0	;D0FC01EC
	move.l	a0,-$0008(a3)	;2748FFF8
	lea	_GFX_Fairy.l,a1	;43F900044ED0
	moveq	#$08,d4	;7808
	moveq	#$05,d5	;7A05
	moveq	#$28,d7	;7E28
	moveq	#$00,d6	;7C00
	bsr	adrCd00AD34	;61006724
	lea	_GFX_Fairy.l,a1	;43F900044ED0
	moveq	#$17,d4	;7817
	moveq	#$05,d5	;7A05
	moveq	#$28,d7	;7E28
	moveq	#-$01,d6	;7CFF
	bsr	adrCd00AD34	;61006712
	unlk	a3	;4E5B
	move.l	(sp)+,a4	;285F
	rts	;4E75

adrEA00462A:
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
adrEA00463E:
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

adrCd00465E:
	move.b	$004E(a5),d0	;102D004E
	beq.s	adrCd004674	;6710
	subq.b	#$01,d0	;5300
	beq	adrCd004748	;670000E0
	subq.b	#$01,d0	;5300
	beq	adrCd004870	;67000202
	bra	adrCd0049D6	;60000364

adrCd004674:
	tst.b	$003F(a5)	;4A2D003F
	bmi	adrCd004AFE	;6B000484
	subq.b	#$01,$003F(a5)	;532D003F
	bpl	adrCd004AFE	;6A00047C
	moveq	#$00,d7	;7E00
adrCd004686:
	move.b	$004F(a5),d7	;1E2D004F
	bmi	adrCd004AFE	;6B000472
	move.b	$18(a5,d7.w),d0	;10357018
	and.w	#$00E0,d0	;024000E0
	bne.s	adrCd0046C6	;662E
	move.b	$18(a5,d7.w),d0	;10357018
	and.w	#$000F,d0	;0240000F
	lea	adrEA004B14.l,a6	;4DF900004B14
	move.b	d0,(a6)	;1C80
	bsr	adrCd006660	;61001FB6
	cmp.b	#$EC,$001C(a4)	;0C2C00EC001C
	bcs.s	adrCd0046BC	;6508
	cmp.b	#$0E,(a4)	;0C14000E
	bcs	adrCd004AE8	;6500042E
adrCd0046BC:
	move.b	$001E(a4),d0	;102C001E
	and.w	#$007F,d0	;0240007F
	bne.s	adrCd0046CC	;6606
adrCd0046C6:
	subq.b	#$01,$004F(a5)	;532D004F
	bra.s	adrCd004686	;60BA

adrCd0046CC:
	bsr	adrCd002734	;6100E066
	jsr	adrCd00CF96.l	;4EB90000CF96
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	$000A(a5),a0	;D0ED000A
	add.w	#$0A86,a0	;D0FC0A86
	moveq	#$03,d7	;7E03
adrLp0046E6:
	move.w	d7,d0	;3007
	eor.w	#$0003,d0	;0A400003
	add.w	#$0064,d0	;06400064
	jsr	adrCd00CAEA.l	;4EB90000CAEA
	dbra	d7,adrLp0046E6	;51CFFFEE
	moveq	#$74,d0	;7074
	addq.w	#$02,a0	;5448
	move.w	$0012(a5),d3	;362D0012
	jsr	adrCd00CAEA.l	;4EB90000CAEA
	moveq	#$04,d0	;7004
	bsr	adrCd0045DE	;6100FED2
	or.b	#$40,$0054(a5)	;002D00400054
	jsr	InitialiseText.l	;4EB90000D09A
	moveq	#$00,d7	;7E00
	move.b	$004F(a5),d7	;1E2D004F
	move.b	$18(a5,d7.w),d0	;10357018
	and.w	#$000F,d0	;0240000F
	clr.b	$0052(a5)	;422D0052
	jsr	Print_wordstext.l	;4EB90000D7E6
	lea	MayBuySpellMsg.l,a6	;4DF900004A84
	jsr	adrLp00CFDA.l	;4EB90000CFDA
	move.b	#$01,$004E(a5)	;1B7C0001004E
	bra	adrCd004AFE	;600003B8

adrCd004748:
	bclr	#$07,$0001(a5)	;08AD00070001
	beq	adrCd004AFE	;670003AE
	move.l	$0002(a5),d1	;222D0002
	sub.w	$0008(a5),d1	;926D0008
	cmpi.b	#$42,d1	;0C010042
	bcs	adrCd004AFE	;6500039E
	cmpi.b	#$54,d1	;0C010054
	bcc	adrCd004AFE	;64000396
	swap	d1	;4841
	sub.b	#$70,d1	;04010070
	bcs	adrCd004AFE	;6500038C
	cmpi.b	#$40,d1	;0C010040
	bcs.s	adrCd004792	;6518
	sub.b	#$50,d1	;04010050
	bcs	adrCd004AFE	;6500037E
	cmpi.b	#$10,d1	;0C010010
	bcc	adrCd004AFE	;64000376
	subq.b	#$01,$004F(a5)	;532D004F
	bra	adrCd004580	;6000FDF0

adrCd004792:
	lsr.w	#$04,d1	;E849
	move.w	d1,-(sp)	;3F01
	bsr	adrCd002734	;6100DF9C
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	$000A(a5),a0	;D0ED000A
	add.w	#$0A90,a0	;D0FC0A90
	moveq	#$74,d0	;7074
	move.w	$0012(a5),d3	;362D0012
	jsr	adrCd00CAEA.l	;4EB90000CAEA
	move.w	(sp),d0	;3017
	bsr	adrCd0045DE	;6100FE26
	moveq	#$00,d0	;7000
	move.b	$004F(a5),d0	;102D004F
	move.b	$18(a5,d0.w),d0	;10350018
	bsr	adrCd006660	;61001E9A
	move.l	$000C(a4),d7	;2E2C000C
	lea	adrEA00463E.w,a6	;4DF8463E	;Short Absolute converted to symbol!
	move.w	(sp),d1	;3217
	asl.w	#$03,d1	;E741
	add.w	d1,a6	;DCC1
	moveq	#$00,d0	;7000
	moveq	#-$01,d2	;74FF
	moveq	#$07,d1	;7207
adrLp0047DC:
	move.b	$00(a6,d1.w),d0	;10361000
	eor.b	#$1F,d0	;0A00001F
	btst	d0,d7	;0107
	bne.s	adrCd0047F4	;660C
	eor.b	#$1F,d0	;0A00001F
	move.w	d0,d2	;3400
	tst.l	d2	;4A82
	bpl.s	adrCd004802	;6A10
	swap	d2	;4842
adrCd0047F4:
	dbra	d1,adrLp0047DC	;51C9FFE6
	move.w	#$FFFF,$0044(a5)	;3B7CFFFF0044
	tst.l	d2	;4A82
	bmi.s	adrCd004814	;6B12
adrCd004802:
	move.b	d2,$0045(a5)	;1B420045
	swap	d2	;4842
	move.b	d2,$0044(a5)	;1B420044
	lea	SelectNewSpellMsg.l,a6	;4DF900004AA2
	bra.s	adrCd00481A	;6006

adrCd004814:
	lea	ThouHastAllMsg.l,a6	;4DF900004AB9
adrCd00481A:
	bsr	adrCd0049AE	;61000192
	move.w	(sp)+,d1	;321F
	lea	adrEA00463A.w,a6	;4DF8463A	;Short Absolute converted to symbol!
	move.b	$00(a6,d1.w),adrB_00D92B.l	;13F610000000D92B
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	$000A(a5),a0	;D0ED000A
	add.w	#$03D2,a0	;D0FC03D2
	move.b	$0044(a5),d0	;102D0044
	bsr	adrCd004852	;61000012
	move.b	$0045(a5),d0	;102D0045
	bsr	adrCd004852	;6100000A
	move.b	#$02,$004E(a5)	;1B7C0002004E
	rts	;4E75

adrCd004852:
	tst.b	d0	;4A00
	bmi.s	adrCd00486E	;6B18
	and.w	#$00FF,d0	;024000FF
	move.l	a0,-(sp)	;2F08
	bsr	adrCd00C2D4	;61007A76
	moveq	#$07,d6	;7C07
	jsr	adrLp00CFDA.l	;4EB90000CFDA
	move.l	(sp)+,a0	;205F
	add.w	#$01B8,a0	;D0FC01B8
adrCd00486E:
	rts	;4E75

adrCd004870:
	bclr	#$07,$0001(a5)	;08AD00070001
	beq.s	adrCd00486E	;67F6
	move.l	$0002(a5),d1	;222D0002
	sub.w	$0008(a5),d1	;926D0008
	cmpi.w	#$0018,d1	;0C410018
	bcs.s	adrCd00486E	;65E8
	cmpi.w	#$0027,d1	;0C410027
	bcs.s	adrCd0048AA	;651E
	sub.b	#$42,d1	;04010042
	bcs.s	adrCd00486E	;65DC
	cmpi.b	#$10,d1	;0C010010
	bcc.s	adrCd00486E	;64D6
	swap	d1	;4841
	sub.w	#$00C0,d1	;044100C0
	bcs.s	adrCd00486E	;65CE
	cmpi.b	#$10,d1	;0C010010
	bcc.s	adrCd00486E	;64C8
	bra	adrCd0046CC	;6000FE24

adrCd0048AA:
	swap	d1	;4841
	sub.b	#$90,d1	;04010090
	bcs.s	adrCd00486E	;65BC
	cmpi.b	#$40,d1	;0C010040
	bcc.s	adrCd00486E	;64B6
	swap	d1	;4841
	sub.w	#$0018,d1	;04410018
	lsr.w	#$03,d1	;E649
	move.b	$44(a5,d1.w),d0	;10351044
	bmi.s	adrCd00486E	;6BA8
	move.b	d0,$0044(a5)	;1B400044
	jsr	InitialiseText.l	;4EB90000D09A
	lea	SpellDescriptions.l,a3	;47F900019F8E
	moveq	#$00,d0	;7000
	move.b	$0044(a5),d0	;102D0044
	jsr	Print_word.l	;4EB90000D7E2
	jsr	TerminateText.l	;4EB90000D008
	move.l	#$00100018,d5	;2A3C00100018
	add.w	$0008(a5),d5	;DA6D0008
	move.l	#$003F0090,d4	;283C003F0090
	moveq	#$00,d3	;7600
	jsr	BW_draw_bar.l	;4EB90000DA68
	move.b	$0044(a5),d0	;102D0044
	bsr	adrCd006900	;61001FFA
	lea	adrEA00463A.w,a6	;4DF8463A	;Short Absolute converted to symbol!
	move.b	$00(a6,d0.w),adrB_00D92B.l	;13F600000000D92B
	add.w	#$0064,d0	;06400064
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	$000A(a5),a0	;D0ED000A
	add.w	#$0A86,a0	;D0FC0A86
	jsr	adrCd00CAEA.l	;4EB90000CAEA
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	$000A(a5),a0	;D0ED000A
	add.w	#$03D2,a0	;D0FC03D2
	moveq	#$00,d0	;7000
	move.b	$0044(a5),d0	;102D0044
	bsr	adrCd004852	;6100FF10
	bsr	adrCd004996	;61000050
	lea	adrEA004A5E.l,a6	;4DF900004A5E
	add.w	#$0030,d1	;06410030
	move.b	d1,$000E(a6)	;1D41000E
	jsr	adrCd00CEC4.l	;4EB90000CEC4
	move.w	d1,$0012(a6)	;3D410012
	jsr	Print_fflim_text.l	;4EB90000D0C6
	moveq	#$00,d0	;7000
	move.b	$004F(a5),d0	;102D004F
	move.b	$18(a5,d0.w),d0	;10350018
	bsr	adrCd006660	;61001CEE
	move.b	$0044(a5),$0013(a4)	;196D00440013
	clr.b	$0015(a4)	;422C0015
	bsr	adrCd006712	;61001D92
	move.b	#$FF,$0013(a4)	;197C00FF0013
	or.b	#$40,$0054(a5)	;002D00400054
	move.b	#$03,$004E(a5)	;1B7C0003004E
adrCd004994:
	rts	;4E75

adrCd004996:
	lea	SpellsCostTable.l,a0	;41F90000685E
	moveq	#$00,d7	;7E00
	move.b	$0044(a5),d7	;1E2D0044
	move.b	$00(a0,d7.w),d0	;10307000
	move.b	d0,d1	;1200
	asl.b	#$02,d0	;E500
	add.b	d1,d0	;D001
	rts	;4E75

adrCd0049AE:
	jsr	InitialiseText.l	;4EB90000D09A
	jsr	Print_fflim_text.l	;4EB90000D0C6
	moveq	#$00,d0	;7000
	move.b	$004F(a5),d0	;102D004F
	move.b	$18(a5,d0.w),d0	;10350018
	and.w	#$000F,d0	;0240000F
	moveq	#$11,d6	;7C11
	jsr	Print_wordstext.l	;4EB90000D7E6
	jmp	TerminateText.l	;4EF90000D008

adrCd0049D6:
	bclr	#$07,$0001(a5)	;08AD00070001
	beq.s	adrCd004994	;67B6
	move.l	$0002(a5),d1	;222D0002
	sub.w	$0008(a5),d1	;926D0008
	sub.b	#$42,d1	;04010042
	bcs.s	adrCd004994	;65A8
	cmpi.b	#$10,d1	;0C010010
	bcc.s	adrCd004994	;64A2
	swap	d1	;4841
	sub.w	#$0070,d1	;04410070
	bcs.s	adrCd004994	;659A
	cmpi.w	#$0010,d1	;0C410010
	bcs.s	adrCd004A10	;6510
	cmpi.w	#$0050,d1	;0C410050
	bcs.s	adrCd004994	;658E
	cmpi.w	#$0060,d1	;0C410060
	bcc.s	adrCd004994	;6488
	bra	adrCd0046CC	;6000FCBE

adrCd004A10:
	bsr.s	adrCd004996	;6184
	move.w	d0,d2	;3400
	moveq	#$00,d1	;7200
	move.b	$004F(a5),d1	;122D004F
	move.b	$18(a5,d1.w),d0	;10351018
	move.b	d0,d1	;1200
	asl.b	#$04,d1	;E901
	lea	PocketContents.l,a4	;49F90000ED2A
	add.w	d1,a4	;D8C1
	move.b	$000C(a4),d3	;162C000C
	sub.b	d2,d3	;9602
	bcs.s	adrCd004A54	;6522
	move.b	d3,$000C(a4)	;1943000C
	bsr	adrCd006660	;61001C28
	eor.b	#$1F,d7	;0A07001F
	move.l	$000C(a4),d0	;202C000C
	bset	d7,d0	;0FC0
	move.l	d0,$000C(a4)	;2940000C
	subq.b	#$01,$001E(a4)	;532C001E
	subq.b	#$01,$004F(a5)	;532D004F
	bra	adrCd004580	;6000FB2E

adrCd004A54:
	lea	PauperMsg.l,a6	;4DF900004AD0
	bra	adrCd0049AE	;6000FF52

adrEA004A5E:
	dc.b	$FC	;FC
	dc.b	$12	;12
	dc.b	$04	;04
	dc.b	$FE	;FE
	dc.b	$04	;04
	dc.b	'LEVEL  '	;4C4556454C2020
	dc.b	$FE	;FE
	dc.b	$0E	;0E
	dc.b	' '	;20
	dc.b	$FC	;FC
	dc.b	$12	;12
	dc.b	$05	;05
	dc.b	'  '	;2020
	dc.b	$FE	;FE
	dc.b	$04	;04
	dc.b	'  GOLD'	;2020474F4C44
	dc.b	$FC	;FC
	dc.b	$12	;12
	dc.b	$09	;09
	dc.b	$FE	;FE
	dc.b	$0C	;0C
	dc.b	'OK ?'	;4F4B203F
	dc.b	$FF	;FF
MayBuySpellMsg:
	dc.b	' MAY BUY A SPELL-PICK A CLASS'	;204D4159204255592041205350454C4C2D5049434B204120434C415353
	dc.b	$FF	;FF
SelectNewSpellMsg:
	dc.b	'SELECT THY NEW SPELL, '	;53454C45435420544859204E4557205350454C4C2C20
	dc.b	$FF	;FF
ThouHastAllMsg:
	dc.b	'THOU HAST ALL I GIVE, '	;54484F55204841535420414C4C204920474956452C20
	dc.b	$FF	;FF
PauperMsg:
	dc.b	'I FIND THEE A PAUPER, '	;492046494E4420544845452041205041555045522C20
	dc.b	$FF	;FF
	dc.b	$00	;00

adrCd004AE8:
	moveq	#$00,d0	;7000
	move.b	(a6),d0	;1016
	move.l	a6,-(sp)	;2F0E
	bsr.s	adrCd004B28	;6138
	move.l	(sp)+,a6	;2C5F
	jsr	Print_timed_message.l	;4EB90000D86A
	move.b	#$32,$003F(a5)	;1B7C0032003F
adrCd004AFE:
	bclr	#$07,$0001(a5)	;08AD00070001
	beq.s	adrCd004B12	;670C
	clr.w	$0014(a5)	;426D0014
	and.b	#$01,(a5)	;02150001
	clr.b	$0056(a5)	;422D0056
adrCd004B12:
	rts	;4E75

adrEA004B14:
	dc.w	$002B	;002B
	dc.w	$8D2C	;8D2C
	dc.w	$FF00	;FF00
adrEA004B1A:
	dc.w	$000B	;000B
	dc.w	$1828	;1828
	dc.w	$3235	;3235
	dc.w	$3C41	;3C41
	dc.w	$4641	;4641
	dc.w	$4146	;4146
	dc.w	$78B4	;78B4

adrCd004B28:
	addq.b	#$01,(a4)	;5214
	moveq	#$00,d1	;7200
	move.b	(a4),d1	;1214
	move.b	adrEA004B1A(pc,d1.w),$001C(a4)	;197B10EA001C
	move.w	d0,d4	;3800
	bsr	RandomGen_BytewithOffset	;61000A74
	and.w	#$000F,d0	;0240000F
	move.w	d4,d1	;3204
	and.w	#$0001,d1	;02410001
	beq.s	adrCd004B48	;6702
	lsr.w	#$01,d0	;E248
adrCd004B48:
	add.w	#$0009,d0	;06400009
	add.b	$0006(a4),d0	;D02C0006
	bcc.s	adrCd004B56	;6404
	move.b	#$FD,d0	;103C00FD
adrCd004B56:
	move.b	d0,$0006(a4)	;19400006
	bsr	RandomGen_BytewithOffset	;61000A50
	and.w	#$0007,d0	;02400007
	addq.w	#$01,d0	;5240
	add.b	$0008(a4),d0	;D02C0008
	cmpi.w	#$0064,d0	;0C400064
	bcs.s	adrCd004B70	;6502
	moveq	#$63,d0	;7063
adrCd004B70:
	move.b	d0,$0008(a4)	;19400008
	lea	adrEA004C00.l,a2	;45F900004C00
	move.w	d4,d0	;3004
	and.w	#$0003,d0	;02400003
	asl.w	#$02,d0	;E540
	add.w	d0,a2	;D4C0
	moveq	#$03,d6	;7C03
adrLp004B86:
	cmp.b	#$06,(a2)	;0C120006
	bne.s	adrCd004B92	;6606
	bsr	adrCd005556	;610009C8
	bra.s	adrCd004BA2	;6010

adrCd004B92:
	bsr	RandomGen_BytewithOffset	;61000A18
	and.w	#$0007,d0	;02400007
	cmp.b	#$04,(a2)	;0C120004
	bne.s	adrCd004BA2	;6602
	lsr.w	#$01,d0	;E248
adrCd004BA2:
	addq.w	#$01,d0	;5240
	add.b	$01(a4,d6.w),d0	;D0346001
	cmpi.b	#$64,d0	;0C000064
	bcs.s	adrCd004BB0	;6502
	moveq	#$63,d0	;7063
adrCd004BB0:
	move.b	d0,$01(a4,d6.w)	;19806001
	addq.w	#$01,a2	;524A
	dbra	d6,adrLp004B86	;51CEFFCE
	bclr	#$07,$001E(a4)	;08AC0007001E
	move.w	d4,d0	;3004
	and.w	#$0003,d4	;02440003
	subq.w	#$01,d4	;5344
	bne.s	adrCd004BCE	;6604
	addq.b	#$01,$001E(a4)	;522C001E
adrCd004BCE:
	bsr	adrCd000904	;6100BD34
	moveq	#$00,d2	;7400
	move.b	(a4),d2	;1414
	lea	adrEA004B1A.w,a6	;4DF84B1A	;Short Absolute converted to symbol!
	move.b	$00(a6,d2.w),$001C(a4)	;19762000001C
	move.b	$0002(a4),d1	;122C0002
	lsr.b	#$04,d1	;E809
	lsr.b	#$01,d2	;E20A
	add.b	d2,d1	;D202
	sub.b	#$0F,d1	;0401000F
	neg.b	d1	;4401
	cmpi.b	#$08,d1	;0C010008
	bcc.s	adrCd004BF8	;6402
	moveq	#$08,d1	;7208
adrCd004BF8:
	asl.b	#$04,d1	;E901
	move.b	d1,$0019(a4)	;19410019
	rts	;4E75

adrEA004C00:
	dc.w	$0404	;0404
	dc.w	$0608	;0608
	dc.w	$0408	;0408
	dc.w	$0604	;0604
	dc.w	$0806	;0806
	dc.w	$0606	;0606
	dc.w	$0404	;0404
	dc.w	$0806	;0806

adrJA004C10:
	cmp.w	#$0008,$0042(a5)	;0C6D00080042
	bne.s	adrCd004C3E	;6626
	cmp.w	#$0006,$0044(a5)	;0C6D00060044
	bcc.s	adrCd004C3E	;641E
	eor.w	#$0001,$0044(a5)	;0A6D00010044
	bra	adrCd007D6C	;60003144

adrCd004C2A:
	tst.w	$0042(a5)	;4A6D0042
	bpl.s	adrCd004C40	;6A10
	bclr	#$07,$0001(a5)	;08AD00070001
	beq.s	adrCd004C3E	;6706
	move.w	#$001A,$000C(a5)	;3B7C001A000C
adrCd004C3E:
	rts	;4E75

adrCd004C40:
	bclr	#$07,$0001(a5)	;08AD00070001
	beq.s	adrCd004C56	;670E
	lea	adrEA00EAFA.l,a6	;4DF90000EAFA
	moveq	#$1C,d0	;701C
	moveq	#$22,d2	;7422
	bra	adrCd004DB4	;60000160

adrCd004C56:
	moveq	#-$01,d0	;70FF
	move.l	$0002(a5),d1	;222D0002
	sub.w	$0008(a5),d1	;926D0008
	sub.w	#$003A,d1	;0441003A
	bcs.s	adrCd004C80	;651A
	lsr.w	#$03,d1	;E649
	and.w	#$0003,d1	;02410003
	move.w	d1,d0	;3001
	swap	d1	;4841
	move.l	$0046(a5),a0	;206D0046
	cmp.b	$00(a0,d0.w),d1	;B2300000
	bcs.s	adrCd004C7E	;6504
	add.w	#$0100,d0	;06400100
adrCd004C7E:
	ror.w	#$08,d0	;E058
adrCd004C80:
	cmp.w	$0040(a5),d0	;B06D0040
	bne.s	adrCd004C88	;6602
	rts	;4E75

adrCd004C88:
	move.w	d0,$0040(a5)	;3B400040
	bra	adrCd007D6C	;600030DE

adrCd004C90:
	move.w	#$FFFF,$000C(a5)	;3B7CFFFF000C
	move.w	$0022(a5),$0024(a5)	;3B6D00220024
	btst	#$06,$0018(a5)	;082D00060018
	bne.s	adrCd004C3E	;669A
	tst.b	$003D(a5)	;4A2D003D
	bmi.s	adrCd004CB2	;6B08
	move.b	#$FF,$003D(a5)	;1B7C00FF003D
	bra.s	adrCd004D08	;6056

adrCd004CB2:
	moveq	#$05,d1	;7205
	bsr	adrCd005500	;6100084A
	tst.b	d3	;4A03
	bpl.s	adrCd004D08	;6A4C
	bsr	adrCd008498	;610037DA
	move.w	$00(a6,d0.w),d1	;32360000
	and.w	#$0007,d1	;02410007
	cmpi.w	#$0006,d1	;0C410006
	bne.s	adrCd004D08	;663A
	move.b	$00(a6,d0.w),d1	;12360000
	and.w	#$0003,d1	;02410003
	subq.w	#$01,d1	;5341
	bne.s	adrCd004D08	;662E
	bclr	#$07,$01(a6,d0.w)	;08B600070001
	move.w	$0058(a5),d2	;342D0058
	move.w	d2,d1	;3202
	subq.w	#$01,d1	;5341
	move.w	d1,$0058(a5)	;3B410058
	bsr	adrCd0084BA	;610037CC
	move.l	d7,$001C(a5)	;2B47001C
	bsr	adrCd0084D6	;610037E0
	bsr	adrCd008498	;6100379E
	bset	#$07,$01(a6,d0.w)	;08F600070001
	move.b	#$02,$003D(a5)	;1B7C0002003D
adrCd004D08:
	cmp.w	#$0008,$0042(a5)	;0C6D00080042
	bne.s	adrCd004D1A	;660A
	bsr	adrCd0033BE	;6100E6AC
	bcs.s	adrCd004D1A	;6504
	bsr	adrCd00332A	;6100E612
adrCd004D1A:
	move.b	$0014(a5),d0		;102D0014
	beq.s	adrCd004D32		;6712
	cmpi.b	#$01,d0			;0C000001
	beq.s	adrCd004D8C		;6766
	cmpi.b	#$02,d0			;0C000002
	beq	adrCd00465E		;6700F932
	bra	adrJA004DEA		;600000BA

adrCd004D32:
	moveq	#$00,d0	;7000
	move.b	$0056(a5),d0	;102D0056
	beq.s	adrCd004D4E	;6714
	move.w	d0,$000C(a5)	;3B40000C
	clr.b	$0056(a5)	;422D0056
	cmp.w	#$0004,$0014(a5)	;0C6D00040014
	bne.s	adrCd004D4E	;6604
	bsr	Click_CloseSpellBook	;61000A58
adrCd004D4E:
	cmp.w	#$005E,$0002(a5)	;0C6D005E0002
	bcs	adrCd004C2A	;6500FED4
	moveq	#-$01,d0	;70FF
	tst.w	$0040(a5)	;4A6D0040
	bpl	adrCd004C88	;6A00FF28
	bclr	#$07,$0001(a5)	;08AD00070001
	beq.s	adrCd004DA8	;673E
	moveq	#$00,d0	;7000
	move.b	$0015(a5),d0	;102D0015
	asl.w	#$02,d0	;E540
	move.l	adrJT004D78(pc,d0.w),a0	;207B0004
	jmp	(a0)	;4ED0

adrJT004D78:
	dc.l	adrJA004DAA	;00004DAA
	dc.l	Click_CloseSpellBook	;000057A4
	dc.l	adrJA004DEA	;00004DEA
	dc.l	adrJA005628	;00005628
	dc.l	Click_CloseSpellBook	;000057A4

adrCd004D8C:
	bclr	#$07,$0001(a5)	;08AD00070001
	beq.s	adrCd004DA8	;6714
	clr.b	$0014(a5)	;422D0014
	move.b	#$FF,$0053(a5)	;1B7C00FF0053
	lea	adrEA0041ED.w,a6	;4DF841ED	;Short Absolute converted to symbol!
	jmp	Print_timed_message.l	;4EF90000D86A

adrCd004DA8:
	rts	;4E75

adrJA004DAA:
	lea	adrEA00EA72.l,a6	;4DF90000EA72
	moveq	#$00,d0	;7000
	moveq	#$11,d2	;7411
adrCd004DB4:
	move.l	$0002(a5),d1	;222D0002
	sub.w	$0008(a5),d1	;926D0008
adrCd004DBC:
	cmp.w	$0004(a6),d1	;B26E0004
	bcs.s	adrCd004DE0	;651E
	cmp.w	$0006(a6),d1	;B26E0006
	beq.s	adrCd004DCA	;6702
	bcc.s	adrCd004DE0	;6416
adrCd004DCA:
	swap	d1	;4841
	cmp.w	(a6),d1	;B256
	bcs.s	adrCd004DDE	;650E
	cmp.w	$0002(a6),d1	;B26E0002
	beq.s	adrCd004DD8	;6702
	bcc.s	adrCd004DDE	;6406
adrCd004DD8:
	move.w	d0,$000C(a5)	;3B40000C
	rts	;4E75

adrCd004DDE:
	swap	d1	;4841
adrCd004DE0:
	addq.w	#$08,a6	;504E
	addq.w	#$01,d0	;5240
	cmp.w	d2,d0	;B042
	bcs.s	adrCd004DBC	;65D4
	rts	;4E75

adrJA004DEA:
	moveq	#$00,d0	;7000
	move.b	$0014(a5),d0	;102D0014
	bne.s	adrCd004E0C	;661A
	moveq	#-$01,d2	;74FF
	bsr	adrCd00C650	;6100785A
	bmi.s	adrCd004E12	;6B18
	move.w	#$0002,$0014(a5)	;3B7C00020014
	move.w	$000C(a5),d0	;302D000C
	add.w	#$0011,d0	;06400011
	move.b	d0,$0014(a5)	;1B400014
adrCd004E0C:
	move.w	d0,$000C(a5)	;3B40000C
	rts	;4E75

adrCd004E12:
	bsr	adrCd00587C	;61000A68
	tst.w	$000C(a5)	;4A6D000C
	bpl.s	adrCd004E4C	;6A30
	bsr	adrCd00665C	;6100183E
	tst.b	$0013(a4)	;4A2C0013
	bmi.s	adrCd004E4C	;6B26
	cmpi.w	#$0048,d1	;0C410048
	bcs.s	adrCd004E4C	;6520
	cmpi.w	#$0058,d1	;0C410058
	bcc.s	adrCd004E4C	;641A
	swap	d1	;4841
	cmpi.w	#$00E0,d1	;0C4100E0
	bcs.s	adrCd004E4C	;6512
	cmpi.w	#$00F0,d1	;0C4100F0
	bcs.s	adrCd004E46	;6506
	cmpi.w	#$0132,d1	;0C410132
	bcs.s	adrCd004E4E	;6508
adrCd004E46:
	move.w	#$0015,$000C(a5)	;3B7C0015000C
adrCd004E4C:
	rts	;4E75

adrCd004E4E:
	swap	d1	;4841
	cmpi.w	#$0050,d1	;0C410050
	bcs.s	adrCd004E4C	;65F6
	swap	d1	;4841
	cmpi.w	#$0128,d1	;0C410128
	bcc.s	adrCd004E72	;6414
	cmpi.w	#$011A,d1	;0C41011A
	bcc.s	adrCd004E4C	;64E8
	cmpi.w	#$0110,d1	;0C410110
	bcs.s	adrCd004E4C	;65E2
	addq.b	#$01,$0014(a4)	;522C0014
	bra	adrCd0066F6	;60001886

adrCd004E72:
	subq.b	#$01,$0014(a4)	;532C0014
	bra	adrCd0066F6	;6000187E

Click_LaunchSpellFromBook:
	bsr.s	adrCd004E8E	;6112
	bne.s	adrCd004E86	;6608
	bsr	adrCd006698	;61001818
	bsr	adrCd00C85E	;610079DA
adrCd004E86:
	move.w	#$0002,$0014(a5)	;3B7C00020014
adrCd004E8C:
	rts	;4E75

adrCd004E8E:
	bsr	adrCd00665C	;610017CC
	clr.w	adrW_00505A.l	;42790000505A
	move.b	$0007(a5),adrB_00EE3E.l	;13ED00070000EE3E
adrCd004EA0:
	move.b	$0013(a4),d0	;102C0013
	bmi.s	adrCd004E8C	;6BE6
	subq.b	#$03,d0	;5700
	beq.s	adrCd004EBE	;6714
	cmp.w	#$0008,$0042(a5)	;0C6D00080042
	bne.s	adrCd004EBE	;660C
	movem.l	d0-d7/a0-a6,-(sp)	;48E7FFFE
	bsr	adrCd00332A	;6100E472
	movem.l	(sp)+,d0-d7/a0-a6	;4CDF7FFF
adrCd004EBE:
	subq.b	#$04,$0007(a4)	;592C0007
	bcc.s	adrCd004EC8	;6404
	clr.b	$0007(a4)	;422C0007
adrCd004EC8:
	move.b	#$0F,$001B(a4)	;197C000F001B
	clr.b	$0011(a4)	;422C0011
	bsr	adrCd00688C	;610019B8
	move.b	$0009(a4),d1	;122C0009
	sub.b	d0,d1	;9200
	bcs	Spells_NotEnoughSP	;650000F8
	move.b	d1,$0009(a4)	;19410009
	tst.b	d0	;4A00
	bne.s	adrCd004EFA	;6612
	move.b	$0013(a4),d0	;102C0013
	bsr	adrCd006900	;61001A12
	lea	RingUses.l,a0	;41F90000EE32
	subq.b	#$01,$00(a0,d0.w)	;53300000
adrCd004EFA:
	bsr	adrCd0080CA	;610031CE
	bsr	adrCd006778	;61001878
	moveq	#$00,d0	;7000
	move.b	$0013(a4),d0	;102C0013
	lea	SpellsCostTable.l,a6	;4DF90000685E
	move.b	$00(a6,d0.w),d1	;12360000
	addq.b	#$05,d1	;5A01
	add.b	$0015(a4),d1	;D22C0015
	cmpi.b	#$64,d1	;0C010064
	bcs.s	adrCd004F20	;6502
	moveq	#$64,d1	;7264
adrCd004F20:
	move.b	d1,$0015(a4)	;19410015
	add.w	d0,d0	;D040
	lea	Spells_01_Armour.l,a0	;41F90000505C
	lea	Spells_LookupTable.l,a6	;4DF90000500C
	add.w	$00(a6,d0.w),a0	;D0F60000
	bsr	adrCd005546	;6100060E
	add.b	d0,d7	;DE00
	bmi.s	Spells_Failed	;6B72
	move.w	d7,-(sp)	;3F07
	bsr	adrCd008498	;61003556
	move.w	(sp)+,d7	;3E1F
	move.w	$00(a6,d0.w),d1	;32360000
	and.w	#$0007,d1	;02410007
	subq.w	#$06,d1	;5D41
	bne.s	adrCd004F5E	;660C
	move.b	$00(a6,d0.w),d1	;12360000
	and.w	#$0003,d1	;02410003
	beq	Pad_Fizzle	;67000092
adrCd004F5E:
	move.l	a4,-(sp)	;2F0C
	jsr	(a0)	;4E90
	moveq	#$00,d0	;7000
	move.b	adrB_00EE3E.l,d0	;10390000EE3E
	bsr	adrCd004078	;6100F10C
	tst.w	d1	;4A41
	bmi.s	adrCd004F8E	;6B1C
	beq.s	adrCd004F86	;6712
	move.w	d1,d7	;3E01
	tst.w	$0042(a5)	;4A6D0042
	bpl.s	adrCd004F8E	;6A12
	bsr	adrCd007EF0	;61002F72
	bsr	adrCd007ED2	;61002F50
	bra.s	adrCd004F8E	;6008

adrCd004F86:
	move.w	$0006(a5),d7	;3E2D0006
	bsr	adrCd00CCD8	;61007D4C
adrCd004F8E:
	move.l	(sp)+,a4	;285F
	move.l	#adrL_007E22,a0	;207C00007E22
	add.l	a4,a0	;D1CC
	moveq	#$00,d0	;7000
	move.b	$0013(a4),d0	;102C0013
	addq.b	#$01,$00(a0,d0.w)	;52300000
	bcc.s	adrCd004FA8	;6404
	subq.b	#$01,$00(a0,d0.w)	;53300000
adrCd004FA8:
	lea	NullString.l,a6	;4DF90000CAE9
	bra.s	adrCd004FBE	;600E

Spells_Failed:
	lea	SpellFailedMsg.l,a6	;4DF90000504C
	move.w	#$0004,adrW_00D92A.l	;33FC00040000D92A
adrCd004FBE:
	move.b	#$FF,$0013(a4)	;197C00FF0013
	tst.b	adrB_00505B.l	;4A390000505B
	bne.s	adrCd004FD4	;6608
	jsr	LowerText.l	;4EB90000CFB8
	moveq	#$00,d0	;7000
adrCd004FD4:
	rts	;4E75

Spells_NotEnoughSP:
	tst.b	adrB_00505B.l	;4A390000505B
	bne.s	adrCd004FD4	;66F6
	lea	CostTooHighMsg.l,a6	;4DF90000EA62
	jsr	LowerText.l	;4EB90000CFB8
	moveq	#$01,d0	;7001
	rts	;4E75

Pad_Fizzle:
	lea	SpellFizzledMsg.l,a6	;4DF900004FFE
	move.w	#$0008,adrW_00D92A.l	;33FC00080000D92A
	bra.s	adrCd004FBE	;60C0

SpellFizzledMsg:
	dc.b	'SPELL FIZZLED'	;5350454C4C2046495A5A4C4544
	dc.b	$FF	;FF
Spells_LookupTable:
	dc.w	Spells_01_Armour-Spells_01_Armour	;0000
	dc.w	Spells_02_Terror-Spells_01_Armour	;0022
	dc.w	Spells_03_Vitalise-Spells_01_Armour	;002A
	dc.w	Spells_04_Biguile-Spells_01_Armour	;0032
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
SpellFailedMsg:
	dc.b	'SPELL FAILED'	;5350454C4C204641494C4544
	dc.b	$FF	;FF
	dc.b	$00	;00
adrW_00505A:
	dc.b	$00	;00
adrB_00505B:
	dc.b	$00	;00

Spells_01_Armour:
	moveq	#$00,d4	;7800
	addq.w	#$02,d7	;5447
adrCd005060:
	cmpi.w	#$0040,d7	;0C470040
	bcs.s	adrCd005068	;6502
	moveq	#$3F,d7	;7E3F
adrCd005068:
	asl.w	#$02,d7	;E547
	and.w	#$00F8,d7	;024700F8
	add.b	d4,d7	;DE04
	move.b	d7,$0011(a4)	;19470011
	move.b	#$02,adrB_00EE3C.l	;13FC00020000EE3C
	rts	;4E75

Spells_02_Terror:
	move.w	#$008F,d4	;383C008F
	bra	adrCd005316	;60000292

Spells_03_Vitalise:
	moveq	#$07,d4	;7807
	lsr.w	#$02,d7	;E44F
	bra	adrCd005236	;600001AA

Spells_04_Biguile:
	cmp.w	#$0008,$0042(a5)	;0C6D00080042
	bne.s	adrCd0050BC	;6626
	lsr.b	#$02,d7	;E40F
	addq.w	#$01,d7	;5247
	bsr	adrCd0041FA	;6100F15E
	move.w	d7,d0	;3007
	add.b	$0006(a4),d7	;DE2C0006
	move.b	d7,$0006(a4)	;19470006
	add.b	$0007(a4),d0	;D02C0007
	move.b	d0,$0007(a4)	;19400007
	bsr	adrCd00847E	;610033CC
	move.w	#$008D,d7	;3E3C008D
	bra	adrCd001DBC	;6000CD02

adrCd0050BC:
	rts	;4E75

Spells_05_Deflect:
	moveq	#$01,d4	;7801
	bra.s	adrCd005060	;609E

Spells_06_Magelock:
	bsr	adrCd008498	;610033D4
	move.b	$01(a6,d0.w),d1	;12360001
	and.w	#$0007,d1	;02410007
	subq.w	#$02,d1	;5541
	bne.s	adrCd0050E8	;6616
	move.w	$0020(a5),d2	;342D0020
	add.w	d2,d2	;D442
	addq.w	#$01,d2	;5242
	btst	d2,$00(a6,d0.w)	;05360000
	bne.s	adrCd00512E	;664E
	subq.w	#$01,d2	;5342
	btst	d2,$00(a6,d0.w)	;05360000
	bne.s	adrCd005134	;664C
adrCd0050E8:
	bsr	adrCd00847E	;61003394
	cmp.w	adrW_00EE72.l,d7	;BE790000EE72
	bcc.s	adrCd005134	;6440
	swap	d7	;4847
	cmp.w	adrW_00EE70.l,d7	;BE790000EE70
	bcc.s	adrCd005134	;6436
	move.b	$01(a6,d0.w),d1	;12360001
	and.w	#$0007,d1	;02410007
	cmpi.w	#$0002,d1	;0C410002
	beq.s	adrCd00511C	;6710
	cmpi.w	#$0005,d1	;0C410005
	bne.s	adrCd005134	;6622
	move.b	$00(a6,d0.w),d1	;12360000
	lsr.b	#$04,d1	;E809
	beq.s	adrCd00512E	;6714
	rts	;4E75

adrCd00511C:
	move.w	$0020(a5),d2	;342D0020
	eor.w	#$0002,d2	;0A420002
	add.w	d2,d2	;D442
	addq.w	#$01,d2	;5242
	btst	d2,$00(a6,d0.w)	;05360000
	beq.s	adrCd005134	;6706
adrCd00512E:
	bchg	#$04,$01(a6,d0.w)	;087600040001
adrCd005134:
	rts	;4E75

Spells_07_Conceal:
	bsr	adrCd00847E	;61003346
	cmp.w	adrW_00EE72.l,d7	;BE790000EE72
	bcc.s	adrCd005150	;640E
	cmp.w	adrW_00EE70.l,d7	;BE790000EE70
	bcc.s	adrCd005150	;6406
	bset	#$03,$01(a6,d0.w)	;08F600030001
adrCd005150:
	rts	;4E75

Spells_08_Warpower:
	moveq	#$02,d4	;7802
	bra	adrCd005060	;6000FF0A

Spells_09_Missle:
	move.w	#$008A,d4	;383C008A
	lsr.w	#$01,d7	;E24F
	bra	adrCd005328	;600001C8

Spells_10_Vanish:
	moveq	#$03,d4	;7803
	bra	adrCd005060	;6000FEFA

Spells_11_Paralyze:
	move.w	#$008C,d4	;383C008C
	bra	adrCd005316	;600001A8

Spells_12_Alchemy:
	moveq	#$00,d0	;7000
	move.b	adrB_00EE3E.l,d0	;10390000EE3E
	asl.w	#$04,d0	;E940
	lea	PocketContents.l,a0	;41F90000ED2A
	add.w	d0,a0	;D0C0
	moveq	#$00,d0	;7000
	move.b	(a0),d1	;1210
	cmpi.b	#$1B,d1	;0C01001B
	bcs.s	adrCd005192	;6506
	cmpi.b	#$3F,d1	;0C01003F
	bcs.s	adrCd0051A4	;6512
adrCd005192:
	move.b	$0001(a0),d1	;12280001
	moveq	#$01,d0	;7001
	cmpi.b	#$1B,d1	;0C01001B
	bcs.s	adrCd0051CE	;6530
	cmpi.b	#$3F,d1	;0C01003F
	bcc.s	adrCd0051CE	;642A
adrCd0051A4:
	addq.w	#$05,d7	;5A47
	add.b	$000C(a0),d7	;DE28000C
	cmpi.b	#$64,d7						;0C070064
	bcs.s	adrCd0051B2	;6502
	moveq	#$63,d7	;7E63
adrCd0051B2:
	move.b	d7,$000C(a0)	;1147000C
	moveq	#$0B,d2	;740B
adrLp0051B8:
	cmp.b	#$01,$00(a0,d2.w)	;0C3000012000
	bne.s	adrCd0051C4	;6604
	clr.b	$00(a0,d2.w)	;42302000
adrCd0051C4:
	dbra	d2,adrLp0051B8	;51CAFFF2
	move.b	#$01,$00(a0,d0.w)	;11BC00010000
adrCd0051CE:
	rts	;4E75

Spells_13_Confuse:
	move.w	#$008B,d4	;383C008B
	bra	adrCd005316	;60000140

Spells_14_Levitate:
	moveq	#$05,d4	;7805
	bra	adrCd005060	;6000FE84

Spells_15_Antimage:
	moveq	#$06,d4	;7806
	bra	adrCd005060	;6000FE7E

Spells_16_Recharge:
	moveq	#$00,d0			;7000
	move.b	adrB_00EE3E.l,d0	;10390000EE3E
	asl.w	#$04,d0			;E940
	lea	PocketContents.l,a0	;41F90000ED2A
	add.w	d0,a0			;D0C0
	move.b	(a0),d0			;1010
	cmpi.b	#$69,d0			;0C000069
	bcs.s	adrCd005204		;6506
	cmpi.b	#$6D,d0			;0C00006D
	bcs.s	adrCd005214		;6510
adrCd005204:
	move.b	$0001(a0),d0		;10280001
	cmpi.b	#$69,d0			;0C000069
	bcs.s	adrCd005224		;6516
	cmpi.b	#$6D,d0			;0C00006D
	bcc.s	adrCd005224		;6410
adrCd005214:
	sub.w	#$0069,d0		;04400069
	lea	RingUses.l,a0	;41F90000EE32
	lsr.w	#$03,d7			;E64F
	move.b	d7,$00(a0,d0.w)		;11870000
adrCd005224:
	rts	;4E75

Spells_17_Trueview:
	moveq	#$07,d4	;7807
	bra	adrCd005060	;6000FE36

Spells_18_Renew:
	move.w	d7,d4	;3807
	add.w	d7,d7	;DE47
	add.w	d4,d7	;DE44
	lsr.w	#$04,d7	;E84F
	moveq	#$05,d4	;7805
adrCd005236:
	move.w	d7,d5	;3A07
adrLp005238:
	bsr	adrCd005556	;6100031C
	add.w	d0,d5	;DA40
	dbra	d7,adrLp005238	;51CFFFF8
	cmpi.w	#$0100,d5	;0C450100
	bcs.s	adrCd00524A	;6502
	moveq	#-$01,d5	;7AFF
adrCd00524A:
	moveq	#$03,d1	;7203
adrLp00524C:
	move.b	$18(a5,d1.w),d0	;10351018
	and.w	#$00E0,d0	;024000E0
	bne.s	adrCd005276	;6620
	move.b	$18(a5,d1.w),d0	;10351018
	bsr	adrCd006660	;61001404
	move.b	$00(a4,d4.w),d0	;10344000
	add.b	d5,d0	;D005
	bcc.s	adrCd005268	;6402
	moveq	#-$01,d0	;70FF
adrCd005268:
	cmp.b	$01(a4,d4.w),d0	;B0344001
	bcs.s	adrCd005272	;6504
	move.b	$01(a4,d4.w),d0	;10344001
adrCd005272:
	move.b	d0,$00(a4,d4.w)	;19804000
adrCd005276:
	dbra	d1,adrLp00524C	;51C9FFD4
	bra	adrCd0080CA	;60002E4E

Spells_19_Vivify:
	bsr	adrCd008498	;61003218
	bsr	adrCd0078FA	;61002676
	bsr	adrCd0033BE	;6100E136
	bcc.s	adrCd0052A0	;6414
	tst.b	d0	;4A00
	bpl.s	adrCd00529E	;6A0E
	move.l	a5,-(sp)	;2F0D
	move.l	a1,a5	;2A49
	bsr	adrCd008498	;61003202
	bsr	adrCd0078FA	;61002660
	move.l	(sp)+,a5	;2A5F
adrCd00529E:
	rts	;4E75

adrCd0052A0:
	bsr	adrCd00847E	;610031DC
	move.b	$01(a6,d0.w),d1	;12360001
	and.w	#$0007,d1	;02410007
	subq.w	#$01,d1	;5341
	beq.s	adrCd00529E	;67EE
	bra	adrCd007812	;60002560

Spells_20_Dispell:
	bsr	adrCd00847E	;610031C8
	bclr	#$03,$01(a6,d0.w)	;08B600030001
	move.b	$01(a6,d0.w),d1	;12360001
	not.b	d1	;4601
	and.w	#$0007,d1	;02410007
	bne.s	adrCd0052D8	;660E
	btst	#$00,$00(a6,d0.w)	;083600000000
	bne.s	adrCd0052DA	;6608
adrCd0052D2:
	and.w	#$00F8,$00(a6,d0.w)	;027600F80000
adrCd0052D8:
	rts	;4E75

adrCd0052DA:
	lea	adrEA0173F6.l,a0	;41F9000173F6
	moveq	#-$04,d1	;72FC
adrCd0052E2:
	addq.w	#$04,d1	;5841
	cmp.w	-$0002(a0),d1	;B268FFFE
	bcc.s	adrCd0052D2	;64E8
	cmp.w	$02(a0,d1.w),d0	;B0701002
	bne.s	adrCd0052E2	;66F2
	bra	adrCd001212	;6000BF20

Spells_21_Firepath:
	move.w	#$0087,d4	;383C0087
	addq.w	#$02,d7	;5447
	bra.s	adrCd005316	;601A

Spells_22_Illusion:
	moveq	#$65,d4	;7865
	bra	adrCd005328	;60000028

Spells_23_Compass:
	moveq	#$04,d4	;7804
	bra	adrCd005060	;6000FD5A

Spells_24_Spelltap:
	move.w	#$008E,d4	;383C008E
	bra.s	adrCd005316	;6008

Spells_25_Disrupt:
	move.w	#$0083,d4	;383C0083
	addq.w	#$05,d7	;5A47
	add.w	d7,d7	;DE47
adrCd005316:
	bset	#$08,d7	;08C70008
	bra.s	adrCd005328	;600C

Spells_26_Fireball:
	move.w	#$0080,d4	;383C0080
adrCd005320:
	move.w	d7,d3	;3607
	add.w	d7,d7	;DE47
	add.w	d3,d7	;DE43
	lsr.w	#$01,d7	;E24F
adrCd005328:
	move.w	$0020(a5),d6	;3C2D0020
	swap	d6	;4846
	move.w	$0020(a5),d6	;3C2D0020
adrCd005332:
	move.w	d7,d3	;3607
	move.l	$001C(a5),d7	;2E2D001C
	move.w	$0058(a5),d5	;3A2D0058
adrCd00533C:
	move.w	d5,-(sp)	;3F05
	bsr	adrCd007A44	;61002704
	bcc.s	adrCd005352	;640E
	move.w	(sp)+,d5	;3A1F
	move.b	#$FF,adrW_00505A.w	;11FC00FF505A	;Short Absolute converted to symbol!
	cmp.w	d0,d2	;B440
	bne.s	adrCd005358	;6608
	rts	;4E75

adrCd005352:
	clr.b	adrW_00505A.w	;4238505A	;Short Absolute converted to symbol!
	move.w	(sp)+,d5	;3A1F
adrCd005358:
	bset	#$07,$01(a6,d2.w)	;08F600072001
adrCd00535E:
	lea	UnpackedMonsters.l,a4	;49F900016B7E
	addq.w	#$01,-$0002(a4)	;526CFFFE
	move.w	-$0002(a4),d1	;322CFFFE
	cmpi.w	#$007D,d1	;0C41007D
	bcs.s	adrCd00537C	;650A
	subq.w	#$01,-$0002(a4)	;536CFFFE
	bsr	adrCd00277E	;6100D406
	bra.s	adrCd00535E	;60E2

adrCd00537C:
	asl.w	#$04,d1	;E941
	add.w	d1,a4	;D8C1
	move.b	d7,$0001(a4)	;19470001
	swap	d7	;4847
	move.b	d7,$0000(a4)	;19470000
	swap	d6	;4846
	move.b	d6,$0002(a4)	;19460002
	move.b	d5,$0004(a4)	;19450004
	swap	d5	;4845
	move.b	adrB_00EE3E.l,$000C(a4)	;19790000EE3E000C
	move.b	d4,$000B(a4)	;1944000B
	move.b	adrB_00505B.w,$0003(a4)	;1978505B0003	;Short Absolute converted to symbol!
	clr.w	$0008(a4)	;426C0008
	clr.b	$0005(a4)	;422C0005
	move.b	#$03,$000A(a4)	;197C0003000A
	move.b	#$FF,$000D(a4)	;197C00FF000D
	tst.b	d4	;4A04
	bmi.s	adrCd0053FE	;6B3E
	move.b	#$64,$000B(a4)	;197C0064000B
	cmpi.b	#$65,d4	;0C040065
	beq.s	adrCd0053D6	;670A
	moveq	#$06,d4	;7806
	add.w	d3,d4	;D843
	asl.w	#$03,d4	;E744
	move.w	d4,$0008(a4)	;39440008
adrCd0053D6:
	lsr.w	#$02,d3	;E44B
	cmpi.b	#$65,d4	;0C040065
	bne.s	adrCd0053E2	;6604
	bset	#$07,d3	;08C30007
adrCd0053E2:
	addq.w	#$02,d3	;5443
	move.b	d3,$0006(a4)	;19430006
	and.w	#$007F,d3	;0243007F
	move.b	d3,$0007(a4)	;19430007
	move.b	#$80,$0003(a4)	;197C00800003
	move.b	#$1F,$0005(a4)	;197C001F0005
	bra.s	adrCd005412	;6014

adrCd0053FE:
	move.b	d3,$0006(a4)	;19430006
	clr.b	$0007(a4)	;422C0007
	btst	#$08,d3	;08030008
	beq.s	adrCd005412	;6706
	bset	#$07,$0006(a4)	;08EC00070006
adrCd005412:
	tst.b	adrW_00505A.w	;4A38505A	;Short Absolute converted to symbol!
	bne	adrCd001D58	;6600C940
	rts	;4E75

Spells_27_Wychwind:
	add.w	#$000A,d7	;0647000A
	add.w	d7,d7	;DE47
	moveq	#$07,d5	;7A07
.wychwind_loop:
	movem.w	d5/d7,-(sp)	;48A70500
	move.w	#$0081,d4	;383C0081
	move.w	$0020(a5),d6	;3C2D0020
	add.b	.wychwind_data(pc,d5.w),d6	;DC3B5034
	and.w	#$0003,d6	;02460003
	swap	d6	;4846
	move.w	d5,d6	;3C05
	cmpi.w	#$0004,d6	;0C460004
	bcc.s	.wychwind_skip1	;640A
	add.w	$0020(a5),d6	;DC6D0020
	and.w	#$0003,d6	;02460003
	bra.s	.wychwind_skip2	;600C

.wychwind_skip1:
	subq.w	#$04,d6	;5946
	add.w	$0020(a5),d6	;DC6D0020
	and.w	#$0003,d6	;02460003
	addq.w	#$04,d6	;5846
.wychwind_skip2:
	bsr	adrCd005332	;6100FED8
	movem.w	(sp)+,d5/d7	;4C9F00A0
	dbra	d5,.wychwind_loop	;51CDFFC2
	rts	;4E75

.wychwind_data:
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$00	;00

Spells_28_ArcBolt:
	move.w	#$0082,d4	;383C0082
	bra	adrCd005320	;6000FEAC

Spells_29_Formwall:
	moveq	#$03,d4	;7803
adrCd005478:
	move.w	d7,d3	;3607
	addq.w	#$02,d3	;5443
	asl.w	#$02,d3	;E543
	bsr	adrCd00847E	;61002FFE
	cmp.w	adrW_00EE72.l,d7	;BE790000EE72
	bcc.s	adrCd0054E4	;645A
	swap	d7	;4847
	cmp.w	adrW_00EE70.l,d7	;BE790000EE70
	bcc.s	adrCd0054E4	;6450
	move.b	$01(a6,d0.w),d1	;12360001
	bmi.s	adrCd0054E4	;6B4A
	and.w	#$0007,d1	;02410007
	bne.s	adrCd0054E4	;6644
	tst.b	$00(a6,d0.w)	;4A360000
	bne.s	adrCd0054E4	;663E
	or.b	#$07,$01(a6,d0.w)	;003600070001
	or.b	d3,d4	;8803
	move.b	d4,$00(a6,d0.w)	;1D840000
	and.w	#$0003,d4	;02440003
	subq.b	#$03,d4	;5704
	bne.s	adrCd0054E4	;662A
	move.w	#$03FF,d1	;323C03FF
adrCd0054BE:
	lea	adrEA0173F6.l,a0	;41F9000173F6
	swap	d0	;4840
	move.w	d1,d0	;3001
	swap	d0	;4840
	moveq	#$00,d1	;7200
adrCd0054CC:
	cmp.w	-$0002(a0),d1	;B268FFFE
	bcc.s	adrCd0054DC	;640A
	cmp.w	$02(a0,d1.w),d0	;B0701002
	beq.s	adrCd0054E0	;6708
	addq.w	#$04,d1	;5841
	bra.s	adrCd0054CC	;60F0

adrCd0054DC:
	addq.w	#$04,-$0002(a0)	;5868FFFE
adrCd0054E0:
	move.l	d0,$00(a0,d1.w)	;21801000
adrCd0054E4:
	rts	;4E75

Spells_30_Summon:
	moveq	#$64,d4	;7864
	bra	adrCd005328	;6000FE3E

Spells_31_Blaze:
	move.w	#$0084,d4	;383C0084
	add.w	#$000A,d7	;0647000A
	lsr.w	#$01,d7	;E24F
	bra	adrCd005328	;6000FE30

Spells_32_Mindrock:
	moveq	#$02,d4	;7802
	bra	adrCd005478	;6000FF7A

adrCd005500:
	moveq	#-$01,d3	;76FF
	moveq	#$03,d2	;7403
adrLp005504:
	move.b	$18(a5,d2.w),d0	;10352018
	and.w	#$00E0,d0	;024000E0
	bne.s	adrCd005540	;6632
	move.b	$18(a5,d2.w),d0	;10352018
	bsr	adrCd006660	;6100114C
	move.b	$0011(a4),d0	;102C0011
	and.w	#$0007,d0	;02400007
	sub.w	d1,d0	;9041
	bne.s	adrCd005540	;661E
	move.b	$0011(a4),d0	;102C0011
	lsr.b	#$03,d0	;E608
	tst.b	d3	;4A03
	bpl.s	adrCd00552E	;6A02
	moveq	#$00,d3	;7600
adrCd00552E:
	cmp.b	d3,d0	;B003
	bcs.s	adrCd005540	;650E
	move.b	d0,d3	;1600
	swap	d3	;4843
	move.b	$18(a5,d2.w),d3	;16352018
	and.w	#$000F,d3	;0243000F
	swap	d3	;4843
adrCd005540:
	dbra	d2,adrLp005504	;51CAFFC2
	rts	;4E75

adrCd005546:
	moveq	#$03,d6	;7C03
	moveq	#$02,d5	;7A02
adrLp00554A:
	bsr.s	adrCd005556	;610A
	add.w	d0,d6	;DC40
	dbra	d5,adrLp00554A	;51CDFFFA
	move.w	d6,d0	;3006
	rts	;4E75

adrCd005556:
	move.w	adrW_0055AA.l,d0	;3039000055AA
	addq.w	#$01,d0	;5240
	mulu	#$B640,d0	;C0FCB640
	move.l	d0,d1	;2200
	asl.l	#$04,d0	;E980
	add.l	d1,d0	;D081
	move.w	#$0511,d1	;323C0511
	moveq	#$00,d3	;7600
adrCd00556E:
	divu	d1,d0	;80C1
	bvc.s	adrCd005580	;680E
	move.w	d0,d2	;3400
	clr.w	d0	;4240
	swap	d0	;4840
	divu	d1,d0	;80C1
	move.w	d0,d3	;3600
	move.w	d2,d0	;3002
	bra.s	adrCd00556E	;60EE

adrCd005580:
	subq.w	#$01,d1	;5341
	swap	d0	;4840
	move.w	d3,d0	;3003
	swap	d0	;4840
	divu	d1,d0	;80C1
	clr.w	d0	;4240
	swap	d0	;4840
	move.w	d0,adrW_0055AA.l	;33C0000055AA
	moveq	#$06,d1	;7206
adrCd005596:
	divu	d1,d0	;80C1
	bvc.s	adrCd0055A6	;680C
	move.w	d0,d2	;3400
	clr.w	d0	;4240
	swap	d0	;4840
	divu	d1,d0	;80C1
	move.w	d2,d0	;3002
	bra.s	adrCd005596	;60F0

adrCd0055A6:
	swap	d0	;4840
	rts	;4E75

adrW_0055AA:
	dc.b	$03	;03
RandomOffsetValue:
	dc.b	$E1	;E1

RandomGen_BytewithOffset:
	moveq	#$01,d1	;7201
	bsr.s	RandomGen	;610C
	swap	d0	;4840
	add.b	RandomOffsetValue(pc),d0	;D03AFFF7
	rts	;4E75

RandomGen_100:
	move.w	#$6400,d1	;323C6400
RandomGen:
	swap	d1	;4841
	moveq	#$00,d0	;7000
	move.b	adrB_0055DE.l,d0	;1039000055DE
	move.w	d0,d1	;3200
	lsr.b	#$03,d1	;E609
	eor.b	d0,d1	;B101
	lsr.b	#$01,d1	;E209
	roxr.b	#$01,d0	;E210
	move.b	d0,adrB_0055DE.l	;13C0000055DE
	swap	d1	;4841
	mulu	d1,d0	;C0C1
	swap	d0	;4840
	rts	;4E75

adrB_0055DE:
	dc.b	$FF	;FF
	dc.b	$FF	;FF

Click_ViewSpell:
	move.w	#$0002,$0014(a5)	;3B7C00020014
	bsr	adrCd00C2AC	;61006CC4
	bpl.s	adrCd0055F6	;6A0A
	bsr	adrCd006698	;610010AA
	bsr	adrCd00CF96	;610079A4
	bra.s	adrCd005624	;602E

adrCd0055F6:
	move.l	a6,-(sp)	;2F0E
	bsr	adrCd006778	;6100117E
	addq.b	#$03,d7	;5607
	bmi.s	adrCd00561A	;6B1A
	lea	SpellsCostTable.l,a0	;41F90000685E
	move.b	$00(a0,d6.w),d0	;10306000
	add.w	d0,d0	;D040
	addq.b	#$01,d0	;5200
	cmp.b	d7,d0	;B007
	bcs.s	adrCd005614	;6502
	move.b	d7,d0	;1007
adrCd005614:
	neg.b	d0	;4400
	move.b	d0,$0014(a4)	;19400014
adrCd00561A:
	bsr	adrCd006698	;6100107C
	move.l	(sp)+,a6	;2C5F
	bsr	adrCd00CFBC	;6100799A
adrCd005624:
	bra	adrCd00C85E	;60007238

adrJA005628:
	move.w	$000E(a5),d7	;3E2D000E
	moveq	#-$01,d2	;74FF
	bsr	adrCd00C714	;610070E4
	bpl.s	adrCd005680	;6A4C
	bsr	adrCd00587C	;61000246
	tst.w	$000C(a5)	;4A6D000C
	bpl.s	adrCd005676	;6A38
	cmpi.w	#$0048,d1	;0C410048
	bcs.s	adrCd005676	;6532
	cmpi.w	#$0058,d1	;0C410058
	bcc.s	adrCd005676	;642C
	swap	d1	;4841
	sub.w	#$00E0,d1	;044100E0
	bcs.s	adrCd005676	;6524
	lsr.w	#$04,d1	;E849
	cmpi.w	#$0005,d1	;0C410005
	beq	Click_CloseSpellBook	;6700014A
	cmpi.w	#$0004,d1	;0C410004
	beq.s	adrCd005678	;6716
	move.b	$18(a5,d1.w),d0	;10351018
	and.w	#$00A0,d0	;024000A0
	bne.s	adrCd005676	;660A
	move.w	#$0011,$000C(a5)	;3B7C0011000C
	move.w	d1,$000E(a5)	;3B41000E
adrCd005676:
	rts	;4E75

adrCd005678:
	move.w	#$0013,$000C(a5)	;3B7C0013000C
	rts	;4E75

adrCd005680:
	move.w	#$0012,$000C(a5)	;3B7C0012000C
	move.b	d7,$000E(a5)	;1B47000E
	rts	;4E75

adrB_00568C:
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00

adrCd005694:
	bsr	adrCd0084D6	;61002E40
	moveq	#$03,d1	;7203
	bsr	adrCd005500	;6100FE64
	moveq	#$0B,d2	;740B
	tst.w	d3	;4A43
	bmi.s	adrCd0056AC	;6B08
	addq.w	#$01,d3	;5243
	add.w	d3,d3	;D643
	sub.w	d3,d2	;9443
	bcs.s	adrCd005676	;65CA
adrCd0056AC:
	move.l	adrL_00EE78.l,a2	;24790000EE78
	add.w	adrW_00EE76.l,a2	;D4F90000EE76
	move.l	a6,a3	;264E
	move.w	adrW_00EE72.l,d0	;30390000EE72
	mulu	adrW_00EE70.l,d0	;C0F90000EE70
	subq.w	#$01,d0	;5340
adrLp0056C8:
	move.w	(a2)+,d1	;321A
	and.w	#$0007,d1	;02410007
	cmpi.b	#$02,d1	;0C010002
	bne.s	adrCd0056DC	;6608
	btst	#$04,-$0001(a2)	;082A0004FFFF
	bne.s	adrCd0056EE	;6612
adrCd0056DC:
	cmpi.b	#$07,d1	;0C010007
	bne.s	adrCd0056F0	;660E
	move.b	-$0002(a2),d1	;122AFFFE
	and.w	#$0003,d1	;02410003
	subq.w	#$01,d1	;5341
	beq.s	adrCd0056F0	;6702
adrCd0056EE:
	moveq	#$01,d1	;7201
adrCd0056F0:
	move.b	adrB_00568C(pc,d1.w),(a3)+	;16FB109A
	dbra	d0,adrLp0056C8	;51C8FFD2
	lea	adrEA01674C.l,a2	;45F90001674C
	lea	adrEA0167CC.l,a3	;47F9000167CC
	move.b	$001F(a5),$0001(a2)	;156D001F0001
	move.b	$001D(a5),(a2)	;14AD001D
	move.b	#$FF,$0002(a2)	;157C00FF0002
adrLp005714:
	move.l	a2,a0	;204A
	move.l	a3,a1	;224B
adrCd005718:
	moveq	#$00,d7	;7E00
	move.b	(a0)+,d7	;1E18
	bmi.s	adrCd00575A	;6B3C
	swap	d7	;4847
	move.b	(a0)+,d7	;1E18
	subq.w	#$01,d7	;5347
	bcs.s	adrCd00572A	;6504
	moveq	#$02,d1	;7202
	bsr.s	adrCd00576A	;6140
adrCd00572A:
	addq.w	#$02,d7	;5447
	cmp.w	adrW_00EE72.l,d7	;BE790000EE72
	bcc.s	adrCd005738	;6404
	moveq	#$00,d1	;7200
	bsr.s	adrCd00576A	;6132
adrCd005738:
	subq.w	#$01,d7	;5347
	swap	d7	;4847
	addq.w	#$01,d7	;5247
	cmp.w	adrW_00EE70.l,d7	;BE790000EE70
	bcc.s	adrCd00574E	;6408
	swap	d7	;4847
	moveq	#$03,d1	;7203
	bsr.s	adrCd00576A	;611E
	swap	d7	;4847
adrCd00574E:
	subq.w	#$02,d7	;5547
	bcs.s	adrCd005718	;65C6
	swap	d7	;4847
	moveq	#$01,d1	;7201
	bsr.s	adrCd00576A	;6112
	bra.s	adrCd005718	;60BE

adrCd00575A:
	cmp.l	a1,a3	;B7C9
	beq.s	adrCd005792	;6734
	move.b	#$FF,(a1)	;12BC00FF
	exg	a2,a3	;C74A
	dbra	d2,adrLp005714	;51CAFFAE
	rts	;4E75

adrCd00576A:
	move.w	d7,d0	;3007
	mulu	adrW_00EE70.l,d0	;C0F90000EE70
	swap	d7	;4847
	add.w	d7,d0	;D047
	swap	d7	;4847
	tst.b	$00(a6,d0.w)	;4A360000
	bmi.s	adrCd005792	;6B14
	beq.s	adrCd005782	;6702
	rts	;4E75

adrCd005782:
	or.b	#$80,d1	;00010080
	move.b	d1,$00(a6,d0.w)	;1D810000
	swap	d7	;4847
	move.b	d7,(a1)+	;12C7
	swap	d7	;4847
	move.b	d7,(a1)+	;12C7
adrCd005792:
	rts	;4E75

adrEA005794:
	dc.w	$0001	;0001
	dc.w	$00FF	;00FF
	dc.w	$0101	;0101
	dc.w	$FFFF	;FFFF
	dc.w	$FF00	;FF00
	dc.w	$0100	;0100
	dc.w	$FF01	;FF01
	dc.w	$01FF	;01FF

Click_CloseSpellBook:
	clr.w	$0014(a5)	;426D0014
	bra	adrCd008278	;60002ACE

adrCd0057AC:
	btst	#$06,$0018(a5)	;082D00060018
	bne.s	adrCd005792	;66DE
	pea	adrL_008226.l	;487900008226
adrCd0057BA:
	move.w	$000C(a5),d0	;302D000C
	bmi.s	adrCd005792	;6BD2
	asl.w	#$02,d0	;E540
	lea	InterfaceButtons.l,a0	;41F9000057CE
	move.l	$00(a0,d0.w),a0	;20700000
	jmp	(a0)	;4ED0

InterfaceButtons:
	dc.l	adrJA006684	;00006684
	dc.l	Click_ShowStats	;00006616
	dc.l	Click_MultiFunctionButton	;000064AA
	dc.l	Click_OpenInventory	;00006BF0
	dc.l	adrJA005F9E	;00005F9E
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
	dc.l	adrJA006C0A	;00006C0A
	dc.l	adrJA006A46	;00006A46
	dc.l	Click_Item_17_to_1A_Potions	;00006914
	dc.l	adrJA005862	;00005862
	dc.l	Click_LaunchSpellFromBook	;00004E7A
	dc.l	Click_ViewSpell	;000055E0
	dc.l	Click_TurnSpellBookPage	;0000C2EA
	dc.l	Click_CloseSpellBook	;000057A4
	dc.l	Click_TurnSpellBookPage	;0000C2EA
	dc.l	Click_CommsAndOptions	;0000420C
	dc.l	adrJA005862	;00005862
	dc.l	Click_PauseGame	;0000425E
	dc.l	Click_LoadSaveGame	;0000432A
	dc.l	Click_SleepParty	;00004536
	dc.l	Click_ShowTeamAvatars	;000032DE
	dc.l	adrJA004C10	;00004C10
	dc.l	adrJA00336A	;0000336A
	dc.l	adrJA005D3E	;00005D3E
	dc.l	adrJA005894	;00005894
	dc.l	adrJA0064D0	;000064D0

adrJA005862:
	rts	;4E75

adrEA005864:
	dc.w	$0074	;0074
	dc.w	$00CC	;00CC
	dc.w	$0049	;0049
	dc.w	$0059	;0059
	dc.w	$0088	;0088
	dc.w	$00B8	;00B8
	dc.w	$0028	;0028
	dc.w	$003C	;003C
	dc.w	$0072	;0072
	dc.w	$00CD	;00CD
	dc.w	$001C	;001C
	dc.w	$0048	;0048

adrCd00587C:
	moveq	#$22,d0	;7022
	moveq	#$26,d2	;7426
	lea	adrEA005864.w,a6	;4DF85864	;Short Absolute converted to symbol!
	move.w	#$FFFF,$000C(a5)	;3B7CFFFF000C
	bra	adrCd004DB4	;6000F528

Click_Display:
	bsr.s	adrCd00587C	;61EC
	bra	adrCd0057BA	;6000FF28

adrJA005894:
	bsr	adrCd00847E	;61002BE8
	cmp.w	adrW_00EE72.l,d7	;BE790000EE72
	bcc.s	adrCd0058EA	;644A
	swap	d7	;4847
	cmp.w	adrW_00EE70.l,d7	;BE790000EE70
	bcc.s	adrCd0058EA	;6440
	swap	d7	;4847
	move.w	$00(a6,d0.w),d2	;34360000
	move.w	d2,d3	;3602
	and.w	#$0007,d2	;02420007
	subq.w	#$01,d2	;5342
	bne	adrJA0064D0	;66000C16
	tst.b	d3	;4A03
	bpl.s	adrCd0058EA	;6A2A
	move.b	$01(a6,d0.w),d3	;16360001
	lsr.w	#$04,d3	;E84B
	and.w	#$0003,d3	;02430003
	eor.w	#$0002,d3	;0A430002
	cmp.w	$0020(a5),d3	;B66D0020
	bne.s	adrCd0058EA	;6616
	move.b	$00(a6,d0.w),d3	;16360000
	and.w	#$0003,d3	;02430003
	add.w	d3,d3	;D643
	lea	MainWall_Action_01.l,a0	;41F9000058F4
	add.w	adrJT0058EC(pc,d3.w),a0	;D0FB3006
	jmp	(a0)	;4ED0

adrCd0058EA:
	rts	;4E75

adrJT0058EC:
	dc.w	MainWall_Action_01-MainWall_Action_01	;0000
	dc.w	MainWall_Action_02-MainWall_Action_01	;0018
	dc.w	MainWall_Action_03-MainWall_Action_01	;0236
	dc.w	MainWall_Action_04-MainWall_Action_01	;0064

MainWall_Action_01:
	move.w	$0004(a5),d1	;322D0004
	sub.w	$0008(a5),d1	;926D0008
	moveq	#$02,d6	;7C02
	cmpi.w	#$0033,d1	;0C410033
	bcs	adrCd005D4E	;6500044A
	moveq	#$03,d6	;7C03
	bra	adrCd005D4E	;60000444

MainWall_Action_02:
	moveq	#$00,d1	;7200
	move.b	$00(a6,d0.w),d1	;12360000
	lsr.b	#$02,d1	;E409
	subq.b	#$05,d1	;5B01
	bcc.s	adrCd00591A	;6402
	rts	;4E75

adrCd00591A:
	move.w	d1,-(sp)	;3F01
	moveq	#$38,d5	;7A38
	bsr	adrCd00CC3A	;6100731A
	move.w	(sp)+,d1	;321F
	move.w	CurrentTower.l,d0	;30390000EE2E
	add.b	ScrollTowerOffsets(pc,d0.w),d1	;D23B0026
	lea	ScrollOffsets.l,a0	;41F90001A31C
	lea	$0092(a0),a6	;4DE80092
	add.w	d1,d1	;D241
	add.w	$00(a0,d1.w),a6	;DCF01000
	move.w	#$0004,$0014(a5)	;3B7C00040014
	move.l	#$00000003,adrW_00D92A.l	;23FC000000030000D92A
	bra	Print_fflim_text	;60007776

ScrollTowerOffsets:
	dc.b	$00	;00
	dc.b	$15	;15
	dc.b	$21	;21
	dc.b	$29	;29
	dc.b	$31	;31
	dc.b	$3B	;3B

MainWall_Action_04:
	moveq	#$00,d1	;7200
	move.b	$00(a6,d0.w),d1	;12360000
	btst	#$02,d1	;08010002
	bne.s	adrCd005986	;6622
	tst.w	$002E(a5)	;4A6D002E
	bne.s	adrCd005984	;661A
	lsr.w	#$03,d1	;E649
	add.w	#$0060,d1	;06410060
	move.w	d1,$002E(a5)	;3B41002E
	move.w	#$0001,$002C(a5)	;3B7C0001002C
	bset	#$02,$00(a6,d0.w)	;08F600020000
	bra	adrCd005D40	;600003BE

adrCd005984:
	rts	;4E75

adrCd005986:
	lsr.w	#$03,d1	;E649
	add.w	#$0060,d1	;06410060
	cmp.w	$002E(a5),d1	;B26D002E
	bne.s	adrCd005984	;66F2
	clr.l	$002C(a5)	;42AD002C
	movem.l	d0/a6,-(sp)	;48E78002
	bsr	adrCd005D40	;610003A4
	movem.l	(sp)+,d0/a6	;4CDF4001
	move.b	$00(a6,d0.w),d1	;12360000
	lsr.w	#$02,d1	;E449
	and.w	#$000E,d1	;0241000E
	lea	SocketActions_SerpentCrystal.l,a0	;41F9000059CE
	add.w	Sockets_LookupTable(pc,d1.w),a0	;D0FB100A
	jsr	(a0)	;4E90
	moveq	#$05,d0	;7005
	bra	PlaySound	;60002F02

Sockets_LookupTable:
	dc.w	SocketActions_SerpentCrystal-SocketActions_SerpentCrystal	;0000
	dc.w	SocketActions_ChaosCrystal-SocketActions_SerpentCrystal	;0024
	dc.w	SocketActions_DragonCrystal-SocketActions_SerpentCrystal	;006A
	dc.w	SocketActions_MoonCrystal-SocketActions_SerpentCrystal	;008A
	dc.w	Exit_SocketAction-SocketActions_SerpentCrystal	;0022
	dc.w	SocketActions_BluishGem-SocketActions_SerpentCrystal	;00E0
	dc.w	Exit_SocketAction-SocketActions_SerpentCrystal	;0022
	dc.w	SocketActions_TanGem-SocketActions_SerpentCrystal	;00D8

SocketActions_SerpentCrystal:
	moveq	#$05,d4	;7805
	moveq	#$12,d6	;7C12
	bsr	adrCd005A7C	;610000A8
	cmp.w	#$0005,CurrentTower.l	;0C7900050000EE2E
	bne.s	Exit_SocketAction	;6610
	move.l	#$00090001,d7	;2E3C00090001
Last_CrystalAction:
	bsr	CoordToMap	;61002AB4
	and.w	#$00F8,$00(a6,d0.w)	;027600F80000
Exit_SocketAction:
	rts	;4E75

SocketActions_ChaosCrystal:
	bclr	#$02,$00(a6,d0.w)	;08B600020000
	bsr	adrCd008498	;61002A9E
	bsr	adrCd0078FA	;61001EFC
	cmp.w	#$0005,CurrentTower.l	;0C7900050000EE2E
	bne.s	Exit_SocketAction	;66E6
	lea	UnpackedMonsters.l,a0	;41F900016B7E
	cmp.b	#$6B,$000B(a0)	;0C28006B000B
	bne.s	.EntropySummoned	;6618
	tst.b	(a0)	;4A10
	bpl.s	.EntropySummoned	;6A14
	and.b	#$7F,(a0)	;0210007F
	move.l	#$00090008,d7	;2E3C00090008
	bsr	CoordToMap	;61002A74
	bset	#$07,$01(a6,d0.w)	;08F600070001
.EntropySummoned:
	move.l	#$00090003,d7	;2E3C00090003
	bra.s	Last_CrystalAction	;60AE

SocketActions_DragonCrystal:
	moveq	#$07,d4	;7807
	moveq	#$11,d6	;7C11
	bsr.s	adrCd005A7C	;613E
	cmp.w	#$0005,CurrentTower.l	;0C7900050000EE2E
	bne.s	Exit_SocketAction	;66A8
	move.l	#$00100008,d7	;2E3C00100008
	bsr.s	Last_CrystalAction	;6196
	move.l	#$00040008,d7	;2E3C00040008	;
	bra.s	Last_CrystalAction	;608E

SocketActions_MoonCrystal:
	moveq	#$09,d4	;7809
	moveq	#$13,d6	;7C13
	bsr.s	adrCd005A7C	;611E
	cmp.w	#$0005,CurrentTower.l	;0C7900050000EE2E
	bne.s	Exit_SocketAction	;6688
	move.l	#$00030009,d7	;2E3C00030009	;Long Addr replaced with Symbol
	bsr	Last_CrystalAction	;6100FF76
	move.l	#$000F0009,d7	;2E3C000F0009
	bra	Last_CrystalAction	;6000FF6C

adrCd005A7C:
	bclr	#$02,$00(a6,d0.w)	;08B600020000
	moveq	#$03,d7	;7E03
adrLp005A84:
	move.b	$18(a5,d7.w),d0	;10357018
	bmi.s	adrCd005A94	;6B0A
	bsr	adrCd006660	;61000BD4
	move.b	$01(a4,d4.w),$00(a4,d4.w)	;19B440014000
adrCd005A94:
	dbra	d7,adrLp005A84	;51CFFFEE
	bsr	adrCd008498	;610029FE
	move.w	d6,d7	;3E06
	bsr	adrCd001DBC	;6100C31C
	bra	adrCd007FF8	;60002554

SocketActions_TanGem:
	lea	TanGemLocs.l,a0	;41F900005AFA
	bra.s	TeleportGem	;6006

SocketActions_BluishGem:
	lea	BlueGemLocs.l,a0	;41F900005B12
TeleportGem:
	move.w	CurrentTower.l,d1	;32390000EE2E
	asl.w	#$02,d1	;E541
	add.w	d1,a0	;D0C1
	moveq	#$00,d6	;7C00
	move.b	(a0)+,d6	;1C18
	swap	d6	;4846
	move.b	(a0)+,d6	;1C18
	cmp.l	$001C(a5),d6	;BCAD001C
	bne.s	adrCd005AD2	;6606
	move.b	(a0)+,d6	;1C18
	swap	d6	;4846
	move.b	(a0),d6	;1C10
adrCd005AD2:
	bsr	adrCd008498	;610029C4
	bclr	#$07,$01(a6,d0.w)	;08B600070001
	move.l	d6,$001C(a5)	;2B46001C
	bsr	adrCd00847E	;6100299C
	bchg	#$02,$00(a6,d0.w)	;087600020000
	bsr	adrCd008498	;610029AC
	bset	#$07,$01(a6,d0.w)	;08F600070001
	moveq	#$10,d7	;7E10
	bra	adrCd001DBC	;6000C2C4

TanGemLocs:
	INCBIN bw-data/gem-tan.locations

BlueGemLocs:
	INCBIN bw-data/gem-blu.locations

MainWall_Action_03:
	moveq	#$00,d1	;7200
	move.b	$00(a6,d0.w),d1	;12360000
	and.w	#$00F8,d1	;024100F8
	beq.s	Switch_00_s00_Null	;6730
	bchg	#$02,$00(a6,d0.w)	;087600020000
	lsr.b	#$01,d1	;E209
	move.w	CurrentTower.l,d0	;30390000EE2E
	asl.w	#$06,d0	;ED40
	lea	SwitchData_1.l,a1	;43F900005B78
	add.w	d0,a1	;D2C0
	moveq	#$00,d0	;7000
	move.b	$00(a1,d1.w),d0	;10311000
	lea	Switch_00_s00_Null.l,a0	;41F900005B66
	add.w	Switches_LookupTable(pc,d0.w),a0	;D0FB000C
	jsr	(a0)	;4E90
	moveq	#$00,d0	;7000
	bra	PlaySound	;60002D5A

Switch_00_s00_Null:
	rts	;4E75

Switches_LookupTable:
	dc.w	Switch_00_s00_Null-Switch_00_s00_Null	;0000
	dc.w	Switch_01_s02_Trigger_11_t16_RemoveXY-Switch_00_s00_Null	;01AC
	dc.w	Switch_02_s04_Trigger_23_t2E-Switch_00_s00_Null	;0196
	dc.w	Switch_03_s06_Trigger_03_t06_OpenLockedDoorXY-Switch_00_s00_Null	;1BE0
	dc.w	Switch_04_s08_Trigger_22_t2C_RotateWallXY-Switch_00_s00_Null	;1B4E
	dc.w	Switch05_s0A_Trigger_13_t1A_TogglePillarXY-Switch_00_s00_Null	;1C06
	dc.w	Switch06_s0C_Trigger_18_t24_CreatePillarXY-Switch_00_s00_Null	;1C02
	dc.w	Switch_07_s0E_Trigger_26_t34_RotateWoodXY-Switch_00_s00_Null	;1BF2
SwitchData_1:
	INCBIN bw-data/mod0.switches

SwitchData_2:
	INCBIN bw-data/serp.switches

SwitchData_3:
	INCBIN bw-data/moon.switches

SwitchData_4:
	INCBIN bw-data/drag.switches

SwitchData_5:
	INCBIN bw-data/chaos.switches

SwitchData_6:
	INCBIN bw-data/zendik.switches

Switch_00_s00_Trigger_15_t1E_ToggleWallXY:
	bsr	Switch_01_s02_Trigger_11_t16_RemoveXY	;61000018
Switch_02_s04_Trigger_23_t2E:
	bsr.s	adrCd005D2E	;6130
	tst.b	$01(a6,d0.w)	;4A360001
	bmi.s	adrCd005D10	;6B0C
	and.w	#$00F9,$00(a6,d0.w)	;027600F90000
	eor.b	#$01,$01(a6,d0.w)	;0A3600010001
adrCd005D10:
	rts	;4E75

Switch_01_s02_Trigger_11_t16_RemoveXY:
	bsr.s	adrCd005D2E	;611A
	move.b	$01(a6,d0.w),d2	;14360001
	and.w	#$0007,d2	;02420007
	subq.w	#$01,d2	;5342
	bne.s	adrCd005D26	;6606
	and.b	#$4F,$01(a6,d0.w)	;0236004F0001
adrCd005D26:
	and.b	#$F8,$01(a6,d0.w)	;023600F80001
	rts	;4E75

adrCd005D2E:
	moveq	#$00,d7	;7E00
	move.b	$02(a1,d1.w),d7	;1E311002
	swap	d7	;4847
	move.b	$03(a1,d1.w),d7	;1E311003
	bra	CoordToMap	;60002760

adrJA005D3E:
	bsr.s	adrCd005D52	;6112
adrCd005D40:
	cmp.w	#$0003,$0014(a5)	;0C6D00030014
	beq	adrCd006C34	;67000EEC
	bra	adrCd006CD2	;60000F86

adrCd005D4E:
	bsr.s	adrCd005D9E	;614E
	bra.s	adrCd005D40	;60EE

adrCd005D52:
	move.l	$0002(a5),d1	;222D0002
	sub.w	$0008(a5),d1	;926D0008
	moveq	#$02,d6	;7C02
	cmpi.w	#$0051,d1	;0C410051
	bcs.s	adrCd005D64	;6502
	subq.w	#$02,d6	;5546
adrCd005D64:
	swap	d1	;4841
	cmpi.w	#$00A0,d1	;0C4100A0
	bcs.s	adrCd005D6E	;6502
	addq.w	#$01,d6	;5246
adrCd005D6E:
	move.l	$001C(a5),d7	;2E2D001C
	cmpi.w	#$0002,d6	;0C460002
	bcc.s	adrCd005D7E	;6406
	bsr	CoordToMap	;61002722
	bra.s	adrCd005D9E	;6020

adrCd005D7E:
	bsr	adrCd008482	;61002702
	cmp.w	adrW_00EE72.l,d7	;BE790000EE72
	bcc.s	adrCd005D9C	;6412
	swap	d7	;4847
	cmp.w	adrW_00EE70.l,d7	;BE790000EE70
	bcc.s	adrCd005D9C	;6408
	swap	d7	;4847
	bsr	adrCd005E42	;610000AA
	bcc.s	adrCd005D9E	;6402
adrCd005D9C:
	rts	;4E75

adrCd005D9E:
	bclr	#$03,$01(a6,d0.w)	;08B600030001
	tst.w	$002E(a5)	;4A6D002E
	bne	adrCd005E7C	;660000D2
	btst	#$06,$01(a6,d0.w)	;083600060001
	beq.s	adrCd005D9C	;67E8
	bsr	adrCd005F2E	;61000178
	bsr	adrCd005F5C	;610001A2
	bne.s	adrCd005D9C	;66DE
	lea	$03(a0,d7.w),a1	;43F07003
	moveq	#$00,d3	;7600
	move.b	-$0001(a1),d3	;1629FFFF
	add.w	d3,d3	;D643
	moveq	#$00,d1	;7200
	move.b	$00(a1,d3.w),d1	;12313000
	move.w	d1,$002E(a5)	;3B41002E
	move.b	$01(a1,d3.w),d1	;12313001
	moveq	#$01,d2	;7401
	cmp.w	#$0005,$002E(a5)	;0C6D0005002E
	bcc.s	adrCd005DEC	;640A
	move.w	d1,d2	;3401
	cmpi.b	#$64,d2	;0C020064
	bcs.s	adrCd005DEC	;6502
	moveq	#$63,d2	;7463
adrCd005DEC:
	move.w	d2,$002C(a5)	;3B42002C
	sub.b	d2,d1	;9202
	move.b	d1,$01(a1,d3.w)	;13813001
	bne.s	adrCd005D9C	;66A4
adrCd005DF8:
	subq.b	#$01,-$0001(a1)	;5329FFFF
	bcs.s	adrCd005E1E	;6520
	lea	$00(a1,d3.w),a1	;43F13000
	lea	$0002(a1),a2	;45E90002
	add.w	d3,d7	;DE43
	addq.w	#$03,d7	;5647
	subq.w	#$02,-$0002(a0)	;5568FFFE
adrCd005E0E:
	move.w	-$0002(a0),d2	;3428FFFE
	sub.w	d7,d2	;9447
	bra.s	adrCd005E18	;6002

adrLp005E16:
	move.b	(a2)+,(a1)+	;12DA
adrCd005E18:
	dbra	d2,adrLp005E16	;51CAFFFC
	rts	;4E75

adrCd005E1E:
	lea	$00(a0,d7.w),a1	;43F07000
	lea	$0005(a1),a2	;45E90005
	subq.w	#$05,-$0002(a0)	;5B68FFFE
	bsr.s	adrCd005E0E	;61E2
	moveq	#$03,d5	;7A03
adrLp005E2E:
	move.w	d5,d6	;3C05
	bsr	adrCd005F5C	;6100012A
	beq.s	adrCd005E40	;670A
	dbra	d5,adrLp005E2E	;51CDFFF6
	bclr	#$06,$01(a6,d0.w)	;08B600060001
adrCd005E40:
	rts	;4E75

adrCd005E42:
	swap	d6	;4846
	move.w	$0020(a5),d6	;3C2D0020
	move.w	d0,d2	;3400
	bsr	adrCd008498	;6100264C
	bsr	adrCd007AE6	;61001C96
	bcs.s	adrCd005E7A	;6526
	move.w	d2,d0	;3002
	move.b	$01(a6,d0.w),d1	;12360001
	and.w	#$0007,d1	;02410007
	subq.w	#$01,d1	;5341
	beq.s	adrCd005E76	;6714
	subq.w	#$01,d1	;5341
	bne.s	adrCd005E70	;660A
	eor.w	#$0002,d6	;0A460002
	bsr	adrCd007AF4	;61001C88
	bcs.s	adrCd005E7A	;650A
adrCd005E70:
	move.w	d2,d0	;3002
	swap	d6	;4846
	rts	;4E75

adrCd005E76:
	sub.b	#$FF,d1	;040100FF
adrCd005E7A:
	rts	;4E75

adrCd005E7C:
	move.l	$002C(a5),d5	;2A2D002C
	clr.l	$002C(a5)	;42AD002C
	bsr	adrCd005F2E	;610000A8
adrCd005E88:
	bclr	#$03,$01(a6,d0.w)	;08B600030001
	bsr	adrCd005F5C	;610000CC
	bne	adrCd005F04	;66000070
	lea	$03(a0,d7.w),a1	;43F07003
	moveq	#$00,d3	;7600
	move.b	-$0001(a1),d3	;1629FFFF
	add.w	d3,d3	;D643
adrCd005EA2:
	cmp.b	$00(a1,d3.w),d5	;BA313000
	beq.s	adrCd005EE2	;673A
	subq.w	#$02,d3	;5543
	bcc.s	adrCd005EA2	;64F6
adrCd005EAC:
	move.w	-$0002(a0),d2	;3428FFFE
	addq.w	#$02,-$0002(a0)	;5468FFFE
	addq.b	#$01,-$0001(a1)	;5229FFFF
	moveq	#$00,d3	;7600
	move.b	-$0001(a1),d3	;1629FFFF
	add.w	d3,d3	;D643
	lea	$00(a0,d2.w),a0	;41F02000
	lea	$0002(a0),a2	;45E80002
	add.w	d3,d7	;DE43
	addq.w	#$03,d7	;5647
	sub.w	d7,d2	;9447
	bra.s	adrCd005ED2	;6002

adrLp005ED0:
	move.b	-(a0),-(a2)	;1520
adrCd005ED2:
	dbra	d2,adrLp005ED0	;51CAFFFC
	move.b	d5,$00(a1,d3.w)	;13853000
	swap	d5	;4845
	move.b	d5,$01(a1,d3.w)	;13853001
	rts	;4E75

adrCd005EE2:
	swap	d5	;4845
	add.b	$01(a1,d3.w),d5	;DA313001
	tst.b	-$0001(a1)	;4A29FFFF
	bne.s	adrCd005EF4	;6606
	move.b	d5,$01(a1,d3.w)	;13853001
	rts	;4E75

adrCd005EF4:
	swap	d5	;4845
	move.w	d7,d1	;3207
	bsr	adrCd005DF8	;6100FEFE
	move.w	d1,d7	;3E01
	lea	$03(a0,d7.w),a1	;43F07003
	bra.s	adrCd005EAC	;60A8

adrCd005F04:
	bset	#$06,$01(a6,d0.w)	;08F600060001
	addq.w	#$05,-$0002(a0)	;5A68FFFE
	move.w	d0,d1	;3200
	move.b	d1,$01(a0,d7.w)	;11817001
	ror.w	#$08,d1	;E059
	or.b	d6,d1	;8206
	move.b	d1,$00(a0,d7.w)	;11817000
	move.b	#$00,$02(a0,d7.w)	;11BC00007002
	move.b	d5,$03(a0,d7.w)	;11857003
	swap	d5	;4845
	move.b	d5,$04(a0,d7.w)	;11857004
	rts	;4E75

adrCd005F2E:
	move.w	$0020(a5),d1	;322D0020
	add.w	d1,d1	;D241
	add.w	d1,d1	;D241
	add.w	d6,d1	;D246
	move.b	adrB_005F3E(pc,d1.w),d6	;1C3B1004
	rts	;4E75

adrB_005F3E:
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

adrCd005F4E:
	lea	adrEA0174F8.l,a0	;41F9000174F8
adrCd005F54:
	cmp.w	(a0),d0	;B050
	beq.s	adrCd005F92	;673A
	addq.w	#$04,a0	;5848
	bra.s	adrCd005F54	;60F8

adrCd005F5C:
	move.l	adrL_00EE78.l,a0	;20790000EE78
	add.w	#$0FCA,a0	;D0FC0FCA
	move.w	d0,d1	;3200
	ror.w	#$08,d1	;E059
	ror.b	#$02,d6	;E41E
	or.b	d6,d1	;8206
	moveq	#$00,d7	;7E00
	moveq	#$00,d2	;7400
adrCd005F72:
	cmp.w	-$0002(a0),d7	;BE68FFFE
	bcc.s	adrCd005F90	;6418
	cmp.b	$01(a0,d7.w),d0	;B0307001
	bne.s	adrCd005F84	;6606
	cmp.b	$00(a0,d7.w),d1	;B2307000
	beq.s	adrCd005F92	;670E
adrCd005F84:
	move.b	$02(a0,d7.w),d2	;14307002
	add.w	d2,d2	;D442
	add.w	d2,d7	;DE42
	addq.w	#$05,d7	;5A47
	bra.s	adrCd005F72	;60E2

adrCd005F90:
	moveq	#$01,d1	;7201
adrCd005F92:
	rts	;4E75

Click_Display_Centre:
	and.b	#$01,(a5)	;02150001
	bset	#$03,(a5)	;08D50003
	bra.s	adrCd005FA6	;6008

adrJA005F9E:
	and.b	#$01,(a5)	;02150001
	bset	#$01,(a5)	;08D50001
adrCd005FA6:
	moveq	#$03,d1	;7203
	bsr	adrCd005500	;6100F556
	tst.w	d3	;4A43
	bmi.s	adrCd005F92	;6BE2
	swap	d3	;4843
	move.w	d3,d0	;3003
	bsr	adrCd006660	;610006AA
	clr.b	$0011(a4)	;422C0011
	bsr	adrCd0081CE	;61002210
	bra	adrCd007B50	;60001B8E

adrCd005FC4:
	lea	_GFX_Pockets+$6508.l,a1	;43F900052C0A
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	$000A(a5),a0	;D0ED000A
	moveq	#$00,d0	;7000
	move.b	$18(a5,d7.w),d0	;10357018
	move.w	d0,d1	;3200
	and.w	#$000F,d1	;0241000F
	and.w	#$00E0,d0	;024000E0
	bne.s	adrCd005F92	;66AC
	move.w	d1,d0	;3001
	and.w	#$0003,d1	;02410003
	mulu	#$0460,d1	;C2FC0460
	add.w	d1,a1	;D2C1
	bsr	adrCd006900	;6100090C
	move.b	adrB_00600C(pc,d0.w),d3	;163B0014
	move.w	d7,d0	;3007
	add.w	d0,d0	;D040
	add.w	adrW_006010(pc,d0.w),a0	;D0FB0010
	move.l	#$00000006,-(sp)	;2F3C00000006
	bra	adrCd007E62	;60001E58

adrB_00600C:
	dc.b	$06	;06
	dc.b	$0D	;0D
	dc.b	$0C	;0C
	dc.b	$08	;08
adrW_006010:
	dc.w	$0DF4	;0DF4
	dc.w	$0000	;0000
	dc.w	$000D	;000D
	dc.w	$001B	;001B

adrCd006018:
	sub.w	$0020(a1),d0	;90690020
	addq.w	#$02,d0	;5440
	eor.w	#$0001,d2	;0A420001
	add.w	d2,d0	;D042
	and.w	#$0003,d0	;02400003
	moveq	#$00,d1	;7200
	move.b	$26(a1,d0.w),d1	;12310026
	bpl.s	adrCd006046	;6A16
	sub.w	d2,d0	;9042
	eor.w	#$0001,d2	;0A420001
	add.w	d2,d0	;D042
	and.w	#$0003,d0	;02400003
	move.b	$26(a1,d0.w),d1	;12310026
	bpl.s	adrCd006046	;6A04
	move.w	$0006(a1),d1	;32290006
adrCd006046:
	and.w	#$000F,d1	;0241000F
	clr.w	adrW_006458.l	;427900006458
	movem.l	d0/d1/a1/a4/a5,-(sp)	;48E7C04C
	move.w	d1,d0	;3001
	move.l	a1,a5	;2A49
	bsr	adrCd004078	;6100E01E
	move.b	(a5),d2	;1415
	and.w	#$000A,d2	;0242000A
	beq.s	adrCd006084	;6720
	btst	#$04,$18(a5,d1.w)	;083500041018
	beq.s	adrCd006074	;6708
	and.w	#$0008,d2	;02420008
	beq.s	adrCd006090	;671E
	bra.s	adrCd006084	;6010

adrCd006074:
	bsr	adrCd006660	;610005EA
	move.b	$0006(a4),d0	;102C0006
	lsr.b	#$01,d0	;E208
	cmp.b	$0005(a4),d0	;B02C0005
	bcs.s	adrCd006090	;650C
adrCd006084:
	move.w	#$FFFF,adrW_006458.l	;33FCFFFF00006458
	bset	d1,$003C(a5)	;03ED003C
adrCd006090:
	movem.l	(sp)+,d0/d1/a1/a4/a5	;4CDF3203
adrCd006094:
	rts	;4E75

adrCd006096:
	tst.b	d7	;4A07
	bne.s	adrCd0060A2	;6608
	cmp.b	#$02,$0015(a5)	;0C2D00020015
	bcc.s	adrCd006094	;64F2
adrCd0060A2:
	or.b	#$B0,$0054(a5)	;002D00B00054
	moveq	#$67,d4	;7867
	moveq	#$06,d5	;7A06
	swap	d4	;4844
	swap	d5	;4845
	move.b	adrB_0060C2(pc,d7.w),d4	;183B7010
	move.b	adrB_0060C6(pc,d7.w),d5	;1A3B7010
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$00,d3	;7600
	bra	BW_draw_bar	;600079A8

adrB_0060C2:
	dc.b	$60	;60
	dc.b	$00	;00
	dc.b	$68	;68
	dc.b	$D8	;D8
adrB_0060C6:
	dc.b	$59	;59
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00

adrCd0060CA:
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	$000A(a5),a0	;D0ED000A
	move.l	a4,-(sp)	;2F0C
	move.b	$18(a5,d7.w),d0	;10357018
	bsr	adrCd006660	;61000584
	move.b	$0019(a4),d0	;102C0019
	move.l	(sp)+,a4	;285F
	lsr.b	#$04,d0	;E808
	subq.b	#$02,d0	;5500
	move.b	d0,$5E(a5,d7.w)	;1B80705E
	add.w	d7,d7	;DE47
	add.w	adrW_006134(pc,d7.w),a0	;D0FB7044
	moveq	#$0B,d6	;7C0B
	tst.w	d7	;4A47
	bne.s	adrCd006102	;660A
	moveq	#$0E,d6	;7C0E
	or.b	#$10,$0054(a5)	;002D00100054
	bra.s	adrCd006108	;6006

adrCd006102:
	or.b	#$A0,$0054(a5)	;002D00A00054
adrCd006108:
	move.l	#$000D0000,adrW_00D92A.l	;23FC000D00000000D92A
	lea	OutcomeMsgs_0.l,a6	;4DF900006142
	move.b	OutcomeMsgOffsets(pc,d4.w),d4	;183B4022
	bne.s	adrCd00612E	;6610
	move.w	d5,d0	;3005
	beq.s	adrCd006130	;670E
	lea	OutcomeMsgs_5.l,a6	;4DF90000616B
	moveq	#$09,d2	;7409
	bsr.s	adrCd006178	;614C
	moveq	#$00,d4	;7800
adrCd00612E:
	add.w	d4,a6	;DCC4
adrCd006130:
	bra	adrLp00CFDA	;60006EA8

adrW_006134:
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
	dc.b	'MISSES'	;4D4953534553
	dc.b	$FF	;FF
OutcomeMsgs_1:
	dc.b	'SHOOTS'	;53484F4F5453
	dc.b	$FF	;FF
OutcomeMsgs_2:
	dc.b	'CHANTS'	;4348414E5453
	dc.b	$FF	;FF
OutcomeMsgs_3:
	dc.b	'CASTS SPELL'	;4341535453205350454C4C
	dc.b	$FF	;FF
OutcomeMsgs_4:
	dc.b	'DEFENDS'	;444546454E4453
	dc.b	$FF	;FF
OutcomeMsgs_5:
	dc.b	'HITS FOR '	;4849545320464F5220
NumHitsMsg:
	dc.b	'000'	;303030
	dc.b	$FF	;FF

adrCd006178:
	move.w	d0,d1	;3200
	moveq	#$00,d0	;7000
	move.w	d1,d0	;3001
	divu	#$0064,d0	;80FC0064
	move.w	d0,d3	;3600
	beq.s	adrCd006190	;670A
	add.b	#$30,d0	;06000030
	move.b	d0,$00(a6,d2.w)	;1D802000
	addq.w	#$01,d2	;5242
adrCd006190:
	swap	d0	;4840
	bsr	adrCd00CEC4	;61006D30
	move.b	d1,d0	;1001
	ror.w	#$08,d1	;E059
	tst.w	d3	;4A43
	bne.s	adrCd0061A4	;6606
	cmpi.b	#$30,d1	;0C010030
	beq.s	adrCd0061AA	;6706
adrCd0061A4:
	move.b	d1,$00(a6,d2.w)	;1D812000
	addq.w	#$01,d2	;5242
adrCd0061AA:
	move.b	d0,$00(a6,d2.w)	;1D802000
	move.b	#$FF,$01(a6,d2.w)	;1DBC00FF2001
	rts	;4E75

adrCd0061B6:
	movem.l	d1/d3/a5,-(sp)	;48E75004
	lea	Player1_Data.l,a5	;4BF90000EE7C
	bsr.s	adrCd0061D0	;610E
	lea	Player2_Data.l,a5	;4BF90000EEDE
	bsr.s	adrCd0061D0	;6106
	movem.l	(sp)+,d1/d3/a5	;4CDF200A
	rts	;4E75

adrCd0061D0:
	cmp.b	$0035(a5),d1	;B22D0035
	beq	adrCd00332A	;6700D154
	rts	;4E75

adrCd0061DA:
	moveq	#$02,d0	;7002
	bsr	PlaySound	;610026E0
	bsr.s	adrCd0061B6	;61D4
	bsr	adrCd00641C	;61000238
	clr.w	$0000(a6)	;426E0000
	clr.w	adrW_00230A.w	;4278230A	;Short Absolute converted to symbol!
	bsr	RandomGen_100	;6100F3C8
	add.w	$0002(a6),d0	;D06E0002
	move.w	d0,d2	;3400
	bsr	RandomGen_100	;6100F3BE
	add.w	$0004(a6),d0	;D06E0004
	sub.w	d0,d2	;9440
	bmi.s	adrCd006210	;6B0C
	move.w	d2,d0	;3002
	moveq	#$40,d2	;7440
	sub.w	d0,d2	;9440
	bpl.s	adrCd00621C	;6A10
	moveq	#$01,d2	;7401
	bra.s	adrCd00621C	;600C

adrCd006210:
	neg.w	d2	;4442
	move.w	d2,d0	;3002
	moveq	#$40,d2	;7440
	cmp.w	d2,d0	;B042
	bpl	adrCd006288	;6A00006E
adrCd00621C:
	move.w	$0006(a6),d1	;322E0006
	bsr	RandomGen	;6100F39A
	addq.w	#$01,d0	;5240
	add.b	$0008(a6),d0	;D02E0008
	add.b	$000A(a6),d0	;D02E000A
	moveq	#$00,d1	;7200
	move.b	$0009(a6),d1	;122E0009
	sub.w	#$0014,d1	;04410014
	bcs.s	adrCd00623E	;6504
	lsr.w	#$03,d1	;E649
	add.w	d1,d0	;D041
adrCd00623E:
	tst.w	adrW_00628A.l	;4A790000628A
	bne.s	adrCd00624C	;6606
	move.w	d0,d1	;3200
	add.w	d0,d0	;D040
	add.w	d1,d0	;D041
adrCd00624C:
	moveq	#$00,d4	;7800
	move.b	$000D(a6),d4	;182E000D
	lsr.b	#$01,d4	;E20C
	bcc.s	adrCd006264	;640E
	move.w	d2,d1	;3202
	and.w	#$000F,d1	;0241000F
	beq.s	adrCd006262	;6704
	subq.w	#$08,d1	;5141
	bcs.s	adrCd006264	;6502
adrCd006262:
	addq.w	#$01,d4	;5244
adrCd006264:
	sub.w	d4,d0	;9044
	bcs.s	adrCd006288	;6520
	beq.s	adrCd006288	;671E
	move.w	d0,d1	;3200
	cmpi.w	#$0028,d2	;0C420028
	bcc.s	adrCd006284	;6412
	add.w	d1,d0	;D041
	cmpi.w	#$0019,d2	;0C420019
	bcc.s	adrCd006284	;640A
	add.w	d1,d0	;D041
	cmpi.w	#$000A,d2	;0C42000A
	bcc.s	adrCd006284	;6402
	add.w	d1,d0	;D041
adrCd006284:
	move.w	d0,$0000(a6)	;3D400000
adrCd006288:
	rts	;4E75

adrW_00628A:
	dc.w	$0000	;0000

adrCd00628C:
	moveq	#$00,d4	;7800
	moveq	#$00,d5	;7A00
	moveq	#$00,d6	;7C00
	moveq	#$00,d7	;7E00
	cmpi.w	#$0010,d0	;0C400010
	bcs.s	adrCd0062C6	;652C
	sub.w	#$0010,d0	;04400010
	asl.w	#$04,d0	;E940
	lea	UnpackedMonsters.l,a4	;49F900016B7E
	add.w	d0,a4	;D8C0
	moveq	#$1E,d1	;721E
	moveq	#$14,d2	;7414
	move.b	$0006(a4),d0	;102C0006
	and.w	#$007F,d0	;0240007F
	move.w	d0,d3	;3600
	add.w	d3,d3	;D643
	add.w	d3,d1	;D243
	add.w	d3,d1	;D243
	add.w	d3,d2	;D443
	add.w	d0,d3	;D640
	lsr.w	#$01,d3	;E24B
	moveq	#$08,d4	;7808
	rts	;4E75

adrCd0062C6:
	move.w	d0,d1	;3200
	bsr	adrCd006660	;61000396
	subq.b	#$03,$0007(a4)	;572C0007
	bcc.s	adrCd0062D6	;6404
	clr.b	$0007(a4)	;422C0007
adrCd0062D6:
	move.w	d1,d0	;3001
	bsr.s	adrCd00631E	;6144
	bsr	adrCd006382	;610000A6
	bsr	adrCd000924	;6100A644
	tst.w	adrW_00628A.w	;4A78628A	;Short Absolute converted to symbol!
	bne.s	adrCd0062EA	;6602
	move.b	(a4),d0	;1014
adrCd0062EA:
	moveq	#$00,d1	;7200
	move.b	$0011(a4),d1	;122C0011
	move.w	d1,d2	;3401
	and.w	#$0007,d2	;02420007
	subq.b	#$02,d2	;5502
	bne.s	adrCd006312	;6618
	lsr.b	#$03,d1	;E609
	move.w	d1,d2	;3401
	lsr.w	#$02,d2	;E44A
	addq.w	#$01,d2	;5242
	add.w	d2,d0	;D042
	move.w	d1,d2	;3401
	add.b	$0001(a4),d1	;D22C0001
	addq.b	#$08,d1	;5001
	add.b	$0002(a4),d2	;D42C0002
	rts	;4E75

adrCd006312:
	move.b	$0001(a4),d1	;122C0001
	addq.b	#$08,d1	;5001
	move.b	$0002(a4),d2	;142C0002
	rts	;4E75

adrCd00631E:
	lea	PocketContents.l,a1	;43F90000ED2A
	asl.w	#$04,d0	;E940
	add.w	d0,a1	;D2C0
	move.b	$0011(a4),d3	;162C0011
	move.w	d3,d2	;3403
	lsr.b	#$03,d2	;E60A
	and.w	#$0007,d3	;02430007
	beq.s	adrCd006338	;6702
	moveq	#$00,d2	;7400
adrCd006338:
	move.b	$000B(a4),d3	;162C000B
	cmp.b	d3,d2	;B403
	bcs.s	adrCd006342	;6502
	move.b	d2,d3	;1602
adrCd006342:
	move.b	$0002(a1),d2	;14290002
	beq.s	adrCd006356	;670E
	sub.b	#$1B,d2	;0402001B
	add.b	d2,d2	;D402
	addq.b	#$03,d2	;5602
	cmp.b	d2,d3	;B602
	bcc.s	adrCd006356	;6402
	move.b	d2,d3	;1602
adrCd006356:
	move.b	$0012(a4),d2	;142C0012
	beq.s	adrCd006362	;6706
	sub.b	#$2B,d2	;0402002B
	add.b	d2,d3	;D602
adrCd006362:
	moveq	#$00,d2	;7400
	move.b	$0003(a1),d2	;14290003
	sub.b	#$24,d2	;04020024
	bcs.s	adrCd006378	;650A
	cmpi.w	#$0007,d2	;0C420007
	bcc.s	adrCd006378	;6404
	add.b	Monster_Grades?_5FD6(pc,d2.w),d3	;D63B2004
adrCd006378:
	rts	;4E75

Monster_Grades?_5FD6:
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$04	;04
	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$05	;05
	dc.b	$07	;07
	dc.b	$00	;00

adrCd006382:
	moveq	#$00,d0			;7000
	move.b	(a1),d0			;1011
	sub.b	#$30,d0			;04000030
	bcs.s	adrCd006392		;6506
	cmpi.b	#$10,d0			;0C000010
	bcs.s	adrCd0063A2		;6510
adrCd006392:
	move.b	$0001(a1),d0		;10290001
	sub.b	#$30,d0			;04000030
	bcs.s	adrCd0063DA		;653E
	cmpi.b	#$10,d0			;0C000010
	bcc.s	adrCd0063DA		;6438
adrCd0063A2:
	lea	adrEA0063DC.l,a0	;41F9000063DC
	asl.w	#$02,d0			;E540
	add.w	d0,a0			;D0C0
	move.b	(a0)+,d4		;1818
	move.b	(a0)+,d5		;1A18
	move.b	(a0)+,d6		;1C18
	move.b	(a0)+,d7		;1E18
	tst.w	adrW_00628A.w		;4A78628A	;Short Absolute converted to symbol!
	bne.s	adrCd0063C6		;660C
	cmpi.b	#$08,d0			;0C000008
	bcs.s	adrCd0063C6		;6506
	move.w	#$FFFF,adrW_00628A.w	;31FCFFFF628A	;Short Absolute converted to symbol!
adrCd0063C6:
	cmpi.b	#$1C,d0	;0C00001C
	bne.s	adrCd0063DA	;660E
	cmp.b	#$2B,$0012(a4)	;0C2C002B0012
	beq.s	adrCd0063DA	;6706
	moveq	#$05,d6	;7C05
	moveq	#$05,d7	;7E05
	moveq	#$00,d5	;7A00
adrCd0063DA:
	rts	;4E75

adrEA0063DC:
	dc.w	$0400	;0400
	dc.w	$0000	;0000
	dc.w	$0603	;0603
	dc.w	$0A00	;0A00
	dc.w	$0600	;0600
	dc.w	$0A1E	;0A1E
	dc.w	$0800	;0800
	dc.w	$0505	;0505
	dc.w	$0802	;0802
	dc.w	$0A05	;0A05
	dc.w	$0A06	;0A06
	dc.w	$0F1E	;0F1E
	dc.w	$0A08	;0A08
	dc.w	$190A	;190A
	dc.w	$1019	;1019
	dc.w	$3C32	;3C32
	dc.w	$0A00	;0A00
	dc.w	$0000	;0000
	dc.w	$0A02	;0A02
	dc.w	$0500	;0500
	dc.w	$0C04	;0C04
	dc.w	$0000	;0000
	dc.w	$0C06	;0C06
	dc.w	$0A05	;0A05
	dc.w	$0C08	;0C08
	dc.w	$0F00	;0F00
	dc.w	$0600	;0600
	dc.w	$0028	;0028
	dc.w	$0802	;0802
	dc.w	$141E	;141E
	dc.w	$0C02	;0C02
	dc.w	$1928	;1928

adrCd00641C:
	lea	adrEA016B6C.l,a6	;4DF900016B6C
	move.w	d1,-(sp)	;3F01
	move.w	d3,d0	;3003
	bsr	adrCd00645A	;61000032
	move.w	(sp)+,d0	;301F
	bsr	adrCd00628C	;6100FE5E
	move.b	d7,$000C(a6)	;1D47000C
	move.b	d3,$000D(a6)	;1D43000D
	lsr.w	#$03,d2	;E64A
	add.w	d2,d0	;D042
	move.w	d0,d1	;3200
	asl.w	#$02,d0	;E540
	add.w	d1,d0	;D041
	move.b	$000C(a6),d1	;122E000C
	add.w	d1,d0	;D041
	tst.w	adrW_006458.l	;4A7900006458
	beq.s	adrCd006452	;6702
	add.w	d0,d0	;D040
adrCd006452:
	move.w	d0,$0004(a6)	;3D400004
	rts	;4E75

adrW_006458:
	dc.w	$0000	;0000

adrCd00645A:
	bsr	adrCd00628C	;6100FE30
	move.b	d6,$000B(a6)	;1D46000B
	move.b	d5,$000A(a6)	;1D45000A
	move.b	d4,$0006(a6)	;1D440006
	clr.b	$0007(a6)	;422E0007
	move.b	d0,$0008(a6)	;1D400008
	move.b	d1,$0009(a6)	;1D410009
	add.w	d0,d0	;D040
	sub.w	#$0010,d1	;04410010
	bcc.s	adrCd006480	;6402
	moveq	#$00,d1	;7200
adrCd006480:
	lsr.w	#$04,d1	;E849
	add.w	d1,d0	;D041
	sub.w	#$0014,d2	;04420014
	bcc.s	adrCd00648C	;6402
	moveq	#$00,d2	;7400
adrCd00648C:
	lsr.w	#$04,d2	;E84A
	add.w	d2,d0	;D042
	move.w	d0,d1	;3200
	asl.w	#$02,d0	;E540
	add.w	d1,d0	;D041
	move.b	$000B(a6),d1	;122E000B
	add.w	d1,d0	;D041
	tst.w	adrW_00628A.w	;4A78628A	;Short Absolute converted to symbol!
	bne.s	adrCd0064A4	;6602
	add.w	d0,d0	;D040
adrCd0064A4:
	move.w	d0,$0002(a6)	;3D400002
	rts	;4E75

Click_MultiFunctionButton:
	bsr	adrCd00665C	;610001B0
	tst.b	$0011(a4)	;4A2C0011
	beq.s	adrCd0064C2	;670E
	clr.b	$0011(a4)	;422C0011
	move.w	$0006(a5),d7	;3E2D0006
	bsr	adrCd00CCD8	;6100681A
	bra.s	adrCd0064CC	;600A

adrCd0064C2:
	tst.b	$0013(a4)	;4A2C0013
	bmi.s	adrJA0064D0	;6B08
	bsr	adrCd004E8E	;6100E9C4
adrCd0064CC:
	bra	adrCd0081CE	;60001D00

adrJA0064D0:
	moveq	#$02,d3	;7602
	move.w	$0020(a5),d2	;342D0020
	add.w	d2,d2	;D442
	addq.w	#$01,d2	;5242
	bsr	adrCd008498	;61001FBC
	move.b	$01(a6,d0.w),d1	;12360001
	and.w	#$0007,d1	;02410007
	cmpi.b	#$02,d1	;0C010002
	bne.s	adrCd0064F2	;6606
	btst	d2,$00(a6,d0.w)	;05360000
	bne.s	adrCd006552	;6660
adrCd0064F2:
	bsr	adrCd008482	;61001F8E
	cmp.w	adrW_00EE72.l,d7	;BE790000EE72
	bcc.s	adrCd006550	;6452
	swap	d7	;4847
	cmp.w	adrW_00EE70.l,d7	;BE790000EE70
	bcc.s	adrCd006550	;6448
	eor.w	#$0004,d2	;0A420004
	move.b	$01(a6,d0.w),d1	;12360001
	and.w	#$0007,d1	;02410007
	cmpi.b	#$02,d1	;0C010002
	beq.s	adrCd00654A	;6730
	cmpi.b	#$05,d1	;0C010005
	bne.s	adrCd006550	;6630
	tst.b	$01(a6,d0.w)	;4A360001
	bmi.s	adrCd006550	;6B2A
	btst	#$03,$00(a6,d0.w)	;083600030000
	bne.s	adrCd006594	;6666
	moveq	#$01,d2	;7401
	move.b	$00(a6,d0.w),d3	;16360000
	lsr.b	#$04,d3	;E80B
	beq.s	adrCd00657C	;6744
	add.w	#$004F,d3	;0643004F
	cmp.w	$002E(a5),d3	;B66D002E
	bne.s	adrCd006594	;6652
	and.b	#$0F,$00(a6,d0.w)	;0236000F0000
	bra.s	adrCd006552	;6008

adrCd00654A:
	btst	d2,$00(a6,d0.w)	;05360000
	bne.s	adrCd006552	;6602
adrCd006550:
	rts	;4E75

adrCd006552:
	cmp.w	$002E(a5),d3	;B66D002E
	bne.s	adrCd00657C	;6624
	subq.w	#$01,$002C(a5)	;536D002C
	bne.s	adrCd006562	;6604
	clr.w	$002E(a5)	;426D002E
adrCd006562:
	bchg	#$04,$01(a6,d0.w)	;087600040001
	cmp.w	#$0003,$0014(a5)	;0C6D00030014
	bne.s	adrCd00657C	;660C
	movem.l	d0/d2/a6,-(sp)	;48E7A002
	bsr	adrCd006C42	;610006CC
	movem.l	(sp)+,d0/d2/a6	;4CDF4005
adrCd00657C:
	subq.w	#$01,d2	;5342
	btst	#$04,$01(a6,d0.w)	;083600040001
	bne.s	adrCd006594	;660E
	bchg	d2,$00(a6,d0.w)	;05760000
	moveq	#$01,d0	;7001
	bsr	PlaySound	;61002330
	bra	adrCd00CF96	;60006A04

adrCd006594:
	lea	DoorLockedMsg.l,a6	;4DF90000659E
	bra	WriteTimedText	;60006AEC

DoorLockedMsg:
	dc.b	'THE DOOR IS LOCKED'	;54484520444F4F52204953204C4F434B4544
	dc.b	$FF	;FF
	dc.b	$00	;00

Click_PartyMember:
	lsr.w	#$02,d0	;E448
	subq.w	#$06,d0	;5D40
	tst.w	$0016(a5)	;4A6D0016
	bpl.s	adrCd0065CC	;6A10
	tst.b	$26(a5,d0.w)	;4A350026
	bpl.s	adrCd0065C4	;6A02
	rts	;4E75

adrCd0065C4:
	move.w	d0,$0016(a5)	;3B400016
	bra	adrCd008396	;60001DCC

adrCd0065CC:
	cmp.w	$0016(a5),d0	;B06D0016
	beq.s	adrCd0065E8	;6716
	move.b	$26(a5,d0.w),d1	;12350026
	move.w	$0016(a5),d2	;342D0016
	move.b	$26(a5,d2.w),$26(a5,d0.w)	;1BB520260026
	move.b	d1,$26(a5,d2.w)	;1B812026
	moveq	#-$01,d0	;70FF
	bra.s	adrCd0065C4	;60DC

adrCd0065E8:
	move.b	$26(a5,d0.w),d0	;10350026
	bmi.s	adrCd006608	;6B1A
	move.w	$0006(a5),d2	;342D0006
	move.w	d0,$0006(a5)	;3B400006
	bsr	adrCd004078	;6100DA80
	move.b	d2,$18(a5,d1.w)	;1B821018
	move.b	d0,$0018(a5)	;1B400018
	bset	#$04,$0018(a5)	;08ED00040018
adrCd006608:
	move.w	#$FFFF,$0016(a5)	;3B7CFFFF0016
	bsr	adrCd008278	;61001C68
	bra	adrCd007B50	;6000153C

Click_ShowStats:
	move.w	#$0001,$0014(a5)	;3B7C00010014
	moveq	#$38,d5	;7A38
	bsr	adrCd00CB2A	;6100650A
	lea	adrEA00E9E8.l,a6	;4DF90000E9E8
	bsr	Print_fflim_text	;61006A9C
	asl.w	#$05,d7	;EB47
	lea	CharacterStats.l,a6	;4DF90000EB2A
	moveq	#$00,d0	;7000
	move.b	$10(a6,d7.w),d0	;10367010
	beq.s	adrCd00666E	;6732
	move.w	#$00C7,d1	;323C00C7
	moveq	#$30,d2	;7430
	move.l	#$002F00F9,d4	;283C002F00F9
	bsr	adrCd008144	;61001AFA
	move.l	#$0004004A,d5	;2A3C0004004A	;Long Addr replaced with Symbol
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$09,d3	;7609
	bra	BW_draw_bar	;6000740E

adrCd00665C:
	move.w	$0006(a5),d0	;302D0006
adrCd006660:
	and.w	#$000F,d0	;0240000F
	asl.w	#$05,d0	;EB40
	lea	CharacterStats.l,a4	;49F90000EB2A
	add.w	d0,a4	;D8C0
adrCd00666E:
	rts	;4E75

adrCd006670:
	clr.w	$002A(a5)	;426D002A
	move.b	$0013(a4),d0	;102C0013
	bmi.s	adrCd006682	;6B08
	lsr.b	#$03,d0	;E608
	add.b	d0,d0	;D000
	move.b	d0,$002B(a5)	;1B40002B
adrCd006682:
	rts	;4E75

adrJA006684:
	bsr	adrCd008258	;61001BD2
	bsr	adrCd00C7C8	;6100613E
	bsr.s	adrCd006670	;61E2
	bsr	adrCd00C85E	;610061CE
	move.w	#$0002,$0014(a5)	;3B7C00020014
adrCd006698:
	bsr	adrCd00C812	;61006178
	sub.w	#$02DC,a0	;90FC02DC
	move.b	$0013(a4),d0	;102C0013
	bpl.s	adrCd0066BE	;6A18
	bsr.s	adrCd0066B8	;6110
	moveq	#$68,d7	;7E68
adrCd0066AA:
	move.w	d7,d0	;3007
	bsr	adrCd00CAEA	;6100643C
	addq.w	#$01,d7	;5247
	cmpi.w	#$006C,d7	;0C47006C
	bcs.s	adrCd0066AA	;65F2
adrCd0066B8:
	moveq	#$4F,d0	;704F
	bra	adrCd00CAEA	;6000642E

adrCd0066BE:
	bsr	adrCd006900	;61000240
	add.w	#$0064,d0	;06400064
	bsr	adrCd00CAEA	;61006422
	moveq	#$03,d7	;7E03
adrLp0066CC:
	move.w	#$003B,d0	;303C003B
	bsr	adrCd00CAEA	;61006418
	dbra	d7,adrLp0066CC	;51CFFFF6
	move.b	$0013(a4),d0	;102C0013
	bsr	adrCd006900	;61000222
	add.w	#$0064,d0	;06400064
	bsr	adrCd00CAEA	;61006404
	moveq	#$00,d0	;7000
	move.b	$0013(a4),d0	;102C0013
	bsr	adrCd00C2D4	;61005BE4
	bsr	adrCd00CFBC	;610068C8
adrCd0066F6:
	or.b	#$04,$0054(a5)	;002D00040054
	bsr	adrCd00688C	;6100018E
	lea	adrEA00EA36.l,a6	;4DF90000EA36
	bsr	adrCd00CEC4	;610067BC
	move.w	d1,$0010(a6)	;3D410010
	bsr	Print_fflim_text	;610069B6
adrCd006712:
	lea	adrEA00EA4C.l,a6	;4DF90000EA4C
	bsr	LowerText	;6100689E
	clr.b	$0057(a5)	;422D0057
adrCd006720:
	tst.b	$0057(a5)	;4A2D0057
	bmi.s	adrCd00675E	;6B38
	or.b	#$10,$0054(a5)	;002D00100054
	bsr	adrCd006778	;6100004A
	neg.b	d7	;4407
	bpl.s	adrCd006736	;6A02
	moveq	#$00,d7	;7E00
adrCd006736:
	cmpi.b	#$13,d7	;0C070013
	bcc.s	adrCd00675E	;6422
	move.b	adrB_006760(pc,d7.w),d0	;103B7022
	moveq	#$64,d1	;7264
	moveq	#$34,d2	;7434
	move.l	#$0004005A,d5	;2A3C0004005A	;Long Addr replaced with Symbol
	add.w	$0008(a5),d5	;DA6D0008
	move.l	#$0033009F,d4	;283C0033009F
	bsr	adrCd008144	;610019EE
	moveq	#$0C,d3	;760C
	bra	BW_draw_bar	;6000730C

adrCd00675E:
	rts	;4E75

adrB_006760:
	dc.b	$64	;64
	dc.b	$64	;64
	dc.b	$64	;64
	dc.b	$64	;64
	dc.b	$63	;63
	dc.b	$62	;62
	dc.b	$5F	;5F
	dc.b	$5A	;5A
	dc.b	$54	;54
	dc.b	$4A	;4A
	dc.b	$3E	;3E
	dc.b	$32	;32
	dc.b	$25	;25
	dc.b	$1A	;1A
	dc.b	$10	;10
	dc.b	$09	;09
	dc.b	$05	;05
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$00	;00

	bsr	adrCd006660	;6100FEEA
adrCd006778:
	move.b	$0013(a4),d0	;102C0013
	bsr	adrCd006900	;61000182
	move.w	d0,-(sp)	;3F00
	move.l	a4,d0	;200C
	sub.l	#CharacterStats,d0	;04800000EB2A
	lea	PocketContents.l,a0	;41F90000ED2A
	lsr.w	#$01,d0	;E248
	add.w	d0,a0	;D0C0
	lsr.w	#$04,d0	;E848
	move.w	d0,d1	;3200
	bsr	adrCd006900	;61000166
	moveq	#$00,d7	;7E00
	cmp.w	(sp),d0	;B057
	bne.s	adrCd0067AC	;660A
	move.w	d1,d2	;3401
	and.w	#$0003,d2	;02420003
	move.b	adrB_0067E6(pc,d2.w),d7	;1E3B203C
adrCd0067AC:
	move.l	#adrL_007E22,a1	;227C00007E22
	add.l	a4,a1	;D3CC
	moveq	#$00,d6	;7C00
	move.b	$0013(a4),d6	;1C2C0013
	move.b	$00(a1,d6.w),d0	;10316000
	moveq	#$05,d2	;7405
	moveq	#$00,d3	;7600
	tst.w	d7	;4A47
	bne.s	adrCd0067D8	;6612
	move.w	(sp),d4	;3817
	add.w	#$0057,d4	;06440057
	cmp.b	(a0),d4	;B810
	beq.s	adrCd0067D6	;6706
	cmp.b	$0001(a0),d4	;B8280001
	bne.s	adrCd0067E0	;660A
adrCd0067D6:
	addq.b	#$03,d7	;5607
adrCd0067D8:
	cmp.w	d2,d0	;B042
	bcs.s	adrCd0067EA	;650E
	addq.w	#$05,d7	;5A47
	sub.w	d2,d0	;9042
adrCd0067E0:
	add.w	d2,d2	;D442
	addq.w	#$01,d3	;5243
	bra.s	adrCd0067D8	;60F2

adrB_0067E6:
	dc.b	$03	;03
	dc.b	$05	;05
	dc.b	$04	;04
	dc.b	$04	;04

adrCd0067EA:
	lsr.w	d3,d0	;E668
	add.w	d0,d7	;DE40
	move.w	d1,d4	;3801
	bsr	adrCd00093E	;6100A14C
	add.b	d0,d7	;DE00
	add.b	d0,d7	;DE00
	add.b	$0014(a4),d7	;DE2C0014
	move.w	d4,d0	;3004
	move.w	d6,d4	;3806
	bsr	adrCd006900	;610000FE
	move.w	d4,d6	;3C04
	cmp.w	(sp)+,d0	;B05F
	bne.s	adrCd00681A	;6610
	add.w	#$0057,d0	;06400057
	moveq	#$01,d1	;7201
	cmp.b	(a0),d0	;B010
	beq.s	adrCd00681C	;6708
	cmp.b	$0001(a0),d0	;B0280001
	beq.s	adrCd00681C	;6702
adrCd00681A:
	moveq	#$00,d1	;7200
adrCd00681C:
	move.b	$0015(a4),d0	;102C0015
	lsr.b	d1,d0	;E228
	sub.b	d0,d7	;9E00
	moveq	#$05,d0	;7005
	cmp.b	#$3F,(a0)	;0C10003F
	beq.s	adrCd006836	;670A
	cmp.b	#$3F,$0001(a0)	;0C28003F0001
	beq.s	adrCd006836	;6702
	moveq	#$00,d0	;7000
adrCd006836:
	add.b	d0,d7	;DE00
	sub.b	SpellsDifficultyTable(pc,d6.w),d7	;9E3B6004
	rts	;4E75

SpellsDifficultyTable:
	dc.b	$0E	;0E
	dc.b	$0F	;0F
	dc.b	$0E	;0E
	dc.b	$0E	;0E
	dc.b	$0D	;0D
	dc.b	$0E	;0E
	dc.b	$0E	;0E
	dc.b	$0F	;0F
	dc.b	$0E	;0E
	dc.b	$0F	;0F
	dc.b	$0E	;0E
	dc.b	$12	;12
	dc.b	$0F	;0F
	dc.b	$0F	;0F
	dc.b	$11	;11
	dc.b	$10	;10
	dc.b	$0F	;0F
	dc.b	$10	;10
	dc.b	$24	;24
	dc.b	$10	;10
	dc.b	$11	;11
	dc.b	$13	;13
	dc.b	$0E	;0E
	dc.b	$12	;12
	dc.b	$18	;18
	dc.b	$10	;10
	dc.b	$16	;16
	dc.b	$10	;10
	dc.b	$11	;11
	dc.b	$13	;13
	dc.b	$12	;12
	dc.b	$10	;10
SpellsCostTable:
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$01	;01
	dc.b	$03	;03
	dc.b	$02	;02
	dc.b	$05	;05
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$04	;04
	dc.b	$05	;05
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$07	;07
	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$04	;04
	dc.b	$02	;02
	dc.b	$05	;05
	dc.b	$08	;08
	dc.b	$03	;03
	dc.b	$07	;07
	dc.b	$04	;04
	dc.b	$05	;05
	dc.b	$06	;06
	dc.b	$06	;06
	dc.b	$04	;04
adrB_00687E:
	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$06	;06
	dc.b	$0A	;0A
	dc.b	$0F	;0F
	dc.b	$15	;15
	dc.b	$1C	;1C
	dc.b	$24	;24
	dc.b	$2D	;2D
	dc.b	$37	;37
	dc.b	$42	;42
	dc.b	$4E	;4E
	dc.b	$5B	;5B
	dc.b	$69	;69

adrCd00688C:
	move.l	a4,d0	;200C
	sub.l	#CharacterStats,d0	;04800000EB2A
	lsr.w	#$01,d0	;E248
	lea	PocketContents.l,a0	;41F90000ED2A
	add.w	d0,a0	;D0C0
	moveq	#$00,d0	;7000
	move.b	$0013(a4),d0	;102C0013
	bsr.s	adrCd006900	;615A
	add.w	#$0069,d0	;06400069
	cmp.b	(a0),d0	;B010
	beq.s	adrCd0068B4	;6706
	cmp.b	$0001(a0),d0	;B0280001
	bne.s	adrCd0068D0	;661C
adrCd0068B4:
	sub.w	#$0069,d0	;04400069
	lea	RingUses.l,a0	;41F90000EE32
	tst.b	$00(a0,d0.w)	;4A300000
	bmi.s	adrCd0068D0	;6B0C
	moveq	#$00,d0	;7000
	move.b	d0,$0014(a4)	;19400014
	rts	;4E75

adrCd0068CC:
	subq.b	#$01,$0014(a4)	;532C0014
adrCd0068D0:
	move.b	$0014(a4),d1	;122C0014
	ext.w	d1	;4881
	bmi.s	adrCd0068DC	;6B04
	move.b	adrB_00687E(pc,d1.w),d1	;123B10A4
adrCd0068DC:
	moveq	#$00,d0	;7000
	move.b	$0013(a4),d0	;102C0013
	lea	SpellsCostTable.w,a0	;41F8685E	;Short Absolute converted to symbol!
	move.b	$00(a0,d0.w),d0	;10300000
	addq.w	#$01,d0	;5240
	add.w	d0,d0	;D040
	add.w	d1,d0	;D041
	bne.s	adrCd0068F8	;6606
	addq.b	#$01,$0014(a4)	;522C0014
	moveq	#$01,d0	;7001
adrCd0068F8:
	cmpi.w	#$0064,d0	;0C400064
	bcc.s	adrCd0068CC	;64CE
	rts	;4E75

adrCd006900:
	move.w	d0,d6	;3C00
	cmpi.b	#$10,d0	;0C000010
	bcs.s	adrCd00690A	;6502
	not.w	d0	;4640
adrCd00690A:
	lsr.w	#$02,d0	;E448
	add.w	d6,d0	;D046
	and.w	#$0003,d0	;02400003
adrCd006912:
	rts	;4E75

Click_Item_17_to_1A_Potions:
	move.w	$002E(a5),d0	;302D002E
	beq.s	adrCd006912	;67F8
	cmpi.w	#$001B,d0	;0C40001B
	bcc.s	adrCd006912	;64F2
	cmpi.w	#$0017,d0	;0C400017
	bcs.s	adrCd00699A	;6574
	sub.w	#$0017,d0	;04400017
	move.w	d0,d1	;3200
	clr.l	$002C(a5)	;42AD002C
	move.b	$000F(a5),d0	;102D000F
	move.b	$18(a5,d0.w),d0	;10350018
	bsr	adrCd006660	;6100FD26
	lea	Potion_1_SerpentSlime.l,a0	;41F90000695A
	add.w	d1,d1	;D241
	add.w	Potion_LookupTable(pc,d1.w),a0	;D0FB100C
	jsr	(a0)	;4E90
	bsr	adrCd007FF8	;610016AC
	bra	adrCd006C34	;600002E4

Potion_LookupTable:
	dc.w	Potion_1_SerpentSlime-Potion_1_SerpentSlime	;0000
	dc.w	Potion_2_BrimstoneBroth-Potion_1_SerpentSlime	;001C
	dc.w	Potion_3_DragonAle-Potion_1_SerpentSlime	;0008
	dc.w	Potion_4_MoonElixir-Potion_1_SerpentSlime	;0010

Potion_1_SerpentSlime:
	move.b	$0006(a4),$0005(a4)	;196C00060005
	rts	;4E75

Potion_3_DragonAle:
	move.b	$0008(a4),$0007(a4)	;196C00080007
	rts	;4E75

Potion_4_MoonElixir:
	move.b	$000A(a4),$0009(a4)	;196C000A0009
	clr.b	$0015(a4)	;422C0015
	rts	;4E75

Potion_2_BrimstoneBroth:
	clr.b	$0015(a4)	;422C0015
	moveq	#$05,d4	;7805
	bsr.s	adrCd006984	;6106
	moveq	#$07,d4	;7807
	bsr.s	adrCd006984	;6102
	moveq	#$09,d4	;7809
adrCd006984:
	move.b	$01(a4,d4.w),d0	;10344001
	sub.b	$00(a4,d4.w),d0	;90344000
	addq.b	#$01,d0	;5200
	lsr.b	#$01,d0	;E208
	add.b	$00(a4,d4.w),d0	;D0344000
	move.b	d0,$00(a4,d4.w)	;19804000
	rts	;4E75

adrCd00699A:
	cmpi.w	#$0005,d0	;0C400005
	bcs	adrCd006A16	;65000076
	cmpi.w	#$0014,d0	;0C400014
	bcs.s	adrCd0069BA	;6512
	moveq	#$00,d1	;7200
	sub.w	#$0014,d0	;04400014
adrLp0069AE:
	add.w	#$0042,d1	;06410042
	dbra	d0,adrLp0069AE	;51C8FFFA
	moveq	#$00,d0	;7000
	bra.s	adrCd0069D4	;601A

adrCd0069BA:
	moveq	#$14,d1	;7214
	cmpi.w	#$000E,d0	;0C40000E
	bcc.s	adrCd0069C4	;6402
	moveq	#$20,d1	;7220
adrCd0069C4:
	move.w	d0,d2	;3400
	subq.w	#$05,d0	;5B40
	beq.s	adrCd0069D4	;670A
adrCd0069CA:
	subq.w	#$03,d0	;5740
	beq.s	adrCd0069D4	;6706
	bcc.s	adrCd0069CA	;64FA
	move.w	d2,d0	;3002
	subq.w	#$01,d0	;5340
adrCd0069D4:
	move.w	d0,$002E(a5)	;3B40002E
	move.b	$000F(a5),d0	;102D000F
	move.b	$18(a5,d0.w),d0	;10350018
	bsr	adrCd006660	;6100FC7E
	add.b	$0010(a4),d1	;D22C0010
	bcs.s	adrCd0069F0	;6506
	cmpi.w	#$00C8,d1	;0C4100C8
	bcs.s	adrCd0069F4	;6504
adrCd0069F0:
	move.b	#$C7,d1	;123C00C7
adrCd0069F4:
	move.b	d1,$0010(a4)	;19410010
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$0B64,a0	;D0FC0B64
	add.w	$000A(a5),a0	;D0ED000A
	move.w	$002E(a5),d0	;302D002E
	bsr	ObjectGraphic	;6100605A
	bsr	adrCd006D1E	;6100030E
	bra	adrCd006C9C	;60000288

adrCd006A16:
	moveq	#$00,d7	;7E00
	move.b	$000F(a5),d7	;1E2D000F
	move.b	$18(a5,d7.w),d7	;1E357018
	asl.b	#$04,d7	;E907
	lea	PocketContents.l,a6	;4DF90000ED2A
	add.w	d7,a6	;DCC7
	subq.b	#$01,$0B(a6,d0.w)	;5336000B
	bcc.s	adrCd006A36	;6406
adrCd006A30:
	addq.b	#$01,$0B(a6,d0.w)	;5236000B
	rts	;4E75

adrCd006A36:
	cmp.w	#$0063,$002C(a5)	;0C6D0063002C
	bcc.s	adrCd006A30	;64F2
	addq.w	#$01,$002C(a5)	;526D002C
	bra	adrJA006C0A	;600001C6

adrJA006A46:
	moveq	#$00,d7	;7E00
	move.b	$000E(a5),d7	;1E2D000E
	moveq	#$00,d0	;7000
	move.b	$18(a5,d7.w),d0	;10357018
	move.w	d0,d2	;3400
	and.w	#$000F,d2	;0242000F
	asl.b	#$04,d0	;E900
	lea	PocketContents.l,a6	;4DF90000ED2A
	add.w	d0,a6	;DCC0
	lea	CharacterStats.l,a4	;49F90000EB2A
	add.w	d0,d0	;D040
	add.w	d0,a4	;D8C0
	moveq	#$00,d0	;7000
	move.b	$000F(a5),d0	;102D000F
	move.w	$002E(a5),d1	;322D002E
	beq.s	adrCd006A98	;6720
	cmpi.b	#$03,d0	;0C000003
	bne.s	adrCd006A98	;661A
	cmpi.w	#$0024,d1	;0C410024
	bcs.s	adrCd006AAE	;652A
	cmpi.w	#$002B,d1	;0C41002B
	bcc.s	adrCd006AAE	;6424
	btst	#$00,d2	;08020000
	beq.s	adrCd006AF2	;6762
	cmpi.w	#$0027,d1	;0C410027
	bcs.s	adrCd006AF2	;655C
	bra.s	adrCd006AAE	;6016

adrCd006A98:
	cmpi.b	#$02,d0	;0C000002
	bne.s	adrCd006AB4	;6616
	tst.w	d1	;4A41
	beq.s	adrCd006AF2	;6750
	cmpi.w	#$001B,d1	;0C41001B
	bcs.s	adrCd006AAE	;6506
	cmpi.w	#$0024,d1	;0C410024
	bcs.s	adrCd006AF2	;6544
adrCd006AAE:
	move.w	d7,$000E(a5)	;3B47000E
	rts	;4E75

adrCd006AB4:
	bcc.s	adrCd006AF2	;643C
	cmp.w	#$002B,$002E(a5)	;0C6D002B002E
	bcs.s	adrCd006ADC	;651E
	cmp.w	#$0030,$002E(a5)	;0C6D0030002E
	bcc.s	adrCd006ADC	;6416
	move.b	$0012(a4),d1	;122C0012
	move.b	$002F(a5),$0012(a4)	;196D002F0012
	move.b	d1,$002F(a5)	;1B41002F
	bne.s	adrCd006AF2	;661C
	clr.w	$002C(a5)	;426D002C
	bra.s	adrCd006AF2	;6016

adrCd006ADC:
	tst.b	$00(a6,d0.w)	;4A360000
	bne.s	adrCd006AF2	;6610
	tst.w	$002E(a5)	;4A6D002E
	bne.s	adrCd006AF2	;660A
	move.b	$0012(a4),$00(a6,d0.w)	;1DAC00120000
	clr.b	$0012(a4)	;422C0012
adrCd006AF2:
	moveq	#$00,d1	;7200
	move.b	$00(a6,d0.w),d1	;12360000
	beq	adrCd006B82	;67000088
	cmpi.w	#$0005,d1	;0C410005
	bcc	adrCd006B82	;64000080
	move.w	$002E(a5),d3	;362D002E
	bne.s	adrCd006B1C	;6612
	move.w	d1,$002E(a5)	;3B41002E
	move.w	#$0001,$002C(a5)	;3B7C0001002C
	subq.b	#$01,$0B(a6,d1.w)	;5336100B
	bra	adrCd006BB8	;6000009E

adrCd006B1C:
	cmpi.w	#$0005,d3	;0C430005
	bcs.s	adrCd006B30	;650E
	move.b	$0B(a6,d1.w),$002D(a5)	;1B76100B002D
	clr.b	$0B(a6,d1.w)	;4236100B
	bra	adrCd006BB0	;60000082

adrCd006B30:
	cmp.w	d1,d3	;B641
	bne.s	adrCd006B54	;6620
	move.b	$0B(a6,d1.w),d2	;1436100B
	add.b	$002D(a5),d2	;D42D002D
	move.b	d2,$0B(a6,d1.w)	;1D82100B
	cmpi.b	#$64,d2	;0C020064
	bcc.s	adrCd006B4C	;6406
	clr.l	$002C(a5)	;42AD002C
	bra.s	adrCd006BB8	;606C

adrCd006B4C:
	move.b	#$63,$0B(a6,d1.w)	;1DBC0063100B
	bra.s	adrCd006B78	;6024

adrCd006B54:
	move.b	$0B(a6,d3.w),d2	;1436300B
	add.b	$002D(a5),d2	;D42D002D
	cmpi.b	#$64,d2	;0C020064
	bcc.s	adrCd006B72	;6410
	move.b	d2,$0B(a6,d3.w)	;1D82300B
	move.b	$0B(a6,d1.w),$002D(a5)	;1B76100B002D
	clr.b	$0B(a6,d1.w)	;4236100B
	bra.s	adrCd006BA0	;602E

adrCd006B72:
	move.b	#$63,$0B(a6,d3.w)	;1DBC0063300B
adrCd006B78:
	sub.b	#$63,d2	;04020063
	move.b	d2,$002D(a5)	;1B42002D
	bra.s	adrCd006BB8	;6036

adrCd006B82:
	move.w	$002E(a5),d3	;362D002E
	beq.s	adrCd006BB0	;6728
	cmpi.w	#$0005,d3	;0C430005
	bcc.s	adrCd006BB0	;6422
	move.b	$0B(a6,d3.w),d2	;1436300B
	add.b	$002D(a5),d2	;D42D002D
	move.b	d2,$0B(a6,d3.w)	;1D82300B
	cmpi.b	#$64,d2	;0C020064
	bcc.s	adrCd006B72	;64D2
adrCd006BA0:
	moveq	#$0B,d2	;740B
adrLp006BA2:
	cmp.b	$00(a6,d2.w),d3	;B6362000
	bne.s	adrCd006BAC	;6604
	clr.b	$00(a6,d2.w)	;42362000
adrCd006BAC:
	dbra	d2,adrLp006BA2	;51CAFFF4
adrCd006BB0:
	move.b	d3,$00(a6,d0.w)	;1D830000
	move.w	d1,$002E(a5)	;3B41002E
adrCd006BB8:
	cmp.b	#$02,$000F(a5)	;0C2D0002000F
	bne.s	adrCd006BD8	;6618
	btst	d7,$003E(a5)	;0F2D003E
	beq.s	adrCd006BD8	;6712
	move.w	d7,-(sp)	;3F07
	bsr	adrCd007EF0	;61001326
	tst.w	$0002(sp)	;4A6F0002
	beq.s	adrCd006BD6	;6704
	bsr	adrCd007ED2	;610012FE
adrCd006BD6:
	move.w	(sp)+,d7	;3E1F
adrCd006BD8:
	move.w	d7,$000E(a5)	;3B47000E
	move.w	$002E(a5),d0	;302D002E
	beq.s	adrCd006BE8	;6706
	cmpi.w	#$0005,d0	;0C400005
	bcs.s	adrJA006C0A	;6522
adrCd006BE8:
	move.w	#$0001,$002C(a5)	;3B7C0001002C
	bra.s	adrJA006C0A	;601A

Click_OpenInventory:
	clr.w	$000E(a5)	;426D000E
	move.l	#$005E00E1,d4	;283C005E00E1
	move.l	#$00070040,d5	;2A3C00070040
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$03,d3	;7603
	bsr	BW_draw_bar	;61006E60
adrJA006C0A:
	move.w	$000E(a5),d7	;3E2D000E
	move.b	$18(a5,d7.w),d7	;1E357018
	and.w	#$000F,d7	;0247000F
	bsr	adrCd00C9BC	;61005DA4
	move.l	#$000D0003,adrW_00D92A.l	;23FC000D00030000D92A
	bsr	adrCd00C984	;61005D5E
	move.w	d7,d0	;3007
	bsr	adrCd00CF08	;610062DC
	move.w	#$0003,$0014(a5)	;3B7C00030014
adrCd006C34:
	bsr	adrCd006CD2	;6100009C
	cmp.b	#$03,$0015(a5)	;0C2D00030015
	bne	Trigger_00_t00_Null	;660003D6
adrCd006C42:
	or.b	#$04,$0054(a5)	;002D00040054
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$0B5C,a0	;D0FC0B5C
	add.w	$000A(a5),a0	;D0ED000A
	moveq	#$00,d7	;7E00
adrCd006C58:
	bsr	adrCd008416	;610017BC
	addq.w	#$01,d7	;5247
	cmpi.w	#$0004,d7	;0C470004
	bcs.s	adrCd006C58	;65F4
	move.w	$002E(a5),d0	;302D002E
	move.w	$002C(a5),d1	;322D002C
	bsr	ObjectGraphic	;61005DF8
	move.w	$0012(a5),d3	;362D0012
	moveq	#$74,d0	;7074
	bsr	adrCd00CAEA	;61005E72
	bsr	adrCd006D1E	;610000A2
	move.w	$002E(a5),d0	;302D002E
	beq.s	adrCd006C90	;670C
	cmpi.w	#$0005,d0	;0C400005
	bcs.s	adrCd006C90	;6506
	cmpi.w	#$0017,d0	;0C400017
	bcs.s	adrCd006C92	;6502
adrCd006C90:
	rts	;4E75

adrCd006C92:
	lea	adrEA00E998.l,a6	;4DF90000E998
	bsr	Print_fflim_text	;6100642C
adrCd006C9C:
	or.b	#$14,$0054(a5)	;002D00140054
	move.w	$000E(a5),d0	;302D000E
	move.b	$18(a5,d0.w),d0	;10350018
	bsr	adrCd006660	;6100F9B4
	move.b	$0010(a4),d0	;102C0010
	move.w	#$00C7,d1	;323C00C7
	moveq	#$3A,d2	;743A
	move.l	#$0004005A,d5	;2A3C0004005A	;Long Addr replaced with Symbol
	add.w	$0008(a5),d5	;DA6D0008
	move.l	#$00390098,d4	;283C00390098
	bsr	adrCd008144	;6100147A
	moveq	#$09,d3	;7609
	bra	BW_draw_bar	;60006D98

adrCd006CD2:
	move.w	$002E(a5),d0	;302D002E
	bne.s	adrCd006CE2	;660A
	lea	NullString.l,a6	;4DF90000CAE9
	bra	LowerText	;600062D8

adrCd006CE2:
	move.w	d0,d1	;3200
	sub.w	#$0040,d1	;04410040
	bcs.s	adrCd006D08	;651E
	cmpi.w	#$0010,d1	;0C410010
	bcc.s	adrCd006D08	;6418
	move.w	d1,d0	;3001
	bsr	adrCd004078	;6100D384
	move.w	$002E(a5),d0	;302D002E
	tst.w	d1	;4A41
	bmi.s	adrCd006D08	;6B0A
	bclr	#$05,$18(a5,d1.w)	;08B500051018
	clr.l	$002C(a5)	;42AD002C
adrCd006D08:
	lea	ObjectDefinitionsTable.l,a6	;4DF90000E4C4
	asl.w	#$02,d0	;E540
	add.w	d0,a6	;DCC0
	move.w	#$0006,adrW_00D92A.l	;33FC00060000D92A
	bra	Print_item_desc_fresh	;60006AE2

adrCd006D1E:
	moveq	#$0D,d3	;760D
	move.l	#$000E0049,d5	;2A3C000E0049
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$0F,d4	;780F
	swap	d4	;4844
	move.b	$000F(a5),d4	;182D000F
	asl.w	#$04,d4	;E944
	add.w	#$00E1,d4	;064400E1
	bra	BW_draw_frame	;60006D9A

adrCd006D3C:
	subq.b	#$01,$0055(a5)	;532D0055
	bpl.s	adrCd006D44	;6A02
adrCd006D42:
	rts	;4E75

adrCd006D44:
	tst.b	$0015(a5)	;4A2D0015
	bne.s	adrCd006D42	;66F8
	or.b	#$04,$0054(a5)	;002D00040054
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	$000A(a5),a0	;D0ED000A
	add.w	#$097C,a0	;D0FC097C
	lea	_GFX_Pockets+$6A60.l,a1	;43F900053162
	btst	#$00,(a5)	;08150000
	bne.s	adrCd006D6E	;6604
	lea	$0020(a1),a1	;43E90020
adrCd006D6E:
	move.l	#$00020016,d5	;2A3C00020016	;Long Addr replaced with Symbol
	move.l	#$00000088,a3	;267C00000088
	bra	adrCd00CCB8	;60005F3C

adrW_006D7E:
	dc.w	$0050	;0050
	dc.w	$0268	;0268
	dc.w	$01D8	;01D8
	dc.w	$0180	;0180
	dc.w	$0000	;0000
	dc.w	$00E0	;00E0
adrW_006D8A:
	dc.w	$00A0	;00A0
	dc.w	$0284	;0284
	dc.w	$02D0	;02D0
	dc.w	$0280	;0280
	dc.w	$00A0	;00A0
	dc.w	$00A2	;00A2
adrB_006D96:
	dc.b	$01	;01
adrB_006D97:
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

adrCd006DA2:
	tst.b	$0015(a5)	;4A2D0015
	bne	adrCd004C3E	;6600DE96
	or.b	#$04,$0054(a5)	;002D00040054
	move.b	#$81,$0055(a5)	;1B7C00810055
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	$000A(a5),a0	;D0ED000A
	add.w	#$08DC,a0	;D0FC08DC
	add.w	d0,d0	;D040
	add.w	adrW_006D8A(pc,d0.w),a0	;D0FB00C2
	lea	_GFX_ButtonHighlights.l,a1	;43F900018EFE
	add.w	adrW_006D7E(pc,d0.w),a1	;D2FB00AC
	moveq	#$00,d5	;7A00
	moveq	#$00,d3	;7600
	move.b	adrB_006D96(pc,d0.w),d5	;1A3B00BC
	move.b	d5,d3	;1605
	swap	d5	;4845
	move.b	adrB_006D97(pc,d0.w),d5	;1A3B00B5
	addq.w	#$01,d3	;5243
	add.w	d3,d3	;D643
	swap	d3	;4843
	bra	adrCd00B5CA	;600047DE

Click_MoveForwards:
	moveq	#$00,d0	;7000
	bra.s	MoveParty	;600A

Click_MoveBackwards:
	moveq	#$02,d0	;7002
	bra.s	MoveParty	;6006

Click_MoveLeft:
	moveq	#$03,d0	;7003
	bra.s	MoveParty	;6002

Click_MoveRight:
	moveq	#$01,d0	;7001
MoveParty:
	and.b	#$01,(a5)	;02150001
	move.w	d0,-(sp)	;3F00
	bsr.s	adrCd006DA2	;619E
	move.w	(sp)+,d6	;3C1F
	move.l	$001C(a5),d7	;2E2D001C
	add.w	$0020(a5),d6	;DC6D0020
	and.w	#$0003,d6	;02460003
	bsr	adrCd007A44	;61000C30
	bcc	adrCd006E3E	;64000026
	cmp.w	d0,d2	;B440
	bne.s	adrCd006E3C	;661E
	move.w	$00(a6,d0.w),d1	;32360000
	and.w	#$0007,d1	;02410007
	cmpi.w	#$0004,d1	;0C410004
	bne.s	adrCd006E3C	;6610
	move.b	$00(a6,d0.w),d1	;12360000
	lsr.b	#$01,d1	;E209
	eor.b	#$02,d1	;0A010002
	cmp.b	d1,d6	;BC01
	beq	adrCd006ED0	;67000096
adrCd006E3C:
	rts	;4E75

adrCd006E3E:
	move.w	$00(a6,d0.w),d1	;32360000
	and.w	#$0007,d1	;02410007
	subq.w	#$06,d1	;5D41
	bcs.s	adrCd006EA8	;655E
	beq.s	adrCd006E90	;6744
	move.b	$00(a6,d0.w),d1	;12360000
	move.w	d1,d2	;3401
	and.w	#$0003,d2	;02420003
	subq.w	#$01,d2	;5342
	bne.s	adrCd006EA8	;664E
	move.l	d7,$001C(a5)	;2B47001C
	movem.w	d0/d1,-(sp)	;48A7C000
	moveq	#$05,d1	;7205
	bsr	adrCd005500	;6100E69A
	movem.w	(sp)+,d0/d1	;4C9F0003
	tst.w	d3	;4A43
	bpl.s	adrCd006E3C	;6ACC
	lsr.b	#$02,d1	;E409
	move.w	d1,d7	;3E01
	movem.l	d0/a6,-(sp)	;48E78002
	bsr	adrCd001E42	;6100AFC8
	movem.l	(sp)+,d0/a6	;4CDF4001
	move.l	a5,-(sp)	;2F0D
	move.l	a5,a1	;224D
	clr.w	adrW_0020F4.w	;427820F4	;Short Absolute converted to symbol!
	bsr	adrCd00248C	;6100B602
	move.l	(sp)+,a5	;2A5F
	rts	;4E75

adrCd006E90:
	move.b	$00(a6,d0.w),d1	;12360000
	and.w	#$0003,d1	;02410003
	bne.s	adrCd006EA0	;6606
	bsr	adrCd006F80	;610000E4
	bra.s	adrCd006EA8	;6008

adrCd006EA0:
	subq.w	#$01,d1	;5341
	beq.s	adrCd006EA8	;6704
	bsr	adrCd006FAA	;61000104
adrCd006EA8:
	movem.l	d0/d7/a6,-(sp)	;48E78102
	bsr	adrCd0081CE	;61001320
	movem.l	(sp)+,d0/d7/a6	;4CDF4081
	move.w	$00(a6,d0.w),d1	;32360000
	and.w	#$0007,d1	;02410007
	cmpi.w	#$0004,d1	;0C410004
	bne	adrCd006F38	;66000076
	moveq	#$00,d6	;7C00
	move.b	$00(a6,d0.w),d6	;1C360000
	lsr.b	#$01,d6	;E20E
	eor.b	#$02,d6	;0A060002
adrCd006ED0:
	bclr	#$07,$01(a6,d0.w)	;08B600070001
	move.w	$0058(a5),d2	;342D0058
	move.w	d2,d1	;3202
	addq.w	#$01,d1	;5241
	btst	#$00,$00(a6,d0.w)	;083600000000
	beq.s	adrCd006EE8	;6702
	subq.w	#$02,d1	;5541
adrCd006EE8:
	bsr	adrCd0084BA	;610015D0
	move.w	d1,d0	;3001
	bsr	adrCd0084DA	;610015EA
	lea	adrEA005794.w,a0	;41F85794	;Short Absolute converted to symbol!
	add.b	$08(a0,d6.w),d7	;DE306008
	add.b	$08(a0,d6.w),d7	;DE306008
	swap	d7	;4847
	add.b	$00(a0,d6.w),d7	;DE306000
	add.b	$00(a0,d6.w),d7	;DE306000
	swap	d7	;4847
	bsr	CoordToMap	;61001590
	tst.b	$01(a6,d0.w)	;4A360001
	bpl.s	adrCd006F24	;6A10
	bsr	adrCd0084D6	;610015C0
	bsr	adrCd008498	;6100157E
	bset	#$07,$01(a6,d0.w)	;08F600070001
	rts	;4E75

adrCd006F24:
	move.w	d1,$0058(a5)	;3B410058
	bset	#$07,$01(a6,d0.w)	;08F600070001
	move.b	$00(a6,d0.w),d0	;10360000
	lsr.b	#$01,d0	;E208
	move.b	d0,$0021(a5)	;1B400021
adrCd006F38:
	move.l	d7,$001C(a5)	;2B47001C
	tst.b	$003E(a5)	;4A2D003E
	beq.s	adrCd006F4A	;6708
	clr.b	$003E(a5)	;422D003E
	bsr	adrCd007B50	;61000C08
adrCd006F4A:
	move.w	$0042(a5),d0	;302D0042
	bmi.s	adrCd006F58	;6B08
	cmpi.w	#$0008,d0	;0C400008
	bcc	Click_ShowTeamAvatars	;6400C388
adrCd006F58:
	rts	;4E75

Click_RotateLeft:
	subq.w	#$01,$0020(a5)	;536D0020
	and.w	#$0003,$0020(a5)	;026D00030020
	moveq	#$04,d0	;7004
	bra.s	adrCd006F74	;600C

Click_RotateRight:
	addq.w	#$01,$0020(a5)	;526D0020
	and.w	#$0003,$0020(a5)	;026D00030020
	moveq	#$05,d0	;7005
adrCd006F74:
	bsr	adrCd006DA2	;6100FE2C
	bsr	adrCd008498	;6100151E
	bra	adrCd006EA8	;6000FF2A

adrCd006F80:
	movem.l	d0/d7/a6,-(sp)	;48E78102
	moveq	#$03,d7	;7E03
adrLp006F86:
	move.b	$18(a5,d7.w),d1	;12357018
	move.w	d1,d0	;3001
	and.w	#$00E0,d1	;024100E0
	bne.s	adrCd006F9A	;6608
	bsr	adrCd006660	;6100F6CC
	clr.b	$0011(a4)	;422C0011
adrCd006F9A:
	dbra	d7,adrLp006F86	;51CFFFEA
	bsr	adrCd007B50	;61000BB0
	movem.l	(sp)+,d0/d7/a6	;4CDF4081
	rts	;4E75

adrEA006FA8:
	dc.w	$FFFF	;FFFF

adrCd006FAA:
	move.w	#$FFFF,adrEA006FA8.w	;31FCFFFF6FA8	;Short Absolute converted to symbol!
	move.b	$00(a6,d0.w),d1	;12360000
	and.w	#$0003,d1	;02410003
	subq.w	#$02,d1	;5541
	bne.s	adrCd006FC0	;6604
	clr.w	adrEA006FA8.w	;42786FA8	;Short Absolute converted to symbol!
adrCd006FC0:
	move.b	$00(a6,d0.w),d1	;12360000
	and.w	#$00F8,d1	;024100F8
	lsr.b	#$01,d1	;E209
	lea	TriggersData_1.l,a1	;43F900007056
	move.w	CurrentTower.l,d2	;34390000EE2E
	asl.w	#$07,d2	;EF42
	add.w	d2,a1	;D2C2
	moveq	#$00,d2	;7400
	move.b	$00(a1,d1.w),d2	;14311000
	cmpi.b	#$08,d2	;0C020008
	beq.s	adrCd006FF2	;670C
	cmpi.b	#$0A,d2	;0C02000A
	beq.s	adrCd006FF2	;6706
	cmpi.b	#$2A,d2	;0C02002A
	bne.s	adrCd006FF8	;6606
adrCd006FF2:
	move.w	#$0005,adrEA006FA8.w	;31FC00056FA8	;Short Absolute converted to symbol!
adrCd006FF8:
	lea	Trigger_00_t00_Null.l,a0	;41F900007016
	add.w	Triggers_LookupTable(pc,d2.w),a0	;D0FB2018
	movem.l	d0/d7/a6,-(sp)	;48E78102
	jsr	(a0)	;4E90
	move.w	adrEA006FA8.w,d0	;30386FA8	;Short Absolute converted to symbol!
	bmi.s	adrCd007012	;6B04
	bsr	PlaySound	;610018AE
adrCd007012:
	movem.l	(sp)+,d0/d7/a6	;4CDF4081
Trigger_00_t00_Null:
	rts	;4E75

Triggers_LookupTable:
	dc.w	Trigger_00_t00_Null-Trigger_00_t00_Null	;0000
	dc.w	Trigger_01_t02_Spinner180-Trigger_00_t00_Null	;06FC
	dc.w	Trigger_02_t04_SpinnerRandom-Trigger_00_t00_Null	;0704
	dc.w	Switch_03_s06_Trigger_03_t06_OpenLockedDoorXY-Trigger_00_t00_Null	;0730
	dc.w	Trigger_04_t08-Trigger_00_t00_Null	;07EA
	dc.w	Trigger_05_t0A-Trigger_00_t00_Null	;08DA
	dc.w	Trigger_06_t0C_WoodTrap1-Trigger_00_t00_Null	;06BC
	dc.w	Trigger_07_t0E_WoodTrap2-Trigger_00_t00_Null	;06D4
	dc.w	Trigger_08_t10-Trigger_00_t00_Null	;06EC
	dc.w	Trigger_09_t12-Trigger_00_t00_Null	;043E
	dc.w	Trigger_10_t14-Trigger_00_t00_Null	;03D0
	dc.w	Switch_01_s02_Trigger_11_t16_RemoveXY-Trigger_00_t00_Null	;ECFC
	dc.w	Trigger_12_t18-Trigger_00_t00_Null	;071E
	dc.w	Switch05_s0A_Trigger_13_t1A_TogglePillarXY-Trigger_00_t00_Null	;0756
	dc.w	Trigger_14_t1C-Trigger_00_t00_Null	;0768

	dc.w	Switch_00_s00_Trigger_15_t1E_ToggleWallXY-Trigger_00_t00_Null	;ECE2
	dc.w	Trigger_16_t20-Trigger_00_t00_Null	;0780
	dc.w	Trigger_17_t22-Trigger_00_t00_Null	;07C0
	dc.w	Switch06_s0C_Trigger_18_t24_CreatePillarXY-Trigger_00_t00_Null	;0752

	dc.w	Trigger_19_t26-Trigger_00_t00_Null	;0370
	dc.w	Trigger_20_t28-Trigger_00_t00_Null	;0340
	dc.w	Trigger_21_t2A-Trigger_00_t00_Null	;0670
	dc.w	Switch_04_s08_Trigger_22_t2C_RotateWallXY-Trigger_00_t00_Null	;069E

	dc.w	Switch_02_s04_Trigger_23_t2E-Trigger_00_t00_Null	;ECE6
	dc.w	adrJA007728-Trigger_00_t00_Null	;0712
	dc.w	Trigger_24_t30_Spinner3-Trigger_00_t00_Null	;0626
	dc.w	Trigger_25_t32-Trigger_00_t00_Null	;0774

	dc.w	Switch_07_s0E_Trigger_26_t34_RotateWoodXY-Trigger_00_t00_Null	;0742
	dc.w	Trigger_27_t36-Trigger_00_t00_Null	;061A
	dc.w	Trigger_28_t38_GameCompletion-Trigger_00_t00_Null	;0504
	dc.w	adrJA007502-Trigger_00_t00_Null	;04EC
TriggersData_1:
	INCBIN edit-data/mod0.triggers

TriggersData_2:
	INCBIN bw-data/serp.triggers

TriggersData_3:
	INCBIN bw-data/moon.triggers

TriggersData_4:
	INCBIN bw-data/drag.triggers

TriggersData_5:
	INCBIN bw-data/chaos.triggers

TriggersData_6:
	INCBIN bw-data/zendik.triggers

Trigger_20_t28:
	tst.w	MultiPlayer.l	;4A790000EE30
	beq	adrCd007470	;67000112
	pea	$00(a1,d1.w)	;48711000
	bsr	adrCd007974	;6100060E
	move.l	(sp)+,a2	;245F
	move.w	CurrentTower.l,d2	;34390000EE2E
	moveq	#$00,d1	;7200
	move.b	KeepStartLocsFloors(pc,d2.w),d1	;123B2058
	asl.w	#$02,d2	;E542
	lea	KeepStartLocations.l,a0	;41F9000073CE
	add.w	d2,a0	;D0C2
	moveq	#$00,d0	;7000
	bra	adrCd007408	;60000084

Trigger_19_t26:
	tst.w	MultiPlayer.l	;4A790000EE30
	bne	adrCd007470	;660000E2
	pea	$00(a1,d1.w)	;48711000
	bsr	adrCd005D2E	;6100E998
	bsr	adrCd0098A4	;6100250A
	bcc.s	adrCd0073A2	;6404
	tst.b	d0	;4A00
	bmi.s	adrCd0073A6	;6B04
adrCd0073A2:
	addq.w	#$04,sp	;584F
	rts	;4E75

adrCd0073A6:
	move.l	a1,-(sp)	;2F09
	bsr	adrCd007974	;610005CA
	movem.l	(sp)+,a1/a2	;4CDF0600
	move.w	CurrentTower.l,d2	;34390000EE2E
	moveq	#$00,d1	;7200
	move.b	KeepStartLocsFloors(pc,d2.w),d1	;123B2012
	asl.w	#$02,d2	;E542
	lea	KeepStartLocations.l,a0	;41F9000073CE
	add.w	d2,a0	;D0C2
	moveq	#$00,d0	;7000
	bra	adrCd00748C	;600000C2

KeepStartLocsFloors:
	dc.w	$0004	;0004
KeepStartLocations:
	dc.w	$0404	;0404
	dc.w	$0405	;0405
	dc.w	$0801	;0801
	dc.w	$0A01	;0A01
	dc.w	$0811	;0811
	dc.w	$0A11	;0A11
	dc.w	$1108	;1108
	dc.w	$110A	;110A
	dc.w	$0108	;0108
	dc.w	$010A	;010A
	dc.w	$0101	;0101
	dc.w	$0103	;0103

Trigger_10_t14:
	tst.w	MultiPlayer.l	;4A790000EE30
	beq	adrCd007470	;67000082
	pea	$00(a1,d1.w)	;48711000
	bsr	adrCd007974	;6100057E
	move.l	(sp)+,a2	;245F
	moveq	#$00,d0	;7000
	move.b	$0001(a2),d0	;102A0001
	lea	DungeonStartLocs.l,a0	;41F9000074EA
	moveq	#$00,d1	;7200
adrCd007408:
	moveq	#$00,d2	;7400
	move.b	$00(a0,d0.w),d2	;14300000
	add.b	$02(a0,d0.w),d2	;D4300002
	lsr.w	#$01,d2	;E24A
	swap	d2	;4842
	move.b	$01(a0,d0.w),d2	;14300001
	add.b	$03(a0,d0.w),d2	;D4300003
	lsr.w	#$01,d2	;E24A
	move.l	d2,$001C(a5)	;2B42001C
	move.w	d1,$0058(a5)	;3B410058
	lsr.b	#$02,d0	;E408
	move.w	d0,CurrentTower.l	;33C00000EE2E
	bsr	adrCd000B68	;61009736
	bsr	adrCd0084D6	;610010A0
	bsr	adrCd008498	;6100105E
	move.l	d0,$0004(sp)	;2F400004
	move.l	$001C(a5),$0008(sp)	;2F6D001C0008
	move.l	a6,$000C(sp)	;2F4E000C
	bset	#$07,$01(a6,d0.w)	;08F600070001
	bra	MonsterTransfer	;600095A4

Trigger_09_t12:
	tst.w	MultiPlayer.l	;4A790000EE30
	bmi.s	adrCd007470	;6B14
	pea	$00(a1,d1.w)	;48711000
	bsr	adrCd005D2E	;6100E8CC
	bsr	adrCd0098A4	;6100243E
	bcc.s	adrCd00746E	;6404
	tst.b	d0	;4A00
	bmi.s	adrCd007472	;6B04
adrCd00746E:
	addq.w	#$04,sp	;584F
adrCd007470:
	rts	;4E75

adrCd007472:
	move.l	a1,-(sp)	;2F09
	bsr	adrCd007974	;610004FE
	movem.l	(sp)+,a1/a2	;4CDF0600
	moveq	#$00,d0	;7000
	move.b	$0001(a2),d0	;102A0001
	add.w	d0,d0	;D040
	lea	DungeonStartLocs.l,a0	;41F9000074EA
	moveq	#$00,d1	;7200
adrCd00748C:
	move.b	$00(a0,d0.w),$001D(a5)	;1B700000001D
	move.b	$01(a0,d0.w),$001F(a5)	;1B700001001F
	move.w	d1,$0058(a5)	;3B410058
	eor.b	#$02,d0	;0A000002
	move.b	$00(a0,d0.w),$001D(a1)	;13700000001D
	move.b	$01(a0,d0.w),$001F(a1)	;13700001001F
	move.w	d1,$0058(a1)	;33410058
	lsr.b	#$02,d0	;E408
	move.w	d0,CurrentTower.l	;33C00000EE2E
	bsr	adrCd000B68	;610096AE
	bsr	adrCd0084D6	;61001018
	bsr	adrCd008498	;61000FD6
	move.l	d0,$0004(sp)	;2F400004
	move.l	$001C(a5),$0008(sp)	;2F6D001C0008
	move.l	a6,$000C(sp)	;2F4E000C
	bset	#$07,$01(a6,d0.w)	;08F600070001
	exg	a1,a5	;CB49
	bsr	adrCd008498	;61000FBC
	bset	#$07,$01(a6,d0.w)	;08F600070001
	exg	a1,a5	;CB49
	bra	MonsterTransfer	;6000950E

DungeonStartLocs:
	INCBIN bw-data/dungeon.entrances

adrJA007502:
	move.l	adrL_00EE78.l,a6	;2C790000EE78
	move.b	$0014(a6),d0	;102E0014
	and.b	$001C(a6),d0	;C02E001C
	btst	#$00,d0	;08000000
	bne	Switch_01_s02_Trigger_11_t16_RemoveXY	;6600E7FC
	rts	;4E75

Trigger_28_t38_GameCompletion:
	move.l	a5,-(sp)	;2F0D
	bsr.s	GameEndPicture	;6164
	clr.w	adrB_008C1E.l	;427900008C1E
	bsr	adrCd008CCA	;610017A4
	bsr	adrCd008D88	;6100185E
	moveq	#$4B,d0	;704B
DBFWait1d:
	dbra	d1,DBFWait1d	;51C9FFFE
	dbra	d0,DBFWait1d	;51C8FFFA
	lea	Player1_Data.l,a5	;4BF90000EE7C
	bsr	adrCd00CF96	;61005A58
	lea	NullString.l,a6	;4DF90000CAE9
	bsr	WriteText	;61005B46
	tst.w	MultiPlayer.l	;4A790000EE30
	bne.s	.Player2Skip	;6614
	lea	Player2_Data.l,a5	;4BF90000EEDE
	bsr	adrCd00CF96	;61005A3C
	lea	NullString.l,a6	;4DF90000CAE9
	bsr	WriteText	;61005B2A
.Player2Skip:
	bsr	adrCd008CCA	;61001762
	bsr	adrCd008D88	;6100181C
	move.w	#$FFFF,adrB_008C1E.l	;33FCFFFF00008C1E
adrCd007576:
	tst.b	adrB_008C1E.l	;4A3900008C1E
	bne.s	adrCd007576	;66F8
	move.l	(sp)+,a5	;2A5F
	rts	;4E75

GameEndPicture:
	lea	Player1_Data.l,a5	;4BF90000EE7C
	tst.w	MultiPlayer.l	;4A790000EE30
	bne.s	.GameEnd_repeat	;6608
	bsr.s	.GameEnd_repeat	;6106
	lea	Player2_Data.l,a5	;4BF90000EEDE
.GameEnd_repeat:
	clr.w	$0014(a5)	;426D0014
	move.w	#$FFFF,$0042(a5)	;3B7CFFFF0042
	bsr	adrCd007B50	;610005AC
	bsr	adrCd008278	;61000CD0
	bsr	adrCd002734	;6100B188
	movem.l	d0-d7/a0-a6,-(sp)	;48E7FFFE
	link	a3,#-$0020	;4E53FFE0
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	$000A(a5),a0	;D0ED000A
	add.w	#$01EC,a0	;D0FC01EC
	move.l	a0,-$0008(a3)	;2748FFF8
	clr.b	-$0015(a3)	;422BFFEB
	moveq	#$00,d0	;7000
	moveq	#$00,d1	;7200
	moveq	#$28,d5	;7A28
	moveq	#$36,d4	;7836
	bsr	Draw_Entropy	;61002F66
	unlk	a3	;4E5B
	lea	AccursedBloodwychMsg.l,a6	;4DF9000075F4
	bsr	WriteText	;61005AAC
	lea	CongratsText.l,a6	;4DF90000761C
	bsr	LowerText	;610059CC
	movem.l	(sp)+,d0-d7/a0-a6	;4CDF7FFF
	rts	;4E75

AccursedBloodwychMsg:
	dc.b	'ACCURSED BLOODWYCH! WE SHALL MEET AGAIN'	;414343555253454420424C4F4F445759434821205745205348414C4C204D45455420414741494E
	dc.b	$FF	;FF
CongratsText:
	dc.b	$FE	;FE
	dc.b	$0B	;0B
	dc.b	'CONGRATULATIONS!'	;434F4E47524154554C4154494F4E5321
	dc.b	$FF	;FF
	dc.b	$00	;00

Trigger_27_t36:
	bsr	adrCd005D2E	;6100E6FC
	eor.b	#$03,$00(a6,d0.w)	;0A3600030000
	rts	;4E75

Trigger_24_t30_Spinner3:
	moveq	#$00,d0	;7000
	move.b	$01(a1,d1.w),d0	;10311001
	move.w	d0,d6	;3C00
	bsr	adrCd0084DA	;61000E94
	bsr	adrCd005D2E	;6100E6E4
	tst.b	$01(a6,d0.w)	;4A360001
	bpl.s	adrCd007660	;6A0E
	subq.w	#$01,d7	;5347
	bsr	CoordToMap	;61000E46
	tst.b	$01(a6,d0.w)	;4A360001
	bpl.s	adrCd007660	;6A02
	rts	;4E75

adrCd007660:
	bsr.s	adrCd007664	;6102
	rts	;4E75

adrCd007664:
	bset	#$07,$01(a6,d0.w)	;08F600070001
	move.l	$0008(sp),d1	;222F0008
	bclr	#$07,$01(a6,d1.w)	;08B600071001
	move.w	d6,$0058(a5)	;3B460058
	move.l	d7,$001C(a5)	;2B47001C
	move.l	d7,$000C(sp)	;2F47000C
	move.l	d0,$0008(sp)	;2F400008
	rts	;4E75

Trigger_21_t2A:
	moveq	#$00,d0	;7000
	move.b	$01(a1,d1.w),d0	;10311001
	move.w	d0,d6	;3C00
	bsr	adrCd0084DA	;61000E4A
	bsr	adrCd005D2E	;6100E69A
	tst.b	$01(a6,d0.w)	;4A360001
	bpl.s	adrCd0076AC	;6A10
	addq.w	#$02,d0	;5440
	swap	d7	;4847
	addq.w	#$01,d7	;5247
	swap	d7	;4847
	tst.b	$01(a6,d0.w)	;4A360001
	bpl.s	adrCd0076AC	;6A02
	rts	;4E75

adrCd0076AC:
	bsr.s	adrCd007664	;61B6
	moveq	#$10,d7	;7E10
	bra	adrCd001DBC	;6000A70A

Switch_04_s08_Trigger_22_t2C_RotateWallXY:
	bsr	adrCd005D2E	;6100E678
	move.b	$01(a6,d0.w),d1	;12360001
	move.w	d1,d2	;3401
	and.b	#$CF,d2	;020200CF
	add.w	#$0010,d1	;06410010
	and.w	#$0030,d1	;02410030
	or.b	d1,d2	;8401
	move.b	d2,$01(a6,d0.w)	;1D820001
	rts	;4E75

Trigger_06_t0C_WoodTrap1:
	move.l	#$000D000C,d7	;2E3C000D000C
	bsr	CoordToMap	;61000DC2
	bset	#$02,$00(a6,d0.w)	;08F600020000
	bclr	#$06,$02(a6,d0.w)	;08B600060002
	rts	;4E75

Trigger_07_t0E_WoodTrap2:
	move.l	#$00030000,d7	;2E3C00030000	;Long Addr replaced with Symbol
	bsr	CoordToMap	;61000DAA
	bclr	#$02,$00(a6,d0.w)	;08B600020000
	bset	#$06,$02(a6,d0.w)	;08F600060002
	rts	;4E75

Trigger_08_t10:
	subq.w	#$02,d0	;5540
	tst.b	$01(a6,d0.w)	;4A360001
	bmi.s	adrCd007710	;6B06
	bset	#$00,$00(a6,d0.w)	;08F600000000
adrCd007710:
	rts	;4E75

Trigger_01_t02_Spinner180:
	eor.w	#$0002,$0020(a5)	;0A6D00020020
	rts	;4E75

Trigger_02_t04_SpinnerRandom:
	bsr	RandomGen_BytewithOffset	;6100DE90
	and.w	#$0003,d0	;02400003
	move.w	d0,$0020(a5)	;3B400020
	rts	;4E75

adrJA007728:
	addq.w	#$01,$0020(a5)	;526D0020
	and.w	#$0003,$0020(a5)	;026D00030020
	rts	;4E75

Trigger_12_t18:
	bsr	adrCd005D2E	;6100E5F8
	bset	#$00,$00(a6,d0.w)	;08F600000000
	move.w	#$0001,adrEA006FA8.w	;31FC00016FA8	;Short Absolute converted to symbol!
	rts	;4E75

Switch_03_s06_Trigger_03_t06_OpenLockedDoorXY:
	bsr	adrCd005D2E	;6100E5E6
	bclr	#$00,$00(a6,d0.w)	;08B600000000
	move.w	#$0001,adrEA006FA8.w	;31FC00016FA8	;Short Absolute converted to symbol!
	rts	;4E75

Switch_07_s0E_Trigger_26_t34_RotateWoodXY:
	bsr	adrCd005D2E	;6100E5D4
	move.b	$00(a6,d0.w),d1	;12360000
	ror.b	#$02,d1	;E419
	move.b	d1,$00(a6,d0.w)	;1D810000
	rts	;4E75

Switch06_s0C_Trigger_18_t24_CreatePillarXY:
	bsr	Switch_01_s02_Trigger_11_t16_RemoveXY	;6100E5A8
Switch05_s0A_Trigger_13_t1A_TogglePillarXY:
	bsr	adrCd005D2E	;6100E5C0
	move.b	#$01,$00(a6,d0.w)	;1DBC00010000
	eor.b	#$03,$01(a6,d0.w)	;0A3600030001
	rts	;4E75

Trigger_14_t1C:
	bsr	adrCd005D2E	;6100E5AE
	or.b	#$06,$01(a6,d0.w)	;003600060001
	rts	;4E75

Trigger_25_t32:
	bsr	adrCd005D2E	;6100E5A2
	eor.b	#$06,$01(a6,d0.w)	;0A3600060001
	rts	;4E75

Trigger_16_t20:
	moveq	#$00,d6	;7C00
	move.b	$01(a1,d1.w),d6	;1C311001
	move.w	d1,-(sp)	;3F01
	bsr	adrCd0084FC	;61000D5C
	move.w	(sp)+,d1	;321F
	move.l	d2,d7	;2E02
	lea	adrEA005794.w,a0	;41F85794	;Short Absolute converted to symbol!
	add.b	$08(a0,d6.w),d7	;DE306008
	cmp.w	adrW_00EE72.l,d7	;BE790000EE72
	bcc	Switch_01_s02_Trigger_11_t16_RemoveXY	;6400E55C
	swap	d7	;4847
	add.b	$00(a0,d6.w),d7	;DE306000
	cmp.w	adrW_00EE70.l,d7	;BE790000EE70
	bcc	Switch_01_s02_Trigger_11_t16_RemoveXY	;6400E54C
	swap	d7	;4847
	bsr	CoordToMap	;61000CD0
	eor.b	#$06,$01(a6,d0.w)	;0A3600060001
	rts	;4E75

Trigger_17_t22:
	bsr	adrCd0084FC	;61000D24
	move.l	d2,d7	;2E02
	subq.b	#$01,d7	;5307
	bsr	CoordToMap	;61000CBC
	and.w	#$00F8,$00(a6,d0.w)	;027600F80000
	or.w	#$0103,$00(a6,d0.w)	;007601030000
	swap	d7	;4847
	subq.b	#$01,d7	;5307
	swap	d7	;4847
	bsr	CoordToMap	;61000CA6
	and.w	#$00F8,$00(a6,d0.w)	;027600F80000
	rts	;4E75

Trigger_04_t08:
	addq.w	#$02,d0	;5440
	tst.b	$01(a6,d0.w)	;4A360001
	bmi	Trigger_00_t00_Null	;6B00F80E
	bset	#$00,$00(a6,d0.w)	;08F600000000
	addq.w	#$02,d0	;5440
adrCd007812:
	move.w	#$0086,d7	;3E3C0086
	bsr	adrCd001DBC	;6100A5A4
	tst.b	$01(a6,d0.w)	;4A360001
	bmi.s	adrCd007836	;6B16
	btst	#$06,$01(a6,d0.w)	;083600060001
	beq.s	adrCd007836	;670E
	moveq	#$03,d4	;7803
adrLp00782A:
	move.w	d4,d6	;3C04
	bsr	adrCd005F5C	;6100E72E
	beq.s	adrCd007838	;6706
adrCd007832:
	dbra	d4,adrLp00782A	;51CCFFF6
adrCd007836:
	rts	;4E75

adrCd007838:
	lea	$03(a0,d7.w),a1	;43F07003
	moveq	#$00,d3	;7600
	move.b	-$0001(a1),d3	;1629FFFF
	add.w	d3,d3	;D643
adrCd007844:
	move.b	$00(a1,d3.w),d2	;14313000
	sub.b	#$40,d2	;04020040
	bcs.s	adrCd007854	;6506
	cmpi.b	#$10,d2	;0C020010
	bcs.s	adrCd00785A	;6506
adrCd007854:
	subq.w	#$02,d3	;5543
	bcc.s	adrCd007844	;64EC
	bra.s	adrCd007832	;60D8

adrCd00785A:
	bset	#$07,$01(a6,d0.w)	;08F600070001
	move.w	d2,-(sp)	;3F02
	bsr	adrCd005DF8	;6100E594
	bsr	adrCd0084FC	;61000C94
	move.w	d1,d3	;3601
	move.w	(sp)+,d0	;301F
	and.w	#$000F,d0	;0240000F
	move.l	a5,-(sp)	;2F0D
	bsr	adrCd004066	;6100C7F0
	tst.w	d1	;4A41
	bpl.s	adrCd0078A0	;6A24
	move.l	(sp)+,a5	;2A5F
adrCd00787E:
	bsr	adrCd006660	;6100EDE0
	move.b	d2,$0017(a4)	;19420017
	swap	d2	;4842
	move.b	d2,$0016(a4)	;19420016
	move.b	d3,$001A(a4)	;1943001A
	move.b	#$03,$0018(a4)	;197C00030018
	move.b	CurrentTower+$1.l,$001F(a4)	;19790000EE2F001F
	rts	;4E75

adrCd0078A0:
	bclr	#$06,$18(a5,d1.w)	;08B500061018
	tst.w	d1	;4A41
	beq.s	adrCd0078C0	;6716
	btst	#$06,$0018(a5)	;082D00060018
	bne.s	adrCd0078B6	;6604
	bsr.s	adrCd00787E	;61CA
	bra.s	adrCd0078E4	;602E

adrCd0078B6:
	move.b	$0018(a5),$18(a5,d1.w)	;1BAD00181018
	move.w	d0,$0006(a5)	;3B400006
adrCd0078C0:
	move.b	d0,$0018(a5)	;1B400018
	bset	#$04,$0018(a5)	;08ED00040018
	move.l	d2,$001C(a5)	;2B42001C
	move.w	d3,$0058(a5)	;3B430058
	move.w	#$0003,$0020(a5)	;3B7C00030020
	move.b	d0,$0026(a5)	;1B400026
	bsr	adrCd008278	;6100099A
	clr.b	$0056(a5)	;422D0056
adrCd0078E4:
	bsr	adrCd007B50	;6100026A
	bsr	adrCd008246	;6100095C
	move.l	(sp)+,a5	;2A5F
	rts	;4E75

Trigger_05_t0A:
	subq.w	#$02,d0	;5540
	bset	#$00,$00(a6,d0.w)	;08F600000000
	addq.w	#$02,d0	;5440
adrCd0078FA:
	move.w	#$0086,d7	;3E3C0086
	bsr	adrCd001DBC	;6100A4BC
	moveq	#$05,d0	;7005
	bsr	PlaySound	;61000FB8
	move.w	#$FFFF,adrEA006FA8.w	;31FCFFFF6FA8	;Short Absolute converted to symbol!
	moveq	#$03,d0	;7003
adrLp007910:
	tst.b	$18(a5,d0.w)	;4A350018
	bmi.s	adrCd007958	;6B42
	btst	#$05,$18(a5,d0.w)	;083500050018
	bne.s	adrCd007958	;663A
	bclr	#$06,$18(a5,d0.w)	;08B500060018
	beq.s	adrCd007958	;6732
	move.w	d0,-(sp)	;3F00
	move.b	$18(a5,d0.w),d0	;10350018
	bsr	adrCd006660	;6100ED32
	move.b	#$05,$0007(a4)	;197C00050007
	move.b	#$05,$0005(a4)	;197C00050005
	move.w	(sp)+,d0	;301F
	moveq	#$03,d1	;7203
adrLp007940:
	tst.b	$26(a5,d1.w)	;4A351026
	bmi.s	adrCd00794C	;6B06
	dbra	d1,adrLp007940	;51C9FFF8
	moveq	#$00,d1	;7200
adrCd00794C:
	and.b	#$0F,$18(a5,d0.w)	;0235000F0018
	move.b	$18(a5,d0.w),$26(a5,d1.w)	;1BB500181026
adrCd007958:
	dbra	d0,adrLp007910	;51C8FFB6
	move.w	#$FFFF,$0042(a5)	;3B7CFFFF0042
	move.w	#$FFFF,$0040(a5)	;3B7CFFFF0040
	clr.b	$003E(a5)	;422D003E
	bsr	adrCd007B50	;610001E2
	bra	adrCd008246	;600008D4

adrCd007974:
	bsr	adrCd001090	;6100971A
	move.w	CurrentTower.l,d0	;30390000EE2E
	move.w	d0,d1	;3200
	add.w	d0,d0	;D040
	add.w	d0,d1	;D240
	asl.w	#$08,d1	;E141
	lea	MonsterData_1.l,a3	;47F900017584
	add.w	d1,a3	;D6C1
	lea	UnpackedMonsters.l,a4	;49F900016B7E
	move.w	-$0002(a4),d1	;322CFFFE
	lea	MonsterTotalsCounts.l,a0	;41F900017578
	move.w	d1,$00(a0,d0.w)	;31810000
	bmi.s	adrCd007A10	;6B6C
	move.l	a3,a0	;204B
	move.w	#$00BF,d0	;303C00BF
	moveq	#-$01,d2	;74FF
adrLp0079AC:
	move.l	d2,(a0)+	;20C2
	dbra	d0,adrLp0079AC	;51C8FFFC
	move.l	a3,a0	;204B
adrLp0079B4:
	move.b	$000A(a4),d2	;142C000A
	asl.b	#$04,d2	;E902
	move.b	$0004(a4),d3	;162C0004
	addq.w	#$01,d3	;5243
	and.w	#$000F,d3	;0243000F
	or.b	d2,d3	;8602
	move.b	d3,(a3)+	;16C3
	move.b	$0000(a4),(a3)+	;16EC0000
	move.b	$0001(a4),(a3)+	;16EC0001
	move.b	$0006(a4),(a3)+	;16EC0006
	move.b	$000B(a4),(a3)+	;16EC000B
	move.b	$000D(a4),d3	;162C000D
	bmi.s	adrCd007A06	;6B28
	lea	adrEA017390.l,a6	;4DF900017390
	asl.w	#$02,d3	;E543
	add.w	d3,a6	;DCC3
	moveq	#$03,d2	;7403
adrLp0079EA:
	moveq	#$00,d0	;7000
	move.b	$00(a6,d2.w),d0	;10362000
	bmi.s	adrCd007A02	;6B10
	add.b	d0,d0	;D000
	add.b	$00(a6,d2.w),d0	;D0362000
	add.w	d0,d0	;D040
	move.b	d3,d4	;1803
	add.b	d2,d4	;D802
	move.b	d4,$05(a0,d0.w)	;11840005
adrCd007A02:
	dbra	d2,adrLp0079EA	;51CAFFE6
adrCd007A06:
	addq.w	#$01,a3	;524B
	add.w	#$0010,a4	;D8FC0010
	dbra	d1,adrLp0079B4	;51C9FFA6
adrCd007A10:
	lea	adrEA0174F8.l,a0	;41F9000174F8
	move.l	adrL_00EE78.l,a6	;2C790000EE78
	move.w	-$0002(a0),d7	;3E28FFFE
	clr.w	-$0002(a0)	;4268FFFE
	bra.s	adrCd007A30	;600A

adrLp007A26:
	move.w	(a0),d0	;3010
	bclr	#$05,$01(a6,d0.w)	;08B600050001
	clr.l	(a0)+	;4298
adrCd007A30:
	dbra	d7,adrLp007A26	;51CFFFF4
adrCd007A34:
	tst.w	adrW_0173F4.l	;4A79000173F4
	beq.s	adrCd007A42	;6706
	bsr	adrCd001174	;61009736
	bra.s	adrCd007A34	;60F2

adrCd007A42:
	rts	;4E75

adrCd007A44:
	move.l	d7,d5	;2A07
	bsr	CoordToMap	;61000A54
	move.w	d0,d2	;3400
	bsr	adrCd007AE6	;61000098
	bcs	adrCd007ADE	;6500008C
	move.w	d6,d0	;3006
	bsr	adrCd008486	;61000A2E
	cmp.w	adrW_00EE72.l,d7	;BE790000EE72
	bcc.s	adrCd007ADC	;647A
	swap	d7	;4847
	cmp.w	adrW_00EE70.l,d7	;BE790000EE70
	bcc.s	adrCd007ADC	;6470
	swap	d7	;4847
	move.b	$01(a6,d0.w),d1	;12360001
	bpl.s	adrCd007A8E	;6A1A
	and.w	#$0007,d1	;02410007
	subq.b	#$01,d1	;5301
	beq.s	adrCd007ADC	;6760
	subq.b	#$01,d1	;5301
	bne.s	adrCd007ADE	;665E
	eor.w	#$0002,d6	;0A460002
	bsr.s	adrCd007AF4	;616E
	bcs.s	adrCd007AD8	;6550
	eor.w	#$0002,d6	;0A460002
	bra.s	adrCd007ADE	;6050

adrCd007A8E:
	and.w	#$0007,d1	;02410007
	move.b	adrB_007AD0(pc,d1.w),d1	;123B103C
	beq.s	adrCd007AC0	;6728
	bpl.s	adrCd007AB0	;6A16
	addq.b	#$01,d1	;5201
	beq.s	adrCd007ADC	;673E
	addq.b	#$01,d1	;5201
	beq.s	adrCd007ADE	;673C
	move.b	$00(a6,d0.w),d1	;12360000
	not.b	d1	;4601
	and.b	#$03,d1	;02010003
	beq.s	adrCd007ADC	;672E
	bra.s	adrCd007AC0	;6010

adrCd007AB0:
	eor.w	#$0002,d6	;0A460002
	subq.b	#$01,d1	;5301
	bne.s	adrCd007ABC	;6604
	bsr.s	adrCd007AF8	;613E
	bra.s	adrCd007ABE	;6002

adrCd007ABC:
	bsr.s	adrCd007AF4	;6136
adrCd007ABE:
	bcs.s	adrCd007AD8	;6518
adrCd007AC0:
	bclr	#$07,$01(a6,d2.w)	;08B600072001
	bset	#$07,$01(a6,d0.w)	;08F600070001
	swap	d1	;4841
	rts	;4E75

adrB_007AD0:
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$02	;02
	dc.b	$FE	;FE
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$FD	;FD

adrCd007AD8:
	eor.w	#$0002,d6	;0A460002
adrCd007ADC:
	move.w	d2,d0	;3002
adrCd007ADE:
	move.l	d5,d7	;2E05
	sub.w	#$FFFF,d1	;0441FFFF
	rts	;4E75

adrCd007AE6:
	move.b	$01(a6,d0.w),d1	;12360001
	and.w	#$0007,d1	;02410007
	cmpi.b	#$02,d1	;0C010002
	bne.s	adrCd007B04	;6610
adrCd007AF4:
	move.w	d6,d1	;3206
	add.w	d1,d1	;D241
adrCd007AF8:
	btst	d1,$00(a6,d0.w)	;03360000
	beq.s	adrCd007B04	;6706
	sub.b	#$FF,d1	;040100FF
	rts	;4E75

adrCd007B04:
	swap	d1	;4841
	rts	;4E75

adrCd007B08:
	bsr	adrCd008DA8	;6100129E
	moveq	#$00,d4	;7800
	moveq	#$60,d5	;7A60
	tst.w	MultiPlayer.l	;4A790000EE30
	beq.s	adrCd007B20	;6708
	moveq	#$1F,d5	;7A1F
	bsr.s	adrCd007B2E	;6112
	move.w	#$0090,d5	;3A3C0090
adrCd007B20:
	bsr.s	adrCd007B2E	;610C
adrCd007B22:
	bsr	adrCd008278	;61000754
	bsr	adrCd007B50	;61000028
	bra	adrCd008FB8	;6000148C

adrCd007B2E:
	move.l	#$013F0001,d3	;263C013F0001
adrCd007B34:
	bsr	BW_blit_horiz_line	;6100604E
	addq.w	#$01,d5	;5245
	addq.w	#$01,d3	;5243
	cmpi.w	#$0005,d3	;0C430005
	bcs.s	adrCd007B34	;65F2
	subq.w	#$02,d3	;5543
adrCd007B44:
	bsr	BW_blit_horiz_line	;6100603E
	addq.w	#$01,d5	;5245
	subq.w	#$01,d3	;5343
	bne.s	adrCd007B44	;66F6
	rts	;4E75

adrCd007B50:
	tst.w	$0042(a5)	;4A6D0042
	bmi	adrCd007EC0	;6B00036A
	or.b	#$03,$0054(a5)	;002D00030054
	move.l	#$005F0000,d4	;283C005F0000
	move.l	#$00580007,d5	;2A3C00580007
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$00,d3	;7600
	bsr	BW_draw_bar	;61005EF6
	move.l	#$FFFFFFFF,$005A(a5)	;2B7CFFFFFFFF005A
	bsr	adrCd00CCBE	;61005140
	moveq	#$0A,d5	;7A0A
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$32,d4	;7832
	move.l	#$002B0002,d3	;263C002B0002
	bsr	BW_blit_vertical_line	;61005F74
	moveq	#$5D,d4	;785D
	bsr	BW_blit_vertical_line	;61005F6E
	addq.w	#$02,d5	;5445
	sub.l	#$00040000,d3	;048300040000	;Long Addr replaced with Symbol
	moveq	#$5B,d4	;785B
	bsr	BW_blit_vertical_line	;61005F60
	moveq	#$34,d4	;7834
	bsr	BW_blit_vertical_line	;61005F5A
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$0147,a0	;D0FC0147
	add.w	$000A(a5),a0	;D0ED000A
	moveq	#$71,d7	;7E71
	move.w	$0012(a5),d3	;362D0012
adrCd007BC0:
	move.w	d7,d0	;3007
	bsr	adrCd00CAEA	;61004F26
	addq.w	#$01,d7	;5247
	move.w	d7,d0	;3007
	bsr	adrCd00CAEA	;61004F1E
	addq.w	#$01,d7	;5247
	add.w	#$027C,a0	;D0FC027C
	cmpi.w	#$0075,d7	;0C470075
	bcs.s	adrCd007BC0	;65E6
	cmp.w	#$0008,$0042(a5)	;0C6D00080042
	bne.s	adrCd007BE8	;6606
	cmpi.w	#$0077,d7	;0C470077
	bcs.s	adrCd007BC0	;65D8
adrCd007BE8:
	bsr	adrCd007D6C	;61000182
	lea	_GFX_Pockets+$3C60.l,a1	;43F900050362
	move.l	#$00050006,d5	;2A3C00050006	;Long Addr replaced with Symbol
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$0DE8,a0	;D0FC0DE8
	add.w	$000A(a5),a0	;D0ED000A
	lea	$0070.w,a3	;47F80070
	bra	adrCd00CCB8	;600050AC

adrEA007C0E:
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
adrEA007C20:
	dc.b	$5F	;5F
	dc.b	$5F	;5F
	dc.b	$5F	;5F
	dc.b	$5F	;5F
adrEA007C24:
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$FF	;FF
adrEA007C2C:
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
adrEA007C3A:
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
adrEA007C4D:
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
adrEA007C6F:
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
adrEA007C87:
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
adrEA007C93:
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

adrJA007CA0:
	lea	adrEA007C0E.w,a6	;4DF87C0E	;Short Absolute converted to symbol!
	rts	;4E75

adrJA007CA6:
	bsr.s	adrCd007D06	;615E
	moveq	#$01,d1	;7201
	moveq	#$00,d3	;7600
adrCd007CAC:
	move.b	$18(a5,d1.w),d0	;10351018
	and.w	#$00E0,d0	;024000E0
	bne.s	adrCd007CCC	;6616
	move.b	$18(a5,d1.w),d0	;10351018
	and.w	#$000F,d0	;0240000F
	move.b	d0,$04(a6,d2.w)	;1D802004
	move.b	#$5F,$00(a6,d3.w)	;1DBC005F3000
	addq.w	#$01,d3	;5243
	addq.w	#$02,d2	;5442
adrCd007CCC:
	addq.w	#$01,d1	;5241
	cmpi.w	#$0004,d1	;0C410004
	bcs.s	adrCd007CAC	;65D8
	rts	;4E75

adrJA007CD6:
	bsr.s	adrCd007D06	;612E
	moveq	#$02,d1	;7202
	moveq	#$00,d3	;7600
adrLp007CDC:
	move.b	$19(a5,d1.w),d0	;10351019
	bmi.s	adrCd007D00	;6B1E
	btst	#$05,d0	;08000005
	beq.s	adrCd007D00	;6718
	btst	#$06,d0	;08000006
	bne.s	adrCd007D00	;6612
	and.w	#$000F,d0	;0240000F
	move.b	d0,$04(a6,d2.w)	;1D802004
	move.b	#$5F,$00(a6,d3.w)	;1DBC005F3000
	addq.w	#$02,d2	;5442
	addq.w	#$01,d3	;5243
adrCd007D00:
	dbra	d1,adrLp007CDC	;51C9FFDA
	rts	;4E75

adrCd007D06:
	lea	adrEA007C20.w,a6	;4DF87C20	;Short Absolute converted to symbol!
	move.b	#$FC,d0	;103C00FC
	moveq	#$08,d2	;7408
adrCd007D10:
	move.b	d0,$02(a6,d2.w)	;1D802002
	subq.w	#$02,d2	;5542
	bne.s	adrCd007D10	;66F8
	move.l	#$FFFFFFFF,(a6)	;2CBCFFFFFFFF
	rts	;4E75

adrJA007D20:
	lea	adrEA007C2C.w,a6	;4DF87C2C	;Short Absolute converted to symbol!
	rts	;4E75

adrJA007D26:
	lea	adrEA007C3A.w,a6	;4DF87C3A	;Short Absolute converted to symbol!
	rts	;4E75

adrJA007D2C:
	lea	adrEA007C4D.w,a6	;4DF87C4D	;Short Absolute converted to symbol!
	rts	;4E75

adrJA007D32:
	lea	adrEA007C6F.w,a6	;4DF87C6F	;Short Absolute converted to symbol!
	rts	;4E75

adrJA007D38:
	lea	adrEA007C87.w,a6	;4DF87C87	;Short Absolute converted to symbol!
	rts	;4E75

adrJA007D3E:
	lea	adrEA007C93.w,a6	;4DF87C93	;Short Absolute converted to symbol!
	rts	;4E75

adrJT007D44:
	dc.l	adrJA007CA0	;00007CA0
	dc.l	adrJA007CA6	;00007CA6
	dc.l	$00000000	;00000000
	dc.l	adrJA007CD6	;00007CD6
	dc.l	adrJA007D20	;00007D20
	dc.l	adrJA007D26	;00007D26
	dc.l	adrJA007D2C	;00007D2C
	dc.l	adrJA007D32	;00007D32
	dc.l	adrJA007D38	;00007D38
	dc.l	adrJA007D3E	;00007D3E

adrCd007D6C:
	or.b	#$01,$0054(a5)	;002D00010054
	move.w	$0044(a5),d0	;302D0044
	asl.w	#$02,d0	;E540
	move.l	adrJT007D44(pc,d0.w),a0	;207B00CA
	jsr	(a0)	;4E90
	move.l	a6,$0046(a5)	;2B4E0046
	move.l	#$00060039,d5	;2A3C00060039
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$00,d7	;7E00
adrCd007D8E:
	moveq	#$02,d3	;7602
	moveq	#$00,d4	;7800
	move.b	$00(a6,d7.w),d4	;18367000
	bpl.s	adrCd007D9C	;6A04
	moveq	#$5F,d4	;785F
	bra.s	adrCd007DAC	;6010

adrCd007D9C:
	cmp.b	$0040(a5),d7	;BE2D0040
	bne.s	adrCd007DAC	;660A
	tst.b	$0041(a5)	;4A2D0041
	bne.s	adrCd007DAC	;6604
	move.w	$0010(a5),d3	;362D0010
adrCd007DAC:
	subq.w	#$01,d4	;5344
	swap	d4	;4844
	movem.l	d4/d5/d7,-(sp)	;48E70D00
	bsr	BW_draw_bar	;61005CB2
	subq.w	#$07,d5	;5F45
	swap	d4	;4844
	addq.w	#$01,d4	;5244
	move.l	#$00060000,d3	;263C00060000
	bsr	BW_blit_vertical_line	;61005D3E
	movem.l	(sp),d4/d5/d7	;4CD700B0
	swap	d4	;4844
	addq.w	#$02,d4	;5444
	moveq	#$5D,d0	;705D
	sub.w	d4,d0	;9044
	bcs.s	adrCd007DF2	;651C
	swap	d4	;4844
	move.w	d0,d4	;3800
	swap	d4	;4844
	moveq	#$02,d3	;7602
	cmp.b	$0040(a5),d7	;BE2D0040
	bne.s	adrCd007DEE	;660A
	tst.b	$0041(a5)	;4A2D0041
	beq.s	adrCd007DEE	;6704
	move.w	$0010(a5),d3	;362D0010
adrCd007DEE:
	bsr	BW_draw_bar	;61005C78
adrCd007DF2:
	movem.l	(sp)+,d4/d5/d7	;4CDF00B0
	addq.w	#$08,d5	;5045
	addq.w	#$01,d7	;5247
	cmpi.w	#$0004,d7	;0C470004
	bcs.s	adrCd007D8E	;658E
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	$000A(a5),a0	;D0ED000A
	add.w	#$0910,a0	;D0FC0910
	addq.w	#$04,a6	;584E
	moveq	#$00,d7	;7E00
adrCd007E12:
	move.l	a0,-(sp)	;2F08
	bsr	Print_com_menu_entry	;61005936
	clr.b	adrB_00EE2D.l	;42390000EE2D
	move.l	(sp)+,a0	;205F
	add.w	#$0140,a0	;D0FC0140
adrL_007E22:	equ	*-2
	addq.w	#$01,d7	;5247
	cmpi.w	#$0004,d7	;0C470004
	bcs.s	adrCd007E12	;65E6
	moveq	#$00,d4	;7800
	moveq	#$39,d5	;7A39
	add.w	$0008(a5),d5	;DA6D0008
	move.l	#$001E0000,d3	;263C001E0000
	bsr	BW_blit_vertical_line	;61005CC8
	moveq	#$5E,d4	;785E
	bsr	BW_blit_vertical_line	;61005CC2
	addq.w	#$01,d4	;5244
	bra	BW_blit_vertical_line	;60005CBC

adrCd007E4A:
	add.l	screen_ptr.l,a0	;D1F900008D36
	add.w	$000A(a5),a0	;D0ED000A
	lea	_GFX_Pockets+$6500.l,a1	;43F900052C02
	move.l	#$00000024,-(sp)	;2F3C00000024
	moveq	#$00,d3	;7600
adrCd007E62:
	lea	$0098.w,a3	;47F80098
	bra	adrCd00CE28	;60004FC0

adrCd007E6A:
	btst	d7,$003E(a5)	;0F2D003E
	beq.s	adrCd007E80	;6710
	move.b	$18(a5,d7.w),d1	;12357018
	move.b	d1,d0	;1001
	and.w	#$000F,d0	;0240000F
	and.w	#$00E0,d1	;024100E0
	beq.s	adrCd007E82	;6702
adrCd007E80:
	rts	;4E75

adrCd007E82:
	move.b	d0,-$0017(a3)	;1740FFE9
	move.w	d7,d0	;3007
	add.w	d7,d7	;DE47
	add.w	d0,d7	;DE40
	add.w	d7,d7	;DE47
	move.w	adrW_007EA8(pc,d7.w),d4	;383B7018
	move.w	adrW_007EAA(pc,d7.w),d5	;3A3B7016
	move.w	adrW_007EAC(pc,d7.w),d1	;323B7014
	moveq	#$00,d0	;7000
	move.w	#$FFFF,adrW_00AD64.l	;33FCFFFF0000AD64
	bra	Draw_Character	;6000289E

adrW_007EA8:
	dc.w	$0011	;0011
adrW_007EAA:
	dc.w	$001C	;001C
adrW_007EAC:
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

adrCd007EC0:
	moveq	#$03,d7	;7E03
adrLp007EC2:
	move.w	d7,-(sp)	;3F07
	bsr	adrCd007EF0	;6100002A
	move.w	(sp)+,d7	;3E1F
	dbra	d7,adrLp007EC2	;51CFFFF6
	bsr	adrCd007FF8	;61000128
adrCd007ED2:
	lea	_GFX_Pockets+$3C30.l,a1	;43F900050332
	move.l	#$00050006,d5	;2A3C00050006	;Long Addr replaced with Symbol
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$0DE8,a0	;D0FC0DE8
	add.w	$000A(a5),a0	;D0ED000A
	bra	adrLp008D3E	;60000E50

adrCd007EF0:
	tst.b	$5A(a5,d7.w)	;4A35705A
	bmi.s	adrCd007EF8	;6B02
	rts	;4E75

adrCd007EF8:
	or.b	#$03,$0054(a5)	;002D00030054
	tst.w	d7	;4A47
	beq.s	adrCd007F0A	;6708
	clr.w	adrW_00EE2A.l	;42790000EE2A
	bra.s	adrCd007F54	;604A

adrCd007F0A:
	tst.w	$0042(a5)	;4A6D0042
	bpl	adrCd00CCBE	;6A004DAE
	moveq	#$00,d3	;7600
	moveq	#$5F,d4	;785F
	swap	d4	;4844
	move.l	#$002E0007,d5	;2A3C002E0007
	add.w	$0008(a5),d5	;DA6D0008
	bsr	BW_draw_bar	;61005B44
	btst	#$00,$003E(a5)	;082D0000003E
	bne.s	adrCd007F36	;6608
	bsr	adrCd00CCBE	;61004D8E
	bra	adrCd007FF8	;600000C4

adrCd007F36:
	move.l	#$00000230,a0	;207C00000230
	bsr	adrCd007E4A	;6100FF0C
	move.l	#$00000235,a0	;207C00000235
	bsr	adrCd007E4A	;6100FF02
	moveq	#$00,d7	;7E00
	bsr	adrCd007FB2	;61000064
	bra	adrCd007FF8	;600000A6

adrCd007F54:
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$0898,a0	;D0FC0898
	add.w	$000A(a5),a0	;D0ED000A
	move.w	d7,d0	;3007
	subq.w	#$01,d7	;5347
	asl.w	#$02,d7	;E547
	add.w	d7,a0	;D0C7
	move.b	$18(a5,d0.w),d7	;1E350018
	bpl.s	adrCd007F86	;6A16
	lea	_GFX_Shield_Clicked.l,a1	;43F900019BFE
	sub.l	a3,a3	;97CB
	move.l	#$00010028,d5	;2A3C00010028	;Long Addr replaced with Symbol
	move.w	$0012(a5),d3	;362D0012
	bra	adrCd00CE26	;60004EA2

adrCd007F86:
	btst	d0,$003E(a5)	;012D003E
	beq.s	adrCd007FD6	;674A
	btst	#$05,d7	;08070005
	bne.s	adrCd007FD6	;6644
	btst	#$06,d7	;08070006
	bne.s	adrCd007FDE	;6646
	move.w	d0,-(sp)	;3F00
	lea	_GFX_Pockets+$5070.l,a1	;43F900051772
	move.l	#$00010028,d5	;2A3C00010028	;Long Addr replaced with Symbol
	move.l	#$00000090,a3	;267C00000090
	bsr	adrCd00CCB8	;61004D0A
	move.w	(sp)+,d7	;3E1F
adrCd007FB2:
	link	a3,#-$0020	;4E53FFE0
	move.b	#$FF,-$0019(a3)	;177C00FFFFE7
	clr.b	-$0015(a3)	;422BFFEB
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	$000A(a5),a0	;D0ED000A
	move.l	a0,-$0008(a3)	;2748FFF8
	bsr	adrCd007E6A	;6100FE9A
	unlk	a3	;4E5B
adrCd007FD4:
	rts	;4E75

adrCd007FD6:
	moveq	#$04,d3	;7604
	btst	#$06,d7	;08070006
	beq.s	adrCd007FE0	;6702
adrCd007FDE:
	moveq	#$00,d3	;7600
adrCd007FE0:
	and.w	#$000F,d7	;0247000F
	tst.w	d3	;4A43
	beq.s	adrCd007FF4	;670C
	bsr	adrCd00CCFE	;61004D14
	cmpi.w	#$0008,d3	;0C430008
	bne.s	adrCd007FF4	;6602
	subq.w	#$01,d3	;5343
adrCd007FF4:
	bra	Draw_ShieldAvatar	;60004DAA

adrCd007FF8:
	tst.w	$0042(a5)	;4A6D0042
	bpl.s	adrCd007FD4	;6AD6
	moveq	#$36,d4	;7836
	moveq	#$0A,d5	;7A0A
	add.w	$0008(a5),d5	;DA6D0008
	move.l	#$00240001,d3	;263C00240001
	bsr	BW_blit_horiz_line	;61005B76
	addq.w	#$01,d5	;5245
	subq.w	#$02,d4	;5544
	add.l	#$00040001,d3	;068300040001	;Long Addr replaced with Symbol
	bsr	BW_blit_horiz_line	;61005B68
	addq.w	#$01,d5	;5245
	subq.w	#$01,d4	;5344
	add.l	#$00020001,d3	;068300020001	;Long Addr replaced with Symbol
	bsr	BW_blit_horiz_line	;61005B5A
	addq.w	#$01,d5	;5245
	addq.w	#$01,d3	;5243
	bsr	BW_blit_horiz_line	;61005B52
	addq.w	#$01,d5	;5245
	subq.w	#$03,d3	;5743
	bsr	BW_blit_horiz_line	;61005B4A
	moveq	#$31,d5	;7A31
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$33,d4	;7833
	move.l	#$002A0001,d3	;263C002A0001
	bsr	BW_blit_horiz_line	;61005B38
	addq.w	#$01,d5	;5245
	addq.w	#$03,d3	;5643
	bsr	BW_blit_horiz_line	;61005B30
	addq.w	#$01,d5	;5245
	subq.w	#$01,d3	;5343
	bsr	BW_blit_horiz_line	;61005B28
	addq.w	#$01,d4	;5244
	addq.w	#$01,d5	;5245
	sub.l	#$00020001,d3	;048300020001	;Long Addr replaced with Symbol
	bsr	BW_blit_horiz_line	;61005B1A
	addq.w	#$02,d4	;5444
	addq.w	#$01,d5	;5245
	sub.l	#$00040001,d3	;048300040001	;Long Addr replaced with Symbol
	bsr	BW_blit_horiz_line	;61005B0C
	moveq	#$10,d5	;7A10
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$34,d4	;7834
	move.l	#$001F0001,d3	;263C001F0001
	bsr	BW_blit_vertical_line	;61005A7A
	moveq	#$5C,d4	;785C
	bsr	BW_blit_vertical_line	;61005A74
	swap	d5	;4845
	move.w	#$001F,d5	;3A3C001F
	swap	d5	;4845
	move.l	#$00260035,d4	;283C00260035
	moveq	#$02,d3	;7602
	bsr	BW_draw_bar	;610059C4
	lea	_GFX_Pockets+$7580.l,a1	;43F900053C82
	move.l	#$00000088,a3	;267C00000088
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	$000A(a5),a0	;D0ED000A
	add.w	#$0286,a0	;D0FC0286
	move.l	#$00020005,d5	;2A3C00020005	;Long Addr replaced with Symbol
	bsr	adrCd00CCB8	;61004BF0
adrCd0080CA:
	tst.w	$0042(a5)	;4A6D0042
	bpl	adrCd008256	;6A000186
	or.b	#$01,$0054(a5)	;002D00010054
	move.l	#$00240036,d4	;283C00240036
	move.l	#$00160017,d5	;2A3C00160017
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$03,d3	;7603
	bsr	BW_draw_bar	;6100597C
	btst	#$00,$003E(a5)	;082D0000003E
	bne	adrCd00815C	;66000066
	move.w	$0006(a5),d7	;3E2D0006
	asl.w	#$05,d7	;EB47
	lea	CharacterStats.l,a6	;4DF90000EB2A
	lea	$05(a6,d7.w),a6	;4DF67005
	move.l	#$00040019,d5	;2A3C00040019	;Long Addr replaced with Symbol
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$02,d6	;7C02
	moveq	#$07,d3	;7607
	btst	#$00,(a5)	;08150000
	beq.s	adrLp00811E	;6702
	moveq	#$0C,d3	;760C
adrLp00811E:
	move.b	(a6)+,d0	;101E
	beq.s	adrCd008132	;6710
	move.b	(a6),d1	;1216
	bsr.s	adrCd00813C	;6116
	movem.l	d3-d6,-(sp)	;48E71E00
	bsr	BW_draw_bar	;6100593C
	movem.l	(sp)+,d3-d6	;4CDF0078
adrCd008132:
	addq.w	#$07,d5	;5E45
	addq.w	#$01,a6	;524E
	dbra	d6,adrLp00811E	;51CEFFE6
	rts	;4E75

adrCd00813C:
	move.l	#$00220037,d4	;283C00220037
	moveq	#$23,d2	;7423
adrCd008144:
	swap	d4	;4844
	cmp.b	d1,d0	;B001
	bcc.s	adrCd008158	;640E
	and.w	#$00FF,d0	;024000FF
	and.w	#$00FF,d1	;024100FF
	mulu	d2,d0	;C0C2
	divu	d1,d0	;80C1
	move.w	d0,d4	;3800
adrCd008158:
	swap	d4	;4844
	rts	;4E75

adrCd00815C:
	moveq	#$0E,d3	;760E
	lea	CharacterStats+$5.l,a6	;4DF90000EB2F
	moveq	#$03,d6	;7C03
	move.l	#$00060052,d5	;2A3C00060052
adrLp00816C:
	move.b	$18(a5,d6.w),d0	;10356018
	move.w	d0,d1	;3200
	and.w	#$00E0,d1	;024100E0
	bne.s	adrCd0081C0	;6648
	and.w	#$000F,d0	;0240000F
	asl.w	#$05,d0	;EB40
	move.b	$01(a6,d0.w),d1	;12360001
	move.b	$00(a6,d0.w),d0	;10360000
	beq.s	adrCd0081C0	;6738
	and.w	#$00FF,d0	;024000FF
	moveq	#$14,d4	;7814
	swap	d4	;4844
	moveq	#$15,d2	;7415
	bsr.s	adrCd008144	;61B0
	swap	d4	;4844
	moveq	#$2C,d2	;742C
	sub.w	d4,d2	;9444
	swap	d4	;4844
	move.w	d2,d4	;3802
	movem.l	d3-d6,-(sp)	;48E71E00
	exg	d4,d5	;C945
	add.w	$0008(a5),d5	;DA6D0008
	move.b	$18(a5,d6.w),d0	;10356018
	and.w	#$000F,d0	;0240000F
	bsr	adrCd006900	;6100E74E
	move.b	adrB_0081CA(pc,d0.w),d3	;163B0014
	bsr	BW_draw_bar	;610058AE
	movem.l	(sp)+,d3-d6	;4CDF0078
adrCd0081C0:
	sub.w	#$0009,d5	;04450009
	dbra	d6,adrLp00816C	;51CEFFA6
adrCd0081C8:
	rts	;4E75

adrB_0081CA:
	dc.b	$06	;06
	dc.b	$0D	;0D
	dc.b	$0C	;0C
	dc.b	$07	;07

adrCd0081CE:
	tst.w	$0014(a5)	;4A6D0014
	bne.s	adrCd0081C8	;66F4
	or.b	#$04,$0054(a5)	;002D00040054
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$054C,a0	;D0FC054C
	add.w	$000A(a5),a0	;D0ED000A
	bsr	adrCd00665C	;6100E472
	moveq	#$63,d0	;7063
	moveq	#$00,d2	;7400
	move.b	$0011(a4),d2	;142C0011
	bne.s	adrCd00820A	;6614
	move.b	$0013(a4),d2	;142C0013
	bmi.s	adrCd008206	;6B0A
	move.w	d2,d0	;3002
	bsr	adrCd006900	;6100E700
	add.w	#$0064,d0	;06400064
adrCd008206:
	bra	adrCd00CAEA	;600048E2

adrCd00820A:
	and.w	#$0007,d2	;02420007
	move.b	adrB_00821E(pc,d2.w),d0	;103B200E
	cmpi.w	#$0040,d0	;0C400040
	bne.s	adrCd008206	;66EE
	add.w	$0020(a5),d0	;D06D0020
	bra.s	adrCd008206	;60E8

adrB_00821E:
	dc.b	$3C	;3C
	dc.b	$3D	;3D
	dc.b	$3E	;3E
	dc.b	$3F	;3F
	dc.b	$40	;40
	dc.b	$44	;44
	dc.b	$45	;45
	dc.b	$46	;46

adrL_008226:
	tst.b	$0055(a5)	;4A2D0055
	bpl.s	adrCd008230	;6A04
	bsr	adrCd006D3C	;6100EB0E
adrCd008230:
	move.b	$0034(a5),d0	;102D0034
	bmi.s	adrCd008256	;6B20
	move.b	#$FF,$0034(a5)	;1B7C00FF0034
	lea	adrEA0041DE.w,a6	;4DF841DE	;Short Absolute converted to symbol!
	move.b	d0,(a6)	;1C80
	bsr	Print_timed_message	;61005626
adrCd008246:
	moveq	#$00,d0	;7000
	move.b	$0015(a5),d0	;102D0015
	beq	adrCd008396	;67000148
	subq.b	#$03,d0	;5700
	beq	adrCd006C34	;6700E9E0
adrCd008256:
	rts	;4E75

adrCd008258:
	or.b	#$0C,$0054(a5)	;002D000C0054
	bsr	adrCd00CF96	;61004D36
	move.l	#$005E00E1,d4	;283C005E00E1
	move.l	#$00560009,d5	;2A3C00560009
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$00,d3	;7600
	bra	BW_draw_bar	;600057F2

adrCd008278:
	bsr.s	adrCd008258	;61DE
	move.w	#$00E2,d4	;383C00E2
	moveq	#$0A,d5	;7A0A
	add.w	$0008(a5),d5	;DA6D0008
	move.l	#$005D0001,d3	;263C005D0001
adrCd00828A:
	bsr	BW_blit_horiz_line	;610058F8
	addq.w	#$01,d5	;5245
	addq.w	#$01,d3	;5243
	cmpi.w	#$0005,d3	;0C430005
	bcs.s	adrCd00828A	;65F2
	subq.w	#$04,d3	;5943
	bsr	BW_blit_horiz_line	;610058E8
	move.l	#$00070010,d5	;2A3C00070010
	add.w	$0008(a5),d5	;DA6D0008
	move.l	#$005D00E2,d4	;283C005D00E2
	move.w	$0010(a5),d3	;362D0010
	bsr	BW_draw_bar	;610057B4
	move.w	#$0001,d3	;363C0001
adrCd0082BA:
	addq.w	#$01,d5	;5245
	bsr	BW_blit_horiz_line	;610058C6
	addq.w	#$01,d3	;5243
	cmpi.w	#$0005,d3	;0C430005
	bcs.s	adrCd0082BA	;65F2
	move.w	$0006(a5),d0	;302D0006
	bsr	adrCd00CF08	;61004C3A
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$0544,a0	;D0FC0544
	add.w	$000A(a5),a0	;D0ED000A
	lea	_GFX_Pockets+$67C0.l,a1	;43F900052EC2
	move.l	#$00000080,a3	;267C00000080
	move.l	#$00030015,d5	;2A3C00030015	;Long Addr replaced with Symbol
	bsr	adrCd00CCB8	;610049C6
	add.w	#$0028,a0	;D0FC0028
	lea	_GFX_Pockets+$67E0.l,a1	;43F900052EE2
	btst	#$00,(a5)	;08150000
	bne.s	adrCd008308	;6604
	add.w	#$0020,a1	;D2FC0020
adrCd008308:
	move.l	#$0003001E,d5	;2A3C0003001E	;Long Addr replaced with Symbol
	bsr	adrCd00CCB8	;610049A8
	bsr	adrCd0081CE	;6100FEBA
	move.w	#$0062,d0	;303C0062
	bsr	adrCd00CAEA	;610047CE
	moveq	#$20,d5	;7A20
	add.w	$0008(a5),d5	;DA6D0008
	move.w	#$0120,d4	;383C0120
	move.l	#$001F0001,d3	;263C001F0001
	bsr	BW_blit_horiz_line	;61005854
	add.w	#$0011,d5	;06450011
	bsr	BW_blit_horiz_line	;6100584C
	addq.w	#$02,d5	;5445
adrCd00833C:
	bsr	BW_blit_horiz_line	;61005846
	addq.w	#$01,d5	;5245
	addq.w	#$01,d3	;5243
	cmpi.w	#$0005,d3	;0C430005
	bcs.s	adrCd00833C	;65F2
	subq.w	#$04,d3	;5943
	bsr	BW_blit_horiz_line	;61005836
	bsr.s	adrCd008396	;6144
	move.l	#$00000E04,a0	;207C00000E04	;Long Addr replaced with Symbol
adrCd008358:
	move.l	#$00000070,a3	;267C00000070
	lea	_GFX_Pockets+$3C00.l,a1	;43F900050302
	move.l	#$00050006,d5	;2A3C00050006	;Long Addr replaced with Symbol
	add.l	screen_ptr.l,a0	;D1F900008D36
	add.w	$000A(a5),a0	;D0ED000A
	bra	adrCd00CCB8	;60004942

;fiX Label expected
	move.w	d0,d2	;3400
	and.w	#$0003,d0	;02400003
	asl.w	#$02,d0	;E540
	and.w	#$000C,d2	;0242000C
	lsr.w	#$02,d2	;E44A
	add.w	d2,d0	;D042
	add.w	#$0050,d0	;06400050
adrCd00838C:
	rts	;4E75

adrW_00838E:
	dc.w	$08E4	;08E4
	dc.w	$0000	;0000
	dc.w	$0256	;0256
	dc.w	$FFFC	;FFFC

adrCd008396:
	btst	#$06,$0018(a5)	;082D00060018
	bne.s	adrCd00838C	;66EE
	or.b	#$04,$0054(a5)	;002D00040054
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	$000A(a5),a0	;D0ED000A
	moveq	#$00,d7	;7E00
adrCd0083B0:
	move.w	d7,d2	;3407
	add.w	d2,d2	;D442
	add.w	adrW_00838E(pc,d2.w),a0	;D0FB20D8
	move.b	$26(a5,d7.w),d0	;10357026
	bpl.s	adrCd0083C4	;6A06
	bsr	adrCd008462	;610000A2
	bra.s	adrCd0083D4	;6010

adrCd0083C4:
	cmp.w	$0016(a5),d7	;BE6D0016
	beq.s	adrCd0083D0	;6706
	bsr	adrCd008430	;61000064
	bra.s	adrCd0083D4	;6004

adrCd0083D0:
	bsr	adrCd00842C	;6100005A
adrCd0083D4:
	addq.w	#$01,d7	;5247
	cmpi.w	#$0004,d7	;0C470004
	bcs.s	adrCd0083B0	;65D4
	move.w	$0006(a5),d0	;302D0006
	bsr	adrCd004092	;6100BCB0
	move.w	$0010(a5),d3	;362D0010
	move.l	#$000F0121,d4	;283C000F0121
	move.l	#$000D0039,d5	;2A3C000D0039
	add.w	$0008(a5),d5	;DA6D0008
	btst	#$01,d2	;08020001
	beq.s	adrCd008402	;6704
	add.w	#$000F,d5	;0645000F
adrCd008402:
	move.b	adrB_008412(pc,d2.w),d2	;143B200E
	beq.s	adrCd00840E	;6706
	sub.l	#$0000FFF0,d4	;04840000FFF0	;Long Addr replaced with Symbol
adrCd00840E:
	bra	BW_draw_frame	;600056C4

adrB_008412:
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$00	;00

adrCd008416:
	move.b	$18(a5,d7.w),d0	;10357018
	and.w	#$00EF,d0	;024000EF
	bmi.s	adrCd008462	;6B42
	btst	#$05,d0	;08000005
	bne.s	adrCd008462	;663C
	btst	#$06,d0	;08000006
	beq.s	adrCd008430	;6704
adrCd00842C:
	moveq	#$00,d6	;7C00
	bra.s	adrCd00843E	;600E

adrCd008430:
	move.w	d0,d1	;3200
	bsr	adrCd006900	;6100E4CC
	move.w	d0,d6	;3C00
	move.w	d1,d0	;3001
	addq.w	#$01,d6	;5246
	asl.w	#$02,d6	;E546
adrCd00843E:
	lea	adrEA00846A.l,a6	;4DF90000846A
	add.w	d6,a6	;DCC6
	and.w	#$0003,d0	;02400003
	add.w	#$004B,d0	;0640004B
	move.w	#$FFFF,adrW_00B4BE.l	;33FCFFFF0000B4BE
	bsr	adrCd00CAEA	;61004692
	clr.w	adrW_00B4BE.l	;42790000B4BE
	rts	;4E75

adrCd008462:
	move.w	#$003B,d0	;303C003B
	bra	adrCd00CAEA	;60004682

adrEA00846A:
	dc.w	$0004	;0004
	dc.w	$030E	;030E
ClassColours:
	dc.w	$0006	;0006
	dc.w	$050E	;050E
	dc.w	$000D	;000D
	dc.w	$0B0E	;0B0E
	dc.w	$000B	;000B
	dc.w	$0C0D	;0C0D
	dc.w	$0008	;0008
	dc.w	$070E	;070E

adrCd00847E:
	move.l	$001C(a5),d7	;2E2D001C
adrCd008482:
	move.w	$0020(a5),d0	;302D0020
adrCd008486:
	lea	adrEA005794.w,a0	;41F85794	;Short Absolute converted to symbol!
	add.b	$08(a0,d0.w),d7	;DE300008
	swap	d7	;4847
	add.b	$00(a0,d0.w),d7	;DE300000
	swap	d7	;4847
	bra.s	CoordToMap	;6004

adrCd008498:
	move.l	$001C(a5),d7	;2E2D001C
CoordToMap:
	move.l	adrL_00EE78.l,a6	;2C790000EE78
adrCd0084A2:
	move.w	d7,d0	;3007
	mulu	adrW_00EE70.l,d0	;C0F90000EE70
	swap	d7	;4847
	add.w	d7,d0	;D047
	swap	d7	;4847
	add.w	d0,d0	;D040
	add.w	adrW_00EE76.l,d0	;D0790000EE76
	rts	;4E75

adrCd0084BA:
	lea	adrEA00EE60.l,a0	;41F90000EE60
	add.b	$08(a0,d2.w),d7	;DE302008
	swap	d7	;4847
	add.b	$00(a0,d2.w),d7	;DE302000
	sub.b	$00(a0,d1.w),d7	;9E301000
	swap	d7	;4847
	sub.b	$08(a0,d1.w),d7	;9E301008
	rts	;4E75

adrCd0084D6:
	move.w	$0058(a5),d0	;302D0058
adrCd0084DA:
	lea	adrEA00EE40.l,a0	;41F90000EE40
	move.b	$00(a0,d0.w),adrB_00EE71.l	;13F000000000EE71
	move.b	$08(a0,d0.w),adrB_00EE73.l	;13F000080000EE73
	add.w	d0,d0	;D040
	move.w	$10(a0,d0.w),adrW_00EE76.l	;33F000100000EE76
	rts	;4E75

adrCd0084FC:
	moveq	#-$01,d1	;72FF
	moveq	#$00,d2	;7400
	move.w	adrW_00EE76.l,d2	;34390000EE76
	lea	adrEA00EE50.l,a0	;41F90000EE50
adrCd00850C:
	addq.w	#$01,d1	;5241
	cmp.w	(a0)+,d2	;B458
	bne.s	adrCd00850C	;66FA
	sub.w	d0,d2	;9440
	neg.w	d2	;4442
	lsr.w	#$01,d2	;E24A
	divu	adrW_00EE70.l,d2	;84F90000EE70
	rts	;4E75

adrL_008520:
	dc.l	$00000000	;00000000

adrLp008524:
	bsr	adrCd008534	;6100000E
	bsr	adrCd008726	;610001FC
	addq.w	#$02,d0	;5440
	dbra	d7,adrLp008524	;51CFFFF4
	rts	;4E75

adrCd008534:
	movem.l	d0-d7/a1-a4,-(sp)	;48E7FF78
	move.l	adrL_008520.l,a1	;227900008520
	move.w	#$00F9,d6	;3C3C00F9
adrLp008542:
	move.l	#$AAAAAAAA,(a1)+	;22FCAAAAAAAA
	dbra	d6,adrLp008542	;51CEFFF8
	moveq	#$0A,d3	;760A
	moveq	#$0B,d2	;740B
adrLp008550:
	move.l	a1,a6	;2C49
	move.l	#$AAAAAAAA,(a1)+	;22FCAAAAAAAA
	move.l	#$44894489,(a1)+	;22FC44894489
	move.b	#$FF,d7	;1E3C00FF
	asl.l	#$08,d7	;E187
	move.b	d0,d7	;1E00
	asl.l	#$08,d7	;E187
	move.b	d1,d7	;1E01
	asl.l	#$08,d7	;E187
	move.b	d2,d7	;1E02
	move.l	a1,a2	;2449
	move.l	d7,d6	;2C07
	and.l	#$AAAAAAAA,d6	;0286AAAAAAAA
	lsr.l	#$01,d6	;E28E
	move.l	d6,(a1)+	;22C6
	and.l	#$55555555,d7	;028755555555
	move.l	d7,(a1)+	;22C7
	moveq	#$01,d5	;7A01
	bsr	adrCd00868A	;61000102
	eor.l	d6,d7	;BD87
	move.l	a1,a2	;2449
	clr.l	(a1)+	;4299
	clr.l	(a1)+	;4299
	clr.l	(a1)+	;4299
	clr.l	(a1)+	;4299
	clr.l	(a1)+	;4299
	clr.l	(a1)+	;4299
	clr.l	(a1)+	;4299
	clr.l	(a1)+	;4299
	move.l	d7,d6	;2C07
	and.l	#$AAAAAAAA,d6	;0286AAAAAAAA
	lsr.l	#$01,d6	;E28E
	move.l	d6,(a1)+	;22C6
	and.l	#$55555555,d7	;028755555555
	move.l	d7,(a1)+	;22C7
	moveq	#$05,d5	;7A05
	bsr	adrCd00868A	;610000D4
	move.l	a1,a3	;2649
	addq.l	#$08,a1	;5089
	move.l	a1,a4	;2849
	moveq	#$7F,d5	;7A7F
	moveq	#$00,d4	;7800
adrLp0085C2:
	move.l	(a0)+,d7	;2E18
	move.l	d7,d6	;2C07
	and.l	#$AAAAAAAA,d6	;0286AAAAAAAA
	lsr.l	#$01,d6	;E28E
	and.l	#$55555555,d7	;028755555555
	move.l	d7,$0200(a1)	;23470200
	move.l	d6,(a1)+	;22C6
	eor.l	d6,d4	;BD84
	eor.l	d7,d4	;BF84
	dbra	d5,adrLp0085C2	;51CDFFE2
	move.l	d4,d7	;2E04
	and.l	#$AAAAAAAA,d4	;0284AAAAAAAA
	lsr.l	#$01,d4	;E28C
	and.l	#$55555555,d7	;028755555555
	move.l	a3,a2	;244B
	move.l	d4,(a3)+	;26C4
	move.l	d7,(a3)	;2687
	moveq	#$01,d5	;7A01
	bsr	adrCd00868A	;6100008E
	move.l	a4,a2	;244C
	move.w	#$0080,d5	;3A3C0080
	bsr	adrCd00868A	;61000084
	addq.b	#$01,d1	;5201
	subq.b	#$01,d2	;5302
	add.l	#$00000200,a1	;D3FC00000200
	dbra	d3,adrLp008550	;51CBFF3C
	move.l	#$AAAAAAAA,(a1)	;22BCAAAAAAAA
	move.w	#$0002,_custom+intreq.l	;33FC000200DFF09C
	move.l	adrL_008520.l,a1	;227900008520
	move.l	a1,_custom+dskpt.l	;23C900DFF020
	move.w	#$8210,_custom+dmacon.l	;33FC821000DFF096
	move.w	#$7700,_custom+adkcon.l	;33FC770000DFF09E
	move.w	#$9100,_custom+adkcon.l	;33FC910000DFF09E
	move.w	#$4000,_custom+dsklen.l	;33FC400000DFF024
	move.b	_ciab+ciaicr.l,d0	;103900BFDD00
adrCd008656:
	move.b	_ciab+ciaicr.l,d0	;103900BFDD00
	btst	#$04,d0	;08000004
	beq.s	adrCd008656	;67F4
	move.w	#$D955,_custom+dsklen.l	;33FCD95500DFF024
	move.w	#$D955,_custom+dsklen.l	;33FCD95500DFF024
adrCd008672:
	move.w	_custom+intreqr.l,d0	;303900DFF01E
	btst	#$01,d0	;08000001
	beq.s	adrCd008672	;67F4
	movem.l	(sp)+,d0-d7/a1-a4	;4CDF1EFF
	bsr	adrCd00886A	;610001E6
	bra	adrCd0086D2	;6000004A

adrCd00868A:
	movem.l	d0-d5/a2,-(sp)	;48E7FC20
	add.w	d5,d5	;DA45
	subq.w	#$01,d5	;5345
	move.b	-$0001(a2),d0	;102AFFFF
adrLp008696:
	move.l	(a2),d4	;2812
	move.l	d4,d1	;2204
	move.l	d4,d2	;2404
	not.l	d1	;4681
	and.l	#$55555555,d1	;028155555555
	asl.l	#$01,d1	;E381
	move.l	d1,d3	;2601
	roxr.b	#$01,d0	;E210
	roxr.l	#$01,d4	;E294
	eor.l	d4,d1	;B981
	and.l	d3,d1	;C283
	or.l	d1,d2	;8481
	move.l	d2,(a2)+	;24C2
	move.b	d2,d0	;1002
	dbra	d5,adrLp008696	;51CDFFDE
	movem.l	(sp)+,d0-d5/a2	;4CDF043F
	rts	;4E75

adrCd0086C0:
	move.l	a0,-(sp)	;2F08
adrLp0086C2:
	bsr	adrCd0087A6	;610000E2
	bsr	adrCd008726	;6100005E
	dbra	d0,adrLp0086C2	;51C8FFF6
	move.l	(sp)+,a0	;205F
	rts	;4E75

adrCd0086D2:
	btst	#$05,_ciaa.l	;0839000500BFE001
	bne.s	adrCd0086D2	;66F6
	rts	;4E75

;fiX Label expected
	st	adrB_0088A2.l	;50F9000088A2
	move.b	#$79,_ciab+ciaprb.l	;13FC007900BFD100
	nop	;4E71
	nop	;4E71
	move.b	#$71,_ciab+ciaprb.l	;13FC007100BFD100
	move.w	#$B000,d0	;303CB000
adrLp0086FC:
	dbra	d0,adrLp0086FC	;51C8FFFE
	rts	;4E75

adrCd008702:
	clr.b	adrB_0088A2.l	;4239000088A2
	move.b	#$7D,_ciab+ciaprb.l	;13FC007D00BFD100
	nop	;4E71
	nop	;4E71
	move.b	#$75,_ciab+ciaprb.l	;13FC007500BFD100
	move.w	#$B000,d0	;303CB000

adrLp008720:
	dbra	d0,adrLp008720	;51C8FFFE
	rts	;4E75

adrCd008726:
	tst.b	adrB_0088A2.l	;4A39000088A2
	beq.s	adrCd008744	;6716
	move.b	#$70,_ciab+ciaprb.l	;13FC007000BFD100
	nop	;4E71
	nop	;4E71
	move.b	#$71,_ciab+ciaprb.l	;13FC007100BFD100
	bra.s	adrCd008758	;6014

adrCd008744:
	move.b	#$74,_ciab+ciaprb.l	;13FC007400BFD100
	nop	;4E71
	nop	;4E71
	move.b	#$75,_ciab+ciaprb.l	;13FC007500BFD100
adrCd008758:
	bsr	adrCd00886A	;61000110
	bra	adrCd0086D2	;6000FF74

adrCd008760:
	tst.b	adrB_0088A2.l	;4A39000088A2
	beq.s	adrCd00877E	;6716
	move.b	#$72,_ciab+ciaprb.l	;13FC007200BFD100
	nop	;4E71
	nop	;4E71
	move.b	#$73,_ciab+ciaprb.l	;13FC007300BFD100
	bra.s	adrCd008792	;6014

adrCd00877E:
	move.b	#$76,_ciab+ciaprb.l	;13FC007600BFD100
	nop	;4E71
	nop	;4E71
	move.b	#$77,_ciab+ciaprb.l	;13FC007700BFD100
adrCd008792:
	bsr	adrCd00886A	;610000D6
	bra	adrCd0086D2	;6000FF3A

;fiX Label expected
	subq.w	#$01,d6	;5346
	beq	adrCd00884A	;670000AC
	bsr	adrCd00886A	;610000C8
	bra.s	adrCd0087AC	;6006

adrCd0087A6:
	movem.l	d0-d2/d5/d6/a1,-(sp)	;48E7E640
	moveq	#$03,d6	;7C03
adrCd0087AC:
	move.w	#$0002,_custom+intreq.l	;33FC000200DFF09C
	move.l	adrL_008520.l,a1	;227900008520
	clr.l	$0002(a1)	;42A90002
	move.l	a1,_custom+dskpt.l	;23C900DFF020
	move.w	#$8010,_custom+dmacon.l	;33FC801000DFF096
	move.w	#$4489,_custom+dsksync.l	;33FC448900DFF07E
	move.w	#$9500,_custom+adkcon.l	;33FC950000DFF09E
	move.w	#$4000,_custom+dsklen.l	;33FC400000DFF024
	move.b	_ciab+ciaicr.l,d0	;103900BFDD00
adrCd0087EA:
	move.b	_ciab+ciaicr.l,d0	;103900BFDD00
	btst	#$04,d0	;08000004
	beq.s	adrCd0087EA	;67F4
	move.w	#$9F40,_custom+dsklen.l	;33FC9F4000DFF024
	move.w	#$9F40,_custom+dsklen.l	;33FC9F4000DFF024
	move.l	#adrL_0186A0,d1	;223C000186A0
adrCd00880C:
	move.w	_custom+intreqr.l,d0	;303900DFF01E
	btst	#$01,d0	;08000001
	bne.s	adrCd00881C	;6604
	subq.l	#$01,d1	;5381
	bne.s	adrCd00880C	;66F0
adrCd00881C:
	moveq	#$0A,d5	;7A0A
	lea	$003A(a1),a1	;43E9003A
adrLp008822:
	moveq	#$7F,d6	;7C7F
adrLp008824:
	move.l	$0200(a1),d1	;22290200
	move.l	(a1)+,d0	;2019
	asl.l	#$01,d0	;E380
	and.l	#$AAAAAAAA,d0	;0280AAAAAAAA
	and.l	#$55555555,d1	;028155555555
	or.l	d1,d0	;8081
	move.l	d0,(a0)+	;20C0
	dbra	d6,adrLp008824	;51CEFFE6
	add.l	#$00000240,a1	;D3FC00000240
	dbra	d5,adrLp008822	;51CDFFDA
adrCd00884A:
	movem.l	(sp)+,d0-d2/d5/d6/a1	;4CDF0267
	rts	;4E75

adrCd008850:
	move.b	_ciaa.l,d0	;103900BFE001
	btst	#$04,d0	;08000004
	beq.s	adrCd008866	;670A
	bsr	adrCd008760	;6100FF02
	bsr	adrCd00886A	;61000008
	bra.s	adrCd008850	;60EA

adrCd008866:
	bra	adrCd0086D2	;6000FE6A

adrCd00886A:
	move.l	d7,-(sp)	;2F07
	move.w	#$0960,d7	;3E3C0960
adrLp008870:
	dbra	d7,adrLp008870	;51CFFFFE
	move.l	(sp)+,d7	;2E1F
	rts	;4E75

adrCd008878:
	move.b	#$FD,_ciab+ciaprb.l	;13FC00FD00BFD100
	nop	;4E71
	nop	;4E71
	move.b	#$F5,_ciab+ciaprb.l	;13FC00F500BFD100
	rts	;4E75

adrCd00888E:
	move.l	d7,-(sp)	;2F07
	bsr.s	adrCd008850	;61BE
	subq.w	#$01,d7	;5347
	bcs.s	adrCd00889E	;6508
adrLp008896:
	bsr	adrCd008726	;6100FE8E
	dbra	d7,adrLp008896	;51CFFFFA
adrCd00889E:
	move.l	(sp)+,d7	;2E1F
	rts	;4E75

adrB_0088A2:
	dc.b	$00	;00
	dc.b	$00	;00

adrL_0088A4:
	move.w	#$0001,_custom+dmacon.l		;33FC000100DFF096
	move.w	#$0080,_custom+intena.l		;33FC008000DFF09A
	move.w	#$0080,_custom+intreq.l		;33FC008000DFF09C
	rte					;4E73
	
PlaySound:
	move.w	d1,-(sp)			;3F01
	move.w	#$0001,_custom+dmacon.l		;33FC000100DFF096
	move.w	#$0080,_custom+intena.l		;33FC008000DFF09A
	asl.w	#$02,d0				;E540
	lea	AudioSample_1.l,a0		;41F900054422
	add.w	AudioSampleOffsets(pc,d0.w),a0		;D0FB005E
	move.w	AudioSampleOffsets+2(pc,d0.w),d0		;303B005C
	lea	$0030(a0),a0			;41E80030
	move.w	-$0002(a0),d1			;3228FFFE
	lsr.w	#$01,d1				;E249
	asl.w	#$02,d0				;E540
	move.l	a0,_custom+aud.l		;23C800DFF0A0
	move.w	d1,_custom+aud0+ac_len.l	;33C100DFF0A4
	move.w	#$0040,_custom+aud0+ac_vol.l	;33FC004000DFF0A8
	move.w	d0,_custom+aud0+ac_per.l	;33C000DFF0A6
	move.w	(a0),_custom+aud0+ac_dat.l	;33D000DFF0AA
	move.w	#$0078,d1			;323C0078
.soundloop1:
	dbra	d1,.soundloop1			;51C9FFFE
	move.w	#$8001,_custom+dmacon.l		;33FC800100DFF096
	move.w	#$0078,d1			;323C0078
.soundloop2:
	dbra	d1,.soundloop2			;51C9FFFE
	move.w	#$0080,_custom+intreq.l		;33FC008000DFF09C
	move.w	#$8080,_custom+intena.l		;33FC808000DFF09A
	move.w	(sp)+,d1			;321F
	rts					;4E75

AudioSampleOffsets:
	dc.w	AudioSample_1-AudioSample_1	;0000

	dc.w	$0028				;0028
	dc.w	AudioSample_1-AudioSample_1	;0000
	dc.w	$009B				;009B
	dc.w	AudioSample_2-AudioSample_1	;0084
	dc.w	$005D				;005D
	dc.w	AudioSample_3-AudioSample_1	;0646
	dc.w	$0028				;0028
	dc.w	AudioSample_4-AudioSample_1	;1ECE
	dc.w	$0049				;0049
	dc.w	AudioSample_5-AudioSample_1	;3684
	dc.w	$0049				;0049

adrW_008950:
	dc.w	AudioSample_1-AudioSample_1	;0000

MouseControl:
	move.w	_custom+joy0dat.l,d0	;303900DFF00A
	move.w	adrW_008950.l,d1	;323900008950
	move.w	d0,adrW_008950.l	;33C000008950
	bsr	adrCd008A0A		;610000A4
	ror.w	#$08,d0			;E058
	ror.w	#$08,d1			;E059
	bsr	adrCd008A0A		;6100009C
	lea	Player1_Data.l,a5	;4BF90000EE7C
	move.w	$0004(a5),d1		;322D0004
	moveq	#$00,d2			;7400
	move.b	d0,d2			;1400
	ext.w	d2			;4882
	add.w	d2,d1			;D242
	bpl.s	adrCd008986		;6A02
	moveq	#$00,d1			;7200
adrCd008986:
	cmp.b	$003B(a5),d1		;B22D003B
	bcc.s	adrCd008990		;6404
	move.b	$003B(a5),d1		;122D003B
adrCd008990:
	cmp.b	$003A(a5),d1		;B22D003A
	bcs.s	adrCd00899A		;6504
	move.b	$003A(a5),d1		;122D003A
adrCd00899A:
	move.w	d1,$0004(a5)		;3B410004
	lsr.w	#$08,d0			;E048
	ext.w	d0			;4880
	move.w	$0002(a5),d1		;322D0002
	add.w	d0,d1			;D240
	bpl.s	adrCd0089AE		;6A04
	add.w	#$0140,d1		;06410140
adrCd0089AE:
	cmpi.w	#$0140,d1		;0C410140
	bcs.s	adrCd0089B8		;6504
	sub.w	#$0140,d1		;04410140
adrCd0089B8:
	move.w	d1,$0002(a5)		;3B410002
	move.l	$0002(a5),d1		;222D0002
	lea	SpritePosition_00.l,a0	;41F900008E84
	bsr	adrCd008A50		;61000088
	lea	SpritePosition_01.l,a0	;41F900008F14
	move.l	#$FF81FFC9,d1		;223CFF81FFC9
	bsr	adrCd008A50		;61000078
	move.b	_ciaa.l,d1		;123900BFE001
	not.b	d1			;4601
	and.w	#$0040,d1		;02410040
	rol.b	#$01,d1			;E319
	lea	adrEA008AFC.l,a0	;41F900008AFC
	tst.b	d1			;4A01
	bpl.s	adrCd0089F6		;6A04
	tst.b	(a0)			;4A10
	bmi.s	adrCd008A08		;6B12
adrCd0089F6:
	move.b	d1,(a0)			;1081
	tst.b	d1			;4A01
	bpl.s	adrCd008A08		;6A0C
	tst.b	$0001(a5)		;4A2D0001
	bmi.s	adrCd008A08		;6B06
	bset	#$07,$0001(a5)		;08ED00070001
adrCd008A08:
	rts				;4E75

adrCd008A0A:
	sub.b	d1,d0			;9001
	bcc.s	adrCd008A14		;6406
	tst.b	d0			;4A00
	bmi.s	adrCd008A1A		;6B08
	bra.s	adrCd008A18		;6004

adrCd008A14:
	tst.b	d0			;4A00
	bpl.s	adrCd008A1A		;6A02
adrCd008A18:
	neg.b	d0			;4400
adrCd008A1A:
	rts	;4E75

InputControls:
	tst.w	MultiPlayer.l	;4A790000EE30
	bne	MouseControl	;6600FF2E
	bsr	JoystickControl	;610000D6
	move.w	(a0),d0	;3010
	lea	Player2_Data.l,a5	;4BF90000EEDE
	bsr	adrCd008A98	;61000064
	lea	SpritePosition_01.l,a0	;41F900008F14
	bsr.s	adrCd008A50	;6112
	lsr.w	#$08,d0	;E048
	lea	Player1_Data.l,a5	;4BF90000EE7C
	bsr	adrCd008A98	;61000050
	lea	SpritePosition_00.l,a0	;41F900008E84
adrCd008A50:
	add.w	#$0037,d1	;06410037
	move.b	d1,(a0)	;1081
	move.b	d1,$0048(a0)	;11410048
	move.w	d1,d2	;3401
	add.w	#$0010,d1	;06410010
	move.b	d1,$0002(a0)	;11410002
	move.b	d1,$004A(a0)	;1141004A
	ror.w	#$07,d1	;EE59
	ror.w	#$06,d2	;EC5A
	and.w	#$0004,d2	;02420004
	and.w	#$0002,d1	;02410002
	or.b	d1,d2	;8401
	swap	d1	;4841
	add.w	#$0080,d1	;06410080
	ror.w	#$01,d1	;E259
	move.b	d1,$0001(a0)	;11410001
	move.b	d1,$0049(a0)	;11410049
	rol.w	#$01,d1	;E359
	and.w	#$0001,d1	;02410001
	or.b	d2,d1	;8202
	move.b	d1,$0003(a0)	;11410003
	move.b	d1,$004B(a0)	;1141004B
	rts	;4E75

adrCd008A98:
	move.l	$0002(a5),d1	;222D0002
	lsr.b	#$01,d0	;E208
	bcc.s	adrCd008AAA	;640A
	subq.w	#$02,d1	;5541
	cmp.b	$003B(a5),d1	;B22D003B
	bcc.s	adrCd008AAA	;6402
	addq.w	#$02,d1	;5441
adrCd008AAA:
	lsr.b	#$01,d0	;E208
	bcc.s	adrCd008AB8	;640A
	addq.w	#$02,d1	;5441
	cmp.b	$003A(a5),d1	;B22D003A
	bcs.s	adrCd008AB8	;6502
	subq.w	#$02,d1	;5541
adrCd008AB8:
	swap	d1	;4841
	lsr.b	#$01,d0	;E208
	bcc.s	adrCd008AC6	;6408
	subq.w	#$02,d1	;5541
	bcc.s	adrCd008AC6	;6404
	add.w	#$0140,d1	;06410140
adrCd008AC6:
	lsr.b	#$01,d0	;E208
	bcc.s	adrCd008ACC	;6402
	addq.w	#$02,d1	;5441
adrCd008ACC:
	cmpi.w	#$0140,d1	;0C410140
	bcs.s	adrCd008AD6	;6504
	sub.w	#$0140,d1	;04410140
adrCd008AD6:
	swap	d1	;4841
	move.l	d1,$0002(a5)	;2B410002
	rts	;4E75

adrCd008ADE:
	move.w	d0,d1	;3200
	ror.w	#$01,d0	;E258
	eor.w	d0,d1	;B141
	moveq	#$00,d2	;7400
	lsr.w	#$01,d0	;E248
	addx.b	d2,d2	;D502
	add.b	d0,d0	;D000
	addx.b	d2,d2	;D502
	lsr.w	#$01,d1	;E249
	addx.b	d2,d2	;D502
	add.b	d1,d1	;D201
	addx.b	d2,d2	;D502
	move.w	d2,d0	;3002
	rts	;4E75

adrEA008AFA:
	dc.w	$0000	;0000
adrEA008AFC:
	dc.w	$0000	;0000

JoystickControl:
	move.w	_custom+joy0dat.l,d0	;303900DFF00A
	bsr.s	adrCd008ADE	;61D8
	move.b	_ciaa.l,d1	;123900BFE001
	not.b	d1	;4601
	and.w	#$0040,d1	;02410040
	rol.b	#$01,d1	;E319
	or.b	d1,d0	;8001
	swap	d0	;4840
	move.w	_custom+joy1dat.l,d0	;303900DFF00C
	bsr.s	adrCd008ADE	;61BE
	move.b	_ciaa.l,d1	;123900BFE001
	not.b	d1	;4601
	and.b	#$80,d1	;02010080
	or.b	d1,d0	;8001
	lea	adrEA008AFA.l,a0	;41F900008AFA
	lea	Player2_Data.l,a5	;4BF90000EEDE
	moveq	#$01,d1	;7201
adrLp008B3C:
	tst.b	$02(a0,d1.w)	;4A301002
	bpl.s	adrCd008B4C	;6A0A
	move.b	d0,$02(a0,d1.w)	;11801002
	and.b	#$7F,d0	;0200007F
	bra.s	adrCd008B50	;6004

adrCd008B4C:
	move.b	d0,$02(a0,d1.w)	;11801002
adrCd008B50:
	move.b	d0,$00(a0,d1.w)	;11801000
	tst.b	d0	;4A00
	bpl.s	adrCd008B64	;6A0C
	tst.b	$0001(a5)	;4A2D0001
	bmi.s	adrCd008B64	;6B06
	bset	#$07,$0001(a5)	;08ED00070001
adrCd008B64:
	lea	Player1_Data.l,a5	;4BF90000EE7C
	swap	d0	;4840
	dbra	d1,adrLp008B3C	;51C9FFCE
	rts	;4E75

adrCd008B72:
	tst.w	Paused_Marker.l	;4A7900008C1C
	bne.s	adrCd008BE8	;666E
	tst.b	$0052(a5)	;4A2D0052
	bmi.s	adrCd008BE0	;6B60
	moveq	#$00,d0	;7000
	move.b	$004B(a5),d0	;102D004B
	bne.s	adrCd008B9A	;6612
	move.b	$0052(a5),d0	;102D0052
	and.w	#$003F,d0	;0240003F
	beq.s	adrCd008BE0	;674E
	move.w	#$90FF,$004A(a5)	;3B7C90FF004A
	bra.s	adrCd008BE0	;6046

adrCd008B9A:
	tst.b	$004A(a5)	;4A2D004A
	bne.s	adrCd008BDC	;663C
	tst.b	d0	;4A00
	bpl.s	adrCd008BAC	;6A08
	cmpi.w	#$00F9,d0	;0C4000F9
	beq.s	adrCd008BE0	;6736
	neg.b	d0	;4400
adrCd008BAC:
	subq.b	#$01,$004B(a5)	;532D004B
	move.b	#$02,$004A(a5)	;1B7C0002004A
	btst	#$00,(a5)	;08150000
	beq.s	adrCd008BC0	;6704
	add.w	#$000C,d0	;0640000C
adrCd008BC0:
	btst	#$06,$0052(a5)	;082D00060052
	beq.s	adrCd008BCA	;6702
	addq.w	#$06,d0	;5C40
adrCd008BCA:
	add.w	d0,d0	;D040
	move.w	adrCd008BE8(pc,d0.w),d0	;303B001A
;fiX Data reference expected
	move.w	d0,_custom+color+$0000001E.l	;33C000DFF19E
	move.w	d0,$004C(a5)	;3B40004C
	rts	;4E75

adrCd008BDC:
	subq.b	#$01,$004A(a5)	;532D004A
adrCd008BE0:
	move.w	$004C(a5),_custom+color+$0000001E.l	;33ED004C00DFF19E
adrCd008BE8:
	rts	;4E75

;fiX Label expected
	dc.w	$00C0	;00C0
	dc.w	$0080	;0080
	dc.w	$0060	;0060
	dc.w	$0040	;0040
	dc.w	$0020	;0020
	dc.w	$0000	;0000
	dc.w	$0C00	;0C00
	dc.w	$0800	;0800
	dc.w	$0600	;0600
	dc.w	$0400	;0400
	dc.w	$0200	;0200
	dc.w	$0000	;0000
	dc.w	$0E80	;0E80
	dc.w	$0A60	;0A60
	dc.w	$0640	;0640
	dc.w	$0420	;0420
	dc.w	$0200	;0200
	dc.w	$0000	;0000
	dc.w	$0C00	;0C00
	dc.w	$0800	;0800
	dc.w	$0600	;0600
	dc.w	$0400	;0400
	dc.w	$0200	;0200
	dc.w	$0000	;0000
VBI_Marker:
	dc.w	$0000	;0000
Paused_Marker:
	dc.w	$0000	;0000
adrB_008C1E:
	dc.b	$00	;00
adrB_008C1F:
	dc.b	$FF	;FF

VerticalBlankInterupt:
	move.w	d0,-(sp)	;3F00
	move.w	_custom+intreqr.l,d0	;303900DFF01E
	and.w	#$0020,d0	;02400020
	beq.s	adrCd008C40	;6712
	move.w	(sp)+,d0	;301F
	move.w	#$0020,_custom+intreq.l	;33FC002000DFF09C
	clr.w	VBI_Marker.l	;427900008C1A
	rte	;4E73

adrCd008C40:
	move.w	(sp)+,d0	;301F
	eor.w	#$0001,VBI_Marker.l	;0A79000100008C1A
	beq.s	adrCd008C62	;6716
	movem.l	d0/a5,-(sp)	;48E78004
	lea	Player2_Data.l,a5	;4BF90000EEDE
	bsr	adrCd008B72	;6100FF1A
	movem.l	(sp)+,d0/a5	;4CDF2001
	bra	adrCd008CC0	;60000060

adrCd008C62:
	movem.l	d0-d7/a0-a6,-(sp)	;48E7FFFE
	subq.w	#$01,adrW_00EE9E.l	;53790000EE9E
	bcc.s	adrCd008C74	;6406
	clr.w	adrW_00EE9E.l	;42790000EE9E
adrCd008C74:
	subq.w	#$01,adrW_00EF00.l	;53790000EF00
	bcc.s	adrCd008C82	;6406
	clr.w	adrW_00EF00.l	;42790000EF00
adrCd008C82:
	lea	adrEA00EE36.l,a0	;41F90000EE36
	moveq	#$02,d0	;7002
adrLp008C8A:
	subq.w	#$01,(a0)+	;5358
	bcc.s	adrCd008C92	;6404
	clr.w	-$0002(a0)	;4268FFFE
adrCd008C92:
	dbra	d0,adrLp008C8A	;51C8FFF6
	lea	Player1_Data.l,a5	;4BF90000EE7C
	bsr	adrCd008B72	;6100FED4
	tst.b	adrB_008C1F.l	;4A3900008C1F
	beq.s	adrCd008CBC	;6714
	bsr	InputControls	;6100FD72
	tst.b	adrB_008C1E.l	;4A3900008C1E
	beq.s	adrCd008CBC	;6708
	clr.b	adrB_008C1E.l	;423900008C1E
	bsr.s	adrCd008CCA	;610E
adrCd008CBC:
	movem.l	(sp)+,d0-d7/a0-a6	;4CDF7FFF
adrCd008CC0:
	move.w	#$0010,_custom+intreq.l	;33FC001000DFF09C
adrL_008CC8:
	rte	;4E73

adrCd008CCA:
	cmp.l	#$00060000,screen_ptr.l	;0CB90006000000008D36
	bne.s	adrCd008CEC	;6616
	move.l	#$00067D00,screen_ptr.l	;23FC00067D0000008D36
	move.l	#$00060000,framebuffer_ptr.l	;23FC0006000000008D3A
	bra.s	adrCd008D00	;6014

adrCd008CEC:
	move.l	#$00060000,screen_ptr.l	;23FC0006000000008D36
	move.l	#$00067D00,framebuffer_ptr.l	;23FC00067D0000008D3A
adrCd008D00:
	lea	CopperList_00.l,a0	;41F900008E10
	move.l	#$00060000,d0	;203C00060000
	cmp.l	screen_ptr.l,d0	;B0B900008D36
	bne.s	adrCd008D1A	;6606
	move.l	#$00067D00,d0	;203C00067D00
adrCd008D1A:
	moveq	#$03,d1	;7203
adrLp008D1C:
	move.w	d0,$0006(a0)	;31400006
	swap	d0	;4840
	move.w	d0,$0002(a0)	;31400002
	swap	d0	;4840
	add.l	#$00001F40,d0	;068000001F40	;Long Addr replaced with Symbol
	addq.w	#$08,a0	;5048
	dbra	d1,adrLp008D1C	;51C9FFEA
	rts	;4E75

screen_ptr:
	dc.l	$00060000	;00060000
framebuffer_ptr:
	dc.l	$00067D00	;00067D00

adrLp008D3E:
	swap	d5	;4845
	move.w	d5,d4	;3805
adrLp008D42:
	move.w	(a0),d2	;3410
	or.w	$1F40(a0),d2	;84681F40
	or.w	$3E80(a0),d2	;84683E80
	or.w	$5DC0(a0),d2	;84685DC0
	not.w	d2	;4642
	move.l	(a1)+,d0	;2019
	move.l	(a1)+,d1	;2219
	and.w	d2,d1	;C242
	or.w	d1,$5DC0(a0)	;83685DC0
	swap	d1	;4841
	and.w	d2,d1	;C242
	or.w	d1,$3E80(a0)	;83683E80
	and.w	d2,d0	;C042
	or.w	d0,$1F40(a0)	;81681F40
	swap	d0	;4840
	and.w	d2,d0	;C042
	or.w	d0,(a0)+	;8158
	dbra	d4,adrLp008D42	;51CCFFD0
	sub.w	d5,a0	;90C5
	sub.w	d5,a0	;90C5
	lea	$0026(a0),a0	;41E80026
	lea	$0070(a1),a1	;43E90070
	swap	d5	;4845
	dbra	d5,adrLp008D3E	;51CDFFBA
	rts	;4E75

adrCd008D88:
	move.l	screen_ptr.l,a1	;227900008D36
	move.l	framebuffer_ptr.l,a0	;207900008D3A
	move.w	#$1F3F,d0	;303C1F3F
adrLp008D98:
	move.l	(a0)+,(a1)+	;22D8
	dbra	d0,adrLp008D98	;51C8FFFC
	rts	;4E75

adrCd008DA0:
	move.l	framebuffer_ptr.l,a0	;207900008D3A
	bra.s	adrCd008DAE	;6006

adrCd008DA8:
	move.l	screen_ptr.l,a0	;207900008D36
adrCd008DAE:
	move.w	#$1F3F,d0	;303C1F3F
adrLp008DB2:
	clr.l	(a0)+	;4298
	dbra	d0,adrLp008DB2	;51C8FFFC
	rts	;4E75

adrCd008DBA:
	lea	_custom+color.l,a1	;43F900DFF180
	lea	GamePalette.l,a0	;41F900008DD0
	moveq	#$1F,d0	;701F
adrLp008DC8:
	move.w	(a0)+,(a1)+	;32D8
	dbra	d0,adrLp008DC8	;51C8FFFC
	rts	;4E75

GamePalette:
	dc.w	$0000	;0000
	dc.w	$0444	;0444
	dc.w	$0666	;0666
	dc.w	$0888	;0888
	dc.w	$0AAA	;0AAA
	dc.w	$0292	;0292
	dc.w	$01C1	;01C1
	dc.w	$000E	;000E
	dc.w	$048E	;048E
	dc.w	$0821	;0821
	dc.w	$0B31	;0B31
	dc.w	$0E96	;0E96
	dc.w	$0D00	;0D00
	dc.w	$0FD0	;0FD0
	dc.w	$0EEE	;0EEE
	dc.w	$0C08	;0C08
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$022E	;022E
	dc.w	$048E	;048E
	dc.w	$0EEE	;0EEE
	dc.w	$0000	;0000
	dc.w	$0E00	;0E00
	dc.w	$0E83	;0E83
	dc.w	$0EEE	;0EEE
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
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
SpritePosition_00:
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
adrEA008EC8:
	dc.w	$0000	;0000
	dc.w	$0000	;0000
SpritePosition_04:
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
SpritePosition_01:
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
SpritePosition_02:
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

adrCd008FA4:
	move.l	#$007F0060,d4	;283C007F0060
	move.l	#$004B000C,d5	;2A3C004B000C
	add.w	$0008(a5),d5	;DA6D0008
	bra	BW_draw_bar	;60004AB2

adrCd008FB8:
	btst	#$06,$0018(a5)	;082D00060018
	bne.s	adrCd009036	;6676
	btst	#$02,(a5)	;08150002
	bne.s	adrCd009036	;6670
	move.b	$003D(a5),d3	;162D003D
	bpl.s	adrCd008FA4	;6AD8
	move.b	$0053(a5),d0	;102D0053
	bmi.s	adrCd009042	;6B70
	bsr	adrCd006660	;6100D68C
	link	a3,#-$0020	;4E53FFE0
	moveq	#$00,d0	;7000
	move.b	$0016(a4),d0	;102C0016
	move.w	d0,-$0004(a3)	;3740FFFC
	move.b	$0017(a4),d0	;102C0017
	move.w	d0,-$0002(a3)	;3740FFFE
	move.b	$0018(a4),d0	;102C0018
	and.w	#$0003,d0	;02400003
	move.w	d0,-$000A(a3)	;3740FFF6
	bsr.s	adrCd009000	;6106
	move.b	$001A(a4),d0	;102C001A
	bra.s	adrCd00905C	;605C

adrCd009000:
	moveq	#$00,d1	;7200
	move.b	$0011(a4),d0	;102C0011
	and.w	#$0007,d0	;02400007
	subq.b	#$07,d0	;5F00
	beq.s	adrCd009038	;672A
	move.l	a4,d0	;200C
	sub.l	#CharacterStats,d0	;04800000EB2A
	lsr.w	#$05,d0	;EA48
	move.w	d0,d2	;3400
	and.w	#$0003,d2	;02420003
	cmpi.b	#$03,d2	;0C020003
	bne.s	adrCd009036	;6612
	bsr	RandomGen_BytewithOffset	;6100C586
	move.b	(a4),d2	;1414
	asl.b	#$04,d2	;E902
	moveq	#$00,d1	;7200
	cmp.b	d0,d2	;B400
	bcs.s	adrCd009036	;6504
	move.b	(a4),d1	;1214
	add.w	d1,d1	;D241
adrCd009036:
	rts	;4E75

adrCd009038:
	move.b	$0011(a4),d1	;122C0011
	lsr.b	#$03,d1	;E609
	addq.w	#$01,d1	;5241
	rts	;4E75

adrCd009042:
	link	a3,#-$0020	;4E53FFE0
	move.l	$001C(a5),-$0004(a3)	;276D001CFFFC
	move.w	$0020(a5),-$000A(a3)	;376D0020FFF6
	bsr	adrCd00665C	;6100D608
	bsr.s	adrCd009000	;61A8
	move.w	$0058(a5),d0	;302D0058
adrCd00905C:
	move.w	d0,-$001E(a3)	;3740FFE2
	move.b	d1,-$001F(a3)	;1741FFE1
	bsr	adrCd0084DA	;6100F474
	move.l	-$0004(a3),d7	;2E2BFFFC
	bsr	CoordToMap	;6100F42E
	btst	#$05,$01(a6,d0.w)	;083600050001
	beq.s	adrCd0090D4	;675C
	bsr	adrCd005F4E	;6100CED4
	move.w	$0002(a0),d1	;32280002
	move.w	d1,d0	;3001
	and.w	#$0003,d1	;02410003
	cmpi.w	#$0002,d1	;0C410002
	bcc.s	adrCd0090D4	;6448
	and.w	#$00FC,d0	;024000FC
	cmpi.w	#$002C,d0	;0C40002C
	bcc.s	adrCd00909C	;6406
	cmpi.w	#$0020,d0	;0C400020
	bcc.s	adrCd0090D4	;6438
adrCd00909C:
	lsr.w	#$01,d0	;E248
	add.w	d0,d1	;D240
	move.b	adrB_0090AC(pc,d1.w),$003D(a5)	;1B7B100A003D
	unlk	a3	;4E5B
	bra	adrCd008FB8	;6000FF0E

adrB_0090AC:
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

adrCd0090D4:
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$01EC,a0	;D0FC01EC
	add.w	$000A(a5),a0	;D0ED000A
	move.l	a0,-$0008(a3)	;2748FFF8
	move.w	-$0004(a3),d0	;302BFFFC
	add.w	-$0002(a3),d0	;D06BFFFE
	add.w	-$000A(a3),d0	;D06BFFF6
	and.w	#$0001,d0	;02400001
	move.w	d0,-$000C(a3)	;3740FFF4
	bsr	adrCd00B7F4	;610026F8
	move.w	-$000A(a3),d0	;302BFFF6
	move.w	d0,d1	;3200
	ror.b	#$03,d0	;E618
	add.w	d1,d1	;D241
	add.w	d1,d0	;D041
	add.w	d1,d1	;D241
	add.w	d1,d0	;D041
	lea	adrEA00B8AE.l,a0	;41F90000B8AE
	add.w	d0,a0	;D0C0
	move.l	a0,-$0010(a3)	;2748FFF0
	move.l	adrW_00EE70.l,d1	;22390000EE70
	move.w	d1,d2	;3401
	swap	d1	;4841
	move.l	-$0004(a3),d3	;262BFFFC
	move.l	adrL_00EE78.l,a6	;2C790000EE78
	moveq	#$00,d6	;7C00
adrCd009130:
	lsr.l	#$01,d5	;E28D
	lsr.l	#$01,d4	;E28C
	move.l	d3,d7	;2E03
	add.b	$0001(a0),d7	;DE280001
	cmp.w	d2,d7	;BE42
	bcc	adrCd0091C0	;64000082
	swap	d7	;4847
	add.b	(a0),d7	;DE10
	cmp.w	d1,d7	;BE41
	bcc.s	adrCd0091C0		;6478
	swap	d7			;4847
	bsr	adrCd0084A2		;6100F356
	move.w	$00(a6,d0.w),d0		;30360000
	tst.b	d0			;4A00
	beq.s	adrCd0091C4		;676E
	and.b	#$07,d0			;02000007
	beq.s	adrCd0091BC		;6760
	cmpi.b	#$01,d0			;0C000001
	beq.s	adrCd0091C0		;675E
	cmpi.b	#$07,d0			;0C000007
	bne.s	adrCd00917E		;6616
	lsr.w	#$08,d0			;E048
	and.w	#$0003,d0		;02400003
	cmpi.b	#$02,d0			;0C000002
	bcs.s	adrCd0091BC		;6548
	bne.s	adrCd0091C0		;664A
	tst.b	-$001F(a3)		;4A2BFFE1
	beq.s	adrCd0091C0		;6744
	bra.s	adrCd0091BC		;603E

adrCd00917E:
	cmpi.b	#$02,d0			;0C000002
	bne.s	adrCd0091BC		;6638
	move.w	-$000A(a3),d7		;3E2BFFF6
	cmpi.w	#$0012,d6		;0C460012
	beq.s	adrCd009194		;6706
	addq.w	#$02,d7			;5447	
	and.w	#$0003,d7		;02470003
adrCd009194:
	add.w	d7,d7	;DE47
	addq.w	#$08,d7	;5047
	btst	d7,d0	;0F00
	beq.s	adrCd0091BC	;6720
	cmpi.w	#$000E,d6	;0C46000E
	bcc.s	adrCd0091C0	;641E
	move.w	-$000A(a3),d7	;3E2BFFF6
	addq.w	#$01,d7	;5247
	cmpi.w	#$0007,d6	;0C460007
	bcs.s	adrCd0091B0	;6502
	addq.w	#$02,d7	;5447
adrCd0091B0:
	and.w	#$0003,d7	;02470003
	add.w	d7,d7	;DE47
	addq.w	#$08,d7	;5047
	btst	d7,d0	;0F00
	bne.s	adrCd0091C0	;6604
adrCd0091BC:
	bset	#$1F,d4	;08C4001F
adrCd0091C0:
	bset	#$1F,d5	;08C5001F
adrCd0091C4:
	addq.w	#$02,a0	;5448
	addq.w	#$01,d6	;5246
	cmpi.w	#$0013,d6	;0C460013
	bcs	adrCd009130	;6500FF62
	rol.l	#$03,d5	;E79D
	swap	d5	;4845
	rol.l	#$03,d4	;E79C
	swap	d4	;4844
	lea	adrEA00B9DA.l,a6	;4DF90000B9DA
	lea	adrEA00B98E.l,a4	;49F90000B98E
	moveq	#$00,d7	;7E00
	moveq	#-$01,d0	;70FF
	moveq	#$12,d6	;7C12
adrLp0091EA:
	btst	d6,d5	;0D05
	beq.s	adrCd0091F6	;6708
	or.l	(a6),d7	;8E96
	btst	d6,d4	;0D04
	bne.s	adrCd0091F6	;6602
	and.l	(a4),d0	;C094
adrCd0091F6:
	subq.w	#$04,a6	;594E
	subq.w	#$04,a4	;594C
	dbra	d6,adrLp0091EA	;51CEFFEE
	and.l	d0,d7	;CE80
	moveq	#$00,d6	;7C00
adrCd009202:
	btst	d6,d5	;0D05
	beq.s	adrCd009212	;670C
	movem.l	d5-d7,-(sp)	;48E70700
	bsr	adrCd00921E	;61000012
	movem.l	(sp)+,d5-d7	;4CDF00E0
adrCd009212:
	addq.w	#$01,d6	;5246
	cmpi.b	#$13,d6	;0C060013
	bcs.s	adrCd009202	;65E8
	unlk	a3	;4E5B
	rts	;4E75

adrCd00921E:
	move.b	d6,-$0016(a3)	;1746FFEA
	move.l	-$0010(a3),a0	;206BFFF0
	add.w	d6,d6	;DC46
	add.w	d6,a0	;D0C6
	moveq	#$01,d1	;7201
	move.l	-$0004(a3),d5	;2A2BFFFC
	swap	d5	;4845
	add.b	(a0)+,d5	;DA18
	move.b	d5,-$0019(a3)	;1745FFE7
	cmp.w	adrW_00EE70.l,d5	;BA790000EE70
	beq.s	adrCd00926C	;672C
	bcs.s	adrCd009248	;6506
	addq.b	#$01,d5	;5205
	beq.s	adrCd00926C	;6726
	rts	;4E75

adrCd009248:
	swap	d5	;4845
	add.b	(a0),d5	;DA10
	move.b	d5,-$001A(a3)	;1745FFE6
	cmp.w	adrW_00EE72.l,d5	;BA790000EE72
	beq.s	adrCd00926C	;6714
	bcs.s	adrCd009260	;6506
	addq.b	#$01,d5	;5205
	beq.s	adrCd00926C	;670E
	rts	;4E75

adrCd009260:
	exg	d5,d7	;CB47
	bsr	CoordToMap	;6100F238
	exg	d5,d7	;CB47
	move.w	$00(a6,d0.w),d1	;32360000
adrCd00926C:
	clr.b	-$0013(a3)	;422BFFED
	move.w	d1,-$0012(a3)	;3741FFEE
	btst	#$06,d1	;08010006
	beq.s	adrCd009286	;670C
	movem.l	d0/d1/d6/d7,-(sp)	;48E7C300
	bsr	adrCd00960A	;6100038A
	movem.l	(sp)+,d0/d1/d6/d7	;4CDF00C3
adrCd009286:
	btst	#$05,d1	;08010005
	beq	adrCd009378	;670000EC
	move.w	d1,d2	;3401
	and.w	#$0007,d2	;02420007
	subq.w	#$01,d2	;5342
	beq	adrCd009378	;670000E0
	move.w	d0,-(sp)	;3F00
	bsr	adrCd009378	;610000DA
	move.w	(sp)+,d0	;301F
	bsr	adrCd005F4E	;6100CCAA
	move.w	$0002(a0),d1	;32280002
	move.w	d1,d2	;3401
	and.w	#$0003,d2	;02420003
	cmpi.w	#$0002,d2	;0C420002
	bne	adrCd0092E8	;66000032
	lsr.b	#$02,d1	;E409
	add.w	#$0080,d1	;06410080
	move.b	d1,-$0017(a3)	;1741FFE9
	moveq	#$04,d1	;7204
	cmp.b	#$12,-$0016(a3)	;0C2B0012FFEA
	bne	adrCd00A6EC	;66001420
	subq.b	#$01,-$0016(a3)	;532BFFEA
	move.l	-$0004(a3),d7	;2E2BFFFC
	move.w	-$000A(a3),d0	;302BFFF6
	bsr	adrCd008486	;6100F1AA
	tst.b	$01(a6,d0.w)	;4A360001
	bmi	adrCd00A6EC	;6B001408
	rts	;4E75

adrCd0092E8:
	and.w	#$00FC,d1	;024100FC
	cmpi.w	#$001C,d1	;0C41001C
	bcc.s	adrCd009358	;6466
	move.w	d1,-(sp)	;3F01
	bsr	adrCd00995C	;61000666
	move.w	(sp)+,d0	;301F
	addq.b	#$01,d1	;5201
	beq.s	adrCd009358	;675A
	subq.b	#$01,d1	;5301
	move.b	adrB_00935A(pc,d1.w),d1	;123B1058
	add.w	d1,d1	;D241
	lea	_GFX_AirbourneSpells.l,a1	;43F900034A30
	add.w	adrW_009360(pc,d1.w),a1	;D2FB1052
	add.w	d1,d1	;D241
	add.b	adrB_009368(pc,d1.w),d4	;D83B1054
	add.b	adrB_009369(pc,d1.w),d5	;DA3B1051
	moveq	#$00,d7	;7E00
	move.b	adrB_00936A(pc,d1.w),d7	;1E3B104C
	swap	d7	;4847
	move.b	adrB_00936B(pc,d1.w),d7	;1E3B1047
	add.w	$0008(a5),d5	;DA6D0008
	move.b	d4,d6	;1C04
	add.b	#$60,d4	;06040060
	ext.w	d6	;4886
	asr.w	#$04,d6	;E846
	move.w	#$FFFF,adrW_00B4BE.l	;33FCFFFF0000B4BE
	lea	SpellStars_Colours.l,a0	;41F900009B70
	move.l	$00(a0,d0.w),adrEA00B4C0.l	;23F000000000B4C0
	move.l	a3,-(sp)	;2F0B
	bsr	adrCd00AE5E	;61001B10
	move.l	(sp)+,a3	;265F
	clr.w	adrW_00B4BE.l	;42790000B4BE
adrCd009358:
	rts	;4E75

adrB_00935A:
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$03	;03
adrW_009360:
	dc.w	$0000	;0000
	dc.w	$0318	;0318
	dc.w	$0438	;0438
	dc.w	$0498	;0498
adrB_009368:
	dc.b	$F4	;F4
adrB_009369:
	dc.b	$F7	;F7
adrB_00936A:
	dc.b	$02	;02
adrB_00936B:
	dc.b	$20	;20
	dc.b	$FA	;FA
	dc.b	$FD	;FD
	dc.b	$01	;01
	dc.b	$11	;11
	dc.b	$FE	;FE
	dc.b	$0D	;0D
	dc.b	$00	;00
	dc.b	$0B	;0B
	dc.b	$00	;00
	dc.b	$0D	;0D
	dc.b	$00	;00
	dc.b	$08	;08

adrCd009378:
	and.w	#$0007,d1	;02410007
	bne.s	adrCd009388	;660A
	tst.b	-$0011(a3)	;4A2BFFEF
	bmi	adrCd0099F0	;6B00066C
	rts	;4E75

adrCd009388:
	lea	adrEA00B9F2.l,a6	;4DF90000B9F2
	add.w	d6,d6	;DC46
	add.w	d6,a6	;DCC6
	moveq	#$03,d5	;7A03
	subq.b	#$01,d1	;5301
	beq.s	adrLp0093C2	;672A
	subq.b	#$01,d1	;5301
	beq.s	adrCd0093BC	;6720
	subq.b	#$01,d1	;5301
	beq	adrCd00956A	;670001CA
	cmpi.b	#$03,d1	;0C010003
	beq	adrCd0094DC	;67000134
	cmpi.b	#$04,d1	;0C010004
	beq	adrCd009496	;670000E6
	move.b	d1,-$0013(a3)	;1741FFED
	addq.w	#$02,a6	;544E
	moveq	#$01,d5	;7A01
	bra.s	adrLp0093C2	;6006

adrCd0093BC:
	move.b	#$FF,-$0013(a3)	;177C00FFFFED
adrLp0093C2:
	moveq	#$00,d6	;7C00
	move.b	(a6)+,d6	;1C1E
	bmi.s	adrCd00943A	;6B72
	btst	d6,d7	;0D07
	beq.s	adrCd00943A	;676E
	clr.b	-$0014(a3)	;422BFFEC
	clr.b	-$0015(a3)	;422BFFEB
	bsr	adrCd0095D4	;610001FE
	tst.b	-$0013(a3)	;4A2BFFED
	bmi.s	adrCd0093E4	;6B06
	beq.s	adrCd009440	;6760
	bra	adrCd009482	;600000A0

adrCd0093E4:
	cmpi.w	#$0002,d5	;0C450002
	bcc.s	adrCd009412	;6428
	tst.w	d5	;4A45
	beq.s	adrCd0093F8	;670A
	cmp.b	#$0E,-$0016(a3)	;0C2B000EFFEA
	bcc.s	adrCd009412	;641C
	bra.s	adrCd009400	;6008

adrCd0093F8:
	cmp.b	#$0E,-$0016(a3)	;0C2B000EFFEA
	bcs.s	adrCd009412	;6512
adrCd009400:
	tst.b	-$0011(a3)	;4A2BFFEF
	bpl.s	adrCd009412	;6A0C
	movem.l	d1/d5-d7/a6,-(sp)	;48E74702
	bsr	adrCd0099F0	;610005E4
	movem.l	(sp)+,d1/d5-d7/a6	;4CDF40E2
adrCd009412:
	add.w	d1,d1	;D241
	move.b	-$0012(a3),d0	;102BFFEE
	lsr.w	d1,d0	;E268
	and.w	#$0003,d0	;02400003
	beq.s	adrCd00943A	;671A
	subq.w	#$01,d0	;5340
	beq.s	adrCd00942E	;670A
	move.b	d0,-$0014(a3)	;1740FFEC
	subq.w	#$01,d0	;5340
	move.b	d0,-$0015(a3)	;1740FFEB
adrCd00942E:
	movem.l	d5/a6,-(sp)	;48E70402
	bsr	adrCd00B3D8	;61001FA4
	movem.l	(sp)+,d5/a6	;4CDF4020
adrCd00943A:
	dbra	d5,adrLp0093C2	;51CDFF86
	rts	;4E75

adrCd009440:
	move.b	-$0011(a3),d0	;102BFFEF
	bpl.s	adrCd009474	;6A2E
	lsr.b	#$04,d0	;E808
	and.w	#$0003,d0	;02400003
	cmp.b	d0,d1	;B200
	bne.s	adrCd009474	;6624
	move.b	-$0012(a3),d0	;102BFFEE
	move.b	#$FF,-$0015(a3)	;177C00FFFFEB
	and.w	#$0003,d0	;02400003
	beq.s	adrCd009474	;6714
	subq.b	#$01,-$0015(a3)	;532BFFEB
	subq.w	#$01,d0	;5340
	beq.s	adrCd009474	;670C
	subq.b	#$01,-$0015(a3)	;532BFFEB
	subq.w	#$01,d0	;5340
	beq.s	adrCd009474	;6704
	subq.b	#$01,-$0015(a3)	;532BFFEB
adrCd009474:
	movem.l	d5/a6,-(sp)	;48E70402
	bsr	adrCd00B074	;61001BFA
	movem.l	(sp)+,d5/a6	;4CDF4020
	bra.s	adrCd00943A	;60B8

adrCd009482:
	bsr	adrCd0099DC	;61000558
	bmi	adrCd00B2DE	;6B001E56
	btst	d1,d7	;0307
	beq	adrCd00B2DE	;67001E50
	move.w	d1,d6	;3C01
	bra	adrCd00B2DE	;60001E4A

adrCd009496:
	move.b	-$0012(a3),d1	;122BFFEE
	and.w	#$0003,d1	;02410003
	beq.s	adrCd0094B2	;6712
	cmpi.w	#$0001,d1	;0C410001
	beq.s	adrCd0094BC	;6716
	cmpi.b	#$03,d1	;0C010003
	beq.s	adrCd0094B4	;6708
	tst.b	-$001F(a3)	;4A2BFFE1
	beq.s	adrCd0094B4	;6702
adrCd0094B2:
	rts	;4E75

adrCd0094B4:
	lsr.w	#$01,d6	;E24E
	moveq	#$01,d1	;7201
	bra	adrCd00926C	;6000FDB2

adrCd0094BC:
	bsr	RandomGen_BytewithOffset	;6100C0EE
	and.w	#$0004,d0	;02400004
	move.l	adrL_0094D4(pc,d0.w),adrEA00B4C0.l	;23FB000E0000B4C0
	move.b	#$02,-$0012(a3)	;177C0002FFEE
	bra.s	adrCd0094E6	;6012

adrL_0094D4:
	dc.l	$090C0B0D	;090C0B0D
	dc.l	$090A0B0D	;090A0B0D

adrCd0094DC:
	move.l	#$01050406,adrEA00B4C0.l	;23FC010504060000B4C0
adrCd0094E6:
	bsr	adrCd0099DC	;610004F4
	cmpi.w	#$0012,d0	;0C400012
	beq.s	adrCd0094F8	;6708
	tst.b	d1	;4A01
	bmi.s	adrCd009568	;6B74
	btst	d1,d7	;0307
	beq.s	adrCd009568	;6770
adrCd0094F8:
	move.b	-$0012(a3),d1	;122BFFEE
	move.w	d0,d6	;3C00
	btst	#$02,d1	;08010002
	beq.s	adrCd009522	;671E
	movem.l	d1/d6,-(sp)	;48E74200
	lea	_GFX_Pad.l,a1	;43F900031F68
	lea	adrEA00BF62.l,a2	;45F90000BF62
	lea	adrEA018C66.l,a0	;41F900018C66
	bsr	adrCd0095B4	;61000098
	movem.l	(sp)+,d1/d6	;4CDF0042
adrCd009522:
	lea	adrEA018C4E.l,a0	;41F900018C4E
	lea	adrEA00BF16.l,a2	;45F90000BF16
	lea	_GFX_PitLow.l,a1	;43F900031AD8
	and.w	#$0003,d1	;02410003
	beq.s	adrCd009560	;6726
	cmpi.w	#$0003,d1	;0C410003
	beq.s	adrCd009560	;6720
	btst	#$00,d1	;08010000
	bne.s	adrCd00955E	;6618
	lea	_GFX_PitHigh.l,a1	;43F900031D20
	move.w	#$FFFF,adrW_00B4BE.l	;33FCFFFF0000B4BE
	bsr.s	adrCd0095B4	;615E
	clr.w	adrW_00B4BE.l	;42790000B4BE
	bra.s	adrCd009560	;6002

adrCd00955E:
	bsr.s	adrCd0095B4	;6154
adrCd009560:
	tst.b	-$0011(a3)	;4A2BFFEF
	bmi	adrCd0099F0	;6B00048A
adrCd009568:
	rts	;4E75

adrCd00956A:
	bsr	adrCd0099DC	;61000470
	bmi.s	adrCd00959E	;6B2E
	btst	d1,d7	;0307
	beq.s	adrCd00959E	;672A
	cmp.b	#$01,-$0012(a3)	;0C2B0001FFEE
	beq.s	adrCd0095A0	;6724
	lea	adrEA018B2C.l,a0	;41F900018B2C
	lea	adrEA00BC9E.l,a2	;45F90000BC9E
	lea	_GFX_Bed.l,a1	;43F900028C28
	move.w	d0,d6	;3C00
adrCd009590:
	bsr	adrCd00B486	;61001EF4
	swap	d3	;4843
	move.l	a3,-(sp)	;2F0B
	bsr	adrCd00B5CA	;61002030
	move.l	(sp)+,a3	;265F
adrCd00959E:
	rts	;4E75

adrCd0095A0:
	lea	adrEA018B16.l,a0	;41F900018B16
	lea	adrEA00BC06.l,a2	;45F90000BC06
	lea	_GFX_Pillar.l,a1	;43F9000296A0
	move.w	d0,d6	;3C00
adrCd0095B4:
	moveq	#$00,d0	;7000
	move.b	adrB_0095C0(pc,d6.w),d0	;103B6008
	bpl.s	adrCd009590	;6AD4
	bra	adrCd00B42E	;60001E70

adrB_0095C0:
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$05	;05
	dc.b	$06	;06
	dc.b	$80	;80
	dc.b	$81	;81
	dc.b	$82	;82
	dc.b	$83	;83
	dc.b	$84	;84
	dc.b	$85	;85
	dc.b	$86	;86
	dc.b	$07	;07
	dc.b	$08	;08
	dc.b	$09	;09
	dc.b	$0A	;0A
	dc.b	$0B	;0B
	dc.b	$0C	;0C

adrCd0095D4:
	move.w	d5,d1	;3205
	cmp.b	#$07,-$0016(a3)	;0C2B0007FFEA
	bcc.s	adrCd0095EA	;640C
	btst	#$00,d1	;08010000
	bne.s	adrCd0095FC	;6618
	eor.w	#$0001,d1	;0A410001
	bra.s	adrCd009600	;6016

adrCd0095EA:
	cmp.b	#$0E,-$0016(a3)	;0C2B000EFFEA
	bcs.s	adrCd0095FC	;650A
	btst	#$01,d1	;08010001
	bne.s	adrCd0095FC	;6604
	eor.w	#$0001,d1	;0A410001
adrCd0095FC:
	eor.w	#$0003,d1	;0A410003
adrCd009600:
	add.w	-$000A(a3),d1	;D26BFFF6
	and.w	#$0003,d1	;02410003
	rts	;4E75

adrCd00960A:
	tst.b	-$001F(a3)	;4A2BFFE1
	bne.s	adrCd00961A	;660A
	btst	#$03,$01(a6,d0.w)	;083600030001
	beq.s	adrCd00961A	;6702
	rts	;4E75

adrCd00961A:
	move.w	d1,d2	;3401
	and.w	#$0007,d2	;02420007
	cmpi.w	#$0006,d2	;0C420006
	beq.s	adrCd00963A	;6714
	subq.w	#$01,d2	;5342
	bne.s	adrCd009648	;661E
	lsr.w	#$04,d1	;E849
	and.w	#$0003,d1	;02410003
	eor.w	#$0002,d1	;0A410002
	cmp.w	-$000A(a3),d1	;B26BFFF6
	bne.s	adrCd009680	;6646
adrCd00963A:
	addq.w	#$04,sp	;584F
	movem.l	(sp),d0/d1/d6/d7	;4CD700C3
	bsr	adrCd009286	;6100FC44
	movem.l	(sp)+,d0/d1/d6/d7	;4CDF00C3
adrCd009648:
	moveq	#$00,d1	;7200
adrCd00964A:
	move.w	d1,-(sp)	;3F01
	move.w	d1,d6	;3C01
	bsr	adrCd005F2E	;6100C8DE
	bsr	adrCd005F5C	;6100C908
	bne.s	adrCd009676	;661E
	rol.b	#$02,d6	;E51E
	lea	$02(a0,d7.w),a0	;41F07002
	moveq	#$00,d7	;7E00
	move.b	(a0)+,d7	;1E18
adrLp009662:
	movem.l	d0/d6/d7/a0/a3,-(sp)	;48E78390
	moveq	#$00,d2	;7400
	move.b	(a0),d2	;1410
	bsr.s	adrCd0096BE	;6152
	movem.l	(sp)+,d0/d6/d7/a0/a3	;4CDF09C1
	addq.w	#$02,a0	;5448
	dbra	d7,adrLp009662	;51CFFFEE
adrCd009676:
	move.w	(sp)+,d1	;321F
	addq.w	#$01,d1	;5241
	cmpi.w	#$0004,d1	;0C410004
	bcs.s	adrCd00964A	;65CA
adrCd009680:
	rts	;4E75

adrB_009682:
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$02	;02
	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$01	;01
	dc.b	$03	;03
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$02	;02
adrB_009692:
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$00	;00
adrB_009696:
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$06	;06
	dc.b	$04	;04
	dc.b	$02	;02
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$06	;06
	dc.b	$04	;04
	dc.b	$02	;02
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$06	;06
	dc.b	$04	;04
	dc.b	$02	;02
	dc.b	$00	;00
adrB_0096A9:
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$04	;04
adrB_0096B1:
	dc.b	$4F	;4F
	dc.b	$47	;47
	dc.b	$41	;41
	dc.b	$3D	;3D
	dc.b	$38	;38
adrB_0096B6:
	dc.b	$1D	;1D
	dc.b	$10	;10
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$12	;12
	dc.b	$0A	;0A
	dc.b	$0E	;0E
	dc.b	$08	;08

adrCd0096BE:
	move.w	-$000A(a3),d0	;302BFFF6
	add.w	d0,d0	;D040
	add.w	d0,d0	;D040
	add.w	d6,d0	;D046
	move.b	adrB_009682(pc,d0.w),d6	;1C3B00B8
	moveq	#$00,d1	;7200
	move.b	-$0016(a3),d1	;122BFFEA
	move.b	adrB_009696(pc,d1.w),d0	;103B10C2
	bmi.s	adrCd009680	;6BA8
	add.b	adrB_009692(pc,d6.w),d0	;D03B60B8
	move.b	adrB_0096A9(pc,d0.w),d0	;103B00CB
	bmi.s	adrCd009680	;6B9E
	asl.w	#$02,d1	;E541
	add.w	d6,d1	;D246
	moveq	#$00,d5	;7A00
	moveq	#$00,d4	;7800
	move.b	adrB_0096B1(pc,d0.w),d5	;1A3B00C5
	add.w	$0008(a5),d5	;DA6D0008
	lea	adrEA0097BC.l,a0	;41F9000097BC
	move.b	$00(a0,d1.w),d4	;18301000
	move.w	-$0012(a3),d3	;362BFFEE
	and.w	#$0007,d3	;02430007
	subq.w	#$01,d3	;5343
	bne.s	adrCd009722	;661A
	subq.w	#$04,d6	;5946
	move.w	d0,d3	;3600
	add.w	d3,d3	;D643
	add.w	d6,d3	;D646
	sub.b	adrB_0096B6(pc,d3.w),d5	;9A3B30A4
	lea	adrEA009808.l,a0	;41F900009808
	move.b	-$0016(a3),d3	;162BFFEA
	move.b	$00(a0,d3.w),d4	;18303000
adrCd009722:
	cmpi.b	#$80,d4	;0C040080
	beq	adrCd009680	;6700FF58
	lea	ObjectColourSets.l,a6	;4DF90000E770
	moveq	#$00,d3	;7600
	move.b	$00(a6,d2.w),d3	;16362000
	asl.w	#$02,d3	;E543
	lea	FloorObjectPalettes.l,a6	;4DF90000E7DE
	move.l	$00(a6,d3.w),adrEA00B4C0.l	;23F630000000B4C0
	lea	ObjectFloorShapeTable.l,a0	;41F90000E67A
	move.b	$00(a0,d2.w),d3	;16302000
	move.w	d3,d6	;3C03
	asl.w	#$02,d6	;E546
	add.w	d3,d6	;DC43
	add.w	d0,d6	;DC40
	add.w	d6,d6	;DC46
	lea	FloorObjectGraphicOffsets.l,a0	;41F90000E88A
	lea	_GFX_ObjectsOnFloor.l,a1	;43F900032F60
	add.w	$00(a0,d6.w),a1	;D2F06000
	cmpi.b	#$12,d3	;0C030012
	bcs.s	adrCd009774	;6504
	add.w	#$0CB8,a1	;D2FC0CB8
adrCd009774:
	moveq	#$00,d7	;7E00
	cmpi.b	#$12,d3	;0C030012
	bcs.s	adrCd009780	;6504
	move.b	adrB_0097B6(pc,d0.w),d7	;1E3B0038
adrCd009780:
	swap	d7	;4847
	lsr.w	#$01,d6	;E24E
	lea	FloorObjectShapeHeights.l,a0	;41F90000E6E8
	move.b	$00(a0,d6.w),d7	;1E306000
	lea	adrEA00981C.l,a0	;41F90000981C
	add.b	$00(a0,d6.w),d5	;DA306000
	move.b	d4,d6	;1C04
	add.b	#$60,d4	;06040060
	ext.w	d6	;4886
	asr.w	#$04,d6	;E846
	move.w	#$FFFF,adrW_00B4BE.l	;33FCFFFF0000B4BE
	bsr	adrCd00AE5E	;610016B2
	clr.w	adrW_00B4BE.l	;42790000B4BE
	rts	;4E75

adrB_0097B6:
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
adrEA0097BC:
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$01	;01
	dc.b	$15	;15
	dc.b	$01	;01
	dc.b	$15	;15
	dc.b	$80	;80
	dc.b	$08	;08
	dc.b	$80	;80
	dc.b	$08	;08
	dc.b	$80	;80
	dc.b	$FD	;FD
	dc.b	$80	;80
	dc.b	$EC	;EC
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$5D	;5D
	dc.b	$71	;71
	dc.b	$5D	;5D
	dc.b	$71	;71
	dc.b	$67	;67
	dc.b	$80	;80
	dc.b	$67	;67
	dc.b	$80	;80
	dc.b	$69	;69
	dc.b	$80	;80
	dc.b	$78	;78
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$2F	;2F
	dc.b	$43	;43
	dc.b	$2F	;2F
	dc.b	$43	;43
	dc.b	$29	;29
	dc.b	$46	;46
	dc.b	$29	;29
	dc.b	$46	;46
	dc.b	$22	;22
	dc.b	$47	;47
	dc.b	$1C	;1C
	dc.b	$49	;49
	dc.b	$16	;16
	dc.b	$4C	;4C
	dc.b	$80	;80
	dc.b	$80	;80
adrEA009808:
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$0C	;0C
	dc.b	$FC	;FC
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$66	;66
	dc.b	$72	;72
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$80	;80
	dc.b	$39	;39
	dc.b	$37	;37
	dc.b	$34	;34
	dc.b	$80	;80
	dc.b	$00	;00
adrEA00981C:
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$03	;03
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$04	;04
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$03	;03
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$03	;03
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$05	;05
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$02	;02
	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$03	;03
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$03	;03
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$03	;03
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$04	;04
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$05	;05
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$05	;05
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$04	;04
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$00	;00

adrCd0098A4:
	bsr	adrCd0084FC	;6100EC56
adrCd0098A8:
	move.w	#$0080,d0	;303C0080
	lea	Player1_Data.l,a1	;43F90000EE7C
	cmp.w	$0058(a1),d1	;B2690058
	bne.s	adrCd0098BE	;6606
	cmp.l	$001C(a1),d2	;B4A9001C
	beq.s	adrCd009930	;6772
adrCd0098BE:
	addq.b	#$01,d0	;5200
	lea	Player2_Data.l,a1	;43F90000EEDE
	cmp.w	$0058(a1),d1	;B2690058
	bne.s	adrCd0098D2	;6606
	cmp.l	$001C(a1),d2	;B4A9001C
	beq.s	adrCd009930	;675E
adrCd0098D2:
	lea	CharacterStats.l,a1	;43F90000EB2A
	move.b	d2,d0	;1002
	swap	d2	;4842
	rol.w	#$08,d2	;E15A
	move.b	d0,d2	;1400
	move.w	CurrentTower.l,d3	;36390000EE2E
	moveq	#$0F,d0	;700F
adrLp0098E8:
	cmp.b	$001F(a1),d3	;B629001F
	bne.s	adrCd0098FA	;660C
	cmp.b	$001A(a1),d1	;B229001A
	bne.s	adrCd0098FA	;6606
	cmp.w	$0016(a1),d2	;B4690016
	beq.s	adrCd00992A	;6730
adrCd0098FA:
	add.w	#$0020,a1	;D2FC0020
	dbra	d0,adrLp0098E8	;51C8FFE8
	moveq	#$10,d0	;7010
	lea	UnpackedMonsters.l,a1	;43F900016B7E
	move.w	-$0002(a1),d3	;3629FFFE
	bmi.s	adrCd009926	;6B16
adrLp009910:
	cmp.b	$0004(a1),d1	;B2290004
	bne.s	adrCd00991C	;6606
	cmp.w	$0000(a1),d2	;B4690000
	beq.s	adrCd009930	;6714
adrCd00991C:
	addq.w	#$01,d0	;5240
	add.w	#$0010,a1	;D2FC0010
	dbra	d3,adrLp009910	;51CBFFEC
adrCd009926:
	swap	d1	;4841
	rts	;4E75

adrCd00992A:
	not.b	d0	;4600
	and.w	#$000F,d0	;0240000F
adrCd009930:
	ori.b	#$01,ccr	;003C0001
	rts	;4E75

adrB_009936:
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$00	;00
adrB_00993B:
	dc.b	$06	;06
	dc.b	$06	;06
	dc.b	$FF	;FF
	dc.b	$04	;04
	dc.b	$02	;02
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$06	;06
	dc.b	$06	;06
	dc.b	$FF	;FF
	dc.b	$04	;04
	dc.b	$02	;02
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$06	;06
	dc.b	$04	;04
	dc.b	$02	;02
	dc.b	$00	;00
	dc.b	$FF	;FF
adrB_00994E:
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$04	;04
	dc.b	$05	;05
	dc.b	$05	;05
adrB_009956:
	dc.b	$27	;27
	dc.b	$25	;25
	dc.b	$24	;24
	dc.b	$24	;24
	dc.b	$18	;18
	dc.b	$1A	;1A

adrCd00995C:
	moveq	#$04,d1	;7204
adrCd00995E:
	move.w	d1,d2	;3401
	move.w	#$004B,adrW_00AD64.l	;33FC004B0000AD64
	moveq	#$00,d0	;7000
	moveq	#$00,d4	;7800
	move.b	-$0016(a3),d0	;102BFFEA
	move.b	adrB_00993B(pc,d0.w),d1	;123B00C9
	bmi.s	adrCd0099C6	;6B50
	add.b	adrB_009936(pc,d2.w),d1	;D23B20BE
	move.w	d0,d5	;3A00
	asl.w	#$02,d0	;E540
	add.w	d5,d0	;D045
	add.w	d2,d0	;D042
	move.w	d1,d2	;3401
	lea	adrEA018A84.l,a0	;41F900018A84
	move.b	$00(a0,d0.w),d4	;18300000
	cmpi.b	#$FF,d4	;0C0400FF
	beq.s	adrCd0099C8	;6734
	move.b	adrB_00994E(pc,d2.w),d1	;123B20B8
	move.b	adrB_009956(pc,d1.w),d5	;1A3B10BC
	move.w	-$0012(a3),d0	;302BFFEE
	and.w	#$0007,d0	;02400007
	cmpi.w	#$0004,d0	;0C400004
	bne.s	adrCd0099C6	;661C
	move.b	adrB_0099CC(pc,d2.w),d0	;103B2020
	move.b	adrB_0099D4(pc,d2.w),d2	;143B2024
	btst	#$00,-$0012(a3)	;082B0000FFEE
	bne.s	adrCd0099BE	;6604
	neg.b	d0	;4400
	moveq	#$4B,d2	;744B
adrCd0099BE:
	add.b	d0,d5	;DA00
	move.w	d2,adrW_00AD64.l	;33C20000AD64
adrCd0099C6:
	rts	;4E75

adrCd0099C8:
	moveq	#-$01,d1	;72FF
	rts	;4E75

adrB_0099CC:
	dc.b	$00	;00
	dc.b	$08	;08
	dc.b	$00	;00
	dc.b	$06	;06
	dc.b	$00	;00
	dc.b	$06	;06
	dc.b	$00	;00
	dc.b	$00	;00
adrB_0099D4:
	dc.b	$4B	;4B
	dc.b	$3E	;3E
	dc.b	$4B	;4B
	dc.b	$34	;34
	dc.b	$4B	;4B
	dc.b	$2E	;2E
	dc.b	$4B	;4B
	dc.b	$4B	;4B

adrCd0099DC:
	moveq	#$00,d0	;7000
	moveq	#$00,d1	;7200
	lea	adrEA00B9DE.l,a0	;41F90000B9DE
	move.b	-$0016(a3),d0	;102BFFEA
	move.b	$00(a0,d0.w),d1	;12300000
adrCd0099EE:
	rts	;4E75

adrCd0099F0:
	bsr.s	adrCd0099DC	;61EA
	bmi.s	adrCd0099EE	;6BFA
	btst	d1,d7	;0307
	beq.s	adrCd0099EE	;67F6
	moveq	#$00,d2	;7400
	move.b	-$0019(a3),d2	;142BFFE7
	swap	d2	;4842
	move.b	-$001A(a3),d2	;142BFFE6
	move.w	-$001E(a3),d1	;322BFFE2
	bsr	adrCd0098A8	;6100FE9E
	bcc.s	adrCd0099EE	;64E0
	tst.b	d0	;4A00
	bmi	adrCd009AFA	;6B0000E8
	cmpi.w	#$0010,d0	;0C400010
	bcc.s	adrCd009A2A	;6410
	move.b	d0,-$0017(a3)	;1740FFE9
	move.b	$001B(a1),d0	;1029001B
	move.b	$0018(a1),d1	;12290018
	bra	adrCd009AB2	;6000008A

adrCd009A2A:
	moveq	#$00,d0	;7000
	move.b	$000D(a1),d0	;1029000D
	bmi.s	adrCd009A82	;6B50
	move.b	$0002(a1),d2	;14290002
	and.w	#$0003,d2	;02420003
	asl.w	#$02,d0	;E540
	lea	adrEA017390.l,a1	;43F900017390
	add.w	d0,a1	;D2C0
	moveq	#$03,d1	;7203
adrLp009A46:
	move.w	d1,d3	;3601
	addq.w	#$02,d3	;5443
	add.w	-$000A(a3),d3	;D66BFFF6
	sub.w	d2,d3	;9642
	and.w	#$0003,d3	;02430003
	moveq	#$00,d0	;7000
	move.b	$00(a1,d3.w),d0	;10313000
	bmi.s	adrCd009A7C	;6B20
	movem.l	d1/d2/a1,-(sp)	;48E76040
	asl.w	#$04,d0	;E940
	lea	UnpackedMonsters.l,a1	;43F900016B7E
	add.w	d0,a1	;D2C0
	add.w	d2,d3	;D642
	and.w	#$0003,d3	;02430003
	asl.w	#$04,d3	;E943
	or.b	d2,d3	;8602
	move.w	d3,d1	;3203
	bsr.s	adrCd009A86	;610E
	movem.l	(sp)+,d1/d2/a1	;4CDF0206
adrCd009A7C:
	dbra	d1,adrLp009A46	;51C9FFC8
	rts	;4E75

adrCd009A82:
	move.b	$0002(a1),d1	;12290002
adrCd009A86:
	move.b	$000B(a1),-$0017(a3)	;1769000BFFE9
	cmp.b	#$1A,-$0017(a3)	;0C2B001AFFE9
	bne.s	adrCd009AA8	;6614
	move.w	d1,d3	;3601
	bsr	RandomGen_BytewithOffset	;6100BB14
	move.w	d3,d1	;3203
	and.w	#$0001,d0	;02400001
	add.w	#$001A,d0	;0640001A
	move.b	d0,-$0017(a3)	;1740FFE9
adrCd009AA8:
	move.b	$0005(a1),d0	;10290005
	move.b	$0006(a1),-$0018(a3)	;17690006FFE8
adrCd009AB2:
	bsr	adrCd009BC0	;6100010C
	move.b	d1,d2	;1401
	and.b	#$03,d2	;02020003
	move.b	d2,-$001B(a3)	;1742FFE5
	lsr.b	#$04,d1	;E809
	subq.w	#$02,d1	;5541
	sub.w	-$000A(a3),d1	;926BFFF6
	and.w	#$0003,d1	;02410003
	cmp.b	#$15,-$0017(a3)	;0C2B0015FFE9
	beq.s	.CentralPosition	;6720
	cmp.b	#$16,-$0017(a3)	;0C2B0016FFE9
	beq.s	.CentralPosition	;6718
	cmp.b	#$40,-$0017(a3)	;0C2B0040FFE9
	beq.s	.CentralPosition	;6710
	cmp.b	#$67,-$0017(a3)	;0C2B0067FFE9
	bcc.s	.CentralPosition	;6408
	tst.b	-$0017(a3)	;4A2BFFE9
	bpl	adrCd00A6EC	;6A000BFA
.CentralPosition:
	moveq	#$04,d1	;7204
	bra	adrCd00A6EC	;60000BF4

adrCd009AFA:
	move.b	$0021(a1),-$001B(a3)	;17690021FFE5
	move.l	a5,-(sp)	;2F0D
	move.l	a1,a5	;2A49
	moveq	#$03,d1	;7203
	bsr	adrCd005500	;6100B9F8
	move.l	(sp)+,a5	;2A5F
	tst.w	d3	;4A43
	bmi.s	adrCd009B1A	;6B0A
	move.b	-$001F(a3),d2	;142BFFE1
	cmp.b	d2,d3	;B602
	bcs.s	adrCd009B1A	;6502
	rts	;4E75

adrCd009B1A:
	moveq	#$04,d1	;7204
	moveq	#$02,d0	;7002
	moveq	#$00,d2	;7400
adrLp009B20:
	tst.b	$27(a1,d0.w)	;4A310027
	bmi.s	adrCd009B28	;6B02
	addq.w	#$01,d2	;5242
adrCd009B28:
	dbra	d0,adrLp009B20	;51C8FFF6
	move.w	$0006(a1),d0	;30290006
	tst.w	d2	;4A42
	beq	adrCd009B5E	;6700002A
	moveq	#$03,d1	;7203
adrLp009B38:
	moveq	#$02,d0	;7002
	sub.w	$0020(a1),d0	;90690020
	add.w	-$000A(a3),d0	;D06BFFF6
	add.w	d1,d0	;D041
	and.w	#$0003,d0	;02400003
	move.b	$26(a1,d0.w),d0	;10310026
	bmi.s	adrCd009B58	;6B0A
	movem.l	d1/a1,-(sp)	;48E74040
	bsr.s	adrCd009B5E	;610A
	movem.l	(sp)+,d1/a1	;4CDF0202
adrCd009B58:
	dbra	d1,adrLp009B38	;51C9FFDE
	rts	;4E75

adrCd009B5E:
	move.b	d0,-$0017(a3)	;1740FFE9
	bsr	adrCd006660	;6100CAFC
	move.b	$001B(a4),d0	;102C001B
	bsr.s	adrCd009BC0	;6154
	bra	adrCd00A6EC	;60000B7E

SpellStars_Colours:
	dc.l	$090D0B0C	;090D0B0C
	dc.l	$02060807	;02060807
	dc.l	$020D0605	;020D0605
	dc.l	$00000000	;00000000
	dc.l	$090C0B0D	;090C0B0D
	dc.l	$090D0B0C	;090D0B0C
	dc.l	$0B0E0D0B	;0B0E0D0B
	dc.l	$090C0B0D	;090C0B0D
	dc.l	$090A0A0B	;090A0A0B
	dc.l	$01020506	;01020506
	dc.l	$0C0B0D0E	;0C0B0D0E
	dc.l	$0708060D	;0708060D
	dc.l	$0105060D	;0105060D
	dc.l	$07020804	;07020804
	dc.l	$0A0B0D0D	;0A0B0D0D
	dc.l	$0B0D0D0E	;0B0D0D0E
	dc.l	$00000000	;00000000
	dc.l	$090C0B0D	;090C0B0D
	dc.l	$0506060D	;0506060D
	dc.l	$0708060D	;0708060D

adrCd009BC0:
	clr.b	-$0015(a3)	;422BFFEB
	and.w	#$001F,d0	;0240001F
	move.b	adrB_009BD0(pc,d0.w),-$0015(a3)	;177B0006FFEB
	rts	;4E75

adrB_009BD0:
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$03	;03

Draw_Spell:
	lea	adrEA009C68.l,a1		;43F900009C68
	move.b	$00(a1,d1.w),d1			;12311000
	add.w	d1,d1				;D241
	lea	_GFX_FireBall.l,a1		;43F900034778
	lea	adrEA009C6E.l,a2		;45F900009C6E
	cmpi.b	#$86,d0				;0C000086
	bcs.s	adrCd009C18			;650A
	add.w	#$0798,a1			;D2FC0798
	lea	adrEA009C86.l,a2		;45F900009C86
adrCd009C18:
	add.w	$00(a2,d1.w),a1			;D2F21000
	add.w	d1,d1				;D241
	add.b	$08(a2,d1.w),d4			;D8321008
	add.b	$09(a2,d1.w),d5			;DA321009
	moveq	#$00,d7				;7E00
	move.b	$0A(a2,d1.w),d7			;1E32100A
	swap	d7				;4847
	move.b	$0B(a2,d1.w),d7			;1E32100B
	add.w	$0008(a5),d5			;DA6D0008
	move.b	d4,d6				;1C04
	add.b	#$60,d4				;06040060
	ext.w	d6				;4886
	asr.w	#$04,d6	;			E846
	move.l	a3,-(sp)			;2F0B
	move.w	#$FFFF,adrW_00B4BE.l		;33FCFFFF0000B4BE
	lea	SpellStars_Colours.l,a0		;41F900009B70
	asl.b	#$02,d0	;E500
	move.l	$00(a0,d0.w),adrEA00B4C0.l	;23F000000000B4C0
	bsr	adrCd00AE5E	;61001202
	clr.w	adrW_00B4BE.l	;42790000B4BE
	move.l	(sp)+,a3	;265F
	rts	;4E75

adrEA009C68:
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$03	;03
adrEA009C6E:
	dc.w	$0000	;0000
	dc.w	$01A0	;01A0
	dc.w	$0220	;0220
	dc.w	$0278	;0278
	dc.w	$F9F8	;F9F8
	dc.w	$0119	;0119
	dc.w	$FC00	;FC00
	dc.w	$000F	;000F
	dc.w	$0110	;0110
	dc.w	$000A	;000A
	dc.w	$020D	;020D
	dc.w	$0007	;0007
adrEA009C86:
	dc.w	$0000	;0000
	dc.w	$01B0	;01B0
	dc.w	$0228	;0228
	dc.w	$0280	;0280
	dc.w	$F9F8	;F9F8
	dc.w	$011A	;011A
	dc.w	$FE01	;FE01
	dc.w	$000E	;000E
	dc.w	$010E	;010E
	dc.w	$000A	;000A
	dc.w	$010E	;010E
	dc.w	$0006	;0006
adrB_009C9E:
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$81	;81

adrCd009CA2:
	move.w	d1,d2	;3401
	add.w	d2,d2	;D442
	add.w	d1,d2	;D441
	moveq	#$00,d6	;7C00
	move.b	adrB_009C9E(pc,d0.w),d3	;163B00F2
	bpl.s	adrCd009CB2	;6A02
	moveq	#-$01,d6	;7CFF
adrCd009CB2:
	and.w	#$007F,d3	;0243007F
	add.w	d3,d2	;D443
	moveq	#$00,d7	;7E00
	move.b	$0A(a0,d2.w),d7	;1E30200A
	swap	d7	;4847
	add.w	d2,d2	;D442
	move.w	$00(a2,d2.w),d2	;34322000
	add.w	d2,a1	;D2C2
	sub.b	$00(a0,d1.w),d5	;9A301000
	move.b	$06(a0,d1.w),d7	;1E301006
	rts	;4E75

Draw_Summon:
	lea	adrEA009EBE.l,a2	;45F900009EBE
	lea	adrEA009DC0.l,a0	;41F900009DC0
	lea	_GFX_Summon.l,a1	;43F900045018
	bsr.s	adrCd009CA2	;61BC
	lea	IllusionPalette.l,a6	;4DF900009E5C
	tst.b	-$0018(a3)	;4A2BFFE8
	bmi.s	.IllusionSkip	;6B0C
	lea	MonsterColours_Summons.l,a0	;41F900009DB8
	moveq	#$02,d3	;7602
	bsr	MonsterColourGrading	;61000198
.IllusionSkip:
	movem.w	d0/d1/d4/d5/d7,-(sp)	;48A7CD00
	move.l	a1,-(sp)	;2F09
	bsr	adrCd00AD34	;6100102E
	move.l	(sp)+,a1	;225F
	movem.w	(sp)+,d0/d1/d4/d5/d7	;4C9F00B3
	addq.b	#$03,d4	;5604
	tst.w	d1	;4A41
	bne.s	adrCd009D28	;6614
	btst	#$00,d0	;08000000
	bne.s	adrCd009D28	;660E
	moveq	#-$01,d6	;7CFF
	movem.w	d0/d1/d4/d5,-(sp)	;48A7CC00
	bsr	adrCd00AD34	;61001012
	movem.w	(sp)+,d0/d1/d4/d5	;4C9F0033
adrCd009D28:
	cmpi.w	#$0004,d1	;0C410004
	bcc	adrCd009DB6	;64000088
	lea	adrEA009DDC.l,a2	;45F900009DDC
	movem.w	d0/d1/d4/d5,-(sp)	;48A7CC00
	moveq	#$00,d6	;7C00
	moveq	#$00,d2	;7400
	bsr	adrCd009D50	;61000010
	movem.w	(sp)+,d0/d1/d4/d5	;4C9F0033
	lea	adrEA009DFC.l,a2	;45F900009DFC
	moveq	#-$01,d6	;7CFF
	moveq	#$01,d2	;7401
adrCd009D50:
	lea	adrEA009DCC.l,a0	;41F900009DCC
	move.b	$00(a0,d0.w),d3	;16300000
	bpl.s	adrCd009D5E	;6A02
	not.w	d6	;4646
adrCd009D5E:
	and.w	#$007F,d3	;0243007F
	btst	d2,-$0015(a3)	;052BFFEB
	beq.s	adrCd009D6A	;6702
	moveq	#$02,d3	;7602
adrCd009D6A:
	move.w	d1,d2	;3401
	add.w	d2,d2	;D442
	add.w	d1,d2	;D441
	add.w	d3,d2	;D443
	moveq	#$00,d7	;7E00
	lea	adrEA009DD0.l,a0	;41F900009DD0
	move.b	$00(a0,d2.w),d7	;1E302000
	add.w	d2,d2	;D442
	lea	adrEA009EE2.l,a0	;41F900009EE2
	lea	_GFX_Summon.l,a1	;43F900045018
	add.w	$00(a0,d2.w),a1	;D2F02000
	move.w	d1,d2	;3401
	asl.w	#$02,d2	;E542
	add.w	d0,d2	;D440
	add.w	d2,d2	;D442
	cmpi.b	#$02,d3	;0C030002
	bne.s	adrCd009DA2	;6604
	add.w	#$0040,a2	;D4FC0040
adrCd009DA2:
	cmp.w	#$FFFF,$00(a2,d2.w)	;0C72FFFF2000
	beq.s	adrCd009DB6	;670C
	sub.b	$00(a2,d2.w),d4	;98322000
	sub.b	$01(a2,d2.w),d5	;9A322001
	bra	adrCd00AD34	;60000F80

adrCd009DB6:
	rts	;4E75

MonsterColours_Summons:
	dc.w	$0001	;0001
	dc.w	$0203	;0203
	dc.w	$0405	;0405
	dc.w	$0607	;0607
adrEA009DC0:
	dc.w	$1511	;1511
	dc.w	$0D0C	;0D0C
	dc.w	$FE00	;FE00
	dc.w	$2E26	;2E26
	dc.w	$1F1A	;1F1A
	dc.w	$1510	;1510
adrEA009DCC:
	dc.w	$0001	;0001
	dc.w	$8001	;8001
adrEA009DD0:
	dc.w	$1414	;1414
	dc.w	$1010	;1010
	dc.w	$100B	;100B
	dc.w	$0C0C	;0C0C
	dc.w	$0A0B	;0A0B
	dc.w	$0B08	;0B08
adrEA009DDC:
	dc.w	$09F9	;09F9
	dc.w	$FFFF	;FFFF
	dc.w	$FAF9	;FAF9
	dc.w	$03F9	;03F9
	dc.w	$07FA	;07FA
	dc.w	$FFFF	;FFFF
	dc.w	$00FA	;00FA
	dc.w	$02FA	;02FA
	dc.w	$07FB	;07FB
	dc.w	$FFFF	;FFFF
	dc.w	$04FB	;04FB
	dc.w	$01FB	;01FB
	dc.w	$06FC	;06FC
	dc.w	$FFFF	;FFFF
	dc.w	$07FC	;07FC
	dc.w	$01FC	;01FC
adrEA009DFC:
	dc.w	$FAF9	;FAF9
	dc.w	$03F9	;03F9
	dc.w	$09F9	;09F9
	dc.w	$FFFF	;FFFF
	dc.w	$00FA	;00FA
	dc.w	$04FA	;04FA
	dc.w	$07FA	;07FA
	dc.w	$FFFF	;FFFF
	dc.w	$04FB	;04FB
	dc.w	$05FB	;05FB
	dc.w	$06FB	;06FB
	dc.w	$FFFF	;FFFF
	dc.w	$07FC	;07FC
	dc.w	$05FC	;05FC
	dc.w	$06FC	;06FC
	dc.w	$FFFF	;FFFF
	dc.w	$0D04	;0D04
	dc.w	$FFFF	;FFFF
	dc.w	$F604	;F604
	dc.w	$0604	;0604
	dc.w	$0A02	;0A02
	dc.w	$FFFF	;FFFF
	dc.w	$FD02	;FD02
	dc.w	$0302	;0302
	dc.w	$0A01	;0A01
	dc.w	$FFFF	;FFFF
	dc.w	$0101	;0101
	dc.w	$0301	;0301
	dc.w	$0901	;0901
	dc.w	$FFFF	;FFFF
	dc.w	$0401	;0401
	dc.w	$0201	;0201
	dc.w	$F604	;F604
	dc.w	$0004	;0004
	dc.w	$0D04	;0D04
	dc.w	$FFFF	;FFFF
	dc.w	$FD02	;FD02
	dc.w	$0302	;0302
	dc.w	$0A02	;0A02
	dc.w	$FFFF	;FFFF
	dc.w	$0101	;0101
	dc.w	$0301	;0301
	dc.w	$0901	;0901
	dc.w	$FFFF	;FFFF
	dc.w	$0401	;0401
	dc.w	$0401	;0401
	dc.w	$0901	;0901
	dc.w	$FFFF	;FFFF
IllusionPalette:
	dc.w	$0000	;0000
	dc.w	$0708	;0708
MonsterPalettes:
	dc.w	$0003	;0003
	dc.w	$040E	;040E
	dc.w	$0008	;0008
	dc.w	$040E	;040E
	dc.w	$0005	;0005
	dc.w	$060E	;060E
	dc.w	$0009	;0009
	dc.w	$0A0B	;0A0B
	dc.w	$0009	;0009
	dc.w	$0C0B	;0C0B
	dc.w	$000A	;000A
	dc.w	$0B0D	;0B0D
	dc.w	$000B	;000B
	dc.w	$0D0E	;0D0E
	dc.w	$000C	;000C
	dc.w	$0B0D	;0B0D
	dc.w	$0002	;0002
	dc.w	$0304	;0304
	dc.w	$0008	;0008
	dc.w	$040D	;040D
	dc.w	$0005	;0005
	dc.w	$060D	;060D
	dc.w	$0007	;0007
	dc.w	$0804	;0804
	dc.w	$0007	;0007
	dc.w	$080D	;080D

MonsterColourGrading:
	moveq	#$00,d2	;7400
	move.b	-$0018(a3),d2	;142BFFE8
	sub.b	d3,d2	;9403
	bcc.s	.gradelower	;6402
	moveq	#$00,d2	;7400
.gradelower:
	cmpi.b	#$08,d2	;0C020008
	bcs.s	.gradeupper	;6502
	moveq	#$07,d2	;7407
.gradeupper:
	move.b	$00(a0,d2.w),d2	;14302000
	asl.w	#$02,d2	;E542
	lea	MonsterPalettes.l,a6	;4DF900009E60
	add.w	d2,a6	;DCC2
	move.l	(a6),adrEA00B4C0.l	;23D60000B4C0
	rts	;4E75

adrEA009EBE:
	dc.w	$0000	;0000
	dc.w	$0178	;0178
	dc.w	$02F0	;02F0
	dc.w	$0468	;0468
	dc.w	$05A0	;05A0
	dc.w	$06D8	;06D8
	dc.w	$0810	;0810
	dc.w	$0910	;0910
	dc.w	$0A10	;0A10
	dc.w	$0B10	;0B10
	dc.w	$0BE8	;0BE8
	dc.w	$0CC0	;0CC0
	dc.w	$0D98	;0D98
	dc.w	$0E48	;0E48
	dc.w	$0EF8	;0EF8
	dc.w	$0FA8	;0FA8
	dc.w	$1030	;1030
	dc.w	$10B8	;10B8
adrEA009EE2:
	dc.w	$1140	;1140
	dc.w	$11E8	;11E8
	dc.w	$1290	;1290
	dc.w	$1318	;1318
	dc.w	$13A0	;13A0
	dc.w	$1428	;1428
	dc.w	$1488	;1488
	dc.w	$14F0	;14F0
	dc.w	$1558	;1558
	dc.w	$15B0	;15B0
	dc.w	$1610	;1610
	dc.w	$1670	;1670

Draw_Crab:
	move.w	#$FFFF,adrW_00B4BE.l	;33FCFFFF0000B4BE
	lea	MonsterColours_Crabs.l,a0	;41F900009F20
	moveq	#$02,d3	;7602
	bsr.s	MonsterColourGrading	;6188
	bsr	adrCd00A106	;610001F8
	lea	adrEA00B4C0.l,a6	;4DF90000B4C0
	bsr.s	adrCd009F28	;6110
	clr.w	adrW_00B4BE.l	;42790000B4BE
	rts	;4E75

MonsterColours_Crabs:
	INCBIN bw-data/crab.colours

adrCd009F28:
	cmpi.b	#$02,d1	;0C010002
	bcc.s	adrCd009F32	;6404
	bsr	adrCd00A060	;61000130
adrCd009F32:
	cmpi.b	#$02,d0	;0C000002
	beq.s	adrCd009F78	;6740
	tst.b	d0	;4A00
	bne	adrCd009FE8	;660000AC
	cmpi.b	#$02,d1	;0C010002
	bcs.s	adrCd009F8C	;6548
	subq.w	#$02,d1	;5541
	lea	adrEA00A17A.l,a2	;45F90000A17A
	bsr	adrCd00A0F6	;610001A8
	moveq	#$00,d7	;7E00
	move.b	adrB_009F80(pc,d1.w),d7	;1E3B102C
	add.b	adrB_009F7A(pc,d1.w),d5	;DA3B1022
	moveq	#$00,d6	;7C00
	add.w	d1,d1	;D241
	movem.l	d0/d1/d4/d5/d7/a1,-(sp)	;48E7CD40
	add.b	adrB_009F7C(pc,d1.w),d4	;D83B1018
	bsr	adrCd00AD34	;61000DCC
	movem.l	(sp)+,d0/d1/d4/d5/d7/a1	;4CDF02B3
	moveq	#-$01,d6	;7CFF
	add.b	adrB_009F7D(pc,d1.w),d4	;D83B100B
	bra	adrCd00AD34	;60000DBE

adrCd009F78:
	rts	;4E75

adrB_009F7A:
	dc.b	$F8	;F8
	dc.b	$F7	;F7
adrB_009F7C:
	dc.b	$F8	;F8
adrB_009F7D:
	dc.b	$04	;04
	dc.b	$F9	;F9
	dc.b	$FF	;FF
adrB_009F80:
	dc.b	$09	;09
	dc.b	$07	;07
adrB_009F82:
	dc.b	$FD	;FD
	dc.b	$EF	;EF
	dc.b	$FA	;FA
	dc.b	$F1	;F1
adrB_009F86:
	dc.b	$F0	;F0
	dc.b	$10	;10
	dc.b	$F6	;F6
	dc.b	$04	;04
adrB_009F8A:
	dc.b	$14	;14
	dc.b	$0D	;0D

adrCd009F8C:
	moveq	#$00,d7	;7E00
	move.b	adrB_009F8A(pc,d1.w),d7	;1E3B10FA
	moveq	#$00,d2	;7400
	moveq	#$00,d6	;7C00
	bsr	adrCd009F9E	;61000006
	moveq	#$01,d2	;7401
	moveq	#-$01,d6	;7CFF
adrCd009F9E:
	lea	adrEA00A6C2.l,a2	;45F90000A6C2
	lea	_GFX_Behemoth.l,a1	;43F9000466D0
	movem.w	d0/d1/d4/d5/d7,-(sp)	;48A7CD00
	add.w	d1,d1	;D241
	move.w	d1,d3	;3601
	add.w	d2,d3	;D642
	add.b	adrB_009F86(pc,d3.w),d4	;D83B30D0
	move.w	d1,d3	;3601
	btst	d2,-$0015(a3)	;052BFFEB
	beq.s	adrCd009FC4	;6704
	addq.w	#$01,d3	;5243
	addq.w	#$02,a2	;544A
adrCd009FC4:
	add.b	adrB_009F82(pc,d3.w),d5	;DA3B30BC
	add.w	d1,d1	;D241
	add.w	$00(a2,d1.w),a1	;D2F21000
	bsr	adrCd00AD34	;61000D64
	movem.w	(sp)+,d0/d1/d4/d5/d7	;4C9F00B3
	rts	;4E75

adrB_009FD8:
	dc.b	$08	;08
	dc.b	$12	;12
	dc.b	$07	;07
	dc.b	$0E	;0E
adrB_009FDC:
	dc.b	$E6	;E6
	dc.b	$E5	;E5
	dc.b	$1A	;1A
	dc.b	$1B	;1B
	dc.b	$EF	;EF
	dc.b	$EF	;EF
	dc.b	$0B	;0B
	dc.b	$0B	;0B
adrB_009FE4:
	dc.b	$02	;02
	dc.b	$F1	;F1
	dc.b	$FB	;FB
	dc.b	$F0	;F0

adrCd009FE8:
	cmpi.b	#$02,d1	;0C010002
	bcc.s	adrCd00A030	;6442
	lea	adrEA00A17E.l,a2	;45F90000A17E
	add.w	d1,d1	;D241
	moveq	#-$01,d6	;7CFF
	lsr.b	#$01,d0	;E208
	beq.s	adrCd009FFE	;6702
	moveq	#$00,d6	;7C00
adrCd009FFE:
	move.w	d1,d2	;3401
	add.w	d0,d2	;D440
	add.w	d2,d2	;D442
	eor.b	#$01,d0	;0A000001
	btst	d0,-$0015(a3)	;012BFFEB
	beq.s	adrCd00A012	;6704
	addq.w	#$01,d1	;5241
	addq.w	#$01,d2	;5242
adrCd00A012:
	moveq	#$00,d7	;7E00
	move.b	adrB_009FD8(pc,d1.w),d7	;1E3B10C2
	add.b	adrB_009FDC(pc,d2.w),d4	;D83B20C2
	add.b	adrB_009FE4(pc,d1.w),d5	;DA3B10C6
	bsr	adrCd00A0F6	;610000D4
	bra	adrCd00AD34	;60000D0E

adrB_00A028:
	dc.b	$08	;08
	dc.b	$06	;06
adrB_00A02A:
	dc.b	$F3	;F3
	dc.b	$09	;09
	dc.b	$F2	;F2
	dc.b	$06	;06
adrB_00A02E:
	dc.b	$F8	;F8
	dc.b	$F7	;F7

adrCd00A030:
	subq.b	#$02,d1	;5501
	moveq	#$00,d7	;7E00
	move.b	adrB_00A028(pc,d1.w),d7	;1E3B10F2
	add.b	adrB_00A02E(pc,d1.w),d5	;DA3B10F4
	lea	adrEA00A186.l,a2	;45F90000A186
	bsr	adrCd00A0F6	;610000B2
	add.w	d1,d1	;D241
	moveq	#-$01,d6	;7CFF
	lsr.b	#$01,d0	;E208
	beq.s	adrCd00A052	;6704
	moveq	#$00,d6	;7C00
	addq.w	#$01,d1	;5241
adrCd00A052:
	add.b	adrB_00A02A(pc,d1.w),d4	;D83B10D6
	bra	adrCd00AD34	;60000CDC

adrB_00A05A:
	dc.b	$0B	;0B
	dc.b	$07	;07
adrB_00A05C:
	dc.b	$FE	;FE
	dc.b	$FB	;FB
adrB_00A05E:
	dc.b	$EC	;EC
	dc.b	$14	;14

adrCd00A060:
	tst.b	d0	;4A00
	bne.s	adrCd00A086	;6622
	moveq	#$00,d6	;7C00
	lea	adrEA00A170.l,a2	;45F90000A170
	movem.w	d0/d1/d4/d5,-(sp)	;48A7CC00
	move.b	adrB_00A05A(pc,d1.w),d7	;1E3B10E8
	bsr	adrCd00A0F6	;61000080
	add.b	adrB_00A05C(pc,d1.w),d5	;DA3B10E2
adrCd00A07C:
	bsr	adrCd00AD34	;61000CB6
	movem.w	(sp)+,d0/d1/d4/d5	;4C9F0033
adrCd00A084:
	rts	;4E75

adrCd00A086:
	cmpi.b	#$02,d0	;0C000002
	beq.s	adrCd00A0B4	;6728
	tst.b	d1	;4A01
	bne.s	adrCd00A084	;66F4
	lea	_GFX_CrabClaw.l,a1	;43F900047F10
	movem.w	d0/d1/d4/d5,-(sp)	;48A7CC00
	moveq	#$07,d7	;7E07
	subq.b	#$03,d5	;5705
	moveq	#-$01,d6	;7CFF
	lsr.b	#$01,d0	;E208
	beq.s	adrCd00A0A6	;6702
	moveq	#$00,d6	;7C00
adrCd00A0A6:
	add.b	adrB_00A05E(pc,d0.w),d4	;D83B00B6
	bra.s	adrCd00A07C	;60D0

adrB_00A0AC:
	dc.b	$07	;07
	dc.b	$F9	;F9
	dc.b	$FE	;FE
	dc.b	$FC	;FC
adrB_00A0B0:
	dc.b	$EF	;EF
	dc.b	$F1	;F1
adrB_00A0B2:
	dc.b	$07	;07
	dc.b	$04	;04

adrCd00A0B4:
	tst.b	-$0015(a3)	;4A2BFFEB
	beq.s	adrCd00A084	;67CA
	lea	adrEA00A176.l,a2	;45F90000A176
	bsr.s	adrCd00A0F6	;6134
	moveq	#$00,d7	;7E00
	move.b	adrB_00A0B2(pc,d1.w),d7	;1E3B10EC
	moveq	#-$01,d6	;7CFF
	moveq	#$00,d2	;7400
	bsr.s	adrCd00A0D2	;6104
	moveq	#$00,d6	;7C00
	moveq	#$01,d2	;7401
adrCd00A0D2:
	btst	d2,-$0015(a3)	;052BFFEB
	beq.s	adrCd00A0F4	;671C
	movem.w	d0/d1/d4/d5/d7,-(sp)	;48A7CD00
	move.l	a1,-(sp)	;2F09
	add.b	adrB_00A0B0(pc,d1.w),d5	;DA3B10D0
	add.w	d1,d1	;D241
	add.w	d2,d1	;D242
	add.b	adrB_00A0AC(pc,d1.w),d4	;D83B10C4
	bsr	adrCd00AD34	;61000C48
	move.l	(sp)+,a1	;225F
	movem.w	(sp)+,d0/d1/d4/d5/d7	;4C9F00B3
adrCd00A0F4:
	rts	;4E75

adrCd00A0F6:
	lea	_GFX_Crab.l,a1	;43F900047AB8
	move.w	d1,d2	;3401
	add.w	d2,d2	;D442
	add.w	$00(a2,d2.w),a1	;D2F22000
	rts	;4E75

adrCd00A106:
	lea	LargeMonsterSizeScales.l,a0	;41F90000A536
	move.b	$00(a0,d1.w),d1	;12301000
	lea	adrEA00A168.l,a2	;45F90000A168
	lea	adrEA00A15C.l,a0	;41F90000A15C
	add.b	$00(a0,d1.w),d5	;DA301000
	moveq	#$00,d7	;7E00
	move.b	$04(a0,d1.w),d7	;1E301004
	swap	d7	;4847
	move.b	$08(a0,d1.w),d7	;1E301008
	bsr.s	adrCd00A0F6	;61C8
	movem.l	d0-d2/d4/d5/d7,-(sp)	;48E7ED00
	move.l	a1,-(sp)	;2F09
	add.b	adrB_00A154(pc,d2.w),d4	;D83B201E
	moveq	#$00,d6	;7C00
	bsr	adrCd00A6CA	;6100058E
	move.l	(sp)+,a1	;225F
	movem.l	(sp),d0-d2/d4/d5/d7	;4CD700B7
	moveq	#-$01,d6	;7CFF
	add.b	adrB_00A155(pc,d2.w),d4	;D83B200D
	bsr	adrCd00A6CA	;6100057E
	movem.l	(sp)+,d0-d2/d4/d5/d7	;4CDF00B7
	rts	;4E75

adrB_00A154:
	dc.b	$EC	;EC
adrB_00A155:
	dc.b	$04	;04
	dc.b	$F2	;F2
	dc.b	$F8	;F8
	dc.b	$F8	;F8
	dc.b	$04	;04
	dc.b	$F9	;F9
	dc.b	$FF	;FF
adrEA00A15C:
	dc.w	$080B	;080B
	dc.w	$1714	;1714
	dc.w	$0101	;0101
	dc.w	$0000	;0000
	dc.w	$1C12	;1C12
	dc.w	$0C09	;0C09
adrEA00A168:
	dc.w	$0000	;0000
	dc.w	$01D0	;01D0
	dc.w	$0300	;0300
	dc.w	$0368	;0368
adrEA00A170:
	dc.w	$03B8	;03B8
	dc.w	$0418	;0418
	dc.w	$0458	;0458
adrEA00A176:
	dc.w	$0498	;0498
	dc.w	$04D8	;04D8
adrEA00A17A:
	dc.w	$0500	;0500
	dc.w	$0550	;0550
adrEA00A17E:
	dc.w	$0590	;0590
	dc.w	$05D8	;05D8
	dc.w	$0670	;0670
	dc.w	$06B0	;06B0
adrEA00A186:
	dc.w	$0728	;0728
	dc.w	$0770	;0770

Draw_Beholder:
	moveq	#$04,d3	;7604
	lea	MonsterColours_Beholder.l,a0	;41F90000A1AC
	bsr	MonsterColourGrading	;6100FD00
	bsr	adrCd00A26E	;610000D6
	cmpi.b	#$02,d0	;0C000002
	beq.s	adrCd00A1A4	;6704
	bsr	adrCd00A1BC	;6100001A
adrCd00A1A4:
	clr.w	adrW_00B4BE.l	;42790000B4BE
	rts	;4E75

MonsterColours_Beholder:
	dc.w	$040A	;040A
	dc.w	$070B	;070B
	dc.w	$0308	;0308
	dc.w	$0509	;0509
adrB_00A1B4:
	dc.b	$08	;08
	dc.b	$06	;06
	dc.b	$06	;06
	dc.b	$04	;04
adrB_00A1B8:
	dc.b	$06	;06
	dc.b	$05	;05
	dc.b	$04	;04
	dc.b	$03	;03

adrCd00A1BC:
	cmpi.b	#$04,d1	;0C010004
	bcc.s	adrCd00A226	;6464
	lea	adrEA00A308.l,a2	;45F90000A308
	moveq	#$00,d7	;7E00
	add.b	adrB_00A1B8(pc,d1.w),d5	;DA3B10EC
	move.w	d1,d2	;3401
	add.w	d2,d2	;D442
	btst	#$01,-$0015(a3)	;082B0001FFEB
	beq.s	adrCd00A1DC	;6702
	addq.w	#$01,d2	;5242
adrCd00A1DC:
	add.w	d2,d2	;D442
	lea	_GFX_Beholder_0.l,a1	;43F900048260
	tst.b	d0	;4A00
	bne.s	adrCd00A200	;6618
	move.b	adrB_00A1B4(pc,d1.w),d7	;1E3B10CA
	add.w	$00(a2,d2.w),a1	;D2F22000
	bra	adrCd00A2B6	;600000C4

adrB_00A1F4:
	dc.b	$08	;08
	dc.b	$06	;06
	dc.b	$04	;04
	dc.b	$04	;04
adrB_00A1F8:
	dc.b	$08	;08
	dc.b	$04	;04
	dc.b	$FF	;FF
	dc.b	$FD	;FD
adrB_00A1FC:
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$00	;00

adrCd00A200:
	add.w	#$0010,a2	;D4FC0010
	add.w	$00(a2,d2.w),a1	;D2F22000
	move.b	adrB_00A1F4(pc,d1.w),d7	;1E3B10EA
	add.b	adrB_00A1FC(pc,d1.w),d5	;DA3B10EE
	moveq	#$00,d6	;7C00
	lsr.b	#$01,d0	;E208
	beq	adrCd00AD34	;67000B1E
	add.b	adrB_00A1F8(pc,d1.w),d4	;D83B10DE
	moveq	#-$01,d6	;7CFF
	bra	adrCd00AD34	;60000B14

adrB_00A222:
	dc.b	$06	;06
	dc.b	$04	;04
adrB_00A224:
	dc.b	$F9	;F9
	dc.b	$F7	;F7

adrCd00A226:
	lea	adrEA00A328.l,a2	;45F90000A328
	subq.w	#$04,d1	;5941
	move.w	d1,d2	;3401
	moveq	#$02,d7	;7E02
	add.b	adrB_00A222(pc,d1.w),d5	;DA3B10EE
	moveq	#$00,d6	;7C00
	tst.b	d0	;4A00
	beq.s	adrCd00A248	;670C
	addq.w	#$02,d2	;5442
	lsr.b	#$01,d0	;E208
	beq.s	adrCd00A248	;6706
	moveq	#-$01,d6	;7CFF
	add.b	adrB_00A224(pc,d1.w),d4	;D83B10DE
adrCd00A248:
	add.w	d2,d2	;D442
	lea	_GFX_Beholder_0.l,a1	;43F900048260
	add.w	$00(a2,d2.w),a1	;D2F22000
	bra	adrCd00AD34	;60000ADE

adrB_00A258:
	dc.b	$14	;14
	dc.b	$10	;10
	dc.b	$0D	;0D
	dc.b	$0A	;0A
	dc.b	$0B	;0B
	dc.b	$08	;08
adrB_00A25E:
	dc.b	$FD	;FD
	dc.b	$FE	;FE
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
adrB_00A264:
	dc.b	$F2	;F2
	dc.b	$F4	;F4
	dc.b	$F6	;F6
	dc.b	$F7	;F7
	dc.b	$02	;02
	dc.b	$01	;01
adrB_00A26A:
	dc.b	$06	;06
	dc.b	$04	;04
	dc.b	$03	;03
	dc.b	$03	;03

adrCd00A26E:
	moveq	#$00,d7	;7E00
	move.b	adrB_00A258(pc,d1.w),d7	;1E3B10E6
	add.b	adrB_00A25E(pc,d1.w),d4	;D83B10E8
	add.b	adrB_00A264(pc,d1.w),d5	;DA3B10EA
	lea	adrEA00A2F4.l,a2	;45F90000A2F4
	bsr	adrCd00A2E4	;61000060
	bsr	adrCd00A2B6	;6100002E
	cmpi.b	#$04,d1	;0C010004
	bcc.s	adrCd00A2B4	;6424
	lea	adrEA00A300.l,a2	;45F90000A300
	bsr	adrCd00A2E4	;6100004C
	move.w	d5,-(sp)	;3F05
	moveq	#$00,d7	;7E00
	move.b	adrB_00A26A(pc,d1.w),d7	;1E3B10CA
	sub.b	d7,d5	;9A07
	move.b	-$0015(a3),d2	;142BFFEB
	not.b	d2	;4602
	and.w	#$0001,d2	;02420001
	sub.b	d2,d5	;9A02
	bsr.s	adrCd00A2B6	;6104
	move.w	(sp)+,d5	;3A1F
adrCd00A2B4:
	rts	;4E75

adrCd00A2B6:
	movem.w	d0/d1/d4/d5/d7,-(sp)	;48A7CD00
	move.l	a1,-(sp)	;2F09
	moveq	#$00,d6	;7C00
	bsr	adrCd00AD34	;61000A74
	move.l	(sp)+,a1	;225F
	movem.w	(sp)+,d0/d1/d4/d5/d7	;4C9F00B3
	cmpi.b	#$02,d1	;0C010002
	bcc.s	adrCd00A2B4	;64E6
	moveq	#-$01,d6	;7CFF
	movem.w	d0/d1/d4/d5/d7,-(sp)	;48A7CD00
	add.b	adrB_00A2E2(pc,d1.w),d4	;D83B100C
	bsr	adrCd00AD34	;61000A5A
	movem.w	(sp)+,d0/d1/d4/d5/d7	;4C9F00B3
	rts	;4E75

adrB_00A2E2:
	dc.b	$08	;08
	dc.b	$04	;04

adrCd00A2E4:
	move.w	d1,d2	;3401
	add.w	d2,d2	;D442
	lea	_GFX_Beholder_0.l,a1	;43F900048260
	add.w	$00(a2,d2.w),a1	;D2F22000
	rts	;4E75

adrEA00A2F4:
	dc.w	_GFX_Beholder_0-_GFX_Beholder_0	;0000
	dc.w	_GFX_Beholder_1-_GFX_Beholder_0	;00A8
	dc.w	_GFX_Beholder_2-_GFX_Beholder_0	;0130
	dc.w	_GFX_Beholder_3-_GFX_Beholder_0	;01A0
	dc.w	_GFX_Beholder_4-_GFX_Beholder_0	;01F8
	dc.w	_GFX_Beholder_5-_GFX_Beholder_0	;0258
adrEA00A300:
	dc.w	_GFX_Beholder_6-_GFX_Beholder_0	;02A0
	dc.w	_GFX_Beholder_7-_GFX_Beholder_0	;02D8
	dc.w	_GFX_Beholder_8-_GFX_Beholder_0	;0300
	dc.w	_GFX_Beholder_9-_GFX_Beholder_0	;0320
adrEA00A308:
	dc.w	$0340	;0340
	dc.w	$0388	;0388
	dc.w	$03D0	;03D0
	dc.w	$0408	;0408
	dc.w	$0440	;0440
	dc.w	$0478	;0478
	dc.w	$04B0	;04B0
	dc.w	$04D8	;04D8
	dc.w	$0500	;0500
	dc.w	$0548	;0548
	dc.w	$0590	;0590
	dc.w	$05C8	;05C8
	dc.w	$0600	;0600
	dc.w	$0628	;0628
	dc.w	$0650	;0650
	dc.w	$0678	;0678
adrEA00A328:
	dc.w	$06A0	;06A0
	dc.w	$06B8	;06B8
	dc.w	$06D0	;06D0
	dc.w	$06E8	;06E8

Draw_LittleDragon:
	moveq	#$01,d2	;7401
	lea	adrEA00A33C.l,a2	;45F90000A33C
	moveq	#$03,d3	;7603
	bra.s	adrCd00A356	;601A

adrEA00A33C:
	dc.w	$F1F5	;F1F5
	dc.w	$FBFA	;FBFA
	dc.w	$FD01	;FD01
	dc.w	$0E0D	;0E0D
adrEA00A344:
	dc.w	$E8EE	;E8EE
	dc.w	$F6F9	;F6F9
	dc.w	$F0F8	;F0F8
	dc.w	$0909	;0909

Draw_BigDragon:
	moveq	#$00,d2	;7400
	lea	adrEA00A344.l,a2	;45F90000A344
	moveq	#$09,d3	;7609
adrCd00A356:
	lea	LargeMonsterSizeScales.l,a0	;41F90000A536
	move.b	$00(a0,d1.w),d1	;12301000
	add.b	$00(a2,d1.w),d4	;D8321000
	add.b	$04(a2,d1.w),d5	;DA321004
	add.w	d2,d1	;D242
	btst	#$00,d0	;08000000
	beq.s	adrCd00A37C	;670C
	move.w	d0,d2	;3400
	lsr.w	#$01,d2	;E24A
	add.w	d1,d2	;D441
	add.w	d1,d2	;D441
	add.b	adrB_00A39C(pc,d2.w),d4	;D83B2022
adrCd00A37C:
	lea	MonsterColours_Dragons.l,a0	;41F90000A3A6
	bsr	MonsterColourGrading	;6100FB10
	move.w	#$FFFF,adrW_00B4BE.l	;33FCFFFF0000B4BE
	bsr	adrCd00A476	;610000E6
	bsr.s	adrCd00A3AE	;611A
	clr.w	adrW_00B4BE.l	;42790000B4BE
adrCd00A39A:
	rts	;4E75

adrB_00A39C:
	dc.b	$FD	;FD
	dc.b	$F5	;F5
	dc.b	$FD	;FD
	dc.b	$F1	;F1
	dc.b	$FE	;FE
	dc.b	$F2	;F2
	dc.b	$FE	;FE
	dc.b	$FA	;FA
	dc.b	$FF	;FF
	dc.b	$F6	;F6
MonsterColours_Dragons:
	dc.w	$0B0A	;0B0A
	dc.w	$0408	;0408
	dc.w	$0709	;0709
	dc.w	$0506	;0506

adrCd00A3AE:
	cmpi.b	#$02,d0	;0C000002
	beq.s	adrCd00A39A	;67E6
	cmpi.b	#$03,d1	;0C010003
	bcc.s	adrCd00A39A	;64E0
	moveq	#$00,d2	;7400
	moveq	#$00,d6	;7C00
	movem.w	d0/d1/d4/d5,-(sp)	;48A7CC00
	bsr.s	adrCd00A3D0	;610C
	movem.w	(sp)+,d0/d1/d4/d5	;4C9F0033
	tst.w	d0	;4A40
	bne.s	adrCd00A39A	;66CE
	moveq	#-$01,d6	;7CFF
	moveq	#$01,d2	;7401
adrCd00A3D0:
	move.w	d1,d3	;3601
	asl.w	#$02,d3	;E543
	move.w	d0,d7	;3E00
	beq.s	adrCd00A3E0	;6708
	addq.w	#$02,d3	;5443
	lsr.w	#$01,d7	;E24F
	bne.s	adrCd00A3E0	;6602
	not.l	d6	;4686
adrCd00A3E0:
	btst	d2,-$0015(a3)	;052BFFEB
	beq.s	adrCd00A3E8	;6702
	addq.w	#$01,d3	;5243
adrCd00A3E8:
	moveq	#$00,d7	;7E00
	move.b	adrB_00A418(pc,d3.w),d7	;1E3B302C
	swap	d7	;4847
	move.b	adrB_00A424(pc,d3.w),d7	;1E3B3032
	add.b	adrB_00A430(pc,d3.w),d5	;DA3B303A
	add.w	d3,d3	;D643
	lea	adrEA00A4F2.l,a2	;45F90000A4F2
	lea	_GFX_Dragon.l,a1	;43F900048960
	add.w	$00(a2,d3.w),a1	;D2F23000
	tst.w	d6	;4A46
	bpl.s	adrCd00A410	;6A02
	addq.w	#$01,d3	;5243
adrCd00A410:
	add.b	adrB_00A43C(pc,d3.w),d4	;D83B302A
	bra	adrCd00A6CA	;600002B4

adrB_00A418:
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
adrB_00A424:
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
adrB_00A430:
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
adrB_00A43C:
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
adrB_00A454:
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
adrB_00A463:
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$81	;81
adrB_00A467:
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

adrCd00A476:
	move.w	d1,d2	;3401
	add.w	d2,d2	;D442
	add.w	d1,d2	;D441
	moveq	#$00,d6	;7C00
	move.b	adrB_00A463(pc,d0.w),d3	;163B00E3
	bpl.s	adrCd00A488	;6A04
	moveq	#-$01,d6	;7CFF
	moveq	#$01,d3	;7601
adrCd00A488:
	add.b	d3,d2	;D403
	moveq	#$00,d7	;7E00
	move.b	adrB_00A454(pc,d2.w),d7	;1E3B20C6
	swap	d7	;4847
	move.b	adrB_00A467(pc,d2.w),d7	;1E3B20D3
	add.w	d2,d2	;D442
	lea	adrEA00A4D4.l,a2	;45F90000A4D4
	lea	_GFX_Dragon.l,a1	;43F900048960
	add.w	$00(a2,d2.w),a1	;D2F22000
	movem.l	d0/d1/d4/d5/d7/a1,-(sp)	;48E7CD40
	bsr	adrCd00A6CA	;6100021C
	movem.l	(sp)+,d0/d1/d4/d5/d7/a1	;4CDF02B3
	btst	#$00,d0	;08000000
	bne.s	adrCd00A4CC	;6612
	moveq	#-$01,d6	;7CFF
	movem.w	d0/d1/d4/d5,-(sp)	;48A7CC00
	add.b	adrB_00A4CE(pc,d1.w),d4	;D83B100C
	bsr	adrCd00A6CA	;61000204
	movem.w	(sp)+,d0/d1/d4/d5	;4C9F0033
adrCd00A4CC:
	rts	;4E75

adrB_00A4CE:
	dc.b	$20	;20
	dc.b	$0E	;0E
	dc.b	$10	;10
	dc.b	$07	;07
	dc.b	$04	;04
	dc.b	$00	;00
adrEA00A4D4:
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
adrEA00A4F2:
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

Draw_Behemoth:
	move.w	#$FFFF,adrW_00B4BE.l	;33FCFFFF0000B4BE
	lea	MonsterColours_Behemoth.l,a0	;41F90000A52E
	moveq	#$06,d3	;7606
	bsr	MonsterColourGrading	;6100F978
	lea	adrEA00A668.l,a0	;41F90000A668
	bsr.s	adrCd00A54C	;6126
	clr.w	adrW_00B4BE.l	;42790000B4BE
	rts	;4E75

MonsterColours_Behemoth:
	dc.w	$090B	;090B
	dc.w	$0A08	;0A08
	dc.w	$0304	;0304
	dc.w	$0507	;0507
LargeMonsterSizeScales:
	dc.w	$0000	;0000
	dc.w	$0101	;0101
	dc.w	$0203	;0203

Draw_Entropy:
	move.l	#$04080C,adrEA00B4C0.l	;23FC0004080C0000B4C0
	lea	adrEA00A604.l,a0	;41F90000A604
adrCd00A54C:
	move.b	LargeMonsterSizeScales(pc,d1.w),d1	;123B10E8
	lea	$0042(a0),a2	;45E80042

	move.l	$003E(a0),a1	;2268003E    *Fix stored address **  

	bsr	adrCd009CA2	;6100F748
	add.b	$16(a0,d1.w),d4	;D8301016
	move.w	d0,d2	;3400
	lsr.w	#$01,d2	;E24A
	bcc.s	adrCd00A56E	;6408
	add.w	d1,d2	;D441
	add.w	d1,d2	;D441
	add.b	$1A(a0,d2.w),d4	;D830201A
adrCd00A56E:
	movem.l	d0/d1/d4/d5/d7/a0/a1,-(sp)	;48E7CDC0
	bsr	adrCd00A6CA	;61000156
	movem.l	(sp),d0/d1/d4/d5/d7/a0/a1	;4CD703B3
	btst	#$00,d0	;08000000
	bne.s	adrCd00A58A	;660A
	moveq	#-$01,d6	;7CFF
	add.b	$22(a0,d1.w),d4	;D8301022
	bsr	adrCd00A6CA	;61000142
adrCd00A58A:
	movem.l	(sp)+,d0/d1/d4/d5/d7/a0/a1	;4CDF03B3
	cmpi.b	#$02,d1	;0C010002
	bcc.s	adrCd00A600	;646C
	lea	adrEA00B4C0.l,a6	;4DF90000B4C0
	moveq	#$00,d2	;7400
	moveq	#$00,d6	;7C00
	move.l	a0,-(sp)	;2F08
	bsr.s	adrCd00A5AE	;610C
	move.l	(sp)+,a0	;205F
	btst	#$00,d0	;08000000
	bne.s	adrCd00A600	;6656
	moveq	#$01,d2	;7401
	moveq	#-$01,d6	;7CFF
adrCd00A5AE:
	movem.w	d0/d1/d4/d5,-(sp)	;48A7CC00
	move.l	$003E(a0),a1	;2268003E
	add.w	d1,d1	;D241
	moveq	#$00,d3	;7600
	btst	d2,-$0015(a3)	;052BFFEB
	beq.s	adrCd00A5C4	;6704
	addq.w	#$01,d1	;5241
	moveq	#-$01,d3	;76FF
adrCd00A5C4:
	moveq	#$00,d7	;7E00
	move.b	$2A(a0,d1.w),d7	;1E30102A
	add.b	$26(a0,d1.w),d5	;DA301026
	add.w	d1,d1	;D241
	add.w	$5A(a0,d1.w),a1	;D2F0105A
	add.w	d1,d1	;D241
	lsr.w	#$01,d0	;E248
	bcc.s	adrCd00A5EE	;6414
	addq.w	#$02,d1	;5441
	tst.w	d3	;4A43
	bpl.s	adrCd00A5E8	;6A08
	tst.w	-$0002(a0)	;4A68FFFE
	beq.s	adrCd00A5E8	;6702
	not.w	d6	;4646
adrCd00A5E8:
	tst.w	d0	;4A40
	bne.s	adrCd00A5EE	;6602
	not.w	d6	;4646
adrCd00A5EE:
	tst.w	d6	;4A46
	beq.s	adrCd00A5F4	;6702
	addq.w	#$01,d1	;5241
adrCd00A5F4:
	add.b	$2E(a0,d1.w),d4	;D830102E
	bsr	adrCd00AD34	;6100073A
	movem.w	(sp)+,d0/d1/d4/d5	;4C9F0033
adrCd00A600:
	rts	;4E75

;fiX Label expected
	dc.w	$FFFF	;FFFF
adrEA00A604:
	dc.w	$1008	;1008
	dc.w	$F8F8	;F8F8
	dc.w	$0000	;0000
	dc.w	$3223	;3223
	dc.w	$1A14	;1A14
	dc.w	$0002	;0002
	dc.w	$0000	;0000
	dc.w	$0100	;0100
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FAFB	;FAFB
	dc.w	$FBFB	;FBFB
	dc.w	$FDF1	;FDF1
	dc.w	$FEF7	;FEF7
	dc.w	$03F4	;03F4
	dc.w	$04FF	;04FF
	dc.w	$0D03	;0D03
	dc.w	$0703	;0703
	dc.w	$FEF2	;FEF2
	dc.w	$FCF3	;FCF3
	dc.w	$1914	;1914
	dc.w	$110E	;110E
	dc.w	$F617	;F617
	dc.w	$120E	;120E
	dc.w	$F419	;F419
	dc.w	$051B	;051B
	dc.w	$F90A	;F90A
	dc.w	$0B05	;0B05
	dc.w	$F80B	;F80B
	dc.w	$040C	;040C


	;dc.w	$0004	;0004
	;dc.w	$B290	;B290
	dc.l	_GFX_Entropy
	
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
adrEA00A668:
	dc.w	$0C05	;0C05
	dc.w	$F6F6	;F6F6
	dc.w	$0000	;0000
	dc.w	$2B1E	;2B1E
	dc.w	$1410	;1410
	dc.w	$0102	;0102
	dc.w	$0100	;0100
	dc.w	$0100	;0100
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$F1F6	;F1F6
	dc.w	$F7F7	;F7F7
	dc.w	$FF00	;FF00
	dc.w	$FFFF	;FFFF
	dc.w	$04FA	;04FA
	dc.w	$0505	;0505
	dc.w	$0F0F	;0F0F
	dc.w	$0F0B	;0F0B
	dc.w	$FEF1	;FEF1
	dc.w	$FBF2	;FBF2
	dc.w	$1414	;1414
	dc.w	$0D0D	;0D0D
	dc.w	$F42B	;F42B
	dc.w	$0719	;0719
	dc.w	$F42B	;F42B
	dc.w	$0719	;0719
	dc.w	$F817	;F817
	dc.w	$050B	;050B
	dc.w	$F817	;F817
	dc.w	$050B	;050B
	dc.w	$0004	;0004
	dc.w	$66D0	;66D0
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
adrEA00A6C2:
	dc.w	$11B8	;11B8
	dc.w	$1260	;1260
	dc.w	$1308	;1308
	dc.w	$1378	;1378

adrCd00A6CA:
	add.w	$0008(a5),d5	;DA6D0008
	move.b	d4,d6	;1C04
	add.b	#$60,d4	;06040060
	ext.w	d6	;4886
	asr.w	#$04,d6	;E846
	move.l	a3,-(sp)	;2F0B
	tst.l	d6	;4A86
	bmi.s	adrCd00A6E4	;6B06
	bsr	adrCd00AE5E	;6100077E
	bra.s	adrCd00A6E8	;6004

adrCd00A6E4:
	bsr	adrCd00AF1E	;61000838
adrCd00A6E8:
	move.l	(sp)+,a3	;265F
	rts	;4E75

adrCd00A6EC:
	bsr	adrCd00995E	;6100F270
	tst.b	d1	;4A01
	bpl.s	adrCd00A6F6	;6A02
	rts	;4E75

adrCd00A6F6:
	move.b	-$0017(a3),d0	;102BFFE9
	bmi	Draw_Spell	;6B00F4F4
	move.w	-$000A(a3),d0	;302BFFF6
	btst	#$00,d0	;08000000
	bne.s	adrCd00A70A	;6602
	addq.w	#$02,d0	;5440
adrCd00A70A:
	add.b	-$001B(a3),d0	;D02BFFE5
	and.w	#$0003,d0	;02400003
	moveq	#$00,d2	;7400
	move.b	-$0017(a3),d2	;142BFFE9
	sub.b	#$64,d2	;04020064
	bcs.s	Draw_Character	;6526
	cmpi.b	#$02,d2	;0C020002
	beq	Draw_Beholder	;6700FA66
	bcs	Draw_Summon	;6500F5AA
	subq.b	#$03,d2	;5702
	lea	Creatures_LookupTable.l,a1	;43F90000A73A
	add.w	d2,d2	;D442
	add.w	$00(a1,d2.w),a1	;D2F12000
	jmp	(a1)	;4ED1

Creatures_LookupTable:
	dc.w	Draw_Behemoth-Creatures_LookupTable	;FDD0
	dc.w	Draw_Crab-Creatures_LookupTable	;F7C0
	dc.w	Draw_BigDragon-Creatures_LookupTable	;FC12
	dc.w	Draw_LittleDragon-Creatures_LookupTable	;FBF6
	dc.w	Draw_Entropy-Creatures_LookupTable	;FE02

Draw_Character:
	moveq	#$00,d2	;7400
	move.b	-$0017(a3),d2	;142BFFE9
	lea	CharacterHeadSel.l,a0	;41F90000A91A
	move.b	$00(a0,d2.w),-$0018(a3)	;17702000FFE8
	move.w	d1,d2	;3401
	asl.w	#$02,d2	;E542
	add.w	d0,d2	;D440
	add.w	d2,d2	;D442
	move.w	d2,d3	;3602
	asl.w	#$02,d2	;E542
	add.w	d3,d2	;D443
	moveq	#$00,d6	;7C00
	move.b	-$0017(a3),d3	;162BFFE9
	cmpi.b	#$10,d3	;0C030010
	bcc	adrCd00A7F2	;64000082
	move.w	d3,d7	;3E03
	asl.b	#$04,d7	;E907
	lea	PocketContents+$2.l,a0	;41F90000ED2C
	move.b	$00(a0,d7.w),d7	;1E307000
	cmpi.w	#$0024,d7	;0C470024
	bcc.s	adrCd00A7F2	;646C
	sub.w	#$001B,d7	;0447001B
	bcs.s	adrCd00A7F2	;6566
	move.b	adrB_00A792(pc,d7.w),d6	;1C3B7004
	bra.s	adrCd00A7F2	;6060

adrB_00A792:
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$42	;42
	dc.b	$43	;43
	dc.b	$82	;82
	dc.b	$83	;83
	dc.b	$C2	;C2
	dc.b	$C3	;C3
	dc.b	$00	;00
CharacterBodySel:
	INCBIN bw-data/characters.bodies

adrCd00A7F2:
	move.b	CharacterBodySel(pc,d3.w),d3	;163B30A8
	beq.s	adrCd00A808	;6710
	tst.w	d6	;4A46
	beq.s	adrCd00A808	;670C
	cmpi.w	#$0003,d3	;0C430003
	bcc.s	adrCd00A804	;6402
	moveq	#$03,d3	;7603
adrCd00A804:
	add.b	d6,d3	;D606
	add.b	d6,d3	;D606
adrCd00A808:
	move.b	d6,-$001C(a3)			;1746FFE4
	lea	adrEA00A88E.l,a0		;41F90000A88E
	and.w	#$000F,d3			;0243000F
	mulu	#$000A,d3			;C6FC000A
	lea	$02(a0,d3.w),a0			;41F03002
	lea	adrEA018804.l,a1		;43F900018804
	tst.w	-$0002(a0)			;4A68FFFE
	beq.s	adrCd00A830			;6706
	lea	adrEA018944.l,a1		;43F900018944
adrCd00A830:
	move.l	a0,-(sp)	;2F08
	move.l	a1,-(sp)	;2F09
	move.w	d2,-(sp)	;3F02
	move.w	d5,-(sp)	;3F05
	move.w	d4,-(sp)	;3F04
	move.w	d1,-(sp)	;3F01
	move.w	d0,-(sp)	;3F00
	cmpi.w	#$0004,d1	;0C410004
	beq	adrCd00AC6E	;6700042A
	cmpi.w	#$0005,d1	;0C410005
	beq	adrCd00AC9C	;67000450
	tst.b	-$0019(a3)	;4A2BFFE7
	bmi.s	adrCd00A876	;6B22
	cmpi.w	#$0003,d1	;0C410003
	bcc.s	adrCd00A876	;641C
	bsr	RandomGen_BytewithOffset	;6100AD50
	move.b	d0,d1	;1200
	and.w	#$000C,d1	;0241000C
	bne.s	adrCd00A876	;6610
	and.w	#$0003,d0	;02400003
	beq.s	adrCd00A876	;670A
	subq.w	#$02,d0	;5540
	add.b	$0005(sp),d0	;D02F0005
	move.b	d0,$0005(sp)	;1F400005
adrCd00A876:
	moveq	#$00,d0	;7000
adrCd00A878:
	move.w	d0,-(sp)	;3F00
	bsr	adrCd00A998	;6100011C
	move.w	(sp)+,d0	;301F
	addq.w	#$01,d0	;5240
	cmpi.w	#$0005,d0	;0C400005
	bcs.s	adrCd00A878	;65F0
	add.w	#$0012,sp	;DEFC0012
	rts	;4E75

adrEA00A88E:
	dc.w	$0000	;0000
	dc.w	$2BE0	;2BE0
	dc.w	$10E0	;10E0
	dc.w	$3378	;3378
	dc.w	$4428	;4428
	dc.w	$0000	;0000
	dc.w	$2448	;2448
	dc.w	$0CA8	;0CA8
	dc.w	$3828	;3828
	dc.w	$47D0	;47D0
	dc.w	$0000	;0000
	dc.w	$1518	;1518
	dc.w	$0000	;0000
	dc.w	$3378	;3378
	dc.w	$3CD8	;3CD8
	dc.w	$0000	;0000
	dc.w	$1518	;1518
	dc.w	$0438	;0438
	dc.w	$3378	;3378
	dc.w	$4080	;4080
	dc.w	$0001	;0001
	dc.w	$4EC0	;4EC0
	dc.w	$4B78	;4B78
	dc.w	$6C60	;6C60
	dc.w	$7098	;7098
	dc.w	$0000	;0000
	dc.w	$1518	;1518
	dc.w	$0438	;0438
	dc.w	$3378	;3378
	dc.w	$4080	;4080
	dc.w	$0001	;0001
	dc.w	$64F8	;64F8
	dc.w	$4B78	;4B78
	dc.w	$6C60	;6C60
	dc.w	$7410	;7410
	dc.w	$0000	;0000
	dc.w	$1CB0	;1CB0
	dc.w	$0870	;0870
	dc.w	$3378	;3378
	dc.w	$4428	;4428
	dc.w	$0001	;0001
	dc.w	$5D90	;5D90
	dc.w	$4B78	;4B78
	dc.w	$6C60	;6C60
	dc.w	$7410	;7410
	dc.w	$0000	;0000
	dc.w	$1CB0	;1CB0
	dc.w	$0870	;0870
	dc.w	$3378	;3378
	dc.w	$4428	;4428
	dc.w	$0001	;0001
	dc.w	$5628	;5628
	dc.w	$4B78	;4B78
	dc.w	$6C60	;6C60
	dc.w	$7788	;7788
	dc.w	$0000	;0000
	dc.w	$1518	;1518
	dc.w	$0870	;0870
	dc.w	$3378	;3378
	dc.w	$4080	;4080
	dc.w	$0000	;0000
	dc.w	$7B00	;7B00
	dc.w	$0000	;0000
	dc.w	$3378	;3378
	dc.w	$8298	;8298
	dc.w	$0000	;0000
	dc.w	$7B00	;7B00
	dc.w	$0870	;0870
	dc.w	$3378	;3378
	dc.w	$8298	;8298
CharacterHeadSel:
	INCBIN bw-data/characters.heads

adrW_00A970:
	dc.w	$00A0	;00A0
adrW_00A972:
	dc.w	$00AC	;00AC
	dc.w	$00C4	;00C4
	dc.w	$00D0	;00D0
	dc.w	$00E8	;00E8
	dc.w	$00F4	;00F4
	dc.w	$010C	;010C
	dc.w	$0118	;0118
	dc.w	$010C	;010C
	dc.w	$0118	;0118
adrB_00A984:
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$81	;81
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$81	;81
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$81	;81
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$80	;80
	dc.b	$01	;01
	dc.b	$80	;80
	dc.b	$81	;81
	dc.b	$00	;00
	dc.b	$FF	;FF

adrCd00A998:
	move.w	d0,d2	;3400
	asl.w	#$02,d2	;E542
	move.w	adrW_00A970(pc,d2.w),d1	;323B20D2
	move.w	adrW_00A972(pc,d2.w),d3	;363B20D0
	move.l	$0010(sp),a0	;206F0010
	lea	$00(a0,d1.w),a1	;43F01000
	lea	$00(a0,d3.w),a2	;45F03000
	add.w	$000E(sp),a0	;D0EF000E
	add.w	$0006(sp),d2	;D46F0006
	moveq	#$00,d6	;7C00
	move.b	adrB_00A984(pc,d2.w),d2	;143B20C8
	bpl.s	adrCd00A9C2	;6A02
	subq.w	#$01,d6	;5346
adrCd00A9C2:
	cmpi.b	#$FF,d2	;0C0200FF
	bne.s	adrCd00A9CA	;6602
	rts	;4E75

adrCd00A9CA:
	cmpi.w	#$0003,d0	;0C400003
	bcs.s	adrCd00A9DC	;650C
	move.w	d0,d1	;3200
	subq.w	#$03,d1	;5741
	btst	d1,-$0015(a3)	;032BFFEB
	beq.s	adrCd00A9DC	;6702
	moveq	#$02,d2	;7402
adrCd00A9DC:
	and.w	#$007F,d2	;0242007F
	move.w	$0008(sp),d1	;322F0008
	add.w	d1,d1	;D241
	add.w	$0008(sp),d1	;D26F0008
	add.w	d1,d2	;D441
	moveq	#$00,d7	;7E00
	move.b	$00(a1,d2.w),d7	;1E312000
	add.w	d2,d2	;D442
	moveq	#$00,d1	;7200
	move.w	$00(a2,d2.w),d1	;32322000
	cmpi.w	#$0002,d0	;0C400002
	bne.s	adrCd00AA14	;6614
	move.b	-$0018(a3),d0	;102BFFE8
	mulu	#$0378,d0	;C0FC0378
	lea	$FFFFC190.l,a1	;43F9FFFFC190
	add.w	d0,d1	;D240
	add.w	d1,a1	;D2C1
	bra.s	adrCd00AA24	;6010

adrCd00AA14:
	bcs.s	adrCd00AA18	;6502
	moveq	#$02,d0	;7002
adrCd00AA18:
	move.l	$0014(sp),a1	;226F0014
	add.w	d0,d0	;D040
	add.w	$00(a1,d0.w),d1	;D2710000
	move.l	d1,a1	;2241
adrCd00AA24:
	move.w	$000C(sp),d5	;3A2F000C
	move.w	$000A(sp),d4	;382F000A
	move.w	$0004(sp),d0	;302F0004
	add.w	d0,d0	;D040
	add.b	$00(a0,d0.w),d4	;D8300000
	add.b	$01(a0,d0.w),d5	;DA300001
	lea	adrEA00ABF6.l,a6	;4DF90000ABF6
	cmpi.w	#$0004,d0	;0C400004
	bcs.s	adrCd00AA92	;654C
	bne.s	adrCd00AA4E	;6606
	moveq	#$00,d0	;7000
	bra	adrCd00AADC	;60000090

adrCd00AA4E:
	move.w	$0004(sp),d1	;322F0004
	subq.w	#$03,d1	;5741
	btst	d1,-$0015(a3)	;032BFFEB
	beq.s	adrCd00AA90	;6736
	move.w	$0008(sp),d1	;322F0008
	subq.w	#$06,d0	;5D40
	add.w	d0,d0	;D040
	lea	adrEA00AAFC.l,a0	;41F90000AAFC
	cmp.l	#adrEA018944,$0010(sp)	;0CAF000189440010
	bne.s	adrCd00AA76	;6604
	add.w	#$0024,a0	;D0FC0024
adrCd00AA76:
	sub.b	$00(a0,d1.w),d5	;9A301000
	addq.w	#$04,a0	;5848
	asl.w	#$03,d1	;E741
	add.w	$0006(sp),d1	;D26F0006
	add.w	d1,d0	;D041
	add.b	$00(a0,d0.w),d4	;D8300000
	btst	#$00,d1	;08010000
	beq.s	adrCd00AA90	;6702
	not.w	d6	;4646
adrCd00AA90:
	moveq	#$04,d0	;7004
adrCd00AA92:
	moveq	#$00,d1	;7200
	move.b	-$001C(a3),d1	;122BFFE4
	beq	adrCd00AAD8	;6700003E
	subq.b	#$01,d1	;5301
	move.b	d1,d2	;1401
	asl.b	#$03,d1	;E701
	add.b	d2,d1	;D202
	asl.b	#$02,d1	;E501
	move.l	$0014(sp),a6	;2C6F0014
	addq.w	#$08,d1	;5041
	tst.w	-$0002(a6)	;4A6EFFFE
	bne.s	adrCd00AABC	;660A
	subq.w	#$04,d1	;5941
	cmp.w	#$2BE0,(a6)	;0C562BE0
	bne.s	adrCd00AABC	;6602
	subq.w	#$04,d1	;5941
adrCd00AABC:
	lea	adrEA00ABA6.l,a0	;41F90000ABA6
	add.w	d1,a0	;D0C1
	move.w	d0,d1	;3200
	add.w	d1,d1	;D241
	add.w	d0,d1	;D240
	add.w	d1,d1	;D241
	cmp.b	#$FF,$00(a0,d1.w)	;0C3000FF1000
	beq.s	adrCd00AAD8	;6704
	bsr.s	adrCd00AB44	;616E
	bra.s	adrCd00AAF8	;6020

adrCd00AAD8:
	add.w	d0,d0	;D040
	addq.w	#$04,d0	;5840
adrCd00AADC:
	moveq	#$00,d1	;7200
	move.b	-$0017(a3),d1	;122BFFE9
	asl.w	#$02,d1	;E541
	moveq	#$00,d2	;7400
	move.b	-$0017(a3),d2	;142BFFE9
	add.w	d2,d1	;D242
	asl.w	#$02,d1	;E541
	add.w	d1,d0	;D041
	lea	CharacterColours.l,a6	;4DF9000351C8
	add.w	d0,a6	;DCC0
adrCd00AAF8:
	bra	adrCd00AD2E	;60000234

adrEA00AAFC:
	dc.w	$0806	;0806
	dc.w	$0605	;0605
	dc.w	$FC00	;FC00
	dc.w	$04FC	;04FC
	dc.w	$0404	;0404
	dc.w	$FC00	;FC00
	dc.w	$FD00	;FD00
	dc.w	$03FA	;03FA
	dc.w	$0306	;0306
	dc.w	$FD00	;FD00
	dc.w	$FE00	;FE00
	dc.w	$02F9	;02F9
	dc.w	$0207	;0207
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$02F8	;02F8
	dc.w	$0207	;0207
	dc.w	$FE00	;FE00
	dc.w	$0806	;0806
	dc.w	$0605	;0605
	dc.w	$FD00	;FD00
	dc.w	$03FA	;03FA
	dc.w	$0306	;0306
	dc.w	$FD00	;FD00
	dc.w	$FE00	;FE00
	dc.w	$02F8	;02F8
	dc.w	$0207	;0207
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$02F8	;02F8
	dc.w	$0208	;0208
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$02F7	;02F7
	dc.w	$0209	;0209
	dc.w	$FE00	;FE00

adrCd00AB44:
	lea	adrEA00B4C0.l,a6	;4DF90000B4C0
	move.l	$00(a0,d1.w),(a6)	;2CB01000
	move.b	-$001C(a3),d1	;122BFFE4
	rol.b	#$02,d1	;E519
	and.w	#$0003,d1	;02410003
	beq.s	adrCd00AB7C	;6722
	move.b	adrB_00ABA2(pc,d1.w),d1	;123B1046
	moveq	#$03,d2	;7403
adrLp00AB60:
	move.b	d1,d3	;1601
	cmp.b	#$04,$00(a6,d2.w)	;0C3600042000
	beq.s	adrCd00AB74	;670A
	subq.b	#$01,d3	;5303
	cmp.b	#$03,$00(a6,d2.w)	;0C3600032000
	bne.s	adrCd00AB78	;6604
adrCd00AB74:
	move.b	d3,$00(a6,d2.w)	;1D832000
adrCd00AB78:
	dbra	d2,adrLp00AB60	;51CAFFE6
adrCd00AB7C:
	lea	adrEA00AC12.l,a0	;41F90000AC12
	move.b	-$0018(a3),d1	;122BFFE8
	asl.w	#$02,d1	;E541
	add.w	d1,a0	;D0C1
	moveq	#$03,d2	;7403
adrLp00AB8C:
	move.b	$00(a6,d2.w),d1	;12362000
	bpl.s	adrCd00AB9C	;6A0A
	and.w	#$0003,d1	;02410003
	move.b	$00(a0,d1.w),$00(a6,d2.w)	;1DB010002000
adrCd00AB9C:
	dbra	d2,adrLp00AB8C	;51CAFFEE
	rts	;4E75

adrB_00ABA2:
	dc.b	$00	;00
	dc.b	$08	;08
	dc.b	$06	;06
	dc.b	$0B	;0B
adrEA00ABA6:
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
adrEA00ABF6:
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
adrEA00AC12:
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
adrEA00AC52:
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
adrEA00AC5E:
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

adrCd00AC6E:
	move.w	-$0002(a0),-(sp)	;3F28FFFE
	moveq	#$00,d3	;7600
	move.w	$0006(a0),d3	;36280006
	tst.w	(sp)	;4A57
	beq.s	adrCd00AC8C	;6710
	moveq	#$14,d7	;7E14
	move.w	#$00A8,d2	;343C00A8
	lea	adrEA018A74.l,a0	;41F900018A74
	bra	adrCd00ACCC	;60000042

adrCd00AC8C:
	moveq	#$15,d7	;7E15
	move.w	#$00B0,d2	;343C00B0
	lea	adrEA018934.l,a0	;41F900018934
	bra	adrCd00ACCC	;60000032

adrCd00AC9C:
	move.w	-$0002(a0),-(sp)	;3F28FFFE
	moveq	#$00,d3	;7600
	move.w	$0006(a0),d3	;36280006
	tst.w	(sp)	;4A57
	beq.s	adrCd00ACBC	;6712
	moveq	#$0F,d7	;7E0F
	move.w	#$0080,d2	;343C0080
	lea	adrEA018A7C.l,a0	;41F900018A7C
	add.w	#$01F8,d3	;064301F8
	bra.s	adrCd00ACCC	;6010

adrCd00ACBC:
	moveq	#$10,d7	;7E10
	move.w	#$0088,d2	;343C0088
	lea	adrEA01893C.l,a0	;41F90001893C
	add.w	#$0210,d3	;06430210
adrCd00ACCC:
	move.l	d3,a1	;2243
	add.w	d0,d0	;D040
	add.b	$00(a0,d0.w),d4	;D8300000
	add.b	$01(a0,d0.w),d5	;DA300001
	moveq	#$00,d6	;7C00
	cmpi.w	#$0006,d0	;0C400006
	bne.s	adrCd00ACE4	;6604
	subq.w	#$01,d6	;5346
	subq.w	#$04,d0	;5940
adrCd00ACE4:
	lsr.w	#$01,d0	;E248
	mulu	d0,d2	;C4C0
	add.w	d2,a1	;D2C2
	moveq	#$00,d1	;7200
	move.b	-$001C(a3),d1	;122BFFE4
	beq.s	adrCd00AD0E	;671C
	and.w	#$0003,d1	;02410003
	asl.w	#$02,d1	;E541
	lea	adrEA00AC52.l,a0	;41F90000AC52
	tst.w	(sp)	;4A57
	beq.s	adrCd00AD08	;6706
	lea	adrEA00AC5E.l,a0	;41F90000AC5E
adrCd00AD08:
	bsr	adrCd00AB44	;6100FE3A
	bra.s	adrCd00AD26	;6018

adrCd00AD0E:
	move.b	-$0017(a3),d1	;122BFFE9
	asl.w	#$02,d1	;E541
	moveq	#$00,d0	;7000
	move.b	-$0017(a3),d0	;102BFFE9
	add.w	d0,d1	;D240
	asl.w	#$02,d1	;E541
	lea	CharacterColours+$10.l,a6	;4DF9000351D8
	add.w	d1,a6	;DCC1
adrCd00AD26:
	bsr.s	adrCd00AD2E	;6106
	add.w	#$0014,sp	;DEFC0014
	rts	;4E75

adrCd00AD2E:
	add.l	#_GFX_Bodies,a1	;D3FC000396F0	;Long Addr replaced with Symbol
adrCd00AD34:
	move.w	d5,d0	;3005
	add.w	d7,d0	;D047
	sub.w	adrW_00AD64.l,d0	;90790000AD64
	bcs.s	adrCd00AD42	;6502
	sub.w	d0,d7	;9E40
adrCd00AD42:
	swap	d7	;4847
	move.b	d4,d7	;1E04
	ext.w	d7	;4887
	move.l	-$0008(a3),a0	;206BFFF8
	mulu	#$0028,d5	;CAFC0028
	and.w	#$FFF0,d7	;0247FFF0
	asr.w	#$03,d7	;E647
	add.w	d7,d5	;DA47
	add.w	d5,a0	;D0C5
	asr.w	#$01,d7	;E247
	move.l	a3,-(sp)	;2F0B
	bsr.s	adrCd00AD90	;6130
	move.l	(sp)+,a3	;265F
	rts	;4E75

adrW_00AD64:
	dc.w	$004B	;004B

adrCd00AD66:
	lea	adrEA01684C.l,a6	;4DF90001684C
adrCd00AD6C:
	moveq	#$00,d2	;7400
	move.b	d0,d2	;1400
	move.b	$00(a6,d2.w),d0	;10362000
	ror.w	#$08,d0	;E058
	move.b	d0,d2	;1400
	move.b	$00(a6,d2.w),d0	;10362000
	swap	d0	;4840
	move.b	d0,d2	;1400
	move.b	$00(a6,d2.w),d0	;10362000
	ror.w	#$08,d0	;E058
	move.b	d0,d2	;1400
	move.b	$00(a6,d2.w),d0	;10362000
	swap	d0	;4840
	rts	;4E75

adrCd00AD90:
	and.w	#$000F,d4	;0244000F
	swap	d6	;4846
	move.w	d7,d6	;3C07
	moveq	#-$01,d5	;7AFF
	lsr.w	d4,d5	;E86D
	move.w	d5,d0	;3005
	swap	d5	;4845
	move.w	d0,d5	;3A00
	swap	d7	;4847
adrLp00ADA4:
	swap	d7	;4847
	move.w	d6,d7	;3E06
	move.l	(a1)+,d0	;2019
	move.l	(a1)+,d1	;2219
	tst.l	d6	;4A86
	bpl.s	adrCd00ADBC	;6A0C
	move.l	a6,a2	;244E
	bsr.s	adrCd00AD66	;61B2
	exg	d0,d1	;C141
	bsr.s	adrCd00AD6C	;61B4
	exg	d0,d1	;C141
	move.l	a2,a6	;2C4A
adrCd00ADBC:
	ror.l	d4,d0	;E8B8
	ror.l	d4,d1	;E8B9
	move.l	d0,a2	;2440
	move.l	d1,a3	;2641
	and.l	d5,d0	;C085
	and.l	d5,d1	;C285
	not.l	d5	;4685
	or.l	d5,d0	;8085
	or.l	d5,d1	;8285
	bsr	adrCd00AE0A	;6100003A
	addq.w	#$01,d7	;5247
	move.l	a2,d0	;200A
	move.l	a3,d1	;220B
	and.l	d5,d0	;C085
	and.l	d5,d1	;C285
	not.l	d5	;4685
	or.l	d5,d0	;8085
	or.l	d5,d1	;8285
	swap	d0	;4840
	swap	d1	;4841
	move.l	d0,d2	;2400
	and.l	d1,d2	;C481
	addq.l	#$01,d2	;5282
	bne.s	adrCd00ADF2	;6604
	addq.w	#$02,a0	;5448
	bra.s	adrCd00ADF6	;6004

adrCd00ADF2:
	bsr	adrCd00AE0A	;61000016
adrCd00ADF6:
	add.w	#$0024,a0	;D0FC0024
	swap	d7	;4847
	dbra	d7,adrLp00ADA4	;51CFFFA6
	rts	;4E75

adrCd00AE02:
	cmpi.w	#$0008,d6	;0C460008
	bcc.s	adrCd00AE58	;6450
	bra.s	adrCd00AE14	;600A

adrCd00AE0A:
	cmpi.w	#$0008,d7	;0C470008
	bcc.s	adrCd00AE58	;6448
	bsr	adrCd00AFD0	;610001BE
adrCd00AE14:
	move.l	d1,d2	;2401
	and.l	d0,d2	;C480
	swap	d2	;4842
	and.l	d0,d2	;C480
	and.l	d1,d2	;C481
	not.l	d2	;4682
	and.l	d2,d0	;C082
	and.l	d2,d1	;C282
	not.l	d2	;4682
	move.w	$5DC0(a0),d3	;36285DC0
	and.w	d2,d3	;C642
	or.w	d1,d3	;8641
	move.w	d3,$5DC0(a0)	;31435DC0
	swap	d1	;4841
	move.w	$3E80(a0),d3	;36283E80
	and.w	d2,d3	;C642
	or.w	d1,d3	;8641
	move.w	d3,$3E80(a0)	;31433E80
	move.w	$1F40(a0),d3	;36281F40
	and.w	d2,d3	;C642
	or.w	d0,d3	;8640
	move.w	d3,$1F40(a0)	;31431F40
	swap	d0	;4840
	move.w	(a0),d3	;3610
	and.w	d2,d3	;C642
	or.w	d0,d3	;8640
	move.w	d3,(a0)+	;30C3
	rts	;4E75

adrCd00AE58:
	addq.w	#$02,a0	;5448
	rts	;4E75

adrW_00AE5C:
	dc.w	$0000	;0000

adrCd00AE5E:
	clr.w	adrW_00AE5C.l	;42790000AE5C
	bra.s	adrCd00AE6E	;6008

adrCd00AE66:
	move.w	#$FFFF,adrW_00AE5C.l	;33FCFFFF0000AE5C
adrCd00AE6E:
	move.w	d4,d1	;3204
	and.w	#$FFF7,d4	;0244FFF7
	bsr	BW_xy_to_offset	;61002DDE
	move.w	d1,d4	;3801
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	d0,a0	;D0C0
	and.w	#$000F,d4	;0244000F
	moveq	#-$01,d5	;7AFF
	lsr.w	d4,d5	;E86D
	move.w	d5,d0	;3005
	swap	d5	;4845
	move.w	d0,d5	;3A00
	not.l	d5	;4685
	lea	adrEA00B4C0.l,a6	;4DF90000B4C0
adrLp00AE98:
	swap	d7	;4847
	move.w	d6,-(sp)	;3F06
	move.w	d7,-(sp)	;3F07
	move.l	d5,d2	;2405
	move.l	d5,d3	;2605
adrLp00AEA2:
	move.l	(a1)+,d0	;2019
	move.l	(a1)+,d1	;2219
	tst.w	adrW_00B4BE.l	;4A790000B4BE
	beq.s	adrCd00AEB2	;6704
	bsr	adrCd00AFD0	;61000120
adrCd00AEB2:
	ror.l	d4,d0	;E8B8
	ror.l	d4,d1	;E8B9
	move.l	d0,a2	;2440
	move.l	d1,a3	;2641
	not.l	d5	;4685
	and.l	d5,d0	;C085
	and.l	d5,d1	;C285
	not.l	d5	;4685
	or.l	d2,d0	;8082
	or.l	d3,d1	;8283
	bsr	adrCd00AE02	;6100FF3A
	addq.w	#$01,d6	;5246
	move.l	a2,d2	;240A
	move.l	a3,d3	;260B
	and.l	d5,d2	;C485
	and.l	d5,d3	;C685
	swap	d2	;4842
	swap	d3	;4843
	dbra	d7,adrLp00AEA2	;51CFFFC8
	move.w	(sp)+,d7	;3E1F
	not.l	d5	;4685
	or.l	d5,d2	;8485
	or.l	d5,d3	;8685
	not.l	d5	;4685
	move.l	d2,d0	;2002
	move.l	d3,d1	;2203
	and.l	d3,d2	;C483
	addq.l	#$01,d2	;5282
	bne.s	adrCd00AEF4	;6604
	addq.w	#$02,a0	;5448
	bra.s	adrCd00AEF8	;6004

adrCd00AEF4:
	bsr	adrCd00AE02	;6100FF0C
adrCd00AEF8:
	move.w	d7,d0	;3007
	add.w	d0,d0	;D040
	tst.w	adrW_00AE5C.l	;4A790000AE5C
	beq.s	adrCd00AF0E	;670A
	add.w	#$0098,a1	;D2FC0098
	move.w	d0,d6	;3C00
	asl.w	#$02,d6	;E546
	sub.w	d6,a1	;92C6
adrCd00AF0E:
	lea	$0024(a0),a0	;41E80024
	sub.w	d0,a0	;90C0
	move.w	(sp)+,d6	;3C1F
	swap	d7	;4847
	dbra	d7,adrLp00AE98	;51CFFF7E
	rts	;4E75

adrCd00AF1E:
	move.w	d4,d1	;3204
	and.w	#$FFF7,d4	;0244FFF7
	bsr	BW_xy_to_offset	;61002D2E
	move.w	d1,d4	;3801
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	d0,a0	;D0C0
	and.w	#$000F,d4	;0244000F
	moveq	#-$01,d5	;7AFF
	lsr.w	d4,d5	;E86D
	move.w	d5,d0	;3005
	swap	d5	;4845
	move.w	d0,d5	;3A00
	not.l	d5	;4685
adrLp00AF42:
	swap	d7	;4847
	move.w	d6,-(sp)	;3F06
	move.w	d7,-(sp)	;3F07
	move.w	d7,d2	;3407
	addq.w	#$01,d2	;5242
	asl.w	#$03,d2	;E742
	add.w	d2,a1	;D2C2
	move.l	d5,d2	;2405
	move.l	d5,d3	;2605
adrLp00AF54:
	move.l	d2,a2	;2442
	move.l	-(a1),d0	;2021
	bsr	adrCd00AD66	;6100FE0C
	move.l	d0,d1	;2200
	move.l	-(a1),d0	;2021
	bsr	adrCd00AD6C	;6100FE0A
	move.l	a2,d2	;240A
	lea	adrEA00B4C0.l,a6	;4DF90000B4C0
	bsr	adrCd00AFD0	;61000062
	ror.l	d4,d0	;E8B8
	ror.l	d4,d1	;E8B9
	move.l	d0,a2	;2440
	move.l	d1,a3	;2641
	not.l	d5	;4685
	and.l	d5,d0	;C085
	and.l	d5,d1	;C285
	not.l	d5	;4685
	or.l	d2,d0	;8082
	or.l	d3,d1	;8283
	bsr	adrCd00AE02	;6100FE7C
	addq.w	#$01,d6	;5246
	move.l	a2,d2	;240A
	move.l	a3,d3	;260B
	and.l	d5,d2	;C485
	and.l	d5,d3	;C685
	swap	d2	;4842
	swap	d3	;4843
	dbra	d7,adrLp00AF54	;51CFFFBC
	move.w	(sp)+,d7	;3E1F
	not.l	d5	;4685
	or.l	d5,d2	;8485
	or.l	d5,d3	;8685
	not.l	d5	;4685
	move.l	d2,d0	;2002
	move.l	d3,d1	;2203
	and.l	d3,d2	;C483
	addq.l	#$01,d2	;5282
	bne.s	adrCd00AFB2	;6604
	addq.w	#$02,a0	;5448
	bra.s	adrCd00AFB6	;6004

adrCd00AFB2:
	bsr	adrCd00AE02	;6100FE4E
adrCd00AFB6:
	move.w	d7,d0	;3007
	addq.w	#$01,d0	;5240
	add.w	d0,d0	;D040
	lea	$0026(a0),a0	;41E80026
	sub.w	d0,a0	;90C0
	asl.w	#$02,d0	;E540
	add.w	d0,a1	;D2C0
	move.w	(sp)+,d6	;3C1F
	swap	d7	;4847
	dbra	d7,adrLp00AF42	;51CFFF76
	rts	;4E75

adrCd00AFD0:
	movem.l	d2-d7,-(sp)	;48E73F00
	move.l	d0,d2	;2400
	swap	d2	;4842
	or.l	d0,d2	;8480
	not.l	d2	;4682
	beq.s	adrCd00B036	;6758
	move.l	d0,-(sp)	;2F00
	moveq	#$00,d4	;7800
	moveq	#$00,d5	;7A00
	move.w	d5,d7	;3E05
	move.l	d1,d3	;2601
	swap	d3	;4843
	or.l	d1,d3	;8681
	not.l	d3	;4683
	and.l	d2,d3	;C682
	beq.s	adrCd00AFF4	;6702
	bsr.s	adrCd00B03C	;6148
adrCd00AFF4:
	addq.w	#$01,d7	;5247
	move.l	d3,d0	;2003
	not.l	d0	;4680
	move.w	d1,d3	;3601
	swap	d3	;4843
	move.w	d1,d3	;3601
	not.l	d3	;4683
	and.l	d0,d3	;C680
	and.l	d2,d3	;C682
	beq.s	adrCd00B00A	;6702
	bsr.s	adrCd00B03C	;6132
adrCd00B00A:
	addq.w	#$01,d7	;5247
	move.l	d1,d3	;2601
	swap	d1	;4841
	move.w	d1,d3	;3601
	not.l	d3	;4683
	and.l	d0,d3	;C680
	and.l	d2,d3	;C682
	beq.s	adrCd00B01C	;6702
	bsr.s	adrCd00B03C	;6120
adrCd00B01C:
	addq.w	#$01,d7	;5247
	move.l	d1,d3	;2601
	swap	d1	;4841
	and.l	d1,d3	;C681
	and.l	d2,d3	;C682
	beq.s	adrCd00B02A	;6702
	bsr.s	adrCd00B03C	;6112
adrCd00B02A:
	not.l	d2	;4682
	move.l	(sp)+,d0	;201F
	and.l	d2,d0	;C082
	or.l	d4,d0	;8084
	and.l	d2,d1	;C282
	or.l	d5,d1	;8285
adrCd00B036:
	movem.l	(sp)+,d2-d7	;4CDF00FC
	rts	;4E75

adrCd00B03C:
	move.b	$00(a6,d7.w),d6	;1C367000
	beq.s	adrCd00B062	;6720
	add.w	d6,d6	;DC46
	add.w	d6,d6	;DC46
	and.w	#$000C,d6	;0246000C
	move.l	adrEA00B064(pc,d6.w),d6	;2C3B6018
	and.l	d3,d6	;CC83
	or.l	d6,d4	;8886
	move.b	$00(a6,d7.w),d6	;1C367000
	and.w	#$000C,d6	;0246000C
	move.l	adrEA00B064(pc,d6.w),d6	;2C3B6008
	and.l	d3,d6	;CC83
	or.l	d6,d5	;8A86
adrCd00B062:
	rts	;4E75

adrEA00B064:
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF

adrCd00B074:
	tst.w	-$000C(a3)	;4A6BFFF4
	bne	adrCd00B2A4	;6600022A
	move.w	d6,d0	;3006
	bsr	adrCd00B474	;610003F4
	swap	d3	;4843
	move.l	a3,-(sp)	;2F0B
	bsr	adrCd00B4E0	;61000458
	move.l	(sp)+,a3	;265F
adrCd00B08C:
	tst.b	-$0015(a3)	;4A2BFFEB
	beq.s	adrCd00B062	;67D0
	addq.b	#$01,-$0015(a3)	;522BFFEB
	beq	adrCd00B1E0	;67000148
	addq.b	#$01,-$0015(a3)	;522BFFEB
	beq	adrCd00B13C	;6700009C
	addq.b	#$01,-$0015(a3)	;522BFFEB
	beq.s	adrCd00B0EE	;6746
	lea	adrEA00B224.l,a0	;41F90000B224
	lea	adrEA00BE36.l,a2	;45F90000BE36
	lea	_GFX_Slots.l,a1	;43F9000287A0
	lea	adrEA00B204.l,a6	;4DF90000B204
	move.b	-$0012(a3),d1	;122BFFEE
	lsr.w	#$03,d1	;E649
	bsr	adrCd00B1D4	;6100010C
	btst	#$02,-$0012(a3)	;082B0002FFEE
	beq.s	adrCd00B0D4	;6702
	clr.b	d0	;4200
adrCd00B0D4:
	move.l	d0,adrEA00B4C0.l	;23C00000B4C0
	move.w	#$FFFF,adrW_00B4BE.l	;33FCFFFF0000B4BE
	bsr	adrCd00B410	;6100032C
	clr.w	adrW_00B4BE.l	;42790000B4BE
	rts	;4E75

adrCd00B0EE:
	lea	adrEA018C2E.l,a0	;41F900018C2E
	lea	adrEA00BEA6.l,a2	;45F90000BEA6
	lea	_GFX_Switches.l,a1	;43F9000284E8
	moveq	#$00,d0	;7000
	move.b	-$0012(a3),d1	;122BFFEE
	and.w	#$00F8,d1	;024100F8
	beq.s	adrCd00B122	;6716
	bsr	adrCd00B1C6	;610000B8
	btst	#$02,-$0012(a3)	;082B0002FFEE
	beq.s	adrCd00B122	;670A
	and.w	#$00FF,d0	;024000FF
	swap	d0	;4840
	move.b	$02(a6,d1.w),d0	;10361002
adrCd00B122:
	move.l	d0,adrEA00B4C0.l	;23C00000B4C0
	move.w	#$FFFF,adrW_00B4BE.l	;33FCFFFF0000B4BE
	bsr	adrCd00B410	;610002DE
	clr.w	adrW_00B4BE.l	;42790000B4BE
	rts	;4E75

adrCd00B13C:
	move.w	d6,-(sp)	;3F06
	lea	adrEA018BB0.l,a0	;41F900018BB0
	lea	adrEA00BD56.l,a2	;45F90000BD56
	lea	_GFX_Sign.l,a1	;43F900025CD8
	lea	adrEA00B264.l,a6	;4DF90000B264
	move.b	-$0012(a3),d1	;122BFFEE
	lsr.b	#$02,d1	;E409
	beq.s	adrCd00B16C	;670E
	cmpi.b	#$05,d1	;0C010005
	bcc.s	adrCd00B16C	;6408
	subq.b	#$01,d1	;5301
	bsr	adrCd00B1D4	;6100006C
	bra.s	adrCd00B16E	;6002

adrCd00B16C:
	bsr.s	adrCd00B1CC	;615E
adrCd00B16E:
	move.l	d0,adrEA00B4C0.l	;23C00000B4C0
	move.w	#$FFFF,adrW_00B4BE.l	;33FCFFFF0000B4BE
	bsr	adrCd00B410	;61000292
	clr.w	adrW_00B4BE.l	;42790000B4BE
	move.w	(sp)+,d6	;3C1F
	move.b	-$0012(a3),d1	;122BFFEE
	lsr.b	#$02,d1	;E409
	beq.s	adrCd00B19A	;670A
	cmpi.b	#$05,d1	;0C010005
	bcc.s	adrCd00B1C4	;642E
	subq.b	#$01,d1	;5301
	bra.s	adrCd00B1A4	;600A

adrCd00B19A:
	move.b	-$0019(a3),d1	;122BFFE7
	add.w	d1,d1	;D241
	sub.b	-$001A(a3),d1	;922BFFE6
adrCd00B1A4:
	and.w	#$0003,d1	;02410003
	mulu	#$0610,d1	;C2FC0610
	lea	_GFX_SignOverlay.l,a1	;43F900026CA8
	add.w	d1,a1	;D2C1
	lea	adrEA00BDC6.l,a2	;45F90000BDC6
	lea	adrEA00B284.l,a0	;41F90000B284
	bsr	adrCd00B410	;6100024E
adrCd00B1C4:
	rts	;4E75

adrCd00B1C6:
	lea	adrEA00B244.l,a6	;4DF90000B244
adrCd00B1CC:
	move.b	-$0019(a3),d1	;122BFFE7
	add.b	-$001A(a3),d1	;D22BFFE6
adrCd00B1D4:
	and.w	#$0007,d1	;02410007
	asl.w	#$02,d1	;E541
	move.l	$00(a6,d1.w),d0	;20361000
	rts	;4E75

adrCd00B1E0:
	tst.b	-$001F(a3)	;4A2BFFE1
	bne.s	adrCd00B1EE	;6608
	btst	#$03,-$0011(a3)	;082B0003FFEF
	bne.s	adrCd00B1C4	;66D6
adrCd00B1EE:
	lea	adrEA018B90.l,a0	;41F900018B90
	lea	adrEA00BCE6.l,a2	;45F90000BCE6
	lea	_GFX_Shelf.l,a1	;43F900025490
	bra	adrCd00B410	;6000020E

adrEA00B204:
	dc.w	$0004	;0004
	dc.w	$0506	;0506
	dc.w	$0004	;0004
	dc.w	$0B0D	;0B0D
	dc.w	$0004	;0004
	dc.w	$090C	;090C
	dc.w	$0004	;0004
	dc.w	$0708	;0708
	dc.w	$0004	;0004
	dc.w	$0304	;0304
	dc.w	$0004	;0004
	dc.w	$0806	;0806
	dc.w	$0004	;0004
	dc.w	$090A	;090A
	dc.w	$0004	;0004
	dc.w	$0A0B	;0A0B
adrEA00B224:
	dc.w	$0000	;0000
	dc.w	$0008	;0008
	dc.w	$0038	;0038
	dc.w	$0068	;0068
	dc.w	$0070	;0070
	dc.w	$00A8	;00A8
	dc.w	$00F0	;00F0
	dc.w	$0170	;0170
	dc.w	$01B8	;01B8
	dc.w	$0210	;0210
	dc.w	$0280	;0280
	dc.w	$0288	;0288
	dc.w	$0330	;0330
	dc.w	$0360	;0360
	dc.w	$03A0	;03A0
	dc.w	$03F8	;03F8
adrEA00B244:
	dc.w	$000D	;000D
	dc.w	$0708	;0708
	dc.w	$000E	;000E
	dc.w	$0506	;0506
	dc.w	$000E	;000E
	dc.w	$090C	;090C
	dc.w	$000E	;000E
	dc.w	$0B0D	;0B0D
	dc.w	$000E	;000E
	dc.w	$0304	;0304
	dc.w	$000E	;000E
	dc.w	$0804	;0804
	dc.w	$000E	;000E
	dc.w	$0A0C	;0A0C
	dc.w	$000D	;000D
	dc.w	$090A	;090A
adrEA00B264:
	dc.w	$0005	;0005
	dc.w	$060D	;060D
	dc.w	$0009	;0009
	dc.w	$0C0B	;0C0B
	dc.w	$0007	;0007
	dc.w	$0804	;0804
	dc.w	$000B	;000B
	dc.w	$0D0E	;0D0E
	dc.w	$0009	;0009
	dc.w	$0A0B	;0A0B
	dc.w	$0002	;0002
	dc.w	$0304	;0304
	dc.w	$0009	;0009
	dc.w	$0B0D	;0B0D
	dc.w	$000A	;000A
	dc.w	$0B0D	;0B0D
adrEA00B284:
	dc.w	$0000	;0000
	dc.w	$0038	;0038
	dc.w	$0070	;0070
	dc.w	$00E0	;00E0
	dc.w	$00E8	;00E8
	dc.w	$0128	;0128
	dc.w	$0130	;0130
	dc.w	$01C0	;01C0
	dc.w	$01C8	;01C8
	dc.w	$0238	;0238
	dc.w	$02D8	;02D8
	dc.w	$02E0	;02E0
	dc.w	$03C0	;03C0
	dc.w	$03F8	;03F8
	dc.w	$0440	;0440
	dc.w	$04B0	;04B0

adrCd00B2A4:
	moveq	#$00,d0	;7000
	move.b	adrB_00B2BA(pc,d6.w),d0	;103B6012
	bsr	adrCd00B474	;610001C8
	add.w	d3,a0	;D0C3
	swap	d3	;4843
	bsr	adrCd00B666	;610003B2
	bra	adrCd00B08C	;6000FDD4

adrB_00B2BA:
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
	dc.b	$17	;17
	dc.b	$00	;00
	dc.b	$01	;01
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
	dc.b	$18	;18
	dc.b	$19	;19
	dc.b	$1A	;1A
	dc.b	$1B	;1B
adrB_00B2D6:
	dc.b	$01	;01
	dc.b	$09	;09
	dc.b	$04	;04
	dc.b	$06	;06
	dc.b	$0D	;0D
	dc.b	$0C	;0C
	dc.b	$07	;07
	dc.b	$0E	;0E

adrCd00B2DE:
	cmp.b	#$01,-$0013(a3)	;0C2B0001FFED
	beq	adrCd00B384	;6700009E
	move.w	#$FFFF,adrW_00B4BE.l	;33FCFFFF0000B4BE
	move.l	#$0004000C,adrEA00B4C0.l	;23FC0004000C0000B4C0	;Long Addr replaced with Symbol
	moveq	#$00,d0	;7000
	move.b	-$0012(a3),d0	;102BFFEE
	btst	#$03,d0	;08000003
	bne.s	adrCd00B312	;660C
	lsr.b	#$04,d0	;E808
	move.b	adrB_00B2D6(pc,d0.w),d0	;103B00CC
	move.b	d0,adrB_00B4C2.l	;13C00000B4C2
adrCd00B312:
	lea	adrEA018C14.l,a0	;41F900018C14
	lea	adrEA00BC4E.l,a2	;45F90000BC4E
	lea	_GFX_LargeOpenDoor.l,a1	;43F90002D660
	btst	#$00,-$0012(a3)	;082B0000FFEE
	beq.s	adrCd00B340	;6714
	lea	_GFX_LargeMetalDoor.l,a1	;43F90002F1C8
	btst	#$01,-$0012(a3)	;082B0001FFEE
	beq.s	adrCd00B340	;6706
	lea	_GFX_PortCullis.l,a1	;43F900030650
adrCd00B340:
	move.b	-$0016(a3),d6	;1C2BFFEA
	cmpi.b	#$0E,d6	;0C06000E
	bcc.s	adrCd00B350	;6406
	bsr	adrCd0095B4	;6100E268
	bra.s	adrCd00B374	;6024

adrCd00B350:
	move.w	d6,d0	;3006
	subq.w	#$07,d0	;5F40
	cmpi.w	#$000B,d0	;0C40000B
	bne.s	adrCd00B370	;6616
	move.w	-$000A(a3),d1	;322BFFF6
	asl.w	#$02,d1	;E541
	eor.b	d1,-$0012(a3)	;B32BFFEE
	btst	#$02,-$0012(a3)	;082B0002FFEE
	beq.s	adrCd00B370	;6704
	addq.w	#$01,d6	;5246
	addq.w	#$01,d0	;5240
adrCd00B370:
	bsr	adrCd00B458	;610000E6
adrCd00B374:
	clr.w	adrW_00B4BE.l	;42790000B4BE
	tst.b	-$0011(a3)	;4A2BFFEF
	bmi	adrCd0099F0	;6B00E670
	rts	;4E75

adrCd00B384:
	lea	_GFX_StairsUp.l,a1	;43F90002AB38
	lea	adrEA018BD0.l,a0	;41F900018BD0
	lea	adrEA00BB1E.l,a2	;45F90000BB1E
	btst	#$00,-$0012(a3)	;082B0000FFEE
	beq.s	adrCd00B3B0	;6712
	lea	_GFX_StairsDown.l,a1	;43F90002C9E0
	lea	adrEA018BF2.l,a0	;41F900018BF2
	lea	adrEA00BB92.l,a2	;45F90000BB92
adrCd00B3B0:
	cmp.b	#$0E,-$0016(a3)	;0C2B000EFFEA
	bcs.s	adrCd00B3CC	;6514
	beq.s	adrCd00B3CE	;6714
	move.b	-$0016(a3),d6	;1C2BFFEA
	move.w	d6,d0	;3006
	add.w	#$000A,d6	;0646000A
	subq.w	#$02,d0	;5540
	bsr	adrCd00B458	;61000090
	bra.s	adrCd00B3CE	;6002

adrCd00B3CC:
	bsr.s	adrCd00B410	;6142
adrCd00B3CE:
	tst.b	-$0011(a3)	;4A2BFFEF
	bmi	adrCd0099F0	;6B00E61C
	rts	;4E75

adrCd00B3D8:
	lea	_GFX_WoodWall.l,a1	;43F90001F980
	lea	adrEA018B70.l,a0	;41F900018B70
	lea	adrEA00BAAE.l,a2	;45F90000BAAE
	tst.b	-$0014(a3)	;4A2BFFEC
	beq.s	adrCd00B40E	;671E
	add.w	#$2498,a1	;D2FC2498
	bsr.s	adrCd00B410	;611A
	tst.b	-$0015(a3)	;4A2BFFEB
	beq.s	adrCd00B42C	;6730
	lea	adrEA018B50.l,a0	;41F900018B50
	lea	adrEA00BFAE.l,a2	;45F90000BFAE
	lea	_GFX_WoodDoors.l,a1	;43F9000242B0
adrCd00B40E:
	nop	;4E71
adrCd00B410:
	moveq	#$00,d0	;7000
	move.b	adrB_00B43C(pc,d6.w),d0	;103B6028
	bmi.s	adrCd00B42E	;6B16
	cmpi.b	#$0C,d0	;0C00000C
	bcc	adrCd00B458	;6400003A
	bsr.s	adrCd00B486	;6164
	swap	d3	;4843
	move.l	a3,-(sp)	;2F0B
	bsr	adrCd00B5CA	;610001A2
	move.l	(sp)+,a3	;265F
adrCd00B42C:
	rts	;4E75

adrCd00B42E:
	and.w	#$007F,d0	;0240007F
	bsr.s	adrCd00B486	;6152
	add.w	d3,a0	;D0C3
	swap	d3	;4843
	bra	adrLp00B76E	;60000334

adrB_00B43C:
	dc.b	$00	;00
	dc.b	$01	;01
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
	dc.b	$80	;80
	dc.b	$81	;81
	dc.b	$82	;82
	dc.b	$83	;83
	dc.b	$84	;84
	dc.b	$85	;85
	dc.b	$86	;86
	dc.b	$87	;87
	dc.b	$88	;88
	dc.b	$89	;89
	dc.b	$8A	;8A
	dc.b	$8B	;8B
	dc.b	$0C	;0C
	dc.b	$0D	;0D
	dc.b	$0E	;0E
	dc.b	$0F	;0F

adrCd00B458:
	bsr.s	adrCd00B486	;612C
	swap	d3	;4843
	movem.l	d1/d3/d5/a0/a1/a3,-(sp)	;48E754D0
	bsr	adrCd00B5CA	;61000168
	movem.l	(sp)+,d1/d3/d5/a0/a1/a3	;4CDF0B2A
	add.w	#$0010,a0	;D0FC0010
	add.w	d1,d1	;D241
	sub.w	d1,a0	;90C1
	bra	adrLp00B76E	;600002FC

adrCd00B474:
	lea	adrEA00BA3E.l,a2	;45F90000BA3E
	lea	adrEA018ADE.l,a0	;41F900018ADE
	lea	_GFX_MainWalls.l,a1	;43F90001B050
adrCd00B486:
	add.w	d0,d0	;D040
	add.w	$00(a0,d0.w),a1	;D2F00000
	move.w	d6,d0	;3006
	asl.w	#$02,d0	;E540
	add.w	d0,a2	;D4C0
	moveq	#$00,d1	;7200
	move.b	(a2)+,d1	;121A
	swap	d1	;4841
	move.b	(a2)+,d1	;121A
	move.w	d1,d0	;3001
	asl.w	#$02,d1	;E541
	add.w	d1,d0	;D041
	asl.w	#$03,d0	;E740
	swap	d1	;4841
	lsr.w	#$02,d1	;E449
	add.w	d1,d0	;D041
	move.l	-$0008(a3),a0	;206BFFF8
	add.w	d0,a0	;D0C0
	moveq	#$00,d5	;7A00
	move.b	(a2)+,d5	;1A1A
	move.w	d5,d3	;3605
	swap	d5	;4845
	move.b	(a2),d5	;1A12
	addq.w	#$01,d3	;5243
	add.w	d3,d3	;D643
	rts	;4E75

adrW_00B4BE:
	dc.w	$0000	;0000
adrEA00B4C0:
	dc.w	$0004	;0004
adrB_00B4C2:
	dc.b	$08	;08
	dc.b	$0C	;0C
adrEA00B4C4:
	dc.b	$01	;01
	dc.b	$05	;05
	dc.b	$07	;07
	dc.b	$05	;05
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$06	;06
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$05	;05
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$05	;05
	dc.b	$07	;07
	dc.b	$05	;05
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$03	;03
	dc.b	$01	;01
	dc.b	$05	;05
	dc.b	$05	;05
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$07	;07
	dc.b	$07	;07
	dc.b	$02	;02
	dc.b	$07	;07

adrCd00B4E0:
	lea	adrEA00B4C4.l,a2	;45F90000B4C4
	add.w	d6,a2	;D4C6
	btst	#$01,(a2)	;08120001
	beq	adrCd00B5CA	;670000DC
	swap	d6	;4846
	btst	#$00,(a2)	;08120000
	beq.s	adrCd00B4FA	;6702
	bsr.s	adrCd00B560	;6166
adrCd00B4FA:
	move.b	(a2),d6	;1C12
	and.w	#$0007,d6	;02460007
	swap	d3	;4843
	moveq	#$28,d2	;7428
	sub.w	d3,d2	;9443
	swap	d3	;4843
	move.w	d5,d4	;3805
	swap	d5	;4845
	move.b	adrB_00B558(pc,d6.w),d6	;1C3B604A
	sub.w	d6,d5	;9A46
	add.w	d6,d6	;DC46
	add.w	d6,d2	;D446
	movem.l	a0/a1,-(sp)	;48E700C0
adrLp00B51A:
	move.w	d5,d3	;3605
adrLp00B51C:
	move.w	(a1)+,(a0)+	;30D9
	move.w	(a1)+,$1F3E(a0)	;31591F3E
	move.w	(a1)+,$3E7E(a0)	;31593E7E
	move.w	(a1)+,$5DBE(a0)	;31595DBE
	dbra	d3,adrLp00B51C	;51CBFFF0
	move.w	d6,d3	;3606
	asl.w	#$02,d3	;E543
	add.w	d3,a1	;D2C3
	add.w	d2,a0	;D0C2
	dbra	d4,adrLp00B51A	;51CCFFE2
	movem.l	(sp)+,a0/a1	;4CDF0300
	swap	d5	;4845
	swap	d3	;4843
	sub.w	d3,d6	;9C43
	sub.w	d6,a0	;90C6
	asl.w	#$02,d6	;E546
	sub.w	d6,a1	;92C6
	swap	d3	;4843
	btst	#$02,(a2)	;08120002
	beq.s	adrCd00B554	;6702
	bsr.s	adrCd00B560	;610C
adrCd00B554:
	swap	d6	;4846
	rts	;4E75

adrB_00B558:
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02

adrCd00B560:
	movem.l	a0/a1,-(sp)	;48E700C0
	swap	d3	;4843
	move.w	d3,d6	;3C03
	subq.w	#$02,d6	;5546
	asl.w	#$02,d6	;E546
	swap	d3	;4843
	move.w	d5,d3	;3605
adrLp00B570:
	move.l	(a1)+,d0	;2019
	move.l	(a1)+,d1	;2219
	move.l	d1,d2	;2401
	and.l	d0,d2	;C480
	swap	d2	;4842
	and.l	d0,d2	;C480
	and.l	d1,d2	;C481
	not.l	d2	;4682
	and.l	d2,d0	;C082
	and.l	d2,d1	;C282
	not.l	d2	;4682
	move.w	$5DC0(a0),d4	;38285DC0
	and.w	d2,d4	;C842
	or.w	d1,d4	;8841
	move.w	d4,$5DC0(a0)	;31445DC0
	swap	d1	;4841
	move.w	$3E80(a0),d4	;38283E80
	and.w	d2,d4	;C842
	or.w	d1,d4	;8841
	move.w	d4,$3E80(a0)	;31443E80
	move.w	$1F40(a0),d4	;38281F40
	and.w	d2,d4	;C842
	or.w	d0,d4	;8840
	move.w	d4,$1F40(a0)	;31441F40
	swap	d0	;4840
	move.w	(a0),d4	;3810
	and.w	d2,d4	;C842
	or.w	d0,d4	;8840
	move.w	d4,(a0)+	;30C4
	add.w	#$0026,a0	;D0FC0026
	add.w	d6,a1	;D2C6
	dbra	d3,adrLp00B570	;51CBFFB2
	movem.l	(sp)+,a0/a1	;4CDF0300
	addq.w	#$02,a0	;5448
	addq.w	#$08,a1	;5049
	rts	;4E75

adrCd00B5CA:
	sub.w	a3,a3	;96CB
adrLp00B5CC:
	swap	d5	;4845
	move.w	d5,d3	;3605
adrLp00B5D0:
	move.l	(a1)+,d0	;2019
	move.l	(a1)+,d1	;2219
	tst.w	adrW_00B4BE.l	;4A790000B4BE
	beq.s	adrCd00B5E6	;670A
	lea	adrEA00B4C0.l,a6	;4DF90000B4C0
	bsr	adrCd00AFD0	;6100F9EC
adrCd00B5E6:
	move.l	d1,d2	;2401
	and.l	d0,d2	;C480
	addq.l	#$01,d2	;5282
	beq.s	adrCd00B630	;6742
	subq.l	#$01,d2	;5382
	swap	d2	;4842
	and.l	d0,d2	;C480
	and.l	d1,d2	;C481
	not.l	d2	;4682
	and.l	d2,d0	;C082
	and.l	d2,d1	;C282
	not.l	d2	;4682
	move.w	$5DC0(a0),d4	;38285DC0
	and.w	d2,d4	;C842
	or.w	d1,d4	;8841
	move.w	d4,$5DC0(a0)	;31445DC0
	swap	d1	;4841
	move.w	$3E80(a0),d4	;38283E80
	and.w	d2,d4	;C842
	or.w	d1,d4	;8841
	move.w	d4,$3E80(a0)	;31443E80
	move.w	$1F40(a0),d4	;38281F40
	and.w	d2,d4	;C842
	or.w	d0,d4	;8840
	move.w	d4,$1F40(a0)	;31441F40
	swap	d0	;4840
	move.w	(a0),d4	;3810
	and.w	d2,d4	;C842
	or.w	d0,d4	;8840
	move.w	d4,(a0)+	;30C4
	bra.s	adrCd00B632	;6002

adrCd00B630:
	addq.w	#$02,a0	;5448
adrCd00B632:
	dbra	d3,adrLp00B5D0	;51CBFF9C
	swap	d3	;4843
	sub.w	d3,a0	;90C3
	swap	d3	;4843
	add.w	#$0028,a0	;D0FC0028
	add.w	a3,a1	;D2CB
	swap	d5	;4845
	dbra	d5,adrLp00B5CC	;51CDFF86
	rts	;4E75

adrEA00B64A:
	dc.w	$0105	;0105
	dc.w	$0705	;0705
	dc.w	$0101	;0101
	dc.w	$0301	;0301
	dc.w	$0205	;0205
	dc.w	$0101	;0101
	dc.w	$0105	;0105
	dc.w	$0705	;0705
	dc.w	$0101	;0101
	dc.w	$0601	;0601
	dc.w	$0505	;0505
	dc.w	$0101	;0101
	dc.w	$0707	;0707
	dc.w	$0207	;0207

adrCd00B666:
	lea	adrEA00B64A.l,a2	;45F90000B64A
	add.w	d6,a2	;D4C6
	btst	#$01,(a2)	;08120001
	beq	adrLp00B76E	;670000FA
	swap	d6	;4846
	btst	#$00,(a2)	;08120000
	beq.s	adrCd00B680	;6702
	bsr.s	adrCd00B6FA	;617A
adrCd00B680:
	movem.l	d7/a0/a1,-(sp)	;48E701C0
	move.b	(a2),d6	;1C12
	and.w	#$0007,d6	;02460007
	swap	d3	;4843
	move.w	#$0028,d7	;3E3C0028
	add.w	d3,d7	;DE43
	swap	d3	;4843
	move.w	d5,d4	;3805
	swap	d5	;4845
	move.b	adrB_00B6F2(pc,d6.w),d6	;1C3B6058
	sub.w	d6,d5	;9A46
	add.w	d6,d6	;DC46
	sub.w	d6,d7	;9E46
adrLp00B6A2:
	move.w	d5,d3	;3605
adrLp00B6A4:
	move.l	(a1)+,d1	;2219
	move.l	(a1)+,d0	;2019
	bsr	adrCd00AD66	;6100F6BC
	exg	d0,d1	;C141
	bsr	adrCd00AD66	;6100F6B6
	move.w	d1,$5DBE(a0)	;31415DBE
	swap	d1	;4841
	move.w	d1,$3E7E(a0)	;31413E7E
	move.w	d0,$1F3E(a0)	;31401F3E
	swap	d0	;4840
	move.w	d0,-(a0)	;3100
	dbra	d3,adrLp00B6A4	;51CBFFDE
	move.w	d6,d3	;3606
	asl.w	#$02,d3	;E543
	add.w	d3,a1	;D2C3
	add.w	d7,a0	;D0C7
	dbra	d4,adrLp00B6A2	;51CCFFD0
	movem.l	(sp)+,d7/a0/a1	;4CDF0380
	swap	d5	;4845
	swap	d3	;4843
	sub.w	d3,d6	;9C43
	add.w	d6,a0	;D0C6
	asl.w	#$02,d6	;E546
	sub.w	d6,a1	;92C6
	swap	d3	;4843
	btst	#$02,(a2)	;08120002
	beq.s	adrCd00B6EE	;6702
	bsr.s	adrCd00B6FA	;610C
adrCd00B6EE:
	swap	d6	;4846
	rts	;4E75

adrB_00B6F2:
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02

adrCd00B6FA:
	movem.l	a0/a1,-(sp)	;48E700C0
	swap	d3	;4843
	move.w	d3,d6	;3C03
	subq.w	#$02,d6	;5546
	asl.w	#$02,d6	;E546
	swap	d3	;4843
	move.w	d5,d3	;3605
adrLp00B70A:
	move.l	(a1)+,d1	;2219
	move.l	(a1)+,d0	;2019
	bsr	adrCd00AD66	;6100F656
	exg	d0,d1	;C141
	bsr	adrCd00AD66	;6100F650
	move.l	d1,d2	;2401
	and.l	d0,d2	;C480
	swap	d2	;4842
	and.l	d0,d2	;C480
	and.l	d1,d2	;C481
	not.l	d2	;4682
	and.l	d2,d0	;C082
	and.l	d2,d1	;C282
	not.l	d2	;4682
	move.w	$5DBE(a0),d4	;38285DBE
	and.w	d2,d4	;C842
	or.w	d1,d4	;8841
	move.w	d4,$5DBE(a0)	;31445DBE
	swap	d1	;4841
	move.w	$3E7E(a0),d4	;38283E7E
	and.w	d2,d4	;C842
	or.w	d1,d4	;8841
	move.w	d4,$3E7E(a0)	;31443E7E
	move.w	$1F3E(a0),d4	;38281F3E
	and.w	d2,d4	;C842
	or.w	d0,d4	;8840
	move.w	d4,$1F3E(a0)	;31441F3E
	swap	d0	;4840
	move.w	-(a0),d4	;3820
	and.w	d2,d4	;C842
	or.w	d0,d4	;8840
	move.w	d4,(a0)	;3084
	add.w	#$002A,a0	;D0FC002A
	add.w	d6,a1	;D2C6
	dbra	d3,adrLp00B70A	;51CBFFA8
	movem.l	(sp)+,a0/a1	;4CDF0300
	subq.w	#$02,a0	;5548
	addq.w	#$08,a1	;5049
	rts	;4E75

adrLp00B76E:
	swap	d5	;4845
	move.w	d5,d3	;3605
adrLp00B772:
	move.l	(a1)+,d1	;2219
	move.l	(a1)+,d0	;2019
	bsr	adrCd00AD66	;6100F5EE
	exg	d0,d1	;C141
	bsr	adrCd00AD66	;6100F5E8
	tst.w	adrW_00B4BE.l	;4A790000B4BE
	beq.s	adrCd00B792	;670A
	lea	adrEA00B4C0.l,a6	;4DF90000B4C0
	bsr	adrCd00AFD0	;6100F840
adrCd00B792:
	move.l	d1,d2	;2401
	and.l	d0,d2	;C480
	addq.l	#$01,d2	;5282
	beq.s	adrCd00B7DC	;6742
	subq.l	#$01,d2	;5382
	swap	d2	;4842
	and.l	d0,d2	;C480
	and.l	d1,d2	;C481
	not.l	d2	;4682
	and.l	d2,d0	;C082
	and.l	d2,d1	;C282
	not.l	d2	;4682
	move.w	$5DBE(a0),d4	;38285DBE
	and.w	d2,d4	;C842
	or.w	d1,d4	;8841
	move.w	d4,$5DBE(a0)	;31445DBE
	swap	d1	;4841
	move.w	$3E7E(a0),d4	;38283E7E
	and.w	d2,d4	;C842
	or.w	d1,d4	;8841
	move.w	d4,$3E7E(a0)	;31443E7E
	move.w	$1F3E(a0),d4	;38281F3E
	and.w	d2,d4	;C842
	or.w	d0,d4	;8840
	move.w	d4,$1F3E(a0)	;31441F3E
	swap	d0	;4840
	move.w	-(a0),d4	;3820
	and.w	d2,d4	;C842
	or.w	d0,d4	;8840
	move.w	d4,(a0)	;3084
	bra.s	adrCd00B7DE	;6002

adrCd00B7DC:
	subq.w	#$02,a0	;5548
adrCd00B7DE:
	dbra	d3,adrLp00B772	;51CBFF92
	swap	d3	;4843
	add.w	d3,a0	;D0C3
	swap	d3	;4843
	add.w	#$0028,a0	;D0FC0028
	swap	d5	;4845
	dbra	d5,adrLp00B76E	;51CDFF7E
	rts	;4E75

adrCd00B7F4:
	lea	_GFX_FloorCeiling.l,a1	;43F900032120
	move.l	-$0008(a3),a0	;206BFFF8
	tst.w	-$000C(a3)	;4A6BFFF4
	beq.s	adrCd00B864	;6760
	moveq	#$16,d0	;7016
	bsr.s	adrLp00B80C	;6104
	bsr.s	adrCd00B82A	;6120
	moveq	#$21,d0	;7021
adrLp00B80C:
	moveq	#$07,d1	;7207
adrLp00B80E:
	move.w	(a1)+,(a0)+	;30D9
	move.w	(a1)+,$1F3E(a0)	;31591F3E
	move.w	(a1)+,$3E7E(a0)	;31593E7E
	move.w	(a1)+,$5DBE(a0)	;31595DBE
	dbra	d1,adrLp00B80E	;51C9FFF0
	lea	$0018(a0),a0	;41E80018
	dbra	d0,adrLp00B80C	;51C8FFE6
	rts	;4E75

adrCd00B82A:
	moveq	#$12,d0	;7012
	moveq	#$00,d1	;7200
adrLp00B82E:
	lea	$1F40(a0),a2	;45E81F40
	move.l	d1,(a2)+	;24C1
	move.l	d1,(a2)+	;24C1
	move.l	d1,(a2)+	;24C1
	move.l	d1,(a2)+	;24C1
	lea	$3E80(a0),a2	;45E83E80
	move.l	d1,(a2)+	;24C1
	move.l	d1,(a2)+	;24C1
	move.l	d1,(a2)+	;24C1
	move.l	d1,(a2)+	;24C1
	lea	$5DC0(a0),a2	;45E85DC0
	move.l	d1,(a2)+	;24C1
	move.l	d1,(a2)+	;24C1
	move.l	d1,(a2)+	;24C1
	move.l	d1,(a2)+	;24C1
	move.l	d1,(a0)+	;20C1
	move.l	d1,(a0)+	;20C1
	move.l	d1,(a0)+	;20C1
	move.l	d1,(a0)+	;20C1
	lea	$0018(a0),a0	;41E80018
	dbra	d0,adrLp00B82E	;51C8FFCE
	rts	;4E75

adrCd00B864:
	lea	adrEA01684C.l,a6	;4DF90001684C
	lea	$0010(a0),a0	;41E80010
	moveq	#$16,d7	;7E16
	bsr.s	adrLp00B87E	;610C
	sub.w	#$0010,a0	;90FC0010
	bsr.s	adrCd00B82A	;61B2
	lea	$0010(a0),a0	;41E80010
	moveq	#$21,d7	;7E21
adrLp00B87E:
	moveq	#$07,d3	;7607
adrLp00B880:
	move.l	(a1)+,d0	;2019
	bsr	adrCd00AD6C	;6100F4E8
	move.l	d0,d1	;2200
	move.l	(a1)+,d0	;2019
	bsr	adrCd00AD6C	;6100F4E0
	move.w	d0,$5DBE(a0)	;31405DBE
	swap	d0	;4840
	move.w	d0,$3E7E(a0)	;31403E7E
	move.w	d1,$1F3E(a0)	;31411F3E
	swap	d1	;4841
	move.w	d1,-(a0)	;3101
	dbra	d3,adrLp00B880	;51CBFFDE
	lea	$0038(a0),a0	;41E80038
	dbra	d7,adrLp00B87E	;51CFFFD4
	rts	;4E75

adrEA00B8AE:
	dc.w	$FEFC	;FEFC
	dc.w	$FFFC	;FFFC
	dc.w	$FEFD	;FEFD
	dc.w	$FFFD	;FFFD
	dc.w	$FFFE	;FFFE
	dc.w	$FFFF	;FFFF
	dc.w	$FF00	;FF00
	dc.w	$02FC	;02FC
	dc.w	$01FC	;01FC
	dc.w	$02FD	;02FD
	dc.w	$01FD	;01FD
	dc.w	$01FE	;01FE
	dc.w	$01FF	;01FF
	dc.w	$0100	;0100
	dc.w	$00FC	;00FC
	dc.w	$00FD	;00FD
	dc.w	$00FE	;00FE
	dc.w	$00FF	;00FF
	dc.w	$0000	;0000
	dc.w	$04FE	;04FE
	dc.w	$04FF	;04FF
	dc.w	$03FE	;03FE
	dc.w	$03FF	;03FF
	dc.w	$02FF	;02FF
	dc.w	$01FF	;01FF
	dc.w	$00FF	;00FF
	dc.w	$0402	;0402
	dc.w	$0401	;0401
	dc.w	$0302	;0302
	dc.w	$0301	;0301
	dc.w	$0201	;0201
	dc.w	$0101	;0101
	dc.w	$0001	;0001
	dc.w	$0400	;0400
	dc.w	$0300	;0300
	dc.w	$0200	;0200
	dc.w	$0100	;0100
	dc.w	$0000	;0000
	dc.w	$0204	;0204
	dc.w	$0104	;0104
	dc.w	$0203	;0203
	dc.w	$0103	;0103
	dc.w	$0102	;0102
	dc.w	$0101	;0101
	dc.w	$0100	;0100
	dc.w	$FE04	;FE04
	dc.w	$FF04	;FF04
	dc.w	$FE03	;FE03
	dc.w	$FF03	;FF03
	dc.w	$FF02	;FF02
	dc.w	$FF01	;FF01
	dc.w	$FF00	;FF00
	dc.w	$0004	;0004
	dc.w	$0003	;0003
	dc.w	$0002	;0002
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$FC02	;FC02
	dc.w	$FC01	;FC01
	dc.w	$FD02	;FD02
	dc.w	$FD01	;FD01
	dc.w	$FE01	;FE01
	dc.w	$FF01	;FF01
	dc.w	$0001	;0001
	dc.w	$FCFE	;FCFE
	dc.w	$FCFF	;FCFF
	dc.w	$FDFE	;FDFE
	dc.w	$FDFF	;FDFF
	dc.w	$FEFF	;FEFF
	dc.w	$FFFF	;FFFF
	dc.w	$00FF	;00FF
	dc.w	$FC00	;FC00
	dc.w	$FD00	;FD00
	dc.w	$FE00	;FE00
	dc.w	$FF00	;FF00
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFD	;FFFD
	dc.w	$FFFF	;FFFF
	dc.w	$FFFE	;FFFE
	dc.w	$FFFF	;FFFF
	dc.w	$FFE8	;FFE8
	dc.w	$FFFF	;FFFF
	dc.w	$FFAC	;FFAC
	dc.w	$FFFF	;FFFF
	dc.w	$FEEC	;FEEC
	dc.w	$FFFF	;FFFF
	dc.w	$FBFF	;FBFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$DFFF	;DFFF
	dc.w	$FFFF	;FFFF
	dc.w	$EFFF	;EFFF
	dc.w	$FFFE	;FFFE
	dc.w	$8FFF	;8FFF
	dc.w	$FFFA	;FFFA
	dc.w	$CFFF	;CFFF
	dc.w	$FFEE	;FFEE
	dc.w	$CFFF	;CFFF
	dc.w	$FFBF	;FFBF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$7FF7	;7FF7
	dc.w	$FEFD	;FEFD
	dc.w	$7FD7	;7FD7
	dc.w	$FCF5	;FCF5
	dc.w	$7F57	;7F57
	dc.w	$F8D5	;F8D5
	dc.w	$7D57	;7D57
adrEA00B98E:
	dc.w	$08D5	;08D5
	dc.w	$7D57	;7D57
	dc.w	$0000	;0000
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$000E	;000E
	dc.w	$0000	;0000
	dc.w	$0011	;0011
	dc.w	$0000	;0000
	dc.w	$0074	;0074
	dc.w	$0000	;0000
	dc.w	$01C0	;01C0
	dc.w	$0000	;0000
	dc.w	$0700	;0700
	dc.w	$0000	;0000
	dc.w	$0C00	;0C00
	dc.w	$0000	;0000
	dc.w	$3000	;3000
	dc.w	$0000	;0000
	dc.w	$E000	;E000
	dc.w	$0001	;0001
	dc.w	$1000	;1000
	dc.w	$0007	;0007
	dc.w	$4000	;4000
	dc.w	$001C	;001C
	dc.w	$0000	;0000
	dc.w	$0070	;0070
	dc.w	$0000	;0000
	dc.w	$00C0	;00C0
	dc.w	$0000	;0000
	dc.w	$0100	;0100
	dc.w	$8008	;8008
	dc.w	$0302	;0302
	dc.w	$0020	;0020
	dc.w	$0608	;0608
	dc.w	$0080	;0080
	dc.w	$0C20	;0C20
	dc.w	$0200	;0200
adrEA00B9DA:
	dc.w	$0880	;0880
	dc.w	$0800	;0800
adrEA00B9DE:
	dc.w	$0002	;0002
	dc.w	$FF06	;FF06
	dc.w	$080A	;080A
	dc.w	$FF0C	;FF0C
	dc.w	$0EFF	;0EFF
	dc.w	$1214	;1214
	dc.w	$16FF	;16FF
	dc.w	$1819	;1819
	dc.w	$1A1B	;1A1B
	dc.w	$FF00	;FF00
adrEA00B9F2:
	dc.w	$FFFF	;FFFF
	dc.w	$0001	;0001
	dc.w	$FF01	;FF01
	dc.w	$0203	;0203
	dc.w	$00FF	;00FF
	dc.w	$FF04	;FF04
	dc.w	$0204	;0204
	dc.w	$0605	;0605
	dc.w	$06FF	;06FF
	dc.w	$0807	;0807
	dc.w	$08FF	;08FF
	dc.w	$0A09	;0A09
	dc.w	$0AFF	;0AFF
	dc.w	$FF0B	;FF0B
	dc.w	$FFFF	;FFFF
	dc.w	$0C0D	;0C0D
	dc.w	$FF0D	;FF0D
	dc.w	$0E0F	;0E0F
	dc.w	$0CFF	;0CFF
	dc.w	$FF10	;FF10
	dc.w	$0E10	;0E10
	dc.w	$1211	;1211
	dc.w	$12FF	;12FF
	dc.w	$1413	;1413
	dc.w	$14FF	;14FF
	dc.w	$1615	;1615
	dc.w	$16FF	;16FF
	dc.w	$FF17	;FF17
	dc.w	$FF0F	;FF0F
	dc.w	$0318	;0318
	dc.w	$1811	;1811
	dc.w	$0519	;0519
	dc.w	$1913	;1913
	dc.w	$071A	;071A
	dc.w	$1A15	;1A15
	dc.w	$091B	;091B
	dc.w	$1B17	;1B17
	dc.w	$0BFF	;0BFF
adrEA00BA3E:
	dc.w	$0015	;0015
	dc.w	$0016	;0016
	dc.w	$0015	;0015
	dc.w	$0116	;0116
	dc.w	$0015	;0015
	dc.w	$0216	;0216
	dc.w	$1015	;1015
	dc.w	$0116	;0116
	dc.w	$0012	;0012
	dc.w	$001B	;001B
	dc.w	$1012	;1012
	dc.w	$001E	;001E
	dc.w	$0012	;0012
	dc.w	$021E	;021E
	dc.w	$100E	;100E
	dc.w	$0029	;0029
	dc.w	$000E	;000E
	dc.w	$0129	;0129
	dc.w	$0006	;0006
	dc.w	$013E	;013E
	dc.w	$0006	;0006
	dc.w	$003E	;003E
	dc.w	$0000	;0000
	dc.w	$004B	;004B
	dc.w	$3815	;3815
	dc.w	$0016	;0016
	dc.w	$3015	;3015
	dc.w	$0116	;0116
	dc.w	$2815	;2815
	dc.w	$0216	;0216
	dc.w	$2015	;2015
	dc.w	$0116	;0116
	dc.w	$3812	;3812
	dc.w	$001B	;001B
	dc.w	$2812	;2812
	dc.w	$001E	;001E
	dc.w	$2812	;2812
	dc.w	$021E	;021E
	dc.w	$280E	;280E
	dc.w	$0029	;0029
	dc.w	$300E	;300E
	dc.w	$0129	;0129
	dc.w	$3006	;3006
	dc.w	$013E	;013E
	dc.w	$3806	;3806
	dc.w	$003E	;003E
	dc.w	$3800	;3800
	dc.w	$004B	;004B
	dc.w	$1015	;1015
	dc.w	$0316	;0316
	dc.w	$1012	;1012
	dc.w	$031E	;031E
	dc.w	$100E	;100E
	dc.w	$0329	;0329
	dc.w	$0006	;0006
	dc.w	$073E	;073E
adrEA00BAAE:
	dc.w	$0015	;0015
	dc.w	$0016	;0016
	dc.w	$0015	;0015
	dc.w	$0116	;0116
	dc.w	$0015	;0015
	dc.w	$0216	;0216
	dc.w	$1015	;1015
	dc.w	$0116	;0116
	dc.w	$0012	;0012
	dc.w	$001B	;001B
	dc.w	$1012	;1012
	dc.w	$001E	;001E
	dc.w	$0012	;0012
	dc.w	$021E	;021E
	dc.w	$100E	;100E
	dc.w	$0029	;0029
	dc.w	$000E	;000E
	dc.w	$0129	;0129
	dc.w	$0006	;0006
	dc.w	$013E	;013E
	dc.w	$0006	;0006
	dc.w	$003E	;003E
	dc.w	$0000	;0000
	dc.w	$004B	;004B
	dc.w	$3815	;3815
	dc.w	$0016	;0016
	dc.w	$3015	;3015
	dc.w	$0116	;0116
	dc.w	$2815	;2815
	dc.w	$0216	;0216
	dc.w	$2015	;2015
	dc.w	$0116	;0116
	dc.w	$3812	;3812
	dc.w	$001B	;001B
	dc.w	$2812	;2812
	dc.w	$001E	;001E
	dc.w	$2812	;2812
	dc.w	$021E	;021E
	dc.w	$280E	;280E
	dc.w	$0029	;0029
	dc.w	$300E	;300E
	dc.w	$0129	;0129
	dc.w	$3006	;3006
	dc.w	$013E	;013E
	dc.w	$3806	;3806
	dc.w	$003E	;003E
	dc.w	$3800	;3800
	dc.w	$004B	;004B
	dc.w	$1015	;1015
	dc.w	$0116	;0116
	dc.w	$1012	;1012
	dc.w	$011E	;011E
	dc.w	$100E	;100E
	dc.w	$0129	;0129
	dc.w	$0006	;0006
	dc.w	$033E	;033E
adrEA00BB1E:
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0015	;0015
	dc.w	$0016	;0016
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1015	;1015
	dc.w	$0016	;0016
	dc.w	$0013	;0013
	dc.w	$001A	;001A
	dc.w	$1012	;1012
	dc.w	$001E	;001E
	dc.w	$0012	;0012
	dc.w	$021E	;021E
	dc.w	$100E	;100E
	dc.w	$0028	;0028
	dc.w	$000E	;000E
	dc.w	$0129	;0129
	dc.w	$0006	;0006
	dc.w	$013E	;013E
	dc.w	$0006	;0006
	dc.w	$003E	;003E
	dc.w	$0000	;0000
	dc.w	$0047	;0047
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3815	;3815
	dc.w	$0016	;0016
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$2815	;2815
	dc.w	$0016	;0016
	dc.w	$3813	;3813
	dc.w	$001A	;001A
	dc.w	$2812	;2812
	dc.w	$001E	;001E
	dc.w	$2812	;2812
	dc.w	$021E	;021E
	dc.w	$280E	;280E
	dc.w	$0028	;0028
	dc.w	$300E	;300E
	dc.w	$0129	;0129
	dc.w	$3006	;3006
	dc.w	$013E	;013E
	dc.w	$3806	;3806
	dc.w	$003E	;003E
	dc.w	$3800	;3800
	dc.w	$0047	;0047
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1012	;1012
	dc.w	$011E	;011E
	dc.w	$100E	;100E
	dc.w	$0129	;0129
	dc.w	$0806	;0806
	dc.w	$023E	;023E
	dc.w	$002E	;002E
	dc.w	$011D	;011D
adrEA00BB92:
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0027	;0027
	dc.w	$0004	;0004
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1027	;1027
	dc.w	$0004	;0004
	dc.w	$0025	;0025
	dc.w	$0008	;0008
	dc.w	$1024	;1024
	dc.w	$000C	;000C
	dc.w	$0026	;0026
	dc.w	$020A	;020A
	dc.w	$1026	;1026
	dc.w	$0011	;0011
	dc.w	$002A	;002A
	dc.w	$010D	;010D
	dc.w	$002A	;002A
	dc.w	$011A	;011A
	dc.w	$002D	;002D
	dc.w	$0017	;0017
	dc.w	$002E	;002E
	dc.w	$0019	;0019
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3827	;3827
	dc.w	$0004	;0004
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$2827	;2827
	dc.w	$0004	;0004
	dc.w	$3825	;3825
	dc.w	$0008	;0008
	dc.w	$2824	;2824
	dc.w	$000C	;000C
	dc.w	$2826	;2826
	dc.w	$020A	;020A
	dc.w	$2826	;2826
	dc.w	$0011	;0011
	dc.w	$302A	;302A
	dc.w	$010D	;010D
	dc.w	$302A	;302A
	dc.w	$011A	;011A
	dc.w	$382D	;382D
	dc.w	$0017	;0017
	dc.w	$382E	;382E
	dc.w	$0019	;0019
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1026	;1026
	dc.w	$010A	;010A
	dc.w	$102A	;102A
	dc.w	$010D	;010D
	dc.w	$082D	;082D
	dc.w	$0217	;0217
	dc.w	$002E	;002E
	dc.w	$011D	;011D
adrEA00BC06:
	dc.w	$0016	;0016
	dc.w	$0015	;0015
	dc.w	$0816	;0816
	dc.w	$0115	;0115
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0013	;0013
	dc.w	$011C	;011C
	dc.w	$000F	;000F
	dc.w	$0126	;0126
	dc.w	$0009	;0009
	dc.w	$0036	;0036
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3816	;3816
	dc.w	$0015	;0015
	dc.w	$2816	;2816
	dc.w	$0115	;0115
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3013	;3013
	dc.w	$011C	;011C
	dc.w	$300F	;300F
	dc.w	$0126	;0126
	dc.w	$3809	;3809
	dc.w	$0036	;0036
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1816	;1816
	dc.w	$0115	;0115
	dc.w	$1813	;1813
	dc.w	$011C	;011C
	dc.w	$180F	;180F
	dc.w	$0126	;0126
	dc.w	$1009	;1009
	dc.w	$0336	;0336
adrEA00BC4E:
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0016	;0016
	dc.w	$0215	;0215
	dc.w	$0014	;0014
	dc.w	$0018	;0018
	dc.w	$0013	;0013
	dc.w	$021C	;021C
	dc.w	$000F	;000F
	dc.w	$0126	;0126
	dc.w	$0009	;0009
	dc.w	$0036	;0036
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$2816	;2816
	dc.w	$0215	;0215
	dc.w	$3814	;3814
	dc.w	$0018	;0018
	dc.w	$2813	;2813
	dc.w	$021C	;021C
	dc.w	$300F	;300F
	dc.w	$0126	;0126
	dc.w	$3809	;3809
	dc.w	$0036	;0036
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1016	;1016
	dc.w	$0115	;0115
	dc.w	$1013	;1013
	dc.w	$011C	;011C
	dc.w	$100F	;100F
	dc.w	$0126	;0126
	dc.w	$0809	;0809
	dc.w	$0236	;0236
	dc.w	$0000	;0000
	dc.w	$004B	;004B
	dc.w	$1000	;1000
	dc.w	$0147	;0147
adrEA00BC9E:
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0029	;0029
	dc.w	$010A	;010A
	dc.w	$002D	;002D
	dc.w	$000F	;000F
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
	dc.w	$3029	;3029
	dc.w	$010A	;010A
	dc.w	$382D	;382D
	dc.w	$000F	;000F
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$101F	;101F
	dc.w	$0314	;0314
	dc.w	$0820	;0820
	dc.w	$051C	;051C
adrEA00BCE6:
	dc.w	$001C	;001C
	dc.w	$0008	;0008
	dc.w	$081D	;081D
	dc.w	$0007	;0007
	dc.w	$081C	;081C
	dc.w	$0108	;0108
	dc.w	$1021	;1021
	dc.w	$0000	;0000
	dc.w	$001D	;001D
	dc.w	$0008	;0008
	dc.w	$101C	;101C
	dc.w	$000B	;000B
	dc.w	$001C	;001C
	dc.w	$010B	;010B
	dc.w	$101B	;101B
	dc.w	$000F	;000F
	dc.w	$001B	;001B
	dc.w	$0010	;0010
	dc.w	$081A	;081A
	dc.w	$0015	;0015
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0016	;0016
	dc.w	$0023	;0023
	dc.w	$381C	;381C
	dc.w	$0008	;0008
	dc.w	$301D	;301D
	dc.w	$0007	;0007
	dc.w	$281C	;281C
	dc.w	$0108	;0108
	dc.w	$2821	;2821
	dc.w	$0000	;0000
	dc.w	$381D	;381D
	dc.w	$0008	;0008
	dc.w	$281C	;281C
	dc.w	$000B	;000B
	dc.w	$301C	;301C
	dc.w	$010B	;010B
	dc.w	$281B	;281B
	dc.w	$000F	;000F
	dc.w	$381B	;381B
	dc.w	$0010	;0010
	dc.w	$301A	;301A
	dc.w	$0015	;0015
	dc.w	$3806	;3806
	dc.w	$0000	;0000
	dc.w	$3816	;3816
	dc.w	$0023	;0023
	dc.w	$181C	;181C
	dc.w	$0008	;0008
	dc.w	$181C	;181C
	dc.w	$000B	;000B
	dc.w	$181B	;181B
	dc.w	$0010	;0010
	dc.w	$1018	;1018
	dc.w	$011A	;011A
adrEA00BD56:
	dc.w	$001A	;001A
	dc.w	$000D	;000D
	dc.w	$001B	;001B
	dc.w	$010B	;010B
	dc.w	$081A	;081A
	dc.w	$010E	;010E
	dc.w	$101A	;101A
	dc.w	$010C	;010C
	dc.w	$0019	;0019
	dc.w	$0010	;0010
	dc.w	$1019	;1019
	dc.w	$0010	;0010
	dc.w	$0018	;0018
	dc.w	$0113	;0113
	dc.w	$1017	;1017
	dc.w	$0017	;0017
	dc.w	$0016	;0016
	dc.w	$011B	;011B
	dc.w	$0813	;0813
	dc.w	$0020	;0020
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$000E	;000E
	dc.w	$0031	;0031
	dc.w	$381A	;381A
	dc.w	$000D	;000D
	dc.w	$301C	;301C
	dc.w	$010B	;010B
	dc.w	$281A	;281A
	dc.w	$010E	;010E
	dc.w	$201A	;201A
	dc.w	$010C	;010C
	dc.w	$3819	;3819
	dc.w	$0010	;0010
	dc.w	$2819	;2819
	dc.w	$0010	;0010
	dc.w	$3018	;3018
	dc.w	$0113	;0113
	dc.w	$2817	;2817
	dc.w	$0017	;0017
	dc.w	$3016	;3016
	dc.w	$011B	;011B
	dc.w	$3013	;3013
	dc.w	$0020	;0020
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$380E	;380E
	dc.w	$0031	;0031
	dc.w	$181A	;181A
	dc.w	$000E	;000E
	dc.w	$1818	;1818
	dc.w	$0013	;0013
	dc.w	$1016	;1016
	dc.w	$011B	;011B
	dc.w	$1012	;1012
	dc.w	$0128	;0128
adrEA00BDC6:
	dc.w	$001D	;001D
	dc.w	$0006	;0006
	dc.w	$081D	;081D
	dc.w	$0006	;0006
	dc.w	$081D	;081D
	dc.w	$0106	;0106
	dc.w	$101A	;101A
	dc.w	$0000	;0000
	dc.w	$001C	;001C
	dc.w	$0007	;0007
	dc.w	$101C	;101C
	dc.w	$0000	;0000
	dc.w	$001C	;001C
	dc.w	$0108	;0108
	dc.w	$1017	;1017
	dc.w	$0000	;0000
	dc.w	$001B	;001B
	dc.w	$000D	;000D
	dc.w	$0819	;0819
	dc.w	$0013	;0013
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0016	;0016
	dc.w	$001B	;001B
	dc.w	$381D	;381D
	dc.w	$0006	;0006
	dc.w	$301D	;301D
	dc.w	$0006	;0006
	dc.w	$281D	;281D
	dc.w	$0106	;0106
	dc.w	$201A	;201A
	dc.w	$0000	;0000
	dc.w	$381C	;381C
	dc.w	$0007	;0007
	dc.w	$2819	;2819
	dc.w	$0000	;0000
	dc.w	$301C	;301C
	dc.w	$0108	;0108
	dc.w	$2817	;2817
	dc.w	$0000	;0000
	dc.w	$381B	;381B
	dc.w	$000D	;000D
	dc.w	$3019	;3019
	dc.w	$0013	;0013
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3816	;3816
	dc.w	$001B	;001B
	dc.w	$181D	;181D
	dc.w	$0006	;0006
	dc.w	$181C	;181C
	dc.w	$0008	;0008
	dc.w	$181B	;181B
	dc.w	$000D	;000D
	dc.w	$1019	;1019
	dc.w	$0115	;0115
adrEA00BE36:
	dc.w	$001D	;001D
	dc.w	$0000	;0000
	dc.w	$081D	;081D
	dc.w	$0005	;0005
	dc.w	$081D	;081D
	dc.w	$0005	;0005
	dc.w	$101A	;101A
	dc.w	$0000	;0000
	dc.w	$001D	;001D
	dc.w	$0006	;0006
	dc.w	$101C	;101C
	dc.w	$0008	;0008
	dc.w	$001D	;001D
	dc.w	$0107	;0107
	dc.w	$101D	;101D
	dc.w	$0008	;0008
	dc.w	$001D	;001D
	dc.w	$000A	;000A
	dc.w	$081B	;081B
	dc.w	$000D	;000D
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0019	;0019
	dc.w	$0014	;0014
	dc.w	$381D	;381D
	dc.w	$0000	;0000
	dc.w	$301D	;301D
	dc.w	$0005	;0005
	dc.w	$301D	;301D
	dc.w	$0005	;0005
	dc.w	$201A	;201A
	dc.w	$0000	;0000
	dc.w	$381D	;381D
	dc.w	$0006	;0006
	dc.w	$281C	;281C
	dc.w	$0008	;0008
	dc.w	$301D	;301D
	dc.w	$0107	;0107
	dc.w	$281D	;281D
	dc.w	$0008	;0008
	dc.w	$381D	;381D
	dc.w	$000A	;000A
	dc.w	$301B	;301B
	dc.w	$000D	;000D
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3819	;3819
	dc.w	$0014	;0014
	dc.w	$181D	;181D
	dc.w	$0005	;0005
	dc.w	$181D	;181D
	dc.w	$0007	;0007
	dc.w	$181D	;181D
	dc.w	$000A	;000A
	dc.w	$181C	;181C
	dc.w	$0011	;0011
adrEA00BEA6:
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$081F	;081F
	dc.w	$0000	;0000
	dc.w	$081E	;081E
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$001F	;001F
	dc.w	$0001	;0001
	dc.w	$101F	;101F
	dc.w	$0000	;0000
	dc.w	$001D	;001D
	dc.w	$0104	;0104
	dc.w	$101E	;101E
	dc.w	$0005	;0005
	dc.w	$001D	;001D
	dc.w	$0006	;0006
	dc.w	$081D	;081D
	dc.w	$0008	;0008
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$001B	;001B
	dc.w	$000E	;000E
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$301F	;301F
	dc.w	$0000	;0000
	dc.w	$301E	;301E
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$381F	;381F
	dc.w	$0001	;0001
	dc.w	$281F	;281F
	dc.w	$0000	;0000
	dc.w	$301D	;301D
	dc.w	$0104	;0104
	dc.w	$281E	;281E
	dc.w	$0005	;0005
	dc.w	$381D	;381D
	dc.w	$0006	;0006
	dc.w	$301D	;301D
	dc.w	$0008	;0008
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$381B	;381B
	dc.w	$000E	;000E
	dc.w	$181E	;181E
	dc.w	$0001	;0001
	dc.w	$181C	;181C
	dc.w	$0006	;0006
	dc.w	$181C	;181C
	dc.w	$0008	;0008
	dc.w	$181C	;181C
	dc.w	$000C	;000C
adrEA00BF16:
	dc.w	$002A	;002A
	dc.w	$0000	;0000
	dc.w	$082A	;082A
	dc.w	$0100	;0100
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$002D	;002D
	dc.w	$0102	;0102
	dc.w	$0032	;0032
	dc.w	$0102	;0102
	dc.w	$0039	;0039
	dc.w	$0005	;0005
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$382A	;382A
	dc.w	$0000	;0000
	dc.w	$282A	;282A
	dc.w	$0100	;0100
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$302D	;302D
	dc.w	$0102	;0102
	dc.w	$3032	;3032
	dc.w	$0102	;0102
	dc.w	$3839	;3839
	dc.w	$0005	;0005
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$182A	;182A
	dc.w	$0100	;0100
	dc.w	$182D	;182D
	dc.w	$0102	;0102
	dc.w	$1832	;1832
	dc.w	$0102	;0102
	dc.w	$1039	;1039
	dc.w	$0305	;0305
	dc.w	$1049	;1049
	dc.w	$0302	;0302
adrEA00BF62:
	dc.w	$0016	;0016
	dc.w	$0000	;0000
	dc.w	$0816	;0816
	dc.w	$0100	;0100
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0013	;0013
	dc.w	$0100	;0100
	dc.w	$000F	;000F
	dc.w	$0101	;0101
	dc.w	$0009	;0009
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3816	;3816
	dc.w	$0000	;0000
	dc.w	$2816	;2816
	dc.w	$0100	;0100
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3013	;3013
	dc.w	$0100	;0100
	dc.w	$300F	;300F
	dc.w	$0101	;0101
	dc.w	$3809	;3809
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1816	;1816
	dc.w	$0100	;0100
	dc.w	$1813	;1813
	dc.w	$0100	;0100
	dc.w	$180F	;180F
	dc.w	$0101	;0101
	dc.w	$1009	;1009
	dc.w	$0303	;0303
	dc.w	$1000	;1000
	dc.w	$0303	;0303
adrEA00BFAE:
	dc.w	$0018	;0018
	dc.w	$0013	;0013
	dc.w	$0819	;0819
	dc.w	$0011	;0011
	dc.w	$0818	;0818
	dc.w	$0113	;0113
	dc.w	$1819	;1819
	dc.w	$0011	;0011
	dc.w	$0016	;0016
	dc.w	$0017	;0017
	dc.w	$1017	;1017
	dc.w	$0018	;0018
	dc.w	$0016	;0016
	dc.w	$011A	;011A
	dc.w	$1015	;1015
	dc.w	$0020	;0020
	dc.w	$0014	;0014
	dc.w	$0023	;0023
	dc.w	$0811	;0811
	dc.w	$002D	;002D
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$000A	;000A
	dc.w	$0041	;0041
	dc.w	$3818	;3818
	dc.w	$0013	;0013
	dc.w	$3019	;3019
	dc.w	$0011	;0011
	dc.w	$2818	;2818
	dc.w	$0113	;0113
	dc.w	$2019	;2019
	dc.w	$0011	;0011
	dc.w	$3816	;3816
	dc.w	$0017	;0017
	dc.w	$2817	;2817
	dc.w	$0018	;0018
	dc.w	$3016	;3016
	dc.w	$011A	;011A
	dc.w	$2815	;2815
	dc.w	$0020	;0020
	dc.w	$3814	;3814
	dc.w	$0023	;0023
	dc.w	$3011	;3011
	dc.w	$002D	;002D
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$380A	;380A
	dc.w	$0041	;0041
	dc.w	$1818	;1818
	dc.w	$0013	;0013
	dc.w	$1816	;1816
	dc.w	$001A	;001A
	dc.w	$1814	;1814
	dc.w	$0023	;0023
	dc.w	$100F	;100F
	dc.w	$0135	;0135

adrCd00C01E:
	lea	SelectChampsMsg.l,a6	;4DF90000E480
	tst.w	MultiPlayer.l	;4A790000EE30
	beq.s	adrCd00C032	;6706
	move.b	#$2E,$001B(a6)	;1D7C002E001B
adrCd00C032:
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$0050,a0	;D0FC0050
	move.l	#$000F0000,adrW_00D92A.l	;23FC000F00000000D92A
	bsr	Print_fflim_text	;6100107E
	lea	Player1_Data.l,a5	;4BF90000EE7C
	tst.w	MultiPlayer.l	;4A790000EE30
	bmi.s	adrCd00C060	;6B08
	bsr.s	adrCd00C060	;6106
	lea	Player2_Data.l,a5	;4BF90000EEDE
adrCd00C060:
	clr.w	$0014(a5)	;426D0014
	move.l	#$002F00A8,d4	;283C002F00A8
	moveq	#$09,d5	;7A09
	bsr.s	adrCd00C0BA	;614C
	move.l	#$009700A8,d4	;283C009700A8
	move.l	#$00070058,d5	;2A3C00070058
	add.w	$0008(a5),d5	;DA6D0008
	move.w	$0010(a5),d3	;362D0010
	bsr	BW_draw_bar	;610019E4
	moveq	#$2A,d5	;7A2A
	bsr	adrCd00CC3A	;61000BB0
	move.l	#$00970001,d3	;263C00970001
	move.w	#$00A8,d4	;383C00A8
	moveq	#$54,d5	;7A54
	add.w	$0008(a5),d5	;DA6D0008
adrCd00C09C:
	bsr	BW_blit_horiz_line	;61001AE6
	addq.w	#$01,d5	;5245
	addq.w	#$01,d3	;5243
	cmpi.w	#$0005,d3	;0C430005
	bcs.s	adrCd00C09C	;65F2
	addq.w	#$08,d5	;5045
	subq.w	#$01,d3	;5343
adrCd00C0AE:
	bsr	BW_blit_horiz_line	;61001AD4
	addq.w	#$01,d5	;5245
	subq.w	#$01,d3	;5343
	bne.s	adrCd00C0AE	;66F6
	rts	;4E75

adrCd00C0BA:
	add.w	$0008(a5),d5	;DA6D0008
	swap	d5	;4845
	move.w	#$002B,d5	;3A3C002B
	swap	d5	;4845
	moveq	#$01,d3	;7601
	movem.l	d3-d5,-(sp)	;48E71C00
	bsr	BW_draw_bar	;6100199A
	movem.l	(sp)+,d3-d5	;4CDF0038
adrCd00C0D4:
	addq.w	#$01,d4	;5244
	addq.w	#$01,d5	;5245
	sub.l	#$00020000,d5	;048500020000	;Long Addr replaced with Symbol
	sub.l	#$00020000,d4	;048400020000	;Long Addr replaced with Symbol
	addq.w	#$01,d3	;5243
	movem.l	d3-d5,-(sp)	;48E71C00
	bsr	BW_draw_frame	;610019E8
	movem.l	(sp)+,d3-d5	;4CDF0038
	cmpi.w	#$0004,d3	;0C430004
	bne.s	adrCd00C0D4	;66DC
	rts	;4E75

ChampionSelection_Main:
	moveq	#-$01,d0	;70FF
	move.w	d0,adrW_00C514.l	;33C00000C514
	move.b	d0,adrB_00EE83.l	;13C00000EE83
	move.b	d0,adrB_00EEE5.l	;13C00000EEE5
	move.l	#$00B00040,adrL_00EE7E.l	;23FC00B000400000EE7E
	move.l	#$00B00078,adrL_00EEE0.l	;23FC00B000780000EEE0
	clr.b	adrB_00EECE.l	;42390000EECE
	move.w	#$BA02,d0	;303CBA02
	move.w	d0,adrW_00EEB6.l	;33C00000EEB6
	move.w	d0,adrW_00EF18.l	;33C00000EF18
	tst.w	MultiPlayer.l	;4A790000EE30
	beq.s	adrCd00C168	;6728
	clr.w	adrW_00C514.l	;42790000C514
	move.w	#$FFFF,adrW_00EEF2.l	;33FCFFFF0000EEF2
	move.l	#$00D80000,adrL_00EEE0.l	;23FC00D800000000EEE0
	move.w	#$0026,adrW_00EE84.l	;33FC00260000EE84
	move.w	#$05F0,adrW_00EE86.l	;33FC05F00000EE86
adrCd00C168:
	bsr	ChampionSelection	;61000C22
	bsr	adrCd00C01E	;6100FEB0
	bsr	adrCd008CCA	;6100CB58
	bsr	ChampionSelection	;61000C16
	bsr	adrCd00C01E	;6100FEA4
	move.w	#$0005,adrW_00EEC6.l	;33FC00050000EEC6
	move.b	#$01,adrB_008C1F.l	;13FC000100008C1F
	jsr	adrEA0008F2.w	;4EB808F2	;Short Absolute converted to symbol!
adrCd00C190:
	move.w	adrW_00EEF2.l,d1	;32390000EEF2
	lea	Player1_Data.l,a5	;4BF90000EE7C
	and.w	$0014(a5),d1	;C26D0014
	bmi.s	ExitOrLoop	;6B52
	clr.b	adrB_00EE2C.l	;42390000EE2C
	bsr	adrCd00C1F6	;6100004C
	bsr	adrCd00C232	;61000084
	lea	Player2_Data.l,a5	;4BF90000EEDE
	bsr	adrCd00C1F6	;6100003E
	bsr	adrCd00C232	;61000076
	move.b	#$FF,adrB_008C1E.l	;13FC00FF00008C1E
adrCd00C1C6:
	tst.b	adrB_008C1E.l	;4A3900008C1E
	bne.s	adrCd00C1C6	;66F8
	move.b	#$01,adrB_00EE2C.l	;13FC00010000EE2C
	lea	Player1_Data.l,a5	;4BF90000EE7C
	bsr	adrCd00C232	;61000054
	clr.w	$000C(a5)	;426D000C
	lea	Player2_Data.l,a5	;4BF90000EEDE
	bsr	adrCd00C232	;61000046
	clr.w	$000C(a5)	;426D000C
	bra.s	adrCd00C190	;609C

ExitOrLoop:
	rts	;4E75

adrCd00C1F6:
	move.w	$0022(a5),$0024(a5)		;3B6D00220024
	bclr	#$07,$0001(a5)			;08AD00070001
	beq.s	ExitOrLoop			;67F0
	move.w	$0014(a5),d0			;302D0014
	bmi.s	ExitOrLoop			;6BEA
	cmpi.b	#$03,d0				;0C000003
	beq.s	ExitOrLoop			;67E4
	bsr	adrCd00C74C			;6100053A
	bpl.s	ExitOrLoop			;6ADE
	tst.b	$0007(a5)			;4A2D0007
	bmi.s	ExitOrLoop			;6BD8
	bsr	adrCd00C5F4			;610003D6
	bpl.s	ExitOrLoop			;6AD2
	bsr	adrCd00C622			;610003FE
	bpl.s	ExitOrLoop			;6ACC
	bsr	adrCd00C70C			;610004E2
	bpl.s	ExitOrLoop			;6AC6
	bra	adrCd00C650			;60000420

adrCd00C232:
	move.w	$0014(a5),d0			;302D0014
	bmi.s	ExitOrLoop			;6BBC
	cmpi.b	#$03,d0				;0C000003
	bne.s	adrCd00C252			;6614
	lsr.w	#$08,d0				;E048
	cmpi.w	#$0007,d0			;0C400007
	bne.s	adrCd00C24E			;6608
	move.w	#$0002,$0014(a5)		;3B7C00020014
	rts	;4E75

adrCd00C24E:
	move.w	d0,$000C(a5)	;3B40000C
adrCd00C252:
	move.w	$000C(a5),d0	;302D000C
	beq.s	ExitOrLoop	;679C
	asl.w	#$02,d0	;E540
	lea	adrJB00C262.l,a0	;41F90000C262
	move.l	$00(a0,d0.w),a0	;20700000
adrJB00C262:	equ	*-2
	jmp	(a0)	;4ED0

ChampionPreviews_LookupTable:
	dc.l	Click_SelectionAvatar	;0000C53C
	dc.l	Click_SwitchView	;0000C436
	dc.l	Click_SelectChampion	;0000C490
	dc.l	Click_ViewObject	;0000C516
	dc.l	Click_PreviewSpell	;0000C286
	dc.l	Click_TurnSpellBookPage	;0000C2EA
	dc.l	ExitOrLoop	;0000C1F4
	dc.l	Click_TurnSpellBookPage	;0000C2EA

Click_PreviewSpell:
	bsr	adrCd00C2AC	;61000024
	bpl.s	adrCd00C298	;6A0C
	move.w	$0006(a5),d7	;3E2D0006
	bsr	adrCd00CFF0	;61000D5E
	bra	adrCd00C85E	;600005C8

adrCd00C298:
	moveq	#$07,d6	;7C07
	bsr	adrCd00D01A	;61000D7E
	bsr	adrLp00CFDA	;61000D3A
	moveq	#$0A,d6	;7C0A
	bsr	TerminateText	;61000D62
	bra	adrCd00C85E	;600005B4

adrCd00C2AC:
	bsr	adrCd00665C	;6100A3AE
	move.w	$002A(a5),d0	;302D002A
	move.w	d0,d2	;3400
	asl.w	#$02,d2	;E542
	lsr.w	#$01,d0	;E248
	move.w	d0,d3	;3600
	move.w	$000E(a5),d0	;302D000E
	btst	d0,$0C(a4,d3.w)	;0134300C
	beq.s	adrCd00C2E0	;671A
	eor.w	#$0007,d0	;0A400007
	add.w	d2,d0	;D042
	move.b	d0,$0013(a4)	;19400013
	clr.b	$0014(a4)	;422C0014
adrCd00C2D4:
	asl.w	#$03,d0	;E740
	lea	SpellNames.l,a6	;4DF900019E8E
	add.w	d0,a6	;DCC0
	rts	;4E75

adrCd00C2E0:
	move.b	#$FF,$0013(a4)	;197C00FF0013
	moveq	#-$01,d0	;70FF
adrCd00C2E8:
	rts	;4E75

Click_TurnSpellBookPage:
	tst.w	$0024(a5)	;4A6D0024
	bne.s	adrCd00C2E8	;66F8
	tst.b	$000F(a5)	;4A2D000F
	bpl.s	adrCd00C322	;6A2C
	tst.b	$000E(a5)	;4A2D000E
	bmi.s	adrCd00C30C	;6B10
	addq.w	#$02,$002A(a5)	;546D002A
	and.w	#$0007,$002A(a5)	;026D0007002A
	move.w	#$FFFF,$000E(a5)	;3B7CFFFF000E
adrCd00C30C:
	tst.b	adrB_00EE2C.l	;4A390000EE2C
	beq.s	adrCd00C31A	;6706
	move.w	#$0002,$0014(a5)	;3B7C00020014
adrCd00C31A:
	bsr	adrCd00C7C8	;610004AC
	bra	adrCd00C85E	;6000053E

adrCd00C322:
	bsr	adrCd00C7C8	;610004A4
	move.w	$002A(a5),d0	;302D002A
	bsr	adrCd00C86A	;6100053E
	move.w	$000E(a5),d1	;322D000E
	bpl.s	adrCd00C338	;6A04
	eor.w	#$0003,d1	;0A410003
adrCd00C338:
	and.w	#$0003,d1	;02410003
	move.w	$002A(a5),d0	;302D002A
	cmpi.w	#$0003,d1	;0C410003
	bne.s	adrCd00C39C	;6656
	addq.w	#$01,d0	;5240
	bsr	adrCd00C86A	;61000520
	move.w	$002A(a5),d0	;302D002A
	addq.w	#$03,d0	;5640
	and.w	#$0007,d0	;02400007
	move.w	d0,d7	;3E00
	asl.w	#$04,d0	;E940
	lea	SpellBookRunes+$3.l,a6	;4DF900018787
	add.w	d0,a6	;DCC0
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$0436,a0	;D0FC0436
	add.w	$000A(a5),a0	;D0ED000A
	move.l	a4,a3	;264C
	move.w	d7,d0	;3007
	lsr.w	#$01,d0	;E248
	add.w	d0,a3	;D6C0
	asl.w	#$02,d7	;E547
	swap	d7	;4847
	move.w	#$0003,d7	;3E3C0003
adrLp00C380:
	bsr	adrCd00C906	;61000584
	move.w	d6,adrW_00D92A.l	;33C60000D92A
	move.b	(a6),d0	;1016
	bsr	adrCd00D8C0	;61001532
	addq.w	#$04,a6	;584E
	add.w	#$013F,a0	;D0FC013F
	dbra	d7,adrLp00C380	;51CFFFE8
	bra.s	adrCd00C3A6	;600A

adrCd00C39C:
	addq.w	#$03,d0	;5640
	and.w	#$0007,d0	;02400007
	bsr	adrCd00C86A	;610004C6
adrCd00C3A6:
	move.w	$002A(a5),d7	;3E2D002A
	addq.w	#$02,d7	;5447
	and.w	#$0007,d7	;02470007
	move.w	d7,d0	;3007
	lsr.w	#$01,d0	;E248
	move.l	a4,a3	;264C
	add.w	d0,a3	;D6C0
	asl.w	#$02,d7	;E547
	swap	d7	;4847
	move.w	#$0007,d7	;3E3C0007
	lea	adrEA00B4C0.l,a6	;4DF90000B4C0
	moveq	#$03,d5	;7A03
adrLp00C3C8:
	bsr	adrCd00C906	;6100053C
	move.b	d6,(a6)+	;1CC6
	subq.w	#$01,d7	;5347
	dbra	d5,adrLp00C3C8	;51CDFFF6
	move.w	$000E(a5),d0	;302D000E
	bpl.s	adrCd00C3DE	;6A04
	eor.w	#$0003,d0	;0A400003
adrCd00C3DE:
	and.w	#$0003,d0	;02400003
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$0186,a0	;D0FC0186
	add.w	$000A(a5),a0	;D0ED000A
	lea	_GFX_Pockets+$4130.l,a1	;43F900050832
	add.w	d0,d0	;D040
	add.w	d0,a0	;D0C0
	asl.w	#$03,d0	;E740
	add.w	d0,a1	;D2C0
	move.l	#$00010037,d5	;2A3C00010037	;Long Addr replaced with Symbol
	move.w	#$0004,d3	;363C0004
	swap	d3	;4843
	move.l	#$00000090,a3	;267C00000090
	move.w	#$FFFF,adrW_00B4BE.l	;33FCFFFF0000B4BE
	bsr	adrLp00B5CC	;6100F1B2
	clr.w	adrW_00B4BE.l	;42790000B4BE
	tst.b	adrB_00EE2C.l	;4A390000EE2C
	beq.s	adrCd00C434	;670A
	subq.b	#$01,$000F(a5)	;532D000F
	move.w	#$0006,$0022(a5)	;3B7C00060022
adrCd00C434:
	rts	;4E75

Click_SwitchView:
	move.w	$0006(a5),d7	;3E2D0006
	bsr	adrCd00CFF0	;61000BB4
adrCd00C43E:
	move.w	$0014(a5),d0	;302D0014
	add.w	#$0060,d0	;06400060
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$0A16,a0	;D0FC0A16
	add.w	$000A(a5),a0	;D0ED000A
	bsr	adrCd00CAEA	;61000694
	move.w	$0014(a5),d0	;302D0014
	asl.w	#$02,d0	;E540
	lea	adrJT00C484.l,a0	;41F90000C484
	move.l	$00(a0,d0.w),a0	;20700000
	jsr	(a0)	;4E90
	tst.b	adrB_00EE2C.l	;4A390000EE2C
	beq.s	adrCd00C482	;6710
	addq.w	#$01,$0014(a5)	;526D0014
	cmp.w	#$0003,$0014(a5)	;0C6D00030014
	bcs.s	adrCd00C482	;6504
	clr.w	$0014(a5)	;426D0014
adrCd00C482:
	rts	;4E75

adrJT00C484:
	dc.l	adrJA00C938	;0000C938
	dc.l	adrJA00C852	;0000C852
	dc.l	adrJA00CB28	;0000CB28

Click_SelectChampion:
	clr.w	adrW_00EEC8.l	;42790000EEC8
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$0050,a0	;D0FC0050
	lea	SelectThyChampMsg.l,a6	;4DF90000E4A0
	moveq	#$27,d6	;7C27
	tst.w	adrW_00C514.l	;4A790000C514
	bne.s	adrCd00C4BA	;660A
	move.w	#$00FF,adrW_00EEC6.l	;33FC00FF0000EEC6
	bra.s	adrCd00C4E0	;6026

adrCd00C4BA:
	move.b	(a5),d0	;1015
	not.w	d0	;4640
	and.w	#$0001,d0	;02400001
	add.b	#$31,d0	;06000031
	move.b	d0,$0007(a6)	;1D400007
	move.l	#$000F0000,adrW_00D92A.l	;23FC000F00000000D92A
	bsr	Print_fflim_text	;61000BF0
	move.w	#$0005,adrW_00EEC6.l	;33FC00050000EEC6
adrCd00C4E0:
	moveq	#$2A,d5	;7A2A
	bsr	adrCd00CC3A	;61000756
	move.b	(a5),d0	;1015
	and.w	#$0001,d0	;02400001
	add.b	#$31,d0	;06000031
	lea	BeginGameScroll.l,a6	;4DF90000E9A8
	move.b	d0,$000E(a6)	;1D40000E
	bsr	Print_fflim_text	;61000BCA
	tst.b	adrB_00EE2C.l	;4A390000EE2C
	beq.s	adrCd00C512	;670C
	move.w	#$FFFF,$0014(a5)	;3B7CFFFF0014
	clr.w	adrW_00C514.l	;42790000C514
adrCd00C512:
	rts	;4E75

adrW_00C514:
	dc.w	$FFFF	;FFFF

Click_ViewObject:
	move.w	$0006(a5),d0	;302D0006
	asl.w	#$04,d0	;E940
	lea	PocketContents.l,a6	;4DF90000ED2A
	add.w	d0,a6	;DCC0
	move.w	$000E(a5),d0	;302D000E
	move.b	$00(a6,d0.w),d0	;10360000
	lea	ObjectDefinitionsTable.l,a6	;4DF90000E4C4
	add.w	d0,d0	;D040
	add.w	d0,d0	;D040
	add.w	d0,a6	;DCC0
	bra	InventoryItem_Description	;600012BE

Click_SelectionAvatar:
	move.w	$0006(a5),d7	;3E2D0006
	move.w	d7,-(sp)	;3F07
	bsr	Draw_Select_Avatars	;61000852
	move.w	$000E(a5),d7	;3E2D000E
	move.w	d7,$0006(a5)	;3B470006
	move.w	$0012(a5),d3	;362D0012
	bsr	adrCd00CD78	;61000824
	clr.w	d4	;4244
	move.l	#$00000296,a0	;207C00000296
	move.w	$0006(a5),d7	;3E2D0006
	bsr	adrCd00CD1C	;610007B8
	bsr	adrCd00CFF0	;61000A88
	bsr	adrCd00665C	;6100A0F0
	move.b	#$FF,$0013(a4)	;197C00FF0013
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$0A19,a0	;D0FC0A19
	add.w	$000A(a5),a0	;D0ED000A
	move.w	d7,d0	;3007
	bsr	adrCd008430	;6100BEAA
	tst.b	$0001(sp)	;4A2F0001
	bpl.s	adrCd00C590	;6A02
	bsr.s	adrCd00C5B8	;6128
adrCd00C590:
	tst.b	adrB_00EE2C.l	;4A390000EE2C
	bne.s	adrCd00C5A4	;660C
	subq.w	#$01,$0014(a5)	;536D0014
	bcc.s	adrCd00C5A4	;6406
	move.w	#$0002,$0014(a5)	;3B7C00020014
adrCd00C5A4:
	bsr	adrCd00C43E	;6100FE98
	move.w	(sp)+,d7	;3E1F
	tst.b	adrB_00EE2C.l	;4A390000EE2C
	bne.s	adrCd00C5B6	;6604
	move.w	d7,$0006(a5)	;3B470006
adrCd00C5B6:
	rts	;4E75

adrCd00C5B8:
	move.l	#$001700AD,d4	;283C001700AD
	bsr.s	adrCd00C5C6	;6106
	move.l	#$001700C5,d4	;283C001700C5
adrCd00C5C6:
	move.l	#$0013003E,d5	;2A3C0013003E
	moveq	#$02,d3	;7602
	add.w	$0008(a5),d5	;DA6D0008
	movem.l	d4/d5,-(sp)	;48E70C00
	bsr	BW_cs_draw_frame	;610014AC
	movem.l	(sp)+,d4/d5	;4CDF0030
	addq.w	#$01,d4	;5244
	sub.l	#$00020000,d4	;048400020000	;Long Addr replaced with Symbol
	sub.l	#$00020000,d5	;048500020000	;Long Addr replaced with Symbol
	addq.w	#$01,d5	;5245
	moveq	#$04,d3	;7604
	bra	BW_draw_frame	;600014E2

adrCd00C5F4:
	move.l	$0002(a5),d1	;222D0002
	sub.w	$0008(a5),d1	;926D0008
	cmpi.w	#$0040,d1	;0C410040
	bcs.s	adrCd00C61E	;651C
	cmpi.w	#$0050,d1	;0C410050
	bcc.s	adrCd00C61E	;6416
	swap	d1	;4841
	cmpi.w	#$00AF,d1	;0C4100AF
	bcs.s	adrCd00C61E	;650E
	cmpi.w	#$00C3,d1	;0C4100C3
	bcc.s	adrCd00C61E	;6408
	move.w	#$0002,$000C(a5)	;3B7C0002000C
	clr.w	d2	;4242
adrCd00C61E:
	tst.w	d2	;4A42
	rts	;4E75

adrCd00C622:
	move.l	$0002(a5),d1	;222D0002
	sub.w	$0008(a5),d1	;926D0008
	cmpi.w	#$0040,d1	;0C410040
	bcs.s	adrCd00C64C	;651C
	cmpi.w	#$0050,d1	;0C410050
	bcc.s	adrCd00C64C	;6416
	swap	d1	;4841
	cmpi.w	#$00C6,d1	;0C4100C6
	bcs.s	adrCd00C64C	;650E
	cmpi.w	#$00DA,d1	;0C4100DA
	bcc.s	adrCd00C64C	;6408
	move.w	#$0003,$000C(a5)	;3B7C0003000C
	clr.w	d2	;4242
adrCd00C64C:
	tst.w	d2	;4A42
	rts	;4E75

adrCd00C650:
	cmp.w	#$0002,$0014(a5)	;0C6D00020014
	bne.s	adrCd00C64C	;66F4
	move.l	$0002(a5),d1	;222D0002
	sub.w	$0008(a5),d1	;926D0008
	sub.w	#$0018,d1	;04410018
	bcs.s	adrCd00C69C	;6536
	cmpi.w	#$0020,d1	;0C410020
	bcc.s	adrCd00C64C	;64E0
	swap	d1	;4841
	sub.w	#$00E8,d1	;044100E8
	bcs.s	adrCd00C64C	;65D8
	moveq	#$00,d0	;7000
	sub.w	#$0020,d1	;04410020
	bcs.s	adrCd00C684	;6508
	sub.w	#$0010,d1	;04410010
	bcs.s	adrCd00C64C	;65CA
	addq.w	#$04,d0	;5840
adrCd00C684:
	swap	d1	;4841
	lsr.w	#$03,d1	;E649
	add.w	d1,d0	;D041
	eor.w	#$0007,d0	;0A400007
	move.w	#$0005,$000C(a5)	;3B7C0005000C
	move.w	d0,$000E(a5)	;3B40000E
	moveq	#$00,d2	;7400
	rts	;4E75

adrCd00C69C:
	add.w	#$0018,d1	;06410018
	cmpi.w	#$0007,d1	;0C410007
	bcs.s	adrCd00C708	;6562
	cmpi.w	#$0010,d1	;0C410010
	bcc.s	adrCd00C708	;645C
	swap	d1	;4841
	cmpi.w	#$00E8,d1	;0C4100E8
	bcs.s	adrCd00C708	;6554
	moveq	#$06,d0	;7006
	cmpi.w	#$00F8,d1	;0C4100F8
	bcs.s	adrCd00C6D8	;651C
	cmpi.w	#$0100,d1	;0C410100
	bcs.s	adrCd00C708	;6546
	moveq	#$07,d0	;7007
	cmpi.w	#$0120,d1	;0C410120
	bcs.s	adrCd00C6D8	;650E
	cmpi.w	#$0128,d1	;0C410128
	bcs.s	adrCd00C708	;6538
	moveq	#$08,d0	;7008
	cmpi.w	#$0138,d1	;0C410138
	bcc.s	adrCd00C708	;6430
adrCd00C6D8:
	move.w	d0,$000C(a5)	;3B40000C
	moveq	#$03,d2	;7403
	cmpi.w	#$0006,d0	;0C400006
	bne.s	adrCd00C6F2	;660E
	subq.w	#$02,$002A(a5)	;556D002A
	and.w	#$0007,$002A(a5)	;026D0007002A
	move.w	#$8003,d2	;343C8003
adrCd00C6F2:
	rol.w	#$08,d0	;E158
	move.b	#$03,d0	;103C0003
	move.w	d0,$0014(a5)	;3B400014
	move.w	d2,$000E(a5)	;3B42000E
	move.w	#$0008,$0022(a5)	;3B7C00080022
	move.w	d0,d2	;3400
adrCd00C708:
	tst.w	d2	;4A42
	rts	;4E75

adrCd00C70C:
	cmp.w	#$0001,$0014(a5)	;0C6D00010014
	bne.s	adrCd00C748	;6634
adrCd00C714:
	move.l	$0002(a5),d1	;222D0002
	sub.w	$0008(a5),d1	;926D0008
	sub.w	#$0020,d1	;04410020
	bcs.s	adrCd00C748	;6526
	cmpi.w	#$0020,d1	;0C410020
	bcc.s	adrCd00C748	;6420
	swap	d1	;4841
	sub.w	#$00E0,d1	;044100E0
	bcs.s	adrCd00C748	;6518
	move.w	#$0004,$000C(a5)	;3B7C0004000C
	lsr.w	#$04,d1	;E849
	move.w	d1,d2	;3401
	swap	d1	;4841
	sub.w	#$0010,d1	;04410010
	bcs.s	adrCd00C744	;6502
	addq.w	#$06,d2	;5C42
adrCd00C744:
	move.w	d2,$000E(a5)	;3B42000E
adrCd00C748:
	tst.w	d2	;4A42
	rts	;4E75

adrCd00C74C:
	move.l	$0002(a5),d1	;222D0002
	moveq	#-$01,d2	;74FF
	moveq	#$0E,d3	;760E
adrCd00C754:
	cmp.w	d3,d1	;B243
	bcs.s	adrCd00C760	;6508
	addq.w	#$01,d2	;5242
	add.w	#$0030,d3	;06430030
	bra.s	adrCd00C754	;60F4

adrCd00C760:
	tst.w	d2	;4A42
	bmi.s	adrCd00C7C4	;6B60
	subq.w	#$07,d3	;5F43
	cmp.w	d3,d1	;B243
	bcc.s	adrCd00C7C2	;6458
	swap	d1	;4841
	cmpi.w	#$009E,d1	;0C41009E
	bcc.s	adrCd00C7C2	;6450
	moveq	#$27,d3	;7627
adrCd00C774:
	cmp.w	d3,d1	;B243
	bcs.s	adrCd00C780	;6508
	addq.w	#$04,d2	;5842
	add.w	#$0028,d3	;06430028
	bra.s	adrCd00C774	;60F4

adrCd00C780:
	sub.w	#$0009,d3	;04430009
	cmp.w	d3,d1	;B243
	bcc.s	adrCd00C7C2	;643A
	cmp.w	adrW_00EEE4.l,d2	;B4790000EEE4
	beq.s	adrCd00C7C4	;6734
	cmp.w	adrW_00EE82.l,d2	;B4790000EE82
	beq.s	adrCd00C7C4	;672C
	move.l	a5,d0	;200D
	eor.l	#Player1_Data,d0	;0A800000EE7C
	eor.l	#Player2_Data,d0	;0A800000EEDE
	move.l	d0,a0	;2040
	cmp.w	#$0001,$000C(a0)	;0C680001000C
	bne.s	adrCd00C7B6	;6606
	cmp.w	$000E(a0),d2	;B468000E
	beq.s	adrCd00C7C4	;670E
adrCd00C7B6:
	move.w	d2,$000E(a5)	;3B42000E
	move.w	#$0001,$000C(a5)	;3B7C0001000C
	moveq	#$00,d2	;7400
adrCd00C7C2:
	swap	d2	;4842
adrCd00C7C4:
	tst.w	d2	;4A42
	rts	;4E75

adrCd00C7C8:
	move.w	$0006(a5),d7	;3E2D0006
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$0184,a0	;D0FC0184
	add.w	$000A(a5),a0	;D0ED000A
	move.l	#$00000070,a3	;267C00000070
	move.l	#$0005003D,d5	;2A3C0005003D	;Long Addr replaced with Symbol
	lea	_GFX_Pockets+$4100.l,a1	;43F900050802
	bsr	adrCd00CCB8	;610004CA
	asl.w	#$05,d7	;EB47
	lea	CharacterStats.l,a4	;49F90000EB2A
	add.w	d7,a4	;D8C7
	rts	;4E75

adrCd00C7FC:
	move.l	#$005E00E0,d4	;283C005E00E0
	move.l	#$00480009,d5	;2A3C00480009
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$00,d3	;7600
	bra	BW_draw_bar	;60001258

adrCd00C812:
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$0E2C,a0	;D0FC0E2C
	add.w	$000A(a5),a0	;D0ED000A
adrCd00C820:
	bsr	adrCd00665C	;61009E3A
	or.b	#$0C,$0054(a5)	;002D000C0054
	move.b	$0009(a4),d0	;102C0009
	bsr	adrCd00CEC4	;61000694
	move.b	$000A(a4),d0	;102C000A
	lea	adrEA00EA00.l,a6	;4DF90000EA00
	move.b	d1,$000E(a6)	;1D41000E
	ror.w	#$08,d1	;E059
	move.b	d1,$000D(a6)	;1D41000D
	bsr	adrCd00CEC4	;6100067C
	move.w	d1,$0010(a6)	;3D410010
	bra	Print_fflim_text	;60000876

adrJA00C852:
	bsr.s	adrCd00C7FC	;61A8
	bsr	adrCd00C7C8	;6100FF72
	add.w	#$00A0,a0	;D0FC00A0
	bsr.s	adrCd00C820	;61C2
adrCd00C85E:
	move.w	$002A(a5),d0	;302D002A
	bsr.s	adrCd00C86A	;6106
	move.w	$002A(a5),d0	;302D002A
	addq.w	#$01,d0	;5240
adrCd00C86A:
	or.b	#$04,$0054(a5)	;002D00040054
	move.w	d0,d7	;3E00
	asl.w	#$04,d0	;E940
	lea	SpellBookRunes.l,a6	;4DF900018784
	add.w	d0,a6	;DCC0
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$042D,a0	;D0FC042D
	add.w	$000A(a5),a0	;D0ED000A
	move.w	#$0003,adrW_00D92C.l	;33FC00030000D92C
	move.w	d7,d0	;3007
	lsr.w	#$01,d0	;E248
	move.l	a4,a3	;264C
	add.w	d0,a3	;D6C0
	move.w	d7,d0	;3007
	asl.w	#$02,d7	;E547
	swap	d7	;4847
	and.w	#$0001,d0	;02400001
	bne.s	adrCd00C8D6	;6630
	move.w	#$0007,d7	;3E3C0007
adrCd00C8AA:
	bsr.s	adrCd00C906	;615A
	move.w	d6,adrW_00D92A.l	;33C60000D92A
	moveq	#$02,d6	;7C02
adrLp00C8B4:
	move.b	(a6)+,d0	;101E
	bsr	adrCd00D8C0	;61001008
	dbra	d6,adrLp00C8B4	;51CEFFF8
	sub.w	#$0028,a0	;90FC0028
	move.b	(a6)+,d0	;101E
	bsr	adrCd00D8C0	;61000FFA
	add.w	#$0164,a0	;D0FC0164
	subq.w	#$01,d7	;5347
	cmpi.w	#$0004,d7	;0C470004
	bcc.s	adrCd00C8AA	;64D6
	rts	;4E75

adrCd00C8D6:
	sub.w	#$0022,a0	;90FC0022
	move.w	#$0003,d7	;3E3C0003
adrLp00C8DE:
	bsr.s	adrCd00C906	;6126
	move.w	d6,adrW_00D92A.l	;33C60000D92A
	move.b	(a6)+,d0	;101E
	bsr	adrCd00D8C0	;61000FD6
	add.w	#$0028,a0	;D0FC0028
	moveq	#$02,d6	;7C02
adrLp00C8F2:
	move.b	(a6)+,d0	;101E
	bsr	adrCd00D8C0	;61000FCA
	dbra	d6,adrLp00C8F2	;51CEFFF8
	add.w	#$0114,a0	;D0FC0114
	dbra	d7,adrLp00C8DE	;51CFFFDC
	rts	;4E75

adrCd00C906:
	moveq	#$01,d6	;7C01
	btst	d7,$000C(a3)	;0F2B000C
	beq.s	adrCd00C932	;6724
	swap	d7	;4847
	move.w	d7,d6	;3C07
	swap	d7	;4847
	move.w	d7,d0	;3007
	not.w	d0	;4640
	and.w	#$0003,d0	;02400003
	add.w	d6,d0	;D046
	and.w	#$001F,d0	;0240001F
	moveq	#$0E,d6	;7C0E
	cmp.b	$0013(a4),d0	;B02C0013
	beq.s	adrCd00C932	;6708
	bsr	adrCd006900	;61009FD4
	move.b	adrB_00C934(pc,d0.w),d6	;1C3B0004
adrCd00C932:
	rts	;4E75

adrB_00C934:
	dc.b	$06	;06
	dc.b	$0D	;0D
	dc.b	$0C	;0C
	dc.b	$07	;07

adrJA00C938:
	move.w	d7,-(sp)	;3F07
	bsr	adrCd00C7FC	;6100FEC0
	move.l	#$005D00E2,d4	;283C005D00E2
	move.l	#$00070018,d5	;2A3C00070018
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$03,d3	;7603
	bsr	BW_draw_bar	;61001116
	move.w	#$0040,d5	;3A3C0040
	add.w	$0008(a5),d5	;DA6D0008
	bsr	BW_draw_bar	;6100110A
	move.w	(sp)+,d7	;3E1F
	move.l	#$0000029C,a0	;207C0000029C
	bsr	adrCd008358	;6100B9EE
	move.l	#$00000B5C,a0	;207C00000B5C	;Long Addr replaced with Symbol
	bsr	adrCd008358	;6100B9E4
	bsr	adrCd00C9BC	;61000044
	lea	adrEA00EA14.l,a6	;4DF90000EA14
	bsr	Print_fflim_text	;61000744
adrCd00C984:
	move.w	d7,d0	;3007
	bsr	adrCd006660	;61009CD8
	move.w	d7,d0	;3007
	bsr	adrCd00631E	;61009990
	move.b	#$2B,d1	;123C002B
	moveq	#$0A,d0	;700A
	sub.b	d3,d0	;9003
	bpl.s	adrCd00C9A0	;6A06
	move.b	#$2D,d1	;123C002D
	neg.b	d0	;4400
adrCd00C9A0:
	lea	adrEA00EA25.l,a6	;4DF90000EA25
	move.b	d1,$000C(a6)	;1D41000C
	bsr	adrCd00CEC4	;61000518
	move.b	d1,$000E(a6)	;1D41000E
	ror.w	#$08,d1	;E059
	move.b	d1,$000D(a6)	;1D41000D
	bra	Print_fflim_text	;6000070C

adrCd00C9BC:
	move.l	a4,-(sp)	;2F0C
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$051C,a0	;D0FC051C
	add.w	$000A(a5),a0	;D0ED000A
	move.w	d7,d0	;3007
	asl.w	#$04,d0	;E940
	lea	PocketContents.l,a4	;49F90000ED2A
	add.w	d0,a4	;D8C0
	swap	d7	;4847
	clr.w	d7	;4247
adrCd00C9DC:
	moveq	#$00,d0	;7000
	move.b	$00(a4,d7.w),d0	;10347000
	bne.s	adrCd00CA38	;6654
	cmpi.w	#$0002,d7	;0C470002
	bcc.s	adrCd00CA14	;642A
	swap	d7	;4847
	move.w	d7,d0	;3007
	swap	d7	;4847
	asl.w	#$05,d0	;EB40
	lea	CharacterStats.l,a1	;43F90000EB2A
	add.w	d0,a1	;D2C0
	moveq	#$00,d0	;7000
	move.b	$0012(a1),d0	;10290012
	beq.s	adrCd00CA14	;6712
	lea	adrEA00E4C3.l,a1	;43F90000E4C3
	asl.w	#$02,d0	;E540
	move.b	$00(a1,d0.w),d3	;16310000
	moveq	#$1A,d0	;701A
	add.w	d7,d0	;D047
	bra.s	adrCd00CA32	;601E

adrCd00CA14:
	move.w	$0012(a5),d3	;362D0012
	cmpi.w	#$0004,d7	;0C470004
	bcc.s	adrCd00CA32	;6414
	move.w	d7,d0	;3007
	cmpi.w	#$0003,d7	;0C470003
	bne.s	adrCd00CA2E	;6608
	btst	#$10,d7	;08070010
	beq.s	adrCd00CA2E	;6702
	addq.w	#$01,d0	;5240
adrCd00CA2E:
	add.w	#$006C,d0	;0640006C
adrCd00CA32:
	bsr	adrCd00CAEA	;610000B6
	bra.s	adrCd00CA4C	;6014

adrCd00CA38:
	cmpi.w	#$0005,d0	;0C400005
	bcc.s	adrCd00CA4A	;640C
	move.b	$0B(a4,d0.w),d1	;1234000B
	bne.s	adrCd00CA4A	;6606
	clr.b	$00(a4,d7.w)	;42347000
	bra.s	adrCd00C9DC	;6092

adrCd00CA4A:
	bsr.s	ObjectGraphic	;611A
adrCd00CA4C:
	addq.w	#$01,d7	;5247
	cmpi.w	#$0006,d7	;0C470006
	bne.s	adrCd00CA58	;6604
	add.w	#$0274,a0	;D0FC0274
adrCd00CA58:
	cmpi.w	#$000C,d7	;0C47000C
	bcs	adrCd00C9DC	;6500FF7E
	swap	d7	;4847
	move.l	(sp)+,a4	;285F
	rts	;4E75

ObjectGraphic:
	tst.w	d0	;4A40
	beq	adrCd00CAEA	;67000080
	cmpi.w	#$0005,d0	;0C400005
	bcs.s	NumberedObject	;6534
	cmpi.w	#$0069,d0	;0C400069
	bcs.s	.SkipRings	;651A
	cmpi.w	#$006D,d0	;0C40006D
	bcc.s	.SkipRings	;6414
	move.w	d0,d3	;3600
	sub.w	#$0069,d3	;04430069
	lea	RingUses.l,a1	;43F90000EE32
	tst.b	$00(a1,d3.w)	;4A313000
	bpl.s	.SkipRings	;6A02
	moveq	#$68,d0	;7068
.SkipRings:
	asl.w	#$02,d0	;E540
	lea	adrEA00E4C2.l,a1	;43F90000E4C2
	moveq	#$00,d3	;7600
	move.b	$01(a1,d0.w),d3	;16310001
	move.b	$00(a1,d0.w),d0	;10310000
	bra.s	adrCd00CAEA	;6044

NumberedObject:
	move.l	a0,-(sp)	;2F08
	move.w	d0,-(sp)	;3F00
	move.b	d1,d0	;1001
	bsr	adrCd00CEC4	;61000416
	move.w	d1,adrEA00CAE6.l	;33C10000CAE6
	move.w	(sp),d0	;3017
	bsr.s	adrCd00CAEA	;6130
	move.l	$0002(sp),a0	;206F0002
	add.w	#$0050,a0	;D0FC0050
	cmp.w	#$0003,(sp)+	;0C5F0003
	bcs.s	adrCd00CACC	;6504
	add.w	#$0118,a0	;D0FC0118
adrCd00CACC:
	lea	adrEA00CAE6.l,a6	;4DF90000CAE6
	move.l	#$00060000,adrW_00D92A.l	;23FC000600000000D92A
	bsr	Print_fflim_text	;610005E8
	move.l	(sp)+,a0	;205F
	addq.w	#$02,a0	;5448
	rts	;4E75

adrEA00CAE6:
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
NullString:
	dc.b	$FF	;FF

adrCd00CAEA:
	move.l	#$00000098,a3	;267C00000098
	lea	_GFX_Pockets.l,a1	;43F90004C702
	and.w	#$00FF,d0	;024000FF
adrCd00CAFA:
	cmpi.b	#$14,d0	;0C000014
	bcs.s	adrCd00CB0A	;650A
	add.w	#$0A00,a1	;D2FC0A00
	sub.w	#$0014,d0	;04400014
	bra.s	adrCd00CAFA	;60F0

adrCd00CB0A:
	asl.w	#$03,d0	;E740
	add.w	d0,a1	;D2C0
	movem.l	a0/a6,-(sp)	;48E70082
	bsr.s	adrCd00CB1C	;6108
	movem.l	(sp)+,a0/a6	;4CDF4100
	addq.w	#$02,a0	;5448
	rts	;4E75

adrCd00CB1C:
	move.l	#$0000000F,-(sp)	;2F3C0000000F
	jmp	adrCd00CE28.l	;4EF90000CE28

adrJA00CB28:
	moveq	#$2A,d5	;7A2A
adrCd00CB2A:
	move.w	$0006(a5),-(sp)	;3F2D0006
	bsr	adrCd00CC3A	;6100010A
	move.w	(sp),d0	;3017
	lea	adrEA00CBD2.l,a6	;4DF90000CBD2
	asl.w	#$05,d0	;EB40
	lea	CharacterStats.l,a0	;41F90000EB2A
	add.w	d0,a0	;D0C0
	lea	adrEA00CBC4.l,a2	;45F90000CBC4
	moveq	#$06,d7	;7E06
	moveq	#$00,d0	;7000
adrLp00CB4E:
	move.b	$00(a2,d7.w),d0	;10327000
	move.b	$00(a0,d0.w),d0	;10300000
	bsr	adrCd00CEC4	;6100036C
	move.b	$07(a2,d7.w),d0	;10327007
	move.b	d1,$01(a6,d0.w)	;1D810001
	ror.w	#$08,d1	;E059
	move.b	d1,$00(a6,d0.w)	;1D810000
	dbra	d7,adrLp00CB4E	;51CFFFE4
	move.w	(sp)+,d7	;3E1F
	move.b	$0005(a0),d0	;10280005
	divu	#$0064,d0	;80FC0064
	tst.w	d0	;4A40
	bne.s	adrCd00CB7E	;6604
	move.b	#$F0,d0	;103C00F0
adrCd00CB7E:
	add.b	#$30,d0	;06000030
	move.b	d0,$0049(a6)	;1D400049
	swap	d0	;4840
	bsr	adrCd00CEC4	;6100033A
	move.w	d1,$004A(a6)	;3D41004A
	move.b	#$20,$0053(a6)	;1D7C00200053
	moveq	#$51,d2	;7451
	moveq	#$00,d0	;7000
	move.b	$0006(a0),d0	;10280006
	divu	#$0064,d0	;80FC0064
	tst.b	d0	;4A00
	beq.s	adrCd00CBB0	;670A
	add.b	#$30,d0	;06000030
	move.b	d0,$00(a6,d2.w)	;1D802000
	addq.w	#$01,d2	;5242
adrCd00CBB0:
	swap	d0	;4840
	bsr	adrCd00CEC4	;61000310
	move.b	d1,$01(a6,d2.w)	;1D812001
	ror.w	#$08,d1	;E059
	move.b	d1,$00(a6,d2.w)	;1D812000
	bra	Print_fflim_text	;60000504

adrEA00CBC4:
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$07	;07
	dc.b	$08	;08
	dc.b	$12	;12
	dc.b	$1D	;1D
	dc.b	$28	;28
	dc.b	$33	;33
	dc.b	$3E	;3E
	dc.b	$5E	;5E
	dc.b	$65	;65
adrEA00CBD2:
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$03	;03
	dc.b	$FE	;FE
	dc.b	$0D	;0D
	dc.b	$FD	;FD
	dc.b	$03	;03
	dc.b	'LEVEL'	;4C4556454C
	dc.b	$FE	;FE
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$FE	;FE
	dc.b	$0E	;0E
	dc.b	'  '	;2020
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	$FE	;FE
	dc.b	$07	;07
	dc.b	'ST'	;5354
	dc.b	$FE	;FE
	dc.b	$0D	;0D
	dc.b	'  '	;2020
	dc.b	$FE	;FE
	dc.b	$01	;01
	dc.b	$2D	;2D
	dc.b	$FE	;FE
	dc.b	$07	;07
	dc.b	'AG'	;4147
	dc.b	$FE	;FE
	dc.b	$0D	;0D
	dc.b	$20	;20
	dc.b	$20	;20
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	$FE	;FE
	dc.b	$07	;07
	dc.b	'IN'	;494E
	dc.b	$FE	;FE
	dc.b	$0D	;0D
	dc.b	'  '	;2020
	dc.b	$FE	;FE
	dc.b	$01	;01
	dc.b	$2D	;2D
	dc.b	$FE	;FE
	dc.b	$07	;07
	dc.b	'CH'	;4348
	dc.b	$FE	;FE
	dc.b	$0D	;0D
	dc.b	'  '	;2020
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	$FE	;FE
	dc.b	$00	;00
	dc.b	'HP'	;4850
	dc.b	$FE	;FE
	dc.b	$0E	;0E
	dc.b	'   '	;202020
	dc.b	$FE	;FE
	dc.b	$01	;01
	dc.b	$2F	;2F
	dc.b	$FE	;FE
	dc.b	$06	;06
	dc.b	'   '	;202020
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	$FE	;FE
	dc.b	$00	;00
	dc.b	'VI '	;564920
	dc.b	$FE	;FE
	dc.b	$0E	;0E
	dc.b	'  '	;2020
	dc.b	$FE	;FE
	dc.b	$01	;01
	dc.b	'/'	;2F
	dc.b	$FE	;FE
	dc.b	$06	;06
	dc.b	'  '	;2020
	dc.b	$FF	;FF

adrCd00CC3A:
	or.b	#$0C,$0054(a5)	;002D000C0054
	swap	d5	;4845
	move.w	#$0018,d5	;3A3C0018
	add.w	$0008(a5),d5	;DA6D0008
	move.l	#$003F00F0,d4	;283C003F00F0
	moveq	#$03,d3	;7603
	bsr	BW_draw_bar	;61000E14
	sub.l	a3,a3	;97CB
	lea	_GFX_Scroll_Edge_Left.l,a1	;43F90001975E
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$03DC,a0	;D0FC03DC
	add.w	$000A(a5),a0	;D0ED000A
	clr.w	d5	;4245
	swap	d5	;4845
	move.l	d5,-(sp)	;2F05
	bsr.s	adrCd00CCB8	;6144
	move.l	(sp)+,d5	;2A1F
	lea	_GFX_Scroll_Edge_Right.l,a1	;43F90001992E
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$03E6,a0	;D0FC03E6
	add.w	$000A(a5),a0	;D0ED000A
	bsr.s	adrCd00CCB8	;612C
	sub.w	#$000A,a0	;90FC000A
	lea	_GFX_Scroll_Edge_Bottom.l,a1	;43F90001948E
	move.l	#$0005000E,d5	;2A3C0005000E	;Long Addr replaced with Symbol
	bsr.s	adrCd00CCB8	;611A
	lea	_GFX_Scroll_Edge_Top.l,a1	;43F9000191BE
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$0184,a0	;D0FC0184
	add.w	$000A(a5),a0	;D0ED000A
	move.l	#$0005000E,d5	;2A3C0005000E	;Long Addr replaced with Symbol
adrCd00CCB8:
	move.l	d5,-(sp)	;2F05
	bra	adrCd00CE28	;6000016C

adrCd00CCBE:
	move.l	#$002F0000,d4	;283C002F0000
	moveq	#$0A,d5	;7A0A
	bsr	adrCd00C0BA	;6100F3F2
	move.w	$0006(a5),d7	;3E2D0006
	moveq	#-$01,d4	;78FF
	move.l	#$000002A9,a0	;207C000002A9
	bsr.s	adrCd00CD1C	;6144
adrCd00CCD8:
	btst	#$00,$003E(a5)	;082D0000003E
	bne.s	adrCd00CD12	;6632
	or.b	#$01,$0054(a5)	;002D00010054
	move.l	#$0021000F,d5	;2A3C0021000F
	add.w	$0008(a5),d5	;DA6D0008
	move.l	#$00230006,d4	;283C00230006
	moveq	#$01,d3	;7601
	bsr.s	adrCd00CCFE	;6104
	bra	BW_draw_frame	;60000DD8

adrCd00CCFE:
	move.w	d7,d0	;3007
	bsr	adrCd006660	;6100995E
	move.b	$0011(a4),d0	;102C0011
	beq.s	adrCd00CD12	;6708
	and.w	#$0007,d0	;02400007
	move.b	adrB_00CD14(pc,d0.w),d3	;163B0004
adrCd00CD12:
	rts	;4E75

adrB_00CD14:
	dc.b	$06	;06
	dc.b	$0D	;0D
	dc.b	$06	;06
	dc.b	$08	;08
	dc.b	$06	;06
	dc.b	$06	;06
	dc.b	$0D	;0D
	dc.b	$08	;08

adrCd00CD1C:
	add.l	screen_ptr.l,a0	;D1F900008D36
	add.w	$000A(a5),a0	;D0ED000A
	lea	_GFX_Avatars.l,a1	;43F900041D30
	move.w	d7,d0	;3007
	asl.w	#$05,d0	;EB40
	sub.w	d7,d0	;9047
	sub.w	d7,d0	;9047
	asl.w	#$04,d0	;E940
	add.w	d0,a1	;D2C0
	move.l	#$0001001D,-(sp)	;2F3C0001001D	;Long Addr replaced with Symbol
	sub.l	a3,a3	;97CB
	tst.w	d4	;4A44
	bne	adrCd00CE28	;660000E4
	bra	adrCd00CE28	;600000E0

adrCd00CD4A:
	move.w	d7,d5	;3A07
	and.w	#$0003,d5	;02450003
	move.w	d5,d0	;3005
	add.w	d0,d5	;DA40
	add.w	d0,d5	;DA40
	asl.w	#$04,d5	;E945
	add.w	#$000F,d5	;0645000F
	mulu	#$0028,d5	;CAFC0028
	move.w	d7,d0	;3007
	and.w	#$000C,d0	;0240000C
	move.w	d0,d1	;3200
	lsr.w	#$02,d1	;E449
	add.w	d1,d0	;D041
	add.w	d5,d0	;D045
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	d0,a0	;D0C0
	rts	;4E75

adrCd00CD78:
	lea	_GFX_Shield_Clicked.l,a1	;43F900019BFE
	sub.l	a3,a3	;97CB
	bsr.s	adrCd00CD4A	;61C8
	move.l	#$00010028,d5	;2A3C00010028	;Long Addr replaced with Symbol
	bra	adrCd00CE26	;6000009C

ChampionSelection:
	moveq	#$0F,d7	;7E0F
.ChampionSelection_Loop:
	bsr.s	Draw_Select_Avatars	;6106
	dbra	d7,.ChampionSelection_Loop	;51CFFFFC
ExitAvatarDrawing:
	rts	;4E75

Draw_Select_Avatars:
	cmpi.w	#$0010,d7	;0C470010
	bcc.s	ExitAvatarDrawing	;64F8
	bsr.s	adrCd00CD4A	;61AC
	moveq	#$04,d3	;7604
Draw_ShieldAvatar:
	move.l	#$00020103,d0	;203C00020103	;Long Addr replaced with Symbol
	tst.w	d3	;4A43
	beq.s	adrCd00CDBC	;6712
	lea	ClassColours.l,a6	;4DF90000846E
	move.w	d7,d0	;3007
	bsr	adrCd006900	;61009B4C
	asl.w	#$02,d0	;E540
	move.l	$00(a6,d0.w),d0	;20360000
adrCd00CDBC:
	lea	adrEA00B4C0.l,a6	;4DF90000B4C0
	move.l	d0,(a6)	;2C80
	sub.l	a3,a3	;97CB
	lea	_GFX_ShieldTop.l,a1	;43F900044B30
	move.l	#$00010004,d5	;2A3C00010004	;Long Addr replaced with Symbol
	bsr	adrCd00CE26	;61000052
	lea	_GFX_ShieldAvatars.l,a1	;43F900043B30
	move.w	d7,d0	;3007
	asl.w	#$08,d0	;E140
	add.w	d0,a1	;D2C0
	move.l	#$0001000F,d5	;2A3C0001000F	;Long Addr replaced with Symbol
	bsr.s	adrCd00CE26	;613C
	lea	_GFX_ShieldClasses.l,a1	;43F900044C10
	move.w	d7,d0	;3007
	and.w	#$0003,d0	;02400003
	move.w	d0,d1	;3200
	asl.w	#$03,d0	;E740
	add.w	d1,d0	;D041
	add.w	d1,d0	;D041
	add.w	d1,d0	;D041
	asl.w	#$04,d0	;E940
	add.w	d0,a1	;D2C0
	move.l	#$1000A,d5	;2A3C0001000A
	move.w	#$FFFF,adrW_00B4BE.l	;33FCFFFF0000B4BE
	bsr.s	adrCd00CE26	;6112
	clr.w	adrW_00B4BE.l	;42790000B4BE
	lea	_GFX_ShieldBottom.l,a1	;43F900044B80
	move.l	#$00010008,d5	;2A3C00010008	;Long Addr replaced with Symbol
adrCd00CE26:
	move.l	d5,-(sp)	;2F05
adrCd00CE28:
	move.l	(sp)+,d5	;2A1F
adrLp00CE2A:
	swap	d5	;4845
	move.w	d5,-(sp)	;3F05
adrLp00CE2E:
	move.l	(a1)+,d0	;2019
	move.l	(a1)+,d1	;2219
	tst.w	adrW_00B4BE.l	;4A790000B4BE
	beq.s	adrCd00CE3E	;6704
	bsr	adrCd00AFD0	;6100E194
adrCd00CE3E:
	bsr	adrCd00CE86	;61000046
	move.b	d1,$5DC1(a0)	;11415DC1
	swap	d1	;4841
	move.b	d1,$3E81(a0)	;11413E81
	ror.l	#$08,d1	;E099
	move.b	d1,$3E80(a0)	;11413E80
	swap	d1	;4841
	move.b	d1,$5DC0(a0)	;11415DC0
	move.b	d0,$1F41(a0)	;11401F41
	swap	d0	;4840
	move.b	d0,$0001(a0)	;11400001
	ror.l	#$08,d0	;E098
	move.b	d0,(a0)	;1080
	swap	d0	;4840
	move.b	d0,$1F40(a0)	;11401F40
	addq.w	#$02,a0	;5448
	dbra	d5,adrLp00CE2E	;51CDFFBE
	move.w	(sp)+,d5	;3A1F
	sub.w	d5,a0	;90C5
	sub.w	d5,a0	;90C5
	add.w	#$0026,a0	;D0FC0026
	add.w	a3,a1	;D2CB
	swap	d5	;4845
	dbra	d5,adrLp00CE2A	;51CDFFA8
	rts	;4E75

adrCd00CE86:
	move.l	d1,d2	;2401
	and.l	d0,d2	;C480
	swap	d2	;4842
	and.l	d0,d2	;C480
	and.l	d1,d2	;C481
	lea	adrEA00B064.l,a2	;45F90000B064
	move.w	d3,d6	;3C03
	and.w	#$000C,d6	;0246000C
	move.l	$00(a2,d6.w),d6	;2C326000
	move.w	d3,d4	;3803
	asl.w	#$02,d4	;E544
	and.w	#$000C,d4	;0244000C
	move.l	$00(a2,d4.w),d4	;28324000
	and.l	d2,d4	;C882
	and.l	d2,d6	;CC82
	not.l	d2	;4682
	and.l	d2,d0	;C082
	and.l	d2,d1	;C282
	or.l	d4,d0	;8084
	or.l	d6,d1	;8286
	rts	;4E75

adrB_00CEBC:
	dc.b	$00	;00
	dc.b	$16	;16
	dc.b	$32	;32
	dc.b	$48	;48
	dc.b	$64	;64
	dc.b	$80	;80
	dc.b	$96	;96
	dc.b	$00	;00

adrCd00CEC4:
	move.b	d0,d1	;1200
	lsr.b	#$04,d1	;E809
	and.w	#$000F,d1	;0241000F
	move.b	adrB_00CEBC(pc,d1.w),d1	;123B10EE
	and.w	#$000F,d0	;0240000F
	move.w	#$0004,ccr	;44FC0004
	abcd	d1,d0	;C101
	clr.b	d1	;4201
	abcd	d1,d0	;C101
	bra.s	adrCd00CEEA	;600A

;fiX Label expected
	move.w	d0,-(sp)	;3F00
	ror.w	#$08,d0	;E058
	bsr.s	adrCd00CEEA	;6104
	swap	d1	;4841
	move.w	(sp)+,d0	;301F
adrCd00CEEA:
	move.b	d0,d1	;1200
	ror.b	#$04,d1	;E819
	bsr.s	adrCd00CEF4	;6104
	rol.w	#$08,d1	;E159
	move.b	d0,d1	;1200
adrCd00CEF4:
	and.b	#$0F,d1	;0201000F
	cmpi.b	#$0A,d1	;0C01000A
	bcs.s	adrCd00CF02	;6504
	add.b	#$07,d1	;06010007
adrCd00CF02:
	add.b	#$30,d1	;06010030
	rts	;4E75

adrCd00CF08:
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	$000A(a5),a0	;D0ED000A
	add.w	#$02EC,a0	;D0FC02EC
	move.w	#$000D,adrW_00D92A.l	;33FC000D0000D92A
	move.w	$0010(a5),adrW_00D92C.l	;33ED00100000D92C
	moveq	#$0B,d6	;7C0B
	and.w	#$000F,d0	;0240000F
	bsr	Print_wordstext	;610008B8
	bsr	TerminateText	;610000D6
	move.w	#$00E0,d4	;383C00E0
	moveq	#$12,d5	;7A12
	add.w	$0008(a5),d5	;DA6D0008
	move.l	#$00040000,d3	;263C00040000	;Long Addr replaced with Symbol
	bsr	BW_blit_vertical_line	;61000BBE
	addq.w	#$01,d4	;5244
	bra	BW_blit_vertical_line	;60000BB8

adrCd00CF4E:
	or.b	#$10,$0054(a5)	;002D00100054
	move.b	#$FF,$0057(a5)	;1B7C00FF0057
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$0DF4,a0	;D0FC0DF4
	add.w	$000A(a5),a0	;D0ED000A
	clr.w	(a0)	;4250
	clr.w	$1F40(a0)	;42681F40
	clr.w	$3E80(a0)	;42683E80
	clr.w	$5DC0(a0)	;42685DC0
	add.w	#$00F0,a0	;D0FC00F0
	clr.w	(a0)	;4250
	clr.w	$1F40(a0)	;42681F40
	clr.w	$3E80(a0)	;42683E80
	clr.w	$5DC0(a0)	;42685DC0
	sub.w	#$00C8,a0	;90FC00C8
	clr.w	adrW_00D92C.l	;42790000D92C
	moveq	#$0F,d6	;7C0F
	rts	;4E75

adrCd00CF96:
	move.l	#$007F0060,d4	;283C007F0060
	move.l	#$00060059,d5	;2A3C00060059
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$00,d3	;7600
	or.b	#$10,$0054(a5)	;002D00100054
	move.b	#$FF,$0057(a5)	;1B7C00FF0057
	bra	BW_draw_bar	;60000AB2

LowerText:
	bsr.s	adrCd00CF4E	;6194
	bra.s	adrLp00CFDA	;601E

adrCd00CFBC:
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$0BAE,a0	;D0FC0BAE
	add.w	$000A(a5),a0	;D0ED000A
	moveq	#$07,d6	;7C07
	move.l	#$000B0000,adrW_00D92A.l	;23FC000B00000000D92A
	bra.s	adrLp00CFDA	;6002

;fiX Label expected
	bsr.s	adrCd00D018	;613E
adrLp00CFDA:
	move.b	(a6)+,d0	;101E
	bpl.s	adrCd00CFE6	;6A08
	bsr	Exec_char_extensions	;610000F6
	bcc.s	adrLp00CFDA	;64F6
	bra.s	TerminateText	;6022

adrCd00CFE6:
	bsr	adrCd00D8C0	;610008D8
	dbra	d6,adrLp00CFDA	;51CEFFEE
	rts	;4E75

adrCd00CFF0:
	bsr.s	adrCd00D018	;6126
	move.w	d7,d0	;3007
	bsr	Print_wordstext	;610007F0
	moveq	#$20,d0	;7020
	bsr	adrCd00D8C0	;610008C4
	subq.w	#$01,d6	;5346
	moveq	#$64,d0	;7064
	add.w	d7,d0	;D047
	bsr	Print_wordstext	;610007E0
TerminateText:
	tst.w	d6	;4A46
	bmi.s	adrCd00D016	;6B0A
adrLp00D00C:
	moveq	#$20,d0	;7020
	bsr	adrCd00D8C0	;610008B0
	dbra	d6,adrLp00D00C	;51CEFFF8
adrCd00D016:
	rts	;4E75

adrCd00D018:
	moveq	#$12,d6	;7C12
adrCd00D01A:
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	#$0E25,a0	;D0FC0E25
	add.w	$000A(a5),a0	;D0ED000A
	move.w	#$000D,adrW_00D92A.l	;33FC000D0000D92A
	move.w	$0010(a5),adrW_00D92C.l	;33ED00100000D92C
	rts	;4E75

WriteMessage:
	move.b	#$81,d2	;143C0081
	bra.s	adrCd00D042	;6002

;fiX Label expected
	dc.w	$7400	;7400

adrCd00D042:
	tst.b	$0005(a4)	;4A2C0005
	bpl.s	WriteFText	;6A48
	movem.l	d2/a6,-(sp)	;48E72002
	bsr.s	WriteFText	;6142
	movem.l	(sp)+,d2/a6	;4CDF4004
	lea	Player1_Data.l,a0	;41F90000EE7C
	btst	#$00,(a5)	;08150000
	bne.s	.continuedcode_001	;6606
	lea	Player2_Data.l,a0	;41F90000EEDE
.continuedcode_001:
	movem.l	a4/a5,-(sp)	;48E7000C
	move.l	a0,a5	;2A48
	move.b	$0001(a4),d0	;102C0001
	jsr	adrCd0041FA.w	;4EB841FA	;Short Absolute converted to symbol!
	tst.b	$0005(a4)	;4A2C0005
	bpl.s	adrCd00D07C	;6A04
	move.b	d0,$0000(a4)	;19400000
adrCd00D07C:
	or.b	#$40,d2	;00020040
	bsr.s	WriteFText	;610E
	movem.l	(sp)+,a4/a5	;4CDF3000
	rts	;4E75

WriteTimedText:
	move.b	#$81,d2	;143C0081
	bra.s	WriteFText	;6002

WriteText:
	moveq	#$00,d2	;7400
WriteFText:
	move.b	d2,$0052(a5)	;1B420052
	bsr.s	InitialiseText	;6104
	bra	adrLp00CFDA	;6000FF42

InitialiseText:
	or.b	#$A0,$0054(a5)	;002D00A00054
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	$000A(a5),a0	;D0ED000A
	add.w	#$0050,a0	;D0FC0050
	move.l	#$000F0000,adrW_00D92A.l	;23FC000F00000000D92A
	clr.w	$004C(a5)	;426D004C
	moveq	#$27,d6	;7C27
	move.w	#$0105,$004A(a5)	;3B7C0105004A
	rts	;4E75

Print_fflim_text:
	move.b	(a6)+,d0	;101E
	bpl.s	.continuedcode_002	;6A06
	bsr.s	Exec_char_extensions	;610A
	bcc.s	Print_fflim_text	;64F8
	rts	;4E75

.continuedcode_002:
	bsr	adrCd00D8C0	;610007EE
	bra.s	Print_fflim_text	;60F0

Exec_char_extensions:
	cmpi.b	#$F0,d0				;0C0000F0
	beq	.Call_F0_Function			;6700004E
	moveq	#$00,d1				;7200
	move.b	(a6)+,d1			;121E
	cmpi.b	#$FE,d0				;0C0000FE
	beq.s	.SetTextColour			;6712
	cmpi.b	#$FD,d0				;0C0000FD
	beq.s	.SetBackgroundTextColour			;6714
	cmpi.b	#$FC,d0				;0C0000FC
	beq.s	.SetXYPosition			;6716
	moveq	#$00,d0				;7000
	subq.w	#$01,d0				;5340
	rts					;4E75

.SetTextColour:
	move.w	d1,adrW_00D92A.l	;33C10000D92A
	rts	;4E75

.SetBackgroundTextColour:
	move.w	d1,adrW_00D92C.l	;33C10000D92C
	rts	;4E75

.SetXYPosition:
	move.w	d1,d4	;3801
	clr.w	d5	;4245
	move.b	(a6)+,d5	;1A1E
	asl.w	#$03,d4	;E744
	asl.w	#$03,d5	;E745
	bsr	BW_xy_to_offset	;61000B3E
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	$000A(a5),a0	;D0ED000A
	add.w	d0,a0	;D0C0
	add.w	#$0050,a0	;D0FC0050
.Exit:
	rts	;4E75

.Call_F0_Function:
	bsr.s	CopyProtection	;610C
	tst.l	d0	;4A80
	beq.s	.Exit	;67F8
	lea	adrCd000C50.w,a0	;41F80C50	;Short Absolute converted to symbol!
	bra	adrCd008DAE		;6000BC78

CopyProtection:
;	movem.l	a4-a6,-(sp)	;48E7000E
;	bra	adrCd00D1FC	;600000BE
	move.l	#$8488ffc4,$24.w
	moveq	#0,d0
	rts


;fiX Label expected
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
adrEA00D186:
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
adrEA00D1F0:
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrL_00D1F8:
	dc.l	$FFFFFFFF	;FFFFFFFF

adrCd00D1FC:
	move.l	a6,-(sp)	;2F0E
	lea	adrEA00D186(pc),a6	;4DFAFF86
	movem.l	d0-d7/a0-a7,(a6)	;48D6FFFF
	lea	$0040(a6),a6	;4DEE0040
	move.l	(sp)+,-$0008(a6)	;2D5FFFF8
	move.l	$00000010.l,d1	;223900000010
; A PC relative Short Absolute outside of the program!
	dc.l	$487A000A
;	pea	$000A.l(pc)	;487A000A	;replaced by dc.l above
	move.l	(sp)+,$00000010.l	;23DF00000010
	illegal	;4AFC
;fiX Label expected
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

adrEA00D2D2:
	movem.l	d0/a0/a1,-(sp)	;48E780C0
	lea	adrEA00D30C(pc),a0	;41FA0034
	move.l	a0,$00000024.l	;23C800000024
	lea	adrEA00D740(pc),a0	;41FA045E
	move.l	a0,$00000020.l	;23C800000020
adrCd00D2EA:
	add.l	#$00000002,$000E(sp)	;06AF00000002000E
	or.b	#$07,$000C(sp)	;002F0007000C
	bchg	#$07,$000C(sp)	;086F0007000C
	lea	adrEA00D1F0(pc),a1	;43FAFEF0
	beq.s	adrCd00D31E	;671A
	move.l	(a1),a0	;2051
	move.l	$0004(a1),(a0)	;20A90004
	bra.s	adrCd00D332	;6026

adrEA00D30C:
	andi.w	#$F8FF,sr	;027CF8FF
	movem.l	d0/a0/a1,-(sp)	;48E780C0
	lea	adrEA00D1F0(pc),a1	;43FAFEDA
	move.l	(a1),a0	;2051
	move.l	$0004(a1),(a0)	;20A90004
adrCd00D31E:
	move.l	$000E(sp),a0	;206F000E
adrCd00D322:
	move.l	a0,(a1)	;2288
	move.l	(a0),$0004(a1)	;23500004
	move.l	-$0004(a0),d0	;2028FFFC
	not.l	d0	;4680
	swap	d0	;4840
	eor.l	d0,(a0)	;B190
adrCd00D332:
	movem.l	(sp)+,d0/a0/a1	;4CDF0301
	rte	;4E73

;fiX Label expected
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

adrCd00D51E:
	btst	#$04,_ciab+ciaicr.l	;0839000400BFDD00
	beq.s	adrCd00D51E	;67F6
	move.w	#$8000,$0024(a0)	;317C80000024
	move.w	#$8000,$0024(a0)	;317C80000024
	moveq	#$00,d1	;7200
	move.l	#$00061A80,d2	;243C00061A80
adrCd00D53C:
	subq.l	#$01,d2	;5382
	beq.s	adrCd00D56A	;672A
	move.b	$001A(a0),d0	;1028001A
	btst	#$04,d0	;08000004
	beq.s	adrCd00D53C	;67F2
	moveq	#$31,d2	;7431
adrLp00D54C:
	addq.l	#$01,d1	;5281
	move.w	$001A(a0),d0	;3028001A
	bpl.s	adrLp00D54C	;6AF8
	move.b	d0,(a1)+	;12C0
	dbra	d2,adrLp00D54C	;51CAFFF4
	move.w	#$03CD,d2	;343C03CD
adrLp00D55E:
	addq.l	#$01,d1	;5281
	move.w	$001A(a0),d0	;3028001A
	bpl.s	adrLp00D55E	;6AF8
	dbra	d2,adrLp00D55E	;51CAFFF6
adrCd00D56A:
	move.w	$001E(a0),d0	;3028001E
	move.w	#$0002,$009C(a0)	;317C0002009C
	move.w	#$4000,$0024(a0)	;317C40000024
	btst	#$01,d0	;08000001
	bne.s	adrCd00D59A	;661A
	moveq	#$00,d1	;7200
	bra.s	adrCd00D59A	;6016

;fiX Label expected
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

adrCd00D59A:
	move.l	d1,d0	;2001
	illegal	;4AFC
;fiX Label expected
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

	rte	;4E73

adrEA00D740:
	movem.l	(sp)+,a4-a6	;4CDF7000
	sub.l	#$8488FFC4,d0	;04808488FFC4
	rts	;4E75

Print_com_menu_entry:
	move.l	#$000D0002,adrW_00D92A.l	;23FC000D00020000D92A
	cmp.b	$0040(a5),d7	;BE2D0040
	bne.s	.continuedcode_005	;6616
	tst.b	$0041(a5)	;4A2D0041
	bne.s	.continuedcode_005	;6610
	move.w	$0010(a5),adrW_00D92C.l	;33ED00100000D92C
	move.w	#$000E,adrW_00D92A.l	;33FC000E0000D92A
.continuedcode_005:
	move.b	(a6)+,d0				;101E
	cmpi.b	#$FA,d0					;0C0000FA
	beq.s	.Print_SkipSomething_TEMP				;6706
	bcc.s	.Print_SkipSomethingElse_TEMP				;640C
	bsr.s	Print_wordstext				;6168
	bra.s	.continuedcode_005				;60F2

.Print_SkipSomething_TEMP:
	move.b	(a6)+,d0	;101E
	bsr	adrCd00D8C0	;6100013C
	bra.s	.continuedcode_005	;60EA

.Print_SkipSomethingElse_TEMP:
	cmpi.b	#$FF,d0					;0C0000FF
	beq.s	Print_LineEnd				;674C
	cmpi.b	#$FC,d0					;0C0000FC
	bne.s	.continuedcode_005				;66DE
	addq.w	#$01,a0					;5248
	move.b	#$FF,adrB_00EE2D.l			;13FC00FF0000EE2D
	move.l	#$000D0002,adrW_00D92A.l		;23FC000D00020000D92A
	cmp.b	$0040(a5),d7				;BE2D0040
	bne.s	.continuedcode_005				;66C4
	tst.b	$0041(a5)				;4A2D0041
	beq.s	.continuedcode_005				;67BE
	move.w	$0010(a5),adrW_00D92C.l			;33ED00100000D92C
	move.w	#$000E,adrW_00D92A.l			;33FC000E0000D92A
	bra.s	.continuedcode_005				;60AC

adrCd00D7C6:
	lea	WordsText.l,a3	;47F90000DC64
Proceed_in_stringtable:
	and.w	#$00FF,d0	;024000FF
	moveq	#$00,d5	;7A00
.continuedcode_006:
	add.w	d5,a3	;D6C5
	move.b	(a3)+,d5	;1A1B
	dbra	d0,.continuedcode_006	;51C8FFFA
Print_LineEnd:
	rts	;4E75

Print_item_name:
	lea	ObjectsDictionary.l,a3	;47F90000E21E
Print_word:
	bsr.s	Proceed_in_stringtable	;61E8
	bra.s	Print_nchars	;6002

Print_wordstext:
	bsr.s	adrCd00D7C6	;61DE
Print_nchars:
	sub.w	d5,d6	;9C45
	subq.w	#$01,d5	;5345
.continuedcode_007:
	move.b	(a3)+,d0	;101B
	bsr	adrCd00D8C0	;610000D0
	dbra	d5,.continuedcode_007	;51CDFFF8
	rts	;4E75

InventoryItem_Description:
	bsr	adrCd00D018	;6100F81E
	bra.s	Print_item_desc	;6004

Print_item_desc_fresh:
	bsr	adrCd00CF4E	;6100F74E
Print_item_desc:
	move.b	(a6)+,d0	;101E
	bsr.s	Print_item_name	;61D6
	subq.w	#$01,d6	;5346
	moveq	#$20,d0	;7020
	bsr	adrCd00D8C0	;610000B4
	move.b	(a6),d0	;1016
	bmi.s	.continuedcode_008	;6B02
	bsr.s	Print_item_name	;61C8
.continuedcode_008:
	tst.w	d6	;4A46
	bpl	TerminateText	;6A00F7F0
	rts	;4E75

Print_npc_message:
	move.b	#$81,d2	;143C0081
	bra.s	.continuedcode_009	;6002

;fiX Label expected
	dc.w	$7400	;7400

.continuedcode_009:
	tst.b	$0005(a4)	;4A2C0005
	bpl.s	Print_message	;6A48
	movem.l	d2/a6,-(sp)	;48E72002
	bsr.s	Print_message	;6142
	movem.l	(sp)+,d2/a6	;4CDF4004
	lea	Player1_Data.l,a0	;41F90000EE7C
	btst	#$00,(a5)	;08150000
	bne.s	adrCd00D846	;6606
	lea	Player2_Data.l,a0	;41F90000EEDE
adrCd00D846:
	movem.l	a4/a5,-(sp)	;48E7000C
	move.l	a0,a5	;2A48
	move.b	$0001(a4),d0	;102C0001
	jsr	adrCd0041FA.w	;4EB841FA	;Short Absolute converted to symbol!
	tst.b	$0005(a4)	;4A2C0005
	bpl.s	adrCd00D85E	;6A04
	move.b	d0,$0000(a4)	;19400000
adrCd00D85E:
	or.b	#$40,d2	;00020040
	bsr.s	Print_message	;610E
	movem.l	(sp)+,a4/a5	;4CDF3000
	rts	;4E75

Print_timed_message:
	move.b	#$81,d2	;143C0081
	bra.s	Print_message	;6002

Print_fix_message:
	moveq	#$00,d2	;7400
Print_message:
	move.b	d2,$0052(a5)	;1B420052
	bsr	InitialiseText	;6100F822
Print_NewLine:
	move.b	(a6)+,d0				;101E
	cmpi.b	#$FA,d0					;0C0000FA
	bcc.s	adrCd00D894				;6412
	bsr	Print_wordstext				;6100FF62
adrCd00D886:
	tst.w	d6	;4A46
	bmi	TerminateText	;6B00F77E
	moveq	#$20,d0	;7020
	bsr.s	adrCd00D8C0	;6130
	subq.w	#$01,d6	;5346
	bra.s	Print_NewLine	;60E6

adrCd00D894:
	beq.s	adrCd00D8B8				;6722
	cmpi.b	#$FF,d0					;0C0000FF
	beq	TerminateText				;6700F76C
	cmpi.b	#$FB,d0					;0C0000FB
	beq.s	Print_FB_Function				;670E
	cmpi.b	#$FE,d0					;0C0000FE
	bne.s	Print_NewLine				;66D0
	move.b	(a6)+,d0				;101E
	bsr	Print_item_name				;6100FF2E
	bra.s	adrCd00D886				;60D4

Print_FB_Function:
	addq.w	#$01,d6	;5246
	subq.w	#$01,a0	;5348
	bra.s	Print_NewLine	;60C2

adrCd00D8B8:
	subq.w	#$01,a0	;5348
	move.b	(a6)+,d0	;101E
	bsr.s	adrCd00D8C0	;6102
	bra.s	adrCd00D886	;60C6

adrCd00D8C0:
	move.l	a0,-(sp)	;2F08
	lea	adrEA018C7E.l,a1	;43F900018C7E
	moveq	#$00,d1	;7200
	move.b	d0,d1	;1200
	move.w	d1,d0	;3001
	asl.w	#$02,d0	;E540
	add.w	d1,d0	;D041
	add.w	d0,a1	;D2C0
	moveq	#$04,d0	;7004
adrLp00D8D6:
	move.b	(a1),d1	;1211
	swap	d1	;4841
	move.b	(a1)+,d1	;1219
	tst.b	adrB_00EE2D.l	;4A390000EE2D
	beq.s	adrCd00D8E8	;6704
	add.l	d1,d1	;D281
	add.l	d1,d1	;D281
adrCd00D8E8:
	not.b	d1	;4601
	swap	d0	;4840
	move.w	#$0003,d0	;303C0003
	move.w	#$5DC0,d4	;383C5DC0
adrLp00D8F4:
	move.b	d1,d3	;1601
	btst	d0,adrB_00D92D(pc)	;013A0035
	bne.s	adrCd00D8FE	;6602
	clr.b	d3	;4203
adrCd00D8FE:
	swap	d1	;4841
	move.b	d1,d2	;1401
	swap	d1	;4841
	btst	d0,adrB_00D92B(pc)	;013A0025
	bne.s	adrCd00D90C	;6602
	clr.b	d2	;4202
adrCd00D90C:
	or.b	d3,d2	;8403
	move.b	d2,$00(a0,d4.w)	;11824000
	sub.w	#$1F40,d4	;04441F40
	dbra	d0,adrLp00D8F4	;51C8FFDC
	swap	d0	;4840
	add.w	#$0028,a0	;D0FC0028
	dbra	d0,adrLp00D8D6	;51C8FFB4
	move.l	(sp)+,a0	;205F
	addq.w	#$01,a0	;5248
	rts	;4E75

adrW_00D92A:
	dc.b	$00	;00
adrB_00D92B:
	dc.b	$01	;01
adrW_00D92C:
	dc.b	$00	;00
adrB_00D92D:
	dc.b	$00	;00

Draw_woundflash_digit:
	move.w	#$000F,adrW_00D92C.l	;33FC000F0000D92C
	movem.l	d4/d5,-(sp)	;48E70C00
	lea	Data_Woundflash.l,a0	;41F90000D988
	move.l	a0,a1	;2248
	moveq	#$09,d2	;7409
	moveq	#-$01,d1	;72FF
.continuedcode_011:
	move.l	d1,(a1)+	;22C1
	dbra	d2,.continuedcode_011	;51CAFFFC
	move.b	#$FF,adrB_00EE2D.l	;13FC00FF0000EE2D
	bsr	BW_Blitchar	;6100005A
	clr.b	adrB_00EE2D.l	;42390000EE2D
	movem.l	(sp)+,d4/d5	;4CDF0030
	move.l	a0,a1	;2248
	move.w	d4,d1	;3204
	and.w	#$FFF7,d4	;0244FFF7
	bsr	BW_xy_to_offset	;610002E8
	move.w	d1,d4	;3801
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	d0,a0	;D0C0
	lea	adrEA00ABF6.l,a6	;4DF90000ABF6
	moveq	#$04,d7	;7E04
	swap	d7	;4847
	moveq	#$00,d6	;7C00
	bra	adrCd00AD90	;6000D40A

Data_Woundflash:
	dc.l	$00000000	;00000000
	dc.l	$00000000	;00000000
	dc.l	$00000000	;00000000
	dc.l	$00000000	;00000000
	dc.l	$00000000	;00000000
	dc.l	$00000000	;00000000
	dc.l	$00000000	;00000000
	dc.l	$00000000	;00000000
	dc.l	$00000000	;00000000
	dc.l	$00000000	;00000000

BW_Blitchar:
	lea	adrEA018C7E.l,a1	;43F900018C7E	;
	move.l	a0,-(sp)	;2F08
	and.w	#$007F,d0	;0240007F
	move.w	d0,d2	;3400
	asl.w	#$02,d0	;E540
	add.w	d2,d0	;D042
	add.w	d0,a1	;D2C0
	move.l	adrW_00D92A.l,d2	;24390000D92A
	lea	BW_blitchar_data.l,a2	;45F90000DA18
	asl.w	#$02,d2	;E542
	move.l	$00(a2,d2.w),d3	;26322000
	swap	d2	;4842
	asl.w	#$02,d2	;E542
	move.l	$00(a2,d2.w),d2	;24322000
	moveq	#$04,d1	;7204
.loop:
	move.b	(a1),d0	;1011
	asl.w	#$08,d0	;E140
	move.b	(a1)+,d0	;1019
	add.w	d0,d0	;D040
	add.w	d0,d0	;D040
	move.w	d0,d4	;3800
	swap	d0	;4840
	move.w	d4,d0	;3004
	move.l	d0,d4	;2800
	not.l	d0	;4680
	and.l	d3,d0	;C083
	and.l	d2,d4	;C882
	or.l	d4,d0	;8084
	move.b	d0,$0006(a0)	;11400006
	swap	d0	;4840
	move.b	d0,$0002(a0)	;11400002
	lsr.l	#$08,d0	;E088
	move.b	d0,(a0)	;1080
	swap	d0	;4840
	move.b	d0,$0004(a0)	;11400004
	addq.w	#$08,a0	;5048
	dbra	d1,.loop	;51C9FFCE
	move.l	(sp)+,a0	;205F
	rts	;4E75

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
	dc.w	$4843	;4843
	dc.w	$4844	;4844
	dc.w	$4845	;4845
	dc.w	$3803	;3803
	dc.w	$3A03	;3A03
	dc.w	$4843	;4843
	dc.w	$4844	;4844
	dc.w	$4845	;4845

BW_draw_bar:
	swap	d4	;4844	;
	swap	d3	;4843
	move.w	d4,d3	;3604
	swap	d4	;4844
	swap	d3	;4843
	swap	d5	;4845
	move.w	d5,d7	;3E05
	swap	d5	;4845
.drawbar_loop:
	bsr	BW_blit_horiz_line	;6100010A
	addq.w	#$01,d5	;5245
	dbra	d7,.drawbar_loop	;51CFFFF8
	rts	;4E75

BW_cs_draw_frame:
	addq.w	#$01,d4	;5244	;
	swap	d4	;4844
	swap	d3	;4843
	move.w	d4,d3	;3604
	subq.w	#$02,d3	;5543
	swap	d4	;4844
	swap	d3	;4843
	bsr	BW_blit_horiz_line	;610000F0
	swap	d5	;4845
	move.w	d5,d7	;3E05
	swap	d5	;4845
	add.w	d7,d5	;DA47
	bsr	BW_blit_horiz_line	;610000E4
	sub.w	d7,d5	;9A47
	subq.w	#$01,d4	;5344
	addq.w	#$01,d5	;5245
	swap	d5	;4845
	swap	d3	;4843
	move.w	d5,d3	;3605
	subq.w	#$02,d3	;5543
	swap	d3	;4843
	swap	d5	;4845
	bsr	BW_blit_vertical_line	;6100004E
	swap	d4	;4844
	move.w	d4,d7	;3E04
	swap	d4	;4844
	add.w	d7,d4	;D847
	bra	BW_blit_vertical_line	;60000042

;fiX Label expected
	swap	d3	;4843
	swap	d4	;4844
	swap	d5	;4845
	move.w	d3,d4	;3803
	move.w	d3,d5	;3A03
	swap	d3	;4843
	swap	d4	;4844
	swap	d5	;4845
BW_draw_frame:
	swap	d4	;4844	;
	swap	d3	;4843
	move.w	d4,d3	;3604
	swap	d4	;4844
	swap	d3	;4843
	bsr	BW_blit_horiz_line	;610000A4
	swap	d5	;4845
	move.w	d5,d7	;3E05
	swap	d5	;4845
	add.w	d7,d5	;DA47
	bsr	BW_blit_horiz_line	;61000098
	sub.w	d7,d5	;9A47
	swap	d5	;4845
	swap	d3	;4843
	move.w	d5,d3	;3605
	swap	d5	;4845
	swap	d3	;4843
	bsr.s	BW_blit_vertical_line	;6108
	swap	d4	;4844
	move.w	d4,d7	;3E04
	swap	d4	;4844
	add.w	d7,d4	;D847
BW_blit_vertical_line:
	bsr	BW_xy_to_offset	;6100014E	;
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	d0,a0	;D0C0
	moveq	#$00,d0	;7000
	moveq	#$00,d1	;7200
	move.b	d3,d1	;1203
	lsr.b	#$01,d1	;E209
	roxr.b	#$01,d0	;E210
	ror.w	#$01,d1	;E259
	swap	d0	;4840
	lsr.b	#$01,d1	;E209
	roxr.b	#$01,d0	;E210
	lsr.b	#$01,d1	;E209
	swap	d1	;4841
	roxr.w	#$01,d1	;E251
	or.l	d1,d0	;8081
	swap	d0	;4840
	move.b	#$7F,d1	;123C007F
	move.w	d4,d7	;3E04
	and.w	#$0007,d7	;02470007
	ror.b	d7,d1	;EE39
	ror.l	d7,d0	;EEB8
	move.l	d3,d2	;2403
	swap	d2	;4842
.vertical_loop:
	move.b	(a0),d7	;1E10
	and.b	d1,d7	;CE01
	or.b	d0,d7	;8E00
	move.b	d7,(a0)	;1087
	swap	d0	;4840
	move.b	$3E80(a0),d7	;1E283E80
	and.b	d1,d7	;CE01
	or.b	d0,d7	;8E00
	move.b	d7,$3E80(a0)	;11473E80
	ror.l	#$08,d0	;E098
	move.b	$5DC0(a0),d7	;1E285DC0
	and.b	d1,d7	;CE01
	or.b	d0,d7	;8E00
	move.b	d7,$5DC0(a0)	;11475DC0
	swap	d0	;4840
	move.b	$1F40(a0),d7	;1E281F40
	and.b	d1,d7	;CE01
	or.b	d0,d7	;8E00
	move.b	d7,$1F40(a0)	;11471F40
	rol.l	#$08,d0	;E198
	add.w	#$0028,a0	;D0FC0028
	dbra	d2,.vertical_loop	;51CAFFC6
	rts	;4E75

hline_data:
	dc.w	$0000	;0000
	dc.w	$00FF	;00FF
	dc.w	$FF00	;FF00
	dc.w	$FFFF	;FFFF

BW_blit_horiz_line:
	movem.l	d3-d5,-(sp)	;48E71C00	;
	bsr	BW_xy_to_offset	;610000CA
	move.l	screen_ptr.l,a0	;207900008D36
	add.w	d0,a0	;D0C0
	lea	hline_data.l,a1	;43F90000DB7C
	move.w	d3,d0	;3003
	and.w	#$000C,d0	;0240000C
	lsr.w	#$01,d0	;E248
	move.w	$00(a1,d0.w),d0	;30310000
	swap	d0	;4840
	add.w	d3,d3	;D643
	and.w	#$0006,d3	;02430006
	move.w	$00(a1,d3.w),d0	;30313000
	swap	d3	;4843
	addq.w	#$01,d3	;5243
	move.w	d4,d2	;3404
	and.w	#$0007,d2	;02420007
	beq.s	adrCd00DC14	;6756
	subq.w	#$08,d2	;5142
	neg.w	d2	;4442
	cmp.w	d2,d3	;B642
	bgt.s	adrCd00DBFE	;6E38
	moveq	#-$01,d2	;74FF
	and.w	#$0007,d4	;02440007
	lsr.b	d3,d2	;E62A
	not.b	d2	;4602
	lsr.b	d4,d2	;E82A
	move.b	d2,d3	;1602
	not.b	d3	;4603
	bsr	adrCd00DBDC	;61000004
	bra.s	adrCd00DC4E	;6072

adrCd00DBDC:
	move.l	d0,d6	;2C00
	moveq	#$03,d5	;7A03
	moveq	#$00,d4	;7800
.horiz_loop:
	move.b	$00(a0,d4.w),d1	;12304000
	and.b	d2,d0	;C002
	and.b	d3,d1	;C203
	or.b	d0,d1	;8200
	move.b	d1,$00(a0,d4.w)	;11814000
	ror.l	#$08,d0	;E098
	add.w	#$1F40,d4	;06441F40
	dbra	d5,.horiz_loop	;51CDFFEA
	move.l	d6,d0	;2006
	rts	;4E75

adrCd00DBFE:
	sub.w	d2,d3	;9642
	swap	d3	;4843
	and.w	#$0007,d4	;02440007
	moveq	#-$01,d2	;74FF
	lsr.b	d4,d2	;E82A
	move.b	d2,d3	;1602
	not.b	d3	;4603
	bsr.s	adrCd00DBDC	;61CC
	swap	d3	;4843
	addq.w	#$01,a0	;5248
adrCd00DC14:
	move.w	d3,d4	;3803
	lsr.w	#$03,d3	;E64B
	beq.s	adrCd00DC3E	;6724
	subq.w	#$01,d3	;5343
	move.l	a0,a1	;2248
	moveq	#$00,d2	;7400
	moveq	#$03,d5	;7A03
adrLp00DC22:
	move.l	a1,a0	;2049
	add.w	d2,a0	;D0C2
	move.w	d3,d1	;3203
adrLp00DC28:
	move.b	d0,(a0)+	;10C0
	dbra	d1,adrLp00DC28	;51C9FFFC
	ror.l	#$08,d0	;E098
	add.w	#$1F40,d2	;06421F40
	dbra	d5,adrLp00DC22	;51CDFFEC
	sub.w	#$1F40,d2	;04421F40
	sub.w	d2,a0	;90C2
adrCd00DC3E:
	and.w	#$0007,d4	;02440007
	beq.s	adrCd00DC4E	;670A
	moveq	#-$01,d3	;76FF
	lsr.b	d4,d3	;E82B
	move.b	d3,d2	;1403
	not.b	d2	;4602
	bsr.s	adrCd00DBDC	;618E
adrCd00DC4E:
	movem.l	(sp)+,d3-d5	;4CDF0038
	rts	;4E75

BW_xy_to_offset:
	move.w	d5,d0	;3005	;
	add.w	d0,d0	;D040
	add.w	d0,d0	;D040
	add.w	d5,d0	;D045
	asl.w	#$06,d0	;ED40
	add.w	d4,d0	;D044
	lsr.w	#$03,d0	;E648
	rts	;4E75

WordsText:
	dc.b	$07	;07
	dc.b	'BLODWYN'	;424C4F4457594E
	dc.b	$07	;07
	dc.b	'MURLOCK'	;4D55524C4F434B
	dc.b	$07	;07
	dc.b	'ELEANOR'	;454C45414E4F52
	dc.b	$07	;07
	dc.b	'ROSANNE'	;524F53414E4E45
	dc.b	$07	;07
	dc.b	'ASTROTH'	;415354524F5448
	dc.b	$06	;06
	dc.b	'ZOTHEN'	;5A4F5448454E
	dc.b	$08	;08
	dc.b	'BALDRICK'	;42414C445249434B
	dc.b	$06	;06
	dc.b	'ELFRIC'	;454C46524943
	dc.b	$0A	;0A
	dc.b	'SIR EDWARD'	;53495220454457415244
	dc.b	$06	;06
	dc.b	'MEGRIM'	;4D454752494D
	dc.b	$06	;06
	dc.b	'SETHRA'	;534554485241
	dc.b	$07	;07
	dc.b	'MR.FLAY'	;4D522E464C4159
	dc.b	$06	;06
	dc.b	'ULRICH'	;554C52494348
	dc.b	$07	;07
	dc.b	'ZASTAPH'	;5A415354415048
	dc.b	$07	;07
	dc.b	'HENGIST'	;48454E47495354
	dc.b	$0A	;0A
	dc.b	'THAI CHANG'	;54484149204348414E47
	dc.b	$0B	;0B
	dc.b	'COMMUNICATE'	;434F4D4D554E4943415445
	dc.b	$07	;07
	dc.b	'COMMEND'	;434F4D4D454E44
	dc.b	$04	;04
	dc.b	'VIEW'	;56494557
	dc.b	$04	;04
	dc.b	'WAIT'	;57414954
	dc.b	$07	;07
	dc.b	'CORRECT'	;434F5252454354
	dc.b	$07	;07
	dc.b	'DISMISS'	;4449534D495353
	dc.b	$04	;04
	dc.b	'CALL'	;43414C4C
	dc.b	$06	;06
	dc.b	'UNABLE'	;554E41424C45
	dc.b	$03	;03
	dc.b	'WHO'	;57484F
	dc.b	$04	;04
	dc.b	'DOST'	;444F5354
	dc.b	$04	;04
	dc.b	'THOU'	;54484F55
	dc.b	$04	;04
	dc.b	'WISH'	;57495348
	dc.b	$02	;02
	dc.b	'TO'	;544F
	dc.b	$06	;06
	dc.b	'ACCEPT'	;414343455054
	dc.b	$03	;03
	dc.b	'THY'	;544859
	dc.b	$06	;06
	dc.b	'HONOUR'	;484F4E4F5552
	dc.b	$08	;08
	dc.b	'EVERYONE'	;45564552594F4E45
	dc.b	$09	;09
	dc.b	'APOLOGISE'	;41504F4C4F47495345
	dc.b	$03	;03
	dc.b	'FOR'	;464F52
	dc.b	$06	;06
	dc.b	'BREATH'	;425245415448
	dc.b	$05	;05
	dc.b	'LEAVE'	;4C45415645
	dc.b	$03	;03
	dc.b	'THE'	;544845
	dc.b	$05	;05
	dc.b	'PARTY'	;5041525459
	dc.b	$04	;04
	dc.b	'HAST'	;48415354
	dc.b	$04	;04
	dc.b	'NONE'	;4E4F4E45
	dc.b	$02	;02
	dc.b	'BE'	;4245
	dc.b	$03	;03
	dc.b	'OUT'	;4F5554
	dc.b	$06	;06
	dc.b	'GAINED'	;4741494E4544
	dc.b	$05	;05
	dc.b	'LEVEL'	;4C4556454C
	dc.b	$03	;03
	dc.b	'LET'	;4C4554
	dc.b	$04	;04
	dc.b	'GIVE'	;47495645
	dc.b	$04	;04
	dc.b	'SOME'	;534F4D45
	dc.b	$06	;06
	dc.b	'DEPART'	;444550415254
	dc.b	$02	;02
	dc.b	'GO'	;474F
	dc.b	$07	;07
	dc.b	'REJOINS'	;52454A4F494E53
	dc.b	$05	;05
	dc.b	'TRULY'	;5452554C59
	dc.b	$07	;07
	dc.b	'THROUGH'	;5448524F554748
	dc.b	$02	;02
	dc.b	'IS'	;4953
	dc.b	$07	;07
	dc.b	'PRESENT'	;50524553454E54
	dc.b	$06	;06
	dc.b	'NORMAL'	;4E4F524D414C
	dc.b	$08	;08
	dc.b	'RESTORED'	;524553544F524544
	dc.b	$05	;05
	dc.b	'THERE'	;5448455245
	dc.b	$04	;04
	dc.b	'BODY'	;424F4459
	dc.b	$04	;04
	dc.b	'HERE'	;48455245
	dc.b	$07	;07
	dc.b	'RECRUIT'	;52454352554954
	dc.b	$02	;02
	dc.b	'NO'	;4E4F
	dc.b	$08	;08
	dc.b	'IDENTIFY'	;4944454E54494659
	dc.b	$07	;07
	dc.b	'INQUIRY'	;494E5155495259
	dc.b	$05	;05
	dc.b	'WHERE'	;5748455245
	dc.b	$06	;06
	dc.b	'ABOUTS'	;41424F555453
	dc.b	$04	;04
	dc.b	'TRAD'	;54524144
	dc.b	$05	;05
	dc.b	'SMALL'	;534D414C4C
	dc.b	$04	;04
	dc.b	'TALK'	;54414C4B
	dc.b	$05	;05
	dc.b	'YES  '	;5945532020
	dc.b	$06	;06
	dc.b	'    NO'	;202020204E4F
	dc.b	$05	;05
	dc.b	'BRIBE'	;4252494245
	dc.b	$06	;06
	dc.b	'THREAT'	;544852454154
	dc.b	$05	;05
	dc.b	'GREET'	;4752454554
	dc.b	$03	;03
	dc.b	'ING'	;494E47
	dc.b	$04	;04
	dc.b	'NAME'	;4E414D45
	dc.b	$04	;04
	dc.b	'SELF'	;53454C46
	dc.b	$06	;06
	dc.b	'REVEAL'	;52455645414C
	dc.b	$04	;04
	dc.b	'FOLK'	;464F4C4B
	dc.b	$04	;04
	dc.b	'LORE'	;4C4F5245
	dc.b	$05	;05
	dc.b	'MAGIC'	;4D41474943
	dc.b	$04	;04
	dc.b	'ITEM'	;4954454D
	dc.b	$06	;06
	dc.b	'OBJECT'	;4F424A454354
	dc.b	$06	;06
	dc.b	'PERSON'	;504552534F4E
	dc.b	$04	;04
	dc.b	'GOLD'	;474F4C44
	dc.b	$08	;08
	dc.b	'PURCHASE'	;5055524348415345
	dc.b	$08	;08
	dc.b	'EXCHANGE'	;45584348414E4745
	dc.b	$04	;04
	dc.b	'SELL'	;53454C4C
	dc.b	$06	;06
	dc.b	'PRAISE'	;505241495345
	dc.b	$05	;05
	dc.b	'CURSE'	;4355525345
	dc.b	$05	;05
	dc.b	'BOAST'	;424F415354
	dc.b	$06	;06
	dc.b	'RETORT'	;5245544F5254
	dc.b	$06	;06
	dc.b	'WIZARD'	;57495A415244
	dc.b	$0A	;0A
	dc.b	'ADVENTURER'	;414456454E5455524552
	dc.b	$08	;08
	dc.b	'CUTPURSE'	;4355545055525345
	dc.b	$02	;02
	dc.b	'MY'	;4D59
	dc.b	$05	;05
	dc.b	'AUGHT'	;4155474854
	dc.b	$05	;05
	dc.b	'OFFER'	;4F46464552
	dc.b	$02	;02
	dc.b	'OR'	;4F52
	dc.b	$04	;04
	dc.b	'AWAY'	;41574159
	dc.b	$0B	;0B
	dc.b	'STONEMAIDEN'	;53544F4E454D414944454E
	dc.b	$09	;09
	dc.b	'DARKHEART'	;4441524B4845415254
	dc.b	$09	;09
	dc.b	'OF AVALON'	;4F46204156414C4F4E
	dc.b	$09	;09
	dc.b	'SWIFTHAND'	;535749465448414E44
	dc.b	$09	;09
	dc.b	'SLAEMWORT'	;534C41454D574F5254
	dc.b	$0A	;0A
	dc.b	'RUNECASTER'	;52554E45434153544552
	dc.b	$08	;08
	dc.b	'THE DUNG'	;5448452044554E47
	dc.b	$09	;09
	dc.b	'FALAENDOR'	;46414C41454E444F52
	dc.b	$04	;04
	dc.b	'LION'	;4C494F4E
	dc.b	$0B	;0B
	dc.b	'OF MOONWYCH'	;4F46204D4F4F4E57594348
	dc.b	$09	;09
	dc.b	'BHOAGHAIL'	;42484F41474841494C
	dc.b	$0A	;0A
	dc.b	'SEPULCRAST'	;534550554C4352415354
	dc.b	$08	;08
	dc.b	'STERNAXE'	;535445524E415845
	dc.b	$07	;07
	dc.b	'MANTRIC'	;4D414E54524943
	dc.b	$09	;09
	dc.b	'MELDANASH'	;4D454C44414E415348
	dc.b	$07	;07
	dc.b	'OF YINN'	;4F462059494E4E
	dc.b	$07	;07
	dc.b	'COURAGE'	;434F5552414745
	dc.b	$08	;08
	dc.b	'STRENGTH'	;535452454E475448
	dc.b	$07	;07
	dc.b	'PROWESS'	;50524F57455353
	dc.b	$08	;08
	dc.b	'ANCESTRY'	;414E434553545259
	dc.b	$04	;04
	dc.b	'FAME'	;46414D45
	dc.b	$07	;07
	dc.b	'ABILITY'	;4142494C495459
	dc.b	$09	;09
	dc.b	'KNOWLEDGE'	;4B4E4F574C45444745
	dc.b	$05	;05
	dc.b	'SPEED'	;5350454544
	dc.b	$0B	;0B
	dc.b	'UNSURPASSED'	;554E535552504153534544
	dc.b	$09	;09
	dc.b	'UNRIVALED'	;554E524956414C4544
	dc.b	$0A	;0A
	dc.b	'INCREDIBLE'	;494E4352454449424C45
	dc.b	$0A	;0A
	dc.b	'STUPENDOUS'	;53545550454E444F5553
	dc.b	$07	;07
	dc.b	'GODLIKE'	;474F444C494B45
	dc.b	$0A	;0A
	dc.b	'UNDISPUTED'	;554E4449535055544544
	dc.b	$0A	;0A
	dc.b	'UNEQUALLED'	;554E455155414C4C4544
	dc.b	$08	;08
	dc.b	'RENOWNED'	;52454E4F574E4544
	dc.b	$05	;05
	dc.b	'FIGHT'	;4649474854
	dc.b	$04	;04
	dc.b	'TALK'	;54414C4B
	dc.b	$05	;05
	dc.b	'SOUND'	;534F554E44
	dc.b	$06	;06
	dc.b	'BEHAVE'	;424548415645
	dc.b	$04	;04
	dc.b	'LOOK'	;4C4F4F4B
	dc.b	$06	;06
	dc.b	'APPEAR'	;415050454152
	dc.b	$04	;04
	dc.b	'SEEM'	;5345454D
	dc.b	$03	;03
	dc.b	'ART'	;415254
	dc.b	$04	;04
	dc.b	'LIKE'	;4C494B45
	dc.b	$01	;01
	dc.b	'A'	;41
	dc.b	$04	;04
	dc.b	'VERY'	;56455259
	dc.b	$09	;09
	dc.b	'STRANGELY'	;535452414E47454C59
	dc.b	$08	;08
	dc.b	'MIGHTILY'	;4D49474854494C59
	dc.b	$06	;06
	dc.b	'HUGELY'	;485547454C59
	dc.b	$0A	;0A
	dc.b	'INCREDIBLY'	;494E4352454449424C59
	dc.b	$0A	;0A
	dc.b	'ESPECIALLY'	;455350454349414C4C59
	dc.b	$09	;09
	dc.b	'IMMENSELY'	;494D4D454E53454C59
	dc.b	$05	;05
	dc.b	'ODDLY'	;4F44444C59
	dc.b	$06	;06
	dc.b	'STRONG'	;5354524F4E47
	dc.b	$05	;05
	dc.b	'BRAVE'	;4252415645
	dc.b	$08	;08
	dc.b	'POWERFUL'	;504F57455246554C
	dc.b	$05	;05
	dc.b	'NOBLE'	;4E4F424C45
	dc.b	$04	;04
	dc.b	'WISE'	;57495345
	dc.b	$04	;04
	dc.b	'FINE'	;46494E45
	dc.b	$08	;08
	dc.b	'SPLENDID'	;53504C454E444944
	dc.b	$07	;07
	dc.b	'AWESOME'	;415745534F4D45
	dc.b	$07	;07
	dc.b	'WARRIOR'	;57415252494F52
	dc.b	$04	;04
	dc.b	'SAGE'	;53414745
	dc.b	$04	;04
	dc.b	'HERO'	;4845524F
	dc.b	$06	;06
	dc.b	'LEADER'	;4C4541444552
	dc.b	$06	;06
	dc.b	'MASTER'	;4D4153544552
	dc.b	$06	;06
	dc.b	'FRIEND'	;465249454E44
	dc.b	$07	;07
	dc.b	'SCHOLAR'	;5343484F4C4152
	dc.b	$06	;06
	dc.b	'EXPERT'	;455850455254
	dc.b	$0C	;0C
	dc.b	'DISGUSTINGLY'	;44495347555354494E474C59
	dc.b	$0B	;0B
	dc.b	'GROTESQUELY'	;47524F5445535155454C59
	dc.b	$0B	;0B
	dc.b	'SICKENINGLY'	;5349434B454E494E474C59
	dc.b	$07	;07
	dc.b	'UTTERLY'	;55545445524C59
	dc.b	$0C	;0C
	dc.b	'UNBELIEVABLY'	;554E42454C49455641424C59
	dc.b	$0B	;0B
	dc.b	'ABHORRENTLY'	;4142484F5252454E544C59
	dc.b	$0B	;0B
	dc.b	'APPALLINGLY'	;415050414C4C494E474C59
	dc.b	$0D	;0D
	dc.b	'INDESCRIBABLY'	;494E4445534352494241424C59
	dc.b	$06	;06
	dc.b	'SMELLY'	;534D454C4C59
	dc.b	$05	;05
	dc.b	'GROSS'	;47524F5353
	dc.b	$06	;06
	dc.b	'STUPID'	;535455504944
	dc.b	$08	;08
	dc.b	'PATHETIC'	;5041544845544943
	dc.b	$08	;08
	dc.b	'GORMLESS'	;474F524D4C455353
	dc.b	$06	;06
	dc.b	'FEEBLE'	;464545424C45
	dc.b	$05	;05
	dc.b	'WARTY'	;5741525459
	dc.b	$04	;04
	dc.b	'UGLY'	;55474C59
	dc.b	$04	;04
	dc.b	'SLUG'	;534C5547
	dc.b	$04	;04
	dc.b	'TOAD'	;544F4144
	dc.b	$04	;04
	dc.b	'CLOD'	;434C4F44
	dc.b	$06	;06
	dc.b	'MAGGOT'	;4D4147474F54
	dc.b	$06	;06
	dc.b	'COWARD'	;434F57415244
	dc.b	$06	;06
	dc.b	'ZOMBIE'	;5A4F4D424945
	dc.b	$0A	;0A
	dc.b	'BUMBLEFOOT'	;42554D424C45464F4F54
	dc.b	$03	;03
	dc.b	'OAF'	;4F4146
	dc.b	$04	;04
	dc.b	'STEP'	;53544550
	dc.b	$05	;05
	dc.b	'ASIDE'	;4153494445
	dc.b	$06	;06
	dc.b	'SUFFER'	;535546464552
	dc.b	$03	;03
	dc.b	'DIE'	;444945
	dc.b	$05	;05
	dc.b	'SORRY'	;534F525259
	dc.b	$03	;03
	dc.b	'ONE'	;4F4E45
	dc.b	$04	;04
	dc.b	'HEAR'	;48454152
	dc.b	$07	;07
	dc.b	'DISTANT'	;44495354414E54
	dc.b	$05	;05
	dc.b	'FRONT'	;46524F4E54
	dc.b	$04	;04
	dc.b	'LEFT'	;4C454654
	dc.b	$04	;04
	dc.b	'REAR'	;52454152
	dc.b	$05	;05
	dc.b	'RIGHT'	;5249474854
	dc.b	$03	;03
	dc.b	'YOU'	;594F55
	dc.b	$05	;05
	dc.b	'THING'	;5448494E47
	dc.b	$04	;04
	dc.b	'WILT'	;57494C54
	dc.b	$05	;05
	dc.b	'TOKEN'	;544F4B454E
	dc.b	$01	;01
	dc.b	'I'	;49
ObjectsDictionary:
	dc.b	$05	;05
	dc.b	'EMPTY'	;454D505459
	dc.b	$04	;04
	dc.b	'SLOT'	;534C4F54
	dc.b	$07	;07
	dc.b	'COINAGE'	;434F494E414745
	dc.b	$06	;06
	dc.b	'COMMON'	;434F4D4D4F4E
	dc.b	$04	;04
	dc.b	'KEYS'	;4B455953
	dc.b	$03	;03
	dc.b	'ELF'	;454C46
	dc.b	$06	;06
	dc.b	'ARROWS'	;4152524F5753
	dc.b	$07	;07
	dc.b	'CRYSTAL'	;4352595354414C
	dc.b	$05	;05
	dc.b	'N''EGG'	;4E27454747
	dc.b	$04	;04
	dc.b	'GRAY'	;47524159
	dc.b	$07	;07
	dc.b	'SERPENT'	;53455250454E54
	dc.b	$05	;05
	dc.b	'CHAOS'	;4348414F53
	dc.b	$06	;06
	dc.b	'DRAGON'	;445241474F4E
	dc.b	$04	;04
	dc.b	'MOON'	;4D4F4F4E
	dc.b	$04	;04
	dc.b	'FOOD'	;464F4F44
	dc.b	$05	;05
	dc.b	'DRINK'	;4452494E4B
	dc.b	$05	;05
	dc.b	'SLIME'	;534C494D45
	dc.b	$09	;09
	dc.b	'BRIMSTONE'	;4252494D53544F4E45
	dc.b	$05	;05
	dc.b	'BROTH'	;42524F5448
	dc.b	$03	;03
	dc.b	'ALE'	;414C45
	dc.b	$04	;04
	dc.b	'MOON'	;4D4F4F4E
	dc.b	$06	;06
	dc.b	'ELIXIR'	;454C49584952
	dc.b	$03	;03
	dc.b	'KEY'	;4B4559
	dc.b	$06	;06
	dc.b	'BATTLE'	;424154544C45
	dc.b	$05	;05
	dc.b	'STAFF'	;5354414646
	dc.b	$04	;04
	dc.b	'WAND'	;57414E44
	dc.b	$04	;04
	dc.b	'RUNE'	;52554E45
	dc.b	$06	;06
	dc.b	'SHIELD'	;534849454C44
	dc.b	$07	;07
	dc.b	'LEATHER'	;4C454154484552
	dc.b	$07	;07
	dc.b	'BUCKLER'	;4255434B4C4552
	dc.b	$05	;05
	dc.b	'LARGE'	;4C41524745
	dc.b	$03	;03
	dc.b	'WAR'	;574152
	dc.b	$06	;06
	dc.b	'ARMOUR'	;41524D4F5552
	dc.b	$05	;05
	dc.b	'CHAIN'	;434841494E
	dc.b	$04	;04
	dc.b	'MAIL'	;4D41494C
	dc.b	$07	;07
	dc.b	'MITHRIL'	;4D49544852494C
	dc.b	$07	;07
	dc.b	'ADAMANT'	;4144414D414E54
	dc.b	$05	;05
	dc.b	'PLATE'	;504C415445
	dc.b	$06	;06
	dc.b	'BRONZE'	;42524F4E5A45
	dc.b	$06	;06
	dc.b	'GLOVES'	;474C4F564553
	dc.b	$06	;06
	dc.b	'DAGGER'	;444147474552
	dc.b	$04	;04
	dc.b	'IRON'	;49524F4E
	dc.b	$09	;09
	dc.b	'CHROMATIC'	;4348524F4D41544943
	dc.b	$07	;07
	dc.b	'STEALTH'	;535445414C5448
	dc.b	$05	;05
	dc.b	'BLADE'	;424C414445
	dc.b	$04	;04
	dc.b	'HEAL'	;4845414C
	dc.b	$06	;06
	dc.b	'PERMIT'	;5045524D4954
	dc.b	$05	;05
	dc.b	'POWER'	;504F574552
	dc.b	$05	;05
	dc.b	'SHORT'	;53484F5254
	dc.b	$05	;05
	dc.b	'SWORD'	;53574F5244
	dc.b	$07	;07
	dc.b	'blank50'	;626C616E6B3530
	dc.b	$04	;04
	dc.b	'LONG'	;4C4F4E47
	dc.b	$04	;04
	dc.b	'BOOK'	;424F4F4B
	dc.b	$09	;09
	dc.b	'FLESHBANE'	;464C45534842414E45
	dc.b	$05	;05
	dc.b	'DEMON'	;44454D4F4E
	dc.b	$0D	;0D
	dc.b	'ACE OF SWORDS'	;414345204F462053574F524453
	dc.b	$05	;05
	dc.b	'FROST'	;46524F5354
	dc.b	$03	;03
	dc.b	'AXE'	;415845
	dc.b	$07	;07
	dc.b	'TROLL''S'	;54524F4C4C2753
	dc.b	$0C	;0C
	dc.b	'DEATHBRINGER'	;44454154484252494E474552
	dc.b	$0A	;0A
	dc.b	'BRAINBITER'	;425241494E4249544552
	dc.b	$03	;03
	dc.b	'BOW'	;424F57
	dc.b	$05	;05
	dc.b	'CROSS'	;43524F5353
	dc.b	$04	;04
	dc.b	'RING'	;52494E47
	dc.b	$05	;05
	dc.b	'(RIP)'	;2852495029
	dc.b	$05	;05
	dc.b	'SCALE'	;5343414C45
	dc.b	$04	;04
	dc.b	'MEAD'	;4D454144
	dc.b	$05	;05
	dc.b	'WATER'	;5741544552
	dc.b	$04	;04
	dc.b	'FIST'	;46495354
	dc.b	$07	;07
	dc.b	'BLODWYN'	;424C4F4457594E
	dc.b	$07	;07
	dc.b	'MURLOCK'	;4D55524C4F434B
	dc.b	$07	;07
	dc.b	'ELEANOR'	;454C45414E4F52
	dc.b	$07	;07
	dc.b	'ROSANNE'	;524F53414E4E45
	dc.b	$07	;07
	dc.b	'ASTROTH'	;415354524F5448
	dc.b	$06	;06
	dc.b	'ZOTHEN'	;5A4F5448454E
	dc.b	$08	;08
	dc.b	'BALDRICK'	;42414C445249434B
	dc.b	$06	;06
	dc.b	'ELFRIC'	;454C46524943
	dc.b	$0A	;0A
	dc.b	'SIR EDWARD'	;53495220454457415244
	dc.b	$06	;06
	dc.b	'MEGRIM'	;4D454752494D
	dc.b	$06	;06
	dc.b	'SETHRA'	;534554485241
	dc.b	$07	;07
	dc.b	'MR.FLAY'	;4D522E464C4159
	dc.b	$06	;06
	dc.b	'ULRICH'	;554C52494348
	dc.b	$07	;07
	dc.b	'ZASTAPH'	;5A415354415048
	dc.b	$07	;07
	dc.b	'HENGIST'	;48454E47495354
	dc.b	$0A	;0A
	dc.b	'THAI CHANG'	;54484149204348414E47
	dc.b	$09	;09
	dc.b	'OF SKULLS'	;4F4620534B554C4C53
	dc.b	$06	;06
	dc.b	'BLUISH'	;424C55495348
	dc.b	$05	;05
	dc.b	'BROWN'	;42524F574E
	dc.b	$03	;03
	dc.b	'TAN'	;54414E
	dc.b	$03	;03
	dc.b	'GEM'	;47454D
SelectChampsMsg:
	dc.b	'PLEASE SELECT YOUR CHAMPIONS...'	;504C454153452053454C45435420594F5552204348414D50494F4E532E2E2E
	dc.b	$FF	;FF
SelectThyChampMsg:
	dc.b	'PLAYER 0 SELECT THY CHAMPION....'	;504C4159455220302053454C45435420544859204348414D50494F4E2E2E2E2E
	dc.b	$FF	;FF
	dc.b	$00	;00
adrEA00E4C2:
	dc.b	$00	;00
adrEA00E4C3:
	dc.b	$00	;00
ObjectDefinitionsTable:
	INCBIN bw-data/objectpocketicons.block

ObjectFloorShapeTable:
	INCBIN bw-data/objectflooricons.block

FloorObjectShapeHeights:
	dc.w	$0806	;0806
	dc.w	$0503	;0503
	dc.w	$0204	;0204
	dc.w	$0302	;0302
	dc.w	$0202	;0202
	dc.w	$0302	;0302
	dc.w	$0202	;0202
	dc.w	$0206	;0206
	dc.w	$0504	;0504
	dc.w	$0302	;0302
	dc.w	$0403	;0403
	dc.w	$0202	;0202
	dc.w	$0204	;0204
	dc.w	$0302	;0302
	dc.w	$0202	;0202
	dc.w	$0808	;0808
	dc.w	$0605	;0605
	dc.w	$0404	;0404
	dc.w	$0202	;0202
	dc.w	$0202	;0202
	dc.w	$0202	;0202
	dc.w	$0202	;0202
	dc.w	$0208	;0208
	dc.w	$0605	;0605
	dc.w	$0302	;0302
	dc.w	$0605	;0605
	dc.w	$0403	;0403
	dc.w	$0208	;0208
	dc.w	$0605	;0605
	dc.w	$0302	;0302
	dc.w	$0503	;0503
	dc.w	$0202	;0202
	dc.w	$0005	;0005
	dc.w	$0403	;0403
	dc.w	$0202	;0202
	dc.w	$0705	;0705
	dc.w	$0402	;0402
	dc.w	$0205	;0205
	dc.w	$0403	;0403
	dc.w	$0202	;0202
	dc.w	$0705	;0705
	dc.w	$0402	;0402
	dc.w	$0206	;0206
	dc.w	$0404	;0404
	dc.w	$0202	;0202
	dc.w	$0505	;0505
	dc.w	$0404	;0404
	dc.w	$0205	;0205
	dc.w	$0504	;0504
	dc.w	$0402	;0402
	dc.w	$0706	;0706
	dc.w	$0504	;0504
	dc.w	$0304	;0304
	dc.w	$0404	;0404
	dc.w	$0303	;0303
	dc.w	$0202	;0202
	dc.w	$0202	;0202
	dc.w	$0202	;0202
	dc.w	$0202	;0202
	dc.w	$0202	;0202
	dc.w	$0404	;0404
	dc.w	$0402	;0402
	dc.w	$0208	;0208
	dc.w	$0A06	;0A06
	dc.w	$0503	;0503
	dc.w	$0605	;0605
	dc.w	$0403	;0403
	dc.w	$0200	;0200
ObjectColourSets:
	dc.w	$0000	;0000
	dc.w	$0B24	;0B24
	dc.w	$1C00	;1C00
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0104	;0104
	dc.w	$0002	;0002
	dc.w	$0500	;0500
	dc.w	$0323	;0323
	dc.w	$1B20	;1B20
	dc.w	$1E21	;1E21
	dc.w	$1D22	;1D22
	dc.w	$1F26	;1F26
	dc.w	$2829	;2829
	dc.w	$2A20	;2A20
	dc.w	$2122	;2122
	dc.w	$2527	;2527
	dc.w	$2021	;2021
	dc.w	$2226	;2226
	dc.w	$1811	;1811
	dc.w	$1615	;1615
	dc.w	$1312	;1312
	dc.w	$1A19	;1A19
	dc.w	$1714	;1714
	dc.w	$1213	;1213
	dc.w	$100F	;100F
	dc.w	$1117	;1117
	dc.w	$1219	;1219
	dc.w	$1613	;1613
	dc.w	$1916	;1916
	dc.w	$1312	;1312
	dc.w	$1613	;1613
	dc.w	$1219	;1219
	dc.w	$1312	;1312
	dc.w	$1916	;1916
	dc.w	$0A07	;0A07
	dc.w	$080D	;080D
	dc.w	$0C00	;0C00
	dc.w	$0E08	;0E08
	dc.w	$0D0C	;0D0C
	dc.w	$000E	;000E
	dc.w	$1211	;1211
	dc.w	$0000	;0000
	dc.w	$1219	;1219
	dc.w	$1613	;1613
	dc.w	$1014	;1014
	dc.w	$1517	;1517
	dc.w	$0008	;0008
	dc.w	$0D0C	;0D0C
	dc.w	$0900	;0900
FloorObjectPalettes:
	dc.w	$0004	;0004
	dc.w	$080C	;080C
	dc.w	$0004	;0004
	dc.w	$0805	;0805
	dc.w	$0004	;0004
	dc.w	$0806	;0806
	dc.w	$0004	;0004
	dc.w	$0807	;0807
	dc.w	$0004	;0004
	dc.w	$0808	;0808
	dc.w	$0004	;0004
	dc.w	$080D	;080D
	dc.w	$0004	;0004
	dc.w	$080E	;080E
	dc.w	$0004	;0004
	dc.w	$040C	;040C
	dc.w	$0004	;0004
	dc.w	$060C	;060C
	dc.w	$0004	;0004
	dc.w	$080C	;080C
	dc.w	$0004	;0004
	dc.w	$0A0C	;0A0C
	dc.w	$0004	;0004
	dc.w	$0B0C	;0B0C
	dc.w	$0004	;0004
	dc.w	$0C0C	;0C0C
	dc.w	$0004	;0004
	dc.w	$0D0C	;0D0C
	dc.w	$0004	;0004
	dc.w	$0E0C	;0E0C
	dc.w	$0004	;0004
	dc.w	$0203	;0203
	dc.w	$0004	;0004
	dc.w	$0304	;0304
	dc.w	$0004	;0004
	dc.w	$040E	;040E
	dc.w	$0004	;0004
	dc.w	$0506	;0506
	dc.w	$0004	;0004
	dc.w	$0708	;0708
	dc.w	$0004	;0004
	dc.w	$0806	;0806
	dc.w	$0004	;0004
	dc.w	$090A	;090A
	dc.w	$0004	;0004
	dc.w	$090C	;090C
	dc.w	$0004	;0004
	dc.w	$0A0B	;0A0B
	dc.w	$0004	;0004
	dc.w	$0A0D	;0A0D
	dc.w	$0004	;0004
	dc.w	$0B0D	;0B0D
	dc.w	$0004	;0004
	dc.w	$0C0B	;0C0B
	dc.w	$0002	;0002
	dc.w	$040E	;040E
	dc.w	$0002	;0002
	dc.w	$060D	;060D
	dc.w	$0002	;0002
	dc.w	$060E	;060E
	dc.w	$0002	;0002
	dc.w	$080E	;080E
	dc.w	$0002	;0002
	dc.w	$0B0E	;0B0E
	dc.w	$0003	;0003
	dc.w	$040E	;040E
	dc.w	$0007	;0007
	dc.w	$080E	;080E
	dc.w	$0005	;0005
	dc.w	$060E	;060E
	dc.w	$0009	;0009
	dc.w	$0A0B	;0A0B
	dc.w	$0009	;0009
	dc.w	$0C0E	;0C0E
	dc.w	$000A	;000A
	dc.w	$0B0D	;0B0D
	dc.w	$000A	;000A
	dc.w	$0B0E	;0B0E
	dc.w	$000B	;000B
	dc.w	$0D0E	;0D0E
	dc.w	$0A09	;0A09
	dc.w	$0A0B	;0A0B
	dc.w	$0403	;0403
	dc.w	$040E	;040E
	dc.w	$0C03	;0C03
	dc.w	$040E	;040E
FloorObjectGraphicOffsets:
	dc.w	$0000	;0000
	dc.w	$0048	;0048
	dc.w	$0080	;0080
	dc.w	$00B0	;00B0
	dc.w	$00D0	;00D0
	dc.w	$00E8	;00E8
	dc.w	$0110	;0110
	dc.w	$0130	;0130
	dc.w	$0148	;0148
	dc.w	$0160	;0160
	dc.w	$0178	;0178
	dc.w	$0198	;0198
	dc.w	$01B0	;01B0
	dc.w	$01C8	;01C8
	dc.w	$01E0	;01E0
	dc.w	$01F8	;01F8
	dc.w	$0230	;0230
	dc.w	$0260	;0260
	dc.w	$0288	;0288
	dc.w	$02A8	;02A8
	dc.w	$02C0	;02C0
	dc.w	$02E8	;02E8
	dc.w	$0308	;0308
	dc.w	$0320	;0320
	dc.w	$0338	;0338
	dc.w	$0350	;0350
	dc.w	$0378	;0378
	dc.w	$0398	;0398
	dc.w	$03B0	;03B0
	dc.w	$03C8	;03C8
	dc.w	$03E0	;03E0
	dc.w	$0428	;0428
	dc.w	$0470	;0470
	dc.w	$04A8	;04A8
	dc.w	$04D8	;04D8
	dc.w	$0500	;0500
	dc.w	$0528	;0528
	dc.w	$0540	;0540
	dc.w	$0558	;0558
	dc.w	$0570	;0570
	dc.w	$0588	;0588
	dc.w	$05A0	;05A0
	dc.w	$05B8	;05B8
	dc.w	$05D0	;05D0
	dc.w	$05E8	;05E8
	dc.w	$0600	;0600
	dc.w	$0648	;0648
	dc.w	$0680	;0680
	dc.w	$06B0	;06B0
	dc.w	$06D0	;06D0
	dc.w	$06E8	;06E8
	dc.w	$0720	;0720
	dc.w	$0750	;0750
	dc.w	$0778	;0778
	dc.w	$0798	;0798
	dc.w	$07B0	;07B0
	dc.w	$07F8	;07F8
	dc.w	$0830	;0830
	dc.w	$0860	;0860
	dc.w	$0880	;0880
	dc.w	$0898	;0898
	dc.w	$08C8	;08C8
	dc.w	$08E8	;08E8
	dc.w	$0900	;0900
	dc.w	$0918	;0918
	dc.w	$0920	;0920
	dc.w	$0950	;0950
	dc.w	$0978	;0978
	dc.w	$0998	;0998
	dc.w	$09B0	;09B0
	dc.w	$09C8	;09C8
	dc.w	$0A08	;0A08
	dc.w	$0A38	;0A38
	dc.w	$0A60	;0A60
	dc.w	$0A78	;0A78
	dc.w	$0A90	;0A90
	dc.w	$0AC0	;0AC0
	dc.w	$0AE8	;0AE8
	dc.w	$0B08	;0B08
	dc.w	$0B20	;0B20
	dc.w	$0B38	;0B38
	dc.w	$0B78	;0B78
	dc.w	$0BA8	;0BA8
	dc.w	$0BD0	;0BD0
	dc.w	$0BE8	;0BE8
	dc.w	$0C00	;0C00
	dc.w	$0C38	;0C38
	dc.w	$0C60	;0C60
	dc.w	$0C88	;0C88
	dc.w	$0CA0	;0CA0
	dc.w	$0000	;0000
	dc.w	$0060	;0060
	dc.w	$00C0	;00C0
	dc.w	$0110	;0110
	dc.w	$0138	;0138
	dc.w	$0150	;0150
	dc.w	$01B0	;01B0
	dc.w	$0210	;0210
	dc.w	$0260	;0260
	dc.w	$0288	;0288
	dc.w	$02A0	;02A0
	dc.w	$0320	;0320
	dc.w	$0390	;0390
	dc.w	$03F0	;03F0
	dc.w	$0418	;0418
	dc.w	$0438	;0438
	dc.w	$0488	;0488
	dc.w	$04D8	;04D8
	dc.w	$0528	;0528
	dc.w	$0548	;0548
	dc.w	$0568	;0568
	dc.w	$0598	;0598
	dc.w	$05C8	;05C8
	dc.w	$05F8	;05F8
	dc.w	$0610	;0610
	dc.w	$0628	;0628
	dc.w	$0658	;0658
	dc.w	$0688	;0688
	dc.w	$06B8	;06B8
	dc.w	$06D0	;06D0
	dc.w	$06E8	;06E8
	dc.w	$0738	;0738
	dc.w	$0788	;0788
	dc.w	$07D8	;07D8
	dc.w	$07F0	;07F0
	dc.w	$0808	;0808
	dc.w	$0898	;0898
	dc.w	$0948	;0948
	dc.w	$09B8	;09B8
	dc.w	$09E8	;09E8
	dc.w	$0A08	;0A08
	dc.w	$0A78	;0A78
	dc.w	$0AD8	;0AD8
	dc.w	$0B28	;0B28
	dc.w	$0B48	;0B48
adrEA00E998:
	dc.b	$FC	;FC
	dc.b	$12	;12
	dc.b	$0B	;0B
	dc.b	$FE	;FE
	dc.b	$04	;04
	dc.b	$02	;02
	dc.b	'       '	;20202020202020
	dc.b	$03	;03
	dc.b	$FF	;FF
	dc.b	$00	;00
BeginGameScroll:
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$03	;03
	dc.b	$FE	;FE
	dc.b	$0D	;0D
	dc.b	$FD	;FD
	dc.b	$03	;03
	dc.b	'PLAYER 0'	;504C415945522030
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	$FE	;FE
	dc.b	$00	;00
	dc.b	'THOU ART'	;54484F5520415254
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'NOW READY'	;4E4F57205245414459
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'TO BEGIN'	;544F20424547494E
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'THY QUEST'	;544859205155455354
	dc.b	$FF	;FF
adrEA00E9E8:
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$08	;08
	dc.b	$FE	;FE
	dc.b	$0D	;0D
	dc.b	'FOOD'	;464F4F44
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$09	;09
	dc.b	$FE	;FE
	dc.b	$04	;04
	dc.b	$02	;02
	dc.b	'      '	;202020202020
	dc.b	$03	;03
	dc.b	$FF	;FF
	dc.b	$00	;00
adrEA00EA00:
	dc.b	$FE	;FE
	dc.b	$0B	;0B
	dc.b	$FD	;FD
	dc.b	$00	;00
	dc.b	'SP.PTS '	;53502E50545320
	dc.b	$FE	;FE
	dc.b	$06	;06
	dc.b	'  /  '	;20202F2020
	dc.b	$FF	;FF
	dc.b	$00	;00
adrEA00EA14:
	dc.b	$FC	;FC
	dc.b	$1D	;1D
	dc.b	$03	;03
	dc.b	$FE	;FE
	dc.b	$0D	;0D
	dc.b	$FD	;FD
	dc.b	$03	;03
	dc.b	'INVENTORY'	;494E56454E544F5259
	dc.b	$FF	;FF
adrEA00EA25:
	dc.b	$FC	;FC
	dc.b	$1D	;1D
	dc.b	$08	;08
	dc.b	'ARMOUR:'	;41524D4F55523A
	dc.b	$FE	;FE
	dc.b	$0E	;0E
	dc.b	'   '	;202020
	dc.b	$FF	;FF
	dc.b	$00	;00
adrEA00EA36:
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$0A	;0A
	dc.b	$FE	;FE
	dc.b	$0D	;0D
	dc.b	$FD	;FD
	dc.b	$00	;00
	dc.b	'COST'	;434F5354
	dc.b	$FE	;FE
	dc.b	$0C	;0C
	dc.b	$04	;04
	dc.b	$FE	;FE
	dc.b	$0D	;0D
	dc.b	'00'	;3030
	dc.b	$FE	;FE
	dc.b	$0C	;0C
	dc.b	$05	;05
	dc.b	$FF	;FF
adrEA00EA4C:
	dc.b	$FE	;FE
	dc.b	$0D	;0D
	dc.b	'CAST % '	;43415354202520
	dc.b	$FE	;FE
	dc.b	$04	;04
	dc.b	$02	;02
	dc.b	'      '	;202020202020
	dc.b	$03	;03
	dc.b	' '	;20
	dc.b	$FF	;FF
	dc.b	$00	;00
CostTooHighMsg:
	dc.b	$FE	;FE
	dc.b	$0C	;0C
	dc.b	'COST TOO HIGH'	;434F535420544F4F2048494748
	dc.b	$FF	;FF
adrEA00EA72:
	dc.w	$00E2	;00E2
	dc.w	$0106	;0106
	dc.w	$0021	;0021
	dc.w	$0036	;0036
	dc.w	$0109	;0109
	dc.w	$011E	;011E
	dc.w	$0021	;0021
	dc.w	$0036	;0036
	dc.w	$0121	;0121
	dc.w	$012E	;012E
	dc.w	$0022	;0022
	dc.w	$002F	;002F
	dc.w	$0131	;0131
	dc.w	$013F	;013F
	dc.w	$0022	;0022
	dc.w	$002F	;002F
	dc.w	$010D	;010D
	dc.w	$011D	;011D
	dc.w	$003A	;003A
	dc.w	$0046	;0046
	dc.w	$010D	;010D
	dc.w	$011D	;011D
	dc.w	$0048	;0048
	dc.w	$0055	;0055
	dc.w	$0120	;0120
	dc.w	$012F	;012F
	dc.w	$003A	;003A
	dc.w	$0045	;0045
	dc.w	$0130	;0130
	dc.w	$013F	;013F
	dc.w	$003A	;003A
	dc.w	$0045	;0045
	dc.w	$0130	;0130
	dc.w	$013F	;013F
	dc.w	$0049	;0049
	dc.w	$0054	;0054
	dc.w	$0120	;0120
	dc.w	$012F	;012F
	dc.w	$0049	;0049
	dc.w	$0054	;0054
	dc.w	$00F1	;00F1
	dc.w	$00FC	;00FC
	dc.w	$003B	;003B
	dc.w	$0045	;0045
	dc.w	$00F0	;00F0
	dc.w	$00FD	;00FD
	dc.w	$0049	;0049
	dc.w	$0053	;0053
	dc.w	$00E2	;00E2
	dc.w	$00EC	;00EC
	dc.w	$0047	;0047
	dc.w	$0053	;0053
	dc.w	$0101	;0101
	dc.w	$010B	;010B
	dc.w	$0047	;0047
	dc.w	$0053	;0053
	dc.w	$00E4	;00E4
	dc.w	$00EC	;00EC
	dc.w	$003C	;003C
	dc.w	$0043	;0043
	dc.w	$0100	;0100
	dc.w	$0109	;0109
	dc.w	$003C	;003C
	dc.w	$0043	;0043
	dc.w	$0072	;0072
	dc.w	$00CD	;00CD
	dc.w	$001C	;001C
	dc.w	$0057	;0057
adrEA00EAFA:
	dc.w	$0038	;0038
	dc.w	$0047	;0047
	dc.w	$0008	;0008
	dc.w	$0017	;0017
	dc.w	$0048	;0048
	dc.w	$0057	;0057
	dc.w	$0008	;0008
	dc.w	$0017	;0017
	dc.w	$0038	;0038
	dc.w	$0047	;0047
	dc.w	$0018	;0018
	dc.w	$0027	;0027
	dc.w	$0048	;0048
	dc.w	$0057	;0057
	dc.w	$0018	;0018
	dc.w	$0027	;0027
	dc.w	$0038	;0038
	dc.w	$0057	;0057
	dc.w	$0028	;0028
	dc.w	$0037	;0037
	dc.w	$0000	;0000
	dc.w	$005D	;005D
	dc.w	$003A	;003A
	dc.w	$0057	;0057
CharacterStats:
	dc.b	$01	;01
	dc.b	$23	;23
	dc.b	$11	;11
	dc.b	$0D	;0D
	dc.b	$0D	;0D

	dc.b	$23	;23
	dc.b	$23	;23
	dc.b	$1F	;1F
	dc.b	$1F	;1F
	dc.b	$06	;06
	dc.b	$09	;09
	dc.b	$05	;05
	dc.b	$80	;80
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$C7	;C7

	dc.b	$FF	;FF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0709	;0709
	dc.w	$0200	;0200
	dc.w	$0300	;0300
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0113	;0113
	dc.w	$1726	;1726
	dc.w	$0E12	;0E12
	dc.w	$121A	;121A
	dc.w	$1A2B	;1A2B
	dc.w	$2D00	;2D00
	dc.w	$4800	;4800
	dc.w	$0000	;0000
	dc.w	$C7FF	;C7FF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$010E	;010E
	dc.w	$0100	;0100
	dc.w	$0300	;0300
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0118	;0118
	dc.w	$1313	;1313
	dc.w	$2318	;2318
	dc.w	$1818	;1818
	dc.w	$180D	;180D
	dc.w	$0D01	;0D01
	dc.w	$0400	;0400
	dc.w	$0000	;0000
	dc.w	$C7FF	;C7FF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1219	;1219
	dc.w	$0000	;0000
	dc.w	$0300	;0300
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0110	;0110
	dc.w	$200E	;200E
	dc.w	$1218	;1218
	dc.w	$1813	;1813
	dc.w	$1310	;1310
	dc.w	$1000	;1000
	dc.w	$0008	;0008
	dc.w	$0000	;0000
	dc.w	$C7FF	;C7FF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0514	;0514
	dc.w	$0200	;0200
	dc.w	$0300	;0300
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrEA00EBAA:
	dc.w	$0122	;0122
	dc.w	$150F	;150F
	dc.w	$0F25	;0F25
	dc.w	$251A	;251A
	dc.w	$1A06	;1A06
	dc.w	$0803	;0803
	dc.w	$0800	;0800
	dc.w	$0000	;0000
	dc.w	$C7FF	;C7FF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0719	;0719
	dc.w	$0000	;0000
	dc.w	$0300	;0300
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0113	;0113
	dc.w	$1623	;1623
	dc.w	$1410	;1410
	dc.w	$1017	;1017
	dc.w	$172B	;172B
	dc.w	$3100	;3100
	dc.w	$0480	;0480
	dc.w	$0000	;0000
	dc.w	$C7FF	;C7FF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$080F	;080F
	dc.w	$0200	;0200
	dc.w	$0300	;0300
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0118	;0118
	dc.w	$1412	;1412
	dc.w	$2719	;2719
	dc.w	$1919	;1919
	dc.w	$190D	;190D
	dc.w	$0E01	;0E01
	dc.w	$1000	;1000
	dc.w	$0000	;0000
	dc.w	$C7FF	;C7FF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$051B	;051B
	dc.w	$0100	;0100
	dc.w	$0300	;0300
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0110	;0110
	dc.w	$1F13	;1F13
	dc.w	$1217	;1217
	dc.w	$1716	;1716
	dc.w	$1610	;1610
	dc.w	$1000	;1000
	dc.w	$0020	;0020
	dc.w	$0000	;0000
	dc.w	$C7FF	;C7FF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0017	;0017
	dc.w	$0100	;0100
	dc.w	$0300	;0300
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0121	;0121
	dc.w	$1A0E	;1A0E
	dc.w	$0D20	;0D20
	dc.w	$201C	;201C
	dc.w	$1C06	;1C06
	dc.w	$0702	;0702
	dc.w	$0080	;0080
	dc.w	$0000	;0000
	dc.w	$C7FF	;C7FF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0013	;0013
	dc.w	$0100	;0100
	dc.w	$0300	;0300
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0110	;0110
	dc.w	$1824	;1824
	dc.w	$1111	;1111
	dc.w	$1119	;1119
	dc.w	$1900	;1900
	dc.w	$0000	;0000
	dc.w	$1008	;1008
	dc.w	$0000	;0000
	dc.w	$C7FF	;C7FF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$081D	;081D
	dc.w	$0300	;0300
	dc.w	$0300	;0300
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0117	;0117
	dc.w	$1215	;1215
	dc.w	$2418	;2418
	dc.w	$1817	;1817
	dc.w	$170D	;170D
	dc.w	$0D03	;0D03
	dc.w	$8000	;8000
	dc.w	$0000	;0000
	dc.w	$C7FF	;C7FF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0912	;0912
	dc.w	$0200	;0200
	dc.w	$0300	;0300
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$010D	;010D
	dc.w	$2014	;2014
	dc.w	$0B14	;0B14
	dc.w	$1412	;1412
	dc.w	$1210	;1210
	dc.w	$1004	;1004
	dc.w	$4000	;4000
	dc.w	$0000	;0000
	dc.w	$C7FF	;C7FF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0D1A	;0D1A
	dc.w	$0000	;0000
	dc.w	$0300	;0300
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0124	;0124
	dc.w	$1710	;1710
	dc.w	$0B23	;0B23
	dc.w	$231C	;231C
	dc.w	$1C03	;1C03
	dc.w	$0602	;0602
	dc.w	$1000	;1000
	dc.w	$0000	;0000
	dc.w	$C7FF	;C7FF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$101C	;101C
	dc.w	$0200	;0200
	dc.w	$0300	;0300
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0112	;0112
	dc.w	$171F	;171F
	dc.w	$1311	;1311
	dc.w	$1119	;1119
	dc.w	$192B	;192B
	dc.w	$2B00	;2B00
	dc.w	$8020	;8020
	dc.w	$0000	;0000
	dc.w	$C7FF	;C7FF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$001D	;001D
	dc.w	$0100	;0100
	dc.w	$0300	;0300
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0119	;0119
	dc.w	$1417	;1417
	dc.w	$231A	;231A
	dc.w	$1A1B	;1A1B
	dc.w	$1B0D	;1B0D
	dc.w	$0D01	;0D01
	dc.w	$0800	;0800
	dc.w	$0000	;0000
	dc.w	$C7FF	;C7FF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0B0A	;0B0A
	dc.w	$0300	;0300
	dc.w	$0300	;0300
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0112	;0112
	dc.w	$2410	;2410
	dc.w	$0F16	;0F16
	dc.w	$1619	;1619
	dc.w	$1910	;1910
	dc.w	$1001	;1001
	dc.w	$0080	;0080
	dc.w	$0000	;0000
	dc.w	$C7FF	;C7FF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0312	;0312
	dc.w	$0100	;0100
	dc.w	$0300	;0300
	dc.w	$0000	;0000
	dc.w	$0000	;0000
PocketContents:
	dc.w	$3300	;3300

	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0A10	;0A10
	dc.w	$0000	;0000
	dc.w	$0002	;0002
	dc.w	$0A05	;0A05
	dc.w	$0000	;0000
	dc.w	$3D00	;3D00
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0A10	;0A10
	dc.w	$0000	;0000
	dc.w	$0002	;0002
	dc.w	$0A05	;0A05
	dc.w	$0000	;0000
	dc.w	$3200	;3200
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0A10	;0A10
	dc.w	$0000	;0000
	dc.w	$0002	;0002
	dc.w	$0A05	;0A05
	dc.w	$0000	;0000
	dc.w	$3000	;3000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0A10	;0A10
	dc.w	$0000	;0000
	dc.w	$0002	;0002
	dc.w	$0A05	;0A05
	dc.w	$0000	;0000
	dc.w	$3300	;3300
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0A10	;0A10
	dc.w	$0000	;0000
	dc.w	$0002	;0002
	dc.w	$0A05	;0A05
	dc.w	$0000	;0000
	dc.w	$3D00	;3D00
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0A10	;0A10
	dc.w	$0000	;0000
	dc.w	$0002	;0002
	dc.w	$0A05	;0A05
	dc.w	$0000	;0000
	dc.w	$3200	;3200
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0A10	;0A10
	dc.w	$0000	;0000
	dc.w	$0002	;0002
	dc.w	$0A05	;0A05
	dc.w	$0000	;0000
	dc.w	$3000	;3000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0A10	;0A10
	dc.w	$0000	;0000
	dc.w	$0002	;0002
	dc.w	$0A05	;0A05
	dc.w	$0000	;0000
	dc.w	$3300	;3300
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0A10	;0A10
	dc.w	$0000	;0000
	dc.w	$0002	;0002
	dc.w	$0A05	;0A05
	dc.w	$0000	;0000
	dc.w	$3D00	;3D00
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0A10	;0A10
	dc.w	$0000	;0000
	dc.w	$0002	;0002
	dc.w	$0A05	;0A05
	dc.w	$0000	;0000
	dc.w	$3200	;3200
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0A10	;0A10
	dc.w	$0000	;0000
	dc.w	$0002	;0002
	dc.w	$0A05	;0A05
	dc.w	$0000	;0000
	dc.w	$3000	;3000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0A10	;0A10
	dc.w	$0000	;0000
	dc.w	$0002	;0002
	dc.w	$0A05	;0A05
	dc.w	$0000	;0000
	dc.w	$3300	;3300
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0A10	;0A10
	dc.w	$0000	;0000
	dc.w	$0002	;0002
	dc.w	$0A05	;0A05
	dc.w	$0000	;0000
	dc.w	$3D00	;3D00
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0A10	;0A10
	dc.w	$0000	;0000
	dc.w	$0002	;0002
	dc.w	$0A05	;0A05
	dc.w	$0000	;0000
	dc.w	$3200	;3200
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0A10	;0A10
	dc.w	$0000	;0000
	dc.w	$0002	;0002
	dc.w	$0A05	;0A05
	dc.w	$0000	;0000
	dc.w	$3000	;3000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0A10	;0A10
	dc.w	$0000	;0000
	dc.w	$0002	;0002
	dc.w	$0A05	;0A05
	dc.w	$0000	;0000
adrW_00EE2A:
	dc.w	$0000	;0000
adrB_00EE2C:
	dc.b	$00	;00
adrB_00EE2D:
	dc.b	$00	;00
CurrentTower:
	dc.b	$00	;00

	dc.b	$00	;00
MultiPlayer:
	dc.w	$FFFF	;FFFF
RingUses:
	dc.w	$0102	;0102
	dc.w	$0303	;0303
adrEA00EE36:
	dc.w	$0000	;0000
adrW_00EE38:
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrB_00EE3C:
	dc.b	$00	;00
adrB_00EE3D:
	dc.b	$01	;01
adrB_00EE3E:
	dc.b	$00	;00
adrB_00EE3F:
	dc.b	$00	;00
adrEA00EE40:
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrEA00EE50:
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrEA00EE60:
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrW_00EE70:
	dc.b	$00	;00
adrB_00EE71:
	dc.b	$00	;00
adrW_00EE72:
	dc.b	$00	;00
adrB_00EE73:
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
adrW_00EE76:
	dc.w	$0000	;0000
adrL_00EE78:
	dc.l	$0000EF78	;0000EF78	;Long Addr replaced with Symbol *Fix stored address **
Player1_Data:
	dc.b	$00	;00
adrB_00EE7D:
	dc.b	$00	;00
adrL_00EE7E:
	dc.l	$00000000	;00000000
adrW_00EE82:
	dc.b	$00	;00
adrB_00EE83:
	dc.b	$00	;00
adrW_00EE84:
	dc.w	$0000	;0000
adrW_00EE86:
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0007	;0007
	dc.w	$0008	;0008
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
adrL_00EE94:
	dc.l	$FFFFFFFF	;FFFFFFFF
adrL_00EE98:
	dc.l	$00000000	;00000000
	dc.w	$0000	;0000
adrW_00EE9E:
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrL_00EEA2:
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.b	$FF	;FF
adrB_00EEB1:
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
adrW_00EEB6:
	dc.w	$0000	;0000
	dc.w	$00FF	;00FF
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrW_00EEC6:
	dc.w	$0000	;0000
adrW_00EEC8:
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrB_00EECE:
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
adrB_00EED2:
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
adrB_00EED5:
	dc.b	$00	;00
adrL_00EED6:
	dc.l	$FFFFFFFF	;FFFFFFFF
	dc.l	$FFFFFFFF	;FFFFFFFF
Player2_Data:
	dc.b	$01	;01
adrB_00EEDF:
	dc.b	$00	;00
adrL_00EEE0:
	dc.l	$00000000	;00000000
adrW_00EEE4:
	dc.b	$00	;00
adrB_00EEE5:
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
adrW_00EEF2:
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
adrL_00EEF6:
	dc.l	$FFFFFFFF	;FFFFFFFF
adrL_00EEFA:
	dc.l	$00000000	;00000000
	dc.w	$0000	;0000
adrW_00EF00:
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrL_00EF04:
	dc.l	$FFFFFFFF	;FFFFFFFF
	dc.l	$00000000	;00000000
	dc.l	$0000FFFF	;0000FFFF	;Long Addr replaced with Symbol
	dc.w	$FFFF	;FFFF
	dc.b	$FF	;FF
adrB_00EF13:
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
adrW_00EF18:
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
adrB_00EF34:
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
adrB_00EF37:
	dc.b	$00	;00
adrL_00EF38:
	dc.l	$FFFFFFFF	;FFFFFFFF
	dc.l	$FFFFFFFF	;FFFFFFFF
MapData1:
	INCBIN edit-data/mod0.map

ObjectData_1:
	dc.w	$033F	;033F
	dc.w	$C80E	;C80E
	dc.w	$0007	;0007
	dc.w	$0188	;0188
	dc.w	$0E00	;0E00
	dc.w	$0701	;0701
	dc.w	$484A	;484A
	dc.w	$000A	;000A
	dc.w	$0188	;0188

	dc.w	$8E02	;8E02
	dc.w	$5001	;5001
	dc.w	$3001	;3001
	dc.w	$0205	;0205
	dc.w	$0850	;0850
	dc.w	$0013	;0013
	dc.w	$0188	;0188
	dc.w	$5000	;5000
	dc.w	$1301	;1301
	dc.w	$8810	;8810
	dc.w	$000D	;000D
	dc.w	$01C8	;01C8
	dc.w	$1000	;1000
	dc.w	$0D01	;0D01
	dc.w	$C84A	;C84A
	dc.w	$000A	;000A
	dc.w	$01C8	;01C8
	dc.w	$8800	;8800
	dc.w	$1001	;1001
	dc.w	$4888	;4888
	dc.w	$0010	;0010
	dc.w	$0186	;0186
	dc.w	$8200	;8200
	dc.w	$0203	;0203
	dc.w	$C654	;C654
	dc.w	$0002	;0002
	dc.w	$0145	;0145
	dc.w	$D401	;D401
	dc.w	$030A	;030A
	dc.w	$5C01	;5C01
	dc.w	$0616	;0616
	dc.w	$0051	;0051
	dc.w	$0185	;0185
	dc.w	$A200	;A200
	dc.w	$5001	;5001
	dc.w	$05A2	;05A2
	dc.w	$0103	;0103
	dc.w	$0A5C	;0A5C
	dc.w	$0186	;0186
	dc.w	$E600	;E600
	dc.w	$1B01	;1B01
	dc.w	$C5AA	;C5AA
	dc.w	$0033	;0033
	dc.w	$01C6	;01C6
	dc.w	$E400	;E400
	dc.w	$2401	;2401
	dc.w	$85AA	;85AA
	dc.w	$0024	;0024
	dc.w	$0185	;0185
	dc.w	$7C00	;7C00
	dc.w	$1B01	;1B01
	dc.w	$C586	;C586
	dc.w	$0025	;0025
	dc.w	$0106	;0106
	dc.w	$EA00	;EA00
	dc.w	$5001	;5001
	dc.w	$86AC	;86AC
	dc.w	$0017	;0017
	dc.w	$0106	;0106
	dc.w	$4200	;4200
	dc.w	$0105	;0105
	dc.w	$C5F6	;C5F6
	dc.w	$0003	;0003
	dc.w	$01C7	;01C7
	dc.w	$6800	;6800
	dc.w	$2501	;2501
	dc.w	$C76A	;C76A
	dc.w	$0032	;0032
	dc.w	$010C	;010C
	dc.w	$7A00	;7A00
	dc.w	$1801	;1801
	dc.w	$4C7A	;4C7A
	dc.w	$0018	;0018
	dc.w	$018C	;018C
	dc.w	$0000	;0000
	dc.w	$1A01	;1A01
	dc.w	$0C00	;0C00
	dc.w	$001A	;001A
	dc.w	$01CB	;01CB
	dc.w	$C000	;C000
	dc.w	$1701	;1701
	dc.w	$8BC0	;8BC0
	dc.w	$0017	;0017
	dc.w	$010C	;010C
	dc.w	$3E00	;3E00
	dc.w	$1901	;1901
	dc.w	$8C3E	;8C3E
	dc.w	$0019	;0019
	dc.w	$01CB	;01CB
	dc.w	$8C00	;8C00
	dc.w	$3001	;3001
	dc.w	$4B8C	;4B8C
	dc.w	$0002	;0002
	dc.w	$02CC	;02CC
	dc.w	$4601	;4601
	dc.w	$5401	;5401
	dc.w	$0A01	;0A01
	dc.w	$C95A	;C95A
	dc.w	$0003	;0003
	dc.w	$0689	;0689
	dc.w	$5A00	;5A00
	dc.w	$2C01	;2C01
	dc.w	$0AC0	;0AC0
	dc.w	$0003	;0003
	dc.w	$04C8	;04C8
	dc.w	$2001	;2001
	dc.w	$0105	;0105
	dc.w	$0203	;0203
	dc.w	$C3FA	;C3FA
	dc.w	$0050	;0050
	dc.w	$01C4	;01C4
	dc.w	$5200	;5200
	dc.w	$0103	;0103
	dc.w	$0400	;0400
	dc.w	$005C	;005C
	dc.w	$01C5	;01C5
	dc.w	$2801	;2801
	dc.w	$5201	;5201
	dc.w	$0A01	;0A01
	dc.w	$03AC	;03AC
	dc.w	$0002	;0002
	dc.w	$0145	;0145
	dc.w	$0E00	;0E00
	dc.w	$0107	;0107
	dc.w	$0538	;0538
	dc.w	$0003	;0003
	dc.w	$0483	;0483
	dc.w	$A000	;A000
	dc.w	$3301	;3301
	dc.w	$C53E	;C53E
	dc.w	$0002	;0002
	dc.w	$0604	;0604
	dc.w	$2201	;2201
	dc.w	$0103	;0103
	dc.w	$0701	;0701
	dc.w	$0460	;0460
	dc.w	$0030	;0030
	dc.w	$01C4	;01C4
	dc.w	$5E00	;5E00
	dc.w	$0107	;0107
	dc.w	$C4A2	;C4A2
	dc.w	$0003	;0003
	dc.w	$0404	;0404
	dc.w	$C000	;C000
	dc.w	$5101	;5101
	dc.w	$8530	;8530
	dc.w	$0024	;0024
	dc.w	$0184	;0184
	dc.w	$D400	;D400
	dc.w	$1401	;1401
	dc.w	$C168	;C168
	dc.w	$0153	;0153
	dc.w	$010A	;010A
	dc.w	$01C2	;01C2
	dc.w	$4C00	;4C00
	dc.w	$3001	;3001
	dc.w	$C128	;C128
	dc.w	$0201	;0201
	dc.w	$0250	;0250
	dc.w	$0107	;0107
	dc.w	$01C0	;01C0
	dc.w	$EE00	;EE00
	dc.w	$5501	;5501
	dc.w	$00E2	;00E2
	dc.w	$003D	;003D
	dc.w	$0140	;0140
	dc.w	$3A00	;3A00
	dc.w	$0103	;0103
	dc.w	$8036	;8036
	dc.w	$0002	;0002
	dc.w	$0381	;0381
	dc.w	$3001	;3001
	dc.w	$1A01	;1A01
	dc.w	$2C01	;2C01
	dc.w	$0036	;0036
	dc.w	$000D	;000D
	dc.w	$01C0	;01C0
	dc.w	$5400	;5400
	dc.w	$0104	;0104
	dc.w	$C07A	;C07A
	dc.w	$0013	;0013
	dc.w	$018D	;018D
	dc.w	$8000	;8000
	dc.w	$5201	;5201
	dc.w	$CD0A	;CD0A
	dc.w	$0027	;0027
	dc.w	$018D	;018D
	dc.w	$FC00	;FC00
	dc.w	$0107	;0107
	dc.w	$CE30	;CE30
	dc.w	$002C	;002C
	dc.w	$010F	;010F
	dc.w	$9000	;9000
	dc.w	$0201	;0201
	dc.w	$0D6A	;0D6A
	dc.w	$0010	;0010
	dc.w	$018D	;018D
	dc.w	$6A00	;6A00
	dc.w	$0701	;0701
	dc.w	$0D6C	;0D6C
	dc.w	$000A	;000A
	dc.w	$010D	;010D
	dc.w	$6E00	;6E00
	dc.w	$0201	;0201
	dc.w	$CD6A	;CD6A
	dc.w	$0001	;0001
	dc.w	$018D	;018D
	dc.w	$6E00	;6E00
	dc.w	$1301	;1301
	dc.w	$4D70	;4D70
	dc.w	$0002	;0002
	dc.w	$030C	;030C
	dc.w	$CE00	;CE00
	dc.w	$0D01	;0D01
	dc.w	$8CD0	;8CD0
	dc.w	$010A	;010A
	dc.w	$010D	;010D
	dc.w	$014D	;014D
	dc.w	$2200	;2200
	dc.w	$0A01	;0A01
	dc.w	$8156	;8156
	dc.w	$000D	;000D
	dc.w	$01CC	;01CC
	dc.w	$DC00	;DC00
	dc.w	$1001	;1001
	dc.w	$CD28	;CD28
	dc.w	$0013	;0013
	dc.w	$018D	;018D
	dc.w	$D800	;D800
	dc.w	$0101	;0101
	dc.w	$CE36	;CE36
	dc.w	$0003	;0003
	dc.w	$03CD	;03CD
	dc.w	$EA00	;EA00
	dc.w	$0303	;0303
	dc.w	$4E70	;4E70
	dc.w	$0033	;0033
	dc.w	$010E	;010E
	dc.w	$E200	;E200
	dc.w	$0A01	;0A01
	dc.w	$0F7C	;0F7C
	dc.w	$0002	;0002
	dc.w	$010F	;010F
	dc.w	$5600	;5600
	dc.w	$1D01	;1D01
	dc.w	$CF88	;CF88
	dc.w	$0101	;0101
	dc.w	$0518	;0518
	dc.w	$014F	;014F
	dc.w	$8800	;8800
	dc.w	$0101	;0101
	dc.w	$CE06	;CE06
	dc.w	$0001	;0001
	dc.w	$050E	;050E
	dc.w	$6400	;6400
	dc.w	$0301	;0301
	dc.w	$CE68	;CE68
	dc.w	$0019	;0019
	dc.w	$014E	;014E
	dc.w	$1C00	;1C00
	dc.w	$0105	;0105
	dc.w	$0BCA	;0BCA
	dc.w	$0001	;0001
	dc.w	$0ACC	;0ACC
	dc.w	$0A00	;0A00
	dc.w	$010A	;010A
	dc.w	$8894	;8894
	dc.w	$012C	;012C
	dc.w	$0110	;0110
	dc.w	$01C3	;01C3
	dc.w	$2A00	;2A00
	dc.w	$1401	;1401
	dc.w	$0156	;0156
	dc.w	$0104	;0104
	dc.w	$080A	;080A
	dc.w	$0141	;0141
	dc.w	$4C00	;4C00
	dc.w	$1D01	;1D01
	dc.w	$C130	;C130
	dc.w	$0056	;0056
	dc.w	$014C	;014C
	dc.w	$CE00	;CE00
	dc.w	$0203	;0203
	dc.w	$8D6C	;8D6C
	dc.w	$0013	;0013
	dc.w	$010C	;010C
	dc.w	$D001	;D001
	dc.w	$030A	;030A
	dc.w	$3201	;3201
	dc.w	$8914	;8914
	dc.w	$0003	;0003
	dc.w	$0A89	;0A89
	dc.w	$4E00	;4E00
	dc.w	$2501	;2501
	dc.w	$079A	;079A
	dc.w	$001C	;001C
	dc.w	$0144	;0144
	dc.w	$B200	;B200
	dc.w	$2501	;2501
	dc.w	$44AA	;44AA
	dc.w	$003D	;003D
	dc.w	$01C8	;01C8
	dc.w	$2801	;2801
	dc.w	$0701	;0701
	dc.w	$3801	;3801
	dc.w	$84B0	;84B0
	dc.w	$0304	;0304
	dc.w	$142E	;142E
	dc.w	$0119	;0119
	dc.w	$0115	;0115
	dc.w	$01C4	;01C4
	dc.w	$CE02	;CE02
	dc.w	$0114	;0114
	dc.w	$1801	;1801
	dc.w	$1701	;1701
	dc.w	$84CE	;84CE
	dc.w	$011A	;011A
	dc.w	$0116	;0116
	dc.w	$0102	;0102
	dc.w	$EA00	;EA00
	dc.w	$1B01	;1B01
	dc.w	$0334	;0334
	dc.w	$0101	;0101
	dc.w	$0E27	;0E27
	dc.w	$0103	;0103
	dc.w	$A803	;A803
	dc.w	$2E01	;2E01
	dc.w	$2001	;2001
	dc.w	$1501	;1501
	dc.w	$1A01	;1A01
	dc.w	$838A	;838A
	dc.w	$0326	;0326
	dc.w	$0115	;0115
	dc.w	$015B	;015B
	dc.w	$0119	;0119
	dc.w	$0143	;0143
	dc.w	$A803	;A803
	dc.w	$1501	;1501
	dc.w	$3A01	;3A01
	dc.w	$0114	;0114
	dc.w	$1A01	;1A01
	dc.w	$C38A	;C38A
	dc.w	$0116	;0116
	dc.w	$0118	;0118
	dc.w	$0103	;0103
	dc.w	$8A02	;8A02
	dc.w	$0414	;0414
	dc.w	$1701	;1701
	dc.w	$1801	;1801
	dc.w	$438A	;438A
	dc.w	$0117	;0117
	dc.w	$0119	;0119
	dc.w	$0149	;0149
	dc.w	$6600	;6600
	dc.w	$1C01	;1C01
	dc.w	$CC88	;CC88
	dc.w	$0103	;0103
	dc.w	$0607	;0607
	dc.w	$014C	;014C
	dc.w	$8C01	;8C01
	dc.w	$3301	;3301
	dc.w	$1001	;1001
	dc.w	$8CCC	;8CCC
	dc.w	$010D	;010D
	dc.w	$011C	;011C
	dc.w	$010A	;010A
	dc.w	$CC00	;CC00
	dc.w	$1B01	;1B01
	dc.w	$C3AA	;C3AA
	dc.w	$0108	;0108
	dc.w	$0151	;0151
	dc.w	$0105	;0105
	dc.w	$0A00	;0A00
	dc.w	$0701	;0701
	dc.w	$44CE	;44CE
	dc.w	$025B	;025B
	dc.w	$0126	;0126
	dc.w	$0118	;0118
	dc.w	$01C4	;01C4
	dc.w	$B002	;B002
	dc.w	$3A01	;3A01
	dc.w	$2001	;2001
	dc.w	$1501	;1501
	dc.w	$04CE	;04CE
	dc.w	$0315	;0315
	dc.w	$0117	;0117
	dc.w	$011A	;011A
	dc.w	$0119	;0119
	dc.w	$0181	;0181
	dc.w	$2800	;2800
	dc.w	$0701	;0701
	dc.w	$C1A8	;C1A8
	dc.w	$0024	;0024
	dc.w	$01C1	;01C1
	dc.w	$A401	;A401
	dc.w	$0306	;0306
	dc.w	$1301	;1301
	dc.w	$41A4	;41A4
	dc.w	$000A	;000A
	dc.w	$0102	;0102
	dc.w	$0C02	;0C02
	dc.w	$0A01	;0A01
	dc.w	$1C01	;1C01
	dc.w	$1001	;1001
	dc.w	$4062	;4062
	dc.w	$0138	;0138
	dc.w	$0107	;0107
	dc.w	$0100	;0100
	dc.w	$3801	;3801
	dc.w	$1000	;1000
	dc.w	$0010	;0010
	dc.w	$011C	;011C
	dc.w	$011C	;011C
	dc.w	$011A	;011A
	dc.w	$0101	;0101
	dc.w	$0008	;0008
	dc.w	$0151	;0151
	dc.w	$0101	;0101
	dc.w	$000D	;000D
	dc.w	$011C	;011C
	dc.w	$0133	;0133
	dc.w	$0101	;0101
	dc.w	$1C01	;1C01
	dc.w	$FF38	;FF38
	dc.w	$0038	;0038
	dc.w	$0138	;0138
	dc.w	$0102	;0102
	dc.w	$EA00	;EA00
	dc.w	$1B01	;1B01
	dc.w	$02EA	;02EA
	dc.w	$001B	;001B
	dc.w	$0102	;0102
	dc.w	$EA00	;EA00
	dc.w	$1B01	;1B01
	dc.w	$02EA	;02EA
	dc.w	$001B	;001B
	dc.w	$0102	;0102
	dc.w	$EA00	;EA00
	dc.w	$1B01	;1B01
	dc.w	$1B01	;1B01
	dc.w	$1EFF	;1EFF
	dc.w	$0300	;0300
	dc.w	$0101	;0101
	dc.w	$1501	;1501
	dc.w	$1801	;1801
	dc.w	$04CE	;04CE
	dc.w	$FF19	;FF19
	dc.w	$0017	;0017
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
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
MapData2:
	dc.w	$0515	;0515
	dc.w	$1511	;1511
	dc.w	$0F0F	;0F0F
	dc.w	$0D0D	;0D0D
	dc.w	$0915	;0915
	dc.w	$1511	;1511
	dc.w	$0F0F	;0F0F
	dc.w	$0D0D	;0D0D
	dc.w	$0000	;0000
	dc.w	$005A	;005A
	dc.w	$03CC	;03CC
	dc.w	$073E	;073E
	dc.w	$0980	;0980
	dc.w	$0B42	;0B42
	dc.w	$0D04	;0D04
	dc.w	$0E56	;0E56
	dc.w	$0800	;0800
	dc.w	$0002	;0002
	dc.w	$0303	;0303
	dc.w	$0404	;0404
	dc.w	$0F00	;0F00
	dc.w	$0002	;0002
	dc.w	$0303	;0303
	dc.w	$0404	;0404
	dc.w	$0011	;0011
	dc.w	$0011	;0011
	dc.w	$073E	;073E
	dc.w	$0007	;0007
	dc.w	$00A1	;00A1
	dc.w	$0404	;0404
	dc.w	$0001	;0001
	dc.w	$0404	;0404
	dc.w	$00A1	;00A1
	dc.w	$3206	;3206
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$3A06	;3A06
	dc.w	$0A05	;0A05
	dc.w	$05A1	;05A1
	dc.w	$0000	;0000
	dc.w	$05A1	;05A1
	dc.w	$0A05	;0A05
	dc.w	$1002	;1002
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1002	;1002
	dc.w	$0000	;0000
	dc.w	$0AB1	;0AB1
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0706	;0706
	dc.w	$0001	;0001
	dc.w	$1B06	;1B06
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0001	;0001
	dc.w	$0105	;0105
	dc.w	$0001	;0001
	dc.w	$0081	;0081
	dc.w	$0001	;0001
	dc.w	$D206	;D206
	dc.w	$DA06	;DA06
	dc.w	$E206	;E206
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0905	;0905
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0505	;0505
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0705	;0705
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0C12	;0C12
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0705	;0705
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0081	;0081
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$11B1	;11B1
	dc.w	$02A1	;02A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0081	;0081
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$2306	;2306
	dc.w	$0505	;0505
	dc.w	$2A06	;2A06
	dc.w	$02B1	;02B1
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0705	;0705
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$22B1	;22B1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$11B1	;11B1
	dc.w	$0281	;0281
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$4A06	;4A06
	dc.w	$00A1	;00A1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0081	;0081
	dc.w	$0305	;0305
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0081	;0081
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C102	;C102
	dc.w	$0001	;0001
	dc.w	$0191	;0191
	dc.w	$0102	;0102
	dc.w	$0102	;0102
	dc.w	$0502	;0502
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0404	;0404
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0705	;0705
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0402	;0402
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0003	;0003
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$1002	;1002
	dc.w	$1402	;1402
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0505	;0505
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0C12	;0C12
	dc.w	$0000	;0000
	dc.w	$C012	;C012
	dc.w	$0702	;0702
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$2315	;2315
	dc.w	$01A1	;01A1
	dc.w	$3315	;3315
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$1AB1	;1AB1
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$3012	;3012
	dc.w	$01A1	;01A1
	dc.w	$01A1	;01A1
	dc.w	$0003	;0003
	dc.w	$4402	;4402
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$4115	;4115
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$5002	;5002
	dc.w	$1402	;1402
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0604	;0604
	dc.w	$15A1	;15A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$00A1	;00A1
	dc.w	$0104	;0104
	dc.w	$0001	;0001
	dc.w	$0104	;0104
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0103	;0103
	dc.w	$0081	;0081
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$19A1	;19A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0302	;0302
	dc.w	$0001	;0001
	dc.w	$0302	;0302
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1402	;1402
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$4306	;4306
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C002	;C002
	dc.w	$0000	;0000
	dc.w	$0B06	;0B06
	dc.w	$0000	;0000
	dc.w	$0C12	;0C12
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$3002	;3002
	dc.w	$0001	;0001
	dc.w	$3012	;3012
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$1281	;1281
	dc.w	$0000	;0000
	dc.w	$0F05	;0F05
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0305	;0305
	dc.w	$0000	;0000
	dc.w	$C002	;C002
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0D02	;0D02
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0312	;0312
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$1D81	;1D81
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$1002	;1002
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0204	;0204
	dc.w	$0000	;0000
	dc.w	$1715	;1715
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0506	;0506
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$5515	;5515
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0003	;0003
	dc.w	$0402	;0402
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
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
	dc.w	$1715	;1715
	dc.w	$0000	;0000
	dc.w	$C002	;C002
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$D002	;D002
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0081	;0081
	dc.w	$31A1	;31A1
	dc.w	$0001	;0001
	dc.w	$3FA1	;3FA1
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$C112	;C112
	dc.w	$0102	;0102
	dc.w	$0102	;0102
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0004	;0004
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$3002	;3002
	dc.w	$0003	;0003
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$1002	;1002
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0706	;0706
	dc.w	$01B1	;01B1
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$0081	;0081
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0102	;0102
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0003	;0003
	dc.w	$0302	;0302
	dc.w	$00B1	;00B1
	dc.w	$0081	;0081
	dc.w	$1002	;1002
	dc.w	$3012	;3012
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0312	;0312
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$2F81	;2F81
	dc.w	$01A1	;01A1
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0104	;0104
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$5115	;5115
	dc.w	$05A1	;05A1
	dc.w	$0004	;0004
	dc.w	$01A1	;01A1
	dc.w	$0004	;0004
	dc.w	$05A1	;05A1
	dc.w	$6115	;6115
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C102	;C102
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0181	;0181
	dc.w	$0091	;0091
	dc.w	$0102	;0102
	dc.w	$0102	;0102
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$4102	;4102
	dc.w	$0000	;0000
	dc.w	$7002	;7002
	dc.w	$0001	;0001
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C102	;C102
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0081	;0081
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0304	;0304
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$7002	;7002
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$6115	;6115
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0004	;0004
	dc.w	$01A1	;01A1
	dc.w	$0312	;0312
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$1402	;1402
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0081	;0081
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0103	;0103
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0181	;0181
	dc.w	$2F81	;2F81
	dc.w	$2581	;2581
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C012	;C012
	dc.w	$0000	;0000
	dc.w	$7102	;7102
	dc.w	$00B1	;00B1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$25A1	;25A1
	dc.w	$3FA1	;3FA1
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0105	;0105
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$2115	;2115
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$2191	;2191
	dc.w	$0000	;0000
	dc.w	$1C12	;1C12
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0706	;0706
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$1002	;1002
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0704	;0704
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0106	;0106
	dc.w	$0000	;0000
	dc.w	$0302	;0302
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0106	;0106
	dc.w	$0000	;0000
	dc.w	$0003	;0003
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$2D91	;2D91
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0504	;0504
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0105	;0105
	dc.w	$0001	;0001
	dc.w	$3012	;3012
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$5AB1	;5AB1
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$4315	;4315
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0705	;0705
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$00A1	;00A1
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$29A1	;29A1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$2A81	;2A81
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0C12	;0C12
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C012	;C012
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$00A1	;00A1
	dc.w	$0504	;0504
	dc.w	$0001	;0001
	dc.w	$0504	;0504
	dc.w	$0081	;0081
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$11B1	;11B1
	dc.w	$02A1	;02A1
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0102	;0102
	dc.w	$0C12	;0C12
	dc.w	$0000	;0000
	dc.w	$2306	;2306
	dc.w	$0505	;0505
	dc.w	$2A06	;2A06
	dc.w	$02B1	;02B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$35A1	;35A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$1002	;1002
	dc.w	$00B1	;00B1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$11B1	;11B1
	dc.w	$0281	;0281
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0204	;0204
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$5002	;5002
	dc.w	$0000	;0000
	dc.w	$0003	;0003
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$5206	;5206
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0204	;0204
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0B06	;0B06
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$2315	;2315
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$3115	;3115
	dc.w	$0001	;0001
	dc.w	$0504	;0504
	dc.w	$0091	;0091
	dc.w	$0D02	;0D02
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$5206	;5206
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0003	;0003
	dc.w	$1591	;1591
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0181	;0181
	dc.w	$0305	;0305
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0505	;0505
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0106	;0106
	dc.w	$0000	;0000
	dc.w	$7715	;7715
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0003	;0003
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$3991	;3991
	dc.w	$1002	;1002
	dc.w	$1402	;1402
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0305	;0305
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0505	;0505
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0003	;0003
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$6306	;6306
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$3291	;3291
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$5B06	;5B06
	dc.w	$0B00	;0B00
	dc.w	$5B06	;5B06
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$32B1	;32B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$32A1	;32A1
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$4115	;4115
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$2515	;2515
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$1315	;1315
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0704	;0704
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$C102	;C102
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4102	;4102
	dc.w	$0102	;0102
	dc.w	$01B1	;01B1
	dc.w	$0004	;0004
	dc.w	$00A1	;00A1
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$05B1	;05B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4002	;4002
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$C002	;C002
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$0704	;0704
	dc.w	$0001	;0001
	dc.w	$0305	;0305
	dc.w	$00A1	;00A1
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$4002	;4002
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0081	;0081
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0302	;0302
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0505	;0505
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0003	;0003
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0102	;0102
	dc.w	$0102	;0102
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0505	;0505
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$8206	;8206
	dc.w	$0103	;0103
	dc.w	$7206	;7206
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0505	;0505
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$9206	;9206
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$9206	;9206
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$8A06	;8A06
	dc.w	$0103	;0103
	dc.w	$7A06	;7A06
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0305	;0305
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$9206	;9206
	dc.w	$0001	;0001
	dc.w	$0B06	;0B06
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$9206	;9206
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$9206	;9206
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$C012	;C012
	dc.w	$0000	;0000
	dc.w	$9206	;9206
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$01A1	;01A1
	dc.w	$0305	;0305
	dc.w	$01A1	;01A1
	dc.w	$1002	;1002
	dc.w	$1315	;1315
	dc.w	$0181	;0181
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$1002	;1002
	dc.w	$0001	;0001
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0706	;0706
	dc.w	$0000	;0000
	dc.w	$0706	;0706
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$6A06	;6A06
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0102	;0102
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$6A00	;6A00
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0003	;0003
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$6A00	;6A00
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0504	;0504
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0404	;0404
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C102	;C102
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$6A00	;6A00
	dc.w	$0001	;0001
	dc.w	$3115	;3115
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$3715	;3715
	dc.w	$3515	;3515
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$11B1	;11B1
	dc.w	$02A1	;02A1
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$6A00	;6A00
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$5002	;5002
	dc.w	$0001	;0001
	dc.w	$3AA1	;3AA1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$2306	;2306
	dc.w	$0505	;0505
	dc.w	$2A06	;2A06
	dc.w	$02B1	;02B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$6A00	;6A00
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0281	;0281
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$3515	;3515
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$3515	;3515
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0105	;0105
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0105	;0105
	dc.w	$0001	;0001
	dc.w	$0305	;0305
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0305	;0305
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0706	;0706
	dc.w	$0706	;0706
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0404	;0404
	dc.w	$3DA1	;3DA1
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0305	;0305
	dc.w	$4181	;4181
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0106	;0106
	dc.w	$0000	;0000
	dc.w	$0106	;0106
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0004	;0004
	dc.w	$0581	;0581
	dc.w	$0104	;0104
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0105	;0105
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$3002	;3002
	dc.w	$0091	;0091
	dc.w	$0402	;0402
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$7515	;7515
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$2715	;2715
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$CB06	;CB06
	dc.w	$05A1	;05A1
	dc.w	$03A1	;03A1
	dc.w	$05A1	;05A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$C306	;C306
	dc.w	$BB06	;BB06
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0591	;0591
	dc.w	$B306	;B306
	dc.w	$05B1	;05B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0591	;0591
	dc.w	$0100	;0100
	dc.w	$05B1	;05B1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$4A81	;4A81
	dc.w	$0591	;0591
	dc.w	$0104	;0104
	dc.w	$05B1	;05B1
	dc.w	$5281	;5281
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0581	;0581
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0581	;0581
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$05B1	;05B1
	dc.w	$0106	;0106
	dc.w	$0106	;0106
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$42A1	;42A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$EA06	;EA06
	dc.w	$EA06	;EA06
	dc.w	$0591	;0591
	dc.w	$0000	;0000
	dc.w	$AB06	;AB06
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$A306	;A306
	dc.w	$9B06	;9B06
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$05B1	;05B1
	dc.w	$0A05	;0A05
	dc.w	$0A05	;0A05
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0103	;0103
	dc.w	$0505	;0505
	dc.w	$F306	;F306
	dc.w	$FB06	;FB06
	dc.w	$0505	;0505
	dc.w	$0103	;0103
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0504	;0504
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$AB06	;AB06
	dc.w	$0001	;0001
	dc.w	$0581	;0581
	dc.w	$0581	;0581
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0100	;0100
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0302	;0302
	dc.w	$0581	;0581
	dc.w	$0302	;0302
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0C02	;0C02
ObjectData_2:
	dc.w	$02FD	;02FD

	dc.w	$8000	;8000
	dc.w	$0065	;0065
	dc.w	$01C0	;01C0
	dc.w	$0000	;0000
	dc.w	$5201	;5201
	dc.w	$8008	;8008
	dc.w	$0067	;0067
	dc.w	$01C0	;01C0
	dc.w	$0800	;0800
	dc.w	$5101	;5101
	dc.w	$8084	;8084
	dc.w	$0025	;0025
	dc.w	$0141	;0141
	dc.w	$1400	;1400
	dc.w	$5201	;5201
	dc.w	$407E	;407E
	dc.w	$001C	;001C
	dc.w	$0100	;0100
	dc.w	$D000	;D000
	dc.w	$3301	;3301
	dc.w	$40C8	;40C8
	dc.w	$0003	;0003
	dc.w	$0883	;0883
	dc.w	$CA00	;CA00
	dc.w	$5401	;5401
	dc.w	$435C	;435C
	dc.w	$0053	;0053
	dc.w	$01C3	;01C3
	dc.w	$5C00	;5C00
	dc.w	$2701	;2701
	dc.w	$42EC	;42EC
	dc.w	$0001	;0001
	dc.w	$0902	;0902
	dc.w	$EE00	;EE00
	dc.w	$2D01	;2D01
	dc.w	$422E	;422E
	dc.w	$003E	;003E
	dc.w	$0142	;0142
	dc.w	$B600	;B600
	dc.w	$2D01	;2D01
	dc.w	$46A0	;46A0
	dc.w	$0002	;0002
	dc.w	$03C5	;03C5
	dc.w	$4A00	;4A00
	dc.w	$0405	;0405
	dc.w	$454A	;454A
	dc.w	$0038	;0038
	dc.w	$01C5	;01C5
	dc.w	$A202	;A202
	dc.w	$010A	;010A
	dc.w	$0D01	;0D01
	dc.w	$5201	;5201
	dc.w	$C59E	;C59E
	dc.w	$0101	;0101
	dc.w	$0A0D	;0A0D
	dc.w	$0185	;0185
	dc.w	$9E01	;9E01
	dc.w	$0306	;0306
	dc.w	$1601	;1601
	dc.w	$45C6	;45C6
	dc.w	$0103	;0103
	dc.w	$0515	;0515
	dc.w	$0146	;0146
	dc.w	$4600	;4600
	dc.w	$3001	;3001
	dc.w	$0646	;0646
	dc.w	$0102	;0102
	dc.w	$0216	;0216
	dc.w	$0106	;0106
	dc.w	$2200	;2200
	dc.w	$0305	;0305
	dc.w	$866A	;866A
	dc.w	$0055	;0055
	dc.w	$0147	;0147
	dc.w	$0A00	;0A00
	dc.w	$1D01	;1D01
	dc.w	$070A	;070A
	dc.w	$0059	;0059
	dc.w	$0106	;0106
	dc.w	$3800	;3800
	dc.w	$5101	;5101
	dc.w	$0564	;0564
	dc.w	$0002	;0002
	dc.w	$0385	;0385
	dc.w	$3A00	;3A00
	dc.w	$3201	;3201
	dc.w	$4542	;4542
	dc.w	$0039	;0039
	dc.w	$01C5	;01C5
	dc.w	$4200	;4200
	dc.w	$0105	;0105
	dc.w	$C7F0	;C7F0
	dc.w	$002C	;002C
	dc.w	$0107	;0107
	dc.w	$7E01	;7E01
	dc.w	$5101	;5101
	dc.w	$0D01	;0D01
	dc.w	$8808	;8808
	dc.w	$0002	;0002
	dc.w	$0288	;0288
	dc.w	$7A00	;7A00
	dc.w	$0105	;0105
	dc.w	$C908	;C908
	dc.w	$0003	;0003
	dc.w	$0609	;0609
	dc.w	$2C00	;2C00
	dc.w	$0105	;0105
	dc.w	$C92A	;C92A
	dc.w	$002D	;002D
	dc.w	$0188	;0188
	dc.w	$7200	;7200
	dc.w	$5301	;5301
	dc.w	$87E8	;87E8
	dc.w	$0001	;0001
	dc.w	$0248	;0248
	dc.w	$0A00	;0A00
	dc.w	$0202	;0202
	dc.w	$C7E8	;C7E8
	dc.w	$0003	;0003
	dc.w	$0208	;0208
	dc.w	$0A00	;0A00
	dc.w	$0401	;0401
	dc.w	$C7A8	;C7A8
	dc.w	$0034	;0034
	dc.w	$0107	;0107
	dc.w	$5400	;5400
	dc.w	$2501	;2501
	dc.w	$03FE	;03FE
	dc.w	$0150	;0150
	dc.w	$010D	;010D
	dc.w	$0142	;0142
	dc.w	$4E00	;4E00
	dc.w	$5401	;5401
	dc.w	$42A4	;42A4
	dc.w	$0017	;0017
	dc.w	$0101	;0101
	dc.w	$4C01	;4C01
	dc.w	$3401	;3401
	dc.w	$1501	;1501
	dc.w	$03F4	;03F4
	dc.w	$0004	;0004
	dc.w	$0A83	;0A83
	dc.w	$F400	;F400
	dc.w	$5E01	;5E01
	dc.w	$C3F2	;C3F2
	dc.w	$0003	;0003
	dc.w	$0147	;0147
	dc.w	$9C00	;9C00
	dc.w	$3801	;3801
	dc.w	$8408	;8408
	dc.w	$0001	;0001
	dc.w	$0644	;0644
	dc.w	$0600	;0600
	dc.w	$0201	;0201
	dc.w	$C560	;C560
	dc.w	$0155	;0155
	dc.w	$0115	;0115
	dc.w	$0145	;0145
	dc.w	$1C01	;1C01
	dc.w	$2701	;2701
	dc.w	$0701	;0701
	dc.w	$058A	;058A
	dc.w	$0101	;0101
	dc.w	$080D	;080D
	dc.w	$0145	;0145
	dc.w	$0E00	;0E00
	dc.w	$1A01	;1A01
	dc.w	$8544	;8544
	dc.w	$001A	;001A
	dc.w	$0143	;0143
	dc.w	$FE00	;FE00
	dc.w	$1801	;1801
	dc.w	$045E	;045E
	dc.w	$0001	;0001
	dc.w	$09C4	;09C4
	dc.w	$3400	;3400
	dc.w	$0206	;0206
	dc.w	$8888	;8888
	dc.w	$0104	;0104
	dc.w	$0A15	;0A15
	dc.w	$01CA	;01CA
	dc.w	$C601	;C601
	dc.w	$0104	;0104
	dc.w	$0A01	;0A01
	dc.w	$09A6	;09A6
	dc.w	$0002	;0002
	dc.w	$0289	;0289
	dc.w	$8601	;8601
	dc.w	$5001	;5001
	dc.w	$1501	;1501
	dc.w	$8A08	;8A08
	dc.w	$0002	;0002
	dc.w	$074B	;074B
	dc.w	$2400	;2400
	dc.w	$1E01	;1E01
	dc.w	$0AEE	;0AEE
	dc.w	$0051	;0051
	dc.w	$018F	;018F
	dc.w	$9800	;9800
	dc.w	$0304	;0304
	dc.w	$0FA6	;0FA6
	dc.w	$0001	;0001
	dc.w	$044F	;044F
	dc.w	$4C00	;4C00
	dc.w	$040A	;040A
	dc.w	$4D18	;4D18
	dc.w	$0052	;0052
	dc.w	$014D	;014D
	dc.w	$3A00	;3A00
	dc.w	$5201	;5201
	dc.w	$CD1E	;CD1E
	dc.w	$002E	;002E
	dc.w	$014D	;014D
	dc.w	$1C00	;1C00
	dc.w	$1F01	;1F01
	dc.w	$4DFC	;4DFC
	dc.w	$0003	;0003
	dc.w	$088E	;088E
	dc.w	$4800	;4800
	dc.w	$0308	;0308
	dc.w	$8E00	;8E00
	dc.w	$0051	;0051
	dc.w	$014B	;014B
	dc.w	$E600	;E600
	dc.w	$0406	;0406
	dc.w	$CBE6	;CBE6
	dc.w	$0001	;0001
	dc.w	$024C	;024C
	dc.w	$0600	;0600
	dc.w	$0303	;0303
	dc.w	$0C06	;0C06
	dc.w	$0002	;0002
	dc.w	$048C	;048C
	dc.w	$2800	;2800
	dc.w	$0406	;0406
	dc.w	$CC26	;CC26
	dc.w	$0002	;0002
	dc.w	$020C	;020C
	dc.w	$4400	;4400
	dc.w	$0305	;0305
	dc.w	$4C3C	;4C3C
	dc.w	$0152	;0152
	dc.w	$011F	;011F
	dc.w	$014B	;014B
	dc.w	$4200	;4200
	dc.w	$5001	;5001
	dc.w	$4C54	;4C54
	dc.w	$002E	;002E
	dc.w	$01C2	;01C2
	dc.w	$8C00	;8C00
	dc.w	$5001	;5001
	dc.w	$826C	;826C
	dc.w	$0007	;0007
	dc.w	$0102	;0102
	dc.w	$6C00	;6C00
	dc.w	$0D01	;0D01
	dc.w	$87F0	;87F0
	dc.w	$010A	;010A
	dc.w	$010D	;010D
	dc.w	$0148	;0148
	dc.w	$7600	;7600
	dc.w	$0D01	;0D01
	dc.w	$C876	;C876
	dc.w	$0007	;0007
	dc.w	$01C2	;01C2
	dc.w	$0A02	;0A02
	dc.w	$0206	;0206
	dc.w	$0A01	;0A01
	dc.w	$0701	;0701
	dc.w	$07DA	;07DA
	dc.w	$0003	;0003
	dc.w	$0389	;0389
	dc.w	$2C00	;2C00
	dc.w	$0701	;0701
	dc.w	$0130	;0130
	dc.w	$010A	;010A
	dc.w	$0117	;0117
	dc.w	$0181	;0181
	dc.w	$3001	;3001
	dc.w	$0701	;0701
	dc.w	$1901	;1901
	dc.w	$893E	;893E
	dc.w	$000D	;000D
	dc.w	$01C3	;01C3
	dc.w	$7A01	;7A01
	dc.w	$0701	;0701
	dc.w	$0D01	;0D01
	dc.w	$837A	;837A
	dc.w	$0034	;0034
	dc.w	$0104	;0104
	dc.w	$4401	;4401
	dc.w	$0A01	;0A01
	dc.w	$5201	;5201
	dc.w	$461A	;461A
	dc.w	$0207	;0207
	dc.w	$010A	;010A
	dc.w	$011E	;011E
	dc.w	$0141	;0141
	dc.w	$5400	;5400
	dc.w	$1E01	;1E01
	dc.w	$064A	;064A
	dc.w	$010A	;010A
	dc.w	$0104	;0104
	dc.w	$0802	;0802
	dc.w	$A401	;A401
	dc.w	$1601	;1601
	dc.w	$1901	;1901
	dc.w	$8622	;8622
	dc.w	$0107	;0107
	dc.w	$0124	;0124
	dc.w	$0185	;0185
	dc.w	$CE01	;CE01
	dc.w	$1501	;1501
	dc.w	$1801	;1801
	dc.w	$4A96	;4A96
	dc.w	$0125	;0125
	dc.w	$010A	;010A
	dc.w	$018C	;018C
	dc.w	$8A02	;8A02
	dc.w	$1601	;1601
	dc.w	$1501	;1501
	dc.w	$0A01	;0A01
	dc.w	$CC8A	;CC8A
	dc.w	$0214	;0214
	dc.w	$0116	;0116
	dc.w	$010A	;010A
	dc.w	$010C	;010C
	dc.w	$7E03	;7E03
	dc.w	$1502	;1502
	dc.w	$0D02	;0D02
	dc.w	$1402	;1402
	dc.w	$1602	;1602
	dc.w	$0792	;0792
	dc.w	$000A	;000A
	dc.w	$01C4	;01C4
	dc.w	$1001	;1001
	dc.w	$1601	;1601
	dc.w	$1D01	;1D01
	dc.w	$48F0	;48F0
	dc.w	$0015	;0015
	dc.w	$01C9	;01C9
	dc.w	$5A00	;5A00
	dc.w	$0D01	;0D01
	dc.w	$C9BC	;C9BC
	dc.w	$0015	;0015
	dc.w	$010B	;010B
	dc.w	$0A00	;0A00
	dc.w	$0D01	;0D01
	dc.w	$0CBA	;0CBA
	dc.w	$0056	;0056
	dc.w	$010D	;010D
	dc.w	$9402	;9402
	dc.w	$5501	;5501
	dc.w	$5601	;5601
	dc.w	$1701	;1701
	dc.w	$060A	;060A
	dc.w	$0104	;0104
	dc.w	$0307	;0307
	dc.w	$0186	;0186
	dc.w	$0A02	;0A02
	dc.w	$030D	;030D
	dc.w	$5701	;5701
	dc.w	$2D01	;2D01
	dc.w	$482A	;482A
	dc.w	$000A	;000A
	dc.w	$0108	;0108
	dc.w	$2A00	;2A00
	dc.w	$3301	;3301
	dc.w	$C822	;C822
	dc.w	$000A	;000A
	dc.w	$01CB	;01CB
	dc.w	$1001	;1001
	dc.w	$5301	;5301
	dc.w	$0A01	;0A01
	dc.w	$CA9C	;CA9C
	dc.w	$0115	;0115
	dc.w	$011E	;011E
	dc.w	$014A	;014A
	dc.w	$0E00	;0E00
	dc.w	$0701	;0701
	dc.w	$09EC	;09EC
	dc.w	$000D	;000D
	dc.w	$0100	;0100
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
MaoData3:
	dc.w	$0515	;0515
	dc.w	$1513	;1513
	dc.w	$1311	;1311
	dc.w	$0900	;0900
	dc.w	$0915	;0915
	dc.w	$1513	;1513
	dc.w	$1311	;1311
	dc.w	$0900	;0900
	dc.w	$0000	;0000
	dc.w	$005A	;005A
	dc.w	$03CC	;03CC
	dc.w	$073E	;073E
	dc.w	$0A10	;0A10
	dc.w	$0CE2	;0CE2
	dc.w	$0F24	;0F24
	dc.w	$0000	;0000
	dc.w	$0800	;0800
	dc.w	$0001	;0001
	dc.w	$0102	;0102
	dc.w	$0600	;0600
	dc.w	$0003	;0003
	dc.w	$0304	;0304
	dc.w	$0405	;0405
	dc.w	$0900	;0900
	dc.w	$0013	;0013
	dc.w	$0013	;0013
	dc.w	$073E	;073E
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0905	;0905
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$C206	;C206
	dc.w	$CA06	;CA06
	dc.w	$D206	;D206
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$0105	;0105
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0D81	;0D81
	dc.w	$0D81	;0D81
	dc.w	$0D81	;0D81
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0004	;0004
	dc.w	$0001	;0001
	dc.w	$0004	;0004
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0105	;0105
	dc.w	$0001	;0001
	dc.w	$2F81	;2F81
	dc.w	$00A1	;00A1
	dc.w	$0001	;0001
	dc.w	$1002	;1002
	dc.w	$3002	;3002
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$4302	;4302
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$3F81	;3F81
	dc.w	$0001	;0001
	dc.w	$0105	;0105
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0706	;0706
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C112	;C112
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0004	;0004
	dc.w	$0001	;0001
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0004	;0004
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0515	;0515
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0515	;0515
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0702	;0702
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$00A1	;00A1
	dc.w	$00A1	;00A1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0102	;0102
	dc.w	$19A1	;19A1
	dc.w	$00A1	;00A1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0305	;0305
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0402	;0402
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0003	;0003
	dc.w	$0001	;0001
	dc.w	$0706	;0706
	dc.w	$0001	;0001
	dc.w	$0302	;0302
	dc.w	$1B06	;1B06
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0001	;0001
	dc.w	$0181	;0181
	dc.w	$0305	;0305
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0181	;0181
	dc.w	$0504	;0504
	dc.w	$0001	;0001
	dc.w	$0504	;0504
	dc.w	$0001	;0001
	dc.w	$0402	;0402
	dc.w	$0003	;0003
	dc.w	$4302	;4302
	dc.w	$0003	;0003
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$3402	;3402
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0D91	;0D91
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0DB1	;0DB1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$01A1	;01A1
	dc.w	$0105	;0105
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0706	;0706
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$2115	;2115
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$19A1	;19A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$11B1	;11B1
	dc.w	$02A1	;02A1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4302	;4302
	dc.w	$1B06	;1B06
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$2306	;2306
	dc.w	$0505	;0505
	dc.w	$2A06	;2A06
	dc.w	$02B1	;02B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$11B1	;11B1
	dc.w	$0281	;0281
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0D91	;0D91
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0DB1	;0DB1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0207	;0207
	dc.w	$0207	;0207
	dc.w	$0207	;0207
	dc.w	$0207	;0207
	dc.w	$0207	;0207
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0D12	;0D12
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0312	;0312
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0D81	;0D81
	dc.w	$3F81	;3F81
	dc.w	$1581	;1581
	dc.w	$2F81	;2F81
	dc.w	$0D81	;0D81
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
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
	dc.w	$3715	;3715
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
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0105	;0105
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$BA06	;BA06
	dc.w	$0006	;0006
	dc.w	$0106	;0106
	dc.w	$0006	;0006
	dc.w	$A206	;A206
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0302	;0302
	dc.w	$00B1	;00B1
	dc.w	$0302	;0302
	dc.w	$0302	;0302
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0003	;0003
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$AA06	;AA06
	dc.w	$0B06	;0B06
	dc.w	$B206	;B206
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0081	;0081
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0305	;0305
	dc.w	$0001	;0001
	dc.w	$0504	;0504
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$9B06	;9B06
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0504	;0504
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$D002	;D002
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0106	;0106
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0105	;0105
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$5002	;5002
	dc.w	$3002	;3002
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0181	;0181
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0181	;0181
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0705	;0705
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0081	;0081
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0081	;0081
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$2191	;2191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0505	;0505
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$1D81	;1D81
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4002	;4002
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0705	;0705
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0106	;0106
	dc.w	$0001	;0001
	dc.w	$3002	;3002
	dc.w	$0001	;0001
	dc.w	$0003	;0003
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$01A1	;01A1
	dc.w	$0103	;0103
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0081	;0081
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0305	;0305
	dc.w	$0001	;0001
	dc.w	$0305	;0305
	dc.w	$01A1	;01A1
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$7012	;7012
	dc.w	$1002	;1002
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0302	;0302
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$3115	;3115
	dc.w	$0001	;0001
	dc.w	$3002	;3002
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$1115	;1115
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0404	;0404
	dc.w	$0081	;0081
	dc.w	$0404	;0404
	dc.w	$0001	;0001
	dc.w	$6315	;6315
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$0181	;0181
	dc.w	$0103	;0103
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0003	;0003
	dc.w	$0001	;0001
	dc.w	$0D02	;0D02
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$2715	;2715
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$C012	;C012
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0003	;0003
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0302	;0302
	dc.w	$0102	;0102
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$0302	;0302
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$00A1	;00A1
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0081	;0081
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3412	;3412
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$6515	;6515
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0705	;0705
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0081	;0081
	dc.w	$0081	;0081
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$1402	;1402
	dc.w	$0000	;0000
	dc.w	$1002	;1002
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$4306	;4306
	dc.w	$4306	;4306
	dc.w	$4306	;4306
	dc.w	$4306	;4306
	dc.w	$3206	;3206
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0406	;0406
	dc.w	$0006	;0006
	dc.w	$1315	;1315
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$4306	;4306
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$4306	;4306
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$3A06	;3A06
	dc.w	$4306	;4306
	dc.w	$8306	;8306
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0081	;0081
	dc.w	$3012	;3012
	dc.w	$0001	;0001
	dc.w	$3002	;3002
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3515	;3515
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$4306	;4306
	dc.w	$0006	;0006
	dc.w	$4306	;4306
	dc.w	$4306	;4306
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0302	;0302
	dc.w	$0102	;0102
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$2591	;2591
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0102	;0102
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$00A1	;00A1
	dc.w	$0001	;0001
	dc.w	$0104	;0104
	dc.w	$0001	;0001
	dc.w	$0104	;0104
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0404	;0404
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0302	;0302
	dc.w	$0102	;0102
	dc.w	$0102	;0102
	dc.w	$29B1	;29B1
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$0081	;0081
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4A06	;4A06
	dc.w	$0000	;0000
	dc.w	$5206	;5206
	dc.w	$0000	;0000
	dc.w	$5A06	;5A06
	dc.w	$0000	;0000
	dc.w	$6206	;6206
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
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
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0A91	;0A91
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0D05	;0D05
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$22B1	;22B1
	dc.w	$2002	;2002
	dc.w	$00A1	;00A1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0103	;0103
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$3315	;3315
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$C002	;C002
	dc.w	$0103	;0103
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$2DB1	;2DB1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0004	;0004
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$11A1	;11A1
	dc.w	$0081	;0081
	dc.w	$02A1	;02A1
	dc.w	$0001	;0001
	dc.w	$7206	;7206
	dc.w	$0106	;0106
	dc.w	$6A06	;6A06
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$7B06	;7B06
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$12A1	;12A1
	dc.w	$0000	;0000
	dc.w	$0DB1	;0DB1
	dc.w	$2306	;2306
	dc.w	$0505	;0505
	dc.w	$2A06	;2A06
	dc.w	$02B1	;02B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0102	;0102
	dc.w	$0302	;0302
	dc.w	$0000	;0000
	dc.w	$6515	;6515
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0F05	;0F05
	dc.w	$3002	;3002
	dc.w	$11B1	;11B1
	dc.w	$0281	;0281
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$3002	;3002
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0102	;0102
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0502	;0502
	dc.w	$0003	;0003
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C002	;C002
	dc.w	$0001	;0001
	dc.w	$9306	;9306
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0F06	;0F06
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$8B06	;8B06
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C002	;C002
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$C002	;C002
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$00A1	;00A1
	dc.w	$0001	;0001
	dc.w	$0B05	;0B05
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0B05	;0B05
	dc.w	$0081	;0081
	dc.w	$01A1	;01A1
	dc.w	$3102	;3102
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$00A1	;00A1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$4302	;4302
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0104	;0104
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3002	;3002
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0003	;0003
	dc.w	$0001	;0001
	dc.w	$0003	;0003
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$5515	;5515
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$00A1	;00A1
	dc.w	$0003	;0003
	dc.w	$0001	;0001
	dc.w	$0305	;0305
	dc.w	$0001	;0001
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0305	;0305
	dc.w	$0181	;0181
	dc.w	$01A1	;01A1
	dc.w	$1315	;1315
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$01A1	;01A1
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$5002	;5002
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
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
	dc.w	$4515	;4515
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
	dc.w	$C012	;C012
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
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C012	;C012
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0207	;0207
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0207	;0207
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$2A81	;2A81
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0504	;0504
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1515	;1515
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0207	;0207
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0191	;0191
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$3191	;3191
	dc.w	$0000	;0000
	dc.w	$0705	;0705
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$2115	;2115
	dc.w	$0000	;0000
	dc.w	$0505	;0505
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0207	;0207
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0106	;0106
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0404	;0404
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0207	;0207
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0003	;0003
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$2315	;2315
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0207	;0207
	dc.w	$1002	;1002
	dc.w	$00B1	;00B1
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$C002	;C002
	dc.w	$4D02	;4D02
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$3281	;3281
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$00B1	;00B1
	dc.w	$0081	;0081
	dc.w	$0001	;0001
	dc.w	$0402	;0402
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0191	;0191
	dc.w	$0006	;0006
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0302	;0302
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0705	;0705
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0402	;0402
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0D91	;0D91
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0505	;0505
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$4291	;4291
	dc.w	$0207	;0207
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0D91	;0D91
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0DB1	;0DB1
	dc.w	$0DA1	;0DA1
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0103	;0103
	dc.w	$0DA1	;0DA1
	dc.w	$0D91	;0D91
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$6715	;6715
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0207	;0207
	dc.w	$0000	;0000
	dc.w	$1BB1	;1BB1
	dc.w	$0207	;0207
	dc.w	$0DB1	;0DB1
	dc.w	$0104	;0104
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0103	;0103
	dc.w	$0D81	;0D81
	dc.w	$0D91	;0D91
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0D91	;0D91
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3A91	;3A91
	dc.w	$0207	;0207
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0505	;0505
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0D91	;0D91
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
ObjectData_3:
	dc.w	$02B6	;02B6

	dc.w	$4028	;4028
	dc.w	$000A	;000A
	dc.w	$0180	;0180
	dc.w	$3000	;3000
	dc.w	$0D01	;0D01
	dc.w	$C028	;C028
	dc.w	$0014	;0014
	dc.w	$0100	;0100
	dc.w	$3000	;3000
	dc.w	$1301	;1301
	dc.w	$0176	;0176
	dc.w	$0103	;0103
	dc.w	$0C34	;0C34
	dc.w	$0141	;0141
	dc.w	$C600	;C600
	dc.w	$5101	;5101
	dc.w	$C148	;C148
	dc.w	$0001	;0001
	dc.w	$0A01	;0A01
	dc.w	$7200	;7200
	dc.w	$0204	;0204
	dc.w	$019C	;019C
	dc.w	$003E	;003E
	dc.w	$0182	;0182
	dc.w	$4A00	;4A00
	dc.w	$0302	;0302
	dc.w	$0156	;0156
	dc.w	$0003	;0003
	dc.w	$0C81	;0C81
	dc.w	$2C00	;2C00
	dc.w	$0202	;0202
	dc.w	$82B0	;82B0
	dc.w	$0001	;0001
	dc.w	$0883	;0883
	dc.w	$B600	;B600
	dc.w	$2801	;2801
	dc.w	$0064	;0064
	dc.w	$0013	;0013
	dc.w	$01C0	;01C0
	dc.w	$6200	;6200
	dc.w	$0D01	;0D01
	dc.w	$4078	;4078
	dc.w	$0007	;0007
	dc.w	$0104	;0104
	dc.w	$D400	;D400
	dc.w	$0306	;0306
	dc.w	$447E	;447E
	dc.w	$0001	;0001
	dc.w	$0505	;0505
	dc.w	$5401	;5401
	dc.w	$3001	;3001
	dc.w	$0D01	;0D01
	dc.w	$84BA	;84BA
	dc.w	$0001	;0001
	dc.w	$0344	;0344
	dc.w	$B800	;B800
	dc.w	$0205	;0205
	dc.w	$05B8	;05B8
	dc.w	$0052	;0052
	dc.w	$0105	;0105
	dc.w	$BA00	;BA00
	dc.w	$6C01	;6C01
	dc.w	$45E2	;45E2
	dc.w	$0015	;0015
	dc.w	$0184	;0184
	dc.w	$7400	;7400
	dc.w	$0204	;0204
	dc.w	$C478	;C478
	dc.w	$0001	;0001
	dc.w	$0585	;0585
	dc.w	$9A00	;9A00
	dc.w	$0105	;0105
	dc.w	$45B8	;45B8
	dc.w	$001E	;001E
	dc.w	$0185	;0185
	dc.w	$D800	;D800
	dc.w	$5001	;5001
	dc.w	$C6EA	;C6EA
	dc.w	$0052	;0052
	dc.w	$0186	;0186
	dc.w	$2001	;2001
	dc.w	$5101	;5101
	dc.w	$010A	;010A
	dc.w	$C6C0	;C6C0
	dc.w	$0019	;0019
	dc.w	$0147	;0147
	dc.w	$2C00	;2C00
	dc.w	$5501	;5501
	dc.w	$C72C	;C72C
	dc.w	$0014	;0014
	dc.w	$0147	;0147
	dc.w	$0400	;0400
	dc.w	$0104	;0104
	dc.w	$C72E	;C72E
	dc.w	$002E	;002E
	dc.w	$01C5	;01C5
	dc.w	$8C00	;8C00
	dc.w	$1F01	;1F01
	dc.w	$068C	;068C
	dc.w	$0003	;0003
	dc.w	$0746	;0746
	dc.w	$8C00	;8C00
	dc.w	$3901	;3901
	dc.w	$C7A2	;C7A2
	dc.w	$010D	;010D
	dc.w	$0116	;0116
	dc.w	$0148	;0148
	dc.w	$1200	;1200
	dc.w	$1001	;1001
	dc.w	$0812	;0812
	dc.w	$0255	;0255
	dc.w	$0104	;0104
	dc.w	$0F0A	;0F0A
	dc.w	$0187	;0187
	dc.w	$A003	;A003
	dc.w	$1A01	;1A01
	dc.w	$1501	;1501
	dc.w	$1601	;1601
	dc.w	$0D01	;0D01
	dc.w	$877C	;877C
	dc.w	$0002	;0002
	dc.w	$0407	;0407
	dc.w	$7C00	;7C00
	dc.w	$010A	;010A
	dc.w	$073E	;073E
	dc.w	$0002	;0002
	dc.w	$0748	;0748
	dc.w	$2600	;2600
	dc.w	$5001	;5001
	dc.w	$8908	;8908
	dc.w	$0052	;0052
	dc.w	$01C9	;01C9
	dc.w	$4400	;4400
	dc.w	$1501	;1501
	dc.w	$496A	;496A
	dc.w	$0103	;0103
	dc.w	$0D04	;0D04
	dc.w	$0A88	;0A88
	dc.w	$C401	;C401
	dc.w	$030A	;030A
	dc.w	$0205	;0205
	dc.w	$C8F0	;C8F0
	dc.w	$0001	;0001
	dc.w	$028A	;028A
	dc.w	$0C00	;0C00
	dc.w	$5E01	;5E01
	dc.w	$4C88	;4C88
	dc.w	$0053	;0053
	dc.w	$01CC	;01CC
	dc.w	$1E00	;1E00
	dc.w	$0204	;0204
	dc.w	$CBC6	;CBC6
	dc.w	$000A	;000A
	dc.w	$01CB	;01CB
	dc.w	$C400	;C400
	dc.w	$1001	;1001
	dc.w	$0C2C	;0C2C
	dc.w	$0050	;0050
	dc.w	$018C	;018C
	dc.w	$2C00	;2C00
	dc.w	$3A01	;3A01
	dc.w	$8B7C	;8B7C
	dc.w	$0054	;0054
	dc.w	$014B	;014B
	dc.w	$9200	;9200
	dc.w	$2801	;2801
	dc.w	$CCB8	;CCB8
	dc.w	$0028	;0028
	dc.w	$010C	;010C
	dc.w	$9C00	;9C00
	dc.w	$0D01	;0D01
	dc.w	$4BD8	;4BD8
	dc.w	$0001	;0001
	dc.w	$078B	;078B
	dc.w	$B200	;B200
	dc.w	$0307	;0307
	dc.w	$8A3C	;8A3C
	dc.w	$005A	;005A
	dc.w	$014A	;014A
	dc.w	$3800	;3800
	dc.w	$0D01	;0D01
	dc.w	$CA38	;CA38
	dc.w	$0001	;0001
	dc.w	$0A8A	;0A8A
	dc.w	$7200	;7200
	dc.w	$1801	;1801
	dc.w	$4A48	;4A48
	dc.w	$0055	;0055
	dc.w	$014A	;014A
	dc.w	$DC01	;DC01
	dc.w	$5201	;5201
	dc.w	$0204	;0204
	dc.w	$CB70	;CB70
	dc.w	$0019	;0019
	dc.w	$010A	;010A
	dc.w	$2800	;2800
	dc.w	$0206	;0206
	dc.w	$8ED0	;8ED0
	dc.w	$0035	;0035
	dc.w	$010E	;010E
	dc.w	$D200	;D200
	dc.w	$3101	;3101
	dc.w	$4D50	;4D50
	dc.w	$0051	;0051
	dc.w	$010E	;010E
	dc.w	$C600	;C600
	dc.w	$0701	;0701
	dc.w	$CEC4	;CEC4
	dc.w	$0020	;0020
	dc.w	$018F	;018F
	dc.w	$0600	;0600
	dc.w	$1A01	;1A01
	dc.w	$CEE2	;CEE2
	dc.w	$0003	;0003
	dc.w	$04CE	;04CE
	dc.w	$7E00	;7E00
	dc.w	$0106	;0106
	dc.w	$4F04	;4F04
	dc.w	$0050	;0050
	dc.w	$010D	;010D
	dc.w	$C400	;C400
	dc.w	$1701	;1701
	dc.w	$4D42	;4D42
	dc.w	$0151	;0151
	dc.w	$0102	;0102
	dc.w	$03CE	;03CE
	dc.w	$FA00	;FA00
	dc.w	$5501	;5501
	dc.w	$8F22	;8F22
	dc.w	$0410	;0410
	dc.w	$0116	;0116
	dc.w	$0114	;0114
	dc.w	$010A	;010A
	dc.w	$0115	;0115
	dc.w	$010F	;010F
	dc.w	$4004	;4004
	dc.w	$010A	;010A
	dc.w	$030A	;030A
	dc.w	$040A	;040A
	dc.w	$0A01	;0A01
	dc.w	$1501	;1501
	dc.w	$CD42	;CD42
	dc.w	$0001	;0001
	dc.w	$0A8F	;0A8F
	dc.w	$8E02	;8E02
	dc.w	$010A	;010A
	dc.w	$040A	;040A
	dc.w	$1401	;1401
	dc.w	$03B6	;03B6
	dc.w	$013A	;013A
	dc.w	$012E	;012E
	dc.w	$0143	;0143
	dc.w	$B801	;B801
	dc.w	$3A01	;3A01
	dc.w	$2E01	;2E01
	dc.w	$0228	;0228
	dc.w	$0104	;0104
	dc.w	$0F3E	;0F3E
	dc.w	$0143	;0143
	dc.w	$9E00	;9E00
	dc.w	$040F	;040F
	dc.w	$00DC	;00DC
	dc.w	$0030	;0030
	dc.w	$0104	;0104
	dc.w	$5400	;5400
	dc.w	$1E01	;1E01
	dc.w	$0814	;0814
	dc.w	$0113	;0113
	dc.w	$0115	;0115
	dc.w	$0148	;0148
	dc.w	$1401	;1401
	dc.w	$0701	;0701
	dc.w	$1601	;1601
	dc.w	$088A	;088A
	dc.w	$0316	;0316
	dc.w	$0115	;0115
	dc.w	$0114	;0114
	dc.w	$0117	;0117
	dc.w	$01C7	;01C7
	dc.w	$A001	;A001
	dc.w	$0701	;0701
	dc.w	$0A01	;0A01
	dc.w	$87A2	;87A2
	dc.w	$0104	;0104
	dc.w	$0F18	;0F18
	dc.w	$0108	;0108
	dc.w	$EA00	;EA00
	dc.w	$2E01	;2E01
	dc.w	$C8C4	;C8C4
	dc.w	$010A	;010A
	dc.w	$010D	;010D
	dc.w	$0107	;0107
	dc.w	$C201	;C201
	dc.w	$0105	;0105
	dc.w	$040A	;040A
	dc.w	$49F8	;49F8
	dc.w	$0104	;0104
	dc.w	$0A3A	;0A3A
	dc.w	$014A	;014A
	dc.w	$0A00	;0A00
	dc.w	$040A	;040A
	dc.w	$09C2	;09C2
	dc.w	$0215	;0215
	dc.w	$010D	;010D
	dc.w	$011F	;011F
	dc.w	$01CD	;01CD
	dc.w	$2A00	;2A00
	dc.w	$2001	;2001
	dc.w	$0F5C	;0F5C
	dc.w	$0315	;0315
	dc.w	$0207	;0207
	dc.w	$010D	;010D
	dc.w	$0204	;0204
	dc.w	$0A4F	;0A4F
	dc.w	$5C03	;5C03
	dc.w	$0D01	;0D01
	dc.w	$0701	;0701
	dc.w	$1601	;1601
	dc.w	$1501	;1501
	dc.w	$CF80	;CF80
	dc.w	$0304	;0304
	dc.w	$0A16	;0A16
	dc.w	$0115	;0115
	dc.w	$0107	;0107
	dc.w	$018F	;018F
	dc.w	$8004	;8004
	dc.w	$0D01	;0D01
	dc.w	$0A01	;0A01
	dc.w	$0701	;0701
	dc.w	$1501	;1501
	dc.w	$1601	;1601
	dc.w	$C3B8	;C3B8
	dc.w	$0028	;0028
	dc.w	$01C1	;01C1
	dc.w	$3A00	;3A00
	dc.w	$3901	;3901
	dc.w	$8E4C	;8E4C
	dc.w	$0004	;0004
	dc.w	$05CE	;05CE
	dc.w	$4C00	;4C00
	dc.w	$5401	;5401
	dc.w	$0796	;0796
	dc.w	$0101	;0101
	dc.w	$0A3D	;0A3D
	dc.w	$0188	;0188
	dc.w	$0400	;0400
	dc.w	$5801	;5801
	dc.w	$8804	;8804
	dc.w	$0058	;0058
	dc.w	$0158	;0158
	dc.w	$0100	;0100
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
MapData4:
	dc.w	$091B	;091B
	dc.w	$1311	;1311
	dc.w	$110D	;110D
	dc.w	$0B03	;0B03
	dc.w	$051B	;051B
	dc.w	$1311	;1311
	dc.w	$110D	;110D
	dc.w	$0B05	;0B05
	dc.w	$0000	;0000
	dc.w	$005A	;005A
	dc.w	$060C	;060C
	dc.w	$08DE	;08DE
	dc.w	$0B20	;0B20
	dc.w	$0D62	;0D62
	dc.w	$0EB4	;0EB4
	dc.w	$0FA6	;0FA6
	dc.w	$0003	;0003
	dc.w	$0708	;0708
	dc.w	$080A	;080A
	dc.w	$0B0F	;0B0F
	dc.w	$0B00	;0B00
	dc.w	$0405	;0405
	dc.w	$0507	;0507
	dc.w	$080B	;080B
	dc.w	$0003	;0003
	dc.w	$0005	;0005
	dc.w	$0FA6	;0FA6
	dc.w	$0007	;0007
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$09A1	;09A1
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0404	;0404
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$AA06	;AA06
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0D05	;0D05
	dc.w	$B206	;B206
	dc.w	$0505	;0505
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$09B1	;09B1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$BA06	;BA06
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0981	;0981
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0004	;0004
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0003	;0003
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$C012	;C012
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0312	;0312
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0102	;0102
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$1306	;1306
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$3012	;3012
	dc.w	$1002	;1002
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0705	;0705
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$8B06	;8B06
	dc.w	$0000	;0000
	dc.w	$1302	;1302
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$00A1	;00A1
	dc.w	$0003	;0003
	dc.w	$3002	;3002
	dc.w	$09A1	;09A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C002	;C002
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$3012	;3012
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0B06	;0B06
	dc.w	$0991	;0991
	dc.w	$0000	;0000
	dc.w	$0102	;0102
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$09B1	;09B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0712	;0712
	dc.w	$0000	;0000
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$9306	;9306
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0305	;0305
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0104	;0104
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$5715	;5715
	dc.w	$0000	;0000
	dc.w	$19B1	;19B1
	dc.w	$0001	;0001
	dc.w	$0004	;0004
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0207	;0207
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0102	;0102
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0102	;0102
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$1002	;1002
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$11B1	;11B1
	dc.w	$02A1	;02A1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$09B1	;09B1
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0102	;0102
	dc.w	$0000	;0000
	dc.w	$0102	;0102
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$2306	;2306
	dc.w	$0505	;0505
	dc.w	$2A06	;2A06
	dc.w	$02B1	;02B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0705	;0705
	dc.w	$0000	;0000
	dc.w	$1DB1	;1DB1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$01A1	;01A1
	dc.w	$0103	;0103
	dc.w	$09A1	;09A1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0091	;0091
	dc.w	$0302	;0302
	dc.w	$1102	;1102
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$11B1	;11B1
	dc.w	$0281	;0281
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$09B1	;09B1
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4D02	;4D02
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0305	;0305
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0504	;0504
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$1515	;1515
	dc.w	$2715	;2715
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0081	;0081
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3012	;3012
	dc.w	$1002	;1002
	dc.w	$0081	;0081
	dc.w	$0981	;0981
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1002	;1002
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$A306	;A306
	dc.w	$0000	;0000
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0091	;0091
	dc.w	$0302	;0302
	dc.w	$0003	;0003
	dc.w	$0981	;0981
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$9B06	;9B06
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0981	;0981
	dc.w	$0103	;0103
	dc.w	$0081	;0081
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0081	;0081
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0402	;0402
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$3012	;3012
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1402	;1402
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0001	;0001
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$4002	;4002
	dc.w	$3012	;3012
	dc.w	$0001	;0001
	dc.w	$0081	;0081
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0207	;0207
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$09B1	;09B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3515	;3515
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$5515	;5515
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1B06	;1B06
	dc.w	$0181	;0181
	dc.w	$00A1	;00A1
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$00A1	;00A1
	dc.w	$0991	;0991
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$3306	;3306
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1A81	;1A81
	dc.w	$0001	;0001
	dc.w	$0105	;0105
	dc.w	$0001	;0001
	dc.w	$0105	;0105
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0081	;0081
	dc.w	$0105	;0105
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1B06	;1B06
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0504	;0504
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$3002	;3002
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$3306	;3306
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3306	;3306
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0305	;0305
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1B06	;1B06
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$1291	;1291
	dc.w	$0000	;0000
	dc.w	$15B1	;15B1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0A91	;0A91
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$7502	;7502
	dc.w	$3A06	;3A06
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0312	;0312
	dc.w	$0001	;0001
	dc.w	$0312	;0312
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$09A1	;09A1
	dc.w	$6315	;6315
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$D502	;D502
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$1515	;1515
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4102	;4102
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0404	;0404
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0181	;0181
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
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
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0705	;0705
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$5AA1	;5AA1
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$5115	;5115
	dc.w	$0001	;0001
	dc.w	$5115	;5115
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3AB1	;3AB1
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$2315	;2315
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0081	;0081
	dc.w	$0103	;0103
	dc.w	$5306	;5306
	dc.w	$42A1	;42A1
	dc.w	$0000	;0000
	dc.w	$6402	;6402
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$5B06	;5B06
	dc.w	$0000	;0000
	dc.w	$2F81	;2F81
	dc.w	$5306	;5306
	dc.w	$3F81	;3F81
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$4A81	;4A81
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0100	;0100
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$4306	;4306
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$11B1	;11B1
	dc.w	$02A1	;02A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$4A06	;4A06
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$5281	;5281
	dc.w	$0103	;0103
	dc.w	$2306	;2306
	dc.w	$0505	;0505
	dc.w	$2A06	;2A06
	dc.w	$02B1	;02B1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4306	;4306
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$11B1	;11B1
	dc.w	$0281	;0281
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0105	;0105
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$5315	;5315
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0004	;0004
	dc.w	$0001	;0001
	dc.w	$2181	;2181
	dc.w	$0001	;0001
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$00A1	;00A1
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$C002	;C002
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0001	;0001
	dc.w	$0104	;0104
	dc.w	$00A1	;00A1
	dc.w	$3012	;3012
	dc.w	$3012	;3012
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0302	;0302
	dc.w	$0001	;0001
	dc.w	$0302	;0302
	dc.w	$00B1	;00B1
	dc.w	$0003	;0003
	dc.w	$0003	;0003
	dc.w	$0981	;0981
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C002	;C002
	dc.w	$2F81	;2F81
	dc.w	$0003	;0003
	dc.w	$3F81	;3F81
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$D012	;D012
	dc.w	$3012	;3012
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
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3715	;3715
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0C12	;0C12
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0081	;0081
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$01A1	;01A1
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1402	;1402
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0100	;0100
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$3281	;3281
	dc.w	$0B05	;0B05
	dc.w	$0281	;0281
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0004	;0004
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0003	;0003
	dc.w	$0081	;0081
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
	dc.w	$0001	;0001
	dc.w	$25A1	;25A1
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$7B06	;7B06
	dc.w	$6206	;6206
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$00A1	;00A1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
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
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0102	;0102
	dc.w	$0102	;0102
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$2DA1	;2DA1
	dc.w	$00A1	;00A1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$22B1	;22B1
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$1002	;1002
	dc.w	$0001	;0001
	dc.w	$1002	;1002
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$8306	;8306
	dc.w	$2A91	;2A91
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0504	;0504
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$1315	;1315
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4102	;4102
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0003	;0003
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C012	;C012
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
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
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$6515	;6515
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
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0504	;0504
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4202	;4202
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$3002	;3002
	dc.w	$1002	;1002
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0105	;0105
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0004	;0004
	dc.w	$0001	;0001
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0705	;0705
	dc.w	$0000	;0000
	dc.w	$0B06	;0B06
	dc.w	$0000	;0000
	dc.w	$5715	;5715
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0181	;0181
	dc.w	$0081	;0081
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$00A1	;00A1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0C12	;0C12
	dc.w	$0C12	;0C12
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$2981	;2981
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$09B1	;09B1
	dc.w	$0006	;0006
	dc.w	$0081	;0081
	dc.w	$0006	;0006
	dc.w	$0991	;0991
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3115	;3115
	dc.w	$0981	;0981
	dc.w	$0081	;0081
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0081	;0081
	dc.w	$0981	;0981
	dc.w	$6115	;6115
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0604	;0604
	dc.w	$0001	;0001
	dc.w	$09A1	;09A1
	dc.w	$2115	;2115
	dc.w	$09A1	;09A1
	dc.w	$0001	;0001
	dc.w	$0204	;0204
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$31A1	;31A1
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1315	;1315
	dc.w	$00A1	;00A1
	dc.w	$0991	;0991
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$09B1	;09B1
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$09A1	;09A1
	dc.w	$0981	;0981
	dc.w	$0103	;0103
	dc.w	$0981	;0981
	dc.w	$0504	;0504
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0000	;0000
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$C012	;C012
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0304	;0304
	dc.w	$0000	;0000
	dc.w	$0704	;0704
	dc.w	$09A1	;09A1
	dc.w	$5315	;5315
	dc.w	$09A1	;09A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0981	;0981
	dc.w	$1381	;1381
	dc.w	$0981	;0981
	dc.w	$0704	;0704
	dc.w	$0000	;0000
ObjectData_4:
	dc.w	$02C0	;02C0

	dc.w	$4494	;4494
	dc.w	$0201	;0201
	dc.w	$0A04	;0A04
	dc.w	$1421	;1421
	dc.w	$0184	;0184
	dc.w	$CC01	;CC01
	dc.w	$3101	;3101
	dc.w	$1601	;1601
	dc.w	$04E4	;04E4
	dc.w	$0126	;0126
	dc.w	$012E	;012E
	dc.w	$0144	;0144
	dc.w	$0800	;0800
	dc.w	$0D01	;0D01
	dc.w	$840C	;840C
	dc.w	$0104	;0104
	dc.w	$0A01	;0A01
	dc.w	$0844	;0844
	dc.w	$E401	;E401
	dc.w	$040A	;040A
	dc.w	$0108	;0108
	dc.w	$0440	;0440
	dc.w	$0126	;0126
	dc.w	$012E	;012E
	dc.w	$01C4	;01C4
	dc.w	$AE01	;AE01
	dc.w	$0D01	;0D01
	dc.w	$0701	;0701
	dc.w	$C408	;C408
	dc.w	$0007	;0007
	dc.w	$0141	;0141
	dc.w	$8401	;8401
	dc.w	$1701	;1701
	dc.w	$5101	;5101
	dc.w	$04B0	;04B0
	dc.w	$0154	;0154
	dc.w	$0110	;0110
	dc.w	$01C6	;01C6
	dc.w	$6400	;6400
	dc.w	$5401	;5401
	dc.w	$06D0	;06D0
	dc.w	$010A	;010A
	dc.w	$0107	;0107
	dc.w	$0186	;0186
	dc.w	$5E01	;5E01
	dc.w	$0D01	;0D01
	dc.w	$1601	;1601
	dc.w	$C65E	;C65E
	dc.w	$0118	;0118
	dc.w	$0107	;0107
	dc.w	$0146	;0146
	dc.w	$D001	;D001
	dc.w	$1701	;1701
	dc.w	$1601	;1601
	dc.w	$06E6	;06E6
	dc.w	$0004	;0004
	dc.w	$0AC7	;0AC7
	dc.w	$1002	;1002
	dc.w	$040A	;040A
	dc.w	$0205	;0205
	dc.w	$010A	;010A
	dc.w	$87F8	;87F8
	dc.w	$0002	;0002
	dc.w	$0508	;0508
	dc.w	$3601	;3601
	dc.w	$5001	;5001
	dc.w	$1601	;1601
	dc.w	$8836	;8836
	dc.w	$0021	;0021
	dc.w	$0108	;0108
	dc.w	$0E00	;0E00
	dc.w	$5501	;5501
	dc.w	$87BE	;87BE
	dc.w	$0116	;0116
	dc.w	$0121	;0121
	dc.w	$0188	;0188
	dc.w	$D400	;D400
	dc.w	$1301	;1301
	dc.w	$48CE	;48CE
	dc.w	$0010	;0010
	dc.w	$018A	;018A
	dc.w	$7E00	;7E00
	dc.w	$0108	;0108
	dc.w	$CA7E	;CA7E
	dc.w	$0004	;0004
	dc.w	$0A4A	;0A4A
	dc.w	$E001	;E001
	dc.w	$040A	;040A
	dc.w	$0109	;0109
	dc.w	$CAFC	;CAFC
	dc.w	$001A	;001A
	dc.w	$0189	;0189
	dc.w	$3602	;3602
	dc.w	$5401	;5401
	dc.w	$2901	;2901
	dc.w	$6901	;6901
	dc.w	$893A	;893A
	dc.w	$0254	;0254
	dc.w	$0129	;0129
	dc.w	$016B	;016B
	dc.w	$0109	;0109
	dc.w	$4E00	;4E00
	dc.w	$5401	;5401
	dc.w	$49EA	;49EA
	dc.w	$0051	;0051
	dc.w	$0109	;0109
	dc.w	$1800	;1800
	dc.w	$0901	;0901
	dc.w	$CC10	;CC10
	dc.w	$0031	;0031
	dc.w	$014B	;014B
	dc.w	$9603	;9603
	dc.w	$5201	;5201
	dc.w	$1601	;1601
	dc.w	$1502	;1502
	dc.w	$1401	;1401
	dc.w	$8D46	;8D46
	dc.w	$0107	;0107
	dc.w	$010A	;010A
	dc.w	$010D	;010D
	dc.w	$4600	;4600
	dc.w	$1301	;1301
	dc.w	$CCE0	;CCE0
	dc.w	$010A	;010A
	dc.w	$010D	;010D
	dc.w	$020B	;020B
	dc.w	$4201	;4201
	dc.w	$040A	;040A
	dc.w	$1401	;1401
	dc.w	$CC00	;CC00
	dc.w	$0104	;0104
	dc.w	$0650	;0650
	dc.w	$010B	;010B
	dc.w	$4C00	;4C00
	dc.w	$0407	;0407
	dc.w	$8D12	;8D12
	dc.w	$0101	;0101
	dc.w	$0A19	;0A19
	dc.w	$014D	;014D
	dc.w	$3400	;3400
	dc.w	$0A01	;0A01
	dc.w	$CC72	;CC72
	dc.w	$0001	;0001
	dc.w	$0A8D	;0A8D
	dc.w	$EC00	;EC00
	dc.w	$2201	;2201
	dc.w	$0DB8	;0DB8
	dc.w	$0054	;0054
	dc.w	$010E	;010E
	dc.w	$1A00	;1A00
	dc.w	$1A01	;1A01
	dc.w	$4E5A	;4E5A
	dc.w	$0022	;0022
	dc.w	$018E	;018E
	dc.w	$9E00	;9E00
	dc.w	$3B01	;3B01
	dc.w	$0E9E	;0E9E
	dc.w	$0016	;0016
	dc.w	$01CE	;01CE
	dc.w	$9401	;9401
	dc.w	$5501	;5501
	dc.w	$1901	;1901
	dc.w	$CE8C	;CE8C
	dc.w	$0002	;0002
	dc.w	$0A4D	;0A4D
	dc.w	$F200	;F200
	dc.w	$0405	;0405
	dc.w	$0F78	;0F78
	dc.w	$0050	;0050
	dc.w	$01CF	;01CF
	dc.w	$3A00	;3A00
	dc.w	$5501	;5501
	dc.w	$4ED4	;4ED4
	dc.w	$0036	;0036
	dc.w	$010E	;010E
	dc.w	$D400	;D400
	dc.w	$5401	;5401
	dc.w	$4EF0	;4EF0
	dc.w	$010A	;010A
	dc.w	$0115	;0115
	dc.w	$014E	;014E
	dc.w	$E401	;E401
	dc.w	$0A01	;0A01
	dc.w	$1501	;1501
	dc.w	$CFBC	;CFBC
	dc.w	$0007	;0007
	dc.w	$018F	;018F
	dc.w	$B800	;B800
	dc.w	$5301	;5301
	dc.w	$0FB2	;0FB2
	dc.w	$0001	;0001
	dc.w	$0F4F	;0F4F
	dc.w	$B600	;B600
	dc.w	$040A	;040A
	dc.w	$0EE4	;0EE4
	dc.w	$0104	;0104
	dc.w	$1051	;1051
	dc.w	$01CF	;01CF
	dc.w	$6200	;6200
	dc.w	$0106	;0106
	dc.w	$0EF0	;0EF0
	dc.w	$0104	;0104
	dc.w	$1052	;1052
	dc.w	$018F	;018F
	dc.w	$8E00	;8E00
	dc.w	$0406	;0406
	dc.w	$404C	;404C
	dc.w	$000A	;000A
	dc.w	$0180	;0180
	dc.w	$4600	;4600
	dc.w	$0701	;0701
	dc.w	$849C	;849C
	dc.w	$0015	;0015
	dc.w	$01C5	;01C5
	dc.w	$7400	;7400
	dc.w	$2C01	;2C01
	dc.w	$C572	;C572
	dc.w	$010A	;010A
	dc.w	$0113	;0113
	dc.w	$0185	;0185
	dc.w	$7200	;7200
	dc.w	$3401	;3401
	dc.w	$8142	;8142
	dc.w	$0120	;0120
	dc.w	$0114	;0114
	dc.w	$0181	;0181
	dc.w	$C801	;C801
	dc.w	$2E01	;2E01
	dc.w	$0701	;0701
	dc.w	$4178	;4178
	dc.w	$010D	;010D
	dc.w	$0113	;0113
	dc.w	$0140	;0140
	dc.w	$0400	;0400
	dc.w	$0701	;0701
	dc.w	$8022	;8022
	dc.w	$000D	;000D
	dc.w	$01C1	;01C1
	dc.w	$6E02	;6E02
	dc.w	$010A	;010A
	dc.w	$0414	;0414
	dc.w	$2101	;2101
	dc.w	$45BC	;45BC
	dc.w	$000A	;000A
	dc.w	$0185	;0185
	dc.w	$7600	;7600
	dc.w	$1001	;1001
	dc.w	$05A6	;05A6
	dc.w	$0007	;0007
	dc.w	$01C0	;01C0
	dc.w	$B600	;B600
	dc.w	$1501	;1501
	dc.w	$8128	;8128
	dc.w	$0007	;0007
	dc.w	$0101	;0101
	dc.w	$6600	;6600
	dc.w	$3801	;3801
	dc.w	$4088	;4088
	dc.w	$0010	;0010
	dc.w	$0140	;0140
	dc.w	$AE00	;AE00
	dc.w	$1401	;1401
	dc.w	$4076	;4076
	dc.w	$0213	;0213
	dc.w	$010D	;010D
	dc.w	$0124	;0124
	dc.w	$0140	;0140
	dc.w	$DC01	;DC01
	dc.w	$3901	;3901
	dc.w	$0D01	;0D01
	dc.w	$40D8	;40D8
	dc.w	$013A	;013A
	dc.w	$010A	;010A
	dc.w	$0141	;0141
	dc.w	$0E00	;0E00
	dc.w	$1401	;1401
	dc.w	$0090	;0090
	dc.w	$020A	;020A
	dc.w	$0115	;0115
	dc.w	$015E	;015E
	dc.w	$01C0	;01C0
	dc.w	$C601	;C601
	dc.w	$0701	;0701
	dc.w	$1B01	;1B01
	dc.w	$80CC	;80CC
	dc.w	$0030	;0030
	dc.w	$0145	;0145
	dc.w	$5E01	;5E01
	dc.w	$0701	;0701
	dc.w	$1F01	;1F01
	dc.w	$05F4	;05F4
	dc.w	$0007	;0007
	dc.w	$0105	;0105
	dc.w	$C400	;C400
	dc.w	$5001	;5001
	dc.w	$45C4	;45C4
	dc.w	$0018	;0018
	dc.w	$01C2	;01C2
	dc.w	$4E00	;4E00
	dc.w	$1301	;1301
	dc.w	$41BE	;41BE
	dc.w	$0039	;0039
	dc.w	$0182	;0182
	dc.w	$1600	;1600
	dc.w	$0701	;0701
	dc.w	$C0E0	;C0E0
	dc.w	$0014	;0014
	dc.w	$0180	;0180
	dc.w	$E000	;E000
	dc.w	$0D01	;0D01
	dc.w	$C184	;C184
	dc.w	$000A	;000A
	dc.w	$0185	;0185
	dc.w	$2A00	;2A00
	dc.w	$0D01	;0D01
	dc.w	$C5CE	;C5CE
	dc.w	$003A	;003A
	dc.w	$0145	;0145
	dc.w	$CE00	;CE00
	dc.w	$0D01	;0D01
	dc.w	$0532	;0532
	dc.w	$000A	;000A
	dc.w	$0185	;0185
	dc.w	$3200	;3200
	dc.w	$1501	;1501
	dc.w	$04F6	;04F6
	dc.w	$0007	;0007
	dc.w	$0104	;0104
	dc.w	$5A00	;5A00
	dc.w	$0A01	;0A01
	dc.w	$041E	;041E
	dc.w	$002D	;002D
	dc.w	$01C3	;01C3
	dc.w	$E200	;E200
	dc.w	$0A01	;0A01
	dc.w	$4348	;4348
	dc.w	$000D	;000D
	dc.w	$01C2	;01C2
	dc.w	$DA01	;DA01
	dc.w	$0701	;0701
	dc.w	$2001	;2001
	dc.w	$83B0	;83B0
	dc.w	$0013	;0013
	dc.w	$0102	;0102
	dc.w	$2200	;2200
	dc.w	$0D01	;0D01
	dc.w	$8756	;8756
	dc.w	$0152	;0152
	dc.w	$0110	;0110
	dc.w	$0147	;0147
	dc.w	$6C00	;6C00
	dc.w	$0701	;0701
	dc.w	$5E00	;5E00
	dc.w	$005E	;005E
	dc.w	$0114	;0114
	dc.w	$010D	;010D
	dc.w	$01FF	;01FF
	dc.w	$0D00	;0D00
	dc.w	$0101	;0101
	dc.w	$0D01	;0D01
	dc.w	$0024	;0024
	dc.w	$0124	;0124
	dc.w	$0101	;0101
	dc.w	$1501	;1501
	dc.w	$0701	;0701
	dc.w	$0701	;0701
	dc.w	$FF21	;FF21
	dc.w	$0000	;0000
	dc.w	$010A	;010A
	dc.w	$010D	;010D
	dc.w	$010A	;010A
	dc.w	$0100	;0100
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
MapData5:
	dc.w	$0915	;0915
	dc.w	$1511	;1511
	dc.w	$0F0D	;0F0D
	dc.w	$0C04	;0C04
	dc.w	$0515	;0515
	dc.w	$1515	;1515
	dc.w	$1515	;1515
	dc.w	$0C01	;0C01
	dc.w	$0000	;0000
	dc.w	$005A	;005A
	dc.w	$03CC	;03CC
	dc.w	$073E	;073E
	dc.w	$0A08	;0A08
	dc.w	$0C7E	;0C7E
	dc.w	$0EA0	;0EA0
	dc.w	$0FC0	;0FC0
	dc.w	$0F00	;0F00
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0004	;0004
	dc.w	$0800	;0800
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$050A	;050A
	dc.w	$000D	;000D
	dc.w	$0015	;0015
	dc.w	$0C7E	;0C7E
	dc.w	$0007	;0007
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0604	;0604
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$1081	;1081
	dc.w	$11A1	;11A1
	dc.w	$0000	;0000
	dc.w	$11A1	;11A1
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$DA06	;DA06
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0505	;0505
	dc.w	$E206	;E206
	dc.w	$0D05	;0D05
	dc.w	$0000	;0000
	dc.w	$10A1	;10A1
	dc.w	$1181	;1181
	dc.w	$0000	;0000
	dc.w	$1181	;1181
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$EA06	;EA06
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0604	;0604
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$39A1	;39A1
	dc.w	$0000	;0000
	dc.w	$C012	;C012
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1002	;1002
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0302	;0302
	dc.w	$F306	;F306
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0103	;0103
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$11A1	;11A1
	dc.w	$0305	;0305
	dc.w	$1DA1	;1DA1
	dc.w	$0001	;0001
	dc.w	$0305	;0305
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0004	;0004
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0207	;0207
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$11A1	;11A1
	dc.w	$0001	;0001
	dc.w	$0305	;0305
	dc.w	$0001	;0001
	dc.w	$11A1	;11A1
	dc.w	$0081	;0081
	dc.w	$0091	;0091
	dc.w	$0003	;0003
	dc.w	$0001	;0001
	dc.w	$0312	;0312
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$1191	;1191
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$1306	;1306
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$1306	;1306
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$7315	;7315
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$C502	;C502
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0304	;0304
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$4002	;4002
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$3B06	;3B06
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1591	;1591
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0AA1	;0AA1
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$1B06	;1B06
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0B06	;0B06
	dc.w	$0000	;0000
	dc.w	$3306	;3306
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0003	;0003
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0304	;0304
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$5115	;5115
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0B06	;0B06
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$4B06	;4B06
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$4306	;4306
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0B06	;0B06
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$1B06	;1B06
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$1306	;1306
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0404	;0404
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$11B1	;11B1
	dc.w	$02A1	;02A1
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$2306	;2306
	dc.w	$0505	;0505
	dc.w	$2A06	;2A06
	dc.w	$02B1	;02B1
	dc.w	$19A1	;19A1
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$11B1	;11B1
	dc.w	$0281	;0281
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0404	;0404
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$6515	;6515
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$1181	;1181
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$1181	;1181
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0706	;0706
	dc.w	$0001	;0001
	dc.w	$0181	;0181
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0705	;0705
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
	dc.w	$6206	;6206
	dc.w	$6A06	;6A06
	dc.w	$7206	;7206
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$2515	;2515
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0706	;0706
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0705	;0705
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0705	;0705
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0003	;0003
	dc.w	$4102	;4102
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0081	;0081
	dc.w	$1002	;1002
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0081	;0081
	dc.w	$0001	;0001
	dc.w	$0404	;0404
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0706	;0706
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0003	;0003
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0504	;0504
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4515	;4515
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$2DB1	;2DB1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0404	;0404
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0712	;0712
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0C12	;0C12
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0706	;0706
	dc.w	$5A06	;5A06
	dc.w	$01B1	;01B1
	dc.w	$01A1	;01A1
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$3315	;3315
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0103	;0103
	dc.w	$3412	;3412
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C012	;C012
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C012	;C012
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0181	;0181
	dc.w	$00A1	;00A1
	dc.w	$0103	;0103
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$21A1	;21A1
	dc.w	$0104	;0104
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0104	;0104
	dc.w	$0001	;0001
	dc.w	$0004	;0004
	dc.w	$0001	;0001
	dc.w	$00A1	;00A1
	dc.w	$00A1	;00A1
	dc.w	$0081	;0081
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1002	;1002
	dc.w	$00A1	;00A1
	dc.w	$0706	;0706
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0103	;0103
	dc.w	$1C12	;1C12
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0106	;0106
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$5206	;5206
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0604	;0604
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$2581	;2581
	dc.w	$0004	;0004
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0001	;0001
	dc.w	$2FA1	;2FA1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0104	;0104
	dc.w	$0000	;0000
	dc.w	$0106	;0106
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0102	;0102
	dc.w	$0102	;0102
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3F91	;3F91
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0106	;0106
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$7AB1	;7AB1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
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
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0104	;0104
	dc.w	$00A1	;00A1
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$11A1	;11A1
	dc.w	$0105	;0105
	dc.w	$11A1	;11A1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1515	;1515
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$00A1	;00A1
	dc.w	$2115	;2115
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0103	;0103
	dc.w	$4102	;4102
	dc.w	$00B1	;00B1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$1291	;1291
	dc.w	$0506	;0506
	dc.w	$12B1	;12B1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C012	;C012
	dc.w	$0000	;0000
	dc.w	$C012	;C012
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C102	;C102
	dc.w	$0302	;0302
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0102	;0102
	dc.w	$0102	;0102
	dc.w	$01B1	;01B1
	dc.w	$0003	;0003
	dc.w	$00A1	;00A1
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0502	;0502
	dc.w	$D206	;D206
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3F91	;3F91
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0705	;0705
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$01A1	;01A1
	dc.w	$3315	;3315
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0706	;0706
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0081	;0081
	dc.w	$0103	;0103
	dc.w	$0102	;0102
	dc.w	$0102	;0102
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$2FA1	;2FA1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0305	;0305
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0106	;0106
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$0312	;0312
	dc.w	$0102	;0102
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0404	;0404
	dc.w	$00A1	;00A1
	dc.w	$0504	;0504
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0003	;0003
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0706	;0706
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0705	;0705
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$8206	;8206
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0304	;0304
	dc.w	$0000	;0000
	dc.w	$1A81	;1A81
	dc.w	$1002	;1002
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0003	;0003
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$3181	;3181
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0091	;0091
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0305	;0305
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0504	;0504
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0B06	;0B06
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$01B1	;01B1
	dc.w	$0B06	;0B06
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0191	;0191
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$1B06	;1B06
	dc.w	$0006	;0006
	dc.w	$1306	;1306
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0B06	;0B06
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0B06	;0B06
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$1B06	;1B06
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0404	;0404
	dc.w	$0181	;0181
	dc.w	$0A05	;0A05
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$01B1	;01B1
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0B06	;0B06
	dc.w	$0191	;0191
	dc.w	$0006	;0006
	dc.w	$0402	;0402
	dc.w	$0106	;0106
	dc.w	$9206	;9206
	dc.w	$0402	;0402
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0B06	;0B06
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$6115	;6115
	dc.w	$01A1	;01A1
	dc.w	$2981	;2981
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$1002	;1002
	dc.w	$01A1	;01A1
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0207	;0207
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0706	;0706
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$5315	;5315
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0404	;0404
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$1315	;1315
	dc.w	$0001	;0001
	dc.w	$0106	;0106
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$FA06	;FA06
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0181	;0181
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$D402	;D402
	dc.w	$1715	;1715
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0104	;0104
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0081	;0081
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$4315	;4315
	dc.w	$0081	;0081
	dc.w	$0001	;0001
	dc.w	$8A06	;8A06
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0081	;0081
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FA06	;FA06
	dc.w	$0103	;0103
	dc.w	$0D02	;0D02
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C102	;C102
	dc.w	$0102	;0102
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0106	;0106
	dc.w	$0001	;0001
	dc.w	$0003	;0003
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0003	;0003
	dc.w	$32A1	;32A1
	dc.w	$2AA1	;2AA1
	dc.w	$22A1	;22A1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$7012	;7012
	dc.w	$3012	;3012
	dc.w	$7002	;7002
	dc.w	$00B1	;00B1
	dc.w	$A206	;A206
	dc.w	$AA06	;AA06
	dc.w	$B206	;B206
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0C12	;0C12
	dc.w	$1306	;1306
	dc.w	$1306	;1306
	dc.w	$1306	;1306
	dc.w	$C012	;C012
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$6115	;6115
	dc.w	$0181	;0181
	dc.w	$3115	;3115
	dc.w	$0001	;0001
	dc.w	$0D02	;0D02
	dc.w	$1306	;1306
	dc.w	$1306	;1306
	dc.w	$1306	;1306
	dc.w	$C012	;C012
	dc.w	$0000	;0000
	dc.w	$7A06	;7A06
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0D12	;0D12
	dc.w	$1306	;1306
	dc.w	$1306	;1306
	dc.w	$1306	;1306
	dc.w	$C102	;C102
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0302	;0302
	dc.w	$4302	;4302
	dc.w	$4302	;4302
	dc.w	$0081	;0081
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0604	;0604
	dc.w	$0001	;0001
	dc.w	$0207	;0207
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$0081	;0081
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0104	;0104
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$7A06	;7A06
	dc.w	$0000	;0000
	dc.w	$52A1	;52A1
	dc.w	$0006	;0006
	dc.w	$0003	;0003
	dc.w	$0001	;0001
	dc.w	$3012	;3012
	dc.w	$0001	;0001
	dc.w	$0003	;0003
	dc.w	$0091	;0091
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$3AA1	;3AA1
	dc.w	$42A1	;42A1
	dc.w	$4AA1	;4AA1
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$01A1	;01A1
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$BA06	;BA06
	dc.w	$C206	;C206
	dc.w	$CA06	;CA06
	dc.w	$0091	;0091
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$01A1	;01A1
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$5712	;5712
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$7A06	;7A06
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0181	;0181
	dc.w	$0103	;0103
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0104	;0104
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0103	;0103
	dc.w	$00A1	;00A1
	dc.w	$0106	;0106
	dc.w	$0000	;0000
	dc.w	$0706	;0706
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C012	;C012
	dc.w	$0000	;0000
	dc.w	$0312	;0312
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0305	;0305
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1002	;1002
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0003	;0003
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0302	;0302
	dc.w	$00A1	;00A1
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0404	;0404
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0C12	;0C12
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0003	;0003
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$2515	;2515
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0304	;0304
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$35B1	;35B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4515	;4515
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$11B1	;11B1
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$6281	;6281
	dc.w	$0001	;0001
	dc.w	$1191	;1191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4515	;4515
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$6AB1	;6AB1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$11B1	;11B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$11A1	;11A1
	dc.w	$0B05	;0B05
	dc.w	$11A1	;11A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0604	;0604
	dc.w	$1191	;1191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$11B1	;11B1
	dc.w	$0081	;0081
	dc.w	$0204	;0204
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$11B1	;11B1
	dc.w	$1191	;1191
	dc.w	$0103	;0103
	dc.w	$9B06	;9B06
	dc.w	$0103	;0103
	dc.w	$11B1	;11B1
	dc.w	$0103	;0103
	dc.w	$00A1	;00A1
	dc.w	$1181	;1181
	dc.w	$0103	;0103
	dc.w	$0302	;0302
	dc.w	$0102	;0102
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0B81	;0B81
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0106	;0106
	dc.w	$0000	;0000
	dc.w	$7291	;7291
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$11B1	;11B1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$1181	;1181
	dc.w	$0103	;0103
	dc.w	$1181	;1181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$5AB1	;5AB1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
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
	dc.w	$00B1	;00B1
	dc.w	$0104	;0104
	dc.w	$0304	;0304
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0704	;0704
ObjectData_5:
	dc.w	$020B	;020B

	dc.w	$C038	;C038
	dc.w	$0016	;0016
	dc.w	$0180	;0180
	dc.w	$3800	;3800
	dc.w	$0701	;0701
	dc.w	$0014	;0014
	dc.w	$0016	;0016
	dc.w	$0140	;0140
	dc.w	$1400	;1400
	dc.w	$0701	;0701
	dc.w	$81F6	;81F6
	dc.w	$0104	;0104
	dc.w	$145D	;145D
	dc.w	$01C1	;01C1
	dc.w	$7E01	;7E01
	dc.w	$0414	;0414
	dc.w	$5D01	;5D01
	dc.w	$00AA	;00AA
	dc.w	$0007	;0007
	dc.w	$0140	;0140
	dc.w	$AA00	;AA00
	dc.w	$5501	;5501
	dc.w	$40F8	;40F8
	dc.w	$0016	;0016
	dc.w	$0140	;0140
	dc.w	$6000	;6000
	dc.w	$0D01	;0D01
	dc.w	$C060	;C060
	dc.w	$000D	;000D
	dc.w	$0180	;0180
	dc.w	$6600	;6600
	dc.w	$0A01	;0A01
	dc.w	$0066	;0066
	dc.w	$000A	;000A
	dc.w	$0100	;0100
	dc.w	$9000	;9000
	dc.w	$0701	;0701
	dc.w	$8090	;8090
	dc.w	$000A	;000A
	dc.w	$01C0	;01C0
	dc.w	$8A00	;8A00
	dc.w	$0D01	;0D01
	dc.w	$408A	;408A
	dc.w	$0007	;0007
	dc.w	$0140	;0140
	dc.w	$B800	;B800
	dc.w	$1601	;1601
	dc.w	$C0B8	;C0B8
	dc.w	$0001	;0001
	dc.w	$0641	;0641
	dc.w	$B200	;B200
	dc.w	$020A	;020A
	dc.w	$C05C	;C05C
	dc.w	$003C	;003C
	dc.w	$018C	;018C
	dc.w	$6200	;6200
	dc.w	$5001	;5001
	dc.w	$8960	;8960
	dc.w	$0016	;0016
	dc.w	$01C6	;01C6
	dc.w	$C400	;C400
	dc.w	$5601	;5601
	dc.w	$C6C0	;C6C0
	dc.w	$0052	;0052
	dc.w	$0108	;0108
	dc.w	$9800	;9800
	dc.w	$0408	;0408
	dc.w	$8A64	;8A64
	dc.w	$0016	;0016
	dc.w	$010A	;010A
	dc.w	$DA00	;DA00
	dc.w	$1601	;1601
	dc.w	$CB1C	;CB1C
	dc.w	$020A	;020A
	dc.w	$0107	;0107
	dc.w	$0116	;0116
	dc.w	$0187	;0187
	dc.w	$EE00	;EE00
	dc.w	$2201	;2201
	dc.w	$87AA	;87AA
	dc.w	$0054	;0054
	dc.w	$0104	;0104
	dc.w	$2600	;2600
	dc.w	$1602	;1602
	dc.w	$CD88	;CD88
	dc.w	$0255	;0255
	dc.w	$016A	;016A
	dc.w	$012F	;012F
	dc.w	$0144	;0144
	dc.w	$4A02	;4A02
	dc.w	$0D01	;0D01
	dc.w	$0A01	;0A01
	dc.w	$2201	;2201
	dc.w	$8D06	;8D06
	dc.w	$0053	;0053
	dc.w	$0106	;0106
	dc.w	$2E00	;2E00
	dc.w	$1701	;1701
	dc.w	$4454	;4454
	dc.w	$0004	;0004
	dc.w	$0C04	;0C04
	dc.w	$0600	;0600
	dc.w	$5101	;5101
	dc.w	$4470	;4470
	dc.w	$0152	;0152
	dc.w	$0116	;0116
	dc.w	$0185	;0185
	dc.w	$AC00	;AC00
	dc.w	$1701	;1701
	dc.w	$06A2	;06A2
	dc.w	$000A	;000A
	dc.w	$01C7	;01C7
	dc.w	$7E00	;7E00
	dc.w	$0107	;0107
	dc.w	$86FC	;86FC
	dc.w	$0018	;0018
	dc.w	$01C6	;01C6
	dc.w	$9E00	;9E00
	dc.w	$1801	;1801
	dc.w	$C5E2	;C5E2
	dc.w	$000A	;000A
	dc.w	$0106	;0106
	dc.w	$3A00	;3A00
	dc.w	$1601	;1601
	dc.w	$899C	;899C
	dc.w	$003F	;003F
	dc.w	$0149	;0149
	dc.w	$9400	;9400
	dc.w	$1A01	;1A01
	dc.w	$4A04	;4A04
	dc.w	$0023	;0023
	dc.w	$01C8	;01C8
	dc.w	$0200	;0200
	dc.w	$5001	;5001
	dc.w	$C912	;C912
	dc.w	$0251	;0251
	dc.w	$0101	;0101
	dc.w	$0C23	;0C23
	dc.w	$0148	;0148
	dc.w	$2600	;2600
	dc.w	$2F01	;2F01
	dc.w	$8828	;8828
	dc.w	$0016	;0016
	dc.w	$0188	;0188
	dc.w	$6800	;6800
	dc.w	$2A01	;2A01
	dc.w	$48A8	;48A8
	dc.w	$0016	;0016
	dc.w	$0108	;0108
	dc.w	$AE00	;AE00
	dc.w	$1A01	;1A01
	dc.w	$4880	;4880
	dc.w	$003F	;003F
	dc.w	$0109	;0109
	dc.w	$0201	;0201
	dc.w	$2F01	;2F01
	dc.w	$2A01	;2A01
	dc.w	$483C	;483C
	dc.w	$0004	;0004
	dc.w	$0AC8	;0AC8
	dc.w	$5600	;5600
	dc.w	$0419	;0419
	dc.w	$4816	;4816
	dc.w	$0001	;0001
	dc.w	$0BC9	;0BC9
	dc.w	$0600	;0600
	dc.w	$1601	;1601
	dc.w	$098E	;098E
	dc.w	$0016	;0016
	dc.w	$0149	;0149
	dc.w	$6801	;6801
	dc.w	$0206	;0206
	dc.w	$0114	;0114
	dc.w	$8A12	;8A12
	dc.w	$0054	;0054
	dc.w	$014A	;014A
	dc.w	$5A00	;5A00
	dc.w	$0108	;0108
	dc.w	$0A5C	;0A5C
	dc.w	$0004	;0004
	dc.w	$088B	;088B
	dc.w	$6000	;6000
	dc.w	$5501	;5501
	dc.w	$0C16	;0C16
	dc.w	$0053	;0053
	dc.w	$010C	;010C
	dc.w	$2C00	;2C00
	dc.w	$040A	;040A
	dc.w	$4BA6	;4BA6
	dc.w	$0050	;0050
	dc.w	$014D	;014D
	dc.w	$4801	;4801
	dc.w	$0205	;0205
	dc.w	$040A	;040A
	dc.w	$4D6E	;4D6E
	dc.w	$0102	;0102
	dc.w	$0504	;0504
	dc.w	$0A8C	;0A8C
	dc.w	$9600	;9600
	dc.w	$5201	;5201
	dc.w	$0CFE	;0CFE
	dc.w	$0004	;0004
	dc.w	$048C	;048C
	dc.w	$FA00	;FA00
	dc.w	$0106	;0106
	dc.w	$8FBC	;8FBC
	dc.w	$0053	;0053
	dc.w	$01CE	;01CE
	dc.w	$5600	;5600
	dc.w	$0204	;0204
	dc.w	$4DA2	;4DA2
	dc.w	$0053	;0053
	dc.w	$010E	;010E
	dc.w	$6600	;6600
	dc.w	$5101	;5101
	dc.w	$CDCC	;CDCC
	dc.w	$0104	;0104
	dc.w	$0A02	;0A02
	dc.w	$040E	;040E
	dc.w	$2E00	;2E00
	dc.w	$0203	;0203
	dc.w	$4F04	;4F04
	dc.w	$0056	;0056
	dc.w	$0141	;0141
	dc.w	$2800	;2800
	dc.w	$0D01	;0D01
	dc.w	$C374	;C374
	dc.w	$0016	;0016
	dc.w	$0181	;0181
	dc.w	$E800	;E800
	dc.w	$0D01	;0D01
	dc.w	$01E8	;01E8
	dc.w	$000A	;000A
	dc.w	$01C1	;01C1
	dc.w	$E600	;E600
	dc.w	$010C	;010C
	dc.w	$4536	;4536
	dc.w	$0016	;0016
	dc.w	$0104	;0104
	dc.w	$6600	;6600
	dc.w	$010C	;010C
	dc.w	$849C	;849C
	dc.w	$0001	;0001
	dc.w	$0A84	;0A84
	dc.w	$1C00	;1C00
	dc.w	$1001	;1001
	dc.w	$84CE	;84CE
	dc.w	$0101	;0101
	dc.w	$0A0D	;0A0D
	dc.w	$0184	;0184
	dc.w	$7A01	;7A01
	dc.w	$0A01	;0A01
	dc.w	$1001	;1001
	dc.w	$434E	;434E
	dc.w	$0002	;0002
	dc.w	$0582	;0582
	dc.w	$D400	;D400
	dc.w	$2F01	;2F01
	dc.w	$433C	;433C
	dc.w	$0101	;0101
	dc.w	$0A10	;0A10
	dc.w	$0100	;0100
	dc.w	$2F00	;2F00
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
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
MapData6:
	dc.w	$1313	;1313
	dc.w	$1313	;1313
	dc.w	$1300	;1300
	dc.w	$0000	;0000
	dc.w	$1313	;1313
	dc.w	$1313	;1313
	dc.w	$1300	;1300
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$02D2	;02D2
	dc.w	$05A4	;05A4
	dc.w	$0876	;0876
	dc.w	$0B48	;0B48
	dc.w	$0E1A	;0E1A
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
	dc.w	$0013	;0013
	dc.w	$0013	;0013
	dc.w	$0B48	;0B48
	dc.w	$0004	;0004
	dc.w	$0003	;0003
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1715	;1715
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4715	;4715
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$3402	;3402
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$1002	;1002
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0102	;0102
	dc.w	$5312	;5312
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$00A1	;00A1
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$01A1	;01A1
	dc.w	$0105	;0105
	dc.w	$01A1	;01A1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0505	;0505
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1002	;1002
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0004	;0004
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0001	;0001
	dc.w	$0102	;0102
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$05B1	;05B1
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0081	;0081
	dc.w	$0103	;0103
	dc.w	$0181	;0181
	dc.w	$01A1	;01A1
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0312	;0312
	dc.w	$0102	;0102
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$09B1	;09B1
	dc.w	$EA06	;EA06
	dc.w	$0001	;0001
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0505	;0505
	dc.w	$F206	;F206
	dc.w	$0D05	;0D05
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0706	;0706
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0DB1	;0DB1
	dc.w	$FA06	;FA06
	dc.w	$0001	;0001
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$0404	;0404
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$11B1	;11B1
	dc.w	$00A1	;00A1
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0207	;0207
	dc.w	$0207	;0207
	dc.w	$0207	;0207
	dc.w	$0207	;0207
	dc.w	$0207	;0207
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$D002	;D002
	dc.w	$0001	;0001
	dc.w	$2115	;2115
	dc.w	$01A1	;01A1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C012	;C012
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$01A1	;01A1
	dc.w	$0103	;0103
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$00A1	;00A1
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0181	;0181
	dc.w	$3115	;3115
	dc.w	$1581	;1581
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0312	;0312
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0003	;0003
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0091	;0091
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0712	;0712
	dc.w	$0000	;0000
	dc.w	$3012	;3012
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$2515	;2515
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$5002	;5002
	dc.w	$1402	;1402
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0081	;0081
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$3002	;3002
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0006	;0006
	dc.w	$8012	;8012
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0402	;0402
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$01A1	;01A1
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$3581	;3581
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0404	;0404
	dc.w	$00A1	;00A1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0504	;0504
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$3412	;3412
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0905	;0905
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$3AA1	;3AA1
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0104	;0104
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$4A06	;4A06
	dc.w	$0001	;0001
	dc.w	$DA06	;DA06
	dc.w	$E106	;E106
	dc.w	$DA06	;DA06
	dc.w	$0001	;0001
	dc.w	$4B06	;4B06
	dc.w	$0081	;0081
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0A91	;0A91
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$5715	;5715
	dc.w	$DA06	;DA06
	dc.w	$DA06	;DA06
	dc.w	$DA06	;DA06
	dc.w	$0F05	;0F05
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0081	;0081
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0081	;0081
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0003	;0003
	dc.w	$00A1	;00A1
	dc.w	$0001	;0001
	dc.w	$DA06	;DA06
	dc.w	$DA06	;DA06
	dc.w	$DA06	;DA06
	dc.w	$0001	;0001
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$1002	;1002
	dc.w	$1C02	;1C02
	dc.w	$0000	;0000
	dc.w	$19A1	;19A1
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$6515	;6515
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$0001	;0001
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
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0181	;0181
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0081	;0081
	dc.w	$0181	;0181
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$00B1	;00B1
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$01A1	;01A1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$B206	;B206
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$4591	;4591
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$1A91	;1A91
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$1291	;1291
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$1715	;1715
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0312	;0312
	dc.w	$00A1	;00A1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0001	;0001
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0181	;0181
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$22B1	;22B1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0091	;0091
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$4002	;4002
	dc.w	$00B1	;00B1
	dc.w	$0204	;0204
	dc.w	$0000	;0000
	dc.w	$7515	;7515
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0305	;0305
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$1C12	;1C12
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4102	;4102
	dc.w	$0000	;0000
	dc.w	$0003	;0003
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1002	;1002
	dc.w	$3002	;3002
	dc.w	$0000	;0000
	dc.w	$0706	;0706
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C012	;C012
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0181	;0181
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0104	;0104
	dc.w	$31A1	;31A1
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$4315	;4315
	dc.w	$0001	;0001
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
	dc.w	$01A1	;01A1
	dc.w	$0103	;0103
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$5A91	;5A91
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0305	;0305
	dc.w	$01A1	;01A1
	dc.w	$0305	;0305
	dc.w	$00A1	;00A1
	dc.w	$0103	;0103
	dc.w	$4306	;4306
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$5115	;5115
	dc.w	$0001	;0001
	dc.w	$0305	;0305
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$4206	;4206
	dc.w	$0103	;0103
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$4A91	;4A91
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$4102	;4102
	dc.w	$0000	;0000
	dc.w	$5291	;5291
	dc.w	$0000	;0000
	dc.w	$0D05	;0D05
	dc.w	$0000	;0000
	dc.w	$0F05	;0F05
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0505	;0505
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$21A1	;21A1
	dc.w	$0081	;0081
	dc.w	$3002	;3002
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0102	;0102
	dc.w	$0312	;0312
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1B06	;1B06
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$3315	;3315
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0181	;0181
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C012	;C012
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$3A06	;3A06
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$5002	;5002
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$3012	;3012
	dc.w	$0103	;0103
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$5002	;5002
	dc.w	$00B1	;00B1
	dc.w	$0081	;0081
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$01A1	;01A1
	dc.w	$0001	;0001
	dc.w	$0081	;0081
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0402	;0402
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$1402	;1402
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0712	;0712
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0B06	;0B06
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0081	;0081
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0C12	;0C12
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0C12	;0C12
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0704	;0704
	dc.w	$0191	;0191
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0705	;0705
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C002	;C002
	dc.w	$2FA1	;2FA1
	dc.w	$00A1	;00A1
	dc.w	$00A1	;00A1
	dc.w	$0091	;0091
	dc.w	$0207	;0207
	dc.w	$0207	;0207
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0105	;0105
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0106	;0106
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C002	;C002
	dc.w	$0402	;0402
	dc.w	$0207	;0207
	dc.w	$0207	;0207
	dc.w	$0207	;0207
	dc.w	$0402	;0402
	dc.w	$0706	;0706
	dc.w	$0000	;0000
	dc.w	$0706	;0706
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$FCA1	;FCA1
	dc.w	$FCA1	;FCA1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4002	;4002
	dc.w	$0402	;0402
	dc.w	$0103	;0103
	dc.w	$0207	;0207
	dc.w	$0207	;0207
	dc.w	$0402	;0402
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$D002	;D002
	dc.w	$1002	;1002
	dc.w	$0081	;0081
	dc.w	$0081	;0081
	dc.w	$0081	;0081
	dc.w	$00A1	;00A1
	dc.w	$29A1	;29A1
	dc.w	$0315	;0315
	dc.w	$0081	;0081
	dc.w	$C306	;C306
	dc.w	$0181	;0181
	dc.w	$BB06	;BB06
	dc.w	$00A1	;00A1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0C12	;0C12
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0207	;0207
	dc.w	$0207	;0207
	dc.w	$0207	;0207
	dc.w	$01B1	;01B1
	dc.w	$CA06	;CA06
	dc.w	$0103	;0103
	dc.w	$D206	;D206
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$39B1	;39B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$11B1	;11B1
	dc.w	$02A1	;02A1
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0C12	;0C12
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0C12	;0C12
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$2306	;2306
	dc.w	$0505	;0505
	dc.w	$2A06	;2A06
	dc.w	$02B1	;02B1
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$6115	;6115
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C102	;C102
	dc.w	$0102	;0102
	dc.w	$00A1	;00A1
	dc.w	$00A1	;00A1
	dc.w	$3FA1	;3FA1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$11B1	;11B1
	dc.w	$0281	;0281
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$FC81	;FC81
	dc.w	$FC81	;FC81
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$25B1	;25B1
	dc.w	$0003	;0003
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C002	;C002
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0705	;0705
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0081	;0081
	dc.w	$0081	;0081
	dc.w	$0081	;0081
	dc.w	$0081	;0081
	dc.w	$0003	;0003
	dc.w	$0102	;0102
	dc.w	$0502	;0502
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0091	;0091
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$1002	;1002
	dc.w	$1C12	;1C12
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$3402	;3402
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1002	;1002
	dc.w	$00B1	;00B1
	dc.w	$0103	;0103
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$7115	;7115
	dc.w	$0181	;0181
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0705	;0705
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0103	;0103
	dc.w	$01A1	;01A1
	dc.w	$0081	;0081
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$2FA1	;2FA1
	dc.w	$0305	;0305
	dc.w	$0001	;0001
	dc.w	$0305	;0305
	dc.w	$3FA1	;3FA1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0081	;0081
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$C112	;C112
	dc.w	$0000	;0000
	dc.w	$1DB1	;1DB1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$1315	;1315
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$0505	;0505
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C002	;C002
	dc.w	$2A81	;2A81
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$6206	;6206
	dc.w	$0000	;0000
	dc.w	$6206	;6206
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$8B06	;8B06
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$05A1	;05A1
	dc.w	$05A1	;05A1
	dc.w	$0103	;0103
	dc.w	$05A1	;05A1
	dc.w	$05A1	;05A1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0181	;0181
	dc.w	$9306	;9306
	dc.w	$0181	;0181
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$11A1	;11A1
	dc.w	$0001	;0001
	dc.w	$11A1	;11A1
	dc.w	$0103	;0103
	dc.w	$9B06	;9B06
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3306	;3306
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$49A1	;49A1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$A306	;A306
	dc.w	$0000	;0000
	dc.w	$32B1	;32B1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0781	;0781
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$AA06	;AA06
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$05A1	;05A1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$1191	;1191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$7A00	;7A00
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1191	;1191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$09B1	;09B1
	dc.w	$7115	;7115
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0705	;0705
	dc.w	$0000	;0000
	dc.w	$3306	;3306
	dc.w	$0FB1	;0FB1
	dc.w	$1191	;1191
	dc.w	$6A06	;6A06
	dc.w	$0006	;0006
	dc.w	$1306	;1306
	dc.w	$0006	;0006
	dc.w	$7200	;7200
	dc.w	$09B1	;09B1
	dc.w	$1791	;1791
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1191	;1191
	dc.w	$3306	;3306
	dc.w	$5306	;5306
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$3306	;3306
	dc.w	$3306	;3306
	dc.w	$09B1	;09B1
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$0103	;0103
	dc.w	$1191	;1191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0006	;0006
	dc.w	$8200	;8200
	dc.w	$0006	;0006
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4002	;4002
	dc.w	$5002	;5002
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0D81	;0D81
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$7012	;7012
	dc.w	$4181	;4181
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0207	;0207
	dc.w	$0000	;0000
	dc.w	$1FA1	;1FA1
	dc.w	$0000	;0000
	dc.w	$0207	;0207
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0712	;0712
	dc.w	$0000	;0000
	dc.w	$3D91	;3D91
	dc.w	$0000	;0000
	dc.w	$00B1	;00B1
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0207	;0207
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3306	;3306
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0207	;0207
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$4002	;4002
	dc.w	$1402	;1402
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$5B06	;5B06
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$4402	;4402
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0D81	;0D81
	dc.w	$0D81	;0D81
	dc.w	$0905	;0905
	dc.w	$0D81	;0D81
	dc.w	$0D81	;0D81
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0305	;0305
	dc.w	$0081	;0081
	dc.w	$0305	;0305
	dc.w	$0102	;0102
	dc.w	$01A1	;01A1
	dc.w	$1C12	;1C12
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$4291	;4291
	dc.w	$0000	;0000
	dc.w	$42B1	;42B1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0C02	;0C02
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0103	;0103
	dc.w	$2D91	;2D91
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$00A1	;00A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0003	;0003
	dc.w	$0081	;0081
	dc.w	$0003	;0003
	dc.w	$4002	;4002
	dc.w	$0000	;0000
	dc.w	$0505	;0505
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$2515	;2515
	dc.w	$0000	;0000
	dc.w	$0C12	;0C12
	dc.w	$0C12	;0C12
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0505	;0505
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0505	;0505
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0103	;0103
	dc.w	$0181	;0181
	dc.w	$0103	;0103
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0291	;0291
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$02B1	;02B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$02A1	;02A1
	dc.w	$0001	;0001
	dc.w	$0291	;0291
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$02B1	;02B1
	dc.w	$0001	;0001
	dc.w	$02A1	;02A1
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$02A1	;02A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$02A1	;02A1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0181	;0181
	dc.w	$0105	;0105
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0381	;0381
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0105	;0105
	dc.w	$0181	;0181
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
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
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$03B1	;03B1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0391	;0391
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01B1	;01B1
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
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
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01A1	;01A1
	dc.w	$0105	;0105
	dc.w	$0191	;0191
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
ObjectData_6:
	dc.w	$01DD	;01DD

	dc.w	$C0A2	;C0A2
	dc.w	$0050	;0050
	dc.w	$0180	;0180
	dc.w	$6201	;6201
	dc.w	$5301	;5301
	dc.w	$3901	;3901
	dc.w	$C06C	;C06C
	dc.w	$0152	;0152
	dc.w	$0116	;0116
	dc.w	$0182	;0182
	dc.w	$6200	;6200
	dc.w	$1601	;1601
	dc.w	$0262	;0262
	dc.w	$0016	;0016
	dc.w	$01C2	;01C2
	dc.w	$6E01	;6E01
	dc.w	$5101	;5101
	dc.w	$1701	;1701
	dc.w	$C22A	;C22A
	dc.w	$0104	;0104
	dc.w	$0834	;0834
	dc.w	$0102	;0102
	dc.w	$7E00	;7E00
	dc.w	$1A01	;1A01
	dc.w	$C258	;C258
	dc.w	$0001	;0001
	dc.w	$0AC3	;0AC3
	dc.w	$1802	;1802
	dc.w	$5001	;5001
	dc.w	$040A	;040A
	dc.w	$2601	;2601
	dc.w	$041E	;041E
	dc.w	$0004	;0004
	dc.w	$0604	;0604
	dc.w	$4600	;4600
	dc.w	$2101	;2101
	dc.w	$459A	;459A
	dc.w	$0001	;0001
	dc.w	$0A85	;0A85
	dc.w	$9C00	;9C00
	dc.w	$2601	;2601
	dc.w	$0314	;0314
	dc.w	$0131	;0131
	dc.w	$0107	;0107
	dc.w	$0184	;0184
	dc.w	$E200	;E200
	dc.w	$040A	;040A
	dc.w	$42EC	;42EC
	dc.w	$0101	;0101
	dc.w	$0A04	;0A04
	dc.w	$0AC5	;0AC5
	dc.w	$5A01	;5A01
	dc.w	$0A01	;0A01
	dc.w	$1601	;1601
	dc.w	$049A	;049A
	dc.w	$0155	;0155
	dc.w	$0116	;0116
	dc.w	$0105	;0105
	dc.w	$3A00	;3A00
	dc.w	$3901	;3901
	dc.w	$449A	;449A
	dc.w	$0019	;0019
	dc.w	$0185	;0185
	dc.w	$5A00	;5A00
	dc.w	$1801	;1801
	dc.w	$04DA	;04DA
	dc.w	$0034	;0034
	dc.w	$01C4	;01C4
	dc.w	$6800	;6800
	dc.w	$1801	;1801
	dc.w	$C45C	;C45C
	dc.w	$0019	;0019
	dc.w	$0141	;0141
	dc.w	$6600	;6600
	dc.w	$1601	;1601
	dc.w	$0170	;0170
	dc.w	$0004	;0004
	dc.w	$0A82	;0A82
	dc.w	$0A00	;0A00
	dc.w	$2F01	;2F01
	dc.w	$0230	;0230
	dc.w	$0202	;0202
	dc.w	$0504	;0504
	dc.w	$0A16	;0A16
	dc.w	$0181	;0181
	dc.w	$5200	;5200
	dc.w	$2F01	;2F01
	dc.w	$4150	;4150
	dc.w	$0002	;0002
	dc.w	$0781	;0781
	dc.w	$B401	;B401
	dc.w	$0205	;0205
	dc.w	$1601	;1601
	dc.w	$C150	;C150
	dc.w	$0001	;0001
	dc.w	$0A00	;0A00
	dc.w	$F400	;F400
	dc.w	$0405	;0405
	dc.w	$01AE	;01AE
	dc.w	$0254	;0254
	dc.w	$0101	;0101
	dc.w	$0A17	;0A17
	dc.w	$0101	;0101
	dc.w	$B400	;B400
	dc.w	$1A01	;1A01
	dc.w	$C188	;C188
	dc.w	$0016	;0016
	dc.w	$01C3	;01C3
	dc.w	$3201	;3201
	dc.w	$5101	;5101
	dc.w	$3A01	;3A01
	dc.w	$034C	;034C
	dc.w	$0016	;0016
	dc.w	$0182	;0182
	dc.w	$D800	;D800
	dc.w	$2101	;2101
	dc.w	$C3B8	;C3B8
	dc.w	$0104	;0104
	dc.w	$0A16	;0A16
	dc.w	$0144	;0144
	dc.w	$5001	;5001
	dc.w	$0406	;0406
	dc.w	$0205	;0205
	dc.w	$05F4	;05F4
	dc.w	$010D	;010D
	dc.w	$0102	;0102
	dc.w	$0285	;0285
	dc.w	$B801	;B801
	dc.w	$5301	;5301
	dc.w	$1601	;1601
	dc.w	$4662	;4662
	dc.w	$0052	;0052
	dc.w	$0107	;0107
	dc.w	$EC02	;EC02
	dc.w	$0205	;0205
	dc.w	$010C	;010C
	dc.w	$040F	;040F
	dc.w	$8808	;8808
	dc.w	$0004	;0004
	dc.w	$0F48	;0F48
	dc.w	$0600	;0600
	dc.w	$010C	;010C
	dc.w	$8850	;8850
	dc.w	$0002	;0002
	dc.w	$0407	;0407
	dc.w	$F800	;F800
	dc.w	$5401	;5401
	dc.w	$07FC	;07FC
	dc.w	$0101	;0101
	dc.w	$0A16	;0A16
	dc.w	$0146	;0146
	dc.w	$EC00	;EC00
	dc.w	$5601	;5601
	dc.w	$C6C4	;C6C4
	dc.w	$0016	;0016
	dc.w	$0186	;0186
	dc.w	$C400	;C400
	dc.w	$0404	;0404
	dc.w	$4636	;4636
	dc.w	$001A	;001A
	dc.w	$01C6	;01C6
	dc.w	$3600	;3600
	dc.w	$1701	;1701
	dc.w	$C610	;C610
	dc.w	$001A	;001A
	dc.w	$0146	;0146
	dc.w	$1000	;1000
	dc.w	$1701	;1701
	dc.w	$0736	;0736
	dc.w	$0055	;0055
	dc.w	$01C9	;01C9
	dc.w	$3401	;3401
	dc.w	$040E	;040E
	dc.w	$0101	;0101
	dc.w	$095A	;095A
	dc.w	$0002	;0002
	dc.w	$04C8	;04C8
	dc.w	$B000	;B000
	dc.w	$2F01	;2F01
	dc.w	$C9BA	;C9BA
	dc.w	$002F	;002F
	dc.w	$010A	;010A
	dc.w	$2A00	;2A00
	dc.w	$1901	;1901
	dc.w	$0A28	;0A28
	dc.w	$0017	;0017
	dc.w	$01C9	;01C9
	dc.w	$B800	;B800
	dc.w	$1A01	;1A01
	dc.w	$0A2C	;0A2C
	dc.w	$0018	;0018
	dc.w	$010A	;010A
	dc.w	$0000	;0000
	dc.w	$1601	;1601
	dc.w	$C8D0	;C8D0
	dc.w	$0016	;0016
	dc.w	$0109	;0109
	dc.w	$D800	;D800
	dc.w	$1601	;1601
	dc.w	$C8AE	;C8AE
	dc.w	$0019	;0019
	dc.w	$0149	;0149
	dc.w	$2200	;2200
	dc.w	$1701	;1701
	dc.w	$C8F2	;C8F2
	dc.w	$001A	;001A
	dc.w	$01C8	;01C8
	dc.w	$F400	;F400
	dc.w	$1801	;1801
	dc.w	$0920	;0920
	dc.w	$0016	;0016
	dc.w	$010A	;010A
	dc.w	$2E01	;2E01
	dc.w	$5001	;5001
	dc.w	$2301	;2301
	dc.w	$0924	;0924
	dc.w	$0156	;0156
	dc.w	$0123	;0123
	dc.w	$018A	;018A
	dc.w	$9C00	;9C00
	dc.w	$0205	;0205
	dc.w	$CB1E	;CB1E
	dc.w	$0001	;0001
	dc.w	$0AC9	;0AC9
	dc.w	$2600	;2600
	dc.w	$5F01	;5F01
	dc.w	$48B2	;48B2
	dc.w	$002B	;002B
	dc.w	$01CD	;01CD
	dc.w	$3000	;3000
	dc.w	$0205	;0205
	dc.w	$0DA4	;0DA4
	dc.w	$0002	;0002
	dc.w	$04CD	;04CD
	dc.w	$EE00	;EE00
	dc.w	$5101	;5101
	dc.w	$8CEE	;8CEE
	dc.w	$0001	;0001
	dc.w	$0A0D	;0A0D
	dc.w	$44FF	;44FF
	dc.w	$4C00	;4C00
	dc.w	$4100	;4100
	dc.w	$4000	;4000
	dc.w	$4501	;4501
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
adrEA01674C:
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
adrEA0167CC:
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
adrEA01684C:
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
adrEA01694C:
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
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
BigMonsterList:
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
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrEA016B4C:
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
adrEA016B6C:
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
adrEA01737E:
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrW_01738E:
	dc.w	$FFFF	;FFFF
adrEA017390:
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
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrW_0173F4:
	dc.w	$0000	;0000
adrEA0173F6:
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
adrEA0174F8:
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
MonsterTotalsCounts:
	INCBIN bw-data/monsters.totals

MonsterData_1:
	dc.w	$040B	;040B
	dc.w	$0F00	;0F00
	dc.w	$15FF	;15FF
	dc.w	$0416	;0416
	dc.w	$1A00	;1A00
	dc.w	$16FF	;16FF
	dc.w	$0502	;0502
	dc.w	$0004	;0004
	dc.w	$15FF	;15FF
	dc.w	$040F	;040F
	dc.w	$0F00	;0F00
	dc.w	$2FFF	;2FFF
	dc.w	$1403	;1403
	dc.w	$0900	;0900
	dc.w	$11FF	;11FF
	dc.w	$0406	;0406
	dc.w	$0001	;0001
	dc.w	$14FF	;14FF
	dc.w	$0406	;0406
	dc.w	$0100	;0100
	dc.w	$14FF	;14FF
	dc.w	$0406	;0406
	dc.w	$0301	;0301
	dc.w	$14FF	;14FF
	dc.w	$0406	;0406
	dc.w	$0400	;0400
	dc.w	$14FF	;14FF
	dc.w	$140A	;140A
	dc.w	$0101	;0101
	dc.w	$12FF	;12FF
	dc.w	$140F	;140F
	dc.w	$0102	;0102
	dc.w	$1FFF	;1FFF
	dc.w	$0415	;0415
	dc.w	$0000	;0000
	dc.w	$2900	;2900
	dc.w	$14FF	;14FF
	dc.w	$0001	;0001
	dc.w	$1201	;1201
	dc.w	$041E	;041E
	dc.w	$0201	;0201
	dc.w	$10FF	;10FF
	dc.w	$041E	;041E
	dc.w	$0402	;0402
	dc.w	$68FF	;68FF
	dc.w	$1413	;1413
	dc.w	$0303	;0303
	dc.w	$65FF	;65FF
	dc.w	$041B	;041B
	dc.w	$0C02	;0C02
	dc.w	$68FF	;68FF
	dc.w	$1418	;1418
	dc.w	$0C02	;0C02
	dc.w	$38FF	;38FF
	dc.w	$1417	;1417
	dc.w	$1802	;1802
	dc.w	$4B04	;4B04
	dc.w	$04FF	;04FF
	dc.w	$1801	;1801
	dc.w	$1105	;1105
	dc.w	$141E	;141E
	dc.w	$1202	;1202
	dc.w	$65FF	;65FF
	dc.w	$141E	;141E
	dc.w	$1102	;1102
	dc.w	$65FF	;65FF
	dc.w	$041A	;041A
	dc.w	$1901	;1901
	dc.w	$31FF	;31FF
	dc.w	$0419	;0419
	dc.w	$1E02	;1E02
	dc.w	$2FFF	;2FFF
	dc.w	$1413	;1413
	dc.w	$1C03	;1C03
	dc.w	$25FF	;25FF
	dc.w	$1416	;1416
	dc.w	$0F01	;0F01
	dc.w	$13FF	;13FF
	dc.w	$0410	;0410
	dc.w	$1501	;1501
	dc.w	$13FF	;13FF
	dc.w	$1417	;1417
	dc.w	$1402	;1402
	dc.w	$30FF	;30FF
	dc.w	$0411	;0411
	dc.w	$1002	;1002
	dc.w	$68FF	;68FF
	dc.w	$0415	;0415
	dc.w	$0E02	;0E02
	dc.w	$68FF	;68FF
	dc.w	$030B	;030B
	dc.w	$0303	;0303
	dc.w	$1DFF	;1DFF
	dc.w	$1300	;1300
	dc.w	$0302	;0302
	dc.w	$1FFF	;1FFF
	dc.w	$030D	;030D
	dc.w	$0202	;0202
	dc.w	$29FF	;29FF
	dc.w	$030E	;030E
	dc.w	$0102	;0102
	dc.w	$12FF	;12FF
	dc.w	$1308	;1308
	dc.w	$0D02	;0D02
	dc.w	$1FFF	;1FFF
	dc.w	$030A	;030A
	dc.w	$0C02	;0C02
	dc.w	$50FF	;50FF
	dc.w	$030C	;030C
	dc.w	$0E03	;0E03
	dc.w	$68FF	;68FF
	dc.w	$0300	;0300
	dc.w	$0402	;0402
	dc.w	$34FF	;34FF
	dc.w	$1300	;1300
	dc.w	$0E03	;0E03
	dc.w	$65FF	;65FF
	dc.w	$0301	;0301
	dc.w	$0903	;0903
	dc.w	$45FF	;45FF
	dc.w	$1200	;1200
	dc.w	$0B02	;0B02
	dc.w	$6AFF	;6AFF
	dc.w	$0203	;0203
	dc.w	$0A03	;0A03
	dc.w	$4AFF	;4AFF
	dc.w	$0204	;0204
	dc.w	$1002	;1002
	dc.w	$11FF	;11FF
	dc.w	$0206	;0206
	dc.w	$1102	;1102
	dc.w	$11FF	;11FF
	dc.w	$0211	;0211
	dc.w	$1203	;1203
	dc.w	$4AFF	;4AFF
	dc.w	$0209	;0209
	dc.w	$0F02	;0F02
	dc.w	$11FF	;11FF
	dc.w	$020A	;020A
	dc.w	$0B02	;0B02
	dc.w	$4AFF	;4AFF
	dc.w	$0210	;0210
	dc.w	$1102	;1102
	dc.w	$48FF	;48FF
	dc.w	$020C	;020C
	dc.w	$1403	;1403
	dc.w	$14FF	;14FF
	dc.w	$0213	;0213
	dc.w	$0003	;0003
	dc.w	$14FF	;14FF
	dc.w	$1201	;1201
	dc.w	$0603	;0603
	dc.w	$3CFF	;3CFF
	dc.w	$0204	;0204
	dc.w	$0502	;0502
	dc.w	$68FF	;68FF
	dc.w	$1205	;1205
	dc.w	$0103	;0103
	dc.w	$6AFF	;6AFF
	dc.w	$1208	;1208
	dc.w	$0704	;0704
	dc.w	$6AFF	;6AFF
	dc.w	$120C	;120C
	dc.w	$0003	;0003
	dc.w	$43FF	;43FF
	dc.w	$0213	;0213
	dc.w	$1002	;1002
	dc.w	$11FF	;11FF
	dc.w	$0214	;0214
	dc.w	$0C02	;0C02
	dc.w	$4BFF	;4BFF
	dc.w	$020C	;020C
	dc.w	$0A02	;0A02
	dc.w	$48FF	;48FF
	dc.w	$150A	;150A
	dc.w	$0303	;0303
	dc.w	$4408	;4408
	dc.w	$05FF	;05FF
	dc.w	$0303	;0303
	dc.w	$4409	;4409
	dc.w	$0507	;0507
	dc.w	$0004	;0004
	dc.w	$12FF	;12FF
	dc.w	$1510	;1510
	dc.w	$0403	;0403
	dc.w	$320C	;320C
	dc.w	$05FF	;05FF
	dc.w	$0404	;0404
	dc.w	$320D	;320D
	dc.w	$15FF	;15FF
	dc.w	$0403	;0403
	dc.w	$320E	;320E
	dc.w	$1512	;1512
	dc.w	$0704	;0704
	dc.w	$6AFF	;6AFF
	dc.w	$150F	;150F
	dc.w	$0804	;0804
	dc.w	$26FF	;26FF
	dc.w	$0500	;0500
	dc.w	$0B04	;0B04
	dc.w	$68FF	;68FF
	dc.w	$1500	;1500
	dc.w	$0E04	;0E04
	dc.w	$6AFF	;6AFF
	dc.w	$0500	;0500
	dc.w	$1104	;1104
	dc.w	$50FF	;50FF
	dc.w	$0501	;0501
	dc.w	$1203	;1203
	dc.w	$68FF	;68FF
	dc.w	$1507	;1507
	dc.w	$1204	;1204
	dc.w	$65FF	;65FF
	dc.w	$0506	;0506
	dc.w	$0904	;0904
	dc.w	$25FF	;25FF
	dc.w	$150B	;150B
	dc.w	$0A04	;0A04
	dc.w	$66FF	;66FF
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
	dc.w	$1200	;1200
	dc.w	$0003	;0003
	dc.w	$44FF	;44FF
	dc.w	$0200	;0200
	dc.w	$0103	;0103
	dc.w	$30FF	;30FF
	dc.w	$020A	;020A
	dc.w	$0404	;0404
	dc.w	$68FF	;68FF
	dc.w	$1213	;1213
	dc.w	$0004	;0004
	dc.w	$20FF	;20FF
	dc.w	$020F	;020F
	dc.w	$0604	;0604
	dc.w	$49FF	;49FF
	dc.w	$020F	;020F
	dc.w	$0703	;0703
	dc.w	$4AFF	;4AFF
	dc.w	$1208	;1208
	dc.w	$1304	;1304
	dc.w	$65FF	;65FF
	dc.w	$0208	;0208
	dc.w	$1005	;1005
	dc.w	$68FF	;68FF
	dc.w	$1208	;1208
	dc.w	$0605	;0605
	dc.w	$6600	;6600
	dc.w	$12FF	;12FF
	dc.w	$0604	;0604
	dc.w	$6601	;6601
	dc.w	$0200	;0200
	dc.w	$1205	;1205
	dc.w	$1004	;1004
	dc.w	$02FF	;02FF
	dc.w	$1204	;1204
	dc.w	$4B05	;4B05
	dc.w	$1207	;1207
	dc.w	$0E06	;0E06
	dc.w	$3DFF	;3DFF
	dc.w	$1213	;1213
	dc.w	$0A06	;0A06
	dc.w	$6AFF	;6AFF
	dc.w	$0211	;0211
	dc.w	$0A06	;0A06
	dc.w	$68FF	;68FF
	dc.w	$1214	;1214
	dc.w	$0305	;0305
	dc.w	$25FF	;25FF
	dc.w	$1302	;1302
	dc.w	$0C06	;0C06
	dc.w	$6AFF	;6AFF
	dc.w	$0308	;0308
	dc.w	$0505	;0505
	dc.w	$68FF	;68FF
	dc.w	$030B	;030B
	dc.w	$0A04	;0A04
	dc.w	$68FF	;68FF
	dc.w	$0300	;0300
	dc.w	$0704	;0704
	dc.w	$480C	;480C
	dc.w	$03FF	;03FF
	dc.w	$0705	;0705
	dc.w	$490D	;490D
	dc.w	$1300	;1300
	dc.w	$0004	;0004
	dc.w	$6530	;6530
	dc.w	$03FF	;03FF
	dc.w	$0004	;0004
	dc.w	$4931	;4931
	dc.w	$1310	;1310
	dc.w	$0D05	;0D05
	dc.w	$21FF	;21FF
	dc.w	$1310	;1310
	dc.w	$0F04	;0F04
	dc.w	$66FF	;66FF
	dc.w	$0300	;0300
	dc.w	$0B03	;0B03
	dc.w	$1CFF	;1CFF
	dc.w	$0301	;0301
	dc.w	$0F04	;0F04
	dc.w	$29FF	;29FF
	dc.w	$0305	;0305
	dc.w	$0F03	;0F03
	dc.w	$1FFF	;1FFF
	dc.w	$0403	;0403
	dc.w	$0603	;0603
	dc.w	$35FF	;35FF
	dc.w	$1404	;1404
	dc.w	$0903	;0903
	dc.w	$21FF	;21FF
	dc.w	$040A	;040A
	dc.w	$0404	;0404
	dc.w	$54FF	;54FF
	dc.w	$0410	;0410
	dc.w	$0004	;0004
	dc.w	$6AFF	;6AFF
	dc.w	$1404	;1404
	dc.w	$1004	;1004
	dc.w	$6608	;6608
	dc.w	$04FF	;04FF
	dc.w	$1003	;1003
	dc.w	$2009	;2009
	dc.w	$14FF	;14FF
	dc.w	$1004	;1004
	dc.w	$3C0A	;3C0A
	dc.w	$04FF	;04FF
	dc.w	$1003	;1003
	dc.w	$1C0B	;1C0B
	dc.w	$3400	;3400
	dc.w	$0505	;0505
	dc.w	$65FF	;65FF
	dc.w	$1405	;1405
	dc.w	$0004	;0004
	dc.w	$6AFF	;6AFF
	dc.w	$1409	;1409
	dc.w	$0204	;0204
	dc.w	$382C	;382C
	dc.w	$04FF	;04FF
	dc.w	$0A03	;0A03
	dc.w	$342D	;342D
	dc.w	$04FF	;04FF
	dc.w	$1204	;1204
	dc.w	$322E	;322E
	dc.w	$140B	;140B
	dc.w	$0A06	;0A06
	dc.w	$6610	;6610
	dc.w	$14FF	;14FF
	dc.w	$0A06	;0A06
	dc.w	$2711	;2711
	dc.w	$0509	;0509
	dc.w	$0D05	;0D05
	dc.w	$68FF	;68FF
	dc.w	$050B	;050B
	dc.w	$0E04	;0E04
	dc.w	$68FF	;68FF
	dc.w	$1500	;1500
	dc.w	$0005	;0005
	dc.w	$2214	;2214
	dc.w	$05FF	;05FF
	dc.w	$0005	;0005
	dc.w	$3615	;3615
	dc.w	$1500	;1500
	dc.w	$0C05	;0C05
	dc.w	$6518	;6518
	dc.w	$15FF	;15FF
	dc.w	$0C04	;0C04
	dc.w	$6519	;6519
	dc.w	$15FF	;15FF
	dc.w	$0C04	;0C04
	dc.w	$651A	;651A
	dc.w	$1809	;1809
	dc.w	$0007	;0007
	dc.w	$6AFF	;6AFF
	dc.w	$0800	;0800
	dc.w	$0306	;0306
	dc.w	$2E1C	;2E1C
	dc.w	$08FF	;08FF
	dc.w	$0305	;0305
	dc.w	$2D1D	;2D1D
	dc.w	$08FF	;08FF
	dc.w	$0305	;0305
	dc.w	$2D1E	;2D1E
	dc.w	$08FF	;08FF
	dc.w	$0305	;0305
	dc.w	$2D1F	;2D1F
	dc.w	$080C	;080C
	dc.w	$0006	;0006
	dc.w	$2E20	;2E20
	dc.w	$08FF	;08FF
	dc.w	$0006	;0006
	dc.w	$2E21	;2E21
	dc.w	$08FF	;08FF
	dc.w	$0005	;0005
	dc.w	$2D22	;2D22
	dc.w	$08FF	;08FF
	dc.w	$0005	;0005
	dc.w	$2D23	;2D23
	dc.w	$080A	;080A
	dc.w	$0605	;0605
	dc.w	$68FF	;68FF
	dc.w	$0804	;0804
	dc.w	$0606	;0606
	dc.w	$68FF	;68FF
	dc.w	$0705	;0705
	dc.w	$0106	;0106
	dc.w	$2EFF	;2EFF
	dc.w	$0706	;0706
	dc.w	$0106	;0106
	dc.w	$45FF	;45FF
	dc.w	$1707	;1707
	dc.w	$0006	;0006
	dc.w	$6534	;6534
	dc.w	$07FF	;07FF
	dc.w	$0006	;0006
	dc.w	$4835	;4835
	dc.w	$1700	;1700
	dc.w	$0C05	;0C05
	dc.w	$6624	;6624
	dc.w	$17FF	;17FF
	dc.w	$0C07	;0C07
	dc.w	$6625	;6625
	dc.w	$17FF	;17FF
	dc.w	$0C06	;0C06
	dc.w	$6626	;6626
	dc.w	$17FF	;17FF
	dc.w	$0C07	;0C07
	dc.w	$6627	;6627
	dc.w	$070C	;070C
	dc.w	$0A07	;0A07
	dc.w	$68FF	;68FF
	dc.w	$060B	;060B
	dc.w	$0207	;0207
	dc.w	$47FF	;47FF
	dc.w	$060A	;060A
	dc.w	$0107	;0107
	dc.w	$47FF	;47FF
	dc.w	$0609	;0609
	dc.w	$0207	;0207
	dc.w	$47FF	;47FF
	dc.w	$1608	;1608
	dc.w	$0108	;0108
	dc.w	$42FF	;42FF
	dc.w	$1602	;1602
	dc.w	$0308	;0308
	dc.w	$6528	;6528
	dc.w	$16FF	;16FF
	dc.w	$0307	;0307
	dc.w	$6529	;6529
	dc.w	$0605	;0605
	dc.w	$0706	;0706
	dc.w	$68FF	;68FF
	dc.w	$1609	;1609
	dc.w	$0E08	;0E08
	dc.w	$6AFF	;6AFF
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
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0205	;0205
	dc.w	$0C08	;0C08
	dc.w	$15FF	;15FF
	dc.w	$020C	;020C
	dc.w	$0508	;0508
	dc.w	$15FF	;15FF
	dc.w	$1207	;1207
	dc.w	$1207	;1207
	dc.w	$6600	;6600
	dc.w	$12FF	;12FF
	dc.w	$1207	;1207
	dc.w	$6601	;6601
	dc.w	$120D	;120D
	dc.w	$1207	;1207
	dc.w	$6604	;6604
	dc.w	$12FF	;12FF
	dc.w	$1207	;1207
	dc.w	$6605	;6605
	dc.w	$1200	;1200
	dc.w	$0A05	;0A05
	dc.w	$2008	;2008
	dc.w	$02FF	;02FF
	dc.w	$0A05	;0A05
	dc.w	$2D09	;2D09
	dc.w	$02FF	;02FF
	dc.w	$0A05	;0A05
	dc.w	$1C0A	;1C0A
	dc.w	$0200	;0200
	dc.w	$1407	;1407
	dc.w	$68FF	;68FF
	dc.w	$0203	;0203
	dc.w	$1406	;1406
	dc.w	$68FF	;68FF
	dc.w	$0205	;0205
	dc.w	$1406	;1406
	dc.w	$68FF	;68FF
	dc.w	$0214	;0214
	dc.w	$1405	;1405
	dc.w	$550C	;550C
	dc.w	$02FF	;02FF
	dc.w	$1406	;1406
	dc.w	$360D	;360D
	dc.w	$0211	;0211
	dc.w	$1406	;1406
	dc.w	$2010	;2010
	dc.w	$02FF	;02FF
	dc.w	$1405	;1405
	dc.w	$4811	;4811
	dc.w	$020F	;020F
	dc.w	$0B05	;0B05
	dc.w	$68FF	;68FF
	dc.w	$120C	;120C
	dc.w	$1407	;1407
	dc.w	$65FF	;65FF
	dc.w	$120A	;120A
	dc.w	$0606	;0606
	dc.w	$67FF	;67FF
	dc.w	$030A	;030A
	dc.w	$0006	;0006
	dc.w	$68FF	;68FF
	dc.w	$1300	;1300
	dc.w	$0007	;0007
	dc.w	$4214	;4214
	dc.w	$03FF	;03FF
	dc.w	$0007	;0007
	dc.w	$4715	;4715
	dc.w	$1300	;1300
	dc.w	$0B06	;0B06
	dc.w	$67FF	;67FF
	dc.w	$0310	;0310
	dc.w	$0B07	;0B07
	dc.w	$67FF	;67FF
	dc.w	$030F	;030F
	dc.w	$0A06	;0A06
	dc.w	$68FF	;68FF
	dc.w	$130A	;130A
	dc.w	$0D07	;0D07
	dc.w	$6AFF	;6AFF
	dc.w	$1300	;1300
	dc.w	$0D07	;0D07
	dc.w	$6618	;6618
	dc.w	$13FF	;13FF
	dc.w	$0D06	;0D06
	dc.w	$6619	;6619
	dc.w	$03FF	;03FF
	dc.w	$0D08	;0D08
	dc.w	$281A	;281A
	dc.w	$03FF	;03FF
	dc.w	$0D06	;0D06
	dc.w	$271B	;271B
	dc.w	$030B	;030B
	dc.w	$1307	;1307
	dc.w	$331C	;331C
	dc.w	$03FF	;03FF
	dc.w	$1307	;1307
	dc.w	$321D	;321D
	dc.w	$130D	;130D
	dc.w	$1307	;1307
	dc.w	$3AFF	;3AFF
	dc.w	$0312	;0312
	dc.w	$0F07	;0F07
	dc.w	$67FF	;67FF
	dc.w	$030E	;030E
	dc.w	$0F07	;0F07
	dc.w	$67FF	;67FF
	dc.w	$040E	;040E
	dc.w	$0206	;0206
	dc.w	$1420	;1420
	dc.w	$04FF	;04FF
	dc.w	$0206	;0206
	dc.w	$1421	;1421
	dc.w	$040E	;040E
	dc.w	$0306	;0306
	dc.w	$1424	;1424
	dc.w	$04FF	;04FF
	dc.w	$0306	;0306
	dc.w	$1425	;1425
	dc.w	$040E	;040E
	dc.w	$0406	;0406
	dc.w	$1428	;1428
	dc.w	$04FF	;04FF
	dc.w	$0406	;0406
	dc.w	$1429	;1429
	dc.w	$040D	;040D
	dc.w	$0006	;0006
	dc.w	$1448	;1448
	dc.w	$04FF	;04FF
	dc.w	$0007	;0007
	dc.w	$1449	;1449
	dc.w	$0405	;0405
	dc.w	$0207	;0207
	dc.w	$36FF	;36FF
	dc.w	$040B	;040B
	dc.w	$0107	;0107
	dc.w	$33FF	;33FF
	dc.w	$0403	;0403
	dc.w	$0000	;0000
	dc.w	$662C	;662C
	dc.w	$14FF	;14FF
	dc.w	$0008	;0008
	dc.w	$662D	;662D
	dc.w	$0403	;0403
	dc.w	$0500	;0500
	dc.w	$6630	;6630
	dc.w	$14FF	;14FF
	dc.w	$0508	;0508
	dc.w	$6631	;6631
	dc.w	$1406	;1406
	dc.w	$0E06	;0E06
	dc.w	$6AFF	;6AFF
	dc.w	$1408	;1408
	dc.w	$0E07	;0E07
	dc.w	$67FF	;67FF
	dc.w	$0404	;0404
	dc.w	$1207	;1207
	dc.w	$68FF	;68FF
	dc.w	$1406	;1406
	dc.w	$1207	;1207
	dc.w	$66FF	;66FF
	dc.w	$1408	;1408
	dc.w	$1208	;1208
	dc.w	$6AFF	;6AFF
	dc.w	$140A	;140A
	dc.w	$1208	;1208
	dc.w	$67FF	;67FF
	dc.w	$050D	;050D
	dc.w	$1006	;1006
	dc.w	$5134	;5134
	dc.w	$15FF	;15FF
	dc.w	$1007	;1007
	dc.w	$2035	;2035
	dc.w	$05FF	;05FF
	dc.w	$1007	;1007
	dc.w	$3636	;3636
	dc.w	$05FF	;05FF
	dc.w	$1006	;1006
	dc.w	$2E37	;2E37
	dc.w	$050E	;050E
	dc.w	$1006	;1006
	dc.w	$1038	;1038
	dc.w	$15FF	;15FF
	dc.w	$1007	;1007
	dc.w	$4139	;4139
	dc.w	$05FF	;05FF
	dc.w	$1007	;1007
	dc.w	$1C3A	;1C3A
	dc.w	$05FF	;05FF
	dc.w	$1006	;1006
	dc.w	$553B	;553B
	dc.w	$1502	;1502
	dc.w	$0108	;0108
	dc.w	$67FF	;67FF
	dc.w	$1512	;1512
	dc.w	$0009	;0009
	dc.w	$67FF	;67FF
	dc.w	$0503	;0503
	dc.w	$0E07	;0E07
	dc.w	$68FF	;68FF
	dc.w	$0504	;0504
	dc.w	$0D08	;0D08
	dc.w	$68FF	;68FF
	dc.w	$0602	;0602
	dc.w	$0A08	;0A08
	dc.w	$67FF	;67FF
	dc.w	$0602	;0602
	dc.w	$0608	;0608
	dc.w	$67FF	;67FF
	dc.w	$1605	;1605
	dc.w	$0508	;0508
	dc.w	$6AFF	;6AFF
	dc.w	$060A	;060A
	dc.w	$0408	;0408
	dc.w	$253C	;253C
	dc.w	$16FF	;16FF
	dc.w	$0407	;0407
	dc.w	$3D3D	;3D3D
	dc.w	$06FF	;06FF
	dc.w	$0408	;0408
	dc.w	$473E	;473E
	dc.w	$06FF	;06FF
	dc.w	$0408	;0408
	dc.w	$493F	;493F
	dc.w	$0610	;0610
	dc.w	$0709	;0709
	dc.w	$68FF	;68FF
	dc.w	$060C	;060C
	dc.w	$0608	;0608
	dc.w	$68FF	;68FF
	dc.w	$0606	;0606
	dc.w	$1009	;1009
	dc.w	$67FF	;67FF
	dc.w	$060B	;060B
	dc.w	$0D09	;0D09
	dc.w	$67FF	;67FF
	dc.w	$0700	;0700
	dc.w	$0307	;0307
	dc.w	$3340	;3340
	dc.w	$17FF	;17FF
	dc.w	$0308	;0308
	dc.w	$3941	;3941
	dc.w	$17FF	;17FF
	dc.w	$030A	;030A
	dc.w	$3A42	;3A42
	dc.w	$0700	;0700
	dc.w	$0507	;0507
	dc.w	$3344	;3344
	dc.w	$17FF	;17FF
	dc.w	$0508	;0508
	dc.w	$3945	;3945
	dc.w	$17FF	;17FF
	dc.w	$050A	;050A
	dc.w	$3A46	;3A46
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
	dc.w	$0201	;0201
	dc.w	$1007	;1007
	dc.w	$4C00	;4C00
	dc.w	$02FF	;02FF
	dc.w	$1008	;1008
	dc.w	$5101	;5101
	dc.w	$0201	;0201
	dc.w	$0A07	;0A07
	dc.w	$1F04	;1F04
	dc.w	$02FF	;02FF
	dc.w	$0A08	;0A08
	dc.w	$4F05	;4F05
	dc.w	$1205	;1205
	dc.w	$1408	;1408
	dc.w	$69FF	;69FF
	dc.w	$1200	;1200
	dc.w	$1507	;1507
	dc.w	$67FF	;67FF
	dc.w	$020E	;020E
	dc.w	$1908	;1908
	dc.w	$68FF	;68FF
	dc.w	$021A	;021A
	dc.w	$1A07	;1A07
	dc.w	$2C08	;2C08
	dc.w	$02FF	;02FF
	dc.w	$1A07	;1A07
	dc.w	$2009	;2009
	dc.w	$12FF	;12FF
	dc.w	$1A08	;1A08
	dc.w	$3F0A	;3F0A
	dc.w	$12FF	;12FF
	dc.w	$1A09	;1A09
	dc.w	$650B	;650B
	dc.w	$1216	;1216
	dc.w	$0E09	;0E09
	dc.w	$69FF	;69FF
	dc.w	$1215	;1215
	dc.w	$0F09	;0F09
	dc.w	$6AFF	;6AFF
	dc.w	$1217	;1217
	dc.w	$0408	;0408
	dc.w	$67FF	;67FF
	dc.w	$0211	;0211
	dc.w	$0507	;0507
	dc.w	$200C	;200C
	dc.w	$12FF	;12FF
	dc.w	$0509	;0509
	dc.w	$410D	;410D
	dc.w	$0207	;0207
	dc.w	$0408	;0408
	dc.w	$68FF	;68FF
	dc.w	$0209	;0209
	dc.w	$0308	;0308
	dc.w	$68FF	;68FF
	dc.w	$1208	;1208
	dc.w	$0508	;0508
	dc.w	$2C10	;2C10
	dc.w	$12FF	;12FF
	dc.w	$0509	;0509
	dc.w	$4211	;4211
	dc.w	$12FF	;12FF
	dc.w	$0508	;0508
	dc.w	$2C12	;2C12
	dc.w	$12FF	;12FF
	dc.w	$050A	;050A
	dc.w	$4213	;4213
	dc.w	$120C	;120C
	dc.w	$0709	;0709
	dc.w	$6614	;6614
	dc.w	$12FF	;12FF
	dc.w	$070A	;070A
	dc.w	$6615	;6615
	dc.w	$0300	;0300
	dc.w	$0C09	;0C09
	dc.w	$69FF	;69FF
	dc.w	$0301	;0301
	dc.w	$0C09	;0C09
	dc.w	$69FF	;69FF
	dc.w	$1306	;1306
	dc.w	$030A	;030A
	dc.w	$69FF	;69FF
	dc.w	$030D	;030D
	dc.w	$0409	;0409
	dc.w	$68FF	;68FF
	dc.w	$0311	;0311
	dc.w	$0608	;0608
	dc.w	$68FF	;68FF
	dc.w	$0312	;0312
	dc.w	$1208	;1208
	dc.w	$2D18	;2D18
	dc.w	$03FF	;03FF
	dc.w	$1208	;1208
	dc.w	$5119	;5119
	dc.w	$13FF	;13FF
	dc.w	$120A	;120A
	dc.w	$661A	;661A
	dc.w	$030B	;030B
	dc.w	$0D08	;0D08
	dc.w	$331C	;331C
	dc.w	$03FF	;03FF
	dc.w	$0D08	;0D08
	dc.w	$4E1D	;4E1D
	dc.w	$03FF	;03FF
	dc.w	$0D0A	;0D0A
	dc.w	$211E	;211E
	dc.w	$1300	;1300
	dc.w	$1209	;1209
	dc.w	$2620	;2620
	dc.w	$13FF	;13FF
	dc.w	$1209	;1209
	dc.w	$2621	;2621
	dc.w	$0404	;0404
	dc.w	$060A	;060A
	dc.w	$67FF	;67FF
	dc.w	$0405	;0405
	dc.w	$0809	;0809
	dc.w	$2824	;2824
	dc.w	$14FF	;14FF
	dc.w	$0809	;0809
	dc.w	$6625	;6625
	dc.w	$1410	;1410
	dc.w	$0F0A	;0F0A
	dc.w	$41FF	;41FF
	dc.w	$0400	;0400
	dc.w	$0A0A	;0A0A
	dc.w	$68FF	;68FF
	dc.w	$1400	;1400
	dc.w	$0009	;0009
	dc.w	$6AFF	;6AFF
	dc.w	$0400	;0400
	dc.w	$1009	;1009
	dc.w	$68FF	;68FF
	dc.w	$4500	;4500
	dc.w	$030B	;030B
	dc.w	$00FF	;00FF
	dc.w	$050A	;050A
	dc.w	$100A	;100A
	dc.w	$5328	;5328
	dc.w	$05FF	;05FF
	dc.w	$100B	;100B
	dc.w	$5329	;5329
	dc.w	$050A	;050A
	dc.w	$0E0A	;0E0A
	dc.w	$532C	;532C
	dc.w	$05FF	;05FF
	dc.w	$0E0B	;0E0B
	dc.w	$532D	;532D
	dc.w	$050F	;050F
	dc.w	$0A0A	;0A0A
	dc.w	$68FF	;68FF
	dc.w	$1509	;1509
	dc.w	$030A	;030A
	dc.w	$69FF	;69FF
	dc.w	$0507	;0507
	dc.w	$020A	;020A
	dc.w	$67FF	;67FF
	dc.w	$1600	;1600
	dc.w	$000A	;000A
	dc.w	$6AFF	;6AFF
	dc.w	$1601	;1601
	dc.w	$0C0A	;0C0A
	dc.w	$67FF	;67FF
	dc.w	$160B	;160B
	dc.w	$0C08	;0C08
	dc.w	$4130	;4130
	dc.w	$06FF	;06FF
	dc.w	$0C0A	;0C0A
	dc.w	$3731	;3731
	dc.w	$06FF	;06FF
	dc.w	$0C09	;0C09
	dc.w	$5332	;5332
	dc.w	$16FF	;16FF
	dc.w	$0C0A	;0C0A
	dc.w	$2C33	;2C33
	dc.w	$0608	;0608
	dc.w	$050B	;050B
	dc.w	$69FF	;69FF
	dc.w	$1701	;1701
	dc.w	$070A	;070A
	dc.w	$69FF	;69FF
	dc.w	$170A	;170A
	dc.w	$030B	;030B
	dc.w	$69FF	;69FF
	dc.w	$1702	;1702
	dc.w	$000B	;000B
	dc.w	$69FF	;69FF
	dc.w	$1708	;1708
	dc.w	$000C	;000C
	dc.w	$69FF	;69FF
	dc.w	$0704	;0704
	dc.w	$000A	;000A
	dc.w	$4734	;4734
	dc.w	$07FF	;07FF
	dc.w	$000A	;000A
	dc.w	$4735	;4735
	dc.w	$0706	;0706
	dc.w	$000A	;000A
	dc.w	$4738	;4738
	dc.w	$07FF	;07FF
	dc.w	$000A	;000A
	dc.w	$4739	;4739
	dc.w	$1801	;1801
	dc.w	$030D	;030D
	dc.w	$69FF	;69FF
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
	dc.w	$0207	;0207
	dc.w	$0000	;0000
	dc.w	$16FF	;16FF
	dc.w	$020D	;020D
	dc.w	$1109	;1109
	dc.w	$67FF	;67FF
	dc.w	$0207	;0207
	dc.w	$0B09	;0B09
	dc.w	$69FF	;69FF
	dc.w	$020A	;020A
	dc.w	$0609	;0609
	dc.w	$67FF	;67FF
	dc.w	$0210	;0210
	dc.w	$0609	;0609
	dc.w	$69FF	;69FF
	dc.w	$020A	;020A
	dc.w	$0E09	;0E09
	dc.w	$2B00	;2B00
	dc.w	$02FF	;02FF
	dc.w	$0E09	;0E09
	dc.w	$2401	;2401
	dc.w	$0208	;0208
	dc.w	$0F09	;0F09
	dc.w	$1E04	;1E04
	dc.w	$02FF	;02FF
	dc.w	$0F09	;0F09
	dc.w	$2805	;2805
	dc.w	$1214	;1214
	dc.w	$020A	;020A
	dc.w	$6AFF	;6AFF
	dc.w	$1203	;1203
	dc.w	$0E0A	;0E0A
	dc.w	$69FF	;69FF
	dc.w	$0204	;0204
	dc.w	$000B	;000B
	dc.w	$2F08	;2F08
	dc.w	$02FF	;02FF
	dc.w	$000B	;000B
	dc.w	$3709	;3709
	dc.w	$0205	;0205
	dc.w	$000B	;000B
	dc.w	$4D0C	;4D0C
	dc.w	$02FF	;02FF
	dc.w	$000B	;000B
	dc.w	$460D	;460D
	dc.w	$0200	;0200
	dc.w	$030E	;030E
	dc.w	$2A1C	;2A1C
	dc.w	$02FF	;02FF
	dc.w	$030E	;030E
	dc.w	$2B1D	;2B1D
	dc.w	$02FF	;02FF
	dc.w	$030C	;030C
	dc.w	$2B1E	;2B1E
	dc.w	$0502	;0502
	dc.w	$0B0B	;0B0B
	dc.w	$1710	;1710
	dc.w	$05FF	;05FF
	dc.w	$0B0B	;0B0B
	dc.w	$1711	;1711
	dc.w	$0300	;0300
	dc.w	$140C	;140C
	dc.w	$67FF	;67FF
	dc.w	$1500	;1500
	dc.w	$020D	;020D
	dc.w	$3BFF	;3BFF
	dc.w	$0400	;0400
	dc.w	$030D	;030D
	dc.w	$67FF	;67FF
	dc.w	$1300	;1300
	dc.w	$000A	;000A
	dc.w	$6614	;6614
	dc.w	$13FF	;13FF
	dc.w	$000B	;000B
	dc.w	$6615	;6615
	dc.w	$0300	;0300
	dc.w	$080C	;080C
	dc.w	$2B18	;2B18
	dc.w	$03FF	;03FF
	dc.w	$080D	;080D
	dc.w	$2C19	;2C19
	dc.w	$0309	;0309
	dc.w	$0800	;0800
	dc.w	$2520	;2520
	dc.w	$13FF	;13FF
	dc.w	$080C	;080C
	dc.w	$1821	;1821
	dc.w	$13FF	;13FF
	dc.w	$080D	;080D
	dc.w	$1722	;1722
	dc.w	$0308	;0308
	dc.w	$0A00	;0A00
	dc.w	$2724	;2724
	dc.w	$13FF	;13FF
	dc.w	$0A0C	;0A0C
	dc.w	$1825	;1825
	dc.w	$13FF	;13FF
	dc.w	$0A0D	;0A0D
	dc.w	$1726	;1726
	dc.w	$1304	;1304
	dc.w	$000D	;000D
	dc.w	$67FF	;67FF
	dc.w	$130D	;130D
	dc.w	$000D	;000D
	dc.w	$69FF	;69FF
	dc.w	$0303	;0303
	dc.w	$120E	;120E
	dc.w	$52FF	;52FF
	dc.w	$1307	;1307
	dc.w	$120D	;120D
	dc.w	$2328	;2328
	dc.w	$03FF	;03FF
	dc.w	$120E	;120E
	dc.w	$2429	;2429
	dc.w	$1314	;1314
	dc.w	$0F0E	;0F0E
	dc.w	$69FF	;69FF
	dc.w	$030F	;030F
	dc.w	$0D0C	;0D0C
	dc.w	$68FF	;68FF
	dc.w	$030C	;030C
	dc.w	$0E0C	;0E0C
	dc.w	$68FF	;68FF
	dc.w	$0404	;0404
	dc.w	$120C	;120C
	dc.w	$532C	;532C
	dc.w	$14FF	;14FF
	dc.w	$120D	;120D
	dc.w	$412D	;412D
	dc.w	$14FF	;14FF
	dc.w	$120C	;120C
	dc.w	$182E	;182E
	dc.w	$0404	;0404
	dc.w	$0900	;0900
	dc.w	$1130	;1130
	dc.w	$04FF	;04FF
	dc.w	$090C	;090C
	dc.w	$2831	;2831
	dc.w	$14FF	;14FF
	dc.w	$090E	;090E
	dc.w	$4232	;4232
	dc.w	$040D	;040D
	dc.w	$060C	;060C
	dc.w	$1E34	;1E34
	dc.w	$14FF	;14FF
	dc.w	$060D	;060D
	dc.w	$1F35	;1F35
	dc.w	$14FF	;14FF
	dc.w	$060C	;060C
	dc.w	$3F36	;3F36
	dc.w	$0407	;0407
	dc.w	$0300	;0300
	dc.w	$1238	;1238
	dc.w	$04FF	;04FF
	dc.w	$030C	;030C
	dc.w	$2C39	;2C39
	dc.w	$04FF	;04FF
	dc.w	$030E	;030E
	dc.w	$413A	;413A
	dc.w	$050B	;050B
	dc.w	$000B	;000B
	dc.w	$67FF	;67FF
	dc.w	$0506	;0506
	dc.w	$000C	;000C
	dc.w	$4EFF	;4EFF
	dc.w	$0504	;0504
	dc.w	$000C	;000C
	dc.w	$4FFF	;4FFF
	dc.w	$0505	;0505
	dc.w	$0C0D	;0C0D
	dc.w	$69FF	;69FF
	dc.w	$0507	;0507
	dc.w	$0C0B	;0C0B
	dc.w	$67FF	;67FF
	dc.w	$050E	;050E
	dc.w	$0C0B	;0C0B
	dc.w	$69FF	;69FF
	dc.w	$150D	;150D
	dc.w	$0D0E	;0D0E
	dc.w	$67FF	;67FF
	dc.w	$050A	;050A
	dc.w	$0E0C	;0E0C
	dc.w	$17FF	;17FF
	dc.w	$0604	;0604
	dc.w	$070C	;070C
	dc.w	$24FF	;24FF
	dc.w	$0606	;0606
	dc.w	$080C	;080C
	dc.w	$443C	;443C
	dc.w	$06FF	;06FF
	dc.w	$080C	;080C
	dc.w	$453D	;453D
	dc.w	$060A	;060A
	dc.w	$060C	;060C
	dc.w	$2BFF	;2BFF
	dc.w	$0608	;0608
	dc.w	$000D	;000D
	dc.w	$28FF	;28FF
	dc.w	$060C	;060C
	dc.w	$010B	;010B
	dc.w	$5440	;5440
	dc.w	$16FF	;16FF
	dc.w	$010D	;010D
	dc.w	$3E41	;3E41
	dc.w	$060A	;060A
	dc.w	$000C	;000C
	dc.w	$37FF	;37FF
	dc.w	$1604	;1604
	dc.w	$0B0D	;0B0D
	dc.w	$2348	;2348
	dc.w	$06FF	;06FF
	dc.w	$0B0E	;0B0E
	dc.w	$2A49	;2A49
	dc.w	$160A	;160A
	dc.w	$0D0D	;0D0D
	dc.w	$3B4C	;3B4C
	dc.w	$16FF	;16FF
	dc.w	$0D0E	;0D0E
	dc.w	$3B4D	;3B4D
	dc.w	$0700	;0700
	dc.w	$000E	;000E
	dc.w	$67FF	;67FF
	dc.w	$0707	;0707
	dc.w	$020E	;020E
	dc.w	$67FF	;67FF
	dc.w	$1700	;1700
	dc.w	$0A10	;0A10
	dc.w	$69FF	;69FF
	dc.w	$1704	;1704
	dc.w	$080E	;080E
	dc.w	$1944	;1944
	dc.w	$17FF	;17FF
	dc.w	$080F	;080F
	dc.w	$1945	;1945
	dc.w	$17FF	;17FF
	dc.w	$080F	;080F
	dc.w	$1946	;1946
	dc.w	$17FF	;17FF
	dc.w	$080F	;080F
	dc.w	$1947	;1947
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
	dc.w	$1589	;1589
	dc.w	$081E	;081E
	dc.w	$6BFF	;6BFF
	dc.w	$1101	;1101
	dc.w	$0E0E	;0E0E
	dc.w	$69FF	;69FF
	dc.w	$1100	;1100
	dc.w	$040E	;040E
	dc.w	$6AFF	;6AFF
	dc.w	$1105	;1105
	dc.w	$0010	;0010
	dc.w	$21FF	;21FF
	dc.w	$0112	;0112
	dc.w	$030F	;030F
	dc.w	$68FF	;68FF
	dc.w	$010E	;010E
	dc.w	$030F	;030F
	dc.w	$68FF	;68FF
	dc.w	$0107	;0107
	dc.w	$120F	;120F
	dc.w	$2A00	;2A00
	dc.w	$01FF	;01FF
	dc.w	$120F	;120F
	dc.w	$2401	;2401
	dc.w	$110F	;110F
	dc.w	$0F10	;0F10
	dc.w	$6604	;6604
	dc.w	$11FF	;11FF
	dc.w	$0F10	;0F10
	dc.w	$6605	;6605
	dc.w	$110E	;110E
	dc.w	$1010	;1010
	dc.w	$67FF	;67FF
	dc.w	$010E	;010E
	dc.w	$0D12	;0D12
	dc.w	$68FF	;68FF
	dc.w	$0107	;0107
	dc.w	$0B0F	;0B0F
	dc.w	$0F08	;0F08
	dc.w	$11FF	;11FF
	dc.w	$0B0F	;0B0F
	dc.w	$1809	;1809
	dc.w	$01FF	;01FF
	dc.w	$0B0F	;0B0F
	dc.w	$2B0A	;2B0A
	dc.w	$11FF	;11FF
	dc.w	$0B11	;0B11
	dc.w	$3A0B	;3A0B
	dc.w	$0111	;0111
	dc.w	$0810	;0810
	dc.w	$530C	;530C
	dc.w	$01FF	;01FF
	dc.w	$0810	;0810
	dc.w	$450D	;450D
	dc.w	$0109	;0109
	dc.w	$0212	;0212
	dc.w	$67FF	;67FF
	dc.w	$0200	;0200
	dc.w	$100D	;100D
	dc.w	$1110	;1110
	dc.w	$02FF	;02FF
	dc.w	$100D	;100D
	dc.w	$4711	;4711
	dc.w	$0200	;0200
	dc.w	$0F0D	;0F0D
	dc.w	$4814	;4814
	dc.w	$02FF	;02FF
	dc.w	$0F0D	;0F0D
	dc.w	$4915	;4915
	dc.w	$0201	;0201
	dc.w	$0F0D	;0F0D
	dc.w	$4A18	;4A18
	dc.w	$02FF	;02FF
	dc.w	$0F0D	;0F0D
	dc.w	$4B19	;4B19
	dc.w	$0201	;0201
	dc.w	$100D	;100D
	dc.w	$111C	;111C
	dc.w	$02FF	;02FF
	dc.w	$100D	;100D
	dc.w	$471D	;471D
	dc.w	$0202	;0202
	dc.w	$0F0D	;0F0D
	dc.w	$4B20	;4B20
	dc.w	$02FF	;02FF
	dc.w	$0F0D	;0F0D
	dc.w	$4821	;4821
	dc.w	$0202	;0202
	dc.w	$100D	;100D
	dc.w	$4924	;4924
	dc.w	$02FF	;02FF
	dc.w	$100D	;100D
	dc.w	$4A25	;4A25
	dc.w	$020F	;020F
	dc.w	$0311	;0311
	dc.w	$68FF	;68FF
	dc.w	$1200	;1200
	dc.w	$080F	;080F
	dc.w	$69FF	;69FF
	dc.w	$020D	;020D
	dc.w	$090D	;090D
	dc.w	$1728	;1728
	dc.w	$02FF	;02FF
	dc.w	$090D	;090D
	dc.w	$1729	;1729
	dc.w	$1307	;1307
	dc.w	$0412	;0412
	dc.w	$69FF	;69FF
	dc.w	$030B	;030B
	dc.w	$020F	;020F
	dc.w	$69FF	;69FF
	dc.w	$030E	;030E
	dc.w	$010F	;010F
	dc.w	$6AFF	;6AFF
	dc.w	$1303	;1303
	dc.w	$0204	;0204
	dc.w	$662C	;662C
	dc.w	$13FF	;13FF
	dc.w	$0211	;0211
	dc.w	$662D	;662D
	dc.w	$13FF	;13FF
	dc.w	$0210	;0210
	dc.w	$662E	;662E
	dc.w	$13FF	;13FF
	dc.w	$020A	;020A
	dc.w	$662F	;662F
	dc.w	$0305	;0305
	dc.w	$0511	;0511
	dc.w	$67FF	;67FF
	dc.w	$0300	;0300
	dc.w	$0600	;0600
	dc.w	$2630	;2630
	dc.w	$13FF	;13FF
	dc.w	$0611	;0611
	dc.w	$1931	;1931
	dc.w	$13FF	;13FF
	dc.w	$0611	;0611
	dc.w	$1832	;1832
	dc.w	$13FF	;13FF
	dc.w	$0610	;0610
	dc.w	$1933	;1933
	dc.w	$0307	;0307
	dc.w	$0E10	;0E10
	dc.w	$3634	;3634
	dc.w	$03FF	;03FF
	dc.w	$0E10	;0E10
	dc.w	$2235	;2235
	dc.w	$0300	;0300
	dc.w	$1010	;1010
	dc.w	$4338	;4338
	dc.w	$03FF	;03FF
	dc.w	$1010	;1010
	dc.w	$4639	;4639
	dc.w	$0312	;0312
	dc.w	$1211	;1211
	dc.w	$68FF	;68FF
	dc.w	$130D	;130D
	dc.w	$0811	;0811
	dc.w	$533C	;533C
	dc.w	$13FF	;13FF
	dc.w	$0811	;0811
	dc.w	$653D	;653D
	dc.w	$1402	;1402
	dc.w	$0312	;0312
	dc.w	$67FF	;67FF
	dc.w	$0406	;0406
	dc.w	$1011	;1011
	dc.w	$1E40	;1E40
	dc.w	$14FF	;14FF
	dc.w	$1011	;1011
	dc.w	$3F41	;3F41
	dc.w	$0400	;0400
	dc.w	$1112	;1112
	dc.w	$68FF	;68FF
	dc.w	$0403	;0403
	dc.w	$1112	;1112
	dc.w	$68FF	;68FF
	dc.w	$140A	;140A
	dc.w	$0612	;0612
	dc.w	$68FF	;68FF
	dc.w	$140B	;140B
	dc.w	$0C12	;0C12
	dc.w	$3E44	;3E44
	dc.w	$04FF	;04FF
	dc.w	$0C12	;0C12
	dc.w	$2B45	;2B45
	dc.w	$14FF	;14FF
	dc.w	$0C12	;0C12
	dc.w	$3B46	;3B46
	dc.w	$140C	;140C
	dc.w	$0019	;0019
	dc.w	$40FF	;40FF
	dc.w	$1500	;1500
	dc.w	$0714	;0714
	dc.w	$69FF	;69FF
	dc.w	$1509	;1509
	dc.w	$0014	;0014
	dc.w	$67FF	;67FF
	dc.w	$150C	;150C
	dc.w	$0014	;0014
	dc.w	$1A4C	;1A4C
	dc.w	$15FF	;15FF
	dc.w	$0014	;0014
	dc.w	$1A4D	;1A4D
	dc.w	$150D	;150D
	dc.w	$0414	;0414
	dc.w	$1A50	;1A50
	dc.w	$15FF	;15FF
	dc.w	$0414	;0414
	dc.w	$1A51	;1A51
	dc.w	$150C	;150C
	dc.w	$1014	;1014
	dc.w	$1A54	;1A54
	dc.w	$15FF	;15FF
	dc.w	$1014	;1014
	dc.w	$1A55	;1A55
	dc.w	$1506	;1506
	dc.w	$1014	;1014
	dc.w	$1A58	;1A58
	dc.w	$15FF	;15FF
	dc.w	$1014	;1014
	dc.w	$1A59	;1A59
	dc.w	$1503	;1503
	dc.w	$0314	;0314
	dc.w	$1A5C	;1A5C
	dc.w	$15FF	;15FF
	dc.w	$0314	;0314
	dc.w	$1A5D	;1A5D
	dc.w	$1504	;1504
	dc.w	$0014	;0014
	dc.w	$1A48	;1A48
	dc.w	$15FF	;15FF
	dc.w	$0014	;0014
	dc.w	$1A49	;1A49
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
adrL_0186A0:
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
SpellBookRunes:
	dc.b	'mar'	;6D6172

	dc.b	'yhadalittlelaaneeitwerraguddutnerewanzednowtecozzitwerawuddunwhyamistillhavintotypethiscrapwhithoughtidfinishacoupleoflinesq'	;79686164616C6974746C656C61616E6565697477657272616775646475746E65726577616E7A65646E6F777465636F7A7A6974776572617775646
*56E776879616D697374696C6C686176696E746F74797065746869736372617077686974686F75676874696466696E69736861636F75706C656F666C696E657371
	dc.b	'x'	;78
adrEA018804:
	dc.w	$0000	;0000
	dc.w	$01F2	;01F2
	dc.w	$03EB	;03EB
	dc.w	$FCF4	;FCF4
	dc.w	$05F4	;05F4
	dc.w	$0500	;0500
	dc.w	$03F2	;03F2
	dc.w	$03EB	;03EB
	dc.w	$0000	;0000
	dc.w	$FFF4	;FFF4
	dc.w	$0000	;0000
	dc.w	$01F2	;01F2
	dc.w	$03EB	;03EB
	dc.w	$05F4	;05F4
	dc.w	$FCF4	;FCF4
	dc.w	$FC00	;FC00
	dc.w	$FEF2	;FEF2
	dc.w	$FEEB	;FEEB
	dc.w	$02F4	;02F4
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01F4	;01F4
	dc.w	$03EE	;03EE
	dc.w	$FDF6	;FDF6
	dc.w	$02F6	;02F6
	dc.w	$0300	;0300
	dc.w	$02F4	;02F4
	dc.w	$02EE	;02EE
	dc.w	$FFFF	;FFFF
	dc.w	$FCF6	;FCF6
	dc.w	$0000	;0000
	dc.w	$01F4	;01F4
	dc.w	$03EE	;03EE
	dc.w	$02F6	;02F6
	dc.w	$FDF6	;FDF6
	dc.w	$FA00	;FA00
	dc.w	$FBF4	;FBF4
	dc.w	$FBEE	;FBEE
	dc.w	$01F6	;01F6
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$01F6	;01F6
	dc.w	$02F1	;02F1
	dc.w	$FDF8	;FDF8
	dc.w	$FEF8	;FEF8
	dc.w	$0300	;0300
	dc.w	$02F6	;02F6
	dc.w	$03F1	;03F1
	dc.w	$FFFF	;FFFF
	dc.w	$FBF8	;FBF8
	dc.w	$0000	;0000
	dc.w	$01F6	;01F6
	dc.w	$02F1	;02F1
	dc.w	$FEF8	;FEF8
	dc.w	$FDF8	;FDF8
	dc.w	$F800	;F800
	dc.w	$F9F6	;F9F6
	dc.w	$F8F1	;F8F1
	dc.w	$00F8	;00F8
	dc.w	$FFFF	;FFFF
	dc.w	$FF00	;FF00
	dc.w	$00F7	;00F7
	dc.w	$02F3	;02F3
	dc.w	$FDF9	;FDF9
	dc.w	$FCF9	;FCF9
	dc.w	$0200	;0200
	dc.w	$01F7	;01F7
	dc.w	$02F3	;02F3
	dc.w	$FFFF	;FFFF
	dc.w	$F8F9	;F8F9
	dc.w	$FF00	;FF00
	dc.w	$01F7	;01F7
	dc.w	$01F3	;01F3
	dc.w	$FCF9	;FCF9
	dc.w	$FDF9	;FDF9
	dc.w	$F700	;F700
	dc.w	$F8F7	;F8F7
	dc.w	$F6F3	;F6F3
	dc.w	$01F9	;01F9
	dc.w	$FFFF	;FFFF
	dc.w	$1919	;1919
	dc.w	$1915	;1915
	dc.w	$1515	;1515
	dc.w	$1111	;1111
	dc.w	$110E	;110E
	dc.w	$0E0E	;0E0E
	dc.w	$0000	;0000
	dc.w	$00D0	;00D0
	dc.w	$01A0	;01A0
	dc.w	$0270	;0270
	dc.w	$0320	;0320
	dc.w	$03D0	;03D0
	dc.w	$0480	;0480
	dc.w	$0510	;0510
	dc.w	$05A0	;05A0
	dc.w	$0630	;0630
	dc.w	$06A8	;06A8
	dc.w	$0720	;0720
	dc.w	$0D0D	;0D0D
	dc.w	$0D0B	;0D0B
	dc.w	$0B0B	;0B0B
	dc.w	$0909	;0909
	dc.w	$0908	;0908
	dc.w	$0808	;0808
	dc.w	$0000	;0000
	dc.w	$0070	;0070
	dc.w	$00E0	;00E0
	dc.w	$0150	;0150
	dc.w	$01B0	;01B0
	dc.w	$0210	;0210
	dc.w	$0270	;0270
	dc.w	$02C0	;02C0
	dc.w	$0310	;0310
	dc.w	$0360	;0360
	dc.w	$03A8	;03A8
	dc.w	$03F0	;03F0
	dc.w	$0B0B	;0B0B
	dc.w	$0B09	;0B09
	dc.w	$0909	;0909
	dc.w	$0707	;0707
	dc.w	$0706	;0706
	dc.w	$0606	;0606
	dc.w	$0000	;0000
	dc.w	$0060	;0060
	dc.w	$00C0	;00C0
	dc.w	$0120	;0120
	dc.w	$0170	;0170
	dc.w	$01C0	;01C0
	dc.w	$0210	;0210
	dc.w	$0250	;0250
	dc.w	$0290	;0290
	dc.w	$02D0	;02D0
	dc.w	$0308	;0308
	dc.w	$0340	;0340
	dc.w	$1111	;1111
	dc.w	$0D0D	;0D0D
	dc.w	$0D0A	;0D0A
	dc.w	$0B0B	;0B0B
	dc.w	$0809	;0809
	dc.w	$0907	;0907
	dc.w	$0000	;0000
	dc.w	$0090	;0090
	dc.w	$0120	;0120
	dc.w	$0190	;0190
	dc.w	$0200	;0200
	dc.w	$0270	;0270
	dc.w	$02C8	;02C8
	dc.w	$0328	;0328
	dc.w	$0388	;0388
	dc.w	$03D0	;03D0
	dc.w	$0420	;0420
	dc.w	$0470	;0470
adrEA018934:
	dc.w	$0001	;0001
	dc.w	$0501	;0501
	dc.w	$0001	;0001
	dc.w	$F801	;F801
adrEA01893C:
	dc.w	$0000	;0000
	dc.w	$0300	;0300
	dc.w	$0000	;0000
	dc.w	$F600	;F600
adrEA018944:
	dc.w	$0001	;0001
	dc.w	$03F5	;03F5
	dc.w	$03EE	;03EE
	dc.w	$FFF7	;FFF7
	dc.w	$02F7	;02F7
	dc.w	$0501	;0501
	dc.w	$05F5	;05F5
	dc.w	$05EE	;05EE
	dc.w	$0000	;0000
	dc.w	$FEF7	;FEF7
	dc.w	$0001	;0001
	dc.w	$03F5	;03F5
	dc.w	$03EE	;03EE
	dc.w	$02F7	;02F7
	dc.w	$FFF7	;FFF7
	dc.w	$FC01	;FC01
	dc.w	$FCF5	;FCF5
	dc.w	$FCEE	;FCEE
	dc.w	$03F7	;03F7
	dc.w	$0000	;0000
	dc.w	$0101	;0101
	dc.w	$03F8	;03F8
	dc.w	$03F2	;03F2
	dc.w	$FFF9	;FFF9
	dc.w	$00F9	;00F9
	dc.w	$0301	;0301
	dc.w	$03F8	;03F8
	dc.w	$03F2	;03F2
	dc.w	$FFFF	;FFFF
	dc.w	$FBF9	;FBF9
	dc.w	$0101	;0101
	dc.w	$03F8	;03F8
	dc.w	$03F2	;03F2
	dc.w	$00F9	;00F9
	dc.w	$FFF9	;FFF9
	dc.w	$FA01	;FA01
	dc.w	$FAF8	;FAF8
	dc.w	$F9F2	;F9F2
	dc.w	$02F9	;02F9
	dc.w	$FFFF	;FFFF
	dc.w	$FF00	;FF00
	dc.w	$01F9	;01F9
	dc.w	$01F4	;01F4
	dc.w	$FEFB	;FEFB
	dc.w	$FBFB	;FBFB
	dc.w	$0300	;0300
	dc.w	$02F9	;02F9
	dc.w	$03F4	;03F4
	dc.w	$FFFF	;FFFF
	dc.w	$F9FB	;F9FB
	dc.w	$FF00	;FF00
	dc.w	$01F9	;01F9
	dc.w	$01F4	;01F4
	dc.w	$FBFB	;FBFB
	dc.w	$FEFB	;FEFB
	dc.w	$F700	;F700
	dc.w	$F8F9	;F8F9
	dc.w	$F7F4	;F7F4
	dc.w	$01FB	;01FB
	dc.w	$FFFF	;FFFF
	dc.w	$FF00	;FF00
	dc.w	$00F9	;00F9
	dc.w	$01F5	;01F5
	dc.w	$FEFB	;FEFB
	dc.w	$F9FB	;F9FB
	dc.w	$0200	;0200
	dc.w	$02F9	;02F9
	dc.w	$03F5	;03F5
	dc.w	$FFFF	;FFFF
	dc.w	$F8FB	;F8FB
	dc.w	$FF00	;FF00
	dc.w	$00F9	;00F9
	dc.w	$00F5	;00F5
	dc.w	$F9FB	;F9FB
	dc.w	$FEFB	;FEFB
	dc.w	$F700	;F700
	dc.w	$F7F9	;F7F9
	dc.w	$F6F5	;F6F5
	dc.w	$01FB	;01FB
	dc.w	$FFFF	;FFFF
	dc.w	$1818	;1818
	dc.w	$1814	;1814
	dc.w	$1414	;1414
	dc.w	$1111	;1111
	dc.w	$110E	;110E
	dc.w	$0E0E	;0E0E
	dc.w	$0000	;0000
	dc.w	$00C8	;00C8
	dc.w	$0190	;0190
	dc.w	$0258	;0258
	dc.w	$0300	;0300
	dc.w	$03A8	;03A8
	dc.w	$0450	;0450
	dc.w	$04E0	;04E0
	dc.w	$0570	;0570
	dc.w	$0600	;0600
	dc.w	$0678	;0678
	dc.w	$06F0	;06F0
	dc.w	$0B0B	;0B0B
	dc.w	$0B08	;0B08
	dc.w	$0808	;0808
	dc.w	$0606	;0606
	dc.w	$0606	;0606
	dc.w	$0606	;0606
	dc.w	$0000	;0000
	dc.w	$0060	;0060
	dc.w	$00C0	;00C0
	dc.w	$0120	;0120
	dc.w	$0168	;0168
	dc.w	$01B0	;01B0
	dc.w	$01F8	;01F8
	dc.w	$0230	;0230
	dc.w	$0268	;0268
	dc.w	$02A0	;02A0
	dc.w	$02D8	;02D8
	dc.w	$0310	;0310
	dc.w	$0B0B	;0B0B
	dc.w	$0B09	;0B09
	dc.w	$0909	;0909
	dc.w	$0707	;0707
	dc.w	$0706	;0706
	dc.w	$0606	;0606
	dc.w	$0000	;0000
	dc.w	$0060	;0060
	dc.w	$00C0	;00C0
	dc.w	$0120	;0120
	dc.w	$0170	;0170
	dc.w	$01C0	;01C0
	dc.w	$0210	;0210
	dc.w	$0250	;0250
	dc.w	$0290	;0290
	dc.w	$02D0	;02D0
	dc.w	$0308	;0308
	dc.w	$0340	;0340
	dc.w	$0F0F	;0F0F
	dc.w	$0B0C	;0B0C
	dc.w	$0C09	;0C09
	dc.w	$090A	;090A
	dc.w	$0808	;0808
	dc.w	$0806	;0806
	dc.w	$0000	;0000
	dc.w	$0080	;0080
	dc.w	$0100	;0100
	dc.w	$0160	;0160
	dc.w	$01C8	;01C8
	dc.w	$0230	;0230
	dc.w	$0280	;0280
	dc.w	$02D0	;02D0
	dc.w	$0328	;0328
	dc.w	$0370	;0370
	dc.w	$03B8	;03B8
	dc.w	$0400	;0400
adrEA018A74:
	dc.w	$0002	;0002
	dc.w	$0402	;0402
	dc.w	$0002	;0002
	dc.w	$F802	;F802
adrEA018A7C:
	dc.w	$0001	;0001
	dc.w	$0201	;0201
	dc.w	$0001	;0001
	dc.w	$F601	;F601
adrEA018A84:
	dc.w	$01FF	;01FF
	dc.w	$FFFF	;FFFF
	dc.w	$FC20	;FC20
	dc.w	$1215	;1215
	dc.w	$1C18	;1C18
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FF1B	;FF1B
	dc.w	$040C	;040C
	dc.w	$170C	;170C
	dc.w	$0BFF	;0BFF
	dc.w	$FA10	;FA10
	dc.w	$00F8	;00F8
	dc.w	$FFFF	;FFFF
	dc.w	$00F1	;00F1
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$7578	;7578
	dc.w	$FF7A	;FF7A
	dc.w	$6457	;6457
	dc.w	$5A61	;5A61
	dc.w	$5DFF	;5DFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$725A	;725A
	dc.w	$5E6B	;5E6B
	dc.w	$64FF	;64FF
	dc.w	$6968	;6968
	dc.w	$7E76	;7E76
	dc.w	$FF76	;FF76
	dc.w	$70FF	;70FF
	dc.w	$7EFF	;7EFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$4334	;4334
	dc.w	$3840	;3840
	dc.w	$3C45	;3C45
	dc.w	$3035	;3035
	dc.w	$413A	;413A
	dc.w	$4A2B	;4A2B
	dc.w	$2F48	;2F48
	dc.w	$3B4D	;3B4D
	dc.w	$2228	;2228
	dc.w	$4938	;4938
adrEA018ADE:
	dc.w	$0000	;0000
	dc.w	$00B8	;00B8
	dc.w	$0228	;0228
	dc.w	$0450	;0450
	dc.w	$05C0	;05C0
	dc.w	$06A0	;06A0
	dc.w	$0798	;0798
	dc.w	$0A80	;0A80
	dc.w	$0BD0	;0BD0
	dc.w	$0E70	;0E70
	dc.w	$1260	;1260
	dc.w	$1458	;1458
	dc.w	$16B8	;16B8
	dc.w	$1770	;1770
	dc.w	$18E0	;18E0
	dc.w	$1B08	;1B08
	dc.w	$1C78	;1C78
	dc.w	$1D58	;1D58
	dc.w	$1E50	;1E50
	dc.w	$2138	;2138
	dc.w	$2288	;2288
	dc.w	$2528	;2528
	dc.w	$2918	;2918
	dc.w	$2B10	;2B10
	dc.w	$2D70	;2D70
	dc.w	$3050	;3050
	dc.w	$3430	;3430
	dc.w	$3970	;3970
adrEA018B16:
	dc.w	$0000	;0000
	dc.w	$00B0	;00B0
	dc.w	$0210	;0210
	dc.w	$0218	;0218
	dc.w	$03E8	;03E8
	dc.w	$0658	;0658
	dc.w	$0810	;0810
	dc.w	$0818	;0818
	dc.w	$0978	;0978
	dc.w	$0B48	;0B48
	dc.w	$0DB8	;0DB8
adrEA018B2C:
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0008	;0008
	dc.w	$00B8	;00B8
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0138	;0138
	dc.w	$01E8	;01E8
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0268	;0268
	dc.w	$0508	;0508
adrEA018B50:
	dc.w	$0000	;0000
	dc.w	$00A0	;00A0
	dc.w	$0130	;0130
	dc.w	$0270	;0270
	dc.w	$0300	;0300
	dc.w	$03C0	;03C0
	dc.w	$0488	;0488
	dc.w	$0638	;0638
	dc.w	$0740	;0740
	dc.w	$0860	;0860
	dc.w	$09D0	;09D0
	dc.w	$09D8	;09D8
	dc.w	$0BE8	;0BE8
	dc.w	$0C88	;0C88
	dc.w	$0D60	;0D60
	dc.w	$0E80	;0E80
adrEA018B70:
	dc.w	$0000	;0000
	dc.w	$00B8	;00B8
	dc.w	$0228	;0228
	dc.w	$0450	;0450
	dc.w	$05C0	;05C0
	dc.w	$06A0	;06A0
	dc.w	$0798	;0798
	dc.w	$0A80	;0A80
	dc.w	$0BD0	;0BD0
	dc.w	$0E70	;0E70
	dc.w	$1260	;1260
	dc.w	$1458	;1458
	dc.w	$16B8	;16B8
	dc.w	$1828	;1828
	dc.w	$1A18	;1A18
	dc.w	$1CB8	;1CB8
adrEA018B90:
	dc.w	$0000	;0000
	dc.w	$0048	;0048
	dc.w	$0088	;0088
	dc.w	$0118	;0118
	dc.w	$0120	;0120
	dc.w	$0168	;0168
	dc.w	$01C8	;01C8
	dc.w	$0288	;0288
	dc.w	$0308	;0308
	dc.w	$0390	;0390
	dc.w	$0440	;0440
	dc.w	$0448	;0448
	dc.w	$0568	;0568
	dc.w	$05B0	;05B0
	dc.w	$0610	;0610
	dc.w	$0698	;0698
adrEA018BB0:
	dc.w	$0000	;0000
	dc.w	$0070	;0070
	dc.w	$0130	;0130
	dc.w	$0220	;0220
	dc.w	$02F0	;02F0
	dc.w	$0378	;0378
	dc.w	$0408	;0408
	dc.w	$0548	;0548
	dc.w	$0608	;0608
	dc.w	$07C8	;07C8
	dc.w	$08D0	;08D0
	dc.w	$08D8	;08D8
	dc.w	$0A68	;0A68
	dc.w	$0AE0	;0AE0
	dc.w	$0B80	;0B80
	dc.w	$0D40	;0D40
adrEA018BD0:
	dc.w	$0000	;0000
	dc.w	$0008	;0008
	dc.w	$00C0	;00C0
	dc.w	$00C8	;00C8
	dc.w	$0180	;0180
	dc.w	$0258	;0258
	dc.w	$0350	;0350
	dc.w	$0638	;0638
	dc.w	$0780	;0780
	dc.w	$0A20	;0A20
	dc.w	$0E10	;0E10
	dc.w	$1008	;1008
	dc.w	$1248	;1248
	dc.w	$1250	;1250
	dc.w	$1440	;1440
	dc.w	$16E0	;16E0
	dc.w	$1CC8	;1CC8
adrEA018BF2:
	dc.w	$0000	;0000
	dc.w	$0008	;0008
	dc.w	$0030	;0030
	dc.w	$0038	;0038
	dc.w	$0060	;0060
	dc.w	$00A8	;00A8
	dc.w	$0110	;0110
	dc.w	$0218	;0218
	dc.w	$02A8	;02A8
	dc.w	$0388	;0388
	dc.w	$0538	;0538
	dc.w	$05F8	;05F8
	dc.w	$06C8	;06C8
	dc.w	$06D0	;06D0
	dc.w	$0780	;0780
	dc.w	$0860	;0860
	dc.w	$0AA0	;0AA0
adrEA018C14:
	dc.w	$0000	;0000
	dc.w	$0008	;0008
	dc.w	$0218	;0218
	dc.w	$02E0	;02E0
	dc.w	$0598	;0598
	dc.w	$0808	;0808
	dc.w	$0000	;0000
	dc.w	$09C0	;09C0
	dc.w	$0B20	;0B20
	dc.w	$0CF0	;0CF0
	dc.w	$0F60	;0F60
	dc.w	$1488	;1488
	dc.w	$16E8	;16E8
adrEA018C2E:
	dc.w	$0000	;0000
	dc.w	$0008	;0008
	dc.w	$0010	;0010
	dc.w	$0020	;0020
	dc.w	$0028	;0028
	dc.w	$0038	;0038
	dc.w	$0040	;0040
	dc.w	$0090	;0090
	dc.w	$00C0	;00C0
	dc.w	$00F8	;00F8
	dc.w	$0140	;0140
	dc.w	$0148	;0148
	dc.w	$01C0	;01C0
	dc.w	$01D0	;01D0
	dc.w	$0208	;0208
	dc.w	$0250	;0250
adrEA018C4E:
	dc.w	$0000	;0000
	dc.w	$0008	;0008
	dc.w	$0018	;0018
	dc.w	$0020	;0020
	dc.w	$0050	;0050
	dc.w	$0080	;0080
	dc.w	$00B0	;00B0
	dc.w	$00B8	;00B8
	dc.w	$00C8	;00C8
	dc.w	$00F8	;00F8
	dc.w	$0128	;0128
	dc.w	$01E8	;01E8
adrEA018C66:
	dc.w	$0000	;0000
	dc.w	$0008	;0008
	dc.w	$0018	;0018
	dc.w	$0020	;0020
	dc.w	$0030	;0030
	dc.w	$0050	;0050
	dc.w	$0070	;0070
	dc.w	$0078	;0078
	dc.w	$0088	;0088
	dc.w	$0098	;0098
	dc.w	$00B8	;00B8
	dc.w	$0138	;0138
adrEA018C7E:
	dc.w	$001F	;001F
	dc.w	$311C	;311C
	dc.w	$0000	;0000
	dc.w	$0EC3	;0EC3
	dc.w	$7E00	;7E00
	dc.w	$000C	;000C
	dc.w	$3C0C	;3C0C
	dc.w	$0000	;0000
	dc.w	$0C0F	;0C0F
	dc.w	$0C00	;0C00
	dc.w	$0C1E	;0C1E
	dc.w	$3F0C	;3F0C
	dc.w	$0C0C	;0C0C
	dc.w	$0C3F	;0C3F
	dc.w	$1E0C	;1E0C
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
	dc.b	$00	;00
GameFont:
	dc.b	$0C	;0C
	dc.w	$1E0C	;1E0C
	dc.w	$000C	;000C
	dc.w	$3333	;3333
	dc.w	$2200	;2200
	dc.w	$0014	;0014
	dc.w	$3E14	;3E14
	dc.w	$3E14	;3E14
	dc.w	$1E34	;1E34
	dc.w	$3E15	;3E15
	dc.w	$3E31	;3E31
	dc.w	$3204	;3204
	dc.w	$0B13	;0B13
	dc.w	$1C08	;1C08
	dc.w	$0D16	;0D16
	dc.w	$1D06	;1D06
	dc.w	$0408	;0408
	dc.w	$0000	;0000
	dc.w	$1820	;1820
	dc.w	$2020	;2020
	dc.w	$1818	;1818
	dc.w	$0404	;0404
	dc.w	$0418	;0418
	dc.w	$120C	;120C
	dc.w	$1E0C	;1E0C
	dc.w	$1208	;1208
	dc.w	$083E	;083E
	dc.w	$0808	;0808
	dc.w	$0000	;0000
	dc.w	$0004	;0004
	dc.w	$1800	;1800
	dc.w	$003E	;003E
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$000C	;000C
	dc.w	$0C03	;0C03
	dc.w	$040C	;040C
	dc.w	$0830	;0830
	dc.w	$0C12	;0C12
	dc.w	$3312	;3312
	dc.w	$0C0C	;0C0C
	dc.w	$3C0C	;3C0C
	dc.w	$0C3F	;0C3F
	dc.w	$0E13	;0E13
	dc.w	$060C	;060C
	dc.w	$1F1E	;1F1E
	dc.w	$030E	;030E
	dc.w	$031E	;031E
	dc.w	$0E12	;0E12
	dc.w	$321F	;321F
	dc.w	$061F	;061F
	dc.w	$181E	;181E
	dc.w	$033E	;033E
	dc.w	$1C30	;1C30
	dc.w	$3E33	;3E33
	dc.w	$1E3F	;1E3F
	dc.w	$2306	;2306
	dc.w	$0C0C	;0C0C
	dc.w	$1E33	;1E33
	dc.w	$1E33	;1E33
	dc.w	$1E1E	;1E1E
	dc.w	$331F	;331F
	dc.w	$031E	;031E
	dc.w	$1818	;1818
	dc.w	$0018	;0018
	dc.w	$1818	;1818
	dc.w	$1800	;1800
	dc.w	$1830	;1830
	dc.w	$0C10	;0C10
	dc.w	$2010	;2010
	dc.w	$0C00	;0C00
	dc.w	$3E00	;3E00
	dc.w	$3E00	;3E00
	dc.w	$3008	;3008
	dc.w	$0408	;0408
	dc.w	$301E	;301E
	dc.w	$3306	;3306
	dc.w	$0C0C	;0C0C
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$000C	;000C
	dc.w	$123F	;123F
	dc.w	$2133	;2133
	dc.w	$3E11	;3E11
	dc.w	$1E11	;1E11
	dc.w	$3E1F	;3E1F
	dc.w	$2120	;2120
	dc.w	$211F	;211F
	dc.w	$3E11	;3E11
	dc.w	$1111	;1111
	dc.w	$3E1F	;3E1F
	dc.w	$213C	;213C
	dc.w	$211F	;211F
	dc.w	$3F10	;3F10
	dc.w	$3C10	;3C10
	dc.w	$101F	;101F
	dc.w	$2023	;2023
	dc.w	$211F	;211F
	dc.w	$3321	;3321
	dc.w	$3F21	;3F21
	dc.w	$333E	;333E
	dc.w	$0808	;0808
	dc.w	$083E	;083E
	dc.w	$3F0C	;3F0C
	dc.w	$0222	;0222
	dc.w	$3C31	;3C31
	dc.w	$121E	;121E
	dc.w	$1131	;1131
	dc.w	$3010	;3010
	dc.w	$2021	;2021
	dc.w	$3F33	;3F33
	dc.w	$2D21	;2D21
	dc.w	$2133	;2133
	dc.w	$2E31	;2E31
	dc.w	$2122	;2122
	dc.w	$230C	;230C
	dc.w	$1233	;1233
	dc.w	$120C	;120C
	dc.w	$3E11	;3E11
	dc.w	$1E10	;1E10
	dc.w	$301E	;301E
	dc.w	$3131	;3131
	dc.w	$1E03	;1E03
	dc.w	$3E13	;3E13
	dc.w	$1C12	;1C12
	dc.w	$331E	;331E
	dc.w	$201E	;201E
	dc.w	$013F	;013F
	dc.w	$3F0C	;3F0C
	dc.w	$1011	;1011
	dc.w	$0F31	;0F31
	dc.w	$1121	;1121
	dc.w	$211F	;211F
	dc.w	$3321	;3321
	dc.w	$2112	;2112
	dc.w	$0C33	;0C33
	dc.w	$2121	;2121
	dc.w	$2D33	;2D33
	dc.w	$3312	;3312
	dc.w	$0C12	;0C12
	dc.w	$3323	;3323
	dc.w	$211F	;211F
	dc.w	$013E	;013E
	dc.w	$3F23	;3F23
	dc.w	$0C31	;0C31
	dc.w	$3F1E	;3F1E
	dc.w	$1818	;1818
	dc.w	$181E	;181E
	dc.w	$3018	;3018
	dc.w	$0C06	;0C06
	dc.w	$031E	;031E
	dc.w	$0606	;0606
	dc.w	$061E	;061E
	dc.w	$0C1E	;0C1E
	dc.w	$3300	;3300
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$003F	;003F
	dc.w	$1808	;1808
	dc.w	$0400	;0400
	dc.w	$000C	;000C
	dc.w	$0033	;0033
	dc.w	$000C	;000C
	dc.w	$3F00	;3F00
	dc.w	$3F00	;3F00
	dc.w	$3F1E	;3F1E
	dc.w	$0133	;0133
	dc.w	$201E	;201E
	dc.w	$3F21	;3F21
	dc.w	$0021	;0021
	dc.w	$3F00	;3F00
	dc.w	$0C12	;0C12
	dc.w	$213F	;213F
	dc.w	$3008	;3008
	dc.w	$0C04	;0C04
	dc.w	$031E	;031E
	dc.w	$3101	;3101
	dc.w	$0212	;0212
	dc.w	$0C33	;0C33
	dc.w	$0033	;0033
	dc.w	$0C33	;0C33
	dc.w	$000C	;000C
	dc.w	$0033	;0033
	dc.w	$3C02	;3C02
	dc.w	$1302	;1302
	dc.w	$3C1E	;3C1E
	dc.w	$2112	;2112
	dc.w	$0C0C	;0C0C
	dc.w	$1C20	;1C20
	dc.w	$3301	;3301
	dc.w	$0E33	;0E33
	dc.w	$1E12	;1E12
	dc.w	$1E33	;1E33
	dc.w	$1C22	;1C22
	dc.w	$0102	;0102
	dc.w	$0C33	;0C33
	dc.w	$2D00	;2D00
	dc.w	$2D33	;2D33
	dc.w	$1203	;1203
	dc.w	$2130	;2130
	dc.w	$1206	;1206
	dc.w	$1921	;1921
	dc.w	$1906	;1906
	dc.w	$2E03	;2E03
	dc.w	$0C30	;0C30
	dc.w	$1D1E	;1D1E
	dc.w	$2112	;2112
	dc.w	$211E	;211E
	dc.w	$3F12	;3F12
	dc.w	$2121	;2121
	dc.w	$1E32	;1E32
	dc.w	$201E	;201E
	dc.w	$0113	;0113
	dc.w	$0101	;0101
	dc.w	$1F02	;1F02
	dc.w	$3F3F	;3F3F
	dc.w	$0033	;0033
	dc.w	$0033	;0033
	dc.w	$0C12	;0C12
	dc.w	$2100	;2100
	dc.w	$3F31	;3F31
	dc.w	$0E00	;0E00
	dc.w	$0E31	;0E31
	dc.w	$3321	;3321
	dc.w	$3E20	;3E20
	dc.w	$300E	;300E
	dc.w	$0830	;0830
	dc.w	$080E	;080E
	dc.w	$1818	;1818
	dc.w	$1818	;1818
	dc.w	$181C	;181C
	dc.w	$0403	;0403
	dc.w	$041C	;041C
	dc.w	$0019	;0019
	dc.w	$2D26	;2D26
	dc.w	$0008	;0008
	dc.w	$103F	;103F
	dc.w	$1008	;1008
_GFX_ButtonHighlights:
	INCBIN bw-gfx/ButtonHighlights

_GFX_Scroll_Edge_Top:
	INCBIN bw-gfx/Scroll_Edge_Top

_GFX_Scroll_Edge_Bottom:
	INCBIN bw-gfx/Scroll_Edge_Bottom

_GFX_Scroll_Edge_Left:
	INCBIN bw-gfx/Scroll_Edge_Left

_GFX_Scroll_Edge_Right:
	INCBIN bw-gfx/Scroll_Edge_Right

_GFX_Shield_Clicked:
	INCBIN bw-gfx/Shield_Clicked

SpellNames:
	dc.b	'ARMOUR  TERROR  VITALISEBEGUILE DEFLECT MAGELOCKCONCEAL WARPOWERMISSILE VANISH  PARALYZEALCHEMY CONFUSE LEVITATEANTIMAGERECH'	;41524D4F55522020544552524F522020564954414C49534542454755494C45204445464C454354204D4147454C4F434B434F4E4345414C2057415
*04F5745524D495353494C452056414E4953482020504152414C595A45414C4348454D5920434F4E46555345204C45564954415445414E54494D41474552454348
	dc.b	'ARGETRUEVIEWRENEW   VIVIFY  DISPELL FIREPATHILLUSIONCOMPASS SPELLTAPDISRUPT FIREBALLWYCHWINDARC BOLTFORMWALLSUMMON  BLAZE   '	;41524745545255455649455752454E4557202020564956494659202044495350454C4C204649524550415448494C4C5553494F4E434F4D5041535
*05350454C4C54415044495352555054204649524542414C4C5759434857494E4441524320424F4C54464F524D57414C4C53554D4D4F4E2020424C415A45202020
	dc.b	'MINDROCK'	;4D494E44524F434B
SpellDescriptions:
	dc.b	$1A	;1A
	dc.b	'WEAR THIS SPELL WITH PRIDE'	;574541522054484953205350454C4C2057495448205052494445
	dc.b	$04	;04
	dc.b	'BOO!'	;424F4F21
	dc.b	$19	;19
	dc.b	'YOU''LL NEVER FEEL SO GOOD'	;594F55274C4C204E45564552204645454C20534F20474F4F44
	dc.b	$1B	;1B
	dc.b	'COAT THY TONGUE WITH SILVER'	;434F41542054485920544F4E47554520574954482053494C564552
	dc.b	$21	;21
	dc.b	'A SPELL A DAY KEEPS AN ARROW AWAY'	;41205350454C4C204120444159204B4545505320414E204152524F572041574159
	dc.b	$25	;25
	dc.b	'WHY BOTHER WITH ALL THOSE SILLY KEYS?'	;57485920424F54484552205749544820414C4C2054484F53452053494C4C59204B4559533F
	dc.b	$24	;24
	dc.b	'WHAT CANNOT BE SEEN CANNOT BE STOLEN'	;574841542043414E4E4F54204245205345454E2043414E4E4F542042452053544F4C454E
	dc.b	$24	;24
	dc.b	'YOU TOO CAN HAVE THE STRENGTH OF TEN'	;594F5520544F4F2043414E20484156452054484520535452454E475448204F462054454E
	dc.b	$1A	;1A
	dc.b	'ONE IN THE EYE FOR ARCHERS'	;4F4E4520494E205448452045594520464F522041524348455253
	dc.b	$1E	;1E
	dc.b	'NOW YOU SEE ME...NOW YOU DON''T'	;4E4F5720594F5520534545204D452E2E2E4E4F5720594F5520444F4E2754
	dc.b	$25	;25
	dc.b	'A FROZEN LIFE MAY WELL BE A SHORT ONE'	;412046524F5A454E204C494645204D41592057454C4C20424520412053484F5254204F4E45
	dc.b	$11	;11
	dc.b	'THE HAND OF MIDAS'	;5448452048414E44204F46204D49444153
	dc.b	$1D	;1D
	dc.b	'THEY WON''T KNOW WHAT HIT THEM'	;5448455920574F4E2754204B4E4F57205748415420484954205448454D
	dc.b	$17	;17
	dc.b	'A GENUINELY LIGHT SPELL'	;412047454E55494E454C59204C49474854205350454C4C
	dc.b	$22	;22
	dc.b	'NEVERMORE WORRY ABOUT SPELLCASTERS'	;4E455645524D4F524520574F5252592041424F5554205350454C4C43415354455253
	dc.b	$1C	;1C
	dc.b	'BOOSTS THE FLATTEST OF RINGS'	;424F4F5354532054484520464C415454455354204F462052494E4753
	dc.b	$21	;21
	dc.b	'NEVER AGAIN LOSE AT HIDE AND SEEK'	;4E4556455220414741494E204C4F5345204154204849444520414E44205345454B
	dc.b	$1D	;1D
	dc.b	'CURES EVERYTHING EXCEPT CRAMP'	;43555245532045564552595448494E4720455843455054204352414D50
	dc.b	$25	;25
	dc.b	'MAKES DEATH BUT A MINOR INCONVENIENCE'	;4D414B4553204445415448204255542041204D494E4F5220494E434F4E56454E49454E4345
	dc.b	$23	;23
	dc.b	'WHAT MAGIC MAKES, MAGIC CAN DESTROY'	;57484154204D41474943204D414B45532C204D414749432043414E2044455354524F59
	dc.b	$17	;17
	dc.b	'LAY DOWN THE RED CARPET'	;4C415920444F574E205448452052454420434152504554
	dc.b	$14	;14
	dc.b	'REAL ENOUGH TO HURT!'	;5245414C20454E4F55474820544F204855525421
	dc.b	$14	;14
	dc.b	'NEVER GET LOST AGAIN'	;4E4556455220474554204C4F535420414741494E
	dc.b	$1B	;1B
	dc.b	'THE BANE OF ALL MAGIC USERS'	;5448452042414E45204F4620414C4C204D41474943205553455253
	dc.b	$1C	;1C
	dc.b	'KNOWN TO SOME AS DEATHSTRIKE'	;4B4E4F574E20544F20534F4D45204153204445415448535452494B45
	dc.b	$12	;12
	dc.b	'A BLAST AT PARTIES'	;4120424C4153542041542050415254494553
	dc.b	$13	;13
	dc.b	'JUST BLOW THEM AWAY'	;4A55535420424C4F57205448454D2041574159
	dc.b	$1A	;1A
	dc.b	'AN ELECTRIFYING EXPERIENCE'	;414E20454C45435452494659494E4720455850455249454E4345
	dc.b	$18	;18
	dc.b	'FOR THOSE WHO LOVE WALLS'	;464F522054484F53452057484F204C4F56452057414C4C53
	dc.b	$17	;17
	dc.b	'YOU''LL NEVER WALK ALONE'	;594F55274C4C204E455645522057414C4B20414C4F4E45
	dc.b	$20	;20
	dc.b	'NONE SHALL PASS THIS FIERY BLAST'	;4E4F4E45205348414C4C2050415353205448495320464945525920424C415354
	dc.b	$23	;23
	dc.b	'FOR THOSE WHO THINK THEY LOVE WALLS',0	;464F522054484F53452057484F205448494E4B2054484559204C4F56452057414C4C5300
ScrollOffsets:
	dc.w	$0000	;0000
	dc.w	$0026	;0026
	dc.w	$004E	;004E
	dc.w	$008A	;008A
	dc.w	$00B3	;00B3
	dc.w	$00CC	;00CC
	dc.w	$00DE	;00DE
	dc.w	$0127	;0127
	dc.w	$0145	;0145
	dc.w	$0180	;0180
	dc.w	$019B	;019B
	dc.w	$01B4	;01B4
	dc.w	$0207	;0207
	dc.w	$0220	;0220
	dc.w	$0252	;0252
	dc.w	$0269	;0269
	dc.w	$028A	;028A
	dc.w	$02A9	;02A9
	dc.w	$02D3	;02D3
	dc.w	$02EB	;02EB
	dc.w	$0340	;0340
	dc.w	$037B	;037B
	dc.w	$03A8	;03A8
	dc.w	$03C0	;03C0
	dc.w	$03E9	;03E9
	dc.w	$040C	;040C
	dc.w	$0444	;0444
	dc.w	$047C	;047C
	dc.w	$049D	;049D
	dc.w	$04D3	;04D3
	dc.w	$0500	;0500
	dc.w	$0525	;0525
	dc.w	$054F	;054F
	dc.w	$056D	;056D
	dc.w	$0593	;0593
	dc.w	$05C2	;05C2
	dc.w	$05FE	;05FE
	dc.w	$0642	;0642
	dc.w	$0667	;0667
	dc.w	$067E	;067E
	dc.w	$06B7	;06B7
	dc.w	$06DB	;06DB
	dc.w	$0709	;0709
	dc.w	$0731	;0731
	dc.w	$076F	;076F
	dc.w	$07A3	;07A3
	dc.w	$07D6	;07D6
	dc.w	$0802	;0802
	dc.w	$0837	;0837
	dc.w	$0858	;0858
	dc.w	$087C	;087C
	dc.w	$08A3	;08A3
	dc.w	$08BA	;08BA
	dc.w	$08E1	;08E1
	dc.w	$092E	;092E
	dc.w	$0950	;0950
	dc.w	$0987	;0987
	dc.w	$09A6	;09A6
	dc.w	$09D0	;09D0
	dc.w	$0A0B	;0A0B
	dc.w	$0A29	;0A29
	dc.w	$0A40	;0A40
	dc.w	$0A67	;0A67
	dc.w	$0AA2	;0AA2
	dc.w	$0AED	;0AED
	dc.w	$0B14	;0B14
	dc.w	$0B4C	;0B4C
	dc.w	$0B77	;0B77
	dc.w	$0BA2	;0BA2
	dc.w	$0BCE	;0BCE
	dc.w	$0BFA	;0BFA
	dc.w	$0C32	;0C32
	dc.w	$0C5D	;0C5D
ScrollTexts:
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'THE KEY'	;544845204B4559
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'ABOVE'	;41424F5645
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'DOTH LIE'	;444F5448204C4945
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$07	;07
	dc.b	'BELOW'	;42454C4F57
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$04	;04
	dc.b	'THE KEY'	;544845204B4559
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'OF HUE'	;4F4620485545
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$06	;06
	dc.b	'IS WHAT'	;49532057484154
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$07	;07
	dc.b	'I''M DUE'	;49274D20445545
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'MY KEY I'	;4D59204B45592049
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'BESTOW TO'	;424553544F5720544F
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'THOSE WHO'	;54484F53452057484F
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'CAN SOLVE'	;43414E20534F4C5645
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$08	;08
	dc.b	'THIS MAZE'	;54484953204D415A45
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$04	;04
	dc.b	'A SWORD'	;412053574F5244
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$05	;05
	dc.b	'A BOW'	;4120424F57
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'THIS WALL'	;544849532057414C4C
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$07	;07
	dc.b	'MUST GO'	;4D55535420474F
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'REFORGE'	;5245464F524745
	dc.b	$FC	;FC
	dc.b	'!'	;21
	dc.b	$06	;06
	dc.b	'THY'	;544859
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$07	;07
	dc.b	'BONES'	;424F4E4553
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'WELCOME'	;57454C434F4D45
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$06	;06
	dc.b	'BACK'	;4241434B
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$03	;03
	dc.b	'BRING THE'	;4252494E4720544845
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'CRYSTALS,'	;4352595354414C532C
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'FIND THEM'	;46494E44205448454D
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'ALL, ONLY'	;414C4C2C204F4E4C59
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'THEN WILL'	;5448454E2057494C4C
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$08	;08
	dc.b	'EVIL FALL'	;4556494C2046414C4C
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$04	;04
	dc.b	'BEYOND'	;4245594F4E44
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$05	;05
	dc.b	'LIES'	;4C494553
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$06	;06
	dc.b	'THE'	;544845
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$07	;07
	dc.b	'KEEP'	;4B454550
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$03	;03
	dc.b	'POTIONS'	;504F54494F4E53
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'ALE     8'	;414C45202020202038
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'SLIME  10'	;534C494D4520203130
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'ELIXIR 12'	;454C49584952203132
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$08	;08
	dc.b	'BROTH  15'	;42524F544820203135
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	'!'	;21
	dc.b	$04	;04
	dc.b	'ALL'	;414C4C
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'MORTALS'	;4D4F5254414C53
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$06	;06
	dc.b	'BEWARE!'	;42455741524521
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'HERE LIES'	;48455245204C494553
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'THE CRYPT'	;544845204352595054
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$03	;03
	dc.b	'EYE OF A'	;455945204F462041
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'NEWT,WING'	;4E4557542C57494E47
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'OF A BAT,'	;4F462041204241542C
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'TOE OF A'	;544F45204F462041
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'SLOTH, OR'	;534C4F54482C204F52
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$08	;08
	dc.b	'SOMETHING'	;534F4D455448494E47
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$09	;09
	dc.b	'LIKE THAT'	;4C494B452054484154
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	'!'	;21
	dc.b	$04	;04
	dc.b	'THE'	;544845
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'SERPENT'	;53455250454E54
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$06	;06
	dc.b	'TOWER'	;544F574552
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$04	;04
	dc.b	'ZENDIK'	;5A454E44494B
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'WILL NOT'	;57494C4C204E4F54
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$06	;06
	dc.b	'SUFFER'	;535546464552
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$07	;07
	dc.b	'ANY TO'	;414E5920544F
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$08	;08
	dc.b	'TRESPASS'	;5452455350415353
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	'!'	;21
	dc.b	$04	;04
	dc.b	'THE'	;544845
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$05	;05
	dc.b	'CHAOS'	;4348414F53
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$06	;06
	dc.b	'TOWER'	;544F574552
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$04	;04
	dc.b	'THE'	;544845
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'TOWER'	;544F574552
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$06	;06
	dc.b	'OF THE'	;4F4620544845
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$07	;07
	dc.b	'DRAGON'	;445241474F4E
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$04	;04
	dc.b	'THE'	;544845
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'TOWER'	;544F574552
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$06	;06
	dc.b	'OF THE'	;4F4620544845
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$07	;07
	dc.b	'MOON'	;4D4F4F4E
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	'!'	;21
	dc.b	$04	;04
	dc.b	'THE'	;544845
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'MENAGERIE'	;4D454E414745524945
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'APPROACH'	;415050524F414348
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$08	;08
	dc.b	'WITH CARE'	;574954482043415245
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$05	;05
	dc.b	'FAST'	;46415354
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$06	;06
	dc.b	'ROUTE'	;524F555445
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$07	;07
	dc.b	'DOWN!'	;444F574E21
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$03	;03
	dc.b	'DAGGER  5'	;444147474552202035
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'LSHIELD 6'	;4C534849454C442036
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'SWORDS 10'	;53574F524453203130
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'STAVES  8'	;535441564553202038
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'LEATHER 7'	;4C4541544845522037
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$08	;08
	dc.b	'CHAIN  12'	;434841494E20203132
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$09	;09
	dc.b	'SHIELD 10'	;534849454C44203130
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$03	;03
	dc.b	'ARMOURY'	;41524D4F555259
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'GLOVES 10'	;474C4F564553203130
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'AXE    12'	;415845202020203132
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'SHIELD 15'	;534849454C44203135
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$08	;08
	dc.b	'PLATE  16'	;504C41544520203136
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'GREETINGS'	;4752454554494E4753
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'TO THEE'	;544F2054484545
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$06	;06
	dc.b	'FOOLISH'	;464F4F4C495348
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'INTRUDERS'	;494E54525544455253
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$04	;04
	dc.b	'LOOK'	;4C4F4F4B
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'BEHIND'	;424548494E44
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$06	;06
	dc.b	'YOU!'	;594F5521
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'THE PRIZE'	;544845205052495A45
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'YOU SEEK'	;594F55205345454B
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$06	;06
	dc.b	'IS FAR'	;495320464152
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$07	;07
	dc.b	'ABOVE'	;41424F5645
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	'!'	;21
	dc.b	$04	;04
	dc.b	'ALL'	;414C4C
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'BELIEVERS'	;42454C494556455253
	dc.b	$FC	;FC
	dc.b	'!'	;21
	dc.b	$06	;06
	dc.b	'ARE'	;415245
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$07	;07
	dc.b	'WELCOME'	;57454C434F4D45
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'PLACE THE'	;504C41434520544845
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'GEM IN'	;47454D20494E
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'THE HOLE'	;54484520484F4C45
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'TO REACH'	;544F205245414348
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$08	;08
	dc.b	'YOUR GOAL'	;594F555220474F414C
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$04	;04
	dc.b	'YOU CAN'	;594F552043414E
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'REACH THE'	;524541434820544845
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'PRIZE BUT'	;5052495A4520425554
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'WILL YOU'	;57494C4C20594F55
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$08	;08
	dc.b	'ESCAPE?'	;4553434150453F
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'FARE THEE'	;464152452054484545
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'WELL MY'	;57454C4C204D59
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$06	;06
	dc.b	'FRIENDS'	;465249454E4453
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$04	;04
	dc.b	'THE GEM'	;5448452047454D
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'IN THE'	;494E20544845
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'KEEP WILL'	;4B4545502057494C4C
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'SHOW YOU'	;53484F5720594F55
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$08	;08
	dc.b	'THE MOON'	;544845204D4F4F4E
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'THOSE WHO'	;54484F53452057484F
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'SEEK THE'	;5345454B20544845
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'EYE SHALL'	;455945205348414C4C
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$07	;07
	dc.b	'PERISH'	;504552495348
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$04	;04
	dc.b	'THE'	;544845
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'CRYSTALS'	;4352595354414C53
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'CAGE THE'	;4341474520544845
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$07	;07
	dc.b	'POWER'	;504F574552
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'ASCEND TO'	;415343454E4420544F
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'THE EYE'	;54484520455945
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$06	;06
	dc.b	'OF THE'	;4F4620544845
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$07	;07
	dc.b	'SERPENT'	;53455250454E54
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'NOW YOU'	;4E4F5720594F55
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$06	;06
	dc.b	'ARE IN'	;41524520494E
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$07	;07
	dc.b	'TROUBLE'	;54524F55424C45
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$04	;04
	dc.b	'PARTING'	;50415254494E47
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'IS SUCH'	;49532053554348
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$06	;06
	dc.b	'SWEET'	;5357454554
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$07	;07
	dc.b	'SORROW'	;534F52524F57
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$04	;04
	dc.b	'WE SELL'	;57452053454C4C
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'THE BEST'	;5448452042455354
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$06	;06
	dc.b	'THAT'	;54484154
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$07	;07
	dc.b	'MONEY'	;4D4F4E4559
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$08	;08
	dc.b	'CAN BUY'	;43414E20425559
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$03	;03
	dc.b	'FOR THE'	;464F5220544845
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$04	;04
	dc.b	'FIRST '	;464952535420
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'YOU RISE'	;594F552052495345
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$07	;07
	dc.b	'FOR THE'	;464F5220544845
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$08	;08
	dc.b	'SECOND'	;5345434F4E44
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$09	;09
	dc.b	'BE WISE'	;42452057495345
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$03	;03
	dc.b	'THE RINGS'	;5448452052494E4753
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'WERE MADE'	;57455245204D414445
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'FROM THE'	;46524F4D20544845
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'SHARDS OF'	;534841524453204F46
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'PUREST'	;505552455354
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$08	;08
	dc.b	'CRYSTALS'	;4352595354414C53
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$04	;04
	dc.b	'BEWARE'	;424557415245
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$05	;05
	dc.b	'THE'	;544845
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$06	;06
	dc.b	'PSYCHIC'	;50535943484943
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$07	;07
	dc.b	'BARRIERS'	;4241525249455253
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'RUN THE'	;52554E20544845
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'GAUNTLET!'	;4741554E544C455421
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'THE GREAT'	;544845204752454154
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'BEAST DID'	;424541535420444944
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'COME FROM'	;434F4D452046524F4D
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'THE OTHER'	;544845204F54484552
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$08	;08
	dc.b	'WORLD'	;574F524C44
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'LOOK HARD'	;4C4F4F4B2048415244
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'AND THOU'	;414E442054484F55
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'SHALT SEE'	;5348414C5420534545
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$04	;04
	dc.b	'TO PASS'	;544F2050415353
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'THE LOCK'	;544845204C4F434B
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'JUST TURN'	;4A555354205455524E
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'THE BLOCK'	;54484520424C4F434B
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'ONWARDS'	;4F4E5741524453
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'TO THY'	;544F20544859
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'GREATER'	;47524541544552
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'GLORIES'	;474C4F52494553
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$03	;03
	dc.b	'THE OLD'	;544845204F4C44
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'ONES WARD'	;4F4E45532057415244
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'THE LAIR'	;544845204C414952
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$06	;06
	dc.b	'OF THE'	;4F4620544845
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'DRAGON''S'	;445241474F4E2753
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$08	;08
	dc.b	'HEART'	;4845415254
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'YOU WILL'	;594F552057494C4C
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'NEVER'	;4E45564552
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$06	;06
	dc.b	'DEFEAT'	;444546454154
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'ZENDIK IN'	;5A454E44494B20494E
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$08	;08
	dc.b	'HIS LAIR'	;484953204C414952
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$03	;03
	dc.b	'GOING'	;474F494E47
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$04	;04
	dc.b	'FURTHER'	;46555254484552
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$05	;05
	dc.b	'WILL'	;57494C4C
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$06	;06
	dc.b	'ENSURE'	;454E53555245
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$07	;07
	dc.b	'YOUR'	;594F5552
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$08	;08
	dc.b	'DEATHS'	;444541544853
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$04	;04
	dc.b	'WITHIN'	;57495448494E
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$05	;05
	dc.b	'THE'	;544845
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$06	;06
	dc.b	'DRAGON'	;445241474F4E
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'LIES THE'	;4C49455320544845
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$08	;08
	dc.b	'POWER'	;504F574552
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'NORTHWARD'	;4E4F52544857415244
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'YOU MUST'	;594F55204D555354
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'TRAVEL'	;54524156454C
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'TO CAGE'	;544F2043414745
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$08	;08
	dc.b	'THE ARC'	;54484520415243
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$04	;04
	dc.b	'THE'	;544845
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'DRAGON'	;445241474F4E
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$06	;06
	dc.b	'HEART'	;4845415254
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$07	;07
	dc.b	'AWAKES'	;4157414B4553
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'THE LORDS'	;544845204C4F524453
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'OF CHAOS'	;4F46204348414F53
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'AWAIT YOU'	;415741495420594F55
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'CHAOS'	;4348414F53
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'CAN NOT'	;43414E204E4F54
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'BE RULED'	;42452052554C4544
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'BY MAN'	;4259204D414E
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	'!'	;21
	dc.b	$05	;05
	dc.b	'THE'	;544845
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$06	;06
	dc.b	'GREAT'	;4752454154
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$07	;07
	dc.b	'BLADE'	;424C414445
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'YOU MUST'	;594F55204D555354
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$05	;05
	dc.b	'RISE'	;52495345
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$06	;06
	dc.b	'BEFORE'	;4245464F5245
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'YOU FALL'	;594F552046414C4C
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$03	;03
	dc.b	'ONLY THEY'	;4F4E4C592054484559
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'WITH THE'	;5749544820544845
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'QUICKEST'	;515549434B455354
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'HAND AND'	;48414E4420414E44
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'KEENEST'	;4B45454E455354
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$08	;08
	dc.b	'EYE WILL'	;4559452057494C4C
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$09	;09
	dc.b	'PREVAIL'	;5052455641494C
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'BE BRAVE'	;4245204252415645
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'AND PRESS'	;414E44205052455353
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'ONWARDS'	;4F4E5741524453
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'YOU HAVE'	;594F552048415645
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'DONE WELL'	;444F4E452057454C4C
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$07	;07
	dc.b	'NOW THE'	;4E4F5720544845
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$08	;08
	dc.b	'CHALLENGE'	;4348414C4C454E4745
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$09	;09
	dc.b	'BEGINS'	;424547494E53
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'ZENDIK'	;5A454E44494B
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'HAS LOST'	;484153204C4F5354
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'CONTROL'	;434F4E54524F4C
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$04	;04
	dc.b	'PREPARE'	;50524550415245
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'TO DIE'	;544F20444945
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'ACCURSED'	;4143435552534544
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'DEFILERS'	;444546494C455253
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$03	;03
	dc.b	'POTIONS'	;504F54494F4E53
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'ALE     8'	;414C45202020202038
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'SLIME  10'	;534C494D4520203130
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'ELIXIR 12'	;454C49584952203132
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$08	;08
	dc.b	'BROTH  15'	;42524F544820203135
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'ZENDIK'	;5A454E44494B
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'BIDS THEE'	;424944532054484545
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$07	;07
	dc.b	'ENTER'	;454E544552
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$05	;05
	dc.b	'NONE'	;4E4F4E45
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$06	;06
	dc.b	'SHALL'	;5348414C4C
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$07	;07
	dc.b	'PASS'	;50415353
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$04	;04
	dc.b	'THE'	;544845
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'MASTER'	;4D4153544552
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$06	;06
	dc.b	'IS NOW'	;4953204E4F57
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$07	;07
	dc.b	'THE'	;544845
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$08	;08
	dc.b	'SLAVE'	;534C415645
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$03	;03
	dc.b	'THE ACE'	;54484520414345
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'HAS NO'	;484153204E4F
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'POWER'	;504F574552
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'WITHOUT'	;574954484F5554
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'THE CHAOS'	;544845204348414F53
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$08	;08
	dc.b	'GLOVES'	;474C4F564553
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$03	;03
	dc.b	'THE DARK'	;544845204441524B
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$04	;04
	dc.b	'ONE HAS'	;4F4E4520484153
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'ESCAPED'	;45534341504544
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'HIS BONDS'	;48495320424F4E4453
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$07	;07
	dc.b	'AND NOW'	;414E44204E4F57
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$08	;08
	dc.b	'RAVAGES'	;52415641474553
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$09	;09
	dc.b	'THE LAND'	;544845204C414E44
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$04	;04
	dc.b	'HEREIN'	;48455245494E
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'DWELLS'	;4457454C4C53
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'THE LORD'	;544845204C4F5244
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$07	;07
	dc.b	'ZENDIK'	;5A454E44494B
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'YOU MUST'	;594F55204D555354
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'PLACE THE'	;504C41434520544845
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'CRYSTALS'	;4352595354414C53
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$07	;07
	dc.b	'EACH IN'	;4541434820494E
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$08	;08
	dc.b	'SEQUENCE'	;53455155454E4345
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'USING THE'	;5553494E4720544845
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'MOON WILL'	;4D4F4F4E2057494C4C
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'OPEN THE'	;4F50454E20544845
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$07	;07
	dc.b	'TOMB'	;544F4D42
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$04	;04
	dc.b	'DRAGON'	;445241474F4E
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'TO CHAOS'	;544F204348414F53
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'AND THEN'	;414E44205448454E
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'THE LAST'	;544845204C415354
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$04	;04
	dc.b	'WITH'	;57495448
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$05	;05
	dc.b	'SERPENT'	;53455250454E54
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$06	;06
	dc.b	'RAGE'	;52414745
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$07	;07
	dc.b	'ENTER'	;454E544552
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$08	;08
	dc.b	'THE CAGE'	;5448452043414745
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'GODS MAY'	;474F4453204D4159
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'KILL AND'	;4B494C4C20414E44
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'MORTALS'	;4D4F5254414C53
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'MAY FEAR'	;4D41592046454152
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$03	;03
	dc.b	' THE'	;20544845
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'CRYSTAL'	;4352595354414C
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'OF CHAOS'	;4F46204348414F53
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$06	;06
	dc.b	'SHALL'	;5348414C4C
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'SUMMON'	;53554D4D4F4E
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$08	;08
	dc.b	'IT NEAR'	;4954204E454152
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$04	;04
	dc.b	'BEWARE'	;424557415245
	dc.b	$FC	;FC
	dc.b	' '	;20
	dc.b	$05	;05
	dc.b	'THE'	;544845
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$06	;06
	dc.b	'LEGION'	;4C4547494F4E
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$07	;07
	dc.b	'OF THE'	;4F4620544845
	dc.b	$FC	;FC
	dc.b	$1F	;1F
	dc.b	$08	;08
	dc.b	'UNDEAD'	;554E44454144
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$03	;03
	dc.b	'THY QUEST'	;544859205155455354
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$04	;04
	dc.b	'HAS COME'	;48415320434F4D45
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$05	;05
	dc.b	'TO AN END'	;544F20414E20454E44
	dc.b	$FC	;FC
	dc.b	'!'	;21
	dc.b	$06	;06
	dc.b	'--'	;2D2D
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$07	;07
	dc.b	'BLOODWYCH'	;424C4F4F4457594348
	dc.b	$FC	;FC
	dc.b	'!'	;21
	dc.b	$08	;08
	dc.b	'IS'	;4953
	dc.b	$FC	;FC
	dc.b	$1E	;1E
	dc.b	$09	;09
	dc.b	'RESTORED'	;524553544F524544
	dc.b	$FF	;FF
_GFX_MainWalls:
	INCBIN bw-gfx/MainWalls

_GFX_WoodWall:
	INCBIN bw-gfx/WoodWall

_GFX_WoodDoors:
	INCBIN bw-gfx/WoodDoors

_GFX_Shelf:
	INCBIN bw-gfx/Shelf

_GFX_Sign:
	INCBIN bw-gfx/Sign

_GFX_SignOverlay:
	INCBIN bw-gfx/SignOverlay

_GFX_Switches:
	INCBIN bw-gfx/Switches

_GFX_Slots:
	INCBIN bw-gfx/Slots

_GFX_Bed:
	INCBIN bw-gfx/Bed

_GFX_Pillar:
	INCBIN bw-gfx/Pillar

_GFX_StairsUp:
	INCBIN bw-gfx/StairsUp

_GFX_StairsDown:
	INCBIN bw-gfx/StairsDown

_GFX_LargeOpenDoor:
	INCBIN bw-gfx/LargeOpenDoor

_GFX_LargeMetalDoor:
	INCBIN bw-gfx/LargeMetalDoor

_GFX_PortCullis:
	INCBIN bw-gfx/PortCullis

_GFX_PitLow:
	INCBIN bw-gfx/PitLow

_GFX_PitHigh:
	INCBIN bw-gfx/PitHigh

_GFX_Pad:
	INCBIN bw-gfx/Pad

_GFX_FloorCeiling:
	INCBIN bw-gfx/FloorCeiling

_GFX_ObjectsOnFloor:
	INCBIN bw-gfx/ObjectsOnFloor

_GFX_FireBall:
	INCBIN bw-gfx/AirbourneFireball

_GFX_AirbourneSpells:
	INCBIN bw-gfx/AirbourneSpells

CharacterColours:
	INCBIN bw-data/characters.colours

_GFX_HeadParts:
	INCBIN bw-gfx/HeadParts

_GFX_Bodies:
	INCBIN bw-gfx/BodyParts

_GFX_Avatars:
	INCBIN bw-gfx/AvatarsLarge

_GFX_ShieldAvatars:
	INCBIN bw-gfx/Shield_Avatars

_GFX_ShieldTop:
	INCBIN bw-gfx/ShieldTop

_GFX_ShieldBottom:
	INCBIN bw-gfx/ShieldBottom

_GFX_ShieldClasses:
	INCBIN bw-gfx/ShieldClasses

_GFX_Fairy:
	INCBIN bw-gfx/Fairy

_GFX_Summon:
	INCBIN bw-gfx/Summon

_GFX_Behemoth:
	INCBIN bw-gfx/Behemoth

_GFX_Crab:
	INCBIN bw-gfx/Crab

_GFX_CrabClaw:
	dc.w	$2FFF	;2FFF
	dc.w	$03FF	;03FF
	dc.w	$53FF	;53FF
	dc.w	$83FF	;83FF
	dc.w	$0FFF	;0FFF
	dc.w	$07FF	;07FF
	dc.w	$C7FF	;C7FF
	dc.w	$07FF	;07FF
	dc.w	$8FFF	;8FFF
	dc.w	$07FF	;07FF
	dc.w	$57FF	;57FF
	dc.w	$17FF	;17FF
	dc.w	$5FFF	;5FFF
	dc.w	$0FFF	;0FFF
	dc.w	$8FFF	;8FFF
	dc.w	$2FFF	;2FFF
	dc.w	$9FFF	;9FFF
	dc.w	$2FFF	;2FFF
	dc.w	$2FFF	;2FFF
	dc.w	$6FFF	;6FFF
	dc.w	$BFFF	;BFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$5FFF	;5FFF
	dc.w	$BFFF	;BFFF
	dc.w	$1FFF	;1FFF
	dc.w	$5FFF	;5FFF
	dc.w	$1FFF	;1FFF
	dc.w	$FFFF	;FFFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$FFFF	;FFFF
	dc.w	$F0FF	;F0FF
	dc.w	$F0FF	;F0FF
	dc.w	$F0FF	;F0FF
	dc.w	$F0FF	;F0FF
	dc.w	$C07F	;C07F
	dc.w	$CA7F	;CA7F
	dc.w	$C77F	;C77F
	dc.w	$C1FF	;C1FF
	dc.w	$88FF	;88FF
	dc.w	$ACFF	;ACFF
	dc.w	$9EFF	;9EFF
	dc.w	$83FF	;83FF
	dc.w	$11FF	;11FF
	dc.w	$59FF	;59FF
	dc.w	$3DFF	;3DFF
	dc.w	$87FF	;87FF
	dc.w	$13FF	;13FF
	dc.w	$33FF	;33FF
	dc.w	$7BFF	;7BFF
	dc.w	$87FF	;87FF
	dc.w	$13FF	;13FF
	dc.w	$3BFF	;3BFF
	dc.w	$7BFF	;7BFF
	dc.w	$83FF	;83FF
	dc.w	$81FF	;81FF
	dc.w	$C9FF	;C9FF
	dc.w	$BDFF	;BDFF
	dc.w	$C7FF	;C7FF
	dc.w	$C7FF	;C7FF
	dc.w	$FFFF	;FFFF
	dc.w	$C7FF	;C7FF
	dc.w	$FFFF	;FFFF
	dc.w	$E7FF	;E7FF
	dc.w	$E7FF	;E7FF
	dc.w	$E7FF	;E7FF
	dc.w	$C7FF	;C7FF
	dc.w	$83FF	;83FF
	dc.w	$B3FF	;B3FF
	dc.w	$9BFF	;9BFF
	dc.w	$9FFF	;9FFF
	dc.w	$2FFF	;2FFF
	dc.w	$6FFF	;6FFF
	dc.w	$2FFF	;2FFF
	dc.w	$1FFF	;1FFF
	dc.w	$0FFF	;0FFF
	dc.w	$AFFF	;AFFF
	dc.w	$6FFF	;6FFF
	dc.w	$8FFF	;8FFF
	dc.w	$8FFF	;8FFF
	dc.w	$CFFF	;CFFF
	dc.w	$BFFF	;BFFF
	dc.w	$B383	;B383
	dc.w	$400F	;400F
	dc.w	$4C1F	;4C1F
	dc.w	$4C7F	;4C7F
	dc.w	$BE43	;BE43
	dc.w	$5003	;5003
	dc.w	$5087	;5087
	dc.w	$5103	;5103
	dc.w	$B923	;B923
	dc.w	$0003	;0003
	dc.w	$44CB	;44CB
	dc.w	$468B	;468B
	dc.w	$DFE3	;DFE3
	dc.w	$8803	;8803
	dc.w	$A003	;A003
	dc.w	$A013	;A013
	dc.w	$D937	;D937
	dc.w	$8003	;8003
	dc.w	$A403	;A403
	dc.w	$A2CB	;A2CB
	dc.w	$F1FF	;F1FF
	dc.w	$C20F	;C20F
	dc.w	$CA0F	;CA0F
	dc.w	$C60F	;C60F
	dc.w	$E88F	;E88F
	dc.w	$C047	;C047
	dc.w	$D567	;D567
	dc.w	$D377	;D377
	dc.w	$E87F	;E87F
	dc.w	$E00F	;E00F
	dc.w	$F68F	;F68F
	dc.w	$F18F	;F18F
	dc.w	$FE1F	;FE1F
	dc.w	$E80F	;E80F
	dc.w	$E92F	;E92F
	dc.w	$E8CF	;E8CF
	dc.w	$FFFF	;FFFF
	dc.w	$FE1F	;FE1F
	dc.w	$FE1F	;FE1F
	dc.w	$FE1F	;FE1F
	dc.w	$BA1F	;BA1F
	dc.w	$203F	;203F
	dc.w	$447F	;447F
	dc.w	$41FF	;41FF
	dc.w	$A51F	;A51F
	dc.w	$481F	;481F
	dc.w	$4A3F	;4A3F
	dc.w	$5A1F	;5A1F
	dc.w	$BC9F	;BC9F
	dc.w	$001F	;001F
	dc.w	$405F	;405F
	dc.w	$435F	;435F
	dc.w	$EB1F	;EB1F
	dc.w	$801F	;801F
	dc.w	$849F	;849F
	dc.w	$901F	;901F
	dc.w	$D1BF	;D1BF
	dc.w	$801F	;801F
	dc.w	$AA1F	;AA1F
	dc.w	$A45F	;A45F
	dc.w	$D93F	;D93F
	dc.w	$A01F	;A01F
	dc.w	$A29F	;A29F
	dc.w	$A6DF	;A6DF
	dc.w	$F9FF	;F9FF
	dc.w	$D03F	;D03F
	dc.w	$D43F	;D43F
	dc.w	$D23F	;D23F
	dc.w	$FE7F	;FE7F
	dc.w	$FC3F	;FC3F
	dc.w	$FCBF	;FCBF
	dc.w	$FD3F	;FD3F
	dc.w	$FFFF	;FFFF
	dc.w	$CF9F	;CF9F
	dc.w	$CF9F	;CF9F
	dc.w	$CF9F	;CF9F
	dc.w	$CFDF	;CFDF
	dc.w	$8787	;8787
	dc.w	$B787	;B787
	dc.w	$87A7	;87A7
	dc.w	$8FC7	;8FC7
	dc.w	$2783	;2783
	dc.w	$67BB	;67BB
	dc.w	$3793	;3793
	dc.w	$8FA3	;8FA3
	dc.w	$0701	;0701
	dc.w	$574D	;574D
	dc.w	$3719	;3719
	dc.w	$CFC3	;CFC3
	dc.w	$8709	;8709
	dc.w	$A71D	;A71D
	dc.w	$9739	;9739
	dc.w	$EF83	;EF83
	dc.w	$C711	;C711
	dc.w	$D735	;D735
	dc.w	$C779	;C779
	dc.w	$FF07	;FF07
	dc.w	$EE03	;EE03
	dc.w	$EE8B	;EE8B
	dc.w	$EE73	;EE73
	dc.w	$FF1F	;FF1F
	dc.w	$FE07	;FE07
	dc.w	$FEE7	;FEE7
	dc.w	$FE07	;FE07
	dc.w	$FFFF	;FFFF
	dc.w	$FE1F	;FE1F
	dc.w	$FE1F	;FE1F
	dc.w	$FE1F	;FE1F
	dc.w	$FFFF	;FFFF
	dc.w	$F9FF	;F9FF
	dc.w	$F9FF	;F9FF
	dc.w	$F9FF	;F9FF
	dc.w	$F9FF	;F9FF
	dc.w	$F07F	;F07F
	dc.w	$F47F	;F47F
	dc.w	$F27F	;F27F
	dc.w	$FC7F	;FC7F
	dc.w	$B81F	;B81F
	dc.w	$BB1F	;BB1F
	dc.w	$B99F	;B99F
	dc.w	$FE1F	;FE1F
	dc.w	$5C8F	;5C8F
	dc.w	$1DEF	;1DEF
	dc.w	$5C8F	;5C8F
	dc.w	$BF0F	;BF0F
	dc.w	$2E47	;2E47
	dc.w	$4ED7	;4ED7
	dc.w	$2EE7	;2EE7
	dc.w	$BF0F	;BF0F
	dc.w	$1E47	;1E47
	dc.w	$1E77	;1E77
	dc.w	$5EE7	;5EE7
	dc.w	$FF07	;FF07
	dc.w	$3E23	;3E23
	dc.w	$3E7B	;3E7B
	dc.w	$3EF3	;3EF3
	dc.w	$FF07	;FF07
	dc.w	$FE23	;FE23
	dc.w	$FE7B	;FE7B
	dc.w	$FEF3	;FEF3
	dc.w	$FF87	;FF87
	dc.w	$FF03	;FF03
	dc.w	$FF2B	;FF2B
	dc.w	$FF73	;FF73
	dc.w	$FF87	;FF87
	dc.w	$FF03	;FF03
	dc.w	$FF2B	;FF2B
	dc.w	$FF73	;FF73
	dc.w	$FF8F	;FF8F
	dc.w	$FF07	;FF07
	dc.w	$FF17	;FF17
	dc.w	$FF67	;FF67
	dc.w	$FF9F	;FF9F
	dc.w	$FF0F	;FF0F
	dc.w	$FF6F	;FF6F
	dc.w	$FF0F	;FF0F
	dc.w	$FFFF	;FFFF
	dc.w	$EF1F	;EF1F
	dc.w	$EF1F	;EF1F
	dc.w	$EF1F	;EF1F
	dc.w	$EFFF	;EFFF
	dc.w	$C7FF	;C7FF
	dc.w	$D7FF	;D7FF
	dc.w	$C7FF	;C7FF
	dc.w	$CFFF	;CFFF
	dc.w	$97FF	;97FF
	dc.w	$B7FF	;B7FF
	dc.w	$97FF	;97FF
	dc.w	$CFFF	;CFFF
	dc.w	$87FF	;87FF
	dc.w	$A7FF	;A7FF
	dc.w	$B7FF	;B7FF
	dc.w	$8FFF	;8FFF
	dc.w	$07FF	;07FF
	dc.w	$57FF	;57FF
	dc.w	$27FF	;27FF
	dc.w	$9FFF	;9FFF
	dc.w	$0FFF	;0FFF
	dc.w	$6FFF	;6FFF
	dc.w	$0FFF	;0FFF
	dc.w	$FFFF	;FFFF
	dc.w	$9FFF	;9FFF
	dc.w	$9FFF	;9FFF
	dc.w	$9FFF	;9FFF
	dc.w	$09CF	;09CF
	dc.w	$04A3	;04A3
	dc.w	$46B3	;46B3
	dc.w	$86B3	;86B3
	dc.w	$73CB	;73CB
	dc.w	$0681	;0681
	dc.w	$8CB5	;8CB5
	dc.w	$0CB1	;0CB1
	dc.w	$92C9	;92C9
	dc.w	$4800	;4800
	dc.w	$4D32	;4D32
	dc.w	$6C34	;6C34
	dc.w	$B6F5	;B6F5
	dc.w	$1540	;1540
	dc.w	$090A	;090A
	dc.w	$4902	;4902
	dc.w	$C491	;C491
	dc.w	$2002	;2002
	dc.w	$1B6E	;1B6E
	dc.w	$3966	;3966
	dc.w	$BEB1	;BEB1
	dc.w	$6860	;6860
	dc.w	$0146	;0146
	dc.w	$F04C	;F04C
	dc.w	$FDA7	;FDA7
	dc.w	$00C1	;00C1
	dc.w	$0259	;0259
	dc.w	$0241	;0241
	dc.w	$FD3F	;FD3F
	dc.w	$F807	;F807
	dc.w	$FAC7	;FAC7
	dc.w	$FAC7	;FAC7
	dc.w	$FFFF	;FFFF
	dc.w	$FE7F	;FE7F
	dc.w	$FE7F	;FE7F
	dc.w	$FE7F	;FE7F
	dc.w	$FF7F	;FF7F
	dc.w	$FE1F	;FE1F
	dc.w	$FE1F	;FE1F
	dc.w	$FE9F	;FE9F
	dc.w	$FF9F	;FF9F
	dc.w	$FD07	;FD07
	dc.w	$FD27	;FD27
	dc.w	$FD67	;FD67
	dc.w	$FFC7	;FFC7
	dc.w	$FA83	;FA83
	dc.w	$F89B	;F89B
	dc.w	$FAB3	;FAB3
	dc.w	$F5A3	;F5A3
	dc.w	$E109	;E109
	dc.w	$E84D	;E84D
	dc.w	$EB59	;EB59
	dc.w	$E511	;E511
	dc.w	$C844	;C844
	dc.w	$D8EE	;D8EE
	dc.w	$DAEC	;DAEC
	dc.w	$E631	;E631
	dc.w	$C084	;C084
	dc.w	$D9C6	;D9C6
	dc.w	$D9CC	;D9CC
	dc.w	$FE49	;FE49
	dc.w	$CD20	;CD20
	dc.w	$C1B2	;C1B2
	dc.w	$C1B4	;C1B4
	dc.w	$FCC9	;FCC9
	dc.w	$E180	;E180
	dc.w	$E336	;E336
	dc.w	$E330	;E330
	dc.w	$FCCB	;FCCB
	dc.w	$FA61	;FA61
	dc.w	$FB35	;FB35
	dc.w	$FB31	;FB31
	dc.w	$FCCF	;FCCF
	dc.w	$FE63	;FE63
	dc.w	$FF33	;FF33
	dc.w	$FF33	;FF33
	dc.w	$094F	;094F
	dc.w	$0427	;0427
	dc.w	$46B7	;46B7
	dc.w	$8637	;8637
	dc.w	$734F	;734F
	dc.w	$0607	;0607
	dc.w	$8CB7	;8CB7
	dc.w	$0CB7	;0CB7
	dc.w	$92CF	;92CF
	dc.w	$4807	;4807
	dc.w	$4C37	;4C37
	dc.w	$6D37	;6D37
	dc.w	$B7FF	;B7FF
	dc.w	$144F	;144F
	dc.w	$080F	;080F
	dc.w	$480F	;480F
	dc.w	$6BBF	;6BBF
	dc.w	$024F	;024F
	dc.w	$044F	;044F
	dc.w	$844F	;844F
	dc.w	$93AF	;93AF
	dc.w	$0947	;0947
	dc.w	$4D57	;4D57
	dc.w	$2D47	;2D47
	dc.w	$B5AF	;B5AF
	dc.w	$0007	;0007
	dc.w	$0A47	;0A47
	dc.w	$4857	;4857
	dc.w	$E54F	;E54F
	dc.w	$2007	;2007
	dc.w	$1A97	;1A97
	dc.w	$1AB7	;1AB7
	dc.w	$AB5F	;AB5F
	dc.w	$410F	;410F
	dc.w	$10AF	;10AF
	dc.w	$548F	;548F
	dc.w	$FEFF	;FEFF
	dc.w	$801F	;801F
	dc.w	$811F	;811F
	dc.w	$811F	;811F
	dc.w	$FAFF	;FAFF
	dc.w	$F97F	;F97F
	dc.w	$FD7F	;FD7F
	dc.w	$FD7F	;FD7F
	dc.w	$FEFF	;FEFF
	dc.w	$F8FF	;F8FF
	dc.w	$F9FF	;F9FF
	dc.w	$F9FF	;F9FF
	dc.w	$FFFF	;FFFF
	dc.w	$FEFF	;FEFF
	dc.w	$FEFF	;FEFF
	dc.w	$FEFF	;FEFF
	dc.w	$0AFF	;0AFF
	dc.w	$003F	;003F
	dc.w	$153F	;153F
	dc.w	$E53F	;E53F
	dc.w	$56BF	;56BF
	dc.w	$015F	;015F
	dc.w	$095F	;095F
	dc.w	$895F	;895F
	dc.w	$AA9F	;AA9F
	dc.w	$041F	;041F
	dc.w	$155F	;155F
	dc.w	$557F	;557F
	dc.w	$D33F	;D33F
	dc.w	$221F	;221F
	dc.w	$089F	;089F
	dc.w	$645F	;645F
	dc.w	$F5FF	;F5FF
	dc.w	$E03F	;E03F
	dc.w	$EA3F	;EA3F
	dc.w	$EA3F	;EA3F
	dc.w	$FDFF	;FDFF
	dc.w	$F2FF	;F2FF
	dc.w	$F2FF	;F2FF
	dc.w	$F2FF	;F2FF
	dc.w	$FFFF	;FFFF
	dc.w	$FDFF	;FDFF
	dc.w	$FDFF	;FDFF
	dc.w	$FDFF	;FDFF
_GFX_Beholder_0:
	dc.w	$FEDF	;FEDF
	dc.w	$FD3F	;FD3F
	dc.w	$FC0F	;FC0F
	dc.w	$FDBF	;FDBF
	dc.w	$FF7F	;FF7F
	dc.w	$FD9F	;FD9F
	dc.w	$FC0F	;FC0F
	dc.w	$FDBF	;FDBF
	dc.w	$FDBF	;FDBF
	dc.w	$F00F	;F00F
	dc.w	$F20F	;F20F
	dc.w	$F05F	;F05F
	dc.w	$F01F	;F01F
	dc.w	$E00F	;E00F
	dc.w	$ED4F	;ED4F
	dc.w	$E2AF	;E2AF
	dc.w	$E00F	;E00F
	dc.w	$C00F	;C00F
	dc.w	$DAAF	;DAAF
	dc.w	$C57F	;C57F
	dc.w	$E00F	;E00F
	dc.w	$C01F	;C01F
	dc.w	$D55F	;D55F
	dc.w	$CBFF	;CBFF
	dc.w	$C00F	;C00F
	dc.w	$800F	;800F
	dc.w	$AABF	;AABF
	dc.w	$97FF	;97FF
	dc.w	$C00F	;C00F
	dc.w	$802F	;802F
	dc.w	$B5FF	;B5FF
	dc.w	$8FFF	;8FFF
	dc.w	$800F	;800F
	dc.w	$005F	;005F
	dc.w	$62FF	;62FF
	dc.w	$1FFF	;1FFF
	dc.w	$800F	;800F
	dc.w	$00BF	;00BF
	dc.w	$55FF	;55FF
	dc.w	$2FFF	;2FFF
	dc.w	$800F	;800F
	dc.w	$027F	;027F
	dc.w	$6BFF	;6BFF
	dc.w	$1FFF	;1FFF
	dc.w	$800F	;800F
	dc.w	$00BF	;00BF
	dc.w	$55FF	;55FF
	dc.w	$2FFF	;2FFF
	dc.w	$800F	;800F
	dc.w	$005F	;005F
	dc.w	$62FF	;62FF
	dc.w	$1FFF	;1FFF
	dc.w	$C00F	;C00F
	dc.w	$802F	;802F
	dc.w	$B5FF	;B5FF
	dc.w	$8FFF	;8FFF
	dc.w	$C00F	;C00F
	dc.w	$800F	;800F
	dc.w	$AABF	;AABF
	dc.w	$97FF	;97FF
	dc.w	$E00F	;E00F
	dc.w	$C01F	;C01F
	dc.w	$D55F	;D55F
	dc.w	$CBFF	;CBFF
	dc.w	$E00F	;E00F
	dc.w	$C00F	;C00F
	dc.w	$DAAF	;DAAF
	dc.w	$C57F	;C57F
	dc.w	$F00F	;F00F
	dc.w	$E00F	;E00F
	dc.w	$EF4F	;EF4F
	dc.w	$E0BF	;E0BF
	dc.w	$FC0F	;FC0F
	dc.w	$F00F	;F00F
	dc.w	$F3AF	;F3AF
	dc.w	$F05F	;F05F
	dc.w	$FF0F	;FF0F
	dc.w	$FC0F	;FC0F
	dc.w	$FCFF	;FCFF
	dc.w	$FC0F	;FC0F
	dc.w	$FFFF	;FFFF
	dc.w	$FF0F	;FF0F
	dc.w	$FF0F	;FF0F
	dc.w	$FF0F	;FF0F
_GFX_Beholder_1:
	dc.w	$F77F	;F77F
	dc.w	$E8FF	;E8FF
	dc.w	$E03F	;E03F
	dc.w	$ECFF	;ECFF
	dc.w	$FDFF	;FDFF
	dc.w	$F67F	;F67F
	dc.w	$F03F	;F03F
	dc.w	$F6FF	;F6FF
	dc.w	$F6FF	;F6FF
	dc.w	$E03F	;E03F
	dc.w	$E93F	;E93F
	dc.w	$E03F	;E03F
	dc.w	$E03F	;E03F
	dc.w	$C03F	;C03F
	dc.w	$DABF	;DABF
	dc.w	$C5FF	;C5FF
	dc.w	$C03F	;C03F
	dc.w	$803F	;803F
	dc.w	$B17F	;B17F
	dc.w	$8FFF	;8FFF
	dc.w	$C03F	;C03F
	dc.w	$807F	;807F
	dc.w	$AAFF	;AAFF
	dc.w	$97FF	;97FF
	dc.w	$803F	;803F
	dc.w	$00BF	;00BF
	dc.w	$75FF	;75FF
	dc.w	$0FFF	;0FFF
	dc.w	$803F	;803F
	dc.w	$017F	;017F
	dc.w	$6BFF	;6BFF
	dc.w	$1FFF	;1FFF
	dc.w	$803F	;803F
	dc.w	$00FF	;00FF
	dc.w	$57FF	;57FF
	dc.w	$2FFF	;2FFF
	dc.w	$803F	;803F
	dc.w	$017F	;017F
	dc.w	$6BFF	;6BFF
	dc.w	$1FFF	;1FFF
	dc.w	$803F	;803F
	dc.w	$00BF	;00BF
	dc.w	$75FF	;75FF
	dc.w	$0FFF	;0FFF
	dc.w	$C03F	;C03F
	dc.w	$807F	;807F
	dc.w	$AAFF	;AAFF
	dc.w	$97FF	;97FF
	dc.w	$C03F	;C03F
	dc.w	$803F	;803F
	dc.w	$B17F	;B17F
	dc.w	$8FFF	;8FFF
	dc.w	$E03F	;E03F
	dc.w	$C03F	;C03F
	dc.w	$DABF	;DABF
	dc.w	$C5FF	;C5FF
	dc.w	$F03F	;F03F
	dc.w	$E03F	;E03F
	dc.w	$ED7F	;ED7F
	dc.w	$E2BF	;E2BF
	dc.w	$FC3F	;FC3F
	dc.w	$F03F	;F03F
	dc.w	$F3FF	;F3FF
	dc.w	$F03F	;F03F
	dc.w	$FFFF	;FFFF
	dc.w	$FC3F	;FC3F
	dc.w	$FC3F	;FC3F
	dc.w	$FC3F	;FC3F
_GFX_Beholder_2:
	dc.w	$F6DF	;F6DF
	dc.w	$C927	;C927
	dc.w	$C007	;C007
	dc.w	$CD67	;CD67
	dc.w	$FBBF	;FBBF
	dc.w	$E44F	;E44F
	dc.w	$E00F	;E00F
	dc.w	$E54F	;E54F
	dc.w	$E54F	;E54F
	dc.w	$C007	;C007
	dc.w	$DAB7	;DAB7
	dc.w	$C007	;C007
	dc.w	$C007	;C007
	dc.w	$8003	;8003
	dc.w	$B45B	;B45B
	dc.w	$8BA3	;8BA3
	dc.w	$C007	;C007
	dc.w	$8003	;8003
	dc.w	$AAAB	;AAAB
	dc.w	$97D3	;97D3
	dc.w	$8003	;8003
	dc.w	$0001	;0001
	dc.w	$5555	;5555
	dc.w	$2FE9	;2FE9
	dc.w	$8003	;8003
	dc.w	$0101	;0101
	dc.w	$6BAD	;6BAD
	dc.w	$1FF1	;1FF1
	dc.w	$8003	;8003
	dc.w	$0381	;0381
	dc.w	$47C5	;47C5
	dc.w	$3FF9	;3FF9
	dc.w	$8003	;8003
	dc.w	$0101	;0101
	dc.w	$6BAD	;6BAD
	dc.w	$1FF1	;1FF1
	dc.w	$8003	;8003
	dc.w	$0001	;0001
	dc.w	$5555	;5555
	dc.w	$2FE9	;2FE9
	dc.w	$C007	;C007
	dc.w	$8003	;8003
	dc.w	$AAAB	;AAAB
	dc.w	$97D3	;97D3
	dc.w	$E00F	;E00F
	dc.w	$C007	;C007
	dc.w	$DC77	;DC77
	dc.w	$C387	;C387
	dc.w	$F83F	;F83F
	dc.w	$E00F	;E00F
	dc.w	$E7CF	;E7CF
	dc.w	$E00F	;E00F
	dc.w	$FFFF	;FFFF
	dc.w	$F83F	;F83F
	dc.w	$F83F	;F83F
	dc.w	$F83F	;F83F
_GFX_Beholder_3:
	dc.w	$F77F	;F77F
	dc.w	$C89F	;C89F
	dc.w	$C01F	;C01F
	dc.w	$CA9F	;CA9F
	dc.w	$EABF	;EABF
	dc.w	$C01F	;C01F
	dc.w	$D55F	;D55F
	dc.w	$C01F	;C01F
	dc.w	$C01F	;C01F
	dc.w	$800F	;800F
	dc.w	$B56F	;B56F
	dc.w	$8A8F	;8A8F
	dc.w	$C01F	;C01F
	dc.w	$800F	;800F
	dc.w	$A22F	;A22F
	dc.w	$9FCF	;9FCF
	dc.w	$800F	;800F
	dc.w	$0207	;0207
	dc.w	$5757	;5757
	dc.w	$2FA7	;2FA7
	dc.w	$800F	;800F
	dc.w	$0707	;0707
	dc.w	$6FB7	;6FB7
	dc.w	$1FC7	;1FC7
	dc.w	$800F	;800F
	dc.w	$0207	;0207
	dc.w	$5757	;5757
	dc.w	$2FA7	;2FA7
	dc.w	$C01F	;C01F
	dc.w	$800F	;800F
	dc.w	$A22F	;A22F
	dc.w	$9FCF	;9FCF
	dc.w	$C01F	;C01F
	dc.w	$800F	;800F
	dc.w	$B8EF	;B8EF
	dc.w	$870F	;870F
	dc.w	$F07F	;F07F
	dc.w	$C01F	;C01F
	dc.w	$CF9F	;CF9F
	dc.w	$C01F	;C01F
	dc.w	$FFFF	;FFFF
	dc.w	$F07F	;F07F
	dc.w	$F07F	;F07F
	dc.w	$F07F	;F07F
_GFX_Beholder_4:
	dc.w	$B6FF	;B6FF
	dc.w	$497F	;497F
	dc.w	$007F	;007F
	dc.w	$497F	;497F
	dc.w	$FFFF	;FFFF
	dc.w	$5D7F	;5D7F
	dc.w	$087F	;087F
	dc.w	$557F	;557F
	dc.w	$FFFF	;FFFF
	dc.w	$087F	;087F
	dc.w	$007F	;007F
	dc.w	$6B7F	;6B7F
	dc.w	$DDFF	;DDFF
	dc.w	$A2FF	;A2FF
	dc.w	$80FF	;80FF
	dc.w	$AAFF	;AAFF
	dc.w	$C9FF	;C9FF
	dc.w	$80FF	;80FF
	dc.w	$B6FF	;B6FF
	dc.w	$80FF	;80FF
	dc.w	$80FF	;80FF
	dc.w	$007F	;007F
	dc.w	$497F	;497F
	dc.w	$3E7F	;3E7F
	dc.w	$007F	;007F
	dc.w	$087F	;087F
	dc.w	$9CFF	;9CFF
	dc.w	$7F7F	;7F7F
	dc.w	$007F	;007F
	dc.w	$1C7F	;1C7F
	dc.w	$BEFF	;BEFF
	dc.w	$7F7F	;7F7F
	dc.w	$007F	;007F
	dc.w	$087F	;087F
	dc.w	$9CFF	;9CFF
	dc.w	$7F7F	;7F7F
	dc.w	$80FF	;80FF
	dc.w	$007F	;007F
	dc.w	$637F	;637F
	dc.w	$1C7F	;1C7F
	dc.w	$E3FF	;E3FF
	dc.w	$80FF	;80FF
	dc.w	$9CFF	;9CFF
	dc.w	$80FF	;80FF
	dc.w	$FFFF	;FFFF
	dc.w	$E3FF	;E3FF
	dc.w	$E3FF	;E3FF
	dc.w	$E3FF	;E3FF
_GFX_Beholder_5:
	dc.w	$BBFF	;BBFF
	dc.w	$D7FF	;D7FF
	dc.w	$83FF	;83FF
	dc.w	$D7FF	;D7FF
	dc.w	$EFFF	;EFFF
	dc.w	$11FF	;11FF
	dc.w	$01FF	;01FF
	dc.w	$55FF	;55FF
	dc.w	$FFFF	;FFFF
	dc.w	$83FF	;83FF
	dc.w	$83FF	;83FF
	dc.w	$ABFF	;ABFF
	dc.w	$83FF	;83FF
	dc.w	$83FF	;83FF
	dc.w	$C7FF	;C7FF
	dc.w	$BBFF	;BBFF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$93FF	;93FF
	dc.w	$7DFF	;7DFF
	dc.w	$01FF	;01FF
	dc.w	$11FF	;11FF
	dc.w	$BBFF	;BBFF
	dc.w	$7DFF	;7DFF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$93FF	;93FF
	dc.w	$7DFF	;7DFF
	dc.w	$83FF	;83FF
	dc.w	$83FF	;83FF
	dc.w	$C7FF	;C7FF
	dc.w	$BBFF	;BBFF
	dc.w	$FFFF	;FFFF
	dc.w	$C7FF	;C7FF
	dc.w	$C7FF	;C7FF
	dc.w	$C7FF	;C7FF
_GFX_Beholder_6:
	dc.w	$FFFF	;FFFF
	dc.w	$E38F	;E38F
	dc.w	$E38F	;E38F
	dc.w	$E38F	;E38F
	dc.w	$FBDF	;FBDF
	dc.w	$DD3F	;DD3F
	dc.w	$C10F	;C10F
	dc.w	$DD7F	;DD7F
	dc.w	$EDDF	;EDDF
	dc.w	$BE7F	;BE7F
	dc.w	$B03F	;B03F
	dc.w	$9EEF	;9EEF
	dc.w	$D52F	;D52F
	dc.w	$9EEF	;9EEF
	dc.w	$986F	;986F
	dc.w	$8ECF	;8ECF
	dc.w	$EBDF	;EBDF
	dc.w	$BC7F	;BC7F
	dc.w	$B03F	;B03F
	dc.w	$9EEF	;9EEF
	dc.w	$FFDF	;FFDF
	dc.w	$C03F	;C03F
	dc.w	$C00F	;C00F
	dc.w	$CC7F	;CC7F
	dc.w	$FDFF	;FDFF
	dc.w	$F60F	;F60F
	dc.w	$F00F	;F00F
	dc.w	$F70F	;F70F
_GFX_Beholder_7:
	dc.w	$FFFF	;FFFF
	dc.w	$C63F	;C63F
	dc.w	$C63F	;C63F
	dc.w	$C63F	;C63F
	dc.w	$D6BF	;D6BF
	dc.w	$B9FF	;B9FF
	dc.w	$A07F	;A07F
	dc.w	$B9FF	;B9FF
	dc.w	$EB7F	;EB7F
	dc.w	$BDFF	;BDFF
	dc.w	$B0FF	;B0FF
	dc.w	$9DBF	;9DBF
	dc.w	$D6BF	;D6BF
	dc.w	$B9FF	;B9FF
	dc.w	$A07F	;A07F
	dc.w	$BDFF	;BDFF
	dc.w	$FFFF	;FFFF
	dc.w	$C03F	;C03F
	dc.w	$C03F	;C03F
	dc.w	$D8FF	;D8FF
_GFX_Beholder_8:
	dc.w	$FFFF	;FFFF
	dc.w	$CC67	;CC67
	dc.w	$CC67	;CC67
	dc.w	$CC67	;CC67
	dc.w	$DC77	;DC77
	dc.w	$B39B	;B39B
	dc.w	$A10B	;A10B
	dc.w	$B39B	;B39B
	dc.w	$F7DF	;F7DF
	dc.w	$BBBB	;BBBB
	dc.w	$A10B	;A10B
	dc.w	$9AB3	;9AB3
	dc.w	$CFE7	;CFE7
	dc.w	$B11B	;B11B
	dc.w	$8003	;8003
	dc.w	$BBBB	;BBBB
_GFX_Beholder_9:
	dc.w	$FFFF	;FFFF
	dc.w	$C89F	;C89F
	dc.w	$C89F	;C89F
	dc.w	$C89F	;C89F
	dc.w	$E8BF	;E8BF
	dc.w	$B76F	;B76F
	dc.w	$820F	;820F
	dc.w	$B76F	;B76F
	dc.w	$FFFF	;FFFF
	dc.w	$B76F	;B76F
	dc.w	$A22F	;A22F
	dc.w	$954F	;954F
	dc.w	$CF9F	;CF9F
	dc.w	$B26F	;B26F
	dc.w	$800F	;800F
	dc.w	$BAEF	;BAEF
	dc.w	$C00F	;C00F
	dc.w	$800F	;800F
	dc.w	$AAFF	;AAFF
	dc.w	$978F	;978F
	dc.w	$C00F	;C00F
	dc.w	$802F	;802F
	dc.w	$B5FF	;B5FF
	dc.w	$8E7F	;8E7F
	dc.w	$800F	;800F
	dc.w	$005F	;005F
	dc.w	$66FF	;66FF
	dc.w	$19FF	;19FF
	dc.w	$87FF	;87FF
	dc.w	$000F	;000F
	dc.w	$580F	;580F
	dc.w	$200F	;200F
	dc.w	$B94F	;B94F
	dc.w	$068F	;068F
	dc.w	$47CF	;47CF
	dc.w	$020F	;020F
	dc.w	$87FF	;87FF
	dc.w	$000F	;000F
	dc.w	$580F	;580F
	dc.w	$200F	;200F
	dc.w	$800F	;800F
	dc.w	$005F	;005F
	dc.w	$66FF	;66FF
	dc.w	$19FF	;19FF
	dc.w	$C00F	;C00F
	dc.w	$802F	;802F
	dc.w	$B5FF	;B5FF
	dc.w	$8E7F	;8E7F
	dc.w	$C00F	;C00F
	dc.w	$800F	;800F
	dc.w	$AAFF	;AAFF
	dc.w	$978F	;978F
	dc.w	$C07F	;C07F
	dc.w	$800F	;800F
	dc.w	$AA8F	;AA8F
	dc.w	$978F	;978F
	dc.w	$C1BF	;C1BF
	dc.w	$804F	;804F
	dc.w	$B47F	;B47F
	dc.w	$8E4F	;8E4F
	dc.w	$864F	;864F
	dc.w	$01BF	;01BF
	dc.w	$61FF	;61FF
	dc.w	$188F	;188F
	dc.w	$98AF	;98AF
	dc.w	$074F	;074F
	dc.w	$47EF	;47EF
	dc.w	$230F	;230F
	dc.w	$A14F	;A14F
	dc.w	$1E8F	;1E8F
	dc.w	$5FCF	;5FCF
	dc.w	$0E0F	;0E0F
	dc.w	$98AF	;98AF
	dc.w	$074F	;074F
	dc.w	$47EF	;47EF
	dc.w	$230F	;230F
	dc.w	$864F	;864F
	dc.w	$01BF	;01BF
	dc.w	$61FF	;61FF
	dc.w	$188F	;188F
	dc.w	$C1BF	;C1BF
	dc.w	$804F	;804F
	dc.w	$B47F	;B47F
	dc.w	$8E4F	;8E4F
	dc.w	$C07F	;C07F
	dc.w	$800F	;800F
	dc.w	$AA8F	;AA8F
	dc.w	$978F	;978F
	dc.w	$C03F	;C03F
	dc.w	$803F	;803F
	dc.w	$ABFF	;ABFF
	dc.w	$963F	;963F
	dc.w	$803F	;803F
	dc.w	$00BF	;00BF
	dc.w	$77FF	;77FF
	dc.w	$09FF	;09FF
	dc.w	$87FF	;87FF
	dc.w	$003F	;003F
	dc.w	$683F	;683F
	dc.w	$103F	;103F
	dc.w	$BA3F	;BA3F
	dc.w	$053F	;053F
	dc.w	$473F	;473F
	dc.w	$043F	;043F
	dc.w	$87FF	;87FF
	dc.w	$003F	;003F
	dc.w	$683F	;683F
	dc.w	$103F	;103F
	dc.w	$803F	;803F
	dc.w	$00BF	;00BF
	dc.w	$77FF	;77FF
	dc.w	$09FF	;09FF
	dc.w	$C03F	;C03F
	dc.w	$803F	;803F
	dc.w	$ABFF	;ABFF
	dc.w	$963F	;963F
	dc.w	$C1FF	;C1FF
	dc.w	$803F	;803F
	dc.w	$AA3F	;AA3F
	dc.w	$963F	;963F
	dc.w	$86FF	;86FF
	dc.w	$013F	;013F
	dc.w	$71FF	;71FF
	dc.w	$093F	;093F
	dc.w	$993F	;993F
	dc.w	$06BF	;06BF
	dc.w	$67BF	;67BF
	dc.w	$023F	;023F
	dc.w	$A23F	;A23F
	dc.w	$1D3F	;1D3F
	dc.w	$5F3F	;5F3F
	dc.w	$0C3F	;0C3F
	dc.w	$993F	;993F
	dc.w	$06BF	;06BF
	dc.w	$67BF	;67BF
	dc.w	$023F	;023F
	dc.w	$86FF	;86FF
	dc.w	$013F	;013F
	dc.w	$71FF	;71FF
	dc.w	$093F	;093F
	dc.w	$C1FF	;C1FF
	dc.w	$803F	;803F
	dc.w	$AA3F	;AA3F
	dc.w	$963F	;963F
	dc.w	$C007	;C007
	dc.w	$8003	;8003
	dc.w	$ABAB	;ABAB
	dc.w	$9453	;9453
	dc.w	$8003	;8003
	dc.w	$0101	;0101
	dc.w	$5FF5	;5FF5
	dc.w	$2BA9	;2BA9
	dc.w	$8FE3	;8FE3
	dc.w	$0001	;0001
	dc.w	$701D	;701D
	dc.w	$0001	;0001
	dc.w	$B45B	;B45B
	dc.w	$0AA1	;0AA1
	dc.w	$4EE5	;4EE5
	dc.w	$0821	;0821
	dc.w	$8FE3	;8FE3
	dc.w	$0001	;0001
	dc.w	$701D	;701D
	dc.w	$0001	;0001
	dc.w	$8003	;8003
	dc.w	$0101	;0101
	dc.w	$5FF5	;5FF5
	dc.w	$2BA9	;2BA9
	dc.w	$C007	;C007
	dc.w	$8003	;8003
	dc.w	$ABAB	;ABAB
	dc.w	$9453	;9453
	dc.w	$C007	;C007
	dc.w	$8003	;8003
	dc.w	$ABAB	;ABAB
	dc.w	$97D3	;97D3
	dc.w	$87C3	;87C3
	dc.w	$0001	;0001
	dc.w	$682D	;682D
	dc.w	$1831	;1831
	dc.w	$9AB3	;9AB3
	dc.w	$0541	;0541
	dc.w	$47C5	;47C5
	dc.w	$2449	;2449
	dc.w	$A44B	;A44B
	dc.w	$1AB1	;1AB1
	dc.w	$5EF5	;5EF5
	dc.w	$0821	;0821
	dc.w	$9AB3	;9AB3
	dc.w	$0541	;0541
	dc.w	$47C5	;47C5
	dc.w	$2449	;2449
	dc.w	$87C3	;87C3
	dc.w	$0001	;0001
	dc.w	$682D	;682D
	dc.w	$1831	;1831
	dc.w	$C007	;C007
	dc.w	$8003	;8003
	dc.w	$BBBB	;BBBB
	dc.w	$87C3	;87C3
	dc.w	$C01F	;C01F
	dc.w	$800F	;800F
	dc.w	$AFAF	;AFAF
	dc.w	$974F	;974F
	dc.w	$8F8F	;8F8F
	dc.w	$0007	;0007
	dc.w	$5057	;5057
	dc.w	$2027	;2027
	dc.w	$B56F	;B56F
	dc.w	$0887	;0887
	dc.w	$4D97	;4D97
	dc.w	$0887	;0887
	dc.w	$8F8F	;8F8F
	dc.w	$0007	;0007
	dc.w	$5057	;5057
	dc.w	$2027	;2027
	dc.w	$C01F	;C01F
	dc.w	$800F	;800F
	dc.w	$AFAF	;AFAF
	dc.w	$974F	;974F
	dc.w	$C71F	;C71F
	dc.w	$800F	;800F
	dc.w	$A8AF	;A8AF
	dc.w	$98CF	;98CF
	dc.w	$9ACF	;9ACF
	dc.w	$0507	;0507
	dc.w	$4717	;4717
	dc.w	$2527	;2527
	dc.w	$A52F	;A52F
	dc.w	$18C7	;18C7
	dc.w	$5DD7	;5DD7
	dc.w	$0887	;0887
	dc.w	$9ACF	;9ACF
	dc.w	$0507	;0507
	dc.w	$4717	;4717
	dc.w	$2527	;2527
	dc.w	$C71F	;C71F
	dc.w	$800F	;800F
	dc.w	$A8AF	;A8AF
	dc.w	$98CF	;98CF
	dc.w	$C01F	;C01F
	dc.w	$801F	;801F
	dc.w	$BABF	;BABF
	dc.w	$87FF	;87FF
	dc.w	$C01F	;C01F
	dc.w	$A03F	;A03F
	dc.w	$BDFF	;BDFF
	dc.w	$B3FF	;B3FF
	dc.w	$801F	;801F
	dc.w	$505F	;505F
	dc.w	$7BFF	;7BFF
	dc.w	$7CFF	;7CFF
	dc.w	$FF1F	;FF1F
	dc.w	$003F	;003F
	dc.w	$00FF	;00FF
	dc.w	$003F	;003F
	dc.w	$94FF	;94FF
	dc.w	$0B1F	;0B1F
	dc.w	$1F1F	;1F1F
	dc.w	$021F	;021F
	dc.w	$FF1F	;FF1F
	dc.w	$003F	;003F
	dc.w	$00FF	;00FF
	dc.w	$003F	;003F
	dc.w	$801F	;801F
	dc.w	$505F	;505F
	dc.w	$7BFF	;7BFF
	dc.w	$7CFF	;7CFF
	dc.w	$C01F	;C01F
	dc.w	$A03F	;A03F
	dc.w	$BDFF	;BDFF
	dc.w	$B3FF	;B3FF
	dc.w	$C01F	;C01F
	dc.w	$801F	;801F
	dc.w	$BABF	;BABF
	dc.w	$87FF	;87FF
	dc.w	$F01F	;F01F
	dc.w	$801F	;801F
	dc.w	$8ABF	;8ABF
	dc.w	$87FF	;87FF
	dc.w	$EC1F	;EC1F
	dc.w	$903F	;903F
	dc.w	$B1FF	;B1FF
	dc.w	$93FF	;93FF
	dc.w	$931F	;931F
	dc.w	$6C5F	;6C5F
	dc.w	$7CFF	;7CFF
	dc.w	$08FF	;08FF
	dc.w	$A8DF	;A8DF
	dc.w	$173F	;173F
	dc.w	$3F3F	;3F3F
	dc.w	$063F	;063F
	dc.w	$943F	;943F
	dc.w	$0BDF	;0BDF
	dc.w	$1FDF	;1FDF
	dc.w	$039F	;039F
	dc.w	$A8DF	;A8DF
	dc.w	$173F	;173F
	dc.w	$3F3F	;3F3F
	dc.w	$063F	;063F
	dc.w	$931F	;931F
	dc.w	$6C5F	;6C5F
	dc.w	$7CFF	;7CFF
	dc.w	$08FF	;08FF
	dc.w	$EC1F	;EC1F
	dc.w	$903F	;903F
	dc.w	$B1FF	;B1FF
	dc.w	$93FF	;93FF
	dc.w	$F01F	;F01F
	dc.w	$801F	;801F
	dc.w	$8ABF	;8ABF
	dc.w	$87FF	;87FF
	dc.w	$807F	;807F
	dc.w	$807F	;807F
	dc.w	$FAFF	;FAFF
	dc.w	$87FF	;87FF
	dc.w	$807F	;807F
	dc.w	$20FF	;20FF
	dc.w	$7DFF	;7DFF
	dc.w	$73FF	;73FF
	dc.w	$FC7F	;FC7F
	dc.w	$007F	;007F
	dc.w	$03FF	;03FF
	dc.w	$00FF	;00FF
	dc.w	$8BFF	;8BFF
	dc.w	$147F	;147F
	dc.w	$1C7F	;1C7F
	dc.w	$047F	;047F
	dc.w	$FC7F	;FC7F
	dc.w	$007F	;007F
	dc.w	$03FF	;03FF
	dc.w	$00FF	;00FF
	dc.w	$807F	;807F
	dc.w	$20FF	;20FF
	dc.w	$7DFF	;7DFF
	dc.w	$73FF	;73FF
	dc.w	$807F	;807F
	dc.w	$807F	;807F
	dc.w	$FAFF	;FAFF
	dc.w	$87FF	;87FF
	dc.w	$F07F	;F07F
	dc.w	$807F	;807F
	dc.w	$8AFF	;8AFF
	dc.w	$87FF	;87FF
	dc.w	$EC7F	;EC7F
	dc.w	$10FF	;10FF
	dc.w	$71FF	;71FF
	dc.w	$13FF	;13FF
	dc.w	$937F	;937F
	dc.w	$2C7F	;2C7F
	dc.w	$3CFF	;3CFF
	dc.w	$08FF	;08FF
	dc.w	$88FF	;88FF
	dc.w	$177F	;177F
	dc.w	$1F7F	;1F7F
	dc.w	$067F	;067F
	dc.w	$937F	;937F
	dc.w	$2C7F	;2C7F
	dc.w	$3CFF	;3CFF
	dc.w	$08FF	;08FF
	dc.w	$EC7F	;EC7F
	dc.w	$10FF	;10FF
	dc.w	$71FF	;71FF
	dc.w	$13FF	;13FF
	dc.w	$F07F	;F07F
	dc.w	$807F	;807F
	dc.w	$8AFF	;8AFF
	dc.w	$87FF	;87FF
	dc.w	$81FF	;81FF
	dc.w	$41FF	;41FF
	dc.w	$79FF	;79FF
	dc.w	$67FF	;67FF
	dc.w	$F9FF	;F9FF
	dc.w	$01FF	;01FF
	dc.w	$07FF	;07FF
	dc.w	$03FF	;03FF
	dc.w	$97FF	;97FF
	dc.w	$29FF	;29FF
	dc.w	$39FF	;39FF
	dc.w	$09FF	;09FF
	dc.w	$F9FF	;F9FF
	dc.w	$01FF	;01FF
	dc.w	$07FF	;07FF
	dc.w	$03FF	;03FF
	dc.w	$81FF	;81FF
	dc.w	$41FF	;41FF
	dc.w	$79FF	;79FF
	dc.w	$67FF	;67FF
	dc.w	$F1FF	;F1FF
	dc.w	$01FF	;01FF
	dc.w	$05FF	;05FF
	dc.w	$0FFF	;0FFF
	dc.w	$ADFF	;ADFF
	dc.w	$51FF	;51FF
	dc.w	$73FF	;73FF
	dc.w	$13FF	;13FF
	dc.w	$93FF	;93FF
	dc.w	$2DFF	;2DFF
	dc.w	$3DFF	;3DFF
	dc.w	$09FF	;09FF
	dc.w	$ADFF	;ADFF
	dc.w	$51FF	;51FF
	dc.w	$73FF	;73FF
	dc.w	$13FF	;13FF
	dc.w	$F1FF	;F1FF
	dc.w	$01FF	;01FF
	dc.w	$05FF	;05FF
	dc.w	$0FFF	;0FFF
	dc.w	$C3FF	;C3FF
	dc.w	$83FF	;83FF
	dc.w	$B3FF	;B3FF
	dc.w	$AFFF	;AFFF
	dc.w	$F3FF	;F3FF
	dc.w	$03FF	;03FF
	dc.w	$0FFF	;0FFF
	dc.w	$07FF	;07FF
	dc.w	$AFFF	;AFFF
	dc.w	$13FF	;13FF
	dc.w	$33FF	;33FF
	dc.w	$13FF	;13FF
	dc.w	$F3FF	;F3FF
	dc.w	$03FF	;03FF
	dc.w	$0FFF	;0FFF
	dc.w	$07FF	;07FF
	dc.w	$C3FF	;C3FF
	dc.w	$83FF	;83FF
	dc.w	$B3FF	;B3FF
	dc.w	$AFFF	;AFFF
	dc.w	$E3FF	;E3FF
	dc.w	$83FF	;83FF
	dc.w	$83FF	;83FF
	dc.w	$9FFF	;9FFF
	dc.w	$DBFF	;DBFF
	dc.w	$23FF	;23FF
	dc.w	$67FF	;67FF
	dc.w	$27FF	;27FF
	dc.w	$A7FF	;A7FF
	dc.w	$1BFF	;1BFF
	dc.w	$3BFF	;3BFF
	dc.w	$13FF	;13FF
	dc.w	$DBFF	;DBFF
	dc.w	$23FF	;23FF
	dc.w	$67FF	;67FF
	dc.w	$27FF	;27FF
	dc.w	$E3FF	;E3FF
	dc.w	$83FF	;83FF
	dc.w	$83FF	;83FF
	dc.w	$9FFF	;9FFF
	dc.w	$3E7F	;3E7F
	dc.w	$007F	;007F
	dc.w	$80FF	;80FF
	dc.w	$417F	;417F
	dc.w	$497F	;497F
	dc.w	$367F	;367F
	dc.w	$BEFF	;BEFF
	dc.w	$147F	;147F
	dc.w	$3E7F	;3E7F
	dc.w	$007F	;007F
	dc.w	$80FF	;80FF
	dc.w	$417F	;417F
	dc.w	$39FF	;39FF
	dc.w	$01FF	;01FF
	dc.w	$83FF	;83FF
	dc.w	$45FF	;45FF
	dc.w	$55FF	;55FF
	dc.w	$29FF	;29FF
	dc.w	$BBFF	;BBFF
	dc.w	$29FF	;29FF
	dc.w	$39FF	;39FF
	dc.w	$01FF	;01FF
	dc.w	$83FF	;83FF
	dc.w	$45FF	;45FF
	dc.w	$E07F	;E07F
	dc.w	$087F	;087F
	dc.w	$1CFF	;1CFF
	dc.w	$1F7F	;1F7F
	dc.w	$907F	;907F
	dc.w	$6C7F	;6C7F
	dc.w	$EEFF	;EEFF
	dc.w	$4F7F	;4F7F
	dc.w	$E07F	;E07F
	dc.w	$087F	;087F
	dc.w	$1CFF	;1CFF
	dc.w	$1F7F	;1F7F
	dc.w	$C1FF	;C1FF
	dc.w	$01FF	;01FF
	dc.w	$13FF	;13FF
	dc.w	$3DFF	;3DFF
	dc.w	$A1FF	;A1FF
	dc.w	$51FF	;51FF
	dc.w	$DBFF	;DBFF
	dc.w	$5DFF	;5DFF
	dc.w	$C1FF	;C1FF
	dc.w	$01FF	;01FF
	dc.w	$13FF	;13FF
	dc.w	$3DFF	;3DFF
_GFX_Dragon:
	INCBIN bw-gfx/Dragon

_GFX_Entropy:
	INCBIN bw-gfx/Entropy

_GFX_Pockets:
	INCBIN bw-gfx/Pockets

AudioSample_1:
	INCBIN bw-sfx/sample1.sound

AudioSample_2:
	INCBIN bw-sfx/sample2.sound

AudioSample_3:
	INCBIN bw-sfx/sample3.sound

AudioSample_4:
	INCBIN bw-sfx/sample4.sound

AudioSample_5:
	INCBIN bw-sfx/sample5.sound

ReserveSpace_1:
	INCBIN bw-data/reservespace1.block

ReserveSpace_2:
	INCBIN bw-data/reservespace2.block

GameEnd:
	end

