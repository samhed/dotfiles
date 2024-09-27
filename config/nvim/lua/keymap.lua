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
-- Sudo
------------------------------------------

-- Show notifications for sudo stuff
local function sudo_notify(cmd, text)
  local notify_opts = {
    title = text,
    icon = ' ',
    render = 'compact',
    hide_from_history = true,
    timeout = 1,
  }
  vim.notify(cmd, 'warn', notify_opts)
end

local function sudo_exec(cmd, print_output)
  vim.fn.inputsave()
  local password = vim.fn.inputsecret("Password: ")
  vim.fn.inputrestore()
  if not password or #password == 0 then
    sudo_notify("Invalid password, sudo aborted")
    return false
  end
  local out = vim.fn.system(string.format("sudo -p '' -S %s", cmd), password)
  if vim.v.shell_error ~= 0 then
    print("\r\n")
    sudo_notify(out)
    return false
  end
  if print_output then print("\r\n", out) end
  return true
end

local function sudo_write(tmpfile, filepath)
  if not tmpfile then tmpfile = vim.fn.tempname() end
  if not filepath then filepath = vim.fn.expand("%") end
  if not filepath or #filepath == 0 then
    sudo_notify("E32: No file name")
    return
  end
  -- `bs=1048576` is equivalent to `bs=1M` for GNU dd or `bs=1m` for BSD dd
  -- Both `bs=1M` and `bs=1m` are non-POSIX
  local cmd = string.format("dd if=%s of=%s bs=1048576",
    vim.fn.shellescape(tmpfile),
    vim.fn.shellescape(filepath))
  -- no need to check error as this fails the entire function
  vim.api.nvim_exec2(string.format("write! %s", tmpfile), { output = true })
  if sudo_exec(cmd) then
    -- refreshes the buffer and prints the "written" message
    vim.cmd.checktime()
    -- exit command mode
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(
      "<Esc>", true, false, true), "n", true)
  end
  vim.fn.delete(tmpfile)
end

local sudoOpts = { silent = true, desc = 'Write with sudo' }
keyset('n', 'w!!', sudo_write, sudoOpts)

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
