return {
  -- Preserve window layouts and prevent NvimTree takeover when closing buffers
  {
    "famiu/bufdelete.nvim",
    cmd = { "Bdelete", "Bwipeout" },
    keys = {
      {
        "<leader>bd",
        function()
          require("bufdelete").bufdelete(0, false)
        end,
        desc = "Close current buffer (preserve window layout)",
      },
    },
  },

  -- Tabs across the top
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "famiu/bufdelete.nvim",
    },
    event = "VeryLazy",
    keys = {
      { "<S-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer tab" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer tab" },
      { "]b", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer tab" },
      { "[b", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer tab" },
      { "<leader>bp", "<cmd>BufferLinePick<CR>", desc = "Pick buffer tab" },
      { "<leader>bc", "<cmd>BufferLineCloseOthers<CR>", desc = "Close other buffers" },
      {
        "<leader>bd",
        function()
          require("bufdelete").bufdelete(0, false)
        end,
        desc = "Close current buffer tab",
      },
    },
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        separator_style = "thin",
        -- Use bufdelete so closing a tab preserves window layout and splits
        close_command = function(bufnr)
          require("bufdelete").bufdelete(bufnr, false)
        end,
        right_mouse_command = function(bufnr)
          require("bufdelete").bufdelete(bufnr, false)
        end,
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
            separator = true,
          },
        },
      },
    },
  },
}
