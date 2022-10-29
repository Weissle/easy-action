local utils = require("easy-action.utils")
local config_module = require("easy-action.config")
local jump = require("easy-action.jump")
local easy_action = {}

easy_action.setup = function(args)
	config_module:set_config(args)
end

--- The basic function of easy-action.
---@param pre_action string|nil It should be something like y,d. If it is nil, you need to input the pre_action;
---@param rest_action string|nil It should be something like y,d. If it is nil, you need to input the rest_action;
---@param jump_cmd string|function|nil How to jump? If it is nil, it will select the jump command according to your config.
easy_action.base_easy_action = function(pre_action, rest_action, jump_cmd)
	local config = config_module.config
	if pre_action == nil then
		pre_action = utils.action_input(config.continue_chars, config.stop_char)
	end

	if rest_action == nil then
		rest_action = utils.action_input(config.continue_chars, config.stop_char)
	end
	assert(type(pre_action) == "string" and type(rest_action) == "string", "pre_action should be string or nil")
	local action = pre_action .. rest_action

	for k, v in pairs(config_module.config.remap) do
		action = string.gsub(action, k, v)
	end
	if action == "" then
		return
	end
	if jump_cmd == nil then
		jump_cmd = jump.get_jump_cmd(action)
	end

	local win_handle = vim.api.nvim_get_current_win()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local async = require("async")
	async(function()
		jump.do_jump_cmd(jump_cmd)
		if win_handle == vim.api.nvim_get_current_win() and utils.equal(cursor_pos, vim.api.nvim_win_get_cursor(0)) then
			return
		end
		vim.cmd("normal " .. action)
		vim.defer_fn(function()
			vim.api.nvim_set_current_win(win_handle)
			vim.api.nvim_win_set_cursor(win_handle, cursor_pos)
		end, config.jump_back_delay_ms)
	end)
end

--- easy-action for doing anything.
easy_action.any_easy_action = function()
	easy_action.base_easy_action(nil, nil, nil)
end
return easy_action
