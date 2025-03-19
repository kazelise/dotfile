-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if vim.loader then
  vim.loader.enable()
end

_G.dd = function(...)
  require("util.debug").dump(...)
end
vim.print = _G.dd
--
-- local function detect_theme()
--   local light_theme = "catppuccin-latte"
--   local dark_theme = "catppuccin-mocha"
--
--   local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
--
--   if handle == nil then
--     vim.cmd("colorscheme " .. dark_theme) -- 如果 `handle` 为 `nil`，使用默认的 light theme
--     return
--   end
--
--   local result = handle:read("*a")
--   handle:close()
--
--   if result:match("Dark") then
--     vim.cmd("colorscheme " .. dark_theme)
--   else
--     vim.cmd("colorscheme " .. light_theme)
--   end
-- end
--
-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     detect_theme()
--   end,
-- })
--

-- Enable undercurl
vim.opt.spell = true
vim.opt.spelllang = { "en_us" }
