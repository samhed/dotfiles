local ufo = {}

function ufo.config()
  require('ufo').setup()
end

local function openAllFolds()  require('ufo').openAllFolds()  end
local function closeAllFolds() require('ufo').closeAllFolds() end

local function toggleColumns()
  -- Toggle CoC diagnostics if CoC is loaded, pcall to ignore errors
  pcall(vim.fn.CocAction, 'diagnosticToggleBuffer')
  if vim.o.number then
    vim.o.number = false
    vim.o.relativenumber = false
    vim.o.foldcolumn = "1"
  else
    vim.o.number = true
    vim.o.relativenumber = true
    vim.o.foldcolumn = "0"
  end
end

ufo.keys = {
  -- <F9> --> Toggle diagnostics, fold & number columns
  { '<F9>', toggleColumns, desc = 'Toggle diagnostics, fold & number columns' },
  -- <z>+<Shift+[r/m]> --> open/close all folds
  { 'zR', openAllFolds, desc = 'open all folds' },
  { 'zM', closeAllFolds, desc = 'close all folds' },
}

return ufo
