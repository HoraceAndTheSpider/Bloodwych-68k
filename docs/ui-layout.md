# Bloodwych SPS 439 interface layout

This is a source-led layout reference for the two-player dungeon interface. It
describes the original SPS 439 drawing and hit-testing paths; it is not a
viewer-only reconstruction.

## Coordinate model

Each player has a separate `PlayerX_Data` record. The renderer adds the
player's screen-buffer offset at `$000A(a5)` to fixed screen-buffer addresses.
The hit-test path subtracts the player's horizontal coordinate at `$0008(a5)`
from the low word of the packed pointer position before comparing it with the
interface tables.

`HitTest_PlayerInterfaceActions` at `$5138` treats each hitbox as four words:

```text
[x_min, x_max, y_min, y_max]
```

The comparisons are inclusive. The first matching record wins and its zero-
based index is written to `PlayerX_Data+$000C`.

## Hitbox tables

`adrEA00EA72` at memory `$EA72` (binary offset `$E6EE`) contains 17 records.
It is scanned for action indices 0 through 16 by `adrJA004DAA`.

| Index | Handler/action | Rectangle |
| ---: | --- | --- |
| 0 | spell-book/active-spell page opener (`adrJA006684`) | `$00E2-$0106`, `$0021-$0036` |
| 1 | statistics (`Click_ShowStats`) | `$0109-$011E`, `$0021-$0036` |
| 2 | context/multi-function (`Click_MultiFunctionButton`) | `$0121-$012E`, `$0022-$002F` |
| 3 | inventory (`Click_OpenInventory`) | `$0131-$013F`, `$0022-$002F` |
| 4 | primary attack | `$010D-$011D`, `$003A-$0046` |
| 5 | centre/display action | `$010D-$011D`, `$0048-$0055` |
| 6–9 | front-left, front-right, back-left, back-right champion selection | `$0120-$012F`, `$0130-$013F`, `$0130-$013F`, `$0120-$012F`; rows `$003A-$0045`, `$003A-$0045`, `$0049-$0054`, `$0049-$0054` |
| 10–15 | forward, backward, left, right, rotate-left, rotate-right | `$00F1-$00FC`, `$00F0-$00FD`, `$00E2-$00EC`, `$0101-$010B`, `$00E4-$00EC`, `$0100-$0109`; rows `$003B-$0045`, `$0049-$0053`, `$0047-$0053`, `$0047-$0053`, `$003C-$0043`, `$003C-$0043` |
| 16 | dungeon display | `$0072-$00CD`, `$001C-$0057` |

The compact table above preserves the original record order. For exact
machine data, use the 17 eight-byte records at `adrEA00EA72`; the merged
6–9 and 10–15 cells are only a visual summary.

`adrEA00EAFA` at memory `$EAFA` (binary offset `$E776`) contains the six
command-row hitboxes. It is scanned with action indices 28 through 33:

| Action | Handler | Rectangle |
| ---: | --- | --- |
| 28 | pause | `$0038-$0047`, `$0008-$0017` |
| 29 | load/save | `$0048-$0057`, `$0008-$0017` |
| 30 | sleep | `$0038-$0047`, `$0018-$0027` |
| 31 | show team avatars | `$0048-$0057`, `$0018-$0027` |
| 32 | change/toggle party-command row (`adrJA004C10`) | `$0038-$0057`, `$0028-$0037` |
| 33 | select party-command entry | `$0000-$005D`, `$003A-$0057` |

`adrEA005864` at memory `$5864` (binary offset `$54E0`) contains three more
four-word records, scanned as actions 34 through 36 by `HitTest_DisplayAction`:

```text
$0074,$00CC,$0049,$0059
$0088,$00B8,$0028,$003C
$0072,$00CD,$001C,$0048
```

These are display/context rectangles, not the ordinary fixed button grid.

The handler meanings come from `DungeonInterfaceActionTable` at memory
`$5B52` (binary offset `$57CE`). The table has 37 longword entries, so the
numeric action written by the hit test is also the jump-table index. The
spell-book, inventory, statistics and communication handlers therefore share
one action namespace; the champion-selection screen has a separate eight-entry
`ChampionPreviews_LookupTable` at `$C266`.

## Main player panel

When `PlayerX_Data+$0042` is negative, `adrCd0080CA` draws the ordinary player
panel. It uses fixed buffer offsets relative to `screen_ptr+$000A(a5)`:

- the panel background is drawn by `BW_draw_bar` with `$00240036` and
  `$00160017+$0008(a5)`;
- four champion status bars are laid out from `$00190004+$0008(a5)`, seven
  bytes/rows apart, using class-derived colours;
- the alternate party-command status bars start at `$00520006+$0008(a5)`;
- champion/icon material is drawn at `$0544` and the selected map/party icon at
  `$054C`;
- the party-command surface is rendered by `adrCd007B50` and
  `adrCd007D6C`, with menu text beginning at `$0910` and successive entries
  separated by `$0140` bytes in the screen buffer.

The class bar colour sequence at `adrB0081CA` is `[6, 13, 12, 7]`. It is a
profession/class colour choice, not the two-player blue/red accent.

## Inventory

`Click_OpenInventory` at `$6BF0` sets page state 3 and draws the inventory
background. `Redraw_Inventory` and `adrCd00C9BC` then draw twelve pocket slots
from `screen_ptr+$051C+$000A(a5)`. After slot 6, the destination advances by
`$0274` to the second pocket row.

The held-item panel starts at `screen_ptr+$0B5C+$000A(a5)`. It draws four fixed
panel pieces, the held object, the quantity, and the selected-slot frame. The
frame uses `$00E1 + (slot << 4)` and `$0049+$0008(a5)`. Food uses the same
panel path and draws a scaled bar with `$00390098` and `$0004005A+$0008(a5)`.

Object icons come through `adrCd00CAEA`, which addresses `GFX_Pockets` in
20-picture banks, advancing `$0A00` bytes per bank. The `Pockets.gfx` file is
therefore both the ordinary object-icon sheet and a packed bank of interface
pieces. Known UI subregions include the inventory chain around `$3C00`, the
spell-book surface around `$4100`, and status/command pieces around `$67C0`,
`$67E0`, `$6A60`, `$7580`, and `$7688`.

`GFX_ButtonHighlights` and the three small tables at `$6D7E`, `$6D8A`, and
`$6D96` position the directional/rotation button highlight sprites. The
highlight routine uses `screen_ptr+$08DC+$000A(a5)` and selects the source
position from those tables.

## Statistics page

`Click_ShowStats` at `$6616` sets page state 1, selects the default scroll
position `$2A`, and calls `Draw_ChampionStats`. `Draw_ScrollFrame` assembles a
96×15 top and bottom cap plus 16×58 left and right edges from:

- `GFX_Scroll_Edge_Top` at `$191BE`;
- `GFX_Scroll_Edge_Bottom` at `$1948E`;
- `GFX_Scroll_Edge_Left` at `$1975E`;
- `GFX_Scroll_Edge_Right` at `$1992E`.

The frame's background uses the per-player offset and the scroll drawing
origins `$0184`, `$03DC`, and `$03E6`. The seven editable values are selected
through `ChampionStatsScroll_FieldAndTextOffsets` at `$CBC4`; the writable
formatted text stream is `ChampionStatsScroll_TextTemplate` at `$CBD2`.

## Spell book

Spell-book drawing is split between the common action handlers and the lower
rendering routines:

- `adrCd00C7C8` draws the packed spell-book surface from `GFX_Pockets+$4100`
  at `screen_ptr+$0184+$000A(a5)`;
- `adrCd00C7FC` fills the page background;
- `adrCd00C812` prints the spell-point values at `screen_ptr+$0E2C` and again
  at `$00A0` later in the page;
- `adrCd00C86A` draws rune entries from `SpellBookRunes` at
  `screen_ptr+$042D+$000A(a5)`;
- `adrCd00C3DE` draws the selected spell marker from `GFX_Pockets+$4130`;
- names and descriptions come from the separate `SpellNames` and
  `SpellDescriptions` streams.

`Click_TurnSpellBookPage` updates the page word at `$002A(a5)` and redraws
the affected rune columns. The visible spell-book controls are action indices
21–25 in `DungeonInterfaceActionTable`; action 0 opens the main spell-book
page, while 21 launches a selected spell and 22 views it.

## Communication and party commands

`Click_CommsAndOptions` starts the party-command surface. The command state at
`PlayerX_Data+$0042` and visible-menu offset at `+$0044` are dispatched through
`PartyCommand_HandlerOffsets` at `$33A0`. The active communication mode is
value `$08`.

The menu renderer `adrCd007D6C` selects one of the descriptor streams at
`adrEA007C0E`, `adrEA007C2C`, `adrEA007C3A`, `adrEA007C4D`, `adrEA007C6F`,
`adrEA007C87`, or `adrEA007C93`, draws five selectable rows, then prints their
text. `PartyCommand_DispatchSelection` converts the selected row and column
back into a command index. The six `adrEA00EAFA` hitboxes above are the
corresponding pointer overlay for pause/load-save/sleep/avatar and command-row
selection.

The communication action meanings themselves are held in the 27-entry
`Comms_ActionHandlerOffsets` table at `$3526`; this is behavioural dispatch,
not screen geometry. Greeting and response text is emitted through the packed
message streams, so no separate communication icon bank has been proven in
the source.

## Player 1 blue / Player 2 red colour selection

The colour selection is in the player data and VBlank path:

- `Player1_Data` begins with `$00` at `$EE7C`;
- `Player2_Data` begins with `$01` at `$EEDE`;
- `adrCd008B72` tests bit 0 of the active player record;
- for Player 2 it adds `$0C` to the colour-table index;
- bit 6 of `$0052(a5)` adds another `$06`, supporting the animated/fade state;
- the selected word is loaded from the 24-word table immediately after the
  `adrCd008BE8` return and stored in `PlayerX_Data+$004C`;
- the same word is written to `_custom+color+$1E`, the hardware colour
  register used by the UI/VBlank path.

The data starts at memory `$8BEA` / binary offset `$8866` and is exactly 24
words (`$30` bytes), ending at `$8C19`. The following word at `$8C1A` is
`VBI_Marker`, so it is not part of this table. The four six-word ramps are
selected as follows:

```text
entry indices  1-6   Player 1 base ramp       $8BEA-$8BF4
entry indices  7-12  Player 1 alternate ramp $8BF6-$8C00
entry indices 13-18  Player 2 base ramp       $8C02-$8C0C
entry indices 19-24  Player 2 alternate ramp $8C0E-$8C18
```

The first ramp is `$00C0,$0080,$0060,$0040,$0020,$0000`; the third ramp is
`$0E80,$0A60,$0640,$0420,$0200,$0000`. These are hardware colour words,
not entries in `CharacterColours` or `ClassColours`. The six-step ramp
selection explains the animated accent transitions as well as the stable
Player 1 blue / Player 2 red appearance.

The load is deliberately based on the code label immediately before the
data:

```asm
add.w   d0,d0
move.w  adrCd008BE8(pc,d0.w),d0
```

`adrCd008BE8` is the address of the preceding `rts` at `$8BE8`; the first
valid selector is 1, so the first lookup lands at `$8BEA`. The PC-relative
base is therefore `$8BE8`, and `d0` is already a byte displacement after the
doubling. Player 2 adds `$0C` to the entry index, while the state bit adds
`$06`; those additions select different six-word ramps before the final
doubling.

For a movable source/resource layout, add a new logical label at the first
data word without removing the return label:

```asm
adrCd008BE8:
        rts
PlayerColourRampTable:
        dc.w    $00C0,$0080,$0060,$0040,$0020,$0000
        ; ...20 further words...
```

Then change the lookup anchor to `PlayerColourRampTable-2(pc,d0.w)`. The
`-2` preserves the original `$8BE8` base while making the data block itself
movable. If the block is extracted, the resource must be exactly 48 bytes;
the `rts` before it and `VBI_Marker` after it remain code/state data outside
the resource. The normal segment relabel should rename `adrCd008BE8` to
`PlayerColourRampLookupBase_Exit`. A separate verified `FIX_LABELS` rule then
consumes the `;fiX Label expected` marker, inserts `PlayerColourRampTable` at
`$8BEA`, and changes only the marked lookup to
`PlayerColourRampTable-2(pc,d0.w)`.

`adrCd0058EA` is unrelated: it is the existing `$58EA` / binary `$5566`
return label at the end of `Handle_WallFeatureClick`. It is not the `$8BEA`
colour-data boundary and should not be used as its anchor.

This is distinct from `CharacterColours` at `$351C8`, which remaps character
body parts, and `ClassColours` at `$846E`, which remaps champion shield/class
avatars.

## Cleanup/Wiki follow-up

The protected profile sheet already maps the named scroll, button-highlight,
Pockets, class-colour and player-data blocks. The missing profile-sheet data
candidates from this investigation are the three hitbox blocks:

```text
adrEA00EA72  Interface_Hitboxes_Main       data/Interface_Hitboxes_Main.lookup       $E6EE  $88
adrEA00EAFA  Interface_Hitboxes_Command    data/Interface_Hitboxes_Command.lookup    $E776  $30
adrEA005864  Interface_Hitboxes_Display    data/Interface_Hitboxes_Display.lookup    $54E0  $18
```

`cleanup.xlsx` now contains verified EQUATES for the shared action IDs, hitbox
record format and counts, packed `Pockets.gfx` UI offsets, and the
`PlayerX_Data` colour/state fields. Its COMMENTS sheet also documents the
three hit-test entry paths and the Player 2 colour-ramp selection in
`adrCd008B72`.

The protected profile row for the extracted colour bytes should describe the
new data label, not the preceding `rts`:

```text
label                 relabel                 Type      DATA BLOCK FILE             name                              BW439 Position  offset  size  Length (Hexidecimal)  data_action  source_comment
PlayerColourRampTable PlayerColourRampTable   gfx-data  PlayerColourRamps.colours   gfx-data/PlayerColourRamps.colours $8866          34918   48    30                    data_start   24 hardware colour words in four six-step Player 1/Player 2 UI accent ramps; the preceding rts at $8BE8 is outside the resource.
```

The ordinary code-label row is separate:

```text
label           relabel                         Type   DATA BLOCK FILE  name  BW439 Position  offset  size  Length (Hexidecimal)  data_action  source_comment
adrCd008BE8     PlayerColourRampLookupBase_Exit label  [blank]          [blank] $8864          34916   [blank] [blank]               [blank]       Exit point and PC-relative base used by the player-colour update routine.
```

The `FIX_LABELS` cleanup row that connects the original source marker to the
new data label is:

```text
profile       anchor_label  insert_label          source_match                           source_replace                                      expected_opcode  expected_matches  status    source_comment
BLOODWYCH439  adrCd008BE8   PlayerColourRampTable move.w adrCd008BE8(pc,d0.w),d0         move.w PlayerColourRampTable-2(pc,d0.w),d0       303B001A         1                 verified  Inserts the data label at $8BEA; the rts at $8BE8 remains the named exit/base label.
```

For the unrelated return address, the ordinary label row is:

```text
label           relabel                   Type   DATA BLOCK FILE  name  BW439 Position  offset  size  Length (Hexidecimal)  data_action  source_comment
adrCd0058EA     Return_WallFeatureClick   label  [blank]          [blank] $5566          21862   [blank] [blank]               [blank]       Return point used when a wall-feature click does not resolve to a supported action.
```

The `$8BEA` 24-word player-colour table has no original source label in
`BLOODWYCH439.asm`; it is now an explicit fix-label insertion candidate,
anchored by the verified `adrCd008BE8` source label. The original code label
still names the `$8BE8` `rts`; `PlayerColourRampTable` names only the 48-byte
table beginning at `$8BEA`.
