local config_module = require("easy-action.config")
local utils = require("easy-action.utils")
local input = {}

--- Get your action input. limited_chars can only show up no more than twice. Return empty string if you press the terminate_char.
---@param free_chars string
---@param limited_chars string
---@param terminate_char string
---@return string|nil
input.input = function(free_chars, limited_chars, terminate_char)
	free_chars = free_chars or config_module.config.free_chars
	limited_chars = limited_chars or config_module.config.limited_chars
	terminate_char = terminate_char or config_module.config.terminate_char
	local limit_cnt, cmd = 0, ""
	while true do
		local c = vim.fn.getcharstr()
		if c == terminate_char then
			return nil
		end
		cmd = cmd .. c
		if utils.char_in_str(c, limited_chars) then
			limit_cnt = limit_cnt + 1
			if limit_cnt >= 2 then
				break
			end
		elseif utils.char_in_str(c, free_chars) == false then
			break
		end
	end
	return cmd
end

input.input_verb = function()
	-- no limited_chars, your verb should be one key like y, d. Otherwise, you pre-define your verb.
	return input.input(nil, "", nil)
end

input.input_range = function()
	return input.input(nil, nil, nil)
end

--- The basic function of easy-action.
---@param action string|table|nil Usually it consists of verb and range. If it is nil, you need to input the verb and range; If it is table, you can define the verb or range previously. If it is string, you don't need to input the command(but it will still be remapped).
---@return string
input.get_action = function(action)
	if type(action) ~= "string" then
		action = action or {}
		action = vim.tbl_extend("keep", action, { verb = nil, range = nil })
		action.verb = action.verb or input.input_verb()
		if action.verb == nil then
			return ""
		end
		action.range = action.range or input.input_range()
		if action.range == nil then
			return ""
		end
		action = action.verb .. action.range
	end
	for k, v in pairs(config_module.config.remap) do
		action = string.gsub(action, k, v)
	end
	return action
end

return input
