return function()
  local builtin = require("statuscol.builtin")
  require("statuscol").setup({
    reculright = true,
    segments = {
      { sign = { name = { "Diagnostic", "Error", "Warning", "Hint" },
                 maxwidth = 2, auto = true },
        click = "v:lua.ScSa" },
      { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
      { sign = { name = { ".*" }, maxwidth = 1, colwidth = 1,
                 fillchar = "│", fillcharhl = 'VertSplit' },
        click = "v:lua.ScSa" },
      { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
    }
  })
end
