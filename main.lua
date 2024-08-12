love = love -- so LSP stops yelling at me
-- require "gtp"
require("board")

function love.load()
  love.keyboard.setKeyRepeat(true, 5)
  love.window.setFullscreen(true) -- missing from Lutro
  BOARD_SCALE = 0.9
  DEFAULT_SIZE = 9
  SIZE = DEFAULT_SIZE
  BLACK, WHITE = -1, 1
  TO_PLAY = BLACK
  STONES = {}
  WIDTH, HEIGHT = love.graphics.getDimensions()
  draw_tatami()
  draw_board()
  load_stones()
  CURRENT = { x = 1, y = 1 }
end

function love.draw()
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(BG_CANVAS, 0, 0)
  --   mouse_board_hint() -- turn back on after {1, 1} sorted

  love.graphics.push()
  love.graphics.translate(TOP_LEFT_BOARD.x, TOP_LEFT_BOARD.y) --origin corner of board
  love.graphics.scale(square)
  draw_stones()
  draw_hint()
  love.graphics.pop()
end

function love.update() end

-- until i can figure out the wonky image assets:
function draw_stones()
  for _, stone in pairs(STONES) do
    if stone.img == BLACK_STONE then
      love.graphics.setColor(0, 0, 0)
    else
      love.graphics.setColor(1, 1, 1)
    end
    --     love.graphics.draw(stone.img, stone.x - 1, stone.y - 1, 1 / square, 1 / square)
    love.graphics.circle("fill", stone.x - 0.5, stone.y - 0.5, 0.5)
  end
end

function draw_hint()
  if TO_PLAY == BLACK then
    love.graphics.setColor(0, 0, 0, 0.1)
  else
    love.graphics.setColor(0.2, 0.2, 0.2, 0.1)
  end
  love.graphics.circle("fill", CURRENT.x - 0.5, CURRENT.y - 0.5, 0.2)
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

function place_stone()
  -- receives {1,1} style cordinates
  if illegal_move() then
    return
  end
  local cord = tostring(CURRENT.x) .. tostring(CURRENT.y)
  if TO_PLAY == BLACK then
    new_stone = { img = BLACK_STONE, x = CURRENT.x, y = CURRENT.y }
  else
    new_stone = { img = WHITE_STONE, x = CURRENT.x, y = CURRENT.y }
  end
  STONES[cord] = new_stone
  TO_PLAY = -TO_PLAY
end

function on_board(x, y)
  return x > 0 and x <= SIZE and y > 0 and y <= SIZE
end

function illegal_move()
  local cord = tostring(CURRENT.x) .. tostring(CURRENT.y)
  return STONES[cord] ~= nil
end

-- not on lutro!
--[[
function mouse_board_hint()
  love.graphics.setColor(0, 0, 0, 0.1)
  cursor_x, cursor_y = love.mouse.getPosition()
  if on_board(cursor_x, cursor_y) then
    --       love.mouse.setVisible(false)
    local x = math.floor((cursor_x - TOP_LEFT_BOARD.x) / square) * square + TOP_LEFT_BOARD.x + offset
    local y = math.floor((cursor_y - TOP_LEFT_BOARD.y) / square) * square + TOP_LEFT_BOARD.y + offset
    HINT = { x = x, y = y }
  else
    --           love.mouse.setVisible(true)

    love.graphics.setColor(1, 1, 1, 1)
  end
end
--]]

function load_stones()
  BLACK_STONE = love.graphics.newImage("assets/black.png")
  WHITE_STONE = love.graphics.newImage("assets/white.png")

  --   stone_width, stone_height = BLACK_STONE:getDimensions()
  --   scale = square / stone_width
  --   scaled_stone_height = stone_height * scale
end
