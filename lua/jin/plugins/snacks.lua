return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    indent = { enabled = true },
    rename = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    input = { enabled = true },
    scroll = { enabled = true },
    styles = {
      notification = {
        { wrap = true }
      }
    }
  }

}
