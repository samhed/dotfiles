return function()
  local builtin = require("statuscol.builtin")

  -- Exclude certain filetypes from having line numbers and a statuscol
  local exclude_filetypes = { "fugitive", "alpha", "git" }
  local function is_excluded_buffer(args)
    if vim.api.nvim_buf_is_valid(args.buf) then
      for _, exclude_ft in ipairs(exclude_filetypes) do
        if string.find(
            vim.api.nvim_get_option_value("filetype", { buf = args.buf}),
            exclude_ft) then
          -- Make statuscol take up no space
          vim.api.nvim_set_option_value("numberwidth", 1, { buf = args.buf})
          return false
        end
      end
    end
    return true
  end

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
        condition = { is_excluded_buffer },
        auto = true,
      },
      {
        -- Git-colored bar
        sign = {
          namespace = { "gitsigns" },
          maxwidth = 1,
          colwidth = 1,
          fillchar = "│",
          fillcharhl = 'WinSeparator'
        },
        click = "v:lua.ScSa",
        condition = { is_excluded_buffer },
        auto = true,
      },
      {
        -- Fold arrow
        text = { builtin.foldfunc },
        click = "v:lua.ScFa",
      },
    }
  })
end
