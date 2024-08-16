function is_spot_filled()
  return STONES[CURRENT.x][CURRENT.y]
end

-- capture chain starting with 'start'
-- placed is added to local STONES
function capture(start, color, placed)
  local STONES = STONES
  STONES[placed.x][placed.y] = placed
  local to_check = { start }
  local to_remove = {}
  local checked = {}

  while #to_check > 0 do
    local curr = table.remove(to_check)
    local x, y = curr.x, curr.y
    checked[tostring(x .. "-" .. y)] = curr

    if on_board(x, y) and STONES[x][y] == nil then
      print("Liberty found")
      return false
    end

    if STONES[x][y].color ~= color then
      print("other color")
      goto continue
    end

    if STONES[x][y].color == color then
      print("Adding " .. x .. "," .. y .. " to remove list")
      to_remove[curr] = curr
      local directions = {
        { x = 0, y = 1 },
        { x = 1, y = 0 },
        { x = 0, y = -1 },
        { x = -1, y = 0 },
      }
      for _, direction in ipairs(directions) do
        local x = curr.x + direction.x
        local y = curr.y + direction.y
        if on_board(x, y) and not checked[tostring(x .. "-" .. y)] then
          print("Adding" .. x .. "," .. y .. "to check")
          table.insert(to_check, { x = x, y = y })
        end
      end
    end
    ::continue::
  end
  print("Removing stones now")
  return to_remove
end
