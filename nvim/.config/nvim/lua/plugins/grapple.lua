return {
	"cbochs/grapple.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{
			"<leader>fl",
			[[<cmd>Grapple toggle_tags<cr>]],
			silent = true,
			noremap = true,
			desc = "Toggle Grapple popup",
		},
		{
			"<leader>fa",
			[[<cmd>Grapple toggle<cr>]],
			silent = true,
			noremap = true,
			desc = "Toggle Grapple anon tag",
		},
		{
			"<leader>fA",
			[[:lua require("grapple").toggle({ name = string.format('"%s"', vim.fn.input('File tag: ')) })<CR>]],
			silent = true,
			noremap = true,
			desc = "Toggle Grapple named tag",
		},
	},
	config = function()
		require("grapple").setup({
			scope = "git_branch",
			popup_options = {
				width = 120,
				height = 16,
			},
		})
	end,
}
