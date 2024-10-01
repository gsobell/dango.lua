function load_sounds()
  STONE_PLACEMENT_SOUND = {}
  STONE_CAPTURE_SOUND = {}
  local placement_files = {
    "assets/audio/0.mp3",
    "assets/audio/1.mp3",
    "assets/audio/2.mp3",
    "assets/audio/3.mp3",
    "assets/audio/4.mp3",
  }
  local capture_files = {
    "assets/audio/capture0.mp3",
    "assets/audio/capture1.mp3",
    "assets/audio/capture2.mp3",
    "assets/audio/capture3.mp3",
    "assets/audio/capture4.mp3",
  }
  for i, file in ipairs(placement_files) do
    STONE_PLACEMENT_SOUND[i] = love.audio.newSource(file, "static")
  end
  for i, file in ipairs(capture_files) do
    STONE_CAPTURE_SOUND[i] = love.audio.newSource(file, "static")
  end
  PASS_SOUND = love.audio.newSource("assets/audio/pass.mp3", "static")
  NEW_GAME_SOUND = love.audio.newSource("assets/audio/newgame.mp3", "static")
  ILLEGAL_PLACEMENT_SOUND = love.audio.newSource("assets/audio/knock.mp3", "static")
end

function load_stones()
  BLACK_STONE = love.graphics.newImage("assets/black.png")
  WHITE_STONE = love.graphics.newImage("assets/white.png")
  STONE_WIDTH, STONE_HEIGHT = BLACK_STONE:getDimensions()
end

function load_board_textures()
  return love.graphics.newImage("assets/wood_grain.png"), love.graphics.newImage("assets/tatami.png")
end
