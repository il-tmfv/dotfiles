return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/nvim-cmp",

		{
			"L3MON4D3/LuaSnip",
			build = (function()
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
			dependencies = {
				{
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
		},
		"saadparwaiz1/cmp_luasnip",
	},
	config = function()
		local cmp = require("cmp")

		cmp.setup({
			snippet = {
				-- REQUIRED - you must specify a snippet engine
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},

			completion = {
				completeopt = "menu,menuone,noinsert",
				-- keyword_length = 3,
			},

			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-n>"] = function(fallback)
					if cmp.visible() then
						cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
					else
						fallback()
					end
				end,
				["<C-p>"] = function(fallback)
					if cmp.visible() then
						cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
					else
						fallback()
					end
				end,
				["<C-e>"] = cmp.mapping.abort(),
				["<C-y>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			}),

			sources = cmp.config.sources({
				-- { name = "supermaven" },
				{ name = "codeium" },
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
			}),
		})

		cmp.setup.filetype("minifiles", {
			enabled = false,
		})
	end,
}
