return function()
  require("cinnamon").setup({
    keymaps = {
      extra = true,
    },
    options = {
      mode = "window",
      delay = 3,
      max_delta = {
        line = 70,
        time = 500,
      }
    },
  })
end
