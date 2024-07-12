return function()
  vim.g.codeium_disable_bindings = 1
  -- vim.api.nvim_set_keymap('i', '<M-;>', 'codeium#CycleCompletions("1")',
  --                         { silent = true, expr = true,
  --                           desc = 'Next Codeium suggestion' })
  -- vim.api.nvim_set_keymap('i', '<M-,>', 'codeium#CycleCompletions("-1")',
  --                         { silent = true, expr = true,
  --                           desc = 'Previous Codeium suggestion' })

  -- <Ctrl+SPACE> --> Accept the Codeium suggestion
  vim.keymap.set('i', '<C-space>', function () return vim.fn['codeium#Accept']() end,
                 { silent = true, expr = true,
                   desc = 'Accept Codeium suggestion' })

  -- <Ctrl+x> --> Clear Codeium suggestion
  vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end,
                 { silent = true, expr = true,
                   desc = 'Clear Codeium suggestion' })
end
