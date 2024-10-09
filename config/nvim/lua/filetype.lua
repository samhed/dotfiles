------------------------------------------
-- Custom filetype associations
------------------------------------------

-- Assume 'markdown' for README files
vim.api.nvim_create_augroup('filetypedetect', { clear = false })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = 'filetypedetect',
  pattern = 'README',
  command = 'if &ft == "text" | set ft=markdown | endif',
})

-- Assume Objective-C for .mm files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = 'filetypedetect',
  pattern = '*.mm',
  command = 'if &ft == "nroff" | set ft=objcpp | endif',
})
