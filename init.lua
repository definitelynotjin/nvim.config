-- Disable default Vim statusline
require("jin.core")
require("jin.lazy")
vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.expand("~/.local/share/nvim/mason/bin")
