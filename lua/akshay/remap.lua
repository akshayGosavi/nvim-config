vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv" , vim.cmd.Ex)
vim.keymap.set('i', 'kj', '<Esc>')
-- center the search result + and open any folds to see the cursor line
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<leader>w', vim.cmd.write) 
-- add a mark to 'z' register + join two lines + move cursor to mark z
-- this will join current line with line above and keep cursor on same position:
vim.keymap.set("n", "J", "mzJ`z")
