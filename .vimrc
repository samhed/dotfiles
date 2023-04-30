" -------------------
"  ColorScheme stuff
" -------------------

" Dark gray vertical split  line (with space char)
" set fillchars=vert:\ 
:highlight VertSplit guifg='#444444' guibg='#282C34' ctermfg=236 ctermbg=238

" Show a very faint highlight on the line with the cursor,
" only on active window
:highlight CursorLine cterm=underline guibg='#1c2330'
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" ---------------------------
"  Changed standard settings
" ---------------------------

" Change leader key to SPACE
nnoremap <SPACE> <Nop>
let mapleader = " "

" Autoload file changes
set autoread

" Case insensitive search when only lower case
set ignorecase
set smartcase

" Don't wrap lines
set nowrap

" visual bell instead of sounds
set visualbell t_vb=[?5h$<100/>[?5l

" visually break and indent smartly
" set breakindent

" automatically use the indent of the previous line when starting a new one
set autoindent
" set smartindent

" open browser for urls (need to start with http:// or https://)
let g:netrw_browsex_viewer='xdg-open'

" Use the new regular expression engine
set re=0

" Switch buffers and resize stuff with mouse
set mouse=a

" Some servers have issues with backup files, see CoC issue #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
"
" Also see ToggleSigns()
set signcolumn=yes
" set number
" set signcolumn=number

" Show trailing whitespace, tabs, nbsp etc.
set list listchars=tab:→\ ,nbsp:␣,trail:·,extends:▶,precedes:◀
" By default, use spaced tabs.
set expandtab
" Display tabs as 4 spaces wide. When expandtab is set, use 8 spaces.
set shiftwidth=4
set tabstop=8
" Edit files as if the tab stop size is 0 some other value.
set softtabstop=0
" Insert indentation according to shiftwidth at the beginning
" of the line when pressing the <TAB> key
set smarttab

" Disable delay after leaving Insert mode
if ! has('gui_running')
  set ttimeoutlen=10
  augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
  augroup END
endif

" Enter append mode for :term
autocmd BufRead *term* execute "normal G$"|startinsert!

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Enable file type detection and set matching indent rules
if has("autocmd")
    filetype plugin indent on
endif

" Fix memory leak issue with the above calls to 'match'
if version >= 702
    autocmd BufWinLeave * call clearmatches()
endif

" Wrap location list and quickfix windows
augroup wrap_loclist
    autocmd!
    autocmd FileType qf setlocal wrap
augroup END

" --------------
"  Key bindings
" --------------

" Use <Ctrl+Up> or <Ctrl+Down> to move lines up or down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
nnoremap <A-Down> :m .+1<CR>==
nnoremap <A-Up> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
inoremap <A-Down> <Esc>:m .+1<CR>==gi
inoremap <A-Up> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
vnoremap <A-Down> :m '>+1<CR>gv=gv
vnoremap <A-Up> :m '<-2<CR>gv=gv

" Copy selected text with Ctrl+c
:vmap <C-C> "+y

" Save using Ctrl-s
noremap <silent> <C-s> :update<CR>
vnoremap <silent> <C-s> <C-C>:update<CR>
inoremap <silent> <C-s> <Esc>:update<CR>
" Save using leader-w
noremap <silent> <leader>w :update<CR>
vnoremap <silent> <leader>w <C-C>:update<CR>

" -------------------
"  Usefull functions
" -------------------

" Output the current syntax highlight groups
nnoremap <f10> :call SynStack()<CR>
function! SynStack ()
    let dict = {}
    for i1 in synstack(line("."), col("."))
        let i2 = synIDtrans(i1)
        let n1 = synIDattr(i1, "name")
        let n2 = synIDattr(i2, "name")
        let dict[n1] = "->" . n2
    endfor
    echo dict
endfunction

" Print details of highlight group
" Use like this ':echo GetHighlight("Normal")'
function! GetHighlight(group)
  let output = execute('hi ' . a:group)
  let list = split(output, '\s\+')
  let dict = {}
  for item in list
    if match(item, '=') > 0
      let splitted = split(item, '=')
      let dict[splitted[0]] = splitted[1]
    endif
  endfor
  return dict
endfunction

" Merge Highlights
command! -nargs=+ -complete=highlight MergeHighlight
    \ call s:MergeHighlight(<q-args>)
function! s:MergeHighlight(args) abort "{{{
  let l:args = split(a:args)
  if len(l:args) < 2
    echoerr '[MergeHighlight] At least 2 arguments are required.'
    echoerr 'New highlight name and source highlight names.'
    return
  endif

  " skip 'links' and 'cleared'
  execute 'highlight' l:args[0] l:args[1:]
      \ ->map({_, val -> substitute(execute('highlight ' . val),
      \                                     '^\S\+\s\+xxx\s', '', '')})
      \ ->filter({_, val -> val !~? '^links to' && val !=? 'cleared'})
      \ ->join()
endfunction "}}}

" ----------------------------
"  GIT and vim-fugitive stuff
" ----------------------------

" Always start on the first line of git commit message
autocmd FileType gitcommit,fugitive call setpos('.', [0, 1, 1, 0])

"if fugitive installed:
  " Delete hidden fugitive buffers
  autocmd BufReadPost fugitive://* set bufhidden=delete
  autocmd User fugitive
    \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
    \   nnoremap <buffer> .. :edit %:h<CR> |
    \ endif

  " Use Ctrl+o to cycle back to the fugitive git log after viewing a commit
  function GitFugitiveToggle(buffer_name, pretty_name, cmd)
    let l:buf_nr = -1
    for buf in getbufinfo()
      " if buffer name includes what we're looking for
      if stridx(buf.name, a:buffer_name) >= 0
        let l:buf_nr = buf.bufnr
      endif
    endfor
    if l:buf_nr > 0
      if bufwinnr(l:buf_nr) > 0
        " it is an active window, close and we're done
        execute "bw! " . l:buf_nr
        call v:lua.git_notify(a:cmd, "Closed " . a:pretty_name)
        return
      else
        " the window wasn't active, close and then open a new one
        execute "bw! " . l:buf_nr
      endif
    endif
    " open a new one
    execute a:cmd
    call v:lua.git_notify(a:cmd, "Opened " . a:pretty_name)
  endfunction

  " Toggle git blame current file (Ctrl+b)
  nnoremap <silent> <C-b> :call
    \ GitFugitiveToggle(".fugitiveblame", "git blame", "G blame")<CR>

  " Open Git options (Ctrl+g)
  nnoremap <silent> <C-g> :call
    \ GitFugitiveToggle("fugitive:", "git overview", ":vert Git")<CR>

  " Open Git log (Ctrl+l)
  nnoremap <silent> <C-l> :call
    \ GitFugitiveToggle("tmp/nvim.", "git log", "vert Git log --decorate")<CR>

  " Toggle git log for current file (Ctrl+k)
  nnoremap <silent> <C-k> :call
    \ GitFugitiveToggle("tmp/nvim.", "git log for current file", "vert Git log --decorate %")<CR>
"end if fugitive

" -----------
"  CoC stuff
" -----------

"if coc installed:

  " Don't make the cursor transparent
  let g:coc_disable_transparent_cursor = 1
  let b:coc_nav = 1

  " <Tab> in normal mode for hover
  "     - expands chunks in fugitive
  nnoremap <silent> <Tab> :call HoverAction()<CR>
  function! HoverAction()
    if stridx(@%, "fugitive") >= 0
      call feedkeys('=')
    else
      call CocActionAsync('doHover')
    endif
  endfunction

  augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl
      \ formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end

  " Add `:Format` command to format current buffer.
  command! -nargs=0 Format :call CocActionAsync('format')

  " Add `:Fold` command to fold current buffer.
  command! -nargs=? Fold   :call CocAction('fold', <f-args>)

  " Add `:OR` command for organize imports of the current buffer.
  command! -nargs=0 OR :call
    \ CocActionAsync('runCommand', 'editor.action.organizeImport')

  " Mappings for CoCList
  " Show all diagnostics.
  nnoremap <silent><nowait> <leader>d  :<C-u>CocList diagnostics<cr>
  " Search workspace symbols.
  nnoremap <silent><nowait> <leader>s  :<C-u>CocList -I symbols<cr>
"end if coc

" ---------------
"  lua config
"  --------------


if (has("nvim"))
lua << EOF

vim.opt.termguicolors = true

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
  { "tpope/vim-fugitive" },

  -- rhubarb for connecting to github
  { "tpope/vim-rhubarb" },

  -- comment out stuff with g-c-c
  { "tpope/vim-commentary" },

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
    build = {":CocInstall coc-json coc-css coc-tsserver coc-eslint coc-html coc-html-css-support coc-pyright coc-clangd coc-nav coc-ltex",
             ":CocUpdate"},
    -- Coc will use pycodestyle as a py-linter, exceptions or other config
    -- for pycodestyle is found here: ~/.config/pycodestyle
    config = function ()
      local keyset = vim.keymap.set

      -- Autocomplete
      function _G.check_back_space()
          local col = vim.fn.col('.') - 1
          return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
      end

      -- TAB is the same as Ctrl-i, we need a way to move back in the jump list
      keyset("n", "<C-p>", "<C-i>", {desc = 'back in jump list'})

      -- Insert current completion on TAB or ENTER
      -- Cycle back to previous completion suggest on Shift+Tab
      local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false, desc="completions"}
      keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
      keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

      -- Use Ctrl+j to trigger snippets
      keyset("i", "<C-j>", "<Plug>(coc-snippets-expand-jump)", {desc = 'trigger snippets'})
      -- Use Ctrl+SPACE to trigger completion.
      keyset("i", "<C-space>", "coc#refresh()", {silent = true, expr = true, desc = 'trigger completion'})

      -- Toggle inlay hints (Ctrl+h)
      keyset("n", "<C-h>", ":CocCommand document.toggleInlayHint<CR>", {silent = true, desc = 'toggle inlay hints'})

      -- Use F7 and F8 to navigate diagnostics
      -- Use `:CocDiagnostics` to get all diagnostics of current buffer in
      -- location list.
      keyset("n", "<F7>", "<Plug>(coc-diagnostic-prev)", {silent = true})
      keyset("n", "<F8>", "<Plug>(coc-diagnostic-next)", {silent = true})

      -- Toggle diagnostics with F9
      function _G.toggleSigns()
        vim.fn.CocAction('diagnosticToggle')
        if vim.o.signcolumn == "yes" then
          vim.o.signcolumn = "no"
        else
          vim.o.signcolumn = "yes"
        end
      end
      keyset("n", "<F9>", '<CMD>lua _G.toggleSigns()<CR>')

      -- GoTo code navigation
      keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
      keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
      keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
      keyset("n", "gr", "<Plug>(coc-references)", {silent = true})

      -- Multiple cursors
      keyset("n", "<leader>a", "<Plug>(coc-cursors-position)", {silent = true})
      keyset("n", "<leader>aw", "<Plug>(coc-cursors-word)", {silent = true})
      keyset("x", "<leader>ar", "<Plug>(coc-cursors-range)", {silent = true})
      keyset("n", "<leader>x", "<Plug>(coc-cursors-operator)", {silent = true})

      -- Use K to show documentation in preview window
      function _G.show_docs()
        local cw = vim.fn.expand('<cword>')
        if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
          vim.api.nvim_command('h ' .. cw)
        elseif vim.api.nvim_eval('coc#rpc#ready()') then
          vim.fn.CocActionAsync('doHover')
        else
          vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
        end
      end
      keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true, desc = 'show documentation'})

      -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
      vim.api.nvim_create_augroup("CocGroup", {})
      vim.api.nvim_create_autocmd("CursorHold", {
        group = "CocGroup",
        command = "silent call CocActionAsync('highlight')",
        desc = "Highlight symbol under cursor on CursorHold"
      })

      -- Search and replace under cursor, use CoC's rename when available
      function _G.rename()
        if vim.fn.CocHasProvider('rename') then
          vim.fn.CocActionAsync('rename')
        else
          local keys = vim.api.nvim_replace_termcodes(':%s/<C-r><C-w>//gc<left><left><left>', false, false, true)
          vim.api.nvim_feedkeys(keys, "n", {})
        end
      end

      -- Symbol renaming
      keyset("n", "<leader>r", "<CMD>lua _G.rename()<CR>", {silent = true})
      keyset("n", "<F6>", "<CMD>lua _G.rename()<CR>", {silent = true})
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
      winbar = {}, -- winbar buggy with fugitive (see https://github.com/nvim-lualine/lualine.nvim/issues/948)
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
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
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
      local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
      table.insert(vimgrep_arguments, "--hidden") -- Search in hidden/dot files.
      table.insert(vimgrep_arguments, "--glob") -- Don't search in the '.git' directory
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
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
        },
        extensions = {
          file_browser = {
            auto_depth = true,
            hidden = true,
            hijack_netrw = true,
          },
          fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                             -- the default case_mode is "smart_case"
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
      vim.notify = require("notify")
      require('notify').setup()
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
    dependencies = "MunifTanjim/nui.nvim",
    config = true,
  },

  -- keybinding helper
  { "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
  },

  -- highlight context changes in files
  { "atusy/tsnode-marker.nvim",
    lazy = true,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("tsnode-marker-markdown", {}),
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

vim.o.scrolloff = 5 -- Show 5 screen lines above and below cursor

vim.o.foldcolumn = '0' -- '0' is not bad
vim.o.foldnestmax = 1 -- same number as foldcolumn to hide numbers
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:▼,foldsep: ,foldclose:⏵]]

vim.keymap.set('n', 'zR', require('ufo').openAllFolds, {desc = 'open all folds'})
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, {desc = 'close all folds'})
local telescope = require('telescope.builtin')
local project_files = function()
  local opts = {} -- define here if you want to define something
  vim.fn.system('git rev-parse --is-inside-work-tree')
  if vim.v.shell_error == 0 then
    telescope.git_files(opts)
  else
    telescope.find_files(opts)
  end
end
vim.keymap.set('n', '<leader>ff', project_files, {desc = 'find files'})
vim.keymap.set('n', '<leader>fr', telescope.oldfiles, {desc = 'recent files'})
vim.keymap.set('n', '<leader>g', telescope.live_grep, {desc = 'live grep'})
vim.keymap.set('n', '<leader>fb', ":Telescope file_browser<CR>", {silent = true, noremap = true, desc = 'browse files'})
vim.keymap.set('n', '<F5>', telescope.buffers, {desc = 'list buffers'})
vim.keymap.set('n', '<leader>fh', telescope.help_tags, {desc = 'find help page'})

---- breadcrumbs in lualine ------

-- onedark 'deep' bg1 & orange
vim.cmd "highlight bc1_s guifg=#abb2bf guibg=#21283b"
vim.cmd "highlight bc1_m guifg=#dd9046 guibg=#21283b"
vim.cmd "highlight bc1_e guifg=#1a212e guibg=#21283b"

-- onedark 'deep' bg0 & blue
vim.cmd "highlight bc2_s guifg=#abb2bf guibg=#1a212e"
vim.cmd "highlight bc2_m guifg=#61afef guibg=#1a212e"
vim.cmd "highlight bc2_e guifg=#1a212e guibg=#1a212e"

-- onedark 'deep' bg0 & cyan
vim.cmd "highlight bc3_s guifg=#abb2bf guibg=#1a212e"
vim.cmd "highlight bc3_m guifg=#56b6c2 guibg=#1a212e"
vim.cmd "highlight bc3_e guifg=#1a212e guibg=#1a212e"

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
      t[#t+1] = '%#' .. (symbols[k][4] or 'Normal') .. '#' .. (symbols[k][5] or '')
    end
  end
  return table.concat(t)
end

------ CoC config -------

-- Can't be in LAZY config since it always needs to be mapped
-- Make ENTER to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice.
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
vim.keymap.set("i", "<CR>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

------ notify functions ------

function git_notify(cmd, text)
  local notify_opts = {
    title = text,
    icon = ' ',
    render = 'compact',
    hide_from_history = true,
    timeout = 1,
  }
  vim.notify(cmd, 'warn', notify_opts)
end

function notify_output(command, opts)
  local output = ""
  local notification
  local notify = function(msg, level)
    local notify_opts = vim.tbl_extend(
      "keep",
      opts or {},
      { title = table.concat(command, " "), replace = notification }
    )
    notification = vim.notify(msg, level, notify_opts)
  end
  local on_data = function(_, data)
    output = output .. table.concat(data, "\n")
    notify(output, "info")
  end
  vim.fn.jobstart(command, {
    on_stdout = on_data,
    on_stderr = on_data,
    on_exit = function(_, code)
      if #output == 0 then
        notify("No output of command, exit code: " .. code, "warn")
      end
    end,
  })
end

local coc_status_record = {}

function coc_status_notify(msg, level)
  local notify_opts = { title = "LSP Status", timeout = 500, hide_from_history = true, on_close = reset_coc_status_record }
  -- if coc_status_record is not {} then add it to notify_opts to key called "replace"
  if coc_status_record ~= {} then
    notify_opts["replace"] = coc_status_record.id
    msg = "id " .. coc_staus_record.id .. " : " ..msg
  end
  coc_status_record = vim.notify(msg, level, notify_opts)
end

function reset_coc_status_record(window)
  coc_status_record = {}
end

local coc_diag_record = {}

function coc_diag_notify(msg, level)
  local notify_opts = { title = "LSP Diagnostics", timeout = 500, on_close = reset_coc_diag_record }
  -- if coc_diag_record is not {} then add it to notify_opts to key called "replace"
  if coc_diag_record ~= {} then
    notify_opts["replace"] = coc_diag_record.id
    msg = "id " .. coc_staus_record.id .. " : " ..msg
  end
  coc_diag_record = vim.notify(msg, level, notify_opts)
end

function reset_coc_diag_record(window)
  coc_diag_record = {}
end

function coc_notify(msg, level)
  local notify_opts = { title = "LSP Message", timeout = 500 }
  vim.notify(msg, level, notify_opts)
end

EOF

" ---------- END OF LUA CONF -----------


function! s:DiagnosticNotify() abort
  let l:info = get(b:, 'coc_diagnostic_info', {})
  if empty(l:info) | return '' | endif
  let l:msgs = []
  let l:level = 'info'
  if get(l:info, 'warning', 0)
    let l:level = 'warn'
  endif
  if get(l:info, 'error', 0)
    let l:level = 'error'
  endif
 
  if get(l:info, 'error', 0)
    call add(l:msgs, ' Errors: ' . l:info['error'])
  endif
  if get(l:info, 'warning', 0)
    call add(l:msgs, ' Warnings: ' . l:info['warning'])
  endif
  if get(l:info, 'information', 0)
    call add(l:msgs, ' Infos: ' . l:info['information'])
  endif
  if get(l:info, 'hint', 0)
    call add(l:msgs, ' Hints: ' . l:info['hint'])
  endif
  let l:msg = join(l:msgs, "\n")
  if empty(l:msg) | let l:msg = ' All OK' | endif
  call v:lua.coc_diag_notify(l:msg, l:level)
endfunction

function! s:StatusNotify() abort
  let l:status = get(g:, 'coc_status', '')
  let l:level = 'info'
  if empty(l:status) | return '' | endif
  call v:lua.coc_status_notify(l:status, l:level)
endfunction

function! s:InitCoc() abort
  " load overrides
  runtime! autoload/coc/ui.vim
  execute "lua vim.notify('Initialized coc.nvim for LSP support', 'info', { title = 'LSP Status' })"
endfunction

" notifications
autocmd User CocNvimInit call s:InitCoc()
autocmd User CocDiagnosticChange call s:DiagnosticNotify()
autocmd User CocStatusChange call s:StatusNotify()

endif
