return function()
  -- <Ctrl+SPACE> --> Accept the Codeium suggestion
  vim.g.codeium_disable_bindings = 1
  -- vim.api.nvim_set_keymap('i', '<C-space>', 'codeium#Accept("<CR>")',
  vim.api.nvim_set_keymap('i', '<C-space>', 'codeium#Accept()',
                          { silent = true, expr = true,
                            desc = 'Accept Codeium suggestion' })
  -- vim.api.nvim_set_keymap('i', '<M-;>', 'codeium#CycleCompletions("1")',
  --                         { silent = true, expr = true,
  --                           desc = 'Next Codeium suggestion' })
  -- vim.api.nvim_set_keymap('i', '<M-,>', 'codeium#CycleCompletions("-1")',
  --                         { silent = true, expr = true,
  --                           desc = 'Previous Codeium suggestion' })
  vim.api.nvim_set_keymap('i', '<C-x>', 'codeium#Clear()',
                          { silent = true, expr = true,
                            desc = 'Clear Codeium suggestion' })
end
