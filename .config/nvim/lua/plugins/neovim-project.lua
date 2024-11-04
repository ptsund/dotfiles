return {
  'coffebar/neovim-project',
  init = function()
    -- enable saving the state of plugins in the session
    vim.opt.sessionoptions:append('globals') -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
  end,
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope.nvim', tag = '0.1.4' },
    { 'Shatur/neovim-session-manager' },
  },
  lazy = false,
  priority = 100,
  config = function()
    require('neovim-project').setup({
      projects = {
        '~/ws/*',
        '~/.config/nvim'
      },
      last_session_on_startup = false,
      dashboard_mode = true,
      patterns = {
        ".git",
        "Cargo.toml",
        "package.json"
      }
    })

    vim.keymap.set('n', '<leader>ph', ':Telescope neovim-project history<CR>', { desc = 'Recent projects' })
    vim.keymap.set('n', '<leader>pd', ':Telescope neovim-project discover<CR>', { desc = 'Open project' })
    vim.keymap.set('n', '<leader>pr', ':NeovimProjectLoadRecent<CR>', { desc = 'Restore project' })

    local augroup = vim.api.nvim_create_augroup("user_cmds", { clear = true })
    vim.api.nvim_create_autocmd("DirChanged", {
      pattern = { "*" },
      group = augroup,
      desc = "Update git env for dotfiles after changing directory",
      callback = function()
        require('nvim-dap-projects').search_project_config()
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = { "SessionLoadPost" },
      group = augroup,
      desc = "Update git env for dotfiles after loading session",
      callback = function()
        require('nvim-dap-projects').search_project_config()
      end,
    })
  end
}
