-- Used to focus / higlight on dedicated class / functions / etc...
return {
  -- Lua
  {
    "folke/twilight.nvim",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      context = 14, -- amount of lines we will try to show around the current line
    },
    keys = {
      { "<leader>ut", "<cmd>Twilight<CR>", desc = "Toggle Twilight" },
    },
  },
}
