-- this file is both valid Lua and TOML [!!!]

default = {
  images = {
    black_stone = "default/white.png",
    white_stone = "default/white.png",
    bg_tile = "default/tatami.png",
    board_pattern = "default/wood_grain.png",
  },
  sounds = {
    placement = {
      "audio/0.mp3",
      "audio/1.mp3",
      "audio/2.mp3",
      "audio/3.mp3",
      "audio/4.mp3",
    },
    capture = {
      "audio/capture0.mp3",
      "audio/capture1.mp3",
      "audio/capture2.mp3",
      "audio/capture3.mp3",
      "audio/capture4.mp3",
    },
    pass = { "audio/pass.mp3" },
    new_game = { "audio/newgame.mp3" },
    illegal = { "audio/knock.mp3" }
  }
}
