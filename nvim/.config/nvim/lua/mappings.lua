vim.g.mapleader = " "
vim.g.maplocalleader = ";"

vim.api.nvim_set_keymap(
	"n",
	"<leader><leader>",
	":wa<CR>",
	{ noremap = true, silent = true, desc = "Quick save all files" }
)

vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = true, silent = true, desc = "Simulate Esc" })

-- buffers
vim.api.nvim_set_keymap("n", "<TAB>", "<cmd>bnext<CR>", { noremap = true, silent = true, desc = "Move to next buffer" })
vim.api.nvim_set_keymap(
	"n",
	"<S-TAB>",
	"<cmd>bprevious<CR>",
	{ noremap = true, silent = true, desc = "Move to previous buffer" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>a",
	"<cmd>A<CR>",
	{ noremap = true, silent = true, desc = "Move to alternate file" }
)

-- Move to window using the <ctrl> hjkl keys
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- better indenting
vim.api.nvim_set_keymap("v", "<", "<gv", { desc = "Move selection to the left" })
vim.api.nvim_set_keymap("v", ">", ">gv", { desc = "Move selection to the right" })

-- move selection
vim.api.nvim_set_keymap("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selected lines down" })
vim.api.nvim_set_keymap("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selected lines up" })

-- open file in external program
vim.api.nvim_set_keymap("n", "gO", "<cmd>!open <cfile><CR>", { desc = "Open file in external program" })

-- copy text selected with mouse
vim.api.nvim_set_keymap("v", "<LeftRelease>", '"*ygv', { desc = "Copy text selected with mouse" })

-- search without moving cursor
vim.api.nvim_set_keymap("n", "*", "*``", { desc = "Search without moving cursor" })

-- change word under cursor or visual selection, repeat with .
vim.api.nvim_set_keymap(
	"n",
	"<leader>cw",
	[[:let @/='\<'.expand('<cword>').'\>'<CR>cgn]],
	{ noremap = true, silent = true, desc = "Change word under cursor and continue with ." }
)
vim.api.nvim_set_keymap(
	"x",
	"<leader>cw",
	[["sy:let @/=@s<CR>cgn]],
	{ noremap = true, silent = true, desc = "Change word under cursor and continue with ." }
)

-- prepares command for replacement
vim.api.nvim_set_keymap("n", [[\\]], [[:%s///g<Left><Left>]], { desc = "Prepares command for replacement" })
vim.api.nvim_set_keymap("x", [[\\]], [[:s///g<Left><Left>]], { desc = "Prepares command for replacement" })
vim.api.nvim_set_keymap("n", [[\\\]], ":cdo s///g<Left><Left>", { desc = "Prepares :cdo command for replacement" })

-- Copy file name/path/line numbers etc
local function copy_and_notify(text)
	vim.fn.setreg("+", text)
	vim.notify(("Copied: " .. text))
	return text
end
local function copy_filepath_with_line()
	local filepath = vim.fn.expand("%")
	local line_number = vim.fn.line(".")
	local filepath_with_line = ("@" .. filepath .. " on line " .. line_number)
	return copy_and_notify(filepath_with_line)
end
local function copy_file_reference()
	local filepath = vim.fn.expand("%:p")
	local line_number = vim.fn.line(".")
	local filepath_with_line = (filepath .. ":" .. line_number)
	return copy_and_notify(filepath_with_line)
end
local function copy_filepath()
	local filepath = vim.fn.expand("%")
	local prefixed = ("@" .. filepath)
	return copy_and_notify(prefixed)
end
local function copy_word_with_filepath()
	local word = vim.fn.expand("<cword>")
	local filepath = vim.fn.expand("%:p")
	local line_number = vim.fn.line(".")
	local word_with_filepath = ("`" .. word .. "` (@" .. filepath .. " on line " .. line_number .. ")")
	return copy_and_notify(word_with_filepath)
end
local function copy_filepath_with_line_range()
	local filepath = vim.fn.expand("%")
	local start_line = vim.fn.getpos("v")[2]
	local end_line = vim.fn.line(".")
	local sorted_start = math.min(start_line, end_line)
	local sorted_end = math.max(start_line, end_line)
	local filepath_with_range = ("@" .. filepath .. " line " .. sorted_start .. " to " .. sorted_end)
	return copy_and_notify(filepath_with_range)
end

local mappings = {
	{ "n", "<leader>Cr", copy_file_reference, "Copy current file reference" },
	{ "n", "<leader>Cc", copy_filepath_with_line, "Copy current filepath with line number" },
	{ "n", "<leader>CC", copy_filepath, "Copy current filepath" },
	{ "n", "<leader>Cw", copy_word_with_filepath, "Copy word under cursor with filepath and line number" },
	{ "v", "<leader>Cr", copy_filepath_with_line_range, "Copy filepath with line range" },
}

for _, mapping in ipairs(mappings) do
	vim.keymap.set(mapping[1], mapping[2], mapping[3], {
		noremap = true,
		silent = true,
		desc = mapping[4],
	})
end
