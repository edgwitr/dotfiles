local extension_configs = {
  le16 = { encoding = "utf-16le", bom = true },
  ps1 = { encoding = "utf-8", bom = true },
  csv = { encoding = "cp932", bom = false },
}

vim.api.nvim_create_autocmd({ "BufNewFile", "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("SetFileEncoding", { clear = true }),
  pattern = "*",
  callback = function()
    local filename = vim.api.nvim_buf_get_name(0)
    local extension = filename:match("^.+%.(%w+)$")
    if extension then
      extension = extension:lower()
      local config = extension_configs[extension]
      if config then
        vim.bo.fileencoding = config.encoding
        vim.bo.bomb = config.bom or false
      else
        -- default
        vim.bo.fileencoding = "utf-8"
        vim.bo.bomb = false
      end
    end
  end,
})
