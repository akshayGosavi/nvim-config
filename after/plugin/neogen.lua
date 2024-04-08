local neogen = require('neogen')
vim.keymap.set('n', '<leader>an', neogen.generate, { desc = 'Generate annotations'})
