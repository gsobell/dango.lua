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
Very much still a work in progress:

```sh
git clone https://github.com/gsobell/dango.lua.git && cd dango.lua
make
love dango.love
```

### Installation
Care was taken to only used [API](https://github.com/libretro/lutro-status) also implemented by [Lutro](https://lutro.libretro.com/), a subset of [LÖVE 2D](https://www.love2d.org/).
This will allow `dango` to run on any embedded device that can run Libretto's [Ludo](https://ludo.libretro.com/) or [RetroArch](https://www.retroarch.com/).


<!-- On a device with either [Ludo](https://ludo.libretro.com/) or [RetroArch](https://www.retroarch.com/): -->

## Controls
Navigate with arrow keys or mouse. Click, `enter` or `space` places a stone.

Keyboard shortcuts:
- `n` : new game
- `p` : pass
- `esc` : exit

## Features

### Current
- Board
- Stones

### Future
- Stone removal
- Ko
- GTP protocol
- Zero configuration GTP engines
- Legal move detection
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
