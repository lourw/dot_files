return {
  'nvim-treesitter/nvim-treesitter-context', 
  config=function()
    vim.keymap.set("n", "[c", function()
      require("treesitter-context").go_to_context()
    end, { silent = true })
  end
}
