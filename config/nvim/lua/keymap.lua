local keyset = vim.keymap.set

------------------------------------------
-- General keymaps
------------------------------------------

-- <Ctrl+c> --> copy selected text with
keyset('v', '<C-c>', '"+y', { desc = 'Copy selected text'} )

-- <leader>+<c> --> clear search highlight with
keyset('n', '<leader>c', ':nohl<CR>',
       { silent = true, desc = 'Clear search highlight' })

-- <Ctrl+s> --> save file (works in INSERT as well)
local save_opts = { silent = true, desc = 'Save'}
keyset('n', '<C-s>', ':update<CR>', save_opts)
keyset('v', '<C-s>', '<C-c>:update<CR>', save_opts)
keyset('i', '<C-s>', '<Esc>:update<CR>', save_opts)
-- <leader>+<w> --> save file
keyset('n', '<leader>w', ':update<CR>', save_opts)
keyset('v', '<leader>w', '<C-c>:update<CR>', save_opts)

-- <Alt+Up> or <Alt+Down> --> move lines up or down
local optsDown = { desc = 'Move line down' }
local optsUp = { desc = 'Move line up' }
keyset('n', '<A-j>', ':m .+1<CR>==', optsDown)
keyset('n', '<A-Down>', ':m .+1<CR>==', optsDown)
keyset('n', '<A-k>', ':m .-2<CR>==', optsUp)
keyset('n', '<A-Up>', ':m .-2<CR>==', optsUp)
keyset('i', '<A-j>', '<Esc>:m .+2<CR>==gi', optsDown)
keyset('i', '<A-Down>', '<Esc>:m .+1<CR>==gi', optsDown)
keyset('i', '<A-k>', '<Esc>:m .-2<CR>==gi', optsUp)
keyset('i', '<A-Up>', '<Esc>:m .-2<CR>==gi', optsUp)
keyset('v', '<A-j>', ':m .+1<CR>gv=gv', optsDown)
keyset('v', '<A-Down>', ':m .+1<CR>gv=gv', optsDown)
keyset('v', '<A-k>', ':m .-2<CR>gv=gv', optsUp)
keyset('v', '<A-Up>', ':m .-2<CR>gv=gv', optsUp)

------------------------------------------
-- Lazy
------------------------------------------

-- <Esc> --> Close Lazy panel
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lazy', callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', '<Esc>', '<cmd>close<CR>',
                   { buffer = event.buf, silent = true })
  end,
})
