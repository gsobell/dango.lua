# dango.lua 🍡

`dango.lua` is a cross-platform, lightweight Go board

> **dan•go** [だんご]  
> noun
> 1. A Japanese dumpling made from *mochiko* (rice flour) 
> 2. A Japanese [go term](https://senseis.xmp.net/?Dango), meaning "dumpling shape";  a solid mass of stones without eyes, and with few liberties

## Motivation
To make a no-frills Go client that supports [GTP](https://www.lysator.liu.se/~gunnar/gtp/gtp2-spec-draft2/gtp2-spec.html) engines out of the box.

A lightweight, cross-platform alternative to [Sabaki](https://github.com/SabakiHQ/Sabaki), especially for embedded systems that don't have the resources for an Electron-based program.


## Build
Still a work in progress, basic game is implemented:

```sh
git clone https://github.com/gsobell/dango.lua.git && cd dango.lua
make
love ./
```
Requires: [`LÖVE 2D`](https://www.love2d.org/)

## Installation

Work in progress, for now see [build](#Build) above.

*Planned:*

Platform specific binaries to be available under [Releases](https://github.com/gsobell/dango.lua/releases) in the future.

There are three default profiles, automatically detected at runtime:
1. Desktop - cross-platform, mouse and keyboard
2. Touchscreen - Phones, tablets, and eInk Tablets
3. Embedded - [RetroArch](https://www.retroarch.com/) or [Ludo](https://ludo.libretro.com/)

#### Lutro compatibility mode
For the third category, care was taken only to use the [API](https://github.com/libretro/lutro-status) implemented by [Lutro](https://lutro.libretro.com/), a subset of [LÖVE 2D](https://www.love2d.org/).
This will allow `dango` to run on any embedded device that supports Libretto's RetroArch. (i.e. handheld console, TV, smart toaster, etc.)


## Controls
Navigate with arrow keys, vim keys, or mouse. Click, `enter` or `space` places a stone.

Keyboard shortcuts:
- `n` : new game
- `u` : undo
- `p` : pass
- `esc` : exit

## Features

### Current
- Any size board
- Stone and group capture
- Legal move detection
- Adjustable scaling for board, grid and stones
- GTP protocol
- Ko
- Undo

### In Progress
- SGF Import/export
- Zero configuration GTP engines

### Future
- Menu
- Profile auto-detection
- Branching game tree
- Themes
  - eInk theme
  - Low-res theme

See [TODO](TODO.md) for the project roadmap.

### Supported GTP Engines

While any and all GTP engines should work, some require additional setup:

 Engine  | Linux             | Windows          | Android         | macOS     | Embedded | Notes
:-:       |:-:                   |:-:                   |:-:                   |:-: | :-:|:-:
[`gnugo`](https://www.gnu.org/software/gnugo/gnugo.html) | :white_check_mark: | :white_large_square: | :white_large_square: | :white_large_square: | :white_large_square: |
[`pachi`](https://github.com/pasky/pachi) | :white_check_mark: | :white_large_square: | :white_large_square: | :white_large_square: | :white_large_square: |
[`michi`](https://github.com/pasky/michi) | :white_large_square: | :white_large_square: | :white_large_square: | :white_large_square: | :white_large_square: | requires `python2`
[`lichi`](https://github.com/gsobell/lichi) | :x: |:x: |:x: |:x: |:x: | in development
[`ray`](https://github.com/kobanium/Ray) | :white_large_square: | :white_large_square: | :white_large_square: | :white_large_square: | :white_large_square: |
 [`katago`](https://github.com/lightvector/KataGo)| :white_large_square: | :white_large_square: | :white_large_square: | :white_large_square: | :white_large_square: | `eigen` cpu, `openCL` on AMD GPU tested
 [`leela zero`](https://github.com/leela-zero/leela-zero) | :white_large_square: | :white_large_square: | :white_large_square: | :white_large_square: | :white_large_square: |

 :white_check_mark: = just works
<!--  :ballot_box_with_check: = works, setup needed    -->
 :white_large_square: = untested
<!-- :negative_squared_cross_mark: = works, setup needed -->
<!-- :bug: = buggy    -->
:x: = not available on this platform

<!-- N/A = not available on this platform -->
<!-- ✅ ☑️ ❎ ⬜ 🐛 ❌ -->

See also:

[dango](https://github.com/gsobell/dango) -
a nCurses Go board for the terminal
***

Made with [LÖVE](https://www.love2d.org/)
