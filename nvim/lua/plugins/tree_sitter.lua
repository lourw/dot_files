return {
  { 
    'nvim-treesitter/nvim-treesitter', 
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup {
        autotag = {
          enable = true,
        },
        highlight = {
          enable = true,
        }
      }
    end
  }
}
