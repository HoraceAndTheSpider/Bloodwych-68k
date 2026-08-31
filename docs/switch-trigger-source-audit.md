# Switch and trigger source audit — 31 August 2026

## Scope and evidence

This audit traces the SPS 439 switch and trigger dispatch paths from original `asm/BLOODWYCH439.asm`. It covers 430 normal instructions in 74 labelled blocks: wall-switch selection/shared actions, player floor-feature dispatch, all trigger selection/sound logic, tower entrances, teleports, ordinary bit-changing handlers, and both Vivify paths. It does not annotate lookup/data declarations, ending-screen presentation below `Trigger_29_t3A_GameCompletion`, or the monster pack/unpack helper called during tower travel.

Every covered instruction's opcode bytes were compared with `binaries/BLOODWYCH439` using the source load delta `$384`. Both displacement tables were decoded as signed big-endian words from the binary; each result lands on the exact original target label shown below. Original-label existence and every existing `segments.xlsx` mapping were checked before producing the protected-sheet handoff. `_archive/AMOS code/BloodwychEditor2-7_026.txt` independently confirms the record fields as `SWITCHTYPE/X/Y` and `TRIGGERTYPE/F/X/Y`, while the game source determines how each action actually interprets those bytes.

`segments.xlsx` and the three ASM files remain untouched. `cleanup.xlsx` receives verified scoped EQU and instruction-comment rules only. No relabel, inspect, format, patch or assembler operation was run.

## Confirmed dispatch

- Wall first-byte bits 3–7 select `tower * 64 + reference * 4`. Reference zero returns before the light toggle and sound. The action byte is already the even byte offset `$00-$0E` into eight word displacements.
- Floor-feature first-byte bits 3–7 select `tower * 128 + reference * 4`. The record action is likewise the even byte offset `$00-$3C` into 31 word displacements.
- `adrEA006FA8` is a signed sound ID. Visible pads default to 0, invisible pads to negative/no sound; `$08/$0A/$2A` default to 5; metal-door handlers override with 1. Internal Vivify plays 5 itself, then suppresses a second play.
- Teleports rewrite D0/D7 in the dispatcher's saved stack frame so destination processing keeps the new cell/X/Y. `$2A` tries an east fallback and queues flash `$10`; `$32` tries north and does not flash. Both check only destination bit 7.
- `$20` uses BB as one of eight movement-vector indexes from the triggering cell; CC/DD is used only when the neighbour is outside the active floor. `$22` moves a pillar northwest→north relative to the trigger. `$38` XORs the floor subtype with 3. `$3C` removes CC/DD only if first-byte bit 0 is present at both fixed cell-data offsets `$14` and `$1C`.
- External Vivify consumes ground remains `$40-$4F` and can rejoin/relocate a champion or party. Internal Vivify scans party slots directly, clears eligible dead flags, and writes five to current HP and vitality.

## Metadata results

The cleanup edit adds 38 verified scoped EQU rules and adds/updates 412 COMMENTS rules. Repeated instructions within one scope share a single count-checked rule. Together these cover all 430 traced instructions; no `dc.*`, `ds.*` or `INCBIN` declaration receives an instruction comment. The formatter now recognises only its two exact legacy generated suffixes after opcode bytes (`Short Absolute converted to symbol!` and `Long Addr replaced with Symbol`), so these do not block a human instruction comment; genuine handwritten comments and all declarations stay protected.

The full protected-profile proposal is `docs/switch-trigger-label-proposals.tsv`. It has exactly the required eleven columns. The original→current→proposed chain for every row follows, so blank and misleading current mappings are explicit rather than silently replaced.

## Protected-sheet label chain

- Row 1092: `adrJA005B2A` → `MainWall_Action_03_Switches` → `MainWall_Action_03_Switches` (existing mapping; comment update only).
- Row 1093: `adrJB005B66` → `Switch_00_s00_Null` → `Switch_00_s00_Null` (existing mapping; comment update only).
- Row 1094: `adrJT005B68` → `Switches_LookupTable` → `Switches_LookupTable` (existing mapping; comment update only).
- Row 1095: `adrJA005CF8` → `Switch_00_s00_Trigger_15_t1E_ToggleWallXY` → `Trigger_15_t1E_CreateWall_XY` (replace existing mapping).
- Row 1096: `adrJA005CFC` → `Switch_02_s04_Trigger_23_t2E` → `Switch_02_s04_Trigger_23_t2E_ToggleWall_XY` (replace existing mapping).
- Row 1097: `adrCd005D10` → `(unlabelled)` → `Return_WallToggle` (populate existing blank relabel).
- Row 1098: `adrJA005D12` → `Switch_01_s02_Trigger_11_t16_RemoveXY` → `Switch_01_s02_Trigger_11_t16_RemoveXY` (existing mapping; comment update only).
- Row 1099: `adrCd005D26` → `(unlabelled)` → `Clear_TargetMapCellType` (populate existing blank relabel).
- Row 1100: `adrCd005D2E` → `(unlabelled)` → `Resolve_ActionTargetXY` (populate existing blank relabel).
- Row 1300: `adrCd006E90` → `Process_PlayerMoveStairOrTeamPad` → `Process_PlayerMoveFloorFeature` (replace existing mapping).
- Row 1301: `adrCd006EA0` → `Reset_PlayerMoveTriggerWait` → `Dispatch_PlayerMoveTriggerPad` (replace existing mapping).
- Row 1312: `adrCd006F80` → `TeamAvatar_LoopStart_AI_TBC` → `Clear_PartyWornSpells` (replace existing mapping).
- Row 1313: `adrLp006F86` → `TeamAvatar_LoopBody_AI_TBC` → `Clear_PartyWornSpells_NextSlot` (replace existing mapping).
- Row 1314: `adrCd006F9A` → `TeamAvatar_LoopEnd_AI_TBC` → `Clear_PartyWornSpells_Continue` (replace existing mapping).
- Row 1315: `adrEA006FA8` → `Trigger_WaitFlag_AI_TBC` → `TriggerSound_ID` (replace existing mapping).
- Row 1316: `adrCd006FAA` → `Reset_TriggerWait_AI_TBC` → `Execute_FloorTrigger` (replace existing mapping).
- Row 1317: `adrCd006FC0` → `TriggerWait_PostCheck_AI_TBC` → `Resolve_FloorTriggerRecord` (replace existing mapping).
- Row 1318: `adrCd006FF2` → `Setup_TriggerEffectDefault_AI_TBC` → `Select_TriggerSpellSound` (replace existing mapping).
- Row 1319: `adrCd006FF8` → `TriggerEffect_Actual_AI_TBC` → `Dispatch_TriggerAndPlaySound` (replace existing mapping).
- Row 1320: `adrCd007012` → `TriggerEffect_Post_AI_TBC` → `Restore_TriggerMovementState` (replace existing mapping).
- Row 1321: `adrJB007016` → `Trigger_00_t00_Null` → `Trigger_00_t00_Null` (existing mapping; comment update only).
- Row 1322: `adrJT007018` → `Triggers_LookupTable` → `Triggers_LookupTable` (existing mapping; comment update only).
- Row 1323: `adrJA007356` → `Trigger_20_t28_Keep_Entrance_CentrePad` → `Trigger_20_t28_Keep_Entrance_CentrePad` (existing mapping; comment update only).
- Row 1324: `adrJA007386` → `Trigger_19_t26_Keep_Entrance_SidePad` → `Trigger_19_t26_Keep_Entrance_SidePad` (existing mapping; comment update only).
- Row 1325: `adrCd0073A2` → `(unlabelled)` → `Return_KeepEntrancePartnerMissing` (populate existing blank relabel).
- Row 1326: `adrCd0073A6` → `(unlabelled)` → `Prepare_KeepEntranceArrivalPair` (populate existing blank relabel).
- Row 1327: `adrJA0073E6` → `Trigger_10_t14_Tower_Entrance_CentrePad` → `Trigger_10_t14_Tower_Entrance_CentrePad` (existing mapping; comment update only).
- Row 1328: `adrCd007408` → `(unlabelled)` → `Enter_TowerAtArrivalMidpoint` (populate existing blank relabel).
- Row 1329: `adrJA007454` → `Trigger_09_t12_Tower_Entrance_SidePad` → `Trigger_09_t12_Tower_Entrance_SidePad` (existing mapping; comment update only).
- Row 1330: `adrCd00746E` → `(unlabelled)` → `Discard_TowerEntranceRecord` (populate existing blank relabel).
- Row 1331: `adrCd007470` → `(unlabelled)` → `Return_TowerEntrance` (populate existing blank relabel).
- Row 1332: `adrCd007472` → `(unlabelled)` → `Prepare_TowerEntranceArrivalPair` (populate existing blank relabel).
- Row 1333: `adrCd00748C` → `(unlabelled)` → `Enter_TowerAtPairedArrivals` (populate existing blank relabel).
- Row 1334: `adrJA007502` → `(unlabelled)` → `Trigger_30_t3C_RemoveXY_IfPuzzleBitsSet` (populate existing blank relabel).
- Row 1335: `adrJA00751A` → `Trigger_28_t38_GameCompletion` → `Trigger_29_t3A_GameCompletion` (replace existing mapping).
- Row 1342: `adrJA007630` → `Trigger_27_t36_Rotate_WoodWall_CounterClockwise` → `Trigger_28_t38_ToggleFloorSubtype_XY` (replace existing mapping).
- Row 1343: `adrJA00763C` → `Trigger_24_t30_Spinner3` → `Trigger_25_t32_Teleport_FXY` (replace existing mapping).
- Row 1344: `adrCd007660` → `(unlabelled)` → `Commit_TeleportWithoutFlash` (populate existing blank relabel).
- Row 1345: `adrCd007664` → `(unlabelled)` → `Commit_TriggerTeleport` (populate existing blank relabel).
- Row 1346: `adrJA007686` → `Trigger_21_t2A_Flash_Telepoprt_FXY` → `Trigger_21_t2A_Flash_Teleport_FXY` (replace existing mapping).
- Row 1347: `adrCd0076AC` → `(unlabelled)` → `Commit_TeleportAndQueueFlash` (populate existing blank relabel).
- Row 1348: `adrJA0076B4` → `Switch_04_s08_Trigger_22_t2C_RotateWall_XY` → `Switch_04_s08_Trigger_22_t2C_RotateWall_XY` (existing mapping; comment update only).
- Row 1349: `adrJA0076D2` → `Trigger_06_t0C_WoodTrap1` → `Trigger_06_t0C_WoodTrap1` (existing mapping; comment update only).
- Row 1350: `adrJA0076EA` → `Trigger_07_t0E_WoodTrap2` → `Trigger_07_t0E_WoodTrap2` (existing mapping; comment update only).
- Row 1351: `adrJA007702` → `Trigger_08_t10_Trader_DoorCloser` → `Trigger_08_t10_Trader_DoorCloser` (existing mapping; comment update only).
- Row 1352: `adrCd007710` → `(unlabelled)` → `Return_TraderDoorCloser` (populate existing blank relabel).
- Row 1353: `adrJA007712` → `Trigger_01_t02_Spinner180` → `Trigger_01_t02_Spinner180` (existing mapping; comment update only).
- Row 1354: `adrJA00771A` → `Trigger_02_t04_SpinnerRandom` → `Trigger_02_t04_SpinnerRandom` (existing mapping; comment update only).
- Row 1355: `adrJA007728` → `(unlabelled)` → `Trigger_24_t30_SpinnerRight90` (populate existing blank relabel).
- Row 1356: `adrJA007734` → `Trigger_12_t18_Close_VoidLock_Door_XY` → `Trigger_12_t18_Close_VoidLock_Door_XY` (existing mapping; comment update only).
- Row 1357: `adrJA007746` → `Switch_03_s06_Trigger_03_t06_OpenLockedDoor_XY` → `Switch_03_s06_Trigger_03_t06_OpenLockedDoor_XY` (existing mapping; comment update only).
- Row 1358: `adrJA007758` → `Switch_07_s0E_Trigger_26_t34_RotateWood_XY` → `Switch_07_s0E_Trigger_26_t34_RotateWood_XY` (existing mapping; comment update only).
- Row 1359: `adrJA007768` → `Switch_06_s0C_Trigger_18_t24_CreatePillar_XY` → `Switch_06_s0C_Trigger_18_t24_CreatePillar_XY` (existing mapping; comment update only).
- Row 1360: `adrJA00776C` → `Switch_05_s0A_Trigger_13_t1A_TogglePillar_XY` → `Switch_05_s0A_Trigger_13_t1A_TogglePillar_XY` (existing mapping; comment update only).
- Row 1361: `adrJA00777E` → `Trigger_14_t1C_Create_Spinner_or_Other_XY` → `Trigger_14_t1C_SetFloorTypeBits_XY` (replace existing mapping).
- Row 1362: `adrJA00778A` → `Trigger_25_t32_Clicker_Teleport_FXY` → `Trigger_26_t34_ToggleFloorTypeBits_XY` (replace existing mapping).
- Row 1363: `adrJA007796` → `Trigger_16_t20_Create_Pad_FXY` → `Trigger_16_t20_ToggleNeighbourFloorType` (replace existing mapping).
- Row 1364: `adrJA0077D6` → `Trigger_17_t22_Move_Diagonal_Pillar` → `Trigger_17_t22_MovePillar_NorthWestToNorth` (replace existing mapping).
- Row 1365: `adrJA007800` → `Trigger_04_t08_Vivify_Machine_External` → `Trigger_04_t08_Vivify_Machine_External` (existing mapping; comment update only).
- Row 1366: `adrCd007812` → `(unlabelled)` → `VivifyExternal_SearchRevivalCell` (populate existing blank relabel).
- Row 1367: `adrLp00782A` → `(unlabelled)` → `VivifyExternal_FindCornerStack` (populate existing blank relabel).
- Row 1368: `adrCd007832` → `(unlabelled)` → `VivifyExternal_NextCorner` (populate existing blank relabel).
- Row 1369: `adrCd007836` → `(unlabelled)` → `Return_VivifyExternalNoRemains` (populate existing blank relabel).
- Row 1370: `adrCd007838` → `(unlabelled)` → `VivifyExternal_PrepareRemainsScan` (populate existing blank relabel).
- Row 1371: `adrCd007844` → `(unlabelled)` → `VivifyExternal_CheckRemainsCode` (populate existing blank relabel).
- Row 1372: `adrCd007854` → `(unlabelled)` → `VivifyExternal_PreviousObject` (populate existing blank relabel).
- Row 1373: `adrCd00785A` → `(unlabelled)` → `VivifyExternal_ConsumeRemains` (populate existing blank relabel).
- Row 1374: `adrCd00787E` → `(unlabelled)` → `Place_VivifiedChampionAtCell` (populate existing blank relabel).
- Row 1375: `adrCd0078A0` → `(unlabelled)` → `VivifyExternal_RestorePartyMember` (populate existing blank relabel).
- Row 1376: `adrCd0078B6` → `(unlabelled)` → `VivifyExternal_ReplaceDeadLeader` (populate existing blank relabel).
- Row 1377: `adrCd0078C0` → `(unlabelled)` → `VivifyExternal_InstallRevivedLeader` (populate existing blank relabel).
- Row 1378: `adrCd0078E4` → `(unlabelled)` → `VivifyExternal_RefreshParty` (populate existing blank relabel).
- Row 1379: `adrJA0078F0` → `Trigger_05_t0A_Vivify_Machine_Internal` → `Trigger_05_t0A_Vivify_Machine_Internal` (existing mapping; comment update only).
- Row 1380: `adrCd0078FA` → `(unlabelled)` → `VivifyInternal_QueueEffectAndSound` (populate existing blank relabel).
- Row 1381: `adrLp007910` → `(unlabelled)` → `VivifyInternal_ReviveNextSlot` (populate existing blank relabel).
- Row 1382: `adrLp007940` → `(unlabelled)` → `VivifyInternal_FindDisplaySlot` (populate existing blank relabel).
- Row 1383: `adrCd00794C` → `(unlabelled)` → `VivifyInternal_InsertDisplayChampion` (populate existing blank relabel).
- Row 1384: `adrCd007958` → `(unlabelled)` → `VivifyInternal_FinishParty` (populate existing blank relabel).

## Verified displacement tables

### Switch action table (`adrJT005B68`)

| action | original target | current mapping | address | signed displacement |
|---:|---|---|---:|---:|
| `$00` | `adrJB005B66` | `Switch_00_s00_Null` | `$5B66` | 0 |
| `$02` | `adrJA005D12` | `Switch_01_s02_Trigger_11_t16_RemoveXY` | `$5D12` | 428 |
| `$04` | `adrJA005CFC` | `Switch_02_s04_Trigger_23_t2E` | `$5CFC` | 406 |
| `$06` | `adrJA007746` | `Switch_03_s06_Trigger_03_t06_OpenLockedDoor_XY` | `$7746` | 7136 |
| `$08` | `adrJA0076B4` | `Switch_04_s08_Trigger_22_t2C_RotateWall_XY` | `$76B4` | 6990 |
| `$0A` | `adrJA00776C` | `Switch_05_s0A_Trigger_13_t1A_TogglePillar_XY` | `$776C` | 7174 |
| `$0C` | `adrJA007768` | `Switch_06_s0C_Trigger_18_t24_CreatePillar_XY` | `$7768` | 7170 |
| `$0E` | `adrJA007758` | `Switch_07_s0E_Trigger_26_t34_RotateWood_XY` | `$7758` | 7154 |

### Trigger action table (`adrJT007018`)

| action | original target | current mapping | address | signed displacement |
|---:|---|---|---:|---:|
| `$00` | `adrJB007016` | `Trigger_00_t00_Null` | `$7016` | 0 |
| `$02` | `adrJA007712` | `Trigger_01_t02_Spinner180` | `$7712` | 1788 |
| `$04` | `adrJA00771A` | `Trigger_02_t04_SpinnerRandom` | `$771A` | 1796 |
| `$06` | `adrJA007746` | `Switch_03_s06_Trigger_03_t06_OpenLockedDoor_XY` | `$7746` | 1840 |
| `$08` | `adrJA007800` | `Trigger_04_t08_Vivify_Machine_External` | `$7800` | 2026 |
| `$0A` | `adrJA0078F0` | `Trigger_05_t0A_Vivify_Machine_Internal` | `$78F0` | 2266 |
| `$0C` | `adrJA0076D2` | `Trigger_06_t0C_WoodTrap1` | `$76D2` | 1724 |
| `$0E` | `adrJA0076EA` | `Trigger_07_t0E_WoodTrap2` | `$76EA` | 1748 |
| `$10` | `adrJA007702` | `Trigger_08_t10_Trader_DoorCloser` | `$7702` | 1772 |
| `$12` | `adrJA007454` | `Trigger_09_t12_Tower_Entrance_SidePad` | `$7454` | 1086 |
| `$14` | `adrJA0073E6` | `Trigger_10_t14_Tower_Entrance_CentrePad` | `$73E6` | 976 |
| `$16` | `adrJA005D12` | `Switch_01_s02_Trigger_11_t16_RemoveXY` | `$5D12` | -4868 |
| `$18` | `adrJA007734` | `Trigger_12_t18_Close_VoidLock_Door_XY` | `$7734` | 1822 |
| `$1A` | `adrJA00776C` | `Switch_05_s0A_Trigger_13_t1A_TogglePillar_XY` | `$776C` | 1878 |
| `$1C` | `adrJA00777E` | `Trigger_14_t1C_Create_Spinner_or_Other_XY` | `$777E` | 1896 |
| `$1E` | `adrJA005CF8` | `Switch_00_s00_Trigger_15_t1E_ToggleWallXY` | `$5CF8` | -4894 |
| `$20` | `adrJA007796` | `Trigger_16_t20_Create_Pad_FXY` | `$7796` | 1920 |
| `$22` | `adrJA0077D6` | `Trigger_17_t22_Move_Diagonal_Pillar` | `$77D6` | 1984 |
| `$24` | `adrJA007768` | `Switch_06_s0C_Trigger_18_t24_CreatePillar_XY` | `$7768` | 1874 |
| `$26` | `adrJA007386` | `Trigger_19_t26_Keep_Entrance_SidePad` | `$7386` | 880 |
| `$28` | `adrJA007356` | `Trigger_20_t28_Keep_Entrance_CentrePad` | `$7356` | 832 |
| `$2A` | `adrJA007686` | `Trigger_21_t2A_Flash_Telepoprt_FXY` | `$7686` | 1648 |
| `$2C` | `adrJA0076B4` | `Switch_04_s08_Trigger_22_t2C_RotateWall_XY` | `$76B4` | 1694 |
| `$2E` | `adrJA005CFC` | `Switch_02_s04_Trigger_23_t2E` | `$5CFC` | -4890 |
| `$30` | `adrJA007728` | `adrJA007728` | `$7728` | 1810 |
| `$32` | `adrJA00763C` | `Trigger_24_t30_Spinner3` | `$763C` | 1574 |
| `$34` | `adrJA00778A` | `Trigger_25_t32_Clicker_Teleport_FXY` | `$778A` | 1908 |
| `$36` | `adrJA007758` | `Switch_07_s0E_Trigger_26_t34_RotateWood_XY` | `$7758` | 1858 |
| `$38` | `adrJA007630` | `Trigger_27_t36_Rotate_WoodWall_CounterClockwise` | `$7630` | 1562 |
| `$3A` | `adrJA00751A` | `Trigger_28_t38_GameCompletion` | `$751A` | 1284 |
| `$3C` | `adrJA007502` | `adrJA007502` | `$7502` | 1260 |

## Remaining limits

- The exact game meaning of the two fixed `$3C` puzzle bits is not established by static code; their condition and target effect are established.
- The routines deliberately treat bit 7 as their occupancy/flag guard without checking destination cell type. A live map observation could document unusual decorated-wall or invalid-floor teleport records, but none is required for the labels/EQU/comments here.
- Game-completion screen-buffer and wait-loop instructions were not included in this comment batch. Its dispatch entry is identified as action `$3A`, and its high-level routine label/comment is proposed.
