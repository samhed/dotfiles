local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.opt.rtp:append(vim.fn.stdpath("config") .. "/after")

-- Settings, autocmd and keymaps are always nice,
-- load these even if lazy is not installed
require("settings")
require("autocmd")
require("keymap")

-- Abort if we can't load lazy
local ok, _ = pcall(require, "lazy") if not ok then return end

require("lazy").setup("plugins", {
  change_detection = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    border = "rounded",
  },
})
require("filetype")
