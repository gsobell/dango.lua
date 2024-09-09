ENGINE = { name = "gnugo", bin = "/usr/bin/gnugo --mode gtp" }
-- ENGINE = { name = "pachi", bin = "/usr/bin/pachi" }

--[[ for testing gtp:
local KOMI = 6.5
local SIZE = 19
local TO_PLAY = -1
--]]

--[[
end goal: have a function that encapusates all gtp functionality, with signature:

generated_move = gtp_move(previous_move)

]]

function send_command(engine, command)
  print("sending command", command)
  engine:write(command .. "\n")
  engine:flush()
  -- check success from file, '='
end

function gtp_play(engine, color, move)
  return send_command(engine, "play " .. color .. " " .. move) ~= false
end

function gtp_genmove(engine, color)
  local move = send_command(engine, "genmove " .. color)
  return move
end

function gtp_undo(engine)
  return send_command(engine, "undo") ~= false
end

function read_response(temp_file) end

-- TODO add check for pass
function gtp_repl()
  local temp_file = os.tmpname()
  local prev_move
  --   local response = file_monitor(temp_file)
  engine = io.popen(ENGINE.bin .. " > " .. temp_file, "w")
  send_command(engine, "boardsize " .. SIZE)
  send_command(engine, "komi " .. KOMI)
  send_command(engine, "clear_board")
  print("Setup complete.")
  move = coroutine.yield()
  while true do
    --     print(move.x, move.y, gtp_to_engine(move.x, move.y))
    gtp_play(engine, "black", gtp_to_engine(move.x, move.y))
    gtp_genmove(engine, "white")
    repeat
      repeat
        genmove = (io.open(temp_file, "r"):read("*a")) -- prints whole file
        genmove = string.sub(genmove, -6)
        genmove = genmove:gsub("[\n= %s\r\n]", "")
      until genmove ~= prev_move
      os.execute("sleep 1")
      local x, y = gtp_from_engine(genmove)
    until x ~= false
    prev_move = genmove
    local x, y = gtp_from_engine(genmove)
    move = coroutine.yield({ x = x, y = y })
  end
end
