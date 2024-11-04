vim.opt.mouse = ''
vim.opt.nu = true
vim.opt.cursorline = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.updatetime = 50

vim.opt.fillchars = { eob = ' ' }

vim.g.rust_recommended_style = false

vim.filetype.add({
  extensions = {
    vert = "glsl",
    tesc = "glsl",
    tese = "glsl",
    geom = "glsl",
    frag = "glsl"
  }
})
