return function()
  local alpha = require("alpha")
  local dashboard = require("alpha.themes.dashboard")
  dashboard.section.buttons.val = {
    dashboard.button("e", "  New file" , ":ene <BAR> startinsert <CR>"),
    dashboard.button("SPC f f", "󰈞  Find file"),
    dashboard.button("SPC f r", "  Recent files"),
    dashboard.button("SPC g", "󰈬  Live grep"),
    dashboard.button("CTRL + g", "  Show git overview", "<C-g>"),
    dashboard.button("q", "  Quit NVIM" , ":qa<CR>"),
  }
  alpha.setup(dashboard.config)
end
