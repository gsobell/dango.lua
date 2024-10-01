-- refactor this file into smaller functions, calculate local needed in file in main board func

function draw_board()
  -- board
  local board_bg, _ = load_board_textures()
  local board_edge = math.min(WIDTH * BOARD_SCALE, HEIGHT * BOARD_SCALE)
  local board = love.graphics.newQuad(0, 0, board_edge, board_edge, board_bg:getDimensions())
  local x, y = (WIDTH - board_edge) / 2, (HEIGHT - board_edge) / 2
  local scaled_edge = board_edge * GRID_SCALE
  SQUARE = scaled_edge / SIZE
  local offset = SQUARE * 0.5

  board_bg:setWrap("repeat", "repeat")
  love.graphics.draw(board_bg, board, x, y)
  love.graphics.setColor(love.math.colorFromBytes(200, 146, 58))
  love.graphics.setLineWidth(5)
  love.graphics.rectangle("line", x, y, board_edge, board_edge, 4, 4)

  x, y = (WIDTH - scaled_edge) / 2, (HEIGHT - scaled_edge) / 2
  TOP_LEFT_BOARD = { x = x, y = y }
  BOTTOM_RIGHT_BOARD = { x = x + scaled_edge, y = y + scaled_edge }
  local cellSize = scaled_edge / SIZE

  gridlines = function()
    love.graphics.translate(x + offset, y + offset)
    local gridLines = {}
    for i = 1, scaled_edge, cellSize do
      local line = { i, 0, i, scaled_edge - 2 * offset }
      table.insert(gridLines, line)
    end
    for j = 1, scaled_edge, cellSize do
      local line = { 0, j, scaled_edge - 2 * offset, j }
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
    end
  end

  coordinates_one_one = function()
    if COORDINATES then
      love.graphics.setFont(love.graphics.newFont(20))
      for i = 1, SIZE do
        love.graphics.print(i, i * cellSize - cellSize, -cellSize, 0, 1, 1, love.graphics.getFont():getWidth(i) / 2, 0)
      end
      for j = 1, SIZE do
        love.graphics.print(j, -cellSize, j * cellSize - cellSize, 0, 1, 1, 0, love.graphics.getFont():getWidth(j) / 2)
      end
    end
  end

  coordinates_a_one = function() end

  hoshi = function()
    local center = (SIZE - 1) / 2
    local hoshi
    local from_edge = 4
    local radius = 7
    --   local radius = math.min(HEIGHT, WIDTH) / 100
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
        love.graphics.circle("fill", SQUARE * i + 1, SQUARE * j + 1, radius)
      end -- +1 is to center on line width
    end
    if SIZE % 2 == 1 then
      love.graphics.circle("fill", SQUARE * center + 1, SQUARE * center + 1, radius)
    end
  end

  gridlines()
  coordinates_one_one()
  local hoshi_cuttoff_dpi = 300
  if WIDTH > hoshi_cuttoff_dpi and HEIGHT > hoshi_cuttoff_dpi then
    hoshi()
  end
  love.graphics.setCanvas()
end

function draw_tatami()
  --tatami
  local _, tatami = load_board_textures()
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
