return function()
  -- <Ctrl+SPACE> --> Accept the Copilot suggestion
  vim.g.copilot_no_tab_map = true
  vim.api.nvim_set_keymap('i', '<C-space>', 'copilot#Accept("<CR>")',
                          { silent = true, expr = true,
                            desc = 'Accept Copilot suggestion' })
end
