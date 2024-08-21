--[[
dango.lua -- a cross platform, lightweight Go board
Copyright (C) 2024 gsobell

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.]]

require("board")
require("logic")
require("assets")
require("record")
-- require("gtp")
-- require("sgf")
-- require("themes")

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
  BOARD_SCALE = 0.9
  GRID_SCALE = 0.8
  STONE_SCALE = 1
  DEFAULT_SIZE = 9
  COORDINATES = true
  SIZE = DEFAULT_SIZE
  BLACK, WHITE = -1, 1
  TO_PLAY = BLACK
  CURRENT = { x = math.ceil(SIZE / 2), y = math.ceil(SIZE / 2) }
  WIDTH, HEIGHT = love.graphics.getDimensions()
  STONES = generate_stones()
  GAME_RECORD = record.new()
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
        love.graphics.draw(
          stone.img,
          stone.x - 0.5,
          stone.y - 0.5,
          0,
          1 / STONE_WIDTH * STONE_SCALE,
          1 / STONE_HEIGHT * STONE_SCALE,
          STONE_WIDTH / 2,
          STONE_HEIGHT / 2
        )
      end
    end
  end
end

function love.resize(w, h) --not in lutro
  if not initial_resize then
    WIDTH, HEIGHT = w, h
    -- TODO do check here if to show hoshi, cuttoff dpi tdb
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
    GAME_RECORD = record.new()
    love.audio.play(NEW_GAME_SOUND)
  end
  if key == "u" then
    local last_turn = GAME_RECORD:undo()
    if not last_turn then
      return
    end
    local color, x, y, to_replace = last_turn.color, last_turn.x, last_turn.y, last_turn.captured_stones
        STONES[x][y] = nil
        -- TODO add stone retrieval with undo
    --     for _, group in pairs(to_replace) do
    --       if group then
    --         for _, stone in pairs(group) do
    --           local i, j = stone.x, stone.y
    --           if -color == BLACK then
    --             STONES[i][j] = { color = BLACK, img = BLACK_STONE, x = i, y = j }
    --           else
    --             STONES[i][j] = { color = WHITE, img = WHITE_STONE, x = i, y = j }
    --           end
    --         end
    --       end
    --     end
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
    love.audio.play(ILLEGAL_PLACEMENT_SOUND)
    return
  end
  local directions = adjacent(CURRENT.x, CURRENT.y)

  do
    -- capture checks
    to_remove = {}
    for _, direction in ipairs(directions) do
      local x, y = direction.x, direction.y
      if on_board(x, y) and STONES[x][y] ~= nil and STONES[x][y].color ~= TO_PLAY then
        table.insert(to_remove, capture(STONES[x][y], -TO_PLAY, CURRENT))
      end
    end

    for _, group in pairs(to_remove) do
      unplace_stones(group)
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
    love.audio.play(ILLEGAL_PLACEMENT_SOUND)
    return
  end

  ::placement::

  if TO_PLAY == BLACK then
    STONES[CURRENT.x][CURRENT.y] = { color = BLACK, img = BLACK_STONE, x = CURRENT.x, y = CURRENT.y }
  else
    STONES[CURRENT.x][CURRENT.y] = { color = WHITE, img = WHITE_STONE, x = CURRENT.x, y = CURRENT.y }
  end

  GAME_RECORD:add_turn(TO_PLAY, CURRENT.x, CURRENT.y, to_remove)

  local randomIndex = math.random(1, #STONE_PLACEMENT_SOUND)
  love.audio.play(STONE_PLACEMENT_SOUND[randomIndex])
  TO_PLAY = -TO_PLAY
end

function unplace_stones(group)
  if not group then
    return false
  end
  for _, stone in pairs(group) do
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
