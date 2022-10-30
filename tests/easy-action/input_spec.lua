local config_module = require("easy-action.config")
local input = require("easy-action.input")

local function input_mock_factory(str)
	local ret = {
		index = 1,
	}
	function ret:get()
		assert(ret.index <= #str)
		local c = string.sub(str, ret.index, ret.index)
		ret.index = ret.index + 1
		return c
	end
	return ret
end

describe("input.input", function()
	it("default test", function()
		config_module.config.terminate_char = ""
		local input_mock = input_mock_factory("123456yy??????")
		vim.fn.getcharstr = input_mock.get
		assert(input.input(nil, nil, nil) == "123456y")

		input_mock = input_mock_factory("30ff??????")
		vim.fn.getcharstr = input_mock.get
		assert(input.input(nil, nil, nil) == "30ff")

		input_mock = input_mock_factory("30f??????")
		vim.fn.getcharstr = input_mock.get
		local cmd = input.input(nil, nil, nil)
		assert(cmd == nil)
	end)
end)

describe("input.get_action", function()
	it("string test", function()
		assert(input.get_action("qwert") == "qwert")
		assert(input.get_action("yib") == "yi(")
		assert(input.get_action("ya{") == "ya{")
	end)
	it("input test", function()
		local input_mock = input_mock_factory("123456yy??????")
		vim.fn.getcharstr = input_mock.get
		assert(input.get_action(nil) == "123456yy")

		input_mock = input_mock_factory("y30w")
		vim.fn.getcharstr = input_mock.get
		assert(input.get_action(nil) == "y30w")

		input_mock = input_mock_factory("ib")
		vim.fn.getcharstr = input_mock.get
		assert(input.get_action({
			verb = "custom_verb",
			range = nil,
		}) == "custom_verbi(")

		input_mock = input_mock_factory("y")
		vim.fn.getcharstr = input_mock.get
		assert(input.get_action(nil) == "")
	end)
end)
-- TODO: UT for input.input_verb
