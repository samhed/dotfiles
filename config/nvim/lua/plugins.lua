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
    event = "VeryLazy",
  },

  -- Javascript syntax
  { "jelera/vim-javascript-syntax",
    ft = "javascript",
  },

  -- Makes word motions work for CamelCase and snake_case
  { "chaoren/vim-wordmotion",
    event = "VeryLazy",
  },

  -- fugitive is a git plugin
  { "tpope/vim-fugitive",
    config = require("setup.fugitive").config,
    keys = require("setup.fugitive").keys,
  },

  -- rhubarb for connecting to github
  { "tpope/vim-rhubarb",
    event = "VeryLazy",
  },

  -- comment out stuff with g-c-c
  { "numToStr/Comment.nvim",
    config = true,
    event = "VeryLazy",
  },

  -- Auto detect indentation
  { "tpope/vim-sleuth",
    event = "VeryLazy",
  },

  -- UNIX shell commands from vim
  { "tpope/vim-eunuch",
    event = "VeryLazy",
  },

  -- Colorify color-hex codes
  { "rrethy/vim-hexokinase",
    build = "make hexokinase",
    event = "VeryLazy",
  },

  -- CoC for LSP support & Tab completion
  { "neoclide/coc.nvim",
    branch = "release",
    build = {":CocInstall coc-json coc-css coc-tsserver coc-eslint coc-html " ..
             "coc-html-css-support coc-pyright coc-clangd coc-lua coc-ltex " ..
             "coc-snippets coc-nav coc-tabnine", ":CocUpdate"},
    -- Coc will use pycodestyle as a py-linter, exceptions or other config
    -- for pycodestyle is found here: ~/.config/pycodestyle
    config = require("setup.coc"),
    event = "VeryLazy",
  },

  -- gitsigns shows git diffs in the sign column
  { "lewis6991/gitsigns.nvim",
    config = require("setup.gitsigns"),
  },

  -- Merge conflicts
  -- c+o = choose ours, c+t = theirs, ]+x = previous conflict, [+x = next
  { "akinsho/git-conflict.nvim",
    opts = { disable_diagnostics = true },
    event = "VeryLazy",
  },

  -- Better folding
  { "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter",
      "luukvbaal/statuscol.nvim"
    },
    keys = require("setup.ufo").keys,
    config = require("setup.ufo").config,
  },

  -- Status column for signs, numbers and fold
  { "luukvbaal/statuscol.nvim",
    config = require("setup.statuscol"),
  },

  -- Statusline
  { "nvim-lualine/lualine.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = require("setup.lualine"),
  },

  -- Nice colorscheme (no proper highlights for Python)
  { "navarasu/onedark.nvim",
    config = require("setup.onedark"),
    priority = 1000,
  },

  -- Greeting screen
  { "goolord/alpha-nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "navarasu/onedark.nvim",
    },
    config = require("setup.alpha"),
  },

  -- Better syntax highlighting possibilities
  { "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = require("setup.treesitter"),
    event = "VeryLazy",
  },

  -- Treesitter and highlight group information
  { "nvim-treesitter/playground",
    dependencies = "nvim-treesitter/nvim-treesitter",
    cmd = "TSPlaygroundToggle",
    module = false, -- only load on command
  },

  -- fuzzy finder for telescope
  { "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    keys = require("setup.telescope").keys,
  },

  -- file / code finder
  { "nvim-telescope/telescope.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    keys = require("setup.telescope").keys,
    config = require("setup.telescope").config,
  },

  -- Smart history for telescope
  { "nvim-telescope/telescope-smart-history.nvim",
    dependencies = {
      { "kkharji/sqlite.lua",
        build = "mkdir -p ~/.local/share/nvim/databases",
      },
    },
    keys = require("setup.telescope").keys,
  },

  -- Filebrowsing
  { "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    keys = require("setup.telescope").fb_keys,
  },

  -- Use telescope UI for select
  { "nvim-telescope/telescope-ui-select.nvim" },

  -- Toggle terminal
  { "akinsho/toggleterm.nvim",
    dependencies = "nvim-lua/popup.nvim",
    config = require("setup.toggleterm").config,
    keys = require("setup.toggleterm").keys,
  },

  -- Fancy notifications
  { "rcarriga/nvim-notify",
    config = require("setup.notify"),
  },

  -- Highlight indentations
  { "lukas-reineke/indent-blankline.nvim",
    opts = {
      use_treesitter = true,
      show_first_indent_level = false,
    },
    event = "VeryLazy",
  },

  -- New GUI for messages, cmdline and popupmenu
  { "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = require("setup.noice"),
  },

  -- keybinding helper
  { "folke/which-key.nvim",
    config = require("setup.whichkey"),
    event = "VeryLazy",
  },

  -- Google Keep integration
  { "stevearc/gkeep.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
  },

  -- GitHub Copilot
  { "github/copilot.vim",
    config = require("setup.copilot"),
  },

  -- Smooth scrolling
  { "declancm/cinnamon.nvim",
    config = true,
  },
}
