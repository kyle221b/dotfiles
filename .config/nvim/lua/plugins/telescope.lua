return {
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.4',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'debugloop/telescope-undo.nvim',
      'nvim-telescope/telescope-frecency.nvim',
    },
    config = function()
      require('telescope').setup({
        extensions = {
          undo = {
            use_delta = true,
            side_by_side = true,
            layout_strategy = "vertical",
            layout_config = {
              preview_height = 0.8,
            }
          },
          frecency = {
            default_workspace = 'CWD',
          },
        }
      })
      require('telescope').load_extension('undo')
      require('telescope').load_extension('fzf')
      require('telescope').load_extension('frecency')
    end,
    init = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader><leader>', '<Cmd>Telescope frecency<CR>', { desc = 'Find frecent' })
      vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Git files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffer' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Find help' })
      vim.keymap.set("n", "<leader>u", "<CMD>Telescope undo<CR>")
    end
  },
}
