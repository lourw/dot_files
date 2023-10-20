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
    priority = 1000,
  },
  {
    'doums/darcula',
    config = function()
      vim.cmd.colorscheme "darcula"
    end
  }
}
