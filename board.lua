-- refactor this file into smaller functions, calculate local needed in file in main board func

function draw_board()
  -- board
  local board_bg = love.graphics.newImage("assets/wood_grain.png")
  local square_edge = math.min(WIDTH * BOARD_SCALE, HEIGHT * BOARD_SCALE)
  local board = love.graphics.newQuad(0, 0, square_edge, square_edge, board_bg:getDimensions())
  board_bg:setWrap("repeat", "repeat")
  local x = (WIDTH - square_edge) / 2
  local y = (HEIGHT - square_edge) / 2
  love.graphics.draw(board_bg, board, x, y)
  love.graphics.setColor(love.math.colorFromBytes(200, 146, 58))
  love.graphics.setLineWidth(5)
  love.graphics.rectangle("line", x, y, square_edge, square_edge, 4, 4)

  square_edge = square_edge * GRID_SCALE
  SQUARE = square_edge / SIZE
  local offset = SQUARE * 0.5
  x = (WIDTH - square_edge) / 2
  y = (HEIGHT - square_edge) / 2
  TOP_LEFT_BOARD = { x = x, y = y }
  BOTTOM_RIGHT_BOARD = { x = x + square_edge, y = y + square_edge }
  love.graphics.translate(x + offset, y + offset)
  local cellSize = square_edge / SIZE
  local gridLines = {}
  -- TODO  use: love.graphics.scale(square) here:

  for i = 1, square_edge, cellSize do
    local line = { i, 0, i, square_edge - 2 * offset }
    table.insert(gridLines, line)
  end
  for j = 1, square_edge, cellSize do
    local line = { 0, j, square_edge - 2 * offset, j }
    table.insert(gridLines, line)
  end
  if SIZE > 9 then
    love.graphics.setLineWidth(1)
  else
    love.graphics.setLineWidth(2)
  end
  love.graphics.setColor(0, 0, 0)
  for _, line in ipairs(gridLines) do
    love.graphics.line(line)
    --     x = x - 1
  end

  -- coordinates
  --TODO add A1 style, fix to stone size, so stone doesn't cover
  if COORDINATES then
    love.graphics.setFont(love.graphics.newFont(20))
    for i = 1, SIZE do
      love.graphics.print(i, i * cellSize - cellSize, -cellSize, 0, 1, 1, love.graphics.getFont():getWidth(i) / 2, 0)
    end
    for j = 1, SIZE do
      love.graphics.print(j, -cellSize, j * cellSize - cellSize, 0, 1, 1, 0, love.graphics.getFont():getWidth(j) / 2)
    end
  end

  -- hoshi [star points] MUST be made small when board size scalled down
  local center = (SIZE - 1) / 2
  local from_edge = 4
  local hoshi
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
      love.graphics.circle("fill", SQUARE * i + 1, SQUARE * j + 1, 7)
    end -- +1 is to center on line width
  end
  if SIZE % 2 == 1 then
    love.graphics.circle("fill", SQUARE * center + 1, SQUARE * center + 1, 7)
  end
  love.graphics.setCanvas()
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
