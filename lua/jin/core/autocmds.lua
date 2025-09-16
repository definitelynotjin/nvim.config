-- autocmds.lua
-- Prevent ts_ls and vue_ls from attaching at the same time

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LspConflictFix", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    local active = vim.lsp.get_clients()

    -- if volar attaches, stop tsserver
    if client.name == "vue_ls" then
      for _, c in ipairs(active) do
        if c.name == "ts_ls" then
          c.stop()
        end
      end
    end

    -- if tsserver attaches on vue file, stop it
    if client.name == "ts_ls" and vim.bo[args.buf].filetype == "vue" then
      client.stop()
    end
  end,
})

