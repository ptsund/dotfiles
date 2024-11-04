return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v3.x',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig'
  },
  config = function()
    local lsp_zero = require('lsp-zero')

    lsp_zero.on_attach(function(_, bufnr)
      lsp_zero.default_keymaps({
        buffer = bufnr,
        preserve_mappings = false
      })

      lsp_zero.buffer_autoformat()

      local function opts(t)
        t.buffer = bufnr
        t.remap = false
        return t
      end

      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts({ desc = 'Go to definition' }))
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts({ desc = 'Go to declaration' }))
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts({ desc = 'Go to implementation' }))
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts({ desc = 'List references' }))
      vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts({ desc = 'Show signature' }))
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts({ desc = 'Hover' }))
      vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, opts({ desc = 'Rename' }))
      vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, opts({ desc = 'Format file' }))
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts({ desc = 'Code action' }))
      vim.keymap.set('n', '<leader>cp', vim.diagnostic.goto_prev, opts({ desc = 'Go to previous error' }))
      vim.keymap.set('n', '<leader>cn', vim.diagnostic.goto_next, opts({ desc = 'Go to next error' }))
      vim.keymap.set('n', '<leader>cl', vim.diagnostic.open_float, opts({ desc = 'List errors' }))
    end)

    lsp_zero.set_server_config({
      on_init = function(client)
        client.server_capabilities.semanticTokensProvider = nil
      end,
    })

    require('mason').setup({})
    require('mason-lspconfig').setup({
      ensure_installed = {
        'bashls',
        'clangd',
        'cssls',
        'dockerls',
        'docker_compose_language_service',
        'eslint',
        'gopls',
        'graphql',
        'html',
        'htmx',
        'jsonls',
        'tsserver',
        'lua_ls',
        'marksman',
        'omnisharp',
        'rust_analyzer',
        'taplo',
        'lemminx'
      },
      handlers = {
        lsp_zero.default_setup,
      }
    })
  end
}
