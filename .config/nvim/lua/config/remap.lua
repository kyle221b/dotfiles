vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

vim.keymap.set("c", "<C-a>", "<C-b>")
vim.keymap.set("c", "<M-b>", "<S-Left>")
vim.keymap.set("c", "<M-f>", "<S-Right>")
vim.keymap.set("c", "<M-h>", "<Left>")
vim.keymap.set("c", "<M-l>", "<Right>")

vim.keymap.set("v", ".", ":norm.<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "[t", "gT")
vim.keymap.set("n", "]t", "gt")

vim.keymap.set("x", "<leader>p", '"_dP')

vim.keymap.set("n", "<M-j>", function()
	for _, win in pairs(vim.fn.getwininfo()) do
		if win["quickfix"] == 1 then
			vim.cmd("ccl")
			return
		end
		vim.cmd("copen")
	end
end, { desc = "Toggle quickfix" })
