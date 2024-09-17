return {
	"stevearc/aerial.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<F3>", "<cmd>AerialToggle left<CR>", noremap = true, desc = "Toggle Aerial window" },
	},
	opts = {
		layout = {
			max_width = { 120, 0.33 },
			width = nil,
			min_width = 10,
			resize_to_content = true,
		},
	},
}
