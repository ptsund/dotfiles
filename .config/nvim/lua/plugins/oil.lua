return {
  'stevearc/oil.nvim',
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  config = function()
    local oil = require('oil')
    oil.setup()
    vim.keymap.set('n', '<leader>fe', function() oil.toggle_float(vim.fn.getcwd()) end,
      { desc = 'Open directory in buffer' })
  end,
}
