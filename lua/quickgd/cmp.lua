local source = {}

local has_cmp, cmp = pcall(require, "cmp")
if not has_cmp then
	return
end

source.new = function()
	local self = setmetatable({}, { __index = source })
	return self
end

function source:is_available()
	if vim.o.filetype == "gdshader" then
		return true
	end
	return false
end

function source:get_debug_name()
	return "quickgd"
end

function source:get_trigger_characters(params)
	return { " ", "<tab>" }
end

local function is_same_type(parent, child)
	for _, value in pairs(parent) do
		if value.label == child then
			return true
		end
	end
	return false
end

local comp = {
	shader_type = require("quickgd.completion.shader_type"),
	decleration = require("quickgd.completion.decleration"),
	type = require("quickgd.completion.type"),
	hints = require("quickgd.completion.hints"),
	func = require("quickgd.completion.func"),
	global = require("quickgd.completion.global"),
	spatial = require("quickgd.completion.spatial"),
	canvas_item = require("quickgd.completion.canvas_item"),
	particles = require("quickgd.completion.particles"),
	sky = require("quickgd.completion.sky"),
	fog = require("quickgd.completion.fog"),
}

function source:complete(params, callback)
	local cur = params.context.cursor.col
	local row = params.context.cursor.row
	local line = params.context.cursor_line
	local line_clean = string.match(line, "^[%s%t]*(.*)")
	local line_before_cursor = string.sub(line_clean, 1, cur - 1)
	local line_split = require("quickgd.lib.str").split(line_before_cursor, " ")
	local line_split_tail = line_split[#line_split]
	local cur_node = vim.treesitter.get_node({ bufnr = 0 })

	local function get_key()
		if line_split[1] == "render_mode" or line_split[1] == "shader_type" then
			return line_split[1]
		elseif #line_clean <= 2 then
			return ";"
		elseif line_split[#line_split + 1] then
			return line_split[#line_split - 1]
		else
			return line_split_tail
		end
		return ";"
	end
	local key = get_key()

	local ts = require("quickgd.lib.treesitter")
	local root = ts.get_root(0)
	local func = {}

	local query = vim.treesitter.parse_query(
		"glsl",
		[[
    (function_definition
      (function_declarator
        declarator: (identifier) @vertex_name (#eq? @vertex_name "vertex"))) @vertex

    (function_definition
      (function_declarator
        declarator: (identifier) @fragment_name (#eq? @fragment_name "fragment"))) @fragment

    (function_definition
      (function_declarator
        declarator: (identifier) @light_name (#eq? @light_name "light"))) @light

    (function_definition
      (function_declarator
        declarator: (identifier) @start_name (#eq? @start_name "start"))) @start

    (function_definition
      (function_declarator
        declarator: (identifier) @process_name (#eq? @process_name "process"))) @process

    (function_definition
      (function_declarator
        declarator: (identifier) @sky_name (#eq? @sky_name "sky"))) @sky
        
    (function_definition
      (function_declarator
        declarator: (identifier) @fog_name (#eq? @fog_name "fog"))) @fog

    (declaration
      type: (type_identifier)@type (#eq? @type "shader_type")
      declarator: (identifier)@shader_type)
    ]]
	)

	for id, node in query:iter_captures(root, 0, 0, -1) do
		local name = query.captures[id]

		if name == "shader_type" then
			local text = vim.treesitter.get_node_text(node, 0, {})
			func.shader_type = text
		end
		if name == "vertex" then
			func.vertex = node
		end
		if name == "fragment" then
			func.fragment = node
		end
		if name == "light" then
			func.light = node
		end
		if name == "start" then
			func.start = node
		end
		if name == "process" then
			func.process = node
		end
		if name == "sky" then
			func.sky = node
		end
		if name == "fog" then
			func.fog = node
		end
	end

	local function set_universal(list)
		if key == "shader_type" then
			list = comp.shader_type
			goto done
		end
		if key == ";" then
			list = vim.list_extend(list, comp.decleration)
		end
		if key == ";" or (#line_split < 2 and is_same_type(comp.decleration, key)) then
			list = vim.list_extend(list, comp.type)
		end
		if key == ":" then
			list = comp.hints
		elseif string.match(line_before_cursor, "=") then
			list = vim.list_extend(list, comp.global)
			list = vim.list_extend(list, comp.func)
		end
		::done::
		return list
	end

	local function set_spatial(list)
		if key == "render_mode" then
			list = comp.spatial.render_mode
			goto done
		end
		-- in --
		if string.match(line_before_cursor, "=") then
			if func.vertex and row > func.vertex:start() + 1 and row < func.vertex:end_() + 1 then
				list = vim.list_extend(list, comp.spatial.vertex_in)
				list = vim.list_extend(list, comp.spatial.vertex_inout)
			elseif func.fragment and row > func.fragment:start() + 1 and row < func.fragment:end_() + 1 then
				list = vim.list_extend(list, comp.spatial.fragment_in)
				list = vim.list_extend(list, comp.spatial.fragment_inout)
			elseif func.light and row > func.light:start() + 1 and row < func.light:end_() + 1 then
				list = vim.list_extend(list, comp.spatial.light_in)
			end
			goto done
		end
		-- out --
		if func.vertex and row > func.vertex:start() + 1 and row < func.vertex:end_() + 1 then
			list = vim.list_extend(list, comp.spatial.vertex_out)
			list = vim.list_extend(list, comp.spatial.vertex_inout)
		elseif func.fragment and row > func.fragment:start() + 1 and row < func.fragment:end_() + 1 then
			list = vim.list_extend(list, comp.spatial.fragment_in)
			list = vim.list_extend(list, comp.spatial.fragment_inout)
		elseif func.light and row > func.light:start() + 1 and row < func.light:end_() + 1 then
			list = vim.list_extend(list, comp.spatial.light_out)
		end
		::done::
		return list
	end

	local function set_canvas_item(list)
		if key == "render_mode" then
			list = comp.spatial.render_mode
			goto done
		end
		-- in --
		if string.match(line_before_cursor, "=") then
			if func.vertex and row > func.vertex:start() + 1 and row < func.vertex:end_() + 1 then
				list = vim.list_extend(list, comp.canvas_item.vertex_in)
				list = vim.list_extend(list, comp.canvas_item.vertex_inout)
			elseif func.fragment and row > func.fragment:start() + 1 and row < func.fragment:end_() + 1 then
				list = vim.list_extend(list, comp.canvas_item.fragment_in)
				list = vim.list_extend(list, comp.canvas_item.fragment_inout)
			elseif func.light and row > func.light:start() + 1 and row < func.light:end_() + 1 then
				list = vim.list_extend(list, comp.canvas_item.light_in)
				list = vim.list_extend(list, comp.canvas_item.light_inout)
			end
			goto done
		end
		-- out --
		if func.vertex and row > func.vertex:start() + 1 and row < func.vertex:end_() + 1 then
			list = vim.list_extend(list, comp.canvas_item.vertex_out)
			list = vim.list_extend(list, comp.canvas_item.vertex_inout)
		elseif func.fragment and row > func.fragment:start() + 1 and row < func.fragment:end_() + 1 then
			list = vim.list_extend(list, comp.canvas_item.fragment_out)
			list = vim.list_extend(list, comp.canvas_item.fragment_inout)
		elseif func.light and row > func.light:start() + 1 and row < func.light:end_() + 1 then
			list = vim.list_extend(list, comp.canvas_item.light_out)
			list = vim.list_extend(list, comp.canvas_item.light_inout)
		end
		::done::
		return list
	end

	local function set_particles(list)
		if key == "render_mode" then
			list = comp.particles.render_mode
			goto done
		end
		-- in --
		if string.match(line_before_cursor, "=") then
			if func.start and row > func.start:start() + 1 and row < func.start:end_() + 1 then
				list = vim.list_extend(list, comp.particles.start_in)
				list = vim.list_extend(list, comp.particles.global_in)
				list = vim.list_extend(list, comp.particles.global_inout)
			elseif func.process and row > func.process:start() + 1 and row < func.process:end_() + 1 then
				list = vim.list_extend(list, comp.particles.process_in)
				list = vim.list_extend(list, comp.particles.global_inout)
			end
			goto done
		end
		-- out --
		if func.start and row > func.start:start() + 1 and row < func.start:end_() + 1 then
			list = vim.list_extend(list, comp.particles.global_inout)
		elseif func.process and row > func.process:start() + 1 and row < func.process:end_() + 1 then
			list = vim.list_extend(list, comp.particles.global_inout)
		end
		::done::
		return list
	end

	local function set_sky(list)
		if key == "render_mode" then
			list = comp.sky.render_mode
			goto done
		end
		list = vim.list_extend(list, comp.sky.global)
		-- in --
		if string.match(line_before_cursor, "=") then
			require("notify")({ "in" })
			if func.start and row > func.start:start() + 1 and row < func.start:end_() + 1 then
				list = vim.list_extend(list, comp.sky.sky_in)
			end
			goto done
		end
		-- out --
		if func.sky and row > func.sky:start() + 1 and row < func.sky:end_() + 1 then
			require("notify")({ "out" })
			list = vim.list_extend(list, comp.sky.sky_out)
		end
		::done::
		return list
	end

	local function set_fog(list)
		-- in --
		if string.match(line_before_cursor, "=") then
			if func.fog and row > func.fog:start() + 1 and row < func.fog:end_() + 1 then
				list = vim.list_extend(list, comp.fog.fog_in)
			end
			goto done
		end
		-- out --
		if func.fog and row > func.fog:start() + 1 and row < func.fog:end_() + 1 then
			list = vim.list_extend(list, comp.fog.fog_out)
		end
		::done::
		return list
	end

	local function get_list()
		local items = nil
		items = {}
		items = set_universal(items)
		if func.shader_type == "spatial" then
			items = set_spatial(items)
		elseif func.shader_type == "canvas_item" then
			items = set_canvas_item(items)
		elseif func.shader_type == "particles" then
			items = set_particles(items)
		elseif func.shader_type == "sky" then
			items = set_sky(items)
		elseif func.shader_type == "fog" then
			items = set_fog(items)
		end
		return items
	end

	callback(get_list())
end

-- function source:resolve(completion_item, callback)
-- end

-- function source:execute(completion_item, callback)
--   callback(completion_item)
-- end

cmp.register_source("quickgd", source.new())
