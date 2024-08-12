local api = vim.api

------------------------------------------
-- General auto commands
------------------------------------------

table.unpack = table.unpack or unpack -- 5.1 compatibility

-- Return to last edit positon when opening files
api.nvim_create_autocmd({'BufRead', 'BufReadPost'}, {
  callback = function()
    local row, column = table.unpack(api.nvim_buf_get_mark(0, '"'))
    local buf_line_count = api.nvim_buf_line_count(0)

    if row >= 1 and row <= buf_line_count then
      api.nvim_win_set_cursor(0, {row, column})
    end
  end,
})

-- Always start on the first line of git commit message
api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit', 'fugitive' },
  command = "call setpos('.', [0, 1, 1, 0])",
})

-- Fix memory leak issue with calls to 'match'
api.nvim_create_autocmd('BufWinLeave', {
  pattern = '*', command = 'call clearmatches()',
})

-- Wrap location list and quickfix windows
api.nvim_create_autocmd('FileType', {
  pattern = 'qf', callback = 'setlocal wrap',
})

-- Only show cursorline in current buffer
local cursorGrp = api.nvim_create_augroup('CursorLine', { clear = true })
api.nvim_create_autocmd({ 'VimEnter', 'WinEnter', 'BufWinEnter' }, {
  pattern = '*', command = 'setlocal cursorline', group = cursorGrp,
})
api.nvim_create_autocmd({ 'WinLeave' }, {
  pattern = '*', command = 'setlocal nocursorline', group = cursorGrp,
})
