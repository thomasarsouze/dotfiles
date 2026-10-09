return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      { "nvim-mini/mini.diff", version = "*" },
    },
    cmd = { "CodeCompanion" },
    opts = {
      strategies = {
        chat = { adapter = "albert" },
        inline = { adapter = "albert" },
        agent = { adapter = "albert" },
      },
      adapters = {
        http = {
          albert = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "albert",
              env = {
                url = "https://albert.api.etalab.gouv.fr/v1",
                chat_url = "/chat/completions",
                models_endpoint = "/models",
                api_key = "ALBERT_API_KEY",
              },
              schema = {
                model = { default = "deepseek-v4-flash-0731" },
              },
            })
          end,
        },
      },
    },
    keys = {
      {
        "<LocalLeader>a",
        "<cmd>CodeCompanionActions<cr>",
        mode = { "n", "v" },
        desc = "CodeCompanion actions",
      },
      {
        "<LocalLeader>r",
        "<cmd>CodeCompanionCodeReview Toggle<cr>",
        mode = { "n", "v" },
        desc = "CodeCompanion Code Review",
      },
      {
        "<LocalLeader>c",
        "<cmd>CodeCompanionChat Toggle<cr>",
        mode = { "n", "v" },
        desc = "Toggle CodeCompanion chat",
      },
      {
        "ga",
        "<cmd>CodeCompanionChat Add<cr>",
        mode = "v",
        desc = "Add to CodeCompanion chat",
      },
      -- Explain the selection
      {
        "<LocalLeader>ie",
        ":'<,'>CodeCompanion /explain<cr>",
        mode = "v",
        desc = "Explain selection",
      },
      -- Fix the selection
      {
        "<LocalLeader>if",
        ":'<,'>CodeCompanion /fix<cr>",
        mode = "v",
        desc = "Fix selection",
      },
      -- LSP diagnostics for the selection
      {
        "<LocalLeader>il",
        ":'<,'>CodeCompanion /lsp<cr>",
        mode = "v",
        desc = "LSP Diagnostics for selection",
      },
      -- Write unit tests for the selection
      {
        "<LocalLeader>it",
        ":'<,'>CodeCompanion /tests<cr>",
        mode = "v",
        desc = "Write tests for selection",
      },
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)
      vim.cmd([[cab aa CodeCompanion]])
      vim.cmd([[cab ai :'<,'>CodeCompanion]])
    end,
  },
}
