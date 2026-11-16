return {
  {
    "saghen/blink.cmp",
    dependencies = { "R-nvim/cmp-r", "saghen/blink.compat" },
    opts = {
      sources = {
        compat = { "cmp_r" },
        providers = {
          cmp_r = { kind = "R" },
        },
      },
    },
  },
}
