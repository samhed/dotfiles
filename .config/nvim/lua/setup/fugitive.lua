local api = vim.api

return function ()
  -- Delete hidden fugitive buffers
  api.nvim_create_autocmd('BufReadPost', {
    pattern = 'fugitive://*',
    command = 'set bufhidden=delete',
  })

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

  -- <p> --> view previous (parent) commit
  -- <Ctrl+o> --> go back
  function GitFugitiveToggle(buffer_name, pretty_name, cmd)
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

  -- <Ctrl+b> --> Toggle git blame on current file
  vim.keymap.set('n', '<C-b>', '', {
    callback = function()
      GitFugitiveToggle('.fugitiveblame', 'git blame', 'G blame')
    end,
    silent = true, desc = 'Toggle git blame on current file',
  })
  -- <Ctrl+g> --> Toggle git overview
  vim.keymap.set('n', '<C-g>', '', {
    callback = function()
      GitFugitiveToggle('fugitive:', 'git overview', ':vert Git')
    end,
    silent = true, desc = 'Toggle git overview',
  })
  -- <Ctrl+l> --> Toggle git log
  vim.keymap.set('n', '<C-l>', '', {
    callback = function()
      GitFugitiveToggle('tmp/nvim.', 'git log', 'vert Git log --decorate')
    end,
    silent = true, desc = 'Toggle git log',
  })
  -- <Ctrl+k> --> Toggle git log for current file
  vim.keymap.set('n', '<C-k>', '', {
    callback = function()
      GitFugitiveToggle('tmp/nvim.', 'git log current file',
                        'vert Git log --decorate %')
    end,
    silent = true, desc = 'Toggle git log',
  })
end
