return function()
  require("custom.breadcrumbs")
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
    winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {
        { 'filetype', icon_only = true, separator = ''},
        { 'filename', symbols = { unnamed = ''}},
      },
      lualine_z = {Breadcrumbs},
    },
    inactive_winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {
        { 'filetype', icon_only = true, separator = '', colored = false },
        { 'filename', symbols = { unnamed = ''}},
      },
    },
  })
end
