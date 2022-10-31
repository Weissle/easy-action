local utils = require("easy-action.utils")
local config_module = require("easy-action.config")
local jump = {}

local hop_action_select = function(action)
	local hop_config = config_module.config.jump_provider_config.hop
	assert(#action > 0)
	-- In case the action like yf(
	for i = 1, #action - 1 do
		if utils.char_in_str(string.sub(action, i, i), "ftFT") then
			return hop_config.action_select.default
		end
	end

	local last_char = string.sub(action, #action)
	for k, v in pairs(hop_config.action_select) do
		if k ~= "default" and utils.char_in_str(last_char, v.options) then
			local ret = {
				cmd = v.cmd,
			}
			if v.feed ~= nil then
				ret.feed = v.feed(action)
			end
			return ret
		end
	end
	return hop_config.action_select.default
end

local leap_action_select = function(action)
	local leap_config = config_module.config.jump_provider_config.leap
	return leap_config.action_select.default
end

--- Get the jump cmd according to your action
---@param action string
---@return string|function|table
jump.get_jump_cmd = function(action)
	local jump_cmd = nil
	local jump_provider = config_module.config.jump_provider
	if jump_provider == "hop" then
		jump_cmd = hop_action_select(action)
	elseif jump_provider == "leap" then
		jump_cmd = leap_action_select(action)
	elseif config_module.config.jump_provider_config[jump_provider] then
		local tmp = config_module.config.jump_provider_config[jump_provider]
		if type(tmp) == "function" then
			jump_cmd = tmp(action)
		else
			assert(type(tmp) == "string" or type(tmp) == "table")
			jump_cmd = tmp
		end
	end
	return jump_cmd
end

--- exec your jump cmd
---@param jump_cmd string|function|table
jump.do_jump_cmd = function(jump_cmd)
	if type(jump_cmd) == "table" then
		if jump_cmd.feed then
			utils.defer_feedkeys(config_module.config.feed_delay_ms, jump_cmd.feed, "n", true)
		end
		jump_cmd = jump_cmd.cmd
	end
	utils.call(jump_cmd)
end

--- jump according to your action
---@param action string
jump.jump = function(action)
	local jump_cmd = jump.get_jump_cmd(action)
	jump.do_jump_cmd(jump_cmd)
end

return jump
