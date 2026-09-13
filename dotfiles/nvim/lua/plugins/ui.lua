return {
  -- Icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  -- Clean Status Line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "dracula",
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- Floating UI replacement for vim.ui.select and vim.ui.input
  {
    "stevearc/dressing.nvim",
    opts = {
      input = {
        border = "rounded",
      },
      select = {
        backend = { "telescope", "builtin" },
        builtin = {
          border = "rounded",
        },
      },
    },
  },

  -- Keymap discovery popup
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      -- Register friendly group names for which-key
      if wk.add then
        wk.add({
          { "<leader>a", group = "Auto-Save" },
          { "<leader>b", group = "Buffers / Tabs" },
          { "<leader>c", group = "Code / LSP" },
          { "<leader>f", group = "Find (Telescope)" },
          { "<leader>F", group = "Flutter" },
          { "<leader>g", group = "Git / Changes" },
          { "<leader>h", group = "Git Hunks" },
          { "<leader>s", group = "Search Text" },
        })
      end
    end,
  },
}
