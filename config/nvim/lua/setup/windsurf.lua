return function()
  vim.g.codeium_disable_bindings = 1
  vim.g.codeium_filetypes = { gitcommit = true }

  -- Windsurf was formerly known as Codeium

  -- <Ctrl+SPACE> --> Accept the Windsurf suggestion
  vim.keymap.set('i', '<C-space>', function () return vim.fn['codeium#Accept']() end,
                 { silent = true, expr = true,
                   desc = 'Accept Windsurf suggestion' })

  -- <Ctrl+Down> and <Ctrl+Up> --> Cycle through Windsurf suggestions
  vim.keymap.set('i', '<c-Down>', function() return vim.fn['codeium#CycleCompletions'](1) end,
                 { silent = true, expr = true,
                   desc = 'Next Windsurf suggestion' })
  vim.keymap.set('i', '<c-Up>', function() return vim.fn['codeium#CycleCompletions'](-1) end,
                 { silent = true, expr = true,
                   desc = 'Previous Windsurf suggestion' })

  -- <Ctrl+x> --> Clear Windsurf suggestion
  vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end,
                 { silent = true, expr = true,
                   desc = 'Clear Windsurf suggestion' })
end
