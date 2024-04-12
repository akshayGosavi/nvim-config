require('nvim-treesitter.configs').setup({
  ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'javascript', 'html', 'css', 'java', 'properties', 'ruby', 'sql', 'typescript', 'xml' },
  sync_install = false,
  auto_install = true,
  highlight = { enabled = true },
  indent = { enabled = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<C-space>',
      node_incremental = '<C-space>',
      scope_incremental = false,
      node_decremental = '<bs>',
    }
  }
})
