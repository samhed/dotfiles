return function()
  require("onedark").setup({
    style = "deep",
  })
  vim.cmd([[colorscheme onedark]])

  -- Show a very faint highlight on the line with the cursor
  vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#1c2330' })
end
