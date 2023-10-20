-- Setup language servers.
local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}
lspconfig.rust_analyzer.setup {}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>gq', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>gw', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts, { desc = "Get Declaration" })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts, { desc = "Get Definition" })
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts, { desc = "Documentation on Hover" })
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts, { desc = "Get Implementation" })
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts, { desc = "Signature Help" })
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts, { desc = "Add Workspace Folder" })
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts, { desc = "Remove Workspace Folder" })
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts, { desc = "List Workspace Folders" })
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts, { desc = "Rename" })
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<space>gr', vim.lsp.buf.references, opts, { desc = "Get References" })
    vim.keymap.set('n', '<space>gf', function()
      vim.lsp.buf.format { async = true }
    end, opts, { desc = "AutoFormat" })
  end,
})
