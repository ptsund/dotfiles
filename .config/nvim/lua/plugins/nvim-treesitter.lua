return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  build = ':TSUpdate',
  event = {
    'BufReadPre',
    'BufNewFile'
  },
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = {
        'bash',
        'c',
        'c_sharp',
        'cpp',
        'css',
        'dart',
        'diff',
        'dockerfile',
        'git_config',
        'git_rebase',
        'gitattributes',
        'gitcommit',
        'gitignore',
        'glsl',
        'go',
        'graphql',
        'html',
        'http',
        'javascript',
        'jsdoc',
        'json',
        -- 'JSON with comments',
        'llvm',
        'lua',
        'make',
        'markdown',
        'python',
        'ron',
        'rust',
        'ssh_config',
        'toml',
        'typescript',
        'xml',
        'yaml'
      },
      auto_install = true,
      hightlight = {
        enable = true
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<CR>',
          node_incremental = '<CR>',
          node_decremental = '<BS>',
          scope_decremental = false
        }
      },
      indent = {
        enable = false
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner"
          },
        },
      }
    })
  end,
}
