local M = {}

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

return M
