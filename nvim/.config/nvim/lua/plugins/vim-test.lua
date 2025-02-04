return {
	"vim-test/vim-test",
	dependencies = { "preservim/vimux" },
	config = function()
		vim.cmd("let test#strategy = 'vimux'")
		vim.cmd("let VimuxUseNearest = 0")
	end,
	keys = {
		{ "<leader>tn", ":TestNearest<CR>", noremap = true, silent = true, desc = "Test nearest line" },
		{ "<leader>tf", ":TestFile<CR>", noremap = true, silent = true, desc = "Test file" },
		{ "<leader>ts", ":TestSuite<CR>", noremap = true, silent = true, desc = "Test suite" },
		{ "<leader>tl", ":TestLast<CR>", noremap = true, silent = true, desc = "Test last" },
		{ "<leader>tv", ":TestVisit<CR>", noremap = true, silent = true, desc = "Open the last test file" },
	},
}
