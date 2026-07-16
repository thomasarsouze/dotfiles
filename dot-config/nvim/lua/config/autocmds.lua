-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == "ruff" then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = "LSP: Disable hover capability from Ruff",
})

local repl = require("python_interactive")
local quarto_dispatch = require("quarto-dispatch")

-- autocmd to define so mappings for python
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python" },
  callback = function(args)
    local opts = {
      buffer = args.buf,
      silent = true,
    }

    vim.keymap.set("n", "<CR>", repl.send_line, opts)
    vim.keymap.set("x", "<CR>", repl.send_selection, opts)
    vim.keymap.set("n", "<S-CR>", repl.send_cell, opts)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "quarto",
  callback = function(args)
    vim.keymap.set("n", "<CR>", quarto_dispatch.run_line, {
      buffer = args.buf,
      silent = true,
      desc = "Run current Quarto line",
    })
    vim.keymap.set("x", "<CR>", quarto_dispatch.run_range, {
      buffer = args.buf,
      silent = true,
      desc = "Run Quarto selection",
    })
    vim.keymap.set("n", "<S-CR>", quarto_dispatch.run_cell, {
      buffer = args.buf,
      silent = true,
      desc = "Run Quarto cell",
    })
  end,
})
