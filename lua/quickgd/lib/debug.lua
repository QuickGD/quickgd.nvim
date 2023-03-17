local M = {}

function M.time(name, callback)
  local before = os.clock()
  local call = callback()
  local after = os.clock()
  local message = string.format("%s took %0.6f seconds to run", name, after - before)
  local has_notify, notify = pcall(require, "notify")

  if has_notify then
    notify({ message })
  else
    print(message)
  end
  return call or true
end

return M
