function is_spot_filled()
  return STONES[CURRENT.x][CURRENT.y]
end

function on_board(x, y)
  return x > 0 and x <= SIZE and y > 0 and y <= SIZE
end

function is_ko()
  if #RECORD > 3 then
    result = RECORD[#RECORD].state == RECORD[#RECORD - 2].state
  end
  return false or result
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

function place_stone()
  if is_spot_filled() then
    love.audio.play(ILLEGAL_PLACEMENT_SOUND)
    return
  end

  local directions = adjacent(CURRENT.x, CURRENT.y)
  to_remove = {}
  for _, direction in ipairs(directions) do
    local x, y = direction.x, direction.y
    if on_board(x, y) and STONES[x][y] ~= nil and STONES[x][y].color ~= TO_PLAY then
      table.insert(to_remove, capture(STONES[x][y], -TO_PLAY, CURRENT))
    end
  end

  is_captured = false
  for _, group in pairs(to_remove) do
    is_captured = unplace_stones(group) or is_captured
  end

  -- liberty check
  for _, direction in ipairs(directions) do
    local x, y = direction.x, direction.y
    if on_board(x, y) and STONES[x][y] == nil then
      placement()
      return
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
      placement()
      return
    end
  end
  love.audio.play(ILLEGAL_PLACEMENT_SOUND)
end

function placement()
  STONES:add(TO_PLAY, CURRENT.x, CURRENT.y)
  RECORD:add()

  str_pretty_print(stones_to_str(STONES))

  JUST_PLAYED = STONES[CURRENT.x][CURRENT.y] -- used by GTP engine, replace
  --
  local random_index = math.random(1, #STONE_PLACEMENT_SOUND)
  TO_PLAY = -TO_PLAY
  DRAW_AFTER_PLACE = false
  if is_ko() then
    RECORD:undo()
    love.audio.play(ILLEGAL_PLACEMENT_SOUND)
    return
  end
  if is_captured then
    random_index = math.random(1, #STONE_CAPTURE_SOUND)
    love.audio.play(STONE_CAPTURE_SOUND[random_index])
  else
    love.audio.play(STONE_PLACEMENT_SOUND[random_index])
  end
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
  return true
end

function capture(start, color, placed)
  STONES[placed.x][placed.y] = placed
  local to_check = { start }
  local to_remove = {}
  local checked = {}

  while #to_check > 0 do
    local curr = table.remove(to_check)
    local x, y = curr.x, curr.y
    checked[tostring(x .. "-" .. y)] = curr

    if on_board(x, y) and STONES[x][y] == nil then
      STONES[CURRENT.x][CURRENT.y] = nil
      return false
    elseif STONES[x][y].color ~= color then
      goto continue
    elseif STONES[x][y].color == color then
      to_remove[curr] = curr
      local directions = adjacent(x, y)
      for _, direction in ipairs(directions) do
        x, y = direction.x, direction.y
        if on_board(x, y) and not checked[tostring(x .. "-" .. y)] then
          table.insert(to_check, { x = x, y = y })
        end
      end
    end
    ::continue::
  end
  STONES[CURRENT.x][CURRENT.y] = nil
  return to_remove
end
