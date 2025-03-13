return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local dap_widgets = require("dap.ui.widgets")

      -- Keybindings
      vim.keymap.set('n', '<F5>', function() dap.continue() end)
      vim.keymap.set('n', '<F10>', function() dap.step_over() end)
      vim.keymap.set('n', '<F11>', function() dap.step_into() end)
      vim.keymap.set('n', '<F12>', function() dap.step_out() end)
      vim.keymap.set('n', '<Leader>b', function() dap.toggle_breakpoint() end)
      vim.keymap.set('n', '<Leader>B', function() dap.set_breakpoint() end)
      vim.keymap.set('n', '<Leader>lp',
        function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
      vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end)
      vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end)
      vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
        dap_widgets.hover()
      end)
      vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
        dap_widgets.preview()
      end)
      vim.keymap.set('n', '<Leader>df', function()
        dap_widgets.centered_float(dap_widgets.frames)
      end)
      vim.keymap.set('n', '<Leader>ds', function()
        dap_widgets.centered_float(dap_widgets.scopes)
      end)

      -- Adapter configurations
      dap.adapters.python_local = {
        type = "executable",
        command = vim.fn.exepath("python3"),
        args = { "-m", "debugpy.adapter" },
      }

      dap.adapters.python_poetry = {
        type = "executable",
        command = "poetry",
        args = { "run", "python", "-m", "debugpy.adapter" },
      }

      dap.adapters.python_remote = {
        type = "server",
        host = "127.0.0.1",
        port = 5678,
      }


      -- Default debugee configurations
      dap.configurations.python = {
        {
          type = "python_local",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            return vim.fn.exepath("python3")
          end,
        },
        {
          type = "python_poetry",
          request = "launch",
          name = "Launch file (Poetry)",
          program = "${file}",
        },
        {
          type = "python_remote",
          request = "attach",
          name = "Attach to process",
          pid = function()
            return require("dap.utils").pick_process()
          end,
          pythonPath = function()
            return vim.fn.exepath("python3")
          end,
        }
      }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio"
    },
    config = function()
      require("dapui").setup()

      -- Automatically open and close the DAP UI when debugging
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
      dap.listeners.after.event_stopped.dapui_config = function(_, event)
        if event.reason == "exception" then
          local description = event.description or "Unknown error"
          dapui.eval(description .. "\n" .. event.text)
        end
      end

      vim.keymap.set("n", "<Leader>dt", function()
        require("dapui").toggle()
      end, { desc = "Toggle DAP UI" })

      vim.api.nvim_create_user_command("DapUiToggle", function()
        require("dapui").toggle()
      end, {})
    end,
  }
}
