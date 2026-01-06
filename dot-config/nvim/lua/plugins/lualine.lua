return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = {
            {
              function()
                local venv_path = require("venv-selector").venv()
                if not venv_path or venv_path == "" then
                  return ""
                end

                local venv_name = vim.fn.fnamemodify(venv_path, ":t")
                if not venv_name or venv_name == "" then
                  return ""
                end

                return "🐍 " .. venv_name
              end,
              cond = function()
                return vim.bo.filetype == "python" or vim.bo.filetype == "quarto"
              end,
            },
            "encoding",
            "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}
