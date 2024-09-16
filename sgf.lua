-- "aa" --> {x=1, y=1}
function sgf_to_coords(sgf)
  local x = string.byte(sgf:sub(1, 1)) - string.byte("a") + 1
  local y = string.byte(sgf:sub(2, 2)) - string.byte("a") + 1
  return x, y
end

-- TODO reattach engine if size change triggered
function sgf_set_size(sgf_in)
  local size = sgf_in:match("SZ%[(%d+)%]")
  if size then
    SIZE = tonumber(size)
    STONES = generate_stones()
  end
end

function sgf_parse(sgf_in)
  for prop, coord in sgf_in:gmatch("([BW])%[(%a%a)%]") do
    local x, y = sgf_to_coords(coord)
    if prop == "B" then
      STONES[x][y] = { color = BLACK, img = BLACK_STONE, x = x, y = y }
    elseif prop == "W" then
      STONES[x][y] = { color = WHITE, img = WHITE_STONE, x = x, y = y }
    end
  end
end

-- testing
-- sgf_input = "(;FF[4]GM[1]SZ[19]B[aa]W[ab]B[bc]W[dd])"
-- sgf_set_size(sgf_input)
-- sgf_parse_stones(sgf_input)
