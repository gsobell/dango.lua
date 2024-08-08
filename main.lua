love = love -- so LSP stops yelling at me
SIZE = 15
BOARD_SCALE = 0.9

function love.load()
  success = love.window.setFullscreen(true) -- missing from Lutro
  width, height = love.graphics.getDimensions()

  stones = {}
  draw_tatami()
  draw_board()
end

function love.draw()
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(bg_canvas, 0, 0)
end

function love.update() end

function draw_tatami()
  --tatami
  tatami = love.graphics.newImage("assets/tatami.png")
  bg_canvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
  love.graphics.setCanvas(bg_canvas)
  tileWidth = tatami:getWidth()
  tileHeight = tatami:getHeight()
  local numX = math.ceil(width / tileWidth)
  local numY = math.ceil(height / tileHeight)
  for x = 0, numX - 1 do
    for y = 0, numY - 1 do
      love.graphics.draw(tatami, x * tileWidth, y * tileHeight)
    end
  end
end

function draw_board()
  -- board
  board_bg = love.graphics.newImage("assets/board.png")
  square_edge = math.min(width * BOARD_SCALE, height * BOARD_SCALE)
  board = love.graphics.newQuad(0, 0, square_edge, square_edge, board_bg:getDimensions())
  board_bg:setWrap("repeat", "repeat")
  local x = (width - square_edge) / 2
  local y = (height - square_edge) / 2
  love.graphics.draw(board_bg, board, x, y)
  love.graphics.setColor(love.math.colorFromBytes(200, 146, 58))
  love.graphics.setLineWidth(5)
  love.graphics.rectangle("line", x, y, square_edge, square_edge, 4, 4)

  -- lines
  square = square_edge / SIZE
  offset = square * 0.5
  love.graphics.translate(x + offset, y + offset)
  local cellSize = square_edge / SIZE
  local gridLines = {}

  local windowWidth, windowHeight = love.graphics.getDimensions()

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
      love.graphics.circle("fill", square * i, square * j, 7)
    end
  end
  if SIZE % 2 == 1 then
    love.graphics.circle("fill", square * center, square * center, 7)
  end

  love.graphics.setCanvas()
end
