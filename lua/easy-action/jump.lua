local utils = require("easy-action.utils")
local config_module = require("easy-action.config")
local jump = {}

local function get_exec_and_feed_function(cmd, feed)
	return function()
		utils.defer_feedkeys(config_module.config.feed_delay_ms, feed, "n", true)
		utils.call(cmd)
	end
end

local hop_action_select = function(action)
	local hop_config = config_module.config.jump_provider_config.hop
	local remap = config_module.remap or {}
	local last_char = string.sub(action, #action)
	last_char = remap[last_char] or last_char
	for k, v in pairs(hop_config.action_select) do
		if k ~= "default" and utils.char_in_str(last_char, v.options) then
			if v.feed == nil then
				return v.cmd
			else
				local feed = v.feed(action)
				assert(type(feed) == "string")
				return get_exec_and_feed_function(v.cmd, feed)
			end
		end
	end
	return hop_config.action_select.default
end

--- Get the jump cmd according to your action
---@param action string
---@return string|function
jump.get_jump_cmd = function(action)
	local jump_cmd = nil
	if config_module.config.jump_provider == "hop" then
		jump_cmd = hop_action_select(action)
	end
	return jump_cmd
end

--- exec your jump cmd
---@param jump_cmd string|function
jump.do_jump_cmd = function(jump_cmd)
	utils.call(jump_cmd)
end

--- jump according to your action
---@param action string
jump.jump = function(action)
	local jump_cmd = jump.get_jump_cmd(action)
	jump.do_jump_cmd(jump_cmd)
end

return jump
