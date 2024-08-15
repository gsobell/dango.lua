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

function capture(coord, color, checked, to_remove)
-- check if liberty / empty
  local up = coord - 1
  local down = coord + 1
  local left = coord + 100
  local right = coord - 100

checked = {coord}
to_check = { up, down, left, right }

while #to_check > 0 do

if coord_on_board(coord) and STONES[coord] == nil then
	return false
end

-- already checked
if checked[coord] then
	return false
end

-- other color
if STONES[coord] ~= color then
	return false
end

-- table.remove(to_check, coord)
table.insert(checked, coord)
table.insert(to_remove, coord)


end
return to_remove
end
