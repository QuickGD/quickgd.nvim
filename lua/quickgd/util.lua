local M = {}

function M.split(string, char)
  local pattern = '([^' .. char .. ']+)'
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

function M.path_from_base(string)
  local path_list = M.split(string, "/")
  local base_dir = M.getcwd()
  local path = ""

  local found_base = false
  for _, value in ipairs(path_list) do
    if value == base_dir then
      found_base = true
    end
    if found_base then
      path = path .. value .. "/"
    end
  end
  return path
end

function M.getcwd()
  return vim.fs.basename(vim.fn.getcwd())
end

-- WARNING: this function can not handle duplicate names currently.
-- using base path currently until issue is solved.

function M.get_files_by_end(string, telescope) --> table
  telescope = telescope or "true"
  local find = vim.fs.find(function(x) return vim.endswith(x, string) end,
    { type = "file", limit = math.huge })
  local files = {}
  local icon = require("nvim-web-devicons").get_icon_by_filetype("tscn", {})
  if #find > 1 then
    if telescope == "true" then
      for _, value in ipairs(find) do
        local path = vim.fs.normalize(value)
        local name = icon .. " " .. M.path_from_base(path)
        table.insert(files, { name, path })
      end
    else
      files.name = {}
      files.path = {}
      for _, value in ipairs(find) do
        local path = vim.fs.normalize(value)
        local name = icon .. " " .. M.path_from_base(path)
        table.insert(files.name, name)
        table.insert(files.path, path)
      end
    end
  end
  return files
end

return M
