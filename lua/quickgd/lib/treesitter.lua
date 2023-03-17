local M = {}

function M.get_root(bufnr)
  local parser = vim.treesitter.get_parser(bufnr, "glsl", {})
  local tree = parser:parse()[1]
  return tree:root()
end

function M.query_function_name(name)
  local query = string.format(
    [[
    (function_definition
      (function_declarator
        (identifier)@name(#eq? @name "%s")))@func
    ]], name)
  local function_name = vim.treesitter.parse_query("glsl", query)
  return function_name
end

return M
