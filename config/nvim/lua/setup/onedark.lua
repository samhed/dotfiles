return function()
  require("onedark").setup({
    style = "deep",
  })
  vim.cmd([[colorscheme onedark]])

  -- Show a very faint highlight on the line with the cursor
  vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#1c2330' })

  -- Remove background from FoldColumn
  vim.api.nvim_set_hl(0, 'FoldColumn', { link='WinSeparator' })

  -- Remove background from Lazy window
  vim.api.nvim_set_hl(0, 'LazyNormal', { link='Normal' })
  vim.api.nvim_set_hl(0, 'FloatBorder', { link='NonText' })
end
