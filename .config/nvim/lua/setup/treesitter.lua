return function()
  require("nvim-treesitter.configs").setup({
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
  })
end
