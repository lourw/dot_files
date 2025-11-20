-- Note: look at `config/lazy_config.lua` for where we look for treesitter compiler
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
