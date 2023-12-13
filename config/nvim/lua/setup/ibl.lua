return function()
  local hooks = require("ibl.hooks")
  hooks.register(
    hooks.type.WHITESPACE,
    hooks.builtin.hide_first_space_indent_level
  )
  hooks.register(
    hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "NonScopeGuide", { fg = "#1f2634" })
    end
  )

  require("ibl").setup({
    indent = {
      highlight = { "NonScopeGuide" },
    },
    scope = {
      show_start = false,
      show_end = false,
      highlight = { "WinSeparator" },
    },
  })
end
