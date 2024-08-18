require("board")
require("logic")
-- require("gtp")

local initial_resize = true

function love.load()
  love.keyboard.setKeyRepeat(true, 5)
  love.window.setFullscreen(true) -- missing from Lutro
  load_globals()
  --   love.window.setMode(50, 50, { resizable= true, minwidth=20, minheight=10} )
  draw_tatami()
  draw_board()
  load_stones()
  load_sounds()
end

function love.update() end

function love.draw()
  draw_bg()
  love.graphics.push()
  love.graphics.translate(TOP_LEFT_BOARD.x, TOP_LEFT_BOARD.y) -- 0,0 of board
  love.graphics.scale(square)
  draw_stones()
  mouse_board_hint()
  draw_hint()
  love.graphics.pop()
end

function load_globals()
  BOARD_SCALE = 0.90
  DEFAULT_SIZE = 9
  SIZE = DEFAULT_SIZE
  BLACK, WHITE = -1, 1
  TO_PLAY = BLACK
  CURRENT = { x = math.ceil(SIZE / 2), y = math.ceil(SIZE / 2) }
  WIDTH, HEIGHT = love.graphics.getDimensions()
  STONES = generate_stones()
end

function generate_stones()
  STONES = {}
  for i = 1, SIZE do
    STONES[i] = {}
    for j = 1, SIZE do
      STONES[i][j] = nil
    end
  end
  return STONES
end

function draw_stones()
  for _, row in pairs(STONES) do
    for _, stone in pairs(row) do
      if stone then
        love.graphics.setColor(0, 0, 0)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(stone.img, stone.x - 1, stone.y - 1, 1 / STONE_WIDTH, 1 / STONE_HEIGHT)
      end
    end
  end
end

function love.resize(w, h) --not in lutro
  if not initial_resize then
    WIDTH, HEIGHT = w, h
    draw_tatami()
    draw_board()
  end
  initial_resize = false
end

function draw_bg()
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(BG_CANVAS, 0, 0)
  love.graphics.setBlendMode("alpha")
end

function draw_hint()
  if TO_PLAY == BLACK then
    love.graphics.setColor(0, 0, 0, 0.1)
  else
    love.graphics.setColor(0.2, 0.2, 0.2, 0.1)
  end
  love.graphics.circle("fill", CURRENT.x - 0.5, CURRENT.y - 0.5, 0.15)
  love.graphics.setColor(1, 1, 1)
end

function love.keypressed(key)
  local new = direction(CURRENT.x, CURRENT.y, key)
  if on_board(new.x, new.y) then
    CURRENT = new
  end
  if key == "escape" then
    love.event.quit()
  end
  if key == "n" then
    STONES = generate_stones()
    KO = { x = nil, y = nil }
    love.audio.play(NEW_GAME_SOUND)
  end
  if key == "p" then
    TO_PLAY = -TO_PLAY
    love.audio.play(PASS_SOUND)
  end
  if key == "return" or key == "space" then
    place_stone()
  end
end

function love.mousepressed(_, _, button)
  if button == 1 then
    local cursor_x, cursor_y = love.mouse.getPosition()
    local x = math.ceil((cursor_x - TOP_LEFT_BOARD.x) / square)
    local y = math.ceil((cursor_y - TOP_LEFT_BOARD.y) / square)
    if on_board(x, y) then
      place_stone()
    end
  end
end

function direction(x, y, key)
  if key == "up" then
    y = y - 1
  elseif key == "down" then
    y = y + 1
  elseif key == "left" then
    x = x - 1
  elseif key == "right" then
    x = x + 1
  end
  return { x = x, y = y }
end

function adjacent(x, y)
  local to_return = {}
  local directions = {
    { x = 0, y = 1 },
    { x = 1, y = 0 },
    { x = 0, y = -1 },
    { x = -1, y = 0 },
  }
  for _, direction in ipairs(directions) do
    local new_x = x + direction.x
    local new_y = y + direction.y
    table.insert(to_return, { x = new_x, y = new_y })
  end
  return to_return
end

function on_board(x, y)
  return x > 0 and x <= SIZE and y > 0 and y <= SIZE
end

function place_stone()
  if is_spot_filled() then
    return
  end

  local directions = adjacent(CURRENT.x, CURRENT.y)

  do
    -- capture checks
    for _, direction in ipairs(directions) do
      local x, y = direction.x, direction.y
      if on_board(x, y) and STONES[x][y] ~= nil and STONES[x][y].color ~= TO_PLAY then
        unplace_stones(capture(STONES[x][y], -TO_PLAY, CURRENT))
      end
    end

    -- liberty check
    for _, direction in ipairs(directions) do
      local x, y = direction.x, direction.y
      if on_board(x, y) and STONES[x][y] == nil then
        goto placement
      end
    end

    -- self-atari check
    for _, direction in ipairs(directions) do
      local x, y = direction.x, direction.y
      if
        on_board(x, y)
        and STONES[x][y] ~= nil
        and STONES[x][y].color == TO_PLAY
        and not capture(STONES[x][y], TO_PLAY, CURRENT)
      then
        goto placement
      end
    end
    return
  end

  ::placement::
  if TO_PLAY == BLACK then
    STONES[CURRENT.x][CURRENT.y] = { color = BLACK, img = BLACK_STONE, x = CURRENT.x, y = CURRENT.y }
  else
    STONES[CURRENT.x][CURRENT.y] = { color = WHITE, img = WHITE_STONE, x = CURRENT.x, y = CURRENT.y }
  end
  --   update_ko()
  local randomIndex = math.random(1, #STONE_PLACEMENT_SOUND)
  love.audio.play(STONE_PLACEMENT_SOUND[randomIndex])
  TO_PLAY = -TO_PLAY
end

function unplace_stones(to_remove)
  if not to_remove then
    return false
  end
  for _, stone in pairs(to_remove) do
    local x = stone.x
    local y = stone.y
    STONES[x][y] = nil
  end
  local randomIndex = math.random(1, #STONE_CAPTURE_SOUND)
  love.audio.play(STONE_CAPTURE_SOUND[randomIndex])
  return true
end

function mouse_board_hint() -- not on lutro!
  local cursor_x, cursor_y = love.mouse.getPosition()
  local x = math.ceil((cursor_x - TOP_LEFT_BOARD.x) / square)
  local y = math.ceil((cursor_y - TOP_LEFT_BOARD.y) / square)
  if on_board(x, y) then
    CURRENT.x = x
    CURRENT.y = y
  end
end

function load_stones()
  BLACK_STONE = love.graphics.newImage("assets/black.png")
  WHITE_STONE = love.graphics.newImage("assets/white.png")
  STONE_WIDTH, STONE_HEIGHT = BLACK_STONE:getDimensions()
end

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
end
