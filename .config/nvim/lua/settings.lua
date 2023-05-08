local api = vim.api

------------------------------------------
-- General
------------------------------------------

vim.o.mouse = 'a' -- Switch buffers and resize stuff with mouse
vim.o.autoread = true -- Autoload file changes
vim.o.backup = false      -- Some servers have issues with backup
vim.o.writebackup = false -- files, see CoC issue #649
vim.o.undofile = true
vim.g.netrw_browsex_viewer = 'xdg-open' -- open urls (start /w http://)
vim.g.mapleader = " " -- Change leader key to SPACE

------------------------------------------
-- Highlights
------------------------------------------

-- Show a very faint highlight on the line with the cursor
api.nvim_set_hl(0, 'CursorLine', { bg = '#1c2330' })

------------------------------------------
-- Memory, CPU
------------------------------------------

vim.o.updatetime = 300 -- ms to wait for an event to trigger, (default=4s)
vim.o.synmaxcol = 240 -- Max column for syntax highlight

------------------------------------------
-- Neovim UI
------------------------------------------

vim.o.termguicolors = true
vim.o.visualbell = true -- visual bell instead of sounds
vim.o.signcolumn = 'yes' -- Always show to avoid shifts due to diagnostics
vim.o.number = true
vim.o.scrolloff = 5 -- Show 5 screen lines above and below cursor
vim.o.wrap = false -- Don't wrap lines

------------------------------------------
-- Tabs, indent
------------------------------------------

vim.o.list = true
vim.o.listchars = "tab:→ ,nbsp:␣,trail:·,extends:▶,precedes:◀"
vim.o.expandtab = true -- By default, use spaced tabs
vim.o.shiftwidth = 4 -- Display tabs as 4 spaces wide
vim.o.tabstop = 8 -- Count <Tab> as 8 spaces
vim.o.softtabstop = 0 -- Edit files as if the tab size is some other value
vim.o.smarttab = true -- Insert indent at beginning of line when pressing <Tab>
vim.o.autoindent = true -- automatically indent next row
-- vim.o.smartindent = true

------------------------------------------
-- Folding
------------------------------------------

vim.o.foldcolumn = '0' -- '0' is not bad
vim.o.foldnestmax = 1 -- same number as foldcolumn to hide numbers
vim.o.foldlevel = 99 -- Using ufo provider need a large value, can be decreased
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:▼,foldsep: ,foldclose:⏵]]

------------------------------------------
-- Search
------------------------------------------

vim.o.re = 0 -- Use the new regular expression engine
vim.o.ignorecase = true
vim.o.smartcase = true -- Case insensitive search when only lower case
