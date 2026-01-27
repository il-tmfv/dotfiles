return {
	"esmuellert/codediff.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	cmd = "CodeDiff",
	keys = {
		{ "<leader>cd", "<cmd>CodeDiff<CR>", noremap = true, silent = true, desc = "Toggle CodeDiff" },
	},
}
