local api = vim.api

local fugitive = {}

function fugitive.config()
  -- Delete hidden fugitive buffers
  api.nvim_create_autocmd('BufReadPost', {
    pattern = 'fugitive://*',
    command = 'set bufhidden=delete',
  })
  -- <Tab> --> in fugitive buffers expands chunks
  -- Note that this should override "doHover" from CoC
  api.nvim_create_autocmd("User", {
    pattern = { "FugitiveObject", "FugitiveIndex" },
    callback = function()
      vim.keymap.set("n", "<TAB>", "<Plug>fugitive:=",
                     { buffer = true, desc = "Expand chunk" })
    end,
  })
  -- <,> --> in fugitive log jumps to next commit
  api.nvim_create_autocmd({ 'BufRead', 'BufEnter' }, {
    pattern = "/tmp/nvim.*",
    callback = function()
      vim.keymap.set("n", ",", "<Plug>fugitive:]]",
                     { buffer = true, desc = "Jump to next commit in log" })
    end,
  })
  -- <m> --> in fugitive log jumps to previous commit
  api.nvim_create_autocmd({ 'BufRead', 'BufEnter' }, {
    pattern = "/tmp/nvim.*",
    callback = function()
      vim.keymap.set("n", "m", "<Plug>fugitive:[[",
                     { buffer = true, desc = "Jump to previous commit in log" })
    end,
  })
end

-- Show notifications for git stuff
local function git_notify(cmd, text)
  local notify_opts = {
    title = text,
    icon = ' ',
    render = 'compact',
    hide_from_history = true,
    timeout = 1,
  }
  vim.notify(cmd, 'warn', notify_opts)
end

local function git_fugitive_toggle(buffer_name, pretty_name, cmd)
  local buf_to_toggle = -1
  for buf = 1, vim.fn.bufnr('$') do
    -- if buffer name includes what we're looking for
    if api.nvim_buf_is_valid(buf) and
       string.find(api.nvim_buf_get_name(buf), buffer_name) then
      buf_to_toggle = buf
    end
  end
  if buf_to_toggle > 0 then
    if vim.fn.bufwinnr(buf_to_toggle) > 0 then
      -- it is an active window, close and we're done
      vim.cmd("bw! " .. buf_to_toggle)
      git_notify(cmd, "Closed " .. pretty_name)
      return
    else
      -- the window wasn't active, close and then open a new one
      vim.cmd("bw! " .. buf_to_toggle)
    end
  end
  -- open a new one
  vim.cmd(cmd)
  git_notify(cmd, "Opened " .. pretty_name)
end

local function git_blame()
  git_fugitive_toggle('.fugitiveblame', 'git blame', 'G blame')
end
local function git_overview()
  git_fugitive_toggle('fugitive:', 'git overview', ':vert Git')
end
local function git_log()
  git_fugitive_toggle('tmp/nvim.', 'git log', 'vert Git log --decorate')
end
local function git_log_cur()
  git_fugitive_toggle('tmp/nvim.', 'git log current file',
                      'vert Git log --decorate %')
end

-- <p> --> view previous (parent) commit
-- <Ctrl+o> --> go back
fugitive.keys = {
  -- <Ctrl+b> --> Toggle git blame on current file
  -- <Ctrl+g> --> Toggle git overview
  -- <Ctrl+l> --> Toggle git log
  -- <Ctrl+k> --> Toggle git log for current file
  { '<C-b>', git_blame,    desc = 'Toggle git blame on current file' },
  { '<C-g>', git_overview, desc = 'Toggle git overview' },
  { '<C-l>', git_log,      desc = 'Toggle git log' },
  { '<C-k>', git_log_cur,  desc = 'Toggle git log for current file' }
}

return fugitive
