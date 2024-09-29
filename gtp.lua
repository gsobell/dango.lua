ENGINE = { name = "gnugo", bin = "/usr/bin/gnugo --mode gtp" }
-- ENGINE = { name = "pachi", bin = "/usr/bin/pachi" }

--[[ for testing gtp:
local KOMI = 6.5
local SIZE = 19
local TO_PLAY = -1
--]]

function gtp_setup()
  if IS_AI.black then
    GTP_BLACK_CO = coroutine.create(gtp_repl)
    local success, err = coroutine.resume(GTP_BLACK_CO, BLACK)
    if not success then
      print("Error starting coroutine: " .. err)
    end
  end

  if IS_AI.white then
    GTP_WHITE_CO = coroutine.create(gtp_repl)
    local success, err = coroutine.resume(GTP_WHITE_CO, WHITE)
    if not success then
      print("Error starting coroutine: " .. err)
    end
  end
  return GTP_BLACK_CO, GTP_WHITE_CO
end

function gtp_sync(engine)
  send_command(engine, "clear_board")
  for _, stone in ipairs(STONES) do
    if stone.color == BLACK then
      color = "black"
    else
      color = "white"
    end
    gtp_play(engine, color, gtp_to_engine(stone.x, stone.y))
  end
end

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

-- TODO add check for pass
function gtp_repl(player_color)
  if player_color == WHITE then
    player, opponent = "white", "black"
  else
    player, opponent = "black", "white"
  end
  local temp_file = os.tmpname()
  local prev_move
  engine = io.popen(ENGINE.bin .. " > " .. temp_file, "w")
  send_command(engine, "boardsize " .. SIZE)
  send_command(engine, "komi " .. KOMI)
  send_command(engine, "clear_board")
  print("Setup complete.")
  move = coroutine.yield()
  while true do
    if move then
      gtp_play(engine, opponent, gtp_to_engine(move.x, move.y))
    else
      gtp_play(engine, opponent, "pass")
    end
    gtp_genmove(engine, player)
    repeat
      repeat
        -- add clause to clear file when exceeds given size
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
