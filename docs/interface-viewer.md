# Interface Viewer / Editor

The Interface Viewer / Editor is the source-led reconstruction workspace for
Bloodwych's stacked two-player dungeon interface. Launch it from the right-hand
column of the App or directly with:

```text
python main.py interface
python main.py interface --modified
```

The App launcher separates source/data operations on the left from viewers and
editors on the right. The interface workspace returns to that launcher when it
closes.

## Current workspace

The preview shows the native 320×120 visible strip enlarged with
nearest-neighbour scaling. Its 320×96 player-local buffer begins at visible
`y=8`; the remaining lines are the full-width top/bottom chrome and intervening
black spacing seen in the original capture. Original Player 1 screenshots
establish the active buffer as three stable regions:

- a 96-pixel-wide left panel which toggles between compact statistics and
  party commands;
- the 128×76 dungeon viewport at native `(96,10)`;
- the fixed action/control bank beginning at `x=224`.

Both full-width grey borders have seven rows, using palette indices
`1, 2, 3, 4, 3, 2, 1`, as drawn by `adrCd007B2E`. The centre is `$AAA`
grey. The dungeon preview uses the same scene renderer, background loader,
and `(X + Y + facing) & 1` parity helper as the Map viewer. Moving one tile
or turning a quarter-turn selects the alternate floor/ceiling and wall
patterns together, following `adrCd0090D4`, `adrCd00B7F4` and `adrCd00B074`.

The disposable 5×9 test floor is embedded in
`tools/interface_data.py` as `INTERFACE_PREVIEW_FLOOR_BYTES`, with its switch
definitions in `INTERFACE_PREVIEW_SWITCHES`. These are independent of the
extracted maps and switch resources. Coordinates begin at `(0,0)` in the
top-left; the party starts at `(2,5)` facing north.

At `(1,5)`, cell `0A91` is an east-facing switch using reference 1. Its
synthetic `SwitchData_1`-style record is `04 00 01 04`: action `$04`, unused
byte zero, target X=1/Y=4 on the current floor. Turn left from the starting
position and click the switch to remove the wall at `(1,4)`; click again to
restore it. The switch also changes between its lit and dim graphics using
the shared Map renderer.

The click uses hitbox `$23` through `adrJA005894` and `adrJA005B2A`.
Action `$04` selects `adrJA005CFC`, whose existing relabel is
`Switch_02_s04_Trigger_23_t2E`. Hitbox `$24` remains the direct door action.
This preview currently implements only the toggle-wall switch action; other
switch actions and triggers remain outside its simulation. Reload restores
the test map and switch state without saving them to a game resource.

The compact statistics panel is not the full Statistics page. Clicking the
compact panel switches the reconstructed left side to party commands, and
clicking its triangle control switches back. Neither operation replaces the
dungeon view or right control bank. Inventory, the full Statistics page and
the spell book remain separate page modes.

Player 1 and Player 2 buttons select the corresponding `PlayerX_Data`
coordinate base, right-control graphic variant, and fixed interface colours.
The primary channel is blue `$7` / red `$9`; the secondary pocket-graphic
template channel is light blue `$8` / orange-red `$C`. The dialogue-text colour
is selected separately from the ramp table described below.

`W` and `S` move forward/backward, `A` and `D` strafe left/right, and `Q`
and `E` turn left/right. A configured joypad supplies the same six actions.
Keyboard, joypad and on-screen arrows all use the same preview movement and
collision routine and briefly light the corresponding original arrow. The
controls work while viewing any Interface page. Pause and load/save consume
them while those states own input; movement from sleep wakes the party and then
performs the requested action.

The hitbox overlay reads the extracted main, command, and display rectangle
tables. It is state-aware: movement and dungeon-display rectangles are shown
only on the ordinary dungeon interface, party-command rectangles only on the
command state, and page modes retain only the four active page-navigation
buttons. In communication mode the overlay shows the five visible grid
hot-boxes: pause, load/save, sleep, team avatars, and the wide third-row
communication toggle. The sixth raw command-table record is the broad
party-command selection region and is intentionally not drawn as a grid
hot-box. Every displayed rectangle retains its action number, verified handler
name, and corresponding entry in the 37-entry `DungeonInterfaceActionTable`.
Clicking an overlay rectangle invokes the viewer's source-led preview action:
pause waits for a click anywhere, load/save shows the original
function-key prompt at the top of the current interface, sleep clears the
dungeon viewport and draws the framed `THOU ART ASLEEP` state, the team-avatar
control returns to compact statistics, and the Statistics hit-box opens the
Statistics mode. The third-row communication toggle has no invented visual
stand-in: the original only acts while its separate communication-state flag is
active, so the viewer reports that condition rather than drawing a speculative
selection frame.
The overlay starts disabled for an unobstructed layout review; use the
`Hitboxes` button or press `H` to toggle it.

Pause recolours black and dialogue ink to `$400` across the entire strip
between the grey borders, including the spacing above and below the player
buffer. Its next click only unpauses: it cannot also activate the underlying
control. Load/save blocks other controls until **F10** is pressed; clicking
the exact **F10 - EXIT** text is also supported as an app convenience. F1/F2
disk operations are not simulated. Both states suppress ordinary hitboxes
and prevent game/editor controls from acting; the window close action remains
available. These input rules follow `adrCd00427C` and `adrCd00437E`.

The sleep reconstruction follows the verified source flow: `Click_SleepParty`
calls `adrCd002734`, the same shared clear-and-frame routine called before
`ThouArtDead`, then prints the `ThouArtAsleep` control-coded text stream. Its
three frame rectangles and text positions are rendered from that routine and
stream: its clear begins at `(96,12,128,76)`, two pixels below the compact
stats top decoration; its frame has a two-scanline top and three nested
side/bottom edges. `THOU ART` is at `(128,32)` and `ASLEEP` at `(136,48)`.
Clicking the dungeon viewport wakes the party and consumes that click without
also performing a wall/door action, following the sleep input path through
`adrCd00465E` and `adrCd004AFE`. Existing page controls can still wake the
party as before.

The inventory preview draws the same twelve slots as the source. Slots 0-3
are left hand, right hand, body armour, and shield. Empty equipment positions
use the semantic pictures from `Pockets.gfx` rather than a generic empty
pocket; occupied positions use the object-definition graphic and colour.
All twelve empty positions use pictures `$6C`-$77`, with template ink `$F`
replaced by the active player's secondary UI colour.

The compact stats panel draws three bars, matching the source's DBRA count of
`$02`. Their colours are an independent hard-coded pair (`$7` for Player 1,
`$C` for Player 2), so editing either player-record UI colour does not alter
them.

The lower shield row uses the second chain strip in `Pockets.gfx`, at
`GFX_Pockets+$3C30`. Its gaps are part of the graphic and leave room for the
three shield avatars. The continuous strip at `$3C00` is used where no shield
row interrupts it; `$3C60` is the command-panel strip.

The viewer selects four different champion records at startup, so the large
portrait and the three party shields do not repeat. It presents one
representative living champion, one dead champion, and one vacant party slot.
Both small portraits retain their ordinary face indices; standard Bloodwych
does not apply the `$4/$8/$C` avatar recolour mask. The common planar renderer
does replace ink `$F`, which belongs to the shield background/surround: living
party records normally use light-grey `$4` when no spell is worn, while dead
slots use `$0`.
Only the dead slot's class icon is four-colour remapped, using the source's
exact `$00020103` mask (indices `$0,$2,$1,$3`).
The representative living slot uses the ordinary `Draw_ShieldAvatar` path.
The separately decoded selected-shield surround at `GFX_Pockets+$5070` belongs
to the active/selected branch at `$7F86` and is not used merely because a
champion is alive.
The vacant slot
uses `Shield_Clicked.gfx`, whose template ink `$F` is replaced with the active
player's secondary UI colour and produces the horse emblem seen in the game.

The preview distinguishes source-led compositions from partial reconstructions.
This prevents procedural placeholders from being mistaken for confirmed game
pixels while the remaining draw routines are traced.

## Dialogue-text colour editor

`PlayerColourRamps.colours` is the current extracted filename for four six-word
dialogue ramps. Player 1's base ramp starts at green `$0C0`, Player 2's starts
at orange `$E80`, and both alternate ramps start at red `$C00`; every ramp
fades through six steps to black. The editor selects player, speaker/alternate
state, and fade step and then edits the red, green, and blue nibbles of that
exact `$0RGB` hardware word. The preview applies it only to GameFont dialogue
ink, not to the interface's blue/red chrome.

The text renderer uses planar ink index `$F`. The Copper list waits at raster
positions `$98` and `$FF` and requests an interrupt at each boundary. The
interrupt handler alternates between Player 2 and Player 1 and writes that
player's current ramp word to hardware colour register 15. Consequently the
same ink index can be orange, green, or red in different vertical regions of
one displayed frame. The Copper schedules the scanline changes; the CPU
interrupt routine performs the colour-register writes.

Text-colour ramp edits update the live shared session immediately.
**EXPORT ALL** writes the entire session, including any map or champion changes
made in other viewers, into the matching `-modified` folder. **DATA / FILES**
provides the common reset, reload, import and patch actions; there is no separate
modified-data toggle. Clean data remains immutable. See
[shared editing sessions](edit-session.md).

## Source provenance and future editing

Visual placement is not controlled by one original table. A typical source
draw prepares:

```text
A1  graphic source, often GFX_Pockets+offset
A0  screen_ptr + player screen-byte offset + destination
D5  packed DBRA width/height counts
A3  source-row stride for a crop in the 320-pixel backing sheet
D3  colour index that replaces template ink $F
```

and then calls the common planar renderer. The interface model records these
relationships with human-readable source names. Python drawing comments also
cite the original ASM address labels; editor-only overlays and presentation
adapters are identified separately. Layout editing will eventually
emit modified graphic/hitbox resources and source-build metadata; it must not
rewrite generated ASM directly.

The first implemented editor is the dialogue-text colour-ramp editor. Graphic-pixel,
placement, and hitbox editing remain read-only until the corresponding source
boundaries and relocation rules are proven.
