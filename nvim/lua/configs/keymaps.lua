vim.g.mapleader = " "

vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })
vim.keymap.set("n", ":Q", ":q!", { desc = "Exit" })
vim.keymap.set('n', '<Leader>b', ':b#<Cr>', { desc = "Goto Previous Buffer" })

vim.keymap.set('n', '<Leader>q', ':q<Cr>', { desc = "Quit Buffer" })
vim.keymap.set('n', '<Leader>t', ':terminal<Cr>', { desc = "Terminal" })
vim.keymap.set('n', '<Leader>w', ':update<Cr>', { desc = "Write Buffer" })
vim.keymap.set('n', '<Leader>o', ':Oil --float<Cr>', { desc = "Open Filesystem"})

vim.keymap.set('n', 'Wj', '<c-w>j')
vim.keymap.set('n', 'Wh', '<c-w>h')
vim.keymap.set('n', 'Wk', '<c-w>k')
vim.keymap.set('n', 'Wj', '<c-w>j')

vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Escape Terminal Mode" })
vim.keymap.set("v", "y", "myy`y", { desc = "Keep Cursor In Place on Yank"})
