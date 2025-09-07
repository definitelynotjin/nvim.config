return {
  "folke/noice.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    cmdline = { view = "cmdline_popup" },
    messages = { view = "notify" },
    popupmenu = { enabled = true },
    lsp = { override = { "vim.lsp.util.show_line_diagnostics", "vim.lsp.util.show_cursor_diagnostics" } },
  },
  config = function(_, opts)
    require("noice").setup(opts)

    -- Keymap to open Noice message history
    vim.keymap.set("n", "<leader>mh", function()
      require("noice").cmd("history")
    end, { desc = "Show Noice message history" })
  end,
}

