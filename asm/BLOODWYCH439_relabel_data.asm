
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
AirbourneSpell_GeneralFirstCode:				equ	$86			; First airborne-spell code using the general spell picture/layout family rather than the fireball family.
Champion_Count:									equ	$10			; Loops over all champion records during location lookup.
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
DiskReadTimeoutCount:							equ	$000186A0	; Disk-read timeout counter used while waiting for DMA completion.
Dungeon_CellTypeMask:							equ	$07			; Mask retaining the three-bit dungeon map-cell type.
Dungeon_ViewCell_Count:							equ	$13			; Number of player-relative dungeon view cells scanned by the renderer.
Food_DrinkPortionValue:							equ	$14			; Default portion value for Mead and Water.
Food_LevelLimitExclusive:						equ	$C8			; Tests whether food level must be clamped.
Food_LevelMaximum:								equ	$C7			; Clamps food level to its maximum.
Food_PortionGroupSize:							equ	$03			; Finds whether the selected object is the first stage of a three-object food group.
Food_SolidPortionValue:							equ	$20			; Selects the larger solid-food portion value.
Food_WholeValueStep:							equ	$42			; Adds one food-value step for each N'Egg size.
HeldItem_ObjectCodeByteOffset:					equ	$2F			; Offset of the low byte of the held object code.
HeldItem_ObjectCodeOffset:						equ	$2E			; Offset of the currently held object code in the interface state.
HeldItem_QuantityByteOffset:					equ	$2D			; Offset of the low byte of the held-object quantity.
HeldItem_QuantityOffset:						equ	$2C			; Offset of the held-object quantity word.
HeldItem_StateOffset:							equ	$2C			; Consumes the complete held potion before applying its effect.
InterfaceAction_BackLeftChampion:				equ	$09			; Selects the back-left champion icon.
InterfaceAction_BackRightChampion:				equ	$08			; Selects the back-right champion icon.
InterfaceAction_Display:						equ	$10			; Displays the dungeon view.
InterfaceAction_FrontLeftChampion:				equ	$06			; Selects the front-left champion icon.
InterfaceAction_FrontRightChampion:				equ	$07			; Selects the front-right champion icon.
InterfaceAction_Inventory:						equ	$03			; Opens the inventory window.
InterfaceAction_InventoryObject:				equ	$12			; Handles the selected inventory object.
InterfaceAction_InventoryRefresh:				equ	$11			; Refreshes the inventory.
InterfaceAction_LoadSave:						equ	$1D			; Opens the load/save interface.
InterfaceAction_MoveBackward:					equ	$0B			; Moves the party backward.
InterfaceAction_MoveForward:					equ	$0A			; Base dungeon action added to the raw-key index so keyboard movement begins with Move Forward.
InterfaceAction_MoveLeft:						equ	$0C			; Moves the party left.
InterfaceAction_MoveRight:						equ	$0D			; Moves the party right.
InterfaceAction_MultiFunction:					equ	$02			; Context-sensitive command that can open a door.
InterfaceAction_Pause:							equ	$1C			; Pauses the game.
InterfaceAction_PotionFood:						equ	$13			; Handles potion or food inventory actions.
InterfaceAction_PrimaryAttack:					equ	$04			; Primary attack command.
InterfaceAction_RotateLeft:						equ	$0E			; Rotates the party left.
InterfaceAction_RotateRight:					equ	$0F			; Rotates the party right.
InterfaceAction_Stats:							equ	$01			; Opens the statistics window.
InterfaceAction_TableEntryShift:				equ	$02			; Shift count converting an interface action index into a four-byte jump-table offset.
InterfaceAction_TableEntrySize:					equ	$04			; Size in bytes of each dungeon action-table entry.
InterfaceAction_WallClick:						equ	$23			; Handles a clicked wall feature.
InterfaceAction_WallFeature:					equ	$24			; Direct contextual wall-feature action, including door interaction.
InterfaceMode_Communication:					equ	$08			; Interface mode value active while communicating with another character.
InterfaceState_MenuOffset:						equ	$44			; Converts the visible communication menu level into a communication action index.
Monster_ColourGradeCount:						equ	$08			; Number of SPS 439 monster palette grades before the renderer clamps to the highest grade index.
Monster_RenderFlagMask:							equ	$1F			; Mask retaining the five monster render-state bits used by the animation lookup.
Monster_Type_First:								equ	$64			; Converts the monster type code into the renderer dispatch index; codes below the first monster type continue to character drawing.
MonsterActionCountdown_LevelBase:				equ	$0E			; Level value used as the starting point for monster action-countdown calculation.
MonsterActionCountdown_Minimum:					equ	$08			; Minimum monster action-countdown level.
MonsterForm_Zendik:								equ	$40			; Checks the reserved Zendik form.
MonsterHitPoints_BaseBonus:						equ	$19			; Base value added to calculated monster hit points.
MonsterHitPoints_DefaultMultiplierHigh:			equ	$0190		; Default high-level monster hit-point multiplier.
MonsterHitPoints_DefaultMultiplierMid:			equ	$FA			; Default middle-level monster hit-point multiplier.
MonsterLive_RecordCapacity:						equ	$80			; Maximum number of live monster records represented by the cleared workspace.
MonsterLive_RecordCountOffset:					equ	-$02		; Reads the live monster count before removing a record.
MonsterLive_WorkspaceLongwordCount:				equ	$0200		; Clears the live-monster workspace.
MonsterRecord_ActionCountdown:					equ	$03			; Assigns the special action countdown used for object-bearing monsters.
MonsterRecord_ActionState:						equ	$05			; Clears the live monster action/status byte.
MonsterRecord_CurrentLevel:						equ	$06			; Writes the current live level into the packed record.
MonsterRecord_BaseLevel:						equ	$07			; Stores the base live monster level.
MonsterRecord_CarriedObject:					equ	$0C			; Tests whether the monster has a carried object during later monster interaction.
MonsterRecord_Floor:							equ	$04			; Copies the floor while compacting team records.
MonsterRecord_Form:								equ	$0B			; Writes the live form into the packed record.
MonsterRecord_HitPoints:						equ	$08			; Stores calculated starting hit points.
MonsterRecord_NoPosition:						equ	$FF			; Marks the source live record as removed.
MonsterRecord_NoTeamGroup:						equ	$FF			; Clears the first team member's group assignment.
MonsterRecord_RotationAndSpace:					equ	$02			; Reads the rotation or occupied-space field while rebuilding teams.
MonsterRecord_Size:								equ	$10			; Advances the live monster offset to the next record.
MonsterRecord_SizeShift:						equ	$04			; Converts a live monster byte offset into a record index.
MonsterRecord_TeamGroupIndex:					equ	$0D			; Reads a live monster's team group index.
MonsterRecord_Type:								equ	$0A			; Reads the live monster type for repacking.
MonsterRecord_XPosition:						equ	$00			; Copies the X coordinate while compacting team records.
MonsterRecord_YPosition:						equ	$01			; Copies the Y coordinate while compacting team records.
MonsterTeamData_GroupShift:						equ	$02			; Converts packed member data to a team-group index.
MonsterTeamIndexTable_CountOffset:				equ	-$02		; Reads the number of populated team groups.
MonsterTeamIndexTable_LongwordCount:			equ	$19			; Clears all twenty-five team groups.
MonsterTeamMember_Count:						equ	$04			; Loops over all four members of each team.
MonsterTeamMember_SlotMask:						equ	$03			; Extracts the team-member slot.
Object_AceOfSwords:								equ	$37			; Assigns the Ace of Swords to Zendik.
Object_Armour_First:							equ	$1B			; First body-armour object and exclusive end of potions.
Object_Arrows_First:							equ	$03			; First arrow object code.
Object_Axes_First:								equ	$38			; First axe object.
Object_Blades_First:							equ	$30			; First blade object and exclusive end of gloves.
Object_BookOfSkulls:							equ	$6D			; Book of Skulls object and exclusive end of magic rings.
Object_Bows_First:								equ	$5C			; First bow object.
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
PhysicalAttack_CooldownInitial:					equ	$07			; Initial cooldown written whenever a champion performs a physical attack.
PhysicalAttack_VitalityCost:					equ	$03			; Vitality removed when champion combat values are loaded for physical combat.
PlanarColourMask_IndexMask:						equ	$0C			; Mask converting a two-bit destination colour value into a longword mask-table offset.
Player_ActionCommandOffset:						equ	$0C			; Offset of the active per-player interface command.
Player_ActionInvalid:							equ	$FFFF		; Value meaning no active action.
Player_AttackPrimaryStateBit:					equ	$01			; State bit set by the primary attack handler.
Player_PendingActionOffset:						equ	$56			; Offset read when transferring a pending action into the active command.
PlayerData_Direction:							equ	$20			; Stores the champion facing direction in the active player record.
PlayerData_Floor:								equ	$58			; Stores the champion floor in the active player record.
PlayerData_StartXPosition:						equ	$1C			; Stores the champion start X position in the active player record.
PlayerData_StartYPosition:						equ	$1E			; Stores the champion start Y position in the active player record.
PowerStaff_SpellCastingBonus:					equ	$05			; Spell-casting quality bonus supplied by a held Power Staff.
Screen_BitplaneRowBytes:						equ	$28			; Number of bytes in one 320-pixel screen row for a single bitplane.
Sound_AlternativeSpell:							equ	$05			; Alternative spell-effect sound ID.
Sound_AttackClink:								equ	$02			; Sound ID for the physical attack or fighting clink.
Sound_CharacterDeath:							equ	$03			; Sound ID played when a character reaches the death-state handling path.
Sound_DoorClick:								equ	$01			; Sound ID for the ordinary wall-feature or door toggle click.
Sound_SpellRoar:								equ	$04			; Sound ID for the spell or fireball sound.
Sound_SwitchClick:								equ	$00			; Sound ID for the switch or interface click effect.
SpellCasting_VitalityCost:						equ	$04			; Vitality removed when a champion launches a spell.
WallOverlay_ColourEntryShift:					equ	$02			; Shift converting a wall-overlay colour index into a four-byte table offset.
WallOverlay_ColourIndexMask:					equ	$07			; Mask selecting one of eight wall-overlay colour entries.
WallSprite_IndexMask:							equ	$7F			; Mask removing the horizontal-mirror flag from a wall-component picture index.
WallTransform_FlagMask:							equ	$07			; Mask retaining the three wall perspective-transform control bits.
Weapon_AceOfSwordsRecordOffset:					equ	$1C			; Byte offset of the Ace of Swords record within Weapon_CombatModifiers.
Weapon_BackstabEligibleByteLimit:				equ	$08			; Exclusive byte-offset limit for weapon records which preserve a Cutpurse backstab.
Weapon_CombatModifierRecordCount:				equ	$10			; Number of four-byte records in Weapon_CombatModifiers.
WornSpell_Beguile_BaseBonus:					equ	$01			; Minimum attitude and patience bonus supplied by a successful Beguile spell.
WornSpell_Beguile_PowerShift:					equ	$02			; Right shift converting Beguile spell power into its communication bonus.
WornSpell_Warpower:								equ	$02			; Low three-bit worn-spell type used for Warpower.
AirbourneSpell_Fireball:						equ	$80			; Live-entity form code used by Fireball projectiles.
AirbourneSpell_Wychwind:						equ	$81			; Live-entity form code used by each Wychwind projectile.
AirbourneSpell_ArcBolt:							equ	$82			; Live-entity form code used by Arc Bolt projectiles.
AirbourneSpell_Disrupt:							equ	$83			; Live-entity form code used by Disrupt projectiles.
AirbourneSpell_Blaze:							equ	$84			; Live-entity form code used by Blaze projectiles.
AirbourneSpell_Firepath:						equ	$87			; Live-entity form code used to launch Firepath.
AirbourneSpell_Missile:							equ	$8A			; Live-entity form code used by Missile projectiles.
AirbourneSpell_Confuse:							equ	$8B			; Live-entity form code used by Confuse projectiles.
AirbourneSpell_Paralyze:						equ	$8C			; Live-entity form code used by Paralyze projectiles.
AirbourneSpell_Beguile:							equ	$8D			; Spell-effect code queued after Beguile changes the communication state.
AirbourneSpell_Spelltap:						equ	$8E			; Live-entity form code used by Spelltap projectiles.
AirbourneSpell_Terror:							equ	$8F			; Live-entity form code used by Terror projectiles.
WornSpell_Armour:								equ	$00			; Low three-bit worn-spell type used for Armour.
WornSpell_Deflect:								equ	$01			; Low three-bit worn-spell type used for Deflect.
WornSpell_Vanish:								equ	$03			; Low three-bit worn-spell type used for Vanish.
WornSpell_Compass:								equ	$04			; Low three-bit worn-spell type used for Compass.
WornSpell_Levitate:								equ	$05			; Low three-bit worn-spell type used for Levitate.
WornSpell_Antimage:								equ	$06			; Low three-bit worn-spell type used for Antimage.
WornSpell_Trueview:								equ	$07			; Low three-bit worn-spell type used for Trueview.
WornSpell_TypeMask:								equ	$07			; Clears the low three type bits before a worn-spell type is packed into the value.
WornSpell_PowerMaximum:							equ	$3F			; Largest worn-spell power accepted before packing.
WornSpell_PowerShift:							equ	$02			; Shift placing worn-spell power above the low three-bit type field.
SpellCasting_ActionCooldown:					equ	$0F			; Champion action cooldown applied when a spell-cast attempt begins.
SpellCasting_CooldownMaximum:					equ	$64			; Maximum accumulated spell cooldown.
Alchemy_BaseCoinageGain:						equ	$05			; Coinage added by Alchemy before the spell-power contribution.
Recharge_PowerShift:							equ	$03			; Right shift converting spell power into replacement magic-ring uses.
Wychwind_ProjectileCount:						equ	$08			; Number of radial Wychwind projectiles created by one cast.
Wychwind_PowerBonus:							equ	$0A			; Power added before Wychwind creates its eight projectiles.
MagicFeature_Mindrock:							equ	$02			; Low two-bit map magic-feature subtype used for Mindrock.
MagicFeature_Formwall:							equ	$03			; Low two-bit map magic-feature subtype used for Formwall.
MapCell_MagicFeatureType:						equ	$07			; Map-cell type value shared by Firepath, Mindrock and Formwall.
MapCell_ConcealedBit:							equ	$03			; Map-cell flag bit set by Conceal and cleared by Dispel.
MapCell_MagelockedBit:							equ	$04			; Door-state flag bit toggled by Magelock.
MapCell_SpellEntityBit:							equ	$07			; Marks a map cell as containing a live spell or summoned entity.
InterfaceAction_SpellBook:						equ	$00			; Action 0 opens the spell-book and active-spell page through the dungeon interface action table.
InterfaceAction_LaunchSpellFromBook:			equ	$15			; Launches the selected spell from the spell book.
InterfaceAction_ViewSpell:						equ	$16			; Views the selected spell in the spell book.
InterfaceAction_TurnSpellBookPage:				equ	$17			; Turns a spell-book page through the dungeon interface action table.
InterfaceAction_CloseCurrentPage:				equ	$18			; Closes the current spell-book or interface page.
InterfaceAction_TurnSpellBookPage_Alternate:	equ	$19			; Second spell-book page-control action; it enters the same page-turn handler through the opposite control.
InterfaceAction_CommsAndOptions:				equ	$1A			; Opens the communications and party-options surface.
InterfaceAction_SleepParty:						equ	$1E			; Requests party sleep from the communications/options surface.
InterfaceAction_ShowTeamAvatars:				equ	$1F			; Shows the team avatars from the communications/options surface.
InterfaceAction_PartyCommandMode:				equ	$20			; Changes or toggles the active party-command row.
InterfaceAction_PartyCommandSelection:			equ	$21			; Dispatches a selected party-command menu entry.
InterfaceHitbox_RecordWords:					equ	$04			; Each interface hitbox is four 16-bit words: X minimum, X maximum, Y minimum and Y maximum.
InterfaceHitbox_RecordBytes:					equ	$08			; The hit-test scanner advances eight bytes for each rectangle record.
InterfaceHitbox_MainActionCount:				equ	$11			; The main player-panel hitbox table contains 17 records for action IDs $00-$10.
InterfaceHitbox_CommandActionBase:				equ	$1C			; The command-row hitbox table starts at action ID $1C (pause).
InterfaceHitbox_CommandActionCount:				equ	$06			; The command-row hitbox table contains six records for action IDs $1C-$21.
InterfaceHitbox_DisplayActionBase:				equ	$22			; The display/context hitbox table starts at action ID $22.
InterfaceHitbox_DisplayActionCount:				equ	$03			; The display/context hitbox table contains three records for action IDs $22-$24.
PlayerData_DialogueColourOffset:				equ	$4C			; Active PlayerX_Data stores the current hardware dialogue-text colour 15 word at offset $4C.
PlayerData_DialogueColourStateOffset:			equ	$52			; Active PlayerX_Data stores dialogue-colour fade and alternate-speaker flags at offset $52.
PlayerData_PlayerIdentityBit:					equ	$00			; Bit 0 of the active player record selects Player 2's orange dialogue-ramp family when set.
PlayerData_DialogueAlternateRampBit:			equ	$06			; Bit 6 of the dialogue-colour state byte selects the shared red monster/alternate-speaker ramp.
DialogueColourRamp_EntriesPerState:				equ	$06			; Each dialogue-colour fade ramp contains six hardware-colour words ending at black.
DialogueColourRamp_Player2Offset:				equ	$0C			; Player 2 adds $0C to the entry index to select its orange speech and red alternate ramps.
GFX_Pockets_InventoryInterfaceOffset:			equ	$3C00		; Packed Pockets.gfx offset containing the inventory chain/interface strip.
GFX_Pockets_SpellBookOffset:					equ	$4100		; Packed Pockets.gfx offset used for the spell-book surface.
GFX_Pockets_SelectedSpellMarkerOffset:			equ	$4130		; Packed Pockets.gfx offset used for the selected-spell marker.
GFX_Pockets_StatusPanelOffset:					equ	$67C0		; Packed Pockets.gfx offset used by the status-panel interface pieces.
GFX_Pockets_CommandPanelOffset:					equ	$7580		; Packed Pockets.gfx offset used by the lower status/command interface pieces.
DialogueText_PaletteIndex:						equ	$0F			; InitialiseText draws ordinary dialogue with foreground ink index 15.
Copper_Player2RasterY:							equ	$98			; CopperList_01 requests the Player 2 raster service after waiting for vertical position $98.
Copper_Player1FrameWrapRasterY:					equ	$FF			; CopperList_01 requests the Player 1/frame service at the $FF raster wrap boundary.
CopperInterrupt_RequestWord:					equ	$8010		; CopperList_01 writes $8010 to INTREQ at both raster waits to request the shared level-3 interrupt.
PlayerData_UIPrimaryColourOffset:				equ	$10			; PlayerX_Data stores the primary interface background and selection colour index at offset $10.
PlayerData_UISecondaryColourOffset:				equ	$12			; PlayerX_Data stores the colour index used to replace template ink $F in player-coloured interface graphics at offset $12.
CompactStatsBar_LastIndex:						equ	$02			; The compact player panel draws bar indices zero through two, giving exactly three statistics bars.
Player1_CompactStatsColourIndex:				equ	$07			; The compact Player 1 statistics bars use hard-coded palette index $07.
Player2_CompactStatsColourIndex:				equ	$0C			; The compact Player 2 statistics bars use hard-coded palette index $0C.
PlayerData_InterfaceScreenBufferOffset:			equ	$0A			; PlayerX_Data stores the framebuffer destination offset added to interface drawing addresses at offset $0A.
DeadPartyShieldClassColourMask:					equ	$00020103	; Fixed four-colour professional-symbol mask used when D3 is zero for a dead party member.
GFX_Pockets_SelectedPartyShieldFrameOffset:		equ	$5070		; Offset of the 32x41 selected living-party shield surround in Pockets.gfx.
PartyShieldFrameSourceRowSkip:					equ	$90			; Source-row skip after reading a two-word-wide crop from the 320-pixel Pockets sheet.
PlayerData_PartyCommandStateOffset:				equ	$42			; Offset of the signed party-command/interface state word in each PlayerData record; $FFFF means inactive and states $0000-$0008 select dispatcher states.
MainChampionAvatar_ScreenByteOffset:			equ	$02A9		; Player-local screen byte offset for the 32 by 30 large champion portrait at coordinate ($08,$11).
ChampionLargeAvatar_DrawDimensions:				equ	$0001001D	; Packed DBRA terminal counts for a large champion portrait: two 16-pixel words across and 30 rows.

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
	move.w	#$7FFF,_custom+intena.l												;33FC7FFF00DFF09A
	move.w	#$7FFF,_custom+intreq.l												;33FC7FFF00DFF09C
;  
; Copies 40 bytes of code starting at CodeMover to $00000090
;  
	lea		CodeMover(pc),a0													;41FA0020
	lea		$00000090.l,a1														;43F900000090
	moveq	#$28,d0																;7028
.loop:
	move.b	(a0)+,(a1)+															;12D8
	dbra	d0,.loop															;51C8FFFC
;  
; Cache the game code start address in A6
;  
	lea		GameStart(pc),a6													;4DFA0038
;  
; Put the address of the moved code into the trap vector
;  
	move.l	#$00000090,tv_TrapInstrVects.l										;23FC0000009000000080
;  
; Trigger the trap...
;  
	trap	#$00																;4E40
;  
; This gets executed for trap #$00.
; On entry, A6 holds the address of GameStart when the code was loaded.
; Now gets relocated to $0400.
;  
CodeMover:
	move.l	#$0005909C,d0														;203C0005909C
	move.w	#$7FFF,_custom+intreq.l												;33FC7FFF00DFF09C
	lea		GameStart.l,a0														;41F900000400
.loop:
	move.b	(a6)+,(a0)+															;10DE
	subq.l	#$01,d0																;5380
	bcc.s	.loop																;64FA
	move.w	#$7FFF,_custom+intreq.l												;33FC7FFF00DFF09C
;  
; The code is now in its proper place.
; So just jump on in.  All labels will now reslve to their
; correct absolute addresses.
;  
	jmp		GameStart.l															;4EF900000400

;fiX Label expected
	dc.w	$0000	;0000

GameStart:
	move.w	#$7FFF,_custom+intena.l												;33FC7FFF00DFF09A
	move.w	#$7FFF,_custom+intreq.l												;33FC7FFF00DFF09C
	lea		$0005FFFC.l,sp														;4FF90005FFFC
	clr.b	SyncFlagHighByte_AI_TBC.l											;423900008C1F
	bsr		Init_CustomChipRegisters_AI_TBC										;61000074
	clr.b	InputStateFlag_AI_TBC.l												;42390000EE2D
	clr.w	FrameSyncFlagWord_AI_TBC.l											;427900008C1E
	bsr		Init_DisplayDMA_AI_TBC												;61000496
	bsr		MainMenu															;61000314
	jsr		adrCd008DA8.l														;4EB900008DA8
	jsr		adrCd008DA0.l														;4EB900008DA0
	moveq	#Sound_SwitchClick,d0												;Selects the initial switch or interface click sound.
	jsr		PlaySound.l															;4EB9000088BE
	tst.w	MainMenuBuffer.l													;4A7900000656
	bmi.s	MainMenu_ReturnToStart_AI_TBC										;6B3E
	beq.s	PostMainMenu_ChampionSetup_AI_TBC									;6704
	bra		InitialiseActivePlayerData											;60000752

PostMainMenu_ChampionSetup_AI_TBC:		; Memory Address ($0456) and binary offset [$00D2]
	jsr		ChampionSelection_Main.l											;4EB90000C0FA
	move.b	adrB_00EE83.l,Player1_ChampionCount.l								;13F90000EE830000EE94
	move.b	Player2_ChampionCount.l,Player2_ChampionPointer.l					;13F90000EEE50000EEF6
	move.l	Player1_ChampionCount.l,Player1_ChampionPointer.l					;23F90000EE940000EEA2
	move.l	Player2_ChampionPointer.l,adrL_00EF04.l								;23F90000EEF60000EF04
	moveq	#$0F,d0																;700F
DBFWait1a:		; Memory Address ($0486) and binary offset [$0102]
	dbra	d1,DBFWait1a														;51C9FFFE
	dbra	d0,DBFWait1a														;51C8FFFA
MainMenu_ReturnToStart_AI_TBC:		; Memory Address ($048E) and binary offset [$010A]
	bra		InitialiseNewGameSession											;60000712

Init_CustomChipRegisters_AI_TBC:		; Memory Address ($0492) and binary offset [$010E]
	jsr		adrCd008DBA.l														;4EB900008DBA
	move.w	#$4200,_custom+bplcon0.l											;33FC420000DFF100
	move.w	#$0000,_custom+bplcon1.l											;33FC000000DFF102
	move.w	#$0024,_custom+bplcon2.l											;33FC002400DFF104
	move.w	#$0000,_custom+bpl1mod.l											;33FC000000DFF108
	move.w	#$0000,_custom+bpl2mod.l											;33FC000000DFF10A
	move.w	#$0038,_custom+ddfstrt.l											;33FC003800DFF092
	move.w	#$00D0,_custom+ddfstop.l											;33FC00D000DFF094
	move.w	#$3781,_custom+diwstrt.l											;33FC378100DFF08E
	move.w	#$FFC1,_custom+diwstop.l											;33FCFFC100DFF090
	move.l	#CopperList_00,_custom+cop1lc.l										;23FC00008E1000DFF080
	move.l	#$00060000,screen_ptr.l												;23FC0006000000008D36
	jsr		adrCd008D00.l														;4EB900008D00
	lea		CopperList_01.l,a0													;41F900008E30
	lea		Copper_SpriteOffsetTable_DATA_AI_TBC.l,a1							;43F9000005AA
	lea		Sprite_PositionPointerTable_DATA_AI_TBC.l,a2						;45F9000005B2
	moveq	#$07,d1																;7207
Copper_SpriteInitLoop_AI_TBC:		; Memory Address ($050E) and binary offset [$018A]
	moveq	#$00,d0																;7000
	move.b	$00(a1,d1.w),d0														;10311000
	add.w	d0,d0																;D040
	add.w	d0,d0																;D040
	move.l	$00(a2,d0.w),d0														;20320000
	move.w	d0,$0006(a0)														;31400006
	swap	d0																	;4840
	move.w	d0,$0002(a0)														;31400002
	addq.w	#$08,a0																;5048
	dbra	d1,Copper_SpriteInitLoop_AI_TBC										;51C9FFE4
	move.l	#adrL_008CC8,d0														;203C00008CC8
	lea		$0060.w,a0															;41F80060	;Short Absolute replaced by symbol!
	moveq	#$07,d1																;7207
Interrupt_VectorInitLoop_AI_TBC:		; Memory Address ($0538) and binary offset [$01B4]
	move.l	d0,(a0)+															;20C0
	dbra	d1,Interrupt_VectorInitLoop_AI_TBC									;51C9FFFC
	move.l	#VerticalBlankInterupt,$006C.w										;21FC00008C20006C	;Short Absolute converted to symbol!
	move.l	#Level_2_Interrupt,$0068.w											;21FC000005CE0068	;Short Absolute converted to symbol!
	move.l	#adrL_0088A4,$0070.w												;21FC000088A40070	;Short Absolute converted to symbol!
	move.w	#$7FFF,_custom+intena.l												;33FC7FFF00DFF09A
	move.b	_ciaa+ciacra.l,d0													;103900BFEE01
	move.b	#$21,_ciaa+ciacra.l													;13FC002100BFEE01
	move.b	#$7F,_ciaa+ciaicr.l													;13FC007F00BFED01
	move.b	_ciaa+ciaicr.l,d0													;103900BFED01
	move.b	#$88,_ciaa+ciaicr.l													;13FC008800BFED01
	move.w	_custom+copjmp1.l,d0												;303900DFF088
	move.w	#$7FFF,_custom+dmacon.l												;33FC7FFF00DFF096
	move.w	#$83A0,_custom+dmacon.l												;33FC83A000DFF096
	move.w	#$7FFF,_custom+intreq.l												;33FC7FFF00DFF09C
	move.w	#$C038,_custom+intena.l												;33FCC03800DFF09A
	rts																			;4E75

Copper_SpriteOffsetTable_DATA_AI_TBC:		; Memory Address ($05AA) and binary offset [$0226]
	dc.w	$0404	;0404
	dc.w	$0403	;0403
	dc.w	$0402	;0402
	dc.w	$0100	;0100
Sprite_PositionPointerTable_DATA_AI_TBC:		; Memory Address ($05B2) and binary offset [$022E]
	dc.l	SpritePosition_00	;00008E84
	dc.l	SpritePosition_01	;00008F14
	dc.l	SpritePosition_04	;00008ECC
	dc.l	SpritePosition_02	;00008F5C
	dc.l	adrEA008EC8	;00008EC8
	dc.w	$0000	;0000
Level2Int_LastKeyScratch_AI_TBC:		; Memory Address ($05C8) and binary offset [$0244]
	ds.b	$1
KeyboardKeyCode:		; Memory Address ($05C9) and binary offset [$0245]
	ds.b	$5
Level_2_Interrupt:		; Memory Address ($05CE) and binary offset [$024A]
	movem.l	d0/d1/a0,-(sp)														;48E7C080
	lea		_ciaa.l,a0															;41F900BFE001
	move.b	$0C00(a0),d0														;10280C00
	ror.b	#$01,d0																;E218
	not.b	d0																	;4600
	move.b	d0,KeyboardKeyCode.w												;11C005C9	;Short Absolute converted to symbol!
	or.b	#$40,$0E00(a0)														;002800400E00
	clr.b	$0C00(a0)															;42280C00
	move.b	$0100(a0),d1														;12280100
	bsr.s	CheckKeyboard														;6128
	moveq	#$2D,d0																;702D
.L2InteruptLoop:		; Memory Address ($05F6) and binary offset [$0272]
	dbra	d0,.L2InteruptLoop													;51C8FFFE
	lea		_ciaa.l,a0															;41F900BFE001
	move.b	$0D00(a0),d0														;10280D00
	and.b	#$BF,$0E00(a0)														;022800BF0E00
	move.b	d0,Level2Int_LastKeyScratch_AI_TBC.w								;11C005C8	;Short Absolute converted to symbol!
	movem.l	(sp)+,d0/d1/a0														;4CDF0103
	move.w	#$0008,_custom+intreq.l												;33FC000800DFF09C
	rte																			;4E73

CheckKeyboard:		; Memory Address ($061C) and binary offset [$0298]
	lea		RawKeyCodes.l,a0													;41F90000064A
	moveq	#$0B,d1																;720B
.keyboardloop:		; Memory Address ($0624) and binary offset [$02A0]
	cmp.b	(a0)+,d0															;B018
	beq.s	KeyboardAction														;6706
	dbra	d1,.keyboardloop													;51C9FFFA
	rts																			;4E75

KeyboardAction:		; Memory Address ($062E) and binary offset [$02AA]
	lea		Player1_Data.l,a0													;41F90000EE7C
	subq.w	#$06,d1																;5D41
	bcc.s	.skipPlayer2														;6408
	addq.w	#$06,d1																;5C41
	lea		Player2_Data.l,a0													;41F90000EEDE
.skipPlayer2:
	add.w	#InterfaceAction_MoveForward,d1										;Base dungeon action added to the raw-key index so keyboard movement begins with Move Forward.
	move.b	d1,Player_PendingActionOffset(a0)									;Offset of the pending action byte written by keyboard input.
	rts																			;4E75

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
	; dc.b    'TEST'

	dc.b	$FE	;FE
	dc.b	$06	;06
	dc.b	$FF	;FF

	EVEN	
MainMenu:		; Memory Address ($0746) and binary offset [$03C2]
	clr.w	MainMenuBuffer.w													;42780656	;Short Absolute converted to symbol!
	clr.w	MultiPlayer.l														;42790000EE30
	jsr		adrCd008DA8.l														;4EB900008DA8
	jsr		adrCd008DA0.l														;4EB900008DA0
	lea		MainMenuText.w,a6													;4DF8065D	;Short Absolute converted to symbol!
	tst.w	MainMenuInitColours.w												;4A780658	;Short Absolute converted to symbol!
	bne.s	.menuscreen															;6602
	subq.w	#$03,a6																;574E
.menuscreen:		; Memory Address ($0768) and binary offset [$03E4]
	lea		Player1_Data.l,a5													;4BF90000EE7C
	jsr		Print_fflim_text.l													;4EB90000D0C6
	jsr		adrCd008CCA.l														;4EB900008CCA
	tst.w	MainMenuInitColours.w												;4A780658	;Short Absolute converted to symbol!
	bne.s	MenuKeyboard														;660C
	move.w	#$FFFF,MainMenuInitColours.w										;31FCFFFF0658	;Short Absolute converted to symbol!
	jsr		adrCd008878.l														;4EB900008878
MenuKeyboard:
	clr.b	KeyboardKeyCode.w													;423805C9	;Short Absolute converted to symbol!
.menukeyboardloop:
	move.b	KeyboardKeyCode.w,d0												;103805C9	;Short Absolute converted to symbol!
	sub.b	#$50,d0																;04000050
	beq		Ply1_Start															;67000088
	subq.b	#$01,d0																;5300
	beq		Ply2_Start															;6700008C
	subq.b	#$01,d0																;5300
	beq		QkPly1_Start														;6700008E
	subq.b	#$01,d0																;5300
	beq		QkPly2_Start														;670000CE
	cmpi.b	#$06,d0																;0C000006
	beq.s	LoadGameFromMenu													;670C
	subq.b	#$05,d0																;5B00
	bne.s	.menukeyboardloop													;66D8
	move.w	#$FFFF,MultiPlayer.l												;33FCFFFF0000EE30
LoadGameFromMenu:
	move.l	#$00067D00,screen_ptr.l												;23FC00067D0000008D36
	move.l	#$00060000,framebuffer_ptr.l										;23FC0006000000008D3A
	jsr		adrCd008DA8.l														;4EB900008DA8
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$0E10,a0															;D0FC0E10
	lea		Msg_InstertLoadDisk.l,a6											;4DF9000044E5
	jsr		Print_fflim_text.l													;4EB90000D0C6
	jsr		adrCd008CCA.l														;4EB900008CCA
	clr.b	KeyboardKeyCode.w													;423805C9	;Short Absolute converted to symbol!
	bsr		LoadSaveGame_Loop													;61003C0A
	bcs		MainMenu															;6500FF46
	bsr		LoadSaveGame_Action													;61003C1E
	bsr		adrCd004440															;61003C38
	cmp.b	#$FF,Character_Stats_DataTable+$11.l								;0C3900FF0000EB3B
	beq		MainMenu															;6700FF32
	bsr		Select_CurrentTowerMapData											;61000350
	move.w	#$0001,MainMenuBuffer.w												;31FC00010656	;Short Absolute converted to symbol!
	rts																			;4E75

Ply1_Start:
	move.w	#$FFFF,MultiPlayer.l												;33FCFFFF0000EE30
	rts																			;4E75

Ply2_Start:
	clr.w	MultiPlayer.l														;42790000EE30
	rts																			;4E75

QkPly1_Start:
	move.w	#$FFFF,MultiPlayer.l												;33FCFFFF0000EE30
	move.w	#$FFFF,MainMenuBuffer.w												;31FCFFFF0656	;Short Absolute converted to symbol!
	move.l	#$000E0503,$0018(a5)												;2B7C000E05030018
	move.l	$0018(a5),$0026(a5)													;2B6D00180026
	clr.w	$0006(a5)															;426D0006
	lea		Character_Stats_DataTable.l,a0										;41F90000EB2A
	move.b	#$0C,$0016(a0)														;117C000C0016
	move.b	#$17,$0017(a0)														;117C00170017
	clr.b	$0018(a0)															;42280018
	moveq	#-$01,d0															;70FF
	move.b	d0,$01D6(a0)														;114001D6
	move.b	d0,$00B6(a0)														;114000B6
	move.b	d0,$0076(a0)														;11400076
	rts																			;4E75

QkPly2_Start:
	bsr.s	QkPly1_Start														;61B8
	clr.w	MultiPlayer.l														;42790000EE30
	move.l	#$04060D0F,Player2_ChampionPointer.l								;23FC04060D0F0000EEF6
	move.l	#$04060D0F,adrL_00EF04.l											;23FC04060D0F0000EF04
	move.w	#$0004,adrW_00EEE4.l												;33FC00040000EEE4
	lea		Character_Stats_DataTable+$80.l,a0									;41F90000EBAA
	move.b	#$0E,$0016(a0)														;117C000E0016
	move.b	#$17,$0017(a0)														;117C00170017
	clr.b	$0018(a0)															;42280018
	moveq	#-$01,d0															;70FF
	move.b	d0,$0056(a0)														;11400056
	move.b	d0,$0136(a0)														;11400136
	move.b	d0,$0176(a0)														;11400176
	rts																			;4E75

Init_DisplayDMA_AI_TBC:		; Memory Address ($08C4) and binary offset [$0540]
	lea		BitReverse_LookupBuffer.l,a0										;41F90001684C
	move.w	#$00FF,d7															;3E3C00FF
SpellsPracticed_InitializeEntriesLoop_AI_TBC:		; Memory Address ($08CE) and binary offset [$054A]
	move.w	d7,d0																;3007
	moveq	#$07,d6																;7C07
SpellsPracticed_AccumulateEntryBitsLoop_AI_TBC:		; Memory Address ($08D2) and binary offset [$054E]
	lsr.b	#$01,d0																;E208
	addx.b	d1,d1																;D301
	dbra	d6,SpellsPracticed_AccumulateEntryBitsLoop_AI_TBC					;51CEFFFA
	move.b	d1,$00(a0,d7.w)														;11817000
	dbra	d7,SpellsPracticed_InitializeEntriesLoop_AI_TBC						;51CFFFEE
	lea		Spells_Practiced_DataTable.l,a0										;41F90001694C
	moveq	#$7F,d0																;707F
SpellsPracticed_ClearEntriesLoop_AI_TBC:		; Memory Address ($08EA) and binary offset [$0566]
	clr.l	(a0)+																;4298
	dbra	d0,SpellsPracticed_ClearEntriesLoop_AI_TBC							;51C8FFFC
	rts																			;4E75

Initialize_SpellPracticeThresholds:		; Memory Address ($08F2) and binary offset [$056E]
	; Initialises calculated spell-practice values for all sixteen champion
	; records.
	moveq	#$0F,d7																;7E0F
SpellPractice_ThresholdLoop:		; Memory Address ($08F4) and binary offset [$0570]
	move.w	d7,d0																;3007
	bsr		Calculate_SpellPracticeThreshold									;6100000C
	move.b	d0,$0009(a4)														;19400009
	dbra	d7,SpellPractice_ThresholdLoop										;51CFFFF4
	rts																			;4E75

Calculate_SpellPracticeThreshold:		; Memory Address ($0904) and binary offset [$0580]
	; Calculates a champion's spell-practice threshold from Wizard-weighted level
	; and half Intelligence, clamped to $63.
	move.w	d0,d1																;3200
	bsr		Load_ChampionStatRecord												;61005D58
	bsr.s	Calculate_WizardLevelContribution									;6132
	asl.w	#$02,d0																;E540
	move.b	$0003(a4),d1														;122C0003
	lsr.b	#$01,d1																;E209
	add.b	d1,d0																;D001
	cmpi.b	#$64,d0																;0C000064
	bcs.s	SpellPractice_StoreThreshold										;6502
	moveq	#$63,d0																;7063
SpellPractice_StoreThreshold:		; Memory Address ($091E) and binary offset [$059A]
	; Stores the calculated spell-practice threshold in the champion record.
	move.b	d0,$000A(a4)														;1940000A
	rts																			;4E75

Calculate_WarriorLevelContribution:		; Memory Address ($0924) and binary offset [$05A0]
	; Calculates the Warrior-weighted contribution of a champion's level.
	and.w	#$0003,d1															;02410003
	move.b	WarriorLevel_ChampionTypeShifts(pc,d1.w),d1							;123B1010
	bpl.s	Calculate_ShiftedChampionLevel										;6A26
	moveq	#$00,d0																;7000
	move.b	(a4),d0																;1014
	add.w	d0,d0																;D040
	add.b	(a4),d0																;D014
	lsr.w	#$02,d0																;E448
	rts																			;4E75

WarriorLevel_ChampionTypeShifts:		; Memory Address ($093A) and binary offset [$05B6]
	; Selects full, quarter or special three-quarter level weighting for each
	; champion type.
	dc.b	$00	;00
	dc.b	$02	;02
	dc.b	$FF	;FF
	dc.b	$02	;02

Calculate_WizardLevelContribution:		; Memory Address ($093E) and binary offset [$05BA]
	; Calculates the Wizard-weighted contribution of a champion's level.
	and.w	#$0003,d1															;02410003
	move.b	WizardLevel_ChampionTypeShifts(pc,d1.w),d1							;123B1004
	bra.s	Calculate_ShiftedChampionLevel										;600C

WizardLevel_ChampionTypeShifts:		; Memory Address ($0948) and binary offset [$05C4]
	; Selects quarter, full or half Wizard-level weighting for each champion type.
	dc.b	$02	;02
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02

Calculate_CutpurseLevelContribution:		; Memory Address ($094C) and binary offset [$05C8]
	; Calculates the Cutpurse-weighted contribution of a champion's level.
	and.w	#$0003,d1															;02410003
	move.b	CutpurseLevel_ChampionTypeShifts(pc,d1.w),d1						;123B100A
Calculate_ShiftedChampionLevel:		; Memory Address ($0954) and binary offset [$05D0]
	; Loads the champion's level and applies the selected right-shift weighting.
	moveq	#$00,d0																;7000
	move.b	(a4),d0																;1014
	lsr.w	d1,d0																;E268
	rts																			;4E75

CutpurseLevel_ChampionTypeShifts:		; Memory Address ($095C) and binary offset [$05D8]
	; Selects quarter, half or full Cutpurse-level weighting for each champion
	; type.
	dc.b	$02	;02
	dc.b	$02	;02
	dc.b	$01	;01
	dc.b	$00	;00

Map_Traps_InitProcessing_AI_TBC:		; Memory Address ($0960) and binary offset [$05DC]
	moveq	#$00,d7																;7E00
	moveq	#$00,d6																;7C00
	move.l	Current_TowerMapDataBase.l,a6										;2C790000EE78
	lea		$0FCA(a6),a0														;41EE0FCA
Map_Traps_ProcessNextEntryLoop_AI_TBC:		; Memory Address ($096E) and binary offset [$05EA]
	cmp.w	-$0002(a0),d7														;BE68FFFE
	bcc.s	Map_Traps_ProcessingDone_AI_TBC										;6420
	move.b	$00(a0,d7.w),d0														;10307000
	rol.w	#$08,d0																;E158
	move.b	$01(a0,d7.w),d0														;10307001
	and.w	#$3FFF,d0															;02403FFF
	bset	#$06,$01(a6,d0.w)													;08F600060001
	move.b	$02(a0,d7.w),d6														;1C307002
	add.w	d6,d6																;DC46
	addq.w	#$05,d6																;5A46
	add.w	d6,d7																;DE46
	bra.s	Map_Traps_ProcessNextEntryLoop_AI_TBC								;60DA

Map_Traps_ProcessingDone_AI_TBC:		; Memory Address ($0994) and binary offset [$0610]
	rts																			;4E75

PrepareCharacters:
	; Initialises all sixteen champion-stat records for the current tower,
	; recalculates derived values, and marks placed champions on the working map.
	bsr		Select_CurrentTowerMapData											;Selects the current tower's map-pointer block before champion coordinates are converted to map cells.
	lea		Character_Stats_DataTable.l,a4										;Loads a4 with the base of the champion-stat table; all ChampionStat fields below are relative to this record.
	moveq	#Champion_Count-1,d6												;Initialises the reverse champion loop for all sixteen champion records; d6 counts down from the last slot.
PrepareCharacters_ChampionLoop:
	; Processes the sixteen champion records in table order.
	clr.b	ChampionStat_WornSpell(a4)											;Clears the champion's currently worn spell so no spell remains equipped at tower start.
	move.b	#$FF,ChampionStat_SpellToCast(a4)									;Sets the spell-to-cast field to $FF, meaning that no spell-casting request is pending.
	clr.b	ChampionStat_FairySpellCount(a4)									;Clears the fairy-spell purchase count so tower-start setup begins with no queued purchases.
	clr.b	ChampionStat_AttackCooldown(a4)										;Clears the champion's physical-attack cooldown before play begins.
	move.b	#$FF,ChampionStat_XPToNextLevel(a4)									;Sets the experience threshold field to $FF, the start-of-game sentinel for experience-to-next-level handling.
	move.w	d6,d0																;Copies the reverse loop counter into d0 so the champion's logical table index can be calculated.
	eor.b	#Champion_Count-1,d0												;Reverses the countdown index, turning the backward loop position into the champion number expected by stat calculation.
	bsr		Recalculate_CharacterDerivedStats									;Recalculates derived champion statistics using the selected champion record and its logical index.
	move.b	ChampionStat_SpellPointsMaximum(a4),ChampionStat_SpellPointsCurrent(a4)	;Copies maximum spell points into current spell points, filling the starting spell-point reserve.
	moveq	#$00,d0																;Clears d0 before loading the champion's floor number for map-context selection.
	move.b	ChampionStat_Floor(a4),d0											;Loads the champion's tower-floor field into d0 for the floor/map lookup.
	jsr		adrCd0084DA.l														;Resolves the floor-specific map context used by subsequent coordinate-to-cell conversion.
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
	bsr		Map_Traps_InitProcessing_AI_TBC										;Initialises the trap-processing state before monster placement changes the current tower map.
	lea		MonsterTeamIndexTable.l,a4											;Loads a4 with the monster team-index table, whose entries point from team slots to live monster records.
	moveq	#-$01,d6															;Creates the $FF empty/sentinel value used to clear team data and mark missing entries.
	move.w	d6,MonsterTeamIndexTable_CountOffset(a4)							;Initialises the team-table count word to $FFFF before any valid monster teams are found.
	moveq	#MonsterTeamIndexTable_LongwordCount-1,d0							;Sets the team-table clearing loop to cover all twenty-five four-member team records.
.ClearMonsterTeamIndexLoop:		; Memory Address ($0A08) and binary offset [$0684]
	; Clears the twenty-five four-member team slots.
	move.l	d6,(a4)+															;Writes the empty sentinel into the current team-table longword and advances to the next slot.
	dbra	d0,.ClearMonsterTeamIndexLoop										;Clears every team-table longword before rebuilding team membership from packed monster data.
	lea		UnpackedMonsters.l,a4												;Loads a4 with the base of the live, unpacked monster-record workspace.
	move.w	#MonsterLive_WorkspaceLongwordCount-1,d0							;Sets the clearing loop to cover 512 longwords, the full $800-byte live-monster workspace.
.ClearLiveMonsterRecordsLoop:
	; Clears the live-monster workspace before unpacking.
	move.l	d6,(a4)+															;Fills the current live-monster longword with the empty sentinel and advances through the workspace.
	dbra	d0,.ClearLiveMonsterRecordsLoop										;Clears all live monster records before unpacking the selected tower's packed records.
	move.w	CurrentTower.l,d0													;Reads the selected tower number into d0 to choose its monster count and packed block.
	move.w	d0,d1																;Copies the tower number to d1 because d0 will be reused to form a table offset.
	add.w	d0,d0																;Doubles the tower number to address the word-sized monster-count entry for that tower.
	lea		MonsterTotalsCounts_mod0.l,a4										;Loads the table of per-tower monster totals.
	move.w	$00(a4,d0.w),d6														;Reads this tower's packed-monster count into d6 for the unpacking loop.
	lea		UnpackedMonsters.l,a4												;Restores a4 to the live-monster base so the count and records use the same workspace.
	move.w	d6,MonsterLive_RecordCountOffset(a4)								;Stores the selected tower's live-record count in the workspace count word at offset -2.
	bmi		Trigger_00_t00_Null													;Exits through the null-trigger path when this tower contains no monsters.
	add.w	d1,d0																;Forms a three-times-tower index from the preserved tower number for the six-byte monster block table.
	asl.w	#PackedMonster_TowerBlockShift,d0									;Multiplies the tower block index by $100, the packed monster block spacing.
	lea		MonsterBlock_mod0.l,a3												;Loads a3 with the base of the packed monster-block table.
	add.w	d0,a3																;Moves a3 to the selected tower's packed six-byte monster records.
	moveq	#$00,d4																;Initialises d4 as the zero-based packed/live monster ordinal used in team-table entries.
UnpackNextMonsterRecord:
	; Expands one packed six-byte monster record into a sixteen-byte live record.
	clr.b	MonsterRecord_ActionState(a4)										;Clears the live action/status byte before copying data into this monster record.
	clr.b	MonsterRecord_RotationAndSpace(a4)									;Clears the live rotation/occupied-space byte because it is rebuilt later by movement logic.
	move.b	(a3)+,d0															;Reads the packed type-and-floor byte and advances a3 to the packed X coordinate.
	subq.b	#PackedMonster_FloorEncodingBias,d0									;Removes the packed floor encoding bias before splitting type and floor.
	move.b	d0,d1																;Copies the adjusted packed byte into d1 so its high nibble can be extracted without losing the floor nibble.
	lsr.b	#PackedMonster_TypeShift,d1											;Shifts the packed high nibble down to produce the monster type code.
	move.b	d1,MonsterRecord_Type(a4)											;Stores the decoded monster type in the live record's type field.
	and.w	#PackedMonster_NibbleMask,d0										;Masks off the high nibble, retaining the packed floor number in d0.
	move.b	d0,MonsterRecord_Floor(a4)											;Stores the decoded floor number in the live monster record.
	bsr		adrCd0084DA															;Selects the floor-specific map context used for this monster's coordinate conversion.
	moveq	#$00,d7																;Clears d7 before assembling the packed live X/Y coordinate.
	move.b	(a3)+,d7															;Reads the packed X byte into the high-byte staging register d7 and advances to packed Y.
	move.b	d7,MonsterRecord_XPosition(a4)										;Stores the decoded X coordinate in the live monster record.
	swap	d7																	;Swaps d7 so the staged X coordinate occupies the high word while Y is appended below it.
	move.b	(a3)+,d7															;Reads the packed X byte into the high-byte staging register d7 and advances to packed Y.
	move.b	d7,MonsterRecord_YPosition(a4)										;Stores the decoded Y coordinate in the live monster record.
	btst	#$17,d7																;Tests the packed-coordinate validity bit to detect the $FF/no-position monster sentinel.
	bne.s	.MonsterPositionHandled												;Skips map occupancy marking when this monster has no valid starting position.
	bsr		CoordToMap															;Converts the decoded monster X/Y coordinate into a map-cell index.
	bset	#$07,$01(a6,d0.w)													;Sets the occupied-by-monster bit in the corresponding current-map cell.
.MonsterPositionHandled:		; Memory Address ($0A8E) and binary offset [$070A]
	; Continues after packed-coordinate map handling.
	moveq	#$00,d0																;Clears d0 before reading the packed monster level.
	move.b	(a3)+,d0															;Reads the packed level byte and advances a3 to the packed monster form.
	move.b	d0,MonsterRecord_CurrentLevel(a4)									;Stores the level used by the monster's current behaviour and hit-point calculations.
	move.b	d0,MonsterRecord_BaseLevel(a4)										;Stores the original unpacked level as the monster's base level for later progression.
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
	move.b	d1,MonsterRecord_ActionCountdown(a4)								;Stores the level-derived action countdown in the live monster record.
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
	move.w	d0,MonsterRecord_HitPoints(a4)										;Stores the calculated starting hit points in the live monster record.
	move.b	(a3)+,MonsterRecord_Form(a4)										;Reads the packed monster form/graphic identifier into the live record.
	bpl.s	CheckMonsterFormForCarriedObject									;Branches to the Zendik special-case check only for non-negative, ordinary monster forms.
	move.b	#$10,MonsterRecord_ActionCountdown(a4)								;Gives a negative/special form the fixed action countdown used by that special behaviour.
	bra.s	StoreTeamData														;Skips the Zendik object check and continues with packed team-data processing.

CheckMonsterFormForCarriedObject:
	; Handles the monster-form special case that assigns a fixed carried object.
	cmp.b	#MonsterForm_Zendik,MonsterRecord_Form(a4)							;0C2C0040000B	;
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
	tst.b	MonsterRecord_XPosition(a4)											;Tests the live X coordinate so an unpositioned monster is not counted as an active team member.
	bmi.s	.AdvanceToNextMonster												;Skips team counting and group assignment when the monster has no valid position.
	addq.w	#$01,MonsterTeamIndexTable_CountOffset(a0)							;Increments the active team-member count stored before the team-index table.
	lsr.b	#MonsterTeamData_GroupShift,d0										;Shifts away the member-slot bits, leaving the packed team group number.
	move.b	d0,MonsterRecord_TeamGroupIndex(a4)									;Stores the decoded team group index in the live monster record.
.AdvanceToNextMonster:		; Memory Address ($0B16) and binary offset [$0792]
	; Advances to the next packed and live monster record.
	add.w	#MonsterRecord_Size,a4												;Advances a4 by the $10-byte live monster record size.
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
	; Copies a champion’s saved start position into the active player record.
	bsr		Load_CurrentChampionStatRecord										;Loads the current champion's stat record into a4; a5 points to the active player record receiving the data.
	moveq	#$00,d0																;Clears d0 before reading the saved champion X coordinate.
	move.b	ChampionStat_XPosition(a4),d0										;Loads the saved champion X coordinate for transfer into the active player position.
	bmi.s	.NoChampionStartPosition											;Returns without copying a position when X is negative, the no-start-position sentinel.
	move.b	#$FF,ChampionStat_XPosition(a4)										;Marks the champion's saved X coordinate consumed so it cannot be reused on the next transfer.
	move.w	d0,PlayerData_StartXPosition(a5)									;Copies the X coordinate into the active player record's start-position word at offset $1C.
	move.b	ChampionStat_YPosition(a4),d0										;Loads the saved champion Y coordinate into d0.
	move.b	#$FF,ChampionStat_YPosition(a4)										;Marks the champion's saved Y coordinate consumed after it has been selected.
	move.w	d0,PlayerData_StartYPosition(a5)									;Copies the Y coordinate into the active player record's start-position word at offset $1E.
	move.b	ChampionStat_Direction(a4),d0										;Loads the champion's saved facing/direction byte.
	move.w	d0,PlayerData_Direction(a5)											;Copies the direction into the active player record's orientation field at offset $20.
	move.b	ChampionStat_Floor(a4),d0											;Loads the champion's saved floor byte.
	move.w	d0,PlayerData_Floor(a5)												;Copies the floor into the active player record's map-index field at offset $58.
.NoChampionStartPosition:		; Memory Address ($0B66) and binary offset [$07E2]
	; Returns when the champion has no saved position.
	rts																			;Returns to the player-initialisation loop after a valid or absent champion position has been handled.

Select_CurrentTowerMapData:		; Memory Address ($0B68) and binary offset [$07E4]
	; Copies the selected tower’s map-pointer block into working memory.
	move.w	CurrentTower.l,d0													;Reads the selected tower number for map-pointer selection.
	add.w	d0,d0																;Converts the tower number into a word offset for the tower-offset table.
	lea		Current_TowerMapOffsets.l,a0										;Loads the table of offsets from MapData1 to each tower's map-pointer block.
	lea		MapData1.l,a6														;Loads a6 with the first tower map-data block, the base used by the relative offset.
	add.w	$00(a0,d0.w),a6														;Adds the selected tower offset to a6, selecting that tower's fourteen map pointers.
	lea		Current_TowerMapHeaderCache.l,a0									;Loads the working cache that stores the selected tower's map pointers.
	moveq	#$0D,d0																;Sets the copy loop for fourteen longword map-pointer entries.
.CopyCurrentTowerMapPointerLoop:		; Memory Address ($0B88) and binary offset [$0804]
	; Copies the fourteen map pointers for the selected tower.
	move.l	(a6)+,(a0)+															;Copies one map pointer from the selected tower block into the working cache and advances both pointers.
	dbra	d0,.CopyCurrentTowerMapPointerLoop									;Repeats the pointer copy until all fourteen entries are cached.
	move.l	a6,Current_TowerMapDataBase.l										;Stores the address immediately after the pointer block as the selected tower's map-data base.
	rts																			;Returns with the current tower map pointers and base address ready for use.

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
	clr.w	FrameSyncFlagWord_AI_TBC.l											;Clears the frame-synchronisation flag before constructing the player state.
	move.b	#$FF,adrB_00EE2C.l													;Sets the shared player/session state byte to its inactive sentinel value.
	lea		Player1_Data.l,a5													;Loads a5 with the first player's data record.
	move.l	#$00F00020,$0002(a5)												;Initialises the first player's packed state/position word with its single-player defaults.
	move.w	#$5601,$003A(a5)													;Initialises the first player's control and interface state word.
	tst.w	MultiPlayer.l														;Checks whether the session is running in multiplayer mode.
	beq.s	InitialisePlayer2Data												;Takes the single-player path into the shared second-player/default setup block.
	move.w	#$8223,$003A(a5)													;Replaces the first player's control state with the multiplayer configuration.
	move.l	#$FFFFFFFF,Player2_ChampionPointer.l								;Invalidates the second player's champion pointer until multiplayer selection supplies it.
	move.w	#$0027,$0008(a5)													;Initialises the first player's multiplayer start-position word.
	move.w	#$0618,$000A(a5)													;Initialises the first player's multiplayer map/viewport word.
	clr.l	adrL_00EEE0.l														;Clears the shared second-player/session scratch longword.
	moveq	#$00,d7																;Sets d7 to zero so the shared player loop handles only the active first player on this path.
	bra.s	InitialisePlayerDataLoop											;Jumps into the common player-record initialisation loop.

InitialisePlayer2Data:		; Memory Address ($0BF6) and binary offset [$0872]
	; Initialises the second player structure for a two-player session.
	lea		Player2_Data.l,a5													;Loads a5 with the second player's data record.
	move.l	#$00F00088,$0002(a5)												;Initialises the second player's packed state/position word for the two-player path.
	move.w	#$BE68,$003A(a5)													;Initialises the second player's control and interface state word.
	move.w	#$0068,$0008(a5)													;Initialises the second player's start-position word.
	move.w	#$1040,$000A(a5)													;Initialises the second player's map/viewport word.
	moveq	#$01,d7																;Sets d7 to one so the common loop processes both player records.
InitialisePlayerDataLoop:		; Memory Address ($0C18) and binary offset [$0894]
	; Initialises each active player structure and transfers its saved champion
	; start position.
	clr.w	$0014(a5)															;Clears the active player's transient action/state word before input processing begins.
	move.w	#$FFFF,$0042(a5)													;Initialises the party-command/interface state word to $FFFF, meaning no numbered command state is active.
	move.w	#$FFFF,$0040(a5)													;Sets the command-type/state word to $FFFF, meaning no command is pending.
	bsr		TransferChampionStartPosition										;Transfers the active player's saved champion start position into the player record.
	bset	#$04,$0018(a5)														;Sets the active-player flag bit used to mark the player record as initialised/available.
	lea		Player1_Data.l,a5													;Resets a5 to Player1_Data so the next loop iteration starts from the first player record.
	dbra	d7,InitialisePlayerDataLoop											;Repeats player initialisation for the remaining player selected by d7.
	bsr		adrCd0042BA															;Runs the shared post-player setup routine after all player records are initialised.
	move.w	#$FFFF,FrameSyncFlagWord_AI_TBC.l									;Sets the frame-synchronisation flag to release the subsequent frame-wait logic.
Wait_FrameSync_AI_TBC:		; Memory Address ($0C48) and binary offset [$08C4]
	tst.b	FrameSyncFlagWord_AI_TBC.l											;4A3900008C1E
	bne.s	Wait_FrameSync_AI_TBC												;66F8
Menu_RenderLoop_AI_TBC:		; Memory Address ($0C50) and binary offset [$08CC]
	lea		Player1_Data.l,a5													;4BF90000EE7C
	bsr		adrCd0084D6															;6100787E
	bsr		Scan_PlayerInterfaceActions											;61004034
	bsr		Dispatch_PlayerInterfaceActionGuarded								;61004B4C
	tst.w	MultiPlayer.l														;4A790000EE30
	bne.s	Menu_IdlePoll_AI_TBC												;661E
	lea		Player2_Data.l,a5													;4BF90000EEDE
	bsr		adrCd0084D6															;61007864
	bsr		Scan_PlayerInterfaceActions											;6100401A
	bsr		Dispatch_PlayerInterfaceActionGuarded								;61004B32
	jsr		adrCd008FB8.l														;4EB900008FB8
	lea		Player1_Data.l,a5													;4BF90000EE7C
Menu_IdlePoll_AI_TBC:		; Memory Address ($0C88) and binary offset [$0904]
	jsr		adrCd008FB8.l														;4EB900008FB8
	move.b	#$FF,FrameSyncFlagWord_AI_TBC.l										;13FC00FF00008C1E
adrCd000C96:		; Memory Address ($0C96) and binary offset [$0912]
	tst.b	FrameSyncFlagWord_AI_TBC.l											;4A3900008C1E
	bne.s	adrCd000C96															;66F8
	bsr.s	RelocateTraps_AI_TBC												;6164
	move.b	Player1_ChampionCount.l,d0											;10390000EE94
	and.b	Player2_ChampionPointer.l,d0										;C0390000EEF6
	btst	#$06,d0																;08000006
	beq.s	adrCd000CB4															;6702
	bsr.s	DelayLoop1a_AI_TBC													;610E
adrCd000CB4:		; Memory Address ($0CB4) and binary offset [$0930]
	move.w	#$0001,SpellEntity_PlacementConflictFlag.l							;33FC00010000505A
	bsr		adrCd001238															;6100057A
	bra.s	Menu_RenderLoop_AI_TBC												;608E

DelayLoop1a_AI_TBC:		; Memory Address ($0CC2) and binary offset [$093E]
	move.l	adrEA00EE36.l,-(sp)													;2F390000EE36
	moveq	#$14,d0																;7014
DBFWait1b:		; Memory Address ($0CCA) and binary offset [$0946]
	dbra	d1,DBFWait1b														;51C9FFFE
	dbra	d0,DBFWait1b														;51C8FFFA
	move.l	#$FFFFFFFF,adrL_00EED6.l											;23FCFFFFFFFF0000EED6
	move.l	#$FFFFFFFF,adrL_00EF38.l											;23FCFFFFFFFF0000EF38
	clr.w	FrameSyncFlagWord_AI_TBC.l											;427900008C1E
	bsr		adrCd0042BA															;610035CC
	clr.w	FrameSyncFlagWord_AI_TBC.l											;427900008C1E
	moveq	#$14,d0																;7014
DBFWait1c:		; Memory Address ($0CF8) and binary offset [$0974]
	dbra	d1,DBFWait1c														;51C9FFFE
	dbra	d0,DBFWait1c														;51C8FFFA
	bra		LoadGame															;600036A2

RelocateTraps_AI_TBC:		; Memory Address ($0D04) and binary offset [$0980]
	lea		Player1_Data.l,a5													;4BF90000EE7C
	bsr.s	Setup_PlayerZOffset_AI_TBC											;6106
	lea		Player2_Data.l,a5													;4BF90000EEDE
Setup_PlayerZOffset_AI_TBC:		; Memory Address ($0D12) and binary offset [$098E]
	and.b	#$7F,$0052(a5)														;022D007F0052
	move.b	$0054(a5),d3														;162D0054
	clr.b	$0054(a5)															;422D0054
	move.w	$000A(a5),d0														;302D000A
	move.w	d0,d6																;3C00
	bsr.s	ScreenFade_Control_AI_TBC											;6156
	move.w	d6,d0																;3006
	add.w	#$001C,d0															;0640001C
	bsr.s	ScreenFade_Control_AI_TBC											;614E
	lsr.b	#$01,d3																;E20B
	bcc.s	Player_HeightAdjust_AI_TBC											;6408
	move.w	d6,d0																;3006
	add.w	#$0DCC,d0															;06400DCC
	bsr.s	Setup_ScreenFade_AI_TBC												;612C
Player_HeightAdjust_AI_TBC:		; Memory Address ($0D3C) and binary offset [$09B8]
	move.w	d6,d0																;3006
	lsr.b	#$01,d3																;E20B
	bcc.s	Player_HeightCheck_AI_TBC											;6406
	add.w	#$000C,d0															;0640000C
	bsr.s	Setup_ScreenFade_AI_TBC												;6120
Player_HeightCheck_AI_TBC:		; Memory Address ($0D48) and binary offset [$09C4]
	move.w	d6,d0																;3006
	lsr.b	#$01,d3																;E20B
	bcc		adrCd000DEA															;6400009C
	add.w	#$01EC,d0															;064001EC
	move.l	screen_ptr.l,a0														;207900008D36
	move.l	framebuffer_ptr.l,a1												;227900008D3A
	add.w	d0,a1																;D2C0
	add.w	d0,a0																;D0C0
	bra		adrCd000DEC															;60000086

Setup_ScreenFade_AI_TBC:		; Memory Address ($0D68) and binary offset [$09E4]
	move.l	screen_ptr.l,a0														;207900008D36
	move.l	framebuffer_ptr.l,a1												;227900008D3A
	add.w	d0,a1																;D2C0
	add.w	d0,a0																;D0C0
	moveq	#$07,d0																;7007
	bra		adrLp000DEE															;60000072

ScreenFade_Control_AI_TBC:		; Memory Address ($0D7E) and binary offset [$09FA]
	moveq	#$06,d2																;7406
	btst	#$05,d3																;08030005
	bne.s	adrCd000D8C															;6606
	moveq	#-$01,d2															;74FF
	add.w	#$0118,d0															;06400118
adrCd000D8C:		; Memory Address ($0D8C) and binary offset [$0A08]
	lsr.b	#$01,d3																;E20B
	bcc.s	adrCd000D94															;6404
	add.w	#$0051,d2															;06420051
adrCd000D94:		; Memory Address ($0D94) and binary offset [$0A10]
	lsr.b	#$01,d3																;E20B
	bcc.s	adrCd000D9A															;6402
	addq.w	#$08,d2																;5042
adrCd000D9A:		; Memory Address ($0D9A) and binary offset [$0A16]
	tst.w	d2																	;4A42
	bmi.s	adrCd000DEA															;6B4C
	move.l	screen_ptr.l,a0														;207900008D36
	move.l	framebuffer_ptr.l,a1												;227900008D3A
	add.w	d0,a1																;D2C0
	add.w	d0,a0																;D0C0
adrLp000DAE:		; Memory Address ($0DAE) and binary offset [$0A2A]
	lea		$5DC0(a1),a3														;47E95DC0
	lea		$5DC0(a0),a2														;45E85DC0
	move.l	(a3)+,(a2)+															;24DB
	move.l	(a3)+,(a2)+															;24DB
	move.l	(a3)+,(a2)+															;24DB
	lea		$3E80(a1),a3														;47E93E80
	lea		$3E80(a0),a2														;45E83E80
	move.l	(a3)+,(a2)+															;24DB
	move.l	(a3)+,(a2)+															;24DB
	move.l	(a3)+,(a2)+															;24DB
	lea		$1F40(a1),a3														;47E91F40
	lea		$1F40(a0),a2														;45E81F40
	move.l	(a3)+,(a2)+															;24DB
	move.l	(a3)+,(a2)+															;24DB
	move.l	(a3)+,(a2)+															;24DB
	move.l	(a1)+,(a0)+															;20D9
	move.l	(a1)+,(a0)+															;20D9
	move.l	(a1)+,(a0)+															;20D9
	lea		$001C(a0),a0														;41E8001C
	lea		$001C(a1),a1														;43E9001C
	dbra	d2,adrLp000DAE														;51CAFFC6
adrCd000DEA:		; Memory Address ($0DEA) and binary offset [$0A66]
	rts																			;4E75

adrCd000DEC:		; Memory Address ($0DEC) and binary offset [$0A68]
	moveq	#$4B,d0																;704B
adrLp000DEE:		; Memory Address ($0DEE) and binary offset [$0A6A]
	lea		$5DC0(a1),a3														;47E95DC0
	lea		$5DC0(a0),a2														;45E85DC0
	move.l	(a3)+,(a2)+															;24DB
	move.l	(a3)+,(a2)+															;24DB
	move.l	(a3)+,(a2)+															;24DB
	move.l	(a3)+,(a2)+															;24DB
	lea		$3E80(a1),a3														;47E93E80
	lea		$3E80(a0),a2														;45E83E80
	move.l	(a3)+,(a2)+															;24DB
	move.l	(a3)+,(a2)+															;24DB
	move.l	(a3)+,(a2)+															;24DB
	move.l	(a3)+,(a2)+															;24DB
	lea		$1F40(a1),a3														;47E91F40
	lea		$1F40(a0),a2														;45E81F40
	move.l	(a3)+,(a2)+															;24DB
	move.l	(a3)+,(a2)+															;24DB
	move.l	(a3)+,(a2)+															;24DB
	move.l	(a3)+,(a2)+															;24DB
	move.l	(a1)+,(a0)+															;20D9
	move.l	(a1)+,(a0)+															;20D9
	move.l	(a1)+,(a0)+															;20D9
	move.l	(a1)+,(a0)+															;20D9
	lea		$0018(a0),a0														;41E80018
	lea		$0018(a1),a1														;43E90018
	dbra	d0,adrLp000DEE														;51C8FFBE
	rts																			;4E75

Keyboard_InterruptService_AI_TBC:		; Memory Address ($0E34) and binary offset [$0AB0]
	move.l	a4,d0																;200C
	sub.l	#Character_Stats_DataTable,d0										;04800000EB2A
	lsr.w	#$01,d0																;E248
	lea		Character_Pockets_DataTable.l,a0									;41F90000ED2A
	add.w	d0,a0																;D0C0
	lsr.w	#$04,d0																;E848
	move.w	d0,d7																;3E00
	movem.l	d0/d1/d7/a5,-(sp)													;48E7C104
	bsr		adrCd004066															;61003216
	tst.w	d1																	;4A41
	bmi.s	CheckKeyboard_InputLoop_AI_TBC										;6B0E
	btst	#$06,$18(a5,d1.w)													;083500061018
	beq.s	CheckKeyboard_InputLoop_AI_TBC										;6706
	movem.l	(sp)+,d0/d1/d7/a5													;4CDF2083
	rts																			;4E75

CheckKeyboard_InputLoop_AI_TBC:		; Memory Address ($0E64) and binary offset [$0AE0]
	movem.l	(sp)+,d0/d1/d7/a5													;4CDF2083
	move.b	$0009(a4),d0														;102C0009
	cmp.b	$000A(a4),d0														;B02C000A
	beq.s	ProcessKeyCode_AI_TBC												;6704
	addq.b	#$01,$0009(a4)														;522C0009
ProcessKeyCode_AI_TBC:		; Memory Address ($0E76) and binary offset [$0AF2]
	move.b	(a4),d0																;1014
	lsr.b	#$01,d0																;E208
	cmp.b	#$5B,(a0)															;0C10005B
	beq.s	adrCd000E8A															;670A
	cmp.b	#$5B,$0001(a0)														;0C28005B0001
	beq.s	adrCd000E8A															;6702
	lsr.b	#$01,d0																;E208
adrCd000E8A:		; Memory Address ($0E8A) and binary offset [$0B06]
	addq.b	#$01,d0																;5200
	add.b	$0005(a4),d0														;D02C0005
	bcc.s	adrCd000E94															;6402
	moveq	#-$01,d0															;70FF
adrCd000E94:		; Memory Address ($0E94) and binary offset [$0B10]
	cmp.b	$0006(a4),d0														;B02C0006
	bcs.s	adrCd000E9E															;6504
	move.b	$0006(a4),d0														;102C0006
adrCd000E9E:		; Memory Address ($0E9E) and binary offset [$0B1A]
	move.b	d0,$0005(a4)														;19400005
	tst.b	$0007(a4)															;4A2C0007
	bne.s	RandomWalk_NormalReturn_AI_TBC										;6626
	movem.l	d7/a4/a5,-(sp)														;48E7010C
	bsr		RandomGen_BytewithOffset											;610046FE
	and.w	#$0007,d0															;02400007
	add.b	(a4),d0																;D014
	cmp.b	$0005(a4),d0														;B02C0005
	bcs.s	RandomWalk_Init_AI_TBC												;6506
	move.b	$0005(a4),d0														;102C0005
	beq.s	adrCd000ECA															;6708
RandomWalk_Init_AI_TBC:		; Memory Address ($0EC2) and binary offset [$0B3E]
	move.w	d0,d5																;3A00
	move.w	d7,d0																;3007
	bsr		adrCd002298															;610013D0
adrCd000ECA:		; Memory Address ($0ECA) and binary offset [$0B46]
	movem.l	(sp)+,d7/a4/a5														;4CDF3080
RandomWalk_NormalReturn_AI_TBC:		; Memory Address ($0ECE) and binary offset [$0B4A]
	move.b	$0010(a4),d0														;102C0010
	bne.s	adrCd000EE0															;660C
	subq.b	#$01,$0007(a4)														;532C0007
	bcc.s	adrCd000EF6															;641C
	clr.b	$0007(a4)															;422C0007
	bra.s	adrCd000EF6															;6016

adrCd000EE0:		; Memory Address ($0EE0) and binary offset [$0B5C]
	lsr.b	#$06,d0																;EC08
	addq.b	#$01,d0																;5200
	add.b	$0007(a4),d0														;D02C0007
	cmp.b	$0008(a4),d0														;B02C0008
	bcs.s	adrCd000EF2															;6504
	move.b	$0008(a4),d0														;102C0008
adrCd000EF2:		; Memory Address ($0EF2) and binary offset [$0B6E]
	move.b	d0,$0007(a4)														;19400007
adrCd000EF6:		; Memory Address ($0EF6) and binary offset [$0B72]
	rts																			;4E75

Stat_UpdateLoop_AI_TBC:		; Memory Address ($0EF8) and binary offset [$0B74]
	lea		Character_Stats_DataTable.l,a4										;49F90000EB2A
	moveq	#$0F,d7																;7E0F
adrLp000F00:		; Memory Address ($0F00) and binary offset [$0B7C]
	movem.l	d7/a4,-(sp)															;48E70108
	bsr		Keyboard_InterruptService_AI_TBC									;6100FF2E
	movem.l	(sp)+,d7/a4															;4CDF1080
	add.w	#$0020,a4															;D8FC0020
	dbra	d7,adrLp000F00														;51CFFFEE
	subq.b	#$01,adrB_00EE3C.l													;53390000EE3C
	lea		Player1_Data.l,a5													;4BF90000EE7C
	bsr		ChampionFlag_Test_AI_TBC											;6100001C
	lea		Player2_Data.l,a5													;4BF90000EEDE
	bsr		ChampionFlag_Test_AI_TBC											;61000012
	tst.b	adrB_00EE3C.l														;4A390000EE3C
	bpl.s	ChampionFlag_Reset_AI_TBC											;6A06
	clr.b	adrB_00EE3C.l														;42390000EE3C
ChampionFlag_Reset_AI_TBC:		; Memory Address ($0F3C) and binary offset [$0BB8]
	rts																			;4E75

ChampionFlag_Test_AI_TBC:		; Memory Address ($0F3E) and binary offset [$0BBA]
	tst.b	adrB_00EE3C.l														;4A390000EE3C
	bpl		adrCd00104A															;6A000104
	moveq	#$00,d6																;7C00
	moveq	#$03,d7																;7E03
adrLp000F4C:		; Memory Address ($0F4C) and binary offset [$0BC8]
	move.b	$18(a5,d7.w),d0														;10357018
	bmi.s	adrCd000FB8															;6B66
	btst	#$06,d0																;08000006
	bne.s	adrCd000FB8															;6660
	and.w	#$000F,d0															;0240000F
	move.w	d0,d1																;3200
	bsr		Load_ChampionStatRecord												;61005700
	btst	#$02,(a5)															;08150002
	bne.s	TeamAvatar_UpdateLoop_AI_TBC										;6618
	btst	#$06,$18(a5,d7.w)													;083500067018
	bne.s	TeamAvatar_UpdateLoop_AI_TBC										;6610
	cmpi.b	#$0B,d1																;0C01000B
	beq.s	TeamAvatar_UpdateLoop_AI_TBC										;670A
	subq.b	#$01,$0010(a4)														;532C0010
	bcc.s	TeamAvatar_UpdateLoop_AI_TBC										;6404
	clr.b	$0010(a4)															;422C0010
TeamAvatar_UpdateLoop_AI_TBC:		; Memory Address ($0F80) and binary offset [$0BFC]
	move.b	$0011(a4),d0														;102C0011
	and.w	#$0007,d0															;02400007
	beq.s	adrCd000FB8															;672E
	subq.b	#$08,$0011(a4)														;512C0011
	bcc.s	adrCd000FB8															;6428
	clr.b	$0011(a4)															;422C0011
	tst.w	d7																	;4A47
	bne.s	adrCd000F9A															;6602
	addq.b	#$01,d6																;5206
adrCd000F9A:		; Memory Address ($0F9A) and binary offset [$0C16]
	btst	d7,$003E(a5)														;0F2D003E
	bne.s	adrCd000FB8															;6618
	tst.w	d7																	;4A47
	beq.s	TriggerState_Reset_AI_TBC											;6706
	tst.w	$0042(a5)															;4A6D0042
	bpl.s	adrCd000FB8															;6A0E
TriggerState_Reset_AI_TBC:		; Memory Address ($0FAA) and binary offset [$0C26]
	movem.w	d6/d7,-(sp)															;48A70300
	bsr		Refresh_PartyShieldSlotIfDirty										;61006F40
	movem.w	(sp)+,d6/d7															;4C9F00C0
	bset	d7,d6																;0FC6
adrCd000FB8:		; Memory Address ($0FB8) and binary offset [$0C34]
	dbra	d7,adrLp000F4C														;51CFFF92
	btst	#$00,d6																;08060000
	beq.s	TriggerState_Check_AI_TBC											;670E
	tst.b	$0015(a5)															;4A2D0015
	bne.s	TriggerState_Check_AI_TBC											;6608
	move.w	d6,-(sp)															;3F06
	bsr		Load_MapPosition_AI_TBC												;61007202
	move.w	(sp)+,d6															;3C1F
TriggerState_Check_AI_TBC:		; Memory Address ($0FD0) and binary offset [$0C4C]
	and.w	#$000E,d6															;0246000E
	beq.s	adrCd00104A															;6774
	bsr		Draw_PartyShieldChainStrip											;61006EFA
	bra.s	adrCd00104A															;606E

FloorTrigger_Handler_AI_TBC:		; Memory Address ($0FDC) and binary offset [$0C58]
	btst	#$02,(a5)															;08150002
	beq		adrCd00108E															;670000AC
	clr.w	adrW_001062.l														;427900001062
	bsr		adrCd0084D6															;610074EA
	bsr		adrCd00847E															;6100748E
	move.w	$00(a6,d0.w),d1														;32360000
	and.w	#$0007,d1															;02410007
	subq.w	#$03,d1																;5741
	bne.s	adrCd00100C															;660E
	tst.b	$00(a6,d0.w)														;4A360000
	bne.s	adrCd00100C															;6608
	move.w	#$FFFF,adrW_001062.l												;33FCFFFF00001062
adrCd00100C:		; Memory Address ($100C) and binary offset [$0C88]
	moveq	#$03,d7																;7E03
adrLp00100E:		; Memory Address ($100E) and binary offset [$0C8A]
	move.b	$18(a5,d7.w),d0														;10357018
	and.w	#$00E0,d0															;024000E0
	bne.s	adrCd001046															;662E
	move.b	$18(a5,d7.w),d0														;10357018
	bsr		Load_ChampionStatRecord												;61005642
	subq.b	#$06,$0015(a4)														;5D2C0015
	bcc.s	adrCd00102A															;6404
	clr.b	$0015(a4)															;422C0015
adrCd00102A:		; Memory Address ($102A) and binary offset [$0CA6]
	movem.l	d7/a5,-(sp)															;48E70104
	bsr		Keyboard_InterruptService_AI_TBC									;6100FE04
	tst.w	adrW_001062.l														;4A7900001062
	beq.s	adrCd001042															;6708
	subq.b	#$01,$0009(a4)														;532C0009
	bsr		Keyboard_InterruptService_AI_TBC									;6100FDF4
adrCd001042:		; Memory Address ($1042) and binary offset [$0CBE]
	movem.l	(sp)+,d7/a5															;4CDF2080
adrCd001046:		; Memory Address ($1046) and binary offset [$0CC2]
	dbra	d7,adrLp00100E														;51CFFFC6
adrCd00104A:		; Memory Address ($104A) and binary offset [$0CC6]
	bsr		Draw_MainPlayerInterface											;6100707E
	move.w	$0014(a5),d1														;322D0014
	subq.w	#$01,d1																;5341
	beq		Click_ShowStats														;670055C0
	subq.b	#$01,d1																;5301
	bne.s	adrCd00108E															;6632
	jmp		Draw_SpellPointValues.l												;4EF90000C812

adrW_001062:		; Memory Address ($1062) and binary offset [$0CDE]
	ds.b	$2
adrCd001064:		; Memory Address ($1064) and binary offset [$0CE0]
	subq.b	#$01,adrB_00EE3D.l													;53390000EE3D
	bpl.s	adrCd00108E															;6A22
	move.b	#$07,adrB_00EE3D.l													;13FC00070000EE3D
	moveq	#$0F,d7																;7E0F
	lea		Character_Stats_DataTable.l,a4										;49F90000EB2A
adrLp00107C:		; Memory Address ($107C) and binary offset [$0CF8]
	subq.b	#$01,$0015(a4)														;532C0015
	bcc.s	adrCd001086															;6404
	clr.b	$0015(a4)															;422C0015
adrCd001086:		; Memory Address ($1086) and binary offset [$0D02]
	add.w	#$0020,a4															;D8FC0020
	dbra	d7,adrLp00107C														;51CFFFF0
adrCd00108E:		; Memory Address ($108E) and binary offset [$0D0A]
	rts																			;4E75

adrCd001090:		; Memory Address ($1090) and binary offset [$0D0C]
	moveq	#$00,d6																;7C00
	lea		UnpackedMonsters.l,a3												;47F900016B7E
	lea		MonsterTeamIndexTable.l,a0											;41F900017390
	move.w	MonsterTeamIndexTable_CountOffset(a0),d7							;3E28FFFE
	bmi.s	adrCd00108E															;6BEA
adrLp0010A4:		; Memory Address ($10A4) and binary offset [$0D20]
	cmp.l	#$FFFFFFFF,(a0)														;0C90FFFFFFFF
	beq.s	adrCd0010EA															;673E
	moveq	#-$01,d4															;78FF
	moveq	#MonsterTeamMember_Count-1,d1										;7203
adrLp0010B0:		; Memory Address ($10B0) and binary offset [$0D2C]
	moveq	#$00,d2																;7400
	move.b	$00(a0,d1.w),d2														;14301000
	bmi.s	adrCd0010CA															;6B12
	addq.w	#$01,d4																;5244
	asl.w	#$04,d2																;E942
	move.b	MonsterRecord_TeamGroupIndex(a3,d2.w),d3							;1633200D
	bmi.s	adrCd0010CA															;6B08
	sub.b	d6,d3																;9606
	move.b	d3,MonsterRecord_TeamGroupIndex(a3,d2.w)							;1783200D
	move.w	d2,d5																;3A02
adrCd0010CA:		; Memory Address ($10CA) and binary offset [$0D46]
	dbra	d1,adrLp0010B0														;51C9FFE4
	tst.w	d4																	;4A44
	bne.s	adrCd00110A															;6638
	move.b	#MonsterRecord_NoTeamGroup,MonsterRecord_TeamGroupIndex(a3,d5.w)	;17BC00FF500D
	move.b	MonsterRecord_RotationAndSpace(a3,d5.w),d4							;18335002
	and.w	#$0003,d4															;02440003
	move.w	d4,d2																;3404
	asl.w	#$04,d4																;E944
	or.w	d4,d2																;8444
	move.b	d2,$02(a3,d5.w)														;17825002
adrCd0010EA:		; Memory Address ($10EA) and binary offset [$0D66]
	lea		$0004(a0),a1														;43E80004
	lea		(a0),a2																;45D0
	move.w	d7,d1																;3207
	bra.s	adrCd0010F6															;6002

adrLp0010F4:		; Memory Address ($10F4) and binary offset [$0D70]
	move.l	(a1)+,(a2)+															;24D9
adrCd0010F6:		; Memory Address ($10F6) and binary offset [$0D72]
	dbra	d1,adrLp0010F4														;51C9FFFC
	move.l	#$FFFFFFFF,(a2)														;24BCFFFFFFFF
	subq.w	#$01,MonsterTeamGroupCount.l										;53790001738E
	addq.w	#$01,d6																;5246
	bra.s	adrCd00116E															;6064

adrCd00110A:		; Memory Address ($110A) and binary offset [$0D86]
	move.w	(a0),d0																;3010
	and.w	#$8080,d0															;02408080
	beq.s	adrCd00116C															;675A
	move.b	$0003(a0),d2														;14280003
	bmi.s	adrCd001120															;6B08
	move.b	#$FF,$0003(a0)														;117C00FF0003
	bra.s	adrCd00112A															;600A

adrCd001120:		; Memory Address ($1120) and binary offset [$0D9C]
	move.b	$0002(a0),d2														;14280002
	move.b	#$FF,$0002(a0)														;117C00FF0002
adrCd00112A:		; Memory Address ($112A) and binary offset [$0DA6]
	moveq	#$01,d1																;7201
	tst.b	d0																	;4A00
	bmi.s	adrCd001132															;6B02
	moveq	#$00,d1																;7200
adrCd001132:		; Memory Address ($1132) and binary offset [$0DAE]
	move.b	d2,$00(a0,d1.w)														;11821000
	move.w	d5,d3																;3605
	lsr.w	#$04,d3																;E84B
	cmp.b	(a0),d3																;B610
	beq.s	adrCd00116C															;672E
	move.b	(a0),d3																;1610
	asl.w	#$04,d3																;E943
	move.b	MonsterRecord_XPosition(a3,d5.w),MonsterRecord_XPosition(a3,d3.w)	;17B350003000
	move.b	MonsterRecord_YPosition(a3,d5.w),MonsterRecord_YPosition(a3,d3.w)	;17B350013001
	move.b	MonsterRecord_Floor(a3,d5.w),MonsterRecord_Floor(a3,d3.w)			;17B350043004
	move.b	#$FF,$00(a3,d5.w)													;17BC00FF5000
	move.b	MonsterRecord_RotationAndSpace(a3,d5.w),MonsterRecord_RotationAndSpace(a3,d3.w)	;17B350023002
	move.b	MonsterRecord_TeamGroupIndex(a3,d5.w),MonsterRecord_TeamGroupIndex(a3,d3.w)	;17B3500D300D
	move.b	#MonsterRecord_NoTeamGroup,MonsterRecord_TeamGroupIndex(a3,d5.w)	;17BC00FF500D
adrCd00116C:		; Memory Address ($116C) and binary offset [$0DE8]
	addq.w	#$04,a0																;5848
adrCd00116E:		; Memory Address ($116E) and binary offset [$0DEA]
	dbra	d7,adrLp0010A4														;51CFFF34
	rts																			;4E75

adrCd001174:		; Memory Address ($1174) and binary offset [$0DF0]
	clr.w	adrW_0020F4.l														;4279000020F4
	moveq	#$00,d1																;7200
	move.l	Current_TowerMapDataBase.l,a6										;2C790000EE78
	lea		adrEA0173F6.l,a0													;41F9000173F6
adrCd001188:		; Memory Address ($1188) and binary offset [$0E04]
	cmp.w	-$0002(a0),d1														;B268FFFE
	bcs.s	adrCd001190															;6502
	rts																			;4E75

adrCd001190:		; Memory Address ($1190) and binary offset [$0E0C]
	move.w	$02(a0,d1.w),d0														;30301002
	subq.b	#$04,$00(a6,d0.w)													;59360000
	bcs.s	adrCd0011B6															;651C
	cmp.b	#$01,$00(a0,d1.w)													;0C3000011000
	bne.s	adrCd0011B2															;6610
	tst.b	$01(a6,d0.w)														;4A360001
	bpl.s	adrCd0011B2															;6A0A
	move.b	$01(a0,d1.w),adrB_00EE3E.l											;13F010010000EE3E
	bsr.s	adrCd0011BA															;6108
adrCd0011B2:		; Memory Address ($11B2) and binary offset [$0E2E]
	addq.w	#$04,d1																;5841
	bra.s	adrCd001188															;60D2

adrCd0011B6:		; Memory Address ($11B6) and binary offset [$0E32]
	bsr.s	adrCd001212															;615A
	bra.s	adrCd001188															;60CE

adrCd0011BA:		; Memory Address ($11BA) and binary offset [$0E36]
	movem.l	d1/a0/a5/a6,-(sp)													;48E74086
	move.b	$00(a6,d0.w),d1														;12360000
	lsr.b	#$02,d1																;E409
	movem.w	d0/d1,-(sp)															;48A7C000
	jsr		adrCd0098A4.l														;4EB9000098A4
	bcc.s	adrCd001208															;6438
	tst.b	d0																	;4A00
	bmi.s	adrCd0011F0															;6B1C
	cmpi.b	#$10,d0																;0C000010
	bcs.s	adrCd0011E0															;6506
	tst.b	$000B(a1)															;4A29000B
	bmi.s	adrCd001208															;6B28
adrCd0011E0:		; Memory Address ($11E0) and binary offset [$0E5C]
	move.w	$0002(sp),d7														;3E2F0002
	bsr		adrCd001E42															;61000C5C
	move.w	(sp),d0																;3017
	bsr		adrCd00230C															;61001120
	bra.s	adrCd001208															;6018

adrCd0011F0:		; Memory Address ($11F0) and binary offset [$0E6C]
	move.l	a1,a5																;2A49
	moveq	#$05,d1																;7205
	bsr		adrCd005500															;6100430A
	tst.w	d3																	;4A43
	bpl.s	adrCd001208															;6A0C
	move.w	$0002(sp),d7														;3E2F0002
	bsr		adrCd001E42															;61000C40
	bsr		adrCd00248C															;61001286
adrCd001208:		; Memory Address ($1208) and binary offset [$0E84]
	movem.w	(sp)+,d0/d1															;4C9F0003
	movem.l	(sp)+,d1/a0/a5/a6													;4CDF6102
	rts																			;4E75

adrCd001212:		; Memory Address ($1212) and binary offset [$0E8E]
	and.w	#$00F8,$00(a6,d0.w)													;027600F80000
	lea		$00(a0,d1.w),a1														;43F01000
	lea		$0004(a1),a2														;45E90004
	move.w	-$0002(a0),d0														;3028FFFE
	sub.w	d1,d0																;9041
	lsr.w	#$02,d0																;E448
	subq.w	#$01,d0																;5340
	bra.s	adrCd00122E															;6002

adrLp00122C:		; Memory Address ($122C) and binary offset [$0EA8]
	move.l	(a2)+,(a1)+															;22DA
adrCd00122E:		; Memory Address ($122E) and binary offset [$0EAA]
	dbra	d0,adrLp00122C														;51C8FFFC
	subq.w	#$04,-$0002(a0)														;5968FFFE
	rts																			;4E75

adrCd001238:		; Memory Address ($1238) and binary offset [$0EB4]
	tst.w	adrEA00EE36.l														;4A790000EE36
	bne.s	adrCd001286															;6646
	move.w	#$012C,adrEA00EE36.l												;33FC012C0000EE36
	bsr		adrCd001174															;6100FF2A
	lea		Player1_Data.l,a5													;4BF90000EE7C
	bsr		FloorTrigger_Handler_AI_TBC											;6100FD88
	lea		ReserveSpace_1.l,a6													;4DF900058828
	bsr		adrCd005694															;61004436
	lea		Player2_Data.l,a5													;4BF90000EEDE
	bsr		FloorTrigger_Handler_AI_TBC											;6100FD74
	lea		ReserveSpace_2.l,a6													;4DF900058C10
	bsr		adrCd005694															;61004422
	bsr		adrCd001090															;6100FE1A
	bchg	#$01,adrB_00EE3F.l													;087900010000EE3F
	beq.s	adrCd001286															;6704
	bsr		Stat_UpdateLoop_AI_TBC												;6100FC74
adrCd001286:		; Memory Address ($1286) and binary offset [$0F02]
	tst.w	adrW_00EE38.l														;4A790000EE38
	bne		adrCd0013C0															;66000132
	move.w	#$0007,adrW_00EE38.l												;33FC00070000EE38
	bsr		adrCd001064															;6100FDCA
	lea		adrEA0174F8.l,a0													;41F9000174F8
	lea		-$0002(a0),a1														;43E8FFFE
	move.l	Current_TowerMapDataBase.l,a6										;2C790000EE78
	move.w	-$0002(a0),d7														;3E28FFFE
	bra.s	adrCd0012DA															;6028

adrLp0012B2:		; Memory Address ($12B2) and binary offset [$0F2E]
	move.w	(a0)+,d0															;3018
	subq.w	#$01,(a0)															;5350
	move.w	(a0)+,d1															;3218
	not.w	d1																	;4641
	and.w	#$0003,d1															;02410003
	bne.s	adrCd0012DA															;661A
	bclr	#$05,$01(a6,d0.w)													;08B600050001
	subq.w	#$04,a0																;5948
	lea		(a0),a2																;45D0
	lea		$0004(a0),a3														;47E80004
	move.w	d7,d1																;3207
	bra.s	adrCd0012D4															;6002

adrLp0012D2:		; Memory Address ($12D2) and binary offset [$0F4E]
	move.l	(a3)+,(a2)+															;24DB
adrCd0012D4:		; Memory Address ($12D4) and binary offset [$0F50]
	dbra	d1,adrLp0012D2														;51C9FFFC
	subq.w	#$01,(a1)															;5351
adrCd0012DA:		; Memory Address ($12DA) and binary offset [$0F56]
	dbra	d7,adrLp0012B2														;51CFFFD6
	lea		Player1_Data.l,a5													;4BF90000EE7C
	bsr		adrCd002904															;6100161E
	lea		Player2_Data.l,a5													;4BF90000EEDE
	bsr		adrCd002904															;61001614
	moveq	#$00,d7																;7E00
	move.w	#$FFFF,adrW_0013C2.l												;33FCFFFF000013C2
	clr.w	adrW_0013C4.l														;4279000013C4
	lea		Character_Stats_DataTable.l,a4										;49F90000EB2A
adrCd001308:		; Memory Address ($1308) and binary offset [$0F84]
	move.w	d7,-(sp)															;3F07
	move.w	d7,d0																;3007
	move.w	d7,adrW_0013C2.l													;33C7000013C2
	bsr		adrCd004066															;61002D52
	tst.w	d1																	;4A41
	bpl.s	adrCd001320															;6A06
	moveq	#$16,d4																;7816
	bsr		adrCd0013C6															;610000A8
adrCd001320:		; Memory Address ($1320) and binary offset [$0F9C]
	add.w	#$0020,a4															;D8FC0020
	move.w	(sp)+,d7															;3E1F
	addq.w	#$01,d7																;5247
	cmpi.w	#$0010,d7															;0C470010
	bcs.s	adrCd001308															;65DA
	lea		UnpackedMonsters.l,a4												;49F900016B7E
	move.w	-$0002(a4),d7														;3E2CFFFE
	bmi.s	adrCd001352															;6B18
adrLp00133A:		; Memory Address ($133A) and binary offset [$0FB6]
	move.w	d7,-(sp)															;3F07
	addq.w	#$01,adrW_0013C2.l													;5279000013C2
	moveq	#$00,d4																;7800
	bsr		adrCd0013D8															;61000092
	add.w	#$0010,a4															;D8FC0010
	move.w	(sp)+,d7															;3E1F
	dbra	d7,adrLp00133A														;51CFFFEA
adrCd001352:		; Memory Address ($1352) and binary offset [$0FCE]
	lea		Player1_Data.l,a5													;4BF90000EE7C
	bsr.s	adrCd001360															;6106
	lea		Player2_Data.l,a5													;4BF90000EEDE
adrCd001360:		; Memory Address ($1360) and binary offset [$0FDC]
	moveq	#$03,d7																;7E03
	moveq	#$00,d6																;7C00
adrLp001364:		; Memory Address ($1364) and binary offset [$0FE0]
	tst.b	$5A(a5,d7.w)														;4A35705A
	bmi.s	adrCd00137E															;6B14
	subq.b	#$01,$5A(a5,d7.w)													;5335705A
	bpl.s	adrCd00137E															;6A0E
	moveq	#$01,d6																;7C01
	movem.w	d6/d7,-(sp)															;48A70300
	bsr		Refresh_PartyShieldSlotIfDirty										;61006B78
	movem.w	(sp)+,d6/d7															;4C9F00C0
adrCd00137E:		; Memory Address ($137E) and binary offset [$0FFA]
	dbra	d7,adrLp001364														;51CFFFE4
	tst.w	d6																	;4A46
	beq		adrCd00138C															;67000006
	bsr		Draw_PartyShieldChainStrip											;61006B48
adrCd00138C:		; Memory Address ($138C) and binary offset [$1008]
	moveq	#$03,d7																;7E03
adrLp00138E:		; Memory Address ($138E) and binary offset [$100A]
	tst.b	$5E(a5,d7.w)														;4A35705E
	bmi.s	adrCd0013A2															;6B0E
	subq.b	#$01,$5E(a5,d7.w)													;5335705E
	bpl.s	adrCd0013A2															;6A08
	move.w	d7,-(sp)															;3F07
	bsr		adrCd006096															;61004CF8
	move.w	(sp)+,d7															;3E1F
adrCd0013A2:		; Memory Address ($13A2) and binary offset [$101E]
	dbra	d7,adrLp00138E														;51CFFFEA
	rts																			;4E75

adrCd0013A8:		; Memory Address ($13A8) and binary offset [$1024]
	sub.w	d1,d0																;9041
	move.w	d0,d1																;3200
	bpl.s	adrCd0013B0															;6A02
	neg.w	d0																	;4440
adrCd0013B0:		; Memory Address ($13B0) and binary offset [$102C]
	move.w	d0,d2																;3400
	swap	d0																	;4840
	swap	d1																	;4841
	sub.w	d1,d0																;9041
	move.w	d0,d1																;3200
	bpl.s	adrCd0013BE															;6A02
	neg.w	d0																	;4440
adrCd0013BE:		; Memory Address ($13BE) and binary offset [$103A]
	add.w	d0,d2																;D440
adrCd0013C0:		; Memory Address ($13C0) and binary offset [$103C]
	rts																			;4E75

adrW_0013C2:		; Memory Address ($13C2) and binary offset [$103E]
	ds.b	$2
adrW_0013C4:		; Memory Address ($13C4) and binary offset [$1040]
	ds.b	$2
adrCd0013C6:		; Memory Address ($13C6) and binary offset [$1042]
	move.w	CurrentTower.l,d0													;30390000EE2E
	cmp.b	$001F(a4),d0														;B02C001F
	bne.s	adrCd0013C0															;66EE
	bsr		Update_CharacterAttackCooldown										;610015B0
	bra.s	adrCd0013EE															;6016

adrCd0013D8:		; Memory Address ($13D8) and binary offset [$1054]
	move.b	$0005(a4),d0														;102C0005
	bsr		Decrement_CharacterTimerLowBits										;61001594
	move.b	$0005(a4),d1														;122C0005
	and.b	#$60,d1																;02010060
	or.b	d1,d0																;8001
	move.b	d0,$0005(a4)														;19400005
adrCd0013EE:		; Memory Address ($13EE) and binary offset [$106A]
	move.b	$04(a4,d4.w),d0														;10344004
	cmp.b	adrB_00EED5.l,d0													;B0390000EED5
	beq.s	adrCd001402															;6708
	cmp.b	adrB_00EF37.l,d0													;B0390000EF37
	bne.s	adrCd001414															;6612
adrCd001402:		; Memory Address ($1402) and binary offset [$107E]
	move.b	$03(a4,d4.w),d7														;1E344003
	move.w	d7,d1																;3207
	and.w	#$000F,d1															;0241000F
	subq.w	#$01,d1																;5341
	bcs.s	adrCd001416															;6506
	subq.b	#$01,$03(a4,d4.w)													;53344003
adrCd001414:		; Memory Address ($1414) and binary offset [$1090]
	rts																			;4E75

adrCd001416:		; Memory Address ($1416) and binary offset [$1092]
	move.w	d7,d1																;3207
	lsr.b	#$04,d1																;E809
	or.b	d7,d1																;8207
	move.b	d1,$03(a4,d4.w)														;19814003
	btst	#$06,$05(a4,d4.w)													;083400064005
	beq.s	adrCd00143E															;6716
	move.w	#$001E,adrW_0020F4.l												;33FC001E000020F4
	bsr		adrCd0014E8															;610000B6
	tst.w	d5																	;4A45
	bne.s	adrCd00143E															;6606
	bclr	#$06,$05(a4,d4.w)													;08B400064005
adrCd00143E:		; Memory Address ($143E) and binary offset [$10BA]
	btst	#$05,$05(a4,d4.w)													;083400054005
	beq.s	adrCd00146E															;6728
	and.b	#$F0,$03(a4,d4.w)													;023400F04003
	or.b	#$02,$03(a4,d4.w)													;003400024003
	move.w	#$0028,adrW_0020F4.l												;33FC0028000020F4
	bsr		adrCd0014E8															;6100008C
	tst.w	d5																	;4A45
	bne.s	adrCd00146E															;660C
	bclr	#$05,$05(a4,d4.w)													;08B400054005
	or.b	#$0F,$03(a4,d4.w)													;0034000F4003
adrCd00146E:		; Memory Address ($146E) and binary offset [$10EA]
	tst.b	$05(a4,d4.w)														;4A344005
	bpl.s	adrCd001498															;6A24
	move.w	#$0014,adrW_0020F4.l												;33FC0014000020F4
	bsr		adrCd0014E8															;6100006A
	and.b	#$7F,$05(a4,d4.w)													;0234007F4005
	tst.w	d5																	;4A45
	beq.s	adrCd001498															;670E
	or.b	#$0F,$03(a4,d4.w)													;0034000F4003
	bset	#$07,$05(a4,d4.w)													;08F400074005
adrCd001496:		; Memory Address ($1496) and binary offset [$1112]
	rts																			;4E75

adrCd001498:		; Memory Address ($1498) and binary offset [$1114]
	moveq	#$00,d7																;7E00
	move.b	$00(a4,d4.w),d7														;1E344000
	bmi		adrCd001414															;6B00FF74
	swap	d7																	;4847
	move.b	$01(a4,d4.w),d7														;1E344001
	moveq	#$00,d0																;7000
	move.b	$04(a4,d4.w),d0														;10344004
	bsr		adrCd0084DA															;6100702A
	bsr		CoordToMap															;61006FE8
	move.b	$01(a6,d0.w),d1														;12360001
	bpl.s	adrCd001496															;6ADA
	cmpi.w	#$0000,d4															;0C440000
	beq.s	adrCd00150C															;674A
	bsr		adrCd001842															;6100037E
	bpl		adrCd001BCE															;6A000706
	tst.w	adrW_0013C4.w														;4A7813C4	;Short Absolute converted to symbol!
	beq		AttackType_Drone													;6700028A
	lea		ReserveSpace_1.l,a6													;4DF900058828
	btst	#$00,(a5)															;08150000
	beq.s	adrCd0014E4															;6706
	lea		ReserveSpace_2.l,a6													;4DF900058C10
adrCd0014E4:		; Memory Address ($14E4) and binary offset [$1160]
	bra		adrCd0016CE															;600001E8

adrCd0014E8:		; Memory Address ($14E8) and binary offset [$1164]
	move.l	a4,a1																;224C
	move.l	a1,d0																;2009
	cmpi.w	#$0000,d4															;0C440000
	bne.s	adrCd001500															;660E
	sub.l	#UnpackedMonsters,d0												;048000016B7E
	lsr.w	#$04,d0																;E848
	add.w	#$0010,d0															;06400010
	bra.s	adrCd001508															;6008

adrCd001500:		; Memory Address ($1500) and binary offset [$117C]
	sub.l	#Character_Stats_DataTable,d0										;04800000EB2A
	lsr.w	#$05,d0																;EA48
adrCd001508:		; Memory Address ($1508) and binary offset [$1184]
	bra		adrCd0020F6															;60000BEC

adrCd00150C:		; Memory Address ($150C) and binary offset [$1188]
	move.b	$000B(a4),d2														;142C000B
	bmi		adrCd001708															;6B0001F6
	cmpi.b	#$40,d2																;0C020040
	beq.s	adrCd001526															;670C
	cmpi.b	#$67,d2																;0C020067
	bcc.s	adrCd001526															;6406
	tst.b	$000D(a4)															;4A2C000D
	bmi.s	adrCd00153A															;6B14
adrCd001526:		; Memory Address ($1526) and binary offset [$11A2]
	and.b	#$03,$0002(a4)														;022C00030002
	move.b	$0002(a4),d6														;1C2C0002
	asl.b	#$04,d6																;E906
	or.b	$0002(a4),d6														;8C2C0002
	move.b	d6,$0002(a4)														;19460002
adrCd00153A:		; Memory Address ($153A) and binary offset [$11B6]
	bsr		adrCd001842															;61000306
	bpl		adrCd001BCE															;6A00068E
	move.w	adrW_0013C2.w,d1													;323813C2	;Short Absolute converted to symbol!
	cmp.b	adrB_00EEB1.l,d1													;B2390000EEB1
	beq		adrCd001BD4															;67000686
	cmp.b	adrB_00EF13.l,d1													;B2390000EF13
	beq		adrCd001BD4															;6700067C
	move.b	$0005(a4),d1														;122C0005
	and.w	#$0060,d1															;02410060
	bne		AttackType_Drone													;660001F6
	move.b	$0006(a4),d0														;102C0006
	move.b	$0007(a4),d1														;122C0007
	and.w	#$007F,d1															;0241007F
	and.w	#$007F,d0															;0240007F
	cmp.w	d0,d1																;B240
	bcc.s	adrCd001596															;641C
	move.l	a4,a1																;224C
	clr.w	adrW_0020F4.l														;4279000020F4
	bsr		adrCd0020F6															;61000B72
	tst.w	d5																	;4A45
	beq.s	adrCd001596															;670C
	bchg	#$07,$0007(a4)														;086C00070007
	beq.s	adrCd001596															;6704
	addq.b	#$01,$0007(a4)														;522C0007
adrCd001596:		; Memory Address ($1596) and binary offset [$1212]
	move.b	$000A(a4),d1														;122C000A
	add.w	d1,d1																;D241
	lea		AttackType_NoSpells.l,a1											;43F90000166A
	lea		MonsterAttackTypeTable.l,a0											;41F9000015AE
	add.w	$00(a0,d1.w),a1														;D2F01000
	jmp		(a1)																;4ED1

MonsterAttackTypeTable:		; Memory Address ($15AE) and binary offset [$122A]
	dc.w	AttackType_NoSpells-AttackType_NoSpells	;0000
	dc.w	AttackType_Spells-AttackType_NoSpells	;FF6C
	dc.w	AttackType_Drone-AttackType_NoSpells	;00F0
	dc.w	AttackType_DroneSpells-AttackType_NoSpells	;FF4E
	dc.w	adrJA001664-AttackType_NoSpells	;FFFA

AttackType_DroneSpells:		; Memory Address ($15B8) and binary offset [$1234]
	bsr		RandomGen_BytewithOffset											;61003FF2
	and.w	#$000F,d0															;0240000F
	bne		AttackType_Drone													;66000198
	bra.s	adrCd0015E0															;601A

MonsterAttackSpells:		; Memory Address ($15C6) and binary offset [$1242]
	INCBIN "/data/BLOODWYCH439-clean/data/monsters.spellbook.block"

AttackType_Spells:		; Memory Address ($15D6) and binary offset [$1252]
	bsr		adrCd005556															;61003F7E
	subq.b	#$02,d0																;5500
	bcc		AttackType_NoSpells													;6400008C
adrCd0015E0:		; Memory Address ($15E0) and binary offset [$125C]
	bsr		RandomGen_BytewithOffset											;61003FCA
	and.w	#$000F,d0															;0240000F
	move.b	$0007(a4),d3														;162C0007
	and.w	#$007F,d3															;0243007F
	cmpi.b	#$08,d3																;0C030008
	bcc.s	adrCd001608															;6412
	lsr.w	#$01,d0																;E248
	cmpi.b	#$05,d3																;0C030005
	bcc.s	adrCd001608															;640A
	lsr.w	#$01,d0																;E248
	cmpi.b	#$04,d3																;0C030004
	bcc.s	adrCd001608															;6402
	lsr.w	#$01,d0																;E248
adrCd001608:		; Memory Address ($1608) and binary offset [$1284]
	move.b	MonsterAttackSpells(pc,d0.w),d0										;103B00BC
	move.w	d0,d4																;3800
	or.w	#$0080,d4															;00440080
	move.w	d3,d6																;3C03
	and.w	#$0080,d0															;02400080
	or.b	d0,d3																;8600
	add.w	d3,d3																;D643
	add.b	d6,d3																;D606
	cmpi.b	#$81,d4																;0C040081
	beq.s	adrCd00162C															;6708
	cmpi.b	#$8E,d4																;0C04008E
	beq.s	adrCd00162C															;6702
	lsr.b	#$01,d3																;E20B
adrCd00162C:		; Memory Address ($162C) and binary offset [$12A8]
	move.b	$0002(a4),d0														;102C0002
	and.w	#$0003,d0															;02400003
	move.w	d0,d6																;3C00
	swap	d6																	;4846
	move.w	d0,d6																;3C00
	moveq	#$00,d5																;7A00
	move.b	$0004(a4),d5														;1A2C0004
	moveq	#$00,d7																;7E00
	move.b	$0000(a4),d7														;1E2C0000
	swap	d7																	;4847
	move.b	$0001(a4),d7														;1E2C0001
	move.b	#$1F,$0005(a4)														;197C001F0005
	move.l	a4,-(sp)															;2F0C
	move.b	#$FF,adrB_00EE3E.l													;13FC00FF0000EE3E
	bsr		SpellEntity_CheckPlacement											;61003CDE
	move.l	(sp)+,a4															;285F
	rts																			;4E75

adrJA001664:		; Memory Address ($1664) and binary offset [$12E0]
	moveq	#$0C,d3																;760C
	moveq	#$0B,d0																;700B
	bra.s	adrCd001608															;609E

AttackType_NoSpells:		; Memory Address ($166A) and binary offset [$12E6]
	moveq	#-$01,d2															;74FF
	move.b	$0004(a4),d1														;122C0004
	cmp.b	adrB_00EED5.l,d1													;B2390000EED5
	bne.s	AttackType_ArcBoltMachine											;660C
	move.l	adrL_00EE98.l,d0													;20390000EE98
	move.l	d7,d1																;2207
	bsr		adrCd0013A8															;6100FD26
AttackType_ArcBoltMachine:		; Memory Address ($1684) and binary offset [$1300]
	move.w	d2,d3																;3602
	moveq	#-$01,d2															;74FF
	move.b	$0004(a4),d1														;122C0004
	cmp.b	adrB_00EF37.l,d1													;B2390000EF37
	bne.s	adrCd0016A0															;660C
	move.l	adrL_00EEFA.l,d0													;20390000EEFA
	move.l	d7,d1																;2207
	bsr		adrCd0013A8															;6100FD0A
adrCd0016A0:		; Memory Address ($16A0) and binary offset [$131C]
	moveq	#$00,d4																;7800
	tst.w	d2																	;4A42
	bmi.s	adrCd0016BE															;6B18
	move.l	a4,d0																;200C
	sub.l	#MonsterBlock_mod0,d0												;048000017584
	lsr.w	#$04,d0																;E848
	add.b	$000B(a4),d0														;D02C000B
	add.b	$0006(a4),d0														;D02C0006
	and.w	#$0001,d0															;02400001
	add.w	d0,d2																;D440
adrCd0016BE:		; Memory Address ($16BE) and binary offset [$133A]
	lea		ReserveSpace_1.l,a6													;4DF900058828
	cmp.w	d2,d3																;B642
	bcs.s	adrCd0016CE															;6506
	lea		ReserveSpace_2.l,a6													;4DF900058C10
adrCd0016CE:		; Memory Address ($16CE) and binary offset [$134A]
	move.w	d7,d0																;3007
	mulu	adrW_00EE70.l,d0													;C0F90000EE70
	swap	d7																	;4847
	add.w	d7,d0																;D047
	swap	d7																	;4847
	move.b	$00(a6,d0.w),d0														;10360000
	beq.s	AttackType_Drone													;6778
	cmpi.b	#$FF,d0																;0C0000FF
	beq.s	AttackType_Drone													;6772
	and.w	#$0003,d0															;02400003
	move.b	$02(a4,d4.w),d6														;1C344002
	and.w	#$0003,d6															;02460003
	cmp.w	d0,d6																;BC40
	beq.s	AttackType_Drone													;6762
	eor.w	d0,d6																;B146
	subq.w	#$02,d6																;5546
	beq		adrCd001BB8															;670004BA
	move.b	$02(a4,d4.w),d6														;1C344002
	bra		adrCd001BC6															;600004C0

adrCd001708:		; Memory Address ($1708) and binary offset [$1384]
	sub.b	#$84,d2																;04020084
	bcs.s	AttackType_Drone													;654C
	beq.s	adrCd001714															;6704
	subq.b	#$03,d2																;5702
	bne.s	AttackType_Drone													;6646
adrCd001714:		; Memory Address ($1714) and binary offset [$1390]
	not.w	d1																	;4641
	and.w	#$0007,d1															;02410007
	beq.s	adrCd001728															;670C
	cmpi.w	#$0007,d1															;0C410007
	bne.s	AttackType_Drone													;6638
	tst.b	$00(a6,d0.w)														;4A360000
	bne.s	AttackType_Drone													;6632
adrCd001728:		; Memory Address ($1728) and binary offset [$13A4]
	or.b	#$07,$01(a6,d0.w)													;003600070001
	moveq	#$00,d1																;7200
	move.b	$0006(a4),d1														;122C0006
	cmp.b	#$84,$000B(a4)														;0C2C0084000B
	bne.s	adrCd001746															;660A
	add.b	d1,d1																;D201
	cmpi.b	#$40,d1																;0C010040
	bcs.s	adrCd001746															;6502
	moveq	#$3F,d1																;723F
adrCd001746:		; Memory Address ($1746) and binary offset [$13C2]
	asl.b	#$02,d1																;E501
	addq.b	#$01,d1																;5201
	move.b	d1,$00(a6,d0.w)														;1D810000
	move.w	#$0100,d1															;323C0100
	move.b	$000C(a4),d1														;122C000C
	bsr		Formwall_PrepareLinkedFeature										;61003D66
AttackType_Drone:		; Memory Address ($175A) and binary offset [$13D6]
	move.b	$02(a4,d4.w),d6														;1C344002
	and.w	#$0003,d6															;02460003
	bsr		Compute_NewMapIndex_AI_TBC											;610062E0
	bcs		adrCd001AF0															;65000388
	cmpi.w	#$0000,d4															;0C440000
	bne.s	adrCd001778															;6608
	cmp.b	#$85,$000B(a4)														;0C2C0085000B
	beq.s	adrCd0017EE															;6776
adrCd001778:		; Memory Address ($1778) and binary offset [$13F4]
	move.b	d7,$01(a4,d4.w)														;19874001
	swap	d7																	;4847
	move.b	d7,$00(a4,d4.w)														;19874000
	swap	d7																	;4847
	bsr		adrCd001842															;610000BC
	and.w	#$0030,d0															;02400030
	bsr		adrCd001BCE															;61000440
	cmpi.b	#$00,d4																;0C040000
	bne.s	adrCd00179C															;6606
	tst.b	$000B(a4)															;4A2C000B
	bmi.s	adrCd0017EC															;6B50
adrCd00179C:		; Memory Address ($179C) and binary offset [$1418]
	bsr		CoordToMap															;61006CFE
	move.w	$00(a6,d0.w),d1														;32360000
	not.w	d1																	;4641
	and.w	#$0007,d1															;02410007
	bne.s	adrCd0017EC															;6640
	move.b	$00(a6,d0.w),d1														;12360000
	move.w	d1,d7																;3E01
	and.w	#$0003,d1															;02410003
	subq.b	#$01,d1																;5301
	bne.s	adrCd0017EC															;6632
	lea		adrEA0173F6.l,a0													;41F9000173F6
	moveq	#-$04,d1															;72FC
adrCd0017C2:		; Memory Address ($17C2) and binary offset [$143E]
	addq.w	#$04,d1																;5841
	cmp.w	-$0002(a0),d1														;B268FFFE
	bcc.s	adrCd0017EC															;6422
	cmp.w	$02(a0,d1.w),d0														;B0701002
	bne.s	adrCd0017C2															;66F2
	move.b	$01(a0,d1.w),adrB_00EE3E.l											;13F010010000EE3E
	lsr.b	#$02,d7																;E40F
	move.l	a4,-(sp)															;2F0C
	bsr		adrCd001E42															;61000664
	clr.w	adrW_0020F4.l														;4279000020F4
	bsr		adrCd00230C															;61000B24
	move.l	(sp)+,a4															;285F
adrCd0017EC:		; Memory Address ($17EC) and binary offset [$1468]
	rts																			;4E75

adrCd0017EE:		; Memory Address ($17EE) and binary offset [$146A]
	move.w	$00(a6,d0.w),d1														;32360000
	not.b	d1																	;4601
	and.w	#$0007,d1															;02410007
	bne.s	adrCd001808															;660E
	move.b	$00(a6,d0.w),d1														;12360000
	and.w	#$0003,d1															;02410003
	subq.w	#$01,d1																;5341
	beq		adrCd001778															;6700FF72
adrCd001808:		; Memory Address ($1808) and binary offset [$1484]
	move.w	$00(a6,d2.w),d1														;32362000
	not.b	d1																	;4601
	and.w	#$0007,d1															;02410007
	beq.s	adrCd00181E															;670A
	move.b	#$80,$000B(a4)														;197C0080000B
	bra		adrCd001778															;6000FF5C

adrCd00181E:		; Memory Address ($181E) and binary offset [$149A]
	bclr	#$07,$01(a6,d0.w)													;08B600070001
	bset	#$07,$01(a6,d2.w)													;08F600072001
	eor.b	#$02,$0002(a4)														;0A2C00020002
	rts																			;4E75

Monster_Movement_DataTable:		; Memory Address ($1832) and binary offset [$14AE]
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

adrCd001842:		; Memory Address ($1842) and binary offset [$14BE]
	moveq	#$00,d6																;7C00
	move.b	$02(a4,d4.w),d6														;1C344002
	move.w	d6,d0																;3006
	and.w	#$0003,d6															;02460003
	move.w	d6,d2																;3406
	asl.w	#$02,d2																;E542
	lsr.w	#$04,d0																;E848
	add.w	d0,d2																;D440
	move.b	Monster_Movement_DataTable(pc,d2.w),d0								;103B20DA
	rts																			;4E75

adrCd00185C:		; Memory Address ($185C) and binary offset [$14D8]
	clr.w	PhysicalAttack_DoubleDefenceFlag.l									;427900006458
	jsr		adrCd0098A4.l														;4EB9000098A4
	bcc		adrCd001BB8															;6400034E
	tst.b	d0																	;4A00
	bmi		adrCd001AB6															;6B000246
	cmpi.b	#$10,d0																;0C000010
	bcs		CheckMonsterHeldObject												;6500010A
	move.b	$000B(a4),d2														;142C000B
	bmi		CheckMonsterHeldObject												;6B000102
	cmpi.b	#$64,d2																;0C020064
	bne.s	adrCd001894															;660C
	move.b	$000C(a4),adrB_00EE3E.l												;13EC000C0000EE3E
	bra		CheckMonsterHeldObject												;600000F0

adrCd001894:		; Memory Address ($1894) and binary offset [$1510]
	cmp.b	#$64,$000B(a1)														;0C290064000B
	beq		CheckMonsterHeldObject												;670000E6
	cmpi.b	#$40,d2																;0C020040
	beq		adrCd001BB8															;67000314
	cmpi.b	#$67,d2																;0C020067
	bcc		adrCd001BB8															;6400030C
	move.b	$000B(a1),d2														;1429000B
	bpl.s	adrCd0018F6															;6A42
	cmpi.b	#$85,d2																;0C020085
	bne		adrCd001BB8															;660002FE
	move.l	a4,-(sp)															;2F0C
	moveq	#$00,d7																;7E00
	move.b	$0000(a4),d7														;1E2C0000
	swap	d7																	;4847
	move.b	$0001(a4),d7														;1E2C0001
	bsr		CoordToMap															;61006BD0
	bclr	#$07,$01(a6,d0.w)													;08B600070001
	moveq	#$00,d7																;7E00
	move.b	$0000(a1),d7														;1E290000
	move.b	d7,$0000(a4)														;19470000
	swap	d7																	;4847
	move.b	$0001(a1),d7														;1E290001
	move.b	d7,$0001(a4)														;19470001
	bsr		CoordToMap															;61006BB2
	move.l	a1,a4																;2849
	bsr		CheckEquipCostsAndAttrs_AI_TBC										;61000468
	move.l	(sp)+,a4															;285F
	rts																			;4E75

adrCd0018F6:		; Memory Address ($18F6) and binary offset [$1572]
	cmpi.b	#$40,d2																;0C020040
	beq		adrCd001BB8															;670002BC
	cmpi.b	#$67,d2																;0C020067
	bcc		adrCd001BB8															;640002B4
	tst.b	$000D(a4)															;4A2C000D
	bpl		adrCd001BB8															;6A0002AC
	moveq	#$00,d3																;7600
	move.b	$000D(a1),d3														;1629000D
	bpl.s	adrCd00193C															;6A26
	lea		MonsterTeamIndexTable.l,a0											;41F900017390
	addq.w	#$01,-$0002(a0)														;5268FFFE
	move.w	-$0002(a0),d3														;3628FFFE
	move.b	d3,$000D(a1)														;1343000D
	asl.w	#$02,d3																;E543
	sub.w	#$0010,d0															;04400010
	move.l	#$FFFFFFFF,$00(a0,d3.w)												;21BCFFFFFFFF3000
	move.b	d0,$00(a0,d3.w)														;11803000
	lsr.w	#$02,d3																;E44B
adrCd00193C:		; Memory Address ($193C) and binary offset [$15B8]
	asl.w	#$02,d3																;E543
	lea		MonsterTeamIndexTable.l,a0											;41F900017390
	add.w	d3,a0																;D0C3
	moveq	#$03,d2																;7403
adrLp001948:		; Memory Address ($1948) and binary offset [$15C4]
	tst.b	$00(a0,d2.w)														;4A302000
	bmi.s	adrCd001956															;6B08
	dbra	d2,adrLp001948														;51CAFFF8
	bra		adrCd001BB8															;60000264

adrCd001956:		; Memory Address ($1956) and binary offset [$15D2]
	move.l	a4,d0																;200C
	sub.l	#UnpackedMonsters,d0												;048000016B7E
	lsr.w	#$04,d0																;E848
	move.b	d0,$00(a0,d2.w)														;11802000
	moveq	#$00,d7																;7E00
	move.b	$0000(a4),d7														;1E2C0000
	swap	d7																	;4847
	move.b	$0001(a4),d7														;1E2C0001
	move.b	#$FF,$0000(a4)														;197C00FF0000
	bsr		CoordToMap															;61006B24
	bclr	#$07,$01(a6,d0.w)													;08B600070001
	rts																			;4E75

CheckMonsterHeldObject:		; Memory Address ($1982) and binary offset [$15FE]
	; Checks whether a monster form and carried object require held-object
	; processing.
	move.w	d0,d1																;Copies the caller's interaction/level value into d1 because d0 is reused for monster-form tests.
CheckMonsterHeldObjectByLevel:		; Memory Address ($1984) and binary offset [$1600]
	; Continues held-object processing using the current interaction or level
	; threshold.
	move.b	MonsterRecord_Form(a4),d0											;Loads the live monster form/graphic identifier into d0.
	bpl		adrCd001A4A															;Skips special held-object processing for a non-negative, ordinary monster form.
	cmpi.b	#$10,d1																;Checks whether the caller's level or interaction value is below the special-processing threshold $10.
	bcs.s	adrCd00199C															;Enters the carried-object resolution path for values below the threshold.
	tst.b	MonsterRecord_CarriedObject(a4)										;Tests whether the monster's carried-object byte is negative, meaning no object has been assigned.
	bpl		adrCd001A4A															;Skips special held-object processing for a non-negative, ordinary monster form.
	rts																			;Returns without changing the monster when no special held-object action is required.

adrCd00199C:		; Memory Address ($199C) and binary offset [$1618]
	movem.l	d1/a5,-(sp)															;Saves d1 and a5 while the object/character lookup routines temporarily reuse them.
	move.w	d1,d0																;Passes the interaction/level value to the lookup routine in its expected argument register d0.
	bsr		adrCd004066															;Resolves the current interaction or level against the supporting object/character lookup data.
	tst.w	d1																	;Tests whether the lookup returned a valid result in d1.
	bmi.s	adrCd0019C2															;Falls back to the alternate result path when the first lookup failed.
	moveq	#$01,d1																;Selects the standard lookup variant used to resolve the monster's special interaction.
	move.l	a4,-(sp)															;Saves the live monster pointer before the lookup routine changes a4.
	bsr		adrCd005500															;Performs the special object/character lookup using the selected interaction value.
	move.l	(sp)+,a4															;Restores a4 so subsequent field accesses again address the live monster record.
	tst.w	d3																	;Tests the secondary lookup result returned in d3.
	bmi.s	adrCd0019C2															;Falls back to the alternate result path when the first lookup failed.
	swap	d3																	;Swaps d3 so the resolved result word is available to the common path.
	movem.l	(sp)+,d1/a5															;Restores the saved interaction value and player pointer registers.
	move.w	d3,d1																;Copies the resolved interaction/character index into d1 for champion-record selection.
	bra.s	adrCd0019C6															;Branches to the common champion-record processing path.

adrCd0019C2:		; Memory Address ($19C2) and binary offset [$163E]
	movem.l	(sp)+,d1/a5															;Restores the saved interaction value and player pointer after the fallback lookup path.
adrCd0019C6:		; Memory Address ($19C6) and binary offset [$1642]
	move.w	d1,d0																;Copies the selected champion/interaction index into d0 for record loading.
	move.l	a4,a2																;Preserves the live monster pointer in a2 while a4 is temporarily used for the champion record.
	bsr		Load_ChampionStatRecord												;Loads the selected champion's stat record into a4.
	exg		a4,a2																;Swaps a4 and a2 so a4 again addresses the monster and a2 addresses the selected champion.
	move.b	$0011(a2),d0														;Reads the selected champion's worn-spell field.
	and.w	#$0007,d0															;Masks the spell field to its low three-bit spell code.
	subq.w	#$01,d0																;Normalises the spell code around the first spell entry before testing the required spell.
	bne.s	adrCd001A4A															;Skips the special action when the selected champion is not wearing the required spell.
	move.b	#$01,$0011(a2)														;Sets the selected champion's worn-spell field to the required spell code.
	moveq	#$00,d7																;Clears d7 before assembling the monster's map coordinate.
	move.b	$0000(a4),d7														;Loads the monster X coordinate into the high-byte staging register d7.
	swap	d7																	;Moves the X coordinate into the high word so Y can be appended.
	move.b	$0001(a4),d7														;Loads the monster Y coordinate into the low byte of d7.
	bsr		CoordToMap															;Converts the monster coordinate into the current-map cell index.
	tst.b	$01(a6,d0.w)														;Tests the map cell's occupancy/visibility byte before attempting the special action.
	bpl.s	adrCd001A06															;Continues when the target map cell is available for the action.
	move.w	d1,-(sp)															;Saves the resolved interaction/level value while checking the map cell occupant.
	bsr		adrCd0098A4															;Checks the selected map cell for an occupying character or monster.
	move.w	(sp)+,d1															;Restores the resolved interaction/level value after the occupancy check.
	tst.b	d0																	;Tests the occupancy result returned in d0.
	bmi		adrCd001A4A															;Aborts the special action when the map-cell check reports a blocking occupant.
adrCd001A06:		; Memory Address ($1A06) and binary offset [$1682]
	moveq	#$00,d4																;Clears d4 before loading the monster form used by the movement/render calculation.
	move.b	$000B(a4),d4														;Loads the monster form/graphic identifier for downstream movement or effect selection.
	move.b	$0002(a4),d0														;Loads the live rotation/occupied-space byte into d0.
	and.w	#$0003,d0															;Masks d0 to the four facing/space variants represented by the low two bits.
	lea		MovementOffsetTable.l,a0											;Loads the four-direction movement offset table.
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
	move.b	d1,adrB_00EE3E.l													;Stores the resolved level/index value in the shared special-object scratch byte.
	bra		SpellEntity_CheckPlacement											;Branches to the common special-object handling routine with the prepared registers.

adrCd001A4A:		; Memory Address ($1A4A) and binary offset [$16C6]
	moveq	#$00,d3																;7600
	move.b	$000D(a4),d3														;162C000D
	bmi.s	adrCd001A84															;6B32
	move.l	a4,-(sp)															;2F0C
	asl.w	#$02,d3																;E543
	lea		MonsterTeamIndexTable.l,a0											;41F900017390
	add.w	d3,a0																;D0C3
	moveq	#$01,d0																;7001
adrLp001A60:		; Memory Address ($1A60) and binary offset [$16DC]
	moveq	#$00,d3																;7600
	move.b	$00(a0,d0.w),d3														;16300000
	bmi.s	adrCd001A7C															;6B14
	movem.l	d0/d1/a0,-(sp)														;48E7C080
	lea		UnpackedMonsters.l,a4												;49F900016B7E
	asl.w	#$04,d3																;E943
	add.w	d3,a4																;D8C3
	bsr.s	adrCd001A84															;610C
	movem.l	(sp)+,d0/d1/a0														;4CDF0103
adrCd001A7C:		; Memory Address ($1A7C) and binary offset [$16F8]
	dbra	d0,adrLp001A60														;51C8FFE2
	move.l	(sp)+,a4															;285F
	rts																			;4E75

adrCd001A84:		; Memory Address ($1A84) and binary offset [$1700]
	move.l	a4,d3																;260C
	sub.l	#UnpackedMonsters,d3												;048300016B7E
	lsr.w	#$04,d3																;E84B
	add.w	#$0010,d3															;06430010
	move.b	#$07,$0005(a4)														;197C00070005
	move.l	a4,-(sp)															;2F0C
	move.w	d1,-(sp)															;3F01
	move.w	#$FFFF,PhysicalAttack_BackstabState.l								;33FCFFFF0000628A
	bsr		Resolve_PhysicalAttack												;61004734
	move.w	(sp)+,d0															;301F
	move.w	$0000(a6),d5														;3A2E0000
	bsr		adrCd002298															;610007E8
	move.l	(sp)+,a4															;285F
	rts																			;4E75

adrCd001AB6:		; Memory Address ($1AB6) and binary offset [$1732]
	bsr		RandomGen_BytewithOffset											;61003AF4
	move.w	d0,d2																;3400
	and.w	#$0001,d2															;02420001
	moveq	#$00,d0																;7000
	move.b	$0002(a4),d0														;102C0002
	bsr		adrCd006018															;61004550
	tst.b	$000B(a4)															;4A2C000B
	bpl		CheckMonsterHeldObjectByLevel										;6A00FEB4
	movem.l	d0/d1/a5,-(sp)														;48E7C004
	move.l	a1,a5																;2A49
	move.w	d1,d0																;3001
	bsr		adrCd004078															;6100259C
	bclr	d1,$003C(a5)														;03AD003C
	clr.w	PhysicalAttack_DoubleDefenceFlag.l									;427900006458
	movem.l	(sp)+,d0/d1/a5														;4CDF2003
	bra		CheckMonsterHeldObjectByLevel										;6000FE96

adrCd001AF0:		; Memory Address ($1AF0) and binary offset [$176C]
	move.w	adrW_0013C2.w,d1													;323813C2	;Short Absolute converted to symbol!
	cmp.b	adrB_00EEB1.l,d1													;B2390000EEB1
	beq		adrCd001BD4															;670000D8
	cmp.b	adrB_00EF13.l,d1													;B2390000EF13
	beq		adrCd001BD4															;670000CE
	cmpi.w	#$0000,d4															;0C440000
	beq.s	adrCd001B74															;6766
	tst.w	adrW_0013C4.w														;4A7813C4	;Short Absolute converted to symbol!
	beq		adrCd001BB8															;670000A4
	movem.w	d0/d2,-(sp)															;48A7A000
	bsr		adrCd0098A4															;61007D88
	movem.w	(sp)+,d1/d2															;4C9F0006
	tst.b	d0																	;4A00
	bpl		adrCd001BB8															;6A000092
	cmp.l	a1,a5																;BBC9
	bne		adrCd001BB8															;6600008C
	bclr	#$07,$01(a6,d2.w)													;08B600072001
	move.l	a4,d0																;200C
	sub.l	#Character_Stats_DataTable,d0										;04800000EB2A
	lsr.w	#$05,d0																;EA48
	bsr		adrCd004078															;61002538
	bclr	#$05,$18(a5,d1.w)													;08B500051018
	move.b	d0,$0034(a5)														;1B400034
	cmp.b	$0053(a5),d0														;B02D0053
	bne.s	adrCd001B5C															;660A
	move.b	#$FF,$0053(a5)														;1B7C00FF0053
	clr.b	$0014(a5)															;422D0014
adrCd001B5C:		; Memory Address ($1B5C) and binary offset [$17D8]
	moveq	#$03,d7																;7E03
adrLp001B5E:		; Memory Address ($1B5E) and binary offset [$17DA]
	tst.b	$26(a5,d7.w)														;4A357026
	bmi.s	adrCd001B68															;6B04
	dbra	d7,adrLp001B5E														;51CFFFF8
adrCd001B68:		; Memory Address ($1B68) and binary offset [$17E4]
	move.b	d0,$26(a5,d7.w)														;1B807026
	move.b	#$FF,$0016(a4)														;197C00FF0016
	rts																			;4E75

adrCd001B74:		; Memory Address ($1B74) and binary offset [$17F0]
	tst.b	$000B(a4)															;4A2C000B
	bmi		EquipStateOrArmorHandler_AI_TBC										;6B000182
	cmp.b	#$15,$000B(a4)														;0C2C0015000B
	beq.s	adrCd001BB8															;6734
	cmp.b	#$16,$000B(a4)														;0C2C0016000B
	beq.s	adrCd001BB8															;672C
	cmp.w	d2,d0																;B042
	bne.s	adrCd001BA0															;6610
	move.w	$00(a6,d0.w),d1														;32360000
	and.w	#$0007,d1															;02410007
	subq.w	#$02,d1																;5541
	bne		adrCd001C02															;66000066
	bra.s	adrCd001BD6															;6036

adrCd001BA0:		; Memory Address ($1BA0) and binary offset [$181C]
	move.b	$01(a6,d0.w),d2														;14360001
	bpl.s	adrCd001BB8															;6A12
	move.b	#$FF,adrB_00EE3E.l													;13FC00FF0000EE3E
	and.w	#$0007,d2															;02420007
	subq.w	#$01,d2																;5342
	bne		adrCd00185C															;6600FCA6
adrCd001BB8:		; Memory Address ($1BB8) and binary offset [$1834]
	bsr		RandomGen_BytewithOffset											;610039F2
	or.w	#$0001,d0															;00400001
	move.b	$02(a4,d4.w),d6														;1C344002
	add.w	d6,d0																;D046
adrCd001BC6:		; Memory Address ($1BC6) and binary offset [$1842]
	and.w	#$0003,d0															;02400003
	and.w	#$00F0,d6															;024600F0
adrCd001BCE:		; Memory Address ($1BCE) and binary offset [$184A]
	or.b	d6,d0																;8006
	move.b	d0,$02(a4,d4.w)														;19804002
adrCd001BD4:		; Memory Address ($1BD4) and binary offset [$1850]
	rts																			;4E75

adrCd001BD6:		; Memory Address ($1BD6) and binary offset [$1852]
	move.b	$0002(a4),d6														;1C2C0002
	and.w	#$0003,d6															;02460003
	move.b	$00(a6,d0.w),d1														;12360000
	add.w	d6,d6																;DC46
	addq.w	#$01,d6																;5246
	btst	d6,$00(a6,d0.w)														;0D360000
	beq.s	adrCd001C02															;6716
	subq.w	#$01,d6																;5346
	btst	d6,$00(a6,d0.w)														;0D360000
	beq.s	adrCd001C02															;670E
	btst	#$04,$01(a6,d0.w)													;083600040001
	bne.s	adrCd001BB8															;66BC
	bclr	d6,$00(a6,d0.w)														;0DB60000
	rts																			;4E75

adrCd001C02:		; Memory Address ($1C02) and binary offset [$187E]
	moveq	#$00,d7																;7E00
	move.b	$0000(a4),d7														;1E2C0000
	swap	d7																	;4847
	move.b	$0001(a4),d7														;1E2C0001
	move.b	$0002(a4),d0														;102C0002
	and.w	#$0003,d0															;02400003
	move.w	d0,d6																;3C00
	bsr		adrCd008486															;6100686C
	move.w	$00(a6,d0.w),d1														;32360000
	and.w	#$0007,d1															;02410007
	subq.w	#$02,d1																;5541
	bne.s	adrCd001BB8															;6690
	btst	#$04,$01(a6,d0.w)													;083600040001
	bne.s	adrCd001BB8															;6688
	eor.b	#$02,d6																;0A060002
	add.w	d6,d6																;DC46
	addq.w	#$01,d6																;5246
	btst	d6,$00(a6,d0.w)														;0D360000
	beq		adrCd001BB8															;6700FF7A
	subq.w	#$01,d6																;5346
	bclr	d6,$00(a6,d0.w)														;0DB60000
	rts																			;4E75

adrCd001C48:		; Memory Address ($1C48) and binary offset [$18C4]
	cmp.w	d0,d2																;B440
	bne		adrCd001C86															;6600003A
adrCd001C4E:		; Memory Address ($1C4E) and binary offset [$18CA]
	move.b	$0002(a4),d6														;1C2C0002
	and.w	#$0003,d6															;02460003
	cmpi.w	#$0002,d6															;0C460002
	bcs.s	adrCd001C60															;6504
	eor.w	#$0001,d6															;0A460001
adrCd001C60:		; Memory Address ($1C60) and binary offset [$18DC]
	moveq	#$00,d1																;7200
	move.b	$000B(a4),d1														;122C000B
	sub.b	#$85,d1																;04010085
	movem.w	d0/d1/d6,-(sp)														;48A7C200
	bsr		adrCd0027E0															;61000B70
	movem.w	(sp)+,d0/d1/d6														;4C9F0043
	cmpi.w	#$0005,d1															;0C410005
	beq.s	adrCd001CD2															;6756
	moveq	#$01,d5																;7A01
	swap	d5																	;4845
	move.w	d1,d5																;3A01
	bra		adrCd005E88															;60004204

adrCd001C86:		; Memory Address ($1C86) and binary offset [$1902]
	moveq	#$00,d7																;7E00
	move.b	$000B(a4),d7														;1E2C000B
	bsr		adrCd001DBC															;6100012E
	tst.b	$01(a6,d0.w)														;4A360001
	bmi.s	adrCd001C9E															;6B08
	eor.b	#$02,$0002(a4)														;0A2C00020002
	bra.s	adrCd001C4E															;60B0

adrCd001C9E:		; Memory Address ($1C9E) and binary offset [$191A]
	movem.l	a4/a5,-(sp)															;48E7000C
	lea		adrEA01737E.l,a0													;41F90001737E
	moveq	#$03,d1																;7203
adrLp001CAA:		; Memory Address ($1CAA) and binary offset [$1926]
	move.l	(a4)+,(a0)+															;20DC
	dbra	d1,adrLp001CAA														;51C9FFFC
	sub.w	#$0010,a4															;98FC0010
	move.w	d0,d4																;3800
	bsr		adrCd0027E0															;61000B28
	move.w	d4,d0																;3004
	lea		adrEA01737E.l,a4													;49F90001737E
	move.b	$000C(a4),adrB_00EE3E.l												;13EC000C0000EE3E
	bsr		adrCd00185C															;6100FB90
	movem.l	(sp)+,a4/a5															;4CDF3000
adrCd001CD2:		; Memory Address ($1CD2) and binary offset [$194E]
	rts																			;4E75

HandleArmorSubroutine_AI_TBC:		; Memory Address ($1CD4) and binary offset [$1950]
	bsr		adrCd001BB8															;6100FEE2
	move.w	d0,d6																;3C00
	and.w	#$0003,d6															;02460003
	bsr		Compute_NewMapIndex_AI_TBC											;61005D64
	bcs.s	CheckAndToggleProcessedFlag_AI_TBC									;650C
	move.b	d7,$0001(a4)														;19470001
	swap	d7																	;4847
	move.b	d7,$0000(a4)														;19470000
	rts																			;4E75

CheckAndToggleProcessedFlag_AI_TBC:		; Memory Address ($1CF0) and binary offset [$196C]
	cmp.w	d0,d2																;B440
	bne.s	EquipStateOrArmorHandler_AI_TBC										;6608
	eor.b	#$02,$0002(a4)														;0A2C00020002
	rts																			;4E75

EquipStateOrArmorHandler_AI_TBC:		; Memory Address ($1CFC) and binary offset [$1978]
	cmp.b	#$84,$000B(a4)														;0C2C0084000B
	bne.s	CompareLastBlockedVSEquipCode_AI_TBC								;661A
	move.b	#$85,$000B(a4)														;197C0085000B
	move.b	$0006(a4),d1														;122C0006
	addq.w	#$04,d1																;5841
	asl.w	#$02,d1																;E541
	move.b	d1,$0006(a4)														;19410006
ClearOrTogglePlayerBit_AI_TBC:		; Memory Address ($1D16) and binary offset [$1992]
	eor.b	#$02,$0002(a4)														;0A2C00020002
	rts																			;4E75

CompareLastBlockedVSEquipCode_AI_TBC:		; Memory Address ($1D1E) and binary offset [$199A]
	cmp.w	d2,d0																;B042
	bne.s	EquipOrArmorDecisionLoop_AI_TBC										;6610
	cmp.b	#$85,$000B(a4)														;0C2C0085000B
	beq.s	ClearOrTogglePlayerBit_AI_TBC										;67EC
	cmp.b	#$82,$000B(a4)														;0C2C0082000B
	beq.s	HandleArmorSubroutine_AI_TBC										;67A2
EquipOrArmorDecisionLoop_AI_TBC:		; Memory Address ($1D32) and binary offset [$19AE]
	cmp.b	#$85,$000B(a4)														;0C2C0085000B
	bne.s	MarkMapCellProcessedFlag_AI_TBC										;6618
	move.w	$00(a6,d0.w),d1														;32360000
	not.b	d1																	;4601
	and.w	#$0007,d1															;02410007
	bne.s	ClearOrTogglePlayerBit_AI_TBC										;66D0
	move.b	$00(a6,d0.w),d1														;12360000
	and.w	#$0003,d1															;02410003
	subq.w	#$01,d1																;5341
	bne.s	ClearOrTogglePlayerBit_AI_TBC										;66C4
MarkMapCellProcessedFlag_AI_TBC:		; Memory Address ($1D52) and binary offset [$19CE]
	bclr	#$07,$01(a6,d2.w)													;08B600072001
CheckEquipCostsAndAttrs_AI_TBC:		; Memory Address ($1D58) and binary offset [$19D4]
	cmp.b	#$88,$000B(a4)														;0C2C0088000B
	bcs.s	ClampEquipOrTeleportCode_AI_TBC										;650A
	cmp.b	#$8B,$000B(a4)														;0C2C008B000B
	bcs		adrCd001C48															;6500FEE0
ClampEquipOrTeleportCode_AI_TBC:		; Memory Address ($1D6A) and binary offset [$19E6]
	moveq	#$00,d7																;7E00
	move.b	$0006(a4),d7														;1E2C0006
	swap	d7																	;4847
	move.b	$000B(a4),d7														;1E2C000B
	bmi.s	PrepareTeleportOrEquipValue_AI_TBC									;6B02
	clr.w	d7																	;4247
PrepareTeleportOrEquipValue_AI_TBC:		; Memory Address ($1D7A) and binary offset [$19F6]
	moveq	#$00,d1																;7200
	move.b	$0004(a4),d1														;122C0004
	move.w	d0,d4																;3800
	move.b	$000C(a4),adrB_00EE3E.l												;13EC000C0000EE3E
	bmi.s	adrCd001DAA															;6B1E
	movem.l	d0/a0,-(sp)															;48E78080
	cmpi.b	#$83,d7																;0C070083
	beq.s	adrCd001D9E															;6708
	moveq	#$04,d0																;7004
	cmpi.b	#$8B,d7																;0C07008B
	bcs.s	adrCd001DA0															;6502
adrCd001D9E:		; Memory Address ($1D9E) and binary offset [$1A1A]
	moveq	#Sound_AlternativeSpell,d0											;7005
adrCd001DA0:		; Memory Address ($1DA0) and binary offset [$1A1C]
	jsr		PlaySound.l															;4EB9000088BE
	movem.l	(sp)+,d0/a0															;4CDF0101
adrCd001DAA:		; Memory Address ($1DAA) and binary offset [$1A26]
	bsr		adrCd0027E0															;61000A34
	move.w	d4,d0																;3004
	move.l	a4,-(sp)															;2F0C
	bsr.s	adrCd001DE0															;612C
	move.l	(sp)+,a4															;285F
	sub.w	#$0010,a4															;98FC0010
adrCd001DBA:		; Memory Address ($1DBA) and binary offset [$1A36]
	rts																			;4E75

adrCd001DBC:		; Memory Address ($1DBC) and binary offset [$1A38]
	bset	#$05,$01(a6,d0.w)													;08F600050001
	asl.b	#$02,d7																;E507
	addq.w	#$02,d7																;5447
	lea		adrEA0174F8.l,a0													;41F9000174F8
	move.w	-$0002(a0),d2														;3428FFFE
	addq.w	#$01,-$0002(a0)														;5268FFFE
	asl.w	#$02,d2																;E542
	move.w	d0,$00(a0,d2.w)														;31802000
	move.w	d7,$02(a0,d2.w)														;31872002
	rts																			;4E75

adrCd001DE0:		; Memory Address ($1DE0) and binary offset [$1A5C]
	bsr.s	adrCd001DBC															;61DA
	swap	d7																	;4847
	move.b	$01(a6,d0.w),d5														;1A360001
	bpl.s	adrCd001DBA															;6AD0
	and.w	#$0007,d5															;02450007
	subq.w	#$01,d5																;5345
	beq.s	adrCd001DBA															;67C8
	movem.l	d0-d7/a0-a6,-(sp)													;48E7FFFE
	bsr		adrCd0098A4															;61007AAC
	bcs.s	adrCd001E08															;650C
	movem.l	(sp)+,d0-d7/a0-a6													;4CDF7FFF
	bclr	#$07,$01(a6,d0.w)													;08B600070001
	bra.s	adrCd001DBA															;60B2

adrCd001E08:		; Memory Address ($1E08) and binary offset [$1A84]
	tst.b	d0																	;4A00
	bpl.s	adrCd001E28															;6A1C
	swap	d7																	;4847
	move.b	d7,d5																;1A07
	swap	d7																	;4847
	lsr.b	#$02,d5																;E40D
	cmpi.b	#$03,d5																;0C050003
	beq.s	adrCd001E28															;670E
	cmpi.b	#$0B,d5																;0C05000B
	bcc.s	adrCd001E28															;6408
	moveq	#Sound_SpellRoar,d0													;7004
	jsr		PlaySound.l															;4EB9000088BE
adrCd001E28:		; Memory Address ($1E28) and binary offset [$1AA4]
	movem.l	(sp)+,d0-d7/a0-a6													;4CDF7FFF
	move.b	d7,d5																;1A07
	and.w	#$007F,d5															;0245007F
	move.w	d5,adrW_0020F4.l													;33C5000020F4
	tst.b	d7																	;4A07
	bmi.s	adrCd001E84															;6B48
	bsr.s	adrCd001E42															;6104
	bra		adrCd00230C															;600004CC

adrCd001E42:		; Memory Address ($1E42) and binary offset [$1ABE]
	move.w	#$FFFF,adrW_00230A.l												;33FCFFFF0000230A
	move.w	d0,-(sp)															;3F00
	move.w	d7,d5																;3A07
	addq.w	#$01,d5																;5245
adrLp001E50:		; Memory Address ($1E50) and binary offset [$1ACC]
	bsr		adrCd005556															;61003704
	add.w	d0,d5																;DA40
	dbra	d7,adrLp001E50														;51CFFFF8
	move.w	(sp)+,d0															;301F
	move.w	d5,-(sp)															;3F05
	cmpi.w	#$0100,d5															;0C450100
	bcs.s	adrCd001E68															;6504
	move.w	#$00FD,d5															;3A3C00FD
adrCd001E68:		; Memory Address ($1E68) and binary offset [$1AE4]
	moveq	#$03,d1																;7203
	lea		adrEA002680.l,a0													;41F900002680
adrLp001E70:		; Memory Address ($1E70) and binary offset [$1AEC]
	move.b	d5,$00(a0,d1.w)														;11851000
	dbra	d1,adrLp001E70														;51C9FFFA
	move.w	(sp)+,d5															;3A1F
	swap	d5																	;4845
	move.w	#$FFFF,d5															;3A3CFFFF
	swap	d5																	;4845
	rts																			;4E75

adrCd001E84:		; Memory Address ($1E84) and binary offset [$1B00]
	swap	d7																	;4847
	lsr.b	#$02,d7																;E40F
	cmpi.b	#$03,d7																;0C070003
	beq		adrCd001FD2															;67000144
	cmpi.b	#$0B,d7																;0C07000B
	beq		adrCd002086															;670001F0
	cmpi.b	#$0C,d7																;0C07000C
	beq		adrCd001F78															;670000DA
	cmpi.b	#$0F,d7																;0C07000F
	beq		adrCd001F4A															;670000A4
	cmpi.b	#$0E,d7																;0C07000E
	beq.s	adrCd001EB0															;6702
	rts																			;4E75

adrCd001EB0:		; Memory Address ($1EB0) and binary offset [$1B2C]
	bsr		adrCd0098A4															;610079F2
	bcc.s	adrCd001EDA															;6424
	tst.b	d0																	;4A00
	bmi.s	adrCd001F0C															;6B52
	cmpi.b	#$10,d0																;0C000010
	bcs.s	adrCd001EDC															;651C
	move.b	$0007(a1),d5														;1A290007
	and.b	#$7F,d5																;0205007F
	lsr.b	#$01,d5																;E20D
	move.b	d5,$0007(a1)														;13450007
	bsr		adrCd0020F6															;61000226
	tst.w	d5																	;4A45
	beq.s	adrCd001EDA															;6704
	clr.b	$0007(a1)															;42290007
adrCd001EDA:		; Memory Address ($1EDA) and binary offset [$1B56]
	rts																			;4E75

adrCd001EDC:		; Memory Address ($1EDC) and binary offset [$1B58]
	clr.b	$0011(a1)															;42290011
	move.w	adrW_0020F4.l,d5													;3A39000020F4
	bsr		adrCd0020F8															;61000210
	move.b	$0009(a1),d1														;12290009
	sub.b	d5,d1																;9205
	bcc.s	adrCd001EF4															;6402
	moveq	#$00,d1																;7200
adrCd001EF4:		; Memory Address ($1EF4) and binary offset [$1B70]
	move.b	d1,$0009(a1)														;13410009
	move.b	$0015(a1),d1														;12290015
	add.b	d5,d1																;D205
	cmpi.b	#$64,d1																;0C010064
	bcs.s	adrCd001F06															;6502
	moveq	#$64,d1																;7264
adrCd001F06:		; Memory Address ($1F06) and binary offset [$1B82]
	move.b	d1,$0015(a1)														;13410015
	rts																			;4E75

adrCd001F0C:		; Memory Address ($1F0C) and binary offset [$1B88]
	moveq	#$03,d7																;7E03
	moveq	#$05,d0																;7005
	jsr		PlaySound.l															;4EB9000088BE
adrLp001F16:		; Memory Address ($1F16) and binary offset [$1B92]
	moveq	#$00,d0																;7000
	move.b	$18(a1,d7.w),d0														;10317018
	move.w	d0,d1																;3200
	and.w	#$00E0,d0															;024000E0
	bne.s	adrCd001F36															;6612
	and.w	#$000F,d1															;0241000F
	move.w	d1,d0																;3001
	bsr		Load_ChampionStatRecord												;61004734
	move.w	d1,d0																;3001
	exg		a1,a4																;C949
	bsr.s	adrCd001EDC															;61A8
	exg		a1,a4																;C949
adrCd001F36:		; Memory Address ($1F36) and binary offset [$1BB2]
	dbra	d7,adrLp001F16														;51CFFFDE
	move.l	a5,-(sp)															;2F0D
	move.l	a1,a5																;2A49
	bsr		Draw_PartyCommandInterface											;61005C10
	bsr		Load_MapPosition_AI_TBC												;6100628A
	move.l	(sp)+,a5															;2A5F
	rts																			;4E75

adrCd001F4A:		; Memory Address ($1F4A) and binary offset [$1BC6]
	bsr		adrCd0098A4															;61007958
	bcc.s	adrCd001F76															;6426
adrCd001F50:		; Memory Address ($1F50) and binary offset [$1BCC]
	moveq	#$19,d4																;7819
	tst.b	d0																	;4A00
	bmi.s	adrCd001F76															;6B20
	cmpi.b	#$10,d0																;0C000010
	bcs.s	adrCd001F5E															;6502
	moveq	#$03,d4																;7803
adrCd001F5E:		; Memory Address ($1F5E) and binary offset [$1BDA]
	and.b	#$F0,$00(a1,d4.w)													;023100F04000
	bsr		adrCd00208C															;61000126
	bclr	#$06,$03(a1,d4.w)													;08B100064003
	beq.s	adrCd001F76															;6706
	bset	#$05,$03(a1,d4.w)													;08F100054003
adrCd001F76:		; Memory Address ($1F76) and binary offset [$1BF2]
	rts																			;4E75

adrCd001F78:		; Memory Address ($1F78) and binary offset [$1BF4]
	bsr		adrCd0098A4															;6100792A
	bcc.s	adrCd001FA0															;6422
	moveq	#$16,d4																;7816
	tst.b	d0																	;4A00
	bmi.s	adrCd001FA2															;6B1E
	cmpi.b	#$10,d0																;0C000010
	bcs.s	adrCd001F8C															;6502
	moveq	#$00,d4																;7800
adrCd001F8C:		; Memory Address ($1F8C) and binary offset [$1C08]
	bsr		adrCd0020F6															;61000168
	tst.w	d5																	;4A45
	beq.s	adrCd001FA0															;670C
	bset	#$07,$05(a1,d4.w)													;08F100074005
	or.b	#$0F,$03(a1,d4.w)													;0031000F4003
adrCd001FA0:		; Memory Address ($1FA0) and binary offset [$1C1C]
	rts																			;4E75

adrCd001FA2:		; Memory Address ($1FA2) and binary offset [$1C1E]
	moveq	#$03,d7																;7E03
	moveq	#$05,d0																;7005
	jsr		PlaySound.l															;4EB9000088BE
adrLp001FAC:		; Memory Address ($1FAC) and binary offset [$1C28]
	moveq	#$00,d0																;7000
	move.b	$18(a1,d7.w),d0														;10317018
	move.w	d0,d1																;3200
	and.w	#$00E0,d0															;024000E0
	bne.s	adrCd001FCC															;6612
	and.w	#$000F,d1															;0241000F
	move.w	d1,d0																;3001
	bsr		Load_ChampionStatRecord												;6100469E
	move.w	d1,d0																;3001
	exg		a1,a4																;C949
	bsr.s	adrCd001F8C															;61C2
	exg		a1,a4																;C949
adrCd001FCC:		; Memory Address ($1FCC) and binary offset [$1C48]
	dbra	d7,adrLp001FAC														;51CFFFDE
	rts																			;4E75

adrCd001FD2:		; Memory Address ($1FD2) and binary offset [$1C4E]
	move.w	#$FFFF,adrW_00230A.l												;33FCFFFF0000230A
	movem.w	d0/d1,-(sp)															;48A7C000
	moveq	#-$01,d5															;7AFF
	bsr		adrCd0098A4															;610078C2
	bcc.s	adrCd00203E															;6458
	move.w	d0,-(sp)															;3F00
	bsr.s	adrCd002024															;613A
	move.w	(sp),d0																;3017
	tst.b	d0																	;4A00
	bmi.s	adrCd002010															;6B20
	cmpi.b	#$10,d0																;0C000010
	bcs.s	adrCd002014															;651E
	addq.w	#$02,sp																;544F
	move.b	$0006(a1),d7														;1E290006
	lsr.b	#$02,d7																;E40F
	beq.s	adrCd00201C															;671C
	move.w	d0,-(sp)															;3F00
	subq.b	#$01,d7																;5307
	beq.s	adrCd002014															;670E
	subq.b	#$01,d7																;5307
	beq.s	adrCd002010															;6706
	bsr		adrCd0020F8															;610000EC
	move.w	(sp),d0																;3017
adrCd002010:		; Memory Address ($2010) and binary offset [$1C8C]
	bsr		adrCd0020F8															;610000E6
adrCd002014:		; Memory Address ($2014) and binary offset [$1C90]
	movem.w	(sp)+,d0															;4C9F0001
	bsr		adrCd0020F8															;610000DE
adrCd00201C:		; Memory Address ($201C) and binary offset [$1C98]
	movem.w	(sp)+,d0/d1															;4C9F0003
	bra		adrCd00230C															;600002EA

adrCd002024:		; Memory Address ($2024) and binary offset [$1CA0]
	tst.b	d0																	;4A00
	bmi.s	adrCd00204A															;6B22
	cmpi.b	#$10,d0																;0C000010
	bcs.s	adrCd002040															;6512
	clr.w	d5																	;4245
	cmp.b	#$15,$0006(a1)														;0C2900150006
	bcc.s	adrCd00203E															;6406
	move.w	$0008(a1),d5														;3A290008
	addq.w	#$01,d5																;5245
adrCd00203E:		; Memory Address ($203E) and binary offset [$1CBA]
	rts																			;4E75

adrCd002040:		; Memory Address ($2040) and binary offset [$1CBC]
	clr.w	d5																	;4245
	move.b	$0005(a1),d5														;1A290005
	addq.b	#$01,d5																;5205
	rts																			;4E75

adrCd00204A:		; Memory Address ($204A) and binary offset [$1CC6]
	moveq	#$05,d0																;7005
	jsr		PlaySound.l															;4EB9000088BE
	moveq	#$01,d2																;7401
	lea		adrEA002680.l,a0													;41F900002680
	clr.l	(a0)																;4290
	move.l	a4,-(sp)															;2F0C
	moveq	#$03,d7																;7E03
adrLp002060:		; Memory Address ($2060) and binary offset [$1CDC]
	moveq	#$00,d0																;7000
	move.b	$18(a1,d7.w),d0														;10317018
	and.w	#$00E0,d0															;024000E0
	bne.s	adrCd00207E															;6612
	move.b	$18(a1,d7.w),d0														;10317018
	bsr		Load_ChampionStatRecord												;610045EE
	move.b	$0005(a4),$00(a0,d7.w)												;11AC00057000
	addq.b	#$01,$00(a0,d7.w)													;52307000
adrCd00207E:		; Memory Address ($207E) and binary offset [$1CFA]
	dbra	d7,adrLp002060														;51CFFFE0
	move.l	(sp)+,a4															;285F
adrCd002084:		; Memory Address ($2084) and binary offset [$1D00]
	rts																			;4E75

adrCd002086:		; Memory Address ($2086) and binary offset [$1D02]
	bsr		adrCd0098A4															;6100781C
	bcc.s	adrCd002084															;64F8
adrCd00208C:		; Memory Address ($208C) and binary offset [$1D08]
	tst.b	d0																	;4A00
	bmi.s	adrCd0020D6															;6B46
	moveq	#$18,d4																;7818
	cmpi.b	#$10,d0																;0C000010
	bcs.s	adrCd0020A0															;6508
	tst.b	$000B(a1)															;4A29000B
	bmi.s	adrCd0020D4															;6B36
	moveq	#$02,d4																;7802
adrCd0020A0:		; Memory Address ($20A0) and binary offset [$1D1C]
	move.b	$00(a1,d4.w),d7														;1E314000
	bsr.s	adrCd0020B8															;6112
	cmp.b	$00(a1,d4.w),d7														;BE314000
	beq.s	adrCd0020D4															;6728
	move.b	d7,$00(a1,d4.w)														;13874000
	bset	#$06,$03(a1,d4.w)													;08F100064003
	rts																			;4E75

adrCd0020B8:		; Memory Address ($20B8) and binary offset [$1D34]
	move.w	d0,d6																;3C00
	bsr		adrCd0020F6															;6100003A
	tst.w	d5																	;4A45
	beq.s	adrCd0020D4															;6712
	eor.b	#$02,d7																;0A070002
	move.w	d6,d0																;3006
	bsr		adrCd0020F6															;6100002C
	tst.w	d5																	;4A45
	bne.s	adrCd0020D4															;6604
	eor.b	#$01,d7																;0A070001
adrCd0020D4:		; Memory Address ($20D4) and binary offset [$1D50]
	rts																			;4E75

adrCd0020D6:		; Memory Address ($20D6) and binary offset [$1D52]
	bsr		Load_CurrentChampionStatRecord										;61004584
	moveq	#$05,d0																;7005
	jsr		PlaySound.l															;4EB9000088BE
	exg		a4,a1																;C34C
	move.w	$0006(a4),d0														;302C0006
	move.w	$0020(a4),d7														;3E2C0020
	bsr.s	adrCd0020B8															;61CA
	move.w	d7,$0020(a4)														;39470020
	rts																			;4E75

adrW_0020F4:		; Memory Address ($20F4) and binary offset [$1D70]
	ds.b	$2
adrCd0020F6:		; Memory Address ($20F6) and binary offset [$1D72]
	moveq	#$01,d5																;7A01
adrCd0020F8:		; Memory Address ($20F8) and binary offset [$1D74]
	tst.b	d0																	;4A00
	bmi.s	adrCd00212E															;6B32
	cmpi.b	#$10,d0																;0C000010
	bcs.s	adrCd002128															;6526
	move.b	$0006(a1),d2														;14290006
	and.w	#$007F,d2															;0242007F
adrCd00210A:		; Memory Address ($210A) and binary offset [$1D86]
	asl.w	#$03,d2																;E742
	add.w	#$0064,d2															;06420064
	move.w	adrW_0020F4.w,d0													;303820F4	;Short Absolute converted to symbol!
	add.w	d0,d0																;D040
	sub.w	d0,d2																;9440
	bpl.s	adrCd00211C															;6A02
	moveq	#$0A,d2																;740A
adrCd00211C:		; Memory Address ($211C) and binary offset [$1D98]
	bsr		RandomGen_BytewithOffset											;6100348E
	cmp.w	d0,d2																;B440
	bcs.s	adrCd002126															;6502
	lsr.w	#$01,d5																;E24D
adrCd002126:		; Memory Address ($2126) and binary offset [$1DA2]
	rts																			;4E75

adrCd002128:		; Memory Address ($2128) and binary offset [$1DA4]
	moveq	#$00,d2																;7400
	move.b	(a1),d2																;1411
	bra.s	adrCd00210A															;60DC

adrCd00212E:		; Memory Address ($212E) and binary offset [$1DAA]
	moveq	#$06,d1																;7206
	movem.l	a4/a5,-(sp)															;48E7000C
	move.l	a1,a5																;2A49
	bsr		adrCd005500															;610033C8
	movem.l	(sp)+,a4/a5															;4CDF3000
	tst.w	d3																	;4A43
	bmi.s	adrCd00216A															;6B28
	move.w	#$FF80,adrW_0020F4.w												;31FCFF8020F4	;Short Absolute converted to symbol!
	move.w	d3,-(sp)															;3F03
	bsr.s	adrCd00216A															;611E
	move.w	(sp)+,d3															;361F
	move.w	d3,d7																;3E03
	addq.w	#$02,d3																;5443
	asl.w	#$03,d3																;E743
	neg.w	d3																	;4443
	move.w	d3,adrW_0020F4.w													;31C320F4	;Short Absolute converted to symbol!
	lsr.w	#$02,d7																;E44F
	addq.w	#$01,d7																;5247
adrLp00215E:		; Memory Address ($215E) and binary offset [$1DDA]
	move.w	d7,-(sp)															;3F07
	bsr.s	adrCd00216A															;6108
	move.w	(sp)+,d7															;3E1F
	dbra	d7,adrLp00215E														;51CFFFF8
	rts																			;4E75

adrCd00216A:		; Memory Address ($216A) and binary offset [$1DE6]
	lea		adrEA002680.l,a0													;41F900002680
	move.l	a4,-(sp)															;2F0C
	clr.w	d5																	;4245
	moveq	#$03,d7																;7E03
adrLp002176:		; Memory Address ($2176) and binary offset [$1DF2]
	move.b	$18(a1,d7.w),d0														;10317018
	bsr		Load_ChampionStatRecord												;610044E4
	move.b	$00(a0,d7.w),d5														;1A307000
	exg		a1,a4																;C949
	bsr.s	adrCd002128															;61A2
	exg		a1,a4																;C949
	move.b	d5,$00(a0,d7.w)														;11857000
	dbra	d7,adrLp002176														;51CFFFE8
	move.l	(sp)+,a4															;285F
adrCd002192:		; Memory Address ($2192) and binary offset [$1E0E]
	rts																			;4E75

adrCd002194:		; Memory Address ($2194) and binary offset [$1E10]
	move.b	$000B(a1),d0														;1029000B
	bmi.s	adrCd002192															;6BF8
	sub.b	#$64,d0																;04000064
	beq.s	adrCd002192															;67F2
	move.b	adrB_00EE3E.l,d0													;10390000EE3E
	cmpi.b	#$10,d0																;0C000010
	bcc.s	adrCd002192															;64E6
	bsr		Load_ChampionStatRecord												;610044B2
	cmp.b	#$EC,$001C(a4)														;0C2C00EC001C
	bcc.s	adrCd0021EC															;6434
	move.w	$001C(a4),d2														;342C001C
	move.w	d5,d1																;3205
	cmp.w	$0008(a1),d1														;B2690008
	bcs.s	adrCd0021CA															;6506
	move.w	$0008(a1),d1														;32290008
	addq.w	#$01,d1																;5241
adrCd0021CA:		; Memory Address ($21CA) and binary offset [$1E46]
	tst.w	MultiPlayer.l														;4A790000EE30
	beq.s	adrCd0021D6															;6704
	addq.w	#$01,d1																;5241
	lsr.w	#$01,d1																;E249
adrCd0021D6:		; Memory Address ($21D6) and binary offset [$1E52]
	sub.w	d1,d2																;9441
	bcs.s	adrCd0021E4															;650A
	cmp.b	#$09,$0006(a1)														;0C2900090006
	bcc.s	adrCd0021E4															;6402
	sub.w	d1,d2																;9441
adrCd0021E4:		; Memory Address ($21E4) and binary offset [$1E60]
	move.w	d2,$001C(a4)														;3942001C
	bsr		adrCd002258															;6100006E
adrCd0021EC:		; Memory Address ($21EC) and binary offset [$1E68]
	move.l	a5,a2																;244D
	move.b	adrB_00EE3E.l,d0													;10390000EE3E
	and.w	#$000F,d0															;0240000F
	bsr		adrCd004066															;61001E6C
	exg		a5,a2																;C54D
	tst.w	d1																	;4A41
	bmi.s	adrCd002192															;6B90
	move.w	$0008(a1),d1														;32290008
	sub.w	d5,d1																;9245
	bcc.s	adrCd002256															;644C
	move.b	$0006(a1),d1														;12290006
	and.w	#$007F,d1															;0241007F
	moveq	#$03,d7																;7E03
adrLp002214:		; Memory Address ($2214) and binary offset [$1E90]
	move.b	$18(a2,d7.w),d0														;10327018
	and.w	#$00E0,d0															;024000E0
	bne.s	adrCd002252															;6634
	move.b	$18(a2,d7.w),d0														;10327018
	bsr		Load_ChampionStatRecord												;6100443C
	move.b	$001C(a4),d0														;102C001C
	cmpi.b	#$EC,d0																;0C0000EC
	bcc.s	adrCd002252															;6422
	moveq	#$00,d2																;7400
	move.b	d1,d2																;1401
	sub.b	(a4),d2																;9414
	addq.b	#$02,d2																;5402
	bmi.s	adrCd002252															;6B18
	asl.w	#$07,d2																;EF42
	move.w	$001C(a4),d0														;302C001C
	tst.w	MultiPlayer.l														;4A790000EE30
	bne.s	adrCd00224A															;6602
	add.w	d2,d2																;D442
adrCd00224A:		; Memory Address ($224A) and binary offset [$1EC6]
	sub.w	d2,d0																;9042
	move.w	d0,$001C(a4)														;3940001C
	bsr.s	adrCd002258															;6106
adrCd002252:		; Memory Address ($2252) and binary offset [$1ECE]
	dbra	d7,adrLp002214														;51CFFFC0
adrCd002256:		; Memory Address ($2256) and binary offset [$1ED2]
	rts																			;4E75

adrCd002258:		; Memory Address ($2258) and binary offset [$1ED4]
	tst.b	$001E(a4)															;4A2C001E
	bmi.s	adrCd002296															;6B38
	moveq	#$00,d2																;7400
	move.b	(a4),d2																;1414
	lea		adrEA004B1A.l,a0													;41F900004B1A
	move.b	$00(a0,d2.w),d3														;16302000
	lsr.b	#$01,d3																;E20B
	cmp.b	$001C(a4),d3														;B62C001C
	bcs.s	adrCd002296															;6522
	move.l	a4,d3																;260C
	sub.l	#Character_Stats_DataTable,d3										;04830000EB2A
	lsr.b	#$05,d3																;EA0B
	and.w	#$0003,d3															;02430003
	beq.s	adrCd00228A															;6706
	cmpi.w	#$0003,d3															;0C430003
	bcs.s	adrCd002290															;6506
adrCd00228A:		; Memory Address ($228A) and binary offset [$1F06]
	btst	#$00,d2																;08020000
	bne.s	adrCd002296															;6606
adrCd002290:		; Memory Address ($2290) and binary offset [$1F0C]
	add.b	#$81,$001E(a4)														;062C0081001E
adrCd002296:		; Memory Address ($2296) and binary offset [$1F12]
	rts																			;4E75

adrCd002298:		; Memory Address ($2298) and binary offset [$1F14]
	swap	d5																	;4845
	clr.w	d5																	;4245
	swap	d5																	;4845
	cmpi.w	#$0010,d0															;0C400010
	bcs.s	adrCd0022CA															;6526
	move.w	d0,d1																;3200
	sub.w	#$0010,d0															;04400010
	asl.w	#$04,d0																;E940
	lea		UnpackedMonsters.l,a1												;43F900016B7E
	add.w	d0,a1																;D2C0
	moveq	#$00,d7																;7E00
	move.b	$0000(a1),d7														;1E290000
	swap	d7																	;4847
	move.b	$0001(a1),d7														;1E290001
	bsr		CoordToMap															;610061DA
	move.w	d0,d4																;3800
	move.w	d1,d0																;3001
	bra.s	adrCd002324															;605A

adrCd0022CA:		; Memory Address ($22CA) and binary offset [$1F46]
	move.w	d0,d3																;3600
	bsr		Load_ChampionStatRecord												;61004392
	move.l	a4,a1																;224C
	moveq	#$00,d7																;7E00
	move.b	$0016(a1),d7														;1E290016
	bpl.s	adrCd0022F8															;6A1E
	move.w	d3,d0																;3003
	bsr		adrCd004066															;61001D88
	tst.w	d1																	;4A41
	bmi		adrCd001DBA															;6B00FAD6
	move.l	a5,a1																;224D
	lea		adrEA002680.l,a0													;41F900002680
	clr.l	(a0)																;4290
	move.b	d5,$00(a0,d1.w)														;11851000
	bra		adrCd00248C															;60000196

adrCd0022F8:		; Memory Address ($22F8) and binary offset [$1F74]
	swap	d7																	;4847
	move.b	$0017(a1),d7														;1E290017
	bsr		CoordToMap															;6100619C
	move.w	d0,d4																;3800
	move.w	d3,d0																;3003
	bra		adrCd002414															;6000010C

adrW_00230A:		; Memory Address ($230A) and binary offset [$1F86]
	ds.b	$2
adrCd00230C:		; Memory Address ($230C) and binary offset [$1F88]
	move.w	d0,d4																;3800
	bsr		adrCd0098A4															;61007594
	bcs.s	adrCd002316															;6502
	rts																			;4E75

adrCd002316:		; Memory Address ($2316) and binary offset [$1F92]
	tst.b	d0																	;4A00
	bmi		adrCd00248C															;6B000172
	cmpi.w	#$0010,d0															;0C400010
	bcs		adrCd002414															;650000F2
adrCd002324:		; Memory Address ($2324) and binary offset [$1FA0]
	tst.w	adrW_00230A.w														;4A78230A	;Short Absolute converted to symbol!
	beq.s	adrCd002374															;674A
	moveq	#$00,d1																;7200
	move.b	$000D(a1),d1														;1229000D
	bmi.s	adrCd002374															;6B42
	asl.w	#$02,d1																;E541
	lea		MonsterTeamIndexTable.l,a0											;41F900017390
	add.w	d1,a0																;D0C1
	moveq	#$03,d7																;7E03
adrLp00233E:		; Memory Address ($233E) and binary offset [$1FBA]
	moveq	#$00,d1																;7200
	move.b	$00(a0,d7.w),d1														;12307000
	bmi.s	adrCd002360															;6B1A
	move.w	d1,d0																;3001
	add.w	#$0010,d0															;06400010
	asl.w	#$04,d1																;E941
	lea		UnpackedMonsters.l,a1												;43F900016B7E
	add.w	d1,a1																;D2C1
	movem.l	d4/d5/d7/a0/a6,-(sp)												;48E70D82
	bsr.s	adrCd002374															;6118
	movem.l	(sp)+,d4/d5/d7/a0/a6												;4CDF41B0
adrCd002360:		; Memory Address ($2360) and binary offset [$1FDC]
	dbra	d7,adrLp00233E														;51CFFFDC
	cmp.l	#$FFFFFFFF,(a0)														;0C90FFFFFFFF
	beq.s	adrCd002394															;6728
	bset	#$07,$01(a6,d4.w)													;08F600074001
	rts																			;4E75

adrCd002374:		; Memory Address ($2374) and binary offset [$1FF0]
	movem.w	d0/d4,-(sp)															;48A78800
	tst.l	d5																	;4A85
	bpl.s	adrCd002380															;6A04
	bsr		adrCd0020F8															;6100FD7A
adrCd002380:		; Memory Address ($2380) and binary offset [$1FFC]
	bsr		adrCd002194															;6100FE12
	movem.w	(sp)+,d0/d4															;4C9F0011
	move.w	$0008(a1),d1														;32290008
	sub.w	d5,d1																;9245
	bcs.s	adrCd002396															;6506
	move.w	d1,$0008(a1)														;33410008
adrCd002394:		; Memory Address ($2394) and binary offset [$2010]
	rts																			;4E75

adrCd002396:		; Memory Address ($2396) and binary offset [$2012]
	moveq	#$00,d2																;7400
	move.b	$000C(a1),d2														;1429000C
	swap	d2																	;4842
	move.b	$000B(a1),d2														;1429000B
	move.l	d2,-(sp)															;2F02
	bsr		adrCd0027F0															;6100044A
	move.w	d4,d0																;3004
	moveq	#$01,d7																;7E01
	bsr		adrCd001DBC															;6100FA0E
	move.l	(sp)+,d2															;241F
	tst.b	d2																	;4A02
	bmi.s	adrCd002394															;6BDE
	moveq	#$01,d5																;7A01
	swap	d5																	;4845
	cmpi.b	#$64,d2																;0C020064
	beq.s	adrCd002394															;67D4
	move.w	#$0056,d5															;3A3C0056
	cmpi.b	#$6B,d2																;0C02006B
	beq.s	_DropTheObject														;672C
	cmpi.b	#$40,d2																;0C020040
	bne.s	adrCd0023D6															;6606
	swap	d2																	;4842
	move.w	d2,d5																;3A02
	bra.s	_DropTheObject														;6020

adrCd0023D6:		; Memory Address ($23D6) and binary offset [$2052]
	bsr		RandomGen_BytewithOffset											;610031D4
	and.w	#$000F,d0															;0240000F
	move.b	DroppedObjects_DataTable(pc,d0.w),d5								;1A3B0024
	beq.s	adrCd002394															;67B0
	cmpi.w	#$0005,d5															;0C450005
	bcc.s	_DropTheObject														;640C
	bsr		RandomGen_BytewithOffset											;610031C0
	and.w	#$0007,d0															;02400007
	swap	d0																	;4840
	add.l	d0,d5																;DA80
_DropTheObject:		; Memory Address ($23F6) and binary offset [$2072]
	move.w	d4,d0																;3004
	move.l	Current_TowerMapDataBase.l,a6										;2C790000EE78
	moveq	#$00,d6																;7C00
	bra		adrCd005E88															;60003A86

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

adrCd002414:		; Memory Address ($2414) and binary offset [$2090]
	tst.l	d5																	;4A85
	bpl.s	adrCd002420															;6A08
	move.w	d0,-(sp)															;3F00
	bsr		adrCd0020F8															;6100FCDC
	move.w	(sp)+,d0															;301F
adrCd002420:		; Memory Address ($2420) and binary offset [$209C]
	moveq	#$00,d1																;7200
	move.b	$0005(a1),d1														;12290005
	sub.w	d5,d1																;9245
	bcs.s	adrCd002430															;6506
	move.b	d1,$0005(a1)														;13410005
	rts																			;4E75

adrCd002430:		; Memory Address ($2430) and binary offset [$20AC]
	clr.b	$0005(a1)															;42290005
	clr.b	$0007(a1)															;42290007
	move.l	a5,-(sp)															;2F0D
	bsr		adrCd004066															;61001C2A
	tst.w	d1																	;4A41
	bmi.s	adrCd002460															;6B1E
	bset	#$06,$18(a5,d1.w)													;08F500061018
	tst.w	$0042(a5)															;4A6D0042
	bpl.s	adrCd002460															;6A12
	movem.l	d4/a1,-(sp)															;48E70840
	move.w	d1,d7																;3E01
	bsr		Refresh_PartyShieldSlotIfDirty										;61005A9A
	bsr		Draw_PartyShieldChainStrip											;61005A78
	movem.l	(sp)+,d4/a1															;4CDF0210
adrCd002460:		; Memory Address ($2460) and binary offset [$20DC]
	move.l	(sp)+,a5															;2A5F
	move.b	#$FF,$0016(a1)														;137C00FF0016
	move.l	Current_TowerMapDataBase.l,a6										;2C790000EE78
	move.w	d4,d0																;3004
	bclr	#$07,$01(a6,d0.w)													;08B600070001
	move.l	a1,d5																;2A09
	sub.l	#Character_Stats_DataTable,d5										;04850000EB2A
	lsr.w	#$05,d5																;EA4D
	add.l	#$10040,d5															;068500010040
	moveq	#$00,d6																;7C00
	bra		adrCd005E88															;600039FE

adrCd00248C:		; Memory Address ($248C) and binary offset [$2108]
	or.b	#$0F,$003E(a1)														;0029000F003E
	bclr	#$02,(a1)															;08910002
	beq.s	adrCd00249C															;6704
	clr.w	$0014(a1)															;42690014
adrCd00249C:		; Memory Address ($249C) and binary offset [$2118]
	tst.l	d5																	;4A85
	bpl.s	adrCd0024A6															;6A06
	moveq	#-$01,d0															;70FF
	bsr		adrCd0020F8															;6100FC54
adrCd0024A6:		; Memory Address ($24A6) and binary offset [$2122]
	moveq	#$03,d1																;7203
	lea		adrEA002680.l,a0													;41F900002680
adrLp0024AE:		; Memory Address ($24AE) and binary offset [$212A]
	move.b	$18(a1,d1.w),d0														;10311018
	and.w	#$00E0,d0															;024000E0
	beq.s	adrCd0024BE															;6706
	clr.b	$00(a0,d1.w)														;42301000
	bra.s	adrCd0024F2															;6034

adrCd0024BE:		; Memory Address ($24BE) and binary offset [$213A]
	move.b	$18(a1,d1.w),d0														;10311018
	bsr		Load_ChampionStatRecord												;6100419C
	move.b	$0005(a4),d0														;102C0005
	sub.b	$00(a0,d1.w),d0														;90301000
	bcc.s	adrCd0024EE															;641E
	or.b	#$40,$18(a1,d1.w)													;003100401018
	clr.b	$0011(a4)															;422C0011
	move.b	#$FF,$0013(a4)														;197C00FF0013
	move.l	a0,-(sp)															;2F08
	moveq	#Sound_CharacterDeath,d0											;7003
	jsr		PlaySound.l															;4EB9000088BE
	move.l	(sp)+,a0															;205F
	moveq	#$00,d0																;7000
adrCd0024EE:		; Memory Address ($24EE) and binary offset [$216A]
	move.b	d0,$0005(a4)														;19400005
adrCd0024F2:		; Memory Address ($24F2) and binary offset [$216E]
	dbra	d1,adrLp0024AE														;51C9FFBA
	move.l	a5,-(sp)															;2F0D
	move.l	a1,a5																;2A49
	moveq	#$03,d1																;7203
adrLp0024FC:		; Memory Address ($24FC) and binary offset [$2178]
	move.b	$18(a5,d1.w),d0														;10351018
	bmi.s	Loop_CheckSpecialFlag06_AI_TBC										;6B1E
	btst	#$06,d0																;08000006
	beq.s	Loop_CheckSpecialFlag06_AI_TBC										;6718
	btst	#$05,d0																;08000005
	bne.s	Loop_CheckSpecialFlag06_AI_TBC										;6612
	and.w	#$000F,d0															;0240000F
	bsr		adrCd004092															;61001B7E
	tst.w	d2																	;4A42
	bmi.s	Loop_CheckSpecialFlag06_AI_TBC										;6B06
	move.b	#$FF,$26(a5,d2.w)													;1BBC00FF2026
Loop_CheckSpecialFlag06_AI_TBC:		; Memory Address ($2520) and binary offset [$219C]
	dbra	d1,adrLp0024FC														;51C9FFDA
	btst	#$06,$0018(a5)														;082D00060018
	bne.s	Handle_SpecialFlag06_AI_TBC											;6608
	bsr		adrCd008246															;61005D18
	bra		Finalize_PartyAction_AI_TBC											;600000D8

Handle_SpecialFlag06_AI_TBC:		; Memory Address ($2534) and binary offset [$21B0]
	moveq	#$00,d1																;7200
	moveq	#$00,d0																;7000
Loop_InventoryAction_AI_TBC:		; Memory Address ($2538) and binary offset [$21B4]
	move.b	$18(a5,d1.w),d0														;10351018
	and.w	#$00E0,d0															;024000E0
	bne.s	Adjust_InventoryIndex_AI_TBC										;6634
	move.b	$18(a5,d1.w),d0														;10351018
	and.w	#$000F,d0															;0240000F
	move.b	$0018(a5),$18(a5,d1.w)												;1BAD00181018
	move.b	d0,$0018(a5)														;1B400018
	bset	#$04,$0018(a5)														;08ED00040018
	move.w	d0,$0006(a5)														;3B400006
	bsr.s	Init_InventorySwap_AI_TBC											;6104
	bra		Clear_PartyActionState_AI_TBC										;6000009C

Init_InventorySwap_AI_TBC:		; Memory Address ($2564) and binary offset [$21E0]
	lea		adrEA002680.l,a0													;41F900002680
	move.b	(a0),d0																;1010
	move.b	$00(a0,d1.w),(a0)													;10B01000
	move.b	d0,$00(a0,d1.w)														;11801000
	rts																			;4E75

Adjust_InventoryIndex_AI_TBC:		; Memory Address ($2576) and binary offset [$21F2]
	addq.w	#$01,d1																;5241
	cmpi.w	#$0004,d1															;0C410004
	bcs.s	Loop_InventoryAction_AI_TBC											;65BA
	and.b	#$01,(a5)															;02150001
	moveq	#$03,d1																;7203
adrLp002584:		; Memory Address ($2584) and binary offset [$2200]
	move.b	$18(a5,d1.w),d0														;10351018
	btst	#$05,d0																;08000005
	beq.s	Store_InventoryState_AI_TBC											;6706
	btst	#$06,d0																;08000006
	beq.s	End_InventoryLoop_AI_TBC											;6706
Store_InventoryState_AI_TBC:		; Memory Address ($2594) and binary offset [$2210]
	dbra	d1,adrLp002584														;51C9FFEE
	bra.s	Dispatch_PartyAction_AI_TBC											;6054

End_InventoryLoop_AI_TBC:		; Memory Address ($259A) and binary offset [$2216]
	move.b	$0018(a5),$18(a5,d1.w)												;1BAD00181018
	move.b	d0,$0018(a5)														;1B400018
	bset	#$04,$0018(a5)														;08ED00040018
	and.w	#$000F,d0															;0240000F
	move.w	d0,$0006(a5)														;3B400006
	bsr.s	Init_InventorySwap_AI_TBC											;61B0
	bsr		Clear_TriggerProcessed_AI_TBC										;61000072
	bclr	#$05,$0018(a5)														;08AD00050018
	bsr		Load_CurrentChampionStatRecord										;6100409C
	move.b	$0016(a4),$001D(a5)													;1B6C0016001D
	move.b	$0017(a4),$001F(a5)													;1B6C0017001F
	move.b	$001A(a4),$0059(a5)													;1B6C001A0059
	move.b	$0018(a4),$0021(a5)													;1B6C00180021
	move.b	#$FF,$0016(a4)														;197C00FF0016
	move.b	$0018(a5),$0026(a5)													;1B6D00180026
	and.b	#$0F,$0026(a5)														;022D000F0026
	bra.s	Clear_PartyActionState_AI_TBC										;6010

Dispatch_PartyAction_AI_TBC:		; Memory Address ($25EE) and binary offset [$226A]
	bsr.s	Clear_TriggerProcessed_AI_TBC										;6138
	move.b	#$FF,$001D(a5)														;1B7C00FF001D
	bsr		adrCd00270E															;61000116
	and.b	#$01,(a5)															;02150001
Clear_PartyActionState_AI_TBC:		; Memory Address ($25FE) and binary offset [$227A]
	clr.w	$0014(a5)															;426D0014
	clr.b	$003E(a5)															;422D003E
	bsr		Draw_ChampionNamePanelFrame											;61005C70
Finalize_PartyAction_AI_TBC:		; Memory Address ($260A) and binary offset [$2286]
	move.w	#$FFFF,$0042(a5)													;3B7CFFFF0042
	move.w	#$FFFF,$0040(a5)													;3B7CFFFF0040
	move.b	#$FF,$0035(a5)														;1B7C00FF0035
	bsr		Refresh_DirtyPartyShieldSlots										;610058A2
	bsr		Loop_TeamAvatarSlots_AI_TBC											;61000040
	move.l	(sp)+,a5															;2A5F
	rts																			;4E75

Clear_TriggerProcessed_AI_TBC:		; Memory Address ($2628) and binary offset [$22A4]
	bsr		adrCd008498															;61005E6E
	bclr	#$07,$01(a6,d0.w)													;08B600070001
	moveq	#$03,d1																;7203
adrLp002634:		; Memory Address ($2634) and binary offset [$22B0]
	moveq	#$01,d5																;7A01
	swap	d5																	;4845
	move.b	$18(a5,d1.w),d5														;1A351018
	bmi.s	Mark_TeamAvatarSlot_AI_TBC											;6B1E
	bset	#$05,$18(a5,d1.w)													;08F500051018
	bne.s	Mark_TeamAvatarSlot_AI_TBC											;6616
	and.w	#$000F,d5															;0245000F
	add.w	#$0040,d5															;06450040
	moveq	#$00,d6																;7C00
	movem.l	d0/d1,-(sp)															;48E7C000
	bsr		adrCd005E88															;61003832
	movem.l	(sp)+,d0/d1															;4CDF0003
Mark_TeamAvatarSlot_AI_TBC:		; Memory Address ($265C) and binary offset [$22D8]
	dbra	d1,adrLp002634														;51C9FFD6
	rts																			;4E75

Loop_TeamAvatarSlots_AI_TBC:		; Memory Address ($2662) and binary offset [$22DE]
	moveq	#$03,d7																;7E03
adrLp002664:		; Memory Address ($2664) and binary offset [$22E0]
	move.b	$18(a5,d7.w),d0														;10357018
	bmi.s	Eval_TeamAvatarSlot_AI_TBC											;6B10
	moveq	#$00,d0																;7000
	move.b	adrEA002680(pc,d7.w),d0												;103B7012
	beq.s	Eval_TeamAvatarSlot_AI_TBC											;6708
	move.w	d7,-(sp)															;3F07
	bsr		Quickstart_FallbackHandler_AI_TBC									;6100000E
	move.w	(sp)+,d7															;3E1F
Eval_TeamAvatarSlot_AI_TBC:		; Memory Address ($267A) and binary offset [$22F6]
	dbra	d7,adrLp002664														;51CFFFE8
	rts																			;4E75

adrEA002680:		; Memory Address ($2680) and binary offset [$22FC]
	ds.b	$4
Quickstart_FallbackHandler_AI_TBC:		; Memory Address ($2684) and binary offset [$2300]
	move.w	d0,-(sp)															;3F00
	move.l	#$000D000C,adrW_00D92A.l											;23FC000D000C0000D92A
	lea		GFX_Pockets+$7688.l,a1												;43F900053D8A
	move.b	#$07,$5A(a5,d7.w)													;1BBC0007705A
	move.w	d7,d0																;3007
	move.l	#$1000A,d7															;2E3C0001000A
	add.w	d0,d0																;D040
	add.w	d0,d0																;D040
	move.w	adrW_0026FE(pc,d0.w),d4												;383B0054
	move.w	adrW_002700(pc,d0.w),d5												;3A3B0052
	add.w	$0008(a5),d5														;DA6D0008
	movem.l	d4/d5,-(sp)															;48E70C00
	moveq	#$00,d6																;7C00
	jsr		adrCd00AE66.l														;4EB90000AE66
	movem.l	(sp)+,d4/d5															;4CDF0030
	move.w	(sp)+,d0															;301F
	addq.w	#$04,d4																;5844
	addq.w	#$03,d5																;5645
	lea		Notice_NumberOfHits.l,a6											;4DF900006174
	moveq	#$00,d2																;7400
	bsr		adrCd006178															;61003AA4
	moveq	#$08,d0																;7008
	move.w	d2,d1																;3202
	beq.s	adrCd0026E4															;6708
	subq.w	#$04,d0																;5940
	subq.w	#$01,d2																;5342
	beq.s	adrCd0026E4															;6702
	subq.w	#$04,d0																;5940
adrCd0026E4:		; Memory Address ($26E4) and binary offset [$2360]
	add.w	d0,d4																;D840
adrLp0026E6:		; Memory Address ($26E6) and binary offset [$2362]
	move.b	(a6)+,d0															;101E
	movem.l	d1/d4/d5/a6,-(sp)													;48E74C02
	jsr		Draw_woundflash_digit.l												;4EB90000D92E
	movem.l	(sp)+,d1/d4/d5/a6													;4CDF4032
	addq.w	#$08,d4																;5044
	dbra	d1,adrLp0026E6														;51C9FFEC
	rts																			;4E75

adrW_0026FE:		; Memory Address ($26FE) and binary offset [$237A]
	dc.w	$000B	;000B
adrW_002700:		; Memory Address ($2700) and binary offset [$237C]
	dc.w	$0013	;0013
	dc.w	$0000	;0000
	dc.w	$0040	;0040
	dc.w	$0020	;0020
	dc.w	$0040	;0040
	dc.w	$0040	;0040
	dc.w	$0040	;0040

adrCd00270E:		; Memory Address ($270E) and binary offset [$238A]
	bsr.s	adrCd002734															;6124
	lea		ThouArtDead.l,a6													;4DF90000271C
	jmp		Print_fflim_text.l													;4EF90000D0C6

ThouArtDead:		; Memory Address ($271C) and binary offset [$2398]
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

adrCd002734:		; Memory Address ($2734) and binary offset [$23B0]
	or.b	#$40,$0054(a5)														;002D00400054
	moveq	#$00,d3																;7600
	bsr		adrCd008FA4															;61006866
	move.l	#$004B000C,d5														;2A3C004B000C
	add.w	$0008(a5),d5														;DA6D0008
	move.l	#$007F0060,d4														;283C007F0060
	moveq	#$04,d3																;7604
	moveq	#$02,d2																;7402
	bra.s	adrCd002760															;600A

adrLp002756:		; Memory Address ($2756) and binary offset [$23D2]
	add.w	d2,d5																;DA42
	swap	d5																	;4845
	sub.w	d2,d5																;9A42
	subq.w	#$01,d5																;5345
	swap	d5																	;4845
adrCd002760:		; Memory Address ($2760) and binary offset [$23DC]
	movem.l	d2-d5,-(sp)															;48E73C00
	jsr		BW_draw_frame.l														;4EB90000DAD4
	movem.l	(sp)+,d2-d5															;4CDF003C
	eor.w	#$0006,d3															;0A430006
	add.l	#$FFFE0001,d4														;0684FFFE0001
	dbra	d2,adrLp002756														;51CAFFDC
	rts																			;4E75

adrCd00277E:		; Memory Address ($277E) and binary offset [$23FA]
	movem.l	d0-d7/a0-a6,-(sp)													;48E7FFFE
	lea		UnpackedMonsters.l,a4												;49F900016B7E
	move.w	-$0002(a4),d6														;3C2CFFFE
adrLp00278C:		; Memory Address ($278C) and binary offset [$2408]
	move.w	d6,d0																;3006
	asl.w	#$04,d0																;E940
	lea		$00(a4,d0.w),a3														;47F40000
	move.b	$000B(a3),d0														;102B000B
	bmi.s	adrCd0027A0															;6B06
	cmpi.b	#$64,d0																;0C000064
	bne.s	adrCd0027C6															;6626
adrCd0027A0:		; Memory Address ($27A0) and binary offset [$241C]
	moveq	#$00,d0																;7000
	move.b	$0004(a3),d0														;102B0004
	bsr		adrCd0084DA															;61005D32
	moveq	#$00,d7																;7E00
	move.b	$0000(a3),d7														;1E2B0000
	bmi.s	adrCd0027C6															;6B14
	swap	d7																	;4847
	move.b	$0001(a3),d7														;1E2B0001
	bsr		CoordToMap															;61005CE2
	move.w	d0,d4																;3800
	move.w	d6,d0																;3006
	add.w	#$0010,d0															;06400010
	bsr.s	adrCd0027F0															;612A
adrCd0027C6:		; Memory Address ($27C6) and binary offset [$2442]
	dbra	d6,adrLp00278C														;51CEFFC4
	movem.l	(sp),d0-d7/a0-a6													;4CD77FFF
	move.w	d2,d0																;3002
	bsr		adrCd0084FC															;61005D2A
	move.w	d1,d0																;3001
	bsr		adrCd0084DA															;61005D02
	movem.l	(sp)+,d0-d7/a0-a6													;4CDF7FFF
	rts																			;4E75

adrCd0027E0:		; Memory Address ($27E0) and binary offset [$245C]
	move.l	a4,d0																;200C
	sub.l	#UnpackedMonsters,d0												;048000016B7E
	lsr.w	#MonsterRecord_SizeShift,d0											;E848
	add.w	#MonsterRecord_Size,d0												;06400010
	bra.s	adrCd0027F6															;6006

adrCd0027F0:		; Memory Address ($27F0) and binary offset [$246C]
	bclr	#$07,$01(a6,d4.w)													;08B600074001
adrCd0027F6:		; Memory Address ($27F6) and binary offset [$2472]
	bsr.s	adrCd002848															;6150
	lea		UnpackedMonsters.l,a2												;45F900016B7E
	move.w	MonsterLive_RecordCountOffset(a2),d2								;342AFFFE
	subq.w	#$01,MonsterLive_RecordCountOffset(a2)								;536AFFFE
	sub.w	d0,d2																;9440
	asl.w	#MonsterRecord_SizeShift,d0											;E940
	lea		$00(a2,d0.w),a2														;45F20000
	lea		MonsterRecord_Size(a2),a3											;47EA0010
	bra.s	adrCd00281C															;6008

adrLp002814:		; Memory Address ($2814) and binary offset [$2490]
	move.l	(a3)+,(a2)+															;24DB
	move.l	(a3)+,(a2)+															;24DB
	move.l	(a3)+,(a2)+															;24DB
	move.l	(a3)+,(a2)+															;24DB
adrCd00281C:		; Memory Address ($281C) and binary offset [$2498]
	dbra	d2,adrLp002814														;51CAFFF6
	moveq	#-$01,d2															;74FF
	move.l	d2,(a2)+															;24C2
	move.l	d2,(a2)+															;24C2
	move.l	d2,(a2)+															;24C2
	move.l	d2,(a2)																;2482
adrCd00282A:		; Memory Address ($282A) and binary offset [$24A6]
	rts																			;4E75

adrCd00282C:		; Memory Address ($282C) and binary offset [$24A8]
	tst.b	$0035(a0)															;4A280035
	bmi.s	adrCd00282A															;6BF8
	cmp.b	$0035(a0),d0														;B0280035
	bne.s	adrCd002840															;6608
	move.b	#$FF,$0035(a0)														;117C00FF0035
	rts																			;4E75

adrCd002840:		; Memory Address ($2840) and binary offset [$24BC]
	bcc.s	adrCd00282A															;64E8
	subq.b	#$01,$0035(a0)														;53280035
	rts																			;4E75

adrCd002848:		; Memory Address ($2848) and binary offset [$24C4]
	lea		Player1_Data.l,a0													;41F90000EE7C
	bsr.s	adrCd00282C															;61DC
	lea		Player2_Data.l,a0													;41F90000EEDE
	bsr.s	adrCd00282C															;61D4
	sub.w	#MonsterRecord_Size,d0												;04400010
	lea		MonsterTeamIndexTable.l,a0											;41F900017390
	move.w	MonsterTeamIndexTable_CountOffset(a0),d2							;3428FFFE
	bmi.s	adrCd00282A															;6BC2
	move.w	d5,-(sp)															;3F05
adrLp00286A:		; Memory Address ($286A) and binary offset [$24E6]
	movem.w	d0/d2,-(sp)															;48A7A000
	bsr.s	adrCd00287C															;610C
	movem.w	(sp)+,d0/d2															;4C9F0005
	dbra	d2,adrLp00286A														;51CAFFF4
	move.w	(sp)+,d5															;3A1F
	rts																			;4E75

adrCd00287C:		; Memory Address ($287C) and binary offset [$24F8]
	moveq	#MonsterTeamMember_Count-1,d3										;7603
	moveq	#$00,d2																;7400
adrLp002880:		; Memory Address ($2880) and binary offset [$24FC]
	move.b	$00(a0,d3.w),d5														;1A303000
	bmi.s	adrCd002896															;6B10
	cmp.b	d5,d0																;B005
	bcs.s	adrCd002892															;6508
	bne.s	adrCd002896															;660A
	clr.b	$00(a0,d3.w)														;42303000
	moveq	#$01,d2																;7401
adrCd002892:		; Memory Address ($2892) and binary offset [$250E]
	subq.b	#$01,$00(a0,d3.w)													;53303000
adrCd002896:		; Memory Address ($2896) and binary offset [$2512]
	dbra	d3,adrLp002880														;51CBFFE8
	tst.w	d2																	;4A42
	beq.s	adrCd0028B8															;671A
	lea		UnpackedMonsters.l,a2												;45F900016B7E
	asl.w	#MonsterRecord_SizeShift,d0											;E940
	tst.b	$0D(a2,d0.w)														;4A32000D
	bmi.s	adrCd0028B8															;6B0C
	moveq	#MonsterTeamMember_Count-1,d3										;7603
adrLp0028AE:		; Memory Address ($28AE) and binary offset [$252A]
	tst.b	$00(a0,d3.w)														;4A303000
	bpl.s	adrCd0028BC															;6A08
	dbra	d3,adrLp0028AE														;51CBFFF8
adrCd0028B8:		; Memory Address ($28B8) and binary offset [$2534]
	addq.w	#$04,a0																;5848
	rts																			;4E75

adrCd0028BC:		; Memory Address ($28BC) and binary offset [$2538]
	bset	#$07,$01(a6,d4.w)													;08F600074001
	move.b	$00(a0,d3.w),d3														;16303000
	asl.w	#$04,d3																;E943
	cmp.w	d0,d3																;B640
	bcs.s	adrCd0028D0															;6504
	add.w	#$0010,d3															;06430010
adrCd0028D0:		; Memory Address ($28D0) and binary offset [$254C]
	lea		$00(a2,d3.w),a3														;47F23000
	lea		$00(a2,d0.w),a2														;45F20000
	move.b	MonsterRecord_XPosition(a2),MonsterRecord_XPosition(a3)				;176A00000000
	move.b	MonsterRecord_YPosition(a2),MonsterRecord_YPosition(a3)				;176A00010001
	move.b	MonsterRecord_Floor(a2),MonsterRecord_Floor(a3)						;176A00040004
	move.b	MonsterRecord_RotationAndSpace(a2),MonsterRecord_RotationAndSpace(a3)	;176A00020002
	move.b	MonsterRecord_TeamGroupIndex(a2),MonsterRecord_TeamGroupIndex(a3)	;176A000D000D
	move.b	#MonsterRecord_NoTeamGroup,MonsterRecord_TeamGroupIndex(a2)			;157C00FF000D
	move.b	#MonsterRecord_NoPosition,MonsterRecord_XPosition(a2)				;157C00FF0000
	bra.s	adrCd0028B8															;60B4

adrCd002904:		; Memory Address ($2904) and binary offset [$2580]
	cmp.b	#$02,$0015(a5)														;0C2D00020015
	bne.s	adrCd00291A															;660E
	bsr		Load_CurrentChampionStatRecord										;61003D4E
	tst.b	$0013(a4)															;4A2C0013
	bmi.s	adrCd00291A															;6B04
	bsr		adrCd006720															;61003E08
adrCd00291A:		; Memory Address ($291A) and binary offset [$2596]
	bsr		adrCd0084D6															;61005BBA
	bsr		adrCd002BCE															;610002AE
	move.b	#$FF,$0034(a5)														;1B7C00FF0034
	moveq	#$03,d7																;7E03
adrLp00292A:		; Memory Address ($292A) and binary offset [$25A6]
	moveq	#$00,d0																;7000
	move.b	$18(a5,d7.w),d0														;10357018
	move.w	d0,d3																;3600
	and.w	#$000F,d3															;0243000F
	and.w	#$00E0,d0															;024000E0
	beq.s	adrCd002960															;6724
	tst.b	$0050(a5)															;4A2D0050
	beq.s	adrCd00296C															;672A
	cmpi.b	#$20,d0																;0C000020
	bne.s	adrCd00296C															;6624
	move.w	d3,d0																;3003
	move.w	d7,-(sp)															;3F07
	bsr		Load_ChampionStatRecord												;61003D12
	moveq	#$16,d4																;7816
	move.w	#$FFFF,adrW_0013C4.w												;31FCFFFF13C4	;Short Absolute converted to symbol!
	bsr		adrCd0013C6															;6100EA6C
	move.w	(sp)+,d7															;3E1F
	bra.s	adrCd00296C															;600C

adrCd002960:		; Memory Address ($2960) and binary offset [$25DC]
	move.w	d3,d0																;3003
	bsr		Load_ChampionStatRecord												;61003CFC
	move.w	d7,-(sp)															;3F07
	bsr.s	Update_CharacterActionTimers										;6130
	move.w	(sp)+,d7															;3E1F
adrCd00296C:		; Memory Address ($296C) and binary offset [$25E8]
	dbra	d7,adrLp00292A														;51CFFFBC
	rts																			;4E75

Decrement_CharacterTimerLowBits:		; Memory Address ($2972) and binary offset [$25EE]
	move.b	d0,d1																;1200
	bmi.s	adrCd002982															;6B0C
	and.w	#$0007,d1															;02410007
	subq.b	#$01,d0																;5300
	subq.w	#$01,d1																;5341
	bcc.s	adrCd002982															;6402
	moveq	#$00,d0																;7000
adrCd002982:		; Memory Address ($2982) and binary offset [$25FE]
	rts																			;4E75

Update_CharacterAttackCooldown:		; Memory Address ($2984) and binary offset [$2600]
	move.b	$001B(a4),d0														;102C001B
	bsr.s	Decrement_CharacterTimerLowBits										;61E8
	move.b	$001B(a4),d1														;122C001B
	and.b	#$20,d1																;02010020
	or.b	d1,d0																;8001
	move.b	d0,$001B(a4)														;1940001B
	rts																			;4E75

Update_CharacterActionTimers:		; Memory Address ($299A) and binary offset [$2616]
	bsr.s	Update_CharacterAttackCooldown										;61E8
	move.b	$0019(a4),d0														;102C0019
	move.b	d0,d1																;1200
	and.w	#$000F,d1															;0241000F
	subq.w	#$01,d1																;5341
	bcs.s	Check_DoorToggle_AI_TBC												;6506
	subq.b	#$01,$0019(a4)														;532C0019
adrCd0029AE:		; Memory Address ($29AE) and binary offset [$262A]
	rts																			;4E75

Check_DoorToggle_AI_TBC:		; Memory Address ($29B0) and binary offset [$262C]
	move.b	d0,d1																;1200
	lsr.b	#$04,d1																;E809
	or.b	d0,d1																;8200
	move.b	d1,$0019(a4)														;19410019
	moveq	#$04,d4																;7804
	bclr	d7,$003C(a5)														;0FAD003C
	bne		Call_DoorToggleRoutine_AI_TBC										;66000082
	move.b	(a5),d0																;1015
	and.w	#$000A,d0															;0240000A
	beq.s	adrCd0029AE															;67E2
	tst.w	d7																	;4A47
	bne.s	adrCd0029D8															;6608
	cmp.b	#$02,$0015(a5)														;0C2D00020015
	bcc.s	adrCd0029AE															;64D6
adrCd0029D8:		; Memory Address ($29D8) and binary offset [$2654]
	move.w	d3,d0																;3003
	move.b	d3,adrB_00EE3E.l													;13C30000EE3E
	bsr		Load_ChampionStatRecord												;61003C7E
	tst.b	$0013(a4)															;4A2C0013
	bpl		adrCd002BB4															;6A0001CA
	move.w	d3,d0																;3003
	bsr		adrCd004092															;610016A2
	movem.w	d2/d3/d7,-(sp)														;48A73100
	bsr		PostDoorToggle_Enter_AI_TBC											;6100006C
	bmi.s	DoorToggle_Lower_AI_TBC												;6B06
	bsr		Interface_CheckSelectedCellInteraction								;610009C0
	bcs.s	adrCd002A14															;6512
DoorToggle_Lower_AI_TBC:		; Memory Address ($2A02) and binary offset [$267E]
	movem.w	(sp)+,d2/d3/d7														;4C9F008C
DoorToggle_Raise_AI_TBC:		; Memory Address ($2A06) and binary offset [$2682]
	tst.w	d7																	;4A47
	bne		adrCd002B26															;6600011C
	and.b	#$01,(a5)															;02150001
	bra		adrCd002B26															;60000114

adrCd002A14:		; Memory Address ($2A14) and binary offset [$2690]
	movem.w	(sp)+,d2/d3/d7														;4C9F008C
	tst.b	d0																	;4A00
	bmi.s	adrCd002A28															;6B0C
	cmpi.b	#$10,d0																;0C000010
	bcs.s	adrCd002A28															;6506
	tst.b	$000B(a1)															;4A29000B
	bmi.s	DoorToggle_Raise_AI_TBC												;6BDE
adrCd002A28:		; Memory Address ($2A28) and binary offset [$26A4]
	cmpi.w	#$0002,d2															;0C420002
	bcc		adrCd002B26															;640000F8
	movem.l	a4/a5,-(sp)															;48E7000C
	bsr		Prepare_PhysicalAttackContext										;61000084
	movem.l	(sp)+,a4/a5															;4CDF3000
	move.w	PhysicalAttack_WorkingValues.l,d5									;3A3900016B6C
	moveq	#$00,d4																;7800
Call_DoorToggleRoutine_AI_TBC:		; Memory Address ($2A44) and binary offset [$26C0]
	move.w	$0004(sp),d7														;3E2F0004
	movem.w	d4-d7,-(sp)															;48A70F00
	tst.w	d7																	;4A47
	bne.s	adrCd002A58															;6608
	bsr		Load_MapPosition_AI_TBC												;6100577C
	movem.w	(sp),d4-d7															;4C9700F0
adrCd002A58:		; Memory Address ($2A58) and binary offset [$26D4]
	bsr		adrCd005FC4															;6100356A
	movem.w	(sp)+,d4-d7															;4C9F00F0
	bra		adrCd0060CA															;60003668

PostDoorToggle_Enter_AI_TBC:		; Memory Address ($2A64) and binary offset [$26E0]
	bsr		adrCd008498															;61005A32
	move.w	$00(a6,d0.w),d1														;32360000
	and.w	#$0007,d1															;02410007
	subq.w	#$02,d1																;5541
	bne.s	PostDoorToggle_CheckExit_AI_TBC										;660C
	move.w	$0020(a5),d1														;322D0020
	add.w	d1,d1																;D241
	btst	d1,$00(a6,d0.w)														;03360000
	bne.s	PostDoorToggle_Default_AI_TBC										;6636
PostDoorToggle_CheckExit_AI_TBC:		; Memory Address ($2A80) and binary offset [$26FC]
	bsr		adrCd00847E															;610059FC
	cmp.w	adrW_00EE72.l,d7													;BE790000EE72
	bcc.s	PostDoorToggle_Default_AI_TBC										;642A
	swap	d7																	;4847
	cmp.w	adrW_00EE70.l,d7													;BE790000EE70
	bcc.s	PostDoorToggle_Default_AI_TBC										;6420
	move.w	$00(a6,d0.w),d1														;32360000
	and.w	#$0007,d1															;02410007
	subq.w	#$02,d1																;5541
	bne.s	PostDoorToggle_EndCase_AI_TBC										;6610
	move.w	$0020(a5),d1														;322D0020
	eor.w	#$0002,d1															;0A410002
	add.w	d1,d1																;D241
	btst	d1,$00(a6,d0.w)														;03360000
	bne.s	PostDoorToggle_Default_AI_TBC										;6604
PostDoorToggle_EndCase_AI_TBC:		; Memory Address ($2AB2) and binary offset [$272E]
	moveq	#$00,d1																;7200
	rts																			;4E75

PostDoorToggle_Default_AI_TBC:		; Memory Address ($2AB6) and binary offset [$2732]
	moveq	#-$01,d1															;72FF
	rts																			;4E75

Prepare_PhysicalAttackContext:		; Memory Address ($2ABA) and binary offset [$2736]
	clr.w	PhysicalAttack_DoubleDefenceFlag.l									;427900006458
	move.w	$0020(a5),d1														;322D0020
	tst.b	d0																	;4A00
	bpl.s	PhysicalAttack_TargetFacingPath										;6A14
	sub.w	$0020(a1),d1														;92690020
	move.w	d1,PhysicalAttack_BackstabState.l									;33C10000628A
	move.w	$0020(a5),d0														;302D0020
	bsr		adrCd006018															;61003540
	bra.s	Apply_CutpurseBackstabEligibility									;601C

PhysicalAttack_TargetFacingPath:		; Memory Address ($2ADC) and binary offset [$2758]
	move.b	$0002(a1),d2														;14290002
	cmpi.b	#$10,d0																;0C000010
	bcc.s	adrCd002AEA															;6404
	move.b	$0018(a1),d2														;14290018
adrCd002AEA:		; Memory Address ($2AEA) and binary offset [$2766]
	and.w	#$0003,d2															;02420003
	sub.w	d2,d1																;9242
	move.w	d1,PhysicalAttack_BackstabState.l									;33C10000628A
	move.w	d0,d1																;3200
Apply_CutpurseBackstabEligibility:		; Memory Address ($2AF8) and binary offset [$2774]
	move.w	d3,d0																;3003
	not.w	d0																	;4640
	and.w	#Character_ProfessionMask,d0										;Low two bits used to select one of the four character professions.
	beq.s	Execute_PhysicalAttack												;6708
	move.w	#$FFFF,PhysicalAttack_BackstabState.l								;33FCFFFF0000628A
Execute_PhysicalAttack:		; Memory Address ($2B0A) and binary offset [$2786]
	move.b	#PhysicalAttack_CooldownInitial,$001B(a4)							;Initial cooldown written whenever a champion performs a physical attack.
	move.l	a4,-(sp)															;2F0C
	move.w	d1,-(sp)															;3F01
	bsr		Resolve_PhysicalAttack												;610036C4
	move.w	(sp)+,d0															;301F
	move.w	$0000(a6),d5														;3A2E0000
	bsr		adrCd002298															;6100F778
	move.l	(sp)+,a4															;285F
	rts																			;4E75

adrCd002B26:		; Memory Address ($2B26) and binary offset [$27A2]
	move.w	d3,d1																;3203
	move.w	d1,d2																;3401
	bsr		Calculate_CutpurseLevelContribution									;6100DE20
	lea		Character_Pockets_DataTable.l,a0									;41F90000ED2A
	asl.w	#$04,d2																;E942
	add.w	d2,a0																;D0C2
	moveq	#-$01,d4															;78FF
	moveq	#-$01,d5															;7AFF
	moveq	#$01,d3																;7601
adrLp002B3E:		; Memory Address ($2B3E) and binary offset [$27BA]
	bsr.s	adrCd002B90															;6150
	dbra	d3,adrLp002B3E														;51CBFFFC
	move.w	d4,d3																;3604
	or.w	d5,d3																;8645
	tst.w	d3																	;4A43
	bmi.s	adrCd002BB4															;6B68
	move.b	$00(a0,d4.w),d2														;14304000
	subq.b	#$01,$0B(a0,d2.w)													;5330200B
	bcs.s	adrCd002B86															;6530
	subq.b	#$03,d2																;5702
	move.w	#$0088,d4															;383C0088
	add.w	d2,d4																;D842
	add.b	d2,d0																;D002
	move.b	$00(a0,d5.w),d5														;1A305000
	sub.w	#$005C,d5															;0445005C
	move.b	Bow_ActionBitShiftCounts(pc,d5.w),d2								;143B5016
	lsr.w	d2,d0																;E468
	add.b	Bow_ActionValueAdjustments(pc,d5.w),d0								;D03B5013
	add.w	d0,d0																;D040
	move.w	d0,d7																;3E00
	bsr		SpellEntity_PrepareDirection										;610027B0
	moveq	#$01,d4																;7801
	bra		Call_DoorToggleRoutine_AI_TBC										;6000FEC6

Bow_ActionBitShiftCounts:		; Memory Address ($2B80) and binary offset [$27FC]
	; Selects the bit shift applied by each of the three bow object types.
	dc.b	$01,$00,$01
Bow_ActionValueAdjustments:		; Memory Address ($2B83) and binary offset [$27FF]
	; Adds the final per-bow adjustment after the bow action value is shifted.
	dc.b	$00,$00,$01

adrCd002B86:		; Memory Address ($2B86) and binary offset [$2802]
	clr.b	$00(a0,d4.w)														;42304000
	clr.b	$0B(a0,d2.w)														;4230200B
	rts																			;4E75

adrCd002B90:		; Memory Address ($2B90) and binary offset [$280C]
	move.b	$00(a0,d3.w),d2														;14303000
	cmpi.b	#$05,d2																;0C020005
	bcc.s	adrCd002BA4															;640A
	cmpi.b	#$03,d2																;0C020003
	bcs.s	adrCd002BA2															;6502
	move.w	d3,d4																;3803
adrCd002BA2:		; Memory Address ($2BA2) and binary offset [$281E]
	rts																			;4E75

adrCd002BA4:		; Memory Address ($2BA4) and binary offset [$2820]
	cmpi.b	#$5C,d2																;0C02005C
	bcs.s	adrCd002BA2															;65F8
	cmpi.b	#$5F,d2																;0C02005F
	bcc.s	adrCd002BA2															;64F2
	move.w	d3,d5																;3A03
	rts																			;4E75

adrCd002BB4:		; Memory Address ($2BB4) and binary offset [$2830]
	tst.b	$0013(a4)															;4A2C0013
	bmi.s	adrCd002BD6															;6B1C
	bsr		CastSpell_ValidateSelection											;610022E4
	moveq	#$03,d4																;7803
	tst.b	$0013(a4)															;4A2C0013
	bmi		Call_DoorToggleRoutine_AI_TBC										;6B00FE7E
	addq.b	#$04,$0007(a4)														;582C0007
	rts																			;4E75

adrCd002BCE:		; Memory Address ($2BCE) and binary offset [$284A]
	cmp.w	#$0008,$0042(a5)													;0C6D00080042
	beq.s	adrCd002BD8															;6702
adrCd002BD6:		; Memory Address ($2BD6) and binary offset [$2852]
	rts																			;4E75

adrCd002BD8:		; Memory Address ($2BD8) and binary offset [$2854]
	bsr		Comms_GetState														;61001620
	and.b	#$3F,$0006(a4)														;022C003F0006
	subq.b	#$01,$0004(a4)														;532C0004
	bne.s	adrCd002BD6															;66EE
	tst.b	$0005(a4)															;4A2C0005
	bmi.s	adrCd002BD6															;6BE8
	move.b	$0002(a4),d0														;102C0002
	move.b	$0003(a4),$0002(a4)													;196C00030002
	move.b	d0,$0003(a4)														;19400003
	moveq	#$00,d0																;7000
	move.b	$0000(a4),d0														;102C0000
	cmpi.b	#$09,d0																;0C000009
	bne.s	adrCd002C40															;6638
	movem.l	d0/a4/a5,-(sp)														;48E7800C
	bsr		Interface_CheckSelectedCellInteraction								;610007B0
	bcc.s	adrCd002C3C															;642A
	tst.b	d0																	;4A00
	bmi.s	adrCd002C3C															;6B26
	moveq	#$00,d1																;7200
	move.b	$0006(a4),d1														;122C0006
	sub.w	#$000A,d1															;0441000A
	neg.w	d1																	;4441
	add.w	d1,d1																;D241
	move.w	d1,adrW_0020F4.w													;31C120F4	;Short Absolute converted to symbol!
	bsr		adrCd001F50															;6100F326
	btst	#$05,$03(a1,d4.w)													;083100054003
	beq.s	adrCd002C3C															;6708
	movem.l	(sp)+,d0/a4/a5														;4CDF3001
	bra		Click_ShowTeamAvatars												;600006A4

adrCd002C3C:		; Memory Address ($2C3C) and binary offset [$28B8]
	movem.l	(sp)+,d0/a4/a5														;4CDF3001
adrCd002C40:		; Memory Address ($2C40) and binary offset [$28BC]
	tst.b	$0006(a4)															;4A2C0006
	beq		adrCd00332A															;670006E4
	lea		Comms_Respond_Recruit.l,a0											;41F900002CE4
	add.w	d0,d0																;D040
	add.w	Comms_ResponseHandlerOffsets(pc,d0.w),a0							;D0FB005C
	move.l	a4,-(sp)															;2F0C
	moveq	#$00,d0																;7000
	move.b	$0035(a5),d0														;102D0035
	jsr		(a0)																;4E90
	move.l	(sp)+,a4															;285F
	moveq	#$00,d0																;7000
	move.b	$0003(a4),d0														;102C0003
	move.b	$0002(a4),$0003(a4)													;196C00020003
	move.b	d0,$0002(a4)														;19400002
	move.b	$0001(a4),$0000(a4)													;196C00010000
	or.b	#$40,$0052(a5)														;002D00400052
	move.b	$0035(a5),d0														;102D0035
	cmpi.b	#$10,d0																;0C000010
	bcs.s	adrCd002C98															;6512
	bsr		Load_ChampionStatRecord												;610039D8
	and.b	#$F0,$0019(a4)														;022C00F00019
	or.b	#$0A,$0019(a4)														;002C000A0019
adrJA002C96:		; Memory Address ($2C96) and binary offset [$2912]
	rts																			;4E75

adrCd002C98:		; Memory Address ($2C98) and binary offset [$2914]
	lea		BigMonsterList.l,a4													;49F900016A7E
	asl.w	#$04,d0																;E940
	and.b	#$F0,$0003(a4)														;022C00F00003
	or.b	#$0A,$0003(a4)														;002C000A0003
	rts																			;4E75

Comms_ResponseHandlerOffsets:		; Memory Address ($2CAE) and binary offset [$292A]
	; Selects the response handler for the other character's preceding
	; communication action.
	dc.w	Comms_Respond_Recruit-Comms_Respond_Recruit	;0000
	dc.w	adrJA002C96-Comms_Respond_Recruit	;FFB2
	dc.w	adrJA002C96-Comms_Respond_Recruit	;FFB2
	dc.w	Comms_RespondWithRetort-Comms_Respond_Recruit	;00C2
	dc.w	adrJA002C96-Comms_Respond_Recruit	;FFB2
	dc.w	adrJA002C96-Comms_Respond_Recruit	;FFB2
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
	tst.b	$0007(a4)															;4A2C0007
	bmi		Comms_RespondWithRetort												;6B0000BC
	cmpi.b	#$10,d0																;0C000010
	bcs.s	adrCd002D04															;6512
	cmp.b	#$07,$0006(a4)														;0C2C00070006
	bcs		Comms_RespondWithRetort												;650000AC
adrCd002CFC:		; Memory Address ($2CFC) and binary offset [$2978]
	lea		Msg_Recruit_Refusal.l,a6											;4DF900003162
	bra.s	adrCd002D34															;6030

adrCd002D04:		; Memory Address ($2D04) and binary offset [$2980]
	move.l	a5,-(sp)															;2F0D
	bsr		adrCd004066															;6100135E
	move.l	a5,a1																;224D
	move.l	(sp)+,a5															;2A5F
	tst.w	d1																	;4A41
	bmi.s	adrCd002D1E															;6B0C
	cmp.l	a1,a5																;BBC9
	bne.s	adrCd002CFC															;66E6
	move.b	#$FF,$0050(a5)														;1B7C00FF0050
	rts																			;4E75

adrCd002D1E:		; Memory Address ($2D1E) and binary offset [$299A]
	cmp.b	#$0A,$0006(a4)														;0C2C000A0006
	bcc.s	adrCd002D3A															;6414
	cmp.b	#$05,$0006(a4)														;0C2C00050006
	bcs.s	Comms_RespondWithRetort												;6578
	lea		Msg_Recruit_KeepTalking.l,a6										;4DF900003147
adrCd002D34:		; Memory Address ($2D34) and binary offset [$29B0]
	jmp		WriteMessage.l														;4EF90000D03A

adrCd002D3A:		; Memory Address ($2D3A) and binary offset [$29B6]
	bsr		adrCd004054															;61001318
	tst.b	$18(a5,d1.w)														;4A351018
	bpl.s	adrCd002D9E															;6A5A
	lea		adrEA00CAE6.l,a6													;4DF90000CAE6
	move.w	#$45FF,(a6)															;3CBC45FF
	jsr		Print_npc_message.l													;4EB90000D81C
	move.b	$0003(a4),d0														;102C0003
	and.w	#$000F,d0															;0240000F
	move.w	d0,d2																;3400
	bsr		Load_ChampionStatRecord												;61003900
	moveq	#$00,d7																;7E00
	move.b	$0016(a4),d7														;1E2C0016
	swap	d7																	;4847
	move.b	$0017(a4),d7														;1E2C0017
	move.b	#$FF,$0016(a4)														;197C00FF0016
	bsr		CoordToMap															;61005726
	bclr	#$07,$01(a6,d0.w)													;08B600070001
	bsr		adrCd004054															;610012D4
	move.b	d2,$18(a5,d1.w)														;1B821018
	moveq	#$03,d0																;7003
adrLp002D88:		; Memory Address ($2D88) and binary offset [$2A04]
	tst.b	$26(a5,d0.w)														;4A350026
	bmi.s	adrCd002D92															;6B04
	dbra	d0,adrLp002D88														;51C8FFF8
adrCd002D92:		; Memory Address ($2D92) and binary offset [$2A0E]
	move.b	d2,$26(a5,d0.w)														;1B820026
	bsr		adrCd00332A															;61000592
	bra		adrCd008246															;600054AA

adrCd002D9E:		; Memory Address ($2D9E) and binary offset [$2A1A]
	lea		Msg_Recruit_PartyFull.l,a6											;4DF900003100
	bra.s	adrCd002D34															;608E

Comms_RespondWithRetort:
	; Routes an action to the contextual Retort reply generator.
	moveq	#CommsAction_Retort,d1												;Communication action selected for a contextual Retort.
adrCd002DA8:		; Memory Address ($2DA8) and binary offset [$2A24]
	bra		Comms_RunAction														;60000766

Comms_Respond_LowAttitude:		; Memory Address ($2DAC) and binary offset [$2A28]
	; Selects a hostile or dismissive response when attitude is low.
	moveq	#CommsAction_Threat,d1												;Communication action selected by Threat.
	tst.b	$0007(a4)															;4A2C0007
	bmi.s	adrCd002DA8															;6BF4
	cmp.b	#$0A,$0006(a4)														;0C2C000A0006
	bcs.s	adrCd002DA8															;65EC
	bra.s	Comms_RespondWithRetort												;60E8

Comms_Respond_WhoGoesOrNameSelf:		; Memory Address ($2DBE) and binary offset [$2A3A]
	; Responds to identity questions, revealing a champion name or special monster
	; identity when permitted.
	moveq	#CommsAction_NameSelf,d1											;Communication action selected by Name Self.
	cmpi.b	#$10,d0																;0C000010
	bcs.s	adrCd002DA8															;65E2
	cmp.b	#$05,$0006(a4)														;0C2C00050006
	bcs.s	Comms_RespondWithRetort												;65D8
	lea		Msg_WhoGoes_NameUnimportant.l,a6									;4DF900003178
	lea		BigMonsterList.l,a1													;43F900016A7E
	asl.w	#$04,d0																;E940
Zendik_Named:
	cmp.b	#$40,$0B(a1,d0.w)													;0C310040000B
	bne.s	NotNamed															;6606
	lea		Msg_WhoGoes_Zendik.l,a6												;4DF900003191
NotNamed:
	bra		adrCd002D34															;6000FF48

Comms_Respond_ThyTradeOrRevealSelf:		; Memory Address ($2DEE) and binary offset [$2A6A]
	; Responds to profession questions, revealing a champion profession when
	; applicable.
	cmpi.b	#$10,d0																;0C000010
	bcc.s	Comms_RespondWithRetort												;64B2
	moveq	#CommsAction_RevealSelf,d1											;Communication action selected by Reveal Self.
	bra.s	adrCd002DA8															;60B0

Comms_Respond_Persons:		; Memory Address ($2DF8) and binary offset [$2A74]
	; Selects the response to the Persons inquiry according to attitude and
	; randomness.
	moveq	#-$02,d0															;70FE
	cmp.b	#$0A,$0006(a4)														;0C2C000A0006
	bcs.s	adrCd002E06															;6504
	bra		Comms_Action_Praise													;60000B14

adrCd002E06:		; Memory Address ($2E06) and binary offset [$2A82]
	bsr		RandomGen_BytewithOffset											;610027A4
	moveq	#CommsAction_Boast,d1												;Communication action selected by Boast.
	tst.b	d0																	;4A00
	bmi.s	adrCd002DA8															;6B98
	bra.s	Comms_RespondWithRetort												;6094

Comms_Respond_Offer:		; Memory Address ($2E12) and binary offset [$2A8E]
	; Handles acceptance and transfer of an offered held object or coinage.
	cmpi.b	#$10,d0																;0C000010
	bcs.s	Comms_RespondWithRetort												;658E
	move.w	HeldItem_ObjectCodeOffset(a5),d1									;Offset of the currently held object code in the interface state.
	cmp.b	$000A(a4),d1														;B22C000A
	bne		adrCd002FD8															;660001B6
	tst.w	d1																	;4A41
	beq.s	adrCd002E52															;672A
	cmpi.b	#Object_Permit,d1													;Permit object and exclusive end of bows.
	beq.s	adrCd002E36															;6708
	cmpi.b	#Object_Remains_First,d1											;First champion-remains object and first normally non-tradable object.
	bcc		Comms_RejectUntradeableObject										;6400023A
adrCd002E36:		; Memory Address ($2E36) and binary offset [$2AB2]
	moveq	#$00,d2																;7400
	move.b	$0008(a4),d2														;142C0008
	lea		Comms_AcceptOfferedObject.l,a0										;41F900002E5C
	add.w	d2,d2																;D442
	add.w	Comms_TradeModeHandlerOffsets(pc,d2.w),a0							;D0FB2004
	jmp		(a0)																;4ED0

Comms_TradeModeHandlerOffsets:		; Memory Address ($2E4A) and binary offset [$2AC6]
	; Selects transfer behaviour for the active purchase, exchange or sell mode.
	dc.w	Comms_AcceptOfferedObject-Comms_AcceptOfferedObject	;0000
	dc.w	Comms_BuyOfferedObject-Comms_AcceptOfferedObject	;0026
	dc.w	Comms_ExchangeOfferedObject-Comms_AcceptOfferedObject	;0088
	dc.w	Comms_AcceptOfferedObject-Comms_AcceptOfferedObject	;0000

adrCd002E52:		; Memory Address ($2E52) and binary offset [$2ACE]
	move.b	#$08,$0000(a4)														;197C00080000
	bra		Comms_RespondWithRetort												;6000FF4C

Comms_AcceptOfferedObject:		; Memory Address ($2E5C) and binary offset [$2AD8]
	; Accepts an offered object after its tradeability has been checked.
	cmpi.b	#Object_Permit,d1													;Permit object and exclusive end of bows.
	beq.s	adrCd002E76															;6714
	sub.w	#Object_TradeValueTable_First,d1									;First object represented by the trade-value lookup table.
	bcs.s	adrCd002E76															;650E
	lea		Comms_ObjectTradeValues.l,a0										;41F9000031E6
	tst.b	$00(a0,d1.w)														;4A301000
	bmi		Comms_RejectUntradeableObject										;6B0001FA
adrCd002E76:		; Memory Address ($2E76) and binary offset [$2AF2]
	clr.l	HeldItem_StateOffset(a5)											;Offset of the combined held-item quantity and object-code state.
adrCd002E7A:		; Memory Address ($2E7A) and binary offset [$2AF6]
	bsr		adrCd0035FA															;6100077E
	bra		Refresh_HeldItemDisplay												;60003DB4

Comms_BuyOfferedObject:		; Memory Address ($2E82) and binary offset [$2AFE]
	; Calculates the attitude-adjusted purchase price of an object offered by the
	; player.
	move.w	$002C(a5),d4														;382D002C
	cmp.b	$0009(a4),d4														;B82C0009
	bcs		adrCd002FD8															;6500014C
	bsr		Comms_GetMonsterTradeObject											;610003A2
	move.w	$002C(a5),d4														;382D002C
	move.w	d0,d3																;3600
	moveq	#$01,d2																;7401
	sub.b	#$14,d3																;04030014
	bcs.s	adrCd002EB4															;6514
	cmpi.b	#$5F,d0																;0C00005F
	bne.s	adrCd002EAA															;6604
	moveq	#$5A,d2																;745A
	bra.s	adrCd002EB4															;600A

adrCd002EAA:		; Memory Address ($2EAA) and binary offset [$2B26]
	lea		Comms_ObjectTradeValues.l,a1										;43F9000031E6
	move.b	$00(a1,d3.w),d2														;14313000
adrCd002EB4:		; Memory Address ($2EB4) and binary offset [$2B30]
	moveq	#$6E,d3																;766E
	sub.b	$0006(a4),d3														;962C0006
	cmp.b	#$50,d3																;B63C0050
	bcc.s	adrCd002EC2															;6402
	moveq	#$50,d3																;7650
adrCd002EC2:		; Memory Address ($2EC2) and binary offset [$2B3E]
	mulu	d3,d2																;C4C3
	divu	#$0064,d2															;84FC0064
	cmp.b	d2,d4																;B802
	bcs.s	adrCd002EDE															;6512
	move.b	#$06,$0C(a0,d1.w)													;11BC0006100C
adrCd002ED2:		; Memory Address ($2ED2) and binary offset [$2B4E]
	move.b	d0,$002F(a5)														;1B40002F
	move.w	#$0001,$002C(a5)													;3B7C0001002C
	bra.s	adrCd002E7A															;609C

adrCd002EDE:		; Memory Address ($2EDE) and binary offset [$2B5A]
	moveq	#$07,d1																;7207
	bra		adrCd002DA8															;6000FEC6

Comms_ExchangeOfferedObject:		; Memory Address ($2EE4) and binary offset [$2B60]
	; Compares offered-object values and completes an acceptable exchange.
	lea		Comms_ObjectTradeValues.l,a1										;43F9000031E6
	moveq	#$02,d2																;7402
	sub.w	#$0014,d1															;04410014
	bcs.s	adrCd002F04															;6512
	cmpi.b	#$4B,d1																;0C01004B
	bne.s	adrCd002EFC															;6604
	moveq	#$5A,d2																;745A
	bra.s	adrCd002F04															;6008

adrCd002EFC:		; Memory Address ($2EFC) and binary offset [$2B78]
	move.b	$00(a1,d1.w),d2														;14311000
	bmi		adrCd00306A															;6B000168
adrCd002F04:		; Memory Address ($2F04) and binary offset [$2B80]
	bsr		Comms_GetMonsterTradeObject											;6100032C
	move.w	d0,d4																;3800
	moveq	#$02,d3																;7602
	sub.w	#$0014,d4															;04440014
	bcs.s	adrCd002F16															;6504
	move.b	$00(a1,d4.w),d3														;16314000
adrCd002F16:		; Memory Address ($2F16) and binary offset [$2B92]
	cmp.b	d3,d2																;B403
	bcs		adrCd002FB0															;65000096
	move.b	$002F(a5),$0C(a0,d1.w)												;11AD002F100C
	bra.s	adrCd002ED2															;60AE

Comms_Respond_Purchase:		; Memory Address ($2F24) and binary offset [$2BA0]
	; Selects trader merchandise and produces the response to Purchase.
	cmpi.b	#$10,d0																;0C000010
	bcs		Comms_RespondWithRetort												;6500FE7C
Comms_SelectTraderStock:
	; Uses the monster type to select or initialise the object offered for sale.
	bsr		Comms_GetMonsterTradeObject											;61000304
	lea		$00(a0,d1.w),a1														;43F01000
	cmp.b	#$15,$000B(a1)														;0C290015000B
	bcs.s	Comms_PrintPurchaseObject											;6510
	cmp.b	#$17,$000B(a1)														;0C290017000B
	bcc.s	Comms_PrintPurchaseObject											;6408
	bsr		Comms_InitialiseMonsterTrader										;61000336
	move.b	$000C(a1),d0														;1029000C
Comms_PrintPurchaseObject:
	; Builds the purchase response using the monster's currently offered object.
	bra		adrCd0038D2															;60000984

Comms_Respond_Exchange:
	; Compares the offered and requested object values and begins an exchange when
	; acceptable.
	cmpi.b	#$10,d0																;0C000010
	bcs		Comms_RespondWithRetort												;6500FE50
	move.w	$002E(a5),d1														;322D002E
	cmp.b	$000A(a4),d1														;B22C000A
	bne		adrCd002FD8															;66000076
	tst.w	d1																	;4A41
	beq.s	Comms_SelectTraderStock												;67C4
	lea		Comms_ObjectTradeValues.l,a1										;43F9000031E6
	cmpi.b	#$5F,d1																;0C01005F
	bne.s	Comms_CompareExchangeObject											;6604
	moveq	#$5A,d2																;745A
	bra.s	adrCd002F90															;6018

Comms_CompareExchangeObject:
	; Loads the trade value of the held object for an exchange comparison.
	cmpi.b	#$40,d1																;0C010040
	bcc		Comms_RejectUntradeableObject										;640000F0
	moveq	#$02,d2																;7402
	sub.w	#$0014,d1															;04410014
	bcs.s	adrCd002F90															;6508
	move.b	$00(a1,d1.w),d2														;14311000
	bmi		adrCd00306A															;6B0000DC
adrCd002F90:		; Memory Address ($2F90) and binary offset [$2C0C]
	bsr		Comms_GetMonsterTradeObject											;610002A0
	move.w	d0,d1																;3200
	moveq	#$02,d3																;7602
	sub.w	#$0014,d1															;04410014
	bcs.s	adrCd002FA2															;6504
	move.b	$00(a1,d1.w),d3														;16311000
adrCd002FA2:		; Memory Address ($2FA2) and binary offset [$2C1E]
	cmp.b	d3,d2																;B403
	bcs.s	adrCd002FB0															;650A
	move.b	#$12,$0001(a4)														;197C00120001
	bra		adrCd00383E															;60000890

adrCd002FB0:		; Memory Address ($2FB0) and binary offset [$2C2C]
	lea		Msg_Trade_OfferTooLow.l,a6											;4DF9000031D2
	jmp		Print_npc_message.l													;4EF90000D81C

adrCd002FBC:		; Memory Address ($2FBC) and binary offset [$2C38]
	clr.b	$0008(a4)															;422C0008
	bra		Comms_RespondWithRetort												;6000FDE4

Comms_Respond_Sell:		; Memory Address ($2FC4) and binary offset [$2C40]
	; Handles the response to Sell and validates the held object and quoted value.
	cmpi.b	#$10,d0																;0C000010
	bcs		Comms_RespondWithRetort												;6500FDDC
	move.w	$002E(a5),d0														;302D002E
	beq.s	adrCd002FBC															;67EA
	cmp.b	$000A(a4),d0														;B02C000A
	beq.s	adrCd002FEE															;6716
adrCd002FD8:		; Memory Address ($2FD8) and binary offset [$2C54]
	subq.b	#$05,$0006(a4)														;5B2C0006
	bpl.s	adrCd002FE2															;6A04
	clr.b	$0006(a4)															;422C0006
adrCd002FE2:		; Memory Address ($2FE2) and binary offset [$2C5E]
	lea		Msg_Trade_RipOff.l,a6												;4DF900003112
	jmp		WriteMessage.l														;4EF90000D03A

adrCd002FEE:		; Memory Address ($2FEE) and binary offset [$2C6A]
	cmpi.b	#$5F,d0																;0C00005F
	bne.s	adrCd002FF8															;6604
	moveq	#$5A,d0																;705A
	bra.s	adrCd003016															;601E

adrCd002FF8:		; Memory Address ($2FF8) and binary offset [$2C74]
	cmpi.b	#$40,d0																;0C000040
	bcc.s	Comms_RejectUntradeableObject										;6470
	sub.b	#$14,d0																;04000014
	bcc.s	adrCd00300A															;6406
	moveq	#$01,d0																;7001
	bra		Comms_PrintGoldOffer												;6000023A

adrCd00300A:		; Memory Address ($300A) and binary offset [$2C86]
	lea		Comms_ObjectTradeValues.l,a0										;41F9000031E6
	move.b	$00(a0,d0.w),d0														;10300000
	bmi.s	adrCd00306A															;6B54
adrCd003016:		; Memory Address ($3016) and binary offset [$2C92]
	moveq	#$00,d2																;7400
	move.b	$0009(a4),d2														;142C0009
	bne.s	adrCd00303E															;6620
	moveq	#$00,d1																;7200
	move.b	$0006(a4),d1														;122C0006
	sub.w	#$000A,d1															;0441000A
	add.w	#$003C,d1															;0641003C
	cmp.w	#$0064,d1															;B27C0064
	bcc		Comms_PrintGoldOffer												;64000210
	mulu	d1,d0																;C0C1
	divu	#$0064,d0															;80FC0064
	bra		Comms_PrintGoldOffer												;60000206

adrCd00303E:		; Memory Address ($303E) and binary offset [$2CBA]
	bpl.s	adrCd003054															;6A14
	clr.b	$0008(a4)															;422C0008
	lea		Msg_Trade_TooGreedy.l,a6											;4DF9000031B4
	move.b	#$19,$0001(a4)														;197C00190001
	bra		adrCd002D34															;6000FCE2

adrCd003054:		; Memory Address ($3054) and binary offset [$2CD0]
	cmp.b	#$0F,$0006(a4)														;0C2C000F0006
	bcs.s	adrCd003094															;6538
	sub.b	d2,d0																;9002
	lsr.b	#$01,d0																;E208
	add.b	d2,d0																;D002
	bset	#$07,d0																;08C00007
	bra		Comms_PrintGoldOffer												;600001DA

adrCd00306A:		; Memory Address ($306A) and binary offset [$2CE6]
	clr.b	$0008(a4)															;422C0008
Comms_RejectUntradeableObject:
	; Rejects an object that cannot safely participate in trading.
	move.b	#$07,$0001(a4)														;197C00070001
	lea		Msg_Trade_UnnaturalObject.l,a6										;4DF90000312B
	bra		adrCd002D34															;6000FCB8

Comms_Respond_Praise:		; Memory Address ($307E) and binary offset [$2CFA]
	; Selects a complimentary, neutral or hostile response to Praise from the
	; current attitude.
	moveq	#CommsAction_Praise,d1												;Communication action selected by Praise.
	cmp.b	#$0A,$0006(a4)														;0C2C000A0006
	bcc		adrCd002DA8															;6400FD20
	cmp.b	#$05,$0006(a4)														;0C2C00050006
	bcc		Comms_RespondWithRetort												;6400FD14
adrCd003094:		; Memory Address ($3094) and binary offset [$2D10]
	moveq	#$17,d1																;7217
	bra		adrCd002DA8															;6000FD10

Comms_Respond_Curse:		; Memory Address ($309A) and binary offset [$2D16]
	; Selects a curse, retort or threat response according to attitude and
	; patience.
	moveq	#CommsAction_Curse,d1												;Communication action selected by Curse.
	cmp.b	#$05,$0006(a4)														;0C2C00050006
	bcc		adrCd002DA8															;6400FD04
	tst.b	$0007(a4)															;4A2C0007
	bpl		Comms_RespondWithRetort												;6A00FCFA
	moveq	#$09,d1																;7209
	bra		adrCd002DA8															;6000FCF6

Comms_Respond_Boast:		; Memory Address ($30B4) and binary offset [$2D30]
	; Selects a praise, boast, retort or hostile response to Boast.
	cmp.b	#$0A,$0006(a4)														;0C2C000A0006
	bcc.s	Comms_Respond_Praise												;64C2
	moveq	#CommsAction_Boast,d1												;Communication action selected by Boast.
	cmp.b	#$07,$0006(a4)														;0C2C00070006
	bcc		adrCd002DA8															;6400FCE2
	tst.b	$0007(a4)															;4A2C0007
	bmi.s	Comms_Respond_Curse													;6BCC
	bra		Comms_RespondWithRetort												;6000FCD6

Comms_Respond_Greeting:		; Memory Address ($30D2) and binary offset [$2D4E]
	; Selects the initial reply, ranging from hostility to an identity or
	; profession question.
	cmp.b	#$02,$0006(a4)														;0C2C00020006
	bcs		Comms_Respond_LowAttitude											;6500FCD2
	cmp.b	#$05,$0006(a4)														;0C2C00050006
	bcs.s	Comms_Respond_Curse													;65B6
	cmp.b	#$08,$0006(a4)														;0C2C00080006
	bcs		Comms_RespondWithRetort												;6500FCBA
	bsr		RandomGen_BytewithOffset											;610024BC
	moveq	#CommsAction_WhoGoes,d1												;Communication action selected by Who Goes.
	tst.b	d0																	;4A00
	bmi		adrCd002DA8															;6B00FCB0
	moveq	#CommsAction_ThyTrade,d1											;Communication action selected by Thy Trade.
	bra		adrCd002DA8															;6000FCAA

Msg_Recruit_PartyFull:
	; Character response when Recruit succeeds on attitude but the party has no
	; free slot.
	dc.b	'THY PARTY IS FULL'	;5448592050415254592049532046554C4C
	dc.b	$FF	;FF
Msg_Trade_RipOff:
	; Character response when the held object or trade state no longer matches the
	; proposed deal.
	dc.b	'WOULDST THOU RIP ME OFF?'	;574F554C4453542054484F5520524950204D45204F46463F
	dc.b	$FF	;FF
Msg_Trade_UnnaturalObject:
	; Character response rejecting an untradeable or unnatural object.
	dc.b	'I NEVER TRUST THE UNNATURAL'	;49204E455645522054525553542054484520554E4E41545552414C
	dc.b	$FF	;FF
Msg_Recruit_KeepTalking:
	; Character response when Recruit attitude is promising but below the joining
	; threshold.
	dc.b	'KEEP TALKING AND WE''LL SEE'	;4B4545502054414C4B494E4720414E44205745274C4C20534545
	dc.b	$FF	;FF
Msg_Recruit_Refusal:
	; Character response refusing recruitment or interaction.
	dc.b	'I THINK NOT MY FRIEND'	;49205448494E4B204E4F54204D5920465249454E44
	dc.b	$FF	;FF
Msg_WhoGoes_NameUnimportant:
	; Monster response refusing to reveal a name.
	dc.b	'MY NAME IS NOT IMPORTANT'	;4D59204E414D45204953204E4F5420494D504F5254414E54
	dc.b	$FF	;FF
Msg_WhoGoes_Zendik:
	; Special identity response used when the addressed monster is Zendik.
	dc.b	'I AM ZENDIK THE MASTER OF CREATION'	;4920414D205A454E44494B20544845204D4153544552204F46204352454154494F4E
	dc.b	$FF	;FF
Msg_Trade_TooGreedy:
	; Character response when a trade request becomes too greedy.
	dc.b	'METHINKS THOU ART TOO GREEDY!'	;4D455448494E4B532054484F552041525420544F4F2047524545445921
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
	move.w	d0,d1																;3200
	lea		BigMonsterList.l,a0													;41F900016A7E
	asl.w	#$04,d1																;E941
	move.b	$0C(a0,d1.w),d0														;1030100C
	rts																			;4E75

Comms_PrintGoldOffer:
	; Formats a calculated trade value into the packed gold-offer message.
	move.b	d0,$0009(a4)														;19400009
	and.w	#$007F,d0															;0240007F
	jsr		Convert_ByteToDecimalText.l											;4EB90000CEC4
	lea		Msg_Trade_GoldOfferTemplate.w,a6									;4DF831D9	;Short Absolute converted to symbol!
	moveq	#$06,d2																;7406
	ror.w	#$08,d1																;E059
	cmpi.b	#$30,d1																;0C010030
	beq.s	adrCd00326A															;670C
	move.b	d1,$00(a6,d2.w)														;1D812000
	move.b	#$FA,$01(a6,d2.w)													;1DBC00FA2001
	addq.w	#$02,d2																;5442
adrCd00326A:		; Memory Address ($326A) and binary offset [$2EE6]
	ror.w	#$08,d1																;E059
	move.b	d1,$00(a6,d2.w)														;1D812000
	move.b	#$54,$01(a6,d2.w)													;1DBC00542001
	addq.w	#$02,d2																;5442
	bra		adrCd0038DC															;60000662

Comms_InitialiseMonsterTrader:
	; Initialises monster-trader stock and applies the monster's initial attitude
	; penalty.
	movem.w	d0/d1,-(sp)															;48A7C000
	move.b	#$03,$0006(a4)														;197C00030006
	cmp.b	#$40,$000B(a1)														;0C290040000B
	beq.s	adrCd0032D8															;674A
	bsr		RandomGen_BytewithOffset											;6100231C
	cmp.b	#$16,$000B(a1)														;0C290016000B
	bne.s	.Trader_NotPotionsButArms											;660E
	and.w	#$0003,d0															;02400003
	add.w	#$0017,d0															;06400017
	move.b	d0,$000C(a1)														;1340000C
	bra.s	adrCd0032D8															;6030

.Trader_NotPotionsButArms:		; Memory Address ($32A8) and binary offset [$2F24]
	and.w	#$001F,d0															;0240001F
	move.b	$0006(a1),d1														;12290006
	cmpi.b	#$08,d1																;0C010008
	bcc.s	.DontDivideList														;640A
	lsr.w	#$01,d0																;E248
	cmpi.b	#$04,d1																;0C010004
	bcc.s	.DontDivideList														;6402
	lsr.w	#$01,d0																;E248
.DontDivideList:		; Memory Address ($32C0) and binary offset [$2F3C]
	lea		Comms_TraderStockObjects.w,a0										;41F83212	;Short Absolute converted to symbol!
	move.b	$00(a0,d0.w),$000C(a1)												;13700000000C
	move.b	$0006(a1),d0														;10290006
	and.w	#$007F,d0															;0240007F
	neg.b	d0																	;4400
	move.b	d0,$0006(a4)														;19400006
adrCd0032D8:		; Memory Address ($32D8) and binary offset [$2F54]
	movem.w	(sp)+,d0/d1															;4C9F0003
	rts																			;4E75

Click_ShowTeamAvatars:		; Memory Address ($32DE) and binary offset [$2F5A]
	move.b	#$01,$0052(a5)														;1B7C00010052
	clr.b	$004A(a5)															;422D004A
	tst.b	$004B(a5)															;4A2D004B
	bmi.s	adrCd0032F4															;6B06
	move.w	#$00FF,$004A(a5)													;3B7C00FF004A
adrCd0032F4:		; Memory Address ($32F4) and binary offset [$2F70]
	cmp.w	#$0008,$0042(a5)													;0C6D00080042
	beq.s	adrCd003312															;6716
	tst.w	$0042(a5)															;4A6D0042
	bne.s	adrCd00332A															;6628
	move.w	#$FFFF,$0042(a5)													;3B7CFFFF0042
	move.w	#$FFFF,$0040(a5)													;3B7CFFFF0040
	bra		Draw_PartyCommandInterface											;60004840

adrCd003312:		; Memory Address ($3312) and binary offset [$2F8E]
	cmp.w	#$0006,$0044(a5)													;0C6D00060044
	bcs.s	adrCd00332A															;6510
adrCd00331A:		; Memory Address ($331A) and binary offset [$2F96]
	lsr.w	$0044(a5)															;E2ED0044
	addq.w	#$01,$0044(a5)														;526D0044
	bsr		adrCd003344															;61000020
	bra		Draw_PartyCommandMenu												;60004A44

adrCd00332A:		; Memory Address ($332A) and binary offset [$2FA6]
	clr.w	$0042(a5)															;426D0042
	clr.w	$0044(a5)															;426D0044
	move.b	#$FF,$0035(a5)														;1B7C00FF0035
adrCd003338:		; Memory Address ($3338) and binary offset [$2FB4]
	move.l	#$003B003B,d7														;2E3C003B003B
	bsr.s	adrCd00334A															;610A
	bra		Draw_PartyCommandMenu												;60004A2A

adrCd003344:		; Memory Address ($3344) and binary offset [$2FC0]
	move.l	#$00760075,d7														;2E3C00760075
adrCd00334A:		; Memory Address ($334A) and binary offset [$2FC6]
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$0647,a0															;D0FC0647
	add.w	$000A(a5),a0														;D0ED000A
	move.w	d7,d0																;3007
	swap	d7																	;4847
	jsr		Draw_PocketGraphic.l												;4EB90000CAEA
	move.w	d7,d0																;3007
	jmp		Draw_PocketGraphic.l												;4EF90000CAEA

PartyCommand_DispatchSelection:		; Memory Address ($336A) and binary offset [$2FE6]
	; Decodes the selected party-command button from the interface selection bytes
	; and dispatches the current party-command state.
	move.l	$0046(a5),a6														;Loads the packed command-row definition used to translate the selected button into a party-command index.
	moveq	#$00,d1																;7200
	move.b	$0040(a5),d0														;102D0040
	and.w	#$0003,d0															;02400003
	subq.b	#$01,d0																;5300
	bcs.s	adrCd00338A															;650E
adrLp00337C:		; Memory Address ($337C) and binary offset [$2FF8]
	addq.w	#$01,d1																;5241
	cmp.b	#$5F,(a6)+															;Command descriptors below $5F consume an additional position while the visible command rows are flattened into one index.
	bcc.s	adrCd003386															;6402
	addq.w	#$01,d1																;5241
adrCd003386:		; Memory Address ($3386) and binary offset [$3002]
	dbra	d0,adrLp00337C														;51C8FFF4
adrCd00338A:		; Memory Address ($338A) and binary offset [$3006]
	add.b	$0041(a5),d1														;Adds the selected command sub-index to the command index derived from the packed row definition.
PartyCommand_DispatchState:		; Memory Address ($338E) and binary offset [$300A]
	; Dispatches party-command states 0 through 8 through
	; PartyCommand_HandlerOffsets: resolve selection, Communicate, Commend, View,
	; Wait, Correct, Dismiss, Call, or handle the active communication menu.
	move.w	$0042(a5),d0														;Loads party-command state 0 through 8 for dispatch through the handler-offset table.
	add.w	d0,d0																;D040
	lea		PartyCommand_ResolveSelection.l,a0									;41F9000033B2
	add.w	PartyCommand_HandlerOffsets(pc,d0.w),a0								;Adds the selected word-relative offset to the common table base to obtain the party-command handler address.
	jmp		(a0)																;4ED0

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
	bra.s	PartyCommand_DispatchState											;60D0

Interface_CheckSelectedCellInteraction:		; Memory Address ($33BE) and binary offset [$303A]
	; Checks map bounds and selected-cell metadata, then resolves an interaction
	; target; Communicate uses its carry result, but this helper is also called by
	; other interface paths.
	bsr		adrCd00847E															;610050BE
	move.l	d7,d2																;2407
	cmp.w	adrW_00EE72.l,d7													;BE790000EE72
	bcc.s	adrCd0033EC															;6420
	swap	d7																	;4847
	cmp.w	adrW_00EE70.l,d7													;BE790000EE70
	bcc.s	adrCd0033EC															;6416
	move.b	$01(a6,d0.w),d1														;12360001
	bpl.s	adrCd0033EC															;6A10
	and.w	#$0007,d1															;02410007
	subq.w	#$01,d1																;5341
	beq.s	adrCd0033EC															;6708
	move.w	$0058(a5),d1														;322D0058
	bra		Find_DungeonCellOccupant											;600064BE

adrCd0033EC:		; Memory Address ($33EC) and binary offset [$3068]
	rts																			;4E75

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
	jmp		Print_timed_message.l												;4EF90000D86A

Comms_StartWithTarget:		; Memory Address ($3402) and binary offset [$307E]
	; Initialises communication state for the selected champion or monster and
	; prints the greeting.
	move.w	d0,d1																;3200
	bsr		Load_CurrentChampionStatRecord										;61003256
	move.b	#$17,$001B(a4)														;197C0017001B
	move.w	d1,d0																;3001
	bsr		Comms_GetState														;61000DE8
	clr.b	$0006(a4)															;422C0006
	move.b	#CommsAction_Greeting,CommsState_PreviousActionOffset(a4)			;Initial communication action used when a conversation begins.
	bclr	#$07,$0005(a4)														;08AC00070005
	tst.b	d0																	;4A00
	bmi.s	adrCd003458															;6B30
	move.w	$0020(a5),d1														;322D0020
	eor.w	#$0002,d1															;0A410002
	moveq	#$18,d4																;7818
	cmpi.w	#$0010,d0															;0C400010
	bcs.s	adrCd003444															;650C
	tst.b	$000B(a1)															;4A29000B
	bmi.s	Interface_ReportCommunicationTargetUnavailable						;6BB4
	bsr		Comms_InitialiseMonsterTrader										;6100FE3C
	moveq	#$02,d4																;7802
adrCd003444:		; Memory Address ($3444) and binary offset [$30C0]
	and.b	#$F0,$00(a1,d4.w)													;023100F04000
	or.b	$00(a1,d4.w),d1														;82314000
	move.b	d1,$00(a1,d4.w)														;13814000
	move.b	d0,$0035(a5)														;1B400035
	bra.s	adrCd003462															;600A

adrCd003458:		; Memory Address ($3458) and binary offset [$30D4]
	bset	#$07,$0005(a4)														;08EC00070005
	move.w	$0006(a1),d0														;30290006
adrCd003462:		; Memory Address ($3462) and binary offset [$30DE]
	move.b	$0007(a5),$0003(a4)													;196D00070003
	and.w	#$007F,d0															;0240007F
	move.b	d0,$0002(a4)														;19400002
	move.l	a4,-(sp)															;2F0C
	bsr		Load_CurrentChampionStatRecord										;610031E8
	move.b	ChampionStat_Charisma(a4),d2										;Offset of Charisma in a thirty-two-byte champion-stat record.
	move.l	(sp)+,a4															;285F
	bsr		RandomGen_BytewithOffset											;6100212E
	and.w	#$0007,d0															;02400007
	addq.w	#$02,d0																;5440
	sub.b	#Comms_CharismaBaseline,d2											;Charisma receives no initial communication bonus at or below this value.
	bcc.s	adrCd00348E															;6402
	moveq	#$00,d2																;7400
adrCd00348E:		; Memory Address ($348E) and binary offset [$310A]
	lsr.b	#Comms_CharismaShift,d2												;Right shift converting excess Charisma into an initial attitude bonus.
	add.b	d2,d0																;D002
	add.b	CommsState_AttitudeOffset(a4),d0									;Offset of mutable communication attitude or rapport.
	bpl.s	adrCd00349A															;6A02
	moveq	#$00,d0																;7000
adrCd00349A:		; Memory Address ($349A) and binary offset [$3116]
	move.b	d0,CommsState_AttitudeOffset(a4)									;Offset of mutable communication attitude or rapport.
	bsr		RandomGen_BytewithOffset											;6100210C
	and.w	#$0007,d0															;02400007
	addq.w	#$08,d0																;5040
	move.b	d0,CommsState_PatienceOffset(a4)									;Offset of communication patience or remaining engagement.
	move.b	#$14,$0004(a4)														;197C00140004
	clr.b	$0008(a4)															;422C0008
	lea		Msg_Greeting.l,a6													;4DF900003DF7
	jsr		Print_npc_message.l													;4EB90000D81C
	move.w	#$0004,$0044(a5)													;3B7C00040044
	bra		adrCd003D9C															;600008D2

Comms_HandleMenuSelection:		; Memory Address ($34CC) and binary offset [$3148]
	; Converts the visible communication menu and button into an action and runs
	; it.
	move.w	InterfaceState_MenuOffset(a5),d0									;302D0044
	subq.w	#$04,d0																;5940
	beq.s	adrCd0034E0															;670C
	addq.w	#$04,d1																;5841
	subq.w	#$01,d0																;5340
	beq.s	adrCd0034E0															;6706
	addq.w	#$02,d1																;5441
	asl.w	#$02,d0																;E540
	add.w	d0,d1																;D240
adrCd0034E0:		; Memory Address ($34E0) and binary offset [$315C]
	bsr		Comms_GetState														;61000D18
	addq.b	#$01,CommsState_AttitudeOffset(a4)									;Offset of mutable communication attitude or rapport.
	bsr.s	Comms_RunAction														;6126
	cmp.w	#$0006,InterfaceState_MenuOffset(a5)								;0C6D00060044
	bcs.s	adrCd0034FE															;650C
	cmp.b	#$06,$0001(a4)														;0C2C00060001
	bcs.s	adrCd00350E															;6514
	bsr		adrCd00331A															;6100FE1E
adrCd0034FE:		; Memory Address ($34FE) and binary offset [$317A]
	move.b	#$14,$0004(a4)														;197C00140004
	move.b	CommsState_CurrentActionOffset(a4),CommsState_PreviousActionOffset(a4)	;Offset of the communication action currently being performed.
	subq.b	#$01,CommsState_PatienceOffset(a4)									;Offset of communication patience or remaining engagement.
adrCd00350E:		; Memory Address ($350E) and binary offset [$318A]
	rts																			;4E75

Comms_RunAction:		; Memory Address ($3510) and binary offset [$318C]
	; Stores and dispatches one communication action.
	move.b	d1,CommsState_CurrentActionOffset(a4)								;Offset of the communication action currently being performed.
	add.w	d1,d1																;D241
	lea		Comms_Action_Recruit.l,a0											;41F90000355C
	add.w	Comms_ActionHandlerOffsets(pc,d1.w),a0								;D0FB1008
	bsr		RandomGen_BytewithOffset											;6100208A
	jmp		(a0)																;4ED0

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
	lea		Msg_Recruit.l,a6													;4DF900003E83
	jmp		WriteMessage.l														;4EF90000D03A

Comms_Action_None:		; Memory Address ($3568) and binary offset [$31E4]
	; No-operation handler used by the final communication action slot.
	rts																			;4E75

Comms_Action_Identify:		; Memory Address ($356A) and binary offset [$31E6]
	; Opens the Identify communication submenu.
	addq.w	#$02,$0044(a5)														;546D0044
	bra		adrCd003338															;6000FDC8

Comms_Action_Inquiry:		; Memory Address ($3572) and binary offset [$31EE]
	; Opens the Inquiry communication submenu.
	addq.w	#$03,$0044(a5)														;566D0044
	bra		adrCd003338															;6000FDC0

Comms_Action_Whereabouts:		; Memory Address ($357A) and binary offset [$31F6]
	; Communicates the Whereabouts question.
	lea		Msg_Whereabouts.l,a6												;4DF900003E2F
	jmp		WriteMessage.l														;4EF90000D03A

Comms_Action_Trading:		; Memory Address ($3586) and binary offset [$3202]
	; Opens the Trading communication submenu.
	addq.w	#$03,$0044(a5)														;566D0044
	bra		adrCd003338															;6000FDAC

Comms_Action_Smalltalk:		; Memory Address ($358E) and binary offset [$320A]
	; Opens the Smalltalk communication submenu.
	addq.w	#$04,$0044(a5)														;586D0044
	bra		adrCd003338															;6000FDA4

Comms_Action_Yes:		; Memory Address ($3596) and binary offset [$3212]
	; Communicates Yes and completes an accepted object or coinage transfer when
	; one is pending.
	move.b	$0008(a4),d2														;142C0008
	subq.b	#CommsTradeMode_Exchange,d2											;Exchange communication mode.
	bcs.s	adrCd0035FE															;6560
	bne.s	adrCd0035DC															;663C
	cmp.b	#CommsAction_Offer,CommsState_PreviousActionOffset(a4)				;Communication action selected by Offer.
	bne.s	adrCd0035FE															;6656
	move.w	$002E(a5),d0														;302D002E
	cmp.b	$000A(a4),d0														;B02C000A
	bne.s	adrCd0035FA															;6648
	move.b	$0035(a5),d0														;102D0035
	cmpi.b	#$10,d0																;0C000010
	bcs.s	adrCd0035FE															;6542
	bsr		Comms_GetMonsterTradeObject											;6100FC74
	move.b	$002F(a5),$0C(a0,d1.w)												;11AD002F100C
	move.b	d0,$002F(a5)														;1B40002F
	move.w	#$0001,$002C(a5)													;3B7C0001002C
adrCd0035D0:		; Memory Address ($35D0) and binary offset [$324C]
	move.b	#CommsAction_Boast,CommsState_CurrentActionOffset(a4)				;Communication action selected by Boast.
	bsr.s	adrCd0035FA															;6122
	bra		Refresh_HeldItemDisplay												;6000365A

adrCd0035DC:		; Memory Address ($35DC) and binary offset [$3258]
	move.b	$000A(a4),d0														;102C000A
	cmp.b	$002F(a5),d0														;B02D002F
	bne.s	adrCd0035FA															;6614
	and.b	#$7F,$0009(a4)														;022C007F0009
	move.b	$0009(a4),$002D(a5)													;1B6C0009002D
	move.w	#$0001,$002E(a5)													;3B7C0001002E
	bra.s	adrCd0035D0															;60D6

adrCd0035FA:		; Memory Address ($35FA) and binary offset [$3276]
	clr.b	$0008(a4)															;422C0008
adrCd0035FE:		; Memory Address ($35FE) and binary offset [$327A]
	move.w	#$45FF,d0															;303C45FF
	bra.s	adrCd003626															;6022

Comms_Action_No:		; Memory Address ($3604) and binary offset [$3280]
	; Communicates No and cancels or refuses the active trading mode.
	move.w	#$3DFF,d0															;303C3DFF
	move.b	$0008(a4),d1														;122C0008
	beq.s	adrCd003626															;6718
	add.b	#CommsAction_Offer,d1												;Communication action selected by Offer.
	move.b	d1,$0001(a4)														;19410001
	cmpi.b	#CommsAction_Sell,d1												;Communication action selected by Sell.
	bne.s	adrCd003626															;660A
	subq.b	#$04,CommsState_AttitudeOffset(a4)									;Offset of mutable communication attitude or rapport.
	bpl.s	adrCd003626															;6A04
	clr.b	$0006(a4)															;422C0006
adrCd003626:		; Memory Address ($3626) and binary offset [$32A2]
	subq.b	#$01,CommsState_AttitudeOffset(a4)									;Offset of mutable communication attitude or rapport.
	bpl.s	adrCd003630															;6A04
	clr.b	$0006(a4)															;422C0006
adrCd003630:		; Memory Address ($3630) and binary offset [$32AC]
	lea		adrEA00CAE6.l,a6													;4DF90000CAE6
	move.w	d0,(a6)																;3C80
	jmp		Print_npc_message.l													;4EF90000D81C

Comms_Action_Bribe:		; Memory Address ($363E) and binary offset [$32BA]
	; Communicates the Bribe question.
	lea		Msg_Bribe.l,a6														;4DF900003E26
	jmp		Print_npc_message.l													;4EF90000D81C

Comms_Action_Threat:		; Memory Address ($364A) and binary offset [$32C6]
	; Builds a randomized threat and reduces attitude.
	lea		Comms_MessageBuffer.l,a6											;4DF900003DC0
	and.w	#$0003,d0															;02400003
	lea		Comms_ThreatOpeningFragments.l,a3									;47F900003DDE
	bsr		Comms_CopyThreatFragment											;61000084
	move.b	CommsState_AttitudeOffset(a4),d0									;Offset of mutable communication attitude or rapport.
	subq.b	#$03,CommsState_AttitudeOffset(a4)									;Offset of mutable communication attitude or rapport.
	bpl.s	adrCd00366C															;6A04
	clr.b	$0006(a4)															;422C0006
adrCd00366C:		; Memory Address ($366C) and binary offset [$32E8]
	cmpi.b	#$0A,d0																;0C00000A
	bcs.s	adrCd0036A2															;6530
adrCd003672:		; Memory Address ($3672) and binary offset [$32EE]
	move.b	$0002(a4),d0														;102C0002
	bpl.s	adrCd003680															;6A08
	and.w	#$000F,d0															;0240000F
	move.b	d0,(a6)+															;1CC0
	bra.s	adrCd0036D0															;6050

adrCd003680:		; Memory Address ($3680) and binary offset [$32FC]
	move.b	#$99,(a6)+															;1CFC0099
	move.b	#$C3,d1																;123C00C3
	btst	#$06,d0																;08000006
	beq.s	adrCd00369E															;6710
	move.b	#$9E,d1																;123C009E
	and.w	#$0003,d0															;02400003
	beq.s	adrCd00369E															;6706
	add.b	#$5B,d0																;0600005B
	move.b	d0,d1																;1200
adrCd00369E:		; Memory Address ($369E) and binary offset [$331A]
	move.b	d1,(a6)+															;1CC1
	bra.s	adrCd0036D0															;602E

adrCd0036A2:		; Memory Address ($36A2) and binary offset [$331E]
	move.b	#$62,(a6)+															;1CFC0062
	bsr		RandomGen_BytewithOffset											;61001F04
	and.w	#$0003,d0															;02400003
	lea		Comms_ThreatConsequenceFragments.l,a3								;47F900003DEE
	bsr.s	Comms_CopyThreatFragment											;612A
	cmp.b	#$06,$0006(a4)														;0C2C00060006
	bcc.s	adrCd003672															;64B4
	move.b	#$1A,(a6)+															;1CFC001A
	bsr		RandomGen_BytewithOffset											;61001EE8
	and.w	#$0007,d0															;02400007
	add.b	#$B6,d0																;060000B6
	move.b	d0,(a6)+															;1CC0
adrCd0036D0:		; Memory Address ($36D0) and binary offset [$334C]
	move.b	#$FF,(a6)															;1CBC00FF
	lea		Comms_MessageBuffer.l,a6											;4DF900003DC0
	jmp		Print_npc_message.l													;4EF90000D81C

Comms_CopyThreatFragment:		; Memory Address ($36E0) and binary offset [$335C]
	; Copies one length-prefixed threat fragment into the communication message
	; buffer.
	jsr		Proceed_in_stringtable.l											;4EB90000D7CC
	subq.w	#$01,d5																;5345
adrLp0036E8:		; Memory Address ($36E8) and binary offset [$3364]
	move.b	(a3)+,(a6)+															;1CDB
	dbra	d5,adrLp0036E8														;51CDFFFC
	rts																			;4E75

Comms_Action_WhoGoes:		; Memory Address ($36F0) and binary offset [$336C]
	; Communicates the Who Goes identity question.
	lea		Msg_WhoGoes.l,a6													;4DF900003DFD
	jmp		Print_npc_message.l													;4EF90000D81C

Comms_Action_ThyTrade:		; Memory Address ($36FC) and binary offset [$3378]
	; Communicates the Thy Trade profession question.
	lea		Msg_ThyTrade.l,a6													;4DF900003708
	jmp		WriteMessage.l														;4EF90000D03A

Msg_ThyTrade:
	; Question communicated by the Thy Trade button.
	dc.b	'WHAT BE THY BUSINESS?'	;574841542042452054485920425553494E4553533F
	dc.b	$FF	;FF

Comms_Action_NameSelf:		; Memory Address ($371E) and binary offset [$339A]
	; Builds a message revealing the speaker's name and title.
	lea		Msg_NameSelfTemplate.l,a6											;4DF900003DAA
	move.b	$0003(a4),d1														;122C0003
	or.b	#$80,$0003(a4)														;002C00800003
	and.w	#$000F,d1															;0241000F
	move.b	d1,$0003(a6)														;1D410003
	add.w	#$0064,d1															;06410064
	move.b	d1,$0004(a6)														;1D410004
	jmp		Print_npc_message.l													;4EF90000D81C

Comms_Action_RevealSelf:		; Memory Address ($3744) and binary offset [$33C0]
	; Builds a message revealing the speaker's profession.
	lea		Msg_RevealSelfTemplate.l,a6											;4DF900003E03
	move.b	$0003(a4),d0														;102C0003
	or.b	#$40,$0003(a4)														;002C00400003
	and.w	#$000F,d0															;0240000F
	move.b	#$9E,$0006(a6)														;1D7C009E0006
	and.w	#$0003,d0															;02400003
	beq.s	adrCd00376C															;6708
	add.w	#$005B,d0															;0640005B
	move.b	d0,$0006(a6)														;1D400006
adrCd00376C:		; Memory Address ($376C) and binary offset [$33E8]
	jmp		Print_npc_message.l													;4EF90000D81C

Comms_Action_FolkLore:		; Memory Address ($3772) and binary offset [$33EE]
	; Communicates the Folk Lore inquiry.
	lea		Msg_FolkLore.l,a6													;4DF9000037A2
	jmp		WriteMessage.l														;4EF90000D03A

Comms_Action_MagicItems:		; Memory Address ($377E) and binary offset [$33FA]
	; Communicates the Magic Items inquiry.
	lea		Msg_MagicItems.l,a6													;4DF9000037BF
	jmp		WriteMessage.l														;4EF90000D03A

Comms_Action_Objects:		; Memory Address ($378A) and binary offset [$3406]
	; Communicates the Objects inquiry.
	lea		Msg_Objects.l,a6													;4DF9000037E4
	jmp		WriteMessage.l														;4EF90000D03A

Comms_Action_Persons:		; Memory Address ($3796) and binary offset [$3412]
	; Communicates the Persons inquiry.
	lea		Msg_Persons.l,a6													;4DF900003809
	jmp		WriteMessage.l														;4EF90000D03A

Msg_FolkLore:
	; Question communicated by the Folk Lore button.
	dc.b	'HAST THOU HEARD ANY LEGENDS?'	;484153542054484F5520484541524420414E59204C4547454E44533F
	dc.b	$FF	;FF
Msg_MagicItems:
	; Question communicated by the Magic Items button.
	dc.b	'KNOWEST THOU OF ANY ENCHANTED ITEMS?'	;4B4E4F574553542054484F55204F4620414E5920454E4348414E544544204954454D533F
	dc.b	$FF	;FF
Msg_Objects:
	; Question communicated by the Objects button.
	dc.b	'KNOWEST THOU OF ANY WEAPONS OF NOTE?'	;4B4E4F574553542054484F55204F4620414E5920574541504F4E53204F46204E4F54453F
	dc.b	$FF	;FF
Msg_Persons:
	; Question communicated by the Persons button.
	dc.b	'HAST HEARD OF ANY POWERFUL BEINGS?'	;48415354204845415244204F4620414E5920504F57455246554C204245494E47533F
	dc.b	$FF	;FF

Comms_Action_Offer:		; Memory Address ($382C) and binary offset [$34A8]
	; Builds the Offer message from held coinage, a held object or the empty-hand
	; template.
	move.w	HeldItem_ObjectCodeOffset(a5),d0									;Offset of the currently held object code in the interface state.
	move.b	d0,$000A(a4)														;1940000A
	bne.s	adrCd00383E															;6608
	clr.b	$0008(a4)															;422C0008
	moveq	#$2E,d0																;702E
	bra.s	adrCd003894															;6056

adrCd00383E:		; Memory Address ($383E) and binary offset [$34BA]
	cmpi.w	#Object_Coinage,d0													;Coinage object code.
	bne.s	adrCd00385C															;6618
	move.w	HeldItem_StateOffset(a5),d0											;Offset of the combined held-item quantity and object-code state.
	cmp.b	#$02,$0008(a4)														;0C2C00020008
	bne		Comms_PrintGoldOffer												;6600F9F2
	move.b	#$01,$0008(a4)														;197C00010008
	bra		Comms_PrintGoldOffer												;6000F9E8

adrCd00385C:		; Memory Address ($385C) and binary offset [$34D8]
	cmp.b	#$01,$0008(a4)														;0C2C00010008
	bne.s	adrCd00386A															;6606
	move.b	#$02,$0008(a4)														;197C00020008
adrCd00386A:		; Memory Address ($386A) and binary offset [$34E6]
	lea		Msg_OfferHeldItemTemplate.l,a6										;4DF900003E65
	moveq	#$05,d2																;7405
	bra.s	adrCd0038DA															;6066

Comms_Action_Sell:		; Memory Address ($3874) and binary offset [$34F0]
	; Builds the Sell message and records the held object for the proposed trade.
	move.b	#$03,$0008(a4)														;197C00030008
	clr.b	$0009(a4)															;422C0009
	move.w	HeldItem_ObjectCodeOffset(a5),d0									;Offset of the currently held object code in the interface state.
	beq.s	adrCd003892															;670E
	move.b	d0,$000A(a4)														;1940000A
	lea		Msg_SellHeldItemTemplate.l,a6										;4DF900003E70
	moveq	#$05,d2																;7405
	bra.s	adrCd0038DA															;6048

adrCd003892:		; Memory Address ($3892) and binary offset [$350E]
	moveq	#$57,d0																;7057
adrCd003894:		; Memory Address ($3894) and binary offset [$3510]
	lea		Msg_OfferOrSellTemplate.l,a6										;4DF900003E58
	move.b	d0,$0005(a6)														;1D400005
	jmp		Print_npc_message.l													;4EF90000D81C

Comms_Action_Purchase:		; Memory Address ($38A4) and binary offset [$3520]
	; Communicates the Purchase question and enters purchase mode.
	lea		Msg_Purchase.l,a6													;4DF900003E7B
	move.b	#$01,$0008(a4)														;197C00010008
	jmp		Print_npc_message.l													;4EF90000D81C

Comms_Action_Exchange:		; Memory Address ($38B6) and binary offset [$3532]
	; Builds the Exchange question and enters exchange mode.
	move.b	#$02,$0008(a4)														;197C00020008
	move.w	HeldItem_ObjectCodeOffset(a5),d0									;Offset of the currently held object code in the interface state.
	move.b	d0,$000A(a4)														;1940000A
	bne.s	adrCd0038D2															;660C
	lea		Msg_Exchange.l,a6													;4DF900003E0B
	jmp		Print_npc_message.l													;4EF90000D81C

adrCd0038D2:		; Memory Address ($38D2) and binary offset [$354E]
	lea		Msg_ExchangeHeldItemTemplate.l,a6									;4DF900003E15
	moveq	#$0B,d2																;740B
adrCd0038DA:		; Memory Address ($38DA) and binary offset [$3556]
	bsr.s	Comms_AppendObjectName												;6118
adrCd0038DC:		; Memory Address ($38DC) and binary offset [$3558]
	move.b	#$FA,$00(a6,d2.w)													;1DBC00FA2000
	move.b	#$3F,$01(a6,d2.w)													;1DBC003F2001
	move.b	#$FF,$02(a6,d2.w)													;1DBC00FF2002
	jmp		Print_npc_message.l													;4EF90000D81C

Comms_AppendObjectName:		; Memory Address ($38F4) and binary offset [$3570]
	; Appends an object's one- or two-part display name to a packed communication
	; message.
	lea		Object_Definition_Table+$02.l,a0									;41F90000E4C4
	add.w	d0,d0																;D040
	add.w	d0,d0																;D040
	add.w	d0,a0																;D0C0
	move.b	(a0)+,$00(a6,d2.w)													;1D982000
	addq.w	#$01,d2																;5242
	move.b	(a0),d0																;1010
	bmi.s	adrCd003916															;6B0C
	move.b	#$FE,$00(a6,d2.w)													;1DBC00FE2000
	move.b	d0,$01(a6,d2.w)														;1D802001
	addq.w	#$02,d2																;5442
adrCd003916:		; Memory Address ($3916) and binary offset [$3592]
	rts																			;4E75

Comms_Action_Praise:		; Memory Address ($3918) and binary offset [$3594]
	; Builds a randomized compliment and raises attitude.
	addq.b	#$01,CommsState_AttitudeOffset(a4)									;Offset of mutable communication attitude or rapport.
	lea		Comms_PraiseWordRanges.l,a0											;41F900003A02
	bra.s	adrCd003934															;6010

Comms_Action_Curse:		; Memory Address ($3924) and binary offset [$35A0]
	; Builds a randomized insult and reduces attitude.
	subq.b	#$04,CommsState_AttitudeOffset(a4)									;Offset of mutable communication attitude or rapport.
	bpl.s	adrCd00392E															;6A04
	clr.b	$0006(a4)															;422C0006
adrCd00392E:		; Memory Address ($392E) and binary offset [$35AA]
	lea		Comms_CurseWordRanges.l,a0											;41F900003A08
adrCd003934:		; Memory Address ($3934) and binary offset [$35B0]
	bsr.s	Comms_BuildSmalltalk												;6148
	moveq	#$02,d4																;7802
adrLp003938:		; Memory Address ($3938) and binary offset [$35B4]
	asr.w	#$01,d7																;E247
	bcc.s	adrCd00393E															;6402
	bsr.s	Comms_AppendSmalltalkWord											;6112
adrCd00393E:		; Memory Address ($393E) and binary offset [$35BA]
	addq.w	#$02,a0																;5448
	dbra	d4,adrLp003938														;51CCFFF6
	move.b	#$FF,$00(a6,d2.w)													;1DBC00FF2000
	jmp		Print_npc_message.l													;4EF90000D81C

Comms_AppendSmalltalkWord:		; Memory Address ($3950) and binary offset [$35CC]
	; Selects and appends one optional word from a praise or curse word range.
	bsr		RandomGen_BytewithOffset											;61001C5A
	and.w	#$0007,d0															;02400007
	tst.w	d7																	;4A47
	bpl.s	adrCd003972															;6A16
	cmp.b	(a0),d0																;B010
	bcs.s	adrCd00396E															;650E
	move.b	#$FA,$00(a6,d2.w)													;1DBC00FA2000
	move.b	#$4E,$01(a6,d2.w)													;1DBC004E2001
	addq.w	#$02,d2																;5442
adrCd00396E:		; Memory Address ($396E) and binary offset [$35EA]
	and.w	#$00FF,d7															;024700FF
adrCd003972:		; Memory Address ($3972) and binary offset [$35EE]
	add.b	$0001(a0),d0														;D0280001
	move.b	d0,$00(a6,d2.w)														;1D802000
	addq.w	#$01,d2																;5242
	rts																			;4E75

Comms_BuildSmalltalk:		; Memory Address ($397E) and binary offset [$35FA]
	; Builds a randomized praise or curse from a sentence pattern and three word
	; ranges.
	and.w	#$00FE,d0															;024000FE
	moveq	#$00,d7																;7E00
adrCd003984:		; Memory Address ($3984) and binary offset [$3600]
	cmp.b	Comms_SmalltalkPatternBands(pc,d7.w),d0								;B03B7070
	bcs.s	adrCd00398E															;6504
	addq.w	#$02,d7																;5447
	bra.s	adrCd003984															;60F6

adrCd00398E:		; Memory Address ($398E) and binary offset [$360A]
	move.b	adrB_0039F7(pc,d7.w),d7												;1E3B7067
	lea		Comms_MessageBuffer.l,a6											;4DF900003DC0
	move.b	#$1A,(a6)															;1CBC001A
	moveq	#$01,d2																;7401
	lsr.w	#$01,d7																;E24F
	bcc.s	adrCd0039DA															;6438
	cmp.b	#$03,$0001(a4)														;0C2C00030001
	bne.s	adrCd0039B2															;6608
	bsr		adrCd005556															;61001BAA
	addq.w	#$02,d0																;5440
	bra.s	adrCd0039BA															;6008

adrCd0039B2:		; Memory Address ($39B2) and binary offset [$362E]
	bsr		RandomGen_BytewithOffset											;61001BF8
	and.w	#$0007,d0															;02400007
adrCd0039BA:		; Memory Address ($39BA) and binary offset [$3636]
	move.w	#$0084,d1															;323C0084
	add.w	d0,d1																;D240
	move.b	d1,$0001(a6)														;1D410001
	moveq	#$02,d2																;7402
	cmpi.w	#$0007,d0															;0C400007
	beq.s	adrCd0039DA															;670E
	move.b	#$FA,$0002(a6)														;1D7C00FA0002
	move.b	#$53,$0003(a6)														;1D7C00530003
	moveq	#$04,d2																;7404
adrCd0039DA:		; Memory Address ($39DA) and binary offset [$3656]
	ror.w	#$01,d7																;E25F
	bpl.s	adrCd0039F4															;6A16
	cmpi.w	#$0005,d0															;0C400005
	bcc.s	adrCd0039EC															;6408
	move.b	#$8C,$00(a6,d2.w)													;1DBC008C2000
	addq.w	#$01,d2																;5242
adrCd0039EC:		; Memory Address ($39EC) and binary offset [$3668]
	move.b	#$8D,$00(a6,d2.w)													;1DBC008D2000
	addq.w	#$01,d2																;5242
adrCd0039F4:		; Memory Address ($39F4) and binary offset [$3670]
	rts																			;4E75

Comms_SmalltalkPatternBands:		; Memory Address ($39F6) and binary offset [$3672]
	; Upper bounds and bit masks selecting randomized smalltalk sentence patterns.
	dc.b	$0C	;0C
adrB_0039F7:		; Memory Address ($39F7) and binary offset [$3673]
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
	lea		Msg_BoastTemplate.l,a6												;4DF900003DBA
	and.w	#$0007,d0															;02400007
	add.w	#$0074,d0															;06400074
	move.b	d0,$0002(a6)														;1D400002
	bsr		RandomGen_BytewithOffset											;61001B8A
	and.w	#$0007,d0															;02400007
	add.w	#$007C,d0															;0640007C
	move.b	d0,$0004(a6)														;1D400004
	jmp		Print_npc_message.l													;4EF90000D81C

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
	moveq	#$00,d0																;7000
	move.b	$0000(a4),d0														;102C0000
	move.b	Comms_ActionReplyIndexes(pc,d0.w),d0								;103B00DC
	add.w	d0,d0																;D040
	lea		Msg_Reply_Recruit.l,a6												;4DF900003B1A
	add.w	Msg_ActionReplyOffsets(pc,d0.w),a6									;DCFB0026
	tst.b	(a6)																;4A16
	bpl.s	Comms_PrintActionReply												;6A12
	lea		Msg_Agreement_00.l,a6												;4DF900003ABA
	bsr		RandomGen_BytewithOffset											;61001B38
	and.w	#$0006,d0															;02400006
	add.w	Msg_AgreementOffsets(pc,d0.w),a6									;DCFB0008
Comms_PrintActionReply:
	; Prints the fixed or fallback reply selected for the preceding communication
	; action.
	jmp		WriteMessage.l														;4EF90000D03A

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
	dc.b	'THAT''S VERY POSSIBLE'	;544841542753205645525920504F535349424C45
	dc.b	$FF	;FF
Msg_Agreement_01:
	; Randomized agreement fallback: I CANNOT BUT AGREE.
	dc.b	'I CANNOT BUT AGREE'	;492043414E4E4F5420425554204147524545
	dc.b	$FF	;FF
Msg_Agreement_02:
	; Randomized agreement fallback: THAT SEEMS VERY LIKELY.
	dc.b	'THAT SEEMS VERY LIKELY'	;54484154205345454D532056455259204C494B454C59
	dc.b	$FF	;FF
Msg_Agreement_03:
	; Randomized agreement fallback: I'M NOT ABOUT TO ARGUE WITH THEE.
	dc.b	'I''M NOT ABOUT TO ARGUE WITH THEE'	;49274D204E4F542041424F555420544F20415247554520574954482054484545
	dc.b	$FF	;FF
Msg_Reply_Recruit:
	; Contextual reply to Recruit.
	dc.b	'I DON''T KEEP COMPANY WITH MAGGOTS'	;4920444F4E2754204B45455020434F4D50414E592057495448204D4147474F5453
	dc.b	$FF	;FF
Msg_Reply_Whereabouts:
	; Contextual reply to Whereabouts.
	dc.b	'LOOK TO THE TOWERS MY FRIEND'	;4C4F4F4B20544F2054484520544F57455253204D5920465249454E44
	dc.b	$FF	;FF
Msg_Reply_Yes_UseAgreement:
	; $FF sentinel selecting a randomized agreement after Yes.
	dc.b	$FF	;FF
Msg_Reply_No:
	; Contextual reply to No.
	dc.b	'INDEED NOT'	;494E44454544204E4F54
	dc.b	$FF	;FF
Msg_Reply_Bribe:
	; Contextual reply to Bribe.
	dc.b	'MAKE ME THY OFFER'	;4D414B45204D4520544859204F46464552
	dc.b	$FF	;FF
Msg_Reply_Threat:
	; Contextual reply to Threat.
	dc.b	'PICK ON SOMEONE THY OWN SIZE THOU SLUG'	;5049434B204F4E20534F4D454F4E4520544859204F574E2053495A452054484F5520534C5547
	dc.b	$FF	;FF
Msg_Reply_WhoGoes:
	; Contextual reply to Who Goes.
	dc.b	'I AM THY WORST NIGHTMARE'	;4920414D2054485920574F525354204E494748544D415245
	dc.b	$FF	;FF
Msg_Reply_ThyTrade:
	; Contextual reply to Thy Trade.
	dc.b	'NONE OF THY BUSINESS I''M SURE'	;4E4F4E45204F462054485920425553494E4553532049274D2053555245
	dc.b	$FF	;FF
Msg_Reply_NameSelf_UseAgreement:
	; $FF sentinel selecting a randomized agreement after Name Self.
	dc.b	$FF	;FF
Msg_Reply_RevealSelf_UseAgreement:
	; $FF sentinel selecting a randomized agreement after Reveal Self.
	dc.b	$FF	;FF
Msg_Reply_FolkLore:
	; Contextual reply to Folk Lore.
	dc.b	'NEWS IS SCARCE IN THESE PARTS'	;4E4557532049532053434152434520494E205448455345205041525453
	dc.b	$FF	;FF
Msg_Reply_MagicItems:
	; Contextual reply to Magic Items.
	dc.b	'I HEAR CRYSTALS ARE WORTH SEEKING'	;492048454152204352595354414C532041524520574F525448205345454B494E47
	dc.b	$FF	;FF
Msg_Reply_Objects:
	; Contextual reply to Objects.
	dc.b	'WHO CAN SAY WHAT IS OF NOTE?'	;57484F2043414E205341592057484154204953204F46204E4F54453F
	dc.b	$FF	;FF
Msg_Reply_Persons:
	; Contextual reply to Persons.
	dc.b	'I HEAR ZENDIK IS NOT WHOLLY A WORM'	;492048454152205A454E44494B204953204E4F542057484F4C4C59204120574F524D
	dc.b	$FF	;FF
Msg_Reply_Offer:
	; Contextual reply to Offer.
	dc.b	'GIVE ME A BREAK'	;47495645204D45204120425245414B
	dc.b	$FF	;FF
Msg_Reply_Purchase:
	; Contextual reply to Purchase.
	dc.b	'THY COINAGE IS WORTHLESS TO ME'	;54485920434F494E41474520495320574F5254484C45535320544F204D45
	dc.b	$FF	;FF
Msg_Reply_Exchange:
	; Contextual reply to Exchange.
	dc.b	'I DO NOT TRADE IN TRINKETS'	;4920444F204E4F5420545241444520494E205452494E4B455453
	dc.b	$FF	;FF
Msg_Reply_Sell:
	; Contextual reply to Sell.
	dc.b	'I NEED NOT THY TRASH'	;49204E454544204E4F5420544859205452415348
	dc.b	$FF	;FF
Msg_Reply_Praise_UseAgreement:
	; $FF sentinel selecting a randomized agreement after Praise.
	dc.b	$FF	;FF
Msg_Reply_Curse:
	; Contextual reply to Curse.
	dc.b	'MAYBE TRUE BUT THOU SHOULD BE SO LUCKY'	;4D415942452054525545204255542054484F552053484F554C4420424520534F204C55434B59
	dc.b	$FF	;FF
Msg_Reply_Boast:
	; Contextual reply to Boast.
	dc.b	'I TRUST THIS PLEASES THEE'	;49205452555354205448495320504C45415345532054484545
	dc.b	$FF	;FF
Msg_Reply_Retort_UseAgreement:
	; $FF sentinel selecting a randomized agreement after Retort.
	dc.b	$FF	;FF
Msg_Reply_Greeting:
	; Contextual dismissive reply to the initial Greeting.
	dc.b	'WHY DOST BURDEN ME WITH THY COMPANY?'	;57485920444F53542042555244454E204D4520574954482054485920434F4D50414E593F
	dc.b	$FF	;FF

	lea		Comms_MessageBuffer.l,a6											;4DF900003DC0
	move.b	#$33,(a6)															;1CBC0033
	move.b	#$5F,$0001(a6)														;1D7C005F0001
	move.b	#$FE,$0002(a6)														;1D7C00FE0002
	moveq	#$03,d2																;7403
	move.w	$0006(a5),d1														;322D0006
	asl.w	#$04,d1																;E941
	lea		Character_Pockets_DataTable.l,a0									;41F90000ED2A
	move.b	$00(a0,d1.w),d1														;12301000
	bne.s	adrCd003D52															;660A
	move.b	#$44,$00(a6,d2.w)													;1DBC00442000
	addq.w	#$01,d2																;5242
	bra.s	adrCd003D74															;6022

adrCd003D52:		; Memory Address ($3D52) and binary offset [$39CE]
	lea		Object_Definition_Table+$02.l,a0									;41F90000E4C4
	add.w	d1,d1																;D241
	add.w	d1,d1																;D241
	add.w	d1,a0																;D0C1
	move.b	(a0)+,$00(a6,d2.w)													;1D982000
	addq.w	#$01,d2																;5242
	move.b	(a0),d0																;1010
	bmi.s	adrCd003D74															;6B0C
	move.b	#$FE,$00(a6,d2.w)													;1DBC00FE2000
	move.b	d0,$01(a6,d2.w)														;1D802001
	addq.w	#$02,d2																;5442
adrCd003D74:		; Memory Address ($3D74) and binary offset [$39F0]
	move.b	#$35,$00(a6,d2.w)													;1DBC00352000
	bsr		RandomGen_BytewithOffset											;61001830
	and.w	#$0007,d0															;02400007
	add.w	#$007C,d0															;0640007C
	move.b	d0,$01(a6,d2.w)														;1D802001
	move.b	#$FF,$02(a6,d2.w)													;1DBC00FF2002
	jsr		Print_npc_message.l													;4EB90000D81C
	move.w	#$0006,$0044(a5)													;3B7C00060044
adrCd003D9C:		; Memory Address ($3D9C) and binary offset [$3A18]
	move.w	#$0008,$0042(a5)													;3B7C00080042
	bsr		adrCd003344															;6100F5A0
	bra		Draw_PartyCommandMenu												;60003FC4

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
	dc.b	'WHERE IS THIS OF WHICH THOU HAST SPOKEN?'	;57484552452049532054484953204F462057484943482054484F5520484153542053504F4B454E3F
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
	dc.b	'COME JOIN MY MERRY BAND'	;434F4D45204A4F494E204D59204D455252592042414E44
	dc.b	$FF	;FF
	dc.b	$00	;00

PartyCommand_Call:		; Memory Address ($3E9C) and binary offset [$3B18]
	; Displays "THOU DOST CALL OUT" and, when the other player is active on the
	; same map, builds a direction-and-distance call notice for that player.
	lea		Notice_Call_Out.l,a6												;Selects the packed Call notice "THOU DOST CALL OUT".
	jsr		Print_timed_message.l												;4EB90000D86A
	move.b	#$FF,$0050(a5)														;1B7C00FF0050
	lea		Player1_Data.l,a1													;43F90000EE7C
	btst	#$00,(a5)															;Uses the current-player selector bit to choose the other player's state record.
	bne.s	adrCd003EC0															;6606
	lea		Player2_Data.l,a1													;43F90000EEDE
adrCd003EC0:		; Memory Address ($3EC0) and binary offset [$3B3C]
	btst	#$06,$0018(a1)														;082900060018
	bne		adrCd003F58															;66000090
	move.b	(a1),d0																;1011
	and.b	#$FE,d0																;020000FE
	bne		adrCd003F58															;66000086
	move.w	$0058(a5),d0														;302D0058
	cmp.w	$0058(a1),d0														;Only builds the second-player proximity notice when both players have the same map index.
	bne		adrCd003F58															;6600007A
	lea		Comms_MessageBuffer.w,a6											;4DF83DC0	;Short Absolute converted to symbol!
	move.b	#$CA,(a6)+															;1CFC00CA
	move.b	#$C4,(a6)+															;1CFC00C4
	move.l	$001C(a1),d1														;2229001C
	move.l	$001C(a5),d0														;202D001C
	bsr		adrCd0013A8															;6100D4B2
	cmpi.w	#$0005,d2															;0C420005
	bcs.s	adrCd003F0C															;650E
	cmpi.w	#$0009,d2															;0C420009
	bcs.s	adrCd003F08															;6504
	move.b	#$8E,(a6)+															;1CFC008E
adrCd003F08:		; Memory Address ($3F08) and binary offset [$3B84]
	move.b	#$C5,(a6)+															;1CFC00C5
adrCd003F0C:		; Memory Address ($3F0C) and binary offset [$3B88]
	move.b	#$16,(a6)+															;Appends the packed-word token for CALL to the dynamically generated other-player notice.
	move.b	#$FA,(a6)+															;1CFC00FA
	move.b	#$53,(a6)+															;1CFC0053
	move.b	#$1C,(a6)+															;1CFC001C
	move.b	#$25,(a6)+															;1CFC0025
	moveq	#$00,d3																;7600
	move.w	d0,d2																;3400
	swap	d0																	;4840
	cmp.w	d0,d2																;B440
	bcs.s	adrCd003F2E															;6504
	moveq	#$01,d3																;7601
	swap	d1																	;4841
adrCd003F2E:		; Memory Address ($3F2E) and binary offset [$3BAA]
	swap	d1																	;4841
	tst.w	d1																	;4A41
	bmi.s	adrCd003F36															;6B02
	addq.b	#$02,d3																;5403
adrCd003F36:		; Memory Address ($3F36) and binary offset [$3BB2]
	add.w	$0020(a1),d3														;Rotates the relative direction by the other player's facing direction.
	and.w	#$0003,d3															;Wraps the facing-relative direction to one of four directions.
	add.w	#$00C6,d3															;Converts direction 0 through 3 into the corresponding packed direction-word token.
	move.b	d3,(a6)+															;1CC3
	move.b	#$FF,(a6)															;1CBC00FF
	lea		Comms_MessageBuffer.w,a6											;4DF83DC0	;Short Absolute converted to symbol!
	move.l	a5,-(sp)															;2F0D
	move.l	a1,a5																;2A49
	jsr		Print_timed_message.l												;4EB90000D86A
	move.l	(sp)+,a5															;2A5F
adrCd003F58:		; Memory Address ($3F58) and binary offset [$3BD4]
	bra		adrCd00332A															;6000F3D0

PartyCommand_Dismiss:		; Memory Address ($3F5C) and binary offset [$3BD8]
	; Opens party-member selection for Dismiss or removes the selected member from
	; the active party; displays "<NAME> LEAVES THE PARTY" or "<NAME> IS UNABLE TO
	; DEPART".
	moveq	#$15,d7																;Selects packed action token $15, DISMISS, for prompts and result handling.
	bra.s	Interface_ProcessSelectedInventoryAction							;6006

PartyCommand_Wait:		; Memory Address ($3F60) and binary offset [$3BDC]
	; Opens party-member selection for Wait or removes and marks the selected
	; member as waiting; displays "<NAME> WAITS" or "<NAME> IS UNABLE TO DEPART".
	clr.b	$0050(a5)															;422D0050
	moveq	#$13,d7																;Selects packed action token $13, WAIT, for prompts and result handling.
Interface_ProcessSelectedInventoryAction:		; Memory Address ($3F66) and binary offset [$3BE2]
	; Maps the selected inventory entry, tests the destination cell, removes or
	; applies the object, and prints success or blocked notices.
	tst.b	$004E(a5)															;A clear target-selection flag opens the party-member selector; a set flag processes the chosen member.
	beq		Interface_OpenInventoryActionSelector								;67000134
	bsr		Interface_MapSelectedAction											;6100020E
	move.w	d7,-(sp)															;3F07
	move.b	d0,$004F(a5)														;1B40004F
	move.l	$001C(a5),d7														;2E2D001C
	move.w	$0020(a5),d6														;3C2D0020
	bsr		Compute_NewMapIndex_AI_TBC											;61003AC2
	bcc.s	Interface_FinalizeSelectedWorldAction								;Carry clear indicates that the selected party member can be placed at the party's current location.
	addq.w	#$02,sp																;544F
	lea		Notice_PartyCommand_UnableToDepart.l,a6								;Selects "<NAME> IS UNABLE TO DEPART" when the selected member cannot be placed outside the active party.
	move.b	$004F(a5),(a6)														;1CAD004F
	jsr		Print_timed_message.l												;4EB90000D86A
	bra		adrCd00332A															;6000F390

Interface_FinalizeSelectedWorldAction:		; Memory Address ($3F9C) and binary offset [$3C18]
	; Completes a valid selected-object world action, updates the champion record,
	; and displays the resulting notice.
	bset	#$07,$01(a6,d2.w)													;08F600072001
	move.b	$004F(a5),d0														;102D004F
	bsr		Interface_RemoveSelectedInventoryObject								;6100005C
	lea		Notice_Dismiss_PartyMemberLeaves.l,a6								;4DF9000041C6
	move.w	(sp)+,d1															;321F
	cmpi.w	#$0015,d1															;Distinguishes Dismiss from Wait after the selected member has been removed from the active party.
	beq.s	adrCd003FCE															;6716
	bsr		adrCd004054															;6100009A
	move.b	$004F(a5),d0														;102D004F
	bset	#$05,d0																;Marks a Wait target as waiting so View can select that party member later.
	move.b	d0,$18(a5,d1.w)														;1B801018
	lea		Notice_Wait_PartyMemberWaits.l,a6									;4DF9000041C1
adrCd003FCE:		; Memory Address ($3FCE) and binary offset [$3C4A]
	move.b	$004F(a5),d0														;102D004F
	move.b	d0,(a6)																;Patches the first packed-word token of the Wait or Dismiss result with the selected party member's name.
	bsr		Load_ChampionStatRecord												;6100268A
	move.b	d7,$0017(a4)														;19470017
	swap	d7																	;4847
	move.b	d7,$0016(a4)														;19470016
	move.b	$0059(a5),$001A(a4)													;196D0059001A
	move.b	$0021(a5),$0018(a4)													;196D00210018
	move.b	CurrentTower+$01.l,$001F(a4)										;19790000EE2F001F
	jsr		Print_timed_message.l												;4EB90000D86A
	bsr		adrCd008246															;61004248
	bra		adrCd00332A															;6000F328

Interface_RemoveSelectedInventoryObject:		; Memory Address ($4004) and binary offset [$3C80]
	; Removes the selected inventory object, compacts the pocket flags, and
	; refreshes inventory state.
	bsr		adrCd004092															;6100008C
	move.b	#$FF,$26(a5,d2.w)													;1BBC00FF2026
	cmp.w	$0016(a5),d2														;B46D0016
	bne.s	adrCd00401A															;6606
	move.w	#$FFFF,$0016(a5)													;3B7CFFFF0016
adrCd00401A:		; Memory Address ($401A) and binary offset [$3C96]
	bsr		adrCd004078															;6100005C
	move.w	d1,d3																;3601
adrCd004020:		; Memory Address ($4020) and binary offset [$3C9C]
	move.b	$19(a5,d1.w),$18(a5,d1.w)											;1BB510191018
	addq.w	#$01,d1																;5241
	cmpi.w	#$0003,d1															;0C410003
	bcs.s	adrCd004020															;65F2
	move.b	#$FF,$001B(a5)														;1B7C00FF001B
	cmp.b	#$03,$0015(a5)														;0C2D00030015
	bne.s	adrCd004052															;6616
	cmp.b	$000F(a5),d3														;B62D000F
	bne.s	adrCd00404C															;660A
	move.l	d7,-(sp)															;2F07
	bsr		Click_OpenInventory													;61002BAA
	move.l	(sp)+,d7															;2E1F
	rts																			;4E75

adrCd00404C:		; Memory Address ($404C) and binary offset [$3CC8]
	bcc.s	adrCd004052															;6404
	subq.b	#$01,$000F(a5)														;532D000F
adrCd004052:		; Memory Address ($4052) and binary offset [$3CCE]
	rts																			;4E75

adrCd004054:		; Memory Address ($4054) and binary offset [$3CD0]
	moveq	#$00,d1																;7200
adrCd004056:		; Memory Address ($4056) and binary offset [$3CD2]
	tst.b	$18(a5,d1.w)														;4A351018
	bmi.s	adrCd004064															;6B08
	addq.w	#$01,d1																;5241
	cmpi.w	#$0003,d1															;0C410003
	bcs.s	adrCd004056															;65F2
adrCd004064:		; Memory Address ($4064) and binary offset [$3CE0]
	rts																			;4E75

adrCd004066:		; Memory Address ($4066) and binary offset [$3CE2]
	lea		Player1_Data.l,a5													;4BF90000EE7C
	bsr.s	adrCd004078															;610A
	tst.w	d1																	;4A41
	bpl.s	adrCd004064															;6AF2
	lea		Player2_Data.l,a5													;4BF90000EEDE
adrCd004078:		; Memory Address ($4078) and binary offset [$3CF4]
	move.w	d2,-(sp)															;3F02
	moveq	#$03,d1																;7203
adrLp00407C:		; Memory Address ($407C) and binary offset [$3CF8]
	move.b	$18(a5,d1.w),d2														;14351018
	bmi.s	adrCd00408A															;6B08
	and.w	#$000F,d2															;0242000F
	cmp.b	d2,d0																;B002
	beq.s	adrCd00408E															;6704
adrCd00408A:		; Memory Address ($408A) and binary offset [$3D06]
	dbra	d1,adrLp00407C														;51C9FFF0
adrCd00408E:		; Memory Address ($408E) and binary offset [$3D0A]
	move.w	(sp)+,d2															;341F
	rts																			;4E75

adrCd004092:		; Memory Address ($4092) and binary offset [$3D0E]
	moveq	#$03,d2																;7403
adrLp004094:		; Memory Address ($4094) and binary offset [$3D10]
	cmp.b	$26(a5,d2.w),d0														;B0352026
	beq.s	adrCd00409E															;6704
	dbra	d2,adrLp004094														;51CAFFF8
adrCd00409E:		; Memory Address ($409E) and binary offset [$3D1A]
	rts																			;4E75

Interface_OpenInventoryActionSelector:		; Memory Address ($40A0) and binary offset [$3D1C]
	; Builds the selectable inventory-object list and either opens selection or
	; displays the supplied no-selection notice.
	bsr		adrJA007CA6															;61003C04
	tst.w	d2																	;4A42
	bne.s	adrCd0040BC															;6614
	lea		Notice_PartyCommand_NoTarget.l,a6									;4DF9000041CD
	move.b	d7,$0005(a6)														;Patches "THOU HAST NONE PRESENT TO <ACTION>" with the current party-command word token.
Interface_ShowInventoryActionNotice:		; Memory Address ($40B2) and binary offset [$3D2E]
	; Clears the page state and prints a fixed inventory/action notice.
	clr.w	$0042(a5)															;426D0042
	jmp		Print_timed_message.l												;4EF90000D86A

adrCd0040BC:		; Memory Address ($40BC) and binary offset [$3D38]
	move.w	#$0001,$0044(a5)													;3B7C00010044
	bra.s	Interface_InitInventoryActionSelector								;6006

Interface_OpenInventorySelection:		; Memory Address ($40C4) and binary offset [$3D40]
	; Selects the inventory-selection page and enters the common selection-prompt
	; path.
	move.w	#$0003,$0044(a5)													;3B7C00030044
Interface_InitInventoryActionSelector:		; Memory Address ($40CA) and binary offset [$3D46]
	; Marks selection as active, patches the prompt template with the action value,
	; and opens the fixed-message selector.
	move.b	#$01,$004E(a5)														;1B7C0001004E
	lea		Notice_PartyCommand_SelectTarget.l,a6								;4DF9000041A0
	move.b	d7,$0007(a6)														;Patches "WHOM DOST THOU WISH TO <ACTION>?" with the current party-command word token.
	jsr		Print_fix_message.l													;4EB90000D870
	bra		Draw_PartyCommandMenu												;60003C8A

PartyCommand_View:		; Memory Address ($40E4) and binary offset [$3D60]
	; Opens selection for an eligible waiting party member and switches the
	; viewpoint through that member; otherwise displays "EVERYONE IS PRESENT".
	tst.b	$004E(a5)															;4A2D004E
	bne.s	Interface_CommitSelectedInventoryAction								;662A
	moveq	#$12,d7																;7E12
	moveq	#$03,d1																;7203
	moveq	#$00,d2																;7400
adrLp0040F0:		; Memory Address ($40F0) and binary offset [$3D6C]
	move.b	$18(a5,d1.w),d0														;10351018
	bmi.s	adrCd004104															;6B0E
	btst	#$06,d0																;08000006
	bne.s	adrCd004104															;6608
	btst	#$05,d0																;Only party entries marked as waiting are eligible for View.
	beq.s	adrCd004104															;6702
	addq.w	#$01,d2																;5242
adrCd004104:		; Memory Address ($4104) and binary offset [$3D80]
	dbra	d1,adrLp0040F0														;51C9FFEA
	tst.w	d2																	;4A42
	bne.s	Interface_OpenInventorySelection									;66B8
	lea		Notice_View_EveryonePresent.l,a6									;Selects "EVERYONE IS PRESENT" when no waiting party member is available to View.
	bra.s	Interface_ShowInventoryActionNotice									;609E

Interface_CommitSelectedInventoryAction:		; Memory Address ($4114) and binary offset [$3D90]
	; Stores the selected inventory action nibble, patches its notice template, and
	; commits the pending action.
	bsr		Interface_MapSelectedAction											;61000068
	move.b	d0,$0053(a5)														;1B400053
	and.b	#$0F,$0053(a5)														;Retains the selected champion index while discarding the party-entry state flags.
	move.b	#$01,$0014(a5)														;Marks the selected waiting champion as the active remote viewpoint.
	lea		Notice_View_ThroughPartyMember.l,a6									;4DF9000041E3
	move.b	$0053(a5),$0004(a6)													;Patches "VIEWING THROUGH <NAME>" with the selected champion's name token.
	jsr		Print_fix_message.l													;4EB90000D870
	move.w	#$0101,$0040(a5)													;3B7C01010040
	bra		adrCd00332A															;6000F1E8

PartyCommand_Correct:		; Memory Address ($4144) and binary offset [$3DC0]
	; Opens party-member selection for Correct or sets bit 4 in the selected
	; member's stored party-state byte; displays "<NAME> APOLOGISES FOR BREATHING".
	moveq	#$14,d7																;Selects packed action token $14, CORRECT, for the target prompt.
	lea		Notice_Correct_Apology.l,a6											;4DF9000041B2
	moveq	#$10,d3																;Supplies bit 4 so Correct records the correction state on the selected party entry.
	bra.s	Interface_CommitSelectedObjectFlags									;600A

PartyCommand_Commend:		; Memory Address ($4150) and binary offset [$3DCC]
	; Opens party-member selection for Commend or clears bit 4 in the selected
	; member's stored party-state byte; displays "<NAME> ACCEPTS THY HONOUR".
	lea		Notice_Commend_Accepted.l,a6										;4DF9000041AB
	moveq	#$11,d7																;Selects packed action token $11, COMMEND, for the target prompt.
	moveq	#$00,d3																;Supplies a clear bit 4 so Commend removes the selected party entry's correction state.
Interface_CommitSelectedObjectFlags:		; Memory Address ($415A) and binary offset [$3DD6]
	; Maps the selected object, clears its active flag, updates the pocket flags,
	; and prints the action notice.
	tst.b	$004E(a5)															;4A2D004E
	beq		Interface_OpenInventoryActionSelector								;6700FF40
	bsr.s	Interface_MapSelectedAction											;611A
	bclr	#$04,$19(a5,d2.w)													;Clears the existing correction-state bit before applying the Correct or Commend value.
	or.b	$19(a5,d2.w),d3														;86352019
	move.b	d3,$19(a5,d2.w)														;1B832019
	move.b	d0,(a6)																;Patches the Correct or Commend result template with the selected party member's name token.
	jsr		Print_timed_message.l												;4EB90000D86A
	bra		adrCd00332A															;6000F1AE

Interface_MapSelectedAction:		; Memory Address ($417E) and binary offset [$3DFA]
	; Maps the selected button index through the runtime action-selection scratch
	; entries at $7C24; negative entries return the existing
	; Return_InvalidPlayerAction path.
	lea		Interface_ActionSelectionScratchEntries.l,a1						;43F900007C24
	and.w	#$0003,d1															;02410003
	move.w	d1,d2																;3401
	add.w	d1,d1																;D241
	move.b	$00(a1,d1.w),d0														;10311000
	bmi.s	Return_InvalidPlayerAction											;6B04
	lsr.w	#$01,d1																;E249
	rts																			;4E75

Return_InvalidPlayerAction:		; Memory Address ($451A) and binary offset [$4196]
	; Returns from invalid or unavailable player-action processing.
	move.w	#$FFFF,$000C(a5)													;3B7CFFFF000C
	addq.w	#$04,sp																;584F
	rts																			;4E75

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
	lea		Comms_StateRecords.l,a4												;49F900016B4C
	btst	#$00,(a5)															;08150000
	beq.s	adrCd00420A															;6704
	add.w	#$0010,a4															;D8FC0010
adrCd00420A:		; Memory Address ($420A) and binary offset [$3E86]
	rts																			;4E75

Click_CommsAndOptions:		; Memory Address ($420C) and binary offset [$3E88]
	move.w	$0004(a5),d1														;322D0004
	sub.w	$0008(a5),d1														;926D0008
	cmpi.w	#$0037,d1															;0C410037
	bcs.s	adrCd004234															;651A
	move.w	$0002(a5),d1														;322D0002
	lsr.w	#$05,d1																;EA49
	and.w	#$0003,d1															;02410003
	addq.w	#$01,d1																;5241
adrCd004226:		; Memory Address ($4226) and binary offset [$3EA2]
	bchg	d1,$003E(a5)														;036D003E
	move.w	d1,d7																;3E01
	bsr		Refresh_PartyShieldSlotIfDirty										;61003CC2
	bra		Draw_PartyShieldChainStrip											;60003CA0

adrCd004234:		; Memory Address ($4234) and binary offset [$3EB0]
	moveq	#$00,d1																;7200
	cmp.w	#$0030,$0002(a5)													;0C6D00300002
	bcs.s	adrCd004226															;65E8
	move.b	$003E(a5),d0														;102D003E
	and.b	#$0E,d0																;0200000E
	bne.s	ExitPause															;6670
	clr.w	$0042(a5)															;426D0042
	clr.w	$0044(a5)															;426D0044
	move.w	#$FFFF,$0040(a5)													;3B7CFFFF0040
	clr.b	$003E(a5)															;422D003E
	bra		Draw_PartyCommandInterface											;600038F4

Click_PauseGame:		; Memory Address ($425E) and binary offset [$3EDA]
	move.l	adrEA00EE36.l,d1													;22390000EE36
	move.w	#$FFFF,Paused_Marker.l												;33FCFFFF00008C1C
	lea		_custom+color.l,a0													;41F900DFF180
	move.w	#$0400,(a0)															;30BC0400
	move.w	#$0400,$001E(a0)													;317C0400001E
.PauseLoop:		; Memory Address ($427C) and binary offset [$3EF8]
	move.b	adrB_00EE7D.l,d0													;10390000EE7D
	or.b	adrB_00EEDF.l,d0													;80390000EEDF
	bpl.s	.PauseLoop															;6AF2
	clr.w	(a0)																;4250
	clr.w	$001E(a0)															;4268001E
	move.l	d1,adrEA00EE36.l													;23C10000EE36
	and.b	#$7F,adrB_00EE7D.l													;0239007F0000EE7D
	and.b	#$7F,adrB_00EEDF.l													;0239007F0000EEDF
	clr.b	Player1_PendingAction.l												;42390000EED2
	clr.b	Player2_PendingAction.l												;42390000EF34
	clr.w	Paused_Marker.l														;427900008C1C
ExitPause:		; Memory Address ($42B8) and binary offset [$3F34]
	rts																			;4E75

adrCd0042BA:		; Memory Address ($42BA) and binary offset [$3F36]
	lea		Player1_Data.l,a5													;4BF90000EE7C
	bsr		Reset_PlayerActionState												;61000048
	bsr		adrCd007B08															;61003842
	btst	#$06,$0018(a5)														;082D00060018
	beq.s	adrCd0042D4															;6704
	bsr		adrCd00270E															;6100E43C
adrCd0042D4:		; Memory Address ($42D4) and binary offset [$3F50]
	tst.w	MultiPlayer.l														;4A790000EE30
	bmi.s	adrCd0042F6															;6B1A
	lea		Player2_Data.l,a5													;4BF90000EEDE
	bsr		Reset_PlayerActionState												;61000026
	bsr		adrCd007B22															;6100383A
	btst	#$06,$0018(a5)														;082D00060018
	beq.s	adrCd0042F6															;6704
	bsr		adrCd00270E															;6100E41A
adrCd0042F6:		; Memory Address ($42F6) and binary offset [$3F72]
	jsr		adrCd008CCA.l														;4EB900008CCA
	bsr		adrCd008D88															;61004A8A
	move.w	#$FFFF,FrameSyncFlagWord_AI_TBC.l									;33FCFFFF00008C1E
	rts																			;4E75

Reset_PlayerActionState:		; Memory Address ($468E) and binary offset [$430A]
	; Resets per-player interface state, clears the active action, and restores the
	; invalid-action value.
	and.b	#$01,(a5)															;02150001
	clr.b	$0056(a5)															;422D0056
	clr.w	$0014(a5)															;426D0014
	clr.b	$003C(a5)															;422D003C
	clr.b	$003E(a5)															;422D003E
	clr.b	$0050(a5)															;422D0050
	move.w	#Player_ActionInvalid,$000C(a5)										;Value meaning no active action.
	rts																			;4E75

Click_LoadSaveGame:		; Memory Address ($432A) and binary offset [$3FA6]
	move.l	adrEA00EE36.l,-(sp)													;2F390000EE36
	clr.w	FrameSyncFlagWord_AI_TBC.l											;427900008C1E
	move.l	#$00067D00,screen_ptr.l												;23FC00067D0000008D36
	move.l	#$00060000,framebuffer_ptr.l										;23FC0006000000008D3A
	lea		Player1_Data.l,a5													;4BF90000EE7C
	lea		Msg_LoadSaveFunctionKeys.l,a6										;4DF9000044C4
	jsr		WriteText.l															;4EB90000D08E
	tst.w	MultiPlayer.l														;4A790000EE30
	bne.s	.skipPlayer2														;6612
	lea		Player2_Data.l,a5													;4BF90000EEDE
	lea		Msg_LoadSaveFunctionKeys.l,a6										;4DF9000044C4
	jsr		WriteText.l															;4EB90000D08E
.skipPlayer2:
	clr.b	KeyboardKeyCode.w													;423805C9	;Short Absolute converted to symbol!
	bsr		adrCd008CCA															;6100494E
.PickLoadSaveGame_Loop:		; Memory Address ($437E) and binary offset [$3FFA]
	move.b	KeyboardKeyCode.w,d0												;103805C9	;Short Absolute converted to symbol!
	cmpi.b	#$50,d0																;0C000050
	beq.s	LoadGame															;671C
	cmpi.b	#$51,d0																;0C000051
	beq		SaveGame															;6700002C
	cmpi.b	#$59,d0																;0C000059
	bne.s	.PickLoadSaveGame_Loop												;66E8
adrCd004396:		; Memory Address ($4396) and binary offset [$4012]
	move.l	(sp)+,adrEA00EE36.l													;23DF0000EE36
	clr.b	KeyboardKeyCode.w													;423805C9	;Short Absolute converted to symbol!
	bra		adrCd0042BA															;6000FF18

LoadGame:		; Memory Address ($43A4) and binary offset [$4020]
	moveq	#$00,d0																;7000
	bsr		adrCd0043E2															;6100003A
	bcs.s	adrCd004396															;65EA
	bsr		adrCd004440															;61000092
	tst.l	d0																	;4A80
	bmi.s	LoadGame															;6BF0
	bsr		Select_CurrentTowerMapData											;6100C7B2
	bra.s	adrCd004396															;60DC

SaveGame:		; Memory Address ($43BA) and binary offset [$4036]
	moveq	#$01,d0																;7001
	bsr		adrCd0043E2															;61000024
	bcs.s	adrCd004396															;65D4
	bsr		adrCd004480															;610000BC
	tst.l	d0																	;4A80
	bmi.s	SaveGame															;6BF0
	bra.s	adrCd004396															;60CA

AwaitDisk:		; Memory Address ($43CC) and binary offset [$4048]
	lea		Msg_InstertLoadDisk.l,a6											;4DF9000044E5
	tst.w	d0																	;4A40
	beq.s	.PickLoadSaveMessage												;6706
	lea		Msg_InstertSaveDisk.l,a6											;4DF90000450D
.PickLoadSaveMessage:		; Memory Address ($43DC) and binary offset [$4058]
	jmp		WriteText.l															;4EF90000D08E

adrCd0043E2:		; Memory Address ($43E2) and binary offset [$405E]
	lea		Player1_Data.l,a5													;4BF90000EE7C
	tst.w	MultiPlayer.l														;4A790000EE30
	bne.s	.skipPlayer2														;660C
	move.w	d0,-(sp)															;3F00
	bsr.s	AwaitDisk															;61D8
	move.w	(sp)+,d0															;301F
	lea		Player2_Data.l,a5													;4BF90000EEDE
.skipPlayer2:
	bsr.s	AwaitDisk															;61CE
	clr.b	KeyboardKeyCode.w													;423805C9	;Short Absolute converted to symbol!
	bsr		adrCd008CCA															;610048C6
LoadSaveGame_Loop:		; Memory Address ($4406) and binary offset [$4082]
	move.b	KeyboardKeyCode.w,d0												;103805C9	;Short Absolute converted to symbol!
	cmpi.b	#$44,d0																;0C000044
	beq.s	LoadSaveGame_Action													;6712
	cmpi.b	#$43,d0																;0C000043
	beq.s	LoadSaveGame_Action													;670C
	cmpi.b	#$59,d0																;0C000059
	bne.s	LoadSaveGame_Loop													;66EA
	sub.b	#$FF,d0																;040000FF
	rts																			;4E75

LoadSaveGame_Action:		; Memory Address ($4422) and binary offset [$409E]
	moveq	#$3C,d0																;703C
	tst.w	MultiPlayer.l														;4A790000EE30
	beq.s	adrCd00442E															;6702
	moveq	#$46,d0																;7046
adrCd00442E:		; Memory Address ($442E) and binary offset [$40AA]
	move.w	d0,adrW_00447E.l													;33C00000447E
	rts																			;4E75

adrCd004436:		; Memory Address ($4436) and binary offset [$40B2]
	jsr		adrCd008878.l														;4EB900008878
	moveq	#-$01,d0															;70FF
	rts																			;4E75

adrCd004440:		; Memory Address ($4440) and binary offset [$40BC]
	jsr		CopyProtection.l													;4EB90000D138
	tst.l	d0																	;4A80
	beq.s	adrCd004436															;67EC
	move.l	screen_ptr.l,adrL_008520.l											;23F900008D3600008520
	jsr		adrCd008702.l														;4EB900008702
	move.w	adrW_00447E.l,d7													;3E390000447E
	jsr		adrCd00888E.l														;4EB90000888E
	lea		Character_Stats_DataTable.l,a0										;41F90000EB2A
	moveq	#$08,d0																;7008
	jsr		adrCd0086C0.l														;4EB9000086C0
	jsr		adrCd008878.l														;4EB900008878
	moveq	#$00,d0																;7000
	rts																			;4E75

adrW_00447E:		; Memory Address ($447E) and binary offset [$40FA]
	ds.b	$2
adrCd004480:		; Memory Address ($4480) and binary offset [$40FC]
	jsr		CopyProtection.l													;4EB90000D138
	tst.l	d0																	;4A80
	beq.s	adrCd004436															;67AC
	move.l	screen_ptr.l,adrL_008520.l											;23F900008D3600008520
	jsr		adrCd008702.l														;4EB900008702
	move.w	adrW_00447E.w,d7													;3E38447E	;Short Absolute converted to symbol!
	jsr		adrCd00888E.l														;4EB90000888E
	lea		Character_Stats_DataTable.l,a0										;41F90000EB2A
	moveq	#$00,d0																;7000
	move.w	adrW_00447E.w,d0													;3038447E	;Short Absolute converted to symbol!
	moveq	#$00,d1																;7200
	moveq	#$08,d7																;7E08
	jsr		adrLp008524.l														;4EB900008524
	jsr		adrCd008878.l														;4EB900008878
	moveq	#$00,d0																;7000
	rts																			;4E75

Msg_LoadSaveFunctionKeys:
	dc.b	'F1 - LOAD, F2 - SAVE, F10 - EXIT'	;4631202D204C4F41442C204632202D20534156452C20463130202D2045584954
	dc.b	$FF	;FF
Msg_InstertLoadDisk:
	dc.b	'INSERT LOAD DISK AND RETURN, F10 - EXIT'	;494E53455254204C4F4144204449534B20414E442052455455524E2C20463130202D2045584954
	dc.b	$FF	;FF
Msg_InstertSaveDisk:
	dc.b	'INSERT SAVE DISK AND RETURN, F10 - EXIT'	;494E534552542053415645204449534B20414E442052455455524E2C20463130202D2045584954
	dc.b	$FF	;FF
	dc.b	$00	;00

Click_SleepParty:		; Memory Address ($4536) and binary offset [$41B2]
	move.b	#$03,$004F(a5)														;1B7C0003004F
	clr.w	$0014(a5)															;426D0014
	move.w	#$FFFF,$0042(a5)													;3B7CFFFF0042
	move.w	#$FFFF,$0040(a5)													;3B7CFFFF0040
	move.b	#$FF,$0035(a5)														;1B7C00FF0035
	moveq	#$03,d7																;7E03
adrLp004554:		; Memory Address ($4554) and binary offset [$41D0]
	move.b	$18(a5,d7.w),d0														;10357018
	and.w	#$00C0,d0															;024000C0
	bne.s	adrCd004574															;6616
	move.b	$18(a5,d7.w),d0														;10357018
	bsr		Load_ChampionStatRecord												;610020FC
	clr.b	$0011(a4)															;422C0011
	move.b	#$FF,$0013(a4)														;197C00FF0013
	clr.b	$0014(a4)															;422C0014
adrCd004574:		; Memory Address ($4574) and binary offset [$41F0]
	dbra	d7,adrLp004554														;51CFFFDE
	bsr		Draw_PartyCommandInterface											;610035D6
	bsr		Draw_ChampionNamePanelFrame											;61003CFA
adrCd004580:		; Memory Address ($4580) and binary offset [$41FC]
	bsr		adrCd002734															;6100E1B2
	and.b	#$01,(a5)															;02150001
	bset	#$02,(a5)															;08D50002
	move.b	#$32,$003F(a5)														;1B7C0032003F
	move.b	#$02,$0014(a5)														;1B7C00020014
	clr.b	$004E(a5)															;422D004E
	move.b	#$01,$0052(a5)														;1B7C00010052
	clr.b	$004A(a5)															;422D004A
	tst.b	$004B(a5)															;4A2D004B
	bmi.s	adrCd0045B2															;6B06
	move.w	#$00FF,$004A(a5)													;3B7C00FF004A
adrCd0045B2:		; Memory Address ($45B2) and binary offset [$422E]
	lea		ThouArtAsleep.l,a6													;4DF9000045C4
	jsr		Print_fflim_text.l													;4EB90000D0C6
	jmp		adrCd00CF96.l														;4EF90000CF96

ThouArtAsleep:		; Memory Address ($45C4) and binary offset [$4240]
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

adrCd0045DE:		; Memory Address ($45DE) and binary offset [$425A]
	move.l	a4,-(sp)															;2F0C
	asl.w	#$02,d0																;E540
	lea		adrEA00462A.l,a6													;4DF90000462A
	add.w	d0,a6																;DCC0
	link	a3,#-$0020															;4E53FFE0
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	$000A(a5),a0														;D0ED000A
	add.w	#$01EC,a0															;D0FC01EC
	move.l	a0,-$0008(a3)														;2748FFF8
	lea		GFX_Fairy.l,a1														;43F900044ED0
	moveq	#$08,d4																;7808
	moveq	#$05,d5																;7A05
	moveq	#$28,d7																;7E28
	moveq	#$00,d6																;7C00
	bsr		Draw_Monster_16PixelStrip											;61006724
	lea		GFX_Fairy.l,a1														;43F900044ED0
	moveq	#$17,d4																;7817
	moveq	#$05,d5																;7A05
	moveq	#$28,d7																;7E28
	moveq	#-$01,d6															;7CFF
	bsr		Draw_Monster_16PixelStrip											;61006712
	unlk	a3																	;4E5B
	move.l	(sp)+,a4															;285F
	rts																			;4E75

adrEA00462A:		; Memory Address ($462A) and binary offset [$42A6]
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

adrCd00465E:		; Memory Address ($465E) and binary offset [$42DA]
	move.b	$004E(a5),d0														;102D004E
	beq.s	adrCd004674															;6710
	subq.b	#$01,d0																;5300
	beq		adrCd004748															;670000E0
	subq.b	#$01,d0																;5300
	beq		adrCd004870															;67000202
	bra		adrCd0049D6															;60000364

adrCd004674:		; Memory Address ($4674) and binary offset [$42F0]
	tst.b	$003F(a5)															;4A2D003F
	bmi		adrCd004AFE															;6B000484
	subq.b	#$01,$003F(a5)														;532D003F
	bpl		adrCd004AFE															;6A00047C
	moveq	#$00,d7																;7E00
adrCd004686:		; Memory Address ($4686) and binary offset [$4302]
	move.b	$004F(a5),d7														;1E2D004F
	bmi		adrCd004AFE															;6B000472
	move.b	$18(a5,d7.w),d0														;10357018
	and.w	#$00E0,d0															;024000E0
	bne.s	adrCd0046C6															;662E
	move.b	$18(a5,d7.w),d0														;10357018
	and.w	#$000F,d0															;0240000F
	lea		adrEA004B14.l,a6													;4DF900004B14
	move.b	d0,(a6)																;1C80
	bsr		Load_ChampionStatRecord												;61001FB6
	cmp.b	#$EC,$001C(a4)														;0C2C00EC001C
	bcs.s	adrCd0046BC															;6508
	cmp.b	#$0E,(a4)															;0C14000E
	bcs		adrCd004AE8															;6500042E
adrCd0046BC:		; Memory Address ($46BC) and binary offset [$4338]
	move.b	$001E(a4),d0														;102C001E
	and.w	#$007F,d0															;0240007F
	bne.s	adrCd0046CC															;6606
adrCd0046C6:		; Memory Address ($46C6) and binary offset [$4342]
	subq.b	#$01,$004F(a5)														;532D004F
	bra.s	adrCd004686															;60BA

adrCd0046CC:		; Memory Address ($46CC) and binary offset [$4348]
	bsr		adrCd002734															;6100E066
	jsr		adrCd00CF96.l														;4EB90000CF96
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	$000A(a5),a0														;D0ED000A
	add.w	#$0A86,a0															;D0FC0A86
	moveq	#$03,d7																;7E03
adrLp0046E6:		; Memory Address ($46E6) and binary offset [$4362]
	move.w	d7,d0																;3007
	eor.w	#$0003,d0															;0A400003
	add.w	#$0064,d0															;06400064
	jsr		Draw_PocketGraphic.l												;4EB90000CAEA
	dbra	d7,adrLp0046E6														;51CFFFEE
	moveq	#$74,d0																;7074
	addq.w	#$02,a0																;5448
	move.w	$0012(a5),d3														;362D0012
	jsr		Draw_PocketGraphic.l												;4EB90000CAEA
	moveq	#$04,d0																;7004
	bsr		adrCd0045DE															;6100FED2
	or.b	#$40,$0054(a5)														;002D00400054
	jsr		InitialiseText.l													;4EB90000D09A
	moveq	#$00,d7																;7E00
	move.b	$004F(a5),d7														;1E2D004F
	move.b	$18(a5,d7.w),d0														;10357018
	and.w	#$000F,d0															;0240000F
	clr.b	$0052(a5)															;422D0052
	jsr		Print_wordstext.l													;4EB90000D7E6
	lea		MayBuySpellMsg.l,a6													;4DF900004A84
	jsr		adrLp00CFDA.l														;4EB90000CFDA
	move.b	#$01,$004E(a5)														;1B7C0001004E
	bra		adrCd004AFE															;600003B8

adrCd004748:		; Memory Address ($4748) and binary offset [$43C4]
	bclr	#$07,$0001(a5)														;08AD00070001
	beq		adrCd004AFE															;670003AE
	move.l	$0002(a5),d1														;222D0002
	sub.w	$0008(a5),d1														;926D0008
	cmpi.b	#$42,d1																;0C010042
	bcs		adrCd004AFE															;6500039E
	cmpi.b	#$54,d1																;0C010054
	bcc		adrCd004AFE															;64000396
	swap	d1																	;4841
	sub.b	#$70,d1																;04010070
	bcs		adrCd004AFE															;6500038C
	cmpi.b	#$40,d1																;0C010040
	bcs.s	adrCd004792															;6518
	sub.b	#$50,d1																;04010050
	bcs		adrCd004AFE															;6500037E
	cmpi.b	#$10,d1																;0C010010
	bcc		adrCd004AFE															;64000376
	subq.b	#$01,$004F(a5)														;532D004F
	bra		adrCd004580															;6000FDF0

adrCd004792:		; Memory Address ($4792) and binary offset [$440E]
	lsr.w	#$04,d1																;E849
	move.w	d1,-(sp)															;3F01
	bsr		adrCd002734															;6100DF9C
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	$000A(a5),a0														;D0ED000A
	add.w	#$0A90,a0															;D0FC0A90
	moveq	#$74,d0																;7074
	move.w	$0012(a5),d3														;362D0012
	jsr		Draw_PocketGraphic.l												;4EB90000CAEA
	move.w	(sp),d0																;3017
	bsr		adrCd0045DE															;6100FE26
	moveq	#$00,d0																;7000
	move.b	$004F(a5),d0														;102D004F
	move.b	$18(a5,d0.w),d0														;10350018
	bsr		Load_ChampionStatRecord												;61001E9A
	move.l	$000C(a4),d7														;2E2C000C
	lea		adrEA00463E.w,a6													;4DF8463E	;Short Absolute converted to symbol!
	move.w	(sp),d1																;3217
	asl.w	#$03,d1																;E741
	add.w	d1,a6																;DCC1
	moveq	#$00,d0																;7000
	moveq	#-$01,d2															;74FF
	moveq	#$07,d1																;7207
adrLp0047DC:		; Memory Address ($47DC) and binary offset [$4458]
	move.b	$00(a6,d1.w),d0														;10361000
	eor.b	#$1F,d0																;0A00001F
	btst	d0,d7																;0107
	bne.s	adrCd0047F4															;660C
	eor.b	#$1F,d0																;0A00001F
	move.w	d0,d2																;3400
	tst.l	d2																	;4A82
	bpl.s	adrCd004802															;6A10
	swap	d2																	;4842
adrCd0047F4:		; Memory Address ($47F4) and binary offset [$4470]
	dbra	d1,adrLp0047DC														;51C9FFE6
	move.w	#$FFFF,$0044(a5)													;3B7CFFFF0044
	tst.l	d2																	;4A82
	bmi.s	adrCd004814															;6B12
adrCd004802:		; Memory Address ($4802) and binary offset [$447E]
	move.b	d2,$0045(a5)														;1B420045
	swap	d2																	;4842
	move.b	d2,$0044(a5)														;1B420044
	lea		SelectNewSpellMsg.l,a6												;4DF900004AA2
	bra.s	adrCd00481A															;6006

adrCd004814:		; Memory Address ($4814) and binary offset [$4490]
	lea		ThouHastAllMsg.l,a6													;4DF900004AB9
adrCd00481A:		; Memory Address ($481A) and binary offset [$4496]
	bsr		adrCd0049AE															;61000192
	move.w	(sp)+,d1															;321F
	lea		adrEA00463A.w,a6													;4DF8463A	;Short Absolute converted to symbol!
	move.b	$00(a6,d1.w),adrB_00D92B.l											;13F610000000D92B
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	$000A(a5),a0														;D0ED000A
	add.w	#$03D2,a0															;D0FC03D2
	move.b	$0044(a5),d0														;102D0044
	bsr		adrCd004852															;61000012
	move.b	$0045(a5),d0														;102D0045
	bsr		adrCd004852															;6100000A
	move.b	#$02,$004E(a5)														;1B7C0002004E
	rts																			;4E75

adrCd004852:		; Memory Address ($4852) and binary offset [$44CE]
	tst.b	d0																	;4A00
	bmi.s	adrCd00486E															;6B18
	and.w	#$00FF,d0															;024000FF
	move.l	a0,-(sp)															;2F08
	bsr		adrCd00C2D4															;61007A76
	moveq	#$07,d6																;7C07
	jsr		adrLp00CFDA.l														;4EB90000CFDA
	move.l	(sp)+,a0															;205F
	add.w	#$01B8,a0															;D0FC01B8
adrCd00486E:		; Memory Address ($486E) and binary offset [$44EA]
	rts																			;4E75

adrCd004870:		; Memory Address ($4870) and binary offset [$44EC]
	bclr	#$07,$0001(a5)														;08AD00070001
	beq.s	adrCd00486E															;67F6
	move.l	$0002(a5),d1														;222D0002
	sub.w	$0008(a5),d1														;926D0008
	cmpi.w	#$0018,d1															;0C410018
	bcs.s	adrCd00486E															;65E8
	cmpi.w	#$0027,d1															;0C410027
	bcs.s	adrCd0048AA															;651E
	sub.b	#$42,d1																;04010042
	bcs.s	adrCd00486E															;65DC
	cmpi.b	#$10,d1																;0C010010
	bcc.s	adrCd00486E															;64D6
	swap	d1																	;4841
	sub.w	#$00C0,d1															;044100C0
	bcs.s	adrCd00486E															;65CE
	cmpi.b	#$10,d1																;0C010010
	bcc.s	adrCd00486E															;64C8
	bra		adrCd0046CC															;6000FE24

adrCd0048AA:		; Memory Address ($48AA) and binary offset [$4526]
	swap	d1																	;4841
	sub.b	#$90,d1																;04010090
	bcs.s	adrCd00486E															;65BC
	cmpi.b	#$40,d1																;0C010040
	bcc.s	adrCd00486E															;64B6
	swap	d1																	;4841
	sub.w	#$0018,d1															;04410018
	lsr.w	#$03,d1																;E649
	move.b	$44(a5,d1.w),d0														;10351044
	bmi.s	adrCd00486E															;6BA8
	move.b	d0,$0044(a5)														;1B400044
	jsr		InitialiseText.l													;4EB90000D09A
	lea		SpellDescriptions.l,a3												;47F900019F8E
	moveq	#$00,d0																;7000
	move.b	$0044(a5),d0														;102D0044
	jsr		Print_word.l														;4EB90000D7E2
	jsr		TerminateText.l														;4EB90000D008
	move.l	#$00100018,d5														;2A3C00100018
	add.w	$0008(a5),d5														;DA6D0008
	move.l	#$003F0090,d4														;283C003F0090
	moveq	#$00,d3																;7600
	jsr		BW_draw_bar.l														;4EB90000DA68
	move.b	$0044(a5),d0														;102D0044
	bsr		Character_GetClassIndex												;61001FFA
	lea		adrEA00463A.w,a6													;4DF8463A	;Short Absolute converted to symbol!
	move.b	$00(a6,d0.w),adrB_00D92B.l											;13F600000000D92B
	add.w	#$0064,d0															;06400064
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	$000A(a5),a0														;D0ED000A
	add.w	#$0A86,a0															;D0FC0A86
	jsr		Draw_PocketGraphic.l												;4EB90000CAEA
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	$000A(a5),a0														;D0ED000A
	add.w	#$03D2,a0															;D0FC03D2
	moveq	#$00,d0																;7000
	move.b	$0044(a5),d0														;102D0044
	bsr		adrCd004852															;6100FF10
	bsr		adrCd004996															;61000050
	lea		adrEA004A5E.l,a6													;4DF900004A5E
	add.w	#$0030,d1															;06410030
	move.b	d1,$000E(a6)														;1D41000E
	jsr		Convert_ByteToDecimalText.l											;4EB90000CEC4
	move.w	d1,$0012(a6)														;3D410012
	jsr		Print_fflim_text.l													;4EB90000D0C6
	moveq	#$00,d0																;7000
	move.b	$004F(a5),d0														;102D004F
	move.b	$18(a5,d0.w),d0														;10350018
	bsr		Load_ChampionStatRecord												;61001CEE
	move.b	$0044(a5),$0013(a4)													;196D00440013
	clr.b	$0015(a4)															;422C0015
	bsr		adrCd006712															;61001D92
	move.b	#$FF,$0013(a4)														;197C00FF0013
	or.b	#$40,$0054(a5)														;002D00400054
	move.b	#$03,$004E(a5)														;1B7C0003004E
adrCd004994:		; Memory Address ($4994) and binary offset [$4610]
	rts																			;4E75

adrCd004996:		; Memory Address ($4996) and binary offset [$4612]
	lea		SpellCost_DataTable.l,a0											;41F90000685E
	moveq	#$00,d7																;7E00
	move.b	$0044(a5),d7														;1E2D0044
	move.b	$00(a0,d7.w),d0														;10307000
	move.b	d0,d1																;1200
	asl.b	#$02,d0																;E500
	add.b	d1,d0																;D001
	rts																			;4E75

adrCd0049AE:		; Memory Address ($49AE) and binary offset [$462A]
	jsr		InitialiseText.l													;4EB90000D09A
	jsr		Print_fflim_text.l													;4EB90000D0C6
	moveq	#$00,d0																;7000
	move.b	$004F(a5),d0														;102D004F
	move.b	$18(a5,d0.w),d0														;10350018
	and.w	#$000F,d0															;0240000F
	moveq	#$11,d6																;7C11
	jsr		Print_wordstext.l													;4EB90000D7E6
	jmp		TerminateText.l														;4EF90000D008

adrCd0049D6:		; Memory Address ($49D6) and binary offset [$4652]
	bclr	#$07,$0001(a5)														;08AD00070001
	beq.s	adrCd004994															;67B6
	move.l	$0002(a5),d1														;222D0002
	sub.w	$0008(a5),d1														;926D0008
	sub.b	#$42,d1																;04010042
	bcs.s	adrCd004994															;65A8
	cmpi.b	#$10,d1																;0C010010
	bcc.s	adrCd004994															;64A2
	swap	d1																	;4841
	sub.w	#$0070,d1															;04410070
	bcs.s	adrCd004994															;659A
	cmpi.w	#$0010,d1															;0C410010
	bcs.s	adrCd004A10															;6510
	cmpi.w	#$0050,d1															;0C410050
	bcs.s	adrCd004994															;658E
	cmpi.w	#$0060,d1															;0C410060
	bcc.s	adrCd004994															;6488
	bra		adrCd0046CC															;6000FCBE

adrCd004A10:		; Memory Address ($4A10) and binary offset [$468C]
	bsr.s	adrCd004996															;6184
	move.w	d0,d2																;3400
	moveq	#$00,d1																;7200
	move.b	$004F(a5),d1														;122D004F
	move.b	$18(a5,d1.w),d0														;10351018
	move.b	d0,d1																;1200
	asl.b	#$04,d1																;E901
	lea		Character_Pockets_DataTable.l,a4									;49F90000ED2A
	add.w	d1,a4																;D8C1
	move.b	$000C(a4),d3														;162C000C
	sub.b	d2,d3																;9602
	bcs.s	adrCd004A54															;6522
	move.b	d3,$000C(a4)														;1943000C
	bsr		Load_ChampionStatRecord												;61001C28
	eor.b	#$1F,d7																;0A07001F
	move.l	$000C(a4),d0														;202C000C
	bset	d7,d0																;0FC0
	move.l	d0,$000C(a4)														;2940000C
	subq.b	#$01,$001E(a4)														;532C001E
	subq.b	#$01,$004F(a5)														;532D004F
	bra		adrCd004580															;6000FB2E

adrCd004A54:		; Memory Address ($4A54) and binary offset [$46D0]
	lea		PauperMsg.l,a6														;4DF900004AD0
	bra		adrCd0049AE															;6000FF52

adrEA004A5E:		; Memory Address ($4A5E) and binary offset [$46DA]
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

adrCd004AE8:		; Memory Address ($4AE8) and binary offset [$4764]
	moveq	#$00,d0																;7000
	move.b	(a6),d0																;1016
	move.l	a6,-(sp)															;2F0E
	bsr.s	adrCd004B28															;6138
	move.l	(sp)+,a6															;2C5F
	jsr		Print_timed_message.l												;4EB90000D86A
	move.b	#$32,$003F(a5)														;1B7C0032003F
adrCd004AFE:		; Memory Address ($4AFE) and binary offset [$477A]
	bclr	#$07,$0001(a5)														;08AD00070001
	beq.s	adrCd004B12															;670C
	clr.w	$0014(a5)															;426D0014
	and.b	#$01,(a5)															;02150001
	clr.b	$0056(a5)															;422D0056
adrCd004B12:		; Memory Address ($4B12) and binary offset [$478E]
	rts																			;4E75

adrEA004B14:		; Memory Address ($4B14) and binary offset [$4790]
	dc.w	$002B	;002B
	dc.w	$8D2C	;8D2C
	dc.w	$FF00	;FF00
adrEA004B1A:		; Memory Address ($4B1A) and binary offset [$4796]
	dc.w	$000B	;000B
	dc.w	$1828	;1828
	dc.w	$3235	;3235
	dc.w	$3C41	;3C41
	dc.w	$4641	;4641
	dc.w	$4146	;4146
	dc.w	$78B4	;78B4

adrCd004B28:		; Memory Address ($4B28) and binary offset [$47A4]
	addq.b	#$01,(a4)															;5214
	moveq	#$00,d1																;7200
	move.b	(a4),d1																;1214
	move.b	adrEA004B1A(pc,d1.w),$001C(a4)										;197B10EA001C
	move.w	d0,d4																;3800
	bsr		RandomGen_BytewithOffset											;61000A74
	and.w	#$000F,d0															;0240000F
	move.w	d4,d1																;3204
	and.w	#$0001,d1															;02410001
	beq.s	adrCd004B48															;6702
	lsr.w	#$01,d0																;E248
adrCd004B48:		; Memory Address ($4B48) and binary offset [$47C4]
	add.w	#$0009,d0															;06400009
	add.b	$0006(a4),d0														;D02C0006
	bcc.s	adrCd004B56															;6404
	move.b	#$FD,d0																;103C00FD
adrCd004B56:		; Memory Address ($4B56) and binary offset [$47D2]
	move.b	d0,$0006(a4)														;19400006
	bsr		RandomGen_BytewithOffset											;61000A50
	and.w	#$0007,d0															;02400007
	addq.w	#$01,d0																;5240
	add.b	$0008(a4),d0														;D02C0008
	cmpi.w	#$0064,d0															;0C400064
	bcs.s	adrCd004B70															;6502
	moveq	#$63,d0																;7063
adrCd004B70:		; Memory Address ($4B70) and binary offset [$47EC]
	move.b	d0,$0008(a4)														;19400008
	lea		adrEA004C00.l,a2													;45F900004C00
	move.w	d4,d0																;3004
	and.w	#$0003,d0															;02400003
	asl.w	#$02,d0																;E540
	add.w	d0,a2																;D4C0
	moveq	#$03,d6																;7C03
adrLp004B86:		; Memory Address ($4B86) and binary offset [$4802]
	cmp.b	#$06,(a2)															;0C120006
	bne.s	adrCd004B92															;6606
	bsr		adrCd005556															;610009C8
	bra.s	adrCd004BA2															;6010

adrCd004B92:		; Memory Address ($4B92) and binary offset [$480E]
	bsr		RandomGen_BytewithOffset											;61000A18
	and.w	#$0007,d0															;02400007
	cmp.b	#$04,(a2)															;0C120004
	bne.s	adrCd004BA2															;6602
	lsr.w	#$01,d0																;E248
adrCd004BA2:		; Memory Address ($4BA2) and binary offset [$481E]
	addq.w	#$01,d0																;5240
	add.b	$01(a4,d6.w),d0														;D0346001
	cmpi.b	#$64,d0																;0C000064
	bcs.s	adrCd004BB0															;6502
	moveq	#$63,d0																;7063
adrCd004BB0:		; Memory Address ($4BB0) and binary offset [$482C]
	move.b	d0,$01(a4,d6.w)														;19806001
	addq.w	#$01,a2																;524A
	dbra	d6,adrLp004B86														;51CEFFCE
	bclr	#$07,$001E(a4)														;08AC0007001E
	move.w	d4,d0																;3004
	and.w	#$0003,d4															;02440003
	subq.w	#$01,d4																;5344
	bne.s	Recalculate_CharacterDerivedStats									;6604
	addq.b	#$01,$001E(a4)														;522C001E
Recalculate_CharacterDerivedStats:		; Memory Address ($4BCE) and binary offset [$484A]
	bsr		Calculate_SpellPracticeThreshold									;6100BD34
	moveq	#$00,d2																;7400
	move.b	(a4),d2																;1414
	lea		adrEA004B1A.w,a6													;4DF84B1A	;Short Absolute converted to symbol!
	move.b	$00(a6,d2.w),$001C(a4)												;19762000001C
	move.b	$0002(a4),d1														;122C0002
	lsr.b	#$04,d1																;E809
	lsr.b	#$01,d2																;E20A
	add.b	d2,d1																;D202
	sub.b	#$0F,d1																;0401000F
	neg.b	d1																	;4401
	cmpi.b	#$08,d1																;0C010008
	bcc.s	adrCd004BF8															;6402
	moveq	#$08,d1																;7208
adrCd004BF8:		; Memory Address ($4BF8) and binary offset [$4874]
	asl.b	#$04,d1																;E901
	move.b	d1,$0019(a4)														;19410019
	rts																			;4E75

adrEA004C00:		; Memory Address ($4C00) and binary offset [$487C]
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
	cmp.w	#$0008,$0042(a5)													;0C6D00080042
	bne.s	adrCd004C3E															;6626
	cmp.w	#$0006,$0044(a5)													;0C6D00060044
	bcc.s	adrCd004C3E															;641E
	eor.w	#$0001,$0044(a5)													;0A6D00010044
	bra		Draw_PartyCommandMenu												;60003144

adrCd004C2A:		; Memory Address ($4C2A) and binary offset [$48A6]
	tst.w	$0042(a5)															;4A6D0042
	bpl.s	adrCd004C40															;6A10
	bclr	#$07,$0001(a5)														;08AD00070001
	beq.s	adrCd004C3E															;6706
	move.w	#$001A,$000C(a5)													;3B7C001A000C
adrCd004C3E:		; Memory Address ($4C3E) and binary offset [$48BA]
	rts																			;4E75

adrCd004C40:		; Memory Address ($4C40) and binary offset [$48BC]
	bclr	#$07,$0001(a5)														;08AD00070001
	beq.s	adrCd004C56															;670E
	lea		Interface_Hitboxes_Command.l,a6										;4DF90000EAFA
	moveq	#$1C,d0																;Starts the command-row hitbox scan at action ID $1C.
	moveq	#$22,d2																;Sets the exclusive upper bound for the six command-row hitboxes, covering action IDs $1C-$21.
	bra		HitTest_PlayerInterfaceActions										;60000160

adrCd004C56:		; Memory Address ($4C56) and binary offset [$48D2]
	moveq	#-$01,d0															;70FF
	move.l	$0002(a5),d1														;222D0002
	sub.w	$0008(a5),d1														;926D0008
	sub.w	#$003A,d1															;0441003A
	bcs.s	adrCd004C80															;651A
	lsr.w	#$03,d1																;E649
	and.w	#$0003,d1															;02410003
	move.w	d1,d0																;3001
	swap	d1																	;4841
	move.l	$0046(a5),a0														;206D0046
	cmp.b	$00(a0,d0.w),d1														;B2300000
	bcs.s	adrCd004C7E															;6504
	add.w	#$0100,d0															;06400100
adrCd004C7E:		; Memory Address ($4C7E) and binary offset [$48FA]
	ror.w	#$08,d0																;E058
adrCd004C80:		; Memory Address ($4C80) and binary offset [$48FC]
	cmp.w	$0040(a5),d0														;B06D0040
	bne.s	adrCd004C88															;6602
	rts																			;4E75

adrCd004C88:		; Memory Address ($4C88) and binary offset [$4904]
	move.w	d0,$0040(a5)														;3B400040
	bra		Draw_PartyCommandMenu												;600030DE

Scan_PlayerInterfaceActions:		; Memory Address ($5014) and binary offset [$4C90]
	; Scans interface state and resolves direct or pending player actions.
	move.w	#$FFFF,$000C(a5)													;3B7CFFFF000C
	move.w	$0022(a5),$0024(a5)													;3B6D00220024
	btst	#$06,$0018(a5)														;082D00060018
	bne.s	adrCd004C3E															;669A
	tst.b	$003D(a5)															;4A2D003D
	bmi.s	adrCd004CB2															;6B08
	move.b	#$FF,$003D(a5)														;1B7C00FF003D
	bra.s	adrCd004D08															;6056

adrCd004CB2:		; Memory Address ($4CB2) and binary offset [$492E]
	moveq	#$05,d1																;7205
	bsr		adrCd005500															;6100084A
	tst.b	d3																	;4A03
	bpl.s	adrCd004D08															;6A4C
	bsr		adrCd008498															;610037DA
	move.w	$00(a6,d0.w),d1														;32360000
	and.w	#$0007,d1															;02410007
	cmpi.w	#$0006,d1															;0C410006
	bne.s	adrCd004D08															;663A
	move.b	$00(a6,d0.w),d1														;12360000
	and.w	#$0003,d1															;02410003
	subq.w	#$01,d1																;5341
	bne.s	adrCd004D08															;662E
	bclr	#$07,$01(a6,d0.w)													;08B600070001
	move.w	$0058(a5),d2														;342D0058
	move.w	d2,d1																;3202
	subq.w	#$01,d1																;5341
	move.w	d1,$0058(a5)														;3B410058
	bsr		adrCd0084BA															;610037CC
	move.l	d7,$001C(a5)														;2B47001C
	bsr		adrCd0084D6															;610037E0
	bsr		adrCd008498															;6100379E
	bset	#$07,$01(a6,d0.w)													;08F600070001
	move.b	#$02,$003D(a5)														;1B7C0002003D
adrCd004D08:		; Memory Address ($4D08) and binary offset [$4984]
	cmp.w	#$0008,$0042(a5)													;0C6D00080042
	bne.s	adrCd004D1A															;660A
	bsr		Interface_CheckSelectedCellInteraction								;6100E6AC
	bcs.s	adrCd004D1A															;6504
	bsr		adrCd00332A															;6100E612
adrCd004D1A:		; Memory Address ($4D1A) and binary offset [$4996]
	move.b	$0014(a5),d0														;102D0014
	beq.s	Consume_PlayerPendingAction											;6712
	cmpi.b	#$01,d0																;0C000001
	beq.s	adrCd004D8C															;6766
	cmpi.b	#$02,d0																;0C000002
	beq		adrCd00465E															;6700F932
	bra		Resolve_PlayerContextAction											;600000BA

Consume_PlayerPendingAction:		; Memory Address ($50B6) and binary offset [$4D32]
	; Copies PlayerX_Data+$56 into PlayerX_Data+$0C, then clears the pending byte.
	moveq	#$00,d0																;7000
	move.b	Player_PendingActionOffset(a5),d0									;Offset read when transferring a pending action into the active command.
	beq.s	adrCd004D4E															;6714
	move.w	d0,Player_ActionCommandOffset(a5)									;Offset of the active per-player interface command.
	clr.b	$0056(a5)															;422D0056
	cmp.w	#$0004,$0014(a5)													;0C6D00040014
	bne.s	adrCd004D4E															;6604
	bsr		Click_CloseCurrentPage												;61000A58
adrCd004D4E:		; Memory Address ($4D4E) and binary offset [$49CA]
	cmp.w	#$005E,$0002(a5)													;0C6D005E0002
	bcs		adrCd004C2A															;6500FED4
	moveq	#-$01,d0															;70FF
	tst.w	$0040(a5)															;4A6D0040
	bpl		adrCd004C88															;6A00FF28
	bclr	#$07,$0001(a5)														;08AD00070001
	beq.s	adrCd004DA8															;673E
	moveq	#$00,d0																;7000
	move.b	$0015(a5),d0														;102D0015
	asl.w	#$02,d0																;E540
	move.l	adrJT004D78(pc,d0.w),a0												;207B0004
	jmp		(a0)																;4ED0

adrJT004D78:		; Memory Address ($4D78) and binary offset [$49F4]
	dc.l	Begin_HitTestMainInterfaceActions	;00004DAA
	dc.l	Click_CloseCurrentPage	;000057A4
	dc.l	Resolve_PlayerContextAction	;00004DEA
	dc.l	adrJA005628	;00005628
	dc.l	Click_CloseCurrentPage	;000057A4

adrCd004D8C:		; Memory Address ($4D8C) and binary offset [$4A08]
	bclr	#$07,$0001(a5)														;08AD00070001
	beq.s	adrCd004DA8															;6714
	clr.b	$0014(a5)															;422D0014
	move.b	#$FF,$0053(a5)														;1B7C00FF0053
	lea		Notice_View_NormalRestored.w,a6										;4DF841ED	;Short Absolute converted to symbol!
	jmp		Print_timed_message.l												;4EF90000D86A

adrCd004DA8:		; Memory Address ($4DA8) and binary offset [$4A24]
	rts																			;4E75

Begin_HitTestMainInterfaceActions:		; Memory Address ($4DAA) and binary offset [$4A26]
	; Selects the 17-record main hitbox table before entering the shared hit
	; tester.
	lea		Interface_Hitboxes_Main.l,a6										;4DF90000EA72
	moveq	#$00,d0																;7000
	moveq	#$11,d2																;Sets the exclusive upper bound for the 17-record main player-interface hitbox scan, covering action IDs $00-$10.
HitTest_PlayerInterfaceActions:		; Memory Address ($5138) and binary offset [$4DB4]
	; Tests pointer coordinates against interface rectangles and writes the
	; resulting action directly to PlayerX_Data+$0C.
	move.l	$0002(a5),d1														;222D0002
	sub.w	$0008(a5),d1														;Subtracts the active player's horizontal interface offset before comparing the pointer X coordinate with a hitbox.
adrCd004DBC:		; Memory Address ($4DBC) and binary offset [$4A38]
	cmp.w	$0004(a6),d1														;B26E0004
	bcs.s	adrCd004DE0															;651E
	cmp.w	$0006(a6),d1														;B26E0006
	beq.s	adrCd004DCA															;6702
	bcc.s	adrCd004DE0															;6416
adrCd004DCA:		; Memory Address ($4DCA) and binary offset [$4A46]
	swap	d1																	;4841
	cmp.w	(a6),d1																;B256
	bcs.s	adrCd004DDE															;650E
	cmp.w	$0002(a6),d1														;B26E0002
	beq.s	Store_HitTestActionCommand											;6702
	bcc.s	adrCd004DDE															;6406
Store_HitTestActionCommand:		; Memory Address ($515C) and binary offset [$4DD8]
	; Stores the action number selected by the interface hit test.
	move.w	d0,$000C(a5)														;Stores the zero-based interface action selected by the first matching rectangle in PlayerX_Data.
	rts																			;4E75

adrCd004DDE:		; Memory Address ($4DDE) and binary offset [$4A5A]
	swap	d1																	;4841
adrCd004DE0:		; Memory Address ($4DE0) and binary offset [$4A5C]
	addq.w	#$08,a6																;Advances to the next eight-byte interface hitbox record after a failed rectangle comparison.
	addq.w	#$01,d0																;5240
	cmp.w	d2,d0																;B042
	bcs.s	adrCd004DBC															;65D4
	rts																			;4E75

Resolve_PlayerContextAction:		; Memory Address ($516E) and binary offset [$4DEA]
	; Resolves context-dependent actions and may invoke the display-action hit-test
	; routine.
	moveq	#$00,d0																;7000
	move.b	$0014(a5),d0														;102D0014
	bne.s	adrCd004E0C															;661A
	moveq	#-$01,d2															;74FF
	bsr		adrCd00C650															;6100785A
	bmi.s	adrCd004E12															;6B18
	move.w	#$0002,$0014(a5)													;3B7C00020014
	move.w	$000C(a5),d0														;302D000C
	add.w	#$0011,d0															;06400011
	move.b	d0,$0014(a5)														;1B400014
adrCd004E0C:		; Memory Address ($4E0C) and binary offset [$4A88]
	move.w	d0,$000C(a5)														;3B40000C
	rts																			;4E75

adrCd004E12:		; Memory Address ($4E12) and binary offset [$4A8E]
	bsr		HitTest_DisplayAction												;61000A68
	tst.w	$000C(a5)															;4A6D000C
	bpl.s	adrCd004E4C															;6A30
	bsr		Load_CurrentChampionStatRecord										;6100183E
	tst.b	$0013(a4)															;4A2C0013
	bmi.s	adrCd004E4C															;6B26
	cmpi.w	#$0048,d1															;0C410048
	bcs.s	adrCd004E4C															;6520
	cmpi.w	#$0058,d1															;0C410058
	bcc.s	adrCd004E4C															;641A
	swap	d1																	;4841
	cmpi.w	#$00E0,d1															;0C4100E0
	bcs.s	adrCd004E4C															;6512
	cmpi.w	#$00F0,d1															;0C4100F0
	bcs.s	adrCd004E46															;6506
	cmpi.w	#$0132,d1															;0C410132
	bcs.s	adrCd004E4E															;6508
adrCd004E46:		; Memory Address ($4E46) and binary offset [$4AC2]
	move.w	#$0015,$000C(a5)													;3B7C0015000C
adrCd004E4C:		; Memory Address ($4E4C) and binary offset [$4AC8]
	rts																			;4E75

adrCd004E4E:		; Memory Address ($4E4E) and binary offset [$4ACA]
	swap	d1																	;4841
	cmpi.w	#$0050,d1															;0C410050
	bcs.s	adrCd004E4C															;65F6
	swap	d1																	;4841
	cmpi.w	#$0128,d1															;0C410128
	bcc.s	adrCd004E72															;6414
	cmpi.w	#$011A,d1															;0C41011A
	bcc.s	adrCd004E4C															;64E8
	cmpi.w	#$0110,d1															;0C410110
	bcs.s	adrCd004E4C															;65E2
	addq.b	#$01,$0014(a4)														;522C0014
	bra		adrCd0066F6															;60001886

adrCd004E72:		; Memory Address ($4E72) and binary offset [$4AEE]
	subq.b	#$01,$0014(a4)														;532C0014
	bra		adrCd0066F6															;6000187E

Click_LaunchSpellFromBook:		; Memory Address ($4E7A) and binary offset [$4AF6]
	bsr.s	Cast_SelectedChampionSpell											;6112
	bne.s	adrCd004E86															;6608
	bsr		adrCd006698															;61001818
	bsr		adrCd00C85E															;610079DA
adrCd004E86:		; Memory Address ($4E86) and binary offset [$4B02]
	move.w	#$0002,$0014(a5)													;3B7C00020014
adrCd004E8C:		; Memory Address ($4E8C) and binary offset [$4B08]
	rts																			;4E75

Cast_SelectedChampionSpell:		; Memory Address ($5212) and binary offset [$4E8E]
	; Validates and charges the selected champion spell, performs its cast check,
	; dispatches the spell handler, records practice, and reports failure.
	bsr		Load_CurrentChampionStatRecord										;610017CC
	clr.w	SpellEntity_PlacementConflictFlag.l									;42790000505A
	move.b	$0007(a5),adrB_00EE3E.l												;13ED00070000EE3E
CastSpell_ValidateSelection:		; Memory Address ($5224) and binary offset [$4EA0]
	; Rejects an empty spell selection and closes communication mode before every
	; spell except Beguile.
	move.b	$0013(a4),d0														;Loads the selected zero-based spell index; $FF means that no spell is queued.
	bmi.s	adrCd004E8C															;6BE6
	subq.b	#$03,d0																;Tests spell index 3, Beguile, which is allowed to preserve communication mode.
	beq.s	CastSpell_ApplyVitalityCost											;6714
	cmp.w	#$0008,$0042(a5)													;0C6D00080042
	bne.s	CastSpell_ApplyVitalityCost											;660C
	movem.l	d0-d7/a0-a6,-(sp)													;48E7FFFE
	bsr		adrCd00332A															;Closes the current interface mode before casting any spell other than Beguile.
	movem.l	(sp)+,d0-d7/a0-a6													;4CDF7FFF
CastSpell_ApplyVitalityCost:		; Memory Address ($5242) and binary offset [$4EBE]
	; Removes four vitality for the cast attempt and clamps the champion's current
	; vitality to zero.
	subq.b	#SpellCasting_VitalityCost,$0007(a4)								;Vitality removed when a champion launches a spell.
	bcc.s	CastSpell_ApplySpellPointCost										;6404
	clr.b	$0007(a4)															;422C0007
CastSpell_ApplySpellPointCost:		; Memory Address ($524C) and binary offset [$4EC8]
	; Applies action state, calculates spell-point cost, consumes ring-assisted
	; casts, and rejects insufficient spell points.
	move.b	#SpellCasting_ActionCooldown,$001B(a4)								;Applies the champion action cooldown as soon as the cast attempt is committed.
	clr.b	$0011(a4)															;Removes the champion's currently worn spell before resolving the new cast.
	bsr		adrCd00688C															;Calculates the spell-point cost, including ring-based free casting and the champion's power setting.
	move.b	$0009(a4),d1														;122C0009
	sub.b	d0,d1																;Subtracts the calculated cost from current spell points; borrow rejects the cast.
	bcs		CastSpell_RejectInsufficientSpellPoints								;650000F8
	move.b	d1,$0009(a4)														;19410009
	tst.b	d0																	;4A00
	bne.s	CastSpell_CalculateQualityAndCooldown								;6612
	move.b	$0013(a4),d0														;102C0013
	bsr		Character_GetClassIndex												;61001A12
	lea		RingUses.l,a0														;41F90000EE32
	subq.b	#$01,$00(a0,d0.w)													;Consumes one use from the matching magic ring when it reduced the spell-point cost to zero.
CastSpell_CalculateQualityAndCooldown:		; Memory Address ($527E) and binary offset [$4EFA]
	; Calculates signed casting quality and accumulates the selected spell's
	; cooldown up to 100.
	bsr		Draw_MainPlayerInterface											;610031CE
	bsr		Calculate_SpellCastingQuality										;Builds signed casting quality from practice, profession, level, power, equipment and spell difficulty.
	moveq	#$00,d0																;7000
	move.b	$0013(a4),d0														;102C0013
	lea		SpellCost_DataTable.l,a6											;4DF90000685E
	move.b	$00(a6,d0.w),d1														;12360000
	addq.b	#$05,d1																;5A01
	add.b	$0015(a4),d1														;Accumulates the selected spell's base delay onto the champion's current spell cooldown.
	cmpi.b	#SpellCasting_CooldownMaximum,d1									;Clamps accumulated spell cooldown to 100.
	bcs.s	CastSpell_SelectHandler												;6502
	moveq	#$64,d1																;7264
CastSpell_SelectHandler:		; Memory Address ($52A4) and binary offset [$4F20]
	; Loads the selected spell routine from the thirty-two-entry relative-offset
	; dispatch table and performs the final cast roll.
	move.b	d1,$0015(a4)														;19410015
	add.w	d0,d0																;D040
	lea		Spells_01_Armour.l,a0												;41F90000505C
	lea		Spells_LookupTable.l,a6												;4DF90000500C
	add.w	$00(a6,d0.w),a0														;Selects the spell handler from the 32-entry relative-offset table.
	bsr		adrCd005546															;Rolls three six-sided random values plus the routine's base of three for the final cast check.
	add.b	d0,d7																;Adds the 3d6 roll to signed casting quality; a negative result produces SPELL FAILED.
	bmi.s	CastSpell_SelectFailedNotice										;6B72
	move.w	d7,-(sp)															;3F07
	bsr		adrCd008498															;61003556
	move.w	(sp)+,d7															;3E1F
	move.w	$00(a6,d0.w),d1														;32360000
	and.w	#$0007,d1															;02410007
	subq.w	#$06,d1																;5D41
	bne.s	CastSpell_ExecuteHandler											;660C
	move.b	$00(a6,d0.w),d1														;12360000
	and.w	#$0003,d1															;02410003
	beq		CastSpell_SelectFizzledNotice										;67000092
CastSpell_ExecuteHandler:		; Memory Address ($52E2) and binary offset [$4F5E]
	; Executes the selected spell handler and refreshes champion or player state
	; after the effect is applied.
	move.l	a4,-(sp)															;2F0C
	jsr		(a0)																;Executes the selected spell handler with D7 carrying the successful cast's effective power.
	moveq	#$00,d0																;7000
	move.b	adrB_00EE3E.l,d0													;10390000EE3E
	bsr		adrCd004078															;6100F10C
	tst.w	d1																	;4A41
	bmi.s	CastSpell_RecordPractice											;6B1C
	beq.s	CastSpell_RefreshChampionStatus										;6712
	move.w	d1,d7																;3E01
	tst.w	$0042(a5)															;4A6D0042
	bpl.s	CastSpell_RecordPractice											;6A12
	bsr		Refresh_PartyShieldSlotIfDirty										;61002F72
	bsr		Draw_PartyShieldChainStrip											;61002F50
	bra.s	CastSpell_RecordPractice											;6008

CastSpell_RefreshChampionStatus:		; Memory Address ($530A) and binary offset [$4F86]
	; Refreshes the selected champion's displayed status when the post-spell party
	; lookup returns the active slot.
	move.w	$0006(a5),d7														;3E2D0006
	bsr		Draw_MainChampionAvatarInnerFrame									;61007D4C
CastSpell_RecordPractice:		; Memory Address ($5312) and binary offset [$4F8E]
	; Increments the casting champion's per-spell practice counter with saturation
	; at $FF.
	move.l	(sp)+,a4															;285F
	move.l	#adrL_007E22,a0														;207C00007E22
	add.l	a4,a0																;D1CC
	moveq	#$00,d0																;7000
	move.b	$0013(a4),d0														;102C0013
	addq.b	#$01,$00(a0,d0.w)													;Increments this champion's per-spell practice counter after the handler runs.
	bcc.s	CastSpell_Complete													;6404
	subq.b	#$01,$00(a0,d0.w)													;Restores a saturated practice counter to $FF after byte overflow.
CastSpell_Complete:		; Memory Address ($532C) and binary offset [$4FA8]
	; Selects the empty notice after a successful spell before common cast
	; finalisation.
	lea		NullString.l,a6														;4DF90000CAE9
	bra.s	CastSpell_Finalize													;600E

CastSpell_SelectFailedNotice:		; Memory Address ($5334) and binary offset [$4FB0]
	; Selects SPELL FAILED and its message-state value after a negative
	; casting-quality result.
	lea		Notice_SpellFailed.l,a6												;4DF90000504C
	move.w	#$0004,adrW_00D92A.l												;33FC00040000D92A
CastSpell_Finalize:		; Memory Address ($5342) and binary offset [$4FBE]
	; Clears the queued spell and displays the selected result notice when message
	; output is enabled.
	move.b	#$FF,$0013(a4)														;Clears the queued spell index when the cast succeeds, fails or fizzles.
	tst.b	SpellEntity_AIOriginFlag.l											;4A390000505B
	bne.s	Return_CastSpell													;6608
	jsr		LowerText.l															;4EB90000CFB8
	moveq	#$00,d0																;7000
Return_CastSpell:		; Memory Address ($5358) and binary offset [$4FD4]
	; Shared return from spell-cast success and notice handling.
	rts																			;4E75

CastSpell_RejectInsufficientSpellPoints:		; Memory Address ($535A) and binary offset [$4FD6]
	; Displays the cost-too-high notice and returns one when the champion cannot
	; pay the spell-point cost.
	tst.b	SpellEntity_AIOriginFlag.l											;4A390000505B
	bne.s	Return_CastSpell													;66F6
	lea		Msg_CostTooHigh.l,a6												;4DF90000EA62
	jsr		LowerText.l															;4EB90000CFB8
	moveq	#$01,d0																;7001
	rts																			;4E75

CastSpell_SelectFizzledNotice:		; Memory Address ($5372) and binary offset [$4FEE]
	; Selects SPELL FIZZLED and its message-state value when the target cell
	; suppresses the spell.
	lea		Notice_SpellFizzle.l,a6												;4DF900004FFE
	move.w	#$0008,adrW_00D92A.l												;33FC00080000D92A
	bra.s	CastSpell_Finalize													;60C0

Notice_SpellFizzle:
	dc.b	'SPELL FIZZLED'	;5350454C4C2046495A5A4C4544
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
	dc.b	'SPELL FAILED'	;5350454C4C204641494C4544
	dc.b	$FF	;FF
	dc.b	$00	;00
SpellEntity_PlacementConflictFlag:		; Memory Address ($53DE) and binary offset [$505A]
	; Working flag set when spell-entity placement crosses or conflicts with the
	; resolved map destination.
	ds.b	$1
SpellEntity_AIOriginFlag:		; Memory Address ($53DF) and binary offset [$505B]
	; Working origin value used by AI-created entities and to suppress
	; player-facing cast notices.
	ds.b	$1
Spells_01_Armour:		; Memory Address ($505C) and binary offset [$4CD8]
	moveq	#WornSpell_Armour,d4												;7800
	addq.w	#$02,d7																;5447
StoreWornSpell_ClampPower:		; Memory Address ($53E4) and binary offset [$5060]
	; Clamps worn-spell power to sixty-three before packing it with the low
	; three-bit spell type.
	cmpi.w	#$0040,d7															;0C470040
	bcs.s	StoreWornSpell														;6502
	moveq	#WornSpell_PowerMaximum,d7											;7E3F
StoreWornSpell:		; Memory Address ($53EC) and binary offset [$5068]
	; Packs worn-spell power and type into the champion record and requests a
	; status refresh.
	asl.w	#WornSpell_PowerShift,d7											;E547
	and.w	#~WornSpell_TypeMask&$FF,d7											;Keeps the packed power bits while clearing the low three bits reserved for worn-spell type.
	add.b	d4,d7																;Packs the selected worn-spell type into the low three bits of the scaled power.
	move.b	d7,$0011(a4)														;Stores the packed worn-spell type and power on the casting champion.
	move.b	#$02,adrB_00EE3C.l													;13FC00020000EE3C
	rts																			;4E75

Spells_02_Terror:		; Memory Address ($507E) and binary offset [$4CFA]
	move.w	#AirbourneSpell_Terror,d4											;383C008F
	bra		SpellEntity_SetPowerFlag											;60000292

Spells_03_Vitalise:		; Memory Address ($5086) and binary offset [$4D02]
	moveq	#$07,d4																;7807
	lsr.w	#$02,d7																;E44F
	bra		RestorePartyStat_CalculateAmount									;600001AA

Spells_04_Beguile:		; Memory Address ($508E) and binary offset [$4D0A]
	; While communication is active, adds floor(spell power / 4) + 1 to both
	; attitude and patience.
	cmp.w	#InterfaceMode_Communication,$0042(a5)								;Interface mode value active while communicating with another character.
	bne.s	Return_Beguile														;6626
	lsr.b	#WornSpell_Beguile_PowerShift,d7									;Right shift converting Beguile spell power into its communication bonus.
	addq.w	#WornSpell_Beguile_BaseBonus,d7										;Minimum attitude and patience bonus supplied by a successful Beguile spell.
	bsr		Comms_GetState														;6100F15E
	move.w	d7,d0																;3007
	add.b	CommsState_AttitudeOffset(a4),d7									;Offset of mutable communication attitude or rapport.
	move.b	d7,CommsState_AttitudeOffset(a4)									;Offset of mutable communication attitude or rapport.
	add.b	CommsState_PatienceOffset(a4),d0									;Offset of communication patience or remaining engagement.
	move.b	d0,CommsState_PatienceOffset(a4)									;Offset of communication patience or remaining engagement.
	bsr		adrCd00847E															;610033CC
	move.w	#AirbourneSpell_Beguile,d7											;3E3C008D
	bra		adrCd001DBC															;6000CD02

Return_Beguile:		; Memory Address ($5440) and binary offset [$50BC]
	; Returns without changing communication state when Beguile is cast outside
	; communication mode.
	rts																			;4E75

Spells_05_Deflect:		; Memory Address ($50BE) and binary offset [$4D3A]
	moveq	#WornSpell_Deflect,d4												;7801
	bra.s	StoreWornSpell_ClampPower											;609E

Spells_06_Magelock:		; Memory Address ($50C2) and binary offset [$4D3E]
	bsr		adrCd008498															;610033D4
	move.b	$01(a6,d0.w),d1														;12360001
	and.w	#$0007,d1															;02410007
	subq.w	#$02,d1																;5541
	bne.s	Magelock_CheckTargetCell											;6616
	move.w	$0020(a5),d2														;342D0020
	add.w	d2,d2																;D442
	addq.w	#$01,d2																;5242
	btst	d2,$00(a6,d0.w)														;05360000
	bne.s	Magelock_ToggleLock													;664E
	subq.w	#$01,d2																;5342
	btst	d2,$00(a6,d0.w)														;05360000
	bne.s	Return_Magelock														;664C
Magelock_CheckTargetCell:		; Memory Address ($546C) and binary offset [$50E8]
	; Checks the cell in front of the party and validates a door side before
	; changing its Magelock flag.
	bsr		adrCd00847E															;61003394
	cmp.w	adrW_00EE72.l,d7													;BE790000EE72
	bcc.s	Return_Magelock														;6440
	swap	d7																	;4847
	cmp.w	adrW_00EE70.l,d7													;BE790000EE70
	bcc.s	Return_Magelock														;6436
	move.b	$01(a6,d0.w),d1														;12360001
	and.w	#$0007,d1															;02410007
	cmpi.w	#$0002,d1															;0C410002
	beq.s	Magelock_CheckOppositeDoorSide										;6710
	cmpi.w	#$0005,d1															;0C410005
	bne.s	Return_Magelock														;6622
	move.b	$00(a6,d0.w),d1														;12360000
	lsr.b	#$04,d1																;E809
	beq.s	Magelock_ToggleLock													;6714
	rts																			;4E75

Magelock_CheckOppositeDoorSide:		; Memory Address ($54A0) and binary offset [$511C]
	; Checks the opposite side of a door cell against the party's facing direction.
	move.w	$0020(a5),d2														;342D0020
	eor.w	#$0002,d2															;0A420002
	add.w	d2,d2																;D442
	addq.w	#$01,d2																;5242
	btst	d2,$00(a6,d0.w)														;05360000
	beq.s	Return_Magelock														;6706
Magelock_ToggleLock:		; Memory Address ($54B2) and binary offset [$512E]
	; Toggles bit four of the validated door cell's state byte.
	bchg	#MapCell_MagelockedBit,$01(a6,d0.w)									;Toggles the lock flag only after the target is confirmed as the relevant side of a door cell.
Return_Magelock:		; Memory Address ($54B8) and binary offset [$5134]
	; Shared return for rejected and completed Magelock operations.
	rts																			;4E75

Spells_07_Conceal:		; Memory Address ($5136) and binary offset [$4DB2]
	bsr		adrCd00847E															;61003346
	cmp.w	adrW_00EE72.l,d7													;BE790000EE72
	bcc.s	adrCd005150															;640E
	cmp.w	adrW_00EE70.l,d7													;BE790000EE70
	bcc.s	adrCd005150															;6406
	bset	#MapCell_ConcealedBit,$01(a6,d0.w)									;08F600030001
adrCd005150:		; Memory Address ($5150) and binary offset [$4DCC]
	rts																			;4E75

Spells_08_Warpower:		; Memory Address ($5152) and binary offset [$4DCE]
	moveq	#WornSpell_Warpower,d4												;Low three-bit worn-spell type used for Warpower.
	bra		StoreWornSpell_ClampPower											;6000FF0A

Spells_09_Missle:		; Memory Address ($5158) and binary offset [$4DD4]
	move.w	#AirbourneSpell_Missile,d4											;383C008A
	lsr.w	#$01,d7																;E24F
	bra		SpellEntity_PrepareDirection										;600001C8

Spells_10_Vanish:		; Memory Address ($5162) and binary offset [$4DDE]
	moveq	#WornSpell_Vanish,d4												;7803
	bra		StoreWornSpell_ClampPower											;6000FEFA

Spells_11_Paralyze:		; Memory Address ($5168) and binary offset [$4DE4]
	move.w	#AirbourneSpell_Paralyze,d4											;383C008C
	bra		SpellEntity_SetPowerFlag											;600001A8

Spells_12_Alchemy:		; Memory Address ($5170) and binary offset [$4DEC]
	moveq	#$00,d0																;7000
	move.b	adrB_00EE3E.l,d0													;10390000EE3E
	asl.w	#$04,d0																;E940
	lea		Character_Pockets_DataTable.l,a0									;41F90000ED2A
	add.w	d0,a0																;D0C0
	moveq	#$00,d0																;7000
	move.b	(a0),d1																;1210
	cmpi.b	#Object_Armour_First,d1												;Only objects from the armour/weapon range can be converted into coinage.
	bcs.s	Alchemy_CheckRightHand												;6506
	cmpi.b	#Object_PowerStaff,d1												;Power Staff and later object codes are excluded from Alchemy conversion.
	bcs.s	Alchemy_ConvertHeldItemToCoinage									;6512
Alchemy_CheckRightHand:		; Memory Address ($5516) and binary offset [$5192]
	; Checks the right hand when the left-hand object is outside Alchemy's
	; convertible range.
	move.b	$0001(a0),d1														;12280001
	moveq	#$01,d0																;7001
	cmpi.b	#Object_Armour_First,d1												;Only objects from the armour/weapon range can be converted into coinage.
	bcs.s	Return_Alchemy														;6530
	cmpi.b	#Object_PowerStaff,d1												;Power Staff and later object codes are excluded from Alchemy conversion.
	bcc.s	Return_Alchemy														;642A
Alchemy_ConvertHeldItemToCoinage:		; Memory Address ($5528) and binary offset [$51A4]
	; Adds five plus spell power to coinage, clamps the quantity to ninety-nine,
	; and prepares the hand conversion.
	addq.w	#Alchemy_BaseCoinageGain,d7											;Adds five coinage before adding the existing counted-coin quantity.
	add.b	$000C(a0),d7														;DE28000C
	cmpi.b	#$64,d7																;0C070064
	bcs.s	Alchemy_StoreCoinage												;6502
	moveq	#Object_StackMaximum,d7												;7E63
Alchemy_StoreCoinage:		; Memory Address ($5536) and binary offset [$51B2]
	; Stores the updated coinage quantity and removes duplicate coinage object
	; slots.
	move.b	d7,$000C(a0)														;1147000C
	moveq	#$0B,d2																;740B
Alchemy_RemoveDuplicateCoinageLoop:		; Memory Address ($553C) and binary offset [$51B8]
	; Scans all twelve ordinary pockets and clears existing coinage object slots.
	cmp.b	#$01,$00(a0,d2.w)													;0C3000012000
	bne.s	adrCd0051C4															;6604
	clr.b	$00(a0,d2.w)														;42302000
adrCd0051C4:		; Memory Address ($51C4) and binary offset [$4E40]
	dbra	d2,Alchemy_RemoveDuplicateCoinageLoop								;51CAFFF2
	move.b	#Object_Coinage,$00(a0,d0.w)										;Replaces the converted hand object with the single authoritative coinage slot.
Return_Alchemy:		; Memory Address ($5552) and binary offset [$51CE]
	; Returns after Alchemy conversion or when neither hand contains an eligible
	; object.
	rts																			;4E75

Spells_13_Confuse:		; Memory Address ($51D0) and binary offset [$4E4C]
	move.w	#AirbourneSpell_Confuse,d4											;383C008B
	bra		SpellEntity_SetPowerFlag											;60000140

Spells_14_Levitate:		; Memory Address ($51D8) and binary offset [$4E54]
	moveq	#WornSpell_Levitate,d4												;7805
	bra		StoreWornSpell_ClampPower											;6000FE84

Spells_15_Antimage:		; Memory Address ($51DE) and binary offset [$4E5A]
	moveq	#WornSpell_Antimage,d4												;7806
	bra		StoreWornSpell_ClampPower											;6000FE7E

Spells_16_Recharge:		; Memory Address ($51E4) and binary offset [$4E60]
	moveq	#$00,d0																;7000
	move.b	adrB_00EE3E.l,d0													;10390000EE3E
	asl.w	#$04,d0																;E940
	lea		Character_Pockets_DataTable.l,a0									;41F90000ED2A
	add.w	d0,a0																;D0C0
	move.b	(a0),d0																;1010
	cmpi.b	#Object_MagicRings_First,d0											;0C000069
	bcs.s	Recharge_CheckRightHand												;6506
	cmpi.b	#Object_BookOfSkulls,d0												;0C00006D
	bcs.s	Recharge_SelectedRing												;6510
Recharge_CheckRightHand:		; Memory Address ($5588) and binary offset [$5204]
	; Checks the right hand when the left hand does not contain one of the four
	; rechargeable magic rings.
	move.b	$0001(a0),d0														;10280001
	cmpi.b	#Object_MagicRings_First,d0											;0C000069
	bcs.s	Return_Recharge														;6516
	cmpi.b	#Object_BookOfSkulls,d0												;0C00006D
	bcc.s	Return_Recharge														;6410
Recharge_SelectedRing:		; Memory Address ($5598) and binary offset [$5214]
	; Maps the selected magic-ring object to RingUses and replaces its uses with
	; spell power divided by eight.
	sub.w	#Object_MagicRings_First,d0											;Converts magic-ring object codes $69-$6C into the four-entry ring-use index.
	lea		RingUses.l,a0														;41F90000EE32
	lsr.w	#Recharge_PowerShift,d7												;Sets replacement ring uses to floor(effective spell power / 8).
	move.b	d7,$00(a0,d0.w)														;11870000
Return_Recharge:		; Memory Address ($55A8) and binary offset [$5224]
	; Returns after Recharge or when neither hand contains a rechargeable ring.
	rts																			;4E75

Spells_17_Trueview:		; Memory Address ($5226) and binary offset [$4EA2]
	moveq	#WornSpell_Trueview,d4												;7807
	bra		StoreWornSpell_ClampPower											;6000FE36

Spells_18_Renew:		; Memory Address ($522C) and binary offset [$4EA8]
	move.w	d7,d4																;3807
	add.w	d7,d7																;DE47
	add.w	d4,d7																;Forms three times the effective spell power before division by sixteen.
	lsr.w	#$04,d7																;E84F
	moveq	#$05,d4																;7805
RestorePartyStat_CalculateAmount:		; Memory Address ($55BA) and binary offset [$5236]
	; Adds random variation to Vitalise or Renew's base amount and clamps the
	; restoration value to one byte.
	move.w	d7,d5																;3A07
RestorePartyStat_RandomiseLoop:		; Memory Address ($55BC) and binary offset [$5238]
	; Accumulates the spell-power-controlled sequence of six-sided random values.
	bsr		adrCd005556															;6100031C
	add.w	d0,d5																;DA40
	dbra	d7,RestorePartyStat_RandomiseLoop									;51CFFFF8
	cmpi.w	#$0100,d5															;0C450100
	bcs.s	RestorePartyStat_BeginChampionLoop									;6502
	moveq	#-$01,d5															;7AFF
RestorePartyStat_BeginChampionLoop:		; Memory Address ($55CE) and binary offset [$524A]
	; Initialises the four-slot active-party scan for Vitalise and Renew.
	moveq	#$03,d1																;7203
RestorePartyStat_ChampionLoop:		; Memory Address ($55D0) and binary offset [$524C]
	; Applies the restoration to each occupied active-party slot and clamps current
	; stat to maximum.
	move.b	$18(a5,d1.w),d0														;10351018
	and.w	#$00E0,d0															;024000E0
	bne.s	RestorePartyStat_NextChampion										;6620
	move.b	$18(a5,d1.w),d0														;10351018
	bsr		Load_ChampionStatRecord												;61001404
	move.b	$00(a4,d4.w),d0														;Loads each active champion's selected current stat: hit points for Renew or vitality for Vitalise.
	add.b	d5,d0																;D005
	bcc.s	RestorePartyStat_ClampOverflow										;6402
	moveq	#-$01,d0															;70FF
RestorePartyStat_ClampOverflow:		; Memory Address ($55EC) and binary offset [$5268]
	; Converts byte overflow in the restored current stat to $FF before
	; maximum-stat clamping.
	cmp.b	$01(a4,d4.w),d0														;Clamps the restored current stat to its adjacent maximum-stat byte.
	bcs.s	RestorePartyStat_StoreCurrent										;6504
	move.b	$01(a4,d4.w),d0														;10344001
RestorePartyStat_StoreCurrent:		; Memory Address ($55F6) and binary offset [$5272]
	; Stores the clamped current hit-point or vitality value for one active
	; champion.
	move.b	d0,$00(a4,d4.w)														;19804000
RestorePartyStat_NextChampion:		; Memory Address ($55FA) and binary offset [$5276]
	; Advances the active-party restoration loop and refreshes the champion display
	; when complete.
	dbra	d1,RestorePartyStat_ChampionLoop									;51C9FFD4
	bra		Draw_MainPlayerInterface											;60002E4E

Spells_19_Vivify:		; Memory Address ($527E) and binary offset [$4EFA]
	bsr		adrCd008498															;61003218
	bsr		adrCd0078FA															;61002676
	bsr		Interface_CheckSelectedCellInteraction								;6100E136
	bcc.s	Vivify_ResolveTargetCell											;6414
	tst.b	d0																	;4A00
	bpl.s	Return_Vivify														;6A0E
	move.l	a5,-(sp)															;2F0D
	move.l	a1,a5																;2A49
	bsr		adrCd008498															;61003202
	bsr		adrCd0078FA															;61002660
	move.l	(sp)+,a5															;2A5F
Return_Vivify:		; Memory Address ($5622) and binary offset [$529E]
	; Returns after Vivify has resolved its selected cell or linked player context.
	rts																			;4E75

Vivify_ResolveTargetCell:		; Memory Address ($5624) and binary offset [$52A0]
	; Checks the target cell type and enters the shared Vivify-machine or
	; cell-resolution path when appropriate.
	bsr		adrCd00847E															;610031DC
	move.b	$01(a6,d0.w),d1														;12360001
	and.w	#$0007,d1															;02410007
	subq.w	#$01,d1																;5341
	beq.s	Return_Vivify														;67EE
	bra		adrCd007812															;60002560

Spells_20_Dispell:		; Memory Address ($52B4) and binary offset [$4F30]
	bsr		adrCd00847E															;610031C8
	bclr	#MapCell_ConcealedBit,$01(a6,d0.w)									;Always removes Conceal from the target cell before considering linked feature removal.
	move.b	$01(a6,d0.w),d1														;12360001
	not.b	d1																	;4601
	and.w	#$0007,d1															;02410007
	bne.s	Return_Dispel														;660E
	btst	#$00,$00(a6,d0.w)													;083600000000
	bne.s	Dispel_FindLinkedFeature											;6608
Dispel_ClearCellFeature:		; Memory Address ($5656) and binary offset [$52D2]
	; Clears the target cell's feature bits after any linked feature record has
	; been removed.
	and.w	#$00F8,$00(a6,d0.w)													;027600F80000
Return_Dispel:		; Memory Address ($565C) and binary offset [$52D8]
	; Returns when Dispel has no linked target or after the target has been
	; cleared.
	rts																			;4E75

Dispel_FindLinkedFeature:		; Memory Address ($565E) and binary offset [$52DA]
	; Initialises the scan for a four-byte linked feature record associated with
	; the target map cell.
	lea		adrEA0173F6.l,a0													;41F9000173F6
	moveq	#-$04,d1															;72FC
Dispel_FindLinkedFeatureLoop:		; Memory Address ($5666) and binary offset [$52E2]
	; Scans linked feature records and removes the matching target record when
	; found.
	addq.w	#$04,d1																;5841
	cmp.w	-$0002(a0),d1														;B268FFFE
	bcc.s	Dispel_ClearCellFeature												;64E8
	cmp.w	$02(a0,d1.w),d0														;B0701002
	bne.s	Dispel_FindLinkedFeatureLoop										;66F2
	bra		adrCd001212															;6000BF20

Spells_21_Firepath:		; Memory Address ($52F4) and binary offset [$4F70]
	move.w	#AirbourneSpell_Firepath,d4											;383C0087
	addq.w	#$02,d7																;5447
	bra.s	SpellEntity_SetPowerFlag											;601A

Spells_22_Illusion:		; Memory Address ($52FC) and binary offset [$4F78]
	moveq	#$65,d4																;7865
	bra		SpellEntity_PrepareDirection										;60000028

Spells_23_Compass:		; Memory Address ($5302) and binary offset [$4F7E]
	moveq	#WornSpell_Compass,d4												;7804
	bra		StoreWornSpell_ClampPower											;6000FD5A

Spells_24_Spelltap:		; Memory Address ($5308) and binary offset [$4F84]
	move.w	#AirbourneSpell_Spelltap,d4											;383C008E
	bra.s	SpellEntity_SetPowerFlag											;6008

Spells_25_Disrupt:		; Memory Address ($530E) and binary offset [$4F8A]
	move.w	#AirbourneSpell_Disrupt,d4											;383C0083
	addq.w	#$05,d7																;5A47
	add.w	d7,d7																;DE47
SpellEntity_SetPowerFlag:		; Memory Address ($569A) and binary offset [$5316]
	; Sets the high spell-power flag used by Terror, Paralyze, Firepath, Spelltap,
	; and Disrupt before entity creation.
	bset	#$08,d7																;08C70008
	bra.s	SpellEntity_PrepareDirection										;600C

Spells_26_Fireball:		; Memory Address ($531C) and binary offset [$4F98]
	move.w	#AirbourneSpell_Fireball,d4											;383C0080
SpellEntity_ScalePowerThreeHalves:		; Memory Address ($56A4) and binary offset [$5320]
	; Scales Fireball and Arc Bolt effective power to three halves before creating
	; the live spell entity.
	move.w	d7,d3																;3607
	add.w	d7,d7																;DE47
	add.w	d3,d7																;DE43
	lsr.w	#$01,d7																;E24F
SpellEntity_PrepareDirection:		; Memory Address ($56AC) and binary offset [$5328]
	; Packs the player's facing direction for the shared spell, Illusion, and
	; Summon entity creator.
	move.w	$0020(a5),d6														;3C2D0020
	swap	d6																	;4846
	move.w	$0020(a5),d6														;3C2D0020
CreateSpellEntity:		; Memory Address ($56B6) and binary offset [$5332]
	; Creates an airborne spell, Illusion, or Summon entity at the resolved map
	; position.
	move.w	d7,d3																;3607
	move.l	$001C(a5),d7														;2E2D001C
	move.w	$0058(a5),d5														;3A2D0058
SpellEntity_CheckPlacement:		; Memory Address ($56C0) and binary offset [$533C]
	; Resolves the destination map cell and records whether placement crossed a map
	; boundary or conflict.
	move.w	d5,-(sp)															;3F05
	bsr		Compute_NewMapIndex_AI_TBC											;61002704
	bcc.s	SpellEntity_PlacementInsideMap										;640E
	move.w	(sp)+,d5															;3A1F
	move.b	#$FF,SpellEntity_PlacementConflictFlag.w							;11FC00FF505A	;Short Absolute converted to symbol!
	cmp.w	d0,d2																;B440
	bne.s	SpellEntity_MarkMapCell												;6608
	rts																			;4E75

SpellEntity_PlacementInsideMap:		; Memory Address ($56D6) and binary offset [$5352]
	; Clears the placement-conflict flag when the destination lies inside the
	; current map.
	clr.b	SpellEntity_PlacementConflictFlag.w									;4238505A	;Short Absolute converted to symbol!
	move.w	(sp)+,d5															;3A1F
SpellEntity_MarkMapCell:		; Memory Address ($56DC) and binary offset [$5358]
	; Marks the destination cell as containing a live spell or summoned entity.
	bset	#MapCell_SpellEntityBit,$01(a6,d2.w)								;Marks the resolved destination cell before allocating the overloaded live-entity record.
SpellEntity_AllocateRecord:		; Memory Address ($56E2) and binary offset [$535E]
	; Allocates a sixteen-byte record in the overloaded live-monster workspace,
	; freeing one when the spell-entity limit is reached.
	lea		UnpackedMonsters.l,a4												;Uses the live-monster workspace for spell entities, Illusion and Summon.
	addq.w	#$01,-$0002(a4)														;526CFFFE
	move.w	-$0002(a4),d1														;322CFFFE
	cmpi.w	#$007D,d1															;0C41007D
	bcs.s	SpellEntity_InitialiseRecord										;650A
	subq.w	#$01,-$0002(a4)														;536CFFFE
	bsr		adrCd00277E															;6100D406
	bra.s	SpellEntity_AllocateRecord											;60E2

SpellEntity_InitialiseRecord:		; Memory Address ($5700) and binary offset [$537C]
	; Initialises position, facing, floor, caster, form, power, state, and team
	; fields for a new spell entity.
	asl.w	#$04,d1																;E941
	add.w	d1,a4																;D8C1
	move.b	d7,$0001(a4)														;19470001
	swap	d7																	;4847
	move.b	d7,$0000(a4)														;19470000
	swap	d6																	;4846
	move.b	d6,$0002(a4)														;19460002
	move.b	d5,$0004(a4)														;19450004
	swap	d5																	;4845
	move.b	adrB_00EE3E.l,$000C(a4)												;19790000EE3E000C
	move.b	d4,$000B(a4)														;Stores the spell/entity form code in the overloaded live-record form byte.
	move.b	SpellEntity_AIOriginFlag.w,$0003(a4)								;1978505B0003	;Short Absolute converted to symbol!
	clr.w	$0008(a4)															;426C0008
	clr.b	$0005(a4)															;422C0005
	move.b	#$03,$000A(a4)														;197C0003000A
	move.b	#$FF,$000D(a4)														;197C00FF000D
	tst.b	d4																	;4A04
	bmi.s	SpellEntity_InitialiseAirbourne										;6B3E
	move.b	#$64,$000B(a4)														;197C0064000B
	cmpi.b	#$65,d4																;0C040065
	beq.s	SpellEntity_InitialiseIllusion										;670A
	moveq	#$06,d4																;7806
	add.w	d3,d4																;D843
	asl.w	#$03,d4																;E744
	move.w	d4,$0008(a4)														;39440008
SpellEntity_InitialiseIllusion:		; Memory Address ($575A) and binary offset [$53D6]
	; Applies Illusion's special power flag before common monster-like entity
	; initialisation.
	lsr.w	#$02,d3																;E44B
	cmpi.b	#$65,d4																;0C040065
	bne.s	SpellEntity_InitialiseMonsterLike									;6604
	bset	#$07,d3																;08C30007
SpellEntity_InitialiseMonsterLike:		; Memory Address ($5766) and binary offset [$53E2]
	; Initialises the level and state fields shared by Illusion and Summon
	; entities.
	addq.w	#$02,d3																;5443
	move.b	d3,$0006(a4)														;19430006
	and.w	#$007F,d3															;0243007F
	move.b	d3,$0007(a4)														;19430007
	move.b	#$80,$0003(a4)														;197C00800003
	move.b	#$1F,$0005(a4)														;197C001F0005
	bra.s	SpellEntity_FinalizeCreation										;6014

SpellEntity_InitialiseAirbourne:		; Memory Address ($5782) and binary offset [$53FE]
	; Initialises airborne-spell power fields and transfers the high spell-power
	; flag into the record.
	move.b	d3,$0006(a4)														;19430006
	clr.b	$0007(a4)															;422C0007
	btst	#$08,d3																;08030008
	beq.s	SpellEntity_FinalizeCreation										;6706
	bset	#$07,$0006(a4)														;08EC00070006
SpellEntity_FinalizeCreation:		; Memory Address ($5796) and binary offset [$5412]
	; Runs the placement-conflict follow-up when required and otherwise returns
	; from entity creation.
	tst.b	SpellEntity_PlacementConflictFlag.w									;4A38505A	;Short Absolute converted to symbol!
	bne		CheckEquipCostsAndAttrs_AI_TBC										;6600C940
	rts																			;4E75

Spells_27_Wychwind:		; Memory Address ($541C) and binary offset [$5098]
	add.w	#Wychwind_PowerBonus,d7												;0647000A
	add.w	d7,d7																;DE47
	moveq	#Wychwind_ProjectileCount-1,d5										;Runs once for each of the eight surrounding projectile directions.
.Wychwind_SpawnProjectileLoop:		; Memory Address ($57A8) and binary offset [$5424]
	; Creates one Wychwind projectile for each of the eight directions around the
	; caster.
	movem.w	d5/d7,-(sp)															;48A70500
	move.w	#AirbourneSpell_Wychwind,d4											;383C0081
	move.w	$0020(a5),d6														;3C2D0020
	add.b	.Wychwind_DirectionAdjustments(pc,d5.w),d6							;Rotates the projectile's facing with the mechanic-owned eight-byte direction-adjustment table.
	and.w	#$0003,d6															;02460003
	swap	d6																	;4846
	move.w	d5,d6																;3C05
	cmpi.w	#$0004,d6															;0C460004
	bcc.s	.Wychwind_RotateSecondDirectionGroup								;640A
	add.w	$0020(a5),d6														;DC6D0020
	and.w	#$0003,d6															;02460003
	bra.s	.Wychwind_CreateProjectile											;600C

.Wychwind_RotateSecondDirectionGroup:		; Memory Address ($57D0) and binary offset [$544C]
	; Normalises Wychwind directions four through seven before applying the party
	; facing.
	subq.w	#$04,d6																;5946
	add.w	$0020(a5),d6														;DC6D0020
	and.w	#$0003,d6															;02460003
	addq.w	#$04,d6																;5846
.Wychwind_CreateProjectile:		; Memory Address ($57DC) and binary offset [$5458]
	; Calls the shared spell-entity creator with one Wychwind direction and
	; restores loop state.
	bsr		CreateSpellEntity													;6100FED8
	movem.w	(sp)+,d5/d7															;4C9F00A0
	dbra	d5,.Wychwind_SpawnProjectileLoop									;51CDFFC2
	rts																			;4E75

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
	move.w	#AirbourneSpell_ArcBolt,d4											;383C0082
	bra		SpellEntity_ScalePowerThreeHalves									;6000FEAC

Spells_29_Formwall:		; Memory Address ($5476) and binary offset [$50F2]
	moveq	#MagicFeature_Formwall,d4											;7803
CreateMagicWallFeature:		; Memory Address ($57FC) and binary offset [$5478]
	; Creates a power-scaled Formwall or Mindrock in an empty map cell directly in
	; front of the party.
	move.w	d7,d3																;3607
	addq.w	#$02,d3																;5443
	asl.w	#$02,d3																;E543
	bsr		adrCd00847E															;61002FFE
	cmp.w	adrW_00EE72.l,d7													;BE790000EE72
	bcc.s	Return_CreateMagicWallFeature										;645A
	swap	d7																	;4847
	cmp.w	adrW_00EE70.l,d7													;BE790000EE70
	bcc.s	Return_CreateMagicWallFeature										;6450
	move.b	$01(a6,d0.w),d1														;12360001
	bmi.s	Return_CreateMagicWallFeature										;6B4A
	and.w	#$0007,d1															;02410007
	bne.s	Return_CreateMagicWallFeature										;6644
	tst.b	$00(a6,d0.w)														;4A360000
	bne.s	Return_CreateMagicWallFeature										;663E
	or.b	#MapCell_MagicFeatureType,$01(a6,d0.w)								;Changes an empty target cell to map type 7, the shared magic-feature type.
	or.b	d3,d4																;Packs spell-power bands above the low two-bit Formwall or Mindrock subtype.
	move.b	d4,$00(a6,d0.w)														;1D840000
	and.w	#$0003,d4															;02440003
	subq.b	#$03,d4																;5704
	bne.s	Return_CreateMagicWallFeature										;662A
	move.w	#$03FF,d1															;323C03FF
Formwall_PrepareLinkedFeature:		; Memory Address ($5842) and binary offset [$54BE]
	; Builds the packed map-position key used to register a Formwall in the linked
	; feature list.
	lea		adrEA0173F6.l,a0													;41F9000173F6
	swap	d0																	;4840
	move.w	d1,d0																;3001
	swap	d0																	;4840
	moveq	#$00,d1																;7200
Formwall_FindLinkedFeatureLoop:		; Memory Address ($5850) and binary offset [$54CC]
	; Searches the linked feature list for the Formwall's packed map-position key.
	cmp.w	-$0002(a0),d1														;B268FFFE
	bcc.s	Formwall_AppendLinkedFeature										;640A
	cmp.w	$02(a0,d1.w),d0														;B0701002
	beq.s	Formwall_StoreLinkedFeature											;6708
	addq.w	#$04,d1																;5841
	bra.s	Formwall_FindLinkedFeatureLoop										;60F0

Formwall_AppendLinkedFeature:		; Memory Address ($5860) and binary offset [$54DC]
	; Extends the linked feature list when the Formwall's map-position key is not
	; already present.
	addq.w	#$04,-$0002(a0)														;5868FFFE
Formwall_StoreLinkedFeature:		; Memory Address ($5864) and binary offset [$54E0]
	; Stores the Formwall's packed map-position key in the linked feature list.
	move.l	d0,$00(a0,d1.w)														;21801000
Return_CreateMagicWallFeature:		; Memory Address ($5868) and binary offset [$54E4]
	; Returns after Formwall or Mindrock creation or when the target cell is
	; unsuitable.
	rts																			;4E75

Spells_30_Summon:		; Memory Address ($54E6) and binary offset [$5162]
	moveq	#$64,d4																;7864
	bra		SpellEntity_PrepareDirection										;6000FE3E

Spells_31_Blaze:		; Memory Address ($54EC) and binary offset [$5168]
	move.w	#AirbourneSpell_Blaze,d4											;383C0084
	add.w	#$000A,d7															;0647000A
	lsr.w	#$01,d7																;E24F
	bra		SpellEntity_PrepareDirection										;6000FE30

Spells_32_Mindrock:		; Memory Address ($54FA) and binary offset [$5176]
	moveq	#MagicFeature_Mindrock,d4											;7802
	bra		CreateMagicWallFeature												;6000FF7A

adrCd005500:		; Memory Address ($5500) and binary offset [$517C]
	moveq	#-$01,d3															;76FF
	moveq	#$03,d2																;7403
adrLp005504:		; Memory Address ($5504) and binary offset [$5180]
	move.b	$18(a5,d2.w),d0														;10352018
	and.w	#$00E0,d0															;024000E0
	bne.s	adrCd005540															;6632
	move.b	$18(a5,d2.w),d0														;10352018
	bsr		Load_ChampionStatRecord												;6100114C
	move.b	$0011(a4),d0														;102C0011
	and.w	#$0007,d0															;02400007
	sub.w	d1,d0																;9041
	bne.s	adrCd005540															;661E
	move.b	$0011(a4),d0														;102C0011
	lsr.b	#$03,d0																;E608
	tst.b	d3																	;4A03
	bpl.s	adrCd00552E															;6A02
	moveq	#$00,d3																;7600
adrCd00552E:		; Memory Address ($552E) and binary offset [$51AA]
	cmp.b	d3,d0																;B003
	bcs.s	adrCd005540															;650E
	move.b	d0,d3																;1600
	swap	d3																	;4843
	move.b	$18(a5,d2.w),d3														;16352018
	and.w	#$000F,d3															;0243000F
	swap	d3																	;4843
adrCd005540:		; Memory Address ($5540) and binary offset [$51BC]
	dbra	d2,adrLp005504														;51CAFFC2
	rts																			;4E75

adrCd005546:		; Memory Address ($5546) and binary offset [$51C2]
	moveq	#$03,d6																;7C03
	moveq	#$02,d5																;7A02
adrLp00554A:		; Memory Address ($554A) and binary offset [$51C6]
	bsr.s	adrCd005556															;610A
	add.w	d0,d6																;DC40
	dbra	d5,adrLp00554A														;51CDFFFA
	move.w	d6,d0																;3006
	rts																			;4E75

adrCd005556:		; Memory Address ($5556) and binary offset [$51D2]
	move.w	adrW_0055AA.l,d0													;3039000055AA
	addq.w	#$01,d0																;5240
	mulu	#$B640,d0															;C0FCB640
	move.l	d0,d1																;2200
	asl.l	#$04,d0																;E980
	add.l	d1,d0																;D081
	move.w	#$0511,d1															;323C0511
	moveq	#$00,d3																;7600
adrCd00556E:		; Memory Address ($556E) and binary offset [$51EA]
	divu	d1,d0																;80C1
	bvc.s	adrCd005580															;680E
	move.w	d0,d2																;3400
	clr.w	d0																	;4240
	swap	d0																	;4840
	divu	d1,d0																;80C1
	move.w	d0,d3																;3600
	move.w	d2,d0																;3002
	bra.s	adrCd00556E															;60EE

adrCd005580:		; Memory Address ($5580) and binary offset [$51FC]
	subq.w	#$01,d1																;5341
	swap	d0																	;4840
	move.w	d3,d0																;3003
	swap	d0																	;4840
	divu	d1,d0																;80C1
	clr.w	d0																	;4240
	swap	d0																	;4840
	move.w	d0,adrW_0055AA.l													;33C0000055AA
	moveq	#$06,d1																;7206
adrCd005596:		; Memory Address ($5596) and binary offset [$5212]
	divu	d1,d0																;80C1
	bvc.s	adrCd0055A6															;680C
	move.w	d0,d2																;3400
	clr.w	d0																	;4240
	swap	d0																	;4840
	divu	d1,d0																;80C1
	move.w	d2,d0																;3002
	bra.s	adrCd005596															;60F0

adrCd0055A6:		; Memory Address ($55A6) and binary offset [$5222]
	swap	d0																	;4840
	rts																			;4E75

adrW_0055AA:		; Memory Address ($55AA) and binary offset [$5226]
	dc.b	$03	;03
RandomOffsetValue:		; Memory Address ($55AB) and binary offset [$5227]
	dc.b	$E1	;E1

RandomGen_BytewithOffset:		; Memory Address ($55AC) and binary offset [$5228]
	moveq	#$01,d1																;7201
	bsr.s	RandomGen															;610C
	swap	d0																	;4840
	add.b	RandomOffsetValue(pc),d0											;D03AFFF7
	rts																			;4E75

RandomGen_100:		; Memory Address ($55B8) and binary offset [$5234]
	move.w	#$6400,d1															;323C6400
RandomGen:		; Memory Address ($55BC) and binary offset [$5238]
	swap	d1																	;4841
	moveq	#$00,d0																;7000
	move.b	adrB_0055DE.l,d0													;1039000055DE
	move.w	d0,d1																;3200
	lsr.b	#$03,d1																;E609
	eor.b	d0,d1																;B101
	lsr.b	#$01,d1																;E209
	roxr.b	#$01,d0																;E210
	move.b	d0,adrB_0055DE.l													;13C0000055DE
	swap	d1																	;4841
	mulu	d1,d0																;C0C1
	swap	d0																	;4840
	rts																			;4E75

adrB_0055DE:		; Memory Address ($55DE) and binary offset [$525A]
	dc.b	$FF	;FF
	dc.b	$FF	;FF

Click_ViewSpell:		; Memory Address ($55E0) and binary offset [$525C]
	move.w	#$0002,$0014(a5)													;3B7C00020014
	bsr		adrCd00C2AC															;61006CC4
	bpl.s	adrCd0055F6															;6A0A
	bsr		adrCd006698															;610010AA
	bsr		adrCd00CF96															;610079A4
	bra.s	adrCd005624															;602E

adrCd0055F6:		; Memory Address ($55F6) and binary offset [$5272]
	move.l	a6,-(sp)															;2F0E
	bsr		Calculate_SpellCastingQuality										;6100117E
	addq.b	#$03,d7																;5607
	bmi.s	adrCd00561A															;6B1A
	lea		SpellCost_DataTable.l,a0											;41F90000685E
	move.b	$00(a0,d6.w),d0														;10306000
	add.w	d0,d0																;D040
	addq.b	#$01,d0																;5200
	cmp.b	d7,d0																;B007
	bcs.s	adrCd005614															;6502
	move.b	d7,d0																;1007
adrCd005614:		; Memory Address ($5614) and binary offset [$5290]
	neg.b	d0																	;4400
	move.b	d0,$0014(a4)														;19400014
adrCd00561A:		; Memory Address ($561A) and binary offset [$5296]
	bsr		adrCd006698															;6100107C
	move.l	(sp)+,a6															;2C5F
	bsr		adrCd00CFBC															;6100799A
adrCd005624:		; Memory Address ($5624) and binary offset [$52A0]
	bra		adrCd00C85E															;60007238

adrJA005628:		; Memory Address ($5628) and binary offset [$52A4]
	move.w	$000E(a5),d7														;3E2D000E
	moveq	#-$01,d2															;74FF
	bsr		adrCd00C714															;610070E4
	bpl.s	adrCd005680															;6A4C
	bsr		HitTest_DisplayAction												;61000246
	tst.w	$000C(a5)															;4A6D000C
	bpl.s	adrCd005676															;6A38
	cmpi.w	#$0048,d1															;0C410048
	bcs.s	adrCd005676															;6532
	cmpi.w	#$0058,d1															;0C410058
	bcc.s	adrCd005676															;642C
	swap	d1																	;4841
	sub.w	#$00E0,d1															;044100E0
	bcs.s	adrCd005676															;6524
	lsr.w	#$04,d1																;E849
	cmpi.w	#$0005,d1															;0C410005
	beq		Click_CloseCurrentPage												;6700014A
	cmpi.w	#$0004,d1															;0C410004
	beq.s	adrCd005678															;6716
	move.b	$18(a5,d1.w),d0														;10351018
	and.w	#$00A0,d0															;024000A0
	bne.s	adrCd005676															;660A
	move.w	#$0011,$000C(a5)													;3B7C0011000C
	move.w	d1,$000E(a5)														;3B41000E
adrCd005676:		; Memory Address ($5676) and binary offset [$52F2]
	rts																			;4E75

adrCd005678:		; Memory Address ($5678) and binary offset [$52F4]
	move.w	#$0013,$000C(a5)													;3B7C0013000C
	rts																			;4E75

adrCd005680:		; Memory Address ($5680) and binary offset [$52FC]
	move.w	#$0012,$000C(a5)													;3B7C0012000C
	move.b	d7,$000E(a5)														;1B47000E
	rts																			;4E75

adrB_00568C:		; Memory Address ($568C) and binary offset [$5308]
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00

adrCd005694:		; Memory Address ($5694) and binary offset [$5310]
	bsr		adrCd0084D6															;61002E40
	moveq	#$03,d1																;7203
	bsr		adrCd005500															;6100FE64
	moveq	#$0B,d2																;740B
	tst.w	d3																	;4A43
	bmi.s	adrCd0056AC															;6B08
	addq.w	#$01,d3																;5243
	add.w	d3,d3																;D643
	sub.w	d3,d2																;9443
	bcs.s	adrCd005676															;65CA
adrCd0056AC:		; Memory Address ($56AC) and binary offset [$5328]
	move.l	Current_TowerMapDataBase.l,a2										;24790000EE78
	add.w	adrW_00EE76.l,a2													;D4F90000EE76
	move.l	a6,a3																;264E
	move.w	adrW_00EE72.l,d0													;30390000EE72
	mulu	adrW_00EE70.l,d0													;C0F90000EE70
	subq.w	#$01,d0																;5340
adrLp0056C8:		; Memory Address ($56C8) and binary offset [$5344]
	move.w	(a2)+,d1															;321A
	and.w	#$0007,d1															;02410007
	cmpi.b	#$02,d1																;0C010002
	bne.s	adrCd0056DC															;6608
	btst	#$04,-$0001(a2)														;082A0004FFFF
	bne.s	adrCd0056EE															;6612
adrCd0056DC:		; Memory Address ($56DC) and binary offset [$5358]
	cmpi.b	#$07,d1																;0C010007
	bne.s	adrCd0056F0															;660E
	move.b	-$0002(a2),d1														;122AFFFE
	and.w	#$0003,d1															;02410003
	subq.w	#$01,d1																;5341
	beq.s	adrCd0056F0															;6702
adrCd0056EE:		; Memory Address ($56EE) and binary offset [$536A]
	moveq	#$01,d1																;7201
adrCd0056F0:		; Memory Address ($56F0) and binary offset [$536C]
	move.b	adrB_00568C(pc,d1.w),(a3)+											;16FB109A
	dbra	d0,adrLp0056C8														;51C8FFD2
	lea		adrEA01674C.l,a2													;45F90001674C
	lea		adrEA0167CC.l,a3													;47F9000167CC
	move.b	$001F(a5),$0001(a2)													;156D001F0001
	move.b	$001D(a5),(a2)														;14AD001D
	move.b	#$FF,$0002(a2)														;157C00FF0002
adrLp005714:		; Memory Address ($5714) and binary offset [$5390]
	move.l	a2,a0																;204A
	move.l	a3,a1																;224B
adrCd005718:		; Memory Address ($5718) and binary offset [$5394]
	moveq	#$00,d7																;7E00
	move.b	(a0)+,d7															;1E18
	bmi.s	adrCd00575A															;6B3C
	swap	d7																	;4847
	move.b	(a0)+,d7															;1E18
	subq.w	#$01,d7																;5347
	bcs.s	adrCd00572A															;6504
	moveq	#$02,d1																;7202
	bsr.s	adrCd00576A															;6140
adrCd00572A:		; Memory Address ($572A) and binary offset [$53A6]
	addq.w	#$02,d7																;5447
	cmp.w	adrW_00EE72.l,d7													;BE790000EE72
	bcc.s	adrCd005738															;6404
	moveq	#$00,d1																;7200
	bsr.s	adrCd00576A															;6132
adrCd005738:		; Memory Address ($5738) and binary offset [$53B4]
	subq.w	#$01,d7																;5347
	swap	d7																	;4847
	addq.w	#$01,d7																;5247
	cmp.w	adrW_00EE70.l,d7													;BE790000EE70
	bcc.s	adrCd00574E															;6408
	swap	d7																	;4847
	moveq	#$03,d1																;7203
	bsr.s	adrCd00576A															;611E
	swap	d7																	;4847
adrCd00574E:		; Memory Address ($574E) and binary offset [$53CA]
	subq.w	#$02,d7																;5547
	bcs.s	adrCd005718															;65C6
	swap	d7																	;4847
	moveq	#$01,d1																;7201
	bsr.s	adrCd00576A															;6112
	bra.s	adrCd005718															;60BE

adrCd00575A:		; Memory Address ($575A) and binary offset [$53D6]
	cmp.l	a1,a3																;B7C9
	beq.s	Return_ActionDispatchBlocked										;6734
	move.b	#$FF,(a1)															;12BC00FF
	exg		a2,a3																;C74A
	dbra	d2,adrLp005714														;51CAFFAE
	rts																			;4E75

adrCd00576A:		; Memory Address ($576A) and binary offset [$53E6]
	move.w	d7,d0																;3007
	mulu	adrW_00EE70.l,d0													;C0F90000EE70
	swap	d7																	;4847
	add.w	d7,d0																;D047
	swap	d7																	;4847
	tst.b	$00(a6,d0.w)														;4A360000
	bmi.s	Return_ActionDispatchBlocked										;6B14
	beq.s	adrCd005782															;6702
	rts																			;4E75

adrCd005782:		; Memory Address ($5782) and binary offset [$53FE]
	or.b	#$80,d1																;00010080
	move.b	d1,$00(a6,d0.w)														;1D810000
	swap	d7																	;4847
	move.b	d7,(a1)+															;12C7
	swap	d7																	;4847
	move.b	d7,(a1)+															;12C7
Return_ActionDispatchBlocked:		; Memory Address ($5B16) and binary offset [$5792]
	; Exit used when interface-action dispatch is blocked by player state.
	rts																			;4E75

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
	clr.w	$0014(a5)															;426D0014
	bra		Draw_ChampionNamePanelFrame											;60002ACE

Dispatch_PlayerInterfaceActionGuarded:		; Memory Address ($5B30) and binary offset [$57AC]
	; Checks player state before dispatching the active action.
	btst	#$06,$0018(a5)														;082D00060018
	bne.s	Return_ActionDispatchBlocked										;66DE
	pea		adrL_008226.l														;487900008226
Dispatch_PlayerInterfaceAction:		; Memory Address ($5B3E) and binary offset [$57BA]
	; Indexes the dungeon InterfaceButtons jump table using PlayerX_Data+$0C.
	move.w	Player_ActionCommandOffset(a5),d0									;Offset used to dispatch the active player interface command.
	bmi.s	Return_ActionDispatchBlocked										;6BD2
	asl.w	#InterfaceAction_TableEntryShift,d0									;Shift count converting an interface action index into a four-byte jump-table offset.
	lea		DungeonInterfaceActionTable.l,a0									;41F9000057CE
	move.l	$00(a0,d0.w),a0														;20700000
	jmp		(a0)																;4ED0

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
	dc.l	adrJA005862	;00005862
	dc.l	Click_LaunchSpellFromBook	;00004E7A
	dc.l	Click_ViewSpell	;000055E0
	dc.l	Click_TurnSpellBookPage	;0000C2EA
	dc.l	Click_CloseCurrentPage	;000057A4
	dc.l	Click_TurnSpellBookPage	;0000C2EA
	dc.l	Click_CommsAndOptions	;0000420C
	dc.l	adrJA005862	;00005862
	dc.l	Click_PauseGame	;0000425E
	dc.l	Click_LoadSaveGame	;0000432A
	dc.l	Click_SleepParty	;00004536
	dc.l	Click_ShowTeamAvatars	;000032DE
	dc.l	Click_TogglePartyCommandRow	;00004C10
	dc.l	PartyCommand_DispatchSelection	;0000336A
	dc.l	adrJA005D3E	;00005D3E
	dc.l	Handle_WallFeatureClick	;00005894
	dc.l	adrJA0064D0	;000064D0

adrJA005862:		; Memory Address ($5862) and binary offset [$54DE]
	rts																			;4E75

Interface_Hitboxes_Display:		; Memory Address ($5864) and binary offset [$54E0]
	; Three display/context hitbox records for action IDs $22-$24, stored as
	; inclusive X/Y rectangle words.
	INCBIN "/data/BLOODWYCH439-clean/data/Interface_Hitboxes_Display.lookup"

HitTest_DisplayAction:		; Memory Address ($5C00) and binary offset [$587C]
	; Tests display-area rectangles and stores a resulting command in
	; PlayerX_Data+$0C.
	moveq	#$22,d0																;Starts the display/context hitbox scan at action ID $22.
	moveq	#$26,d2																;7426
	lea		Interface_Hitboxes_Display.w,a6										;4DF85864	;Short Absolute converted to symbol!
	move.w	#$FFFF,$000C(a5)													;Clears the pending interface action before testing the display/context rectangles.
	bra		HitTest_PlayerInterfaceActions										;6000F528

Click_Display:		; Memory Address ($588E) and binary offset [$550A]
	bsr.s	HitTest_DisplayAction												;61EC
	bra		Dispatch_PlayerInterfaceAction										;6000FF28

Handle_WallFeatureClick:		; Memory Address ($5C18) and binary offset [$5894]
	; Handles a clicked wall feature and can route to the contextual wall-feature
	; command.
	bsr		adrCd00847E															;61002BE8
	cmp.w	adrW_00EE72.l,d7													;BE790000EE72
	bcc.s	Return_WallFeatureClick												;644A
	swap	d7																	;4847
	cmp.w	adrW_00EE70.l,d7													;BE790000EE70
	bcc.s	Return_WallFeatureClick												;6440
	swap	d7																	;4847
	move.w	$00(a6,d0.w),d2														;34360000
	move.w	d2,d3																;3602
	and.w	#$0007,d2															;02420007
	subq.w	#$01,d2																;5342
	bne		adrJA0064D0															;66000C16
	tst.b	d3																	;4A03
	bpl.s	Return_WallFeatureClick												;6A2A
	move.b	$01(a6,d0.w),d3														;16360001
	lsr.w	#$04,d3																;E84B
	and.w	#$0003,d3															;02430003
	eor.w	#$0002,d3															;0A430002
	cmp.w	$0020(a5),d3														;B66D0020
	bne.s	Return_WallFeatureClick												;6616
	move.b	$00(a6,d0.w),d3														;16360000
	and.w	#$0003,d3															;02430003
	add.w	d3,d3																;D643
	lea		MainWall_Action_01_Shelf.l,a0										;41F9000058F4
	add.w	MainWall_Action_LookupTable(pc,d3.w),a0								;D0FB3006
	jmp		(a0)																;4ED0

Return_WallFeatureClick:		; Memory Address ($58EA) and binary offset [$5566]
	; Return point used when a wall-feature click does not resolve to a supported
	; action.
	rts																			;4E75

MainWall_Action_LookupTable:		; Memory Address ($58EC) and binary offset [$5568]
	; Relative dispatch offsets for shelf, wall-decoration, switch, and socket
	; click handlers.
	dc.w	MainWall_Action_01_Shelf-MainWall_Action_01_Shelf	;0000
	dc.w	MainWall_Action_02_WallDecoration-MainWall_Action_01_Shelf	;0018
	dc.w	MainWall_Action_03_Switches-MainWall_Action_01_Shelf	;0236
	dc.w	MainWall_Action_04_Sockets-MainWall_Action_01_Shelf	;0064

MainWall_Action_01_Shelf:		; Memory Address ($58F4) and binary offset [$5570]
	; Maps the clicked shelf height to one of the two shelf object subpositions
	; before shared object handling.
	move.w	$0004(a5),d1														;322D0004
	sub.w	$0008(a5),d1														;926D0008
	moveq	#$02,d6																;7C02
	cmpi.w	#$0033,d1															;0C410033
	bcs		adrCd005D4E															;6500044A
	moveq	#$03,d6																;7C03
	bra		adrCd005D4E															;60000444

MainWall_Action_02_WallDecoration:		; Memory Address ($590C) and binary offset [$5588]
	; Accepts scroll-bearing wall decorations and converts their subtype into a
	; scroll index.
	moveq	#$00,d1																;7200
	move.b	$00(a6,d0.w),d1														;12360000
	lsr.b	#$02,d1																;E409
	subq.b	#$05,d1																;5B01
	bcc.s	MainWall_Action_02_Scrolls											;6402
	rts																			;4E75

MainWall_Action_02_Scrolls:		; Memory Address ($591A) and binary offset [$5596]
	; Draws the scroll frame, resolves the tower-specific scroll text, and prints
	; it in the interface.
	move.w	d1,-(sp)															;3F01
	moveq	#$38,d5																;7A38
	bsr		Draw_ScrollFrame													;6100731A
	move.w	(sp)+,d1															;321F
	move.w	CurrentTower.l,d0													;30390000EE2E
	add.b	Scroll_TowerOffsets_DataTable(pc,d0.w),d1							;D23B0026
	lea		Scroll_Offsets.l,a0													;41F90001A31C
	lea		$0092(a0),a6														;4DE80092
	add.w	d1,d1																;D241
	add.w	$00(a0,d1.w),a6														;DCF01000
	move.w	#$0004,$0014(a5)													;3B7C00040014
	move.l	#$00000003,adrW_00D92A.l											;23FC000000030000D92A
	bra		Print_fflim_text													;60007776

Scroll_TowerOffsets_DataTable:		; Memory Address ($5952) and binary offset [$55CE]
	INCBIN "/data/BLOODWYCH439-clean/data/scrollstowers.data"

MainWall_Action_04_Sockets:		; Memory Address ($5958) and binary offset [$55D4]
	; Places a held crystal or gem into a wall socket, or dispatches the action for
	; an occupied socket.
	moveq	#$00,d1																;7200
	move.b	$00(a6,d0.w),d1														;12360000
	btst	#$02,d1																;08010002
	bne.s	Sockets_Actions														;6622
	tst.w	$002E(a5)															;4A6D002E
	bne.s	Socket_ClickExit													;661A
	lsr.w	#$03,d1																;E649
	add.w	#$0060,d1															;06410060
	move.w	d1,$002E(a5)														;3B41002E
	move.w	#$0001,$002C(a5)													;3B7C0001002C
	bset	#$02,$00(a6,d0.w)													;08F600020000
	bra		adrCd005D40															;600003BE

Socket_ClickExit:		; Memory Address ($5984) and binary offset [$5600]
	rts																			;4E75

Sockets_Actions:		; Memory Address ($5986) and binary offset [$5602]
	; Verifies the held object matches the occupied socket and dispatches the
	; crystal or gem-specific effect.
	lsr.w	#$03,d1																;E649
	add.w	#$0060,d1															;06410060
	cmp.w	$002E(a5),d1														;B26D002E
	bne.s	Socket_ClickExit													;66F2
	clr.l	$002C(a5)															;42AD002C
	movem.l	d0/a6,-(sp)															;48E78002
	bsr		adrCd005D40															;610003A4
	movem.l	(sp)+,d0/a6															;4CDF4001
	move.b	$00(a6,d0.w),d1														;12360000
	lsr.w	#$02,d1																;E449
	and.w	#$000E,d1															;0241000E
	lea		SocketActions_SerpentCrystal.l,a0									;41F9000059CE
	add.w	Sockets_LookupTable(pc,d1.w),a0										;D0FB100A
	jsr		(a0)																;4E90
	moveq	#Sound_AlternativeSpell,d0											;7005
	bra		PlaySound															;60002F02

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
	moveq	#$05,d4																;7805
	moveq	#$12,d6																;7C12
	bsr		adrCd005A7C															;610000A8
	cmp.w	#$0005,CurrentTower.l												;0C7900050000EE2E
	bne.s	Exit_SocketAction													;6610
	move.l	#$00090001,d7														;2E3C00090001
Last_CrystalAction:
	bsr		CoordToMap															;61002AB4
	and.w	#$00F8,$00(a6,d0.w)													;027600F80000
Exit_SocketAction:
	rts																			;4E75

SocketActions_ChaosCrystal:		; Memory Address ($59F2) and binary offset [$566E]
	bclr	#$02,$00(a6,d0.w)													;08B600020000
	bsr		adrCd008498															;61002A9E
	bsr		adrCd0078FA															;61001EFC
	cmp.w	#$0005,CurrentTower.l												;0C7900050000EE2E
	bne.s	Exit_SocketAction													;66E6
	lea		UnpackedMonsters.l,a0												;41F900016B7E
	cmp.b	#$6B,$000B(a0)														;0C28006B000B
	bne.s	.EntropySummoned													;6618
	tst.b	(a0)																;4A10
	bpl.s	.EntropySummoned													;6A14
	and.b	#$7F,(a0)															;0210007F
	move.l	#$00090008,d7														;2E3C00090008
	bsr		CoordToMap															;61002A74
	bset	#$07,$01(a6,d0.w)													;08F600070001
.EntropySummoned:		; Memory Address ($5A30) and binary offset [$56AC]
	move.l	#$00090003,d7														;2E3C00090003
	bra.s	Last_CrystalAction													;60AE

SocketActions_DragonCrystal:		; Memory Address ($5A38) and binary offset [$56B4]
	moveq	#$07,d4																;7807
	moveq	#$11,d6																;7C11
	bsr.s	adrCd005A7C															;613E
	cmp.w	#$0005,CurrentTower.l												;0C7900050000EE2E
	bne.s	Exit_SocketAction													;66A8
	move.l	#$00100008,d7														;2E3C00100008
	bsr.s	Last_CrystalAction													;6196
	move.l	#$00040008,d7														;2E3C00040008	;
	bra.s	Last_CrystalAction													;608E

SocketActions_MoonCrystal:		; Memory Address ($5A58) and binary offset [$56D4]
	moveq	#$09,d4																;7809
	moveq	#$13,d6																;7C13
	bsr.s	adrCd005A7C															;611E
	cmp.w	#$0005,CurrentTower.l												;0C7900050000EE2E
	bne.s	Exit_SocketAction													;6688
	move.l	#$00030009,d7														;2E3C00030009	;Long Addr replaced with Symbol
	bsr		Last_CrystalAction													;6100FF76
	move.l	#$000F0009,d7														;2E3C000F0009
	bra		Last_CrystalAction													;6000FF6C

adrCd005A7C:		; Memory Address ($5A7C) and binary offset [$56F8]
	bclr	#$02,$00(a6,d0.w)													;08B600020000
	moveq	#$03,d7																;7E03
adrLp005A84:		; Memory Address ($5A84) and binary offset [$5700]
	move.b	$18(a5,d7.w),d0														;10357018
	bmi.s	adrCd005A94															;6B0A
	bsr		Load_ChampionStatRecord												;61000BD4
	move.b	$01(a4,d4.w),$00(a4,d4.w)											;19B440014000
adrCd005A94:		; Memory Address ($5A94) and binary offset [$5710]
	dbra	d7,adrLp005A84														;51CFFFEE
	bsr		adrCd008498															;610029FE
	move.w	d6,d7																;3E06
	bsr		adrCd001DBC															;6100C31C
	bra		Draw_CompactStatsFrame												;60002554

SocketActions_TanGem:		; Memory Address ($5AA6) and binary offset [$5722]
	lea		TanGemLocs.l,a0														;41F900005AFA
	bra.s	TeleportGem															;6006

SocketActions_BluishGem:		; Memory Address ($5AAE) and binary offset [$572A]
	lea		BlueGemLocs.l,a0													;41F900005B12
TeleportGem:		; Memory Address ($5AB4) and binary offset [$5730]
	move.w	CurrentTower.l,d1													;32390000EE2E
	asl.w	#$02,d1																;E541
	add.w	d1,a0																;D0C1
	moveq	#$00,d6																;7C00
	move.b	(a0)+,d6															;1C18
	swap	d6																	;4846
	move.b	(a0)+,d6															;1C18
	cmp.l	$001C(a5),d6														;BCAD001C
	bne.s	adrCd005AD2															;6606
	move.b	(a0)+,d6															;1C18
	swap	d6																	;4846
	move.b	(a0),d6																;1C10
adrCd005AD2:		; Memory Address ($5AD2) and binary offset [$574E]
	bsr		adrCd008498															;610029C4
	bclr	#$07,$01(a6,d0.w)													;08B600070001
	move.l	d6,$001C(a5)														;2B46001C
	bsr		adrCd00847E															;6100299C
	bchg	#$02,$00(a6,d0.w)													;087600020000
	bsr		adrCd008498															;610029AC
	bset	#$07,$01(a6,d0.w)													;08F600070001
	moveq	#$10,d7																;7E10
	bra		adrCd001DBC															;6000C2C4

TanGemLocs:		; Memory Address ($5AFA) and binary offset [$5776]
	INCBIN "/data/BLOODWYCH439-clean/maps/gem-tan.locations"
BlueGemLocs:		; Memory Address ($5B12) and binary offset [$578E]
	INCBIN "/data/BLOODWYCH439-clean/maps/gem-blu.locations"

MainWall_Action_03_Switches:		; Memory Address ($5B2A) and binary offset [$57A6]
	; Toggles the switch display state and dispatches the tower-specific switch
	; trigger.
	moveq	#$00,d1																;7200
	move.b	$00(a6,d0.w),d1														;12360000
	and.w	#$00F8,d1															;024100F8
	beq.s	Switch_00_s00_Null													;6730
	bchg	#$02,$00(a6,d0.w)													;087600020000
	lsr.b	#$01,d1																;E209
	move.w	CurrentTower.l,d0													;30390000EE2E
	asl.w	#$06,d0																;ED40
	lea		SwitchData_1.l,a1													;43F900005B78
	add.w	d0,a1																;D2C0
	moveq	#$00,d0																;7000
	move.b	$00(a1,d1.w),d0														;10311000
	lea		Switch_00_s00_Null.l,a0												;41F900005B66
	add.w	Switches_LookupTable(pc,d0.w),a0									;D0FB000C
	jsr		(a0)																;4E90
	moveq	#$00,d0																;7000
	bra		PlaySound															;60002D5A

Switch_00_s00_Null:		; Memory Address ($5B66) and binary offset [$57E2]
	rts																			;4E75

Switches_LookupTable:		; Memory Address ($5B68) and binary offset [$57E4]
	dc.w	Switch_00_s00_Null-Switch_00_s00_Null	;0000
	dc.w	Switch_01_s02_Trigger_11_t16_RemoveXY-Switch_00_s00_Null	;01AC
	dc.w	Switch_02_s04_Trigger_23_t2E-Switch_00_s00_Null	;0196
	dc.w	Switch_03_s06_Trigger_03_t06_OpenLockedDoor_XY-Switch_00_s00_Null	;1BE0
	dc.w	Switch_04_s08_Trigger_22_t2C_RotateWall_XY-Switch_00_s00_Null	;1B4E
	dc.w	Switch_05_s0A_Trigger_13_t1A_TogglePillar_XY-Switch_00_s00_Null	;1C06
	dc.w	Switch_06_s0C_Trigger_18_t24_CreatePillar_XY-Switch_00_s00_Null	;1C02
	dc.w	Switch_07_s0E_Trigger_26_t34_RotateWood_XY-Switch_00_s00_Null	;1BF2
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

Switch_00_s00_Trigger_15_t1E_ToggleWallXY:		; Memory Address ($5CF8) and binary offset [$5974]
	bsr		Switch_01_s02_Trigger_11_t16_RemoveXY								;61000018
Switch_02_s04_Trigger_23_t2E:		; Memory Address ($5CFC) and binary offset [$5978]
	bsr.s	adrCd005D2E															;6130
	tst.b	$01(a6,d0.w)														;4A360001
	bmi.s	adrCd005D10															;6B0C
	and.w	#$00F9,$00(a6,d0.w)													;027600F90000
	eor.b	#$01,$01(a6,d0.w)													;0A3600010001
adrCd005D10:		; Memory Address ($5D10) and binary offset [$598C]
	rts																			;4E75

Switch_01_s02_Trigger_11_t16_RemoveXY:		; Memory Address ($5D12) and binary offset [$598E]
	bsr.s	adrCd005D2E															;611A
	move.b	$01(a6,d0.w),d2														;14360001
	and.w	#$0007,d2															;02420007
	subq.w	#$01,d2																;5342
	bne.s	adrCd005D26															;6606
	and.b	#$4F,$01(a6,d0.w)													;0236004F0001
adrCd005D26:		; Memory Address ($5D26) and binary offset [$59A2]
	and.b	#$F8,$01(a6,d0.w)													;023600F80001
	rts																			;4E75

adrCd005D2E:		; Memory Address ($5D2E) and binary offset [$59AA]
	moveq	#$00,d7																;7E00
	move.b	$02(a1,d1.w),d7														;1E311002
	swap	d7																	;4847
	move.b	$03(a1,d1.w),d7														;1E311003
	bra		CoordToMap															;60002760

adrJA005D3E:		; Memory Address ($5D3E) and binary offset [$59BA]
	bsr.s	adrCd005D52															;6112
adrCd005D40:		; Memory Address ($5D40) and binary offset [$59BC]
	cmp.w	#$0003,$0014(a5)													;0C6D00030014
	beq		Refresh_HeldItemDisplay												;67000EEC
	bra		Draw_HeldObjectDescription											;60000F86

adrCd005D4E:		; Memory Address ($5D4E) and binary offset [$59CA]
	bsr.s	adrCd005D9E															;614E
	bra.s	adrCd005D40															;60EE

adrCd005D52:		; Memory Address ($5D52) and binary offset [$59CE]
	move.l	$0002(a5),d1														;222D0002
	sub.w	$0008(a5),d1														;926D0008
	moveq	#$02,d6																;7C02
	cmpi.w	#$0051,d1															;0C410051
	bcs.s	adrCd005D64															;6502
	subq.w	#$02,d6																;5546
adrCd005D64:		; Memory Address ($5D64) and binary offset [$59E0]
	swap	d1																	;4841
	cmpi.w	#$00A0,d1															;0C4100A0
	bcs.s	adrCd005D6E															;6502
	addq.w	#$01,d6																;5246
adrCd005D6E:		; Memory Address ($5D6E) and binary offset [$59EA]
	move.l	$001C(a5),d7														;2E2D001C
	cmpi.w	#$0002,d6															;0C460002
	bcc.s	adrCd005D7E															;6406
	bsr		CoordToMap															;61002722
	bra.s	adrCd005D9E															;6020

adrCd005D7E:		; Memory Address ($5D7E) and binary offset [$59FA]
	bsr		adrCd008482															;61002702
	cmp.w	adrW_00EE72.l,d7													;BE790000EE72
	bcc.s	adrCd005D9C															;6412
	swap	d7																	;4847
	cmp.w	adrW_00EE70.l,d7													;BE790000EE70
	bcc.s	adrCd005D9C															;6408
	swap	d7																	;4847
	bsr		adrCd005E42															;610000AA
	bcc.s	adrCd005D9E															;6402
adrCd005D9C:		; Memory Address ($5D9C) and binary offset [$5A18]
	rts																			;4E75

adrCd005D9E:		; Memory Address ($5D9E) and binary offset [$5A1A]
	bclr	#$03,$01(a6,d0.w)													;08B600030001
	tst.w	$002E(a5)															;4A6D002E
	bne		adrCd005E7C															;660000D2
	btst	#$06,$01(a6,d0.w)													;083600060001
	beq.s	adrCd005D9C															;67E8
	bsr		adrCd005F2E															;61000178
	bsr		adrCd005F5C															;610001A2
	bne.s	adrCd005D9C															;66DE
	lea		$03(a0,d7.w),a1														;43F07003
	moveq	#$00,d3																;7600
	move.b	-$0001(a1),d3														;1629FFFF
	add.w	d3,d3																;D643
	moveq	#$00,d1																;7200
	move.b	$00(a1,d3.w),d1														;12313000
	move.w	d1,$002E(a5)														;3B41002E
	move.b	$01(a1,d3.w),d1														;12313001
	moveq	#$01,d2																;7401
	cmp.w	#$0005,$002E(a5)													;0C6D0005002E
	bcc.s	adrCd005DEC															;640A
	move.w	d1,d2																;3401
	cmpi.b	#$64,d2																;0C020064
	bcs.s	adrCd005DEC															;6502
	moveq	#$63,d2																;7463
adrCd005DEC:		; Memory Address ($5DEC) and binary offset [$5A68]
	move.w	d2,$002C(a5)														;3B42002C
	sub.b	d2,d1																;9202
	move.b	d1,$01(a1,d3.w)														;13813001
	bne.s	adrCd005D9C															;66A4
adrCd005DF8:		; Memory Address ($5DF8) and binary offset [$5A74]
	subq.b	#$01,-$0001(a1)														;5329FFFF
	bcs.s	adrCd005E1E															;6520
	lea		$00(a1,d3.w),a1														;43F13000
	lea		$0002(a1),a2														;45E90002
	add.w	d3,d7																;DE43
	addq.w	#$03,d7																;5647
	subq.w	#$02,-$0002(a0)														;5568FFFE
adrCd005E0E:		; Memory Address ($5E0E) and binary offset [$5A8A]
	move.w	-$0002(a0),d2														;3428FFFE
	sub.w	d7,d2																;9447
	bra.s	adrCd005E18															;6002

adrLp005E16:		; Memory Address ($5E16) and binary offset [$5A92]
	move.b	(a2)+,(a1)+															;12DA
adrCd005E18:		; Memory Address ($5E18) and binary offset [$5A94]
	dbra	d2,adrLp005E16														;51CAFFFC
	rts																			;4E75

adrCd005E1E:		; Memory Address ($5E1E) and binary offset [$5A9A]
	lea		$00(a0,d7.w),a1														;43F07000
	lea		$0005(a1),a2														;45E90005
	subq.w	#$05,-$0002(a0)														;5B68FFFE
	bsr.s	adrCd005E0E															;61E2
	moveq	#$03,d5																;7A03
adrLp005E2E:		; Memory Address ($5E2E) and binary offset [$5AAA]
	move.w	d5,d6																;3C05
	bsr		adrCd005F5C															;6100012A
	beq.s	adrCd005E40															;670A
	dbra	d5,adrLp005E2E														;51CDFFF6
	bclr	#$06,$01(a6,d0.w)													;08B600060001
adrCd005E40:		; Memory Address ($5E40) and binary offset [$5ABC]
	rts																			;4E75

adrCd005E42:		; Memory Address ($5E42) and binary offset [$5ABE]
	swap	d6																	;4846
	move.w	$0020(a5),d6														;3C2D0020
	move.w	d0,d2																;3400
	bsr		adrCd008498															;6100264C
	bsr		adrCd007AE6															;61001C96
	bcs.s	adrCd005E7A															;6526
	move.w	d2,d0																;3002
	move.b	$01(a6,d0.w),d1														;12360001
	and.w	#$0007,d1															;02410007
	subq.w	#$01,d1																;5341
	beq.s	adrCd005E76															;6714
	subq.w	#$01,d1																;5341
	bne.s	adrCd005E70															;660A
	eor.w	#$0002,d6															;0A460002
	bsr		adrCd007AF4															;61001C88
	bcs.s	adrCd005E7A															;650A
adrCd005E70:		; Memory Address ($5E70) and binary offset [$5AEC]
	move.w	d2,d0																;3002
	swap	d6																	;4846
	rts																			;4E75

adrCd005E76:		; Memory Address ($5E76) and binary offset [$5AF2]
	sub.b	#$FF,d1																;040100FF
adrCd005E7A:		; Memory Address ($5E7A) and binary offset [$5AF6]
	rts																			;4E75

adrCd005E7C:		; Memory Address ($5E7C) and binary offset [$5AF8]
	move.l	$002C(a5),d5														;2A2D002C
	clr.l	$002C(a5)															;42AD002C
	bsr		adrCd005F2E															;610000A8
adrCd005E88:		; Memory Address ($5E88) and binary offset [$5B04]
	bclr	#$03,$01(a6,d0.w)													;08B600030001
	bsr		adrCd005F5C															;610000CC
	bne		adrCd005F04															;66000070
	lea		$03(a0,d7.w),a1														;43F07003
	moveq	#$00,d3																;7600
	move.b	-$0001(a1),d3														;1629FFFF
	add.w	d3,d3																;D643
adrCd005EA2:		; Memory Address ($5EA2) and binary offset [$5B1E]
	cmp.b	$00(a1,d3.w),d5														;BA313000
	beq.s	adrCd005EE2															;673A
	subq.w	#$02,d3																;5543
	bcc.s	adrCd005EA2															;64F6
adrCd005EAC:		; Memory Address ($5EAC) and binary offset [$5B28]
	move.w	-$0002(a0),d2														;3428FFFE
	addq.w	#$02,-$0002(a0)														;5468FFFE
	addq.b	#$01,-$0001(a1)														;5229FFFF
	moveq	#$00,d3																;7600
	move.b	-$0001(a1),d3														;1629FFFF
	add.w	d3,d3																;D643
	lea		$00(a0,d2.w),a0														;41F02000
	lea		$0002(a0),a2														;45E80002
	add.w	d3,d7																;DE43
	addq.w	#$03,d7																;5647
	sub.w	d7,d2																;9447
	bra.s	adrCd005ED2															;6002

adrLp005ED0:		; Memory Address ($5ED0) and binary offset [$5B4C]
	move.b	-(a0),-(a2)															;1520
adrCd005ED2:		; Memory Address ($5ED2) and binary offset [$5B4E]
	dbra	d2,adrLp005ED0														;51CAFFFC
	move.b	d5,$00(a1,d3.w)														;13853000
	swap	d5																	;4845
	move.b	d5,$01(a1,d3.w)														;13853001
	rts																			;4E75

adrCd005EE2:		; Memory Address ($5EE2) and binary offset [$5B5E]
	swap	d5																	;4845
	add.b	$01(a1,d3.w),d5														;DA313001
	tst.b	-$0001(a1)															;4A29FFFF
	bne.s	adrCd005EF4															;6606
	move.b	d5,$01(a1,d3.w)														;13853001
	rts																			;4E75

adrCd005EF4:		; Memory Address ($5EF4) and binary offset [$5B70]
	swap	d5																	;4845
	move.w	d7,d1																;3207
	bsr		adrCd005DF8															;6100FEFE
	move.w	d1,d7																;3E01
	lea		$03(a0,d7.w),a1														;43F07003
	bra.s	adrCd005EAC															;60A8

adrCd005F04:		; Memory Address ($5F04) and binary offset [$5B80]
	bset	#$06,$01(a6,d0.w)													;08F600060001
	addq.w	#$05,-$0002(a0)														;5A68FFFE
	move.w	d0,d1																;3200
	move.b	d1,$01(a0,d7.w)														;11817001
	ror.w	#$08,d1																;E059
	or.b	d6,d1																;8206
	move.b	d1,$00(a0,d7.w)														;11817000
	move.b	#$00,$02(a0,d7.w)													;11BC00007002
	move.b	d5,$03(a0,d7.w)														;11857003
	swap	d5																	;4845
	move.b	d5,$04(a0,d7.w)														;11857004
	rts																			;4E75

adrCd005F2E:		; Memory Address ($5F2E) and binary offset [$5BAA]
	move.w	$0020(a5),d1														;322D0020
	add.w	d1,d1																;D241
	add.w	d1,d1																;D241
	add.w	d6,d1																;D246
	move.b	adrB_005F3E(pc,d1.w),d6												;1C3B1004
	rts																			;4E75

adrB_005F3E:		; Memory Address ($5F3E) and binary offset [$5BBA]
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

adrCd005F4E:		; Memory Address ($5F4E) and binary offset [$5BCA]
	lea		adrEA0174F8.l,a0													;41F9000174F8
adrCd005F54:		; Memory Address ($5F54) and binary offset [$5BD0]
	cmp.w	(a0),d0																;B050
	beq.s	adrCd005F92															;673A
	addq.w	#$04,a0																;5848
	bra.s	adrCd005F54															;60F8

adrCd005F5C:		; Memory Address ($5F5C) and binary offset [$5BD8]
	move.l	Current_TowerMapDataBase.l,a0										;20790000EE78
	add.w	#$0FCA,a0															;D0FC0FCA
	move.w	d0,d1																;3200
	ror.w	#$08,d1																;E059
	ror.b	#$02,d6																;E41E
	or.b	d6,d1																;8206
	moveq	#$00,d7																;7E00
	moveq	#$00,d2																;7400
adrCd005F72:		; Memory Address ($5F72) and binary offset [$5BEE]
	cmp.w	-$0002(a0),d7														;BE68FFFE
	bcc.s	adrCd005F90															;6418
	cmp.b	$01(a0,d7.w),d0														;B0307001
	bne.s	adrCd005F84															;6606
	cmp.b	$00(a0,d7.w),d1														;B2307000
	beq.s	adrCd005F92															;670E
adrCd005F84:		; Memory Address ($5F84) and binary offset [$5C00]
	move.b	$02(a0,d7.w),d2														;14307002
	add.w	d2,d2																;D442
	add.w	d2,d7																;DE42
	addq.w	#$05,d7																;5A47
	bra.s	adrCd005F72															;60E2

adrCd005F90:		; Memory Address ($5F90) and binary offset [$5C0C]
	moveq	#$01,d1																;7201
adrCd005F92:		; Memory Address ($5F92) and binary offset [$5C0E]
	rts																			;4E75

Click_Display_Centre:		; Memory Address ($5F94) and binary offset [$5C10]
	and.b	#$01,(a5)															;02150001
	bset	#$03,(a5)															;08D50003
	bra.s	Select_AttackingChampion											;6008

Handle_PrimaryAttackAction:		; Memory Address ($6322) and binary offset [$5F9E]
	; Primary attack action handler; sets the primary attack state bit and
	; continues through the common attack routine.
	and.b	#$01,(a5)															;02150001
	bset	#Player_AttackPrimaryStateBit,(a5)									;State bit set by the primary attack handler.
Select_AttackingChampion:		; Memory Address ($632A) and binary offset [$5FA6]
	; Common attack setup that selects the active champion/action participant.
	moveq	#$03,d1																;7203
	bsr		adrCd005500															;6100F556
	tst.w	d3																	;4A43
	bmi.s	adrCd005F92															;6BE2
	swap	d3																	;4843
	move.w	d3,d0																;3003
	bsr		Load_ChampionStatRecord												;610006AA
	clr.b	$0011(a4)															;422C0011
	bsr		Load_MapPosition_AI_TBC												;61002210
	bra		Draw_PartyCommandInterface											;60001B8E

adrCd005FC4:		; Memory Address ($5FC4) and binary offset [$5C40]
	lea		GFX_Pockets+$6508.l,a1												;43F900052C0A
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	$000A(a5),a0														;D0ED000A
	moveq	#$00,d0																;7000
	move.b	$18(a5,d7.w),d0														;10357018
	move.w	d0,d1																;3200
	and.w	#$000F,d1															;0241000F
	and.w	#$00E0,d0															;024000E0
	bne.s	adrCd005F92															;66AC
	move.w	d1,d0																;3001
	and.w	#$0003,d1															;02410003
	mulu	#$0460,d1															;C2FC0460
	add.w	d1,a1																;D2C1
	bsr		Character_GetClassIndex												;6100090C
	move.b	adrB_00600C(pc,d0.w),d3												;163B0014
	move.w	d7,d0																;3007
	add.w	d0,d0																;D040
	add.w	adrW_006010(pc,d0.w),a0												;D0FB0010
	move.l	#$00000006,-(sp)													;2F3C00000006
	bra		adrCd007E62															;60001E58

adrB_00600C:		; Memory Address ($600C) and binary offset [$5C88]
	dc.b	$06	;06
	dc.b	$0D	;0D
	dc.b	$0C	;0C
	dc.b	$08	;08
adrW_006010:		; Memory Address ($6010) and binary offset [$5C8C]
	dc.w	$0DF4	;0DF4
	dc.w	$0000	;0000
	dc.w	$000D	;000D
	dc.w	$001B	;001B

adrCd006018:		; Memory Address ($6018) and binary offset [$5C94]
	sub.w	$0020(a1),d0														;90690020
	addq.w	#$02,d0																;5440
	eor.w	#$0001,d2															;0A420001
	add.w	d2,d0																;D042
	and.w	#$0003,d0															;02400003
	moveq	#$00,d1																;7200
	move.b	$26(a1,d0.w),d1														;12310026
	bpl.s	adrCd006046															;6A16
	sub.w	d2,d0																;9042
	eor.w	#$0001,d2															;0A420001
	add.w	d2,d0																;D042
	and.w	#$0003,d0															;02400003
	move.b	$26(a1,d0.w),d1														;12310026
	bpl.s	adrCd006046															;6A04
	move.w	$0006(a1),d1														;32290006
adrCd006046:		; Memory Address ($6046) and binary offset [$5CC2]
	and.w	#$000F,d1															;0241000F
	clr.w	PhysicalAttack_DoubleDefenceFlag.l									;427900006458
	movem.l	d0/d1/a1/a4/a5,-(sp)												;48E7C04C
	move.w	d1,d0																;3001
	move.l	a1,a5																;2A49
	bsr		adrCd004078															;6100E01E
	move.b	(a5),d2																;1415
	and.w	#$000A,d2															;0242000A
	beq.s	adrCd006084															;6720
	btst	#$04,$18(a5,d1.w)													;083500041018
	beq.s	adrCd006074															;6708
	and.w	#$0008,d2															;02420008
	beq.s	adrCd006090															;671E
	bra.s	adrCd006084															;6010

adrCd006074:		; Memory Address ($6074) and binary offset [$5CF0]
	bsr		Load_ChampionStatRecord												;610005EA
	move.b	$0006(a4),d0														;102C0006
	lsr.b	#$01,d0																;E208
	cmp.b	$0005(a4),d0														;B02C0005
	bcs.s	adrCd006090															;650C
adrCd006084:		; Memory Address ($6084) and binary offset [$5D00]
	move.w	#$FFFF,PhysicalAttack_DoubleDefenceFlag.l							;33FCFFFF00006458
	bset	d1,$003C(a5)														;03ED003C
adrCd006090:		; Memory Address ($6090) and binary offset [$5D0C]
	movem.l	(sp)+,d0/d1/a1/a4/a5												;4CDF3203
adrCd006094:		; Memory Address ($6094) and binary offset [$5D10]
	rts																			;4E75

adrCd006096:		; Memory Address ($6096) and binary offset [$5D12]
	tst.b	d7																	;4A07
	bne.s	adrCd0060A2															;6608
	cmp.b	#$02,$0015(a5)														;0C2D00020015
	bcc.s	adrCd006094															;64F2
adrCd0060A2:		; Memory Address ($60A2) and binary offset [$5D1E]
	or.b	#$B0,$0054(a5)														;002D00B00054
	moveq	#$67,d4																;7867
	moveq	#$06,d5																;7A06
	swap	d4																	;4844
	swap	d5																	;4845
	move.b	adrB_0060C2(pc,d7.w),d4												;183B7010
	move.b	adrB_0060C6(pc,d7.w),d5												;1A3B7010
	add.w	$0008(a5),d5														;DA6D0008
	moveq	#$00,d3																;7600
	bra		BW_draw_bar															;600079A8

adrB_0060C2:		; Memory Address ($60C2) and binary offset [$5D3E]
	dc.b	$60	;60
	dc.b	$00	;00
	dc.b	$68	;68
	dc.b	$D8	;D8
adrB_0060C6:		; Memory Address ($60C6) and binary offset [$5D42]
	dc.b	$59	;59
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00

adrCd0060CA:		; Memory Address ($60CA) and binary offset [$5D46]
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	$000A(a5),a0														;D0ED000A
	move.l	a4,-(sp)															;2F0C
	move.b	$18(a5,d7.w),d0														;10357018
	bsr		Load_ChampionStatRecord												;61000584
	move.b	$0019(a4),d0														;102C0019
	move.l	(sp)+,a4															;285F
	lsr.b	#$04,d0																;E808
	subq.b	#$02,d0																;5500
	move.b	d0,$5E(a5,d7.w)														;1B80705E
	add.w	d7,d7																;DE47
	add.w	adrW_006134(pc,d7.w),a0												;D0FB7044
	moveq	#$0B,d6																;7C0B
	tst.w	d7																	;4A47
	bne.s	adrCd006102															;660A
	moveq	#$0E,d6																;7C0E
	or.b	#$10,$0054(a5)														;002D00100054
	bra.s	adrCd006108															;6006

adrCd006102:		; Memory Address ($6102) and binary offset [$5D7E]
	or.b	#$A0,$0054(a5)														;002D00A00054
adrCd006108:		; Memory Address ($6108) and binary offset [$5D84]
	move.l	#$000D0000,adrW_00D92A.l											;23FC000D00000000D92A
	lea		OutcomeMsgs_0.l,a6													;4DF900006142
	move.b	OutcomeMsgOffsets(pc,d4.w),d4										;183B4022
	bne.s	adrCd00612E															;6610
	move.w	d5,d0																;3005
	beq.s	adrCd006130															;670E
	lea		OutcomeMsgs_5.l,a6													;4DF90000616B
	moveq	#$09,d2																;7409
	bsr.s	adrCd006178															;614C
	moveq	#$00,d4																;7800
adrCd00612E:		; Memory Address ($612E) and binary offset [$5DAA]
	add.w	d4,a6																;DCC4
adrCd006130:		; Memory Address ($6130) and binary offset [$5DAC]
	bra		adrLp00CFDA															;60006EA8

adrW_006134:		; Memory Address ($6134) and binary offset [$5DB0]
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
Notice_NumberOfHits:
	dc.b	'000'	;303030
	dc.b	$FF	;FF

adrCd006178:		; Memory Address ($6178) and binary offset [$5DF4]
	move.w	d0,d1																;3200
	moveq	#$00,d0																;7000
	move.w	d1,d0																;3001
	divu	#$0064,d0															;80FC0064
	move.w	d0,d3																;3600
	beq.s	adrCd006190															;670A
	add.b	#$30,d0																;06000030
	move.b	d0,$00(a6,d2.w)														;1D802000
	addq.w	#$01,d2																;5242
adrCd006190:		; Memory Address ($6190) and binary offset [$5E0C]
	swap	d0																	;4840
	bsr		Convert_ByteToDecimalText											;61006D30
	move.b	d1,d0																;1001
	ror.w	#$08,d1																;E059
	tst.w	d3																	;4A43
	bne.s	adrCd0061A4															;6606
	cmpi.b	#$30,d1																;0C010030
	beq.s	adrCd0061AA															;6706
adrCd0061A4:		; Memory Address ($61A4) and binary offset [$5E20]
	move.b	d1,$00(a6,d2.w)														;1D812000
	addq.w	#$01,d2																;5242
adrCd0061AA:		; Memory Address ($61AA) and binary offset [$5E26]
	move.b	d0,$00(a6,d2.w)														;1D802000
	move.b	#$FF,$01(a6,d2.w)													;1DBC00FF2001
	rts																			;4E75

Close_AttackedChampionCommunicationPanels:		; Memory Address ($61B6) and binary offset [$5E32]
	; Closes either player's communication panel when its selected target is the
	; champion being attacked.
	movem.l	d1/d3/a5,-(sp)														;48E75004
	lea		Player1_Data.l,a5													;4BF90000EE7C
	bsr.s	Close_PlayerCommunicationIfTargetAttacked							;610E
	lea		Player2_Data.l,a5													;4BF90000EEDE
	bsr.s	Close_PlayerCommunicationIfTargetAttacked							;6106
	movem.l	(sp)+,d1/d3/a5														;4CDF200A
	rts																			;4E75

Close_PlayerCommunicationIfTargetAttacked:		; Memory Address ($61D0) and binary offset [$5E4C]
	; Clears one player's communication state when the attacked champion matches
	; the selected target.
	cmp.b	$0035(a5),d1														;B22D0035
	beq		adrCd00332A															;6700D154
	rts																			;4E75

Resolve_PhysicalAttack:		; Memory Address ($61DA) and binary offset [$5E56]
	; Performs the opposed attack roll, calculates weapon damage, subtracts armour
	; and applies the hit-quality multiplier.
	moveq	#Sound_AttackClink,d0												;Selects the fighting clink played when a physical attack begins.
	bsr		PlaySound															;610026E0
	bsr.s	Close_AttackedChampionCommunicationPanels							;61D4
	bsr		Prepare_AttackAndDefenceScores										;61000238
	clr.w	$0000(a6)															;426E0000
	clr.w	adrW_00230A.w														;4278230A	;Short Absolute converted to symbol!
	bsr		RandomGen_100														;6100F3C8
	add.w	$0002(a6),d0														;D06E0002
	move.w	d0,d2																;3400
	bsr		RandomGen_100														;6100F3BE
	add.w	$0004(a6),d0														;D06E0004
	sub.w	d0,d2																;9440
	bmi.s	PhysicalAttack_HandleDefenderRollWin								;6B0C
	move.w	d2,d0																;3002
	moveq	#$40,d2																;7440
	sub.w	d0,d2																;9440
	bpl.s	PhysicalAttack_CalculateDamage										;6A10
	moveq	#$01,d2																;7401
	bra.s	PhysicalAttack_CalculateDamage										;600C

PhysicalAttack_HandleDefenderRollWin:		; Memory Address ($6210) and binary offset [$5E8C]
	neg.w	d2																	;4442
	move.w	d2,d0																;3002
	moveq	#$40,d2																;7440
	cmp.w	d2,d0																;B042
	bpl		PhysicalAttack_Return												;6A00006E
PhysicalAttack_CalculateDamage:		; Memory Address ($621C) and binary offset [$5E98]
	; Calculates base damage from weapon range, level, fixed weapon damage and
	; effective Strength.
	move.w	$0006(a6),d1														;322E0006
	bsr		RandomGen															;6100F39A
	addq.w	#$01,d0																;5240
	add.b	$0008(a6),d0														;D02E0008
	add.b	$000A(a6),d0														;D02E000A
	moveq	#$00,d1																;7200
	move.b	$0009(a6),d1														;122E0009
	sub.w	#$0014,d1															;04410014
	bcs.s	PhysicalAttack_ApplyBackstabDamage									;6504
	lsr.w	#$03,d1																;E649
	add.w	d1,d0																;D041
PhysicalAttack_ApplyBackstabDamage:		; Memory Address ($623E) and binary offset [$5EBA]
	; Triples damage when the attack retains backstab eligibility.
	tst.w	PhysicalAttack_BackstabState.l										;4A790000628A
	bne.s	PhysicalAttack_CalculateArmourReduction								;6606
	move.w	d0,d1																;3200
	add.w	d0,d0																;D040
	add.w	d1,d0																;D041
PhysicalAttack_CalculateArmourReduction:		; Memory Address ($624C) and binary offset [$5EC8]
	; Calculates the defender's armour reduction, including conditional upward
	; rounding.
	moveq	#$00,d4																;7800
	move.b	$000D(a6),d4														;182E000D
	lsr.b	#$01,d4																;E20C
	bcc.s	PhysicalAttack_ApplyArmourReduction									;640E
	move.w	d2,d1																;3202
	and.w	#$000F,d1															;0241000F
	beq.s	PhysicalAttack_RoundArmourReductionUp								;6704
	subq.w	#$08,d1																;5141
	bcs.s	PhysicalAttack_ApplyArmourReduction									;6502
PhysicalAttack_RoundArmourReductionUp:		; Memory Address ($6262) and binary offset [$5EDE]
	addq.w	#$01,d4																;5244
PhysicalAttack_ApplyArmourReduction:		; Memory Address ($6264) and binary offset [$5EE0]
	; Subtracts effective armour before applying hit-quality damage multipliers.
	sub.w	d4,d0																;9044
	bcs.s	PhysicalAttack_Return												;6520
	beq.s	PhysicalAttack_Return												;671E
	move.w	d0,d1																;3200
	cmpi.w	#$0028,d2															;0C420028
	bcc.s	PhysicalAttack_StoreDamage											;6412
	add.w	d1,d0																;D041
	cmpi.w	#$0019,d2															;0C420019
	bcc.s	PhysicalAttack_StoreDamage											;640A
	add.w	d1,d0																;D041
	cmpi.w	#$000A,d2															;0C42000A
	bcc.s	PhysicalAttack_StoreDamage											;6402
	add.w	d1,d0																;D041
PhysicalAttack_StoreDamage:		; Memory Address ($6284) and binary offset [$5F00]
	; Stores the final positive damage in the physical-attack working values.
	move.w	d0,$0000(a6)														;3D400000
PhysicalAttack_Return:		; Memory Address ($6288) and binary offset [$5F04]
	rts																			;4E75

PhysicalAttack_BackstabState:		; Memory Address ($628A) and binary offset [$5F06]
	ds.b	$2
Load_CombatantCombatValues:		; Memory Address ($628C) and binary offset [$5F08]
	; Loads champion or monster combat statistics and applies equipment and
	; active-spell modifiers.
	moveq	#$00,d4																;7800
	moveq	#$00,d5																;7A00
	moveq	#$00,d6																;7C00
	moveq	#$00,d7																;7E00
	cmpi.w	#$0010,d0															;0C400010
	bcs.s	Load_ChampionCombatValues											;652C
	sub.w	#$0010,d0															;04400010
	asl.w	#$04,d0																;E940
	lea		UnpackedMonsters.l,a4												;49F900016B7E
	add.w	d0,a4																;D8C0
	moveq	#$1E,d1																;721E
	moveq	#$14,d2																;7414
	move.b	$0006(a4),d0														;102C0006
	and.w	#$007F,d0															;0240007F
	move.w	d0,d3																;3600
	add.w	d3,d3																;D643
	add.w	d3,d1																;D243
	add.w	d3,d1																;D243
	add.w	d3,d2																;D443
	add.w	d0,d3																;D640
	lsr.w	#$01,d3																;E24B
	moveq	#$08,d4																;7808
	rts																			;4E75

Load_ChampionCombatValues:		; Memory Address ($62C6) and binary offset [$5F42]
	move.w	d0,d1																;3200
	bsr		Load_ChampionStatRecord												;61000396
	subq.b	#PhysicalAttack_VitalityCost,$0007(a4)								;Vitality removed when champion combat values are loaded for physical combat.
	bcc.s	Apply_ChampionCombatModifiers										;6404
	clr.b	$0007(a4)															;422C0007
Apply_ChampionCombatModifiers:		; Memory Address ($62D6) and binary offset [$5F52]
	move.w	d1,d0																;3001
	bsr.s	Calculate_CharacterArmourLevel										;6144
	bsr		Calculate_WeaponCombatBonuses										;610000A6
	bsr		Calculate_WarriorLevelContribution									;6100A644
	tst.w	PhysicalAttack_BackstabState.w										;4A78628A	;Short Absolute converted to symbol!
	bne.s	Apply_WarpowerCombatModifiers										;6602
	move.b	(a4),d0																;1014
Apply_WarpowerCombatModifiers:		; Memory Address ($62EA) and binary offset [$5F66]
	moveq	#$00,d1																;7200
	move.b	$0011(a4),d1														;122C0011
	move.w	d1,d2																;3401
	and.w	#$0007,d2															;02420007
	subq.b	#WornSpell_Warpower,d2												;Low three-bit worn-spell type used for Warpower.
	bne.s	Load_NormalChampionCombatStats										;6618
	lsr.b	#$03,d1																;E609
	move.w	d1,d2																;3401
	lsr.w	#$02,d2																;E44A
	addq.w	#$01,d2																;5242
	add.w	d2,d0																;D042
	move.w	d1,d2																;3401
	add.b	$0001(a4),d1														;D22C0001
	addq.b	#Combat_StrengthBias,d1												;Internal Strength bias applied before physical-combat thresholds.
	add.b	$0002(a4),d2														;D42C0002
	rts																			;4E75

Load_NormalChampionCombatStats:		; Memory Address ($6312) and binary offset [$5F8E]
	move.b	$0001(a4),d1														;122C0001
	addq.b	#Combat_StrengthBias,d1												;Internal Strength bias applied before physical-combat thresholds.
	move.b	$0002(a4),d2														;142C0002
	rts																			;4E75

Calculate_CharacterArmourLevel:		; Memory Address ($631E) and binary offset [$5F9A]
	; Combines body armour, worn gloves and shield values into the character's
	; effective armour level.
	lea		Character_Pockets_DataTable.l,a1									;43F90000ED2A
	asl.w	#$04,d0																;E940
	add.w	d0,a1																;D2C0
	move.b	$0011(a4),d3														;162C0011
	move.w	d3,d2																;3403
	lsr.b	#$03,d2																;E60A
	and.w	#$0007,d3															;02430007
	beq.s	Armour_SelectInnateOrSpellValue										;6702
	moveq	#$00,d2																;7400
Armour_SelectInnateOrSpellValue:		; Memory Address ($6338) and binary offset [$5FB4]
	; Selects the greater of innate armour and an active Armour-spell magnitude.
	move.b	$000B(a4),d3														;162C000B
	cmp.b	d3,d2																;B403
	bcs.s	Armour_ApplyBodyArmour												;6502
	move.b	d2,d3																;1602
Armour_ApplyBodyArmour:		; Memory Address ($6342) and binary offset [$5FBE]
	; Replaces the base armour value when the worn body armour provides greater
	; protection.
	move.b	$0002(a1),d2														;14290002
	beq.s	Armour_ApplyWornHandArmour											;670E
	sub.b	#$1B,d2																;0402001B
	add.b	d2,d2																;D402
	addq.b	#$03,d2																;5602
	cmp.b	d2,d3																;B602
	bcc.s	Armour_ApplyWornHandArmour											;6402
	move.b	d2,d3																;1602
Armour_ApplyWornHandArmour:		; Memory Address ($6356) and binary offset [$5FD2]
	; Adds the contribution of the champion's worn hand-armour object.
	move.b	$0012(a4),d2														;142C0012
	beq.s	Armour_ApplyShield													;6706
	sub.b	#$2B,d2																;0402002B
	add.b	d2,d3																;D602
Armour_ApplyShield:		; Memory Address ($6362) and binary offset [$5FDE]
	; Adds the equipped shield's armour contribution.
	moveq	#$00,d2																;7400
	move.b	$0003(a1),d2														;14290003
	sub.b	#$24,d2																;04020024
	bcs.s	Armour_Return														;650A
	cmpi.w	#$0007,d2															;0C420007
	bcc.s	Armour_Return														;6404
	add.b	Shield_ArmourBonuses(pc,d2.w),d3									;D63B2004
Armour_Return:		; Memory Address ($6378) and binary offset [$5FF4]
	rts																			;4E75

Shield_ArmourBonuses:		; Memory Address ($637A) and binary offset [$5FF6]
	; Maps shield objects $24-$2A to armour contributions; the eighth byte is
	; unused by the seven-entry range.
	INCBIN "/data/BLOODWYCH439-clean/data/Shield_ArmourBonuses.lookup"

Calculate_WeaponCombatBonuses:		; Memory Address ($6382) and binary offset [$5FFE]
	; Checks the two held-object slots for weapon objects $30-$3F and loads their
	; combat adjustments.
	moveq	#$00,d0																;7000
	move.b	(a1),d0																;1011
	sub.b	#Object_Blades_First,d0												;First blade object and exclusive end of gloves.
	bcs.s	Weapon_CheckRightHand												;6506
	cmpi.b	#Weapon_CombatModifierRecordCount,d0								;Number of four-byte records in Weapon_CombatModifiers.
	bcs.s	Weapon_LoadCombatModifiers											;6510
Weapon_CheckRightHand:		; Memory Address ($6392) and binary offset [$600E]
	; Checks the right-hand pocket after the left hand does not contain a
	; recognised weapon.
	move.b	$0001(a1),d0														;10290001
	sub.b	#Object_Blades_First,d0												;First blade object and exclusive end of gloves.
	bcs.s	Weapon_ReturnCombatModifiers										;653E
	cmpi.b	#Weapon_CombatModifierRecordCount,d0								;Number of four-byte records in Weapon_CombatModifiers.
	bcc.s	Weapon_ReturnCombatModifiers										;6438
Weapon_LoadCombatModifiers:		; Memory Address ($63A2) and binary offset [$601E]
	; Loads random damage, fixed damage, attack and defence modifiers from the
	; selected weapon record.
	lea		Weapon_CombatModifiers.l,a0											;41F9000063DC
	asl.w	#$02,d0																;E540
	add.w	d0,a0																;D0C0
	move.b	(a0)+,d4															;1818
	move.b	(a0)+,d5															;1A18
	move.b	(a0)+,d6															;1C18
	move.b	(a0)+,d7															;1E18
	tst.w	PhysicalAttack_BackstabState.w										;4A78628A	;Short Absolute converted to symbol!
	bne.s	Weapon_ApplyAceOfSwordsRestriction									;660C
	cmpi.b	#Weapon_BackstabEligibleByteLimit,d0								;Exclusive byte-offset limit for weapon records which preserve a Cutpurse backstab.
	bcs.s	Weapon_ApplyAceOfSwordsRestriction									;6506
	move.w	#$FFFF,PhysicalAttack_BackstabState.w								;31FCFFFF628A	;Short Absolute converted to symbol!
Weapon_ApplyAceOfSwordsRestriction:		; Memory Address ($63C6) and binary offset [$6042]
	; Reduces the Ace of Swords combat modifiers unless Chaos Gloves are worn.
	cmpi.b	#Weapon_AceOfSwordsRecordOffset,d0									;Byte offset of the Ace of Swords record within Weapon_CombatModifiers.
	bne.s	Weapon_ReturnCombatModifiers										;660E
	cmp.b	#Object_ChaosGloves,$0012(a4)										;Chaos Gloves object code.
	beq.s	Weapon_ReturnCombatModifiers										;6706
	moveq	#$05,d6																;7C05
	moveq	#$05,d7																;7E05
	moveq	#$00,d5																;7A00
Weapon_ReturnCombatModifiers:		; Memory Address ($63DA) and binary offset [$6056]
	rts																			;4E75

Weapon_CombatModifiers:		; Memory Address ($63DC) and binary offset [$6058]
	; Sixteen four-byte records for weapons $30-$3F: random damage range, fixed
	; damage bonus, attack bonus and defence bonus.
	INCBIN "/data/BLOODWYCH439-clean/data/Weapon_CombatModifiers.lookup"

Prepare_AttackAndDefenceScores:		; Memory Address ($641C) and binary offset [$6098]
	; Builds the attacker score and defender score, including weapon attack, weapon
	; defence and effective armour values.
	lea		PhysicalAttack_WorkingValues.l,a6									;4DF900016B6C
	move.w	d1,-(sp)															;3F01
	move.w	d3,d0																;3003
	bsr		Calculate_AttackerCombatScore										;61000032
	move.w	(sp)+,d0															;301F
	bsr		Load_CombatantCombatValues											;6100FE5E
	move.b	d7,$000C(a6)														;1D47000C
	move.b	d3,$000D(a6)														;1D43000D
	lsr.w	#$03,d2																;E64A
	add.w	d2,d0																;D042
	move.w	d0,d1																;3200
	asl.w	#$02,d0																;E540
	add.w	d1,d0																;D041
	move.b	$000C(a6),d1														;122E000C
	add.w	d1,d0																;D041
	tst.w	PhysicalAttack_DoubleDefenceFlag.l									;4A7900006458
	beq.s	DefenderScore_StoreResult											;6702
	add.w	d0,d0																;D040
DefenderScore_StoreResult:		; Memory Address ($6452) and binary offset [$60CE]
	; Stores the completed defender score in the physical-attack working values.
	move.w	d0,$0004(a6)														;3D400004
	rts																			;4E75

PhysicalAttack_DoubleDefenceFlag:		; Memory Address ($6458) and binary offset [$60D4]
	ds.b	$2
Calculate_AttackerCombatScore:		; Memory Address ($645A) and binary offset [$60D6]
	; Calculates an attacker score from level, strength, agility and the equipped
	; weapon’s attack bonus.
	bsr		Load_CombatantCombatValues											;6100FE30
	move.b	d6,$000B(a6)														;1D46000B
	move.b	d5,$000A(a6)														;1D45000A
	move.b	d4,$0006(a6)														;1D440006
	clr.b	$0007(a6)															;422E0007
	move.b	d0,$0008(a6)														;1D400008
	move.b	d1,$0009(a6)														;1D410009
	add.w	d0,d0																;D040
	sub.w	#$0010,d1															;04410010
	bcc.s	AttackerScore_AddStrengthContribution								;6402
	moveq	#$00,d1																;7200
AttackerScore_AddStrengthContribution:		; Memory Address ($6480) and binary offset [$60FC]
	; Adds the thresholded effective-Strength contribution to the attacker score.
	lsr.w	#$04,d1																;E849
	add.w	d1,d0																;D041
	sub.w	#$0014,d2															;04420014
	bcc.s	AttackerScore_AddAgilityContribution								;6402
	moveq	#$00,d2																;7400
AttackerScore_AddAgilityContribution:		; Memory Address ($648C) and binary offset [$6108]
	; Adds the thresholded effective-Agility contribution to the attacker score.
	lsr.w	#$04,d2																;E84A
	add.w	d2,d0																;D042
	move.w	d0,d1																;3200
	asl.w	#$02,d0																;E540
	add.w	d1,d0																;D041
	move.b	$000B(a6),d1														;122E000B
	add.w	d1,d0																;D041
	tst.w	PhysicalAttack_BackstabState.w										;4A78628A	;Short Absolute converted to symbol!
	bne.s	AttackerScore_StoreResult											;6602
	add.w	d0,d0																;D040
AttackerScore_StoreResult:		; Memory Address ($64A4) and binary offset [$6120]
	; Stores the completed attacker score in the physical-attack working values.
	move.w	d0,$0002(a6)														;3D400002
	rts																			;4E75

Click_MultiFunctionButton:		; Memory Address ($64AA) and binary offset [$6126]
	bsr		Load_CurrentChampionStatRecord										;610001B0
	tst.b	$0011(a4)															;4A2C0011
	beq.s	Resolve_MultiFunctionContext										;670E
	clr.b	$0011(a4)															;422C0011
	move.w	$0006(a5),d7														;3E2D0006
	bsr		Draw_MainChampionAvatarInnerFrame									;6100681A
	bra.s	adrCd0064CC															;600A

Resolve_MultiFunctionContext:		; Memory Address ($6846) and binary offset [$64C2]
	; Continuation of the multi-function handler; selects interaction, spell, or
	; map-AI behaviour from context.
	tst.b	$0013(a4)															;4A2C0013
	bmi.s	adrJA0064D0															;6B08
	bsr		Cast_SelectedChampionSpell											;6100E9C4
adrCd0064CC:		; Memory Address ($64CC) and binary offset [$6148]
	bra		Load_MapPosition_AI_TBC												;60001D00

adrJA0064D0:		; Memory Address ($64D0) and binary offset [$614C]
	moveq	#$02,d3																;7602
	move.w	$0020(a5),d2														;342D0020
	add.w	d2,d2																;D442
	addq.w	#$01,d2																;5242
	bsr		adrCd008498															;61001FBC
	move.b	$01(a6,d0.w),d1														;12360001
	and.w	#$0007,d1															;02410007
	cmpi.b	#$02,d1																;0C010002
	bne.s	adrCd0064F2															;6606
	btst	d2,$00(a6,d0.w)														;05360000
	bne.s	Toggle_WallFeatureOrReportLocked									;6660
adrCd0064F2:		; Memory Address ($64F2) and binary offset [$616E]
	bsr		adrCd008482															;61001F8E
	cmp.w	adrW_00EE72.l,d7													;BE790000EE72
	bcc.s	adrCd006550															;6452
	swap	d7																	;4847
	cmp.w	adrW_00EE70.l,d7													;BE790000EE70
	bcc.s	adrCd006550															;6448
	eor.w	#$0004,d2															;0A420004
	move.b	$01(a6,d0.w),d1														;12360001
	and.w	#$0007,d1															;02410007
	cmpi.b	#$02,d1																;0C010002
	beq.s	adrCd00654A															;6730
	cmpi.b	#$05,d1																;0C010005
	bne.s	adrCd006550															;6630
	tst.b	$01(a6,d0.w)														;4A360001
	bmi.s	adrCd006550															;6B2A
	btst	#$03,$00(a6,d0.w)													;083600030000
	bne.s	Return_WallFeatureLocked											;6666
	moveq	#$01,d2																;7401
	move.b	$00(a6,d0.w),d3														;16360000
	lsr.b	#$04,d3																;E80B
	beq.s	adrCd00657C															;6744
	add.w	#$004F,d3															;0643004F
	cmp.w	$002E(a5),d3														;B66D002E
	bne.s	Return_WallFeatureLocked											;6652
	and.b	#$0F,$00(a6,d0.w)													;0236000F0000
	bra.s	Toggle_WallFeatureOrReportLocked									;6008

adrCd00654A:		; Memory Address ($654A) and binary offset [$61C6]
	btst	d2,$00(a6,d0.w)														;05360000
	bne.s	Toggle_WallFeatureOrReportLocked									;6602
adrCd006550:		; Memory Address ($6550) and binary offset [$61CC]
	rts																			;4E75

Toggle_WallFeatureOrReportLocked:		; Memory Address ($68D6) and binary offset [$6552]
	; Checks and changes a wall-feature or door state.
	cmp.w	$002E(a5),d3														;B66D002E
	bne.s	adrCd00657C															;6624
	subq.w	#$01,$002C(a5)														;536D002C
	bne.s	adrCd006562															;6604
	clr.w	$002E(a5)															;426D002E
adrCd006562:		; Memory Address ($6562) and binary offset [$61DE]
	bchg	#$04,$01(a6,d0.w)													;087600040001
	cmp.w	#$0003,$0014(a5)													;0C6D00030014
	bne.s	adrCd00657C															;660C
	movem.l	d0/d2/a6,-(sp)														;48E7A002
	bsr		Draw_HeldItemPanel													;610006CC
	movem.l	(sp)+,d0/d2/a6														;4CDF4005
adrCd00657C:		; Memory Address ($657C) and binary offset [$61F8]
	subq.w	#$01,d2																;5342
	btst	#$04,$01(a6,d0.w)													;083600040001
	bne.s	Return_WallFeatureLocked											;660E
	bchg	d2,$00(a6,d0.w)														;05760000
	moveq	#Sound_DoorClick,d0													;Selects the click played when a wall feature or door changes state.
	bsr		PlaySound															;61002330
	bra		adrCd00CF96															;60006A04

Return_WallFeatureLocked:		; Memory Address ($6918) and binary offset [$6594]
	; Locked-door failure path that displays the locked-door message.
	lea		Notice_DoorLocked.l,a6												;4DF90000659E
	bra		WriteTimedText														;60006AEC

Notice_DoorLocked:
	dc.b	'THE DOOR IS LOCKED'	;54484520444F4F52204953204C4F434B4544
	dc.b	$FF	;FF
	dc.b	$00	;00

Click_PartyMember:		; Memory Address ($65B2) and binary offset [$622E]
	lsr.w	#$02,d0																;E448
	subq.w	#$06,d0																;5D40
	tst.w	$0016(a5)															;4A6D0016
	bpl.s	adrCd0065CC															;6A10
	tst.b	$26(a5,d0.w)														;4A350026
	bpl.s	adrCd0065C4															;6A02
	rts																			;4E75

adrCd0065C4:		; Memory Address ($65C4) and binary offset [$6240]
	move.w	d0,$0016(a5)														;3B400016
	bra		adrCd008396															;60001DCC

adrCd0065CC:		; Memory Address ($65CC) and binary offset [$6248]
	cmp.w	$0016(a5),d0														;B06D0016
	beq.s	adrCd0065E8															;6716
	move.b	$26(a5,d0.w),d1														;12350026
	move.w	$0016(a5),d2														;342D0016
	move.b	$26(a5,d2.w),$26(a5,d0.w)											;1BB520260026
	move.b	d1,$26(a5,d2.w)														;1B812026
	moveq	#-$01,d0															;70FF
	bra.s	adrCd0065C4															;60DC

adrCd0065E8:		; Memory Address ($65E8) and binary offset [$6264]
	move.b	$26(a5,d0.w),d0														;10350026
	bmi.s	adrCd006608															;6B1A
	move.w	$0006(a5),d2														;342D0006
	move.w	d0,$0006(a5)														;3B400006
	bsr		adrCd004078															;6100DA80
	move.b	d2,$18(a5,d1.w)														;1B821018
	move.b	d0,$0018(a5)														;1B400018
	bset	#$04,$0018(a5)														;08ED00040018
adrCd006608:		; Memory Address ($6608) and binary offset [$6284]
	move.w	#$FFFF,$0016(a5)													;3B7CFFFF0016
	bsr		Draw_ChampionNamePanelFrame											;61001C68
	bra		Draw_PartyCommandInterface											;6000153C

Click_ShowStats:		; Memory Address ($6616) and binary offset [$6292]
	; Selects statistics mode, draws the tall scroll using D5=$38, prints
	; ChampionStatsScroll_FoodTextTemplate and draws the champion food bar from
	; record byte $10.
	move.w	#$0001,$0014(a5)													;3B7C00010014
	moveq	#$38,d5																;7A38
	bsr		Draw_ChampionStats													;6100650A
	lea		ChampionStatsScroll_FoodTextTemplate.l,a6							;4DF90000E9E8
	bsr		Print_fflim_text													;61006A9C
	asl.w	#$05,d7																;EB47
	lea		Character_Stats_DataTable.l,a6										;4DF90000EB2A
	moveq	#$00,d0																;7000
	move.b	$10(a6,d7.w),d0														;10367010
	beq.s	adrCd00666E															;6732
	move.w	#$00C7,d1															;323C00C7
	moveq	#$30,d2																;7430
	move.l	#$002F00F9,d4														;283C002F00F9
	bsr		Scale_ValueToBarLength												;61001AFA
	move.l	#$0004004A,d5														;2A3C0004004A	;Long Addr replaced with Symbol
	add.w	$0008(a5),d5														;DA6D0008
	moveq	#$09,d3																;7609
	bra		BW_draw_bar															;6000740E

Load_CurrentChampionStatRecord:		; Memory Address ($665C) and binary offset [$62D8]
	; Loads the current player champion number before resolving its statistics
	; record.
	move.w	$0006(a5),d0														;302D0006
Load_ChampionStatRecord:		; Memory Address ($6660) and binary offset [$62DC]
	; Converts champion number D0 into a pointer to its 32-byte statistics record
	; in A4.
	and.w	#$000F,d0															;0240000F
	asl.w	#$05,d0																;EB40
	lea		Character_Stats_DataTable.l,a4										;49F90000EB2A
	add.w	d0,a4																;D8C0
adrCd00666E:		; Memory Address ($666E) and binary offset [$62EA]
	rts																			;4E75

adrCd006670:		; Memory Address ($6670) and binary offset [$62EC]
	clr.w	$002A(a5)															;426D002A
	move.b	$0013(a4),d0														;102C0013
	bmi.s	adrCd006682															;6B08
	lsr.b	#$03,d0																;E608
	add.b	d0,d0																;D000
	move.b	d0,$002B(a5)														;1B40002B
adrCd006682:		; Memory Address ($6682) and binary offset [$62FE]
	rts																			;4E75

Click_OpenSpellBook:		; Memory Address ($6684) and binary offset [$6300]
	; Opens and composes the selected champion's spell-book interface page.
	bsr		Draw_ChampionNamePanelBackground									;61001BD2
	bsr		Prepare_AndDrawSpellBookSurface										;6100613E
	bsr.s	adrCd006670															;61E2
	bsr		adrCd00C85E															;610061CE
	move.w	#$0002,$0014(a5)													;3B7C00020014
adrCd006698:		; Memory Address ($6698) and binary offset [$6314]
	bsr		Draw_SpellPointValues												;61006178
	sub.w	#$02DC,a0															;90FC02DC
	move.b	$0013(a4),d0														;102C0013
	bpl.s	adrCd0066BE															;6A18
	bsr.s	adrCd0066B8															;6110
	moveq	#$68,d7																;7E68
adrCd0066AA:		; Memory Address ($66AA) and binary offset [$6326]
	move.w	d7,d0																;3007
	bsr		Draw_PocketGraphic													;6100643C
	addq.w	#$01,d7																;5247
	cmpi.w	#$006C,d7															;0C47006C
	bcs.s	adrCd0066AA															;65F2
adrCd0066B8:		; Memory Address ($66B8) and binary offset [$6334]
	moveq	#$4F,d0																;704F
	bra		Draw_PocketGraphic													;6000642E

adrCd0066BE:		; Memory Address ($66BE) and binary offset [$633A]
	bsr		Character_GetClassIndex												;61000240
	add.w	#$0064,d0															;06400064
	bsr		Draw_PocketGraphic													;61006422
	moveq	#$03,d7																;7E03
adrLp0066CC:		; Memory Address ($66CC) and binary offset [$6348]
	move.w	#$003B,d0															;303C003B
	bsr		Draw_PocketGraphic													;61006418
	dbra	d7,adrLp0066CC														;51CFFFF6
	move.b	$0013(a4),d0														;102C0013
	bsr		Character_GetClassIndex												;61000222
	add.w	#$0064,d0															;06400064
	bsr		Draw_PocketGraphic													;61006404
	moveq	#$00,d0																;7000
	move.b	$0013(a4),d0														;102C0013
	bsr		adrCd00C2D4															;61005BE4
	bsr		adrCd00CFBC															;610068C8
adrCd0066F6:		; Memory Address ($66F6) and binary offset [$6372]
	or.b	#$04,$0054(a5)														;002D00040054
	bsr		adrCd00688C															;6100018E
	lea		adrEA00EA36.l,a6													;4DF90000EA36
	bsr		Convert_ByteToDecimalText											;610067BC
	move.w	d1,$0010(a6)														;3D410010
	bsr		Print_fflim_text													;610069B6
adrCd006712:		; Memory Address ($6712) and binary offset [$638E]
	lea		adrEA00EA4C.l,a6													;4DF90000EA4C
	bsr		LowerText															;6100689E
	clr.b	$0057(a5)															;422D0057
adrCd006720:		; Memory Address ($6720) and binary offset [$639C]
	tst.b	$0057(a5)															;4A2D0057
	bmi.s	adrCd00675E															;6B38
	or.b	#$10,$0054(a5)														;002D00100054
	bsr		Calculate_SpellCastingQuality										;6100004A
	neg.b	d7																	;4407
	bpl.s	adrCd006736															;6A02
	moveq	#$00,d7																;7E00
adrCd006736:		; Memory Address ($6736) and binary offset [$63B2]
	cmpi.b	#$13,d7																;0C070013
	bcc.s	adrCd00675E															;6422
	move.b	adrB_006760(pc,d7.w),d0												;103B7022
	moveq	#$64,d1																;7264
	moveq	#$34,d2																;7434
	move.l	#$0004005A,d5														;2A3C0004005A	;Long Addr replaced with Symbol
	add.w	$0008(a5),d5														;DA6D0008
	move.l	#$0033009F,d4														;283C0033009F
	bsr		Scale_ValueToBarLength												;610019EE
	moveq	#$0C,d3																;760C
	bra		BW_draw_bar															;6000730C

adrCd00675E:		; Memory Address ($675E) and binary offset [$63DA]
	rts																			;4E75

adrB_006760:		; Memory Address ($6760) and binary offset [$63DC]
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

	bsr		Load_ChampionStatRecord												;6100FEEA
Calculate_SpellCastingQuality:		; Memory Address ($6778) and binary offset [$63F4]
	move.b	$0013(a4),d0														;102C0013
	bsr		Character_GetClassIndex												;61000182
	move.w	d0,-(sp)															;3F00
	move.l	a4,d0																;200C
	sub.l	#Character_Stats_DataTable,d0										;04800000EB2A
	lea		Character_Pockets_DataTable.l,a0									;41F90000ED2A
	lsr.w	#$01,d0																;E248
	add.w	d0,a0																;D0C0
	lsr.w	#$04,d0																;E848
	move.w	d0,d1																;3200
	bsr		Character_GetClassIndex												;61000166
	moveq	#$00,d7																;7E00
	cmp.w	(sp),d0																;B057
	bne.s	adrCd0067AC															;660A
	move.w	d1,d2																;3401
	and.w	#$0003,d2															;02420003
	move.b	SpellCasting_ProfessionBaseBonuses(pc,d2.w),d7						;1E3B203C
adrCd0067AC:		; Memory Address ($67AC) and binary offset [$6428]
	move.l	#adrL_007E22,a1														;227C00007E22
	add.l	a4,a1																;D3CC
	moveq	#$00,d6																;7C00
	move.b	$0013(a4),d6														;1C2C0013
	move.b	$00(a1,d6.w),d0														;10316000
	moveq	#$05,d2																;7405
	moveq	#$00,d3																;7600
	tst.w	d7																	;4A47
	bne.s	adrCd0067D8															;6612
	move.w	(sp),d4																;3817
	add.w	#$0057,d4															;06440057
	cmp.b	(a0),d4																;B810
	beq.s	adrCd0067D6															;6706
	cmp.b	$0001(a0),d4														;B8280001
	bne.s	adrCd0067E0															;660A
adrCd0067D6:		; Memory Address ($67D6) and binary offset [$6452]
	addq.b	#$03,d7																;5607
adrCd0067D8:		; Memory Address ($67D8) and binary offset [$6454]
	cmp.w	d2,d0																;B042
	bcs.s	adrCd0067EA															;650E
	addq.w	#$05,d7																;5A47
	sub.w	d2,d0																;9042
adrCd0067E0:		; Memory Address ($67E0) and binary offset [$645C]
	add.w	d2,d2																;D442
	addq.w	#$01,d3																;5243
	bra.s	adrCd0067D8															;60F2

SpellCasting_ProfessionBaseBonuses:		; Memory Address ($67E6) and binary offset [$6462]
	; Four profession-indexed casting bonuses used when the selected spell class
	; matches the champion profession.
	INCBIN "/data/BLOODWYCH439-clean/data/SpellCasting_ProfessionBaseBonuses.lookup"

adrCd0067EA:		; Memory Address ($67EA) and binary offset [$6466]
	lsr.w	d3,d0																;E668
	add.w	d0,d7																;DE40
	move.w	d1,d4																;3801
	bsr		Calculate_WizardLevelContribution									;6100A14C
	add.b	d0,d7																;DE00
	add.b	d0,d7																;DE00
	add.b	$0014(a4),d7														;DE2C0014
	move.w	d4,d0																;3004
	move.w	d6,d4																;3806
	bsr		Character_GetClassIndex												;610000FE
	move.w	d4,d6																;3C04
	cmp.w	(sp)+,d0															;B05F
	bne.s	adrCd00681A															;6610
	add.w	#$0057,d0															;06400057
	moveq	#$01,d1																;7201
	cmp.b	(a0),d0																;B010
	beq.s	Apply_PowerStaffSpellCastingBonus									;6708
	cmp.b	$0001(a0),d0														;B0280001
	beq.s	Apply_PowerStaffSpellCastingBonus									;6702
adrCd00681A:		; Memory Address ($681A) and binary offset [$6496]
	moveq	#$00,d1																;7200
Apply_PowerStaffSpellCastingBonus:		; Memory Address ($681C) and binary offset [$6498]
	move.b	$0015(a4),d0														;102C0015
	lsr.b	d1,d0																;E228
	sub.b	d0,d7																;9E00
	moveq	#PowerStaff_SpellCastingBonus,d0									;Spell-casting quality bonus supplied by a held Power Staff.
	cmp.b	#Object_PowerStaff,(a0)												;Power Staff object code.
	beq.s	adrCd006836															;670A
	cmp.b	#Object_PowerStaff,$0001(a0)										;Power Staff object code.
	beq.s	adrCd006836															;6702
	moveq	#$00,d0																;7000
adrCd006836:		; Memory Address ($6836) and binary offset [$64B2]
	add.b	d0,d7																;DE00
	sub.b	SpellCasting_SpellDifficultyPenalties(pc,d6.w),d7					;9E3B6004
	rts																			;4E75

SpellCasting_SpellDifficultyPenalties:		; Memory Address ($683E) and binary offset [$64BA]
	; Sixteen spell-indexed values subtracted from the calculated spell-casting
	; quality.
	INCBIN "/data/BLOODWYCH439-clean/data/SpellCasting_SpellDifficultyPenalties.lookup"
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
SpellCost_DataTable:		; Memory Address ($685E) and binary offset [$64DA]
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
adrB_00687E:		; Memory Address ($687E) and binary offset [$64FA]
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

adrCd00688C:		; Memory Address ($688C) and binary offset [$6508]
	move.l	a4,d0																;200C
	sub.l	#Character_Stats_DataTable,d0										;04800000EB2A
	lsr.w	#$01,d0																;E248
	lea		Character_Pockets_DataTable.l,a0									;41F90000ED2A
	add.w	d0,a0																;D0C0
	moveq	#$00,d0																;7000
	move.b	$0013(a4),d0														;102C0013
	bsr.s	Character_GetClassIndex												;615A
	add.w	#$0069,d0															;06400069
	cmp.b	(a0),d0																;B010
	beq.s	adrCd0068B4															;6706
	cmp.b	$0001(a0),d0														;B0280001
	bne.s	adrCd0068D0															;661C
adrCd0068B4:		; Memory Address ($68B4) and binary offset [$6530]
	sub.w	#$0069,d0															;04400069
	lea		RingUses.l,a0														;41F90000EE32
	tst.b	$00(a0,d0.w)														;4A300000
	bmi.s	adrCd0068D0															;6B0C
	moveq	#$00,d0																;7000
	move.b	d0,$0014(a4)														;19400014
	rts																			;4E75

adrCd0068CC:		; Memory Address ($68CC) and binary offset [$6548]
	subq.b	#$01,$0014(a4)														;532C0014
adrCd0068D0:		; Memory Address ($68D0) and binary offset [$654C]
	move.b	$0014(a4),d1														;122C0014
	ext.w	d1																	;4881
	bmi.s	adrCd0068DC															;6B04
	move.b	adrB_00687E(pc,d1.w),d1												;123B10A4
adrCd0068DC:		; Memory Address ($68DC) and binary offset [$6558]
	moveq	#$00,d0																;7000
	move.b	$0013(a4),d0														;102C0013
	lea		SpellCost_DataTable.w,a0											;41F8685E	;Short Absolute converted to symbol!
	move.b	$00(a0,d0.w),d0														;10300000
	addq.w	#$01,d0																;5240
	add.w	d0,d0																;D040
	add.w	d1,d0																;D041
	bne.s	adrCd0068F8															;6606
	addq.b	#$01,$0014(a4)														;522C0014
	moveq	#$01,d0																;7001
adrCd0068F8:		; Memory Address ($68F8) and binary offset [$6574]
	cmpi.w	#$0064,d0															;0C400064
	bcc.s	adrCd0068CC															;64CE
	rts																			;4E75

Character_GetClassIndex:		; Memory Address ($6900) and binary offset [$657C]
	; Converts a champion or character number into one of the four class indices.
	move.w	d0,d6																;3C00
	cmpi.b	#$10,d0																;0C000010
	bcs.s	Character_GetClassIndex_CombineBits									;6502
	not.w	d0																	;4640
Character_GetClassIndex_CombineBits:		; Memory Address ($690A) and binary offset [$6586]
	; Combines the character-number bit groups before applying the four-profession
	; mask.
	lsr.w	#$02,d0																;E448
	add.w	d6,d0																;D046
	and.w	#Character_ProfessionMask,d0										;Low two bits used to select one of the four character professions.
Return_CharacterOrHeldItemAction:		; Memory Address ($6912) and binary offset [$658E]
	; Shared return used by character-class calculation and rejected held-item
	; actions.
	rts																			;4E75

Click_Item_17_to_1A_Potions:		; Memory Address ($6914) and binary offset [$6590]
	; Dispatches held food, counted objects and potions; potions $17-$1A are
	; removed before applying their character-stat effect.
	move.w	HeldItem_ObjectCodeOffset(a5),d0									;Reads the currently held object code.
	beq.s	Return_CharacterOrHeldItemAction									;67F8
	cmpi.w	#Object_Armour_First,d0												;Exclusive upper boundary of the potion range.
	bcc.s	Return_CharacterOrHeldItemAction									;64F2
	cmpi.w	#Object_Potions_First,d0											;Separates potion objects from food and counted objects.
	bcs.s	Use_FoodOrCountedObject												;6574
	sub.w	#Object_Potions_First,d0											;Converts potion object code `$17-$1A` into lookup index `0-3`.
	move.w	d0,d1																;3200
	clr.l	HeldItem_StateOffset(a5)											;Consumes the complete held potion before applying its effect.
	move.b	$000F(a5),d0														;102D000F
	move.b	$18(a5,d0.w),d0														;10350018
	bsr		Load_ChampionStatRecord												;6100FD26
	lea		Potion_1_SerpentSlime.l,a0											;41F90000695A
	add.w	d1,d1																;D241
	add.w	Potion_LookupTable(pc,d1.w),a0										;D0FB100C
	jsr		(a0)																;4E90
	bsr		Draw_CompactStatsFrame												;610016AC
	bra		Refresh_HeldItemDisplay												;600002E4

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
	rts																			;4E75

Potion_3_DragonAle:		; Memory Address ($6962) and binary offset [$65DE]
	; Restores current vitality to the character's maximum vitality.
	move.b	ChampionStat_VitalityMaximum(a4),ChampionStat_VitalityCurrent(a4)	;Restores current vitality to maximum.
	rts																			;4E75

Potion_4_MoonElixir:		; Memory Address ($696A) and binary offset [$65E6]
	; Restores current spell points to maximum and clears the spell cooldown.
	move.b	ChampionStat_SpellPointsMaximum(a4),ChampionStat_SpellPointsCurrent(a4)	;Restores current spell points to maximum.
	clr.b	ChampionStat_SpellCooldown(a4)										;Moon Elixir clears spell cooldown.
	rts																			;4E75

Potion_2_BrimstoneBroth:		; Memory Address ($6976) and binary offset [$65F2]
	; Clears spell cooldown and restores half of each HP, vitality and spell-point
	; deficit, rounded upward.
	clr.b	ChampionStat_SpellCooldown(a4)										;Brimstone Broth clears spell cooldown.
	moveq	#ChampionStat_HitPointsCurrent,d4									;Selects the current/max hit-point pair for halfway restoration.
	bsr.s	Potion_2_RestoreStatHalfway											;6106
	moveq	#ChampionStat_VitalityCurrent,d4									;Selects the current/max vitality pair for halfway restoration.
	bsr.s	Potion_2_RestoreStatHalfway											;6102
	moveq	#ChampionStat_SpellPointsCurrent,d4									;Selects the current/max spell-point pair for halfway restoration.
Potion_2_RestoreStatHalfway:		; Memory Address ($6984) and binary offset [$6600]
	; Moves one current statistic halfway towards its following maximum-statistic
	; byte, rounding upward.
	move.b	$01(a4,d4.w),d0														;10344001
	sub.b	$00(a4,d4.w),d0														;90344000
	addq.b	#$01,d0																;5200
	lsr.b	#$01,d0																;E208
	add.b	$00(a4,d4.w),d0														;D0344000
	move.b	d0,$00(a4,d4.w)														;19804000
	rts																			;4E75

Use_FoodOrCountedObject:		; Memory Address ($699A) and binary offset [$6616]
	; Dispatches counted objects below $05, three-stage food $05-$13 and whole
	; N'Egg food $14-$16.
	cmpi.w	#Object_Food_First,d0												;Objects below `$05` use counted-object logic.
	bcs		Click_CountedObject													;65000076
	cmpi.w	#Object_Neggs_First,d0												;Separates three-stage food from whole N'Egg food.
	bcs.s	Click_PortionedFood													;6512
	moveq	#$00,d1																;7200
	sub.w	#Object_Neggs_First,d0												;Converts N'Egg object code to whole-food size index.
WholeFood_AddValueLoop:		; Memory Address ($69AE) and binary offset [$662A]
	; Adds one $42 food-value step for each N'Egg size before consuming it
	; completely.
	add.w	#Food_WholeValueStep,d1												;Adds one food-value step for each N'Egg size.
	dbra	d0,WholeFood_AddValueLoop											;51C8FFFA
	moveq	#$00,d0																;7000
	bra.s	ConsumeFood_StoreRemainingObject									;601A

Click_PortionedFood:		; Memory Address ($69BA) and binary offset [$6636]
	; Consumes one third of food or drink, selects its food-value increase and
	; resolves the remaining object stage.
	moveq	#Food_DrinkPortionValue,d1											;Default portion value for Mead and Water.
	cmpi.w	#Object_Drinks_First,d0												;Separates solid-food portions from drink portions.
	bcc.s	PortionedFood_SelectNextObject										;6402
	moveq	#Food_SolidPortionValue,d1											;Selects the larger solid-food portion value.
PortionedFood_SelectNextObject:		; Memory Address ($69C4) and binary offset [$6640]
	; Starts resolution of the previous portion graphic or the empty-object result.
	move.w	d0,d2																;3400
	subq.w	#Object_Food_First,d0												;Normalises the portioned-food object code to a zero-based group offset.
	beq.s	ConsumeFood_StoreRemainingObject									;670A
PortionedFood_FindGroupStartLoop:		; Memory Address ($69CA) and binary offset [$6646]
	; Tests three-object portion groups; each group start becomes empty and other
	; stages decrement.
	subq.w	#Food_PortionGroupSize,d0											;Finds whether the selected object is the first stage of a three-object food group.
	beq.s	ConsumeFood_StoreRemainingObject									;6706
	bcc.s	PortionedFood_FindGroupStartLoop									;64FA
	move.w	d2,d0																;3002
	subq.w	#$01,d0																;5340
ConsumeFood_StoreRemainingObject:		; Memory Address ($69D4) and binary offset [$6650]
	; Stores the remaining portion object, or $00 when the food has been completely
	; consumed.
	move.w	d0,HeldItem_ObjectCodeOffset(a5)									;Stores the decremented portion or empty object code.
	move.b	$000F(a5),d0														;102D000F
	move.b	$18(a5,d0.w),d0														;10350018
	bsr		Load_ChampionStatRecord												;6100FC7E
	add.b	ChampionStat_FoodLevel(a4),d1										;Adds the consumed food value to the character's current food level.
	bcs.s	ConsumeFood_ClampLevel												;6506
	cmpi.w	#Food_LevelLimitExclusive,d1										;Tests whether food level must be clamped.
	bcs.s	ConsumeFood_StoreLevel												;6504
ConsumeFood_ClampLevel:		; Memory Address ($69F0) and binary offset [$666C]
	; Clamps food level to $C7 when addition carries or reaches the exclusive $C8
	; limit.
	move.b	#Food_LevelMaximum,d1												;Clamps food level to its maximum.
ConsumeFood_StoreLevel:		; Memory Address ($69F4) and binary offset [$6670]
	; Stores the updated food level and redraws the remaining held object.
	move.b	d1,ChampionStat_FoodLevel(a4)										;Stores the updated food level.
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$0B64,a0															;D0FC0B64
	add.w	$000A(a5),a0														;D0ED000A
	move.w	HeldItem_ObjectCodeOffset(a5),d0									;Offset of the currently held object code in the interface state.
	bsr		ObjectGraphic														;6100605A
	bsr		Draw_SelectedInventorySlotFrame										;6100030E
	bra		Draw_FoodLevelBar													;60000288

Click_CountedObject:		; Memory Address ($6A16) and binary offset [$6692]
	; Transfers one counted coin, key or arrow between the character count table
	; and the held stack.
	moveq	#$00,d7																;7E00
	move.b	$000F(a5),d7														;1E2D000F
	move.b	$18(a5,d7.w),d7														;1E357018
	asl.b	#$04,d7																;E907
	lea		Character_Pockets_DataTable.l,a6									;4DF90000ED2A
	add.w	d7,a6																;DCC7
	subq.b	#$01,$0B(a6,d0.w)													;5336000B
	bcc.s	Stack_ObjectFromInventory											;6406
Cancel_CountedObjectTransfer:		; Memory Address ($6A30) and binary offset [$66AC]
	; Restores a counted-object quantity when the transfer cannot proceed.
	addq.b	#$01,$0B(a6,d0.w)													;5236000B
	rts																			;4E75

Stack_ObjectFromInventory:		; Memory Address ($6A36) and binary offset [$66B2]
	; Transfers one counted object from the champion count table to the held stack,
	; provided the held quantity is below $63.
	cmp.w	#Object_StackMaximum,HeldItem_QuantityOffset(a5)					;Offset of the held-object quantity word.
	bcc.s	Cancel_CountedObjectTransfer										;64F2
	addq.w	#$01,HeldItem_QuantityOffset(a5)									;Offset of the held-object quantity word.
	bra		Redraw_Inventory													;600001C6

Click_ObjectInInventory:		; Memory Address ($6A46) and binary offset [$66C2]
	; Handles inventory-slot selection, counted stacks, armour restrictions, worn
	; hand armour and held-object swapping.
	moveq	#$00,d7																;7E00
	move.b	$000E(a5),d7														;1E2D000E
	moveq	#$00,d0																;7000
	move.b	$18(a5,d7.w),d0														;10357018
	move.w	d0,d2																;3400
	and.w	#$000F,d2															;0242000F
	asl.b	#$04,d0																;E900
	lea		Character_Pockets_DataTable.l,a6									;4DF90000ED2A
	add.w	d0,a6																;DCC0
	lea		Character_Stats_DataTable.l,a4										;49F90000EB2A
	add.w	d0,d0																;D040
	add.w	d0,a4																;D8C0
	moveq	#$00,d0																;7000
	move.b	$000F(a5),d0														;102D000F
	move.w	HeldItem_ObjectCodeOffset(a5),d1									;Offset of the currently held object code in the interface state.
	beq.s	Check_BodyArmourInventorySlot										;6720
	cmpi.b	#ChampionPocket_Shield,d0											;Offset of the dedicated shield pocket.
	bne.s	Check_BodyArmourInventorySlot										;661A
	cmpi.w	#Object_SmallShields_First,d1										;First small-shield object and exclusive end of body armour.
	bcs.s	Reject_InventorySlotAction											;652A
	cmpi.w	#Object_Gloves_First,d1												;First glove object and exclusive end of all shields.
	bcc.s	Reject_InventorySlotAction											;6424
	btst	#$00,d2																;08020000
	beq.s	Handle_SelectedPocketObject											;6762
	cmpi.w	#Object_LargeShields_First,d1										;First large-shield object.
	bcs.s	Handle_SelectedPocketObject											;655C
	bra.s	Reject_InventorySlotAction											;6016

Check_BodyArmourInventorySlot:		; Memory Address ($6A98) and binary offset [$6714]
	; Allows only body-armour objects $1B-$23 in the dedicated body-armour slot.
	cmpi.b	#ChampionPocket_BodyArmour,d0										;Offset of the dedicated body-armour pocket.
	bne.s	Check_WornHandArmourSlot											;6616
	tst.w	d1																	;4A41
	beq.s	Handle_SelectedPocketObject											;6750
	cmpi.w	#Object_Armour_First,d1												;First body-armour object and exclusive end of potions.
	bcs.s	Reject_InventorySlotAction											;6506
	cmpi.w	#Object_SmallShields_First,d1										;First small-shield object and exclusive end of body armour.
	bcs.s	Handle_SelectedPocketObject											;6544
Reject_InventorySlotAction:		; Memory Address ($6AAE) and binary offset [$672A]
	; Leaves the objects unchanged, selects the clicked inventory slot and returns.
	move.w	d7,$000E(a5)														;3B47000E
	rts																			;4E75

Check_WornHandArmourSlot:		; Memory Address ($6AB4) and binary offset [$6730]
	; Handles Chaos Gloves and other worn hand-armour exchanges involving the two
	; hand pockets.
	bcc.s	Handle_SelectedPocketObject											;643C
	cmp.w	#Object_Gloves_First,HeldItem_ObjectCodeOffset(a5)					;Offset of the currently held object code in the interface state.
	bcs.s	Unequip_WornHandArmourToEmptyHand									;651E
	cmp.w	#Object_Blades_First,HeldItem_ObjectCodeOffset(a5)					;Offset of the currently held object code in the interface state.
	bcc.s	Unequip_WornHandArmourToEmptyHand									;6416
	move.b	ChampionStat_WornHandArmour(a4),d1									;Offset of the worn hand-armour object in a champion-stat record.
	move.b	HeldItem_ObjectCodeByteOffset(a5),ChampionStat_WornHandArmour(a4)	;Offset of the low byte of the held object code.
	move.b	d1,HeldItem_ObjectCodeByteOffset(a5)								;Offset of the low byte of the held object code.
	bne.s	Handle_SelectedPocketObject											;661C
	clr.w	HeldItem_QuantityOffset(a5)											;Offset of the held-object quantity word.
	bra.s	Handle_SelectedPocketObject											;6016

Unequip_WornHandArmourToEmptyHand:		; Memory Address ($6ADC) and binary offset [$6758]
	; Moves worn hand armour into an empty hand pocket when no object is currently
	; held.
	tst.b	$00(a6,d0.w)														;4A360000
	bne.s	Handle_SelectedPocketObject											;6610
	tst.w	HeldItem_ObjectCodeOffset(a5)										;Offset of the currently held object code in the interface state.
	bne.s	Handle_SelectedPocketObject											;660A
	move.b	ChampionStat_WornHandArmour(a4),$00(a6,d0.w)						;Offset of the worn hand-armour object in a champion-stat record.
	clr.b	ChampionStat_WornHandArmour(a4)										;Offset of the worn hand-armour object in a champion-stat record.
Handle_SelectedPocketObject:		; Memory Address ($6AF2) and binary offset [$676E]
	; Processes the object in the selected champion pocket, including
	; counted-object pickup, merging and ordinary held-object swapping.
	moveq	#$00,d1																;7200
	move.b	$00(a6,d0.w),d1														;12360000
	beq		Return_HeldCountedObjectToInventory									;67000088
	cmpi.w	#Object_Food_First,d1												;First food object and exclusive end of counted objects.
	bcc		Return_HeldCountedObjectToInventory									;64000080
	move.w	HeldItem_ObjectCodeOffset(a5),d3									;Offset of the currently held object code in the interface state.
	bne.s	Swap_HeldObjectForCountedStack										;6612
	move.w	d1,HeldItem_ObjectCodeOffset(a5)									;Offset of the currently held object code in the interface state.
	move.w	#$0001,HeldItem_QuantityOffset(a5)									;Offset of the held-object quantity word.
	subq.b	#$01,$0B(a6,d1.w)													;5336100B
	bra		Refresh_InventoryAfterObjectChange									;6000009E

Swap_HeldObjectForCountedStack:		; Memory Address ($6B1C) and binary offset [$6798]
	; Picks up a complete counted-object stack while placing the previously held
	; non-counted object into the pocket.
	cmpi.w	#Object_Food_First,d3												;First food object and exclusive end of counted objects.
	bcs.s	Merge_MatchingCountedObjectStack									;650E
	move.b	ChampionPocket_CountedObjectCountsOffset(a6,d1.w),HeldItem_QuantityByteOffset(a5)	;Offset of the low byte of the held-object quantity.
	clr.b	$0B(a6,d1.w)														;4236100B
	bra		Swap_HeldObjectWithPocket											;60000082

Merge_MatchingCountedObjectStack:		; Memory Address ($6B30) and binary offset [$67AC]
	; Merges held and inventory quantities when both represent the same counted
	; object.
	cmp.w	d1,d3																;B641
	bne.s	Merge_DifferentCountedObjectStack									;6620
	move.b	$0B(a6,d1.w),d2														;1436100B
	add.b	HeldItem_QuantityByteOffset(a5),d2									;Offset of the low byte of the held-object quantity.
	move.b	d2,$0B(a6,d1.w)														;1D82100B
	cmpi.b	#Object_StackLimitExclusive,d2										;Exclusive counted-object quantity limit.
	bcc.s	Clamp_MatchingCountedObjectStack									;6406
	clr.l	HeldItem_StateOffset(a5)											;Offset of the complete four-byte held-item state.
	bra.s	Refresh_InventoryAfterObjectChange									;606C

Clamp_MatchingCountedObjectStack:		; Memory Address ($6B4C) and binary offset [$67C8]
	; Clamps the merged inventory quantity to $63.
	move.b	#Object_StackMaximum,ChampionPocket_CountedObjectCountsOffset(a6,d1.w)	;Highest stored quantity for a counted object.
	bra.s	Store_CountedObjectRemainder										;6024

Merge_DifferentCountedObjectStack:		; Memory Address ($6B54) and binary offset [$67D0]
	; Adds the held quantity to its existing global count before picking up a
	; different counted stack.
	move.b	$0B(a6,d3.w),d2														;1436300B
	add.b	HeldItem_QuantityByteOffset(a5),d2									;Offset of the low byte of the held-object quantity.
	cmpi.b	#Object_StackLimitExclusive,d2										;Exclusive counted-object quantity limit.
	bcc.s	Clamp_CountedObjectStack											;6410
	move.b	d2,$0B(a6,d3.w)														;1D82300B
	move.b	ChampionPocket_CountedObjectCountsOffset(a6,d1.w),HeldItem_QuantityByteOffset(a5)	;Offset of the low byte of the held-object quantity.
	clr.b	$0B(a6,d1.w)														;4236100B
	bra.s	Remove_DuplicateCountedObjectSlots									;602E

Clamp_CountedObjectStack:		; Memory Address ($6B72) and binary offset [$67EE]
	; Clamps a counted-object total to $63 before retaining the excess.
	move.b	#Object_StackMaximum,ChampionPocket_CountedObjectCountsOffset(a6,d3.w)	;Highest stored quantity for a counted object.
Store_CountedObjectRemainder:		; Memory Address ($6B78) and binary offset [$67F4]
	; Stores quantity remaining above the $63 inventory-count limit in the held
	; stack.
	sub.b	#Object_StackMaximum,d2												;Highest stored quantity for a counted object.
	move.b	d2,HeldItem_QuantityByteOffset(a5)									;Offset of the low byte of the held-object quantity.
	bra.s	Refresh_InventoryAfterObjectChange									;6036

Return_HeldCountedObjectToInventory:		; Memory Address ($6B82) and binary offset [$67FE]
	; Returns a held counted stack to its global character count.
	move.w	HeldItem_ObjectCodeOffset(a5),d3									;Offset of the currently held object code in the interface state.
	beq.s	Swap_HeldObjectWithPocket											;6728
	cmpi.w	#Object_Food_First,d3												;First food object and exclusive end of counted objects.
	bcc.s	Swap_HeldObjectWithPocket											;6422
	move.b	$0B(a6,d3.w),d2														;1436300B
	add.b	HeldItem_QuantityByteOffset(a5),d2									;Offset of the low byte of the held-object quantity.
	move.b	d2,$0B(a6,d3.w)														;1D82300B
	cmpi.b	#Object_StackLimitExclusive,d2										;Exclusive counted-object quantity limit.
	bcc.s	Clamp_CountedObjectStack											;64D2
Remove_DuplicateCountedObjectSlots:		; Memory Address ($6BA0) and binary offset [$681C]
	; Removes redundant pocket entries for a counted object after returning its
	; quantity.
	moveq	#ChampionPocket_LastIndex,d2										;Highest ordinary pocket index in the twelve-pocket scan.
Remove_DuplicateCountedObjectSlots_Loop:		; Memory Address ($6BA2) and binary offset [$681E]
	; Scans all twelve character pockets for duplicate counted-object codes.
	cmp.b	$00(a6,d2.w),d3														;B6362000
	bne.s	Remove_DuplicateCountedObjectSlots_Next								;6604
	clr.b	$00(a6,d2.w)														;42362000
Remove_DuplicateCountedObjectSlots_Next:		; Memory Address ($6BAC) and binary offset [$6828]
	; Advances the duplicate counted-object pocket scan.
	dbra	d2,Remove_DuplicateCountedObjectSlots_Loop							;51CAFFF4
Swap_HeldObjectWithPocket:		; Memory Address ($6BB0) and binary offset [$682C]
	; Stores the previous held object in the selected pocket and makes the pocket
	; object the new held object.
	move.b	d3,$00(a6,d0.w)														;1D830000
	move.w	d1,HeldItem_ObjectCodeOffset(a5)									;Offset of the currently held object code in the interface state.
Refresh_InventoryAfterObjectChange:		; Memory Address ($6BB8) and binary offset [$6834]
	; Refreshes selection and inventory graphics after an object transfer.
	cmp.b	#$02,$000F(a5)														;0C2D0002000F
	bne.s	Finalize_InventoryObjectChange										;6618
	btst	d7,$003E(a5)														;0F2D003E
	beq.s	Finalize_InventoryObjectChange										;6712
	move.w	d7,-(sp)															;3F07
	bsr		Refresh_PartyShieldSlotIfDirty										;61001326
	tst.w	$0002(sp)															;4A6F0002
	beq.s	Restore_SelectedInventorySlot										;6704
	bsr		Draw_PartyShieldChainStrip											;610012FE
Restore_SelectedInventorySlot:		; Memory Address ($6BD6) and binary offset [$6852]
	; Restores the selected slot number after auxiliary inventory handling.
	move.w	(sp)+,d7															;3E1F
Finalize_InventoryObjectChange:		; Memory Address ($6BD8) and binary offset [$6854]
	; Normalises held counted-object state and redraws the inventory.
	move.w	d7,$000E(a5)														;3B47000E
	move.w	HeldItem_ObjectCodeOffset(a5),d0									;Offset of the currently held object code in the interface state.
	beq.s	Normalize_HeldNonCountedObjectQuantity								;6706
	cmpi.w	#Object_Food_First,d0												;First food object and exclusive end of counted objects.
	bcs.s	Redraw_Inventory													;6522
Normalize_HeldNonCountedObjectQuantity:		; Memory Address ($6BE8) and binary offset [$6864]
	; Sets the held quantity to one when the resulting held state is empty or
	; contains a non-counted object.
	move.w	#$0001,HeldItem_QuantityOffset(a5)									;Offset of the held-object quantity word.
	bra.s	Redraw_Inventory													;601A

Click_OpenInventory:		; Memory Address ($6BF0) and binary offset [$686C]
	clr.w	$000E(a5)															;426D000E
	move.l	#$005E00E1,d4														;283C005E00E1
	move.l	#$00070040,d5														;2A3C00070040
	add.w	$0008(a5),d5														;DA6D0008
	moveq	#$03,d3																;7603
	bsr		BW_draw_bar															;61006E60
Redraw_Inventory:		; Memory Address ($6C0A) and binary offset [$6886]
	move.w	$000E(a5),d7														;3E2D000E
	move.b	$18(a5,d7.w),d7														;1E357018
	and.w	#$000F,d7															;0247000F
	bsr		Draw_InventoryPocketSlots											;61005DA4
	move.l	#$000D0003,adrW_00D92A.l											;23FC000D00030000D92A
	bsr		adrCd00C984															;61005D5E
	move.w	d7,d0																;3007
	bsr		adrCd00CF08															;610062DC
	move.w	#$0003,$0014(a5)													;3B7C00030014
Refresh_HeldItemDisplay:		; Memory Address ($6C34) and binary offset [$68B0]
	; Updates the held-item description, graphic, quantity and optional food bar.
	bsr		Draw_HeldObjectDescription											;6100009C
	cmp.b	#$03,$0015(a5)														;0C2D00030015
	bne		Trigger_00_t00_Null													;660003D6
Draw_HeldItemPanel:		; Memory Address ($6C42) and binary offset [$68BE]
	; Draws the held-item panel pieces followed by the held object's pocket graphic
	; and quantity.
	or.b	#$04,$0054(a5)														;002D00040054
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$0B5C,a0															;D0FC0B5C
	add.w	$000A(a5),a0														;D0ED000A
	moveq	#$00,d7																;7E00
Draw_HeldItemPanelPieces_Loop:		; Memory Address ($6C58) and binary offset [$68D4]
	; Draws the four fixed decorative pieces surrounding the held-item graphic.
	bsr		adrCd008416															;610017BC
	addq.w	#$01,d7																;5247
	cmpi.w	#$0004,d7															;0C470004
	bcs.s	Draw_HeldItemPanelPieces_Loop										;65F4
	move.w	HeldItem_ObjectCodeOffset(a5),d0									;Offset of the currently held object code in the interface state.
	move.w	HeldItem_QuantityOffset(a5),d1										;Offset of the held-object quantity word.
	bsr		ObjectGraphic														;61005DF8
	move.w	$0012(a5),d3														;362D0012
	moveq	#$74,d0																;7074
	bsr		Draw_PocketGraphic													;61005E72
	bsr		Draw_SelectedInventorySlotFrame										;610000A2
	move.w	HeldItem_ObjectCodeOffset(a5),d0									;Offset of the currently held object code in the interface state.
	beq.s	Return_FromHeldItemDisplay											;670C
	cmpi.w	#Object_Food_First,d0												;First food object and exclusive end of counted objects.
	bcs.s	Return_FromHeldItemDisplay											;6506
	cmpi.w	#Object_Potions_First,d0											;First potion object and exclusive end of food.
	bcs.s	Draw_FoodStatus														;6502
Return_FromHeldItemDisplay:		; Memory Address ($6C90) and binary offset [$690C]
	; Returns when the held item does not require the food-status display.
	rts																			;4E75

Draw_FoodStatus:		; Memory Address ($6C92) and binary offset [$690E]
	; Draws the FOOD label and the food-level bar scaled against the $00-$C7 food
	; value.
	lea		adrEA00E998.l,a6													;4DF90000E998
	bsr		Print_fflim_text													;6100642C
Draw_FoodLevelBar:		; Memory Address ($6C9C) and binary offset [$6918]
	; Reads champion food byte $10 and draws its bar scaled from $00 to $C7.
	or.b	#$14,$0054(a5)														;002D00140054
	move.w	$000E(a5),d0														;302D000E
	move.b	$18(a5,d0.w),d0														;10350018
	bsr		Load_ChampionStatRecord												;6100F9B4
	move.b	ChampionStat_FoodLevel(a4),d0										;Offset of food level in a character-stat record.
	move.w	#Food_LevelMaximum,d1												;Highest stored character food level.
	moveq	#$3A,d2																;743A
	move.l	#$0004005A,d5														;2A3C0004005A	;Long Addr replaced with Symbol
	add.w	$0008(a5),d5														;DA6D0008
	move.l	#$00390098,d4														;283C00390098
	bsr		Scale_ValueToBarLength												;6100147A
	moveq	#$09,d3																;7609
	bra		BW_draw_bar															;60006D98

Draw_HeldObjectDescription:		; Memory Address ($6CD2) and binary offset [$694E]
	; Prints an empty description or prepares the selected held object's
	; description.
	move.w	HeldItem_ObjectCodeOffset(a5),d0									;Offset of the currently held object code in the interface state.
	bne.s	Prepare_HeldObjectDescription										;660A
	lea		NullString.l,a6														;4DF90000CAE9
	bra		LowerText															;600062D8

Prepare_HeldObjectDescription:		; Memory Address ($6CE2) and binary offset [$695E]
	; Handles champion-remains ownership before resolving and printing the held
	; object's description.
	move.w	d0,d1																;3200
	sub.w	#Object_Remains_First,d1											;First champion-remains object.
	bcs.s	Resolve_HeldObjectDescription										;651E
	cmpi.w	#Champion_Count,d1													;Number of standard champions and champion-remains objects.
	bcc.s	Resolve_HeldObjectDescription										;6418
	move.w	d1,d0																;3001
	bsr		adrCd004078															;6100D384
	move.w	HeldItem_ObjectCodeOffset(a5),d0									;Offset of the currently held object code in the interface state.
	tst.w	d1																	;4A41
	bmi.s	Resolve_HeldObjectDescription										;6B0A
	bclr	#$05,$18(a5,d1.w)													;08B500051018
	clr.l	HeldItem_StateOffset(a5)											;Offset of the complete four-byte held-item state.
Resolve_HeldObjectDescription:		; Memory Address ($6D08) and binary offset [$6984]
	; Resolves the normal object-definition text after optional champion-remains
	; ownership handling.
	lea		Object_Definition_Table+$02.l,a6									;4DF90000E4C4
	asl.w	#$02,d0																;E540
	add.w	d0,a6																;DCC0
	move.w	#$0006,adrW_00D92A.l												;33FC00060000D92A
	bra		Print_item_desc_fresh												;60006AE2

Draw_SelectedInventorySlotFrame:		; Memory Address ($6D1E) and binary offset [$699A]
	; Draws the highlight frame around the selected character inventory slot.
	moveq	#$0D,d3																;760D
	move.l	#$000E0049,d5														;2A3C000E0049
	add.w	$0008(a5),d5														;DA6D0008
	moveq	#$0F,d4																;780F
	swap	d4																	;4844
	move.b	$000F(a5),d4														;182D000F
	asl.w	#$04,d4																;E944
	add.w	#$00E1,d4															;064400E1
	bra		BW_draw_frame														;60006D9A

adrCd006D3C:		; Memory Address ($6D3C) and binary offset [$69B8]
	subq.b	#$01,$0055(a5)														;532D0055
	bpl.s	adrCd006D44															;6A02
adrCd006D42:		; Memory Address ($6D42) and binary offset [$69BE]
	rts																			;4E75

adrCd006D44:		; Memory Address ($6D44) and binary offset [$69C0]
	tst.b	$0015(a5)															;4A2D0015
	bne.s	adrCd006D42															;66F8
	or.b	#$04,$0054(a5)														;002D00040054
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	$000A(a5),a0														;D0ED000A
	add.w	#$097C,a0															;D0FC097C
	lea		GFX_Pockets+$6A60.l,a1												;43F900053162
	btst	#$00,(a5)															;08150000
	bne.s	adrCd006D6E															;6604
	lea		$0020(a1),a1														;43E90020
adrCd006D6E:		; Memory Address ($6D6E) and binary offset [$69EA]
	move.l	#$00020016,d5														;2A3C00020016	;Long Addr replaced with Symbol
	move.l	#$00000088,a3														;267C00000088
	bra		Draw_PlanarGraphic													;60005F3C

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
	tst.b	$0015(a5)															;4A2D0015
	bne		adrCd004C3E															;6600DE96
	or.b	#$04,$0054(a5)														;002D00040054
	move.b	#$81,$0055(a5)														;1B7C00810055
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	$000A(a5),a0														;D0ED000A
	add.w	#$08DC,a0															;D0FC08DC
	add.w	d0,d0																;D040
	add.w	Arrow_Highlights_X_Positions(pc,d0.w),a0							;D0FB00C2
	lea		GFX_ButtonHighlights.l,a1											;43F900018EFE
	add.w	Arrow_Highlights_Y_Offsets(pc,d0.w),a1								;D2FB00AC
	moveq	#$00,d5																;7A00
	moveq	#$00,d3																;7600
	move.b	Arrow_Highlights_Offsets(pc,d0.w),d5								;1A3B00BC
	move.b	d5,d3																;1605
	swap	d5																	;4845
	move.b	Arrow_Highlights_Offsets+$01(pc,d0.w),d5							;1A3B00B5
	addq.w	#$01,d3																;5243
	add.w	d3,d3																;D643
	swap	d3																	;4843
	bra		Draw_WallSprite_Normal												;600047DE

Click_MoveForwards:		; Memory Address ($6DEE) and binary offset [$6A6A]
	moveq	#$00,d0																;7000
	bra.s	_MoveParty															;600A

Click_MoveBackwards:		; Memory Address ($6DF2) and binary offset [$6A6E]
	moveq	#$02,d0																;7002
	bra.s	_MoveParty															;6006

Click_MoveLeft:		; Memory Address ($6DF6) and binary offset [$6A72]
	moveq	#$03,d0																;7003
	bra.s	_MoveParty															;6002

Click_MoveRight:		; Memory Address ($6DFA) and binary offset [$6A76]
	moveq	#$01,d0																;7001
_MoveParty:		; Memory Address ($6DFC) and binary offset [$6A78]
	and.b	#$01,(a5)															;02150001
	move.w	d0,-(sp)															;3F00
	bsr.s	Draw_Arrow_Highlights												;619E
	move.w	(sp)+,d6															;3C1F
	move.l	$001C(a5),d7														;2E2D001C
	add.w	$0020(a5),d6														;DC6D0020
	and.w	#$0003,d6															;02460003
	bsr		Compute_NewMapIndex_AI_TBC											;61000C30
	bcc		Check_Collision_AI_TBC												;64000026
	cmp.w	d0,d2																;B440
	bne.s	_MoveFailed															;661E
	move.w	$00(a6,d0.w),d1														;32360000
	and.w	#$0007,d1															;02410007
	cmpi.w	#$0004,d1															;0C410004
	bne.s	_MoveFailed															;6610
	move.b	$00(a6,d0.w),d1														;12360000
	lsr.b	#$01,d1																;E209
	eor.b	#$02,d1																;0A010002
	cmp.b	d1,d6																;BC01
	beq		Execute_StairTransition_AI_TBC										;67000096
_MoveFailed:		; Memory Address ($6E3C) and binary offset [$6AB8]
	rts																			;4E75

Check_Collision_AI_TBC:		; Memory Address ($6E3E) and binary offset [$6ABA]
	move.w	$00(a6,d0.w),d1														;32360000
	and.w	#$0007,d1															;02410007
	subq.w	#$06,d1																;5D41
	bcs.s	Start_StairTransition_AI_TBC										;655E
	beq.s	Begin_StairCondition_AI_TBC											;6744
	move.b	$00(a6,d0.w),d1														;12360000
	move.w	d1,d2																;3401
	and.w	#$0003,d2															;02420003
	subq.w	#$01,d2																;5342
	bne.s	Start_StairTransition_AI_TBC										;664E
	move.l	d7,$001C(a5)														;2B47001C
	movem.w	d0/d1,-(sp)															;48A7C000
	moveq	#$05,d1																;7205
	bsr		adrCd005500															;6100E69A
	movem.w	(sp)+,d0/d1															;4C9F0003
	tst.w	d3																	;4A43
	bpl.s	_MoveFailed															;6ACC
	lsr.b	#$02,d1																;E409
	move.w	d1,d7																;3E01
	movem.l	d0/a6,-(sp)															;48E78002
	bsr		adrCd001E42															;6100AFC8
	movem.l	(sp)+,d0/a6															;4CDF4001
	move.l	a5,-(sp)															;2F0D
	move.l	a5,a1																;224D
	clr.w	adrW_0020F4.w														;427820F4	;Short Absolute converted to symbol!
	bsr		adrCd00248C															;6100B602
	move.l	(sp)+,a5															;2A5F
	rts																			;4E75

Begin_StairCondition_AI_TBC:		; Memory Address ($6E90) and binary offset [$6B0C]
	move.b	$00(a6,d0.w),d1														;12360000
	and.w	#$0003,d1															;02410003
	bne.s	Save_State_For_Stair_AI_TBC											;6606
	bsr		TeamAvatar_LoopStart_AI_TBC											;610000E4
	bra.s	Start_StairTransition_AI_TBC										;6008

Save_State_For_Stair_AI_TBC:		; Memory Address ($6EA0) and binary offset [$6B1C]
	subq.w	#$01,d1																;5341
	beq.s	Start_StairTransition_AI_TBC										;6704
	bsr		Reset_TriggerWait_AI_TBC											;61000104
Start_StairTransition_AI_TBC:		; Memory Address ($6EA8) and binary offset [$6B24]
	movem.l	d0/d7/a6,-(sp)														;48E78102
	bsr		Load_MapPosition_AI_TBC												;61001320
	movem.l	(sp)+,d0/d7/a6														;4CDF4081
	move.w	$00(a6,d0.w),d1														;32360000
	and.w	#$0007,d1															;02410007
	cmpi.w	#$0004,d1															;0C410004
	bne		Store_PlayerXY_AI_TBC												;66000076
	moveq	#$00,d6																;7C00
	move.b	$00(a6,d0.w),d6														;1C360000
	lsr.b	#$01,d6																;E20E
	eor.b	#$02,d6																;0A060002
Execute_StairTransition_AI_TBC:		; Memory Address ($6ED0) and binary offset [$6B4C]
	bclr	#$07,$01(a6,d0.w)													;08B600070001
	move.w	$0058(a5),d2														;342D0058
	move.w	d2,d1																;3202
	addq.w	#$01,d1																;5241
	btst	#$00,$00(a6,d0.w)													;083600000000
	beq.s	Continue_StairTransition_AI_TBC										;6702
	subq.w	#$02,d1																;5541
Continue_StairTransition_AI_TBC:		; Memory Address ($6EE8) and binary offset [$6B64]
	bsr		adrCd0084BA															;610015D0
	move.w	d1,d0																;3001
	bsr		adrCd0084DA															;610015EA
	lea		MovementOffsetTable.w,a0											;41F85794	;Short Absolute converted to symbol!
	add.b	$08(a0,d6.w),d7														;DE306008
	add.b	$08(a0,d6.w),d7														;DE306008
	swap	d7																	;4847
	add.b	$00(a0,d6.w),d7														;DE306000
	add.b	$00(a0,d6.w),d7														;DE306000
	swap	d7																	;4847
	bsr		CoordToMap															;61001590
	tst.b	$01(a6,d0.w)														;4A360001
	bpl.s	Update_StairCompletion_AI_TBC										;6A10
	bsr		adrCd0084D6															;610015C0
	bsr		adrCd008498															;6100157E
	bset	#$07,$01(a6,d0.w)													;08F600070001
	rts																			;4E75

Update_StairCompletion_AI_TBC:		; Memory Address ($6F24) and binary offset [$6BA0]
	move.w	d1,$0058(a5)														;3B410058
	bset	#$07,$01(a6,d0.w)													;08F600070001
	move.b	$00(a6,d0.w),d0														;10360000
	lsr.b	#$01,d0																;E208
	move.b	d0,$0021(a5)														;1B400021
Store_PlayerXY_AI_TBC:		; Memory Address ($6F38) and binary offset [$6BB4]
	move.l	d7,$001C(a5)														;2B47001C
	tst.b	$003E(a5)															;4A2D003E
	beq.s	Check_TeamPad_AI_TBC												;6708
	clr.b	$003E(a5)															;422D003E
	bsr		Draw_PartyCommandInterface											;61000C08
Check_TeamPad_AI_TBC:		; Memory Address ($6F4A) and binary offset [$6BC6]
	move.w	$0042(a5),d0														;302D0042
	bmi.s	After_TeamPad_AI_TBC												;6B08
	cmpi.w	#$0008,d0															;0C400008
	bcc		Click_ShowTeamAvatars												;6400C388
After_TeamPad_AI_TBC:		; Memory Address ($6F58) and binary offset [$6BD4]
	rts																			;4E75

Click_RotateLeft:		; Memory Address ($6F5A) and binary offset [$6BD6]
	subq.w	#$01,$0020(a5)														;536D0020
	and.w	#$0003,$0020(a5)													;026D00030020
	moveq	#$04,d0																;7004
	bra.s	Execute_Rotation													;600C

Click_RotateRight:		; Memory Address ($6F68) and binary offset [$6BE4]
	addq.w	#$01,$0020(a5)														;526D0020
	and.w	#$0003,$0020(a5)													;026D00030020
	moveq	#$05,d0																;7005
Execute_Rotation:		; Memory Address ($6F74) and binary offset [$6BF0]
	bsr		Draw_Arrow_Highlights												;6100FE2C
	bsr		adrCd008498															;6100151E
	bra		Start_StairTransition_AI_TBC										;6000FF2A

TeamAvatar_LoopStart_AI_TBC:		; Memory Address ($6F80) and binary offset [$6BFC]
	movem.l	d0/d7/a6,-(sp)														;48E78102
	moveq	#$03,d7																;7E03
TeamAvatar_LoopBody_AI_TBC:		; Memory Address ($6F86) and binary offset [$6C02]
	move.b	$18(a5,d7.w),d1														;12357018
	move.w	d1,d0																;3001
	and.w	#$00E0,d1															;024100E0
	bne.s	TeamAvatar_LoopEnd_AI_TBC											;6608
	bsr		Load_ChampionStatRecord												;6100F6CC
	clr.b	$0011(a4)															;422C0011
TeamAvatar_LoopEnd_AI_TBC:		; Memory Address ($6F9A) and binary offset [$6C16]
	dbra	d7,TeamAvatar_LoopBody_AI_TBC										;51CFFFEA
	bsr		Draw_PartyCommandInterface											;61000BB0
	movem.l	(sp)+,d0/d7/a6														;4CDF4081
	rts																			;4E75

Trigger_WaitFlag_AI_TBC:		; Memory Address ($6FA8) and binary offset [$6C24]
	dc.w	$FFFF	;FFFF

Reset_TriggerWait_AI_TBC:		; Memory Address ($6FAA) and binary offset [$6C26]
	move.w	#$FFFF,Trigger_WaitFlag_AI_TBC.w									;31FCFFFF6FA8	;Short Absolute converted to symbol!
	move.b	$00(a6,d0.w),d1														;12360000
	and.w	#$0003,d1															;02410003
	subq.w	#$02,d1																;5541
	bne.s	TriggerWait_PostCheck_AI_TBC										;6604
	clr.w	Trigger_WaitFlag_AI_TBC.w											;42786FA8	;Short Absolute converted to symbol!
TriggerWait_PostCheck_AI_TBC:		; Memory Address ($6FC0) and binary offset [$6C3C]
	move.b	$00(a6,d0.w),d1														;12360000
	and.w	#$00F8,d1															;024100F8
	lsr.b	#$01,d1																;E209
	lea		TriggersData_1.l,a1													;43F900007056
	move.w	CurrentTower.l,d2													;34390000EE2E
	asl.w	#$07,d2																;EF42
	add.w	d2,a1																;D2C2
	moveq	#$00,d2																;7400
	move.b	$00(a1,d1.w),d2														;14311000
	cmpi.b	#$08,d2																;0C020008
	beq.s	Setup_TriggerEffectDefault_AI_TBC									;670C
	cmpi.b	#$0A,d2																;0C02000A
	beq.s	Setup_TriggerEffectDefault_AI_TBC									;6706
	cmpi.b	#$2A,d2																;0C02002A
	bne.s	TriggerEffect_Actual_AI_TBC											;6606
Setup_TriggerEffectDefault_AI_TBC:		; Memory Address ($6FF2) and binary offset [$6C6E]
	move.w	#$0005,Trigger_WaitFlag_AI_TBC.w									;31FC00056FA8	;Short Absolute converted to symbol!
TriggerEffect_Actual_AI_TBC:		; Memory Address ($6FF8) and binary offset [$6C74]
	lea		Trigger_00_t00_Null.l,a0											;41F900007016
	add.w	Triggers_LookupTable(pc,d2.w),a0									;D0FB2018
	movem.l	d0/d7/a6,-(sp)														;48E78102
	jsr		(a0)																;4E90
	move.w	Trigger_WaitFlag_AI_TBC.w,d0										;30386FA8	;Short Absolute converted to symbol!
	bmi.s	TriggerEffect_Post_AI_TBC											;6B04
	bsr		PlaySound															;610018AE
TriggerEffect_Post_AI_TBC:		; Memory Address ($7012) and binary offset [$6C8E]
	movem.l	(sp)+,d0/d7/a6														;4CDF4081
Trigger_00_t00_Null:		; Memory Address ($7016) and binary offset [$6C92]
	rts																			;4E75

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
	dc.w	Trigger_14_t1C_Create_Spinner_or_Other_XY-Trigger_00_t00_Null	;0768

	dc.w	Switch_00_s00_Trigger_15_t1E_ToggleWallXY-Trigger_00_t00_Null	;ECE2
	dc.w	Trigger_16_t20_Create_Pad_FXY-Trigger_00_t00_Null	;0780
	dc.w	Trigger_17_t22_Move_Diagonal_Pillar-Trigger_00_t00_Null	;07C0
	dc.w	Switch_06_s0C_Trigger_18_t24_CreatePillar_XY-Trigger_00_t00_Null	;0752

	dc.w	Trigger_19_t26_Keep_Entrance_SidePad-Trigger_00_t00_Null	;0370
	dc.w	Trigger_20_t28_Keep_Entrance_CentrePad-Trigger_00_t00_Null	;0340
	dc.w	Trigger_21_t2A_Flash_Telepoprt_FXY-Trigger_00_t00_Null	;0670
	dc.w	Switch_04_s08_Trigger_22_t2C_RotateWall_XY-Trigger_00_t00_Null	;069E

	dc.w	Switch_02_s04_Trigger_23_t2E-Trigger_00_t00_Null	;ECE6
	dc.w	adrJA007728-Trigger_00_t00_Null	;0712
	dc.w	Trigger_24_t30_Spinner3-Trigger_00_t00_Null	;0626
	dc.w	Trigger_25_t32_Clicker_Teleport_FXY-Trigger_00_t00_Null	;0774

	dc.w	Switch_07_s0E_Trigger_26_t34_RotateWood_XY-Trigger_00_t00_Null	;0742
	dc.w	Trigger_27_t36_Rotate_WoodWall_CounterClockwise-Trigger_00_t00_Null	;061A
	dc.w	Trigger_28_t38_GameCompletion-Trigger_00_t00_Null	;0504
	dc.w	adrJA007502-Trigger_00_t00_Null	;04EC
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
	tst.w	MultiPlayer.l														;4A790000EE30
	beq		adrCd007470															;67000112
	pea		$00(a1,d1.w)														;48711000
	bsr		adrCd007974															;6100060E
	move.l	(sp)+,a2															;245F
	move.w	CurrentTower.l,d2													;34390000EE2E
	moveq	#$00,d1																;7200
	move.b	Keep_Start_Floors_DataTable(pc,d2.w),d1								;123B2058
	asl.w	#$02,d2																;E542
	lea		Keep_Start_XY_DataTable.l,a0										;41F9000073CE
	add.w	d2,a0																;D0C2
	moveq	#$00,d0																;7000
	bra		adrCd007408															;60000084

Trigger_19_t26_Keep_Entrance_SidePad:		; Memory Address ($7386) and binary offset [$7002]
	tst.w	MultiPlayer.l														;4A790000EE30
	bne		adrCd007470															;660000E2
	pea		$00(a1,d1.w)														;48711000
	bsr		adrCd005D2E															;6100E998
	bsr		adrCd0098A4															;6100250A
	bcc.s	adrCd0073A2															;6404
	tst.b	d0																	;4A00
	bmi.s	adrCd0073A6															;6B04
adrCd0073A2:		; Memory Address ($73A2) and binary offset [$701E]
	addq.w	#$04,sp																;584F
	rts																			;4E75

adrCd0073A6:		; Memory Address ($73A6) and binary offset [$7022]
	move.l	a1,-(sp)															;2F09
	bsr		adrCd007974															;610005CA
	movem.l	(sp)+,a1/a2															;4CDF0600
	move.w	CurrentTower.l,d2													;34390000EE2E
	moveq	#$00,d1																;7200
	move.b	Keep_Start_Floors_DataTable(pc,d2.w),d1								;123B2012
	asl.w	#$02,d2																;E542
	lea		Keep_Start_XY_DataTable.l,a0										;41F9000073CE
	add.w	d2,a0																;D0C2
	moveq	#$00,d0																;7000
	bra		adrCd00748C															;600000C2

Keep_Start_Floors_DataTable:		; Memory Address ($73CC) and binary offset [$7048]
	INCBIN "/data/BLOODWYCH439-clean/maps/keep.floors"
Keep_Start_XY_DataTable:		; Memory Address ($73CE) and binary offset [$704A]
	INCBIN "/data/BLOODWYCH439-clean/maps/keep.entrances"

Trigger_10_t14_Tower_Entrance_CentrePad:		; Memory Address ($73E6) and binary offset [$7062]
	tst.w	MultiPlayer.l														;4A790000EE30
	beq		adrCd007470															;67000082
	pea		$00(a1,d1.w)														;48711000
	bsr		adrCd007974															;6100057E
	move.l	(sp)+,a2															;245F
	moveq	#$00,d0																;7000
	move.b	$0001(a2),d0														;102A0001
	lea		Tower_Start_XY_DataTable.l,a0										;41F9000074EA
	moveq	#$00,d1																;7200
adrCd007408:		; Memory Address ($7408) and binary offset [$7084]
	moveq	#$00,d2																;7400
	move.b	$00(a0,d0.w),d2														;14300000
	add.b	$02(a0,d0.w),d2														;D4300002
	lsr.w	#$01,d2																;E24A
	swap	d2																	;4842
	move.b	$01(a0,d0.w),d2														;14300001
	add.b	$03(a0,d0.w),d2														;D4300003
	lsr.w	#$01,d2																;E24A
	move.l	d2,$001C(a5)														;2B42001C
	move.w	d1,$0058(a5)														;3B410058
	lsr.b	#$02,d0																;E408
	move.w	d0,CurrentTower.l													;33C00000EE2E
	bsr		Select_CurrentTowerMapData											;61009736
	bsr		adrCd0084D6															;610010A0
	bsr		adrCd008498															;6100105E
	move.l	d0,$0004(sp)														;2F400004
	move.l	$001C(a5),$0008(sp)													;2F6D001C0008
	move.l	a6,$000C(sp)														;2F4E000C
	bset	#$07,$01(a6,d0.w)													;08F600070001
	bra		UnpackTowerMonsters													;600095A4

Trigger_09_t12_Tower_Entrance_SidePad:		; Memory Address ($7454) and binary offset [$70D0]
	tst.w	MultiPlayer.l														;4A790000EE30
	bmi.s	adrCd007470															;6B14
	pea		$00(a1,d1.w)														;48711000
	bsr		adrCd005D2E															;6100E8CC
	bsr		adrCd0098A4															;6100243E
	bcc.s	adrCd00746E															;6404
	tst.b	d0																	;4A00
	bmi.s	adrCd007472															;6B04
adrCd00746E:		; Memory Address ($746E) and binary offset [$70EA]
	addq.w	#$04,sp																;584F
adrCd007470:		; Memory Address ($7470) and binary offset [$70EC]
	rts																			;4E75

adrCd007472:		; Memory Address ($7472) and binary offset [$70EE]
	move.l	a1,-(sp)															;2F09
	bsr		adrCd007974															;610004FE
	movem.l	(sp)+,a1/a2															;4CDF0600
	moveq	#$00,d0																;7000
	move.b	$0001(a2),d0														;102A0001
	add.w	d0,d0																;D040
	lea		Tower_Start_XY_DataTable.l,a0										;41F9000074EA
	moveq	#$00,d1																;7200
adrCd00748C:		; Memory Address ($748C) and binary offset [$7108]
	move.b	$00(a0,d0.w),$001D(a5)												;1B700000001D
	move.b	$01(a0,d0.w),$001F(a5)												;1B700001001F
	move.w	d1,$0058(a5)														;3B410058
	eor.b	#$02,d0																;0A000002
	move.b	$00(a0,d0.w),$001D(a1)												;13700000001D
	move.b	$01(a0,d0.w),$001F(a1)												;13700001001F
	move.w	d1,$0058(a1)														;33410058
	lsr.b	#$02,d0																;E408
	move.w	d0,CurrentTower.l													;33C00000EE2E
	bsr		Select_CurrentTowerMapData											;610096AE
	bsr		adrCd0084D6															;61001018
	bsr		adrCd008498															;61000FD6
	move.l	d0,$0004(sp)														;2F400004
	move.l	$001C(a5),$0008(sp)													;2F6D001C0008
	move.l	a6,$000C(sp)														;2F4E000C
	bset	#$07,$01(a6,d0.w)													;08F600070001
	exg		a1,a5																;CB49
	bsr		adrCd008498															;61000FBC
	bset	#$07,$01(a6,d0.w)													;08F600070001
	exg		a1,a5																;CB49
	bra		UnpackTowerMonsters													;6000950E

Tower_Start_XY_DataTable:		; Memory Address ($74EA) and binary offset [$7166]
	INCBIN "/data/BLOODWYCH439-clean/data/tower.entrances"

adrJA007502:		; Memory Address ($7502) and binary offset [$717E]
	move.l	Current_TowerMapDataBase.l,a6										;2C790000EE78
	move.b	$0014(a6),d0														;102E0014
	and.b	$001C(a6),d0														;C02E001C
	btst	#$00,d0																;08000000
	bne		Switch_01_s02_Trigger_11_t16_RemoveXY								;6600E7FC
	rts																			;4E75

Trigger_28_t38_GameCompletion:		; Memory Address ($751A) and binary offset [$7196]
	move.l	a5,-(sp)															;2F0D
	bsr.s	GameEndPicture														;6164
	clr.w	FrameSyncFlagWord_AI_TBC.l											;427900008C1E
	bsr		adrCd008CCA															;610017A4
	bsr		adrCd008D88															;6100185E
	moveq	#$4B,d0																;704B
DBFWait1d:		; Memory Address ($752E) and binary offset [$71AA]
	dbra	d1,DBFWait1d														;51C9FFFE
	dbra	d0,DBFWait1d														;51C8FFFA
	lea		Player1_Data.l,a5													;4BF90000EE7C
	bsr		adrCd00CF96															;61005A58
	lea		NullString.l,a6														;4DF90000CAE9
	bsr		WriteText															;61005B46
	tst.w	MultiPlayer.l														;4A790000EE30
	bne.s	.Player2Skip														;6614
	lea		Player2_Data.l,a5													;4BF90000EEDE
	bsr		adrCd00CF96															;61005A3C
	lea		NullString.l,a6														;4DF90000CAE9
	bsr		WriteText															;61005B2A
.Player2Skip:		; Memory Address ($7566) and binary offset [$71E2]
	bsr		adrCd008CCA															;61001762
	bsr		adrCd008D88															;6100181C
	move.w	#$FFFF,FrameSyncFlagWord_AI_TBC.l									;33FCFFFF00008C1E
adrCd007576:		; Memory Address ($7576) and binary offset [$71F2]
	tst.b	FrameSyncFlagWord_AI_TBC.l											;4A3900008C1E
	bne.s	adrCd007576															;66F8
	move.l	(sp)+,a5															;2A5F
	rts																			;4E75

GameEndPicture:
	lea		Player1_Data.l,a5													;4BF90000EE7C
	tst.w	MultiPlayer.l														;4A790000EE30
	bne.s	.GameEnd_repeat														;6608
	bsr.s	.GameEnd_repeat														;6106
	lea		Player2_Data.l,a5													;4BF90000EEDE
.GameEnd_repeat:
	clr.w	$0014(a5)															;426D0014
	move.w	#$FFFF,$0042(a5)													;3B7CFFFF0042
	bsr		Draw_PartyCommandInterface											;610005AC
	bsr		Draw_ChampionNamePanelFrame											;61000CD0
	bsr		adrCd002734															;6100B188
	movem.l	d0-d7/a0-a6,-(sp)													;48E7FFFE
	link	a3,#-$0020															;4E53FFE0
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	$000A(a5),a0														;D0ED000A
	add.w	#$01EC,a0															;D0FC01EC
	move.l	a0,-$0008(a3)														;2748FFF8
	clr.b	-$0015(a3)															;422BFFEB
	moveq	#$00,d0																;7000
	moveq	#$00,d1																;7200
	moveq	#$28,d5																;7A28
	moveq	#$36,d4																;7836
	bsr		Draw_Entropy														;61002F66
	unlk	a3																	;4E5B
	lea		AccursedBloodwychMsg.l,a6											;4DF9000075F4
	bsr		WriteText															;61005AAC
	lea		CongratsText.l,a6													;4DF90000761C
	bsr		LowerText															;610059CC
	movem.l	(sp)+,d0-d7/a0-a6													;4CDF7FFF
	rts																			;4E75

AccursedBloodwychMsg:
	dc.b	'ACCURSED BLOODWYCH! WE SHALL MEET AGAIN'	;414343555253454420424C4F4F445759434821205745205348414C4C204D45455420414741494E
	dc.b	$FF	;FF
CongratsText:
	dc.b	$FE	;FE
	dc.b	$0B	;0B
	dc.b	'CONGRATULATIONS!'	;434F4E47524154554C4154494F4E5321
	dc.b	$FF	;FF
	dc.b	$00	;00

Trigger_27_t36_Rotate_WoodWall_CounterClockwise:		; Memory Address ($7630) and binary offset [$72AC]
	bsr		adrCd005D2E															;6100E6FC
	eor.b	#$03,$00(a6,d0.w)													;0A3600030000
	rts																			;4E75

Trigger_24_t30_Spinner3:		; Memory Address ($763C) and binary offset [$72B8]
	moveq	#$00,d0																;7000
	move.b	$01(a1,d1.w),d0														;10311001
	move.w	d0,d6																;3C00
	bsr		adrCd0084DA															;61000E94
	bsr		adrCd005D2E															;6100E6E4
	tst.b	$01(a6,d0.w)														;4A360001
	bpl.s	adrCd007660															;6A0E
	subq.w	#$01,d7																;5347
	bsr		CoordToMap															;61000E46
	tst.b	$01(a6,d0.w)														;4A360001
	bpl.s	adrCd007660															;6A02
	rts																			;4E75

adrCd007660:		; Memory Address ($7660) and binary offset [$72DC]
	bsr.s	adrCd007664															;6102
	rts																			;4E75

adrCd007664:		; Memory Address ($7664) and binary offset [$72E0]
	bset	#$07,$01(a6,d0.w)													;08F600070001
	move.l	$0008(sp),d1														;222F0008
	bclr	#$07,$01(a6,d1.w)													;08B600071001
	move.w	d6,$0058(a5)														;3B460058
	move.l	d7,$001C(a5)														;2B47001C
	move.l	d7,$000C(sp)														;2F47000C
	move.l	d0,$0008(sp)														;2F400008
	rts																			;4E75

Trigger_21_t2A_Flash_Telepoprt_FXY:		; Memory Address ($7686) and binary offset [$7302]
	moveq	#$00,d0																;7000
	move.b	$01(a1,d1.w),d0														;10311001
	move.w	d0,d6																;3C00
	bsr		adrCd0084DA															;61000E4A
	bsr		adrCd005D2E															;6100E69A
	tst.b	$01(a6,d0.w)														;4A360001
	bpl.s	adrCd0076AC															;6A10
	addq.w	#$02,d0																;5440
	swap	d7																	;4847
	addq.w	#$01,d7																;5247
	swap	d7																	;4847
	tst.b	$01(a6,d0.w)														;4A360001
	bpl.s	adrCd0076AC															;6A02
	rts																			;4E75

adrCd0076AC:		; Memory Address ($76AC) and binary offset [$7328]
	bsr.s	adrCd007664															;61B6
	moveq	#$10,d7																;7E10
	bra		adrCd001DBC															;6000A70A

Switch_04_s08_Trigger_22_t2C_RotateWall_XY:		; Memory Address ($76B4) and binary offset [$7330]
	bsr		adrCd005D2E															;6100E678
	move.b	$01(a6,d0.w),d1														;12360001
	move.w	d1,d2																;3401
	and.b	#$CF,d2																;020200CF
	add.w	#$0010,d1															;06410010
	and.w	#$0030,d1															;02410030
	or.b	d1,d2																;8401
	move.b	d2,$01(a6,d0.w)														;1D820001
	rts																			;4E75

Trigger_06_t0C_WoodTrap1:		; Memory Address ($76D2) and binary offset [$734E]
	move.l	#$000D000C,d7														;2E3C000D000C
	bsr		CoordToMap															;61000DC2
	bset	#$02,$00(a6,d0.w)													;08F600020000
	bclr	#$06,$02(a6,d0.w)													;08B600060002
	rts																			;4E75

Trigger_07_t0E_WoodTrap2:		; Memory Address ($76EA) and binary offset [$7366]
	move.l	#$00030000,d7														;2E3C00030000	;Long Addr replaced with Symbol
	bsr		CoordToMap															;61000DAA
	bclr	#$02,$00(a6,d0.w)													;08B600020000
	bset	#$06,$02(a6,d0.w)													;08F600060002
	rts																			;4E75

Trigger_08_t10_Trader_DoorCloser:		; Memory Address ($7702) and binary offset [$737E]
	subq.w	#$02,d0																;5540
	tst.b	$01(a6,d0.w)														;4A360001
	bmi.s	adrCd007710															;6B06
	bset	#$00,$00(a6,d0.w)													;08F600000000
adrCd007710:		; Memory Address ($7710) and binary offset [$738C]
	rts																			;4E75

Trigger_01_t02_Spinner180:		; Memory Address ($7712) and binary offset [$738E]
	eor.w	#$0002,$0020(a5)													;0A6D00020020
	rts																			;4E75

Trigger_02_t04_SpinnerRandom:		; Memory Address ($771A) and binary offset [$7396]
	bsr		RandomGen_BytewithOffset											;6100DE90
	and.w	#$0003,d0															;02400003
	move.w	d0,$0020(a5)														;3B400020
	rts																			;4E75

adrJA007728:		; Memory Address ($7728) and binary offset [$73A4]
	addq.w	#$01,$0020(a5)														;526D0020
	and.w	#$0003,$0020(a5)													;026D00030020
	rts																			;4E75

Trigger_12_t18_Close_VoidLock_Door_XY:		; Memory Address ($7734) and binary offset [$73B0]
	bsr		adrCd005D2E															;6100E5F8
	bset	#$00,$00(a6,d0.w)													;08F600000000
	move.w	#$0001,Trigger_WaitFlag_AI_TBC.w									;31FC00016FA8	;Short Absolute converted to symbol!
	rts																			;4E75

Switch_03_s06_Trigger_03_t06_OpenLockedDoor_XY:		; Memory Address ($7746) and binary offset [$73C2]
	bsr		adrCd005D2E															;6100E5E6
	bclr	#$00,$00(a6,d0.w)													;08B600000000
	move.w	#$0001,Trigger_WaitFlag_AI_TBC.w									;31FC00016FA8	;Short Absolute converted to symbol!
	rts																			;4E75

Switch_07_s0E_Trigger_26_t34_RotateWood_XY:		; Memory Address ($7758) and binary offset [$73D4]
	bsr		adrCd005D2E															;6100E5D4
	move.b	$00(a6,d0.w),d1														;12360000
	ror.b	#$02,d1																;E419
	move.b	d1,$00(a6,d0.w)														;1D810000
	rts																			;4E75

Switch_06_s0C_Trigger_18_t24_CreatePillar_XY:		; Memory Address ($7768) and binary offset [$73E4]
	bsr		Switch_01_s02_Trigger_11_t16_RemoveXY								;6100E5A8
Switch_05_s0A_Trigger_13_t1A_TogglePillar_XY:		; Memory Address ($776C) and binary offset [$73E8]
	bsr		adrCd005D2E															;6100E5C0
	move.b	#$01,$00(a6,d0.w)													;1DBC00010000
	eor.b	#$03,$01(a6,d0.w)													;0A3600030001
	rts																			;4E75

Trigger_14_t1C_Create_Spinner_or_Other_XY:		; Memory Address ($777E) and binary offset [$73FA]
	bsr		adrCd005D2E															;6100E5AE
	or.b	#$06,$01(a6,d0.w)													;003600060001
	rts																			;4E75

Trigger_25_t32_Clicker_Teleport_FXY:		; Memory Address ($778A) and binary offset [$7406]
	bsr		adrCd005D2E															;6100E5A2
	eor.b	#$06,$01(a6,d0.w)													;0A3600060001
	rts																			;4E75

Trigger_16_t20_Create_Pad_FXY:		; Memory Address ($7796) and binary offset [$7412]
	moveq	#$00,d6																;7C00
	move.b	$01(a1,d1.w),d6														;1C311001
	move.w	d1,-(sp)															;3F01
	bsr		adrCd0084FC															;61000D5C
	move.w	(sp)+,d1															;321F
	move.l	d2,d7																;2E02
	lea		MovementOffsetTable.w,a0											;41F85794	;Short Absolute converted to symbol!
	add.b	$08(a0,d6.w),d7														;DE306008
	cmp.w	adrW_00EE72.l,d7													;BE790000EE72
	bcc		Switch_01_s02_Trigger_11_t16_RemoveXY								;6400E55C
	swap	d7																	;4847
	add.b	$00(a0,d6.w),d7														;DE306000
	cmp.w	adrW_00EE70.l,d7													;BE790000EE70
	bcc		Switch_01_s02_Trigger_11_t16_RemoveXY								;6400E54C
	swap	d7																	;4847
	bsr		CoordToMap															;61000CD0
	eor.b	#$06,$01(a6,d0.w)													;0A3600060001
	rts																			;4E75

Trigger_17_t22_Move_Diagonal_Pillar:		; Memory Address ($77D6) and binary offset [$7452]
	bsr		adrCd0084FC															;61000D24
	move.l	d2,d7																;2E02
	subq.b	#$01,d7																;5307
	bsr		CoordToMap															;61000CBC
	and.w	#$00F8,$00(a6,d0.w)													;027600F80000
	or.w	#$0103,$00(a6,d0.w)													;007601030000
	swap	d7																	;4847
	subq.b	#$01,d7																;5307
	swap	d7																	;4847
	bsr		CoordToMap															;61000CA6
	and.w	#$00F8,$00(a6,d0.w)													;027600F80000
	rts																			;4E75

Trigger_04_t08_Vivify_Machine_External:		; Memory Address ($7800) and binary offset [$747C]
	addq.w	#$02,d0																;5440
	tst.b	$01(a6,d0.w)														;4A360001
	bmi		Trigger_00_t00_Null													;6B00F80E
	bset	#$00,$00(a6,d0.w)													;08F600000000
	addq.w	#$02,d0																;5440
adrCd007812:		; Memory Address ($7812) and binary offset [$748E]
	move.w	#$0086,d7															;3E3C0086
	bsr		adrCd001DBC															;6100A5A4
	tst.b	$01(a6,d0.w)														;4A360001
	bmi.s	adrCd007836															;6B16
	btst	#$06,$01(a6,d0.w)													;083600060001
	beq.s	adrCd007836															;670E
	moveq	#$03,d4																;7803
adrLp00782A:		; Memory Address ($782A) and binary offset [$74A6]
	move.w	d4,d6																;3C04
	bsr		adrCd005F5C															;6100E72E
	beq.s	adrCd007838															;6706
adrCd007832:		; Memory Address ($7832) and binary offset [$74AE]
	dbra	d4,adrLp00782A														;51CCFFF6
adrCd007836:		; Memory Address ($7836) and binary offset [$74B2]
	rts																			;4E75

adrCd007838:		; Memory Address ($7838) and binary offset [$74B4]
	lea		$03(a0,d7.w),a1														;43F07003
	moveq	#$00,d3																;7600
	move.b	-$0001(a1),d3														;1629FFFF
	add.w	d3,d3																;D643
adrCd007844:		; Memory Address ($7844) and binary offset [$74C0]
	move.b	$00(a1,d3.w),d2														;14313000
	sub.b	#$40,d2																;04020040
	bcs.s	adrCd007854															;6506
	cmpi.b	#$10,d2																;0C020010
	bcs.s	adrCd00785A															;6506
adrCd007854:		; Memory Address ($7854) and binary offset [$74D0]
	subq.w	#$02,d3																;5543
	bcc.s	adrCd007844															;64EC
	bra.s	adrCd007832															;60D8

adrCd00785A:		; Memory Address ($785A) and binary offset [$74D6]
	bset	#$07,$01(a6,d0.w)													;08F600070001
	move.w	d2,-(sp)															;3F02
	bsr		adrCd005DF8															;6100E594
	bsr		adrCd0084FC															;61000C94
	move.w	d1,d3																;3601
	move.w	(sp)+,d0															;301F
	and.w	#$000F,d0															;0240000F
	move.l	a5,-(sp)															;2F0D
	bsr		adrCd004066															;6100C7F0
	tst.w	d1																	;4A41
	bpl.s	adrCd0078A0															;6A24
	move.l	(sp)+,a5															;2A5F
adrCd00787E:		; Memory Address ($787E) and binary offset [$74FA]
	bsr		Load_ChampionStatRecord												;6100EDE0
	move.b	d2,$0017(a4)														;19420017
	swap	d2																	;4842
	move.b	d2,$0016(a4)														;19420016
	move.b	d3,$001A(a4)														;1943001A
	move.b	#$03,$0018(a4)														;197C00030018
	move.b	CurrentTower+$01.l,$001F(a4)										;19790000EE2F001F
	rts																			;4E75

adrCd0078A0:		; Memory Address ($78A0) and binary offset [$751C]
	bclr	#$06,$18(a5,d1.w)													;08B500061018
	tst.w	d1																	;4A41
	beq.s	adrCd0078C0															;6716
	btst	#$06,$0018(a5)														;082D00060018
	bne.s	adrCd0078B6															;6604
	bsr.s	adrCd00787E															;61CA
	bra.s	adrCd0078E4															;602E

adrCd0078B6:		; Memory Address ($78B6) and binary offset [$7532]
	move.b	$0018(a5),$18(a5,d1.w)												;1BAD00181018
	move.w	d0,$0006(a5)														;3B400006
adrCd0078C0:		; Memory Address ($78C0) and binary offset [$753C]
	move.b	d0,$0018(a5)														;1B400018
	bset	#$04,$0018(a5)														;08ED00040018
	move.l	d2,$001C(a5)														;2B42001C
	move.w	d3,$0058(a5)														;3B430058
	move.w	#$0003,$0020(a5)													;3B7C00030020
	move.b	d0,$0026(a5)														;1B400026
	bsr		Draw_ChampionNamePanelFrame											;6100099A
	clr.b	$0056(a5)															;422D0056
adrCd0078E4:		; Memory Address ($78E4) and binary offset [$7560]
	bsr		Draw_PartyCommandInterface											;6100026A
	bsr		adrCd008246															;6100095C
	move.l	(sp)+,a5															;2A5F
	rts																			;4E75

Trigger_05_t0A_Vivify_Machine_Internal:		; Memory Address ($78F0) and binary offset [$756C]
	subq.w	#$02,d0																;5540
	bset	#$00,$00(a6,d0.w)													;08F600000000
	addq.w	#$02,d0																;5440
adrCd0078FA:		; Memory Address ($78FA) and binary offset [$7576]
	move.w	#$0086,d7															;3E3C0086
	bsr		adrCd001DBC															;6100A4BC
	moveq	#$05,d0																;7005
	bsr		PlaySound															;61000FB8
	move.w	#$FFFF,Trigger_WaitFlag_AI_TBC.w									;31FCFFFF6FA8	;Short Absolute converted to symbol!
	moveq	#$03,d0																;7003
adrLp007910:		; Memory Address ($7910) and binary offset [$758C]
	tst.b	$18(a5,d0.w)														;4A350018
	bmi.s	adrCd007958															;6B42
	btst	#$05,$18(a5,d0.w)													;083500050018
	bne.s	adrCd007958															;663A
	bclr	#$06,$18(a5,d0.w)													;08B500060018
	beq.s	adrCd007958															;6732
	move.w	d0,-(sp)															;3F00
	move.b	$18(a5,d0.w),d0														;10350018
	bsr		Load_ChampionStatRecord												;6100ED32
	move.b	#$05,$0007(a4)														;197C00050007
	move.b	#$05,$0005(a4)														;197C00050005
	move.w	(sp)+,d0															;301F
	moveq	#$03,d1																;7203
adrLp007940:		; Memory Address ($7940) and binary offset [$75BC]
	tst.b	$26(a5,d1.w)														;4A351026
	bmi.s	adrCd00794C															;6B06
	dbra	d1,adrLp007940														;51C9FFF8
	moveq	#$00,d1																;7200
adrCd00794C:		; Memory Address ($794C) and binary offset [$75C8]
	and.b	#$0F,$18(a5,d0.w)													;0235000F0018
	move.b	$18(a5,d0.w),$26(a5,d1.w)											;1BB500181026
adrCd007958:		; Memory Address ($7958) and binary offset [$75D4]
	dbra	d0,adrLp007910														;51C8FFB6
	move.w	#$FFFF,$0042(a5)													;3B7CFFFF0042
	move.w	#$FFFF,$0040(a5)													;3B7CFFFF0040
	clr.b	$003E(a5)															;422D003E
	bsr		Draw_PartyCommandInterface											;610001E2
	bra		adrCd008246															;600008D4

adrCd007974:		; Memory Address ($7974) and binary offset [$75F0]
	bsr		adrCd001090															;6100971A
	move.w	CurrentTower.l,d0													;30390000EE2E
	move.w	d0,d1																;3200
	add.w	d0,d0																;D040
	add.w	d0,d1																;D240
	asl.w	#PackedMonster_TowerBlockShift,d1									;E141
	lea		MonsterBlock_mod0.l,a3												;47F900017584
	add.w	d1,a3																;D6C1
	lea		UnpackedMonsters.l,a4												;49F900016B7E
	move.w	MonsterLive_RecordCountOffset(a4),d1								;322CFFFE
	lea		MonsterTotalsCounts_mod0.l,a0										;41F900017578
	move.w	d1,$00(a0,d0.w)														;31810000
	bmi.s	adrCd007A10															;6B6C
	move.l	a3,a0																;204B
	move.w	#PackedMonster_TowerBlockLongwordCount-1,d0							;303C00BF
	moveq	#-$01,d2															;74FF
adrLp0079AC:		; Memory Address ($79AC) and binary offset [$7628]
	move.l	d2,(a0)+															;20C2
	dbra	d0,adrLp0079AC														;51C8FFFC
	move.l	a3,a0																;204B
adrLp0079B4:		; Memory Address ($79B4) and binary offset [$7630]
	move.b	MonsterRecord_Type(a4),d2											;142C000A
	asl.b	#$04,d2																;E902
	move.b	MonsterRecord_Floor(a4),d3											;162C0004
	addq.w	#$01,d3																;5243
	and.w	#$000F,d3															;0243000F
	or.b	d2,d3																;8602
	move.b	d3,(a3)+															;16C3
	move.b	MonsterRecord_XPosition(a4),(a3)+									;16EC0000
	move.b	MonsterRecord_YPosition(a4),(a3)+									;16EC0001
	move.b	MonsterRecord_CurrentLevel(a4),(a3)+								;16EC0006
	move.b	MonsterRecord_Form(a4),(a3)+										;16EC000B
	move.b	MonsterRecord_TeamGroupIndex(a4),d3									;162C000D
	bmi.s	adrCd007A06															;6B28
	lea		MonsterTeamIndexTable.l,a6											;4DF900017390
	asl.w	#$02,d3																;E543
	add.w	d3,a6																;DCC3
	moveq	#MonsterTeamMember_Count-1,d2										;7403
adrLp0079EA:		; Memory Address ($79EA) and binary offset [$7666]
	moveq	#$00,d0																;7000
	move.b	$00(a6,d2.w),d0														;10362000
	bmi.s	adrCd007A02															;6B10
	add.b	d0,d0																;D000
	add.b	$00(a6,d2.w),d0														;D0362000
	add.w	d0,d0																;D040
	move.b	d3,d4																;1803
	add.b	d2,d4																;D802
	move.b	d4,PackedMonster_TeamDataOffset(a0,d0.w)							;11840005
adrCd007A02:		; Memory Address ($7A02) and binary offset [$767E]
	dbra	d2,adrLp0079EA														;51CAFFE6
adrCd007A06:		; Memory Address ($7A06) and binary offset [$7682]
	addq.w	#$01,a3																;524B
	add.w	#$0010,a4															;D8FC0010
	dbra	d1,adrLp0079B4														;51C9FFA6
adrCd007A10:		; Memory Address ($7A10) and binary offset [$768C]
	lea		adrEA0174F8.l,a0													;41F9000174F8
	move.l	Current_TowerMapDataBase.l,a6										;2C790000EE78
	move.w	-$0002(a0),d7														;3E28FFFE
	clr.w	-$0002(a0)															;4268FFFE
	bra.s	adrCd007A30															;600A

adrLp007A26:		; Memory Address ($7A26) and binary offset [$76A2]
	move.w	(a0),d0																;3010
	bclr	#$05,$01(a6,d0.w)													;08B600050001
	clr.l	(a0)+																;4298
adrCd007A30:		; Memory Address ($7A30) and binary offset [$76AC]
	dbra	d7,adrLp007A26														;51CFFFF4
adrCd007A34:		; Memory Address ($7A34) and binary offset [$76B0]
	tst.w	adrW_0173F4.l														;4A79000173F4
	beq.s	adrCd007A42															;6706
	bsr		adrCd001174															;61009736
	bra.s	adrCd007A34															;60F2

adrCd007A42:		; Memory Address ($7A42) and binary offset [$76BE]
	rts																			;4E75

Compute_NewMapIndex_AI_TBC:		; Memory Address ($7A44) and binary offset [$76C0]
	move.l	d7,d5																;2A07
	bsr		CoordToMap															;61000A54
	move.w	d0,d2																;3400
	bsr		adrCd007AE6															;61000098
	bcs		adrCd007ADE															;6500008C
	move.w	d6,d0																;3006
	bsr		adrCd008486															;61000A2E
	cmp.w	adrW_00EE72.l,d7													;BE790000EE72
	bcc.s	adrCd007ADC															;647A
	swap	d7																	;4847
	cmp.w	adrW_00EE70.l,d7													;BE790000EE70
	bcc.s	adrCd007ADC															;6470
	swap	d7																	;4847
	move.b	$01(a6,d0.w),d1														;12360001
	bpl.s	adrCd007A8E															;6A1A
	and.w	#$0007,d1															;02410007
	subq.b	#$01,d1																;5301
	beq.s	adrCd007ADC															;6760
	subq.b	#$01,d1																;5301
	bne.s	adrCd007ADE															;665E
	eor.w	#$0002,d6															;0A460002
	bsr.s	adrCd007AF4															;616E
	bcs.s	adrCd007AD8															;6550
	eor.w	#$0002,d6															;0A460002
	bra.s	adrCd007ADE															;6050

adrCd007A8E:		; Memory Address ($7A8E) and binary offset [$770A]
	and.w	#$0007,d1															;02410007
	move.b	adrB_007AD0(pc,d1.w),d1												;123B103C
	beq.s	adrCd007AC0															;6728
	bpl.s	adrCd007AB0															;6A16
	addq.b	#$01,d1																;5201
	beq.s	adrCd007ADC															;673E
	addq.b	#$01,d1																;5201
	beq.s	adrCd007ADE															;673C
	move.b	$00(a6,d0.w),d1														;12360000
	not.b	d1																	;4601
	and.b	#$03,d1																;02010003
	beq.s	adrCd007ADC															;672E
	bra.s	adrCd007AC0															;6010

adrCd007AB0:		; Memory Address ($7AB0) and binary offset [$772C]
	eor.w	#$0002,d6															;0A460002
	subq.b	#$01,d1																;5301
	bne.s	adrCd007ABC															;6604
	bsr.s	adrCd007AF8															;613E
	bra.s	adrCd007ABE															;6002

adrCd007ABC:		; Memory Address ($7ABC) and binary offset [$7738]
	bsr.s	adrCd007AF4															;6136
adrCd007ABE:		; Memory Address ($7ABE) and binary offset [$773A]
	bcs.s	adrCd007AD8															;6518
adrCd007AC0:		; Memory Address ($7AC0) and binary offset [$773C]
	bclr	#$07,$01(a6,d2.w)													;08B600072001
	bset	#$07,$01(a6,d0.w)													;08F600070001
	swap	d1																	;4841
	rts																			;4E75

adrB_007AD0:		; Memory Address ($7AD0) and binary offset [$774C]
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$02	;02
	dc.b	$FE	;FE
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$00	;00
	dc.b	$FD	;FD

adrCd007AD8:		; Memory Address ($7AD8) and binary offset [$7754]
	eor.w	#$0002,d6															;0A460002
adrCd007ADC:		; Memory Address ($7ADC) and binary offset [$7758]
	move.w	d2,d0																;3002
adrCd007ADE:		; Memory Address ($7ADE) and binary offset [$775A]
	move.l	d5,d7																;2E05
	sub.w	#$FFFF,d1															;0441FFFF
	rts																			;4E75

adrCd007AE6:		; Memory Address ($7AE6) and binary offset [$7762]
	move.b	$01(a6,d0.w),d1														;12360001
	and.w	#$0007,d1															;02410007
	cmpi.b	#$02,d1																;0C010002
	bne.s	adrCd007B04															;6610
adrCd007AF4:		; Memory Address ($7AF4) and binary offset [$7770]
	move.w	d6,d1																;3206
	add.w	d1,d1																;D241
adrCd007AF8:		; Memory Address ($7AF8) and binary offset [$7774]
	btst	d1,$00(a6,d0.w)														;03360000
	beq.s	adrCd007B04															;6706
	sub.b	#$FF,d1																;040100FF
	rts																			;4E75

adrCd007B04:		; Memory Address ($7B04) and binary offset [$7780]
	swap	d1																	;4841
	rts																			;4E75

adrCd007B08:		; Memory Address ($7B08) and binary offset [$7784]
	bsr		adrCd008DA8															;6100129E
	moveq	#$00,d4																;7800
	moveq	#$60,d5																;7A60
	tst.w	MultiPlayer.l														;4A790000EE30
	beq.s	adrCd007B20															;6708
	moveq	#$1F,d5																;7A1F
	bsr.s	Draw_PartyCommandPanelEdge											;6112
	move.w	#$0090,d5															;3A3C0090
adrCd007B20:		; Memory Address ($7B20) and binary offset [$779C]
	bsr.s	Draw_PartyCommandPanelEdge											;610C
adrCd007B22:		; Memory Address ($7B22) and binary offset [$779E]
	bsr		Draw_ChampionNamePanelFrame											;61000754
	bsr		Draw_PartyCommandInterface											;61000028
	bra		adrCd008FB8															;6000148C

Draw_PartyCommandPanelEdge:		; Memory Address ($7B2E) and binary offset [$77AA]
	; Builds the procedural edge around the party-command panel using repeated
	; horizontal lines.
	move.l	#$013F0001,d3														;263C013F0001
adrCd007B34:		; Memory Address ($7B34) and binary offset [$77B0]
	bsr		BW_blit_horiz_line													;6100604E
	addq.w	#$01,d5																;5245
	addq.w	#$01,d3																;5243
	cmpi.w	#$0005,d3															;0C430005
	bcs.s	adrCd007B34															;65F2
	subq.w	#$02,d3																;5543
adrCd007B44:		; Memory Address ($7B44) and binary offset [$77C0]
	bsr		BW_blit_horiz_line													;6100603E
	addq.w	#$01,d5																;5245
	subq.w	#$01,d3																;5343
	bne.s	adrCd007B44															;66F6
	rts																			;4E75

Draw_PartyCommandInterface:		; Memory Address ($7B50) and binary offset [$77CC]
	; Clears and composes the party-command panel for the current command state.
	tst.w	$0042(a5)															;4A6D0042
	bmi		Refresh_DirtyPartyShieldSlots										;6B00036A
	or.b	#$03,$0054(a5)														;002D00030054
	move.l	#$005F0000,d4														;283C005F0000
	move.l	#$00580007,d5														;2A3C00580007
	add.w	$0008(a5),d5														;DA6D0008
	moveq	#$00,d3																;7600
	bsr		BW_draw_bar															;61005EF6
	move.l	#$FFFFFFFF,$005A(a5)												;2B7CFFFFFFFF005A
	bsr		Draw_MainChampionAvatarPanel										;61005140
	moveq	#$0A,d5																;7A0A
	add.w	$0008(a5),d5														;DA6D0008
	moveq	#$32,d4																;7832
	move.l	#$002B0002,d3														;263C002B0002
	bsr		BW_blit_vertical_line												;61005F74
	moveq	#$5D,d4																;785D
	bsr		BW_blit_vertical_line												;61005F6E
	addq.w	#$02,d5																;5445
	sub.l	#$00040000,d3														;048300040000	;Long Addr replaced with Symbol
	moveq	#$5B,d4																;785B
	bsr		BW_blit_vertical_line												;61005F60
	moveq	#$34,d4																;7834
	bsr		BW_blit_vertical_line												;61005F5A
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$0147,a0															;D0FC0147
	add.w	$000A(a5),a0														;D0ED000A
	moveq	#$71,d7																;7E71
	move.w	$0012(a5),d3														;Loads the active player's secondary UI colour before drawing the six command/toggle pocket graphics.
adrCd007BC0:		; Memory Address ($7BC0) and binary offset [$783C]
	move.w	d7,d0																;3007
	bsr		Draw_PocketGraphic													;61004F26
	addq.w	#$01,d7																;5247
	move.w	d7,d0																;3007
	bsr		Draw_PocketGraphic													;61004F1E
	addq.w	#$01,d7																;5247
	add.w	#$027C,a0															;D0FC027C
	cmpi.w	#$0075,d7															;0C470075
	bcs.s	adrCd007BC0															;65E6
	cmp.w	#$0008,$0042(a5)													;0C6D00080042
	bne.s	adrCd007BE8															;6606
	cmpi.w	#$0077,d7															;0C470077
	bcs.s	adrCd007BC0															;65D8
adrCd007BE8:		; Memory Address ($7BE8) and binary offset [$7864]
	bsr		Draw_PartyCommandMenu												;61000182
	lea		GFX_Pockets+$3C60.l,a1												;43F900050362
	move.l	#$00050006,d5														;2A3C00050006	;Long Addr replaced with Symbol
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$0DE8,a0															;D0FC0DE8
	add.w	$000A(a5),a0														;D0ED000A
	lea		$0070.w,a3															;47F80070
	bra		Draw_PlanarGraphic													;600050AC

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

adrJA007CA0:		; Memory Address ($7CA0) and binary offset [$791C]
	lea		PartyCommandDescriptorStream_Mode0.w,a6								;4DF87C0E	;Short Absolute converted to symbol!
	rts																			;4E75

adrJA007CA6:		; Memory Address ($7CA6) and binary offset [$7922]
	bsr.s	adrCd007D06															;615E
	moveq	#$01,d1																;7201
	moveq	#$00,d3																;7600
adrCd007CAC:		; Memory Address ($7CAC) and binary offset [$7928]
	move.b	$18(a5,d1.w),d0														;10351018
	and.w	#$00E0,d0															;024000E0
	bne.s	adrCd007CCC															;6616
	move.b	$18(a5,d1.w),d0														;10351018
	and.w	#$000F,d0															;0240000F
	move.b	d0,$04(a6,d2.w)														;1D802004
	move.b	#$5F,$00(a6,d3.w)													;1DBC005F3000
	addq.w	#$01,d3																;5243
	addq.w	#$02,d2																;5442
adrCd007CCC:		; Memory Address ($7CCC) and binary offset [$7948]
	addq.w	#$01,d1																;5241
	cmpi.w	#$0004,d1															;0C410004
	bcs.s	adrCd007CAC															;65D8
	rts																			;4E75

adrJA007CD6:		; Memory Address ($7CD6) and binary offset [$7952]
	bsr.s	adrCd007D06															;612E
	moveq	#$02,d1																;7202
	moveq	#$00,d3																;7600
adrLp007CDC:		; Memory Address ($7CDC) and binary offset [$7958]
	move.b	$19(a5,d1.w),d0														;10351019
	bmi.s	adrCd007D00															;6B1E
	btst	#$05,d0																;08000005
	beq.s	adrCd007D00															;6718
	btst	#$06,d0																;08000006
	bne.s	adrCd007D00															;6612
	and.w	#$000F,d0															;0240000F
	move.b	d0,$04(a6,d2.w)														;1D802004
	move.b	#$5F,$00(a6,d3.w)													;1DBC005F3000
	addq.w	#$02,d2																;5442
	addq.w	#$01,d3																;5243
adrCd007D00:		; Memory Address ($7D00) and binary offset [$797C]
	dbra	d1,adrLp007CDC														;51C9FFDA
	rts																			;4E75

adrCd007D06:		; Memory Address ($7D06) and binary offset [$7982]
	lea		Interface_ActionSelectionScratchBuffer.w,a6							;4DF87C20	;Short Absolute converted to symbol!
	move.b	#$FC,d0																;103C00FC
	moveq	#$08,d2																;7408
adrCd007D10:		; Memory Address ($7D10) and binary offset [$798C]
	move.b	d0,$02(a6,d2.w)														;1D802002
	subq.w	#$02,d2																;5542
	bne.s	adrCd007D10															;66F8
	move.l	#$FFFFFFFF,(a6)														;2CBCFFFFFFFF
	rts																			;4E75

adrJA007D20:		; Memory Address ($7D20) and binary offset [$799C]
	lea		PartyCommandDescriptorStream_Mode4.w,a6								;4DF87C2C	;Short Absolute converted to symbol!
	rts																			;4E75

adrJA007D26:		; Memory Address ($7D26) and binary offset [$79A2]
	lea		PartyCommandDescriptorStream_Mode5.w,a6								;4DF87C3A	;Short Absolute converted to symbol!
	rts																			;4E75

adrJA007D2C:		; Memory Address ($7D2C) and binary offset [$79A8]
	lea		PartyCommandDescriptorStream_Mode6.w,a6								;4DF87C4D	;Short Absolute converted to symbol!
	rts																			;4E75

adrJA007D32:		; Memory Address ($7D32) and binary offset [$79AE]
	lea		PartyCommandDescriptorStream_Mode7.w,a6								;4DF87C6F	;Short Absolute converted to symbol!
	rts																			;4E75

adrJA007D38:		; Memory Address ($7D38) and binary offset [$79B4]
	lea		PartyCommandDescriptorStream_Mode8.w,a6								;4DF87C87	;Short Absolute converted to symbol!
	rts																			;4E75

adrJA007D3E:		; Memory Address ($7D3E) and binary offset [$79BA]
	lea		PartyCommandDescriptorStream_Mode9.w,a6								;4DF87C93	;Short Absolute converted to symbol!
	rts																			;4E75

adrJT007D44:		; Memory Address ($7D44) and binary offset [$79C0]
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

Draw_PartyCommandMenu:		; Memory Address ($7D6C) and binary offset [$79E8]
	; Selects a command descriptor stream and draws its selectable rows and text.
	or.b	#$01,$0054(a5)														;002D00010054
	move.w	$0044(a5),d0														;302D0044
	asl.w	#$02,d0																;E540
	move.l	adrJT007D44(pc,d0.w),a0												;207B00CA
	jsr		(a0)																;4E90
	move.l	a6,$0046(a5)														;2B4E0046
	move.l	#$00060039,d5														;2A3C00060039
	add.w	$0008(a5),d5														;DA6D0008
	moveq	#$00,d7																;7E00
adrCd007D8E:		; Memory Address ($7D8E) and binary offset [$7A0A]
	moveq	#$02,d3																;7602
	moveq	#$00,d4																;7800
	move.b	$00(a6,d7.w),d4														;18367000
	bpl.s	adrCd007D9C															;6A04
	moveq	#$5F,d4																;785F
	bra.s	adrCd007DAC															;6010

adrCd007D9C:		; Memory Address ($7D9C) and binary offset [$7A18]
	cmp.b	$0040(a5),d7														;BE2D0040
	bne.s	adrCd007DAC															;660A
	tst.b	$0041(a5)															;4A2D0041
	bne.s	adrCd007DAC															;6604
	move.w	$0010(a5),d3														;Uses the active player's primary UI colour for either selected party-command row state.
adrCd007DAC:		; Memory Address ($7DAC) and binary offset [$7A28]
	subq.w	#$01,d4																;5344
	swap	d4																	;4844
	movem.l	d4/d5/d7,-(sp)														;48E70D00
	bsr		BW_draw_bar															;61005CB2
	subq.w	#$07,d5																;5F45
	swap	d4																	;4844
	addq.w	#$01,d4																;5244
	move.l	#$00060000,d3														;263C00060000
	bsr		BW_blit_vertical_line												;61005D3E
	movem.l	(sp),d4/d5/d7														;4CD700B0
	swap	d4																	;4844
	addq.w	#$02,d4																;5444
	moveq	#$5D,d0																;705D
	sub.w	d4,d0																;9044
	bcs.s	adrCd007DF2															;651C
	swap	d4																	;4844
	move.w	d0,d4																;3800
	swap	d4																	;4844
	moveq	#$02,d3																;7602
	cmp.b	$0040(a5),d7														;BE2D0040
	bne.s	adrCd007DEE															;660A
	tst.b	$0041(a5)															;4A2D0041
	beq.s	adrCd007DEE															;6704
	move.w	$0010(a5),d3														;Uses the active player's primary UI colour for either selected party-command row state.
adrCd007DEE:		; Memory Address ($7DEE) and binary offset [$7A6A]
	bsr		BW_draw_bar															;61005C78
adrCd007DF2:		; Memory Address ($7DF2) and binary offset [$7A6E]
	movem.l	(sp)+,d4/d5/d7														;4CDF00B0
	addq.w	#$08,d5																;5045
	addq.w	#$01,d7																;5247
	cmpi.w	#$0004,d7															;0C470004
	bcs.s	adrCd007D8E															;658E
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	$000A(a5),a0														;D0ED000A
	add.w	#$0910,a0															;D0FC0910
	addq.w	#$04,a6																;584E
	moveq	#$00,d7																;7E00
adrCd007E12:		; Memory Address ($7E12) and binary offset [$7A8E]
	move.l	a0,-(sp)															;2F08
	bsr		Print_com_menu_entry												;61005936
	clr.b	InputStateFlag_AI_TBC.l												;42390000EE2D
	move.l	(sp)+,a0															;205F
	add.w	#$0140,a0															;D0FC0140
adrL_007E22:									equ	*-2			; Memory Address ($7E22) and binary offset [$7A9E]
	addq.w	#$01,d7																;5247
	cmpi.w	#$0004,d7															;0C470004
	bcs.s	adrCd007E12															;65E6
	moveq	#$00,d4																;7800
	moveq	#$39,d5																;7A39
	add.w	$0008(a5),d5														;DA6D0008
	move.l	#$001E0000,d3														;263C001E0000
	bsr		BW_blit_vertical_line												;61005CC8
	moveq	#$5E,d4																;785E
	bsr		BW_blit_vertical_line												;61005CC2
	addq.w	#$01,d4																;5244
	bra		BW_blit_vertical_line												;60005CBC

adrCd007E4A:		; Memory Address ($7E4A) and binary offset [$7AC6]
	add.l	screen_ptr.l,a0														;D1F900008D36
	add.w	$000A(a5),a0														;D0ED000A
	lea		GFX_Pockets+$6500.l,a1												;43F900052C02
	move.l	#$00000024,-(sp)													;2F3C00000024
	moveq	#$00,d3																;7600
adrCd007E62:		; Memory Address ($7E62) and binary offset [$7ADE]
	lea		$0098.w,a3															;47F80098
	bra		Draw_PlanarGraphicCore												;60004FC0

Draw_ActivePartyChampionInShield:		; Memory Address ($7E6A) and binary offset [$7AE6]
	; Validate an active living party slot and draw its character inside the
	; selected shield surround.
	btst	d7,$003E(a5)														;0F2D003E
	beq.s	adrCd007E80															;6710
	move.b	$18(a5,d7.w),d1														;12357018
	move.b	d1,d0																;1001
	and.w	#$000F,d0															;0240000F
	and.w	#$00E0,d1															;024100E0
	beq.s	adrCd007E82															;6702
adrCd007E80:		; Memory Address ($7E80) and binary offset [$7AFC]
	rts																			;4E75

adrCd007E82:		; Memory Address ($7E82) and binary offset [$7AFE]
	move.b	d0,-$0017(a3)														;1740FFE9
	move.w	d7,d0																;3007
	add.w	d7,d7																;DE47
	add.w	d0,d7																;DE40
	add.w	d7,d7																;DE47
	move.w	ActivePartyChampionShieldDrawParameters(pc,d7.w),d4					;383B7018
	move.w	adrW_007EAA(pc,d7.w),d5												;3A3B7016
	move.w	adrW_007EAC(pc,d7.w),d1												;323B7014
	moveq	#$00,d0																;7000
	move.w	#$FFFF,MonsterStrip_BottomY.l										;33FCFFFF0000AD64
	bra		Draw_Character														;6000289E

ActivePartyChampionShieldDrawParameters:		; Memory Address ($7EA8) and binary offset [$7B24]
	; Four six-byte records supplying character-render X, Y, and display parameters
	; for the party slots.
	dc.w	$0011	;0011
adrW_007EAA:		; Memory Address ($7EAA) and binary offset [$7B26]
	dc.w	$001C	;001C
adrW_007EAC:		; Memory Address ($7EAC) and binary offset [$7B28]
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
	moveq	#$03,d7																;7E03
Refresh_DirtyPartyShieldSlots_Loop:		; Memory Address ($7EC2) and binary offset [$7B3E]
	; Four-slot dirty-shield refresh loop.
	move.w	d7,-(sp)															;3F07
	bsr		Refresh_PartyShieldSlotIfDirty										;6100002A
	move.w	(sp)+,d7															;3E1F
	dbra	d7,Refresh_DirtyPartyShieldSlots_Loop								;51CFFFF6
	bsr		Draw_CompactStatsFrame												;61000128
Draw_PartyShieldChainStrip:		; Memory Address ($7ED2) and binary offset [$7B4E]
	; Draw the Pockets.gfx chain strip whose gaps accommodate the shield slots.
	lea		GFX_Pockets+$3C30.l,a1												;43F900050332
	move.l	#$00050006,d5														;2A3C00050006	;Long Addr replaced with Symbol
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$0DE8,a0															;D0FC0DE8
	add.w	$000A(a5),a0														;D0ED000A
	bra		adrLp008D3E															;60000E50

Refresh_PartyShieldSlotIfDirty:		; Memory Address ($7EF0) and binary offset [$7B6C]
	; Return unless the selected party slot is marked for redraw.
	tst.b	$5A(a5,d7.w)														;4A35705A
	bmi.s	adrCd007EF8															;6B02
	rts																			;4E75

adrCd007EF8:		; Memory Address ($7EF8) and binary offset [$7B74]
	or.b	#$03,$0054(a5)														;002D00030054
	tst.w	d7																	;4A47
	beq.s	adrCd007F0A															;6708
	clr.w	adrW_00EE2A.l														;42790000EE2A
	bra.s	Draw_PartyShieldSlot												;604A

adrCd007F0A:		; Memory Address ($7F0A) and binary offset [$7B86]
	tst.w	$0042(a5)															;4A6D0042
	bpl		Draw_MainChampionAvatarPanel										;6A004DAE
	moveq	#$00,d3																;7600
	moveq	#$5F,d4																;785F
	swap	d4																	;4844
	move.l	#$002E0007,d5														;2A3C002E0007
	add.w	$0008(a5),d5														;DA6D0008
	bsr		BW_draw_bar															;61005B44
	btst	#$00,$003E(a5)														;082D0000003E
	bne.s	adrCd007F36															;6608
	bsr		Draw_MainChampionAvatarPanel										;61004D8E
	bra		Draw_CompactStatsFrame												;600000C4

adrCd007F36:		; Memory Address ($7F36) and binary offset [$7BB2]
	move.l	#$00000230,a0														;207C00000230
	bsr		adrCd007E4A															;6100FF0C
	move.l	#$00000235,a0														;207C00000235
	bsr		adrCd007E4A															;6100FF02
	moveq	#$00,d7																;7E00
	bsr		Draw_SelectedPartyChampionInShield									;61000064
	bra		Draw_CompactStatsFrame												;600000A6

Draw_PartyShieldSlot:		; Memory Address ($7F54) and binary offset [$7BD0]
	; Choose vacant, selected-living, ordinary, or dead rendering for one party
	; shield slot.
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$0898,a0															;D0FC0898
	add.w	$000A(a5),a0														;D0ED000A
	move.w	d7,d0																;3007
	subq.w	#$01,d7																;5347
	asl.w	#$02,d7																;E547
	add.w	d7,a0																;D0C7
	move.b	$18(a5,d0.w),d7														;Loads the selected party-slot state byte; a negative value denotes a vacant slot and the low nibble identifies an occupied champion.
	bpl.s	Select_OccupiedPartyShieldRendering									;6A16
	lea		GFX_Shield_Clicked.l,a1												;43F900019BFE
	sub.l	a3,a3																;97CB
	move.l	#$00010028,d5														;2A3C00010028	;Long Addr replaced with Symbol
	move.w	$0012(a5),d3														;362D0012
	bra		adrCd00CE26															;60004EA2

Select_OccupiedPartyShieldRendering:		; Memory Address ($7F86) and binary offset [$7C02]
	; Distinguish the selected living slot from ordinary and dead occupied slots.
	btst	d0,$003E(a5)														;Tests whether this party slot is the active selected member before choosing its shield-rendering path.
	beq.s	Select_PartyShieldClassColours										;674A
	btst	#$05,d7																;08070005
	bne.s	Select_PartyShieldClassColours										;6644
	btst	#$06,d7																;08070006
	bne.s	Use_DeadPartyShieldClassColours										;6646
	move.w	d0,-(sp)															;3F00
	lea		GFX_Pockets+GFX_Pockets_SelectedPartyShieldFrameOffset.l,a1			;Selects the 32x41 light-grey shield surround used for the active living party member.
	move.l	#$00010028,d5														;2A3C00010028	;Long Addr replaced with Symbol
	move.l	#PartyShieldFrameSourceRowSkip,a3									;Skips the unused remainder of each Pockets.gfx source row after drawing the two-word-wide shield surround.
	bsr		Draw_PlanarGraphic													;61004D0A
	move.w	(sp)+,d7															;3E1F
Draw_SelectedPartyChampionInShield:		; Memory Address ($7FB2) and binary offset [$7C2E]
	; Prepare the character-render work area and draw the active living champion
	; inside the selected surround.
	link	a3,#-$0020															;4E53FFE0
	move.b	#$FF,-$0019(a3)														;177C00FFFFE7
	clr.b	-$0015(a3)															;422BFFEB
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	$000A(a5),a0														;D0ED000A
	move.l	a0,-$0008(a3)														;2748FFF8
	bsr		Draw_ActivePartyChampionInShield									;6100FE9A
	unlk	a3																	;4E5B
Return_PartyShieldDrawing:		; Memory Address ($7FD4) and binary offset [$7C50]
	; Shared return for party-shield rendering paths.
	rts																			;4E75

Select_PartyShieldClassColours:		; Memory Address ($7FD6) and binary offset [$7C52]
	; Select normal class colours or the fixed dead-state class mask.
	moveq	#$04,d3																;7604
	btst	#$06,d7																;08070006
	beq.s	Prepare_ComposedPartyShieldAvatar									;6702
Use_DeadPartyShieldClassColours:		; Memory Address ($7FDE) and binary offset [$7C5A]
	; Set D3 to zero, selecting black surround ink and the fixed dead
	; professional-symbol mask.
	moveq	#$00,d3																;Selects black for shield ink $F and retains the fixed dead-state professional-symbol colour mask.
Prepare_ComposedPartyShieldAvatar:		; Memory Address ($7FE0) and binary offset [$7C5C]
	; Resolve the champion ID and living shield ink before entering the common
	; shield compositor.
	and.w	#$000F,d7															;0247000F
	tst.w	d3																	;4A43
	beq.s	Draw_ComposedPartyShieldAvatar										;670C
	bsr		Select_ChampionShieldInkColour										;61004D14
	cmpi.w	#$0008,d3															;0C430008
	bne.s	Draw_ComposedPartyShieldAvatar										;6602
	subq.w	#$01,d3																;5343
Draw_ComposedPartyShieldAvatar:		; Memory Address ($7FF4) and binary offset [$7C70]
	; Tail-call Draw_ShieldAvatar with the selected living or dead colour state.
	bra		Draw_ShieldAvatar													;60004DAA

Draw_CompactStatsFrame:		; Memory Address ($7FF8) and binary offset [$7C74]
	; Builds the compact statistics panel from procedural lines, a background
	; rectangle, and the packed STATS title graphic.
	tst.w	$0042(a5)															;4A6D0042
	bpl.s	Return_PartyShieldDrawing											;6AD6
	moveq	#$36,d4																;7836
	moveq	#$0A,d5																;7A0A
	add.w	$0008(a5),d5														;DA6D0008
	move.l	#$00240001,d3														;Top stats-frame line: DBRA terminal count $24 draws $25 pixels using palette index $01.
	bsr		BW_blit_horiz_line													;61005B76
	addq.w	#$01,d5																;5245
	subq.w	#$02,d4																;5544
	add.l	#$00040001,d3														;068300040001	;Long Addr replaced with Symbol
	bsr		BW_blit_horiz_line													;61005B68
	addq.w	#$01,d5																;5245
	subq.w	#$01,d4																;5344
	add.l	#$00020001,d3														;068300020001	;Long Addr replaced with Symbol
	bsr		BW_blit_horiz_line													;61005B5A
	addq.w	#$01,d5																;5245
	addq.w	#$01,d3																;Fourth top frame line keeps the width and advances to palette index $04.
	bsr		BW_blit_horiz_line													;61005B52
	addq.w	#$01,d5																;5245
	subq.w	#$03,d3																;Fifth top frame line returns the packed colour to palette index $01.
	bsr		BW_blit_horiz_line													;61005B4A
	moveq	#$31,d5																;7A31
	add.w	$0008(a5),d5														;DA6D0008
	moveq	#$33,d4																;7833
	move.l	#$002A0001,d3														;First lower stats-frame line: DBRA terminal count $2A draws $2B pixels using palette index $01.
	bsr		BW_blit_horiz_line													;61005B38
	addq.w	#$01,d5																;5245
	addq.w	#$03,d3																;Second lower frame line advances to palette index $04.
	bsr		BW_blit_horiz_line													;61005B30
	addq.w	#$01,d5																;5245
	subq.w	#$01,d3																;Third lower frame line advances back to palette index $03.
	bsr		BW_blit_horiz_line													;61005B28
	addq.w	#$01,d4																;5244
	addq.w	#$01,d5																;5245
	sub.l	#$00020001,d3														;048300020001	;Long Addr replaced with Symbol
	bsr		BW_blit_horiz_line													;61005B1A
	addq.w	#$02,d4																;5444
	addq.w	#$01,d5																;5245
	sub.l	#$00040001,d3														;048300040001	;Long Addr replaced with Symbol
	bsr		BW_blit_horiz_line													;61005B0C
	moveq	#$10,d5																;7A10
	add.w	$0008(a5),d5														;DA6D0008
	moveq	#$34,d4																;7834
	move.l	#$001F0001,d3														;Side frame lines use terminal count $1F, drawing $20 pixels in palette index $01.
	bsr		BW_blit_vertical_line												;61005A7A
	moveq	#$5C,d4																;785C
	bsr		BW_blit_vertical_line												;61005A74
	swap	d5																	;4845
	move.w	#$001F,d5															;3A3C001F
	swap	d5																	;4845
	move.l	#$00260035,d4														;Stats background packs X=$35 with horizontal terminal count $26, drawing $27 pixels wide.
	moveq	#$02,d3																;Stats background uses palette index $02, the light-grey panel fill.
	bsr		BW_draw_bar															;Draws the stats background rectangle using the dimensions in D4 and the current palette index in D3.
	lea		GFX_Pockets+$7580.l,a1												;Selects the pre-drawn `<STATS>` title graphic from GFX_Pockets.
	move.l	#$00000088,a3														;267C00000088
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	$000A(a5),a0														;D0ED000A
	add.w	#$0286,a0															;D0FC0286
	move.l	#$00020005,d5														;2A3C00020005	;Long Addr replaced with Symbol
	bsr		Draw_PlanarGraphic													;61004BF0
Draw_MainPlayerInterface:		; Memory Address ($80CA) and binary offset [$7D46]
	; Draws the ordinary player interface, including exactly three compact
	; statistics bars.
	tst.w	$0042(a5)															;4A6D0042
	bpl		adrCd008256															;6A000186
	or.b	#$01,$0054(a5)														;002D00010054
	move.l	#$00240036,d4														;283C00240036
	move.l	#$00160017,d5														;2A3C00160017
	add.w	$0008(a5),d5														;DA6D0008
	moveq	#$03,d3																;The stats-bar background uses palette index $03.
	bsr		BW_draw_bar															;Draws the stats-bar background rectangle using D4 dimensions and D3.
	btst	#$00,$003E(a5)														;082D0000003E
	bne		adrCd00815C															;66000066
	move.w	$0006(a5),d7														;3E2D0006
	asl.w	#$05,d7																;EB47
	lea		Character_Stats_DataTable.l,a6										;4DF90000EB2A
	lea		$05(a6,d7.w),a6														;4DF67005
	move.l	#$00040019,d5														;2A3C00040019	;Long Addr replaced with Symbol
	add.w	$0008(a5),d5														;DA6D0008
	moveq	#CompactStatsBar_LastIndex,d6										;Initialises the three-bar DBRA loop with terminal index 2.
	moveq	#Player1_CompactStatsColourIndex,d3									;Selects Player 1's hard-coded colour for each compact statistics bar.
	btst	#$00,(a5)															;08150000
	beq.s	Draw_CompactStatsBarsLoop											;6702
	moveq	#Player2_CompactStatsColourIndex,d3									;Selects Player 2's hard-coded colour for each compact statistics bar.
Draw_CompactStatsBarsLoop:		; Memory Address ($811E) and binary offset [$7D9A]
	; Draws the three compact player statistics bars using the player-specific
	; hard-coded colour.
	move.b	(a6)+,d0															;101E
	beq.s	adrCd008132															;6710
	move.b	(a6),d1																;1216
	bsr.s	adrCd00813C															;6116
	movem.l	d3-d6,-(sp)															;48E71E00
	bsr		BW_draw_bar															;6100593C
	movem.l	(sp)+,d3-d6															;4CDF0078
adrCd008132:		; Memory Address ($8132) and binary offset [$7DAE]
	addq.w	#$07,d5																;5E45
	addq.w	#$01,a6																;524E
	dbra	d6,Draw_CompactStatsBarsLoop										;51CEFFE6
	rts																			;4E75

adrCd00813C:		; Memory Address ($813C) and binary offset [$7DB8]
	move.l	#$00220037,d4														;283C00220037
	moveq	#$23,d2																;7423
Scale_ValueToBarLength:		; Memory Address ($8144) and binary offset [$7DC0]
	; Scales D0 against maximum D1 to a D2-pixel bar length. Used here to scale
	; food $00-$C7 across 48 pixels.
	swap	d4																	;4844
	cmp.b	d1,d0																;B001
	bcc.s	adrCd008158															;640E
	and.w	#$00FF,d0															;024000FF
	and.w	#$00FF,d1															;024100FF
	mulu	d2,d0																;C0C2
	divu	d1,d0																;80C1
	move.w	d0,d4																;3800
adrCd008158:		; Memory Address ($8158) and binary offset [$7DD4]
	swap	d4																	;4844
	rts																			;4E75

adrCd00815C:		; Memory Address ($815C) and binary offset [$7DD8]
	moveq	#$0E,d3																;760E
	lea		Character_Stats_DataTable+$05.l,a6									;4DF90000EB2F
	moveq	#$03,d6																;7C03
	move.l	#$00060052,d5														;2A3C00060052
adrLp00816C:		; Memory Address ($816C) and binary offset [$7DE8]
	move.b	$18(a5,d6.w),d0														;10356018
	move.w	d0,d1																;3200
	and.w	#$00E0,d1															;024100E0
	bne.s	adrCd0081C0															;6648
	and.w	#$000F,d0															;0240000F
	asl.w	#$05,d0																;EB40
	move.b	$01(a6,d0.w),d1														;12360001
	move.b	$00(a6,d0.w),d0														;10360000
	beq.s	adrCd0081C0															;6738
	and.w	#$00FF,d0															;024000FF
	moveq	#$14,d4																;7814
	swap	d4																	;4844
	moveq	#$15,d2																;7415
	bsr.s	Scale_ValueToBarLength												;61B0
	swap	d4																	;4844
	moveq	#$2C,d2																;742C
	sub.w	d4,d2																;9444
	swap	d4																	;4844
	move.w	d2,d4																;3802
	movem.l	d3-d6,-(sp)															;48E71E00
	exg		d4,d5																;C945
	add.w	$0008(a5),d5														;DA6D0008
	move.b	$18(a5,d6.w),d0														;10356018
	and.w	#$000F,d0															;0240000F
	bsr		Character_GetClassIndex												;6100E74E
	move.b	ChampionClassBarColours(pc,d0.w),d3									;163B0014
	bsr		BW_draw_bar															;610058AE
	movem.l	(sp)+,d3-d6															;4CDF0078
adrCd0081C0:		; Memory Address ($81C0) and binary offset [$7E3C]
	sub.w	#$0009,d5															;04450009
	dbra	d6,adrLp00816C														;51CEFFA6
adrCd0081C8:		; Memory Address ($81C8) and binary offset [$7E44]
	rts																			;4E75

ChampionClassBarColours:		; Memory Address ($81CA) and binary offset [$7E46]
	; Maps the four champion professions to their main-panel status-bar palette
	; indices.
	dc.b	$06	;06
	dc.b	$0D	;0D
	dc.b	$0C	;0C
	dc.b	$07	;07

Load_MapPosition_AI_TBC:		; Memory Address ($81CE) and binary offset [$7E4A]
	tst.w	$0014(a5)															;4A6D0014
	bne.s	adrCd0081C8															;66F4
	or.b	#$04,$0054(a5)														;002D00040054
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$054C,a0															;D0FC054C
	add.w	$000A(a5),a0														;D0ED000A
	bsr		Load_CurrentChampionStatRecord										;6100E472
	moveq	#$63,d0																;7063
	moveq	#$00,d2																;7400
	move.b	$0011(a4),d2														;142C0011
	bne.s	adrCd00820A															;6614
	move.b	$0013(a4),d2														;142C0013
	bmi.s	adrCd008206															;6B0A
	move.w	d2,d0																;3002
	bsr		Character_GetClassIndex												;6100E700
	add.w	#$0064,d0															;06400064
adrCd008206:		; Memory Address ($8206) and binary offset [$7E82]
	bra		Draw_PocketGraphic													;600048E2

adrCd00820A:		; Memory Address ($820A) and binary offset [$7E86]
	and.w	#$0007,d2															;02420007
	move.b	adrB_00821E(pc,d2.w),d0												;103B200E
	cmpi.w	#$0040,d0															;0C400040
	bne.s	adrCd008206															;66EE
	add.w	$0020(a5),d0														;D06D0020
	bra.s	adrCd008206															;60E8

adrB_00821E:		; Memory Address ($821E) and binary offset [$7E9A]
	dc.b	$3C	;3C
	dc.b	$3D	;3D
	dc.b	$3E	;3E
	dc.b	$3F	;3F
	dc.b	$40	;40
	dc.b	$44	;44
	dc.b	$45	;45
	dc.b	$46	;46

adrL_008226:		; Memory Address ($8226) and binary offset [$7EA2]
	tst.b	$0055(a5)															;4A2D0055
	bpl.s	adrCd008230															;6A04
	bsr		adrCd006D3C															;6100EB0E
adrCd008230:		; Memory Address ($8230) and binary offset [$7EAC]
	move.b	$0034(a5),d0														;102D0034
	bmi.s	adrCd008256															;6B20
	move.b	#$FF,$0034(a5)														;1B7C00FF0034
	lea		Notice_PartyMemberRejoins.w,a6										;4DF841DE	;Short Absolute converted to symbol!
	move.b	d0,(a6)																;1C80
	bsr		Print_timed_message													;61005626
adrCd008246:		; Memory Address ($8246) and binary offset [$7EC2]
	moveq	#$00,d0																;7000
	move.b	$0015(a5),d0														;102D0015
	beq		adrCd008396															;67000148
	subq.b	#$03,d0																;5700
	beq		Refresh_HeldItemDisplay												;6700E9E0
adrCd008256:		; Memory Address ($8256) and binary offset [$7ED2]
	rts																			;4E75

Draw_ChampionNamePanelBackground:		; Memory Address ($8258) and binary offset [$7ED4]
	; Clears the right-hand champion name and display panel before its decorative
	; frame is drawn.
	or.b	#$0C,$0054(a5)														;002D000C0054
	bsr		adrCd00CF96															;61004D36
	move.l	#$005E00E1,d4														;283C005E00E1
	move.l	#$00560009,d5														;2A3C00560009
	add.w	$0008(a5),d5														;DA6D0008
	moveq	#$00,d3																;7600
	bra		BW_draw_bar															;600057F2

Draw_ChampionNamePanelFrame:		; Memory Address ($8278) and binary offset [$7EF4]
	; Draws the champion name-panel bevel, primary-colour name strip, and lower
	; frame lines.
	bsr.s	Draw_ChampionNamePanelBackground									;61DE
	move.w	#$00E2,d4															;383C00E2
	moveq	#$0A,d5																;7A0A
	add.w	$0008(a5),d5														;DA6D0008
	move.l	#$005D0001,d3														;263C005D0001
adrCd00828A:		; Memory Address ($828A) and binary offset [$7F06]
	bsr		BW_blit_horiz_line													;610058F8
	addq.w	#$01,d5																;5245
	addq.w	#$01,d3																;5243
	cmpi.w	#$0005,d3															;0C430005
	bcs.s	adrCd00828A															;65F2
	subq.w	#$04,d3																;5943
	bsr		BW_blit_horiz_line													;610058E8
	move.l	#$00070010,d5														;2A3C00070010
	add.w	$0008(a5),d5														;DA6D0008
	move.l	#$005D00E2,d4														;283C005D00E2
	move.w	$0010(a5),d3														;Loads the active player's primary UI colour for the champion-name background block.
	bsr		BW_draw_bar															;610057B4
	move.w	#$0001,d3															;363C0001
Draw_ChampionNamePanelLowerEdge:		; Memory Address ($82BA) and binary offset [$7F36]
	; Draws the lower decorative edge and adjacent packed status graphics for the
	; champion name panel.
	addq.w	#$01,d5																;5245
	bsr		BW_blit_horiz_line													;610058C6
	addq.w	#$01,d3																;5243
	cmpi.w	#$0005,d3															;0C430005
	bcs.s	Draw_ChampionNamePanelLowerEdge										;65F2
	move.w	$0006(a5),d0														;302D0006
	bsr		adrCd00CF08															;61004C3A
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$0544,a0															;D0FC0544
	add.w	$000A(a5),a0														;D0ED000A
	lea		GFX_Pockets+$67C0.l,a1												;43F900052EC2
	move.l	#$00000080,a3														;267C00000080
	move.l	#$00030015,d5														;2A3C00030015	;Long Addr replaced with Symbol
	bsr		Draw_PlanarGraphic													;610049C6
	add.w	#$0028,a0															;D0FC0028
	lea		GFX_Pockets+$67E0.l,a1												;43F900052EE2
	btst	#$00,(a5)															;08150000
	bne.s	adrCd008308															;6604
	add.w	#$0020,a1															;D2FC0020
adrCd008308:		; Memory Address ($8308) and binary offset [$7F84]
	move.l	#$0003001E,d5														;2A3C0003001E	;Long Addr replaced with Symbol
	bsr		Draw_PlanarGraphic													;610049A8
	bsr		Load_MapPosition_AI_TBC												;6100FEBA
	move.w	#$0062,d0															;303C0062
	bsr		Draw_PocketGraphic													;610047CE
	moveq	#$20,d5																;7A20
	add.w	$0008(a5),d5														;DA6D0008
	move.w	#$0120,d4															;383C0120
	move.l	#$001F0001,d3														;263C001F0001
	bsr		BW_blit_horiz_line													;61005854
	add.w	#$0011,d5															;06450011
	bsr		BW_blit_horiz_line													;6100584C
	addq.w	#$02,d5																;5445
Draw_DungeonDisplayLowerEdge:		; Memory Address ($833C) and binary offset [$7FB8]
	; Completes the lower dungeon-display edge with procedural lines before drawing
	; the continuous chain strip.
	bsr		BW_blit_horiz_line													;61005846
	addq.w	#$01,d5																;5245
	addq.w	#$01,d3																;5243
	cmpi.w	#$0005,d3															;0C430005
	bcs.s	Draw_DungeonDisplayLowerEdge										;65F2
	subq.w	#$04,d3																;5943
	bsr		BW_blit_horiz_line													;61005836
	bsr.s	adrCd008396															;6144
	move.l	#$00000E04,a0														;207C00000E04	;Long Addr replaced with Symbol
adrCd008358:		; Memory Address ($8358) and binary offset [$7FD4]
	move.l	#$00000070,a3														;267C00000070
	lea		GFX_Pockets+$3C00.l,a1												;43F900050302
	move.l	#$00050006,d5														;2A3C00050006	;Long Addr replaced with Symbol
	add.l	screen_ptr.l,a0														;D1F900008D36
	add.w	$000A(a5),a0														;D0ED000A
	bra		Draw_PlanarGraphic													;60004942

;fiX Label expected
	move.w	d0,d2																;3400
	and.w	#$0003,d0															;02400003
	asl.w	#$02,d0																;E540
	and.w	#$000C,d2															;0242000C
	lsr.w	#$02,d2																;E44A
	add.w	d2,d0																;D042
	add.w	#$0050,d0															;06400050
adrCd00838C:		; Memory Address ($838C) and binary offset [$8008]
	rts																			;4E75

adrW_00838E:		; Memory Address ($838E) and binary offset [$800A]
	dc.w	$08E4	;08E4
	dc.w	$0000	;0000
	dc.w	$0256	;0256
	dc.w	$FFFC	;FFFC

adrCd008396:		; Memory Address ($8396) and binary offset [$8012]
	btst	#$06,$0018(a5)														;082D00060018
	bne.s	adrCd00838C															;66EE
	or.b	#$04,$0054(a5)														;002D00040054
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	$000A(a5),a0														;D0ED000A
	moveq	#$00,d7																;7E00
adrCd0083B0:		; Memory Address ($83B0) and binary offset [$802C]
	move.w	d7,d2																;3407
	add.w	d2,d2																;D442
	add.w	adrW_00838E(pc,d2.w),a0												;D0FB20D8
	move.b	$26(a5,d7.w),d0														;10357026
	bpl.s	adrCd0083C4															;6A06
	bsr		adrCd008462															;610000A2
	bra.s	adrCd0083D4															;6010

adrCd0083C4:		; Memory Address ($83C4) and binary offset [$8040]
	cmp.w	$0016(a5),d7														;BE6D0016
	beq.s	adrCd0083D0															;6706
	bsr		adrCd008430															;61000064
	bra.s	adrCd0083D4															;6004

adrCd0083D0:		; Memory Address ($83D0) and binary offset [$804C]
	bsr		adrCd00842C															;6100005A
adrCd0083D4:		; Memory Address ($83D4) and binary offset [$8050]
	addq.w	#$01,d7																;5247
	cmpi.w	#$0004,d7															;0C470004
	bcs.s	adrCd0083B0															;65D4
	move.w	$0006(a5),d0														;302D0006
	bsr		adrCd004092															;6100BCB0
	move.w	$0010(a5),d3														;Loads the active player's primary UI colour for the selected team-member frame.
	move.l	#$000F0121,d4														;283C000F0121
	move.l	#$000D0039,d5														;2A3C000D0039
	add.w	$0008(a5),d5														;DA6D0008
	btst	#$01,d2																;08020001
	beq.s	adrCd008402															;6704
	add.w	#$000F,d5															;0645000F
adrCd008402:		; Memory Address ($8402) and binary offset [$807E]
	move.b	adrB_008412(pc,d2.w),d2												;143B200E
	beq.s	adrCd00840E															;6706
	sub.l	#$0000FFF0,d4														;04840000FFF0	;Long Addr replaced with Symbol
adrCd00840E:		; Memory Address ($840E) and binary offset [$808A]
	bra		BW_draw_frame														;600056C4

adrB_008412:		; Memory Address ($8412) and binary offset [$808E]
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$01	;01
	dc.b	$00	;00

adrCd008416:		; Memory Address ($8416) and binary offset [$8092]
	move.b	$18(a5,d7.w),d0														;10357018
	and.w	#$00EF,d0															;024000EF
	bmi.s	adrCd008462															;6B42
	btst	#$05,d0																;08000005
	bne.s	adrCd008462															;663C
	btst	#$06,d0																;08000006
	beq.s	adrCd008430															;6704
adrCd00842C:		; Memory Address ($842C) and binary offset [$80A8]
	moveq	#$00,d6																;7C00
	bra.s	adrCd00843E															;600E

adrCd008430:		; Memory Address ($8430) and binary offset [$80AC]
	move.w	d0,d1																;3200
	bsr		Character_GetClassIndex												;6100E4CC
	move.w	d0,d6																;3C00
	move.w	d1,d0																;3001
	addq.w	#$01,d6																;5246
	asl.w	#$02,d6																;E546
adrCd00843E:		; Memory Address ($843E) and binary offset [$80BA]
	lea		adrEA00846A.l,a6													;4DF90000846A
	add.w	d6,a6																;DCC6
	and.w	#$0003,d0															;02400003
	add.w	#$004B,d0															;0640004B
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l									;33FCFFFF0000B4BE
	bsr		Draw_PocketGraphic													;61004692
	clr.w	Buffer_Colour_Mask_Toggle.l											;42790000B4BE
	rts																			;4E75

adrCd008462:		; Memory Address ($8462) and binary offset [$80DE]
	move.w	#$003B,d0															;303C003B
	bra		Draw_PocketGraphic													;60004682

adrEA00846A:		; Memory Address ($846A) and binary offset [$80E6]
	dc.w	$0004	;0004
	dc.w	$030E	;030E
ClassColours:		; Memory Address ($846E) and binary offset [$80EA]
	; Four colour-mask records used when composing champion shield avatars.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Champion_Class.colours"

adrCd00847E:		; Memory Address ($847E) and binary offset [$80FA]
	move.l	$001C(a5),d7														;2E2D001C
adrCd008482:		; Memory Address ($8482) and binary offset [$80FE]
	move.w	$0020(a5),d0														;302D0020
adrCd008486:		; Memory Address ($8486) and binary offset [$8102]
	lea		MovementOffsetTable.w,a0											;41F85794	;Short Absolute converted to symbol!
	add.b	$08(a0,d0.w),d7														;DE300008
	swap	d7																	;4847
	add.b	$00(a0,d0.w),d7														;DE300000
	swap	d7																	;4847
	bra.s	CoordToMap															;6004

adrCd008498:		; Memory Address ($8498) and binary offset [$8114]
	move.l	$001C(a5),d7														;2E2D001C
CoordToMap:
	move.l	Current_TowerMapDataBase.l,a6										;2C790000EE78
adrCd0084A2:		; Memory Address ($84A2) and binary offset [$811E]
	move.w	d7,d0																;3007
	mulu	adrW_00EE70.l,d0													;C0F90000EE70
	swap	d7																	;4847
	add.w	d7,d0																;D047
	swap	d7																	;4847
	add.w	d0,d0																;D040
	add.w	adrW_00EE76.l,d0													;D0790000EE76
	rts																			;4E75

adrCd0084BA:		; Memory Address ($84BA) and binary offset [$8136]
	lea		adrEA00EE60.l,a0													;41F90000EE60
	add.b	$08(a0,d2.w),d7														;DE302008
	swap	d7																	;4847
	add.b	$00(a0,d2.w),d7														;DE302000
	sub.b	$00(a0,d1.w),d7														;9E301000
	swap	d7																	;4847
	sub.b	$08(a0,d1.w),d7														;9E301008
	rts																			;4E75

adrCd0084D6:		; Memory Address ($84D6) and binary offset [$8152]
	move.w	$0058(a5),d0														;302D0058
adrCd0084DA:		; Memory Address ($84DA) and binary offset [$8156]
	lea		Current_TowerMapHeaderCache.l,a0									;41F90000EE40
	move.b	$00(a0,d0.w),adrB_00EE71.l											;13F000000000EE71
	move.b	$08(a0,d0.w),adrB_00EE73.l											;13F000080000EE73
	add.w	d0,d0																;D040
	move.w	$10(a0,d0.w),adrW_00EE76.l											;33F000100000EE76
	rts																			;4E75

adrCd0084FC:		; Memory Address ($84FC) and binary offset [$8178]
	moveq	#-$01,d1															;72FF
	moveq	#$00,d2																;7400
	move.w	adrW_00EE76.l,d2													;34390000EE76
	lea		adrEA00EE50.l,a0													;41F90000EE50
adrCd00850C:		; Memory Address ($850C) and binary offset [$8188]
	addq.w	#$01,d1																;5241
	cmp.w	(a0)+,d2															;B458
	bne.s	adrCd00850C															;66FA
	sub.w	d0,d2																;9440
	neg.w	d2																	;4442
	lsr.w	#$01,d2																;E24A
	divu	adrW_00EE70.l,d2													;84F90000EE70
	rts																			;4E75

adrL_008520:		; Memory Address ($8520) and binary offset [$819C]
	ds.b	$4
adrLp008524:		; Memory Address ($8524) and binary offset [$81A0]
	bsr		adrCd008534															;6100000E
	bsr		adrCd008726															;610001FC
	addq.w	#$02,d0																;5440
	dbra	d7,adrLp008524														;51CFFFF4
	rts																			;4E75

adrCd008534:		; Memory Address ($8534) and binary offset [$81B0]
	movem.l	d0-d7/a1-a4,-(sp)													;48E7FF78
	move.l	adrL_008520.l,a1													;227900008520
	move.w	#$00F9,d6															;3C3C00F9
adrLp008542:		; Memory Address ($8542) and binary offset [$81BE]
	move.l	#$AAAAAAAA,(a1)+													;22FCAAAAAAAA
	dbra	d6,adrLp008542														;51CEFFF8
	moveq	#$0A,d3																;760A
	moveq	#$0B,d2																;740B
adrLp008550:		; Memory Address ($8550) and binary offset [$81CC]
	move.l	a1,a6																;2C49
	move.l	#$AAAAAAAA,(a1)+													;22FCAAAAAAAA
	move.l	#$44894489,(a1)+													;22FC44894489
	move.b	#$FF,d7																;1E3C00FF
	asl.l	#$08,d7																;E187
	move.b	d0,d7																;1E00
	asl.l	#$08,d7																;E187
	move.b	d1,d7																;1E01
	asl.l	#$08,d7																;E187
	move.b	d2,d7																;1E02
	move.l	a1,a2																;2449
	move.l	d7,d6																;2C07
	and.l	#$AAAAAAAA,d6														;0286AAAAAAAA
	lsr.l	#$01,d6																;E28E
	move.l	d6,(a1)+															;22C6
	and.l	#$55555555,d7														;028755555555
	move.l	d7,(a1)+															;22C7
	moveq	#$01,d5																;7A01
	bsr		adrCd00868A															;61000102
	eor.l	d6,d7																;BD87
	move.l	a1,a2																;2449
	clr.l	(a1)+																;4299
	clr.l	(a1)+																;4299
	clr.l	(a1)+																;4299
	clr.l	(a1)+																;4299
	clr.l	(a1)+																;4299
	clr.l	(a1)+																;4299
	clr.l	(a1)+																;4299
	clr.l	(a1)+																;4299
	move.l	d7,d6																;2C07
	and.l	#$AAAAAAAA,d6														;0286AAAAAAAA
	lsr.l	#$01,d6																;E28E
	move.l	d6,(a1)+															;22C6
	and.l	#$55555555,d7														;028755555555
	move.l	d7,(a1)+															;22C7
	moveq	#$05,d5																;7A05
	bsr		adrCd00868A															;610000D4
	move.l	a1,a3																;2649
	addq.l	#$08,a1																;5089
	move.l	a1,a4																;2849
	moveq	#$7F,d5																;7A7F
	moveq	#$00,d4																;7800
adrLp0085C2:		; Memory Address ($85C2) and binary offset [$823E]
	move.l	(a0)+,d7															;2E18
	move.l	d7,d6																;2C07
	and.l	#$AAAAAAAA,d6														;0286AAAAAAAA
	lsr.l	#$01,d6																;E28E
	and.l	#$55555555,d7														;028755555555
	move.l	d7,$0200(a1)														;23470200
	move.l	d6,(a1)+															;22C6
	eor.l	d6,d4																;BD84
	eor.l	d7,d4																;BF84
	dbra	d5,adrLp0085C2														;51CDFFE2
	move.l	d4,d7																;2E04
	and.l	#$AAAAAAAA,d4														;0284AAAAAAAA
	lsr.l	#$01,d4																;E28C
	and.l	#$55555555,d7														;028755555555
	move.l	a3,a2																;244B
	move.l	d4,(a3)+															;26C4
	move.l	d7,(a3)																;2687
	moveq	#$01,d5																;7A01
	bsr		adrCd00868A															;6100008E
	move.l	a4,a2																;244C
	move.w	#$0080,d5															;3A3C0080
	bsr		adrCd00868A															;61000084
	addq.b	#$01,d1																;5201
	subq.b	#$01,d2																;5302
	add.l	#$00000200,a1														;D3FC00000200
	dbra	d3,adrLp008550														;51CBFF3C
	move.l	#$AAAAAAAA,(a1)														;22BCAAAAAAAA
	move.w	#$0002,_custom+intreq.l												;33FC000200DFF09C
	move.l	adrL_008520.l,a1													;227900008520
	move.l	a1,_custom+dskpt.l													;23C900DFF020
	move.w	#$8210,_custom+dmacon.l												;33FC821000DFF096
	move.w	#$7700,_custom+adkcon.l												;33FC770000DFF09E
	move.w	#$9100,_custom+adkcon.l												;33FC910000DFF09E
	move.w	#$4000,_custom+dsklen.l												;33FC400000DFF024
	move.b	_ciab+ciaicr.l,d0													;103900BFDD00
adrCd008656:		; Memory Address ($8656) and binary offset [$82D2]
	move.b	_ciab+ciaicr.l,d0													;103900BFDD00
	btst	#$04,d0																;08000004
	beq.s	adrCd008656															;67F4
	move.w	#$D955,_custom+dsklen.l												;33FCD95500DFF024
	move.w	#$D955,_custom+dsklen.l												;33FCD95500DFF024
adrCd008672:		; Memory Address ($8672) and binary offset [$82EE]
	move.w	_custom+intreqr.l,d0												;303900DFF01E
	btst	#$01,d0																;08000001
	beq.s	adrCd008672															;67F4
	movem.l	(sp)+,d0-d7/a1-a4													;4CDF1EFF
	bsr		adrCd00886A															;610001E6
	bra		adrCd0086D2															;6000004A

adrCd00868A:		; Memory Address ($868A) and binary offset [$8306]
	movem.l	d0-d5/a2,-(sp)														;48E7FC20
	add.w	d5,d5																;DA45
	subq.w	#$01,d5																;5345
	move.b	-$0001(a2),d0														;102AFFFF
adrLp008696:		; Memory Address ($8696) and binary offset [$8312]
	move.l	(a2),d4																;2812
	move.l	d4,d1																;2204
	move.l	d4,d2																;2404
	not.l	d1																	;4681
	and.l	#$55555555,d1														;028155555555
	asl.l	#$01,d1																;E381
	move.l	d1,d3																;2601
	roxr.b	#$01,d0																;E210
	roxr.l	#$01,d4																;E294
	eor.l	d4,d1																;B981
	and.l	d3,d1																;C283
	or.l	d1,d2																;8481
	move.l	d2,(a2)+															;24C2
	move.b	d2,d0																;1002
	dbra	d5,adrLp008696														;51CDFFDE
	movem.l	(sp)+,d0-d5/a2														;4CDF043F
	rts																			;4E75

adrCd0086C0:		; Memory Address ($86C0) and binary offset [$833C]
	move.l	a0,-(sp)															;2F08
adrLp0086C2:		; Memory Address ($86C2) and binary offset [$833E]
	bsr		adrCd0087A6															;610000E2
	bsr		adrCd008726															;6100005E
	dbra	d0,adrLp0086C2														;51C8FFF6
	move.l	(sp)+,a0															;205F
	rts																			;4E75

adrCd0086D2:		; Memory Address ($86D2) and binary offset [$834E]
	btst	#$05,_ciaa.l														;0839000500BFE001
	bne.s	adrCd0086D2															;66F6
	rts																			;4E75

;fiX Label expected
	st		adrB_0088A2.l														;50F9000088A2
	move.b	#$79,_ciab+ciaprb.l													;13FC007900BFD100
	nop																			;4E71
	nop																			;4E71
	move.b	#$71,_ciab+ciaprb.l													;13FC007100BFD100
	move.w	#$B000,d0															;303CB000
adrLp0086FC:		; Memory Address ($86FC) and binary offset [$8378]
	dbra	d0,adrLp0086FC														;51C8FFFE
	rts																			;4E75

adrCd008702:		; Memory Address ($8702) and binary offset [$837E]
	clr.b	adrB_0088A2.l														;4239000088A2
	move.b	#$7D,_ciab+ciaprb.l													;13FC007D00BFD100
	nop																			;4E71
	nop																			;4E71
	move.b	#$75,_ciab+ciaprb.l													;13FC007500BFD100
	move.w	#$B000,d0															;303CB000

adrLp008720:		; Memory Address ($8720) and binary offset [$839C]
	dbra	d0,adrLp008720														;51C8FFFE
	rts																			;4E75

adrCd008726:		; Memory Address ($8726) and binary offset [$83A2]
	tst.b	adrB_0088A2.l														;4A39000088A2
	beq.s	adrCd008744															;6716
	move.b	#$70,_ciab+ciaprb.l													;13FC007000BFD100
	nop																			;4E71
	nop																			;4E71
	move.b	#$71,_ciab+ciaprb.l													;13FC007100BFD100
	bra.s	adrCd008758															;6014

adrCd008744:		; Memory Address ($8744) and binary offset [$83C0]
	move.b	#$74,_ciab+ciaprb.l													;13FC007400BFD100
	nop																			;4E71
	nop																			;4E71
	move.b	#$75,_ciab+ciaprb.l													;13FC007500BFD100
adrCd008758:		; Memory Address ($8758) and binary offset [$83D4]
	bsr		adrCd00886A															;61000110
	bra		adrCd0086D2															;6000FF74

adrCd008760:		; Memory Address ($8760) and binary offset [$83DC]
	tst.b	adrB_0088A2.l														;4A39000088A2
	beq.s	adrCd00877E															;6716
	move.b	#$72,_ciab+ciaprb.l													;13FC007200BFD100
	nop																			;4E71
	nop																			;4E71
	move.b	#$73,_ciab+ciaprb.l													;13FC007300BFD100
	bra.s	adrCd008792															;6014

adrCd00877E:		; Memory Address ($877E) and binary offset [$83FA]
	move.b	#$76,_ciab+ciaprb.l													;13FC007600BFD100
	nop																			;4E71
	nop																			;4E71
	move.b	#$77,_ciab+ciaprb.l													;13FC007700BFD100
adrCd008792:		; Memory Address ($8792) and binary offset [$840E]
	bsr		adrCd00886A															;610000D6
	bra		adrCd0086D2															;6000FF3A

;fiX Label expected
	subq.w	#$01,d6																;5346
	beq		adrCd00884A															;670000AC
	bsr		adrCd00886A															;610000C8
	bra.s	adrCd0087AC															;6006

adrCd0087A6:		; Memory Address ($87A6) and binary offset [$8422]
	movem.l	d0-d2/d5/d6/a1,-(sp)												;48E7E640
	moveq	#$03,d6																;7C03
adrCd0087AC:		; Memory Address ($87AC) and binary offset [$8428]
	move.w	#$0002,_custom+intreq.l												;33FC000200DFF09C
	move.l	adrL_008520.l,a1													;227900008520
	clr.l	$0002(a1)															;42A90002
	move.l	a1,_custom+dskpt.l													;23C900DFF020
	move.w	#$8010,_custom+dmacon.l												;33FC801000DFF096
	move.w	#$4489,_custom+dsksync.l											;33FC448900DFF07E
	move.w	#$9500,_custom+adkcon.l												;33FC950000DFF09E
	move.w	#$4000,_custom+dsklen.l												;33FC400000DFF024
	move.b	_ciab+ciaicr.l,d0													;103900BFDD00
adrCd0087EA:		; Memory Address ($87EA) and binary offset [$8466]
	move.b	_ciab+ciaicr.l,d0													;103900BFDD00
	btst	#$04,d0																;08000004
	beq.s	adrCd0087EA															;67F4
	move.w	#$9F40,_custom+dsklen.l												;33FC9F4000DFF024
	move.w	#$9F40,_custom+dsklen.l												;33FC9F4000DFF024
	move.l	#DiskReadTimeoutCount,d1											;Disk-read timeout counter used while waiting for DMA completion.
adrCd00880C:		; Memory Address ($880C) and binary offset [$8488]
	move.w	_custom+intreqr.l,d0												;303900DFF01E
	btst	#$01,d0																;08000001
	bne.s	adrCd00881C															;6604
	subq.l	#$01,d1																;5381
	bne.s	adrCd00880C															;66F0
adrCd00881C:		; Memory Address ($881C) and binary offset [$8498]
	moveq	#$0A,d5																;7A0A
	lea		$003A(a1),a1														;43E9003A
adrLp008822:		; Memory Address ($8822) and binary offset [$849E]
	moveq	#$7F,d6																;7C7F
adrLp008824:		; Memory Address ($8824) and binary offset [$84A0]
	move.l	$0200(a1),d1														;22290200
	move.l	(a1)+,d0															;2019
	asl.l	#$01,d0																;E380
	and.l	#$AAAAAAAA,d0														;0280AAAAAAAA
	and.l	#$55555555,d1														;028155555555
	or.l	d1,d0																;8081
	move.l	d0,(a0)+															;20C0
	dbra	d6,adrLp008824														;51CEFFE6
	add.l	#$00000240,a1														;D3FC00000240
	dbra	d5,adrLp008822														;51CDFFDA
adrCd00884A:		; Memory Address ($884A) and binary offset [$84C6]
	movem.l	(sp)+,d0-d2/d5/d6/a1												;4CDF0267
	rts																			;4E75

adrCd008850:		; Memory Address ($8850) and binary offset [$84CC]
	move.b	_ciaa.l,d0															;103900BFE001
	btst	#$04,d0																;08000004
	beq.s	adrCd008866															;670A
	bsr		adrCd008760															;6100FF02
	bsr		adrCd00886A															;61000008
	bra.s	adrCd008850															;60EA

adrCd008866:		; Memory Address ($8866) and binary offset [$84E2]
	bra		adrCd0086D2															;6000FE6A

adrCd00886A:		; Memory Address ($886A) and binary offset [$84E6]
	move.l	d7,-(sp)															;2F07
	move.w	#$0960,d7															;3E3C0960
adrLp008870:		; Memory Address ($8870) and binary offset [$84EC]
	dbra	d7,adrLp008870														;51CFFFFE
	move.l	(sp)+,d7															;2E1F
	rts																			;4E75

adrCd008878:		; Memory Address ($8878) and binary offset [$84F4]
	move.b	#$FD,_ciab+ciaprb.l													;13FC00FD00BFD100
	nop																			;4E71
	nop																			;4E71
	move.b	#$F5,_ciab+ciaprb.l													;13FC00F500BFD100
	rts																			;4E75

adrCd00888E:		; Memory Address ($888E) and binary offset [$850A]
	move.l	d7,-(sp)															;2F07
	bsr.s	adrCd008850															;61BE
	subq.w	#$01,d7																;5347
	bcs.s	adrCd00889E															;6508
adrLp008896:		; Memory Address ($8896) and binary offset [$8512]
	bsr		adrCd008726															;6100FE8E
	dbra	d7,adrLp008896														;51CFFFFA
adrCd00889E:		; Memory Address ($889E) and binary offset [$851A]
	move.l	(sp)+,d7															;2E1F
	rts																			;4E75

adrB_0088A2:		; Memory Address ($88A2) and binary offset [$851E]
	ds.b	$2
adrL_0088A4:		; Memory Address ($88A4) and binary offset [$8520]
	move.w	#$0001,_custom+dmacon.l												;33FC000100DFF096
	move.w	#$0080,_custom+intena.l												;33FC008000DFF09A
	move.w	#$0080,_custom+intreq.l												;33FC008000DFF09C
	rte																			;4E73
	
PlaySound:
	move.w	d1,-(sp)															;3F01
	move.w	#$0001,_custom+dmacon.l												;33FC000100DFF096
	move.w	#$0080,_custom+intena.l												;33FC008000DFF09A
	asl.w	#$02,d0																;Converts the zero-based sound ID into a four-byte index for the sample-offset and playback-period table.
	lea		SFX_AudioSample_1.l,a0												;41F900054422
	add.w	AudioSampleOffsets(pc,d0.w),a0										;Adds the selected sample base offset to locate the sound data.
	move.w	AudioSampleOffsets+$2(pc,d0.w),d0									;Loads the selected Paula playback-period value.
	lea		$0030(a0),a0														;Skips the 8SVX header and points Paula at the sample body.
	move.w	-$0002(a0),d1														;Reads the sample-body length stored immediately before the sample data.
	lsr.w	#$01,d1																;E249
	asl.w	#$02,d0																;Converts the zero-based sound ID into a four-byte index for the sample-offset and playback-period table.
	move.l	a0,_custom+aud.l													;23C800DFF0A0
	move.w	d1,_custom+aud0+ac_len.l											;Programs Paula channel 0 with the selected sample length.
	move.w	#$0040,_custom+aud0+ac_vol.l										;Sets Paula channel 0 to maximum volume used by this routine.
	move.w	d0,_custom+aud0+ac_per.l											;Programs the selected sample playback period.
	move.w	(a0),_custom+aud0+ac_dat.l											;Loads the first sample word into Paula channel 0's data register.
	move.w	#$0078,d1															;323C0078
.soundloop1:		; Memory Address ($8910) and binary offset [$858C]
	dbra	d1,.soundloop1														;51C9FFFE
	move.w	#$8001,_custom+dmacon.l												;Enables DMA for Paula channel 0 and its audio master control.
	move.w	#$0078,d1															;323C0078
.soundloop2:		; Memory Address ($8920) and binary offset [$859C]
	dbra	d1,.soundloop2														;51C9FFFE
	move.w	#$0080,_custom+intreq.l												;Clears the pending audio interrupt request after playback.
	move.w	#$8080,_custom+intena.l												;33FC808000DFF09A
	move.w	(sp)+,d1															;321F
	rts																			;4E75

AudioSampleOffsets:		; Memory Address ($8938) and binary offset [$85B4]
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

adrW_008950:		; Memory Address ($8950) and binary offset [$85CC]
	ds.b	$2
MouseControl:		; Memory Address ($8952) and binary offset [$85CE]
	move.w	_custom+joy0dat.l,d0												;303900DFF00A
	move.w	adrW_008950.l,d1													;323900008950
	move.w	d0,adrW_008950.l													;33C000008950
	bsr		adrCd008A0A															;610000A4
	ror.w	#$08,d0																;E058
	ror.w	#$08,d1																;E059
	bsr		adrCd008A0A															;6100009C
	lea		Player1_Data.l,a5													;4BF90000EE7C
	move.w	$0004(a5),d1														;322D0004
	moveq	#$00,d2																;7400
	move.b	d0,d2																;1400
	ext.w	d2																	;4882
	add.w	d2,d1																;D242
	bpl.s	adrCd008986															;6A02
	moveq	#$00,d1																;7200
adrCd008986:		; Memory Address ($8986) and binary offset [$8602]
	cmp.b	$003B(a5),d1														;B22D003B
	bcc.s	adrCd008990															;6404
	move.b	$003B(a5),d1														;122D003B
adrCd008990:		; Memory Address ($8990) and binary offset [$860C]
	cmp.b	$003A(a5),d1														;B22D003A
	bcs.s	adrCd00899A															;6504
	move.b	$003A(a5),d1														;122D003A
adrCd00899A:		; Memory Address ($899A) and binary offset [$8616]
	move.w	d1,$0004(a5)														;3B410004
	lsr.w	#$08,d0																;E048
	ext.w	d0																	;4880
	move.w	$0002(a5),d1														;322D0002
	add.w	d0,d1																;D240
	bpl.s	adrCd0089AE															;6A04
	add.w	#$0140,d1															;06410140
adrCd0089AE:		; Memory Address ($89AE) and binary offset [$862A]
	cmpi.w	#$0140,d1															;0C410140
	bcs.s	adrCd0089B8															;6504
	sub.w	#$0140,d1															;04410140
adrCd0089B8:		; Memory Address ($89B8) and binary offset [$8634]
	move.w	d1,$0002(a5)														;3B410002
	move.l	$0002(a5),d1														;222D0002
	lea		SpritePosition_00.l,a0												;41F900008E84
	bsr		adrCd008A50															;61000088
	lea		SpritePosition_01.l,a0												;41F900008F14
	move.l	#$FF81FFC9,d1														;223CFF81FFC9
	bsr		adrCd008A50															;61000078
	move.b	_ciaa.l,d1															;123900BFE001
	not.b	d1																	;4601
	and.w	#$0040,d1															;02410040
	rol.b	#$01,d1																;E319
	lea		adrEA008AFC.l,a0													;41F900008AFC
	tst.b	d1																	;4A01
	bpl.s	adrCd0089F6															;6A04
	tst.b	(a0)																;4A10
	bmi.s	adrCd008A08															;6B12
adrCd0089F6:		; Memory Address ($89F6) and binary offset [$8672]
	move.b	d1,(a0)																;1081
	tst.b	d1																	;4A01
	bpl.s	adrCd008A08															;6A0C
	tst.b	$0001(a5)															;4A2D0001
	bmi.s	adrCd008A08															;6B06
	bset	#$07,$0001(a5)														;08ED00070001
adrCd008A08:		; Memory Address ($8A08) and binary offset [$8684]
	rts																			;4E75

adrCd008A0A:		; Memory Address ($8A0A) and binary offset [$8686]
	sub.b	d1,d0																;9001
	bcc.s	adrCd008A14															;6406
	tst.b	d0																	;4A00
	bmi.s	adrCd008A1A															;6B08
	bra.s	adrCd008A18															;6004

adrCd008A14:		; Memory Address ($8A14) and binary offset [$8690]
	tst.b	d0																	;4A00
	bpl.s	adrCd008A1A															;6A02
adrCd008A18:		; Memory Address ($8A18) and binary offset [$8694]
	neg.b	d0																	;4400
adrCd008A1A:		; Memory Address ($8A1A) and binary offset [$8696]
	rts																			;4E75

InputControls:		; Memory Address ($8A1C) and binary offset [$8698]
	tst.w	MultiPlayer.l														;4A790000EE30
	bne		MouseControl														;6600FF2E
	bsr		JoystickControl														;610000D6
	move.w	(a0),d0																;3010
	lea		Player2_Data.l,a5													;4BF90000EEDE
	bsr		adrCd008A98															;61000064
	lea		SpritePosition_01.l,a0												;41F900008F14
	bsr.s	adrCd008A50															;6112
	lsr.w	#$08,d0																;E048
	lea		Player1_Data.l,a5													;4BF90000EE7C
	bsr		adrCd008A98															;61000050
	lea		SpritePosition_00.l,a0												;41F900008E84
adrCd008A50:		; Memory Address ($8A50) and binary offset [$86CC]
	add.w	#$0037,d1															;06410037
	move.b	d1,(a0)																;1081
	move.b	d1,$0048(a0)														;11410048
	move.w	d1,d2																;3401
	add.w	#$0010,d1															;06410010
	move.b	d1,$0002(a0)														;11410002
	move.b	d1,$004A(a0)														;1141004A
	ror.w	#$07,d1																;EE59
	ror.w	#$06,d2																;EC5A
	and.w	#$0004,d2															;02420004
	and.w	#$0002,d1															;02410002
	or.b	d1,d2																;8401
	swap	d1																	;4841
	add.w	#$0080,d1															;06410080
	ror.w	#$01,d1																;E259
	move.b	d1,$0001(a0)														;11410001
	move.b	d1,$0049(a0)														;11410049
	rol.w	#$01,d1																;E359
	and.w	#$0001,d1															;02410001
	or.b	d2,d1																;8202
	move.b	d1,$0003(a0)														;11410003
	move.b	d1,$004B(a0)														;1141004B
	rts																			;4E75

adrCd008A98:		; Memory Address ($8A98) and binary offset [$8714]
	move.l	$0002(a5),d1														;222D0002
	lsr.b	#$01,d0																;E208
	bcc.s	adrCd008AAA															;640A
	subq.w	#$02,d1																;5541
	cmp.b	$003B(a5),d1														;B22D003B
	bcc.s	adrCd008AAA															;6402
	addq.w	#$02,d1																;5441
adrCd008AAA:		; Memory Address ($8AAA) and binary offset [$8726]
	lsr.b	#$01,d0																;E208
	bcc.s	adrCd008AB8															;640A
	addq.w	#$02,d1																;5441
	cmp.b	$003A(a5),d1														;B22D003A
	bcs.s	adrCd008AB8															;6502
	subq.w	#$02,d1																;5541
adrCd008AB8:		; Memory Address ($8AB8) and binary offset [$8734]
	swap	d1																	;4841
	lsr.b	#$01,d0																;E208
	bcc.s	adrCd008AC6															;6408
	subq.w	#$02,d1																;5541
	bcc.s	adrCd008AC6															;6404
	add.w	#$0140,d1															;06410140
adrCd008AC6:		; Memory Address ($8AC6) and binary offset [$8742]
	lsr.b	#$01,d0																;E208
	bcc.s	adrCd008ACC															;6402
	addq.w	#$02,d1																;5441
adrCd008ACC:		; Memory Address ($8ACC) and binary offset [$8748]
	cmpi.w	#$0140,d1															;0C410140
	bcs.s	adrCd008AD6															;6504
	sub.w	#$0140,d1															;04410140
adrCd008AD6:		; Memory Address ($8AD6) and binary offset [$8752]
	swap	d1																	;4841
	move.l	d1,$0002(a5)														;2B410002
	rts																			;4E75

adrCd008ADE:		; Memory Address ($8ADE) and binary offset [$875A]
	move.w	d0,d1																;3200
	ror.w	#$01,d0																;E258
	eor.w	d0,d1																;B141
	moveq	#$00,d2																;7400
	lsr.w	#$01,d0																;E248
	addx.b	d2,d2																;D502
	add.b	d0,d0																;D000
	addx.b	d2,d2																;D502
	lsr.w	#$01,d1																;E249
	addx.b	d2,d2																;D502
	add.b	d1,d1																;D201
	addx.b	d2,d2																;D502
	move.w	d2,d0																;3002
	rts																			;4E75

adrEA008AFA:		; Memory Address ($8AFA) and binary offset [$8776]
	ds.b	$2
adrEA008AFC:		; Memory Address ($8AFC) and binary offset [$8778]
	ds.b	$2
JoystickControl:		; Memory Address ($8AFE) and binary offset [$877A]
	move.w	_custom+joy0dat.l,d0												;303900DFF00A
	bsr.s	adrCd008ADE															;61D8
	move.b	_ciaa.l,d1															;123900BFE001
	not.b	d1																	;4601
	and.w	#$0040,d1															;02410040
	rol.b	#$01,d1																;E319
	or.b	d1,d0																;8001
	swap	d0																	;4840
	move.w	_custom+joy1dat.l,d0												;303900DFF00C
	bsr.s	adrCd008ADE															;61BE
	move.b	_ciaa.l,d1															;123900BFE001
	not.b	d1																	;4601
	and.b	#$80,d1																;02010080
	or.b	d1,d0																;8001
	lea		adrEA008AFA.l,a0													;41F900008AFA
	lea		Player2_Data.l,a5													;4BF90000EEDE
	moveq	#$01,d1																;7201
adrLp008B3C:		; Memory Address ($8B3C) and binary offset [$87B8]
	tst.b	$02(a0,d1.w)														;4A301002
	bpl.s	adrCd008B4C															;6A0A
	move.b	d0,$02(a0,d1.w)														;11801002
	and.b	#$7F,d0																;0200007F
	bra.s	adrCd008B50															;6004

adrCd008B4C:		; Memory Address ($8B4C) and binary offset [$87C8]
	move.b	d0,$02(a0,d1.w)														;11801002
adrCd008B50:		; Memory Address ($8B50) and binary offset [$87CC]
	move.b	d0,$00(a0,d1.w)														;11801000
	tst.b	d0																	;4A00
	bpl.s	adrCd008B64															;6A0C
	tst.b	$0001(a5)															;4A2D0001
	bmi.s	adrCd008B64															;6B06
	bset	#$07,$0001(a5)														;08ED00070001
adrCd008B64:		; Memory Address ($8B64) and binary offset [$87E0]
	lea		Player1_Data.l,a5													;4BF90000EE7C
	swap	d0																	;4840
	dbra	d1,adrLp008B3C														;51C9FFCE
	rts																			;4E75

Update_PlayerDialogueTextColour:		; Memory Address ($8B72) and binary offset [$87EE]
	; Selects the active player's six-step dialogue-text fade ramp and writes
	; hardware palette index 15.
	tst.w	Paused_Marker.l														;4A7900008C1C
	bne.s	PlayerColourRampLookupBase_Exit										;666E
	tst.b	$0052(a5)															;4A2D0052
	bmi.s	adrCd008BE0															;6B60
	moveq	#$00,d0																;7000
	move.b	$004B(a5),d0														;102D004B
	bne.s	adrCd008B9A															;6612
	move.b	$0052(a5),d0														;102D0052
	and.w	#$003F,d0															;0240003F
	beq.s	adrCd008BE0															;674E
	move.w	#$90FF,$004A(a5)													;3B7C90FF004A
	bra.s	adrCd008BE0															;6046

adrCd008B9A:		; Memory Address ($8B9A) and binary offset [$8816]
	tst.b	$004A(a5)															;4A2D004A
	bne.s	adrCd008BDC															;663C
	tst.b	d0																	;4A00
	bpl.s	adrCd008BAC															;6A08
	cmpi.w	#$00F9,d0															;0C4000F9
	beq.s	adrCd008BE0															;6736
	neg.b	d0																	;4400
adrCd008BAC:		; Memory Address ($8BAC) and binary offset [$8828]
	subq.b	#$01,$004B(a5)														;532D004B
	move.b	#$02,$004A(a5)														;1B7C0002004A
	btst	#$00,(a5)															;08150000
	beq.s	adrCd008BC0															;6704
	add.w	#$000C,d0															;Selects Player 2's orange dialogue-ramp family by adding $0C to the table index; doubling then produces a 24-byte displacement.
adrCd008BC0:		; Memory Address ($8BC0) and binary offset [$883C]
	btst	#$06,$0052(a5)														;Tests the dialogue state bit that selects the shared red monster/alternate-speaker ramp.
	beq.s	adrCd008BCA															;6702
	addq.w	#$06,d0																;5C40
adrCd008BCA:		; Memory Address ($8BCA) and binary offset [$8846]
	add.w	d0,d0																;D040
	move.w	PlayerColourRampTable-2(pc,d0.w),d0									;Uses PlayerColourRampTable-2 as the preserved $8BE8 PC-relative base; indices 1-24 address the green, red, orange, and red dialogue fades at $8BEA.

	move.w	d0,_custom+color+$0000001E.l										;Writes the active player's dialogue ink to hardware colour register 15 for the current Copper-scheduled raster region.
	move.w	d0,$004C(a5)														;Stores the selected hardware dialogue-text colour 15 word in the active PlayerX_Data record.
	rts																			;4E75

adrCd008BDC:		; Memory Address ($8BDC) and binary offset [$8858]
	subq.b	#$01,$004A(a5)														;532D004A
adrCd008BE0:		; Memory Address ($8BE0) and binary offset [$885C]
	move.w	$004C(a5),_custom+color+$0000001E.l									;Restores the active player's current dialogue colour 15 at this Copper-scheduled raster region when no fade step advances.
PlayerColourRampLookupBase_Exit:		; Memory Address ($8BE8) and binary offset [$8864]
	; Exit point and preserved PC-relative lookup base used by the dialogue-text
	; colour update routine.
	rts																			;4E75

PlayerColourRampTable:		; Memory Address ($8BEA) and binary offset [$8866]
	; 24 hardware colour words forming green Player 1, orange Player 2, and shared
	; red alternate dialogue fades; the preceding RTS at $8BE8 is outside the
	; resource.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/PlayerColourRamps.colours"
VBI_Marker:		; Memory Address ($8C1A) and binary offset [$8896]
	ds.b	$2
Paused_Marker:		; Memory Address ($8C1C) and binary offset [$8898]
	ds.b	$2
FrameSyncFlagWord_AI_TBC:		; Memory Address ($8C1E) and binary offset [$889A]
	ds.b	$1
SyncFlagHighByte_AI_TBC:		; Memory Address ($8C1F) and binary offset [$889B]
	dc.b	$FF	;FF

VerticalBlankInterupt:		; Memory Address ($8C20) and binary offset [$889C]
	move.w	d0,-(sp)															;3F00
	move.w	_custom+intreqr.l,d0												;303900DFF01E
	and.w	#$0020,d0															;02400020
	beq.s	Handle_CopperRasterInterrupt										;6712
	move.w	(sp)+,d0															;301F
	move.w	#$0020,_custom+intreq.l												;33FC002000DFF09C
	clr.w	VBI_Marker.l														;427900008C1A
	rte																			;4E73

Handle_CopperRasterInterrupt:		; Memory Address ($8C40) and binary offset [$88BC]
	; Handles Copper-triggered raster interrupts, alternating Player 2
	; dialogue-colour service with the Player 1 frame service.
	move.w	(sp)+,d0															;301F
	eor.w	#$0001,VBI_Marker.l													;0A79000100008C1A
	beq.s	Handle_Player1RasterAndFrameUpdate									;6716
	movem.l	d0/a5,-(sp)															;48E78004
	lea		Player2_Data.l,a5													;Selects Player 2 for the first Copper-scheduled dialogue-colour raster service.
	bsr		Update_PlayerDialogueTextColour										;Updates hardware colour 15 from Player 2's dialogue fade state for the lower player region.
	movem.l	(sp)+,d0/a5															;4CDF2001
	bra		adrCd008CC0															;60000060

Handle_Player1RasterAndFrameUpdate:		; Memory Address ($8C62) and binary offset [$88DE]
	; Runs Player 1 dialogue-colour service and the normal timing, input, and frame
	; update at the second Copper interrupt.
	movem.l	d0-d7/a0-a6,-(sp)													;48E7FFFE
	subq.w	#$01,adrW_00EE9E.l													;53790000EE9E
	bcc.s	adrCd008C74															;6406
	clr.w	adrW_00EE9E.l														;42790000EE9E
adrCd008C74:		; Memory Address ($8C74) and binary offset [$88F0]
	subq.w	#$01,adrW_00EF00.l													;53790000EF00
	bcc.s	adrCd008C82															;6406
	clr.w	adrW_00EF00.l														;42790000EF00
adrCd008C82:		; Memory Address ($8C82) and binary offset [$88FE]
	lea		adrEA00EE36.l,a0													;41F90000EE36
	moveq	#$02,d0																;7002
adrLp008C8A:		; Memory Address ($8C8A) and binary offset [$8906]
	subq.w	#$01,(a0)+															;5358
	bcc.s	adrCd008C92															;6404
	clr.w	-$0002(a0)															;4268FFFE
adrCd008C92:		; Memory Address ($8C92) and binary offset [$890E]
	dbra	d0,adrLp008C8A														;51C8FFF6
	lea		Player1_Data.l,a5													;Selects Player 1 for the second Copper-scheduled dialogue-colour service and frame update.
	bsr		Update_PlayerDialogueTextColour										;Updates hardware colour 15 from Player 1's dialogue fade state after the raster/frame wrap.
	tst.b	SyncFlagHighByte_AI_TBC.l											;4A3900008C1F
	beq.s	adrCd008CBC															;6714
	bsr		InputControls														;6100FD72
	tst.b	FrameSyncFlagWord_AI_TBC.l											;4A3900008C1E
	beq.s	adrCd008CBC															;6708
	clr.b	FrameSyncFlagWord_AI_TBC.l											;423900008C1E
	bsr.s	adrCd008CCA															;610E
adrCd008CBC:		; Memory Address ($8CBC) and binary offset [$8938]
	movem.l	(sp)+,d0-d7/a0-a6													;4CDF7FFF
adrCd008CC0:		; Memory Address ($8CC0) and binary offset [$893C]
	move.w	#$0010,_custom+intreq.l												;33FC001000DFF09C
adrL_008CC8:		; Memory Address ($8CC8) and binary offset [$8944]
	rte																			;4E73

adrCd008CCA:		; Memory Address ($8CCA) and binary offset [$8946]
	cmp.l	#$00060000,screen_ptr.l												;0CB90006000000008D36
	bne.s	adrCd008CEC															;6616
	move.l	#$00067D00,screen_ptr.l												;23FC00067D0000008D36
	move.l	#$00060000,framebuffer_ptr.l										;23FC0006000000008D3A
	bra.s	adrCd008D00															;6014

adrCd008CEC:		; Memory Address ($8CEC) and binary offset [$8968]
	move.l	#$00060000,screen_ptr.l												;23FC0006000000008D36
	move.l	#$00067D00,framebuffer_ptr.l										;23FC00067D0000008D3A
adrCd008D00:		; Memory Address ($8D00) and binary offset [$897C]
	lea		CopperList_00.l,a0													;41F900008E10
	move.l	#$00060000,d0														;203C00060000
	cmp.l	screen_ptr.l,d0														;B0B900008D36
	bne.s	adrCd008D1A															;6606
	move.l	#$00067D00,d0														;203C00067D00
adrCd008D1A:		; Memory Address ($8D1A) and binary offset [$8996]
	moveq	#$03,d1																;7203
adrLp008D1C:		; Memory Address ($8D1C) and binary offset [$8998]
	move.w	d0,$0006(a0)														;31400006
	swap	d0																	;4840
	move.w	d0,$0002(a0)														;31400002
	swap	d0																	;4840
	add.l	#$00001F40,d0														;068000001F40	;Long Addr replaced with Symbol
	addq.w	#$08,a0																;5048
	dbra	d1,adrLp008D1C														;51C9FFEA
	rts																			;4E75

screen_ptr:
	dc.l	$00060000	;00060000
framebuffer_ptr:
	dc.l	$00067D00	;00067D00

adrLp008D3E:		; Memory Address ($8D3E) and binary offset [$89BA]
	swap	d5																	;4845
	move.w	d5,d4																;3805
adrLp008D42:		; Memory Address ($8D42) and binary offset [$89BE]
	move.w	(a0),d2																;3410
	or.w	$1F40(a0),d2														;84681F40
	or.w	$3E80(a0),d2														;84683E80
	or.w	$5DC0(a0),d2														;84685DC0
	not.w	d2																	;4642
	move.l	(a1)+,d0															;2019
	move.l	(a1)+,d1															;2219
	and.w	d2,d1																;C242
	or.w	d1,$5DC0(a0)														;83685DC0
	swap	d1																	;4841
	and.w	d2,d1																;C242
	or.w	d1,$3E80(a0)														;83683E80
	and.w	d2,d0																;C042
	or.w	d0,$1F40(a0)														;81681F40
	swap	d0																	;4840
	and.w	d2,d0																;C042
	or.w	d0,(a0)+															;8158
	dbra	d4,adrLp008D42														;51CCFFD0
	sub.w	d5,a0																;90C5
	sub.w	d5,a0																;90C5
	lea		$0026(a0),a0														;41E80026
	lea		$0070(a1),a1														;43E90070
	swap	d5																	;4845
	dbra	d5,adrLp008D3E														;51CDFFBA
	rts																			;4E75

adrCd008D88:		; Memory Address ($8D88) and binary offset [$8A04]
	move.l	screen_ptr.l,a1														;227900008D36
	move.l	framebuffer_ptr.l,a0												;207900008D3A
	move.w	#$1F3F,d0															;303C1F3F
adrLp008D98:		; Memory Address ($8D98) and binary offset [$8A14]
	move.l	(a0)+,(a1)+															;22D8
	dbra	d0,adrLp008D98														;51C8FFFC
	rts																			;4E75

adrCd008DA0:		; Memory Address ($8DA0) and binary offset [$8A1C]
	move.l	framebuffer_ptr.l,a0												;207900008D3A
	bra.s	adrCd008DAE															;6006

adrCd008DA8:		; Memory Address ($8DA8) and binary offset [$8A24]
	move.l	screen_ptr.l,a0														;207900008D36
adrCd008DAE:		; Memory Address ($8DAE) and binary offset [$8A2A]
	move.w	#$1F3F,d0															;303C1F3F
adrLp008DB2:		; Memory Address ($8DB2) and binary offset [$8A2E]
	clr.l	(a0)+																;4298
	dbra	d0,adrLp008DB2														;51C8FFFC
	rts																			;4E75

adrCd008DBA:		; Memory Address ($8DBA) and binary offset [$8A36]
	lea		_custom+color.l,a1													;43F900DFF180
	lea		GamePalette.l,a0													;41F900008DD0
	moveq	#$1F,d0																;701F
adrLp008DC8:		; Memory Address ($8DC8) and binary offset [$8A44]
	move.w	(a0)+,(a1)+															;32D8
	dbra	d0,adrLp008DC8														;51C8FFFC
	rts																			;4E75

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
adrEA008EC8:		; Memory Address ($8EC8) and binary offset [$8B44]
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

adrCd008FA4:		; Memory Address ($8FA4) and binary offset [$8C20]
	move.l	#$007F0060,d4														;283C007F0060
	move.l	#$004B000C,d5														;2A3C004B000C
	add.w	$0008(a5),d5														;DA6D0008
	bra		BW_draw_bar															;60004AB2

adrCd008FB8:		; Memory Address ($8FB8) and binary offset [$8C34]
	btst	#$06,$0018(a5)														;082D00060018
	bne.s	adrCd009036															;6676
	btst	#$02,(a5)															;08150002
	bne.s	adrCd009036															;6670
	move.b	$003D(a5),d3														;162D003D
	bpl.s	adrCd008FA4															;6AD8
	move.b	$0053(a5),d0														;102D0053
	bmi.s	adrCd009042															;6B70
	bsr		Load_ChampionStatRecord												;6100D68C
	link	a3,#-$0020															;4E53FFE0
	moveq	#$00,d0																;7000
	move.b	$0016(a4),d0														;102C0016
	move.w	d0,-$0004(a3)														;3740FFFC
	move.b	$0017(a4),d0														;102C0017
	move.w	d0,-$0002(a3)														;3740FFFE
	move.b	$0018(a4),d0														;102C0018
	and.w	#$0003,d0															;02400003
	move.w	d0,-$000A(a3)														;3740FFF6
	bsr.s	adrCd009000															;6106
	move.b	$001A(a4),d0														;102C001A
	bra.s	adrCd00905C															;605C

adrCd009000:		; Memory Address ($9000) and binary offset [$8C7C]
	moveq	#$00,d1																;7200
	move.b	$0011(a4),d0														;102C0011
	and.w	#$0007,d0															;02400007
	subq.b	#$07,d0																;5F00
	beq.s	adrCd009038															;672A
	move.l	a4,d0																;200C
	sub.l	#Character_Stats_DataTable,d0										;04800000EB2A
	lsr.w	#$05,d0																;EA48
	move.w	d0,d2																;3400
	and.w	#$0003,d2															;02420003
	cmpi.b	#$03,d2																;0C020003
	bne.s	adrCd009036															;6612
	bsr		RandomGen_BytewithOffset											;6100C586
	move.b	(a4),d2																;1414
	asl.b	#$04,d2																;E902
	moveq	#$00,d1																;7200
	cmp.b	d0,d2																;B400
	bcs.s	adrCd009036															;6504
	move.b	(a4),d1																;1214
	add.w	d1,d1																;D241
adrCd009036:		; Memory Address ($9036) and binary offset [$8CB2]
	rts																			;4E75

adrCd009038:		; Memory Address ($9038) and binary offset [$8CB4]
	move.b	$0011(a4),d1														;122C0011
	lsr.b	#$03,d1																;E609
	addq.w	#$01,d1																;5241
	rts																			;4E75

adrCd009042:		; Memory Address ($9042) and binary offset [$8CBE]
	link	a3,#-$0020															;4E53FFE0
	move.l	$001C(a5),-$0004(a3)												;276D001CFFFC
	move.w	$0020(a5),-$000A(a3)												;376D0020FFF6
	bsr		Load_CurrentChampionStatRecord										;6100D608
	bsr.s	adrCd009000															;61A8
	move.w	$0058(a5),d0														;302D0058
adrCd00905C:		; Memory Address ($905C) and binary offset [$8CD8]
	move.w	d0,-$001E(a3)														;3740FFE2
	move.b	d1,-$001F(a3)														;1741FFE1
	bsr		adrCd0084DA															;6100F474
	move.l	-$0004(a3),d7														;2E2BFFFC
	bsr		CoordToMap															;6100F42E
	btst	#$05,$01(a6,d0.w)													;083600050001
	beq.s	Draw_DungeonViewport												;675C
	bsr		adrCd005F4E															;6100CED4
	move.w	$0002(a0),d1														;32280002
	move.w	d1,d0																;3001
	and.w	#$0003,d1															;02410003
	cmpi.w	#$0002,d1															;0C410002
	bcc.s	Draw_DungeonViewport												;6448
	and.w	#$00FC,d0															;024000FC
	cmpi.w	#$002C,d0															;0C40002C
	bcc.s	adrCd00909C															;6406
	cmpi.w	#$0020,d0															;0C400020
	bcc.s	Draw_DungeonViewport												;6438
adrCd00909C:		; Memory Address ($909C) and binary offset [$8D18]
	lsr.w	#$01,d0																;E248
	add.w	d0,d1																;D240
	move.b	adrB_0090AC(pc,d1.w),$003D(a5)										;1B7B100A003D
	unlk	a3																	;4E5B
	bra		adrCd008FB8															;6000FF0E

adrB_0090AC:		; Memory Address ($90AC) and binary offset [$8D28]
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
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$01EC,a0															;D0FC01EC
	add.w	$000A(a5),a0														;D0ED000A
	move.l	a0,-$0008(a3)														;2748FFF8
	move.w	-$0004(a3),d0														;302BFFFC
	add.w	-$0002(a3),d0														;D06BFFFE
	add.w	-$000A(a3),d0														;D06BFFF6
	and.w	#$0001,d0															;02400001
	move.w	d0,-$000C(a3)														;3740FFF4
	bsr		Draw_FloorAndCeiling												;610026F8
	move.w	-$000A(a3),d0														;302BFFF6
	move.w	d0,d1																;3200
	ror.b	#$03,d0																;E618
	add.w	d1,d1																;D241
	add.w	d1,d0																;D041
	add.w	d1,d1																;D241
	add.w	d1,d0																;D041
	lea		Dungeon_ViewCell_RelativeCoordinates.l,a0							;41F90000B8AE
	add.w	d0,a0																;D0C0
	move.l	a0,-$0010(a3)														;2748FFF0
	move.l	adrW_00EE70.l,d1													;22390000EE70
	move.w	d1,d2																;3401
	swap	d1																	;4841
	move.l	-$0004(a3),d3														;262BFFFC
	move.l	Current_TowerMapDataBase.l,a6										;2C790000EE78
	moveq	#$00,d6																;7C00
Build_DungeonVisibilityMasks_Loop:		; Memory Address ($9130) and binary offset [$8DAC]
	; Scans one player-relative view cell and records whether its map contents
	; block or contribute visible faces.
	lsr.l	#$01,d5																;E28D
	lsr.l	#$01,d4																;E28C
	move.l	d3,d7																;2E03
	add.b	$0001(a0),d7														;DE280001
	cmp.w	d2,d7																;BE42
	bcc		adrCd0091C0															;64000082
	swap	d7																	;4847
	add.b	(a0),d7																;DE10
	cmp.w	d1,d7																;BE41
	bcc.s	adrCd0091C0															;6478
	swap	d7																	;4847
	bsr		adrCd0084A2															;6100F356
	move.w	$00(a6,d0.w),d0														;30360000
	tst.b	d0																	;4A00
	beq.s	adrCd0091C4															;676E
	and.b	#$07,d0																;02000007
	beq.s	adrCd0091BC															;6760
	cmpi.b	#$01,d0																;0C000001
	beq.s	adrCd0091C0															;675E
	cmpi.b	#$07,d0																;0C000007
	bne.s	adrCd00917E															;6616
	lsr.w	#$08,d0																;E048
	and.w	#$0003,d0															;02400003
	cmpi.b	#$02,d0																;0C000002
	bcs.s	adrCd0091BC															;6548
	bne.s	adrCd0091C0															;664A
	tst.b	-$001F(a3)															;4A2BFFE1
	beq.s	adrCd0091C0															;6744
	bra.s	adrCd0091BC															;603E

adrCd00917E:		; Memory Address ($917E) and binary offset [$8DFA]
	cmpi.b	#$02,d0																;0C000002
	bne.s	adrCd0091BC															;6638
	move.w	-$000A(a3),d7														;3E2BFFF6
	cmpi.w	#$0012,d6															;0C460012
	beq.s	adrCd009194															;6706
	addq.w	#$02,d7																;5447
	and.w	#$0003,d7															;02470003
adrCd009194:		; Memory Address ($9194) and binary offset [$8E10]
	add.w	d7,d7																;DE47
	addq.w	#$08,d7																;5047
	btst	d7,d0																;0F00
	beq.s	adrCd0091BC															;6720
	cmpi.w	#$000E,d6															;0C46000E
	bcc.s	adrCd0091C0															;641E
	move.w	-$000A(a3),d7														;3E2BFFF6
	addq.w	#$01,d7																;5247
	cmpi.w	#$0007,d6															;0C460007
	bcs.s	adrCd0091B0															;6502
	addq.w	#$02,d7																;5447
adrCd0091B0:		; Memory Address ($91B0) and binary offset [$8E2C]
	and.w	#$0003,d7															;02470003
	add.w	d7,d7																;DE47
	addq.w	#$08,d7																;5047
	btst	d7,d0																;0F00
	bne.s	adrCd0091C0															;6604
adrCd0091BC:		; Memory Address ($91BC) and binary offset [$8E38]
	bset	#$1F,d4																;08C4001F
adrCd0091C0:		; Memory Address ($91C0) and binary offset [$8E3C]
	bset	#$1F,d5																;08C5001F
adrCd0091C4:		; Memory Address ($91C4) and binary offset [$8E40]
	addq.w	#$02,a0																;5448
	addq.w	#$01,d6																;5246
	cmpi.w	#$0013,d6															;0C460013
	bcs		Build_DungeonVisibilityMasks_Loop									;6500FF62
	rol.l	#$03,d5																;E79D
	swap	d5																	;4845
	rol.l	#$03,d4																;E79C
	swap	d4																	;4844
	lea		Dungeon_ViewCell_VisibleFaceMasks+$48.l,a6							;4DF90000B9DA
	lea		Dungeon_ViewCell_OcclusionMasks+$48.l,a4							;49F90000B98E
	moveq	#$00,d7																;7E00
	moveq	#-$01,d0															;70FF
	moveq	#$12,d6																;7C12
Apply_DungeonOcclusionMasks_Loop:		; Memory Address ($91EA) and binary offset [$8E66]
	; Combines the per-cell visible-face and occlusion masks from farthest view
	; cell to nearest.
	btst	d6,d5																;0D05
	beq.s	adrCd0091F6															;6708
	or.l	(a6),d7																;8E96
	btst	d6,d4																;0D04
	bne.s	adrCd0091F6															;6602
	and.l	(a4),d0																;C094
adrCd0091F6:		; Memory Address ($91F6) and binary offset [$8E72]
	subq.w	#$04,a6																;594E
	subq.w	#$04,a4																;594C
	dbra	d6,Apply_DungeonOcclusionMasks_Loop									;51CEFFEE
	and.l	d0,d7																;CE80
	moveq	#$00,d6																;7C00
Draw_VisibleDungeonCells_Loop:		; Memory Address ($9202) and binary offset [$8E7E]
	; Visits each visible player-relative cell and calls the per-cell dungeon
	; renderer.
	btst	d6,d5																;0D05
	beq.s	adrCd009212															;670C
	movem.l	d5-d7,-(sp)															;48E70700
	bsr		Draw_DungeonViewCell												;61000012
	movem.l	(sp)+,d5-d7															;4CDF00E0
adrCd009212:		; Memory Address ($9212) and binary offset [$8E8E]
	addq.w	#$01,d6																;5246
	cmpi.b	#Dungeon_ViewCell_Count,d6											;Continues through all nineteen player-relative view cells.
	bcs.s	Draw_VisibleDungeonCells_Loop										;65E8
	unlk	a3																	;4E5B
	rts																			;4E75

Draw_DungeonViewCell:		; Memory Address ($921E) and binary offset [$8E9A]
	; Resolves and draws one player-relative dungeon view cell.
	move.b	d6,-$0016(a3)														;1746FFEA
	move.l	-$0010(a3),a0														;206BFFF0
	add.w	d6,d6																;DC46
	add.w	d6,a0																;D0C6
	moveq	#$01,d1																;7201
	move.l	-$0004(a3),d5														;2A2BFFFC
	swap	d5																	;4845
	add.b	(a0)+,d5															;DA18
	move.b	d5,-$0019(a3)														;1745FFE7
	cmp.w	adrW_00EE70.l,d5													;BA790000EE70
	beq.s	Process_DungeonViewCellContents										;672C
	bcs.s	adrCd009248															;6506
	addq.b	#$01,d5																;5205
	beq.s	Process_DungeonViewCellContents										;6726
	rts																			;4E75

adrCd009248:		; Memory Address ($9248) and binary offset [$8EC4]
	swap	d5																	;4845
	add.b	(a0),d5																;DA10
	move.b	d5,-$001A(a3)														;1745FFE6
	cmp.w	adrW_00EE72.l,d5													;BA790000EE72
	beq.s	Process_DungeonViewCellContents										;6714
	bcs.s	adrCd009260															;6506
	addq.b	#$01,d5																;5205
	beq.s	Process_DungeonViewCellContents										;670E
	rts																			;4E75

adrCd009260:		; Memory Address ($9260) and binary offset [$8EDC]
	exg		d5,d7																;CB47
	bsr		CoordToMap															;6100F238
	exg		d5,d7																;CB47
	move.w	$00(a6,d0.w),d1														;32360000
Process_DungeonViewCellContents:		; Memory Address ($926C) and binary offset [$8EE8]
	; Processes floor objects, stationary spells, wall geometry, and occupants for
	; the resolved view cell.
	clr.b	-$0013(a3)															;422BFFED
	move.w	d1,-$0012(a3)														;3741FFEE
	btst	#$06,d1																;08010006
	beq.s	adrCd009286															;670C
	movem.l	d0/d1/d6/d7,-(sp)													;48E7C300
	bsr		Draw_DungeonCellFloorObjects										;6100038A
	movem.l	(sp)+,d0/d1/d6/d7													;4CDF00C3
adrCd009286:		; Memory Address ($9286) and binary offset [$8F02]
	btst	#$05,d1																;08010005
	beq		Dispatch_DungeonCellType											;670000EC
	move.w	d1,d2																;3401
	and.w	#$0007,d2															;02420007
	subq.w	#$01,d2																;5342
	beq		Dispatch_DungeonCellType											;670000E0
	move.w	d0,-(sp)															;3F00
	bsr		Dispatch_DungeonCellType											;610000DA
	move.w	(sp)+,d0															;301F
	bsr		adrCd005F4E															;6100CCAA
	move.w	$0002(a0),d1														;32280002
	move.w	d1,d2																;3401
	and.w	#$0003,d2															;02420003
	cmpi.w	#$0002,d2															;0C420002
	bne		adrCd0092E8															;66000032
	lsr.b	#$02,d1																;E409
	add.w	#$0080,d1															;06410080
	move.b	d1,-$0017(a3)														;1741FFE9
	moveq	#$04,d1																;7204
	cmp.b	#$12,-$0016(a3)														;0C2B0012FFEA
	bne		adrCd00A6EC															;66001420
	subq.b	#$01,-$0016(a3)														;532BFFEA
	move.l	-$0004(a3),d7														;2E2BFFFC
	move.w	-$000A(a3),d0														;302BFFF6
	bsr		adrCd008486															;6100F1AA
	tst.b	$01(a6,d0.w)														;4A360001
	bmi		adrCd00A6EC															;6B001408
	rts																			;4E75

adrCd0092E8:		; Memory Address ($92E8) and binary offset [$8F64]
	and.w	#$00FC,d1															;024100FC
	cmpi.w	#$001C,d1															;0C41001C
	bcc.s	adrCd009358															;6466
	move.w	d1,-(sp)															;3F01
	bsr		Prepare_CentredMonster_ScreenPosition								;61000666
	move.w	(sp)+,d0															;301F
	addq.b	#$01,d1																;5201
	beq.s	adrCd009358															;675A
	subq.b	#$01,d1																;5301
	move.b	GFX_StationarySpell_DistanceGroups(pc,d1.w),d1						;123B1058
	add.w	d1,d1																;D241
	lea		GFX_AirbourneSpells.l,a1											;43F900034A30
	add.w	GFX_StationarySpell_LookupTable(pc,d1.w),a1							;D2FB1052
	add.w	d1,d1																;D241
	add.b	GFX_StationarySpell_RenderLayout(pc,d1.w),d4						;D83B1054
	add.b	GFX_StationarySpell_RenderLayout+$1(pc,d1.w),d5						;DA3B1051
	moveq	#$00,d7																;7E00
	move.b	GFX_StationarySpell_RenderLayout+$2(pc,d1.w),d7						;1E3B104C
	swap	d7																	;4847
	move.b	GFX_StationarySpell_RenderLayout+$3(pc,d1.w),d7						;1E3B1047
	add.w	$0008(a5),d5														;DA6D0008
	move.b	d4,d6																;1C04
	add.b	#$60,d4																;06040060
	ext.w	d6																	;4886
	asr.w	#$04,d6																;E846
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l									;33FCFFFF0000B4BE
	lea		GFX_Spell_ColourMasks.l,a0											;41F900009B70
	move.l	$00(a0,d0.w),Buffer_Colour_Mask.l									;23F000000000B4C0
	move.l	a3,-(sp)															;2F0B
	bsr		Draw_PlanarSprite_Normal											;61001B10
	move.l	(sp)+,a3															;265F
	clr.w	Buffer_Colour_Mask_Toggle.l											;42790000B4BE
adrCd009358:		; Memory Address ($9358) and binary offset [$8FD4]
	rts																			;4E75

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
	bne.s	Draw_DungeonLocation_ByType											;660A
	tst.b	-$0011(a3)															;4A2BFFEF
	bmi		Draw_DungeonCellOccupants											;6B00066C
	rts																			;4E75

Draw_DungeonLocation_ByType:		; Memory Address ($9388) and binary offset [$9004]
	; Dispatches the current map type and iterates its candidate wall faces.
	lea		Dungeon_ViewCell_WallFaceSlots.l,a6									;4DF90000B9F2
	add.w	d6,d6																;DC46
	add.w	d6,a6																;DCC6
	moveq	#$03,d5																;7A03
	subq.b	#$01,d1																;5301
	beq.s	Draw_DungeonWallFaces_Loop											;672A
	subq.b	#$01,d1																;5301
	beq.s	adrCd0093BC															;6720
	subq.b	#$01,d1																;5301
	beq		Draw_BedOrPillar													;670001CA
	cmpi.b	#$03,d1																;0C010003
	beq		Set_TriggerPad_ColourMask											;67000134
	cmpi.b	#$04,d1																;0C010004
	beq		Draw_FirepathCell													;670000E6
	move.b	d1,-$0013(a3)														;1741FFED
	addq.w	#$02,a6																;544E
	moveq	#$01,d5																;7A01
	bra.s	Draw_DungeonWallFaces_Loop											;6006

adrCd0093BC:		; Memory Address ($93BC) and binary offset [$9038]
	move.b	#$FF,-$0013(a3)														;177C00FFFFED
Draw_DungeonWallFaces_Loop:		; Memory Address ($93C2) and binary offset [$903E]
	; Iterates the candidate projected faces for the current dungeon cell and draws
	; those surviving visibility tests.
	moveq	#$00,d6																;7C00
	move.b	(a6)+,d6															;1C1E
	bmi.s	adrCd00943A															;6B72
	btst	d6,d7																;0D07
	beq.s	adrCd00943A															;676E
	clr.b	-$0014(a3)															;422BFFEC
	clr.b	-$0015(a3)															;422BFFEB
	bsr		Resolve_DungeonWallFaceDirection									;610001FE
	tst.b	-$0013(a3)															;4A2BFFED
	bmi.s	Resolve_WoodenWallFace												;6B06
	beq.s	Draw_StoneWallFace													;6760
	bra		Draw_DoorOrStairsFace												;600000A0

Resolve_WoodenWallFace:		; Memory Address ($93E4) and binary offset [$9060]
	; Resolves whether a wooden wall or doorway face is visible from the current
	; candidate direction.
	cmpi.w	#$0002,d5															;0C450002
	bcc.s	adrCd009412															;6428
	tst.w	d5																	;4A45
	beq.s	adrCd0093F8															;670A
	cmp.b	#$0E,-$0016(a3)														;0C2B000EFFEA
	bcc.s	adrCd009412															;641C
	bra.s	adrCd009400															;6008

adrCd0093F8:		; Memory Address ($93F8) and binary offset [$9074]
	cmp.b	#$0E,-$0016(a3)														;0C2B000EFFEA
	bcs.s	adrCd009412															;6512
adrCd009400:		; Memory Address ($9400) and binary offset [$907C]
	tst.b	-$0011(a3)															;4A2BFFEF
	bpl.s	adrCd009412															;6A0C
	movem.l	d1/d5-d7/a6,-(sp)													;48E74702
	bsr		Draw_DungeonCellOccupants											;610005E4
	movem.l	(sp)+,d1/d5-d7/a6													;4CDF40E2
adrCd009412:		; Memory Address ($9412) and binary offset [$908E]
	add.w	d1,d1																;D241
	move.b	-$0012(a3),d0														;102BFFEE
	lsr.w	d1,d0																;E268
	and.w	#$0003,d0															;02400003
	beq.s	adrCd00943A															;671A
	subq.w	#$01,d0																;5340
	beq.s	adrCd00942E															;670A
	move.b	d0,-$0014(a3)														;1740FFEC
	subq.w	#$01,d0																;5340
	move.b	d0,-$0015(a3)														;1740FFEB
adrCd00942E:		; Memory Address ($942E) and binary offset [$90AA]
	movem.l	d5/a6,-(sp)															;48E70402
	bsr		Draw_WoodenWallOrDoorFace											;61001FA4
	movem.l	(sp)+,d5/a6															;4CDF4020
adrCd00943A:		; Memory Address ($943A) and binary offset [$90B6]
	dbra	d5,Draw_DungeonWallFaces_Loop										;51CDFF86
	rts																			;4E75

Draw_StoneWallFace:		; Memory Address ($9440) and binary offset [$90BC]
	; Selects the projected stone-wall face and any main-wall overlay for the
	; current direction.
	move.b	-$0011(a3),d0														;102BFFEF
	bpl.s	adrCd009474															;6A2E
	lsr.b	#$04,d0																;E808
	and.w	#$0003,d0															;02400003
	cmp.b	d0,d1																;B200
	bne.s	adrCd009474															;6624
	move.b	-$0012(a3),d0														;102BFFEE
	move.b	#$FF,-$0015(a3)														;177C00FFFFEB
	and.w	#$0003,d0															;02400003
	beq.s	adrCd009474															;6714
	subq.b	#$01,-$0015(a3)														;532BFFEB
	subq.w	#$01,d0																;5340
	beq.s	adrCd009474															;670C
	subq.b	#$01,-$0015(a3)														;532BFFEB
	subq.w	#$01,d0																;5340
	beq.s	adrCd009474															;6704
	subq.b	#$01,-$0015(a3)														;532BFFEB
adrCd009474:		; Memory Address ($9474) and binary offset [$90F0]
	movem.l	d5/a6,-(sp)															;48E70402
	bsr		Draw_MainWallFace_ByPatternParity									;61001BFA
	movem.l	(sp)+,d5/a6															;4CDF4020
	bra.s	adrCd00943A															;60B8

Draw_DoorOrStairsFace:		; Memory Address ($9482) and binary offset [$90FE]
	; Resolves the visible face slot before dispatching the shared main-door or
	; stairs renderer.
	bsr		Resolve_DungeonCellCentredSlot										;61000558
	bmi		Draw_Main_Door_Or_Stairs											;6B001E56
	btst	d1,d7																;0307
	beq		Draw_Main_Door_Or_Stairs											;67001E50
	move.w	d1,d6																;3C01
	bra		Draw_Main_Door_Or_Stairs											;60001E4A

Draw_FirepathCell:		; Memory Address ($9496) and binary offset [$9112]
	; Interprets the Firepath cell state and selects its ordinary or randomly
	; varied colour mask.
	move.b	-$0012(a3),d1														;122BFFEE
	and.w	#$0003,d1															;02410003
	beq.s	adrCd0094B2															;6712
	cmpi.w	#$0001,d1															;0C410001
	beq.s	Select_Firepath_ColourMask											;6716
	cmpi.b	#$03,d1																;0C010003
	beq.s	adrCd0094B4															;6708
	tst.b	-$001F(a3)															;4A2BFFE1
	beq.s	adrCd0094B4															;6702
adrCd0094B2:		; Memory Address ($94B2) and binary offset [$912E]
	rts																			;4E75

adrCd0094B4:		; Memory Address ($94B4) and binary offset [$9130]
	lsr.w	#$01,d6																;E24E
	moveq	#$01,d1																;7201
	bra		Process_DungeonViewCellContents										;6000FDB2

Select_Firepath_ColourMask:		; Memory Address ($94BC) and binary offset [$9138]
	; Selects one of two Firepath colour masks using the random-value bit at offset
	; four.
	bsr		RandomGen_BytewithOffset											;6100C0EE
	and.w	#$0004,d0															;02400004
	move.l	GFX_Firepath_ColourMasks(pc,d0.w),Buffer_Colour_Mask.l				;23FB000E0000B4C0
	move.b	#$02,-$0012(a3)														;177C0002FFEE
	bra.s	Draw_FloorFeature													;6012

GFX_Firepath_ColourMasks:		; Memory Address ($94D4) and binary offset [$9150]
	; Two four-byte colour masks selected by the Firepath renderer after the random
	; colour choice.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Dungeon_Firepath.colours"

Set_TriggerPad_ColourMask:		; Memory Address ($94DC) and binary offset [$9158]
	move.l	#$01050406,Buffer_Colour_Mask.l										;23FC010504060000B4C0
Draw_FloorFeature:		; Memory Address ($94E6) and binary offset [$9162]
	; Checks centred-slot visibility before composing ceiling holes, floor pits, or
	; trigger pads.
	bsr		Resolve_DungeonCellCentredSlot										;610004F4
	cmpi.w	#$0012,d0															;0C400012
	beq.s	Draw_CeilingHole													;6708
	tst.b	d1																	;4A01
	bmi.s	adrCd009568															;6B74
	btst	d1,d7																;0307
	beq.s	adrCd009568															;6770
Draw_CeilingHole:		; Memory Address ($94F8) and binary offset [$9174]
	; Draws the ceiling-hole component when requested, then continues with the
	; corresponding floor feature.
	move.b	-$0012(a3),d1														;122BFFEE
	move.w	d0,d6																;3C00
	btst	#$02,d1																;08010002
	beq.s	Draw_FloorPitOrTriggerPad											;671E
	movem.l	d1/d6,-(sp)															;48E74200
	lea		GFX_Ceiling_Hole.l,a1												;43F900031F68
	lea		GFX_Ceiling_Hole_Positions.l,a2										;45F90000BF62
	lea		GFX_Ceiling_Hole_Offsets.l,a0										;41F900018C66
	bsr		Draw_CentredDungeonComponent										;61000098
	movem.l	(sp)+,d1/d6															;4CDF0042
Draw_FloorPitOrTriggerPad:		; Memory Address ($9522) and binary offset [$919E]
	; Selects floor-pit or trigger-pad artwork and applies the temporary
	; trigger-pad colour mask.
	lea		GFX_FloorPit_TriggerPad_Offsets.l,a0								;41F900018C4E
	lea		GFX_FloorPit_TriggerPad_Positions.l,a2								;45F90000BF16
	lea		GFX_Floor_Pit.l,a1													;43F900031AD8
	and.w	#$0003,d1															;02410003
	beq.s	adrCd009560															;6726
	cmpi.w	#$0003,d1															;0C410003
	beq.s	adrCd009560															;6720
	btst	#$00,d1																;08010000
	bne.s	adrCd00955E															;6618
	lea		GFX_Trigger_Pad.l,a1												;43F900031D20
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l									;33FCFFFF0000B4BE
	bsr.s	Draw_CentredDungeonComponent										;615E
	clr.w	Buffer_Colour_Mask_Toggle.l											;42790000B4BE
	bra.s	adrCd009560															;6002

adrCd00955E:		; Memory Address ($955E) and binary offset [$91DA]
	bsr.s	Draw_CentredDungeonComponent										;6154
adrCd009560:		; Memory Address ($9560) and binary offset [$91DC]
	tst.b	-$0011(a3)															;4A2BFFEF
	bmi		Draw_DungeonCellOccupants											;6B00048A
adrCd009568:		; Memory Address ($9568) and binary offset [$91E4]
	rts																			;4E75

Draw_BedOrPillar:		; Memory Address ($956A) and binary offset [$91E6]
	; Selects the bed or pillar graphics, offsets, and projected positions for a
	; centred dungeon cell.
	bsr		Resolve_DungeonCellCentredSlot										;61000470
	bmi.s	adrCd00959E															;6B2E
	btst	d1,d7																;0307
	beq.s	adrCd00959E															;672A
	cmp.b	#$01,-$0012(a3)														;0C2B0001FFEE
	beq.s	Draw_Pillar															;6724
	lea		GFX_Misc_Bed_Offsets.l,a0											;41F900018B2C
	lea		GFX_Misc_Bed_Positions.l,a2											;45F90000BC9E
	lea		GFX_Bed.l,a1														;43F900028C28
	move.w	d0,d6																;3C00
Draw_Wall_Sprite:		; Memory Address ($9590) and binary offset [$920C]
	; Prepares and draws a centred dungeon component through the ordinary planar
	; wall-sprite compositor.
	bsr		Prepare_WallSpriteDraw												;61001EF4
	swap	d3																	;4843
	move.l	a3,-(sp)															;2F0B
	bsr		Draw_WallSprite_Normal												;61002030
	move.l	(sp)+,a3															;265F
adrCd00959E:		; Memory Address ($959E) and binary offset [$921A]
	rts																			;4E75

Draw_Pillar:		; Memory Address ($95A0) and binary offset [$921C]
	; Selects the pillar graphics tables before entering the centred-component
	; drawing path.
	lea		GFX_Misc_Pillar_Offsets.l,a0										;41F900018B16
	lea		GFX_Misc_Pillar_Positions.l,a2										;45F90000BC06
	lea		GFX_Pillar.l,a1														;43F9000296A0
	move.w	d0,d6																;3C00
Draw_CentredDungeonComponent:		; Memory Address ($95B4) and binary offset [$9230]
	; Maps a centred view cell to a component picture and chooses its normal or
	; mirrored drawing path.
	moveq	#$00,d0																;7000
	move.b	GFX_CentredDungeonComponent_SpriteMirrorTable(pc,d6.w),d0			;103B6008
	bpl.s	Draw_Wall_Sprite													;6AD4
	bra		Flip_Sprite															;60001E70

GFX_CentredDungeonComponent_SpriteMirrorTable:		; Memory Address ($95C0) and binary offset [$923C]
	; Maps the 19 viewport cells to centred dungeon sprite numbers; bit 7 selects
	; horizontal mirroring. The twentieth byte is spare.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Dungeon_CentredComponents.lookup"

Resolve_DungeonWallFaceDirection:		; Memory Address ($95D4) and binary offset [$9250]
	; Converts the current candidate face and player facing into the corresponding
	; N/E/S/W direction.
	move.w	d5,d1																;3205
	cmp.b	#$07,-$0016(a3)														;0C2B0007FFEA
	bcc.s	adrCd0095EA															;640C
	btst	#$00,d1																;08010000
	bne.s	adrCd0095FC															;6618
	eor.w	#$0001,d1															;0A410001
	bra.s	adrCd009600															;6016

adrCd0095EA:		; Memory Address ($95EA) and binary offset [$9266]
	cmp.b	#$0E,-$0016(a3)														;0C2B000EFFEA
	bcs.s	adrCd0095FC															;650A
	btst	#$01,d1																;08010001
	bne.s	adrCd0095FC															;6604
	eor.w	#$0001,d1															;0A410001
adrCd0095FC:		; Memory Address ($95FC) and binary offset [$9278]
	eor.w	#$0003,d1															;0A410003
adrCd009600:		; Memory Address ($9600) and binary offset [$927C]
	add.w	-$000A(a3),d1														;D26BFFF6
	and.w	#$0003,d1															;02410003
	rts																			;4E75

Draw_DungeonCellFloorObjects:		; Memory Address ($960A) and binary offset [$9286]
	; Checks floor-object visibility and walks the four rotated object subpositions
	; in the current dungeon cell.
	tst.b	-$001F(a3)															;4A2BFFE1
	bne.s	adrCd00961A															;660A
	btst	#$03,$01(a6,d0.w)													;083600030001
	beq.s	adrCd00961A															;6702
	rts																			;4E75

adrCd00961A:		; Memory Address ($961A) and binary offset [$9296]
	move.w	d1,d2																;3401
	and.w	#$0007,d2															;02420007
	cmpi.w	#$0006,d2															;0C420006
	beq.s	adrCd00963A															;6714
	subq.w	#$01,d2																;5342
	bne.s	adrCd009648															;661E
	lsr.w	#$04,d1																;E849
	and.w	#$0003,d1															;02410003
	eor.w	#$0002,d1															;0A410002
	cmp.w	-$000A(a3),d1														;B26BFFF6
	bne.s	adrCd009680															;6646
adrCd00963A:		; Memory Address ($963A) and binary offset [$92B6]
	addq.w	#$04,sp																;584F
	movem.l	(sp),d0/d1/d6/d7													;4CD700C3
	bsr		adrCd009286															;6100FC44
	movem.l	(sp)+,d0/d1/d6/d7													;4CDF00C3
adrCd009648:		; Memory Address ($9648) and binary offset [$92C4]
	moveq	#$00,d1																;7200
Draw_DungeonCellObjectSubpositions_Loop:		; Memory Address ($964A) and binary offset [$92C6]
	; Iterates the four object subpositions after rotating them into the
	; player-relative facing.
	move.w	d1,-(sp)															;3F01
	move.w	d1,d6																;3C01
	bsr		adrCd005F2E															;6100C8DE
	bsr		adrCd005F5C															;6100C908
	bne.s	adrCd009676															;661E
	rol.b	#$02,d6																;E51E
	lea		$02(a0,d7.w),a0														;41F07002
	moveq	#$00,d7																;7E00
	move.b	(a0)+,d7															;1E18
Draw_DungeonCellObjects_Loop:		; Memory Address ($9662) and binary offset [$92DE]
	; Draws every object record attached to the current floor subposition.
	movem.l	d0/d6/d7/a0/a3,-(sp)												;48E78390
	moveq	#$00,d2																;7400
	move.b	(a0),d2																;1410
	bsr.s	Draw_ObjectOnFloor													;6152
	movem.l	(sp)+,d0/d6/d7/a0/a3												;4CDF09C1
	addq.w	#$02,a0																;5448
	dbra	d7,Draw_DungeonCellObjects_Loop										;51CFFFEE
adrCd009676:		; Memory Address ($9676) and binary offset [$92F2]
	move.w	(sp)+,d1															;321F
	addq.w	#$01,d1																;5241
	cmpi.w	#$0004,d1															;0C410004
	bcs.s	Draw_DungeonCellObjectSubpositions_Loop								;65CA
adrCd009680:		; Memory Address ($9680) and binary offset [$92FC]
	rts																			;4E75

GFX_ObjectsOnFloor_SubpositionRotation:		; Memory Address ($9682) and binary offset [$92FE]
	; Combined floor-object projection layout containing sub-position rotation,
	; depth bias, view-cell depth, projection groups, base Y positions and
	; shelf/special Y adjustments.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/ObjectsOnFloor_Projection.layout"

Draw_ObjectOnFloor:		; Memory Address ($96BE) and binary offset [$933A]
	; Resolves object mini-space, view cell and distance into one of five projected
	; floor graphics and its screen position.
	move.w	-$000A(a3),d0														;302BFFF6
	add.w	d0,d0																;D040
	add.w	d0,d0																;D040
	add.w	d6,d0																;D046
	move.b	GFX_ObjectsOnFloor_SubpositionRotation(pc,d0.w),d6					;1C3B00B8
	moveq	#$00,d1																;7200
	move.b	-$0016(a3),d1														;122BFFEA
	move.b	GFX_ObjectsOnFloor_SubpositionRotation+$14(pc,d1.w),d0				;103B10C2
	bmi.s	adrCd009680															;6BA8
	add.b	GFX_ObjectsOnFloor_SubpositionRotation+$10(pc,d6.w),d0				;D03B60B8
	move.b	GFX_ObjectsOnFloor_SubpositionRotation+$27(pc,d0.w),d0				;103B00CB
	bmi.s	adrCd009680															;6B9E
	asl.w	#$02,d1																;E541
	add.w	d6,d1																;D246
	moveq	#$00,d5																;7A00
	moveq	#$00,d4																;7800
	move.b	GFX_ObjectsOnFloor_SubpositionRotation+$2F(pc,d0.w),d5				;1A3B00C5
	add.w	$0008(a5),d5														;DA6D0008
	lea		GFX_ObjectsOnFloor_XPositions.l,a0									;41F9000097BC
	move.b	$00(a0,d1.w),d4														;18301000
	move.w	-$0012(a3),d3														;362BFFEE
	and.w	#$0007,d3															;02430007
	subq.w	#$01,d3																;5343
	bne.s	Draw_ObjectOnFloor_ResolveGraphic									;661A
	subq.w	#$04,d6																;5946
	move.w	d0,d3																;3600
	add.w	d3,d3																;D643
	add.w	d6,d3																;D646
	sub.b	GFX_ObjectsOnFloor_SubpositionRotation+$34(pc,d3.w),d5				;9A3B30A4
	lea		GFX_ObjectsOnFloor_SpecialXPositions.l,a0							;41F900009808
	move.b	-$0016(a3),d3														;162BFFEA
	move.b	$00(a0,d3.w),d4														;18303000
Draw_ObjectOnFloor_ResolveGraphic:		; Memory Address ($9722) and binary offset [$939E]
	; Loads the object's floor shape, recolour definition, graphics offset and
	; selected projection.
	cmpi.b	#$80,d4																;0C040080
	beq		adrCd009680															;6700FF58
	lea		Object_Floor_Colours.l,a6											;4DF90000E770
	moveq	#$00,d3																;7600
	move.b	$00(a6,d2.w),d3														;16362000
	asl.w	#$02,d3																;E543
	lea		Object_Floor_Palettes.l,a6											;4DF90000E7DE
	move.l	$00(a6,d3.w),Buffer_Colour_Mask.l									;23F630000000B4C0
	lea		Object_Floor_DataTable.l,a0											;41F90000E67A
	move.b	$00(a0,d2.w),d3														;16302000
	move.w	d3,d6																;3C03
	asl.w	#$02,d6																;E546
	add.w	d3,d6																;DC43
	add.w	d0,d6																;DC40
	add.w	d6,d6																;DC46
	lea		GFX_ObjectsOnFloor_Offsets.l,a0										;41F90000E88A
	lea		GFX_ObjectsOnFloor.l,a1												;43F900032F60
	add.w	$00(a0,d6.w),a1														;D2F06000
	cmpi.b	#$12,d3																;0C030012
	bcs.s	Draw_ObjectOnFloor_ResolveWidth										;6504
	add.w	#$0CB8,a1															;D2FC0CB8
Draw_ObjectOnFloor_ResolveWidth:		; Memory Address ($9774) and binary offset [$93F0]
	; Selects the normal or wide floor-object drawing width.
	moveq	#$00,d7																;7E00
	cmpi.b	#$12,d3																;0C030012
	bcs.s	Draw_ObjectOnFloor_Blit												;6504
	move.b	GFX_ObjectsOnFloor_Widths(pc,d0.w),d7								;1E3B0038
Draw_ObjectOnFloor_Blit:		; Memory Address ($9780) and binary offset [$93FC]
	; Applies the shape-specific Y adjustment and draws the recoloured floor-object
	; graphic.
	swap	d7																	;4847
	lsr.w	#$01,d6																;E24E
	lea		GFX_ObjectsOnFloor_Heights.l,a0										;41F90000E6E8
	move.b	$00(a0,d6.w),d7														;1E306000
	lea		GFX_ObjectsOnFloor_YAdjustments.l,a0								;41F90000981C
	add.b	$00(a0,d6.w),d5														;DA306000
	move.b	d4,d6																;1C04
	add.b	#$60,d4																;06040060
	ext.w	d6																	;4886
	asr.w	#$04,d6																;E846
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l									;33FCFFFF0000B4BE
	bsr		Draw_PlanarSprite_Normal											;610016B2
	clr.w	Buffer_Colour_Mask_Toggle.l											;42790000B4BE
	rts																			;4E75

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

adrCd0098A4:		; Memory Address ($98A4) and binary offset [$9520]
	bsr		adrCd0084FC															;6100EC56
Find_DungeonCellOccupant:		; Memory Address ($98A8) and binary offset [$9524]
	; Searches players, champions, and unpacked monsters for an occupant at the
	; requested tower and map coordinates.
	move.w	#$0080,d0															;303C0080
	lea		Player1_Data.l,a1													;43F90000EE7C
	cmp.w	$0058(a1),d1														;B2690058
	bne.s	adrCd0098BE															;6606
	cmp.l	$001C(a1),d2														;B4A9001C
	beq.s	adrCd009930															;6772
adrCd0098BE:		; Memory Address ($98BE) and binary offset [$953A]
	addq.b	#$01,d0																;5200
	lea		Player2_Data.l,a1													;43F90000EEDE
	cmp.w	$0058(a1),d1														;B2690058
	bne.s	adrCd0098D2															;6606
	cmp.l	$001C(a1),d2														;B4A9001C
	beq.s	adrCd009930															;675E
adrCd0098D2:		; Memory Address ($98D2) and binary offset [$954E]
	lea		Character_Stats_DataTable.l,a1										;43F90000EB2A
	move.b	d2,d0																;1002
	swap	d2																	;4842
	rol.w	#$08,d2																;E15A
	move.b	d0,d2																;1400
	move.w	CurrentTower.l,d3													;36390000EE2E
	moveq	#Champion_Count-1,d0												;700F
adrLp0098E8:		; Memory Address ($98E8) and binary offset [$9564]
	cmp.b	ChampionStat_Tower(a1),d3											;B629001F
	bne.s	adrCd0098FA															;660C
	cmp.b	ChampionStat_Floor(a1),d1											;B229001A
	bne.s	adrCd0098FA															;6606
	cmp.w	ChampionStat_XPosition(a1),d2										;B4690016
	beq.s	adrCd00992A															;6730
adrCd0098FA:		; Memory Address ($98FA) and binary offset [$9576]
	add.w	#$0020,a1															;D2FC0020
	dbra	d0,adrLp0098E8														;51C8FFE8
	moveq	#$10,d0																;7010
	lea		UnpackedMonsters.l,a1												;43F900016B7E
	move.w	MonsterLive_RecordCountOffset(a1),d3								;3629FFFE
	bmi.s	adrCd009926															;6B16
adrLp009910:		; Memory Address ($9910) and binary offset [$958C]
	cmp.b	MonsterRecord_Floor(a1),d1											;B2290004
	bne.s	adrCd00991C															;6606
	cmp.w	MonsterRecord_XPosition(a1),d2										;B4690000
	beq.s	adrCd009930															;6714
adrCd00991C:		; Memory Address ($991C) and binary offset [$9598]
	addq.w	#$01,d0																;5240
	add.w	#MonsterRecord_Size,a1												;D2FC0010
	dbra	d3,adrLp009910														;51CBFFEC
adrCd009926:		; Memory Address ($9926) and binary offset [$95A2]
	swap	d1																	;4841
	rts																			;4E75

adrCd00992A:		; Memory Address ($992A) and binary offset [$95A6]
	not.b	d0																	;4600
	and.w	#$000F,d0															;0240000F
adrCd009930:		; Memory Address ($9930) and binary offset [$95AC]
	ori.b	#$01,ccr															;003C0001
	rts																			;4E75

Monster_SubPosition_DepthAdjustments:		; Memory Address ($9936) and binary offset [$95B2]
	; Adjusts the selected sub-position before it is converted to a monster
	; graphics distance.
	dc.b	$00,$00,$01,$01,$00
Monster_ViewCell_DepthSlots:		; Memory Address ($993B) and binary offset [$95B7]
	; Maps each view cell to a base depth slot; $FF marks a position that is not
	; visible.
	dc.b	$06,$06,$FF,$04,$02,$00,$FF,$06,$06,$FF,$04,$02,$00,$FF,$06,$04
	dc.b	$02,$00,$FF
Monster_Depth_GfxSlots:		; Memory Address ($994E) and binary offset [$95CA]
	; Maps depth slots to one of the six monster graphics-distance slots.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Monster_Depth_GfxSlots.lookup"
Monster_GfxSlot_YPositions:		; Memory Address ($9956) and binary offset [$95D2]
	; Provides the base vertical screen position for each monster graphics-distance
	; slot.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Monster_GfxSlot_Y.positions"

Prepare_CentredMonster_ScreenPosition:		; Memory Address ($995C) and binary offset [$95D8]
	; Entry point for centrally positioned monsters; forces the centre sub-position
	; before using Prepare_Monster_ScreenPosition.
	moveq	#$04,d1																;7204
Prepare_Monster_ScreenPosition:		; Memory Address ($995E) and binary offset [$95DA]
	; Converts a visible monster's view cell and sub-position into its graphics
	; distance, screen coordinates, and strip height.
	move.w	d1,d2																;3401
	move.w	#$004B,MonsterStrip_BottomY.l										;33FC004B0000AD64
	moveq	#$00,d0																;7000
	moveq	#$00,d4																;7800
	move.b	-$0016(a3),d0														;102BFFEA
	move.b	Monster_ViewCell_DepthSlots(pc,d0.w),d1								;123B00C9
	bmi.s	adrCd0099C6															;6B50
	add.b	Monster_SubPosition_DepthAdjustments(pc,d2.w),d1					;D23B20BE
	move.w	d0,d5																;3A00
	asl.w	#$02,d0																;E540
	add.w	d5,d0																;D045
	add.w	d2,d0																;D042
	move.w	d1,d2																;3401
	lea		Monster_ViewCell_SubPosition_XPositions.l,a0						;41F900018A84
	move.b	$00(a0,d0.w),d4														;18300000
	cmpi.b	#$FF,d4																;0C0400FF
	beq.s	adrCd0099C8															;6734
	move.b	Monster_Depth_GfxSlots(pc,d2.w),d1									;123B20B8
	move.b	Monster_GfxSlot_YPositions(pc,d1.w),d5								;1A3B10BC
	move.w	-$0012(a3),d0														;302BFFEE
	and.w	#$0007,d0															;02400007
	cmpi.w	#$0004,d0															;0C400004
	bne.s	adrCd0099C6															;661C
	move.b	adrB_0099CC(pc,d2.w),d0												;103B2020
	move.b	adrB_0099D4(pc,d2.w),d2												;143B2024
	btst	#$00,-$0012(a3)														;082B0000FFEE
	bne.s	adrCd0099BE															;6604
	neg.b	d0																	;4400
	moveq	#$4B,d2																;744B
adrCd0099BE:		; Memory Address ($99BE) and binary offset [$963A]
	add.b	d0,d5																;DA00
	move.w	d2,MonsterStrip_BottomY.l											;33C20000AD64
adrCd0099C6:		; Memory Address ($99C6) and binary offset [$9642]
	rts																			;4E75

adrCd0099C8:		; Memory Address ($99C8) and binary offset [$9644]
	moveq	#-$01,d1															;72FF
	rts																			;4E75

adrB_0099CC:		; Memory Address ($99CC) and binary offset [$9648]
	dc.b	$00	;00
	dc.b	$08	;08
	dc.b	$00	;00
	dc.b	$06	;06
	dc.b	$00	;00
	dc.b	$06	;06
	dc.b	$00	;00
	dc.b	$00	;00
adrB_0099D4:		; Memory Address ($99D4) and binary offset [$9650]
	dc.b	$4B	;4B
	dc.b	$3E	;3E
	dc.b	$4B	;4B
	dc.b	$34	;34
	dc.b	$4B	;4B
	dc.b	$2E	;2E
	dc.b	$4B	;4B
	dc.b	$4B	;4B

Resolve_DungeonCellCentredSlot:		; Memory Address ($99DC) and binary offset [$9658]
	; Maps the current view cell to its centred visibility bit and projected slot.
	moveq	#$00,d0																;7000
	moveq	#$00,d1																;7200
	lea		Dungeon_ViewCell_CentredSlots.l,a0									;41F90000B9DE
	move.b	-$0016(a3),d0														;102BFFEA
	move.b	$00(a0,d0.w),d1														;12300000
adrCd0099EE:		; Memory Address ($99EE) and binary offset [$966A]
	rts																			;4E75

Draw_DungeonCellOccupants:		; Memory Address ($99F0) and binary offset [$966C]
	; Finds and draws players, champions, or monsters occupying the visible centred
	; slot.
	bsr.s	Resolve_DungeonCellCentredSlot										;61EA
	bmi.s	adrCd0099EE															;6BFA
	btst	d1,d7																;0307
	beq.s	adrCd0099EE															;67F6
	moveq	#$00,d2																;7400
	move.b	-$0019(a3),d2														;142BFFE7
	swap	d2																	;4842
	move.b	-$001A(a3),d2														;142BFFE6
	move.w	-$001E(a3),d1														;322BFFE2
	bsr		Find_DungeonCellOccupant											;6100FE9E
	bcc.s	adrCd0099EE															;64E0
	tst.b	d0																	;4A00
	bmi		adrCd009AFA															;6B0000E8
	cmpi.w	#$0010,d0															;0C400010
	bcc.s	adrCd009A2A															;6410
	move.b	d0,-$0017(a3)														;1740FFE9
	move.b	$001B(a1),d0														;1029001B
	move.b	$0018(a1),d1														;12290018
	bra		adrCd009AB2															;6000008A

adrCd009A2A:		; Memory Address ($9A2A) and binary offset [$96A6]
	moveq	#$00,d0																;7000
	move.b	$000D(a1),d0														;1029000D
	bmi.s	adrCd009A82															;6B50
	move.b	$0002(a1),d2														;14290002
	and.w	#$0003,d2															;02420003
	asl.w	#$02,d0																;E540
	lea		MonsterTeamIndexTable.l,a1											;43F900017390
	add.w	d0,a1																;D2C0
	moveq	#$03,d1																;7203
adrLp009A46:		; Memory Address ($9A46) and binary offset [$96C2]
	move.w	d1,d3																;3601
	addq.w	#$02,d3																;5443
	add.w	-$000A(a3),d3														;D66BFFF6
	sub.w	d2,d3																;9642
	and.w	#$0003,d3															;02430003
	moveq	#$00,d0																;7000
	move.b	$00(a1,d3.w),d0														;10313000
	bmi.s	adrCd009A7C															;6B20
	movem.l	d1/d2/a1,-(sp)														;48E76040
	asl.w	#$04,d0																;E940
	lea		UnpackedMonsters.l,a1												;43F900016B7E
	add.w	d0,a1																;D2C0
	add.w	d2,d3																;D642
	and.w	#$0003,d3															;02430003
	asl.w	#$04,d3																;E943
	or.b	d2,d3																;8602
	move.w	d3,d1																;3203
	bsr.s	adrCd009A86															;610E
	movem.l	(sp)+,d1/d2/a1														;4CDF0206
adrCd009A7C:		; Memory Address ($9A7C) and binary offset [$96F8]
	dbra	d1,adrLp009A46														;51C9FFC8
	rts																			;4E75

adrCd009A82:		; Memory Address ($9A82) and binary offset [$96FE]
	move.b	$0002(a1),d1														;12290002
adrCd009A86:		; Memory Address ($9A86) and binary offset [$9702]
	move.b	$000B(a1),-$0017(a3)												;1769000BFFE9
	cmp.b	#$1A,-$0017(a3)														;0C2B001AFFE9
	bne.s	adrCd009AA8															;6614
	move.w	d1,d3																;3601
	bsr		RandomGen_BytewithOffset											;6100BB14
	move.w	d3,d1																;3203
	and.w	#$0001,d0															;02400001
	add.w	#$001A,d0															;0640001A
	move.b	d0,-$0017(a3)														;1740FFE9
adrCd009AA8:		; Memory Address ($9AA8) and binary offset [$9724]
	move.b	$0005(a1),d0														;10290005
	move.b	$0006(a1),-$0018(a3)												;17690006FFE8
adrCd009AB2:		; Memory Address ($9AB2) and binary offset [$972E]
	bsr		Decode_Monster_RenderFlags											;6100010C
	move.b	d1,d2																;1401
	and.b	#$03,d2																;02020003
	move.b	d2,-$001B(a3)														;1742FFE5
	lsr.b	#$04,d1																;E809
	subq.w	#$02,d1																;5541
	sub.w	-$000A(a3),d1														;926BFFF6
	and.w	#$0003,d1															;02410003
	cmp.b	#$15,-$0017(a3)														;0C2B0015FFE9
	beq.s	.CentralPosition													;6720
	cmp.b	#$16,-$0017(a3)														;0C2B0016FFE9
	beq.s	.CentralPosition													;6718
	cmp.b	#$40,-$0017(a3)														;0C2B0040FFE9
	beq.s	.CentralPosition													;6710
	cmp.b	#$67,-$0017(a3)														;0C2B0067FFE9
	bcc.s	.CentralPosition													;6408
	tst.b	-$0017(a3)															;4A2BFFE9
	bpl		adrCd00A6EC															;6A000BFA
.CentralPosition:
	moveq	#$04,d1																;7204
	bra		adrCd00A6EC															;60000BF4

adrCd009AFA:		; Memory Address ($9AFA) and binary offset [$9776]
	move.b	$0021(a1),-$001B(a3)												;17690021FFE5
	move.l	a5,-(sp)															;2F0D
	move.l	a1,a5																;2A49
	moveq	#$03,d1																;7203
	bsr		adrCd005500															;6100B9F8
	move.l	(sp)+,a5															;2A5F
	tst.w	d3																	;4A43
	bmi.s	adrCd009B1A															;6B0A
	move.b	-$001F(a3),d2														;142BFFE1
	cmp.b	d2,d3																;B602
	bcs.s	adrCd009B1A															;6502
	rts																			;4E75

adrCd009B1A:		; Memory Address ($9B1A) and binary offset [$9796]
	moveq	#$04,d1																;7204
	moveq	#$02,d0																;7002
	moveq	#$00,d2																;7400
adrLp009B20:		; Memory Address ($9B20) and binary offset [$979C]
	tst.b	$27(a1,d0.w)														;4A310027
	bmi.s	adrCd009B28															;6B02
	addq.w	#$01,d2																;5242
adrCd009B28:		; Memory Address ($9B28) and binary offset [$97A4]
	dbra	d0,adrLp009B20														;51C8FFF6
	move.w	$0006(a1),d0														;30290006
	tst.w	d2																	;4A42
	beq		adrCd009B5E															;6700002A
	moveq	#$03,d1																;7203
adrLp009B38:		; Memory Address ($9B38) and binary offset [$97B4]
	moveq	#$02,d0																;7002
	sub.w	$0020(a1),d0														;90690020
	add.w	-$000A(a3),d0														;D06BFFF6
	add.w	d1,d0																;D041
	and.w	#$0003,d0															;02400003
	move.b	$26(a1,d0.w),d0														;10310026
	bmi.s	adrCd009B58															;6B0A
	movem.l	d1/a1,-(sp)															;48E74040
	bsr.s	adrCd009B5E															;610A
	movem.l	(sp)+,d1/a1															;4CDF0202
adrCd009B58:		; Memory Address ($9B58) and binary offset [$97D4]
	dbra	d1,adrLp009B38														;51C9FFDE
	rts																			;4E75

adrCd009B5E:		; Memory Address ($9B5E) and binary offset [$97DA]
	move.b	d0,-$0017(a3)														;1740FFE9
	bsr		Load_ChampionStatRecord												;6100CAFC
	move.b	$001B(a4),d0														;102C001B
	bsr.s	Decode_Monster_RenderFlags											;6154
	bra		adrCd00A6EC															;60000B7E

GFX_Spell_ColourMasks:		; Memory Address ($9B70) and binary offset [$97EC]
	; Four colour-mask indices per spell code. The first 16 records cover $80–$8F;
	; the final four $90–$93 records have no confirmed gameplay effect but are
	; retained for byte-exact source reproduction.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/AirbourneSpells.colours"

Decode_Monster_RenderFlags:		; Memory Address ($9BC0) and binary offset [$983C]
	; Masks a monster render state to five bits and uses the resulting lookup entry
	; for arm or claw animation flags.
	clr.b	-$0015(a3)															;422BFFEB
	and.w	#Monster_RenderFlagMask,d0											;Keeps only the five bits used to choose monster arm or claw animation flags.
	move.b	Monster_RenderFlags_LookupTable(pc,d0.w),-$0015(a3)					;177B0006FFEB
	rts																			;4E75

Monster_RenderFlags_LookupTable:		; Memory Address ($9BD0) and binary offset [$984C]
	; Maps the low five bits of a monster render state to the two arm or claw
	; animation flags.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Monster_RenderFlags.lookup"

Draw_AirbourneSpell:		; Memory Address ($9BF0) and binary offset [$986C]
	; Selects the distance group, graphical family and colour mask used to render
	; flying spell codes $80+.
	lea		GFX_AirbourneSpell_DistanceGroups.l,a1								;43F900009C68
	move.b	$00(a1,d1.w),d1														;12311000
	add.w	d1,d1																;D241
	lea		GFX_FireBall.l,a1													;43F900034778
	lea		GFX_AirbourneFireball_RenderLayout.l,a2								;45F900009C6E
	cmpi.b	#AirbourneSpell_GeneralFirstCode,d0									;Separates fireball codes from the general airborne-spell graphic family.
	bcs.s	.RenderSelectedLayout												;650A
	add.w	#$0798,a1															;D2FC0798
	lea		GFX_AirbourneSpells_RenderLayout.l,a2								;45F900009C86
.RenderSelectedLayout:		; Memory Address ($9C18) and binary offset [$9894]
	; Shared rendering path after selecting either the Fireball or general
	; Airbourne-spell layout.
	add.w	$00(a2,d1.w),a1														;D2F21000
	add.w	d1,d1																;D241
	add.b	$08(a2,d1.w),d4														;D8321008
	add.b	$09(a2,d1.w),d5														;DA321009
	moveq	#$00,d7																;7E00
	move.b	$0A(a2,d1.w),d7														;1E32100A
	swap	d7																	;4847
	move.b	$0B(a2,d1.w),d7														;1E32100B
	add.w	$0008(a5),d5														;DA6D0008
	move.b	d4,d6																;1C04
	add.b	#$60,d4																;06040060
	ext.w	d6																	;4886
	asr.w	#$04,d6																;E846
	move.l	a3,-(sp)															;2F0B
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l									;33FCFFFF0000B4BE
	lea		GFX_Spell_ColourMasks.l,a0											;41F900009B70
	asl.b	#$02,d0																;E500
	move.l	$00(a0,d0.w),Buffer_Colour_Mask.l									;23F000000000B4C0
	bsr		Draw_PlanarSprite_Normal											;61001202
	clr.w	Buffer_Colour_Mask_Toggle.l											;42790000B4BE
	move.l	(sp)+,a3															;265F
	rts																			;4E75

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
	; Maps facing direction to front, side, back, or mirrored-side graphic
	; variants.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Monster_Facing_GfxVariants.lookup"

adrCd009CA2:		; Memory Address ($9CA2) and binary offset [$991E]
	move.w	d1,d2																;3401
	add.w	d2,d2																;D442
	add.w	d1,d2																;D441
	moveq	#$00,d6																;7C00
	move.b	Monster_Facing_GfxVariants_LookupTable(pc,d0.w),d3					;163B00F2
	bpl.s	adrCd009CB2															;6A02
	moveq	#-$01,d6															;7CFF
adrCd009CB2:		; Memory Address ($9CB2) and binary offset [$992E]
	and.w	#$007F,d3															;0243007F
	add.w	d3,d2																;D443
	moveq	#$00,d7																;7E00
	move.b	$0A(a0,d2.w),d7														;1E30200A
	swap	d7																	;4847
	add.w	d2,d2																;D442
	move.w	$00(a2,d2.w),d2														;34322000
	add.w	d2,a1																;D2C2
	sub.b	$00(a0,d1.w),d5														;9A301000
	move.b	$06(a0,d1.w),d7														;1E301006
	rts																			;4E75

Draw_Summon:		; Memory Address ($9CD2) and binary offset [$994E]
	lea		GFX_Summon_LookupTable.l,a2											;45F900009EBE
	lea		GFX_Summon_Body_Layout.l,a0											;41F900009DC0
	lea		GFX_Summon.l,a1														;43F900045018
	bsr.s	adrCd009CA2															;61BC
	lea		Illusion_Palettes.l,a6												;4DF900009E5C
	tst.b	-$0018(a3)															;4A2BFFE8
	bmi.s	.IllusionSkip														;6B0C
	lea		Monster_Summon_Colours.l,a0											;41F900009DB8
	moveq	#$02,d3																;7602
	bsr		MonsterColourGrading												;61000198
.IllusionSkip:		; Memory Address ($9CFE) and binary offset [$997A]
	movem.w	d0/d1/d4/d5/d7,-(sp)												;48A7CD00
	move.l	a1,-(sp)															;2F09
	bsr		Draw_Monster_16PixelStrip											;6100102E
	move.l	(sp)+,a1															;225F
	movem.w	(sp)+,d0/d1/d4/d5/d7												;4C9F00B3
	addq.b	#$03,d4																;5604
	tst.w	d1																	;4A41
	bne.s	adrCd009D28															;6614
	btst	#$00,d0																;08000000
	bne.s	adrCd009D28															;660E
	moveq	#-$01,d6															;7CFF
	movem.w	d0/d1/d4/d5,-(sp)													;48A7CC00
	bsr		Draw_Monster_16PixelStrip											;61001012
	movem.w	(sp)+,d0/d1/d4/d5													;4C9F0033
adrCd009D28:		; Memory Address ($9D28) and binary offset [$99A4]
	cmpi.w	#$0004,d1															;0C410004
	bcc		adrCd009DB6															;64000088
	lea		GFX_Summon_PrimaryArm_Positions.l,a2								;45F900009DDC
	movem.w	d0/d1/d4/d5,-(sp)													;48A7CC00
	moveq	#$00,d6																;7C00
	moveq	#$00,d2																;7400
	bsr		adrCd009D50															;61000010
	movem.w	(sp)+,d0/d1/d4/d5													;4C9F0033
	lea		GFX_Summon_SecondaryArm_Positions.l,a2								;45F900009DFC
	moveq	#-$01,d6															;7CFF
	moveq	#$01,d2																;7401
adrCd009D50:		; Memory Address ($9D50) and binary offset [$99CC]
	lea		GFX_Summon_ArmVariants_LookupTable.l,a0								;41F900009DCC
	move.b	$00(a0,d0.w),d3														;16300000
	bpl.s	adrCd009D5E															;6A02
	not.w	d6																	;4646
adrCd009D5E:		; Memory Address ($9D5E) and binary offset [$99DA]
	and.w	#$007F,d3															;0243007F
	btst	d2,-$0015(a3)														;052BFFEB
	beq.s	adrCd009D6A															;6702
	moveq	#$02,d3																;7602
adrCd009D6A:		; Memory Address ($9D6A) and binary offset [$99E6]
	move.w	d1,d2																;3401
	add.w	d2,d2																;D442
	add.w	d1,d2																;D441
	add.w	d3,d2																;D443
	moveq	#$00,d7																;7E00
	lea		GFX_Summon_Arm_Heights.l,a0											;41F900009DD0
	move.b	$00(a0,d2.w),d7														;1E302000
	add.w	d2,d2																;D442
	lea		GFX_Summon_Arms_LookupTable.l,a0									;41F900009EE2
	lea		GFX_Summon.l,a1														;43F900045018
	add.w	$00(a0,d2.w),a1														;D2F02000
	move.w	d1,d2																;3401
	asl.w	#$02,d2																;E542
	add.w	d0,d2																;D440
	add.w	d2,d2																;D442
	cmpi.b	#$02,d3																;0C030002
	bne.s	adrCd009DA2															;6604
	add.w	#$0040,a2															;D4FC0040
adrCd009DA2:		; Memory Address ($9DA2) and binary offset [$9A1E]
	cmp.w	#$FFFF,$00(a2,d2.w)													;0C72FFFF2000
	beq.s	adrCd009DB6															;670C
	sub.b	$00(a2,d2.w),d4														;98322000
	sub.b	$01(a2,d2.w),d5														;9A322001
	bra		Draw_Monster_16PixelStrip											;60000F80

adrCd009DB6:		; Memory Address ($9DB6) and binary offset [$9A32]
	rts																			;4E75

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
	moveq	#$00,d2																;7400
	move.b	-$0018(a3),d2														;142BFFE8
	sub.b	d3,d2																;9403
	bcc.s	.gradelower															;6402
	moveq	#$00,d2																;7400
.gradelower:		; Memory Address ($9EA0) and binary offset [$9B1C]
	cmpi.b	#Monster_ColourGradeCount,d2										;Clamps the colour-grade index to the eight palette grades available in the SPS 439 monster renderer.
	bcs.s	.gradeupper															;6502
	moveq	#$07,d2																;7407
.gradeupper:		; Memory Address ($9EA8) and binary offset [$9B24]
	move.b	$00(a0,d2.w),d2														;14302000
	asl.w	#$02,d2																;E542
	lea		Monster_Palettes.l,a6												;4DF900009E60
	add.w	d2,a6																;DCC2
	move.l	(a6),Buffer_Colour_Mask.l											;23D60000B4C0
	rts																			;4E75

GFX_Summon_LookupTable:		; Memory Address ($9EBE) and binary offset [$9B3A]
	; Offsets of the 18 Summon body pictures in Summon.gfx: six distances by three
	; facing variants.
	INCBIN "/data/BLOODWYCH439-clean/monsters/Summon.offsets"
GFX_Summon_Arms_LookupTable:		; Memory Address ($9EE2) and binary offset [$9B5E]
	; Offsets of the 12 Summon arm pictures in Summon.gfx: four distances by three
	; arm variants.
	INCBIN "/data/BLOODWYCH439-clean/monsters/Summon_Arms.offsets"

Draw_Crab:		; Memory Address ($9EFA) and binary offset [$9B76]
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l									;33FCFFFF0000B4BE
	lea		Monster_Crabs_Colours.l,a0											;41F900009F20
	moveq	#$02,d3																;7602
	bsr.s	MonsterColourGrading												;6188
	bsr		adrCd00A106															;610001F8
	lea		Buffer_Colour_Mask.l,a6												;4DF90000B4C0
	bsr.s	adrCd009F28															;6110
	clr.w	Buffer_Colour_Mask_Toggle.l											;42790000B4BE
	rts																			;4E75

Monster_Crabs_Colours:		; Memory Address ($9F20) and binary offset [$9B9C]
	INCBIN "/data/BLOODWYCH439-clean/monsters/crab.colours"

adrCd009F28:		; Memory Address ($9F28) and binary offset [$9BA4]
	cmpi.b	#$02,d1																;0C010002
	bcc.s	adrCd009F32															;6404
	bsr		adrCd00A060															;61000130
adrCd009F32:		; Memory Address ($9F32) and binary offset [$9BAE]
	cmpi.b	#$02,d0																;0C000002
	beq.s	adrCd009F78															;6740
	tst.b	d0																	;4A00
	bne		adrCd009FE8															;660000AC
	cmpi.b	#$02,d1																;0C010002
	bcs.s	adrCd009F8C															;6548
	subq.w	#$02,d1																;5541
	lea		adrEA00A17A.l,a2													;45F90000A17A
	bsr		adrCd00A0F6															;610001A8
	moveq	#$00,d7																;7E00
	move.b	adrB_009F80(pc,d1.w),d7												;1E3B102C
	add.b	adrB_009F7A(pc,d1.w),d5												;DA3B1022
	moveq	#$00,d6																;7C00
	add.w	d1,d1																;D241
	movem.l	d0/d1/d4/d5/d7/a1,-(sp)												;48E7CD40
	add.b	adrB_009F7C(pc,d1.w),d4												;D83B1018
	bsr		Draw_Monster_16PixelStrip											;61000DCC
	movem.l	(sp)+,d0/d1/d4/d5/d7/a1												;4CDF02B3
	moveq	#-$01,d6															;7CFF
	add.b	adrB_009F7D(pc,d1.w),d4												;D83B100B
	bra		Draw_Monster_16PixelStrip											;60000DBE

adrCd009F78:		; Memory Address ($9F78) and binary offset [$9BF4]
	rts																			;4E75

adrB_009F7A:
	dc.b	$F8	;F8
	dc.b	$F7	;F7
adrB_009F7C:		; Memory Address ($9F7C) and binary offset [$9BF8]
	dc.b	$F8	;F8
adrB_009F7D:		; Memory Address ($9F7D) and binary offset [$9BF9]
	dc.b	$04	;04
	dc.b	$F9	;F9
	dc.b	$FF	;FF
adrB_009F80:		; Memory Address ($9F80) and binary offset [$9BFC]
	dc.b	$09	;09
	dc.b	$07	;07
adrB_009F82:		; Memory Address ($9F82) and binary offset [$9BFE]
	dc.b	$FD	;FD
	dc.b	$EF	;EF
	dc.b	$FA	;FA
	dc.b	$F1	;F1
adrB_009F86:		; Memory Address ($9F86) and binary offset [$9C02]
	dc.b	$F0	;F0
	dc.b	$10	;10
	dc.b	$F6	;F6
	dc.b	$04	;04
adrB_009F8A:		; Memory Address ($9F8A) and binary offset [$9C06]
	dc.b	$14	;14
	dc.b	$0D	;0D

adrCd009F8C:		; Memory Address ($9F8C) and binary offset [$9C08]
	moveq	#$00,d7																;7E00
	move.b	adrB_009F8A(pc,d1.w),d7												;1E3B10FA
	moveq	#$00,d2																;7400
	moveq	#$00,d6																;7C00
	bsr		adrCd009F9E															;61000006
	moveq	#$01,d2																;7401
	moveq	#-$01,d6															;7CFF
adrCd009F9E:		; Memory Address ($9F9E) and binary offset [$9C1A]
	lea		GFX_Behemoth_Claw_LookupTable.l,a2									;45F90000A6C2
	lea		GFX_Behemoth.l,a1													;43F9000466D0
	movem.w	d0/d1/d4/d5/d7,-(sp)												;48A7CD00
	add.w	d1,d1																;D241
	move.w	d1,d3																;3601
	add.w	d2,d3																;D642
	add.b	adrB_009F86(pc,d3.w),d4												;D83B30D0
	move.w	d1,d3																;3601
	btst	d2,-$0015(a3)														;052BFFEB
	beq.s	adrCd009FC4															;6704
	addq.w	#$01,d3																;5243
	addq.w	#$02,a2																;544A
adrCd009FC4:		; Memory Address ($9FC4) and binary offset [$9C40]
	add.b	adrB_009F82(pc,d3.w),d5												;DA3B30BC
	add.w	d1,d1																;D241
	add.w	$00(a2,d1.w),a1														;D2F21000
	bsr		Draw_Monster_16PixelStrip											;61000D64
	movem.w	(sp)+,d0/d1/d4/d5/d7												;4C9F00B3
	rts																			;4E75

adrB_009FD8:
	dc.b	$08	;08
	dc.b	$12	;12
	dc.b	$07	;07
	dc.b	$0E	;0E
adrB_009FDC:		; Memory Address ($9FDC) and binary offset [$9C58]
	dc.b	$E6	;E6
	dc.b	$E5	;E5
	dc.b	$1A	;1A
	dc.b	$1B	;1B
	dc.b	$EF	;EF
	dc.b	$EF	;EF
	dc.b	$0B	;0B
	dc.b	$0B	;0B
adrB_009FE4:		; Memory Address ($9FE4) and binary offset [$9C60]
	dc.b	$02	;02
	dc.b	$F1	;F1
	dc.b	$FB	;FB
	dc.b	$F0	;F0

adrCd009FE8:		; Memory Address ($9FE8) and binary offset [$9C64]
	cmpi.b	#$02,d1																;0C010002
	bcc.s	adrCd00A030															;6442
	lea		adrEA00A17E.l,a2													;45F90000A17E
	add.w	d1,d1																;D241
	moveq	#-$01,d6															;7CFF
	lsr.b	#$01,d0																;E208
	beq.s	adrCd009FFE															;6702
	moveq	#$00,d6																;7C00
adrCd009FFE:		; Memory Address ($9FFE) and binary offset [$9C7A]
	move.w	d1,d2																;3401
	add.w	d0,d2																;D440
	add.w	d2,d2																;D442
	eor.b	#$01,d0																;0A000001
	btst	d0,-$0015(a3)														;012BFFEB
	beq.s	adrCd00A012															;6704
	addq.w	#$01,d1																;5241
	addq.w	#$01,d2																;5242
adrCd00A012:		; Memory Address ($A012) and binary offset [$9C8E]
	moveq	#$00,d7																;7E00
	move.b	adrB_009FD8(pc,d1.w),d7												;1E3B10C2
	add.b	adrB_009FDC(pc,d2.w),d4												;D83B20C2
	add.b	adrB_009FE4(pc,d1.w),d5												;DA3B10C6
	bsr		adrCd00A0F6															;610000D4
	bra		Draw_Monster_16PixelStrip											;60000D0E

adrB_00A028:
	dc.b	$08	;08
	dc.b	$06	;06
adrB_00A02A:		; Memory Address ($A02A) and binary offset [$9CA6]
	dc.b	$F3	;F3
	dc.b	$09	;09
	dc.b	$F2	;F2
	dc.b	$06	;06
adrB_00A02E:		; Memory Address ($A02E) and binary offset [$9CAA]
	dc.b	$F8	;F8
	dc.b	$F7	;F7

adrCd00A030:		; Memory Address ($A030) and binary offset [$9CAC]
	subq.b	#$02,d1																;5501
	moveq	#$00,d7																;7E00
	move.b	adrB_00A028(pc,d1.w),d7												;1E3B10F2
	add.b	adrB_00A02E(pc,d1.w),d5												;DA3B10F4
	lea		adrEA00A186.l,a2													;45F90000A186
	bsr		adrCd00A0F6															;610000B2
	add.w	d1,d1																;D241
	moveq	#-$01,d6															;7CFF
	lsr.b	#$01,d0																;E208
	beq.s	adrCd00A052															;6704
	moveq	#$00,d6																;7C00
	addq.w	#$01,d1																;5241
adrCd00A052:		; Memory Address ($A052) and binary offset [$9CCE]
	add.b	adrB_00A02A(pc,d1.w),d4												;D83B10D6
	bra		Draw_Monster_16PixelStrip											;60000CDC

adrB_00A05A:
	dc.b	$0B	;0B
	dc.b	$07	;07
GFX_CrabFace_Position:		; Memory Address ($A05C) and binary offset [$9CD8]
	dc.b	$FE	;FE
	dc.b	$FB	;FB
adrB_00A05E:		; Memory Address ($A05E) and binary offset [$9CDA]
	dc.b	$EC	;EC
	dc.b	$14	;14

adrCd00A060:		; Memory Address ($A060) and binary offset [$9CDC]
	tst.b	d0																	;4A00
	bne.s	adrCd00A086															;6622
	moveq	#$00,d6																;7C00
	lea		adrEA00A170.l,a2													;45F90000A170
	movem.w	d0/d1/d4/d5,-(sp)													;48A7CC00
	move.b	adrB_00A05A(pc,d1.w),d7												;1E3B10E8
	bsr		adrCd00A0F6															;61000080
	add.b	GFX_CrabFace_Position(pc,d1.w),d5									;DA3B10E2
adrCd00A07C:		; Memory Address ($A07C) and binary offset [$9CF8]
	bsr		Draw_Monster_16PixelStrip											;61000CB6
	movem.w	(sp)+,d0/d1/d4/d5													;4C9F0033
adrCd00A084:		; Memory Address ($A084) and binary offset [$9D00]
	rts																			;4E75

adrCd00A086:		; Memory Address ($A086) and binary offset [$9D02]
	cmpi.b	#$02,d0																;0C000002
	beq.s	adrCd00A0B4															;6728
	tst.b	d1																	;4A01
	bne.s	adrCd00A084															;66F4
	lea		GFX_CrabClaw.l,a1													;43F900047F10
	movem.w	d0/d1/d4/d5,-(sp)													;48A7CC00
	moveq	#$07,d7																;7E07
	subq.b	#$03,d5																;5705
	moveq	#-$01,d6															;7CFF
	lsr.b	#$01,d0																;E208
	beq.s	adrCd00A0A6															;6702
	moveq	#$00,d6																;7C00
adrCd00A0A6:		; Memory Address ($A0A6) and binary offset [$9D22]
	add.b	adrB_00A05E(pc,d0.w),d4												;D83B00B6
	bra.s	adrCd00A07C															;60D0

adrB_00A0AC:
	dc.b	$07	;07
	dc.b	$F9	;F9
	dc.b	$FE	;FE
	dc.b	$FC	;FC
adrB_00A0B0:		; Memory Address ($A0B0) and binary offset [$9D2C]
	dc.b	$EF	;EF
	dc.b	$F1	;F1
adrB_00A0B2:		; Memory Address ($A0B2) and binary offset [$9D2E]
	dc.b	$07	;07
	dc.b	$04	;04

adrCd00A0B4:		; Memory Address ($A0B4) and binary offset [$9D30]
	tst.b	-$0015(a3)															;4A2BFFEB
	beq.s	adrCd00A084															;67CA
	lea		adrEA00A176.l,a2													;45F90000A176
	bsr.s	adrCd00A0F6															;6134
	moveq	#$00,d7																;7E00
	move.b	adrB_00A0B2(pc,d1.w),d7												;1E3B10EC
	moveq	#-$01,d6															;7CFF
	moveq	#$00,d2																;7400
	bsr.s	GFX_Beholder														;6104
	moveq	#$00,d6																;7C00
	moveq	#$01,d2																;7401
GFX_Beholder:		; Memory Address ($A0D2) and binary offset [$9D4E]
	; Draws the Beholder's optional eye components selected by its render flags.
	btst	d2,-$0015(a3)														;052BFFEB
	beq.s	adrCd00A0F4															;671C
	movem.w	d0/d1/d4/d5/d7,-(sp)												;48A7CD00
	move.l	a1,-(sp)															;2F09
	add.b	adrB_00A0B0(pc,d1.w),d5												;DA3B10D0
	add.w	d1,d1																;D241
	add.w	d2,d1																;D242
	add.b	adrB_00A0AC(pc,d1.w),d4												;D83B10C4
	bsr		Draw_Monster_16PixelStrip											;61000C48
	move.l	(sp)+,a1															;225F
	movem.w	(sp)+,d0/d1/d4/d5/d7												;4C9F00B3
adrCd00A0F4:		; Memory Address ($A0F4) and binary offset [$9D70]
	rts																			;4E75

adrCd00A0F6:		; Memory Address ($A0F6) and binary offset [$9D72]
	lea		GFX_Crab.l,a1														;43F900047AB8
	move.w	d1,d2																;3401
	add.w	d2,d2																;D442
	add.w	$00(a2,d2.w),a1														;D2F22000
	rts																			;4E75

adrCd00A106:		; Memory Address ($A106) and binary offset [$9D82]
	lea		Monster_DistanceGroups_LookupTable.l,a0								;41F90000A536
	move.b	$00(a0,d1.w),d1														;12301000
	lea		adrEA00A168.l,a2													;45F90000A168
	lea		adrEA00A15C.l,a0													;41F90000A15C
	add.b	$00(a0,d1.w),d5														;DA301000
	moveq	#$00,d7																;7E00
	move.b	$04(a0,d1.w),d7														;1E301004
	swap	d7																	;4847
	move.b	$08(a0,d1.w),d7														;1E301008
	bsr.s	adrCd00A0F6															;61C8
	movem.l	d0-d2/d4/d5/d7,-(sp)												;48E7ED00
	move.l	a1,-(sp)															;2F09
	add.b	adrB_00A154(pc,d2.w),d4												;D83B201E
	moveq	#$00,d6																;7C00
	bsr		Draw_Monster_CompositeBitmap										;6100058E
	move.l	(sp)+,a1															;225F
	movem.l	(sp),d0-d2/d4/d5/d7													;4CD700B7
	moveq	#-$01,d6															;7CFF
	add.b	adrB_00A155(pc,d2.w),d4												;D83B200D
	bsr		Draw_Monster_CompositeBitmap										;6100057E
	movem.l	(sp)+,d0-d2/d4/d5/d7												;4CDF00B7
	rts																			;4E75

adrB_00A154:
	dc.b	$EC	;EC
adrB_00A155:		; Memory Address ($A155) and binary offset [$9DD1]
	dc.b	$04	;04
	dc.b	$F2	;F2
	dc.b	$F8	;F8
	dc.b	$F8	;F8
	dc.b	$04	;04
	dc.b	$F9	;F9
	dc.b	$FF	;FF
adrEA00A15C:		; Memory Address ($A15C) and binary offset [$9DD8]
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
adrEA00A170:		; Memory Address ($A170) and binary offset [$9DEC]
	dc.w	$03B8	;03B8
	dc.w	$0418	;0418
	dc.w	$0458	;0458
adrEA00A176:		; Memory Address ($A176) and binary offset [$9DF2]
	dc.w	$0498	;0498
	dc.w	$04D8	;04D8
adrEA00A17A:		; Memory Address ($A17A) and binary offset [$9DF6]
	dc.w	$0500	;0500
	dc.w	$0550	;0550
adrEA00A17E:		; Memory Address ($A17E) and binary offset [$9DFA]
	dc.w	$0590	;0590
	dc.w	$05D8	;05D8
	dc.w	$0670	;0670
	dc.w	$06B0	;06B0
adrEA00A186:		; Memory Address ($A186) and binary offset [$9E02]
	dc.w	$0728	;0728
	dc.w	$0770	;0770

Draw_Beholder:		; Memory Address ($A18A) and binary offset [$9E06]
	moveq	#$04,d3																;7604
	lea		Monster_Beholder_Colours.l,a0										;41F90000A1AC
	bsr		MonsterColourGrading												;6100FD00
	bsr		Draw_Beholder_BodyAndUpperEyes										;610000D6
	cmpi.b	#$02,d0																;0C000002
	beq.s	adrCd00A1A4															;6704
	bsr		Draw_Beholder_CentralEye											;6100001A
adrCd00A1A4:		; Memory Address ($A1A4) and binary offset [$9E20]
	clr.w	Buffer_Colour_Mask_Toggle.l											;42790000B4BE
	rts																			;4E75

Monster_Beholder_Colours:		; Memory Address ($A1AC) and binary offset [$9E28]
	INCBIN "/data/BLOODWYCH439-clean/monsters/beholder.colours"
GFX_Beholder_CentralEye_Near_Front_Heights:		; Memory Address ($A1B4) and binary offset [$9E30]
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_CentralEye_Near_Front.heights"
GFX_Beholder_CentralEye_Near_YPositions:		; Memory Address ($A1B8) and binary offset [$9E34]
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_CentralEye_Near_Y.positions"

Draw_Beholder_CentralEye:		; Memory Address ($A1BC) and binary offset [$9E38]
	cmpi.b	#$04,d1																;0C010004
	bcc.s	Draw_Beholder_CentralEye_Far										;6464
	lea		GFX_Beholder_CentralEye_Near_LookupTable.l,a2						;45F90000A308
	moveq	#$00,d7																;7E00
	add.b	GFX_Beholder_CentralEye_Near_YPositions(pc,d1.w),d5					;DA3B10EC
	move.w	d1,d2																;3401
	add.w	d2,d2																;D442
	btst	#$01,-$0015(a3)														;082B0001FFEB
	beq.s	adrCd00A1DC															;6702
	addq.w	#$01,d2																;5242
adrCd00A1DC:		; Memory Address ($A1DC) and binary offset [$9E58]
	add.w	d2,d2																;D442
	lea		GFX_Beholder_Body.l,a1												;43F900048260
	tst.b	d0																	;4A00
	bne.s	Draw_Beholder_CentralEye_NearSide									;6618
	move.b	GFX_Beholder_CentralEye_Near_Front_Heights(pc,d1.w),d7				;1E3B10CA
	add.w	$00(a2,d2.w),a1														;D2F22000
	bra		Draw_Beholder_Component												;600000C4

GFX_Beholder_CentralEye_Near_Side_Heights:		; Memory Address ($A1F4) and binary offset [$9E70]
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_CentralEye_Near_Side.heights"
GFX_Beholder_CentralEye_Near_Side_Mirrored_XPositions:		; Memory Address ($A1F8) and binary offset [$9E74]
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_CentralEye_Near_Side_Mirrored_X.positions"
GFX_Beholder_CentralEye_Near_Side_YPositions:		; Memory Address ($A1FC) and binary offset [$9E78]
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_CentralEye_Near_Side_Y.positions"

Draw_Beholder_CentralEye_NearSide:		; Memory Address ($A200) and binary offset [$9E7C]
	add.w	#$0010,a2															;D4FC0010
	add.w	$00(a2,d2.w),a1														;D2F22000
	move.b	GFX_Beholder_CentralEye_Near_Side_Heights(pc,d1.w),d7				;1E3B10EA
	add.b	GFX_Beholder_CentralEye_Near_Side_YPositions(pc,d1.w),d5			;DA3B10EE
	moveq	#$00,d6																;7C00
	lsr.b	#$01,d0																;E208
	beq		Draw_Monster_16PixelStrip											;67000B1E
	add.b	GFX_Beholder_CentralEye_Near_Side_Mirrored_XPositions(pc,d1.w),d4	;D83B10DE
	moveq	#-$01,d6															;7CFF
	bra		Draw_Monster_16PixelStrip											;60000B14

GFX_Beholder_CentralEye_Far_YPositions:		; Memory Address ($A222) and binary offset [$9E9E]
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_CentralEye_Far_Y.positions"
GFX_Beholder_CentralEye_Far_Side_Mirrored_XPositions:		; Memory Address ($A224) and binary offset [$9EA0]
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_CentralEye_Far_Side_Mirrored_X.positions"

Draw_Beholder_CentralEye_Far:		; Memory Address ($A226) and binary offset [$9EA2]
	lea		GFX_Beholder_CentralEye_Far_LookupTable.l,a2						;45F90000A328
	subq.w	#$04,d1																;5941
	move.w	d1,d2																;3401
	moveq	#$02,d7																;7E02
	add.b	GFX_Beholder_CentralEye_Far_YPositions(pc,d1.w),d5					;DA3B10EE
	moveq	#$00,d6																;7C00
	tst.b	d0																	;4A00
	beq.s	adrCd00A248															;670C
	addq.w	#$02,d2																;5442
	lsr.b	#$01,d0																;E208
	beq.s	adrCd00A248															;6706
	moveq	#-$01,d6															;7CFF
	add.b	GFX_Beholder_CentralEye_Far_Side_Mirrored_XPositions(pc,d1.w),d4	;D83B10DE
adrCd00A248:		; Memory Address ($A248) and binary offset [$9EC4]
	add.w	d2,d2																;D442
	lea		GFX_Beholder_Body.l,a1												;43F900048260
	add.w	$00(a2,d2.w),a1														;D2F22000
	bra		Draw_Monster_16PixelStrip											;60000ADE

GFX_Beholder_Body_Heights:		; Memory Address ($A258) and binary offset [$9ED4]
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_Body.heights"
GFX_Beholder_Composite_XPositions:		; Memory Address ($A25E) and binary offset [$9EDA]
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_Composite_X.positions"
GFX_Beholder_Composite_YPositions:		; Memory Address ($A264) and binary offset [$9EE0]
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_Composite_Y.positions"
GFX_Beholder_UpperEyes_Heights:		; Memory Address ($A26A) and binary offset [$9EE6]
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_UpperEyes.heights"

Draw_Beholder_BodyAndUpperEyes:		; Memory Address ($A26E) and binary offset [$9EEA]
	moveq	#$00,d7																;7E00
	move.b	GFX_Beholder_Body_Heights(pc,d1.w),d7								;1E3B10E6
	add.b	GFX_Beholder_Composite_XPositions(pc,d1.w),d4						;D83B10E8
	add.b	GFX_Beholder_Composite_YPositions(pc,d1.w),d5						;DA3B10EA
	lea		GFX_Beholder_Body_LookupTable.l,a2									;45F90000A2F4
	bsr		Select_Beholder_GfxFromLookup										;61000060
	bsr		Draw_Beholder_Component												;6100002E
	cmpi.b	#$04,d1																;0C010004
	bcc.s	adrCd00A2B4															;6424
	lea		GFX_Beholder_UpperEyes_LookupTable.l,a2								;45F90000A300
	bsr		Select_Beholder_GfxFromLookup										;6100004C
	move.w	d5,-(sp)															;3F05
	moveq	#$00,d7																;7E00
	move.b	GFX_Beholder_UpperEyes_Heights(pc,d1.w),d7							;1E3B10CA
	sub.b	d7,d5																;9A07
	move.b	-$0015(a3),d2														;142BFFEB
	not.b	d2																	;4602
	and.w	#$0001,d2															;02420001
	sub.b	d2,d5																;9A02
	bsr.s	Draw_Beholder_Component												;6104
	move.w	(sp)+,d5															;3A1F
adrCd00A2B4:		; Memory Address ($A2B4) and binary offset [$9F30]
	rts																			;4E75

Draw_Beholder_Component:		; Memory Address ($A2B6) and binary offset [$9F32]
	movem.w	d0/d1/d4/d5/d7,-(sp)												;48A7CD00
	move.l	a1,-(sp)															;2F09
	moveq	#$00,d6																;7C00
	bsr		Draw_Monster_16PixelStrip											;61000A74
	move.l	(sp)+,a1															;225F
	movem.w	(sp)+,d0/d1/d4/d5/d7												;4C9F00B3
	cmpi.b	#$02,d1																;0C010002
	bcc.s	adrCd00A2B4															;64E6
	moveq	#-$01,d6															;7CFF
	movem.w	d0/d1/d4/d5/d7,-(sp)												;48A7CD00
	add.b	GFX_Beholder_Near_MirroredHalf_XPositions(pc,d1.w),d4				;D83B100C
	bsr		Draw_Monster_16PixelStrip											;61000A5A
	movem.w	(sp)+,d0/d1/d4/d5/d7												;4C9F00B3
	rts																			;4E75

GFX_Beholder_Near_MirroredHalf_XPositions:		; Memory Address ($A2E2) and binary offset [$9F5E]
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_Near_MirroredHalf_X.positions"

Select_Beholder_GfxFromLookup:		; Memory Address ($A2E4) and binary offset [$9F60]
	; Converts a Beholder component index into an offset from the packed Beholder
	; graphic bank.
	move.w	d1,d2																;3401
	add.w	d2,d2																;D442
	lea		GFX_Beholder_Body.l,a1												;43F900048260
	add.w	$00(a2,d2.w),a1														;D2F22000
	rts																			;4E75

GFX_Beholder_Body_LookupTable:		; Memory Address ($A2F4) and binary offset [$9F70]
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_Body.offsets"
GFX_Beholder_UpperEyes_LookupTable:		; Memory Address ($A300) and binary offset [$9F7C]
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_UpperEyes.offsets"
GFX_Beholder_CentralEye_Near_LookupTable:		; Memory Address ($A308) and binary offset [$9F84]
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_CentralEye_Near.offsets"
GFX_Beholder_CentralEye_Far_LookupTable:		; Memory Address ($A328) and binary offset [$9FA4]
	INCBIN "/data/BLOODWYCH439-clean/monsters/Beholder_CentralEye_Far.offsets"

Draw_LittleDragon:		; Memory Address ($A330) and binary offset [$9FAC]
	moveq	#$01,d2																;7401
	lea		adrEA00A33C.l,a2													;45F90000A33C
	moveq	#$03,d3																;7603
	bra.s	adrCd00A356															;601A

adrEA00A33C:
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
	moveq	#$00,d2																;7400
	lea		BigDragon_Table_Unknown.l,a2										;45F90000A344
	moveq	#$09,d3																;7609
adrCd00A356:		; Memory Address ($A356) and binary offset [$9FD2]
	lea		Monster_DistanceGroups_LookupTable.l,a0								;41F90000A536
	move.b	$00(a0,d1.w),d1														;12301000
	add.b	$00(a2,d1.w),d4														;D8321000
	add.b	$04(a2,d1.w),d5														;DA321004
	add.w	d2,d1																;D242
	btst	#$00,d0																;08000000
	beq.s	adrCd00A37C															;670C
	move.w	d0,d2																;3400
	lsr.w	#$01,d2																;E24A
	add.w	d1,d2																;D441
	add.w	d1,d2																;D441
	add.b	GFX_Dragon_Side_XPositions(pc,d2.w),d4								;D83B2022
adrCd00A37C:		; Memory Address ($A37C) and binary offset [$9FF8]
	lea		Monster_Dragon_Colours.l,a0											;41F90000A3A6
	bsr		MonsterColourGrading												;6100FB10
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l									;33FCFFFF0000B4BE
	bsr		adrCd00A476															;610000E6
	bsr.s	adrCd00A3AE															;611A
	clr.w	Buffer_Colour_Mask_Toggle.l											;42790000B4BE
adrCd00A39A:		; Memory Address ($A39A) and binary offset [$A016]
	rts																			;4E75

GFX_Dragon_Side_XPositions:		; Memory Address ($A39C) and binary offset [$A018]
	; Additional horizontal shifts for side-facing Dragons by size group and side.
	INCBIN "/data/BLOODWYCH439-clean/monsters/Dragon_Side_X.positions"
Monster_Dragon_Colours:		; Memory Address ($A3A6) and binary offset [$A022]
	INCBIN "/data/BLOODWYCH439-clean/monsters/dragon.colours"

adrCd00A3AE:		; Memory Address ($A3AE) and binary offset [$A02A]
	cmpi.b	#$02,d0																;0C000002
	beq.s	adrCd00A39A															;67E6
	cmpi.b	#$03,d1																;0C010003
	bcc.s	adrCd00A39A															;64E0
	moveq	#$00,d2																;7400
	moveq	#$00,d6																;7C00
	movem.w	d0/d1/d4/d5,-(sp)													;48A7CC00
	bsr.s	adrCd00A3D0															;610C
	movem.w	(sp)+,d0/d1/d4/d5													;4C9F0033
	tst.w	d0																	;4A40
	bne.s	adrCd00A39A															;66CE
	moveq	#-$01,d6															;7CFF
	moveq	#$01,d2																;7401
adrCd00A3D0:		; Memory Address ($A3D0) and binary offset [$A04C]
	move.w	d1,d3																;3601
	asl.w	#$02,d3																;E543
	move.w	d0,d7																;3E00
	beq.s	adrCd00A3E0															;6708
	addq.w	#$02,d3																;5443
	lsr.w	#$01,d7																;E24F
	bne.s	adrCd00A3E0															;6602
	not.l	d6																	;4686
adrCd00A3E0:		; Memory Address ($A3E0) and binary offset [$A05C]
	btst	d2,-$0015(a3)														;052BFFEB
	beq.s	adrCd00A3E8															;6702
	addq.w	#$01,d3																;5243
adrCd00A3E8:		; Memory Address ($A3E8) and binary offset [$A064]
	moveq	#$00,d7																;7E00
	move.b	adrB_00A418(pc,d3.w),d7												;1E3B302C
	swap	d7																	;4847
	move.b	adrB_00A424(pc,d3.w),d7												;1E3B3032
	add.b	adrB_00A430(pc,d3.w),d5												;DA3B303A
	add.w	d3,d3																;D643
	lea		adrEA00A4F2.l,a2													;45F90000A4F2
	lea		GFX_Dragon.l,a1														;43F900048960
	add.w	$00(a2,d3.w),a1														;D2F23000
	tst.w	d6																	;4A46
	bpl.s	adrCd00A410															;6A02
	addq.w	#$01,d3																;5243
adrCd00A410:		; Memory Address ($A410) and binary offset [$A08C]
	add.b	adrB_00A43C(pc,d3.w),d4												;D83B302A
	bra		Draw_Monster_CompositeBitmap										;600002B4

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
adrB_00A424:		; Memory Address ($A424) and binary offset [$A0A0]
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
adrB_00A430:		; Memory Address ($A430) and binary offset [$A0AC]
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
adrB_00A43C:		; Memory Address ($A43C) and binary offset [$A0B8]
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
adrB_00A463:		; Memory Address ($A463) and binary offset [$A0DF]
	dc.b	$00	;00
	dc.b	$01	;01
	dc.b	$02	;02
	dc.b	$81	;81
adrB_00A467:		; Memory Address ($A467) and binary offset [$A0E3]
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

adrCd00A476:		; Memory Address ($A476) and binary offset [$A0F2]
	move.w	d1,d2																;3401
	add.w	d2,d2																;D442
	add.w	d1,d2																;D441
	moveq	#$00,d6																;7C00
	move.b	adrB_00A463(pc,d0.w),d3												;163B00E3
	bpl.s	adrCd00A488															;6A04
	moveq	#-$01,d6															;7CFF
	moveq	#$01,d3																;7601
adrCd00A488:		; Memory Address ($A488) and binary offset [$A104]
	add.b	d3,d2																;D403
	moveq	#$00,d7																;7E00
	move.b	adrB_00A454(pc,d2.w),d7												;1E3B20C6
	swap	d7																	;4847
	move.b	adrB_00A467(pc,d2.w),d7												;1E3B20D3
	add.w	d2,d2																;D442
	lea		adrEA00A4D4.l,a2													;45F90000A4D4
	lea		GFX_Dragon.l,a1														;43F900048960
	add.w	$00(a2,d2.w),a1														;D2F22000
	movem.l	d0/d1/d4/d5/d7/a1,-(sp)												;48E7CD40
	bsr		Draw_Monster_CompositeBitmap										;6100021C
	movem.l	(sp)+,d0/d1/d4/d5/d7/a1												;4CDF02B3
	btst	#$00,d0																;08000000
	bne.s	adrCd00A4CC															;6612
	moveq	#-$01,d6															;7CFF
	movem.w	d0/d1/d4/d5,-(sp)													;48A7CC00
	add.b	GFX_Dragon_MirroredHalf_XPositions(pc,d1.w),d4						;D83B100C
	bsr		Draw_Monster_CompositeBitmap										;61000204
	movem.w	(sp)+,d0/d1/d4/d5													;4C9F0033
adrCd00A4CC:		; Memory Address ($A4CC) and binary offset [$A148]
	rts																			;4E75

GFX_Dragon_MirroredHalf_XPositions:		; Memory Address ($A4CE) and binary offset [$A14A]
	; Horizontal spacing used when the Dragon body is completed by drawing a
	; mirrored second half.
	INCBIN "/data/BLOODWYCH439-clean/monsters/Dragon_MirroredHalf_X.positions"
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
adrEA00A4F2:		; Memory Address ($A4F2) and binary offset [$A16E]
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
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l									;33FCFFFF0000B4BE
	lea		Monster_Behemoth_Colours.l,a0										;41F90000A52E
	moveq	#$06,d3																;7606
	bsr		MonsterColourGrading												;6100F978
	lea		GFX_Behemoth_Layout.l,a0											;41F90000A668
	bsr.s	adrCd00A54C															;6126
	clr.w	Buffer_Colour_Mask_Toggle.l											;42790000B4BE
	rts																			;4E75

Monster_Behemoth_Colours:		; Memory Address ($A52E) and binary offset [$A1AA]
	INCBIN "/data/BLOODWYCH439-clean/monsters/behemoth.colours"
Monster_DistanceGroups_LookupTable:		; Memory Address ($A536) and binary offset [$A1B2]
	; Maps six visible distance slots to four stored size groups used by centred
	; large monsters.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Monster_DistanceGroups.lookup"

Draw_Entropy:		; Memory Address ($A53C) and binary offset [$A1B8]
	move.l	#$04080C,Buffer_Colour_Mask.l										;23FC0004080C0000B4C0
	lea		GFX_Entropy_Layout.l,a0												;41F90000A604
adrCd00A54C:		; Memory Address ($A54C) and binary offset [$A1C8]
	move.b	Monster_DistanceGroups_LookupTable(pc,d1.w),d1						;123B10E8
	lea		$0042(a0),a2														;45E80042

	move.l	$003E(a0),a1														;2268003E    *Fix stored address **

	bsr		adrCd009CA2															;6100F748
	add.b	$16(a0,d1.w),d4														;D8301016
	move.w	d0,d2																;3400
	lsr.w	#$01,d2																;E24A
	bcc.s	adrCd00A56E															;6408
	add.w	d1,d2																;D441
	add.w	d1,d2																;D441
	add.b	$1A(a0,d2.w),d4														;D830201A
adrCd00A56E:		; Memory Address ($A56E) and binary offset [$A1EA]
	movem.l	d0/d1/d4/d5/d7/a0/a1,-(sp)											;48E7CDC0
	bsr		Draw_Monster_CompositeBitmap										;61000156
	movem.l	(sp),d0/d1/d4/d5/d7/a0/a1											;4CD703B3
	btst	#$00,d0																;08000000
	bne.s	adrCd00A58A															;660A
	moveq	#-$01,d6															;7CFF
	add.b	$22(a0,d1.w),d4														;D8301022
	bsr		Draw_Monster_CompositeBitmap										;61000142
adrCd00A58A:		; Memory Address ($A58A) and binary offset [$A206]
	movem.l	(sp)+,d0/d1/d4/d5/d7/a0/a1											;4CDF03B3
	cmpi.b	#$02,d1																;0C010002
	bcc.s	adrCd00A600															;646C
	lea		Buffer_Colour_Mask.l,a6												;4DF90000B4C0
	moveq	#$00,d2																;7400
	moveq	#$00,d6																;7C00
	move.l	a0,-(sp)															;2F08
	bsr.s	adrCd00A5AE															;610C
	move.l	(sp)+,a0															;205F
	btst	#$00,d0																;08000000
	bne.s	adrCd00A600															;6656
	moveq	#$01,d2																;7401
	moveq	#-$01,d6															;7CFF
adrCd00A5AE:		; Memory Address ($A5AE) and binary offset [$A22A]
	movem.w	d0/d1/d4/d5,-(sp)													;48A7CC00
	move.l	$003E(a0),a1														;2268003E
	add.w	d1,d1																;D241
	moveq	#$00,d3																;7600
	btst	d2,-$0015(a3)														;052BFFEB
	beq.s	adrCd00A5C4															;6704
	addq.w	#$01,d1																;5241
	moveq	#-$01,d3															;76FF
adrCd00A5C4:		; Memory Address ($A5C4) and binary offset [$A240]
	moveq	#$00,d7																;7E00
	move.b	$2A(a0,d1.w),d7														;1E30102A
	add.b	$26(a0,d1.w),d5														;DA301026
	add.w	d1,d1																;D241
	add.w	$5A(a0,d1.w),a1														;D2F0105A
	add.w	d1,d1																;D241
	lsr.w	#$01,d0																;E248
	bcc.s	adrCd00A5EE															;6414
	addq.w	#$02,d1																;5441
	tst.w	d3																	;4A43
	bpl.s	adrCd00A5E8															;6A08
	tst.w	-$0002(a0)															;4A68FFFE
	beq.s	adrCd00A5E8															;6702
	not.w	d6																	;4646
adrCd00A5E8:		; Memory Address ($A5E8) and binary offset [$A264]
	tst.w	d0																	;4A40
	bne.s	adrCd00A5EE															;6602
	not.w	d6																	;4646
adrCd00A5EE:		; Memory Address ($A5EE) and binary offset [$A26A]
	tst.w	d6																	;4A46
	beq.s	adrCd00A5F4															;6702
	addq.w	#$01,d1																;5241
adrCd00A5F4:		; Memory Address ($A5F4) and binary offset [$A270]
	add.b	$2E(a0,d1.w),d4														;D830102E
	bsr		Draw_Monster_16PixelStrip											;6100073A
	movem.w	(sp)+,d0/d1/d4/d5													;4C9F0033
adrCd00A600:		; Memory Address ($A600) and binary offset [$A27C]
	rts																			;4E75

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
	add.w	$0008(a5),d5														;DA6D0008
	move.b	d4,d6																;1C04
	add.b	#$60,d4																;06040060
	ext.w	d6																	;4886
	asr.w	#$04,d6																;E846
	move.l	a3,-(sp)															;2F0B
	tst.l	d6																	;4A86
	bmi.s	adrCd00A6E4															;6B06
	bsr		Draw_PlanarSprite_Normal											;6100077E
	bra.s	adrCd00A6E8															;6004

adrCd00A6E4:		; Memory Address ($A6E4) and binary offset [$A360]
	bsr		Draw_PlanarSprite_BitReversed										;61000838
adrCd00A6E8:		; Memory Address ($A6E8) and binary offset [$A364]
	move.l	(sp)+,a3															;265F
	rts																			;4E75

adrCd00A6EC:		; Memory Address ($A6EC) and binary offset [$A368]
	bsr		Prepare_Monster_ScreenPosition										;6100F270
	tst.b	d1																	;4A01
	bpl.s	adrCd00A6F6															;6A02
	rts																			;4E75

adrCd00A6F6:		; Memory Address ($A6F6) and binary offset [$A372]
	move.b	-$0017(a3),d0														;102BFFE9
	bmi		Draw_AirbourneSpell													;6B00F4F4
	move.w	-$000A(a3),d0														;302BFFF6
	btst	#$00,d0																;08000000
	bne.s	adrCd00A70A															;6602
	addq.w	#$02,d0																;5440
adrCd00A70A:		; Memory Address ($A70A) and binary offset [$A386]
	add.b	-$001B(a3),d0														;D02BFFE5
	and.w	#$0003,d0															;02400003
	moveq	#$00,d2																;7400
	move.b	-$0017(a3),d2														;142BFFE9
	sub.b	#Monster_Type_First,d2												;Converts the monster type code into the renderer dispatch index; codes below the first monster type continue to character drawing.
	bcs.s	Draw_Character														;6526
	cmpi.b	#$02,d2																;0C020002
	beq		Draw_Beholder														;6700FA66
	bcs		Draw_Summon															;6500F5AA
	subq.b	#$03,d2																;5702
	lea		Creatures_LookupTable.l,a1											;43F90000A73A
	add.w	d2,d2																;D442
	add.w	$00(a1,d2.w),a1														;D2F12000
	jmp		(a1)																;4ED1

Creatures_LookupTable:		; Memory Address ($A73A) and binary offset [$A3B6]
	dc.w	Draw_Behemoth-Creatures_LookupTable	;FDD0
	dc.w	Draw_Crab-Creatures_LookupTable	;F7C0
	dc.w	Draw_BigDragon-Creatures_LookupTable	;FC12
	dc.w	Draw_LittleDragon-Creatures_LookupTable	;FBF6
	dc.w	Draw_Entropy-Creatures_LookupTable	;FE02

Draw_Character:		; Memory Address ($A744) and binary offset [$A3C0]
	moveq	#$00,d2																;7400
	move.b	-$0017(a3),d2														;142BFFE9
	lea		CharacterHeadSel.l,a0												;41F90000A91A
	move.b	$00(a0,d2.w),-$0018(a3)												;17702000FFE8
	move.w	d1,d2																;3401
	asl.w	#$02,d2																;E542
	add.w	d0,d2																;D440
	add.w	d2,d2																;D442
	move.w	d2,d3																;3602
	asl.w	#$02,d2																;E542
	add.w	d3,d2																;D443
	moveq	#$00,d6																;7C00
	move.b	-$0017(a3),d3														;162BFFE9
	cmpi.b	#$10,d3																;0C030010
	bcc		adrCd00A7F2															;64000082
	move.w	d3,d7																;3E03
	asl.b	#$04,d7																;E907
	lea		Character_Pockets_DataTable+$02.l,a0								;41F90000ED2C
	move.b	$00(a0,d7.w),d7														;1E307000
	cmpi.w	#$0024,d7															;0C470024
	bcc.s	adrCd00A7F2															;646C
	sub.w	#$001B,d7															;0447001B
	bcs.s	adrCd00A7F2															;6566
	move.b	Character_WornArmour_RenderOverrides(pc,d7.w),d6					;1C3B7004
	bra.s	adrCd00A7F2															;6060

Character_WornArmour_RenderOverrides:		; Memory Address ($A792) and binary offset [$A40E]
	; Maps worn body armour $1B-$23 to the alternate character body and colour
	; override flags.
	dc.b	$01,$02,$03,$42,$43,$82,$83,$C2,$C3
	dc.b	$00	;00
CharacterBodySel:		; Memory Address ($A79C) and binary offset [$A418]
	INCBIN "/data/BLOODWYCH439-clean/data/characters.bodies"

adrCd00A7F2:		; Memory Address ($A7F2) and binary offset [$A46E]
	move.b	CharacterBodySel(pc,d3.w),d3										;163B30A8
	beq.s	adrCd00A808															;6710
	tst.w	d6																	;4A46
	beq.s	adrCd00A808															;670C
	cmpi.w	#$0003,d3															;0C430003
	bcc.s	adrCd00A804															;6402
	moveq	#$03,d3																;7603
adrCd00A804:		; Memory Address ($A804) and binary offset [$A480]
	add.b	d6,d3																;D606
	add.b	d6,d3																;D606
adrCd00A808:		; Memory Address ($A808) and binary offset [$A484]
	move.b	d6,-$001C(a3)														;1746FFE4
	lea		Character_BodyDefinitions.l,a0										;41F90000A88E
	and.w	#$000F,d3															;0243000F
	mulu	#$000A,d3															;C6FC000A
	lea		$02(a0,d3.w),a0														;41F03002
	lea		Character_RenderLayout_Standard.l,a1								;43F900018804
	tst.w	-$0002(a0)															;4A68FFFE
	beq.s	adrCd00A830															;6706
	lea		Character_RenderLayout_Alternate.l,a1								;43F900018944
adrCd00A830:		; Memory Address ($A830) and binary offset [$A4AC]
	move.l	a0,-(sp)															;2F08
	move.l	a1,-(sp)															;2F09
	move.w	d2,-(sp)															;3F02
	move.w	d5,-(sp)															;3F05
	move.w	d4,-(sp)															;3F04
	move.w	d1,-(sp)															;3F01
	move.w	d0,-(sp)															;3F00
	cmpi.w	#$0004,d1															;0C410004
	beq		adrCd00AC6E															;6700042A
	cmpi.w	#$0005,d1															;0C410005
	beq		adrCd00AC9C															;67000450
	tst.b	-$0019(a3)															;4A2BFFE7
	bmi.s	adrCd00A876															;6B22
	cmpi.w	#$0003,d1															;0C410003
	bcc.s	adrCd00A876															;641C
	bsr		RandomGen_BytewithOffset											;6100AD50
	move.b	d0,d1																;1200
	and.w	#$000C,d1															;0241000C
	bne.s	adrCd00A876															;6610
	and.w	#$0003,d0															;02400003
	beq.s	adrCd00A876															;670A
	subq.w	#$02,d0																;5540
	add.b	$0005(sp),d0														;D02F0005
	move.b	d0,$0005(sp)														;1F400005
adrCd00A876:		; Memory Address ($A876) and binary offset [$A4F2]
	moveq	#$00,d0																;7000
adrCd00A878:		; Memory Address ($A878) and binary offset [$A4F4]
	move.w	d0,-(sp)															;3F00
	bsr		Draw_CharacterComponent												;6100011C
	move.w	(sp)+,d0															;301F
	addq.w	#$01,d0																;5240
	cmpi.w	#$0005,d0															;0C400005
	bcs.s	adrCd00A878															;65F0
	add.w	#$0012,sp															;DEFC0012
	rts																			;4E75

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
	move.w	d0,d2																;3400
	asl.w	#$02,d2																;E542
	move.w	Character_RenderTableOffsets(pc,d2.w),d1							;323B20D2
	move.w	Character_RenderTableOffsets+$02(pc,d2.w),d3						;363B20D0
	move.l	$0010(sp),a0														;206F0010
	lea		$00(a0,d1.w),a1														;43F01000
	lea		$00(a0,d3.w),a2														;45F03000
	add.w	$000E(sp),a0														;D0EF000E
	add.w	$0006(sp),d2														;D46F0006
	moveq	#$00,d6																;7C00
	move.b	Character_PartFacingVariants(pc,d2.w),d2							;143B20C8
	bpl.s	adrCd00A9C2															;6A02
	subq.w	#$01,d6																;5346
adrCd00A9C2:		; Memory Address ($A9C2) and binary offset [$A63E]
	cmpi.b	#$FF,d2																;0C0200FF
	bne.s	adrCd00A9CA															;6602
	rts																			;4E75

adrCd00A9CA:		; Memory Address ($A9CA) and binary offset [$A646]
	cmpi.w	#$0003,d0															;0C400003
	bcs.s	adrCd00A9DC															;650C
	move.w	d0,d1																;3200
	subq.w	#$03,d1																;5741
	btst	d1,-$0015(a3)														;032BFFEB
	beq.s	adrCd00A9DC															;6702
	moveq	#$02,d2																;7402
adrCd00A9DC:		; Memory Address ($A9DC) and binary offset [$A658]
	and.w	#$007F,d2															;0242007F
	move.w	$0008(sp),d1														;322F0008
	add.w	d1,d1																;D241
	add.w	$0008(sp),d1														;D26F0008
	add.w	d1,d2																;D441
	moveq	#$00,d7																;7E00
	move.b	$00(a1,d2.w),d7														;1E312000
	add.w	d2,d2																;D442
	moveq	#$00,d1																;7200
	move.w	$00(a2,d2.w),d1														;32322000
	cmpi.w	#$0002,d0															;0C400002
	bne.s	adrCd00AA14															;6614
	move.b	-$0018(a3),d0														;102BFFE8
	mulu	#$0378,d0															;C0FC0378
	lea		$FFFFC190.l,a1														;43F9FFFFC190
	add.w	d0,d1																;D240
	add.w	d1,a1																;D2C1
	bra.s	adrCd00AA24															;6010

adrCd00AA14:		; Memory Address ($AA14) and binary offset [$A690]
	bcs.s	adrCd00AA18															;6502
	moveq	#$02,d0																;7002
adrCd00AA18:		; Memory Address ($AA18) and binary offset [$A694]
	move.l	$0014(sp),a1														;226F0014
	add.w	d0,d0																;D040
	add.w	$00(a1,d0.w),d1														;D2710000
	move.l	d1,a1																;2241
adrCd00AA24:		; Memory Address ($AA24) and binary offset [$A6A0]
	move.w	$000C(sp),d5														;3A2F000C
	move.w	$000A(sp),d4														;382F000A
	move.w	$0004(sp),d0														;302F0004
	add.w	d0,d0																;D040
	add.b	$00(a0,d0.w),d4														;D8300000
	add.b	$01(a0,d0.w),d5														;DA300001
	lea		adrEA00ABF6.l,a6													;4DF90000ABF6
	cmpi.w	#$0004,d0															;0C400004
	bcs.s	adrCd00AA92															;654C
	bne.s	adrCd00AA4E															;6606
	moveq	#$00,d0																;7000
	bra		adrCd00AADC															;60000090

adrCd00AA4E:		; Memory Address ($AA4E) and binary offset [$A6CA]
	move.w	$0004(sp),d1														;322F0004
	subq.w	#$03,d1																;5741
	btst	d1,-$0015(a3)														;032BFFEB
	beq.s	adrCd00AA90															;6736
	move.w	$0008(sp),d1														;322F0008
	subq.w	#$06,d0																;5D40
	add.w	d0,d0																;D040
	lea		Character_ArmAnimationPositions.l,a0								;41F90000AAFC
	cmp.l	#Character_RenderLayout_Alternate,$0010(sp)							;0CAF000189440010
	bne.s	adrCd00AA76															;6604
	add.w	#$0024,a0															;D0FC0024
adrCd00AA76:		; Memory Address ($AA76) and binary offset [$A6F2]
	sub.b	$00(a0,d1.w),d5														;9A301000
	addq.w	#$04,a0																;5848
	asl.w	#$03,d1																;E741
	add.w	$0006(sp),d1														;D26F0006
	add.w	d1,d0																;D041
	add.b	$00(a0,d0.w),d4														;D8300000
	btst	#$00,d1																;08010000
	beq.s	adrCd00AA90															;6702
	not.w	d6																	;4646
adrCd00AA90:		; Memory Address ($AA90) and binary offset [$A70C]
	moveq	#$04,d0																;7004
adrCd00AA92:		; Memory Address ($AA92) and binary offset [$A70E]
	moveq	#$00,d1																;7200
	move.b	-$001C(a3),d1														;122BFFE4
	beq		adrCd00AAD8															;6700003E
	subq.b	#$01,d1																;5301
	move.b	d1,d2																;1401
	asl.b	#$03,d1																;E701
	add.b	d2,d1																;D202
	asl.b	#$02,d1																;E501
	move.l	$0014(sp),a6														;2C6F0014
	addq.w	#$08,d1																;5041
	tst.w	-$0002(a6)															;4A6EFFFE
	bne.s	adrCd00AABC															;660A
	subq.w	#$04,d1																;5941
	cmp.w	#$2BE0,(a6)															;0C562BE0
	bne.s	adrCd00AABC															;6602
	subq.w	#$04,d1																;5941
adrCd00AABC:		; Memory Address ($AABC) and binary offset [$A738]
	lea		adrEA00ABA6.l,a0													;41F90000ABA6
	add.w	d1,a0																;D0C1
	move.w	d0,d1																;3200
	add.w	d1,d1																;D241
	add.w	d0,d1																;D240
	add.w	d1,d1																;D241
	cmp.b	#$FF,$00(a0,d1.w)													;0C3000FF1000
	beq.s	adrCd00AAD8															;6704
	bsr.s	Prepare_CharacterComponentColourMask								;616E
	bra.s	adrCd00AAF8															;6020

adrCd00AAD8:		; Memory Address ($AAD8) and binary offset [$A754]
	add.w	d0,d0																;D040
	addq.w	#$04,d0																;5840
adrCd00AADC:		; Memory Address ($AADC) and binary offset [$A758]
	moveq	#$00,d1																;7200
	move.b	-$0017(a3),d1														;122BFFE9
	asl.w	#$02,d1																;E541
	moveq	#$00,d2																;7400
	move.b	-$0017(a3),d2														;142BFFE9
	add.w	d2,d1																;D242
	asl.w	#$02,d1																;E541
	add.w	d1,d0																;D041
	lea		CharacterColours.l,a6												;4DF9000351C8
	add.w	d0,a6																;DCC0
adrCd00AAF8:		; Memory Address ($AAF8) and binary offset [$A774]
	bra		adrCd00AD2E															;60000234

Character_ArmAnimationPositions:		; Memory Address ($AAFC) and binary offset [$A778]
	; Standard and alternate animated-arm Y corrections and facing-specific X
	; corrections.
	INCBIN "/data/BLOODWYCH439-clean/data/characters-arm-animation.positions"

Prepare_CharacterComponentColourMask:		; Memory Address ($AB44) and binary offset [$A7C0]
	; Builds a character-component colour mask and applies worn-armour material and
	; character-specific palette substitutions.
	lea		Buffer_Colour_Mask.l,a6												;4DF90000B4C0
	move.l	$00(a0,d1.w),(a6)													;2CB01000
	move.b	-$001C(a3),d1														;122BFFE4
	rol.b	#$02,d1																;E519
	and.w	#$0003,d1															;02410003
	beq.s	adrCd00AB7C															;6722
	move.b	Character_ArmourMaterial_PalettePairEnds(pc,d1.w),d1				;123B1046
	moveq	#$03,d2																;7403
adrLp00AB60:		; Memory Address ($AB60) and binary offset [$A7DC]
	move.b	d1,d3																;1601
	cmp.b	#$04,$00(a6,d2.w)													;0C3600042000
	beq.s	adrCd00AB74															;670A
	subq.b	#$01,d3																;5303
	cmp.b	#$03,$00(a6,d2.w)													;0C3600032000
	bne.s	adrCd00AB78															;6604
adrCd00AB74:		; Memory Address ($AB74) and binary offset [$A7F0]
	move.b	d3,$00(a6,d2.w)														;1D832000
adrCd00AB78:		; Memory Address ($AB78) and binary offset [$A7F4]
	dbra	d2,adrLp00AB60														;51CAFFE6
adrCd00AB7C:		; Memory Address ($AB7C) and binary offset [$A7F8]
	lea		adrEA00AC12.l,a0													;41F90000AC12
	move.b	-$0018(a3),d1														;122BFFE8
	asl.w	#$02,d1																;E541
	add.w	d1,a0																;D0C1
	moveq	#$03,d2																;7403
adrLp00AB8C:		; Memory Address ($AB8C) and binary offset [$A808]
	move.b	$00(a6,d2.w),d1														;12362000
	bpl.s	adrCd00AB9C															;6A0A
	and.w	#$0003,d1															;02410003
	move.b	$00(a0,d1.w),$00(a6,d2.w)											;1DB010002000
adrCd00AB9C:		; Memory Address ($AB9C) and binary offset [$A818]
	dbra	d2,adrLp00AB8C														;51CAFFEE
	rts																			;4E75

Character_ArmourMaterial_PalettePairEnds:		; Memory Address ($ABA2) and binary offset [$A81E]
	; Maps ordinary, Mithril, Adamant and Crystal armour material codes to the
	; brighter palette index of each adjacent dark/light colour pair.
	INCBIN "/data/BLOODWYCH439-clean/data/characters-armour-material.palette"
adrEA00ABA6:		; Memory Address ($ABA6) and binary offset [$A822]
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
adrEA00ABF6:		; Memory Address ($ABF6) and binary offset [$A872]
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
adrEA00AC12:		; Memory Address ($AC12) and binary offset [$A88E]
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
adrEA00AC52:		; Memory Address ($AC52) and binary offset [$A8CE]
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
adrEA00AC5E:		; Memory Address ($AC5E) and binary offset [$A8DA]
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

adrCd00AC6E:		; Memory Address ($AC6E) and binary offset [$A8EA]
	move.w	-$0002(a0),-(sp)													;3F28FFFE
	moveq	#$00,d3																;7600
	move.w	$0006(a0),d3														;36280006
	tst.w	(sp)																;4A57
	beq.s	adrCd00AC8C															;6710
	moveq	#$14,d7																;7E14
	move.w	#$00A8,d2															;343C00A8
	lea		Character_Distant4_Positions_Alternate.l,a0							;41F900018A74
	bra		adrCd00ACCC															;60000042

adrCd00AC8C:		; Memory Address ($AC8C) and binary offset [$A908]
	moveq	#$15,d7																;7E15
	move.w	#$00B0,d2															;343C00B0
	lea		Character_Distant4_Positions_Standard.l,a0							;41F900018934
	bra		adrCd00ACCC															;60000032

adrCd00AC9C:		; Memory Address ($AC9C) and binary offset [$A918]
	move.w	-$0002(a0),-(sp)													;3F28FFFE
	moveq	#$00,d3																;7600
	move.w	$0006(a0),d3														;36280006
	tst.w	(sp)																;4A57
	beq.s	adrCd00ACBC															;6712
	moveq	#$0F,d7																;7E0F
	move.w	#$0080,d2															;343C0080
	lea		Character_Distant5_Positions_Alternate.l,a0							;41F900018A7C
	add.w	#$01F8,d3															;064301F8
	bra.s	adrCd00ACCC															;6010

adrCd00ACBC:		; Memory Address ($ACBC) and binary offset [$A938]
	moveq	#$10,d7																;7E10
	move.w	#$0088,d2															;343C0088
	lea		Character_Distant5_Positions_Standard.l,a0							;41F90001893C
	add.w	#$0210,d3															;06430210
adrCd00ACCC:		; Memory Address ($ACCC) and binary offset [$A948]
	move.l	d3,a1																;2243
	add.w	d0,d0																;D040
	add.b	$00(a0,d0.w),d4														;D8300000
	add.b	$01(a0,d0.w),d5														;DA300001
	moveq	#$00,d6																;7C00
	cmpi.w	#$0006,d0															;0C400006
	bne.s	adrCd00ACE4															;6604
	subq.w	#$01,d6																;5346
	subq.w	#$04,d0																;5940
adrCd00ACE4:		; Memory Address ($ACE4) and binary offset [$A960]
	lsr.w	#$01,d0																;E248
	mulu	d0,d2																;C4C0
	add.w	d2,a1																;D2C2
	moveq	#$00,d1																;7200
	move.b	-$001C(a3),d1														;122BFFE4
	beq.s	adrCd00AD0E															;671C
	and.w	#$0003,d1															;02410003
	asl.w	#$02,d1																;E541
	lea		adrEA00AC52.l,a0													;41F90000AC52
	tst.w	(sp)																;4A57
	beq.s	adrCd00AD08															;6706
	lea		adrEA00AC5E.l,a0													;41F90000AC5E
adrCd00AD08:		; Memory Address ($AD08) and binary offset [$A984]
	bsr		Prepare_CharacterComponentColourMask								;6100FE3A
	bra.s	adrCd00AD26															;6018

adrCd00AD0E:		; Memory Address ($AD0E) and binary offset [$A98A]
	move.b	-$0017(a3),d1														;122BFFE9
	asl.w	#$02,d1																;E541
	moveq	#$00,d0																;7000
	move.b	-$0017(a3),d0														;102BFFE9
	add.w	d0,d1																;D240
	asl.w	#$02,d1																;E541
	lea		CharacterColours+$10.l,a6											;4DF9000351D8
	add.w	d1,a6																;DCC1
adrCd00AD26:		; Memory Address ($AD26) and binary offset [$A9A2]
	bsr.s	adrCd00AD2E															;6106
	add.w	#$0014,sp															;DEFC0014
	rts																			;4E75

adrCd00AD2E:		; Memory Address ($AD2E) and binary offset [$A9AA]
	add.l	#GFX_BodyParts,a1													;D3FC000396F0	;Long Addr replaced with Symbol
Draw_Monster_16PixelStrip:		; Memory Address ($AD34) and binary offset [$A9B0]
	; Writes one 16-pixel planar monster strip into the dungeon viewport, applying
	; mirroring and colour substitution.
	move.w	d5,d0																;3005
	add.w	d7,d0																;D047
	sub.w	MonsterStrip_BottomY.l,d0											;90790000AD64
	bcs.s	adrCd00AD42															;6502
	sub.w	d0,d7																;9E40
adrCd00AD42:		; Memory Address ($AD42) and binary offset [$A9BE]
	swap	d7																	;4847
	move.b	d4,d7																;1E04
	ext.w	d7																	;4887
	move.l	-$0008(a3),a0														;206BFFF8
	mulu	#$0028,d5															;CAFC0028
	and.w	#$FFF0,d7															;0247FFF0
	asr.w	#$03,d7																;E647
	add.w	d7,d5																;DA47
	add.w	d5,a0																;D0C5
	asr.w	#$01,d7																;E247
	move.l	a3,-(sp)															;2F0B
	bsr.s	Draw_MonsterStrip_Shifted											;6130
	move.l	(sp)+,a3															;265F
	rts																			;4E75

MonsterStrip_BottomY:		; Memory Address ($AD64) and binary offset [$A9E0]
	; Mutable lower Y clipping boundary used by the 16-pixel monster-strip
	; renderer.
	dc.w	$004B	;004B

Reverse_PlanarLongwordBits:		; Memory Address ($AD66) and binary offset [$A9E2]
	; Loads the byte-reversal lookup and reverses all 32 bits of a planar source
	; longword.
	lea		BitReverse_LookupBuffer.l,a6										;4DF90001684C
Reverse_PlanarLongwordBits_WithLookup:		; Memory Address ($AD6C) and binary offset [$A9E8]
	; Reverses a planar source longword using four byte lookups when the lookup
	; base is already loaded.
	moveq	#$00,d2																;7400
	move.b	d0,d2																;1400
	move.b	$00(a6,d2.w),d0														;10362000
	ror.w	#$08,d0																;E058
	move.b	d0,d2																;1400
	move.b	$00(a6,d2.w),d0														;10362000
	swap	d0																	;4840
	move.b	d0,d2																;1400
	move.b	$00(a6,d2.w),d0														;10362000
	ror.w	#$08,d0																;E058
	move.b	d0,d2																;1400
	move.b	$00(a6,d2.w),d0														;10362000
	swap	d0																	;4840
	rts																			;4E75

Draw_MonsterStrip_Shifted:		; Memory Address ($AD90) and binary offset [$AA0C]
	; Shifts, clips, mirrors when requested, recolours, and merges a monster strip
	; into the dungeon viewport.
	and.w	#$000F,d4															;0244000F
	swap	d6																	;4846
	move.w	d7,d6																;3C07
	moveq	#-$01,d5															;7AFF
	lsr.w	d4,d5																;E86D
	move.w	d5,d0																;3005
	swap	d5																	;4845
	move.w	d0,d5																;3A00
	swap	d7																	;4847
adrLp00ADA4:		; Memory Address ($ADA4) and binary offset [$AA20]
	swap	d7																	;4847
	move.w	d6,d7																;3E06
	move.l	(a1)+,d0															;2019
	move.l	(a1)+,d1															;2219
	tst.l	d6																	;4A86
	bpl.s	adrCd00ADBC															;6A0C
	move.l	a6,a2																;244E
	bsr.s	Reverse_PlanarLongwordBits											;61B2
	exg		d0,d1																;C141
	bsr.s	Reverse_PlanarLongwordBits_WithLookup								;61B4
	exg		d0,d1																;C141
	move.l	a2,a6																;2C4A
adrCd00ADBC:		; Memory Address ($ADBC) and binary offset [$AA38]
	ror.l	d4,d0																;E8B8
	ror.l	d4,d1																;E8B9
	move.l	d0,a2																;2440
	move.l	d1,a3																;2641
	and.l	d5,d0																;C085
	and.l	d5,d1																;C285
	not.l	d5																	;4685
	or.l	d5,d0																;8085
	or.l	d5,d1																;8285
	bsr		Composite_PlanarSpriteWord_IfVisible								;6100003A
	addq.w	#$01,d7																;5247
	move.l	a2,d0																;200A
	move.l	a3,d1																;220B
	and.l	d5,d0																;C085
	and.l	d5,d1																;C285
	not.l	d5																	;4685
	or.l	d5,d0																;8085
	or.l	d5,d1																;8285
	swap	d0																	;4840
	swap	d1																	;4841
	move.l	d0,d2																;2400
	and.l	d1,d2																;C481
	addq.l	#$01,d2																;5282
	bne.s	adrCd00ADF2															;6604
	addq.w	#$02,a0																;5448
	bra.s	adrCd00ADF6															;6004

adrCd00ADF2:		; Memory Address ($ADF2) and binary offset [$AA6E]
	bsr		Composite_PlanarSpriteWord_IfVisible								;61000016
adrCd00ADF6:		; Memory Address ($ADF6) and binary offset [$AA72]
	add.w	#$0024,a0															;D0FC0024
	swap	d7																	;4847
	dbra	d7,adrLp00ADA4														;51CFFFA6
	rts																			;4E75

adrCd00AE02:		; Memory Address ($AE02) and binary offset [$AA7E]
	cmpi.w	#$0008,d6															;0C460008
	bcc.s	adrCd00AE58															;6450
	bra.s	Merge_PlanarSpriteWord												;600A

Composite_PlanarSpriteWord_IfVisible:		; Memory Address ($AE0A) and binary offset [$AA86]
	; Skips horizontally clipped words and otherwise recolours and merges one
	; planar sprite word.
	cmpi.w	#$0008,d7															;0C470008
	bcc.s	adrCd00AE58															;6448
	bsr		Remap_PlanarSpriteColours											;610001BE
Merge_PlanarSpriteWord:		; Memory Address ($AE14) and binary offset [$AA90]
	; Builds the transparent-pixel mask and merges one sprite word into all four
	; destination bitplanes.
	move.l	d1,d2																;2401
	and.l	d0,d2																;C480
	swap	d2																	;4842
	and.l	d0,d2																;C480
	and.l	d1,d2																;C481
	not.l	d2																	;4682
	and.l	d2,d0																;C082
	and.l	d2,d1																;C282
	not.l	d2																	;4682
	move.w	$5DC0(a0),d3														;36285DC0
	and.w	d2,d3																;C642
	or.w	d1,d3																;8641
	move.w	d3,$5DC0(a0)														;31435DC0
	swap	d1																	;4841
	move.w	$3E80(a0),d3														;36283E80
	and.w	d2,d3																;C642
	or.w	d1,d3																;8641
	move.w	d3,$3E80(a0)														;31433E80
	move.w	$1F40(a0),d3														;36281F40
	and.w	d2,d3																;C642
	or.w	d0,d3																;8640
	move.w	d3,$1F40(a0)														;31431F40
	swap	d0																	;4840
	move.w	(a0),d3																;3610
	and.w	d2,d3																;C642
	or.w	d0,d3																;8640
	move.w	d3,(a0)+															;30C3
	rts																			;4E75

adrCd00AE58:		; Memory Address ($AE58) and binary offset [$AAD4]
	addq.w	#$02,a0																;5448
	rts																			;4E75

adrW_00AE5C:		; Memory Address ($AE5C) and binary offset [$AAD8]
	ds.b	$2
Draw_PlanarSprite_Normal:		; Memory Address ($AE5E) and binary offset [$AADA]
	; Initialises and draws an ordinary aligned or shifted planar sprite into the
	; screen bitplanes.
	clr.w	adrW_00AE5C.l														;42790000AE5C
	bra.s	Draw_PlanarSprite_Normal_Setup										;6008

adrCd00AE66:		; Memory Address ($AE66) and binary offset [$AAE2]
	move.w	#$FFFF,adrW_00AE5C.l												;33FCFFFF0000AE5C
Draw_PlanarSprite_Normal_Setup:		; Memory Address ($AE6E) and binary offset [$AAEA]
	; Calculates the destination address and horizontal shift before entering the
	; normal planar sprite loops.
	move.w	d4,d1																;3204
	and.w	#$FFF7,d4															;0244FFF7
	bsr		BW_xy_to_offset														;61002DDE
	move.w	d1,d4																;3801
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	d0,a0																;D0C0
	and.w	#$000F,d4															;0244000F
	moveq	#-$01,d5															;7AFF
	lsr.w	d4,d5																;E86D
	move.w	d5,d0																;3005
	swap	d5																	;4845
	move.w	d0,d5																;3A00
	not.l	d5																	;4685
	lea		Buffer_Colour_Mask.l,a6												;4DF90000B4C0
adrLp00AE98:		; Memory Address ($AE98) and binary offset [$AB14]
	swap	d7																	;4847
	move.w	d6,-(sp)															;3F06
	move.w	d7,-(sp)															;3F07
	move.l	d5,d2																;2405
	move.l	d5,d3																;2605
adrLp00AEA2:		; Memory Address ($AEA2) and binary offset [$AB1E]
	move.l	(a1)+,d0															;2019
	move.l	(a1)+,d1															;2219
	tst.w	Buffer_Colour_Mask_Toggle.l											;4A790000B4BE
	beq.s	adrCd00AEB2															;6704
	bsr		Remap_PlanarSpriteColours											;61000120
adrCd00AEB2:		; Memory Address ($AEB2) and binary offset [$AB2E]
	ror.l	d4,d0																;E8B8
	ror.l	d4,d1																;E8B9
	move.l	d0,a2																;2440
	move.l	d1,a3																;2641
	not.l	d5																	;4685
	and.l	d5,d0																;C085
	and.l	d5,d1																;C285
	not.l	d5																	;4685
	or.l	d2,d0																;8082
	or.l	d3,d1																;8283
	bsr		adrCd00AE02															;6100FF3A
	addq.w	#$01,d6																;5246
	move.l	a2,d2																;240A
	move.l	a3,d3																;260B
	and.l	d5,d2																;C485
	and.l	d5,d3																;C685
	swap	d2																	;4842
	swap	d3																	;4843
	dbra	d7,adrLp00AEA2														;51CFFFC8
	move.w	(sp)+,d7															;3E1F
	not.l	d5																	;4685
	or.l	d5,d2																;8485
	or.l	d5,d3																;8685
	not.l	d5																	;4685
	move.l	d2,d0																;2002
	move.l	d3,d1																;2203
	and.l	d3,d2																;C483
	addq.l	#$01,d2																;5282
	bne.s	adrCd00AEF4															;6604
	addq.w	#$02,a0																;5448
	bra.s	adrCd00AEF8															;6004

adrCd00AEF4:		; Memory Address ($AEF4) and binary offset [$AB70]
	bsr		adrCd00AE02															;6100FF0C
adrCd00AEF8:		; Memory Address ($AEF8) and binary offset [$AB74]
	move.w	d7,d0																;3007
	add.w	d0,d0																;D040
	tst.w	adrW_00AE5C.l														;4A790000AE5C
	beq.s	adrCd00AF0E															;670A
	add.w	#$0098,a1															;D2FC0098
	move.w	d0,d6																;3C00
	asl.w	#$02,d6																;E546
	sub.w	d6,a1																;92C6
adrCd00AF0E:		; Memory Address ($AF0E) and binary offset [$AB8A]
	lea		$0024(a0),a0														;41E80024
	sub.w	d0,a0																;90C0
	move.w	(sp)+,d6															;3C1F
	swap	d7																	;4847
	dbra	d7,adrLp00AE98														;51CFFF7E
	rts																			;4E75

Draw_PlanarSprite_BitReversed:		; Memory Address ($AF1E) and binary offset [$AB9A]
	; Draws a horizontally reversed aligned or shifted planar sprite into the
	; screen bitplanes.
	move.w	d4,d1																;3204
	and.w	#$FFF7,d4															;0244FFF7
	bsr		BW_xy_to_offset														;61002D2E
	move.w	d1,d4																;3801
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	d0,a0																;D0C0
	and.w	#$000F,d4															;0244000F
	moveq	#-$01,d5															;7AFF
	lsr.w	d4,d5																;E86D
	move.w	d5,d0																;3005
	swap	d5																	;4845
	move.w	d0,d5																;3A00
	not.l	d5																	;4685
adrLp00AF42:		; Memory Address ($AF42) and binary offset [$ABBE]
	swap	d7																	;4847
	move.w	d6,-(sp)															;3F06
	move.w	d7,-(sp)															;3F07
	move.w	d7,d2																;3407
	addq.w	#$01,d2																;5242
	asl.w	#$03,d2																;E742
	add.w	d2,a1																;D2C2
	move.l	d5,d2																;2405
	move.l	d5,d3																;2605
adrLp00AF54:		; Memory Address ($AF54) and binary offset [$ABD0]
	move.l	d2,a2																;2442
	move.l	-(a1),d0															;2021
	bsr		Reverse_PlanarLongwordBits											;6100FE0C
	move.l	d0,d1																;2200
	move.l	-(a1),d0															;2021
	bsr		Reverse_PlanarLongwordBits_WithLookup								;6100FE0A
	move.l	a2,d2																;240A
	lea		Buffer_Colour_Mask.l,a6												;4DF90000B4C0
	bsr		Remap_PlanarSpriteColours											;61000062
	ror.l	d4,d0																;E8B8
	ror.l	d4,d1																;E8B9
	move.l	d0,a2																;2440
	move.l	d1,a3																;2641
	not.l	d5																	;4685
	and.l	d5,d0																;C085
	and.l	d5,d1																;C285
	not.l	d5																	;4685
	or.l	d2,d0																;8082
	or.l	d3,d1																;8283
	bsr		adrCd00AE02															;6100FE7C
	addq.w	#$01,d6																;5246
	move.l	a2,d2																;240A
	move.l	a3,d3																;260B
	and.l	d5,d2																;C485
	and.l	d5,d3																;C685
	swap	d2																	;4842
	swap	d3																	;4843
	dbra	d7,adrLp00AF54														;51CFFFBC
	move.w	(sp)+,d7															;3E1F
	not.l	d5																	;4685
	or.l	d5,d2																;8485
	or.l	d5,d3																;8685
	not.l	d5																	;4685
	move.l	d2,d0																;2002
	move.l	d3,d1																;2203
	and.l	d3,d2																;C483
	addq.l	#$01,d2																;5282
	bne.s	adrCd00AFB2															;6604
	addq.w	#$02,a0																;5448
	bra.s	adrCd00AFB6															;6004

adrCd00AFB2:		; Memory Address ($AFB2) and binary offset [$AC2E]
	bsr		adrCd00AE02															;6100FE4E
adrCd00AFB6:		; Memory Address ($AFB6) and binary offset [$AC32]
	move.w	d7,d0																;3007
	addq.w	#$01,d0																;5240
	add.w	d0,d0																;D040
	lea		$0026(a0),a0														;41E80026
	sub.w	d0,a0																;90C0
	asl.w	#$02,d0																;E540
	add.w	d0,a1																;D2C0
	move.w	(sp)+,d6															;3C1F
	swap	d7																	;4847
	dbra	d7,adrLp00AF42														;51CFFF76
	rts																			;4E75

Remap_PlanarSpriteColours:		; Memory Address ($AFD0) and binary offset [$AC4C]
	; Remaps the planar source colour indices through the active four-byte
	; colour-mask table.
	movem.l	d2-d7,-(sp)															;48E73F00
	move.l	d0,d2																;2400
	swap	d2																	;4842
	or.l	d0,d2																;8480
	not.l	d2																	;4682
	beq.s	adrCd00B036															;6758
	move.l	d0,-(sp)															;2F00
	moveq	#$00,d4																;7800
	moveq	#$00,d5																;7A00
	move.w	d5,d7																;3E05
	move.l	d1,d3																;2601
	swap	d3																	;4843
	or.l	d1,d3																;8681
	not.l	d3																	;4683
	and.l	d2,d3																;C682
	beq.s	adrCd00AFF4															;6702
	bsr.s	Accumulate_PlanarColourMask											;6148
adrCd00AFF4:		; Memory Address ($AFF4) and binary offset [$AC70]
	addq.w	#$01,d7																;5247
	move.l	d3,d0																;2003
	not.l	d0																	;4680
	move.w	d1,d3																;3601
	swap	d3																	;4843
	move.w	d1,d3																;3601
	not.l	d3																	;4683
	and.l	d0,d3																;C680
	and.l	d2,d3																;C682
	beq.s	adrCd00B00A															;6702
	bsr.s	Accumulate_PlanarColourMask											;6132
adrCd00B00A:		; Memory Address ($B00A) and binary offset [$AC86]
	addq.w	#$01,d7																;5247
	move.l	d1,d3																;2601
	swap	d1																	;4841
	move.w	d1,d3																;3601
	not.l	d3																	;4683
	and.l	d0,d3																;C680
	and.l	d2,d3																;C682
	beq.s	adrCd00B01C															;6702
	bsr.s	Accumulate_PlanarColourMask											;6120
adrCd00B01C:		; Memory Address ($B01C) and binary offset [$AC98]
	addq.w	#$01,d7																;5247
	move.l	d1,d3																;2601
	swap	d1																	;4841
	and.l	d1,d3																;C681
	and.l	d2,d3																;C682
	beq.s	adrCd00B02A															;6702
	bsr.s	Accumulate_PlanarColourMask											;6112
adrCd00B02A:		; Memory Address ($B02A) and binary offset [$ACA6]
	not.l	d2																	;4682
	move.l	(sp)+,d0															;201F
	and.l	d2,d0																;C082
	or.l	d4,d0																;8084
	and.l	d2,d1																;C282
	or.l	d5,d1																;8285
adrCd00B036:		; Memory Address ($B036) and binary offset [$ACB2]
	movem.l	(sp)+,d2-d7															;4CDF00FC
	rts																			;4E75

Accumulate_PlanarColourMask:		; Memory Address ($B03C) and binary offset [$ACB8]
	; Accumulates destination bitplane bits for one populated source-colour
	; combination.
	move.b	$00(a6,d7.w),d6														;1C367000
	beq.s	adrCd00B062															;6720
	add.w	d6,d6																;DC46
	add.w	d6,d6																;DC46
	and.w	#PlanarColourMask_IndexMask,d6										;Converts each two-bit destination colour pair into one of four longword plane masks.
	move.l	Bitplane_Mask(pc,d6.w),d6											;2C3B6018
	and.l	d3,d6																;CC83
	or.l	d6,d4																;8886
	move.b	$00(a6,d7.w),d6														;1C367000
	and.w	#PlanarColourMask_IndexMask,d6										;Converts each two-bit destination colour pair into one of four longword plane masks.
	move.l	Bitplane_Mask(pc,d6.w),d6											;2C3B6008
	and.l	d3,d6																;CC83
	or.l	d6,d5																;8A86
adrCd00B062:		; Memory Address ($B062) and binary offset [$ACDE]
	rts																			;4E75

Bitplane_Mask:		; Memory Address ($B064) and binary offset [$ACE0]
	; Four 32-bit plane-write masks selected by a two-bit colour value during
	; planar graphic composition.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Dungeon_BitplaneMasks.lookup"

Draw_MainWallFace_ByPatternParity:		; Memory Address ($B074) and binary offset [$ACF0]
	; Dispatches one main-wall face through the ordinary or
	; lookup-selected/bit-reversed path according to (player X + player Y + facing)
	; & 1.
	tst.w	-$000C(a3)															;4A6BFFF4
	bne		Draw_MainWallFace													;6600022A
	move.w	d6,d0																;3006
	bsr		Select_MainWallGraphicTables										;610003F4
	swap	d3																	;4843
	move.l	a3,-(sp)															;2F0B
	bsr		Draw_WallComponent_Transformed										;61000458
	move.l	(sp)+,a3															;265F
Draw_Main_Object_Overlay:		; Memory Address ($B08C) and binary offset [$AD08]
	; Draws the selected wall overlay and dispatches switch, sign, shelf, socket,
	; or other wall-feature artwork.
	tst.b	-$0015(a3)															;4A2BFFEB
	beq.s	adrCd00B062															;67D0
	addq.b	#$01,-$0015(a3)														;522BFFEB
	beq		Draw_Main_Shelf_Overlay												;67000148
	addq.b	#$01,-$0015(a3)														;522BFFEB
	beq		Draw_Main_Sign_Overlay												;6700009C
	addq.b	#$01,-$0015(a3)														;522BFFEB
	beq.s	Draw_Main_Switch_Overlay											;6746
	lea		GFX_Main_Slots_Offsets.l,a0											;41F90000B224
	lea		GFX_Main_Slots_Positions.l,a2										;45F90000BE36
	lea		GFX_Slots.l,a1														;43F9000287A0
	lea		GFX_Main_Slots_Palette.l,a6											;4DF90000B204
	move.b	-$0012(a3),d1														;122BFFEE
	lsr.w	#$03,d1																;E649
	bsr		Load_WallOverlay_ColourMask											;6100010C
	btst	#$02,-$0012(a3)														;082B0002FFEE
	beq.s	Draw_Main_Slot_Overlay												;6702
	clr.b	d0																	;4200
Draw_Main_Slot_Overlay:		; Memory Address ($B0D4) and binary offset [$AD50]
	; Applies the selected socket or lock-slot colour mask and draws the main-wall
	; slot component.
	move.l	d0,Buffer_Colour_Mask.l												;23C00000B4C0
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l									;33FCFFFF0000B4BE
	bsr		Draw_WallComponentFace												;6100032C
	clr.w	Buffer_Colour_Mask_Toggle.l											;42790000B4BE
	rts																			;4E75

Draw_Main_Switch_Overlay:		; Memory Address ($B0EE) and binary offset [$AD6A]
	; Selects the main-wall switch graphic and builds its state-dependent colour
	; mask.
	lea		GFX_Main_Switches_Offsets.l,a0										;41F900018C2E
	lea		GFX_Main_Switches_Positions.l,a2									;45F90000BEA6
	lea		GFX_Switches.l,a1													;43F9000284E8
	moveq	#$00,d0																;7000
	move.b	-$0012(a3),d1														;122BFFEE
	and.w	#$00F8,d1															;024100F8
	beq.s	Draw_Main_Switch_Overlay_WithColourMask								;6716
	bsr		Select_MainSwitch_ColourMask										;610000B8
	btst	#$02,-$0012(a3)														;082B0002FFEE
	beq.s	Draw_Main_Switch_Overlay_WithColourMask								;670A
	and.w	#$00FF,d0															;024000FF
	swap	d0																	;4840
	move.b	$02(a6,d1.w),d0														;10361002
Draw_Main_Switch_Overlay_WithColourMask:		; Memory Address ($B122) and binary offset [$AD9E]
	; Applies the resolved switch-state colour mask and draws the main-wall switch
	; component.
	move.l	d0,Buffer_Colour_Mask.l												;23C00000B4C0
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l									;33FCFFFF0000B4BE
	bsr		Draw_WallComponentFace												;610002DE
	clr.w	Buffer_Colour_Mask_Toggle.l											;42790000B4BE
	rts																			;4E75

Draw_Main_Sign_Overlay:		; Memory Address ($B13C) and binary offset [$ADB8]
	; Draws a recoloured wall sign followed by its directional generated-symbol
	; overlay when applicable.
	move.w	d6,-(sp)															;3F06
	lea		GFX_Main_Sign_Offsets.l,a0											;41F900018BB0
	lea		GFX_Main_Sign_Positions.l,a2										;45F90000BD56
	lea		GFX_Sign.l,a1														;43F900025CD8
	lea		GFX_Main_Sign_Colours.l,a6											;4DF90000B264
	move.b	-$0012(a3),d1														;122BFFEE
	lsr.b	#$02,d1																;E409
	beq.s	Select_Main_Sign_MapColour											;670E
	cmpi.b	#$05,d1																;0C010005
	bcc.s	Select_Main_Sign_MapColour											;6408
	subq.b	#$01,d1																;5301
	bsr		Load_WallOverlay_ColourMask											;6100006C
	bra.s	Draw_Main_Sign_Base													;6002

Select_Main_Sign_MapColour:		; Memory Address ($B16C) and binary offset [$ADE8]
	; Falls back to a coordinate-derived colour for sign types without a fixed
	; colour entry.
	bsr.s	Calculate_WallOverlay_ColourIndex									;615E
Draw_Main_Sign_Base:		; Memory Address ($B16E) and binary offset [$ADEA]
	; Draws the recoloured sign base before selecting its directional sign-overlay
	; picture.
	move.l	d0,Buffer_Colour_Mask.l												;23C00000B4C0
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l									;33FCFFFF0000B4BE
	bsr		Draw_WallComponentFace												;61000292
	clr.w	Buffer_Colour_Mask_Toggle.l											;42790000B4BE
	move.w	(sp)+,d6															;3C1F
	move.b	-$0012(a3),d1														;122BFFEE
	lsr.b	#$02,d1																;E409
	beq.s	Select_Main_SignOverlay_Direction									;670A
	cmpi.b	#$05,d1																;0C010005
	bcc.s	adrCd00B1C4															;642E
	subq.b	#$01,d1																;5301
	bra.s	Draw_Main_SignOverlay												;600A

Select_Main_SignOverlay_Direction:		; Memory Address ($B19A) and binary offset [$AE16]
	; Derives the generated sign-overlay direction from the map coordinates.
	move.b	-$0019(a3),d1														;122BFFE7
	add.w	d1,d1																;D241
	sub.b	-$001A(a3),d1														;922BFFE6
Draw_Main_SignOverlay:		; Memory Address ($B1A4) and binary offset [$AE20]
	; Selects and draws one of the four directional pictures from SignOverlay.gfx.
	and.w	#$0003,d1															;02410003
	mulu	#$0610,d1															;C2FC0610
	lea		GFX_SignOverlay.l,a1												;43F900026CA8
	add.w	d1,a1																;D2C1
	lea		GFX_Main_Signoverlay_Positions.l,a2									;45F90000BDC6
	lea		GFX_Main_Signoverlay_Offsets.l,a0									;41F90000B284
	bsr		Draw_WallComponentFace												;6100024E
adrCd00B1C4:		; Memory Address ($B1C4) and binary offset [$AE40]
	rts																			;4E75

Select_MainSwitch_ColourMask:		; Memory Address ($B1C6) and binary offset [$AE42]
	; Selects the switch colour table before falling through to the
	; coordinate-derived colour-mask lookup.
	lea		GFX_Switches_Colours.l,a6											;4DF90000B244
Calculate_WallOverlay_ColourIndex:		; Memory Address ($B1CC) and binary offset [$AE48]
	; Calculates map X plus map Y for generated signs, wall scrolls and non-zero
	; switch colour selection.
	move.b	-$0019(a3),d1														;122BFFE7
	add.b	-$001A(a3),d1														;D22BFFE6
Load_WallOverlay_ColourMask:		; Memory Address ($B1D4) and binary offset [$AE50]
	; Masks the colour index to eight entries, multiplies it by four and loads the
	; selected four-byte colour mask.
	and.w	#WallOverlay_ColourIndexMask,d1										;Wraps coordinate-derived and fixed colour selections to the eight available masks.
	asl.w	#WallOverlay_ColourEntryShift,d1									;Converts the colour index into a byte offset for four-byte mask records.
	move.l	$00(a6,d1.w),d0														;20361000
	rts																			;4E75

Draw_Main_Shelf_Overlay:		; Memory Address ($B1E0) and binary offset [$AE5C]
	; Suppresses an occluded shelf where necessary and otherwise draws the
	; projected shelf component.
	tst.b	-$001F(a3)															;4A2BFFE1
	bne.s	Draw_Main_Shelf_Visible												;6608
	btst	#$03,-$0011(a3)														;082B0003FFEF
	bne.s	adrCd00B1C4															;66D6
Draw_Main_Shelf_Visible:		; Memory Address ($B1EE) and binary offset [$AE6A]
	; Loads the shelf graphics tables and draws the shelf when its wall-face
	; visibility conditions permit.
	lea		GFX_Main_Shelf_Offsets.l,a0											;41F900018B90
	lea		GFX_Main_Shelf_Positions.l,a2										;45F90000BCE6
	lea		GFX_Shelf.l,a1														;43F900025490
	bra		Draw_WallComponentFace												;6000020E

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
	moveq	#$00,d0																;7000
	move.b	GFX_Main_Wall_SpriteTable(pc,d6.w),d0								;103B6012
	bsr		Select_MainWallGraphicTables										;610001C8
	add.w	d3,a0																;D0C3
	swap	d3																	;4843
	bsr		Draw_MainWall_Transformed											;610003B2
	bra		Draw_Main_Object_Overlay											;6000FDD4

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
	cmp.b	#$01,-$0013(a3)														;0C2B0001FFED
	beq		Draw_Main_Stairs													;6700009E
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l									;33FCFFFF0000B4BE
	move.l	#$0004000C,Buffer_Colour_Mask.l										;23FC0004000C0000B4C0	;Long Addr replaced with Symbol
	moveq	#$00,d0																;7000
	move.b	-$0012(a3),d0														;102BFFEE
	btst	#$03,d0																;08000003
	bne.s	Select_Main_Door_Graphic											;660C
	lsr.b	#$04,d0																;E808
	move.b	Door_Lock_Colours(pc,d0.w),d0										;103B00CC
	move.b	d0,Buffer_Colour_Mask+$02.l											;13C00000B4C2
Select_Main_Door_Graphic:		; Memory Address ($B312) and binary offset [$AF8E]
	; Selects open-door, metal-door, or portcullis artwork from the door-state
	; bits.
	lea		GFX_Door_Offsets.l,a0												;41F900018C14
	lea		GFX_Door_Positions.l,a2												;45F90000BC4E
	lea		GFX_Door_Open.l,a1													;43F90002D660
	btst	#$00,-$0012(a3)														;082B0000FFEE
	beq.s	Draw_Main_Door_ByViewCell											;6714
	lea		GFX_Door_Metal.l,a1													;43F90002F1C8
	btst	#$01,-$0012(a3)														;082B0001FFEE
	beq.s	Draw_Main_Door_ByViewCell											;6706
	lea		GFX_Door_PortCullis.l,a1											;43F900030650
Draw_Main_Door_ByViewCell:		; Memory Address ($B340) and binary offset [$AFBC]
	; Chooses the side-face component path or centred two-half construction for the
	; current view cell.
	move.b	-$0016(a3),d6														;1C2BFFEA
	cmpi.b	#$0E,d6																;0C06000E
	bcc.s	Draw_Main_Door_CentredFace											;6406
	bsr		Draw_CentredDungeonComponent										;6100E268
	bra.s	adrCd00B374															;6024

Draw_Main_Door_CentredFace:		; Memory Address ($B350) and binary offset [$AFCC]
	; Adjusts the centred door slot and orientation before constructing the door
	; from two reflected halves.
	move.w	d6,d0																;3006
	subq.w	#$07,d0																;5F40
	cmpi.w	#$000B,d0															;0C40000B
	bne.s	Draw_Main_Door_Centred_TwoHalves									;6616
	move.w	-$000A(a3),d1														;322BFFF6
	asl.w	#$02,d1																;E541
	eor.b	d1,-$0012(a3)														;B32BFFEE
	btst	#$02,-$0012(a3)														;082B0002FFEE
	beq.s	Draw_Main_Door_Centred_TwoHalves									;6704
	addq.w	#$01,d6																;5246
	addq.w	#$01,d0																;5240
Draw_Main_Door_Centred_TwoHalves:		; Memory Address ($B370) and binary offset [$AFEC]
	; Draws a centred main door from its source half and reflected partner.
	bsr		Draw_WallComponent_TwoHalves										;610000E6
adrCd00B374:		; Memory Address ($B374) and binary offset [$AFF0]
	clr.w	Buffer_Colour_Mask_Toggle.l											;42790000B4BE
	tst.b	-$0011(a3)															;4A2BFFEF
	bmi		Draw_DungeonCellOccupants											;6B00E670
	rts																			;4E75

Draw_Main_Stairs:		; Memory Address ($B384) and binary offset [$B000]
	; Selects ascending or descending stairs graphics, offsets, and projected
	; positions.
	lea		GFX_Stairs_Up.l,a1													;43F90002AB38
	lea		GFX_Stairs_Up_Offsets.l,a0											;41F900018BD0
	lea		GFX_Stairs_Up_Positions.l,a2										;45F90000BB1E
	btst	#$00,-$0012(a3)														;082B0000FFEE
	beq.s	Draw_Main_Stairs_ByViewCell											;6712
	lea		GFX_Stairs_Down.l,a1												;43F90002C9E0
	lea		GFX_Stairs_Down_Offsets.l,a0										;41F900018BF2
	lea		GFX_Stairs_Down_Positions.l,a2										;45F90000BB92
Draw_Main_Stairs_ByViewCell:		; Memory Address ($B3B0) and binary offset [$B02C]
	; Chooses the side-face path, suppresses the farthest central slot, or
	; constructs centred stairs from two halves.
	cmp.b	#$0E,-$0016(a3)														;0C2B000EFFEA
	bcs.s	Draw_Main_Stairs_SideFace											;6514
	beq.s	adrCd00B3CE															;6714
	move.b	-$0016(a3),d6														;1C2BFFEA
	move.w	d6,d0																;3006
	add.w	#$000A,d6															;0646000A
	subq.w	#$02,d0																;5540
	bsr		Draw_WallComponent_TwoHalves										;61000090
	bra.s	adrCd00B3CE															;6002

Draw_Main_Stairs_SideFace:		; Memory Address ($B3CC) and binary offset [$B048]
	; Draws the complete stairs component for a side view cell.
	bsr.s	Draw_WallComponentFace												;6142
adrCd00B3CE:		; Memory Address ($B3CE) and binary offset [$B04A]
	tst.b	-$0011(a3)															;4A2BFFEF
	bmi		Draw_DungeonCellOccupants											;6B00E61C
	rts																			;4E75

Draw_WoodenWallOrDoorFace:		; Memory Address ($B3D8) and binary offset [$B054]
	; Selects a solid wooden wall, open doorway frame and optional closed-door
	; overlay.
	lea		GFX_WoodenWalls.l,a1												;43F90001F980
	lea		GFX_Wooden_Wall_Offsets.l,a0										;41F900018B70
	lea		GFX_Wooden_Wall_Positions.l,a2										;45F90000BAAE
	tst.b	-$0014(a3)															;4A2BFFEC
	beq.s	Draw_Selected_WoodenWallOrDoorComponent								;671E
	add.w	#$2498,a1															;D2FC2498
	bsr.s	Draw_WallComponentFace												;611A
	tst.b	-$0015(a3)															;4A2BFFEB
	beq.s	adrCd00B42C															;6730
	lea		GFX_Wooden_Doors_Offsets.l,a0										;41F900018B50
	lea		GFX_Wooden_Doors_Positions.l,a2										;45F90000BFAE
	lea		GFX_WoodDoors.l,a1													;43F9000242B0
Draw_Selected_WoodenWallOrDoorComponent:		; Memory Address ($B40E) and binary offset [$B08A]
	; Draws the selected solid wall, doorway frame, or closed wooden-door
	; component.
	nop																			;4E71
Draw_WallComponentFace:		; Memory Address ($B410) and binary offset [$B08C]
	; Selects a wall-component picture and chooses its normal, mirrored or two-half
	; drawing path.
	moveq	#$00,d0																;7000
	move.b	GFX_WallComponent_SpriteMirrorTable(pc,d6.w),d0						;103B6028
	bmi.s	Flip_Sprite															;6B16
	cmpi.b	#$0C,d0																;0C00000C
	bcc		Draw_WallComponent_TwoHalves										;6400003A
	bsr.s	Prepare_WallSpriteDraw												;6164
	swap	d3																	;4843
	move.l	a3,-(sp)															;2F0B
	bsr		Draw_WallSprite_Normal												;610001A2
	move.l	(sp)+,a3															;265F
adrCd00B42C:		; Memory Address ($B42C) and binary offset [$B0A8]
	rts																			;4E75

Flip_Sprite:		; Memory Address ($B42E) and binary offset [$B0AA]
	; Clears the component mirror flag, resolves its geometry, and draws it through
	; the bit-reversed path.
	and.w	#WallSprite_IndexMask,d0											;Removes the mirror flag while retaining the component picture index.
	bsr.s	Prepare_WallSpriteDraw												;6152
	add.w	d3,a0																;D0C3
	swap	d3																	;4843
	bra		Draw_WallSprite_BitReversed											;60000334

GFX_WallComponent_SpriteMirrorTable:		; Memory Address ($B43C) and binary offset [$B0B8]
	; Maps the 28 wall-face slots to component pictures; bit 7 selects the
	; horizontally mirrored drawing path.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Dungeon_WallComponents.lookup"

Draw_WallComponent_TwoHalves:		; Memory Address ($B458) and binary offset [$B0D4]
	; Draws one source half and its reflected partner to construct a complete
	; central component.
	bsr.s	Prepare_WallSpriteDraw												;612C
	swap	d3																	;4843
	movem.l	d1/d3/d5/a0/a1/a3,-(sp)												;48E754D0
	bsr		Draw_WallSprite_Normal												;61000168
	movem.l	(sp)+,d1/d3/d5/a0/a1/a3												;4CDF0B2A
	add.w	#$0010,a0															;D0FC0010
	add.w	d1,d1																;D241
	sub.w	d1,a0																;90C1
	bra		Draw_WallSprite_BitReversed											;600002FC

Select_MainWallGraphicTables:		; Memory Address ($B474) and binary offset [$B0F0]
	; Selects the Main_Walls graphics, picture offsets and packed position tables.
	lea		GFX_Main_Walls_Positions.l,a2										;45F90000BA3E
	lea		GFX_Main_Walls_Offsets.l,a0											;41F900018ADE
	lea		GFX_MainWalls.l,a1													;43F90001B050
Prepare_WallSpriteDraw:		; Memory Address ($B486) and binary offset [$B102]
	; Resolves a picture offset and packed position into source pointer,
	; destination pointer, width and height.
	add.w	d0,d0																;D040
	add.w	$00(a0,d0.w),a1														;D2F00000
	move.w	d6,d0																;3006
	asl.w	#$02,d0																;E540
	add.w	d0,a2																;D4C0
	moveq	#$00,d1																;7200
	move.b	(a2)+,d1															;121A
	swap	d1																	;4841
	move.b	(a2)+,d1															;121A
	move.w	d1,d0																;3001
	asl.w	#$02,d1																;E541
	add.w	d1,d0																;D041
	asl.w	#$03,d0																;E740
	swap	d1																	;4841
	lsr.w	#$02,d1																;E449
	add.w	d1,d0																;D041
	move.l	-$0008(a3),a0														;206BFFF8
	add.w	d0,a0																;D0C0
	moveq	#$00,d5																;7A00
	move.b	(a2)+,d5															;1A1A
	move.w	d5,d3																;3605
	swap	d5																	;4845
	move.b	(a2),d5																;1A12
	addq.w	#$01,d3																;5243
	add.w	d3,d3																;D643
	rts																			;4E75

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
	lea		GFX_WallComponent_DrawTransformFlags.l,a2							;45F90000B4C4
	add.w	d6,a2																;D4C6
	btst	#$01,(a2)															;08120001
	beq		Draw_WallSprite_Normal												;670000DC
	swap	d6																	;4846
	btst	#$00,(a2)															;08120000
	beq.s	adrCd00B4FA															;6702
	bsr.s	Draw_WallComponent_EdgeTransform									;6166
adrCd00B4FA:		; Memory Address ($B4FA) and binary offset [$B176]
	move.b	(a2),d6																;1C12
	and.w	#WallTransform_FlagMask,d6											;Retains the edge and perspective controls used to index the component trim table.
	swap	d3																	;4843
	moveq	#Screen_BitplaneRowBytes,d2											;Uses the forty-byte single-bitplane screen-row stride when advancing transformed component rows.
	sub.w	d3,d2																;9443
	swap	d3																	;4843
	move.w	d5,d4																;3805
	swap	d5																	;4845
	move.b	GFX_WallComponent_PerspectiveTrimLookup(pc,d6.w),d6					;1C3B604A
	sub.w	d6,d5																;9A46
	add.w	d6,d6																;DC46
	add.w	d6,d2																;D446
	movem.l	a0/a1,-(sp)															;48E700C0
adrLp00B51A:		; Memory Address ($B51A) and binary offset [$B196]
	move.w	d5,d3																;3605
adrLp00B51C:		; Memory Address ($B51C) and binary offset [$B198]
	move.w	(a1)+,(a0)+															;30D9
	move.w	(a1)+,$1F3E(a0)														;31591F3E
	move.w	(a1)+,$3E7E(a0)														;31593E7E
	move.w	(a1)+,$5DBE(a0)														;31595DBE
	dbra	d3,adrLp00B51C														;51CBFFF0
	move.w	d6,d3																;3606
	asl.w	#$02,d3																;E543
	add.w	d3,a1																;D2C3
	add.w	d2,a0																;D0C2
	dbra	d4,adrLp00B51A														;51CCFFE2
	movem.l	(sp)+,a0/a1															;4CDF0300
	swap	d5																	;4845
	swap	d3																	;4843
	sub.w	d3,d6																;9C43
	sub.w	d6,a0																;90C6
	asl.w	#$02,d6																;E546
	sub.w	d6,a1																;92C6
	swap	d3																	;4843
	btst	#$02,(a2)															;08120002
	beq.s	adrCd00B554															;6702
	bsr.s	Draw_WallComponent_EdgeTransform									;610C
adrCd00B554:		; Memory Address ($B554) and binary offset [$B1D0]
	swap	d6																	;4846
	rts																			;4E75

GFX_WallComponent_PerspectiveTrimLookup:		; Memory Address ($B558) and binary offset [$B1D4]
	; Maps the low three component-transform flag bits to zero, one or two source
	; word-columns trimmed during perspective drawing.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Dungeon_WallComponent_PerspectiveTrim.lookup"

Draw_WallComponent_EdgeTransform:		; Memory Address ($B560) and binary offset [$B1DC]
	; Draws the extra perspective edge pass for a wall component.
	movem.l	a0/a1,-(sp)															;48E700C0
	swap	d3																	;4843
	move.w	d3,d6																;3C03
	subq.w	#$02,d6																;5546
	asl.w	#$02,d6																;E546
	swap	d3																	;4843
	move.w	d5,d3																;3605
adrLp00B570:		; Memory Address ($B570) and binary offset [$B1EC]
	move.l	(a1)+,d0															;2019
	move.l	(a1)+,d1															;2219
	move.l	d1,d2																;2401
	and.l	d0,d2																;C480
	swap	d2																	;4842
	and.l	d0,d2																;C480
	and.l	d1,d2																;C481
	not.l	d2																	;4682
	and.l	d2,d0																;C082
	and.l	d2,d1																;C282
	not.l	d2																	;4682
	move.w	$5DC0(a0),d4														;38285DC0
	and.w	d2,d4																;C842
	or.w	d1,d4																;8841
	move.w	d4,$5DC0(a0)														;31445DC0
	swap	d1																	;4841
	move.w	$3E80(a0),d4														;38283E80
	and.w	d2,d4																;C842
	or.w	d1,d4																;8841
	move.w	d4,$3E80(a0)														;31443E80
	move.w	$1F40(a0),d4														;38281F40
	and.w	d2,d4																;C842
	or.w	d0,d4																;8840
	move.w	d4,$1F40(a0)														;31441F40
	swap	d0																	;4840
	move.w	(a0),d4																;3810
	and.w	d2,d4																;C842
	or.w	d0,d4																;8840
	move.w	d4,(a0)+															;30C4
	add.w	#$0026,a0															;D0FC0026
	add.w	d6,a1																;D2C6
	dbra	d3,adrLp00B570														;51CBFFB2
	movem.l	(sp)+,a0/a1															;4CDF0300
	addq.w	#$02,a0																;5448
	addq.w	#$08,a1																;5049
	rts																			;4E75

Draw_WallSprite_Normal:		; Memory Address ($B5CA) and binary offset [$B246]
	; Initialises the normal wall-sprite source-row stride before entering the
	; shared planar compositor.
	sub.w	a3,a3																;96CB
Draw_WallSprite_Rows_Loop:		; Memory Address ($B5CC) and binary offset [$B248]
	; Iterates the source rows and words of an ordinary planar wall or wall-feature
	; sprite.
	swap	d5																	;4845
	move.w	d5,d3																;3605
adrLp00B5D0:		; Memory Address ($B5D0) and binary offset [$B24C]
	move.l	(a1)+,d0															;2019
	move.l	(a1)+,d1															;2219
	tst.w	Buffer_Colour_Mask_Toggle.l											;4A790000B4BE
	beq.s	Composite_WallSprite_Row											;670A
	lea		Buffer_Colour_Mask.l,a6												;4DF90000B4C0
	bsr		Remap_PlanarSpriteColours											;6100F9EC
Composite_WallSprite_Row:		; Memory Address ($B5E6) and binary offset [$B262]
	; Builds the transparency mask and merges one ordinary planar sprite word into
	; all four destination bitplanes.
	move.l	d1,d2																;2401
	and.l	d0,d2																;C480
	addq.l	#$01,d2																;5282
	beq.s	adrCd00B630															;6742
	subq.l	#$01,d2																;5382
	swap	d2																	;4842
	and.l	d0,d2																;C480
	and.l	d1,d2																;C481
	not.l	d2																	;4682
	and.l	d2,d0																;C082
	and.l	d2,d1																;C282
	not.l	d2																	;4682
	move.w	$5DC0(a0),d4														;38285DC0
	and.w	d2,d4																;C842
	or.w	d1,d4																;8841
	move.w	d4,$5DC0(a0)														;31445DC0
	swap	d1																	;4841
	move.w	$3E80(a0),d4														;38283E80
	and.w	d2,d4																;C842
	or.w	d1,d4																;8841
	move.w	d4,$3E80(a0)														;31443E80
	move.w	$1F40(a0),d4														;38281F40
	and.w	d2,d4																;C842
	or.w	d0,d4																;8840
	move.w	d4,$1F40(a0)														;31441F40
	swap	d0																	;4840
	move.w	(a0),d4																;3810
	and.w	d2,d4																;C842
	or.w	d0,d4																;8840
	move.w	d4,(a0)+															;30C4
	bra.s	adrCd00B632															;6002

adrCd00B630:		; Memory Address ($B630) and binary offset [$B2AC]
	addq.w	#$02,a0																;5448
adrCd00B632:		; Memory Address ($B632) and binary offset [$B2AE]
	dbra	d3,adrLp00B5D0														;51CBFF9C
	swap	d3																	;4843
	sub.w	d3,a0																;90C3
	swap	d3																	;4843
	add.w	#$0028,a0															;D0FC0028
	add.w	a3,a1																;D2CB
	swap	d5																	;4845
	dbra	d5,Draw_WallSprite_Rows_Loop										;51CDFF86
	rts																			;4E75

GFX_Main_Wall_DrawTransformFlags:		; Memory Address ($B64A) and binary offset [$B2C6]
	; Per-face transformation flags for stone-wall graphics. This differs from the
	; component table at wall-face slots 6 and 18.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Dungeon_MainWall_DrawTransform.flags"

Draw_MainWall_Transformed:		; Memory Address ($B666) and binary offset [$B2E2]
	; Applies main-wall transformation flags, horizontal bit reversal and
	; perspective trimming.
	lea		GFX_Main_Wall_DrawTransformFlags.l,a2								;45F90000B64A
	add.w	d6,a2																;D4C6
	btst	#$01,(a2)															;08120001
	beq		Draw_WallSprite_BitReversed											;670000FA
	swap	d6																	;4846
	btst	#$00,(a2)															;08120000
	beq.s	adrCd00B680															;6702
	bsr.s	Draw_MainWall_EdgeTransform											;617A
adrCd00B680:		; Memory Address ($B680) and binary offset [$B2FC]
	movem.l	d7/a0/a1,-(sp)														;48E701C0
	move.b	(a2),d6																;1C12
	and.w	#WallTransform_FlagMask,d6											;Retains the edge and perspective controls used to index the main-wall trim table.
	swap	d3																	;4843
	move.w	#Screen_BitplaneRowBytes,d7											;Uses the forty-byte single-bitplane screen-row stride when advancing transformed wall rows.
	add.w	d3,d7																;DE43
	swap	d3																	;4843
	move.w	d5,d4																;3805
	swap	d5																	;4845
	move.b	GFX_Main_Wall_PerspectiveTrimLookup(pc,d6.w),d6						;1C3B6058
	sub.w	d6,d5																;9A46
	add.w	d6,d6																;DC46
	sub.w	d6,d7																;9E46
adrLp00B6A2:		; Memory Address ($B6A2) and binary offset [$B31E]
	move.w	d5,d3																;3605
adrLp00B6A4:		; Memory Address ($B6A4) and binary offset [$B320]
	move.l	(a1)+,d1															;2219
	move.l	(a1)+,d0															;2019
	bsr		Reverse_PlanarLongwordBits											;6100F6BC
	exg		d0,d1																;C141
	bsr		Reverse_PlanarLongwordBits											;6100F6B6
	move.w	d1,$5DBE(a0)														;31415DBE
	swap	d1																	;4841
	move.w	d1,$3E7E(a0)														;31413E7E
	move.w	d0,$1F3E(a0)														;31401F3E
	swap	d0																	;4840
	move.w	d0,-(a0)															;3100
	dbra	d3,adrLp00B6A4														;51CBFFDE
	move.w	d6,d3																;3606
	asl.w	#$02,d3																;E543
	add.w	d3,a1																;D2C3
	add.w	d7,a0																;D0C7
	dbra	d4,adrLp00B6A2														;51CCFFD0
	movem.l	(sp)+,d7/a0/a1														;4CDF0380
	swap	d5																	;4845
	swap	d3																	;4843
	sub.w	d3,d6																;9C43
	add.w	d6,a0																;D0C6
	asl.w	#$02,d6																;E546
	sub.w	d6,a1																;92C6
	swap	d3																	;4843
	btst	#$02,(a2)															;08120002
	beq.s	adrCd00B6EE															;6702
	bsr.s	Draw_MainWall_EdgeTransform											;610C
adrCd00B6EE:		; Memory Address ($B6EE) and binary offset [$B36A]
	swap	d6																	;4846
	rts																			;4E75

GFX_Main_Wall_PerspectiveTrimLookup:		; Memory Address ($B6F2) and binary offset [$B36E]
	; Maps the low three main-wall transform flag bits to zero, one or two source
	; word-columns trimmed during perspective drawing.
	INCBIN "/data/BLOODWYCH439-clean/gfx-data/Dungeon_MainWall_PerspectiveTrim.lookup"

Draw_MainWall_EdgeTransform:		; Memory Address ($B6FA) and binary offset [$B376]
	; Draws the horizontally reversed perspective edge pass for a stone wall.
	movem.l	a0/a1,-(sp)															;48E700C0
	swap	d3																	;4843
	move.w	d3,d6																;3C03
	subq.w	#$02,d6																;5546
	asl.w	#$02,d6																;E546
	swap	d3																	;4843
	move.w	d5,d3																;3605
adrLp00B70A:		; Memory Address ($B70A) and binary offset [$B386]
	move.l	(a1)+,d1															;2219
	move.l	(a1)+,d0															;2019
	bsr		Reverse_PlanarLongwordBits											;6100F656
	exg		d0,d1																;C141
	bsr		Reverse_PlanarLongwordBits											;6100F650
	move.l	d1,d2																;2401
	and.l	d0,d2																;C480
	swap	d2																	;4842
	and.l	d0,d2																;C480
	and.l	d1,d2																;C481
	not.l	d2																	;4682
	and.l	d2,d0																;C082
	and.l	d2,d1																;C282
	not.l	d2																	;4682
	move.w	$5DBE(a0),d4														;38285DBE
	and.w	d2,d4																;C842
	or.w	d1,d4																;8841
	move.w	d4,$5DBE(a0)														;31445DBE
	swap	d1																	;4841
	move.w	$3E7E(a0),d4														;38283E7E
	and.w	d2,d4																;C842
	or.w	d1,d4																;8841
	move.w	d4,$3E7E(a0)														;31443E7E
	move.w	$1F3E(a0),d4														;38281F3E
	and.w	d2,d4																;C842
	or.w	d0,d4																;8840
	move.w	d4,$1F3E(a0)														;31441F3E
	swap	d0																	;4840
	move.w	-(a0),d4															;3820
	and.w	d2,d4																;C842
	or.w	d0,d4																;8840
	move.w	d4,(a0)																;3084
	add.w	#$002A,a0															;D0FC002A
	add.w	d6,a1																;D2C6
	dbra	d3,adrLp00B70A														;51CBFFA8
	movem.l	(sp)+,a0/a1															;4CDF0300
	subq.w	#$02,a0																;5548
	addq.w	#$08,a1																;5049
	rts																			;4E75

Draw_WallSprite_BitReversed:		; Memory Address ($B76E) and binary offset [$B3EA]
	; Writes normal wall rows after horizontally reversing their planar source
	; bits.
	swap	d5																	;4845
	move.w	d5,d3																;3605
Draw_WallSprite_BitReversed_Rows_Loop:		; Memory Address ($B772) and binary offset [$B3EE]
	; Iterates a horizontally bit-reversed wall sprite through its planar source
	; rows and words.
	move.l	(a1)+,d1															;2219
	move.l	(a1)+,d0															;2019
	bsr		Reverse_PlanarLongwordBits											;6100F5EE
	exg		d0,d1																;C141
	bsr		Reverse_PlanarLongwordBits											;6100F5E8
	tst.w	Buffer_Colour_Mask_Toggle.l											;4A790000B4BE
	beq.s	Composite_BitReversedWallSprite_Row									;670A
	lea		Buffer_Colour_Mask.l,a6												;4DF90000B4C0
	bsr		Remap_PlanarSpriteColours											;6100F840
Composite_BitReversedWallSprite_Row:		; Memory Address ($B792) and binary offset [$B40E]
	; Builds the transparency mask and merges one bit-reversed sprite word into all
	; four destination bitplanes.
	move.l	d1,d2																;2401
	and.l	d0,d2																;C480
	addq.l	#$01,d2																;5282
	beq.s	adrCd00B7DC															;6742
	subq.l	#$01,d2																;5382
	swap	d2																	;4842
	and.l	d0,d2																;C480
	and.l	d1,d2																;C481
	not.l	d2																	;4682
	and.l	d2,d0																;C082
	and.l	d2,d1																;C282
	not.l	d2																	;4682
	move.w	$5DBE(a0),d4														;38285DBE
	and.w	d2,d4																;C842
	or.w	d1,d4																;8841
	move.w	d4,$5DBE(a0)														;31445DBE
	swap	d1																	;4841
	move.w	$3E7E(a0),d4														;38283E7E
	and.w	d2,d4																;C842
	or.w	d1,d4																;8841
	move.w	d4,$3E7E(a0)														;31443E7E
	move.w	$1F3E(a0),d4														;38281F3E
	and.w	d2,d4																;C842
	or.w	d0,d4																;8840
	move.w	d4,$1F3E(a0)														;31441F3E
	swap	d0																	;4840
	move.w	-(a0),d4															;3820
	and.w	d2,d4																;C842
	or.w	d0,d4																;8840
	move.w	d4,(a0)																;3084
	bra.s	adrCd00B7DE															;6002

adrCd00B7DC:		; Memory Address ($B7DC) and binary offset [$B458]
	subq.w	#$02,a0																;5548
adrCd00B7DE:		; Memory Address ($B7DE) and binary offset [$B45A]
	dbra	d3,Draw_WallSprite_BitReversed_Rows_Loop							;51CBFF92
	swap	d3																	;4843
	add.w	d3,a0																;D0C3
	swap	d3																	;4843
	add.w	#$0028,a0															;D0FC0028
	swap	d5																	;4845
	dbra	d5,Draw_WallSprite_BitReversed										;51CDFF7E
	rts																			;4E75

Draw_FloorAndCeiling:		; Memory Address ($B7F4) and binary offset [$B470]
	; Draws the floor and ceiling bands used by the dungeon viewport. Selects the
	; ordinary or horizontally bit-reversed floor/ceiling renderer according to the
	; dungeon pattern parity.
	lea		GFX_FloorCeiling.l,a1												;43F900032120
	move.l	-$0008(a3),a0														;206BFFF8
	tst.w	-$000C(a3)															;4A6BFFF4
	beq.s	Draw_FloorAndCeiling_BitReversed									;6760
	moveq	#$16,d0																;7016
	bsr.s	Draw_FloorAndCeiling_CopyRows_Loop									;6104
	bsr.s	Clear_FloorCeiling_ViewGap											;6120
	moveq	#$21,d0																;7021
Draw_FloorAndCeiling_CopyRows_Loop:		; Memory Address ($B80C) and binary offset [$B488]
	; Copies source rows into the floor and ceiling areas of the dungeon viewport.
	; Copies the parity-1 floor and ceiling rows directly into the dungeon
	; viewport.
	moveq	#$07,d1																;7207
adrLp00B80E:		; Memory Address ($B80E) and binary offset [$B48A]
	move.w	(a1)+,(a0)+															;30D9
	move.w	(a1)+,$1F3E(a0)														;31591F3E
	move.w	(a1)+,$3E7E(a0)														;31593E7E
	move.w	(a1)+,$5DBE(a0)														;31595DBE
	dbra	d1,adrLp00B80E														;51C9FFF0
	lea		$0018(a0),a0														;41E80018
	dbra	d0,Draw_FloorAndCeiling_CopyRows_Loop								;51C8FFE6
	rts																			;4E75

Clear_FloorCeiling_ViewGap:		; Memory Address ($B82A) and binary offset [$B4A6]
	; Clears the nineteen-rowhorizontal  view area between the ceiling and floor
	; bands.
	moveq	#$12,d0																;7012
	moveq	#$00,d1																;7200
adrLp00B82E:		; Memory Address ($B82E) and binary offset [$B4AA]
	lea		$1F40(a0),a2														;45E81F40
	move.l	d1,(a2)+															;24C1
	move.l	d1,(a2)+															;24C1
	move.l	d1,(a2)+															;24C1
	move.l	d1,(a2)+															;24C1
	lea		$3E80(a0),a2														;45E83E80
	move.l	d1,(a2)+															;24C1
	move.l	d1,(a2)+															;24C1
	move.l	d1,(a2)+															;24C1
	move.l	d1,(a2)+															;24C1
	lea		$5DC0(a0),a2														;45E85DC0
	move.l	d1,(a2)+															;24C1
	move.l	d1,(a2)+															;24C1
	move.l	d1,(a2)+															;24C1
	move.l	d1,(a2)+															;24C1
	move.l	d1,(a0)+															;20C1
	move.l	d1,(a0)+															;20C1
	move.l	d1,(a0)+															;20C1
	move.l	d1,(a0)+															;20C1
	lea		$0018(a0),a0														;41E80018
	dbra	d0,adrLp00B82E														;51C8FFCE
	rts																			;4E75

Draw_FloorAndCeiling_BitReversed:		; Memory Address ($B864) and binary offset [$B4E0]
	; Draws the horizontally bit-reversed floor and ceiling bands for parity 0.
	lea		BitReverse_LookupBuffer.l,a6										;4DF90001684C
	lea		$0010(a0),a0														;41E80010
	moveq	#$16,d7																;7E16
	bsr.s	Draw_FloorAndCeiling_BitReversed_Loop								;610C
	sub.w	#$0010,a0															;90FC0010
	bsr.s	Clear_FloorCeiling_ViewGap											;61B2
	lea		$0010(a0),a0														;41E80010
	moveq	#$21,d7																;7E21
Draw_FloorAndCeiling_BitReversed_Loop:		; Memory Address ($B87E) and binary offset [$B4FA]
	; Loop used to write the bit-reversed floor and ceiling rows. Bit-reverses and
	; writes each floor/ceiling source row from the opposite side of the viewport.
	moveq	#$07,d3																;7607
adrLp00B880:		; Memory Address ($B880) and binary offset [$B4FC]
	move.l	(a1)+,d0															;2019
	bsr		Reverse_PlanarLongwordBits_WithLookup								;6100F4E8
	move.l	d0,d1																;2200
	move.l	(a1)+,d0															;2019
	bsr		Reverse_PlanarLongwordBits_WithLookup								;6100F4E0
	move.w	d0,$5DBE(a0)														;31405DBE
	swap	d0																	;4840
	move.w	d0,$3E7E(a0)														;31403E7E
	move.w	d1,$1F3E(a0)														;31411F3E
	swap	d1																	;4841
	move.w	d1,-(a0)															;3101
	dbra	d3,adrLp00B880														;51CBFFDE
	lea		$0038(a0),a0														;41E80038
	dbra	d7,Draw_FloorAndCeiling_BitReversed_Loop							;51CFFFD4
	rts																			;4E75

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

adrCd00C01E:		; Memory Address ($C01E) and binary offset [$BC9A]
	lea		Notice_SelectChampions.l,a6											;4DF90000E480
	tst.w	MultiPlayer.l														;4A790000EE30
	beq.s	adrCd00C032															;6706
	move.b	#$2E,$001B(a6)														;1D7C002E001B
adrCd00C032:		; Memory Address ($C032) and binary offset [$BCAE]
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$0050,a0															;D0FC0050
	move.l	#$000F0000,adrW_00D92A.l											;23FC000F00000000D92A
	bsr		Print_fflim_text													;6100107E
	lea		Player1_Data.l,a5													;4BF90000EE7C
	tst.w	MultiPlayer.l														;4A790000EE30
	bmi.s	adrCd00C060															;6B08
	bsr.s	adrCd00C060															;6106
	lea		Player2_Data.l,a5													;4BF90000EEDE
adrCd00C060:		; Memory Address ($C060) and binary offset [$BCDC]
	clr.w	$0014(a5)															;426D0014
	move.l	#$002F00A8,d4														;283C002F00A8
	moveq	#$09,d5																;7A09
	bsr.s	Draw_BevelledPanelFrame												;614C
	move.l	#$009700A8,d4														;283C009700A8
	move.l	#$00070058,d5														;2A3C00070058
	add.w	$0008(a5),d5														;DA6D0008
	move.w	$0010(a5),d3														;362D0010
	bsr		BW_draw_bar															;610019E4
	moveq	#$2A,d5																;7A2A
	bsr		Draw_ScrollFrame													;61000BB0
	move.l	#$00970001,d3														;263C00970001
	move.w	#$00A8,d4															;383C00A8
	moveq	#$54,d5																;7A54
	add.w	$0008(a5),d5														;DA6D0008
adrCd00C09C:		; Memory Address ($C09C) and binary offset [$BD18]
	bsr		BW_blit_horiz_line													;61001AE6
	addq.w	#$01,d5																;5245
	addq.w	#$01,d3																;5243
	cmpi.w	#$0005,d3															;0C430005
	bcs.s	adrCd00C09C															;65F2
	addq.w	#$08,d5																;5045
	subq.w	#$01,d3																;5343
adrCd00C0AE:		; Memory Address ($C0AE) and binary offset [$BD2A]
	bsr		BW_blit_horiz_line													;61001AD4
	addq.w	#$01,d5																;5245
	subq.w	#$01,d3																;5343
	bne.s	adrCd00C0AE															;66F6
	rts																			;4E75

Draw_BevelledPanelFrame:		; Memory Address ($C0BA) and binary offset [$BD36]
	; Fills a panel rectangle and draws three successively inset grey frame
	; outlines.
	add.w	$0008(a5),d5														;DA6D0008
	swap	d5																	;4845
	move.w	#$002B,d5															;Sets vertical terminal count $2B; the panel fill therefore spans $2C rows.
	swap	d5																	;4845
	moveq	#$01,d3																;Selects palette index $01 for the initial filled panel rectangle.
	movem.l	d3-d5,-(sp)															;48E71C00
	bsr		BW_draw_bar															;6100199A
	movem.l	(sp)+,d3-d5															;4CDF0038
adrCd00C0D4:		; Memory Address ($C0D4) and binary offset [$BD50]
	addq.w	#$01,d4																;5244
	addq.w	#$01,d5																;5245
	sub.l	#$00020000,d5														;048500020000	;Long Addr replaced with Symbol
	sub.l	#$00020000,d4														;048400020000	;Long Addr replaced with Symbol
	addq.w	#$01,d3																;Advances through the three grey outline colours as the frame moves inward.
	movem.l	d3-d5,-(sp)															;48E71C00
	bsr		BW_draw_frame														;610019E8
	movem.l	(sp)+,d3-d5															;4CDF0038
	cmpi.w	#$0004,d3															;0C430004
	bne.s	adrCd00C0D4															;66DC
	rts																			;4E75

ChampionSelection_Main:		; Memory Address ($C0FA) and binary offset [$BD76]
	moveq	#-$01,d0															;70FF
	move.w	d0,adrW_00C514.l													;33C00000C514
	move.b	d0,adrB_00EE83.l													;13C00000EE83
	move.b	d0,Player2_ChampionCount.l											;13C00000EEE5
	move.l	#$00B00040,adrL_00EE7E.l											;23FC00B000400000EE7E
	move.l	#$00B00078,adrL_00EEE0.l											;23FC00B000780000EEE0
	clr.b	adrB_00EECE.l														;42390000EECE
	move.w	#$BA02,d0															;303CBA02
	move.w	d0,adrW_00EEB6.l													;33C00000EEB6
	move.w	d0,adrW_00EF18.l													;33C00000EF18
	tst.w	MultiPlayer.l														;4A790000EE30
	beq.s	adrCd00C168															;6728
	clr.w	adrW_00C514.l														;42790000C514
	move.w	#$FFFF,adrW_00EEF2.l												;33FCFFFF0000EEF2
	move.l	#$00D80000,adrL_00EEE0.l											;23FC00D800000000EEE0
	move.w	#$0026,adrW_00EE84.l												;33FC00260000EE84
	move.w	#$05F0,Player1_InterfaceScreenBufferOffset.l						;33FC05F00000EE86
adrCd00C168:		; Memory Address ($C168) and binary offset [$BDE4]
	bsr		ChampionSelection													;61000C22
	bsr		adrCd00C01E															;6100FEB0
	bsr		adrCd008CCA															;6100CB58
	bsr		ChampionSelection													;61000C16
	bsr		adrCd00C01E															;6100FEA4
	move.w	#$0005,adrW_00EEC6.l												;33FC00050000EEC6
	move.b	#$01,SyncFlagHighByte_AI_TBC.l										;13FC000100008C1F
	jsr		Initialize_SpellPracticeThresholds.w								;4EB808F2	;Short Absolute converted to symbol!
adrCd00C190:		; Memory Address ($C190) and binary offset [$BE0C]
	move.w	adrW_00EEF2.l,d1													;32390000EEF2
	lea		Player1_Data.l,a5													;4BF90000EE7C
	and.w	$0014(a5),d1														;C26D0014
	bmi.s	ExitOrLoop															;6B52
	clr.b	adrB_00EE2C.l														;42390000EE2C
	bsr		adrCd00C1F6															;6100004C
	bsr		Process_ChampionSelectionAction										;61000084
	lea		Player2_Data.l,a5													;4BF90000EEDE
	bsr		adrCd00C1F6															;6100003E
	bsr		Process_ChampionSelectionAction										;61000076
	move.b	#$FF,FrameSyncFlagWord_AI_TBC.l										;13FC00FF00008C1E
adrCd00C1C6:		; Memory Address ($C1C6) and binary offset [$BE42]
	tst.b	FrameSyncFlagWord_AI_TBC.l											;4A3900008C1E
	bne.s	adrCd00C1C6															;66F8
	move.b	#$01,adrB_00EE2C.l													;13FC00010000EE2C
	lea		Player1_Data.l,a5													;4BF90000EE7C
	bsr		Process_ChampionSelectionAction										;61000054
	clr.w	$000C(a5)															;426D000C
	lea		Player2_Data.l,a5													;4BF90000EEDE
	bsr		Process_ChampionSelectionAction										;61000046
	clr.w	$000C(a5)															;426D000C
	bra.s	adrCd00C190															;609C

ExitOrLoop:		; Memory Address ($C1F4) and binary offset [$BE70]
	rts																			;4E75

adrCd00C1F6:		; Memory Address ($C1F6) and binary offset [$BE72]
	move.w	$0022(a5),$0024(a5)													;3B6D00220024
	bclr	#$07,$0001(a5)														;08AD00070001
	beq.s	ExitOrLoop															;67F0
	move.w	$0014(a5),d0														;302D0014
	bmi.s	ExitOrLoop															;6BEA
	cmpi.b	#$03,d0																;0C000003
	beq.s	ExitOrLoop															;67E4
	bsr		adrCd00C74C															;6100053A
	bpl.s	ExitOrLoop															;6ADE
	tst.b	$0007(a5)															;4A2D0007
	bmi.s	ExitOrLoop															;6BD8
	bsr		adrCd00C5F4															;610003D6
	bpl.s	ExitOrLoop															;6AD2
	bsr		adrCd00C622															;610003FE
	bpl.s	ExitOrLoop															;6ACC
	bsr		adrCd00C70C															;610004E2
	bpl.s	ExitOrLoop															;6AC6
	bra		adrCd00C650															;60000420

Process_ChampionSelectionAction:		; Memory Address ($C5B6) and binary offset [$C232]
	; Processes the champion-selection screen's separate action state.
	move.w	$0014(a5),d0														;302D0014
	bmi.s	ExitOrLoop															;6BBC
	cmpi.b	#$03,d0																;0C000003
	bne.s	Dispatch_ChampionSelectionAction									;6614
	lsr.w	#$08,d0																;E048
	cmpi.w	#$0007,d0															;0C400007
	bne.s	adrCd00C24E															;6608
	move.w	#$0002,$0014(a5)													;3B7C00020014
	rts																			;4E75

adrCd00C24E:		; Memory Address ($C24E) and binary offset [$BECA]
	move.w	d0,$000C(a5)														;3B40000C
Dispatch_ChampionSelectionAction:		; Memory Address ($C5D6) and binary offset [$C252]
	; Dispatches champion-selection actions through the local preview/action table.
	move.w	$000C(a5),d0														;302D000C
	beq.s	ExitOrLoop															;679C
	asl.w	#$02,d0																;E540
	lea		ChampionSelection_ActionHandlers.l,a0								;41F90000C262
	move.l	$00(a0,d0.w),a0														;20700000
ChampionSelection_ActionHandlers:				equ	*-2			; Memory Address ($C5E6) and binary offset [$C262]
	; Champion-selection action handler table; its numeric meanings differ from
	; dungeon InterfaceButtons.
	jmp		(a0)																;4ED0

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
	bsr		adrCd00C2AC															;61000024
	bpl.s	adrCd00C298															;6A0C
	move.w	$0006(a5),d7														;3E2D0006
	bsr		adrCd00CFF0															;61000D5E
	bra		adrCd00C85E															;600005C8

adrCd00C298:		; Memory Address ($C298) and binary offset [$BF14]
	moveq	#$07,d6																;7C07
	bsr		adrCd00D01A															;61000D7E
	bsr		adrLp00CFDA															;61000D3A
	moveq	#$0A,d6																;7C0A
	bsr		TerminateText														;61000D62
	bra		adrCd00C85E															;600005B4

adrCd00C2AC:		; Memory Address ($C2AC) and binary offset [$BF28]
	bsr		Load_CurrentChampionStatRecord										;6100A3AE
	move.w	$002A(a5),d0														;302D002A
	move.w	d0,d2																;3400
	asl.w	#$02,d2																;E542
	lsr.w	#$01,d0																;E248
	move.w	d0,d3																;3600
	move.w	$000E(a5),d0														;302D000E
	btst	d0,$0C(a4,d3.w)														;0134300C
	beq.s	adrCd00C2E0															;671A
	eor.w	#$0007,d0															;0A400007
	add.w	d2,d0																;D042
	move.b	d0,$0013(a4)														;19400013
	clr.b	$0014(a4)															;422C0014
adrCd00C2D4:		; Memory Address ($C2D4) and binary offset [$BF50]
	asl.w	#$03,d0																;E740
	lea		SpellNames.l,a6														;4DF900019E8E
	add.w	d0,a6																;DCC0
	rts																			;4E75

adrCd00C2E0:		; Memory Address ($C2E0) and binary offset [$BF5C]
	move.b	#$FF,$0013(a4)														;197C00FF0013
	moveq	#-$01,d0															;70FF
adrCd00C2E8:		; Memory Address ($C2E8) and binary offset [$BF64]
	rts																			;4E75

Click_TurnSpellBookPage:		; Memory Address ($C2EA) and binary offset [$BF66]
	tst.w	$0024(a5)															;4A6D0024
	bne.s	adrCd00C2E8															;66F8
	tst.b	$000F(a5)															;4A2D000F
	bpl.s	adrCd00C322															;6A2C
	tst.b	$000E(a5)															;4A2D000E
	bmi.s	adrCd00C30C															;6B10
	addq.w	#$02,$002A(a5)														;546D002A
	and.w	#$0007,$002A(a5)													;026D0007002A
	move.w	#$FFFF,$000E(a5)													;3B7CFFFF000E
adrCd00C30C:		; Memory Address ($C30C) and binary offset [$BF88]
	tst.b	adrB_00EE2C.l														;4A390000EE2C
	beq.s	adrCd00C31A															;6706
	move.w	#$0002,$0014(a5)													;3B7C00020014
adrCd00C31A:		; Memory Address ($C31A) and binary offset [$BF96]
	bsr		Prepare_AndDrawSpellBookSurface										;610004AC
	bra		adrCd00C85E															;6000053E

adrCd00C322:		; Memory Address ($C322) and binary offset [$BF9E]
	bsr		Prepare_AndDrawSpellBookSurface										;610004A4
	move.w	$002A(a5),d0														;302D002A
	bsr		Draw_SpellBookRunePage												;6100053E
	move.w	$000E(a5),d1														;322D000E
	bpl.s	adrCd00C338															;6A04
	eor.w	#$0003,d1															;0A410003
adrCd00C338:		; Memory Address ($C338) and binary offset [$BFB4]
	and.w	#$0003,d1															;02410003
	move.w	$002A(a5),d0														;302D002A
	cmpi.w	#$0003,d1															;0C410003
	bne.s	adrCd00C39C															;6656
	addq.w	#$01,d0																;5240
	bsr		Draw_SpellBookRunePage												;61000520
	move.w	$002A(a5),d0														;302D002A
	addq.w	#$03,d0																;5640
	and.w	#$0007,d0															;02400007
	move.w	d0,d7																;3E00
	asl.w	#$04,d0																;E940
	lea		SpellBookRunes+$03.l,a6												;4DF900018787
	add.w	d0,a6																;DCC0
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$0436,a0															;D0FC0436
	add.w	$000A(a5),a0														;D0ED000A
	move.l	a4,a3																;264C
	move.w	d7,d0																;3007
	lsr.w	#$01,d0																;E248
	add.w	d0,a3																;D6C0
	asl.w	#$02,d7																;E547
	swap	d7																	;4847
	move.w	#$0003,d7															;3E3C0003
adrLp00C380:		; Memory Address ($C380) and binary offset [$BFFC]
	bsr		adrCd00C906															;61000584
	move.w	d6,adrW_00D92A.l													;33C60000D92A
	move.b	(a6),d0																;1016
	bsr		adrCd00D8C0															;61001532
	addq.w	#$04,a6																;584E
	add.w	#$013F,a0															;D0FC013F
	dbra	d7,adrLp00C380														;51CFFFE8
	bra.s	adrCd00C3A6															;600A

adrCd00C39C:		; Memory Address ($C39C) and binary offset [$C018]
	addq.w	#$03,d0																;5640
	and.w	#$0007,d0															;02400007
	bsr		Draw_SpellBookRunePage												;610004C6
adrCd00C3A6:		; Memory Address ($C3A6) and binary offset [$C022]
	move.w	$002A(a5),d7														;3E2D002A
	addq.w	#$02,d7																;5447
	and.w	#$0007,d7															;02470007
	move.w	d7,d0																;3007
	lsr.w	#$01,d0																;E248
	move.l	a4,a3																;264C
	add.w	d0,a3																;D6C0
	asl.w	#$02,d7																;E547
	swap	d7																	;4847
	move.w	#$0007,d7															;3E3C0007
	lea		Buffer_Colour_Mask.l,a6												;4DF90000B4C0
	moveq	#$03,d5																;7A03
adrLp00C3C8:		; Memory Address ($C3C8) and binary offset [$C044]
	bsr		adrCd00C906															;6100053C
	move.b	d6,(a6)+															;1CC6
	subq.w	#$01,d7																;5347
	dbra	d5,adrLp00C3C8														;51CDFFF6
	move.w	$000E(a5),d0														;302D000E
	bpl.s	Draw_SelectedSpellMarker											;6A04
	eor.w	#$0003,d0															;0A400003
Draw_SelectedSpellMarker:		; Memory Address ($C3DE) and binary offset [$C05A]
	; Draws the selected spell-column marker from GFX_Pockets+$4130.
	and.w	#$0003,d0															;02400003
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$0186,a0															;D0FC0186
	add.w	$000A(a5),a0														;D0ED000A
	lea		GFX_Pockets+$4130.l,a1												;43F900050832
	add.w	d0,d0																;D040
	add.w	d0,a0																;D0C0
	asl.w	#$03,d0																;E740
	add.w	d0,a1																;D2C0
	move.l	#$00010037,d5														;2A3C00010037	;Long Addr replaced with Symbol
	move.w	#$0004,d3															;363C0004
	swap	d3																	;4843
	move.l	#$00000090,a3														;267C00000090
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l									;33FCFFFF0000B4BE
	bsr		Draw_WallSprite_Rows_Loop											;6100F1B2
	clr.w	Buffer_Colour_Mask_Toggle.l											;42790000B4BE
	tst.b	adrB_00EE2C.l														;4A390000EE2C
	beq.s	adrCd00C434															;670A
	subq.b	#$01,$000F(a5)														;532D000F
	move.w	#$0006,$0022(a5)													;3B7C00060022
adrCd00C434:		; Memory Address ($C434) and binary offset [$C0B0]
	rts																			;4E75

Click_SwitchView:		; Memory Address ($C436) and binary offset [$C0B2]
	move.w	$0006(a5),d7														;3E2D0006
	bsr		adrCd00CFF0															;61000BB4
adrCd00C43E:		; Memory Address ($C43E) and binary offset [$C0BA]
	move.w	$0014(a5),d0														;302D0014
	add.w	#$0060,d0															;06400060
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$0A16,a0															;D0FC0A16
	add.w	$000A(a5),a0														;D0ED000A
	bsr		Draw_PocketGraphic													;61000694
	move.w	$0014(a5),d0														;302D0014
	asl.w	#$02,d0																;E540
	lea		adrJT00C484.l,a0													;41F90000C484
	move.l	$00(a0,d0.w),a0														;20700000
	jsr		(a0)																;4E90
	tst.b	adrB_00EE2C.l														;4A390000EE2C
	beq.s	adrCd00C482															;6710
	addq.w	#$01,$0014(a5)														;526D0014
	cmp.w	#$0003,$0014(a5)													;0C6D00030014
	bcs.s	adrCd00C482															;6504
	clr.w	$0014(a5)															;426D0014
adrCd00C482:		; Memory Address ($C482) and binary offset [$C0FE]
	rts																			;4E75

adrJT00C484:		; Memory Address ($C484) and binary offset [$C100]
	dc.l	adrJA00C938	;0000C938
	dc.l	adrJA00C852	;0000C852
	dc.l	Draw_ChampionStats_DefaultPosition	;0000CB28

Click_SelectChampion:		; Memory Address ($C490) and binary offset [$C10C]
	clr.w	adrW_00EEC8.l														;42790000EEC8
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$0050,a0															;D0FC0050
	lea		Notice_SelectChampion.l,a6											;4DF90000E4A0
	moveq	#$27,d6																;7C27
	tst.w	adrW_00C514.l														;4A790000C514
	bne.s	adrCd00C4BA															;660A
	move.w	#$00FF,adrW_00EEC6.l												;33FC00FF0000EEC6
	bra.s	adrCd00C4E0															;6026

adrCd00C4BA:		; Memory Address ($C4BA) and binary offset [$C136]
	move.b	(a5),d0																;1015
	not.w	d0																	;4640
	and.w	#$0001,d0															;02400001
	add.b	#$31,d0																;06000031
	move.b	d0,$0007(a6)														;1D400007
	move.l	#$000F0000,adrW_00D92A.l											;23FC000F00000000D92A
	bsr		Print_fflim_text													;61000BF0
	move.w	#$0005,adrW_00EEC6.l												;33FC00050000EEC6
adrCd00C4E0:		; Memory Address ($C4E0) and binary offset [$C15C]
	moveq	#$2A,d5																;7A2A
	bsr		Draw_ScrollFrame													;61000756
	move.b	(a5),d0																;1015
	and.w	#$0001,d0															;02400001
	add.b	#$31,d0																;06000031
	lea		BeginGameScroll.l,a6												;4DF90000E9A8
	move.b	d0,$000E(a6)														;1D40000E
	bsr		Print_fflim_text													;61000BCA
	tst.b	adrB_00EE2C.l														;4A390000EE2C
	beq.s	adrCd00C512															;670C
	move.w	#$FFFF,$0014(a5)													;3B7CFFFF0014
	clr.w	adrW_00C514.l														;42790000C514
adrCd00C512:		; Memory Address ($C512) and binary offset [$C18E]
	rts																			;4E75

adrW_00C514:		; Memory Address ($C514) and binary offset [$C190]
	dc.w	$FFFF	;FFFF

Click_ViewObject:		; Memory Address ($C516) and binary offset [$C192]
	move.w	$0006(a5),d0														;302D0006
	asl.w	#$04,d0																;E940
	lea		Character_Pockets_DataTable.l,a6									;4DF90000ED2A
	add.w	d0,a6																;DCC0
	move.w	$000E(a5),d0														;302D000E
	move.b	$00(a6,d0.w),d0														;10360000
	lea		Object_Definition_Table+$02.l,a6									;4DF90000E4C4
	add.w	d0,d0																;D040
	add.w	d0,d0																;D040
	add.w	d0,a6																;DCC0
	bra		InventoryItem_Description											;600012BE

Click_SelectionAvatar:		; Memory Address ($C53C) and binary offset [$C1B8]
	move.w	$0006(a5),d7														;3E2D0006
	move.w	d7,-(sp)															;3F07
	bsr		Draw_Select_Avatars													;61000852
	move.w	$000E(a5),d7														;3E2D000E
	move.w	d7,$0006(a5)														;3B470006
	move.w	$0012(a5),d3														;362D0012
	bsr		adrCd00CD78															;61000824
	clr.w	d4																	;4244
	move.l	#$00000296,a0														;207C00000296
	move.w	$0006(a5),d7														;3E2D0006
	bsr		Draw_ChampionLargeAvatar											;610007B8
	bsr		adrCd00CFF0															;61000A88
	bsr		Load_CurrentChampionStatRecord										;6100A0F0
	move.b	#$FF,$0013(a4)														;197C00FF0013
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$0A19,a0															;D0FC0A19
	add.w	$000A(a5),a0														;D0ED000A
	move.w	d7,d0																;3007
	bsr		adrCd008430															;6100BEAA
	tst.b	$0001(sp)															;4A2F0001
	bpl.s	adrCd00C590															;6A02
	bsr.s	adrCd00C5B8															;6128
adrCd00C590:		; Memory Address ($C590) and binary offset [$C20C]
	tst.b	adrB_00EE2C.l														;4A390000EE2C
	bne.s	adrCd00C5A4															;660C
	subq.w	#$01,$0014(a5)														;536D0014
	bcc.s	adrCd00C5A4															;6406
	move.w	#$0002,$0014(a5)													;3B7C00020014
adrCd00C5A4:		; Memory Address ($C5A4) and binary offset [$C220]
	bsr		adrCd00C43E															;6100FE98
	move.w	(sp)+,d7															;3E1F
	tst.b	adrB_00EE2C.l														;4A390000EE2C
	bne.s	adrCd00C5B6															;6604
	move.w	d7,$0006(a5)														;3B470006
adrCd00C5B6:		; Memory Address ($C5B6) and binary offset [$C232]
	rts																			;4E75

adrCd00C5B8:		; Memory Address ($C5B8) and binary offset [$C234]
	move.l	#$001700AD,d4														;283C001700AD
	bsr.s	adrCd00C5C6															;6106
	move.l	#$001700C5,d4														;283C001700C5
adrCd00C5C6:		; Memory Address ($C5C6) and binary offset [$C242]
	move.l	#$0013003E,d5														;2A3C0013003E
	moveq	#$02,d3																;7602
	add.w	$0008(a5),d5														;DA6D0008
	movem.l	d4/d5,-(sp)															;48E70C00
	bsr		BW_cs_draw_frame													;610014AC
	movem.l	(sp)+,d4/d5															;4CDF0030
	addq.w	#$01,d4																;5244
	sub.l	#$00020000,d4														;048400020000	;Long Addr replaced with Symbol
	sub.l	#$00020000,d5														;048500020000	;Long Addr replaced with Symbol
	addq.w	#$01,d5																;5245
	moveq	#$04,d3																;7604
	bra		BW_draw_frame														;600014E2

adrCd00C5F4:		; Memory Address ($C5F4) and binary offset [$C270]
	move.l	$0002(a5),d1														;222D0002
	sub.w	$0008(a5),d1														;926D0008
	cmpi.w	#$0040,d1															;0C410040
	bcs.s	adrCd00C61E															;651C
	cmpi.w	#$0050,d1															;0C410050
	bcc.s	adrCd00C61E															;6416
	swap	d1																	;4841
	cmpi.w	#$00AF,d1															;0C4100AF
	bcs.s	adrCd00C61E															;650E
	cmpi.w	#$00C3,d1															;0C4100C3
	bcc.s	adrCd00C61E															;6408
	move.w	#$0002,$000C(a5)													;3B7C0002000C
	clr.w	d2																	;4242
adrCd00C61E:		; Memory Address ($C61E) and binary offset [$C29A]
	tst.w	d2																	;4A42
	rts																			;4E75

adrCd00C622:		; Memory Address ($C622) and binary offset [$C29E]
	move.l	$0002(a5),d1														;222D0002
	sub.w	$0008(a5),d1														;926D0008
	cmpi.w	#$0040,d1															;0C410040
	bcs.s	adrCd00C64C															;651C
	cmpi.w	#$0050,d1															;0C410050
	bcc.s	adrCd00C64C															;6416
	swap	d1																	;4841
	cmpi.w	#$00C6,d1															;0C4100C6
	bcs.s	adrCd00C64C															;650E
	cmpi.w	#$00DA,d1															;0C4100DA
	bcc.s	adrCd00C64C															;6408
	move.w	#$0003,$000C(a5)													;3B7C0003000C
	clr.w	d2																	;4242
adrCd00C64C:		; Memory Address ($C64C) and binary offset [$C2C8]
	tst.w	d2																	;4A42
	rts																			;4E75

adrCd00C650:		; Memory Address ($C650) and binary offset [$C2CC]
	cmp.w	#$0002,$0014(a5)													;0C6D00020014
	bne.s	adrCd00C64C															;66F4
	move.l	$0002(a5),d1														;222D0002
	sub.w	$0008(a5),d1														;926D0008
	sub.w	#$0018,d1															;04410018
	bcs.s	adrCd00C69C															;6536
	cmpi.w	#$0020,d1															;0C410020
	bcc.s	adrCd00C64C															;64E0
	swap	d1																	;4841
	sub.w	#$00E8,d1															;044100E8
	bcs.s	adrCd00C64C															;65D8
	moveq	#$00,d0																;7000
	sub.w	#$0020,d1															;04410020
	bcs.s	adrCd00C684															;6508
	sub.w	#$0010,d1															;04410010
	bcs.s	adrCd00C64C															;65CA
	addq.w	#$04,d0																;5840
adrCd00C684:		; Memory Address ($C684) and binary offset [$C300]
	swap	d1																	;4841
	lsr.w	#$03,d1																;E649
	add.w	d1,d0																;D041
	eor.w	#$0007,d0															;0A400007
	move.w	#$0005,$000C(a5)													;3B7C0005000C
	move.w	d0,$000E(a5)														;3B40000E
	moveq	#$00,d2																;7400
	rts																			;4E75

adrCd00C69C:		; Memory Address ($C69C) and binary offset [$C318]
	add.w	#$0018,d1															;06410018
	cmpi.w	#$0007,d1															;0C410007
	bcs.s	adrCd00C708															;6562
	cmpi.w	#$0010,d1															;0C410010
	bcc.s	adrCd00C708															;645C
	swap	d1																	;4841
	cmpi.w	#$00E8,d1															;0C4100E8
	bcs.s	adrCd00C708															;6554
	moveq	#$06,d0																;7006
	cmpi.w	#$00F8,d1															;0C4100F8
	bcs.s	adrCd00C6D8															;651C
	cmpi.w	#$0100,d1															;0C410100
	bcs.s	adrCd00C708															;6546
	moveq	#$07,d0																;7007
	cmpi.w	#$0120,d1															;0C410120
	bcs.s	adrCd00C6D8															;650E
	cmpi.w	#$0128,d1															;0C410128
	bcs.s	adrCd00C708															;6538
	moveq	#$08,d0																;7008
	cmpi.w	#$0138,d1															;0C410138
	bcc.s	adrCd00C708															;6430
adrCd00C6D8:		; Memory Address ($C6D8) and binary offset [$C354]
	move.w	d0,$000C(a5)														;3B40000C
	moveq	#$03,d2																;7403
	cmpi.w	#$0006,d0															;0C400006
	bne.s	adrCd00C6F2															;660E
	subq.w	#$02,$002A(a5)														;556D002A
	and.w	#$0007,$002A(a5)													;026D0007002A
	move.w	#$8003,d2															;343C8003
adrCd00C6F2:		; Memory Address ($C6F2) and binary offset [$C36E]
	rol.w	#$08,d0																;E158
	move.b	#$03,d0																;103C0003
	move.w	d0,$0014(a5)														;3B400014
	move.w	d2,$000E(a5)														;3B42000E
	move.w	#$0008,$0022(a5)													;3B7C00080022
	move.w	d0,d2																;3400
adrCd00C708:		; Memory Address ($C708) and binary offset [$C384]
	tst.w	d2																	;4A42
	rts																			;4E75

adrCd00C70C:		; Memory Address ($C70C) and binary offset [$C388]
	cmp.w	#$0001,$0014(a5)													;0C6D00010014
	bne.s	adrCd00C748															;6634
adrCd00C714:		; Memory Address ($C714) and binary offset [$C390]
	move.l	$0002(a5),d1														;222D0002
	sub.w	$0008(a5),d1														;926D0008
	sub.w	#$0020,d1															;04410020
	bcs.s	adrCd00C748															;6526
	cmpi.w	#$0020,d1															;0C410020
	bcc.s	adrCd00C748															;6420
	swap	d1																	;4841
	sub.w	#$00E0,d1															;044100E0
	bcs.s	adrCd00C748															;6518
	move.w	#$0004,$000C(a5)													;3B7C0004000C
	lsr.w	#$04,d1																;E849
	move.w	d1,d2																;3401
	swap	d1																	;4841
	sub.w	#$0010,d1															;04410010
	bcs.s	adrCd00C744															;6502
	addq.w	#$06,d2																;5C42
adrCd00C744:		; Memory Address ($C744) and binary offset [$C3C0]
	move.w	d2,$000E(a5)														;3B42000E
adrCd00C748:		; Memory Address ($C748) and binary offset [$C3C4]
	tst.w	d2																	;4A42
	rts																			;4E75

adrCd00C74C:		; Memory Address ($C74C) and binary offset [$C3C8]
	move.l	$0002(a5),d1														;222D0002
	moveq	#-$01,d2															;74FF
	moveq	#$0E,d3																;760E
adrCd00C754:		; Memory Address ($C754) and binary offset [$C3D0]
	cmp.w	d3,d1																;B243
	bcs.s	adrCd00C760															;6508
	addq.w	#$01,d2																;5242
	add.w	#$0030,d3															;06430030
	bra.s	adrCd00C754															;60F4

adrCd00C760:		; Memory Address ($C760) and binary offset [$C3DC]
	tst.w	d2																	;4A42
	bmi.s	adrCd00C7C4															;6B60
	subq.w	#$07,d3																;5F43
	cmp.w	d3,d1																;B243
	bcc.s	adrCd00C7C2															;6458
	swap	d1																	;4841
	cmpi.w	#$009E,d1															;0C41009E
	bcc.s	adrCd00C7C2															;6450
	moveq	#$27,d3																;7627
adrCd00C774:		; Memory Address ($C774) and binary offset [$C3F0]
	cmp.w	d3,d1																;B243
	bcs.s	adrCd00C780															;6508
	addq.w	#$04,d2																;5842
	add.w	#$0028,d3															;06430028
	bra.s	adrCd00C774															;60F4

adrCd00C780:		; Memory Address ($C780) and binary offset [$C3FC]
	sub.w	#$0009,d3															;04430009
	cmp.w	d3,d1																;B243
	bcc.s	adrCd00C7C2															;643A
	cmp.w	adrW_00EEE4.l,d2													;B4790000EEE4
	beq.s	adrCd00C7C4															;6734
	cmp.w	adrW_00EE82.l,d2													;B4790000EE82
	beq.s	adrCd00C7C4															;672C
	move.l	a5,d0																;200D
	eor.l	#Player1_Data,d0													;0A800000EE7C
	eor.l	#Player2_Data,d0													;0A800000EEDE
	move.l	d0,a0																;2040
	cmp.w	#$0001,$000C(a0)													;0C680001000C
	bne.s	adrCd00C7B6															;6606
	cmp.w	$000E(a0),d2														;B468000E
	beq.s	adrCd00C7C4															;670E
adrCd00C7B6:		; Memory Address ($C7B6) and binary offset [$C432]
	move.w	d2,$000E(a5)														;3B42000E
	move.w	#$0001,$000C(a5)													;3B7C0001000C
	moveq	#$00,d2																;7400
adrCd00C7C2:		; Memory Address ($C7C2) and binary offset [$C43E]
	swap	d2																	;4842
adrCd00C7C4:		; Memory Address ($C7C4) and binary offset [$C440]
	tst.w	d2																	;4A42
	rts																			;4E75

Prepare_AndDrawSpellBookSurface:		; Memory Address ($C7C8) and binary offset [$C444]
	; Draws the packed spell-book surface and selects the current champion record.
	move.w	$0006(a5),d7														;3E2D0006
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$0184,a0															;D0FC0184
	add.w	$000A(a5),a0														;D0ED000A
	move.l	#$00000070,a3														;267C00000070
	move.l	#$0005003D,d5														;2A3C0005003D	;Long Addr replaced with Symbol
	lea		GFX_Pockets+$4100.l,a1												;43F900050802
	bsr		Draw_PlanarGraphic													;610004CA
	asl.w	#$05,d7																;EB47
	lea		Character_Stats_DataTable.l,a4										;49F90000EB2A
	add.w	d7,a4																;D8C7
	rts																			;4E75

Clear_SpellBookPanel:		; Memory Address ($C7FC) and binary offset [$C478]
	; Clears the 96-pixel spell-book panel before redrawing it.
	move.l	#$005E00E0,d4														;283C005E00E0
	move.l	#$00480009,d5														;2A3C00480009
	add.w	$0008(a5),d5														;DA6D0008
	moveq	#$00,d3																;7600
	bra		BW_draw_bar															;60001258

Draw_SpellPointValues:		; Memory Address ($C812) and binary offset [$C48E]
	; Formats and prints the current and maximum spell-point values.
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$0E2C,a0															;D0FC0E2C
	add.w	$000A(a5),a0														;D0ED000A
adrCd00C820:		; Memory Address ($C820) and binary offset [$C49C]
	bsr		Load_CurrentChampionStatRecord										;61009E3A
	or.b	#$0C,$0054(a5)														;002D000C0054
	move.b	$0009(a4),d0														;102C0009
	bsr		Convert_ByteToDecimalText											;61000694
	move.b	$000A(a4),d0														;102C000A
	lea		adrEA00EA00.l,a6													;4DF90000EA00
	move.b	d1,$000E(a6)														;1D41000E
	ror.w	#$08,d1																;E059
	move.b	d1,$000D(a6)														;1D41000D
	bsr		Convert_ByteToDecimalText											;6100067C
	move.w	d1,$0010(a6)														;3D410010
	bra		Print_fflim_text													;60000876

adrJA00C852:		; Memory Address ($C852) and binary offset [$C4CE]
	bsr.s	Clear_SpellBookPanel												;61A8
	bsr		Prepare_AndDrawSpellBookSurface										;6100FF72
	add.w	#$00A0,a0															;D0FC00A0
	bsr.s	adrCd00C820															;61C2
adrCd00C85E:		; Memory Address ($C85E) and binary offset [$C4DA]
	move.w	$002A(a5),d0														;302D002A
	bsr.s	Draw_SpellBookRunePage												;6106
	move.w	$002A(a5),d0														;302D002A
	addq.w	#$01,d0																;5240
Draw_SpellBookRunePage:		; Memory Address ($C86A) and binary offset [$C4E6]
	; Draws one rune page from SpellBookRunes.
	or.b	#$04,$0054(a5)														;002D00040054
	move.w	d0,d7																;3E00
	asl.w	#$04,d0																;E940
	lea		SpellBookRunes.l,a6													;4DF900018784
	add.w	d0,a6																;DCC0
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$042D,a0															;D0FC042D
	add.w	$000A(a5),a0														;D0ED000A
	move.w	#$0003,adrW_00D92C.l												;33FC00030000D92C
	move.w	d7,d0																;3007
	lsr.w	#$01,d0																;E248
	move.l	a4,a3																;264C
	add.w	d0,a3																;D6C0
	move.w	d7,d0																;3007
	asl.w	#$02,d7																;E547
	swap	d7																	;4847
	and.w	#$0001,d0															;02400001
	bne.s	adrCd00C8D6															;6630
	move.w	#$0007,d7															;3E3C0007
adrCd00C8AA:		; Memory Address ($C8AA) and binary offset [$C526]
	bsr.s	adrCd00C906															;615A
	move.w	d6,adrW_00D92A.l													;33C60000D92A
	moveq	#$02,d6																;7C02
adrLp00C8B4:		; Memory Address ($C8B4) and binary offset [$C530]
	move.b	(a6)+,d0															;101E
	bsr		adrCd00D8C0															;61001008
	dbra	d6,adrLp00C8B4														;51CEFFF8
	sub.w	#$0028,a0															;90FC0028
	move.b	(a6)+,d0															;101E
	bsr		adrCd00D8C0															;61000FFA
	add.w	#$0164,a0															;D0FC0164
	subq.w	#$01,d7																;5347
	cmpi.w	#$0004,d7															;0C470004
	bcc.s	adrCd00C8AA															;64D6
	rts																			;4E75

adrCd00C8D6:		; Memory Address ($C8D6) and binary offset [$C552]
	sub.w	#$0022,a0															;90FC0022
	move.w	#$0003,d7															;3E3C0003
adrLp00C8DE:		; Memory Address ($C8DE) and binary offset [$C55A]
	bsr.s	adrCd00C906															;6126
	move.w	d6,adrW_00D92A.l													;33C60000D92A
	move.b	(a6)+,d0															;101E
	bsr		adrCd00D8C0															;61000FD6
	add.w	#$0028,a0															;D0FC0028
	moveq	#$02,d6																;7C02
adrLp00C8F2:		; Memory Address ($C8F2) and binary offset [$C56E]
	move.b	(a6)+,d0															;101E
	bsr		adrCd00D8C0															;61000FCA
	dbra	d6,adrLp00C8F2														;51CEFFF8
	add.w	#$0114,a0															;D0FC0114
	dbra	d7,adrLp00C8DE														;51CFFFDC
	rts																			;4E75

adrCd00C906:		; Memory Address ($C906) and binary offset [$C582]
	moveq	#$01,d6																;7C01
	btst	d7,$000C(a3)														;0F2B000C
	beq.s	adrCd00C932															;6724
	swap	d7																	;4847
	move.w	d7,d6																;3C07
	swap	d7																	;4847
	move.w	d7,d0																;3007
	not.w	d0																	;4640
	and.w	#$0003,d0															;02400003
	add.w	d6,d0																;D046
	and.w	#$001F,d0															;0240001F
	moveq	#$0E,d6																;7C0E
	cmp.b	$0013(a4),d0														;B02C0013
	beq.s	adrCd00C932															;6708
	bsr		Character_GetClassIndex												;61009FD4
	move.b	adrB_00C934(pc,d0.w),d6												;1C3B0004
adrCd00C932:		; Memory Address ($C932) and binary offset [$C5AE]
	rts																			;4E75

adrB_00C934:		; Memory Address ($C934) and binary offset [$C5B0]
	dc.b	$06	;06
	dc.b	$0D	;0D
	dc.b	$0C	;0C
	dc.b	$07	;07

adrJA00C938:		; Memory Address ($C938) and binary offset [$C5B4]
	move.w	d7,-(sp)															;3F07
	bsr		Clear_SpellBookPanel												;6100FEC0
	move.l	#$005D00E2,d4														;283C005D00E2
	move.l	#$00070018,d5														;2A3C00070018
	add.w	$0008(a5),d5														;DA6D0008
	moveq	#$03,d3																;7603
	bsr		BW_draw_bar															;61001116
	move.w	#$0040,d5															;3A3C0040
	add.w	$0008(a5),d5														;DA6D0008
	bsr		BW_draw_bar															;6100110A
	move.w	(sp)+,d7															;3E1F
	move.l	#$0000029C,a0														;207C0000029C
	bsr		adrCd008358															;6100B9EE
	move.l	#$00000B5C,a0														;207C00000B5C	;Long Addr replaced with Symbol
	bsr		adrCd008358															;6100B9E4
	bsr		Draw_InventoryPocketSlots											;61000044
	lea		adrEA00EA14.l,a6													;4DF90000EA14
	bsr		Print_fflim_text													;61000744
adrCd00C984:		; Memory Address ($C984) and binary offset [$C600]
	move.w	d7,d0																;3007
	bsr		Load_ChampionStatRecord												;61009CD8
	move.w	d7,d0																;3007
	bsr		Calculate_CharacterArmourLevel										;61009990
	move.b	#$2B,d1																;123C002B
	moveq	#$0A,d0																;700A
	sub.b	d3,d0																;9003
	bpl.s	adrCd00C9A0															;6A06
	move.b	#$2D,d1																;123C002D
	neg.b	d0																	;4400
adrCd00C9A0:		; Memory Address ($C9A0) and binary offset [$C61C]
	lea		adrEA00EA25.l,a6													;4DF90000EA25
	move.b	d1,$000C(a6)														;1D41000C
	bsr		Convert_ByteToDecimalText											;61000518
	move.b	d1,$000E(a6)														;1D41000E
	ror.w	#$08,d1																;E059
	move.b	d1,$000D(a6)														;1D41000D
	bra		Print_fflim_text													;6000070C

Draw_InventoryPocketSlots:		; Memory Address ($C9BC) and binary offset [$C638]
	; Draws the selected champion's twelve inventory pocket slots.
	move.l	a4,-(sp)															;2F0C
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$051C,a0															;D0FC051C
	add.w	$000A(a5),a0														;D0ED000A
	move.w	d7,d0																;3007
	asl.w	#$04,d0																;E940
	lea		Character_Pockets_DataTable.l,a4									;49F90000ED2A
	add.w	d0,a4																;D8C0
	swap	d7																	;4847
	clr.w	d7																	;4247
adrCd00C9DC:		; Memory Address ($C9DC) and binary offset [$C658]
	moveq	#$00,d0																;7000
	move.b	$00(a4,d7.w),d0														;10347000
	bne.s	adrCd00CA38															;6654
	cmpi.w	#$0002,d7															;0C470002
	bcc.s	Select_EmptyInventorySlotGraphic									;642A
	swap	d7																	;4847
	move.w	d7,d0																;3007
	swap	d7																	;4847
	asl.w	#$05,d0																;EB40
	lea		Character_Stats_DataTable.l,a1										;43F90000EB2A
	add.w	d0,a1																;D2C0
	moveq	#$00,d0																;7000
	move.b	$0012(a1),d0														;10290012
	beq.s	Select_EmptyInventorySlotGraphic									;6712
	lea		Object_Definition_Table+$01.l,a1									;43F90000E4C3
	asl.w	#$02,d0																;E540
	move.b	$00(a1,d0.w),d3														;16310000
	moveq	#$1A,d0																;701A
	add.w	d7,d0																;D047
	bra.s	adrCd00CA32															;601E

Select_EmptyInventorySlotGraphic:		; Memory Address ($CA14) and binary offset [$C690]
	; Selects the semantic empty hand, armour, shield, or pocket picture and the
	; player secondary UI colour.
	move.w	$0012(a5),d3														;Loads the secondary UI colour used to recolour empty hand, armour, shield, and pocket template graphics.
	cmpi.w	#$0004,d7															;0C470004
	bcc.s	adrCd00CA32															;6414
	move.w	d7,d0																;3007
	cmpi.w	#$0003,d7															;0C470003
	bne.s	adrCd00CA2E															;6608
	btst	#$10,d7																;08070010
	beq.s	adrCd00CA2E															;6702
	addq.w	#$01,d0																;5240
adrCd00CA2E:		; Memory Address ($CA2E) and binary offset [$C6AA]
	add.w	#$006C,d0															;0640006C
adrCd00CA32:		; Memory Address ($CA32) and binary offset [$C6AE]
	bsr		Draw_PocketGraphic													;610000B6
	bra.s	adrCd00CA4C															;6014

adrCd00CA38:		; Memory Address ($CA38) and binary offset [$C6B4]
	cmpi.w	#$0005,d0															;0C400005
	bcc.s	adrCd00CA4A															;640C
	move.b	$0B(a4,d0.w),d1														;1234000B
	bne.s	adrCd00CA4A															;6606
	clr.b	$00(a4,d7.w)														;42347000
	bra.s	adrCd00C9DC															;6092

adrCd00CA4A:		; Memory Address ($CA4A) and binary offset [$C6C6]
	bsr.s	ObjectGraphic														;611A
adrCd00CA4C:		; Memory Address ($CA4C) and binary offset [$C6C8]
	addq.w	#$01,d7																;5247
	cmpi.w	#$0006,d7															;0C470006
	bne.s	adrCd00CA58															;6604
	add.w	#$0274,a0															;D0FC0274
adrCd00CA58:		; Memory Address ($CA58) and binary offset [$C6D4]
	cmpi.w	#$000C,d7															;0C47000C
	bcs		adrCd00C9DC															;6500FF7E
	swap	d7																	;4847
	move.l	(sp)+,a4															;285F
	rts																			;4E75

ObjectGraphic:		; Memory Address ($CA66) and binary offset [$C6E2]
	tst.w	d0																	;4A40
	beq		Draw_PocketGraphic													;67000080
	cmpi.w	#$0005,d0															;0C400005
	bcs.s	NumberedObject														;6534
	cmpi.w	#$0069,d0															;0C400069
	bcs.s	.SkipRings															;651A
	cmpi.w	#$006D,d0															;0C40006D
	bcc.s	.SkipRings															;6414
	move.w	d0,d3																;3600
	sub.w	#$0069,d3															;04430069
	lea		RingUses.l,a1														;43F90000EE32
	tst.b	$00(a1,d3.w)														;4A313000
	bpl.s	.SkipRings															;6A02
	moveq	#$68,d0																;7068
.SkipRings:		; Memory Address ($CA92) and binary offset [$C70E]
	asl.w	#$02,d0																;E540
	lea		Object_Definition_Table.l,a1										;43F90000E4C2
	moveq	#$00,d3																;7600
	move.b	$01(a1,d0.w),d3														;16310001
	move.b	$00(a1,d0.w),d0														;10310000
	bra.s	Draw_PocketGraphic													;6044

NumberedObject:		; Memory Address ($CAA6) and binary offset [$C722]
	move.l	a0,-(sp)															;2F08
	move.w	d0,-(sp)															;3F00
	move.b	d1,d0																;1001
	bsr		Convert_ByteToDecimalText											;61000416
	move.w	d1,adrEA00CAE6.l													;33C10000CAE6
	move.w	(sp),d0																;3017
	bsr.s	Draw_PocketGraphic													;6130
	move.l	$0002(sp),a0														;206F0002
	add.w	#$0050,a0															;D0FC0050
	cmp.w	#$0003,(sp)+														;0C5F0003
	bcs.s	adrCd00CACC															;6504
	add.w	#$0118,a0															;D0FC0118
adrCd00CACC:		; Memory Address ($CACC) and binary offset [$C748]
	lea		adrEA00CAE6.l,a6													;4DF90000CAE6
	move.l	#$00060000,adrW_00D92A.l											;23FC000600000000D92A
	bsr		Print_fflim_text													;610005E8
	move.l	(sp)+,a0															;205F
	addq.w	#$02,a0																;5448
	rts																			;4E75

adrEA00CAE6:		; Memory Address ($CAE6) and binary offset [$C762]
	dc.b	$FF	;FF
	dc.b	$FF	;FF
	dc.b	$FF	;FF
NullString:
	dc.b	$FF	;FF

Draw_PocketGraphic:		; Memory Address ($CAEA) and binary offset [$C766]
	; Resolves a GFX_Pockets picture index and enters the common four-plane
	; renderer.
	move.l	#$00000098,a3														;267C00000098
	lea		GFX_Pockets.l,a1													;43F90004C702
	and.w	#$00FF,d0															;024000FF
adrCd00CAFA:		; Memory Address ($CAFA) and binary offset [$C776]
	cmpi.b	#$14,d0																;0C000014
	bcs.s	adrCd00CB0A															;650A
	add.w	#$0A00,a1															;D2FC0A00
	sub.w	#$0014,d0															;04400014
	bra.s	adrCd00CAFA															;60F0

adrCd00CB0A:		; Memory Address ($CB0A) and binary offset [$C786]
	asl.w	#$03,d0																;E740
	add.w	d0,a1																;D2C0
	movem.l	a0/a6,-(sp)															;48E70082
	bsr.s	adrCd00CB1C															;6108
	movem.l	(sp)+,a0/a6															;4CDF4100
	addq.w	#$02,a0																;5448
	rts																			;4E75

adrCd00CB1C:		; Memory Address ($CB1C) and binary offset [$C798]
	move.l	#$0000000F,-(sp)													;2F3C0000000F
	jmp		Draw_PlanarGraphicCore.l											;4EF90000CE28

Draw_ChampionStats_DefaultPosition:		; Memory Address ($CB28) and binary offset [$C7A4]
	; Sets the default scroll Y position to $2A, then enters Draw_ChampionStats.
	moveq	#$2A,d5																;7A2A
Draw_ChampionStats:		; Memory Address ($CB2A) and binary offset [$C7A6]
	; Draws the scroll frame, inserts fields from the selected 32-byte champion
	; record into ChampionStatsScroll_TextTemplate, then calls Print_fflim_text. D5
	; supplies the scroll Y position.
	move.w	$0006(a5),-(sp)														;3F2D0006
	bsr		Draw_ScrollFrame													;6100010A
	move.w	(sp),d0																;3017
	lea		ChampionStatsScroll_TextTemplate.l,a6								;4DF90000CBD2
	asl.w	#$05,d0																;EB40
	lea		Character_Stats_DataTable.l,a0										;41F90000EB2A
	add.w	d0,a0																;D0C0
	lea		ChampionStatsScroll_FieldAndTextOffsets.l,a2						;45F90000CBC4
	moveq	#$06,d7																;7E06
	moveq	#$00,d0																;7000
ChampionStats_InsertFieldsLoop:		; Memory Address ($CB4E) and binary offset [$C7CA]
	; Copies seven champion fields into their corresponding positions within the
	; writable formatted-text template.
	move.b	$00(a2,d7.w),d0														;10327000
	move.b	$00(a0,d0.w),d0														;10300000
	bsr		Convert_ByteToDecimalText											;6100036C
	move.b	$07(a2,d7.w),d0														;10327007
	move.b	d1,$01(a6,d0.w)														;1D810001
	ror.w	#$08,d1																;E059
	move.b	d1,$00(a6,d0.w)														;1D810000
	dbra	d7,ChampionStats_InsertFieldsLoop									;51CFFFE4
	move.w	(sp)+,d7															;3E1F
	move.b	$0005(a0),d0														;10280005
	divu	#$0064,d0															;80FC0064
	tst.w	d0																	;4A40
	bne.s	adrCd00CB7E															;6604
	move.b	#$F0,d0																;103C00F0
adrCd00CB7E:		; Memory Address ($CB7E) and binary offset [$C7FA]
	add.b	#$30,d0																;06000030
	move.b	d0,$0049(a6)														;1D400049
	swap	d0																	;4840
	bsr		Convert_ByteToDecimalText											;6100033A
	move.w	d1,$004A(a6)														;3D41004A
	move.b	#$20,$0053(a6)														;1D7C00200053
	moveq	#$51,d2																;7451
	moveq	#$00,d0																;7000
	move.b	$0006(a0),d0														;10280006
	divu	#$0064,d0															;80FC0064
	tst.b	d0																	;4A00
	beq.s	adrCd00CBB0															;670A
	add.b	#$30,d0																;06000030
	move.b	d0,$00(a6,d2.w)														;1D802000
	addq.w	#$01,d2																;5242
adrCd00CBB0:		; Memory Address ($CBB0) and binary offset [$C82C]
	swap	d0																	;4840
	bsr		Convert_ByteToDecimalText											;61000310
	move.b	d1,$01(a6,d2.w)														;1D812001
	ror.w	#$08,d1																;E059
	move.b	d1,$00(a6,d2.w)														;1D812000
	bra		Print_fflim_text													;60000504

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
	or.b	#$0C,$0054(a5)														;002D000C0054
	swap	d5																	;4845
	move.w	#$0018,d5															;3A3C0018
	add.w	$0008(a5),d5														;DA6D0008
	move.l	#$003F00F0,d4														;283C003F00F0
	moveq	#$03,d3																;7603
	bsr		BW_draw_bar															;61000E14
	sub.l	a3,a3																;97CB
	lea		GFX_Scroll_Edge_Left.l,a1											;43F90001975E
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$03DC,a0															;D0FC03DC
	add.w	$000A(a5),a0														;D0ED000A
	clr.w	d5																	;4245
	swap	d5																	;4845
	move.l	d5,-(sp)															;2F05
	bsr.s	Draw_PlanarGraphic													;6144
	move.l	(sp)+,d5															;2A1F
	lea		GFX_Scroll_Edge_Right.l,a1											;43F90001992E
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$03E6,a0															;D0FC03E6
	add.w	$000A(a5),a0														;D0ED000A
	bsr.s	Draw_PlanarGraphic													;612C
	sub.w	#$000A,a0															;90FC000A
	lea		GFX_Scroll_Edge_Bottom.l,a1											;43F90001948E
	move.l	#$0005000E,d5														;2A3C0005000E	;Long Addr replaced with Symbol
	bsr.s	Draw_PlanarGraphic													;611A
	lea		GFX_Scroll_Edge_Top.l,a1											;43F9000191BE
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$0184,a0															;D0FC0184
	add.w	$000A(a5),a0														;D0ED000A
	move.l	#$0005000E,d5														;2A3C0005000E	;Long Addr replaced with Symbol
Draw_PlanarGraphic:		; Memory Address ($CCB8) and binary offset [$C934]
	; Pushes the packed DBRA width/height counts from D5 and enters the generic
	; four-plane graphic renderer.
	move.l	d5,-(sp)															;2F05
	bra		Draw_PlanarGraphicCore												;6000016C

Draw_MainChampionAvatarPanel:		; Memory Address ($CCBE) and binary offset [$C93A]
	; Composes the main champion panel from its outer bevel, large portrait, and
	; optional inner frame.
	move.l	#$002F0000,d4														;Sets outer avatar-panel X=$00 and horizontal terminal count $2F, producing a $30-pixel width.
	moveq	#$0A,d5																;Sets the outer avatar-panel top edge to player-local Y=$0A.
	bsr		Draw_BevelledPanelFrame												;6100F3F2
	move.w	$0006(a5),d7														;3E2D0006
	moveq	#-$01,d4															;78FF
	move.l	#MainChampionAvatar_ScreenByteOffset,a0								;Selects screen byte offset $02A9, which resolves to player-local portrait coordinate ($08,$11).
	bsr.s	Draw_ChampionLargeAvatar											;Draws only the 32 by 30 champion portrait; the surrounding frames are separate procedural stages.
Draw_MainChampionAvatarInnerFrame:		; Memory Address ($CCD8) and binary offset [$C954]
	; Draws the inner large-avatar outline unless the current player state
	; suppresses it.
	btst	#$00,$003E(a5)														;082D0000003E
	bne.s	adrCd00CD12															;6632
	or.b	#$01,$0054(a5)														;002D00010054
	move.l	#$0021000F,d5														;Sets inner-frame Y=$0F and vertical terminal count $21, producing a $22-pixel height.
	add.w	$0008(a5),d5														;DA6D0008
	move.l	#$00230006,d4														;Sets inner-frame X=$06 and horizontal terminal count $23, producing a $24-pixel width.
	moveq	#$01,d3																;7601
	bsr.s	Select_ChampionShieldInkColour										;6104
	bra		BW_draw_frame														;Draws the optional inner outline after the portrait, using the default or worn-spell-selected ink.

Select_ChampionShieldInkColour:		; Memory Address ($CCFE) and binary offset [$C97A]
	; Map champion-record byte $11 to the palette ink replacing shield-surround
	; index $F.
	move.w	d7,d0																;3007
	bsr		Load_ChampionStatRecord												;6100995E
	move.b	ChampionStat_WornSpell(a4),d0										;Reads the currently worn spell; zero leaves the normal light-grey shield-surround ink unchanged.
	beq.s	adrCd00CD12															;6708
	and.w	#$0007,d0															;Uses the worn spell's low three bits to select one of eight shield-surround ink colours.
	move.b	ChampionShieldInkColourLookup(pc,d0.w),d3							;163B0004
adrCd00CD12:		; Memory Address ($CD12) and binary offset [$C98E]
	rts																			;4E75

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
	add.l	screen_ptr.l,a0														;D1F900008D36
	add.w	$000A(a5),a0														;D0ED000A
	lea		GFX_Avatars_Large.l,a1												;43F900041D30
	move.w	d7,d0																;3007
	asl.w	#$05,d0																;EB40
	sub.w	d7,d0																;9047
	sub.w	d7,d0																;9047
	asl.w	#$04,d0																;E940
	add.w	d0,a1																;D2C0
	move.l	#ChampionLargeAvatar_DrawDimensions,-(sp)							;2F3C0001001D	;Long Addr replaced with Symbol
	sub.l	a3,a3																;97CB
	tst.w	d4																	;4A44
	bne		Draw_PlanarGraphicCore												;660000E4
	bra		Draw_PlanarGraphicCore												;600000E0

Get_ChampionShieldScreenPosition:		; Memory Address ($CD4A) and binary offset [$C9C6]
	; Calculates the screen destination for a champion shield/avatar slot.
	move.w	d7,d5																;3A07
	and.w	#$0003,d5															;02450003
	move.w	d5,d0																;3005
	add.w	d0,d5																;DA40
	add.w	d0,d5																;DA40
	asl.w	#$04,d5																;E945
	add.w	#$000F,d5															;0645000F
	mulu	#$0028,d5															;CAFC0028
	move.w	d7,d0																;3007
	and.w	#$000C,d0															;0240000C
	move.w	d0,d1																;3200
	lsr.w	#$02,d1																;E449
	add.w	d1,d0																;D041
	add.w	d5,d0																;D045
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	d0,a0																;D0C0
	rts																			;4E75

adrCd00CD78:		; Memory Address ($CD78) and binary offset [$C9F4]
	lea		GFX_Shield_Clicked.l,a1												;43F900019BFE
	sub.l	a3,a3																;97CB
	bsr.s	Get_ChampionShieldScreenPosition									;61C8
	move.l	#$00010028,d5														;2A3C00010028	;Long Addr replaced with Symbol
	bra		adrCd00CE26															;6000009C

ChampionSelection:		; Memory Address ($CD8C) and binary offset [$CA08]
	moveq	#$0F,d7																;7E0F
.ChampionSelection_Loop:		; Memory Address ($CD8E) and binary offset [$CA0A]
	bsr.s	Draw_Select_Avatars													;6106
	dbra	d7,.ChampionSelection_Loop											;51CFFFFC
ExitAvatarDrawing:		; Memory Address ($CD94) and binary offset [$CA10]
	rts																			;4E75

Draw_Select_Avatars:
	cmpi.w	#$0010,d7															;0C470010
	bcc.s	ExitAvatarDrawing													;64F8
	bsr.s	Get_ChampionShieldScreenPosition									;61AC
	moveq	#$04,d3																;7604
Draw_ShieldAvatar:		; Memory Address ($CDA0) and binary offset [$CA1C]
	; Composes a champion shield avatar from its top, avatar, class-mask, and
	; bottom planar components.
	move.l	#DeadPartyShieldClassColourMask,d0									;203C00020103	;Long Addr replaced with Symbol
	tst.w	d3																	;Keeps the fixed dead mask when D3 is zero; living shields replace it with a ClassColours record.
	beq.s	Store_ShieldClassColourMask											;6712
	lea		ClassColours.l,a6													;4DF90000846E
	move.w	d7,d0																;3007
	bsr		Character_GetClassIndex												;61009B4C
	asl.w	#$02,d0																;E540
	move.l	$00(a6,d0.w),d0														;20360000
Store_ShieldClassColourMask:		; Memory Address ($CDBC) and binary offset [$CA38]
	; Store the normal professional-symbol mask or fixed dead mask before drawing
	; the shield components.
	lea		Buffer_Colour_Mask.l,a6												;4DF90000B4C0
	move.l	d0,(a6)																;2C80
	sub.l	a3,a3																;97CB
	lea		GFX_Shield_Top.l,a1													;43F900044B30
	move.l	#$00010004,d5														;2A3C00010004	;Long Addr replaced with Symbol
	bsr		adrCd00CE26															;61000052
	lea		GFX_Avatars_Small.l,a1												;43F900043B30
	move.w	d7,d0																;3007
	asl.w	#$08,d0																;E140
	add.w	d0,a1																;D2C0
	move.l	#$0001000F,d5														;2A3C0001000F	;Long Addr replaced with Symbol
	bsr.s	adrCd00CE26															;613C
	lea		GFX_Shield_Classes.l,a1												;43F900044C10
	move.w	d7,d0																;3007
	and.w	#$0003,d0															;02400003
	move.w	d0,d1																;3200
	asl.w	#$03,d0																;E740
	add.w	d1,d0																;D041
	add.w	d1,d0																;D041
	add.w	d1,d0																;D041
	asl.w	#$04,d0																;E940
	add.w	d0,a1																;D2C0
	move.l	#$1000A,d5															;2A3C0001000A
	move.w	#$FFFF,Buffer_Colour_Mask_Toggle.l									;Enables four-colour remapping only for the professional symbol; the face avatar is never passed through this mask.
	bsr.s	adrCd00CE26															;6112
	clr.w	Buffer_Colour_Mask_Toggle.l											;Disables four-colour remapping immediately after the professional symbol has been drawn.
	lea		GFX_Shield_Bottom.l,a1												;43F900044B80
	move.l	#$00010008,d5														;2A3C00010008	;Long Addr replaced with Symbol
adrCd00CE26:		; Memory Address ($CE26) and binary offset [$CAA2]
	move.l	d5,-(sp)															;2F05
Draw_PlanarGraphicCore:		; Memory Address ($CE28) and binary offset [$CAA4]
	; Draws packed four-plane graphic rows and applies the supplied template colour
	; index.
	move.l	(sp)+,d5															;2A1F
adrLp00CE2A:		; Memory Address ($CE2A) and binary offset [$CAA6]
	swap	d5																	;4845
	move.w	d5,-(sp)															;3F05
adrLp00CE2E:		; Memory Address ($CE2E) and binary offset [$CAAA]
	move.l	(a1)+,d0															;2019
	move.l	(a1)+,d1															;2219
	tst.w	Buffer_Colour_Mask_Toggle.l											;4A790000B4BE
	beq.s	adrCd00CE3E															;6704
	bsr		Remap_PlanarSpriteColours											;6100E194
adrCd00CE3E:		; Memory Address ($CE3E) and binary offset [$CABA]
	bsr		Replace_PlanarInk15WithColour										;61000046
	move.b	d1,$5DC1(a0)														;11415DC1
	swap	d1																	;4841
	move.b	d1,$3E81(a0)														;11413E81
	ror.l	#$08,d1																;E099
	move.b	d1,$3E80(a0)														;11413E80
	swap	d1																	;4841
	move.b	d1,$5DC0(a0)														;11415DC0
	move.b	d0,$1F41(a0)														;11401F41
	swap	d0																	;4840
	move.b	d0,$0001(a0)														;11400001
	ror.l	#$08,d0																;E098
	move.b	d0,(a0)																;1080
	swap	d0																	;4840
	move.b	d0,$1F40(a0)														;11401F40
	addq.w	#$02,a0																;5448
	dbra	d5,adrLp00CE2E														;51CDFFBE
	move.w	(sp)+,d5															;3A1F
	sub.w	d5,a0																;90C5
	sub.w	d5,a0																;90C5
	add.w	#$0026,a0															;D0FC0026
	add.w	a3,a1																;D2CB
	swap	d5																	;4845
	dbra	d5,adrLp00CE2A														;51CDFFA8
	rts																			;4E75

Replace_PlanarInk15WithColour:		; Memory Address ($CE86) and binary offset [$CB02]
	; Replaces source palette-index $F pixels with the four-bit colour index
	; supplied in D3.
	move.l	d1,d2																;2401
	and.l	d0,d2																;C480
	swap	d2																	;4842
	and.l	d0,d2																;C480
	and.l	d1,d2																;C481
	lea		Bitplane_Mask.l,a2													;45F90000B064
	move.w	d3,d6																;Begins converting the supplied colour index into bitplane masks that replace source ink $F pixels.
	and.w	#$000C,d6															;0246000C
	move.l	$00(a2,d6.w),d6														;2C326000
	move.w	d3,d4																;3803
	asl.w	#$02,d4																;E544
	and.w	#$000C,d4															;0244000C
	move.l	$00(a2,d4.w),d4														;28324000
	and.l	d2,d4																;C882
	and.l	d2,d6																;CC82
	not.l	d2																	;4682
	and.l	d2,d0																;C082
	and.l	d2,d1																;C282
	or.l	d4,d0																;8084
	or.l	d6,d1																;8286
	rts																			;4E75

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
	move.b	d0,d1																;1200
	lsr.b	#$04,d1																;E809
	and.w	#$000F,d1															;0241000F
	move.b	ConvertByteToDecimal_HighNibbleAdjustments(pc,d1.w),d1				;123B10EE
	and.w	#$000F,d0															;0240000F
	move.w	#$0004,ccr															;44FC0004
	abcd	d1,d0																;C101
	clr.b	d1																	;4201
	abcd	d1,d0																;C101
	bra.s	Convert_PackedBCDToASCII											;600A

;fiX Label expected
	move.w	d0,-(sp)															;3F00
	ror.w	#$08,d0																;E058
	bsr.s	Convert_PackedBCDToASCII											;6104
	swap	d1																	;4841
	move.w	(sp)+,d0															;301F
Convert_PackedBCDToASCII:		; Memory Address ($CEEA) and binary offset [$CB66]
	; Converts both nibbles of the packed value into ASCII characters.
	move.b	d0,d1																;1200
	ror.b	#$04,d1																;E819
	bsr.s	Convert_NibbleToASCII												;6104
	rol.w	#$08,d1																;E159
	move.b	d0,d1																;1200
Convert_NibbleToASCII:		; Memory Address ($CEF4) and binary offset [$CB70]
	; Converts a hexadecimal nibble to its ASCII character representation.
	and.b	#$0F,d1																;0201000F
	cmpi.b	#$0A,d1																;0C01000A
	bcs.s	adrCd00CF02															;6504
	add.b	#$07,d1																;06010007
adrCd00CF02:		; Memory Address ($CF02) and binary offset [$CB7E]
	add.b	#$30,d1																;06010030
	rts																			;4E75

adrCd00CF08:		; Memory Address ($CF08) and binary offset [$CB84]
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	$000A(a5),a0														;D0ED000A
	add.w	#$02EC,a0															;D0FC02EC
	move.w	#$000D,adrW_00D92A.l												;33FC000D0000D92A
	move.w	$0010(a5),adrW_00D92C.l												;33ED00100000D92C
	moveq	#$0B,d6																;7C0B
	and.w	#$000F,d0															;0240000F
	bsr		Print_wordstext														;610008B8
	bsr		TerminateText														;610000D6
	move.w	#$00E0,d4															;383C00E0
	moveq	#$12,d5																;7A12
	add.w	$0008(a5),d5														;DA6D0008
	move.l	#$00040000,d3														;263C00040000	;Long Addr replaced with Symbol
	bsr		BW_blit_vertical_line												;61000BBE
	addq.w	#$01,d4																;5244
	bra		BW_blit_vertical_line												;60000BB8

adrCd00CF4E:		; Memory Address ($CF4E) and binary offset [$CBCA]
	or.b	#$10,$0054(a5)														;002D00100054
	move.b	#$FF,$0057(a5)														;1B7C00FF0057
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$0DF4,a0															;D0FC0DF4
	add.w	$000A(a5),a0														;D0ED000A
	clr.w	(a0)																;4250
	clr.w	$1F40(a0)															;42681F40
	clr.w	$3E80(a0)															;42683E80
	clr.w	$5DC0(a0)															;42685DC0
	add.w	#$00F0,a0															;D0FC00F0
	clr.w	(a0)																;4250
	clr.w	$1F40(a0)															;42681F40
	clr.w	$3E80(a0)															;42683E80
	clr.w	$5DC0(a0)															;42685DC0
	sub.w	#$00C8,a0															;90FC00C8
	clr.w	adrW_00D92C.l														;42790000D92C
	moveq	#$0F,d6																;7C0F
	rts																			;4E75

adrCd00CF96:		; Memory Address ($CF96) and binary offset [$CC12]
	move.l	#$007F0060,d4														;283C007F0060
	move.l	#$00060059,d5														;2A3C00060059
	add.w	$0008(a5),d5														;DA6D0008
	moveq	#$00,d3																;7600
	or.b	#$10,$0054(a5)														;002D00100054
	move.b	#$FF,$0057(a5)														;1B7C00FF0057
	bra		BW_draw_bar															;60000AB2

LowerText:
	bsr.s	adrCd00CF4E															;6194
	bra.s	adrLp00CFDA															;601E

adrCd00CFBC:		; Memory Address ($CFBC) and binary offset [$CC38]
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$0BAE,a0															;D0FC0BAE
	add.w	$000A(a5),a0														;D0ED000A
	moveq	#$07,d6																;7C07
	move.l	#$000B0000,adrW_00D92A.l											;23FC000B00000000D92A
	bra.s	adrLp00CFDA															;6002

;fiX Label expected
	bsr.s	adrCd00D018															;613E
adrLp00CFDA:		; Memory Address ($CFDA) and binary offset [$CC56]
	move.b	(a6)+,d0															;101E
	bpl.s	adrCd00CFE6															;6A08
	bsr		Exec_char_extensions												;610000F6
	bcc.s	adrLp00CFDA															;64F6
	bra.s	TerminateText														;6022

adrCd00CFE6:		; Memory Address ($CFE6) and binary offset [$CC62]
	bsr		adrCd00D8C0															;610008D8
	dbra	d6,adrLp00CFDA														;51CEFFEE
	rts																			;4E75

adrCd00CFF0:		; Memory Address ($CFF0) and binary offset [$CC6C]
	bsr.s	adrCd00D018															;6126
	move.w	d7,d0																;3007
	bsr		Print_wordstext														;610007F0
	moveq	#$20,d0																;7020
	bsr		adrCd00D8C0															;610008C4
	subq.w	#$01,d6																;5346
	moveq	#$64,d0																;7064
	add.w	d7,d0																;D047
	bsr		Print_wordstext														;610007E0
TerminateText:		; Memory Address ($D008) and binary offset [$CC84]
	tst.w	d6																	;4A46
	bmi.s	adrCd00D016															;6B0A
adrLp00D00C:		; Memory Address ($D00C) and binary offset [$CC88]
	moveq	#$20,d0																;7020
	bsr		adrCd00D8C0															;610008B0
	dbra	d6,adrLp00D00C														;51CEFFF8
adrCd00D016:		; Memory Address ($D016) and binary offset [$CC92]
	rts																			;4E75

adrCd00D018:		; Memory Address ($D018) and binary offset [$CC94]
	moveq	#$12,d6																;7C12
adrCd00D01A:		; Memory Address ($D01A) and binary offset [$CC96]
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	#$0E25,a0															;D0FC0E25
	add.w	$000A(a5),a0														;D0ED000A
	move.w	#$000D,adrW_00D92A.l												;33FC000D0000D92A
	move.w	$0010(a5),adrW_00D92C.l												;33ED00100000D92C
	rts																			;4E75

WriteMessage:
	move.b	#$81,d2																;143C0081
	bra.s	adrCd00D042															;6002

;fiX Label expected
	dc.w	$7400	;7400

adrCd00D042:		; Memory Address ($D042) and binary offset [$CCBE]
	tst.b	$0005(a4)															;4A2C0005
	bpl.s	WriteFText															;6A48
	movem.l	d2/a6,-(sp)															;48E72002
	bsr.s	WriteFText															;6142
	movem.l	(sp)+,d2/a6															;4CDF4004
	lea		Player1_Data.l,a0													;41F90000EE7C
	btst	#$00,(a5)															;08150000
	bne.s	.continuedcode_001													;6606
	lea		Player2_Data.l,a0													;41F90000EEDE
.continuedcode_001:		; Memory Address ($D064) and binary offset [$CCE0]
	movem.l	a4/a5,-(sp)															;48E7000C
	move.l	a0,a5																;2A48
	move.b	$0001(a4),d0														;102C0001
	jsr		Comms_GetState.w													;4EB841FA	;Short Absolute converted to symbol!
	tst.b	$0005(a4)															;4A2C0005
	bpl.s	adrCd00D07C															;6A04
	move.b	d0,$0000(a4)														;19400000
adrCd00D07C:		; Memory Address ($D07C) and binary offset [$CCF8]
	or.b	#$40,d2																;00020040
	bsr.s	WriteFText															;610E
	movem.l	(sp)+,a4/a5															;4CDF3000
	rts																			;4E75

WriteTimedText:		; Memory Address ($D088) and binary offset [$CD04]
	move.b	#$81,d2																;143C0081
	bra.s	WriteFText															;6002

WriteText:
	moveq	#$00,d2																;7400
WriteFText:		; Memory Address ($D090) and binary offset [$CD0C]
	move.b	d2,$0052(a5)														;1B420052
	bsr.s	InitialiseText														;6104
	bra		adrLp00CFDA															;6000FF42

InitialiseText:		; Memory Address ($D09A) and binary offset [$CD16]
	or.b	#$A0,$0054(a5)														;002D00A00054
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	$000A(a5),a0														;D0ED000A
	add.w	#$0050,a0															;D0FC0050
	move.l	#$000F0000,adrW_00D92A.l											;Sets ordinary dialogue foreground ink to palette index 15; raster interrupts supply its player/monster RGB value.
	clr.w	$004C(a5)															;426D004C
	moveq	#$27,d6																;7C27
	move.w	#$0105,$004A(a5)													;3B7C0105004A
	rts																			;4E75

Print_fflim_text:		; Memory Address ($D0C6) and binary offset [$CD42]
	move.b	(a6)+,d0															;101E
	bpl.s	.continuedcode_002													;6A06
	bsr.s	Exec_char_extensions												;610A
	bcc.s	Print_fflim_text													;64F8
	rts																			;4E75

.continuedcode_002:		; Memory Address ($D0D0) and binary offset [$CD4C]
	bsr		adrCd00D8C0															;610007EE
	bra.s	Print_fflim_text													;60F0

Exec_char_extensions:		; Memory Address ($D0D6) and binary offset [$CD52]
	cmpi.b	#$F0,d0																;0C0000F0
	beq		.Call_F0_Function													;6700004E
	moveq	#$00,d1																;7200
	move.b	(a6)+,d1															;121E
	cmpi.b	#$FE,d0																;0C0000FE
	beq.s	.SetTextColour														;6712
	cmpi.b	#$FD,d0																;0C0000FD
	beq.s	.SetBackgroundTextColour											;6714
	cmpi.b	#$FC,d0																;0C0000FC
	beq.s	.SetXYPosition														;6716
	moveq	#$00,d0																;7000
	subq.w	#$01,d0																;5340
	rts																			;4E75

.SetTextColour:		; Memory Address ($D0FA) and binary offset [$CD76]
	move.w	d1,adrW_00D92A.l													;33C10000D92A
	rts																			;4E75

.SetBackgroundTextColour:		; Memory Address ($D102) and binary offset [$CD7E]
	move.w	d1,adrW_00D92C.l													;33C10000D92C
	rts																			;4E75

.SetXYPosition:		; Memory Address ($D10A) and binary offset [$CD86]
	move.w	d1,d4																;3801
	clr.w	d5																	;4245
	move.b	(a6)+,d5															;1A1E
	asl.w	#$03,d4																;E744
	asl.w	#$03,d5																;E745
	bsr		BW_xy_to_offset														;61000B3E
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	$000A(a5),a0														;D0ED000A
	add.w	d0,a0																;D0C0
	add.w	#$0050,a0															;D0FC0050
.Exit:		; Memory Address ($D128) and binary offset [$CDA4]
	rts																			;4E75

.Call_F0_Function:		; Memory Address ($D12A) and binary offset [$CDA6]
	bsr.s	CopyProtection														;610C
	tst.l	d0																	;4A80
	beq.s	.Exit																;67F8
	lea		Menu_RenderLoop_AI_TBC.w,a0											;41F80C50	;Short Absolute converted to symbol!
	bra		adrCd008DAE															;6000BC78

CopyProtection:
	movem.l	a4-a6,-(sp)															;48E7000E
	bra		adrCd00D1FC															;600000BE
;	move.l	#$8488ffc4,$24.w
;	moveq	#0,d0
;	rts


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
adrEA00D186:		; Memory Address ($D186) and binary offset [$CE02]
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
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
adrEA00D1F0:		; Memory Address ($D1F0) and binary offset [$CE6C]
	ds.b	$8
adrL_00D1F8:		; Memory Address ($D1F8) and binary offset [$CE74]
	dc.l	$FFFFFFFF	;FFFFFFFF

adrCd00D1FC:		; Memory Address ($D1FC) and binary offset [$CE78]
	move.l	a6,-(sp)															;2F0E
	lea		adrEA00D186(pc),a6													;4DFAFF86
	movem.l	d0-d7/a0-a7,(a6)													;48D6FFFF
	lea		$0040(a6),a6														;4DEE0040
	move.l	(sp)+,-$0008(a6)													;2D5FFFF8
	move.l	$00000010.l,d1														;223900000010
; A PC relative Short Absolute outside of the program!
	dc.l	$487A000A
;	pea	$000A.l(pc)	;487A000A	;replaced by dc.l above
	move.l	(sp)+,$00000010.l													;23DF00000010
	illegal																		;4AFC
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

adrEA00D2D2:		; Memory Address ($D2D2) and binary offset [$CF4E]
	movem.l	d0/a0/a1,-(sp)														;48E780C0
	lea		adrEA00D30C(pc),a0													;41FA0034
	move.l	a0,$00000024.l														;23C800000024
	lea		adrEA00D740(pc),a0													;41FA045E
	move.l	a0,$00000020.l														;23C800000020
adrCd00D2EA:		; Memory Address ($D2EA) and binary offset [$CF66]
	add.l	#$00000002,$000E(sp)												;06AF00000002000E
	or.b	#$07,$000C(sp)														;002F0007000C
	bchg	#$07,$000C(sp)														;086F0007000C
	lea		adrEA00D1F0(pc),a1													;43FAFEF0
	beq.s	adrCd00D31E															;671A
	move.l	(a1),a0																;2051
	move.l	$0004(a1),(a0)														;20A90004
	bra.s	adrCd00D332															;6026

adrEA00D30C:		; Memory Address ($D30C) and binary offset [$CF88]
	andi.w	#$F8FF,sr															;027CF8FF
	movem.l	d0/a0/a1,-(sp)														;48E780C0
	lea		adrEA00D1F0(pc),a1													;43FAFEDA
	move.l	(a1),a0																;2051
	move.l	$0004(a1),(a0)														;20A90004
adrCd00D31E:		; Memory Address ($D31E) and binary offset [$CF9A]
	move.l	$000E(sp),a0														;206F000E
adrCd00D322:		; Memory Address ($D322) and binary offset [$CF9E]
	move.l	a0,(a1)																;2288
	move.l	(a0),$0004(a1)														;23500004
	move.l	-$0004(a0),d0														;2028FFFC
	not.l	d0																	;4680
	swap	d0																	;4840
	eor.l	d0,(a0)																;B190
adrCd00D332:		; Memory Address ($D332) and binary offset [$CFAE]
	movem.l	(sp)+,d0/a0/a1														;4CDF0301
	rte																			;4E73

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

adrCd00D51E:		; Memory Address ($D51E) and binary offset [$D19A]
	btst	#$04,_ciab+ciaicr.l													;0839000400BFDD00
	beq.s	adrCd00D51E															;67F6
	move.w	#$8000,$0024(a0)													;317C80000024
	move.w	#$8000,$0024(a0)													;317C80000024
	moveq	#$00,d1																;7200
	move.l	#$00061A80,d2														;243C00061A80
adrCd00D53C:		; Memory Address ($D53C) and binary offset [$D1B8]
	subq.l	#$01,d2																;5382
	beq.s	adrCd00D56A															;672A
	move.b	$001A(a0),d0														;1028001A
	btst	#$04,d0																;08000004
	beq.s	adrCd00D53C															;67F2
	moveq	#$31,d2																;7431
adrLp00D54C:		; Memory Address ($D54C) and binary offset [$D1C8]
	addq.l	#$01,d1																;5281
	move.w	$001A(a0),d0														;3028001A
	bpl.s	adrLp00D54C															;6AF8
	move.b	d0,(a1)+															;12C0
	dbra	d2,adrLp00D54C														;51CAFFF4
	move.w	#$03CD,d2															;343C03CD
adrLp00D55E:		; Memory Address ($D55E) and binary offset [$D1DA]
	addq.l	#$01,d1																;5281
	move.w	$001A(a0),d0														;3028001A
	bpl.s	adrLp00D55E															;6AF8
	dbra	d2,adrLp00D55E														;51CAFFF6
adrCd00D56A:		; Memory Address ($D56A) and binary offset [$D1E6]
	move.w	$001E(a0),d0														;3028001E
	move.w	#$0002,$009C(a0)													;317C0002009C
	move.w	#$4000,$0024(a0)													;317C40000024
	btst	#$01,d0																;08000001
	bne.s	adrCd00D59A															;661A
	moveq	#$00,d1																;7200
	bra.s	adrCd00D59A															;6016

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

adrCd00D59A:		; Memory Address ($D59A) and binary offset [$D216]
	move.l	d1,d0																;2001
	illegal																		;4AFC
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

	rte																			;4E73

adrEA00D740:		; Memory Address ($D740) and binary offset [$D3BC]
	movem.l	(sp)+,a4-a6															;4CDF7000
	sub.l	#$8488FFC4,d0														;04808488FFC4
	rts																			;4E75

Print_com_menu_entry:		; Memory Address ($D74C) and binary offset [$D3C8]
	move.l	#$000D0002,adrW_00D92A.l											;23FC000D00020000D92A
	cmp.b	$0040(a5),d7														;BE2D0040
	bne.s	.continuedcode_005													;6616
	tst.b	$0041(a5)															;4A2D0041
	bne.s	.continuedcode_005													;6610
	move.w	$0010(a5),adrW_00D92C.l												;33ED00100000D92C
	move.w	#$000E,adrW_00D92A.l												;33FC000E0000D92A
.continuedcode_005:		; Memory Address ($D772) and binary offset [$D3EE]
	move.b	(a6)+,d0															;101E
	cmpi.b	#$FA,d0																;0C0000FA
	beq.s	.Print_SkipSomething_TEMP											;6706
	bcc.s	.Print_SkipSomethingElse_TEMP										;640C
	bsr.s	Print_wordstext														;6168
	bra.s	.continuedcode_005													;60F2

.Print_SkipSomething_TEMP:		; Memory Address ($D780) and binary offset [$D3FC]
	move.b	(a6)+,d0															;101E
	bsr		adrCd00D8C0															;6100013C
	bra.s	.continuedcode_005													;60EA

.Print_SkipSomethingElse_TEMP:		; Memory Address ($D788) and binary offset [$D404]
	cmpi.b	#$FF,d0																;0C0000FF
	beq.s	Print_LineEnd														;674C
	cmpi.b	#$FC,d0																;0C0000FC
	bne.s	.continuedcode_005													;66DE
	addq.w	#$01,a0																;5248
	move.b	#$FF,InputStateFlag_AI_TBC.l										;13FC00FF0000EE2D
	move.l	#$000D0002,adrW_00D92A.l											;23FC000D00020000D92A
	cmp.b	$0040(a5),d7														;BE2D0040
	bne.s	.continuedcode_005													;66C4
	tst.b	$0041(a5)															;4A2D0041
	beq.s	.continuedcode_005													;67BE
	move.w	$0010(a5),adrW_00D92C.l												;33ED00100000D92C
	move.w	#$000E,adrW_00D92A.l												;33FC000E0000D92A
	bra.s	.continuedcode_005													;60AC

adrCd00D7C6:		; Memory Address ($D7C6) and binary offset [$D442]
	lea		WordsText.l,a3														;47F90000DC64
Proceed_in_stringtable:		; Memory Address ($D7CC) and binary offset [$D448]
	and.w	#$00FF,d0															;024000FF
	moveq	#$00,d5																;7A00
.continuedcode_006:		; Memory Address ($D7D2) and binary offset [$D44E]
	add.w	d5,a3																;D6C5
	move.b	(a3)+,d5															;1A1B
	dbra	d0,.continuedcode_006												;51C8FFFA
Print_LineEnd:		; Memory Address ($D7DA) and binary offset [$D456]
	rts																			;4E75

Print_item_name:		; Memory Address ($D7DC) and binary offset [$D458]
	lea		Objects_Texts.l,a3													;47F90000E21E
Print_word:		; Memory Address ($D7E2) and binary offset [$D45E]
	bsr.s	Proceed_in_stringtable												;61E8
	bra.s	Print_nchars														;6002

Print_wordstext:		; Memory Address ($D7E6) and binary offset [$D462]
	bsr.s	adrCd00D7C6															;61DE
Print_nchars:		; Memory Address ($D7E8) and binary offset [$D464]
	sub.w	d5,d6																;9C45
	subq.w	#$01,d5																;5345
.continuedcode_007:		; Memory Address ($D7EC) and binary offset [$D468]
	move.b	(a3)+,d0															;101B
	bsr		adrCd00D8C0															;610000D0
	dbra	d5,.continuedcode_007												;51CDFFF8
	rts																			;4E75

InventoryItem_Description:		; Memory Address ($D7F8) and binary offset [$D474]
	bsr		adrCd00D018															;6100F81E
	bra.s	Print_item_desc														;6004

Print_item_desc_fresh:		; Memory Address ($D7FE) and binary offset [$D47A]
	bsr		adrCd00CF4E															;6100F74E
Print_item_desc:		; Memory Address ($D802) and binary offset [$D47E]
	move.b	(a6)+,d0															;101E
	bsr.s	Print_item_name														;61D6
	subq.w	#$01,d6																;5346
	moveq	#$20,d0																;7020
	bsr		adrCd00D8C0															;610000B4
	move.b	(a6),d0																;1016
	bmi.s	.continuedcode_008													;6B02
	bsr.s	Print_item_name														;61C8
.continuedcode_008:		; Memory Address ($D814) and binary offset [$D490]
	tst.w	d6																	;4A46
	bpl		TerminateText														;6A00F7F0
	rts																			;4E75

Print_npc_message:		; Memory Address ($D81C) and binary offset [$D498]
	move.b	#$81,d2																;143C0081
	bra.s	.continuedcode_009													;6002

;fiX Label expected
	dc.w	$7400	;7400

.continuedcode_009:		; Memory Address ($D824) and binary offset [$D4A0]
	tst.b	$0005(a4)															;4A2C0005
	bpl.s	Print_message														;6A48
	movem.l	d2/a6,-(sp)															;48E72002
	bsr.s	Print_message														;6142
	movem.l	(sp)+,d2/a6															;4CDF4004
	lea		Player1_Data.l,a0													;41F90000EE7C
	btst	#$00,(a5)															;08150000
	bne.s	adrCd00D846															;6606
	lea		Player2_Data.l,a0													;41F90000EEDE
adrCd00D846:		; Memory Address ($D846) and binary offset [$D4C2]
	movem.l	a4/a5,-(sp)															;48E7000C
	move.l	a0,a5																;2A48
	move.b	$0001(a4),d0														;102C0001
	jsr		Comms_GetState.w													;4EB841FA	;Short Absolute converted to symbol!
	tst.b	$0005(a4)															;4A2C0005
	bpl.s	adrCd00D85E															;6A04
	move.b	d0,$0000(a4)														;19400000
adrCd00D85E:		; Memory Address ($D85E) and binary offset [$D4DA]
	or.b	#$40,d2																;00020040
	bsr.s	Print_message														;610E
	movem.l	(sp)+,a4/a5															;4CDF3000
	rts																			;4E75

Print_timed_message:		; Memory Address ($D86A) and binary offset [$D4E6]
	move.b	#$81,d2																;143C0081
	bra.s	Print_message														;6002

Print_fix_message:		; Memory Address ($D870) and binary offset [$D4EC]
	moveq	#$00,d2																;7400
Print_message:		; Memory Address ($D872) and binary offset [$D4EE]
	move.b	d2,$0052(a5)														;1B420052
	bsr		InitialiseText														;6100F822
Print_NewLine:		; Memory Address ($D87A) and binary offset [$D4F6]
	move.b	(a6)+,d0															;101E
	cmpi.b	#$FA,d0																;0C0000FA
	bcc.s	adrCd00D894															;6412
	bsr		Print_wordstext														;6100FF62
adrCd00D886:		; Memory Address ($D886) and binary offset [$D502]
	tst.w	d6																	;4A46
	bmi		TerminateText														;6B00F77E
	moveq	#$20,d0																;7020
	bsr.s	adrCd00D8C0															;6130
	subq.w	#$01,d6																;5346
	bra.s	Print_NewLine														;60E6

adrCd00D894:		; Memory Address ($D894) and binary offset [$D510]
	beq.s	adrCd00D8B8															;6722
	cmpi.b	#$FF,d0																;0C0000FF
	beq		TerminateText														;6700F76C
	cmpi.b	#$FB,d0																;0C0000FB
	beq.s	Print_FB_Function													;670E
	cmpi.b	#$FE,d0																;0C0000FE
	bne.s	Print_NewLine														;66D0
	move.b	(a6)+,d0															;101E
	bsr		Print_item_name														;6100FF2E
	bra.s	adrCd00D886															;60D4

Print_FB_Function:		; Memory Address ($D8B2) and binary offset [$D52E]
	addq.w	#$01,d6																;5246
	subq.w	#$01,a0																;5348
	bra.s	Print_NewLine														;60C2

adrCd00D8B8:		; Memory Address ($D8B8) and binary offset [$D534]
	subq.w	#$01,a0																;5348
	move.b	(a6)+,d0															;101E
	bsr.s	adrCd00D8C0															;6102
	bra.s	adrCd00D886															;60C6

adrCd00D8C0:		; Memory Address ($D8C0) and binary offset [$D53C]
	move.l	a0,-(sp)															;2F08
	lea		GameFont.l,a1														;43F900018C7E
	moveq	#$00,d1																;7200
	move.b	d0,d1																;1200
	move.w	d1,d0																;3001
	asl.w	#$02,d0																;E540
	add.w	d1,d0																;D041
	add.w	d0,a1																;D2C0
	moveq	#$04,d0																;7004
adrLp00D8D6:		; Memory Address ($D8D6) and binary offset [$D552]
	move.b	(a1),d1																;1211
	swap	d1																	;4841
	move.b	(a1)+,d1															;1219
	tst.b	InputStateFlag_AI_TBC.l												;4A390000EE2D
	beq.s	adrCd00D8E8															;6704
	add.l	d1,d1																;D281
	add.l	d1,d1																;D281
adrCd00D8E8:		; Memory Address ($D8E8) and binary offset [$D564]
	not.b	d1																	;4601
	swap	d0																	;4840
	move.w	#$0003,d0															;303C0003
	move.w	#$5DC0,d4															;383C5DC0
adrLp00D8F4:		; Memory Address ($D8F4) and binary offset [$D570]
	move.b	d1,d3																;1601
	btst	d0,adrB_00D92D(pc)													;013A0035
	bne.s	adrCd00D8FE															;6602
	clr.b	d3																	;4203
adrCd00D8FE:		; Memory Address ($D8FE) and binary offset [$D57A]
	swap	d1																	;4841
	move.b	d1,d2																;1401
	swap	d1																	;4841
	btst	d0,adrB_00D92B(pc)													;013A0025
	bne.s	adrCd00D90C															;6602
	clr.b	d2																	;4202
adrCd00D90C:		; Memory Address ($D90C) and binary offset [$D588]
	or.b	d3,d2																;8403
	move.b	d2,$00(a0,d4.w)														;11824000
	sub.w	#$1F40,d4															;04441F40
	dbra	d0,adrLp00D8F4														;51C8FFDC
	swap	d0																	;4840
	add.w	#$0028,a0															;D0FC0028
	dbra	d0,adrLp00D8D6														;51C8FFB4
	move.l	(sp)+,a0															;205F
	addq.w	#$01,a0																;5248
	rts																			;4E75

adrW_00D92A:		; Memory Address ($D92A) and binary offset [$D5A6]
	ds.b	$1
adrB_00D92B:		; Memory Address ($D92B) and binary offset [$D5A7]
	dc.b	$01	;01
adrW_00D92C:		; Memory Address ($D92C) and binary offset [$D5A8]
	ds.b	$1
adrB_00D92D:		; Memory Address ($D92D) and binary offset [$D5A9]
	ds.b	$1
Draw_woundflash_digit:		; Memory Address ($D92E) and binary offset [$D5AA]
	move.w	#$000F,adrW_00D92C.l												;33FC000F0000D92C
	movem.l	d4/d5,-(sp)															;48E70C00
	lea		Data_Woundflash.l,a0												;41F90000D988
	move.l	a0,a1																;2248
	moveq	#$09,d2																;7409
	moveq	#-$01,d1															;72FF
.continuedcode_011:		; Memory Address ($D946) and binary offset [$D5C2]
	move.l	d1,(a1)+															;22C1
	dbra	d2,.continuedcode_011												;51CAFFFC
	move.b	#$FF,InputStateFlag_AI_TBC.l										;13FC00FF0000EE2D
	bsr		BW_Blitchar															;6100005A
	clr.b	InputStateFlag_AI_TBC.l												;42390000EE2D
	movem.l	(sp)+,d4/d5															;4CDF0030
	move.l	a0,a1																;2248
	move.w	d4,d1																;3204
	and.w	#$FFF7,d4															;0244FFF7
	bsr		BW_xy_to_offset														;610002E8
	move.w	d1,d4																;3801
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	d0,a0																;D0C0
	lea		adrEA00ABF6.l,a6													;4DF90000ABF6
	moveq	#$04,d7																;7E04
	swap	d7																	;4847
	moveq	#$00,d6																;7C00
	bra		Draw_MonsterStrip_Shifted											;6000D40A

Data_Woundflash:		; Memory Address ($D988) and binary offset [$D604]
	ds.b	$28
BW_Blitchar:
	lea		GameFont.l,a1														;43F900018C7E	;
	move.l	a0,-(sp)															;2F08
	and.w	#$007F,d0															;0240007F
	move.w	d0,d2																;3400
	asl.w	#$02,d0																;E540
	add.w	d2,d0																;D042
	add.w	d0,a1																;D2C0
	move.l	adrW_00D92A.l,d2													;24390000D92A
	lea		BW_blitchar_data.l,a2												;45F90000DA18
	asl.w	#$02,d2																;E542
	move.l	$00(a2,d2.w),d3														;26322000
	swap	d2																	;4842
	asl.w	#$02,d2																;E542
	move.l	$00(a2,d2.w),d2														;24322000
	moveq	#$04,d1																;7204
.loop:
	move.b	(a1),d0																;1011
	asl.w	#$08,d0																;E140
	move.b	(a1)+,d0															;1019
	add.w	d0,d0																;D040
	add.w	d0,d0																;D040
	move.w	d0,d4																;3800
	swap	d0																	;4840
	move.w	d4,d0																;3004
	move.l	d0,d4																;2800
	not.l	d0																	;4680
	and.l	d3,d0																;C083
	and.l	d2,d4																;C882
	or.l	d4,d0																;8084
	move.b	d0,$0006(a0)														;11400006
	swap	d0																	;4840
	move.b	d0,$0002(a0)														;11400002
	lsr.l	#$08,d0																;E088
	move.b	d0,(a0)																;1080
	swap	d0																	;4840
	move.b	d0,$0004(a0)														;11400004
	addq.w	#$08,a0																;5048
	dbra	d1,.loop															;51C9FFCE
	move.l	(sp)+,a0															;205F
	rts																			;4E75

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
	swap	d4																	;4844	;
	swap	d3																	;4843
	move.w	d4,d3																;3604
	swap	d4																	;4844
	swap	d3																	;4843
	swap	d5																	;4845
	move.w	d5,d7																;3E05
	swap	d5																	;4845
.drawbar_loop:
	bsr		BW_blit_horiz_line													;6100010A
	addq.w	#$01,d5																;5245
	dbra	d7,.drawbar_loop													;51CFFFF8
	rts																			;4E75

BW_cs_draw_frame:
	addq.w	#$01,d4																;5244	;
	swap	d4																	;4844
	swap	d3																	;4843
	move.w	d4,d3																;3604
	subq.w	#$02,d3																;5543
	swap	d4																	;4844
	swap	d3																	;4843
	bsr		BW_blit_horiz_line													;610000F0
	swap	d5																	;4845
	move.w	d5,d7																;3E05
	swap	d5																	;4845
	add.w	d7,d5																;DA47
	bsr		BW_blit_horiz_line													;610000E4
	sub.w	d7,d5																;9A47
	subq.w	#$01,d4																;5344
	addq.w	#$01,d5																;5245
	swap	d5																	;4845
	swap	d3																	;4843
	move.w	d5,d3																;3605
	subq.w	#$02,d3																;5543
	swap	d3																	;4843
	swap	d5																	;4845
	bsr		BW_blit_vertical_line												;6100004E
	swap	d4																	;4844
	move.w	d4,d7																;3E04
	swap	d4																	;4844
	add.w	d7,d4																;D847
	bra		BW_blit_vertical_line												;60000042

;fiX Label expected
	swap	d3																	;4843
	swap	d4																	;4844
	swap	d5																	;4845
	move.w	d3,d4																;3803
	move.w	d3,d5																;3A03
	swap	d3																	;4843
	swap	d4																	;4844
	swap	d5																	;4845
BW_draw_frame:
	swap	d4																	;4844	;
	swap	d3																	;4843
	move.w	d4,d3																;3604
	swap	d4																	;4844
	swap	d3																	;4843
	bsr		BW_blit_horiz_line													;610000A4
	swap	d5																	;4845
	move.w	d5,d7																;3E05
	swap	d5																	;4845
	add.w	d7,d5																;DA47
	bsr		BW_blit_horiz_line													;61000098
	sub.w	d7,d5																;9A47
	swap	d5																	;4845
	swap	d3																	;4843
	move.w	d5,d3																;3605
	swap	d5																	;4845
	swap	d3																	;4843
	bsr.s	BW_blit_vertical_line												;6108
	swap	d4																	;4844
	move.w	d4,d7																;3E04
	swap	d4																	;4844
	add.w	d7,d4																;D847
BW_blit_vertical_line:
	bsr		BW_xy_to_offset														;6100014E	;
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	d0,a0																;D0C0
	moveq	#$00,d0																;7000
	moveq	#$00,d1																;7200
	move.b	d3,d1																;1203
	lsr.b	#$01,d1																;E209
	roxr.b	#$01,d0																;E210
	ror.w	#$01,d1																;E259
	swap	d0																	;4840
	lsr.b	#$01,d1																;E209
	roxr.b	#$01,d0																;E210
	lsr.b	#$01,d1																;E209
	swap	d1																	;4841
	roxr.w	#$01,d1																;E251
	or.l	d1,d0																;8081
	swap	d0																	;4840
	move.b	#$7F,d1																;123C007F
	move.w	d4,d7																;3E04
	and.w	#$0007,d7															;02470007
	ror.b	d7,d1																;EE39
	ror.l	d7,d0																;EEB8
	move.l	d3,d2																;2403
	swap	d2																	;4842
.vertical_loop:
	move.b	(a0),d7																;1E10
	and.b	d1,d7																;CE01
	or.b	d0,d7																;8E00
	move.b	d7,(a0)																;1087
	swap	d0																	;4840
	move.b	$3E80(a0),d7														;1E283E80
	and.b	d1,d7																;CE01
	or.b	d0,d7																;8E00
	move.b	d7,$3E80(a0)														;11473E80
	ror.l	#$08,d0																;E098
	move.b	$5DC0(a0),d7														;1E285DC0
	and.b	d1,d7																;CE01
	or.b	d0,d7																;8E00
	move.b	d7,$5DC0(a0)														;11475DC0
	swap	d0																	;4840
	move.b	$1F40(a0),d7														;1E281F40
	and.b	d1,d7																;CE01
	or.b	d0,d7																;8E00
	move.b	d7,$1F40(a0)														;11471F40
	rol.l	#$08,d0																;E198
	add.w	#$0028,a0															;D0FC0028
	dbra	d2,.vertical_loop													;51CAFFC6
	rts																			;4E75

hline_data:
	dc.w	$0000	;0000
	dc.w	$00FF	;00FF
	dc.w	$FF00	;FF00
	dc.w	$FFFF	;FFFF

BW_blit_horiz_line:
	movem.l	d3-d5,-(sp)															;48E71C00	;
	bsr		BW_xy_to_offset														;610000CA
	move.l	screen_ptr.l,a0														;207900008D36
	add.w	d0,a0																;D0C0
	lea		hline_data.l,a1														;43F90000DB7C
	move.w	d3,d0																;3003
	and.w	#$000C,d0															;0240000C
	lsr.w	#$01,d0																;E248
	move.w	$00(a1,d0.w),d0														;30310000
	swap	d0																	;4840
	add.w	d3,d3																;D643
	and.w	#$0006,d3															;02430006
	move.w	$00(a1,d3.w),d0														;30313000
	swap	d3																	;4843
	addq.w	#$01,d3																;5243
	move.w	d4,d2																;3404
	and.w	#$0007,d2															;02420007
	beq.s	adrCd00DC14															;6756
	subq.w	#$08,d2																;5142
	neg.w	d2																	;4442
	cmp.w	d2,d3																;B642
	bgt.s	adrCd00DBFE															;6E38
	moveq	#-$01,d2															;74FF
	and.w	#$0007,d4															;02440007
	lsr.b	d3,d2																;E62A
	not.b	d2																	;4602
	lsr.b	d4,d2																;E82A
	move.b	d2,d3																;1602
	not.b	d3																	;4603
	bsr		adrCd00DBDC															;61000004
	bra.s	adrCd00DC4E															;6072

adrCd00DBDC:		; Memory Address ($DBDC) and binary offset [$D858]
	move.l	d0,d6																;2C00
	moveq	#$03,d5																;7A03
	moveq	#$00,d4																;7800
.horiz_loop:
	move.b	$00(a0,d4.w),d1														;12304000
	and.b	d2,d0																;C002
	and.b	d3,d1																;C203
	or.b	d0,d1																;8200
	move.b	d1,$00(a0,d4.w)														;11814000
	ror.l	#$08,d0																;E098
	add.w	#$1F40,d4															;06441F40
	dbra	d5,.horiz_loop														;51CDFFEA
	move.l	d6,d0																;2006
	rts																			;4E75

adrCd00DBFE:		; Memory Address ($DBFE) and binary offset [$D87A]
	sub.w	d2,d3																;9642
	swap	d3																	;4843
	and.w	#$0007,d4															;02440007
	moveq	#-$01,d2															;74FF
	lsr.b	d4,d2																;E82A
	move.b	d2,d3																;1602
	not.b	d3																	;4603
	bsr.s	adrCd00DBDC															;61CC
	swap	d3																	;4843
	addq.w	#$01,a0																;5248
adrCd00DC14:		; Memory Address ($DC14) and binary offset [$D890]
	move.w	d3,d4																;3803
	lsr.w	#$03,d3																;E64B
	beq.s	adrCd00DC3E															;6724
	subq.w	#$01,d3																;5343
	move.l	a0,a1																;2248
	moveq	#$00,d2																;7400
	moveq	#$03,d5																;7A03
adrLp00DC22:		; Memory Address ($DC22) and binary offset [$D89E]
	move.l	a1,a0																;2049
	add.w	d2,a0																;D0C2
	move.w	d3,d1																;3203
adrLp00DC28:		; Memory Address ($DC28) and binary offset [$D8A4]
	move.b	d0,(a0)+															;10C0
	dbra	d1,adrLp00DC28														;51C9FFFC
	ror.l	#$08,d0																;E098
	add.w	#$1F40,d2															;06421F40
	dbra	d5,adrLp00DC22														;51CDFFEC
	sub.w	#$1F40,d2															;04421F40
	sub.w	d2,a0																;90C2
adrCd00DC3E:		; Memory Address ($DC3E) and binary offset [$D8BA]
	and.w	#$0007,d4															;02440007
	beq.s	adrCd00DC4E															;670A
	moveq	#-$01,d3															;76FF
	lsr.b	d4,d3																;E82B
	move.b	d3,d2																;1403
	not.b	d2																	;4602
	bsr.s	adrCd00DBDC															;618E
adrCd00DC4E:		; Memory Address ($DC4E) and binary offset [$D8CA]
	movem.l	(sp)+,d3-d5															;4CDF0038
	rts																			;4E75

BW_xy_to_offset:
	move.w	d5,d0																;3005	;
	add.w	d0,d0																;D040
	add.w	d0,d0																;D040
	add.w	d5,d0																;D045
	asl.w	#$06,d0																;ED40
	add.w	d4,d0																;D044
	lsr.w	#$03,d0																;E648
	rts																			;4E75

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
Objects_Texts:		; Memory Address ($E21E) and binary offset [$DE9A]
	INCBIN "/data/BLOODWYCH439-clean/data/objecttext.block"
Notice_SelectChampions:
	dc.b	'PLEASE SELECT YOUR CHAMPIONS...'	;504C454153452053454C45435420594F5552204348414D50494F4E532E2E2E
	dc.b	$FF	;FF
Notice_SelectChampion:
	dc.b	'PLAYER 0 SELECT THY CHAMPION....'	;504C4159455220302053454C45435420544859204348414D50494F4E2E2E2E2E
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
adrEA00E998:		; Memory Address ($E998) and binary offset [$E614]
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
BeginGameScroll:		; Memory Address ($E9A8) and binary offset [$E624]
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
ChampionStatsScroll_FoodTextTemplate:		; Memory Address ($E9E8) and binary offset [$E664]
	; Print_fflim_text stream for FOOD. Uses ink $D for the heading and ink $4 for
	; raw GameFont glyphs $02/$03 surrounding six bar cells.
	INCBIN "/data/BLOODWYCH439-clean/data/champion-stats-scroll-food.text"
adrEA00EA00:		; Memory Address ($EA00) and binary offset [$E67C]
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
adrEA00EA14:		; Memory Address ($EA14) and binary offset [$E690]
	dc.b	$FC	;FC
	dc.b	$1D	;1D
	dc.b	$03	;03
	dc.b	$FE	;FE
	dc.b	$0D	;0D
	dc.b	$FD	;FD
	dc.b	$03	;03
	dc.b	'INVENTORY'	;494E56454E544F5259
	dc.b	$FF	;FF
adrEA00EA25:		; Memory Address ($EA25) and binary offset [$E6A1]
	dc.b	$FC	;FC
	dc.b	$1D	;1D
	dc.b	$08	;08
	dc.b	'ARMOUR:'	;41524D4F55523A
	dc.b	$FE	;FE
	dc.b	$0E	;0E
	dc.b	'   '	;202020
	dc.b	$FF	;FF
	dc.b	$00	;00
adrEA00EA36:		; Memory Address ($EA36) and binary offset [$E6B2]
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
adrEA00EA4C:		; Memory Address ($EA4C) and binary offset [$E6C8]
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
Msg_CostTooHigh:		; Memory Address ($EA62) and binary offset [$E6DE]
	dc.b	$FE	;FE
	dc.b	$0C	;0C
	dc.b	'COST TOO HIGH'	;434F535420544F4F2048494748
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
	; Sixteen 32-byte champion-stat records.
	INCBIN "/data/BLOODWYCH439-clean/data/champions.stats"
Character_Pockets_DataTable:		; Memory Address ($ED2A) and binary offset [$E9A6]
	INCBIN "/data/BLOODWYCH439-clean/data/champions.pockets"
adrW_00EE2A:		; Memory Address ($EE2A) and binary offset [$EAA6]
	ds.b	$2
adrB_00EE2C:		; Memory Address ($EE2C) and binary offset [$EAA8]
	ds.b	$1
InputStateFlag_AI_TBC:		; Memory Address ($EE2D) and binary offset [$EAA9]
	ds.b	$1
CurrentTower:
	ds.b	$2
MultiPlayer:
	dc.w	$FFFF	;FFFF
RingUses:		; Memory Address ($EE32) and binary offset [$EAAE]
	dc.w	$0102	;0102
	dc.w	$0303	;0303
adrEA00EE36:		; Memory Address ($EE36) and binary offset [$EAB2]
	ds.b	$2
adrW_00EE38:		; Memory Address ($EE38) and binary offset [$EAB4]
	ds.b	$4
adrB_00EE3C:		; Memory Address ($EE3C) and binary offset [$EAB8]
	ds.b	$1
adrB_00EE3D:		; Memory Address ($EE3D) and binary offset [$EAB9]
	dc.b	$01	;01
adrB_00EE3E:		; Memory Address ($EE3E) and binary offset [$EABA]
	ds.b	$1
adrB_00EE3F:		; Memory Address ($EE3F) and binary offset [$EABB]
	ds.b	$1
Current_TowerMapHeaderCache:		; Memory Address ($EE40) and binary offset [$EABC]
	ds.b	$10
adrEA00EE50:		; Memory Address ($EE50) and binary offset [$EACC]
	ds.b	$10
adrEA00EE60:		; Memory Address ($EE60) and binary offset [$EADC]
	ds.b	$10
adrW_00EE70:		; Memory Address ($EE70) and binary offset [$EAEC]
	ds.b	$1
adrB_00EE71:		; Memory Address ($EE71) and binary offset [$EAED]
	ds.b	$1
adrW_00EE72:		; Memory Address ($EE72) and binary offset [$EAEE]
	ds.b	$1
adrB_00EE73:		; Memory Address ($EE73) and binary offset [$EAEF]
	ds.b	$3
adrW_00EE76:		; Memory Address ($EE76) and binary offset [$EAF2]
	ds.b	$2
Current_TowerMapDataBase:		; Memory Address ($EE78) and binary offset [$EAF4]
	dc.l	$0000EF78	;0000EF78	;Long Addr replaced with Symbol *Fix stored address **
Player1_Data:
	ds.b	$1
adrB_00EE7D:		; Memory Address ($EE7D) and binary offset [$EAF9]
	ds.b	$1
adrL_00EE7E:		; Memory Address ($EE7E) and binary offset [$EAFA]
	ds.b	$4
adrW_00EE82:		; Memory Address ($EE82) and binary offset [$EAFE]
	ds.b	$1
adrB_00EE83:		; Memory Address ($EE83) and binary offset [$EAFF]
	ds.b	$1
adrW_00EE84:		; Memory Address ($EE84) and binary offset [$EB00]
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
adrL_00EE98:		; Memory Address ($EE98) and binary offset [$EB14]
	ds.b	$6
adrW_00EE9E:		; Memory Address ($EE9E) and binary offset [$EB1A]
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
adrB_00EEB1:		; Memory Address ($EEB1) and binary offset [$EB2D]
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
adrW_00EEB6:		; Memory Address ($EEB6) and binary offset [$EB32]
	dc.w	$0000	;0000
	dc.w	$00FF	;00FF
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
	dc.w	$0000	;0000
adrW_00EEC6:		; Memory Address ($EEC6) and binary offset [$EB42]
	ds.b	$2
adrW_00EEC8:		; Memory Address ($EEC8) and binary offset [$EB44]
	ds.b	$6
adrB_00EECE:		; Memory Address ($EECE) and binary offset [$EB4A]
	dc.b	$00	;00
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
Player1_PendingAction:		; Memory Address ($F256) and binary offset [$EED2]
	; Pending action byte for player 1; keyboard and external overlays can write
	; here before the player loop consumes it.
	ds.b	$3
adrB_00EED5:		; Memory Address ($EED5) and binary offset [$EB51]
	ds.b	$1
adrL_00EED6:		; Memory Address ($EED6) and binary offset [$EB52]
	dc.l	$FFFFFFFF	;FFFFFFFF
	dc.l	$FFFFFFFF	;FFFFFFFF
Player2_Data:
	dc.b	$01	;01
adrB_00EEDF:		; Memory Address ($EEDF) and binary offset [$EB5B]
	ds.b	$1
adrL_00EEE0:		; Memory Address ($EEE0) and binary offset [$EB5C]
	ds.b	$4
adrW_00EEE4:		; Memory Address ($EEE4) and binary offset [$EB60]
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
adrW_00EEF2:		; Memory Address ($EEF2) and binary offset [$EB6E]
	dc.w	$0000	;0000
	dc.w	$FFFF	;FFFF
Player2_ChampionPointer:		; Memory Address ($EEF6) and binary offset [$EB72]
	dc.l	$FFFFFFFF	;FFFFFFFF
adrL_00EEFA:		; Memory Address ($EEFA) and binary offset [$EB76]
	ds.b	$6
adrW_00EF00:		; Memory Address ($EF00) and binary offset [$EB7C]
	ds.b	$4
adrL_00EF04:		; Memory Address ($EF04) and binary offset [$EB80]
	dc.l	$FFFFFFFF	;FFFFFFFF
	dc.l	$00000000	;00000000
	dc.l	$0000FFFF	;0000FFFF	;Long Addr replaced with Symbol
	dc.w	$FFFF	;FFFF
	dc.b	$FF	;FF
adrB_00EF13:		; Memory Address ($EF13) and binary offset [$EB8F]
	dc.b	$FF	;FF
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
	dc.b	$00	;00
adrW_00EF18:		; Memory Address ($EF18) and binary offset [$EB94]
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
adrB_00EF37:		; Memory Address ($EF37) and binary offset [$EBB3]
	ds.b	$1
adrL_00EF38:		; Memory Address ($EF38) and binary offset [$EBB4]
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
adrEA01674C:		; Memory Address ($1674C) and binary offset [$163C8]
	ds.b	$80
adrEA0167CC:		; Memory Address ($167CC) and binary offset [$16448]
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
adrEA01737E:		; Memory Address ($1737E) and binary offset [$16FFA]
	ds.b	$10
MonsterTeamGroupCount:		; Memory Address ($1738E) and binary offset [$1700A]
	; Count of populated team groups in MonsterTeamIndexTable.
	dc.w	$FFFF	;FFFF
MonsterTeamIndexTable:		; Memory Address ($17390) and binary offset [$1700C]
	; Twenty-five four-byte team groups; $FF marks an empty member slot.
	ds.b	$64
adrW_0173F4:		; Memory Address ($173F4) and binary offset [$17070]
	ds.b	$2
adrEA0173F6:		; Memory Address ($173F6) and binary offset [$17072]
	ds.b	$102
adrEA0174F8:		; Memory Address ($174F8) and binary offset [$17174]
	ds.b	$80
MonsterTotalsCounts_mod0:		; Memory Address ($17578) and binary offset [$171F4]
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
	dc.b	'mar'	;6D6172
	dc.b	'yhadalittlelaaneeitwerraguddutnerewanzednowtecozzitwerawuddunwhyamistillhavintotypethiscrapwhithoughtidfinishacoupleoflinesq'	;79686164616C6974746C656C61616E6565697477657272616775646475746E65726577616E7A65646E6F777465636F7A7A6974776572617775646
*56E776879616D697374696C6C686176696E746F74797065746869736372617077686974686F75676874696466696E69736861636F75706C656F666C696E657371
	dc.b	'x'	;78
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
	; Provides the horizontal screen position for every view-cell and sub-position
	; combination.
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
	dc.b	'MINDROCK'	;4D494E44524F434B
SpellDescriptions:		; Memory Address ($19F8F) and binary offset [$19C0B]
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
