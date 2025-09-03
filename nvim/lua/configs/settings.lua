vim.opt.cursorcolumn = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hlsearch = true
vim.opt.mouse = 'i'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.wrap = true
vim.opt.wildmode = 'longest:full,full'
vim.opt.wildmenu = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.undofile = true

vim.opt.textwidth = 100

-- make long text break using new line instead of cutting off word
vim.opt.linebreak = true

-- make vim recognize - and _ in variables as while words
vim.opt.iskeyword:append("_")
vim.opt.iskeyword:append("-")
