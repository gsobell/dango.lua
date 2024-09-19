function generate_stones()
  stones_meta = {}
  stones_meta.__index = {
    init = function(self)
      for i = 1, SIZE do
        self[i] = {}
      end
    end,

    add = function(self, color, x, y)
      self[x][y] = { color = color, x = x, y = y }
    end,
    get = function(self, color)
      local filtered = {}
      for _, row in ipairs(self) do
        for _, stone in ipairs(row) do
          if stone.color == color then
            table.insert(filtered, stone)
          end
        end
      end
      return filtered
    end,
  }
  local stones = {}
  setmetatable(stones, stones_meta)
  stones:init()
  return stones
end

function draw_stones()
  for _, row in pairs(STONES) do
    for _, stone in pairs(row) do
      if stone then
        if stone.color == BLACK then
          img = BLACK_STONE
        else
          img = WHITE_STONE
        end
        love.graphics.draw(
          img,
          stone.x - 0.5,
          stone.y - 0.5,
          0,
          1 / STONE_WIDTH * STONE_SCALE,
          1 / STONE_HEIGHT * STONE_SCALE,
          STONE_WIDTH / 2,
          STONE_HEIGHT / 2
        )
      end
    end
  end
end
