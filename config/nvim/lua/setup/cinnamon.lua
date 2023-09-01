return function()
  require("cinnamon").setup({
    default_delay = 3,
    scroll_limit = 500,
    max_length = 70,
    extra_keymaps = true,
    hide_cursor = true,
  })
end
