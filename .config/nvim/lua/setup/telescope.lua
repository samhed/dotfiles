return function()
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
end
