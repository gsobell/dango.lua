## To-do Queue
- Finish undo
  - [ ] Note that deep copying and storing STONES may be more efficient than "rewinding" the table
- Ko, based on data structure
- Command line args to override defaults, see lua 'regex'
- GTP games
- Use metatable for stones
- sgf handling

## General
- Touchscreen support
- Auto-detect device profile
- Add window, android to make
- Command line options and help
- love 2D and gnugo etc installation helper
- Add stone type by means of metatables

## Release Checklist
- Add screenshot(s) to readme
- Confirm gnugo works
- Refactor and format code
- dango.lua --> something else?
- Automated tests; sanity checks
- Contribution guidelines for testing/features

## Record
- Allow for branches

## GTP
- GTP implementation
- Lua popen() only supports read or write, so make temp, and redirect gtp to temp

## SGF
- Save games as SGF
- View SGF comments

## Profiles
- Desktop
- Touchscreen
  - [ ] No hinting
- eInk
  - [ ] Inherits Touchscreen
  - [ ] Lower refresh rate
  - [ ] Default theme
- Embedded
  - [ ] Set non-compatible functions to `nil`
  - [ ] No mouse

## Lutro
- compatibility mode
- lutro-helper.sh

## UI
- Hint to show last played
- Add simple menu
- Add side A-1 legends (already implemented in gtp.lua)
- Game manager for ongoing games
- Smooth hint transition
- Icon for .exe

## Themes
- Legwork needed to support styled shapes
- Themes
  - [ ] E-ink
  - [ ] LCD monotone - see Kawasaki Igo-Master
  - [ ] Kifu - see sabaki
  - [ ] Other OGS themes

## Translations
- Japanese
- Korean
- Chinese
