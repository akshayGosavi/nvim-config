vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>pv' , vim.cmd.Ex, { desc = 'Open Netrw file explorer' })
vim.keymap.set('i', 'kj', '<Esc>', { desc = 'Return to Normal mode' })
-- center the search result + and open any folds to see the cursor line
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Center next search result and open any folds' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Center previous search result and open any folds' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Move down a screen and center cursor' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Move up a screen and center cursor' })
vim.keymap.set('n', '<leader>w', vim.cmd.write, { desc = ' Save changes' })
-- add a mark to 'z' register + join two lines + move cursor to mark z
-- this will join current line with line above and keep cursor on same position:
vim.keymap.set("n", "J", "mzJ`z", { desc = ' Join current line with line above and keep cursor on same position' })
