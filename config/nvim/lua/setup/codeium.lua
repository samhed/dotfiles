return function()
  vim.g.codeium_disable_bindings = 1
  vim.g.codeium_filetypes = { gitcommit = true }

  -- <Ctrl+SPACE> --> Accept the Codeium suggestion
  vim.keymap.set('i', '<C-space>', function () return vim.fn['codeium#Accept']() end,
                 { silent = true, expr = true,
                   desc = 'Accept Codeium suggestion' })

  -- <Ctrl+Down> and <Ctrl+Up> --> Cycle through Codeium suggestions
  vim.keymap.set('i', '<c-Down>', function() return vim.fn['codeium#CycleCompletions'](1) end,
                 { silent = true, expr = true,
                   desc = 'Next Codeium suggestion' })
  vim.keymap.set('i', '<c-Up>', function() return vim.fn['codeium#CycleCompletions'](-1) end,
                 { silent = true, expr = true,
                   desc = 'Previous Codeium suggestion' })

  -- <Ctrl+x> --> Clear Codeium suggestion
  vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end,
                 { silent = true, expr = true,
                   desc = 'Clear Codeium suggestion' })
end
