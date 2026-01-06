return {
  -- Pyright configuration
  {
    "neovim/nvim-lspconfig", -- The plugin you're using for LSPs
    config = function()
      -- Pyright setup
      require("lspconfig").pyright.setup({
        settings = {
          pyright = {
            disableorganizeimports = true,
          },
          python = {
            analysis = {
              ignore = { "*" }, -- Disable analysis to use ruff for linting
            },
          },
        },
      })

      -- Ruff LSP setup
      require("lspconfig").ruff.setup({
        init_options = {
          settings = {
            -- Add ruff-specific settings here if necessary
          },
        },
      })
    end,
  },
}

--return {
--	{
--		"neovim/nvim-lspconfig",
--		opts = {
--			servers = {
--				ruff_lsp = {
--					settings = {
--						args = {}, -- Optional: customize Ruff
--					},
--				},
--				pyright = {
--					settings = {
--						python = {
--							pythonPath = vim.fn.exepath("python"),
--						},
--					},
--				},
--				marksman = {},
--				julials = {},
--				r_language_server = {
--					cmd = { "R", "--slave", "-e", "languageserver::run()" },
--				},
--			},
--		},
--	},
--}
