return function()
  -- require("custom.breadcrumbs")
  require("lualine").setup({
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {'filetype', {'filename', path = 1}},
      lualine_x = {'searchcount'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {{'filename', path = 1}},
      lualine_x = {},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    tabline = {},
    winbar = {},
    -- winbar buggy with fugitive
    -- (see https://github.com/nvim-lualine/lualine.nvim/issues/948)
    -- winbar = {
    --   lualine_a = {},
    --   lualine_b = {},
    --   lualine_c = {},
    --   lualine_x = {'filetype'},
    --   lualine_y = {'filename'},
    --   lualine_z = {Breadcrumbs}
    -- },
    inactive_winbar = {},
  })
end
