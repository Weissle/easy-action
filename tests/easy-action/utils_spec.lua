local utils = require("easy-action.utils")

describe("utils.char_in_str", function()
	local normal_str = "abcdefg,.[]"
	it("normal char -> ret true", function()
		for _, v in ipairs({ "a", "b", "c", "d", "e", "f", "g", ",", ",", "[", "]" }) do
			assert(utils.char_in_str(v, normal_str))
		end
	end)
	it("normal char -> ret false", function()
		for _, v in ipairs({ "n", "m", "z", ")" }) do
			assert(utils.char_in_str(v, normal_str) == false)
		end
	end)
end)

describe("utils.equal", function()
	local empty_fa = function() end
	local empty_fb = function() end
	it("simple equal", function()
		assert(utils.equal(123, 123))
		assert(utils.equal("123", "123"))
		assert(utils.equal(true, true))
		assert(utils.equal(false, false))
		assert(utils.equal(empty_fa, empty_fa))
	end)
	it("simple not equal", function()
		assert(utils.equal(123, 456) == false)
		assert(utils.equal(123, "123") == false)
		assert(utils.equal("123", "223") == false)
		assert(utils.equal(true, false) == false)
		assert(utils.equal(false, true) == false)
		assert(utils.equal(empty_fa, empty_fb) == false)
	end)
	local tbl_a = {
		a = 1,
		b = 2,
		c = {
			hello = "hello",
		},
	}
	local tbl_b = {
		a = 1,
		b = 2,
		c = {
			hello = "hello",
		},
	}
	it("table equal", function()
		assert(utils.equal(tbl_a, tbl_b))
	end)
	tbl_b.c.happy = "happy"
	it("table not equal", function()
		assert(utils.equal(tbl_a, tbl_b) == false)
	end)
end)

