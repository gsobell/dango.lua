function draw_hints()
  mouse_board_hint()
  draw_hint_current()
  draw_hint_last_played()
end

function smooth_hint() end

function jump_hint() end

function draw_hint_last_played()
  if not JUST_PLAYED.x or not JUST_PLAYED.y then
    return
  end
  if TO_PLAY == BLACK then
    love.graphics.setColor(0, 0, 0, 0.8)
  else
    love.graphics.setColor(1, 1, 1, 0.8)
  end
  love.graphics.scale(1 / SQUARE)
  local line = math.floor(math.min(HEIGHT, WIDTH) / 150)
  love.graphics.setLineWidth(line)
  love.graphics.circle("line", (JUST_PLAYED.x - 0.5) * SQUARE, (JUST_PLAYED.y - 0.5) * SQUARE, SQUARE / 4)
  love.graphics.setLineWidth(1)
  love.graphics.scale(SQUARE)
  love.graphics.setColor(1, 1, 1)
end

function draw_hint_current()
  if CURRENT.x == JUST_PLAYED.x and CURRENT.y == JUST_PLAYED.y then
    return
  end
  if TO_PLAY == BLACK then
    love.graphics.setColor(0, 0, 0, 0.1)
  else
    love.graphics.setColor(0.2, 0.2, 0.2, 0.1)
  end
  love.graphics.circle("fill", CURRENT.x - 0.5, CURRENT.y - 0.5, 0.15)
  love.graphics.setColor(1, 1, 1)
end

function mouse_board_hint() -- not on lutro!
  local cursor_x, cursor_y = love.mouse.getPosition()
  local x = math.ceil((cursor_x - TOP_LEFT_BOARD.x) / SQUARE)
  local y = math.ceil((cursor_y - TOP_LEFT_BOARD.y) / SQUARE)
  if on_board(x, y) then
    CURRENT.x = x
    CURRENT.y = y
  end
end
