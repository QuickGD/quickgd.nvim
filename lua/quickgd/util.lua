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

function M.split(string, char)
  local pattern = string.format('([^%s]+)', char)
  local split_list = {}
  for word in string.gmatch(string, pattern) do
    table.insert(split_list, word)
  end
  return split_list
end

function M.name_from_function(string)
  local name_split = M.split(string, '_')
  local name = ""
  for _, value in ipairs(name_split) do
    local upper = (value:gsub("^%l", string.upper))
    name = name .. upper
  end
  return name
end

function M.truncate_path(string)
  local base_dir = M.cwdname()
  local pattern = string.format("(%s.*)", base_dir)
  local match = string.match(string, pattern)
  return string.gsub(match, base_dir .. "/", "")
end

function M.truncate_path_amount(string, amount)
  local base_dir = M.cwdname()
  local chunk = "[^/]*/"
  local pattern = ""
  for _ = 1, amount, 1 do
    pattern = pattern .. chunk
  end
  local final_pattern = string.format("(%s[^/]*)$", pattern)
  return string.match(string, final_pattern)
end

function M.cwdname()
  return vim.fs.basename(vim.fn.getcwd())
end

function M.get_files_by_end(string, telescope) --> table
  telescope = telescope or "true"
  local find = vim.fs.find(function(x) return vim.endswith(x, string) end,
        { type = "file", limit = math.huge }) or {}
  local files = {}
  local icon = require("nvim-web-devicons").get_icon_by_filetype("tscn", {})
  if #find > 1 then
    if telescope == "true" then
      for _, value in ipairs(find) do
        local path = vim.fs.normalize(value)
        local name = icon .. " " .. M.truncate_path(path)
        table.insert(files, { name, path })
      end
    else
      files.name = {}
      files.path = {}
      for _, value in ipairs(find) do
        local path = vim.fs.normalize(value)
        local name = icon .. " " .. M.truncate_path(path)
        table.insert(files.name, name)
        table.insert(files.path, path)
      end
    end
  end
  return files
end

return M
