return function()
  require("toggleterm").setup({
    open_mapping = [[<c-t>]], -- toggle terminal with Ctrl-t
    insert_mappings = true, -- open mapping applies in insert mode
    terminal_mappings = true, -- open mapping applies in the opened terminals
    direction = 'float',
    float_opts = {
      border = 'curved',
      width = function()
        return math.floor(vim.o.columns * 0.7)
      end,
      height = 50,
      winblend = 10,
    },
  })
end
