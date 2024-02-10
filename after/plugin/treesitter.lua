require('nvim-treesitter.configs').setup({
	ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'javascript', 'html', 'css', 'java', 'properties', 'ruby', 'sql', 'typescript', 'xml' },
	sync_install = false,
	auto_install = true,
	highlight = { enabled = true },
})
