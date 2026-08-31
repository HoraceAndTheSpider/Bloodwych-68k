# Joypad controls

Choose **Define Joypad Buttons** on the front menu, or **JOYPAD (F8)** in any
viewer or the Binaries / Saves / Data browser. The same page opens automatically
when a connected device has no usable matching layout, including when a joypad
is plugged in after opening the app. Cancelling leaves an unconfigured device
inactive for that window; F8 reopens the page. Keyboard and mouse remain usable.
**RESCAN** checks SDL's list again and shows its version and any device-open
errors. The app also rescans once a second to recover missed connection events.

## macOS detection

Detection uses `pygame.joystick.get_count()` plus SDL connection/removal events;
it does not equate a Bluetooth pairing with a readable game controller. Some
macOS controllers are visible to HID while Apple's GameController API claims
support but supplies no controller. SDL 2.28.4 can then skip the HID device and
report zero joypads. This was reproduced with an 8BitDo SN30 Pro+ on macOS 14.7.2.

The macOS dependency is Pygame Community Edition (`pygame-ce`), which still
imports as `pygame`. Pygame CE 2.5.5 / SDL 2.32.6 was verified to detect that
controller through HID: four axes, sixteen buttons and one hat. If the initial
SDL list is empty on macOS, the app uses `SDL_JOYSTICK_MFI=0` and reinitializes
the joystick subsystem, provided SDL is at least 2.32.6. Existing controllers
and an explicitly set `SDL_JOYSTICK_MFI` are left alone. Older SDL builds show
a runtime-upgrade message; they do not support this fallback reliably.

Use the project-local environment, not an older global Pygame installation:

```sh
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements.txt
.venv/bin/python main.py
```

An environment already prepared for this project needs only the last command.
Export any in-memory edits before closing the old app. Do not install both
`pygame` and `pygame-ce` into the same environment: they supply the same import
package. The fallback changes only this process's SDL settings; it does not
alter Bluetooth pairings, firmware or macOS privacy permissions.

SDL documents the [MFI backend switch](https://wiki.libsdl.org/SDL2/SDL_HINT_JOYSTICK_MFI).
Physical input and button assignments still need checking in the definition page;
successful enumeration alone does not test each control.

## Defining controls

Release the sticks, triggers and buttons before connecting or starting setup.
Select a row with the mouse, or use Up/Down and Enter, then press the desired
button, D-pad direction or analogue direction. **DEFINE ALL** walks through the
rows; release each input before defining the next. D-pads reported as buttons,
hats or axes are all supported. Diagonal hat input is ignored during definition
because it does not identify a single direction. No axis or button number is
assumed to mean movement.

The six required movement controls are forward, backward, strafe left, strafe
right, turn left and turn right. Optional controls are pointer up/down/left/right
and fire (left mouse click). One physical input direction can serve only one
action. **CLEAR** removes the selected binding; **SKIP** leaves it unchanged and
advances. An input already assigned elsewhere is rejected with an explanation.
Two opposite directions of an analogue axis are separate inputs.

**SAVE** validates and writes the layout. **CANCEL** discards unsaved changes;
Escape cancels a capture first, then closes the page. The device arrows select
another connected joypad and discard the current unsaved draft. Use keyboard or
mouse for definition: mapped joypad actions are suspended while the page is open
so input cannot accidentally edit a resource or click through to another page.

Layouts are local JSON files under `config/joypads/`, separate from game data,
saves and exports, and ignored by Git. Matching uses the SDL hardware GUID,
platform and axis/button/hat counts, rather than the device's changing connection
number. Identical controllers share a layout; a different connection mode or
different reported hardware may need its own layout. Missing, incomplete,
incompatible or damaged files reopen setup instead of enabling guessed controls.
A failed save leaves the previous file intact.

Mapped movement works in all five map modes and moves the shared cursor relative
to its facing; it does not move a placed object/actor or apply game collision
rules. Held controls repeat after a short delay. Stick noise is filtered and
release thresholds prevent jitter from generating repeated steps. The cursor
automatically pans into view at the current zoom level.

The optional pointer controls work in the launcher, viewers and file browser.
Analogue movement gives proportional pointer speed; buttons and D-pad directions
give steady movement. Fire produces normal left-button press/release events,
including held editor adjustments. Disconnecting a device, opening setup or
losing window focus releases fire. Held inputs must be released before they can
act again after setup or a focus change.

The shared input adapter exposes named movement actions with the connected
device's instance ID, and mouse events for pointer/fire. A future game test mode
can consume these without another controller definition flow. This does not add
a game test mode or assign connected devices to Player 1/Player 2 yet.
