SIZE = 9
BOARD_SCALE = 0.9

-- game init
function love.load()
  success = love.window.setFullscreen(true) -- missing from Lutro
  width, height = love.graphics.getDimensions()
  --wood
  board_bg = love.graphics.newImage("assets/board.png")
  square_edge = math.min(width * BOARD_SCALE, height * BOARD_SCALE)
  board = love.graphics.newQuad(0, 0, square_edge, square_edge, board_bg:getDimensions())
  board_bg:setWrap("repeat", "repeat")

  --tatami
  tatami = love.graphics.newImage("assets/tatami.png")
end

function love.draw()
  -- tatami
  tileWidth = tatami:getWidth()
  tileHeight = tatami:getHeight()
  local numX = math.ceil(width / tileWidth)
  local numY = math.ceil(height / tileHeight)
  for x = 0, numX - 1 do
    for y = 0, numY - 1 do
      love.graphics.draw(tatami, x * tileWidth, y * tileHeight)
    end
  end
  -- board
  local x = (width - square_edge) / 2
  local y = (height - square_edge) / 2
  love.graphics.draw(board_bg, board, x, y)
  love.graphics.setColor(love.math.colorFromBytes(200, 146, 58))
    love.graphics.setLineWidth(5)
  love.graphics.rectangle("line", x, y, square_edge, square_edge, 4, 4 )
  -- lines

  offset = square_edge / SIZE * 0.5
  love.graphics.translate(x + offset, y + offset)
  local cellSize = square_edge / SIZE
  local gridLines = {}

  local windowWidth, windowHeight = love.graphics.getDimensions()

  -- Vertical lines.
  for x = 1, square_edge, cellSize do
    local line = { x, 0, x, square_edge - 2 * offset }
    table.insert(gridLines, line)
  end
  -- Horizontal lines.
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
  end
  love.graphics.setColor(1, 1, 1) -- RGB for white

  -- star points
end
