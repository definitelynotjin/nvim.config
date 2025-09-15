vim.g.mapleader = " "

local keymap = vim.keymap

-- Go to first non-blank character of line
local function go_to_line_start_code()
	local col = vim.fn.match(vim.fn.getline("."), "\\S")
	vim.api.nvim_win_set_cursor(3, { vim.fn.line("."), col })
end

-- Go to last non-blank character of line
local function go_to_line_end_code()
	local line = vim.fn.getline(".")
	local col = #line:gsub("%s+$", "") -- trim trailing whitespace
	vim.api.nvim_win_set_cursor(3, { vim.fn.line("."), col })
end

keymap.set("n", "gh", "^", { noremap = true })
keymap.set("n", "gl", "g$", { noremap = true })
keymap.set("v", "gh", "^", { noremap = true })
keymap.set("v", "gl", "g$", { noremap = true })
-- Modes: n = normal, v = visual, x = visual block, o = operator-pending,
-- i = insert, c = command-line, t = terminal, s = select
local modes = { "n", "v", "x", "o" }
for _, m in ipairs(modes) do
	keymap.set(m, "j", "k", { noremap = true, silent = true })
	keymap.set(m, "k", "j", { noremap = true, silent = true })
end

-- Notifier History
keymap.set("n", "<leader>mm", function()
	Snacks.picker.notifications()
end, { desc = "notifications History" })

-- Save file
keymap.set("n", "<leader>cw", ":w<CR>", { noremap = true, silent = true })

-- Open nvim config
keymap.set("n", "<leader>co", function()
	vim.cmd("cd ~/.config/nvim")
end, { noremap = true, silent = true })
-- Select all
keymap.set("n", "<C-a>", "ggVG$", { noremap = true, silent = true })
-- Navigate between tabs
keymap.set("n", "<A-k>", ":tabnext<CR>", { noremap = true, silent = true })
keymap.set("n", "<A-j>", ":tabprevious<CR>", { noremap = true, silent = true })

-- Close the current tab
keymap.set("n", "<A-w>", ":tabclose<CR>", { noremap = true, silent = true })

keymap.set({ "n", "v" }, "<C-j>", "<C-u>", { remap = true, silent = true })
keymap.set({ "n", "v" }, "<C-k>", "<C-d>", { remap = true, silent = true })

-- Comment eh
keymap.set({ "n", "v" }, "<leader>qq", "gc", { remap = true })
keymap.set({ "n" }, "<leader>Q", "gcc", { remap = true })

-- Remove highlight from search with ESC
keymap.set("n", "<Esc>", function()
	vim.cmd("nohlsearch")
	return "<Esc>"
end, { noremap = true, silent = true, expr = true })
