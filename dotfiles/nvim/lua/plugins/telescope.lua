return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Telescope",
    keys = {
      -- Quick buffer switching (list open buffers and search/filter)
      { "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>", desc = "Switch open buffer" },
      { "<leader>bb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>", desc = "List & search open buffers" },
      { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>", desc = "Find open buffers" },

      -- File finding & live text search
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep (search text project-wide)" },
      { "<leader>sb", "<cmd>Telescope live_grep grep_open_files=true<CR>", desc = "Search text inside open buffers" },
      { "<leader>/",  "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Fuzzy search in current buffer" },
      { "<leader>fo", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
      { "<leader>fr", "<cmd>Telescope resume<CR>", desc = "Resume last search" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Workspace diagnostics" },

      -- Git finding
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "View changed & staged files" },
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Git commits log" },
      { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Git branches" },
    },
    opts = {
      defaults = {
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        path_display = { "truncate" },
        layout_config = {
          horizontal = {
            preview_width = 0.55,
            results_width = 0.8,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
      },
      pickers = {
        buffers = {
          sort_mru = true,
          sort_lastused = true,
          mappings = {
            i = {
              ["<C-d>"] = "delete_buffer",
            },
            n = {
              ["dd"] = "delete_buffer",
            },
          },
        },
      },
    },
  },
}
