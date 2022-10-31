# easy-action

![GitHub Workflow Status](https://img.shields.io/github/workflow/status/Weissle/easy-action/default?style=for-the-badge)
![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)

easy-action is a plugin which allows you to execute an action, such as yank and delete, but keeps your cursor position.

It bases on [EasyMotion](https://github.com/easymotion/vim-easymotion)-like plugins.
When use EasyMotion-like plugin, you need to trigger them and choose the position you jump.
For easy-action, you need to trigger easy-action, input your action, choose where to perform the action.

In the below example, my cursor is on the left window and I will copy and delete the text on the right window which is around 45 line. In this example, I use `<space>e` to trigger easy-action.


https://user-images.githubusercontent.com/29982556/198888179-22180ad5-6248-45ef-b494-7051b672dd80.mp4


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
- [X] [leap.nvim](https://github.com/ggandor/leap.nvim)  
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
  -- These chars can show up any times in your action input.
  free_chars = "0123456789",
  -- These chars can show up no more than twice in action input.
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
    leap = {
      action_select = {
        default = function()
          require("leap").leap({ target_windows = require("leap.util").get_enterable_windows() })
        end,
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
      -- It can be table, {cmd = string|function, feed = string}, then easy-action will execute this cmd and feed the `feed`.
    end
  }
})
```

## Usage
easy-action doesn't change your keymap by default. You may
```lua
local opts = { slient=true, remap=false }
-- trigger easy-action.
vim.keymap.set("n","<leader>e", "<cmd>BasicEasyAction<cr>", opts)

-- To insert something and jump back after you leave the insert mode
vim.keymap.set("n","<leader>ei", function()
  require("easy-action").base_easy_action("i", nil, "InsertLeave")
end, opts)

-- run :h base_easy_action() to see more details about the base_easy_action.

```

