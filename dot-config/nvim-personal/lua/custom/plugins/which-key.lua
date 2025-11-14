return {
  { -- show keybinding help window
    'folke/which-key.nvim',
    enabled = true,
    config = function()
      require('which-key').setup {}
      require('custom.config.keymaps')
    end,
  },
}