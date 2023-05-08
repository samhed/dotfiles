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
    config = require("setup.fugitive"),
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
      -- require("custom.breadcrumbs")
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
    config = require("setup.telescope"),
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
        render = require("custom.notifyrender")
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
    config = require("setup.whichkey"),
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
