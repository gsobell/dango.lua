ENGINE = { name = "gnugo", bin = "/usr/bin/gnugo" }

---[[ for testing gtp:
local KOMI = 6.5
local SIZE = 19
local TO_PLAY = -1
--]]

function gtp_init()
  local engine = io.popen(ENGINE.bin .. " --mode gtp", "r")
  send_command(engine, "boardsize " .. SIZE)
  send_command(engine, "komi " .. KOMI)
  send_command(engine, "clear_board")
  return engine
end

-- response is like that begins with '='
function send_command(engine, command)
  engine:write(command .. "\n")
  engine:flush()
  local response = ""
  while true do
    local line = engine:read("*line")
    if not line then
      break
    end
    if line:match("^=") then
      response = line
      print(response)
      print(gtp_from_engine(response))
      break
    end
  end
  return response
end

function gtp_play(engine, TO_PLAY, move)
  send_command(engine, TO_PLAY .. " " .. move)
end

function gtp_genmove(engine, TO_PLAY)
  return send_command(engine, "genmove " .. TO_PLAY)
end

-- A1 --> 1-1
-- NOTE 'i' is skipped for traditional reasons
function gtp_from_engine(a1)
  a1 = a1:match("=%s*(%a%d+)")
  if not a1 then
    return false
  end
  local alpha, num = a1:match("([A-Z])(%d+)")
  if not alpha or not num then
    return false
  end
  local x
  local y = tonumber(num)
  if alpha > "I" then
    x = string.byte(alpha) - string.byte("A")
  else
    x = string.byte(alpha) - string.byte("A") + 1
  end
  return x, y
end

-- 1-1 --> A1
function gtp_to_engine(x, y)
  local alpha
  local num = tostring(y)
  if x <= string.byte("I") - string.byte("A") then
    alpha = string.char(string.byte("A") + x - 1)
  else
    alpha = string.char(string.byte("A") + x)
  end
  return alpha .. num
end

local function gtp_repl(engine)
  while true do
    local move = coroutine.yield("Enter your move (or 'q' to quit):")
    if move == "q" then
      break
    end
    gtp_play(engine, "black", move)
    local computer_move = gtp_genmove(engine, "white")
    print("Computer plays: " .. computer_move)
    coroutine.yield()
  end
end

-- syncs to current state in case of failure
-- use in conjuction with game record
function gtp_sync() end

function gtp_health()
  if coroutine.status(co) == "dead" then
    engine = gtp_init()
    gtp_sync()
    return engine
  end
  return false
end

engine = gtp_init()
co = coroutine.create(function()
  gtp_repl(engine)
end)

while coroutine.status(co) ~= "dead" do
  local status, user_input = coroutine.resume(co)
  if not status then
    print("Error: " .. user_input)
    break
  end
  if user_input then
    io.write(user_input)
    io.flush()
  end
end

engine:close()
