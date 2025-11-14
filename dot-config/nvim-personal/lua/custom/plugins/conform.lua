return {
  'stevearc/conform.nvim',
  opts = {},
  config = function()
    require('conform').setup {
      format_on_save = {
        timeout_ms = 5000,
        lsp_format = 'fallback',
      },
      formatters_by_ft = {
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        lua = { 'stylua' },
        go = { 'gofmt' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
        julia = { 'runic' },
        r = { 'styler' },
      },
      formatters = {
        ['clang-format'] = {
          prepend_args = { '-style=file', '-fallback-style=LLVM' },
        },
      },
    }

    vim.keymap.set('n', '<leader>li', function()
      require('conform').format { bufnr = 0 }
    end)
  end,
}
