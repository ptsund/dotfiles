return {
  'akinsho/toggleterm.nvim',
  config = function()
    require('toggleterm').setup({
      open_mapping = [[<leader><CR>]],
      direction = 'float',
      insert_mappings = false,
      float_opts = {
        border = 'curved'
      }
    })
  end
}
