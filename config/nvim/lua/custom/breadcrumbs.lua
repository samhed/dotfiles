local api = vim.api

---- breadcrumbs in lualine ------

-- onedark 'deep' bg1 & orange
api.nvim_set_hl(0, 'bc1_s', { fg = '#abb2bf', bg = '#21283b' })
api.nvim_set_hl(0, 'bc1_m', { fg = '#dd9046', bg = '#21283b' })
api.nvim_set_hl(0, 'bc1_e', { fg = '#1a212e', bg = '#21283b' })

-- onedark 'deep' bg0 & blue
api.nvim_set_hl(0, 'bc2_s', { fg = '#abb2bf', bg = '#1a212e' })
api.nvim_set_hl(0, 'bc2_m', { fg = '#61afef', bg = '#1a212e' })
api.nvim_set_hl(0, 'bc2_e', { fg = '#1a212e', bg = '#1a212e' })

-- onedark 'deep' bg0 & cyan
api.nvim_set_hl(0, 'bc3_s', { fg = '#abb2bf', bg = '#1a212e' })
api.nvim_set_hl(0, 'bc3_m', { fg = '#56b6c2', bg = '#1a212e' })
api.nvim_set_hl(0, 'bc3_e', { fg = '#1a212e', bg = '#1a212e' })

local symbols = {
  { 'bc1_s', '  ', 'bc1_m', 'bc1_e', '' },
  { 'bc2_s', ' 󰊕 ', 'bc2_m', 'bc2_e', ' %##%#bc2_e#' },
  { 'bc3_s', '  ', 'bc3_m', 'bc3_e', '%##%#bc3_e#' },
}

-- show breadcrumbs if available
function Breadcrumbs()
  local items = vim.b.coc_nav
  local t = {''}
  if items then
    for k,v in ipairs(items) do
      setmetatable(v, { __index = function(table, key)
        return ''
      end})
      t[#t+1] = '%#' .. (symbols[k][1] or 'Normal') .. '#' ..
                (symbols[k][2] or '') ..
                '%#' .. (symbols[k][3] or 'Normal') .. '#' ..
                (v.name or '')
      if next(items,k) ~= nil then
        t[#t+1] = '%#' .. (symbols[k][4] or 'Normal') .. '#' ..
                  (symbols[k][5] or '')
      end
    end
  end
  return table.concat(t)
end
