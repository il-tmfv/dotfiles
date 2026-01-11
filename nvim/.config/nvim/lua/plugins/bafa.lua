return {
	"mistweaverco/bafa.nvim",
	version = "v1.10.1",
	keys = {
		{
			"<leader>fj",
			"<cmd>lua require('bafa').toggle()<CR>",
			noremap = true,
			silent = true,
			desc = "View opened buffers",
		},
	},
}
