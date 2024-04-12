require('lualine').setup({
  options = {
    theme = 'catppuccin',
    disabled_filetypes = {
      statusline = { 'NvimTree' },
    },
  },
  sections = {
    lualine_a = {
      'mode' , require('noice').api.statusline.mode.get
    },
  },
})
