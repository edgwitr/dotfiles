local extension_encodings = {
  txt = "utf-8",
  ps1 = "utf-8-bom",
}

local group = vim.api.nvim_create_augroup("SetFileEncoding", { clear = true })

vim.api.nvim_create_autocmd({ "BufNewFile" }, {
  group = group,
  pattern = "*",
  callback = function()
      local filename = vim.api.nvim_buf_get_name(0)
      local extension = filename:match("^.+%.(%w+)$")
      if extension then
          extension = extension:lower()
          local encoding = extension_encodings[extension]
          if encoding then
              vim.bo.fileencoding = encoding
          end
      end
  end,
})
