return {
  -- Gitsigns for gutter indicators and hunk manipulation
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
        untracked    = { text = "┆" },
      },
      on_attach = function(bufnr)
        local gs = require("gitsigns")

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Navigation between hunks (changes)
        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, "Next Git hunk")

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, "Previous Git hunk")

        -- Actions
        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        map("v", "<leader>hs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage selected hunk")
        map("v", "<leader>hr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset selected hunk")
        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk diff")
        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, "Blame line (popup)")
        map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle inline blame")
        map("n", "<leader>hd", gs.diffthis, "Diff against index")
      end,
    },
  },

  -- Vim-Fugitive for interactive Git console (:Git)
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gdiffsplit", "Gvdiffsplit", "Gwrite", "Gread" },
    keys = {
      { "<leader>gg", "<cmd>Git<CR>", desc = "Git status summary (Fugitive)" },
      { "<leader>gd", "<cmd>Gdiffsplit<CR>", desc = "Git side-by-side diff" },
    },
  },

  -- Diffview for full-project side-by-side git changes and staging review
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFileHistory" },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<CR>", desc = "Open Git Changes / Staged review panel" },
      { "<leader>gV", "<cmd>DiffviewClose<CR>", desc = "Close Git review panel" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File Git history" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = {
          layout = "diff2_horizontal",
        },
      },
    },
  },
}
