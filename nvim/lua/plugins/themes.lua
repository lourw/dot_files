return {
  {
    "bluz71/vim-nightfly-colors",
    name = "nightfly", 
    lazy = false,
    -- config = function()
    --     vim.cmd("colorscheme nightfly")
    -- end
  },
  { 
    "catppuccin/nvim", 
    name = "catppuccin", 
    -- config = function()
    --   vim.cmd("colorscheme catppuccin-mocha")
    -- end,
    priority = 1
  },
  {
    'doums/darcula',
    config = function()
      vim.cmd.colorscheme "darcula"
    end
  }
}
