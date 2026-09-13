return {
  {
    "Mofiqul/dracula.nvim",
    name = "dracula",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_bg = false,
      italic_comment = true,
    },
    config = function(_, opts)
      local dracula = require("dracula")
      dracula.setup(opts)
      vim.cmd.colorscheme("dracula")
    end,
  },
}
