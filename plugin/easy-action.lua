--- BasicEasyAction
vim.api.nvim_create_user_command("BasicEasyAction", function()
	require("easy-action").base_easy_action(nil, nil, nil)
end, {})
