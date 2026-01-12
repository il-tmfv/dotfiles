return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"cbochs/grapple.nvim",
	},
	opts = {
		options = {
			icons_enabled = true,
			theme = "auto",
		},
		tabline = {
			lualine_c = {
				{
					"filename",
					path = 1,
				},
			},
			lualine_y = {
				{
					function()
						local key = require("grapple").name_or_index()
						return "[" .. key .. "]"
					end,
					cond = require("grapple").exists,
				},
			},
		},
	},
}
