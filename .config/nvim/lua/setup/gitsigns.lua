return function()
  require("gitsigns").setup({
    signs = {
      add =    { text = "│" },
      change = { text = "│" },
      delete = { text = "│" },
    }
  })
end
