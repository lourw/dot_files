-- nvim-treesitter's main branch: parsers are built with the tree-sitter CLI (pinned in
-- mise/config.toml), and highlighting is started by Neovim itself, not a setup() option
local parsers = {
  "python",
  "rust",
  "go",
  "typescript",
  "erlang",
  "elixir"
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false, -- doesn't support lazy-loading
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter').install(parsers)

      -- Highlight any filetype that has a parser installed
      vim.api.nvim_create_autocmd('FileType', {
        callback = function() pcall(vim.treesitter.start) end,
      })
    end
  }
}
