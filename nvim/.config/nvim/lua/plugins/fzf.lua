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
		{
			"<leader>fj",
			"<cmd>lua require('fzf-lua').buffers()<cr>",
			noremap = true,
			silent = true,
			desc = "Fzf in opened buffer",
		},
		{
			"<leader>fo",
			"<cmd>lua require('fzf-lua').oldfiles(" .. files_args .. ")<cr>",
			noremap = true,
			silent = true,
			desc = "Fzf in previously opened buffers",
		},
		{
			"<leader>fc",
			"<cmd>lua require('fzf-lua').resume()<cr>",
			noremap = true,
			silent = true,
			desc = "Resume the last Fzf search",
		},
		{
			"<leader>ff",
			"<cmd>lua require('fzf-lua').files(" .. files_args .. ")<cr>",
			noremap = true,
			silent = true,
			desc = "Fzf for files",
		},
		{
			"<leader>fg",
			"<cmd>lua require('fzf-lua').live_grep_glob(" .. grep_args .. ")<cr>",
			noremap = true,
			silent = true,
			desc = "Fzf in files",
		},
		{
			"<leader>fw",
			"*``<cmd>lua require('fzf-lua').grep_cword(" .. grep_args .. ")<cr>",
			noremap = true,
			silent = true,
			desc = "Fzf in files for current word",
		},
		{
			"<leader>fw",
			"*``<cmd>lua require('fzf-lua').grep_visual(" .. grep_args .. ")<cr>",
			mode = "v",
			noremap = true,
			silent = true,
			desc = "Fzf in files for current word",
		},
	},
}
