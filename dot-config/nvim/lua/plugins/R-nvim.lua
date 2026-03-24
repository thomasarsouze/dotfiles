return {
  {
    "R-nvim/R.nvim",
    init = function()
      -- Disable legacy nvimcom support
      vim.g.R_nvimcom = 0
      -- Disable rnvimserver entirely
      vim.g.R_use_rnvimserver = 0
      -- Disable Quarto auto rnvimserver (optional)
      vim.g.R_quarto_use_rnvimserver = 0 -- Disable legacy nvimcom support
    end,
  },
}
