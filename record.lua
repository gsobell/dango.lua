function generate_record()
  record_meta = {}
  record_meta.__index = {
    add = function(self)
      self[#self + 1] = { color = TO_PLAY, x = CURRENT.x, y = CURRENT.y, state = stones_to_str(STONES) }
    end,
    pass = function(self)
      if #self > 0 then
        self[#self + 1] = { scolor = TO_PLAY, state = self[#self].state }
      end
    end,

    undo = function(self)
      if #self > 0 then
        if #self == 1 then
          STONES = generate_stones()
          self = generate_record()
          return
        end
        STONES = str_to_stones(self[#self - 1].state)
        self[#self] = nil
        TO_PLAY = -TO_PLAY
        --         print(stones_to_str(STONES))
      end
    end,
  }
  record = {}
  setmetatable(record, record_meta)
  return record
end

-- STONES --> n**2 str
function stones_to_str(stones)
  if stones == nil then
    return
  end
  local string = ""
  for i = 1, SIZE do
    for j = 1, SIZE do
      if stones[i][j] ~= nil then
        if stones[i][j].color == BLACK then
          string = string .. "B"
        elseif stones[i][j].color == WHITE then
          string = string .. "W"
        end
      else
        string = string .. "."
      end
    end
  end
  return string
end

-- --> n**2 str --> STONES
function str_to_stones(str)
  if not str then
    return generate_stones() -- root of game
  end
  local stones = {}
  local index = 1
  for i = 1, SIZE do
    stones[i] = {}
    for j = 1, SIZE do
      local char = str:sub(index, index)
      if char ~= "." then
        if char == "W" then
          stones[i][j] = { color = WHITE, x = i, y = j }
        elseif char == "B" then
          stones[i][j] = { color = BLACK, x = i, y = j }
        end
      end
      index = index + 1
    end
  end
  setmetatable(stones, stones_meta)
  return stones
end

function str_pretty_print(str)
  print("  -- Turn " .. #RECORD .. " --")
  local transpose = {}
  for i = 1, SIZE do
    for j = 1, SIZE do
      local k = (j - 1) * SIZE + i
      if not transpose[i] then
        transpose[i] = ""
      end
      transpose[i] = transpose[i] .. str:sub(k, k)
    end
  end

  for i = 1, SIZE do
    local pretty_row = transpose[i]:gsub(".", "%0 ")
    print(pretty_row)
  end
  print("\n")
end
