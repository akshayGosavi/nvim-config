require('noice').setup({
	lsp = {
		-- override markdown rendering so other plugins use 'treesitter'
		override = {
			['vim.lsp.util.convert_input_to_markdown_lines'] = true,
			['vim.lsp.util.stylize_markdown'] = true,
		},
	},
})
