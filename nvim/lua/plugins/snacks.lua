-- lua/plugins/snacks.lua
return {
  {
    "folke/snacks.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("snacks").setup({
        dashboard = { -- 注意此处必须有 dashboard 字段
          formats = {
            key = function(item)
              return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
            end,
          },
          sections = {
            { section = "terminal", cmd = "fortune -s | cowsay", hl = "header", padding = 1, indent = 8 },
            { title = "MRU", padding = 1 },
            { section = "recent_files", limit = 8, padding = 1 },
            { title = "MRU ", file = vim.fn.fnamemodify(".", ":~"), padding = 1 },
            { section = "recent_files", cwd = true, limit = 8, padding = 1 },
            { title = "Sessions", padding = 1 },
            { section = "projects", padding = 1 },
            { title = "Bookmarks", padding = 1 },
            { section = "keys" },
          },
        },
      })
    end,
  },
}
