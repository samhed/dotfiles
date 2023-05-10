return function()
  require('notify').setup({
    minimum_width = 30,
    render = require("custom.notifyrender")
  })
  vim.notify = require("notify")
end
