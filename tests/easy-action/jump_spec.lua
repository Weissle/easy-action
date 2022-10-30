local config_module = require("easy-action.config")
local utils = require("easy-action.utils")
local jump = require("easy-action.jump")

describe("jump.get_jump_cmd", function()
	local config = config_module.config
	it("hop", function()
		assert(utils.equal(jump.get_jump_cmd("yi{"), {
			cmd = "HopChar1MW",
			feed = "{",
		}))
		assert(utils.equal(jump.get_jump_cmd("yfb"), "HopChar2MW"))
		assert(utils.equal(jump.get_jump_cmd("3yy"), { cmd = "HopLineMW" }))
		assert(utils.equal(jump.get_jump_cmd("y3w"), "HopChar2MW"))
	end)

	it("user defined", function()
		config.jump_provider = "other"
		config.jump_provider_config.other = "abc"
		assert(utils.equal(jump.get_jump_cmd("yfb"), "abc"))
		config.jump_provider_config.other = { tbl = "table" }
		assert(utils.equal(jump.get_jump_cmd("any"), { tbl = "table" }))
		config.jump_provider_config.other = function(_)
			return "abc"
		end
		assert(utils.equal(jump.get_jump_cmd("any"), "abc"))
	end)

end)

-- TODO:  ut for jump.do_jump_cmd
