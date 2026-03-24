return {
  {
    "neovim/nvim-lspconfig", -- The plugin you're using for LSPs
    opts = {
      servers = {
        -- Python
        pyright = {
          settings = {
            -- Pyright configuration
            pyright = {
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                ignore = { "*" },
              },
            },
          },
        },

        ruff = {
          init_options = {
            settings = {},
          },
        },

        r_language_server = {
          cmd = { "R", "--slave", "-e", "languageserver::run()" },
        },

        marksman = {},

        julials = {},
      },
    },
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
