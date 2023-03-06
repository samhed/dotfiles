" -------------------
"  ColorScheme stuff
" -------------------

" Dark gray vertical split  line (with space char)
" set fillchars=vert:\ 
:highlight VertSplit guifg='#444444' guibg='#282C34' ctermfg=236 ctermbg=238

" Show a very faint highlight on the line with the cursor
set cursorline
:highlight CursorLine cterm=underline guibg='#1c2330'

match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd BufEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

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

  function! RemoveWhitespaceHighlightForGit()
    hi link ExtraWhitespace NONE
  endfunction

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

  " TAB is the same as Ctrl-i, we need a way to move back in the jump list
  nnoremap <C-p> <C-i>

  " Insert current completion on TAB or ENTER
  inoremap <silent><expr> <TAB>
        \ coc#pum#visible() ? coc#pum#insert():
        \ CheckBackspace() ? "\<Tab>" :
        \ coc#refresh()
  " Cycle back to previous completion suggest on Shift+Tab
  inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

  " Make <CR> to accept selected completion item or notify coc.nvim to format
  " <C-g>u breaks current undo, please make your own choice.
  " inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
  "                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Use <c-space> to trigger completion.
  if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
  else
    inoremap <silent><expr> <c-@> coc#refresh()
  endif

  " Toggle inlay hints (Ctrl+h)
  nnoremap <C-h> :CocCommand document.toggleInlayHint<CR>

  " Use F7 and F8 to navigate diagnostics
  " Use `:CocDiagnostics` to get all diagnostics of current buffer in
  " location list.
  nmap <silent> <F7> <Plug>(coc-diagnostic-prev)
  nmap <silent> <F8> <Plug>(coc-diagnostic-next)

  " Toggle diagnostics with F9
  nnoremap <F9> :call ToggleSigns()<CR>
  function! ToggleSigns ()
    call CocAction('diagnosticToggle')
    if &signcolumn ==# "yes"
      set signcolumn=no
    else
      set signcolumn=yes
    endif
  endfunction

  " GoTo code navigation.
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

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

  " Use K to show documentation in preview window.
  nnoremap <silent> K :call ShowDocumentation()<CR>

  function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
      call CocActionAsync('doHover')
    else
      call feedkeys('K', 'in')
    endif
  endfunction

  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')


  " --- Use Coc (backslash+r+n) when language server supports it
  " Search and replace under cursor: backslash+r+Enter (\r)
  " nnoremap <leader>r :%s/\<<C-r><C-w>\>//gc<left><left><left>
  function! Rename()
    if CocAction('hasProvider', 'rename')
      call CocActionAsync('rename')
    else
      call feedkeys(":%s/\<C-r>\<C-w>//gc\<left>\<left>\<left>")
    endif
  endfunction

  " Symbol renaming.
  " nmap <leader>rn <Plug>(coc-rename)
  nmap <silent> <leader>r :call Rename()<CR>
  nmap <silent> <F6> :call Rename()<CR>

  " Formatting selected code.
  " xmap <leader>f  <Plug>(coc-format-selected)
  " nmap <leader>f  <Plug>(coc-format-selected)

  augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl
      \ formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end

  " Applying codeAction to the selected region.
  " Example: `<leader>aap` for current paragraph
  " xmap <leader>a  <Plug>(coc-codeaction-selected)
  " nmap <leader>a  <Plug>(coc-codeaction-selected)

  " Remap keys for applying codeAction to the current buffer.
  " nmap <leader>ac  <Plug>(coc-codeaction)
  " Apply AutoFix to problem on the current line.
  " nmap <leader>qf  <Plug>(coc-fix-current)

  " Run the Code Lens action on the current line.
  " nmap <leader>cl  <Plug>(coc-codelens-action)

  " Map function and class text objects
  " NOTE: Requires 'textDocument.documentSymbol' support from the language
  " server.
  " xmap if <Plug>(coc-funcobj-i)
  " omap if <Plug>(coc-funcobj-i)
  " xmap af <Plug>(coc-funcobj-a)
  " omap af <Plug>(coc-funcobj-a)
  " xmap ic <Plug>(coc-classobj-i)
  " omap ic <Plug>(coc-classobj-i)
  " xmap ac <Plug>(coc-classobj-a)
  " omap ac <Plug>(coc-classobj-a)

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
  nnoremap <silent><nowait> <leader>dt  :<C-u>:call CocAction('diagnosticToggle')<cr>
  " Manage extensions.
  " nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
  " Show commands.
  " nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
  " Find symbol of current document.
  " nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
  " Search workspace symbols.
  nnoremap <silent><nowait> <leader>s  :<C-u>CocList -I symbols<cr>
  " Do default action for next item.
  " nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
  " Do default action for previous item.
  " nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
  " Resume latest coc list.
  " nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
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
    ft = "JavaScript",
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
    build = ":CocUpdate",
    -- Coc will use pycodestyle as a py-linter, exceptions or other config
    -- for pycodestyle is found here: ~/.config/pycodestyle
  },
  { "neoclide/coc-json",
    dependencies = "neoclide/coc.nvim",
    lazy = false,
    build = "yarn install --frozen-lockfile",
  },
  { "neoclide/coc-git",
    dependencies = "neoclide/coc.nvim",
    lazy = false,
    build = "yarn install --frozen-lockfile",
  },
  { "neoclide/coc-css",
    dependencies = "neoclide/coc.nvim",
    build = "yarn install --frozen-lockfile",
  },
  { "neoclide/coc-tsserver",
    dependencies = "neoclide/coc.nvim",
    build = "yarn install --frozen-lockfile",
  },
  { "neoclide/coc-eslint",
    dependencies = "neoclide/coc.nvim",
    build = "yarn install --frozen-lockfile",
  },
  { "neoclide/coc-html",
    dependencies = "neoclide/coc.nvim",
    build = "yarn install --frozen-lockfile",
  },
  { "yaegassy/coc-html-css-support",
    dependencies = "neoclide/coc.nvim",
    build = "yarn install --frozen-lockfile",
  },
  { "fannheyward/coc-pyright",
    dependencies = "neoclide/coc.nvim",
    build = "yarn install --frozen-lockfile",
  },
  { "clangd/coc-clangd",
    dependencies = "neoclide/coc.nvim",
    build = "yarn install --frozen-lockfile",
  },
  { "yuki-yano/coc-nav",
    dependencies = "neoclide/coc.nvim",
    build = "yarn install --frozen-lockfile",
  },
  { "josa42/coc-lua",
    dependencies = "neoclide/coc.nvim",
    build = "yarn install --frozen-lockfile",
  },
  { "iamcco/coc-svg",
    dependencies = "neoclide/coc.nvim",
    build = "yarn install --frozen-lockfile",
  },

  -- gitsigns shows git diffs in the sign column
  { "lewis6991/gitsigns.nvim",
    config = true,
  },

  -- Merge conflicts
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
          find_files = {
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
        },
        extensions = {
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
    config = true
  },
})

vim.o.foldcolumn = '0' -- '0' is not bad
vim.o.foldnestmax = 1 -- same number as foldcolumn to hide numbers
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:▼,foldsep: ,foldclose:⏵]]

vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
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
vim.keymap.set('n', '<leader>ff', project_files, {})
vim.keymap.set('n', '<leader>fr', telescope.oldfiles, {})
vim.keymap.set('n', '<leader>g', telescope.live_grep, {})
vim.keymap.set('n', '<leader>fb', telescope.buffers, {})
vim.keymap.set('n', '<F5>', telescope.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope.help_tags, {})

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

-- FIXME

local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice.
vim.keymap.set("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

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
