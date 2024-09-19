-- SGF FF[4] format is used, branches to be introduced eventually

-- "aa" --> {x=1, y=1}
function sgf_to_coords(sgf)
  local x = string.byte(sgf:sub(1, 1)) - string.byte("a") + 1
  local y = string.byte(sgf:sub(2, 2)) - string.byte("a") + 1
  return x, y
end

-- {x=1, y=1} --> "aa"
function sgf_from_coord(x, y)
  return string.char(x + 96) .. string.char(y + 96)
end

function sgf_set_size(sgf_in)
  local size = sgf_in:match("SZ%[(%d+)%]")
  if size then
    SIZE = tonumber(size)
    STONES = generate_stones()
  end
end

function sgf_to_stone(sgf_in)
  for prop, coord in sgf_in:gmatch("([BW])%[(%a%a)%]") do
    local x, y = sgf_to_coords(coord)
    if prop == "B" then
      STONES[x][y] = { color = BLACK, x = x, y = y }
    elseif prop == "W" then
      STONES[x][y] = { color = WHITE, x = x, y = y }
    end
  end
end

function sgf_from_stone(stones)
  local sgf = "(;FF[4]GM[1]SZ[" .. SIZE .. "]"
  for _, stone in ipairs(stones) do
    local player = stone.color
    local coord = sgf_from_coord(stone.x, stone.y)
    sgf = sgf .. ";" .. player .. "[" .. coord .. "]"
  end
  sgf = sgf .. ")"
  return sgf
end
