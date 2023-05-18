return function()
  local status_ok, alpha = pcall(require, "alpha")
  if not status_ok then
    return
  end

  -- Needs to be italic to appear as intended
  local logoLines  = {
    [[                                                                   ]],
    [[      ████ ██████           █████      ██                    ]],
    [[     ███████████             █████                            ]],
    [[     █████████ ███████████████████ ███   ███████████  ]],
    [[    █████████  ███    █████████████ █████ ██████████████  ]],
    [[   █████████ ██████████ █████████ █████ █████ ████ █████  ]],
    [[ ███████████ ███    ███ █████████ █████ █████ ████ █████ ]],
    [[██████  █████████████████████ ████ █████ █████ ████ ██████]],
  }
  -- Create some nice Highlight colors to use for the logo
  colorLetters = { 'A', 'B', 'C', 'D', 'E' }
  for i,_ in ipairs(logoLines) do
    -- Purple/Blue
    vim.api.nvim_set_hl(0, 'logo'..colorLetters[1]..i, {
      italic = true, fg = string.format('#%02x%02xff', (255 - i * 20), i * 20)
    })
    -- Green/Blue
    vim.api.nvim_set_hl(0, 'logo'..colorLetters[2]..i, {
      italic = true, fg = string.format('#30%02x%02x', (255 - i * 22), i * 26)
    })
    -- LightBlue/Yellow
    vim.api.nvim_set_hl(0, 'logo'..colorLetters[3]..i, {
      italic = true, fg = string.format('#%02xaf%02x', i * 31, (255 - i * 25))
    })
    -- Pink/Yellow
    vim.api.nvim_set_hl(0, 'logo'..colorLetters[4]..i, {
      italic = true, fg = string.format('#ff%02x%02x', i * 25, (255 - i * 25))
    })
    -- Red/Pink
    vim.api.nvim_set_hl(0, 'logo'..colorLetters[5]..i, {
      italic = true, fg = string.format('#ff%02x%02x', i * 5, i * 26)
    })
  end
  math.randomseed(os.time())
  randomColor = colorLetters[math.random(#colorLetters)]

  local logo = {}
  for i, line in ipairs(logoLines) do
    table.insert(logo, { hi = "logo"..randomColor..i, line = line})
  end

  -- Map over the headers, setting a different color for each line.
  -- This is done by setting the Highligh to logoN, where N is the row index.
  local function coloredHeader()
    local lines = {}
    for i, lineConfig in pairs(logo) do
      local hi = lineConfig.hi
      local line_chars = lineConfig.line
      local line = {
        type = "text",
        val = line_chars,
        opts = {
          hl = hi,
          shrink_margin = false,
          position = "center",
        },
      }
      table.insert(lines, line)
    end

    local output = {
      type = "group",
      val = lines,
      opts = { position = "center", },
    }

    return output
  end

  local theme = require("alpha.themes.theta")
  local config = theme.config
  local dashboard = require("alpha.themes.dashboard")
  local buttons = {
    type = "group",
    val = {
      { type = "text", val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
      { type = "padding", val = 1 },
      dashboard.button("e", "  New file" , ":ene <BAR> startinsert <CR>"),
      dashboard.button("SPC f f", "󰈞  Find file"),
      dashboard.button("SPC f r", "  Recent files"),
      dashboard.button("SPC g", "󰈬  Live grep"),
      dashboard.button("CTRL + g", "  Show git overview", "<C-g>"),
      dashboard.button("Lazy", "  Plugin manager", ":Lazy<CR>"),
      dashboard.button("q", "󰅚  Quit NVIM" , ":qa<CR>"),
    },
    position = "center",
  }

  config.layout[2] = coloredHeader()
    print(config.layout[2])
  config.layout[6] = buttons
  alpha.setup(config)
end
