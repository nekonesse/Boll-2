# Mario & Sonic Boll 2

Mario & Sonic Boll 2 is a fangame featuring Super Mario and Sonic the Hedgehog. It's a successor to the original Sonic Boll and its Deluxe version, and is currently in development on a brand new engine. It features heavy influence from 2D and early 3D entries of both franchises, while trying to do its own thing combining what makes both Mario and Sonic special.

You can find more info about our plans in our GDD (Game Design Document): https://docs.google.com/document/d/1Pk0B2v3YO71YAq32v4xs2YGsvMUyVazocIokcUpVisQ/edit?usp=drivesdk
Be warned that some things may be a little outdated or require more discussion.

We also have a trello but it cannot be shared to the public, so i will work on merging all of the Trello boards into github issues.

GAME CONTROLS:
X key: A Button
Z Key: B Button
C Key: C Button
V Key: V Button

EDITOR CONTROLS:
CTRL + S: Save File
CTRL + Z: Undo (Heavily WIP)
CTRL + Y: Redo (Heavily WIP)

DEBUG CONTROLS:
F1: Lower Game Speed
F2: Raise Game Speed
F3: Debug Display
F4: Toggle Show Collision Mode
F5: FPS Display
F6: Read HUD Status (coins, lives, time, reserved item) via screen reader

## Accessibility

Menu, UI, and gameplay screen-reader speech is provided by [GMSTolkTalk](https://github.com/Gannio/GMSTolkTalk), which wraps [Tolk](https://github.com/ndarilek/tolk).

- Tolk is distributed under the GNU Lesser General Public License version 3 (LGPLv3).
- NVDA client libraries are distributed under the GNU Lesser General Public License version 2.1 (LGPLv2.1).

Speech follows the active screen reader (e.g. NVDA) when detected. A Screen Reader option is available under Settings > Accessibility (Auto / On / Off).

On the boot disclaimer screen, speech is sequential: the disclaimer finishes, then "Press any button to continue." is spoken. All other speech interrupts the current utterance (menus, level name, death, coins, checkpoints, etc.).