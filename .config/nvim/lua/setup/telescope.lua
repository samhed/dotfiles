local telescope = {}

function telescope.config()
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
end

local function project_files()
  local builtin = require('telescope.builtin')
  vim.fn.system('git rev-parse --is-inside-work-tree')
  if vim.v.shell_error == 0 then
    builtin.git_files({})
  else
    builtin.find_files({})
  end
end

local function recent_files() require('telescope.builtin').oldfiles({})  end
local function help_tags()    require('telescope.builtin').help_tags({}) end
local function live_grep()    require('telescope.builtin').live_grep({}) end
local function registers()    require('telescope.builtin').registers({}) end
local function buffers()      require('telescope.builtin').buffers({})   end

telescope.keys = {
  -- <leader>+<f>+[f/r/h] --> find files/recent/buffers/help/browse
  { '<leader>ff', project_files, desc = 'Find files' },
  { '<leader>fr', recent_files, desc = 'Recent files' },
  { '<leader>fh', help_tags, desc = 'Find help tag' },
  -- <leader>+<g> --> live grep
  { '<leader>g', live_grep, desc = 'Live grep' },
  -- <leader>+<v> --> list registers (delete history)
  { '<leader>v', registers, desc = 'List registers' },
  -- <F5> --> list buffers
  { '<F5>', buffers, desc = 'List buffers' },
}
telescope.fb_keys = {
  -- <leader>+<f>+<b> --> browse files
  { '<leader>fb', ":Telescope file_browser<CR>",
    silent = true, noremap = true, desc = 'Browse files' },
}

return telescope
