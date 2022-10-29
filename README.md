# Easy Action

![GitHub Workflow Status](https://img.shields.io/github/workflow/status/Weissle/easy-action/default?style=for-the-badge)
![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)

Easy Action is a plugin which allows you to execute an action, such as yank and delete, but keep your cursor position.
It bases on [EasyMotion](https://github.com/easymotion/vim-easymotion)-like plugins.

## Background
With the easy-motion like plugin, we can easily jump to anywhere visible.
However, it is not so easy to execute an action on where is visible.
Think about how many keys we need to press if we want to yank or delete something which is not under our cursor.

## Status
The whole plugin's status is alpha. 
Your feedbacks are very important to the easy-action's improvement.  
I use hop.nvim, supporting other relative plugins maybe slow.Thus, PR is welcome.

**Currently supported Plugins**:
- [X] [hop.nvim](https://github.com/phaazon/hop.nvim)  
- [ ] [leap.nvim](https://github.com/ggandor/leap.nvim)  
- [ ] [mini.nvim](https://github.com/echasnovski/mini.nvim)

## Install

With packer.nvim
```lua
use{ "Weissle/easy-action" }
```

## Config

```lua
-- Below setting is default and you don't need to copy it. You may just require("easy-action").setup({})
require("easy-action").setup({
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
})
```

**Use other jump plugins**  
```lua
require("easy-action").setup({
	jump_provider = "other_jump_plugin_name",
	jump_provider_config = {
		other_jump_plugin_name = function(action)
			-- Your will get the action which is going to be executed. And you can choose your jump command. 
			-- It can be string, then easy-action will do vim.cmd(ret).
			-- It can be function, then easy-action will call ret().
			-- It can be table, {cmd = string|function, feed = string}, then easy-action will execute this cmd and feed these the `feed`.
		end
	}
})
```

## Usage
easy-motion doesn't change your keymap by default. You may
```lua
local opts = { slient=true, remap=false }
-- Normally you can use <leader>eyy to copy a line. <leader>eyi" to copy the content within a pair of quotation.
vim.keymap.set("n","<leader>e", "<cmd>BasicEasyAction<cr>", opts)

-- To insert something and jump back after you leave the insert mode
vim.keymap.set("n","<leader>ei", function()
	require("easy-action").base_easy_action("i", nil, "InsertLeave")
end, opts)

-- run :h base_easy_action() to see more details about the base_easy_action.

```

