return {
	"akinsho/bufferline.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	lazy = false,
	opts = {
		options = {
			offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "left" } },
			diagnostics = "nvim_lsp",
		},
	},
	keys = {
		{ "<leader>bc", "<cmd>BufferLinePickClose<CR>", noremap = true },
	},
}
