local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find [F]iles' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[G]rep search' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find [B]uffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Find [H]elp' })
vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Find [G]it Files' })
-- git actions with telescope
vim.keymap.set('n', '<leader>gst', builtin.git_status, { desc ='Git Status' });
vim.keymap.set('n', '<leader>gsh', builtin.git_stash, { desc ='Git Stash' });

