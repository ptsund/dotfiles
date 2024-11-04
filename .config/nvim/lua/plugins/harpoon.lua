return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope.nvim', tag = '0.1.5' }
  },
  config = function()
    local harpoon = require('harpoon')
    harpoon:setup()

    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
          results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
      }):find()
    end

    vim.keymap.set('n', '<leader>ma', function() harpoon:list():append() end, { desc = 'Add mark' })
    vim.keymap.set('n', '<leader>mr', function() harpoon:list():remove() end, { desc = 'Remove mark' })
    vim.keymap.set('n', '<leader>ml', function() toggle_telescope(harpoon:list()) end, { desc = 'List marks' })
    vim.keymap.set('n', '<C-1>', function() harpoon:list():select(1) end, { desc = 'Go to first mark' })
    vim.keymap.set('n', '<C-2>', function() harpoon:list():select(2) end, { desc = 'Go to second mark' })
    vim.keymap.set('n', '<C-3>', function() harpoon:list():select(3) end, { desc = 'Go to third mark' })
    vim.keymap.set('n', '<C-4>', function() harpoon:list():select(4) end, { desc = 'Go to fourth mark' })
    vim.keymap.set('n', '<C-p>', function() harpoon:list():prev() end, { desc = 'Go to previous mark' })
    vim.keymap.set('n', '<C-n>', function() harpoon:list():next() end, { desc = 'Go to next mark' })
  end,
}
