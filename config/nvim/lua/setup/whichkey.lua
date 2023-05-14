return function()
  vim.o.timeout = true
  vim.o.timeoutlen = 300
  require("which-key").setup({
    window = {
      border = "single",
      margin = { 0.05, 0.06, 0.05, 0.06 },
      winblend = 15,
    },
  })
end
