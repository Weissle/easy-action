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
**Currently supported Plugins**:
- [X] [hop.nvim](https://github.com/phaazon/hop.nvim)
- [ ] [leap.nvim](https://github.com/ggandor/leap.nvim)

## Using it

With packer.nvim
```lua
use{
	"Weissle/easy-motion",
	requires = {"kevinhwang91/promise-async", --[[a easymotion-like plugin]]}
	config = function 
		require("easy-motion").setup({})
		vim.keymap.set("n", "<leader>e", "<cmd>EasyActionAny<cr>", {slient=true, remap=false})
	end
}
```

## Config
