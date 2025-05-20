vim.g.mapleader = " "

vim.keymap.set("n", "<C-q>", ":qa<CR>", { noremap = true, silent = true })

-- CTRL+S to save buffer
vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })

-- Better page jump by centering
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-b>", "<C-b>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-f>", "<C-f>zz", { noremap = true, silent = true })
