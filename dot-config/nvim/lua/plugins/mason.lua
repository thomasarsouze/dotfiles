return {
  {
    "mason.nvim",
    opts = {
      ensure_installed = {
        -- LSPs
        "ruff",
        "r-languageserver",
        "julia-lsp",
        "marksman",
        -- Formatters
        "black",
        "ruff",
        "isort",
        "jupytext",
        "prettier",
        "markdownlint",
      },
    },
  },
}
