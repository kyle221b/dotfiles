return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
  },
  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = {
      { "L3MON4D3/LuaSnip" },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    opts = {
      keymap = {
        preset = "default",
        ['C-u'] = { "scroll_documentation_up", "fallback" },
        ['C-d'] = { "scroll_documentation_down", "fallback" },
        ['C-j'] = { "snippet_backward", "fallback" },
        ['C-k'] = { "snippet_forward", "fallback" },
      },
      sources = {
        default = { "lsp", "path", "luasnip", "buffer", "dadbod" },
        providers = {
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
        },
      },
      snippets = {
        expand = function(snippet) require("luasnip").lsp_expand(snippet) end,
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").jumpable(filter.direction)
          end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction) require("luasnip").jump(direction) end,
      }
    },
    opts_extend = { "sources.default" },
  },
}
