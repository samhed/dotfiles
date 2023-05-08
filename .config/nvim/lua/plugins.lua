local api = vim.api

------------------------------------------
-- Plugins
------------------------------------------

return {

  -- Auto close parens & brackets etc.
  { "windwp/nvim-autopairs",
    opts = {
      check_ts = true,
      map_cr = false,
    },
  },

  -- Javascript syntax
  { "jelera/vim-javascript-syntax",
    ft = "javascript",
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
    config = require("setup.coc"),
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
      -- <z>+<Shift+[r/m]> --> open/close all folds
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds,
                     { desc = 'open all folds' })
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds,
                     { desc = 'close all folds' })
    end,
  },

  -- Statusline
  { "nvim-lualine/lualine.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      -- require("breadcrumbs")
      require("lualine").setup({
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
        --   lualine_z = {Breadcrumbs}
        -- },
        inactive_winbar = {},
      })
    end
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
            mappings = {
              i = { ["d"] = require('telescope.actions').delete_buffer },
            },
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
}
