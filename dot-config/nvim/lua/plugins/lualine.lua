return {
  {
    "nvim-lualine/lualine.nvim",
    options = {
      sections = {
        lualine_c = {
          {
            "filepath",
            path = 1,
            shorting_target = 80, -- adjust as needed
          },
        },
      },
    },
  },
}
