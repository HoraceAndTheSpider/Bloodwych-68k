
dsksync:	equ	$0000007E
copjmp1:	equ	$00000088
copinit_SIZEOF:	equ	$000000F8
ucl_SIZEOF:	equ	$0000000C
aud:		equ	$000000A0
DMAF_SPRITE:	equ	$00000020
ac_vol:		equ	$00000008
adkcon:		equ	$0000009E
DMAF_MASTER:	equ	$00000200
INTF_EXTER:	equ	$00002000
_custom:	equ	$00DFF000
ddfstop:	equ	$00000094
CIACRAF_START:	equ	$00000001
bplcon2:	equ	$00000104
diwstrt:	equ	$0000008E
ac_per:		equ	$00000006
intreq:		equ	$0000009C
bplcon0:	equ	$00000100
bplcon1:	equ	$00000102
INTF_AUD1:	equ	$00000100
copinit_genloc:	equ	$000000D8
INTF_AUD0:	equ	$00000080
INTF_AUD3:	equ	$00000400
INTF_BLIT:	equ	$00000040
INTF_AUD2:	equ	$00000200
INTF_DSKBLK:	equ	$00000002
INTF_SOFTINT:	equ	$00000004
aud0:		equ	$000000A0
diwstop:	equ	$00000090
INTF_RBF:	equ	$00000800
CIAICRF_SETCLR:	equ	$00000080
ddfstrt:	equ	$00000092
CIAICRF_ALRM:	equ	$00000004
tv_Illegal:	equ	$00000010
tv_TrapInstrVects:	equ	$00000080
INTF_TBE:	equ	$00000001
crl_SIZEOF:	equ	$0000000A
ciaprb:		equ	$00000100
CPR_NT_LOF:	equ	$00008000
CIAICRF_FLG:	equ	$00000010
DMAF_COPPER:	equ	$00000080
tv_Trace:	equ	$00000024
CIACRAF_INMODE:	equ	$00000020
intena:		equ	$0000009A
INTB_SETCLR:	equ	$0000000F
INTF_PORTS:	equ	$00000008
INTF_SETCLR:	equ	$00008000
intreqr:	equ	$0000001E
joy0dat:	equ	$0000000A
ac_dat:		equ	$0000000A
tv_Lev4IntVect:	equ	$00000070
CIAICRF_SP:	equ	$00000008
tv_Lev3IntVect:	equ	$0000006C
tv_Lev2IntVect:	equ	$00000068
HOLDNMODIFY:	equ	$00000800
joy1dat:	equ	$0000000C
bpl2mod:	equ	$0000010A
color:		equ	$00000180
tv_BusError:	equ	$00000008
CIAICRF_TB:	equ	$00000002
bltddat:	equ	$00000000
bpl1mod:	equ	$00000108
CIAICRF_TA:	equ	$00000001
tv_SpuriousInterrupt:	equ	$00000060
INTF_COPER:	equ	$00000010
INTF_DSKSYNC:	equ	$00001000
INTF_VERTB:	equ	$00000020
ciaicr:		equ	$00000D00
ci_SIZEOF:	equ	$00000006
cl_SIZEOF:	equ	$00000022
dskpt:		equ	$00000020
DMAF_SETCLR:	equ	$00008000
cop1lc:		equ	$00000080
_ciaa:		equ	$00BFE001
_ciab:		equ	$00BFD000
dmacon:		equ	$00000096
tv_PrivilegeViolation:	equ	$00000020
DMAF_RASTER:	equ	$00000100
CPRNXTBUF:	equ	$00000002
dsklen:		equ	$00000024
ac_len:		equ	$00000004
ciacra:		equ	$00000E00
ciacrb:		equ	$00000F00
dskdatr:	equ	$00000008
INTF_INTEN:	equ	$00004000
****************************************************************************
;	Changed for Devpac:
;
	SECTION	BEXTCLEAN_041_8rs000000,CODE_C
;	SECTION	BEXTCLEAN_041_8rs000000,CODE,CHIP
ProgStart:
; Places GameStart at $0400
	ORG	$3A4
;  
	move.w	#$7FFF,_custom+intena.l	;33FC7FFF00DFF09A
	move.w	#$7FFF,_custom+intreq.l	;33FC7FFF00DFF09C
	lea	CodeMover(pc),a0	;41FA0020
	lea	$00000090.l,a1	;43F900000090
	moveq	#$28,d0	;7028
adrLp0003C0:	move.b	(a0)+,(a1)+	;12D8
	dbra	d0,adrLp0003C0	;51C8FFFC
	lea	GameStart(pc),a6	;4DFA0038
	move.l	#$00000090,tv_TrapInstrVects.l	;23FC0000009000000080
	trap	#$00	;4E40
CodeMover:	move.l	#$0005909C,d0	;203C0005909C
	move.w	#$7FFF,_custom+intreq.l	;33FC7FFF00DFF09C
	lea	GameStart.l,a0	;41F900000400
.loop:	move.b	(a6)+,(a0)+	;10DE
	subq.l	#$01,d0	;5380
	bcc.s	.loop	;64FA
	move.w	#$7FFF,_custom+intreq.l	;33FC7FFF00DFF09C
	jmp	GameStart.l	;4EF900000400

;fiX Label expected
	dc.w	$0000	;0000

GameStart:	move.w	#$7FFF,_custom+intena.l	;33FC7FFF00DFF09A
	move.w	#$7FFF,_custom+intreq.l	;33FC7FFF00DFF09C
	lea	$0005FFFC.l,sp	;4FF90005FFFC
	clr.b	adrB_0099EF.l	;4239000099EF
	bsr	adrCd000456	;61000038
	clr.b	adrB_00F989.l	;42390000F989
	clr.w	adrB_0099EE.l	;4279000099EE
	bsr	adrCd000946	;61000518
	bsr	MainMenu	;610002BE
	jsr	adrCd009B74.l	;4EB900009B74
	jsr	adrCd009B6C.l	;4EB900009B6C
	moveq	#$00,d0	;7000
	jsr	PlaySound.l	;4EB90000968E
	tst.w	MainMenuBuffer.l	;4A7900000626
	beq	adrCd000F0A	;67000ABA
	bra	adrCd000F0E	;60000ABA

adrCd000456:	jsr	adrCd009B86.l	;4EB900009B86
	move.w	#$4200,_custom+bplcon0.l	;33FC420000DFF100
	move.w	#$0000,_custom+bplcon1.l	;33FC000000DFF102
	move.w	#$0024,_custom+bplcon2.l	;33FC002400DFF104
	move.w	#$0000,_custom+bpl1mod.l	;33FC000000DFF108
	move.w	#$0000,_custom+bpl2mod.l	;33FC000000DFF10A
	move.w	#$0038,_custom+ddfstrt.l	;33FC003800DFF092
	move.w	#$00D0,_custom+ddfstop.l	;33FC00D000DFF094
	move.w	#$3781,_custom+diwstrt.l	;33FC378100DFF08E
	move.w	#$FFC1,_custom+diwstop.l	;33FCFFC100DFF090
	move.l	#CopperList000,_custom+cop1lc.l	;23FC00009BDC00DFF080
	move.l	#$00060000,screen_ptr.l	;23FC0006000000009B06
	jsr	adrCd009AD0.l	;4EB900009AD0
	lea	CopperList001.l,a0	;41F900009BFC
	lea	adrEA000576.l,a1	;43F900000576
	lea	adrEA00057E.l,a2	;45F90000057E
	moveq	#$07,d1	;7207
adrLp0004D2:	moveq	#$00,d0	;7000
	move.b	$00(a1,d1.w),d0	;10311000
	add.w	d0,d0	;D040
	add.w	d0,d0	;D040
	move.l	$00(a2,d0.w),d0	;20320000
	move.w	d0,$0006(a0)	;31400006
	swap	d0	;4840
	move.w	d0,$0002(a0)	;31400002
	addq.w	#$08,a0	;5048
	dbra	d1,adrLp0004D2	;51C9FFE4
	move.l	#AdrCd009A98,d0	;203C00009A98
	lea	tv_SpuriousInterrupt.l,a0	;41F900000060
	moveq	#$07,d1	;7207
adrLp0004FE:	move.l	d0,(a0)+	;20C0
	dbra	d1,adrLp0004FE	;51C9FFFC
	move.l	#VerticalBlankInterupt,tv_Lev3IntVect.l	;23FC000099F00000006C
	move.l	#Level_2_Interrupt,tv_Lev2IntVect.l	;23FC0000059A00000068
	move.l	#Level_4_Interrupt,tv_Lev4IntVect.l	;23FC0000967400000070
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

adrEA000576:	dc.b	$04	;04
	dc.b	$04	;04
	dc.b	$04	;04
	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$00	;00
adrEA00057E:	
	dc.l	SpritePosition_00	;00009C50
	dc.l	SpritePosition_01	;00009CE0
	dc.l	SpritePosition_04	;00009C98
	dc.l	SpritePosition_02	;00009D28
	dc.l	adrEA009C94	;00009C94
	dc.w	$0000	;0000
adrB_000594:	dc.b	$00	;00
KeyboardKeyCode:	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00

Level_2_Interrupt:	movem.l	d0/d1/a0,-(sp)	;48E7C080
	lea	_ciaa.l,a0	;41F900BFE001
	move.b	$0C00(a0),d0	;10280C00
	ror.b	#$01,d0	;E218
	not.b	d0	;4600
	move.b	d0,KeyboardKeyCode.l	;13C000000595
	or.b	#$40,$0E00(a0)	;002800400E00
	clr.b	$0C00(a0)	;42280C00
	move.b	$0100(a0),d1	;12280100
	bsr.s	CheckKeyboard	;612A
	moveq	#$2D,d0	;702D
adrLp0005C4:	dbra	d0,adrLp0005C4	;51C8FFFE
	lea	_ciaa.l,a0	;41F900BFE001
	move.b	$0D00(a0),d0	;10280D00
	and.b	#$BF,$0E00(a0)	;022800BF0E00
	move.b	d0,adrB_000594.l	;13C000000594
	movem.l	(sp)+,d0/d1/a0	;4CDF0103
	move.w	#$0008,_custom+intreq.l	;33FC000800DFF09C
	rte	;4E73

CheckKeyboard:	lea	RawKeyCodes.l,a0	;41F90000061A
	moveq	#$0B,d1	;720B
.keyboardloop:	cmp.b	(a0)+,d0	;B018
	beq.s	KeyboardAction	;6706
	dbra	d1,.keyboardloop	;51C9FFFA
	rts	;4E75

KeyboardAction:	lea	Player1_Data.l,a0	;41F90000F9D8
	subq.w	#$06,d1	;5D41
	bcc.s	.skipPlayer2	;6408
	addq.w	#$06,d1	;5C41
	lea	Player2_Data.l,a0	;41F90000FA3A
.skipPlayer2:	add.w	#$000A,d1	;0641000A
	move.b	d1,$0056(a0)	;11410056
	rts	;4E75

RawKeyCodes:	dc.b	$5F	;5F
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
	dc.w	$0000	;0000
MainMenuInitColours:	
	dc.w	$0000	;0000
	dc.w	$FD00	;FD00
	dc.b	$F0	;F0
MainMenuText:	dc.b	$FE	;FE
	dc.b	$0C	;0C
	dc.b	$FC	;FC
	dc.b	$04	;04
	dc.b	$03	;03
	dc.b	'BLOODWYCH - THE EXTENDED LEVELS'	;424C4F4F4457594348202D2054484520455854454E444544204C4556454C53
	dc.b	$FE	;FE
	dc.b	$06	;06
	dc.b	$FC	;FC
	dc.b	$04	;04
	dc.b	$08	;08
	dc.b	'F1   LOAD ONE PLAYER GAME'	;46312020204C4F4144204F4E4520504C415945522047414D45
	dc.b	$FC	;FC
	dc.b	$04	;04
	dc.b	$0A	;0A
	dc.b	'F2   LOAD TWO PLAYER GAME'	;46322020204C4F41442054574F20504C415945522047414D45
	dc.b	$FC	;FC
	dc.b	$04	;04
	dc.b	$0E	;0E
	dc.b	'F9   TRANSFER ONE PLAYER BLOODWYCH'	;46392020205452414E53464552204F4E4520504C4159455220424C4F4F4457594348
	dc.b	$FC	;FC
	dc.b	$04	;04
	dc.b	$10	;10
	dc.b	'F10  TRANSFER TWO PLAYER BLOODWYCH'	;46313020205452414E534645522054574F20504C4159455220424C4F4F4457594348
	dc.b	$FE	;FE
	dc.b	$03	;03
	dc.b	$FC	;FC
	dc.b	$0A	;0A
	dc.b	$18	;18
	dc.b	'(C) MIRRORSOFT 1989'	;284329204D4952524F52534F46542031393839
	dc.b	$FE	;FE
	dc.b	$06	;06
	dc.b	$FF	;FF

MainMenu:	
	clr.w	Multiplayer.l		;42790000F98C
	jsr	adrCd009B74.l		;4EB900009B74
	jsr	adrCd009B6C.l		;4EB900009B6C
	lea	MainMenuText.l,a6	;4DF90000062D
	tst.w	MainMenuInitColours.l		;4A7900000628
	bne.s	.menuscreen		;6602
	subq.w	#$03,a6	;574E
.menuscreen:	
	lea	Player1_Data.l,a5	;4BF90000F9D8
	jsr	adrCd00DAA6.l		;4EB90000DAA6
	jsr	adrCd009A9A.l		;4EB900009A9A
	tst.w	MainMenuInitColours.l		;4A7900000628
	bne.s	MenuKeyboard		;660E
	move.w	#$FFFF,MainMenuInitColours.l	;33FCFFFF00000628
	jsr	adrCd009648.l		;4EB900009648
MenuKeyboard:	
	clr.b	KeyboardKeyCode.l		;423900000595
MenuKeyboardLoop:	
	move.b	KeyboardKeyCode.l,d0	;103900000595
	sub.b	#$50,d0			;04000050
	beq	Ply2_ImportGame		;67000016
	subq.b	#$01,d0			;5300
	beq	Ply1_ImportGame	;67000018
	subq.b	#$01,d0			;5300
	subq.b	#$01,d0			;5300
	subq.b	#$05,d0			;5B00
	beq.s	Ply1_Start		;6772
	subq.b	#$01,d0			;5300
	beq.s	Ply1_LoadGame		;6778
	bra.s	MenuKeyboardLoop	;60DE

Ply2_ImportGame:	
	move.w	#$FFFF,Multiplayer.l	;33FCFFFF0000F98C
Ply1_ImportGame:	
	move.l	#$00067D00,screen_ptr.l	;23FC00067D0000009B06
	move.l	#$00060000,framebuffer_ptr.l	;23FC0006000000009B0A
	jsr	adrCd009B74.l	;4EB900009B74
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	#$0E10,a0	;D0FC0E10
	lea	InsertLoadDiskMsg.l,a6	;4DF900004C87
	jsr	adrCd00DAA6.l	;4EB90000DAA6
	jsr	adrCd009A9A.l	;4EB900009A9A
	clr.b	KeyboardKeyCode.l	;423900000595
	bsr	adrCd004BA2	;610043FA
	bcs	MainMenu	;6500FF44
	bsr	adrCd004BC0	;61004410
	bsr	adrCd004BDE	;6100442A
	cmp.b	#$FF,CharacterStats+$15.l	;0C3900FF0000F59B
	beq	MainMenu	;6700FF30
	move.w	#$FFFF,MainMenuBuffer.l	;33FCFFFF00000626
	bra	adrCd000ED4	;60000708

Ply1_Start:	
	move.w	#$FFFF,Multiplayer.l	;33FCFFFF0000F98C
	bra.s	adrCd0007DE	;6006

Ply1_LoadGame:	
	clr.w	Multiplayer.l	;42790000F98C
adrCd0007DE:	
	move.l	#$00067D00,screen_ptr.l	;23FC00067D0000009B06
	move.l	#$00060000,framebuffer_ptr.l	;23FC0006000000009B0A
	jsr	adrCd009B74.l	;4EB900009B74
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	#$0E10,a0	;D0FC0E10
	lea	InsertLoadDiskMsg.l,a6	;4DF900004C87
	jsr	adrCd00DAA6.l	;4EB90000DAA6
	jsr	adrCd009A9A.l	;4EB900009A9A
	clr.b	KeyboardKeyCode.l	;423900000595
	bsr	adrCd004BA2	;61004386
	bcs	MainMenu	;6500FED0
	jsr	adrCd004BC0.l	;4EB900004BC0
	jsr	CopyProtection.l	;4EB90000DB18
	tst.l	d0	;4A80
	beq	adrCd004BD4	;670043A2
	move.l	screen_ptr.l,adrL_0092F0.l	;23F900009B06000092F0
	jsr	adrCd0094D2.l	;4EB9000094D2
	move.w	adrW_004C1C.l,d7	;3E3900004C1C
	jsr	adrCd00965E.l	;4EB90000965E
	lea	$00070000.l,a0	;41F900070000
	moveq	#$08,d0	;7008
	jsr	adrCd009490.l	;4EB900009490
	jsr	adrCd009648.l	;4EB900009648
	lea	$00070000.l,a0	;41F900070000
	move.l	$036A(a0),adrB_00F9F0.l	;23E8036A0000F9F0
	move.l	$03CC(a0),adrB_00FA52.l	;23E803CC0000FA52
	lea	adrEA014CA4.l,a1	;43F900014CA4
	lea	$7E22(a0),a2	;45E87E22
	move.w	#$01FF,d0	;303C01FF
adrLp000888:	
	move.b	(a2)+,(a1)+	;12DA
	dbra	d0,adrLp000888	;51C8FFFC
	lea	Player1_Data.l,a5	;4BF90000F9D8
	move.w	#$0116,d5	;3A3C0116
	bsr.s	adrCd0008AE	;6114
	tst.w	Multiplayer.l	;4A790000F98C
	bmi	adrCd000924	;6B000082
	lea	Player2_Data.l,a5	;4BF90000FA3A
	move.w	#$1516,d5	;3A3C1516
adrCd0008AE:		
	tst.b	$0018(a5)	;4A2D0018
	bmi.s	adrCd000924	;6B70
	clr.w	$0006(a5)	;426D0006
	moveq	#$03,d7	;7E03
adrLp0008BA:	
	move.b	$18(a5,d7.w),d0	;10357018
	bmi.s	adrCd000902	;6B42
	and.w	#$000F,d0	;0240000F
	move.b	d0,$18(a5,d7.w)	;1B807018
	move.b	d0,$26(a5,d7.w)	;1B807026
	move.w	d0,d1	;3200
	bsr	adrCd0072D4	;61006A04
	moveq	#$0F,d6	;7C0F
adrLp0008D4:	
	clr.b	$30(a4,d6.w)	;42346030
	dbra	d6,adrLp0008D4	;51CEFFFA
	asl.w	#$05,d1	;EB41
	lea	$00(a0,d1.w),a3	;47F01000
	moveq	#$00,d0	;7000
	moveq	#$1F,d6	;7C1F
adrLp0008E6:	move.b	adrB_000926(pc,d6.w),d0	;103B603E
	move.b	$00(a3,d6.w),$00(a4,d0.w)	;19B360000000
	dbra	d6,adrLp0008E6	;51CEFFF4
	move.b	#$FF,$001A(a4)	;197C00FF001A
	asl.w	$0006(a4)	;E1EC0006
	asl.w	$0008(a4)	;E1EC0008
adrCd000902:	dbra	d7,adrLp0008BA	;51CFFFB6
	move.b	$0018(a5),$0007(a5)	;1B6D00180007
	bsr	adrCd0072D0	;610069C2
	move.b	d5,$001B(a4)	;1945001B
	ror.w	#$08,d5	;E05D
	move.b	d5,$001A(a4)	;1945001A
	clr.b	$001C(a4)	;422C001C
	move.b	#$04,$001E(a4)	;197C0004001E
adrCd000924:	rts	;4E75

adrB_000926:	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$05	;05
	dc.b	$07	;07
	dc.b	$09	;09
	dc.b	$0A	;0A
	dc.b	$0B	;0B
	dc.b	$0C	;0C
	dc.b	$0D	;0D
	dc.b	$0E	;0E
	dc.b	$10	;10
	dc.b	$11	;11
	dc.b	$12	;12
	dc.b	$13	;13
	dc.b	$14	;14
	dc.b	$15	;15
	dc.b	$16	;16
	dc.b	$17	;17
	dc.b	$18	;18
	dc.b	$19	;19
	dc.b	$1A	;1A
	dc.b	$1B	;1B
	dc.b	$1C	;1C
	dc.b	$1D	;1D
	dc.b	$1E	;1E
	dc.b	$1F	;1F
	dc.b	$20	;20
	dc.b	$21	;21
	dc.b	$22	;22
	dc.b	$23	;23

adrCd000946:	lea	adrEA014BA4.l,a0	;41F900014BA4
	move.w	#$00FF,d7	;3E3C00FF
adrLp000950:	move.w	d7,d0	;3007
	moveq	#$07,d6	;7C07
adrLp000954:	lsr.b	#$01,d0	;E208
	addx.b	d1,d1	;D301
	dbra	d6,adrLp000954	;51CEFFFA
	move.b	d1,$00(a0,d7.w)	;11817000
	dbra	d7,adrLp000950	;51CFFFEE
	lea	adrEA014CA4.l,a0	;41F900014CA4
	moveq	#$7F,d0	;707F
adrLp00096C:	clr.l	(a0)+	;4298
	dbra	d0,adrLp00096C	;51C8FFFC
	rts	;4E75

;fiX Label expected
	moveq	#$0F,d7	;7E0F
adrLp000976:	move.w	d7,d0	;3007
	bsr	adrCd000986	;6100000C
	move.b	d0,$000C(a4)	;1940000C
	dbra	d7,adrLp000976	;51CFFFF4
	rts	;4E75

adrCd000986:	bsr	adrCd0072D4	;6100694C
adrCd00098A:	bsr.s	adrCd0009BC	;6130
	asl.w	#$02,d0	;E540
	move.b	$0004(a4),d1	;122C0004
	lsr.b	#$01,d1	;E209
	add.b	d1,d0	;D001
	cmp.b	#$64,d0	;0C000064
	bcs.s	adrCd00099E	;6502
	moveq	#$63,d0	;7063
adrCd00099E:	move.b	d0,$000D(a4)	;1940000D
	rts	;4E75

adrCd0009A4:	bsr.s	adrCd0009DA	;6134
	move.b	adrB_0009B8(pc,d1.w),d1	;123B1010
	bpl.s	adrCd0009CE	;6A22
	moveq	#$00,d0	;7000
	move.b	(a4),d0	;1014
	add.w	d0,d0	;D040
	add.b	(a4),d0	;D014
	lsr.w	#$02,d0	;E448
	rts	;4E75

adrB_0009B8:	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$FF	;FF
	dc.b	$02	;02

adrCd0009BC:	bsr.s	adrCd0009DA	;611C
	move.b	adrB_0009C4(pc,d1.w),d1	;123B1004
	bra.s	adrCd0009CE	;600A

adrB_0009C4:	dc.b	$02	;02
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02

adrCd0009C8:	bsr.s	adrCd0009DA	;6110
	move.b	adrB_0009D6(pc,d1.w),d1	;123B100A
adrCd0009CE:	moveq	#$00,d0	;7000
	move.b	(a4),d0	;1014
	lsr.w	d1,d0	;E268
	rts	;4E75

adrB_0009D6:	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$00	;00

adrCd0009DA:	moveq	#$00,d1	;7200
	move.b	$0001(a4),d1	;122C0001
adrCd0009E0:	move.l	a0,-(sp)	;2F08
	lea	characters.heads.l,a0	;41F90000B788
	move.b	$00(a0,d1.w),d1	;12301000
	lea	adrEA00D6B6.l,a0	;41F90000D6B6
	move.b	$00(a0,d1.w),d1	;12301000
	and.w	#$0003,d1	;02410003
	move.l	(sp)+,a0	;205F
	rts	;4E75

adrCd0009FE:	moveq	#$00,d7	;7E00
	moveq	#$00,d6	;7C00
	move.l	adrL_00F9D4.l,a6	;2C790000F9D4
	lea	$0FCA(a6),a0	;41EE0FCA
adrCd000A0C:	cmp.w	-$0002(a0),d7	;BE68FFFE
	bcc.s	adrCd000A32	;6420
	move.b	$00(a0,d7.w),d0	;10307000
	rol.w	#$08,d0	;E158
	move.b	$01(a0,d7.w),d0	;10307001
	and.w	#$3FFF,d0	;02403FFF
	bset	#$06,$01(a6,d0.w)	;08F600060001
	move.b	$02(a0,d7.w),d6	;1C307002
	add.w	d6,d6	;DC46
	addq.w	#$05,d6	;5A46
	add.w	d6,d7	;DE46
	bra.s	adrCd000A0C	;60DA

adrCd000A32:	rts	;4E75

adrCd000A34:	lea	adrEA014ED4.l,a6	;4DF900014ED4
	moveq	#$0F,d0	;700F
adrLp000A3C:	move.b	#$FF,$00(a6,d0.w)	;1DBC00FF0000
	dbra	d0,adrLp000A3C	;51C8FFF8
	moveq	#$00,d0	;7000
	lea	Player1_Data.l,a5	;4BF90000F9D8
	bsr.s	adrCd000A56	;6106
	lea	Player2_Data.l,a5	;4BF90000FA3A
adrCd000A56:	moveq	#$03,d7	;7E03
adrLp000A58:	move.b	$18(a5,d7.w),d0	;10357018
	bmi.s	adrCd000A66	;6B08
	and.w	#$000F,d0	;0240000F
	clr.b	$00(a6,d0.w)	;42360000
adrCd000A66:	dbra	d7,adrLp000A58	;51CFFFF0
	rts	;4E75

adrCd000A6C:	lea	adrEA014ED4.l,a6	;4DF900014ED4
	moveq	#$0F,d1	;720F
adrLp000A74:	tst.b	$00(a6,d1.w)	;4A361000
	bmi.s	adrCd000A8A	;6B10
	dbra	d1,adrLp000A74	;51C9FFF8
	move.w	d1,d0	;3001
	move.w	#$0700,_custom+color.l	;33FC070000DFF180
	rts	;4E75

adrCd000A8A:	move.b	#$01,$00(a6,d1.w)	;1DBC00011000
	movem.l	d1/a4,-(sp)	;48E74008
	move.w	d0,d4	;3800
	lea	adrEA0156E6.l,a4	;49F9000156E6
	moveq	#$0F,d0	;700F
adrLp000A9E:	move.b	$00(a0,d0.w),$00(a4,d0.w)	;19B000000000
	dbra	d0,adrLp000A9E	;51C8FFF8
	jsr	adrCd00924C.l	;4EB90000924C
	exg	d0,d4	;C144
	bsr	adrCd002CF6	;61002244
	move.w	$0002(sp),d0	;302F0002
	bsr	adrCd0072D4	;6100681A
	lea	adrEA0156E6.l,a0	;41F9000156E6
	move.b	$0001(a4),d2	;142C0001
	cmp.b	$000B(a0),d2	;B428000B
	bne.s	adrCd000AD6	;660A
	move.b	(a4),d2	;1414
	cmp.b	$0006(a0),d2	;B4280006
	beq	adrCd000C86	;670001B2
adrCd000AD6:	moveq	#$00,d2	;7400
	move.b	$0006(a0),d2	;14280006
	move.b	d2,(a4)	;1882
	move.w	d2,d3	;3602
	add.w	d3,d3	;D643
	add.w	#$0014,d3	;06430014
	move.b	d3,$0003(a4)	;19430003
	add.w	d2,d3	;D642
	move.b	d3,$000A(a4)	;1943000A
	move.b	d3,$000B(a4)	;1943000B
	sub.w	d2,d3	;9642
	add.w	d3,d3	;D643
	sub.w	#$000A,d3	;0443000A
	move.b	d3,$0002(a4)	;19430002
	move.w	d2,d3	;3602
	add.w	d2,d3	;D642
	add.w	d2,d3	;D642
	lsr.w	#$01,d3	;E24B
	move.b	d3,$000E(a4)	;1943000E
	move.b	$0003(a0),$001D(a4)	;19680003001D
	move.w	$0008(a0),$0006(a4)	;396800080006
	move.w	$0008(a0),$0008(a4)	;396800080008
	move.b	$000B(a0),$0001(a4)	;1968000B0001
	move.b	$000A(a0),$0024(a4)	;1968000A0024
	and.b	#$07,$0024(a4)	;022C00070024
	move.b	#$C7,$0014(a4)	;197C00C70014
	move.b	CurrentTower+$1.l,$0023(a4)	;19790000F98B0023
	move.b	(a4),d2	;1414
	add.w	d2,d2	;D442
	add.b	(a4),d2	;D414
	move.w	$0002(sp),d0	;302F0002
	asl.w	#$04,d0	;E940
	lea	adrEA014CA4.l,a2	;45F900014CA4
	add.w	d0,a2	;D4C0
	moveq	#$1F,d0	;701F
adrLp000B54:	move.b	d2,$00(a2,d0.w)	;15820000
	dbra	d0,adrLp000B54	;51C8FFFA
AdrEA000B5C:	moveq	#$0F,d3	;760F
adrLp000B5E:	clr.b	$30(a4,d3.w)	;42343030
	dbra	d3,adrLp000B5E	;51CBFFFA
	move.b	$000C(a0),d2	;1428000C
	cmp.b	#$05,d2	;0C020005
	bcs.s	adrCd000B74	;6504
	move.b	d2,$0036(a4)	;19420036
adrCd000B74:	bsr	adrCd0028D4	;61001D5E
	move.w	d5,d0	;3005
	beq.s	adrCd000B8A	;670E
	move.b	d5,$0035(a4)	;19450035
	subq.b	#$05,d5	;5B05
	bcc.s	adrCd000B8A	;6406
	swap	d5	;4845
	move.b	d5,$3B(a4,d0.w)	;1985003B
adrCd000B8A:	bsr	adrCd0009DA	;6100FE4E
	lea	adrEA000CB2.l,a0	;41F900000CB2
	move.b	$00(a0,d1.w),$0030(a4)	;197010000030
	move.b	$0002(a4),d0	;102C0002
	add.b	$04(a0,d1.w),d0	;D0301004
	move.b	d0,$0004(a4)	;19400004
	move.b	$0002(a4),d0	;102C0002
	add.b	$08(a0,d1.w),d0	;D0301008
	move.b	d0,$0005(a4)	;19400005
	move.b	$0003(a4),d0	;102C0003
	add.b	$0C(a0,d1.w),d0	;D030100C
	move.b	d0,$0003(a4)	;19400003
	move.b	$0002(a4),d0	;102C0002
	add.b	$10(a0,d1.w),d0	;D0301010
	move.b	d0,$0002(a4)	;19400002
	move.b	#$FF,$0017(a4)	;197C00FF0017
	move.b	#$FF,$000F(a4)	;197C00FF000F
	clr.b	$0015(a4)	;422C0015
	clr.b	$0019(a4)	;422C0019
	clr.b	$0022(a4)	;422C0022
	move.w	d1,d3	;3601
	move.b	$0001(a4),d0	;102C0001
	move.b	(a4),d2	;1414
	jsr	adrCd00E1AA.l	;4EB90000E1AA
	move.b	$0001(a4),d0	;102C0001
	bsr	adrCd0075DC	;610069E6
	and.b	#$FC,d7	;020700FC
	or.b	d0,d7	;8E00
	rol.w	#$05,d7	;EB5F
	bsr	adrCd0009BC	;6100FDBA
	add.w	d0,d0	;D040
	move.b	$18(a0,d3.w),d3	;16303018
	sub.w	d3,d0	;9043
	bcc.s	adrCd000C14	;6406
	add.w	d3,d0	;D043
	moveq	#-$01,d3	;76FF
	bra.s	adrCd000C18	;6004

adrCd000C14:	exg	d0,d3	;C143
	subq.w	#$01,d0	;5340
adrCd000C18:	move.l	#$08080808,$0014(a0)	;217C080808080014
	moveq	#$00,d6	;7C00
	lea	adrEA004DE6.l,a6	;4DF900004DE6
adrLp000C28:	bsr.s	adrCd000C8C	;6162
	dbra	d0,adrLp000C28	;51C8FFFC
	moveq	#$00,d0	;7000
	tst.w	d3	;4A43
	bmi.s	adrCd000C78	;6B44
adrLp000C34:	tst.w	d0	;4A40
	bne.s	adrCd000C72	;663A
	ror.w	#$05,d7	;EA5F
	move.w	d7,d1	;3207
	and.w	#$0003,d1	;02410003
	bne.s	adrCd000C72	;6630
	ror.w	#$05,d7	;EA5F
	move.w	d7,d0	;3007
	and.w	#$0003,d0	;02400003
	move.b	d0,$000F(a4)	;1940000F
	move.b	#$08,$14(a0,d0.w)	;11BC00080014
	asl.w	#$03,d0	;E740
	lea	$00(a6,d0.w),a1	;43F60000
	moveq	#$07,d0	;7007
	moveq	#$00,d2	;7400
adrLp000C5E:	move.b	$00(a1,d0.w),d2	;14310000
	move.b	#$0A,$00(a2,d2.w)	;15BC000A2000
	eor.b	#$1F,d2	;0A02001F
	bclr	d2,d6	;0586
	dbra	d0,adrLp000C5E	;51C8FFEE
adrCd000C72:	bsr.s	adrCd000C8C	;6118
	dbra	d3,adrLp000C34	;51CBFFBE
adrCd000C78:	move.l	d6,$0010(a4)	;29460010
	bsr	adrCd00098A	;6100FD0C
	move.b	$000D(a4),$000C(a4)	;196C000D000C
adrCd000C86:	movem.l	(sp)+,d0/a4	;4CDF1001
	rts	;4E75

adrCd000C8C:	ror.w	#$05,d7	;EA5F
	move.w	d7,d1	;3207
	and.w	#$0003,d1	;02410003
	moveq	#$00,d2	;7400
	move.b	$14(a0,d1.w),d2	;14301014
	subq.w	#$01,d2	;5342
	bcs.s	adrCd000CB0	;6512
	move.b	d2,$14(a0,d1.w)	;11821014
	asl.w	#$03,d1	;E741
	add.w	d2,d1	;D242
	move.b	$00(a6,d1.w),d2	;14361000
	eor.b	#$1F,d2	;0A02001F
	bset	d2,d6	;05C6
adrCd000CB0:	rts	;4E75

adrEA000CB2:	dc.b	$32	;32
	dc.b	$3D	;3D
	dc.b	$3E	;3E
	dc.b	$30	;30
	dc.b	$F6	;F6
	dc.b	$07	;07
	dc.b	$FE	;FE
	dc.b	$FA	;FA
	dc.b	$FA	;FA
	dc.b	$F8	;F8
	dc.b	$08	;08
	dc.b	$FE	;FE
	dc.b	$00	;00
	dc.b	$F8	;F8
	dc.b	$04	;04
	dc.b	$0C	;0C
	dc.b	$00	;00
	dc.b	$F4	;F4
	dc.b	$FB	;FB
	dc.b	$F8	;F8
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$09	;09
	dc.b	$1E	;1E
	dc.b	$10	;10
	dc.b	$08	;08

adrCd000CCE:	bsr	adrCd000A34	;6100FD64
	bsr	adrCd000ED4	;61000200
	lea	CharacterStats.l,a4	;49F90000F586
	moveq	#$0F,d6	;7C0F
adrLp000CDE:	clr.b	$0015(a4)	;422C0015
	clr.b	$0025(a4)	;422C0025
	move.b	#$FF,$0017(a4)	;197C00FF0017
	clr.b	$0022(a4)	;422C0022
	clr.b	$0016(a4)	;422C0016
	move.b	#$7F,$000F(a4)	;197C007F000F
	clr.b	$001F(a4)	;422C001F
	move.b	#$FF,$0021(a4)	;197C00FF0021
	move.w	d6,d0	;3006
	eor.b	#$0F,d0	;0A00000F
	bsr	adrCd00556A	;6100485E
	move.b	$000D(a4),$000C(a4)	;196C000D000C
	moveq	#$00,d0	;7000
	move.b	$001E(a4),d0	;102C001E
	jsr	adrCd0092AA.l	;4EB9000092AA
	moveq	#$00,d7	;7E00
	move.b	$001A(a4),d7	;1E2C001A
	bmi.s	adrCd000D3A	;6B12
	swap	d7	;4847
	move.b	$001B(a4),d7	;1E2C001B
	jsr	CoordToMap.l	;4EB90000926C
	bset	#$07,$01(a6,d0.w)	;08F600070001
adrCd000D3A:	lea	$0040(a4),a4	;49EC0040
	dbra	d6,adrLp000CDE	;51CEFF9E
adrCd000D42:	bsr	adrCd0009FE	;6100FCBA
	lea	DroppedObjects.l,a2	;45F900016568
	move.w	CurrentTower.l,d0	;30390000F98A
	add.w	d0,d0	;D040
	move.w	$00(a2,d0.w),d0	;30320000
	lea	$08(a2,d0.w),a2	;45F20008
	lea	adrEA0156F8.l,a4	;49F9000156F8
	moveq	#-$01,d6	;7CFF
	move.w	d6,-$0002(a4)	;3946FFFE
	moveq	#$18,d0	;7018
adrLp000D6A:	move.l	d6,(a4)+	;28C6
	dbra	d0,adrLp000D6A	;51C8FFFC
	lea	UnpackedMonsters.l,a4	;49F900014EE6
	move.w	#$01FF,d0	;303C01FF
adrLp000D7A:	move.l	d6,(a4)+	;28C6
	dbra	d0,adrLp000D7A	;51C8FFFC
	move.w	CurrentTower.l,d0	;30390000F98A
	move.w	d0,d1	;3200
	add.w	d0,d0	;D040
	lea	MonsterTotalsCounts.l,a4	;49F900015960
	move.w	$00(a4,d0.w),d6	;3C340000
	lea	UnpackedMonsters.l,a4	;49F900014EE6
	move.w	d6,-$0002(a4)	;3946FFFE
	bmi	Trigger_00_t00_Null	;6B006F50
	add.w	d1,d0	;D041
	asl.w	#$08,d0	;E140
	lea	serpex.monsters.l,a3	;47F900015968
	add.w	d0,a3	;D6C0
	moveq	#$00,d4	;7800
adrLp000DB0:	clr.b	$0005(a4)	;422C0005
	clr.b	$0002(a4)	;422C0002
	move.b	#$FF,$000C(a4)	;197C00FF000C
	move.b	(a3)+,d0	;101B
	subq.b	#$01,d0	;5300
	move.b	d0,d1	;1200
	bpl.s	adrCd000DCA	;6A04
	move.b	(a2)+,$000C(a4)	;195A000C
adrCd000DCA:	lsr.b	#$04,d1	;E809
	move.b	d1,$000A(a4)	;1941000A
	and.w	#$000F,d0	;0240000F
	move.b	d0,$0004(a4)	;19400004
	jsr	adrCd0092AA.l	;4EB9000092AA
	moveq	#$00,d7	;7E00
	move.b	(a3)+,d7	;1E1B
	move.b	d7,$0000(a4)	;19470000
	swap	d7	;4847
	move.b	(a3)+,d7	;1E1B
	move.b	d7,$0001(a4)	;19470001
	btst	#$17,d7	;08070017
	bne.s	adrCd000E00	;660C
	jsr	CoordToMap.l	;4EB90000926C
	bset	#$07,$01(a6,d0.w)	;08F600070001
adrCd000E00:	moveq	#$00,d0	;7000
	move.b	(a3)+,d0	;101B
AdrEA000E04:	move.b	d0,$0006(a4)	;19400006
	move.b	d0,$0007(a4)	;19400007
	moveq	#$0E,d1	;720E
	sub.b	d0,d1	;9200
	bcs.s	adrCd000E18	;6506
	cmp.b	#$08,d1	;0C010008
	bcc.s	adrCd000E1A	;6402
adrCd000E18:	moveq	#$08,d1	;7208
adrCd000E1A:	asl.b	#$04,d1	;E901
	move.b	d1,$0003(a4)	;19410003
	move.w	#$0190,d1	;323C0190
	cmp.b	#$1E,d0	;0C00001E
	bcc.s	adrCd000E38	;640E
	move.w	#$00C8,d1	;323C00C8
	cmp.b	#$18,d0	;0C000018
	bcc.s	adrCd000E38	;6404
	move.b	adrB_000E86(pc,d0.w),d1	;123B0050
adrCd000E38:	mulu	d1,d0	;C0C1
	add.w	#$0019,d0	;06400019
	move.w	d0,$0008(a4)	;39400008
	move.b	(a3)+,$000B(a4)	;195B000B
	bpl.s	adrCd000E50	;6A08
	clr.b	$0003(a4)	;422C0003
	clr.w	$0008(a4)	;426C0008
adrCd000E50:	moveq	#$00,d0	;7000
	move.b	(a3)+,d0	;101B
	cmp.b	#$FF,d0	;0C0000FF
	beq.s	adrCd000E7A	;6720
	lea	adrEA0156F8.l,a0	;41F9000156F8
	move.b	d4,$00(a0,d0.w)	;11840000
	move.b	d0,d1	;1200
	and.b	#$03,d1	;02010003
	tst.b	$0000(a4)	;4A2C0000
	bmi.s	adrCd000E7A	;6B0A
	addq.w	#$01,-$0002(a0)	;5268FFFE
	lsr.b	#$02,d0	;E408
	move.b	d0,$000D(a4)	;1940000D
adrCd000E7A:	lea	$0010(a4),a4	;49EC0010
	addq.w	#$01,d4	;5244
	dbra	d6,adrLp000DB0	;51CEFF2E
	rts	;4E75

adrB_000E86:	dc.b	$00	;00
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
	dc.b	$96	;96
	dc.b	$96	;96
	dc.b	$96	;96
	dc.b	$96	;96
	dc.b	$96	;96
	dc.b	$A0	;A0
	dc.b	$A0	;A0
	dc.b	$AA	;AA
	dc.b	$AA	;AA
	dc.b	$B4	;B4
	dc.b	$B4	;B4
	dc.b	$BE	;BE
	dc.b	$BE	;BE

adrCd000E9E:	bsr	adrCd0072D0	;61006430
	moveq	#$00,d0	;7000
	move.b	$001A(a4),d0	;102C001A
	bmi.s	adrCd000ED2	;6B28
	move.b	#$FF,$001A(a4)	;197C00FF001A
	move.w	d0,$001C(a5)	;3B40001C
	move.b	$001B(a4),d0	;102C001B
	move.b	#$FF,$001B(a4)	;197C00FF001B
	move.w	d0,$001E(a5)	;3B40001E
	move.b	$001C(a4),d0	;102C001C
	move.w	d0,$0020(a5)	;3B400020
	move.b	$001E(a4),d0	;102C001E
	move.w	d0,$0058(a5)	;3B400058
adrCd000ED2:	rts	;4E75

adrCd000ED4:
	move.w	CurrentTower.l,d0	;30390000F98A
	add.w	d0,d0	;D040
	lea	adrEA000F02.l,a0	;41F900000F02
	lea	MapData1.l,a6	;4DF90000FA9C
	add.w	$00(a0,d0.w),a6	;DCF00000
	lea	adrEA00F99C.l,a0	;41F90000F99C
	moveq	#$0D,d0	;700D
adrLp000EF4:	move.l	(a6)+,(a0)+	;20DE
	dbra	d0,adrLp000EF4	;51C8FFFC
	move.l	a6,adrL_00F9D4.l	;23CE0000F9D4
	rts	;4E75

adrEA000F02:
	dc.w	MapData1-MapData1	;0000
	dc.w	MapData2-MapData1	;1402
	dc.w	MaoData3-MapData1	;2804
	dc.w	MapData4-MapData1	;3C06

adrCd000F0A:
	bsr	adrCd000CCE			;6100FDC2
adrCd000F0E:
	clr.w	adrB_0099EE.l			;4279000099EE
	move.b	#$FF,adrB_00F988.l		;13FC00FF0000F988
	lea	Player1_Data.l,a5		;4BF90000F9D8
	move.l	#$00F00020,$0002(a5)		;2B7C00F000200002
	move.w	#$5601,$003A(a5)		;3B7C5601003A
	tst.w	Multiplayer.l			;4A790000F98C
	beq.s	adrCd000F5E			;6726
	move.w	#$8223,$003A(a5)		;3B7C8223003A
	move.l	#$FFFFFFFF,adrB_00FA52.l	;23FCFFFFFFFF0000FA52
	move.w	#$0027,$0008(a5)		;3B7C00270008
	move.w	#$0618,$000A(a5)		;3B7C0618000A
	clr.l	adrL_00FA3C.l			;42B90000FA3C
	moveq	#$00,d7				;7E00
	bra.s	adrLp000F80			;6022

adrCd000F5E:	lea	Player2_Data.l,a5	;4BF90000FA3A
	move.l	#$00F00088,$0002(a5)		;2B7C00F000880002
	move.w	#$BE68,$003A(a5)		;3B7CBE68003A
	move.w	#$0068,$0008(a5)		;3B7C00680008
	move.w	#$1040,$000A(a5)		;3B7C1040000A
	moveq	#$01,d7				;7E01
adrLp000F80:	clr.w	$0014(a5)		;426D0014
	move.w	#$FFFF,$0042(a5)		;3B7CFFFF0042
	move.w	#$FFFF,$0040(a5)		;3B7CFFFF0040
	bsr	adrCd000E9E			;6100FF0C
	bset	#$04,$0018(a5)			;08ED00040018
	lea	Player1_Data.l,a5		;4BF90000F9D8
	dbra	d7,adrLp000F80			;51CFFFDE
	bsr	adrCd004A4E			;61003AA8
	move.w	#$FFFF,adrB_0099EE.l		;33FCFFFF000099EE
adrCd000FB0:	tst.b	adrB_0099EE.l		;4A39000099EE
	bne.s	adrCd000FB0			;66F8
adrCd000FB8:	
	lea	Player1_Data.l,a5	;4BF90000F9D8
	jsr	adrCd0092A6.l	;4EB9000092A6
	bsr	adrCd00564C	;61004686
	bsr	adrCd00644C	;61005482
	tst.w	Multiplayer.l	;4A790000F98C
	bne.s	adrCd000FF4	;6620
	lea	Player2_Data.l,a5	;4BF90000FA3A
	jsr	adrCd0092A6.l	;4EB9000092A6
	bsr	adrCd00564C	;6100466A
	bsr	adrCd00644C	;61005466
	jsr	adrCd009D84.l	;4EB900009D84
	lea	Player1_Data.l,a5	;4BF90000F9D8
adrCd000FF4:	jsr	adrCd009D84.l	;4EB900009D84
	move.b	#$FF,adrB_0099EE.l	;13FC00FF000099EE
adrCd001002:	tst.b	adrB_0099EE.l	;4A39000099EE
	bne.s	adrCd001002	;66F8
	bsr.s	adrCd001070	;6164
	move.b	adrB_00F9F0.l,d0	;10390000F9F0
	and.b	adrB_00FA52.l,d0	;C0390000FA52
	btst	#$06,d0	;08000006
	beq.s	adrCd001020	;6702
	bsr.s	adrCd00102E	;610E
adrCd001020:	move.w	#$0001,adrB_005A5C.l	;33FC000100005A5C
	bsr	adrCd0015AA	;61000580
	bra.s	adrCd000FB8	;608A

adrCd00102E:	move.l	adrEA00F992.l,-(sp)	;2F390000F992
	moveq	#$14,d0	;7014
adrLp001036:	dbra	d1,adrLp001036	;51C9FFFE
	dbra	d0,adrLp001036	;51C8FFFA
	move.l	#$FFFFFFFF,adrL_00FA32.l	;23FCFFFFFFFF0000FA32
	move.l	#$FFFFFFFF,adrL_00FA94.l	;23FCFFFFFFFF0000FA94
	clr.w	adrB_0099EE.l	;4279000099EE
	bsr	adrCd004A4E	;610039F4
	clr.w	adrB_0099EE.l	;4279000099EE
	moveq	#$14,d0	;7014
adrLp001064:	dbra	d1,adrLp001064	;51C9FFFE
	dbra	d0,adrLp001064	;51C8FFFA
	bra	LoadGame	;60003AD0

adrCd001070:	lea	Player1_Data.l,a5	;4BF90000F9D8
	bsr.s	adrCd00107E	;6106
	lea	Player2_Data.l,a5	;4BF90000FA3A
adrCd00107E:	and.b	#$7F,$0052(a5)	;022D007F0052
	move.b	$0054(a5),d3	;162D0054
	clr.b	$0054(a5)	;422D0054
	move.w	$000A(a5),d0	;302D000A
	move.w	d0,d6	;3C00
	bsr.s	adrCd0010EA	;6156
	move.w	d6,d0	;3006
	add.w	#$001C,d0	;0640001C
	bsr.s	adrCd0010EA	;614E
	lsr.b	#$01,d3	;E20B
	bcc.s	adrCd0010A8	;6408
	move.w	d6,d0	;3006
	add.w	#$0DCC,d0	;06400DCC
	bsr.s	adrCd0010D4	;612C
adrCd0010A8:	move.w	d6,d0	;3006
	lsr.b	#$01,d3	;E20B
	bcc.s	adrCd0010B4	;6406
	add.w	#$000C,d0	;0640000C
	bsr.s	adrCd0010D4	;6120
adrCd0010B4:	move.w	d6,d0	;3006
	lsr.b	#$01,d3	;E20B
	bcc	adrCd001158	;6400009E
	add.w	#$01EC,d0	;064001EC
	move.l	screen_ptr.l,a0	;207900009B06
	move.l	framebuffer_ptr.l,a1	;227900009B0A
	add.w	d0,a1	;D2C0
	add.w	d0,a0	;D0C0
	bra	adrCd00115A	;60000088

adrCd0010D4:	move.l	screen_ptr.l,a0	;207900009B06
	move.l	framebuffer_ptr.l,a1	;227900009B0A
	add.w	d0,a1	;D2C0
	add.w	d0,a0	;D0C0
	moveq	#$07,d0	;7007
	bra	adrLp00115C	;60000074

adrCd0010EA:	moveq	#$06,d2	;7406
	btst	#$05,d3	;08030005
	bne.s	adrCd0010F8	;6606
	moveq	#-$01,d2	;74FF
	add.w	#$0118,d0	;06400118
adrCd0010F8:	lsr.b	#$01,d3	;E20B
	bcc.s	adrCd001100	;6404
	add.w	#$0051,d2	;06420051
adrCd001100:	lsr.b	#$01,d3	;E20B
	bcc.s	adrCd001108	;6404
	add.w	#$0008,d2	;06420008
adrCd001108:	tst.w	d2	;4A42
	bmi.s	adrCd001158	;6B4C
	move.l	screen_ptr.l,a0	;207900009B06
	move.l	framebuffer_ptr.l,a1	;227900009B0A
	add.w	d0,a1	;D2C0
	add.w	d0,a0	;D0C0
adrLp00111C:	lea	$5DC0(a1),a3	;47E95DC0
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
	dbra	d2,adrLp00111C	;51CAFFC6
adrCd001158:	rts	;4E75

adrCd00115A:	moveq	#$4B,d0	;704B
adrLp00115C:	lea	$5DC0(a1),a3	;47E95DC0
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
	dbra	d0,adrLp00115C	;51C8FFBE
	rts	;4E75

adrCd0011A2:	move.l	a4,d0	;200C
	sub.l	#CharacterStats,d0	;04800000F586
	lsr.w	#$06,d0	;EC48
	move.w	d0,d7	;3E00
	movem.l	d0/d1/d7/a5,-(sp)	;48E7C104
	bsr	adrCd0047FA	;61003646
	tst.w	d1	;4A41
	bmi.s	adrCd0011C8	;6B0E
	btst	#$06,$18(a5,d1.w)	;083500061018
	beq.s	adrCd0011C8	;6706
	movem.l	(sp)+,d0/d1/d7/a5	;4CDF2083
	rts	;4E75

adrCd0011C8:	movem.l	(sp)+,d0/d1/d7/a5	;4CDF2083
	cmp.b	#$10,$0001(a4)	;0C2C00100001
	bcc.s	adrCd00120E	;643A
	move.b	$000C(a4),d0	;102C000C
	cmp.b	$000D(a4),d0	;B02C000D
	beq.s	adrCd0011E2	;6704
	addq.b	#$01,$000C(a4)	;522C000C
adrCd0011E2:	moveq	#$00,d0	;7000
	move.b	(a4),d0	;1014
	lsr.w	#$01,d0	;E248
	cmp.b	#$5B,$0030(a4)	;0C2C005B0030
	beq.s	adrCd0011FA	;670A
	cmp.b	#$5B,$0031(a4)	;0C2C005B0031
	beq.s	adrCd0011FA	;6702
	lsr.w	#$01,d0	;E248
adrCd0011FA:	addq.w	#$01,d0	;5240
	add.w	$0006(a4),d0	;D06C0006
	cmp.w	$0008(a4),d0	;B06C0008
	bcs.s	adrCd00120A	;6504
	move.w	$0008(a4),d0	;302C0008
adrCd00120A:	move.w	d0,$0006(a4)	;39400006
adrCd00120E:	tst.b	$000A(a4)	;4A2C000A
	bne.s	adrCd00123A	;6626
	movem.l	d7/a4/a5,-(sp)	;48E7010C
	bsr	RandomGen_BytewithOffset	;61004FC6
	and.w	#$0007,d0	;02400007
	add.b	(a4),d0	;D014
	cmp.w	$0006(a4),d0	;B06C0006
	bcs.s	adrCd00122E	;6506
	move.w	$0006(a4),d0	;302C0006
	beq.s	adrCd001236	;6708
adrCd00122E:	move.w	d0,d5	;3A00
	move.w	d7,d0	;3007
	bsr	adrCd00278A	;61001556
adrCd001236:	movem.l	(sp)+,d7/a4/a5	;4CDF3080
adrCd00123A:	move.b	$0014(a4),d0	;102C0014
	bne.s	adrCd00124C	;660C
	subq.b	#$01,$000A(a4)	;532C000A
	bcc.s	adrCd001262	;641C
	clr.b	$000A(a4)	;422C000A
	bra.s	adrCd001262	;6016

adrCd00124C:	lsr.b	#$06,d0	;EC08
	addq.b	#$01,d0	;5200
	add.b	$000A(a4),d0	;D02C000A
	cmp.b	$000B(a4),d0	;B02C000B
	bcs.s	adrCd00125E	;6504
	move.b	$000B(a4),d0	;102C000B
adrCd00125E:	move.b	d0,$000A(a4)	;1940000A
adrCd001262:	rts	;4E75

adrCd001264:	lea	CharacterStats.l,a4	;49F90000F586
	moveq	#$0F,d7	;7E0F
adrLp00126C:	movem.l	d7/a4,-(sp)	;48E70108
	bsr	adrCd0011A2	;6100FF30
	movem.l	(sp)+,d7/a4	;4CDF1080
	lea	$0040(a4),a4	;49EC0040
	dbra	d7,adrLp00126C	;51CFFFEE
	subq.b	#$01,adrB_00F998.l	;53390000F998
	lea	Player1_Data.l,a5	;4BF90000F9D8
	bsr	adrCd0012AA	;6100001C
	lea	Player2_Data.l,a5	;4BF90000FA3A
	bsr	adrCd0012AA	;61000012
	tst.b	adrB_00F998.l	;4A390000F998
	bpl.s	adrCd0012A8	;6A06
	clr.b	adrB_00F998.l	;42390000F998
adrCd0012A8:	rts	;4E75

adrCd0012AA:	tst.b	adrB_00F998.l	;4A390000F998
	bpl	adrCd0013BE	;6A00010C
	moveq	#$00,d6	;7C00
	moveq	#$03,d7	;7E03
adrLp0012B8:	move.b	$18(a5,d7.w),d0	;10357018
	bmi.s	adrCd001324	;6B66
	btst	#$06,d0	;08000006
	bne.s	adrCd001324	;6660
	and.w	#$000F,d0	;0240000F
	move.w	d0,d1	;3200
	bsr	adrCd0072D4	;61006008
	btst	#$02,(a5)	;08150002
	bne.s	adrCd0012EC	;6618
	btst	#$06,$18(a5,d7.w)	;083500067018
	bne.s	adrCd0012EC	;6610
	cmp.b	#$0B,d1	;0C01000B
	beq.s	adrCd0012EC	;670A
	subq.b	#$01,$0014(a4)	;532C0014
	bcc.s	adrCd0012EC	;6404
	clr.b	$0014(a4)	;422C0014
adrCd0012EC:
	move.b	$0015(a4),d0	;102C0015
	and.w	#$0007,d0	;02400007
	beq.s	adrCd001324	;672E
	subq.b	#$08,$0015(a4)	;512C0015
	bcc.s	adrCd001324	;6428
	clr.b	$0015(a4)	;422C0015
	tst.w	d7	;4A47
	bne.s	adrCd001306	;6602
	addq.b	#$01,d6	;5206
adrCd001306:	btst	d7,$003E(a5)	;0F2D003E
	bne.s	adrCd001324	;6618
	tst.w	d7	;4A47
	beq.s	adrCd001316	;6706
	tst.w	$0042(a5)	;4A6D0042
	bpl.s	adrCd001324	;6A0E
adrCd001316:	movem.w	d6/d7,-(sp)	;48A70300
	bsr	adrCd008C4A	;6100792E
	movem.w	(sp)+,d6/d7	;4C9F00C0
	bset	d7,d6	;0FC6
adrCd001324:	dbra	d7,adrLp0012B8	;51CFFF92
	btst	#$00,d6	;08060000
	beq.s	adrCd00133C	;670E
	tst.b	$0015(a5)	;4A2D0015
	bne.s	adrCd00133C	;6608
	move.w	d6,-(sp)	;3F06
	bsr	adrCd008F3E	;61007C06
	move.w	(sp)+,d6	;3C1F
adrCd00133C:	and.w	#$000E,d6	;0246000E
	beq.s	adrCd0013BE	;677C
	bsr	adrCd008C2C	;610078E8
	bra.s	adrCd0013BE	;6076

adrCd001348:	btst	#$02,(a5)	;08150002
	beq	adrCd001402	;670000B4
	clr.w	adrW_0013D6.l	;4279000013D6
	bsr	adrCd0092A6	;61007F4E
	bsr	adrCd00924C	;61007EF0
	move.w	$00(a6,d0.w),d1	;32360000
	and.w	#$0007,d1	;02410007
	subq.w	#$03,d1	;5741
	bne.s	adrCd001378	;660E
	tst.b	$00(a6,d0.w)	;4A360000
	bne.s	adrCd001378	;6608
	move.w	#$FFFF,adrW_0013D6.l	;33FCFFFF000013D6
adrCd001378:
	moveq	#$03,d7	;7E03
adrLp00137A:
	move.b	$18(a5,d7.w),d0	;10357018
	and.w	#$00E0,d0	;024000E0
	bne.s	adrCd0013BA	;6636
	move.b	$18(a5,d7.w),d0	;10357018
	bsr	adrCd0072D4	;61005F4A
	subq.b	#$06,$0019(a4)	;5D2C0019
	bcc.s	adrCd001396	;6404
	clr.b	$0019(a4)	;422C0019
adrCd001396:	movem.l	d7/a5,-(sp)	;48E70104
	bsr	adrCd0011A2	;6100FE06
	tst.w	adrW_0013D6.l	;4A79000013D6
	beq.s	adrCd0013B6	;6710
	cmp.b	#$10,$0001(a4)	;0C2C00100001
	bcc.s	adrCd0013B6	;6408
	subq.b	#$01,$000C(a4)	;532C000C
	bsr	adrCd0011A2	;6100FDEE
adrCd0013B6:
	movem.l	(sp)+,d7/a5	;4CDF2080
adrCd0013BA:
	dbra	d7,adrLp00137A	;51CFFFBE
adrCd0013BE:
	bsr	adrCd008E24	;61007A64
	move.w	$0014(a5),d1	;322D0014
	subq.w	#$01,d1	;5341
	beq	Click_ShowStats	;67005EBE
	subq.b	#$01,d1	;5301
	bne.s	adrCd001402	;6632
	jmp	adrCd00D10A.l	;4EF90000D10A

adrW_0013D6:	dc.w	$0000	;0000

adrCd0013D8:	subq.b	#$01,adrB_00F999.l	;53390000F999
	bpl.s	adrCd001402	;6A22
	move.b	#$07,adrB_00F999.l	;13FC00070000F999
	moveq	#$0F,d7	;7E0F
	lea	CharacterStats.l,a4	;49F90000F586
adrLp0013F0:	subq.b	#$01,$0019(a4)	;532C0019
	bcc.s	adrCd0013FA	;6404
	clr.b	$0019(a4)	;422C0019
adrCd0013FA:	lea	$0040(a4),a4	;49EC0040
	dbra	d7,adrLp0013F0	;51CFFFF0
adrCd001402:	rts	;4E75

adrCd001404:	moveq	#$00,d6	;7C00
	lea	UnpackedMonsters.l,a3	;47F900014EE6
	lea	adrEA0156F8.l,a0	;41F9000156F8
	move.w	-$0002(a0),d7	;3E28FFFE
	bmi.s	adrCd001402	;6BEA
adrLp001418:	cmp.l	#$FFFFFFFF,(a0)	;0C90FFFFFFFF
	beq.s	adrCd00145E	;673E
	moveq	#-$01,d4	;78FF
	moveq	#$03,d1	;7203
adrLp001424:	moveq	#$00,d2	;7400
	move.b	$00(a0,d1.w),d2	;14301000
	bmi.s	adrCd00143E	;6B12
	addq.w	#$01,d4	;5244
	asl.w	#$04,d2	;E942
	move.b	$0D(a3,d2.w),d3	;1633200D
	bmi.s	adrCd00143E	;6B08
	sub.b	d6,d3	;9606
	move.b	d3,$0D(a3,d2.w)	;1783200D
	move.w	d2,d5	;3A02
adrCd00143E:	dbra	d1,adrLp001424	;51C9FFE4
	tst.w	d4	;4A44
	bne.s	adrCd00147E	;6638
	move.b	#$FF,$0D(a3,d5.w)	;17BC00FF500D
	move.b	$02(a3,d5.w),d4	;18335002
	and.w	#$0003,d4	;02440003
	move.w	d4,d2	;3404
	asl.w	#$04,d4	;E944
	or.w	d4,d2	;8444
	move.b	d2,$02(a3,d5.w)	;17825002
adrCd00145E:	lea	$0004(a0),a1	;43E80004
	lea	(a0),a2	;45D0
	move.w	d7,d1	;3207
	bra.s	adrCd00146A	;6002

adrLp001468:	move.l	(a1)+,(a2)+	;24D9
adrCd00146A:	dbra	d1,adrLp001468	;51C9FFFC
	move.l	#$FFFFFFFF,(a2)	;24BCFFFFFFFF
	subq.w	#$01,Word20156F6.l	;5379000156F6
	addq.w	#$01,d6	;5246
	bra.s	adrCd0014E2	;6064

adrCd00147E:	move.w	(a0),d0	;3010
	and.w	#$8080,d0	;02408080
	beq.s	adrCd0014E0	;675A
	move.b	$0003(a0),d2	;14280003
	bmi.s	adrCd001494	;6B08
	move.b	#$FF,$0003(a0)	;117C00FF0003
	bra.s	adrCd00149E	;600A

adrCd001494:	move.b	$0002(a0),d2	;14280002
	move.b	#$FF,$0002(a0)	;117C00FF0002
adrCd00149E:	moveq	#$01,d1	;7201
	tst.b	d0	;4A00
	bmi.s	adrCd0014A6	;6B02
	moveq	#$00,d1	;7200
adrCd0014A6:	move.b	d2,$00(a0,d1.w)	;11821000
	move.w	d5,d3	;3605
	lsr.w	#$04,d3	;E84B
	cmp.b	(a0),d3	;B610
	beq.s	adrCd0014E0	;672E
	move.b	(a0),d3	;1610
	asl.w	#$04,d3	;E943
	move.b	$00(a3,d5.w),$00(a3,d3.w)	;17B350003000
	move.b	$01(a3,d5.w),$01(a3,d3.w)	;17B350013001
	move.b	$04(a3,d5.w),$04(a3,d3.w)	;17B350043004
	move.b	#$FF,$00(a3,d5.w)	;17BC00FF5000
	move.b	$02(a3,d5.w),$02(a3,d3.w)	;17B350023002
	move.b	$0D(a3,d5.w),$0D(a3,d3.w)	;17B3500D300D
	move.b	#$FF,$0D(a3,d5.w)	;17BC00FF500D
adrCd0014E0:	addq.w	#$04,a0	;5848
adrCd0014E2:	dbra	d7,adrLp001418	;51CFFF34
	rts	;4E75

adrCd0014E8:	moveq	#$00,d1	;7200
	move.l	adrL_00F9D4.l,a6	;2C790000F9D4
	lea	adrEA01575E.l,a0	;41F90001575E
adrCd0014F6:	cmp.w	-$0002(a0),d1	;B268FFFE
	bcs.s	adrCd0014FE	;6502
	rts	;4E75

adrCd0014FE:	move.w	$02(a0,d1.w),d0	;30301002
	subq.b	#$04,$00(a6,d0.w)	;59360000
	bcs.s	adrCd001524	;651C
	cmp.b	#$01,$00(a0,d1.w)	;0C3000011000
	bne.s	adrCd001520	;6610
	tst.b	$01(a6,d0.w)	;4A360001
	bpl.s	adrCd001520	;6A0A
	move.b	$01(a0,d1.w),adrB_00F99A.l	;13F010010000F99A
	bsr.s	adrCd001528	;6108
adrCd001520:	addq.w	#$04,d1	;5841
	bra.s	adrCd0014F6	;60D2

adrCd001524:	bsr.s	adrCd001584	;615E
	bra.s	adrCd0014F6	;60CE

adrCd001528:	movem.l	d1/a0/a5/a6,-(sp)	;48E74086
	move.b	$00(a6,d0.w),d1	;12360000
	lsr.b	#$02,d1	;E409
	move.w	d1,adrW_0025A8.l	;33C1000025A8
	movem.w	d0/d1,-(sp)	;48A7C000
	bsr	adrCd0087BA	;6100727C
	bcc.s	adrCd00157A	;6438
	tst.b	d0	;4A00
	bmi.s	adrCd001562	;6B1C
	cmp.b	#$10,d0	;0C000010
	bcs.s	adrCd001552	;6506
	tst.b	$000B(a1)	;4A29000B
	bmi.s	adrCd00157A	;6B28
adrCd001552:	move.w	$0002(sp),d7	;3E2F0002
	bsr	adrCd0022B6	;61000D5E
	move.w	(sp),d0	;3017
	bsr	adrCd002804	;610012A6
	bra.s	adrCd00157A	;6018

adrCd001562:	move.l	a1,a5	;2A49
	moveq	#$05,d1	;7205
	bsr	adrCd006128	;61004BC0
	tst.w	d3	;4A43
	bpl.s	adrCd00157A	;6A0C
	move.w	$0002(sp),d7	;3E2F0002
	bsr	adrCd0022B6	;61000D42
	bsr	adrCd002984	;6100140C
adrCd00157A:	movem.w	(sp)+,d0/d1	;4C9F0003
	movem.l	(sp)+,d1/a0/a5/a6	;4CDF6102
	rts	;4E75

adrCd001584:	and.w	#$00F8,$00(a6,d0.w)	;027600F80000
	lea	$00(a0,d1.w),a1	;43F01000
	lea	$0004(a1),a2	;45E90004
	move.w	-$0002(a0),d0	;3028FFFE
	sub.w	d1,d0	;9041
	lsr.w	#$02,d0	;E448
	subq.w	#$01,d0	;5340
	bra.s	adrCd0015A0	;6002

adrLp00159E:	move.l	(a2)+,(a1)+	;22DA
adrCd0015A0:	dbra	d0,adrLp00159E	;51C8FFFC
	subq.w	#$04,-$0002(a0)	;5968FFFE
	rts	;4E75

adrCd0015AA:	tst.w	adrEA00F992.l	;4A790000F992
	bne.s	adrCd0015F8	;6646
	move.w	#$012C,adrEA00F992.l	;33FC012C0000F992
	bsr	adrCd0014E8	;6100FF2C
	lea	Player1_Data.l,a5	;4BF90000F9D8
	bsr	adrCd001348	;6100FD82
	lea	ReserveSpace_1.l,a6	;4DF900055E88
	bsr	adrCd006334	;61004D64
	lea	Player2_Data.l,a5	;4BF90000FA3A
	bsr	adrCd001348	;6100FD6E
	lea	ReserveSpace_2.l,a6	;4DF900056270
	bsr	adrCd006334	;61004D50
	bsr	adrCd001404	;6100FE1C
	bchg	#$01,adrB_00F99B.l	;087900010000F99B
	beq.s	adrCd0015F8	;6704
	bsr	adrCd001264	;6100FC6E
adrCd0015F8:	tst.w	adrW_00F994.l	;4A790000F994
	bne	adrCd001738	;66000138
	move.w	#$0007,adrW_00F994.l	;33FC00070000F994
	bsr	adrCd0013D8	;6100FDCC
	lea	adrEA015860.l,a0	;41F900015860
	lea	-$0002(a0),a1	;43E8FFFE
	move.l	adrL_00F9D4.l,a6	;2C790000F9D4
	move.w	-$0002(a0),d7	;3E28FFFE
	bra.s	adrCd00164C	;6028

adrLp001624:	move.w	(a0)+,d0	;3018
	subq.w	#$01,(a0)	;5350
	move.w	(a0)+,d1	;3218
	not.w	d1	;4641
	and.w	#$0003,d1	;02410003
	bne.s	adrCd00164C	;661A
	bclr	#$05,$01(a6,d0.w)	;08B600050001
	subq.w	#$04,a0	;5948
	lea	(a0),a2	;45D0
	lea	$0004(a0),a3	;47E80004
	move.w	d7,d1	;3207
	bra.s	adrCd001646	;6002

adrLp001644:	move.l	(a3)+,(a2)+	;24DB
adrCd001646:	dbra	d1,adrLp001644	;51C9FFFC
	subq.w	#$01,(a1)	;5351
adrCd00164C:	dbra	d7,adrLp001624	;51CFFFD6
	lea	Player1_Data.l,a5	;4BF90000F9D8
	bsr	adrCd002E0A	;610017B2
	lea	Player2_Data.l,a5	;4BF90000FA3A
	bsr	adrCd002E0A	;610017A8
	subq.w	#$01,adrW_00A936.l	;53790000A936
	moveq	#$00,d7	;7E00
	move.w	#$FFFF,adrW_00173A.l	;33FCFFFF0000173A
	clr.w	adrW_00173C.l	;42790000173C
	lea	CharacterStats.l,a4	;49F90000F586
adrCd001680:	move.w	d7,-(sp)	;3F07
	move.w	d7,d0	;3007
	move.w	d7,adrW_00173A.l	;33C70000173A
	bsr	adrCd0047FA	;6100316E
	tst.w	d1	;4A41
	bpl.s	adrCd001698	;6A06
	moveq	#$1A,d4	;781A
	bsr	adrCd00173E	;610000A8
adrCd001698:	lea	$0040(a4),a4	;49EC0040
	move.w	(sp)+,d7	;3E1F
	addq.w	#$01,d7	;5247
	cmp.w	#$0010,d7	;0C470010
	bcs.s	adrCd001680	;65DA
	lea	UnpackedMonsters.l,a4	;49F900014EE6
	move.w	-$0002(a4),d7	;3E2CFFFE
	bmi.s	adrCd0016CA	;6B18
adrLp0016B2:	move.w	d7,-(sp)	;3F07
	addq.w	#$01,adrW_00173A.l	;52790000173A
	moveq	#$00,d4	;7800
	bsr	adrCd001750	;61000092
	lea	$0010(a4),a4	;49EC0010
	move.w	(sp)+,d7	;3E1F
	dbra	d7,adrLp0016B2	;51CFFFEA
adrCd0016CA:	lea	Player1_Data.l,a5	;4BF90000F9D8
	bsr.s	adrCd0016D8	;6106
	lea	Player2_Data.l,a5	;4BF90000FA3A
adrCd0016D8:	moveq	#$03,d7	;7E03
	moveq	#$00,d6	;7C00
adrLp0016DC:	tst.b	$5A(a5,d7.w)	;4A35705A
	bmi.s	adrCd0016F6	;6B14
	subq.b	#$01,$5A(a5,d7.w)	;5335705A
	bpl.s	adrCd0016F6	;6A0E
	moveq	#$01,d6	;7C01
	movem.w	d6/d7,-(sp)	;48A70300
	bsr	adrCd008C4A	;6100755A
	movem.w	(sp)+,d6/d7	;4C9F00C0
adrCd0016F6:	dbra	d7,adrLp0016DC	;51CFFFE4
	tst.w	d6	;4A46
	beq	adrCd001704	;67000006
	bsr	adrCd008C2C	;6100752A
adrCd001704:	moveq	#$03,d7	;7E03
adrLp001706:	tst.b	$5E(a5,d7.w)	;4A35705E
	bmi.s	adrCd00171A	;6B0E
	subq.b	#$01,$5E(a5,d7.w)	;5335705E
	bpl.s	adrCd00171A	;6A08
	move.w	d7,-(sp)	;3F07
	bsr	adrCd006CD6	;610055C0
	move.w	(sp)+,d7	;3E1F
adrCd00171A:	dbra	d7,adrLp001706	;51CFFFEA
	rts	;4E75

adrCd001720:	sub.w	d1,d0	;9041
	move.w	d0,d1	;3200
	bpl.s	adrCd001728	;6A02
	neg.w	d0	;4440
adrCd001728:	move.w	d0,d2	;3400
	swap	d0	;4840
	swap	d1	;4841
	sub.w	d1,d0	;9041
	move.w	d0,d1	;3200
	bpl.s	adrCd001736	;6A02
	neg.w	d0	;4440
adrCd001736:	add.w	d0,d2	;D440
adrCd001738:	rts	;4E75

adrW_00173A:	dc.w	$0000	;0000
adrW_00173C:	dc.w	$0000	;0000

adrCd00173E:	move.w	CurrentTower.l,d0	;30390000F98A
	cmp.b	$0023(a4),d0	;B02C0023
	bne.s	adrCd001738	;66EE
	bsr	adrCd002E92	;61001746
	bra.s	adrCd001766	;6016

adrCd001750:	move.b	$0005(a4),d0	;102C0005
	bsr	adrCd002E80	;6100172A
	move.b	$0005(a4),d1	;122C0005
	and.b	#$60,d1	;02010060
	or.b	d1,d0	;8001
	move.b	d0,$0005(a4)	;19400005
adrCd001766:	move.b	$04(a4,d4.w),d0	;10344004
	cmp.b	adrB_00FA31.l,d0	;B0390000FA31
	beq.s	adrCd00177A	;6708
	cmp.b	adrB_00FA93.l,d0	;B0390000FA93
	bne.s	adrCd00178C	;6612
adrCd00177A:	move.b	$03(a4,d4.w),d7	;1E344003
	move.w	d7,d1	;3207
	and.w	#$000F,d1	;0241000F
	subq.w	#$01,d1	;5341
	bcs.s	adrCd00178E	;6506
	subq.b	#$01,$03(a4,d4.w)	;53344003
adrCd00178C:	rts	;4E75

adrCd00178E:	move.w	d7,d1	;3207
	lsr.b	#$04,d1	;E809
	or.b	d7,d1	;8207
	move.b	d1,$03(a4,d4.w)	;19814003
	btst	#$06,$05(a4,d4.w)	;083400064005
	beq.s	adrCd0017B6	;6716
	move.w	#$001E,adrW_0025A8.l	;33FC001E000025A8
	bsr	adrCd001862	;610000B8
	tst.w	d5	;4A45
	bne.s	adrCd0017B6	;6606
	bclr	#$06,$05(a4,d4.w)	;08B400064005
adrCd0017B6:	btst	#$05,$05(a4,d4.w)	;083400054005
	beq.s	adrCd0017E6	;6728
	and.b	#$F0,$03(a4,d4.w)	;023400F04003
	or.b	#$02,$03(a4,d4.w)	;003400024003
	move.w	#$0028,adrW_0025A8.l	;33FC0028000025A8
	bsr	adrCd001862	;6100008E
	tst.w	d5	;4A45
	bne.s	adrCd0017E6	;660C
	bclr	#$05,$05(a4,d4.w)	;08B400054005
	or.b	#$0F,$03(a4,d4.w)	;0034000F4003
adrCd0017E6:	tst.b	$05(a4,d4.w)	;4A344005
	bpl.s	adrCd001810	;6A24
	move.w	#$0014,adrW_0025A8.l	;33FC0014000025A8
	bsr	adrCd001862	;6100006C
	and.b	#$7F,$05(a4,d4.w)	;0234007F4005
	tst.w	d5	;4A45
	beq.s	adrCd001810	;670E
	or.b	#$0F,$03(a4,d4.w)	;0034000F4003
	bset	#$07,$05(a4,d4.w)	;08F400074005
adrCd00180E:	rts	;4E75

adrCd001810:	moveq	#$00,d7	;7E00
	move.b	$00(a4,d4.w),d7	;1E344000
	bmi	adrCd00178C	;6B00FF74
	swap	d7	;4847
	move.b	$01(a4,d4.w),d7	;1E344001
	moveq	#$00,d0	;7000
	move.b	$04(a4,d4.w),d0	;10344004
	bsr	adrCd0092AA	;61007A82
	bsr	CoordToMap	;61007A40
	move.b	$01(a6,d0.w),d1	;12360001
	bpl.s	adrCd00180E	;6ADA
	cmp.w	#$0000,d4	;0C440000
	beq.s	adrCd001886	;674C
	bsr	adrCd001C5A	;6100041E
	bpl	adrCd002000	;6A0007C0
	tst.w	adrW_00173C.l	;4A790000173C
	beq	AttackType_Drone	;67000328
	lea	ReserveSpace_1.l,a6	;4DF900055E88
	btst	#$00,(a5)	;08150000
	beq.s	adrCd00185E	;6706
	lea	ReserveSpace_2.l,a6	;4DF900056270
adrCd00185E:	bra	adrCd001A58	;600001F8

adrCd001862:	move.l	a4,a1	;224C
	move.l	a1,d0	;2009
	cmp.w	#$0000,d4	;0C440000
	bne.s	adrCd00187A	;660E
	sub.l	#UnpackedMonsters,d0	;048000014EE6
	lsr.w	#$04,d0	;E848
	add.w	#$0010,d0	;06400010
	bra.s	adrCd001882	;6008

adrCd00187A:
	sub.l	#CharacterStats,d0	;04800000F586
	lsr.w	#$06,d0	;EC48
adrCd001882:
	bra	adrCd0025AA	;60000D26

adrCd001886:
	move.b	$000B(a4),d2	;142C000B
	bmi	adrCd001A98	;6B00020C
	cmp.b	#$67,d2	;0C020067
	bcc.s	adrCd00189A	;6406
	tst.b	$000D(a4)	;4A2C000D
	bmi.s	adrCd0018AE	;6B14
adrCd00189A:
	and.b	#$03,$0002(a4)	;022C00030002
	move.b	$0002(a4),d6	;1C2C0002
	asl.b	#$04,d6	;E906
	or.b	$0002(a4),d6	;8C2C0002
	move.b	d6,$0002(a4)	;19460002
adrCd0018AE:
	bsr	adrCd001C5A	;610003AA
	bpl	adrCd002000	;6A00074C
	move.w	adrW_00173A.l,d1	;32390000173A
	cmp.b	adrB_00FA0D.l,d1	;B2390000FA0D
	beq	adrCd002006	;67000742
	cmp.b	adrB_00FA6F.l,d1	;B2390000FA6F
	beq	adrCd002006	;67000738
	move.b	$0005(a4),d1	;122C0005
	and.w	#$0060,d1	;02410060
	bne	AttackType_Drone	;66000298
	move.b	$0006(a4),d0	;102C0006
	move.b	$0007(a4),d1	;122C0007
	and.w	#$007F,d1	;0241007F
	and.w	#$007F,d0	;0240007F
	cmp.w	d0,d1	;B240
	bcc.s	adrCd00190C	;641C
	move.l	a4,a1	;224C
	clr.w	adrW_0025A8.l	;4279000025A8
	bsr	adrCd0025AA	;61000CB0
	tst.w	d5	;4A45
	beq.s	adrCd00190C	;670C
	bchg	#$07,$0007(a4)	;086C00070007
	beq.s	adrCd00190C	;6704
	addq.b	#$01,$0007(a4)	;522C0007
adrCd00190C:
	move.b	$000A(a4),d1		;122C000A
	and.w	#$0007,d1		;02410007
	add.w	d1,d1			;D241
	lea	AttackType_NoSpells.l,a1	;43F9000019F4
	lea	adrJT001928.l,a0	;41F900001928
	add.w	$00(a0,d1.w),a1		;D2F01000
	jmp	(a1)			;4ED1

adrJT001928:
	dc.w	AttackType_NoSpells-AttackType_NoSpells	;0000
	dc.w	AttackType_Spells-AttackType_NoSpells	;FF64
	dc.w	AttackType_Drone-AttackType_NoSpells	;017E
	dc.w	AttackType_DroneSpells-AttackType_NoSpells	;FF3E
	dc.w	AttackType_ArcBoltMachine-AttackType_NoSpells	;FFF2

AttackType_DroneSpells:
	bsr	RandomGen_BytewithOffset	;610048AC
	and.w	#$000F,d0	;0240000F
	bne	AttackType_Drone	;66000236
	move.b	#$FF,adrB_00F99A.l	;13FC00FF0000F99A
	bra.s	adrCd00196A	;6022

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
	bsr	adrCd00618A	;61004830
	subq.b	#$02,d0	;5500
	bcc	AttackType_NoSpells	;64000094
	move.b	#$FF,adrB_00F99A.l	;13FC00FF0000F99A
adrCd00196A:
	bsr	RandomGen_BytewithOffset	;61004874
	and.w	#$000F,d0	;0240000F
	move.b	$0007(a4),d3	;162C0007
	and.w	#$007F,d3	;0243007F
	cmp.b	#$08,d3	;0C030008
	bcc.s	adrCd001992	;6412
	lsr.w	#$01,d0	;E248
	cmp.b	#$05,d3	;0C030005
	bcc.s	adrCd001992	;640A
	lsr.w	#$01,d0	;E248
	cmp.b	#$04,d3	;0C030004
	bcc.s	adrCd001992	;6402
	lsr.w	#$01,d0	;E248
adrCd001992:	move.b	MonsterAttackSpells(pc,d0.w),d0	;103B00B4
	move.w	d0,d4	;3800
	or.w	#$0080,d4	;00440080
	move.w	d3,d6	;3C03
	and.w	#$0080,d0	;02400080
	or.b	d0,d3	;8600
	add.w	d3,d3	;D643
	add.b	d6,d3	;D606
	cmp.b	#$81,d4	;0C040081
	beq.s	adrCd0019B6	;6708
	cmp.b	#$8E,d4	;0C04008E
	beq.s	adrCd0019B6	;6702
	lsr.b	#$01,d3	;E20B
adrCd0019B6:	move.b	$0002(a4),d0	;102C0002
	and.w	#$0003,d0	;02400003
adrCd0019BE:	move.w	d0,d6	;3C00
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
	bsr	adrCd005D9E	;610043BE
	move.l	(sp)+,a4	;285F
	rts	;4E75

AttackType_ArcBoltMachine:	moveq	#$0C,d3	;760C
	moveq	#$0B,d0	;700B
	move.b	#$FF,adrB_00F99A.l	;13FC00FF0000F99A
	bra.s	adrCd001992	;609E

AttackType_NoSpells:	moveq	#-$01,d2	;74FF
	move.b	$0004(a4),d1	;122C0004
	cmp.b	adrB_00FA31.l,d1	;B2390000FA31
	bne.s	adrCd001A0E	;660C
	move.l	adrL_00F9F4.l,d0	;20390000F9F4
	move.l	d7,d1	;2207
	bsr	adrCd001720	;6100FD14
adrCd001A0E:	move.w	d2,d3	;3602
	moveq	#-$01,d2	;74FF
	move.b	$0004(a4),d1	;122C0004
	cmp.b	adrB_00FA93.l,d1	;B2390000FA93
	bne.s	adrCd001A2A	;660C
	move.l	adrL_00FA56.l,d0	;20390000FA56
	move.l	d7,d1	;2207
	bsr	adrCd001720	;6100FCF8
adrCd001A2A:	moveq	#$00,d4	;7800
	tst.w	d2	;4A42
	bmi.s	adrCd001A48	;6B18
	move.l	a4,d0	;200C
	sub.l	#serpex.monsters,d0	;048000015968
	lsr.w	#$04,d0	;E848
	add.b	$000B(a4),d0	;D02C000B
	add.b	$0006(a4),d0	;D02C0006
	and.w	#$0001,d0	;02400001
	add.w	d0,d2	;D440
adrCd001A48:	lea	ReserveSpace_1.l,a6	;4DF900055E88
	cmp.w	d2,d3	;B642
	bcs.s	adrCd001A58	;6506
	lea	ReserveSpace_2.l,a6	;4DF900056270
adrCd001A58:	move.w	d7,d0	;3007
	mulu	adrW_00F9CC.l,d0	;C0F90000F9CC
	swap	d7	;4847
	add.w	d7,d0	;D047
	swap	d7	;4847
	move.b	$00(a6,d0.w),d0	;10360000
	beq	AttackType_Drone	;67000106
	cmp.b	#$FF,d0	;0C0000FF
	beq	AttackType_Drone	;670000FE
	and.w	#$0003,d0	;02400003
	move.b	$02(a4,d4.w),d6	;1C344002
	and.w	#$0003,d6	;02460003
	cmp.w	d0,d6	;BC40
	beq	AttackType_Drone	;670000EC
	eor.w	d0,d6	;B146
	subq.w	#$02,d6	;5546
	beq	adrCd001FEA	;6700055C
	move.b	$02(a4,d4.w),d6	;1C344002
	bra	adrCd001FF8	;60000562

adrCd001A98:	cmp.b	#$94,d2	;0C020094
	bne.s	adrCd001B02	;6664
	move.w	adrW_00A936.l,d4	;38390000A936
	and.w	#$0003,d4	;02440003
	bne	adrCd001C04	;6600015A
	moveq	#$00,d4	;7800
	moveq	#$00,d3	;7600
	move.b	$0006(a4),d3	;162C0006
	bsr	RandomGen_BytewithOffset	;6100472A
	and.w	#$000F,d0	;0240000F
	move.b	adrB_001AF2(pc,d0.w),d4	;183B0034
	bpl.s	adrCd001AC6	;6A04
	bset	#$08,d3	;08C30008
adrCd001AC6:	bset	#$07,d4	;08C40007
	bsr	RandomGen_BytewithOffset	;61004714
	and.w	#$0003,d0	;02400003
	cmp.w	#$0002,d0	;0C400002
	bne.s	adrCd001ADA	;6602
	moveq	#$00,d0	;7000
adrCd001ADA:	add.b	$0002(a4),d0	;D02C0002
	and.w	#$0003,d0	;02400003
	move.b	$000C(a4),adrB_00F99A.l	;13EC000C0000F99A
	move.b	$0006(a4),d3	;162C0006
	bra	adrCd0019BE	;6000FECE

adrB_001AF2:	dc.b	$8B	;8B
	dc.b	$00	;00
	dc.b	$83	;83
	dc.b	$8C	;8C
	dc.b	$0A	;0A
	dc.b	$87	;87
	dc.b	$8E	;8E
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$18	;18
	dc.b	$16	;16
	dc.b	$95	;95
	dc.b	$01	;01
	dc.b	$95	;95
	dc.b	$00	;00
	dc.b	$02	;02

adrCd001B02:	cmp.b	#$96,d2	;0C020096
	bne.s	adrCd001B1A	;6612
	not.w	d1	;4641
	and.w	#$0007,d1	;02410007
	bne.s	AttackType_Drone	;6662
	move.w	d0,-(sp)	;3F00
	bsr	adrCd005D10	;610041FC
	move.w	(sp)+,d0	;301F
	bra.s	AttackType_Drone	;6058

adrCd001B1A:	sub.b	#$84,d2	;04020084
	bcs.s	AttackType_Drone	;6552
	beq.s	adrCd001B2C	;670A
	cmp.b	#$14,d2	;0C020014
	beq.s	adrCd001B2C	;6704
	subq.b	#$03,d2	;5702
	bne.s	AttackType_Drone	;6646
adrCd001B2C:	not.w	d1	;4641
	and.w	#$0007,d1	;02410007
	beq.s	adrCd001B40	;670C
	cmp.w	#$0007,d1	;0C410007
	bne.s	AttackType_Drone	;6638
	tst.b	$00(a6,d0.w)	;4A360000
	bne.s	AttackType_Drone	;6632
adrCd001B40:	or.b	#$07,$01(a6,d0.w)	;003600070001
	moveq	#$00,d1	;7200
	move.b	$0006(a4),d1	;122C0006
	cmp.b	#$87,$000B(a4)	;0C2C0087000B
	beq.s	adrCd001B5E	;670A
	add.w	d1,d1	;D241
	cmp.w	#$0040,d1	;0C410040
	bcs.s	adrCd001B5E	;6502
	moveq	#$3F,d1	;723F
adrCd001B5E:	asl.b	#$02,d1	;E501
	addq.b	#$01,d1	;5201
	move.b	d1,$00(a6,d0.w)	;1D810000
	move.w	#$0100,d1	;323C0100
	move.b	$000C(a4),d1	;122C000C
	bsr	adrCd005F30	;610043C0
AttackType_Drone:	move.b	$02(a4,d4.w),d6	;1C344002
	and.w	#$0003,d6	;02460003
	bsr	adrCd0086F6	;61006B7A
	bcs	adrCd001F1E	;6500039E
	cmp.w	#$0000,d4	;0C440000
	bne.s	adrCd001B90	;6608
	cmp.b	#$85,$000B(a4)	;0C2C0085000B
	beq.s	adrCd001C06	;6776
adrCd001B90:	move.b	d7,$01(a4,d4.w)	;19874001
	swap	d7	;4847
	move.b	d7,$00(a4,d4.w)	;19874000
	swap	d7	;4847
	bsr	adrCd001C5A	;610000BC
	and.w	#$0030,d0	;02400030
	bsr	adrCd002000	;6100045A
	cmp.b	#$00,d4	;0C040000
	bne.s	adrCd001BB4	;6606
	tst.b	$000B(a4)	;4A2C000B
	bmi.s	adrCd001C04	;6B50
adrCd001BB4:	bsr	CoordToMap	;610076B6
	move.w	$00(a6,d0.w),d1	;32360000
	not.w	d1	;4641
	and.w	#$0007,d1	;02410007
	bne.s	adrCd001C04	;6640
	move.b	$00(a6,d0.w),d1	;12360000
	move.w	d1,d7	;3E01
	and.w	#$0003,d1	;02410003
	subq.b	#$01,d1	;5301
	bne.s	adrCd001C04	;6632
	lea	adrEA01575E.l,a0	;41F90001575E
	moveq	#-$04,d1	;72FC
adrCd001BDA:	addq.w	#$04,d1	;5841
	cmp.w	-$0002(a0),d1	;B268FFFE
	bcc.s	adrCd001C04	;6422
	cmp.w	$02(a0,d1.w),d0	;B0701002
	bne.s	adrCd001BDA	;66F2
	move.b	$01(a0,d1.w),adrB_00F99A.l	;13F010010000F99A
	lsr.w	#$02,d7	;E44F
	move.w	d7,adrW_0025A8.l	;33C7000025A8
	move.l	a4,-(sp)	;2F0C
	bsr	adrCd0022B6	;610006BA
	bsr	adrCd002804	;61000C04
	move.l	(sp)+,a4	;285F
adrCd001C04:	rts	;4E75

adrCd001C06:	move.w	$00(a6,d0.w),d1	;32360000
	not.b	d1	;4601
	and.w	#$0007,d1	;02410007
	bne.s	adrCd001C20	;660E
	move.b	$00(a6,d0.w),d1	;12360000
	and.w	#$0003,d1	;02410003
	subq.w	#$01,d1	;5341
	beq	adrCd001B90	;6700FF72
adrCd001C20:	move.w	$00(a6,d2.w),d1	;32362000
	not.b	d1	;4601
	and.w	#$0007,d1	;02410007
	beq.s	adrCd001C36	;670A
	move.b	#$80,$000B(a4)	;197C0080000B
	bra	adrCd001B90	;6000FF5C

adrCd001C36:	bclr	#$07,$01(a6,d0.w)	;08B600070001
	bset	#$07,$01(a6,d2.w)	;08F600072001
	eor.b	#$02,$0002(a4)	;0A2C00020002
	rts	;4E75

adrB_001C4A:	dc.b	$B0	;B0
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

adrCd001C5A:	moveq	#$00,d6	;7C00
	move.b	$02(a4,d4.w),d6	;1C344002
	move.w	d6,d0	;3006
	and.w	#$0003,d6	;02460003
	move.w	d6,d2	;3406
	asl.w	#$02,d2	;E542
	lsr.w	#$04,d0	;E848
	add.w	d0,d2	;D440
	move.b	adrB_001C4A(pc,d2.w),d0	;103B20DA
	rts	;4E75

adrCd001C74:	clr.w	adrW_0070C6.l	;4279000070C6
	bsr	adrCd0087BA	;61006B3E
	bcc	adrCd001FEA	;6400036A
	tst.b	d0	;4A00
	bmi	adrCd001EE4	;6B00025E
	cmp.b	#$10,d0	;0C000010
	bcs	adrCd001D90	;65000102
	move.b	$000B(a4),d2	;142C000B
	bmi	adrCd001D90	;6B0000FA
	cmp.b	#$64,d2	;0C020064
	bne.s	adrCd001CAA	;660C
	move.b	$000C(a4),adrB_00F99A.l	;13EC000C0000F99A
	bra	adrCd001D90	;600000E8

adrCd001CAA:	cmp.b	#$64,$000B(a1)	;0C290064000B
	beq	adrCd001D90	;670000DE
	cmp.b	#$67,d2	;0C020067
	bcc	adrCd001FEA	;64000330
	move.b	$000B(a1),d2	;1429000B
	bpl.s	adrCd001D04	;6A42
	cmp.b	#$85,d2	;0C020085
	bne	adrCd001FEA	;66000322
	move.l	a4,-(sp)	;2F0C
	moveq	#$00,d7	;7E00
	move.b	$0000(a4),d7	;1E2C0000
	swap	d7	;4847
	move.b	$0001(a4),d7	;1E2C0001
	bsr	CoordToMap	;61007592
	bclr	#$07,$01(a6,d0.w)	;08B600070001
	moveq	#$00,d7	;7E00
	move.b	$0000(a1),d7	;1E290000
	move.b	d7,$0000(a4)	;19470000
	swap	d7	;4847
	move.b	$0001(a1),d7	;1E290001
	move.b	d7,$0001(a4)	;19470001
	bsr	CoordToMap	;61007574
	move.l	a1,a4	;2849
	bsr	adrCd0021C0	;610004C2
	move.l	(sp)+,a4	;285F
	rts	;4E75

adrCd001D04:	cmp.b	#$40,d2	;0C020040
	beq	adrCd001FEA	;670002E0
	cmp.b	#$67,d2	;0C020067
	bcc	adrCd001FEA	;640002D8
	tst.b	$000D(a4)	;4A2C000D
	bpl	adrCd001FEA	;6A0002D0
	moveq	#$00,d3	;7600
	move.b	$000D(a1),d3	;1629000D
	bpl.s	adrCd001D4A	;6A26
	lea	adrEA0156F8.l,a0	;41F9000156F8
	addq.w	#$01,-$0002(a0)	;5268FFFE
	move.w	-$0002(a0),d3	;3628FFFE
	move.b	d3,$000D(a1)	;1343000D
	asl.w	#$02,d3	;E543
	sub.w	#$0010,d0	;04400010
	move.l	#$FFFFFFFF,$00(a0,d3.w)	;21BCFFFFFFFF3000
	move.b	d0,$00(a0,d3.w)	;11803000
	lsr.w	#$02,d3	;E44B
adrCd001D4A:	asl.w	#$02,d3	;E543
	lea	adrEA0156F8.l,a0	;41F9000156F8
	add.w	d3,a0	;D0C3
	moveq	#$03,d2	;7403
adrLp001D56:	tst.b	$00(a0,d2.w)	;4A302000
	bmi.s	adrCd001D64	;6B08
	dbra	d2,adrLp001D56	;51CAFFF8
	bra	adrCd001FEA	;60000288

adrCd001D64:	move.l	a4,d0	;200C
	sub.l	#UnpackedMonsters,d0	;048000014EE6
	lsr.w	#$04,d0	;E848
	move.b	d0,$00(a0,d2.w)	;11802000
	moveq	#$00,d7	;7E00
	move.b	$0000(a4),d7	;1E2C0000
	swap	d7	;4847
	move.b	$0001(a4),d7	;1E2C0001
	move.b	#$FF,$0000(a4)	;197C00FF0000
	bsr	CoordToMap	;610074E6
	bclr	#$07,$01(a6,d0.w)	;08B600070001
	rts	;4E75

adrCd001D90:	move.w	d0,d1	;3200
adrCd001D92:	move.b	$000B(a4),d0	;102C000B
	bpl	adrCd001E78	;6A0000E0
	cmp.b	#$10,d1	;0C010010
	bcs.s	adrCd001DAA	;650A
	tst.b	$000C(a4)	;4A2C000C
	bpl	adrCd001E78	;6A0000D2
	rts	;4E75

adrCd001DAA:	movem.l	d1/a5,-(sp)	;48E74004
	move.w	d1,d0	;3001
	bsr	adrCd0047FA	;61002A48
	tst.w	d1	;4A41
	bmi.s	adrCd001DE0	;6B28
	moveq	#$01,d1	;7201
	move.l	a4,-(sp)	;2F0C
	bsr	adrCd006128	;6100436A
	move.l	(sp)+,a4	;285F
	tst.w	d3	;4A43
	bpl.s	adrCd001DD6	;6A10
	move.w	#$8000,d1	;323C8000
	move.l	a4,-(sp)	;2F0C
	bsr	adrCd006128	;6100435A
	move.l	(sp)+,a4	;285F
	tst.w	d3	;4A43
	bmi.s	adrCd001DE0	;6B0A
adrCd001DD6:	swap	d3	;4843
	movem.l	(sp)+,d1/a5	;4CDF2002
	move.w	d3,d1	;3203
	bra.s	adrCd001DE4	;6004

adrCd001DE0:	movem.l	(sp)+,d1/a5	;4CDF2002
adrCd001DE4:	move.w	d1,d0	;3001
	move.l	a4,a2	;244C
	bsr	adrCd0072D4	;610054EA
	exg	a2,a4	;C54C
	move.b	$0015(a2),d0	;102A0015
	beq	adrCd001E78	;67000084
	and.w	#$0007,d0	;02400007
	bne.s	adrCd001E06	;660A
	tst.b	$0025(a2)	;4A2A0025
	beq	adrCd001E78	;67000076
	bra.s	adrCd001E10	;600A

adrCd001E06:	subq.w	#$01,d0	;5340
	bne.s	adrCd001E78	;666E
	move.b	#$01,$0015(a2)	;157C00010015
adrCd001E10:	moveq	#$00,d7	;7E00
	move.b	$0000(a4),d7	;1E2C0000
	swap	d7	;4847
	move.b	$0001(a4),d7	;1E2C0001
	bsr	CoordToMap	;6100744E
	tst.b	$01(a6,d0.w)	;4A360001
	bpl.s	adrCd001E34	;6A0E
	move.w	d1,-(sp)	;3F01
	bsr	adrCd0087BA	;61006990
	move.w	(sp)+,d1	;321F
	tst.b	d0	;4A00
	bmi	adrCd001E78	;6B000046
adrCd001E34:	moveq	#$00,d4	;7800
	move.b	$000B(a4),d4	;182C000B
	move.b	$0002(a4),d0	;102C0002
	and.w	#$0003,d0	;02400003
	lea	adrEA006434.l,a0	;41F900006434
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
	move.b	d1,adrB_00F99A.l	;13C10000F99A
	bra	adrCd005D9E	;60003F28

adrCd001E78:	moveq	#$00,d3	;7600
	move.b	$000D(a4),d3	;162C000D
	bmi.s	adrCd001EB2	;6B32
	move.l	a4,-(sp)	;2F0C
	asl.w	#$02,d3	;E543
	lea	adrEA0156F8.l,a0	;41F9000156F8
	add.w	d3,a0	;D0C3
	moveq	#$01,d0	;7001
adrLp001E8E:	moveq	#$00,d3	;7600
	move.b	$00(a0,d0.w),d3	;16300000
	bmi.s	adrCd001EAA	;6B14
	movem.l	d0/d1/a0,-(sp)	;48E7C080
	lea	UnpackedMonsters.l,a4	;49F900014EE6
	asl.w	#$04,d3	;E943
	add.w	d3,a4	;D8C3
	bsr.s	adrCd001EB2	;610C
	movem.l	(sp)+,d0/d1/a0	;4CDF0103
adrCd001EAA:	dbra	d0,adrLp001E8E	;51C8FFE2
	move.l	(sp)+,a4	;285F
	rts	;4E75

adrCd001EB2:	move.l	a4,d3	;260C
	sub.l	#UnpackedMonsters,d3	;048300014EE6
	lsr.w	#$04,d3		;E84B
	add.w	#$0010,d3	;06430010
	move.b	#$07,$0005(a4)	;197C00070005
	move.l	a4,-(sp)	;2F0C
	move.w	d1,-(sp)	;3F01
	move.w	#$FFFF,adrW_006EEA.l	;33FCFFFF00006EEA
	bsr	adrCd006E2E	;61004F5A
	move.w	(sp)+,d0	;301F
	move.w	$0000(a6),d5	;3A2E0000
	bsr	adrCd00278A	;610008AC
	move.l	(sp)+,a4	;285F
	rts	;4E75

adrCd001EE4:	bsr	RandomGen_BytewithOffset	;610042FA
	move.w	d0,d2	;3400
	and.w	#$0001,d2	;02420001
	moveq	#$00,d0	;7000
	move.b	$0002(a4),d0	;102C0002
	bsr	adrCd006C58	;61004D62
	tst.b	$000B(a4)	;4A2C000B
	bpl	adrCd001D92	;6A00FE94
	movem.l	d0/d1/a5,-(sp)	;48E7C004
	move.l	a1,a5	;2A49
	move.w	d1,d0	;3001
	bsr	adrCd00480C	;61002902
	bclr	d1,$003C(a5)	;03AD003C
	clr.w	adrW_0070C6.l	;4279000070C6
	movem.l	(sp)+,d0/d1/a5	;4CDF2003
	bra	adrCd001D92	;6000FE76

adrCd001F1E:	
	move.w	adrW_00173A.l,d1	;32390000173A
	cmp.b	adrB_00FA0D.l,d1	;B2390000FA0D
	beq	adrCd002006	;670000DA
	cmp.b	adrB_00FA6F.l,d1	;B2390000FA6F
	beq	adrCd002006	;670000D0
	cmp.w	#$0000,d4	;0C440000
	beq.s	adrCd001FA6	;6768
	tst.w	adrW_00173C.l	;4A790000173C
	beq	adrCd001FEA	;670000A4
	movem.w	d0/d2,-(sp)	;48A7A000
	bsr	adrCd0087BA	;6100686C
	movem.w	(sp)+,d1/d2	;4C9F0006
	tst.b	d0	;4A00
	bpl	adrCd001FEA	;6A000092
	cmp.l	a1,a5	;BBC9
	bne	adrCd001FEA	;6600008C
	bclr	#$07,$01(a6,d2.w)	;08B600072001
	move.l	a4,d0	;200C
	sub.l	#CharacterStats,d0	;04800000F586
	lsr.w	#$06,d0	;EC48
	bsr	adrCd00480C	;6100289A
	bclr	#$05,$18(a5,d1.w)	;08B500051018
	move.b	d0,$0034(a5)	;1B400034
	cmp.b	$0053(a5),d0	;B02D0053
	bne.s	adrCd001F8E	;660A
	move.b	#$FF,$0053(a5)	;1B7C00FF0053
	clr.b	$0014(a5)	;422D0014
adrCd001F8E:	
	moveq	#$03,d7	;7E03
adrLp001F90:
	tst.b	$26(a5,d7.w)	;4A357026
	bmi.s	adrCd001F9A	;6B04
	dbra	d7,adrLp001F90	;51CFFFF8
adrCd001F9A:
	move.b	d0,$26(a5,d7.w)	;1B807026
	move.b	#$FF,$001A(a4)	;197C00FF001A
	rts	;4E75

adrCd001FA6:	tst.b	$000B(a4)	;4A2C000B
	bmi	adrCd002138	;6B00018C
	cmp.b	#$15,$000B(a4)	;0C2C0015000B
	beq.s	adrCd001FEA	;6734
	cmp.b	#$16,$000B(a4)	;0C2C0016000B
	beq.s	adrCd001FEA	;672C
	cmp.w	d2,d0	;B042
	bne.s	adrCd001FD2	;6610
	move.w	$00(a6,d0.w),d1	;32360000
	and.w	#$0007,d1	;02410007
	subq.w	#$02,d1	;5541
	bne	adrCd002034	;66000066
	bra.s	adrCd002008	;6036

adrCd001FD2:
	move.b	$01(a6,d0.w),d2	;14360001
	bpl.s	adrCd001FEA	;6A12
	move.b	#$FF,adrB_00F99A.l	;13FC00FF0000F99A
	and.w	#$0007,d2	;02420007
	subq.w	#$01,d2	;5342
	bne	adrCd001C74	;6600FC8C
adrCd001FEA:
	bsr	RandomGen_BytewithOffset	;610041F4
	or.w	#$0001,d0	;00400001
	move.b	$02(a4,d4.w),d6	;1C344002
	add.w	d6,d0	;D046
adrCd001FF8:
	and.w	#$0003,d0	;02400003
	and.w	#$00F0,d6	;024600F0
adrCd002000:	
	or.b	d6,d0	;8006
	move.b	d0,$02(a4,d4.w)	;19804002
adrCd002006:	
	rts	;4E75

adrCd002008:	move.b	$0002(a4),d6	;1C2C0002
	and.w	#$0003,d6	;02460003
	move.b	$00(a6,d0.w),d1	;12360000
	add.w	d6,d6	;DC46
	addq.w	#$01,d6	;5246
	btst	d6,$00(a6,d0.w)	;0D360000
	beq.s	adrCd002034	;6716
	subq.w	#$01,d6	;5346
	btst	d6,$00(a6,d0.w)	;0D360000
	beq.s	adrCd002034	;670E
	btst	#$04,$01(a6,d0.w)	;083600040001
	bne.s	adrCd001FEA	;66BC
	bclr	d6,$00(a6,d0.w)	;0DB60000
	rts	;4E75

adrCd002034:	moveq	#$00,d7	;7E00
	move.b	$0000(a4),d7	;1E2C0000
	swap	d7	;4847
	move.b	$0001(a4),d7	;1E2C0001
	move.b	$0002(a4),d0	;102C0002
	and.w	#$0003,d0	;02400003
	move.w	d0,d6	;3C00
	bsr	adrCd009254	;61007208
	move.w	$00(a6,d0.w),d1	;32360000
	and.w	#$0007,d1	;02410007
	subq.w	#$02,d1	;5541
	bne.s	adrCd001FEA	;6690
	btst	#$04,$01(a6,d0.w)	;083600040001
	bne.s	adrCd001FEA	;6688
	eor.b	#$02,d6	;0A060002
	add.w	d6,d6	;DC46
	addq.w	#$01,d6	;5246
	btst	d6,$00(a6,d0.w)	;0D360000
	beq	adrCd001FEA	;6700FF7A
	subq.w	#$01,d6	;5346
	bclr	d6,$00(a6,d0.w)	;0DB60000
	rts	;4E75

adrCd00207A:	cmp.w	d0,d2	;B440
	bne	adrCd0020B8	;6600003A
adrCd002080:	move.b	$0002(a4),d6	;1C2C0002
	and.w	#$0003,d6	;02460003
	cmp.w	#$0002,d6	;0C460002
	bcs.s	adrCd002092	;6504
	eor.w	#$0001,d6	;0A460001
adrCd002092:	moveq	#$00,d1	;7200
	move.b	$000B(a4),d1	;122C000B
	sub.b	#$85,d1	;04010085
	movem.w	d0/d1/d6,-(sp)	;48A7C200
	bsr	adrCd002CE6	;61000C44
	movem.w	(sp)+,d0/d1/d6	;4C9F0043
	cmp.w	#$0005,d1	;0C410005
	beq.s	adrCd002104	;6756
	moveq	#$01,d5	;7A01
	swap	d5	;4845
	move.w	d1,d5	;3A01
	bra	adrCd006AAA	;600049F4

adrCd0020B8:	moveq	#$00,d7	;7E00
	move.b	$000B(a4),d7	;1E2C000B
	bsr	adrCd00222A	;6100016A
	tst.b	$01(a6,d0.w)	;4A360001
	bmi.s	adrCd0020D0	;6B08
	eor.b	#$02,$0002(a4)	;0A2C00020002
	bra.s	adrCd002080	;60B0

adrCd0020D0:	movem.l	a4/a5,-(sp)	;48E7000C
	lea	adrEA0156E6.l,a0	;41F9000156E6
	moveq	#$03,d1	;7203
adrLp0020DC:	move.l	(a4)+,(a0)+	;20DC
	dbra	d1,adrLp0020DC	;51C9FFFC
	sub.w	#$0010,a4	;98FC0010
	move.w	d0,d4	;3800
	bsr	adrCd002CE6	;61000BFC
	move.w	d4,d0	;3004
	lea	adrEA0156E6.l,a4	;49F9000156E6
	move.b	$000C(a4),adrB_00F99A.l	;13EC000C0000F99A
	bsr	adrCd001C74	;6100FB76
	movem.l	(sp)+,a4/a5	;4CDF3000
adrCd002104:	rts	;4E75

adrCd002106:	moveq	#$00,d4	;7800
	bsr	adrCd001FEA	;6100FEE0
	move.w	d0,d6	;3C00
	and.w	#$0003,d6	;02460003
	bsr	adrCd0086F6	;610065E2
	bcs.s	adrCd002124	;650C
	move.b	d7,$0001(a4)	;19470001
	swap	d7	;4847
	move.b	d7,$0000(a4)	;19470000
	rts	;4E75

adrCd002124:	cmp.w	d0,d2	;B440
	beq.s	adrCd002130	;6708
	cmp.b	#$98,$000B(a4)	;0C2C0098000B
	bne.s	adrCd002138	;6608
adrCd002130:	eor.b	#$02,$0002(a4)	;0A2C00020002
	rts	;4E75

adrCd002138:	cmp.b	#$84,$000B(a4)	;0C2C0084000B
	bne.s	adrCd00215A	;661A
	move.b	#$85,$000B(a4)	;197C0085000B
	move.b	$0006(a4),d1	;122C0006
	addq.b	#$04,d1	;5801
	asl.b	#$02,d1	;E501
	move.b	d1,$0006(a4)	;19410006
adrCd002152:	eor.b	#$02,$0002(a4)	;0A2C00020002
	rts	;4E75

adrCd00215A:	cmp.b	#$98,$000B(a4)	;0C2C0098000B
	bne.s	adrCd002184	;6622
	cmp.w	d0,d2	;B440
	beq.s	adrCd002106	;67A0
	move.b	$01(a6,d0.w),d1	;12360001
	and.w	#$0007,d1	;02410007
	subq.w	#$03,d1	;5741
	beq.s	adrCd002106	;6794
	subq.w	#$04,d1	;5941
	bne.s	adrCd002106	;6690
	move.b	$00(a6,d0.w),d1	;12360000
	and.w	#$0003,d1	;02410003
	subq.w	#$01,d1	;5341
	bne.s	adrCd002106	;6684
	bra.s	adrCd00219A	;6016

adrCd002184:	cmp.w	d2,d0	;B042
	bne.s	adrCd00219A	;6612
	cmp.b	#$85,$000B(a4)	;0C2C0085000B
	beq.s	adrCd002152	;67C2
	cmp.b	#$82,$000B(a4)	;0C2C0082000B
	beq	adrCd002106	;6700FF6E
adrCd00219A:	cmp.b	#$85,$000B(a4)	;0C2C0085000B
	bne.s	adrCd0021BA	;6618
	move.w	$00(a6,d0.w),d1	;32360000
	not.b	d1	;4601
	and.w	#$0007,d1	;02410007
	bne.s	adrCd002152	;66A4
	move.b	$00(a6,d0.w),d1	;12360000
	and.w	#$0003,d1	;02410003
	subq.w	#$01,d1	;5341
	bne.s	adrCd002152	;6698
adrCd0021BA:	bclr	#$07,$01(a6,d2.w)	;08B600072001
adrCd0021C0:	cmp.b	#$88,$000B(a4)	;0C2C0088000B
	bcs.s	adrCd0021D2	;650A
	cmp.b	#$8B,$000B(a4)	;0C2C008B000B
	bcs	adrCd00207A	;6500FEAA
adrCd0021D2:	moveq	#$00,d7	;7E00
	move.b	$0006(a4),d7	;1E2C0006
	swap	d7	;4847
	move.b	$000B(a4),d7	;1E2C000B
	bmi.s	adrCd0021E2	;6B02
	clr.w	d7	;4247
adrCd0021E2:	moveq	#$00,d1	;7200
	move.b	$0004(a4),d1	;122C0004
	move.w	d0,d4	;3800
	move.b	$000C(a4),adrB_00F99A.l	;13EC000C0000F99A
	bmi.s	adrCd002218	;6B24
	movem.l	d0/a0,-(sp)	;48E78080
	cmp.b	#$83,d7	;0C070083
	beq.s	adrCd00220C	;670E
	moveq	#$04,d0	;7004
	cmp.b	#$8B,d7	;0C07008B
	bcs.s	adrCd00220E	;6508
	cmp.b	#$98,d7	;0C070098
	beq.s	adrCd00220E	;6702
adrCd00220C:	moveq	#$05,d0	;7005
adrCd00220E:	jsr	PlaySound.l	;4EB90000968E
	movem.l	(sp)+,d0/a0	;4CDF0101
adrCd002218:	bsr	adrCd002CE6	;61000ACC
	move.w	d4,d0	;3004
	move.l	a4,-(sp)	;2F0C
	bsr.s	adrCd00224E	;612C
	move.l	(sp)+,a4	;285F
	sub.w	#$0010,a4	;98FC0010
adrCd002228:	rts	;4E75

adrCd00222A:	bset	#$05,$01(a6,d0.w)	;08F600050001
	asl.b	#$02,d7	;E507
	addq.w	#$02,d7	;5447
	lea	adrEA015860.l,a0	;41F900015860
	move.w	-$0002(a0),d2	;3428FFFE
	addq.w	#$01,-$0002(a0)	;5268FFFE
	asl.w	#$02,d2	;E542
	move.w	d0,$00(a0,d2.w)	;31802000
	move.w	d7,$02(a0,d2.w)	;31872002
	rts	;4E75

adrCd00224E:	bsr.s	adrCd00222A	;61DA
	swap	d7	;4847
	move.b	$01(a6,d0.w),d5	;1A360001
	bpl.s	adrCd002228	;6AD0
	and.w	#$0007,d5	;02450007
	subq.w	#$01,d5	;5345
	beq.s	adrCd002228	;67C8
	movem.l	d0-d7/a0-a6,-(sp)	;48E7FFFE
	bsr	adrCd0087BA	;61006554
	bcs.s	adrCd002276	;650C
	movem.l	(sp)+,d0-d7/a0-a6	;4CDF7FFF
	bclr	#$07,$01(a6,d0.w)	;08B600070001
	bra.s	adrCd002228	;60B2

adrCd002276:	tst.b	d0	;4A00
	bpl.s	adrCd00229C	;6A22
	swap	d7	;4847
	move.b	d7,d5	;1A07
	swap	d7	;4847
	lsr.b	#$02,d5	;E40D
	cmp.b	#$18,d5	;0C050018
	beq.s	adrCd002294	;670C
	cmp.b	#$03,d5	;0C050003
	beq.s	adrCd00229C	;670E
	cmp.b	#$0B,d5	;0C05000B
	bcc.s	adrCd00229C	;6408
adrCd002294:	moveq	#$04,d0	;7004
	jsr	PlaySound.l	;4EB90000968E
adrCd00229C:	movem.l	(sp)+,d0-d7/a0-a6	;4CDF7FFF
	move.b	d7,d5	;1A07
	and.w	#$007F,d5	;0245007F
	move.w	d5,adrW_0025A8.l	;33C5000025A8
	tst.b	d7	;4A07
	bmi.s	adrCd0022FA	;6B4A
	bsr.s	adrCd0022B6	;6104
	bra	adrCd002804	;60000550

adrCd0022B6:	move.w	#$FFFF,adrW_002802.l	;33FCFFFF00002802
	move.w	d0,-(sp)	;3F00
	move.w	d7,d5	;3A07
	addq.w	#$01,d5	;5245
adrLp0022C4:	bsr	RandomGen_BytewithOffset	;61003F1A
	and.w	#$0007,d0	;02400007
	add.w	d0,d5	;DA40
	dbra	d7,adrLp0022C4	;51CFFFF4
	move.w	(sp)+,d0	;301F
	move.w	d5,-(sp)	;3F05
	cmp.w	#$03E8,d5	;0C4503E8
	bcs.s	adrCd0022E0	;6504
	move.w	#$03E5,d5	;3A3C03E5
adrCd0022E0:	moveq	#$03,d1	;7203
	lea	adrCd002B8A.l,a0	;41F900002B8A
adrLp0022E8:	move.w	d5,-(a0)	;3105
	dbra	d1,adrLp0022E8	;51C9FFFC
	move.w	(sp)+,d5	;3A1F
	swap	d5	;4845
	move.w	#$FFFF,d5	;3A3CFFFF
	swap	d5	;4845
	rts	;4E75

adrCd0022FA:	swap	d7	;4847
	lsr.b	#$02,d7	;E40F
	cmp.b	#$03,d7	;0C070003
	beq	adrCd002494	;67000190
	cmp.b	#$0B,d7	;0C07000B
	beq	adrCd00253A	;6700022E
	cmp.b	#$0C,d7	;0C07000C
	beq	adrCd00243A	;67000126
	cmp.b	#$0F,d7	;0C07000F
	beq	adrCd00240C	;670000F0
	cmp.b	#$0E,d7	;0C07000E
	beq	adrCd00236A	;67000046
	cmp.b	#$16,d7	;0C070016
	beq	adrCd00236A	;6700003E
	move.w	#$FFFF,adrW_002802.l	;33FCFFFF00002802
	movem.w	d0/d1,-(sp)	;48A7C000
	moveq	#-$01,d5	;7AFF
	bsr	adrCd0087BA	;6100647C
	bcs.s	adrCd002348	;6506
	movem.w	(sp)+,d0/d1	;4C9F0003
	rts	;4E75

adrCd002348:	bsr	adrCd0024B8	;6100016E
	add.w	#$01F4,d5	;064501F4
	lea	adrEA002B82.l,a0	;41F900002B82
	move.w	#$0003,d0	;303C0003
adrLp00235A:	add.w	#$00C8,(a0)+	;065800C8
	dbra	d0,adrLp00235A	;51C8FFFA
	movem.w	(sp)+,d0/d1	;4C9F0003
	bra	adrCd002804	;6000049C

adrCd00236A:	bsr	adrCd0087BA	;6100644E
	bcc.s	adrCd002394	;6424
	tst.b	d0	;4A00
	bmi.s	adrCd0023CE	;6B5A
	cmp.b	#$10,d0	;0C000010
	bcs.s	adrCd002396	;651C
	move.b	$0007(a1),d5	;1A290007
	and.b	#$7F,d5	;0205007F
	lsr.b	#$01,d5	;E20D
	move.b	d5,$0007(a1)	;13450007
	bsr	adrCd0025AA	;61000220
	tst.w	d5	;4A45
	beq.s	adrCd002394	;6704
	clr.b	$0007(a1)	;42290007
adrCd002394:	rts	;4E75

adrCd002396:	clr.b	$0015(a1)	;42290015
	move.w	adrW_0025A8.l,d5	;3A39000025A8
	move.w	d0,-(sp)	;3F00
	bsr	adrCd0025AC	;61000208
	move.w	(sp)+,d0	;301F
	bsr	adrCd0025AC	;61000202
	move.b	$000C(a1),d1	;1229000C
	sub.b	d5,d1	;9205
	bcc.s	adrCd0023B6	;6402
	moveq	#$00,d1	;7200
adrCd0023B6:	move.b	d1,$000C(a1)	;1341000C
	move.b	$0019(a1),d1	;12290019
	add.b	d5,d1	;D205
	cmp.b	#$64,d1	;0C010064
	bcs.s	adrCd0023C8	;6502
	moveq	#$64,d1	;7264
adrCd0023C8:	move.b	d1,$0019(a1)	;13410019
	rts	;4E75

adrCd0023CE:	moveq	#$03,d7	;7E03
	moveq	#$05,d0	;7005
	jsr	PlaySound.l	;4EB90000968E
adrLp0023D8:	moveq	#$00,d0	;7000
	move.b	$18(a1,d7.w),d0	;10317018
	move.w	d0,d1	;3200
	and.w	#$00E0,d0	;024000E0
	bne.s	adrCd0023F8	;6612
	and.w	#$000F,d1	;0241000F
	move.w	d1,d0	;3001
	bsr	adrCd0072D4	;61004EE6
	move.w	d1,d0	;3001
	exg	a4,a1	;C949
	bsr.s	adrCd002396	;61A0
	exg	a4,a1	;C949
adrCd0023F8:	dbra	d7,adrLp0023D8	;51CFFFDE
	move.l	a5,-(sp)	;2F0D
	move.l	a1,a5	;2A49
	bsr	adrCd008894	;61006492
	bsr	adrCd008F3E	;61006B38
	move.l	(sp)+,a5	;2A5F
	rts	;4E75

adrCd00240C:	bsr	adrCd0087BA	;610063AC
	bcc.s	adrCd002438	;6426
adrCd002412:	moveq	#$1D,d4	;781D
	tst.b	d0	;4A00
	bmi.s	adrCd002438	;6B20
	cmp.b	#$10,d0	;0C000010
	bcs.s	adrCd002420	;6502
	moveq	#$03,d4	;7803
adrCd002420:	and.b	#$F0,$00(a1,d4.w)	;023100F04000
	bsr	adrCd002540	;61000118
	bclr	#$06,$03(a1,d4.w)	;08B100064003
	beq.s	adrCd002438	;6706
	bset	#$05,$03(a1,d4.w)	;08F100054003
adrCd002438:	rts	;4E75

adrCd00243A:	bsr	adrCd0087BA	;6100637E
	bcc.s	adrCd002462	;6422
	moveq	#$1A,d4	;781A
	tst.b	d0	;4A00
	bmi.s	adrCd002464	;6B1E
	cmp.b	#$10,d0	;0C000010
	bcs.s	adrCd00244E	;6502
	moveq	#$00,d4	;7800
adrCd00244E:	bsr	adrCd0025AA	;6100015A
	tst.w	d5	;4A45
	beq.s	adrCd002462	;670C
	bset	#$07,$05(a1,d4.w)	;08F100074005
	or.b	#$0F,$03(a1,d4.w)	;0031000F4003
adrCd002462:	rts	;4E75

adrCd002464:	moveq	#$03,d7	;7E03
	moveq	#$05,d0	;7005
	jsr	PlaySound.l	;4EB90000968E
adrLp00246E:	moveq	#$00,d0	;7000
	move.b	$18(a1,d7.w),d0	;10317018
	move.w	d0,d1	;3200
	and.w	#$00E0,d0	;024000E0
	bne.s	adrCd00248E	;6612
	and.w	#$000F,d1	;0241000F
	move.w	d1,d0	;3001
	bsr	adrCd0072D4	;61004E50
	move.w	d1,d0	;3001
	exg	a4,a1	;C949
	bsr.s	adrCd00244E	;61C2
	exg	a4,a1	;C949
adrCd00248E:	dbra	d7,adrLp00246E	;51CFFFDE
	rts	;4E75

adrCd002494:	move.w	#$FFFF,adrW_002802.l	;33FCFFFF00002802
	movem.w	d0/d1,-(sp)	;48A7C000
	moveq	#-$01,d5	;7AFF
	bsr	adrCd0087BA	;61006316
	bcs.s	adrCd0024AE	;6506
	movem.w	(sp)+,d0/d1	;4C9F0003
	rts	;4E75

adrCd0024AE:	bsr.s	adrCd0024B8	;6108
	movem.w	(sp)+,d0/d1	;4C9F0003
	bra	adrCd002804	;6000034E

adrCd0024B8:	move.w	d0,-(sp)	;3F00
	bsr.s	adrCd0024CE	;6112
	move.w	(sp),d0	;3017
	tst.b	d0	;4A00
	bpl.s	adrCd0024C6	;6A04
	bsr	adrCd0025AC	;610000E8
adrCd0024C6:	movem.w	(sp)+,d0	;4C9F0001
	bra	adrCd0025AC	;600000E0

adrCd0024CE:	tst.b	d0	;4A00
	bmi.s	adrCd0024F6	;6B24
	cmp.b	#$10,d0	;0C000010
	bcs.s	adrCd0024EC	;6514
	cmp.b	#$6C,$000B(a4)	;0C2C006C000B
	bne.s	adrCd0024E4	;6604
	clr.w	d5	;4245
	rts	;4E75

adrCd0024E4:	move.w	$0008(a1),d5	;3A290008
	addq.w	#$01,d5	;5245
	rts	;4E75

adrCd0024EC:	clr.w	d5	;4245
	move.w	$0006(a1),d5	;3A290006
	addq.b	#$01,d5	;5205
	rts	;4E75

adrCd0024F6:	moveq	#$05,d0	;7005
	jsr	PlaySound.l	;4EB90000968E
	moveq	#$01,d2	;7401
	lea	adrEA002B82.l,a0	;41F900002B82
	clr.l	(a0)	;4290
	clr.l	$0004(a0)	;42A80004
	move.l	a4,-(sp)	;2F0C
	moveq	#$03,d7	;7E03
adrLp002510:	moveq	#$00,d0	;7000
	move.b	$18(a1,d7.w),d0	;10317018
	and.w	#$00E0,d0	;024000E0
	bne.s	adrCd002532	;6616
	move.b	$18(a1,d7.w),d0	;10317018
	bsr	adrCd0072D4	;61004DB2
	add.w	d7,d7	;DE47
	move.w	$0006(a4),$00(a0,d7.w)	;31AC00067000
	addq.w	#$01,$00(a0,d7.w)	;52707000
	lsr.w	#$01,d7	;E24F
adrCd002532:	dbra	d7,adrLp002510	;51CFFFDC
	move.l	(sp)+,a4	;285F
adrCd002538:	rts	;4E75

adrCd00253A:	bsr	adrCd0087BA	;6100627E
	bcc.s	adrCd002538	;64F8
adrCd002540:	tst.b	d0	;4A00
	bmi.s	adrCd00258A	;6B46
	moveq	#$1C,d4	;781C
	cmp.b	#$10,d0	;0C000010
	bcs.s	adrCd002554	;6508
	tst.b	$000B(a1)	;4A29000B
	bmi.s	adrCd002588	;6B36
	moveq	#$02,d4	;7802
adrCd002554:	move.b	$00(a1,d4.w),d7	;1E314000
	bsr.s	adrCd00256C	;6112
	cmp.b	$00(a1,d4.w),d7	;BE314000
	beq.s	adrCd002588	;6728
	move.b	d7,$00(a1,d4.w)	;13874000
	bset	#$06,$03(a1,d4.w)	;08F100064003
	rts	;4E75

adrCd00256C:	move.w	d0,d6	;3C00
	bsr	adrCd0025AA	;6100003A
	tst.w	d5	;4A45
	beq.s	adrCd002588	;6712
	eor.b	#$02,d7	;0A070002
	move.w	d6,d0	;3006
	bsr	adrCd0025AA	;6100002C
	tst.w	d5	;4A45
	bne.s	adrCd002588	;6604
	eor.b	#$01,d7	;0A070001
adrCd002588:
	rts	;4E75

adrCd00258A:
	bsr	adrCd0072D0	;61004D44
	moveq	#$05,d0	;7005
	jsr	PlaySound.l	;4EB90000968E
	exg	a1,a4	;C34C
	move.w	$0006(a4),d0	;302C0006
	move.w	$0020(a4),d7	;3E2C0020
	bsr.s	adrCd00256C	;61CA
	move.w	d7,$0020(a4)	;39470020
	rts	;4E75

adrW_0025A8:
	dc.w	$0000	;0000

adrCd0025AA:
	moveq	#$01,d5	;7A01
adrCd0025AC:
	tst.b	d0	;4A00
	bmi.s	adrCd0025E4	;6B34
	cmp.b	#$10,d0	;0C000010
	bcs.s	adrCd0025DE	;6528
	move.b	$0006(a1),d2	;14290006
	and.w	#$007F,d2	;0242007F
adrCd0025BE:
	asl.w	#$03,d2			;E742
	add.w	#$0064,d2		;06420064
	move.w	adrW_0025A8.l,d0	;3039000025A8
	add.w	d0,d0			;D040
	sub.w	d0,d2			;9440
	bpl.s	adrCd0025D2		;6A02
	moveq	#$0A,d2			;740A
adrCd0025D2:
	bsr	RandomGen_BytewithOffset	;61003C0C
	cmp.w	d0,d2			;B440
	bcs.s	adrCd0025DC		;6502
	lsr.w	#$01,d5			;E24D
adrCd0025DC:	rts			;4E75

adrCd0025DE:	moveq	#$00,d2	;7400
	move.b	(a1),d2	;1411
	bra.s	adrCd0025BE	;60DA

adrCd0025E4:	moveq	#$06,d1	;7206
	movem.l	a4/a5,-(sp)	;48E7000C
	move.l	a1,a5	;2A49
	bsr	adrCd006128	;61003B3A
	movem.l	(sp)+,a4/a5	;4CDF3000
	tst.w	d3	;4A43
	bpl.s	adrCd002610	;6A18
	move.w	#$8000,d1	;323C8000
	movem.l	a4/a5,-(sp)	;48E7000C
	move.l	a1,a5	;2A49
	bsr	adrCd006128	;61003B24
	movem.l	(sp)+,a4/a5	;4CDF3000
	tst.w	d3	;4A43
	bmi.s	adrCd00263C	;6B2E
	add.w	d3,d3	;D643
adrCd002610:
	move.w	#$FF80,adrW_0025A8.l	;33FCFF80000025A8
	move.w	d3,-(sp)	;3F03
	bsr.s	adrCd00263C	;6120
	move.w	(sp)+,d3	;361F
	move.w	d3,d7	;3E03
	addq.w	#$02,d3	;5443
	asl.w	#$03,d3	;E743
	neg.w	d3	;4443
	move.w	d3,adrW_0025A8.l	;33C3000025A8
	lsr.w	#$02,d7	;E44F
	addq.w	#$01,d7	;5247
adrLp002630:
	move.w	d7,-(sp)	;3F07
	bsr.s	adrCd00263C	;6108
	move.w	(sp)+,d7	;3E1F
	dbra	d7,adrLp002630	;51CFFFF8
	rts	;4E75

adrCd00263C:
	lea	adrEA002B82.l,a0	;41F900002B82
	move.l	a4,-(sp)	;2F0C
	clr.w	d5	;4245
	moveq	#$03,d7	;7E03
adrLp002648:
	move.b	$18(a1,d7.w),d0	;10317018
	bsr	adrCd0072D4	;61004C86
	add.w	d7,d7	;DE47
	move.w	$00(a0,d7.w),d5	;3A307000
	exg	a4,a1	;C949
	bsr.s	adrCd0025DE	;6184
	exg	a4,a1	;C949
	move.w	d5,$00(a0,d7.w)	;31857000
	lsr.w	#$01,d7	;E24F
	dbra	d7,adrLp002648	;51CFFFE4
	move.l	(sp)+,a4	;285F
adrCd002668:	rts	;4E75

adrCd00266A:	move.b	$000B(a1),d0	;1029000B
	bmi.s	adrCd002668	;6BF8
	sub.b	#$64,d0	;04000064
	beq.s	adrCd002668	;67F2
	move.b	adrB_00F99A.l,d0	;10390000F99A
	cmp.b	#$10,d0	;0C000010
	bcc.s	adrCd002668	;64E6
	bsr	adrCd0072D4	;61004C50
	cmp.b	#$EC,$0020(a4)	;0C2C00EC0020
	bcc.s	adrCd0026CA	;643C
	move.w	$0020(a4),d2	;342C0020
	move.w	d5,d1	;3205
	cmp.w	$0008(a1),d1	;B2690008
	bcs.s	adrCd0026A0	;6506
	move.w	$0008(a1),d1	;32290008
	addq.w	#$01,d1	;5241
adrCd0026A0:	tst.w	Multiplayer.l	;4A790000F98C
	beq.s	adrCd0026AC	;6704
	addq.w	#$01,d1	;5241
	lsr.w	#$01,d1	;E249
adrCd0026AC:	sub.w	d1,d2	;9441
	bcs.s	adrCd0026BA	;650A
	cmp.b	#$09,$0006(a1)	;0C2900090006
	bcc.s	adrCd0026BA	;6402
	sub.w	d1,d2	;9441
adrCd0026BA:	cmp.b	#$10,$0001(a4)	;0C2C00100001
	bcc.s	adrCd0026CA	;6408
	move.w	d2,$0020(a4)	;39420020
	bsr	adrCd00273E	;61000076
adrCd0026CA:	move.l	a5,a2	;244D
	move.b	adrB_00F99A.l,d0	;10390000F99A
	and.w	#$000F,d0	;0240000F
	bsr	adrCd0047FA	;61002122
	exg	a2,a5	;C54D
	tst.w	d1	;4A41
	bmi.s	adrCd002668	;6B88
	move.w	$0008(a1),d1	;32290008
	sub.w	d5,d1	;9245
	bcc.s	adrCd00273C	;6454
	move.b	$0006(a1),d1	;12290006
	and.w	#$007F,d1	;0241007F
	moveq	#$03,d7	;7E03
adrLp0026F2:	move.b	$18(a2,d7.w),d0	;10327018
	and.w	#$00E0,d0	;024000E0
	bne.s	adrCd002738	;663C
	move.b	$18(a2,d7.w),d0	;10327018
	bsr	adrCd0072D4	;61004BD2
	cmp.b	#$10,$0001(a4)	;0C2C00100001
	bcc.s	adrCd002738	;642C
	move.b	$0020(a4),d0	;102C0020
	cmp.b	#$EC,d0	;0C0000EC
	bcc.s	adrCd002738	;6422
	moveq	#$00,d2	;7400
	move.b	d1,d2	;1401
	sub.b	(a4),d2	;9414
	addq.b	#$02,d2	;5402
	bmi.s	adrCd002738	;6B18
	asl.w	#$07,d2	;EF42
	move.w	$0020(a4),d0	;302C0020
	tst.w	Multiplayer.l	;4A790000F98C
	bne.s	adrCd002730	;6602
	add.w	d2,d2	;D442
adrCd002730:	sub.w	d2,d0	;9042
	move.w	d0,$0020(a4)	;39400020
	bsr.s	adrCd00273E	;6106
adrCd002738:	dbra	d7,adrLp0026F2	;51CFFFB8
adrCd00273C:	rts	;4E75

adrCd00273E:	tst.b	$0022(a4)	;4A2C0022
	bmi.s	adrCd002788	;6B44
	moveq	#$00,d2	;7400
	move.b	(a4),d2	;1414
	lea	adrEA0054A0.l,a0	;41F9000054A0
	move.b	$00(a0,d2.w),d3	;16302000
	lsr.b	#$01,d3	;E20B
	cmp.b	$0020(a4),d3	;B62C0020
	bcs.s	adrCd002788	;652E
	move.b	$0001(a4),d3	;162C0001
	and.w	#$0003,d3	;02430003
	beq.s	adrCd002768	;6704
	subq.w	#$03,d3	;5743
	bne.s	adrCd00276E	;6606
adrCd002768:	btst	#$00,d2	;08020000
	bne.s	adrCd002788	;661A
adrCd00276E:	add.b	#$81,$0022(a4)	;062C00810022
	cmp.l	#$FFFFFFFF,$0010(a4)	;0CACFFFFFFFF0010
	bne.s	adrCd002788	;660A
	tst.b	$000F(a4)	;4A2C000F
	bmi.s	adrCd002788	;6B04
	clr.b	$0022(a4)	;422C0022
adrCd002788:	rts	;4E75

adrCd00278A:	
	swap	d5	;4845
	clr.w	d5		;4245
	swap	d5		;4845
	cmp.w	#$0010,d0	;0C400010
	bcs.s	adrCd0027BC	;6526
	move.w	d0,d1		;3200
	sub.w	#$0010,d0	;04400010
	asl.w	#$04,d0		;E940
	lea	UnpackedMonsters.l,a1	;43F900014EE6
	add.w	d0,a1		;D2C0
	moveq	#$00,d7		;7E00
	move.b	$0000(a1),d7	;1E290000
	swap	d7		;4847
	move.b	$0001(a1),d7	;1E290001
	bsr	CoordToMap	;61006AB8
	move.w	d0,d4		;3800
	move.w	d1,d0		;3001
	bra.s	adrCd00281C	;6060

adrCd0027BC:	move.w	d0,d3	;3600
	bsr	adrCd0072D4	;61004B14
	move.l	a4,a1	;224C
	moveq	#$00,d7	;7E00
	move.b	$001A(a1),d7	;1E29001A
	bpl.s	adrCd0027F0	;6A24
	move.w	d3,d0	;3003
	bsr	adrCd0047FA	;6100202A
	tst.w	d1	;4A41
	bmi	adrCd002228	;6B00FA52
	move.l	a5,a1	;224D
	lea	adrEA002B82.l,a0	;41F900002B82
	clr.l	(a0)	;4290
	clr.l	$0004(a0)	;42A80004
	add.w	d1,d1	;D241
	move.w	d5,$00(a0,d1.w)	;31851000
	bra	adrCd002984	;60000196

adrCd0027F0:	swap	d7	;4847
	move.b	$001B(a1),d7	;1E29001B
	bsr	CoordToMap	;61006A74
	move.w	d0,d4	;3800
	move.w	d3,d0	;3003
	bra	adrCd00290E	;6000010E

adrW_002802:	dc.w	$0000	;0000

adrCd002804:	move.w	d0,d4	;3800
	bsr	adrCd0087BA	;61005FB2
	bcs.s	adrCd00280E	;6502
	rts	;4E75

adrCd00280E:
	tst.b	d0	;4A00
	bmi	adrCd002984	;6B000172
	cmp.w	#$0010,d0	;0C400010
	bcs	adrCd00290E	;650000F4
adrCd00281C:
	tst.w	adrW_002802.l	;4A7900002802
	beq.s	adrCd00286E	;674A
	moveq	#$00,d1	;7200
	move.b	$000D(a1),d1	;1229000D
	bmi.s	adrCd00286E	;6B42
	asl.w	#$02,d1	;E541
	lea	adrEA0156F8.l,a0	;41F9000156F8
	add.w	d1,a0	;D0C1
	moveq	#$03,d7	;7E03
adrLp002838:	moveq	#$00,d1	;7200
	move.b	$00(a0,d7.w),d1	;12307000
	bmi.s	adrCd00285A	;6B1A
	move.w	d1,d0	;3001
	add.w	#$0010,d0	;06400010
	asl.w	#$04,d1	;E941
	lea	UnpackedMonsters.l,a1	;43F900014EE6
	add.w	d1,a1	;D2C1
	movem.l	d4/d5/d7/a0/a6,-(sp)	;48E70D82
	bsr.s	adrCd00286E	;6118
	movem.l	(sp)+,d4/d5/d7/a0/a6	;4CDF41B0
adrCd00285A:	dbra	d7,adrLp002838	;51CFFFDC
	cmp.l	#$FFFFFFFF,(a0)	;0C90FFFFFFFF
	beq.s	adrCd00288E	;6728
	bset	#$07,$01(a6,d4.w)	;08F600074001
	rts	;4E75

adrCd00286E:	movem.w	d0/d4,-(sp)	;48A78800
	tst.l	d5	;4A85
	bpl.s	adrCd00287A	;6A04
	bsr	adrCd0025AC	;6100FD34
adrCd00287A:	bsr	adrCd00266A	;6100FDEE
	movem.w	(sp)+,d0/d4	;4C9F0011
	move.w	$0008(a1),d1	;32290008
	sub.w	d5,d1	;9245
	bcs.s	adrCd002890	;6506
	move.w	d1,$0008(a1)	;33410008
adrCd00288E:	rts	;4E75

adrCd002890:	moveq	#$00,d2	;7400
	move.b	$000C(a1),d2	;1429000C
	swap	d2	;4842
	move.b	$000B(a1),d2	;1429000B
	move.l	d2,-(sp)	;2F02
	bsr	adrCd002CF6	;61000456
	move.w	d4,d0	;3004
	moveq	#$01,d7	;7E01
	bsr	adrCd00222A	;6100F982
	move.l	(sp)+,d2	;241F
	tst.b	d2	;4A02
	bmi.s	adrCd00288E	;6BDE
	moveq	#$01,d5	;7A01
	swap	d5	;4845
	cmp.b	#$64,d2	;0C020064
	beq.s	adrCd00288E	;67D4
	swap	d2	;4842
	move.b	d2,d5	;1A02
	bpl.s	adrCd0028C6	;6A06
	bsr.s	adrCd0028D4	;6112
	tst.w	d5	;4A45
	beq.s	adrCd00288E	;67C8
adrCd0028C6:	move.w	d4,d0	;3004
	move.l	adrL_00F9D4.l,a6	;2C790000F9D4
	moveq	#$00,d6	;7C00
	bra	adrCd006AAA	;600041D8

adrCd0028D4:	bsr	RandomGen_BytewithOffset	;6100390A
	and.l	#$0000000F,d0	;02800000000F
	moveq	#$01,d5	;7A01
	swap	d5	;4845
	move.b	adrB_0028FE(pc,d0.w),d5	;1A3B001A
	beq.s	adrCd0028FC	;6714
	cmp.w	#$0005,d5	;0C450005
	bcc.s	adrCd0028FC	;640E
	bsr	RandomGen_BytewithOffset	;610038F0
	and.l	#$00000007,d0	;028000000007
	swap	d0	;4840
	add.l	d0,d5	;DA80
adrCd0028FC:	rts	;4E75

adrB_0028FE:	dc.b	$00	;00
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

adrCd00290E:	tst.l	d5	;4A85
	bpl.s	adrCd00291A	;6A08
	move.w	d0,-(sp)	;3F00
	bsr	adrCd0025AC	;6100FC96
	move.w	(sp)+,d0	;301F
adrCd00291A:	move.w	$0006(a1),d1	;32290006
	sub.w	d5,d1	;9245
	bcs.s	adrCd002928	;6506
	move.w	d1,$0006(a1)	;33410006
	rts	;4E75

adrCd002928:	clr.w	$0006(a1)	;42690006
	clr.b	$000A(a1)	;4229000A
	move.l	a5,-(sp)	;2F0D
	bsr	adrCd0047FA	;61001EC6
	tst.w	d1	;4A41
	bmi.s	adrCd002958	;6B1E
	bset	#$06,$18(a5,d1.w)	;08F500061018
	tst.w	$0042(a5)	;4A6D0042
	bpl.s	adrCd002958	;6A12
	movem.l	d4/a1,-(sp)	;48E70840
	move.w	d1,d7	;3E01
	bsr	adrCd008C4A	;610062FC
	bsr	adrCd008C2C	;610062DA
	movem.l	(sp)+,d4/a1	;4CDF0210
adrCd002958:	move.l	(sp)+,a5	;2A5F
	move.b	#$FF,$001A(a1)	;137C00FF001A
	move.l	adrL_00F9D4.l,a6	;2C790000F9D4
	move.w	d4,d0	;3004
	bclr	#$07,$01(a6,d0.w)	;08B600070001
	move.l	a1,d5	;2A09
	sub.l	#CharacterStats,d5	;04850000F586	;Long Addr replaced with Symbol NOT - now fixed
	lsr.w	#$06,d5	;EC4D
	add.l	#$00010040,d5	;068500010040	;Long Addr replaced with Symbol
	moveq	#$00,d6	;7C00
	bra	adrCd006AAA	;60004128

adrCd002984:	or.b	#$0F,$003E(a1)	;0029000F003E
	bclr	#$02,(a1)	;08910002
	beq.s	adrCd002994	;6704
	clr.w	$0014(a1)	;42690014
adrCd002994:	tst.l	d5	;4A85
	bpl.s	adrCd00299E	;6A06
	moveq	#-$01,d0	;70FF
	bsr	adrCd0025AC	;6100FC10
adrCd00299E:	moveq	#$03,d1	;7203
	lea	adrEA002B82.l,a0	;41F900002B82
adrLp0029A6:	move.w	d1,d2	;3401
	add.w	d2,d2	;D442
	move.b	$18(a1,d1.w),d0	;10311018
	and.w	#$00E0,d0	;024000E0
	beq.s	adrCd0029BA	;6706
	clr.w	$00(a0,d2.w)	;42702000
	bra.s	adrCd0029EE	;6034

adrCd0029BA:	move.b	$18(a1,d1.w),d0	;10311018
	bsr	adrCd0072D4	;61004914
	move.w	$0006(a4),d0	;302C0006
	sub.w	$00(a0,d2.w),d0	;90702000
	bcc.s	adrCd0029EA	;641E
	or.b	#$40,$18(a1,d1.w)	;003100401018
	clr.b	$0015(a4)	;422C0015
	move.b	#$FF,$0017(a4)	;197C00FF0017
	move.l	a0,-(sp)	;2F08
	moveq	#$03,d0	;7003
	jsr	PlaySound.l	;4EB90000968E
	move.l	(sp)+,a0	;205F
	moveq	#$00,d0	;7000
adrCd0029EA:	move.w	d0,$0006(a4)	;39400006
adrCd0029EE:	dbra	d1,adrLp0029A6	;51C9FFB6
	move.l	a5,-(sp)	;2F0D
	move.l	a1,a5	;2A49
	moveq	#$03,d1	;7203
adrLp0029F8:	move.b	$18(a5,d1.w),d0	;10351018
	bmi.s	adrCd002A1C	;6B1E
	btst	#$06,d0	;08000006
	beq.s	adrCd002A1C	;6718
	btst	#$05,d0	;08000005
	bne.s	adrCd002A1C	;6612
	and.w	#$000F,d0	;0240000F
	bsr	adrCd004826	;61001E16
	tst.w	d2	;4A42
	bmi.s	adrCd002A1C	;6B06
	move.b	#$FF,$26(a5,d2.w)	;1BBC00FF2026
adrCd002A1C:	dbra	d1,adrLp0029F8	;51C9FFDA
	btst	#$06,$0018(a5)	;082D00060018
	bne.s	adrCd002A30	;6608
	bsr	adrCd008FCA	;610065A0
	bra	adrCd002B0A	;600000DC

adrCd002A30:	moveq	#$00,d1	;7200
	moveq	#$00,d0	;7000
adrCd002A34:	move.b	$18(a5,d1.w),d0	;10351018
	and.w	#$00E0,d0	;024000E0
	bne.s	adrCd002A76	;6638
	move.b	$18(a5,d1.w),d0	;10351018
	and.w	#$000F,d0	;0240000F
	move.b	$0018(a5),$18(a5,d1.w)	;1BAD00181018
	move.b	d0,$0018(a5)	;1B400018
	bset	#$04,$0018(a5)	;08ED00040018
	move.w	d0,$0006(a5)	;3B400006
	bsr.s	adrCd002A60	;6104
	bra	adrCd002AFE	;600000A0

adrCd002A60:	lea	adrEA002B82.l,a0	;41F900002B82
	move.w	(a0),d0	;3010
	add.w	d1,d1	;D241
	move.w	$00(a0,d1.w),(a0)	;30B01000
	move.w	d0,$00(a0,d1.w)	;31801000
	lsr.w	#$01,d1	;E249
	rts	;4E75

adrCd002A76:	addq.w	#$01,d1	;5241
	cmp.w	#$0004,d1	;0C410004
	bcs.s	adrCd002A34	;65B6
	and.b	#$01,(a5)	;02150001
	moveq	#$03,d1	;7203
adrLp002A84:	move.b	$18(a5,d1.w),d0	;10351018
	btst	#$05,d0	;08000005
	beq.s	adrCd002A94	;6706
	btst	#$06,d0	;08000006
	beq.s	adrCd002A9A	;6706
adrCd002A94:	dbra	d1,adrLp002A84	;51C9FFEE
	bra.s	adrCd002AEE	;6054

adrCd002A9A:	move.b	$0018(a5),$18(a5,d1.w)	;1BAD00181018
	move.b	d0,$0018(a5)	;1B400018
	bset	#$04,$0018(a5)	;08ED00040018
	and.w	#$000F,d0	;0240000F
	move.w	d0,$0006(a5)	;3B400006
	bsr.s	adrCd002A60	;61AC
	bsr	adrCd002B28	;61000072
	bclr	#$05,$0018(a5)	;08AD00050018
	bsr	adrCd0072D0	;61004810
	move.b	$001A(a4),$001D(a5)	;1B6C001A001D
	move.b	$001B(a4),$001F(a5)	;1B6C001B001F
	move.b	$001E(a4),$0059(a5)	;1B6C001E0059
	move.b	$001C(a4),$0021(a5)	;1B6C001C0021
	move.b	#$FF,$001A(a4)	;197C00FF001A
	move.b	$0018(a5),$0026(a5)	;1B6D00180026
	and.b	#$0F,$0026(a5)	;022D000F0026
	bra.s	adrCd002AFE	;6010

adrCd002AEE:	bsr.s	adrCd002B28	;6138
	move.b	#$FF,$001D(a5)	;1B7C00FF001D
	bsr	adrCd002C14	;6100011C
	and.b	#$01,(a5)	;02150001
adrCd002AFE:	clr.w	$0014(a5)	;426D0014
	clr.b	$003E(a5)	;422D003E
	bsr	adrCd008FFC	;610064F4
adrCd002B0A:	move.w	#$FFFF,$0042(a5)	;3B7CFFFF0042
	move.w	#$FFFF,$0040(a5)	;3B7CFFFF0040
	move.b	#$FF,$0035(a5)	;1B7C00FF0035
	bsr	adrCd008C1A	;610060FC
	bsr	adrCd002B62	;61000040
	move.l	(sp)+,a5	;2A5F
	rts	;4E75

adrCd002B28:	bsr	adrCd009268	;6100673E
	bclr	#$07,$01(a6,d0.w)	;08B600070001
	moveq	#$03,d1	;7203
adrLp002B34:	moveq	#$01,d5	;7A01
	swap	d5	;4845
	move.b	$18(a5,d1.w),d5	;1A351018
	bmi.s	adrCd002B5C	;6B1E
	bset	#$05,$18(a5,d1.w)	;08F500051018
	bne.s	adrCd002B5C	;6616
	and.w	#$000F,d5	;0245000F
	add.w	#$0040,d5	;06450040
	moveq	#$00,d6	;7C00
	movem.l	d0/d1,-(sp)	;48E7C000
	bsr	adrCd006AAA	;61003F54
	movem.l	(sp)+,d0/d1	;4CDF0003
adrCd002B5C:	dbra	d1,adrLp002B34	;51C9FFD6
	rts	;4E75

adrCd002B62:	moveq	#$03,d7	;7E03
adrLp002B64:	move.b	$18(a5,d7.w),d0	;10357018
	bmi.s	adrCd002B7C	;6B12
	move.w	d7,d1	;3207
	add.w	d1,d1	;D241
	move.w	adrEA002B82(pc,d1.w),d0	;303B1012
	beq.s	adrCd002B7C	;6708
	move.w	d7,-(sp)	;3F07
	bsr	adrCd002B8A	;61000012
	move.w	(sp)+,d7	;3E1F
adrCd002B7C:	dbra	d7,adrLp002B64	;51CFFFE6
	rts	;4E75

adrEA002B82:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000

adrCd002B8A:	move.w	d0,-(sp)	;3F00
	move.l	#$000D000C,adrW_00E3FA.l	;23FC000D000C0000E3FA
	lea	_GFX_Pockets+$7688.l,a1	;43F900050B3A
	move.b	#$07,$5A(a5,d7.w)	;1BBC0007705A
	move.w	d7,d0	;3007
	move.l	#$0001000A,d7	;2E3C0001000A	;Long Addr replaced with Symbol
	add.w	d0,d0	;D040
	add.w	d0,d0	;D040
	move.w	adrW_002C04(pc,d0.w),d4	;383B0054
	move.w	adrW_002C06(pc,d0.w),d5	;3A3B0052
	add.w	$0008(a5),d5	;DA6D0008
	movem.l	d4/d5,-(sp)	;48E70C00
	moveq	#$00,d6	;7C00
	jsr	adrCd00BCFC.l	;4EB90000BCFC
	movem.l	(sp)+,d4/d5	;4CDF0030
	move.w	(sp)+,d0	;301F
	addq.w	#$04,d4	;5844
	addq.w	#$03,d5	;5645
	lea	NumHitsMsg.l,a6	;4DF900006DC8
	moveq	#$00,d2	;7400
	bsr	adrCd006DCC	;610041F2
	moveq	#$08,d0	;7008
	move.w	d2,d1	;3202
	beq.s	adrCd002BEA	;6708
	subq.w	#$04,d0	;5940
	subq.w	#$01,d2	;5342
	beq.s	adrCd002BEA	;6702
	subq.w	#$04,d0	;5940
adrCd002BEA:	add.w	d0,d4	;D840
adrLp002BEC:	move.b	(a6)+,d0	;101E
	movem.l	d1/d4/d5/a6,-(sp)	;48E74C02
	jsr	adrCd00E3FE.l	;4EB90000E3FE
	movem.l	(sp)+,d1/d4/d5/a6	;4CDF4032
	addq.w	#$08,d4	;5044
	dbra	d1,adrLp002BEC	;51C9FFEC
	rts	;4E75

adrW_002C04:	dc.w	$000B	;000B
adrW_002C06:	dc.w	$0013	;0013
	dc.w	$0000	;0000
	dc.w	$0040	;0040
	dc.w	$0020	;0020
	dc.w	$0040	;0040
	dc.w	$0040	;0040
	dc.w	$0040	;0040

adrCd002C14:	bsr.s	adrCd002C3A	;6124
	lea	ThouArtDead.l,a6	;4DF900002C22
	jmp	adrCd00DAA6.l	;4EF90000DAA6

ThouArtDead:	dc.b	$FC	;FC
	dc.b	$12	;12
	dc.b	$04	;04
	dc.b	$FE	;FE
	dc.b	$04	;04
	dc.b	$FD	;FD
	dc.b	$00	;00
	dc.b	'THOU'	;54484F55
	dc.b	$FC	;FC
	dc.b	$10	;10
	dc.b	$06	;06
	dc.b	'ART DEAD'	;4152542044454144
	dc.b	$FF	;FF
	dc.b	$00	;00

adrCd002C3A:	or.b	#$40,$0054(a5)	;002D00400054
	moveq	#$00,d3	;7600
	bsr	adrCd009D70	;6100712C
	move.l	#$004B000C,d5	;2A3C004B000C
	add.w	$0008(a5),d5	;DA6D0008
	move.l	#$007F0060,d4	;283C007F0060
	moveq	#$04,d3	;7604
	moveq	#$02,d2	;7402
	bra.s	adrCd002C66	;600A

adrLp002C5C:	add.w	d2,d5	;DA42
	swap	d5	;4845
	sub.w	d2,d5	;9A42
	subq.w	#$01,d5	;5345
	swap	d5	;4845
adrCd002C66:	movem.l	d2-d5,-(sp)	;48E73C00
	jsr	adrCd00E5A4.l	;4EB90000E5A4
	movem.l	(sp)+,d2-d5	;4CDF003C
	eor.w	#$0006,d3	;0A430006
	add.l	#$FFFE0001,d4	;0684FFFE0001
	dbra	d2,adrLp002C5C	;51CAFFDC
	rts	;4E75

adrCd002C84:	movem.l	d0-d7/a0-a6,-(sp)	;48E7FFFE
	lea	UnpackedMonsters.l,a4	;49F900014EE6
	move.w	-$0002(a4),d6	;3C2CFFFE
adrLp002C92:	move.w	d6,d0	;3006
	asl.w	#$04,d0	;E940
	lea	$00(a4,d0.w),a3	;47F40000
	move.b	$000B(a3),d0	;102B000B
	bmi.s	adrCd002CA6	;6B06
	cmp.b	#$64,d0	;0C000064
	bne.s	adrCd002CCC	;6626
adrCd002CA6:	moveq	#$00,d0	;7000
	move.b	$0004(a3),d0	;102B0004
	bsr	adrCd0092AA	;610065FC
	moveq	#$00,d7	;7E00
	move.b	$0000(a3),d7	;1E2B0000
	bmi.s	adrCd002CCC	;6B14
	swap	d7	;4847
	move.b	$0001(a3),d7	;1E2B0001
	bsr	CoordToMap	;610065AC
	move.w	d0,d4	;3800
	move.w	d6,d0	;3006
	add.w	#$0010,d0	;06400010
	bsr.s	adrCd002CF6	;612A
adrCd002CCC:	dbra	d6,adrLp002C92	;51CEFFC4
	movem.l	(sp),d0-d7/a0-a6	;4CD77FFF
	move.w	d2,d0	;3002
	bsr	adrCd0092CC	;610065F4
	move.w	d1,d0	;3001
	bsr	adrCd0092AA	;610065CC
	movem.l	(sp)+,d0-d7/a0-a6	;4CDF7FFF
	rts	;4E75

adrCd002CE6:	move.l	a4,d0	;200C
	sub.l	#UnpackedMonsters,d0	;048000014EE6
	lsr.w	#$04,d0	;E848
	add.w	#$0010,d0	;06400010
	bra.s	adrCd002CFC	;6006

adrCd002CF6:	bclr	#$07,$01(a6,d4.w)	;08B600074001
adrCd002CFC:	bsr.s	adrCd002D4E	;6150
	lea	UnpackedMonsters.l,a2	;45F900014EE6
	move.w	-$0002(a2),d2	;342AFFFE
	subq.w	#$01,-$0002(a2)	;536AFFFE
	sub.w	d0,d2	;9440
	asl.w	#$04,d0	;E940
	lea	$00(a2,d0.w),a2	;45F20000
	lea	$0010(a2),a3	;47EA0010
	bra.s	adrCd002D22	;6008

adrLp002D1A:	move.l	(a3)+,(a2)+	;24DB
	move.l	(a3)+,(a2)+	;24DB
	move.l	(a3)+,(a2)+	;24DB
	move.l	(a3)+,(a2)+	;24DB
adrCd002D22:	dbra	d2,adrLp002D1A	;51CAFFF6
	moveq	#-$01,d2	;74FF
	move.l	d2,(a2)+	;24C2
	move.l	d2,(a2)+	;24C2
	move.l	d2,(a2)+	;24C2
	move.l	d2,(a2)	;2482
adrCd002D30:	rts	;4E75

adrCd002D32:	tst.b	$0035(a0)	;4A280035
	bmi.s	adrCd002D30	;6BF8
	cmp.b	$0035(a0),d0	;B0280035
	bne.s	adrCd002D46	;6608
	move.b	#$FF,$0035(a0)	;117C00FF0035
	rts	;4E75

adrCd002D46:	bcc.s	adrCd002D30	;64E8
	subq.b	#$01,$0035(a0)	;53280035
	rts	;4E75

adrCd002D4E:	lea	Player1_Data.l,a0	;41F90000F9D8
	bsr.s	adrCd002D32	;61DC
	lea	Player2_Data.l,a0	;41F90000FA3A
	bsr.s	adrCd002D32	;61D4
	sub.w	#$0010,d0	;04400010
	lea	adrEA0156F8.l,a0	;41F9000156F8
	move.w	-$0002(a0),d2	;3428FFFE
	bmi.s	adrCd002D30	;6BC2
	move.w	d5,-(sp)	;3F05
adrLp002D70:	movem.w	d0/d2,-(sp)	;48A7A000
	bsr.s	adrCd002D82	;610C
	movem.w	(sp)+,d0/d2	;4C9F0005
	dbra	d2,adrLp002D70	;51CAFFF4
	move.w	(sp)+,d5	;3A1F
	rts	;4E75

adrCd002D82:	moveq	#$03,d3	;7603
	moveq	#$00,d2	;7400
adrLp002D86:	move.b	$00(a0,d3.w),d5	;1A303000
	bmi.s	adrCd002D9C	;6B10
	cmp.b	d5,d0	;B005
	bcs.s	adrCd002D98	;6508
	bne.s	adrCd002D9C	;660A
	clr.b	$00(a0,d3.w)	;42303000
	moveq	#$01,d2	;7401
adrCd002D98:	subq.b	#$01,$00(a0,d3.w)	;53303000
adrCd002D9C:	dbra	d3,adrLp002D86	;51CBFFE8
	tst.w	d2	;4A42
	beq.s	adrCd002DBE	;671A
	lea	UnpackedMonsters.l,a2	;45F900014EE6
	asl.w	#$04,d0	;E940
	tst.b	$0D(a2,d0.w)	;4A32000D
	bmi.s	adrCd002DBE	;6B0C
	moveq	#$03,d3	;7603
adrLp002DB4:	tst.b	$00(a0,d3.w)	;4A303000
	bpl.s	adrCd002DC2	;6A08
	dbra	d3,adrLp002DB4	;51CBFFF8
adrCd002DBE:	addq.w	#$04,a0	;5848
	rts	;4E75

adrCd002DC2:	bset	#$07,$01(a6,d4.w)	;08F600074001
	move.b	$00(a0,d3.w),d3	;16303000
	asl.w	#$04,d3	;E943
	cmp.w	d0,d3	;B640
	bcs.s	adrCd002DD6	;6504
	add.w	#$0010,d3	;06430010
adrCd002DD6:	lea	$00(a2,d3.w),a3	;47F23000
	lea	$00(a2,d0.w),a2	;45F20000
	move.b	$0000(a2),$0000(a3)	;176A00000000
	move.b	$0001(a2),$0001(a3)	;176A00010001
	move.b	$0004(a2),$0004(a3)	;176A00040004
	move.b	$0002(a2),$0002(a3)	;176A00020002
	move.b	$000D(a2),$000D(a3)	;176A000D000D
	move.b	#$FF,$000D(a2)	;157C00FF000D
	move.b	#$FF,$0000(a2)	;157C00FF0000
	bra.s	adrCd002DBE	;60B4

adrCd002E0A:	cmp.b	#$02,$0015(a5)	;0C2D00020015
	bne.s	adrCd002E20	;660E
	bsr	adrCd0072D0	;610044BC
	tst.b	$0017(a4)	;4A2C0017
	bmi.s	adrCd002E20	;6B04
	bsr	adrCd0073BC	;6100459E
adrCd002E20:	bsr	adrCd0092A6	;61006484
	bsr	adrCd0030F4	;610002CE
	move.b	#$FF,$0034(a5)	;1B7C00FF0034
	moveq	#$03,d7	;7E03
adrLp002E30:	moveq	#$00,d0	;7000
	move.b	$18(a5,d7.w),d0	;10357018
	move.w	d0,d3	;3600
	and.w	#$000F,d3	;0243000F
	and.w	#$00E0,d0	;024000E0
	beq.s	adrCd002E6E	;672C
	tst.b	$0050(a5)	;4A2D0050
	beq.s	adrCd002E7A	;6732
	cmp.b	#$20,d0	;0C000020
	bne.s	adrCd002E7A	;662C
	move.w	d3,d0	;3003
	move.w	d7,-(sp)	;3F07
	bsr	adrCd0072D4	;61004480
	moveq	#$1A,d4	;781A
	move.w	#$FFFF,adrW_00173C.l	;33FCFFFF0000173C
	and.b	#$F1,$001D(a4)	;022C00F1001D
	bsr	adrCd00173E	;6100E8D6
	move.w	(sp)+,d7	;3E1F
	bra.s	adrCd002E7A	;600C

adrCd002E6E:	move.w	d3,d0	;3003
	bsr	adrCd0072D4	;61004462
	move.w	d7,-(sp)	;3F07
	bsr.s	adrCd002EA8	;6130
	move.w	(sp)+,d7	;3E1F
adrCd002E7A:	dbra	d7,adrLp002E30	;51CFFFB4
	rts	;4E75

adrCd002E80:	move.b	d0,d1	;1200
	bmi.s	adrCd002E90	;6B0C
	and.w	#$0007,d1	;02410007
	subq.b	#$01,d0	;5300
	subq.w	#$01,d1	;5341
	bcc.s	adrCd002E90	;6402
	moveq	#$00,d0	;7000
adrCd002E90:	rts	;4E75

adrCd002E92:	move.b	$001F(a4),d0	;102C001F
	bsr.s	adrCd002E80	;61E8
	move.b	$001F(a4),d1	;122C001F
	and.b	#$20,d1	;02010020
	or.b	d1,d0	;8001
	move.b	d0,$001F(a4)	;1940001F
	rts	;4E75

adrCd002EA8:	bsr.s	adrCd002E92	;61E8
	move.b	$001D(a4),d0	;102C001D
	move.b	d0,d1	;1200
	and.w	#$000F,d1	;0241000F
	subq.w	#$01,d1	;5341
	bcs.s	adrCd002EBE	;6506
	subq.b	#$01,$001D(a4)	;532C001D
adrCd002EBC:	rts	;4E75

adrCd002EBE:	move.b	d0,d1	;1200
	lsr.b	#$04,d1	;E809
	or.b	d0,d1	;8200
	move.b	d1,$001D(a4)	;1941001D
	moveq	#$04,d4	;7804
	bclr	d7,$003C(a5)	;0FAD003C
	bne	adrCd002F52	;66000082
	move.b	(a5),d0	;1015
	and.w	#$000A,d0	;0240000A
	beq.s	adrCd002EBC	;67E2
	tst.w	d7	;4A47
	bne.s	adrCd002EE6	;6608
	cmp.b	#$02,$0015(a5)	;0C2D00020015
	bcc.s	adrCd002EBC	;64D6
adrCd002EE6:	move.w	d3,d0	;3003
	move.b	d3,adrB_00F99A.l	;13C30000F99A
	bsr	adrCd0072D4	;610043E4
	tst.b	$0017(a4)	;4A2C0017
	bpl	adrCd0030DA	;6A0001E2
	move.w	d3,d0	;3003
	bsr	adrCd004826	;61001928
	movem.w	d2/d3/d7,-(sp)	;48A73100
	bsr	adrCd002F72	;6100006C
	bmi.s	adrCd002F10	;6B06
	bsr	adrCd003AD2	;61000BC6
	bcs.s	adrCd002F22	;6512
adrCd002F10:	movem.w	(sp)+,d2/d3/d7	;4C9F008C
adrCd002F14:	tst.w	d7	;4A47
	bne	adrCd003056	;6600013E
	and.b	#$01,(a5)	;02150001
	bra	adrCd003056	;60000136

adrCd002F22:	movem.w	(sp)+,d2/d3/d7	;4C9F008C
	tst.b	d0	;4A00
	bmi.s	adrCd002F36	;6B0C
	cmp.b	#$10,d0	;0C000010
	bcs.s	adrCd002F36	;6506
	tst.b	$000B(a1)	;4A29000B
	bmi.s	adrCd002F14	;6BDE
adrCd002F36:	cmp.w	#$0002,d2	;0C420002
	bcc	adrCd003056	;6400011A
	movem.l	a4/a5,-(sp)	;48E7000C
	bsr	adrCd002FC8	;61000084
	movem.l	(sp)+,a4/a5	;4CDF3000
	move.w	adrEA014EC4.l,d5	;3A3900014EC4
	moveq	#$00,d4	;7800
adrCd002F52:	move.w	$0004(sp),d7	;3E2F0004
	movem.w	d4-d7,-(sp)	;48A70F00
	tst.w	d7	;4A47
	bne.s	adrCd002F66	;6608
	bsr	adrCd008F3E	;61005FDE
	movem.w	(sp),d4-d7	;4C9700F0
adrCd002F66:	bsr	adrCd006BE6	;61003C7E
	movem.w	(sp)+,d4-d7	;4C9F00F0
	bra	adrCd006D14	;60003DA4

adrCd002F72:	bsr	adrCd009268	;610062F4
	move.w	$00(a6,d0.w),d1	;32360000
	and.w	#$0007,d1	;02410007
	subq.w	#$02,d1	;5541
	bne.s	adrCd002F8E	;660C
	move.w	$0020(a5),d1	;322D0020
	add.w	d1,d1	;D241
	btst	d1,$00(a6,d0.w)	;03360000
	bne.s	adrCd002FC4	;6636
adrCd002F8E:	bsr	adrCd00924C	;610062BC
	cmp.w	adrW_00F9CE.l,d7	;BE790000F9CE
	bcc.s	adrCd002FC4	;642A
	swap	d7	;4847
	cmp.w	adrW_00F9CC.l,d7	;BE790000F9CC
	bcc.s	adrCd002FC4	;6420
	move.w	$00(a6,d0.w),d1	;32360000
	and.w	#$0007,d1	;02410007
	subq.w	#$02,d1	;5541
	bne.s	adrCd002FC0	;6610
	move.w	$0020(a5),d1	;322D0020
	eor.w	#$0002,d1	;0A410002
	add.w	d1,d1	;D241
	btst	d1,$00(a6,d0.w)	;03360000
	bne.s	adrCd002FC4	;6604
adrCd002FC0:	moveq	#$00,d1	;7200
	rts	;4E75

adrCd002FC4:	moveq	#-$01,d1	;72FF
	rts	;4E75

adrCd002FC8:	clr.w	adrW_0070C6.l	;4279000070C6
	move.w	$0020(a5),d1	;322D0020
	tst.b	d0	;4A00
	bpl.s	adrCd002FEA	;6A14
	sub.w	$0020(a1),d1	;92690020
	move.w	d1,adrW_006EEA.l	;33C100006EEA
	move.w	$0020(a5),d0	;302D0020
	bsr	adrCd006C58	;61003C72
	bra.s	adrCd003006	;601C

adrCd002FEA:	move.b	$0002(a1),d2	;14290002
	cmp.b	#$10,d0	;0C000010
	bcc.s	adrCd002FF8	;6404
	move.b	$001C(a1),d2	;1429001C
adrCd002FF8:	and.w	#$0003,d2	;02420003
	sub.w	d2,d1	;9242
	move.w	d1,adrW_006EEA.l	;33C100006EEA
	move.w	d0,d1	;3200
adrCd003006:	move.w	d1,d0	;3001
	bsr	adrCd0009DA	;6100D9D0
	exg	d0,d1	;C141
	not.w	d0	;4640
	and.w	#$0003,d0	;02400003
	beq.s	adrCd003032	;671C
	move.w	#$FFFF,adrW_006EEA.l	;33FCFFFF00006EEA
	move.b	$0015(a4),d0	;102C0015
	and.w	#$0007,d0	;02400007
	subq.b	#$02,d0	;5500
	bne.s	adrCd003032	;6608
	move.b	$0025(a4),adrB_003054.l	;13EC002500003054
adrCd003032:	move.b	#$07,$001F(a4)	;197C0007001F
	move.l	a4,-(sp)	;2F0C
	move.w	d1,-(sp)	;3F01
	bsr	adrCd006E2E	;61003DF0
	clr.w	adrB_003054.l	;427900003054
	move.w	(sp)+,d0	;301F
	move.w	$0000(a6),d5	;3A2E0000
	bsr	adrCd00278A	;6100F73C
	move.l	(sp)+,a4	;285F
	rts	;4E75

adrB_003054:	dc.b	$00	;00
	dc.b	$00	;00

adrCd003056:	move.w	d3,d1	;3203
	bsr	adrCd0009C8	;6100D96E
	moveq	#-$01,d4	;78FF
	moveq	#-$01,d5	;7AFF
	moveq	#$00,d2	;7400
	moveq	#$01,d3	;7601
adrLp003064:	bsr.s	adrCd0030B6	;6150
	dbra	d3,adrLp003064	;51CBFFFC
	move.w	d4,d3	;3604
	or.w	d5,d3	;8645
	tst.w	d3	;4A43
	bmi.s	adrCd0030DA	;6B68
	move.b	$30(a4,d4.w),d2	;14344030
	subq.b	#$01,$3B(a4,d2.w)	;5334203B
	bcs.s	adrCd0030AC	;6530
	subq.b	#$03,d2	;5702
	move.w	#$0088,d4	;383C0088
	add.w	d2,d4	;D842
	add.b	d2,d0	;D002
	move.b	$30(a4,d5.w),d5	;1A345030
	sub.w	#$005C,d5	;0445005C
	move.b	adrB_0030A6(pc,d5.w),d2	;143B5016
	lsr.w	d2,d0	;E468
	add.b	adrB_0030A9(pc,d5.w),d0	;D03B5013
	add.w	d0,d0	;D040
	move.w	d0,d7	;3E00
	bsr	adrCd005D80	;61002CE2
	moveq	#$01,d4	;7801
	bra	adrCd002F52	;6000FEAE

adrB_0030A6:	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$01	;01
adrB_0030A9:	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01

adrCd0030AC:	clr.b	$30(a4,d4.w)	;42344030
	clr.b	$3B(a4,d2.w)	;4234203B
	rts	;4E75

adrCd0030B6:	move.b	$30(a4,d3.w),d2	;14343030
	cmp.b	#$05,d2	;0C020005
	bcc.s	adrCd0030CA	;640A
	cmp.b	#$03,d2	;0C020003
	bcs.s	adrCd0030C8	;6502
	move.w	d3,d4	;3803
adrCd0030C8:	rts	;4E75

adrCd0030CA:	cmp.b	#$5C,d2	;0C02005C
	bcs.s	adrCd0030C8	;65F8
	cmp.b	#$5F,d2	;0C02005F
	bcc.s	adrCd0030C8	;64F2
	move.w	d3,d5	;3A03
	rts	;4E75

adrCd0030DA:	tst.b	$0017(a4)	;4A2C0017
	bmi.s	adrCd0030FC	;6B1C
	bsr	adrCd00585E	;6100277C
	moveq	#$03,d4	;7803
	tst.b	$0017(a4)	;4A2C0017
	bmi	adrCd002F52	;6B00FE66
	addq.b	#$04,$000A(a4)	;582C000A
	rts	;4E75

adrCd0030F4:	cmp.w	#$0008,$0042(a5)	;0C6D00080042
	beq.s	adrCd0030FE	;6702
adrCd0030FC:	rts	;4E75

adrCd0030FE:	bsr	adrCd00498E	;6100188E
	and.b	#$3F,$0006(a4)	;022C003F0006
	subq.b	#$01,$0004(a4)	;532C0004
	bne.s	adrCd0030FC	;66EE
	tst.b	$0005(a4)	;4A2C0005
	bmi.s	adrCd0030FC	;6BE8
	move.b	$0002(a4),d0	;102C0002
	move.b	$0003(a4),$0002(a4)	;196C00030002
	move.b	d0,$0003(a4)	;19400003
	moveq	#$00,d0	;7000
	move.b	$0000(a4),d0	;102C0000
	cmp.b	#$09,d0	;0C000009
	bne.s	adrCd003168	;663A
	movem.l	d0/a4/a5,-(sp)	;48E7800C
	bsr	adrCd003AD2	;6100099E
	bcc.s	adrCd003164	;642C
	tst.b	d0	;4A00
	bmi.s	adrCd003164	;6B28
	moveq	#$00,d1	;7200
	move.b	$0006(a4),d1		;122C0006
	sub.w	#$000A,d1		;0441000A
	neg.w	d1			;4441
	add.w	d1,d1			;D241
	move.w	d1,adrW_0025A8.l	;33C1000025A8
	bsr	adrCd002412		;6100F2C0
	btst	#$05,$03(a1,d4.w)	;083100054003
	beq.s	adrCd003164		;6708
	movem.l	(sp)+,d0/a4/a5		;4CDF3001
	bra	adrJC0039F2		;60000890

adrCd003164:	movem.l	(sp)+,d0/a4/a5	;4CDF3001
adrCd003168:	tst.b	$0006(a4)	;4A2C0006
	beq	adrCd003A3E	;670008D0
	lea	adrJB00320C.l,a0	;41F90000320C
	add.w	d0,d0	;D040
	add.w	adrJT0031D6(pc,d0.w),a0	;D0FB005C
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
	cmp.b	#$10,d0	;0C000010
	bcs.s	adrCd0031C0	;6512
	bsr	adrCd0072D4	;61004124
	and.b	#$F0,$001D(a4)	;022C00F0001D
	or.b	#$0A,$001D(a4)	;002C000A001D
adrJC0031BE:	rts	;4E75

adrCd0031C0:	lea	adrEA014DE6.l,a4	;49F900014DE6
	asl.w	#$04,d0	;E940
	and.b	#$F0,$0003(a4)	;022C00F00003
	or.b	#$0A,$0003(a4)	;002C000A0003
	rts	;4E75

adrJT0031D6:	dc.w	adrJB00320C-adrJB00320C	;0000
	dc.w	adrJC0031BE-adrJB00320C	;FFB2
	dc.w	adrJC0031BE-adrJB00320C	;FFB2
	dc.w	adrJC00331A-adrJB00320C	;010E
	dc.w	adrJC0031BE-adrJB00320C	;FFB2
	dc.w	adrJC0031BE-adrJB00320C	;FFB2
	dc.w	adrJC00331A-adrJB00320C	;010E
	dc.w	adrJC00331A-adrJB00320C	;010E
	dc.w	adrJC00331A-adrJB00320C	;010E
	dc.w	adrJC003320-adrJB00320C	;0114
	dc.w	CharacterName-adrJB00320C	;0126
	dc.w	adrJC00337E-adrJB00320C	;0172
	dc.w	CharacterName-adrJB00320C	;0126
	dc.w	adrJC00337E-adrJB00320C	;0172
	dc.w	adrJC0033D8-adrJB00320C	;01CC
	dc.w	adrJC00331A-adrJB00320C	;010E
	dc.w	adrJC003422-adrJB00320C	;0216
	dc.w	adrJC0033BA-adrJB00320C	;01AE
	dc.w	adrJC0034B4-adrJB00320C	;02A8
	dc.w	adrJC0035C8-adrJB00320C	;03BC
	dc.w	adrJC0035F4-adrJB00320C	;03E8
	dc.w	adrJC003668-adrJB00320C	;045C
	dc.w	adrJC003722-adrJB00320C	;0516
	dc.w	adrJC00373E-adrJB00320C	;0532
	dc.w	adrJC003758-adrJB00320C	;054C
	dc.w	adrJC00331A-adrJB00320C	;010E
	dc.w	adrJC003776-adrJB00320C	;056A

adrJB00320C:
	tst.b	$0007(a4)	;4A2C0007
	bmi	adrJC00331A	;6B000108
	cmp.b	#$10,d0	;0C000010
	bcs.s	adrCd003278	;655E
	cmp.b	#$07,$0006(a4)	;0C2C00070006
	bcs	adrJC00331A	;650000F8
adrCd003224:
	cmp.b	#$0C,$0006(a4)	;0C2C000C0006
	bcs.s	adrCd003268	;653C
	lea	adrEA014DE6.l,a0	;41F900014DE6
	move.w	d0,d1	;3200
	asl.w	#$04,d1	;E941
	add.w	d1,a0	;D0C1
	cmp.b	#$15,$000B(a0)	;0C280015000B
	bcs.s	adrCd003250	;6510
	cmp.b	#$1C,$000B(a0)	;0C28001C000B
	bcs.s	adrCd003268	;6520
	cmp.b	#$64,$000B(a0)	;0C280064000B
	bcc.s	adrCd003268	;6418
adrCd003250:	bsr	adrCd0047E8	;61001596
	tst.b	$18(a5,d1.w)	;4A351018
	bpl.s	adrCd003270	;6A16
	bsr	adrCd000A6C	;6100D810
	tst.w	d0	;4A40
	bmi.s	adrCd003268	;6B06
	move.b	d0,$0003(a4)	;19400003
	bra.s	adrCd0032AE	;6046

adrCd003268:	lea	adrEA003895.l,a6	;4DF900003895
	bra.s	adrCd0032A8	;6038

adrCd003270:	lea	adrEA003833.l,a6	;4DF900003833
	bra.s	adrCd0032A8	;6030

adrCd003278:	move.l	a5,-(sp)	;2F0D
	bsr	adrCd0047FA	;6100157E
	move.l	a5,a1	;224D
	move.l	(sp)+,a5	;2A5F
	tst.w	d1	;4A41
	bmi.s	adrCd003292	;6B0C
	cmp.l	a1,a5	;BBC9
	bne.s	adrCd003224	;669A
	move.b	#$FF,$0050(a5)	;1B7C00FF0050
	rts	;4E75

adrCd003292:	cmp.b	#$0A,$0006(a4)	;0C2C000A0006
	bcc.s	adrCd0032AE	;6414
	cmp.b	#$05,$0006(a4)	;0C2C00050006
	bcs.s	adrJC00331A	;6578
	lea	adrEA00387A.l,a6	;4DF90000387A
adrCd0032A8:	jmp	adrCd00DA18.l	;4EF90000DA18

adrCd0032AE:	bsr	adrCd0047E8	;61001538
	tst.b	$18(a5,d1.w)	;4A351018
	bpl.s	adrCd003270	;6AB8
	lea	adrEA00D3DA.l,a6	;4DF90000D3DA
	move.w	#$45FF,(a6)	;3CBC45FF
	jsr	adrCd00E2EA.l	;4EB90000E2EA
	move.b	$0003(a4),d0	;102C0003
	and.w	#$000F,d0	;0240000F
	move.w	d0,d2	;3400
	bsr	adrCd0072D4	;61004000
	cmp.b	#$10,$0001(a4)	;0C2C00100001
	bcc.s	adrCd0032F4	;6416
	moveq	#$00,d7	;7E00
	move.b	$001A(a4),d7	;1E2C001A
	swap	d7	;4847
	move.b	$001B(a4),d7	;1E2C001B
	bsr	CoordToMap	;61005F80
	bclr	#$07,$01(a6,d0.w)	;08B600070001
adrCd0032F4:	move.b	#$FF,$001A(a4)	;197C00FF001A
	bsr	adrCd0047E8	;610014EC
	move.b	d2,$18(a5,d1.w)	;1B821018
	moveq	#$03,d0	;7003
adrLp003304:	tst.b	$26(a5,d0.w)	;4A350026
	bmi.s	adrCd00330E	;6B04
	dbra	d0,adrLp003304	;51C8FFF8
adrCd00330E:	move.b	d2,$26(a5,d0.w)	;1B820026
	bsr	adrCd003A3E	;6100072A
	bra	adrCd008FCA	;60005CB2

adrJC00331A:	moveq	#$19,d1	;7219
adrCd00331C:	bra	adrCd003C34	;60000916

adrJC003320:	moveq	#$09,d1	;7209
	tst.b	$0007(a4)	;4A2C0007
	bmi.s	adrCd00331C	;6BF4
	cmp.b	#$0A,$0006(a4)	;0C2C000A0006
	bcs.s	adrCd00331C	;65EC
	bra.s	adrJC00331A	;60E8

CharacterName:
	moveq	#$0C,d1	;720C
	cmp.b	#$10,d0	;0C000010
	bcs.s	adrCd00331C	;65E2
	cmp.b	#$05,$0006(a4)	;0C2C00050006
	bcs.s	adrJC00331A	;65D8
	lea	adrEA014DE6.l,a1	;43F900014DE6
	asl.w	#$04,d0	;E940
	add.w	d0,a1	;D2C0

; ** insert naming code here

	lea	adrEA0044C2.l,a6	;4DF9000044C2
	lea	adrEA0038DD.l,a0	;41F9000038DD
adrCd003358:
	move.b	(a0)+,d0	;1018
	bmi.s	adrCd003360	;6B04
	move.b	d0,(a6)+	;1CC0
	bra.s	adrCd003358	;60F8

adrCd003360:
	moveq	#$00,d0	;7000
	move.b	$000B(a1),d0	;1029000B
	move.b	$0006(a1),d2	;14290006
	move.b	$000A(a1),d1	;1229000A
	jsr	adrCd00E1C4.l	;4EB90000E1C4
	lea	adrEA0044C2.l,a6	;4DF9000044C2
	bra	adrCd0032A8	;6000FF2C

adrJC00337E:	moveq	#$0D,d1	;720D
	cmp.b	#$10,d0	;0C000010
	bcs.s	adrCd00331C	;6596
	lea	adrEA014DE6.l,a1	;43F900014DE6
	asl.w	#$04,d0	;E940
	move.b	$0B(a1,d0.w),d1	;1231000B
	cmp.b	#$64,d1	;0C010064
	bcc.s	adrJC00331A	;6482
	bsr	adrCd0009E0	;6100D646
	lea	adrEA004505.l,a6	;4DF900004505
	move.b	#$9E,$0006(a6)	;1D7C009E0006
	tst.w	d1	;4A41
	beq.s	adrCd0033B4	;6708
	add.b	#$5B,d1	;0601005B
	move.b	d1,$0006(a6)	;1D410006
adrCd0033B4:	jmp	adrCd00E2EA.l	;4EF90000E2EA

adrJC0033BA:	moveq	#-$02,d0	;70FE
	cmp.b	#$0A,$0006(a4)	;0C2C000A0006
	bcs.s	adrCd0033C8	;6504
	bra	adrJC0040A4	;60000CDE

adrCd0033C8:	bsr	RandomGen_BytewithOffset	;61002E16
	moveq	#$18,d1	;7218
	tst.b	d0	;4A00
	bmi	adrCd00331C	;6B00FF4A
	bra	adrJC00331A	;6000FF44

adrJC0033D8:	cmp.b	#$10,d0	;0C000010
	bcs.s	adrCd0033F4	;6516
	lea	adrEA014DE6.l,a1	;43F900014DE6
	asl.w	#$04,d0	;E940
	move.b	$0B(a1,d0.w),d0	;1031000B
	cmp.b	#$64,d0	;0C000064
	bcc	adrJC00331A	;6400FF2A
	bra.s	adrCd003400	;600C

adrCd0033F4:	asl.w	#$06,d0	;ED40
	lea	CharacterStats.l,a1	;43F90000F586
	move.b	$01(a1,d0.w),d0	;10310001
adrCd003400:	bsr	adrCd0075DC	;610041DA
	lea	Quote_0.l,a6	;4DF9000037A4
	add.w	d0,d0	;D040
	add.w	QuoteOffsets(pc,d0.w),a6	;DCFB000C
	move.b	#$19,$0001(a4)	;197C00190001
	bra	adrCd0032A8	;6000FE90

QuoteOffsets:	dc.w	Quote_0-Quote_0	;0000
	dc.w	Quote_1-Quote_0	;0025
	dc.w	Quote_2-Quote_0	;0043
	dc.w	Quote_3-Quote_0	;006A

adrJC003422:	cmp.b	#$10,d0	;0C000010
	bcs.s	adrCd003436	;650E
	lea	adrEA014DE6.l,a1	;43F900014DE6
	asl.w	#$04,d0	;E940
	move.b	$0C(a1,d0.w),d0	;1031000C
	bra.s	adrCd003442	;600C

adrCd003436:	asl.w	#$06,d0	;ED40
	lea	CharacterStats.l,a1	;43F90000F586
	move.b	$30(a1,d0.w),d0	;10310030
adrCd003442:	lea	adrEA0044C2.l,a6	;4DF9000044C2
	move.b	#$33,(a6)	;1CBC0033
	move.b	#$5F,$0001(a6)	;1D7C005F0001
	move.b	#$FE,$0002(a6)	;1D7C00FE0002
	moveq	#$03,d2	;7403
	moveq	#$00,d1	;7200
	move.b	d0,d1	;1200
	bne.s	adrCd00346A	;660A
	move.b	#$44,$00(a6,d2.w)	;1DBC00442000
	addq.w	#$01,d2	;5242
	bra.s	adrCd00348C	;6022

adrCd00346A:	lea	ObjectDefinitionsTable+$2.l,a0	;41F90000EF4C
	add.w	d1,d1	;D241
	add.w	d1,d1	;D241
	add.w	d1,a0	;D0C1
	move.b	(a0)+,$00(a6,d2.w)	;1D982000
	addq.w	#$01,d2	;5242
	move.b	(a0),d0	;1010
	bmi.s	adrCd00348C	;6B0C
	move.b	#$FE,$00(a6,d2.w)	;1DBC00FE2000
	move.b	d0,$01(a6,d2.w)	;1D802001
	addq.w	#$02,d2	;5442
adrCd00348C:	move.b	#$35,$00(a6,d2.w)	;1DBC00352000
	bsr	RandomGen_BytewithOffset	;61002D4C
	and.w	#$0007,d0	;02400007
	add.w	#$007C,d0	;0640007C
	move.b	d0,$01(a6,d2.w)	;1D802001
	move.b	#$FF,$02(a6,d2.w)	;1DBC00FF2002
	move.b	#$19,$0001(a4)	;197C00190001
	jmp	adrCd00E2EA.l	;4EF90000E2EA

adrJC0034B4:	cmp.b	#$10,d0	;0C000010
	bcs	adrJC00331A	;6500FE60
	move.w	$002E(a5),d1	;322D002E
	cmp.b	$000A(a4),d1	;B22C000A
	bne	adrCd00367C	;660001B6
	tst.w	d1	;4A41
	beq.s	adrCd0034F6	;672A
	cmp.b	#$5F,d1	;0C01005F
	beq.s	adrCd0034DA	;6708
	cmp.b	#$40,d1	;0C010040
	bcc	adrCd003712	;6400023A
adrCd0034DA:	moveq	#$00,d2	;7400
	move.b	$0008(a4),d2	;142C0008
	lea	adrJC003500.l,a0	;41F900003500
	add.w	d2,d2	;D442
	add.w	adrJT0034EE(pc,d2.w),a0	;D0FB2004
	jmp	(a0)	;4ED0

adrJT0034EE:
	dc.w	adrJC003500-adrJC003500	;0000
	dc.w	adrJC003526-adrJC003500	;0026
	dc.w	adrJC003588-adrJC003500	;0088
	dc.w	adrJC003500-adrJC003500	;0000

adrCd0034F6:	move.b	#$08,$0000(a4)	;197C00080000
	bra	adrJC00331A	;6000FE1C

adrJC003500:	cmp.b	#$5F,d1	;0C01005F
	beq.s	adrCd00351A	;6714
	sub.w	#$0014,d1	;04410014
	bcs.s	adrCd00351A	;650E
	lea	adrEA0038E9.l,a0	;41F9000038E9
	tst.b	$00(a0,d1.w)	;4A301000
	bmi	adrCd003712	;6B0001FA
adrCd00351A:	clr.l	$002C(a5)	;42AD002C
adrCd00351E:	bsr	adrCd003D1E	;610007FE
	bra	adrCd007900	;600043DC

adrJC003526:	move.w	$002C(a5),d4	;382D002C
	cmp.b	$0009(a4),d4	;B82C0009
	bcs	adrCd00367C	;6500014C
	bsr	adrCd003936	;61000402
	move.w	$002C(a5),d4	;382D002C
	move.w	d0,d3	;3600
	moveq	#$01,d2	;7401
	sub.b	#$14,d3	;04030014
	bcs.s	adrCd003558	;6514
	cmp.b	#$5F,d0	;0C00005F
	bne.s	adrCd00354E	;6604
	moveq	#$5A,d2	;745A
	bra.s	adrCd003558	;600A

adrCd00354E:	lea	adrEA0038E9.l,a1	;43F9000038E9
	move.b	$00(a1,d3.w),d2	;14313000
adrCd003558:	moveq	#$6E,d3	;766E
	sub.b	$0006(a4),d3	;962C0006
	cmp.b	#$50,d3	;B63C0050
	bcc.s	adrCd003566	;6402
	moveq	#$50,d3	;7650
adrCd003566:	mulu	d3,d2	;C4C3
	divu	#$0064,d2	;84FC0064
	cmp.b	d2,d4	;B802
	bcs.s	adrCd003582	;6512
	move.b	#$06,$0C(a0,d1.w)	;11BC0006100C
adrCd003576:	move.b	d0,$002F(a5)	;1B40002F
	move.w	#$0001,$002C(a5)	;3B7C0001002C
	bra.s	adrCd00351E	;609C

adrCd003582:	moveq	#$07,d1	;7207
	bra	adrCd00331C	;6000FD96

adrJC003588:	lea	adrEA0038E9.l,a1	;43F9000038E9
	moveq	#$02,d2	;7402
	sub.w	#$0014,d1	;04410014
	bcs.s	adrCd0035A8	;6512
	cmp.b	#$4B,d1	;0C01004B
	bne.s	adrCd0035A0	;6604
	moveq	#$5A,d2	;745A
	bra.s	adrCd0035A8	;6008

adrCd0035A0:	move.b	$00(a1,d1.w),d2	;14311000
	bmi	adrCd00370E	;6B000168
adrCd0035A8:	bsr	adrCd003936	;6100038C
	move.w	d0,d4	;3800
	moveq	#$02,d3	;7602
	sub.w	#$0014,d4	;04440014
	bcs.s	adrCd0035BA	;6504
	move.b	$00(a1,d4.w),d3	;16314000
adrCd0035BA:	cmp.b	d3,d2	;B403
	bcs	adrCd003654	;65000096
	move.b	$002F(a5),$0C(a0,d1.w)	;11AD002F100C
	bra.s	adrCd003576	;60AE

adrJC0035C8:	cmp.b	#$10,d0	;0C000010
	bcs	adrJC00331A	;6500FD4C
adrCd0035D0:	bsr	adrCd003936	;61000364
	lea	$00(a0,d1.w),a1	;43F01000
	cmp.b	#$15,$000B(a1)	;0C290015000B
	bcs.s	adrCd0035F0	;6510
	cmp.b	#$17,$000B(a1)	;0C290017000B
	bcc.s	adrCd0035F0	;6408
	bsr	adrCd003982	;61000398
	move.b	$000C(a1),d0	;1029000C
adrCd0035F0:	bra	adrCd00405E	;60000A6C

adrJC0035F4:	cmp.b	#$10,d0	;0C000010
	bcs	adrJC00331A	;6500FD20
	move.w	$002E(a5),d1	;322D002E
	cmp.b	$000A(a4),d1	;B22C000A
	bne	adrCd00367C	;66000076
	tst.w	d1	;4A41
	beq.s	adrCd0035D0	;67C4
	lea	adrEA0038E9.l,a1	;43F9000038E9
	cmp.b	#$5F,d1	;0C01005F
	bne.s	adrCd00361C	;6604
	moveq	#$5A,d2	;745A
	bra.s	adrCd003634	;6018

adrCd00361C:	cmp.b	#$40,d1	;0C010040
	bcc	adrCd003712	;640000F0
	moveq	#$02,d2	;7402
	sub.w	#$0014,d1	;04410014
	bcs.s	adrCd003634	;6508
	move.b	$00(a1,d1.w),d2	;14311000
	bmi	adrCd00370E	;6B0000DC
adrCd003634:	bsr	adrCd003936	;61000300
	move.w	d0,d1	;3200
	moveq	#$02,d3	;7602
	sub.w	#$0014,d1	;04410014
	bcs.s	adrCd003646	;6504
	move.b	$00(a1,d1.w),d3	;16311000
adrCd003646:	cmp.b	d3,d2	;B403
	bcs.s	adrCd003654	;650A
	move.b	#$12,$0001(a4)	;197C00120001
	bra	adrCd003FCA	;60000978

adrCd003654:	lea	adrEA0038C9.l,a6	;4DF9000038C9
	jmp	adrCd00E2EA.l	;4EF90000E2EA

adrCd003660:	clr.b	$0008(a4)	;422C0008
	bra	adrJC00331A	;6000FCB4

adrJC003668:	cmp.b	#$10,d0	;0C000010
	bcs	adrJC00331A	;6500FCAC
	move.w	$002E(a5),d0	;302D002E
	beq.s	adrCd003660	;67EA
	cmp.b	$000A(a4),d0	;B02C000A
	beq.s	adrCd003692	;6716
adrCd00367C:	subq.b	#$05,$0006(a4)	;5B2C0006
	bpl.s	adrCd003686	;6A04
	clr.b	$0006(a4)	;422C0006
adrCd003686:	lea	adrEA003845.l,a6	;4DF900003845
	jmp	adrCd00DA18.l	;4EF90000DA18

adrCd003692:	cmp.b	#$5F,d0	;0C00005F
	bne.s	adrCd00369C	;6604
	moveq	#$5A,d0	;705A
	bra.s	adrCd0036BA	;601E

adrCd00369C:	cmp.b	#$40,d0	;0C000040
	bcc.s	adrCd003712	;6470
	sub.b	#$14,d0	;04000014
	bcc.s	adrCd0036AE	;6406
	moveq	#$01,d0	;7001
	bra	adrCd003946	;6000029A

adrCd0036AE:	lea	adrEA0038E9.l,a0	;41F9000038E9
	move.b	$00(a0,d0.w),d0	;10300000
	bmi.s	adrCd00370E	;6B54
adrCd0036BA:	moveq	#$00,d2	;7400
	move.b	$0009(a4),d2	;142C0009
	bne.s	adrCd0036E2	;6620
	moveq	#$00,d1	;7200
	move.b	$0006(a4),d1	;122C0006
	sub.w	#$000A,d1	;0441000A
	add.w	#$003C,d1	;0641003C
	cmp.w	#$0064,d1	;B27C0064
	bcc	adrCd003946	;64000270
	mulu	d1,d0	;C0C1
	divu	#$0064,d0	;80FC0064
	bra	adrCd003946	;60000266

adrCd0036E2:	bpl.s	adrCd0036F8	;6A14
	clr.b	$0008(a4)	;422C0008
	lea	adrEA0038AB.l,a6	;4DF9000038AB
	move.b	#$19,$0001(a4)	;197C00190001
	bra	adrCd0032A8	;6000FBB2

adrCd0036F8:	cmp.b	#$0F,$0006(a4)	;0C2C000F0006
	bcs.s	adrCd003738	;6538
	sub.b	d2,d0	;9002
	lsr.b	#$01,d0	;E208
	add.b	d2,d0	;D002
	bset	#$07,d0	;08C00007
	bra	adrCd003946	;6000023A

adrCd00370E:	clr.b	$0008(a4)	;422C0008
adrCd003712:	move.b	#$07,$0001(a4)	;197C00070001
	lea	adrEA00385E.l,a6	;4DF90000385E
	bra	adrCd0032A8	;6000FB88

adrJC003722:	moveq	#$16,d1	;7216
	cmp.b	#$0A,$0006(a4)	;0C2C000A0006
	bcc	adrCd00331C	;6400FBF0
	cmp.b	#$05,$0006(a4)	;0C2C00050006
	bcc	adrJC00331A	;6400FBE4
adrCd003738:	moveq	#$17,d1	;7217
	bra	adrCd00331C	;6000FBE0

adrJC00373E:	moveq	#$17,d1	;7217
	cmp.b	#$05,$0006(a4)	;0C2C00050006
	bcc	adrCd00331C	;6400FBD4
	tst.b	$0007(a4)	;4A2C0007
	bpl	adrJC00331A	;6A00FBCA
	moveq	#$09,d1	;7209
	bra	adrCd00331C	;6000FBC6

adrJC003758:	cmp.b	#$0A,$0006(a4)	;0C2C000A0006
	bcc.s	adrJC003722	;64C2
	moveq	#$18,d1	;7218
	cmp.b	#$07,$0006(a4)	;0C2C00070006
	bcc	adrCd00331C	;6400FBB2
	tst.b	$0007(a4)	;4A2C0007
	bmi.s	adrJC00373E	;6BCC
	bra	adrJC00331A	;6000FBA6

adrJC003776:	cmp.b	#$02,$0006(a4)	;0C2C00020006
	bcs	adrJC003320	;6500FBA2
	cmp.b	#$05,$0006(a4)	;0C2C00050006
	bcs.s	adrJC00373E	;65B6
	cmp.b	#$08,$0006(a4)	;0C2C00080006
	bcs	adrJC00331A	;6500FB8A
	bsr	RandomGen_BytewithOffset	;61002A4C
	moveq	#$0A,d1	;720A
	tst.b	d0	;4A00
	bmi	adrCd00331C	;6B00FB80
	moveq	#$0B,d1	;720B
	bra	adrCd00331C	;6000FB7A

Quote_0:	dc.b	'FLESH IS BUT ONE COIL OF THE SERPENT'	;464C45534820495320425554204F4E4520434F494C204F46205448452053455250454E54
	dc.b	$FF	;FF
Quote_1:	dc.b	'CHAOS IS THE ESSENCE OF BEING'	;4348414F532049532054484520455353454E4345204F46204245494E47
	dc.b	$FF	;FF
Quote_2:	dc.b	'THE MIGHT OF A DRAGON IS WITHOUT EQUAL'	;544845204D49474854204F46204120445241474F4E20495320574954484F555420455155414C
	dc.b	$FF	;FF
Quote_3:	dc.b	'THE POWER OF A LOON IS WITH THE MOON'	;54484520504F574552204F462041204C4F4F4E204953205749544820544845204D4F4F4E
	dc.b	$FF	;FF
adrEA003833:	dc.b	'THY PARTY IS FULL'	;5448592050415254592049532046554C4C
	dc.b	$FF	;FF
adrEA003845:	dc.b	'WOULDST THOU RIP ME OFF?'	;574F554C4453542054484F5520524950204D45204F46463F
	dc.b	$FF	;FF
adrEA00385E:	dc.b	'I NEVER TRUST THE UNNATURAL'	;49204E455645522054525553542054484520554E4E41545552414C
	dc.b	$FF	;FF
adrEA00387A:	dc.b	'KEEP TALKING AND WE''LL SEE'	;4B4545502054414C4B494E4720414E44205745274C4C20534545
	dc.b	$FF	;FF
adrEA003895:	dc.b	'I THINK NOT MY FRIEND'	;49205448494E4B204E4F54204D5920465249454E44
	dc.b	$FF	;FF
adrEA0038AB:	dc.b	'METHINKS THOU ART TOO GREEDY!'	;4D455448494E4B532054484F552041525420544F4F2047524545445921
	dc.b	$FF	;FF
adrEA0038C9:	dc.b	$1A	;1A
	dc.b	$19	;19
	dc.b	'a'	;61
	dc.b	$8D	;8D
	dc.b	$B1	;B1
	dc.b	'Q'	;51
	dc.b	$FF	;FF
adrEA0038D0:	dc.b	$CC	;CC
	dc.b	$1A	;1A
	dc.b	$1D	;1D
	dc.b	$FA	;FA
	dc.b	' '	;20
	dc.b	$FA	;FA
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
adrEA0038DD:	dc.b	'MY NAME IS '	;4D59204E414D4520495320
	dc.b	$FF	;FF
adrEA0038E9:	dc.b	$04	;04
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
adrEA003915:
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
	dc.b	$00	;00

adrCd003936:	move.w	d0,d1	;3200
	lea	adrEA014DE6.l,a0	;41F900014DE6
	asl.w	#$04,d1	;E941
	move.b	$0C(a0,d1.w),d0	;1030100C
	rts	;4E75

adrCd003946:	move.b	d0,$0009(a4)	;19400009
	and.w	#$007F,d0	;0240007F
	jsr	adrCd00D8DA.l	;4EB90000D8DA
	lea	adrEA0038D0.l,a6	;4DF9000038D0
	moveq	#$06,d2	;7406
	ror.w	#$08,d1	;E059
	cmp.b	#$30,d1	;0C010030
	beq.s	adrCd003970	;670C
	move.b	d1,$00(a6,d2.w)	;1D812000
	move.b	#$FA,$01(a6,d2.w)	;1DBC00FA2001
	addq.w	#$02,d2	;5442
adrCd003970:	ror.w	#$08,d1	;E059
	move.b	d1,$00(a6,d2.w)	;1D812000
	move.b	#$54,$01(a6,d2.w)	;1DBC00542001
	addq.w	#$02,d2	;5442
	bra	adrCd004068	;600006E8

adrCd003982:	movem.w	d0/d1,-(sp)	;48A7C000
	move.b	#$03,$0006(a4)	;197C00030006
	bsr	RandomGen_BytewithOffset	;61002852
	cmp.b	#$16,$000B(a1)	;0C290016000B
	bne.s	adrCd0039B4	;661C
	tst.b	$000C(a4)	;4A2C000C
	bmi.s	adrCd0039A6	;6B08
	cmp.b	#$40,$000C(a4)	;0C2C0040000C
	bcc.s	adrCd0039EC	;6446
adrCd0039A6:	and.w	#$0003,d0	;02400003
	add.w	#$0017,d0	;06400017
	move.b	d0,$000C(a1)	;1340000C
	bra.s	adrCd0039EC	;6038

adrCd0039B4:	and.w	#$001F,d0	;0240001F
	move.b	$0006(a1),d1	;12290006
	cmp.b	#$08,d1	;0C010008
	bcc.s	adrCd0039CC	;640A
	lsr.w	#$01,d0	;E248
	cmp.b	#$04,d1	;0C010004
	bcc.s	adrCd0039CC	;6402
	lsr.w	#$01,d0	;E248
adrCd0039CC:	
	lea	adrEA003915.l,a0	;41F900003915
	move.b	$00(a0,d0.w),$000C(a1)	;13700000000C
	and.b	#$07,$000A(a1)	;02290007000A
	move.b	$0006(a1),d0	;10290006
	and.w	#$007F,d0	;0240007F
	neg.b	d0	;4400
	move.b	d0,$0006(a4)	;19400006
adrCd0039EC:	movem.w	(sp)+,d0/d1	;4C9F0003
	rts	;4E75

adrJC0039F2:	move.b	#$01,$0052(a5)	;1B7C00010052
	clr.b	$004A(a5)	;422D004A
	tst.b	$004B(a5)	;4A2D004B
	bmi.s	adrCd003A08	;6B06
	move.w	#$00FF,$004A(a5)	;3B7C00FF004A
adrCd003A08:	cmp.w	#$0008,$0042(a5)	;0C6D00080042
	beq.s	adrCd003A26	;6716
	tst.w	$0042(a5)	;4A6D0042
	bne.s	adrCd003A3E	;6628
	move.w	#$FFFF,$0042(a5)	;3B7CFFFF0042
	move.w	#$FFFF,$0040(a5)	;3B7CFFFF0040
	bra	adrCd008894	;60004E70

adrCd003A26:	cmp.w	#$0006,$0044(a5)	;0C6D00060044
	bcs.s	adrCd003A3E	;6510
adrCd003A2E:	lsr.w	$0044(a5)	;E2ED0044
	addq.w	#$01,$0044(a5)	;526D0044
	bsr	adrCd003A58	;61000020
	bra	adrCd008AC4	;60005088

adrCd003A3E:	clr.w	$0042(a5)	;426D0042
	clr.w	$0044(a5)	;426D0044
	move.b	#$FF,$0035(a5)	;1B7C00FF0035
adrCd003A4C:	move.l	#$003B003B,d7	;2E3C003B003B
	bsr.s	adrCd003A5E	;610A
	bra	adrCd008AC4	;6000506E

adrCd003A58:	move.l	#$00760075,d7	;2E3C00760075
adrCd003A5E:	move.l	screen_ptr.l,a0	;207900009B06
	add.w	#$0647,a0	;D0FC0647
	add.w	$000A(a5),a0	;D0ED000A
	move.w	d7,d0	;3007
	swap	d7	;4847
	jsr	adrCd00D3DE.l	;4EB90000D3DE
	move.w	d7,d0	;3007
	jmp	adrCd00D3DE.l	;4EF90000D3DE

adrJC003A7E:	move.l	$0046(a5),a6	;2C6D0046
	moveq	#$00,d1	;7200
	move.b	$0040(a5),d0	;102D0040
	and.w	#$0003,d0	;02400003
	subq.b	#$01,d0	;5300
	bcs.s	adrCd003A9E	;650E
adrLp003A90:	addq.w	#$01,d1	;5241
	cmp.b	#$5F,(a6)+	;0C1E005F
	bcc.s	adrCd003A9A	;6402
	addq.w	#$01,d1	;5241
adrCd003A9A:	dbra	d0,adrLp003A90	;51C8FFF4
adrCd003A9E:	add.b	$0041(a5),d1	;D22D0041
adrCd003AA2:	move.w	$0042(a5),d0	;302D0042
	add.w	d0,d0	;D040
	lea	adrJB003AC6.l,a0	;41F900003AC6
	add.w	adrJT003AB4(pc,d0.w),a0	;D0FB0004
	jmp	(a0)	;4ED0

adrJT003AB4:
	dc.w	adrJB003AC6-adrJB003AC6	;0000
	dc.w	adrJC003B02-adrJB003AC6	;003C
	dc.w	adrJC0048E4-adrJB003AC6	;0E1E
	dc.w	adrJC004878-adrJB003AC6	;0DB2
	dc.w	adrJC004666-adrJB003AC6	;0BA0
	dc.w	adrJC0048D8-adrJB003AC6	;0E12
	dc.w	adrJC004662-adrJB003AC6	;0B9C
	dc.w	adrJC00459E-adrJB003AC6	;0AD8
	dc.w	adrJC003BF0-adrJB003AC6	;012A

adrJB003AC6:	clr.b	$004E(a5)	;422D004E
	addq.w	#$01,d1	;5241
	move.w	d1,$0042(a5)	;3B410042
	bra.s	adrCd003AA2	;60D0

adrCd003AD2:	bsr	adrCd00924C	;61005778
	move.l	d7,d2	;2407
	cmp.w	adrW_00F9CE.l,d7	;BE790000F9CE
	bcc.s	adrCd003B00	;6420
	swap	d7	;4847
	cmp.w	adrW_00F9CC.l,d7	;BE790000F9CC
	bcc.s	adrCd003B00	;6416
	move.b	$01(a6,d0.w),d1	;12360001
	bpl.s	adrCd003B00	;6A10
	and.w	#$0007,d1	;02410007
	subq.w	#$01,d1	;5341
	beq.s	adrCd003B00	;6708
	move.w	$0058(a5),d1	;322D0058
	bra	adrCd0087BE	;60004CC0

adrCd003B00:	rts	;4E75

adrJC003B02:	bsr.s	adrCd003AD2	;61CE
	bcs.s	adrCd003B16	;6510
adrCd003B06:	lea	adrEA004987.l,a6	;4DF900004987
	clr.w	$0042(a5)	;426D0042
	jmp	adrCd00E33A.l	;4EF90000E33A

adrCd003B16:	move.w	d0,d1	;3200
	bsr	adrCd0072D0	;610037B6
	move.b	#$17,$001F(a4)	;197C0017001F
	move.w	d1,d0	;3001
	bsr	adrCd00498E	;61000E68
	clr.b	$0006(a4)	;422C0006
	move.b	#$1A,$0000(a4)	;197C001A0000
	bclr	#$07,$0005(a4)	;08AC00070005
	tst.b	d0	;4A00
	bmi.s	adrCd003B72	;6B36
	move.w	$0020(a5),d1	;322D0020
	eor.w	#$0002,d1	;0A410002
	moveq	#$1C,d4	;781C
	cmp.w	#$0010,d0	;0C400010
	bcs.s	adrCd003B5E	;6512
	tst.b	$000B(a1)	;4A29000B
	bmi.s	adrCd003B06	;6BB4
	tst.b	$000C(a1)	;4A29000C
	bpl.s	adrCd003B5C	;6A04
	bsr	adrCd003982	;6100FE28
adrCd003B5C:	moveq	#$02,d4	;7802
adrCd003B5E:	and.b	#$F0,$00(a1,d4.w)	;023100F04000
	or.b	$00(a1,d4.w),d1	;82314000
	move.b	d1,$00(a1,d4.w)	;13814000
	move.b	d0,$0035(a5)	;1B400035
	bra.s	adrCd003B7C	;600A

adrCd003B72:	bset	#$07,$0005(a4)	;08EC00070005
	move.w	$0006(a1),d0	;30290006
adrCd003B7C:	move.b	$0007(a5),$0003(a4)	;196D00070003
	and.w	#$007F,d0	;0240007F
	move.b	d0,$0002(a4)	;19400002
	move.l	a4,-(sp)	;2F0C
	bsr	adrCd0072D0	;61003742
	move.b	$0005(a4),d2	;142C0005
	move.l	(sp)+,a4	;285F
	bsr	RandomGen_BytewithOffset	;61002648
	and.w	#$0007,d0	;02400007
	addq.w	#$02,d0	;5440
	sub.b	#$14,d2	;04020014
	bcc.s	adrCd003BA8	;6402
	moveq	#$00,d2	;7400
adrCd003BA8:	lsr.b	#$02,d2	;E40A
	add.b	d2,d0	;D002
	add.b	$0006(a4),d0	;D02C0006
	bpl.s	adrCd003BB4	;6A02
	moveq	#$00,d0	;7000
adrCd003BB4:	move.b	d0,$0006(a4)	;19400006
	bsr	RandomGen_BytewithOffset	;61002626
	and.w	#$0007,d0	;02400007
	addq.w	#$08,d0	;5040
	move.b	d0,$0007(a4)	;19400007
	move.b	#$14,$0004(a4)	;197C00140004
	clr.b	$0008(a4)	;422C0008
	lea	adrEA0044F9.l,a6	;4DF9000044F9
	jsr	adrCd00E2EA.l	;4EB90000E2EA
	move.w	#$0004,$0044(a5)	;3B7C00040044
	move.w	#$0008,$0042(a5)	;3B7C00080042
	bsr	adrCd003A58	;6100FE6E
	bra	adrCd008AC4	;60004ED6

adrJC003BF0:	move.w	$0044(a5),d0	;302D0044
	subq.w	#$04,d0	;5940
	beq.s	adrCd003C04	;670C
	addq.w	#$04,d1	;5841
	subq.w	#$01,d0	;5340
	beq.s	adrCd003C04	;6706
	addq.w	#$02,d1	;5441
	asl.w	#$02,d0	;E540
	add.w	d0,d1	;D240
adrCd003C04:	bsr	adrCd00498E	;61000D88
	addq.b	#$01,$0006(a4)	;522C0006
	bsr.s	adrCd003C34	;6126
	cmp.w	#$0006,$0044(a5)	;0C6D00060044
	bcs.s	adrCd003C22	;650C
	cmp.b	#$06,$0001(a4)	;0C2C00060001
	bcs.s	adrCd003C32	;6514
	bsr	adrCd003A2E	;6100FE0E
adrCd003C22:	move.b	#$14,$0004(a4)	;197C00140004
	move.b	$0001(a4),$0000(a4)	;196C00010000
	subq.b	#$01,$0007(a4)	;532C0007
adrCd003C32:	rts	;4E75

adrCd003C34:	move.b	d1,$0001(a4)	;19410001
	add.w	d1,d1	;D241
	lea	adrJB003C80.l,a0	;41F900003C80
	add.w	adrJT003C4A(pc,d1.w),a0	;D0FB1008
	bsr	RandomGen_BytewithOffset	;6100259A
	jmp	(a0)	;4ED0

adrJT003C4A:
	dc.w	adrJB003C80-adrJB003C80	;0000
	dc.w	adrJC003C8E-adrJB003C80	;000E
	dc.w	adrJC003C96-adrJB003C80	;0016
	dc.w	adrJC003C9E-adrJB003C80	;001E
	dc.w	adrJC003CAA-adrJB003C80	;002A
	dc.w	adrJC003CB2-adrJB003C80	;0032
	dc.w	adrJC003CBA-adrJB003C80	;003A
	dc.w	adrJC003D28-adrJB003C80	;00A8
	dc.w	adrJC003D62-adrJB003C80	;00E2
	dc.w	adrJC003D6E-adrJB003C80	;00EE
	dc.w	adrJC003E28-adrJB003C80	;01A8
	dc.w	adrJC003E34-adrJB003C80	;01B4
	dc.w	adrJC003E56-adrJB003C80	;01D6
	dc.w	adrJC003EC2-adrJB003C80	;0242
	dc.w	adrJC003EFE-adrJB003C80	;027E
	dc.w	adrJC003F0A-adrJB003C80	;028A
	dc.w	adrJC003F16-adrJB003C80	;0296
	dc.w	adrJC003F22-adrJB003C80	;02A2
	dc.w	adrJC003FB8-adrJB003C80	;0338
	dc.w	adrJC004030-adrJB003C80	;03B0
	dc.w	adrJC004042-adrJB003C80	;03C2
	dc.w	adrJC004000-adrJB003C80	;0380
	dc.w	adrJC0040A4-adrJB003C80	;0424
	dc.w	adrJC0040B0-adrJB003C80	;0430
	dc.w	adrJC00419A-adrJB003C80	;051A
	dc.w	adrJC0041DE-adrJB003C80	;055E
	dc.w	adrJC003C8C-adrJB003C80	;000C

adrJB003C80:	lea	adrEA004585.l,a6	;4DF900004585
	jmp	adrCd00DA18.l	;4EF90000DA18

adrJC003C8C:	rts	;4E75

adrJC003C8E:	addq.w	#$02,$0044(a5)	;546D0044
	bra	adrCd003A4C	;6000FDB8

adrJC003C96:	addq.w	#$03,$0044(a5)	;566D0044
	bra	adrCd003A4C	;6000FDB0

adrJC003C9E:	lea	adrEA004531.l,a6	;4DF900004531
	jmp	adrCd00DA18.l	;4EF90000DA18

adrJC003CAA:	addq.w	#$03,$0044(a5)	;566D0044
	bra	adrCd003A4C	;6000FD9C

adrJC003CB2:	addq.w	#$04,$0044(a5)	;586D0044
	bra	adrCd003A4C	;6000FD94

adrJC003CBA:	move.b	$0008(a4),d2	;142C0008
	subq.b	#$02,d2	;5502
	bcs.s	adrCd003D22	;6560
	bne.s	adrCd003D00	;663C
	cmp.b	#$12,$0000(a4)	;0C2C00120000
	bne.s	adrCd003D22	;6656
	move.w	$002E(a5),d0	;302D002E
	cmp.b	$000A(a4),d0	;B02C000A
	bne.s	adrCd003D1E	;6648
	move.b	$0035(a5),d0	;102D0035
	cmp.b	#$10,d0	;0C000010
	bcs.s	adrCd003D22	;6542
	bsr	adrCd003936	;6100FC54
	move.b	$002F(a5),$0C(a0,d1.w)	;11AD002F100C
	move.b	d0,$002F(a5)	;1B40002F
	move.w	#$0001,$002C(a5)	;3B7C0001002C
adrCd003CF4:	move.b	#$18,$0001(a4)	;197C00180001
	bsr.s	adrCd003D1E	;6122
	bra	adrCd007900	;60003C02

adrCd003D00:	move.b	$000A(a4),d0	;102C000A
	cmp.b	$002F(a5),d0	;B02D002F
	bne.s	adrCd003D1E	;6614
	and.b	#$7F,$0009(a4)	;022C007F0009
	move.b	$0009(a4),$002D(a5)	;1B6C0009002D
	move.w	#$0001,$002E(a5)	;3B7C0001002E
	bra.s	adrCd003CF4	;60D6

adrCd003D1E:	clr.b	$0008(a4)	;422C0008
adrCd003D22:	move.w	#$45FF,d0	;303C45FF
	bra.s	adrCd003D4A	;6022

adrJC003D28:	move.w	#$3DFF,d0	;303C3DFF
	move.b	$0008(a4),d1	;122C0008
	beq.s	adrCd003D4A	;6718
	add.b	#$12,d1	;06010012
	move.b	d1,$0001(a4)	;19410001
	cmp.b	#$15,d1	;0C010015
	bne.s	adrCd003D4A	;660A
	subq.b	#$04,$0006(a4)	;592C0006
	bpl.s	adrCd003D4A	;6A04
	clr.b	$0006(a4)	;422C0006
adrCd003D4A:	subq.b	#$01,$0006(a4)	;532C0006
	bpl.s	adrCd003D54	;6A04
	clr.b	$0006(a4)	;422C0006
adrCd003D54:	lea	adrEA00D3DA.l,a6	;4DF90000D3DA
	move.w	d0,(a6)	;3C80
	jmp	adrCd00E2EA.l	;4EF90000E2EA

adrJC003D62:	lea	adrEA004528.l,a6	;4DF900004528
	jmp	adrCd00E2EA.l	;4EF90000E2EA

adrJC003D6E:	lea	adrEA0044C2.l,a6	;4DF9000044C2
	and.w	#$0003,d0	;02400003
	lea	adrEA0044E0.l,a3	;47F9000044E0
	bsr	adrCd003E18	;61000098
	move.b	$0006(a4),d0	;102C0006
	subq.b	#$03,$0006(a4)	;572C0006
	bpl.s	adrCd003D90	;6A04
	clr.b	$0006(a4)	;422C0006
adrCd003D90:	cmp.b	#$0A,d0	;0C00000A
	bcs.s	adrCd003DDA	;6544
adrCd003D96:	move.b	$0002(a4),d0	;102C0002
	bpl.s	adrCd003DA4	;6A08
	and.w	#$000F,d0	;0240000F
	move.b	d0,(a6)+	;1CC0
	bra.s	adrCd003E08	;6064

adrCd003DA4:	move.b	#$99,(a6)+	;1CFC0099
	move.b	#$C3,d1	;123C00C3
	btst	#$06,d0	;08000006
	beq.s	adrCd003DD6	;6724
	and.w	#$000F,d0	;0240000F
	lea	CharacterStats.l,a1	;43F90000F586
	asl.w	#$06,d0	;ED40
	move.b	$01(a1,d0.w),d1	;12310001
	bsr	adrCd0009E0	;6100CC1C
	move.w	d1,d0	;3001
	move.b	#$9E,d1	;123C009E
	tst.w	d0	;4A40
	beq.s	adrCd003DD6	;6706
	add.b	#$5B,d0	;0600005B
	move.b	d0,d1	;1200
adrCd003DD6:	move.b	d1,(a6)+	;1CC1
	bra.s	adrCd003E08	;602E

adrCd003DDA:	move.b	#$62,(a6)+	;1CFC0062
	bsr	RandomGen_BytewithOffset	;61002400
	and.w	#$0003,d0	;02400003
	lea	adrEA0044F0.l,a3	;47F9000044F0
	bsr.s	adrCd003E18	;612A
	cmp.b	#$06,$0006(a4)	;0C2C00060006
	bcc.s	adrCd003D96	;64A0
	move.b	#$1A,(a6)+	;1CFC001A
	bsr	RandomGen_BytewithOffset	;610023E4
	and.w	#$0007,d0	;02400007
	add.b	#$B6,d0	;060000B6
	move.b	d0,(a6)+	;1CC0
adrCd003E08:	move.b	#$FF,(a6)	;1CBC00FF
	lea	adrEA0044C2.l,a6	;4DF9000044C2
	jmp	adrCd00E2EA.l	;4EF90000E2EA

adrCd003E18:	jsr	adrCd00E284.l	;4EB90000E284
	subq.w	#$01,d5	;5345
adrLp003E20:	move.b	(a3)+,(a6)+	;1CDB
	dbra	d5,adrLp003E20	;51CDFFFC
	rts	;4E75

adrJC003E28:	lea	adrEA0044FF.l,a6	;4DF9000044FF
	jmp	adrCd00E2EA.l	;4EF90000E2EA

adrJC003E34:	lea	adrEA003E40.l,a6	;4DF900003E40
	jmp	adrCd00DA18.l	;4EF90000DA18

adrEA003E40:	dc.b	'WHAT BE THY BUSINESS?'	;574841542042452054485920425553494E4553533F
	dc.b	$FF	;FF

adrJC003E56:	lea	adrEA0044AC.l,a6	;4DF9000044AC
	move.b	$0003(a4),d1	;122C0003
	or.b	#$80,$0003(a4)	;002C00800003
	and.w	#$000F,d1	;0241000F
	move.b	d1,$0003(a6)	;1D410003
	move.b	d1,$0004(a6)	;1D410004
	add.b	#$64,$0004(a6)	;062E00640004
	asl.w	#$06,d1	;ED41
	lea	CharacterStats.l,a1	;43F90000F586
	add.w	d1,a1	;D2C1
	cmp.b	#$10,$0001(a1)	;0C2900100001
	bcc.s	adrCd003E90	;6406
	jmp	adrCd00E2EA.l	;4EF90000E2EA

adrCd003E90:	lea	adrEA0044C2.l,a6	;4DF9000044C2
	lea	adrEA0038DD.l,a0	;41F9000038DD
adrCd003E9C:	move.b	(a0)+,d0	;1018
	bmi.s	adrCd003EA4	;6B04
	move.b	d0,(a6)+	;1CC0
	bra.s	adrCd003E9C	;60F8

adrCd003EA4:	moveq	#$00,d0	;7000
	move.b	$0001(a1),d0	;10290001
	move.b	$0024(a1),d1	;12290024
	move.b	(a1),d2	;1411
	jsr	adrCd00E1C4.l	;4EB90000E1C4
	lea	adrEA0044C2.l,a6	;4DF9000044C2
	jmp	adrCd00DA68.l	;4EF90000DA68

adrJC003EC2:	lea	adrEA004505.l,a6	;4DF900004505
	move.b	$0003(a4),d0	;102C0003
	or.b	#$40,$0003(a4)	;002C00400003
	and.w	#$000F,d0	;0240000F
	move.b	#$9E,$0006(a6)	;1D7C009E0006
	lea	CharacterStats.l,a1	;43F90000F586
	asl.w	#$06,d0	;ED40
	move.b	$01(a1,d0.w),d1	;12310001
	bsr	adrCd0009E0	;6100CAF6
	move.w	d1,d0	;3001
	beq.s	adrCd003EF8	;6708
	add.w	#$005B,d0	;0640005B
	move.b	d0,$0006(a6)	;1D400006
adrCd003EF8:	jmp	adrCd00E2EA.l	;4EF90000E2EA

adrJC003EFE:	lea	adrEA003F2E.l,a6	;4DF900003F2E
	jmp	adrCd00DA18.l	;4EF90000DA18

adrJC003F0A:	lea	adrEA003F4B.l,a6	;4DF900003F4B
	jmp	adrCd00DA18.l	;4EF90000DA18

adrJC003F16:	lea	adrEA003F70.l,a6	;4DF900003F70
	jmp	adrCd00DA18.l	;4EF90000DA18

adrJC003F22:	lea	adrEA003F95.l,a6	;4DF900003F95
	jmp	adrCd00DA18.l	;4EF90000DA18

adrEA003F2E:	dc.b	'HAST THOU HEARD ANY LEGENDS?'	;484153542054484F5520484541524420414E59204C4547454E44533F
	dc.b	$FF	;FF
adrEA003F4B:	dc.b	'KNOWEST THOU OF ANY ENCHANTED ITEMS?'	;4B4E4F574553542054484F55204F4620414E5920454E4348414E544544204954454D533F
	dc.b	$FF	;FF
adrEA003F70:	dc.b	'KNOWEST THOU OF ANY WEAPONS OF NOTE?'	;4B4E4F574553542054484F55204F4620414E5920574541504F4E53204F46204E4F54453F
	dc.b	$FF	;FF
adrEA003F95:	dc.b	'HAST HEARD OF ANY POWERFUL BEINGS?'	;48415354204845415244204F4620414E5920504F57455246554C204245494E47533F
	dc.b	$FF	;FF

adrJC003FB8:	move.w	$002E(a5),d0	;302D002E
	move.b	d0,$000A(a4)	;1940000A
	bne.s	adrCd003FCA	;6608
	clr.b	$0008(a4)	;422C0008
	moveq	#$2E,d0	;702E
	bra.s	adrCd004020	;6056

adrCd003FCA:	cmp.w	#$0001,d0	;0C400001
	bne.s	adrCd003FE8	;6618
	move.w	$002C(a5),d0	;302D002C
	cmp.b	#$02,$0008(a4)	;0C2C00020008
	bne	adrCd003946	;6600F96A
	move.b	#$01,$0008(a4)	;197C00010008
	bra	adrCd003946	;6000F960

adrCd003FE8:	cmp.b	#$01,$0008(a4)	;0C2C00010008
	bne.s	adrCd003FF6	;6606
	move.b	#$02,$0008(a4)	;197C00020008
adrCd003FF6:	lea	adrEA004567.l,a6	;4DF900004567
	moveq	#$05,d2	;7405
	bra.s	adrCd004066	;6066

adrJC004000:	move.b	#$03,$0008(a4)	;197C00030008
	clr.b	$0009(a4)	;422C0009
	move.w	$002E(a5),d0	;302D002E
	beq.s	adrCd00401E	;670E
	move.b	d0,$000A(a4)	;1940000A
	lea	adrEA004572.l,a6	;4DF900004572
	moveq	#$05,d2	;7405
	bra.s	adrCd004066	;6048

adrCd00401E:	moveq	#$57,d0	;7057
adrCd004020:	lea	adrEA00455A.l,a6	;4DF90000455A
	move.b	d0,$0005(a6)	;1D400005
	jmp	adrCd00E2EA.l	;4EF90000E2EA

adrJC004030:	lea	adrEA00457D.l,a6	;4DF90000457D
	move.b	#$01,$0008(a4)	;197C00010008
	jmp	adrCd00E2EA.l	;4EF90000E2EA

adrJC004042:	move.b	#$02,$0008(a4)	;197C00020008
	move.w	$002E(a5),d0	;302D002E
	move.b	d0,$000A(a4)	;1940000A
	bne.s	adrCd00405E	;660C
	lea	adrEA00450D.l,a6	;4DF90000450D
	jmp	adrCd00E2EA.l	;4EF90000E2EA

adrCd00405E:	lea	adrEA004517.l,a6	;4DF900004517
	moveq	#$0B,d2	;740B
adrCd004066:	bsr.s	adrCd004080	;6118
adrCd004068:	move.b	#$FA,$00(a6,d2.w)	;1DBC00FA2000
	move.b	#$3F,$01(a6,d2.w)	;1DBC003F2001
	move.b	#$FF,$02(a6,d2.w)	;1DBC00FF2002
	jmp	adrCd00E2EA.l	;4EF90000E2EA

adrCd004080:	lea	ObjectDefinitionsTable+$2.l,a0	;41F90000EF4C
	add.w	d0,d0	;D040
	add.w	d0,d0	;D040
	add.w	d0,a0	;D0C0
	move.b	(a0)+,$00(a6,d2.w)	;1D982000
	addq.w	#$01,d2	;5242
	move.b	(a0),d0	;1010
	bmi.s	adrCd0040A2	;6B0C
	move.b	#$FE,$00(a6,d2.w)	;1DBC00FE2000
	move.b	d0,$01(a6,d2.w)	;1D802001
	addq.w	#$02,d2	;5442
adrCd0040A2:	rts	;4E75

adrJC0040A4:	addq.b	#$01,$0006(a4)	;522C0006
	lea	adrEA00418E.l,a0	;41F90000418E
	bra.s	adrCd0040C0	;6010

adrJC0040B0:	subq.b	#$04,$0006(a4)	;592C0006
	bpl.s	adrCd0040BA	;6A04
	clr.b	$0006(a4)	;422C0006
adrCd0040BA:	lea	adrEA004194.l,a0	;41F900004194
adrCd0040C0:	bsr.s	adrCd00410A	;6148
	moveq	#$02,d4	;7802
adrLp0040C4:	asr.w	#$01,d7	;E247
	bcc.s	adrCd0040CA	;6402
	bsr.s	adrCd0040DC	;6112
adrCd0040CA:	addq.w	#$02,a0	;5448
	dbra	d4,adrLp0040C4	;51CCFFF6
	move.b	#$FF,$00(a6,d2.w)	;1DBC00FF2000
	jmp	adrCd00E2EA.l	;4EF90000E2EA

adrCd0040DC:	bsr	RandomGen_BytewithOffset	;61002102
	and.w	#$0007,d0	;02400007
	tst.w	d7	;4A47
	bpl.s	adrCd0040FE	;6A16
	cmp.b	(a0),d0	;B010
	bcs.s	adrCd0040FA	;650E
	move.b	#$FA,$00(a6,d2.w)	;1DBC00FA2000
	move.b	#$4E,$01(a6,d2.w)	;1DBC004E2001
	addq.w	#$02,d2	;5442
adrCd0040FA:	and.w	#$00FF,d7	;024700FF
adrCd0040FE:	add.b	$0001(a0),d0	;D0280001
	move.b	d0,$00(a6,d2.w)	;1D802000
	addq.w	#$01,d2	;5242
	rts	;4E75

adrCd00410A:	and.w	#$00FE,d0	;024000FE
	moveq	#$00,d7	;7E00
adrCd004110:	cmp.b	adrB_004182(pc,d7.w),d0	;B03B7070
	bcs.s	adrCd00411A	;6504
	addq.w	#$02,d7	;5447
	bra.s	adrCd004110	;60F6

adrCd00411A:	move.b	adrB_004183(pc,d7.w),d7	;1E3B7067
	lea	adrEA0044C2.l,a6	;4DF9000044C2
	move.b	#$1A,(a6)	;1CBC001A
	moveq	#$01,d2	;7401
	lsr.w	#$01,d7	;E24F
	bcc.s	adrCd004166	;6438
	cmp.b	#$03,$0001(a4)	;0C2C00030001
	bne.s	adrCd00413E	;6608
	bsr	adrCd00618A	;61002052
	addq.w	#$02,d0	;5440
	bra.s	adrCd004146	;6008

adrCd00413E:	bsr	RandomGen_BytewithOffset	;610020A0
	and.w	#$0007,d0	;02400007
adrCd004146:	move.w	#$0084,d1	;323C0084
	add.w	d0,d1	;D240
	move.b	d1,$0001(a6)	;1D410001
	moveq	#$02,d2	;7402
	cmp.w	#$0007,d0	;0C400007
	beq.s	adrCd004166	;670E
	move.b	#$FA,$0002(a6)	;1D7C00FA0002
	move.b	#$53,$0003(a6)	;1D7C00530003
	moveq	#$04,d2	;7404
adrCd004166:	ror.w	#$01,d7	;E25F
	bpl.s	adrCd004180	;6A16
	cmp.w	#$0005,d0	;0C400005
	bcc.s	adrCd004178	;6408
	move.b	#$8C,$00(a6,d2.w)	;1DBC008C2000
	addq.w	#$01,d2	;5242
adrCd004178:	move.b	#$8D,$00(a6,d2.w)	;1DBC008D2000
	addq.w	#$01,d2	;5242
adrCd004180:	rts	;4E75

adrB_004182:	dc.b	$0C	;0C
adrB_004183:	dc.b	$10	;10
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
adrEA00418E:	dc.w	$048E	;048E
	dc.w	$0796	;0796
	dc.w	$079E	;079E
adrEA004194:	dc.w	$03A6	;03A6
	dc.w	$07AE	;07AE
	dc.w	$07B6	;07B6

adrJC00419A:	lea	adrEA0044BC.l,a6	;4DF9000044BC
	and.w	#$0007,d0	;02400007
	add.w	#$0074,d0	;06400074
	move.b	d0,$0002(a6)	;1D400002
	bsr	RandomGen_BytewithOffset	;61002032
	and.w	#$0007,d0	;02400007
	add.w	#$007C,d0	;0640007C
	move.b	d0,$0004(a6)	;1D400004
	jmp	adrCd00E2EA.l	;4EF90000E2EA

adrB_0041C2:	dc.b	$00	;00
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

adrJC0041DE:	moveq	#$00,d0	;7000
	move.b	$0000(a4),d0	;102C0000
	move.b	adrB_0041C2(pc,d0.w),d0	;103B00DC
	add.w	d0,d0	;D040
	lea	Reply2_0.l,a6	;4DF9000042A6
	add.w	adrW_004218(pc,d0.w),a6	;DCFB0026
	tst.b	(a6)	;4A16
	bpl.s	adrCd00420A	;6A12
	lea	Reply1_0.l,a6	;4DF900004246
	bsr	RandomGen_BytewithOffset	;61001FE0
	and.w	#$0006,d0	;02400006
	add.w	adrW_004210(pc,d0.w),a6	;DCFB0008
adrCd00420A:	jmp	adrCd00DA18.l	;4EF90000DA18

adrW_004210:	dc.w	Reply1_0-Reply1_0	;0000
	dc.w	Reply1_1-Reply1_0	;0015
	dc.w	Reply1_2-Reply1_0	;0028
	dc.w	Reply1_3-Reply1_0	;003F
adrW_004218:	dc.w	Reply2_0-Reply2_0	;0000
	dc.w	Reply2_1-Reply2_0	;0022
	dc.w	Reply2_2-Reply2_0	;003F
	dc.w	Reply2_3-Reply2_0	;0040
	dc.w	Reply2_4-Reply2_0	;004B
	dc.w	Reply2_5-Reply2_0	;005D
	dc.w	Reply2_6-Reply2_0	;0084
	dc.w	Reply2_7-Reply2_0	;009D
	dc.w	Reply2_8-Reply2_0	;00BB
	dc.w	Reply2_9-Reply2_0	;00BC
	dc.w	Reply2_10-Reply2_0	;00BD
	dc.w	Reply2_11-Reply2_0	;00DB
	dc.w	Reply2_12-Reply2_0	;00FF
	dc.w	Reply2_13-Reply2_0	;011C
	dc.w	Reply2_14-Reply2_0	;013F
	dc.w	Reply2_15-Reply2_0	;014F
	dc.w	Reply2_16-Reply2_0	;016E
	dc.w	Reply2_17-Reply2_0	;0189
	dc.w	Reply2_18-Reply2_0	;019E
	dc.w	Reply2_19-Reply2_0	;019F
	dc.w	Reply2_20-Reply2_0	;01C6
	dc.w	Reply2_21-Reply2_0	;01E0
	dc.w	Reply2_22-Reply2_0	;01E1
Reply1_0:	dc.b	'THAT''S VERY POSSIBLE'	;544841542753205645525920504F535349424C45
	dc.b	$FF	;FF
Reply1_1:	dc.b	'I CANNOT BUT AGREE'	;492043414E4E4F5420425554204147524545
	dc.b	$FF	;FF
Reply1_2:	dc.b	'THAT SEEMS VERY LIKELY'	;54484154205345454D532056455259204C494B454C59
	dc.b	$FF	;FF
Reply1_3:	dc.b	'I''M NOT ABOUT TO ARGUE WITH THEE'	;49274D204E4F542041424F555420544F20415247554520574954482054484545
	dc.b	$FF	;FF
Reply2_0:	dc.b	'I DON''T KEEP COMPANY WITH MAGGOTS'	;4920444F4E2754204B45455020434F4D50414E592057495448204D4147474F5453
	dc.b	$FF	;FF
Reply2_1:	dc.b	'LOOK TO THE TOWERS MY FRIEND'	;4C4F4F4B20544F2054484520544F57455253204D5920465249454E44
	dc.b	$FF	;FF
Reply2_2:	dc.b	$FF	;FF
Reply2_3:	dc.b	'INDEED NOT'	;494E44454544204E4F54
	dc.b	$FF	;FF
Reply2_4:	dc.b	'MAKE ME THY OFFER'	;4D414B45204D4520544859204F46464552
	dc.b	$FF	;FF
Reply2_5:	dc.b	'PICK ON SOMEONE THY OWN SIZE THOU SLUG'	;5049434B204F4E20534F4D454F4E4520544859204F574E2053495A452054484F5520534C5547
	dc.b	$FF	;FF
Reply2_6:	dc.b	'I AM THY WORST NIGHTMARE'	;4920414D2054485920574F525354204E494748544D415245
	dc.b	$FF	;FF
Reply2_7:	dc.b	'NONE OF THY BUSINESS I''M SURE'	;4E4F4E45204F462054485920425553494E4553532049274D2053555245
	dc.b	$FF	;FF
Reply2_8:	dc.b	$FF	;FF
Reply2_9:	dc.b	$FF	;FF
Reply2_10:	dc.b	'NEWS IS SCARCE IN THESE PARTS'	;4E4557532049532053434152434520494E205448455345205041525453
	dc.b	$FF	;FF
Reply2_11:	dc.b	'MAGIC IS IN THE EYE OF THE BEHOLDER'	;4D4147494320495320494E2054484520455945204F4620544845204245484F4C444552
	dc.b	$FF	;FF
Reply2_12:	dc.b	'WHO CAN SAY WHAT IS OF NOTE?'	;57484F2043414E205341592057484154204953204F46204E4F54453F
	dc.b	$FF	;FF
Reply2_13:	dc.b	'I AWAIT THE CALL OF THE MARTINDALE'	;49204157414954205448452043414C4C204F4620544845204D415254494E44414C45
	dc.b	$FF	;FF
Reply2_14:	dc.b	'GIVE ME A BREAK'	;47495645204D45204120425245414B
	dc.b	$FF	;FF
Reply2_15:	dc.b	'THY COINAGE IS WORTHLESS TO ME'	;54485920434F494E41474520495320574F5254484C45535320544F204D45
	dc.b	$FF	;FF
Reply2_16:	dc.b	'I DO NOT TRADE IN TRINKETS'	;4920444F204E4F5420545241444520494E205452494E4B455453
	dc.b	$FF	;FF
Reply2_17:	dc.b	'I NEED NOT THY TRASH'	;49204E454544204E4F5420544859205452415348
	dc.b	$FF	;FF
Reply2_18:	dc.b	$FF	;FF
Reply2_19:	dc.b	'MAYBE TRUE BUT THOU SHOULD BE SO LUCKY'	;4D415942452054525545204255542054484F552053484F554C4420424520534F204C55434B59
	dc.b	$FF	;FF
Reply2_20:	dc.b	'I TRUST THIS PLEASES THEE'	;49205452555354205448495320504C45415345532054484545
	dc.b	$FF	;FF
Reply2_21:	dc.b	$FF	;FF
Reply2_22:	dc.b	'WHY DOST BURDEN ME WITH THY COMPANY?'	;57485920444F53542042555244454E204D4520574954482054485920434F4D50414E593F
	dc.b	$FF	;FF
adrEA0044AC:	dc.b	$5F	;5F
	dc.b	$4B	;4B
	dc.b	$35	;35
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$4B	;4B
	dc.b	$FA	;FA
	dc.b	$53	;53
	dc.b	$29	;29
	dc.b	$1C	;1C
	dc.b	$25	;25
	dc.b	$FA	;FA
	dc.b	$45	;45
	dc.b	$00	;00
	dc.b	$FF	;FF
adrEA0044BC:	dc.b	$33	;33
	dc.b	$5F	;5F
	dc.b	$00	;00
	dc.b	$35	;35
	dc.b	$00	;00
	dc.b	$FF	;FF
adrEA0044C2:	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
adrEA0044E0:	dc.b	$02	;02
	dc.b	$BE	;BE
	dc.b	$BF	;BF
	dc.b	$01	;01
	dc.b	$30	;30
	dc.b	$07	;07
	dc.b	$29	;29
	dc.b	$FB	;FB
	dc.b	$31	;31
	dc.b	$FA	;FA
	dc.b	$4E	;4E
	dc.b	$FA	;FA
	dc.b	$45	;45
	dc.b	$02	;02
	dc.b	$31	;31
	dc.b	$63	;63
adrEA0044F0:	dc.b	$01	;01
	dc.b	$C0	;C0
	dc.b	$01	;01
	dc.b	$C1	;C1
	dc.b	$02	;02
	dc.b	$29	;29
	dc.b	$C2	;C2
	dc.b	$01	;01
	dc.b	$84	;84
adrEA0044F9:	dc.b	$49	;49
	dc.b	$FB	;FB
	dc.b	$4A	;4A
	dc.b	$FA	;FA
	dc.b	$53	;53
	dc.b	$FF	;FF
adrEA0044FF:	dc.b	$18	;18
	dc.b	$8B	;8B
	dc.b	$1A	;1A
	dc.b	$FA	;FA
	dc.b	$3F	;3F
	dc.b	$FF	;FF
adrEA004505:	dc.b	$CE	;CE
	dc.b	$8D	;8D
	dc.b	$FA	;FA
	dc.b	$4D	;4D
	dc.b	$8D	;8D
	dc.b	$99	;99
	dc.b	$00	;00
	dc.b	$FF	;FF
adrEA00450D:	dc.b	$27	;27
	dc.b	$1A	;1A
	dc.b	$60	;60
	dc.b	$22	;22
	dc.b	$42	;42
	dc.b	$FA	;FA
	dc.b	$45	;45
	dc.b	$FA	;FA
	dc.b	$3F	;3F
	dc.b	$FF	;FF
adrEA004517:	dc.b	$18	;18
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
adrEA004528:	dc.b	$CC	;CC
	dc.b	$1A	;1A
	dc.b	$1D	;1D
	dc.b	$2F	;2F
	dc.b	$43	;43
	dc.b	$CD	;CD
	dc.b	$FA	;FA
	dc.b	$3F	;3F
	dc.b	$FF	;FF
adrEA004531:	dc.b	'WHERE IS THIS OF WHICH THOU HAST SPOKEN?'	;57484552452049532054484953204F462057484943482054484F5520484153542053504F4B454E3F
	dc.b	$FF	;FF
adrEA00455A:	dc.b	$2D	;2D
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
adrEA004567:	dc.b	$CC	;CC
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
adrEA004572:	dc.b	$CC	;CC
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
adrEA00457D:	dc.b	$27	;27
	dc.b	$1A	;1A
	dc.b	$60	;60
	dc.b	$1C	;1C
	dc.b	$57	;57
	dc.b	$FA	;FA
	dc.b	$3F	;3F
	dc.b	$FF	;FF
adrEA004585:	dc.b	'COME JOIN MY MERRY BAND'	;434F4D45204A4F494E204D59204D455252592042414E44
	dc.b	$FF	;FF
	dc.b	$00	;00

adrJC00459E:	lea	adrEA004968.l,a6	;4DF900004968
	jsr	adrCd00E33A.l	;4EB90000E33A
	move.b	#$FF,$0050(a5)	;1B7C00FF0050
	lea	Player1_Data.l,a1	;43F90000F9D8
	btst	#$00,(a5)	;08150000
	bne.s	adrCd0045C2	;6606
	lea	Player2_Data.l,a1	;43F90000FA3A
adrCd0045C2:	btst	#$06,$0018(a1)	;082900060018
	bne	adrCd00465E	;66000094
	move.b	(a1),d0	;1011
	and.b	#$FE,d0	;020000FE
	bne	adrCd00465E	;6600008A
	move.w	$0058(a5),d0	;302D0058
	cmp.w	$0058(a1),d0	;B0690058
	bne	adrCd00465E	;6600007E
	lea	adrEA0044C2.l,a6	;4DF9000044C2
	move.b	#$CA,(a6)+	;1CFC00CA
	move.b	#$C4,(a6)+	;1CFC00C4
	move.l	$001C(a1),d1	;2229001C
	move.l	$001C(a5),d0	;202D001C
	bsr	adrCd001720	;6100D126
	cmp.w	#$0005,d2	;0C420005
	bcs.s	adrCd004610	;650E
	cmp.w	#$0009,d2	;0C420009
	bcs.s	adrCd00460C	;6504
	move.b	#$8E,(a6)+	;1CFC008E
adrCd00460C:	move.b	#$C5,(a6)+	;1CFC00C5
adrCd004610:	move.b	#$16,(a6)+	;1CFC0016
	move.b	#$FA,(a6)+	;1CFC00FA
	move.b	#$53,(a6)+	;1CFC0053
	move.b	#$1C,(a6)+	;1CFC001C
	move.b	#$25,(a6)+	;1CFC0025
	moveq	#$00,d3	;7600
	move.w	d0,d2	;3400
	swap	d0	;4840
	cmp.w	d0,d2	;B440
	bcs.s	adrCd004632	;6504
	moveq	#$01,d3	;7601
	swap	d1	;4841
adrCd004632:	swap	d1	;4841
	tst.w	d1	;4A41
	bmi.s	adrCd00463A	;6B02
	addq.b	#$02,d3	;5403
adrCd00463A:	add.w	$0020(a1),d3	;D6690020
	and.w	#$0003,d3	;02430003
	add.w	#$00C6,d3	;064300C6
	move.b	d3,(a6)+	;1CC3
	move.b	#$FF,(a6)	;1CBC00FF
	lea	adrEA0044C2.l,a6	;4DF9000044C2
	move.l	a5,-(sp)	;2F0D
	move.l	a1,a5	;2A49
	jsr	adrCd00E33A.l	;4EB90000E33A
	move.l	(sp)+,a5	;2A5F
adrCd00465E:	bra	adrCd003A3E	;6000F3DE

adrJC004662:	moveq	#$15,d7	;7E15
	bra.s	adrCd00466C	;6006

adrJC004666:	clr.b	$0050(a5)	;422D0050
	moveq	#$13,d7	;7E13
adrCd00466C:	tst.b	$004E(a5)	;4A2D004E
	beq	adrCd004834	;670001C2
	bsr	adrCd004912	;6100029C
	move.w	d7,-(sp)	;3F07
	move.b	d0,$004F(a5)	;1B40004F
	move.l	$001C(a5),d7	;2E2D001C
	move.w	$0020(a5),d6	;3C2D0020
	bsr	adrCd0086F6	;6100406E
	bcc.s	adrCd0046A2	;6416
	addq.w	#$02,sp	;544F
	lea	adrEA00494F.l,a6	;4DF90000494F
	move.b	$004F(a5),(a6)	;1CAD004F
	jsr	adrCd00E33A.l	;4EB90000E33A
	bra	adrCd003A3E	;6000F39E

adrCd0046A2:	bset	#$07,$01(a6,d2.w)	;08F600072001
	move.b	$004F(a5),d0	;102D004F
	bsr	adrCd004798	;610000EA
	lea	adrEA00495A.l,a6	;4DF90000495A
	move.w	(sp)+,d1	;321F
	cmp.w	#$0015,d1	;0C410015
	beq.s	adrCd0046D6	;6718
	bsr	adrCd0047E8	;61000128
	move.b	$004F(a5),d0	;102D004F
	bset	#$05,d0	;08C00005
	move.b	d0,$18(a5,d1.w)	;1B801018
	lea	adrEA004955.l,a6	;4DF900004955
	moveq	#$00,d1	;7200
adrCd0046D6:	moveq	#$00,d0	;7000
	move.b	$004F(a5),d0	;102D004F
	move.b	d0,(a6)	;1C80
	move.w	d0,d2	;3400
	bsr	adrCd0072D4	;61002BF2
	cmp.b	#$15,d1	;0C010015
	bne	adrCd00476C	;66000082
	cmp.b	#$10,$0001(a4)	;0C2C00100001
	bcs.s	adrCd00476C	;6578
	lea	adrEA014ED4.l,a0	;41F900014ED4
	move.b	#$FF,$00(a0,d2.w)	;11BC00FF2000
	lea	(a4),a0	;41D4
adrCd004702:	lea	UnpackedMonsters.l,a4	;49F900014EE6
	addq.w	#$01,-$0002(a4)	;526CFFFE
	move.w	-$0002(a4),d1	;322CFFFE
	cmp.w	#$007D,d1	;0C41007D
	bcs.s	adrCd004720	;650A
	subq.w	#$01,-$0002(a4)	;536CFFFE
	bsr	adrCd002C84	;6100E568
	bra.s	adrCd004702	;60E2

adrCd004720:	asl.w	#$04,d1	;E941
	add.w	d1,a4	;D8C1
	move.b	d7,$0001(a4)	;19470001
	swap	d7	;4847
	move.b	d7,$0000(a4)	;19470000
	move.b	$0059(a5),$0004(a4)	;196D00590004
	move.b	$0021(a5),$0002(a4)	;196D00210002
	move.b	#$80,$0003(a4)	;197C00800003
	move.b	$0001(a0),$000B(a4)	;19680001000B
	move.w	$0006(a0),$0008(a4)	;396800060008
	move.b	(a0),$0006(a4)	;19500006
	move.b	(a0),$0007(a4)	;19500007
	move.b	#$FF,$000D(a4)	;197C00FF000D
	move.b	#$FF,$000C(a4)	;197C00FF000C
	clr.b	$0005(a4)	;422C0005
	move.b	$0024(a0),$000A(a4)	;19680024000A
	bra.s	adrCd00478A	;601E

adrCd00476C:	move.b	d7,$001B(a4)	;1947001B
	swap	d7	;4847
	move.b	d7,$001A(a4)	;1947001A
	move.b	$0059(a5),$001E(a4)	;196D0059001E
	move.b	$0021(a5),$001C(a4)	;196D0021001C
	move.b	CurrentTower+$1.l,$0023(a4)	;19790000F98B0023
adrCd00478A:	jsr	adrCd00E33A.l	;4EB90000E33A
	bsr	adrCd008FCA	;61004838
	bra	adrCd003A3E	;6000F2A8

adrCd004798:	bsr	adrCd004826	;6100008C
	move.b	#$FF,$26(a5,d2.w)	;1BBC00FF2026
	cmp.w	$0016(a5),d2	;B46D0016
	bne.s	adrCd0047AE	;6606
	move.w	#$FFFF,$0016(a5)	;3B7CFFFF0016
adrCd0047AE:	bsr	adrCd00480C	;6100005C
	move.w	d1,d3	;3601
adrCd0047B4:	move.b	$19(a5,d1.w),$18(a5,d1.w)	;1BB510191018
	addq.w	#$01,d1	;5241
	cmp.w	#$0003,d1	;0C410003
	bcs.s	adrCd0047B4	;65F2
	move.b	#$FF,$001B(a5)	;1B7C00FF001B
	cmp.b	#$03,$0015(a5)	;0C2D00030015
	bne.s	adrCd0047E6	;6616
	cmp.b	$000F(a5),d3	;B62D000F
	bne.s	adrCd0047E0	;660A
	move.l	d7,-(sp)	;2F07
	bsr	Click_OpenInventory	;610030E2
	move.l	(sp)+,d7	;2E1F
	rts	;4E75

adrCd0047E0:	bcc.s	adrCd0047E6	;6404
	subq.b	#$01,$000F(a5)	;532D000F
adrCd0047E6:	rts	;4E75

adrCd0047E8:	moveq	#$00,d1	;7200
adrCd0047EA:	tst.b	$18(a5,d1.w)	;4A351018
	bmi.s	adrCd0047F8	;6B08
	addq.w	#$01,d1	;5241
	cmp.w	#$0003,d1	;0C410003
	bcs.s	adrCd0047EA	;65F2
adrCd0047F8:	rts	;4E75

adrCd0047FA:	lea	Player1_Data.l,a5	;4BF90000F9D8
	bsr.s	adrCd00480C	;610A
	tst.w	d1	;4A41
	bpl.s	adrCd0047F8	;6AF2
	lea	Player2_Data.l,a5	;4BF90000FA3A
adrCd00480C:	move.w	d2,-(sp)	;3F02
	moveq	#$03,d1	;7203
adrLp004810:	move.b	$18(a5,d1.w),d2	;14351018
	bmi.s	adrCd00481E	;6B08
	and.w	#$000F,d2	;0242000F
	cmp.b	d2,d0	;B002
	beq.s	adrCd004822	;6704
adrCd00481E:	dbra	d1,adrLp004810	;51C9FFF0
adrCd004822:	move.w	(sp)+,d2	;341F
	rts	;4E75

adrCd004826:	moveq	#$03,d2	;7403
adrLp004828:	cmp.b	$26(a5,d2.w),d0	;B0352026
	beq.s	adrCd004832	;6704
	dbra	d2,adrLp004828	;51CAFFF8
adrCd004832:	rts	;4E75

adrCd004834:	bsr	adrJC0089F0	;610041BA
	tst.w	d2	;4A42
	bne.s	adrCd004850	;6614
	lea	adrEA004961.l,a6	;4DF900004961
	move.b	d7,$0005(a6)	;1D470005
adrCd004846:	clr.w	$0042(a5)	;426D0042
	jmp	adrCd00E33A.l	;4EF90000E33A

adrCd004850:	move.w	#$0001,$0044(a5)	;3B7C00010044
	bra.s	adrCd00485E	;6006

adrCd004858:	move.w	#$0003,$0044(a5)	;3B7C00030044
adrCd00485E:	move.b	#$01,$004E(a5)	;1B7C0001004E
	lea	adrEA004934.l,a6	;4DF900004934
	move.b	d7,$0007(a6)	;1D470007
	jsr	adrCd00E340.l	;4EB90000E340
	bra	adrCd008AC4	;6000424E

adrJC004878:	tst.b	$004E(a5)	;4A2D004E
	bne.s	adrCd0048A8	;662A
	moveq	#$12,d7	;7E12
	moveq	#$03,d1	;7203
	moveq	#$00,d2	;7400
adrLp004884:	move.b	$18(a5,d1.w),d0	;10351018
	bmi.s	adrCd004898	;6B0E
	btst	#$06,d0	;08000006
	bne.s	adrCd004898	;6608
	btst	#$05,d0	;08000005
	beq.s	adrCd004898	;6702
	addq.w	#$01,d2	;5242
adrCd004898:	dbra	d1,adrLp004884	;51C9FFEA
	tst.w	d2	;4A42
	bne.s	adrCd004858	;66B8
	lea	adrEA00497D.l,a6	;4DF90000497D
	bra.s	adrCd004846	;609E

adrCd0048A8:	bsr	adrCd004912	;61000068
	move.b	d0,$0053(a5)	;1B400053
	and.b	#$0F,$0053(a5)	;022D000F0053
	move.b	#$01,$0014(a5)	;1B7C00010014
	lea	adrEA004977.l,a6	;4DF900004977
	move.b	$0053(a5),$0004(a6)	;1D6D00530004
	jsr	adrCd00E340.l	;4EB90000E340
	move.w	#$0101,$0040(a5)	;3B7C01010040
	bra	adrCd003A3E	;6000F168

adrJC0048D8:	moveq	#$14,d7	;7E14
	lea	adrEA004946.l,a6	;4DF900004946
	moveq	#$10,d3	;7610
	bra.s	adrCd0048EE	;600A

adrJC0048E4:	lea	adrEA00493F.l,a6	;4DF90000493F
	moveq	#$11,d7	;7E11
	moveq	#$00,d3	;7600
adrCd0048EE:	tst.b	$004E(a5)	;4A2D004E
	beq	adrCd004834	;6700FF40
	bsr.s	adrCd004912	;611A
	bclr	#$04,$19(a5,d2.w)	;08B500042019
	or.b	$19(a5,d2.w),d3	;86352019
	move.b	d3,$19(a5,d2.w)	;1B832019
	move.b	d0,(a6)	;1C80
	jsr	adrCd00E33A.l	;4EB90000E33A
	bra	adrCd003A3E	;6000F12E

adrCd004912:	lea	adrEA00896C.l,a1	;43F90000896C
	and.w	#$0003,d1	;02410003
	move.w	d1,d2	;3401
	add.w	d1,d1	;D241
	move.b	$00(a1,d1.w),d0	;10311000
	bmi.s	adrCd00492A	;6B04
	lsr.w	#$01,d1	;E249
	rts	;4E75

adrCd00492A:	move.w	#$FFFF,$000C(a5)	;3B7CFFFF000C
	addq.w	#$04,sp	;584F
	rts	;4E75

adrEA004934:	dc.b	$18	;18
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
adrEA00493F:	dc.b	$00	;00
	dc.b	$1D	;1D
	dc.b	$FA	;FA
	dc.b	$53	;53
	dc.b	$1E	;1E
	dc.b	$1F	;1F
	dc.b	$FF	;FF
adrEA004946:	dc.b	$00	;00
	dc.b	$21	;21
	dc.b	$FA	;FA
	dc.b	$53	;53
	dc.b	$22	;22
	dc.b	$23	;23
	dc.b	$FB	;FB
	dc.b	$4A	;4A
	dc.b	$FF	;FF
adrEA00494F:	dc.b	$00	;00
	dc.b	$35	;35
	dc.b	$17	;17
	dc.b	$1C	;1C
	dc.b	$30	;30
	dc.b	$FF	;FF
adrEA004955:	dc.b	$00	;00
	dc.b	$13	;13
	dc.b	$FA	;FA
	dc.b	$53	;53
	dc.b	$FF	;FF
adrEA00495A:	dc.b	$00	;00
	dc.b	$24	;24
	dc.b	$FA	;FA
	dc.b	$53	;53
	dc.b	$25	;25
	dc.b	$26	;26
	dc.b	$FF	;FF
adrEA004961:	dc.b	$1A	;1A
	dc.b	$27	;27
	dc.b	$28	;28
	dc.b	$36	;36
	dc.b	$1C	;1C
	dc.b	$00	;00
	dc.b	$FF	;FF
adrEA004968:	dc.b	$1A	;1A
	dc.b	$19	;19
	dc.b	$16	;16
	dc.b	$2A	;2A
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$30	;30
	dc.b	$FA	;FA
	dc.b	$53	;53
	dc.b	$FF	;FF
adrEA004972:	dc.b	$00	;00
	dc.b	$32	;32
	dc.b	$25	;25
	dc.b	$26	;26
	dc.b	$FF	;FF
adrEA004977:	dc.b	$12	;12
	dc.b	$FB	;FB
	dc.b	$4A	;4A
	dc.b	$34	;34
	dc.b	$00	;00
	dc.b	$FF	;FF
adrEA00497D:	dc.b	$20	;20
	dc.b	$35	;35
	dc.b	$36	;36
	dc.b	$FF	;FF
adrEA004981:	dc.b	$37	;37
	dc.b	$12	;12
	dc.b	$FB	;FB
	dc.b	$4A	;4A
	dc.b	$38	;38
	dc.b	$FF	;FF
adrEA004987:	dc.b	$39	;39
	dc.b	$35	;35
	dc.b	$3D	;3D
	dc.b	$FB	;FB
	dc.b	$3A	;3A
	dc.b	$3B	;3B
	dc.b	$FF	;FF

adrCd00498E:	lea	adrEA014EA4.l,a4	;49F900014EA4
	btst	#$00,(a5)	;08150000
	beq.s	adrCd00499E	;6704
	add.w	#$0010,a4	;D8FC0010
adrCd00499E:	rts	;4E75

adrJC0049A0:	move.w	$0004(a5),d1	;322D0004
	sub.w	$0008(a5),d1	;926D0008
	cmp.w	#$0037,d1	;0C410037
	bcs.s	adrCd0049C8	;651A
	move.w	$0002(a5),d1	;322D0002
	lsr.w	#$05,d1	;EA49
	and.w	#$0003,d1	;02410003
	addq.w	#$01,d1	;5241
adrCd0049BA:	bchg	d1,$003E(a5)	;036D003E
	move.w	d1,d7	;3E01
	bsr	adrCd008C4A	;61004288
	bra	adrCd008C2C	;60004266

adrCd0049C8:	moveq	#$00,d1	;7200
	cmp.w	#$0030,$0002(a5)	;0C6D00300002
	bcs.s	adrCd0049BA	;65E8
	move.b	$003E(a5),d0	;102D003E
	and.b	#$0E,d0	;0200000E
	bne.s	adrCd004A4C	;6670
	clr.w	$0042(a5)	;426D0042
	clr.w	$0044(a5)	;426D0044
	move.w	#$FFFF,$0040(a5)	;3B7CFFFF0040
	clr.b	$003E(a5)	;422D003E
	bra	adrCd008894	;60003EA4

adrJC0049F2:	move.l	adrEA00F992.l,d1	;22390000F992
	move.w	#$FFFF,Paused_Marker.l	;33FCFFFF000099EC
	lea	_custom+color.l,a0	;41F900DFF180
	move.w	#$0400,(a0)	;30BC0400
	move.w	#$0400,$001E(a0)	;317C0400001E
adrCd004A10:	move.b	adrB_00F9D9.l,d0	;10390000F9D9
	or.b	adrB_00FA3B.l,d0	;80390000FA3B
	bpl.s	adrCd004A10	;6AF2
	clr.w	(a0)	;4250
	clr.w	$001E(a0)	;4268001E
	move.l	d1,adrEA00F992.l	;23C10000F992
	and.b	#$7F,adrB_00F9D9.l	;0239007F0000F9D9
	and.b	#$7F,adrB_00FA3B.l	;0239007F0000FA3B
	clr.b	adrB_00FA2E.l	;42390000FA2E
	clr.b	adrB_00FA90.l	;42390000FA90
	clr.w	Paused_Marker.l	;4279000099EC
adrCd004A4C:	rts	;4E75

adrCd004A4E:	lea	Player1_Data.l,a5	;4BF90000F9D8
	bsr	adrCd004A9E	;61000048
	bsr	adrCd00884C	;61003DF2
	btst	#$06,$0018(a5)	;082D00060018
	beq.s	adrCd004A68	;6704
	bsr	adrCd002C14	;6100E1AE
adrCd004A68:	tst.w	Multiplayer.l	;4A790000F98C
	bmi.s	adrCd004A8A	;6B1A
	lea	Player2_Data.l,a5	;4BF90000FA3A
	bsr	adrCd004A9E	;61000026
	bsr	adrCd008866	;61003DEA
	btst	#$06,$0018(a5)	;082D00060018
	beq.s	adrCd004A8A	;6704
	bsr	adrCd002C14	;6100E18C
adrCd004A8A:	jsr	adrCd009A9A.l	;4EB900009A9A
	bsr	adrCd009B54	;610050C2
	move.w	#$FFFF,adrB_0099EE.l	;33FCFFFF000099EE
	rts	;4E75

adrCd004A9E:	and.b	#$01,(a5)	;02150001
	clr.b	$0056(a5)	;422D0056
	clr.w	$0014(a5)	;426D0014
	clr.b	$003C(a5)	;422D003C
	clr.b	$003E(a5)	;422D003E
	clr.b	$0050(a5)	;422D0050
	move.w	#$FFFF,$000C(a5)	;3B7CFFFF000C
	rts	;4E75

Click_LoadSaveGame:
	move.l	adrEA00F992.l,-(sp)	;2F390000F992
	clr.w	adrB_0099EE.l	;4279000099EE
	move.l	#$00067D00,screen_ptr.l	;23FC00067D0000009B06
	move.l	#$00060000,framebuffer_ptr.l	;23FC0006000000009B0A
	lea	Player1_Data.l,a5	;4BF90000F9D8
	lea	F1_F2_F10_Msg.l,a6	;4DF900004C66
	jsr	adrCd00DA6E.l	;4EB90000DA6E
	tst.w	Multiplayer.l	;4A790000F98C
	bne.s	.skipPlayer2	;6612
	lea	Player2_Data.l,a5	;4BF90000FA3A
	lea	F1_F2_F10_Msg.l,a6	;4DF900004C66
	jsr	adrCd00DA6E.l	;4EB90000DA6E
.skipPlayer2:
	clr.b	KeyboardKeyCode.l	;423900000595
	bsr	adrCd009A9A	;61004F88
.PickLoadSaveGame_Loop:
	move.b	KeyboardKeyCode.l,d0	;103900000595
	cmp.b	#$50,d0	;0C000050
	beq.s	LoadGame	;671E
	cmp.b	#$51,d0	;0C000051
	beq	SaveGame	;6700002E
	cmp.b	#$59,d0	;0C000059
	bne.s	.PickLoadSaveGame_Loop	;66E6
adrCd004B2E:
	move.l	(sp)+,adrEA00F992.l	;23DF0000F992
	clr.b	KeyboardKeyCode.l	;423900000595
	bra	adrCd004A4E	;6000FF12

LoadGame:
	moveq	#$00,d0	;7000
	bsr	adrCd004B7C	;6100003A
	bcs.s	adrCd004B2E	;65E8
	bsr	adrCd004BDE	;61000096
	tst.l	d0	;4A80
	bmi.s	LoadGame	;6BF0
	bsr	adrCd000ED4	;6100C384
	bra.s	adrCd004B2E	;60DA

SaveGame:	moveq	#$01,d0	;7001
	bsr	adrCd004B7C	;61000024
	bcs.s	adrCd004B2E	;65D2
	bsr	adrCd004C1E	;610000C0
	tst.l	d0	;4A80
	bmi.s	SaveGame	;6BF0
	bra.s	adrCd004B2E	;60C8

AwaitDisk:
	lea	InsertLoadDiskMsg.l,a6	;4DF900004C87
	tst.w	d0	;4A40
	beq.s	.PickLoadSaveMessage	;6706
	lea	InsertSaveDiskMsg.l,a6	;4DF900004CAF
.PickLoadSaveMessage:
	jmp	adrCd00DA6E.l	;4EF90000DA6E

adrCd004B7C:
	lea	Player1_Data.l,a5	;4BF90000F9D8
	tst.w	Multiplayer.l	;4A790000F98C
	bne.s	adrCd004B96	;660C
	move.w	d0,-(sp)	;3F00
	bsr.s	AwaitDisk	;61D8
	move.w	(sp)+,d0	;301F
	lea	Player2_Data.l,a5	;4BF90000FA3A
adrCd004B96:
	bsr.s	AwaitDisk	;61CE
	clr.b	KeyboardKeyCode.l	;423900000595
	bsr	adrCd009A9A	;61004EFA
adrCd004BA2:
	move.b	KeyboardKeyCode.l,d0	;103900000595
	cmp.b	#$44,d0	;0C000044
	beq.s	adrCd004BC0	;6712
	cmp.b	#$43,d0	;0C000043
	beq.s	adrCd004BC0	;670C
	cmp.b	#$59,d0	;0C000059
	bne.s	adrCd004BA2	;66E8
	sub.b	#$FF,d0	;040000FF
	rts	;4E75

adrCd004BC0:
	moveq	#$3C,d0	;703C
	tst.w	Multiplayer.l	;4A790000F98C
	beq.s	adrCd004BCC	;6702
	moveq	#$46,d0	;7046
adrCd004BCC:
	move.w	d0,adrW_004C1C.l	;33C000004C1C
	rts	;4E75

adrCd004BD4:
	jsr	adrCd009648.l	;4EB900009648
	moveq	#-$01,d0	;70FF
	rts	;4E75

adrCd004BDE:
	jsr	CopyProtection.l	;4EB90000DB18
	tst.l	d0	;4A80
	beq.s	adrCd004BD4	;67EC
	move.l	screen_ptr.l,adrL_0092F0.l	;23F900009B06000092F0
	jsr	adrCd0094AE.l	;4EB9000094AE
	move.w	adrW_004C1C.l,d7	;3E3900004C1C
	jsr	adrCd00965E.l	;4EB90000965E
	lea	CharacterStats.l,a0	;41F90000F586
	moveq	#$08,d0	;7008
	jsr	adrCd009490.l	;4EB900009490
	jsr	adrCd009648.l	;4EB900009648
	moveq	#$00,d0	;7000
	rts	;4E75

adrW_004C1C:
	dc.w	$0000	;0000

adrCd004C1E:
	jsr	CopyProtection.l			;4EB90000DB18
	tst.l	d0				;4A80
	beq.s	adrCd004BD4			;67AC
	move.l	screen_ptr.l,adrL_0092F0.l	;23F900009B06000092F0
	jsr	adrCd0094AE.l			;4EB9000094AE
	move.w	adrW_004C1C.l,d7		;3E3900004C1C
	jsr	adrCd00965E.l			;4EB90000965E
	lea	CharacterStats.l,a0		;41F90000F586
	moveq	#$00,d0				;7000
	move.w	adrW_004C1C.l,d0		;303900004C1C
	moveq	#$00,d1				;7200
	moveq	#$08,d7				;7E08
	jsr	adrLp0092F4.l			;4EB9000092F4
	jsr	adrCd009648.l			;4EB900009648
	moveq	#$00,d0				;7000
	rts					;4E75

F1_F2_F10_Msg:	dc.b	'F1 - LOAD, F2 - SAVE, F10 - EXIT'	;4631202D204C4F41442C204632202D20534156452C20463130202D2045584954
	dc.b	$FF	;FF
InsertLoadDiskMsg:	dc.b	'INSERT LOAD DISK AND RETURN, F10 - EXIT'	;494E53455254204C4F4144204449534B20414E442052455455524E2C20463130202D2045584954
	dc.b	$FF	;FF
InsertSaveDiskMsg:	dc.b	'INSERT SAVE DISK AND RETURN, F10 - EXIT'	;494E534552542053415645204449534B20414E442052455455524E2C20463130202D2045584954
	dc.b	$FF	;FF
	dc.b	$00	;00

Click_SleepParty:
	move.b	#$03,$004F(a5)	;1B7C0003004F
	clr.w	$0014(a5)	;426D0014
	move.w	#$FFFF,$0042(a5)	;3B7CFFFF0042
	move.w	#$FFFF,$0040(a5)	;3B7CFFFF0040
	move.b	#$FF,$0035(a5)	;1B7C00FF0035
	moveq	#$03,d7	;7E03
adrLp004CF6:	move.b	$18(a5,d7.w),d0	;10357018
	and.w	#$00C0,d0	;024000C0
	bne.s	adrCd004D16	;6616
	move.b	$18(a5,d7.w),d0	;10357018
	bsr	adrCd0072D4	;610025CE
	clr.b	$0015(a4)	;422C0015
	move.b	#$FF,$0017(a4)	;197C00FF0017
	clr.b	$0018(a4)	;422C0018
adrCd004D16:	dbra	d7,adrLp004CF6	;51CFFFDE
	bsr	adrCd008894	;61003B78
	bsr	adrCd008FFC	;610042DC
adrCd004D22:	bsr	adrCd002C3A	;6100DF16
	and.b	#$01,(a5)	;02150001
	bset	#$02,(a5)	;08D50002
	move.b	#$32,$003F(a5)	;1B7C0032003F
	move.b	#$02,$0014(a5)	;1B7C00020014
	clr.b	$004E(a5)	;422D004E
	move.b	#$01,$0052(a5)	;1B7C00010052
	clr.b	$004A(a5)	;422D004A
	tst.b	$004B(a5)	;4A2D004B
	bmi.s	adrCd004D54	;6B06
	move.w	#$00FF,$004A(a5)	;3B7C00FF004A
adrCd004D54:	lea	ThouArtAsleep.l,a6	;4DF900004D66
	jsr	adrCd00DAA6.l	;4EB90000DAA6
	jmp	adrCd00D9B4.l	;4EF90000D9B4

ThouArtAsleep:	dc.b	$FC	;FC
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

adrCd004D80:	move.l	a4,-(sp)	;2F0C
	asl.w	#$02,d0	;E540
	lea	adrEA004DCC.l,a6	;4DF900004DCC
	add.w	d0,a6	;DCC0
	link	a3,#-$0020	;4E53FFE0	;fix reqd for Devpac
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	$000A(a5),a0	;D0ED000A
	add.w	#$01EC,a0	;D0FC01EC
	move.l	a0,-$0008(a3)	;2748FFF8
	lea	_GFX_Fairy.l,a1	;43F900041C80
	moveq	#$08,d4	;7808
	moveq	#$05,d5	;7A05
	moveq	#$28,d7	;7E28
	moveq	#$00,d6	;7C00
	bsr	adrCd00BBCA	;61006E18
	lea	_GFX_Fairy.l,a1	;43F900041C80
	moveq	#$17,d4	;7817
	moveq	#$05,d5	;7A05
	moveq	#$28,d7	;7E28
	moveq	#-$01,d6	;7CFF
	bsr	adrCd00BBCA	;61006E06
	unlk	a3	;4E5B
	move.l	(sp)+,a4	;285F
	rts	;4E75

adrEA004DCC:	dc.w	$0504	;0504
	dc.w	$0806	;0806
	dc.w	$0B04	;0B04
	dc.w	$080D	;080D
	dc.w	$0904	;0904
	dc.w	$080C	;080C
	dc.w	$0704	;0704
	dc.w	$0808	;0808
	dc.w	$0A0C	;0A0C
	dc.w	$0D0B	;0D0B
adrEA004DE0:	dc.w	$060D	;060D
	dc.w	$0C08	;0C08
	dc.w	$0B00	;0B00
adrEA004DE6:	dc.b	$1C	;1C
	dc.b	$1B	;1B
	dc.b	$11	;11
	dc.b	$07	;07
	dc.b	$0D	;0D
	dc.b	$16	;16
	dc.b	$0A	;0A
	dc.b	$00	;00
	dc.b	$18	;18
	dc.b	$12	;12
	dc.b	$1D	;1D
	dc.b	$0B	;0B
	dc.b	$17	;17
	dc.b	$0E	;0E
	dc.b	$01	;01
	dc.b	$04	;04
	dc.b	$1E	;1E
	dc.b	$0F	;0F
	dc.b	$14	;14
	dc.b	$19	;19
	dc.b	$13	;13
	dc.b	$02	;02
	dc.b	$05	;05
	dc.b	$08	;08
	dc.b	$1A	;1A
	dc.b	$1F	;1F
	dc.b	$15	;15
	dc.b	$09	;09
	dc.b	$10	;10
	dc.b	$06	;06
	dc.b	$0C	;0C
	dc.b	$03	;03
	dc.b	$27	;27
	dc.b	$26	;26
	dc.b	$25	;25
	dc.b	$24	;24
	dc.b	$23	;23
	dc.b	$22	;22
	dc.b	$21	;21
	dc.b	$20	;20
adrEA004E0E:	dc.w	$0001	;0001
	dc.w	$0200	;0200
	dc.w	$0001	;0001
	dc.w	$0204	;0204
	dc.w	$0004	;0004
	dc.w	$0104	;0104
	dc.w	$0103	;0103
	dc.w	$0206	;0206
	dc.w	$0305	;0305
	dc.w	$0603	;0603
	dc.w	$0505	;0505
	dc.w	$0203	;0203
	dc.w	$0704	;0704
	dc.w	$0706	;0706
	dc.w	$0705	;0705
	dc.w	$0706	;0706

adrCd004E2E:	move.b	$004E(a5),d0	;102D004E
	beq	adrCd004ED2	;6700009E
	subq.b	#$01,d0	;5300
	beq	adrCd004F68	;6700012E
	subq.b	#$01,d0	;5300
	beq	adrCd005170	;67000330
	subq.b	#$01,d0	;5300
	beq	adrCd005352	;6700050C
	bclr	#$07,$0001(a5)	;08AD00070001
	beq	adrCd005484	;67000634
	move.l	$0002(a5),d1	;222D0002
	sub.w	$0008(a5),d1	;926D0008
	cmp.b	#$42,d1	;0C010042
	bcs	adrCd005484	;65000624
	cmp.b	#$54,d1	;0C010054
	bcc	adrCd005484	;6400061C
	swap	d1	;4841
	sub.b	#$70,d1	;04010070
	lsr.w	#$04,d1	;E849
	cmp.b	#$04,d1	;0C010004
	bcs.s	adrCd004E84	;650C
	cmp.b	#$05,d1	;0C010005
	beq	adrCd004F24	;670000A6
	bra	adrCd005484	;60000602

adrCd004E84:	moveq	#$00,d7	;7E00
	move.b	$004F(a5),d7	;1E2D004F
	move.b	$18(a5,d7.w),d0	;10357018
	bsr	adrCd0072D4	;61002444
	lsr.w	#$01,d0	;E248
	lea	adrEA014CA4.l,a0	;41F900014CA4
	add.w	d0,a0	;D0C0
	move.b	d1,$000F(a4)	;1941000F
	move.b	#$01,$0022(a4)	;197C00010022
	lea	adrEA004DE6.l,a6	;4DF900004DE6
	asl.w	#$03,d1	;E741
	add.w	d1,a6	;DCC1
	moveq	#$07,d1	;7207
	move.l	$0010(a4),d7	;2E2C0010
	moveq	#$00,d0	;7000
adrLp004EB8:	move.b	$00(a6,d1.w),d0	;10361000
	clr.b	$00(a0,d0.w)	;42300000
	eor.b	#$1F,d0	;0A00001F
	bclr	d0,d7	;0187
	dbra	d1,adrLp004EB8	;51C9FFF0
	move.l	d7,$0010(a4)	;29470010
	bra	adrCd004F24	;60000054

adrCd004ED2:	tst.b	$003F(a5)	;4A2D003F
	bmi	adrCd005484	;6B0005AC
	subq.b	#$01,$003F(a5)	;532D003F
	bpl	adrCd005484	;6A0005A4
	moveq	#$00,d7	;7E00
adrCd004EE4:	move.b	$004F(a5),d7	;1E2D004F
	bmi	adrCd005484	;6B00059A
	move.b	$18(a5,d7.w),d0	;10357018
	and.w	#$00E0,d0	;024000E0
	bne.s	adrCd004F1E	;6628
	move.b	$18(a5,d7.w),d0	;10357018
	and.w	#$000F,d0	;0240000F
	lea	adrEA00549A.l,a6	;4DF90000549A
	move.b	d0,(a6)	;1C80
	bsr	adrCd0072D4	;610023CC
	cmp.b	#$EC,$0020(a4)	;0C2C00EC0020
	bcc	adrCd00546E	;6400055C
	move.b	$0022(a4),d0	;102C0022
	and.w	#$007F,d0	;0240007F
	bne.s	adrCd004F24	;6606
adrCd004F1E:	subq.b	#$01,$004F(a5)	;532D004F
	bra.s	adrCd004EE4	;60C0

adrCd004F24:	bsr	adrCd00510C	;610001E6
	moveq	#$05,d0	;7005
	bsr	adrCd004D80	;6100FE54
	or.b	#$40,$0054(a5)	;002D00400054
	jsr	adrCd00DA7A.l	;4EB90000DA7A
	moveq	#$00,d7	;7E00
	move.b	$004F(a5),d7	;1E2D004F
	move.b	$18(a5,d7.w),d0	;10357018
	and.w	#$000F,d0	;0240000F
	clr.b	$0052(a5)	;422D0052
	jsr	adrCd00E2B2.l	;4EB90000E2B2
	lea	adrEA0053F4.l,a6	;4DF9000053F4
	jsr	adrLp00D9F4.l	;4EB90000D9F4
	move.b	#$01,$004E(a5)	;1B7C0001004E
	bra	adrCd005484	;6000051E

adrCd004F68:	bclr	#$07,$0001(a5)	;08AD00070001
	beq	adrCd005484	;67000514
	move.l	$0002(a5),d1	;222D0002
	sub.w	$0008(a5),d1	;926D0008
	cmp.b	#$42,d1	;0C010042
	bcs	adrCd005484	;65000504
	cmp.b	#$54,d1	;0C010054
	bcc	adrCd005484	;640004FC
	swap	d1	;4841
	moveq	#$00,d7	;7E00
	move.b	$004F(a5),d7	;1E2D004F
	move.b	$18(a5,d7.w),d0	;10357018
	bsr	adrCd0072D4	;6100233C
	move.w	d1,d0	;3001
	sub.b	#$68,d0	;04000068
	bcs	adrCd005484	;650004E2
	tst.b	$000F(a4)	;4A2C000F
	bmi.s	adrCd004FB0	;6B06
	subq.w	#$08,d0	;5140
	bcs	adrCd005484	;650004D6
adrCd004FB0:	lsr.w	#$04,d0	;E848
	cmp.w	#$0004,d0	;0C400004
	bcs.s	adrCd005002	;654A
	bne.s	adrCd004FEA	;6630
	tst.b	$000F(a4)	;4A2C000F
	bpl	adrCd005484	;6A0004C4
	move.b	#$7F,$000F(a4)	;197C007F000F
	bsr	adrCd00510C	;61000142
	move.b	#$FF,$000F(a4)	;197C00FF000F
	moveq	#$04,d0	;7004
	bsr	adrCd004D80	;6100FDAA
	lea	adrEA005457.l,a6	;4DF900005457
	bsr	adrCd00532A	;6100034A
	move.b	#$04,$004E(a5)	;1B7C0004004E
	rts	;4E75

adrCd004FEA:	sub.b	#$C0,d1	;040100C0
	bcs	adrCd005484	;65000494
	cmp.b	#$10,d1	;0C010010
	bcc	adrCd005484	;6400048C
	subq.b	#$01,$004F(a5)	;532D004F
	bra	adrCd004D22	;6000FD22

adrCd005002:	cmp.b	$000F(a4),d0	;B02C000F
	bne.s	adrCd00500A	;6602
	moveq	#$04,d0	;7004
adrCd00500A:	move.w	d0,-(sp)	;3F00
	bsr	adrCd002C3A	;6100DC2C
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	$000A(a5),a0	;D0ED000A
	add.w	#$0A90,a0	;D0FC0A90
	moveq	#$74,d0	;7074
	move.w	$0012(a5),d3	;362D0012
	jsr	adrCd00D3DE.l	;4EB90000D3DE
	move.w	(sp),d0	;3017
	bsr	adrCd004D80	;6100FD52
	moveq	#$00,d0	;7000
	move.b	$004F(a5),d0	;102D004F
	move.b	$18(a5,d0.w),d0	;10350018
	bsr	adrCd0072D4	;61002298
	move.l	$0010(a4),d7	;2E2C0010
	lea	adrEA004DE6.l,a6	;4DF900004DE6
	move.w	(sp),d1	;3217
	cmp.b	#$04,d1	;0C010004
	bne.s	adrCd005054	;6604
	move.b	$000F(a4),d1	;122C000F
adrCd005054:	asl.w	#$03,d1	;E741
	add.w	d1,a6	;DCC1
	moveq	#$00,d0	;7000
	moveq	#-$01,d2	;74FF
	moveq	#$07,d1	;7207
adrLp00505E:	move.b	$00(a6,d1.w),d0	;10361000
	eor.b	#$1F,d0	;0A00001F
	btst	d0,d7	;0107
	bne.s	adrCd005072	;6608
	move.w	d1,d2	;3401
	tst.l	d2	;4A82
	bpl.s	adrCd005080	;6A10
	swap	d2	;4842
adrCd005072:	dbra	d1,adrLp00505E	;51C9FFEA
	move.w	#$FFFF,$0044(a5)	;3B7CFFFF0044
	tst.l	d2	;4A82
	bmi.s	adrCd005092	;6B12
adrCd005080:	move.b	d2,$0045(a5)	;1B420045
	swap	d2	;4842
	move.b	d2,$0044(a5)	;1B420044
	lea	adrEA005412.l,a6	;4DF900005412
	bra.s	adrCd005098	;6006

adrCd005092:	lea	adrEA005429.l,a6	;4DF900005429
adrCd005098:	bsr	adrCd00532A	;61000290
	move.w	(sp)+,d1	;321F
	lea	adrEA004DE0.l,a6	;4DF900004DE0
	move.b	$00(a6,d1.w),adrB_00E3FB.l	;13F610000000E3FB
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	$000A(a5),a0	;D0ED000A
	add.w	#$03D2,a0	;D0FC03D2
	asl.w	#$03,d1	;E741
	addq.w	#$06,d1	;5C41
	add.w	d1,a6	;DCC1
	moveq	#$00,d0	;7000
	move.b	$0044(a5),d0	;102D0044
	bmi.s	adrCd0050D0	;6B08
	move.b	$00(a6,d0.w),d0	;10360000
	move.b	d0,$0044(a5)	;1B400044
adrCd0050D0:	bsr	adrCd0050EE	;6100001C
	move.b	$0045(a5),d0	;102D0045
	bmi.s	adrCd0050E6	;6B0C
	move.b	$00(a6,d0.w),d0	;10360000
	move.b	d0,$0045(a5)	;1B400045
	bsr	adrCd0050EE	;6100000A
adrCd0050E6:	move.b	#$02,$004E(a5)	;1B7C0002004E
	rts	;4E75

adrCd0050EE:	tst.b	d0	;4A00
	bmi.s	adrCd00510A	;6B18
	movem.l	d0/a0/a6,-(sp)	;48E78082
	bsr	adrCd006246	;6100114E
	moveq	#$07,d6	;7C07
	jsr	adrLp00D9F4.l	;4EB90000D9F4
	movem.l	(sp)+,d0/a0/a6	;4CDF4101
	lea	$01B8(a0),a0	;41E801B8
adrCd00510A:	rts	;4E75

adrCd00510C:	bsr	adrCd002C3A	;6100DB2C
	jsr	adrCd00D9B4.l	;4EB90000D9B4
	moveq	#$00,d7	;7E00
	move.b	$004F(a5),d7	;1E2D004F
	move.b	$18(a5,d7.w),d0	;10357018
	bsr	adrCd0072D4	;610021B2
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	$000A(a5),a0	;D0ED000A
	lea	$0A86(a0),a0	;41E80A86
	moveq	#$03,d7	;7E03
	tst.b	$000F(a4)	;4A2C000F
	bpl.s	adrLp00513E	;6A04
	addq.w	#$01,d7	;5247
	subq.w	#$01,a0	;5348
adrLp00513E:	move.w	d7,d0	;3007
	subq.w	#$03,d0	;5740
	tst.b	$000F(a4)	;4A2C000F
	bpl.s	adrCd00514A	;6A02
	subq.w	#$01,d0	;5340
adrCd00514A:	neg.w	d0	;4440
	cmp.b	$000F(a4),d0	;B02C000F
	bne.s	adrCd005154	;6602
	moveq	#$04,d0	;7004
adrCd005154:	add.w	#$0050,d0	;06400050
	jsr	adrCd00D3DE.l	;4EB90000D3DE
	dbra	d7,adrLp00513E	;51CFFFDE
	moveq	#$74,d0	;7074
	addq.w	#$02,a0	;5448
	move.w	$0012(a5),d3	;362D0012
	jmp	adrCd00D3DE.l	;4EF90000D3DE

adrCd005170:	bclr	#$07,$0001(a5)	;08AD00070001
	beq.s	adrCd00510A	;6792
	move.l	$0002(a5),d1	;222D0002
	sub.w	$0008(a5),d1	;926D0008
	cmp.w	#$0018,d1	;0C410018
	bcs.s	adrCd00510A	;6584
	cmp.w	#$0027,d1	;0C410027
	bcs.s	adrCd0051B2	;6526
	sub.b	#$42,d1	;04010042
	bcs	adrCd00510A	;6500FF78
	cmp.b	#$10,d1	;0C010010
	bcc	adrCd00510A	;6400FF70
	swap	d1	;4841
	sub.w	#$00C0,d1	;044100C0
	bcs	adrCd00510A	;6500FF66
	cmp.b	#$10,d1	;0C010010
	bcc	adrCd00510A	;6400FF5E
	bra	adrCd004F24	;6000FD74

adrCd0051B2:	swap	d1	;4841
	sub.b	#$90,d1	;04010090
	bcs	adrCd00510A	;6500FF50
	cmp.b	#$40,d1	;0C010040
	bcc	adrCd00510A	;6400FF48
	swap	d1	;4841
	sub.w	#$0018,d1	;04410018
	lsr.w	#$03,d1	;E649
	move.b	$44(a5,d1.w),d0	;10351044
	bmi	adrCd00510A	;6B00FF38
	move.b	d0,$0044(a5)	;1B400044
	jsr	adrCd00DA7A.l	;4EB90000DA7A
	lea	adrEA0174DC.l,a3	;47F9000174DC
	moveq	#$00,d0	;7000
	move.b	$0044(a5),d0	;102D0044
	jsr	adrCd00E2AE.l	;4EB90000E2AE
	jsr	adrCd00D9FE.l	;4EB90000D9FE
	move.l	#$00100018,d5	;2A3C00100018
	add.w	$0008(a5),d5	;DA6D0008
	move.l	#$003F0090,d4	;283C003F0090
	moveq	#$00,d3	;7600
	jsr	adrCd00E538.l	;4EB90000E538
	moveq	#$00,d0	;7000
	move.b	$004F(a5),d0	;102D004F
	move.b	$18(a5,d0.w),d0	;10350018
	bsr	adrCd0072D4	;610020BA
	move.b	$0044(a5),d0	;102D0044
	cmp.b	#$20,d0	;0C000020
	bcc.s	adrCd00522C	;6406
	bsr	adrCd0075DC	;610023B4
	bra.s	adrCd00522E	;6002

adrCd00522C:	moveq	#$04,d0	;7004
adrCd00522E:	lea	adrEA004DE0.l,a6	;4DF900004DE0
	move.b	$00(a6,d0.w),adrB_00E3FB.l	;13F600000000E3FB
	add.w	#$0050,d0	;06400050
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	$000A(a5),a0	;D0ED000A
	lea	$0A86(a0),a0	;41E80A86
	jsr	adrCd00D3DE.l	;4EB90000D3DE
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	$000A(a5),a0	;D0ED000A
	lea	$03D2(a0),a0	;41E803D2
	moveq	#$00,d0	;7000
	move.b	$0044(a5),d0	;102D0044
	bsr	adrCd0050EE	;6100FE84
	bsr	adrCd0052F4	;61000086
	lea	adrEA0053CE.l,a6	;4DF9000053CE
	swap	d0	;4840
	move.b	d1,d0	;1001
	jsr	adrCd00D8DA.l	;4EB90000D8DA
	move.b	d1,$000E(a6)	;1D41000E
	ror.w	#$08,d1	;E059
	cmp.b	#$30,d1	;0C010030
	bne.s	adrCd00528E	;6602
	moveq	#$20,d1	;7220
adrCd00528E:	move.b	d1,$000D(a6)	;1D41000D
	swap	d0	;4840
	jsr	adrCd00D8DA.l	;4EB90000D8DA
	move.w	d1,$0012(a6)	;3D410012
	jsr	adrCd00DAA6.l	;4EB90000DAA6
	moveq	#$00,d0	;7000
	move.b	$004F(a5),d0	;102D004F
	move.b	$18(a5,d0.w),d0	;10350018
	bsr	adrCd0072D4	;61002024
	moveq	#$00,d0	;7000
	move.b	$0044(a5),d0	;102D0044
	cmp.b	#$20,d0	;0C000020
	bcs.s	adrCd0052D4	;6516
	moveq	#$27,d1	;7227
	sub.w	d0,d1	;9240
	move.b	$000F(a4),d0	;102C000F
	lea	adrEA004DE6.l,a6	;4DF900004DE6
	asl.w	#$03,d0	;E740
	add.w	d1,d0	;D041
	move.b	$00(a6,d0.w),d0	;10360000
adrCd0052D4:	move.b	d0,$0017(a4)	;19400017
	clr.b	$0019(a4)	;422C0019
	bsr	adrCd0073AE	;610020D0
	move.b	#$FF,$0017(a4)	;197C00FF0017
	or.b	#$40,$0054(a5)	;002D00400054
	move.b	#$03,$004E(a5)	;1B7C0003004E
	rts	;4E75

adrCd0052F4:	lea	adrEA007524.l,a0	;41F900007524
	moveq	#$00,d7	;7E00
	move.b	$0044(a5),d7	;1E2D0044
	move.b	$00(a0,d7.w),d0	;10307000
	move.b	d0,d1	;1200
	asl.b	#$02,d0	;E500
	add.b	d1,d0	;D001
	cmp.b	#$20,d7	;0C070020
	bcs.s	adrCd005328	;6518
	lea	adrEA004DE6.l,a0	;41F900004DE6
	sub.w	#$0027,d7	;04470027
	neg.w	d7	;4447
	add.w	d7,a0	;D0C7
	move.b	$000F(a4),d7	;1E2C000F
	asl.w	#$03,d7	;E747
	move.b	$00(a0,d7.w),d7	;1E307000
adrCd005328:	rts	;4E75

adrCd00532A:	jsr	adrCd00DA7A.l	;4EB90000DA7A
	jsr	adrCd00DAA6.l	;4EB90000DAA6
	moveq	#$00,d0	;7000
	move.b	$004F(a5),d0	;102D004F
	move.b	$18(a5,d0.w),d0	;10350018
	and.w	#$000F,d0	;0240000F
	moveq	#$11,d6	;7C11
	jsr	adrCd00E2B2.l	;4EB90000E2B2
	jmp	adrCd00D9FE.l	;4EF90000D9FE

adrCd005352:	bclr	#$07,$0001(a5)	;08AD00070001
	beq.s	adrCd005328	;67CE
	move.l	$0002(a5),d1	;222D0002
	sub.w	$0008(a5),d1	;926D0008
	sub.b	#$42,d1	;04010042
	bcs.s	adrCd005328	;65C0
	cmp.b	#$10,d1	;0C010010
	bcc.s	adrCd005328	;64BA
	swap	d1	;4841
	sub.w	#$0070,d1	;04410070
	bcs.s	adrCd005328	;65B2
	cmp.w	#$0010,d1	;0C410010
	bcs.s	adrCd00538C	;6510
	cmp.w	#$0050,d1	;0C410050
	bcs.s	adrCd005328	;65A6
	cmp.w	#$0060,d1	;0C410060
	bcc.s	adrCd005328	;64A0
	bra	adrCd004F24	;6000FB9A

adrCd00538C:	moveq	#$00,d1	;7200
	move.b	$004F(a5),d1	;122D004F
	move.b	$18(a5,d1.w),d0	;10351018
	bsr	adrCd0072D4	;61001F3C
	bsr	adrCd0052F4	;6100FF58
	move.b	$003C(a4),d3	;162C003C
	sub.b	d0,d3	;9600
	bcs.s	adrCd0053C4	;651E
	move.b	d3,$003C(a4)	;1943003C
	eor.b	#$1F,d7	;0A07001F
	move.l	$0010(a4),d0	;202C0010
	bset	d7,d0	;0FC0
	move.l	d0,$0010(a4)	;29400010
	subq.b	#$01,$0022(a4)	;532C0022
	subq.b	#$01,$004F(a5)	;532D004F
	bra	adrCd004D22	;6000F960

adrCd0053C4:	lea	adrEA005440.l,a6	;4DF900005440
	bra	adrCd00532A	;6000FF5E

adrEA0053CE:	dc.b	$FC	;FC
	dc.b	$12	;12
	dc.b	$04	;04
	dc.b	$FE	;FE
	dc.b	$04	;04
	dc.b	'LEVEL '	;4C4556454C20
	dc.b	$FE	;FE
	dc.b	$0E	;0E
	dc.b	'  '	;2020
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
adrEA0053F4:	dc.b	' MAY BUY A SPELL-PICK A CLASS'	;204D4159204255592041205350454C4C2D5049434B204120434C415353
	dc.b	$FF	;FF
adrEA005412:	dc.b	'SELECT THY NEW SPELL, '	;53454C45435420544859204E4557205350454C4C2C20
	dc.b	$FF	;FF
adrEA005429:	dc.b	'THOU HAST ALL I GIVE, '	;54484F55204841535420414C4C204920474956452C20
	dc.b	$FF	;FF
adrEA005440:	dc.b	'I FIND THEE A PAUPER, '	;492046494E4420544845452041205041555045522C20
	dc.b	$FF	;FF
adrEA005457:	dc.b	'FORSAKE AN OLD CLASS, '	;464F5253414B4520414E204F4C4420434C4153532C20
	dc.b	$FF	;FF

adrCd00546E:	moveq	#$00,d0	;7000
	move.b	(a6),d0	;1016
	move.l	a6,-(sp)	;2F0E
	bsr.s	adrCd0054C0	;614A
	move.l	(sp)+,a6	;2C5F
	jsr	adrCd00E33A.l	;4EB90000E33A
	move.b	#$23,$003F(a5)	;1B7C0023003F
adrCd005484:	bclr	#$07,$0001(a5)	;08AD00070001
	beq.s	adrCd005498	;670C
	clr.w	$0014(a5)	;426D0014
	and.b	#$01,(a5)	;02150001
	clr.b	$0056(a5)	;422D0056
adrCd005498:	rts	;4E75

adrEA00549A:	dc.w	$002B	;002B
	dc.w	$8D2C	;8D2C
	dc.w	$FF00	;FF00
adrEA0054A0:	dc.w	$0404	;0404
	dc.w	$0404	;0404
	dc.w	$0404	;0404
	dc.w	$0404	;0404
	dc.w	$0404	;0404
	dc.w	$0404	;0404
	dc.w	$0404	;0404
	dc.w	$484B	;484B
	dc.w	$4264	;4264
	dc.w	$8DAA	;8DAA
	dc.w	$7D82	;7D82
	dc.w	$64AF	;64AF
	dc.w	$C8C8	;C8C8
	dc.w	$C8C8	;C8C8
	dc.w	$C8C8	;C8C8
	dc.w	$C8C8	;C8C8

adrCd0054C0:	cmp.b	#$10,$0001(a4)	;0C2C00100001
	bcc.s	adrCd005498	;64D0
	addq.b	#$01,(a4)	;5214
	moveq	#$00,d1	;7200
	move.b	(a4),d1	;1214
	cmp.b	#$0F,d1	;0C01000F
	bne.s	adrCd0054DA	;6606
	move.b	#$FF,$000F(a4)	;197C00FF000F
adrCd0054DA:	move.b	adrEA0054A0(pc,d1.w),$0020(a4)	;197B10C40020
	move.w	d0,d4	;3800
	bsr	RandomGen_BytewithOffset	;61000CFC
	and.w	#$003F,d0	;0240003F
	move.w	d4,d1	;3204
	and.w	#$0001,d1	;02410001
	beq.s	adrCd0054F4	;6702
	lsr.w	#$01,d0	;E248
adrCd0054F4:	add.w	#$001E,d0	;0640001E
	add.w	$0008(a4),d0	;D06C0008
	move.w	d0,$0008(a4)	;39400008
	bsr	RandomGen_BytewithOffset	;61000CDE
	and.w	#$0007,d0	;02400007
	addq.w	#$01,d0	;5240
	add.b	$000B(a4),d0	;D02C000B
	move.b	d0,$000B(a4)	;1940000B
	lea	adrEA0055B8.l,a6	;4DF9000055B8
	move.w	d4,d0	;3004
	and.w	#$0003,d0	;02400003
	asl.w	#$02,d0	;E540
	lea	$04(a6,d0.w),a2	;45F60004
	moveq	#$03,d6	;7C03
adrLp005526:	cmp.b	#$06,(a2)+	;0C1A0006
	bne.s	adrCd005532	;6606
	bsr	adrCd00618A	;61000C5C
	bra.s	adrCd005544	;6012

adrCd005532:	bsr	RandomGen_BytewithOffset	;61000CAC
	and.w	#$0007,d0	;02400007
	cmp.b	#$04,-$0001(a2)	;0C2A0004FFFF
	bne.s	adrCd005544	;6602
	lsr.w	#$01,d0	;E248
adrCd005544:	addq.w	#$01,d0	;5240
	move.w	d0,d1	;3200
	move.b	(a6)+,d0	;101E
	add.b	$00(a4,d0.w),d1	;D2340000
	move.b	d1,$00(a4,d0.w)	;19810000
	dbra	d6,adrLp005526	;51CEFFD2
	bclr	#$07,$0022(a4)	;08AC00070022
	move.w	d4,d0	;3004
	and.w	#$0003,d4	;02440003
	subq.w	#$01,d4	;5344
	bne.s	adrCd00556A	;6604
	addq.b	#$01,$0022(a4)	;522C0022
adrCd00556A:	tst.b	$0022(a4)	;4A2C0022
	beq.s	adrCd005584	;6714
	cmp.l	#$FFFFFFFF,$0010(a4)	;0CACFFFFFFFF0010
	bne.s	adrCd005584	;660A
	tst.b	$000F(a4)	;4A2C000F
	bmi.s	adrCd005584	;6B04
	clr.b	$0022(a4)	;422C0022
adrCd005584:	bsr	adrCd000986	;6100B400
	moveq	#$00,d2	;7400
	move.b	(a4),d2	;1414
	lea	adrEA0054A0.l,a6	;4DF9000054A0
	move.b	$00(a6,d2.w),$0020(a4)	;197620000020
	move.b	$0003(a4),d1	;122C0003
	lsr.b	#$04,d1	;E809
	lsr.b	#$01,d2	;E20A
	add.b	d2,d1	;D202
	sub.b	#$0F,d1	;0401000F
	neg.b	d1	;4401
	cmp.b	#$08,d1	;0C010008
	bcc.s	adrCd0055B0	;6402
	moveq	#$08,d1	;7208
adrCd0055B0:	asl.b	#$04,d1	;E901
	move.b	d1,$001D(a4)	;1941001D
	rts	;4E75

adrEA0055B8:	dc.w	$0203	;0203
	dc.w	$0405	;0405
	dc.w	$0806	;0806
	dc.w	$0404	;0404
	dc.w	$0406	;0406
	dc.w	$0804	;0804
	dc.w	$0606	;0606
	dc.w	$0608	;0608
	dc.w	$0608	;0608
	dc.w	$0404	;0404

adrJC0055CC:	
	cmp.w	#$0008,$0042(a5)	;0C6D00080042
	bne.s	adrCd0055FA	;6626
	cmp.w	#$0006,$0044(a5)	;0C6D00060044
	bcc.s	adrCd0055FA	;641E
	eor.w	#$0001,$0044(a5)	;0A6D00010044
	bra	adrCd008AC4	;600034E0

adrCd0055E6:	tst.w	$0042(a5)	;4A6D0042
	bpl.s	adrCd0055FC	;6A10
	bclr	#$07,$0001(a5)	;08AD00070001
	beq.s	adrCd0055FA	;6706
	move.w	#$001A,$000C(a5)	;3B7C001A000C
adrCd0055FA:	rts	;4E75

adrCd0055FC:	
	bclr	#$07,$0001(a5)	;08AD00070001
	beq.s	adrCd005612	;670E
	lea	adrEA00F556.l,a6	;4DF90000F556
	moveq	#$1C,d0	;701C
	moveq	#$22,d2	;7422
	bra	adrCd005772	;60000162

adrCd005612:	moveq	#-$01,d0	;70FF
	move.l	$0002(a5),d1	;222D0002
	sub.w	$0008(a5),d1	;926D0008
	sub.w	#$003A,d1	;0441003A
	bcs.s	adrCd00563C	;651A
	lsr.w	#$03,d1	;E649
	and.w	#$0003,d1	;02410003
	move.w	d1,d0	;3001
	swap	d1	;4841
	move.l	$0046(a5),a0	;206D0046
	cmp.b	$00(a0,d0.w),d1	;B2300000
	bcs.s	adrCd00563A	;6504
	add.w	#$0100,d0	;06400100
adrCd00563A:	ror.w	#$08,d0	;E058
adrCd00563C:	cmp.w	$0040(a5),d0	;B06D0040
	bne.s	adrCd005644	;6602
	rts	;4E75

adrCd005644:	move.w	d0,$0040(a5)	;3B400040
	bra	adrCd008AC4	;6000347A

adrCd00564C:	move.w	#$FFFF,$000C(a5)	;3B7CFFFF000C
	move.w	$0022(a5),$0024(a5)	;3B6D00220024
	btst	#$06,$0018(a5)	;082D00060018
	bne.s	adrCd0055FA	;669A
	tst.b	$003D(a5)	;4A2D003D
	bmi.s	adrCd00566E	;6B08
	move.b	#$FF,$003D(a5)	;1B7C00FF003D
	bra.s	adrCd0056C4	;6056

adrCd00566E:	moveq	#$05,d1	;7205
	bsr	adrCd006128	;61000AB6
	tst.b	d3	;4A03
	bpl.s	adrCd0056C4	;6A4C
	bsr	adrCd009268	;61003BEE
	move.w	$00(a6,d0.w),d1	;32360000
	and.w	#$0007,d1	;02410007
	cmp.w	#$0006,d1	;0C410006
	bne.s	adrCd0056C4	;663A
	move.b	$00(a6,d0.w),d1	;12360000
	and.w	#$0003,d1	;02410003
	subq.w	#$01,d1	;5341
	bne.s	adrCd0056C4	;662E
	bclr	#$07,$01(a6,d0.w)	;08B600070001
	move.w	$0058(a5),d2	;342D0058
	move.w	d2,d1	;3202
	subq.w	#$01,d1	;5341
	move.w	d1,$0058(a5)	;3B410058
	bsr	adrCd00928A	;61003BE0
	move.l	d7,$001C(a5)	;2B47001C
	bsr	adrCd0092A6	;61003BF4
	bsr	adrCd009268	;61003BB2
	bset	#$07,$01(a6,d0.w)	;08F600070001
	move.b	#$02,$003D(a5)	;1B7C0002003D
adrCd0056C4:	cmp.w	#$0008,$0042(a5)	;0C6D00080042
	bne.s	adrCd0056D6	;660A
	bsr	adrCd003AD2	;6100E404
	bcs.s	adrCd0056D6	;6504
	bsr	adrCd003A3E	;6100E36A
adrCd0056D6:	move.b	$0014(a5),d0	;102D0014
	beq.s	adrCd0056EE	;6712
	cmp.b	#$01,d0	;0C000001
	beq.s	adrCd005748	;6766
	cmp.b	#$02,d0	;0C000002
	beq	adrCd004E2E	;6700F746
	bra	adrJC0057A8	;600000BC

adrCd0056EE:	moveq	#$00,d0	;7000
	move.b	$0056(a5),d0	;102D0056
	beq.s	adrCd00570A	;6714
	move.w	d0,$000C(a5)	;3B40000C
	clr.b	$0056(a5)	;422D0056
	cmp.w	#$0004,$0014(a5)	;0C6D00040014
	bne.s	adrCd00570A	;6604
	bsr	Click_CloseSpellBook	;61000D3C
adrCd00570A:	cmp.w	#$005E,$0002(a5)	;0C6D005E0002
	bcs	adrCd0055E6	;6500FED4
	moveq	#-$01,d0	;70FF
	tst.w	$0040(a5)	;4A6D0040
	bpl	adrCd005644	;6A00FF28
	bclr	#$07,$0001(a5)	;08AD00070001
	beq.s	adrCd005766	;6740
	moveq	#$00,d0	;7000
	move.b	$0015(a5),d0	;102D0015
	asl.w	#$02,d0	;E540
	move.l	adrJT005734(pc,d0.w),a0	;207B0004
	jmp	(a0)	;4ED0

adrJT005734:	dc.l	adrJC005768	;00005768
	dc.l	Click_CloseSpellBook	;00006444
	dc.l	adrJC0057A8	;000057A8
	dc.l	adrJC0062CA	;000062CA
	dc.l	Click_CloseSpellBook	;00006444

adrCd005748:	bclr	#$07,$0001(a5)	;08AD00070001
	beq.s	adrCd005766	;6716
	clr.b	$0014(a5)	;422D0014
	move.b	#$FF,$0053(a5)	;1B7C00FF0053
	lea	adrEA004981.l,a6	;4DF900004981
	jmp	adrCd00E33A.l	;4EF90000E33A

adrCd005766:	rts	;4E75

adrJC005768:	lea	adrEA00F4CE.l,a6	;4DF90000F4CE
	moveq	#$00,d0	;7000
	moveq	#$11,d2	;7411
adrCd005772:	move.l	$0002(a5),d1	;222D0002
	sub.w	$0008(a5),d1	;926D0008
adrCd00577A:	cmp.w	$0004(a6),d1	;B26E0004
	bcs.s	adrCd00579E	;651E
	cmp.w	$0006(a6),d1	;B26E0006
	beq.s	adrCd005788	;6702
	bcc.s	adrCd00579E	;6416
adrCd005788:	swap	d1	;4841
	cmp.w	(a6),d1	;B256
	bcs.s	adrCd00579C	;650E
	cmp.w	$0002(a6),d1	;B26E0002
	beq.s	adrCd005796	;6702
	bcc.s	adrCd00579C	;6406
adrCd005796:	move.w	d0,$000C(a5)	;3B40000C
	rts	;4E75

adrCd00579C:	swap	d1	;4841
adrCd00579E:	addq.w	#$08,a6	;504E
	addq.w	#$01,d0	;5240
	cmp.w	d2,d0	;B042
	bcs.s	adrCd00577A	;65D4
	rts	;4E75

adrJC0057A8:	moveq	#$00,d0	;7000
	move.b	$0014(a5),d0	;102D0014
	bne.s	adrCd0057CA	;661A
	moveq	#-$01,d2	;74FF
	bsr	adrCd00D002	;6100784E
	bmi.s	adrCd0057D0	;6B18
	move.w	#$0002,$0014(a5)	;3B7C00020014
	move.w	$000C(a5),d0	;302D000C
	add.w	#$0011,d0	;06400011
	move.b	d0,$0014(a5)	;1B400014
adrCd0057CA:	move.w	d0,$000C(a5)	;3B40000C
	rts	;4E75

adrCd0057D0:	bsr	adrCd00651C	;61000D4A
	tst.w	$000C(a5)	;4A6D000C
	bpl.s	adrCd00580A	;6A30
	bsr	adrCd0072D0	;61001AF4
	tst.b	$0017(a4)	;4A2C0017
	bmi.s	adrCd00580A	;6B26
	cmp.w	#$0048,d1	;0C410048
	bcs.s	adrCd00580A	;6520
	cmp.w	#$0058,d1	;0C410058
	bcc.s	adrCd00580A	;641A
	swap	d1	;4841
	cmp.w	#$00E0,d1	;0C4100E0
	bcs.s	adrCd00580A	;6512
	cmp.w	#$00F0,d1	;0C4100F0
	bcs.s	adrCd005804	;6506
	cmp.w	#$0132,d1	;0C410132
	bcs.s	adrCd00580C	;6508
adrCd005804:	move.w	#$0015,$000C(a5)	;3B7C0015000C
adrCd00580A:	rts	;4E75

adrCd00580C:	swap	d1	;4841
	cmp.w	#$0050,d1	;0C410050
	bcs.s	adrCd00580A	;65F6
	swap	d1	;4841
	cmp.w	#$0128,d1	;0C410128
	bcc.s	adrCd005830	;6414
	cmp.w	#$011A,d1	;0C41011A
	bcc.s	adrCd00580A	;64E8
	cmp.w	#$0110,d1	;0C410110
	bcs.s	adrCd00580A	;65E2
	addq.b	#$01,$0018(a4)	;522C0018
	bra	adrCd007392	;60001B64

adrCd005830:	subq.b	#$01,$0018(a4)	;532C0018
	bra	adrCd007392	;60001B5C

Click_LaunchSpellFromBook:
	bsr.s	adrCd00584C	;6112
	bne.s	adrCd005844	;6608
	bsr	adrCd00730C	;61001ACE
	bsr	adrCd00D156	;61007914
adrCd005844:
	move.w	#$0002,$0014(a5)	;3B7C00020014
adrCd00584A:
	rts	;4E75

adrCd00584C:	bsr	adrCd0072D0	;61001A82
	clr.w	adrB_005A5C.l	;427900005A5C
	move.b	$0007(a5),adrB_00F99A.l	;13ED00070000F99A
adrCd00585E:	move.b	$0017(a4),d0	;102C0017
	bmi.s	adrCd00584A	;6BE6
	cmp.b	#$03,$000F(a4)	;0C2C0003000F
	beq.s	adrCd005870	;6704
	subq.b	#$03,d0	;5700
	beq.s	adrCd005884	;6714
adrCd005870:	cmp.w	#$0008,$0042(a5)	;0C6D00080042
	bne.s	adrCd005884	;660C
	movem.l	d0-d7/a0-a6,-(sp)	;48E7FFFE
	bsr	adrCd003A3E	;6100E1C0
	movem.l	(sp)+,d0-d7/a0-a6	;4CDF7FFF
adrCd005884:	subq.b	#$04,$000A(a4)	;592C000A
	bcc.s	adrCd00588E	;6404
	clr.b	$000A(a4)	;422C000A
adrCd00588E:	move.b	#$0F,$001F(a4)	;197C000F001F
	clr.b	$0015(a4)	;422C0015
	clr.b	$0025(a4)	;422C0025
	bsr	adrCd00755A	;61001CBC
	move.b	$000C(a4),d1	;122C000C
	sub.b	d0,d1	;9200
	bcs	adrCd0059C8	;65000120
	move.b	d1,$000C(a4)	;1941000C
	tst.b	d0	;4A00
	bne.s	adrCd0058C4	;6612
	move.b	$0017(a4),d0	;102C0017
	bsr	adrCd0075DC	;61001D24
	lea	RingUses.l,a0	;41F90000F98E
	subq.b	#$01,$00(a0,d0.w)	;53300000
adrCd0058C4:	bsr	adrCd008E24	;6100355E
	bsr	adrCd007416	;61001B4C
	moveq	#$00,d0	;7000
	move.b	$0017(a4),d0	;102C0017
	bsr	adrCd0075DC	;61001D08
	move.w	d0,d1	;3200
	move.b	$0017(a4),d0	;102C0017
	cmp.b	$000F(a4),d1	;B22C000F
	bne.s	adrCd0058F0	;660E
	lea	adrEA004E0E.l,a6	;4DF900004E0E
	move.b	$00(a6,d0.w),d0	;10360000
	add.w	#$0020,d0	;06400020
adrCd0058F0:	lea	adrEA007524.l,a6	;4DF900007524
	move.b	$00(a6,d0.w),d1	;12360000
	addq.b	#$05,d1	;5A01
	add.b	$0019(a4),d1	;D22C0019
	cmp.b	#$64,d1	;0C010064
	bcs.s	adrCd005908	;6502
	moveq	#$64,d1	;7264
adrCd005908:	move.b	d1,$0019(a4)	;19410019
	add.w	d0,d0	;D040
	lea	Spells_01_Armour.l,a0	;41F900005A64
	lea	adrJT005A0C.l,a6	;4DF900005A0C
	add.w	$00(a6,d0.w),a0	;D0F60000
	bsr	adrCd00617A	;6100085A
	add.b	d0,d7	;DE00
	bmi.s	adrCd0059A2	;6B7C
	move.w	d7,-(sp)	;3F07
	bsr	adrCd009268	;6100393E
	move.w	(sp)+,d7	;3E1F
	move.w	$00(a6,d0.w),d1	;32360000
	and.w	#$0007,d1	;02410007
	subq.w	#$06,d1	;5D41
	bne.s	adrCd005946	;660C
	move.b	$00(a6,d0.w),d1	;12360000
	and.w	#$0003,d1	;02410003
	beq	adrCd0059E0	;6700009C
adrCd005946:	move.l	a4,-(sp)	;2F0C
	jsr	(a0)	;4E90
	moveq	#$00,d0	;7000
	move.b	adrB_00F99A.l,d0	;10390000F99A
	bsr	adrCd00480C	;6100EEB8
	tst.w	d1	;4A41
	bmi.s	adrCd005976	;6B1C
	beq.s	adrCd00596E	;6712
	move.w	d1,d7	;3E01
	tst.w	$0042(a5)	;4A6D0042
	bpl.s	adrCd005976	;6A12
	bsr	adrCd008C4A	;610032E4
	bsr	adrCd008C2C	;610032C2
	bra.s	adrCd005976	;6008

adrCd00596E:	move.w	$0006(a5),d7	;3E2D0006
	bsr	adrCd00D66A	;61007CF6
adrCd005976:	move.l	(sp)+,a4	;285F
	move.l	a4,d0	;200C
	sub.l	#CharacterStats,d0	;04800000F586
	lsr.w	#$01,d0	;E248
	lea	adrEA014CA4.l,a0	;41F900014CA4
	add.w	d0,a0	;D0C0
	moveq	#$00,d0	;7000
	move.b	$0017(a4),d0	;102C0017
	addq.b	#$01,$00(a0,d0.w)	;52300000
	bcc.s	adrCd00599A	;6404
	subq.b	#$01,$00(a0,d0.w)	;53300000
adrCd00599A:	lea	adrEA00D3DD.l,a6	;4DF90000D3DD
	bra.s	adrCd0059B0	;600E

adrCd0059A2:	lea	adrEA0059FE.l,a6	;4DF9000059FE
	move.w	#$0004,adrW_00E3FA.l	;33FC00040000E3FA
adrCd0059B0:	move.b	#$FF,$0017(a4)	;197C00FF0017
	tst.b	adrB_005A5D.l	;4A3900005A5D
	bne.s	adrCd0059C6	;6608
	jsr	adrCd00D9D6.l	;4EB90000D9D6
	moveq	#$00,d0	;7000
adrCd0059C6:	rts	;4E75

adrCd0059C8:	tst.b	adrB_005A5D.l	;4A3900005A5D
	bne.s	adrCd0059C6	;66F6
	lea	adrEA00F4BE.l,a6	;4DF90000F4BE
	jsr	adrCd00D9D6.l	;4EB90000D9D6
	moveq	#$01,d0	;7001
	rts	;4E75

adrCd0059E0:	lea	adrEA0059F0.l,a6	;4DF9000059F0
	move.w	#$0008,adrW_00E3FA.l	;33FC00080000E3FA
	bra.s	adrCd0059B0	;60C0

adrEA0059F0:	dc.b	'SPELL FIZZLED'	;5350454C4C2046495A5A4C4544
	dc.b	$FF	;FF
adrEA0059FE:	dc.b	'SPELL FAILED'	;5350454C4C204641494C4544
	dc.b	$FF	;FF
	dc.b	$00	;00
adrJT005A0C:	dc.w	Spells_01_Armour-Spells_01_Armour	;0000
	dc.w	Spells_02_Terror-Spells_01_Armour	;0022
	dc.w	Spells_03_Vitalise-Spells_01_Armour	;002A
	dc.w	Spells_04_Biguile-Spells_01_Armour	;0078
	dc.w	adrJC005B0C-Spells_01_Armour	;00A8
	dc.w	Spells_06_Magelock-Spells_01_Armour	;00AE
	dc.w	Spells_07_Conceal-Spells_01_Armour	;0122
	dc.w	Spells_08_Warpower-Spells_01_Armour	;014A
	dc.w	Spells_09_Missle-Spells_01_Armour	;0150
	dc.w	Spells_10_Vanish-Spells_01_Armour	;015A
	dc.w	Spells_11_Paralyze-Spells_01_Armour	;0160
	dc.w	Spells_12_Alchemy-Spells_01_Armour	;0168
	dc.w	Spells_13_Confuse-Spells_01_Armour	;01CA
	dc.w	Spells_14_Levitate-Spells_01_Armour	;01D2
	dc.w	Spells_15_Antimage-Spells_01_Armour	;01D8
	dc.w	Spells_16_Recharge-Spells_01_Armour	;01DE
	dc.w	Spells_17_Trueview-Spells_01_Armour	;0224
	dc.w	Spells_18_Renew-Spells_01_Armour	;022A
	dc.w	Spells_19_Vivify-Spells_01_Armour	;0272
	dc.w	Spells_20_Dispell-Spells_01_Armour	;02A8
	dc.w	Spells_21_Firepath-Spells_01_Armour	;02E8
	dc.w	Spells_22_Illusion-Spells_01_Armour	;02F0
	dc.w	Spells_23_Compass-Spells_01_Armour	;02F6
	dc.w	Spells_24_Spelltap-Spells_01_Armour	;02FC
	dc.w	Spells_25_Disrupt-Spells_01_Armour	;0302
	dc.w	Spells_26_Fireball-Spells_01_Armour	;0310
	dc.w	Spells_27_Wychwind-Spells_01_Armour	;0422
	dc.w	Spells_28_ArcBolt-Spells_01_Armour	;047C
	dc.w	Spells_29_Formwall-Spells_01_Armour	;0484
	dc.w	Spells_30_Summon-Spells_01_Armour	;052A
	dc.w	Spells_31_Blaze-Spells_01_Armour	;0530
	dc.w	Spells_32_Mindrock-Spells_01_Armour	;053E
	dc.w	Spells_33_Protect-Spells_01_Armour	;FFFA
	dc.w	Spells_34-Spells_01_Armour	;0544
	dc.w	Spells_35_Enhance-Spells_01_Armour	;013E
	dc.w	Spells_36_Inferno-Spells_01_Armour	;062C
	dc.w	Spells_37_Nullify-Spells_01_Armour	;0642
	dc.w	Spells_38-Spells_01_Armour	;064C
	dc.w	Spells_39-Spells_01_Armour	;067E
	dc.w	Spells_40_Vortex-Spells_01_Armour	;06BA
adrB_005A5C:	dc.b	$00	;00
adrB_005A5D:	dc.b	$00	;00

Spells_33_Protect:	move.b	#$08,$0025(a4)	;197C00080025
Spells_01_Armour:	moveq	#$00,d4	;7800
	addq.w	#$02,d7	;5447
adrCd005A68:	cmp.w	#$0040,d7	;0C470040
	bcs.s	adrCd005A70	;6502
	moveq	#$3F,d7	;7E3F
adrCd005A70:	asl.w	#$02,d7	;E547
	and.w	#$00F8,d7	;024700F8
	add.b	d4,d7	;DE04
	move.b	d7,$0015(a4)	;19470015
	move.b	#$02,adrB_00F998.l	;13FC00020000F998
	rts	;4E75

Spells_02_Terror:	move.w	#$008F,d4	;383C008F
	bra	adrCd005D6E	;600002E2

Spells_03_Vitalise:	lsr.w	#$02,d7	;E44F
	move.w	d7,d5	;3A07
adrLp005A92:	bsr	RandomGen_BytewithOffset	;6100074C
	and.w	#$0007,d0	;02400007
	add.w	d0,d5	;DA40
	dbra	d7,adrLp005A92	;51CFFFF4
	cmp.w	#$0100,d5	;0C450100
	bcs.s	adrCd005AA8	;6502
	moveq	#-$01,d5	;7AFF
adrCd005AA8:	moveq	#$03,d1	;7203
adrLp005AAA:	move.b	$18(a5,d1.w),d0	;10351018
	and.w	#$00E0,d0	;024000E0
	bne.s	adrCd005AD4	;6620
	move.b	$18(a5,d1.w),d0	;10351018
	bsr	adrCd0072D4	;6100181A
	move.b	$000A(a4),d0	;102C000A
	add.b	d5,d0	;D005
	bcc.s	adrCd005AC6	;6402
	moveq	#-$01,d0	;70FF
adrCd005AC6:	cmp.b	$000B(a4),d0	;B02C000B
	bcs.s	adrCd005AD0	;6504
	move.b	$000B(a4),d0	;102C000B
adrCd005AD0:	move.b	d0,$000A(a4)	;1940000A
adrCd005AD4:	dbra	d1,adrLp005AAA	;51C9FFD4
	bra	adrCd008E24	;6000334A

Spells_04_Biguile:	cmp.w	#$0008,$0042(a5)	;0C6D00080042
	bne.s	adrCd005B0A	;6626
	lsr.b	#$02,d7	;E40F
	addq.w	#$01,d7	;5247
	bsr	adrCd00498E	;6100EEA4
	move.w	d7,d0	;3007
	add.b	$0006(a4),d7	;DE2C0006
	move.b	d7,$0006(a4)	;19470006
	add.b	$0007(a4),d0	;D02C0007
	move.b	d0,$0007(a4)	;19400007
	bsr	adrCd00924C	;6100374C
	move.w	#$008D,d7	;3E3C008D
	bra	adrCd00222A	;6000C722

adrCd005B0A:	rts	;4E75

adrJC005B0C:	moveq	#$01,d4	;7801
	bra	adrCd005A68	;6000FF58

Spells_06_Magelock:	bsr	adrCd009268	;61003754
	move.b	$01(a6,d0.w),d1	;12360001
	and.w	#$0007,d1	;02410007
	subq.w	#$02,d1	;5541
	bne.s	adrCd005B38	;6616
	move.w	$0020(a5),d2	;342D0020
	add.w	d2,d2	;D442
	addq.w	#$01,d2	;5242
	btst	d2,$00(a6,d0.w)	;05360000
	bne.s	adrCd005B7E	;664E
	subq.w	#$01,d2	;5342
	btst	d2,$00(a6,d0.w)	;05360000
	bne.s	adrCd005B84	;664C
adrCd005B38:	bsr	adrCd00924C	;61003712
	cmp.w	adrW_00F9CE.l,d7	;BE790000F9CE
	bcc.s	adrCd005B84	;6440
	swap	d7	;4847
	cmp.w	adrW_00F9CC.l,d7	;BE790000F9CC
	bcc.s	adrCd005B84	;6436
	move.b	$01(a6,d0.w),d1	;12360001
	and.w	#$0007,d1	;02410007
	cmp.w	#$0002,d1	;0C410002
	beq.s	adrCd005B6C	;6710
	cmp.w	#$0005,d1	;0C410005
	bne.s	adrCd005B84	;6622
	move.b	$00(a6,d0.w),d1	;12360000
	lsr.b	#$04,d1	;E809
	beq.s	adrCd005B7E	;6714
	rts	;4E75

adrCd005B6C:	move.w	$0020(a5),d2	;342D0020
	eor.w	#$0002,d2	;0A420002
	add.w	d2,d2	;D442
	addq.w	#$01,d2	;5242
	btst	d2,$00(a6,d0.w)	;05360000
	beq.s	adrCd005B84	;6706
adrCd005B7E:	bchg	#$04,$01(a6,d0.w)	;087600040001
adrCd005B84:	rts	;4E75

Spells_07_Conceal:	bsr	adrCd00924C	;610036C4
	cmp.w	adrW_00F9CE.l,d7	;BE790000F9CE
	bcc.s	adrCd005BA0	;640E
	cmp.w	adrW_00F9CC.l,d7	;BE790000F9CC
	bcc.s	adrCd005BA0	;6406
	bset	#$03,$01(a6,d0.w)	;08F600030001
adrCd005BA0:	rts	;4E75

Spells_35_Enhance:	clr.b	$0019(a4)	;422C0019
	move.b	#$08,$0025(a4)	;197C00080025
	add.w	d7,d7	;DE47
Spells_08_Warpower:	moveq	#$02,d4	;7802
	bra	adrCd005A68	;6000FEB6

Spells_09_Missle:	move.w	#$008A,d4	;383C008A
	lsr.w	#$01,d7	;E24F
	bra	adrCd005D80	;600001C4

Spells_10_Vanish:	moveq	#$03,d4	;7803
	bra	adrCd005A68	;6000FEA6

Spells_11_Paralyze:	move.w	#$008C,d4	;383C008C
	bra	adrCd005D6E	;600001A4

Spells_12_Alchemy:	moveq	#$00,d0	;7000
	move.b	adrB_00F99A.l,d0	;10390000F99A
	asl.w	#$06,d0	;ED40
	lea	CharacterStats.l,a0	;41F90000F586
	add.w	d0,a0	;D0C0
	moveq	#$00,d0	;7000
	move.b	$0030(a0),d1	;12280030
	cmp.b	#$1B,d1	;0C01001B
	bcs.s	adrCd005BF0	;6506
	cmp.b	#$3F,d1	;0C01003F
	bcs.s	adrCd005C02	;6512
adrCd005BF0:	move.b	$0031(a0),d1	;12280031
	moveq	#$01,d0	;7001
	cmp.b	#$1B,d1	;0C01001B
	bcs.s	adrCd005C2C	;6530
	cmp.b	#$3F,d1	;0C01003F
	bcc.s	adrCd005C2C	;642A
adrCd005C02:	addq.w	#$05,d7	;5A47
	add.b	$003C(a0),d7	;DE28003C
	cmp.b	#$64,d7	;0C070064
	bcs.s	adrCd005C10	;6502
	moveq	#$63,d7	;7E63
adrCd005C10:	move.b	d7,$003C(a0)	;1147003C
	moveq	#$0B,d2	;740B
adrLp005C16:	cmp.b	#$01,$30(a0,d2.w)	;0C3000012030
	bne.s	adrCd005C22	;6604
	clr.b	$30(a0,d2.w)	;42302030
adrCd005C22:	dbra	d2,adrLp005C16	;51CAFFF2
	move.b	#$01,$30(a0,d0.w)	;11BC00010030
adrCd005C2C:	rts	;4E75

Spells_13_Confuse:	move.w	#$008B,d4	;383C008B
	bra	adrCd005D6E	;6000013A

Spells_14_Levitate:	moveq	#$05,d4	;7805
	bra	adrCd005A68	;6000FE2E

Spells_15_Antimage:	moveq	#$06,d4	;7806
	bra	adrCd005A68	;6000FE28

Spells_16_Recharge:	moveq	#$00,d0	;7000
	move.b	adrB_00F99A.l,d0	;10390000F99A
	asl.w	#$06,d0	;ED40
	lea	CharacterStats.l,a0	;41F90000F586
	add.w	d0,a0	;D0C0
	moveq	#$00,d0	;7000
	move.b	$0030(a0),d0	;10280030
	cmp.b	#$69,d0	;0C000069
	bcs.s	adrCd005C66	;6506
	cmp.b	#$6D,d0	;0C00006D
	bcs.s	adrCd005C76	;6510
adrCd005C66:	move.b	$0031(a0),d0	;10280031
	cmp.b	#$69,d0	;0C000069
	bcs.s	adrCd005C86	;6516
	cmp.b	#$6D,d0	;0C00006D
	bcc.s	adrCd005C86	;6410
adrCd005C76:	sub.w	#$0069,d0	;04400069
	lea	RingUses.l,a0	;41F90000F98E
	lsr.w	#$03,d7	;E64F
	move.b	d7,$00(a0,d0.w)	;11870000
adrCd005C86:	rts	;4E75

Spells_17_Trueview:	moveq	#$07,d4	;7807
	bra	adrCd005A68	;6000FDDC

Spells_18_Renew:	move.w	d7,d4	;3807
	add.w	d7,d7	;DE47
	add.w	d4,d7	;DE44
	lsr.w	#$03,d7	;E64F
	move.w	d7,d5	;3A07
adrLp005C98:	bsr	RandomGen_BytewithOffset	;61000546
	and.w	#$0007,d0	;02400007
	add.w	d0,d5	;DA40
	dbra	d7,adrLp005C98	;51CFFFF4
	moveq	#$03,d1	;7203
adrLp005CA8:	move.b	$18(a5,d1.w),d0	;10351018
	and.w	#$00E0,d0	;024000E0
	bne.s	adrCd005CCE	;661C
	move.b	$18(a5,d1.w),d0	;10351018
	bsr	adrCd0072D4	;6100161C
	move.w	$0006(a4),d0	;302C0006
	add.w	d5,d0	;D045
	cmp.w	$0008(a4),d0	;B06C0008
	bcs.s	adrCd005CCA	;6504
	move.w	$0008(a4),d0	;302C0008
adrCd005CCA:	move.w	d0,$0006(a4)	;39400006
adrCd005CCE:	dbra	d1,adrLp005CA8	;51C9FFD8
	bra	adrCd008E24	;60003150

Spells_19_Vivify:	bsr	adrCd009268	;61003590
	bsr	adrCd008598	;610028BC
	bsr	adrCd003AD2	;6100DDF2
	bcc.s	adrCd005CF8	;6414
	tst.b	d0	;4A00
	bpl.s	adrCd005CF6	;6A0E
	move.l	a5,-(sp)	;2F0D
	move.l	a1,a5	;2A49
	bsr	adrCd009268	;6100357A
	bsr	adrCd008598	;610028A6
	move.l	(sp)+,a5	;2A5F
adrCd005CF6:	rts	;4E75

adrCd005CF8:	bsr	adrCd00924C	;61003552
	move.b	$01(a6,d0.w),d1	;12360001
	and.w	#$0007,d1	;02410007
	subq.w	#$01,d1	;5341
	beq.s	adrCd005CF6	;67EE
	bra	adrCd0084B0	;600027A6

Spells_20_Dispell:	bsr	adrCd00924C	;6100353E
adrCd005D10:	bclr	#$03,$01(a6,d0.w)	;08B600030001
	move.b	$01(a6,d0.w),d1	;12360001
	not.b	d1	;4601
	and.w	#$0007,d1	;02410007
	bne.s	adrCd005D30	;660E
	btst	#$00,$00(a6,d0.w)	;083600000000
	bne.s	adrCd005D32	;6608
adrCd005D2A:	and.w	#$00F8,$00(a6,d0.w)	;027600F80000
adrCd005D30:	rts	;4E75

adrCd005D32:	lea	adrEA01575E.l,a0	;41F90001575E
	moveq	#-$04,d1	;72FC
adrCd005D3A:	addq.w	#$04,d1	;5841
	cmp.w	-$0002(a0),d1	;B268FFFE
	bcc.s	adrCd005D2A	;64E8
	cmp.w	$02(a0,d1.w),d0	;B0701002
	bne.s	adrCd005D3A	;66F2
	bra	adrCd001584	;6000B83A

Spells_21_Firepath:	move.w	#$0087,d4	;383C0087
	addq.w	#$02,d7	;5447
	bra.s	adrCd005D6E	;601A

Spells_22_Illusion:	moveq	#$65,d4	;7865
	bra	adrCd005D80	;60000028

Spells_23_Compass:	moveq	#$04,d4	;7804
	bra	adrCd005A68	;6000FD0A

Spells_24_Spelltap:	move.w	#$008E,d4	;383C008E
	bra.s	adrCd005D6E	;6008

Spells_25_Disrupt:
	move.w	#$0083,d4	;383C0083
	addq.w	#$05,d7	;5A47
	add.w	d7,d7	;DE47
adrCd005D6E:
	bset	#$08,d7	;08C70008
	bra.s	adrCd005D80	;600C

Spells_26_Fireball:
	move.w	#$0080,d4	;383C0080
adrCd005D78:
	move.w	d7,d3	;3607
	add.w	d7,d7	;DE47
	add.w	d3,d7	;DE43
	lsr.w	#$01,d7	;E24F
adrCd005D80:
	move.w	$0020(a5),d6	;3C2D0020
	swap	d6	;4846
	move.w	$0020(a5),d6	;3C2D0020
adrCd005D8A:
	move.w	d7,d3	;3607
	cmp.b	#$80,d3	;0C030080
	bcs.s	adrCd005D96	;6504
	move.b	#$7F,d3	;163C007F
adrCd005D96:
	move.l	$001C(a5),d7	;2E2D001C
	move.w	$0058(a5),d5	;3A2D0058
adrCd005D9E:
	move.w	d5,-(sp)	;3F05
	bsr	adrCd0086F6	;61002954
	bcc.s	adrCd005DB6	;6410
	move.w	(sp)+,d5	;3A1F
	move.b	#$FF,adrB_005A5C.l	;13FC00FF00005A5C
	cmp.w	d0,d2	;B440
	bne.s	adrCd005DBE	;660A
	rts	;4E75

adrCd005DB6:
	clr.b	adrB_005A5C.l	;423900005A5C
	move.w	(sp)+,d5	;3A1F
adrCd005DBE:
	bset	#$07,$01(a6,d2.w)	;08F600072001
adrCd005DC4:
	lea	UnpackedMonsters.l,a4	;49F900014EE6
	addq.w	#$01,-$0002(a4)	;526CFFFE
	move.w	-$0002(a4),d1	;322CFFFE
	cmp.w	#$007D,d1	;0C41007D
	bcs.s	adrCd005DE2	;650A
	subq.w	#$01,-$0002(a4)	;536CFFFE
	bsr	adrCd002C84	;6100CEA6
	bra.s	adrCd005DC4	;60E2

adrCd005DE2:	asl.w	#$04,d1	;E941
	add.w	d1,a4	;D8C1
	move.b	d7,$0001(a4)	;19470001
	swap	d7	;4847
	move.b	d7,$0000(a4)	;19470000
	swap	d6	;4846
	move.b	d6,$0002(a4)	;19460002
	move.b	d5,$0004(a4)	;19450004
	swap	d5	;4845
	move.b	adrB_00F99A.l,$000C(a4)	;19790000F99A000C
	move.b	d4,$000B(a4)	;1944000B
	move.b	adrB_005A5D.l,$0003(a4)	;197900005A5D0003
	clr.w	$0008(a4)	;426C0008
	clr.b	$0005(a4)	;422C0005
	move.b	#$03,$000A(a4)	;197C0003000A
	move.b	#$FF,$000D(a4)	;197C00FF000D
	tst.b	d4	;4A04
	bmi.s	adrCd005E66	;6B3E
	move.b	#$64,$000B(a4)	;197C0064000B
	cmp.b	#$65,d4	;0C040065
	beq.s	adrCd005E3E	;670A
	moveq	#$06,d4	;7806
	add.w	d3,d4	;D843
	asl.w	#$03,d4	;E744
	move.w	d4,$0008(a4)	;39440008
adrCd005E3E:	lsr.w	#$02,d3	;E44B
	cmp.b	#$65,d4	;0C040065
	bne.s	adrCd005E4A	;6604
	bset	#$07,d3	;08C30007
adrCd005E4A:	addq.w	#$02,d3	;5443
	move.b	d3,$0006(a4)	;19430006
	and.w	#$007F,d3	;0243007F
	move.b	d3,$0007(a4)	;19430007
	move.b	#$80,$0003(a4)	;197C00800003
	move.b	#$1F,$0005(a4)	;197C001F0005
	bra.s	adrCd005E7A	;6014

adrCd005E66:	move.b	d3,$0006(a4)	;19430006
	clr.b	$0007(a4)	;422C0007
	btst	#$08,d3	;08030008
	beq.s	adrCd005E7A	;6706
	bset	#$07,$0006(a4)	;08EC00070006
adrCd005E7A:	tst.b	adrB_005A5C.l	;4A3900005A5C
	bne	adrCd0021C0	;6600C33E
	rts	;4E75

Spells_27_Wychwind:	add.w	#$000A,d7	;0647000A
	add.w	d7,d7	;DE47
	cmp.w	#$0080,d7	;0C470080
	bcs.s	adrCd005E94	;6502
	moveq	#$7F,d7	;7E7F
adrCd005E94:	moveq	#$07,d5	;7A07
.wychwind_loop:	movem.w	d5/d7,-(sp)	;48A70500
	move.w	#$0081,d4	;383C0081
	move.w	$0020(a5),d6	;3C2D0020
	add.b	.wychwind_data(pc,d5.w),d6	;DC3B5034
	and.w	#$0003,d6	;02460003
	swap	d6	;4846
	move.w	d5,d6	;3C05
	cmp.w	#$0004,d6	;0C460004
	bcc.s	.wychwind_skip1	;640A
	add.w	$0020(a5),d6	;DC6D0020
	and.w	#$0003,d6	;02460003
	bra.s	.wychwind_skip2	;600C

.wychwind_skip1:	subq.w	#$04,d6	;5946
	add.w	$0020(a5),d6	;DC6D0020
	and.w	#$0003,d6	;02460003
	addq.w	#$04,d6	;5846
.wychwind_skip2:	bsr	adrCd005D8A	;6100FEBE
	movem.w	(sp)+,d5/d7	;4C9F00A0
	dbra	d5,.wychwind_loop	;51CDFFC2
	rts	;4E75

.wychwind_data:	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$00	;00

Spells_28_ArcBolt:	move.w	#$0082,d4	;383C0082
	bra	adrCd005D78	;6000FE92

Spells_29_Formwall:	moveq	#$03,d4	;7803
adrCd005EEA:	move.w	d7,d3	;3607
	addq.w	#$02,d3	;5443
	asl.w	#$02,d3	;E543
	bsr	adrCd00924C	;6100335A
	cmp.w	adrW_00F9CE.l,d7	;BE790000F9CE
	bcc.s	adrCd005F5E	;6462
	swap	d7	;4847
	cmp.w	adrW_00F9CC.l,d7	;BE790000F9CC
	bcc.s	adrCd005F5E	;6458
	move.b	$01(a6,d0.w),d1	;12360001
	bmi.s	adrCd005F5E	;6B52
	and.w	#$0007,d1	;02410007
	bne.s	adrCd005F5E	;664C
	tst.b	$00(a6,d0.w)	;4A360000
	bne.s	adrCd005F5E	;6646
	or.b	#$07,$01(a6,d0.w)	;003600070001
	or.b	d3,d4	;8803
	move.b	d4,$00(a6,d0.w)	;1D840000
	and.w	#$0003,d4	;02440003
	subq.b	#$03,d4	;5704
	bne.s	adrCd005F5E	;6632
	move.w	#$03FF,d1	;323C03FF
adrCd005F30:	lea	adrEA01575E.l,a0	;41F90001575E
	swap	d0	;4840
	move.w	d1,d0	;3001
	swap	d0	;4840
	moveq	#$00,d1	;7200
adrCd005F3E:	cmp.w	-$0002(a0),d1	;B268FFFE
	bcc.s	adrCd005F56	;6412
	cmp.w	$02(a0,d1.w),d0	;B0701002
	beq.s	adrCd005F5A	;6710
	addq.b	#$04,d1	;5801
	bcc.s	adrCd005F3E	;64F0
	and.w	#$00F8,$00(a6,d0.w)	;027600F80000
	bra.s	adrCd005F60	;600A

adrCd005F56:	addq.w	#$04,-$0002(a0)	;5868FFFE
adrCd005F5A:	move.l	d0,$00(a0,d1.w)	;21801000
adrCd005F5E:	rts	;4E75

adrCd005F60:	movem.l	d0/a6,-(sp)	;48E78002
	lea	adrEA01575E.l,a0	;41F90001575E
	move.l	adrL_00F9D4.l,a6	;2C790000F9D4
	move.w	-$0002(a0),d1	;3228FFFE
adrCd005F74:	subq.w	#$04,d1	;5941
	bmi.s	adrCd005F84	;6B0C
	move.w	$02(a0,d1.w),d0	;30301002
	and.w	#$00F8,$00(a6,d0.w)	;027600F80000
	bra.s	adrCd005F74	;60F0

adrCd005F84:	clr.w	-$0002(a0)	;4268FFFE
	movem.l	(sp)+,d0/a6	;4CDF4001
	rts	;4E75

Spells_30_Summon:	moveq	#$64,d4	;7864
	bra	adrCd005D80	;6000FDEE

Spells_31_Blaze:	move.w	#$0084,d4	;383C0084
	add.w	#$000A,d7	;0647000A
	lsr.w	#$01,d7	;E24F
	bra	adrCd005D80	;6000FDE0

Spells_32_Mindrock:	moveq	#$02,d4	;7802
	bra	adrCd005EEA	;6000FF44

Spells_34:	moveq	#$00,d0	;7000
	move.b	adrB_00F99A.l,d0	;10390000F99A
	bsr	adrCd0047FA	;6100E848
	tst.w	d1	;4A41
	bmi	adrCd00605E	;6B0000A6
	lsr.w	#$04,d7	;E84F
	addq.w	#$01,d7	;5247
	move.w	d7,d5	;3A07
	bsr	adrCd009268	;610032A6
	move.l	d7,d4	;2807
	moveq	#$00,d6	;7C00
adrLp005FC8:	move.w	$00(a6,d0.w),d1	;32360000
	and.w	#$0007,d1	;02410007
	subq.w	#$02,d1	;5541
	bne.s	adrCd005FE0	;660C
	move.w	$0020(a5),d1	;322D0020
	add.w	d1,d1	;D241
	btst	d1,$00(a6,d0.w)	;03360000
	bne.s	adrCd006058	;6678
adrCd005FE0:	bsr	adrCd009250	;6100326E
	cmp.w	adrW_00F9CE.l,d7	;BE790000F9CE
	bcc.s	adrCd006058	;646C
	swap	d7	;4847
	cmp.w	adrW_00F9CE.l,d7	;BE790000F9CE
	bcc.s	adrCd006058	;6462
	swap	d7	;4847
	move.w	$00(a6,d0.w),d1	;32360000
	and.w	#$0007,d1	;02410007
	move.b	adrB_006016(pc,d1.w),d1	;123B1014
	bmi.s	adrCd006058	;6B52
	beq.s	adrCd006040	;6738
	subq.w	#$01,d1	;5341
	bne.s	adrCd00601E	;6612
	btst	#$00,$00(a6,d0.w)	;083600000000
	beq.s	adrCd006040	;672C
	bra.s	adrCd006058	;6042

adrB_006016:	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$03	;03
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$01	;01
	dc.b	$FF	;FF
	dc.b	$02	;02

adrCd00601E:	subq.w	#$01,d1	;5341
	bne.s	adrCd006030	;660E
	move.b	$00(a6,d0.w),d1	;12360000
	not.w	d1	;4641
	and.w	#$0003,d1	;02410003
	beq.s	adrCd006058	;672A
	bra.s	adrCd006040	;6010

adrCd006030:	move.w	$0020(a5),d1	;322D0020
	eor.w	#$0002,d1	;0A410002
	add.w	d1,d1	;D241
	btst	d1,$00(a6,d0.w)	;03360000
	bne.s	adrCd006058	;6618
adrCd006040:	tst.b	$01(a6,d0.w)	;4A360001
	bpl.s	adrCd00604C	;6A06
	moveq	#-$01,d6	;7CFF
	addq.w	#$01,d5	;5245
	bra.s	adrCd006054	;6008

adrCd00604C:	move.l	d7,d4	;2807
	and.b	#$01,d6	;02060001
	bne.s	adrCd006058	;6604
adrCd006054:	dbra	d5,adrLp005FC8	;51CDFF72
adrCd006058:	cmp.l	$001C(a5),d4	;B8AD001C
	bne.s	adrCd006060	;6602
adrCd00605E:	rts	;4E75

adrCd006060:	bsr	adrCd009268	;61003206
	bclr	#$07,$01(a6,d0.w)	;08B600070001
	move.l	d4,$001C(a5)	;2B44001C
	tst.b	d6	;4A06
	bmi.s	adrCd00607A	;6B08
	beq.s	adrCd00607A	;6706
	eor.w	#$0002,$0020(a5)	;0A6D00020020
adrCd00607A:	bsr	adrCd009268	;610031EC
	bset	#$07,$01(a6,d0.w)	;08F600070001
	moveq	#$10,d7	;7E10
	bsr	adrCd00222A	;6100C1A2
	moveq	#$05,d0	;7005
	bra	PlaySound	;60003600

Spells_36_Inferno:	move.w	#$0098,d4	;383C0098
	add.w	#$000A,d7	;0647000A
	add.w	d7,d7	;DE47
	cmp.w	#$0080,d7	;0C470080
	bcs.s	adrCd0060A2	;6502
	moveq	#$7F,d7	;7E7F
adrCd0060A2:	bra	adrCd005D80	;6000FCDC

Spells_37_Nullify:	move.w	#$0096,d4	;383C0096
	moveq	#$00,d7	;7E00
	bra	adrCd005D6E	;6000FCC0

Spells_38:	bsr	Spells_19_Vivify	;6100FC24
	moveq	#$03,d7	;7E03
adrLp0060B6:	move.b	$18(a5,d7.w),d0	;10357018
	move.w	d0,d1	;3200
	and.w	#$00A0,d1	;024100A0
	bne.s	adrCd0060DA	;6618
	and.b	#$BF,d0	;020000BF
	move.b	d0,$18(a5,d7.w)	;1B807018
	bsr	adrCd0072D4	;61001208
	move.w	$0008(a4),$0006(a4)	;396C00080006
	move.b	$000B(a4),$000A(a4)	;196C000B000A
adrCd0060DA:	dbra	d7,adrLp0060B6	;51CFFFDA
	bra	adrCd008E24	;60002D44

Spells_39:	add.w	d7,d7	;DE47
	add.w	#$001E,d7	;0647001E
	move.w	$0020(a5),d6	;3C2D0020
	swap	d6	;4846
	move.w	$0020(a5),d6	;3C2D0020
	move.w	#$0095,d4	;383C0095
	bsr.s	adrCd00610A	;6112
	move.w	$0020(a5),d6	;3C2D0020
	bsr.s	adrCd006108	;610A
	move.w	$0020(a5),d6	;3C2D0020
	addq.w	#$03,d6	;5646
	and.w	#$0003,d6	;02460003
adrCd006108:	addq.w	#$04,d6	;5846
adrCd00610A:	addq.b	#$01,d7	;5207
	movem.l	d4/d6/d7,-(sp)	;48E70B00
	bset	#$08,d7	;08C70008
	bsr	adrCd005D8A	;6100FC74
	movem.l	(sp)+,d4/d6/d7	;4CDF00D0
	rts	;4E75

Spells_40_Vortex:	move.w	#$0094,d4	;383C0094
	add.w	d7,d7	;DE47
	bra	adrCd005D80	;6000FC5A

adrCd006128:	moveq	#-$01,d3	;76FF
	moveq	#$03,d2	;7403
adrLp00612C:	move.b	$18(a5,d2.w),d0	;10352018
	and.w	#$00E0,d0	;024000E0
	bne.s	adrCd006174	;663E
	move.b	$18(a5,d2.w),d0	;10352018
	bsr	adrCd0072D4	;61001198
	move.b	$0015(a4),d0	;102C0015
	beq.s	adrCd006174	;6730
	and.w	#$0007,d0	;02400007
	sub.b	d1,d0	;9001
	bne.s	adrCd006174	;6628
	tst.w	d1	;4A41
	bpl.s	adrCd006156	;6A06
	tst.b	$0025(a4)	;4A2C0025
	beq.s	adrCd006174	;671E
adrCd006156:	move.b	$0015(a4),d0	;102C0015
	lsr.b	#$03,d0	;E608
	tst.b	d3	;4A03
	bpl.s	adrCd006162	;6A02
	moveq	#$00,d3	;7600
adrCd006162:	cmp.b	d3,d0	;B003
	bcs.s	adrCd006174	;650E
	move.b	d0,d3	;1600
	swap	d3	;4843
	move.b	$18(a5,d2.w),d3	;16352018
	and.w	#$000F,d3	;0243000F
	swap	d3	;4843
adrCd006174:	dbra	d2,adrLp00612C	;51CAFFB6
	rts	;4E75

adrCd00617A:	moveq	#$03,d6	;7C03
	moveq	#$02,d5	;7A02
adrLp00617E:	bsr.s	adrCd00618A	;610A
	add.w	d0,d6	;DC40
	dbra	d5,adrLp00617E	;51CDFFFA
	move.w	d6,d0	;3006
	rts	;4E75

adrCd00618A:	move.w	adrW_0061DE.l,d0	;3039000061DE
	addq.w	#$01,d0	;5240
	mulu	#$B640,d0	;C0FCB640
	move.l	d0,d1	;2200
	asl.l	#$04,d0	;E980
	add.l	d1,d0	;D081
	move.w	#$0511,d1	;323C0511
	moveq	#$00,d3	;7600
adrCd0061A2:	divu	d1,d0	;80C1
	bvc.s	adrCd0061B4	;680E
	move.w	d0,d2	;3400
	clr.w	d0	;4240
	swap	d0	;4840
	divu	d1,d0	;80C1
	move.w	d0,d3	;3600
	move.w	d2,d0	;3002
	bra.s	adrCd0061A2	;60EE

adrCd0061B4:	subq.w	#$01,d1	;5341
	swap	d0	;4840
	move.w	d3,d0	;3003
	swap	d0	;4840
	divu	d1,d0	;80C1
	clr.w	d0	;4240
	swap	d0	;4840
	move.w	d0,adrW_0061DE.l	;33C0000061DE
	moveq	#$06,d1	;7206
adrCd0061CA:	divu	d1,d0	;80C1
	bvc.s	adrCd0061DA	;680C
	move.w	d0,d2	;3400
	clr.w	d0	;4240
	swap	d0	;4840
	divu	d1,d0	;80C1
	move.w	d2,d0	;3002
	bra.s	adrCd0061CA	;60F0

adrCd0061DA:	swap	d0	;4840
	rts	;4E75

adrW_0061DE:	dc.b	$03	;03
adrB_0061DF:	dc.b	$E1	;E1

RandomGen_BytewithOffset:	moveq	#$01,d1	;7201
	bsr.s	adrCd0061F0	;610C
	swap	d0	;4840
	add.b	adrB_0061DF(pc),d0	;D03AFFF7
	rts	;4E75

adrCd0061EC:	move.w	#$6400,d1	;323C6400
adrCd0061F0:	swap	d1	;4841
	moveq	#$00,d0	;7000
	move.b	adrB_006212.l,d0	;103900006212
	move.w	d0,d1	;3200
	lsr.b	#$03,d1	;E609
	eor.b	d0,d1	;B101
	lsr.b	#$01,d1	;E209
	roxr.b	#$01,d0	;E210
	move.b	d0,adrB_006212.l	;13C000006212
	swap	d1	;4841
	mulu	d1,d0	;C0C1
	swap	d0	;4840
	rts	;4E75

adrB_006212:	dc.b	$FF	;FF
	dc.b	$FF	;FF

adrCd006214:	bsr	adrCd0072D0	;610010BA
	move.w	$002A(a5),d0	;302D002A
	move.w	d0,d2	;3400
	asl.w	#$02,d2	;E542
	lsr.w	#$01,d0	;E248
	move.w	d0,d3	;3600
	move.w	$000E(a5),d0	;302D000E
	btst	d0,$10(a4,d3.w)	;01343010
	beq.s	adrCd00623E	;6710
	eor.w	#$0007,d0	;0A400007
	add.w	d2,d0	;D042
	move.b	d0,$0017(a4)	;19400017
	clr.b	$0018(a4)	;422C0018
	rts	;4E75

adrCd00623E:	moveq	#-$01,d0	;70FF
	move.b	d0,$0017(a4)	;19400017
adrCd006244:	rts	;4E75

adrCd006246:	asl.w	#$03,d0	;E740
	lea	adrEA01739C.l,a6	;4DF90001739C
	add.w	d0,a6	;DCC0
	rts	;4E75

Click_ViewSpell:
	move.w	#$0002,$0014(a5)	;3B7C00020014
	bsr.s	adrCd006214	;61BA
	bpl.s	adrCd006266	;6A0A
	bsr	adrCd00730C	;610010AE
	bsr	adrCd00D9B4	;61007752
	bra.s	adrCd00628C	;6026

adrCd006266:	bsr	adrCd007416	;610011AE
	addq.b	#$03,d7	;5607
	bmi.s	adrCd006288	;6B1A
	lea	adrEA007524.l,a0	;41F900007524
	move.b	$00(a0,d6.w),d0	;10306000
	add.w	d0,d0	;D040
	addq.b	#$01,d0	;5200
	cmp.b	d7,d0	;B007
	bcs.s	adrCd006282	;6502
	move.b	d7,d0	;1007
adrCd006282:	neg.b	d0	;4400
	move.b	d0,$0018(a4)	;19400018
adrCd006288:	bsr	adrCd00730C	;61001082
adrCd00628C:	bra	adrCd00D156	;60006EC8

adrCd006290:	move.l	$0002(a5),d1	;222D0002
	sub.w	$0008(a5),d1	;926D0008
	sub.w	#$0020,d1	;04410020
	bcs.s	adrCd0062C6	;6528
	cmp.w	#$0020,d1	;0C410020
	bcc.s	adrCd0062C6	;6422
	swap	d1	;4841
	sub.w	#$00E0,d1	;044100E0
	bcs.s	adrCd0062C6	;651A
	move.w	#$0004,$000C(a5)	;3B7C0004000C
	lsr.w	#$04,d1	;E849
	move.w	d1,d2	;3401
	swap	d1	;4841
	sub.w	#$0010,d1	;04410010
	bcs.s	adrCd0062C2	;6504
	add.w	#$0006,d2	;06420006
adrCd0062C2:	move.w	d2,$000E(a5)	;3B42000E
adrCd0062C6:	tst.w	d2	;4A42
	rts	;4E75

adrJC0062CA:	move.w	$000E(a5),d7	;3E2D000E
	moveq	#-$01,d2	;74FF
	bsr.s	adrCd006290	;61BE
	bpl.s	adrCd006320	;6A4C
	bsr	adrCd00651C	;61000246
	tst.w	$000C(a5)	;4A6D000C
	bpl.s	adrCd006316	;6A38
	cmp.w	#$0048,d1	;0C410048
	bcs.s	adrCd006316	;6532
	cmp.w	#$0058,d1	;0C410058
	bcc.s	adrCd006316	;642C
	swap	d1	;4841
	sub.w	#$00E0,d1	;044100E0
	bcs.s	adrCd006316	;6524
	lsr.w	#$04,d1	;E849
	cmp.w	#$0005,d1	;0C410005
	beq	Click_CloseSpellBook	;6700014A
	cmp.w	#$0004,d1	;0C410004
	beq.s	adrCd006318	;6716
	move.b	$18(a5,d1.w),d0	;10351018
	and.w	#$00A0,d0	;024000A0
	bne.s	adrCd006316	;660A
	move.w	#$0011,$000C(a5)	;3B7C0011000C
	move.w	d1,$000E(a5)	;3B41000E
adrCd006316:	rts	;4E75

adrCd006318:	move.w	#$0013,$000C(a5)	;3B7C0013000C
	rts	;4E75

adrCd006320:	move.w	#$0012,$000C(a5)	;3B7C0012000C
	move.b	d7,$000E(a5)	;1B47000E
	rts	;4E75

adrB_00632C:	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00

adrCd006334:	bsr	adrCd0092A6	;61002F70
	moveq	#$03,d1	;7203
	bsr	adrCd006128	;6100FDEC
	moveq	#$0B,d2	;740B
	tst.w	d3	;4A43
	bmi.s	adrCd00634C	;6B08
	addq.w	#$01,d3	;5243
	add.w	d3,d3	;D643
	sub.w	d3,d2	;9443
	bcs.s	adrCd006316	;65CA
adrCd00634C:	move.l	adrL_00F9D4.l,a2	;24790000F9D4
	add.w	adrW_00F9D2.l,a2	;D4F90000F9D2
	move.l	a6,a3	;264E
	move.w	adrW_00F9CE.l,d0	;30390000F9CE
	mulu	adrW_00F9CC.l,d0	;C0F90000F9CC
	subq.w	#$01,d0	;5340
adrLp006368:	move.w	(a2)+,d1	;321A
	and.w	#$0007,d1	;02410007
	cmp.b	#$02,d1	;0C010002
	bne.s	adrCd00637C	;6608
	btst	#$04,-$0001(a2)	;082A0004FFFF
	bne.s	adrCd00638E	;6612
adrCd00637C:	cmp.b	#$07,d1	;0C010007
	bne.s	adrCd006390	;660E
	move.b	-$0002(a2),d1	;122AFFFE
	and.w	#$0003,d1	;02410003
	subq.w	#$01,d1	;5341
	beq.s	adrCd006390	;6702
adrCd00638E:	moveq	#$01,d1	;7201
adrCd006390:	move.b	adrB_00632C(pc,d1.w),(a3)+	;16FB109A
	dbra	d0,adrLp006368	;51C8FFD2
	lea	adrEA014AA4.l,a2	;45F900014AA4
	lea	adrEA014B24.l,a3	;47F900014B24
	move.b	$001F(a5),$0001(a2)	;156D001F0001
	move.b	$001D(a5),(a2)	;14AD001D
	move.b	#$FF,$0002(a2)	;157C00FF0002
adrLp0063B4:	move.l	a2,a0	;204A
	move.l	a3,a1	;224B
adrCd0063B8:	moveq	#$00,d7	;7E00
	move.b	(a0)+,d7	;1E18
	bmi.s	adrCd0063FA	;6B3C
	swap	d7	;4847
	move.b	(a0)+,d7	;1E18
	subq.w	#$01,d7	;5347
	bcs.s	adrCd0063CA	;6504
	moveq	#$02,d1	;7202
	bsr.s	adrCd00640A	;6140
adrCd0063CA:	addq.w	#$02,d7	;5447
	cmp.w	adrW_00F9CE.l,d7	;BE790000F9CE
	bcc.s	adrCd0063D8	;6404
	moveq	#$00,d1	;7200
	bsr.s	adrCd00640A	;6132
adrCd0063D8:	subq.w	#$01,d7	;5347
	swap	d7	;4847
	addq.w	#$01,d7	;5247
	cmp.w	adrW_00F9CC.l,d7	;BE790000F9CC
	bcc.s	adrCd0063EE	;6408
	swap	d7	;4847
	moveq	#$03,d1	;7203
	bsr.s	adrCd00640A	;611E
	swap	d7	;4847
adrCd0063EE:	subq.w	#$02,d7	;5547
	bcs.s	adrCd0063B8	;65C6
	swap	d7	;4847
	moveq	#$01,d1	;7201
	bsr.s	adrCd00640A	;6112
	bra.s	adrCd0063B8	;60BE

adrCd0063FA:	cmp.l	a1,a3	;B7C9
	beq.s	adrCd006432	;6734
	move.b	#$FF,(a1)	;12BC00FF
	exg	a3,a2	;C74A
	dbra	d2,adrLp0063B4	;51CAFFAE
	rts	;4E75

adrCd00640A:	move.w	d7,d0	;3007
	mulu	adrW_00F9CC.l,d0	;C0F90000F9CC
	swap	d7	;4847
	add.w	d7,d0	;D047
	swap	d7	;4847
	tst.b	$00(a6,d0.w)	;4A360000
	bmi.s	adrCd006432	;6B14
	beq.s	adrCd006422	;6702
	rts	;4E75

adrCd006422:	or.b	#$80,d1	;00010080
	move.b	d1,$00(a6,d0.w)	;1D810000
	swap	d7	;4847
	move.b	d7,(a1)+	;12C7
	swap	d7	;4847
	move.b	d7,(a1)+	;12C7
adrCd006432:	rts	;4E75

adrEA006434:	dc.w	$0001	;0001
	dc.w	$00FF	;00FF
	dc.w	$0101	;0101
	dc.w	$FFFF	;FFFF
	dc.w	$FF00	;FF00
	dc.w	$0100	;0100
	dc.w	$FF01	;FF01
	dc.w	$01FF	;01FF

Click_CloseSpellBook:	clr.w	$0014(a5)	;426D0014
	bra	adrCd008FFC	;60002BB2

adrCd00644C:	btst	#$06,$0018(a5)	;082D00060018
	bne.s	adrCd006432	;66DE
	pea	AdrCd008FA8.l	;487900008FA8
adrCd00645A:	move.w	$000C(a5),d0	;302D000C
	bmi.s	adrCd006432	;6BD2
	asl.w	#$02,d0		;E540
	lea	adrJT00646E.l,a0	;41F90000646E
	move.l	$00(a0,d0.w),a0		;20700000
	jmp	(a0)		;4ED0

adrJT00646E:	
	dc.l	adrJC0072F8	;000072F8
	dc.l	Click_ShowStats	;00007288
	dc.l	Click_MultiFunctionButton	;0000711A
adrJC00647A:	
	dc.l	Click_OpenInventory	;000078BC
	dc.l	adrJC006BC0	;00006BC0
	dc.l	Click_Display_Centre	;00006BB6
	dc.l	Click_PartyMember	;00007222
	dc.l	Click_PartyMember	;00007222
	dc.l	Click_PartyMember	;00007222
	dc.l	Click_PartyMember	;00007222
	dc.l	Click_MoveForwards	;00007ABC
	dc.l	Click_MoveBackwards	;00007AC0
	dc.l	Click_MoveLeft	;00007AC4
	dc.l	Click_MoveRight	;00007AC8
	dc.l	Click_RotateLeft	;00007C2C
	dc.l	Click_RotateRight	;00007C3A
	dc.l	Click_Display	;00006530
	dc.l	adrJC0078D6	;000078D6
	dc.l	adrJC007724	;00007724
	dc.l	Click_Item_17_to_1A_Potions	;000075F0
	dc.l	adrJC006502	;00006502
	dc.l	Click_LaunchSpellFromBook	;00005838
	dc.l	Click_ViewSpell	;00006252
	dc.l	Click_TurnSpellBookPage	;0000CEB4
	dc.l	Click_CloseSpellBook	;00006444
	dc.l	Click_TurnSpellBookPage	;0000CEB4
	dc.l	adrJC0049A0	;000049A0
	dc.l	adrJC006502	;00006502
	dc.l	adrJC0049F2	;000049F2
	dc.l	Click_LoadSaveGame	;00004ABE
	dc.l	Click_SleepParty	;00004CD8
	dc.l	adrJC0039F2	;000039F2
	dc.l	adrJC0055CC	;000055CC
	dc.l	adrJC003A7E	;00003A7E
	dc.l	adrJC006960	;00006960
	dc.l	adrJC006536	;00006536
	dc.l	adrJC007140	;00007140

adrJC006502:	rts	;4E75

adrEA006504:	dc.w	$0074	;0074
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

adrCd00651C:
	moveq	#$22,d0	;7022
	moveq	#$26,d2	;7426
	lea	adrEA006504.l,a6	;4DF900006504
	move.w	#$FFFF,$000C(a5)	;3B7CFFFF000C
	bra	adrCd005772	;6000F244

Click_Display:	bsr.s	adrCd00651C	;61EA
	bra	adrCd00645A	;6000FF26

adrJC006536:	bsr	adrCd00924C	;61002D14
	cmp.w	adrW_00F9CE.l,d7	;BE790000F9CE
	bcc.s	adrCd00658C	;644A
	swap	d7	;4847
	cmp.w	adrW_00F9CC.l,d7	;BE790000F9CC
	bcc.s	adrCd00658C	;6440
	swap	d7	;4847
	move.w	$00(a6,d0.w),d2	;34360000
	move.w	d2,d3	;3602
	and.w	#$0007,d2	;02420007
	subq.w	#$01,d2	;5342
	bne	adrJC007140	;66000BE4
	tst.b	d3	;4A03
	bpl.s	adrCd00658C	;6A2A
	move.b	$01(a6,d0.w),d3	;16360001
	lsr.w	#$04,d3	;E84B
	and.w	#$0003,d3	;02430003
	eor.w	#$0002,d3	;0A430002
	cmp.w	$0020(a5),d3	;B66D0020
	bne.s	adrCd00658C	;6616
	move.b	$00(a6,d0.w),d3	;16360000
	and.w	#$0003,d3	;02430003
	add.w	d3,d3	;D643
	lea	MainWall_Action_01.l,a0	;41F900006596
	add.w	adrJT00658E(pc,d3.w),a0	;D0FB3006
	jmp	(a0)	;4ED0

adrCd00658C:	rts	;4E75

adrJT00658E:
	dc.w	MainWall_Action_01-MainWall_Action_01	;0000
	dc.w	MainWall_Action_02-MainWall_Action_01	;0018
	dc.w	MainWall_Action_03-MainWall_Action_01	;021C
	dc.w	MainWall_Action_04-MainWall_Action_01	;0062

MainWall_Action_01:
	move.w	$0004(a5),d1	;322D0004
	sub.w	$0008(a5),d1	;926D0008
	moveq	#$02,d6	;7C02
	cmp.w	#$0033,d1	;0C410033
	bcs	adrCd006970	;650003CA
	moveq	#$03,d6	;7C03
	bra	adrCd006970	;600003C4

MainWall_Action_02:	moveq	#$00,d1	;7200
	move.b	$00(a6,d0.w),d1	;12360000
	lsr.b	#$02,d1	;E409
	subq.b	#$05,d1	;5B01
	bcc.s	adrCd0065BC	;6402
	rts	;4E75

adrCd0065BC:	move.w	d1,-(sp)	;3F01
	bsr	adrCd00D58C	;61006FCC
	move.w	(sp)+,d1	;321F
	move.w	CurrentTower.l,d0	;30390000F98A
	add.b	ScrollTowerOffsets(pc,d0.w),d1	;D23B0026
	lea	adrEA017952.l,a0	;41F900017952
	lea	$0092(a0),a6	;4DE80092
	add.w	d1,d1	;D241
	add.w	$00(a0,d1.w),a6	;DCF01000
	move.w	#$0004,$0014(a5)	;3B7C00040014
	move.l	#$00000003,adrW_00E3FA.l	;23FC000000030000E3FA
	bra	adrCd00DAA6	;600074B6

ScrollTowerOffsets:
	dc.b	$00	;00
	dc.b	$15	;15
	dc.b	$21	;21
	dc.b	$29	;29
	dc.b	$31	;31
	dc.b	$3B	;3B

MainWall_Action_04:	moveq	#$00,d1	;7200
	move.b	$00(a6,d0.w),d1	;12360000
	btst	#$02,d1	;08010002
	bne.s	adrCd006626	;6622
	tst.w	$002E(a5)	;4A6D002E
	bne.s	adrCd006624	;661A
	lsr.w	#$03,d1	;E649
	add.w	#$0060,d1	;06410060
	move.w	d1,$002E(a5)	;3B41002E
	move.w	#$0001,$002C(a5)	;3B7C0001002C
	bset	#$02,$00(a6,d0.w)	;08F600020000
	bra	adrCd006962	;60000340

adrCd006624:	rts	;4E75

adrCd006626:	lsr.w	#$03,d1	;E649
	add.w	#$0060,d1	;06410060
	cmp.w	$002E(a5),d1	;B26D002E
	bne.s	adrCd006624	;66F2
	clr.l	$002C(a5)	;42AD002C
	movem.l	d0/a6,-(sp)	;48E78002
	bsr	adrCd006962	;61000326
	movem.l	(sp)+,d0/a6	;4CDF4001
	move.b	$00(a6,d0.w),d1	;12360000
	lsr.w	#$02,d1	;E449
	and.w	#$000E,d1	;0241000E
	lea	SocketActions_SerpentCrystal.l,a0	;41F90000666E
	add.w	Sockets_LookupTable(pc,d1.w),a0	;D0FB100A
	jsr	(a0)	;4E90
	moveq	#$05,d0	;7005
	bra	PlaySound	;60003032

Sockets_LookupTable:
	dc.w	SocketActions_SerpentCrystal-SocketActions_SerpentCrystal	;0000
	dc.w	SocketActions_ChaosCrystal-SocketActions_SerpentCrystal	;0024
	dc.w	SocketActions_DragonCrystal-SocketActions_SerpentCrystal	;0056
	dc.w	SocketActions_MoonCrystal-SocketActions_SerpentCrystal	;0076
	dc.w	Exit_SocketAction-SocketActions_SerpentCrystal	;0022
	dc.w	Actions_4-SocketActions_SerpentCrystal	;00D8
	dc.w	Exit_SocketAction-SocketActions_SerpentCrystal	;0022
	dc.w	Actions_5-SocketActions_SerpentCrystal	;00D0

SocketActions_SerpentCrystal:
	moveq	#$06,d4	;7806
	moveq	#$12,d6	;7C12
	bsr	adrCd0066FC	;61000088
	cmp.w	#$0003,CurrentTower.l	;0C7900030000F98A
	bne.s	OpenDoor_SocketAction	;663A
	move.l	#$00070004,d7	;2E3C00070004
Last_CrystalAction:
	bsr	CoordToMap	;61002BE4
	and.w	#$00F8,$00(a6,d0.w)	;027600F80000
Exit_SocketAction:	rts	;4E75

SocketActions_ChaosCrystal:	bclr	#$02,$00(a6,d0.w)	;08B600020000
	movem.l	d0/a6,-(sp)	;48E78002
	bsr	adrCd009268	;61002BCA
	bsr	adrCd008598	;61001EF6
	movem.l	(sp)+,d0/a6	;4CDF4001
	cmp.w	#$0003,CurrentTower.l	;0C7900030000F98A
	bne.s	OpenDoor_SocketAction	;6608
	move.l	#$00070003,d7	;2E3C00070003
	bra.s	Last_CrystalAction	;60CC

OpenDoor_SocketAction:	addq.w	#$02,d0	;5440
	bclr	#$00,$00(a6,d0.w)	;08B600000000
	rts	;4E75

SocketActions_DragonCrystal:	moveq	#$0A,d4	;780A
	moveq	#$11,d6	;7C11
	bsr.s	adrCd0066FC	;6132
	cmp.w	#$0003,CurrentTower.l	;0C7900030000F98A
	bne.s	OpenDoor_SocketAction	;66E6
	move.l	#$00070001,d7	;2E3C00070001
	bsr.s	Last_CrystalAction	;61AA
	or.w	#$D206,$00(a6,d0.w)	;0076D2060000
	rts	;4E75

SocketActions_MoonCrystal:	moveq	#$0C,d4	;780C
	moveq	#$13,d6	;7C13
	bsr.s	adrCd0066FC	;6112
	cmp.w	#$0003,CurrentTower.l	;0C7900030000F98A
	bne.s	OpenDoor_SocketAction	;66C6
	move.l	#$00070002,d7	;2E3C00070002
	bra.s	Last_CrystalAction	;608A

adrCd0066FC:	movem.l	d0/a6,-(sp)	;48E78002
	bclr	#$02,$00(a6,d0.w)	;08B600020000
	moveq	#$03,d7	;7E03
adrLp006708:	move.b	$18(a5,d7.w),d0	;10357018
	bmi.s	adrCd006726	;6B18
	bsr	adrCd0072D4	;61000BC4
	cmp.w	#$0006,d4	;0C440006
	bne.s	adrCd006720	;6608
	move.w	$0008(a4),$0006(a4)	;396C00080006
	bra.s	adrCd006726	;6006

adrCd006720:	move.b	$01(a4,d4.w),$00(a4,d4.w)	;19B440014000
adrCd006726:	dbra	d7,adrLp006708	;51CFFFE0
	bsr	adrCd009268	;61002B3C
	move.w	d6,d7	;3E06
	bsr	adrCd00222A	;6100BAF8
	bsr	adrCd008D52	;6100261C
	movem.l	(sp)+,d0/a6	;4CDF4001
	rts	;4E75

Actions_5:	lea	TanGemLocs.l,a0	;41F900006792
	bra.s	TeleportGem	;6006

Actions_4:	lea	BlueGemLocs.l,a0	;41F9000067A2
TeleportGem:	move.w	CurrentTower.l,d1	;32390000F98A
	asl.w	#$02,d1	;E541
	add.w	d1,a0	;D0C1
	moveq	#$00,d6	;7C00
	move.b	(a0)+,d6	;1C18
	swap	d6	;4846
	move.b	(a0)+,d6	;1C18
	cmp.l	$001C(a5),d6	;BCAD001C
	bne.s	adrCd00676A	;6606
	move.b	(a0)+,d6	;1C18
	swap	d6	;4846
	move.b	(a0),d6	;1C10
adrCd00676A:	bsr	adrCd009268	;61002AFC
	bclr	#$07,$01(a6,d0.w)	;08B600070001
	move.l	d6,$001C(a5)	;2B46001C
	bsr	adrCd00924C	;61002AD2
	bchg	#$02,$00(a6,d0.w)	;087600020000
	bsr	adrCd009268	;61002AE4
	bset	#$07,$01(a6,d0.w)	;08F600070001
	moveq	#$10,d7	;7E10
	bra	adrCd00222A	;6000BA9A

TanGemLocs:
	INCBIN bext-data/gem-bluex.locations

BlueGemLocs:
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$090B	;090B
	dc.w	$0102	;0102
	dc.w	$0606	;0606
	dc.w	$0B0E	;0B0E
	dc.w	$010D	;010D
	dc.w	$0102	;0102

MainWall_Action_03:
	moveq	#$00,d1	;7200
	move.b	$00(a6,d0.w),d1	;12360000
	and.w	#$00F8,d1	;024100F8
	beq.s	adrJB0067EE	;6730
	bchg	#$02,$00(a6,d0.w)	;087600020000
	lsr.b	#$01,d1	;E209
	move.w	CurrentTower.l,d0	;30390000F98A
	asl.w	#$06,d0	;ED40
	lea	SwitchData_1.l,a1	;43F900006808
	add.w	d0,a1	;D2C0
	moveq	#$00,d0	;7000
	move.b	$00(a1,d1.w),d0	;10311000
	lea	adrJB0067EE.l,a0	;41F9000067EE
	add.w	Switch_00_s00_Null(pc,d0.w),a0	;D0FB000C
	jsr	(a0)	;4E90
	moveq	#$00,d0	;7000
	bra	PlaySound	;60002EA2

adrJB0067EE:	rts	;4E75

Switch_00_s00_Null:
	dc.w	adrJB0067EE-adrJB0067EE	;0000
	dc.w	Switch_01_s02_Trigger_11_t16_RemoveXY-adrJB0067EE	;0146
	dc.w	Switch_02_s04_Trigger_23_t2E-adrJB0067EE	;0130
	dc.w	Switch_03_s06_Trigger_03_t06_OpenLockedDoorXY-adrJB0067EE	;1BE6
	dc.w	Switch_04_s08_Trigger_22_t2C_RotateWallXY-adrJB0067EE	;1B52
	dc.w	Switch05_s0A_Trigger_13_t1A_TogglePillarXY-adrJB0067EE	;1C0E
	dc.w	Switch06_s0C_Trigger_18_t24_CreatePillarXY-adrJB0067EE	;1C0A
	dc.w	Switch_07_s0E_Trigger_26_t34_RotateWoodXY-adrJB0067EE	;1BFA
	dc.w	Switch_03_s06_Trigger_03_t06_OpenLockedDoorXY-adrJB0067EE	;1BE6
	dc.w	adrJC006908-adrJB0067EE	;011A
	dc.w	Trigger_14_t1C-adrJB0067EE	;1C20
	dc.w	Trigger_25_t32-adrJB0067EE	;1C38
SwitchData_1:
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0200	;0200
	dc.w	$0711	;0711
	dc.w	$0200	;0200
	dc.w	$0F11	;0F11
	dc.w	$0E00	;0E00
	dc.w	$0303	;0303
	dc.w	$0200	;0200
	dc.w	$0C05	;0C05
	dc.w	$0200	;0200
	dc.w	$0A0A	;0A0A
	dc.w	$0200	;0200
	dc.w	$000D	;000D
	dc.w	$0E00	;0E00
	dc.w	$0601	;0601
	dc.w	$0E00	;0E00
	dc.w	$0A07	;0A07
	dc.w	$0E00	;0E00
	dc.w	$0E05	;0E05
	dc.w	$0E00	;0E00
	dc.w	$0A05	;0A05
	dc.w	$0E00	;0E00
	dc.w	$0D07	;0D07
	dc.w	$0E00	;0E00
	dc.w	$0B00	;0B00
	dc.w	$0E00	;0E00
	dc.w	$0C00	;0C00
	dc.w	$0200	;0200
	dc.w	$0804	;0804
	dc.w	$0200	;0200
	dc.w	$0105	;0105
SwitchData_2:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0200	;0200
	dc.w	$0411	;0411
	dc.w	$0200	;0200
	dc.w	$1012	;1012
	dc.w	$0200	;0200
	dc.w	$0A0A	;0A0A
	dc.w	$1000	;1000
	dc.w	$0A0F	;0A0F
	dc.w	$0E00	;0E00
	dc.w	$0B13	;0B13
	dc.w	$0200	;0200
	dc.w	$140D	;140D
	dc.w	$0E00	;0E00
	dc.w	$0B01	;0B01
	dc.w	$0E00	;0E00
	dc.w	$1102	;1102
	dc.w	$1200	;1200
	dc.w	$0000	;0000
	dc.w	$0E00	;0E00
	dc.w	$0901	;0901
	dc.w	$0200	;0200
	dc.w	$0303	;0303
	dc.w	$0200	;0200
	dc.w	$060E	;060E
	dc.w	$0200	;0200
	dc.w	$0614	;0614
	dc.w	$0200	;0200
	dc.w	$0803	;0803
	dc.w	$0200	;0200
	dc.w	$1202	;1202
SwitchData_3:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0200	;0200
	dc.w	$0306	;0306
	dc.w	$0200	;0200
	dc.w	$050D	;050D
	dc.w	$0200	;0200
	dc.w	$0605	;0605
	dc.w	$0200	;0200
	dc.w	$0702	;0702
	dc.w	$1000	;1000
	dc.w	$0701	;0701
	dc.w	$1442	;1442
	dc.w	$0801	;0801
	dc.w	$0E00	;0E00
	dc.w	$0902	;0902
	dc.w	$0E00	;0E00
	dc.w	$0900	;0900
	dc.w	$1200	;1200
	dc.w	$0000	;0000
	dc.w	$0200	;0200
	dc.w	$0906	;0906
	dc.w	$0200	;0200
	dc.w	$0402	;0402
	dc.w	$0200	;0200
	dc.w	$0C00	;0C00
	dc.w	$0200	;0200
	dc.w	$0600	;0600
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
SwitchData_4:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0200	;0200
	dc.w	$0504	;0504
	dc.w	$1400	;1400
	dc.w	$0801	;0801
	dc.w	$1400	;1400
	dc.w	$0802	;0802
	dc.w	$1400	;1400
	dc.w	$0803	;0803
	dc.w	$1400	;1400
	dc.w	$0804	;0804
	dc.w	$0200	;0200
	dc.w	$0511	;0511
	dc.w	$0200	;0200
	dc.w	$070B	;070B
	dc.w	$1600	;1600
	dc.w	$0502	;0502
	dc.w	$1600	;1600
	dc.w	$0501	;0501
	dc.w	$0E00	;0E00
	dc.w	$0506	;0506
	dc.w	$0200	;0200
	dc.w	$0A00	;0A00
	dc.w	$0200	;0200
	dc.w	$0905	;0905
	dc.w	$0200	;0200
	dc.w	$0001	;0001
	dc.w	$0200	;0200
	dc.w	$070A	;070A
	dc.w	$0000	;0000
	dc.w	$0000	;0000

adrJC006908:
	bsr	adrCd00924C	;61002942
	and.w	#$0040,$00(a6,d0.w)	;027600400000
	or.w	#$6306,$00(a6,d0.w)	;007663060000
	rts	;4E75

Switch_00_s00_Trigger_15_t1E_ToggleWallXY:
	bsr	Switch_01_s02_Trigger_11_t16_RemoveXY	;61000018
Switch_02_s04_Trigger_23_t2E:
	bsr.s	adrCd006950	;6130
	tst.b	$01(a6,d0.w)	;4A360001
	bmi.s	adrCd006932	;6B0C
	and.w	#$00F9,$00(a6,d0.w)	;027600F90000
	eor.b	#$01,$01(a6,d0.w)	;0A3600010001
adrCd006932:
	rts	;4E75

Switch_01_s02_Trigger_11_t16_RemoveXY:
	bsr.s	adrCd006950	;611A
	move.b	$01(a6,d0.w),d2	;14360001
	and.w	#$0007,d2	;02420007
	subq.w	#$01,d2	;5342
	bne.s	adrCd006948	;6606
	and.b	#$4F,$01(a6,d0.w)	;0236004F0001
adrCd006948:
	and.b	#$F8,$01(a6,d0.w)	;023600F80001
	rts	;4E75

adrCd006950:	moveq	#$00,d7	;7E00
	move.b	$02(a1,d1.w),d7	;1E311002
	swap	d7	;4847
	move.b	$03(a1,d1.w),d7	;1E311003
	bra	CoordToMap	;6000290E

adrJC006960:	bsr.s	adrCd006974	;6112
adrCd006962:	cmp.w	#$0003,$0014(a5)	;0C6D00030014
	beq	adrCd007900	;67000F96
	bra	adrCd0079A0	;60001032

adrCd006970:	bsr.s	adrCd0069C0	;614E
	bra.s	adrCd006962	;60EE

adrCd006974:	move.l	$0002(a5),d1	;222D0002
	sub.w	$0008(a5),d1	;926D0008
	moveq	#$02,d6	;7C02
	cmp.w	#$0051,d1	;0C410051
	bcs.s	adrCd006986	;6502
	subq.w	#$02,d6	;5546
adrCd006986:	swap	d1	;4841
	cmp.w	#$00A0,d1	;0C4100A0
	bcs.s	adrCd006990	;6502
	addq.w	#$01,d6	;5246
adrCd006990:	move.l	$001C(a5),d7	;2E2D001C
	cmp.w	#$0002,d6	;0C460002
	bcc.s	adrCd0069A0	;6406
	bsr	CoordToMap	;610028D0
	bra.s	adrCd0069C0	;6020

adrCd0069A0:	bsr	adrCd009250	;610028AE
	cmp.w	adrW_00F9CE.l,d7	;BE790000F9CE
	bcc.s	adrCd0069BE	;6412
	swap	d7	;4847
	cmp.w	adrW_00F9CC.l,d7	;BE790000F9CC
	bcc.s	adrCd0069BE	;6408
	swap	d7	;4847
	bsr	adrCd006A64	;610000AA
	bcc.s	adrCd0069C0	;6402
adrCd0069BE:	rts	;4E75

adrCd0069C0:	bclr	#$03,$01(a6,d0.w)	;08B600030001
	tst.w	$002E(a5)	;4A6D002E
	bne	adrCd006A9E	;660000D2
	btst	#$06,$01(a6,d0.w)	;083600060001
	beq.s	adrCd0069BE	;67E8
	bsr	adrCd006B50	;61000178
	bsr	adrCd006B7E	;610001A2
	bne.s	adrCd0069BE	;66DE
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
	bcc.s	adrCd006A0E	;640A
	move.w	d1,d2	;3401
	cmp.b	#$64,d2	;0C020064
	bcs.s	adrCd006A0E	;6502
	moveq	#$63,d2	;7463
adrCd006A0E:	move.w	d2,$002C(a5)	;3B42002C
	sub.b	d2,d1	;9202
	move.b	d1,$01(a1,d3.w)	;13813001
	bne.s	adrCd0069BE	;66A4
adrCd006A1A:	subq.b	#$01,-$0001(a1)	;5329FFFF
	bcs.s	adrCd006A40	;6520
	lea	$00(a1,d3.w),a1	;43F13000
	lea	$0002(a1),a2	;45E90002
	add.w	d3,d7	;DE43
	addq.w	#$03,d7	;5647
	subq.w	#$02,-$0002(a0)	;5568FFFE
adrCd006A30:	move.w	-$0002(a0),d2	;3428FFFE
	sub.w	d7,d2	;9447
	bra.s	adrCd006A3A	;6002

adrLp006A38:	move.b	(a2)+,(a1)+	;12DA
adrCd006A3A:	dbra	d2,adrLp006A38	;51CAFFFC
	rts	;4E75

adrCd006A40:	lea	$00(a0,d7.w),a1	;43F07000
	lea	$0005(a1),a2	;45E90005
	subq.w	#$05,-$0002(a0)	;5B68FFFE
	bsr.s	adrCd006A30	;61E2
	moveq	#$03,d5	;7A03
adrLp006A50:	move.w	d5,d6	;3C05
	bsr	adrCd006B7E	;6100012A
	beq.s	adrCd006A62	;670A
	dbra	d5,adrLp006A50	;51CDFFF6
	bclr	#$06,$01(a6,d0.w)	;08B600060001
adrCd006A62:	rts	;4E75

adrCd006A64:	swap	d6	;4846
	move.w	$0020(a5),d6	;3C2D0020
	move.w	d0,d2	;3400
	bsr	adrCd009268	;610027FA
	bsr	adrCd008798	;61001D26
	bcs.s	adrCd006A9C	;6526
	move.w	d2,d0	;3002
	move.b	$01(a6,d0.w),d1	;12360001
	and.w	#$0007,d1	;02410007
	subq.w	#$01,d1	;5341
	beq.s	adrCd006A98	;6714
	subq.w	#$01,d1	;5341
	bne.s	adrCd006A92	;660A
	eor.w	#$0002,d6	;0A460002
	bsr	adrCd0087A6	;61001D18
	bcs.s	adrCd006A9C	;650A
adrCd006A92:	move.w	d2,d0	;3002
	swap	d6	;4846
	rts	;4E75

adrCd006A98:	sub.b	#$FF,d1	;040100FF
adrCd006A9C:	rts	;4E75

adrCd006A9E:	move.l	$002C(a5),d5	;2A2D002C
	clr.l	$002C(a5)	;42AD002C
	bsr	adrCd006B50	;610000A8
adrCd006AAA:	bclr	#$03,$01(a6,d0.w)	;08B600030001
	bsr	adrCd006B7E	;610000CC
	bne	adrCd006B26	;66000070
	lea	$03(a0,d7.w),a1	;43F07003
	moveq	#$00,d3	;7600
	move.b	-$0001(a1),d3	;1629FFFF
	add.w	d3,d3	;D643
adrCd006AC4:	cmp.b	$00(a1,d3.w),d5	;BA313000
	beq.s	adrCd006B04	;673A
	subq.w	#$02,d3	;5543
	bcc.s	adrCd006AC4	;64F6
adrCd006ACE:	move.w	-$0002(a0),d2	;3428FFFE
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
	bra.s	adrCd006AF4	;6002

adrLp006AF2:	move.b	-(a0),-(a2)	;1520
adrCd006AF4:	dbra	d2,adrLp006AF2	;51CAFFFC
	move.b	d5,$00(a1,d3.w)	;13853000
	swap	d5	;4845
	move.b	d5,$01(a1,d3.w)	;13853001
	rts	;4E75

adrCd006B04:	swap	d5	;4845
	add.b	$01(a1,d3.w),d5	;DA313001
	tst.b	-$0001(a1)	;4A29FFFF
	bne.s	adrCd006B16	;6606
	move.b	d5,$01(a1,d3.w)	;13853001
	rts	;4E75

adrCd006B16:	swap	d5	;4845
	move.w	d7,d1	;3207
	bsr	adrCd006A1A	;6100FEFE
	move.w	d1,d7	;3E01
	lea	$03(a0,d7.w),a1	;43F07003
	bra.s	adrCd006ACE	;60A8

adrCd006B26:	bset	#$06,$01(a6,d0.w)	;08F600060001
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

adrCd006B50:	move.w	$0020(a5),d1	;322D0020
	add.w	d1,d1	;D241
	add.w	d1,d1	;D241
	add.w	d6,d1	;D246
	move.b	adrB_006B60(pc,d1.w),d6	;1C3B1004
	rts	;4E75

adrB_006B60:	dc.b	$00	;00
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

adrCd006B70:	lea	adrEA015860.l,a0	;41F900015860
adrCd006B76:	cmp.w	(a0),d0	;B050
	beq.s	adrCd006BB4	;673A
	addq.w	#$04,a0	;5848
	bra.s	adrCd006B76	;60F8

adrCd006B7E:	move.l	adrL_00F9D4.l,a0	;20790000F9D4
	add.w	#$0FCA,a0	;D0FC0FCA
	move.w	d0,d1	;3200
	ror.w	#$08,d1	;E059
	ror.b	#$02,d6	;E41E
	or.b	d6,d1	;8206
	moveq	#$00,d7	;7E00
	moveq	#$00,d2	;7400
adrCd006B94:	cmp.w	-$0002(a0),d7	;BE68FFFE
	bcc.s	adrCd006BB2	;6418
	cmp.b	$01(a0,d7.w),d0	;B0307001
	bne.s	adrCd006BA6	;6606
	cmp.b	$00(a0,d7.w),d1	;B2307000
	beq.s	adrCd006BB4	;670E
adrCd006BA6:	move.b	$02(a0,d7.w),d2	;14307002
	add.w	d2,d2	;D442
	add.w	d2,d7	;DE42
	addq.w	#$05,d7	;5A47
	bra.s	adrCd006B94	;60E2

adrCd006BB2:	moveq	#$01,d1	;7201
adrCd006BB4:	rts	;4E75

Click_Display_Centre:
	and.b	#$01,(a5)	;02150001
	bset	#$03,(a5)	;08D50003
	bra.s	adrCd006BC8	;6008

adrJC006BC0:	and.b	#$01,(a5)	;02150001
	bset	#$01,(a5)	;08D50001
adrCd006BC8:	moveq	#$03,d1	;7203
	bsr	adrCd006128	;6100F55C
	tst.w	d3	;4A43
	bmi.s	adrCd006BB4	;6BE2
	swap	d3	;4843
	move.w	d3,d0	;3003
	bsr	adrCd0072D4	;610006FC
	clr.b	$0015(a4)	;422C0015
	bsr	adrCd008F3E	;6100235E
	bra	adrCd008894	;60001CB0

adrCd006BE6:	lea	_GFX_Pockets+$6508.l,a1	;43F90004F9BA
	moveq	#$00,d0	;7000
	move.b	$18(a5,d7.w),d0	;10357018
	move.w	d0,d1	;3200
	and.w	#$000F,d1	;0241000F
	and.w	#$00E0,d0	;024000E0
	bne.s	adrCd006BB4	;66B6
	move.w	d1,d0	;3001
	asl.w	#$06,d0	;ED40
	lea	CharacterStats.l,a0	;41F90000F586
	add.w	d0,a0	;D0C0
	move.b	$0001(a0),d1	;12280001
	move.w	d1,d0	;3001
	bsr	adrCd0009E0	;61009DCE
	mulu	#$0460,d1	;C2FC0460
	add.w	d1,a1	;D2C1
	move.w	d0,d1	;3200
	bsr	adrCd0075DC	;610009BE
	cmp.w	#$0010,d1	;0C410010
	bcs.s	adrCd006C28	;6502
	addq.w	#$04,d0	;5840
adrCd006C28:	move.b	adrB_006C48(pc,d0.w),d3	;163B001E
	move.w	d7,d0	;3007
	add.w	d0,d0	;D040
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	$000A(a5),a0	;D0ED000A
	add.w	adrW_006C50(pc,d0.w),a0	;D0FB0014
	move.l	#$00000006,-(sp)	;2F3C00000006
	bra	adrCd008BBA	;60001F74

adrB_006C48:	dc.b	$06	;06
	dc.b	$0D	;0D
	dc.b	$0C	;0C
	dc.b	$08	;08
	dc.b	$05	;05
	dc.b	$0B	;0B
	dc.b	$09	;09
	dc.b	$07	;07
adrW_006C50:	dc.w	$0DF4	;0DF4
	dc.w	$0000	;0000
	dc.w	$000D	;000D
	dc.w	$001B	;001B

adrCd006C58:	sub.w	$0020(a1),d0	;90690020
	addq.w	#$02,d0	;5440
	eor.w	#$0001,d2	;0A420001
	add.w	d2,d0	;D042
	and.w	#$0003,d0	;02400003
	moveq	#$00,d1	;7200
	move.b	$26(a1,d0.w),d1	;12310026
	bpl.s	adrCd006C86	;6A16
	sub.w	d2,d0	;9042
	eor.w	#$0001,d2	;0A420001
	add.w	d2,d0	;D042
	and.w	#$0003,d0	;02400003
	move.b	$26(a1,d0.w),d1	;12310026
	bpl.s	adrCd006C86	;6A04
	move.w	$0006(a1),d1	;32290006
adrCd006C86:	and.w	#$000F,d1	;0241000F
	clr.w	adrW_0070C6.l	;4279000070C6
	movem.l	d0/d1/a1/a4/a5,-(sp)	;48E7C04C
	move.w	d1,d0	;3001
	move.l	a1,a5	;2A49
	bsr	adrCd00480C	;6100DB72
	move.b	(a5),d2	;1415
	and.w	#$000A,d2	;0242000A
	beq.s	adrCd006CC4	;6720
	btst	#$04,$18(a5,d1.w)	;083500041018
	beq.s	adrCd006CB4	;6708
	and.w	#$0008,d2	;02420008
	beq.s	adrCd006CD0	;671E
	bra.s	adrCd006CC4	;6010

adrCd006CB4:	bsr	adrCd0072D4	;6100061E
	move.w	$0008(a4),d0	;302C0008
	lsr.w	#$01,d0	;E248
	cmp.w	$0006(a4),d0	;B06C0006
	bcs.s	adrCd006CD0	;650C
adrCd006CC4:	move.w	#$FFFF,adrW_0070C6.l	;33FCFFFF000070C6
	bset	d1,$003C(a5)	;03ED003C
adrCd006CD0:	movem.l	(sp)+,d0/d1/a1/a4/a5	;4CDF3203
adrCd006CD4:	rts	;4E75

adrCd006CD6:	tst.b	d7	;4A07
	bne.s	adrCd006CE2	;6608
	cmp.b	#$02,$0015(a5)	;0C2D00020015
	bcc.s	adrCd006CD4	;64F2
adrCd006CE2:	or.b	#$B0,$0054(a5)	;002D00B00054
	move.w	#$00F9,$004A(a5)	;3B7C00F9004A
	clr.w	$004C(a5)	;426D004C
	moveq	#$67,d4	;7867
	moveq	#$06,d5	;7A06
	swap	d4	;4844
	swap	d5	;4845
	move.b	adrB_006D0C(pc,d7.w),d4	;183B7010
	move.b	adrB_006D10(pc,d7.w),d5	;1A3B7010
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$00,d3	;7600
	bra	adrCd00E538	;6000782E

adrB_006D0C:	dc.b	$60	;60
	dc.b	$00	;00
	dc.b	$68	;68
	dc.b	$D8	;D8
adrB_006D10:	dc.b	$59	;59
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00

adrCd006D14:	move.w	#$00F9,$004A(a5)	;3B7C00F9004A
	clr.w	$004C(a5)	;426D004C
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	$000A(a5),a0	;D0ED000A
	move.l	a4,-(sp)	;2F0C
	move.b	$18(a5,d7.w),d0	;10357018
	bsr	adrCd0072D4	;610005A4
	move.b	$001D(a4),d0	;102C001D
	move.l	(sp)+,a4	;285F
	lsr.b	#$04,d0	;E808
	subq.b	#$02,d0	;5500
	move.b	d0,$5E(a5,d7.w)	;1B80705E
	add.w	d7,d7	;DE47
	add.w	adrW_006D88(pc,d7.w),a0	;D0FB7044
	moveq	#$0B,d6	;7C0B
	tst.w	d7	;4A47
	bne.s	adrCd006D56	;660A
	moveq	#$0E,d6	;7C0E
	or.b	#$10,$0054(a5)	;002D00100054
	bra.s	adrCd006D5C	;6006

adrCd006D56:	or.b	#$A0,$0054(a5)	;002D00A00054
adrCd006D5C:	move.l	#$000D0000,adrW_00E3FA.l	;23FC000D00000000E3FA
	lea	OutcomeMsgs_0.l,a6	;4DF900006D96
	move.b	OutcomeMsgOffsets(pc,d4.w),d4	;183B4022
	bne.s	adrCd006D82	;6610
	move.w	d5,d0	;3005
	beq.s	adrCd006D84	;670E
	lea	OutcomeMsgs_5.l,a6	;4DF900006DBF
	moveq	#$09,d2	;7409
	bsr.s	adrCd006DCC	;614C
	moveq	#$00,d4	;7800
adrCd006D82:	add.w	d4,a6	;DCC4
adrCd006D84:	bra	adrLp00D9F4	;60006C6E

adrW_006D88:	dc.w	$0E1D	;0E1D
	dc.w	$0029	;0029
	dc.w	$0036	;0036
	dc.w	$0044	;0044
OutcomeMsgOffsets:	dc.b	OutcomeMsgs_0-OutcomeMsgs_0	;00
	dc.b	OutcomeMsgs_1-OutcomeMsgs_0	;07
	dc.b	OutcomeMsgs_2-OutcomeMsgs_0	;0E
	dc.b	OutcomeMsgs_3-OutcomeMsgs_0	;15
	dc.b	OutcomeMsgs_4-OutcomeMsgs_0	;21
	dc.b	OutcomeMsgs_5-OutcomeMsgs_0	;29
OutcomeMsgs_0:	dc.b	'MISSES'	;4D4953534553
	dc.b	$FF	;FF
OutcomeMsgs_1:	dc.b	'SHOOTS'	;53484F4F5453
	dc.b	$FF	;FF
OutcomeMsgs_2:	dc.b	'CHANTS'	;4348414E5453
	dc.b	$FF	;FF
OutcomeMsgs_3:	dc.b	'CASTS SPELL'	;4341535453205350454C4C
	dc.b	$FF	;FF
OutcomeMsgs_4:	dc.b	'DEFENDS'	;444546454E4453
	dc.b	$FF	;FF
OutcomeMsgs_5:	dc.b	'HITS FOR '	;4849545320464F5220
NumHitsMsg:	dc.b	'000'	;303030
	dc.b	$FF	;FF

adrCd006DCC:	move.w	d0,d1	;3200
	moveq	#$00,d0	;7000
	move.w	d1,d0	;3001
	divu	#$0064,d0	;80FC0064
	move.w	d0,d3	;3600
	beq.s	adrCd006DE4	;670A
	add.b	#$30,d0	;06000030
	move.b	d0,$00(a6,d2.w)	;1D802000
	addq.w	#$01,d2	;5242
adrCd006DE4:	swap	d0	;4840
	bsr	adrCd00D8DA	;61006AF2
	move.b	d1,d0	;1001
	ror.w	#$08,d1	;E059
	tst.w	d3	;4A43
	bne.s	adrCd006DF8	;6606
	cmp.b	#$30,d1	;0C010030
	beq.s	adrCd006DFE	;6706
adrCd006DF8:	move.b	d1,$00(a6,d2.w)	;1D812000
	addq.w	#$01,d2	;5242
adrCd006DFE:	move.b	d0,$00(a6,d2.w)	;1D802000
	move.b	#$FF,$01(a6,d2.w)	;1DBC00FF2001
	rts	;4E75

adrCd006E0A:	movem.l	d1/d3/a5,-(sp)	;48E75004
	lea	Player1_Data.l,a5	;4BF90000F9D8
	bsr.s	adrCd006E24	;610E
	lea	Player2_Data.l,a5	;4BF90000FA3A
	bsr.s	adrCd006E24	;6106
	movem.l	(sp)+,d1/d3/a5	;4CDF200A
	rts	;4E75

adrCd006E24:	cmp.b	$0035(a5),d1	;B22D0035
	beq	adrCd003A3E	;6700CC14
	rts	;4E75

adrCd006E2E:
	moveq	#$02,d0	;7002
	bsr	PlaySound	;6100285C
	bsr.s	adrCd006E0A	;61D4
	bsr	adrCd00708A	;61000252
	clr.w	$0000(a6)	;426E0000
	clr.w	adrW_002802.l	;427900002802
	bsr	adrCd0061EC	;6100F3A6
	add.w	$0002(a6),d0	;D06E0002
	move.w	d0,d2	;3400
	bsr	adrCd0061EC	;6100F39C
	add.w	$0004(a6),d0	;D06E0004
	sub.w	d0,d2	;9440
	bmi.s	adrCd006E66	;6B0C
	move.w	d2,d0	;3002
	moveq	#$40,d2	;7440
	sub.w	d0,d2	;9440
	bpl.s	adrCd006E72	;6A10
	moveq	#$01,d2	;7401
	bra.s	adrCd006E72	;600C

adrCd006E66:	neg.w	d2	;4442
	move.w	d2,d0	;3002
	moveq	#$40,d2	;7440
	cmp.w	d2,d0	;B042
	bpl	adrCd006EE8	;6A000078
adrCd006E72:	move.w	$0006(a6),d1	;322E0006
	bsr	adrCd0061F0	;6100F378
	addq.w	#$01,d0	;5240
	add.b	$0008(a6),d0	;D02E0008
	add.b	$000A(a6),d0	;D02E000A
	moveq	#$00,d1	;7200
	move.b	$0009(a6),d1	;122E0009
	sub.w	#$0014,d1	;04410014
	bcs.s	adrCd006E94	;6504
	lsr.w	#$03,d1	;E649
	add.w	d1,d0	;D041
adrCd006E94:	tst.w	adrW_006EEA.l	;4A7900006EEA
	bne.s	adrCd006EA2	;6606
	move.w	d0,d1	;3200
	add.w	d0,d0	;D040
	add.w	d1,d0	;D041
adrCd006EA2:	tst.w	adrB_003054.l	;4A7900003054
	beq.s	adrCd006EAC	;6702
	add.w	d0,d0	;D040
adrCd006EAC:	moveq	#$00,d4	;7800
	move.b	$000D(a6),d4	;182E000D
	lsr.b	#$01,d4	;E20C
	bcc.s	adrCd006EC4	;640E
	move.w	d2,d1	;3202
	and.w	#$000F,d1	;0241000F
	beq.s	adrCd006EC2	;6704
	subq.w	#$08,d1	;5141
	bcs.s	adrCd006EC4	;6502
adrCd006EC2:	addq.w	#$01,d4	;5244
adrCd006EC4:	sub.w	d4,d0	;9044
	bcs.s	adrCd006EE8	;6520
	beq.s	adrCd006EE8	;671E
	move.w	d0,d1	;3200
	cmp.w	#$0028,d2	;0C420028
	bcc.s	adrCd006EE4	;6412
	add.w	d1,d0	;D041
	cmp.w	#$0019,d2	;0C420019
	bcc.s	adrCd006EE4	;640A
	add.w	d1,d0	;D041
	cmp.w	#$000A,d2	;0C42000A
	bcc.s	adrCd006EE4	;6402
	add.w	d1,d0	;D041
adrCd006EE4:	move.w	d0,$0000(a6)	;3D400000
adrCd006EE8:	rts	;4E75

adrW_006EEA:	dc.w	$0000	;0000

adrCd006EEC:	moveq	#$00,d4	;7800
	moveq	#$00,d5	;7A00
	moveq	#$00,d6	;7C00
	moveq	#$00,d7	;7E00
	cmp.w	#$0010,d0	;0C400010
	bcs.s	adrCd006F28	;652E
	sub.w	#$0010,d0	;04400010
	asl.w	#$04,d0	;E940
	lea	UnpackedMonsters.l,a4	;49F900014EE6
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
	moveq	#$10,d4	;7810
	moveq	#$0A,d5	;7A0A
	rts	;4E75

adrCd006F28:
	move.w	d0,d1	;3200
	bsr	adrCd0072D4	;610003A8
	subq.b	#$03,$000A(a4)	;572C000A
	bcc.s	adrCd006F38	;6404
	clr.b	$000A(a4)	;422C000A
adrCd006F38:
	move.w	d1,d0	;3001
	bsr.s	adrCd006F82	;6146
	bsr	adrCd006FE8	;610000AA
	bsr	adrCd0009A4	;61009A62
	tst.w	adrW_006EEA.l	;4A7900006EEA
	bne.s	adrCd006F4E	;6602
	move.b	(a4),d0	;1014
adrCd006F4E:	moveq	#$00,d1	;7200
	move.b	$0015(a4),d1	;122C0015
	move.w	d1,d2	;3401
	and.w	#$0007,d2	;02420007
	subq.b	#$02,d2	;5502
	bne.s	adrCd006F76	;6618
	lsr.b	#$03,d1	;E609
	move.w	d1,d2	;3401
	lsr.w	#$02,d2	;E44A
	addq.w	#$01,d2	;5242
	add.w	d2,d0	;D042
	move.w	d1,d2	;3401
	add.b	$0002(a4),d1	;D22C0002
	addq.b	#$08,d1	;5001
	add.b	$0003(a4),d2	;D42C0003
	rts	;4E75

adrCd006F76:	move.b	$0002(a4),d1	;122C0002
	addq.b	#$08,d1	;5001
	move.b	$0003(a4),d2	;142C0003
	rts	;4E75

adrCd006F82:	move.b	$0015(a4),d3	;162C0015
	move.w	d3,d2	;3403
	lsr.b	#$03,d2	;E60A
	add.b	$0025(a4),d2	;D42C0025
	add.b	d2,d2	;D402
	and.w	#$0007,d3	;02430007
	beq.s	adrCd006F98	;6702
	moveq	#$00,d2	;7400
adrCd006F98:	move.b	$000E(a4),d3	;162C000E
	cmp.b	d3,d2	;B403
	bcs.s	adrCd006FA2	;6502
	move.b	d2,d3	;1602
adrCd006FA2:	move.b	$0032(a4),d2	;142C0032
	beq.s	adrCd006FB8	;6710
	sub.b	#$1B,d2	;0402001B
	add.b	d2,d2	;D402
	add.b	d2,d2	;D402
	addq.b	#$08,d2	;5002
	cmp.b	d2,d3	;B602
	bcc.s	adrCd006FB8	;6402
	move.b	d2,d3	;1602
adrCd006FB8:	move.b	$0016(a4),d2	;142C0016
	beq.s	adrCd006FC8	;670A
	sub.b	#$2B,d2	;0402002B
	add.b	d2,d2	;D402
	add.b	d2,d3	;D602
	add.b	d2,d3	;D602
adrCd006FC8:	moveq	#$00,d2	;7400
	move.b	$0033(a4),d2	;142C0033
	sub.b	#$24,d2	;04020024
	bcs.s	adrCd006FDE	;650A
	cmp.w	#$0007,d2	;0C420007
	bcc.s	adrCd006FDE	;6404
	add.b	adrB_006FE0(pc,d2.w),d3	;D63B2004
adrCd006FDE:	rts	;4E75

adrB_006FE0:	dc.b	$04	;04
	dc.b	$09	;09
	dc.b	$0E	;0E
	dc.b	$07	;07
	dc.b	$0C	;0C
	dc.b	$10	;10
	dc.b	$15	;15
	dc.b	$00	;00

adrCd006FE8:	moveq	#$00,d0	;7000
	move.b	$0030(a4),d0	;102C0030
	sub.b	#$30,d0	;04000030
	bcs.s	adrCd006FFA	;6506
	cmp.b	#$10,d0	;0C000010
	bcs.s	adrCd00700A	;6510
adrCd006FFA:	move.b	$0031(a4),d0	;102C0031
	sub.b	#$30,d0	;04000030
	bcs.s	adrCd007048	;6544
	cmp.b	#$10,d0	;0C000010
	bcc.s	adrCd007048	;643E
adrCd00700A:
	lea	adrEA00704A.l,a0	;41F90000704A
	asl.w	#$02,d0	;E540
	add.w	d0,a0	;D0C0
	move.b	(a0)+,d4	;1818
	move.b	(a0)+,d5	;1A18
	move.b	(a0)+,d6	;1C18
	move.b	(a0)+,d7	;1E18
	tst.w	adrW_006EEA.l	;4A7900006EEA
	bne.s	adrCd007032	;660E
	cmp.b	#$08,d0	;0C000008
	bcs.s	adrCd007032	;6508
	move.w	#$FFFF,adrW_006EEA.l	;33FCFFFF00006EEA
adrCd007032:
	cmp.b	#$1C,d0	;0C00001C
	bne.s	adrCd007048	;6610
	cmp.b	#$2B,$0016(a4)	;0C2C002B0016
	beq.s	adrCd007048	;6708
	moveq	#$14,d4	;7814
	moveq	#$0C,d5	;7A0C
	moveq	#$0A,d6	;7C0A
	moveq	#$0F,d7	;7E0F
adrCd007048:	rts	;4E75

adrEA00704A:	dc.b	$06	;06
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$10	;10
	dc.b	$08	;08
	dc.b	$0A	;0A
	dc.b	$00	;00
	dc.b	$0A	;0A
	dc.b	$05	;05
	dc.b	$0F	;0F
	dc.b	$0F	;0F
	dc.b	$0C	;0C
	dc.b	$0A	;0A
	dc.b	$0F	;0F
	dc.b	$1E	;1E
	dc.b	$10	;10
	dc.b	$0F	;0F
	dc.b	$19	;19
	dc.b	$0A	;0A
	dc.b	$14	;14
	dc.b	$0F	;0F
	dc.b	$28	;28
	dc.b	$1E	;1E
	dc.b	$14	;14
	dc.b	$19	;19
	dc.b	$1E	;1E
	dc.b	$1E	;1E
	dc.b	$20	;20
	dc.b	$1E	;1E
	dc.b	$3C	;3C
	dc.b	$32	;32
	dc.b	$0A	;0A
	dc.b	$08	;08
	dc.b	$05	;05
	dc.b	$00	;00
	dc.b	$0C	;0C
	dc.b	$0C	;0C
	dc.b	$0A	;0A
	dc.b	$00	;00
	dc.b	$14	;14
	dc.b	$0C	;0C
	dc.b	$28	;28
	dc.b	$0A	;0A
	dc.b	$14	;14
	dc.b	$14	;14
	dc.b	$28	;28
	dc.b	$14	;14
	dc.b	$14	;14
	dc.b	$1E	;1E
	dc.b	$1E	;1E
	dc.b	$14	;14
	dc.b	$06	;06
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$28	;28
	dc.b	$08	;08
	dc.b	$06	;06
	dc.b	$14	;14
	dc.b	$1E	;1E
	dc.b	$10	;10
	dc.b	$08	;08
	dc.b	$19	;19
	dc.b	$28	;28

adrCd00708A:
	lea	adrEA014EC4.l,a6	;4DF900014EC4
	move.w	d1,-(sp)	;3F01
	move.w	d3,d0	;3003
	bsr	adrCd0070C8	;61000032
	move.w	(sp)+,d0	;301F
	bsr	adrCd006EEC	;6100FE50
	move.b	d7,$000C(a6)	;1D47000C
	move.b	d3,$000D(a6)	;1D43000D
	lsr.w	#$03,d2	;E64A
	add.w	d2,d0	;D042
	move.w	d0,d1	;3200
	asl.w	#$02,d0	;E540
	add.w	d1,d0	;D041
	move.b	$000C(a6),d1	;122E000C
	add.w	d1,d0	;D041
	tst.w	adrW_0070C6.l	;4A79000070C6
	beq.s	adrCd0070C0	;6702
	add.w	d0,d0	;D040
adrCd0070C0:	move.w	d0,$0004(a6)	;3D400004
	rts	;4E75

adrW_0070C6:	dc.w	$0000	;0000

adrCd0070C8:	bsr	adrCd006EEC	;6100FE22
	move.b	d6,$000B(a6)	;1D46000B
	move.b	d5,$000A(a6)	;1D45000A
	move.b	d4,$0006(a6)	;1D440006
	clr.b	$0007(a6)	;422E0007
	move.b	d0,$0008(a6)	;1D400008
	move.b	d1,$0009(a6)	;1D410009
	add.w	d0,d0	;D040
	sub.w	#$0010,d1	;04410010
	bcc.s	adrCd0070EE	;6402
	moveq	#$00,d1	;7200
adrCd0070EE:	lsr.w	#$04,d1	;E849
	add.w	d1,d0	;D041
	sub.w	#$0014,d2	;04420014
	bcc.s	adrCd0070FA	;6402
	moveq	#$00,d2	;7400
adrCd0070FA:	lsr.w	#$04,d2	;E84A
	add.w	d2,d0	;D042
	move.w	d0,d1	;3200
	asl.w	#$02,d0	;E540
	add.w	d1,d0	;D041
	move.b	$000B(a6),d1	;122E000B
	add.w	d1,d0	;D041
	tst.w	adrW_006EEA.l	;4A7900006EEA
	bne.s	adrCd007114	;6602
	add.w	d0,d0	;D040
adrCd007114:	move.w	d0,$0002(a6)	;3D400002
	rts	;4E75

Click_MultiFunctionButton:
	bsr	adrCd0072D0	;610001B4
	tst.b	$0015(a4)	;4A2C0015
	beq.s	adrCd007132	;670E
	clr.b	$0015(a4)	;422C0015
	move.w	$0006(a5),d7	;3E2D0006
	bsr	adrCd00D66A	;6100653C
	bra.s	adrCd00713C	;600A

adrCd007132:	tst.b	$0017(a4)	;4A2C0017
	bmi.s	adrJC007140	;6B08
	bsr	adrCd00584C	;6100E712
adrCd00713C:	bra	adrCd008F3E	;60001E00

adrJC007140:	moveq	#$02,d3	;7602
	move.w	$0020(a5),d2	;342D0020
	add.w	d2,d2	;D442
	addq.w	#$01,d2	;5242
	bsr	adrCd009268	;6100211C
	move.b	$01(a6,d0.w),d1	;12360001
	and.w	#$0007,d1	;02410007
	cmp.b	#$02,d1	;0C010002
	bne.s	adrCd007162	;6606
	btst	d2,$00(a6,d0.w)	;05360000
	bne.s	adrCd0071C2	;6660
adrCd007162:	bsr	adrCd009250	;610020EC
	cmp.w	adrW_00F9CE.l,d7	;BE790000F9CE
	bcc.s	adrCd0071C0	;6452
	swap	d7	;4847
	cmp.w	adrW_00F9CC.l,d7	;BE790000F9CC
	bcc.s	adrCd0071C0	;6448
	eor.w	#$0004,d2	;0A420004
	move.b	$01(a6,d0.w),d1	;12360001
	and.w	#$0007,d1	;02410007
	cmp.b	#$02,d1	;0C010002
	beq.s	adrCd0071BA	;6730
	cmp.b	#$05,d1	;0C010005
	bne.s	adrCd0071C0	;6630
	tst.b	$01(a6,d0.w)	;4A360001
	bmi.s	adrCd0071C0	;6B2A
	btst	#$03,$00(a6,d0.w)	;083600030000
	bne.s	adrCd007204	;6666
	moveq	#$01,d2	;7401
	move.b	$00(a6,d0.w),d3	;16360000
	lsr.b	#$04,d3	;E80B
	beq.s	adrCd0071EC	;6744
	add.w	#$004F,d3	;0643004F
	cmp.w	$002E(a5),d3	;B66D002E
	bne.s	adrCd007204	;6652
	and.b	#$0F,$00(a6,d0.w)	;0236000F0000
	bra.s	adrCd0071C2	;6008

adrCd0071BA:	btst	d2,$00(a6,d0.w)	;05360000
	bne.s	adrCd0071C2	;6602
adrCd0071C0:	rts	;4E75

adrCd0071C2:	cmp.w	$002E(a5),d3	;B66D002E
	bne.s	adrCd0071EC	;6624
	subq.w	#$01,$002C(a5)	;536D002C
	bne.s	adrCd0071D2	;6604
	clr.w	$002E(a5)	;426D002E
adrCd0071D2:	bchg	#$04,$01(a6,d0.w)	;087600040001
	cmp.w	#$0003,$0014(a5)	;0C6D00030014
	bne.s	adrCd0071EC	;660C
	movem.l	d0/d2/a6,-(sp)	;48E7A002
	bsr	adrCd00790E	;61000728
	movem.l	(sp)+,d0/d2/a6	;4CDF4005
adrCd0071EC:	subq.w	#$01,d2	;5342
	btst	#$04,$01(a6,d0.w)	;083600040001
	bne.s	adrCd007204	;660E
	bchg	d2,$00(a6,d0.w)	;05760000
	moveq	#$01,d0	;7001
	bsr	PlaySound	;61002490
	bra	adrCd00D9B4	;600067B2

adrCd007204:	lea	adrEA00720E.l,a6	;4DF90000720E
	bra	adrCd00DA68	;6000685C

adrEA00720E:	dc.b	'THE DOOR IS LOCKED'	;54484520444F4F52204953204C4F434B4544
	dc.b	$FF	;FF
	dc.b	$00	;00

Click_PartyMember:
	lsr.w	#$02,d0	;E448
	sub.w	#$0006,d0	;04400006
	tst.w	$0016(a5)	;4A6D0016
	bpl.s	adrCd00723E	;6A10
	tst.b	$26(a5,d0.w)	;4A350026
	bpl.s	adrCd007236	;6A02
	rts	;4E75

adrCd007236:	move.w	d0,$0016(a5)	;3B400016
	bra	adrCd009104	;60001EC8

adrCd00723E:	cmp.w	$0016(a5),d0	;B06D0016
	beq.s	adrCd00725A	;6716
	move.b	$26(a5,d0.w),d1	;12350026
	move.w	$0016(a5),d2	;342D0016
	move.b	$26(a5,d2.w),$26(a5,d0.w)	;1BB520260026
	move.b	d1,$26(a5,d2.w)	;1B812026
	moveq	#-$01,d0	;70FF
	bra.s	adrCd007236	;60DC

adrCd00725A:	move.b	$26(a5,d0.w),d0	;10350026
	bmi.s	adrCd00727A	;6B1A
	move.w	$0006(a5),d2	;342D0006
	move.w	d0,$0006(a5)	;3B400006
	bsr	adrCd00480C	;6100D5A2
	move.b	d2,$18(a5,d1.w)	;1B821018
	move.b	d0,$0018(a5)	;1B400018
	bset	#$04,$0018(a5)	;08ED00040018
adrCd00727A:	move.w	#$FFFF,$0016(a5)	;3B7CFFFF0016
	bsr	adrCd008FFC	;61001D7A
	bra	adrCd008894	;6000160E

Click_ShowStats:
	move.w	#$0001,$0014(a5)	;3B7C00010014
	bsr	adrCd00D41C	;6100618C
	lea	adrEA00F444.l,a6	;4DF90000F444
	bsr	adrCd00DAA6	;6100680C
	move.w	$0006(a5),d7	;3E2D0006
	asl.w	#$06,d7	;ED47
	lea	CharacterStats.l,a6	;4DF90000F586
	moveq	#$00,d0	;7000
	move.b	$14(a6,d7.w),d0	;10367014
	beq.s	adrCd0072E2	;6732
	move.w	#$00C7,d1	;323C00C7
	moveq	#$30,d2	;7430
	move.l	#$002F00F9,d4	;283C002F00F9
	bsr	adrCd008EAE	;61001BF0
	move.l	#$0004004A,d5	;2A3C0004004A	;Long Addr replaced with Symbol
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$09,d3	;7609
	bra	adrCd00E538	;6000726A

adrCd0072D0:	move.w	$0006(a5),d0	;302D0006
adrCd0072D4:	and.w	#$000F,d0	;0240000F
	asl.w	#$06,d0	;ED40
	lea	CharacterStats.l,a4	;49F90000F586
	add.w	d0,a4	;D8C0
adrCd0072E2:	rts	;4E75

adrCd0072E4:	clr.w	$002A(a5)	;426D002A
	move.b	$0017(a4),d0	;102C0017
	bmi.s	adrCd0072F6	;6B08
	lsr.b	#$03,d0	;E608
	add.b	d0,d0	;D000
	move.b	d0,$002B(a5)	;1B40002B
adrCd0072F6:	rts	;4E75

adrJC0072F8:	bsr	adrCd008FDC	;61001CE2
	bsr	adrCd00D0C0	;61005DC2
	bsr.s	adrCd0072E4	;61E2
	bsr	adrCd00D156	;61005E52
	move.w	#$0002,$0014(a5)	;3B7C00020014
adrCd00730C:	bsr	adrCd00D10A	;61005DFC
	sub.w	#$02DC,a0	;90FC02DC
	move.b	$0017(a4),d0	;102C0017
	bpl.s	adrCd007332	;6A18
	bsr.s	adrCd00732C	;6110
	moveq	#$68,d7	;7E68
adrCd00731E:	move.w	d7,d0	;3007
	bsr	adrCd00D3DE	;610060BC
	addq.w	#$01,d7	;5247
	cmp.w	#$006C,d7	;0C47006C
	bcs.s	adrCd00731E	;65F2
adrCd00732C:	moveq	#$4F,d0	;704F
	bra	adrCd00D3DE	;600060AE

adrCd007332:	bsr	adrCd0075DC	;610002A8
	move.w	d0,d7	;3E00
	sub.b	$000F(a4),d7	;9E2C000F
	bne.s	adrCd007340	;6602
	moveq	#$04,d0	;7004
adrCd007340:	add.w	#$0050,d0	;06400050
	bsr	adrCd00D3DE	;61006098
	swap	d7	;4847
	move.w	#$0003,d7	;3E3C0003
adrLp00734E:	move.w	#$003B,d0	;303C003B
	bsr	adrCd00D3DE	;6100608A
	dbra	d7,adrLp00734E	;51CFFFF6
	swap	d7	;4847
	add.b	$000F(a4),d7	;DE2C000F
	cmp.b	$000F(a4),d7	;BE2C000F
	bne.s	adrCd007368	;6602
	moveq	#$04,d7	;7E04
adrCd007368:	move.w	d7,d0	;3007
	add.w	#$0050,d0	;06400050
	bsr	adrCd00D3DE	;6100606E
	moveq	#$00,d0	;7000
	move.b	$0017(a4),d0	;102C0017
	subq.w	#$04,d7	;5947
	bne.s	adrCd00738A	;660E
	lea	adrEA004E0E.l,a6	;4DF900004E0E
	move.b	$00(a6,d0.w),d0	;10360000
	add.w	#$0020,d0	;06400020
adrCd00738A:	bsr	adrCd006246	;6100EEBA
	bsr	adrCd00D9DA	;6100664A
adrCd007392:	or.b	#$04,$0054(a5)	;002D00040054
	bsr	adrCd00755A	;610001C0
	lea	adrEA00F492.l,a6	;4DF90000F492
	bsr	adrCd00D8DA	;61006536
	move.w	d1,$0010(a6)	;3D410010
	bsr	adrCd00DAA6	;610066FA
adrCd0073AE:	lea	adrEA00F4A8.l,a6	;4DF90000F4A8
	bsr	adrCd00D9D6	;61006620
	clr.b	$0057(a5)	;422D0057
adrCd0073BC:	tst.b	$0057(a5)	;4A2D0057
	bmi.s	adrCd0073FC	;6B3A
	or.b	#$10,$0054(a5)	;002D00100054
	bsr	adrCd007416	;6100004C
	neg.b	d7	;4407
	bpl.s	adrCd0073D2	;6A02
	moveq	#$00,d7	;7E00
adrCd0073D2:	cmp.b	#$13,d7	;0C070013
	bcc.s	adrCd0073FC	;6424
	clr.w	d0	;4240
	move.b	adrB_0073FE(pc,d7.w),d0	;103B7022
	moveq	#$64,d1	;7264
	moveq	#$34,d2	;7434
	move.l	#$0004005A,d5	;2A3C0004005A	;Long Addr replaced with Symbol
	add.w	$0008(a5),d5	;DA6D0008
	move.l	#$0033009F,d4	;283C0033009F
	bsr	adrCd008EAE	;61001ABA
	moveq	#$0C,d3	;760C
	bra	adrCd00E538	;6000713E

adrCd0073FC:	rts	;4E75

adrB_0073FE:	dc.b	$64	;64
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

	bsr	adrCd0072D4	;6100FEC0
adrCd007416:	move.b	$0017(a4),d0	;102C0017
	bsr	adrCd0075DC	;610001C0
	move.w	d0,-(sp)	;3F00
	move.l	a4,d0	;200C
	sub.l	#CharacterStats,d0	;04800000F586
	lsr.w	#$01,d0	;E248
	lea	adrEA014CA4.l,a1	;43F900014CA4
	add.w	d0,a1	;D2C0
	moveq	#$00,d0	;7000
	move.b	$0001(a4),d0	;102C0001
	move.w	d0,d1	;3200
	bsr	adrCd0075DC	;610001A0
	moveq	#$00,d7	;7E00
	cmp.w	(sp),d0	;B057
	bne.s	adrCd00744C	;6608
	bsr	adrCd0009E0	;6100959A
	move.b	adrB_007486(pc,d1.w),d7	;1E3B103C
adrCd00744C:	moveq	#$00,d6	;7C00
	move.b	$0017(a4),d6	;1C2C0017
	move.b	$00(a1,d6.w),d0	;10316000
	moveq	#$05,d2	;7405
	moveq	#$00,d3	;7600
	tst.w	d7	;4A47
	bne.s	adrCd007478	;661A
	move.w	(sp),d4	;3817
	cmp.b	$000F(a4),d4	;B82C000F
	beq.s	adrCd007480	;671A
	add.w	#$0057,d4	;06440057
	cmp.b	$0030(a4),d4	;B82C0030
	beq.s	adrCd007476	;6706
	cmp.b	$0031(a4),d4	;B82C0031
	bne.s	adrCd007480	;660A
adrCd007476:	addq.b	#$03,d7	;5607
adrCd007478:	cmp.w	d2,d0	;B042
	bcs.s	adrCd00748A	;650E
	addq.w	#$05,d7	;5A47
	sub.w	d2,d0	;9042
adrCd007480:	add.w	d2,d2	;D442
	addq.w	#$01,d3	;5243
	bra.s	adrCd007478	;60F2

adrB_007486:	dc.b	$03	;03
	dc.b	$05	;05
	dc.b	$04	;04
	dc.b	$04	;04

adrCd00748A:	lsr.w	d3,d0	;E668
	add.w	d0,d7	;DE40
	move.w	d1,d4	;3801
	bsr	adrCd0009BC	;6100952A
	add.b	d0,d7	;DE00
	add.b	d0,d7	;DE00
	add.b	$0018(a4),d7	;DE2C0018
	move.b	$0001(a4),d0	;102C0001
	move.w	d6,d4	;3806
	bsr	adrCd0075DC	;61000138
	move.w	d4,d6	;3C04
	move.w	(sp)+,d4	;381F
	cmp.b	$000F(a4),d4	;B82C000F
	bne.s	adrCd0074C0	;6610
	lea	adrEA004E0E.l,a0	;41F900004E0E
	move.b	$00(a0,d6.w),d6	;1C306000
	add.w	#$0020,d6	;06460020
	bra.s	adrCd0074D6	;6016

adrCd0074C0:	cmp.b	d0,d4	;B800
	bne.s	adrCd0074D6	;6612
	add.w	#$0057,d0	;06400057
	moveq	#$01,d1	;7201
	cmp.b	$0030(a4),d0	;B02C0030
	beq.s	adrCd0074D8	;6708
	cmp.b	$0031(a4),d0	;B02C0031
	beq.s	adrCd0074D8	;6702
adrCd0074D6:	moveq	#$00,d1	;7200
adrCd0074D8:	move.b	$0019(a4),d0	;102C0019
	lsr.b	d1,d0	;E228
	sub.b	d0,d7	;9E00
	moveq	#$05,d0	;7005
	cmp.b	#$3F,$0030(a4)	;0C2C003F0030
	beq.s	adrCd0074F4	;670A
	cmp.b	#$3F,$0031(a4)	;0C2C003F0031
	beq.s	adrCd0074F4	;6702
	moveq	#$00,d0	;7000
adrCd0074F4:	add.b	d0,d7	;DE00
	sub.b	adrB_0074FC(pc,d6.w),d7	;9E3B6004
	rts	;4E75

adrB_0074FC:	dc.b	$0E	;0E
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
	dc.b	$14	;14
	dc.b	$15	;15
	dc.b	$16	;16
	dc.b	$19	;19
	dc.b	$17	;17
	dc.b	$23	;23
	dc.b	$1A	;1A
	dc.b	$1B	;1B
adrEA007524:	dc.b	$01	;01
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
	dc.b	$06	;06
	dc.b	$07	;07
	dc.b	$07	;07
	dc.b	$08	;08
	dc.b	$08	;08
	dc.b	$12	;12
	dc.b	$0A	;0A
	dc.b	$0C	;0C
adrB_00754C:	dc.b	$00	;00
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

adrCd00755A:	moveq	#$00,d0	;7000
	move.b	$0017(a4),d0	;102C0017
	bsr	adrCd0075DC	;6100007A
	move.w	d0,d2	;3400
	sub.b	$000F(a4),d2	;942C000F
	beq.s	adrCd007598	;672C
	add.w	#$0069,d0	;06400069
	cmp.b	$0030(a4),d0	;B02C0030
	beq.s	adrCd00757C	;6706
	cmp.b	$0031(a4),d0	;B02C0031
	bne.s	adrCd007598	;661C
adrCd00757C:	sub.w	#$0069,d0	;04400069
	lea	RingUses.l,a0	;41F90000F98E
	tst.b	$00(a0,d0.w)	;4A300000
	bmi.s	adrCd007598	;6B0C
	moveq	#$00,d0	;7000
	move.b	d0,$0018(a4)	;19400018
	rts	;4E75

adrCd007594:	subq.b	#$01,$0018(a4)	;532C0018
adrCd007598:	move.b	$0018(a4),d1	;122C0018
	ext.w	d1	;4881
	bmi.s	adrCd0075A4	;6B04
	move.b	adrB_00754C(pc,d1.w),d1	;123B10AA
adrCd0075A4:	moveq	#$00,d0	;7000
	move.b	$0017(a4),d0	;102C0017
	tst.b	d2	;4A02
	bne.s	adrCd0075BC	;660E
	lea	adrEA004E0E.l,a0	;41F900004E0E
	move.b	$00(a0,d0.w),d0	;10300000
	add.w	#$0020,d0	;06400020
adrCd0075BC:	lea	adrEA007524.l,a0	;41F900007524
	move.b	$00(a0,d0.w),d0	;10300000
	addq.w	#$01,d0	;5240
	add.w	d0,d0	;D040
	add.w	d1,d0	;D041
	bne.s	adrCd0075D4	;6606
	addq.b	#$01,$0018(a4)	;522C0018
	moveq	#$01,d0	;7001
adrCd0075D4:
	cmp.w	#$0064,d0	;0C400064
	bcc.s	adrCd007594	;64BA
	rts	;4E75

adrCd0075DC:	move.w	d0,d6	;3C00
	cmp.b	#$10,d0	;0C000010
	bcs.s	adrCd0075E6	;6502
	not.w	d0	;4640
adrCd0075E6:	lsr.w	#$02,d0	;E448
	add.w	d6,d0	;D046
	and.w	#$0003,d0	;02400003
adrCd0075EE:	rts	;4E75

Click_Item_17_to_1A_Potions:
	move.w	$002E(a5),d0	;302D002E
	beq.s	adrCd0075EE	;67F8
	cmp.w	#$001B,d0	;0C40001B
	bcc.s	adrCd0075EE	;64F2
	cmp.w	#$0017,d0	;0C400017
	bcs.s	adrCd007674	;6572
	sub.w	#$0017,d0	;04400017
	move.w	d0,d1	;3200
	clr.l	$002C(a5)	;42AD002C
	move.b	$000F(a5),d0	;102D000F
	move.b	$18(a5,d0.w),d0	;10350018
	bsr	adrCd0072D4	;6100FCBE
	lea	Potion_1_SerpentSlime.l,a0	;41F900007636
	add.w	d1,d1	;D241
	add.w	Potion_LookupTable(pc,d1.w),a0	;D0FB100C
	jsr	(a0)	;4E90
	bsr	adrCd008D52	;6100172A
	bra	adrCd007900	;600002D4

Potion_LookupTable:
	dc.w	Potion_1_SerpentSlime-Potion_1_SerpentSlime	;0000
	dc.w	Potion_2_BrimstoneBroth-Potion_1_SerpentSlime	;001C
	dc.w	Potion_3_DragonAle-Potion_1_SerpentSlime	;0008
	dc.w	Potion_4_MoonElixir-Potion_1_SerpentSlime	;0010

Potion_1_SerpentSlime:	move.w	$0008(a4),$0006(a4)	;396C00080006
	rts	;4E75

Potion_3_DragonAle:	move.b	$000B(a4),$000A(a4)	;196C000B000A
	rts	;4E75

Potion_4_MoonElixir:	move.b	$000D(a4),$000C(a4)	;196C000D000C
	clr.b	$0019(a4)	;422C0019
	rts	;4E75

Potion_2_BrimstoneBroth:	clr.b	$0019(a4)	;422C0019
	bsr.s	Potion_1_SerpentSlime	;61DE
	moveq	#$0A,d4	;780A
	bsr.s	adrCd00765E	;6102
	moveq	#$0C,d4	;780C
adrCd00765E:	move.b	$01(a4,d4.w),d0	;10344001
	sub.b	$00(a4,d4.w),d0	;90344000
	addq.b	#$01,d0	;5200
	lsr.b	#$01,d0	;E208
	add.b	$00(a4,d4.w),d0	;D0344000
	move.b	d0,$00(a4,d4.w)	;19804000
	rts	;4E75

adrCd007674:	cmp.w	#$0005,d0	;0C400005
	bcs	adrCd0076F0	;65000076
	cmp.w	#$0014,d0	;0C400014
	bcs.s	adrCd007694	;6512
	moveq	#$00,d1	;7200
	sub.w	#$0014,d0	;04400014
adrLp007688:	add.w	#$0042,d1	;06410042
	dbra	d0,adrLp007688	;51C8FFFA
	moveq	#$00,d0	;7000
	bra.s	adrCd0076AE	;601A

adrCd007694:	moveq	#$14,d1	;7214
	cmp.w	#$000E,d0	;0C40000E
	bcc.s	adrCd00769E	;6402
	moveq	#$20,d1	;7220
adrCd00769E:	move.w	d0,d2	;3400
	subq.w	#$05,d0	;5B40
	beq.s	adrCd0076AE	;670A
adrCd0076A4:	subq.w	#$03,d0	;5740
	beq.s	adrCd0076AE	;6706
	bcc.s	adrCd0076A4	;64FA
	move.w	d2,d0	;3002
	subq.w	#$01,d0	;5340
adrCd0076AE:	move.w	d0,$002E(a5)	;3B40002E
	move.b	$000F(a5),d0	;102D000F
	move.b	$18(a5,d0.w),d0	;10350018
	bsr	adrCd0072D4	;6100FC18
	add.b	$0014(a4),d1	;D22C0014
	bcs.s	adrCd0076CA	;6506
	cmp.w	#$00C8,d1	;0C4100C8
	bcs.s	adrCd0076CE	;6504
adrCd0076CA:	move.b	#$C7,d1	;123C00C7
adrCd0076CE:	move.b	d1,$0014(a4)	;19410014
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	#$0B64,a0	;D0FC0B64
	add.w	$000A(a5),a0	;D0ED000A
	move.w	$002E(a5),d0	;302D002E
	bsr	adrCd00D35A	;61005C74
	bsr	adrCd0079EC	;61000302
	bra	adrCd007968	;6000027A

adrCd0076F0:	moveq	#$00,d7	;7E00
	move.b	$000F(a5),d7	;1E2D000F
	move.b	$18(a5,d7.w),d7	;1E357018
	and.w	#$000F,d7	;0247000F
	asl.w	#$06,d7	;ED47
	lea	CharacterStats.l,a6	;4DF90000F586
	add.w	d7,a6	;DCC7
	subq.b	#$01,$3B(a6,d0.w)	;5336003B
	bcc.s	adrCd007714	;6406
adrCd00770E:	addq.b	#$01,$3B(a6,d0.w)	;5236003B
	rts	;4E75

adrCd007714:	cmp.w	#$0063,$002C(a5)	;0C6D0063002C
	bcc.s	adrCd00770E	;64F2
	addq.w	#$01,$002C(a5)	;526D002C
	bra	adrJC0078D6	;600001B4

adrJC007724:	moveq	#$00,d7	;7E00
	move.b	$000E(a5),d7	;1E2D000E
	moveq	#$00,d0	;7000
	move.b	$18(a5,d7.w),d0	;10357018
	bsr	adrCd0072D4	;6100FBA2
	moveq	#$00,d0	;7000
	move.b	$000F(a5),d0	;102D000F
	move.w	$002E(a5),d1	;322D002E
	beq.s	adrCd007766	;6726
	cmp.b	#$03,d0	;0C000003
	bne.s	adrCd007766	;6620
	cmp.w	#$0024,d1	;0C410024
	bcs.s	adrCd00777C	;6530
	cmp.w	#$002B,d1	;0C41002B
	bcc.s	adrCd00777C	;642A
	move.w	d1,d2	;3401
	bsr	adrCd0009DA	;61009284
	btst	#$00,d1	;08010000
	beq.s	adrCd0077C0	;6762
	cmp.w	#$0027,d2	;0C420027
	bcs.s	adrCd0077C0	;655C
	bra.s	adrCd00777C	;6016

adrCd007766:	cmp.b	#$02,d0	;0C000002
	bne.s	adrCd007782	;6616
	tst.w	d1	;4A41
	beq.s	adrCd0077C0	;6750
	cmp.w	#$001B,d1	;0C41001B
	bcs.s	adrCd00777C	;6506
	cmp.w	#$0024,d1	;0C410024
	bcs.s	adrCd0077C0	;6544
adrCd00777C:	move.w	d7,$000E(a5)	;3B47000E
	rts	;4E75

adrCd007782:	bcc.s	adrCd0077C0	;643C
	cmp.w	#$002B,$002E(a5)	;0C6D002B002E
	bcs.s	adrCd0077AA	;651E
	cmp.w	#$0030,$002E(a5)	;0C6D0030002E
	bcc.s	adrCd0077AA	;6416
	move.b	$0016(a4),d1	;122C0016
	move.b	$002F(a5),$0016(a4)	;196D002F0016
	move.b	d1,$002F(a5)	;1B41002F
	bne.s	adrCd0077C0	;661C
	clr.w	$002C(a5)	;426D002C
	bra.s	adrCd0077C0	;6016

adrCd0077AA:	tst.b	$30(a4,d0.w)	;4A340030
	bne.s	adrCd0077C0	;6610
	tst.w	$002E(a5)	;4A6D002E
	bne.s	adrCd0077C0	;660A
	move.b	$0016(a4),$30(a4,d0.w)	;19AC00160030
	clr.b	$0016(a4)	;422C0016
adrCd0077C0:	moveq	#$00,d1	;7200
	move.b	$30(a4,d0.w),d1	;12340030
	beq	adrCd007850	;67000088
	cmp.w	#$0005,d1	;0C410005
	bcc	adrCd007850	;64000080
	move.w	$002E(a5),d3	;362D002E
	bne.s	adrCd0077EA	;6612
	move.w	d1,$002E(a5)	;3B41002E
	move.w	#$0001,$002C(a5)	;3B7C0001002C
	subq.b	#$01,$3B(a4,d1.w)	;5334103B
	bra	adrCd007886	;6000009E

adrCd0077EA:	cmp.w	#$0005,d3	;0C430005
	bcs.s	adrCd0077FE	;650E
	move.b	$3B(a4,d1.w),$002D(a5)	;1B74103B002D
	clr.b	$3B(a4,d1.w)	;4234103B
	bra	adrCd00787E	;60000082

adrCd0077FE:	cmp.w	d1,d3	;B641
	bne.s	adrCd007822	;6620
	move.b	$3B(a4,d1.w),d2	;1434103B
	add.b	$002D(a5),d2	;D42D002D
	move.b	d2,$3B(a4,d1.w)	;1982103B
	cmp.b	#$64,d2	;0C020064
	bcc.s	adrCd00781A	;6406
	clr.l	$002C(a5)	;42AD002C
	bra.s	adrCd007886	;606C

adrCd00781A:	move.b	#$63,$3B(a4,d1.w)	;19BC0063103B
	bra.s	adrCd007846	;6024

adrCd007822:	move.b	$3B(a4,d3.w),d2	;1434303B
	add.b	$002D(a5),d2	;D42D002D
	cmp.b	#$64,d2	;0C020064
	bcc.s	adrCd007840	;6410
	move.b	d2,$3B(a4,d3.w)	;1982303B
	move.b	$3B(a4,d1.w),$002D(a5)	;1B74103B002D
	clr.b	$3B(a4,d1.w)	;4234103B
	bra.s	adrCd00786E	;602E

adrCd007840:	move.b	#$63,$3B(a4,d3.w)	;19BC0063303B
adrCd007846:	sub.b	#$63,d2	;04020063
	move.b	d2,$002D(a5)	;1B42002D
	bra.s	adrCd007886	;6036

adrCd007850:	move.w	$002E(a5),d3	;362D002E
	beq.s	adrCd00787E	;6728
	cmp.w	#$0005,d3	;0C430005
	bcc.s	adrCd00787E	;6422
	move.b	$3B(a4,d3.w),d2	;1434303B
	add.b	$002D(a5),d2	;D42D002D
	move.b	d2,$3B(a4,d3.w)	;1982303B
	cmp.b	#$64,d2	;0C020064
	bcc.s	adrCd007840	;64D2
adrCd00786E:	moveq	#$0B,d2	;740B
adrLp007870:	cmp.b	$30(a4,d2.w),d3	;B6342030
	bne.s	adrCd00787A	;6604
	clr.b	$30(a4,d2.w)	;42342030
adrCd00787A:	dbra	d2,adrLp007870	;51CAFFF4
adrCd00787E:	move.b	d3,$30(a4,d0.w)	;19830030
	move.w	d1,$002E(a5)	;3B41002E
adrCd007886:	cmp.b	#$02,$000F(a5)	;0C2D0002000F
	bne.s	adrCd0078A4	;6616
	btst	d7,$003E(a5)	;0F2D003E
	beq.s	adrCd0078A4	;6710
	move.w	d7,-(sp)	;3F07
	bsr	adrCd008C4A	;610013B2
	tst.w	(sp)	;4A57
	beq.s	adrCd0078A2	;6704
	bsr	adrCd008C2C	;6100138C
adrCd0078A2:	move.w	(sp)+,d7	;3E1F
adrCd0078A4:	move.w	d7,$000E(a5)	;3B47000E
	move.w	$002E(a5),d0	;302D002E
	beq.s	adrCd0078B4	;6706
	cmp.w	#$0005,d0	;0C400005
	bcs.s	adrJC0078D6	;6522
adrCd0078B4:	move.w	#$0001,$002C(a5)	;3B7C0001002C
	bra.s	adrJC0078D6	;601A

Click_OpenInventory:
	clr.w	$000E(a5)	;426D000E
	move.l	#$005E00E1,d4	;283C005E00E1
	move.l	#$00070040,d5	;2A3C00070040
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$03,d3	;7603
	bsr	adrCd00E538	;61006C64
adrJC0078D6:
	move.w	$000E(a5),d7	;3E2D000E
	move.b	$18(a5,d7.w),d7	;1E357018
	and.w	#$000F,d7	;0247000F
	bsr	adrCd00D2BE	;610059DA
	move.l	#$000D0003,adrW_00E3FA.l	;23FC000D00030000E3FA
	bsr	adrCd00D286	;61005994
	move.w	d7,d0	;3007
	bsr	adrCd00D926	;6100602E
	move.w	#$0003,$0014(a5)	;3B7C00030014
adrCd007900:	bsr	adrCd0079A0	;6100009E
	cmp.b	#$03,$0015(a5)	;0C2D00030015
	bne	Trigger_00_t00_Null	;660003E4
adrCd00790E:	or.b	#$04,$0054(a5)	;002D00040054
	move.l	screen_ptr.l,a0	;207900009B06
	lea	$0B5C(a0),a0	;41E80B5C
	add.w	$000A(a5),a0	;D0ED000A
	moveq	#$00,d7	;7E00
adrCd007924:	bsr	adrCd009186	;61001860
	addq.w	#$01,d7	;5247
	cmp.w	#$0004,d7	;0C470004
	bcs.s	adrCd007924	;65F4
	move.w	$002E(a5),d0	;302D002E
	move.w	$002C(a5),d1	;322D002C
	bsr	adrCd00D35A	;61005A20
	move.w	$0012(a5),d3	;362D0012
	moveq	#$74,d0	;7074
	bsr	adrCd00D3DE	;61005A9A
	bsr	adrCd0079EC	;610000A4
	move.w	$002E(a5),d0	;302D002E
	beq.s	adrCd00795C	;670C
	cmp.w	#$0005,d0	;0C400005
	bcs.s	adrCd00795C	;6506
	cmp.w	#$0017,d0	;0C400017
	bcs.s	adrCd00795E	;6502
adrCd00795C:	rts	;4E75

adrCd00795E:
	lea	adrEA00F434.l,a6	;4DF90000F434
	bsr	adrCd00DAA6	;61006140
adrCd007968:
	or.b	#$14,$0054(a5)	;002D00140054
	move.w	$000E(a5),d0	;302D000E
	move.b	$18(a5,d0.w),d0	;10350018
	bsr	adrCd0072D4	;6100F95C
	clr.w	d0	;4240
	move.b	$0014(a4),d0	;102C0014
	move.w	#$00C7,d1	;323C00C7
	moveq	#$3A,d2	;743A
	move.l	#$0004005A,d5	;2A3C0004005A	;Long Addr replaced with Symbol
	add.w	$0008(a5),d5	;DA6D0008
	move.l	#$00390098,d4	;283C00390098
	bsr	adrCd008EAE	;61001516
	moveq	#$09,d3	;7609
	bra	adrCd00E538	;60006B9A

adrCd0079A0:	move.w	$002E(a5),d0	;302D002E
	bne.s	adrCd0079B0	;660A
	lea	adrEA00D3DD.l,a6	;4DF90000D3DD
	bra	adrCd00D9D6	;60006028

adrCd0079B0:	move.w	d0,d1	;3200
	sub.w	#$0040,d1	;04410040
	bcs.s	adrCd0079D6	;651E
	cmp.w	#$0010,d1	;0C410010
	bcc.s	adrCd0079D6	;6418
	move.w	d1,d0	;3001
	bsr	adrCd00480C	;6100CE4A
	move.w	$002E(a5),d0	;302D002E
	tst.w	d1	;4A41
	bmi.s	adrCd0079D6	;6B0A
	bclr	#$05,$18(a5,d1.w)	;08B500051018
	clr.l	$002C(a5)	;42AD002C
adrCd0079D6:	lea	ObjectDefinitionsTable+$2.l,a6	;4DF90000EF4C
	asl.w	#$02,d0	;E540
	add.w	d0,a6	;DCC0
	move.w	#$0006,adrW_00E3FA.l	;33FC00060000E3FA
	bra	adrCd00E2CC	;600068E2

adrCd0079EC:	moveq	#$0D,d3	;760D
	move.l	#$000E0049,d5	;2A3C000E0049
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$0F,d4	;780F
	swap	d4	;4844
	move.b	$000F(a5),d4	;182D000F
	asl.w	#$04,d4	;E944
	add.w	#$00E1,d4	;064400E1
	bra	adrCd00E5A4	;60006B9C

adrCd007A0A:	subq.b	#$01,$0055(a5)	;532D0055
	bpl.s	adrCd007A12	;6A02
adrCd007A10:	rts	;4E75

adrCd007A12:	tst.b	$0015(a5)	;4A2D0015
	bne.s	adrCd007A10	;66F8
	or.b	#$04,$0054(a5)	;002D00040054
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	$000A(a5),a0	;D0ED000A
	add.w	#$097C,a0	;D0FC097C
	lea	_GFX_Pockets+$6A60.l,a1	;43F90004FF12
	btst	#$00,(a5)	;08150000
	bne.s	adrCd007A3C	;6604
	lea	$0020(a1),a1	;43E90020
adrCd007A3C:	
	move.l	#$00020016,d5	;2A3C00020016	;Long Addr replaced with Symbol
	move.l	#$00000088,a3	;267C00000088
	bra	adrCd00D60C	;60005BC2

adrW_007A4C:	dc.w	$0050	;0050
	dc.w	$0268	;0268
	dc.w	$01D8	;01D8
	dc.w	$0180	;0180
	dc.w	$0000	;0000
	dc.w	$00E0	;00E0
adrW_007A58:	dc.w	$00A0	;00A0
	dc.w	$0284	;0284
	dc.w	$02D0	;02D0
	dc.w	$0280	;0280
	dc.w	$00A0	;00A0
	dc.w	$00A2	;00A2
adrB_007A64:	dc.b	$01	;01
adrB_007A65:	dc.b	$08	;08
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

adrCd007A70:	tst.b	$0015(a5)	;4A2D0015
	bne	adrCd0055FA	;6600DB84
	or.b	#$04,$0054(a5)	;002D00040054
	move.b	#$81,$0055(a5)	;1B7C00810055
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	$000A(a5),a0	;D0ED000A
	add.w	#$08DC,a0	;D0FC08DC
	add.w	d0,d0	;D040
	add.w	adrW_007A58(pc,d0.w),a0	;D0FB00C2
	lea	adrEA016D4C.l,a1	;43F900016D4C
	add.w	adrW_007A4C(pc,d0.w),a1	;D2FB00AC
	moveq	#$00,d5	;7A00
	moveq	#$00,d3	;7600
	move.b	adrB_007A64(pc,d0.w),d5	;1A3B00BC
	move.b	d5,d3	;1605
	swap	d5	;4845
	move.b	adrB_007A65(pc,d0.w),d5	;1A3B00B5
	addq.w	#$01,d3	;5243
	add.w	d3,d3	;D643
	swap	d3	;4843
	bra	adrCd00C460	;600049A6

Click_MoveForwards:	moveq	#$00,d0	;7000
	bra.s	MoveParty	;600A

Click_MoveBackwards:	moveq	#$02,d0	;7002
	bra.s	MoveParty	;6006

Click_MoveLeft:	moveq	#$03,d0	;7003
	bra.s	MoveParty	;6002

Click_MoveRight:	moveq	#$01,d0	;7001
MoveParty:	and.b	#$01,(a5)	;02150001
	move.w	d0,-(sp)	;3F00
	bsr.s	adrCd007A70	;619E
	move.w	(sp)+,d6	;3C1F
	move.l	$001C(a5),d7	;2E2D001C
	add.w	$0020(a5),d6	;DC6D0020
	and.w	#$0003,d6	;02460003
	bsr	adrCd0086F6	;61000C14
	bcc	adrCd007B0C	;64000026
	cmp.w	d0,d2	;B440
	bne.s	adrCd007B0A	;661E
	move.w	$00(a6,d0.w),d1	;32360000
	and.w	#$0007,d1	;02410007
	cmp.w	#$0004,d1	;0C410004
	bne.s	adrCd007B0A	;6610
	move.b	$00(a6,d0.w),d1	;12360000
	lsr.b	#$01,d1	;E209
	eor.b	#$02,d1	;0A010002
	cmp.b	d1,d6	;BC01
	beq	adrCd007BA0	;67000098
adrCd007B0A:	rts	;4E75

adrCd007B0C:	move.w	$00(a6,d0.w),d1	;32360000
	and.w	#$0007,d1	;02410007
	subq.w	#$06,d1	;5D41
	bcs.s	adrCd007B78	;6560
	beq.s	adrCd007B60	;6746
	move.b	$00(a6,d0.w),d1	;12360000
	move.w	d1,d2	;3401
	and.w	#$0003,d2	;02420003
	subq.w	#$01,d2	;5342
	bne.s	adrCd007B78	;6650
	move.l	d7,$001C(a5)	;2B47001C
	movem.w	d0/d1,-(sp)	;48A7C000
	moveq	#$05,d1	;7205
	bsr	adrCd006128	;6100E5F4
	movem.w	(sp)+,d0/d1	;4C9F0003
	tst.w	d3	;4A43
	bpl.s	adrCd007B0A	;6ACC
	lsr.b	#$02,d1	;E409
	move.w	d1,d7	;3E01
	move.w	d7,adrW_0025A8.l	;33C7000025A8
	movem.l	d0/a6,-(sp)	;48E78002
	bsr	adrCd0022B6	;6100A768
	movem.l	(sp)+,d0/a6	;4CDF4001
	move.l	a5,-(sp)	;2F0D
	move.l	a5,a1		;224D
	bsr	adrCd002984	;6100AE2A
	move.l	(sp)+,a5	;2A5F
	rts	;4E75

adrCd007B60:
	move.b	$00(a6,d0.w),d1	;12360000
	and.w	#$0003,d1	;02410003
	bne.s	adrCd007B70	;6606
	bsr	adrCd007C52	;610000E6
	bra.s	adrCd007B78	;6008

adrCd007B70:	subq.w	#$01,d1	;5341
	beq.s	adrCd007B78	;6704
	bsr	adrCd007C7C	;61000106
adrCd007B78:	movem.l	d0/d7/a6,-(sp)	;48E78102
	bsr	adrCd008F3E	;610013C0
	movem.l	(sp)+,d0/d7/a6	;4CDF4081
	move.w	$00(a6,d0.w),d1	;32360000
	and.w	#$0007,d1	;02410007
	cmp.w	#$0004,d1	;0C410004
	bne	adrCd007C0A	;66000078
	moveq	#$00,d6	;7C00
	move.b	$00(a6,d0.w),d6	;1C360000
	lsr.b	#$01,d6	;E20E
	eor.b	#$02,d6	;0A060002
adrCd007BA0:	bclr	#$07,$01(a6,d0.w)	;08B600070001
	move.w	$0058(a5),d2	;342D0058
	move.w	d2,d1	;3202
	addq.w	#$01,d1	;5241
	btst	#$00,$00(a6,d0.w)	;083600000000
	beq.s	adrCd007BB8	;6702
	subq.w	#$02,d1	;5541
adrCd007BB8:	bsr	adrCd00928A	;610016D0
	move.w	d1,d0	;3001
	bsr	adrCd0092AA	;610016EA
	lea	adrEA006434.l,a0	;41F900006434
	add.b	$08(a0,d6.w),d7	;DE306008
	add.b	$08(a0,d6.w),d7	;DE306008
	swap	d7	;4847
	add.b	$00(a0,d6.w),d7	;DE306000
	add.b	$00(a0,d6.w),d7	;DE306000
	swap	d7	;4847
	bsr	CoordToMap	;6100168E
	tst.b	$01(a6,d0.w)	;4A360001
	bpl.s	adrCd007BF6	;6A10
	bsr	adrCd0092A6	;610016BE
	bsr	adrCd009268	;6100167C
	bset	#$07,$01(a6,d0.w)	;08F600070001
	rts	;4E75

adrCd007BF6:	move.w	d1,$0058(a5)	;3B410058
	bset	#$07,$01(a6,d0.w)	;08F600070001
	move.b	$00(a6,d0.w),d0	;10360000
	lsr.b	#$01,d0	;E208
	move.b	d0,$0021(a5)	;1B400021
adrCd007C0A:	move.l	d7,$001C(a5)	;2B47001C
	tst.b	$003E(a5)	;4A2D003E
	beq.s	adrCd007C1C	;6708
	clr.b	$003E(a5)	;422D003E
	bsr	adrCd008894	;61000C7A
adrCd007C1C:	move.w	$0042(a5),d0	;302D0042
	bmi.s	adrCd007C2A	;6B08
	cmp.w	#$0008,d0	;0C400008
	bcc	adrJC0039F2	;6400BDCA
adrCd007C2A:	rts	;4E75

Click_RotateLeft:
	subq.w	#$01,$0020(a5)	;536D0020
	and.w	#$0003,$0020(a5)	;026D00030020
	moveq	#$04,d0	;7004
	bra.s	adrCd007C46	;600C

Click_RotateRight:
	addq.w	#$01,$0020(a5)	;526D0020
	and.w	#$0003,$0020(a5)	;026D00030020
	moveq	#$05,d0	;7005
adrCd007C46:	bsr	adrCd007A70	;6100FE28
	bsr	adrCd009268	;6100161C
	bra	adrCd007B78	;6000FF28

adrCd007C52:	movem.l	d0/d7/a6,-(sp)	;48E78102
	moveq	#$03,d7	;7E03
adrLp007C58:	move.b	$18(a5,d7.w),d1	;12357018
	move.w	d1,d0	;3001
	and.w	#$00E0,d1	;024100E0
	bne.s	adrCd007C6C	;6608
	bsr	adrCd0072D4	;6100F66E
	clr.b	$0015(a4)	;422C0015
adrCd007C6C:	dbra	d7,adrLp007C58	;51CFFFEA
	bsr	adrCd008894	;61000C22
	movem.l	(sp)+,d0/d7/a6	;4CDF4081
	rts	;4E75

adrW_007C7A:	dc.w	$FFFF	;FFFF

adrCd007C7C:
	move.w	#$FFFF,adrW_007C7A.l	;33FCFFFF00007C7A
	move.b	$00(a6,d0.w),d1	;12360000
	and.w	#$0003,d1	;02410003
	subq.w	#$02,d1	;5541
	bne.s	adrCd007C96	;6606
	clr.w	adrW_007C7A.l	;427900007C7A
adrCd007C96:	move.b	$00(a6,d0.w),d1	;12360000
	and.w	#$00F8,d1	;024100F8
	lsr.b	#$01,d1	;E209
	lea	serpex.triggers.l,a1	;43F900007D34
	move.w	CurrentTower.l,d2	;34390000F98A
	asl.w	#$07,d2	;EF42
	add.w	d2,a1	;D2C2
	moveq	#$00,d2	;7400
	move.b	$00(a1,d1.w),d2	;14311000
	cmp.b	#$08,d2	;0C020008
	beq.s	adrCd007CC8	;670C
	cmp.b	#$0A,d2	;0C02000A
	beq.s	adrCd007CC8	;6706
	cmp.b	#$2A,d2	;0C02002A
	bne.s	adrCd007CD0	;6608
adrCd007CC8:
	move.w	#$0005,adrW_007C7A.l	;33FC000500007C7A
adrCd007CD0:
	lea	Trigger_00_t00_Null.l,a0	;41F900007CF0
	add.w	Triggers_LookupTable(pc,d2.w),a0	;D0FB201A
	movem.l	d0/d7/a6,-(sp)	;48E78102
	jsr	(a0)	;4E90
	move.w	adrW_007C7A.l,d0	;303900007C7A
	bmi.s	adrCd007CEC	;6B04
	bsr	PlaySound	;610019A4
adrCd007CEC:	movem.l	(sp)+,d0/d7/a6	;4CDF4081
Trigger_00_t00_Null:	rts	;4E75

Triggers_LookupTable:
	dc.w	Trigger_00_t00_Null-Trigger_00_t00_Null	;0000
	dc.w	TriggerAction_02_Spinner-Trigger_00_t00_Null	;06AE
	dc.w	Trigger_02_t04_SpinnerRandom-Trigger_00_t00_Null	;06B6
	dc.w	Switch_03_s06_Trigger_03_t06_OpenLockedDoorXY-Trigger_00_t00_Null	;06E4
	dc.w	Trigger_04_t08-Trigger_00_t00_Null	;07AE
	dc.w	Trigger_05_t0A-Trigger_00_t00_Null	;089E
	dc.w	Trigger_06_t0C_WoodTrap1-Trigger_00_t00_Null	;066E
	dc.w	Trigger_07_t0E_WoodTrap2-Trigger_00_t00_Null	;0686
	dc.w	Trigger_08_t10-Trigger_00_t00_Null	;069E
	dc.w	Trigger_09_t12-Trigger_00_t00_Null	;03D0
	dc.w	Trigger_10_t14-Trigger_00_t00_Null	;034E
	dc.w	Switch_01_s02_Trigger_11_t16_RemoveXY-Trigger_00_t00_Null	;EC44
	dc.w	Trigger_12_t18-Trigger_00_t00_Null	;06D0
	dc.w	Switch05_s0A_Trigger_13_t1A_TogglePillarXY-Trigger_00_t00_Null	;070C
	dc.w	Trigger_14_t1C-Trigger_00_t00_Null	;071E
	dc.w	Switch_00_s00_Trigger_15_t1E_ToggleWallXY-Trigger_00_t00_Null	;EC2A
	dc.w	Trigger_16_t20-Trigger_00_t00_Null	;0742
	dc.w	Trigger_17_t22-Trigger_00_t00_Null	;0784
	dc.w	Switch06_s0C_Trigger_18_t24_CreatePillarXY-Trigger_00_t00_Null	;0708
	dc.w	adrJC00803C-Trigger_00_t00_Null	;034C
	dc.w	adrJC00803C-Trigger_00_t00_Null	;034C
	dc.w	Trigger_21_t2A-Trigger_00_t00_Null	;0622
	dc.w	Switch_04_s08_Trigger_22_t2C_RotateWallXY-Trigger_00_t00_Null	;0650
	dc.w	Switch_02_s04_Trigger_23_t2E-Trigger_00_t00_Null	;EC2E
	dc.w	adrJC0083B4-Trigger_00_t00_Null	;06C4
	dc.w	Trigger_24_t30_Spinner3-Trigger_00_t00_Null	;05D8
	dc.w	Trigger_25_t32-Trigger_00_t00_Null	;0736
	dc.w	Switch_07_s0E_Trigger_26_t34_RotateWoodXY-Trigger_00_t00_Null	;06F8
	dc.w	Trigger_27_t36-Trigger_00_t00_Null	;05CC
	dc.w	Trigger_28_t38_GameCompletion-Trigger_00_t00_Null	;04B2
	dc.w	adrJC00818A-Trigger_00_t00_Null	;049A
	dc.w	adrJC007F34-Trigger_00_t00_Null	;0244
	dc.w	adrJC008002-Trigger_00_t00_Null	;0312
serpex.triggers:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0400	;0400
	dc.w	$0000	;0000
	dc.w	$0200	;0200
	dc.w	$0000	;0000
	dc.w	$1000	;1000
	dc.w	$0000	;0000
	dc.w	$0800	;0800
	dc.w	$0000	;0000
	dc.w	$0A00	;0A00
	dc.w	$0000	;0000
	dc.w	$1600	;1600
	dc.w	$000F	;000F
	dc.w	$1600	;1600
	dc.w	$160F	;160F
	dc.w	$1800	;1800
	dc.w	$1404	;1404
	dc.w	$2A04	;2A04
	dc.w	$0406	;0406
	dc.w	$2A05	;2A05
	dc.w	$0007	;0007
	dc.w	$1600	;1600
	dc.w	$0C08	;0C08
	dc.w	$2A05	;2A05
	dc.w	$0107	;0107
	dc.w	$3600	;3600
	dc.w	$0807	;0807
	dc.w	$3600	;3600
	dc.w	$0805	;0805
	dc.w	$3600	;3600
	dc.w	$0803	;0803
	dc.w	$2400	;2400
	dc.w	$0C05	;0C05
	dc.w	$2A06	;2A06
	dc.w	$000A	;000A
	dc.w	$2A04	;2A04
	dc.w	$0B11	;0B11
	dc.w	$1600	;1600
	dc.w	$0C09	;0C09
	dc.w	$1600	;1600
	dc.w	$0409	;0409
	dc.w	$1600	;1600
	dc.w	$0406	;0406
	dc.w	$2400	;2400
	dc.w	$0C08	;0C08
	dc.w	$1201	;1201
	dc.w	$0901	;0901
	dc.w	$1401	;1401
	dc.w	$0000	;0000
	dc.w	$1201	;1201
	dc.w	$0701	;0701
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
chaosex.triggers:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0200	;0200
	dc.w	$0000	;0000
	dc.w	$0400	;0400
	dc.w	$0000	;0000
	dc.w	$1800	;1800
	dc.w	$1202	;1202
	dc.w	$1600	;1600
	dc.w	$0805	;0805
	dc.w	$1600	;1600
	dc.w	$1005	;1005
	dc.w	$1000	;1000
	dc.w	$0000	;0000
	dc.w	$3E00	;3E00
	dc.w	$0000	;0000
	dc.w	$2A03	;2A03
	dc.w	$0200	;0200
	dc.w	$3600	;3600
	dc.w	$130D	;130D
	dc.w	$0600	;0600
	dc.w	$0C10	;0C10
	dc.w	$3600	;3600
	dc.w	$0913	;0913
	dc.w	$4000	;4000
	dc.w	$0000	;0000
	dc.w	$0600	;0600
	dc.w	$0310	;0310
	dc.w	$2A02	;2A02
	dc.w	$0308	;0308
	dc.w	$2C00	;2C00
	dc.w	$0305	;0305
	dc.w	$2400	;2400
	dc.w	$060E	;060E
	dc.w	$1600	;1600
	dc.w	$010F	;010F
	dc.w	$2C00	;2C00
	dc.w	$0413	;0413
	dc.w	$2A03	;2A03
	dc.w	$1314	;1314
	dc.w	$2A03	;2A03
	dc.w	$0F0F	;0F0F
	dc.w	$0600	;0600
	dc.w	$0D0E	;0D0E
	dc.w	$3600	;3600
	dc.w	$0D0B	;0D0B
	dc.w	$2A04	;2A04
	dc.w	$0708	;0708
	dc.w	$0600	;0600
	dc.w	$0009	;0009
	dc.w	$0600	;0600
	dc.w	$0E07	;0E07
	dc.w	$1201	;1201
	dc.w	$0801	;0801
	dc.w	$1401	;1401
	dc.w	$0000	;0000
	dc.w	$1201	;1201
	dc.w	$0601	;0601
	dc.w	$1200	;1200
	dc.w	$0B13	;0B13
	dc.w	$1400	;1400
	dc.w	$0000	;0000
	dc.w	$1200	;1200
	dc.w	$0D13	;0D13
moonex.triggers:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0200	;0200
	dc.w	$0000	;0000
	dc.w	$0400	;0400
	dc.w	$0000	;0000
	dc.w	$3600	;3600
	dc.w	$0605	;0605
	dc.w	$2A01	;2A01
	dc.w	$0408	;0408
	dc.w	$2A02	;2A02
	dc.w	$0806	;0806
	dc.w	$2A01	;2A01
	dc.w	$0D0E	;0D0E
	dc.w	$3E00	;3E00
	dc.w	$0000	;0000
	dc.w	$2A07	;2A07
	dc.w	$0602	;0602
	dc.w	$2A07	;2A07
	dc.w	$0904	;0904
	dc.w	$2A07	;2A07
	dc.w	$0C02	;0C02
	dc.w	$1600	;1600
	dc.w	$0608	;0608
	dc.w	$4000	;4000
	dc.w	$0000	;0000
	dc.w	$2A07	;2A07
	dc.w	$0304	;0304
	dc.w	$1600	;1600
	dc.w	$0B09	;0B09
	dc.w	$0600	;0600
	dc.w	$0E07	;0E07
	dc.w	$1600	;1600
	dc.w	$0B01	;0B01
	dc.w	$0600	;0600
	dc.w	$0E03	;0E03
	dc.w	$0600	;0600
	dc.w	$080A	;080A
	dc.w	$1600	;1600
	dc.w	$0902	;0902
	dc.w	$1C00	;1C00
	dc.w	$0403	;0403
	dc.w	$1201	;1201
	dc.w	$0201	;0201
	dc.w	$1401	;1401
	dc.w	$0000	;0000
	dc.w	$1201	;1201
	dc.w	$0001	;0001
	dc.w	$1200	;1200
	dc.w	$0207	;0207
	dc.w	$1400	;1400
	dc.w	$0000	;0000
	dc.w	$1200	;1200
	dc.w	$0007	;0007
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
dragex.triggers:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$2A03	;2A03
	dc.w	$0707	;0707
	dc.w	$0400	;0400
	dc.w	$0000	;0000
	dc.w	$1000	;1000
	dc.w	$0000	;0000
	dc.w	$1600	;1600
	dc.w	$020F	;020F
	dc.w	$1600	;1600
	dc.w	$120F	;120F
	dc.w	$2A00	;2A00
	dc.w	$0A0F	;0A0F
	dc.w	$3E00	;3E00
	dc.w	$0000	;0000
	dc.w	$1800	;1800
	dc.w	$0A08	;0A08
	dc.w	$1600	;1600
	dc.w	$0A0C	;0A0C
	dc.w	$2A04	;2A04
	dc.w	$0502	;0502
	dc.w	$2A05	;2A05
	dc.w	$0A02	;0A02
	dc.w	$2A06	;2A06
	dc.w	$0502	;0502
	dc.w	$2A07	;2A07
	dc.w	$0506	;0506
	dc.w	$2A03	;2A03
	dc.w	$0C01	;0C01
	dc.w	$0600	;0600
	dc.w	$0E0C	;0E0C
	dc.w	$0600	;0600
	dc.w	$0006	;0006
	dc.w	$1600	;1600
	dc.w	$0103	;0103
	dc.w	$1600	;1600
	dc.w	$0302	;0302
	dc.w	$3204	;3204
	dc.w	$0901	;0901
	dc.w	$2A02	;2A02
	dc.w	$0503	;0503
	dc.w	$1600	;1600
	dc.w	$0505	;0505
	dc.w	$1800	;1800
	dc.w	$0507	;0507
	dc.w	$2A02	;2A02
	dc.w	$0903	;0903
	dc.w	$2200	;2200
	dc.w	$0000	;0000
	dc.w	$2A07	;2A07
	dc.w	$0804	;0804
	dc.w	$3A00	;3A00
	dc.w	$0000	;0000
	dc.w	$1200	;1200
	dc.w	$0B13	;0B13
	dc.w	$1400	;1400
	dc.w	$0000	;0000
	dc.w	$1200	;1200
	dc.w	$0913	;0913
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000

adrJC007F34:	bsr	adrCd0092CC	;61001396
	move.l	d2,d7	;2E02
	moveq	#$03,d6	;7C03
adrLp007F3C:	movem.l	d1/d6/d7,-(sp)	;48E74300
	bsr.s	adrCd007F4C	;610A
	movem.l	(sp)+,d1/d6/d7	;4CDF00C2
	dbra	d6,adrLp007F3C	;51CEFFF4
adrCd007F4A:	rts	;4E75

adrCd007F4C:	lea	adrEA006434.l,a0	;41F900006434
	add.b	$08(a0,d6.w),d7	;DE306008
	swap	d7	;4847
	add.b	$00(a0,d6.w),d7	;DE306000
	cmp.w	adrW_00F9CC.l,d7	;BE790000F9CC
	bcc.s	adrCd007F4A	;64E6
	swap	d7	;4847
	cmp.w	adrW_00F9CE.l,d7	;BE790000F9CE
	bcc.s	adrCd007F4A	;64DC
	bsr	CoordToMap	;610012FC
	move.b	$01(a6,d0.w),d2	;14360001
	bmi.s	adrCd007F4A	;6BD2
	and.w	#$0007,d2	;02420007
	beq.s	adrCd007F82	;6704
	subq.w	#$06,d2	;5D42
	bne.s	adrCd007F4A	;66C8
adrCd007F82:	bset	#$07,$01(a6,d0.w)	;08F600070001
	lea	UnpackedMonsters.l,a4	;49F900014EE6
	addq.w	#$01,-$0002(a4)	;526CFFFE
	move.w	-$0002(a4),d2	;342CFFFE
	cmp.w	#$007D,d2	;0C42007D
	bcs.s	adrCd007FA6	;650A
	subq.w	#$01,-$0002(a4)	;536CFFFE
	bsr	adrCd002C84	;6100ACE2
	bra.s	adrCd007F82	;60DC

adrCd007FA6:	asl.w	#$04,d2	;E942
	add.w	d2,a4	;D8C2
	move.b	d7,$0001(a4)	;19470001
	swap	d7	;4847
	move.b	d7,$0000(a4)	;19470000
	move.b	#$FF,$000C(a4)	;197C00FF000C
	move.b	#$09,d2	;143C0009
	add.b	d6,d2	;D406
	move.b	d2,$0006(a4)	;19420006
	lsr.b	#$01,d2	;E20A
	move.b	d2,$0007(a4)	;19420007
	move.w	#$0190,$0008(a4)	;397C01900008
	move.b	#$64,$000B(a4)	;197C0064000B
	move.b	#$81,$0003(a4)	;197C00810003
	clr.b	$0005(a4)	;422C0005
	move.b	#$01,$000A(a4)	;197C0001000A
	move.b	d1,$0004(a4)	;19410004
	move.b	d6,d2	;1406
	asl.b	#$04,d2	;E902
	or.b	d6,d2	;8406
	eor.b	#$22,d2	;0A020022
	move.b	d2,$0002(a4)	;19420002
	move.w	#$0005,adrW_007C7A.l	;33FC000500007C7A
	rts	;4E75

adrJC008002:	bsr	adrCd009268	;61001264
	move.w	$00(a6,d0.w),d1	;32360000
	and.w	#$0007,d1	;02410007
	subq.w	#$02,d1	;5541
	beq.s	adrCd008036	;6724
	and.b	#$40,$01(a6,d0.w)	;023600400001
	move.w	$000C(a5),d1	;322D000C
	sub.w	#$000A,d1	;0441000A
	move.b	adrB_008038(pc,d1.w),d1	;123B1016
	add.w	$0020(a5),d1	;D26D0020
	asl.w	#$04,d1	;E941
	or.w	#$4A81,d1	;00414A81
	or.b	$01(a6,d0.w),d1	;82360001
	move.w	d1,$00(a6,d0.w)	;3D810000
adrCd008036:	rts	;4E75

adrB_008038:	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$01	;01

adrJC00803C:	rts	;4E75

Trigger_10_t14:
	tst.w	Multiplayer.l	;4A790000F98C
	beq.s	adrJC00803C	;67F6
	pea	$00(a1,d1.w)	;48711000
	bsr	adrCd008614	;610005C8
	move.l	(sp)+,a2	;245F
	move.w	CurrentTower.l,d0	;30390000F98A
	addq.w	#$01,CurrentTower.l	;52790000F98A
	tst.b	$0001(a2)	;4A2A0001
	bne.s	adrCd008068	;6606
	subq.w	#$02,CurrentTower.l	;55790000F98A
adrCd008068:	add.w	d0,d0	;D040
	add.b	$0001(a2),d0	;D02A0001
	lea	dungeonex.entrances.l,a0	;41F900008166
	moveq	#$00,d1	;7200
	move.b	$1C(a0,d0.w),d1	;1230001C
	asl.w	#$02,d0	;E540
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
	bsr	adrCd000ED4	;61008E36
	bsr	adrCd0092A6	;61001204
	bsr	adrCd009268	;610011C2
	move.l	d0,$0004(sp)	;2F400004
	move.l	$001C(a5),$0008(sp)	;2F6D001C0008
	move.l	a6,$000C(sp)	;2F4E000C
	bset	#$07,$01(a6,d0.w)	;08F600070001
	bra	adrCd000D42	;60008C84

Trigger_09_t12:
	tst.w	Multiplayer.l	;4A790000F98C
	bmi.s	adrCd0080DC	;6B14
	pea	$00(a1,d1.w)	;48711000
	bsr	adrCd006950	;6100E882
	bsr	adrCd0087BA	;610006E8
	bcc.s	adrCd0080DA	;6404
	tst.b	d0	;4A00
	bmi.s	adrCd0080DE	;6B04
adrCd0080DA:	addq.w	#$04,sp	;584F
adrCd0080DC:	rts	;4E75

adrCd0080DE:	move.l	a1,-(sp)	;2F09
	bsr	adrCd008614	;61000532
	movem.l	(sp)+,a1/a2	;4CDF0600
	move.w	CurrentTower.l,d0	;30390000F98A
	addq.w	#$01,CurrentTower.l	;52790000F98A
	tst.b	$0001(a2)	;4A2A0001
	bne.s	adrCd008100	;6606
	subq.w	#$02,CurrentTower.l	;55790000F98A
adrCd008100:	add.w	d0,d0	;D040
	add.b	$0001(a2),d0	;D02A0001
	lea	dungeonex.entrances.l,a0	;41F900008166
	moveq	#$00,d1	;7200
	move.b	$1C(a0,d0.w),d1	;1230001C
	asl.w	#$02,d0	;E540
	move.b	$00(a0,d0.w),$001D(a5)	;1B700000001D
	move.b	$01(a0,d0.w),$001F(a5)	;1B700001001F
	move.b	$02(a0,d0.w),$001D(a1)	;13700002001D
	move.b	$03(a0,d0.w),$001F(a1)	;13700003001F
	move.w	d1,$0058(a5)	;3B410058
	move.w	d1,$0058(a1)	;33410058
	bsr	adrCd000ED4	;61008D9E
	bsr	adrCd0092A6	;6100116C
	bsr	adrCd009268	;6100112A
	move.l	d0,$0004(sp)	;2F400004
	move.l	$001C(a5),$0008(sp)	;2F6D001C0008
	move.l	a6,$000C(sp)	;2F4E000C
	bset	#$07,$01(a6,d0.w)	;08F600070001
	exg	a5,a1	;CB49
	bsr	adrCd009268	;61001110
	bset	#$07,$01(a6,d0.w)	;08F600070001
	exg	a5,a1	;CB49
	bra	adrCd000D42	;60008BDE

dungeonex.entrances:
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0913	;0913
	dc.w	$0B13	;0B13
	dc.w	$0701	;0701
	dc.w	$0901	;0901
	dc.w	$0007	;0007
	dc.w	$0207	;0207
	dc.w	$0601	;0601
	dc.w	$0801	;0801
	dc.w	$0913	;0913
	dc.w	$0B13	;0B13
	dc.w	$0001	;0001
	dc.w	$0201	;0201
	dc.w	$FF00	;FF00
	dc.w	$0100	;0100
	dc.w	$0400	;0400
	dc.w	$00FF	;00FF

adrJC00818A:	move.l	adrL_00F9D4.l,a6	;2C790000F9D4
	move.b	$0014(a6),d0	;102E0014
	and.b	$001C(a6),d0	;C02E001C
	btst	#$00,d0	;08000000
	bne	Switch_01_s02_Trigger_11_t16_RemoveXY	;6600E796
	rts	;4E75

Trigger_28_t38_GameCompletion:
	move.l	a5,-(sp)	;2F0D
	bsr.s	GameEndPicture	;6164
	clr.w	adrB_0099EE.l	;4279000099EE
	bsr	adrCd009A9A	;610018EC
	bsr	adrCd009B54	;610019A2
	moveq	#$4B,d0	;704B
DBFWait1d:
	dbra	d1,DBFWait1d	;51C9FFFE
	dbra	d0,DBFWait1d	;51C8FFFA
	lea	Player1_Data.l,a5	;4BF90000F9D8
	bsr	adrCd00D9B4	;610057EE
	lea	adrEA00D3DD.l,a6	;4DF90000D3DD
	bsr	adrCd00DA6E	;6100589E
	tst.w	Multiplayer.l	;4A790000F98C
	bne.s	.Player2Skip	;6614
	lea	Player2_Data.l,a5	;4BF90000FA3A
	bsr	adrCd00D9B4	;610057D2
	lea	adrEA00D3DD.l,a6	;4DF90000D3DD
	bsr	adrCd00DA6E	;61005882
.Player2Skip:
	bsr	adrCd009A9A	;610018AA
	bsr	adrCd009B54	;61001960
	move.w	#$FFFF,adrB_0099EE.l	;33FCFFFF000099EE
adrCd0081FE:
	tst.b	adrB_0099EE.l	;4A39000099EE
	bne.s	adrCd0081FE	;66F8
	move.l	(sp)+,a5	;2A5F
	rts	;4E75

GameEndPicture:
	lea	Player1_Data.l,a5	;4BF90000F9D8
	tst.w	Multiplayer.l	;4A790000F98C
	bne.s	.GameEnd_repeat	;6608
	bsr.s	.GameEnd_repeat	;6106
	lea	Player2_Data.l,a5	;4BF90000FA3A
.GameEnd_repeat:
	clr.w	$0014(a5)	;426D0014
	move.w	#$FFFF,$0042(a5)	;3B7CFFFF0042
	bsr	adrCd008894	;61000668
	bsr	adrCd008FFC	;61000DCC
	bsr	adrCd002C3A	;6100AA06
	movem.l	d0-d7/a0-a6,-(sp)	;48E7FFFE
	link	a3,#-$0020	;4E53FFE0	;fix reqd for Devpac
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	$000A(a5),a0	;D0ED000A
	add.w	#$01EC,a0	;D0FC01EC
	move.l	a0,-$0008(a3)	;2748FFF8
	clr.b	-$0015(a3)	;422BFFEB
	clr.b	-$0017(a3)	;422BFFE9
	moveq	#$00,d0	;7000
	moveq	#$00,d1	;7200
	moveq	#$28,d5	;7A28
	moveq	#$36,d4	;7836
	bsr	Draw_Entropy	;61003112
	unlk	a3	;4E5B
	lea	VictoriousText.l,a6	;4DF900008280
	bsr	adrCd00DA6E	;61005800
	lea	CongratsText.l,a6	;4DF9000082A8
	bsr	adrCd00D9D6	;6100575E
	movem.l	(sp)+,d0-d7/a0-a6	;4CDF7FFF
	rts	;4E75

VictoriousText:	dc.b	'THOU ART VICTORIOUS! I SHALL NOT RETURN'	;54484F552041525420564943544F52494F5553212049205348414C4C204E4F542052455455524E
	dc.b	$FF	;FF
CongratsText:	dc.b	$FE	;FE
	dc.b	$0B	;0B
	dc.b	'CONGRATULATIONS!'	;434F4E47524154554C4154494F4E5321
	dc.b	$FF	;FF
	dc.b	$00	;00

Trigger_27_t36:	bsr	adrCd006950	;6100E692
	eor.b	#$03,$00(a6,d0.w)	;0A3600030000
	rts	;4E75

Trigger_24_t30_Spinner3:
	moveq	#$00,d0	;7000
	move.b	$01(a1,d1.w),d0	;10311001
	move.w	d0,d6	;3C00
	bsr	adrCd0092AA	;61000FD8
	bsr	adrCd006950	;6100E67A
	tst.b	$01(a6,d0.w)	;4A360001
	bpl.s	adrCd0082EC	;6A0E
	subq.w	#$01,d7	;5347
	bsr	CoordToMap	;61000F8A
	tst.b	$01(a6,d0.w)	;4A360001
	bpl.s	adrCd0082EC	;6A02
	rts	;4E75

adrCd0082EC:	bsr.s	adrCd0082F0	;6102
	rts	;4E75

adrCd0082F0:	bset	#$07,$01(a6,d0.w)	;08F600070001
	move.l	$0008(sp),d1	;222F0008
	bclr	#$07,$01(a6,d1.w)	;08B600071001
	move.w	d6,$0058(a5)	;3B460058
	move.l	d7,$001C(a5)	;2B47001C
	move.l	d7,$000C(sp)	;2F47000C
	move.l	d0,$0008(sp)	;2F400008
	rts	;4E75

Trigger_21_t2A:	moveq	#$00,d0	;7000
	move.b	$01(a1,d1.w),d0	;10311001
	move.w	d0,d6	;3C00
	bsr	adrCd0092AA	;61000F8E
	bsr	adrCd006950	;6100E630
	tst.b	$01(a6,d0.w)	;4A360001
	bpl.s	adrCd008338	;6A10
	addq.w	#$02,d0	;5440
	swap	d7	;4847
	addq.w	#$01,d7	;5247
	swap	d7	;4847
	tst.b	$01(a6,d0.w)	;4A360001
	bpl.s	adrCd008338	;6A02
	rts	;4E75

adrCd008338:	bsr.s	adrCd0082F0	;61B6
	moveq	#$10,d7	;7E10
	bra	adrCd00222A	;60009EEC

Switch_04_s08_Trigger_22_t2C_RotateWallXY:	bsr	adrCd006950	;6100E60E
	move.b	$01(a6,d0.w),d1	;12360001
	move.w	d1,d2	;3401
	and.b	#$CF,d2	;020200CF
	add.w	#$0010,d1	;06410010
	and.w	#$0030,d1	;02410030
	or.b	d1,d2	;8401
	move.b	d2,$01(a6,d0.w)	;1D820001
	rts	;4E75

Trigger_06_t0C_WoodTrap1:	
	move.l	#$000D000C,d7		;2E3C000D000C
	bsr	CoordToMap		;61000F06
	bset	#$02,$00(a6,d0.w)	;08F600020000
	bclr	#$06,$02(a6,d0.w)	;08B600060002
	rts	;4E75

Trigger_07_t0E_WoodTrap2:	
	move.l	#$00030000,d7			;2E3C00030000	;Long Addr replaced with Symbol
	bsr	CoordToMap		;61000EEE
	bclr	#$02,$00(a6,d0.w)	;08B600020000
	bset	#$06,$02(a6,d0.w)	;08F600060002
	rts				;4E75

Trigger_08_t10:	subq.w	#$02,d0	;5540
	tst.b	$01(a6,d0.w)	;4A360001
	bmi.s	adrCd00839C	;6B06
	bset	#$00,$00(a6,d0.w)	;08F600000000
adrCd00839C:	rts	;4E75

TriggerAction_02_Spinner:	eor.w	#$0002,$0020(a5)	;0A6D00020020
	rts	;4E75

Trigger_02_t04_SpinnerRandom:	bsr	RandomGen_BytewithOffset	;6100DE38
	and.w	#$0003,d0	;02400003
	move.w	d0,$0020(a5)	;3B400020
	rts	;4E75

adrJC0083B4:	addq.w	#$01,$0020(a5)	;526D0020
	and.w	#$0003,$0020(a5)	;026D00030020
	rts	;4E75

Trigger_12_t18:
	bsr	adrCd006950	;6100E58E
	bset	#$00,$00(a6,d0.w)	;08F600000000
	move.w	#$0001,adrW_007C7A.l	;33FC000100007C7A
	rts	;4E75

Switch_03_s06_Trigger_03_t06_OpenLockedDoorXY:
	bsr	adrCd006950	;6100E57A
	bclr	#$00,$00(a6,d0.w)	;08B600000000
	move.w	#$0001,adrW_007C7A.l	;33FC000100007C7A
	rts	;4E75

Switch_07_s0E_Trigger_26_t34_RotateWoodXY:
	bsr	adrCd006950	;6100E566
	move.b	$00(a6,d0.w),d1	;12360000
	ror.b	#$02,d1	;E419
	move.b	d1,$00(a6,d0.w)	;1D810000
	rts	;4E75

Switch06_s0C_Trigger_18_t24_CreatePillarXY:
	bsr	Switch_01_s02_Trigger_11_t16_RemoveXY	;6100E53A
Switch05_s0A_Trigger_13_t1A_TogglePillarXY:
	bsr	adrCd006950	;6100E552
	move.b	#$01,$00(a6,d0.w)	;1DBC00010000
	eor.b	#$03,$01(a6,d0.w)	;0A3600030001
	rts	;4E75

Trigger_14_t1C:
	bsr	adrCd006950	;6100E540
	move.b	$01(a1,d1.w),$00(a6,d0.w)	;1DB110010000
	and.b	#$F8,$01(a6,d0.w)	;023600F80001
	or.b	#$06,$01(a6,d0.w)	;003600060001
	rts	;4E75

Trigger_25_t32:
	bsr	adrCd006950	;6100E528
	eor.b	#$06,$01(a6,d0.w)	;0A3600060001
	rts	;4E75

Trigger_16_t20:	moveq	#$00,d6	;7C00
	move.b	$01(a1,d1.w),d6	;1C311001
	move.w	d1,-(sp)	;3F01
	bsr	adrCd0092CC	;61000E90
	move.w	(sp)+,d1	;321F
	move.l	d2,d7	;2E02
	lea	adrEA006434.l,a0	;41F900006434
	add.b	$08(a0,d6.w),d7	;DE306008
	cmp.w	adrW_00F9CE.l,d7	;BE790000F9CE
	bcc	Switch_01_s02_Trigger_11_t16_RemoveXY	;6400E4E0
	swap	d7	;4847
	add.b	$00(a0,d6.w),d7	;DE306000
	cmp.w	adrW_00F9CC.l,d7	;BE790000F9CC
	bcc	Switch_01_s02_Trigger_11_t16_RemoveXY	;6400E4D0
	swap	d7	;4847
	bsr	CoordToMap	;61000E02
	eor.b	#$06,$01(a6,d0.w)	;0A3600060001
	rts	;4E75

Trigger_17_t22:	bsr	adrCd0092CC	;61000E56
	move.l	d2,d7	;2E02
	subq.b	#$01,d7	;5307
	bsr	CoordToMap	;61000DEE
	and.w	#$00F8,$00(a6,d0.w)	;027600F80000
	or.w	#$0103,$00(a6,d0.w)	;007601030000
	swap	d7	;4847
	subq.b	#$01,d7	;5307
	swap	d7	;4847
	bsr	CoordToMap	;61000DD8
	and.w	#$00F8,$00(a6,d0.w)	;027600F80000
	rts	;4E75

Trigger_04_t08:
	addq.w	#$02,d0	;5440
	tst.b	$01(a6,d0.w)	;4A360001
	bmi	Trigger_00_t00_Null	;6B00F84A
	bset	#$00,$00(a6,d0.w)	;08F600000000
	addq.w	#$02,d0	;5440
adrCd0084B0:
	move.w	#$0086,d7	;3E3C0086
	bsr	adrCd00222A	;61009D74
	tst.b	$01(a6,d0.w)	;4A360001
	bmi.s	adrCd0084D4	;6B16
	btst	#$06,$01(a6,d0.w)	;083600060001
	beq.s	adrCd0084D4	;670E
	moveq	#$03,d4	;7803
adrLp0084C8:	move.w	d4,d6	;3C04
	bsr	adrCd006B7E	;6100E6B2
	beq.s	adrCd0084D6	;6706
adrCd0084D0:	dbra	d4,adrLp0084C8	;51CCFFF6
adrCd0084D4:	rts	;4E75

adrCd0084D6:	lea	$03(a0,d7.w),a1	;43F07003
	moveq	#$00,d3	;7600
	move.b	-$0001(a1),d3	;1629FFFF
	add.w	d3,d3	;D643
adrCd0084E2:	move.b	$00(a1,d3.w),d2	;14313000
	sub.b	#$40,d2	;04020040
	bcs.s	adrCd0084F2	;6506
	cmp.b	#$10,d2	;0C020010
	bcs.s	adrCd0084F8	;6506
adrCd0084F2:	subq.w	#$02,d3	;5543
	bcc.s	adrCd0084E2	;64EC
	bra.s	adrCd0084D0	;60D8

adrCd0084F8:	bset	#$07,$01(a6,d0.w)	;08F600070001
	move.w	d2,-(sp)	;3F02
	bsr	adrCd006A1A	;6100E518
	bsr	adrCd0092CC	;61000DC6
	move.w	d1,d3	;3601
	move.w	(sp)+,d0	;301F
	and.w	#$000F,d0	;0240000F
	move.l	a5,-(sp)	;2F0D
	bsr	adrCd0047FA	;6100C2E6
	tst.w	d1	;4A41
	bpl.s	adrCd00853E	;6A24
	move.l	(sp)+,a5	;2A5F
adrCd00851C:	bsr	adrCd0072D4	;6100EDB6
	move.b	d2,$001B(a4)	;1942001B
	swap	d2	;4842
	move.b	d2,$001A(a4)	;1942001A
	move.b	d3,$001E(a4)	;1943001E
	move.b	#$03,$001C(a4)	;197C0003001C
	move.b	CurrentTower+$1.l,$0023(a4)	;19790000F98B0023
	rts	;4E75

adrCd00853E:	bclr	#$06,$18(a5,d1.w)	;08B500061018
	tst.w	d1	;4A41
	beq.s	adrCd00855E	;6716
	btst	#$06,$0018(a5)	;082D00060018
	bne.s	adrCd008554	;6604
	bsr.s	adrCd00851C	;61CA
	bra.s	adrCd008582	;602E

adrCd008554:	move.b	$0018(a5),$18(a5,d1.w)	;1BAD00181018
	move.w	d0,$0006(a5)	;3B400006
adrCd00855E:	move.b	d0,$0018(a5)	;1B400018
	bset	#$04,$0018(a5)	;08ED00040018
	move.l	d2,$001C(a5)	;2B42001C
	move.w	d3,$0058(a5)	;3B430058
	move.w	#$0003,$0020(a5)	;3B7C00030020
	move.b	d0,$0026(a5)	;1B400026
	bsr	adrCd008FFC	;61000A80
	clr.b	$0056(a5)	;422D0056
adrCd008582:	bsr	adrCd008894	;61000310
	bsr	adrCd008FCA	;61000A42
	move.l	(sp)+,a5	;2A5F
	rts	;4E75

Trigger_05_t0A:
	subq.w	#$02,d0	;5540
	bset	#$00,$00(a6,d0.w)	;08F600000000
	addq.w	#$02,d0	;5440
adrCd008598:
	move.w	#$0086,d7	;3E3C0086
	bsr	adrCd00222A	;61009C8C
	moveq	#$05,d0	;7005
	bsr	PlaySound	;610010EA
	move.w	#$FFFF,adrW_007C7A.l	;33FCFFFF00007C7A
	moveq	#$03,d0	;7003
adrLp0085B0:
	tst.b	$18(a5,d0.w)	;4A350018
	bmi.s	adrCd0085F8	;6B42
	btst	#$05,$18(a5,d0.w)	;083500050018
	bne.s	adrCd0085F8	;663A
	bclr	#$06,$18(a5,d0.w)	;08B500060018
	beq.s	adrCd0085F8	;6732
	move.w	d0,-(sp)	;3F00
	move.b	$18(a5,d0.w),d0	;10350018
	bsr	adrCd0072D4	;6100ED06
	move.b	#$05,$000A(a4)	;197C0005000A
	move.w	#$0005,$0006(a4)	;397C00050006
	move.w	(sp)+,d0	;301F
	moveq	#$03,d1	;7203
adrLp0085E0:
	tst.b	$26(a5,d1.w)	;4A351026
	bmi.s	adrCd0085EC	;6B06
	dbra	d1,adrLp0085E0	;51C9FFF8
	moveq	#$00,d1	;7200
adrCd0085EC:
	and.b	#$0F,$18(a5,d0.w)	;0235000F0018
	move.b	$18(a5,d0.w),$26(a5,d1.w)	;1BB500181026
adrCd0085F8:
	dbra	d0,adrLp0085B0	;51C8FFB6
	move.w	#$FFFF,$0042(a5)	;3B7CFFFF0042
	move.w	#$FFFF,$0040(a5)	;3B7CFFFF0040
	clr.b	$003E(a5)	;422D003E
	bsr	adrCd008894	;61000286
	bra	adrCd008FCA	;600009B8

adrCd008614:	bsr	adrCd001404	;61008DEE
	move.w	CurrentTower.l,d0	;30390000F98A
	move.w	d0,d1	;3200
	add.w	d0,d0	;D040
	add.w	d0,d1	;D240
	asl.w	#$08,d1	;E141
	lea	serpex.monsters.l,a3	;47F900015968
	add.w	d1,a3	;D6C1
	lea	UnpackedMonsters.l,a4	;49F900014EE6
	move.w	-$0002(a4),d1	;322CFFFE
	lea	MonsterTotalsCounts.l,a0	;41F900015960
	move.w	d1,$00(a0,d0.w)	;31810000
	bmi	adrCd0086CE	;6B00008A
	move.l	a3,a0	;204B
	move.w	#$00BF,d0	;303C00BF
	moveq	#-$01,d2	;74FF
adrLp00864E:	move.l	d2,(a0)+	;20C2
	dbra	d0,adrLp00864E	;51C8FFFC
	move.l	a3,a0	;204B
	lea	DroppedObjects.l,a2	;45F900016568
	move.w	CurrentTower.l,d0	;30390000F98A
	add.w	d0,d0	;D040
	move.w	$00(a2,d0.w),d0	;30320000
	lea	$08(a2,d0.w),a2	;45F20008
adrLp00866C:	move.b	$000A(a4),d2	;142C000A
	asl.b	#$04,d2	;E902
	move.b	$0004(a4),d3	;162C0004
	addq.w	#$01,d3	;5243
	and.w	#$000F,d3	;0243000F
	or.b	d2,d3	;8602
	move.b	d3,(a3)+	;16C3
	bpl.s	adrCd008686	;6A04
	move.b	$000C(a4),(a2)+	;14EC000C
adrCd008686:	move.b	$0000(a4),(a3)+	;16EC0000
	move.b	$0001(a4),(a3)+	;16EC0001
	move.b	$0006(a4),(a3)+	;16EC0006
	move.b	$000B(a4),(a3)+	;16EC000B
	move.b	$000D(a4),d3	;162C000D
	bmi.s	adrCd0086C4	;6B28
	lea	adrEA0156F8.l,a6	;4DF9000156F8
	asl.w	#$02,d3	;E543
	add.w	d3,a6	;DCC3
	moveq	#$03,d2	;7403
adrLp0086A8:
	moveq	#$00,d0	;7000
	move.b	$00(a6,d2.w),d0	;10362000
	bmi.s	adrCd0086C0	;6B10
	add.b	d0,d0	;D000
	add.b	$00(a6,d2.w),d0	;D0362000
	add.w	d0,d0	;D040
	move.b	d3,d4	;1803
	add.b	d2,d4	;D802
	move.b	d4,$05(a0,d0.w)	;11840005
adrCd0086C0:	dbra	d2,adrLp0086A8	;51CAFFE6
adrCd0086C4:	addq.w	#$01,a3	;524B
	add.w	#$0010,a4	;D8FC0010
	dbra	d1,adrLp00866C	;51C9FFA0
adrCd0086CE:	lea	adrEA015860.l,a0	;41F900015860
	move.l	adrL_00F9D4.l,a6	;2C790000F9D4
	move.w	-$0002(a0),d7	;3E28FFFE
	clr.w	-$0002(a0)	;4268FFFE
	bra.s	adrCd0086EE	;600A

adrLp0086E4:	move.w	(a0),d0	;3010
	bclr	#$05,$01(a6,d0.w)	;08B600050001
	clr.l	(a0)+	;4298
adrCd0086EE:	dbra	d7,adrLp0086E4	;51CFFFF4
	bra	adrCd005F60	;6000D86C

adrCd0086F6:	move.l	d7,d5	;2A07
	bsr	CoordToMap	;61000B72
	move.w	d0,d2	;3400
	bsr	adrCd008798	;61000098
	bcs	adrCd008790	;6500008C
	move.w	d6,d0	;3006
	bsr	adrCd009254	;61000B4A
	cmp.w	adrW_00F9CE.l,d7	;BE790000F9CE
	bcc.s	adrCd00878E	;647A
	swap	d7	;4847
	cmp.w	adrW_00F9CC.l,d7	;BE790000F9CC
	bcc.s	adrCd00878E	;6470
	swap	d7	;4847
	move.b	$01(a6,d0.w),d1	;12360001
	bpl.s	adrCd008740	;6A1A
	and.w	#$0007,d1	;02410007
	subq.b	#$01,d1	;5301
	beq.s	adrCd00878E	;6760
	subq.b	#$01,d1	;5301
	bne.s	adrCd008790	;665E
	eor.w	#$0002,d6	;0A460002
	bsr.s	adrCd0087A6	;616E
	bcs.s	adrCd00878A	;6550
	eor.w	#$0002,d6	;0A460002
	bra.s	adrCd008790	;6050

adrCd008740:	and.w	#$0007,d1	;02410007
	move.b	adrB_008782(pc,d1.w),d1	;123B103C
	beq.s	adrCd008772	;6728
	bpl.s	adrCd008762	;6A16
	addq.b	#$01,d1	;5201
	beq.s	adrCd00878E	;673E
	addq.b	#$01,d1	;5201
	beq.s	adrCd008790	;673C
	move.b	$00(a6,d0.w),d1	;12360000
	not.b	d1	;4601
	and.b	#$03,d1	;02010003
	beq.s	adrCd00878E	;672E
	bra.s	adrCd008772	;6010

adrCd008762:	eor.w	#$0002,d6	;0A460002
	subq.b	#$01,d1	;5301
	bne.s	adrCd00876E	;6604
	bsr.s	adrCd0087AA	;613E
	bra.s	adrCd008770	;6002

adrCd00876E:	bsr.s	adrCd0087A6	;6136
adrCd008770:	bcs.s	adrCd00878A	;6518
adrCd008772:	bclr	#$07,$01(a6,d2.w)	;08B600072001
	bset	#$07,$01(a6,d0.w)	;08F600070001
	swap	d1	;4841
	rts	;4E75

adrB_008782:	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$02	;02
	dc.b	$FE	;FE
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$FD	;FD

adrCd00878A:	eor.w	#$0002,d6	;0A460002
adrCd00878E:	move.w	d2,d0	;3002
adrCd008790:	move.l	d5,d7	;2E05
	sub.w	#$FFFF,d1	;0441FFFF
	rts	;4E75

adrCd008798:	move.b	$01(a6,d0.w),d1	;12360001
	and.w	#$0007,d1	;02410007
	cmp.b	#$02,d1	;0C010002
	bne.s	adrCd0087B6	;6610
adrCd0087A6:	move.w	d6,d1	;3206
	add.w	d1,d1	;D241
adrCd0087AA:	btst	d1,$00(a6,d0.w)	;03360000
	beq.s	adrCd0087B6	;6706
	sub.b	#$FF,d1	;040100FF
	rts	;4E75

adrCd0087B6:	swap	d1	;4841
	rts	;4E75

adrCd0087BA:	bsr	adrCd0092CC	;61000B10
adrCd0087BE:	move.w	#$0080,d0	;303C0080
	lea	Player1_Data.l,a1	;43F90000F9D8
	cmp.w	$0058(a1),d1	;B2690058
	bne.s	adrCd0087D4	;6606
	cmp.l	$001C(a1),d2	;B4A9001C
	beq.s	adrCd008846	;6772
adrCd0087D4:	addq.b	#$01,d0	;5200
	lea	Player2_Data.l,a1	;43F90000FA3A
	cmp.w	$0058(a1),d1	;B2690058
	bne.s	adrCd0087E8	;6606
	cmp.l	$001C(a1),d2	;B4A9001C
	beq.s	adrCd008846	;675E
adrCd0087E8:	lea	CharacterStats.l,a1	;43F90000F586
	move.b	d2,d0	;1002
	swap	d2	;4842
	rol.w	#$08,d2	;E15A
	move.b	d0,d2	;1400
	move.w	CurrentTower.l,d3	;36390000F98A
	moveq	#$0F,d0	;700F
adrLp0087FE:	cmp.b	$0023(a1),d3	;B6290023
	bne.s	adrCd008810	;660C
	cmp.b	$001E(a1),d1	;B229001E
	bne.s	adrCd008810	;6606
	cmp.w	$001A(a1),d2	;B469001A
	beq.s	adrCd008840	;6730
adrCd008810:	lea	$0040(a1),a1	;43E90040
	dbra	d0,adrLp0087FE	;51C8FFE8
	moveq	#$10,d0	;7010
	lea	UnpackedMonsters.l,a1	;43F900014EE6
	move.w	-$0002(a1),d3	;3629FFFE
	bmi.s	adrCd00883C	;6B16
adrLp008826:	cmp.b	$0004(a1),d1	;B2290004
	bne.s	adrCd008832	;6606
	cmp.w	$0000(a1),d2	;B4690000
	beq.s	adrCd008846	;6714
adrCd008832:	addq.w	#$01,d0	;5240
	add.w	#$0010,a1	;D2FC0010
	dbra	d3,adrLp008826	;51CBFFEC
adrCd00883C:	swap	d1	;4841
	rts	;4E75

adrCd008840:	not.b	d0	;4600
	and.w	#$000F,d0	;0240000F
adrCd008846:	ori.b	#$01,ccr	;003C0001
	rts	;4E75

adrCd00884C:	bsr	adrCd009B74	;61001326
	moveq	#$00,d4	;7800
	moveq	#$60,d5	;7A60
	tst.w	Multiplayer.l	;4A790000F98C
	beq.s	adrCd008864	;6708
	moveq	#$1F,d5	;7A1F
	bsr.s	adrCd008872	;6112
	move.w	#$0090,d5	;3A3C0090
adrCd008864:	bsr.s	adrCd008872	;610C
adrCd008866:	bsr	adrCd008FFC	;61000794
	bsr	adrCd008894	;61000028
	bra	adrCd009D84	;60001514

adrCd008872:	move.l	#$013F0001,d3	;263C013F0001
adrCd008878:	bsr	adrCd00E654	;61005DDA
	addq.w	#$01,d5	;5245
	addq.w	#$01,d3	;5243
	cmp.w	#$0005,d3	;0C430005
	bcs.s	adrCd008878	;65F2
	subq.w	#$02,d3	;5543
adrCd008888:	bsr	adrCd00E654	;61005DCA
	addq.w	#$01,d5	;5245
	subq.w	#$01,d3	;5343
	bne.s	adrCd008888	;66F6
	rts	;4E75

adrCd008894:	tst.w	$0042(a5)	;4A6D0042
	bmi	adrCd008C1A	;6B000380
	or.b	#$03,$0054(a5)	;002D00030054
	move.l	#$005F0000,d4	;283C005F0000
	move.l	#$00580007,d5	;2A3C00580007
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$00,d3	;7600
	bsr	adrCd00E538	;61005C82
	move.l	#$FFFFFFFF,$005A(a5)	;2B7CFFFFFFFF005A
	bsr	adrCd00D652	;61004D90
	moveq	#$0A,d5	;7A0A
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$32,d4	;7832
	move.l	#$002B0002,d3	;263C002B0002
	bsr	adrCd00E5D4	;61005D00
	moveq	#$5D,d4	;785D
	bsr	adrCd00E5D4	;61005CFA
	add.w	#$0002,d5	;06450002
	sub.l	#$00040000,d3	;048300040000	;Long Addr replaced with Symbol
	moveq	#$5B,d4	;785B
	bsr	adrCd00E5D4	;61005CEA
	moveq	#$34,d4	;7834
	bsr	adrCd00E5D4	;61005CE4
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	#$0147,a0	;D0FC0147
	add.w	$000A(a5),a0	;D0ED000A
	moveq	#$71,d7	;7E71
	move.w	$0012(a5),d3	;362D0012
adrCd008906:	move.w	d7,d0	;3007
	bsr	adrCd00D3DE	;61004AD4
	addq.w	#$01,d7	;5247
	move.w	d7,d0	;3007
	bsr	adrCd00D3DE	;61004ACC
	addq.w	#$01,d7	;5247
	add.w	#$027C,a0	;D0FC027C
	cmp.w	#$0075,d7	;0C470075
	bcs.s	adrCd008906	;65E6
	cmp.w	#$0008,$0042(a5)	;0C6D00080042
	bne.s	adrCd00892E	;6606
	cmp.w	#$0077,d7	;0C470077
	bcs.s	adrCd008906	;65D8
adrCd00892E:	bsr	adrCd008AC4	;61000194
	lea	_GFX_Pockets+$3C60.l,a1	;43F90004D112
	move.l	#$00050006,d5	;2A3C00050006	;Long Addr replaced with Symbol
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	#$0DE8,a0	;D0FC0DE8
	add.w	$000A(a5),a0	;D0ED000A
	lea	$00000070.l,a3	;47F900000070
	bra	adrCd00D60C	;60004CB8

adrEA008956:	dc.b	$5F	;5F
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
adrEA008968:	dc.b	$5F	;5F
	dc.b	$5F	;5F
	dc.b	$5F	;5F
	dc.b	$5F	;5F
adrEA00896C:	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$FC	;FC
	dc.b	$FF	;FF
adrEA008974:	dc.b	$5F	;5F
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
adrEA008982:	dc.b	$5F	;5F
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
adrEA008995:	dc.b	$5F	;5F
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
adrEA0089B7:	dc.b	$5F	;5F
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
adrEA0089CF:	dc.b	$5F	;5F
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
adrEA0089DB:	dc.b	$5F	;5F
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

adrJC0089E8:
	lea	adrEA008956.l,a6	;4DF900008956
	rts	;4E75

adrJC0089F0:
	bsr.s	adrCd008A50	;615E
	moveq	#$01,d1	;7201
	moveq	#$00,d3	;7600
adrCd0089F6:
	move.b	$18(a5,d1.w),d0	;10351018
	and.w	#$00E0,d0	;024000E0
	bne.s	adrCd008A16	;6616
	move.b	$18(a5,d1.w),d0	;10351018
	and.w	#$000F,d0	;0240000F
	move.b	d0,$04(a6,d2.w)	;1D802004
	move.b	#$5F,$00(a6,d3.w)	;1DBC005F3000
	addq.w	#$01,d3	;5243
	addq.w	#$02,d2	;5442
adrCd008A16:	addq.w	#$01,d1	;5241
	cmp.w	#$0004,d1	;0C410004
	bcs.s	adrCd0089F6	;65D8
	rts	;4E75

adrJC008A20:	bsr.s	adrCd008A50	;612E
	moveq	#$02,d1	;7202
	moveq	#$00,d3	;7600
adrLp008A26:	move.b	$19(a5,d1.w),d0	;10351019
	bmi.s	adrCd008A4A	;6B1E
	btst	#$05,d0	;08000005
	beq.s	adrCd008A4A	;6718
	btst	#$06,d0	;08000006
	bne.s	adrCd008A4A	;6612
	and.w	#$000F,d0	;0240000F
	move.b	d0,$04(a6,d2.w)	;1D802004
	move.b	#$5F,$00(a6,d3.w)	;1DBC005F3000
	addq.w	#$02,d2	;5442
	addq.w	#$01,d3	;5243
adrCd008A4A:	dbra	d1,adrLp008A26	;51C9FFDA
	rts	;4E75

adrCd008A50:	lea	adrEA008968.l,a6	;4DF900008968
	move.b	#$FC,d0	;103C00FC
	moveq	#$08,d2	;7408
adrCd008A5C:	move.b	d0,$02(a6,d2.w)	;1D802002
	subq.w	#$02,d2	;5542
	bne.s	adrCd008A5C	;66F8
	move.l	#$FFFFFFFF,(a6)	;2CBCFFFFFFFF
	rts	;4E75

adrJC008A6C:
	lea	adrEA008974.l,a6	;4DF900008974
	rts	;4E75

adrJC008A74:
	lea	adrEA008982.l,a6	;4DF900008982
	rts	;4E75

adrJC008A7C:
	lea	adrEA008995.l,a6	;4DF900008995
	rts	;4E75

adrJC008A84:
	lea	adrEA0089B7.l,a6	;4DF9000089B7
	rts	;4E75

adrJC008A8C:
	lea	adrEA0089CF.l,a6	;4DF9000089CF
	rts	;4E75

adrJC008A94:
	lea	adrEA0089DB.l,a6	;4DF9000089DB
	rts	;4E75

adrJT008A9C:
	dc.l	adrJC0089E8	;000089E8
	dc.l	adrJC0089F0	;000089F0
	dc.l	$00000000	;00000000
	dc.l	adrJC008A20	;00008A20
	dc.l	adrJC008A6C	;00008A6C
	dc.l	adrJC008A74	;00008A74
	dc.l	adrJC008A7C	;00008A7C
	dc.l	adrJC008A84	;00008A84
	dc.l	adrJC008A8C	;00008A8C
	dc.l	adrJC008A94	;00008A94

adrCd008AC4:	or.b	#$01,$0054(a5)	;002D00010054
	move.w	$0044(a5),d0	;302D0044
	asl.w	#$02,d0	;E540
	move.l	adrJT008A9C(pc,d0.w),a0	;207B00CA
	jsr	(a0)	;4E90
	move.l	a6,$0046(a5)	;2B4E0046
	move.l	#$00060039,d5	;2A3C00060039
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$00,d7	;7E00
adrCd008AE6:	moveq	#$02,d3	;7602
	moveq	#$00,d4	;7800
	move.b	$00(a6,d7.w),d4	;18367000
	bpl.s	adrCd008AF4	;6A04
	moveq	#$5F,d4	;785F
	bra.s	adrCd008B04	;6010

adrCd008AF4:	cmp.b	$0040(a5),d7	;BE2D0040
	bne.s	adrCd008B04	;660A
	tst.b	$0041(a5)	;4A2D0041
	bne.s	adrCd008B04	;6604
	move.w	$0010(a5),d3	;362D0010
adrCd008B04:	subq.w	#$01,d4	;5344
	swap	d4	;4844
	movem.l	d4/d5/d7,-(sp)	;48E70D00
	bsr	adrCd00E538	;61005A2A
	subq.w	#$07,d5	;5F45
	swap	d4	;4844
	addq.w	#$01,d4	;5244
	move.l	#$00060000,d3	;263C00060000
	bsr	adrCd00E5D4	;61005AB6
	movem.l	(sp),d4/d5/d7	;4CD700B0
	swap	d4	;4844
	addq.w	#$02,d4	;5444
	moveq	#$5D,d0	;705D
	sub.w	d4,d0	;9044
	bcs.s	adrCd008B4A	;651C
	swap	d4	;4844
	move.w	d0,d4	;3800
	swap	d4	;4844
	moveq	#$02,d3	;7602
	cmp.b	$0040(a5),d7	;BE2D0040
	bne.s	adrCd008B46	;660A
	tst.b	$0041(a5)	;4A2D0041
	beq.s	adrCd008B46	;6704
	move.w	$0010(a5),d3	;362D0010
adrCd008B46:	bsr	adrCd00E538	;610059F0
adrCd008B4A:	movem.l	(sp)+,d4/d5/d7	;4CDF00B0
	addq.w	#$08,d5	;5045
	addq.w	#$01,d7	;5247
	cmp.w	#$0004,d7	;0C470004
	bcs.s	adrCd008AE6	;658E
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	$000A(a5),a0	;D0ED000A
	add.w	#$0910,a0	;D0FC0910
	addq.w	#$04,a6	;584E
	moveq	#$00,d7	;7E00
adrCd008B6A:	move.l	a0,-(sp)	;2F08
	bsr	adrCd00E0E2	;61005574
	clr.b	adrB_00F989.l	;42390000F989
	move.l	(sp)+,a0	;205F
	add.w	#$0140,a0	;D0FC0140
	addq.w	#$01,d7	;5247
	cmp.w	#$0004,d7	;0C470004
	bcs.s	adrCd008B6A	;65E6
	moveq	#$00,d4	;7800
	moveq	#$39,d5	;7A39
	add.w	$0008(a5),d5	;DA6D0008
	move.l	#$001E0000,d3	;263C001E0000
	bsr	adrCd00E5D4	;61005A40
	moveq	#$5E,d4	;785E
	bsr	adrCd00E5D4	;61005A3A
	addq.w	#$01,d4	;5244
	bra	adrCd00E5D4	;60005A34

adrCd008BA2:	add.l	screen_ptr.l,a0	;D1F900009B06
	add.w	$000A(a5),a0	;D0ED000A
	lea	_GFX_Pockets+$6500.l,a1	;43F90004F9B2
	move.l	#$00000024,-(sp)	;2F3C00000024
	moveq	#$00,d3	;7600
adrCd008BBA:	lea	$00000098.l,a3	;47F900000098
	bra	adrCd00D81C	;60004C5A

adrCd008BC4:	btst	d7,$003E(a5)	;0F2D003E
	beq.s	adrCd008BDA	;6710
	move.b	$18(a5,d7.w),d1	;12357018
	move.b	d1,d0	;1001
	and.w	#$000F,d0	;0240000F
	and.w	#$00E0,d1	;024100E0
	beq.s	adrCd008BDC	;6702
adrCd008BDA:	rts	;4E75

adrCd008BDC:	move.b	d0,-$0017(a3)	;1740FFE9
	move.w	d7,d0	;3007
	add.w	d7,d7	;DE47
	add.w	d0,d7	;DE40
	add.w	d7,d7	;DE47
	move.w	adrW_008C02(pc,d7.w),d4	;383B7018
	move.w	adrW_008C04(pc,d7.w),d5	;3A3B7016
	move.w	adrW_008C06(pc,d7.w),d1	;323B7014
	moveq	#$00,d0	;7000
	move.w	#$FFFF,adrW_00BBFA.l	;33FCFFFF0000BBFA
	bra	Draw_Characters	;60002996

adrW_008C02:	dc.w	$0011	;0011
adrW_008C04:	dc.w	$001C	;001C
adrW_008C06:	dc.w	$0000	;0000
	dc.w	$0008	;0008
	dc.w	$0048	;0048
	dc.w	$0001	;0001
	dc.w	$0028	;0028
	dc.w	$0048	;0048
	dc.w	$0001	;0001
	dc.w	$0048	;0048
	dc.w	$0048	;0048
	dc.w	$0001	;0001

adrCd008C1A:	moveq	#$03,d7	;7E03
adrLp008C1C:	move.w	d7,-(sp)	;3F07
	bsr	adrCd008C4A	;6100002A
	move.w	(sp)+,d7	;3E1F
	dbra	d7,adrLp008C1C	;51CFFFF6
	bsr	adrCd008D52	;61000128
adrCd008C2C:	lea	_GFX_Pockets+$3C30.l,a1	;43F90004D0E2
	move.l	#$00050006,d5	;2A3C00050006	;Long Addr replaced with Symbol
	move.l	screen_ptr.l,a0	;207900009B06
	lea	$0DE8(a0),a0	;41E80DE8
	add.w	$000A(a5),a0	;D0ED000A
	bra	adrLp009B0E	;60000EC6

adrCd008C4A:	tst.b	$5A(a5,d7.w)	;4A35705A
	bmi.s	adrCd008C52	;6B02
	rts	;4E75

adrCd008C52:	or.b	#$03,$0054(a5)	;002D00030054
	tst.w	d7	;4A47
	beq.s	adrCd008C64	;6708
	clr.w	adrW_00F986.l	;42790000F986
	bra.s	adrCd008CAE	;604A

adrCd008C64:	tst.w	$0042(a5)	;4A6D0042
	bpl	adrCd00D652	;6A0049E8
	moveq	#$00,d3	;7600
	moveq	#$5F,d4	;785F
	swap	d4	;4844
	move.l	#$002E0007,d5	;2A3C002E0007
	add.w	$0008(a5),d5	;DA6D0008
	bsr	adrCd00E538	;610058BA
	btst	#$00,$003E(a5)	;082D0000003E
	bne.s	adrCd008C90	;6608
	bsr	adrCd00D652	;610049C8
	bra	adrCd008D52	;600000C4

adrCd008C90:	move.l	#$00000230,a0	;207C00000230
	bsr	adrCd008BA2	;6100FF0A
	move.l	#$00000235,a0	;207C00000235
	bsr	adrCd008BA2	;6100FF00
	moveq	#$00,d7	;7E00
	bsr	adrCd008D0C	;61000064
	bra	adrCd008D52	;600000A6

adrCd008CAE:	move.l	screen_ptr.l,a0	;207900009B06
	add.w	#$0898,a0	;D0FC0898
	add.w	$000A(a5),a0	;D0ED000A
	move.w	d7,d0	;3007
	subq.w	#$01,d7	;5347
	asl.w	#$02,d7	;E547
	add.w	d7,a0	;D0C7
	move.b	$18(a5,d0.w),d7	;1E350018
	bpl.s	adrCd008CE0	;6A16
	lea	adrEA01710C.l,a1	;43F90001710C
	sub.l	a3,a3	;97CB
	move.l	#$00010028,d5	;2A3C00010028	;Long Addr replaced with Symbol
	move.w	$0012(a5),d3	;362D0012
	bra	adrCd00D81A	;60004B3C

adrCd008CE0:	btst	d0,$003E(a5)	;012D003E
	beq.s	adrCd008D30	;674A
	btst	#$05,d7	;08070005
	bne.s	adrCd008D30	;6644
	btst	#$06,d7	;08070006
	bne.s	adrCd008D38	;6646
	move.w	d0,-(sp)	;3F00
	lea	_GFX_Pockets+$5070.l,a1	;43F90004E522
	move.l	#$00010028,d5	;2A3C00010028	;Long Addr replaced with Symbol
	move.l	#$00000090,a3	;267C00000090
	bsr	adrCd00D60C	;61004904
	move.w	(sp)+,d7	;3E1F
adrCd008D0C:	
	link	a3,#-$0020	;4E53FFE0	;fix reqd for Devpac
	move.b	#$FF,-$0019(a3)	;177C00FFFFE7
	clr.b	-$0015(a3)	;422BFFEB
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	$000A(a5),a0	;D0ED000A
	move.l	a0,-$0008(a3)	;2748FFF8
	bsr	adrCd008BC4	;6100FE9A
	unlk	a3	;4E5B
adrCd008D2E:	rts	;4E75

adrCd008D30:	moveq	#$04,d3	;7604
	btst	#$06,d7	;08070006
	beq.s	adrCd008D3A	;6702
adrCd008D38:	moveq	#$00,d3	;7600
adrCd008D3A:	and.w	#$000F,d7	;0247000F
	tst.w	d3	;4A43
	beq.s	adrCd008D4E	;670C
	bsr	adrCd00D690	;6100494C
	cmp.w	#$0008,d3	;0C430008
	bne.s	adrCd008D4E	;6602
	subq.w	#$01,d3	;5343
adrCd008D4E:	bra	adrCd00D73E	;600049EE

adrCd008D52:	tst.w	$0042(a5)	;4A6D0042
	bpl.s	adrCd008D2E	;6AD6
	moveq	#$36,d4	;7836
	moveq	#$0A,d5	;7A0A
	add.w	$0008(a5),d5	;DA6D0008
	move.l	#$00240001,d3	;263C00240001
	bsr	adrCd00E654	;610058EC
	addq.w	#$01,d5	;5245
	subq.w	#$02,d4	;5544
	add.l	#$00040001,d3	;068300040001	;Long Addr replaced with Symbol
	bsr	adrCd00E654	;610058DE
	addq.w	#$01,d5	;5245
	subq.w	#$01,d4	;5344
	add.l	#$00020001,d3	;068300020001	;Long Addr replaced with Symbol
	bsr	adrCd00E654	;610058D0
	addq.w	#$01,d5	;5245
	addq.w	#$01,d3	;5243
	bsr	adrCd00E654	;610058C8
	addq.w	#$01,d5	;5245
	subq.w	#$03,d3	;5743
	bsr	adrCd00E654	;610058C0
	moveq	#$31,d5	;7A31
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$33,d4	;7833
	move.l	#$002A0001,d3	;263C002A0001
	bsr	adrCd00E654	;610058AE
	addq.w	#$01,d5	;5245
	addq.w	#$03,d3	;5643
	bsr	adrCd00E654	;610058A6
	addq.w	#$01,d5	;5245
	subq.w	#$01,d3	;5343
	bsr	adrCd00E654	;6100589E
	addq.w	#$01,d4	;5244
	addq.w	#$01,d5	;5245
	sub.l	#$00020001,d3	;048300020001	;Long Addr replaced with Symbol
	bsr	adrCd00E654	;61005890
	addq.w	#$02,d4	;5444
	addq.w	#$01,d5	;5245
	sub.l	#$00040001,d3	;048300040001	;Long Addr replaced with Symbol
	bsr	adrCd00E654	;61005882
	moveq	#$10,d5	;7A10
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$34,d4	;7834
	move.l	#$001F0001,d3	;263C001F0001
	bsr	adrCd00E5D4	;610057F0
	moveq	#$5C,d4	;785C
	bsr	adrCd00E5D4	;610057EA
	swap	d5	;4845
	move.w	#$001F,d5	;3A3C001F
	swap	d5	;4845
	move.l	#$00260035,d4	;283C00260035
	moveq	#$02,d3	;7602
	bsr	adrCd00E538	;6100573A
	lea	_GFX_Pockets+$7580.l,a1	;43F900050A32
	move.l	#$00000088,a3	;267C00000088
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	$000A(a5),a0	;D0ED000A
	add.w	#$0286,a0	;D0FC0286
	move.l	#$00020005,d5	;2A3C00020005	;Long Addr replaced with Symbol
	bsr	adrCd00D60C	;610047EA
adrCd008E24:	tst.w	$0042(a5)	;4A6D0042
	bpl	adrCd008FDA	;6A0001B0
	or.b	#$01,$0054(a5)	;002D00010054
	move.l	#$00240036,d4	;283C00240036
	move.l	#$00160017,d5	;2A3C00160017
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$03,d3	;7603
	bsr	adrCd00E538	;610056F2
	btst	#$00,$003E(a5)	;082D0000003E
	bne	adrCd008EBE	;6600006E
	move.w	$0006(a5),d7	;3E2D0006
	asl.w	#$06,d7	;ED47
	lea	CharacterStats.l,a6	;4DF90000F586
	lea	$06(a6,d7.w),a6	;4DF67006
	move.l	#$00040019,d5	;2A3C00040019	;Long Addr replaced with Symbol
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$02,d6	;7C02
	moveq	#$07,d3	;7607
	btst	#$00,(a5)	;08150000
	beq.s	adrCd008E78	;6702
	moveq	#$0C,d3	;760C
adrCd008E78:	move.w	(a6)+,d0	;301E
	move.w	(a6),d1	;3216
	addq.w	#$01,a6	;524E
	tst.w	d0	;4A40
	beq.s	adrCd008E9C	;671A
	bra.s	adrCd008E8E	;600A

adrLp008E84:	moveq	#$00,d0	;7000
	move.b	(a6)+,d0	;101E
	beq.s	adrCd008E9C	;6712
	moveq	#$00,d1	;7200
	move.b	(a6),d1	;1216
adrCd008E8E:	bsr.s	adrCd008EA6	;6116
	movem.l	d3-d6,-(sp)	;48E71E00
	bsr	adrCd00E538	;610056A2
	movem.l	(sp)+,d3-d6	;4CDF0078
adrCd008E9C:	addq.w	#$07,d5	;5E45
	addq.w	#$01,a6	;524E
	dbra	d6,adrLp008E84	;51CEFFE2
	rts	;4E75

adrCd008EA6:	move.l	#$00220037,d4	;283C00220037
	moveq	#$23,d2	;7423
adrCd008EAE:	swap	d4	;4844
	cmp.w	d1,d0	;B041
	bcc.s	adrCd008EBA	;6406
	mulu	d2,d0	;C0C2
	divu	d1,d0	;80C1
	move.w	d0,d4	;3800
adrCd008EBA:	swap	d4	;4844
	rts	;4E75

adrCd008EBE:	lea	CharacterStats.l,a6	;4DF90000F586
	moveq	#$03,d6	;7C03
	move.l	#$00060052,d5	;2A3C00060052
adrLp008ECC:	move.b	$18(a5,d6.w),d0	;10356018
	move.w	d0,d1	;3200
	and.w	#$00E0,d1	;024100E0
	bne.s	adrCd008F2C	;6654
	and.w	#$000F,d0	;0240000F
	asl.w	#$06,d0	;ED40
	move.w	$08(a6,d0.w),d1	;32360008
	move.w	$06(a6,d0.w),d0	;30360006
	beq.s	adrCd008F2C	;6744
	moveq	#$14,d4	;7814
	swap	d4	;4844
	moveq	#$15,d2	;7415
	bsr.s	adrCd008EAE	;61BE
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
	asl.w	#$06,d0	;ED40
	move.b	$01(a6,d0.w),d0	;10360001
	move.b	d0,d1	;1200
	bsr	adrCd0075DC	;6100E6C6
	cmp.b	#$10,d1	;0C010010
	bcs.s	adrCd008F20	;6502
	addq.w	#$04,d0	;5840
adrCd008F20:	move.b	adrB_008F36(pc,d0.w),d3	;163B0014
	bsr	adrCd00E538	;61005612
	movem.l	(sp)+,d3-d6	;4CDF0078
adrCd008F2C:	sub.w	#$0009,d5	;04450009
	dbra	d6,adrLp008ECC	;51CEFF9A
adrCd008F34:	rts	;4E75

adrB_008F36:	dc.b	$06	;06
	dc.b	$0D	;0D
	dc.b	$0C	;0C
	dc.b	$07	;07
	dc.b	$05	;05
	dc.b	$0B	;0B
	dc.b	$09	;09
	dc.b	$08	;08

adrCd008F3E:	tst.w	$0014(a5)	;4A6D0014
	bne.s	adrCd008F34	;66F0
	or.b	#$04,$0054(a5)	;002D00040054
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	#$054C,a0	;D0FC054C
	add.w	$000A(a5),a0	;D0ED000A
	bsr	adrCd0072D0	;6100E376
	moveq	#$63,d0	;7063
	moveq	#$00,d2	;7400
	move.b	$0015(a4),d2	;142C0015
	bne.s	adrCd008F82	;661C
	move.b	$0017(a4),d2	;142C0017
	bmi.s	adrCd008F7E	;6B12
	move.w	d2,d0	;3002
	bsr	adrCd0075DC	;6100E66C
	cmp.b	$000F(a4),d0	;B02C000F
	bne.s	adrCd008F7A	;6602
	moveq	#$04,d0	;7004
adrCd008F7A:	add.w	#$0050,d0	;06400050
adrCd008F7E:	bra	adrCd00D3DE	;6000445E

adrCd008F82:	and.w	#$0007,d2	;02420007
	moveq	#$0B,d3	;760B
	tst.b	$0025(a4)	;4A2C0025
	bne.s	adrCd008F90	;6602
	moveq	#$06,d3	;7606
adrCd008F90:	move.b	adrB_008FA0(pc,d2.w),d0	;103B200E
	cmp.w	#$0040,d0	;0C400040
	bne.s	adrCd008F7E	;66E4
	add.w	$0020(a5),d0	;D06D0020
	bra.s	adrCd008F7E	;60DE

adrB_008FA0:	dc.b	$3C	;3C
	dc.b	$3D	;3D
	dc.b	$3E	;3E
	dc.b	$3F	;3F
	dc.b	$40	;40
	dc.b	$44	;44
	dc.b	$45	;45
	dc.b	$46	;46

AdrCd008FA8:	tst.b	$0055(a5)	;4A2D0055
	bpl.s	adrCd008FB2	;6A04
	bsr	adrCd007A0A	;6100EA5A
adrCd008FB2:	move.b	$0034(a5),d0	;102D0034
	bmi.s	adrCd008FDA	;6B22
	move.b	#$FF,$0034(a5)	;1B7C00FF0034
	lea	adrEA004972.l,a6	;4DF900004972
	move.b	d0,(a6)	;1C80
	bsr	adrCd00E33A	;61005372
adrCd008FCA:	moveq	#$00,d0	;7000
	move.b	$0015(a5),d0	;102D0015
	beq	adrCd009104	;67000132
	subq.b	#$03,d0	;5700
	beq	adrCd007900	;6700E928
adrCd008FDA:	rts	;4E75

adrCd008FDC:	or.b	#$0C,$0054(a5)	;002D000C0054
	bsr	adrCd00D9B4	;610049D0
	move.l	#$005E00E1,d4	;283C005E00E1
	move.l	#$00560009,d5	;2A3C00560009
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$00,d3	;7600
	bra	adrCd00E538	;6000553E

adrCd008FFC:	bsr.s	adrCd008FDC	;61DE
	move.w	#$00E2,d4	;383C00E2
	moveq	#$0A,d5	;7A0A
	add.w	$0008(a5),d5	;DA6D0008
	move.l	#$005D0001,d3	;263C005D0001
adrCd00900E:	bsr	adrCd00E654	;61005644
	addq.w	#$01,d5	;5245
	addq.w	#$01,d3	;5243
	cmp.w	#$0005,d3	;0C430005
	bcs.s	adrCd00900E	;65F2
	subq.w	#$04,d3	;5943
	bsr	adrCd00E654	;61005634
	move.l	#$00070010,d5	;2A3C00070010
	add.w	$0008(a5),d5	;DA6D0008
	move.l	#$005D00E2,d4	;283C005D00E2
	move.w	$0010(a5),d3	;362D0010
	bsr	adrCd00E538	;61005500
	move.w	#$0001,d3	;363C0001
adrCd00903E:	addq.w	#$01,d5	;5245
	bsr	adrCd00E654	;61005612
	addq.w	#$01,d3	;5243
	cmp.w	#$0005,d3	;0C430005
	bcs.s	adrCd00903E	;65F2
	move.w	$0006(a5),d0	;302D0006
	bsr	adrCd00D926	;610048D4
	move.l	screen_ptr.l,a0	;207900009B06
	lea	$0544(a0),a0	;41E80544
	add.w	$000A(a5),a0	;D0ED000A
	lea	_GFX_Pockets+$67C0.l,a1	;43F90004FC72
	move.l	#$00000080,a3	;267C00000080
	move.l	#$00030015,d5	;2A3C00030015	;Long Addr replaced with Symbol
	bsr	adrCd00D60C	;61004596
	lea	$0028(a0),a0	;41E80028
	lea	_GFX_Pockets+$67E0.l,a1	;43F90004FC92
	btst	#$00,(a5)	;08150000
	bne.s	adrCd00908C	;6604
	lea	$0020(a1),a1	;43E90020
adrCd00908C:	move.l	#$0003001E,d5	;2A3C0003001E	;Long Addr replaced with Symbol
	bsr	adrCd00D60C	;61004578
	bsr	adrCd008F3E	;6100FEA6
	move.w	#$0062,d0	;303C0062
	bsr	adrCd00D3DE	;6100433E
	moveq	#$20,d5	;7A20
	add.w	$0008(a5),d5	;DA6D0008
	move.w	#$0120,d4	;383C0120
	move.l	#$001F0001,d3	;263C001F0001
	bsr	adrCd00E654	;610055A0
	add.w	#$0011,d5	;06450011
	bsr	adrCd00E654	;61005598
	addq.w	#$02,d5	;5445
adrCd0090C0:	bsr	adrCd00E654	;61005592
	addq.w	#$01,d5	;5245
	addq.w	#$01,d3	;5243
	cmp.w	#$0005,d3	;0C430005
	bcs.s	adrCd0090C0	;65F2
	subq.w	#$04,d3	;5943
	bsr	adrCd00E654	;61005582
	bsr.s	adrCd009104	;612E

	move.l	#$00000E04,a0	;207C00000E04	;Long Addr replaced with Symbol FIX

adrCd0090DC:	
	move.l	#$00000070,a3	;267C00000070
	lea	_GFX_Pockets+$3C00.l,a1	;43F90004D0B2
	move.l	#$00050006,d5	;2A3C00050006	;Long Addr replaced with Symbol
	add.l	screen_ptr.l,a0	;D1F900009B06
	add.w	$000A(a5),a0	;D0ED000A
	bra	adrCd00D60C	;60004512

adrW_0090FC:	dc.w	$08E4	;08E4
	dc.w	$0000	;0000
	dc.w	$0256	;0256
	dc.w	$FFFC	;FFFC

adrCd009104:	btst	#$06,$0018(a5)	;082D00060018
	bne	adrCd008FDA	;6600FECE
	or.b	#$04,$0054(a5)	;002D00040054
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	$000A(a5),a0	;D0ED000A
	moveq	#$00,d7	;7E00
adrCd009120:	move.w	d7,d2	;3407
	add.w	d2,d2	;D442
	add.w	adrW_0090FC(pc,d2.w),a0	;D0FB20D6
	move.b	$26(a5,d7.w),d0	;10357026
	bpl.s	adrCd009134	;6A06
	bsr	adrCd0091F4	;610000C4
	bra.s	adrCd009144	;6010

adrCd009134:	cmp.w	$0016(a5),d7	;BE6D0016
	beq.s	adrCd009140	;6706
	bsr	adrCd0091A0	;61000064
	bra.s	adrCd009144	;6004

adrCd009140:	bsr	adrCd00919C	;6100005A
adrCd009144:	addq.w	#$01,d7	;5247
	cmp.w	#$0004,d7	;0C470004
	bcs.s	adrCd009120	;65D4
	move.w	$0006(a5),d0	;302D0006
	bsr	adrCd004826	;6100B6D4
	move.w	$0010(a5),d3	;362D0010
	move.l	#$000F0121,d4	;283C000F0121
	move.l	#$000D0039,d5	;2A3C000D0039
	add.w	$0008(a5),d5	;DA6D0008
	btst	#$01,d2	;08020001
	beq.s	adrCd009172	;6704
	add.w	#$000F,d5	;0645000F
adrCd009172:	move.b	adrB_009182(pc,d2.w),d2	;143B200E
	beq.s	adrCd00917E	;6706
	sub.l	#$0000FFF0,d4	;04840000FFF0	;Long Addr replaced with Symbol
adrCd00917E:	bra	adrCd00E5A4	;60005424

adrB_009182:	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$00	;00

adrCd009186:	move.b	$18(a5,d7.w),d0	;10357018
	and.w	#$00EF,d0	;024000EF
	bmi.s	adrCd0091F4	;6B64
	btst	#$05,d0	;08000005
	bne.s	adrCd0091F4	;665E
	btst	#$06,d0	;08000006
	beq.s	adrCd0091A0	;6704
adrCd00919C:	moveq	#$00,d6	;7C00
	bra.s	adrCd0091BE	;601E

adrCd0091A0:	and.w	#$000F,d0	;0240000F
	move.w	d0,d1	;3200
	asl.w	#$06,d0	;ED40
	lea	CharacterStats.l,a6	;4DF90000F586
	move.b	$01(a6,d0.w),d0	;10360001
	bsr	adrCd0075DC	;6100E428
	move.w	d0,d6	;3C00
	addq.w	#$01,d6	;5246
	asl.w	#$02,d6	;E546
	move.w	d1,d0	;3001
adrCd0091BE:	bsr	adrCd0091FC	;6100003C
	tst.w	d6	;4A46
	beq.s	adrCd0091D0	;670A
	cmp.w	#$0010,d2	;0C420010
	bcs.s	adrCd0091D0	;6504
	add.w	#$0010,d6	;06460010
adrCd0091D0:	lea	ClickedClassColours.l,a6	;4DF900009228
	add.w	d6,a6	;DCC6
	and.w	#$0003,d0	;02400003
	add.w	#$004B,d0	;0640004B
	move.w	#$FFFF,adrW_00C354.l	;33FCFFFF0000C354
	bsr	adrCd00D3DE	;610041F4
	clr.w	adrW_00C354.l	;42790000C354
	rts	;4E75

adrCd0091F4:	move.w	#$003B,d0	;303C003B
	bra	adrCd00D3DE	;600041E4

adrCd0091FC:	and.w	#$000F,d0	;0240000F
	move.w	d0,d1	;3200
	asl.w	#$06,d0	;ED40
	lea	CharacterStats.l,a6	;4DF90000F586
	add.w	d0,a6	;DCC0
	move.b	$0001(a6),d1	;122E0001
	move.w	d1,d2	;3401
	lea	characters.heads.l,a6	;4DF90000B788
	move.b	$00(a6,d1.w),d1	;12361000
	lea	adrEA00D6B6.l,a6	;4DF90000D6B6
	move.b	$00(a6,d1.w),d0	;10361000
	rts	;4E75

ClickedClassColours:
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
	dc.w	$0005	;0005
	dc.w	$0106	;0106
	dc.w	$000B	;000B
	dc.w	$0A0D	;0A0D
	dc.w	$000C	;000C
	dc.w	$090B	;090B
	dc.w	$0007	;0007
	dc.w	$0108	;0108

adrCd00924C:
	move.l	$001C(a5),d7	;2E2D001C
adrCd009250:
	move.w	$0020(a5),d0	;302D0020
adrCd009254:
	lea	adrEA006434.l,a0	;41F900006434
	add.b	$08(a0,d0.w),d7	;DE300008
	swap	d7	;4847
	add.b	$00(a0,d0.w),d7	;DE300000
	swap	d7	;4847
	bra.s	CoordToMap	;6004

adrCd009268:	move.l	$001C(a5),d7	;2E2D001C
CoordToMap:	move.l	adrL_00F9D4.l,a6	;2C790000F9D4
adrCd009272:	move.w	d7,d0	;3007
	mulu	adrW_00F9CC.l,d0	;C0F90000F9CC
	swap	d7	;4847
	add.w	d7,d0	;D047
	swap	d7	;4847
	add.w	d0,d0	;D040
	add.w	adrW_00F9D2.l,d0	;D0790000F9D2
	rts	;4E75

adrCd00928A:	lea	adrEA00F9BC.l,a0	;41F90000F9BC
	add.b	$08(a0,d2.w),d7	;DE302008
	swap	d7	;4847
	add.b	$00(a0,d2.w),d7	;DE302000
	sub.b	$00(a0,d1.w),d7	;9E301000
	swap	d7	;4847
	sub.b	$08(a0,d1.w),d7	;9E301008
	rts	;4E75

adrCd0092A6:	move.w	$0058(a5),d0	;302D0058
adrCd0092AA:	lea	adrEA00F99C.l,a0	;41F90000F99C
	move.b	$00(a0,d0.w),adrB_00F9CD.l	;13F000000000F9CD
	move.b	$08(a0,d0.w),adrB_00F9CF.l	;13F000080000F9CF
	add.w	d0,d0	;D040
	move.w	$10(a0,d0.w),adrW_00F9D2.l	;33F000100000F9D2
	rts	;4E75

adrCd0092CC:	moveq	#-$01,d1	;72FF
	moveq	#$00,d2	;7400
	move.w	adrW_00F9D2.l,d2	;34390000F9D2
	lea	adrEA00F9AC.l,a0	;41F90000F9AC
adrCd0092DC:	addq.w	#$01,d1	;5241
	cmp.w	(a0)+,d2	;B458
	bne.s	adrCd0092DC	;66FA
	sub.w	d0,d2	;9440
	neg.w	d2	;4442
	lsr.w	#$01,d2	;E24A
	divu	adrW_00F9CC.l,d2	;84F90000F9CC
	rts	;4E75

adrL_0092F0:	dc.l	$00000000	;00000000

adrLp0092F4:	bsr	adrCd009304	;6100000E
	bsr	adrCd0094F6	;610001FC
	addq.w	#$02,d0	;5440
	dbra	d7,adrLp0092F4	;51CFFFF4
	rts	;4E75

adrCd009304:	movem.l	d0-d7/a1-a4,-(sp)	;48E7FF78
	move.l	adrL_0092F0.l,a1	;2279000092F0
	move.w	#$00F9,d6	;3C3C00F9
adrLp009312:	move.l	#$AAAAAAAA,(a1)+	;22FCAAAAAAAA
	dbra	d6,adrLp009312	;51CEFFF8
	moveq	#$0A,d3	;760A
	moveq	#$0B,d2	;740B
adrLp009320:	move.l	a1,a6	;2C49
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
	bsr	adrCd00945A	;61000102
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
	bsr	adrCd00945A	;610000D4
	move.l	a1,a3	;2649
	addq.l	#$08,a1	;5089
	move.l	a1,a4	;2849
	moveq	#$7F,d5	;7A7F
	moveq	#$00,d4	;7800
adrLp009392:	move.l	(a0)+,d7	;2E18
	move.l	d7,d6	;2C07
	and.l	#$AAAAAAAA,d6	;0286AAAAAAAA
	lsr.l	#$01,d6	;E28E
	and.l	#$55555555,d7	;028755555555
	move.l	d7,$0200(a1)	;23470200
	move.l	d6,(a1)+	;22C6
	eor.l	d6,d4	;BD84
	eor.l	d7,d4	;BF84
	dbra	d5,adrLp009392	;51CDFFE2
	move.l	d4,d7	;2E04
	and.l	#$AAAAAAAA,d4	;0284AAAAAAAA
	lsr.l	#$01,d4	;E28C
	and.l	#$55555555,d7	;028755555555
	move.l	a3,a2	;244B
	move.l	d4,(a3)+	;26C4
	move.l	d7,(a3)	;2687
	moveq	#$01,d5	;7A01
	bsr	adrCd00945A	;6100008E
	move.l	a4,a2	;244C
	move.w	#$0080,d5	;3A3C0080
	bsr	adrCd00945A	;61000084
	addq.b	#$01,d1	;5201
	subq.b	#$01,d2	;5302
	add.l	#$00000200,a1	;D3FC00000200
	dbra	d3,adrLp009320	;51CBFF3C
	move.l	#$AAAAAAAA,(a1)	;22BCAAAAAAAA
	move.w	#$0002,_custom+intreq.l	;33FC000200DFF09C
	move.l	adrL_0092F0.l,a1	;2279000092F0
	move.l	a1,_custom+dskpt.l	;23C900DFF020
	move.w	#$8210,_custom+dmacon.l	;33FC821000DFF096
	move.w	#$7700,_custom+adkcon.l	;33FC770000DFF09E
	move.w	#$9100,_custom+adkcon.l	;33FC910000DFF09E
	move.w	#$4000,_custom+dsklen.l	;33FC400000DFF024
	move.b	_ciab+ciaicr.l,d0	;103900BFDD00
adrCd009426:	move.b	_ciab+ciaicr.l,d0	;103900BFDD00
	btst	#$04,d0	;08000004
	beq.s	adrCd009426	;67F4
	move.w	#$D955,_custom+dsklen.l	;33FCD95500DFF024
	move.w	#$D955,_custom+dsklen.l	;33FCD95500DFF024
adrCd009442:	move.w	_custom+intreqr.l,d0	;303900DFF01E
	btst	#$01,d0	;08000001
	beq.s	adrCd009442	;67F4
	movem.l	(sp)+,d0-d7/a1-a4	;4CDF1EFF
	bsr	adrCd00963A	;610001E6
	bra	adrCd0094A2	;6000004A

adrCd00945A:	movem.l	d0-d5/a2,-(sp)	;48E7FC20
	add.w	d5,d5	;DA45
	subq.w	#$01,d5	;5345
	move.b	-$0001(a2),d0	;102AFFFF
adrLp009466:	move.l	(a2),d4	;2812
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
	dbra	d5,adrLp009466	;51CDFFDE
	movem.l	(sp)+,d0-d5/a2	;4CDF043F
	rts	;4E75

adrCd009490:	move.l	a0,-(sp)	;2F08
adrLp009492:	bsr	adrCd009576	;610000E2
	bsr	adrCd0094F6	;6100005E
	dbra	d0,adrLp009492	;51C8FFF6
	move.l	(sp)+,a0	;205F
	rts	;4E75

adrCd0094A2:	btst	#$05,_ciaa.l	;0839000500BFE001
	bne.s	adrCd0094A2	;66F6
	rts	;4E75

adrCd0094AE:	st	adrB_009672.l	;50F900009672
	move.b	#$79,$00BFD100.l	;13FC007900BFD100
	nop	;4E71
	nop	;4E71
	move.b	#$71,$00BFD100.l	;13FC007100BFD100
	move.w	#$B000,d0	;303CB000
adrLp0094CC:	dbra	d0,adrLp0094CC	;51C8FFFE
	rts	;4E75

adrCd0094D2:	clr.b	adrB_009672.l	;423900009672
	move.b	#$7D,$00BFD100.l	;13FC007D00BFD100
	nop	;4E71
	nop	;4E71
	move.b	#$75,$00BFD100.l	;13FC007500BFD100
	move.w	#$B000,d0	;303CB000
adrLp0094F0:	dbra	d0,adrLp0094F0	;51C8FFFE
	rts	;4E75

adrCd0094F6:	tst.b	adrB_009672.l	;4A3900009672
	beq.s	adrCd009514	;6716
	move.b	#$70,$00BFD100.l	;13FC007000BFD100
	nop	;4E71
	nop	;4E71
	move.b	#$71,$00BFD100.l	;13FC007100BFD100
	bra.s	adrCd009528	;6014

adrCd009514:	move.b	#$74,$00BFD100.l	;13FC007400BFD100
	nop	;4E71
	nop	;4E71
	move.b	#$75,$00BFD100.l	;13FC007500BFD100
adrCd009528:	bsr	adrCd00963A	;61000110
	bra	adrCd0094A2	;6000FF74

adrCd009530:	tst.b	adrB_009672.l	;4A3900009672
	beq.s	adrCd00954E	;6716
	move.b	#$72,$00BFD100.l	;13FC007200BFD100
	nop	;4E71
	nop	;4E71
	move.b	#$73,$00BFD100.l	;13FC007300BFD100
	bra.s	adrCd009562	;6014

adrCd00954E:
	move.b	#$76,$00BFD100.l	;13FC007600BFD100
	nop	;4E71
	nop	;4E71
	move.b	#$77,$00BFD100.l	;13FC007700BFD100
adrCd009562:	
	bsr	adrCd00963A	;610000D6
	bra	adrCd0094A2	;6000FF3A

;fiX Label expected
	subq.w	#$01,d6	;5346
	beq	adrCd00961A	;670000AC
	bsr	adrCd00963A	;610000C8
	bra.s	adrCd00957C	;6006

adrCd009576:	
	movem.l	d0-d2/d5/d6/a1,-(sp)	;48E7E640
	moveq	#$03,d6	;7C03
adrCd00957C:	
	move.w	#$0002,_custom+intreq.l	;33FC000200DFF09C
	move.l	adrL_0092F0.l,a1	;2279000092F0
	clr.l	$0002(a1)	;42A90002
	move.l	a1,_custom+dskpt.l	;23C900DFF020
	move.w	#$8010,_custom+dmacon.l	;33FC801000DFF096
	move.w	#$4489,_custom+dsksync.l	;33FC448900DFF07E
	move.w	#$9500,_custom+adkcon.l	;33FC950000DFF09E
	move.w	#$4000,_custom+dsklen.l	;33FC400000DFF024
	move.b	_ciab+ciaicr.l,d0	;103900BFDD00
adrCd0095BA:	
	move.b	_ciab+ciaicr.l,d0	;103900BFDD00
	btst	#$04,d0	;08000004
	beq.s	adrCd0095BA	;67F4
	move.w	#$9F40,_custom+dsklen.l	;33FC9F4000DFF024
	move.w	#$9F40,_custom+dsklen.l	;33FC9F4000DFF024

	move.l	#$000186A0,d1	;223C000186A0	;Long Addr replaced with Symbol

adrCd0095DC:	move.w	_custom+intreqr.l,d0	;303900DFF01E
	btst	#$01,d0	;08000001
	bne.s	adrCd0095EC	;6604
	subq.l	#$01,d1	;5381
	bne.s	adrCd0095DC	;66F0
adrCd0095EC:	moveq	#$0A,d5	;7A0A
	lea	$003A(a1),a1	;43E9003A
adrLp0095F2:	moveq	#$7F,d6	;7C7F
adrLp0095F4:	move.l	$0200(a1),d1	;22290200
	move.l	(a1)+,d0	;2019
	asl.l	#$01,d0	;E380
	and.l	#$AAAAAAAA,d0	;0280AAAAAAAA
	and.l	#$55555555,d1	;028155555555
	or.l	d1,d0	;8081
	move.l	d0,(a0)+	;20C0
	dbra	d6,adrLp0095F4	;51CEFFE6
	add.l	#$00000240,a1	;D3FC00000240
	dbra	d5,adrLp0095F2	;51CDFFDA
adrCd00961A:	movem.l	(sp)+,d0-d2/d5/d6/a1	;4CDF0267
	rts	;4E75

adrCd009620:	move.b	_ciaa.l,d0	;103900BFE001
	btst	#$04,d0	;08000004
	beq.s	adrCd009636	;670A
	bsr	adrCd009530	;6100FF02
	bsr	adrCd00963A	;61000008
	bra.s	adrCd009620	;60EA

adrCd009636:	bra	adrCd0094A2	;6000FE6A

adrCd00963A:	move.l	d7,-(sp)	;2F07
	move.w	#$0960,d7	;3E3C0960
adrLp009640:	dbra	d7,adrLp009640	;51CFFFFE
	move.l	(sp)+,d7	;2E1F
	rts	;4E75

adrCd009648:	move.b	#$FD,_ciab+ciaprb.l	;13FC00FD00BFD100
	nop	;4E71
	nop	;4E71
	move.b	#$F5,_ciab+ciaprb.l	;13FC00F500BFD100
	rts	;4E75

adrCd00965E:	move.l	d7,-(sp)	;2F07
	bsr.s	adrCd009620	;61BE
	subq.w	#$01,d7	;5347
	bcs.s	adrCd00966E	;6508
adrLp009666:	bsr	adrCd0094F6	;6100FE8E
	dbra	d7,adrLp009666	;51CFFFFA
adrCd00966E:	move.l	(sp)+,d7	;2E1F
	rts	;4E75

adrB_009672:	dc.b	$00	;00
	dc.b	$00	;00

Level_4_Interrupt:
	move.w	#$0001,_custom+dmacon.l	;33FC000100DFF096
	move.w	#$0080,_custom+intena.l	;33FC008000DFF09A
	move.w	#$0080,_custom+intreq.l	;33FC008000DFF09C
	rte	;4E73

PlaySound:
	move.w	d1,-(sp)	;3F01
	move.w	#$0001,_custom+dmacon.l	;33FC000100DFF096
	move.w	#$0080,_custom+intena.l	;33FC008000DFF09A
	asl.w	#$02,d0	;E540
	lea	AudioSample_1.l,a0	;41F900051A82
	add.w	AudioSampleOffsets(pc,d0.w),a0	;D0FB005E
	move.w	AudioSampleOffsets+2(pc,d0.w),d0	;303B005C
	lea	$0030(a0),a0	;41E80030
	move.w	-$0002(a0),d1	;3228FFFE
	lsr.w	#$01,d1	;E249
	asl.w	#$02,d0	;E540
	move.l	a0,_custom+aud.l	;23C800DFF0A0
	move.w	d1,_custom+aud0+ac_len.l	;33C100DFF0A4
	move.w	#$0040,_custom+aud0+ac_vol.l	;33FC004000DFF0A8
	move.w	d0,_custom+aud0+ac_per.l	;33C000DFF0A6
	move.w	(a0),_custom+aud0+ac_dat.l	;33D000DFF0AA
	move.w	#$0078,d1	;323C0078
.soundloop1:
	dbra	d1,.soundloop1	;51C9FFFE
	move.w	#$8001,_custom+dmacon.l	;33FC800100DFF096
	move.w	#$0078,d1	;323C0078
.soundloop2:
	dbra	d1,.soundloop2	;51C9FFFE
	move.w	#$0080,_custom+intreq.l	;33FC008000DFF09C
	move.w	#$8080,_custom+intena.l	;33FC808000DFF09A
	move.w	(sp)+,d1	;321F
	rts	;4E75


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
	dc.w	$0049		

adrW_009720:
	dc.w	$0000	;0000

MouseControl:	move.w	_custom+joy0dat.l,d0	;303900DFF00A
	move.w	adrW_009720.l,d1	;323900009720
	move.w	d0,adrW_009720.l	;33C000009720
	bsr	adrCd0097DA	;610000A4
	ror.w	#$08,d0	;E058
	ror.w	#$08,d1	;E059
	bsr	adrCd0097DA	;6100009C
	lea	Player1_Data.l,a5	;4BF90000F9D8
	move.w	$0004(a5),d1	;322D0004
	moveq	#$00,d2	;7400
	move.b	d0,d2	;1400
	ext.w	d2	;4882
	add.w	d2,d1	;D242
	bpl.s	adrCd009756	;6A02
	moveq	#$00,d1	;7200
adrCd009756:	cmp.b	$003B(a5),d1	;B22D003B
	bcc.s	adrCd009760	;6404
	move.b	$003B(a5),d1	;122D003B
adrCd009760:	cmp.b	$003A(a5),d1	;B22D003A
	bcs.s	adrCd00976A	;6504
	move.b	$003A(a5),d1	;122D003A
adrCd00976A:	move.w	d1,$0004(a5)	;3B410004
	lsr.w	#$08,d0	;E048
	ext.w	d0	;4880
	move.w	$0002(a5),d1	;322D0002
	add.w	d0,d1	;D240
	bpl.s	adrCd00977E	;6A04
	add.w	#$0140,d1	;06410140
adrCd00977E:	cmp.w	#$0140,d1	;0C410140
	bcs.s	adrCd009788	;6504
	sub.w	#$0140,d1	;04410140
adrCd009788:	move.w	d1,$0002(a5)	;3B410002
	move.l	$0002(a5),d1	;222D0002
	lea	SpritePosition_00.l,a0	;41F900009C50
	bsr	adrCd009820	;61000088
	lea	SpritePosition_01.l,a0	;41F900009CE0
	move.l	#$FF81FFC9,d1	;223CFF81FFC9
	bsr	adrCd009820	;61000078
	move.b	_ciaa.l,d1	;123900BFE001
	not.b	d1	;4601
	and.w	#$0040,d1	;02410040
	rol.b	#$01,d1	;E319
	lea	adrEA0098CC.l,a0	;41F9000098CC
	tst.b	d1	;4A01
	bpl.s	adrCd0097C6	;6A04
	tst.b	(a0)	;4A10
	bmi.s	adrCd0097D8	;6B12
adrCd0097C6:	move.b	d1,(a0)	;1081
	tst.b	d1	;4A01
	bpl.s	adrCd0097D8	;6A0C
	tst.b	$0001(a5)	;4A2D0001
	bmi.s	adrCd0097D8	;6B06
	bset	#$07,$0001(a5)	;08ED00070001
adrCd0097D8:	rts	;4E75

adrCd0097DA:	sub.b	d1,d0	;9001
	bcc.s	adrCd0097E4	;6406
	tst.b	d0	;4A00
	bmi.s	adrCd0097EA	;6B08
	bra.s	adrCd0097E8	;6004

adrCd0097E4:	tst.b	d0	;4A00
	bpl.s	adrCd0097EA	;6A02
adrCd0097E8:	neg.b	d0	;4400
adrCd0097EA:	rts	;4E75

InputControls:	tst.w	Multiplayer.l	;4A790000F98C
	bne	MouseControl	;6600FF2E
	bsr	JoystickControl	;610000D6
	move.w	(a0),d0	;3010
	lea	Player2_Data.l,a5	;4BF90000FA3A
	bsr	adrCd009868	;61000064
	lea	SpritePosition_01.l,a0	;41F900009CE0
	bsr.s	adrCd009820	;6112
	lsr.w	#$08,d0	;E048
	lea	Player1_Data.l,a5	;4BF90000F9D8
	bsr	adrCd009868	;61000050
	lea	SpritePosition_00.l,a0	;41F900009C50
adrCd009820:	add.w	#$0037,d1	;06410037
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

adrCd009868:	move.l	$0002(a5),d1	;222D0002
	lsr.b	#$01,d0	;E208
	bcc.s	adrCd00987A	;640A
	subq.w	#$02,d1	;5541
	cmp.b	$003B(a5),d1	;B22D003B
	bcc.s	adrCd00987A	;6402
	addq.w	#$02,d1	;5441
adrCd00987A:	lsr.b	#$01,d0	;E208
	bcc.s	adrCd009888	;640A
	addq.w	#$02,d1	;5441
	cmp.b	$003A(a5),d1	;B22D003A
	bcs.s	adrCd009888	;6502
	subq.w	#$02,d1	;5541
adrCd009888:	swap	d1	;4841
	lsr.b	#$01,d0	;E208
	bcc.s	adrCd009896	;6408
	subq.w	#$02,d1	;5541
	bcc.s	adrCd009896	;6404
	add.w	#$0140,d1	;06410140
adrCd009896:	lsr.b	#$01,d0	;E208
	bcc.s	adrCd00989C	;6402
	addq.w	#$02,d1	;5441
adrCd00989C:	cmp.w	#$0140,d1	;0C410140
	bcs.s	adrCd0098A6	;6504
	sub.w	#$0140,d1	;04410140
adrCd0098A6:	swap	d1	;4841
	move.l	d1,$0002(a5)	;2B410002
	rts	;4E75

adrCd0098AE:	move.w	d0,d1	;3200
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

adrEA0098CA:	dc.b	$00	;00
	dc.b	$00	;00
adrEA0098CC:	dc.b	$00	;00
	dc.b	$00	;00

JoystickControl:	move.w	_custom+joy0dat.l,d0	;303900DFF00A
	bsr.s	adrCd0098AE	;61D8
	move.b	_ciaa.l,d1	;123900BFE001
	not.b	d1	;4601
	and.w	#$0040,d1	;02410040
	rol.b	#$01,d1	;E319
	or.b	d1,d0	;8001
	swap	d0	;4840
	move.w	_custom+joy1dat.l,d0	;303900DFF00C
	bsr.s	adrCd0098AE	;61BE
	move.b	_ciaa.l,d1	;123900BFE001
	not.b	d1	;4601
	and.b	#$80,d1	;02010080
	or.b	d1,d0	;8001
	lea	adrEA0098CA.l,a0	;41F9000098CA
	lea	Player2_Data.l,a5	;4BF90000FA3A
	moveq	#$01,d1	;7201
adrLp00990C:	tst.b	$02(a0,d1.w)	;4A301002
	bpl.s	adrCd00991C	;6A0A
	move.b	d0,$02(a0,d1.w)	;11801002
	and.b	#$7F,d0	;0200007F
	bra.s	adrCd009920	;6004

adrCd00991C:	move.b	d0,$02(a0,d1.w)	;11801002
adrCd009920:	move.b	d0,$00(a0,d1.w)	;11801000
	tst.b	d0	;4A00
	bpl.s	adrCd009934	;6A0C
	tst.b	$0001(a5)	;4A2D0001
	bmi.s	adrCd009934	;6B06
	bset	#$07,$0001(a5)	;08ED00070001
adrCd009934:	lea	Player1_Data.l,a5	;4BF90000F9D8
	swap	d0	;4840
	dbra	d1,adrLp00990C	;51C9FFCE
	rts	;4E75

adrCd009942:	tst.w	Paused_Marker.l	;4A79000099EC
	bne.s	adrCd0099B8	;666E
	tst.b	$0052(a5)	;4A2D0052
	bmi.s	adrCd0099B0	;6B60
	moveq	#$00,d0	;7000
	move.b	$004B(a5),d0	;102D004B
	bne.s	adrCd00996A	;6612
	move.b	$0052(a5),d0	;102D0052
	and.w	#$003F,d0	;0240003F
	beq.s	adrCd0099B0	;674E
	move.w	#$90FF,$004A(a5)	;3B7C90FF004A
	bra.s	adrCd0099B0	;6046

adrCd00996A:	tst.b	$004A(a5)	;4A2D004A
	bne.s	adrCd0099AC	;663C
	tst.b	d0	;4A00
	bpl.s	adrCd00997C	;6A08
	cmp.w	#$00F9,d0	;0C4000F9
	beq.s	adrCd0099B0	;6736
	neg.b	d0	;4400
adrCd00997C:	subq.b	#$01,$004B(a5)	;532D004B
	move.b	#$02,$004A(a5)	;1B7C0002004A
	btst	#$00,(a5)	;08150000
	beq.s	adrCd009990	;6704
	add.w	#$000C,d0	;0640000C
adrCd009990:	btst	#$06,$0052(a5)	;082D00060052
	beq.s	adrCd00999A	;6702
	addq.w	#$06,d0	;5C40
adrCd00999A:	add.w	d0,d0	;D040
	move.w	adrCd0099B8(pc,d0.w),d0	;303B001A
;fiX Data reference expected
	move.w	d0,_custom+color+$0000001E.l	;33C000DFF19E
	move.w	d0,$004C(a5)	;3B40004C
	rts	;4E75

adrCd0099AC:	subq.b	#$01,$004A(a5)	;532D004A
adrCd0099B0:	move.w	$004C(a5),_custom+color+$0000001E.l	;33ED004C00DFF19E
adrCd0099B8:	rts	;4E75

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
VBI_Marker:	dc.w	$0000	;0000
Paused_Marker:	dc.w	$0000	;0000
adrB_0099EE:	dc.b	$00	;00
adrB_0099EF:	dc.b	$FF	;FF

VerticalBlankInterupt:	move.w	d0,-(sp)	;3F00
	move.w	_custom+intreqr.l,d0	;303900DFF01E
	and.w	#$0020,d0	;02400020
	beq.s	adrCd009A10	;6712
	move.w	(sp)+,d0	;301F
	move.w	#$0020,_custom+intreq.l	;33FC002000DFF09C
	clr.w	VBI_Marker.l	;4279000099EA
	rte	;4E73

adrCd009A10:	move.w	(sp)+,d0	;301F
	eor.w	#$0001,VBI_Marker.l	;0A790001000099EA
	beq.s	adrCd009A32	;6716
	movem.l	d0/a5,-(sp)	;48E78004
	lea	Player2_Data.l,a5	;4BF90000FA3A
	bsr	adrCd009942	;6100FF1A
	movem.l	(sp)+,d0/a5	;4CDF2001
	bra	adrCd009A90	;60000060

adrCd009A32:	movem.l	d0-d7/a0-a6,-(sp)	;48E7FFFE
	subq.w	#$01,adrW_00F9FA.l	;53790000F9FA
	bcc.s	adrCd009A44	;6406
	clr.w	adrW_00F9FA.l	;42790000F9FA
adrCd009A44:	subq.w	#$01,adrW_00FA5C.l	;53790000FA5C
	bcc.s	adrCd009A52	;6406
	clr.w	adrW_00FA5C.l	;42790000FA5C
adrCd009A52:	lea	adrEA00F992.l,a0	;41F90000F992
	moveq	#$02,d0	;7002
adrLp009A5A:	subq.w	#$01,(a0)+	;5358
	bcc.s	adrCd009A62	;6404
	clr.w	-$0002(a0)	;4268FFFE
adrCd009A62:	dbra	d0,adrLp009A5A	;51C8FFF6
	lea	Player1_Data.l,a5	;4BF90000F9D8
	bsr	adrCd009942	;6100FED4
	tst.b	adrB_0099EF.l	;4A39000099EF
	beq.s	adrCd009A8C	;6714
	bsr	InputControls	;6100FD72
	tst.b	adrB_0099EE.l	;4A39000099EE
	beq.s	adrCd009A8C	;6708
	clr.b	adrB_0099EE.l	;4239000099EE
	bsr.s	adrCd009A9A	;610E
adrCd009A8C:	movem.l	(sp)+,d0-d7/a0-a6	;4CDF7FFF
adrCd009A90:	move.w	#$0010,_custom+intreq.l	;33FC001000DFF09C
AdrCd009A98:	rte	;4E73

adrCd009A9A:	cmp.l	#$00060000,screen_ptr.l	;0CB90006000000009B06
	bne.s	adrCd009ABC	;6616
	move.l	#$00067D00,screen_ptr.l	;23FC00067D0000009B06
	move.l	#$00060000,framebuffer_ptr.l	;23FC0006000000009B0A
	bra.s	adrCd009AD0	;6014

adrCd009ABC:	move.l	#$00060000,screen_ptr.l	;23FC0006000000009B06
	move.l	#$00067D00,framebuffer_ptr.l	;23FC00067D0000009B0A
adrCd009AD0:	lea	CopperList000.l,a0	;41F900009BDC
	move.l	#$00060000,d0	;203C00060000
	cmp.l	screen_ptr.l,d0	;B0B900009B06
	bne.s	adrCd009AEA	;6606
	move.l	#$00067D00,d0	;203C00067D00
adrCd009AEA:	
	moveq	#$03,d1	;7203
adrLp009AEC:	
	move.w	d0,$0006(a0)	;31400006
	swap	d0	;4840
	move.w	d0,$0002(a0)	;31400002
	swap	d0	;4840
	add.l	#$00001F40,d0	;068000001F40	;Long Addr replaced with Symbol
	addq.w	#$08,a0	;5048
	dbra	d1,adrLp009AEC	;51C9FFEA
	rts	;4E75

screen_ptr:	dc.l	$00060000	;00060000
framebuffer_ptr:	dc.l	$00067D00	;00067D00

adrLp009B0E:	swap	d5	;4845
	move.w	d5,d4	;3805
adrLp009B12:	move.w	(a0),d2	;3410
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
	dbra	d4,adrLp009B12	;51CCFFD0
	lea	$001C(a0),a0	;41E8001C
	lea	$0070(a1),a1	;43E90070
	swap	d5	;4845
	dbra	d5,adrLp009B0E	;51CDFFBE
	rts	;4E75

adrCd009B54:	move.l	screen_ptr.l,a1	;227900009B06
	move.l	framebuffer_ptr.l,a0	;207900009B0A
	move.w	#$1F3F,d0	;303C1F3F
adrLp009B64:	move.l	(a0)+,(a1)+	;22D8
	dbra	d0,adrLp009B64	;51C8FFFC
	rts	;4E75

adrCd009B6C:	move.l	framebuffer_ptr.l,a0	;207900009B0A
	bra.s	adrCd009B7A	;6006

adrCd009B74:	move.l	screen_ptr.l,a0	;207900009B06
adrCd009B7A:	move.w	#$1F3F,d0	;303C1F3F
adrLp009B7E:	clr.l	(a0)+	;4298
	dbra	d0,adrLp009B7E	;51C8FFFC
	rts	;4E75

adrCd009B86:	lea	_custom+color.l,a1	;43F900DFF180
	lea	adrEA009B9C.l,a0	;41F900009B9C
	moveq	#$1F,d0	;701F
adrLp009B94:	move.w	(a0)+,(a1)+	;32D8
	dbra	d0,adrLp009B94	;51C8FFFC
	rts	;4E75

adrEA009B9C:	
	dc.l	$00000444	;00000444	;Long Addr replaced with Symbol
	dc.l	$06660888	;06660888
	dc.l	$0AAA0292	;0AAA0292
	dc.l	$01C1000E	;01C1000E
	dc.l	$048E0821	;048E0821
	dc.l	$0B310E96	;0B310E96
	dc.l	$0D000FD0	;0D000FD0
	dc.l	$0EEE0C08	;0EEE0C08
	dc.l	$00000000	;00000000
	dc.l	$00000000	;00000000
	dc.l	$0000022E	;0000022E
	dc.l	$048E0EEE	;048E0EEE
	dc.l	$00000E00	;00000E00	;Long Addr replaced with Symbol
	dc.l	$0E830EEE	;0E830EEE
	dc.l	$00000000	;00000000
	dc.l	$00000000	;00000000
CopperList000:	
	dc.l	$00E00007	;00E00007
	dc.l	$00E20000	;00E20000
	dc.l	$00E40007	;00E40007
	dc.l	$00E62000	;00E62000
	dc.l	$00E80007	;00E80007
	dc.l	$00EA4000	;00EA4000
	dc.l	$00EC0007	;00EC0007
	dc.l	$00EE6000	;00EE6000
CopperList001:	
	dc.l	$01200000	;01200000
	dc.l	$01220000	;01220000
	dc.l	$01240000	;01240000
	dc.l	$01260000	;01260000
	dc.l	$01280000	;01280000
	dc.l	$012A0000	;012A0000
	dc.l	$012C0000	;012C0000
	dc.l	$012E0000	;012E0000
	dc.l	$01300000	;01300000
	dc.l	$01320000	;01320000
	dc.l	$01340000	;01340000
	dc.l	$01360000	;01360000
	dc.l	$01380000	;01380000
	dc.l	$013A0000	;013A0000
	dc.l	$013C0000	;013C0000
	dc.l	$013E0000	;013E0000
	dc.l	$9801FF00	;9801FF00
	dc.l	$009C8010	;009C8010
	dc.l	$FF01FF00	;FF01FF00
	dc.l	$009C8010	;009C8010
	dc.l	$FFFFFFFE	;FFFFFFFE
SpritePosition_00:	dc.w	$0000	;0000
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
adrEA009C94:	dc.w	$0000	;0000
	dc.w	$0000	;0000
SpritePosition_04:	dc.w	$0000	;0000
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
SpritePosition_01:	dc.w	$0000	;0000
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
SpritePosition_02:	dc.w	$0000	;0000
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

adrCd009D70:	move.l	#$007F0060,d4	;283C007F0060
	move.l	#$004B000C,d5	;2A3C004B000C
	add.w	$0008(a5),d5	;DA6D0008
	bra	adrCd00E538	;600047B6

adrCd009D84:	btst	#$06,$0018(a5)	;082D00060018
	bne.s	adrCd009DFC	;6670
	btst	#$02,(a5)	;08150002
	bne.s	adrCd009DFC	;666A
	move.b	$003D(a5),d3	;162D003D
	bpl.s	adrCd009D70	;6AD8
	move.b	$0053(a5),d0	;102D0053
	bmi.s	adrCd009E08	;6B6A
	bsr	adrCd0072D4	;6100D534
	link	a3,#-$0020	;4E53FFE0	;fix reqd for Devpac
	moveq	#$00,d0	;7000
	move.b	$001A(a4),d0	;102C001A
	move.w	d0,-$0004(a3)	;3740FFFC
	move.b	$001B(a4),d0	;102C001B
	move.w	d0,-$0002(a3)	;3740FFFE
	move.b	$001C(a4),d0	;102C001C
	and.w	#$0003,d0	;02400003
	move.w	d0,-$000A(a3)	;3740FFF6
	bsr.s	adrCd009DCC	;6106
	move.b	$001E(a4),d0	;102C001E
	bra.s	adrCd009E22	;6056

adrCd009DCC:	move.b	$0015(a4),d0	;102C0015
	and.w	#$0007,d0	;02400007
	subq.b	#$07,d0	;5F00
	beq.s	adrCd009DFE	;6726
	jsr	adrCd0009DA.l	;4EB9000009DA
	move.w	d1,d2	;3401
	moveq	#$00,d1	;7200
	not.w	d2	;4642
	and.w	#$0003,d2	;02420003
	bne.s	adrCd009DFC	;6612
	bsr	RandomGen_BytewithOffset	;6100C3F4
	move.b	(a4),d2	;1414
	asl.b	#$03,d2	;E702
	moveq	#$00,d1	;7200
	cmp.b	d0,d2	;B400
	bcs.s	adrCd009DFC	;6504
	move.b	(a4),d1	;1214
	add.w	d1,d1	;D241
adrCd009DFC:	rts	;4E75

adrCd009DFE:	move.b	$0015(a4),d1	;122C0015
	lsr.b	#$03,d1	;E609
	addq.b	#$01,d1	;5201
	rts	;4E75

adrCd009E08:	link	a3,#-$0020	;4E53FFE0	;fix reqd for Devpac
	move.l	$001C(a5),-$0004(a3)	;276D001CFFFC
	move.w	$0020(a5),-$000A(a3)	;376D0020FFF6
	bsr	adrCd0072D0	;6100D4B6
	bsr.s	adrCd009DCC	;61AE
	move.w	$0058(a5),d0	;302D0058
adrCd009E22:	move.w	d0,-$001E(a3)	;3740FFE2
	move.b	d1,-$001F(a3)	;1741FFE1
	bsr	adrCd0092AA	;6100F47E
	move.l	-$0004(a3),d7	;2E2BFFFC
	bsr	CoordToMap	;6100F438
	btst	#$05,$01(a6,d0.w)	;083600050001
	beq.s	adrCd009EA4	;6766
	bsr	adrCd006B70	;6100CD30
	move.w	$0002(a0),d1	;32280002
	move.w	d1,d0	;3001
	and.w	#$0003,d1	;02410003
	cmp.w	#$0002,d1	;0C410002
	bcc.s	adrCd009EA4	;6452
	and.w	#$00FC,d0	;024000FC
	cmp.w	#$002C,d0	;0C40002C
	bcc.s	adrCd009E62	;6406
	cmp.w	#$0020,d0	;0C400020
	bcc.s	adrCd009EA4	;6442
adrCd009E62:	lsr.w	#$01,d0	;E248
	add.w	d0,d1	;D240
	move.b	adrB_009E72(pc,d1.w),$003D(a5)	;1B7B100A003D
	unlk	a3	;4E5B
	bra	adrCd009D84	;6000FF14

adrB_009E72:	dc.b	$0E	;0E
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
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$0C	;0C
	dc.b	$0B	;0B
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$0B	;0B
	dc.b	$0A	;0A

adrCd009EA4:	move.l	screen_ptr.l,a0	;207900009B06
	lea	$01EC(a0),a0	;41E801EC
	add.w	$000A(a5),a0	;D0ED000A
	move.l	a0,-$0008(a3)	;2748FFF8
	move.w	-$0004(a3),d0	;302BFFFC
	add.w	-$0002(a3),d0	;D06BFFFE
	add.w	-$000A(a3),d0	;D06BFFF6
	and.w	#$0001,d0	;02400001
	move.w	d0,-$000C(a3)	;3740FFF4
	bsr	adrCd00C68A	;610027BE
	move.w	-$000A(a3),d0	;302BFFF6
	move.w	d0,d1	;3200
	ror.b	#$03,d0	;E618
	add.w	d1,d1	;D241
	add.w	d1,d0	;D041
	add.w	d1,d1	;D241
	add.w	d1,d0	;D041
	lea	adrEA00C744.l,a0	;41F90000C744
	add.w	d0,a0	;D0C0
	move.l	a0,-$0010(a3)	;2748FFF0
	move.l	adrW_00F9CC.l,d1	;22390000F9CC
	move.w	d1,d2	;3401
	swap	d1	;4841
	move.l	-$0004(a3),d3	;262BFFFC
	move.l	adrL_00F9D4.l,a6	;2C790000F9D4
	moveq	#$00,d6	;7C00
adrCd009F00:	lsr.l	#$01,d5	;E28D
	lsr.l	#$01,d4	;E28C
	move.l	d3,d7	;2E03
	add.b	$0001(a0),d7	;DE280001
	cmp.w	d2,d7	;BE42
	bcc	adrCd009F90	;64000082
	swap	d7	;4847
	add.b	(a0),d7	;DE10
	cmp.w	d1,d7	;BE41
	bcc.s	adrCd009F90	;6478
	swap	d7	;4847
	bsr	adrCd009272	;6100F356
	move.w	$00(a6,d0.w),d0	;30360000
	tst.b	d0	;4A00
	beq.s	adrCd009F94	;676E
	and.b	#$07,d0	;02000007
	beq.s	adrCd009F8C	;6760
	cmp.b	#$01,d0	;0C000001
	beq.s	adrCd009F90	;675E
	cmp.b	#$07,d0	;0C000007
	bne.s	adrCd009F4E	;6616
	lsr.w	#$08,d0	;E048
	and.w	#$0003,d0	;02400003
	cmp.b	#$02,d0	;0C000002
	bcs.s	adrCd009F8C	;6548
	bne.s	adrCd009F90	;664A
	tst.b	-$001F(a3)	;4A2BFFE1
	beq.s	adrCd009F90	;6744
	bra.s	adrCd009F8C	;603E

adrCd009F4E:	cmp.b	#$02,d0	;0C000002
	bne.s	adrCd009F8C	;6638
	move.w	-$000A(a3),d7	;3E2BFFF6
	cmp.w	#$0012,d6	;0C460012
	beq.s	adrCd009F64	;6706
	addq.w	#$02,d7	;5447
	and.w	#$0003,d7	;02470003
adrCd009F64:	add.w	d7,d7	;DE47
	addq.w	#$08,d7	;5047
	btst	d7,d0	;0F00
	beq.s	adrCd009F8C	;6720
	cmp.w	#$000E,d6	;0C46000E
	bcc.s	adrCd009F90	;641E
	move.w	-$000A(a3),d7	;3E2BFFF6
	addq.w	#$01,d7	;5247
	cmp.w	#$0007,d6	;0C460007
	bcs.s	adrCd009F80	;6502
	addq.w	#$02,d7	;5447
adrCd009F80:	and.w	#$0003,d7	;02470003
	add.w	d7,d7	;DE47
	addq.w	#$08,d7	;5047
	btst	d7,d0	;0F00
	bne.s	adrCd009F90	;6604
adrCd009F8C:	bset	#$1F,d4	;08C4001F
adrCd009F90:	bset	#$1F,d5	;08C5001F
adrCd009F94:	addq.w	#$02,a0	;5448
	addq.w	#$01,d6	;5246
	cmp.w	#$0013,d6	;0C460013
	bcs	adrCd009F00	;6500FF62
	rol.l	#$03,d5	;E79D
	swap	d5	;4845
	rol.l	#$03,d4	;E79C
	swap	d4	;4844
	lea	adrEA00C870.l,a6	;4DF90000C870
	lea	adrEA00C824.l,a4	;49F90000C824
	moveq	#$00,d7	;7E00
	moveq	#-$01,d0	;70FF
	moveq	#$12,d6	;7C12
adrLp009FBA:	btst	d6,d5	;0D05
	beq.s	adrCd009FC6	;6708
	or.l	(a6),d7	;8E96
	btst	d6,d4	;0D04
	bne.s	adrCd009FC6	;6602
	and.l	(a4),d0	;C094
adrCd009FC6:	subq.w	#$04,a6	;594E
	subq.w	#$04,a4	;594C
	dbra	d6,adrLp009FBA	;51CEFFEE
	and.l	d0,d7	;CE80
	moveq	#$00,d6	;7C00
adrCd009FD2:	btst	d6,d5	;0D05
	beq.s	adrCd009FE2	;670C
	movem.l	d5-d7,-(sp)	;48E70700
	bsr	adrCd009FEE	;61000012
	movem.l	(sp)+,d5-d7	;4CDF00E0
adrCd009FE2:	addq.w	#$01,d6	;5246
	cmp.b	#$13,d6	;0C060013
	bcs.s	adrCd009FD2	;65E8
	unlk	a3	;4E5B
	rts	;4E75

adrCd009FEE:	move.b	d6,-$0016(a3)	;1746FFEA
	move.l	-$0010(a3),a0	;206BFFF0
	add.w	d6,d6	;DC46
	add.w	d6,a0	;D0C6
	moveq	#$01,d1	;7201
	move.l	-$0004(a3),d5	;2A2BFFFC
	swap	d5	;4845
	add.b	(a0)+,d5	;DA18
	move.b	d5,-$0019(a3)	;1745FFE7
	cmp.w	adrW_00F9CC.l,d5	;BA790000F9CC
	beq.s	adrCd00A03C	;672C
	bcs.s	adrCd00A018	;6506
	addq.b	#$01,d5	;5205
	beq.s	adrCd00A03C	;6726
	rts	;4E75

adrCd00A018:	swap	d5	;4845
	add.b	(a0),d5	;DA10
	move.b	d5,-$001A(a3)	;1745FFE6
	cmp.w	adrW_00F9CE.l,d5	;BA790000F9CE
	beq.s	adrCd00A03C	;6714
	bcs.s	adrCd00A030	;6506
	addq.b	#$01,d5	;5205
	beq.s	adrCd00A03C	;670E
	rts	;4E75

adrCd00A030:	exg	d5,d7	;CB47
	bsr	CoordToMap	;6100F238
	exg	d5,d7	;CB47
	move.w	$00(a6,d0.w),d1	;32360000
adrCd00A03C:	clr.b	-$0013(a3)	;422BFFED
	move.w	d1,-$0012(a3)	;3741FFEE
	btst	#$06,d1	;08010006
	beq.s	adrCd00A056	;670C
	movem.l	d0/d1/d6/d7,-(sp)	;48E7C300
	bsr	adrCd00A3DA	;6100038A
	movem.l	(sp)+,d0/d1/d6/d7	;4CDF00C3
adrCd00A056:	btst	#$05,d1	;08010005
	beq	adrCd00A148	;670000EC
	move.w	d1,d2	;3401
	and.w	#$0007,d2	;02420007
	subq.w	#$01,d2	;5342
	beq	adrCd00A148	;670000E0
	move.w	d0,-(sp)	;3F00
	bsr	adrCd00A148	;610000DA
	move.w	(sp)+,d0	;301F
	bsr	adrCd006B70	;6100CAFC
	move.w	$0002(a0),d1	;32280002
	move.w	d1,d2	;3401
	and.w	#$0003,d2	;02420003
	cmp.w	#$0002,d2	;0C420002
	bne	adrCd00A0B8	;66000032
	lsr.b	#$02,d1	;E409
	add.w	#$0080,d1	;06410080
	move.b	d1,-$0017(a3)	;1741FFE9
	moveq	#$04,d1	;7204
	cmp.b	#$12,-$0016(a3)	;0C2B0012FFEA
	bne	adrCd00B53C	;660014A0
	subq.b	#$01,-$0016(a3)	;532BFFEA
	move.l	-$0004(a3),d7	;2E2BFFFC
	move.w	-$000A(a3),d0	;302BFFF6
	bsr	adrCd009254	;6100F1A8
	tst.b	$01(a6,d0.w)	;4A360001
	bmi	adrCd00B53C	;6B001488
	rts	;4E75

adrCd00A0B8:	and.w	#$00FC,d1	;024100FC
	cmp.w	#$001C,d1	;0C41001C
	bcc.s	adrCd00A128	;6466
	move.w	d1,-(sp)	;3F01
	bsr	adrCd00A69A	;610005D4
	move.w	(sp)+,d0	;301F
	addq.b	#$01,d1	;5201
	beq.s	adrCd00A128	;675A
	subq.b	#$01,d1	;5301
	move.b	adrB_00A12A(pc,d1.w),d1	;123B1058
	add.w	d1,d1	;D241
	lea	_GFX_AirbourneSpells.l,a1	;43F900031418
	add.w	adrW_00A130(pc,d1.w),a1	;D2FB1052
	add.w	d1,d1	;D241
	add.b	adrB_00A138(pc,d1.w),d4	;D83B1054
	add.b	adrB_00A139(pc,d1.w),d5	;DA3B1051
	moveq	#$00,d7	;7E00
	move.b	adrB_00A13A(pc,d1.w),d7	;1E3B104C
	swap	d7	;4847
	move.b	adrB_00A13B(pc,d1.w),d7	;1E3B1047
	add.w	$0008(a5),d5	;DA6D0008
	move.b	d4,d6	;1C04
	add.b	#$60,d4	;06040060
	ext.w	d6	;4886
	asr.w	#$04,d6	;E846
	move.w	#$FFFF,adrW_00C354.l	;33FCFFFF0000C354
	lea	adrEA00A8A6.l,a0	;41F90000A8A6
	move.l	$00(a0,d0.w),adrEA00C356.l	;23F000000000C356
	move.l	a3,-(sp)	;2F0B
	bsr	adrCd00BCF4	;61001BD6
	move.l	(sp)+,a3	;265F
	clr.w	adrW_00C354.l	;42790000C354
adrCd00A128:	rts	;4E75

adrB_00A12A:	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$03	;03
adrW_00A130:	dc.w	$0000	;0000
	dc.w	$0318	;0318
	dc.w	$0438	;0438
	dc.w	$0498	;0498
adrB_00A138:	dc.b	$F4	;F4
adrB_00A139:	dc.b	$F7	;F7
adrB_00A13A:	dc.b	$02	;02
adrB_00A13B:	dc.b	$20	;20
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

adrCd00A148:	and.w	#$0007,d1	;02410007
	bne.s	adrCd00A158	;660A
	tst.b	-$0011(a3)	;4A2BFFEF
	bmi	adrCd00A72E	;6B0005DA
	rts	;4E75

adrCd00A158:	lea	adrEA00C888.l,a6	;4DF90000C888
	add.w	d6,d6	;DC46
	add.w	d6,a6	;DCC6
	moveq	#$03,d5	;7A03
	subq.b	#$01,d1	;5301
	beq.s	adrLp00A192	;672A
	subq.b	#$01,d1	;5301
	beq.s	adrCd00A18C	;6720
	subq.b	#$01,d1	;5301
	beq	adrCd00A33A	;670001CA
	cmp.b	#$03,d1	;0C010003
	beq	adrCd00A2AC	;67000134
	cmp.b	#$04,d1	;0C010004
	beq	adrCd00A266	;670000E6
	move.b	d1,-$0013(a3)	;1741FFED
	addq.w	#$02,a6	;544E
	moveq	#$01,d5	;7A01
	bra.s	adrLp00A192	;6006

adrCd00A18C:	move.b	#$FF,-$0013(a3)	;177C00FFFFED
adrLp00A192:	moveq	#$00,d6	;7C00
	move.b	(a6)+,d6	;1C1E
	bmi.s	adrCd00A20A	;6B72
	btst	d6,d7	;0D07
	beq.s	adrCd00A20A	;676E
	clr.b	-$0014(a3)	;422BFFEC
	clr.b	-$0015(a3)	;422BFFEB
	bsr	adrCd00A3A4	;610001FE
	tst.b	-$0013(a3)	;4A2BFFED
	bmi.s	adrCd00A1B4	;6B06
	beq.s	adrCd00A210	;6760
	bra	adrCd00A252	;600000A0

adrCd00A1B4:	cmp.w	#$0002,d5	;0C450002
	bcc.s	adrCd00A1E2	;6428
	tst.w	d5	;4A45
	beq.s	adrCd00A1C8	;670A
	cmp.b	#$0E,-$0016(a3)	;0C2B000EFFEA
	bcc.s	adrCd00A1E2	;641C
	bra.s	adrCd00A1D0	;6008

adrCd00A1C8:	cmp.b	#$0E,-$0016(a3)	;0C2B000EFFEA
	bcs.s	adrCd00A1E2	;6512
adrCd00A1D0:	tst.b	-$0011(a3)	;4A2BFFEF
	bpl.s	adrCd00A1E2	;6A0C
	movem.l	d1/d5-d7/a6,-(sp)	;48E74702
	bsr	adrCd00A72E	;61000552
	movem.l	(sp)+,d1/d5-d7/a6	;4CDF40E2
adrCd00A1E2:	add.w	d1,d1	;D241
	move.b	-$0012(a3),d0	;102BFFEE
	lsr.w	d1,d0	;E268
	and.w	#$0003,d0	;02400003
	beq.s	adrCd00A20A	;671A
	subq.w	#$01,d0	;5340
	beq.s	adrCd00A1FE	;670A
	move.b	d0,-$0014(a3)	;1740FFEC
	subq.w	#$01,d0	;5340
	move.b	d0,-$0015(a3)	;1740FFEB
adrCd00A1FE:	movem.l	d5/a6,-(sp)	;48E70402
	bsr	adrCd00C26E	;6100206A
	movem.l	(sp)+,d5/a6	;4CDF4020
adrCd00A20A:	dbra	d5,adrLp00A192	;51CDFF86
	rts	;4E75

adrCd00A210:	move.b	-$0011(a3),d0	;102BFFEF
	bpl.s	adrCd00A244	;6A2E
	lsr.b	#$04,d0	;E808
	and.w	#$0003,d0	;02400003
	cmp.b	d0,d1	;B200
	bne.s	adrCd00A244	;6624
	move.b	-$0012(a3),d0	;102BFFEE
	move.b	#$FF,-$0015(a3)	;177C00FFFFEB
	and.w	#$0003,d0	;02400003
	beq.s	adrCd00A244	;6714
	subq.b	#$01,-$0015(a3)	;532BFFEB
	subq.w	#$01,d0	;5340
	beq.s	adrCd00A244	;670C
	subq.b	#$01,-$0015(a3)	;532BFFEB
	subq.w	#$01,d0	;5340
	beq.s	adrCd00A244	;6704
	subq.b	#$01,-$0015(a3)	;532BFFEB
adrCd00A244:	movem.l	d5/a6,-(sp)	;48E70402
	bsr	adrCd00BF0A	;61001CC0
	movem.l	(sp)+,d5/a6	;4CDF4020
	bra.s	adrCd00A20A	;60B8

adrCd00A252:	bsr	adrCd00A71A	;610004C6
	bmi	adrCd00C174	;6B001F1C
	btst	d1,d7	;0307
	beq	adrCd00C174	;67001F16
	move.w	d1,d6	;3C01
	bra	adrCd00C174	;60001F10

adrCd00A266:	move.b	-$0012(a3),d1	;122BFFEE
	and.w	#$0003,d1	;02410003
	beq.s	adrCd00A282	;6712
	cmp.w	#$0001,d1	;0C410001
	beq.s	adrCd00A28C	;6716
	cmp.b	#$03,d1	;0C010003
	beq.s	adrCd00A284	;6708
	tst.b	-$001F(a3)	;4A2BFFE1
	beq.s	adrCd00A284	;6702
adrCd00A282:	rts	;4E75

adrCd00A284:	lsr.w	#$01,d6	;E24E
	moveq	#$01,d1	;7201
	bra	adrCd00A03C	;6000FDB2

adrCd00A28C:	bsr	RandomGen_BytewithOffset	;6100BF52
	and.w	#$0004,d0	;02400004
	move.l	adrL_00A2A4(pc,d0.w),adrEA00C356.l	;23FB000E0000C356
	move.b	#$02,-$0012(a3)	;177C0002FFEE
	bra.s	adrCd00A2B6	;6012

adrL_00A2A4:	dc.l	$090C0B0D	;090C0B0D
	dc.l	$090A0B0D	;090A0B0D

adrCd00A2AC:	move.l	#$01050406,adrEA00C356.l	;23FC010504060000C356
adrCd00A2B6:	bsr	adrCd00A71A	;61000462
	cmp.w	#$0012,d0	;0C400012
	beq.s	adrCd00A2C8	;6708
	tst.b	d1	;4A01
	bmi.s	adrCd00A338	;6B74
	btst	d1,d7	;0307
	beq.s	adrCd00A338	;6770
adrCd00A2C8:	move.b	-$0012(a3),d1	;122BFFEE
	move.w	d0,d6	;3C00
	btst	#$02,d1	;08010002
	beq.s	adrCd00A2F2	;671E
	movem.l	d1/d6,-(sp)	;48E74200
	lea	_GFX_Pad.l,a1	;43F90002E950
	lea	adrEA00CDF8.l,a2	;45F90000CDF8
	lea	adrEA016AB4.l,a0	;41F900016AB4
	bsr	adrCd00A384	;61000098
	movem.l	(sp)+,d1/d6	;4CDF0042
adrCd00A2F2:	lea	adrEA016A9C.l,a0	;41F900016A9C
	lea	adrEA00CDAC.l,a2	;45F90000CDAC
	lea	_GFX_PitLow.l,a1	;43F90002E4C0
	and.w	#$0003,d1	;02410003
	beq.s	adrCd00A330	;6726
	cmp.w	#$0003,d1	;0C410003
	beq.s	adrCd00A330	;6720
	btst	#$00,d1	;08010000
	bne.s	adrCd00A32E	;6618
	lea	_GFX_PitHigh.l,a1	;43F90002E708
	move.w	#$FFFF,adrW_00C354.l	;33FCFFFF0000C354
	bsr.s	adrCd00A384	;615E
	clr.w	adrW_00C354.l	;42790000C354
	bra.s	adrCd00A330	;6002

adrCd00A32E:	bsr.s	adrCd00A384	;6154
adrCd00A330:	tst.b	-$0011(a3)	;4A2BFFEF
	bmi	adrCd00A72E	;6B0003F8
adrCd00A338:	rts	;4E75

adrCd00A33A:	bsr	adrCd00A71A	;610003DE
	bmi.s	adrCd00A36E	;6B2E
	btst	d1,d7	;0307
	beq.s	adrCd00A36E	;672A
	cmp.b	#$01,-$0012(a3)	;0C2B0001FFEE
	beq.s	adrCd00A370	;6724
	lea	adrEA01697A.l,a0	;41F90001697A
	lea	adrEA00CB34.l,a2	;45F90000CB34
	lea	_GFX_Bed.l,a1	;43F900025610
	move.w	d0,d6	;3C00
adrCd00A360:	bsr	adrCd00C31C	;61001FBA
	swap	d3	;4843
	move.l	a3,-(sp)	;2F0B
	bsr	adrCd00C460	;610020F6
	move.l	(sp)+,a3	;265F
adrCd00A36E:	rts	;4E75

adrCd00A370:	lea	adrEA016964.l,a0	;41F900016964
	lea	adrEA00CA9C.l,a2	;45F90000CA9C
	lea	_GFX_Pillar.l,a1	;43F900026088
	move.w	d0,d6	;3C00
adrCd00A384:	moveq	#$00,d0	;7000
	move.b	adrB_00A390(pc,d6.w),d0	;103B6008
	bpl.s	adrCd00A360	;6AD4
	bra	adrCd00C2C4	;60001F36

adrB_00A390:	dc.b	$00	;00
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

adrCd00A3A4:	move.w	d5,d1	;3205
	cmp.b	#$07,-$0016(a3)	;0C2B0007FFEA
	bcc.s	adrCd00A3BA	;640C
	btst	#$00,d1	;08010000
	bne.s	adrCd00A3CC	;6618
	eor.w	#$0001,d1	;0A410001
	bra.s	adrCd00A3D0	;6016

adrCd00A3BA:	cmp.b	#$0E,-$0016(a3)	;0C2B000EFFEA
	bcs.s	adrCd00A3CC	;650A
	btst	#$01,d1	;08010001
	bne.s	adrCd00A3CC	;6604
	eor.w	#$0001,d1	;0A410001
adrCd00A3CC:	eor.w	#$0003,d1	;0A410003
adrCd00A3D0:	add.w	-$000A(a3),d1	;D26BFFF6
	and.w	#$0003,d1	;02410003
	rts	;4E75

adrCd00A3DA:	tst.b	-$001F(a3)	;4A2BFFE1
	bne.s	adrCd00A3EA	;660A
	btst	#$03,$01(a6,d0.w)	;083600030001
	beq.s	adrCd00A3EA	;6702
	rts	;4E75

adrCd00A3EA:	move.w	d1,d2	;3401
	and.w	#$0007,d2	;02420007
	cmp.w	#$0006,d2	;0C420006
	beq.s	adrCd00A40A	;6714
	subq.w	#$01,d2	;5342
	bne.s	adrCd00A418	;661E
	lsr.w	#$04,d1	;E849
	and.w	#$0003,d1	;02410003
	eor.w	#$0002,d1	;0A410002
	cmp.w	-$000A(a3),d1	;B26BFFF6
	bne.s	adrCd00A450	;6646
adrCd00A40A:	addq.w	#$04,sp	;584F
	movem.l	(sp),d0/d1/d6/d7	;4CD700C3
	bsr	adrCd00A056	;6100FC44
	movem.l	(sp)+,d0/d1/d6/d7	;4CDF00C3
adrCd00A418:	moveq	#$00,d1	;7200
adrCd00A41A:	move.w	d1,-(sp)	;3F01
	move.w	d1,d6	;3C01
	bsr	adrCd006B50	;6100C730
	bsr	adrCd006B7E	;6100C75A
	bne.s	adrCd00A446	;661E
	rol.b	#$02,d6	;E51E
	lea	$02(a0,d7.w),a0	;41F07002
	moveq	#$00,d7	;7E00
	move.b	(a0)+,d7	;1E18
adrLp00A432:	movem.l	d0/d6/d7/a0/a3,-(sp)	;48E78390
	moveq	#$00,d2	;7400
	move.b	(a0),d2	;1410
	bsr.s	adrCd00A48E	;6152
	movem.l	(sp)+,d0/d6/d7/a0/a3	;4CDF09C1
	addq.w	#$02,a0	;5448
	dbra	d7,adrLp00A432	;51CFFFEE
adrCd00A446:	move.w	(sp)+,d1	;321F
	addq.w	#$01,d1	;5241
	cmp.w	#$0004,d1	;0C410004
	bcs.s	adrCd00A41A	;65CA
adrCd00A450:	rts	;4E75

adrB_00A452:	dc.b	$00	;00
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
adrB_00A462:	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$00	;00
adrB_00A466:	dc.b	$FF	;FF
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
adrB_00A479:	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$04	;04
adrB_00A481:	dc.b	$4F	;4F
	dc.b	$47	;47
	dc.b	$41	;41
	dc.b	$3D	;3D
	dc.b	$38	;38
adrB_00A486:	dc.b	$1D	;1D
	dc.b	$10	;10
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$12	;12
	dc.b	$0A	;0A
	dc.b	$0E	;0E
	dc.b	$08	;08

adrCd00A48E:	move.w	-$000A(a3),d0	;302BFFF6
	add.w	d0,d0	;D040
	add.w	d0,d0	;D040
	add.w	d6,d0	;D046
	move.b	adrB_00A452(pc,d0.w),d6	;1C3B00B8
	moveq	#$00,d1	;7200
	move.b	-$0016(a3),d1	;122BFFEA
	move.b	adrB_00A466(pc,d1.w),d0	;103B10C2
	bmi.s	adrCd00A450	;6BA8
	add.b	adrB_00A462(pc,d6.w),d0	;D03B60B8
	move.b	adrB_00A479(pc,d0.w),d0	;103B00CB
	bmi.s	adrCd00A450	;6B9E
	asl.w	#$02,d1	;E541
	add.w	d6,d1	;D246
	moveq	#$00,d5	;7A00
	moveq	#$00,d4	;7800
	move.b	adrB_00A481(pc,d0.w),d5	;1A3B00C5
	add.w	$0008(a5),d5	;DA6D0008
	lea	adrEA00A58C.l,a0	;41F90000A58C
	move.b	$00(a0,d1.w),d4	;18301000
	move.w	-$0012(a3),d3	;362BFFEE
	and.w	#$0007,d3	;02430007
	subq.w	#$01,d3	;5343
	bne.s	adrCd00A4F2	;661A
	subq.w	#$04,d6	;5946
	move.w	d0,d3	;3600
	add.w	d3,d3	;D643
	add.w	d6,d3	;D646
	sub.b	adrB_00A486(pc,d3.w),d5	;9A3B30A4
	lea	adrEA00A5D8.l,a0	;41F90000A5D8
	move.b	-$0016(a3),d3	;162BFFEA
	move.b	$00(a0,d3.w),d4	;18303000
adrCd00A4F2:	cmp.b	#$80,d4	;0C040080
	beq	adrCd00A450	;6700FF58
	lea	ObjectColourSets.l,a6	;4DF90000F1F8
	moveq	#$00,d3	;7600
	move.b	$00(a6,d2.w),d3	;16362000
	asl.w	#$02,d3	;E543
	lea	FloorObjectPalettes.l,a6	;4DF90000F266
	move.l	$00(a6,d3.w),adrEA00C356.l	;23F630000000C356
	lea	ObjectFloorShapeTable.l,a0	;41F90000F102
	move.b	$00(a0,d2.w),d3	;16302000
	move.w	d3,d6	;3C03
	asl.w	#$02,d6	;E546
	add.w	d3,d6	;DC43
	add.w	d0,d6	;DC40
	add.w	d6,d6	;DC46
	lea	FloorObjectGraphicOffsets.l,a0	;41F90000F326
	lea	_GFX_ObjectsOnFloor.l,a1	;43F90002F948
	add.w	$00(a0,d6.w),a1	;D2F06000
	cmp.b	#$12,d3	;0C030012
	bcs.s	adrCd00A544	;6504
	add.w	#$0CB8,a1	;D2FC0CB8
adrCd00A544:	moveq	#$00,d7	;7E00
	cmp.b	#$12,d3	;0C030012
	bcs.s	adrCd00A550	;6504
	move.b	adrB_00A586(pc,d0.w),d7	;1E3B0038
adrCd00A550:	swap	d7	;4847
	lsr.w	#$01,d6	;E24E
	lea	FloorObjectShapeHeights.l,a0	;41F90000F170
	move.b	$00(a0,d6.w),d7	;1E306000
	lea	adrEA00A5EC.l,a0	;41F90000A5EC
	add.b	$00(a0,d6.w),d5	;DA306000
	move.b	d4,d6	;1C04
	add.b	#$60,d4	;06040060
	ext.w	d6	;4886
	asr.w	#$04,d6	;E846
	move.w	#$FFFF,adrW_00C354.l	;33FCFFFF0000C354
	bsr	adrCd00BCF4	;61001778
	clr.w	adrW_00C354.l	;42790000C354
	rts	;4E75

adrB_00A586:	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
adrEA00A58C:	dc.w	$8080	;8080
	dc.w	$8080	;8080
	dc.w	$8080	;8080
	dc.w	$8080	;8080
	dc.w	$8080	;8080
	dc.w	$8080	;8080
	dc.w	$0115	;0115
	dc.w	$0115	;0115
	dc.w	$8008	;8008
	dc.w	$8008	;8008
	dc.w	$80FD	;80FD
	dc.w	$80EC	;80EC
	dc.w	$8080	;8080
	dc.w	$8080	;8080
	dc.w	$8080	;8080
	dc.w	$8080	;8080
	dc.w	$8080	;8080
	dc.w	$8080	;8080
	dc.w	$8080	;8080
	dc.w	$8080	;8080
	dc.w	$5D71	;5D71
	dc.w	$5D71	;5D71
	dc.w	$6780	;6780
	dc.w	$6780	;6780
	dc.w	$6980	;6980
	dc.w	$7880	;7880
	dc.w	$8080	;8080
	dc.w	$8080	;8080
	dc.w	$8080	;8080
	dc.w	$8080	;8080
	dc.w	$2F43	;2F43
	dc.w	$2F43	;2F43
	dc.w	$2946	;2946
	dc.w	$2946	;2946
	dc.w	$2247	;2247
	dc.w	$1C49	;1C49
	dc.w	$164C	;164C
	dc.w	$8080	;8080
adrEA00A5D8:	dc.w	$8080	;8080
	dc.w	$800C	;800C
	dc.w	$FC80	;FC80
	dc.w	$8080	;8080
	dc.w	$8080	;8080
	dc.w	$6672	;6672
	dc.w	$8080	;8080
	dc.w	$8039	;8039
	dc.w	$3734	;3734
	dc.w	$8000	;8000
adrEA00A5EC:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0103	;0103
	dc.w	$0202	;0202
	dc.w	$0101	;0101
	dc.w	$0403	;0403
	dc.w	$0302	;0302
	dc.w	$0101	;0101
	dc.w	$0001	;0001
	dc.w	$0101	;0101
	dc.w	$0302	;0302
	dc.w	$0302	;0302
	dc.w	$0103	;0103
	dc.w	$0202	;0202
	dc.w	$0101	;0101
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0003	;0003
	dc.w	$0202	;0202
	dc.w	$0101	;0101
	dc.w	$0503	;0503
	dc.w	$0302	;0302
	dc.w	$0100	;0100
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0100	;0100
	dc.w	$0101	;0101
	dc.w	$0100	;0100
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$0303	;0303
	dc.w	$0302	;0302
	dc.w	$0003	;0003
	dc.w	$0202	;0202
	dc.w	$0101	;0101
	dc.w	$0101	;0101
	dc.w	$0101	;0101
	dc.w	$0103	;0103
	dc.w	$0202	;0202
	dc.w	$0201	;0201
	dc.w	$0101	;0101
	dc.w	$0101	;0101
	dc.w	$0102	;0102
	dc.w	$0201	;0201
	dc.w	$0101	;0101
	dc.w	$0301	;0301
	dc.w	$0200	;0200
	dc.w	$0103	;0103
	dc.w	$0102	;0102
	dc.w	$0001	;0001
	dc.w	$0100	;0100
	dc.w	$0100	;0100
	dc.w	$0104	;0104
	dc.w	$0202	;0202
	dc.w	$0101	;0101
	dc.w	$0503	;0503
	dc.w	$0302	;0302
	dc.w	$0105	;0105
	dc.w	$0303	;0303
	dc.w	$0201	;0201
	dc.w	$0402	;0402
	dc.w	$0201	;0201
	dc.w	$0100	;0100
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0202	;0202
	dc.w	$0200	;0200
	dc.w	$0100	;0100
adrB_00A674:	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$00	;00
adrB_00A679:	dc.b	$06	;06
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
adrB_00A68C:	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$04	;04
	dc.b	$05	;05
	dc.b	$05	;05
adrB_00A694:	dc.b	$27	;27
	dc.b	$25	;25
	dc.b	$24	;24
	dc.b	$24	;24

	move.b	(a2)+,d4	;181A
adrCd00A69A:	moveq	#$04,d1	;7204
adrCd00A69C:	move.w	d1,d2	;3401
	move.w	#$004B,adrW_00BBFA.l	;33FC004B0000BBFA
	moveq	#$00,d0	;7000
	moveq	#$00,d4	;7800
	move.b	-$0016(a3),d0	;102BFFEA
	move.b	adrB_00A679(pc,d0.w),d1	;123B00C9
	bmi.s	adrCd00A704	;6B50
	add.b	adrB_00A674(pc,d2.w),d1	;D23B20BE
	move.w	d0,d5	;3A00
	asl.w	#$02,d0	;E540
	add.w	d5,d0	;D045
	add.w	d2,d0	;D042
	move.w	d1,d2	;3401
	lea	adrEA0168D2.l,a0	;41F9000168D2
	move.b	$00(a0,d0.w),d4	;18300000
	cmp.b	#$FF,d4	;0C0400FF
	beq.s	adrCd00A706	;6734
	move.b	adrB_00A68C(pc,d2.w),d1	;123B20B8
	move.b	adrB_00A694(pc,d1.w),d5	;1A3B10BC
	move.w	-$0012(a3),d0	;302BFFEE
	and.w	#$0007,d0	;02400007
	cmp.w	#$0004,d0	;0C400004
	bne.s	adrCd00A704	;661C
	move.b	adrB_00A70A(pc,d2.w),d0	;103B2020
	move.b	adrB_00A712(pc,d2.w),d2	;143B2024
	btst	#$00,-$0012(a3)	;082B0000FFEE
	bne.s	adrCd00A6FC	;6604
	neg.b	d0	;4400
	moveq	#$4B,d2	;744B
adrCd00A6FC:	add.b	d0,d5	;DA00
	move.w	d2,adrW_00BBFA.l	;33C20000BBFA
adrCd00A704:	rts	;4E75

adrCd00A706:	moveq	#-$01,d1	;72FF
	rts	;4E75

adrB_00A70A:	dc.b	$00	;00
	dc.b	$08	;08
	dc.b	$00	;00
	dc.b	$06	;06
	dc.b	$00	;00
	dc.b	$06	;06
	dc.b	$00	;00
	dc.b	$00	;00
adrB_00A712:	dc.b	$4B	;4B
	dc.b	$3E	;3E
	dc.b	$4B	;4B
	dc.b	$34	;34
	dc.b	$4B	;4B
	dc.b	$2E	;2E
	dc.b	$4B	;4B
	dc.b	$4B	;4B

adrCd00A71A:	moveq	#$00,d0	;7000
	moveq	#$00,d1	;7200
	lea	adrEA00C874.l,a0	;41F90000C874
	move.b	-$0016(a3),d0	;102BFFEA
	move.b	$00(a0,d0.w),d1	;12300000
adrCd00A72C:	rts	;4E75

adrCd00A72E:	bsr.s	adrCd00A71A	;61EA
	bmi.s	adrCd00A72C	;6BFA
	btst	d1,d7	;0307
	beq.s	adrCd00A72C	;67F6
	moveq	#$00,d2	;7400
	move.b	-$0019(a3),d2	;142BFFE7
	swap	d2	;4842
	move.b	-$001A(a3),d2	;142BFFE6
	move.w	-$001E(a3),d1	;322BFFE2
	bsr	adrCd0087BE	;6100E076
	bcc.s	adrCd00A72C	;64E0
	tst.b	d0	;4A00
	bmi	adrCd00A830	;6B0000E0
	cmp.w	#$0010,d0	;0C400010
	bcc.s	adrCd00A768	;6410
	move.b	d0,-$0017(a3)	;1740FFE9
	move.b	$001F(a1),d0	;1029001F
	move.b	$001C(a1),d1	;1229001C
	bra	adrCd00A7F0	;6000008A

adrCd00A768:	moveq	#$00,d0	;7000
	move.b	$000D(a1),d0	;1029000D
	bmi.s	adrCd00A7C0	;6B50
	move.b	$0002(a1),d2	;14290002
	and.w	#$0003,d2	;02420003
	asl.w	#$02,d0	;E540
	lea	adrEA0156F8.l,a1	;43F9000156F8
	add.w	d0,a1	;D2C0
	moveq	#$03,d1	;7203
adrLp00A784:	move.w	d1,d3	;3601
	addq.w	#$02,d3	;5443
	add.w	-$000A(a3),d3	;D66BFFF6
	sub.w	d2,d3	;9642
	and.w	#$0003,d3	;02430003
	moveq	#$00,d0	;7000
	move.b	$00(a1,d3.w),d0	;10313000
	bmi.s	adrCd00A7BA	;6B20
	movem.l	d1/d2/a1,-(sp)	;48E76040
	asl.w	#$04,d0	;E940
	lea	UnpackedMonsters.l,a1	;43F900014EE6
	add.w	d0,a1	;D2C0
	add.w	d2,d3	;D642
	and.w	#$0003,d3	;02430003
	asl.w	#$04,d3	;E943
	or.b	d2,d3	;8602
	move.w	d3,d1	;3203
	bsr.s	adrCd00A7C4	;610E
	movem.l	(sp)+,d1/d2/a1	;4CDF0206
adrCd00A7BA:	dbra	d1,adrLp00A784	;51C9FFC8
	rts	;4E75

adrCd00A7C0:	move.b	$0002(a1),d1	;12290002
adrCd00A7C4:	move.b	$000B(a1),-$0017(a3)	;1769000BFFE9
	cmp.b	#$1A,-$0017(a3)	;0C2B001AFFE9
	bne.s	adrCd00A7E6	;6614
	move.w	d1,d3	;3601
	bsr	RandomGen_BytewithOffset	;6100BA0A
	move.w	d3,d1	;3203
	and.w	#$0001,d0	;02400001
	add.w	#$001A,d0	;0640001A
	move.b	d0,-$0017(a3)	;1740FFE9
adrCd00A7E6:	move.b	$0005(a1),d0	;10290005
	move.b	$0006(a1),-$0018(a3)	;17690006FFE8
adrCd00A7F0:	bsr	adrCd00A90A	;61000118
	move.b	d1,d2	;1401
	and.b	#$03,d2	;02020003
	move.b	d2,-$001B(a3)	;1742FFE5
	lsr.b	#$04,d1	;E809
	subq.w	#$02,d1	;5541
	sub.w	-$000A(a3),d1	;926BFFF6
	and.w	#$0003,d1	;02410003
	cmp.b	#$15,-$0017(a3)	;0C2B0015FFE9
	beq.s	adrCd00A82A	;6718
	cmp.b	#$16,-$0017(a3)	;0C2B0016FFE9
	beq.s	adrCd00A82A	;6710
	cmp.b	#$67,-$0017(a3)	;0C2B0067FFE9
	bcc.s	adrCd00A82A	;6408
	tst.b	-$0017(a3)	;4A2BFFE9
	bpl	adrCd00B53C	;6A000D14
adrCd00A82A:	moveq	#$04,d1	;7204
	bra	adrCd00B53C	;60000D0E

adrCd00A830:	move.b	$0021(a1),-$001B(a3)	;17690021FFE5
	move.l	a5,-(sp)	;2F0D
	move.l	a1,a5	;2A49
	moveq	#$03,d1	;7203
	bsr	adrCd006128	;6100B8EA
	move.l	(sp)+,a5	;2A5F
	tst.w	d3	;4A43
	bmi.s	adrCd00A850	;6B0A
	move.b	-$001F(a3),d2	;142BFFE1
	cmp.b	d2,d3	;B602
	bcs.s	adrCd00A850	;6502
	rts	;4E75

adrCd00A850:	moveq	#$04,d1	;7204
	moveq	#$02,d0	;7002
	moveq	#$00,d2	;7400
adrLp00A856:	tst.b	$27(a1,d0.w)	;4A310027
	bmi.s	adrCd00A85E	;6B02
	addq.w	#$01,d2	;5242
adrCd00A85E:	dbra	d0,adrLp00A856	;51C8FFF6
	move.w	$0006(a1),d0	;30290006
	tst.w	d2	;4A42
	beq	adrCd00A894	;6700002A
	moveq	#$03,d1	;7203
adrLp00A86E:	moveq	#$02,d0	;7002
	sub.w	$0020(a1),d0	;90690020
	add.w	-$000A(a3),d0	;D06BFFF6
	add.w	d1,d0	;D041
	and.w	#$0003,d0	;02400003
	move.b	$26(a1,d0.w),d0	;10310026
	bmi.s	adrCd00A88E	;6B0A
	movem.l	d1/a1,-(sp)	;48E74040
	bsr.s	adrCd00A894	;610A
	movem.l	(sp)+,d1/a1	;4CDF0202
adrCd00A88E:	dbra	d1,adrLp00A86E	;51C9FFDE
	rts	;4E75

adrCd00A894:	move.b	d0,-$0017(a3)	;1740FFE9
	bsr	adrCd0072D4	;6100CA3A
	move.b	$001F(a4),d0	;102C001F
	bsr.s	adrCd00A90A	;6168
	bra	adrCd00B53C	;60000C98

adrEA00A8A6:	dc.w	$090D	;090D
	dc.w	$0B0C	;0B0C
	dc.w	$0206	;0206
	dc.w	$0807	;0807
	dc.w	$020D	;020D
	dc.w	$0605	;0605
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$090C	;090C
	dc.w	$0B0D	;0B0D
	dc.w	$090D	;090D
	dc.w	$0B0C	;0B0C
	dc.w	$0B0E	;0B0E
	dc.w	$0D0B	;0D0B
	dc.w	$090C	;090C
	dc.w	$0B0D	;0B0D
	dc.w	$090A	;090A
	dc.w	$0A0B	;0A0B
	dc.w	$0102	;0102
	dc.w	$0506	;0506
	dc.w	$0C0B	;0C0B
	dc.w	$0D0E	;0D0E
	dc.w	$0708	;0708
	dc.w	$060D	;060D
	dc.w	$0105	;0105
	dc.w	$060D	;060D
	dc.w	$0702	;0702
	dc.w	$0804	;0804
	dc.w	$0A0B	;0A0B
	dc.w	$0D0D	;0D0D
	dc.w	$0B0D	;0B0D
	dc.w	$0D0E	;0D0E
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$090C	;090C
	dc.w	$0B0D	;0B0D
	dc.w	$0506	;0506
	dc.w	$060D	;060D
	dc.w	$0708	;0708
	dc.w	$060D	;060D
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0D0B	;0D0B
	dc.w	$0C09	;0C09
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$090D	;090D
	dc.w	$0B0A	;0B0A

adrCd00A90A:	and.w	#$001F,d0	;0240001F
	move.b	adrB_00A916(pc,d0.w),-$0015(a3)	;177B0006FFEB
	rts	;4E75

adrB_00A916:	dc.b	$00	;00
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
adrW_00A936:	dc.w	$0000	;0000

adrCd00A938:	lea	beholder.colours.l,a0	;41F90000AFA2
	moveq	#$00,d3	;7600
	and.b	#$07,-$0018(a3)	;022B0007FFE8
	bsr	adrCd00ACAA	;61000362
	move.w	adrW_00A936.l,d0	;30390000A936
	and.w	#$0003,d0	;02400003
	move.b	adrB_00A9C4(pc,d0.w),d0	;103B006E
	bsr.s	adrCd00A97E	;6124
	addq.b	#$02,-$0018(a3)	;542BFFE8
	and.b	#$07,-$0018(a3)	;022B0007FFE8
	moveq	#$00,d3	;7600
	lea	beholder.colours.l,a0	;41F90000AFA2
	bsr	adrCd00ACAA	;6100033C
	move.w	adrW_00A936.l,d0	;30390000A936
	and.w	#$0003,d0	;02400003
	move.b	adrB_00A9C8(pc,d0.w),d0	;103B004C
adrCd00A97E:	move.b	-$001B(a3),d1	;122BFFE5
	sub.b	-$0009(a3),d1	;922BFFF7
	add.b	d0,d1	;D200
	and.w	#$0003,d1	;02410003
	move.w	d0,-(sp)	;3F00
	bsr	adrCd00A69C	;6100FD0C
	move.w	(sp)+,d0	;301F
	tst.w	d1	;4A41
	bmi.s	adrCd00A9C2	;6B2A
	moveq	#$00,d7	;7E00
	moveq	#$00,d2	;7400
	tst.b	d0	;4A00
	bpl.s	adrCd00A9A2	;6A02
	moveq	#$06,d2	;7406
adrCd00A9A2:	move.b	adrB_00A9CC(pc,d1.w),d7	;1E3B1028
	add.b	adrB_00A9D2(pc,d1.w),d4	;D83B102A
	add.b	d1,d2	;D401
	add.b	adrB_00A9D8(pc,d2.w),d5	;DA3B202A
	move.w	d1,d2	;3401
	add.w	d2,d2	;D442
	lea	_GFX_AirbourneBall.l,a1	;43F900031BB0
	add.w	adrW_00A9E4(pc,d2.w),a1	;D2FB2028
	bra	adrCd00B0DE	;6000071E

adrCd00A9C2:	rts	;4E75

adrB_00A9C4:	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$83	;83
	dc.b	$80	;80
adrB_00A9C8:	dc.b	$82	;82
	dc.b	$81	;81
	dc.b	$01	;01
	dc.b	$02	;02
adrB_00A9CC:	dc.b	$14	;14
	dc.b	$10	;10
	dc.b	$0C	;0C
	dc.b	$0A	;0A
	dc.b	$08	;08
	dc.b	$06	;06
adrB_00A9D2:	dc.b	$FD	;FD
	dc.b	$FE	;FE
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
adrB_00A9D8:	dc.b	$F2	;F2
	dc.b	$F4	;F4
	dc.b	$F6	;F6
	dc.b	$F6	;F6
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$F8	;F8
	dc.b	$FA	;FA
	dc.b	$FB	;FB
	dc.b	$FB	;FB
	dc.b	$05	;05
	dc.b	$04	;04
adrW_00A9E4:	dc.w	$0000	;0000
	dc.w	$00A8	;00A8
	dc.w	$0130	;0130
	dc.w	$0198	;0198
	dc.w	$01F0	;01F0
	dc.w	$0238	;0238

DrawSpells:	cmp.b	#$94,d0	;0C000094
	beq	adrCd00A938	;6700FF42
	cmp.b	#$95,d0	;0C000095
	beq	adrCd00A938	;6700FF3A
	lea	adrEA00AA7E.l,a1	;43F90000AA7E
	move.b	$00(a1,d1.w),d1	;12311000
	add.w	d1,d1	;D241
	lea	_GFX_FireBall.l,a1	;43F900031160
	lea	adrEA00AA84.l,a2	;45F90000AA84
	cmp.b	#$86,d0	;0C000086
	bcs.s	adrCd00AA2E	;6510
	cmp.b	#$98,d0	;0C000098
	beq.s	adrCd00AA2E	;670A
	add.w	#$0798,a1	;D2FC0798
	lea	adrEA00AA9C.l,a2	;45F90000AA9C
adrCd00AA2E:	add.w	$00(a2,d1.w),a1	;D2F21000
	add.w	d1,d1	;D241
	add.b	$08(a2,d1.w),d4	;D8321008
	add.b	$09(a2,d1.w),d5	;DA321009
	moveq	#$00,d7	;7E00
	move.b	$0A(a2,d1.w),d7	;1E32100A
	swap	d7	;4847
	move.b	$0B(a2,d1.w),d7	;1E32100B
	add.w	$0008(a5),d5	;DA6D0008
	move.b	d4,d6	;1C04
	add.b	#$60,d4	;06040060
	ext.w	d6	;4886
	asr.w	#$04,d6	;E846
	move.l	a3,-(sp)	;2F0B
	move.w	#$FFFF,adrW_00C354.l	;33FCFFFF0000C354
	lea	adrEA00A8A6.l,a0	;41F90000A8A6
	asl.b	#$02,d0	;E500
	move.l	$00(a0,d0.w),adrEA00C356.l	;23F000000000C356
	bsr	adrCd00BCF4	;61001282
	clr.w	adrW_00C354.l	;42790000C354
	move.l	(sp)+,a3	;265F
	rts	;4E75

adrEA00AA7E:
	dc.w	$0000	;0000
	dc.w	$0101	;0101
	dc.w	$0203	;0203
adrEA00AA84:
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

adrEA00AA9C:
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

adrB_00AAB4:
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$81	;81

adrCd00AAB8:
	move.w	d1,d2	;3401
	add.w	d2,d2	;D442
	add.w	d1,d2	;D441
	moveq	#$00,d6	;7C00
	move.b	adrB_00AAB4(pc,d0.w),d3	;163B00F2
	bpl.s	adrCd00AAC8	;6A02
	moveq	#-$01,d6	;7CFF
adrCd00AAC8:	and.w	#$007F,d3	;0243007F
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
	lea	adrEA00ACD6.l,a2	;45F90000ACD6
	lea	adrEA00ABD6.l,a0	;41F90000ABD6
	lea	_GFX_Summon.l,a1	;43F900041DC8
	bsr.s	adrCd00AAB8	;61BC
	lea	illusion.colours.l,a6	;4DF90000AC72
	tst.b	-$0018(a3)	;4A2BFFE8
	bmi.s	adrCd00AB14	;6B0C
	lea	summons.colours.l,a0	;41F90000ABCE
	moveq	#$0C,d3	;760C
	bsr	adrCd00ACAA	;61000198
adrCd00AB14:	movem.w	d0/d1/d4/d5/d7,-(sp)	;48A7CD00
	move.l	a1,-(sp)	;2F09
	bsr	adrCd00BBCA	;610010AE
	move.l	(sp)+,a1	;225F
	movem.w	(sp)+,d0/d1/d4/d5/d7	;4C9F00B3
	addq.b	#$03,d4	;5604
	tst.w	d1	;4A41
	bne.s	adrCd00AB3E	;6614
	btst	#$00,d0	;08000000
	bne.s	adrCd00AB3E	;660E
	moveq	#-$01,d6	;7CFF
	movem.w	d0/d1/d4/d5,-(sp)	;48A7CC00
	bsr	adrCd00BBCA	;61001092
	movem.w	(sp)+,d0/d1/d4/d5	;4C9F0033
adrCd00AB3E:	cmp.w	#$0004,d1	;0C410004
	bcc	adrCd00ABCC	;64000088
	lea	adrEA00ABF2.l,a2	;45F90000ABF2
	movem.w	d0/d1/d4/d5,-(sp)	;48A7CC00
	moveq	#$00,d6	;7C00
	moveq	#$00,d2	;7400
	bsr	adrCd00AB66	;61000010
	movem.w	(sp)+,d0/d1/d4/d5	;4C9F0033
	lea	adrEA00AC12.l,a2	;45F90000AC12
	moveq	#-$01,d6	;7CFF
	moveq	#$01,d2	;7401
adrCd00AB66:	lea	adrEA00ABE2.l,a0	;41F90000ABE2
	move.b	$00(a0,d0.w),d3	;16300000
	bpl.s	adrCd00AB74	;6A02
	not.w	d6	;4646
adrCd00AB74:	and.w	#$007F,d3	;0243007F
	btst	d2,-$0015(a3)	;052BFFEB
	beq.s	adrCd00AB80	;6702
	moveq	#$02,d3	;7602
adrCd00AB80:	move.w	d1,d2	;3401
	add.w	d2,d2	;D442
	add.w	d1,d2	;D441
	add.w	d3,d2	;D443
	moveq	#$00,d7	;7E00
	lea	adrEA00ABE6.l,a0	;41F90000ABE6
	move.b	$00(a0,d2.w),d7	;1E302000
	add.w	d2,d2	;D442
	lea	adrEA00ACFA.l,a0	;41F90000ACFA
	lea	_GFX_Summon.l,a1	;43F900041DC8
	add.w	$00(a0,d2.w),a1	;D2F02000
	move.w	d1,d2	;3401
	asl.w	#$02,d2	;E542
	add.w	d0,d2	;D440
	add.w	d2,d2	;D442
	cmp.b	#$02,d3	;0C030002
	bne.s	adrCd00ABB8	;6604
	add.w	#$0040,a2	;D4FC0040
adrCd00ABB8:	cmp.w	#$FFFF,$00(a2,d2.w)	;0C72FFFF2000
	beq.s	adrCd00ABCC	;670C
	sub.b	$00(a2,d2.w),d4	;98322000
	sub.b	$01(a2,d2.w),d5	;9A322001
	bra	adrCd00BBCA	;60001000

adrCd00ABCC:	rts	;4E75

summons.colours:	dc.w	$0001	;0001
	dc.w	$0203	;0203
	dc.w	$0405	;0405
	dc.w	$0607	;0607
adrEA00ABD6:	dc.w	$1511	;1511
	dc.w	$0D0C	;0D0C
	dc.w	$FE00	;FE00
	dc.w	$2E26	;2E26
	dc.w	$1F1A	;1F1A
	dc.w	$1510	;1510
adrEA00ABE2:	dc.w	$0001	;0001
	dc.w	$8001	;8001
adrEA00ABE6:	dc.w	$1414	;1414
	dc.w	$1010	;1010
	dc.w	$100B	;100B
	dc.w	$0C0C	;0C0C
	dc.w	$0A0B	;0A0B
	dc.w	$0B08	;0B08
adrEA00ABF2:	dc.w	$09F9	;09F9
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
adrEA00AC12:	dc.w	$FAF9	;FAF9
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
illusion.colours:	dc.w	$0000	;0000
	dc.w	$0708	;0708
monsters.colours:	dc.w	$0003	;0003
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

adrCd00ACAA:	moveq	#$00,d2	;7400
	move.b	-$0018(a3),d2	;142BFFE8
	sub.b	d3,d2	;9403
	bcc.s	adrCd00ACB6	;6402
	moveq	#$00,d2	;7400
adrCd00ACB6:	lsr.w	#$01,d2	;E24A
	cmp.b	#$08,d2	;0C020008
	bcs.s	adrCd00ACC0	;6502
	moveq	#$07,d2	;7407
adrCd00ACC0:	move.b	$00(a0,d2.w),d2	;14302000
	asl.w	#$02,d2	;E542
	lea	monsters.colours.l,a6	;4DF90000AC76
	add.w	d2,a6	;DCC2
	move.l	(a6),adrEA00C356.l	;23D60000C356
	rts	;4E75

adrEA00ACD6:	dc.w	$0000	;0000
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
adrEA00ACFA:	dc.w	$1140	;1140
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

Draw_Crab:	move.w	#$FFFF,adrW_00C354.l	;33FCFFFF0000C354
	lea	crab.colours.l,a0	;41F90000AD38
	moveq	#$0C,d3	;760C
	bsr.s	adrCd00ACAA	;6186
	bsr	adrCd00AF1E	;610001F8
	lea	adrEA00C356.l,a6	;4DF90000C356
	bsr.s	adrCd00AD40	;6110
	clr.w	adrW_00C354.l	;42790000C354
	rts	;4E75

crab.colours:	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$05	;05
	dc.b	$07	;07
	dc.b	$08	;08
	dc.b	$0B	;0B
	dc.b	$09	;09
	dc.b	$0A	;0A

adrCd00AD40:	cmp.b	#$02,d1	;0C010002
	bcc.s	adrCd00AD4A	;6404
	bsr	adrCd00AE78	;61000130
adrCd00AD4A:	cmp.b	#$02,d0	;0C000002
	beq.s	adrCd00AD90	;6740
	tst.b	d0	;4A00
	bne	adrCd00AE00	;660000AC
	cmp.b	#$02,d1	;0C010002
	bcs.s	adrCd00ADA4	;6548
	subq.w	#$02,d1	;5541
	lea	adrEA00AF92.l,a2	;45F90000AF92
	bsr	adrCd00AF0E	;610001A8
	moveq	#$00,d7	;7E00
	move.b	adrB_00AD98(pc,d1.w),d7	;1E3B102C
	add.b	adrB_00AD92(pc,d1.w),d5	;DA3B1022
	moveq	#$00,d6	;7C00
	add.w	d1,d1	;D241
	movem.l	d0/d1/d4/d5/d7/a1,-(sp)	;48E7CD40
	add.b	adrB_00AD94(pc,d1.w),d4	;D83B1018
	bsr	adrCd00BBCA	;61000E4A
	movem.l	(sp)+,d0/d1/d4/d5/d7/a1	;4CDF02B3
	moveq	#-$01,d6	;7CFF
	add.b	adrB_00AD95(pc,d1.w),d4	;D83B100B
	bra	adrCd00BBCA	;60000E3C

adrCd00AD90:	rts	;4E75

adrB_00AD92:	dc.b	$F8	;F8
	dc.b	$F7	;F7
adrB_00AD94:	dc.b	$F8	;F8
adrB_00AD95:	dc.b	$04	;04
	dc.b	$F9	;F9
	dc.b	$FF	;FF
adrB_00AD98:	dc.b	$09	;09
	dc.b	$07	;07
adrB_00AD9A:	dc.b	$FD	;FD
	dc.b	$EF	;EF
	dc.b	$FA	;FA
	dc.b	$F1	;F1
adrB_00AD9E:	dc.b	$F0	;F0
	dc.b	$10	;10
	dc.b	$F6	;F6
	dc.b	$04	;04
adrB_00ADA2:	dc.b	$14	;14
	dc.b	$0D	;0D

adrCd00ADA4:	moveq	#$00,d7	;7E00
	move.b	adrB_00ADA2(pc,d1.w),d7	;1E3B10FA
	moveq	#$00,d2	;7400
	moveq	#$00,d6	;7C00
	bsr	adrCd00ADB6	;61000006
	moveq	#$01,d2	;7401
	moveq	#-$01,d6	;7CFF
adrCd00ADB6:	lea	adrEA00B512.l,a2	;45F90000B512
	lea	_GFX_Behemoth.l,a1	;43F900043480
	movem.w	d0/d1/d4/d5/d7,-(sp)	;48A7CD00
	add.w	d1,d1	;D241
	move.w	d1,d3	;3601
	add.w	d2,d3	;D642
	add.b	adrB_00AD9E(pc,d3.w),d4	;D83B30D0
	move.w	d1,d3	;3601
	btst	d2,-$0015(a3)	;052BFFEB
	beq.s	adrCd00ADDC	;6704
	addq.w	#$01,d3	;5243
	addq.w	#$02,a2	;544A
adrCd00ADDC:	add.b	adrB_00AD9A(pc,d3.w),d5	;DA3B30BC
	add.w	d1,d1	;D241
	add.w	$00(a2,d1.w),a1	;D2F21000
	bsr	adrCd00BBCA	;61000DE2
	movem.w	(sp)+,d0/d1/d4/d5/d7	;4C9F00B3
	rts	;4E75

adrB_00ADF0:	dc.b	$08	;08
	dc.b	$12	;12
	dc.b	$07	;07
	dc.b	$0E	;0E
adrB_00ADF4:	dc.b	$E6	;E6
	dc.b	$E5	;E5
	dc.b	$1A	;1A
	dc.b	$1B	;1B
	dc.b	$EF	;EF
	dc.b	$EF	;EF
	dc.b	$0B	;0B
	dc.b	$0B	;0B
adrB_00ADFC:	dc.b	$02	;02
	dc.b	$F1	;F1
	dc.b	$FB	;FB
	dc.b	$F0	;F0

adrCd00AE00:	cmp.b	#$02,d1	;0C010002
	bcc.s	adrCd00AE48	;6442
	lea	adrEA00AF96.l,a2	;45F90000AF96
	add.w	d1,d1	;D241
	moveq	#-$01,d6	;7CFF
	lsr.b	#$01,d0	;E208
	beq.s	adrCd00AE16	;6702
	moveq	#$00,d6	;7C00
adrCd00AE16:	move.w	d1,d2	;3401
	add.w	d0,d2	;D440
	add.w	d2,d2	;D442
	eor.b	#$01,d0	;0A000001
	btst	d0,-$0015(a3)	;012BFFEB
	beq.s	adrCd00AE2A	;6704
	addq.w	#$01,d1	;5241
	addq.w	#$01,d2	;5242
adrCd00AE2A:	moveq	#$00,d7	;7E00
	move.b	adrB_00ADF0(pc,d1.w),d7	;1E3B10C2
	add.b	adrB_00ADF4(pc,d2.w),d4	;D83B20C2
	add.b	adrB_00ADFC(pc,d1.w),d5	;DA3B10C6
	bsr	adrCd00AF0E	;610000D4
	bra	adrCd00BBCA	;60000D8C

adrB_00AE40:	dc.b	$08	;08
	dc.b	$06	;06
adrB_00AE42:	dc.b	$F3	;F3
	dc.b	$09	;09
	dc.b	$F2	;F2
	dc.b	$06	;06
adrB_00AE46:	dc.b	$F8	;F8
	dc.b	$F7	;F7

adrCd00AE48:	subq.b	#$02,d1	;5501
	moveq	#$00,d7	;7E00
	move.b	adrB_00AE40(pc,d1.w),d7	;1E3B10F2
	add.b	adrB_00AE46(pc,d1.w),d5	;DA3B10F4
	lea	adrEA00AF9E.l,a2	;45F90000AF9E
	bsr	adrCd00AF0E	;610000B2
	add.w	d1,d1	;D241
	moveq	#-$01,d6	;7CFF
	lsr.b	#$01,d0	;E208
	beq.s	adrCd00AE6A	;6704
	moveq	#$00,d6	;7C00
	addq.w	#$01,d1	;5241
adrCd00AE6A:	add.b	adrB_00AE42(pc,d1.w),d4	;D83B10D6
	bra	adrCd00BBCA	;60000D5A

adrB_00AE72:	dc.b	$0B	;0B
	dc.b	$07	;07
adrB_00AE74:	dc.b	$FE	;FE
	dc.b	$FB	;FB
adrB_00AE76:	dc.b	$EC	;EC
	dc.b	$14	;14

adrCd00AE78:	tst.b	d0	;4A00
	bne.s	adrCd00AE9E	;6622
	moveq	#$00,d6	;7C00
	lea	adrEA00AF88.l,a2	;45F90000AF88
	movem.w	d0/d1/d4/d5,-(sp)	;48A7CC00
	move.b	adrB_00AE72(pc,d1.w),d7	;1E3B10E8
	bsr	adrCd00AF0E	;61000080
	add.b	adrB_00AE74(pc,d1.w),d5	;DA3B10E2
adrCd00AE94:	bsr	adrCd00BBCA	;61000D34
	movem.w	(sp)+,d0/d1/d4/d5	;4C9F0033
adrCd00AE9C:	rts	;4E75

adrCd00AE9E:	cmp.b	#$02,d0	;0C000002
	beq.s	adrCd00AECC	;6728
	tst.b	d1	;4A01
	bne.s	adrCd00AE9C	;66F4
	lea	_GFX_CrabClaw.l,a1	;43F900044CC0
	movem.w	d0/d1/d4/d5,-(sp)	;48A7CC00
	moveq	#$07,d7	;7E07
	subq.b	#$03,d5	;5705
	moveq	#-$01,d6	;7CFF
	lsr.b	#$01,d0	;E208
	beq.s	adrCd00AEBE	;6702
	moveq	#$00,d6	;7C00
adrCd00AEBE:	add.b	adrB_00AE76(pc,d0.w),d4	;D83B00B6
	bra.s	adrCd00AE94	;60D0

adrB_00AEC4:	dc.b	$07	;07
	dc.b	$F9	;F9
	dc.b	$FE	;FE
	dc.b	$FC	;FC
adrB_00AEC8:	dc.b	$EF	;EF
	dc.b	$F1	;F1
adrB_00AECA:	dc.b	$07	;07
	dc.b	$04	;04

adrCd00AECC:	tst.b	-$0015(a3)	;4A2BFFEB
	beq.s	adrCd00AE9C	;67CA
	lea	adrEA00AF8E.l,a2	;45F90000AF8E
	bsr.s	adrCd00AF0E	;6134
	moveq	#$00,d7	;7E00
	move.b	adrB_00AECA(pc,d1.w),d7	;1E3B10EC
	moveq	#-$01,d6	;7CFF
	moveq	#$00,d2	;7400
	bsr.s	adrCd00AEEA	;6104
	moveq	#$00,d6	;7C00
	moveq	#$01,d2	;7401
adrCd00AEEA:	btst	d2,-$0015(a3)	;052BFFEB
	beq.s	adrCd00AF0C	;671C
	movem.w	d0/d1/d4/d5/d7,-(sp)	;48A7CD00
	move.l	a1,-(sp)	;2F09
	add.b	adrB_00AEC8(pc,d1.w),d5	;DA3B10D0
	add.w	d1,d1	;D241
	add.w	d2,d1	;D242
	add.b	adrB_00AEC4(pc,d1.w),d4	;D83B10C4
	bsr	adrCd00BBCA	;61000CC6
	move.l	(sp)+,a1	;225F
	movem.w	(sp)+,d0/d1/d4/d5/d7	;4C9F00B3
adrCd00AF0C:	rts	;4E75

adrCd00AF0E:	lea	_GFX_Crab.l,a1	;43F900044868
	move.w	d1,d2	;3401
	add.w	d2,d2	;D442
	add.w	$00(a2,d2.w),a1	;D2F22000
	rts	;4E75

adrCd00AF1E:	lea	adrEA00B36E.l,a0	;41F90000B36E
	move.b	$00(a0,d1.w),d1	;12301000
	lea	adrEA00AF80.l,a2	;45F90000AF80
	lea	adrEA00AF74.l,a0	;41F90000AF74
	add.b	$00(a0,d1.w),d5	;DA301000
	moveq	#$00,d7	;7E00
	move.b	$04(a0,d1.w),d7	;1E301004
	swap	d7	;4847
	move.b	$08(a0,d1.w),d7	;1E301008
	bsr.s	adrCd00AF0E	;61C8
	movem.l	d0-d2/d4/d5/d7,-(sp)	;48E7ED00
	move.l	a1,-(sp)	;2F09
	add.b	adrB_00AF6C(pc,d2.w),d4	;D83B201E
	moveq	#$00,d6	;7C00
	bsr	adrCd00B51A	;610005C6
	move.l	(sp)+,a1	;225F
	movem.l	(sp),d0-d2/d4/d5/d7	;4CD700B7
	moveq	#-$01,d6	;7CFF
	add.b	adrB_00AF6D(pc,d2.w),d4	;D83B200D
	bsr	adrCd00B51A	;610005B6
	movem.l	(sp)+,d0-d2/d4/d5/d7	;4CDF00B7
	rts	;4E75

adrB_00AF6C:	dc.b	$EC	;EC
adrB_00AF6D:	dc.b	$04	;04
	dc.b	$F2	;F2
	dc.b	$F8	;F8
	dc.b	$F8	;F8
	dc.b	$04	;04
	dc.b	$F9	;F9
	dc.b	$FF	;FF
adrEA00AF74:	dc.w	$080B	;080B
	dc.w	$1714	;1714
	dc.w	$0101	;0101
	dc.w	$0000	;0000
	dc.w	$1C12	;1C12
	dc.w	$0C09	;0C09
adrEA00AF80:	dc.w	$0000	;0000
	dc.w	$01D0	;01D0
	dc.w	$0300	;0300
	dc.w	$0368	;0368
adrEA00AF88:	dc.w	$03B8	;03B8
	dc.w	$0418	;0418
	dc.w	$0458	;0458
adrEA00AF8E:	dc.w	$0498	;0498
	dc.w	$04D8	;04D8
adrEA00AF92:	dc.w	$0500	;0500
	dc.w	$0550	;0550
adrEA00AF96:	dc.w	$0590	;0590
	dc.w	$05D8	;05D8
	dc.w	$0670	;0670
	dc.w	$06B0	;06B0
adrEA00AF9E:	dc.w	$0728	;0728
	dc.w	$0770	;0770
beholder.colours:	dc.w	$040A	;040A
	dc.w	$070B	;070B
	dc.w	$0308	;0308
	dc.w	$0509	;0509

Draw_Beholder:	moveq	#$0D,d3	;760D
	lea	beholder.colours.l,a0	;41F90000AFA2
	bsr	adrCd00ACAA	;6100FCF6
	bsr	adrCd00B086	;610000CE
	cmp.b	#$02,d0	;0C000002
	beq.s	adrCd00AFC4	;6704
	bsr	adrCd00AFD4	;61000012
adrCd00AFC4:	clr.w	adrW_00C354.l	;42790000C354
	rts	;4E75

adrB_00AFCC:	dc.b	$08	;08
	dc.b	$06	;06
	dc.b	$06	;06
	dc.b	$04	;04
adrB_00AFD0:	dc.b	$06	;06
	dc.b	$05	;05
	dc.b	$04	;04
	dc.b	$03	;03

adrCd00AFD4:	cmp.b	#$04,d1	;0C010004
	bcc.s	adrCd00B03E	;6464
	lea	adrEA00B120.l,a2	;45F90000B120
	moveq	#$00,d7	;7E00
	add.b	adrB_00AFD0(pc,d1.w),d5	;DA3B10EC
	move.w	d1,d2	;3401
	add.w	d2,d2	;D442
	btst	#$01,-$0015(a3)	;082B0001FFEB
	beq.s	adrCd00AFF4	;6702
	addq.w	#$01,d2	;5242
adrCd00AFF4:	add.w	d2,d2	;D442
	lea	_GFX_Beholder.l,a1	;43F900045010
	tst.b	d0	;4A00
	bne.s	adrCd00B018	;6618
	move.b	adrB_00AFCC(pc,d1.w),d7	;1E3B10CA
	add.w	$00(a2,d2.w),a1	;D2F22000
	bra	adrCd00B0DE	;600000D4

adrB_00B00C:	dc.b	$08	;08
	dc.b	$06	;06
	dc.b	$04	;04
	dc.b	$04	;04
adrB_00B010:	dc.b	$08	;08
	dc.b	$04	;04
	dc.b	$FF	;FF
	dc.b	$FD	;FD
adrB_00B014:	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$00	;00

adrCd00B018:	add.w	#$0010,a2	;D4FC0010
	add.w	$00(a2,d2.w),a1	;D2F22000
	move.b	adrB_00B00C(pc,d1.w),d7	;1E3B10EA
	add.b	adrB_00B014(pc,d1.w),d5	;DA3B10EE
	moveq	#$00,d6	;7C00
	lsr.b	#$01,d0	;E208
	beq	adrCd00BBCA	;67000B9C
	add.b	adrB_00B010(pc,d1.w),d4	;D83B10DE
	moveq	#-$01,d6	;7CFF
	bra	adrCd00BBCA	;60000B92

adrB_00B03A:	dc.b	$06	;06
	dc.b	$04	;04
adrB_00B03C:	dc.b	$F9	;F9
	dc.b	$F7	;F7

adrCd00B03E:	lea	adrEA00B140.l,a2	;45F90000B140
	subq.w	#$04,d1	;5941
	move.w	d1,d2	;3401
	moveq	#$02,d7	;7E02
	add.b	adrB_00B03A(pc,d1.w),d5	;DA3B10EE
	moveq	#$00,d6	;7C00
	tst.b	d0	;4A00
	beq.s	adrCd00B060	;670C
	addq.w	#$02,d2	;5442
	lsr.b	#$01,d0	;E208
	beq.s	adrCd00B060	;6706
	moveq	#-$01,d6	;7CFF
	add.b	adrB_00B03C(pc,d1.w),d4	;D83B10DE
adrCd00B060:	add.w	d2,d2	;D442
	lea	_GFX_Beholder.l,a1	;43F900045010
	add.w	$00(a2,d2.w),a1	;D2F22000
	bra	adrCd00BBCA	;60000B5C

adrB_00B070:	dc.b	$14	;14
	dc.b	$10	;10
	dc.b	$0D	;0D
	dc.b	$0A	;0A
	dc.b	$0B	;0B
	dc.b	$08	;08
adrB_00B076:	dc.b	$FD	;FD
	dc.b	$FE	;FE
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
adrB_00B07C:	dc.b	$F2	;F2
	dc.b	$F4	;F4
	dc.b	$F6	;F6
	dc.b	$F7	;F7
	dc.b	$02	;02
	dc.b	$01	;01
adrB_00B082:	dc.b	$06	;06
	dc.b	$04	;04
	dc.b	$03	;03
	dc.b	$03	;03

adrCd00B086:	moveq	#$00,d7	;7E00
	move.b	adrB_00B070(pc,d1.w),d7	;1E3B10E6
	add.b	adrB_00B076(pc,d1.w),d4	;D83B10E8
	add.b	adrB_00B07C(pc,d1.w),d5	;DA3B10EA
	lea	adrEA00B10C.l,a2	;45F90000B10C
	bsr	adrCd00B0CE	;61000032
	bsr	adrCd00B0DE	;6100003E
	cmp.b	#$04,d1	;0C010004
	bcc.s	adrCd00B0CC	;6424
	lea	adrEA00B118.l,a2	;45F90000B118
	bsr	adrCd00B0CE	;6100001E
	move.w	d5,-(sp)	;3F05
	moveq	#$00,d7	;7E00
	move.b	adrB_00B082(pc,d1.w),d7	;1E3B10CA
	sub.b	d7,d5	;9A07
	move.b	-$0015(a3),d2	;142BFFEB
	not.b	d2	;4602
	and.w	#$0001,d2	;02420001
	sub.b	d2,d5	;9A02
	bsr.s	adrCd00B0DE	;6114
	move.w	(sp)+,d5	;3A1F
adrCd00B0CC:	rts	;4E75

adrCd00B0CE:	move.w	d1,d2	;3401
	add.w	d2,d2	;D442
	lea	_GFX_Beholder.l,a1	;43F900045010
	add.w	$00(a2,d2.w),a1	;D2F22000
	rts	;4E75

adrCd00B0DE:	movem.w	d0/d1/d4/d5/d7,-(sp)	;48A7CD00
	move.l	a1,-(sp)	;2F09
	moveq	#$00,d6	;7C00
	bsr	adrCd00BBCA	;61000AE2
	move.l	(sp)+,a1	;225F
	movem.w	(sp)+,d0/d1/d4/d5/d7	;4C9F00B3
	cmp.b	#$02,d1	;0C010002
	bcc.s	adrCd00B108	;6412
	moveq	#-$01,d6	;7CFF
	movem.w	d0/d1/d4/d5/d7,-(sp)	;48A7CD00
	add.b	adrB_00B10A(pc,d1.w),d4	;D83B100C
	bsr	adrCd00BBCA	;61000AC8
	movem.w	(sp)+,d0/d1/d4/d5/d7	;4C9F00B3
adrCd00B108:	rts	;4E75

adrB_00B10A:	dc.b	$08	;08
	dc.b	$04	;04
adrEA00B10C:	dc.w	$0000	;0000
	dc.w	$00A8	;00A8
	dc.w	$0130	;0130
	dc.w	$01A0	;01A0
	dc.w	$01F8	;01F8
	dc.w	$0258	;0258
adrEA00B118:	dc.w	$02A0	;02A0
	dc.w	$02D8	;02D8
	dc.w	$0300	;0300
	dc.w	$0320	;0320
adrEA00B120:	dc.w	$0340	;0340
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
adrEA00B140:	dc.w	$06A0	;06A0
	dc.w	$06B8	;06B8
	dc.w	$06D0	;06D0
	dc.w	$06E8	;06E8

Draw_LittleDragon:	moveq	#$01,d2	;7401
	lea	adrEA00B154.l,a2	;45F90000B154
	moveq	#$0E,d3	;760E
	bra.s	adrCd00B16E	;601A

adrEA00B154:	dc.w	$F1F5	;F1F5
	dc.w	$FBFA	;FBFA
	dc.w	$FD01	;FD01
	dc.w	$0E0D	;0E0D
adrEA00B15C:	dc.w	$E8EE	;E8EE
	dc.w	$F6F9	;F6F9
	dc.w	$F0F8	;F0F8
	dc.w	$0909	;0909

Draw_BigDragon:	moveq	#$00,d2	;7400
	lea	adrEA00B15C.l,a2	;45F90000B15C
	moveq	#$10,d3	;7610
adrCd00B16E:	lea	adrEA00B36E.l,a0	;41F90000B36E
	move.b	$00(a0,d1.w),d1	;12301000
	add.b	$00(a2,d1.w),d4	;D8321000
	add.b	$04(a2,d1.w),d5	;DA321004
	add.w	d2,d1	;D242
	btst	#$00,d0	;08000000
	beq.s	adrCd00B194	;670C
	move.w	d0,d2	;3400
	lsr.w	#$01,d2	;E24A
	add.w	d1,d2	;D441
	add.w	d1,d2	;D441
	add.b	adrB_00B1B4(pc,d2.w),d4	;D83B2022
adrCd00B194:	lea	dragon.colours.l,a0	;41F90000B1BE
	bsr	adrCd00ACAA	;6100FB0E
	move.w	#$FFFF,adrW_00C354.l	;33FCFFFF0000C354
	bsr	adrCd00B28E	;610000E6
	bsr.s	adrCd00B1C6	;611A
	clr.w	adrW_00C354.l	;42790000C354
adrCd00B1B2:	rts	;4E75

adrB_00B1B4:	dc.b	$FD	;FD
	dc.b	$F5	;F5
	dc.b	$FD	;FD
	dc.b	$F1	;F1
	dc.b	$FE	;FE
	dc.b	$F2	;F2
	dc.b	$FE	;FE
	dc.b	$FA	;FA
	dc.b	$FF	;FF
	dc.b	$F6	;F6
dragon.colours:	dc.w	$0B0A	;0B0A
	dc.w	$0408	;0408
	dc.w	$0709	;0709
	dc.w	$0506	;0506

adrCd00B1C6:	cmp.b	#$02,d0	;0C000002
	beq.s	adrCd00B1B2	;67E6
	cmp.b	#$03,d1	;0C010003
	bcc.s	adrCd00B1B2	;64E0
	moveq	#$00,d2	;7400
	moveq	#$00,d6	;7C00
	movem.w	d0/d1/d4/d5,-(sp)	;48A7CC00
	bsr.s	adrCd00B1E8	;610C
	movem.w	(sp)+,d0/d1/d4/d5	;4C9F0033
	tst.w	d0	;4A40
	bne.s	adrCd00B1B2	;66CE
	moveq	#-$01,d6	;7CFF
	moveq	#$01,d2	;7401
adrCd00B1E8:	move.w	d1,d3	;3601
	asl.w	#$02,d3	;E543
	move.w	d0,d7	;3E00
	beq.s	adrCd00B1F8	;6708
	addq.w	#$02,d3	;5443
	lsr.w	#$01,d7	;E24F
	bne.s	adrCd00B1F8	;6602
	not.l	d6	;4686
adrCd00B1F8:	btst	d2,-$0015(a3)	;052BFFEB
	beq.s	adrCd00B200	;6702
	addq.w	#$01,d3	;5243
adrCd00B200:	moveq	#$00,d7	;7E00
	move.b	adrB_00B230(pc,d3.w),d7	;1E3B302C
	swap	d7	;4847
	move.b	adrB_00B23C(pc,d3.w),d7	;1E3B3032
	add.b	adrB_00B248(pc,d3.w),d5	;DA3B303A
	add.w	d3,d3	;D643
	lea	adrEA00B30A.l,a2	;45F90000B30A
	lea	_GFX_Dragon.l,a1	;43F900045710
	add.w	$00(a2,d3.w),a1	;D2F23000
	tst.w	d6	;4A46
	bpl.s	adrCd00B228	;6A02
	addq.w	#$01,d3	;5243
adrCd00B228:	add.b	adrB_00B254(pc,d3.w),d4	;D83B302A
	bra	adrCd00B51A	;600002EC

adrB_00B230:	dc.b	$00	;00
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
adrB_00B23C:	dc.b	$14	;14
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
adrB_00B248:	dc.b	$22	;22
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
adrB_00B254:	dc.b	$05	;05
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
adrB_00B26C:	dc.b	$01	;01
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
adrB_00B27B:	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$81	;81
adrB_00B27F:	dc.b	$31	;31
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

adrCd00B28E:	move.w	d1,d2	;3401
	add.w	d2,d2	;D442
	add.w	d1,d2	;D441
	moveq	#$00,d6	;7C00
	move.b	adrB_00B27B(pc,d0.w),d3	;163B00E3
	bpl.s	adrCd00B2A0	;6A04
	moveq	#-$01,d6	;7CFF
	moveq	#$01,d3	;7601
adrCd00B2A0:
	add.b	d3,d2	;D403
	moveq	#$00,d7	;7E00
	move.b	adrB_00B26C(pc,d2.w),d7	;1E3B20C6
	swap	d7	;4847
	move.b	adrB_00B27F(pc,d2.w),d7	;1E3B20D3
	add.w	d2,d2	;D442
	lea	adrEA00B2EC.l,a2	;45F90000B2EC
	lea	_GFX_Dragon.l,a1	;43F900045710
	add.w	$00(a2,d2.w),a1	;D2F22000
	movem.l	d0/d1/d4/d5/d7/a1,-(sp)	;48E7CD40
	bsr	adrCd00B51A	;61000254
	movem.l	(sp)+,d0/d1/d4/d5/d7/a1	;4CDF02B3
	btst	#$00,d0	;08000000
	bne.s	adrCd00B2E4	;6612
	moveq	#-$01,d6	;7CFF
	movem.w	d0/d1/d4/d5,-(sp)	;48A7CC00
	add.b	adrB_00B2E6(pc,d1.w),d4	;D83B100C
	bsr	adrCd00B51A	;6100023C
	movem.w	(sp)+,d0/d1/d4/d5	;4C9F0033
adrCd00B2E4:	rts	;4E75

adrB_00B2E6:
	dc.b	$20	;20
	dc.b	$0E	;0E
	dc.b	$10	;10
	dc.b	$07	;07
	dc.b	$04	;04
	dc.b	$00	;00
adrEA00B2EC:
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
adrEA00B30A:
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
	lea	behemoth.colours.l,a0	;41F90000B346
	moveq	#$0E,d3	;760E
	bsr	adrCd00ACAA	;6100F97E
	lea	adrEA00B4B8.l,a0	;41F90000B4B8
adrCd00B334:
	move.w	#$FFFF,adrW_00C354.l	;33FCFFFF0000C354
	bsr.s	adrCd00B39C	;615E
	clr.w	adrW_00C354.l	;42790000C354
	rts	;4E75

behemoth.colours:
	dc.w	$090B	;090B
	dc.w	$0A08	;0A08
	dc.w	$0304	;0304
	dc.w	$0507	;0507
MonsterColours_Entropy:
	dc.w	$0002	;0002
	dc.w	$0506	;0506
	dc.w	$0005	;0005
	dc.w	$060D	;060D
	dc.w	$0009	;0009
	dc.w	$0A0B	;0A0B
	dc.w	$000A	;000A
	dc.w	$0B0D	;0B0D
	dc.w	$0007	;0007
	dc.w	$0804	;0804
	dc.w	$0008	;0008
	dc.w	$040D	;040D
	dc.w	$0009	;0009
	dc.w	$0C0B	;0C0B
	dc.w	$000C	;000C
	dc.w	$0B0D	;0B0D
adrEA00B36E:
	dc.w	$0000	;0000
	dc.w	$0101	;0101
	dc.w	$0203	;0203

Draw_Entropy:
	move.w	CurrentTower.l,d2	;34390000F98A
	asl.w	#$03,d2	;E742
	btst	#$00,-$0017(a3)	;082B0000FFE9
	bne.s	adrCd00B386	;6602
	addq.w	#$04,d2	;5842
adrCd00B386:
	lea	MonsterColours_Entropy.l,a6	;4DF90000B34E
	add.w	d2,a6	;DCC2
	move.l	(a6),adrEA00C356.l	;23D60000C356
	lea	adrEA00B454.l,a0	;41F90000B454
	bra.s	adrCd00B334	;6098

adrCd00B39C:
	move.b	adrEA00B36E(pc,d1.w),d1	;123B10D0
	lea	$0042(a0),a2	;45E80042

	; Entropy fix
	move.l	$003E(a0),a1	;2268003E
	bsr	adrCd00AAB8	;6100F70E
	add.b	$16(a0,d1.w),d4	;D8301016
	move.w	d0,d2	;3400
	lsr.w	#$01,d2	;E24A
	bcc.s	adrCd00B3BE	;6408
	add.w	d1,d2	;D441
	add.w	d1,d2	;D441
	add.b	$1A(a0,d2.w),d4	;D830201A
adrCd00B3BE:
	movem.l	d0/d1/d4/d5/d7/a0/a1,-(sp)	;48E7CDC0
	bsr	adrCd00B51A	;61000156
	movem.l	(sp),d0/d1/d4/d5/d7/a0/a1	;4CD703B3
	btst	#$00,d0	;08000000
	bne.s	adrCd00B3DA	;660A
	moveq	#-$01,d6	;7CFF
	add.b	$22(a0,d1.w),d4	;D8301022
	bsr	adrCd00B51A	;61000142
adrCd00B3DA:
	movem.l	(sp)+,d0/d1/d4/d5/d7/a0/a1	;4CDF03B3
	cmp.b	#$02,d1	;0C010002
	bcc.s	adrCd00B450	;646C
	lea	adrEA00C356.l,a6	;4DF90000C356
	moveq	#$00,d2	;7400
	moveq	#$00,d6	;7C00
	move.l	a0,-(sp)	;2F08
	bsr.s	adrCd00B3FE	;610C
	move.l	(sp)+,a0	;205F
	btst	#$00,d0	;08000000
	bne.s	adrCd00B450	;6656
	moveq	#$01,d2	;7401
	moveq	#-$01,d6	;7CFF
adrCd00B3FE:
	movem.w	d0/d1/d4/d5,-(sp)	;48A7CC00
	; Entropy
	;lea	_GFX_Entropy.l,a1
	move.l	$003E(a0),a1	;2268003E
	add.w	d1,d1	;D241
	moveq	#$00,d3	;7600
	btst	d2,-$0015(a3)	;052BFFEB
	beq.s	adrCd00B414	;6704
	addq.w	#$01,d1	;5241
	moveq	#-$01,d3	;76FF
adrCd00B414:	moveq	#$00,d7	;7E00
	move.b	$2A(a0,d1.w),d7	;1E30102A
	add.b	$26(a0,d1.w),d5	;DA301026
	add.w	d1,d1	;D241
	add.w	$5A(a0,d1.w),a1	;D2F0105A
	add.w	d1,d1	;D241
	lsr.w	#$01,d0	;E248
	bcc.s	adrCd00B43E	;6414
	addq.w	#$02,d1	;5441
	tst.w	d3	;4A43
	bpl.s	adrCd00B438	;6A08
	tst.w	-$0002(a0)	;4A68FFFE
	beq.s	adrCd00B438	;6702
	not.w	d6	;4646
adrCd00B438:	tst.w	d0	;4A40
	bne.s	adrCd00B43E	;6602
	not.w	d6	;4646
adrCd00B43E:	tst.w	d6	;4A46
	beq.s	adrCd00B444	;6702
	addq.w	#$01,d1	;5241
adrCd00B444:	add.b	$2E(a0,d1.w),d4	;D830102E
	bsr	adrCd00BBCA	;61000780
	movem.w	(sp)+,d0/d1/d4/d5	;4C9F0033
adrCd00B450:	rts	;4E75

;fiX Label expected
	dc.w	$FFFF	;FFFF
adrEA00B454:
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

;	dc.w	$0004	;0004
;	dc.w	$8040	;8040
	; proper entropy gfx fix
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
adrEA00B4B8:
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

	
	;dc.w	$0004	;0004
	;dc.w	$3480	;3480
	; Behemoth Graphic Fix
	dc.l	_GFX_Behemoth

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
adrEA00B512:
	dc.w	$11B8	;11B8
	dc.w	$1260	;1260
	dc.w	$1308	;1308
	dc.w	$1378	;1378

adrCd00B51A:
	add.w	$0008(a5),d5	;DA6D0008
	move.b	d4,d6	;1C04
	add.b	#$60,d4	;06040060
	ext.w	d6	;4886
	asr.w	#$04,d6	;E846
	move.l	a3,-(sp)	;2F0B
	tst.l	d6	;4A86
	bmi.s	adrCd00B534	;6B06
	bsr	adrCd00BCF4	;610007C4
	bra.s	adrCd00B538	;6004

adrCd00B534:	bsr	adrCd00BDB4	;6100087E
adrCd00B538:	move.l	(sp)+,a3	;265F
	rts	;4E75

adrCd00B53C:	bsr	adrCd00A69C	;6100F15E
	tst.b	d1	;4A01
	bpl.s	NPC_DrawingSelection	;6A02
	rts	;4E75

NPC_DrawingSelection:	move.b	-$0017(a3),d0	;102BFFE9
	bmi	DrawSpells	;6B00F4A4
	move.w	-$000A(a3),d0	;302BFFF6
	btst	#$00,d0	;08000000
	bne.s	adrCd00B55A	;6602
	addq.w	#$02,d0	;5440
adrCd00B55A:	add.b	-$001B(a3),d0	;D02BFFE5
	and.w	#$0003,d0	;02400003
	moveq	#$00,d2	;7400
	move.b	-$0017(a3),d2	;142BFFE9
	sub.b	#$64,d2	;04020064
	bcs.s	Draw_Characters	;6528
	cmp.b	#$02,d2	;0C020002
	beq	Draw_Beholder	;6700FA36
	bcs	Draw_Summon	;6500F570
	subq.b	#$03,d2	;5702
	lea	adrJT00B58A.l,a1	;43F90000B58A
	add.w	d2,d2	;D442
	add.w	$00(a1,d2.w),a1	;D2F12000
	jmp	(a1)	;4ED1

adrJT00B58A:	dc.w	Draw_Behemoth-adrJT00B58A	;FD98
	dc.w	Draw_Crab-adrJT00B58A	;F788
	dc.w	Draw_BigDragon-adrJT00B58A	;FBDA
	dc.w	Draw_LittleDragon-adrJT00B58A	;FBBE
	dc.w	Draw_Entropy-adrJT00B58A	;FDEA
	dc.w	Draw_Entropy-adrJT00B58A	;FDEA

Draw_Characters:	moveq	#$00,d2	;7400
	move.b	-$0017(a3),d2	;142BFFE9
	cmp.b	#$10,d2	;0C020010
	bcc.s	adrCd00B5B0	;640E
	move.w	d2,d7	;3E02
	asl.w	#$06,d7	;ED47
	lea	CharacterStats.l,a1	;43F90000F586
	move.b	$01(a1,d7.w),d2	;14317001
adrCd00B5B0:	lea	characters.heads.l,a0	;41F90000B788
	move.b	$00(a0,d2.w),-$0018(a3)	;17702000FFE8
	move.w	d1,d2	;3401
	asl.w	#$02,d2	;E542
	add.w	d0,d2	;D440
	add.w	d2,d2	;D442
	move.w	d2,d3	;3602
	asl.w	#$02,d2	;E542
	add.w	d3,d2	;D443
	moveq	#$00,d6	;7C00
	moveq	#$00,d3	;7600
	move.b	-$0017(a3),d3	;162BFFE9
	cmp.b	#$10,d3	;0C030010
	bcc	adrCd00B664	;6400008C
	move.b	$01(a1,d7.w),d3	;16317001
	move.b	$32(a1,d7.w),d7	;1E317032
	cmp.b	#$24,d7	;0C070024
	bcc.s	adrCd00B664	;647C
	sub.b	#$1B,d7	;0407001B
	bcs.s	adrCd00B664	;6576
	move.b	d7,d6	;1C07
	move.b	adrB_00B5F6(pc,d6.w),d6	;1C3B6004
	bra.s	adrCd00B664	;606E

adrB_00B5F6:	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$42	;42
	dc.b	$43	;43
	dc.b	$82	;82
	dc.b	$83	;83
	dc.b	$C2	;C2
	dc.b	$C3	;C3
	dc.b	$00	;00
characters.bodies:	
	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$04	;04
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$02	;02
	dc.b	$04	;04
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$01	;01
	dc.b	$0B	;0B
	dc.b	$02	;02
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$0C	;0C
	dc.b	$0C	;0C
	dc.b	$0C	;0C
	dc.b	$0C	;0C
	dc.b	$0C	;0C
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$08	;08
	dc.b	$08	;08
	dc.b	$04	;04
	dc.b	$04	;04
	dc.b	$04	;04
	dc.b	$0A	;0A
	dc.b	$0D	;0D
	dc.b	$0D	;0D
	dc.b	$0D	;0D
	dc.b	$0D	;0D
	dc.b	$07	;07
	dc.b	$07	;07
	dc.b	$07	;07
	dc.b	$07	;07
	dc.b	$07	;07
	dc.b	$07	;07
	dc.b	$03	;03
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$0B	;0B
	dc.b	$0B	;0B
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$07	;07
	dc.b	$07	;07
	dc.b	$07	;07
	dc.b	$07	;07
	dc.b	$07	;07
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$0B	;0B
	dc.b	$07	;07
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
adrB_00B656:	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$03	;03
	dc.b	$04	;04
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$03	;03

adrCd00B664:	move.b	characters.bodies(pc,d3.w),d3	;163B309A
	beq.s	adrCd00B676	;670C
	tst.w	d6	;4A46
	beq.s	adrCd00B676	;6708
	move.b	adrB_00B656(pc,d3.w),d3	;163B30E6
	add.b	d6,d3	;D606
	add.b	d6,d3	;D606
adrCd00B676:	move.b	d6,-$001C(a3)	;1746FFE4
	lea	adrEA00B6FC.l,a0	;41F90000B6FC
	and.w	#$000F,d3	;0243000F
	mulu	#$000A,d3	;C6FC000A
	lea	$02(a0,d3.w),a0	;41F03002
	lea	adrEA016652.l,a1	;43F900016652
	tst.w	-$0002(a0)	;4A68FFFE
	beq.s	adrCd00B69E	;6706
	lea	adrEA016792.l,a1	;43F900016792
adrCd00B69E:	move.l	a0,-(sp)	;2F08
	move.l	a1,-(sp)	;2F09
	move.w	d2,-(sp)	;3F02
	move.w	d5,-(sp)	;3F05
	move.w	d4,-(sp)	;3F04
	move.w	d1,-(sp)	;3F01
	move.w	d0,-(sp)	;3F00
	cmp.w	#$0004,d1	;0C410004
	beq	adrCd00BAF0	;6700043E
	cmp.w	#$0005,d1	;0C410005
	beq	adrCd00BB1E	;67000464
	tst.b	-$0019(a3)	;4A2BFFE7
	bmi.s	adrCd00B6E4	;6B22
	cmp.w	#$0003,d1	;0C410003
	bcc.s	adrCd00B6E4	;641C
	bsr	RandomGen_BytewithOffset	;6100AB16
	move.b	d0,d1	;1200
	and.w	#$000C,d1	;0241000C
	bne.s	adrCd00B6E4	;6610
	and.w	#$0003,d0	;02400003
	beq.s	adrCd00B6E4	;670A
	subq.w	#$02,d0	;5540
	add.b	$0005(sp),d0	;D02F0005
	move.b	d0,$0005(sp)	;1F400005
adrCd00B6E4:	moveq	#$00,d0	;7000
adrCd00B6E6:	move.w	d0,-(sp)	;3F00
	bsr	adrCd00B806	;6100011C
	move.w	(sp)+,d0	;301F
	addq.w	#$01,d0	;5240
	cmp.w	#$0005,d0	;0C400005
	bcs.s	adrCd00B6E6	;65F0
	lea	$0012(sp),sp	;4FEF0012
	rts	;4E75

adrEA00B6FC:	dc.w	$0000	;0000
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
characters.heads:	dc.b	$0F	;0F
	dc.b	$10	;10
	dc.b	$0E	;0E
	dc.b	$0D	;0D
	dc.b	$01	;01
	dc.b	$0A	;0A
	dc.b	$07	;07
	dc.b	$06	;06
	dc.b	$02	;02
	dc.b	$0C	;0C
	dc.b	$03	;03
	dc.b	$05	;05
	dc.b	$00	;00
	dc.b	$0B	;0B
	dc.b	$08	;08
	dc.b	$04	;04
	dc.b	$04	;04
	dc.b	$05	;05
	dc.b	$06	;06
	dc.b	$03	;03
	dc.b	$10	;10
	dc.b	$07	;07
	dc.b	$03	;03
	dc.b	$11	;11
	dc.b	$11	;11
	dc.b	$11	;11
	dc.b	$11	;11
	dc.b	$11	;11
	dc.b	$04	;04
	dc.b	$04	;04
	dc.b	$04	;04
	dc.b	$0D	;0D
	dc.b	$0C	;0C
	dc.b	$0C	;0C
	dc.b	$0C	;0C
	dc.b	$0C	;0C
	dc.b	$0C	;0C
	dc.b	$03	;03
	dc.b	$03	;03
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$03	;03
	dc.b	$01	;01
	dc.b	$06	;06
	dc.b	$06	;06
	dc.b	$07	;07
	dc.b	$07	;07
	dc.b	$07	;07
	dc.b	$07	;07
	dc.b	$10	;10
	dc.b	$10	;10
	dc.b	$10	;10
	dc.b	$10	;10
	dc.b	$0B	;0B
	dc.b	$0B	;0B
	dc.b	$0B	;0B
	dc.b	$0B	;0B
	dc.b	$09	;09
	dc.b	$0C	;0C
	dc.b	$02	;02
	dc.b	$07	;07
	dc.b	$06	;06
	dc.b	$07	;07
	dc.b	$01	;01
	dc.b	$05	;05
	dc.b	$05	;05
	dc.b	$05	;05
	dc.b	$05	;05
	dc.b	$05	;05
	dc.b	$03	;03
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$03	;03
	dc.b	$0F	;0F
	dc.b	$0F	;0F
	dc.b	$0F	;0F
	dc.b	$0F	;0F
	dc.b	$0F	;0F
	dc.b	$0F	;0F
adrW_00B7DE:	dc.w	$00A0	;00A0
adrW_00B7E0:	dc.w	$00AC	;00AC
	dc.w	$00C4	;00C4
	dc.w	$00D0	;00D0
	dc.w	$00E8	;00E8
	dc.w	$00F4	;00F4
	dc.w	$010C	;010C
	dc.w	$0118	;0118
	dc.w	$010C	;010C
	dc.w	$0118	;0118
adrB_00B7F2:	dc.b	$00	;00
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

adrCd00B806:	move.w	d0,d2	;3400
	asl.w	#$02,d2	;E542
	move.w	adrW_00B7DE(pc,d2.w),d1	;323B20D2
	move.w	adrW_00B7E0(pc,d2.w),d3	;363B20D0
	move.l	$0010(sp),a0	;206F0010
	lea	$00(a0,d1.w),a1	;43F01000
	lea	$00(a0,d3.w),a2	;45F03000
	add.w	$000E(sp),a0	;D0EF000E
	add.w	$0006(sp),d2	;D46F0006
	moveq	#$00,d6	;7C00
	move.b	adrB_00B7F2(pc,d2.w),d2	;143B20C8
	bpl.s	adrCd00B830	;6A02
	subq.w	#$01,d6	;5346
adrCd00B830:	cmp.b	#$FF,d2	;0C0200FF
	bne.s	adrCd00B838	;6602
	rts	;4E75

adrCd00B838:	cmp.w	#$0003,d0	;0C400003
	bcs.s	adrCd00B84A	;650C
	move.w	d0,d1	;3200
	subq.w	#$03,d1	;5741
	btst	d1,-$0015(a3)	;032BFFEB
	beq.s	adrCd00B84A	;6702
	moveq	#$02,d2	;7402
adrCd00B84A:
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
	cmp.w	#$0002,d0	;0C400002
	bne.s	adrCd00B882	;6614
	move.b	-$0018(a3),d0	;102BFFE8
	mulu	#$0378,d0	;C0FC0378
	lea	$FFFFC190.l,a1	;43F9FFFFC190
	add.w	d0,d1	;D240
	add.w	d1,a1	;D2C1
	bra.s	adrCd00B892	;6010

adrCd00B882:	bcs.s	adrCd00B886	;6502
	moveq	#$02,d0	;7002
adrCd00B886:	move.l	$0014(sp),a1	;226F0014
	add.w	d0,d0	;D040
	add.w	$00(a1,d0.w),d1	;D2710000
	move.l	d1,a1	;2241
adrCd00B892:	move.w	$000C(sp),d5	;3A2F000C
	move.w	$000A(sp),d4	;382F000A
	move.w	$0004(sp),d0	;302F0004
	add.w	d0,d0	;D040
	add.b	$00(a0,d0.w),d4	;D8300000
	add.b	$01(a0,d0.w),d5	;DA300001
	lea	adrEA00BA78.l,a6	;4DF90000BA78
	cmp.w	#$0004,d0	;0C400004
	bcs.s	adrCd00B900	;654C
	bne.s	adrCd00B8BC	;6606
	moveq	#$00,d0	;7000
	bra	adrCd00B94C	;60000092

adrCd00B8BC:	move.w	$0004(sp),d1	;322F0004
	subq.w	#$03,d1	;5741
	btst	d1,-$0015(a3)	;032BFFEB
	beq.s	adrCd00B8FE	;6736
	move.w	$0008(sp),d1	;322F0008
	subq.w	#$06,d0	;5D40
	add.w	d0,d0	;D040
	lea	adrEA00B97E.l,a0	;41F90000B97E
	cmp.l	#adrEA016792,$0010(sp)	;0CAF000167920010
	bne.s	adrCd00B8E4	;6604
	add.w	#$0024,a0	;D0FC0024
adrCd00B8E4:	sub.b	$00(a0,d1.w),d5	;9A301000
	addq.w	#$04,a0	;5848
	asl.w	#$03,d1	;E741
	add.w	$0006(sp),d1	;D26F0006
	add.w	d1,d0	;D041
	add.b	$00(a0,d0.w),d4	;D8300000
	btst	#$00,d1	;08010000
	beq.s	adrCd00B8FE	;6702
	not.w	d6	;4646
adrCd00B8FE:	moveq	#$04,d0	;7004
adrCd00B900:	moveq	#$00,d1	;7200
	move.b	-$001C(a3),d1	;122BFFE4
	beq	adrCd00B948	;67000040
	subq.b	#$01,d1	;5301
	move.b	d1,d2	;1401
	asl.b	#$03,d1	;E701
	add.b	d2,d1	;D202
	asl.b	#$02,d1	;E501
	move.l	$0014(sp),a6	;2C6F0014
	addq.w	#$08,d1	;5041
	tst.w	-$0002(a6)	;4A6EFFFE
	bne.s	adrCd00B92A	;660A
	subq.w	#$04,d1	;5941
	cmp.w	#$2BE0,(a6)	;0C562BE0
	bne.s	adrCd00B92A	;6602
	subq.w	#$04,d1	;5941
adrCd00B92A:	lea	adrEA00BA28.l,a0	;41F90000BA28
	add.w	d1,a0	;D0C1
	move.w	d0,d1	;3200
	add.w	d1,d1	;D241
	add.w	d0,d1	;D240
	add.w	d1,d1	;D241
	cmp.b	#$FF,$00(a0,d1.w)	;0C3000FF1000
	beq.s	adrCd00B948	;6706
	bsr	adrCd00B9C6	;61000082
	bra.s	adrCd00B97A	;6032

adrCd00B948:	add.w	d0,d0	;D040
	addq.w	#$04,d0	;5840
adrCd00B94C:	moveq	#$00,d1	;7200
	move.b	-$0017(a3),d1	;122BFFE9
	move.w	d1,d2	;3401
	cmp.b	#$10,d1	;0C010010
	bcc.s	adrCd00B968	;640E
	asl.w	#$06,d1	;ED41
	lea	CharacterStats.l,a6	;4DF90000F586
	move.b	$01(a6,d1.w),d2	;14361001
	move.w	d2,d1	;3202
adrCd00B968:	asl.w	#$02,d1	;E541
	add.w	d2,d1	;D242
	add.w	d2,d1	;D242
	asl.w	#$02,d1	;E541
	add.w	d1,d0	;D041
	lea	CharacterColours.l,a6	;4DF900031E20
	add.w	d0,a6	;DCC0
adrCd00B97A:	bra	adrCd00BBC4	;60000248

adrEA00B97E:	dc.w	$0806	;0806
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

adrCd00B9C6:	lea	adrEA00C356.l,a6	;4DF90000C356
	move.l	$00(a0,d1.w),(a6)	;2CB01000
	move.b	-$001C(a3),d1	;122BFFE4
	rol.b	#$02,d1	;E519
	and.w	#$0003,d1	;02410003
	beq.s	adrCd00B9FE	;6722
	move.b	adrB_00BA24(pc,d1.w),d1	;123B1046
	moveq	#$03,d2	;7403
adrLp00B9E2:	move.b	d1,d3	;1601
	cmp.b	#$04,$00(a6,d2.w)	;0C3600042000
	beq.s	adrCd00B9F6	;670A
	subq.b	#$01,d3	;5303
	cmp.b	#$03,$00(a6,d2.w)	;0C3600032000
	bne.s	adrCd00B9FA	;6604
adrCd00B9F6:	move.b	d3,$00(a6,d2.w)	;1D832000
adrCd00B9FA:	dbra	d2,adrLp00B9E2	;51CAFFE6
adrCd00B9FE:	lea	adrEA00BA94.l,a0	;41F90000BA94
	move.b	-$0018(a3),d1	;122BFFE8
	asl.w	#$02,d1	;E541
	add.w	d1,a0	;D0C1
	moveq	#$03,d2	;7403
adrLp00BA0E:	move.b	$00(a6,d2.w),d1	;12362000
	bpl.s	adrCd00BA1E	;6A0A
	and.w	#$0003,d1	;02410003
	move.b	$00(a0,d1.w),$00(a6,d2.w)	;1DB010002000
adrCd00BA1E:	dbra	d2,adrLp00BA0E	;51CAFFEE
	rts	;4E75

adrB_00BA24:	dc.b	$00	;00
	dc.b	$08	;08
	dc.b	$06	;06
	dc.b	$0B	;0B
adrEA00BA28:	dc.w	$0B0A	;0B0A
	dc.w	$090B	;090B
	dc.w	$090A	;090A
	dc.w	$0B00	;0B00
	dc.w	$8283	;8283
	dc.w	$0000	;0000
	dc.w	$0B0A	;0B0A
	dc.w	$090B	;090B
	dc.w	$090A	;090A
	dc.w	$0B81	;0B81
	dc.w	$090A	;090A
	dc.w	$0B00	;0B00
	dc.w	$8109	;8109
	dc.w	$0A0B	;0A0B
	dc.w	$8009	;8009
	dc.w	$0A0B	;0A0B
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$0E04	;0E04
	dc.w	$0203	;0203
	dc.w	$8204	;8204
	dc.w	$0283	;0283
	dc.w	$8204	;8204
	dc.w	$830C	;830C
	dc.w	$0E04	;0E04
	dc.w	$0203	;0203
	dc.w	$8104	;8104
	dc.w	$0280	;0280
	dc.w	$0304	;0304
	dc.w	$0E00	;0E00
	dc.w	$8102	;8102
	dc.w	$040E	;040E
	dc.w	$8003	;8003
	dc.w	$040E	;040E
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$0E04	;0E04
	dc.w	$0303	;0303
	dc.w	$8204	;8204
	dc.w	$0483	;0483
adrEA00BA78:	dc.w	$0004	;0004
	dc.w	$080C	;080C
	dc.w	$0E04	;0E04
	dc.w	$0303	;0303
	dc.w	$8104	;8104
	dc.w	$0480	;0480
	dc.w	$0304	;0304
	dc.w	$0E00	;0E00
	dc.w	$8103	;8103
	dc.w	$040E	;040E
	dc.w	$8002	;8002
	dc.w	$040E	;040E
	dc.w	$0B03	;0B03
	dc.w	$0304	;0304
adrEA00BA94:	dc.w	$0B0A	;0B0A
	dc.w	$0708	;0708
	dc.w	$0605	;0605
	dc.w	$0B0D	;0B0D
	dc.w	$0B0A	;0B0A
	dc.w	$090C	;090C
	dc.w	$0605	;0605
	dc.w	$0506	;0506
	dc.w	$0B0A	;0B0A
	dc.w	$090C	;090C
	dc.w	$0E00	;0E00
	dc.w	$0B0D	;0B0D
	dc.w	$0B0A	;0B0A
	dc.w	$0506	;0506
	dc.w	$0B0A	;0B0A
	dc.w	$0708	;0708
	dc.w	$0B0A	;0B0A
	dc.w	$0B0D	;0B0D
	dc.w	$0B0A	;0B0A
	dc.w	$0506	;0506
	dc.w	$0B0A	;0B0A
	dc.w	$090C	;090C
	dc.w	$0B0A	;0B0A
	dc.w	$0506	;0506
	dc.w	$0000	;0000
	dc.w	$0708	;0708
	dc.w	$0900	;0900
	dc.w	$0708	;0708
	dc.w	$0900	;0900
	dc.w	$090C	;090C
	dc.w	$0804	;0804
	dc.w	$0404	;0404
adrEA00BAD4:	dc.w	$0B0A	;0B0A
	dc.w	$0B0D	;0B0D
	dc.w	$810A	;810A
	dc.w	$0909	;0909
	dc.w	$8102	;8102
	dc.w	$0482	;0482
adrEA00BAE0:	dc.w	$8103	;8103
	dc.w	$0482	;0482
	dc.w	$8209	;8209
	dc.w	$800A	;800A
	dc.w	$8204	;8204
	dc.w	$800E	;800E
	dc.w	$0004	;0004
	dc.w	$800C	;800C

adrCd00BAF0:	move.w	-$0002(a0),-(sp)	;3F28FFFE
	moveq	#$00,d3	;7600
	move.w	$0006(a0),d3	;36280006
	tst.w	(sp)	;4A57
	beq.s	adrCd00BB0E	;6710
	moveq	#$14,d7	;7E14
	move.w	#$00A8,d2	;343C00A8
	lea	adrEA0168C2.l,a0	;41F9000168C2
	bra	adrCd00BB4E	;60000042

adrCd00BB0E:	moveq	#$15,d7	;7E15
	move.w	#$00B0,d2	;343C00B0
	lea	adrEA016782.l,a0	;41F900016782
	bra	adrCd00BB4E	;60000032

adrCd00BB1E:	move.w	-$0002(a0),-(sp)	;3F28FFFE
	moveq	#$00,d3	;7600
	move.w	$0006(a0),d3	;36280006
	tst.w	(sp)	;4A57
	beq.s	adrCd00BB3E	;6712
	moveq	#$0F,d7	;7E0F
	move.w	#$0080,d2	;343C0080
	lea	adrEA0168CA.l,a0	;41F9000168CA
	add.w	#$01F8,d3	;064301F8
	bra.s	adrCd00BB4E	;6010

adrCd00BB3E:	moveq	#$10,d7	;7E10
	move.w	#$0088,d2	;343C0088
	lea	adrEA01678A.l,a0	;41F90001678A
	add.w	#$0210,d3	;06430210
adrCd00BB4E:	move.l	d3,a1	;2243
	add.w	d0,d0	;D040
	add.b	$00(a0,d0.w),d4	;D8300000
	add.b	$01(a0,d0.w),d5	;DA300001
	moveq	#$00,d6	;7C00
	cmp.w	#$0006,d0	;0C400006
	bne.s	adrCd00BB66	;6604
	subq.w	#$01,d6	;5346
	subq.w	#$04,d0	;5940
adrCd00BB66:	lsr.w	#$01,d0	;E248
	mulu	d0,d2	;C4C0
	add.w	d2,a1	;D2C2
	moveq	#$00,d1	;7200
	move.b	-$001C(a3),d1	;122BFFE4
	beq.s	adrCd00BB90	;671C
	and.w	#$0003,d1	;02410003
	asl.w	#$02,d1	;E541
	lea	adrEA00BAD4.l,a0	;41F90000BAD4
	tst.w	(sp)	;4A57
	beq.s	adrCd00BB8A	;6706
	lea	adrEA00BAE0.l,a0	;41F90000BAE0
adrCd00BB8A:	bsr	adrCd00B9C6	;6100FE3A
	bra.s	adrCd00BBBC	;602C

adrCd00BB90:	move.b	-$0017(a3),d1	;122BFFE9
	cmp.b	#$10,d1	;0C010010
	bcc.s	adrCd00BBAA	;6410
	asl.w	#$06,d1	;ED41
	lea	CharacterStats.l,a6	;4DF90000F586
	add.w	d1,a6	;DCC1
	moveq	#$00,d1	;7200
	move.b	$0001(a6),d1	;122E0001
adrCd00BBAA:	move.w	d1,d0	;3001
	asl.w	#$02,d1	;E541
	add.w	d0,d1	;D240
	add.w	d0,d1	;D240
	asl.w	#$02,d1	;E541
	lea	CharacterColours+$10.l,a6	;4DF900031E30
	add.w	d1,a6	;DCC1
adrCd00BBBC:	bsr.s	adrCd00BBC4	;6106
	add.w	#$0014,sp	;DEFC0014
	rts	;4E75

adrCd00BBC4:	
	add.l	#_GFX_Bodies,a1	;D3FC000364A0	;Long Addr replaced with Symbol  FIX

adrCd00BBCA:	
	move.w	d5,d0	;3005
	add.w	d7,d0	;D047
	sub.w	adrW_00BBFA.l,d0	;90790000BBFA
	bcs.s	adrCd00BBD8	;6502
	sub.w	d0,d7	;9E40
adrCd00BBD8:	swap	d7	;4847
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
	bsr.s	adrCd00BC26	;6130
	move.l	(sp)+,a3	;265F
	rts	;4E75

adrW_00BBFA:	dc.w	$004B	;004B

adrCd00BBFC:	lea	adrEA014BA4.l,a6	;4DF900014BA4
adrCd00BC02:	moveq	#$00,d2	;7400
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

adrCd00BC26:	and.w	#$000F,d4	;0244000F
	swap	d6	;4846
	move.w	d7,d6	;3C07
	moveq	#-$01,d5	;7AFF
	lsr.w	d4,d5	;E86D
	move.w	d5,d0	;3005
	swap	d5	;4845
	move.w	d0,d5	;3A00
	swap	d7	;4847
adrLp00BC3A:	swap	d7	;4847
	move.w	d6,d7	;3E06
	move.l	(a1)+,d0	;2019
	move.l	(a1)+,d1	;2219
	tst.l	d6	;4A86
	bpl.s	adrCd00BC52	;6A0C
	move.l	a6,a2	;244E
	bsr.s	adrCd00BBFC	;61B2
	exg	d0,d1	;C141
	bsr.s	adrCd00BC02	;61B4
	exg	d0,d1	;C141
	move.l	a2,a6	;2C4A
adrCd00BC52:	ror.l	d4,d0	;E8B8
	ror.l	d4,d1	;E8B9
	move.l	d0,a2	;2440
	move.l	d1,a3	;2641
	and.l	d5,d0	;C085
	and.l	d5,d1	;C285
	not.l	d5	;4685
	or.l	d5,d0	;8085
	or.l	d5,d1	;8285
	bsr	adrCd00BCA0	;6100003A
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
	bne.s	adrCd00BC88	;6604
	addq.w	#$02,a0	;5448
	bra.s	adrCd00BC8C	;6004

adrCd00BC88:	bsr	adrCd00BCA0	;61000016
adrCd00BC8C:	add.w	#$0024,a0	;D0FC0024
	swap	d7	;4847
	dbra	d7,adrLp00BC3A	;51CFFFA6
	rts	;4E75

adrCd00BC98:	cmp.w	#$0008,d6	;0C460008
	bcc.s	adrCd00BCEE	;6450
	bra.s	adrCd00BCAA	;600A

adrCd00BCA0:	cmp.w	#$0008,d7	;0C470008
	bcc.s	adrCd00BCEE	;6448
	bsr	adrCd00BE66	;610001BE
adrCd00BCAA:	move.l	d1,d2	;2401
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

adrCd00BCEE:	addq.w	#$02,a0	;5448
	rts	;4E75

adrW_00BCF2:	dc.w	$0000	;0000

adrCd00BCF4:	clr.w	adrW_00BCF2.l	;42790000BCF2
	bra.s	adrCd00BD04	;6008

adrCd00BCFC:	move.w	#$FFFF,adrW_00BCF2.l	;33FCFFFF0000BCF2
adrCd00BD04:	move.w	d4,d1	;3204
	and.w	#$FFF7,d4	;0244FFF7
	bsr	adrCd00E724	;61002A18
	move.w	d1,d4	;3801
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	d0,a0	;D0C0
	and.w	#$000F,d4	;0244000F
	moveq	#-$01,d5	;7AFF
	lsr.w	d4,d5	;E86D
	move.w	d5,d0	;3005
	swap	d5	;4845
	move.w	d0,d5	;3A00
	not.l	d5	;4685
	lea	adrEA00C356.l,a6	;4DF90000C356
adrLp00BD2E:	swap	d7	;4847
	move.w	d6,-(sp)	;3F06
	move.w	d7,-(sp)	;3F07
	move.l	d5,d2	;2405
	move.l	d5,d3	;2605
adrLp00BD38:	move.l	(a1)+,d0	;2019
	move.l	(a1)+,d1	;2219
	tst.w	adrW_00C354.l	;4A790000C354
	beq.s	adrCd00BD48	;6704
	bsr	adrCd00BE66	;61000120
adrCd00BD48:	ror.l	d4,d0	;E8B8
	ror.l	d4,d1	;E8B9
	move.l	d0,a2	;2440
	move.l	d1,a3	;2641
	not.l	d5	;4685
	and.l	d5,d0	;C085
	and.l	d5,d1	;C285
	not.l	d5	;4685
	or.l	d2,d0	;8082
	or.l	d3,d1	;8283
	bsr	adrCd00BC98	;6100FF3A
	addq.w	#$01,d6	;5246
	move.l	a2,d2	;240A
	move.l	a3,d3	;260B
	and.l	d5,d2	;C485
	and.l	d5,d3	;C685
	swap	d2	;4842
	swap	d3	;4843
	dbra	d7,adrLp00BD38	;51CFFFC8
	move.w	(sp)+,d7	;3E1F
	not.l	d5	;4685
	or.l	d5,d2	;8485
	or.l	d5,d3	;8685
	not.l	d5	;4685
	move.l	d2,d0	;2002
	move.l	d3,d1	;2203
	and.l	d3,d2	;C483
	addq.l	#$01,d2	;5282
	bne.s	adrCd00BD8A	;6604
	addq.w	#$02,a0	;5448
	bra.s	adrCd00BD8E	;6004

adrCd00BD8A:	bsr	adrCd00BC98	;6100FF0C
adrCd00BD8E:	move.w	d7,d0	;3007
	add.w	d0,d0	;D040
	tst.w	adrW_00BCF2.l	;4A790000BCF2
	beq.s	adrCd00BDA4	;670A
	add.w	#$0098,a1	;D2FC0098
	move.w	d0,d6	;3C00
	asl.w	#$02,d6	;E546
	sub.w	d6,a1	;92C6
adrCd00BDA4:	lea	$0024(a0),a0	;41E80024
	sub.w	d0,a0	;90C0
	move.w	(sp)+,d6	;3C1F
	swap	d7	;4847
	dbra	d7,adrLp00BD2E	;51CFFF7E
	rts	;4E75

adrCd00BDB4:	move.w	d4,d1	;3204
	and.w	#$FFF7,d4	;0244FFF7
	bsr	adrCd00E724	;61002968
	move.w	d1,d4	;3801
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	d0,a0	;D0C0
	and.w	#$000F,d4	;0244000F
	moveq	#-$01,d5	;7AFF
	lsr.w	d4,d5	;E86D
	move.w	d5,d0	;3005
	swap	d5	;4845
	move.w	d0,d5	;3A00
	not.l	d5	;4685
adrLp00BDD8:	swap	d7	;4847
	move.w	d6,-(sp)	;3F06
	move.w	d7,-(sp)	;3F07
	move.w	d7,d2	;3407
	addq.w	#$01,d2	;5242
	asl.w	#$03,d2	;E742
	add.w	d2,a1	;D2C2
	move.l	d5,d2	;2405
	move.l	d5,d3	;2605
adrLp00BDEA:	move.l	d2,a2	;2442
	move.l	-(a1),d0	;2021
	bsr	adrCd00BBFC	;6100FE0C
	move.l	d0,d1	;2200
	move.l	-(a1),d0	;2021
	bsr	adrCd00BC02	;6100FE0A
	move.l	a2,d2	;240A
	lea	adrEA00C356.l,a6	;4DF90000C356
	bsr	adrCd00BE66	;61000062
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
	bsr	adrCd00BC98	;6100FE7C
	addq.w	#$01,d6	;5246
	move.l	a2,d2	;240A
	move.l	a3,d3	;260B
	and.l	d5,d2	;C485
	and.l	d5,d3	;C685
	swap	d2	;4842
	swap	d3	;4843
	dbra	d7,adrLp00BDEA	;51CFFFBC
	move.w	(sp)+,d7	;3E1F
	not.l	d5	;4685
	or.l	d5,d2	;8485
	or.l	d5,d3	;8685
	not.l	d5	;4685
	move.l	d2,d0	;2002
	move.l	d3,d1	;2203
	and.l	d3,d2	;C483
	addq.l	#$01,d2	;5282
	bne.s	adrCd00BE48	;6604
	addq.w	#$02,a0	;5448
	bra.s	adrCd00BE4C	;6004

adrCd00BE48:	bsr	adrCd00BC98	;6100FE4E
adrCd00BE4C:	move.w	d7,d0	;3007
	addq.w	#$01,d0	;5240
	add.w	d0,d0	;D040
	lea	$0026(a0),a0	;41E80026
	sub.w	d0,a0	;90C0
	asl.w	#$02,d0	;E540
	add.w	d0,a1	;D2C0
	move.w	(sp)+,d6	;3C1F
	swap	d7	;4847
	dbra	d7,adrLp00BDD8	;51CFFF76
	rts	;4E75

adrCd00BE66:	movem.l	d2-d7,-(sp)	;48E73F00
	move.l	d0,d2	;2400
	swap	d2	;4842
	or.l	d0,d2	;8480
	not.l	d2	;4682
	beq.s	adrCd00BECC	;6758
	move.l	d0,-(sp)	;2F00
	moveq	#$00,d4	;7800
	moveq	#$00,d5	;7A00
	move.w	d5,d7	;3E05
	move.l	d1,d3	;2601
	swap	d3	;4843
	or.l	d1,d3	;8681
	not.l	d3	;4683
	and.l	d2,d3	;C682
	beq.s	adrCd00BE8A	;6702
	bsr.s	adrCd00BED2	;6148
adrCd00BE8A:	addq.w	#$01,d7	;5247
	move.l	d3,d0	;2003
	not.l	d0	;4680
	move.w	d1,d3	;3601
	swap	d3	;4843
	move.w	d1,d3	;3601
	not.l	d3	;4683
	and.l	d0,d3	;C680
	and.l	d2,d3	;C682
	beq.s	adrCd00BEA0	;6702
	bsr.s	adrCd00BED2	;6132
adrCd00BEA0:	addq.w	#$01,d7	;5247
	move.l	d1,d3	;2601
	swap	d1	;4841
	move.w	d1,d3	;3601
	not.l	d3	;4683
	and.l	d0,d3	;C680
	and.l	d2,d3	;C682
	beq.s	adrCd00BEB2	;6702
	bsr.s	adrCd00BED2	;6120
adrCd00BEB2:	addq.w	#$01,d7	;5247
	move.l	d1,d3	;2601
	swap	d1	;4841
	and.l	d1,d3	;C681
	and.l	d2,d3	;C682
	beq.s	adrCd00BEC0	;6702
	bsr.s	adrCd00BED2	;6112
adrCd00BEC0:	not.l	d2	;4682
	move.l	(sp)+,d0	;201F
	and.l	d2,d0	;C082
	or.l	d4,d0	;8084
	and.l	d2,d1	;C282
	or.l	d5,d1	;8285
adrCd00BECC:	movem.l	(sp)+,d2-d7	;4CDF00FC
	rts	;4E75

adrCd00BED2:	move.b	$00(a6,d7.w),d6	;1C367000
	beq.s	adrCd00BEF8	;6720
	add.w	d6,d6	;DC46
	add.w	d6,d6	;DC46
	and.w	#$000C,d6	;0246000C
	move.l	adrEA00BEFA(pc,d6.w),d6	;2C3B6018
	and.l	d3,d6	;CC83
	or.l	d6,d4	;8886
	move.b	$00(a6,d7.w),d6	;1C367000
	and.w	#$000C,d6	;0246000C
	move.l	adrEA00BEFA(pc,d6.w),d6	;2C3B6008
	and.l	d3,d6	;CC83
	or.l	d6,d5	;8A86
adrCd00BEF8:	rts	;4E75

adrEA00BEFA:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF

adrCd00BF0A:	tst.w	-$000C(a3)	;4A6BFFF4
	bne	adrCd00C13A	;6600022A
	move.w	d6,d0	;3006
	bsr	adrCd00C30A	;610003F4
	swap	d3	;4843
	move.l	a3,-(sp)	;2F0B
	bsr	adrCd00C376	;61000458
	move.l	(sp)+,a3	;265F
adrCd00BF22:	tst.b	-$0015(a3)	;4A2BFFEB
	beq.s	adrCd00BEF8	;67D0
	addq.b	#$01,-$0015(a3)	;522BFFEB
	beq	adrCd00C076	;67000148
	addq.b	#$01,-$0015(a3)	;522BFFEB
	beq	adrCd00BFD2	;6700009C
	addq.b	#$01,-$0015(a3)	;522BFFEB
	beq.s	adrCd00BF84	;6746
	lea	adrEA00C0BA.l,a0	;41F90000C0BA
	lea	adrEA00CCCC.l,a2	;45F90000CCCC
	lea	_GFX_Slots.l,a1	;43F900025188
	lea	SlotsColour.l,a6	;4DF90000C09A
	move.b	-$0012(a3),d1	;122BFFEE
	lsr.w	#$03,d1	;E649
	bsr	adrCd00C06A	;6100010C
	btst	#$02,-$0012(a3)	;082B0002FFEE
	beq.s	adrCd00BF6A	;6702
	clr.b	d0	;4200
adrCd00BF6A:	move.l	d0,adrEA00C356.l	;23C00000C356
	move.w	#$FFFF,adrW_00C354.l	;33FCFFFF0000C354
	bsr	adrCd00C2A6	;6100032C
	clr.w	adrW_00C354.l	;42790000C354
	rts	;4E75

adrCd00BF84:	lea	adrEA016A7C.l,a0	;41F900016A7C
	lea	adrEA00CD3C.l,a2	;45F90000CD3C
	lea	_GFX_Switches.l,a1	;43F900024ED0
	moveq	#$00,d0	;7000
	move.b	-$0012(a3),d1	;122BFFEE
	and.w	#$00F8,d1	;024100F8
	beq.s	adrCd00BFB8	;6716
	bsr	adrCd00C05C	;610000B8
	btst	#$02,-$0012(a3)	;082B0002FFEE
	beq.s	adrCd00BFB8	;670A
	and.w	#$00FF,d0	;024000FF
	swap	d0	;4840
	move.b	$02(a6,d1.w),d0	;10361002
adrCd00BFB8:	move.l	d0,adrEA00C356.l	;23C00000C356
	move.w	#$FFFF,adrW_00C354.l	;33FCFFFF0000C354
	bsr	adrCd00C2A6	;610002DE
	clr.w	adrW_00C354.l	;42790000C354
	rts	;4E75

adrCd00BFD2:	move.w	d6,-(sp)	;3F06
	lea	adrEA0169FE.l,a0	;41F9000169FE
	lea	adrEA00CBEC.l,a2	;45F90000CBEC
	lea	_GFX_Sign.l,a1	;43F9000226C0
	lea	adrEA00C0FA.l,a6	;4DF90000C0FA
	move.b	-$0012(a3),d1	;122BFFEE
	lsr.b	#$02,d1	;E409
	beq.s	adrCd00C002	;670E
	cmp.b	#$05,d1	;0C010005
	bcc.s	adrCd00C002	;6408
	subq.b	#$01,d1	;5301
	bsr	adrCd00C06A	;6100006C
	bra.s	adrCd00C004	;6002

adrCd00C002:	bsr.s	adrCd00C062	;615E
adrCd00C004:	move.l	d0,adrEA00C356.l	;23C00000C356
	move.w	#$FFFF,adrW_00C354.l	;33FCFFFF0000C354
	bsr	adrCd00C2A6	;61000292
	clr.w	adrW_00C354.l	;42790000C354
	move.w	(sp)+,d6	;3C1F
	move.b	-$0012(a3),d1	;122BFFEE
	lsr.b	#$02,d1	;E409
	beq.s	adrCd00C030	;670A
	cmp.b	#$05,d1	;0C010005
	bcc.s	adrCd00C05A	;642E
	subq.b	#$01,d1	;5301
	bra.s	adrCd00C03A	;600A

adrCd00C030:	move.b	-$0019(a3),d1	;122BFFE7
	add.w	d1,d1	;D241
	sub.b	-$001A(a3),d1	;922BFFE6
adrCd00C03A:	and.w	#$0003,d1	;02410003
	mulu	#$0610,d1	;C2FC0610
	lea	_GFX_SignOverlay.l,a1	;43F900023690
	add.w	d1,a1	;D2C1
	lea	adrEA00CC5C.l,a2	;45F90000CC5C
	lea	adrEA00C11A.l,a0	;41F90000C11A
	bsr	adrCd00C2A6	;6100024E
adrCd00C05A:	rts	;4E75

adrCd00C05C:	lea	adrEA00C0DA.l,a6	;4DF90000C0DA
adrCd00C062:	move.b	-$0019(a3),d1	;122BFFE7
	add.b	-$001A(a3),d1	;D22BFFE6
adrCd00C06A:	and.w	#$0007,d1	;02410007
	asl.w	#$02,d1	;E541
	move.l	$00(a6,d1.w),d0	;20361000
	rts	;4E75

adrCd00C076:	tst.b	-$001F(a3)	;4A2BFFE1
	bne.s	adrCd00C084	;6608
	btst	#$03,-$0011(a3)	;082B0003FFEF
	bne.s	adrCd00C05A	;66D6
adrCd00C084:	lea	adrEA0169DE.l,a0	;41F9000169DE
	lea	adrEA00CB7C.l,a2	;45F90000CB7C
	lea	_GFX_Shelf.l,a1	;43F900021E78
	bra	adrCd00C2A6	;6000020E

SlotsColour:
	dc.l	$00040506	;0004 0506
	dc.l	$00040B0D	;0004 0B0D
	dc.l	$0004090C	;0004 090C
	dc.l	$00040708	;0004 0708
	dc.l	$00040304	;0004 0304
	dc.l	$00040806	;0004 0806
	dc.l	$0004090A	;0004 090A
	dc.l	$00040A0B	;0004 0A0B

adrEA00C0BA:
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
adrEA00C0DA:	dc.w	$000D	;000D
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
	dc.w	$0C0B	;0C0B
	dc.w	$000D	;000D
	dc.w	$090A	;090A
adrEA00C0FA:	dc.w	$0005	;0005
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
adrEA00C11A:	dc.w	$0000	;0000
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

adrCd00C13A:	moveq	#$00,d0	;7000
	move.b	adrB_00C150(pc,d6.w),d0	;103B6012
	bsr	adrCd00C30A	;610001C8
	add.w	d3,a0	;D0C3
	swap	d3	;4843
	bsr	adrCd00C4FC	;610003B2
	bra	adrCd00BF22	;6000FDD4

adrB_00C150:	dc.b	$0C	;0C
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
adrB_00C16C:	dc.b	$01	;01
	dc.b	$09	;09
	dc.b	$04	;04
	dc.b	$06	;06
	dc.b	$0D	;0D
	dc.b	$0C	;0C
	dc.b	$07	;07
	dc.b	$0E	;0E

adrCd00C174:	cmp.b	#$01,-$0013(a3)	;0C2B0001FFED
	beq	adrCd00C21A	;6700009E
	move.w	#$FFFF,adrW_00C354.l	;33FCFFFF0000C354
	move.l	#$0004000C,adrEA00C356.l	;23FC0004000C0000C356	;Long Addr replaced with Symbol
	moveq	#$00,d0	;7000
	move.b	-$0012(a3),d0	;102BFFEE
	btst	#$03,d0	;08000003
	bne.s	adrCd00C1A8	;660C
	lsr.b	#$04,d0	;E808
	move.b	adrB_00C16C(pc,d0.w),d0	;103B00CC
	move.b	d0,adrB_00C358.l	;13C00000C358
adrCd00C1A8:	lea	adrEA016A62.l,a0	;41F900016A62
	lea	adrEA00CAE4.l,a2	;45F90000CAE4
	lea	_GFX_LargeOpenDoor.l,a1	;43F90002A048
	btst	#$00,-$0012(a3)	;082B0000FFEE
	beq.s	adrCd00C1D6	;6714
	lea	_GFX_LargeMetalDoor.l,a1	;43F90002BBB0
	btst	#$01,-$0012(a3)	;082B0001FFEE
	beq.s	adrCd00C1D6	;6706
	lea	_GFX_PortCullis.l,a1	;43F90002D038
adrCd00C1D6:	move.b	-$0016(a3),d6	;1C2BFFEA
	cmp.b	#$0E,d6	;0C06000E
	bcc.s	adrCd00C1E6	;6406
	bsr	adrCd00A384	;6100E1A2
	bra.s	adrCd00C20A	;6024

adrCd00C1E6:	move.w	d6,d0	;3006
	subq.w	#$07,d0	;5F40
	cmp.w	#$000B,d0	;0C40000B
	bne.s	adrCd00C206	;6616
	move.w	-$000A(a3),d1	;322BFFF6
	asl.w	#$02,d1	;E541
	eor.b	d1,-$0012(a3)	;B32BFFEE
	btst	#$02,-$0012(a3)	;082B0002FFEE
	beq.s	adrCd00C206	;6704
	addq.w	#$01,d6	;5246
	addq.w	#$01,d0	;5240
adrCd00C206:	bsr	adrCd00C2EE	;610000E6
adrCd00C20A:	clr.w	adrW_00C354.l	;42790000C354
	tst.b	-$0011(a3)	;4A2BFFEF
	bmi	adrCd00A72E	;6B00E518
	rts	;4E75

adrCd00C21A:	lea	_GFX_StairsUp.l,a1	;43F900027520
	lea	adrEA016A1E.l,a0	;41F900016A1E
	lea	adrEA00C9B4.l,a2	;45F90000C9B4
	btst	#$00,-$0012(a3)	;082B0000FFEE
	beq.s	adrCd00C246	;6712
	lea	_GFX_StairsDown.l,a1	;43F9000293C8
	lea	adrEA016A40.l,a0	;41F900016A40
	lea	adrEA00CA28.l,a2	;45F90000CA28
adrCd00C246:	cmp.b	#$0E,-$0016(a3)	;0C2B000EFFEA
	bcs.s	adrCd00C262	;6514
	beq.s	adrCd00C264	;6714
	move.b	-$0016(a3),d6	;1C2BFFEA
	move.w	d6,d0	;3006
	add.w	#$000A,d6	;0646000A
	subq.w	#$02,d0	;5540
	bsr	adrCd00C2EE	;61000090
	bra.s	adrCd00C264	;6002

adrCd00C262:	bsr.s	adrCd00C2A6	;6142
adrCd00C264:	tst.b	-$0011(a3)	;4A2BFFEF
	bmi	adrCd00A72E	;6B00E4C4
	rts	;4E75

adrCd00C26E:	lea	_GFX_WoodWall.l,a1	;43F90001C368
	lea	adrEA0169BE.l,a0	;41F9000169BE
	lea	adrEA00C944.l,a2	;45F90000C944
	tst.b	-$0014(a3)	;4A2BFFEC
	beq.s	adrCd00C2A4	;671E
	add.w	#$2498,a1	;D2FC2498
	bsr.s	adrCd00C2A6	;611A
	tst.b	-$0015(a3)	;4A2BFFEB
	beq.s	adrCd00C2C2	;6730
	lea	adrEA01699E.l,a0	;41F90001699E
	lea	adrEA00CE44.l,a2	;45F90000CE44
	lea	_GFX_WoodDoors.l,a1	;43F900020C98
adrCd00C2A4:	nop	;4E71
adrCd00C2A6:	moveq	#$00,d0	;7000
	move.b	adrB_00C2D2(pc,d6.w),d0	;103B6028
	bmi.s	adrCd00C2C4	;6B16
	cmp.b	#$0C,d0	;0C00000C
	bcc	adrCd00C2EE	;6400003A
	bsr.s	adrCd00C31C	;6164
	swap	d3	;4843
	move.l	a3,-(sp)	;2F0B
	bsr	adrCd00C460	;610001A2
	move.l	(sp)+,a3	;265F
adrCd00C2C2:	rts	;4E75

adrCd00C2C4:	and.w	#$007F,d0	;0240007F
	bsr.s	adrCd00C31C	;6152
	add.w	d3,a0	;D0C3
	swap	d3	;4843
	bra	adrLp00C604	;60000334

adrB_00C2D2:	dc.b	$00	;00
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

adrCd00C2EE:	bsr.s	adrCd00C31C	;612C
	swap	d3	;4843
	movem.l	d1/d3/d5/a0/a1/a3,-(sp)	;48E754D0
	bsr	adrCd00C460	;61000168
	movem.l	(sp)+,d1/d3/d5/a0/a1/a3	;4CDF0B2A
	add.w	#$0010,a0	;D0FC0010
	add.w	d1,d1	;D241
	sub.w	d1,a0	;90C1
	bra	adrLp00C604	;600002FC

adrCd00C30A:	lea	adrEA00C8D4.l,a2	;45F90000C8D4
	lea	adrEA01692C.l,a0	;41F90001692C
	lea	_GFX_MainWalls.l,a1	;43F900017A38
adrCd00C31C:	add.w	d0,d0	;D040
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

adrW_00C354:	dc.w	$0000	;0000
adrEA00C356:	dc.w	$0004	;0004
adrB_00C358:	dc.b	$08	;08
	dc.b	$0C	;0C
adrEA00C35A:	dc.w	$0105	;0105
	dc.w	$0705	;0705
	dc.w	$0101	;0101
	dc.w	$0601	;0601
	dc.w	$0205	;0205
	dc.w	$0101	;0101
	dc.w	$0105	;0105
	dc.w	$0705	;0705
	dc.w	$0101	;0101
	dc.w	$0301	;0301
	dc.w	$0505	;0505
	dc.w	$0101	;0101
	dc.w	$0707	;0707
	dc.w	$0207	;0207

adrCd00C376:	lea	adrEA00C35A.l,a2	;45F90000C35A
	add.w	d6,a2	;D4C6
	btst	#$01,(a2)	;08120001
	beq	adrCd00C460	;670000DC
	swap	d6	;4846
	btst	#$00,(a2)	;08120000
	beq.s	adrCd00C390	;6702
	bsr.s	adrCd00C3F6	;6166
adrCd00C390:	move.b	(a2),d6	;1C12
	and.w	#$0007,d6	;02460007
	swap	d3	;4843
	moveq	#$28,d2	;7428
	sub.w	d3,d2	;9443
	swap	d3	;4843
	move.w	d5,d4	;3805
	swap	d5	;4845
	move.b	adrB_00C3EE(pc,d6.w),d6	;1C3B604A
	sub.w	d6,d5	;9A46
	add.w	d6,d6	;DC46
	add.w	d6,d2	;D446
	movem.l	a0/a1,-(sp)	;48E700C0
adrLp00C3B0:	move.w	d5,d3	;3605
adrLp00C3B2:	move.w	(a1)+,(a0)+	;30D9
	move.w	(a1)+,$1F3E(a0)	;31591F3E
	move.w	(a1)+,$3E7E(a0)	;31593E7E
	move.w	(a1)+,$5DBE(a0)	;31595DBE
	dbra	d3,adrLp00C3B2	;51CBFFF0
	move.w	d6,d3	;3606
	asl.w	#$02,d3	;E543
	add.w	d3,a1	;D2C3
	add.w	d2,a0	;D0C2
	dbra	d4,adrLp00C3B0	;51CCFFE2
	movem.l	(sp)+,a0/a1	;4CDF0300
	swap	d5	;4845
	swap	d3	;4843
	sub.w	d3,d6	;9C43
	sub.w	d6,a0	;90C6
	asl.w	#$02,d6	;E546
	sub.w	d6,a1	;92C6
	swap	d3	;4843
	btst	#$02,(a2)	;08120002
	beq.s	adrCd00C3EA	;6702
	bsr.s	adrCd00C3F6	;610C
adrCd00C3EA:	swap	d6	;4846
	rts	;4E75

adrB_00C3EE:	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02

adrCd00C3F6:	movem.l	a0/a1,-(sp)	;48E700C0
	swap	d3	;4843
	move.w	d3,d6	;3C03
	subq.w	#$02,d6	;5546
	asl.w	#$02,d6	;E546
	swap	d3	;4843
	move.w	d5,d3	;3605
adrLp00C406:	move.l	(a1)+,d0	;2019
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
	dbra	d3,adrLp00C406	;51CBFFB2
	movem.l	(sp)+,a0/a1	;4CDF0300
	addq.w	#$02,a0	;5448
	addq.w	#$08,a1	;5049
	rts	;4E75

adrCd00C460:	sub.w	a3,a3	;96CB
adrLp00C462:	swap	d5	;4845
	move.w	d5,d3	;3605
adrLp00C466:	move.l	(a1)+,d0	;2019
	move.l	(a1)+,d1	;2219
	tst.w	adrW_00C354.l	;4A790000C354
	beq.s	adrCd00C47C	;670A
	lea	adrEA00C356.l,a6	;4DF90000C356
	bsr	adrCd00BE66	;6100F9EC
adrCd00C47C:	move.l	d1,d2	;2401
	and.l	d0,d2	;C480
	addq.l	#$01,d2	;5282
	beq.s	adrCd00C4C6	;6742
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
	bra.s	adrCd00C4C8	;6002

adrCd00C4C6:	addq.w	#$02,a0	;5448
adrCd00C4C8:	dbra	d3,adrLp00C466	;51CBFF9C
	swap	d3	;4843
	sub.w	d3,a0	;90C3
	swap	d3	;4843
	add.w	#$0028,a0	;D0FC0028
	add.w	a3,a1	;D2CB
	swap	d5	;4845
	dbra	d5,adrLp00C462	;51CDFF86
	rts	;4E75

adrEA00C4E0:	dc.w	$0105	;0105
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

adrCd00C4FC:	lea	adrEA00C4E0.l,a2	;45F90000C4E0
	add.w	d6,a2	;D4C6
	btst	#$01,(a2)	;08120001
	beq	adrLp00C604	;670000FA
	swap	d6	;4846
	btst	#$00,(a2)	;08120000
	beq.s	adrCd00C516	;6702
	bsr.s	adrCd00C590	;617A
adrCd00C516:	movem.l	d7/a0/a1,-(sp)	;48E701C0
	move.b	(a2),d6	;1C12
	and.w	#$0007,d6	;02460007
	swap	d3	;4843
	move.w	#$0028,d7	;3E3C0028
	add.w	d3,d7	;DE43
	swap	d3	;4843
	move.w	d5,d4	;3805
	swap	d5	;4845
	move.b	adrB_00C588(pc,d6.w),d6	;1C3B6058
	sub.w	d6,d5	;9A46
	add.w	d6,d6	;DC46
	sub.w	d6,d7	;9E46
adrLp00C538:	move.w	d5,d3	;3605
adrLp00C53A:	move.l	(a1)+,d1	;2219
	move.l	(a1)+,d0	;2019
	bsr	adrCd00BBFC	;6100F6BC
	exg	d0,d1	;C141
	bsr	adrCd00BBFC	;6100F6B6
	move.w	d1,$5DBE(a0)	;31415DBE
	swap	d1	;4841
	move.w	d1,$3E7E(a0)	;31413E7E
	move.w	d0,$1F3E(a0)	;31401F3E
	swap	d0	;4840
	move.w	d0,-(a0)	;3100
	dbra	d3,adrLp00C53A	;51CBFFDE
	move.w	d6,d3	;3606
	asl.w	#$02,d3	;E543
	add.w	d3,a1	;D2C3
	add.w	d7,a0	;D0C7
	dbra	d4,adrLp00C538	;51CCFFD0
	movem.l	(sp)+,d7/a0/a1	;4CDF0380
	swap	d5	;4845
	swap	d3	;4843
	sub.w	d3,d6	;9C43
	add.w	d6,a0	;D0C6
	asl.w	#$02,d6	;E546
	sub.w	d6,a1	;92C6
	swap	d3	;4843
	btst	#$02,(a2)	;08120002
	beq.s	adrCd00C584	;6702
	bsr.s	adrCd00C590	;610C
adrCd00C584:	swap	d6	;4846
	rts	;4E75

adrB_00C588:	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02

adrCd00C590:	movem.l	a0/a1,-(sp)	;48E700C0
	swap	d3	;4843
	move.w	d3,d6	;3C03
	subq.w	#$02,d6	;5546
	asl.w	#$02,d6	;E546
	swap	d3	;4843
	move.w	d5,d3	;3605
adrLp00C5A0:	move.l	(a1)+,d1	;2219
	move.l	(a1)+,d0	;2019
	bsr	adrCd00BBFC	;6100F656
	exg	d0,d1	;C141
	bsr	adrCd00BBFC	;6100F650
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
	dbra	d3,adrLp00C5A0	;51CBFFA8
	movem.l	(sp)+,a0/a1	;4CDF0300
	subq.w	#$02,a0	;5548
	addq.w	#$08,a1	;5049
	rts	;4E75

adrLp00C604:	swap	d5	;4845
	move.w	d5,d3	;3605
adrLp00C608:	move.l	(a1)+,d1	;2219
	move.l	(a1)+,d0	;2019
	bsr	adrCd00BBFC	;6100F5EE
	exg	d0,d1	;C141
	bsr	adrCd00BBFC	;6100F5E8
	tst.w	adrW_00C354.l	;4A790000C354
	beq.s	adrCd00C628	;670A
	lea	adrEA00C356.l,a6	;4DF90000C356
	bsr	adrCd00BE66	;6100F840
adrCd00C628:	move.l	d1,d2	;2401
	and.l	d0,d2	;C480
	addq.l	#$01,d2	;5282
	beq.s	adrCd00C672	;6742
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
	bra.s	adrCd00C674	;6002

adrCd00C672:	subq.w	#$02,a0	;5548
adrCd00C674:	dbra	d3,adrLp00C608	;51CBFF92
	swap	d3	;4843
	add.w	d3,a0	;D0C3
	swap	d3	;4843
	add.w	#$0028,a0	;D0FC0028
	swap	d5	;4845
	dbra	d5,adrLp00C604	;51CDFF7E
	rts	;4E75

adrCd00C68A:	lea	_GFX_FloorCeiling.l,a1	;43F90002EB08
	move.l	-$0008(a3),a0	;206BFFF8
	tst.w	-$000C(a3)	;4A6BFFF4
	beq.s	adrCd00C6FA	;6760
	moveq	#$16,d0	;7016
	bsr.s	adrLp00C6A2	;6104
	bsr.s	adrCd00C6C0	;6120
	moveq	#$21,d0	;7021
adrLp00C6A2:	moveq	#$07,d1	;7207
adrLp00C6A4:	move.w	(a1)+,(a0)+	;30D9
	move.w	(a1)+,$1F3E(a0)	;31591F3E
	move.w	(a1)+,$3E7E(a0)	;31593E7E
	move.w	(a1)+,$5DBE(a0)	;31595DBE
	dbra	d1,adrLp00C6A4	;51C9FFF0
	lea	$0018(a0),a0	;41E80018
	dbra	d0,adrLp00C6A2	;51C8FFE6
	rts	;4E75

adrCd00C6C0:	moveq	#$12,d0	;7012
	moveq	#$00,d1	;7200
adrLp00C6C4:	lea	$1F40(a0),a2	;45E81F40
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
	dbra	d0,adrLp00C6C4	;51C8FFCE
	rts	;4E75

adrCd00C6FA:	lea	adrEA014BA4.l,a6	;4DF900014BA4
	lea	$0010(a0),a0	;41E80010
	moveq	#$16,d7	;7E16
	bsr.s	adrLp00C714	;610C
	sub.w	#$0010,a0	;90FC0010
	bsr.s	adrCd00C6C0	;61B2
	lea	$0010(a0),a0	;41E80010
	moveq	#$21,d7	;7E21
adrLp00C714:	moveq	#$07,d3	;7607
adrLp00C716:	move.l	(a1)+,d0	;2019
	bsr	adrCd00BC02	;6100F4E8
	move.l	d0,d1	;2200
	move.l	(a1)+,d0	;2019
	bsr	adrCd00BC02	;6100F4E0
	move.w	d0,$5DBE(a0)	;31405DBE
	swap	d0	;4840
	move.w	d0,$3E7E(a0)	;31403E7E
	move.w	d1,$1F3E(a0)	;31411F3E
	swap	d1	;4841
	move.w	d1,-(a0)	;3101
	dbra	d3,adrLp00C716	;51CBFFDE
	lea	$0038(a0),a0	;41E80038
	dbra	d7,adrLp00C714	;51CFFFD4
	rts	;4E75

adrEA00C744:	dc.w	$FEFC	;FEFC
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
adrEA00C824:	dc.w	$08D5	;08D5
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
adrEA00C870:	dc.w	$0880	;0880
	dc.w	$0800	;0800
adrEA00C874:	dc.w	$0002	;0002
	dc.w	$FF06	;FF06
	dc.w	$080A	;080A
	dc.w	$FF0C	;FF0C
	dc.w	$0EFF	;0EFF
	dc.w	$1214	;1214
	dc.w	$16FF	;16FF
	dc.w	$1819	;1819
	dc.w	$1A1B	;1A1B
	dc.w	$FF00	;FF00
adrEA00C888:	dc.w	$FFFF	;FFFF
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
adrEA00C8D4:	dc.w	$0015	;0015
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
adrEA00C944:	dc.w	$0015	;0015
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
adrEA00C9B4:	dc.w	$0000	;0000
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
adrEA00CA28:	dc.w	$0000	;0000
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
adrEA00CA9C:	dc.w	$0016	;0016
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
adrEA00CAE4:	dc.w	$0000	;0000
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
adrEA00CB34:	dc.w	$0000	;0000
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
adrEA00CB7C:	dc.w	$001C	;001C
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
adrEA00CBEC:	dc.w	$001A	;001A
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
adrEA00CC5C:	dc.w	$001D	;001D
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
adrEA00CCCC:	dc.w	$001D	;001D
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
adrEA00CD3C:	dc.w	$0000	;0000
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
adrEA00CDAC:	dc.w	$002A	;002A
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
adrEA00CDF8:	dc.w	$0016	;0016
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
adrEA00CE44:	dc.w	$0018	;0018
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

Click_TurnSpellBookPage:	tst.w	$0024(a5)	;4A6D0024
	bne	adrCd006244	;6600938A
	tst.b	$000F(a5)	;4A2D000F
	bpl.s	adrCd00CEEE	;6A2C
	tst.b	$000E(a5)	;4A2D000E
	bmi.s	adrCd00CED8	;6B10
	addq.w	#$02,$002A(a5)	;546D002A
	and.w	#$0007,$002A(a5)	;026D0007002A
	move.w	#$FFFF,$000E(a5)	;3B7CFFFF000E
adrCd00CED8:	tst.b	adrB_00F988.l	;4A390000F988
	beq.s	adrCd00CEE6	;6706
	move.w	#$0002,$0014(a5)	;3B7C00020014
adrCd00CEE6:	bsr	adrCd00D0C0	;610001D8
	bra	adrCd00D156	;6000026A

adrCd00CEEE:	bsr	adrCd00D0C0	;610001D0
	move.w	$002A(a5),d0	;302D002A
	bsr	adrCd00D162	;6100026A
	move.w	$000E(a5),d1	;322D000E
	bpl.s	adrCd00CF04	;6A04
	eor.w	#$0003,d1	;0A410003
adrCd00CF04:	and.w	#$0003,d1	;02410003
	move.w	$002A(a5),d0	;302D002A
	cmp.w	#$0003,d1	;0C410003
	bne.s	adrCd00CF68	;6656
	addq.w	#$01,d0	;5240
	bsr	adrCd00D162	;6100024C
	move.w	$002A(a5),d0	;302D002A
	addq.w	#$03,d0	;5640
	and.w	#$0007,d0	;02400007
	move.w	d0,d7	;3E00
	asl.w	#$04,d0	;E940
	lea	SpellBook_Runes+$3.l,a6	;4DF9000165D5
	add.w	d0,a6	;DCC0
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	#$0436,a0	;D0FC0436
	add.w	$000A(a5),a0	;D0ED000A
	move.l	a4,a3	;264C
	move.w	d7,d0	;3007
	lsr.w	#$01,d0	;E248
	add.w	d0,a3	;D6C0
	asl.w	#$02,d7	;E547
	swap	d7	;4847
	move.w	#$0003,d7	;3E3C0003
adrLp00CF4C:	bsr	adrCd00D1FE	;610002B0
	move.w	d6,adrW_00E3FA.l	;33C60000E3FA
	move.b	(a6),d0	;1016
	bsr	adrCd00E390	;61001436
	addq.w	#$04,a6	;584E
	lea	$013F(a0),a0	;41E8013F
	dbra	d7,adrLp00CF4C	;51CFFFE8
	bra.s	adrCd00CF72	;600A

adrCd00CF68:	addq.w	#$03,d0	;5640
	and.w	#$0007,d0	;02400007
	bsr	adrCd00D162	;610001F2
adrCd00CF72:	move.w	$002A(a5),d7	;3E2D002A
	addq.w	#$02,d7	;5447
	and.w	#$0007,d7	;02470007
	move.w	d7,d0	;3007
	lsr.w	#$01,d0	;E248
	move.l	a4,a3	;264C
	add.w	d0,a3	;D6C0
	asl.w	#$02,d7	;E547
	swap	d7	;4847
	move.w	#$0007,d7	;3E3C0007
	lea	adrEA00C356.l,a6	;4DF90000C356
	moveq	#$03,d5	;7A03
adrLp00CF94:	bsr	adrCd00D1FE	;61000268
	move.b	d6,(a6)+	;1CC6
	subq.w	#$01,d7	;5347
	dbra	d5,adrLp00CF94	;51CDFFF6
	move.w	$000E(a5),d0	;302D000E
	bpl.s	adrCd00CFAA	;6A04
	eor.w	#$0003,d0	;0A400003
adrCd00CFAA:	and.w	#$0003,d0	;02400003
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	#$0186,a0	;D0FC0186
	add.w	$000A(a5),a0	;D0ED000A
	lea	_GFX_Pockets+$4130.l,a1	;43F90004D5E2
	add.w	d0,d0	;D040
	add.w	d0,a0	;D0C0
	asl.w	#$03,d0	;E740
	add.w	d0,a1	;D2C0
	move.l	#$00010037,d5	;2A3C00010037	;Long Addr replaced with Symbol
	move.w	#$0004,d3	;363C0004
	swap	d3	;4843
	move.l	#$00000090,a3	;267C00000090
	move.w	#$FFFF,adrW_00C354.l	;33FCFFFF0000C354
	bsr	adrLp00C462	;6100F47C
	clr.w	adrW_00C354.l	;42790000C354
	tst.b	adrB_00F988.l	;4A390000F988
	beq.s	adrCd00D000	;670A
	subq.b	#$01,$000F(a5)	;532D000F
	move.w	#$0006,$0022(a5)	;3B7C00060022
adrCd00D000:	rts	;4E75

adrCd00D002:	cmp.w	#$0002,$0014(a5)	;0C6D00020014
	bne.s	adrCd00D04C	;6642
	move.l	$0002(a5),d1	;222D0002
	sub.w	$0008(a5),d1	;926D0008
	sub.w	#$0018,d1	;04410018
	bcs.s	adrCd00D050	;6538
	cmp.w	#$0020,d1	;0C410020
	bcc.s	adrCd00D04C	;642E
	swap	d1	;4841
	sub.w	#$00E8,d1	;044100E8
	bcs.s	adrCd00D04C	;6526
	moveq	#$00,d0	;7000
	sub.w	#$0020,d1	;04410020
	bcs.s	adrCd00D036	;6508
	sub.w	#$0010,d1	;04410010
	bcs.s	adrCd00D04C	;6518
	addq.w	#$04,d0	;5840
adrCd00D036:	swap	d1	;4841
	lsr.w	#$03,d1	;E649
	add.w	d1,d0	;D041
	eor.w	#$0007,d0	;0A400007
	move.w	#$0005,$000C(a5)	;3B7C0005000C
	move.w	d0,$000E(a5)	;3B40000E
	moveq	#$00,d2	;7400
adrCd00D04C:	tst.w	d2	;4A42
	rts	;4E75

adrCd00D050:	add.w	#$0018,d1	;06410018
	cmp.w	#$0007,d1	;0C410007
	bcs.s	adrCd00D0BC	;6562
	cmp.w	#$0010,d1	;0C410010
	bcc.s	adrCd00D0BC	;645C
	swap	d1	;4841
	cmp.w	#$00E8,d1	;0C4100E8
	bcs.s	adrCd00D0BC	;6554
	moveq	#$06,d0	;7006
	cmp.w	#$00F8,d1	;0C4100F8
	bcs.s	adrCd00D08C	;651C
	cmp.w	#$0100,d1	;0C410100
	bcs.s	adrCd00D0BC	;6546
	moveq	#$07,d0	;7007
	cmp.w	#$0120,d1	;0C410120
	bcs.s	adrCd00D08C	;650E
	cmp.w	#$0128,d1	;0C410128
	bcs.s	adrCd00D0BC	;6538
	moveq	#$08,d0	;7008
	cmp.w	#$0138,d1	;0C410138
	bcc.s	adrCd00D0BC	;6430
adrCd00D08C:	move.w	d0,$000C(a5)	;3B40000C
	moveq	#$03,d2	;7403
	cmp.w	#$0006,d0	;0C400006
	bne.s	adrCd00D0A6	;660E
	subq.w	#$02,$002A(a5)	;556D002A
	and.w	#$0007,$002A(a5)	;026D0007002A
	move.w	#$8003,d2	;343C8003
adrCd00D0A6:	rol.w	#$08,d0	;E158
	move.b	#$03,d0	;103C0003
	move.w	d0,$0014(a5)	;3B400014
	move.w	d2,$000E(a5)	;3B42000E
	move.w	#$0008,$0022(a5)	;3B7C00080022
	move.w	d0,d2	;3400
adrCd00D0BC:	tst.w	d2	;4A42
	rts	;4E75

adrCd00D0C0:	move.w	$0006(a5),d7	;3E2D0006
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	#$0184,a0	;D0FC0184
	add.w	$000A(a5),a0	;D0ED000A
	move.l	#$00000070,a3	;267C00000070
	move.l	#$0005003D,d5	;2A3C0005003D	;Long Addr replaced with Symbol
	lea	_GFX_Pockets+$4100.l,a1	;43F90004D5B2
	bsr	adrCd00D60C	;61000526
	asl.w	#$06,d7	;ED47
	lea	CharacterStats.l,a4	;49F90000F586
	add.w	d7,a4	;D8C7
	rts	;4E75

adrCd00D0F4:	move.l	#$005E00E0,d4	;283C005E00E0
	move.l	#$00480009,d5	;2A3C00480009
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$00,d3	;7600
	bra	adrCd00E538	;60001430

adrCd00D10A:	move.l	screen_ptr.l,a0	;207900009B06
	add.w	#$0E2C,a0	;D0FC0E2C
	add.w	$000A(a5),a0	;D0ED000A
adrCd00D118:	bsr	adrCd0072D0	;6100A1B6
	or.b	#$0C,$0054(a5)	;002D000C0054
	move.b	$000C(a4),d0	;102C000C
	bsr	adrCd00D8DA	;610007B2
	move.b	$000D(a4),d0	;102C000D
	lea	adrEA00F45C.l,a6	;4DF90000F45C
	move.b	d1,$000E(a6)	;1D41000E
	ror.w	#$08,d1	;E059
	move.b	d1,$000D(a6)	;1D41000D
	bsr	adrCd00D8DA	;6100079A
	move.w	d1,$0010(a6)	;3D410010
	bra	adrCd00DAA6	;6000095E

;fiX Label expected
	bsr.s	adrCd00D0F4	;61A8
	bsr	adrCd00D0C0	;6100FF72
	lea	$00A0(a0),a0	;41E800A0
	bsr.s	adrCd00D118	;61C2
adrCd00D156:	move.w	$002A(a5),d0	;302D002A
	bsr.s	adrCd00D162	;6106
	move.w	$002A(a5),d0	;302D002A
	addq.w	#$01,d0	;5240
adrCd00D162:	or.b	#$04,$0054(a5)	;002D00040054
	move.w	d0,d7	;3E00
	asl.w	#$04,d0	;E940
	lea	SpellBook_Runes.l,a6	;4DF9000165D2
	add.w	d0,a6	;DCC0
	move.l	screen_ptr.l,a0	;207900009B06
	lea	$042D(a0),a0	;41E8042D
	add.w	$000A(a5),a0	;D0ED000A
	move.w	#$0003,adrW_00E3FC.l	;33FC00030000E3FC
	move.w	d7,d0	;3007
	lsr.w	#$01,d0	;E248
	move.l	a4,a3	;264C
	add.w	d0,a3	;D6C0
	move.w	d7,d0	;3007
	asl.w	#$02,d7	;E547
	swap	d7	;4847
	and.w	#$0001,d0	;02400001
	bne.s	adrCd00D1CE	;6630
	move.w	#$0007,d7	;3E3C0007
adrCd00D1A2:	bsr.s	adrCd00D1FE	;615A
	move.w	d6,adrW_00E3FA.l	;33C60000E3FA
	moveq	#$02,d6	;7C02
adrLp00D1AC:	move.b	(a6)+,d0	;101E
	bsr	adrCd00E390	;610011E0
	dbra	d6,adrLp00D1AC	;51CEFFF8
	sub.w	#$0028,a0	;90FC0028
	move.b	(a6)+,d0	;101E
	bsr	adrCd00E390	;610011D2
	lea	$0164(a0),a0	;41E80164
	subq.w	#$01,d7	;5347
	cmp.w	#$0004,d7	;0C470004
	bcc.s	adrCd00D1A2	;64D6
	rts	;4E75

adrCd00D1CE:	sub.w	#$0022,a0	;90FC0022
	move.w	#$0003,d7	;3E3C0003
adrLp00D1D6:	bsr.s	adrCd00D1FE	;6126
	move.w	d6,adrW_00E3FA.l	;33C60000E3FA
	move.b	(a6)+,d0	;101E
	bsr	adrCd00E390	;610011AE
	lea	$0028(a0),a0	;41E80028
	moveq	#$02,d6	;7C02
adrLp00D1EA:	move.b	(a6)+,d0	;101E
	bsr	adrCd00E390	;610011A2
	dbra	d6,adrLp00D1EA	;51CEFFF8
	lea	$0114(a0),a0	;41E80114
	dbra	d7,adrLp00D1D6	;51CFFFDC
	rts	;4E75

adrCd00D1FE:	moveq	#$01,d6	;7C01
	btst	d7,$0010(a3)	;0F2B0010
	beq.s	adrCd00D234	;672E
	swap	d7	;4847
	move.w	d7,d6	;3C07
	swap	d7	;4847
	move.w	d7,d0	;3007
	not.w	d0	;4640
	and.w	#$0003,d0	;02400003
	add.w	d6,d0	;D046
	and.w	#$001F,d0	;0240001F
	moveq	#$0E,d6	;7C0E
	cmp.b	$0017(a4),d0	;B02C0017
	beq.s	adrCd00D234	;6712
	bsr	adrCd0075DC	;6100A3B8
	cmp.b	$000F(a4),d0	;B02C000F
	bne.s	adrCd00D230	;6604
	moveq	#$0B,d6	;7C0B
	rts	;4E75

adrCd00D230:	move.b	adrB_00D236(pc,d0.w),d6	;1C3B0004
adrCd00D234:	rts	;4E75

adrB_00D236:	dc.b	$06	;06
	dc.b	$0D	;0D
	dc.b	$0C	;0C
	dc.b	$07	;07

	move.w	d7,-(sp)	;3F07
	bsr	adrCd00D0F4	;6100FEB6
	move.l	#$005D00E2,d4	;283C005D00E2
	move.l	#$00070018,d5	;2A3C00070018
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$03,d3	;7603
	bsr	adrCd00E538	;610012E4
	move.w	#$0040,d5	;3A3C0040
	add.w	$0008(a5),d5	;DA6D0008
	bsr	adrCd00E538	;610012D8
	move.w	(sp)+,d7	;3E1F
	move.l	#$0000029C,a0	;207C0000029C
	bsr	adrCd0090DC	;6100BE70
	move.l	#AdrEA000B5C,a0	;207C00000B5C
	bsr	adrCd0090DC	;6100BE66
	bsr	adrCd00D2BE	;61000044
	lea	adrEA00F470.l,a6	;4DF90000F470
	bsr	adrCd00DAA6	;61000822
adrCd00D286:	move.w	d7,d0	;3007
	bsr	adrCd0072D4	;6100A04A
	move.w	d7,d0	;3007
	bsr	adrCd006F82	;61009CF2
	move.b	#$2B,d1	;123C002B
	moveq	#$0A,d0	;700A
	sub.b	d3,d0	;9003
	bpl.s	adrCd00D2A2	;6A06
	move.b	#$2D,d1	;123C002D
	neg.b	d0	;4400
adrCd00D2A2:	lea	adrEA00F481.l,a6	;4DF90000F481
	move.b	d1,$000C(a6)	;1D41000C
	bsr	adrCd00D8DA	;6100062C
	move.b	d1,$000E(a6)	;1D41000E
	ror.w	#$08,d1	;E059
	move.b	d1,$000D(a6)	;1D41000D
	bra	adrCd00DAA6	;600007EA

adrCd00D2BE:	move.l	a4,-(sp)	;2F0C
	move.l	screen_ptr.l,a0	;207900009B06
	lea	$051C(a0),a0	;41E8051C
	add.w	$000A(a5),a0	;D0ED000A
	move.w	d7,d0	;3007
	asl.w	#$06,d0	;ED40
	lea	CharacterStats.l,a4	;49F90000F586
	add.w	d0,a4	;D8C0
	swap	d7	;4847
	clr.w	d7	;4247
adrCd00D2DE:	moveq	#$00,d0	;7000
	move.b	$30(a4,d7.w),d0	;10347030
	bne.s	adrCd00D32E	;6648
	cmp.w	#$0002,d7	;0C470002
	bcc.s	adrCd00D304	;6418
	move.b	$0016(a4),d0	;102C0016
	beq.s	adrCd00D304	;6712
	lea	ObjectDefinitionsTable+$1.l,a1	;43F90000EF4B
	asl.w	#$02,d0	;E540
	move.b	$00(a1,d0.w),d3	;16310000
	moveq	#$1A,d0	;701A
	add.w	d7,d0	;D047
	bra.s	adrCd00D328	;6024

adrCd00D304:	move.w	$0012(a5),d3	;362D0012
	cmp.w	#$0004,d7	;0C470004
	bcc.s	adrCd00D328	;641A
	jsr	adrCd0009DA.l	;4EB9000009DA
	move.w	d7,d0	;3007
	cmp.w	#$0003,d7	;0C470003
	bne.s	adrCd00D324	;6608
	btst	#$00,d1	;08010000
	beq.s	adrCd00D324	;6702
	addq.w	#$01,d0	;5240
adrCd00D324:	add.w	#$006C,d0	;0640006C
adrCd00D328:	bsr	adrCd00D3DE	;610000B4
	bra.s	adrCd00D342	;6014

adrCd00D32E:	cmp.w	#$0005,d0	;0C400005
	bcc.s	adrCd00D340	;640C
	move.b	$3B(a4,d0.w),d1	;1234003B
	bne.s	adrCd00D340	;6606
	clr.b	$30(a4,d7.w)	;42347030
	bra.s	adrCd00D2DE	;609E

adrCd00D340:	bsr.s	adrCd00D35A	;6118
adrCd00D342:	addq.w	#$01,d7	;5247
	cmp.w	#$0006,d7	;0C470006
	bne.s	adrCd00D34E	;6604
	lea	$0274(a0),a0	;41E80274
adrCd00D34E:	cmp.w	#$000C,d7	;0C47000C
	bcs.s	adrCd00D2DE	;658A
	swap	d7	;4847
	move.l	(sp)+,a4	;285F
	rts	;4E75

adrCd00D35A:	tst.w	d0	;4A40
	beq	adrCd00D3DE	;67000080
	cmp.w	#$0005,d0	;0C400005
	bcs.s	adrCd00D39A	;6534
	cmp.w	#$0069,d0	;0C400069
	bcs.s	adrCd00D386	;651A
	cmp.w	#$006D,d0	;0C40006D
	bcc.s	adrCd00D386	;6414
	move.w	d0,d3	;3600
	sub.w	#$0069,d3	;04430069
	lea	RingUses.l,a1	;43F90000F98E
	tst.b	$00(a1,d3.w)	;4A313000
	bpl.s	adrCd00D386	;6A02
	moveq	#$68,d0	;7068
adrCd00D386:	asl.w	#$02,d0	;E540
	lea	ObjectDefinitionsTable.l,a1	;43F90000EF4A
	moveq	#$00,d3	;7600
	move.b	$01(a1,d0.w),d3	;16310001
	move.b	$00(a1,d0.w),d0	;10310000
	bra.s	adrCd00D3DE	;6044

adrCd00D39A:	move.l	a0,-(sp)	;2F08
	move.w	d0,-(sp)	;3F00
	move.b	d1,d0	;1001
	bsr	adrCd00D8DA	;61000538
	move.w	d1,adrEA00D3DA.l	;33C10000D3DA
	move.w	(sp),d0	;3017
	bsr.s	adrCd00D3DE	;6130
	move.l	$0002(sp),a0	;206F0002
	lea	$0050(a0),a0	;41E80050
	cmp.w	#$0003,(sp)+	;0C5F0003
	bcs.s	adrCd00D3C0	;6504
	lea	$0118(a0),a0	;41E80118
adrCd00D3C0:	lea	adrEA00D3DA.l,a6	;4DF90000D3DA
	move.l	#$00060000,adrW_00E3FA.l	;23FC000600000000E3FA
	bsr	adrCd00DAA6	;610006D4
	move.l	(sp)+,a0	;205F
	addq.w	#$02,a0	;5448
	rts	;4E75

adrEA00D3DA:	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
adrEA00D3DD:	dc.b	$FF	;FF

adrCd00D3DE:	move.l	#$00000098,a3	;267C00000098
	lea	_GFX_Pockets.l,a1	;43F9000494B2
	and.w	#$00FF,d0	;024000FF
adrCd00D3EE:	cmp.b	#$14,d0	;0C000014
	bcs.s	adrCd00D3FE	;650A
	lea	$0A00(a1),a1	;43E90A00
	sub.w	#$0014,d0	;04400014
	bra.s	adrCd00D3EE	;60F0

adrCd00D3FE:	asl.w	#$03,d0	;E740
	add.w	d0,a1	;D2C0
	movem.l	a0/a6,-(sp)	;48E70082
	bsr.s	adrCd00D410	;6108
	movem.l	(sp)+,a0/a6	;4CDF4100
	addq.w	#$02,a0	;5448
	rts	;4E75

adrCd00D410:	move.l	#$0000000F,-(sp)	;2F3C0000000F
	jmp	adrCd00D81C.l	;4EF90000D81C

adrCd00D41C:	bsr	adrCd00D58C	;6100016E
	move.w	$0006(a5),d0	;302D0006
	asl.w	#$06,d0	;ED40
	lea	CharacterStats.l,a0	;41F90000F586
	add.w	d0,a0	;D0C0
	lea	adrEA00D512.l,a2	;45F90000D512
	lea	adrEA00D51C.l,a6	;4DF90000D51C
	move.b	(a0),d0	;1010
	bsr	adrCd00D8DA	;6100049C
	move.w	d1,$0012(a6)	;3D410012
	moveq	#$04,d7	;7E04
	moveq	#$00,d0	;7000
	moveq	#$00,d2	;7400
adrLp00D44A:	move.b	$00(a2,d7.w),d0	;10327000
	move.b	$00(a0,d0.w),d0	;10300000
	move.b	$05(a2,d7.w),d2	;14327005
	move.b	#$20,$00(a6,d2.w)	;1DBC00202000
	cmp.b	#$64,d0	;0C000064
	bcs.s	adrCd00D46C	;650A
	move.b	#$31,$00(a6,d2.w)	;1DBC00312000
	sub.b	#$64,d0	;04000064
adrCd00D46C:	bsr	adrCd00D8DA	;6100046C
	move.b	d1,$02(a6,d2.w)	;1D812002
	ror.w	#$08,d1	;E059
	move.b	d1,$01(a6,d2.w)	;1D812001
	dbra	d7,adrLp00D44A	;51CFFFCE
	move.b	$000B(a0),d0	;1028000B
	moveq	#$6B,d2	;746B
	move.b	#$20,$006D(a6)	;1D7C0020006D
	cmp.b	#$64,d0	;0C000064
	bcs.s	adrCd00D49C	;650C
	sub.b	#$64,d0	;04000064
	move.b	#$31,$00(a6,d2.w)	;1DBC00312000
	addq.w	#$01,d2	;5242
adrCd00D49C:	bsr	adrCd00D8DA	;6100043C
	move.b	d1,$01(a6,d2.w)	;1D812001
	ror.w	#$08,d1	;E059
	move.b	d1,$00(a6,d2.w)	;1D812000
	moveq	#$00,d0	;7000
	move.w	$0006(a0),d0	;30280006
	bsr	adrCd00D8B0	;610003FE
	moveq	#$4D,d0	;704D
	moveq	#$00,d6	;7C00
	moveq	#$02,d1	;7202
adrLp00D4BA:	rol.l	#$08,d3	;E19B
	cmp.b	#$30,d3	;0C030030
	beq.s	adrCd00D4C6	;6704
	moveq	#$01,d6	;7C01
	bra.s	adrCd00D4CE	;6008

adrCd00D4C6:	tst.w	d6	;4A46
	bne.s	adrCd00D4CE	;6604
	move.b	#$20,d3	;163C0020
adrCd00D4CE:	move.b	d3,$00(a6,d0.w)	;1D830000
	addq.w	#$01,d0	;5240
	dbra	d1,adrLp00D4BA	;51C9FFE4
	rol.l	#$08,d3	;E19B
	move.b	d3,$00(a6,d0.w)	;1D830000
	moveq	#$00,d0	;7000
	move.w	$0008(a0),d0	;30280008
	bsr	adrCd00D8B0	;610003CA
	move.w	#$2020,$0058(a6)	;3D7C20200058
	moveq	#$00,d6	;7C00
	moveq	#$56,d0	;7056
	moveq	#$03,d1	;7203
adrLp00D4F4:	rol.l	#$08,d3	;E19B
	cmp.b	#$30,d3	;0C030030
	beq.s	adrCd00D500	;6704
	moveq	#$01,d6	;7C01
	bra.s	adrCd00D504	;6004

adrCd00D500:	tst.w	d6	;4A46
	beq.s	adrCd00D50A	;6706
adrCd00D504:	move.b	d3,$00(a6,d0.w)	;1D830000
	addq.w	#$01,d0	;5240
adrCd00D50A:	dbra	d1,adrLp00D4F4	;51C9FFE8
	bra	adrCd00DAA6	;60000596

adrEA00D512:	dc.w	$0203	;0203
	dc.w	$0405	;0405
	dc.w	$0A1D	;0A1D
	dc.w	$2935	;2935
	dc.w	$4163	;4163
adrEA00D51C:	dc.w	$FC1E	;FC1E
	dc.w	$03FE	;03FE
	dc.w	$0DFD	;0DFD
	dc.w	$034C	;034C
	dc.w	$4556	;4556
	dc.w	$454C	;454C
	dc.w	$FE01	;FE01
	dc.w	$0001	;0001
	dc.w	$FE0E	;FE0E
	dc.w	$2020	;2020
	dc.w	$FC1D	;FC1D
	dc.w	$04FE	;04FE
	dc.w	$0753	;0753
	dc.w	$54FE	;54FE
	dc.w	$0D20	;0D20
	dc.w	$2020	;2020
	dc.w	$FE01	;FE01
	dc.w	$2DFE	;2DFE
	dc.w	$0741	;0741
	dc.w	$47FE	;47FE
	dc.w	$0D20	;0D20
	dc.w	$2020	;2020
	dc.w	$FC1D	;FC1D
	dc.w	$05FE	;05FE
	dc.w	$0749	;0749
	dc.w	$4EFE	;4EFE
	dc.w	$0D20	;0D20
	dc.w	$2020	;2020
	dc.w	$FE01	;FE01
	dc.w	$2DFE	;2DFE
	dc.w	$0743	;0743
	dc.w	$48FE	;48FE
	dc.w	$0D20	;0D20
	dc.w	$2020	;2020
	dc.w	$FC1D	;FC1D
	dc.w	$06FE	;06FE
	dc.w	$0048	;0048
	dc.w	$50FE	;50FE
	dc.w	$0E20	;0E20
	dc.w	$2020	;2020
	dc.w	$20FE	;20FE
	dc.w	$012F	;012F
	dc.w	$FE06	;FE06
	dc.w	$2020	;2020
	dc.w	$2020	;2020
	dc.w	$FC1E	;FC1E
	dc.w	$07FE	;07FE
	dc.w	$0056	;0056
	dc.w	$49FE	;49FE
	dc.w	$0E20	;0E20
	dc.w	$2020	;2020
	dc.w	$FE01	;FE01
	dc.w	$2FFE	;2FFE
	dc.w	$0620	;0620
	dc.w	$2020	;2020
	dc.w	$FF00	;FF00

adrCd00D58C:	or.b	#$0C,$0054(a5)	;002D000C0054
	moveq	#$3C,d5	;7A3C
	swap	d5	;4845
	move.w	#$0017,d5	;3A3C0017
	add.w	$0008(a5),d5	;DA6D0008
	move.l	#$003F00F0,d4	;283C003F00F0
	moveq	#$03,d3	;7603
	bsr	adrCd00E538	;61000F90
	sub.l	a3,a3	;97CB
	lea	_GFX_Scroll_Edge_Left.l,a1	;43F9000516B2
	move.l	screen_ptr.l,a0	;207900009B06
	lea	$03B4(a0),a0	;41E803B4
	add.w	$000A(a5),a0	;D0ED000A
	clr.w	d5	;4245
	swap	d5	;4845
	move.l	d5,-(sp)	;2F05
	bsr.s	adrCd00D60C	;6144
	move.l	(sp)+,d5	;2A1F
	lea	_GFX_Scroll_Edge_Right.l,a1	;43F90005189A
	move.l	screen_ptr.l,a0	;207900009B06
	lea	$03BE(a0),a0	;41E803BE
	add.w	$000A(a5),a0	;D0ED000A
	bsr.s	adrCd00D60C	;612C
	sub.w	#$000A,a0	;90FC000A
	move.l	#$0005000B,d5	;2A3C0005000B	;Long Addr replaced with Symbol
	lea	_GFX_Scroll_Edge_Bottom.l,a1	;43F900051472
	bsr.s	adrCd00D60C	;611A
	lea	_GFX_Scroll_Edge_Top.l,a1	;43F9000511D2
	move.l	screen_ptr.l,a0	;207900009B06
	lea	$0184(a0),a0	;41E80184
	add.w	$000A(a5),a0	;D0ED000A
	move.l	#$0005000D,d5	;2A3C0005000D	;Long Addr replaced with Symbol
adrCd00D60C:	
	move.l	d5,-(sp)	;2F05
	bra	adrCd00D81C	;6000020C

adrCd00D612:	add.w	$0008(a5),d5	;DA6D0008
	swap	d5		;4845
	move.w	#$002B,d5	;3A3C002B
	swap	d5		;4845
	moveq	#$01,d3		;7601
	movem.l	d3-d5,-(sp)	;48E71C00
	bsr	adrCd00E538	;61000F12
	movem.l	(sp)+,d3-d5	;4CDF0038
adrCd00D62C:	
	addq.w	#$01,d4	;5244
	addq.w	#$01,d5		;5245
	sub.l	#$00020000,d5	;048500020000	;Long Addr replaced with Symbol
	sub.l	#$00020000,d4	;048400020000	;Long Addr replaced with Symbol
	addq.w	#$01,d3		;5243
	movem.l	d3-d5,-(sp)	;48E71C00
	bsr	adrCd00E5A4	;61000F60
	movem.l	(sp)+,d3-d5	;4CDF0038
	cmp.w	#$0004,d3	;0C430004
	bne.s	adrCd00D62C	;66DC
	rts	;4E75

adrCd00D652:	
	move.l	#$002F0000,d4	;283C002F0000
	moveq	#$0A,d5			;7A0A
	bsr.s	adrCd00D612		;61B6
	move.w	$0006(a5),d7		;3E2D0006
	moveq	#-$01,d4		;78FF
	move.l	#$000002A9,a0		;207C000002A9
	bsr.s	adrCd00D6C8		;615E
adrCd00D66A:	btst	#$00,$003E(a5)	;082D0000003E
	bne.s	adrCd00D6A8		;6636
	or.b	#$01,$0054(a5)		;002D00010054
	move.l	#$0021000F,d5		;2A3C0021000F
	add.w	$0008(a5),d5		;DA6D0008
	move.l	#$00230006,d4		;283C00230006
	moveq	#$01,d3			;7601
	bsr.s	adrCd00D690		;6104
	bra	adrCd00E5A4		;60000F16

adrCd00D690:	move.w	d7,d0		;3007
	bsr	adrCd0072D4		;61009C40
	move.b	$0015(a4),d0		;102C0015
	beq.s	adrCd00D6A8		;670C
	and.w	#$0007,d0		;02400007
	add.b	$0025(a4),d0		;D02C0025
	move.b	adrB_00D6AA(pc,d0.w),d3	;163B0004
adrCd00D6A8:	rts			;4E75

adrB_00D6AA:	
	dc.b	$06	;06
	dc.b	$0D	;0D
	dc.b	$06	;06
	dc.b	$08	;08
	dc.b	$06	;06
	dc.b	$06	;06
	dc.b	$0D	;0D
	dc.b	$08	;08
	dc.b	$0B	;0B
	dc.b	$0B	;0B
	dc.b	$0B	;0B
	dc.b	$0B	;0B
adrEA00D6B6:	
	dc.b	$0C	;0C
	dc.b	$04	;04
	dc.b	$08	;08
	dc.b	$0A	;0A
	dc.b	$0F	;0F
	dc.b	$0B	;0B
	dc.b	$07	;07
	dc.b	$06	;06
	dc.b	$0E	;0E
	dc.b	$01	;01
	dc.b	$05	;05
	dc.b	$0D	;0D
	dc.b	$09	;09
	dc.b	$03	;03
	dc.b	$02	;02
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$00	;00

adrCd00D6C8:	
	add.l	screen_ptr.l,a0	;D1F900009B06
	add.w	$000A(a5),a0	;D0ED000A
	lea	CharacterStats.l,a6	;4DF90000F586
	move.w	d7,d0	;3007
	asl.w	#$06,d0	;ED40
	add.w	d0,a6	;DCC0
	moveq	#$00,d0	;7000
	move.b	$0001(a6),d0	;102E0001
	move.w	d0,d2	;3400
	lea	characters.heads.l,a6	;4DF90000B788
	move.b	$00(a6,d0.w),d0	;10360000
	move.b	adrEA00D6B6(pc,d0.w),d0	;103B00C4
	lea	_GFX_Avatars.l,a1	;43F90003EAE0
	move.w	d0,d1	;3200
	asl.w	#$05,d0	;EB40
	sub.w	d1,d0	;9041
	sub.w	d1,d0	;9041
	asl.w	#$04,d0	;E940
	add.w	d0,a1	;D2C0
	sub.l	a3,a3	;97CB
	move.w	d2,d0	;3002
	asl.w	#$02,d0	;E540
	add.w	d2,d0	;D042
	add.w	d2,d0	;D042
	asl.w	#$02,d0	;E540
	lea	adrEA031E34.l,a6	;4DF900031E34
	add.w	d0,a6	;DCC0
	move.w	#$FFFF,adrW_00C354.l	;33FCFFFF0000C354
	bsr.s	adrCd00D72C	;6108
	clr.w	adrW_00C354.l	;42790000C354
	rts			;4E75

adrCd00D72C:	
	move.l	#$0001001D,-(sp)	;2F3C0001001D	;Long Addr replaced with Symbol
	tst.w	d4		;4A44
	bne	adrCd00D81C	;660000E6
	bra	adrCd00D81C	;600000E2

;fiX Label expected
	moveq	#$04,d3	;7604
adrCd00D73E:	
	move.l	#$00020103,d0		;203C00020103	;Long Addr replaced with Symbol
	tst.w	d3			;4A43
	beq.s	adrCd00D772		;672A
	move.w	d7,d1			;3207
	asl.w	#$06,d1			;ED41
	lea	CharacterStats.l,a6	;4DF90000F586
	moveq	#$00,d0			;7000
	move.b	$01(a6,d1.w),d0		;10361001
	move.w	d0,d2			;3400
	bsr	adrCd0075DC		;61009E80
	cmp.w	#$0010,d2		;0C420010
	bcs.s	adrCd00D766		;6502
	addq.w	#$04,d0	;5840
adrCd00D766:	
	asl.w	#$02,d0	;E540
	lea	ClassColours.l,a6	;4DF90000922C
	move.l	$00(a6,d0.w),d0		;20360000
adrCd00D772:	
	move.l	d0,adrEA00C356.l	;23C00000C356
	sub.l	a3,a3	;97CB
	lea	_GFX_ShieldTop.l,a1	;43F9000418E0
	move.l	#$00010004,d5		;2A3C00010004	;Long Addr replaced with Symbol
	bsr	adrCd00D81A		;61000092
	move.w	d7,d0			;3007
	asl.w	#$06,d0			;ED40
	lea	CharacterStats.l,a6	;4DF90000F586
	add.w	d0,a6			;DCC0
	moveq	#$00,d0			;7000
	move.b	$0001(a6),d0		;102E0001
	move.w	d0,d1			;3200
	lea	characters.heads.l,a6	;4DF90000B788
	move.b	$00(a6,d0.w),d0		;10360000
	lea	adrEA00D6B6.l,a6	;4DF90000D6B6
	move.b	$00(a6,d0.w),d0		;10360000
	move.w	d0,-(sp)		;3F00
	asl.w	#$08,d0			;E140
	lea	_GFX_ShieldAvatars.l,a1	;43F9000408E0
	add.w	d0,a1			;D2C0
	move.l	#$0001000F,d5		;2A3C0001000F	;Long Addr replaced with Symbol
	move.w	d1,d0			;3001
	asl.w	#$02,d0			;E540
	add.w	d1,d0			;D041
	add.w	d1,d0			;D041
	asl.w	#$02,d0			;E540
	lea	adrEA031E34.l,a6	;4DF900031E34
	add.w	d0,a6			;DCC0
	move.w	#$FFFF,adrW_00C354.l	;33FCFFFF0000C354
	bsr.s	adrCd00D81A		;613A
	lea	_GFX_ShieldClasses.l,a1	;43F9000419C0
	move.w	(sp)+,d0		;301F
	and.w	#$0003,d0		;02400003
	move.w	d0,d1			;3200
	asl.w	#$03,d0			;E740
	add.w	d1,d0			;D041
	add.w	d1,d0			;D041
	add.w	d1,d0			;D041
	asl.w	#$04,d0	;		E940
	add.w	d0,a1			;D2C0	
	move.l	#$0001000A,d5		;2A3C0001000A	;Long Addr replaced with Symbol
	lea	adrEA00C356.l,a6	;4DF90000C356
	bsr.s	adrCd00D81A		;6112
	clr.w	adrW_00C354.l		;42790000C354
	lea	_GFX_ShieldBottom.l,a1	;43F900041930
	move.l	#$00010008,d5		;2A3C00010008	;Long Addr replaced with Symbol
adrCd00D81A:	
	move.l	d5,-(sp)	;2F05
adrCd00D81C:	
	move.l	(sp)+,d5	;2A1F
adrLp00D81E:	
	swap	d5	;4845
	move.w	d5,-(sp)	;3F05
adrLp00D822:	
	move.l	(a1)+,d0	;2019
	move.l	(a1)+,d1	;2219
	tst.w	adrW_00C354.l	;4A790000C354
	beq.s	adrCd00D832	;6704
	bsr	adrCd00BE66	;6100E636
adrCd00D832:	
	bsr	adrCd00D87A	;61000046
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
	dbra	d5,adrLp00D822	;51CDFFBE
	move.w	(sp)+,d5	;3A1F
	sub.w	d5,a0	;90C5
	sub.w	d5,a0	;90C5
	add.w	#$0026,a0	;D0FC0026
	add.w	a3,a1	;D2CB
	swap	d5	;4845
	dbra	d5,adrLp00D81E	;51CDFFA8
	rts	;4E75

adrCd00D87A:	move.l	d1,d2	;2401
	and.l	d0,d2	;C480
	swap	d2	;4842
	and.l	d0,d2	;C480
	and.l	d1,d2	;C481
	lea	adrEA00BEFA.l,a2	;45F90000BEFA
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

adrCd00D8B0:	
	moveq	#$00,d4	;7800

adrCd00D8B2:	
	move.w	d4,d1	;3204
	add.w	d1,d1	;D241
	move.w	adrW_00D8D2(pc,d1.w),d1	;323B101A
	divu	d1,d0	;80C1
	add.b	#$30,d0	;06000030
	asl.l	#$08,d3	;E183
	move.b	d0,d3	;1600
	clr.w	d0	;4240
	swap	d0	;4840
	addq.w	#$01,d4	;5244
	cmp.w	#$0004,d4	;0C440004
	bcs.s	adrCd00D8B2	;65E2
	rts	;4E75

adrW_00D8D2:
	dc.w	$03E8	;03E8
	dc.w	$0064	;0064
	dc.w	$000A	;000A
	dc.w	$0001	;0001

adrCd00D8DA:
	move.b	d0,d1	;1200
	lsr.b	#$04,d1	;E809
	and.w	#$000F,d1	;0241000F
	move.b	adrB_00D8F6(pc,d1.w),d1	;123B1012
	and.w	#$000F,d0	;0240000F
	move.w	#$0004,ccr	;44FC0004
	abcd	d1,d0	;C101
	clr.b	d1	;4201
	abcd	d1,d0	;C101
	bra.s	adrCd00D908	;6012

adrB_00D8F6:	
	dc.b	$00	;00
	dc.b	$16	;16
	dc.b	$32	;32
	dc.b	$48	;48
	dc.b	$64	;64
	dc.b	$80	;80
	dc.b	$96	;96
	dc.b	$00	;00

	move.w	d0,-(sp)	;3F00
	ror.w	#$08,d0		;E058
	bsr.s	adrCd00D908	;6104
	swap	d1		;4841
	move.w	(sp)+,d0	;301F

adrCd00D908:	
	move.b	d0,d1	;1200
	ror.b	#$04,d1	;E819
	bsr.s	adrCd00D912	;6104
	rol.w	#$08,d1	;E159
	move.b	d0,d1	;1200

adrCd00D912:
	and.b	#$0F,d1	;0201000F
	cmp.b	#$0A,d1	;0C01000A
	bcs.s	adrCd00D920	;6504
	add.b	#$07,d1	;06010007
adrCd00D920:
	add.b	#$30,d1	;06010030
	rts	;4E75

adrCd00D926:
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	$000A(a5),a0	;D0ED000A
	add.w	#$02EC,a0	;D0FC02EC
	move.w	#$000D,adrW_00E3FA.l	;33FC000D0000E3FA
	move.w	$0010(a5),adrW_00E3FC.l	;33ED00100000E3FC
	moveq	#$0B,d6	;7C0B
	and.w	#$000F,d0	;0240000F
	bsr	adrCd00E2B2	;61000966
	bsr	adrCd00D9FE	;610000AE
	move.w	#$00E0,d4	;383C00E0
	moveq	#$12,d5	;7A12
	add.w	$0008(a5),d5	;DA6D0008
	move.l	#$00040000,d3	;263C00040000	;Long Addr replaced with Symbol
	bsr	adrCd00E5D4	;61000C70
	addq.w	#$01,d4	;5244
	bra	adrCd00E5D4	;60000C6A

adrCd00D96C:	or.b	#$10,$0054(a5)	;002D00100054
	move.b	#$FF,$0057(a5)	;1B7C00FF0057
	move.l	screen_ptr.l,a0	;207900009B06
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
	clr.w	adrW_00E3FC.l	;42790000E3FC
	moveq	#$0F,d6	;7C0F
	rts	;4E75

adrCd00D9B4:	move.l	#$007F0060,d4	;283C007F0060
	move.l	#$00060059,d5	;2A3C00060059
	add.w	$0008(a5),d5	;DA6D0008
	moveq	#$00,d3	;7600
	or.b	#$10,$0054(a5)	;002D00100054
	move.b	#$FF,$0057(a5)	;1B7C00FF0057
	bra	adrCd00E538	;60000B64

adrCd00D9D6:	bsr.s	adrCd00D96C	;6194
	bra.s	adrLp00D9F4	;601A

adrCd00D9DA:	move.l	screen_ptr.l,a0	;207900009B06
	lea	$0BAE(a0),a0	;41E80BAE
	add.w	$000A(a5),a0	;D0ED000A
	moveq	#$07,d6	;7C07
	move.l	#$000B0000,adrW_00E3FA.l	;23FC000B00000000E3FA
adrLp00D9F4:	move.b	(a6)+,d0	;101E
	bpl.s	adrCd00DA0E	;6A16
	bsr	adrCd00DAB6	;610000BC
	bcc.s	adrLp00D9F4	;64F6
adrCd00D9FE:	tst.w	d6	;4A46
	bmi.s	adrCd00DA0C	;6B0A
adrLp00DA02:	moveq	#$20,d0	;7020
	bsr	adrCd00E390	;6100098A
	dbra	d6,adrLp00DA02	;51CEFFF8
adrCd00DA0C:	rts	;4E75

adrCd00DA0E:	bsr	adrCd00E390	;61000980
	dbra	d6,adrLp00D9F4	;51CEFFE0
	rts	;4E75

adrCd00DA18:	move.b	#$81,d2	;143C0081
	bra.s	adrCd00DA20	;6002

;fiX Label expected
	moveq	#$00,d2	;7400
adrCd00DA20:
	tst.b	$0005(a4)	;4A2C0005
	bpl.s	adrCd00DA70	;6A4A
	movem.l	d2/a6,-(sp)	;48E72002
	bsr.s	adrCd00DA70	;6144
	movem.l	(sp)+,d2/a6	;4CDF4004
	lea	Player1_Data.l,a0	;41F90000F9D8
	btst	#$00,(a5)	;08150000
	bne.s	adrCd00DA42	;6606
	lea	Player2_Data.l,a0	;41F90000FA3A
adrCd00DA42:	movem.l	a4/a5,-(sp)	;48E7000C
	move.l	a0,a5	;2A48
	move.b	$0001(a4),d0	;102C0001
	jsr	adrCd00498E.l	;4EB90000498E
	tst.b	$0005(a4)	;4A2C0005
	bpl.s	adrCd00DA5C	;6A04
	move.b	d0,$0000(a4)	;19400000
adrCd00DA5C:	or.b	#$40,d2	;00020040
	bsr.s	adrCd00DA70	;610E
	movem.l	(sp)+,a4/a5	;4CDF3000
	rts	;4E75

adrCd00DA68:	move.b	#$81,d2	;143C0081
	bra.s	adrCd00DA70	;6002

adrCd00DA6E:	moveq	#$00,d2	;7400
adrCd00DA70:	move.b	d2,$0052(a5)	;1B420052
	bsr.s	adrCd00DA7A	;6104
	bra	adrLp00D9F4	;6000FF7C

adrCd00DA7A:	or.b	#$A0,$0054(a5)	;002D00A00054
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	$000A(a5),a0	;D0ED000A
	add.w	#$0050,a0	;D0FC0050
	move.l	#$000F0000,adrW_00E3FA.l	;23FC000F00000000E3FA
	clr.w	$004C(a5)	;426D004C
	moveq	#$27,d6	;7C27
	move.w	#$0105,$004A(a5)	;3B7C0105004A
	rts	;4E75

adrCd00DAA6:	move.b	(a6)+,d0	;101E
	bpl.s	adrCd00DAB0	;6A06
	bsr.s	adrCd00DAB6	;610A
	bcc.s	adrCd00DAA6	;64F8
	rts	;4E75

adrCd00DAB0:	bsr	adrCd00E390	;610008DE
	bra.s	adrCd00DAA6	;60F0

adrCd00DAB6:	cmp.b	#$F0,d0	;0C0000F0
	beq.s	adrCd00DB08	;674C
	moveq	#$00,d1	;7200
	move.b	(a6)+,d1	;121E
	cmp.b	#$FE,d0	;0C0000FE
	beq.s	adrCd00DAD8	;6712
	cmp.b	#$FD,d0	;0C0000FD
	beq.s	adrCd00DAE0	;6714
	cmp.b	#$FC,d0	;0C0000FC
	beq.s	adrCd00DAE8	;6716
	moveq	#$00,d0	;7000
	subq.w	#$01,d0	;5340
	rts	;4E75

adrCd00DAD8:	move.w	d1,adrW_00E3FA.l	;33C10000E3FA
	rts	;4E75

adrCd00DAE0:	move.w	d1,adrW_00E3FC.l	;33C10000E3FC
	rts	;4E75

adrCd00DAE8:	move.w	d1,d4	;3801
	clr.w	d5	;4245
	move.b	(a6)+,d5	;1A1E
	asl.w	#$03,d4	;E744
	asl.w	#$03,d5	;E745
	bsr	adrCd00E724	;61000C30
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	$000A(a5),a0	;D0ED000A
	add.w	d0,a0	;D0C0
	lea	$0050(a0),a0	;41E80050
adrCd00DB06:	rts	;4E75

adrCd00DB08:
	moveq	#$00,d0	;7000
	rts				; uncomment this to apply the DEFJAM crack
	;bsr.s	CopyProtection	;610C	; comment this out to retain the same size with DEFJAM

	beq.s	adrCd00DB06	;67F8
	lea	adrCd000FB8.l,a0	;41F900000FB8
	bra	adrCd009B7A	;6000C064

CopyProtection:	
	movem.l	a4-a6,-(sp)	;48E7000E	; comment this out to apply the WHDLoad Crack
	bra	adrCd00DB8C	;6000006E	; comment this out to apply the WHDLoad Crack

	;move.l	#$4f8b3912,$24.w		; uncomment this to apply the WHDLoad Crack
	;moveq	#0,d0				; uncomment this to apply the WHDLoad Crack
	;rts					; uncomment this to apply the WHDLoad Crack


adrEA00DB20:
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
	dc.l	$00000000	;00000000
	dc.l	$00000000	;00000000
	dc.l	$00000000	;00000000
	dc.l	$00000000	;00000000
adrEA00DB80:	dc.l	$00000000	;00000000
	dc.l	$00000000	;00000000
	dc.l	$FFFFFFFF	;FFFFFFFF

*** FIX - This is very weird!!  What happens after the illegal trap?
; There's a couple of likely looking RTEs below
; but the stuff in between may look like code but isn't!
adrCd00DB8C:	
	move.l	a6,-(sp)		;2F0E
	lea	adrEA00DB20(pc),a6	;4DFAFF90
	movem.l	d0-d7/a0-a7,(a6)	;48D6FFFF
	lea	$0040(a6),a6		;4DEE0040
	move.l	(sp)+,-$0008(a6)	;2D5FFFF8
	move.l	tv_Illegal.l,d1		;223900000010
	dc.l	$487A000A
;	pea	AdrEA00DBB0(pc)		;487A000A
	move.l	(sp)+,tv_Illegal.l	;23DF00000010
	illegal				;4AFC
AdrEA00DBB0:	
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

	movem.l	d0/a0/a1,-(sp)	;48E780C0
	lea	adrEA00DC9C(pc),a0	;41FA0034
	move.l	a0,tv_Trace.l	;23C800000024
	lea	adrEA00E0D6(pc),a0	;41FA0464
	move.l	a0,tv_PrivilegeViolation.l	;23C800000020
	add.l	#$00000002,$000E(sp)	;06AF00000002000E
	or.b	#$07,$000C(sp)	;002F0007000C
	bchg	#$07,$000C(sp)	;086F0007000C
	lea	adrEA00DB80(pc),a1	;43FAFEF0
	beq.s	adrCd00DCAE	;671A
	move.l	(a1),a0	;2051
	move.l	$0004(a1),(a0)	;20A90004
	bra.s	adrCd00DCC2	;6026

adrEA00DC9C:	andi.w	#$F8FF,sr	;027CF8FF
	movem.l	d0/a0/a1,-(sp)	;48E780C0
	lea	adrEA00DB80(pc),a1	;43FAFEDA
	move.l	(a1),a0	;2051
	move.l	$0004(a1),(a0)	;20A90004
adrCd00DCAE:	move.l	$000E(sp),a0	;206F000E
	move.l	a0,(a1)	;2288
	move.l	(a0),$0004(a1)	;23500004
	move.l	-$0004(a0),d0	;2028FFFC
	not.l	d0	;4680
	swap	d0	;4840
	eor.l	d0,(a0)	;B190
adrCd00DCC2:	movem.l	(sp)+,d0/a0/a1	;4CDF0301
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
	dc.w	$05CA	;05CA
	dc.w	$054A	;054A
	dc.w	$00D6	;00D6
	dc.w	$060A	;060A
	dc.w	$064A	;064A
	dc.w	$06CA	;06CA
	dc.w	$054A	;054A
	dc.w	$0110	;0110
	dc.w	$DED5	;DED5
	dc.w	$0493	;0493
	dc.w	$B53A	;B53A
	dc.w	$DEC0	;DEC0
	dc.w	$69D8	;69D8
	dc.w	$7A05	;7A05
	dc.w	$E4FA	;E4FA
	dc.w	$96C7	;96C7
	dc.w	$1F3B	;1F3B
	dc.w	$81C4	;81C4
	dc.w	$687E	;687E
	dc.w	$F181	;F181
	dc.w	$7EBB	;7EBB
	dc.w	$B56A	;B56A
	dc.w	$F192	;F192
	dc.w	$6F6D	;6F6D
	dc.w	$48D1	;48D1
	dc.w	$D62E	;D62E
	dc.w	$914E	;914E
	dc.w	$2CDF	;2CDF
	dc.w	$D627	;D627
	dc.w	$5DDA	;5DDA
	dc.w	$C325	;C325
	dc.w	$296A	;296A
	dc.w	$E6BB	;E6BB
	dc.w	$C32C	;C32C
	dc.w	$EC93	;EC93
	dc.w	$215A	;215A
	dc.w	$3C2B	;3C2B
	dc.w	$B3FC	;B3FC
	dc.w	$6C6D	;6C6D
	dc.w	$3C26	;3C26
	dc.w	$A2D9	;A2D9
	dc.w	$92D6	;92D6
	dc.w	$0C29	;0C29
	dc.w	$5C5A	;5C5A
	dc.w	$C5EB	;C5EB
	dc.w	$3644	;3644
	dc.w	$E70C	;E70C
	dc.w	$7EDD	;7EDD
	dc.w	$834A	;834A
	dc.w	$4DA6	;4DA6
	dc.w	$0012	;0012
	dc.w	$99CB	;99CB
	dc.w	$27DC	;27DC
	dc.w	$FFF5	;FFF5
	dc.w	$7006	;7006
	dc.w	$EEF9	;EEF9
	dc.w	$00D2	;00D2
	dc.w	$4F51	;4F51
	dc.w	$1152	;1152
	dc.w	$829D	;829D
	dc.w	$710C	;710C
	dc.w	$EEAF	;EEAF
	dc.w	$FFF6	;FFF6
	dc.w	$6707	;6707
	dc.w	$9496	;9496
	dc.w	$000A	;000A
	dc.w	$FFF6	;FFF6
	dc.w	$670F	;670F
	dc.w	$288C	;288C
	dc.w	$0005	;0005
	dc.w	$90E0	;90E0
	dc.w	$3ED5	;3ED5
	dc.w	$0056	;0056
	dc.w	$F9C7	;F9C7
	dc.w	$C12B	;C12B
	dc.w	$FFF6	;FFF6
	dc.w	$0C67	;0C67
	dc.w	$3ED0	;3ED0
	dc.w	$FFF6	;FFF6
	dc.w	$6693	;6693
	dc.w	$F86C	;F86C
	dc.w	$00E9	;00E9
	dc.w	$8F16	;8F16
	dc.w	$10C5	;10C5
	dc.w	$8E3A	;8E3A
	dc.w	$7031	;7031
	dc.w	$C94E	;C94E
	dc.w	$50A7	;50A7
	dc.w	$9F76	;9F76
	dc.w	$C95B	;C95B
	dc.w	$64E4	;64E4
	dc.w	$995B	;995B
	dc.w	$36A7	;36A7
	dc.w	$F418	;F418
	dc.w	$994E	;994E
	dc.w	$377A	;377A
	dc.w	$F485	;F485
	dc.w	$7B7A	;7B7A
	dc.w	$E48B	;E48B
	dc.w	$3B1A	;3B1A
	dc.w	$7B77	;7B77
	dc.w	$F68C	;F68C
	dc.w	$7973	;7973
	dc.w	$5614	;5614
	dc.w	$F822	;F822
	dc.w	$7970	;7970
	dc.w	$C576	;C576
	dc.w	$07DD	;07DD
	dc.w	$03D4	;03D4
	dc.w	$BDD1	;BDD1
	dc.w	$FABC	;FABC
	dc.w	$6443	;6443
	dc.w	$4270	;4270
	dc.w	$8FA1	;8FA1
	dc.w	$6456	;6456
	dc.w	$D776	;D776
	dc.w	$7352	;7352
	dc.w	$C2F3	;C2F3
	dc.w	$5D0C	;5D0C
	dc.w	$8E11	;8E11
	dc.w	$5180	;5180
	dc.w	$5D01	;5D01
	dc.w	$D0F4	;D0F4
	dc.w	$6D93	;6D93
	dc.w	$C3A5	;C3A5
	dc.w	$D0F7	;D0F7
	dc.w	$617D	;617D
	dc.w	$9CC2	;9CC2
	dc.w	$2F0B	;2F0B
	dc.w	$EDB4	;EDB4
	dc.w	$9CD7	;9CD7
	dc.w	$5E54	;5E54
	dc.w	$124A	;124A
	dc.w	$FFEC	;FFEC
	dc.w	$41EA	;41EA
	dc.w	$EDB5	;EDB5
	dc.w	$03D4	;03D4
	dc.w	$D163	;D163
	dc.w	$EDB8	;EDB8
	dc.w	$2F3B	;2F3B
	dc.w	$A789	;A789
	dc.w	$FFF8	;FFF8
	dc.w	$3D7B	;3D7B
	dc.w	$D162	;D162
	dc.w	$FFFA	;FFFA
	dc.w	$3D79	;3D79
	dc.w	$A78C	;A78C
	dc.w	$FFFC	;FFFC
	dc.w	$3D7F	;3D7F
	dc.w	$D161	;D161
	dc.w	$FFFE	;FFFE
	dc.w	$3D7D	;3D7D
	dc.w	$D161	;D161
	dc.w	$FFEE	;FFEE
	dc.w	$41E8	;41E8
	dc.w	$2E9E	;2E9E
	dc.w	$03D4	;03D4
	dc.w	$BFD1	;BFD1
	dc.w	$D35F	;D35F
	dc.w	$5EAA	;5EAA
	dc.w	$838D	;838D
	dc.w	$2DBB	;2DBB
	dc.w	$5EA9	;5EA9
	dc.w	$EF23	;EF23
	dc.w	$587B	;587B
	dc.w	$D156	;D156
	dc.w	$1CA9	;1CA9
	dc.w	$B017	;B017
	dc.w	$3FE8	;3FE8
	dc.w	$D60F	;D60F
	dc.w	$5DF7	;5DF7
	dc.w	$410B	;410B
	dc.w	$DAF6	;DAF6
	dc.w	$7749	;7749
	dc.w	$D97C	;D97C
	dc.w	$DAF1	;DAF1
	dc.w	$74C7	;74C7
	dc.w	$D973	;D973
	dc.w	$6A13	;6A13
	dc.w	$8B36	;8B36
	dc.w	$3ABC	;3ABC
	dc.w	$A443	;A443
	dc.w	$7427	;7427
	dc.w	$EAD8	;EAD8
	dc.w	$5AFE	;5AFE
	dc.w	$C309	;C309
	dc.w	$01B7	;01B7
	dc.w	$5AF1	;5AF1
	dc.w	$D50E	;D50E
	dc.w	$6484	;6484
	dc.w	$A63B	;A63B
	dc.w	$D501	;D501
	dc.w	$648B	;648B
	dc.w	$B474	;B474
	dc.w	$7FA5	;7FA5
	dc.w	$6484	;6484
	dc.w	$F07F	;F07F
	dc.w	$6E80	;6E80
	dc.w	$9B93	;9B93
	dc.w	$056C	;056C
	dc.w	$91DD	;91DD
	dc.w	$4E3D	;4E3D
	dc.w	$FFB7	;FFB7
	dc.w	$43B1	;43B1
	dc.w	$B11D	;B11D
	dc.w	$F000	;F000
	dc.w	$3C83	;3C83
	dc.w	$CEF2	;CEF2
	dc.w	$0096	;0096
	dc.w	$CC15	;CC15
	dc.w	$710D	;710D
	dc.w	$0024	;0024
	dc.w	$CCA7	;CCA7
	dc.w	$E8F2	;E8F2
	dc.w	$009E	;009E
	dc.w	$CC1D	;CC1D
	dc.w	$820D	;820D
	dc.w	$009E	;009E
	dc.w	$CC20	;CC20
	dc.w	$7D8C	;7D8C
	dc.w	$A13B	;A13B
	dc.w	$33FF	;33FF
	dc.w	$FF7C	;FF7C
	dc.w	$5EC6	;5EC6
	dc.w	$009C	;009C
	dc.w	$1D2B	;1D2B
	dc.w	$E294	;E294
	dc.w	$7F63	;7F63
	dc.w	$B3DC	;B3DC
	dc.w	$1D4F	;1D4F
	dc.w	$D1F0	;D1F0
	dc.w	$4C07	;4C07
	dc.w	$FD8D	;FD8D
	dc.w	$418B	;418B
	dc.w	$B327	;B327
	dc.w	$F000	;F000
	dc.w	$2FC3	;2FC3
	dc.w	$4CD8	;4CD8
	dc.w	$0BB8	;0BB8
	dc.w	$9547	;9547
	dc.w	$B2A7	;B2A7
	dc.w	$4571	;4571
	dc.w	$6AB9	;6AB9
	dc.w	$001F	;001F
	dc.w	$99F6	;99F6
	dc.w	$0709	;0709
	dc.w	$FE86	;FE86
	dc.w	$678B	;678B
	dc.w	$AB08	;AB08
	dc.w	$017B	;017B
	dc.w	$009C	;009C
	dc.w	$CC1F	;CC1F
	dc.w	$BE84	;BE84
	dc.w	$0024	;0024
	dc.w	$8F24	;8F24
	dc.w	$3EAE	;3EAE
	dc.w	$F22D	;F22D
	dc.w	$70D9	;70D9
	dc.w	$009C	;009C
	dc.w	$CC1F	;CC1F
	dc.w	$CF26	;CF26
	dc.w	$0024	;0024
	dc.w	$8FDB	;8FDB
	dc.w	$3E51	;3E51
	dc.w	$E192	;E192
	dc.w	$7024	;7024
	dc.w	$0BB8	;0BB8
	dc.w	$9547	;9547
	dc.w	$8E93	;8E93
	dc.w	$7955	;7955
	dc.w	$6ABD	;6ABD
	dc.w	$00BF	;00BF
	dc.w	$E001	;E001
	dc.w	$78F4	;78F4
	dc.w	$E60B	;E60B
	dc.w	$1ED2	;1ED2
	dc.w	$87DD	;87DD
	dc.w	$08DD	;08DD
	dc.w	$B957	;B957
	dc.w	$36A8	;36A8
	dc.w	$8722	;8722
	dc.w	$0A22	;0A22
	dc.w	$E61C	;E61C
	dc.w	$7862	;7862
	dc.w	$D100	;D100
	dc.w	$1ED1	;1ED1
	dc.w	$7877	;7877
	dc.w	$D108	;D108
	dc.w	$2F76	;2F76
	dc.w	$C348	;C348
	dc.w	$2E48	;2E48
	dc.w	$D100	;D100
	dc.w	$2F3E	;2F3E
	dc.w	$C300	;C300
	dc.w	$2E40	;2E40
	dc.w	$D100	;D100
	dc.w	$1D03	;1D03
	dc.w	$D5BF	;D5BF
	dc.w	$00DF	;00DF
	dc.w	$F09E	;F09E
	dc.w	$4114	;4114
	dc.w	$CC14	;CC14
	dc.w	$202A	;202A
	dc.w	$BE54	;BE54
	dc.w	$D100	;D100
	dc.w	$267E	;267E
	dc.w	$41AC	;41AC
	dc.w	$DF9F	;DF9F
	dc.w	$005C	;005C
	dc.w	$BE53	;BE53
	dc.w	$001E	;001E
	dc.w	$9EE1	;9EE1
	dc.w	$4162	;4162
	dc.w	$F0E8	;F0E8
	dc.w	$3F39	;3F39
	dc.w	$4173	;4173
	dc.w	$D48A	;D48A
	dc.w	$4A75	;4A75
	dc.w	$BEBA	;BEBA
	dc.w	$2775	;2775
	dc.w	$E788	;E788
	dc.w	$FA3F	;FA3F
	dc.w	$E78A	;E78A
	dc.w	$6A74	;6A74
	dc.w	$01CB	;01CB
	dc.w	$992E	;992E
	dc.w	$0CD5	;0CD5
	dc.w	$81D5	;81D5
	dc.w	$3A68	;3A68
	dc.w	$B594	;B594
	dc.w	$FE57	;FE57
	dc.w	$C596	;C596
	dc.w	$546B	;546B
	dc.w	$F814	;F814
	dc.w	$66EB	;66EB
	dc.w	$ABDE	;ABDE
	dc.w	$2422	;2422
	dc.w	$889F	;889F
	dc.w	$1196	;1196
	dc.w	$D336	;D336
	dc.w	$888E	;888E
	dc.w	$1671	;1671
	dc.w	$2CAB	;2CAB
	dc.w	$A354	;A354
	dc.w	$12DE	;12DE
	dc.w	$A5C6	;A5C6
	dc.w	$7CAB	;7CAB
	dc.w	$F701	;F701
	dc.w	$00C7	;00C7
	dc.w	$8350	;8350
	dc.w	$00BF	;00BF
	dc.w	$E001	;E001
	dc.w	$78EE	;78EE
	dc.w	$F712	;F712
	dc.w	$7A12	;7A12
	dc.w	$E4ED	;E4ED
	dc.w	$08CD	;08CD
	dc.w	$A6F8	;A6F8
	dc.w	$E4FE	;E4FE
	dc.w	$6BFE	;6BFE
	dc.w	$F411	;F411
	dc.w	$4980	;4980
	dc.w	$6BEF	;6BEF
	dc.w	$F510	;F510
	dc.w	$B649	;B649
	dc.w	$3BE3	;3BE3
	dc.w	$569E	;569E
	dc.w	$4A28	;4A28
	dc.w	$C5D7	;C5D7
	dc.w	$76F7	;76F7
	dc.w	$B5D3	;B5D3
	dc.w	$0459	;0459
	dc.w	$D4A6	;D4A6
	dc.w	$4A59	;4A59
	dc.w	$FB88	;FB88
	dc.w	$4E76	;4E76
	dc.w	$DA8D	;DA8D
	dc.w	$2DF2	;2DF2
	dc.w	$B188	;B188
	dc.w	$46F7	;46F7
	dc.w	$D20D	;D20D
	dc.w	$3E32	;3E32
	dc.w	$B9B7	;B9B7
	dc.w	$D100	;D100
	dc.w	$263F	;263F
	dc.w	$4648	;4648
	dc.w	$AA77	;AA77
	dc.w	$D97F	;D97F
	dc.w	$D100	;D100
	dc.w	$0EE0	;0EE0
	dc.w	$912F	;912F
	dc.w	$0FD0	;0FD0
	dc.w	$F115	;F115
	dc.w	$1D2A	;1D2A
	dc.w	$F090	;F090
	dc.w	$D100	;D100
	dc.w	$608A	;608A
	dc.w	$8F4C	;8F4C
	dc.w	$2E40	;2E40
	dc.w	$D100	;D100
	dc.w	$2EFF	;2EFF
	dc.w	$D1C0	;D1C0
	dc.w	$113E	;113E
	dc.w	$DCEF	;DCEF
	dc.w	$D1D5	;D1D5
	dc.w	$782B	;782B
	dc.w	$8454	;8454
	dc.w	$49B4	;49B4
	dc.w	$BE65	;BE65
	dc.w	$7BAB	;7BAB
	dc.w	$FFEF	;FFEF
	dc.w	$6714	;6714
	dc.w	$906B	;906B
	dc.w	$0012	;0012
	dc.w	$B198	;B198
	dc.w	$2F67	;2F67
	dc.w	$FFCD	;FFCD
	dc.w	$080B	;080B
	dc.w	$D098	;D098
	dc.w	$00BF	;00BF
	dc.w	$EE01	;EE01
	dc.w	$7708	;7708
	dc.w	$DB77	;DB77
	dc.w	$4266	;4266
	dc.w	$F3EC	;F3EC
	dc.w	$042A	;042A
	dc.w	$BD99	;BD99
	dc.w	$00BF	;00BF
	dc.w	$EE01	;EE01
	dc.w	$77E2	;77E2
	dc.w	$DB9D	;DB9D
	dc.w	$437A	;437A
	dc.w	$AF79	;AF79
	dc.w	$246A	;246A
	dc.w	$00BF	;00BF
	dc.w	$EE01	;EE01
	dc.w	$0202	;0202
	dc.w	$FF8C	;FF8C
	dc.w	$00BF	;00BF
	dc.w	$E401	;E401
	dc.w	$0802	;0802
	dc.w	$FF42	;FF42
	dc.w	$00BF	;00BF
	dc.w	$E501	;E501
	dc.w	$548B	;548B
	dc.w	$AB74	;AB74
	dc.w	$1AFE	;1AFE
	dc.w	$E501	;E501
	dc.w	$548B	;548B
	dc.w	$AB74	;AB74
	dc.w	$1AFE	;1AFE
	dc.w	$E501	;E501
	dc.w	$548B	;548B
	dc.w	$AB74	;AB74
	dc.w	$1AFE	;1AFE
	dc.w	$E501	;E501
	dc.w	$548B	;548B
	dc.w	$AB74	;AB74
	dc.w	$1AFE	;1AFE
	dc.w	$E501	;E501
	dc.w	$548B	;548B
	dc.w	$AB74	;AB74
	dc.w	$1AFE	;1AFE
	dc.w	$E501	;E501
	dc.w	$548B	;548B
	dc.w	$AB74	;AB74
	dc.w	$1AFE	;1AFE
	dc.w	$E501	;E501
	dc.w	$548B	;548B
	dc.w	$EA8E	;EA8E
	dc.w	$E032	;E032
	dc.w	$3E8D	;3E8D
	dc.w	$156D	;156D
	dc.w	$AB68	;AB68
	dc.w	$3BF6	;3BF6
	dc.w	$E489	;E489
	dc.w	$3A37	;3A37
	dc.w	$C40D	;C40D
	dc.w	$7708	;7708
	dc.w	$C537	;C537
	dc.w	$FAB8	;FAB8
	dc.w	$257E	;257E
	dc.w	$3AC8	;3AC8
	dc.w	$0004	;0004
	dc.w	$DDFB	;DDFB
	dc.w	$63FE	;63FE
	dc.w	$FFD9	;FFD9
	dc.w	$2F6E	;2F6E
	dc.w	$9C03	;9C03
	dc.w	$2900	;2900
	dc.w	$203A	;203A
	dc.w	$FACA	;FACA
	dc.w	$6B04	;6B04
	dc.w	$4E7B	;4E7B
	dc.w	$0002	;0002
	dc.w	$48F9	;48F9
	dc.w	$00FF	;00FF
	dc.w	$0000	;0000
	dc.w	$0008	;0008
	dc.w	$4CFA	;4CFA
	dc.w	$7FFF	;7FFF
	dc.w	$FA4E	;FA4E
	dc.w	$4E73	;4E73

adrEA00E0D6:	movem.l	(sp)+,a4-a6	;4CDF7000
	sub.l	#$4F8B3912,d0	;04804F8B3912
	rts	;4E75

adrCd00E0E2:	move.l	#$000D0002,adrW_00E3FA.l	;23FC000D00020000E3FA
	cmp.b	$0040(a5),d7	;BE2D0040
	bne.s	adrCd00E108	;6616
	tst.b	$0041(a5)	;4A2D0041
	bne.s	adrCd00E108	;6610
	move.w	$0010(a5),adrW_00E3FC.l	;33ED00100000E3FC
	move.w	#$000E,adrW_00E3FA.l	;33FC000E0000E3FA
adrCd00E108:	move.b	(a6)+,d0	;101E
	cmp.b	#$FA,d0	;0C0000FA
	beq.s	adrCd00E118	;6708
	bcc.s	adrCd00E120	;640E
	bsr	adrCd00E2B2	;6100019E
	bra.s	adrCd00E108	;60F0

adrCd00E118:	move.b	(a6)+,d0	;101E
	bsr	adrCd00E390	;61000274
	bra.s	adrCd00E108	;60E8

adrCd00E120:	cmp.b	#$FF,d0	;0C0000FF
	beq	adrCd00DB06	;6700F9E0
	cmp.b	#$FC,d0	;0C0000FC
	bne.s	adrCd00E108	;66DA
	addq.w	#$01,a0	;5248
	move.b	#$FF,adrB_00F989.l	;13FC00FF0000F989
	move.l	#$000D0002,adrW_00E3FA.l	;23FC000D00020000E3FA
	cmp.b	$0040(a5),d7	;BE2D0040
	bne.s	adrCd00E108	;66C0
	tst.b	$0041(a5)	;4A2D0041
	beq.s	adrCd00E108	;67BA
	move.w	$0010(a5),adrW_00E3FC.l	;33ED00100000E3FC
	move.w	#$000E,adrW_00E3FA.l	;33FC000E0000E3FA
	bra.s	adrCd00E108	;60A8

adrCd00E160:	lea	CharacterStats.l,a1	;43F90000F586
	moveq	#$00,d5	;7A00
	move.b	d0,d5	;1A00
	asl.w	#$06,d5	;ED45
	add.w	d5,a1	;D2C5
	cmp.b	#$10,$0001(a1)	;0C2900100001
	bcs	adrCd00E2BA	;65000144
	movem.l	d6/d7/a6,-(sp)	;48E70302
	moveq	#$00,d0	;7000
	move.b	$0001(a1),d0	;10290001
	move.b	$0024(a1),d1	;12290024
	move.b	(a1),d2	;1411
	lea	adrEA0044C2.l,a6	;4DF9000044C2
	bsr.s	adrCd00E1C4	;6134
	lea	adrEA0044C2.l,a3	;47F9000044C2
	moveq	#-$01,d5	;7AFF
adrCd00E198:	addq.w	#$01,d5	;5245
	cmp.b	#$20,$00(a3,d5.w)	;0C3300205000
	bne.s	adrCd00E198	;66F6
	movem.l	(sp)+,d6/d7/a6	;4CDF40C0
	bra	adrCd00E2BC	;60000114

adrCd00E1AA:	sub.b	#$10,d0	;04000010
	or.w	#$FF30,d0	;0040FF30
	move.w	d0,d7	;3E00
	move.b	d2,d0	;1002
	asl.w	#$05,d0	;EB40
	add.w	d0,d7	;DE40
	moveq	#$00,d0	;7000
	move.b	d7,d0	;1007
	ror.w	#$07,d0	;EE58
	eor.w	d0,d7	;B147
	rts	;4E75

adrCd00E1C4:	bsr.s	adrCd00E1AA	;61E4
	moveq	#$00,d6	;7C00
	btst	#$00,d1	;08010000
	beq.s	adrCd00E1D0	;6702
	moveq	#$07,d6	;7C07
adrCd00E1D0:	lea	adrEA00E21C.l,a3	;47F90000E21C
	moveq	#$02,d2	;7402
adrLp00E1D8:	bsr.s	adrCd00E1F0	;6116
	dbra	d2,adrLp00E1D8	;51CAFFFC
	move.b	#$20,(a6)+	;1CFC0020
	moveq	#$03,d2	;7403
adrLp00E1E4:	bsr.s	adrCd00E1F0	;610A
	dbra	d2,adrLp00E1E4	;51CAFFFC
	move.b	#$FF,(a6)+	;1CFC00FF
	rts	;4E75

adrCd00E1F0:	moveq	#$00,d0	;7000
	move.b	$00(a3,d6.w),d0	;10336000
	addq.w	#$01,d6	;5246
	asl.w	#$02,d0	;E540
	move.l	$0E(a3,d0.w),a2	;2473000E
	move.w	d7,d0	;3007
	ror.w	#$04,d7	;E85F
	and.w	#$0007,d0	;02400007
	moveq	#$00,d1	;7200
adrLp00E208:	move.b	(a2)+,d1	;121A
	add.w	d1,a2	;D4C1
	dbra	d0,adrLp00E208	;51C8FFFA
	sub.w	d1,a2	;94C1
	subq.w	#$01,d1	;5341
adrLp00E214:	move.b	(a2)+,(a6)+	;1CDA
	dbra	d1,adrLp00E214	;51C9FFFC
	rts	;4E75

adrEA00E21C:	dc.w	$0001	;0001
	dc.w	$0202	;0202
	dc.w	$0102	;0102
	dc.w	$0102	;0102
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0201	;0201
	dc.w	$0000	;0000
	dc.w	$E236	;E236
	dc.w	$0000	;0000
	dc.w	$E24E	;E24E
	dc.w	$0000	;0000
	dc.w	$E261	;E261
	dc.w	$0253	;0253
	dc.w	$4902	;4902
	dc.w	$4D55	;4D55
	dc.w	$0242	;0242
	dc.w	$4102	;4102
	dc.w	$5459	;5459
	dc.w	$0241	;0241
	dc.w	$5202	;5202
	dc.w	$4C55	;4C55
	dc.w	$024F	;024F
	dc.w	$5302	;5302
	dc.w	$5A4F	;5A4F
	dc.w	$0254	;0254
	dc.w	$4801	;4801
	dc.w	$4D01	;4D01
	dc.w	$4E01	;4E01
	dc.w	$5001	;5001
	dc.w	$5202	;5202
	dc.w	$5254	;5254
	dc.w	$0153	;0153
	dc.w	$0245	;0245
	dc.w	$4E02	;4E02
	dc.w	$5241	;5241
	dc.w	$0341	;0341
	dc.w	$4E41	;4E41
	dc.w	$0250	;0250
	dc.w	$4902	;4902
	dc.w	$4455	;4455
	dc.w	$0345	;0345
	dc.w	$4D41	;4D41
	dc.w	$0349	;0349
	dc.w	$424F	;424F
	dc.w	$0341	;0341
	dc.w	$564F	;564F
	dc.w	$0247	;0247
	dc.w	$4F00	;4F00

adrCd00E27E:	lea	adrEA00E734.l,a3	;47F90000E734
adrCd00E284:	and.w	#$00FF,d0	;024000FF
	moveq	#$00,d5	;7A00
adrLp00E28A:	add.w	d5,a3	;D6C5
	move.b	(a3)+,d5	;1A1B
	dbra	d0,adrLp00E28A	;51C8FFFA
	rts	;4E75

adrCd00E294:	lea	ObjectsDictionary.l,a3	;47F90000ECEE
	cmp.b	#$45,d0	;0C000045
	bcs.s	adrCd00E2AE	;650E
	cmp.b	#$55,d0	;0C000055
	bcc.s	adrCd00E2AE	;6408
	sub.b	#$45,d0	;04000045
	bra	adrCd00E160	;6000FEB4

adrCd00E2AE:	bsr.s	adrCd00E284	;61D4
	bra.s	adrCd00E2BC	;600A

adrCd00E2B2:	cmp.b	#$10,d0	;0C000010
	bcs	adrCd00E160	;6500FEA8
adrCd00E2BA:	bsr.s	adrCd00E27E	;61C2
adrCd00E2BC:	sub.w	d5,d6	;9C45
	subq.w	#$01,d5	;5345
adrLp00E2C0:	move.b	(a3)+,d0	;101B
	bsr	adrCd00E390	;610000CC
	dbra	d5,adrLp00E2C0	;51CDFFF8
	rts	;4E75

adrCd00E2CC:	bsr	adrCd00D96C	;6100F69E
	move.b	(a6)+,d0	;101E
	bsr.s	adrCd00E294	;61C0
	subq.w	#$01,d6	;5346
	moveq	#$20,d0	;7020
	bsr	adrCd00E390	;610000B6
	move.b	(a6),d0	;1016
	bmi.s	adrCd00E2E2	;6B02
	bsr.s	adrCd00E294	;61B2
adrCd00E2E2:	tst.w	d6	;4A46
	bpl	adrCd00D9FE	;6A00F718
	rts	;4E75

adrCd00E2EA:	move.b	#$81,d2	;143C0081
	bra.s	adrCd00E2F2	;6002

;fiX Label expected
	moveq	#$00,d2	;7400
adrCd00E2F2:	tst.b	$0005(a4)	;4A2C0005
	bpl.s	adrCd00E342	;6A4A
	movem.l	d2/a6,-(sp)	;48E72002
	bsr.s	adrCd00E342	;6144
	movem.l	(sp)+,d2/a6	;4CDF4004
	lea	Player1_Data.l,a0	;41F90000F9D8
	btst	#$00,(a5)	;08150000
	bne.s	adrCd00E314	;6606
	lea	Player2_Data.l,a0	;41F90000FA3A
adrCd00E314:	movem.l	a4/a5,-(sp)	;48E7000C
	move.l	a0,a5	;2A48
	move.b	$0001(a4),d0	;102C0001
	jsr	adrCd00498E.l	;4EB90000498E
	tst.b	$0005(a4)	;4A2C0005
	bpl.s	adrCd00E32E	;6A04
	move.b	d0,$0000(a4)	;19400000
adrCd00E32E:	or.b	#$40,d2	;00020040
	bsr.s	adrCd00E342	;610E
	movem.l	(sp)+,a4/a5	;4CDF3000
	rts	;4E75

adrCd00E33A:	move.b	#$81,d2	;143C0081
	bra.s	adrCd00E342	;6002

adrCd00E340:	moveq	#$00,d2	;7400
adrCd00E342:	move.b	d2,$0052(a5)	;1B420052
	bsr	adrCd00DA7A	;6100F732
adrCd00E34A:	move.b	(a6)+,d0	;101E
	cmp.b	#$FA,d0	;0C0000FA
	bcc.s	adrCd00E364	;6412
	bsr	adrCd00E2B2	;6100FF5E
adrCd00E356:	tst.w	d6	;4A46
	bmi	adrCd00D9FE	;6B00F6A4
	moveq	#$20,d0	;7020
	bsr.s	adrCd00E390	;6130
	subq.w	#$01,d6	;5346
	bra.s	adrCd00E34A	;60E6

adrCd00E364:	beq.s	adrCd00E388	;6722
	cmp.b	#$FF,d0	;0C0000FF
	beq	adrCd00D9FE	;6700F692
	cmp.b	#$FB,d0	;0C0000FB
	beq.s	adrCd00E382	;670E
	cmp.b	#$FE,d0	;0C0000FE
	bne.s	adrCd00E34A	;66D0
	move.b	(a6)+,d0	;101E
	bsr	adrCd00E294	;6100FF16
	bra.s	adrCd00E356	;60D4

adrCd00E382:	addq.w	#$01,d6	;5246
	subq.w	#$01,a0	;5348
	bra.s	adrCd00E34A	;60C2

adrCd00E388:	subq.w	#$01,a0	;5348
	move.b	(a6)+,d0	;101E
	bsr.s	adrCd00E390	;6102
	bra.s	adrCd00E356	;60C6

adrCd00E390:	move.l	a0,-(sp)	;2F08
	lea	adrEA016ACC.l,a1	;43F900016ACC
	moveq	#$00,d1	;7200
	move.b	d0,d1	;1200
	move.w	d1,d0	;3001
	asl.w	#$02,d0	;E540
	add.w	d1,d0	;D041
	add.w	d0,a1	;D2C0
	moveq	#$04,d0	;7004
adrLp00E3A6:	move.b	(a1),d1	;1211
	swap	d1	;4841
	move.b	(a1)+,d1	;1219
	tst.b	adrB_00F989.l	;4A390000F989
	beq.s	adrCd00E3B8	;6704
	add.l	d1,d1	;D281
	add.l	d1,d1	;D281
adrCd00E3B8:	not.b	d1	;4601
	swap	d0	;4840
	move.w	#$0003,d0	;303C0003
	move.w	#$5DC0,d4	;383C5DC0
adrLp00E3C4:	move.b	d1,d3	;1601
	btst	d0,adrB_00E3FD(pc)	;013A0035
	bne.s	adrCd00E3CE	;6602
	clr.b	d3	;4203
adrCd00E3CE:	swap	d1	;4841
	move.b	d1,d2	;1401
	swap	d1	;4841
	btst	d0,adrB_00E3FB(pc)	;013A0025
	bne.s	adrCd00E3DC	;6602
	clr.b	d2	;4202
adrCd00E3DC:	or.b	d3,d2	;8403
	move.b	d2,$00(a0,d4.w)	;11824000
	sub.w	#$1F40,d4	;04441F40
	dbra	d0,adrLp00E3C4	;51C8FFDC
	swap	d0	;4840
	add.w	#$0028,a0	;D0FC0028
	dbra	d0,adrLp00E3A6	;51C8FFB4
	move.l	(sp)+,a0	;205F
	addq.w	#$01,a0	;5248
	rts	;4E75

adrW_00E3FA:	dc.b	$00	;00
adrB_00E3FB:	dc.b	$01	;01
adrW_00E3FC:	dc.b	$00	;00
adrB_00E3FD:	dc.b	$00	;00

adrCd00E3FE:	move.w	#$000F,adrW_00E3FC.l	;33FC000F0000E3FC
	movem.l	d4/d5,-(sp)	;48E70C00
	lea	adrEA00E458.l,a0	;41F90000E458
	move.l	a0,a1	;2248
	moveq	#$09,d2	;7409
	moveq	#-$01,d1	;72FF
adrLp00E416:	move.l	d1,(a1)+	;22C1
	dbra	d2,adrLp00E416	;51CAFFFC
	move.b	#$FF,adrB_00F989.l	;13FC00FF0000F989
	bsr	adrCd00E480	;6100005A
	clr.b	adrB_00F989.l	;42390000F989
	movem.l	(sp)+,d4/d5	;4CDF0030
	move.l	a0,a1	;2248
	move.w	d4,d1	;3204
	and.w	#$FFF7,d4	;0244FFF7
	bsr	adrCd00E724	;610002E8
	move.w	d1,d4	;3801
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	d0,a0	;D0C0
	lea	adrEA00BA78.l,a6	;4DF90000BA78
	moveq	#$04,d7	;7E04
	swap	d7	;4847
	moveq	#$00,d6	;7C00
	bra	adrCd00BC26	;6000D7D0

adrEA00E458:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000

adrCd00E480:	lea	adrEA016ACC.l,a1	;43F900016ACC
	move.l	a0,-(sp)	;2F08
	and.w	#$007F,d0	;0240007F
	move.w	d0,d2	;3400
	asl.w	#$02,d0	;E540
	add.w	d2,d0	;D042
	add.w	d0,a1	;D2C0
	move.l	adrW_00E3FA.l,d2	;24390000E3FA
	lea	adrEA00E4E8.l,a2	;45F90000E4E8
	asl.w	#$02,d2	;E542
	move.l	$00(a2,d2.w),d3	;26322000
	swap	d2	;4842
	asl.w	#$02,d2	;E542
	move.l	$00(a2,d2.w),d2	;24322000
	moveq	#$04,d1	;7204
adrLp00E4B0:	move.b	(a1),d0	;1011
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
	dbra	d1,adrLp00E4B0	;51C9FFCE
	move.l	(sp)+,a0	;205F
	rts	;4E75

adrEA00E4E8:	
	dc.l	$00000000	;00000000
	dc.l	$FF000000	;FF000000
	dc.l	$00FF0000	;00FF0000
	dc.l	$FFFF0000	;FFFF0000
	dc.l	$0000FF00	;0000FF00	;Long Addr replaced with Symbol
	dc.l	$FF00FF00	;FF00FF00
	dc.l	$00FFFF00	;00FFFF00
	dc.l	$FFFFFF00	;FFFFFF00
	dc.l	$000000FF	;000000FF
	dc.l	$FF0000FF	;FF0000FF
	dc.l	$00FF00FF	;00FF00FF
	dc.l	$FFFF00FF	;FFFF00FF
	dc.l	$0000FFFF	;0000FFFF	;Long Addr replaced with Symbol
	dc.l	$FF00FFFF	;FF00FFFF
	dc.l	$00FFFFFF	;00FFFFFF
	dc.l	$FFFFFFFF	;FFFFFFFF
	dc.l	$48434844	;48434844
	dc.l	$48453803	;48453803
	dc.l	$3A034843	;3A034843
	dc.l	$48444845	;48444845

adrCd00E538:	swap	d4	;4844
	swap	d3	;4843
	move.w	d4,d3	;3604
	swap	d4	;4844
	swap	d3	;4843
	swap	d5	;4845
	move.w	d5,d7	;3E05
	swap	d5	;4845
adrLp00E548:	bsr	adrCd00E654	;6100010A
	addq.w	#$01,d5	;5245
	dbra	d7,adrLp00E548	;51CFFFF8
	rts	;4E75

;fiX Label expected
	addq.w	#$01,d4	;5244
	swap	d4	;4844
	swap	d3	;4843
	move.w	d4,d3	;3604
	subq.w	#$02,d3	;5543
	swap	d4	;4844
	swap	d3	;4843
	bsr	adrCd00E654	;610000F0
	swap	d5	;4845
	move.w	d5,d7	;3E05
	swap	d5	;4845
	add.w	d7,d5	;DA47
	bsr	adrCd00E654	;610000E4
	sub.w	d7,d5	;9A47
	subq.w	#$01,d4	;5344
	addq.w	#$01,d5	;5245
	swap	d5	;4845
	swap	d3	;4843
	move.w	d5,d3	;3605
	subq.w	#$02,d3	;5543
	swap	d3	;4843
	swap	d5	;4845
	bsr	adrCd00E5D4	;6100004E
	swap	d4	;4844
	move.w	d4,d7	;3E04
	swap	d4	;4844
	add.w	d7,d4	;D847
	bra	adrCd00E5D4	;60000042

;fiX Label expected
	swap	d3	;4843
	swap	d4	;4844
	swap	d5	;4845
	move.w	d3,d4	;3803
	move.w	d3,d5	;3A03
	swap	d3	;4843
	swap	d4	;4844
	swap	d5	;4845
adrCd00E5A4:	swap	d4	;4844
	swap	d3	;4843
	move.w	d4,d3	;3604
	swap	d4	;4844
	swap	d3	;4843
	bsr	adrCd00E654	;610000A4
	swap	d5	;4845
	move.w	d5,d7	;3E05
	swap	d5	;4845
	add.w	d7,d5	;DA47
	bsr	adrCd00E654	;61000098
	sub.w	d7,d5	;9A47
	swap	d5	;4845
	swap	d3	;4843
	move.w	d5,d3	;3605
	swap	d5	;4845
	swap	d3	;4843
	bsr.s	adrCd00E5D4	;6108
	swap	d4	;4844
	move.w	d4,d7	;3E04
	swap	d4	;4844
	add.w	d7,d4	;D847
adrCd00E5D4:	bsr	adrCd00E724	;6100014E
	move.l	screen_ptr.l,a0	;207900009B06
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
adrLp00E60E:	move.b	(a0),d7	;1E10
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
	dbra	d2,adrLp00E60E	;51CAFFC6
	rts	;4E75

adrEA00E64C:	dc.w	$0000	;0000
	dc.w	$00FF	;00FF
	dc.w	$FF00	;FF00
	dc.w	$FFFF	;FFFF

adrCd00E654:	movem.l	d3-d5,-(sp)	;48E71C00
	bsr	adrCd00E724	;610000CA
	move.l	screen_ptr.l,a0	;207900009B06
	add.w	d0,a0	;D0C0
	lea	adrEA00E64C.l,a1	;43F90000E64C
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
	beq.s	adrCd00E6E4	;6756
	subq.w	#$08,d2	;5142
	neg.w	d2	;4442
	cmp.w	d2,d3	;B642
	bgt.s	adrCd00E6CE	;6E38
	moveq	#-$01,d2	;74FF
	and.w	#$0007,d4	;02440007
	lsr.b	d3,d2	;E62A
	not.b	d2	;4602
	lsr.b	d4,d2	;E82A
	move.b	d2,d3	;1602
	not.b	d3	;4603
	bsr	adrCd00E6AC	;61000004
	bra.s	adrCd00E71E	;6072

adrCd00E6AC:	move.l	d0,d6	;2C00
	moveq	#$03,d5	;7A03
	moveq	#$00,d4	;7800
adrLp00E6B2:	move.b	$00(a0,d4.w),d1	;12304000
	and.b	d2,d0	;C002
	and.b	d3,d1	;C203
	or.b	d0,d1	;8200
	move.b	d1,$00(a0,d4.w)	;11814000
	ror.l	#$08,d0	;E098
	add.w	#$1F40,d4	;06441F40
	dbra	d5,adrLp00E6B2	;51CDFFEA
	move.l	d6,d0	;2006
	rts	;4E75

adrCd00E6CE:	sub.w	d2,d3	;9642
	swap	d3	;4843
	and.w	#$0007,d4	;02440007
	moveq	#-$01,d2	;74FF
	lsr.b	d4,d2	;E82A
	move.b	d2,d3	;1602
	not.b	d3	;4603
	bsr.s	adrCd00E6AC	;61CC
	swap	d3	;4843
	addq.w	#$01,a0	;5248
adrCd00E6E4:	move.w	d3,d4	;3803
	lsr.w	#$03,d3	;E64B
	beq.s	adrCd00E70E	;6724
	subq.w	#$01,d3	;5343
	move.l	a0,a1	;2248
	moveq	#$00,d2	;7400
	moveq	#$03,d5	;7A03
adrLp00E6F2:	move.l	a1,a0	;2049
	add.w	d2,a0	;D0C2
	move.w	d3,d1	;3203
adrLp00E6F8:	move.b	d0,(a0)+	;10C0
	dbra	d1,adrLp00E6F8	;51C9FFFC
	ror.l	#$08,d0	;E098
	add.w	#$1F40,d2	;06421F40
	dbra	d5,adrLp00E6F2	;51CDFFEC
	sub.w	#$1F40,d2	;04421F40
	sub.w	d2,a0	;90C2
adrCd00E70E:	and.w	#$0007,d4	;02440007
	beq.s	adrCd00E71E	;670A
	moveq	#-$01,d3	;76FF
	lsr.b	d4,d3	;E82B
	move.b	d3,d2	;1403
	not.b	d2	;4602
	bsr.s	adrCd00E6AC	;618E
adrCd00E71E:	movem.l	(sp)+,d3-d5	;4CDF0038
	rts	;4E75

adrCd00E724:	move.w	d5,d0	;3005
	add.w	d0,d0	;D040
	add.w	d0,d0	;D040
	add.w	d5,d0	;D045
	asl.w	#$06,d0	;ED40
	add.w	d4,d0	;D044
	lsr.w	#$03,d0	;E648
	rts	;4E75

adrEA00E734:	dc.b	$07	;07
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
	dc.b	'ELFRIC',$A	;454C465249430A
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
	dc.b	'HENGIST',$A	;48454E474953540A
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
	dc.b	'WIZARD',$A	;57495A4152440A
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
	dc.b	'SLAEMWORT',$A	;534C41454D574F52540A
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
	dc.b	'BHOAGHAIL',$A	;42484F41474841494C0A
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
	dc.b	'UNRIVALED',$A	;554E524956414C45440A
	dc.b	'INCREDIBLE',$A	;494E4352454449424C450A
	dc.b	'STUPENDOUS'	;53545550454E444F5553
	dc.b	$07	;07
	dc.b	'GODLIKE',$A	;474F444C494B450A
	dc.b	'UNDISPUTED',$A	;554E44495350555445440A
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
	dc.b	'HUGELY',$A	;485547454C590A
	dc.b	'INCREDIBLY',$A	;494E4352454449424C590A
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
	dc.b	'EXPERT',$C	;4558504552540C
	dc.b	'DISGUSTINGLY'	;44495347555354494E474C59
	dc.b	$0B	;0B
	dc.b	'GROTESQUELY'	;47524F5445535155454C59
	dc.b	$0B	;0B
	dc.b	'SICKENINGLY'	;5349434B454E494E474C59
	dc.b	$07	;07
	dc.b	'UTTERLY',$C	;55545445524C590C
	dc.b	'UNBELIEVABLY'	;554E42454C49455641424C59
	dc.b	$0B	;0B
	dc.b	'ABHORRENTLY'	;4142484F5252454E544C59
	dc.b	$0B	;0B
	dc.b	'APPALLINGLY',$D	;415050414C4C494E474C590D
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
	dc.b	'ZOMBIE',$A	;5A4F4D4249450A
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
	dc.b	$06	;06
	dc.b	'blank9'	;626C616E6B39
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
	dc.b	$04	;04
	dc.b	'SOUL'	;534F554C
	dc.b	$05	;05
	dc.b	'SWORD'	;53574F5244
	dc.b	$06	;06
	dc.b	'SUCKER'	;5355434B4552
	dc.b	$04	;04
	dc.b	'LONG'	;4C4F4E47
	dc.b	$04	;04
	dc.b	'BOOK'	;424F4F4B
	dc.b	$09	;09
	dc.b	'FLESHBANE'	;464C45534842414E45
	dc.b	$05	;05
	dc.b	'DEMON',$D	;44454D4F4E0D
	dc.b	'ACE OF SWORDS'	;414345204F462053574F524453
	dc.b	$05	;05
	dc.b	'FROST'	;46524F5354
	dc.b	$03	;03
	dc.b	'AXE'	;415845
	dc.b	$06	;06
	dc.b	'OGRE''S',$C	;4F47524527530C
	dc.b	'DEATHBRINGER'	;44454154484252494E474552
	dc.b	$04	;04
	dc.b	'GREY'	;47524559
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
	dc.b	'ELFRIC',$A	;454C465249430A
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
	dc.b	'HENGIST',$A	;48454E474953540A
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
	dc.b	'GEM',0	;47454D00
ObjectDefinitionsTable:	dc.b	$00	;00
	dc.b	$00	;00
	dc.w	$0001	;0001
	dc.w	$0100	;0100
	dc.w	$02FF	;02FF
	dc.w	$0200	;0200
	dc.w	$0304	;0304
	dc.w	$0300	;0300
	dc.w	$06FF	;06FF
	dc.w	$0400	;0400
	dc.w	$0506	;0506
	dc.w	$2D00	;2D00
	dc.w	$0EFF	;0EFF
	dc.w	$2E00	;2E00
	dc.w	$0EFF	;0EFF
	dc.w	$2F00	;2F00
	dc.w	$0EFF	;0EFF
	dc.w	$3000	;3000
	dc.w	$0EFF	;0EFF
	dc.w	$3100	;3100
	dc.w	$0EFF	;0EFF
	dc.w	$3200	;3200
	dc.w	$0EFF	;0EFF
	dc.w	$3300	;3300
	dc.w	$0EFF	;0EFF
	dc.w	$3400	;3400
	dc.w	$0EFF	;0EFF
	dc.w	$3500	;3500
	dc.w	$0EFF	;0EFF
	dc.w	$370B	;370B
	dc.w	$42FF	;42FF
	dc.w	$380B	;380B
	dc.w	$42FF	;42FF
	dc.w	$390B	;390B
	dc.w	$42FF	;42FF
	dc.w	$3707	;3707
	dc.w	$43FF	;43FF
	dc.w	$3807	;3807
	dc.w	$43FF	;43FF
	dc.w	$3907	;3907
	dc.w	$43FF	;43FF
	dc.w	$3605	;3605
	dc.w	$08FF	;08FF
	dc.w	$3607	;3607
	dc.w	$08FF	;08FF
	dc.w	$360C	;360C
	dc.w	$08FF	;08FF
	dc.w	$0B06	;0B06
	dc.w	$0A10	;0A10
	dc.w	$0B0D	;0B0D
	dc.w	$1112	;1112
	dc.w	$0B0C	;0B0C
	dc.w	$0C13	;0C13
	dc.w	$0B07	;0B07
	dc.w	$1415	;1415
	dc.w	$1600	;1600
	dc.w	$1C20	;1C20
	dc.w	$1703	;1703
	dc.w	$2122	;2122
	dc.w	$1803	;1803
	dc.w	$2522	;2522
	dc.w	$1708	;1708
	dc.w	$2321	;2321
	dc.w	$1808	;1808
	dc.w	$2325	;2325
	dc.w	$1706	;1706
	dc.w	$2421	;2421
	dc.w	$1806	;1806
	dc.w	$2425	;2425
	dc.w	$170B	;170B
	dc.w	$0721	;0721
	dc.w	$180B	;180B
	dc.w	$0725	;0725
	dc.w	$0F0C	;0F0C
	dc.w	$1A1B	;1A1B
	dc.w	$0F05	;0F05
	dc.w	$1A1B	;1A1B
	dc.w	$0F00	;0F00
	dc.w	$1A1B	;1A1B
	dc.w	$1200	;1200
	dc.w	$1F1B	;1F1B
	dc.w	$1300	;1300
	dc.w	$3641	;3641
	dc.w	$1500	;1500
	dc.w	$1730	;1730
	dc.w	$1400	;1400
	dc.w	$2A25	;2A25
	dc.w	$480D	;480D
	dc.w	$0B27	;0B27
	dc.w	$4803	;4803
	dc.w	$1727	;1727
	dc.w	$4808	;4808
	dc.w	$2327	;2327
	dc.w	$4806	;4806
	dc.w	$2427	;2427
	dc.w	$480B	;480B
	dc.w	$0727	;0727
	dc.w	$1C00	;1C00
	dc.w	$28FF	;28FF
	dc.w	$1E00	;1E00
	dc.w	$2B2C	;2B2C
	dc.w	$2206	;2206
	dc.w	$2431	;2431
	dc.w	$2300	;2300
	dc.w	$35FF	;35FF
	dc.w	$5700	;5700
	dc.w	$362C	;362C
	dc.w	$2400	;2400
	dc.w	$1A31	;1A31
	dc.w	$2500	;2500
	dc.w	$3032	;3032
	dc.w	$2600	;2600
	dc.w	$37FF	;37FF
	dc.w	$2705	;2705
	dc.w	$2439	;2439
	dc.w	$2800	;2800
	dc.w	$3A39	;3A39
	dc.w	$5B00	;5B00
	dc.w	$3BFF	;3BFF
	dc.w	$2A00	;2A00
	dc.w	$0C39	;0C39
	dc.w	$2900	;2900
	dc.w	$3C39	;3C39
	dc.w	$0D02	;0D02
	dc.w	$18FF	;18FF
	dc.w	$0D03	;0D03
	dc.w	$1718	;1718
	dc.w	$0D0B	;0D0B
	dc.w	$2F18	;2F18
	dc.w	$3A06	;3A06
	dc.w	$4540	;4540
	dc.w	$3A0D	;3A0D
	dc.w	$4640	;4640
	dc.w	$3A0C	;3A0C
	dc.w	$4740	;4740
	dc.w	$3A08	;3A08
	dc.w	$4840	;4840
	dc.w	$3A0D	;3A0D
	dc.w	$4940	;4940
	dc.w	$3A0C	;3A0C
	dc.w	$4A40	;4A40
	dc.w	$3A08	;3A08
	dc.w	$4B40	;4B40
	dc.w	$3A06	;3A06
	dc.w	$4C40	;4C40
	dc.w	$3A0C	;3A0C
	dc.w	$4D40	;4D40
	dc.w	$3A08	;3A08
	dc.w	$4E40	;4E40
	dc.w	$3A06	;3A06
	dc.w	$4F40	;4F40
	dc.w	$3A0D	;3A0D
	dc.w	$5040	;5040
	dc.w	$3A08	;3A08
	dc.w	$5140	;5140
	dc.w	$3A06	;3A06
	dc.w	$5240	;5240
	dc.w	$3A0D	;3A0D
	dc.w	$5340	;5340
	dc.w	$3A0C	;3A0C
	dc.w	$5440	;5440
	dc.w	$0C0A	;0C0A
	dc.w	$2616	;2616
	dc.w	$0C04	;0C04
	dc.w	$2916	;2916
	dc.w	$0C06	;0C06
	dc.w	$0A16	;0A16
	dc.w	$0C0D	;0C0D
	dc.w	$0B16	;0B16
	dc.w	$0C0C	;0C0C
	dc.w	$0C16	;0C16
	dc.w	$0C08	;0C08
	dc.w	$0D16	;0D16
	dc.w	$0C0E	;0C0E
	dc.w	$2A16	;2A16
	dc.w	$0E06	;0E06
	dc.w	$0A19	;0A19
	dc.w	$0E0D	;0E0D
	dc.w	$0B19	;0B19
	dc.w	$0E0C	;0E0C
	dc.w	$0C19	;0C19
	dc.w	$0E07	;0E07
	dc.w	$0D19	;0D19
	dc.w	$0E0E	;0E0E
	dc.w	$2D19	;2D19
	dc.w	$2B05	;2B05
	dc.w	$333D	;333D
	dc.w	$2B0E	;2B0E
	dc.w	$383D	;383D
	dc.w	$2C00	;2C00
	dc.w	$3E3D	;3E3D
	dc.w	$1900	;1900
	dc.w	$2EFF	;2EFF
	dc.w	$0600	;0600
	dc.w	$0A07	;0A07
	dc.w	$0700	;0700
	dc.w	$0B07	;0B07
	dc.w	$0800	;0800
	dc.w	$0C07	;0C07
	dc.w	$0900	;0900
	dc.w	$0D07	;0D07
	dc.w	$0500	;0500
	dc.w	$0959	;0959
	dc.w	$1F00	;1F00
	dc.w	$5659	;5659
	dc.w	$2000	;2000
	dc.w	$5759	;5759
	dc.w	$2100	;2100
	dc.w	$5859	;5859
	dc.w	$0A04	;0A04
	dc.w	$093F	;093F
	dc.w	$1D06	;1D06
	dc.w	$0A3F	;0A3F
	dc.w	$1D0D	;1D0D
	dc.w	$0B3F	;0B3F
	dc.w	$1D0C	;1D0C
	dc.w	$0C3F	;0C3F
	dc.w	$1D08	;1D08
	dc.w	$0D3F	;0D3F
	dc.w	$6000	;6000
	dc.w	$3455	;3455
ObjectFloorShapeTable:	dc.w	$FF02	;FF02
	dc.w	$0116	;0116
	dc.w	$160A	;160A
	dc.w	$0A03	;0A03
	dc.w	$0404	;0404
	dc.w	$0407	;0407
	dc.w	$0505	;0505
	dc.w	$0B0B	;0B0B
	dc.w	$0B0B	;0B0B
	dc.w	$0B0B	;0B0B
	dc.w	$0909	;0909
	dc.w	$0900	;0900
	dc.w	$0000	;0000
	dc.w	$0019	;0019
	dc.w	$1919	;1919
	dc.w	$1919	;1919
	dc.w	$1919	;1919
	dc.w	$1919	;1919
	dc.w	$1111	;1111
	dc.w	$111A	;111A
	dc.w	$1A1A	;1A1A
	dc.w	$1A0E	;1A0E
	dc.w	$0E0E	;0E0E
	dc.w	$0E0E	;0E0E
	dc.w	$1818	;1818
	dc.w	$1212	;1212
	dc.w	$1212	;1212
	dc.w	$1212	;1212
	dc.w	$1313	;1313
	dc.w	$1313	;1313
	dc.w	$1317	;1317
	dc.w	$1717	;1717
	dc.w	$0606	;0606
	dc.w	$0606	;0606
	dc.w	$0606	;0606
	dc.w	$0606	;0606
	dc.w	$0606	;0606
	dc.w	$0606	;0606
	dc.w	$0606	;0606
	dc.w	$0606	;0606
	dc.w	$0101	;0101
	dc.w	$0101	;0101
	dc.w	$0101	;0101
	dc.w	$0108	;0108
	dc.w	$0808	;0808
	dc.w	$0808	;0808
	dc.w	$1515	;1515
	dc.w	$140F	;140F
	dc.w	$0D0D	;0D0D
	dc.w	$0D0D	;0D0D
	dc.w	$0D0D	;0D0D
	dc.w	$0D0D	;0D0D
	dc.w	$0C0C	;0C0C
	dc.w	$0C0C	;0C0C
	dc.w	$0C10	;0C10
FloorObjectShapeHeights:	dc.w	$0806	;0806
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
ObjectColourSets:	dc.w	$0000	;0000
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
	dc.w	$2A2B	;2A2B
	dc.w	$2025	;2025
	dc.w	$212C	;212C
	dc.w	$2227	;2227
	dc.w	$2021	;2021
	dc.w	$2226	;2226
	dc.w	$1811	;1811
	dc.w	$121C	;121C
	dc.w	$161A	;161A
	dc.w	$1319	;1319
	dc.w	$2D13	;2D13
	dc.w	$2E2F	;2E2F
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
FloorObjectPalettes:	dc.w	$0004	;0004
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
	dc.w	$0503	;0503
	dc.w	$040E	;040E
	dc.w	$0009	;0009
	dc.w	$0C0B	;0C0B
	dc.w	$0005	;0005
	dc.w	$0506	;0506
	dc.w	$000D	;000D
	dc.w	$0203	;0203
	dc.w	$000C	;000C
	dc.w	$090C	;090C
FloorObjectGraphicOffsets:	dc.w	$0000	;0000
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
adrEA00F434:	dc.w	$FC12	;FC12
	dc.w	$0BFE	;0BFE
	dc.b	$04	;04
	dc.b	$02	;02
	dc.b	'       '	;20202020202020
	dc.b	$03	;03
	dc.b	$FF	;FF
	dc.b	$00	;00
adrEA00F444:	dc.b	$FC	;FC
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
adrEA00F45C:	dc.b	$FE	;FE
	dc.b	$0B	;0B
	dc.b	$FD	;FD
	dc.b	$00	;00
	dc.b	'SP.PTS '	;53502E50545320
	dc.b	$FE	;FE
	dc.b	$06	;06
	dc.b	'  /  '	;20202F2020
	dc.b	$FF	;FF
	dc.b	$00	;00
adrEA00F470:	dc.b	$FC	;FC
	dc.b	$1D	;1D
	dc.b	$03	;03
	dc.b	$FE	;FE
	dc.b	$0D	;0D
	dc.b	$FD	;FD
	dc.b	$03	;03
	dc.b	'INVENTORY'	;494E56454E544F5259
	dc.b	$FF	;FF
adrEA00F481:	dc.b	$FC	;FC
	dc.b	$1D	;1D
	dc.b	$08	;08
	dc.b	'ARMOUR:'	;41524D4F55523A
	dc.b	$FE	;FE
	dc.b	$0E	;0E
	dc.b	'   '	;202020
	dc.b	$FF	;FF
	dc.b	$00	;00
adrEA00F492:	dc.b	$FC	;FC
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
adrEA00F4A8:	dc.b	$FE	;FE
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
adrEA00F4BE:	dc.b	$FE	;FE
	dc.b	$0C	;0C
	dc.b	'COST TOO HIGH'	;434F535420544F4F2048494748
	dc.b	$FF	;FF
adrEA00F4CE:	dc.b	$00	;00
	dc.b	$E2	;E2
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
adrEA00F556:	dc.w	$0038	;0038
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
CharacterStats:	dc.w	$0100	;0100
	dc.w	$2311	;2311
	dc.w	$0D0D	;0D0D
	dc.w	$0023	;0023
	dc.w	$0023	;0023
	dc.w	$1F1F	;1F1F
	dc.w	$0609	;0609
	dc.w	$05FF	;05FF
	dc.w	$8000	;8000
	dc.w	$0000	;0000
	dc.b	$C7	;C7
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$F9	;F9
	dc.b	$09	;09
	dc.b	$02	;02
	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$33	;33
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$0A	;0A
	dc.b	$10	;10
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$0A	;0A
	dc.b	$05	;05
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$13	;13
	dc.b	$17	;17
	dc.b	$26	;26
	dc.b	$0E	;0E
	dc.b	$00	;00
	dc.b	$12	;12
	dc.b	$00	;00
	dc.b	$12	;12
	dc.b	$1A	;1A
	dc.b	$1A	;1A
	dc.b	$2B	;2B
	dc.b	$2D	;2D
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$48	;48
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$C7	;C7
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$0E	;0E
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$3D	;3D
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$0A	;0A
	dc.b	$10	;10
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$0A	;0A
	dc.b	$05	;05
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$18	;18
	dc.b	$13	;13
	dc.b	$13	;13
	dc.b	$23	;23
	dc.b	$00	;00
	dc.b	$18	;18
	dc.b	$00	;00
	dc.b	$18	;18
	dc.b	$18	;18
	dc.b	$18	;18
	dc.b	$0D	;0D
	dc.b	$0D	;0D
	dc.b	$01	;01
	dc.b	$FF	;FF
	dc.b	$04	;04
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$C7	;C7
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$EE	;EE
	dc.b	$19	;19
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$32	;32
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$0A	;0A
	dc.b	$10	;10
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$0A	;0A
	dc.b	$05	;05
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$03	;03
	dc.b	$10	;10
	dc.b	$20	;20
	dc.b	$0E	;0E
	dc.b	$12	;12
	dc.b	$00	;00
	dc.b	$18	;18
	dc.b	$00	;00
	dc.b	$18	;18
	dc.b	$13	;13
	dc.b	$13	;13
	dc.b	$10	;10
	dc.b	$10	;10
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$08	;08
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$C7	;C7
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$FB	;FB
	dc.b	$14	;14
	dc.b	$02	;02
	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$30	;30
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$0A	;0A
	dc.b	$10	;10
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$0A	;0A
	dc.b	$05	;05
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$04	;04
	dc.b	$22	;22
	dc.b	$15	;15
	dc.b	$0F	;0F
	dc.b	$0F	;0F
	dc.b	$00	;00
	dc.b	$25	;25
	dc.b	$00	;00
	dc.b	$25	;25
	dc.b	$1A	;1A
	dc.b	$1A	;1A
	dc.b	$06	;06
	dc.b	$08	;08
	dc.b	$03	;03
	dc.b	$FF	;FF
	dc.b	$08	;08
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$C7	;C7
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$F9	;F9
	dc.b	$19	;19
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$33	;33
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$0A	;0A
	dc.b	$10	;10
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$0A	;0A
	dc.b	$05	;05
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$05	;05
	dc.b	$13	;13
	dc.b	$16	;16
	dc.b	$23	;23
	dc.b	$14	;14
	dc.b	$00	;00
	dc.b	$10	;10
	dc.b	$00	;00
	dc.b	$10	;10
	dc.b	$17	;17
	dc.b	$17	;17
	dc.b	$2B	;2B
	dc.b	$31	;31
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$04	;04
	dc.b	$80	;80
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$C7	;C7
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$F8	;F8
	dc.b	$0F	;0F
	dc.b	$02	;02
	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$32	;32
	dc.b	$33	;33
	dc.b	$34	;34
	dc.b	$35	;35
	dc.b	$36	;36
	dc.b	$01	;01
	dc.b	$37	;37
	dc.b	$38	;38
	dc.b	$39	;39
	dc.b	$3A	;3A
	dc.b	$3B	;3B
	dc.b	$3C	;3C
	dc.b	$0A	;0A
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$06	;06
	dc.b	$18	;18
	dc.b	$14	;14
	dc.b	$12	;12
	dc.b	$27	;27
	dc.b	$00	;00
	dc.b	$19	;19
	dc.b	$00	;00
	dc.b	$19	;19
	dc.b	$19	;19
	dc.b	$19	;19
	dc.b	$0D	;0D
	dc.b	$0E	;0E
	dc.b	$01	;01
	dc.b	$FF	;FF
	dc.b	$10	;10
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$C7	;C7
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$FB	;FB
	dc.b	$1B	;1B
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$32	;32
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$0A	;0A
	dc.b	$10	;10
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$0A	;0A
	dc.b	$05	;05
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$07	;07
	dc.b	$10	;10
	dc.b	$1F	;1F
	dc.b	$13	;13
	dc.b	$12	;12
	dc.b	$00	;00
	dc.b	$17	;17
	dc.b	$00	;00
	dc.b	$17	;17
	dc.b	$16	;16
	dc.b	$16	;16
	dc.b	$10	;10
	dc.b	$10	;10
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$20	;20
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$C7	;C7
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$17	;17
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$30	;30
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$0A	;0A
	dc.b	$10	;10
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$0A	;0A
	dc.b	$05	;05
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$08	;08
	dc.b	$21	;21
	dc.b	$1A	;1A
	dc.b	$0E	;0E
	dc.b	$0D	;0D
	dc.b	$00	;00
	dc.b	$20	;20
	dc.b	$00	;00
	dc.b	$20	;20
	dc.b	$1C	;1C
	dc.b	$1C	;1C
	dc.b	$06	;06
	dc.b	$07	;07
	dc.b	$02	;02
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$80	;80
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$C7	;C7
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$13	;13
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$33	;33
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$0A	;0A
	dc.b	$10	;10
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$0A	;0A
	dc.b	$05	;05
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$09	;09
	dc.b	$10	;10
	dc.b	$18	;18
	dc.b	$24	;24
	dc.b	$11	;11
	dc.b	$00	;00
	dc.b	$11	;11
	dc.b	$00	;00
	dc.b	$11	;11
	dc.b	$19	;19
	dc.b	$19	;19
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$10	;10
	dc.b	$08	;08
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$C7	;C7
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$F8	;F8
	dc.b	$1D	;1D
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$3D	;3D
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$0A	;0A
	dc.b	$10	;10
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$0A	;0A
	dc.b	$05	;05
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$0A	;0A
	dc.b	$17	;17
	dc.b	$12	;12
	dc.b	$15	;15
	dc.b	$24	;24
	dc.b	$00	;00
	dc.b	$18	;18
	dc.b	$00	;00
	dc.b	$18	;18
	dc.b	$17	;17
	dc.b	$17	;17
	dc.b	$0D	;0D
	dc.b	$0D	;0D
	dc.b	$03	;03
	dc.b	$FF	;FF
	dc.b	$80	;80
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$C7	;C7
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$F7	;F7
	dc.b	$12	;12
	dc.b	$02	;02
	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$32	;32
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$0A	;0A
	dc.b	$10	;10
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$0A	;0A
	dc.b	$05	;05
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$0B	;0B
	dc.b	$0D	;0D
	dc.b	$20	;20
	dc.b	$14	;14
	dc.b	$0B	;0B
	dc.b	$00	;00
	dc.b	$14	;14
	dc.b	$00	;00
	dc.b	$14	;14
	dc.b	$12	;12
	dc.b	$12	;12
	dc.b	$10	;10
	dc.b	$10	;10
	dc.b	$04	;04
	dc.b	$FF	;FF
	dc.b	$40	;40
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$C7	;C7
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$F3	;F3
	dc.b	$1A	;1A
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$30	;30
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$0A	;0A
	dc.b	$10	;10
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$0A	;0A
	dc.b	$05	;05
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$0C	;0C
	dc.b	$24	;24
	dc.b	$17	;17
	dc.b	$10	;10
	dc.b	$0B	;0B
	dc.b	$00	;00
	dc.b	$23	;23
	dc.b	$00	;00
	dc.b	$23	;23
	dc.b	$1C	;1C
	dc.b	$1C	;1C
	dc.b	$03	;03
	dc.b	$06	;06
	dc.b	$02	;02
	dc.b	$FF	;FF
	dc.b	$10	;10
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$C7	;C7
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$F0	;F0
	dc.b	$1C	;1C
	dc.b	$02	;02
	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$33	;33
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$0A	;0A
	dc.b	$10	;10
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$0A	;0A
	dc.b	$05	;05
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$0D	;0D
	dc.b	$12	;12
	dc.b	$17	;17
	dc.b	$1F	;1F
	dc.b	$13	;13
	dc.b	$00	;00
	dc.b	$11	;11
	dc.b	$00	;00
	dc.b	$11	;11
	dc.b	$19	;19
	dc.b	$19	;19
	dc.b	$2B	;2B
	dc.b	$2B	;2B
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$80	;80
	dc.b	$20	;20
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$C7	;C7
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$1D	;1D
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$3D	;3D
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$0A	;0A
	dc.b	$10	;10
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$0A	;0A
	dc.b	$05	;05
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$0E	;0E
	dc.b	$19	;19
	dc.b	$14	;14
	dc.b	$17	;17
	dc.b	$23	;23
	dc.b	$00	;00
	dc.b	$1A	;1A
	dc.b	$00	;00
	dc.b	$1A	;1A
	dc.b	$1B	;1B
	dc.b	$1B	;1B
	dc.b	$0D	;0D
	dc.b	$0D	;0D
	dc.b	$01	;01
	dc.b	$FF	;FF
	dc.b	$08	;08
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$C7	;C7
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$F5	;F5
	dc.b	$0A	;0A
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$32	;32
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$0A	;0A
	dc.b	$10	;10
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$0A	;0A
	dc.b	$05	;05
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$0F	;0F
	dc.b	$12	;12
	dc.b	$24	;24
	dc.b	$10	;10
	dc.b	$0F	;0F
	dc.b	$00	;00
	dc.b	$16	;16
	dc.b	$00	;00
	dc.b	$16	;16
	dc.b	$19	;19
	dc.b	$19	;19
	dc.b	$10	;10
	dc.b	$10	;10
	dc.b	$01	;01
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$80	;80
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$C7	;C7
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$FD	;FD
	dc.b	$12	;12
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$03	;03
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$30	;30
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$0A	;0A
	dc.b	$10	;10
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$0A	;0A
	dc.b	$05	;05
	dc.b	$00	;00
	dc.b	$00	;00
adrW_00F986:	dc.w	$0000	;0000
adrB_00F988:	dc.b	$00	;00
adrB_00F989:
	dc.b	$00	;00
CurrentTower:
	dc.b	$00	;00

	dc.b	$00	;00
Multiplayer:
	dc.w	$FFFF	;FFFF
RingUses:	dc.w	$0102	;0102
	dc.w	$0303	;0303
adrEA00F992:	dc.w	$0000	;0000
adrW_00F994:	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrB_00F998:	dc.b	$00	;00
adrB_00F999:	dc.b	$01	;01
adrB_00F99A:	dc.b	$00	;00
adrB_00F99B:	dc.b	$00	;00
adrEA00F99C:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrEA00F9AC:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrEA00F9BC:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrW_00F9CC:	
	dc.b	$00	;00
adrB_00F9CD:	
	dc.b	$00	;00
adrW_00F9CE:	
	dc.b	$00	;00
adrB_00F9CF:	
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
adrW_00F9D2:	
	dc.w	$0000	;0000
adrL_00F9D4:	
	dc.l	MapData1+$38	;0000FAD4
Player1_Data:	
	dc.b	$00	;00
adrB_00F9D9:	
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$07	;07
	dc.b	$00	;00
	dc.b	$08	;08
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$FF	;FF
adrB_00F9F0:	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
adrL_00F9F4:	dc.l	$00000000	;00000000
	dc.w	$0000	;0000
adrW_00F9FA:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.b	$FF	;FF
adrB_00FA0D:	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
adrB_00FA2E:	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
adrB_00FA31:	dc.b	$00	;00
adrL_00FA32:	dc.l	$FFFFFFFF	;FFFFFFFF
	dc.l	$FFFFFFFF	;FFFFFFFF
Player2_Data:	dc.b	$01	;01
adrB_00FA3B:	dc.b	$00	;00
adrL_00FA3C:	dc.l	$00000000	;00000000
	dc.l	$00000060	;00000060
	dc.l	$0F000000	;0F000000
	dc.l	$00000009	;00000009
	dc.l	$000C0000	;000C0000
	dc.w	$FFFF	;FFFF
adrB_00FA52:	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
adrL_00FA56:	dc.l	$00000000	;00000000
	dc.w	$0000	;0000
adrW_00FA5C:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.b	$FF	;FF
adrB_00FA6F:	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
adrB_00FA90:	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
adrB_00FA93:	dc.b	$00	;00
adrL_00FA94:	dc.l	$FFFFFFFF	;FFFFFFFF
	dc.l	$FFFFFFFF	;FFFFFFFF
MapData1:
	INCBIN bext-data/serpex.map

ObjectData_1:	dc.w	$0252	;0252
	dc.w	$4B02	;4B02
	dc.w	$0032	;0032
	dc.w	$014B	;014B
	dc.w	$2A00	;2A00
	dc.w	$3201	;3201
	dc.w	$0B02	;0B02
	dc.w	$0032	;0032
	dc.w	$010B	;010B
	dc.w	$2A00	;2A00
	dc.w	$3201	;3201
	dc.w	$CA42	;CA42
	dc.w	$0016	;0016
	dc.w	$018A	;018A
	dc.w	$4200	;4200
	dc.w	$3001	;3001
	dc.w	$CA1E	;CA1E
	dc.w	$0130	;0130
	dc.w	$0116	;0116
	dc.w	$018B	;018B
	dc.w	$2600	;2600
	dc.w	$5D01	;5D01
	dc.w	$CB24	;CB24
	dc.w	$002C	;002C
	dc.w	$01CB	;01CB
	dc.w	$2000	;2000
	dc.w	$5B01	;5B01
	dc.w	$CAD8	;CAD8
	dc.w	$0203	;0203
	dc.w	$145D	;145D
	dc.w	$012C	;012C
	dc.w	$014B	;014B
	dc.w	$0601	;0601
	dc.w	$2C01	;2C01
	dc.w	$2701	;2701
	dc.w	$4AD8	;4AD8
	dc.w	$001C	;001C
	dc.w	$01C9	;01C9
	dc.w	$3401	;3401
	dc.w	$1C01	;1C01
	dc.w	$2401	;2401
	dc.w	$8934	;8934
	dc.w	$0102	;0102
	dc.w	$0A16	;0A16
	dc.w	$01C9	;01C9
	dc.w	$E600	;E600
	dc.w	$020A	;020A
	dc.w	$89E6	;89E6
	dc.w	$0001	;0001
	dc.w	$1489	;1489
	dc.w	$6000	;6000
	dc.w	$2C01	;2C01
	dc.w	$C960	;C960
	dc.w	$0027	;0027
	dc.w	$0189	;0189
	dc.w	$9402	;9402
	dc.w	$0128	;0128
	dc.w	$1601	;1601
	dc.w	$5B01	;5B01
	dc.w	$C95E	;C95E
	dc.w	$001C	;001C
	dc.w	$0189	;0189
	dc.w	$6601	;6601
	dc.w	$0414	;0414
	dc.w	$1601	;1601
	dc.w	$89BA	;89BA
	dc.w	$0101	;0101
	dc.w	$1424	;1424
	dc.w	$0149	;0149
	dc.w	$B800	;B800
	dc.w	$1C01	;1C01
	dc.w	$C9B8	;C9B8
	dc.w	$0104	;0104
	dc.w	$1416	;1416
	dc.w	$0149	;0149
	dc.w	$8A00	;8A00
	dc.w	$1601	;1601
	dc.w	$0B26	;0B26
	dc.w	$0016	;0016
	dc.w	$018A	;018A
	dc.w	$F800	;F800
	dc.w	$030C	;030C
	dc.w	$4AF2	;4AF2
	dc.w	$0003	;0003
	dc.w	$080A	;080A
	dc.w	$BA00	;BA00
	dc.w	$3801	;3801
	dc.w	$88F4	;88F4
	dc.w	$0038	;0038
	dc.w	$0106	;0106
	dc.w	$3E00	;3E00
	dc.w	$5301	;5301
	dc.w	$08B6	;08B6
	dc.w	$0051	;0051
	dc.w	$0187	;0187
	dc.w	$B801	;B801
	dc.w	$1D01	;1D01
	dc.w	$2C01	;2C01
	dc.w	$C8D6	;C8D6
	dc.w	$0116	;0116
	dc.w	$011C	;011C
	dc.w	$0107	;0107
	dc.w	$8E01	;8E01
	dc.w	$0114	;0114
	dc.w	$5001	;5001
	dc.w	$09B4	;09B4
	dc.w	$0001	;0001
	dc.w	$14CA	;14CA
	dc.w	$E800	;E800
	dc.w	$2C01	;2C01
	dc.w	$4B32	;4B32
	dc.w	$0053	;0053
	dc.w	$01CB	;01CB
	dc.w	$3001	;3001
	dc.w	$5101	;5101
	dc.w	$020A	;020A
	dc.w	$8B86	;8B86
	dc.w	$001D	;001D
	dc.w	$018D	;018D
	dc.w	$2800	;2800
	dc.w	$040A	;040A
	dc.w	$4DA6	;4DA6
	dc.w	$0054	;0054
	dc.w	$018D	;018D
	dc.w	$A800	;A800
	dc.w	$020A	;020A
	dc.w	$8DF4	;8DF4
	dc.w	$0016	;0016
	dc.w	$014B	;014B
	dc.w	$3A00	;3A00
	dc.w	$0204	;0204
	dc.w	$4DBA	;4DBA
	dc.w	$0016	;0016
	dc.w	$014C	;014C
	dc.w	$E400	;E400
	dc.w	$030E	;030E
	dc.w	$4DE6	;4DE6
	dc.w	$0102	;0102
	dc.w	$0633	;0633
	dc.w	$01CE	;01CE
	dc.w	$3201	;3201
	dc.w	$5101	;5101
	dc.w	$0203	;0203
	dc.w	$8ECA	;8ECA
	dc.w	$0054	;0054
	dc.w	$010E	;010E
	dc.w	$DE00	;DE00
	dc.w	$5201	;5201
	dc.w	$4E46	;4E46
	dc.w	$0150	;0150
	dc.w	$012C	;012C
	dc.w	$01CE	;01CE
	dc.w	$9A00	;9A00
	dc.w	$5601	;5601
	dc.w	$8F86	;8F86
	dc.w	$002C	;002C
	dc.w	$01CF	;01CF
	dc.w	$1601	;1601
	dc.w	$0201	;0201
	dc.w	$1D01	;1D01
	dc.w	$4FAE	;4FAE
	dc.w	$0055	;0055
	dc.w	$018F	;018F
	dc.w	$9200	;9200
	dc.w	$5A01	;5A01
	dc.w	$4F58	;4F58
	dc.w	$0058	;0058
	dc.w	$018F	;018F
	dc.w	$8C00	;8C00
	dc.w	$5901	;5901
	dc.w	$8F42	;8F42
	dc.w	$0053	;0053
	dc.w	$014F	;014F
	dc.w	$5201	;5201
	dc.w	$5101	;5101
	dc.w	$5701	;5701
	dc.w	$4E90	;4E90
	dc.w	$0033	;0033
	dc.w	$01CF	;01CF
	dc.w	$BE00	;BE00
	dc.w	$1D01	;1D01
	dc.w	$8FC0	;8FC0
	dc.w	$0101	;0101
	dc.w	$0603	;0603
	dc.w	$0E8F	;0E8F
	dc.w	$B802	;B802
	dc.w	$0207	;0207
	dc.w	$0108	;0108
	dc.w	$1601	;1601
	dc.w	$0F82	;0F82
	dc.w	$0002	;0002
	dc.w	$0C47	;0C47
	dc.w	$9A01	;9A01
	dc.w	$1601	;1601
	dc.w	$5501	;5501
	dc.w	$093A	;093A
	dc.w	$001E	;001E
	dc.w	$0149	;0149
	dc.w	$3A00	;3A00
	dc.w	$1601	;1601
	dc.w	$0938	;0938
	dc.w	$0004	;0004
	dc.w	$1447	;1447
	dc.w	$1E01	;1E01
	dc.w	$0314	;0314
	dc.w	$1E01	;1E01
	dc.w	$487E	;487E
	dc.w	$0001	;0001
	dc.w	$14C7	;14C7
	dc.w	$2600	;2600
	dc.w	$0207	;0207
	dc.w	$4800	;4800
	dc.w	$0102	;0102
	dc.w	$0604	;0604
	dc.w	$0C84	;0C84
	dc.w	$D400	;D400
	dc.w	$5401	;5401
	dc.w	$855A	;855A
	dc.w	$0004	;0004
	dc.w	$0AC5	;0AC5
	dc.w	$E401	;E401
	dc.w	$0105	;0105
	dc.w	$0205	;0205
	dc.w	$C502	;C502
	dc.w	$0104	;0104
	dc.w	$1124	;1124
	dc.w	$0144	;0144
	dc.w	$FA00	;FA00
	dc.w	$0314	;0314
	dc.w	$C6A6	;C6A6
	dc.w	$0003	;0003
	dc.w	$1046	;1046
	dc.w	$2001	;2001
	dc.w	$0108	;0108
	dc.w	$040A	;040A
	dc.w	$045A	;045A
	dc.w	$0052	;0052
	dc.w	$01C3	;01C3
	dc.w	$0E00	;0E00
	dc.w	$2701	;2701
	dc.w	$03B8	;03B8
	dc.w	$0051	;0051
	dc.w	$0102	;0102
	dc.w	$EC00	;EC00
	dc.w	$5001	;5001
	dc.w	$0452	;0452
	dc.w	$0016	;0016
	dc.w	$0184	;0184
	dc.w	$2E00	;2E00
	dc.w	$1601	;1601
	dc.w	$4428	;4428
	dc.w	$0016	;0016
	dc.w	$0144	;0144
	dc.w	$7200	;7200
	dc.w	$030F	;030F
	dc.w	$8466	;8466
	dc.w	$0016	;0016
	dc.w	$01C4	;01C4
	dc.w	$6600	;6600
	dc.w	$040C	;040C
	dc.w	$0456	;0456
	dc.w	$0002	;0002
	dc.w	$06C2	;06C2
	dc.w	$8A02	;8A02
	dc.w	$040B	;040B
	dc.w	$0208	;0208
	dc.w	$010D	;010D
	dc.w	$C310	;C310
	dc.w	$0002	;0002
	dc.w	$0683	;0683
	dc.w	$7E00	;7E00
	dc.w	$0308	;0308
	dc.w	$827A	;827A
	dc.w	$0002	;0002
	dc.w	$0742	;0742
	dc.w	$5E00	;5E00
	dc.w	$2701	;2701
	dc.w	$410C	;410C
	dc.w	$0056	;0056
	dc.w	$0181	;0181
	dc.w	$B600	;B600
	dc.w	$040A	;040A
	dc.w	$419E	;419E
	dc.w	$002D	;002D
	dc.w	$0181	;0181
	dc.w	$A400	;A400
	dc.w	$040A	;040A
	dc.w	$C0D4	;C0D4
	dc.w	$001E	;001E
	dc.w	$01C0	;01C0
	dc.w	$E600	;E600
	dc.w	$1E01	;1E01
	dc.w	$C022	;C022
	dc.w	$012D	;012D
	dc.w	$0116	;0116
	dc.w	$0180	;0180
	dc.w	$2800	;2800
	dc.w	$0312	;0312
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
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
	INCBIN bext-data/chaosex.map

ObjectData_2:	dc.w	$023A	;023A
	dc.w	$0030	;0030
	dc.w	$0204	;0204
	dc.w	$0A02	;0A02
	dc.w	$0316	;0316
	dc.w	$0100	;0100
	dc.w	$4C01	;4C01
	dc.w	$040A	;040A
	dc.w	$0205	;0205
	dc.w	$404C	;404C
	dc.w	$0016	;0016
	dc.w	$01C0	;01C0
	dc.w	$D000	;D000
	dc.w	$0106	;0106
	dc.w	$015E	;015E
	dc.w	$0050	;0050
	dc.w	$0101	;0101
	dc.w	$9600	;9600
	dc.w	$5101	;5101
	dc.w	$8154	;8154
	dc.w	$0003	;0003
	dc.w	$1142	;1142
	dc.w	$1600	;1600
	dc.w	$5201	;5201
	dc.w	$C216	;C216
	dc.w	$0002	;0002
	dc.w	$0342	;0342
	dc.w	$4000	;4000
	dc.w	$030A	;030A
	dc.w	$0322	;0322
	dc.w	$0039	;0039
	dc.w	$0182	;0182
	dc.w	$2E01	;2E01
	dc.w	$5201	;5201
	dc.w	$0201	;0201
	dc.w	$8318	;8318
	dc.w	$0001	;0001
	dc.w	$07C2	;07C2
	dc.w	$0200	;0200
	dc.w	$1601	;1601
	dc.w	$8202	;8202
	dc.w	$0016	;0016
	dc.w	$0143	;0143
	dc.w	$4600	;4600
	dc.w	$5301	;5301
	dc.w	$422A	;422A
	dc.w	$0104	;0104
	dc.w	$1701	;1701
	dc.w	$0D42	;0D42
	dc.w	$BC00	;BC00
	dc.w	$3901	;3901
	dc.w	$0336	;0336
	dc.w	$0004	;0004
	dc.w	$0843	;0843
	dc.w	$3600	;3600
	dc.w	$1601	;1601
	dc.w	$0348	;0348
	dc.w	$0153	;0153
	dc.w	$0116	;0116
	dc.w	$0143	;0143
	dc.w	$4200	;4200
	dc.w	$1601	;1601
	dc.w	$C342	;C342
	dc.w	$0016	;0016
	dc.w	$0143	;0143
	dc.w	$C001	;C001
	dc.w	$5001	;5001
	dc.w	$0201	;0201
	dc.w	$4390	;4390
	dc.w	$0055	;0055
	dc.w	$0183	;0183
	dc.w	$9600	;9600
	dc.w	$0201	;0201
	dc.w	$43EA	;43EA
	dc.w	$0002	;0002
	dc.w	$01C4	;01C4
	dc.w	$E400	;E400
	dc.w	$1601	;1601
	dc.w	$050E	;050E
	dc.w	$0001	;0001
	dc.w	$0604	;0604
	dc.w	$5001	;5001
	dc.w	$5401	;5401
	dc.w	$2501	;2501
	dc.w	$8602	;8602
	dc.w	$0252	;0252
	dc.w	$0101	;0101
	dc.w	$0B39	;0B39
	dc.w	$0185	;0185
	dc.w	$B600	;B600
	dc.w	$0407	;0407
	dc.w	$066A	;066A
	dc.w	$0025	;0025
	dc.w	$01C6	;01C6
	dc.w	$4000	;4000
	dc.w	$1601	;1601
	dc.w	$468E	;468E
	dc.w	$0020	;0020
	dc.w	$0106	;0106
	dc.w	$2400	;2400
	dc.w	$030C	;030C
	dc.w	$C5F8	;C5F8
	dc.w	$005D	;005D
	dc.w	$0185	;0185
	dc.w	$9600	;9600
	dc.w	$1601	;1601
	dc.w	$83C8	;83C8
	dc.w	$0016	;0016
	dc.w	$0187	;0187
	dc.w	$1401	;1401
	dc.w	$0108	;0108
	dc.w	$0204	;0204
	dc.w	$03C8	;03C8
	dc.w	$0020	;0020
	dc.w	$018A	;018A
	dc.w	$BE00	;BE00
	dc.w	$0304	;0304
	dc.w	$CABE	;CABE
	dc.w	$0004	;0004
	dc.w	$04CB	;04CB
	dc.w	$0C00	;0C00
	dc.w	$1601	;1601
	dc.w	$4B0C	;4B0C
	dc.w	$0016	;0016
	dc.w	$018A	;018A
	dc.w	$9402	;9402
	dc.w	$030C	;030C
	dc.w	$0206	;0206
	dc.w	$0101	;0101
	dc.w	$892E	;892E
	dc.w	$0050	;0050
	dc.w	$0148	;0148
	dc.w	$F400	;F400
	dc.w	$1601	;1601
	dc.w	$88F6	;88F6
	dc.w	$003F	;003F
	dc.w	$01C9	;01C9
	dc.w	$C801	;C801
	dc.w	$0207	;0207
	dc.w	$1601	;1601
	dc.w	$86FE	;86FE
	dc.w	$0003	;0003
	dc.w	$18C8	;18C8
	dc.w	$3000	;3000
	dc.w	$6C01	;6C01
	dc.w	$885C	;885C
	dc.w	$0016	;0016
	dc.w	$0108	;0108
	dc.w	$2200	;2200
	dc.w	$3101	;3101
	dc.w	$C9BE	;C9BE
	dc.w	$0016	;0016
	dc.w	$01CA	;01CA
	dc.w	$0C01	;0C01
	dc.w	$0204	;0204
	dc.w	$0413	;0413
	dc.w	$071C	;071C
	dc.w	$0054	;0054
	dc.w	$0108	;0108
	dc.w	$1A01	;1A01
	dc.w	$040D	;040D
	dc.w	$1601	;1601
	dc.w	$C9B0	;C9B0
	dc.w	$013F	;013F
	dc.w	$0169	;0169
	dc.w	$01C7	;01C7
	dc.w	$3E00	;3E00
	dc.w	$5601	;5601
	dc.w	$4814	;4814
	dc.w	$0031	;0031
	dc.w	$0107	;0107
	dc.w	$6800	;6800
	dc.w	$1601	;1601
	dc.w	$4762	;4762
	dc.w	$006B	;006B
	dc.w	$0103	;0103
	dc.w	$A200	;A200
	dc.w	$0311	;0311
	dc.w	$03F6	;03F6
	dc.w	$0001	;0001
	dc.w	$0B09	;0B09
	dc.w	$8201	;8201
	dc.w	$6A01	;6A01
	dc.w	$5101	;5101
	dc.w	$0762	;0762
	dc.w	$0053	;0053
	dc.w	$0104	;0104
	dc.w	$5800	;5800
	dc.w	$010A	;010A
	dc.w	$8428	;8428
	dc.w	$0002	;0002
	dc.w	$0343	;0343
	dc.w	$AA00	;AA00
	dc.w	$010C	;010C
	dc.w	$0432	;0432
	dc.w	$0004	;0004
	dc.w	$0883	;0883
	dc.w	$8C01	;8C01
	dc.w	$0421	;0421
	dc.w	$5D01	;5D01
	dc.w	$8AFE	;8AFE
	dc.w	$002E	;002E
	dc.w	$010B	;010B
	dc.w	$DE02	;DE02
	dc.w	$5501	;5501
	dc.w	$0105	;0105
	dc.w	$040E	;040E
	dc.w	$CAFE	;CAFE
	dc.w	$0002	;0002
	dc.w	$068B	;068B
	dc.w	$2A00	;2A00
	dc.w	$1601	;1601
	dc.w	$CB5C	;CB5C
	dc.w	$0102	;0102
	dc.w	$0616	;0616
	dc.w	$01CB	;01CB
	dc.w	$E000	;E000
	dc.w	$5301	;5301
	dc.w	$CD4A	;CD4A
	dc.w	$0050	;0050
	dc.w	$018D	;018D
	dc.w	$AC01	;AC01
	dc.w	$5401	;5401
	dc.w	$2101	;2101
	dc.w	$8B68	;8B68
	dc.w	$0051	;0051
	dc.w	$014B	;014B
	dc.w	$6200	;6200
	dc.w	$0104	;0104
	dc.w	$8BE2	;8BE2
	dc.w	$0002	;0002
	dc.w	$0A0B	;0A0B
	dc.w	$EA00	;EA00
	dc.w	$0409	;0409
	dc.w	$8DBA	;8DBA
	dc.w	$0101	;0101
	dc.w	$0716	;0716
	dc.w	$014C	;014C
	dc.w	$BA00	;BA00
	dc.w	$5601	;5601
	dc.w	$CCEA	;CCEA
	dc.w	$0028	;0028
	dc.w	$01CC	;01CC
	dc.w	$BA00	;BA00
	dc.w	$2101	;2101
	dc.w	$0C9C	;0C9C
	dc.w	$0001	;0001
	dc.w	$06CB	;06CB
	dc.w	$2401	;2401
	dc.w	$0311	;0311
	dc.w	$1601	;1601
	dc.w	$8C70	;8C70
	dc.w	$003A	;003A
	dc.w	$01CC	;01CC
	dc.w	$6E00	;6E00
	dc.w	$1601	;1601
	dc.w	$4C6E	;4C6E
	dc.w	$0016	;0016
	dc.w	$010A	;010A
	dc.w	$D200	;D200
	dc.w	$2801	;2801
	dc.w	$4A7A	;4A7A
	dc.w	$0051	;0051
	dc.w	$018A	;018A
	dc.w	$7E00	;7E00
	dc.w	$0207	;0207
	dc.w	$CAFC	;CAFC
	dc.w	$0001	;0001
	dc.w	$0A4C	;0A4C
	dc.w	$1400	;1400
	dc.w	$5501	;5501
	dc.w	$8AC8	;8AC8
	dc.w	$0016	;0016
	dc.w	$010F	;010F
	dc.w	$2C00	;2C00
	dc.w	$1601	;1601
	dc.w	$0E9C	;0E9C
	dc.w	$0016	;0016
	dc.w	$01CF	;01CF
	dc.w	$5600	;5600
	dc.w	$0414	;0414
	dc.w	$0E04	;0E04
	dc.w	$0001	;0001
	dc.w	$148D	;148D
	dc.w	$CC00	;CC00
	dc.w	$0414	;0414
	dc.w	$8C36	;8C36
	dc.w	$FF03	;FF03
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
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
	INCBIN bext-data/moonex.map

ObjectData_3:	dc.w	$0129	;0129
	dc.w	$4074	;4074
	dc.w	$0055	;0055
	dc.w	$01C0	;01C0
	dc.w	$7400	;7400
	dc.w	$1701	;1701
	dc.w	$C130	;C130
	dc.w	$001A	;001A
	dc.w	$0101	;0101
	dc.w	$3200	;3200
	dc.w	$1601	;1601
	dc.w	$8132	;8132
	dc.w	$0016	;0016
	dc.w	$0183	;0183
	dc.w	$1200	;1200
	dc.w	$0207	;0207
	dc.w	$007E	;007E
	dc.w	$0001	;0001
	dc.w	$0982	;0982
	dc.w	$7A00	;7A00
	dc.w	$5401	;5401
	dc.w	$827E	;827E
	dc.w	$0018	;0018
	dc.w	$01C2	;01C2
	dc.w	$7E00	;7E00
	dc.w	$1801	;1801
	dc.w	$8266	;8266
	dc.w	$002E	;002E
	dc.w	$01C3	;01C3
	dc.w	$3200	;3200
	dc.w	$0314	;0314
	dc.w	$03DC	;03DC
	dc.w	$0004	;0004
	dc.w	$0843	;0843
	dc.w	$DC00	;DC00
	dc.w	$1601	;1601
	dc.w	$C2E4	;C2E4
	dc.w	$0016	;0016
	dc.w	$01C4	;01C4
	dc.w	$A400	;A400
	dc.w	$040C	;040C
	dc.w	$8444	;8444
	dc.w	$0102	;0102
	dc.w	$0401	;0401
	dc.w	$0E43	;0E43
	dc.w	$FC00	;FC00
	dc.w	$1801	;1801
	dc.w	$C3FC	;C3FC
	dc.w	$0017	;0017
	dc.w	$0183	;0183
	dc.w	$FE00	;FE00
	dc.w	$1A01	;1A01
	dc.w	$44CA	;44CA
	dc.w	$0001	;0001
	dc.w	$0F02	;0F02
	dc.w	$4000	;4000
	dc.w	$1601	;1601
	dc.w	$423C	;423C
	dc.w	$0016	;0016
	dc.w	$0144	;0144
	dc.w	$6600	;6600
	dc.w	$0408	;0408
	dc.w	$C466	;C466
	dc.w	$001A	;001A
	dc.w	$0104	;0104
	dc.w	$0000	;0000
	dc.w	$1A01	;1A01
	dc.w	$C3BC	;C3BC
	dc.w	$0002	;0002
	dc.w	$0403	;0403
	dc.w	$DE00	;DE00
	dc.w	$0308	;0308
	dc.w	$43CA	;43CA
	dc.w	$001A	;001A
	dc.w	$0184	;0184
	dc.w	$3000	;3000
	dc.w	$1A01	;1A01
	dc.w	$842C	;842C
	dc.w	$0018	;0018
	dc.w	$0143	;0143
	dc.w	$C600	;C600
	dc.w	$1701	;1701
	dc.w	$03A2	;03A2
	dc.w	$001A	;001A
	dc.w	$0103	;0103
	dc.w	$A600	;A600
	dc.w	$1601	;1601
	dc.w	$43A6	;43A6
	dc.w	$0016	;0016
	dc.w	$01C3	;01C3
	dc.w	$3A00	;3A00
	dc.w	$0106	;0106
	dc.w	$C4D2	;C4D2
	dc.w	$0001	;0001
	dc.w	$0AC4	;0AC4
	dc.w	$D000	;D000
	dc.w	$0416	;0416
	dc.w	$8450	;8450
	dc.w	$0003	;0003
	dc.w	$1405	;1405
	dc.w	$EA00	;EA00
	dc.w	$2201	;2201
	dc.w	$C57C	;C57C
	dc.w	$0016	;0016
	dc.w	$0145	;0145
	dc.w	$7C00	;7C00
	dc.w	$1601	;1601
	dc.w	$C5BC	;C5BC
	dc.w	$0001	;0001
	dc.w	$0D45	;0D45
	dc.w	$4400	;4400
	dc.w	$0203	;0203
	dc.w	$C588	;C588
	dc.w	$0016	;0016
	dc.w	$0145	;0145
	dc.w	$8800	;8800
	dc.w	$1601	;1601
	dc.w	$872C	;872C
	dc.w	$0004	;0004
	dc.w	$0A87	;0A87
	dc.w	$2600	;2600
	dc.w	$031E	;031E
	dc.w	$C724	;C724
	dc.w	$0002	;0002
	dc.w	$0486	;0486
	dc.w	$C000	;C000
	dc.w	$010F	;010F
	dc.w	$0772	;0772
	dc.w	$0022	;0022
	dc.w	$014D	;014D
	dc.w	$DA00	;DA00
	dc.w	$5401	;5401
	dc.w	$0DEC	;0DEC
	dc.w	$0001	;0001
	dc.w	$110D	;110D
	dc.w	$CA00	;CA00
	dc.w	$0408	;0408
	dc.w	$4D3A	;4D3A
	dc.w	$0003	;0003
	dc.w	$154C	;154C
	dc.w	$8000	;8000
	dc.w	$0209	;0209
	dc.w	$CA9C	;CA9C
	dc.w	$0004	;0004
	dc.w	$1F0A	;1F0A
	dc.w	$7E00	;7E00
	dc.w	$3901	;3901
	dc.w	$879C	;879C
	dc.w	$0055	;0055
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
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
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
	INCBIN bext-data/dragex.map

ObjectData_4:	dc.w	$014C	;014C
	dc.w	$430E	;430E
	dc.w	$0018	;0018
	dc.w	$0103	;0103
	dc.w	$0E00	;0E00
	dc.w	$1701	;1701
	dc.w	$0344	;0344
	dc.w	$0004	;0004
	dc.w	$0D83	;0D83
	dc.w	$7000	;7000
	dc.w	$010F	;010F
	dc.w	$0362	;0362
	dc.w	$0002	;0002
	dc.w	$0383	;0383
	dc.w	$6200	;6200
	dc.w	$030F	;030F
	dc.w	$C2D8	;C2D8
	dc.w	$0004	;0004
	dc.w	$0B83	;0B83
	dc.w	$0400	;0400
	dc.w	$010A	;010A
	dc.w	$C2A2	;C2A2
	dc.w	$0016	;0016
	dc.w	$01C2	;01C2
	dc.w	$A000	;A000
	dc.w	$010B	;010B
	dc.w	$82A0	;82A0
	dc.w	$0016	;0016
	dc.w	$01C1	;01C1
	dc.w	$B600	;B600
	dc.w	$2F01	;2F01
	dc.w	$C1A6	;C1A6
	dc.w	$0004	;0004
	dc.w	$0582	;0582
	dc.w	$4E00	;4E00
	dc.w	$010E	;010E
	dc.w	$8226	;8226
	dc.w	$001A	;001A
	dc.w	$0181	;0181
	dc.w	$A600	;A600
	dc.w	$1801	;1801
	dc.w	$C100	;C100
	dc.w	$0016	;0016
	dc.w	$0140	;0140
	dc.w	$D200	;D200
	dc.w	$1701	;1701
	dc.w	$807E	;807E
	dc.w	$0018	;0018
	dc.w	$0100	;0100
	dc.w	$D200	;D200
	dc.w	$0208	;0208
	dc.w	$8136	;8136
	dc.w	$0016	;0016
	dc.w	$01C1	;01C1
	dc.w	$9A00	;9A00
	dc.w	$0309	;0309
	dc.w	$81C0	;81C0
	dc.w	$0026	;0026
	dc.w	$01C0	;01C0
	dc.w	$1E00	;1E00
	dc.w	$1601	;1601
	dc.w	$0026	;0026
	dc.w	$0001	;0001
	dc.w	$0501	;0501
	dc.w	$4000	;4000
	dc.w	$0203	;0203
	dc.w	$4146	;4146
	dc.w	$0004	;0004
	dc.w	$1440	;1440
	dc.w	$CE00	;CE00
	dc.w	$0408	;0408
	dc.w	$40F8	;40F8
	dc.w	$0003	;0003
	dc.w	$1103	;1103
	dc.w	$B200	;B200
	dc.w	$2301	;2301
	dc.w	$C3F0	;C3F0
	dc.w	$0016	;0016
	dc.w	$0182	;0182
	dc.w	$A200	;A200
	dc.w	$3C01	;3C01
	dc.w	$C540	;C540
	dc.w	$002B	;002B
	dc.w	$0184	;0184
	dc.w	$B600	;B600
	dc.w	$010A	;010A
	dc.w	$C684	;C684
	dc.w	$0004	;0004
	dc.w	$0A06	;0A06
	dc.w	$9A00	;9A00
	dc.w	$2301	;2301
	dc.w	$069E	;069E
	dc.w	$0003	;0003
	dc.w	$140B	;140B
	dc.w	$D800	;D800
	dc.w	$5501	;5501
	dc.w	$0BA6	;0BA6
	dc.w	$0001	;0001
	dc.w	$064B	;064B
	dc.w	$F000	;F000
	dc.w	$5201	;5201
	dc.w	$8CDE	;8CDE
	dc.w	$0053	;0053
	dc.w	$01CC	;01CC
	dc.w	$9800	;9800
	dc.w	$5401	;5401
	dc.w	$C668	;C668
	dc.w	$0004	;0004
	dc.w	$1406	;1406
	dc.w	$8A00	;8A00
	dc.w	$2301	;2301
	dc.w	$068E	;068E
	dc.w	$0003	;0003
	dc.w	$15C9	;15C9
	dc.w	$4200	;4200
	dc.w	$5401	;5401
	dc.w	$4A4C	;4A4C
	dc.w	$0016	;0016
	dc.w	$010A	;010A
	dc.w	$2E00	;2E00
	dc.w	$1A01	;1A01
	dc.w	$CA62	;CA62
	dc.w	$0051	;0051
	dc.w	$018B	;018B
	dc.w	$5A00	;5A00
	dc.w	$5401	;5401
	dc.w	$0B38	;0B38
	dc.w	$0016	;0016
	dc.w	$018B	;018B
	dc.w	$6400	;6400
	dc.w	$1701	;1701
	dc.w	$0CDE	;0CDE
	dc.w	$0018	;0018
	dc.w	$014B	;014B
	dc.w	$D800	;D800
	dc.w	$1A01	;1A01
	dc.w	$CC06	;CC06
	dc.w	$0016	;0016
	dc.w	$014D	;014D
	dc.w	$3200	;3200
	dc.w	$1601	;1601
	dc.w	$C3B8	;C3B8
	dc.w	$002A	;002A
	dc.w	$0144	;0144
	dc.w	$C800	;C800
	dc.w	$040C	;040C
	dc.w	$85A8	;85A8
	dc.w	$0001	;0001
	dc.w	$08C5	;08C5
	dc.w	$6200	;6200
	dc.w	$2F01	;2F01
	dc.w	$C53E	;C53E
	dc.w	$0001	;0001
	dc.w	$0A45	;0A45
	dc.w	$3E00	;3E00
	dc.w	$020B	;020B
	dc.w	$01C6	;01C6
	dc.w	$0026	;0026
	dc.w	$0141	;0141
	dc.w	$7600	;7600
	dc.w	$0311	;0311
	dc.w	$049E	;049E
	dc.w	$0001	;0001
	dc.w	$0A87	;0A87
	dc.w	$8001	;8001
	dc.w	$5601	;5601
	dc.w	$0201	;0201
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrEA014AA4:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrEA014B24:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrEA014BA4:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrEA014CA4:	dc.l	$00000000	;00000000
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
	dc.l	$00000000	;00000000
	dc.l	$00000000	;00000000
	dc.l	$00000000	;00000000
	dc.l	$00000000	;00000000
	dc.l	$00000000	;00000000
	dc.l	$00000000	;00000000
	dc.l	$00000000	;00000000
	dc.l	$00000000	;00000000
	dc.l	$00000000	;00000000
	dc.w	$0000	;0000
adrEA014DE6:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrEA014EA4:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrEA014EC4:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrEA014ED4:	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
UnpackedMonsters:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrEA0156E6:	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
Word20156F6:	dc.w	$FFFF	;FFFF
adrEA0156F8:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrEA01575E:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrEA015860:	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
MonsterTotalsCounts:	dc.w	$004C	;004C
	dc.w	$0046	;0046
	dc.w	$0053	;0053
	dc.w	$0049	;0049
serpex.monsters:	dc.w	$0510	;0510
	dc.w	$0C00	;0C00
	dc.w	$16FF	;16FF
	dc.w	$4307	;4307
	dc.w	$0A00	;0A00
	dc.w	$00FF	;00FF
	dc.w	$4400	;4400
	dc.w	$0100	;0100
	dc.w	$00FF	;00FF
	dc.w	$0307	;0307
	dc.w	$041E	;041E
	dc.w	$98FF	;98FF
	dc.w	$0501	;0501
	dc.w	$1307	;1307
	dc.w	$27FF	;27FF
	dc.w	$0504	;0504
	dc.w	$1308	;1308
	dc.w	$68FF	;68FF
	dc.w	$0504	;0504
	dc.w	$1608	;1608
	dc.w	$1100	;1100
	dc.w	$85FF	;85FF
	dc.w	$1608	;1608
	dc.w	$1201	;1201
	dc.w	$0500	;0500
	dc.w	$0D08	;0D08
	dc.w	$6AFF	;6AFF
	dc.w	$0515	;0515
	dc.w	$1307	;1307
	dc.w	$28FF	;28FF
	dc.w	$0512	;0512
	dc.w	$1308	;1308
	dc.w	$68FF	;68FF
	dc.w	$0512	;0512
	dc.w	$1608	;1608
	dc.w	$1004	;1004
	dc.w	$85FF	;85FF
	dc.w	$1608	;1608
	dc.w	$1D05	;1D05
	dc.w	$0516	;0516
	dc.w	$0D08	;0D08
	dc.w	$6AFF	;6AFF
	dc.w	$050A	;050A
	dc.w	$140A	;140A
	dc.w	$13FF	;13FF
	dc.w	$0509	;0509
	dc.w	$150A	;150A
	dc.w	$68FF	;68FF
	dc.w	$050D	;050D
	dc.w	$150A	;150A
	dc.w	$68FF	;68FF
	dc.w	$1408	;1408
	dc.w	$0D0A	;0D0A
	dc.w	$6AFF	;6AFF
	dc.w	$0410	;0410
	dc.w	$090B	;090B
	dc.w	$67FF	;67FF
	dc.w	$150B	;150B
	dc.w	$0B0A	;0B0A
	dc.w	$6608	;6608
	dc.w	$15FF	;15FF
	dc.w	$0B0B	;0B0B
	dc.w	$6609	;6609
	dc.w	$0506	;0506
	dc.w	$080B	;080B
	dc.w	$47FF	;47FF
	dc.w	$1516	;1516
	dc.w	$070C	;070C
	dc.w	$3CFF	;3CFF
	dc.w	$050E	;050E
	dc.w	$050C	;050C
	dc.w	$68FF	;68FF
	dc.w	$0516	;0516
	dc.w	$0B0C	;0B0C
	dc.w	$68FF	;68FF
	dc.w	$0513	;0513
	dc.w	$040C	;040C
	dc.w	$29FF	;29FF
	dc.w	$0515	;0515
	dc.w	$000C	;000C
	dc.w	$1FFF	;1FFF
	dc.w	$850F	;850F
	dc.w	$000D	;000D
	dc.w	$69FF	;69FF
	dc.w	$0508	;0508
	dc.w	$0511	;0511
	dc.w	$68FF	;68FF
	dc.w	$050C	;050C
	dc.w	$0310	;0310
	dc.w	$68FF	;68FF
	dc.w	$1603	;1603
	dc.w	$050E	;050E
	dc.w	$38FF	;38FF
	dc.w	$060E	;060E
	dc.w	$030D	;030D
	dc.w	$500C	;500C
	dc.w	$16FF	;16FF
	dc.w	$030E	;030E
	dc.w	$300D	;300D
	dc.w	$1603	;1603
	dc.w	$000F	;000F
	dc.w	$65FF	;65FF
	dc.w	$060F	;060F
	dc.w	$0C10	;0C10
	dc.w	$67FF	;67FF
	dc.w	$060C	;060C
	dc.w	$120F	;120F
	dc.w	$68FF	;68FF
	dc.w	$1610	;1610
	dc.w	$110F	;110F
	dc.w	$3DFF	;3DFF
	dc.w	$0602	;0602
	dc.w	$0F0E	;0F0E
	dc.w	$4E10	;4E10
	dc.w	$16FF	;16FF
	dc.w	$0F0F	;0F0F
	dc.w	$5111	;5111
	dc.w	$0606	;0606
	dc.w	$0F10	;0F10
	dc.w	$69FF	;69FF
	dc.w	$0607	;0607
	dc.w	$1110	;1110
	dc.w	$20FF	;20FF
	dc.w	$170A	;170A
	dc.w	$0011	;0011
	dc.w	$69FF	;69FF
	dc.w	$0702	;0702
	dc.w	$060F	;060F
	dc.w	$6AFF	;6AFF
	dc.w	$1702	;1702
	dc.w	$020F	;020F
	dc.w	$6AFF	;6AFF
	dc.w	$1703	;1703
	dc.w	$0B10	;0B10
	dc.w	$21FF	;21FF
	dc.w	$1706	;1706
	dc.w	$0B0F	;0B0F
	dc.w	$3AFF	;3AFF
	dc.w	$1704	;1704
	dc.w	$0D10	;0D10
	dc.w	$14FF	;14FF
	dc.w	$1707	;1707
	dc.w	$0D0F	;0D0F
	dc.w	$41FF	;41FF
	dc.w	$1400	;1400
	dc.w	$0611	;0611
	dc.w	$68FF	;68FF
	dc.w	$0405	;0405
	dc.w	$0810	;0810
	dc.w	$3414	;3414
	dc.w	$04FF	;04FF
	dc.w	$0810	;0810
	dc.w	$1F15	;1F15
	dc.w	$0402	;0402
	dc.w	$0A0F	;0A0F
	dc.w	$4818	;4818
	dc.w	$04FF	;04FF
	dc.w	$0A10	;0A10
	dc.w	$4719	;4719
	dc.w	$1407	;1407
	dc.w	$0711	;0711
	dc.w	$651C	;651C
	dc.w	$04FF	;04FF
	dc.w	$0710	;0710
	dc.w	$491D	;491D
	dc.w	$040D	;040D
	dc.w	$0611	;0611
	dc.w	$67FF	;67FF
	dc.w	$840B	;840B
	dc.w	$0110	;0110
	dc.w	$2FFF	;2FFF
	dc.w	$0309	;0309
	dc.w	$0012	;0012
	dc.w	$67FF	;67FF
	dc.w	$9301	;9301
	dc.w	$1011	;1011
	dc.w	$2320	;2320
	dc.w	$13FF	;13FF
	dc.w	$1011	;1011
	dc.w	$3B21	;3B21
	dc.w	$1305	;1305
	dc.w	$0D12	;0D12
	dc.w	$65FF	;65FF
	dc.w	$1310	;1310
	dc.w	$1010	;1010
	dc.w	$6624	;6624
	dc.w	$13FF	;13FF
	dc.w	$1011	;1011
	dc.w	$6625	;6625
	dc.w	$0300	;0300
	dc.w	$0510	;0510
	dc.w	$4428	;4428
	dc.w	$03FF	;03FF
	dc.w	$0510	;0510
	dc.w	$3229	;3229
	dc.w	$8202	;8202
	dc.w	$0712	;0712
	dc.w	$6AFF	;6AFF
	dc.w	$8203	;8203
	dc.w	$0A12	;0A12
	dc.w	$6BFF	;6BFF
	dc.w	$820D	;820D
	dc.w	$0A12	;0A12
	dc.w	$6BFF	;6BFF
	dc.w	$820D	;820D
	dc.w	$0512	;0512
	dc.w	$6BFF	;6BFF
	dc.w	$8202	;8202
	dc.w	$0512	;0512
	dc.w	$6BFF	;6BFF
	dc.w	$9203	;9203
	dc.w	$0019	;0019
	dc.w	$6CFF	;6CFF
	dc.w	$8200	;8200
	dc.w	$0414	;0414
	dc.w	$6BFF	;6BFF
	dc.w	$020B	;020B
	dc.w	$0011	;0011
	dc.w	$3FFF	;3FFF
	dc.w	$1210	;1210
	dc.w	$0910	;0910
	dc.w	$67FF	;67FF
	dc.w	$0210	;0210
	dc.w	$0B11	;0B11
	dc.w	$67FF	;67FF
	dc.w	$9207	;9207
	dc.w	$0A11	;0A11
	dc.w	$67FF	;67FF
	dc.w	$9100	;9100
	dc.w	$0211	;0211
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
chaosex.monsters:	dc.w	$0109	;0109
	dc.w	$050E	;050E
	dc.w	$1100	;1100
	dc.w	$11FF	;11FF
	dc.w	$050E	;050E
	dc.w	$6601	;6601
	dc.w	$010B	;010B
	dc.w	$050E	;050E
	dc.w	$4904	;4904
	dc.w	$11FF	;11FF
	dc.w	$050F	;050F
	dc.w	$6605	;6605
	dc.w	$1105	;1105
	dc.w	$0413	;0413
	dc.w	$67FF	;67FF
	dc.w	$110D	;110D
	dc.w	$0513	;0513
	dc.w	$67FF	;67FF
	dc.w	$8100	;8100
	dc.w	$0812	;0812
	dc.w	$68FF	;68FF
	dc.w	$0113	;0113
	dc.w	$0C12	;0C12
	dc.w	$68FF	;68FF
	dc.w	$010E	;010E
	dc.w	$0811	;0811
	dc.w	$65FF	;65FF
	dc.w	$0107	;0107
	dc.w	$0711	;0711
	dc.w	$55FF	;55FF
	dc.w	$8111	;8111
	dc.w	$0B12	;0B12
	dc.w	$2DFF	;2DFF
	dc.w	$0100	;0100
	dc.w	$0E12	;0E12
	dc.w	$4308	;4308
	dc.w	$11FF	;11FF
	dc.w	$0E12	;0E12
	dc.w	$1C09	;1C09
	dc.w	$1113	;1113
	dc.w	$1212	;1212
	dc.w	$3C0C	;3C0C
	dc.w	$01FF	;01FF
	dc.w	$1212	;1212
	dc.w	$260D	;260D
	dc.w	$0107	;0107
	dc.w	$1213	;1213
	dc.w	$69FF	;69FF
	dc.w	$810E	;810E
	dc.w	$0F13	;0F13
	dc.w	$69FF	;69FF
	dc.w	$0107	;0107
	dc.w	$1412	;1412
	dc.w	$39FF	;39FF
	dc.w	$0110	;0110
	dc.w	$1312	;1312
	dc.w	$2710	;2710
	dc.w	$11FF	;11FF
	dc.w	$1312	;1312
	dc.w	$2111	;2111
	dc.w	$0101	;0101
	dc.w	$1312	;1312
	dc.w	$1F14	;1F14
	dc.w	$91FF	;91FF
	dc.w	$1313	;1313
	dc.w	$4515	;4515
	dc.w	$8213	;8213
	dc.w	$0013	;0013
	dc.w	$69FF	;69FF
	dc.w	$920E	;920E
	dc.w	$0614	;0614
	dc.w	$69FF	;69FF
	dc.w	$8213	;8213
	dc.w	$0C13	;0C13
	dc.w	$68FF	;68FF
	dc.w	$020F	;020F
	dc.w	$0546	;0546
	dc.w	$98FF	;98FF
	dc.w	$4205	;4205
	dc.w	$0C00	;0C00
	dc.w	$0CFF	;0CFF
	dc.w	$1214	;1214
	dc.w	$1214	;1214
	dc.w	$66FF	;66FF
	dc.w	$1202	;1202
	dc.w	$1414	;1414
	dc.w	$66FF	;66FF
	dc.w	$1202	;1202
	dc.w	$0C12	;0C12
	dc.w	$4718	;4718
	dc.w	$12FF	;12FF
	dc.w	$0C13	;0C13
	dc.w	$4519	;4519
	dc.w	$0208	;0208
	dc.w	$0000	;0000
	dc.w	$16FF	;16FF
	dc.w	$0200	;0200
	dc.w	$0514	;0514
	dc.w	$68FF	;68FF
	dc.w	$0200	;0200
	dc.w	$0B15	;0B15
	dc.w	$68FF	;68FF
	dc.w	$820E	;820E
	dc.w	$0115	;0115
	dc.w	$25FF	;25FF
	dc.w	$9313	;9313
	dc.w	$0A15	;0A15
	dc.w	$69FF	;69FF
	dc.w	$0312	;0312
	dc.w	$1300	;1300
	dc.w	$101C	;101C
	dc.w	$13FF	;13FF
	dc.w	$1316	;1316
	dc.w	$651D	;651D
	dc.w	$13FF	;13FF
	dc.w	$1315	;1315
	dc.w	$651E	;651E
	dc.w	$130E	;130E
	dc.w	$0014	;0014
	dc.w	$6AFF	;6AFF
	dc.w	$0314	;0314
	dc.w	$0015	;0015
	dc.w	$67FF	;67FF
	dc.w	$130C	;130C
	dc.w	$0614	;0614
	dc.w	$1920	;1920
	dc.w	$13FF	;13FF
	dc.w	$0614	;0614
	dc.w	$1921	;1921
	dc.w	$0306	;0306
	dc.w	$1415	;1415
	dc.w	$6AFF	;6AFF
	dc.w	$0300	;0300
	dc.w	$0815	;0815
	dc.w	$38FF	;38FF
	dc.w	$0306	;0306
	dc.w	$0016	;0016
	dc.w	$44FF	;44FF
	dc.w	$0400	;0400
	dc.w	$0114	;0114
	dc.w	$1E24	;1E24
	dc.w	$14FF	;14FF
	dc.w	$0115	;0115
	dc.w	$1E25	;1E25
	dc.w	$1406	;1406
	dc.w	$0915	;0915
	dc.w	$2228	;2228
	dc.w	$04FF	;04FF
	dc.w	$0914	;0914
	dc.w	$3429	;3429
	dc.w	$0400	;0400
	dc.w	$1346	;1346
	dc.w	$98FF	;98FF
	dc.w	$1405	;1405
	dc.w	$0D17	;0D17
	dc.w	$67FF	;67FF
	dc.w	$040C	;040C
	dc.w	$0116	;0116
	dc.w	$6AFF	;6AFF
	dc.w	$040A	;040A
	dc.w	$0F15	;0F15
	dc.w	$172C	;172C
	dc.w	$14FF	;14FF
	dc.w	$0F16	;0F16
	dc.w	$172D	;172D
	dc.w	$0412	;0412
	dc.w	$0B15	;0B15
	dc.w	$68FF	;68FF
	dc.w	$4414	;4414
	dc.w	$040C	;040C
	dc.w	$0CFF	;0CFF
	dc.w	$940E	;940E
	dc.w	$0E16	;0E16
	dc.w	$65FF	;65FF
	dc.w	$040E	;040E
	dc.w	$1416	;1416
	dc.w	$68FF	;68FF
	dc.w	$0410	;0410
	dc.w	$0C12	;0C12
	dc.w	$2730	;2730
	dc.w	$14FF	;14FF
	dc.w	$0C17	;0C17
	dc.w	$2031	;2031
	dc.w	$14FF	;14FF
	dc.w	$0C15	;0C15
	dc.w	$2C32	;2C32
	dc.w	$14FF	;14FF
	dc.w	$0C16	;0C16
	dc.w	$1833	;1833
	dc.w	$850A	;850A
	dc.w	$0C18	;0C18
	dc.w	$6BFF	;6BFF
	dc.w	$8504	;8504
	dc.w	$0C18	;0C18
	dc.w	$6BFF	;6BFF
	dc.w	$8500	;8500
	dc.w	$0E18	;0E18
	dc.w	$6BFF	;6BFF
	dc.w	$8502	;8502
	dc.w	$0518	;0518
	dc.w	$6BFF	;6BFF
	dc.w	$850A	;850A
	dc.w	$0518	;0518
	dc.w	$6BFF	;6BFF
	dc.w	$850D	;850D
	dc.w	$0E18	;0E18
	dc.w	$6BFF	;6BFF
	dc.w	$8503	;8503
	dc.w	$0018	;0018
	dc.w	$6BFF	;6BFF
	dc.w	$950C	;950C
	dc.w	$001C	;001C
	dc.w	$6CFF	;6CFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
moonex.monsters:	dc.w	$8103	;8103
	dc.w	$0015	;0015
	dc.w	$67FF	;67FF
	dc.w	$9200	;9200
	dc.w	$0F16	;0F16
	dc.w	$24FF	;24FF
	dc.w	$0200	;0200
	dc.w	$0716	;0716
	dc.w	$2D00	;2D00
	dc.w	$12FF	;12FF
	dc.w	$0717	;0717
	dc.w	$2C01	;2C01
	dc.w	$8203	;8203
	dc.w	$0D19	;0D19
	dc.w	$68FF	;68FF
	dc.w	$0306	;0306
	dc.w	$0716	;0716
	dc.w	$1704	;1704
	dc.w	$93FF	;93FF
	dc.w	$0717	;0717
	dc.w	$1705	;1705
	dc.w	$1300	;1300
	dc.w	$0217	;0217
	dc.w	$6AFF	;6AFF
	dc.w	$9301	;9301
	dc.w	$0917	;0917
	dc.w	$3EFF	;3EFF
	dc.w	$9300	;9300
	dc.w	$1017	;1017
	dc.w	$68FF	;68FF
	dc.w	$8306	;8306
	dc.w	$1000	;1000
	dc.w	$16FF	;16FF
	dc.w	$0305	;0305
	dc.w	$0916	;0916
	dc.w	$4E08	;4E08
	dc.w	$83FF	;83FF
	dc.w	$0917	;0917
	dc.w	$3609	;3609
	dc.w	$0305	;0305
	dc.w	$0A16	;0A16
	dc.w	$540C	;540C
	dc.w	$83FF	;83FF
	dc.w	$0A17	;0A17
	dc.w	$4F0D	;4F0D
	dc.w	$8310	;8310
	dc.w	$0A19	;0A19
	dc.w	$67FF	;67FF
	dc.w	$130C	;130C
	dc.w	$0717	;0717
	dc.w	$6610	;6610
	dc.w	$13FF	;13FF
	dc.w	$0718	;0718
	dc.w	$6611	;6611
	dc.w	$130D	;130D
	dc.w	$0517	;0517
	dc.w	$1414	;1414
	dc.w	$93FF	;93FF
	dc.w	$0518	;0518
	dc.w	$1415	;1415
	dc.w	$8309	;8309
	dc.w	$1018	;1018
	dc.w	$68FF	;68FF
	dc.w	$030A	;030A
	dc.w	$0D17	;0D17
	dc.w	$68FF	;68FF
	dc.w	$940D	;940D
	dc.w	$0B19	;0B19
	dc.w	$3AFF	;3AFF
	dc.w	$9400	;9400
	dc.w	$0D19	;0D19
	dc.w	$39FF	;39FF
	dc.w	$8410	;8410
	dc.w	$0314	;0314
	dc.w	$67FF	;67FF
	dc.w	$1409	;1409
	dc.w	$0014	;0014
	dc.w	$67FF	;67FF
	dc.w	$0405	;0405
	dc.w	$0614	;0614
	dc.w	$4B18	;4B18
	dc.w	$04FF	;04FF
	dc.w	$0614	;0614
	dc.w	$4A19	;4A19
	dc.w	$14FF	;14FF
	dc.w	$0617	;0617
	dc.w	$471A	;471A
	dc.w	$0409	;0409
	dc.w	$0E16	;0E16
	dc.w	$69FF	;69FF
	dc.w	$0410	;0410
	dc.w	$0518	;0518
	dc.w	$67FF	;67FF
	dc.w	$040D	;040D
	dc.w	$0216	;0216
	dc.w	$68FF	;68FF
	dc.w	$1504	;1504
	dc.w	$0F19	;0F19
	dc.w	$3C1C	;3C1C
	dc.w	$15FF	;15FF
	dc.w	$0F19	;0F19
	dc.w	$211D	;211D
	dc.w	$0505	;0505
	dc.w	$0817	;0817
	dc.w	$1720	;1720
	dc.w	$15FF	;15FF
	dc.w	$0818	;0818
	dc.w	$1821	;1821
	dc.w	$95FF	;95FF
	dc.w	$0819	;0819
	dc.w	$1922	;1922
	dc.w	$9501	;9501
	dc.w	$0019	;0019
	dc.w	$6AFF	;6AFF
	dc.w	$1506	;1506
	dc.w	$011A	;011A
	dc.w	$67FF	;67FF
	dc.w	$1509	;1509
	dc.w	$0219	;0219
	dc.w	$69FF	;69FF
	dc.w	$1510	;1510
	dc.w	$0418	;0418
	dc.w	$69FF	;69FF
	dc.w	$050D	;050D
	dc.w	$0D19	;0D19
	dc.w	$68FF	;68FF
	dc.w	$0508	;0508
	dc.w	$1017	;1017
	dc.w	$3324	;3324
	dc.w	$95FF	;95FF
	dc.w	$1019	;1019
	dc.w	$1925	;1925
	dc.w	$15FF	;15FF
	dc.w	$1019	;1019
	dc.w	$1826	;1826
	dc.w	$1807	;1807
	dc.w	$0C1A	;0C1A
	dc.w	$67FF	;67FF
	dc.w	$9806	;9806
	dc.w	$0618	;0618
	dc.w	$41FF	;41FF
	dc.w	$080E	;080E
	dc.w	$0619	;0619
	dc.w	$2B28	;2B28
	dc.w	$08FF	;08FF
	dc.w	$0619	;0619
	dc.w	$2A29	;2A29
	dc.w	$18FF	;18FF
	dc.w	$0619	;0619
	dc.w	$382A	;382A
	dc.w	$18FF	;18FF
	dc.w	$061A	;061A
	dc.w	$1E2B	;1E2B
	dc.w	$080C	;080C
	dc.w	$0D1A	;0D1A
	dc.w	$67FF	;67FF
	dc.w	$0806	;0806
	dc.w	$0D17	;0D17
	dc.w	$522C	;522C
	dc.w	$98FF	;98FF
	dc.w	$0D19	;0D19
	dc.w	$232D	;232D
	dc.w	$0800	;0800
	dc.w	$0D19	;0D19
	dc.w	$4D30	;4D30
	dc.w	$08FF	;08FF
	dc.w	$0D19	;0D19
	dc.w	$3231	;3231
	dc.w	$8800	;8800
	dc.w	$0F1B	;0F1B
	dc.w	$69FF	;69FF
	dc.w	$9703	;9703
	dc.w	$0017	;0017
	dc.w	$3DFF	;3DFF
	dc.w	$1703	;1703
	dc.w	$0518	;0518
	dc.w	$6AFF	;6AFF
	dc.w	$070C	;070C
	dc.w	$0318	;0318
	dc.w	$4C34	;4C34
	dc.w	$17FF	;17FF
	dc.w	$031A	;031A
	dc.w	$3435	;3435
	dc.w	$87FF	;87FF
	dc.w	$0319	;0319
	dc.w	$2F36	;2F36
	dc.w	$1703	;1703
	dc.w	$0D19	;0D19
	dc.w	$6638	;6638
	dc.w	$97FF	;97FF
	dc.w	$0D1B	;0D1B
	dc.w	$1A39	;1A39
	dc.w	$17FF	;17FF
	dc.w	$0D1A	;0D1A
	dc.w	$173A	;173A
	dc.w	$17FF	;17FF
	dc.w	$0D19	;0D19
	dc.w	$663B	;663B
	dc.w	$070E	;070E
	dc.w	$061C	;061C
	dc.w	$10FF	;10FF
	dc.w	$9609	;9609
	dc.w	$0017	;0017
	dc.w	$20FF	;20FF
	dc.w	$0606	;0606
	dc.w	$0C19	;0C19
	dc.w	$68FF	;68FF
	dc.w	$8600	;8600
	dc.w	$001A	;001A
	dc.w	$67FF	;67FF
	dc.w	$9600	;9600
	dc.w	$0E19	;0E19
	dc.w	$53FF	;53FF
	dc.w	$0604	;0604
	dc.w	$1019	;1019
	dc.w	$48FF	;48FF
	dc.w	$0607	;0607
	dc.w	$0D19	;0D19
	dc.w	$4AFF	;4AFF
	dc.w	$060D	;060D
	dc.w	$0C19	;0C19
	dc.w	$133C	;133C
	dc.w	$96FF	;96FF
	dc.w	$0C1A	;0C1A
	dc.w	$3A3D	;3A3D
	dc.w	$960E	;960E
	dc.w	$001A	;001A
	dc.w	$53FF	;53FF
	dc.w	$820F	;820F
	dc.w	$001B	;001B
	dc.w	$6BFF	;6BFF
	dc.w	$820E	;820E
	dc.w	$001B	;001B
	dc.w	$6BFF	;6BFF
	dc.w	$820E	;820E
	dc.w	$091B	;091B
	dc.w	$6BFF	;6BFF
	dc.w	$820F	;820F
	dc.w	$091B	;091B
	dc.w	$6BFF	;6BFF
	dc.w	$820B	;820B
	dc.w	$0A1B	;0A1B
	dc.w	$6BFF	;6BFF
	dc.w	$820B	;820B
	dc.w	$001B	;001B
	dc.w	$6BFF	;6BFF
	dc.w	$8206	;8206
	dc.w	$031B	;031B
	dc.w	$6BFF	;6BFF
	dc.w	$9206	;9206
	dc.w	$0B1E	;0B1E
	dc.w	$6CFF	;6CFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
dragex.monsters:
	INCBIN bext-data/dragex.monsters

DroppedObjects:	dc.w	$0000	;0000
	dc.w	$000E	;000E
	dc.w	$0020	;0020
	dc.w	$0045	;0045
	dc.w	$5656	;5656
	dc.w	$5251	;5251
	dc.w	$5350	;5350
	dc.w	$1717	;1717
	dc.w	$1A18	;1A18
	dc.w	$6019	;6019
	dc.w	$3453	;3453
	dc.w	$5150	;5150
	dc.w	$5656	;5656
	dc.w	$181A	;181A
	dc.w	$1820	;1820
	dc.w	$2052	;2052
	dc.w	$3518	;3518
	dc.w	$531A	;531A
	dc.w	$1917	;1917
	dc.w	$1861	;1861
	dc.w	$5150	;5150
	dc.w	$2250	;2250
	dc.w	$2E52	;2E52
	dc.w	$5625	;5625
	dc.w	$3153	;3153
	dc.w	$5522	;5522
	dc.w	$5551	;5551
	dc.w	$2E52	;2E52
	dc.w	$5156	;5156
	dc.w	$5053	;5053
	dc.w	$3B56	;3B56
	dc.w	$5229	;5229
	dc.w	$5550	;5550
	dc.w	$5136	;5136
	dc.w	$5418	;5418
	dc.w	$1A18	;1A18
	dc.w	$1917	;1917
	dc.w	$1A37	;1A37
	dc.w	$6352	;6352
	dc.w	$5154	;5154
	dc.w	$5553	;5553
	dc.w	$5654	;5654
	dc.w	$5052	;5052
	dc.w	$5051	;5051
	dc.w	$5355	;5355
	dc.w	$5052	;5052
	dc.w	$5451	;5451
	dc.w	$1818	;1818
	dc.w	$5056	;5056
	dc.w	$1A18	;1A18
	dc.w	$1A18	;1A18
	dc.w	$1A18	;1A18
	dc.w	$6200	;6200
SpellBook_Runes:	dc.b	'mar'	;6D6172
	dc.b	'yhadalittlelaaneeitwerraguddutnerewanzednowtecozzitwerawuddunwhyamistillhavintotypethiscrapwhithoughtidfinishacoupleoflinesq'	;79686164616C6974746C656C61616E6565697477657272616775646475746E65726577616E7A65646E6F777465636F7A7A69747765726177756464756E776879616D697374696C6C686176696E746F74797065746869736372617077686974686F75676874696466696E69736861636F75706C656F666C696E657371
	dc.b	'x'	;78
adrEA016652:	dc.w	$0000	;0000
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
adrEA016782:	dc.w	$0001	;0001
	dc.w	$0501	;0501
	dc.w	$0001	;0001
	dc.w	$F801	;F801
adrEA01678A:	dc.w	$0000	;0000
	dc.w	$0300	;0300
	dc.w	$0000	;0000
	dc.w	$F600	;F600
adrEA016792:	dc.w	$0001	;0001
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
adrEA0168C2:	dc.w	$0002	;0002
	dc.w	$0402	;0402
	dc.w	$0002	;0002
	dc.w	$F802	;F802
adrEA0168CA:	dc.w	$0001	;0001
	dc.w	$0201	;0201
	dc.w	$0001	;0001
	dc.w	$F601	;F601
adrEA0168D2:	dc.w	$01FF	;01FF
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
adrEA01692C:	dc.w	$0000	;0000
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
adrEA016964:	dc.w	$0000	;0000
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
adrEA01697A:	dc.w	$0000	;0000
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
adrEA01699E:	dc.w	$0000	;0000
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
adrEA0169BE:	dc.w	$0000	;0000
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
adrEA0169DE:	dc.w	$0000	;0000
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
adrEA0169FE:	dc.w	$0000	;0000
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
adrEA016A1E:	dc.w	$0000	;0000
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
adrEA016A40:	dc.w	$0000	;0000
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
adrEA016A62:	dc.w	$0000	;0000
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
adrEA016A7C:	dc.w	$0000	;0000
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
adrEA016A9C:	dc.w	$0000	;0000
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
adrEA016AB4:	dc.w	$0000	;0000
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
adrEA016ACC:	dc.w	$001F	;001F
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
	dc.w	$000C	;000C
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
adrEA016D4C:	dc.w	$F801	;F801
	dc.w	$F7FE	;F7FE
	dc.w	$F7FE	;F7FE
	dc.w	$F7FE	;F7FE
	dc.w	$FBF1	;FBF1
	dc.w	$F7F2	;F7F2
	dc.w	$F7FE	;F7FE
	dc.w	$F7F2	;F7F2
	dc.w	$FBF3	;FBF3
	dc.w	$F7F5	;F7F5
	dc.w	$F7FD	;F7FD
	dc.w	$F7F5	;F7F5
	dc.w	$FBE7	;FBE7
	dc.w	$F7EB	;F7EB
	dc.w	$F7FB	;F7FB
	dc.w	$F7EB	;F7EB
	dc.w	$FBCF	;FBCF
	dc.w	$F7D7	;F7D7
	dc.w	$F7F7	;F7F7
	dc.w	$F7D7	;F7D7
	dc.w	$FB9F	;FB9F
	dc.w	$F7AF	;F7AF
	dc.w	$F7EF	;F7EF
	dc.w	$F7AF	;F7AF
	dc.w	$FB3F	;FB3F
	dc.w	$F75F	;F75F
	dc.w	$F7DF	;F7DF
	dc.w	$F75F	;F75F
	dc.w	$F87F	;F87F
	dc.w	$F4BF	;F4BF
	dc.w	$F7BF	;F7BF
	dc.w	$F4BF	;F4BF
	dc.w	$F8FF	;F8FF
	dc.w	$F57F	;F57F
	dc.w	$F77F	;F77F
	dc.w	$F57F	;F57F
	dc.w	$F9FF	;F9FF
	dc.w	$F6FF	;F6FF
	dc.w	$F6FF	;F6FF
	dc.w	$F6FF	;F6FF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FCFF	;FCFF
	dc.w	$FB7F	;FB7F
	dc.w	$FB7F	;FB7F
	dc.w	$FB7F	;FB7F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F87F	;F87F
	dc.w	$F4BF	;F4BF
	dc.w	$F7BF	;F7BF
	dc.w	$F4BF	;F4BF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F33F	;F33F
	dc.w	$EB5F	;EB5F
	dc.w	$EFDF	;EFDF
	dc.w	$EB5F	;EB5F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$E79F	;E79F
	dc.w	$D7AF	;D7AF
	dc.w	$DFEF	;DFEF
	dc.w	$D7AF	;D7AF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$CFCF	;CFCF
	dc.w	$AFD7	;AFD7
	dc.w	$BFF7	;BFF7
	dc.w	$AFD7	;AFD7
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$9FE7	;9FE7
	dc.w	$5FEB	;5FEB
	dc.w	$7FFB	;7FFB
	dc.w	$5FEB	;5FEB
	dc.w	$FFFF	;FFFF
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$3FF3	;3FF3
	dc.w	$BFF5	;BFF5
	dc.w	$FFFD	;FFFD
	dc.w	$BFF5	;BFF5
	dc.w	$FFFE	;FFFE
	dc.w	$FFFD	;FFFD
	dc.w	$FFFD	;FFFD
	dc.w	$FFFD	;FFFD
	dc.w	$1FE1	;1FE1
	dc.w	$1FE2	;1FE2
	dc.w	$FFFE	;FFFE
	dc.w	$1FE2	;1FE2
	dc.w	$FFFE	;FFFE
	dc.w	$FFFD	;FFFD
	dc.w	$FFFD	;FFFD
	dc.w	$FFFD	;FFFD
	dc.w	$0001	;0001
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFD	;FFFD
	dc.w	$FFFD	;FFFD
	dc.w	$FFFD	;FFFD
	dc.w	$007F	;007F
	dc.w	$FFBF	;FFBF
	dc.w	$FFBF	;FFBF
	dc.w	$FFBF	;FFBF
	dc.w	$FFFE	;FFFE
	dc.w	$FFFD	;FFFD
	dc.w	$FFFD	;FFFD
	dc.w	$FFFD	;FFFD
	dc.w	$3F7F	;3F7F
	dc.w	$3FBF	;3FBF
	dc.w	$FFBF	;FFBF
	dc.w	$3FBF	;3FBF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$3F7F	;3F7F
	dc.w	$BFBF	;BFBF
	dc.w	$FFBF	;FFBF
	dc.w	$BFBF	;BFBF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$9F7F	;9F7F
	dc.w	$5FBF	;5FBF
	dc.w	$7FBF	;7FBF
	dc.w	$5FBF	;5FBF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$CF7F	;CF7F
	dc.w	$AFBF	;AFBF
	dc.w	$BFBF	;BFBF
	dc.w	$AFBF	;AFBF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$E77F	;E77F
	dc.w	$D7BF	;D7BF
	dc.w	$DFBF	;DFBF
	dc.w	$D7BF	;D7BF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F37F	;F37F
	dc.w	$EBBF	;EBBF
	dc.w	$EFBF	;EFBF
	dc.w	$EBBF	;EBBF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F87F	;F87F
	dc.w	$F4BF	;F4BF
	dc.w	$F7BF	;F7BF
	dc.w	$F4BF	;F4BF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FC7F	;FC7F
	dc.w	$FABF	;FABF
	dc.w	$FBBF	;FBBF
	dc.w	$FABF	;FABF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FE7F	;FE7F
	dc.w	$FDBF	;FDBF
	dc.w	$FDBF	;FDBF
	dc.w	$FDBF	;FDBF
	dc.w	$FF3F	;FF3F
	dc.w	$FEDF	;FEDF
	dc.w	$FEDF	;FEDF
	dc.w	$FEDF	;FEDF
	dc.w	$FE1F	;FE1F
	dc.w	$FD2F	;FD2F
	dc.w	$FDEF	;FDEF
	dc.w	$FD2F	;FD2F
	dc.w	$FCCF	;FCCF
	dc.w	$FAD7	;FAD7
	dc.w	$FBF7	;FBF7
	dc.w	$FAD7	;FAD7
	dc.w	$F9EF	;F9EF
	dc.w	$F5F7	;F5F7
	dc.w	$F7F7	;F7F7
	dc.w	$F5F7	;F5F7
	dc.w	$F3EF	;F3EF
	dc.w	$EBF7	;EBF7
	dc.w	$EFF7	;EFF7
	dc.w	$EBF7	;EBF7
	dc.w	$E7EF	;E7EF
	dc.w	$D7F7	;D7F7
	dc.w	$DFF7	;DFF7
	dc.w	$D7F7	;D7F7
	dc.w	$F3EF	;F3EF
	dc.w	$EBF7	;EBF7
	dc.w	$EFF7	;EFF7
	dc.w	$EBF7	;EBF7
	dc.w	$F9EF	;F9EF
	dc.w	$F5F7	;F5F7
	dc.w	$F7F7	;F7F7
	dc.w	$F5F7	;F5F7
	dc.w	$FCCF	;FCCF
	dc.w	$FAD7	;FAD7
	dc.w	$FBF7	;FBF7
	dc.w	$FAD7	;FAD7
	dc.w	$FE1F	;FE1F
	dc.w	$FD2F	;FD2F
	dc.w	$FDEF	;FDEF
	dc.w	$FD2F	;FD2F
	dc.w	$FF3F	;FF3F
	dc.w	$FEDF	;FEDF
	dc.w	$FEDF	;FEDF
	dc.w	$FEDF	;FEDF
	dc.w	$FFFE	;FFFE
	dc.w	$FFFD	;FFFD
	dc.w	$FFFD	;FFFD
	dc.w	$FFFD	;FFFD
	dc.w	$0001	;0001
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFD	;FFFD
	dc.w	$FFFD	;FFFD
	dc.w	$FFFD	;FFFD
	dc.w	$1FE1	;1FE1
	dc.w	$1FE2	;1FE2
	dc.w	$FFFE	;FFFE
	dc.w	$1FE2	;1FE2
	dc.w	$FFFF	;FFFF
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$3FF3	;3FF3
	dc.w	$BFF5	;BFF5
	dc.w	$FFFD	;FFFD
	dc.w	$BFF5	;BFF5
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$9FE7	;9FE7
	dc.w	$5FEB	;5FEB
	dc.w	$7FFB	;7FFB
	dc.w	$5FEB	;5FEB
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$CFCF	;CFCF
	dc.w	$AFD7	;AFD7
	dc.w	$BFF7	;BFF7
	dc.w	$AFD7	;AFD7
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$E79F	;E79F
	dc.w	$D7AF	;D7AF
	dc.w	$DFEF	;DFEF
	dc.w	$D7AF	;D7AF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F33F	;F33F
	dc.w	$EB5F	;EB5F
	dc.w	$EFDF	;EFDF
	dc.w	$EB5F	;EB5F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F87F	;F87F
	dc.w	$F4BF	;F4BF
	dc.w	$F7BF	;F7BF
	dc.w	$F4BF	;F4BF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FCFF	;FCFF
	dc.w	$FB7F	;FB7F
	dc.w	$FB7F	;FB7F
	dc.w	$FB7F	;FB7F
	dc.w	$F3FF	;F3FF
	dc.w	$EDFF	;EDFF
	dc.w	$EDFF	;EDFF
	dc.w	$EDFF	;EDFF
	dc.w	$E1FF	;E1FF
	dc.w	$D2FF	;D2FF
	dc.w	$DEFF	;DEFF
	dc.w	$D2FF	;D2FF
	dc.w	$CCFF	;CCFF
	dc.w	$AD7F	;AD7F
	dc.w	$BF7F	;BF7F
	dc.w	$AD7F	;AD7F
	dc.w	$DE7F	;DE7F
	dc.w	$BEBF	;BEBF
	dc.w	$BFBF	;BFBF
	dc.w	$BEBF	;BEBF
	dc.w	$DF3F	;DF3F
	dc.w	$BF5F	;BF5F
	dc.w	$BFDF	;BFDF
	dc.w	$BF5F	;BF5F
	dc.w	$DF9F	;DF9F
	dc.w	$BFAF	;BFAF
	dc.w	$BFEF	;BFEF
	dc.w	$BFAF	;BFAF
	dc.w	$DF3F	;DF3F
	dc.w	$BF5F	;BF5F
	dc.w	$BFDF	;BFDF
	dc.w	$BF5F	;BF5F
	dc.w	$DE7F	;DE7F
	dc.w	$BEBF	;BEBF
	dc.w	$BFBF	;BFBF
	dc.w	$BEBF	;BEBF
	dc.w	$CCFF	;CCFF
	dc.w	$AD7F	;AD7F
	dc.w	$BF7F	;BF7F
	dc.w	$AD7F	;AD7F
	dc.w	$E1FF	;E1FF
	dc.w	$D2FF	;D2FF
	dc.w	$DEFF	;DEFF
	dc.w	$D2FF	;D2FF
	dc.w	$F3FF	;F3FF
	dc.w	$EDFF	;EDFF
	dc.w	$EDFF	;EDFF
	dc.w	$EDFF	;EDFF
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
adrEA01710C:	dc.w	$01FF	;01FF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FE00	;FE00
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1E00	;1E00
	dc.w	$01FF	;01FF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$01E0	;01E0
	dc.w	$FE00	;FE00
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$60FF	;60FF
	dc.w	$1FFF	;1FFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FC18	;FC18
	dc.w	$FFE0	;FFE0
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$9F80	;9F80
	dc.w	$7F80	;7F80
	dc.w	$007F	;007F
	dc.w	$0000	;0000
	dc.w	$07E4	;07E4
	dc.w	$07F8	;07F8
	dc.w	$F800	;F800
	dc.w	$0000	;0000
	dc.w	$A07F	;A07F
	dc.w	$607F	;607F
	dc.w	$1FFF	;1FFF
	dc.w	$007F	;007F
	dc.w	$F814	;F814
	dc.w	$F818	;F818
	dc.w	$FFE0	;FFE0
	dc.w	$F800	;F800
	dc.w	$AFFF	;AFFF
	dc.w	$6FFF	;6FFF
	dc.w	$1FFF	;1FFF
	dc.w	$0FFF	;0FFF
	dc.w	$3FD4	;3FD4
	dc.w	$3FD8	;3FD8
	dc.w	$3FE0	;3FE0
	dc.w	$3FC0	;3FC0
	dc.w	$A9FC	;A9FC
	dc.w	$6DFD	;6DFD
	dc.w	$1DFC	;1DFC
	dc.w	$0DFC	;0DFC
	dc.w	$7F14	;7F14
	dc.w	$7F98	;7F98
	dc.w	$7FA0	;7FA0
	dc.w	$7F80	;7F80
	dc.w	$ABF2	;ABF2
	dc.w	$6BF4	;6BF4
	dc.w	$1BF0	;1BF0
	dc.w	$0BF0	;0BF0
	dc.w	$FF54	;FF54
	dc.w	$FF58	;FF58
	dc.w	$FF60	;FF60
	dc.w	$FF40	;FF40
	dc.w	$AFC9	;AFC9
	dc.w	$6FC1	;6FC1
	dc.w	$1FC1	;1FC1
	dc.w	$0FC1	;0FC1
	dc.w	$FFD4	;FFD4
	dc.w	$FFD8	;FFD8
	dc.w	$FFE0	;FFE0
	dc.w	$FFC0	;FFC0
	dc.w	$AF16	;AF16
	dc.w	$6F20	;6F20
	dc.w	$1F20	;1F20
	dc.w	$0F20	;0F20
	dc.w	$FFD4	;FFD4
	dc.w	$FFD8	;FFD8
	dc.w	$FFE0	;FFE0
	dc.w	$FFC0	;FFC0
	dc.w	$AEED	;AEED
	dc.w	$6E0C	;6E0C
	dc.w	$1E0C	;1E0C
	dc.w	$0E0C	;0E0C
	dc.w	$77D4	;77D4
	dc.w	$77D8	;77D8
	dc.w	$77E0	;77E0
	dc.w	$77C0	;77C0
	dc.w	$ADDE	;ADDE
	dc.w	$6CDE	;6CDE
	dc.w	$1CDE	;1CDE
	dc.w	$0CDE	;0CDE
	dc.w	$A3D4	;A3D4
	dc.w	$2BD8	;2BD8
	dc.w	$23E0	;23E0
	dc.w	$23C0	;23C0
	dc.w	$AFFE	;AFFE
	dc.w	$6FFE	;6FFE
	dc.w	$1FFE	;1FFE
	dc.w	$0FFE	;0FFE
	dc.w	$83D4	;83D4
	dc.w	$1BD8	;1BD8
	dc.w	$03E0	;03E0
	dc.w	$03C0	;03C0
	dc.w	$AE3C	;AE3C
	dc.w	$6E3D	;6E3D
	dc.w	$1E3C	;1E3C
	dc.w	$0E3C	;0E3C
	dc.w	$93D4	;93D4
	dc.w	$2BD8	;2BD8
	dc.w	$03E0	;03E0
	dc.w	$03C0	;03C0
	dc.w	$AED9	;AED9
	dc.w	$6E9A	;6E9A
	dc.w	$1E98	;1E98
	dc.w	$0E98	;0E98
	dc.w	$C9D4	;C9D4
	dc.w	$25D8	;25D8
	dc.w	$01E0	;01E0
	dc.w	$01C0	;01C0
	dc.w	$AFF1	;AFF1
	dc.w	$6FC6	;6FC6
	dc.w	$1FC0	;1FC0
	dc.w	$0FC0	;0FC0
	dc.w	$49D4	;49D4
	dc.w	$05D8	;05D8
	dc.w	$01E0	;01E0
	dc.w	$01C0	;01C0
	dc.w	$AFE3	;AFE3
	dc.w	$6FEC	;6FEC
	dc.w	$1FE0	;1FE0
	dc.w	$0FE0	;0FE0
	dc.w	$ADD4	;ADD4
	dc.w	$21D8	;21D8
	dc.w	$21E0	;21E0
	dc.w	$21C0	;21C0
	dc.w	$AFDE	;AFDE
	dc.w	$6FC0	;6FC0
	dc.w	$1FC0	;1FC0
	dc.w	$0FC0	;0FC0
	dc.w	$95D4	;95D4
	dc.w	$11D8	;11D8
	dc.w	$11E0	;11E0
	dc.w	$11C0	;11C0
	dc.w	$5601	;5601
	dc.w	$3600	;3600
	dc.w	$0E00	;0E00
	dc.w	$0600	;0600
	dc.w	$B9A8	;B9A8
	dc.w	$39B0	;39B0
	dc.w	$39C0	;39C0
	dc.w	$3980	;3980
	dc.w	$56D1	;56D1
	dc.w	$36D6	;36D6
	dc.w	$0ED0	;0ED0
	dc.w	$06D0	;06D0
	dc.w	$99A8	;99A8
	dc.w	$19B0	;19B0
	dc.w	$19C0	;19C0
	dc.w	$1980	;1980
	dc.w	$57F8	;57F8
	dc.w	$37FB	;37FB
	dc.w	$0FF8	;0FF8
	dc.w	$07F8	;07F8
	dc.w	$BDA8	;BDA8
	dc.w	$3DB0	;3DB0
	dc.w	$3DC0	;3DC0
	dc.w	$3D80	;3D80
	dc.w	$57FC	;57FC
	dc.w	$37FD	;37FD
	dc.w	$0FFC	;0FFC
	dc.w	$07FC	;07FC
	dc.w	$CFA8	;CFA8
	dc.w	$0FB0	;0FB0
	dc.w	$0FC0	;0FC0
	dc.w	$0F80	;0F80
	dc.w	$57FE	;57FE
	dc.w	$37FE	;37FE
	dc.w	$0FFE	;0FFE
	dc.w	$07FE	;07FE
	dc.w	$5FA8	;5FA8
	dc.w	$9FB0	;9FB0
	dc.w	$1FC0	;1FC0
	dc.w	$1F80	;1F80
	dc.w	$5787	;5787
	dc.w	$3787	;3787
	dc.w	$0F87	;0F87
	dc.w	$0787	;0787
	dc.w	$2FA8	;2FA8
	dc.w	$4FB0	;4FB0
	dc.w	$0FC0	;0FC0
	dc.w	$0F80	;0F80
	dc.w	$2B2B	;2B2B
	dc.w	$1B23	;1B23
	dc.w	$0723	;0723
	dc.w	$0323	;0323
	dc.w	$AF50	;AF50
	dc.w	$8F60	;8F60
	dc.w	$8F80	;8F80
	dc.w	$8F00	;8F00
	dc.w	$2B57	;2B57
	dc.w	$1B13	;1B13
	dc.w	$0713	;0713
	dc.w	$0313	;0313
	dc.w	$2F50	;2F50
	dc.w	$4F60	;4F60
	dc.w	$0F80	;0F80
	dc.w	$0F00	;0F00
	dc.w	$2B9F	;2B9F
	dc.w	$1B80	;1B80
	dc.w	$0780	;0780
	dc.w	$0380	;0380
	dc.w	$9F50	;9F50
	dc.w	$1F60	;1F60
	dc.w	$1F80	;1F80
	dc.w	$1F00	;1F00
	dc.w	$15E0	;15E0
	dc.w	$0DE0	;0DE0
	dc.w	$03E0	;03E0
	dc.w	$01E0	;01E0
	dc.w	$7EA0	;7EA0
	dc.w	$7EC0	;7EC0
	dc.w	$7F00	;7F00
	dc.w	$7E00	;7E00
	dc.w	$15F9	;15F9
	dc.w	$0DF9	;0DF9
	dc.w	$03F9	;03F9
	dc.w	$01F9	;01F9
	dc.w	$FEA0	;FEA0
	dc.w	$FEC0	;FEC0
	dc.w	$FF00	;FF00
	dc.w	$FE00	;FE00
	dc.w	$0AFC	;0AFC
	dc.w	$06FC	;06FC
	dc.w	$01FC	;01FC
	dc.w	$00FC	;00FC
	dc.w	$FD40	;FD40
	dc.w	$FD80	;FD80
	dc.w	$FE00	;FE00
	dc.w	$FC00	;FC00
	dc.w	$0AFE	;0AFE
	dc.w	$06FE	;06FE
	dc.w	$01FE	;01FE
	dc.w	$00FE	;00FE
	dc.w	$FD40	;FD40
	dc.w	$FD80	;FD80
	dc.w	$FE00	;FE00
	dc.w	$FC00	;FC00
	dc.w	$057E	;057E
	dc.w	$037E	;037E
	dc.w	$00FE	;00FE
	dc.w	$007E	;007E
	dc.w	$FA80	;FA80
	dc.w	$FB00	;FB00
	dc.w	$FC00	;FC00
	dc.w	$F800	;F800
	dc.w	$057D	;057D
	dc.w	$037D	;037D
	dc.w	$00FD	;00FD
	dc.w	$007D	;007D
	dc.w	$FA80	;FA80
	dc.w	$FB00	;FB00
	dc.w	$FC00	;FC00
	dc.w	$F800	;F800
	dc.w	$02BF	;02BF
	dc.w	$01BF	;01BF
	dc.w	$007F	;007F
	dc.w	$003F	;003F
	dc.w	$F500	;F500
	dc.w	$F600	;F600
	dc.w	$F800	;F800
	dc.w	$F000	;F000
	dc.w	$0153	;0153
	dc.w	$00DB	;00DB
	dc.w	$003B	;003B
	dc.w	$001B	;001B
	dc.w	$8A00	;8A00
	dc.w	$CC00	;CC00
	dc.w	$D000	;D000
	dc.w	$C000	;C000
	dc.w	$00AF	;00AF
	dc.w	$006F	;006F
	dc.w	$001F	;001F
	dc.w	$000F	;000F
	dc.w	$D400	;D400
	dc.w	$D800	;D800
	dc.w	$E000	;E000
	dc.w	$C000	;C000
	dc.w	$0053	;0053
	dc.w	$0033	;0033
	dc.w	$000F	;000F
	dc.w	$0003	;0003
	dc.w	$2800	;2800
	dc.w	$3000	;3000
	dc.w	$C000	;C000
	dc.w	$0000	;0000
	dc.w	$002C	;002C
	dc.w	$001C	;001C
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$D000	;D000
	dc.w	$E000	;E000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0013	;0013
	dc.w	$000F	;000F
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$2000	;2000
	dc.w	$C000	;C000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$000C	;000C
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C000	;C000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0003	;0003
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrEA01739C:	dc.b	'ARMOUR  TERROR  VITALISEBEGUILE DEFLECT MAGELOCKCONCEAL WARPOWERMISSILE VANISH  PARALYZEALCHEMY CONFUSE LEVITATEANTIMAGERECH'	;41524D4F55522020544552524F522020564954414C49534542454755494C45204445464C454354204D4147454C4F434B434F4E4345414C20574152504F5745524D495353494C452056414E4953482020504152414C595A45414C4348454D5920434F4E46555345204C45564954415445414E54494D41474552454348
	dc.b	'ARGETRUEVIEWRENEW   VIVIFY  DISPELL FIREPATHILLUSIONCOMPASS SPELLTAPDISRUPT FIREBALLWYCHWINDARC BOLTFORMWALLSUMMON  BLAZE   '	;41524745545255455649455752454E4557202020564956494659202044495350454C4C204649524550415448494C4C5553494F4E434F4D50415353205350454C4C54415044495352555054204649524542414C4C5759434857494E4441524320424F4C54464F524D57414C4C53554D4D4F4E2020424C415A45202020
	dc.b	'MINDROCKPROTECT PHAZE   ENHANCE INFERNO NULLIFY RESTORE SPRAY   VORTEX  '	;4D494E44524F434B50524F54454354205048415A45202020454E48414E434520494E4645524E4F204E554C4C49465920524553544F5245205350524159202020564F525445582020
adrEA0174DC:	dc.b	$1A	;1A
	dc.b	'WEAR THIS SPELL WITH PRIDE'	;574541522054484953205350454C4C2057495448205052494445
	dc.b	$04	;04
	dc.b	'BOO!'	;424F4F21
	dc.b	$19	;19
	dc.b	'YOU''LL NEVER FEEL SO GOOD'	;594F55274C4C204E45564552204645454C20534F20474F4F44
	dc.b	$1B	;1B
	dc.b	'COAT THY TONGUE WITH SILVER!A SPELL A DAY KEEPS AN ARROW AWAY%WHY BOTHER WITH ALL THOSE SILLY KEYS?$WHAT CANNOT BE SEEN CANN'	;434F41542054485920544F4E47554520574954482053494C5645522141205350454C4C204120444159204B4545505320414E204152524F5720415741592557485920424F54484552205749544820414C4C2054484F53452053494C4C59204B4559533F24574841542043414E4E4F54204245205345454E2043414E4E
	dc.b	'OT BE STOLEN$YOU TOO CAN HAVE THE STRENGTH OF TEN'	;4F542042452053544F4C454E24594F5520544F4F2043414E20484156452054484520535452454E475448204F462054454E
	dc.b	$1A	;1A
	dc.b	'ONE IN THE EYE FOR ARCHERS'	;4F4E4520494E205448452045594520464F522041524348455253
	dc.b	$1E	;1E
	dc.b	'NOW YOU SEE ME...NOW YOU DON''T%A FROZEN LIFE MAY WELL BE A SHORT ONE'	;4E4F5720594F5520534545204D452E2E2E4E4F5720594F5520444F4E275425412046524F5A454E204C494645204D41592057454C4C20424520412053484F5254204F4E45
	dc.b	$11	;11
	dc.b	'THE HAND OF MIDAS'	;5448452048414E44204F46204D49444153
	dc.b	$1D	;1D
	dc.b	'THEY WON''T KNOW WHAT HIT THEM'	;5448455920574F4E2754204B4E4F57205748415420484954205448454D
	dc.b	$17	;17
	dc.b	'A GENUINELY LIGHT SPELL"NEVERMORE WORRY ABOUT SPELLCASTERS'	;412047454E55494E454C59204C49474854205350454C4C224E455645524D4F524520574F5252592041424F5554205350454C4C43415354455253
	dc.b	$1C	;1C
	dc.b	'BOOSTS THE FLATTEST OF RINGS!NEVER AGAIN LOSE AT HIDE AND SEEK'	;424F4F5354532054484520464C415454455354204F462052494E4753214E4556455220414741494E204C4F5345204154204849444520414E44205345454B
	dc.b	$1D	;1D
	dc.b	'CURES EVERYTHING EXCEPT CRAMP%MAKES DEATH BUT A MINOR INCONVENIENCE#WHAT MAGIC MAKES, MAGIC CAN DESTROY'	;43555245532045564552595448494E4720455843455054204352414D50254D414B4553204445415448204255542041204D494E4F5220494E434F4E56454E49454E43452357484154204D41474943204D414B45532C204D414749432043414E2044455354524F59
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
	dc.b	'YOU''LL NEVER WALK ALONE NONE SHALL PASS THIS FIERY BLAST#FOR THOSE WHO THINK THEY LOVE WALLS!A GUARANTEED ALL-IN-ONE INSURA'	;594F55274C4C204E455645522057414C4B20414C4F4E45204E4F4E45205348414C4C2050415353205448495320464945525920424C41535423464F522054484F53452057484F205448494E4B2054484559204C4F56452057414C4C5321412047554152414E5445454420414C4C2D494E2D4F4E4520494E53555241
	dc.b	'NCE'	;4E4345
	dc.b	$1E	;1E
	dc.b	'TELEPORT YOUR WAY INTO TROUBLE'	;54454C45504F525420594F55522057415920494E544F2054524F55424C45
	dc.b	$16	;16
	dc.b	'THE INSTANT SUPER-HERO'	;54484520494E5354414E542053555045522D4845524F
	dc.b	$1C	;1C
	dc.b	'A BALL OF FRIENDLY FIERY FUN'	;412042414C4C204F4620465249454E444C592046494552592046554E
	dc.b	$15	;15
	dc.b	'DISPELL AT A DISTANCE'	;44495350454C4C20415420412044495354414E4345
	dc.b	$1F	;1F
	dc.b	'A SECOND CHANCE FOR THE WEALTHY'	;41205345434F4E44204348414E434520464F5220544845205745414C544859
	dc.b	$1E	;1E
	dc.b	'UNLEASH THE FULL FURY OF CHAOS'	;554E4C45415348205448452046554C4C2046555259204F46204348414F53
	dc.b	$1D	;1D
	dc.b	'A MAELSTROM OF TOTAL DISASTER',0	;41204D41454C5354524F4D204F4620544F54414C20444953415354455200
adrEA017952:	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$19	;19
	dc.b	$00	;00
	dc.b	$19	;19
	dc.b	$00	;00
	dc.b	$19	;19
	dc.b	$00	;00
	dc.b	$19	;19
	dc.b	$00	;00
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T',0	;5400
	dc.b	'T'	;54
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
_GFX_MainWalls:
	INCBIN bext-gfx/MainWalls

_GFX_WoodWall:
	INCBIN bext-gfx/WoodWall

_GFX_WoodDoors:
	INCBIN bext-gfx/WoodDoors

_GFX_Shelf:
	INCBIN bext-gfx/Shelf

_GFX_Sign:
	INCBIN bext-gfx/Sign

_GFX_SignOverlay:
	INCBIN bext-gfx/SignOverlay

_GFX_Switches:
	INCBIN bext-gfx/Switches

_GFX_Slots:
	INCBIN bext-gfx/Slots

_GFX_Bed:
	INCBIN bext-gfx/Bed

_GFX_Pillar:	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$F9FF	;F9FF
	dc.w	$21FF	;21FF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$A6FF	;A6FF
	dc.w	$78FF	;78FF
	dc.w	$00FF	;00FF
	dc.w	$00FF	;00FF
	dc.w	$DAFF	;DAFF
	dc.w	$CCFF	;CCFF
	dc.w	$20FF	;20FF
	dc.w	$00FF	;00FF
	dc.w	$65FF	;65FF
	dc.w	$87FF	;87FF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$ABFF	;ABFF
	dc.w	$D3FF	;D3FF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$2BFF	;2BFF
	dc.w	$33FF	;33FF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$C7FF	;C7FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$5BFF	;5BFF
	dc.w	$ABFF	;ABFF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$6BFF	;6BFF
	dc.w	$D3FF	;D3FF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$FBFF	;FBFF
	dc.w	$EBFF	;EBFF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$4BFF	;4BFF
	dc.w	$B3FF	;B3FF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$C7FF	;C7FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$3BFF	;3BFF
	dc.w	$33FF	;33FF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$EBFF	;EBFF
	dc.w	$D3FF	;D3FF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$33FF	;33FF
	dc.w	$C3FF	;C3FF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$CCFF	;CCFF
	dc.w	$0EFF	;0EFF
	dc.w	$00FF	;00FF
	dc.w	$00FF	;00FF
	dc.w	$D2FF	;D2FF
	dc.w	$CCFF	;CCFF
	dc.w	$20FF	;20FF
	dc.w	$00FF	;00FF
	dc.w	$AEFF	;AEFF
	dc.w	$70FF	;70FF
	dc.w	$00FF	;00FF
	dc.w	$00FF	;00FF
	dc.w	$B9FF	;B9FF
	dc.w	$41FF	;41FF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$F7FF	;F7FF
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$E9FF	;E9FF
	dc.w	$31FF	;31FF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$F5BB	;F5BB
	dc.w	$F246	;F246
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$45FF	;45FF
	dc.w	$D9FF	;D9FF
	dc.w	$21FF	;21FF
	dc.w	$01FF	;01FF
	dc.w	$F7CE	;F7CE
	dc.w	$F2FF	;F2FF
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$85FF	;85FF
	dc.w	$89FF	;89FF
	dc.w	$71FF	;71FF
	dc.w	$01FF	;01FF
	dc.w	$FEFF	;FEFF
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$69FF	;69FF
	dc.w	$8DFF	;8DFF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$FEFB	;FEFB
	dc.w	$FE5F	;FE5F
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$57FF	;57FF
	dc.w	$67FF	;67FF
	dc.w	$87FF	;87FF
	dc.w	$07FF	;07FF
	dc.w	$FF00	;FF00
	dc.w	$FF00	;FF00
	dc.w	$FF00	;FF00
	dc.w	$FF00	;FF00
	dc.w	$37FF	;37FF
	dc.w	$27FF	;27FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$FEEA	;FEEA
	dc.w	$FE15	;FE15
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$8FFF	;8FFF
	dc.w	$CFFF	;CFFF
	dc.w	$0FFF	;0FFF
	dc.w	$0FFF	;0FFF
	dc.w	$FEAC	;FEAC
	dc.w	$FE57	;FE57
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$57FF	;57FF
	dc.w	$27FF	;27FF
	dc.w	$87FF	;87FF
	dc.w	$07FF	;07FF
	dc.w	$FEE3	;FEE3
	dc.w	$FE1D	;FE1D
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$F7FF	;F7FF
	dc.w	$87FF	;87FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$FF00	;FF00
	dc.w	$FF00	;FF00
	dc.w	$FF00	;FF00
	dc.w	$FF00	;FF00
	dc.w	$0FFF	;0FFF
	dc.w	$0FFF	;0FFF
	dc.w	$0FFF	;0FFF
	dc.w	$0FFF	;0FFF
	dc.w	$FEF6	;FEF6
	dc.w	$FE5F	;FE5F
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$B7FF	;B7FF
	dc.w	$E7FF	;E7FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$FE9A	;FE9A
	dc.w	$FE65	;FE65
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$97FF	;97FF
	dc.w	$E7FF	;E7FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$FEEE	;FEEE
	dc.w	$FE11	;FE11
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$6FFF	;6FFF
	dc.w	$0FFF	;0FFF
	dc.w	$8FFF	;8FFF
	dc.w	$0FFF	;0FFF
	dc.w	$FF00	;FF00
	dc.w	$FF00	;FF00
	dc.w	$FF00	;FF00
	dc.w	$FF00	;FF00
	dc.w	$17FF	;17FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$FEEE	;FEEE
	dc.w	$FE7F	;FE7F
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$77FF	;77FF
	dc.w	$67FF	;67FF
	dc.w	$87FF	;87FF
	dc.w	$07FF	;07FF
	dc.w	$FEB9	;FEB9
	dc.w	$FE47	;FE47
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$17FF	;17FF
	dc.w	$67FF	;67FF
	dc.w	$87FF	;87FF
	dc.w	$07FF	;07FF
	dc.w	$FEFF	;FEFF
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$69FF	;69FF
	dc.w	$8DFF	;8DFF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$F77A	;F77A
	dc.w	$F1DF	;F1DF
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$DDFF	;DDFF
	dc.w	$D1FF	;D1FF
	dc.w	$21FF	;21FF
	dc.w	$01FF	;01FF
	dc.w	$F4F6	;F4F6
	dc.w	$F30F	;F30F
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$4DFF	;4DFF
	dc.w	$51FF	;51FF
	dc.w	$A1FF	;A1FF
	dc.w	$01FF	;01FF
	dc.w	$F7FF	;F7FF
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$33FF	;33FF
	dc.w	$E3FF	;E3FF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$0FFF	;0FFF
	dc.w	$0FFF	;0FFF
	dc.w	$0FFF	;0FFF
	dc.w	$0FFF	;0FFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$0007	;0007
	dc.w	$0007	;0007
	dc.w	$0007	;0007
	dc.w	$0007	;0007
	dc.w	$FEFE	;FEFE
	dc.w	$FE01	;FE01
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$F689	;F689
	dc.w	$09E1	;09E1
	dc.w	$0011	;0011
	dc.w	$0001	;0001
	dc.w	$FEB5	;FEB5
	dc.w	$FE4B	;FE4B
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$8B6E	;8B6E
	dc.w	$3104	;3104
	dc.w	$4490	;4490
	dc.w	$0000	;0000
	dc.w	$FE10	;FE10
	dc.w	$FE10	;FE10
	dc.w	$FEEF	;FEEF
	dc.w	$FE00	;FE00
	dc.w	$8800	;8800
	dc.w	$8816	;8816
	dc.w	$77F8	;77F8
	dc.w	$0010	;0010
	dc.w	$FF2F	;FF2F
	dc.w	$FF10	;FF10
	dc.w	$FF00	;FF00
	dc.w	$FF00	;FF00
	dc.w	$FFF8	;FFF8
	dc.w	$001A	;001A
	dc.w	$0004	;0004
	dc.w	$0000	;0000
	dc.w	$FFCE	;FFCE
	dc.w	$FFC1	;FFC1
	dc.w	$FFC0	;FFC0
	dc.w	$FFC0	;FFC0
	dc.w	$A2D7	;A2D7
	dc.w	$5CA7	;5CA7
	dc.w	$0107	;0107
	dc.w	$0007	;0007
	dc.w	$FFEB	;FFEB
	dc.w	$FFE4	;FFE4
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$7EB7	;7EB7
	dc.w	$AC77	;AC77
	dc.w	$0107	;0107
	dc.w	$0007	;0007
	dc.w	$FFE7	;FFE7
	dc.w	$FFE7	;FFE7
	dc.w	$FFE8	;FFE8
	dc.w	$FFE0	;FFE0
	dc.w	$4427	;4427
	dc.w	$4537	;4537
	dc.w	$BBC7	;BBC7
	dc.w	$0107	;0107
	dc.w	$FFF0	;FFF0
	dc.w	$FFF0	;FFF0
	dc.w	$FFF0	;FFF0
	dc.w	$FFF0	;FFF0
	dc.w	$0007	;0007
	dc.w	$0017	;0017
	dc.w	$0027	;0027
	dc.w	$0007	;0007
	dc.w	$FFED	;FFED
	dc.w	$FFE2	;FFE2
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$EACF	;EACF
	dc.w	$964F	;964F
	dc.w	$010F	;010F
	dc.w	$000F	;000F
	dc.w	$FFEB	;FFEB
	dc.w	$FFE5	;FFE5
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$B217	;B217
	dc.w	$78E7	;78E7
	dc.w	$0507	;0507
	dc.w	$0007	;0007
	dc.w	$FFEE	;FFEE
	dc.w	$FFE1	;FFE1
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$B6F7	;B6F7
	dc.w	$7F17	;7F17
	dc.w	$0107	;0107
	dc.w	$0107	;0107
	dc.w	$FFEC	;FFEC
	dc.w	$FFE3	;FFE3
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$CC37	;CC37
	dc.w	$3697	;3697
	dc.w	$0147	;0147
	dc.w	$0007	;0007
	dc.w	$FFEA	;FFEA
	dc.w	$FFE5	;FFE5
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$6AB7	;6AB7
	dc.w	$DCE7	;DCE7
	dc.w	$0107	;0107
	dc.w	$0007	;0007
	dc.w	$FFF0	;FFF0
	dc.w	$FFF0	;FFF0
	dc.w	$FFF0	;FFF0
	dc.w	$FFF0	;FFF0
	dc.w	$000F	;000F
	dc.w	$000F	;000F
	dc.w	$000F	;000F
	dc.w	$000F	;000F
	dc.w	$FFEE	;FFEE
	dc.w	$FFEE	;FFEE
	dc.w	$FFE1	;FFE1
	dc.w	$FFE0	;FFE0
	dc.w	$2007	;2007
	dc.w	$2007	;2007
	dc.w	$DFF7	;DFF7
	dc.w	$0007	;0007
	dc.w	$FFE8	;FFE8
	dc.w	$FFE7	;FFE7
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$2CF7	;2CF7
	dc.w	$F227	;F227
	dc.w	$0107	;0107
	dc.w	$0007	;0007
	dc.w	$FFEB	;FFEB
	dc.w	$FFE4	;FFE4
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$FC37	;FC37
	dc.w	$AB77	;AB77
	dc.w	$0187	;0187
	dc.w	$0107	;0107
	dc.w	$FFEE	;FFEE
	dc.w	$FFE3	;FFE3
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$1FB7	;1FB7
	dc.w	$F5D7	;F5D7
	dc.w	$0007	;0007
	dc.w	$0007	;0007
	dc.w	$FFE8	;FFE8
	dc.w	$FFE7	;FFE7
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$72CF	;72CF
	dc.w	$DC0F	;DC0F
	dc.w	$010F	;010F
	dc.w	$000F	;000F
	dc.w	$FFF0	;FFF0
	dc.w	$FFF0	;FFF0
	dc.w	$FFF0	;FFF0
	dc.w	$FFF0	;FFF0
	dc.w	$0007	;0007
	dc.w	$0007	;0007
	dc.w	$0037	;0037
	dc.w	$0007	;0007
	dc.w	$FFE9	;FFE9
	dc.w	$FFE9	;FFE9
	dc.w	$FFE6	;FFE6
	dc.w	$FFE0	;FFE0
	dc.w	$1037	;1037
	dc.w	$1007	;1007
	dc.w	$EFC7	;EFC7
	dc.w	$0007	;0007
	dc.w	$FFED	;FFED
	dc.w	$FFE2	;FFE2
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$B697	;B697
	dc.w	$4AF7	;4AF7
	dc.w	$0107	;0107
	dc.w	$0007	;0007
	dc.w	$FFCD	;FFCD
	dc.w	$FFC2	;FFC2
	dc.w	$FFC0	;FFC0
	dc.w	$FFC0	;FFC0
	dc.w	$A4B0	;A4B0
	dc.w	$5E4E	;5E4E
	dc.w	$0100	;0100
	dc.w	$0000	;0000
	dc.w	$FF2F	;FF2F
	dc.w	$FF10	;FF10
	dc.w	$FF00	;FF00
	dc.w	$FF00	;FF00
	dc.w	$FFC2	;FFC2
	dc.w	$0030	;0030
	dc.w	$000C	;000C
	dc.w	$0000	;0000
	dc.w	$FE48	;FE48
	dc.w	$FE48	;FE48
	dc.w	$FEB7	;FEB7
	dc.w	$FE00	;FE00
	dc.w	$8A0E	;8A0E
	dc.w	$8A1E	;8A1E
	dc.w	$75F0	;75F0
	dc.w	$0010	;0010
	dc.w	$FEC5	;FEC5
	dc.w	$FE3A	;FE3A
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$DC48	;DC48
	dc.w	$376C	;376C
	dc.w	$0090	;0090
	dc.w	$0000	;0000
	dc.w	$FEF6	;FEF6
	dc.w	$FE09	;FE09
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$7B63	;7B63
	dc.w	$85E3	;85E3
	dc.w	$0013	;0013
	dc.w	$0003	;0003
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$000F	;000F
	dc.w	$000F	;000F
	dc.w	$000F	;000F
	dc.w	$000F	;000F
	dc.w	$0027	;0027
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$FF40	;FF40
	dc.w	$00FF	;00FF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3FFF	;3FFF
	dc.w	$CFFF	;CFFF
	dc.w	$4FFF	;4FFF
	dc.w	$4FFF	;4FFF
	dc.w	$4268	;4268
	dc.w	$FF6B	;FF6B
	dc.w	$0094	;0094
	dc.w	$0000	;0000
	dc.w	$2FFF	;2FFF
	dc.w	$B1FF	;B1FF
	dc.w	$41FF	;41FF
	dc.w	$01FF	;01FF
	dc.w	$B2A3	;B2A3
	dc.w	$4FFB	;4FFB
	dc.w	$0004	;0004
	dc.w	$0000	;0000
	dc.w	$21FF	;21FF
	dc.w	$EEFF	;EEFF
	dc.w	$50FF	;50FF
	dc.w	$40FF	;40FF
	dc.w	$4A04	;4A04
	dc.w	$FFCC	;FFCC
	dc.w	$0033	;0033
	dc.w	$0000	;0000
	dc.w	$A1FF	;A1FF
	dc.w	$FCFF	;FCFF
	dc.w	$52FF	;52FF
	dc.w	$50FF	;50FF
	dc.w	$0000	;0000
	dc.w	$4C8B	;4C8B
	dc.w	$FFFF	;FFFF
	dc.w	$4C8B	;4C8B
	dc.w	$31FF	;31FF
	dc.w	$F6FF	;F6FF
	dc.w	$C8FF	;C8FF
	dc.w	$C0FF	;C0FF
	dc.w	$01FF	;01FF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$81FF	;81FF
	dc.w	$FCFF	;FCFF
	dc.w	$3EFF	;3EFF
	dc.w	$3CFF	;3CFF
	dc.w	$F700	;F700
	dc.w	$0FFF	;0FFF
	dc.w	$0004	;0004
	dc.w	$0004	;0004
	dc.w	$FFFF	;FFFF
	dc.w	$00FF	;00FF
	dc.w	$00FF	;00FF
	dc.w	$00FF	;00FF
	dc.w	$9AA9	;9AA9
	dc.w	$7FBF	;7FBF
	dc.w	$0054	;0054
	dc.w	$0014	;0014
	dc.w	$BFFF	;BFFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$63E8	;63E8
	dc.w	$FFFF	;FFFF
	dc.w	$0004	;0004
	dc.w	$0004	;0004
	dc.w	$3FFF	;3FFF
	dc.w	$5FFF	;5FFF
	dc.w	$9FFF	;9FFF
	dc.w	$1FFF	;1FFF
	dc.w	$0000	;0000
	dc.w	$52BF	;52BF
	dc.w	$FFFF	;FFFF
	dc.w	$52BF	;52BF
	dc.w	$3FFF	;3FFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$0FFF	;0FFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3FFF	;3FFF
	dc.w	$DFFF	;DFFF
	dc.w	$DFFF	;DFFF
	dc.w	$DFFF	;DFFF
	dc.w	$D402	;D402
	dc.w	$FFFF	;FFFF
	dc.w	$0004	;0004
	dc.w	$0004	;0004
	dc.w	$FFFF	;FFFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$4321	;4321
	dc.w	$FFAF	;FFAF
	dc.w	$0054	;0054
	dc.w	$0004	;0004
	dc.w	$7FFF	;7FFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$0F52	;0F52
	dc.w	$FFFB	;FFFB
	dc.w	$000D	;000D
	dc.w	$0009	;0009
	dc.w	$BFFF	;BFFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$7E09	;7E09
	dc.w	$FE5F	;FE5F
	dc.w	$01A4	;01A4
	dc.w	$0004	;0004
	dc.w	$7FFF	;7FFF
	dc.w	$5FFF	;5FFF
	dc.w	$9FFF	;9FFF
	dc.w	$1FFF	;1FFF
	dc.w	$16E0	;16E0
	dc.w	$EFED	;EFED
	dc.w	$001E	;001E
	dc.w	$000C	;000C
	dc.w	$3FFF	;3FFF
	dc.w	$1FFF	;1FFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$E638	;E638
	dc.w	$FFFF	;FFFF
	dc.w	$0004	;0004
	dc.w	$0004	;0004
	dc.w	$3FFF	;3FFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$0000	;0000
	dc.w	$477F	;477F
	dc.w	$FFFF	;FFFF
	dc.w	$477F	;477F
	dc.w	$3FFF	;3FFF
	dc.w	$DFFF	;DFFF
	dc.w	$DFFF	;DFFF
	dc.w	$DFFF	;DFFF
	dc.w	$3C9A	;3C9A
	dc.w	$EFDF	;EFDF
	dc.w	$0024	;0024
	dc.w	$0004	;0004
	dc.w	$7FFF	;7FFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$5578	;5578
	dc.w	$AFFA	;AFFA
	dc.w	$0007	;0007
	dc.w	$0002	;0002
	dc.w	$7FFF	;7FFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$9AA1	;9AA1
	dc.w	$FEE7	;FEE7
	dc.w	$011C	;011C
	dc.w	$0004	;0004
	dc.w	$FFFF	;FFFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$44E9	;44E9
	dc.w	$FFFF	;FFFF
	dc.w	$0004	;0004
	dc.w	$0004	;0004
	dc.w	$3FFF	;3FFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$E080	;E080
	dc.w	$1FF7	;1FF7
	dc.w	$000C	;000C
	dc.w	$0004	;0004
	dc.w	$FFFF	;FFFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$0FFF	;0FFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3FFF	;3FFF
	dc.w	$DFFF	;DFFF
	dc.w	$DFFF	;DFFF
	dc.w	$DFFF	;DFFF
	dc.w	$0000	;0000
	dc.w	$593F	;593F
	dc.w	$FFFF	;FFFF
	dc.w	$593F	;593F
	dc.w	$3FFF	;3FFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$893A	;893A
	dc.w	$FFBF	;FFBF
	dc.w	$0044	;0044
	dc.w	$0004	;0004
	dc.w	$3FFF	;3FFF
	dc.w	$9FFF	;9FFF
	dc.w	$5FFF	;5FFF
	dc.w	$1FFF	;1FFF
	dc.w	$9FC3	;9FC3
	dc.w	$FFE7	;FFE7
	dc.w	$001C	;001C
	dc.w	$0004	;0004
	dc.w	$BFFF	;BFFF
	dc.w	$9FFF	;9FFF
	dc.w	$5FFF	;5FFF
	dc.w	$1FFF	;1FFF
	dc.w	$B291	;B291
	dc.w	$5FBF	;5FBF
	dc.w	$004C	;004C
	dc.w	$000C	;000C
	dc.w	$3FFF	;3FFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$F020	;F020
	dc.w	$0FFF	;0FFF
	dc.w	$0004	;0004
	dc.w	$0004	;0004
	dc.w	$FFFF	;FFFF
	dc.w	$00FF	;00FF
	dc.w	$00FF	;00FF
	dc.w	$00FF	;00FF
	dc.w	$01FF	;01FF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$21FF	;21FF
	dc.w	$EEFF	;EEFF
	dc.w	$16FF	;16FF
	dc.w	$06FF	;06FF
	dc.w	$9040	;9040
	dc.w	$6FFF	;6FFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$A5FF	;A5FF
	dc.w	$FEFF	;FEFF
	dc.w	$18FF	;18FF
	dc.w	$18FF	;18FF
	dc.w	$0000	;0000
	dc.w	$3376	;3376
	dc.w	$FFFF	;FFFF
	dc.w	$3376	;3376
	dc.w	$17FF	;17FF
	dc.w	$FEFF	;FEFF
	dc.w	$E0FF	;E0FF
	dc.w	$E0FF	;E0FF
	dc.w	$0531	;0531
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$2DFF	;2DFF
	dc.w	$FEFF	;FEFF
	dc.w	$50FF	;50FF
	dc.w	$50FF	;50FF
	dc.w	$8D10	;8D10
	dc.w	$73D5	;73D5
	dc.w	$002A	;002A
	dc.w	$0000	;0000
	dc.w	$83FF	;83FF
	dc.w	$FDFF	;FDFF
	dc.w	$41FF	;41FF
	dc.w	$41FF	;41FF
	dc.w	$7301	;7301
	dc.w	$BDE5	;BDE5
	dc.w	$001A	;001A
	dc.w	$0000	;0000
	dc.w	$0FFF	;0FFF
	dc.w	$B3FF	;B3FF
	dc.w	$43FF	;43FF
	dc.w	$03FF	;03FF
	dc.w	$FF00	;FF00
	dc.w	$00FF	;00FF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3FFF	;3FFF
	dc.w	$CFFF	;CFFF
	dc.w	$4FFF	;4FFF
	dc.w	$4FFF	;4FFF
	dc.w	$0027	;0027
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$FFFF	;FFFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$C7FF	;C7FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$C7FF	;C7FF
	dc.w	$F8FF	;F8FF
	dc.w	$00FF	;00FF
	dc.w	$00FF	;00FF
	dc.w	$58FF	;58FF
	dc.w	$5B3F	;5B3F
	dc.w	$A43F	;A43F
	dc.w	$003F	;003F
	dc.w	$0F3F	;0F3F
	dc.w	$8FCF	;8FCF
	dc.w	$F00F	;F00F
	dc.w	$800F	;800F
	dc.w	$B9DF	;B9DF
	dc.w	$B9EF	;B9EF
	dc.w	$460F	;460F
	dc.w	$000F	;000F
	dc.w	$949F	;949F
	dc.w	$F4AF	;F4AF
	dc.w	$6B4F	;6B4F
	dc.w	$600F	;600F
	dc.w	$365F	;365F
	dc.w	$FF6F	;FF6F
	dc.w	$C98F	;C98F
	dc.w	$C90F	;C90F
	dc.w	$439F	;439F
	dc.w	$FFAF	;FFAF
	dc.w	$3C4F	;3C4F
	dc.w	$3C0F	;3C0F
	dc.w	$843F	;843F
	dc.w	$6FEF	;6FEF
	dc.w	$13CF	;13CF
	dc.w	$03CF	;03CF
	dc.w	$FFFF	;FFFF
	dc.w	$800F	;800F
	dc.w	$000F	;000F
	dc.w	$000F	;000F
	dc.w	$7FFF	;7FFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$7FFF	;7FFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$7FFF	;7FFF
	dc.w	$5FFF	;5FFF
	dc.w	$9FFF	;9FFF
	dc.w	$1FFF	;1FFF
	dc.w	$FFFF	;FFFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$BFFF	;BFFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$3FFF	;3FFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$3FFF	;3FFF
	dc.w	$DFFF	;DFFF
	dc.w	$DFFF	;DFFF
	dc.w	$DFFF	;DFFF
	dc.w	$FFFF	;FFFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$5FFF	;5FFF
	dc.w	$9FFF	;9FFF
	dc.w	$1FFF	;1FFF
	dc.w	$7FFF	;7FFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$3FFF	;3FFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$FFFF	;FFFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$BFFF	;BFFF
	dc.w	$9FFF	;9FFF
	dc.w	$5FFF	;5FFF
	dc.w	$1FFF	;1FFF
	dc.w	$3FFF	;3FFF
	dc.w	$1FFF	;1FFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$3FFF	;3FFF
	dc.w	$9FFF	;9FFF
	dc.w	$5FFF	;5FFF
	dc.w	$1FFF	;1FFF
	dc.w	$3FFF	;3FFF
	dc.w	$9FFF	;9FFF
	dc.w	$5FFF	;5FFF
	dc.w	$1FFF	;1FFF
	dc.w	$FFFF	;FFFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$DFFF	;DFFF
	dc.w	$DFFF	;DFFF
	dc.w	$DFFF	;DFFF
	dc.w	$3FFF	;3FFF
	dc.w	$5FFF	;5FFF
	dc.w	$9FFF	;9FFF
	dc.w	$1FFF	;1FFF
	dc.w	$3FFF	;3FFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$7FFF	;7FFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$3FFF	;3FFF
	dc.w	$1FFF	;1FFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$3FFF	;3FFF
	dc.w	$1FFF	;1FFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$7FFF	;7FFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$3FFF	;3FFF
	dc.w	$9FFF	;9FFF
	dc.w	$5FFF	;5FFF
	dc.w	$1FFF	;1FFF
	dc.w	$FFFF	;FFFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$DFFF	;DFFF
	dc.w	$DFFF	;DFFF
	dc.w	$DFFF	;DFFF
	dc.w	$BFFF	;BFFF
	dc.w	$9FFF	;9FFF
	dc.w	$5FFF	;5FFF
	dc.w	$1FFF	;1FFF
	dc.w	$7FFF	;7FFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$FFFF	;FFFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$3FFF	;3FFF
	dc.w	$1FFF	;1FFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$3FFF	;3FFF
	dc.w	$5FFF	;5FFF
	dc.w	$9FFF	;9FFF
	dc.w	$1FFF	;1FFF
	dc.w	$3FFF	;3FFF
	dc.w	$C00F	;C00F
	dc.w	$000F	;000F
	dc.w	$000F	;000F
	dc.w	$2C5F	;2C5F
	dc.w	$5DEF	;5DEF
	dc.w	$838F	;838F
	dc.w	$018F	;018F
	dc.w	$E0DF	;E0DF
	dc.w	$3EEF	;3EEF
	dc.w	$0F0F	;0F0F
	dc.w	$0E0F	;0E0F
	dc.w	$4D1F	;4D1F
	dc.w	$FD2F	;FD2F
	dc.w	$32CF	;32CF
	dc.w	$300F	;300F
	dc.w	$031F	;031F
	dc.w	$C32F	;C32F
	dc.w	$FCCF	;FCCF
	dc.w	$C00F	;C00F
	dc.w	$923F	;923F
	dc.w	$BADF	;BADF
	dc.w	$6D1F	;6D1F
	dc.w	$281F	;281F
	dc.w	$CCFF	;CCFF
	dc.w	$CF3F	;CF3F
	dc.w	$303F	;303F
	dc.w	$003F	;003F
	dc.w	$1BFF	;1BFF
	dc.w	$9CFF	;9CFF
	dc.w	$E0FF	;E0FF
	dc.w	$80FF	;80FF
	dc.w	$67FF	;67FF
	dc.w	$7BFF	;7BFF
	dc.w	$83FF	;83FF
	dc.w	$03FF	;03FF
	dc.w	$DFFF	;DFFF
	dc.w	$E7FF	;E7FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$7FFF	;7FFF
	dc.w	$9FFF	;9FFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$FFFF	;FFFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$007F	;007F
	dc.w	$007F	;007F
	dc.w	$007F	;007F
	dc.w	$007F	;007F
	dc.w	$FEFF	;FEFF
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$FF7F	;FF7F
	dc.w	$007F	;007F
	dc.w	$007F	;007F
	dc.w	$007F	;007F
	dc.w	$FE9A	;FE9A
	dc.w	$FE6D	;FE6D
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$D57F	;D57F
	dc.w	$6E7F	;6E7F
	dc.w	$007F	;007F
	dc.w	$007F	;007F
	dc.w	$FED6	;FED6
	dc.w	$FEDE	;FEDE
	dc.w	$FE21	;FE21
	dc.w	$FE00	;FE00
	dc.w	$6B7F	;6B7F
	dc.w	$6F7F	;6F7F
	dc.w	$907F	;907F
	dc.w	$007F	;007F
	dc.w	$FFDF	;FFDF
	dc.w	$FF80	;FF80
	dc.w	$FF80	;FF80
	dc.w	$FF80	;FF80
	dc.w	$6BFF	;6BFF
	dc.w	$91FF	;91FF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$FFDB	;FFDB
	dc.w	$FFDB	;FFDB
	dc.w	$FFC4	;FFC4
	dc.w	$FFC0	;FFC0
	dc.w	$BBFF	;BBFF
	dc.w	$BBFF	;BBFF
	dc.w	$43FF	;43FF
	dc.w	$03FF	;03FF
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$FFD4	;FFD4
	dc.w	$FFCB	;FFCB
	dc.w	$FFC0	;FFC0
	dc.w	$FFC0	;FFC0
	dc.w	$ABFF	;ABFF
	dc.w	$73FF	;73FF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$FFDE	;FFDE
	dc.w	$FFCB	;FFCB
	dc.w	$FFC0	;FFC0
	dc.w	$FFC0	;FFC0
	dc.w	$EBFF	;EBFF
	dc.w	$B3FF	;B3FF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$FFDA	;FFDA
	dc.w	$FFC7	;FFC7
	dc.w	$FFC0	;FFC0
	dc.w	$FFC0	;FFC0
	dc.w	$BBFF	;BBFF
	dc.w	$43FF	;43FF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$FFDC	;FFDC
	dc.w	$FFDD	;FFDD
	dc.w	$FFC2	;FFC2
	dc.w	$FFC0	;FFC0
	dc.w	$BBFF	;BBFF
	dc.w	$BBFF	;BBFF
	dc.w	$43FF	;43FF
	dc.w	$03FF	;03FF
	dc.w	$FFD7	;FFD7
	dc.w	$FFCD	;FFCD
	dc.w	$FFC0	;FFC0
	dc.w	$FFC0	;FFC0
	dc.w	$2BFF	;2BFF
	dc.w	$F3FF	;F3FF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$FFDA	;FFDA
	dc.w	$FFC5	;FFC5
	dc.w	$FFC0	;FFC0
	dc.w	$FFC0	;FFC0
	dc.w	$BBFF	;BBFF
	dc.w	$43FF	;43FF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$FFC9	;FFC9
	dc.w	$FFDD	;FFDD
	dc.w	$FFC2	;FFC2
	dc.w	$FFC0	;FFC0
	dc.w	$9BFF	;9BFF
	dc.w	$FBFF	;FBFF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$FFDE	;FFDE
	dc.w	$FFC5	;FFC5
	dc.w	$FFC0	;FFC0
	dc.w	$FFC0	;FFC0
	dc.w	$BBFF	;BBFF
	dc.w	$E3FF	;E3FF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$FFDB	;FFDB
	dc.w	$FF84	;FF84
	dc.w	$FF80	;FF80
	dc.w	$FF80	;FF80
	dc.w	$FBFF	;FBFF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$FEB7	;FEB7
	dc.w	$FEF7	;FEF7
	dc.w	$FE08	;FE08
	dc.w	$FE00	;FE00
	dc.w	$167F	;167F
	dc.w	$9F7F	;9F7F
	dc.w	$607F	;607F
	dc.w	$007F	;007F
	dc.w	$FEAD	;FEAD
	dc.w	$FE5E	;FE5E
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$F97F	;F97F
	dc.w	$4E7F	;4E7F
	dc.w	$007F	;007F
	dc.w	$007F	;007F
	dc.w	$FEFF	;FEFF
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$FF7F	;FF7F
	dc.w	$007F	;007F
	dc.w	$007F	;007F
	dc.w	$007F	;007F
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$007F	;007F
	dc.w	$007F	;007F
	dc.w	$007F	;007F
	dc.w	$007F	;007F
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$000F	;000F
	dc.w	$000F	;000F
	dc.w	$000F	;000F
	dc.w	$000F	;000F
	dc.w	$F66E	;F66E
	dc.w	$F3F4	;F3F4
	dc.w	$F001	;F001
	dc.w	$F000	;F000
	dc.w	$6AEF	;6AEF
	dc.w	$3FCF	;3FCF
	dc.w	$800F	;800F
	dc.w	$000F	;000F
	dc.w	$F6A0	;F6A0
	dc.w	$F3AD	;F3AD
	dc.w	$F052	;F052
	dc.w	$F000	;F000
	dc.w	$05EF	;05EF
	dc.w	$BCCF	;BCCF
	dc.w	$620F	;620F
	dc.w	$200F	;200F
	dc.w	$F000	;F000
	dc.w	$F12C	;F12C
	dc.w	$F7FF	;F7FF
	dc.w	$F12C	;F12C
	dc.w	$000F	;000F
	dc.w	$8E0F	;8E0F
	dc.w	$FFEF	;FFEF
	dc.w	$8E0F	;8E0F
	dc.w	$F9BF	;F9BF
	dc.w	$F800	;F800
	dc.w	$F800	;F800
	dc.w	$F800	;F800
	dc.w	$FF9F	;FF9F
	dc.w	$001F	;001F
	dc.w	$001F	;001F
	dc.w	$001F	;001F
	dc.w	$FE09	;FE09
	dc.w	$FE3F	;FE3F
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$287F	;287F
	dc.w	$FC7F	;FC7F
	dc.w	$007F	;007F
	dc.w	$007F	;007F
	dc.w	$FFB0	;FFB0
	dc.w	$FF92	;FF92
	dc.w	$FF8D	;FF8D
	dc.w	$FF80	;FF80
	dc.w	$A9FF	;A9FF
	dc.w	$ADFF	;ADFF
	dc.w	$51FF	;51FF
	dc.w	$01FF	;01FF
	dc.w	$FF80	;FF80
	dc.w	$FF80	;FF80
	dc.w	$FFBF	;FFBF
	dc.w	$FF80	;FF80
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$FDFF	;FDFF
	dc.w	$01FF	;01FF
	dc.w	$FFC0	;FFC0
	dc.w	$FFC0	;FFC0
	dc.w	$FFC0	;FFC0
	dc.w	$FFC0	;FFC0
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$FFB0	;FFB0
	dc.w	$FFAF	;FFAF
	dc.w	$FF80	;FF80
	dc.w	$FF80	;FF80
	dc.w	$25FF	;25FF
	dc.w	$DDFF	;DDFF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$FFA5	;FFA5
	dc.w	$FFAD	;FFAD
	dc.w	$FF92	;FF92
	dc.w	$FF80	;FF80
	dc.w	$A5FF	;A5FF
	dc.w	$BDFF	;BDFF
	dc.w	$41FF	;41FF
	dc.w	$01FF	;01FF
	dc.w	$FF8B	;FF8B
	dc.w	$FF9F	;FF9F
	dc.w	$FFA0	;FFA0
	dc.w	$FF80	;FF80
	dc.w	$B5FF	;B5FF
	dc.w	$A5FF	;A5FF
	dc.w	$49FF	;49FF
	dc.w	$01FF	;01FF
	dc.w	$FFB0	;FFB0
	dc.w	$FFB1	;FFB1
	dc.w	$FF8E	;FF8E
	dc.w	$FF80	;FF80
	dc.w	$45FF	;45FF
	dc.w	$DDFF	;DDFF
	dc.w	$21FF	;21FF
	dc.w	$01FF	;01FF
	dc.w	$FF96	;FF96
	dc.w	$FFBE	;FFBE
	dc.w	$FF81	;FF81
	dc.w	$FF80	;FF80
	dc.w	$59FF	;59FF
	dc.w	$6DFF	;6DFF
	dc.w	$81FF	;81FF
	dc.w	$01FF	;01FF
	dc.w	$FFC0	;FFC0
	dc.w	$FFC0	;FFC0
	dc.w	$FFC0	;FFC0
	dc.w	$FFC0	;FFC0
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$FF80	;FF80
	dc.w	$FF80	;FF80
	dc.w	$FFBF	;FFBF
	dc.w	$FF80	;FF80
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$FDFF	;FDFF
	dc.w	$01FF	;01FF
	dc.w	$FF96	;FF96
	dc.w	$FFB6	;FFB6
	dc.w	$FF89	;FF89
	dc.w	$FF80	;FF80
	dc.w	$09FF	;09FF
	dc.w	$5DFF	;5DFF
	dc.w	$A1FF	;A1FF
	dc.w	$01FF	;01FF
	dc.w	$FFA1	;FFA1
	dc.w	$FFB5	;FFB5
	dc.w	$FF8A	;FF8A
	dc.w	$FF80	;FF80
	dc.w	$EDFF	;EDFF
	dc.w	$FDFF	;FDFF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$FFB6	;FFB6
	dc.w	$FFBF	;FFBF
	dc.w	$FF80	;FF80
	dc.w	$FF80	;FF80
	dc.w	$B1FF	;B1FF
	dc.w	$FDFF	;FDFF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$FFBF	;FFBF
	dc.w	$FF80	;FF80
	dc.w	$FF80	;FF80
	dc.w	$FF80	;FF80
	dc.w	$FDFF	;FDFF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$FFC0	;FFC0
	dc.w	$FFC0	;FFC0
	dc.w	$FFC0	;FFC0
	dc.w	$FFC0	;FFC0
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$FF80	;FF80
	dc.w	$FF80	;FF80
	dc.w	$FFBF	;FFBF
	dc.w	$FF80	;FF80
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$FDFF	;FDFF
	dc.w	$01FF	;01FF
	dc.w	$FFB4	;FFB4
	dc.w	$FFA5	;FFA5
	dc.w	$FF8A	;FF8A
	dc.w	$FF80	;FF80
	dc.w	$CDFF	;CDFF
	dc.w	$D9FF	;D9FF
	dc.w	$21FF	;21FF
	dc.w	$01FF	;01FF
	dc.w	$FCBE	;FCBE
	dc.w	$FC3F	;FC3F
	dc.w	$FC00	;FC00
	dc.w	$FC00	;FC00
	dc.w	$413F	;413F
	dc.w	$7C3F	;7C3F
	dc.w	$803F	;803F
	dc.w	$003F	;003F
	dc.w	$F8BF	;F8BF
	dc.w	$FB80	;FB80
	dc.w	$F800	;F800
	dc.w	$F800	;F800
	dc.w	$FD1F	;FD1F
	dc.w	$01DF	;01DF
	dc.w	$001F	;001F
	dc.w	$001F	;001F
	dc.w	$F000	;F000
	dc.w	$F32C	;F32C
	dc.w	$F7FF	;F7FF
	dc.w	$F32C	;F32C
	dc.w	$000F	;000F
	dc.w	$4A8F	;4A8F
	dc.w	$FFEF	;FFEF
	dc.w	$4A8F	;4A8F
	dc.w	$F7AA	;F7AA
	dc.w	$F29A	;F29A
	dc.w	$F045	;F045
	dc.w	$F000	;F000
	dc.w	$5A6F	;5A6F
	dc.w	$FACF	;FACF
	dc.w	$850F	;850F
	dc.w	$800F	;800F
	dc.w	$F432	;F432
	dc.w	$F3F5	;F3F5
	dc.w	$F008	;F008
	dc.w	$F000	;F000
	dc.w	$4FEF	;4FEF
	dc.w	$D38F	;D38F
	dc.w	$200F	;200F
	dc.w	$000F	;000F
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$000F	;000F
	dc.w	$000F	;000F
	dc.w	$000F	;000F
	dc.w	$000F	;000F
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$8000	;8000
	dc.w	$7FFF	;7FFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$FFFE	;FFFE
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$BB27	;BB27
	dc.w	$7B6F	;7B6F
	dc.w	$0490	;0490
	dc.w	$0000	;0000
	dc.w	$6579	;6579
	dc.w	$677E	;677E
	dc.w	$9880	;9880
	dc.w	$0000	;0000
	dc.w	$B8ED	;B8ED
	dc.w	$7BFD	;7BFD
	dc.w	$0412	;0412
	dc.w	$0010	;0010
	dc.w	$0815	;0815
	dc.w	$AC16	;AC16
	dc.w	$D7E8	;D7E8
	dc.w	$8400	;8400
	dc.w	$A044	;A044
	dc.w	$71CC	;71CC
	dc.w	$0E33	;0E33
	dc.w	$0000	;0000
	dc.w	$0205	;0205
	dc.w	$977E	;977E
	dc.w	$7880	;7880
	dc.w	$1000	;1000
	dc.w	$8000	;8000
	dc.w	$7E7A	;7E7A
	dc.w	$7FFF	;7FFF
	dc.w	$7E7A	;7E7A
	dc.w	$0001	;0001
	dc.w	$F77E	;F77E
	dc.w	$FFFE	;FFFE
	dc.w	$F77E	;F77E
	dc.w	$F1FF	;F1FF
	dc.w	$9600	;9600
	dc.w	$8800	;8800
	dc.w	$8000	;8000
	dc.w	$FFF7	;FFF7
	dc.w	$0071	;0071
	dc.w	$0009	;0009
	dc.w	$0001	;0001
	dc.w	$FFA1	;FFA1
	dc.w	$E0E5	;E0E5
	dc.w	$E01A	;E01A
	dc.w	$E000	;E000
	dc.w	$4EFF	;4EFF
	dc.w	$DE07	;DE07
	dc.w	$2107	;2107
	dc.w	$0007	;0007
	dc.w	$FF96	;FF96
	dc.w	$FEFE	;FEFE
	dc.w	$FE09	;FE09
	dc.w	$FE08	;FE08
	dc.w	$4EFF	;4EFF
	dc.w	$6F7F	;6F7F
	dc.w	$B07F	;B07F
	dc.w	$207F	;207F
	dc.w	$FF86	;FF86
	dc.w	$FEA7	;FEA7
	dc.w	$FE58	;FE58
	dc.w	$FE00	;FE00
	dc.w	$C5FF	;C5FF
	dc.w	$CD7F	;CD7F
	dc.w	$327F	;327F
	dc.w	$007F	;007F
	dc.w	$FF00	;FF00
	dc.w	$FEFD	;FEFD
	dc.w	$FEFF	;FEFF
	dc.w	$FEFD	;FEFD
	dc.w	$00FF	;00FF
	dc.w	$F77F	;F77F
	dc.w	$FF7F	;FF7F
	dc.w	$F77F	;F77F
	dc.w	$FFFF	;FFFF
	dc.w	$FF00	;FF00
	dc.w	$FF00	;FF00
	dc.w	$FF00	;FF00
	dc.w	$FFFF	;FFFF
	dc.w	$00FF	;00FF
	dc.w	$00FF	;00FF
	dc.w	$00FF	;00FF
	dc.w	$FF0E	;FF0E
	dc.w	$FE7E	;FE7E
	dc.w	$FE81	;FE81
	dc.w	$FE00	;FE00
	dc.w	$56FF	;56FF
	dc.w	$FE7F	;FE7F
	dc.w	$017F	;017F
	dc.w	$007F	;007F
	dc.w	$FF88	;FF88
	dc.w	$FEFC	;FEFC
	dc.w	$FE03	;FE03
	dc.w	$FE00	;FE00
	dc.w	$14FF	;14FF
	dc.w	$B67F	;B67F
	dc.w	$497F	;497F
	dc.w	$007F	;007F
	dc.w	$FF40	;FF40
	dc.w	$FECE	;FECE
	dc.w	$FE39	;FE39
	dc.w	$FE08	;FE08
	dc.w	$0AFF	;0AFF
	dc.w	$6F7F	;6F7F
	dc.w	$B07F	;B07F
	dc.w	$207F	;207F
	dc.w	$FF6C	;FF6C
	dc.w	$FEEE	;FEEE
	dc.w	$FE13	;FE13
	dc.w	$FE02	;FE02
	dc.w	$ECFF	;ECFF
	dc.w	$FE7F	;FE7F
	dc.w	$117F	;117F
	dc.w	$107F	;107F
	dc.w	$FF0B	;FF0B
	dc.w	$FE5B	;FE5B
	dc.w	$FEA4	;FEA4
	dc.w	$FE00	;FE00
	dc.w	$88FF	;88FF
	dc.w	$ED7F	;ED7F
	dc.w	$127F	;127F
	dc.w	$007F	;007F
	dc.w	$FFE8	;FFE8
	dc.w	$FEFF	;FEFF
	dc.w	$FE02	;FE02
	dc.w	$FE02	;FE02
	dc.w	$82FF	;82FF
	dc.w	$A67F	;A67F
	dc.w	$597F	;597F
	dc.w	$007F	;007F
	dc.w	$FFFF	;FFFF
	dc.w	$FF00	;FF00
	dc.w	$FF00	;FF00
	dc.w	$FF00	;FF00
	dc.w	$FFFF	;FFFF
	dc.w	$00FF	;00FF
	dc.w	$00FF	;00FF
	dc.w	$00FF	;00FF
	dc.w	$FF00	;FF00
	dc.w	$FEFE	;FEFE
	dc.w	$FEFF	;FEFF
	dc.w	$FEFE	;FEFE
	dc.w	$00FF	;00FF
	dc.w	$FF7F	;FF7F
	dc.w	$FF7F	;FF7F
	dc.w	$FF7F	;FF7F
	dc.w	$FF01	;FF01
	dc.w	$FE7F	;FE7F
	dc.w	$FE88	;FE88
	dc.w	$FE08	;FE08
	dc.w	$86FF	;86FF
	dc.w	$8F7F	;8F7F
	dc.w	$707F	;707F
	dc.w	$007F	;007F
	dc.w	$FFC9	;FFC9
	dc.w	$FEFB	;FEFB
	dc.w	$FE04	;FE04
	dc.w	$FE00	;FE00
	dc.w	$6DFF	;6DFF
	dc.w	$FF7F	;FF7F
	dc.w	$107F	;107F
	dc.w	$107F	;107F
	dc.w	$FFF8	;FFF8
	dc.w	$FEFA	;FEFA
	dc.w	$FE05	;FE05
	dc.w	$FE00	;FE00
	dc.w	$60FF	;60FF
	dc.w	$FF7F	;FF7F
	dc.w	$807F	;807F
	dc.w	$807F	;807F
	dc.w	$FFE7	;FFE7
	dc.w	$FEEF	;FEEF
	dc.w	$FE10	;FE10
	dc.w	$FE00	;FE00
	dc.w	$A5FF	;A5FF
	dc.w	$ED7F	;ED7F
	dc.w	$127F	;127F
	dc.w	$007F	;007F
	dc.w	$FF42	;FF42
	dc.w	$FE5F	;FE5F
	dc.w	$FEA4	;FEA4
	dc.w	$FE04	;FE04
	dc.w	$E0FF	;E0FF
	dc.w	$F97F	;F97F
	dc.w	$067F	;067F
	dc.w	$007F	;007F
	dc.w	$FFFF	;FFFF
	dc.w	$FF00	;FF00
	dc.w	$FF00	;FF00
	dc.w	$FF00	;FF00
	dc.w	$FFFF	;FFFF
	dc.w	$00FF	;00FF
	dc.w	$00FF	;00FF
	dc.w	$00FF	;00FF
	dc.w	$FF00	;FF00
	dc.w	$FEEF	;FEEF
	dc.w	$FEFF	;FEFF
	dc.w	$FEEF	;FEEF
	dc.w	$00FF	;00FF
	dc.w	$7F7F	;7F7F
	dc.w	$FF7F	;FF7F
	dc.w	$7F7F	;7F7F
	dc.w	$FFFA	;FFFA
	dc.w	$FEFE	;FEFE
	dc.w	$FE05	;FE05
	dc.w	$FE04	;FE04
	dc.w	$34FF	;34FF
	dc.w	$757F	;757F
	dc.w	$8A7F	;8A7F
	dc.w	$007F	;007F
	dc.w	$FF85	;FF85
	dc.w	$FEE5	;FEE5
	dc.w	$FE1A	;FE1A
	dc.w	$FE00	;FE00
	dc.w	$81FF	;81FF
	dc.w	$D97F	;D97F
	dc.w	$367F	;367F
	dc.w	$107F	;107F
	dc.w	$FF88	;FF88
	dc.w	$FEEB	;FEEB
	dc.w	$FE14	;FE14
	dc.w	$FE00	;FE00
	dc.w	$92FF	;92FF
	dc.w	$F77F	;F77F
	dc.w	$087F	;087F
	dc.w	$007F	;007F
	dc.w	$FF00	;FF00
	dc.w	$E042	;E042
	dc.w	$E0BD	;E0BD
	dc.w	$E000	;E000
	dc.w	$28FF	;28FF
	dc.w	$3F07	;3F07
	dc.w	$C007	;C007
	dc.w	$0007	;0007
	dc.w	$FBFF	;FBFF
	dc.w	$DE00	;DE00
	dc.w	$C000	;C000
	dc.w	$C000	;C000
	dc.w	$FFA7	;FFA7
	dc.w	$003B	;003B
	dc.w	$0043	;0043
	dc.w	$0003	;0003
	dc.w	$E810	;E810
	dc.w	$AE76	;AE76
	dc.w	$9189	;9189
	dc.w	$8000	;8000
	dc.w	$5183	;5183
	dc.w	$FFFD	;FFFD
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$8000	;8000
	dc.w	$673F	;673F
	dc.w	$7FFF	;7FFF
	dc.w	$673F	;673F
	dc.w	$0001	;0001
	dc.w	$BCF6	;BCF6
	dc.w	$FFFE	;FFFE
	dc.w	$BCF6	;BCF6
	dc.w	$B494	;B494
	dc.w	$3595	;3595
	dc.w	$4A6B	;4A6B
	dc.w	$0001	;0001
	dc.w	$084B	;084B
	dc.w	$ADEE	;ADEE
	dc.w	$5290	;5290
	dc.w	$0080	;0080
	dc.w	$A747	;A747
	dc.w	$6F67	;6F67
	dc.w	$10B8	;10B8
	dc.w	$0020	;0020
	dc.w	$6B7D	;6B7D
	dc.w	$EFFE	;EFFE
	dc.w	$9400	;9400
	dc.w	$8400	;8400
	dc.w	$BB0C	;BB0C
	dc.w	$7FAC	;7FAC
	dc.w	$0053	;0053
	dc.w	$0000	;0000
	dc.w	$D5ED	;D5ED
	dc.w	$F5FE	;F5FE
	dc.w	$0A00	;0A00
	dc.w	$0000	;0000
	dc.w	$8000	;8000
	dc.w	$7FFF	;7FFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$FFFE	;FFFE
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$FF80	;FF80
	dc.w	$FF80	;FF80
	dc.w	$FF80	;FF80
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$FFC0	;FFC0
	dc.w	$FFBF	;FFBF
	dc.w	$FF80	;FF80
	dc.w	$FF80	;FF80
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$03FF	;03FF
	dc.w	$FDFF	;FDFF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$FFC4	;FFC4
	dc.w	$FFB6	;FFB6
	dc.w	$FF89	;FF89
	dc.w	$FF80	;FF80
	dc.w	$4020	;4020
	dc.w	$5921	;5921
	dc.w	$A6DE	;A6DE
	dc.w	$0000	;0000
	dc.w	$4314	;4314
	dc.w	$D3D6	;D3D6
	dc.w	$2C2B	;2C2B
	dc.w	$0002	;0002
	dc.w	$63FF	;63FF
	dc.w	$FDFF	;FDFF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$FFC0	;FFC0
	dc.w	$FFA0	;FFA0
	dc.w	$FF9F	;FF9F
	dc.w	$FF80	;FF80
	dc.w	$03F1	;03F1
	dc.w	$0BF9	;0BF9
	dc.w	$F406	;F406
	dc.w	$0000	;0000
	dc.w	$05DF	;05DF
	dc.w	$57FF	;57FF
	dc.w	$E820	;E820
	dc.w	$4020	;4020
	dc.w	$EBFF	;EBFF
	dc.w	$FDFF	;FDFF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$FFC7	;FFC7
	dc.w	$FFB7	;FFB7
	dc.w	$FF88	;FF88
	dc.w	$FF80	;FF80
	dc.w	$6508	;6508
	dc.w	$67F9	;67F9
	dc.w	$9866	;9866
	dc.w	$0060	;0060
	dc.w	$0CE2	;0CE2
	dc.w	$CEEE	;CEEE
	dc.w	$7111	;7111
	dc.w	$4000	;4000
	dc.w	$33FF	;33FF
	dc.w	$35FF	;35FF
	dc.w	$C9FF	;C9FF
	dc.w	$01FF	;01FF
	dc.w	$FFDA	;FFDA
	dc.w	$FFBB	;FFBB
	dc.w	$FF85	;FF85
	dc.w	$FF81	;FF81
	dc.w	$5864	;5864
	dc.w	$DAF6	;DAF6
	dc.w	$2509	;2509
	dc.w	$0000	;0000
	dc.w	$8814	;8814
	dc.w	$DE7D	;DE7D
	dc.w	$35C2	;35C2
	dc.w	$1440	;1440
	dc.w	$63FF	;63FF
	dc.w	$6DFF	;6DFF
	dc.w	$91FF	;91FF
	dc.w	$01FF	;01FF
	dc.w	$FFDB	;FFDB
	dc.w	$FFBB	;FFBB
	dc.w	$FF84	;FF84
	dc.w	$FF80	;FF80
	dc.w	$E110	;E110
	dc.w	$E395	;E395
	dc.w	$1E6F	;1E6F
	dc.w	$0205	;0205
	dc.w	$3B00	;3B00
	dc.w	$3BEB	;3BEB
	dc.w	$C41E	;C41E
	dc.w	$000A	;000A
	dc.w	$93FF	;93FF
	dc.w	$DDFF	;DDFF
	dc.w	$61FF	;61FF
	dc.w	$41FF	;41FF
	dc.w	$FFC0	;FFC0
	dc.w	$FFBE	;FFBE
	dc.w	$FFBF	;FFBF
	dc.w	$FFBE	;FFBE
	dc.w	$0000	;0000
	dc.w	$CEEF	;CEEF
	dc.w	$FFFF	;FFFF
	dc.w	$CEEF	;CEEF
	dc.w	$0000	;0000
	dc.w	$FB9E	;FB9E
	dc.w	$FFFF	;FFFF
	dc.w	$FB9E	;FB9E
	dc.w	$03FF	;03FF
	dc.w	$DDFF	;DDFF
	dc.w	$FDFF	;FDFF
	dc.w	$DDFF	;DDFF
	dc.w	$FFF3	;FFF3
	dc.w	$FFCF	;FFCF
	dc.w	$FFC0	;FFC0
	dc.w	$FFC0	;FFC0
	dc.w	$9600	;9600
	dc.w	$9614	;9614
	dc.w	$69EB	;69EB
	dc.w	$0000	;0000
	dc.w	$16E7	;16E7
	dc.w	$56F7	;56F7
	dc.w	$A908	;A908
	dc.w	$0000	;0000
	dc.w	$0FFF	;0FFF
	dc.w	$33FF	;33FF
	dc.w	$C3FF	;C3FF
	dc.w	$03FF	;03FF
	dc.w	$FFFC	;FFFC
	dc.w	$FFF3	;FFF3
	dc.w	$FFF0	;FFF0
	dc.w	$FFF0	;FFF0
	dc.w	$1FFF	;1FFF
	dc.w	$E000	;E000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFF8	;FFF8
	dc.w	$0007	;0007
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$3FFF	;3FFF
	dc.w	$CFFF	;CFFF
	dc.w	$0FFF	;0FFF
	dc.w	$0FFF	;0FFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFC	;FFFC
	dc.w	$FFFC	;FFFC
	dc.w	$FFFC	;FFFC
	dc.w	$F000	;F000
	dc.w	$0FFF	;0FFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$000F	;000F
	dc.w	$FFF0	;FFF0
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FD40	;FD40
	dc.w	$ED42	;ED42
	dc.w	$E2BD	;E2BD
	dc.w	$E000	;E000
	dc.w	$4E2F	;4E2F
	dc.w	$4F67	;4F67
	dc.w	$B097	;B097
	dc.w	$0007	;0007
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FCA2	;FCA2
	dc.w	$EEFA	;EEFA
	dc.w	$E105	;E105
	dc.w	$E000	;E000
	dc.w	$423F	;423F
	dc.w	$4677	;4677
	dc.w	$B987	;B987
	dc.w	$0007	;0007
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F969	;F969
	dc.w	$ED79	;ED79
	dc.w	$E286	;E286
	dc.w	$E000	;E000
	dc.w	$201F	;201F
	dc.w	$F057	;F057
	dc.w	$4FA7	;4FA7
	dc.w	$4007	;4007
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FEC1	;FEC1
	dc.w	$EEC3	;EEC3
	dc.w	$E13E	;E13E
	dc.w	$E002	;E002
	dc.w	$43CF	;43CF
	dc.w	$E7E7	;E7E7
	dc.w	$1817	;1817
	dc.w	$0007	;0007
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F7A2	;F7A2
	dc.w	$E7E2	;E7E2
	dc.w	$E85D	;E85D
	dc.w	$E040	;E040
	dc.w	$407F	;407F
	dc.w	$F4F7	;F4F7
	dc.w	$2F07	;2F07
	dc.w	$2407	;2407
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F000	;F000
	dc.w	$EFBE	;EFBE
	dc.w	$EFFF	;EFFF
	dc.w	$EFBE	;EFBE
	dc.w	$000F	;000F
	dc.w	$7F77	;7F77
	dc.w	$FFF7	;FFF7
	dc.w	$7F77	;7F77
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$FFFF	;FFFF
	dc.w	$000F	;000F
	dc.w	$000F	;000F
	dc.w	$000F	;000F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F960	;F960
	dc.w	$EB60	;EB60
	dc.w	$E49F	;E49F
	dc.w	$E000	;E000
	dc.w	$4EDF	;4EDF
	dc.w	$CED7	;CED7
	dc.w	$3127	;3127
	dc.w	$0007	;0007
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F416	;F416
	dc.w	$EC36	;EC36
	dc.w	$E3C9	;E3C9
	dc.w	$E000	;E000
	dc.w	$044F	;044F
	dc.w	$9F47	;9F47
	dc.w	$E3B7	;E3B7
	dc.w	$8307	;8307
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FF0A	;FF0A
	dc.w	$EF0A	;EF0A
	dc.w	$E0F5	;E0F5
	dc.w	$E000	;E000
	dc.w	$508F	;508F
	dc.w	$54E7	;54E7
	dc.w	$AB17	;AB17
	dc.w	$0007	;0007
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FCA9	;FCA9
	dc.w	$ECAD	;ECAD
	dc.w	$E356	;E356
	dc.w	$E004	;E004
	dc.w	$818F	;818F
	dc.w	$91B7	;91B7
	dc.w	$6E47	;6E47
	dc.w	$0007	;0007
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F912	;F912
	dc.w	$E91F	;E91F
	dc.w	$E6EC	;E6EC
	dc.w	$E00C	;E00C
	dc.w	$0B1F	;0B1F
	dc.w	$7B57	;7B57
	dc.w	$B4A7	;B4A7
	dc.w	$3007	;3007
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F760	;F760
	dc.w	$E779	;E779
	dc.w	$E886	;E886
	dc.w	$E000	;E000
	dc.w	$022F	;022F
	dc.w	$C7F7	;C7F7
	dc.w	$F907	;F907
	dc.w	$C107	;C107
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F718	;F718
	dc.w	$E77A	;E77A
	dc.w	$E885	;E885
	dc.w	$E000	;E000
	dc.w	$85FF	;85FF
	dc.w	$85F7	;85F7
	dc.w	$7A07	;7A07
	dc.w	$0007	;0007
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F704	;F704
	dc.w	$E79C	;E79C
	dc.w	$E873	;E873
	dc.w	$E010	;E010
	dc.w	$D34F	;D34F
	dc.w	$F367	;F367
	dc.w	$0C97	;0C97
	dc.w	$0007	;0007
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FC10	;FC10
	dc.w	$EC10	;EC10
	dc.w	$E3EF	;E3EF
	dc.w	$E000	;E000
	dc.w	$334F	;334F
	dc.w	$BF47	;BF47
	dc.w	$40B7	;40B7
	dc.w	$0007	;0007
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$FFFF	;FFFF
	dc.w	$000F	;000F
	dc.w	$000F	;000F
	dc.w	$000F	;000F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F000	;F000
	dc.w	$EF3F	;EF3F
	dc.w	$EFFF	;EFFF
	dc.w	$EF3F	;EF3F
	dc.w	$000F	;000F
	dc.w	$DEF7	;DEF7
	dc.w	$FFF7	;FFF7
	dc.w	$DEF7	;DEF7
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F808	;F808
	dc.w	$E90D	;E90D
	dc.w	$E6F2	;E6F2
	dc.w	$E000	;E000
	dc.w	$51AF	;51AF
	dc.w	$59A7	;59A7
	dc.w	$A657	;A657
	dc.w	$0007	;0007
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F542	;F542
	dc.w	$EFFA	;EFFA
	dc.w	$E025	;E025
	dc.w	$E020	;E020
	dc.w	$086F	;086F
	dc.w	$7B67	;7B67
	dc.w	$C697	;C697
	dc.w	$4207	;4207
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F8C9	;F8C9
	dc.w	$E8DD	;E8DD
	dc.w	$E726	;E726
	dc.w	$E004	;E004
	dc.w	$0B2F	;0B2F
	dc.w	$0B27	;0B27
	dc.w	$F4D7	;F4D7
	dc.w	$0007	;0007
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F234	;F234
	dc.w	$E37E	;E37E
	dc.w	$EC83	;EC83
	dc.w	$E002	;E002
	dc.w	$404F	;404F
	dc.w	$44C7	;44C7
	dc.w	$BF37	;BF37
	dc.w	$0407	;0407
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F60D	;F60D
	dc.w	$E68D	;E68D
	dc.w	$E972	;E972
	dc.w	$E000	;E000
	dc.w	$339F	;339F
	dc.w	$73F7	;73F7
	dc.w	$CC07	;CC07
	dc.w	$4007	;4007
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F40C	;F40C
	dc.w	$E41C	;E41C
	dc.w	$EBE3	;EBE3
	dc.w	$E000	;E000
	dc.w	$5B0F	;5B0F
	dc.w	$DB17	;DB17
	dc.w	$24E7	;24E7
	dc.w	$0007	;0007
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FD62	;FD62
	dc.w	$EFE2	;EFE2
	dc.w	$E01D	;E01D
	dc.w	$E000	;E000
	dc.w	$AD8F	;AD8F
	dc.w	$AD87	;AD87
	dc.w	$5277	;5277
	dc.w	$0007	;0007
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F000	;F000
	dc.w	$EFFF	;EFFF
	dc.w	$E000	;E000
	dc.w	$E000	;E000
	dc.w	$000F	;000F
	dc.w	$FFF7	;FFF7
	dc.w	$0007	;0007
	dc.w	$0007	;0007
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$FFFF	;FFFF
	dc.w	$000F	;000F
	dc.w	$000F	;000F
	dc.w	$000F	;000F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F000	;F000
	dc.w	$EF9E	;EF9E
	dc.w	$EFFF	;EFFF
	dc.w	$EF9E	;EF9E
	dc.w	$000F	;000F
	dc.w	$FEF7	;FEF7
	dc.w	$FFF7	;FFF7
	dc.w	$FEF7	;FEF7
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F6C2	;F6C2
	dc.w	$E6FB	;E6FB
	dc.w	$E914	;E914
	dc.w	$E010	;E010
	dc.w	$007F	;007F
	dc.w	$30F7	;30F7
	dc.w	$DF07	;DF07
	dc.w	$1007	;1007
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F101	;F101
	dc.w	$E5ED	;E5ED
	dc.w	$EA5E	;EA5E
	dc.w	$E04C	;E04C
	dc.w	$80AF	;80AF
	dc.w	$E8A7	;E8A7
	dc.w	$1757	;1757
	dc.w	$0007	;0007
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F228	;F228
	dc.w	$E6FF	;E6FF
	dc.w	$E906	;E906
	dc.w	$E006	;E006
	dc.w	$C11F	;C11F
	dc.w	$F517	;F517
	dc.w	$0EE7	;0EE7
	dc.w	$0407	;0407
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F741	;F741
	dc.w	$E761	;E761
	dc.w	$E89E	;E89E
	dc.w	$E000	;E000
	dc.w	$758F	;758F
	dc.w	$7D87	;7D87
	dc.w	$8277	;8277
	dc.w	$0007	;0007
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFF8	;FFF8
	dc.w	$FFF8	;FFF8
	dc.w	$FFF8	;FFF8
	dc.w	$FBB1	;FBB1
	dc.w	$0BF1	;0BF1
	dc.w	$040E	;040E
	dc.w	$0000	;0000
	dc.w	$74DF	;74DF
	dc.w	$74D0	;74D0
	dc.w	$8B20	;8B20
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$FFF8	;FFF8
	dc.w	$FFF7	;FFF7
	dc.w	$FFF0	;FFF0
	dc.w	$FFF0	;FFF0
	dc.w	$1000	;1000
	dc.w	$EFFF	;EFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0008	;0008
	dc.w	$FFF7	;FFF7
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$1FFF	;1FFF
	dc.w	$EFFF	;EFFF
	dc.w	$0FFF	;0FFF
	dc.w	$0FFF	;0FFF
	dc.w	$FFF7	;FFF7
	dc.w	$FFEF	;FFEF
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$5FFF	;5FFF
	dc.w	$6000	;6000
	dc.w	$8000	;8000
	dc.w	$0000	;0000
	dc.w	$FFFD	;FFFD
	dc.w	$0005	;0005
	dc.w	$0002	;0002
	dc.w	$0000	;0000
	dc.w	$8FFF	;8FFF
	dc.w	$97FF	;97FF
	dc.w	$67FF	;67FF
	dc.w	$07FF	;07FF
	dc.w	$FFEA	;FFEA
	dc.w	$FFDA	;FFDA
	dc.w	$FFC5	;FFC5
	dc.w	$FFC0	;FFC0
	dc.w	$44A4	;44A4
	dc.w	$CCB4	;CCB4
	dc.w	$334B	;334B
	dc.w	$0000	;0000
	dc.w	$0D1D	;0D1D
	dc.w	$0F5D	;0F5D
	dc.w	$F0A2	;F0A2
	dc.w	$0000	;0000
	dc.w	$C7FF	;C7FF
	dc.w	$CBFF	;CBFF
	dc.w	$33FF	;33FF
	dc.w	$03FF	;03FF
	dc.w	$FFC0	;FFC0
	dc.w	$FFB9	;FFB9
	dc.w	$FFBF	;FFBF
	dc.w	$FFB9	;FFB9
	dc.w	$0000	;0000
	dc.w	$CF9F	;CF9F
	dc.w	$FFFF	;FFFF
	dc.w	$CF9F	;CF9F
	dc.w	$0000	;0000
	dc.w	$DFBD	;DFBD
	dc.w	$FFFF	;FFFF
	dc.w	$DFBD	;DFBD
	dc.w	$03FF	;03FF
	dc.w	$DDFF	;DDFF
	dc.w	$FDFF	;FDFF
	dc.w	$DDFF	;DDFF
	dc.w	$FFD4	;FFD4
	dc.w	$FFB6	;FFB6
	dc.w	$FF89	;FF89
	dc.w	$FF80	;FF80
	dc.w	$43D3	;43D3
	dc.w	$5FDF	;5FDF
	dc.w	$B82C	;B82C
	dc.w	$180C	;180C
	dc.w	$811B	;811B
	dc.w	$CD9B	;CD9B
	dc.w	$3E64	;3E64
	dc.w	$0C00	;0C00
	dc.w	$93FF	;93FF
	dc.w	$9DFF	;9DFF
	dc.w	$61FF	;61FF
	dc.w	$01FF	;01FF
	dc.w	$FFD3	;FFD3
	dc.w	$FFB3	;FFB3
	dc.w	$FF8C	;FF8C
	dc.w	$FF80	;FF80
	dc.w	$2422	;2422
	dc.w	$AC26	;AC26
	dc.w	$DBD9	;DBD9
	dc.w	$8800	;8800
	dc.w	$0762	;0762
	dc.w	$87F6	;87F6
	dc.w	$7819	;7819
	dc.w	$0010	;0010
	dc.w	$9BFF	;9BFF
	dc.w	$9DFF	;9DFF
	dc.w	$61FF	;61FF
	dc.w	$01FF	;01FF
	dc.w	$FFDA	;FFDA
	dc.w	$FFBA	;FFBA
	dc.w	$FF85	;FF85
	dc.w	$FF80	;FF80
	dc.w	$DFD8	;DFD8
	dc.w	$DFDD	;DFDD
	dc.w	$2023	;2023
	dc.w	$0001	;0001
	dc.w	$9654	;9654
	dc.w	$D7F7	;D7F7
	dc.w	$2829	;2829
	dc.w	$0021	;0021
	dc.w	$4BFF	;4BFF
	dc.w	$4DFF	;4DFF
	dc.w	$B1FF	;B1FF
	dc.w	$01FF	;01FF
	dc.w	$FFDF	;FFDF
	dc.w	$FFBF	;FFBF
	dc.w	$FF80	;FF80
	dc.w	$FF80	;FF80
	dc.w	$3712	;3712
	dc.w	$3FD2	;3FD2
	dc.w	$C0AD	;C0AD
	dc.w	$0080	;0080
	dc.w	$53E7	;53E7
	dc.w	$FBE7	;FBE7
	dc.w	$0C18	;0C18
	dc.w	$0800	;0800
	dc.w	$9BFF	;9BFF
	dc.w	$9DFF	;9DFF
	dc.w	$61FF	;61FF
	dc.w	$01FF	;01FF
	dc.w	$FFCA	;FFCA
	dc.w	$FFAE	;FFAE
	dc.w	$FF91	;FF91
	dc.w	$FF80	;FF80
	dc.w	$213B	;213B
	dc.w	$33FB	;33FB
	dc.w	$CC04	;CC04
	dc.w	$0000	;0000
	dc.w	$A10A	;A10A
	dc.w	$A1AA	;A1AA
	dc.w	$5E55	;5E55
	dc.w	$0000	;0000
	dc.w	$5BFF	;5BFF
	dc.w	$7DFF	;7DFF
	dc.w	$81FF	;81FF
	dc.w	$01FF	;01FF
	dc.w	$FFC0	;FFC0
	dc.w	$FFBF	;FFBF
	dc.w	$FF80	;FF80
	dc.w	$FF80	;FF80
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$03FF	;03FF
	dc.w	$FDFF	;FDFF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$FFFF	;FFFF
	dc.w	$FF80	;FF80
	dc.w	$FF80	;FF80
	dc.w	$FF80	;FF80
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
_GFX_StairsUp:
	INCBIN bext-gfx/StairsUp

_GFX_StairsDown:
	INCBIN bext-gfx/StairsDown

_GFX_LargeOpenDoor:
	INCBIN bw-gfx/LargeOpenDoor

_GFX_LargeMetalDoor:
	INCBIN bw-gfx/LargeMetalDoor

_GFX_PortCullis:
	INCBIN bext-gfx/PortCullis

_GFX_PitLow:	dc.w	$007F	;007F
	dc.w	$007F	;007F
	dc.w	$007F	;007F
	dc.w	$007F	;007F
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFE6	;FFE6
	dc.w	$FFE7	;FFE7
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$9CF7	;9CF7
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFC0	;FFC0
	dc.w	$FFC0	;FFC0
	dc.w	$FFC0	;FFC0
	dc.w	$FFC0	;FFC0
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FF80	;FF80
	dc.w	$FF80	;FF80
	dc.w	$FF80	;FF80
	dc.w	$FF80	;FF80
	dc.w	$0003	;0003
	dc.w	$0003	;0003
	dc.w	$0003	;0003
	dc.w	$0003	;0003
	dc.w	$6CE3	;6CE3
	dc.w	$ECE3	;ECE3
	dc.w	$131C	;131C
	dc.w	$0000	;0000
	dc.w	$21FF	;21FF
	dc.w	$20FF	;20FF
	dc.w	$DCFF	;DCFF
	dc.w	$00FF	;00FF
	dc.w	$DD9D	;DD9D
	dc.w	$2262	;2262
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$63FF	;63FF
	dc.w	$91FF	;91FF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0FFF	;0FFF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$801F	;801F
	dc.w	$969F	;969F
	dc.w	$7FDF	;7FDF
	dc.w	$169F	;169F
	dc.w	$D07F	;D07F
	dc.w	$7F3F	;7F3F
	dc.w	$003F	;003F
	dc.w	$003F	;003F
	dc.w	$D9FF	;D9FF
	dc.w	$24FF	;24FF
	dc.w	$00FF	;00FF
	dc.w	$00FF	;00FF
	dc.w	$F7FF	;F7FF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$1FFF	;1FFF
	dc.w	$0FFF	;0FFF
	dc.w	$0FFF	;0FFF
	dc.w	$0FFF	;0FFF
	dc.w	$7FFF	;7FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FF00	;FF00
	dc.w	$FF00	;FF00
	dc.w	$FF00	;FF00
	dc.w	$FF00	;FF00
	dc.w	$00FF	;00FF
	dc.w	$00FF	;00FF
	dc.w	$00FF	;00FF
	dc.w	$00FF	;00FF
	dc.w	$F800	;F800
	dc.w	$FBFF	;FBFF
	dc.w	$F800	;F800
	dc.w	$F800	;F800
	dc.w	$001F	;001F
	dc.w	$FFDF	;FFDF
	dc.w	$001F	;001F
	dc.w	$001F	;001F
	dc.w	$FC00	;FC00
	dc.w	$FC00	;FC00
	dc.w	$F800	;F800
	dc.w	$F800	;F800
	dc.w	$003F	;003F
	dc.w	$003F	;003F
	dc.w	$001F	;001F
	dc.w	$001F	;001F
	dc.w	$F7FF	;F7FF
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$FFEF	;FFEF
	dc.w	$000F	;000F
	dc.w	$000F	;000F
	dc.w	$000F	;000F
	dc.w	$E000	;E000
	dc.w	$E204	;E204
	dc.w	$FFFF	;FFFF
	dc.w	$E204	;E204
	dc.w	$0007	;0007
	dc.w	$8207	;8207
	dc.w	$FFFF	;FFFF
	dc.w	$8207	;8207
	dc.w	$CC33	;CC33
	dc.w	$CBDD	;CBDD
	dc.w	$E000	;E000
	dc.w	$C000	;C000
	dc.w	$FE63	;FE63
	dc.w	$77B3	;77B3
	dc.w	$0007	;0007
	dc.w	$0003	;0003
	dc.w	$A000	;A000
	dc.w	$A000	;A000
	dc.w	$C000	;C000
	dc.w	$8000	;8000
	dc.w	$0001	;0001
	dc.w	$0005	;0005
	dc.w	$0003	;0003
	dc.w	$0001	;0001
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFF	;FFFF
	dc.w	$FFFE	;FFFE
	dc.w	$0000	;0000
	dc.w	$79DE	;79DE
	dc.w	$FFFF	;FFFF
	dc.w	$79DE	;79DE
	dc.w	$0000	;0000
	dc.w	$5CDD	;5CDD
	dc.w	$FFFF	;FFFF
	dc.w	$5CDD	;5CDD
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$FFFF	;FFFF
	dc.w	$7FFF	;7FFF
	dc.w	$FFFD	;FFFD
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$5094	;5094
	dc.w	$D5D7	;D5D7
	dc.w	$2E6B	;2E6B
	dc.w	$0443	;0443
	dc.w	$4C82	;4C82
	dc.w	$DFB2	;DFB2
	dc.w	$337D	;337D
	dc.w	$1330	;1330
	dc.w	$BFFF	;BFFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$FFF9	;FFF9
	dc.w	$FFFC	;FFFC
	dc.w	$FFFE	;FFFE
	dc.w	$FFFC	;FFFC
	dc.w	$3482	;3482
	dc.w	$6C20	;6C20
	dc.w	$835D	;835D
	dc.w	$0000	;0000
	dc.w	$1025	;1025
	dc.w	$6063	;6063
	dc.w	$8F9A	;8F9A
	dc.w	$0002	;0002
	dc.w	$9FFF	;9FFF
	dc.w	$3FFF	;3FFF
	dc.w	$7FFF	;7FFF
	dc.w	$3FFF	;3FFF
	dc.w	$FFF3	;FFF3
	dc.w	$FFFE	;FFFE
	dc.w	$FFFC	;FFFC
	dc.w	$FFFC	;FFFC
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$CFFF	;CFFF
	dc.w	$7FFF	;7FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$FFF1	;FFF1
	dc.w	$FFFA	;FFFA
	dc.w	$FFEC	;FFEC
	dc.w	$FFE8	;FFE8
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$8FFF	;8FFF
	dc.w	$5FFF	;5FFF
	dc.w	$37FF	;37FF
	dc.w	$17FF	;17FF
	dc.w	$FFC2	;FFC2
	dc.w	$FFD4	;FFD4
	dc.w	$FFF8	;FFF8
	dc.w	$FFD0	;FFD0
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$47FF	;47FF
	dc.w	$2FFF	;2FFF
	dc.w	$1FFF	;1FFF
	dc.w	$0FFF	;0FFF
	dc.w	$F800	;F800
	dc.w	$FBE6	;FBE6
	dc.w	$FFFF	;FFFF
	dc.w	$FBE6	;FBE6
	dc.w	$0000	;0000
	dc.w	$F7F6	;F7F6
	dc.w	$FFFF	;FFFF
	dc.w	$F7F6	;F7F6
	dc.w	$0000	;0000
	dc.w	$E7CF	;E7CF
	dc.w	$FFFF	;FFFF
	dc.w	$E7CF	;E7CF
	dc.w	$001F	;001F
	dc.w	$CEDF	;CEDF
	dc.w	$FFFF	;FFFF
	dc.w	$CEDF	;CEDF
	dc.w	$F4D1	;F4D1
	dc.w	$FAF3	;FAF3
	dc.w	$F92E	;F92E
	dc.w	$F822	;F822
	dc.w	$C003	;C003
	dc.w	$D98B	;D98B
	dc.w	$3FFC	;3FFC
	dc.w	$1988	;1988
	dc.w	$8186	;8186
	dc.w	$E3BF	;E3BF
	dc.w	$7E79	;7E79
	dc.w	$6239	;6239
	dc.w	$086F	;086F
	dc.w	$7EDF	;7EDF
	dc.w	$F79F	;F79F
	dc.w	$769F	;769F
	dc.w	$E623	;E623
	dc.w	$F9DC	;F9DC
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$0230	;0230
	dc.w	$FDCF	;FDCF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$6406	;6406
	dc.w	$9BF9	;9BF9
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$2067	;2067
	dc.w	$DF9F	;DF9F
	dc.w	$000F	;000F
	dc.w	$000F	;000F
_GFX_PitHigh:	dc.w	$B7FF	;B7FF
	dc.w	$07FF	;07FF
	dc.w	$47FF	;47FF
	dc.w	$07FF	;07FF
	dc.w	$FEF3	;FEF3
	dc.w	$FE00	;FE00
	dc.w	$FE08	;FE08
	dc.w	$FE00	;FE00
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$A7FF	;A7FF
	dc.w	$07FF	;07FF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFA	;FFFA
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$D003	;D003
	dc.w	$0003	;0003
	dc.w	$26B7	;26B7
	dc.w	$0003	;0003
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F2FF	;F2FF
	dc.w	$F2FF	;F2FF
	dc.w	$F2FF	;F2FF
	dc.w	$0400	;0400
	dc.w	$0000	;0000
	dc.w	$5A9D	;5A9D
	dc.w	$0000	;0000
	dc.w	$07FF	;07FF
	dc.w	$05FF	;05FF
	dc.w	$75FF	;75FF
	dc.w	$0DFF	;0DFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$094A	;094A
	dc.w	$0014	;0014
	dc.w	$1FFF	;1FFF
	dc.w	$17FF	;17FF
	dc.w	$D7FF	;D7FF
	dc.w	$37FF	;37FF
	dc.w	$FFFF	;FFFF
	dc.w	$E03F	;E03F
	dc.w	$E03F	;E03F
	dc.w	$E03F	;E03F
	dc.w	$00FF	;00FF
	dc.w	$00BF	;00BF
	dc.w	$17BF	;17BF
	dc.w	$00BF	;00BF
	dc.w	$03FF	;03FF
	dc.w	$02FF	;02FF
	dc.w	$4AFF	;4AFF
	dc.w	$06FF	;06FF
	dc.w	$0FFF	;0FFF
	dc.w	$0BFF	;0BFF
	dc.w	$CBFF	;CBFF
	dc.w	$3BFF	;3BFF
	dc.w	$3FFF	;3FFF
	dc.w	$2FFF	;2FFF
	dc.w	$2FFF	;2FFF
	dc.w	$EFFF	;EFFF
	dc.w	$FFFF	;FFFF
	dc.w	$BFFF	;BFFF
	dc.w	$BFFF	;BFFF
	dc.w	$BFFF	;BFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FF66	;FF66
	dc.w	$FF00	;FF00
	dc.w	$FF01	;FF01
	dc.w	$FF00	;FF00
	dc.w	$38FF	;38FF
	dc.w	$00FF	;00FF
	dc.w	$44FF	;44FF
	dc.w	$00FF	;00FF
	dc.w	$FFFF	;FFFF
	dc.w	$FC00	;FC00
	dc.w	$FC00	;FC00
	dc.w	$FC00	;FC00
	dc.w	$FFFF	;FFFF
	dc.w	$003F	;003F
	dc.w	$003F	;003F
	dc.w	$003F	;003F
	dc.w	$FC00	;FC00
	dc.w	$FC00	;FC00
	dc.w	$FCB0	;FCB0
	dc.w	$FC00	;FC00
	dc.w	$003F	;003F
	dc.w	$003F	;003F
	dc.w	$C5BF	;C5BF
	dc.w	$003F	;003F
	dc.w	$FFFF	;FFFF
	dc.w	$F800	;F800
	dc.w	$F800	;F800
	dc.w	$F800	;F800
	dc.w	$FFFF	;FFFF
	dc.w	$001F	;001F
	dc.w	$001F	;001F
	dc.w	$001F	;001F
	dc.w	$FFFF	;FFFF
	dc.w	$E000	;E000
	dc.w	$E000	;E000
	dc.w	$E000	;E000
	dc.w	$FFFF	;FFFF
	dc.w	$0007	;0007
	dc.w	$0007	;0007
	dc.w	$0007	;0007
	dc.w	$E000	;E000
	dc.w	$C000	;C000
	dc.w	$CC86	;CC86
	dc.w	$C000	;C000
	dc.w	$0007	;0007
	dc.w	$0003	;0003
	dc.w	$9B13	;9B13
	dc.w	$0003	;0003
	dc.w	$C000	;C000
	dc.w	$8000	;8000
	dc.w	$AD75	;AD75
	dc.w	$9BCE	;9BCE
	dc.w	$0003	;0003
	dc.w	$0001	;0001
	dc.w	$56E9	;56E9
	dc.w	$39B1	;39B1
	dc.w	$FFFF	;FFFF
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$FFFE	;FFFE
	dc.w	$FFFC	;FFFC
	dc.w	$FFFC	;FFFC
	dc.w	$FFFC	;FFFC
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$7FFF	;7FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$FFFC	;FFFC
	dc.w	$FFF8	;FFF8
	dc.w	$FFF9	;FFF9
	dc.w	$FFF8	;FFF8
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$6A93	;6A93
	dc.w	$956C	;956C
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$E7AD	;E7AD
	dc.w	$1852	;1852
	dc.w	$3FFF	;3FFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$9FFF	;9FFF
	dc.w	$FFF8	;FFF8
	dc.w	$FFF0	;FFF0
	dc.w	$FFF3	;FFF3
	dc.w	$FFF0	;FFF0
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$BF4C	;BF4C
	dc.w	$51B7	;51B7
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$AFB1	;AFB1
	dc.w	$55DE	;55DE
	dc.w	$1FFF	;1FFF
	dc.w	$0FFF	;0FFF
	dc.w	$CFFF	;CFFF
	dc.w	$0FFF	;0FFF
	dc.w	$FFF8	;FFF8
	dc.w	$FFE0	;FFE0
	dc.w	$FFE2	;FFE2
	dc.w	$FFE5	;FFE5
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$8F5D	;8F5D
	dc.w	$70B2	;70B2
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$CAC2	;CAC2
	dc.w	$757D	;757D
	dc.w	$1FFF	;1FFF
	dc.w	$07FF	;07FF
	dc.w	$C7FF	;C7FF
	dc.w	$27FF	;27FF
	dc.w	$FFF0	;FFF0
	dc.w	$FFE0	;FFE0
	dc.w	$FFE7	;FFE7
	dc.w	$FFE7	;FFE7
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$BDE3	;BDE3
	dc.w	$FEFF	;FEFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$7F3B	;7F3B
	dc.w	$EDD7	;EDD7
	dc.w	$0FFF	;0FFF
	dc.w	$07FF	;07FF
	dc.w	$E7FF	;E7FF
	dc.w	$E7FF	;E7FF
	dc.w	$FFFF	;FFFF
	dc.w	$F800	;F800
	dc.w	$F800	;F800
	dc.w	$F800	;F800
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$001F	;001F
	dc.w	$001F	;001F
	dc.w	$001F	;001F
	dc.w	$F800	;F800
	dc.w	$F000	;F000
	dc.w	$F0D3	;F0D3
	dc.w	$F12C	;F12C
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C513	;C513
	dc.w	$3AEC	;3AEC
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$91A7	;91A7
	dc.w	$6E58	;6E58
	dc.w	$001F	;001F
	dc.w	$000F	;000F
	dc.w	$1E4F	;1E4F
	dc.w	$E18F	;E18F
	dc.w	$F000	;F000
	dc.w	$E000	;E000
	dc.w	$E6BE	;E6BE
	dc.w	$E3F1	;E3F1
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$F1A9	;F1A9
	dc.w	$7FD6	;7FD6
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$DBFD	;DBFD
	dc.w	$B797	;B797
	dc.w	$000F	;000F
	dc.w	$0007	;0007
	dc.w	$9FE7	;9FE7
	dc.w	$74E7	;74E7
_GFX_Pad:	dc.w	$007F	;007F
	dc.w	$007F	;007F
	dc.w	$007F	;007F
	dc.w	$007F	;007F
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$FF80	;FF80
	dc.w	$FE00	;FE00
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FF40	;FF40
	dc.w	$FF40	;FF40
	dc.w	$FF80	;FF80
	dc.w	$FF00	;FF00
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$7FFF	;7FFF
	dc.w	$0FFF	;0FFF
	dc.w	$0FFF	;0FFF
	dc.w	$0FFF	;0FFF
	dc.w	$4D94	;4D94
	dc.w	$4D94	;4D94
	dc.w	$B26B	;B26B
	dc.w	$0000	;0000
	dc.w	$0FFF	;0FFF
	dc.w	$B3FF	;B3FF
	dc.w	$F3FF	;F3FF
	dc.w	$B3FF	;B3FF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$83FF	;83FF
	dc.w	$63FF	;63FF
	dc.w	$03FF	;03FF
	dc.w	$03FF	;03FF
	dc.w	$B47F	;B47F
	dc.w	$7C7F	;7C7F
	dc.w	$007F	;007F
	dc.w	$007F	;007F
	dc.w	$001F	;001F
	dc.w	$369F	;369F
	dc.w	$FF9F	;FF9F
	dc.w	$369F	;369F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FE00	;FE00
	dc.w	$FE00	;FE00
	dc.w	$FF00	;FF00
	dc.w	$FE00	;FE00
	dc.w	$007F	;007F
	dc.w	$007F	;007F
	dc.w	$00FF	;00FF
	dc.w	$007F	;007F
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$F800	;F800
	dc.w	$F000	;F000
	dc.w	$000F	;000F
	dc.w	$000F	;000F
	dc.w	$001F	;001F
	dc.w	$000F	;000F
	dc.w	$4000	;4000
	dc.w	$8000	;8000
	dc.w	$8000	;8000
	dc.w	$8000	;8000
	dc.w	$0002	;0002
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$0001	;0001
	dc.w	$8000	;8000
	dc.w	$BA35	;BA35
	dc.w	$FFFF	;FFFF
	dc.w	$BA35	;BA35
	dc.w	$0001	;0001
	dc.w	$DDD7	;DDD7
	dc.w	$FFFF	;FFFF
	dc.w	$DDD7	;DDD7
	dc.w	$FFC0	;FFC0
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$03FF	;03FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$FFE2	;FFE2
	dc.w	$FFF3	;FFF3
	dc.w	$FFF8	;FFF8
	dc.w	$FFF0	;FFF0
	dc.w	$FBFE	;FBFE
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$CDB0	;CDB0
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$C7FF	;C7FF
	dc.w	$CFFF	;CFFF
	dc.w	$1FFF	;1FFF
	dc.w	$0FFF	;0FFF
	dc.w	$FFF0	;FFF0
	dc.w	$FFF8	;FFF8
	dc.w	$FFFB	;FFFB
	dc.w	$FFF8	;FFF8
	dc.w	$0000	;0000
	dc.w	$B0A4	;B0A4
	dc.w	$4F5B	;4F5B
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$D010	;D010
	dc.w	$2FEF	;2FEF
	dc.w	$0000	;0000
	dc.w	$0FFF	;0FFF
	dc.w	$1FFF	;1FFF
	dc.w	$DFFF	;DFFF
	dc.w	$1FFF	;1FFF
	dc.w	$FFF8	;FFF8
	dc.w	$FFFE	;FFFE
	dc.w	$FFFF	;FFFF
	dc.w	$FFFE	;FFFE
	dc.w	$0000	;0000
	dc.w	$8F7E	;8F7E
	dc.w	$FFFF	;FFFF
	dc.w	$8F7E	;8F7E
	dc.w	$0000	;0000
	dc.w	$F7B6	;F7B6
	dc.w	$FFFF	;FFFF
	dc.w	$F7B6	;F7B6
	dc.w	$1FFF	;1FFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$EC83	;EC83
	dc.w	$FD7C	;FD7C
	dc.w	$F000	;F000
	dc.w	$F000	;F000
	dc.w	$03C7	;03C7
	dc.w	$FE7E	;FE7E
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$8C3B	;8C3B
	dc.w	$73CE	;73CE
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$BF27	;BF27
	dc.w	$64AF	;64AF
	dc.w	$001F	;001F
	dc.w	$000F	;000F
	dc.w	$F030	;F030
	dc.w	$F9BB	;F9BB
	dc.w	$FC44	;FC44
	dc.w	$F800	;F800
	dc.w	$5041	;5041
	dc.w	$7C53	;7C53
	dc.w	$83AC	;83AC
	dc.w	$0000	;0000
	dc.w	$8453	;8453
	dc.w	$A65F	;A65F
	dc.w	$59A0	;59A0
	dc.w	$0000	;0000
	dc.w	$8D2F	;8D2F
	dc.w	$BFBF	;BFBF
	dc.w	$401F	;401F
	dc.w	$001F	;001F
	dc.w	$F880	;F880
	dc.w	$FC90	;FC90
	dc.w	$FD7F	;FD7F
	dc.w	$FC10	;FC10
	dc.w	$0000	;0000
	dc.w	$C041	;C041
	dc.w	$FFFF	;FFFF
	dc.w	$C041	;C041
	dc.w	$0000	;0000
	dc.w	$3108	;3108
	dc.w	$FFFF	;FFFF
	dc.w	$3108	;3108
	dc.w	$001F	;001F
	dc.w	$243F	;243F
	dc.w	$FFBF	;FFBF
	dc.w	$243F	;243F
	dc.w	$FC00	;FC00
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$003F	;003F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
_GFX_FloorCeiling:
	INCBIN bext-gfx/FloorCeiling

_GFX_ObjectsOnFloor:
	INCBIN bext-gfx/ObjectsOnFloor

_GFX_FireBall:
	INCBIN bext-gfx/AirbourneFireball

_GFX_AirbourneSpells:
	INCBIN bext-gfx/AirbourneSpells

_GFX_AirbourneBall:
	INCBIN bext-gfx/AirbourneBall

CharacterColours:
	dc.w	$0004	;0004
	dc.w	$0800	;0800
	dc.w	$0E04	;0E04
	dc.w	$0803	;0803
	dc.w	$0E04	;0E04
	dc.w	$0803	;0803
	dc.w	$0408	;0408
	dc.w	$040E	;040E

	dc.w	$0808	;0808
	dc.w	$0404	;0404
adrEA031E34:
	dc.w	$0007	;0007
	dc.w	$0804	;0804
	dc.w	$0009	;0009
	dc.w	$0C0B	;0C0B
	dc.w	$0506	;0506
	dc.w	$0E00	;0E00
	dc.w	$090C	;090C
	dc.w	$0B0C	;0B0C
	dc.w	$0B0D	;0B0D
	dc.w	$0B0E	;0B0E
	dc.w	$090C	;090C
	dc.w	$060D	;060D
	dc.w	$0009	;0009
	dc.w	$0C0C	;0C0C
	dc.w	$0000	;0000
	dc.w	$080C	;080C
	dc.w	$090C	;090C
	dc.w	$0B00	;0B00
	dc.w	$090C	;090C
	dc.w	$0B00	;0B00
	dc.w	$0B09	;0B09
	dc.w	$0C0C	;0C0C
	dc.w	$090C	;090C
	dc.w	$0D0C	;0D0C
	dc.w	$0004	;0004
	dc.w	$080C	;080C
	dc.w	$0500	;0500
	dc.w	$000C	;000C
	dc.w	$0804	;0804
	dc.w	$0E00	;0E00
	dc.w	$0804	;0804
	dc.w	$0E00	;0E00
	dc.w	$0B08	;0B08
	dc.w	$040B	;040B
	dc.w	$0804	;0804
	dc.w	$0904	;0904
	dc.w	$0005	;0005
	dc.w	$0607	;0607
	dc.w	$0506	;0506
	dc.w	$000C	;000C
	dc.w	$0105	;0105
	dc.w	$0600	;0600
	dc.w	$0105	;0105
	dc.w	$0606	;0606
	dc.w	$0605	;0605
	dc.w	$0606	;0606
	dc.w	$0506	;0506
	dc.w	$0105	;0105
	dc.w	$0005	;0005
	dc.w	$060D	;060D
	dc.w	$0000	;0000
	dc.w	$0005	;0005
	dc.w	$090C	;090C
	dc.w	$0B00	;0B00
	dc.w	$0B0D	;0B0D
	dc.w	$0E0B	;0E0B
	dc.w	$0B06	;0B06
	dc.w	$050E	;050E
	dc.w	$0A0D	;0A0D
	dc.w	$0C06	;0C06
	dc.w	$0004	;0004
	dc.w	$080C	;080C
	dc.w	$0708	;0708
	dc.w	$0405	;0405
	dc.w	$0804	;0804
	dc.w	$0D00	;0D00
	dc.w	$0804	;0804
	dc.w	$0D0B	;0D0B
	dc.w	$0B08	;0B08
	dc.w	$040D	;040D
	dc.w	$0708	;0708
	dc.w	$0808	;0808
	dc.w	$0007	;0007
	dc.w	$0804	;0804
	dc.w	$0506	;0506
	dc.w	$0007	;0007
	dc.w	$0506	;0506
	dc.w	$0E00	;0E00
	dc.w	$0506	;0506
	dc.w	$0E0B	;0E0B
	dc.w	$0B05	;0B05
	dc.w	$060E	;060E
	dc.w	$0506	;0506
	dc.w	$0606	;0606
	dc.w	$0005	;0005
	dc.w	$060C	;060C
	dc.w	$0203	;0203
	dc.w	$040C	;040C
	dc.w	$090C	;090C
	dc.w	$0B00	;0B00
	dc.w	$090A	;090A
	dc.w	$0B0B	;0B0B
	dc.w	$0B0B	;0B0B
	dc.w	$0A0B	;0A0B
	dc.w	$0A0B	;0A0B
	dc.w	$090C	;090C
	dc.w	$0002	;0002
	dc.w	$0304	;0304
	dc.w	$0005	;0005
	dc.w	$060C	;060C
	dc.w	$0506	;0506
	dc.w	$0E00	;0E00
	dc.w	$0506	;0506
	dc.w	$0E00	;0E00
	dc.w	$0B05	;0B05
	dc.w	$0708	;0708
	dc.w	$0506	;0506
	dc.w	$0007	;0007
	dc.w	$0000	;0000
	dc.w	$0008	;0008
	dc.w	$0504	;0504
	dc.w	$060C	;060C
	dc.w	$0B0D	;0B0D
	dc.w	$0E00	;0E00
	dc.w	$0105	;0105
	dc.w	$0606	;0606
	dc.w	$0605	;0605
	dc.w	$0606	;0606
	dc.w	$0506	;0506
	dc.w	$0B0D	;0B0D
	dc.w	$0005	;0005
	dc.w	$060D	;060D
	dc.w	$0004	;0004
	dc.w	$0E0C	;0E0C
	dc.w	$0B08	;0B08
	dc.w	$0E0D	;0E0D
	dc.w	$0008	;0008
	dc.w	$0E00	;0E00
	dc.w	$0E0E	;0E0E
	dc.w	$0E00	;0E00
	dc.w	$0E08	;0E08
	dc.w	$0E0B	;0E0B
	dc.w	$0002	;0002
	dc.w	$040E	;040E
	dc.w	$0000	;0000
	dc.w	$0007	;0007
	dc.w	$0708	;0708
	dc.w	$0400	;0400
	dc.w	$090A	;090A
	dc.w	$0B0B	;0B0B
	dc.w	$0B0A	;0B0A
	dc.w	$0B0B	;0B0B
	dc.w	$0A0B	;0A0B
	dc.w	$0708	;0708
	dc.w	$0004	;0004
	dc.w	$080C	;080C
	dc.w	$0708	;0708
	dc.w	$0D00	;0D00
	dc.w	$0B0D	;0B0D
	dc.w	$0E00	;0E00
	dc.w	$0804	;0804
	dc.w	$0D0B	;0D0B
	dc.w	$0B0C	;0B0C
	dc.w	$090B	;090B
	dc.w	$0708	;0708
	dc.w	$0D0C	;0D0C
	dc.w	$0007	;0007
	dc.w	$080D	;080D
	dc.w	$0000	;0000
	dc.w	$0005	;0005
	dc.w	$0708	;0708
	dc.w	$0D00	;0D00
	dc.w	$0506	;0506
	dc.w	$0E0B	;0E0B
	dc.w	$0B0D	;0B0D
	dc.w	$0B0E	;0B0E
	dc.w	$0A06	;0A06
	dc.w	$080D	;080D
	dc.w	$0004	;0004
	dc.w	$080C	;080C
	dc.w	$090C	;090C
	dc.w	$0000	;0000
	dc.w	$090C	;090C
	dc.w	$0B00	;0B00
	dc.w	$090C	;090C
	dc.w	$0B0B	;0B0B
	dc.w	$0B09	;0B09
	dc.w	$0C0B	;0C0B
	dc.w	$0A0C	;0A0C
	dc.w	$0C0C	;0C0C
	dc.w	$0009	;0009
	dc.w	$0C06	;0C06
	dc.w	$0203	;0203
	dc.w	$0000	;0000
	dc.w	$0203	;0203
	dc.w	$0400	;0400
	dc.w	$0203	;0203
	dc.w	$040B	;040B
	dc.w	$0B02	;0B02
	dc.w	$0304	;0304
	dc.w	$0303	;0303
	dc.w	$0303	;0303
	dc.w	$0002	;0002
	dc.w	$0407	;0407
	dc.w	$000D	;000D
	dc.w	$0E0B	;0E0B
	dc.w	$080D	;080D
	dc.w	$0E07	;0E07
	dc.w	$000D	;000D
	dc.w	$0E00	;0E00
	dc.w	$0E0D	;0E0D
	dc.w	$0E00	;0E00
	dc.w	$0E0D	;0E0D
	dc.w	$0E07	;0E07
	dc.w	$0002	;0002
	dc.w	$0D0E	;0D0E
	dc.w	$0708	;0708
	dc.w	$000C	;000C
	dc.w	$0506	;0506
	dc.w	$0E00	;0E00
	dc.w	$0A04	;0A04
	dc.w	$020B	;020B
	dc.w	$0B0A	;0B0A
	dc.w	$0B0B	;0B0B
	dc.w	$0703	;0703
	dc.w	$060B	;060B
	dc.w	$0007	;0007
	dc.w	$080C	;080C
	dc.w	$0804	;0804
	dc.w	$0409	;0409
	dc.w	$0708	;0708
	dc.w	$0400	;0400
	dc.w	$0708	;0708
	dc.w	$0400	;0400
	dc.w	$0408	;0408
	dc.w	$0404	;0404
	dc.w	$0708	;0708
	dc.w	$0708	;0708
	dc.w	$0008	;0008
	dc.w	$040D	;040D
	dc.w	$0F07	;0F07
	dc.w	$0F0F	;0F0F
	dc.w	$070F	;070F
	dc.w	$0F0F	;0F0F
	dc.w	$070F	;070F
	dc.w	$0F0F	;0F0F
	dc.w	$0707	;0707
	dc.w	$0F0F	;0F0F
	dc.w	$0707	;0707
	dc.w	$0707	;0707
	dc.w	$0001	;0001
	dc.w	$070C	;070C
	dc.w	$090C	;090C
	dc.w	$0B06	;0B06
	dc.w	$090A	;090A
	dc.w	$0B00	;0B00
	dc.w	$0708	;0708
	dc.w	$0D0B	;0D0B
	dc.w	$0B0D	;0B0D
	dc.w	$0B0E	;0B0E
	dc.w	$0A08	;0A08
	dc.w	$090D	;090D
	dc.w	$0009	;0009
	dc.w	$0C0B	;0C0B
	dc.w	$0204	;0204
	dc.w	$0409	;0409
	dc.w	$090C	;090C
	dc.w	$0D00	;0D00
	dc.w	$0708	;0708
	dc.w	$0404	;0404
	dc.w	$0402	;0402
	dc.w	$0404	;0404
	dc.w	$0308	;0308
	dc.w	$0C04	;0C04
	dc.w	$0002	;0002
	dc.w	$0304	;0304
	dc.w	$0708	;0708
	dc.w	$040C	;040C
	dc.w	$0708	;0708
	dc.w	$0400	;0400
	dc.w	$0708	;0708
	dc.w	$0400	;0400
	dc.w	$0404	;0404
	dc.w	$0804	;0804
	dc.w	$0708	;0708
	dc.w	$0400	;0400
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0105	;0105
	dc.w	$060D	;060D
	dc.w	$0105	;0105
	dc.w	$0600	;0600
	dc.w	$0105	;0105
	dc.w	$0600	;0600
	dc.w	$0606	;0606
	dc.w	$0506	;0506
	dc.w	$0105	;0105
	dc.w	$0600	;0600
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0A0B	;0A0B
	dc.w	$0D06	;0D06
	dc.w	$0A0B	;0A0B
	dc.w	$0D00	;0D00
	dc.w	$0A0B	;0A0B
	dc.w	$0D00	;0D00
	dc.w	$0D0D	;0D0D
	dc.w	$0B0D	;0B0D
	dc.w	$0A0B	;0A0B
	dc.w	$0D00	;0D00
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$090A	;090A
	dc.w	$0B0D	;0B0D
	dc.w	$090A	;090A
	dc.w	$0B00	;0B00
	dc.w	$090A	;090A
	dc.w	$0B00	;0B00
	dc.w	$0B0B	;0B0B
	dc.w	$0A0B	;0A0B
	dc.w	$090A	;090A
	dc.w	$0B00	;0B00
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$090C	;090C
	dc.w	$0B0E	;0B0E
	dc.w	$090C	;090C
	dc.w	$0B00	;0B00
	dc.w	$090C	;090C
	dc.w	$0B00	;0B00
	dc.w	$0B0B	;0B0B
	dc.w	$0C0B	;0C0B
	dc.w	$090C	;090C
	dc.w	$0B00	;0B00
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0708	;0708
	dc.w	$0000	;0000
	dc.w	$0708	;0708
	dc.w	$0D00	;0D00
	dc.w	$0708	;0708
	dc.w	$0D0B	;0D0B
	dc.w	$0B07	;0B07
	dc.w	$080D	;080D
	dc.w	$0808	;0808
	dc.w	$0808	;0808
	dc.w	$0007	;0007
	dc.w	$080A	;080A
	dc.w	$0B0D	;0B0D
	dc.w	$0000	;0000
	dc.w	$0B0D	;0B0D
	dc.w	$0E00	;0E00
	dc.w	$0B0D	;0B0D
	dc.w	$0E0B	;0E0B
	dc.w	$0B0B	;0B0B
	dc.w	$0D0E	;0D0E
	dc.w	$0D0D	;0D0D
	dc.w	$0D0D	;0D0D
	dc.w	$000B	;000B
	dc.w	$0D08	;0D08
	dc.w	$0A0B	;0A0B
	dc.w	$0000	;0000
	dc.w	$0A0B	;0A0B
	dc.w	$0D00	;0D00
	dc.w	$0A0B	;0A0B
	dc.w	$0D0B	;0D0B
	dc.w	$0B0A	;0B0A
	dc.w	$0B0D	;0B0D
	dc.w	$0B0B	;0B0B
	dc.w	$0B0B	;0B0B
	dc.w	$000A	;000A
	dc.w	$0B0C	;0B0C
	dc.w	$0C00	;0C00
	dc.w	$000C	;000C
	dc.w	$0B04	;0B04
	dc.w	$0D0C	;0D0C
	dc.w	$090C	;090C
	dc.w	$0D00	;0D00
	dc.w	$0B0B	;0B0B
	dc.w	$0D0B	;0D0B
	dc.w	$0D09	;0D09
	dc.w	$090C	;090C
	dc.w	$0009	;0009
	dc.w	$0C01	;0C01
	dc.w	$0809	;0809
	dc.w	$0C0C	;0C0C
	dc.w	$0504	;0504
	dc.w	$060C	;060C
	dc.w	$0304	;0304
	dc.w	$0E00	;0E00
	dc.w	$0B05	;0B05
	dc.w	$060B	;060B
	dc.w	$0602	;0602
	dc.w	$0804	;0804
	dc.w	$0008	;0008
	dc.w	$040C	;040C
	dc.w	$0C05	;0C05
	dc.w	$0605	;0605
	dc.w	$0203	;0203
	dc.w	$0400	;0400
	dc.w	$0204	;0204
	dc.w	$0E00	;0E00
	dc.w	$0B05	;0B05
	dc.w	$0605	;0605
	dc.w	$0204	;0204
	dc.w	$0C06	;0C06
	dc.w	$0009	;0009
	dc.w	$0C06	;0C06
	dc.w	$0502	;0502
	dc.w	$030C	;030C
	dc.w	$090A	;090A
	dc.w	$0B00	;0B00
	dc.w	$090A	;090A
	dc.w	$0B00	;0B00
	dc.w	$0B09	;0B09
	dc.w	$0C0C	;0C0C
	dc.w	$090A	;090A
	dc.w	$050C	;050C
	dc.w	$0005	;0005
	dc.w	$0603	;0603
	dc.w	$0307	;0307
	dc.w	$0808	;0808
	dc.w	$0B0D	;0B0D
	dc.w	$0E00	;0E00
	dc.w	$0B0D	;0B0D
	dc.w	$0E00	;0E00
	dc.w	$0B0B	;0B0B
	dc.w	$0C0C	;0C0C
	dc.w	$0B0D	;0B0D
	dc.w	$030C	;030C
	dc.w	$0002	;0002
	dc.w	$0408	;0408
	dc.w	$070D	;070D
	dc.w	$0B08	;0B08
	dc.w	$000D	;000D
	dc.w	$0808	;0808
	dc.w	$0B0D	;0B0D
	dc.w	$0E00	;0E00
	dc.w	$0B03	;0B03
	dc.w	$0D0D	;0D0D
	dc.w	$000D	;000D
	dc.w	$070C	;070C
	dc.w	$0007	;0007
	dc.w	$080D	;080D
	dc.w	$0204	;0204
	dc.w	$0409	;0409
	dc.w	$0708	;0708
	dc.w	$0400	;0400
	dc.w	$0B04	;0B04
	dc.w	$080B	;080B
	dc.w	$0402	;0402
	dc.w	$0404	;0404
	dc.w	$0708	;0708
	dc.w	$0301	;0301
	dc.w	$0002	;0002
	dc.w	$040E	;040E
	dc.w	$0A04	;0A04
	dc.w	$0B09	;0B09
	dc.w	$090C	;090C
	dc.w	$0B00	;0B00
	dc.w	$0B0B	;0B0B
	dc.w	$0C0B	;0C0B
	dc.w	$0B0A	;0B0A
	dc.w	$0B0B	;0B0B
	dc.w	$090C	;090C
	dc.w	$0B01	;0B01
	dc.w	$000A	;000A
	dc.w	$0B0C	;0B0C
	dc.w	$0C0B	;0C0B
	dc.w	$0007	;0007
	dc.w	$0506	;0506
	dc.w	$0D00	;0D00
	dc.w	$0B0D	;0B0D
	dc.w	$060B	;060B
	dc.w	$0B0C	;0B0C
	dc.w	$0B0B	;0B0B
	dc.w	$0506	;0506
	dc.w	$0B01	;0B01
	dc.w	$000C	;000C
	dc.w	$0B0D	;0B0D
	dc.w	$0804	;0804
	dc.w	$000C	;000C
	dc.w	$0A0B	;0A0B
	dc.w	$0D00	;0D00
	dc.w	$0B0D	;0B0D
	dc.w	$0B0B	;0B0B
	dc.w	$0807	;0807
	dc.w	$0808	;0808
	dc.w	$0B0D	;0B0D
	dc.w	$0801	;0801
	dc.w	$0008	;0008
	dc.w	$040D	;040D
	dc.w	$0208	;0208
	dc.w	$040C	;040C
	dc.w	$0803	;0803
	dc.w	$0404	;0404
	dc.w	$0B03	;0B03
	dc.w	$040B	;040B
	dc.w	$0B03	;0B03
	dc.w	$040E	;040E
	dc.w	$0403	;0403
	dc.w	$0408	;0408
	dc.w	$0002	;0002
	dc.w	$0804	;0804
	dc.w	$0A0B	;0A0B
	dc.w	$0D05	;0D05
	dc.w	$0A0A	;0A0A
	dc.w	$0B0C	;0B0C
	dc.w	$0B0A	;0B0A
	dc.w	$0B0B	;0B0B
	dc.w	$0B0A	;0B0A
	dc.w	$0B0E	;0B0E
	dc.w	$0B0A	;0B0A
	dc.w	$0B0C	;0B0C
	dc.w	$0009	;0009
	dc.w	$0A0B	;0A0B
	dc.w	$0B0D	;0B0D
	dc.w	$0E07	;0E07
	dc.w	$080B	;080B
	dc.w	$0D04	;0D04
	dc.w	$0B0B	;0B0B
	dc.w	$0D0B	;0D0B
	dc.w	$0B0B	;0B0B
	dc.w	$0D0E	;0D0E
	dc.w	$0D0B	;0D0B
	dc.w	$0D08	;0D08
	dc.w	$000A	;000A
	dc.w	$0B0D	;0B0D
	dc.w	$090C	;090C
	dc.w	$0B05	;0B05
	dc.w	$0509	;0509
	dc.w	$0C06	;0C06
	dc.w	$0B09	;0B09
	dc.w	$0C0B	;0C0B
	dc.w	$0B09	;0B09
	dc.w	$0C0B	;0C0B
	dc.w	$0C09	;0C09
	dc.w	$0C05	;0C05
	dc.w	$0009	;0009
	dc.w	$0C0B	;0C0B
	dc.w	$0708	;0708
	dc.w	$040A	;040A
	dc.w	$0A07	;0A07
	dc.w	$080B	;080B
	dc.w	$0B07	;0B07
	dc.w	$080B	;080B
	dc.w	$0B07	;0B07
	dc.w	$080E	;080E
	dc.w	$0807	;0807
	dc.w	$080A	;080A
	dc.w	$0007	;0007
	dc.w	$0804	;0804
	dc.w	$0506	;0506
	dc.w	$0D0C	;0D0C
	dc.w	$0905	;0905
	dc.w	$060A	;060A
	dc.w	$0B05	;0B05
	dc.w	$060B	;060B
	dc.w	$0B05	;0B05
	dc.w	$060E	;060E
	dc.w	$0605	;0605
	dc.w	$060A	;060A
	dc.w	$0005	;0005
	dc.w	$060D	;060D
	dc.w	$0A0B	;0A0B
	dc.w	$0007	;0007
	dc.w	$0804	;0804
	dc.w	$0D00	;0D00
	dc.w	$0506	;0506
	dc.w	$0D0B	;0D0B
	dc.w	$0B0A	;0B0A
	dc.w	$0B0B	;0B0B
	dc.w	$0A06	;0A06
	dc.w	$080B	;080B
	dc.w	$000A	;000A
	dc.w	$0B0C	;0B0C
	dc.w	$0504	;0504
	dc.w	$0609	;0609
	dc.w	$090C	;090C
	dc.w	$0B00	;0B00
	dc.w	$0105	;0105
	dc.w	$0600	;0600
	dc.w	$0605	;0605
	dc.w	$0606	;0606
	dc.w	$0506	;0506
	dc.w	$090C	;090C
	dc.w	$0005	;0005
	dc.w	$0604	;0604
	dc.w	$0506	;0506
	dc.w	$0007	;0007
	dc.w	$0804	;0804
	dc.w	$0D00	;0D00
	dc.w	$0105	;0105
	dc.w	$0600	;0600
	dc.w	$0605	;0605
	dc.w	$0606	;0606
	dc.w	$0506	;0506
	dc.w	$0804	;0804
	dc.w	$0005	;0005
	dc.w	$0604	;0604
	dc.w	$090C	;090C
	dc.w	$0007	;0007
	dc.w	$090C	;090C
	dc.w	$0D00	;0D00
	dc.w	$0B02	;0B02
	dc.w	$0D0B	;0D0B
	dc.w	$0B09	;0B09
	dc.w	$0C0B	;0C0B
	dc.w	$0C0D	;0C0D
	dc.w	$0C0C	;0C0C
	dc.w	$0009	;0009
	dc.w	$0C0C	;0C0C
	dc.w	$0105	;0105
	dc.w	$000C	;000C
	dc.w	$0804	;0804
	dc.w	$0D00	;0D00
	dc.w	$0B04	;0B04
	dc.w	$080B	;080B
	dc.w	$0B0D	;0B0D
	dc.w	$0B0E	;0B0E
	dc.w	$0608	;0608
	dc.w	$080D	;080D
	dc.w	$0001	;0001
	dc.w	$050C	;050C
	dc.w	$090C	;090C
	dc.w	$0B07	;0B07
	dc.w	$090C	;090C
	dc.w	$0D00	;0D00
	dc.w	$0B0D	;0B0D
	dc.w	$0E0B	;0E0B
	dc.w	$0B04	;0B04
	dc.w	$030E	;030E
	dc.w	$0C0D	;0C0D
	dc.w	$0C04	;0C04
	dc.w	$0009	;0009
	dc.w	$0C0B	;0C0B
	dc.w	$0506	;0506
	dc.w	$0D07	;0D07
	dc.w	$0708	;0708
	dc.w	$0D00	;0D00
	dc.w	$0203	;0203
	dc.w	$040B	;040B
	dc.w	$0B0C	;0B0C
	dc.w	$090B	;090B
	dc.w	$0604	;0604
	dc.w	$080C	;080C
	dc.w	$0005	;0005
	dc.w	$060D	;060D
	dc.w	$0804	;0804
	dc.w	$0D0C	;0D0C
	dc.w	$0203	;0203
	dc.w	$0400	;0400
	dc.w	$090A	;090A
	dc.w	$0B0B	;0B0B
	dc.w	$0B05	;0B05
	dc.w	$060D	;060D
	dc.w	$0809	;0809
	dc.w	$0306	;0306
	dc.w	$0002	;0002
	dc.w	$0804	;0804
	dc.w	$090A	;090A
	dc.w	$0B07	;0B07
	dc.w	$0506	;0506
	dc.w	$0D00	;0D00
	dc.w	$0C09	;0C09
	dc.w	$0B0B	;0B0B
	dc.w	$0B02	;0B02
	dc.w	$0304	;0304
	dc.w	$0A0C	;0A0C
	dc.w	$0604	;0604
	dc.w	$0009	;0009
	dc.w	$0A0B	;0A0B
	dc.w	$0009	;0009
	dc.w	$0A0B	;0A0B
	dc.w	$0708	;0708
	dc.w	$0E00	;0E00
	dc.w	$0203	;0203
	dc.w	$0407	;0407
	dc.w	$0B09	;0B09
	dc.w	$0A0B	;0A0B
	dc.w	$0902	;0902
	dc.w	$080A	;080A
	dc.w	$0009	;0009
	dc.w	$0A00	;0A00
	dc.w	$0007	;0007
	dc.w	$080D	;080D
	dc.w	$0708	;0708
	dc.w	$0D00	;0D00
	dc.w	$0708	;0708
	dc.w	$0D0C	;0D0C
	dc.w	$0B08	;0B08
	dc.w	$070D	;070D
	dc.w	$0707	;0707
	dc.w	$0707	;0707
	dc.w	$0007	;0007
	dc.w	$0800	;0800
	dc.w	$0008	;0008
	dc.w	$040D	;040D
	dc.w	$0804	;0804
	dc.w	$0D00	;0D00
	dc.w	$0804	;0804
	dc.w	$0D06	;0D06
	dc.w	$0B04	;0B04
	dc.w	$080D	;080D
	dc.w	$0808	;0808
	dc.w	$0808	;0808
	dc.w	$0008	;0008
	dc.w	$0400	;0400
	dc.w	$000B	;000B
	dc.w	$0D0E	;0D0E
	dc.w	$0203	;0203
	dc.w	$0400	;0400
	dc.w	$090A	;090A
	dc.w	$0B08	;0B08
	dc.w	$0B0B	;0B0B
	dc.w	$0A0B	;0A0B
	dc.w	$0D09	;0D09
	dc.w	$030B	;030B
	dc.w	$000B	;000B
	dc.w	$0D00	;0D00
	dc.w	$0B0D	;0B0D
	dc.w	$0C00	;0C00
	dc.w	$0304	;0304
	dc.w	$0E00	;0E00
	dc.w	$0506	;0506
	dc.w	$0D0B	;0D0B
	dc.w	$0B04	;0B04
	dc.w	$030E	;030E
	dc.w	$0D06	;0D06
	dc.w	$0404	;0404
	dc.w	$000B	;000B
	dc.w	$0D0C	;0D0C
	dc.w	$0506	;0506
	dc.w	$0A00	;0A00
	dc.w	$090A	;090A
	dc.w	$0B00	;0B00
	dc.w	$0B0D	;0B0D
	dc.w	$0E0B	;0E0B
	dc.w	$0B08	;0B08
	dc.w	$070E	;070E
	dc.w	$060D	;060D
	dc.w	$0908	;0908
	dc.w	$0005	;0005
	dc.w	$060A	;060A
	dc.w	$0203	;0203
	dc.w	$0400	;0400
	dc.w	$0203	;0203
	dc.w	$0400	;0400
	dc.w	$0203	;0203
	dc.w	$040B	;040B
	dc.w	$0B04	;0B04
	dc.w	$020E	;020E
	dc.w	$0303	;0303
	dc.w	$0304	;0304
	dc.w	$0002	;0002
	dc.w	$0403	;0403
	dc.w	$090C	;090C
	dc.w	$0600	;0600
	dc.w	$0506	;0506
	dc.w	$0D00	;0D00
	dc.w	$0A0B	;0A0B
	dc.w	$0D0B	;0D0B
	dc.w	$0B04	;0B04
	dc.w	$080E	;080E
	dc.w	$0C0B	;0C0B
	dc.w	$0608	;0608
	dc.w	$0009	;0009
	dc.w	$0C06	;0C06
	dc.w	$0004	;0004
	dc.w	$080C	;080C
	dc.w	$0C0B	;0C0B
	dc.w	$0D00	;0D00
	dc.w	$080D	;080D
	dc.w	$0E0B	;0E0B
	dc.w	$0B06	;0B06
	dc.w	$050D	;050D
	dc.w	$0A0D	;0A0D
	dc.w	$0B06	;0B06
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$050B	;050B
	dc.w	$0D0C	;0D0C
	dc.w	$0708	;0708
	dc.w	$0400	;0400
	dc.w	$0708	;0708
	dc.w	$0D00	;0D00
	dc.w	$0B0A	;0B0A
	dc.w	$0B0A	;0B0A
	dc.w	$0708	;0708
	dc.w	$050B	;050B
	dc.w	$0005	;0005
	dc.w	$060D	;060D
	dc.w	$0304	;0304
	dc.w	$0B06	;0B06
	dc.w	$0500	;0500
	dc.w	$0006	;0006
	dc.w	$0B00	;0B00
	dc.w	$000B	;000B
	dc.w	$0B00	;0B00
	dc.w	$0002	;0002
	dc.w	$0402	;0402
	dc.w	$0005	;0005
	dc.w	$0002	;0002
	dc.w	$030B	;030B
	dc.w	$0506	;0506
	dc.w	$0007	;0007
	dc.w	$050D	;050D
	dc.w	$0C06	;0C06
	dc.w	$0B0D	;0B0D
	dc.w	$0C0B	;0C0B
	dc.w	$0B0D	;0B0D
	dc.w	$0C0B	;0C0B
	dc.w	$060C	;060C
	dc.w	$0D05	;0D05
	dc.w	$0005	;0005
	dc.w	$060D	;060D
	dc.w	$060D	;060D
	dc.w	$0009	;0009
	dc.w	$030D	;030D
	dc.w	$0604	;0604
	dc.w	$0B0D	;0B0D
	dc.w	$060B	;060B
	dc.w	$0B0D	;0B0D
	dc.w	$060B	;060B
	dc.w	$0B06	;0B06
	dc.w	$0D03	;0D03
	dc.w	$0006	;0006
	dc.w	$0D0C	;0D0C
	dc.w	$0A0B	;0A0B
	dc.w	$0007	;0007
	dc.w	$090D	;090D
	dc.w	$080A	;080A
	dc.w	$0B0D	;0B0D
	dc.w	$080B	;080B
	dc.w	$0B0D	;0B0D
	dc.w	$080B	;080B
	dc.w	$0A08	;0A08
	dc.w	$0D09	;0D09
	dc.w	$000A	;000A
	dc.w	$0B0D	;0B0D
	dc.w	$0A0B	;0A0B
	dc.w	$000D	;000D
	dc.w	$020D	;020D
	dc.w	$0A05	;0A05
	dc.w	$0B0D	;0B0D
	dc.w	$0A0B	;0A0B
	dc.w	$0B0A	;0B0A
	dc.w	$0B0B	;0B0B
	dc.w	$0B0A	;0B0A
	dc.w	$0D05	;0D05
	dc.w	$000A	;000A
	dc.w	$0B0D	;0B0D
	dc.w	$0000	;0000
	dc.w	$0008	;0008
	dc.w	$0307	;0307
	dc.w	$0004	;0004
	dc.w	$0007	;0007
	dc.w	$0000	;0000
	dc.w	$0707	;0707
	dc.w	$0000	;0000
	dc.w	$0707	;0707
	dc.w	$0004	;0004
	dc.w	$0000	;0000
	dc.w	$010E	;010E
	dc.w	$000B	;000B
	dc.w	$0E0B	;0E0B
	dc.w	$020D	;020D
	dc.w	$0B04	;0B04
	dc.w	$000D	;000D
	dc.w	$0B00	;0B00
	dc.w	$0D0D	;0D0D
	dc.w	$0B00	;0B00
	dc.w	$0D0D	;0D0D
	dc.w	$0B04	;0B04
	dc.w	$000A	;000A
	dc.w	$0B0D	;0B0D
	dc.w	$0006	;0006
	dc.w	$0E00	;0E00
	dc.w	$090D	;090D
	dc.w	$060C	;060C
	dc.w	$000D	;000D
	dc.w	$0600	;0600
	dc.w	$060D	;060D
	dc.w	$0600	;0600
	dc.w	$060D	;060D
	dc.w	$0609	;0609
	dc.w	$0005	;0005
	dc.w	$060E	;060E
	dc.w	$0006	;0006
	dc.w	$0E0C	;0E0C
	dc.w	$0506	;0506
	dc.w	$0E06	;0E06
	dc.w	$0006	;0006
	dc.w	$0E00	;0E00
	dc.w	$0E06	;0E06
	dc.w	$0E00	;0E00
	dc.w	$0E06	;0E06
	dc.w	$0E06	;0E06
	dc.w	$0003	;0003
	dc.w	$060E	;060E
	dc.w	$000D	;000D
	dc.w	$0E0C	;0E0C
	dc.w	$080E	;080E
	dc.w	$0D0D	;0D0D
	dc.w	$000E	;000E
	dc.w	$0D00	;0D00
	dc.w	$0D0E	;0D0E
	dc.w	$0D00	;0D00
	dc.w	$0D0E	;0D0E
	dc.w	$0D08	;0D08
	dc.w	$000B	;000B
	dc.w	$0D0E	;0D0E
	dc.w	$0A04	;0A04
	dc.w	$0B0D	;0B0D
	dc.w	$0A0B	;0A0B
	dc.w	$0D00	;0D00
	dc.w	$060D	;060D
	dc.w	$0C0C	;0C0C
	dc.w	$0C09	;0C09
	dc.w	$0C0C	;0C0C
	dc.w	$0C0D	;0C0D
	dc.w	$0B0C	;0B0C
	dc.w	$000A	;000A
	dc.w	$0B0D	;0B0D
	dc.w	$0B0D	;0B0D
	dc.w	$0007	;0007
	dc.w	$030D	;030D
	dc.w	$0604	;0604
	dc.w	$0B0D	;0B0D
	dc.w	$060B	;060B
	dc.w	$0D0A	;0D0A
	dc.w	$0D0D	;0D0D
	dc.w	$0B06	;0B06
	dc.w	$0D03	;0D03
	dc.w	$000B	;000B
	dc.w	$0D0E	;0D0E
	dc.w	$090C	;090C
	dc.w	$0007	;0007
	dc.w	$0804	;0804
	dc.w	$0D00	;0D00
	dc.w	$0109	;0109
	dc.w	$0C00	;0C00
	dc.w	$0C09	;0C09
	dc.w	$0C0C	;0C0C
	dc.w	$090C	;090C
	dc.w	$0808	;0808
	dc.w	$0009	;0009
	dc.w	$0C0B	;0C0B
	dc.w	$0904	;0904
	dc.w	$0C07	;0C07
	dc.w	$0708	;0708
	dc.w	$0D00	;0D00
	dc.w	$0109	;0109
	dc.w	$0C00	;0C00
	dc.w	$0C0C	;0C0C
	dc.w	$090C	;090C
	dc.w	$090C	;090C
	dc.w	$0807	;0807
	dc.w	$0009	;0009
	dc.w	$0C0B	;0C0B
	dc.w	$0004	;0004
	dc.w	$050C	;050C
	dc.w	$0E04	;0E04
	dc.w	$0500	;0500
	dc.w	$0E04	;0E04
	dc.w	$0504	;0504
	dc.w	$0405	;0405
	dc.w	$040E	;040E
	dc.w	$0405	;0405
	dc.w	$0404	;0404
	dc.w	$0005	;0005
	dc.w	$0304	;0304
	dc.w	$000C	;000C
	dc.w	$090B	;090B
	dc.w	$0B0C	;0B0C
	dc.w	$0900	;0900
	dc.w	$0B0C	;0B0C
	dc.w	$090C	;090C
	dc.w	$0C09	;0C09
	dc.w	$0C0B	;0C0B
	dc.w	$0C09	;0C09
	dc.w	$0C09	;0C09
	dc.w	$0009	;0009
	dc.w	$0C0B	;0C0B
	dc.w	$000D	;000D
	dc.w	$0B0C	;0B0C
	dc.w	$0E0D	;0E0D
	dc.w	$0B00	;0B00
	dc.w	$0E0D	;0E0D
	dc.w	$0B0D	;0B0D
	dc.w	$0D0B	;0D0B
	dc.w	$0D0E	;0D0E
	dc.w	$0D0B	;0D0B
	dc.w	$0D0B	;0D0B
	dc.w	$000B	;000B
	dc.w	$0D0E	;0D0E
	dc.w	$000B	;000B
	dc.w	$0C00	;0C00
	dc.w	$0D0B	;0D0B
	dc.w	$0C00	;0C00
	dc.w	$0D0B	;0D0B
	dc.w	$0C0B	;0C0B
	dc.w	$0B0C	;0B0C
	dc.w	$0B0D	;0B0D
	dc.w	$0D0B	;0D0B
	dc.w	$0C0B	;0C0B
	dc.w	$000C	;000C
	dc.w	$0B0D	;0B0D
	dc.w	$000D	;000D
	dc.w	$060C	;060C
	dc.w	$0E0D	;0E0D
	dc.w	$0600	;0600
	dc.w	$0E0D	;0E0D
	dc.w	$060D	;060D
	dc.w	$0D06	;0D06
	dc.w	$0D0E	;0D0E
	dc.w	$0D06	;0D06
	dc.w	$0D06	;0D06
	dc.w	$0006	;0006
	dc.w	$0D0E	;0D0E
	dc.w	$000D	;000D
	dc.w	$050C	;050C
	dc.w	$0E0D	;0E0D
	dc.w	$0500	;0500
	dc.w	$0E0D	;0E0D
	dc.w	$050D	;050D
	dc.w	$0D05	;0D05
	dc.w	$0D0E	;0D0E
	dc.w	$0D05	;0D05
	dc.w	$0D0D	;0D0D
	dc.w	$0005	;0005
	dc.w	$0D0E	;0D0E

_GFX_HeadParts:
	INCBIN bw-gfx/HeadParts

_GFX_Bodies:
	INCBIN bw-gfx/BodyParts

_GFX_Avatars:
	INCBIN bext-gfx/AvatarsLarge

_GFX_ShieldAvatars:
	INCBIN bext-gfx/ShieldAvatars

_GFX_ShieldTop:
	INCBIN bext-gfx/ShieldTop

_GFX_ShieldBottom:
	INCBIN bext-gfx/ShieldBottom

_GFX_ShieldClasses:
	INCBIN bext-gfx/ShieldClasses

_GFX_Fairy:
	INCBIN bext-gfx/Fairy

_GFX_Summon:
	INCBIN bext-gfx/Summon

_GFX_Behemoth:
	INCBIN bext-gfx/Behemoth

_GFX_Crab:
	INCBIN bext-gfx/Crab

_GFX_CrabClaw:
	INCBIN bext-gfx/CrabClaw

_GFX_Beholder:
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
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFEF	;FFEF
	dc.w	$FFCF	;FFCF
	dc.w	$FFEF	;FFEF
	dc.w	$FFFF	;FFFF
	dc.w	$FFBF	;FFBF
	dc.w	$FFBF	;FFBF
	dc.w	$FFBF	;FFBF
	dc.w	$FFFF	;FFFF
	dc.w	$FFD7	;FFD7
	dc.w	$FFC7	;FFC7
	dc.w	$FFD7	;FFD7
	dc.w	$FFFF	;FFFF
	dc.w	$FF5F	;FF5F
	dc.w	$FF1F	;FF1F
	dc.w	$FF5F	;FF5F
	dc.w	$FFEF	;FFEF
	dc.w	$FFD3	;FFD3
	dc.w	$FFCB	;FFCB
	dc.w	$FFDB	;FFDB
	dc.w	$FFFF	;FFFF
	dc.w	$FF4F	;FF4F
	dc.w	$FF2F	;FF2F
	dc.w	$FF6F	;FF6F
	dc.w	$FFFF	;FFFF
	dc.w	$F2E9	;F2E9
	dc.w	$F4E5	;F4E5
	dc.w	$F6ED	;F6ED
	dc.w	$FFEF	;FFEF
	dc.w	$FFB7	;FFB7
	dc.w	$FF97	;FF97
	dc.w	$FFB7	;FFB7
	dc.w	$FDF7	;FDF7
	dc.w	$FA2C	;FA2C
	dc.w	$F920	;F920
	dc.w	$FB2C	;FB2C
	dc.w	$FFDF	;FFDF
	dc.w	$FFB3	;FFB3
	dc.w	$FF8B	;FF8B
	dc.w	$FFBB	;FFBB
	dc.w	$FEF7	;FEF7
	dc.w	$FD89	;FD89
	dc.w	$FC40	;FC40
	dc.w	$FDC9	;FDC9
	dc.w	$FFFF	;FFFF
	dc.w	$FFC3	;FFC3
	dc.w	$FFC3	;FFC3
	dc.w	$FFC3	;FFC3
	dc.w	$FF7B	;FF7B
	dc.w	$E2E0	;E2E0
	dc.w	$E201	;E201
	dc.w	$E2E5	;E2E5
	dc.w	$FFC3	;FFC3
	dc.w	$FF81	;FF81
	dc.w	$FFBD	;FFBD
	dc.w	$FF95	;FF95
	dc.w	$FFA3	;FFA3
	dc.w	$C840	;C840
	dc.w	$D409	;D409
	dc.w	$DC55	;DC55
	dc.w	$FF83	;FF83
	dc.w	$FF15	;FF15
	dc.w	$FF5D	;FF5D
	dc.w	$FF35	;FF35
	dc.w	$FBC7	;FBC7
	dc.w	$E683	;E683
	dc.w	$E128	;E128
	dc.w	$E793	;E793
	dc.w	$FF01	;FF01
	dc.w	$FE02	;FE02
	dc.w	$FE5E	;FE5E
	dc.w	$FEF6	;FEF6
	dc.w	$FE45	;FE45
	dc.w	$F983	;F983
	dc.w	$F818	;F818
	dc.w	$F9BB	;F9BB
	dc.w	$FF01	;FF01
	dc.w	$FE10	;FE10
	dc.w	$FEB2	;FEB2
	dc.w	$FE7E	;FE7E
	dc.w	$FF98	;FF98
	dc.w	$FE05	;FE05
	dc.w	$FE06	;FE06
	dc.w	$FE67	;FE67
	dc.w	$FE00	;FE00
	dc.w	$FC00	;FC00
	dc.w	$FD55	;FD55
	dc.w	$FCBB	;FCBB
	dc.w	$FF94	;FF94
	dc.w	$700A	;700A
	dc.w	$716B	;716B
	dc.w	$7122	;7122
	dc.w	$FE00	;FE00
	dc.w	$FC11	;FC11
	dc.w	$FCB7	;FCB7
	dc.w	$FDFB	;FDFB
	dc.w	$FC8E	;FC8E
	dc.w	$6B00	;6B00
	dc.w	$6411	;6411
	dc.w	$6F71	;6F71
	dc.w	$FC00	;FC00
	dc.w	$F800	;F800
	dc.w	$F959	;F959
	dc.w	$FBBF	;FBBF
	dc.w	$FFC2	;FFC2
	dc.w	$7000	;7000
	dc.w	$7034	;7034
	dc.w	$7019	;7019
	dc.w	$FC00	;FC00
	dc.w	$F810	;F810
	dc.w	$FA9A	;FA9A
	dc.w	$F97D	;F97D
	dc.w	$7FE0	;7FE0
	dc.w	$3FC1	;3FC1
	dc.w	$BFDF	;BFDF
	dc.w	$BFCB	;BFCB
	dc.w	$FC00	;FC00
	dc.w	$F800	;F800
	dc.w	$F953	;F953
	dc.w	$FBBD	;FBBD
	dc.w	$7FF2	;7FF2
	dc.w	$BFE0	;BFE0
	dc.w	$BFE5	;BFE5
	dc.w	$BFED	;BFED
	dc.w	$F800	;F800
	dc.w	$F010	;F010
	dc.w	$F2B8	;F2B8
	dc.w	$F77F	;F77F
	dc.w	$7FFA	;7FFA
	dc.w	$3FE1	;3FE1
	dc.w	$BFE1	;BFE1
	dc.w	$BFE5	;BFE5
	dc.w	$F800	;F800
	dc.w	$F000	;F000
	dc.w	$F555	;F555
	dc.w	$F2FA	;F2FA
	dc.w	$3FF8	;3FF8
	dc.w	$1FE1	;1FE1
	dc.w	$5FE3	;5FE3
	dc.w	$DFE7	;DFE7
	dc.w	$F000	;F000
	dc.w	$E010	;E010
	dc.w	$EAB9	;EAB9
	dc.w	$E77E	;E77E
	dc.w	$3FF4	;3FF4
	dc.w	$5FE1	;5FE1
	dc.w	$DFE9	;DFE9
	dc.w	$DFE3	;DFE3
	dc.w	$F000	;F000
	dc.w	$E020	;E020
	dc.w	$E574	;E574
	dc.w	$EEFB	;EEFB
	dc.w	$3FF7	;3FF7
	dc.w	$1FE0	;1FE0
	dc.w	$5FE8	;5FE8
	dc.w	$DFE0	;DFE0
	dc.w	$F000	;F000
	dc.w	$E000	;E000
	dc.w	$EAA2	;EAA2
	dc.w	$E57D	;E57D
	dc.w	$1FE5	;1FE5
	dc.w	$0FC0	;0FC0
	dc.w	$AFD8	;AFD8
	dc.w	$6FC3	;6FC3
	dc.w	$E000	;E000
	dc.w	$C020	;C020
	dc.w	$D574	;D574
	dc.w	$CEFB	;CEFB
	dc.w	$1FE2	;1FE2
	dc.w	$2FC0	;2FC0
	dc.w	$EFDD	;EFDD
	dc.w	$6FC1	;6FC1
	dc.w	$E000	;E000
	dc.w	$C000	;C000
	dc.w	$CAAA	;CAAA
	dc.w	$DD7D	;DD7D
	dc.w	$1FE1	;1FE1
	dc.w	$0FC0	;0FC0
	dc.w	$2FD6	;2FD6
	dc.w	$EFC8	;EFC8
	dc.w	$E002	;E002
	dc.w	$C020	;C020
	dc.w	$D175	;D175
	dc.w	$CEF8	;CEF8
	dc.w	$0FE0	;0FE0
	dc.w	$07C0	;07C0
	dc.w	$57DA	;57DA
	dc.w	$B7C5	;B7C5
	dc.w	$C100	;C100
	dc.w	$8000	;8000
	dc.w	$AA22	;AA22
	dc.w	$9CFD	;9CFD
	dc.w	$0FC0	;0FC0
	dc.w	$1781	;1781
	dc.w	$77B5	;77B5
	dc.w	$B78B	;B78B
	dc.w	$C002	;C002
	dc.w	$8020	;8020
	dc.w	$9575	;9575
	dc.w	$BAF8	;BAF8
	dc.w	$07C0	;07C0
	dc.w	$0300	;0300
	dc.w	$1B2B	;1B2B
	dc.w	$FB17	;FB17
	dc.w	$C101	;C101
	dc.w	$8000	;8000
	dc.w	$A2A2	;A2A2
	dc.w	$9C7C	;9C7C
	dc.w	$0740	;0740
	dc.w	$1201	;1201
	dc.w	$7AB1	;7AB1
	dc.w	$BA0F	;BA0F
	dc.w	$C302	;C302
	dc.w	$8020	;8020
	dc.w	$9475	;9475
	dc.w	$B8F8	;B8F8
	dc.w	$0740	;0740
	dc.w	$0800	;0800
	dc.w	$38A3	;38A3
	dc.w	$D81F	;D81F
	dc.w	$8783	;8783
	dc.w	$0300	;0300
	dc.w	$2328	;2328
	dc.w	$7B74	;7B74
	dc.w	$0280	;0280
	dc.w	$0401	;0401
	dc.w	$8D57	;8D57
	dc.w	$7C2F	;7C2F
	dc.w	$8F87	;8F87
	dc.w	$0723	;0723
	dc.w	$4773	;4773
	dc.w	$377B	;377B
	dc.w	$8280	;8280
	dc.w	$0802	;0802
	dc.w	$3D63	;3D63
	dc.w	$5C1F	;5C1F
	dc.w	$8F8F	;8F8F
	dc.w	$0707	;0707
	dc.w	$2727	;2727
	dc.w	$7777	;7777
	dc.w	$8280	;8280
	dc.w	$0401	;0401
	dc.w	$4D57	;4D57
	dc.w	$3C2F	;3C2F
	dc.w	$9FCF	;9FCF
	dc.w	$0FA7	;0FA7
	dc.w	$4FA7	;4FA7
	dc.w	$2FB7	;2FB7
	dc.w	$C180	;C180
	dc.w	$0802	;0802
	dc.w	$2C23	;2C23
	dc.w	$1A5F	;1A5F
	dc.w	$9FDF	;9FDF
	dc.w	$0F8E	;0F8E
	dc.w	$2FAE	;2FAE
	dc.w	$6FAE	;6FAE
	dc.w	$2100	;2100
	dc.w	$0001	;0001
	dc.w	$48C7	;48C7
	dc.w	$963F	;963F
	dc.w	$BFFE	;BFFE
	dc.w	$1FFC	;1FFC
	dc.w	$5FFC	;5FFC
	dc.w	$1FFD	;1FFD
	dc.w	$2E80	;2E80
	dc.w	$0002	;0002
	dc.w	$912F	;912F
	dc.w	$405F	;405F
	dc.w	$BFFF	;BFFF
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$5FFF	;5FFF
	dc.w	$F500	;F500
	dc.w	$E005	;E005
	dc.w	$EA47	;EA47
	dc.w	$E0BF	;E0BF
	dc.w	$FFFF	;FFFF
	dc.w	$BFFF	;BFFF
	dc.w	$BFFF	;BFFF
	dc.w	$BFFF	;BFFF
	dc.w	$EA00	;EA00
	dc.w	$E002	;E002
	dc.w	$F48F	;F48F
	dc.w	$E17F	;E17F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F000	;F000
	dc.w	$E005	;E005
	dc.w	$E557	;E557
	dc.w	$EABF	;EABF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$E800	;E800
	dc.w	$E002	;E002
	dc.w	$E22F	;E22F
	dc.w	$F5FF	;F5FF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$E400	;E400
	dc.w	$E005	;E005
	dc.w	$F15F	;F15F
	dc.w	$FAFF	;FAFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$E000	;E000
	dc.w	$E00B	;E00B
	dc.w	$EABF	;EABF
	dc.w	$FDFF	;FDFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$E000	;E000
	dc.w	$E005	;E005
	dc.w	$F45F	;F45F
	dc.w	$FBFF	;FBFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$E000	;E000
	dc.w	$E00B	;E00B
	dc.w	$E8BF	;E8BF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$E000	;E000
	dc.w	$E015	;E015
	dc.w	$F5FF	;F5FF
	dc.w	$EBFF	;EBFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$9000	;9000
	dc.w	$002B	;002B
	dc.w	$6AFF	;6AFF
	dc.w	$07FF	;07FF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$8800	;8800
	dc.w	$0157	;0157
	dc.w	$35FF	;35FF
	dc.w	$47FF	;47FF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFC	;FFFC
	dc.w	$FFFC	;FFFC
	dc.w	$FFFC	;FFFC
	dc.w	$6400	;6400
	dc.w	$00AB	;00AB
	dc.w	$0BFF	;0BFF
	dc.w	$93FF	;93FF
	dc.w	$FFFF	;FFFF
	dc.w	$FFF8	;FFF8
	dc.w	$FFF9	;FFF9
	dc.w	$FFF9	;FFF9
	dc.w	$E700	;E700
	dc.w	$005F	;005F
	dc.w	$58FF	;58FF
	dc.w	$40FF	;40FF
	dc.w	$FFFF	;FFFF
	dc.w	$FFF0	;FFF0
	dc.w	$FFF5	;FFF5
	dc.w	$FFF5	;FFF5
	dc.w	$DFC0	;DFC0
	dc.w	$270F	;270F
	dc.w	$473F	;473F
	dc.w	$673F	;673F
	dc.w	$FFFF	;FFFF
	dc.w	$FFF5	;FFF5
	dc.w	$FFF0	;FFF0
	dc.w	$FFF5	;FFF5
	dc.w	$FFFF	;FFFF
	dc.w	$4FC0	;4FC0
	dc.w	$0FC0	;0FC0
	dc.w	$4FC0	;4FC0
	dc.w	$FFFF	;FFFF
	dc.w	$FFFA	;FFFA
	dc.w	$FFFA	;FFFA
	dc.w	$FFFA	;FFFA
	dc.w	$FFFF	;FFFF
	dc.w	$BFFF	;BFFF
	dc.w	$BFFF	;BFFF
	dc.w	$BFFF	;BFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$5FFF	;5FFF
	dc.w	$1FFF	;1FFF
	dc.w	$5FFF	;5FFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFF	;FFFF
	dc.w	$3FFF	;3FFF
	dc.w	$BFFF	;BFFF
	dc.w	$BFFF	;BFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFC	;FFFC
	dc.w	$FFFC	;FFFC
	dc.w	$FFFC	;FFFC
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFC	;FFFC
	dc.w	$FFFD	;FFFD
	dc.w	$FFFD	;FFFD
	dc.w	$7FFF	;7FFF
	dc.w	$BC9F	;BC9F
	dc.w	$3C5F	;3C5F
	dc.w	$BCDF	;BCDF
	dc.w	$FFFF	;FFFF
	dc.w	$FFF2	;FFF2
	dc.w	$FFF0	;FFF0
	dc.w	$FFF2	;FFF2
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFE	;FFFE
	dc.w	$FFFB	;FFFB
	dc.w	$FFF8	;FFF8
	dc.w	$FFFB	;FFFB
	dc.w	$FFFF	;FFFF
	dc.w	$723F	;723F
	dc.w	$713F	;713F
	dc.w	$733F	;733F
	dc.w	$FFFD	;FFFD
	dc.w	$FFEA	;FFEA
	dc.w	$FFE4	;FFE4
	dc.w	$FFEE	;FFEE
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFC	;FFFC
	dc.w	$FFFB	;FFFB
	dc.w	$FFF8	;FFF8
	dc.w	$FFFB	;FFFB
	dc.w	$FDFF	;FDFF
	dc.w	$4AFF	;4AFF
	dc.w	$44FF	;44FF
	dc.w	$4EFF	;4EFF
	dc.w	$FFFB	;FFFB
	dc.w	$FFD5	;FFD5
	dc.w	$FFC9	;FFC9
	dc.w	$FFDD	;FFDD
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFB	;FFFB
	dc.w	$EFF4	;EFF4
	dc.w	$EFF4	;EFF4
	dc.w	$EFF4	;EFF4
	dc.w	$F7FF	;F7FF
	dc.w	$A9FF	;A9FF
	dc.w	$91FF	;91FF
	dc.w	$B9FF	;B9FF
	dc.w	$FFF7	;FFF7
	dc.w	$FFAB	;FFAB
	dc.w	$FF93	;FF93
	dc.w	$FFBB	;FFBB
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFF0	;FFF0
	dc.w	$D3E8	;D3E8
	dc.w	$C3ED	;C3ED
	dc.w	$D3EE	;D3EE
	dc.w	$8FFF	;8FFF
	dc.w	$761F	;761F
	dc.w	$061F	;061F
	dc.w	$761F	;761F
	dc.w	$FFE7	;FFE7
	dc.w	$FF3B	;FF3B
	dc.w	$FF03	;FF03
	dc.w	$FF3B	;FF3B
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F87F	;F87F
	dc.w	$F87F	;F87F
	dc.w	$F87F	;F87F
	dc.w	$FFF0	;FFF0
	dc.w	$E4E0	;E4E0
	dc.w	$E8EB	;E8EB
	dc.w	$ECEC	;ECEC
	dc.w	$7FFF	;7FFF
	dc.w	$014F	;014F
	dc.w	$00AF	;00AF
	dc.w	$81EF	;81EF
	dc.w	$FF3F	;FF3F
	dc.w	$FE87	;FE87
	dc.w	$FE87	;FE87
	dc.w	$FEC7	;FEC7
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F87F	;F87F
	dc.w	$E03F	;E03F
	dc.w	$E5BF	;E5BF
	dc.w	$E3BF	;E3BF
	dc.w	$FEE0	;FEE0
	dc.w	$F301	;F301
	dc.w	$F413	;F413
	dc.w	$F71D	;F71D
	dc.w	$1E7F	;1E7F
	dc.w	$0B9F	;0B9F
	dc.w	$A41F	;A41F
	dc.w	$CF9F	;CF9F
	dc.w	$FE07	;FE07
	dc.w	$FD03	;FD03
	dc.w	$FD8B	;FD8B
	dc.w	$FDF3	;FDF3
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$E1FF	;E1FF
	dc.w	$C07F	;C07F
	dc.w	$D67F	;D67F
	dc.w	$CE7F	;CE7F
	dc.w	$FD80	;FD80
	dc.w	$FA42	;FA42
	dc.w	$F86F	;F86F
	dc.w	$FA73	;FA73
	dc.w	$11FF	;11FF
	dc.w	$0E7F	;0E7F
	dc.w	$607F	;607F
	dc.w	$AE7F	;AE7F
	dc.w	$FC07	;FC07
	dc.w	$FA03	;FA03
	dc.w	$FB63	;FB63
	dc.w	$FBBB	;FBBB
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$C7FF	;C7FF
	dc.w	$81FF	;81FF
	dc.w	$A9FF	;A9FF
	dc.w	$99FF	;99FF
	dc.w	$FE30	;FE30
	dc.w	$FD00	;FD00
	dc.w	$FD8B	;FD8B
	dc.w	$FDC6	;FDC6
	dc.w	$0FFF	;0FFF
	dc.w	$40FF	;40FF
	dc.w	$D0FF	;D0FF
	dc.w	$60FF	;60FF
	dc.w	$F803	;F803
	dc.w	$F001	;F001
	dc.w	$F655	;F655
	dc.w	$F7AD	;F7AD
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$8FFF	;8FFF
	dc.w	$07FF	;07FF
	dc.w	$57FF	;57FF
	dc.w	$37FF	;37FF
	dc.w	$FEA0	;FEA0
	dc.w	$F841	;F841
	dc.w	$F857	;F857
	dc.w	$F90D	;F90D
	dc.w	$07FF	;07FF
	dc.w	$021F	;021F
	dc.w	$E91F	;E91F
	dc.w	$931F	;931F
	dc.w	$F801	;F801
	dc.w	$F400	;F400
	dc.w	$F4AA	;F4AA
	dc.w	$F776	;F776
	dc.w	$FFFF	;FFFF
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$1FFF	;1FFF
	dc.w	$0FFF	;0FFF
	dc.w	$AFFF	;AFFF
	dc.w	$6FFF	;6FFF
	dc.w	$F9C0	;F9C0
	dc.w	$F010	;F010
	dc.w	$F63E	;F63E
	dc.w	$F419	;F419
	dc.w	$08FF	;08FF
	dc.w	$278F	;278F
	dc.w	$306F	;306F
	dc.w	$F7EF	;F7EF
	dc.w	$F000	;F000
	dc.w	$E800	;E800
	dc.w	$ED55	;ED55
	dc.w	$EEBB	;EEBB
	dc.w	$FFFE	;FFFE
	dc.w	$7FFC	;7FFC
	dc.w	$7FFD	;7FFD
	dc.w	$7FFC	;7FFC
	dc.w	$1FFF	;1FFF
	dc.w	$2FFF	;2FFF
	dc.w	$6FFF	;6FFF
	dc.w	$EFFF	;EFFF
	dc.w	$F002	;F002
	dc.w	$E820	;E820
	dc.w	$EB3D	;EB3D
	dc.w	$ECF0	;ECF0
	dc.w	$07FF	;07FF
	dc.w	$001F	;001F
	dc.w	$581F	;581F
	dc.w	$E01F	;E01F
	dc.w	$E000	;E000
	dc.w	$C000	;C000
	dc.w	$DA82	;DA82
	dc.w	$DD7D	;DD7D
	dc.w	$7FFE	;7FFE
	dc.w	$1FFC	;1FFC
	dc.w	$9FFC	;9FFC
	dc.w	$9FFD	;9FFD
	dc.w	$3FFF	;3FFF
	dc.w	$5FFF	;5FFF
	dc.w	$DFFF	;DFFF
	dc.w	$DFFF	;DFFF
	dc.w	$E005	;E005
	dc.w	$D000	;D000
	dc.w	$D5FA	;D5FA
	dc.w	$DB80	;DB80
	dc.w	$C7FF	;C7FF
	dc.w	$03FF	;03FF
	dc.w	$2BFF	;2BFF
	dc.w	$33FF	;33FF
	dc.w	$E000	;E000
	dc.w	$D000	;D000
	dc.w	$DB55	;DB55
	dc.w	$DDBA	;DDBA
	dc.w	$1FFC	;1FFC
	dc.w	$0FF8	;0FF8
	dc.w	$2FFB	;2FFB
	dc.w	$EFF8	;EFF8
	dc.w	$3FFF	;3FFF
	dc.w	$1FFF	;1FFF
	dc.w	$5FFF	;5FFF
	dc.w	$DFFF	;DFFF
	dc.w	$C862	;C862
	dc.w	$A000	;A000
	dc.w	$A284	;A284
	dc.w	$B719	;B719
	dc.w	$2BFF	;2BFF
	dc.w	$01FF	;01FF
	dc.w	$95FF	;95FF
	dc.w	$C1FF	;C1FF
	dc.w	$C000	;C000
	dc.w	$8000	;8000
	dc.w	$B68A	;B68A
	dc.w	$BB7D	;BB7D
	dc.w	$0FFC	;0FFC
	dc.w	$17F8	;17F8
	dc.w	$D7FA	;D7FA
	dc.w	$37F9	;37F9
	dc.w	$3FFF	;3FFF
	dc.w	$5FFF	;5FFF
	dc.w	$DFFF	;DFFF
	dc.w	$DFFF	;DFFF
	dc.w	$D1C7	;D1C7
	dc.w	$8002	;8002
	dc.w	$A62A	;A62A
	dc.w	$A832	;A832
	dc.w	$11FF	;11FF
	dc.w	$00FF	;00FF
	dc.w	$C6FF	;C6FF
	dc.w	$E8FF	;E8FF
	dc.w	$C000	;C000
	dc.w	$A000	;A000
	dc.w	$B551	;B551
	dc.w	$BABE	;BABE
	dc.w	$07F8	;07F8
	dc.w	$03F0	;03F0
	dc.w	$2BF5	;2BF5
	dc.w	$DBF2	;DBF2
	dc.w	$3FFF	;3FFF
	dc.w	$1FFF	;1FFF
	dc.w	$5FFF	;5FFF
	dc.w	$DFFF	;DFFF
	dc.w	$8FCF	;8FCF
	dc.w	$4187	;4187
	dc.w	$41B7	;41B7
	dc.w	$71A7	;71A7
	dc.w	$81FF	;81FF
	dc.w	$00FF	;00FF
	dc.w	$2AFF	;2AFF
	dc.w	$74FF	;74FF
	dc.w	$8000	;8000
	dc.w	$0000	;0000
	dc.w	$6889	;6889
	dc.w	$777E	;777E
	dc.w	$03F8	;03F8
	dc.w	$05F0	;05F0
	dc.w	$B5F6	;B5F6
	dc.w	$6DF1	;6DF1
	dc.w	$3FFF	;3FFF
	dc.w	$5FFF	;5FFF
	dc.w	$DFFF	;DFFF
	dc.w	$DFFF	;DFFF
	dc.w	$9F8F	;9F8F
	dc.w	$0F07	;0F07
	dc.w	$6F57	;6F57
	dc.w	$4F67	;4F67
	dc.w	$C0FF	;C0FF
	dc.w	$807F	;807F
	dc.w	$957F	;957F
	dc.w	$BA7F	;BA7F
	dc.w	$8000	;8000
	dc.w	$4008	;4008
	dc.w	$6DDC	;6DDC
	dc.w	$763F	;763F
	dc.w	$01F8	;01F8
	dc.w	$02F0	;02F0
	dc.w	$CAF5	;CAF5
	dc.w	$36F2	;36F2
	dc.w	$1FFF	;1FFF
	dc.w	$2FFF	;2FFF
	dc.w	$6FFF	;6FFF
	dc.w	$EFFF	;EFFF
	dc.w	$FF1F	;FF1F
	dc.w	$9E0F	;9E0F
	dc.w	$9EAF	;9EAF
	dc.w	$9ECF	;9ECF
	dc.w	$C0FF	;C0FF
	dc.w	$807E	;807E
	dc.w	$A37E	;A37E
	dc.w	$BC7E	;BC7E
	dc.w	$0000	;0000
	dc.w	$8000	;8000
	dc.w	$CA88	;CA88
	dc.w	$F57F	;F57F
	dc.w	$00F8	;00F8
	dc.w	$0170	;0170
	dc.w	$ED76	;ED76
	dc.w	$1B71	;1B71
	dc.w	$1FFF	;1FFF
	dc.w	$0FFF	;0FFF
	dc.w	$2FFF	;2FFF
	dc.w	$EFFF	;EFFF
	dc.w	$FF3F	;FF3F
	dc.w	$FE1F	;FE1F
	dc.w	$FE5F	;FE5F
	dc.w	$FE9F	;FE9F
	dc.w	$C0FF	;C0FF
	dc.w	$807E	;807E
	dc.w	$B57E	;B57E
	dc.w	$BA7E	;BA7E
	dc.w	$0080	;0080
	dc.w	$0008	;0008
	dc.w	$915D	;915D
	dc.w	$EE3E	;EE3E
	dc.w	$007C	;007C
	dc.w	$00B8	;00B8
	dc.w	$52BB	;52BB
	dc.w	$ADB8	;ADB8
	dc.w	$0FFF	;0FFF
	dc.w	$17FF	;17FF
	dc.w	$57FF	;57FF
	dc.w	$F7FF	;F7FF
	dc.w	$FE7F	;FE7F
	dc.w	$FC3F	;FC3F
	dc.w	$FCBF	;FCBF
	dc.w	$FD3F	;FD3F
	dc.w	$C0FE	;C0FE
	dc.w	$807C	;807C
	dc.w	$A37D	;A37D
	dc.w	$BC7D	;BC7D
	dc.w	$0000	;0000
	dc.w	$0004	;0004
	dc.w	$9BAE	;9BAE
	dc.w	$EC5F	;EC5F
	dc.w	$003C	;003C
	dc.w	$0058	;0058
	dc.w	$EB5A	;EB5A
	dc.w	$16D9	;16D9
	dc.w	$0FFF	;0FFF
	dc.w	$17FF	;17FF
	dc.w	$B7FF	;B7FF
	dc.w	$77FF	;77FF
	dc.w	$FFFF	;FFFF
	dc.w	$FE7F	;FE7F
	dc.w	$FE7F	;FE7F
	dc.w	$FE7F	;FE7F
	dc.w	$81FE	;81FE
	dc.w	$00FD	;00FD
	dc.w	$46FD	;46FD
	dc.w	$78FD	;78FD
	dc.w	$0080	;0080
	dc.w	$0000	;0000
	dc.w	$B544	;B544
	dc.w	$DA3F	;DA3F
	dc.w	$201E	;201E
	dc.w	$000C	;000C
	dc.w	$50AD	;50AD
	dc.w	$8F6C	;8F6C
	dc.w	$07FF	;07FF
	dc.w	$0BFF	;0BFF
	dc.w	$1BFF	;1BFF
	dc.w	$FBFF	;FBFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$01FC	;01FC
	dc.w	$00FA	;00FA
	dc.w	$8AFB	;8AFB
	dc.w	$F4FB	;F4FB
	dc.w	$0000	;0000
	dc.w	$0004	;0004
	dc.w	$23AE	;23AE
	dc.w	$DC5F	;DC5F
	dc.w	$100E	;100E
	dc.w	$0014	;0014
	dc.w	$AAD5	;AAD5
	dc.w	$45B4	;45B4
	dc.w	$07FF	;07FF
	dc.w	$03FF	;03FF
	dc.w	$ABFF	;ABFF
	dc.w	$7BFF	;7BFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$03F8	;03F8
	dc.w	$81F0	;81F0
	dc.w	$D5F7	;D5F7
	dc.w	$E9F7	;E9F7
	dc.w	$0080	;0080
	dc.w	$0000	;0000
	dc.w	$4744	;4744
	dc.w	$B83F	;B83F
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$7C29	;7C29
	dc.w	$83D8	;83D8
	dc.w	$03FF	;03FF
	dc.w	$09FF	;09FF
	dc.w	$5DFF	;5DFF
	dc.w	$BDFF	;BDFF
	dc.w	$FFFE	;FFFE
	dc.w	$FFFD	;FFFD
	dc.w	$FFFD	;FFFD
	dc.w	$FFFD	;FFFD
	dc.w	$03F8	;03F8
	dc.w	$01F4	;01F4
	dc.w	$8DF6	;8DF6
	dc.w	$F1F7	;F1F7
	dc.w	$0100	;0100
	dc.w	$0004	;0004
	dc.w	$4AAE	;4AAE
	dc.w	$B45F	;B45F
	dc.w	$1002	;1002
	dc.w	$0000	;0000
	dc.w	$2AB5	;2AB5
	dc.w	$C56C	;C56C
	dc.w	$03FF	;03FF
	dc.w	$05FF	;05FF
	dc.w	$8DFF	;8DFF
	dc.w	$7DFF	;7DFF
	dc.w	$FFFC	;FFFC
	dc.w	$FFFA	;FFFA
	dc.w	$FFFB	;FFFB
	dc.w	$FFFB	;FFFB
	dc.w	$07F0	;07F0
	dc.w	$03E8	;03E8
	dc.w	$1BEE	;1BEE
	dc.w	$E3EF	;E3EF
	dc.w	$0080	;0080
	dc.w	$0002	;0002
	dc.w	$D747	;D747
	dc.w	$683F	;683F
	dc.w	$0801	;0801
	dc.w	$0000	;0000
	dc.w	$750A	;750A
	dc.w	$82F6	;82F6
	dc.w	$03FF	;03FF
	dc.w	$09FF	;09FF
	dc.w	$DDFF	;DDFF
	dc.w	$3DFF	;3DFF
	dc.w	$FFFC	;FFFC
	dc.w	$FFFA	;FFFA
	dc.w	$FFFA	;FFFA
	dc.w	$FFFB	;FFFB
	dc.w	$07E0	;07E0
	dc.w	$03C8	;03C8
	dc.w	$ABDD	;ABDD
	dc.w	$D3DE	;D3DE
	dc.w	$07C0	;07C0
	dc.w	$0000	;0000
	dc.w	$882A	;882A
	dc.w	$F01F	;F01F
	dc.w	$0FC0	;0FC0
	dc.w	$0000	;0000
	dc.w	$300D	;300D
	dc.w	$C03B	;C03B
	dc.w	$83FF	;83FF
	dc.w	$05FF	;05FF
	dc.w	$0DFF	;0DFF
	dc.w	$7DFF	;7DFF
	dc.w	$FFF8	;FFF8
	dc.w	$FFF4	;FFF4
	dc.w	$FFF7	;FFF7
	dc.w	$FFF7	;FFF7
	dc.w	$07C0	;07C0
	dc.w	$0390	;0390
	dc.w	$1BBA	;1BBA
	dc.w	$E3BD	;E3BD
	dc.w	$3AB0	;3AB0
	dc.w	$0002	;0002
	dc.w	$0547	;0547
	dc.w	$C00F	;C00F
	dc.w	$1FF0	;1FF0
	dc.w	$0FC0	;0FC0
	dc.w	$4FC6	;4FC6
	dc.w	$AFCD	;AFCD
	dc.w	$83FF	;83FF
	dc.w	$09FF	;09FF
	dc.w	$5DFF	;5DFF
	dc.w	$3DFF	;3DFF
	dc.w	$FFF0	;FFF0
	dc.w	$FFE8	;FFE8
	dc.w	$FFEE	;FFEE
	dc.w	$FFEF	;FFEF
	dc.w	$0780	;0780
	dc.w	$0320	;0320
	dc.w	$3B76	;3B76
	dc.w	$C37B	;C37B
	dc.w	$5558	;5558
	dc.w	$0000	;0000
	dc.w	$2AA2	;2AA2
	dc.w	$8007	;8007
	dc.w	$2FFC	;2FFC
	dc.w	$03C0	;03C0
	dc.w	$13C1	;13C1
	dc.w	$C3C2	;C3C2
	dc.w	$43FF	;43FF
	dc.w	$05FF	;05FF
	dc.w	$ADFF	;ADFF
	dc.w	$BDFF	;BDFF
	dc.w	$FFE0	;FFE0
	dc.w	$FFD0	;FFD0
	dc.w	$FFDD	;FFDD
	dc.w	$FFDF	;FFDF
	dc.w	$0B01	;0B01
	dc.w	$0040	;0040
	dc.w	$54E8	;54E8
	dc.w	$A0F6	;A0F6
	dc.w	$AA28	;AA28
	dc.w	$0002	;0002
	dc.w	$55D7	;55D7
	dc.w	$0007	;0007
	dc.w	$53F2	;53F2
	dc.w	$0000	;0000
	dc.w	$2C0C	;2C0C
	dc.w	$8001	;8001
	dc.w	$23FF	;23FF
	dc.w	$09FF	;09FF
	dc.w	$DDFF	;DDFF
	dc.w	$5DFF	;5DFF
	dc.w	$FFE0	;FFE0
	dc.w	$FFD0	;FFD0
	dc.w	$FFDA	;FFDA
	dc.w	$FFDF	;FFDF
	dc.w	$0507	;0507
	dc.w	$0000	;0000
	dc.w	$3AD8	;3AD8
	dc.w	$C0E0	;C0E0
	dc.w	$4004	;4004
	dc.w	$0000	;0000
	dc.w	$BFFA	;BFFA
	dc.w	$0003	;0003
	dc.w	$FAA9	;FAA9
	dc.w	$0000	;0000
	dc.w	$0552	;0552
	dc.w	$0004	;0004
	dc.w	$27FF	;27FF
	dc.w	$03FF	;03FF
	dc.w	$1BFF	;1BFF
	dc.w	$DBFF	;DBFF
	dc.w	$FFC0	;FFC0
	dc.w	$FFA0	;FFA0
	dc.w	$FFBC	;FFBC
	dc.w	$FFBF	;FFBF
	dc.w	$0A0A	;0A0A
	dc.w	$0000	;0000
	dc.w	$5535	;5535
	dc.w	$A0C0	;A0C0
	dc.w	$0005	;0005
	dc.w	$0002	;0002
	dc.w	$FD5A	;FD5A
	dc.w	$02A2	;02A2
	dc.w	$0540	;0540
	dc.w	$0000	;0000
	dc.w	$52B5	;52B5
	dc.w	$A80A	;A80A
	dc.w	$97FF	;97FF
	dc.w	$0BFF	;0BFF
	dc.w	$6BFF	;6BFF
	dc.w	$2BFF	;2BFF
	dc.w	$FFC0	;FFC0
	dc.w	$FFB0	;FFB0
	dc.w	$FFBA	;FFBA
	dc.w	$FFBF	;FFBF
	dc.w	$0234	;0234
	dc.w	$0000	;0000
	dc.w	$2DCB	;2DCB
	dc.w	$D000	;D000
	dc.w	$0006	;0006
	dc.w	$0000	;0000
	dc.w	$AAA8	;AAA8
	dc.w	$5551	;5551
	dc.w	$0200	;0200
	dc.w	$0000	;0000
	dc.w	$A9EA	;A9EA
	dc.w	$F415	;F415
	dc.w	$4FFF	;4FFF
	dc.w	$07FF	;07FF
	dc.w	$37FF	;37FF
	dc.w	$97FF	;97FF
	dc.w	$FFC0	;FFC0
	dc.w	$FFA8	;FFA8
	dc.w	$FFBC	;FFBC
	dc.w	$FFBF	;FFBF
	dc.w	$01C0	;01C0
	dc.w	$0000	;0000
	dc.w	$5E3D	;5E3D
	dc.w	$A002	;A002
	dc.w	$0008	;0008
	dc.w	$0000	;0000
	dc.w	$5555	;5555
	dc.w	$AAA3	;AAA3
	dc.w	$0000	;0000
	dc.w	$A000	;A000
	dc.w	$F555	;F555
	dc.w	$FAAB	;FAAB
	dc.w	$2FFF	;2FFF
	dc.w	$07FF	;07FF
	dc.w	$57FF	;57FF
	dc.w	$C7FF	;C7FF
	dc.w	$FFC0	;FFC0
	dc.w	$FFB0	;FFB0
	dc.w	$FFBA	;FFBA
	dc.w	$FFBF	;FFBF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$2FFA	;2FFA
	dc.w	$D005	;D005
	dc.w	$0008	;0008
	dc.w	$0001	;0001
	dc.w	$AAA3	;AAA3
	dc.w	$5557	;5557
	dc.w	$0000	;0000
	dc.w	$4000	;4000
	dc.w	$CA82	;CA82
	dc.w	$FD7F	;FD7F
	dc.w	$1FFF	;1FFF
	dc.w	$6FFF	;6FFF
	dc.w	$EFFF	;EFFF
	dc.w	$EFFF	;EFFF
	dc.w	$FFC0	;FFC0
	dc.w	$FFA8	;FFA8
	dc.w	$FFBD	;FFBD
	dc.w	$FFBF	;FFBF
	dc.w	$00F0	;00F0
	dc.w	$00F0	;00F0
	dc.w	$15F5	;15F5
	dc.w	$EAFA	;EAFA
	dc.w	$0008	;0008
	dc.w	$0000	;0000
	dc.w	$4553	;4553
	dc.w	$BAA7	;BAA7
	dc.w	$0020	;0020
	dc.w	$8000	;8000
	dc.w	$9515	;9515
	dc.w	$EADF	;EADF
	dc.w	$3FFF	;3FFF
	dc.w	$9FFF	;9FFF
	dc.w	$DFFF	;DFFF
	dc.w	$DFFF	;DFFF
	dc.w	$FFC0	;FFC0
	dc.w	$FFB0	;FFB0
	dc.w	$FFBA	;FFBA
	dc.w	$FFBF	;FFBF
	dc.w	$00F0	;00F0
	dc.w	$00F0	;00F0
	dc.w	$0AF2	;0AF2
	dc.w	$F5FD	;F5FD
	dc.w	$0008	;0008
	dc.w	$0001	;0001
	dc.w	$20A3	;20A3
	dc.w	$DF57	;DF57
	dc.w	$1810	;1810
	dc.w	$0005	;0005
	dc.w	$A28F	;A28F
	dc.w	$C56F	;C56F
	dc.w	$FFFF	;FFFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$FFC0	;FFC0
	dc.w	$FFA8	;FFA8
	dc.w	$FFBD	;FFBD
	dc.w	$FFBF	;FFBF
	dc.w	$00F0	;00F0
	dc.w	$00F0	;00F0
	dc.w	$40F1	;40F1
	dc.w	$FFFE	;FFFE
	dc.w	$0008	;0008
	dc.w	$0000	;0000
	dc.w	$0001	;0001
	dc.w	$FFF7	;FFF7
	dc.w	$0411	;0411
	dc.w	$800E	;800E
	dc.w	$DA0E	;DA0E
	dc.w	$E1EE	;E1EE
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFE0	;FFE0
	dc.w	$FFD4	;FFD4
	dc.w	$FFDE	;FFDE
	dc.w	$FFDF	;FFDF
	dc.w	$00F0	;00F0
	dc.w	$00F0	;00F0
	dc.w	$8AF0	;8AF0
	dc.w	$FFFF	;FFFF
	dc.w	$0008	;0008
	dc.w	$0000	;0000
	dc.w	$0A84	;0A84
	dc.w	$FFF3	;FFF3
	dc.w	$03A7	;03A7
	dc.w	$4019	;4019
	dc.w	$F419	;F419
	dc.w	$F859	;F859
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFE0	;FFE0
	dc.w	$FFDA	;FFDA
	dc.w	$FFDF	;FFDF
	dc.w	$FFDF	;FFDF
	dc.w	$00F0	;00F0
	dc.w	$00F0	;00F0
	dc.w	$55F4	;55F4
	dc.w	$FFFF	;FFFF
	dc.w	$0004	;0004
	dc.w	$0000	;0000
	dc.w	$5552	;5552
	dc.w	$FFF9	;FFF9
	dc.w	$007F	;007F
	dc.w	$0007	;0007
	dc.w	$5F87	;5F87
	dc.w	$FC07	;FC07
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFF0	;FFF0
	dc.w	$FFED	;FFED
	dc.w	$FFEF	;FFEF
	dc.w	$FFEF	;FFEF
	dc.w	$00F0	;00F0
	dc.w	$00F0	;00F0
	dc.w	$EAFA	;EAFA
	dc.w	$FFFF	;FFFF
	dc.w	$0002	;0002
	dc.w	$0000	;0000
	dc.w	$BFF9	;BFF9
	dc.w	$FFFC	;FFFC
	dc.w	$001F	;001F
	dc.w	$000F	;000F
	dc.w	$AAEF	;AAEF
	dc.w	$5F0F	;5F0F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFF8	;FFF8
	dc.w	$FFF6	;FFF6
	dc.w	$FFF7	;FFF7
	dc.w	$FFF7	;FFF7
	dc.w	$00F0	;00F0
	dc.w	$A8F0	;A8F0
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$0001	;0001
	dc.w	$0AA0	;0AA0
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$801F	;801F
	dc.w	$000F	;000F
	dc.w	$7D6F	;7D6F
	dc.w	$038F	;038F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFE	;FFFE
	dc.w	$FFF9	;FFF9
	dc.w	$FFF9	;FFF9
	dc.w	$FFF9	;FFF9
	dc.w	$0000	;0000
	dc.w	$D555	;D555
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$5554	;5554
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$783F	;783F
	dc.w	$001F	;001F
	dc.w	$82DF	;82DF
	dc.w	$871F	;871F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$C000	;C000
	dc.w	$3FEA	;3FEA
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$0000	;0000
	dc.w	$AAAA	;AAAA
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$103F	;103F
	dc.w	$821F	;821F
	dc.w	$E75F	;E75F
	dc.w	$EF9F	;EF9F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFC0	;FFC0
	dc.w	$003F	;003F
	dc.w	$003F	;003F
	dc.w	$003F	;003F
	dc.w	$0000	;0000
	dc.w	$F555	;F555
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$193F	;193F
	dc.w	$4D1F	;4D1F
	dc.w	$E6DF	;E6DF
	dc.w	$E61F	;E61F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFC	;FFFC
	dc.w	$FFFD	;FFFD
	dc.w	$FFFD	;FFFD
	dc.w	$E97F	;E97F
	dc.w	$3080	;3080
	dc.w	$4640	;4640
	dc.w	$70C0	;70C0
	dc.w	$0003	;0003
	dc.w	$FFFC	;FFFC
	dc.w	$FFFC	;FFFC
	dc.w	$FFFC	;FFFC
	dc.w	$EB7F	;EB7F
	dc.w	$033F	;033F
	dc.w	$14BF	;14BF
	dc.w	$043F	;043F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFD	;FFFD
	dc.w	$FFFC	;FFFC
	dc.w	$FFFD	;FFFD
	dc.w	$FFFF	;FFFF
	dc.w	$405F	;405F
	dc.w	$001F	;001F
	dc.w	$405F	;405F
	dc.w	$FFFF	;FFFF
	dc.w	$0002	;0002
	dc.w	$0000	;0000
	dc.w	$0002	;0002
	dc.w	$A97F	;A97F
	dc.w	$C53F	;C53F
	dc.w	$16BF	;16BF
	dc.w	$E63F	;E63F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFF	;FFFF
	dc.w	$BFBF	;BFBF
	dc.w	$BFBF	;BFBF
	dc.w	$BFBF	;BFBF
	dc.w	$FFFD	;FFFD
	dc.w	$FFFA	;FFFA
	dc.w	$FFF8	;FFF8
	dc.w	$FFFA	;FFFA
	dc.w	$7A7F	;7A7F
	dc.w	$8A3F	;8A3F
	dc.w	$05BF	;05BF
	dc.w	$843F	;843F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFF0	;FFF0
	dc.w	$FFF0	;FFF0
	dc.w	$FFF0	;FFF0
	dc.w	$F4FF	;F4FF
	dc.w	$047F	;047F
	dc.w	$037F	;037F
	dc.w	$087F	;087F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFE0	;FFE0
	dc.w	$FFEE	;FFEE
	dc.w	$FFEE	;FFEE
	dc.w	$62FF	;62FF
	dc.w	$823F	;823F
	dc.w	$C53F	;C53F
	dc.w	$D83F	;D83F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFEA	;FFEA
	dc.w	$FFDD	;FFDD
	dc.w	$FFD1	;FFD1
	dc.w	$FFDD	;FFDD
	dc.w	$D1FF	;D1FF
	dc.w	$E01F	;E01F
	dc.w	$02DF	;02DF
	dc.w	$ECDF	;ECDF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFC1	;FFC1
	dc.w	$FFD2	;FFD2
	dc.w	$FFD3	;FFD3
	dc.w	$205F	;205F
	dc.w	$C0EF	;C0EF
	dc.w	$1F2F	;1F2F
	dc.w	$C0EF	;C0EF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFD2	;FFD2
	dc.w	$FFC0	;FFC0
	dc.w	$FFD2	;FFD2
	dc.w	$FFFF	;FFFF
	dc.w	$202F	;202F
	dc.w	$200F	;200F
	dc.w	$202F	;202F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFED	;FFED
	dc.w	$FFED	;FFED
	dc.w	$FFED	;FFED
	dc.w	$FFFF	;FFFF
	dc.w	$FFDF	;FFDF
	dc.w	$FFDF	;FFDF
	dc.w	$FFDF	;FFDF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFBF	;FFBF
	dc.w	$FFBF	;FFBF
	dc.w	$FFBF	;FFBF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FF5F	;FF5F
	dc.w	$FF1F	;FF1F
	dc.w	$FF5F	;FF5F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FF4F	;FF4F
	dc.w	$FF2F	;FF2F
	dc.w	$FF6F	;FF6F
	dc.w	$FFFF	;FFFF
	dc.w	$FFCF	;FFCF
	dc.w	$FFDF	;FFDF
	dc.w	$FFDF	;FFDF
	dc.w	$FFEF	;FFEF
	dc.w	$FFB7	;FFB7
	dc.w	$FF97	;FF97
	dc.w	$FFB7	;FFB7
	dc.w	$FFFF	;FFFF
	dc.w	$FCEB	;FCEB
	dc.w	$FDE3	;FDE3
	dc.w	$FDEB	;FDEB
	dc.w	$FFDF	;FFDF
	dc.w	$FFB3	;FFB3
	dc.w	$FF8B	;FF8B
	dc.w	$FFBB	;FFBB
	dc.w	$FFFB	;FFFB
	dc.w	$FEB5	;FEB5
	dc.w	$FE31	;FE31
	dc.w	$FEB5	;FEB5
	dc.w	$FFFF	;FFFF
	dc.w	$FFC3	;FFC3
	dc.w	$FFC3	;FFC3
	dc.w	$FFC3	;FFC3
	dc.w	$FFBD	;FFBD
	dc.w	$FF62	;FF62
	dc.w	$FF00	;FF00
	dc.w	$FF66	;FF66
	dc.w	$FFC3	;FFC3
	dc.w	$FFB1	;FFB1
	dc.w	$FFB5	;FFB5
	dc.w	$FFB9	;FFB9
	dc.w	$FFDC	;FFDC
	dc.w	$F3A0	;F3A0
	dc.w	$F583	;F583
	dc.w	$F7B0	;F7B0
	dc.w	$FF83	;FF83
	dc.w	$FF49	;FF49
	dc.w	$FF5D	;FF5D
	dc.w	$FF79	;FF79
	dc.w	$FF71	;FF71
	dc.w	$F980	;F980
	dc.w	$F80A	;F80A
	dc.w	$F984	;F984
	dc.w	$FF01	;FF01
	dc.w	$FE20	;FE20
	dc.w	$FEF0	;FEF0
	dc.w	$FEAE	;FEAE
	dc.w	$FFB2	;FFB2
	dc.w	$FE40	;FE40
	dc.w	$FE09	;FE09
	dc.w	$FE65	;FE65
	dc.w	$FF01	;FF01
	dc.w	$FE84	;FE84
	dc.w	$FEFE	;FEFE
	dc.w	$FEEC	;FEEC
	dc.w	$FFE6	;FFE6
	dc.w	$FF81	;FF81
	dc.w	$FF91	;FF91
	dc.w	$FF89	;FF89
	dc.w	$FE00	;FE00
	dc.w	$FD20	;FD20
	dc.w	$FDB5	;FDB5
	dc.w	$FD6E	;FD6E
	dc.w	$FFA4	;FFA4
	dc.w	$7F41	;7F41
	dc.w	$7F13	;7F13
	dc.w	$7F4B	;7F4B
	dc.w	$FE00	;FE00
	dc.w	$FC04	;FC04
	dc.w	$FD7E	;FD7E
	dc.w	$FDEF	;FDEF
	dc.w	$FF74	;FF74
	dc.w	$7980	;7980
	dc.w	$7A09	;7A09
	dc.w	$7BC3	;7BC3
	dc.w	$FC00	;FC00
	dc.w	$F820	;F820
	dc.w	$FBB6	;FBB6
	dc.w	$FB6D	;FB6D
	dc.w	$FFF4	;FFF4
	dc.w	$7FE0	;7FE0
	dc.w	$7FEA	;7FEA
	dc.w	$7FE3	;7FE3
	dc.w	$FC00	;FC00
	dc.w	$FA00	;FA00
	dc.w	$FAF6	;FAF6
	dc.w	$FBEF	;FBEF
	dc.w	$7FF8	;7FF8
	dc.w	$3FE0	;3FE0
	dc.w	$3FE5	;3FE5
	dc.w	$BFE2	;BFE2
	dc.w	$FC00	;FC00
	dc.w	$F820	;F820
	dc.w	$FB7B	;FB7B
	dc.w	$FAE5	;FAE5
	dc.w	$7FF8	;7FF8
	dc.w	$3FE0	;3FE0
	dc.w	$BFE6	;BFE6
	dc.w	$3FE1	;3FE1
	dc.w	$F801	;F801
	dc.w	$F040	;F040
	dc.w	$F6FE	;F6FE
	dc.w	$F5E6	;F5E6
	dc.w	$7FF9	;7FF9
	dc.w	$3FF0	;3FF0
	dc.w	$3FF6	;3FF6
	dc.w	$BFF0	;BFF0
	dc.w	$F810	;F810
	dc.w	$F480	;F480
	dc.w	$F5CB	;F5CB
	dc.w	$F7E7	;F7E7
	dc.w	$3FFA	;3FFA
	dc.w	$1FF0	;1FF0
	dc.w	$9FF5	;9FF5
	dc.w	$5FF0	;5FF0
	dc.w	$F001	;F001
	dc.w	$E840	;E840
	dc.w	$EAFE	;EAFE
	dc.w	$EDE6	;EDE6
	dc.w	$3FF9	;3FF9
	dc.w	$1FF0	;1FF0
	dc.w	$5FF6	;5FF6
	dc.w	$9FF0	;9FF0
	dc.w	$F010	;F010
	dc.w	$E080	;E080
	dc.w	$EDCB	;EDCB
	dc.w	$EFE7	;EFE7
	dc.w	$BFF2	;BFF2
	dc.w	$1FE0	;1FE0
	dc.w	$5FED	;5FED
	dc.w	$5FE0	;5FE0
	dc.w	$F000	;F000
	dc.w	$E840	;E840
	dc.w	$EAFD	;EAFD
	dc.w	$EDE7	;EDE7
	dc.w	$1FF1	;1FF1
	dc.w	$0FE0	;0FE0
	dc.w	$8FEA	;8FEA
	dc.w	$6FE4	;6FE4
	dc.w	$E010	;E010
	dc.w	$C081	;C081
	dc.w	$D5CB	;D5CB
	dc.w	$DBE7	;DBE7
	dc.w	$9FF0	;9FF0
	dc.w	$0FE0	;0FE0
	dc.w	$6FE5	;6FE5
	dc.w	$4FEB	;4FEB
	dc.w	$E000	;E000
	dc.w	$C100	;C100
	dc.w	$CBDD	;CBDD
	dc.w	$DFE7	;DFE7
	dc.w	$1FE0	;1FE0
	dc.w	$0FC1	;0FC1
	dc.w	$AFDB	;AFDB
	dc.w	$6FC7	;6FC7
	dc.w	$E010	;E010
	dc.w	$D081	;D081
	dc.w	$D5CB	;D5CB
	dc.w	$DBE7	;DBE7
	dc.w	$8FE0	;8FE0
	dc.w	$0780	;0780
	dc.w	$4795	;4795
	dc.w	$378F	;378F
	dc.w	$C000	;C000
	dc.w	$8100	;8100
	dc.w	$AB9D	;AB9D
	dc.w	$B7E7	;B7E7
	dc.w	$4FA0	;4FA0
	dc.w	$0701	;0701
	dc.w	$374B	;374B
	dc.w	$A71F	;A71F
	dc.w	$C010	;C010
	dc.w	$8081	;8081
	dc.w	$95EB	;95EB
	dc.w	$BFC7	;BFC7
	dc.w	$47C0	;47C0
	dc.w	$0202	;0202
	dc.w	$9A27	;9A27
	dc.w	$321F	;321F
	dc.w	$C010	;C010
	dc.w	$A100	;A100
	dc.w	$ABAD	;ABAD
	dc.w	$B7C7	;B7C7
	dc.w	$4740	;4740
	dc.w	$0001	;0001
	dc.w	$30AB	;30AB
	dc.w	$A81F	;A81F
	dc.w	$C010	;C010
	dc.w	$8280	;8280
	dc.w	$B7AA	;B7AA
	dc.w	$BFC7	;BFC7
	dc.w	$4280	;4280
	dc.w	$0003	;0003
	dc.w	$9D57	;9D57
	dc.w	$303F	;303F
	dc.w	$8011	;8011
	dc.w	$0100	;0100
	dc.w	$6B2C	;6B2C
	dc.w	$77C6	;77C6
	dc.w	$C300	;C300
	dc.w	$0005	;0005
	dc.w	$2CAF	;2CAF
	dc.w	$107F	;107F
	dc.w	$81E3	;81E3
	dc.w	$4001	;4001
	dc.w	$5419	;5419
	dc.w	$6E0D	;6E0D
	dc.w	$C200	;C200
	dc.w	$800B	;800B
	dc.w	$B51F	;B51F
	dc.w	$88FF	;88FF
	dc.w	$87CF	;87CF
	dc.w	$0103	;0103
	dc.w	$6123	;6123
	dc.w	$7913	;7913
	dc.w	$E400	;E400
	dc.w	$C005	;C005
	dc.w	$DA3F	;DA3F
	dc.w	$C1FF	;C1FF
	dc.w	$8F9F	;8F9F
	dc.w	$4307	;4307
	dc.w	$5327	;5327
	dc.w	$6367	;6367
	dc.w	$F800	;F800
	dc.w	$C00B	;C00B
	dc.w	$C55F	;C55F
	dc.w	$C2FF	;C2FF
	dc.w	$9FBF	;9FBF
	dc.w	$070E	;070E
	dc.w	$674E	;674E
	dc.w	$674E	;674E
	dc.w	$F000	;F000
	dc.w	$0017	;0017
	dc.w	$0ABF	;0ABF
	dc.w	$05FF	;05FF
	dc.w	$9FFE	;9FFE
	dc.w	$4F9C	;4F9C
	dc.w	$4F9C	;4F9C
	dc.w	$6F9D	;6F9D
	dc.w	$2000	;2000
	dc.w	$000F	;000F
	dc.w	$1C7F	;1C7F
	dc.w	$C3FF	;C3FF
	dc.w	$BFFC	;BFFC
	dc.w	$1FF9	;1FF9
	dc.w	$5FF9	;5FF9
	dc.w	$5FFB	;5FFB
	dc.w	$0000	;0000
	dc.w	$0017	;0017
	dc.w	$FABF	;FABF
	dc.w	$C5FF	;C5FF
	dc.w	$BFF8	;BFF8
	dc.w	$1FF2	;1FF2
	dc.w	$5FF3	;5FF3
	dc.w	$5FF7	;5FF7
	dc.w	$0000	;0000
	dc.w	$000B	;000B
	dc.w	$B55F	;B55F
	dc.w	$CBFF	;CBFF
	dc.w	$FFF9	;FFF9
	dc.w	$BFF0	;BFF0
	dc.w	$BFF2	;BFF2
	dc.w	$BFF6	;BFF6
	dc.w	$0000	;0000
	dc.w	$0007	;0007
	dc.w	$68BF	;68BF
	dc.w	$97FF	;97FF
	dc.w	$FFF0	;FFF0
	dc.w	$FFE0	;FFE0
	dc.w	$FFE7	;FFE7
	dc.w	$FFEF	;FFEF
	dc.w	$8000	;8000
	dc.w	$000B	;000B
	dc.w	$755F	;755F
	dc.w	$0BFF	;0BFF
	dc.w	$FFF0	;FFF0
	dc.w	$FFE1	;FFE1
	dc.w	$FFEB	;FFEB
	dc.w	$FFEF	;FFEF
	dc.w	$4000	;4000
	dc.w	$0005	;0005
	dc.w	$B8AF	;B8AF
	dc.w	$87FF	;87FF
	dc.w	$FFF0	;FFF0
	dc.w	$FFE0	;FFE0
	dc.w	$FFEF	;FFEF
	dc.w	$FFEF	;FFEF
	dc.w	$4000	;4000
	dc.w	$0000	;0000
	dc.w	$345F	;345F
	dc.w	$8BFF	;8BFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$6000	;6000
	dc.w	$0001	;0001
	dc.w	$1AAF	;1AAF
	dc.w	$85FF	;85FF
	dc.w	$FFF0	;FFF0
	dc.w	$FFE4	;FFE4
	dc.w	$FFE7	;FFE7
	dc.w	$FFEF	;FFEF
	dc.w	$D000	;D000
	dc.w	$0000	;0000
	dc.w	$2C15	;2C15
	dc.w	$03FE	;03FE
	dc.w	$FFF0	;FFF0
	dc.w	$FFEA	;FFEA
	dc.w	$FFEF	;FFEF
	dc.w	$FFEF	;FFEF
	dc.w	$6001	;6001
	dc.w	$0000	;0000
	dc.w	$9A8A	;9A8A
	dc.w	$057C	;057C
	dc.w	$FFF0	;FFF0
	dc.w	$FFE4	;FFE4
	dc.w	$FFEE	;FFEE
	dc.w	$FFEF	;FFEF
	dc.w	$7000	;7000
	dc.w	$0000	;0000
	dc.w	$8D51	;8D51
	dc.w	$02AE	;02AE
	dc.w	$FFE0	;FFE0
	dc.w	$FFC0	;FFC0
	dc.w	$FFC5	;FFC5
	dc.w	$FFDE	;FFDE
	dc.w	$9800	;9800
	dc.w	$0000	;0000
	dc.w	$67AA	;67AA
	dc.w	$0055	;0055
	dc.w	$FFE0	;FFE0
	dc.w	$FFC0	;FFC0
	dc.w	$FFCB	;FFCB
	dc.w	$FFDC	;FFDC
	dc.w	$CD00	;CD00
	dc.w	$0000	;0000
	dc.w	$32F5	;32F5
	dc.w	$000A	;000A
	dc.w	$FFE1	;FFE1
	dc.w	$FFC0	;FFC0
	dc.w	$FFD6	;FFD6
	dc.w	$FFC8	;FFC8
	dc.w	$AF40	;AF40
	dc.w	$4000	;4000
	dc.w	$10BF	;10BF
	dc.w	$4000	;4000
	dc.w	$FFE1	;FFE1
	dc.w	$FFC0	;FFC0
	dc.w	$FFCA	;FFCA
	dc.w	$FFD4	;FFD4
	dc.w	$F7F5	;F7F5
	dc.w	$4800	;4800
	dc.w	$000A	;000A
	dc.w	$4800	;4800
	dc.w	$FFE3	;FFE3
	dc.w	$FF80	;FF80
	dc.w	$FF9C	;FF9C
	dc.w	$FF80	;FF80
	dc.w	$FFFF	;FFFF
	dc.w	$4780	;4780
	dc.w	$0780	;0780
	dc.w	$4780	;4780
	dc.w	$FFFB	;FFFB
	dc.w	$FFA0	;FFA0
	dc.w	$FF81	;FF81
	dc.w	$FFA5	;FFA5
	dc.w	$FFFF	;FFFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$FFDB	;FFDB
	dc.w	$FF70	;FF70
	dc.w	$FF25	;FF25
	dc.w	$FF71	;FF71
	dc.w	$FFFF	;FFFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$FFDB	;FFDB
	dc.w	$FF71	;FF71
	dc.w	$FF24	;FF24
	dc.w	$FF71	;FF71
	dc.w	$FFFF	;FFFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$FF8F	;FF8F
	dc.w	$FF72	;FF72
	dc.w	$FF22	;FF22
	dc.w	$FF72	;FF72
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FF8F	;FF8F
	dc.w	$FFAF	;FFAF
	dc.w	$FFAF	;FFAF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFDF	;FFDF
	dc.w	$FFDF	;FFDF
	dc.w	$FFDF	;FFDF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FEFF	;FEFF
	dc.w	$FEFF	;FEFF
	dc.w	$FEFF	;FEFF
	dc.w	$FFFF	;FFFF
	dc.w	$F7FF	;F7FF
	dc.w	$E7FF	;E7FF
	dc.w	$F7FF	;F7FF
	dc.w	$FFFF	;FFFF
	dc.w	$FC7F	;FC7F
	dc.w	$FD7E	;FD7E
	dc.w	$FD7F	;FD7F
	dc.w	$FFFF	;FFFF
	dc.w	$63FF	;63FF
	dc.w	$6BFF	;6BFF
	dc.w	$6BFF	;6BFF
	dc.w	$FF7F	;FF7F
	dc.w	$FDBE	;FDBE
	dc.w	$FCBE	;FCBE
	dc.w	$FDBE	;FDBE
	dc.w	$F7FF	;F7FF
	dc.w	$4DFF	;4DFF
	dc.w	$81FF	;81FF
	dc.w	$CDFF	;CDFF
	dc.w	$FFFF	;FFFF
	dc.w	$FE3F	;FE3F
	dc.w	$FE3F	;FE3F
	dc.w	$FE3F	;FE3F
	dc.w	$BFFF	;BFFF
	dc.w	$61FF	;61FF
	dc.w	$03FF	;03FF
	dc.w	$63FF	;63FF
	dc.w	$FE3F	;FE3F
	dc.w	$FE1E	;FE1E
	dc.w	$FFDD	;FFDD
	dc.w	$FEDF	;FEDF
	dc.w	$E5FF	;E5FF
	dc.w	$07FF	;07FF
	dc.w	$1BFF	;1BFF
	dc.w	$07FF	;07FF
	dc.w	$FE3F	;FE3F
	dc.w	$FCDC	;FCDC
	dc.w	$FCDC	;FCDC
	dc.w	$FDDC	;FDDC
	dc.w	$A7FF	;A7FF
	dc.w	$C3FF	;C3FF
	dc.w	$01FF	;01FF
	dc.w	$DBFF	;DBFF
	dc.w	$FC1F	;FC1F
	dc.w	$F88F	;F88F
	dc.w	$FBAF	;FBAF
	dc.w	$F9EF	;F9EF
	dc.w	$D1FF	;D1FF
	dc.w	$07FF	;07FF
	dc.w	$0DFF	;0DFF
	dc.w	$27FF	;27FF
	dc.w	$F81F	;F81F
	dc.w	$F00C	;F00C
	dc.w	$F4CC	;F4CC
	dc.w	$F3AC	;F3AC
	dc.w	$D1FF	;D1FF
	dc.w	$81FF	;81FF
	dc.w	$23FF	;23FF
	dc.w	$85FF	;85FF
	dc.w	$F81F	;F81F
	dc.w	$F08E	;F08E
	dc.w	$F3ED	;F3ED
	dc.w	$F7AF	;F7AF
	dc.w	$6DFF	;6DFF
	dc.w	$81FF	;81FF
	dc.w	$13FF	;13FF
	dc.w	$93FF	;93FF
	dc.w	$F00F	;F00F
	dc.w	$E087	;E087
	dc.w	$EAA7	;EAA7
	dc.w	$E5D7	;E5D7
	dc.w	$F1FF	;F1FF
	dc.w	$E3FF	;E3FF
	dc.w	$EBFF	;EBFF
	dc.w	$EFFF	;EFFF
	dc.w	$F00F	;F00F
	dc.w	$E007	;E007
	dc.w	$E4B7	;E4B7
	dc.w	$EFD7	;EFD7
	dc.w	$F5FF	;F5FF
	dc.w	$E1FF	;E1FF
	dc.w	$EBFF	;EBFF
	dc.w	$E3FF	;E3FF
	dc.w	$F00F	;F00F
	dc.w	$E087	;E087
	dc.w	$EB87	;EB87
	dc.w	$EDF7	;EDF7
	dc.w	$F9FF	;F9FF
	dc.w	$E3FF	;E3FF
	dc.w	$E3FF	;E3FF
	dc.w	$E7FF	;E7FF
	dc.w	$E007	;E007
	dc.w	$C08B	;C08B
	dc.w	$DFBB	;DFBB
	dc.w	$C9CB	;C9CB
	dc.w	$F5FF	;F5FF
	dc.w	$E1FF	;E1FF
	dc.w	$EBFF	;EBFF
	dc.w	$E3FF	;E3FF
	dc.w	$E007	;E007
	dc.w	$C103	;C103
	dc.w	$C5EB	;C5EB
	dc.w	$DB9B	;DB9B
	dc.w	$F7FF	;F7FF
	dc.w	$E1FF	;E1FF
	dc.w	$E9FF	;E9FF
	dc.w	$E3FF	;E3FF
	dc.w	$E007	;E007
	dc.w	$C003	;C003
	dc.w	$DF33	;DF33
	dc.w	$C1CB	;C1CB
	dc.w	$F5FF	;F5FF
	dc.w	$E1FF	;E1FF
	dc.w	$E9FF	;E9FF
	dc.w	$E3FF	;E3FF
	dc.w	$C003	;C003
	dc.w	$8001	;8001
	dc.w	$9B35	;9B35
	dc.w	$B5CD	;B5CD
	dc.w	$E3FF	;E3FF
	dc.w	$C1FF	;C1FF
	dc.w	$DDFF	;DDFF
	dc.w	$C1FF	;C1FF
	dc.w	$C023	;C023
	dc.w	$8101	;8101
	dc.w	$ADD9	;ADD9
	dc.w	$9385	;9385
	dc.w	$E1FF	;E1FF
	dc.w	$C1FF	;C1FF
	dc.w	$DBFF	;DBFF
	dc.w	$C5FF	;C5FF
	dc.w	$C403	;C403
	dc.w	$8001	;8001
	dc.w	$992D	;992D
	dc.w	$B3D5	;B3D5
	dc.w	$E1FF	;E1FF
	dc.w	$83FF	;83FF
	dc.w	$9BFF	;9BFF
	dc.w	$87FF	;87FF
	dc.w	$8411	;8411
	dc.w	$0000	;0000
	dc.w	$4B2E	;4B2E
	dc.w	$31C6	;31C6
	dc.w	$A1FF	;A1FF
	dc.w	$03FF	;03FF
	dc.w	$53FF	;53FF
	dc.w	$0FFF	;0FFF
	dc.w	$8C21	;8C21
	dc.w	$0102	;0102
	dc.w	$61D6	;61D6
	dc.w	$338A	;338A
	dc.w	$21FF	;21FF
	dc.w	$01FF	;01FF
	dc.w	$DBFF	;DBFF
	dc.w	$07FF	;07FF
	dc.w	$8E30	;8E30
	dc.w	$0C01	;0C01
	dc.w	$1D03	;1D03
	dc.w	$6DCF	;6DCF
	dc.w	$C1FF	;C1FF
	dc.w	$03FF	;03FF
	dc.w	$37FF	;37FF
	dc.w	$0FFF	;0FFF
	dc.w	$9E78	;9E78
	dc.w	$0D32	;0D32
	dc.w	$4DB7	;4DB7
	dc.w	$2DB3	;2DB3
	dc.w	$C1FF	;C1FF
	dc.w	$01FF	;01FF
	dc.w	$33FF	;33FF
	dc.w	$0FFF	;0FFF
	dc.w	$BEF6	;BEF6
	dc.w	$1C60	;1C60
	dc.w	$1D68	;1D68
	dc.w	$5D61	;5D61
	dc.w	$41FF	;41FF
	dc.w	$03FF	;03FF
	dc.w	$27FF	;27FF
	dc.w	$9FFF	;9FFF
	dc.w	$BFFF	;BFFF
	dc.w	$3EFC	;3EFC
	dc.w	$7EFC	;7EFC
	dc.w	$3EFC	;3EFC
	dc.w	$C1FF	;C1FF
	dc.w	$03FF	;03FF
	dc.w	$2FFF	;2FFF
	dc.w	$1FFF	;1FFF
	dc.w	$FFFE	;FFFE
	dc.w	$BFFC	;BFFC
	dc.w	$BFFD	;BFFD
	dc.w	$BFFC	;BFFC
	dc.w	$81FF	;81FF
	dc.w	$07FF	;07FF
	dc.w	$4FFF	;4FFF
	dc.w	$3FFF	;3FFF
	dc.w	$FFFD	;FFFD
	dc.w	$FFFC	;FFFC
	dc.w	$FFFC	;FFFC
	dc.w	$FFFE	;FFFE
	dc.w	$01FF	;01FF
	dc.w	$03FF	;03FF
	dc.w	$D7FF	;D7FF
	dc.w	$3FFF	;3FFF
	dc.w	$FFFE	;FFFE
	dc.w	$FFFC	;FFFC
	dc.w	$FFFC	;FFFC
	dc.w	$FFFD	;FFFD
	dc.w	$01FF	;01FF
	dc.w	$07FF	;07FF
	dc.w	$8FFF	;8FFF
	dc.w	$7FFF	;7FFF
	dc.w	$FFFC	;FFFC
	dc.w	$FFFC	;FFFC
	dc.w	$FFFE	;FFFE
	dc.w	$FFFF	;FFFF
	dc.w	$01FF	;01FF
	dc.w	$0BFF	;0BFF
	dc.w	$DFFF	;DFFF
	dc.w	$7FFF	;7FFF
	dc.w	$FFFC	;FFFC
	dc.w	$FFFC	;FFFC
	dc.w	$FFFF	;FFFF
	dc.w	$FFFE	;FFFE
	dc.w	$01FF	;01FF
	dc.w	$07FF	;07FF
	dc.w	$3FFF	;3FFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFC	;FFFC
	dc.w	$FFFC	;FFFC
	dc.w	$FFFE	;FFFE
	dc.w	$FFFF	;FFFF
	dc.w	$01FF	;01FF
	dc.w	$2BFF	;2BFF
	dc.w	$7FFF	;7FFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFA	;FFFA
	dc.w	$FFE0	;FFE0
	dc.w	$FFE0	;FFE0
	dc.w	$FFE5	;FFE5
	dc.w	$01FF	;01FF
	dc.w	$17FF	;17FF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFE1	;FFE1
	dc.w	$FFC0	;FFC0
	dc.w	$FFCE	;FFCE
	dc.w	$FFD8	;FFD8
	dc.w	$01FF	;01FF
	dc.w	$2FFF	;2FFF
	dc.w	$7FFF	;7FFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFC	;FFFC
	dc.w	$FF80	;FF80
	dc.w	$FF83	;FF83
	dc.w	$FF80	;FF80
	dc.w	$C1FF	;C1FF
	dc.w	$17FF	;17FF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$FFBB	;FFBB
	dc.w	$FF64	;FF64
	dc.w	$FF08	;FF08
	dc.w	$FF6C	;FF6C
	dc.w	$F1FF	;F1FF
	dc.w	$CBFF	;CBFF
	dc.w	$CFFF	;CFFF
	dc.w	$CFFF	;CFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FF4B	;FF4B
	dc.w	$FF23	;FF23
	dc.w	$FF6B	;FF6B
	dc.w	$FFFF	;FFFF
	dc.w	$F1FF	;F1FF
	dc.w	$F1FF	;F1FF
	dc.w	$F1FF	;F1FF
	dc.w	$FFFF	;FFFF
	dc.w	$FFD7	;FFD7
	dc.w	$FFD7	;FFD7
	dc.w	$FFD7	;FFD7
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFF7	;FFF7
	dc.w	$FFF7	;FFF7
	dc.w	$FFF7	;FFF7
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFE3	;FFE3
	dc.w	$FFEB	;FFEB
	dc.w	$FFEB	;FFEB
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$BFFF	;BFFF
	dc.w	$BFFF	;BFFF
	dc.w	$BFFF	;BFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFC6	;FFC6
	dc.w	$FFD6	;FFD6
	dc.w	$FFD6	;FFD6
	dc.w	$FFFF	;FFFF
	dc.w	$3FFE	;3FFE
	dc.w	$BFFE	;BFFE
	dc.w	$BFFE	;BFFE
	dc.w	$FFFF	;FFFF
	dc.w	$5FFF	;5FFF
	dc.w	$1FFF	;1FFF
	dc.w	$5FFF	;5FFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFEF	;FFEF
	dc.w	$FFB2	;FFB2
	dc.w	$FF81	;FF81
	dc.w	$FFB3	;FFB3
	dc.w	$FFFF	;FFFF
	dc.w	$7FFD	;7FFD
	dc.w	$7FFC	;7FFC
	dc.w	$7FFD	;7FFD
	dc.w	$FFFF	;FFFF
	dc.w	$3FFF	;3FFF
	dc.w	$BFFF	;BFFF
	dc.w	$BFFF	;BFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFBD	;FFBD
	dc.w	$FF46	;FF46
	dc.w	$FF40	;FF40
	dc.w	$FF46	;FF46
	dc.w	$FFFF	;FFFF
	dc.w	$FFFA	;FFFA
	dc.w	$FFF9	;FFF9
	dc.w	$FFFB	;FFFB
	dc.w	$7FFF	;7FFF
	dc.w	$BFFF	;BFFF
	dc.w	$3FFF	;3FFF
	dc.w	$BFFF	;BFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FF0F	;FF0F
	dc.w	$A681	;A681
	dc.w	$86A1	;86A1
	dc.w	$A6D1	;A6D1
	dc.w	$FFFB	;FFFB
	dc.w	$9FF4	;9FF4
	dc.w	$5FF4	;5FF4
	dc.w	$DFF4	;DFF4
	dc.w	$FFFF	;FFFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$E7FF	;E7FF
	dc.w	$83FF	;83FF
	dc.w	$8BFF	;8BFF
	dc.w	$9BFF	;9BFF
	dc.w	$FE03	;FE03
	dc.w	$C812	;C812
	dc.w	$D175	;D175
	dc.w	$D9DB	;D9DB
	dc.w	$7FF0	;7FF0
	dc.w	$BFE8	;BFE8
	dc.w	$3FED	;3FED
	dc.w	$BFEF	;BFEF
	dc.w	$7FFF	;7FFF
	dc.w	$3FFF	;3FFF
	dc.w	$BFFF	;BFFF
	dc.w	$3FFF	;3FFF
	dc.w	$9FFF	;9FFF
	dc.w	$07FF	;07FF
	dc.w	$67FF	;67FF
	dc.w	$27FF	;27FF
	dc.w	$F502	;F502
	dc.w	$E825	;E825
	dc.w	$E2FC	;E2FC
	dc.w	$EA25	;EA25
	dc.w	$FFF0	;FFF0
	dc.w	$7FE0	;7FE0
	dc.w	$7FEA	;7FEA
	dc.w	$7FEF	;7FEF
	dc.w	$7FFF	;7FFF
	dc.w	$3FFE	;3FFE
	dc.w	$BFFE	;BFFE
	dc.w	$BFFE	;BFFE
	dc.w	$3FFF	;3FFF
	dc.w	$1FFF	;1FFF
	dc.w	$9FFF	;9FFF
	dc.w	$5FFF	;5FFF
	dc.w	$F101	;F101
	dc.w	$E008	;E008
	dc.w	$EC7E	;EC7E
	dc.w	$ECD8	;ECD8
	dc.w	$FFE0	;FFE0
	dc.w	$9FD1	;9FD1
	dc.w	$1FD7	;1FD7
	dc.w	$9FDB	;9FDB
	dc.w	$3FFE	;3FFE
	dc.w	$1FFC	;1FFC
	dc.w	$DFFC	;DFFC
	dc.w	$5FFD	;5FFD
	dc.w	$7FFF	;7FFF
	dc.w	$3FFF	;3FFF
	dc.w	$BFFF	;BFFF
	dc.w	$BFFF	;BFFF
	dc.w	$E602	;E602
	dc.w	$C105	;C105
	dc.w	$C9E4	;C9E4
	dc.w	$D19D	;D19D
	dc.w	$7FC0	;7FC0
	dc.w	$CFA0	;CFA0
	dc.w	$2FB9	;2FB9
	dc.w	$EFB7	;EFB7
	dc.w	$1FFC	;1FFC
	dc.w	$27F8	;27F8
	dc.w	$27FB	;27FB
	dc.w	$E7F9	;E7F9
	dc.w	$7FFF	;7FFF
	dc.w	$BFFF	;BFFF
	dc.w	$BFFF	;BFFF
	dc.w	$BFFF	;BFFF
	dc.w	$D05B	;D05B
	dc.w	$A200	;A200
	dc.w	$A6A0	;A6A0
	dc.w	$AF04	;AF04
	dc.w	$FF80	;FF80
	dc.w	$FF40	;FF40
	dc.w	$FF69	;FF69
	dc.w	$FF7F	;FF7F
	dc.w	$07F8	;07F8
	dc.w	$83F0	;83F0
	dc.w	$BBF7	;BBF7
	dc.w	$DBF1	;DBF1
	dc.w	$FFFF	;FFFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$8324	;8324
	dc.w	$0000	;0000
	dc.w	$6C5B	;6C5B
	dc.w	$5880	;5880
	dc.w	$FF80	;FF80
	dc.w	$7F00	;7F00
	dc.w	$7F54	;7F54
	dc.w	$7F6B	;7F6B
	dc.w	$03F8	;03F8
	dc.w	$05F0	;05F0
	dc.w	$D5F5	;D5F5
	dc.w	$ADF3	;ADF3
	dc.w	$FFFF	;FFFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$1E70	;1E70
	dc.w	$0420	;0420
	dc.w	$6529	;6529
	dc.w	$A5A6	;A5A6
	dc.w	$FF00	;FF00
	dc.w	$7E00	;7E00
	dc.w	$7EA4	;7EA4
	dc.w	$7EDB	;7EDB
	dc.w	$01F0	;01F0
	dc.w	$80E1	;80E1
	dc.w	$BCEB	;BCEB
	dc.w	$CAE7	;CAE7
	dc.w	$FFFF	;FFFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$7CF8	;7CF8
	dc.w	$1870	;1870
	dc.w	$9875	;9875
	dc.w	$1B76	;1B76
	dc.w	$7F00	;7F00
	dc.w	$3E80	;3E80
	dc.w	$BEBD	;BEBD
	dc.w	$3ED3	;3ED3
	dc.w	$00F0	;00F0
	dc.w	$0160	;0160
	dc.w	$D36D	;D36D
	dc.w	$ED63	;ED63
	dc.w	$7FFF	;7FFF
	dc.w	$BFFF	;BFFF
	dc.w	$BFFF	;BFFF
	dc.w	$BFFF	;BFFF
	dc.w	$F9F8	;F9F8
	dc.w	$70F0	;70F0
	dc.w	$72F4	;72F4
	dc.w	$74F7	;74F7
	dc.w	$7E04	;7E04
	dc.w	$3D00	;3D00
	dc.w	$BDA0	;BDA0
	dc.w	$3DDB	;3DDB
	dc.w	$0070	;0070
	dc.w	$80A0	;80A0
	dc.w	$9BAA	;9BAA
	dc.w	$E6A5	;E6A5
	dc.w	$7FFF	;7FFF
	dc.w	$3FFF	;3FFF
	dc.w	$BFFF	;BFFF
	dc.w	$BFFF	;BFFF
	dc.w	$FFF8	;FFF8
	dc.w	$F9F0	;F9F0
	dc.w	$F9F5	;F9F5
	dc.w	$F9F6	;F9F6
	dc.w	$7C00	;7C00
	dc.w	$3800	;3800
	dc.w	$BB6E	;BB6E
	dc.w	$3BB1	;3BB1
	dc.w	$0038	;0038
	dc.w	$0010	;0010
	dc.w	$DBD5	;DBD5
	dc.w	$E553	;E553
	dc.w	$3FFF	;3FFF
	dc.w	$5FFF	;5FFF
	dc.w	$DFFF	;DFFF
	dc.w	$DFFF	;DFFF
	dc.w	$FFF0	;FFF0
	dc.w	$FFE8	;FFE8
	dc.w	$FFEB	;FFEB
	dc.w	$FFEC	;FFEC
	dc.w	$FC04	;FC04
	dc.w	$7A00	;7A00
	dc.w	$7B58	;7B58
	dc.w	$7BE3	;7BE3
	dc.w	$081C	;081C
	dc.w	$4008	;4008
	dc.w	$446A	;446A
	dc.w	$F3A9	;F3A9
	dc.w	$3FFF	;3FFF
	dc.w	$1FFF	;1FFF
	dc.w	$DFFF	;DFFF
	dc.w	$DFFF	;DFFF
	dc.w	$FFF0	;FFF0
	dc.w	$FFE0	;FFE0
	dc.w	$FFE9	;FFE9
	dc.w	$FFEE	;FFEE
	dc.w	$F804	;F804
	dc.w	$7000	;7000
	dc.w	$76B8	;76B8
	dc.w	$77E3	;77E3
	dc.w	$000C	;000C
	dc.w	$0000	;0000
	dc.w	$EEB3	;EEB3
	dc.w	$F1D0	;F1D0
	dc.w	$1FFF	;1FFF
	dc.w	$2FFF	;2FFF
	dc.w	$6FFF	;6FFF
	dc.w	$EFFF	;EFFF
	dc.w	$FFE0	;FFE0
	dc.w	$FFC0	;FFC0
	dc.w	$FFDB	;FFDB
	dc.w	$FFDC	;FFDC
	dc.w	$F808	;F808
	dc.w	$7400	;7400
	dc.w	$74A6	;74A6
	dc.w	$7751	;7751
	dc.w	$0404	;0404
	dc.w	$4000	;4000
	dc.w	$CB7A	;CB7A
	dc.w	$F0A9	;F0A9
	dc.w	$1FFF	;1FFF
	dc.w	$4FFF	;4FFF
	dc.w	$EFFF	;EFFF
	dc.w	$EFFF	;EFFF
	dc.w	$FFC1	;FFC1
	dc.w	$FFA0	;FFA0
	dc.w	$FFB6	;FFB6
	dc.w	$FFB8	;FFB8
	dc.w	$F018	;F018
	dc.w	$E800	;E800
	dc.w	$EF26	;EF26
	dc.w	$EDC1	;EDC1
	dc.w	$03C2	;03C2
	dc.w	$0000	;0000
	dc.w	$CC0D	;CC0D
	dc.w	$F034	;F034
	dc.w	$1FFF	;1FFF
	dc.w	$2FFF	;2FFF
	dc.w	$6FFF	;6FFF
	dc.w	$EFFF	;EFFF
	dc.w	$FF81	;FF81
	dc.w	$FF40	;FF40
	dc.w	$FF62	;FF62
	dc.w	$FF7C	;FF7C
	dc.w	$E07E	;E07E
	dc.w	$D000	;D000
	dc.w	$D801	;D801
	dc.w	$DF80	;DF80
	dc.w	$07F1	;07F1
	dc.w	$43C0	;43C0
	dc.w	$63CE	;63CE
	dc.w	$FBCA	;FBCA
	dc.w	$1FFF	;1FFF
	dc.w	$4FFF	;4FFF
	dc.w	$6FFF	;6FFF
	dc.w	$EFFF	;EFFF
	dc.w	$FF81	;FF81
	dc.w	$FF40	;FF40
	dc.w	$FF46	;FF46
	dc.w	$FF78	;FF78
	dc.w	$C1AB	;C1AB
	dc.w	$8000	;8000
	dc.w	$B454	;B454
	dc.w	$BA00	;BA00
	dc.w	$0BFD	;0BFD
	dc.w	$01E0	;01E0
	dc.w	$E5E2	;E5E2
	dc.w	$71E2	;71E2
	dc.w	$3FFF	;3FFF
	dc.w	$1FFF	;1FFF
	dc.w	$DFFF	;DFFF
	dc.w	$DFFF	;DFFF
	dc.w	$FF01	;FF01
	dc.w	$FE80	;FE80
	dc.w	$FEEE	;FEEE
	dc.w	$FEF0	;FEF0
	dc.w	$8600	;8600
	dc.w	$0000	;0000
	dc.w	$79FF	;79FF
	dc.w	$6000	;6000
	dc.w	$9FE2	;9FE2
	dc.w	$4000	;4000
	dc.w	$401D	;401D
	dc.w	$6001	;6001
	dc.w	$BFFF	;BFFF
	dc.w	$5FFF	;5FFF
	dc.w	$5FFF	;5FFF
	dc.w	$5FFF	;5FFF
	dc.w	$FF02	;FF02
	dc.w	$FE80	;FE80
	dc.w	$FEC5	;FEC5
	dc.w	$FEF8	;FEF8
	dc.w	$0800	;0800
	dc.w	$0000	;0000
	dc.w	$97F5	;97F5
	dc.w	$600A	;600A
	dc.w	$A081	;A081
	dc.w	$4000	;4000
	dc.w	$4578	;4578
	dc.w	$5A06	;5A06
	dc.w	$7FFF	;7FFF
	dc.w	$3FFF	;3FFF
	dc.w	$BFFF	;BFFF
	dc.w	$BFFF	;BFFF
	dc.w	$FE00	;FE00
	dc.w	$FD80	;FD80
	dc.w	$FDAF	;FDAF
	dc.w	$FDF0	;FDF0
	dc.w	$F000	;F000
	dc.w	$0000	;0000
	dc.w	$0EAA	;0EAA
	dc.w	$0155	;0155
	dc.w	$C040	;C040
	dc.w	$1800	;1800
	dc.w	$3C93	;3C93
	dc.w	$3F2F	;3F2F
	dc.w	$FFFF	;FFFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$FE00	;FE00
	dc.w	$FD00	;FD00
	dc.w	$FDC5	;FDC5
	dc.w	$FDFA	;FDFA
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$FD55	;FD55
	dc.w	$02AA	;02AA
	dc.w	$8000	;8000
	dc.w	$2001	;2001
	dc.w	$7367	;7367
	dc.w	$7E9F	;7E9F
	dc.w	$FFFF	;FFFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$FE00	;FE00
	dc.w	$FD80	;FD80
	dc.w	$FDE2	;FDE2
	dc.w	$FDFD	;FDFD
	dc.w	$7C00	;7C00
	dc.w	$7C00	;7C00
	dc.w	$FEA0	;FEA0
	dc.w	$7D5F	;7D5F
	dc.w	$8611	;8611
	dc.w	$200A	;200A
	dc.w	$794E	;794E
	dc.w	$70AE	;70AE
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FE00	;FE00
	dc.w	$FD40	;FD40
	dc.w	$FDD0	;FDD0
	dc.w	$FDFF	;FDFF
	dc.w	$7C00	;7C00
	dc.w	$7C00	;7C00
	dc.w	$7C15	;7C15
	dc.w	$FFFF	;FFFF
	dc.w	$8113	;8113
	dc.w	$100D	;100D
	dc.w	$360D	;360D
	dc.w	$78ED	;78ED
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FF00	;FF00
	dc.w	$FEA0	;FEA0
	dc.w	$FEEA	;FEEA
	dc.w	$FEFF	;FEFF
	dc.w	$7C00	;7C00
	dc.w	$7C00	;7C00
	dc.w	$FEAA	;FEAA
	dc.w	$FFFF	;FFFF
	dc.w	$80EF	;80EF
	dc.w	$0013	;0013
	dc.w	$1D13	;1D13
	dc.w	$7E13	;7E13
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FF80	;FF80
	dc.w	$FF70	;FF70
	dc.w	$FF7F	;FF7F
	dc.w	$FF7F	;FF7F
	dc.w	$7C00	;7C00
	dc.w	$7C00	;7C00
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$401F	;401F
	dc.w	$000F	;000F
	dc.w	$BB6F	;BB6F
	dc.w	$878F	;878F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFE0	;FFE0
	dc.w	$FF9A	;FF9A
	dc.w	$FF9F	;FF9F
	dc.w	$FF9F	;FF9F
	dc.w	$7C00	;7C00
	dc.w	$FD55	;FD55
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$3C1F	;3C1F
	dc.w	$000F	;000F
	dc.w	$C2AF	;C2AF
	dc.w	$C1CF	;C1CF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFF8	;FFF8
	dc.w	$FFE7	;FFE7
	dc.w	$FFE7	;FFE7
	dc.w	$FFE7	;FFE7
	dc.w	$0000	;0000
	dc.w	$F6AA	;F6AA
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$043F	;043F
	dc.w	$B91F	;B91F
	dc.w	$F99F	;F99F
	dc.w	$FBDF	;FBDF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFF8	;FFF8
	dc.w	$FFF8	;FFF8
	dc.w	$FFF8	;FFF8
	dc.w	$F000	;F000
	dc.w	$0FFF	;0FFF
	dc.w	$0FFF	;0FFF
	dc.w	$0FFF	;0FFF
	dc.w	$1A3F	;1A3F
	dc.w	$E01F	;E01F
	dc.w	$E55F	;E55F
	dc.w	$E19F	;E19F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFEA	;FFEA
	dc.w	$FFE0	;FFE0
	dc.w	$FFEA	;FFEA
	dc.w	$0FFF	;0FFF
	dc.w	$0000	;0000
	dc.w	$B000	;B000
	dc.w	$4000	;4000
	dc.w	$F23F	;F23F
	dc.w	$011F	;011F
	dc.w	$0D5F	;0D5F
	dc.w	$019F	;019F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFF5	;FFF5
	dc.w	$FFEA	;FFEA
	dc.w	$FFE0	;FFE0
	dc.w	$FFEA	;FFEA
	dc.w	$F7FF	;F7FF
	dc.w	$0BFF	;0BFF
	dc.w	$03FF	;03FF
	dc.w	$0BFF	;0BFF
	dc.w	$BC7F	;BC7F
	dc.w	$503F	;503F
	dc.w	$00BF	;00BF
	dc.w	$533F	;533F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFF5	;FFF5
	dc.w	$FFF5	;FFF5
	dc.w	$FFF5	;FFF5
	dc.w	$FFFF	;FFFF
	dc.w	$F7FF	;F7FF
	dc.w	$F7FF	;F7FF
	dc.w	$F7FF	;F7FF
	dc.w	$F87F	;F87F
	dc.w	$003F	;003F
	dc.w	$05BF	;05BF
	dc.w	$063F	;063F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFE	;FFFE
	dc.w	$FFFD	;FFFD
	dc.w	$FFFD	;FFFD
	dc.w	$FFFD	;FFFD
	dc.w	$D4FF	;D4FF
	dc.w	$B81F	;B81F
	dc.w	$215F	;215F
	dc.w	$BA5F	;BA5F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFC	;FFFC
	dc.w	$FFFD	;FFFD
	dc.w	$FFFD	;FFFD
	dc.w	$E81F	;E81F
	dc.w	$306F	;306F
	dc.w	$47AF	;47AF
	dc.w	$706F	;706F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFF	;FFFF
	dc.w	$BFDF	;BFDF
	dc.w	$BFDF	;BFDF
	dc.w	$BFDF	;BFDF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FDFF	;FDFF
	dc.w	$FDFF	;FDFF
	dc.w	$FDFF	;FDFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F8FF	;F8FF
	dc.w	$FAFF	;FAFF
	dc.w	$FAFF	;FAFF
	dc.w	$FFFF	;FFFF
	dc.w	$C7FF	;C7FF
	dc.w	$D7FF	;D7FF
	dc.w	$D7FF	;D7FF
	dc.w	$FEFF	;FEFF
	dc.w	$FB7E	;FB7E
	dc.w	$F97E	;F97E
	dc.w	$FB7E	;FB7E
	dc.w	$FFFF	;FFFF
	dc.w	$2BFF	;2BFF
	dc.w	$A3FF	;A3FF
	dc.w	$ABFF	;ABFF
	dc.w	$FFFF	;FFFF
	dc.w	$FC7F	;FC7F
	dc.w	$FC7F	;FC7F
	dc.w	$FC7F	;FC7F
	dc.w	$DBFF	;DBFF
	dc.w	$E5FF	;E5FF
	dc.w	$81FF	;81FF
	dc.w	$EDFF	;EDFF
	dc.w	$FC7F	;FC7F
	dc.w	$F83E	;F83E
	dc.w	$FABE	;FABE
	dc.w	$F93E	;F93E
	dc.w	$FDFF	;FDFF
	dc.w	$01FF	;01FF
	dc.w	$03FF	;03FF
	dc.w	$31FF	;31FF
	dc.w	$FC7F	;FC7F
	dc.w	$F83C	;F83C
	dc.w	$FBBD	;FBBD
	dc.w	$FABD	;FABD
	dc.w	$F3FF	;F3FF
	dc.w	$81FF	;81FF
	dc.w	$05FF	;05FF
	dc.w	$C9FF	;C9FF
	dc.w	$F83F	;F83F
	dc.w	$F01F	;F01F
	dc.w	$F55F	;F55F
	dc.w	$F69F	;F69F
	dc.w	$A5FF	;A5FF
	dc.w	$41FF	;41FF
	dc.w	$0BFF	;0BFF
	dc.w	$53FF	;53FF
	dc.w	$F83F	;F83F
	dc.w	$F41F	;F41F
	dc.w	$F5DF	;F5DF
	dc.w	$F69F	;F69F
	dc.w	$E5FF	;E5FF
	dc.w	$83FF	;83FF
	dc.w	$9BFF	;9BFF
	dc.w	$83FF	;83FF
	dc.w	$F01F	;F01F
	dc.w	$E80E	;E80E
	dc.w	$EBAF	;EBAF
	dc.w	$EC4F	;EC4F
	dc.w	$A9FF	;A9FF
	dc.w	$C1FF	;C1FF
	dc.w	$17FF	;17FF
	dc.w	$C7FF	;C7FF
	dc.w	$F01F	;F01F
	dc.w	$E00F	;E00F
	dc.w	$ED6F	;ED6F
	dc.w	$EACF	;EACF
	dc.w	$F9FF	;F9FF
	dc.w	$01FF	;01FF
	dc.w	$03FF	;03FF
	dc.w	$07FF	;07FF
	dc.w	$E11F	;E11F
	dc.w	$C00F	;C00F
	dc.w	$D6AF	;D6AF
	dc.w	$DA4F	;DA4F
	dc.w	$F9FF	;F9FF
	dc.w	$E1FF	;E1FF
	dc.w	$E5FF	;E5FF
	dc.w	$E3FF	;E3FF
	dc.w	$E00F	;E00F
	dc.w	$D007	;D007
	dc.w	$DB57	;DB57
	dc.w	$DEE7	;DEE7
	dc.w	$F3FF	;F3FF
	dc.w	$E1FF	;E1FF
	dc.w	$EDFF	;EDFF
	dc.w	$E1FF	;E1FF
	dc.w	$E10F	;E10F
	dc.w	$C247	;C247
	dc.w	$D6D7	;D6D7
	dc.w	$DE67	;DE67
	dc.w	$F5FF	;F5FF
	dc.w	$E1FF	;E1FF
	dc.w	$EBFF	;EBFF
	dc.w	$E1FF	;E1FF
	dc.w	$E00F	;E00F
	dc.w	$CC07	;CC07
	dc.w	$C757	;C757
	dc.w	$D6E7	;D6E7
	dc.w	$F3FF	;F3FF
	dc.w	$E1FF	;E1FF
	dc.w	$EDFF	;EDFF
	dc.w	$E1FF	;E1FF
	dc.w	$C127	;C127
	dc.w	$A043	;A043
	dc.w	$B4CB	;B4CB
	dc.w	$BE53	;BE53
	dc.w	$E1FF	;E1FF
	dc.w	$C1FF	;C1FF
	dc.w	$DBFF	;DBFF
	dc.w	$C5FF	;C5FF
	dc.w	$C027	;C027
	dc.w	$8403	;8403
	dc.w	$AF4B	;AF4B
	dc.w	$B6D3	;B6D3
	dc.w	$E1FF	;E1FF
	dc.w	$C1FF	;C1FF
	dc.w	$D5FF	;D5FF
	dc.w	$CFFF	;CFFF
	dc.w	$C127	;C127
	dc.w	$8043	;8043
	dc.w	$96DB	;96DB
	dc.w	$AC53	;AC53
	dc.w	$E1FF	;E1FF
	dc.w	$81FF	;81FF
	dc.w	$9BFF	;9BFF
	dc.w	$8FFF	;8FFF
	dc.w	$8013	;8013
	dc.w	$0401	;0401
	dc.w	$2745	;2745
	dc.w	$7EE9	;7EE9
	dc.w	$A1FF	;A1FF
	dc.w	$03FF	;03FF
	dc.w	$57FF	;57FF
	dc.w	$0FFF	;0FFF
	dc.w	$8111	;8111
	dc.w	$0040	;0040
	dc.w	$56EE	;56EE
	dc.w	$6C68	;6C68
	dc.w	$41FF	;41FF
	dc.w	$01FF	;01FF
	dc.w	$AFFF	;AFFF
	dc.w	$1FFF	;1FFF
	dc.w	$8911	;8911
	dc.w	$4000	;4000
	dc.w	$624A	;624A
	dc.w	$74E4	;74E4
	dc.w	$81FF	;81FF
	dc.w	$03FF	;03FF
	dc.w	$5FFF	;5FFF
	dc.w	$3FFF	;3FFF
	dc.w	$9E39	;9E39
	dc.w	$0810	;0810
	dc.w	$4996	;4996
	dc.w	$68D0	;68D0
	dc.w	$01FF	;01FF
	dc.w	$05FF	;05FF
	dc.w	$EFFF	;EFFF
	dc.w	$3FFF	;3FFF
	dc.w	$BCFE	;BCFE
	dc.w	$1838	;1838
	dc.w	$1A39	;1A39
	dc.w	$5938	;5938
	dc.w	$01FF	;01FF
	dc.w	$03FF	;03FF
	dc.w	$9FFF	;9FFF
	dc.w	$7FFF	;7FFF
	dc.w	$FDFC	;FDFC
	dc.w	$38E0	;38E0
	dc.w	$38E2	;38E2
	dc.w	$3AE1	;3AE1
	dc.w	$01FF	;01FF
	dc.w	$07FF	;07FF
	dc.w	$3FFF	;3FFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFC4	;FFC4
	dc.w	$FD80	;FD80
	dc.w	$FDB9	;FDB9
	dc.w	$FD9A	;FD9A
	dc.w	$01FF	;01FF
	dc.w	$0BFF	;0BFF
	dc.w	$7FFF	;7FFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFC0	;FFC0
	dc.w	$FFA0	;FFA0
	dc.w	$FFB6	;FFB6
	dc.w	$FFB9	;FFB9
	dc.w	$01FF	;01FF
	dc.w	$17FF	;17FF
	dc.w	$BFFF	;BFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FF80	;FF80
	dc.w	$FF00	;FF00
	dc.w	$FF6D	;FF6D
	dc.w	$FF33	;FF33
	dc.w	$01FF	;01FF
	dc.w	$0FFF	;0FFF
	dc.w	$7FFF	;7FFF
	dc.w	$FFFF	;FFFF
	dc.w	$FF88	;FF88
	dc.w	$FF00	;FF00
	dc.w	$FF36	;FF36
	dc.w	$FF71	;FF71
	dc.w	$01FF	;01FF
	dc.w	$17FF	;17FF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FF88	;FF88
	dc.w	$FF00	;FF00
	dc.w	$FF45	;FF45
	dc.w	$FF72	;FF72
	dc.w	$01FF	;01FF
	dc.w	$0FFF	;0FFF
	dc.w	$7FFF	;7FFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFE8	;FFE8
	dc.w	$FF00	;FF00
	dc.w	$FF16	;FF16
	dc.w	$FF01	;FF01
	dc.w	$01FF	;01FF
	dc.w	$05FF	;05FF
	dc.w	$BFFF	;BFFF
	dc.w	$FDFF	;FDFF
	dc.w	$FF08	;FF08
	dc.w	$FEA0	;FEA0
	dc.w	$FEF7	;FEF7
	dc.w	$FEE0	;FEE0
	dc.w	$03FF	;03FF
	dc.w	$01FF	;01FF
	dc.w	$5DFF	;5DFF
	dc.w	$F9FF	;F9FF
	dc.w	$FF0C	;FF0C
	dc.w	$FE40	;FE40
	dc.w	$FEF2	;FEF2
	dc.w	$FEE1	;FEE1
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$AFFF	;AFFF
	dc.w	$5DFF	;5DFF
	dc.w	$FF16	;FF16
	dc.w	$FE00	;FE00
	dc.w	$FE49	;FE49
	dc.w	$FEE0	;FEE0
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$D5FF	;D5FF
	dc.w	$2BFF	;2BFF
	dc.w	$FF13	;FF13
	dc.w	$FE08	;FE08
	dc.w	$FE64	;FE64
	dc.w	$FE88	;FE88
	dc.w	$01FF	;01FF
	dc.w	$01FF	;01FF
	dc.w	$EBFF	;EBFF
	dc.w	$15FF	;15FF
	dc.w	$FF1D	;FF1D
	dc.w	$FE0A	;FE0A
	dc.w	$FEA0	;FEA0
	dc.w	$FE4A	;FE4A
	dc.w	$EBFF	;EBFF
	dc.w	$01FF	;01FF
	dc.w	$15FF	;15FF
	dc.w	$01FF	;01FF
	dc.w	$FF2F	;FF2F
	dc.w	$FE11	;FE11
	dc.w	$FEC1	;FEC1
	dc.w	$FE11	;FE11
	dc.w	$FFFF	;FFFF
	dc.w	$C1FF	;C1FF
	dc.w	$C1FF	;C1FF
	dc.w	$C1FF	;C1FF
	dc.w	$FFBF	;FFBF
	dc.w	$FC07	;FC07
	dc.w	$FD57	;FD57
	dc.w	$FD17	;FD17
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FEBF	;FEBF
	dc.w	$FD0F	;FD0F
	dc.w	$FD4F	;FD4F
	dc.w	$FD0F	;FD0F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FD3F	;FD3F
	dc.w	$FC3F	;FC3F
	dc.w	$FD3F	;FD3F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FEFF	;FEFF
	dc.w	$FEFF	;FEFF
	dc.w	$FEFF	;FEFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFB	;FFFB
	dc.w	$FFF5	;FFF5
	dc.w	$FFF1	;FFF1
	dc.w	$FFF5	;FFF5
	dc.w	$FFDF	;FFDF
	dc.w	$E7EA	;E7EA
	dc.w	$F7C8	;F7C8
	dc.w	$F7EA	;F7EA
	dc.w	$FFFD	;FFFD
	dc.w	$EBD1	;EBD1
	dc.w	$E3C2	;E3C2
	dc.w	$EBD1	;EBD1
	dc.w	$F3F9	;F3F9
	dc.w	$E5E0	;E5E0
	dc.w	$E5E5	;E5E5
	dc.w	$EDE3	;EDE3
	dc.w	$E1D4	;E1D4
	dc.w	$C0B0	;C0B0
	dc.w	$DA8B	;DA8B
	dc.w	$CEB2	;CEB2
	dc.w	$E1F1	;E1F1
	dc.w	$C2E8	;C2E8
	dc.w	$CEE0	;CEE0
	dc.w	$DAEC	;DAEC
	dc.w	$C1EC	;C1EC
	dc.w	$80D1	;80D1
	dc.w	$92C1	;92C1
	dc.w	$BED3	;BED3
	dc.w	$C0FC	;C0FC
	dc.w	$8878	;8878
	dc.w	$AD7B	;AD7B
	dc.w	$BB79	;BB79
	dc.w	$C0FE	;C0FE
	dc.w	$8178	;8178
	dc.w	$9B78	;9B78
	dc.w	$AD79	;AD79
	dc.w	$80FF	;80FF
	dc.w	$0878	;0878
	dc.w	$1D78	;1D78
	dc.w	$6B79	;6B79
	dc.w	$A07D	;A07D
	dc.w	$0038	;0038
	dc.w	$5ABA	;5ABA
	dc.w	$4DB8	;4DB8
	dc.w	$8278	;8278
	dc.w	$08B0	;08B0
	dc.w	$3DB6	;3DB6
	dc.w	$58B1	;58B1
	dc.w	$2038	;2038
	dc.w	$0050	;0050
	dc.w	$4AD5	;4AD5
	dc.w	$DDD3	;DDD3
	dc.w	$2238	;2238
	dc.w	$0811	;0811
	dc.w	$9D55	;9D55
	dc.w	$D8D3	;D8D3
	dc.w	$3310	;3310
	dc.w	$0000	;0000
	dc.w	$08A9	;08A9
	dc.w	$CC67	;CC67
	dc.w	$77B0	;77B0
	dc.w	$2B01	;2B01
	dc.w	$2B0B	;2B0B
	dc.w	$AB47	;AB47
	dc.w	$7FE0	;7FE0
	dc.w	$3702	;3702
	dc.w	$B717	;B717
	dc.w	$370F	;370F
	dc.w	$FFC0	;FFC0
	dc.w	$7F81	;7F81
	dc.w	$7FA3	;7FA3
	dc.w	$7F9F	;7F9F
	dc.w	$FFA0	;FFA0
	dc.w	$FF82	;FF82
	dc.w	$FF87	;FF87
	dc.w	$FFDF	;FFDF
	dc.w	$FF80	;FF80
	dc.w	$FF85	;FF85
	dc.w	$FF8F	;FF8F
	dc.w	$FFFF	;FFFF
	dc.w	$FF80	;FF80
	dc.w	$FF83	;FF83
	dc.w	$FFDF	;FFDF
	dc.w	$FFFF	;FFFF
	dc.w	$FF80	;FF80
	dc.w	$FFD7	;FFD7
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FE40	;FE40
	dc.w	$FC2F	;FC2F
	dc.w	$FDBF	;FDBF
	dc.w	$FC3F	;FC3F
	dc.w	$FEE0	;FEE0
	dc.w	$FC07	;FC07
	dc.w	$FD1F	;FD1F
	dc.w	$FC1F	;FC1F
	dc.w	$FD38	;FD38
	dc.w	$FA80	;FA80
	dc.w	$F847	;F847
	dc.w	$FA87	;FA87
	dc.w	$FDFF	;FDFF
	dc.w	$FAB8	;FAB8
	dc.w	$F838	;F838
	dc.w	$FAB8	;FAB8
	dc.w	$FFFF	;FFFF
	dc.w	$FA7F	;FA7F
	dc.w	$F87F	;F87F
	dc.w	$FA7F	;FA7F
	dc.w	$FFFF	;FFFF
	dc.w	$FDFF	;FDFF
	dc.w	$FDFF	;FDFF
	dc.w	$FDFF	;FDFF
	dc.w	$FFFF	;FFFF
	dc.w	$FF7F	;FF7F
	dc.w	$FF3F	;FF3F
	dc.w	$FF7F	;FF7F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FEEB	;FEEB
	dc.w	$FE63	;FE63
	dc.w	$FEEB	;FEEB
	dc.w	$FFFF	;FFFF
	dc.w	$FEBF	;FEBF
	dc.w	$FE3F	;FE3F
	dc.w	$FEBF	;FEBF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FEEF	;FEEF
	dc.w	$FD37	;FD37
	dc.w	$FC07	;FC07
	dc.w	$FD37	;FD37
	dc.w	$FFFF	;FFFF
	dc.w	$FC7F	;FC7F
	dc.w	$FD7F	;FD7F
	dc.w	$FD7F	;FD7F
	dc.w	$FFFF	;FFFF
	dc.w	$F9FF	;F9FF
	dc.w	$F9FF	;F9FF
	dc.w	$F9FF	;F9FF
	dc.w	$FC7F	;FC7F
	dc.w	$DA05	;DA05
	dc.w	$9A81	;9A81
	dc.w	$DB05	;DB05
	dc.w	$FFFF	;FFFF
	dc.w	$F8FF	;F8FF
	dc.w	$F8FF	;F8FF
	dc.w	$F8FF	;F8FF
	dc.w	$F9FF	;F9FF
	dc.w	$E0FF	;E0FF
	dc.w	$E6FF	;E6FF
	dc.w	$E6FF	;E6FF
	dc.w	$F82F	;F82F
	dc.w	$809B	;809B
	dc.w	$A483	;A483
	dc.w	$A7DB	;A7DB
	dc.w	$F8FF	;F8FF
	dc.w	$F07F	;F07F
	dc.w	$F57F	;F57F
	dc.w	$F67F	;F67F
	dc.w	$E7FF	;E7FF
	dc.w	$C1FF	;C1FF
	dc.w	$D9FF	;D9FF
	dc.w	$C9FF	;C9FF
	dc.w	$E43F	;E43F
	dc.w	$D007	;D007
	dc.w	$CB47	;CB47
	dc.w	$D987	;D987
	dc.w	$F07F	;F07F
	dc.w	$E83F	;E83F
	dc.w	$EBBF	;EBBF
	dc.w	$EFBF	;EFBF
	dc.w	$CFFF	;CFFF
	dc.w	$87FF	;87FF
	dc.w	$A7FF	;A7FF
	dc.w	$97FF	;97FF
	dc.w	$E42F	;E42F
	dc.w	$D01F	;D01F
	dc.w	$D303	;D303
	dc.w	$D2DF	;D2DF
	dc.w	$E03F	;E03F
	dc.w	$C05F	;C05F
	dc.w	$D95F	;D95F
	dc.w	$DFDF	;DFDF
	dc.w	$CFFF	;CFFF
	dc.w	$97FF	;97FF
	dc.w	$B7FF	;B7FF
	dc.w	$97FF	;97FF
	dc.w	$D17F	;D17F
	dc.w	$A00F	;A00F
	dc.w	$A68F	;A68F
	dc.w	$A80F	;A80F
	dc.w	$E01F	;E01F
	dc.w	$C12F	;C12F
	dc.w	$D16F	;D16F
	dc.w	$DFEF	;DFEF
	dc.w	$9FFF	;9FFF
	dc.w	$0FFF	;0FFF
	dc.w	$4FFF	;4FFF
	dc.w	$2FFF	;2FFF
	dc.w	$859F	;859F
	dc.w	$000F	;000F
	dc.w	$5A6F	;5A6F
	dc.w	$600F	;600F
	dc.w	$C00F	;C00F
	dc.w	$8117	;8117
	dc.w	$B577	;B577
	dc.w	$ABB7	;ABB7
	dc.w	$9FFF	;9FFF
	dc.w	$0FFF	;0FFF
	dc.w	$2FFF	;2FFF
	dc.w	$6FFF	;6FFF
	dc.w	$BBCF	;BBCF
	dc.w	$1187	;1187
	dc.w	$51B7	;51B7
	dc.w	$1587	;1587
	dc.w	$8007	;8007
	dc.w	$0003	;0003
	dc.w	$5DDB	;5DDB
	dc.w	$6BBB	;6BBB
	dc.w	$8FFF	;8FFF
	dc.w	$17FF	;17FF
	dc.w	$57FF	;57FF
	dc.w	$37FF	;37FF
	dc.w	$F7CF	;F7CF
	dc.w	$A387	;A387
	dc.w	$A397	;A397
	dc.w	$ABA7	;ABA7
	dc.w	$8403	;8403
	dc.w	$4105	;4105
	dc.w	$596D	;596D
	dc.w	$639D	;639D
	dc.w	$87FF	;87FF
	dc.w	$0BFF	;0BFF
	dc.w	$5BFF	;5BFF
	dc.w	$3BFF	;3BFF
	dc.w	$FF8F	;FF8F
	dc.w	$F706	;F706
	dc.w	$F756	;F756
	dc.w	$F766	;F766
	dc.w	$0421	;0421
	dc.w	$8080	;8080
	dc.w	$E89A	;E89A
	dc.w	$F3C6	;F3C6
	dc.w	$C7FF	;C7FF
	dc.w	$8BFF	;8BFF
	dc.w	$BBFF	;BBFF
	dc.w	$9BFF	;9BFF
	dc.w	$FF8E	;FF8E
	dc.w	$FF04	;FF04
	dc.w	$FF55	;FF55
	dc.w	$FF65	;FF65
	dc.w	$0420	;0420
	dc.w	$0001	;0001
	dc.w	$D9DD	;D9DD
	dc.w	$E3C3	;E3C3
	dc.w	$C3FF	;C3FF
	dc.w	$05FF	;05FF
	dc.w	$2DFF	;2DFF
	dc.w	$1DFF	;1DFF
	dc.w	$FF1E	;FF1E
	dc.w	$FE0C	;FE0C
	dc.w	$FEAD	;FEAD
	dc.w	$FECD	;FECD
	dc.w	$081E	;081E
	dc.w	$0080	;0080
	dc.w	$D7A1	;D7A1
	dc.w	$E1C0	;E1C0
	dc.w	$43FF	;43FF
	dc.w	$05FF	;05FF
	dc.w	$ADFF	;ADFF
	dc.w	$9DFF	;9DFF
	dc.w	$FE1C	;FE1C
	dc.w	$FC0A	;FC0A
	dc.w	$FD2B	;FD2B
	dc.w	$FDCB	;FDCB
	dc.w	$3E1F	;3E1F
	dc.w	$000E	;000E
	dc.w	$00EE	;00EE
	dc.w	$C1CE	;C1CE
	dc.w	$23FF	;23FF
	dc.w	$49FF	;49FF
	dc.w	$CDFF	;CDFF
	dc.w	$5DFF	;5DFF
	dc.w	$FC18	;FC18
	dc.w	$FA00	;FA00
	dc.w	$FA67	;FA67
	dc.w	$FB86	;FB86
	dc.w	$562E	;562E
	dc.w	$0080	;0080
	dc.w	$29D1	;29D1
	dc.w	$80C0	;80C0
	dc.w	$D7FF	;D7FF
	dc.w	$03FF	;03FF
	dc.w	$2BFF	;2BFF
	dc.w	$2BFF	;2BFF
	dc.w	$FC20	;FC20
	dc.w	$F800	;F800
	dc.w	$FA53	;FA53
	dc.w	$FB8C	;FB8C
	dc.w	$AB44	;AB44
	dc.w	$0000	;0000
	dc.w	$5493	;5493
	dc.w	$00A8	;00A8
	dc.w	$27FF	;27FF
	dc.w	$03FF	;03FF
	dc.w	$9BFF	;9BFF
	dc.w	$5BFF	;5BFF
	dc.w	$F80E	;F80E
	dc.w	$F400	;F400
	dc.w	$F571	;F571
	dc.w	$F780	;F780
	dc.w	$0182	;0182
	dc.w	$0020	;0020
	dc.w	$EE74	;EE74
	dc.w	$1079	;1079
	dc.w	$1FFF	;1FFF
	dc.w	$07FF	;07FF
	dc.w	$67FF	;67FF
	dc.w	$E7FF	;E7FF
	dc.w	$F80F	;F80F
	dc.w	$F40F	;F40F
	dc.w	$F73F	;F73F
	dc.w	$F7CF	;F7CF
	dc.w	$0118	;0118
	dc.w	$0040	;0040
	dc.w	$54E2	;54E2
	dc.w	$AAC5	;AAC5
	dc.w	$1FFF	;1FFF
	dc.w	$2FFF	;2FFF
	dc.w	$EFFF	;EFFF
	dc.w	$EFFF	;EFFF
	dc.w	$F80F	;F80F
	dc.w	$F20F	;F20F
	dc.w	$F68F	;F68F
	dc.w	$F7FF	;F7FF
	dc.w	$0104	;0104
	dc.w	$0000	;0000
	dc.w	$AA59	;AA59
	dc.w	$7EE3	;7EE3
	dc.w	$BFFF	;BFFF
	dc.w	$5FFF	;5FFF
	dc.w	$5FFF	;5FFF
	dc.w	$5FFF	;5FFF
	dc.w	$FC0F	;FC0F
	dc.w	$F90F	;F90F
	dc.w	$FB5F	;FB5F
	dc.w	$FBFF	;FBFF
	dc.w	$0103	;0103
	dc.w	$0000	;0000
	dc.w	$54B4	;54B4
	dc.w	$FE78	;FE78
	dc.w	$FFFF	;FFFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$3FFF	;3FFF
	dc.w	$FF0F	;FF0F
	dc.w	$FCAF	;FCAF
	dc.w	$FCFF	;FCFF
	dc.w	$FCFF	;FCFF
	dc.w	$00E0	;00E0
	dc.w	$0A00	;0A00
	dc.w	$FF1D	;FF1D
	dc.w	$FF06	;FF06
	dc.w	$FFFF	;FFFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$FFC0	;FFC0
	dc.w	$FF3D	;FF3D
	dc.w	$FF3F	;FF3F
	dc.w	$FF3F	;FF3F
	dc.w	$0039	;0039
	dc.w	$5540	;5540
	dc.w	$FFC4	;FFC4
	dc.w	$FFC6	;FFC6
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FF80	;FF80
	dc.w	$FF80	;FF80
	dc.w	$FF80	;FF80
	dc.w	$FFC9	;FFC9
	dc.w	$0000	;0000
	dc.w	$0032	;0032
	dc.w	$0004	;0004
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FF83	;FF83
	dc.w	$FF41	;FF41
	dc.w	$FF0D	;FF0D
	dc.w	$FF71	;FF71
	dc.w	$FF73	;FF73
	dc.w	$FE81	;FE81
	dc.w	$FE05	;FE05
	dc.w	$FE89	;FE89
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFBD	;FFBD
	dc.w	$FF42	;FF42
	dc.w	$FF00	;FF00
	dc.w	$FF42	;FF42
	dc.w	$FFE3	;FFE3
	dc.w	$FE01	;FE01
	dc.w	$FE15	;FE15
	dc.w	$FE19	;FE19
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFBD	;FFBD
	dc.w	$FFBD	;FFBD
	dc.w	$FFBD	;FFBD
	dc.w	$FFE1	;FFE1
	dc.w	$FE82	;FE82
	dc.w	$FE3C	;FE3C
	dc.w	$FEA2	;FEA2
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FF5D	;FF5D
	dc.w	$FF5D	;FF5D
	dc.w	$FF5D	;FF5D
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFF7	;FFF7
	dc.w	$EFFB	;EFFB
	dc.w	$FFF3	;FFF3
	dc.w	$FFFB	;FFFB
	dc.w	$FFFF	;FFFF
	dc.w	$EBE1	;EBE1
	dc.w	$E3E1	;E3E1
	dc.w	$EBE5	;EBE5
	dc.w	$FFED	;FFED
	dc.w	$E3D0	;E3D0
	dc.w	$E3C0	;E3C0
	dc.w	$E3DA	;E3DA
	dc.w	$E3FA	;E3FA
	dc.w	$D1F0	;D1F0
	dc.w	$DDF1	;DDF1
	dc.w	$D9F5	;D9F5
	dc.w	$E3EA	;E3EA
	dc.w	$C1D1	;C1D1
	dc.w	$DDC5	;DDC5
	dc.w	$D5D9	;D5D9
	dc.w	$C1FE	;C1FE
	dc.w	$80F0	;80F0
	dc.w	$AAF1	;AAF1
	dc.w	$B4F5	;B4F5
	dc.w	$C1F4	;C1F4
	dc.w	$A0E8	;A0E8
	dc.w	$BAE3	;BAE3
	dc.w	$ACE9	;ACE9
	dc.w	$C0FC	;C0FC
	dc.w	$8078	;8078
	dc.w	$BD7A	;BD7A
	dc.w	$B679	;B679
	dc.w	$8AFC	;8AFC
	dc.w	$0078	;0078
	dc.w	$5179	;5179
	dc.w	$747A	;747A
	dc.w	$887D	;887D
	dc.w	$5038	;5038
	dc.w	$74BA	;74BA
	dc.w	$5338	;5338
	dc.w	$897C	;897C
	dc.w	$0038	;0038
	dc.w	$76B9	;76B9
	dc.w	$523B	;523B
	dc.w	$8838	;8838
	dc.w	$1200	;1200
	dc.w	$37C7	;37C7
	dc.w	$5283	;5283
	dc.w	$0928	;0928
	dc.w	$0001	;0001
	dc.w	$B653	;B653
	dc.w	$D2C7	;D2C7
	dc.w	$0930	;0930
	dc.w	$9002	;9002
	dc.w	$B0CB	;B0CB
	dc.w	$F607	;F607
	dc.w	$3360	;3360
	dc.w	$0101	;0101
	dc.w	$8D93	;8D93
	dc.w	$C50F	;C50F
	dc.w	$6FC0	;6FC0
	dc.w	$2203	;2203
	dc.w	$2227	;2227
	dc.w	$B21F	;B21F
	dc.w	$7E80	;7E80
	dc.w	$2C05	;2C05
	dc.w	$2C4F	;2C4F
	dc.w	$AD3F	;AD3F
	dc.w	$FC00	;FC00
	dc.w	$7A03	;7A03
	dc.w	$7BD7	;7BD7
	dc.w	$7B3F	;7B3F
	dc.w	$F880	;F880
	dc.w	$F001	;F001
	dc.w	$F34F	;F34F
	dc.w	$F63F	;F63F
	dc.w	$F880	;F880
	dc.w	$F001	;F001
	dc.w	$F34F	;F34F
	dc.w	$F63F	;F63F
	dc.w	$FF81	;FF81
	dc.w	$F000	;F000
	dc.w	$F076	;F076
	dc.w	$F01E	;F01E
	dc.w	$F9C0	;F9C0
	dc.w	$F400	;F400
	dc.w	$F61B	;F61B
	dc.w	$F42F	;F42F
	dc.w	$F9E0	;F9E0
	dc.w	$F000	;F000
	dc.w	$F41C	;F41C
	dc.w	$F603	;F603
	dc.w	$F978	;F978
	dc.w	$F000	;F000
	dc.w	$F287	;F287
	dc.w	$F400	;F400
	dc.w	$F9BF	;F9BF
	dc.w	$F058	;F058
	dc.w	$F618	;F618
	dc.w	$F058	;F058
	dc.w	$FFFF	;FFFF
	dc.w	$E13F	;E13F
	dc.w	$E03F	;E03F
	dc.w	$E13F	;E13F
	dc.w	$FFFF	;FFFF
	dc.w	$E8FF	;E8FF
	dc.w	$E0FF	;E0FF
	dc.w	$E8FF	;E8FF
	dc.w	$FFFF	;FFFF
	dc.w	$F7FF	;F7FF
	dc.w	$F7FF	;F7FF
	dc.w	$F7FF	;F7FF
	dc.w	$FFBF	;FFBF
	dc.w	$FFDF	;FFDF
	dc.w	$FF9F	;FF9F
	dc.w	$FFDF	;FFDF
	dc.w	$FFFF	;FFFF
	dc.w	$F72F	;F72F
	dc.w	$E70F	;E70F
	dc.w	$F7AF	;F7AF
	dc.w	$FEDF	;FEDF
	dc.w	$FF4F	;FF4F
	dc.w	$F63F	;F63F
	dc.w	$FF5F	;FF5F
	dc.w	$F79F	;F79F
	dc.w	$E39F	;E39F
	dc.w	$EB4F	;EB4F
	dc.w	$E3BF	;E3BF
	dc.w	$E32F	;E32F
	dc.w	$C08F	;C08F
	dc.w	$D01F	;D01F
	dc.w	$CCCF	;CCCF
	dc.w	$E3CF	;E3CF
	dc.w	$C19F	;C19F
	dc.w	$CD9F	;CD9F
	dc.w	$D9BF	;D9BF
	dc.w	$C3CF	;C3CF
	dc.w	$899F	;899F
	dc.w	$A9BF	;A9BF
	dc.w	$9D9F	;9D9F
	dc.w	$C1FF	;C1FF
	dc.w	$808F	;808F
	dc.w	$968F	;968F
	dc.w	$BA9F	;BA9F
	dc.w	$81DF	;81DF
	dc.w	$128F	;128F
	dc.w	$5EAF	;5EAF
	dc.w	$3A8F	;3A8F
	dc.w	$A08F	;A08F
	dc.w	$010F	;010F
	dc.w	$155F	;155F
	dc.w	$5B3F	;5B3F
	dc.w	$2C8F	;2C8F
	dc.w	$001F	;001F
	dc.w	$825F	;825F
	dc.w	$513F	;513F
	dc.w	$3E8F	;3E8F
	dc.w	$2C0F	;2C0F
	dc.w	$2D5F	;2D5F
	dc.w	$EC3F	;EC3F
	dc.w	$7F0F	;7F0F
	dc.w	$381F	;381F
	dc.w	$B8BF	;B8BF
	dc.w	$387F	;387F
	dc.w	$F80F	;F80F
	dc.w	$601F	;601F
	dc.w	$66BF	;66BF
	dc.w	$617F	;617F
	dc.w	$E00F	;E00F
	dc.w	$C42F	;C42F
	dc.w	$D77F	;D77F
	dc.w	$CFFF	;CFFF
	dc.w	$E60F	;E60F
	dc.w	$C05F	;C05F
	dc.w	$D8FF	;D8FF
	dc.w	$C9FF	;C9FF
	dc.w	$F30F	;F30F
	dc.w	$E02F	;E02F
	dc.w	$E4FF	;E4FF
	dc.w	$E8FF	;E8FF
	dc.w	$F28F	;F28F
	dc.w	$E01F	;E01F
	dc.w	$ED7F	;ED7F
	dc.w	$E07F	;E07F
	dc.w	$FFFF	;FFFF
	dc.w	$D00F	;D00F
	dc.w	$C00F	;C00F
	dc.w	$D20F	;D20F
	dc.w	$DBFF	;DBFF
	dc.w	$F4FF	;F4FF
	dc.w	$C0FF	;C0FF
	dc.w	$F4FF	;F4FF
	dc.w	$FFFF	;FFFF
	dc.w	$CBFF	;CBFF
	dc.w	$CBFF	;CBFF
	dc.w	$CBFF	;CBFF
	dc.w	$FFFF	;FFFF
	dc.w	$FDFF	;FDFF
	dc.w	$FCFF	;FCFF
	dc.w	$FDFF	;FDFF
	dc.w	$FFFF	;FFFF
	dc.w	$BFFF	;BFFF
	dc.w	$BFFF	;BFFF
	dc.w	$BFFF	;BFFF
	dc.w	$FDFF	;FDFF
	dc.w	$FAFF	;FAFF
	dc.w	$F87F	;F87F
	dc.w	$FAFF	;FAFF
	dc.w	$FFFF	;FFFF
	dc.w	$5FFF	;5FFF
	dc.w	$1FFF	;1FFF
	dc.w	$5FFF	;5FFF
	dc.w	$BAFF	;BAFF
	dc.w	$F17E	;F17E
	dc.w	$B03E	;B03E
	dc.w	$F57E	;F57E
	dc.w	$FFFF	;FFFF
	dc.w	$BFCF	;BFCF
	dc.w	$3FCF	;3FCF
	dc.w	$BFCF	;BFCF
	dc.w	$F57E	;F57E
	dc.w	$A09C	;A09C
	dc.w	$801D	;801D
	dc.w	$AA9D	;AA9D
	dc.w	$3FCF	;3FCF
	dc.w	$1F87	;1F87
	dc.w	$5FB7	;5FB7
	dc.w	$DF97	;DF97
	dc.w	$E8FC	;E8FC
	dc.w	$C07A	;C07A
	dc.w	$D33A	;D33A
	dc.w	$D47B	;D47B
	dc.w	$1F9F	;1F9F
	dc.w	$0F0F	;0F0F
	dc.w	$AF4F	;AF4F
	dc.w	$EF2F	;EF2F
	dc.w	$C7FC	;C7FC
	dc.w	$80F8	;80F8
	dc.w	$A0FB	;A0FB
	dc.w	$B8FA	;B8FA
	dc.w	$0F3F	;0F3F
	dc.w	$961F	;961F
	dc.w	$D69F	;D69F
	dc.w	$B65F	;B65F
	dc.w	$B4F8	;B4F8
	dc.w	$0074	;0074
	dc.w	$0975	;0975
	dc.w	$4276	;4276
	dc.w	$073F	;073F
	dc.w	$021F	;021F
	dc.w	$EADF	;EADF
	dc.w	$9A5F	;9A5F
	dc.w	$EE79	;EE79
	dc.w	$A430	;A430
	dc.w	$A4B4	;A4B4
	dc.w	$B536	;B536
	dc.w	$033F	;033F
	dc.w	$041F	;041F
	dc.w	$749F	;749F
	dc.w	$CC5F	;CC5F
	dc.w	$FC71	;FC71
	dc.w	$F828	;F828
	dc.w	$FAAA	;FAAA
	dc.w	$FB2C	;FB2C
	dc.w	$111F	;111F
	dc.w	$402F	;402F
	dc.w	$EAAF	;EAAF
	dc.w	$466F	;466F
	dc.w	$FC71	;FC71
	dc.w	$F820	;F820
	dc.w	$F8AA	;F8AA
	dc.w	$FB2C	;FB2C
	dc.w	$089F	;089F
	dc.w	$010F	;010F
	dc.w	$D52F	;D52F
	dc.w	$636F	;636F
	dc.w	$F8E3	;F8E3
	dc.w	$F040	;F040
	dc.w	$F554	;F554
	dc.w	$F658	;F658
	dc.w	$0E5F	;0E5F
	dc.w	$200F	;200F
	dc.w	$F0AF	;F0AF
	dc.w	$61AF	;61AF
	dc.w	$F8C5	;F8C5
	dc.w	$F400	;F400
	dc.w	$F52A	;F52A
	dc.w	$F630	;F630
	dc.w	$0DBF	;0DBF
	dc.w	$000F	;000F
	dc.w	$B24F	;B24F
	dc.w	$604F	;604F
	dc.w	$F0DA	;F0DA
	dc.w	$E000	;E000
	dc.w	$ED25	;ED25
	dc.w	$EE00	;EE00
	dc.w	$987F	;987F
	dc.w	$001F	;001F
	dc.w	$471F	;471F
	dc.w	$209F	;209F
	dc.w	$F060	;F060
	dc.w	$E800	;E800
	dc.w	$EC9F	;EC9F
	dc.w	$EF00	;EF00
	dc.w	$643F	;643F
	dc.w	$005F	;005F
	dc.w	$9A5F	;9A5F
	dc.w	$19DF	;19DF
	dc.w	$F00C	;F00C
	dc.w	$E000	;E000
	dc.w	$EE50	;EE50
	dc.w	$EFA3	;EFA3
	dc.w	$817F	;817F
	dc.w	$003F	;003F
	dc.w	$4CBF	;4CBF
	dc.w	$72BF	;72BF
	dc.w	$F882	;F882
	dc.w	$F400	;F400
	dc.w	$F714	;F714
	dc.w	$F779	;F779
	dc.w	$8EFF	;8EFF
	dc.w	$017F	;017F
	dc.w	$617F	;617F
	dc.w	$317F	;317F
	dc.w	$FC72	;FC72
	dc.w	$F900	;F900
	dc.w	$FB8D	;FB8D
	dc.w	$FB89	;FB89
	dc.w	$61FF	;61FF
	dc.w	$80FF	;80FF
	dc.w	$9CFF	;9CFF
	dc.w	$82FF	;82FF
	dc.w	$FF84	;FF84
	dc.w	$FC03	;FC03
	dc.w	$FC5B	;FC5B
	dc.w	$FC33	;FC33
	dc.w	$19FF	;19FF
	dc.w	$40FF	;40FF
	dc.w	$E6FF	;E6FF
	dc.w	$E4FF	;E4FF
	dc.w	$FF1F	;FF1F
	dc.w	$F807	;F807
	dc.w	$F887	;F887
	dc.w	$F8E7	;F8E7
	dc.w	$D3FF	;D3FF
	dc.w	$A1FF	;A1FF
	dc.w	$8DFF	;8DFF
	dc.w	$A5FF	;A5FF
	dc.w	$FB6F	;FB6F
	dc.w	$F517	;F517
	dc.w	$F007	;F007
	dc.w	$F597	;F597
	dc.w	$A1FF	;A1FF
	dc.w	$62FF	;62FF
	dc.w	$18FF	;18FF
	dc.w	$66FF	;66FF
	dc.w	$FFFF	;FFFF
	dc.w	$FA6F	;FA6F
	dc.w	$FA6F	;FA6F
	dc.w	$FA6F	;FA6F
	dc.w	$FFFF	;FFFF
	dc.w	$A1FF	;A1FF
	dc.w	$A1FF	;A1FF
	dc.w	$A1FF	;A1FF
	dc.w	$FFDF	;FFDF
	dc.w	$EFFF	;EFFF
	dc.w	$CFDF	;CFDF
	dc.w	$EFFF	;EFFF
	dc.w	$FF9F	;FF9F
	dc.w	$DFCF	;DFCF
	dc.w	$CFAF	;CFAF
	dc.w	$DFCF	;DFCF
	dc.w	$EFAF	;EFAF
	dc.w	$C79F	;C79F
	dc.w	$C7DF	;C7DF
	dc.w	$D79F	;D79F
	dc.w	$CFAF	;CFAF
	dc.w	$C7CF	;C7CF
	dc.w	$D79F	;D79F
	dc.w	$E7DF	;E7DF
	dc.w	$C7EF	;C7EF
	dc.w	$83CF	;83CF
	dc.w	$BBCF	;BBCF
	dc.w	$A3DF	;A3DF
	dc.w	$C3CF	;C3CF
	dc.w	$818F	;818F
	dc.w	$95BF	;95BF
	dc.w	$A98F	;A98F
	dc.w	$83CF	;83CF
	dc.w	$418F	;418F
	dc.w	$7DAF	;7DAF
	dc.w	$699F	;699F
	dc.w	$81CF	;81CF
	dc.w	$008F	;008F
	dc.w	$329F	;329F
	dc.w	$6CBF	;6CBF
	dc.w	$908F	;908F
	dc.w	$200F	;200F
	dc.w	$6B5F	;6B5F
	dc.w	$263F	;263F
	dc.w	$128F	;128F
	dc.w	$000F	;000F
	dc.w	$685F	;685F
	dc.w	$A53F	;A53F
	dc.w	$170F	;170F
	dc.w	$001F	;001F
	dc.w	$C8BF	;C8BF
	dc.w	$A07F	;A07F
	dc.w	$7E0F	;7E0F
	dc.w	$181F	;181F
	dc.w	$993F	;993F
	dc.w	$98FF	;98FF
	dc.w	$720F	;720F
	dc.w	$703F	;703F
	dc.w	$757F	;757F
	dc.w	$FCFF	;FCFF
	dc.w	$E40F	;E40F
	dc.w	$C01F	;C01F
	dc.w	$DA7F	;DA7F
	dc.w	$C9FF	;C9FF
	dc.w	$E40F	;E40F
	dc.w	$C00F	;C00F
	dc.w	$DB3F	;DB3F
	dc.w	$C8FF	;C8FF
	dc.w	$F60F	;F60F
	dc.w	$C80F	;C80F
	dc.w	$C99F	;C99F
	dc.w	$C86F	;C86F
	dc.w	$E70F	;E70F
	dc.w	$C00F	;C00F
	dc.w	$C8EF	;C8EF
	dc.w	$D01F	;D01F
	dc.w	$E3CF	;E3CF
	dc.w	$C40F	;C40F
	dc.w	$C83F	;C83F
	dc.w	$D50F	;D50F
	dc.w	$FFFF	;FFFF
	dc.w	$D2FF	;D2FF
	dc.w	$C2FF	;C2FF
	dc.w	$D2FF	;D2FF
	dc.w	$FFFF	;FFFF
	dc.w	$EFFF	;EFFF
	dc.w	$EFFF	;EFFF
	dc.w	$EFFF	;EFFF
	dc.w	$FF7F	;FF7F
	dc.w	$FFFF	;FFFF
	dc.w	$FF7F	;FF7F
	dc.w	$FFFF	;FFFF
	dc.w	$FDFF	;FDFF
	dc.w	$FE3F	;FE3F
	dc.w	$F47F	;F47F
	dc.w	$FEFF	;FEFF
	dc.w	$F77F	;F77F
	dc.w	$E27F	;E27F
	dc.w	$EABF	;EABF
	dc.w	$E37F	;E37F
	dc.w	$E73F	;E73F
	dc.w	$C03F	;C03F
	dc.w	$D07F	;D07F
	dc.w	$C9BF	;C9BF
	dc.w	$E3BF	;E3BF
	dc.w	$C17F	;C17F
	dc.w	$C97F	;C97F
	dc.w	$DD7F	;DD7F
	dc.w	$C3FF	;C3FF
	dc.w	$893F	;893F
	dc.w	$BD3F	;BD3F
	dc.w	$897F	;897F
	dc.w	$C37F	;C37F
	dc.w	$803F	;803F
	dc.w	$BCBF	;BCBF
	dc.w	$A83F	;A83F
	dc.w	$8D3F	;8D3F
	dc.w	$807F	;807F
	dc.w	$F0FF	;F0FF
	dc.w	$A27F	;A27F
	dc.w	$BD3F	;BD3F
	dc.w	$0C3F	;0C3F
	dc.w	$4E7F	;4E7F
	dc.w	$0CFF	;0CFF
	dc.w	$BE3F	;BE3F
	dc.w	$307F	;307F
	dc.w	$717F	;717F
	dc.w	$30FF	;30FF
	dc.w	$E03F	;E03F
	dc.w	$A47F	;A47F
	dc.w	$B6FF	;B6FF
	dc.w	$AFFF	;AFFF
	dc.w	$E43F	;E43F
	dc.w	$E0FF	;E0FF
	dc.w	$F9FF	;F9FF
	dc.w	$EBFF	;EBFF
	dc.w	$F23F	;F23F
	dc.w	$E03F	;E03F
	dc.w	$E4FF	;E4FF
	dc.w	$E9FF	;E9FF
	dc.w	$EFFF	;EFFF
	dc.w	$F3FF	;F3FF
	dc.w	$E3FF	;E3FF
	dc.w	$F3FF	;F3FF
	dc.w	$FBFF	;FBFF
	dc.w	$F7FF	;F7FF
	dc.w	$E3FF	;E3FF
	dc.w	$F7FF	;F7FF
	dc.w	$FFFF	;FFFF
	dc.w	$EBFF	;EBFF
	dc.w	$EBFF	;EBFF
	dc.w	$EBFF	;EBFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFB	;FFFB
	dc.w	$FBFB	;FBFB
	dc.w	$FFFB	;FFFB
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F3FF	;F3FF
	dc.w	$E5F5	;E5F5
	dc.w	$E0F1	;E0F1
	dc.w	$EDF5	;EDF5
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$EDF3	;EDF3
	dc.w	$C261	;C261
	dc.w	$8069	;8069
	dc.w	$D26D	;D26D
	dc.w	$F9FF	;F9FF
	dc.w	$F0FF	;F0FF
	dc.w	$F6FF	;F6FF
	dc.w	$F2FF	;F2FF
	dc.w	$D3E1	;D3E1
	dc.w	$81D0	;81D0
	dc.w	$A4D6	;A4D6
	dc.w	$A9DE	;A9DE
	dc.w	$F3FF	;F3FF
	dc.w	$E1FF	;E1FF
	dc.w	$E9FF	;E9FF
	dc.w	$E5FF	;E5FF
	dc.w	$ABE0	;ABE0
	dc.w	$01C0	;01C0
	dc.w	$55CE	;55CE
	dc.w	$01D5	;01D5
	dc.w	$F7FF	;F7FF
	dc.w	$63FF	;63FF
	dc.w	$6BFF	;6BFF
	dc.w	$6BFF	;6BFF
	dc.w	$59C8	;59C8
	dc.w	$0080	;0080
	dc.w	$82A3	;82A3
	dc.w	$24B6	;24B6
	dc.w	$77FF	;77FF
	dc.w	$23FF	;23FF
	dc.w	$A3FF	;A3FF
	dc.w	$ABFF	;ABFF
	dc.w	$F9C9	;F9C9
	dc.w	$F082	;F082
	dc.w	$F296	;F296
	dc.w	$F4A2	;F4A2
	dc.w	$23FF	;23FF
	dc.w	$07FF	;07FF
	dc.w	$D7FF	;D7FF
	dc.w	$4FFF	;4FFF
	dc.w	$F398	;F398
	dc.w	$E100	;E100
	dc.w	$ED67	;ED67
	dc.w	$E942	;E942
	dc.w	$93FF	;93FF
	dc.w	$03FF	;03FF
	dc.w	$67FF	;67FF
	dc.w	$2FFF	;2FFF
	dc.w	$F328	;F328
	dc.w	$E800	;E800
	dc.w	$EC95	;EC95
	dc.w	$E8C2	;E8C2
	dc.w	$EBFF	;EBFF
	dc.w	$07FF	;07FF
	dc.w	$07FF	;07FF
	dc.w	$17FF	;17FF
	dc.w	$E355	;E355
	dc.w	$C000	;C000
	dc.w	$D4AA	;D4AA
	dc.w	$D800	;D800
	dc.w	$97FF	;97FF
	dc.w	$03FF	;03FF
	dc.w	$63FF	;63FF
	dc.w	$0BFF	;0BFF
	dc.w	$E024	;E024
	dc.w	$C001	;C001
	dc.w	$D143	;D143
	dc.w	$DE9B	;DE9B
	dc.w	$1FFF	;1FFF
	dc.w	$07FF	;07FF
	dc.w	$C7FF	;C7FF
	dc.w	$27FF	;27FF
	dc.w	$F014	;F014
	dc.w	$E800	;E800
	dc.w	$EC62	;EC62
	dc.w	$EFC9	;EFC9
	dc.w	$FFFF	;FFFF
	dc.w	$0FFF	;0FFF
	dc.w	$0FFF	;0FFF
	dc.w	$0FFF	;0FFF
	dc.w	$F992	;F992
	dc.w	$F404	;F404
	dc.w	$F62D	;F62D
	dc.w	$F64C	;F64C
	dc.w	$1FFF	;1FFF
	dc.w	$1FFF	;1FFF
	dc.w	$3FFF	;3FFF
	dc.w	$DFFF	;DFFF
	dc.w	$FE3F	;FE3F
	dc.w	$F01C	;F01C
	dc.w	$F05C	;F05C
	dc.w	$F19C	;F19C
	dc.w	$3FFF	;3FFF
	dc.w	$1FFF	;1FFF
	dc.w	$DFFF	;DFFF
	dc.w	$5FFF	;5FFF
	dc.w	$F5BC	;F5BC
	dc.w	$EC7A	;EC7A
	dc.w	$E039	;E039
	dc.w	$EE7A	;EE7A
	dc.w	$1FFF	;1FFF
	dc.w	$2FFF	;2FFF
	dc.w	$0FFF	;0FFF
	dc.w	$EFFF	;EFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F3BD	;F3BD
	dc.w	$F3BD	;F3BD
	dc.w	$F3BD	;F3BD
	dc.w	$FFFF	;FFFF
	dc.w	$DFFF	;DFFF
	dc.w	$DFFF	;DFFF
	dc.w	$DFFF	;DFFF
	dc.w	$FF7F	;FF7F
	dc.w	$DFFF	;DFFF
	dc.w	$DF7F	;DF7F
	dc.w	$DFFF	;DFFF
	dc.w	$FEBF	;FEBF
	dc.w	$EF3F	;EF3F
	dc.w	$CE3F	;CE3F
	dc.w	$EF7F	;EF7F
	dc.w	$DEBF	;DEBF
	dc.w	$8F7F	;8F7F
	dc.w	$AE7F	;AE7F
	dc.w	$8F7F	;8F7F
	dc.w	$CFBF	;CFBF
	dc.w	$873F	;873F
	dc.w	$B73F	;B73F
	dc.w	$877F	;877F
	dc.w	$873F	;873F
	dc.w	$023F	;023F
	dc.w	$4AFF	;4AFF
	dc.w	$723F	;723F
	dc.w	$833F	;833F
	dc.w	$023F	;023F
	dc.w	$167F	;167F
	dc.w	$6AFF	;6AFF
	dc.w	$823F	;823F
	dc.w	$003F	;003F
	dc.w	$357F	;357F
	dc.w	$6CFF	;6CFF
	dc.w	$3E3F	;3E3F
	dc.w	$083F	;083F
	dc.w	$897F	;897F
	dc.w	$C8FF	;C8FF
	dc.w	$3C3F	;3C3F
	dc.w	$107F	;107F
	dc.w	$D2FF	;D2FF
	dc.w	$91FF	;91FF
	dc.w	$643F	;643F
	dc.w	$20FF	;20FF
	dc.w	$29FF	;29FF
	dc.w	$BBFF	;BBFF
	dc.w	$C83F	;C83F
	dc.w	$407F	;407F
	dc.w	$75FF	;75FF
	dc.w	$53FF	;53FF
	dc.w	$F83F	;F83F
	dc.w	$C03F	;C03F
	dc.w	$C4FF	;C4FF
	dc.w	$C3FF	;C3FF
	dc.w	$CC3F	;CC3F
	dc.w	$C03F	;C03F
	dc.w	$F27F	;F27F
	dc.w	$E1BF	;E1BF
	dc.w	$C73F	;C73F
	dc.w	$C83F	;C83F
	dc.w	$D0FF	;D0FF
	dc.w	$E83F	;E83F
	dc.w	$FFFF	;FFFF
	dc.w	$E7FF	;E7FF
	dc.w	$C7FF	;C7FF
	dc.w	$E7FF	;E7FF
	dc.w	$FFFF	;FFFF
	dc.w	$DFFF	;DFFF
	dc.w	$DFFF	;DFFF
	dc.w	$DFFF	;DFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FF83	;FF83
	dc.w	$FF83	;FF83
	dc.w	$FF83	;FF83
	dc.w	$FF83	;FF83
	dc.w	$F803	;F803
	dc.w	$F87F	;F87F
	dc.w	$F803	;F803
	dc.w	$F803	;F803
	dc.w	$E003	;E003
	dc.w	$E6AB	;E6AB
	dc.w	$E157	;E157
	dc.w	$E003	;E003
	dc.w	$C003	;C003
	dc.w	$DF57	;DF57
	dc.w	$C3FF	;C3FF
	dc.w	$C003	;C003
	dc.w	$80AB	;80AB
	dc.w	$AAFB	;AAFB
	dc.w	$95FF	;95FF
	dc.w	$C203	;C203
	dc.w	$8017	;8017
	dc.w	$B4DF	;B4DF
	dc.w	$89FF	;89FF
	dc.w	$C203	;C203
	dc.w	$8003	;8003
	dc.w	$A943	;A943
	dc.w	$9CBF	;9CBF
	dc.w	$C1C3	;C1C3
	dc.w	$8003	;8003
	dc.w	$BC17	;BC17
	dc.w	$8E2B	;8E2B
	dc.w	$E07F	;E07F
	dc.w	$C803	;C803
	dc.w	$CE83	;CE83
	dc.w	$DF03	;DF03
	dc.w	$E07F	;E07F
	dc.w	$C43F	;C43F
	dc.w	$DD3F	;DD3F
	dc.w	$CEBF	;CEBF
	dc.w	$E0FF	;E0FF
	dc.w	$C87F	;C87F
	dc.w	$CE7F	;CE7F
	dc.w	$DF7F	;DF7F
	dc.w	$E0FF	;E0FF
	dc.w	$C47F	;C47F
	dc.w	$D57F	;D57F
	dc.w	$CE7F	;CE7F
	dc.w	$F0FF	;F0FF
	dc.w	$E07F	;E07F
	dc.w	$EA7F	;EA7F
	dc.w	$E77F	;E77F
	dc.w	$F0FF	;F0FF
	dc.w	$E07F	;E07F
	dc.w	$E57F	;E57F
	dc.w	$EA7F	;EA7F
	dc.w	$F4FF	;F4FF
	dc.w	$E07F	;E07F
	dc.w	$EA7F	;EA7F
	dc.w	$E17F	;E17F
	dc.w	$FFFF	;FFFF
	dc.w	$C47F	;C47F
	dc.w	$C07F	;C07F
	dc.w	$C47F	;C47F
	dc.w	$FBFF	;FBFF
	dc.w	$AE3F	;AE3F
	dc.w	$84BF	;84BF
	dc.w	$AEBF	;AEBF
	dc.w	$FBFF	;FBFF
	dc.w	$2E9F	;2E9F
	dc.w	$445F	;445F
	dc.w	$6EDF	;6EDF
	dc.w	$913F	;913F
	dc.w	$6EDF	;6EDF
	dc.w	$445F	;445F
	dc.w	$6EDF	;6EDF
	dc.w	$FFFF	;FFFF
	dc.w	$115F	;115F
	dc.w	$551F	;551F
	dc.w	$555F	;555F
	dc.w	$FFFF	;FFFF
	dc.w	$BBBF	;BBBF
	dc.w	$BBBF	;BBBF
	dc.w	$BBBF	;BBBF
	dc.w	$FFFF	;FFFF
	dc.w	$FDFF	;FDFF
	dc.w	$FDFF	;FDFF
	dc.w	$FDFF	;FDFF
	dc.w	$FDFF	;FDFF
	dc.w	$DADF	;DADF
	dc.w	$D8DF	;D8DF
	dc.w	$DADF	;DADF
	dc.w	$DADF	;DADF
	dc.w	$A52F	;A52F
	dc.w	$820F	;820F
	dc.w	$A72F	;A72F
	dc.w	$EDAF	;EDAF
	dc.w	$3757	;3757
	dc.w	$4227	;4227
	dc.w	$7777	;7777
	dc.w	$BDDF	;BDDF
	dc.w	$6277	;6277
	dc.w	$4227	;4227
	dc.w	$6277	;6277
	dc.w	$EADF	;EADF
	dc.w	$002F	;002F
	dc.w	$472F	;472F
	dc.w	$522F	;522F
	dc.w	$EABF	;EABF
	dc.w	$800F	;800F
	dc.w	$906F	;906F
	dc.w	$952F	;952F
	dc.w	$E03F	;E03F
	dc.w	$C01F	;C01F
	dc.w	$CD9F	;CD9F
	dc.w	$D25F	;D25F
	dc.w	$F27F	;F27F
	dc.w	$E03F	;E03F
	dc.w	$E53F	;E53F
	dc.w	$E8BF	;E8BF
	dc.w	$F77F	;F77F
	dc.w	$E23F	;E23F
	dc.w	$E8BF	;E8BF
	dc.w	$E23F	;E23F
	dc.w	$FD7F	;FD7F
	dc.w	$F23F	;F23F
	dc.w	$F2BF	;F2BF
	dc.w	$F23F	;F23F
	dc.w	$FDFF	;FDFF
	dc.w	$E73F	;E73F
	dc.w	$E23F	;E23F
	dc.w	$E73F	;E73F
	dc.w	$FAFF	;FAFF
	dc.w	$E53F	;E53F
	dc.w	$E23F	;E23F
	dc.w	$E73F	;E73F
	dc.w	$F53F	;F53F
	dc.w	$E21F	;E21F
	dc.w	$E8DF	;E8DF
	dc.w	$E21F	;E21F
	dc.w	$F23F	;F23F
	dc.w	$E001	;E001
	dc.w	$E141	;E141
	dc.w	$ED81	;ED81
	dc.w	$E0C1	;E0C1
	dc.w	$C001	;C001
	dc.w	$DE2B	;DE2B
	dc.w	$C715	;C715
	dc.w	$E101	;E101
	dc.w	$C011	;C011
	dc.w	$D4B5	;D4B5
	dc.w	$CE5F	;CE5F
	dc.w	$E101	;E101
	dc.w	$C02B	;C02B
	dc.w	$DA7F	;DA7F
	dc.w	$C4FF	;C4FF
	dc.w	$E041	;E041
	dc.w	$C005	;C005
	dc.w	$D515	;D515
	dc.w	$CABF	;CABF
	dc.w	$F031	;F031
	dc.w	$E001	;E001
	dc.w	$EF8B	;EF8B
	dc.w	$E14F	;E14F
	dc.w	$FC09	;FC09
	dc.w	$F001	;F001
	dc.w	$F355	;F355
	dc.w	$F0A3	;F0A3
	dc.w	$FFC1	;FFC1
	dc.w	$FC01	;FC01
	dc.w	$FC3F	;FC3F
	dc.w	$FC01	;FC01
	dc.w	$FFFF	;FFFF
	dc.w	$FFC1	;FFC1
	dc.w	$FFC1	;FFC1
	dc.w	$FFC1	;FFC1
	dc.w	$FF87	;FF87
	dc.w	$F807	;F807
	dc.w	$F857	;F857
	dc.w	$F82F	;F82F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F807	;F807
	dc.w	$E007	;E007
	dc.w	$E7AF	;E7AF
	dc.w	$E057	;E057
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$E007	;E007
	dc.w	$C007	;C007
	dc.w	$DD57	;DD57
	dc.w	$C2AF	;C2AF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$C007	;C007
	dc.w	$8107	;8107
	dc.w	$A9AF	;A9AF
	dc.w	$97F7	;97F7
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$8007	;8007
	dc.w	$02A7	;02A7
	dc.w	$57F7	;57F7
	dc.w	$2FFF	;2FFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$8007	;8007
	dc.w	$0007	;0007
	dc.w	$69AF	;69AF
	dc.w	$1E7F	;1E7F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$81CF	;81CF
	dc.w	$0007	;0007
	dc.w	$6607	;6607
	dc.w	$1C37	;1C37
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$C03F	;C03F
	dc.w	$800F	;800F
	dc.w	$B3CF	;B3CF
	dc.w	$8E0F	;8E0F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$E01F	;E01F
	dc.w	$C00F	;C00F
	dc.w	$DD4F	;DD4F
	dc.w	$C3EF	;C3EF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F00F	;F00F
	dc.w	$E047	;E047
	dc.w	$EEE7	;EEE7
	dc.w	$E1F7	;E1F7
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FC07	;FC07
	dc.w	$F023	;F023
	dc.w	$F373	;F373
	dc.w	$F0FB	;F0FB
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FE03	;FE03
	dc.w	$FC11	;FC11
	dc.w	$FD99	;FD99
	dc.w	$FC7D	;FC7D
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FF81	;FF81
	dc.w	$FE00	;FE00
	dc.w	$FE44	;FE44
	dc.w	$FE3E	;FE3E
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFC0	;FFC0
	dc.w	$FF80	;FF80
	dc.w	$FFB0	;FFB0
	dc.w	$FF8F	;FF8F
	dc.w	$FFFF	;FFFF
	dc.w	$11FF	;11FF
	dc.w	$11FF	;11FF
	dc.w	$11FF	;11FF
	dc.w	$FFF0	;FFF0
	dc.w	$FF80	;FF80
	dc.w	$FF85	;FF85
	dc.w	$FF8A	;FF8A
	dc.w	$DDFF	;DDFF
	dc.w	$22FF	;22FF
	dc.w	$6EFF	;6EFF
	dc.w	$6EFF	;6EFF
	dc.w	$FFF1	;FFF1
	dc.w	$FF20	;FF20
	dc.w	$FF48	;FF48
	dc.w	$FF66	;FF66
	dc.w	$6AFF	;6AFF
	dc.w	$F77F	;F77F
	dc.w	$117F	;117F
	dc.w	$F77F	;F77F
	dc.w	$FFA0	;FFA0
	dc.w	$FE40	;FE40
	dc.w	$FE9F	;FE9F
	dc.w	$FEC0	;FEC0
	dc.w	$9FFF	;9FFF
	dc.w	$707F	;707F
	dc.w	$097F	;097F
	dc.w	$797F	;797F
	dc.w	$FFFF	;FFFF
	dc.w	$FEA0	;FEA0
	dc.w	$FE20	;FE20
	dc.w	$FEA0	;FEA0
	dc.w	$FFFF	;FFFF
	dc.w	$897F	;897F
	dc.w	$807F	;807F
	dc.w	$897F	;897F
	dc.w	$FFFF	;FFFF
	dc.w	$FF7F	;FF7F
	dc.w	$FF7F	;FF7F
	dc.w	$FF7F	;FF7F
	dc.w	$FFFF	;FFFF
	dc.w	$F6FF	;F6FF
	dc.w	$F6FF	;F6FF
	dc.w	$F6FF	;F6FF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$C7FF	;C7FF
	dc.w	$C7FF	;C7FF
	dc.w	$C7FF	;C7FF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$DFFF	;DFFF
	dc.w	$B3FF	;B3FF
	dc.w	$8BFF	;8BFF
	dc.w	$BBFF	;BBFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FBFF	;FBFF
	dc.w	$0DFF	;0DFF
	dc.w	$05FF	;05FF
	dc.w	$0DFF	;0DFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$FFFE	;FFFE
	dc.w	$DFFF	;DFFF
	dc.w	$E1FF	;E1FF
	dc.w	$25FF	;25FF
	dc.w	$E5FF	;E5FF
	dc.w	$FFFE	;FFFE
	dc.w	$FFFC	;FFFC
	dc.w	$FFFD	;FFFD
	dc.w	$FFFC	;FFFC
	dc.w	$7FFF	;7FFF
	dc.w	$A5FF	;A5FF
	dc.w	$11FF	;11FF
	dc.w	$B5FF	;B5FF
	dc.w	$FFFC	;FFFC
	dc.w	$FFF8	;FFF8
	dc.w	$FFFB	;FFFB
	dc.w	$FFF9	;FFF9
	dc.w	$FFFF	;FFFF
	dc.w	$13FF	;13FF
	dc.w	$03FF	;03FF
	dc.w	$13FF	;13FF
	dc.w	$FFFC	;FFFC
	dc.w	$FFF0	;FFF0
	dc.w	$FFF2	;FFF2
	dc.w	$FFF3	;FFF3
	dc.w	$7FFF	;7FFF
	dc.w	$2FFF	;2FFF
	dc.w	$AFFF	;AFFF
	dc.w	$2FFF	;2FFF
	dc.w	$FFF0	;FFF0
	dc.w	$FFC0	;FFC0
	dc.w	$FFC5	;FFC5
	dc.w	$FFCA	;FFCA
	dc.w	$FFFF	;FFFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$FFC0	;FFC0
	dc.w	$FF80	;FF80
	dc.w	$FFB2	;FFB2
	dc.w	$FF8F	;FF8F
	dc.w	$FFFF	;FFFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$FF80	;FF80
	dc.w	$FE00	;FE00
	dc.w	$FE44	;FE44
	dc.w	$FE3F	;FE3F
	dc.w	$FFFF	;FFFF
	dc.w	$6FFF	;6FFF
	dc.w	$6FFF	;6FFF
	dc.w	$6FFF	;6FFF
	dc.w	$FE02	;FE02
	dc.w	$FC10	;FC10
	dc.w	$FD99	;FD99
	dc.w	$FC7D	;FC7D
	dc.w	$7FFF	;7FFF
	dc.w	$07FF	;07FF
	dc.w	$17FF	;17FF
	dc.w	$97FF	;97FF
	dc.w	$FC06	;FC06
	dc.w	$F020	;F020
	dc.w	$F370	;F370
	dc.w	$F0F9	;F0F9
	dc.w	$AFFF	;AFFF
	dc.w	$77FF	;77FF
	dc.w	$17FF	;17FF
	dc.w	$77FF	;77FF
	dc.w	$F00F	;F00F
	dc.w	$E046	;E046
	dc.w	$EEE6	;EEE6
	dc.w	$E1F6	;E1F6
	dc.w	$FFFF	;FFFF
	dc.w	$4FFF	;4FFF
	dc.w	$2FFF	;2FFF
	dc.w	$6FFF	;6FFF
	dc.w	$E01F	;E01F
	dc.w	$C00F	;C00F
	dc.w	$DD4F	;DD4F
	dc.w	$C3EF	;C3EF
	dc.w	$FFFF	;FFFF
	dc.w	$9FFF	;9FFF
	dc.w	$9FFF	;9FFF
	dc.w	$9FFF	;9FFF
	dc.w	$C03F	;C03F
	dc.w	$800F	;800F
	dc.w	$B3CF	;B3CF
	dc.w	$8E0F	;8E0F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$81CF	;81CF
	dc.w	$0007	;0007
	dc.w	$6607	;6607
	dc.w	$1C37	;1C37
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$8007	;8007
	dc.w	$0007	;0007
	dc.w	$69AF	;69AF
	dc.w	$1E7F	;1E7F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$8007	;8007
	dc.w	$02A7	;02A7
	dc.w	$57F7	;57F7
	dc.w	$2FFF	;2FFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$C007	;C007
	dc.w	$8157	;8157
	dc.w	$A9FF	;A9FF
	dc.w	$97FF	;97FF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$E087	;E087
	dc.w	$C007	;C007
	dc.w	$DD57	;DD57
	dc.w	$C23F	;C23F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F877	;F877
	dc.w	$E007	;E007
	dc.w	$E60F	;E60F
	dc.w	$E18F	;E18F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FF07	;FF07
	dc.w	$F807	;F807
	dc.w	$F857	;F857
	dc.w	$F8AF	;F8AF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FE3F	;FE3F
	dc.w	$FE3F	;FE3F
	dc.w	$FE3F	;FE3F
	dc.w	$FE3F	;FE3F
	dc.w	$F03F	;F03F
	dc.w	$F1FF	;F1FF
	dc.w	$F03F	;F03F
	dc.w	$F03F	;F03F
	dc.w	$C03F	;C03F
	dc.w	$CDBF	;CDBF
	dc.w	$C27F	;C27F
	dc.w	$C03F	;C03F
	dc.w	$803F	;803F
	dc.w	$BA7F	;BA7F
	dc.w	$8FFF	;8FFF
	dc.w	$883F	;883F
	dc.w	$00FF	;00FF
	dc.w	$77FF	;77FF
	dc.w	$17FF	;17FF
	dc.w	$883F	;883F
	dc.w	$003F	;003F
	dc.w	$42BF	;42BF
	dc.w	$35FF	;35FF
	dc.w	$87FF	;87FF
	dc.w	$003F	;003F
	dc.w	$703F	;703F
	dc.w	$183F	;183F
	dc.w	$C3FF	;C3FF
	dc.w	$91FF	;91FF
	dc.w	$B1FF	;B1FF
	dc.w	$9DFF	;9DFF
	dc.w	$C7FF	;C7FF
	dc.w	$83FF	;83FF
	dc.w	$9BFF	;9BFF
	dc.w	$BBFF	;BBFF
	dc.w	$C7FF	;C7FF
	dc.w	$93FF	;93FF
	dc.w	$B3FF	;B3FF
	dc.w	$9BFF	;9BFF
	dc.w	$E7FF	;E7FF
	dc.w	$C3FF	;C3FF
	dc.w	$DBFF	;DBFF
	dc.w	$CBFF	;CBFF
	dc.w	$E3FF	;E3FF
	dc.w	$C1FF	;C1FF
	dc.w	$DDFF	;DDFF
	dc.w	$C1FF	;C1FF
	dc.w	$FFFF	;FFFF
	dc.w	$C0FF	;C0FF
	dc.w	$C8FF	;C8FF
	dc.w	$C8FF	;C8FF
	dc.w	$F7FF	;F7FF
	dc.w	$88FF	;88FF
	dc.w	$AAFF	;AAFF
	dc.w	$AAFF	;AAFF
	dc.w	$FFFF	;FFFF
	dc.w	$AAFF	;AAFF
	dc.w	$80FF	;80FF
	dc.w	$AAFF	;AAFF
	dc.w	$FFFF	;FFFF
	dc.w	$D5FF	;D5FF
	dc.w	$D5FF	;D5FF
	dc.w	$D5FF	;D5FF
	dc.w	$FFFF	;FFFF
	dc.w	$F7FF	;F7FF
	dc.w	$F7FF	;F7FF
	dc.w	$F7FF	;F7FF
	dc.w	$FFFF	;FFFF
	dc.w	$C1FF	;C1FF
	dc.w	$C9FF	;C9FF
	dc.w	$C9FF	;C9FF
	dc.w	$F7FF	;F7FF
	dc.w	$88FF	;88FF
	dc.w	$AAFF	;AAFF
	dc.w	$AAFF	;AAFF
	dc.w	$FFFF	;FFFF
	dc.w	$AAFF	;AAFF
	dc.w	$80FF	;80FF
	dc.w	$AAFF	;AAFF
	dc.w	$EBFF	;EBFF
	dc.w	$C1FF	;C1FF
	dc.w	$D5FF	;D5FF
	dc.w	$C1FF	;C1FF
	dc.w	$EFFF	;EFFF
	dc.w	$C3FF	;C3FF
	dc.w	$D3FF	;D3FF
	dc.w	$C3FF	;C3FF
	dc.w	$D7FF	;D7FF
	dc.w	$8BFF	;8BFF
	dc.w	$ABFF	;ABFF
	dc.w	$8BFF	;8BFF
	dc.w	$DFFF	;DFFF
	dc.w	$83FF	;83FF
	dc.w	$8BFF	;8BFF
	dc.w	$ABFF	;ABFF
	dc.w	$CBFF	;CBFF
	dc.w	$81FF	;81FF
	dc.w	$95FF	;95FF
	dc.w	$B1FF	;B1FF
	dc.w	$87FF	;87FF
	dc.w	$003F	;003F
	dc.w	$583F	;583F
	dc.w	$303F	;303F
	dc.w	$983F	;983F
	dc.w	$00BF	;00BF
	dc.w	$44BF	;44BF
	dc.w	$23FF	;23FF
	dc.w	$883F	;883F
	dc.w	$017F	;017F
	dc.w	$67FF	;67FF
	dc.w	$13FF	;13FF
	dc.w	$C63F	;C63F
	dc.w	$803F	;803F
	dc.w	$B0FF	;B0FF
	dc.w	$89FF	;89FF
	dc.w	$F1BF	;F1BF
	dc.w	$C03F	;C03F
	dc.w	$CC3F	;CC3F
	dc.w	$C27F	;C27F
	dc.w	$FE3F	;FE3F
	dc.w	$F03F	;F03F
	dc.w	$F1FF	;F1FF
	dc.w	$F03F	;F03F
	dc.w	$FFFF	;FFFF
	dc.w	$FE3F	;FE3F
	dc.w	$FE3F	;FE3F
	dc.w	$FE3F	;FE3F
	dc.w	$F83F	;F83F
	dc.w	$C03F	;C03F
	dc.w	$C2BF	;C2BF
	dc.w	$C57F	;C57F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$C03F	;C03F
	dc.w	$803F	;803F
	dc.w	$BD3F	;BD3F
	dc.w	$82FF	;82FF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$803F	;803F
	dc.w	$043F	;043F
	dc.w	$56BF	;56BF
	dc.w	$2FFF	;2FFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$803F	;803F
	dc.w	$003F	;003F
	dc.w	$567F	;567F
	dc.w	$39FF	;39FF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$877F	;877F
	dc.w	$003F	;003F
	dc.w	$483F	;483F
	dc.w	$38BF	;38BF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$C0FF	;C0FF
	dc.w	$807F	;807F
	dc.w	$BD7F	;BD7F
	dc.w	$877F	;877F
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$E07F	;E07F
	dc.w	$C13F	;C13F
	dc.w	$DB3F	;DB3F
	dc.w	$C7BF	;C7BF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$F83F	;F83F
	dc.w	$E09F	;E09F
	dc.w	$E6DF	;E6DF
	dc.w	$E1DF	;E1DF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FE1F	;FE1F
	dc.w	$F80F	;F80F
	dc.w	$F92F	;F92F
	dc.w	$F8EF	;F8EF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FF0F	;FF0F
	dc.w	$FE00	;FE00
	dc.w	$FE80	;FE80
	dc.w	$FE70	;FE70
	dc.w	$FFFF	;FFFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$7FFF	;7FFF
	dc.w	$FF95	;FF95
	dc.w	$FC0E	;FC0E
	dc.w	$FD42	;FD42
	dc.w	$FD2E	;FD2E
	dc.w	$BFFF	;BFFF
	dc.w	$DFFF	;DFFF
	dc.w	$5FFF	;5FFF
	dc.w	$DFFF	;DFFF
	dc.w	$FE0B	;FE0B
	dc.w	$F906	;F906
	dc.w	$FAF1	;FAF1
	dc.w	$FB07	;FB07
	dc.w	$FFFF	;FFFF
	dc.w	$1FFF	;1FFF
	dc.w	$5FFF	;5FFF
	dc.w	$5FFF	;5FFF
	dc.w	$FFFF	;FFFF
	dc.w	$FDFE	;FDFE
	dc.w	$FDFE	;FDFE
	dc.w	$FDFE	;FDFE
	dc.w	$FFFF	;FFFF
	dc.w	$BFFF	;BFFF
	dc.w	$BFFF	;BFFF
	dc.w	$BFFF	;BFFF
	dc.w	$FFFF	;FFFF
	dc.w	$FFF0	;FFF0
	dc.w	$FFF2	;FFF2
	dc.w	$FFF2	;FFF2
	dc.w	$FFFE	;FFFE
	dc.w	$FFC9	;FFC9
	dc.w	$FFC5	;FFC5
	dc.w	$FFCD	;FFCD
	dc.w	$FFC3	;FFC3
	dc.w	$FF8D	;FF8D
	dc.w	$FFB4	;FFB4
	dc.w	$FF8D	;FF8D
	dc.w	$FF8F	;FF8F
	dc.w	$FF04	;FF04
	dc.w	$FF60	;FF60
	dc.w	$FF34	;FF34
	dc.w	$FF1F	;FF1F
	dc.w	$FE0B	;FE0B
	dc.w	$FEAB	;FEAB
	dc.w	$FE4B	;FE4B
	dc.w	$FE1F	;FE1F
	dc.w	$FC8D	;FC8D
	dc.w	$FDAD	;FDAD
	dc.w	$FCCD	;FCCD
	dc.w	$FC0F	;FC0F
	dc.w	$F000	;F000
	dc.w	$F332	;F332
	dc.w	$F1E2	;F1E2
	dc.w	$F067	;F067
	dc.w	$E209	;E209
	dc.w	$EE95	;EE95
	dc.w	$E31D	;E31D
	dc.w	$E0FF	;E0FF
	dc.w	$C433	;C433
	dc.w	$DD33	;DD33
	dc.w	$CE33	;CE33
	dc.w	$C1FF	;C1FF
	dc.w	$807F	;807F
	dc.w	$BA7F	;BA7F
	dc.w	$9C7F	;9C7F
	dc.w	$867F	;867F
	dc.w	$003F	;003F
	dc.w	$413F	;413F
	dc.w	$39BF	;39BF
	dc.w	$803F	;803F
	dc.w	$017F	;017F
	dc.w	$6DFF	;6DFF
	dc.w	$33FF	;33FF
	dc.w	$C23F	;C23F
	dc.w	$803F	;803F
	dc.w	$857F	;857F
	dc.w	$B8FF	;B8FF
	dc.w	$E1BF	;E1BF
	dc.w	$C03F	;C03F
	dc.w	$D23F	;D23F
	dc.w	$CC7F	;CC7F
	dc.w	$F83F	;F83F
	dc.w	$E03F	;E03F
	dc.w	$E2BF	;E2BF
	dc.w	$E57F	;E57F
	dc.w	$FFFF	;FFFF
	dc.w	$F0FF	;F0FF
	dc.w	$F0FF	;F0FF
	dc.w	$F0FF	;F0FF
	dc.w	$F0FF	;F0FF
	dc.w	$C0FF	;C0FF
	dc.w	$CFFF	;CFFF
	dc.w	$C0FF	;C0FF
	dc.w	$C0FF	;C0FF
	dc.w	$80FF	;80FF
	dc.w	$B0FF	;B0FF
	dc.w	$8FFF	;8FFF
	dc.w	$80FF	;80FF
	dc.w	$04FF	;04FF
	dc.w	$4FFF	;4FFF
	dc.w	$3FFF	;3FFF
	dc.w	$8FFF	;8FFF
	dc.w	$00FF	;00FF
	dc.w	$50FF	;50FF
	dc.w	$30FF	;30FF
	dc.w	$CFFF	;CFFF
	dc.w	$97FF	;97FF
	dc.w	$97FF	;97FF
	dc.w	$B7FF	;B7FF
	dc.w	$C7FF	;C7FF
	dc.w	$83FF	;83FF
	dc.w	$93FF	;93FF
	dc.w	$BBFF	;BBFF
	dc.w	$E7FF	;E7FF
	dc.w	$C3FF	;C3FF
	dc.w	$D3FF	;D3FF
	dc.w	$DBFF	;DBFF
	dc.w	$FFFF	;FFFF
	dc.w	$93FF	;93FF
	dc.w	$83FF	;83FF
	dc.w	$93FF	;93FF
	dc.w	$FFFF	;FFFF
	dc.w	$C5FF	;C5FF
	dc.w	$91FF	;91FF
	dc.w	$D5FF	;D5FF
	dc.w	$FFFF	;FFFF
	dc.w	$8BFF	;8BFF
	dc.w	$8BFF	;8BFF
	dc.w	$8BFF	;8BFF
	dc.w	$FFFF	;FFFF
	dc.w	$CBFF	;CBFF
	dc.w	$CBFF	;CBFF
	dc.w	$CBFF	;CBFF
	dc.w	$FBFF	;FBFF
	dc.w	$85FF	;85FF
	dc.w	$91FF	;91FF
	dc.w	$B5FF	;B5FF
	dc.w	$FFFF	;FFFF
	dc.w	$D5FF	;D5FF
	dc.w	$81FF	;81FF
	dc.w	$D5FF	;D5FF
	dc.w	$D7FF	;D7FF
	dc.w	$83FF	;83FF
	dc.w	$83FF	;83FF
	dc.w	$ABFF	;ABFF
	dc.w	$DFFF	;DFFF
	dc.w	$97FF	;97FF
	dc.w	$A7FF	;A7FF
	dc.w	$97FF	;97FF
	dc.w	$CFFF	;CFFF
	dc.w	$97FF	;97FF
	dc.w	$A7FF	;A7FF
	dc.w	$97FF	;97FF
	dc.w	$9FFF	;9FFF
	dc.w	$00FF	;00FF
	dc.w	$40FF	;40FF
	dc.w	$20FF	;20FF
	dc.w	$80FF	;80FF
	dc.w	$04FF	;04FF
	dc.w	$4FFF	;4FFF
	dc.w	$3FFF	;3FFF
	dc.w	$C8FF	;C8FF
	dc.w	$82FF	;82FF
	dc.w	$B2FF	;B2FF
	dc.w	$87FF	;87FF
	dc.w	$F4FF	;F4FF
	dc.w	$C0FF	;C0FF
	dc.w	$CBFF	;CBFF
	dc.w	$C0FF	;C0FF
	dc.w	$FFFF	;FFFF
	dc.w	$F0FF	;F0FF
	dc.w	$F0FF	;F0FF
	dc.w	$F0FF	;F0FF
	dc.w	$F0FF	;F0FF
	dc.w	$C0FF	;C0FF
	dc.w	$CEFF	;CEFF
	dc.w	$C1FF	;C1FF
	dc.w	$C0FF	;C0FF
	dc.w	$80FF	;80FF
	dc.w	$BCFF	;BCFF
	dc.w	$87FF	;87FF
	dc.w	$80FF	;80FF
	dc.w	$0AFF	;0AFF
	dc.w	$6AFF	;6AFF
	dc.w	$1FFF	;1FFF
	dc.w	$8DFF	;8DFF
	dc.w	$00FF	;00FF
	dc.w	$50FF	;50FF
	dc.w	$32FF	;32FF
	dc.w	$C3FF	;C3FF
	dc.w	$81FF	;81FF
	dc.w	$BDFF	;BDFF
	dc.w	$8DFF	;8DFF
	dc.w	$F1FF	;F1FF
	dc.w	$C2FF	;C2FF
	dc.w	$CAFF	;CAFF
	dc.w	$C6FF	;C6FF
	dc.w	$F8FF	;F8FF
	dc.w	$F03F	;F03F
	dc.w	$F53F	;F53F
	dc.w	$F33F	;F33F
	dc.w	$FC3F	;FC3F
	dc.w	$F807	;F807
	dc.w	$FAC7	;FAC7
	dc.w	$F9C7	;F9C7
	dc.w	$F85F	;F85F
	dc.w	$F423	;F423
	dc.w	$F397	;F397
	dc.w	$F437	;F437
	dc.w	$FFFF	;FFFF
	dc.w	$FBEB	;FBEB
	dc.w	$FBEB	;FBEB
	dc.w	$FBEB	;FBEB
	dc.w	$FFFF	;FFFF
	dc.w	$FF9F	;FF9F
	dc.w	$FF9F	;FF9F
	dc.w	$FF9F	;FF9F
	dc.w	$FFDF	;FFDF
	dc.w	$FE6F	;FE6F
	dc.w	$FE0F	;FE0F
	dc.w	$FE6F	;FE6F
	dc.w	$FE7F	;FE7F
	dc.w	$F80F	;F80F
	dc.w	$F92F	;F92F
	dc.w	$F8AF	;F8AF
	dc.w	$F8FF	;F8FF
	dc.w	$F05F	;F05F
	dc.w	$F55F	;F55F
	dc.w	$F35F	;F35F
	dc.w	$F0FF	;F0FF
	dc.w	$E07F	;E07F
	dc.w	$ED7F	;ED7F
	dc.w	$E67F	;E67F
	dc.w	$E37F	;E37F
	dc.w	$C85F	;C85F
	dc.w	$D81F	;D81F
	dc.w	$CCDF	;CCDF
	dc.w	$C7FF	;C7FF
	dc.w	$913F	;913F
	dc.w	$B93F	;B93F
	dc.w	$993F	;993F
	dc.w	$8DFF	;8DFF
	dc.w	$00FF	;00FF
	dc.w	$50FF	;50FF
	dc.w	$32FF	;32FF
	dc.w	$80FF	;80FF
	dc.w	$0AFF	;0AFF
	dc.w	$6AFF	;6AFF
	dc.w	$1FFF	;1FFF
	dc.w	$C8FF	;C8FF
	dc.w	$80FF	;80FF
	dc.w	$B4FF	;B4FF
	dc.w	$87FF	;87FF
	dc.w	$F4FF	;F4FF
	dc.w	$C0FF	;C0FF
	dc.w	$CAFF	;CAFF
	dc.w	$C1FF	;C1FF

_GFX_Entropy:
	INCBIN bext-gfx/Entropy

_GFX_Pockets:
	INCBIN bext-gfx/Pockets

_GFX_Scroll_Edge_Top:
	INCBIN bext-gfx/Scroll_Edge_Top

_GFX_Scroll_Edge_Bottom:
	INCBIN bext-gfx/Scroll_Edge_Bottom

_GFX_Scroll_Edge_Left:
	INCBIN bext-gfx/Scroll_Edge_Left

_GFX_Scroll_Edge_Right:
	INCBIN bext-gfx/Scroll_Edge_Right

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

