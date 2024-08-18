-- nil if empty
function is_spot_filled()
  return STONES[CURRENT.x][CURRENT.y]
end

--TODO remove 'checked' by using 'to_remove' + 'on_board'
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
    end

    if STONES[x][y].color ~= color then
      goto continue
    end

    if STONES[x][y].color == color then
      to_remove[curr] = curr
      local directions = {
        { x = 0, y = 1 },
        { x = 1, y = 0 },
        { x = 0, y = -1 },
        { x = -1, y = 0 },
      }
      for _, direction in ipairs(directions) do
        x = curr.x + direction.x -- fix redefined local by adjacent()
        y = curr.y + direction.y
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
