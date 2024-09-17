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
      local stones = {}
      for _, stone in ipairs(self) do
        if stone.color == color then
          table.insert(stones, stone)
        end
      end
      return stones
    end,
  }
  STONES = {}
  setmetatable(STONES, stones_meta)
  STONES:init()
  return STONES
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
