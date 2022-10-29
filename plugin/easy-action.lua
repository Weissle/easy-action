--- EasyActionAny: It it same as any_easy_action()
vim.api.nvim_create_user_command("EasyActionAny", require("easy-action").any_easy_action, {})
