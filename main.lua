love = love -- so LSP stops yelling at me
-- require "gtp"

function love.load()
  love.keyboard.setKeyRepeat(true, 5)
  BOARD_SCALE = 0.9
  DEFAULT_SIZE = 19
  SIZE = DEFAULT_SIZE
  BLACK, WHITE = 0, 1
  TO_PLAY = BLACK
  local success = love.window.setFullscreen(true) -- missing from Lutro

  WIDTH, HEIGHT = love.graphics.getDimensions()

  black = love.graphics.newImage("assets/black.png")
  white = love.graphics.newImage("assets/white.png")

  stones = {}
  draw_tatami()
  draw_board()
  HINT = { x = TOP_LEFT_BOARD.x + offset, y = TOP_LEFT_BOARD.y + offset }
end

function love.draw()
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(BG_CANVAS, 0, 0)
  mouse_board_hint()
  love.graphics.setColor(0, 0, 0, 0.1)

  love.graphics.circle("fill", HINT.x, HINT.y, 12)
  love.graphics.setColor(1, 1, 1, 1)
end
function love.update() end

function love.keypressed(key)
  new = direction(HINT.x, HINT.y, key)
  if on_board(new.x, new.y) then
    HINT = new
  end
  if key == "escape" then
    love.event.quit()
  end
end

function direction(x, y, key)
  if key == "up" then
    y = y - square
  elseif key == "down" then
    y = y + square
  elseif key == "left" then
    x = x - square
  elseif key == "right" then
    x = x + square
  end
  return { x = x, y = y }
end

function on_board(x, y)
  return x > TOP_LEFT_BOARD.x and x <= BOTTOM_RIGHT_BOARD.x and y > TOP_LEFT_BOARD.y and y <= BOTTOM_RIGHT_BOARD.y
end

-- not on lutro!
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

function draw_tatami()
  --tatami
  local tatami = love.graphics.newImage("assets/tatami.png")
  BG_CANVAS = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
  love.graphics.setCanvas(BG_CANVAS)
  local tileWidth, tileHeight = tatami:getDimensions()
  local numX = math.ceil(WIDTH / tileWidth)
  local numY = math.ceil(HEIGHT / tileHeight)
  for x = 0, numX - 1 do
    for y = 0, numY - 1 do
      love.graphics.draw(tatami, x * tileWidth, y * tileHeight)
    end
  end
end

function draw_board()
  -- board
  board_bg = love.graphics.newImage("assets/board.png")
  square_edge = math.min(WIDTH * BOARD_SCALE, HEIGHT * BOARD_SCALE)
  board = love.graphics.newQuad(0, 0, square_edge, square_edge, board_bg:getDimensions())
  board_bg:setWrap("repeat", "repeat")
  local x = (WIDTH - square_edge) / 2
  local y = (HEIGHT - square_edge) / 2
  love.graphics.draw(board_bg, board, x, y)
  love.graphics.setColor(love.math.colorFromBytes(200, 146, 58))
  love.graphics.setLineWidth(5)
  love.graphics.rectangle("line", x, y, square_edge, square_edge, 4, 4)
  -- lines
  square = square_edge / SIZE
  offset = square * 0.5
  TOP_LEFT_BOARD = { x = x, y = y }
  BOTTOM_RIGHT_BOARD = { x = x + square_edge, y = y + square_edge }
  love.graphics.translate(x + offset, y + offset)
  local cellSize = square_edge / SIZE
  local gridLines = {}

  for x = 1, square_edge, cellSize do
    local line = { x, 0, x, square_edge - 2 * offset }
    table.insert(gridLines, line)
  end
  for y = 1, square_edge, cellSize do
    local line = { 0, y, square_edge - 2 * offset, y }
    table.insert(gridLines, line)
  end
  if SIZE > 9 then
    love.graphics.setLineWidth(1)
  else
    love.graphics.setLineWidth(2)
  end

  love.graphics.setColor(0, 0, 0)
  for i, line in ipairs(gridLines) do
    love.graphics.line(line)
    x = x - 1
  end

  -- hoshi [star points]
  center = (SIZE - 1) / 2
  from_edge = 4
  if SIZE > 15 and (SIZE % 2 == 1) then
    hoshi = { from_edge - 1, (SIZE - 1) / 2, SIZE - from_edge }
  elseif SIZE >= 13 then
    hoshi = { from_edge - 1, SIZE - from_edge }
  else
    from_edge = 3
    hoshi = { from_edge - 1, SIZE - from_edge }
  end
  for _, i in ipairs(hoshi) do
    for _, j in ipairs(hoshi) do
      love.graphics.circle("fill", square * i + 1, square * j + 1, 7)
    end -- +1 is to center on line width
  end
  if SIZE % 2 == 1 then
    love.graphics.circle("fill", square * center + 1, square * center + 1, 7)
  end
  love.graphics.setCanvas()
end
