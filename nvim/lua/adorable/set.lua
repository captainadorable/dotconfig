vim.opt.nu = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.updatetime = 50


-- i dont know why this is here
CopilotToggle = false
vim.api.nvim_create_user_command("ToggleCopilot", function()
  require("copilot.suggestion").toggle_auto_trigger()
  CopilotToggle = not CopilotToggle
  print("Copilot auto trigger is now " .. (CopilotToggle and "enabled" or "disabled"))
end, {})
