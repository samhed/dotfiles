return function()
  local builtin = require("statuscol.builtin")
  require("statuscol").setup({
    reculright = true,
    segments = {
      -- Keep the signcolumn, but with maxwidth 0 to hide the signs
      -- but still allow the line numbers to be colored accordingly.
      { sign = { name = { "Diagnostic", "Error", "Warning", "Hint" },
                 maxwidth = 0, auto = false },
        click = "v:lua.ScSa" },
      { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
      { sign = { name = { ".*" }, maxwidth = 1, colwidth = 1,
                 fillchar = "│", fillcharhl = 'VertSplit' },
        click = "v:lua.ScSa" },
      { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
    }
  })
end
