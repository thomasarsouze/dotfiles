return { -- If you'd rather extend the default config, use the code below instead:
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			-- add julia and r treesitter
			vim.list_extend(opts.ensure_installed, {
				"julia",
				"r",
			})
		end,
	},
}
