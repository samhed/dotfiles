return function()
  require("gitsigns").setup({
    signs = {
      add          = { text = "│" },
      change       = { text = "│" },
      delete       = { text = "│" },
      topdelete    = { text = "╿" },
      changedelete = { text = "┝" },
      untracked    = { text = "┊" },
    },
    on_attach = function(bufnr)
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ',', function()
        if vim.wo.diff then
          vim.cmd.normal({',', bang = true})
        else
          require("gitsigns").nav_hunk('next')
        end
      end)

      map('n', 'm', function()
        if vim.wo.diff then
          vim.cmd.normal({'m', bang = true})
        else
          require("gitsigns").nav_hunk('prev')
        end
      end)
    end,
  })
end
