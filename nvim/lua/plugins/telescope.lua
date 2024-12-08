return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.4',
  dependencies = {
    'nvim-lua/plenary.nvim' 
  },
  config = function()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Grep in Files"})
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find Buffer"})
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Find Tags"})
    vim.keymap.set('n', '<leader>fm', builtin.marks, { desc = "Find Marks"})
    -- LSP Keymaps
    vim.keymap.set('n', '<leader>fd', builtin.lsp_definitions, { desc = "Find Definitions"})
    vim.keymap.set('n', '<leader>fr', builtin.lsp_references, { desc = "Find References"})
    vim.keymap.set('n', '<leader>fi', builtin.lsp_implementations, { desc = "Find Implementations"})
    vim.keymap.set('n', '<leader>ft', builtin.lsp_type_definitions, { desc = "Find Type Definitions"})
  end
}
