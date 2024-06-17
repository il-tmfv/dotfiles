return {
	"Exafunction/codeium.vim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	config = function()
		vim.g.codeium_log_file = "~/.codeium/codeium.log"
		vim.g.codeium_disable_bindings = 1

		vim.keymap.set("i", "<C-y>", function()
			return vim.fn["codeium#Accept"]()
		end, { expr = true, silent = true })

		vim.keymap.set("n", "<F12>", function()
			return vim.fn["codeium#Chat"]()
		end, { expr = true, silent = true, desc = "Start Codeium chat" })

		vim.keymap.set("i", "<C-n>", function()
			return vim.fn["codeium#CycleCompletions"](1)
		end, { expr = true, silent = true, desc = "Next Codeium completion" })

		vim.keymap.set("i", "<C-e>", function()
			return vim.fn["codeium#Clear"]()
		end, { expr = true, silent = true, desc = "Clear Codeium suggestion" })
	end,
}
