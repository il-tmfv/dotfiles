return {
	"xzbdmw/clasp.nvim",
	config = function()
		require("clasp").setup({
			pairs = { ["{"] = "}", ['"'] = '"', ["'"] = "'", ["("] = ")", ["["] = "]", ["<"] = ">" },
			-- If called from insert mode, do not return to normal mode.
			keep_insert_mode = true,
		})

		-- jumping from smallest region to largest region
		vim.keymap.set({ "n" }, "L", function()
			require("clasp").wrap("next")
		end)

		-- jumping from largest region to smallest region
		vim.keymap.set({ "n" }, "H", function()
			require("clasp").wrap("prev")
		end)
	end,
}
