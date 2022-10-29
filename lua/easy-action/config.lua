local config = {}

config.config = {
	-- default config
	continue_chars = "0123456789ia",
	stop_char = "", --<ECS>
	remap = {
		ib = "i(",
		ab = "a(",
	},
	jump_provider = "hop",
	jump_provider_config = {
		hop = {
			action_select = {
				char1 = {
					options = "(){}[]<>`'\"",
					cmd = "HopChar1MW",
					feed = function(action)
						return string.sub(action, #action)
					end,
				},
				line = {
					options = "yd",
					cmd = "HopLineStartMW",
				},
				default = "HopWordMW",
			},
		},
	},
	jump_back_delay_ms = 1,
	feed_delay_ms = 1,
}

function config:set_config(args)
	config.config = vim.tbl_deep_extend("force", config.config, args or {})
end

return config
