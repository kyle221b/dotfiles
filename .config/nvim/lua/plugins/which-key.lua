return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	opts = {
		-- this is set to true by default, and clobbers the lsp "go-to" mappings
		plugins = {
			presets = {
				g = false,
			},
		},
	},
}
