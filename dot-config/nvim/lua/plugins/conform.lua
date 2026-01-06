return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" }, -- "black", Ruff is faster, Black is more opinionated
        r = { "styler" }, -- Popular R formatter
        julia = { "julia_formatter" }, -- Official Julia formatter
        markdown = { "prettier", "markdownlint" }, -- Prettier for general, markdownlint for linting
      },
    },
  },
}
