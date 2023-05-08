local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.opt.rtp:append(vim.fn.stdpath("config") .. "/after")

require("settings")
require("autocmd")
-- require("lazy").setup("plugins")

local api = vim.api

------------------------------------------
-- General keymaps
------------------------------------------

-- <Ctrl+c> --> copy selected text with
vim.keymap.set('v', '<C-c>', '"+y', { desc = 'Copy selected text'} )

-- <leader>+<c> --> clear search highlight with
vim.keymap.set('n', '<leader>c', ':nohl<CR>', { silent = true, desc = 'Clear search highlight' })

-- <Ctrl+s> --> save file (works in INSERT as well)
local opts = { silent = true, desc = 'Save'}
vim.keymap.set('n', '<C-s>', ':update<CR>', opts)
vim.keymap.set('v', '<C-s>', '<C-c>:update<CR>', opts)
vim.keymap.set('i', '<C-s>', '<Esc>:update<CR>', opts)
-- <leader>+<w> --> save file
vim.keymap.set('n', '<leader>w', ':update<CR>', opts)
vim.keymap.set('v', '<leader>w', '<C-c>:update<CR>', opts)

-- <Alt+Up> or <Alt+Down> --> move lines up or down
local optsDown = { desc = 'Move line down' }
local optsUp = { desc = 'Move line up' }
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', optsDown)
vim.keymap.set('n', '<A-Down>', ':m .+1<CR>==', optsDown)
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', optsUp)
vim.keymap.set('n', '<A-Up>', ':m .-2<CR>==', optsUp)
vim.keymap.set('i', '<A-j>', '<Esc>:m .+2<CR>==gi', optsDown)
vim.keymap.set('i', '<A-Down>', '<Esc>:m .+1<CR>==gi', optsDown)
vim.keymap.set('i', '<A-k>', '<Esc>:m .-2<CR>==gi', optsUp)
vim.keymap.set('i', '<A-Up>', '<Esc>:m .-2<CR>==gi', optsUp)
vim.keymap.set('v', '<A-j>', ':m .+1<CR>gv=gv', optsDown)
vim.keymap.set('v', '<A-Down>', ':m .+1<CR>gv=gv', optsDown)
vim.keymap.set('v', '<A-k>', ':m .-2<CR>gv=gv', optsUp)
vim.keymap.set('v', '<A-Up>', ':m .-2<CR>gv=gv', optsUp)

------------------------------------------
-- Plugins
------------------------------------------

require("lazy").setup({

  -- Auto close parens & brackets etc.
  { "windwp/nvim-autopairs",
    opts = { check_ts = true },
  },

  -- Javascript syntax
  { "jelera/vim-javascript-syntax",
    ft = "javascript",
  },

  -- symbols outline shows the current function etc.
  { "simrat39/symbols-outline.nvim",
    config = true,
  },

  -- Makes word motions work for CamelCase and snake_case
  { "chaoren/vim-wordmotion" },

  -- fugitive is a git plugin
  { "tpope/vim-fugitive",
    config = function ()
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

      -- Use <Ctrl+o> to cycle back to the fugitive git log after viewing a commit
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
    end,
  },

  -- rhubarb for connecting to github
  { "tpope/vim-rhubarb" },

  -- comment out stuff with g-c-c
  { "numToStr/Comment.nvim",
    config = true,
  },

  -- Auto detect indentation
  { "tpope/vim-sleuth" },

  -- UNIX shell commands from vim
  { "tpope/vim-eunuch" },

  -- Colorify color-hex codes
  { "rrethy/vim-hexokinase",
    build = "make hexokinase",
  },

  -- Faster startup and file association
  { "nathom/filetype.nvim",
    config = true,
  },

  -- CoC for LSP support & Tab completion
  { "neoclide/coc.nvim",
    branch = "release",
    build = {":CocInstall coc-json coc-css coc-tsserver coc-eslint coc-html " ..
             "coc-html-css-support coc-pyright coc-clangd coc-lua coc-ltex " ..
             "coc-snippets coc-nav", ":CocUpdate"},
    -- Coc will use pycodestyle as a py-linter, exceptions or other config
    -- for pycodestyle is found here: ~/.config/pycodestyle
    config = function ()
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
    end,
  },

  -- gitsigns shows git diffs in the sign column
  { "lewis6991/gitsigns.nvim",
    config = true,
  },

  -- Merge conflicts
  -- c+o = choose ours, c+t = theirs, ]+x = previous conflict, [+x = next
  { "akinsho/git-conflict.nvim",
    opts = { disable_diagnostics = true },
  },

  -- Better folding
  { "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter",
    },
    config = function()
      require('ufo').setup()
    end,
  },

  -- Statusline
  { "nvim-lualine/lualine.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filetype', {'filename', path = 1}},
        lualine_x = {'searchcount'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {{'filename', path = 1}},
        lualine_x = {},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
      tabline = {},
      winbar = {},
      -- winbar buggy with fugitive
      -- (see https://github.com/nvim-lualine/lualine.nvim/issues/948)
      -- winbar = {
      --   lualine_a = {},
      --   lualine_b = {},
      --   lualine_c = {},
      --   lualine_x = {'filetype'},
      --   lualine_y = {'filename'},
      --   lualine_z = {breadcrumbs}
      -- },
      inactive_winbar = {},
    },
  },

  -- Nice colorscheme (no proper highligts for Python)
  { "navarasu/onedark.nvim",
    config = function()
      require("onedark").setup({
        style = "deep",
      })
      vim.cmd([[colorscheme onedark]])
    end,
  },

  -- Better syntax highlighting possibilities
  { "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "c", "cpp", "python",
        "css", "html", "javascript", "json",
        "bash", "make", "markdown", "markdown_inline", "rst",
        "git_rebase", "gitattributes", "gitcommit", "gitignore",
        "diff", "regex", "lua", "vim", -- "help",
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        disable = { "help" },
        -- Setting this to true will run `:h syntax` and tree-sitter at the
        -- same time. Set this to `true` if you depend on 'syntax' being
        -- enabled (like for indentation). Using this option may slow down
        -- your editor, and you may see some duplicate highlights. Instead of
        -- true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
        disable = { "css" }
      }
    },
  },

  -- fuzzy finder for telescope
  { "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },

  -- file / code finder
  { "nvim-telescope/telescope.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      -- Clone the default Telescope configuration
      local telescopeConfig = require("telescope.config")
      local vimgrep_arguments = {
        table.unpack(telescopeConfig.values.vimgrep_arguments)
      }
      table.insert(vimgrep_arguments, "--hidden") -- Search in hidden/dot files.
      table.insert(vimgrep_arguments, "--glob") -- Don't search in '.git' dir.
      table.insert(vimgrep_arguments, "!**/.git/*")

      require('telescope').setup {
        defaults = {
          -- `hidden = true` is not supported in text grep commands.
          vimgrep_arguments = vimgrep_arguments,
          file_ignore_patterns = {
            'node_modules',
            'buildarea',
          },
          history = {
            path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
            limit = 100,
          },
          mappings = {
            i = {
              ["<esc>"] = require('telescope.actions').close,
              ["<C-w>"] = 'which_key',
              ["<C-Down>"] = require('telescope.actions').cycle_history_next,
              ["<C-Up>"] = require('telescope.actions').cycle_history_prev,
            },
          },
        },
        pickers = {
          live_grep = {
            mappings = {
              i = { ["<c-f>"] = require('telescope.actions').to_fuzzy_refine },
            },
          },
          buffers = {
            ignore_current_buffer = true,
            sort_mru = true,
          },
          find_files = {
            -- `hidden = true` will still show the inside of `.git/`
            -- as it's not `.gitignore`d.
            find_command = {
              "rg", "--files", "--hidden", "--glob", "!**/.git/*"
            },
          },
        },
        extensions = {
          file_browser = {
            auto_depth = true,
            hidden = true,
            hijack_netrw = true,
          },
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
          },
        },
      }
      require('telescope').load_extension('smart_history')
      require('telescope').load_extension('fzf')
      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("file_browser")
    end,
  },

  -- Smart history for telescope
  { "nvim-telescope/telescope-smart-history.nvim",
    dependencies = {
      { "kkharji/sqlite.lua",
        build = "mkdir -p ~/.local/share/nvim/databases",
      },
    },
  },

  { "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    }
  },

  -- Use telescope UI for select
  { "nvim-telescope/telescope-ui-select.nvim" },

  -- Toggle terminal
  { "akinsho/nvim-toggleterm.lua",
    dependencies = "nvim-lua/popup.nvim",
    opts = {
      open_mapping = [[<c-t>]], -- toggle terminal with Ctrl-t
      insert_mappings = true, -- open mapping applies in insert mode
      terminal_mappings = true, -- open mapping applies in the opened terminals
      direction = 'float',
      float_opts = {
        border = 'curved',
        width = function()
          return math.floor(vim.o.columns * 0.7)
        end,
        height = 50,
        winblend = 10,
      },
    },
  },

  -- Fancy notifications
  { "rcarriga/nvim-notify",
    config = function()
      require('notify').setup({
        minimum_width = 30,
        render = require("notifyrender")
      })
      vim.notify = require("notify")
    end,
  },

  -- Highlight indentations
  { "lukas-reineke/indent-blankline.nvim",
    opts = {
      use_treesitter = true,
      show_first_indent_level = false,
    },
  },

  -- New GUI for messages, cmdline and popupmenu
  { "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          long_message_to_split = true,
          command_palette = true,
        },
      })
    end,
  },

  -- keybinding helper
  { "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup({
        window = {
          border = "single",
          margin = { 0.05, 0.06, 0.05, 0.06 },
          winblend = 15,
        },
      })
    end,
  },

  -- highlight context changes in files
  { "atusy/tsnode-marker.nvim",
    lazy = true,
    init = function()
      api.nvim_create_autocmd("FileType", {
        group = api.nvim_create_augroup("tsnode-marker-markdown", {}),
        pattern = "markdown",
        callback = function(ctx)
          require("tsnode-marker").set_automark(ctx.buf, {
            target = { "code_fence_content" }, -- list of target node types
            hl_group = "CursorLine", -- highlight group
          })
        end,
      })
    end,
  },
})

------------------------------------------
-- Folding
------------------------------------------

-- <z>+<Shift+[r/m]> --> open/close all folds
vim.keymap.set('n', 'zR', require('ufo').openAllFolds,
               { desc = 'open all folds' })
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds,
               { desc = 'close all folds' })

------------------------------------------
-- Search
------------------------------------------

local telescope = require('telescope.builtin')
local project_files = function()
  vim.fn.system('git rev-parse --is-inside-work-tree')
  if vim.v.shell_error == 0 then
    telescope.git_files({})
  else
    telescope.find_files({})
  end
end
-- <leader>+<f>+[f/r/h/b] --> find files/recent/buffers/help/browse
vim.keymap.set('n', '<leader>ff', project_files, {desc = 'Find files'})
vim.keymap.set('n', '<leader>fr', telescope.oldfiles, {desc = 'Recent files'})
vim.keymap.set('n', '<leader>fh', telescope.help_tags, {desc = 'Find help tag'})
vim.keymap.set('n', '<leader>fb', ":Telescope file_browser<CR>",
               { silent = true, noremap = true, desc = 'Browse files' })
-- <leader>+<g> --> live grep
vim.keymap.set('n', '<leader>g', telescope.live_grep, {desc = 'Live grep'})
-- <leader>+<v> --> list registers (delete history)
vim.keymap.set('n', '<leader>v', telescope.registers, {desc = 'List registers'})
-- <F5> --> list buffers
vim.keymap.set('n', '<F5>', telescope.buffers, {desc = 'List buffers'})

---- breadcrumbs in lualine ------

-- onedark 'deep' bg1 & orange
api.nvim_set_hl(0, 'bc1_s', { fg = '#abb2bf', bg = '#21283b' })
api.nvim_set_hl(0, 'bc1_m', { fg = '#dd9046', bg = '#21283b' })
api.nvim_set_hl(0, 'bc1_e', { fg = '#1a212e', bg = '#21283b' })

-- onedark 'deep' bg0 & blue
api.nvim_set_hl(0, 'bc2_s', { fg = '#abb2bf', bg = '#1a212e' })
api.nvim_set_hl(0, 'bc2_m', { fg = '#61afef', bg = '#1a212e' })
api.nvim_set_hl(0, 'bc2_e', { fg = '#1a212e', bg = '#1a212e' })

-- onedark 'deep' bg0 & cyan
api.nvim_set_hl(0, 'bc3_s', { fg = '#abb2bf', bg = '#1a212e' })
api.nvim_set_hl(0, 'bc3_m', { fg = '#56b6c2', bg = '#1a212e' })
api.nvim_set_hl(0, 'bc3_e', { fg = '#1a212e', bg = '#1a212e' })

local symbols = {
  { 'bc1_s', '  ', 'bc1_m', 'bc1_e', '' },
  { 'bc2_s', ' 󰊕 ', 'bc2_m', 'bc2_e', ' %##%#bc2_e#' },
  { 'bc3_s', '  ', 'bc3_m', 'bc3_e', '%##%#bc3_e#' },
}

-- show breadcrumbs if available
local function breadcrumbs()
  local items = vim.b.coc_nav
  local t = {''}
  for k,v in ipairs(items) do
    setmetatable(v, { __index = function(table, key)
      return ''
    end})
    t[#t+1] = '%#' .. (symbols[k][1] or 'Normal') .. '#' ..
              (symbols[k][2] or '') ..
              '%#' .. (symbols[k][3] or 'Normal') .. '#' ..
              (v.name or '')
    if next(items,k) ~= nil then
      t[#t+1] = '%#' .. (symbols[k][4] or 'Normal') .. '#' ..
                (symbols[k][5] or '')
    end
  end
  return table.concat(t)
end

------ CoC config -------

-- <ENTER> --> accept selected completion item or notify coc.nvim to format
--             Can't be in LAZY config since it always needs to be mapped
--             <C-g>u breaks current undo, please make your own choice.
vim.keymap.set("i", "<CR>", [[coc#pum#visible() ? coc#pum#confirm() :]] ..
               [["\<C-g>u\<CR><c-r>=coc#on_enter()\<CR>"]],
               { silent = true, noremap = true, expr = true,
                 replace_keycodes = false, desc = 'Select current completion' })

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
    title = "LSP Diagnostics", timeout = 500, on_close = Reset_coc_diag_record,
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
