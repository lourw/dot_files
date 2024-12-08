-- Used to navigate with multiple windows
return {
  "yorickpeterse/nvim-window",
  keys = {
    { "Wj", "<cmd>lua require('nvim-window').pick()<cr>", desc = "nvim-window: Jump to window" },
  },
  config = true,
}
