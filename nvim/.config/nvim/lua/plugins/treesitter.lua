return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		"MeanderingProgrammer/treesitter-modules.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			-- A list of parser names, or "all"
			ensure_installed = {
				"clojure",
				"ruby",
				"elixir",
				"heex",
				"eex",
				"javascript",
				"typescript",
				"tsx",
				"scss",
				"html",
				"yaml",
				"lua",
				"vim",
				"markdown",
			},
			-- fold = { enable = true },
			highlight = { enable = true },
			incremental_selection = {
				enable = true,
				disable = false,
				keymaps = {
					node_incremental = ".",
					node_decremental = ",",
				},
			},
			endwise = {
				enable = true,
			},
		},
	},
}
