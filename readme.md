# IntangibleMatter's Metaballs

This is a simple 2D metaballs implementation based off of [John Wigg's implementation](https://john-wigg.dev/2DMetaballs/).

All of the colour palettes (aside from the flags and a few others) are sourced
from [Lospec](https://lospec.com). The files are all named based on the palette's
title on the website. 

(Also *please* don't read too much into which flags I chose, I just picked some
that I knew and thought might look cool. If you have any you want me to add let
me know!)

## Hotkeys:

`0`:

Disable the palette overlay. To reenable, just switch to a palette.

`2`-`8`:

Load the folder with the corresponding amount of colours.

`F`:

Load the flags folder

`U`:

Load the user palettes folder.

| Platform | Path |
| Windows | `%APPDATA%`\metaballs\palettes\` |
| Mac | `~/Library/Application Support/metaballs/palettes/` |
| Linux | `~/.local/share/metaballs/palettes/` |

You can manually create palettes with a text editor, but the easier way is
probably to download [Godot](https://godotengine.org/), create a new project,
make a new `GradientTexture1D` resource, then move it to the user palettes folder.

`left` and `right`:

Cycle through the colours in the open folder

`D`:

Toggle displaying the name of the palette on screen when it gets loaded.

`Space`:

Toggle fullscreen

`Esc`

Quit


