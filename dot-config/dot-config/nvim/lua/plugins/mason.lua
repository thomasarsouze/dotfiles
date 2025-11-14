return {
	{
		"mason.nvim",
		opts = {
			ensure_installed = {
				-- LSPs
				"ruff",
				"r_language_server",
				"julials",
				"marksman",
				-- Formatters
				"black",
				"ruff",
				"isort",
				"jupytext",
				"styler",
				"julia-formatter",
				"prettier",
				"markdownlint",
				-- Linters
				"linter",
			},
		},
	},
}
