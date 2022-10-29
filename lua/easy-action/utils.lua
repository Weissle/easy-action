local utils = {}

--- check whether a char exists in a string
---@param c string whose length is 1
---@param s string
---@return boolean
utils.char_in_str = function(c, s)
	for i = 1, #s do
		if c == string.sub(s, i, i) then
			return true
		end
	end
	return false
end

--- check if a is equal to b recursivly.
---@param a any
---@param b any
---@return boolean
utils.equal = function(a, b)
	if type(a) ~= type(b) then
		return false
	elseif type(a) == "table" then
		if a == b then
			return true
		elseif vim.tbl_count(a) ~= vim.tbl_count(b) then
			return false
		else
			for k, v in pairs(a) do
				if utils.equal(v, b[k]) == false then
					return false
				end
			end
			return true
		end
	else
		return a == b
	end
end

--- feedkeys after {delay_ms}
---@param delay_ms number|nil
---@vararg any The param of the nvim_feedkeys function
utils.defer_feedkeys = function(delay_ms, ...)
	local args = { ... }
	vim.defer_fn(function()
		vim.api.nvim_feedkeys(unpack(args))
	end, delay_ms)
end

--- run cmd or call cmd()
---@param cmd function|string
utils.call = function(cmd)
	if type(cmd) == "string" then
		vim.cmd(cmd)
	elseif type(cmd) == "function" then
		cmd()
	else
		error("unsupport cmd type, cmd type is " .. type(cmd))
	end
end

return utils
