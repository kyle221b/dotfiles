return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = true,
  },
  {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason-lspconfig.nvim" },
      { "folke/neodev.nvim",                opts = {} },
      { "j-hui/fidget.nvim" },
    },
    config = function()
      local telescope = require("telescope.builtin")

      -- so these can be global keybindings
      vim.keymap.set("n", "gl", vim.diagnostic.open_float)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function(event)
          local bufnr = event.buf
          local opts = { buffer = bufnr }
          local group = vim.api.nvim_create_augroup("lsp", { clear = true })

          -- these will be buffer-local keybindings
          -- because they only work if you have an active language server

          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

          -- Use telescope for a lot of the lsp lookups
          vim.keymap.set("n", "gd", telescope.lsp_definitions, { buffer = bufnr, desc = "Go to definition" })
          vim.keymap.set(
            "n",
            "gi",
            telescope.lsp_implementations,
            { buffer = bufnr, desc = "Go to implementations" }
          )
          vim.keymap.set("n", "gr", telescope.lsp_references, { buffer = bufnr, desc = "Go to references" })
          vim.keymap.set(
            "n",
            "gt",
            telescope.lsp_type_definitions,
            { buffer = bufnr, desc = "Go to type definitions" }
          )
          vim.keymap.set(
            { "n", "i" },
            "<C-k>",
            vim.lsp.buf.signature_help,
            { buffer = bufnr, desc = "Signature help" }
          )
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename" })
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          -- note: diagnostics are not exclusive to lsp servers
        end,
      })

      local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      local default_setup = function(server)
        lspconfig[server].setup({
          capabilities = lsp_capabilities,
        })
      end

      require("mason").setup({})
      require("mason-lspconfig").setup({
        ensure_installed = { "tsserver", "lua_ls" },
        handlers = {
          default_setup,
          ruff = function()
            lspconfig.ruff.setup({
              capabilities = lsp_capabilities,
              on_attach = function(client)
                if client.name == "ruff" then
                  -- Disable hover in favor of Pyright
                  client.server_capabilities.hoverProvider = false
                end
              end,
            })
          end,
          pyright = function()
            lspconfig.pyright.setup({
              settings = {
                pyright = {
                  -- Using Ruff's import organizer
                  disableOrganizeImports = true,
                },
                python = {
                  analysis = {
                    -- Ignore all files for analysis to exclusively use Ruff for linting
                    ignore = { "*" },
                  },
                },
              },
            })
          end,
          lua_ls = function()
            lspconfig.lua_ls.setup({
              capabilities = lsp_capabilities,
              Lua = {
                runtime = {
                  version = "LuaJIT",
                },
                diagnostics = {
                  globals = { "vim" },
                },
                workspace = {
                  library = {
                    vim.env.VIMRUNTIME,
                  },
                },
              },
            })
          end,
        },
      })
    end,
  },
}
