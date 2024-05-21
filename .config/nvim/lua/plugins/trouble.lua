return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	init = function()
		local trouble = require("trouble")
		-- Lua
		vim.keymap.set("n", "<leader>tt", function()
			trouble.toggle()
		end, { desc = "Trouble: toggle" })
		vim.keymap.set("n", "<leader>tw", function()
			trouble.toggle("workspace_diagnostics")
		end, { desc = "Trouble: workspace diagnostics" })
		vim.keymap.set("n", "<leader>td", function()
			trouble.toggle("document_diagnostics")
		end, { desc = "Trouble: document diagnostics" })
		vim.keymap.set("n", "<leader>tq", function()
			trouble.toggle("quickfix")
		end, { desc = "Trouble: quickfix" })
		vim.keymap.set("n", "<leader>tl", function()
			trouble.toggle("loclist")
		end, { desc = "Trouble: loclist" })
		vim.keymap.set("n", "tr", function()
			trouble.toggle("lsp_references")
		end, { desc = "Trouble: references" })
	end,
}
