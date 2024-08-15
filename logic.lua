function is_spot_filled()
  local coord = one_one_to_coord(CURRENT)
  if STONES[coord] ~= nil then
    return true
  end
end

function coord_on_board(coord)
  return (coord >= MIN_COORD) and (coord <= MAX_COORD)
end

--[[ Checks whether groups of color starting with coord
have liberties
]]

function capture(coord, color_to_check, imaginary)
  local STONES = STONES
  STONES[one_one_to_coord(imaginary)] = { color = imaginary.color, x = imaginary.x, y = imaginary.x }
  print("Check group starting with: " .. coord)
  to_remove = { coord = coord }
  checked = {}
  to_check = {coord}

  while #to_check > 0 do
    local curr = table.remove(to_check)
    print("Now checking: " .. curr)

    if coord_on_board(curr) and not STONES[curr] then
      print("liberty found at: " .. curr)
      return false
    end

    if not coord_on_board(curr) then
      checked[curr] = curr
      goto continue
    end

        if checked[curr] then
          print("already checked" .. curr)
          goto continue
        end

    if STONES[curr].color == -color_to_check then
      print("other color" .. curr)
      checked[curr] = curr
      goto continue
    end

    if STONES[curr].color == color_to_check then
      print("Adding " .. curr .. " to remove list")
      checked[curr] = curr
      to_remove[curr] = curr
      local adjacent = { curr - 1, curr + 1, curr + 100, curr - 100 }
      for _, adj in pairs(adjacent) do
        if not checked[adj] and coord_on_board(adj) then
          table.insert(to_check, adj)
        end
      end
    end
    ::continue::
  end
  print("Sending the remove list for removal")
  return to_remove
end
