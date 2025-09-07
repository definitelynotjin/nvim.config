-- Disable default Vim statusline
vim.o.laststatus = 3      -- single global statusline
vim.o.showmode = false    -- hide -- INSERT -- text
vim.o.statusline = ""     -- clear default
vim.o.cursorline = true
vim.o.cursorlineopt = "number"
vim.o.wrap = true
vim.o.linebreak = true
vim.o.statuscolumn = "%s%l  "
vim.o.cmdheight = 0
vim.opt.hidden = true
vim.o.winblend = 0
vim.o.pumblend = 0
require("jin.core")
require("jin.lazy")
