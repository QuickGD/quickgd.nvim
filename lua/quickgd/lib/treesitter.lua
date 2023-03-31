local M = {}
M.parse = {}
M.query = {}

M.parse_query = vim.treesitter.query.parse or vim.treesitter.parse_query

function M.parse:buffer(bufnr, lang)
	-- return parser:parse()[1]
	self.language_tree = vim.treesitter.get_parser(bufnr, lang, {})
	return self
end

function M.parse:reload()
	-- self.parse.language_tree = self.parse.language_tree:invalidate(true)
	self.language_tree:invalidate(true)
end

function M.parse:root()
	return self.language_tree:parse()[1]:root()
end

function M.query_function_name(name)
	local query_string = string.gsub(
		[[
		(function_definition
      	(function_declarator
        	declarator: (identifier)@name (#eq? @name "{r}")))@function
  	]],
		"({r})",
		name
	)

	return M.parse_query("glsl", query_string)
end

M.query.vertex = M.query_function_name("vertex")
M.query.fragment = M.query_function_name("fragment")
M.query.light = M.query_function_name("light")
M.query.start = M.query_function_name("start")
M.query.process = M.query_function_name("process")
M.query.sky = M.query_function_name("sky")
M.query.fog = M.query_function_name("fog")

function M.query_shader_type()
	local query_string = [[
    (declaration
      type: (type_identifier)@name (#eq? @name "shader_type")
      declarator: (identifier)@shader_type)
  ]]
	return M.parse_query("glsl", query_string)
end

M.query.shader_type = M.query_shader_type()

function M.get_node(root, query, type)
	for id, node in query:iter_captures(root, 0, 0, -1) do
		local capture = query.captures[id]
		if capture == type then
			return node
		end
	end
	return false
end

function M.get_text(root, query, type)
	for id, node in query:iter_captures(root, 0, 0, -1) do
		local capture = query.captures[id]
		if capture == type then
			return vim.treesitter.get_node_text(node, 0, {})
		end
	end
end

return M
