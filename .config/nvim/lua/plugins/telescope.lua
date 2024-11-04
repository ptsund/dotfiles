return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'List project files' })
      vim.keymap.set('n', '<leader>ps', builtin.live_grep, { desc = 'Search in project files' })
      vim.keymap.set('n', '<leader>pb', builtin.buffers, { desc = 'Show buffers' })
    end
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      local ts = require('telescope')

      ts.setup({
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown {}
          }
        }
      })

      ts.load_extension('ui-select')
    end
  }
}
