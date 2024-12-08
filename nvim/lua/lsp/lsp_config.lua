-- Setup language servers.
local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}
lspconfig.rust_analyzer.setup {}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<Leader>gq', vim.diagnostic.open_float, { desc = "Open Diagnostic"})
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<Leader>gw', vim.diagnostic.setloclist, { desc = "Diagnostic List"})

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
    vim.keymap.set('n', '<Leader>gD', vim.lsp.buf.declaration, { desc = "Get Declaration" })
    vim.keymap.set('n', '<Leader>gd', vim.lsp.buf.definition, { desc = "Get Definition" })
    vim.keymap.set('n', '<Leader>K', vim.lsp.buf.hover, { desc = "Documentation on Hover" })
    vim.keymap.set('n', '<Leader>gi', vim.lsp.buf.implementation, { desc = "Get Implementation" })
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { desc = "Signature Help" })
    vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, { desc = "Add Workspace Folder" })
    vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = "Remove Workspace Folder" })
    vim.keymap.set('n', '<Leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, { desc = "List Workspace Folders" })
    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, { desc = "Rename" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>ca', vim.lsp.buf.code_action, { desc = "Code Action" })
    vim.keymap.set('n', '<Leader>gr', vim.lsp.buf.references, { desc = "Get References" })
    vim.keymap.set('n', '<Leader>gf', function()
      vim.lsp.buf.format { async = true }
    end, { desc = "AutoFormat" })
  end,
})
