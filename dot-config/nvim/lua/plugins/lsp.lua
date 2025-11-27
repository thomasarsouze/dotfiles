return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				ruff_lsp = {
					settings = {
						args = {}, -- Optional: customize Ruff
					},
				},
				pyright = {
					settings = {
						python = {
							pythonPath = vim.fn.exepath("python"),
						},
					},
				},
				marksman = {},
				julials = {},
				r_language_server = {
					cmd = { "R", "--slave", "-e", "languageserver::run()" },
				},
			},
		},
	},
}
