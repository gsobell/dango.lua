ENGINE = { name = "gnugo", bin = "/usr/bin/gnugo --mode gtp" }

---[[ for testing gtp:
local KOMI = 6.5
local SIZE = 19
local TO_PLAY = -1
--]]

function send_command(engine, command)
  engine:write(command .. "\n")
  engine:flush()
  -- check success from file, '='
end

function gtp_play(engine, color, move)
  return send_command(engine, color .. " " .. move) ~= false
end

function gtp_genmove(engine, color)
  local move = send_command(engine, "genmove " .. color)
  return move
end

function gtp_undo(engine)
  return send_command(engine, "undo") ~= false
end


function read_response(temp_file) end

function gtp_repl()
  local temp_file = os.tmpname()
  local response = file_monitor(temp_file)
  engine = io.popen(ENGINE.bin .. " > " .. temp_file, "w")
  send_command(engine, "boardsize " .. SIZE)
  send_command(engine, "komi " .. KOMI)
  send_command(engine, "clear_board")
  print("Setup complete.")
  coroutine.yield(move)
  while true do
    gtp_play(engine, "black", move)
    gtp_genmove(engine, "white")
    repeat
      move = response.refresh()
    --maybe add nap here?
    until move
    move = coroutine.yield(move)
  end
end

function file_monitor(filePath)
  local file, err = io.open(filePath, "r")
  if not file then
    --         print("Error opening file: " .. err)
    return nil
  end

  local last_pos = file:seek()
  local function refresh()
    file:seek("set", last_pos)
    local new_lines = file:read("*a")
    if new_lines and new_lines ~= "" then
      last_pos = file:seek()
      return new_lines
    end
    return nil
  end

  local function close()
    file:close()
  end

  return {
    checkForNewContent = refresh,
    close = close,
  }
end
