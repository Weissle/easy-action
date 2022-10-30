local config = {}

config.config = {
	-- These chars can show up any times.
	free_chars = "0123456789",
	-- These chars can show up no more than twice.
	limited_chars = "iafFtT",
	-- Cancel action.
	terminate_char = "<ESC>",
	-- all action contains `key` will be replaced by `value`. For example yib -> yi(
	remap = {
		ib = "i(",
		ab = "a(",
	},
	-- Default jump provider
	jump_provider = "hop",
	jump_provider_config = {
		hop = {
			action_select = {
				char1 = {
					-- action ends with any char of options will use HopChar1MW command.
					options = "(){}[]<>`'\"",
					cmd = "HopChar1MW",
					feed = function(action)
						return string.sub(action, #action)
					end,
				},
				line = {
					-- action ends with any char of options will use HopLineMW command.
					options = "yd",
					cmd = "HopLineMW",
				},
				-- Default command.
				default = "HopChar2MW",
			},
		},
	},
	-- Just make sure they are greater than 0. Usually 1 is all right.
	jump_back_delay_ms = 1,
	feed_delay_ms = 1,
}

function config:set_config(args)
	config.config = vim.tbl_deep_extend("force", config.config, args or {})
	config.config.terminate_char = vim.api.nvim_replace_termcodes(config.config.terminate_char, true, true, true)
	print(config.config.terminate_char)
	assert(#config.config.terminate_char == 1, "The terminal char should be one key.")
end

return config
