return { -- LLMs
  {
    'olimorris/codecompanion.nvim',
    version = '*',
    enabled = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim',
    },
    keys = {
      { '<leader>ac', ':CodeCompanionChat Toggle<cr>', desc = '[a]i [c]hat' },
      { '<leader>aa', ':CodeCompanionActions<cr>', desc = '[a]i [a]actions' },
    },
    config = function()
      require('codecompanion').setup {
        display = {
          diff = {
            enabled = true,
          },
        },
        strategies = {
          chat = {
            -- adapter = "ollama",
            adapter = 'copilot',
          },
          inline = {
            -- adapter = "ollama",
            adapter = 'copilot',
          },
          agent = {
            -- adapter = "ollama",
            adapter = 'copilot',
          },
        },
      }
    end,
  },
}
