# Interface source-label ledger

This ledger preserves the original disassembly symbol while assigning a
human-readable name to every address-labelled source point traversed by the
initial interface reconstruction. The original symbol remains provenance; code,
comments, and viewer metadata should use the human name after the protected
profile mapping is accepted.

The earlier spelling `adrB0081CA` was not an exact source symbol. The verified
original label is `adrB_0081CA`.

| Original label | Human label | Memory | Meaning |
| --- | --- | ---: | --- |
| `adrB_0081CA` | `ChampionClassBarColours` | `$81CA` | Four profession-to-status-bar palette indices. |
| `adrCd0058EA` | `Return_WallFeatureClick` | `$58EA` | Return when a wall-feature click has no supported action. |
| `adrJA004DAA` | `Begin_HitTestMainInterfaceActions` | `$4DAA` | Select the main hitbox table and enter the shared hit tester. |
| `adrCd0080CA` | `Draw_MainPlayerInterface` | `$80CA` | Draw the ordinary player interface. |
| `adrCd007FF8` | `Draw_CompactStatsFrame` | `$7FF8` | Build the compact statistics frame from procedural lines, a fill bar, and the `<STATS>` graphic. |
| `adrCd00C0BA` | `Draw_BevelledPanelFrame` | `$C0BA` | Fill a panel rectangle and add three successively inset grey frame outlines. |
| `adrCd00CCBE` | `Draw_MainChampionAvatarPanel` | `$CCBE` | Compose the large champion panel from its outer bevel, portrait, and optional inner frame. |
| `adrCd00CCD8` | `Draw_MainChampionAvatarInnerFrame` | `$CCD8` | Draw the inner large-avatar outline unless the current player state suppresses it. |
| `adrCd007B2E` | `Draw_PartyCommandPanelEdge` | `$7B2E` | Build the procedural edge around the party-command panel. |
| `adrCd008258` | `Draw_ChampionNamePanelBackground` | `$8258` | Clear the right-hand name/display panel before its frame is drawn. |
| `adrCd008278` | `Draw_ChampionNamePanelFrame` | `$8278` | Draw the right-hand name strip and its bevel lines. |
| `adrCd0082BA` | `Draw_ChampionNamePanelLowerEdge` | `$82BA` | Draw the lower name/status-panel edge and packed status graphics. |
| `adrCd00833C` | `Draw_DungeonDisplayLowerEdge` | `$833C` | Draw the lower dungeon-display edge before the chain strip. |
| `adrW_00EE86` | `Player1_InterfaceScreenBufferOffset` | `$EE86` | Player 1 screen-buffer destination offset; later words in the record hold its two interface colour roles. |
| `adrCd007B50` | `Draw_PartyCommandInterface` | `$7B50` | Compose the party-command panel for its current state. |
| `adrCd007D6C` | `Draw_PartyCommandMenu` | `$7D6C` | Select and draw a party-command descriptor stream. |
| `adrCd007E6A` | `Draw_ActivePartyChampionInShield` | `$7E6A` | Validate an active living party slot and draw its character inside the selected shield surround. |
| `adrW_007EA8` | `ActivePartyChampionShieldDrawParameters` | `$7EA8` | Four six-byte records supplying the character renderer's X, Y, and display parameters for the party slots. |
| `adrCd007EC0` | `Refresh_DirtyPartyShieldSlots` | `$7EC0` | Visit all four party slots and redraw those marked dirty before drawing the interrupted chain strip. |
| `adrLp007EC2` | `Refresh_DirtyPartyShieldSlots_Loop` | `$7EC2` | Four-slot dirty-shield refresh loop. |
| `adrCd007ED2` | `Draw_PartyShieldChainStrip` | `$7ED2` | Draw the `$3C30` chain strip whose gaps accommodate the three visible shield slots. |
| `adrCd007EF0` | `Refresh_PartyShieldSlotIfDirty` | `$7EF0` | Return unless the selected slot's redraw flag is negative. |
| `adrCd007F54` | `Draw_PartyShieldSlot` | `$7F54` | Choose vacant, selected-living, ordinary, or dead rendering for one party shield slot. |
| `adrCd007F86` | `Select_OccupiedPartyShieldRendering` | `$7F86` | Distinguish the selected living slot from ordinary/dead occupied slots. |
| `adrCd007FB2` | `Draw_SelectedPartyChampionInShield` | `$7FB2` | Prepare the character-render work area and draw the active living champion inside the selected surround. |
| `adrCd007FD4` | `Return_PartyShieldDrawing` | `$7FD4` | Shared return for party-shield rendering paths. |
| `adrCd007FD6` | `Select_PartyShieldClassColours` | `$7FD6` | Select normal class colours or the fixed dead-state class mask before composing a shield avatar. |
| `adrCd007FDE` | `Use_DeadPartyShieldClassColours` | `$7FDE` | Set `D3` to zero so `Draw_ShieldAvatar` retains its fixed `$00020103` dead-class mask. |
| `adrCd007FE0` | `Prepare_ComposedPartyShieldAvatar` | `$7FE0` | Resolve the champion ID and optional live class colour before entering the common shield compositor. |
| `adrCd007FF4` | `Draw_ComposedPartyShieldAvatar` | `$7FF4` | Tail-call `Draw_ShieldAvatar` with the selected normal or dead class-colour state. |
| `adrCd00C9BC` | `Draw_InventoryPocketSlots` | `$C9BC` | Draw twelve inventory pocket slots. |
| `adrCd00CAEA` | `Draw_PocketGraphic` | `$CAEA` | Resolve and draw a picture from `GFX_Pockets`. |
| `adrCd00CCFE` | `Select_WornSpellShieldInkColour` | `$CCFE` | Map `ChampionStat_WornSpell` to the ink used for palette-index `$F` shield surround pixels. |
| `adrB_00CD14` | `WornSpellShieldInkColourLookup` | `$CD14` | Eight palette indices selected by the low three bits of the currently worn spell. |
| `adrCd00CDBC` | `Store_ShieldClassColourMask` | `$CDBC` | Store the normal class mask or fixed dead mask before drawing the four shield components. |
| `adrCd00CE28` | `Draw_PlanarGraphicCore` | `$CE28` | Draw packed four-plane rows and apply the supplied template colour. |
| `adrCd00CE86` | `Replace_PlanarInk15WithColour` | `$CE86` | Replace source palette-index `$F` pixels with the four-bit colour supplied in `D3`. |
| `adrLp00811E` | `Draw_CompactStatsBarsLoop` | `$811E` | Draw the three compact statistics bars with the independent player-specific colour. |
| `adrCd00CA14` | `Select_EmptyInventorySlotGraphic` | `$CA14` | Select an empty equipment/pocket picture and the player's secondary UI colour. |
| `adrCd00C7C8` | `Prepare_AndDrawSpellBookSurface` | `$C7C8` | Draw the book surface and select the champion record. |
| `adrCd00C7FC` | `Clear_SpellBookPanel` | `$C7FC` | Clear the spell-book panel. |
| `adrCd00C812` | `Draw_SpellPointValues` | `$C812` | Format and print current/maximum spell points. |
| `adrCd00C86A` | `Draw_SpellBookRunePage` | `$C86A` | Draw a rune page from `SpellBookRunes`. |
| `adrCd00C3DE` | `Draw_SelectedSpellMarker` | `$C3DE` | Draw the selected spell-column marker. |
| `adrJA004C10` | `Click_TogglePartyCommandRow` | `$4C10` | Toggle the visible command row in communication mode. |
| `adrCd008B72` | `Update_PlayerDialogueTextColour` | `$8B72` | Select a six-step dialogue-text ramp word and write hardware colour 15. |
| `adrCd008BE8` | `PlayerColourRampLookupBase_Exit` | `$8BE8` | Dialogue-colour update return and historic PC-relative lookup base. |
| `adrCd008C40` | `Handle_CopperRasterInterrupt` | `$8C40` | Alternate the Copper-scheduled interrupt between Player 2 colour service and Player 1 frame service. |
| `adrCd008C62` | `Handle_Player1RasterAndFrameUpdate` | `$8C62` | Update Player 1 dialogue colour, timers, input, and frame state at the second raster interrupt. |
| `adrEA005864` | `Interface_Hitboxes_Display` | `$5864` | Three display/context hitbox records. |
| `adrEA007C0E` | `PartyCommandDescriptorStream_Mode0` | `$7C0E` | Static descriptor stream selected by menu mode 0. |
| `adrEA007C2C` | `PartyCommandDescriptorStream_Mode4` | `$7C2C` | Static descriptor stream selected by menu mode 4. |
| `adrEA007C3A` | `PartyCommandDescriptorStream_Mode5` | `$7C3A` | Static descriptor stream selected by menu mode 5. |
| `adrEA007C4D` | `PartyCommandDescriptorStream_Mode6` | `$7C4D` | Static descriptor stream selected by menu mode 6. |
| `adrEA007C6F` | `PartyCommandDescriptorStream_Mode7` | `$7C6F` | Static descriptor stream selected by menu mode 7. |
| `adrEA007C87` | `PartyCommandDescriptorStream_Mode8` | `$7C87` | Static descriptor stream selected by menu mode 8. |
| `adrEA007C93` | `PartyCommandDescriptorStream_Mode9` | `$7C93` | Static descriptor stream selected by menu mode 9. |
| `adrEA00EA72` | `Interface_Hitboxes_Main` | `$EA72` | Seventeen main-interface hitbox records. |
| `adrEA00EAFA` | `Interface_Hitboxes_Command` | `$EAFA` | Six command-interface hitbox records. |
| `adrJA006684` | `Click_OpenSpellBook` | `$6684` | Open and compose the champion spell-book page. |

The descriptor-stream names deliberately state the verified dispatch index
rather than guessing their visible menu meaning. A live capture of
`PlayerX_Data+$0044` together with the displayed rows for modes 0 and 4–9 would
allow those labels to be promoted to semantic menu names.
