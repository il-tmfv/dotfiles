return {
	"olrtg/nvim-emmet",
	keys = {
		{
			"<leader>xe",
			"<cmd>lua require('nvim-emmet').wrap_with_abbreviation()<cr>",
			mode = "v",
			noremap = true,
			silent = true,
			desc = "Emmet",
		},
	},
}
