return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				python = { "ruff_format", "black" }, -- Ruff is faster, Black is more opinionated
				r = { "styler" }, -- Popular R formatter
				julia = { "julia_formatter" }, -- Official Julia formatter
				markdown = { "prettier", "markdownlint" }, -- Prettier for general, markdownlint for linting
			},
			format_on_save = {
				timeout_ms = 500, -- Adjust if formatting is slow
				lsp_fallback = true, -- Fallback to LSP if no formatter is found
			},
		},
	},
}
