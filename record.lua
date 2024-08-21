turn = {}
turn.__index = turn

function turn.new(color, x, y, captured_stones)
  local instance = {
    color = color,
    x = x,
    y = y,
    captured_stones = captured_stones,
  }
  setmetatable(instance, turn)
  return instance
end

record = {}
record.__index = record

-- TODO look at SGF spec for other metadata fields
function record.new()
  local instance = { turns = {} }
  setmetatable(instance, record)
  return instance
end

function record:add_turn(color, x, y, captured_stones)
  local new_turn = turn.new(color, x, y, captured_stones)
  table.insert(self.turns, new_turn)
end

function record:undo()
  local last_turn = self.turns[#self.turns]
  if last_turn then
    table.remove(self.turns)
    return last_turn
  else
    return nil
  end
end
