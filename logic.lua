function is_spot_filled()
  print("is filed", CURRENT.x, CURRENT.y)
  return STONES[CURRENT.x][CURRENT.y] --TODO  fix attempt to index a nil value (seems to be from gtp move not reading in time)
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
