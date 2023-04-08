local ts = require("quickgd.lib.treesitter")
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
	local filetype = vim.o.filetype
	if filetype == "gdshader" or filetype == "gdshaderinc" then
		return true
	end
	return false
end

function source:get_debug_name()
	return "quickgd"
end

function source:get_trigger_characters(params)
	return { " ", "\t" }
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

local parsed_buffer = ts.parse:buffer(0, "glsl")
local root

function source:complete(params, callback)
	local cur = params.context.cursor.col
	local row = params.context.cursor.row
	local line = params.context.cursor_line
	local line_clean = string.match(line, "^[%s%t]*(.*)")
	local line_before_cursor = string.sub(line_clean, 1, cur - 1)
	local line_split = require("quickgd.lib.str").split(line_before_cursor, " ")
	local line_split_tail = line_split[#line_split]

	local key = (function()
		if line_split[1] == "render_mode" or line_split[1] == "shader_type" then
			return line_split[1]
		elseif #line_clean <= 2 then
			return ";"
		elseif line_split[#line_split + 1] then
			return line_split[#line_split - 1]
		else
			return line_split_tail
		end
	end)()

	root = parsed_buffer:root()

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
		local vertex = ts.get_node(root, ts.query.vertex, "function")
		local fragment = ts.get_node(root, ts.query.fragment, "function")
		local light = ts.get_node(root, ts.query.light, "function")
		if key == "render_mode" then
			list = comp.spatial.render_mode
			goto done
		end
		-- in --
		if string.match(line_before_cursor, "=") then
			if vertex and row > vertex:start() + 1 and row < vertex:end_() + 1 then
				list = vim.list_extend(list, comp.spatial.vertex_in)
				list = vim.list_extend(list, comp.spatial.vertex_inout)
			elseif fragment and row > fragment:start() + 1 and row < fragment:end_() + 1 then
				list = vim.list_extend(list, comp.spatial.fragment_in)
				list = vim.list_extend(list, comp.spatial.fragment_inout)
			elseif light and row > light:start() + 1 and row < light:end_() + 1 then
				list = vim.list_extend(list, comp.spatial.light_in)
			end
			goto done
		end
		-- out --
		if vertex and row > vertex:start() + 1 and row < vertex:end_() + 1 then
			list = vim.list_extend(list, comp.spatial.vertex_out)
			list = vim.list_extend(list, comp.spatial.vertex_inout)
		elseif fragment and row > fragment:start() + 1 and row < fragment:end_() + 1 then
			list = vim.list_extend(list, comp.spatial.fragment_out)
			list = vim.list_extend(list, comp.spatial.fragment_inout)
		elseif light and row > light:start() + 1 and row < light:end_() + 1 then
			list = vim.list_extend(list, comp.spatial.light_out)
		end
		::done::
		return list
	end

	local function set_canvas_item(list)
		local vertex = ts.get_node(root, ts.query.vertex, "function")
		local fragment = ts.get_node(root, ts.query.fragment, "function")
		local light = ts.get_node(root, ts.query.light, "function")
		if key == "render_mode" then
			list = comp.canvas.render_mode
			goto done
		end
		-- in --
		if string.match(line_before_cursor, "=") then
			if vertex and row > vertex:start() + 1 and row < vertex:end_() + 1 then
				list = vim.list_extend(list, comp.canvas_item.vertex_in)
				list = vim.list_extend(list, comp.canvas_item.vertex_inout)
			elseif fragment and row > fragment:start() + 1 and row < fragment:end_() + 1 then
				list = vim.list_extend(list, comp.canvas_item.fragment_in)
				list = vim.list_extend(list, comp.canvas_item.fragment_inout)
			elseif light and row > light:start() + 1 and row < light:end_() + 1 then
				list = vim.list_extend(list, comp.canvas_item.light_in)
				list = vim.list_extend(list, comp.canvas_item.light_inout)
			end
			goto done
		end
		-- out --
		if vertex and row > vertex:start() + 1 and row < vertex:end_() + 1 then
			list = vim.list_extend(list, comp.canvas_item.vertex_out)
			list = vim.list_extend(list, comp.canvas_item.vertex_inout)
		elseif fragment and row > fragment:start() + 1 and row < fragment:end_() + 1 then
			list = vim.list_extend(list, comp.canvas_item.fragment_out)
			list = vim.list_extend(list, comp.canvas_item.fragment_inout)
		elseif light and row > light:start() + 1 and row < light:end_() + 1 then
			list = vim.list_extend(list, comp.canvas_item.light_out)
			list = vim.list_extend(list, comp.canvas_item.light_inout)
		end
		::done::
		return list
	end

	local function set_particles(list)
		local start = ts.get_node(root, ts.query.start, "function")
		local process = ts.get_node(root, ts.query.process, "function")
		if key == "render_mode" then
			list = comp.particles.render_mode
			goto done
		end
		-- in --
		if string.match(line_before_cursor, "=") then
			if start and row > start:start() + 1 and row < start:end_() + 1 then
				list = vim.list_extend(list, comp.particles.start_in)
				list = vim.list_extend(list, comp.particles.global_in)
				list = vim.list_extend(list, comp.particles.global_inout)
			elseif process and row > process:start() + 1 and row < process:end_() + 1 then
				list = vim.list_extend(list, comp.particles.process_in)
				list = vim.list_extend(list, comp.particles.global_inout)
			end
			goto done
		end
		-- out --
		if start and row > start:start() + 1 and row < start:end_() + 1 then
			list = vim.list_extend(list, comp.particles.global_inout)
		elseif process and row > process:start() + 1 and row < process:end_() + 1 then
			list = vim.list_extend(list, comp.particles.global_inout)
		end
		::done::
		return list
	end

	local function set_sky(list)
		local sky = ts.get_node(root, ts.query.sky, "function")
		local start = ts.get_node(root, ts.query.start, "function")
		if key == "render_mode" then
			list = comp.sky.render_mode
			goto done
		end
		list = vim.list_extend(list, comp.sky.global)
		-- in --
		if string.match(line_before_cursor, "=") then
			if start and row > start:start() + 1 and row < start:end_() + 1 then
				list = vim.list_extend(list, comp.sky.sky_in)
			end
			goto done
		end
		-- out --
		if sky and row > sky:start() + 1 and row < sky:end_() + 1 then
			require("notify")({ "out" })
			list = vim.list_extend(list, comp.sky.sky_out)
		end
		::done::
		return list
	end

	local function set_fog(list)
		local fog = ts.get_node(root, ts.query.fog, "function")
		-- in --
		if string.match(line_before_cursor, "=") then
			if fog and row > fog:start() + 1 and row < fog:end_() + 1 then
				list = vim.list_extend(list, comp.fog.fog_in)
			end
			goto done
		end
		-- out --
		if fog and row > fog:start() + 1 and row < fog:end_() + 1 then
			list = vim.list_extend(list, comp.fog.fog_out)
		end
		::done::
		return list
	end

	local function get_list()
		local shader_type = ts.get_text(root, ts.query.shader_type, "shader_type")

		local items = nil
		items = {}
		items = set_universal(items)
		if shader_type == "spatial" then
			items = set_spatial(items)
		elseif shader_type == "canvas_item" then
			items = set_canvas_item(items)
		elseif shader_type == "particles" then
			items = set_particles(items)
		elseif shader_type == "sky" then
			items = set_sky(items)
		elseif shader_type == "fog" then
			items = set_fog(items)
		end
		return items
	end

	callback(get_list())

	ts.parse:reload()
end

-- function source:resolve(completion_item, callback)
-- end

-- function source:execute(completion_item, callback)
--   callback(completion_item)
-- end

cmp.register_source("quickgd", source.new())
