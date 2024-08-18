# dango.lua 🍡

`dango.lua` is a cross-platform, lightweight Go board


> **dan•go** [だんご]  
> noun
> 1. A Japanese dumpling made from *mochiko* (rice flour) 
> 2. A Japanese [go term](https://senseis.xmp.net/?Dango), meaning "dumpling shape";  a solid mass of stones without eyes, and with few liberties

## Motivation
To make a no-frills Go client that supports [GTP](https://www.lysator.liu.se/~gunnar/gtp/gtp2-spec-draft2/gtp2-spec.html) engines.

A lightweight, cross-platform alternative to [Sabaki](https://github.com/SabakiHQ/Sabaki), specifically for embedded systems that don't have the resources for an Electron-based program.


### Build
Still a work in progress, basic game is implemented:

```sh
git clone https://github.com/gsobell/dango.lua.git && cd dango.lua
make
love dango.lua
```
Requires: [`LÖVE 2D`](https://www.love2d.org/)

### Installation

There are three default profiles for the targeted platforms:
1. Desktop - cross-platform, mouse and keyboard
2. Touchscreen - Phones, tablets, and eInk Tablets
3. Embedded - [RetroArch](https://www.retroarch.com/) or [Ludo](https://ludo.libretro.com/)

For the third category, care was taken only to use the [API](https://github.com/libretro/lutro-status) implemented by [Lutro](https://lutro.libretro.com/), a subset of [LÖVE 2D](https://www.love2d.org/).
This will allow `dango` to run on any embedded device that can run Libretto's RetroArch.


## Controls
Navigate with arrow keys or mouse. Click, `enter` or `space` places a stone.

Keyboard shortcuts:
- `n` : new game
- `p` : pass
- `esc` : exit

## Features

### Current
- Board of any size
- Stone and group capture
- Legal move detection

### Future
- Ko
- Undo
- SGF Import/export
- GTP protocol
- Zero configuration GTP engines
- Profile auto-detection
- Themes
  - eInk theme
  - Low-res theme

### Supported GTP Engines
- None

See also:

[dango](https://github.com/gsobell/dango) -
a nCurses Go board for the terminal
***

Made with [LÖVE](https://www.love2d.org/)
