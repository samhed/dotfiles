return function()
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "c", "cpp", "python",
      "css", "html", "javascript", "json",
      "bash", "make", "markdown", "markdown_inline", "rst",
      "git_rebase", "gitattributes", "gitignore", -- "gitcommit",
      "comment", "diff", "regex", "lua", "vim",
    },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      -- Setting this to true will run `:h syntax` and tree-sitter at the
      -- same time. Set this to `true` if you depend on 'syntax' being
      -- enabled (like for indentation). Using this option may slow down
      -- your editor, and you may see some duplicate highlights. Instead of
      -- true it can also be a list of languages
      additional_vim_regex_highlighting = false,
      disable = { "alpha" }
    },
    indent = {
      enable = true,
      disable = { "css", "alpha" }
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj
        keymaps = {
          ["af"] = { query = "@function.outer", desc = "Select outer part of function" },
          ["if"] = { query = "@function.inner", desc = "Select inner part of function" },
          ["ac"] = { query = "@class.outer", desc = "Select outer part of class" },
          ["ic"] = { query = "@class.inner", desc = "Select inner part of class" },
          ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
        },
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V', -- linewise
          ['@class.outer'] = '<c-v>', -- blockwise
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["ää"] = { query = "@function.outer", desc = "Next function start" },
          ["äm"] = { query = "@class.outer", desc = "Next class start" },
          ["äo"] = { query = "@loop.*", desc = "Next loop" },
          ["äs"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
          ["äz"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
        },
        goto_next_end = {
          ["äö"] = { query = "@function.outer", desc = "Next function end" },
          ["äM"] = { query = "@class.outer", desc = "Next class end" },
        },
        goto_previous_start = {
          ["öö"] = { query = "@function.outer", desc = "Previous function start" },
          ["öm"] = { query = "@class.outer", desc = "Previous class start" },
        },
        goto_previous_end = {
          ["öä"] = { query = "@function.outer", desc = "Previous function end" },
          ["öM"] = { query = "@class.outer", desc = "Previous class end" },
        },
        goto_next = {
          ["äd"] = { query = "@conditional.outer", desc = "Move to next conditional" },
        },
        goto_previous = {
          ["öd"] = { query = "@conditional.outer", desc = "Move to previous conditional" },
        },
      },
    },
    playground = {
      enable = true,
    },
  })
end
