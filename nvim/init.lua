-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if vim.loader then
  vim.loader.enable()
end

_G.dd = function(...)
  require("util.debug").dump(...)
end
vim.print = _G.dd

-- Enable undercurl
vim.opt.spell = true
vim.opt.spelllang = { "en_us" }
