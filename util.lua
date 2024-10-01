function flags()
  if arg and #arg > 0 then
    for i, v in ipairs(arg) do
      if v == "--help" or v == "-h" then
        help()
        love.event.quit()
        return
        --       if v == "--sgf" end
        --       if v == "--size" end
        --       if v == "--version" end
      end
    end
  end
end

function help()
  print("dango.lua - a cross platform, lightweight Go board")
  print("  Usage: love ./ [options]")
  print("  Options:")
  print("  --help          Show this help message")
end

-- A1 --> 1-1
-- NOTE 'i' is skipped for traditional reasons
function gtp_from_engine(string)
  if not string then
    return false
  end
  local alpha, num = string:match("([A-Z])(%d+)")
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
