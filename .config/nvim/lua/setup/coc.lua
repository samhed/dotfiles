local api = vim.api

return function ()
  vim.g.coc_disable_transparent_cursor = '1' -- prevent transparent cursor
  vim.b.coc_nav = '1'

  local keyset = vim.keymap.set

  -- Autocomplete
  function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
  end

  -- <Ctrl+p> --> move back in the jump list, we need to remap since
  --              TAB is the same as Ctrl-i
  keyset("n", "<C-p>", "<C-i>", { desc = 'Back in jump list' })

  local tab_opts = { silent = true, noremap = true, expr = true,
                     replace_keycodes = false }

  -- <Tab> --> adds current completion (in Insert-mode)
  tab_opts["desc"] = "Add next completion"
  keyset("i", "<TAB>", [[coc#pum#visible() ? coc#pum#next(1) : ]] ..
         [[v:lua.check_back_space() ? "\<TAB>" : coc#refresh()]], tab_opts)

  -- <Shift+Tab> --> cycle back to previous completion suggest
  tab_opts["desc"] = "Add previous completion"
  keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]],
         tab_opts)

  -- <Tab> --> in Normal-mode, show hover
  -- <Tab> --> in fugitive buffers expands chunks
  keyset("n", "<TAB>", ":call CocActionAsync('doHover')<CR>",
         { silent = true, desc = 'Hover info' })
  api.nvim_create_autocmd("User", {
    pattern = { "FugitiveObject", "FugitiveIndex" },
    callback = function()
      keyset("n", "<TAB>", "<Plug>fugitive:=",
             { buffer = true, desc = "Expand chunk" })
    end,
  })

  -- <Ctrl+SPACE> --> trigger completion.
  keyset("i", "<C-space>", "coc#refresh()",
         { silent = true, expr = true, desc = 'Trigger completion' })

  -- <ENTER> --> accept selected completion item or notify coc.nvim to format
  keyset("i", "<CR>", [[coc#pum#visible() ? coc#pum#confirm() :]] ..
         [["\<C-g>u\<CR><c-r>=coc#on_enter()\<CR>"]],
         { silent = true, noremap = true, expr = true,
           replace_keycodes = false, desc = 'Select current completion' })

  -- <Ctrl+h> --> toggle inlay hints
  keyset("n", "<C-h>", ":CocCommand document.toggleInlayHint<CR>",
         { silent = true, desc = 'Toggle inlay hints' })

  -- <F7> and <F8> --> navigate diagnostics
  -- Use `:CocDiagnostics` to get all diagnostics of current buffer in
  -- location list.
  keyset("n", "<F7>", "<Plug>(coc-diagnostic-prev)",
         { silent = true, desc = 'Go to previous diagnostic'})
  keyset("n", "<F8>", "<Plug>(coc-diagnostic-next)",
         { silent = true, desc = 'Go to next diagnostic'})

  -- <F9> --> Toggle diagnostics
  function _G.toggleSigns()
    vim.fn.CocAction('diagnosticToggle')
    if vim.o.signcolumn == "yes" then
      vim.o.signcolumn = "no"
    else
      vim.o.signcolumn = "yes"
    end
  end
  keyset("n", "<F9>", '<CMD>lua _G.toggleSigns()<CR>',
         { desc = 'Toggle sign column' })

  -- <leader>+<d> --> show all diagnostics
  keyset("n", "<leader>d", ":<C-u>CocList diagnostics<cr>",
         { silent = true, nowait = true, desc = 'Show all diagnostics' })

  -- <leader>+<o> --> Toggle file outline
  function _G.toggleOutline()
    local winid = api.nvim_eval('coc#window#find("cocViewId", "OUTLINE")')
    if winid == -1 then
      vim.fn.CocActionAsync('showOutline', 1)
    else
      vim.fn.CocActionAsync('hideOutline', 1)
    end
  end
  keyset("n", "<leader>o", "<CMD>lua _G.toggleOutline()<CR>",
         { silent = true, desc = 'Show file outline' })

  -- <g>+[d/y/i/r] --> GoTo code navigation
  keyset("n", "gd", "<Plug>(coc-definition)",
         { silent = true, desc = 'GoTo definition' })
  keyset("n", "gy", "<Plug>(coc-type-definition)",
         { silent = true, desc = 'GoTo type definition' })
  keyset("n", "gi", "<Plug>(coc-implementation)",
         { silent = true, desc = 'GoTo implementation' })
  keyset("n", "gr", "<Plug>(coc-references)",
         { silent = true, desc = 'List references' })

  -- <leader>+<a> --> Multiple cursors
  keyset("n", "<leader>a", "<Plug>(coc-cursors-position)",
         { silent = true, desc = 'Start multi-cursor at position' })
  keyset("n", "<leader>aw", "<Plug>(coc-cursors-word)",
         { silent = true, desc = 'Start multi-cursor at word' })
  keyset("x", "<leader>ar", "<Plug>(coc-cursors-range)",
         { silent = true, desc = 'Start multi-cursor from selected range' })
  keyset("n", "<leader>x", "<Plug>(coc-cursors-operator)",
         { silent = true, desc = 'Start multi-cursor from next move' })

  -- <Shift+k> --> show documentation in preview window
  function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
      api.nvim_command('h ' .. cw)
    elseif api.nvim_eval('coc#rpc#ready()') then
      vim.fn.CocActionAsync('doHover')
    else
      api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
  end
  keyset("n", "K", '<CMD>lua _G.show_docs()<CR>',
         { silent = true, desc = 'Show documentation' })

  -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
  api.nvim_create_augroup("CocGroup", {})
  api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
  })

  -- Search and replace under cursor, use CoC's rename when available
  function _G.basic_rename()
    local keys = api.nvim_replace_termcodes(
      ':%s/<C-r><C-w>//gc<left><left><left>', false, false, true)
    api.nvim_feedkeys(keys, "n", {})
  end
  function _G.rename()
    if vim.fn.CocHasProvider('rename') then
      vim.fn.CocActionAsync('rename')
    else
      _G.basic_rename()
    end
  end

  -- <leader>+<r> --> basic renaming under cursor
  keyset("n", "<leader>r", "<CMD>lua _G.basic_rename()<CR>",
         { silent = true, desc = 'Basic rename under cursor' })

  -- <F6> --> symbol renaming if available
  keyset("n", "<F6>", "<CMD>lua _G.rename()<CR>",
         { silent = true, desc = 'Rename symbol' })

  -- Setup formatexpr specified filetype(s)
  api.nvim_create_autocmd("FileType", {
    group = "CocGroup",
    pattern = "typescript,json",
    command = "setl formatexpr=CocAction('formatSelected')",
    desc = "Setup formatexpr specified filetype(s)."
  })

  -- Update signature help on jump placeholder
  api.nvim_create_autocmd("User", {
    group = "CocGroup",
    pattern = "CocJumpPlaceholder",
    command = "call CocActionAsync('showSignatureHelp')",
    desc = "Update signature help on jump placeholder"
  })

  -- Add `:Format` command to format current buffer
  api.nvim_create_user_command("Format", "call CocAction('format')", {})

  -- " Add `:Fold` command to fold current buffer
  api.nvim_create_user_command("Fold",
                               "call CocAction('fold', <f-args>)",
                               { nargs = '?' })

  -- Add `:OR` command for organize imports of the current buffer
  api.nvim_create_user_command("OR",
                               "call CocActionAsync('runCommand', " ..
                               "'editor.action.organizeImport')", {})

  ------ notify functions ------

  local coc_status_record = {}

  local function coc_status_notify(msg, level)
    local notify_opts = {
      title = "LSP Status", timeout = 500, hide_from_history = true,
      on_close = Reset_coc_status_record,
    }
    -- if coc_status_record is not {} then add it to notify_opts to
    -- key called "replace"
    if coc_status_record ~= {} then
      notify_opts["replace"] = coc_status_record
    end
    coc_status_record = vim.notify(msg, level, notify_opts)
  end

  function Reset_coc_status_record(window)
    coc_status_record = {}
  end

  local coc_diag_record = {}

  local function coc_diag_notify(msg, level)
    local notify_opts = {
      title = "LSP Diagnostics", timeout = 500,
      on_close = Reset_coc_diag_record,
    }
    -- if coc_diag_record is not {} then add it to notify_opts to
    -- key called "replace"
    if coc_diag_record ~= {} then
      notify_opts["replace"] = coc_diag_record
    end
    coc_diag_record = vim.notify(msg, level, notify_opts)
  end

  function Reset_coc_diag_record(window)
    coc_diag_record = {}
  end

  function CoC_notify(msg, level)
    local notify_opts = { title = "LSP Message", timeout = 500 }
    vim.notify(msg, level, notify_opts)
  end

  function DiagnosticNotify()
    local info = vim.b.coc_diagnostic_info or {}
    if info == {} then return '' end
    local msgs = {}
    local level = 'info'
    if info['warning'] > 0 then
      level = 'warn'
    end
    if info['error'] > 0 then
      level = 'error'
    end

    if info['error'] > 0 then
      table.insert(msgs, ' Errors: ' .. info['error'])
    end
    if info['warning'] > 0 then
      table.insert(msgs, ' Warnings: ' .. info['warning'])
    end
    if info['information'] > 0 then
      table.insert(msgs, ' Infos: ' .. info['information'])
    end
    if info['hint'] > 0 then
      table.insert(msgs, ' Hints: ' .. info['hint'])
    end
    local msg = table.concat(msgs, " ")
    if msg == "" then msg = ' All OK' end
    coc_diag_notify(msg, level)
  end

  function StatusNotify()
    local status = vim.g.coc_status or ''
    local level = 'info'
    if status == '' then return '' end
    coc_status_notify(status, level)
  end

  function InitCoc()
    vim.cmd('runtime! autoload/coc/ui.vim')
    vim.notify('Initialized coc.nvim for LSP support', 'info',
               { title = 'LSP Status' })
  end

  api.nvim_create_autocmd("User", {
    pattern = "CocNvimInit",
    callback = function() InitCoc() end,
  })
  api.nvim_create_autocmd("User", {
    pattern = "CocDiagnosticChange",
    callback = function() DiagnosticNotify() end,
  })
  api.nvim_create_autocmd("User", {
    pattern = "CocStatusChange",
    callback = function() StatusNotify() end,
  })
end
