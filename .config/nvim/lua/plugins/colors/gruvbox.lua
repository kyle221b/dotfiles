return {
	"ellisonleao/gruvbox.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		bold = false,
	},
	init = function()
		vim.g.gruvbox_contrast_dark = "dark"
	end,
}
