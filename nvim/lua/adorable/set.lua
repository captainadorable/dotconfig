vim.opt.nu = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.updatetime = 100

vim.opt.signcolumn = "yes"

-- godot
local projectfile = vim.fn.getcwd() .. '/project.godot'
if projectfile then
  vim.fn.serverstart './godothost'
end
