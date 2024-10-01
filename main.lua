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

local initial_resize = true

function love.load()
  require("util")
  require("assets")
  require("board")
  require("stones")
  require("record")
  require("logic")
  require("hint")
  require("sgf")
  require("gtp")
  -- require("menu")
  -- require("themes")
  love.keyboard.setKeyRepeat(true, 5)
  --   love.window.setFullscreen(true) -- missing from Lutro
  flags()
  load_globals()
  new_game()
  love.window.setMode(50, 50, { resizable = true, minwidth = 10, minheight = 10 })
  draw_tatami()
  draw_board()
  load_stones()
  load_sounds()
end

function love.update()
  if IS_AI.black and TO_PLAY == BLACK and DRAW_AFTER_PLACE then
    gtp_turn(GTP_BLACK_CO)
  end
  if IS_AI.white and TO_PLAY == WHITE and DRAW_AFTER_PLACE then
    gtp_turn(GTP_WHITE_CO)
  end
  DRAW_AFTER_PLACE = false -- makes sure draws before yields to engine
end

function love.draw()
  draw_bg()
  love.graphics.push()
  love.graphics.translate(TOP_LEFT_BOARD.x, TOP_LEFT_BOARD.y) -- 0,0 of board
  love.graphics.scale(SQUARE)
  draw_stones()
  draw_hints()
  love.graphics.pop()
  DRAW_AFTER_PLACE = true
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
  KOMI = 6.5
  CURRENT = { x = math.ceil(SIZE / 2), y = math.ceil(SIZE / 2) }
  WIDTH, HEIGHT = love.graphics.getDimensions()
  IS_AI = { black = false, white = false }
end

function love.resize(w, h) --not in lutro
  if not initial_resize then
    print("Resize: " .. w .. " x " .. h)
    WIDTH, HEIGHT = w, h
    draw_tatami()
    draw_board()
  end
  initial_resize = false
end

function new_game()
  STONES = generate_stones()
  RECORD = generate_record()
  JUST_PLAYED = { x = nil, y = nil }
  GTP_BLACK_CO, GTP_WHITE_CO = gtp_setup()
end

function draw_bg()
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(BG_CANVAS, 0, 0)
  love.graphics.setBlendMode("alpha")
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
    RECORD = generate_record()
    JUST_PLAYED = { x = nil, y = nil }
    GTP_BLACK_CO, GTP_WHITE_CO = gtp_setup()
    love.audio.play(NEW_GAME_SOUND)
  end
  if key == "u" then
    -- TODO GTP moves again before second undo
    RECORD:undo()
    JUST_PLAYED.undo = true
  end
  if key == "p" then
    TO_PLAY = -TO_PLAY
    RECORD:pass()
    JUST_PLAYED.x, JUST_PLAYED.y = nil, nil
    love.audio.play(PASS_SOUND)
  end
  if key == "return" or key == "space" then
    place_stone()
  end
end

function love.mousepressed(_, _, button)
  if button == 1 then
    local cursor_x, cursor_y = love.mouse.getPosition()
    local x = math.ceil((cursor_x - TOP_LEFT_BOARD.x) / SQUARE)
    local y = math.ceil((cursor_y - TOP_LEFT_BOARD.y) / SQUARE)
    if on_board(x, y) then
      place_stone()
    end
  end
end

function direction(x, y, key)
  if key == "up" or key == "k" then
    y = y - 1
  elseif key == "down" or key == "j" then
    y = y + 1
  elseif key == "left" or key == "h" then
    x = x - 1
  elseif key == "right" or key == "l" then
    x = x + 1
  end
  return { x = x, y = y }
end
