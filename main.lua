love = love -- so LSP stops yelling at me
require("board")
require("logic")

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
  love.graphics.translate(TOP_LEFT_BOARD.x, TOP_LEFT_BOARD.y) --origin corner of board
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
  STONES = {}
  CURRENT = { x = 1, y = 1 }
  WIDTH, HEIGHT = love.graphics.getDimensions()
  MIN_COORD = 0101
  MAX_COORD = SIZE + SIZE * 100
end

function draw_stones()
  for _, stone in pairs(STONES) do
    love.graphics.setColor(0, 0, 0)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(stone.img, stone.x - 1, stone.y - 1, 1 / stone_width, 1 / stone_height)
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
    STONES = {}
    love.audio.play(new_game_sound)
  end
  if key == "p" then
    TO_PLAY = -TO_PLAY
    love.audio.play(pass_sound)
  end
  if key == "return" or key == "space" then
    place_stone()
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    place_stone()
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

-- can recieve x, y or table with [x] and [y]
function one_one_to_coord(curr, y)
  if not y then
    return 100 * curr.x + curr.y
  else
    local x = curr
    return (100 * x) + y
  end
end

function place_stone()
  local coord = one_one_to_coord(CURRENT)
  if is_spot_filled() then
    return
  end

  local up = coord - 1
  local down = coord + 1
  local left = coord + 100
  local right = coord - 100

--   for _, dir in ipairs({ up, down, left, right }) do
--     if coord_on_board(dir) and STONES[dir].color == -TO_PLAY then
--       local stones_to_remove = capture(dir, -TO_PLAY, { coord }, {})
--       if stones_to_remove ~= nil then
--         unplace_stones(stones_to_remove)
--         love.audio.play(capture_sound)
--       end
--     end
--   end

--   if self_capture() then
--     return
--   end
  local new_stone = {}
  if TO_PLAY == BLACK then
    new_stone = { color = BLACK, img = BLACK_STONE, x = CURRENT.x, y = CURRENT.y }
  else
    new_stone = { color = WHITE, img = WHITE_STONE, x = CURRENT.x, y = CURRENT.y }
  end
  STONES[coord] = new_stone
  local randomIndex = math.random(1, #stone_placement_sound)
  love.audio.play(stone_placement_sound[randomIndex])
  TO_PLAY = -TO_PLAY
end

function unplace_stones(to_remove)
  for k, stone in pairs(to_remove) do
    table.remove(stone)
    table.remove(k)
    --     stone:release()
  end
end

function on_board(x, y)
  return x > 0 and x <= SIZE and y > 0 and y <= SIZE
end

function mouse_board_hint() -- not on lutro!
  cursor_x, cursor_y = love.mouse.getPosition()
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
  stone_width, stone_height = BLACK_STONE:getDimensions()
end

function load_sounds()
  stone_placement_sound = {}
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
    stone_placement_sound[i] = love.audio.newSource(file, "static")
  end
  pass_sound = love.audio.newSource("assets/audio/pass.mp3", "static")
  new_game_sound = love.audio.newSource("assets/audio/newgame.mp3", "static")
  capture_sound = love.audio.newSource("assets/audio/capture0.mp3", "static")
end
