return function()
  require("onedark").setup({
    style = "deep",
  })
  vim.cmd([[colorscheme onedark]])
end
