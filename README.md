# dango.lua 🍡

`dango.lua` is a Go board built with [LÖVE](https://www.love2d.org/)

> **dan•go** [だんご]  
> noun
> 1. A Japanese dumpling made from *mochiko* (rice flour) 
> 2. A Japanese [go term](https://senseis.xmp.net/?Dango), meaning "dumpling shape";  a solid mass of stones without eyes, and with few liberties

## Motivation
To make a no-frills Go client that supports [GTP](https://www.lysator.liu.se/~gunnar/gtp/gtp2-spec-draft2/gtp2-spec.html) engines.

A lighweight cross-platform alternative to [Sabaki](https://github.com/SabakiHQ/Sabaki), those who don't have ~300MB to spare for Electron.

Care was taken to only used [API](https://github.com/libretro/lutro-status) exposed by [Lutro](https://lutro.libretro.com/), a subset of [LÖVE 2D](https://www.love2d.org/).
This will allow `dango` to run on any embedded device that can run Libretto's [Ludo](https://ludo.libretro.com/) or [RetroArch](https://www.retroarch.com/).

### Installation
On a desktop:
```sh
```

On a device with either [Ludo](https://ludo.libretro.com/) or [RetroArch](https://www.retroarch.com/):
```sh
```

## Features

### Current
- None

### Future
- Stone removal
- Legal move detection
- GTP protocol
- Themes

***
See also:

[dango](https://github.com/gsobell/dango) -
a nCurses Go board for the terminal

