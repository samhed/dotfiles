return function()
  require('ufo').setup()
  -- <z>+<Shift+[r/m]> --> open/close all folds
  vim.keymap.set('n', 'zR', require('ufo').openAllFolds,
                 { desc = 'open all folds' })
  vim.keymap.set('n', 'zM', require('ufo').closeAllFolds,
                 { desc = 'close all folds' })
end
