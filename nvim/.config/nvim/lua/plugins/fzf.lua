local exclude_paths = require("exclude_paths").exclude_paths
local exclude_files = "!{" .. table.concat(exclude_paths, ",") .. "}"
local grep_args = [[ { cmd = 'rg --column --line-number --no-heading --color=always --smart-case --no-ignore --hidden --glob "]]
	.. exclude_files
	.. [["' } ]]
local files_args = [[ { fzf_opts = {["-i"] = true}, cmd = 'rg --files --follow --no-ignore --hidden --glob "]]
	.. exclude_files
	.. [["' } ]]

return {
	"ibhagwan/fzf-lua",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
		{ "junegunn/fzf", build = "./install --bin" },
	},
	opts = {
		grep = {
			rg_glob = true,
		},
		keymap = {
			fzf = {
				-- use cltr-q to select all items and convert to quickfix list
				["ctrl-q"] = "select-all+accept",
			},
		},
		winopts = {
			preview = {
				horizontal = "right:50%",
			},
		},
	},
	keys = {
		{
			"<leader>fd",
			"<cmd>lua require('fzf-lua').tags_grep_cword()<cr>",
			noremap = true,
			silent = true,
			desc = "Fzf in ctags definitions for current word",
		},
		{
			"<leader>fD",
			"<cmd>lua require('fzf-lua').tags()<cr>",
			noremap = true,
			silent = true,
			desc = "Fzf in ctags definitions",
		},
		{
			"<leader>/",
			"<cmd>lua require('fzf-lua').blines()<cr>",
			noremap = true,
			silent = true,
			desc = "Fzf in current buffer",
		},
	},
}
