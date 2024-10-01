-- SGF FF[4] format is used, branches to be introduced eventually
SGF_BLACK = "B"
SGF_WHITE = "W"

-- "aa" --> {x=1, y=1}
function sgf_to_coords(sgf)
  local x = string.byte(sgf:sub(1, 1)) - string.byte("a") + 1
  local y = string.byte(sgf:sub(2, 2)) - string.byte("a") + 1
  return x, y
end

-- {x=1, y=1} --> "aa"
function sgf_from_coord(x, y)
  if not x and not y then
    return ""
  end
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
  if not STONES then
    STONES = generate_stones()
  end
  for prop, coord in sgf_in:gmatch("([BW])%[(%a%a)%]") do
    local x, y = sgf_to_coords(coord)
    if prop == SGF_BLACK then
      STONES[x][y] = { color = BLACK, x = x, y = y }
    elseif prop == SGF_WHITE then
      STONES[x][y] = { color = WHITE, x = x, y = y }
    end
  end
  --   return STONES
end

-- RECORD is easier to work with than SGF

-- SZ[2]B[aa] --> B...
function sgf_to_record() end

-- B... --> SZ[2]B[aa]
function sgf_from_record() end

-- input must be well-ordered, RECORD, not STONES
function sgf_from_stone(stones)
  local sgf = "(;FF[4]GM[1]SZ[" .. SIZE .. "]"
  local player
  for _, stone in pairs(stones) do
    if stone.color == BLACK then
      player = SGF_BLACK
    else
      player = SGF_WHITE
    end
    local coord = sgf_from_coord(stone.x, stone.y)
    sgf = sgf .. ";" .. player .. "[" .. coord .. "]"
  end
  sgf = sgf .. ")"
  return sgf
end
