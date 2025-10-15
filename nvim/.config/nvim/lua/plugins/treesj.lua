return {
	"Wansmer/treesj",
	dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
	keys = {
		{
			"S",
			":lua require('treesj').toggle()<CR>",
			noremap = true,
			silent = true,
			expr = false,
			mode = "n",
			desc = "Split Join toggle",
		},
	},
	config = function()
		require("treesj").setup({ use_default_keymaps = true })
	end,
}
