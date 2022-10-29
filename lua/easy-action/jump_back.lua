local utils = require("easy-action.utils")
local jump_back = {}

jump_back.win_handle = nil
jump_back.cursor_pos = nil

--- save current cusor position
function jump_back:save_position()
	jump_back.win_handle = vim.api.nvim_get_current_win()
	jump_back.cursor_pos = vim.api.nvim_win_get_cursor(0)
end

--- clear the cursor info as well as the jump_back autocmd
function jump_back:clear()
	vim.api.nvim_create_augroup("easy-action-jumpback", { clear = true }) -- equal to delete
	jump_back.win_handle = nil
	jump_back.cursor_pos = nil
end

--- check if current cursor position is the same as the record
---@return boolean
function jump_back:cursor_doesnt_move()
	return jump_back.win_handle == vim.api.nvim_get_current_win()
		and utils.equal(jump_back.cursor_pos, vim.api.nvim_win_get_cursor(0))
end

--- jump back after {delay_ms}
---@param delay_ms number
function jump_back:defer_jump(delay_ms)
	vim.defer_fn(function()
		vim.api.nvim_set_current_win(jump_back.win_handle)
		vim.api.nvim_win_set_cursor(jump_back.win_handle, jump_back.cursor_pos)
		jump_back:clear()
	end, delay_ms)
end

--- jumpback to the record cursor position after event(s) happen.
---@param event nil|string|table It it is nil, event will not be used. If it is table, it should contain a list of event.
---@param delay_ms number
function jump_back:jumpback(event, delay_ms)
	if event == nil then
		jump_back:defer_jump(delay_ms)
	else
		vim.api.nvim_create_augroup("easy-action-jumpback", { clear = true })
		vim.api.nvim_create_autocmd(event, {
			callback = function()
				jump_back:defer_jump(delay_ms)
			end,
			once = true,
			group = "easy-action-jumpback",
		})
	end
end

return jump_back
