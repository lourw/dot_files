-- Pull in Requirements --
require('configs.keymaps')
require('configs.settings')
require('configs.lazy_config')

-- Auto-load all LSP configs
local lsp_configs = {}

for _, f in pairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
  local server_name = vim.fn.fnamemodify(f, ':t:r')
  table.insert(lsp_configs, server_name)
end

vim.lsp.enable(lsp_configs)
