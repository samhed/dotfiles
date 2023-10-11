return function()
  local builtin = require("statuscol.builtin")
  require("statuscol").setup({
    relculright = true, -- fix number alignment for "set relativenumber"
    segments = {
      -- Keep the signcolumn, but with maxwidth 0 to hide the signs
      -- but still allow the line numbers to be colored accordingly.
      -- | Lnum | Git-colored bar | Fold arrow |
      {
        -- Diagnostic signs - not shown, but we need the segment for
        --                    the line numbers to be correctly colored
        sign = {
          text = { "NOT SHOWN" },
          maxwidth = 0,
          auto = false
        },
        click = "v:lua.ScSa",
      },
      {
        -- Lnum
        text = { builtin.lnumfunc },
        click = "v:lua.ScLa",
      },
      {
        -- Git-colored bar
        sign = {
          name = { ".*" },
          maxwidth = 1,
          colwidth = 1,
          fillchar = "│",
          fillcharhl = 'VertSplit'
        },
        click = "v:lua.ScSa",
      },
      {
        -- Fold arrow
        text = { builtin.foldfunc },
        click = "v:lua.ScFa",
      },
    }
  })
end
