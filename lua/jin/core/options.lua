vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.number = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

opt.ignorecase = true
opt.smartcase = true

opt.termguicolors = true
opt.background = "dark"

opt.backspace = "indent,eol,start"

opt.clipboard:append("unnamedplus")

opt.splitright = true
opt.splitbelow = true
opt.winblend = 0
opt.pumblend = 0
opt.laststatus = 3      -- single global statusline
opt.showmode = false    -- hide -- INSERT -- text
opt.statusline = ""     -- clear default
opt.cursorline = true
opt.cursorlineopt = "number"
opt.wrap = true
opt.linebreak = true
opt.statuscolumn = "%s%l  "
opt.cmdheight = 0
opt.hidden = true
