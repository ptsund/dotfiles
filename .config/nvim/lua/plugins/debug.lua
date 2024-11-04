return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'rcarriga/nvim-dap-ui',
      'ldelossa/nvim-dap-projects'
    },
    config = function()
      require('dapui').setup()
      require('nvim-dap-projects').search_project_config()

      local dap, dapui = require('dap'), require('dapui')

      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
      vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Continue' })
      vim.keymap.set('n', '<leader>ds', dap.step_over, { desc = 'Step over' })
      vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Step into' })
      vim.keymap.set('n', '<leader>de', dap.repl.open, { desc = 'Open REPL' })
      vim.keymap.set('n', '<leader>dr', function() dap.restart({}) end, { desc = 'Restart' })
      vim.keymap.set('n', '<leader>dt', function() dap.terminate({}, {}, function() end) end, { desc = 'Terminate' })

      dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/bin/lldb-dap',
        name = 'lldb'
      }

      dap.configurations.rust = {
        {
          name = 'Launch',
          type = 'lldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
        }
      }

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
    end
  }
}
