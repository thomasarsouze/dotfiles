return {
	--Disabled
	-- add gruvbox
	{ "ellisonleao/gruvbox.nvim", enabled = false },

	-- add tokyonight
	{
		"folke/tokyonight.nvim",
		lazy = true,
		opts = {
			-- "moon", "storm", "night", "day"
			style = "moon",
		},
	},

	-- Disabled
	-- add catppuccin
	{
		"catppuccin/nvim",
		enabled = false,
		lazy = true,
		name = "catppuccin",
		opts = {
			lsp_styles = {
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
				},
			},
			integrations = {
				aerial = true,
				alpha = true,
				cmp = true,
				dashboard = true,
				flash = true,
				fzf = true,
				grug_far = true,
				gitsigns = true,
				headlines = true,
				illuminate = true,
				indent_blankline = { enabled = true },
				leap = true,
				lsp_trouble = true,
				mason = true,
				mini = true,
				navic = { enabled = true, custom_bg = "lualine" },
				neotest = true,
				neotree = true,
				noice = true,
				notify = true,
				snacks = true,
				telescope = true,
				treesitter_context = true,
				which_key = true,
			},
		},
	},

	-- Configure LazyVim to load gruvbox / tokyonight / catpuccin
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "tokyonight",
		},
	},
}
