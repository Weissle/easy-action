local jump_back = require("easy-action.jump_back")
local config_module = require("easy-action.config")
local jump = require("easy-action.jump")
local input = require("easy-action.input")
local easy_action = {}

easy_action.setup = function(args)
	config_module:set_config(args)
end

--- The basic function of easy-action.
---@param action string|table|nil Usually it consists of verb and range. If it is nil, you need to input the verb and range; If it is table, you can define the verb or range previously. If it is string, you don't need to input the command(but it will be remapped).
---@param jump_cmd string|function|table|nil How to jump? If it is nil, it will select the jump command according to your config. If it is string, vim.cmd(jump_cmd). If it is function, call it. If it is table, it should contain two fields, cmd and feed. cmd is a string or a function and feed is your input.
---@param jump_back_event string|table|nil When to jump back? If it is nil, it jumps back after executing the action. It can be event or a list of event.
easy_action.base_easy_action = function(action, jump_cmd, jump_back_event)
	action = input.get_action(action)
	if action == "" then
		return
	end
	print(action)
	jump_back:clear()
	jump_back:save_position()
	local async = require("async")
	async(function()
		jump_cmd = jump_cmd or jump.get_jump_cmd(action)
		vim.pretty_print(jump_cmd)
		jump.do_jump_cmd(jump_cmd)
		-- You didn't move your cursor.
		if jump_back:cursor_doesnt_move() then
			return
		end
		vim.fn.feedkeys(action, "t")
		jump_back:jumpback(jump_back_event, config_module.config.jump_back_delay_ms)
	end)

end

return easy_action
