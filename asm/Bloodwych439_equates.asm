; Generated from the static EQU header by the final formatting pass.
; Regenerate this file from the final relabel-data source; do not edit it.

dsksync:										equ	$0000007E
copjmp1:										equ	$00000088
aud:											equ	$000000A0
ac_vol:											equ	$00000008
adkcon:											equ	$0000009E
_custom:										equ	$00DFF000
ddfstop:										equ	$00000094
bplcon2:										equ	$00000104
diwstrt:										equ	$0000008E
ac_per:											equ	$00000006
intreq:											equ	$0000009C
bplcon0:										equ	$00000100
bplcon1:										equ	$00000102
aud0:											equ	$000000A0
diwstop:										equ	$00000090
cli_SIZEOF:										equ	$00000040
ddfstrt:										equ	$00000092
SYSBASESIZE:									equ	$00000278
tv_TrapInstrVects:								equ	$00000080
ciaprb:											equ	$00000100
intena:											equ	$0000009A
intreqr:										equ	$0000001E
joy0dat:										equ	$0000000A
ac_dat:											equ	$0000000A
joy1dat:										equ	$0000000C
bpl2mod:										equ	$0000010A
color:											equ	$00000180
bltddat:										equ	$00000000
bpl1mod:										equ	$00000108
ciaicr:											equ	$00000D00
dskpt:											equ	$00000020
cop1lc:											equ	$00000080
_ciaa:											equ	$00BFE001
_ciab:											equ	$00BFD000
dmacon:											equ	$00000096
wd_SIZEOF:										equ	$00000088
dsklen:											equ	$00000024
ac_len:											equ	$00000004
ciacra:											equ	$00000E00

AirbourneSpell_ArcBolt:							equ	$82			; Live-entity form code used by Arc Bolt projectiles.
AirbourneSpell_Beguile:							equ	$8D			; Spell-effect code queued after Beguile changes the communication state.
AirbourneSpell_Blaze:							equ	$84			; Live-entity form code used by Blaze projectiles.
AirbourneSpell_CodeBase:						equ	$80			; Converts a low monster-spell selector into the airborne entity-code range.
AirbourneSpell_Confuse:							equ	$8B			; Live-entity form code used by Confuse projectiles.
AirbourneSpell_Disrupt:							equ	$83			; Live-entity form code used by Disrupt projectiles.
AirbourneSpell_Fireball:						equ	$80			; Live-entity form code used by Fireball projectiles.
AirbourneSpell_Firepath:						equ	$87			; Live-entity form code used to launch Firepath.
AirbourneSpell_GeneralFirstCode:				equ	$86			; First airborne-spell code using the general spell picture/layout family rather than the fireball family.
AirbourneSpell_Missile:							equ	$8A			; Live-entity form code used by Missile projectiles.
AirbourneSpell_Paralyze:						equ	$8C			; Live-entity form code used by Paralyze projectiles.
AirbourneSpell_Spelltap:						equ	$8E			; Live-entity form code used by Spelltap projectiles.
AirbourneSpell_Terror:							equ	$8F			; Live-entity form code used by Terror projectiles.
AirbourneSpell_Wychwind:						equ	$81			; Live-entity form code used by each Wychwind projectile.

Alchemy_BaseCoinageGain:						equ	$05			; Coinage added by Alchemy before the spell-power contribution.

ArcBoltMachine_BasePower:						equ	$0C			; Base power supplied by the fixed Arc Bolt machine attack type.

BitReverseLookupLastIndex:						equ	$FF			; Last byte index used while building the complete 256-entry bit-reversal lookup.

CastingFatigueDividerReload:					equ	$07			; Reload value for the casting-fatigue divider, producing one fatigue decay pass every eight engine subcycles.

CellEffect_TeleportFlash:						equ	$10			; Effect code queued after the flashing teleport commits its destination.
CellEffect_Vivify:								equ	$86			; Effect code queued at the Vivify revival cell.

Champion_Count:									equ	$10			; Loops over all champion records during location lookup.

ChampionLargeAvatar_DrawDimensions:				equ	$0001001D	; Packed DBRA terminal counts for a large champion portrait: two 16-pixel words across and 30 rows.

ChampionPocket_BodyArmour:						equ	$02			; Offset of the dedicated body-armour pocket.
ChampionPocket_CountedObjectCountsOffset:		equ	$0B			; Base offset of the object-code-indexed counted-object quantities in a champion-pockets record.
ChampionPocket_LastIndex:						equ	$0B			; Highest ordinary pocket index in the twelve-pocket scan.
ChampionPocket_LeftHand:						equ	$00			; Offset of the left-hand pocket in a sixteen-byte champion-pockets record.
ChampionPocket_RightHand:						equ	$01			; Offset of the right-hand pocket in a champion-pockets record.
ChampionPocket_Shield:							equ	$03			; Offset of the dedicated shield pocket.

ChampionSelection_TableEntrySize:				equ	$04			; Champion-selection action entries are longwords.

ChampionStat_Agility:							equ	$02			; Champion record agility field.
ChampionStat_ArmourLevel:						equ	$0B			; Champion record armour level field.
ChampionStat_AttackCooldown:					equ	$1B			; Clears the champion attack cooldown.
ChampionStat_Charisma:							equ	$04			; Offset of Charisma in a thirty-two-byte champion-stat record.
ChampionStat_Direction:							equ	$18			; Reads the saved champion facing direction.
ChampionStat_FairySpellCount:					equ	$1E			; Clears spells available for purchase.
ChampionStat_Floor:								equ	$1A			; Compares the champion floor during location lookup.
ChampionStat_FoodLevel:							equ	$10			; Stores the updated food level.
ChampionStat_HitPointsCurrent:					equ	$05			; Restores current hit points to maximum.
ChampionStat_HitPointsMaximum:					equ	$06			; Offset of maximum hit points in a character-stat record.
ChampionStat_Intelligence:						equ	$03			; Champion record intelligence field.
ChampionStat_Level:								equ	$00			; Champion record level field.
ChampionStat_LevelProgress:						equ	$1C			; Champion level-progress field.
ChampionStat_RecordSize:						equ	$20			; Advances to the next champion record.
ChampionStat_RecordSizeShift:					equ	$05			; Right-shift count corresponding to the $20-byte champion record size.
ChampionStat_Speed:								equ	$19			; Champion movement-speed field.
ChampionStat_SpellCooldown:						equ	$15			; Brimstone Broth clears spell cooldown.
ChampionStat_SpellPointsCurrent:				equ	$09			; Selects the current/max spell-point pair for halfway restoration.
ChampionStat_SpellPointsMaximum:				equ	$0A			; Offset of maximum spell points in a character-stat record.
ChampionStat_SpellPowerBoost:					equ	$14			; Champion spell-power adjustment field.
ChampionStat_SpellToCast:						equ	$13			; Marks the champion as not currently casting a spell.
ChampionStat_Strength:							equ	$01			; Champion record strength field.
ChampionStat_Tower:								equ	$1F			; Compares the champion tower during location lookup.
ChampionStat_VitalityCurrent:					equ	$07			; Selects the current/max vitality pair for halfway restoration.
ChampionStat_VitalityMaximum:					equ	$08			; Offset of maximum vitality in a character-stat record.
ChampionStat_WornHandArmour:					equ	$12			; Offset of the worn hand-armour object in a champion-stat record.
ChampionStat_WornSpell:							equ	$11			; Clears the worn spell at session start.
ChampionStat_XPosition:							equ	$16			; Compares the champion X/Y position word during location lookup.
ChampionStat_XPToNextLevel:						equ	$1D			; Initialises the next-level experience value.
ChampionStat_YPosition:							equ	$17			; Loads the champion starting Y coordinate.

ChampionStatRecordLastIndex:					equ	$0F			; Last champion index scanned by the slow global statistic-regeneration loop.

Character_ProfessionMask:						equ	$03			; Low two bits used to select one of the four character professions.
Character_Zendik:								equ	$40			; Character identifier $40 represents Zendik; specific source uses still need identifying.

Combat_StrengthBias:							equ	$08			; Internal Strength bias applied before physical-combat thresholds.

Comms_CharismaBaseline:							equ	$14			; Charisma receives no initial communication bonus at or below this value.
Comms_CharismaShift:							equ	$02			; Right shift converting excess Charisma into an initial attitude bonus.

CommsAction_Boast:								equ	$18			; Communication action selected by Boast.
CommsAction_Bribe:								equ	$08			; Communication action selected by Bribe.
CommsAction_Curse:								equ	$17			; Communication action selected by Curse.
CommsAction_Exchange:							equ	$14			; Communication action selected by Exchange.
CommsAction_FolkLore:							equ	$0E			; Communication action selected by Folk Lore.
CommsAction_Greeting:							equ	$1A			; Initial communication action used when a conversation begins.
CommsAction_Identify:							equ	$01			; Communication action opening the Identify submenu.
CommsAction_Inquiry:							equ	$02			; Communication action opening the Inquiry submenu.
CommsAction_MagicItems:							equ	$0F			; Communication action selected by Magic Items.
CommsAction_NameSelf:							equ	$0C			; Communication action selected by Name Self.
CommsAction_No:									equ	$07			; Communication action selected by No.
CommsAction_Objects:							equ	$10			; Communication action selected by Objects.
CommsAction_Offer:								equ	$12			; Communication action selected by Offer.
CommsAction_Persons:							equ	$11			; Communication action selected by Persons.
CommsAction_Praise:								equ	$16			; Communication action selected by Praise.
CommsAction_Purchase:							equ	$13			; Communication action selected by Purchase.
CommsAction_Recruit:							equ	$00			; Communication action selected by Recruit.
CommsAction_Retort:								equ	$19			; Communication action selected for a contextual Retort.
CommsAction_RevealSelf:							equ	$0D			; Communication action selected by Reveal Self.
CommsAction_Sell:								equ	$15			; Communication action selected by Sell.
CommsAction_Smalltalk:							equ	$05			; Communication action opening the Smalltalk submenu.
CommsAction_Threat:								equ	$09			; Communication action selected by Threat.
CommsAction_ThyTrade:							equ	$0B			; Communication action selected by Thy Trade.
CommsAction_Trading:							equ	$04			; Communication action opening the Trading submenu.
CommsAction_Whereabouts:						equ	$03			; Communication action selected by Whereabouts.
CommsAction_WhoGoes:							equ	$0A			; Communication action selected by Who Goes.
CommsAction_Yes:								equ	$06			; Communication action selected by Yes.

CommsState_AttitudeOffset:						equ	$06			; Offset of mutable communication attitude or rapport.
CommsState_CurrentActionOffset:					equ	$01			; Offset of the communication action currently being performed.
CommsState_FlagsOffset:							equ	$05			; Offset of communication record flags.
CommsState_OtherCharacterOffset:				equ	$02			; Offset of the addressed character identifier and its identity flags.
CommsState_PatienceOffset:						equ	$07			; Offset of communication patience or remaining engagement.
CommsState_PreviousActionOffset:				equ	$00			; Offset of the action to which the other character is responding.
CommsState_SpeakerIdentityOffset:				equ	$03			; Offset of the speaker identifier and disclosed-name/profession flags.
CommsState_TimerOffset:							equ	$04			; Offset of the communication activity timer reset after an action.
CommsState_TradeModeOffset:						equ	$08			; Offset of the active communication trading mode.
CommsState_TradeObjectOffset:					equ	$0A			; Offset of the object code involved in the active trade.
CommsState_TradeValueOffset:					equ	$09			; Offset of the quoted or accepted trade value.

CommsTradeMode_Exchange:						equ	$02			; Exchange communication mode.
CommsTradeMode_None:							equ	$00			; No communication trade is pending.
CommsTradeMode_Purchase:						equ	$01			; Purchase communication mode.
CommsTradeMode_Sell:							equ	$03			; Sell communication mode.

CompactStatsBar_LastIndex:						equ	$02			; The compact player panel draws bar indices zero through two, giving exactly three statistics bars.

Copper_Player1FrameWrapRasterY:					equ	$FF			; CopperList_01 requests the Player 1/frame service at the $FF raster wrap boundary.
Copper_Player2RasterY:							equ	$98			; CopperList_01 requests the Player 2 raster service after waiting for vertical position $98.

CopperInterrupt_RequestWord:					equ	$8010		; CopperList_01 writes $8010 to INTREQ at both raster waits to request the shared level-3 interrupt.

DeadPartyShieldClassColourMask:					equ	$00020103	; Fixed four-colour professional-symbol mask used when D3 is zero for a dead party member.

DialogueColourRamp_EntriesPerState:				equ	$06			; Each dialogue-colour fade ramp contains six hardware-colour words ending at black.
DialogueColourRamp_Player2Offset:				equ	$0C			; Player 2 adds $0C to the entry index to select its orange speech and red alternate ramps.

DialogueText_PaletteIndex:						equ	$0F			; InitialiseText draws ordinary dialogue with foreground ink index 15.

Direction_HalfTurn:								equ	$02			; Toggle the facing between opposite compass directions.
Direction_Mask:									equ	$03			; Wrap a facing value to north, east, south or west.
Direction_OppositeMask:							equ	$02			; Reverses the stored stair facing to obtain the permitted travel direction.

DiskReadTimeoutCount:							equ	$000186A0	; Disk-read timeout counter used while waiting for DMA completion.

Dungeon_CellTypeMask:							equ	$07			; Mask retaining the three-bit dungeon map-cell type.
Dungeon_MapCell_MainWallType:					equ	$01			; Dungeon map-cell type for a main stone wall and its wall-mounted features.
Dungeon_ViewCell_Count:							equ	$13			; Number of player-relative dungeon view cells scanned by the renderer.
Dungeon_ViewCell_LastIndex:						equ	$12			; Highest zero-based index of the nineteen dungeon view cells.

FloorFeature_SubtypeMask:						equ	$03			; Extracts the floor feature independently of the ceiling-hole flag.
FloorFeature_VisiblePadSubtype:					equ	$02			; Visible pads select sound zero before the handler runs.

FloorRegenerationCellType:						equ	$03			; Masked map-cell type recognised by FloorTrigger_Handler as the regeneration feature.

FloorTrigger_IndexMask:							equ	$F8			; Keeps trigger index bits 3-7; shifting once right yields a four-byte record offset.
FloorTrigger_TowerStrideShift:					equ	$07			; Multiplies tower number by 128 bytes for its 32 four-byte trigger records.

FloppyDriveReadySenseBit:						equ	$05			; CIAA port bit polled until the selected floppy drive reports ready.

FloppySectorLastIndex:							equ	$0A			; DBRA terminal index for the eleven sectors in a raw floppy track.

FloppySectorsPerTrack:							equ	$0B			; Number of AmigaDOS sectors encoded or decoded in each raw floppy track handled by the save/load routines.

FloppyTrackZeroSenseBit:						equ	$04			; CIAA port bit tested while recalibrating the floppy head to track zero.

Food_DrinkPortionValue:							equ	$14			; Default portion value for Mead and Water.
Food_LevelLimitExclusive:						equ	$C8			; Tests whether food level must be clamped.
Food_LevelMaximum:								equ	$C7			; Clamps food level to its maximum.
Food_PortionGroupSize:							equ	$03			; Finds whether the selected object is the first stage of a three-object food group.
Food_SolidPortionValue:							equ	$20			; Selects the larger solid-food portion value.
Food_WholeValueStep:							equ	$42			; Adds one food-value step for each N'Egg size.

GamePeriodicTickReload:							equ	$012C		; Reload value for the long periodic update counter; decimal 300 triggers linked-magic decay, floor-trigger checks, navigation-field rebuilds, and party maintenance.

GFX_Pockets_ChainStripCommandPanelOffset:		equ	$3C60		; Packed Pockets.gfx offset of the continuous 96 by 7 chain strip used beneath the party-command menu.
GFX_Pockets_ChainStripContinuousOffset:			equ	$3C00		; Packed Pockets.gfx offset of the continuous 96 by 7 chain strip used at the dungeon-display lower edge and in the inventory presentation.
GFX_Pockets_ChainStripShieldGapsOffset:			equ	$3C30		; Packed Pockets.gfx offset of the 96 by 7 chain strip whose gaps accommodate the four party shields.
GFX_Pockets_CommandPadPlayer1Offset:			equ	$6800		; Packed Pockets.gfx offset of the Player 1 command-pad variant.
GFX_Pockets_CommandPadPlayer2Offset:			equ	$67E0		; Packed Pockets.gfx offset of the Player 2 command-pad variant.
GFX_Pockets_SelectedPartyShieldFrameOffset:		equ	$5070		; Offset of the 32x41 selected living-party shield surround in Pockets.gfx.
GFX_Pockets_SelectedSpellMarkerOffset:			equ	$4130		; Packed Pockets.gfx offset used for the selected-spell marker.
GFX_Pockets_SpellBookOffset:					equ	$4100		; Packed Pockets.gfx offset of the 96 by 62 spell-book surface, including its page-turn arrows.
GFX_Pockets_StatsTitleOffset:					equ	$7580		; Packed Pockets.gfx offset of the 48 by 6 STATS title graphic drawn in the compact statistics frame.
GFX_Pockets_StatusPanelOffset:					equ	$67C0		; Packed Pockets.gfx offset of the 64 by 22 status-panel graphic containing the book and ledger icons.

HeldItem_ObjectCodeByteOffset:					equ	$2F			; Offset of the low byte of the held object code.
HeldItem_ObjectCodeOffset:						equ	$2E			; Offset of the currently held object code in the interface state.
HeldItem_QuantityByteOffset:					equ	$2D			; Offset of the low byte of the held-object quantity.
HeldItem_QuantityOffset:						equ	$2C			; Offset of the held-object quantity word.
HeldItem_StateOffset:							equ	$2C			; Consumes the complete held potion before applying its effect.

InterfaceAction_BackLeftChampion:				equ	$09			; Selects the back-left champion icon.
InterfaceAction_BackRightChampion:				equ	$08			; Selects the back-right champion icon.
InterfaceAction_CloseCurrentPage:				equ	$18			; Closes the current spell-book or interface page.
InterfaceAction_CommsAndOptions:				equ	$1A			; Opens the communications and party-options surface.
InterfaceAction_Display:						equ	$10			; Displays the dungeon view.
InterfaceAction_FrontLeftChampion:				equ	$06			; Selects the front-left champion icon.
InterfaceAction_FrontRightChampion:				equ	$07			; Selects the front-right champion icon.
InterfaceAction_Inventory:						equ	$03			; Opens the inventory window.
InterfaceAction_InventoryObject:				equ	$12			; Handles the selected inventory object.
InterfaceAction_InventoryRefresh:				equ	$11			; Refreshes the inventory.
InterfaceAction_LaunchSpellFromBook:			equ	$15			; Launches the selected spell from the spell book.
InterfaceAction_LoadSave:						equ	$1D			; Opens the load/save interface.
InterfaceAction_MoveBackward:					equ	$0B			; Moves the party backward.
InterfaceAction_MoveForward:					equ	$0A			; Base dungeon action added to the raw-key index so keyboard movement begins with Move Forward.
InterfaceAction_MoveLeft:						equ	$0C			; Moves the party left.
InterfaceAction_MoveRight:						equ	$0D			; Moves the party right.
InterfaceAction_MultiFunction:					equ	$02			; Context-sensitive command that can open a door.
InterfaceAction_PartyCommandMode:				equ	$20			; Changes or toggles the active party-command row.
InterfaceAction_PartyCommandSelection:			equ	$21			; Dispatches a selected party-command menu entry.
InterfaceAction_Pause:							equ	$1C			; Pauses the game.
InterfaceAction_PotionFood:						equ	$13			; Handles potion or food inventory actions.
InterfaceAction_PrimaryAttack:					equ	$04			; Primary attack command.
InterfaceAction_RotateLeft:						equ	$0E			; Rotates the party left.
InterfaceAction_RotateRight:					equ	$0F			; Rotates the party right.
InterfaceAction_ShowTeamAvatars:				equ	$1F			; Shows the team avatars from the communications/options surface.
InterfaceAction_SleepParty:						equ	$1E			; Requests party sleep from the communications/options surface.
InterfaceAction_SpellBook:						equ	$00			; Action 0 opens the spell-book and active-spell page through the dungeon interface action table.
InterfaceAction_Stats:							equ	$01			; Opens the statistics window.
InterfaceAction_TableEntryShift:				equ	$02			; Shift count converting an interface action index into a four-byte jump-table offset.
InterfaceAction_TableEntrySize:					equ	$04			; Size in bytes of each dungeon action-table entry.
InterfaceAction_TurnSpellBookPage:				equ	$17			; Turns a spell-book page through the dungeon interface action table.
InterfaceAction_TurnSpellBookPage_Alternate:	equ	$19			; Second spell-book page-control action; it enters the same page-turn handler through the opposite control.
InterfaceAction_ViewSpell:						equ	$16			; Views the selected spell in the spell book.
InterfaceAction_WallClick:						equ	$23			; Handles a clicked wall feature.
InterfaceAction_WallFeature:					equ	$24			; Direct contextual wall-feature action, including door interaction.

InterfaceHitbox_CommandActionBase:				equ	$1C			; The command-row hitbox table starts at action ID $1C (pause).
InterfaceHitbox_CommandActionCount:				equ	$06			; The command-row hitbox table contains six records for action IDs $1C-$21.
InterfaceHitbox_DisplayActionBase:				equ	$22			; The display/context hitbox table starts at action ID $22.
InterfaceHitbox_DisplayActionCount:				equ	$03			; The display/context hitbox table contains three records for action IDs $22-$24.
InterfaceHitbox_MainActionCount:				equ	$11			; The main player-panel hitbox table contains 17 records for action IDs $00-$10.
InterfaceHitbox_RecordBytes:					equ	$08			; The hit-test scanner advances eight bytes for each rectangle record.
InterfaceHitbox_RecordWords:					equ	$04			; Each interface hitbox is four 16-bit words: X minimum, X maximum, Y minimum and Y maximum.

InterfaceMode_Communication:					equ	$08			; Interface mode value active while communicating with another character.

InterfaceState_MenuOffset:						equ	$44			; Converts the visible communication menu level into a communication action index.

MagicFeature_Formwall:							equ	$03			; Low two-bit map magic-feature subtype used for Formwall.
MagicFeature_Mindrock:							equ	$02			; Low two-bit map magic-feature subtype used for Mindrock.

MainChampionAvatar_ScreenByteOffset:			equ	$02A9		; Player-local screen byte offset for the 32 by 30 large champion portrait at coordinate ($08,$11).

Map_AlignmentYArrayOffset:						equ	$08			; Y-alignment bytes start eight bytes after the X-alignment bytes.
Map_CellByteShift:								equ	$01			; Converts the floor-relative two-byte map offset to a cell number before division by width.
Map_FloorDataOffsetsOffset:						equ	$10			; Offset of the eight big-endian floor cell-data offsets in the header.
Map_FloorHeightsOffset:							equ	$08			; Offset of the eight height bytes in the map header.
Map_HeaderSize:									equ	$38			; Copies the 56-byte header as fourteen longwords.
Map_ResourceSize:								equ	$1000		; Fixed map allocation; object records begin after this map and the two-byte object-length word.

MapCell_ClearFeatureWordMask:					equ	$F8			; Clear first-byte feature data and the three-bit type, retaining second-byte flags.
MapCell_ClearTypeMask:							equ	$F8			; Clear the cell type while preserving upper second-byte flags.
MapCell_ConcealedBit:							equ	$03			; Map-cell flag bit set by Conceal and cleared by Dispel.
MapCell_FloorFeatureType:						equ	$06			; Selects floor-feature cells before testing the pit subtype.
MapCell_MagelockedBit:							equ	$04			; Door-state flag bit toggled by Magelock.
MapCell_MagicFeatureType:						equ	$07			; Map-cell type value shared by Firepath, Mindrock and Formwall.
MapCell_ObjectPresentBit:						equ	$06			; Marks map cells that have a floor or shelf object stack.
MapCell_OccupiedBit:							equ	$07			; Map-cell occupied flag updated when a player changes floor.
MapCell_PillarWord:								equ	$0103		; First byte one and map-cell type three define the puzzle pillar.
MapCell_SpellEntityBit:							equ	$07			; Marks a map cell as containing a live spell or summoned entity.
MapCell_StairsType:								equ	$04			; Selects the stair transition path.
MapCell_TypeMask:								equ	$07			; Low three bits of the second byte select the map-cell type.
MapCell_WallTogglePreserveMask:					equ	$F9			; Discard first-byte data and type bits 1-2 before toggling stone-wall bit zero.

Monster_ColourGradeCount:						equ	$08			; Number of SPS 439 monster palette grades before the renderer clamps to the highest grade index.
Monster_RenderFlagMask:							equ	$1F			; Mask retaining the five monster render-state bits used by the animation lookup.
Monster_Type_First:								equ	$64			; Converts the monster type code into the renderer dispatch index; codes below the first monster type continue to character drawing.

MonsterActionCountdown_LevelBase:				equ	$0E			; Level value used as the starting point for monster action-countdown calculation.
MonsterActionCountdown_Minimum:					equ	$08			; Minimum monster action-countdown level.

MonsterActionState_CastingSpell:				equ	$1F			; Action-state value stored on the casting monster after it launches a spell.

MonsterAttackSpell_ArcBoltIndex:				equ	$0B			; Selects entry eleven of the monster attack-spell table.
MonsterAttackSpell_HighPowerFlag:				equ	$80			; Retains the spellbook flag that suppresses the normal final divide-by-two power step.
MonsterAttackSpell_IndexMask:					equ	$0F			; Reduces the random value to one of the sixteen monster attack-spell entries.

MonsterAttackType_ArcBoltMachine:				equ	$04			; Monster attack-type index for the fixed Arc Bolt machine behavior.
MonsterAttackType_Drone:						equ	$02			; Monster attack-type index for movement-only drone behavior.
MonsterAttackType_DroneSpells:					equ	$03			; Monster attack-type index for drones that occasionally cast spells.
MonsterAttackType_NoSpells:						equ	$00			; Monster attack-type index for non-spellcasting pursuit and melee behavior.
MonsterAttackType_Spells:						equ	$01			; Monster attack-type index for normal spellcasting behavior.

MonsterForm_Zendik:								equ	$40			; Checks the reserved Zendik form.

MonsterHitPoints_BaseBonus:						equ	$19			; Base value added to calculated monster hit points.
MonsterHitPoints_DefaultMultiplierHigh:			equ	$0190		; Default high-level monster hit-point multiplier.
MonsterHitPoints_DefaultMultiplierMid:			equ	$FA			; Default middle-level monster hit-point multiplier.

MonsterLive_RecordCapacity:						equ	$80			; Maximum number of live monster records represented by the cleared workspace.
MonsterLive_RecordCountOffset:					equ	-$02		; Reads the last live-record index before removing a monster.
MonsterLive_WorkspaceLongwordCount:				equ	$0200		; Clears the live-monster workspace.

MonsterRecord_ActionCountdown:					equ	$03			; Assigns the special action countdown used for object-bearing monsters.
MonsterRecord_ActionState:						equ	$05			; Clears the live monster action/status byte.
MonsterRecord_BaseLevel:						equ	$07			; Stores the base live monster level.
MonsterRecord_CarriedObject:					equ	$0C			; Tests whether the monster has a carried object during later monster interaction.
MonsterRecord_CurrentLevel:						equ	$06			; Writes the current live level into the packed record.
MonsterRecord_Floor:							equ	$04			; Copies the floor while compacting team records.
MonsterRecord_Form:								equ	$0B			; Writes the live form into the packed record.
MonsterRecord_HitPoints:						equ	$08			; Stores calculated starting hit points.
MonsterRecord_NoPosition:						equ	$FF			; Marks the source live record as removed.
MonsterRecord_NoTeamGroup:						equ	$FF			; Clears the first team member's group assignment.
MonsterRecord_RotationAndSpace:					equ	$02			; Reads the rotation or occupied-space field while rebuilding teams.
MonsterRecord_RotationFacingShift:				equ	$04			; Shifts the live monster rotation state down from its high nibble before viewer-relative facing is calculated.
MonsterRecord_Size:								equ	$10			; Advances the live monster offset to the next record.
MonsterRecord_SizeShift:						equ	$04			; Converts a live monster byte offset into a record index.
MonsterRecord_TeamGroupIndex:					equ	$0D			; Reads a live monster's team group index.
MonsterRecord_Type:								equ	$0A			; Reads the live monster type for repacking.
MonsterRecord_XPosition:						equ	$00			; Copies the X coordinate while compacting team records.
MonsterRecord_YPosition:						equ	$01			; Copies the Y coordinate while compacting team records.

MonsterTeamData_GroupShift:						equ	$02			; Converts packed member data to a team-group index.

MonsterTeamIndexTable_CountOffset:				equ	-$02		; Reads the last team-row index: team count minus one.
MonsterTeamIndexTable_LongwordCount:			equ	$19			; Clears all twenty-five team groups.

MonsterTeamMember_Count:						equ	$04			; Loops over all four members of each team.
MonsterTeamMember_SlotMask:						equ	$03			; Extracts the team-member slot.

MovementOffset_YTableOffset:					equ	$08			; Each addition advances one cell in Y; the consecutive pair advances two cells.

Object_AceOfSwords:								equ	$37			; Assigns the Ace of Swords to Zendik.
Object_Armour_First:							equ	$1B			; First body-armour object and exclusive end of potions.
Object_Arrows_First:							equ	$03			; First arrow object code.
Object_Axes_First:								equ	$38			; First axe object.
Object_Blades_First:							equ	$30			; First blade object and exclusive end of gloves.
Object_BookOfSkulls:							equ	$6D			; Book of Skulls object and exclusive end of magic rings.
Object_Bows_First:								equ	$5C			; First bow object.
Object_ChampionRemainsFirst:					equ	$40			; Remains objects $40-$4F identify the sixteen champions.
Object_ChaosGloves:								equ	$2B			; Chaos Gloves object code.
Object_Coinage:									equ	$01			; Coinage object code.
Object_CommonKeys:								equ	$02			; Common-key object code.
Object_Crystals_First:							equ	$60			; First crystal object.
Object_DepletedRing:							equ	$68			; Depleted-ring object code.
Object_Drinks_First:							equ	$0E			; Separates solid-food portions from drink portions.
Object_EmptySlot:								equ	$00			; Empty object-slot code.
Object_Food_First:								equ	$05			; First food object and exclusive end of counted objects.
Object_Gems_First:								equ	$64			; First gem object.
Object_Gloves_First:							equ	$2B			; First glove object and exclusive end of all shields.
Object_Keys_First:								equ	$50			; First named-key object.
Object_LargeShields_First:						equ	$27			; First large-shield object.
Object_MagicRings_First:						equ	$69			; First rechargeable magic-ring object.
Object_Neggs_First:								equ	$14			; Separates three-stage food from whole N'Egg food.
Object_Permit:									equ	$5F			; Permit object and exclusive end of bows.
Object_PocketGraphicBankSize:					equ	$14			; Number of pocket graphics in each source-bank step.
Object_Potions_First:							equ	$17			; Separates potion objects from food and counted objects.
Object_PowerStaff:								equ	$3F			; Power Staff object code.
Object_Remains_First:							equ	$40			; First champion-remains object and first normally non-tradable object.
Object_Rings_First:								equ	$68			; First member of the complete ring family.
Object_SmallShields_First:						equ	$24			; First small-shield object and exclusive end of body armour.
Object_StackLimitExclusive:						equ	$64			; Exclusive counted-object quantity limit.
Object_StackMaximum:							equ	$63			; Highest stored quantity for a counted object.
Object_Staffs_First:							equ	$3D			; First staff object.
Object_Swords_First:							equ	$32			; First sword object.
Object_TradeValueTable_First:					equ	$14			; First object represented by the trade-value lookup table.
Object_Wands_First:								equ	$57			; First wand object.

ObjectData_LengthBytes:							equ	$02			; Bytes in the big-endian used-payload-length word preceding object-stack records.

ObjectFloor_HiddenXPosition:					equ	$80			; Signed X-position sentinel that suppresses an unavailable projected floor-object mini-space.
ObjectFloor_SubpositionCount:					equ	$04			; Number of rotated NW/NE/SW/SE object mini-spaces inspected in each dungeon cell.
ObjectFloor_WideGraphicsOffset:					equ	$0CB8		; Byte offset from the ordinary ObjectsOnFloor graphics to the wide-shape graphics bank.
ObjectFloor_WideShapeFirst:						equ	$12			; First object floor-shape that uses the wide graphics bank and explicit projection-width selector.

ObjectStack_CountMinusOneOffset:				equ	$02			; Loads the number of additional two-byte object/quantity pairs.
ObjectStack_ItemBytes:							equ	$02			; Grows the used object payload by one code/quantity pair without comparing against the allocation capacity.
ObjectStack_MapOffsetMask:						equ	$3FFF		; Retains the 14-bit map-payload byte offset; bits 15-14 encode the object mini-space.
ObjectStack_MinimumBytes:						equ	$05			; Minimum record is location word, count-minus-one byte, and one object/quantity pair.

PackedMonster_FloorEncodingBias:				equ	$01			; Removes the packed floor encoding bias before splitting type and floor.
PackedMonster_FormOffset:						equ	$04			; Packed monster form/graphic identifier.
PackedMonster_LevelOffset:						equ	$03			; Packed monster level.
PackedMonster_NibbleMask:						equ	$0F			; Extracts the packed floor nibble.
PackedMonster_NoTeamData:						equ	$FF			; Detects a packed record without team data.
PackedMonster_RecordSize:						equ	$06			; Size of one packed monster record.
PackedMonster_TeamDataOffset:					equ	$05			; Writes team data into packed byte five.
PackedMonster_TowerBlockLongwordCount:			equ	$C0			; Clears one complete packed monster tower block.
PackedMonster_TowerBlockShift:					equ	$08			; Selects the packed tower block during live-to-packed transfer.
PackedMonster_TowerBlockSize:					equ	$0300		; Size of one packed monster tower block.
PackedMonster_TypeAndFloorOffset:				equ	$00			; Packed byte containing monster type in the high nibble and floor in the low nibble.
PackedMonster_TypeShift:						equ	$04			; Extracts the packed monster type nibble.
PackedMonster_XCoordinateOffset:				equ	$01			; Packed monster X coordinate.
PackedMonster_YCoordinateOffset:				equ	$02			; Packed monster Y coordinate.

PartyPresentation_LowerFirstY:					equ	$37			; First player-local Y coordinate of the lower party-shield click rows.
PartyPresentation_LowerSlotMask:				equ	$0E			; Mask for the three lower party-shield presentation bits in PlayerX_Data+$003E.
PartyPresentation_StatsXFirst:					equ	$30			; First X coordinate of the compact-statistics area that requests party commands.

PartyShieldFrameSourceRowSkip:					equ	$90			; Source-row skip after reading a two-word-wide crop from the 320-pixel Pockets sheet.

PartyShieldStatusBar_LastSlot:					equ	$03			; DBRA terminal index that visits all four party-shield status-bar slots.
PartyShieldStatusBar_ScaleHeight:				equ	$15			; Sets the scale target used only when a party member's current HP is below maximum.
PartyShieldStatusBar_SuppressionMask:			equ	$E0			; Masks vacant and dead party-slot state bits so those slots receive no HP bar.

PhysicalAttack_CooldownInitial:					equ	$07			; Initial cooldown written whenever a champion performs a physical attack.
PhysicalAttack_VitalityCost:					equ	$03			; Vitality removed when champion combat values are loaded for physical combat.

PlanarColourMask_IndexMask:						equ	$0C			; Mask converting a two-bit destination colour value into a longword mask-table offset.

Player_ActionCommandOffset:						equ	$0C			; Offset of the active per-player interface command.
Player_ActionInvalid:							equ	$FFFF		; Value meaning no active action.
Player_AttackPrimaryStateBit:					equ	$01			; State bit set by the primary attack handler.
Player_PendingActionOffset:						equ	$56			; Offset read when transferring a pending action into the active command.

Player1_CompactStatsColourIndex:				equ	$07			; The compact Player 1 statistics bars use hard-coded palette index $07.

Player2_CompactStatsColourIndex:				equ	$0C			; The compact Player 2 statistics bars use hard-coded palette index $0C.

PlayerData_AvatarPresentationState:				equ	$3E			; Offset of the four-bit main/lower-avatar presentation state in a PlayerX_Data record.
PlayerData_DialogueAlternateRampBit:			equ	$06			; Bit 6 of the dialogue-colour state byte selects the shared red monster/alternate-speaker ramp.
PlayerData_DialogueColourOffset:				equ	$4C			; Active PlayerX_Data stores the current hardware dialogue-text colour 15 word at offset $4C.
PlayerData_DialogueColourStateOffset:			equ	$52			; Active PlayerX_Data stores dialogue-colour fade and alternate-speaker flags at offset $52.
PlayerData_Direction:							equ	$20			; Stores the champion facing direction in the active player record.
PlayerData_Floor:								equ	$58			; Stores the champion floor in the active player record.
PlayerData_InterfaceScreenBufferOffset:			equ	$0A			; PlayerX_Data stores the framebuffer destination offset added to interface drawing addresses at offset $0A.
PlayerData_PartyCommandStateOffset:				equ	$42			; Offset of the signed party-command/interface state word in each PlayerData record; $FFFF means inactive and states $0000-$0008 select dispatcher states.
PlayerData_PlayerIdentityBit:					equ	$00			; Bit 0 of the active player record selects Player 2's orange dialogue-ramp family when set.
PlayerData_StartXPosition:						equ	$1C			; Stores the champion start X position in the active player record.
PlayerData_StartYPosition:						equ	$1E			; Stores the champion start Y position in the active player record.
PlayerData_UIPrimaryColourOffset:				equ	$10			; PlayerX_Data stores the primary interface background and selection colour index at offset $10.
PlayerData_UISecondaryColourOffset:				equ	$12			; PlayerX_Data stores the colour index used to replace template ink $F in player-coloured interface graphics at offset $12.

PowerStaff_SpellCastingBonus:					equ	$05			; Spell-casting quality bonus supplied by a held Power Staff.

Recharge_PowerShift:							equ	$03			; Right shift converting spell power into replacement magic-ring uses.

SaveDataTrackLastIndex:							equ	$08			; DBRA last index for the nine raw floppy tracks transferred as champion save data.

Screen_BitplaneRowBytes:						equ	$28			; Number of bytes in one 320-pixel screen row for a single bitplane.

SinglePlayerSaveDataStartTrack:					equ	$3C			; Starting floppy track used for one-player champion save data.

Sound_AlternativeSpell:							equ	$05			; Alternative spell-effect sound ID.
Sound_AttackClink:								equ	$02			; Sound ID for the physical attack or fighting clink.
Sound_CharacterDeath:							equ	$03			; Sound ID played when a character reaches the death-state handling path.
Sound_DoorClick:								equ	$01			; Sound ID for the ordinary wall-feature or door toggle click.
Sound_SpellRoar:								equ	$04			; Sound ID for the spell or fireball sound.
Sound_SwitchClick:								equ	$00			; Sound ID for the switch or interface click effect.

SpellBook_PageSpreadIncrement:					equ	$02			; Advances the spell book by one two-page spread.

SpellCasting_ActionCooldown:					equ	$0F			; Champion action cooldown applied when a spell-cast attempt begins.
SpellCasting_CastBarMaximumWidth:				equ	$34			; Maximum CAST bar width in pixels.
SpellCasting_CooldownBaseIncrement:				equ	$05			; Base spell-cooldown increment added to the selected spell cost value after quality is calculated.
SpellCasting_CooldownMaximum:					equ	$64			; Maximum accumulated spell cooldown.
SpellCasting_ManaCostMaximum:					equ	$64			; Exclusive spell-point cost ceiling used while normalising byte $14.
SpellCasting_ManaCostMinimum:					equ	$01			; Minimum calculated spell-point cost.
SpellCasting_MatchingWandBonus:					equ	$03			; Cast-quality bonus for a held wand matching a non-matching spell.
SpellCasting_PracticeFirstThreshold:			equ	$05			; First spell-practice threshold for matching spells.
SpellCasting_VitalityCost:						equ	$04			; Vitality removed when a champion launches a spell.

SpellCastingCostMultiplier:						equ	$05			; Multiplier applied to the selected spell's raw cost-table byte to obtain its casting cost.

SpellPracticeClearLongwordLastIndex:			equ	$7F			; Last longword index cleared when initialising the 512-byte spell-practice table.

Stair_DownBit:									equ	$00			; A clear bit ascends one floor; a set bit descends one floor.

StoneWall_FacingMask:							equ	$30			; Facing occupies second-byte bits 4-5.
StoneWall_FacingPreserveMask:					equ	$CF			; Keep all second-byte fields except the wall-facing bits.
StoneWall_FacingStep:							equ	$10			; Advance the two-bit wall-facing field by one direction.
StoneWall_RemoveFeatureMask:					equ	$4F			; Removing a stone wall clears its decoration flag and facing bits.

TriggerAction_FlashTeleport:					equ	$2A			; Action byte is a byte offset into the trigger word-displacement table.
TriggerAction_VivifyExternal:					equ	$08			; Action byte is a byte offset into the trigger word-displacement table.
TriggerAction_VivifyInternal:					equ	$0A			; Action byte is a byte offset into the trigger word-displacement table.

TriggerSound_None:								equ	$FFFF		; Negative trigger sound suppresses playback, rather than requesting a delay.

TriggerTeleportStack_CellOffset:				equ	$08			; Saved dispatcher D0 after the handler and commit-helper return addresses.
TriggerTeleportStack_PackedXYOffset:			equ	$0C			; Replace saved dispatcher D7 after the two return addresses.

TwoPlayerSaveDataStartTrack:					equ	$46			; Starting floppy track used for two-player champion save data.

VivifyImpactCode:								equ	$86			; Map-cell impact code queued by both Vivify-machine paths and the Vivify spell before revival processing.

VivifyRestoredStatValue:						equ	$05			; Hit-points and vitality value assigned when an internally held dead party member is revived.

WallOverlay_ColourEntryShift:					equ	$02			; Shift converting a wall-overlay colour index into a four-byte table offset.
WallOverlay_ColourIndexMask:					equ	$07			; Mask selecting one of eight wall-overlay colour entries.

WallSprite_IndexMask:							equ	$7F			; Mask removing the horizontal-mirror flag from a wall-component picture index.

WallSwitch_DimBit:								equ	$02			; Switch light-state bit toggled for every nonzero reference.
WallSwitch_IndexMask:							equ	$F8			; Bits 3-7 encode the switch record reference.
WallSwitch_TowerStrideShift:					equ	$06			; Each tower has sixteen four-byte switch records.

WallTransform_FlagMask:							equ	$07			; Mask retaining the three wall perspective-transform control bits.

Weapon_AceOfSwordsRecordOffset:					equ	$1C			; Byte offset of the Ace of Swords record within Weapon_CombatModifiers.
Weapon_BackstabEligibleByteLimit:				equ	$08			; Exclusive byte-offset limit for weapon records which preserve a Cutpurse backstab.
Weapon_CombatModifierRecordCount:				equ	$10			; Number of four-byte records in Weapon_CombatModifiers.

WoodEdges_QuarterTurnBits:						equ	$02			; One wooden edge occupies two bits; rotate right to move each edge counterclockwise.

WornSpell_Antimage:								equ	$06			; Low three-bit worn-spell type used for Antimage.
WornSpell_Armour:								equ	$00			; Low three-bit worn-spell type used for Armour.
WornSpell_Beguile_BaseBonus:					equ	$01			; Minimum attitude and patience bonus supplied by a successful Beguile spell.
WornSpell_Beguile_PowerShift:					equ	$02			; Right shift converting Beguile spell power into its communication bonus.
WornSpell_Compass:								equ	$04			; Low three-bit worn-spell type used for Compass.
WornSpell_Deflect:								equ	$01			; Low three-bit worn-spell type used for Deflect.
WornSpell_Levitate:								equ	$05			; Low three-bit worn-spell type used for Levitate.
WornSpell_PowerMaximum:							equ	$3F			; Largest worn-spell power accepted before packing.
WornSpell_PowerShift:							equ	$02			; Shift placing worn-spell power above the low three-bit type field.
WornSpell_Trueview:								equ	$07			; Low three-bit worn-spell type used for Trueview.
WornSpell_TypeMask:								equ	$07			; Clears the low three type bits before a worn-spell type is packed into the value.
WornSpell_Vanish:								equ	$03			; Low three-bit worn-spell type used for Vanish.
WornSpell_Warpower:								equ	$02			; Low three-bit worn-spell type used for Warpower.

WoundFlashHighlightReload:						equ	$07			; Party-shield highlight countdown loaded when a combat wound-flash number is drawn.

Wychwind_PowerBonus:							equ	$0A			; Power added before Wychwind creates its eight projectiles.
Wychwind_ProjectileCount:						equ	$08			; Number of radial Wychwind projectiles created by one cast.
