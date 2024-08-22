# dango.lua 🍡

`dango.lua` is a cross-platform, lightweight Go board

> **dan•go** [だんご]  
> noun
> 1. A Japanese dumpling made from *mochiko* (rice flour) 
> 2. A Japanese [go term](https://senseis.xmp.net/?Dango), meaning "dumpling shape";  a solid mass of stones without eyes, and with few liberties

## Motivation
To make a no-frills Go client that supports [GTP](https://www.lysator.liu.se/~gunnar/gtp/gtp2-spec-draft2/gtp2-spec.html) engines out of the box.

A lightweight, cross-platform alternative to [Sabaki](https://github.com/SabakiHQ/Sabaki), especially for embedded systems that don't have the resources for an Electron-based program.


### Build
Still a work in progress, basic game is implemented:

```sh
git clone https://github.com/gsobell/dango.lua.git && cd dango.lua
make
love ./
```
Requires: [`LÖVE 2D`](https://www.love2d.org/)

### Installation

Work in progress, for now see [build](#Build) above.

Platform specific binaries to be available under [Releases](https://github.com/gsobell/dango.lua/releases) in the future.

*Planned:*

There are three default profiles, automatically detected at runtime:
1. Desktop - cross-platform, mouse and keyboard
2. Touchscreen - Phones, tablets, and eInk Tablets
3. Embedded - [RetroArch](https://www.retroarch.com/) or [Ludo](https://ludo.libretro.com/)

Lutro compatibility mode,
For the third category, care was taken only to use the [API](https://github.com/libretro/lutro-status) implemented by [Lutro](https://lutro.libretro.com/), a subset of [LÖVE 2D](https://www.love2d.org/).
This will allow `dango` to run on any embedded device that can run Libretto's RetroArch.


## Controls
Navigate with arrow keys or mouse. Click, `enter` or `space` places a stone.

Keyboard shortcuts:
- `n` : new game
- `u` : undo (in progress)
- `p` : pass
- `esc` : exit

## Features

### Current
- Any size board
- Stone and group capture
- Legal move detection
- Adjustable scaling for board, grid and stones

### In Progress
- Ko
- Undo
- GTP protocol

### Future
- SGF Import/export
- Zero configuration GTP engines
- Profile auto-detection
- Themes
  - eInk theme
  - Low-res theme

See [TODO](TODO.md) for the project roadmap.

### Supported GTP Engines

While any and all GTP engines should work, some require no additional setup:

 Engine | Windows              | Linux                | Android              | Embedded
:-:     |:-:                   |:-:                   |:-:                   |:-:
`gnugo` | :white_large_square: | :white_large_square: | :white_large_square: | :white_large_square:
`pachi` | :white_large_square: | :white_large_square: | :white_large_square: | :white_large_square:
`michi` | :white_large_square: | :white_large_square: | :white_large_square: | :white_large_square:
`lichi` | :white_large_square: | :white_large_square: | :white_large_square: | :white_large_square:

:white_check_mark: = works

:negative_squared_cross_mark: = works, setup needed

:white_large_square: = untested

:bug: = buggy

:x: = not available on this platform

<!-- N/A = not available on this platform -->
<!-- ✅ ❎ ⬜ 🐛 ❌ -->

See also:

[dango](https://github.com/gsobell/dango) -
a nCurses Go board for the terminal
***

Made with [LÖVE](https://www.love2d.org/)
