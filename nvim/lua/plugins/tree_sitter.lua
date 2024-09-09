return {
  { 
    'nvim-treesitter/nvim-treesitter', 
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          "python",
          "rust",
          "go",
          "norg",
          "typescript",
          "erlang",
          "elixir"
        },
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
