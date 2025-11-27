return {
	{
		"mfussenegger/nvim-lint",
		opts = {
			-- Configure linters by filetype
			linters_by_ft = {
				python = { "ruff" },
				r = { "lintr" }, -- Popular R linter
				julia = { "julia" }, -- Built-in Julia linter
				markdown = { "markdownlint" }, -- Lint Markdown files
			},
		},
		config = function()
			local lint = require("lint")

			-- Create an autocommand to run linters on save
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					lint.try_lint()
				end,
			})

			-- Optional: Add a keybinding to manually trigger linting
			vim.keymap.set("n", "<leader>cL", function()
				lint.try_lint()
			end, { desc = "Trigger linting for current file" })
		end,
	},
}
