-- ========================================================================== --
--                             BOOTSTRAP LAZY.NVIM                            --
-- ========================================================================== --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Disable netrw at the start (recommended by nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- ========================================================================== --
--                               GENERAL SETTINGS                             --
-- ========================================================================== --
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Line numbers
vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Relative line numbers for faster jumping

-- Tabs & Indentation
vim.opt.expandtab = true       -- Convert tabs to spaces
vim.opt.shiftwidth = 2         -- Number of spaces for each step of indent
vim.opt.tabstop = 2            -- Number of spaces that a <Tab> counts for
vim.opt.softtabstop = 2        -- Number of spaces for editing tabs
vim.opt.smartindent = true

-- UI & Ergonomics
vim.opt.termguicolors = true   -- 24-bit RGB colors
vim.opt.signcolumn = "yes"     -- Always keep sign column visible (avoids layout shifts with Git signs)
vim.opt.cursorline = true      -- Highlight the current line
vim.opt.scrolloff = 8          -- Keep 8 lines of context around the cursor
vim.opt.wrap = false           -- Don't wrap long lines
vim.opt.ignorecase = true      -- Ignore case when searching
vim.opt.smartcase = true       -- ...unless uppercase characters are typed
vim.opt.updatetime = 250       -- Faster gitsigns and diagnostics update (default is 4000ms)

-- ========================================================================== --
--                                BASIC KEYMAPS                               --
-- ========================================================================== --
-- Indent / unindent visual selection with Tab and keep selection active
vim.keymap.set("v", "<Tab>", ">gv", { noremap = true, silent = true })
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true })

-- Clear search highlight on pressing Escape in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Easy window navigation using Ctrl + hjkl
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to window on the left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to window below" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to window above" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to window on the right" })

-- ========================================================================== --
--                                   PLUGINS                                  --
-- ========================================================================== --
require("lazy").setup({
  spec = {
    -- ---------------------------------------------------------------------- --
    -- 1. FOLDER TREE ON THE LEFT (nvim-tree)
    -- ---------------------------------------------------------------------- --
    {
      "nvim-tree/nvim-tree.lua",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      keys = {
        { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
        { "<leader>o", "<cmd>NvimTreeFindFileToggle<CR>", desc = "Find current file in tree" },
      },
      opts = {
        view = {
          width = 32,
          side = "left",
        },
        renderer = {
          group_empty = true,
          highlight_git = true,
          icons = {
            show = {
              git = true,
              file = true,
              folder = true,
              folder_arrow = true,
            },
          },
        },
        filters = {
          dotfiles = false, -- show dotfiles (.gitignore, .env, etc.)
        },
        git = {
          enable = true,
          ignore = false,   -- show gitignored files (dimmed)
        },
      },
    },

    -- ---------------------------------------------------------------------- --
    -- 2. SYNTAX HIGHLIGHTING (nvim-treesitter)
    -- ---------------------------------------------------------------------- --
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "master",
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = {
            "bash",
            "c",
            "diff",
            "html",
            "javascript",
            "json",
            "lua",
            "luadoc",
            "markdown",
            "markdown_inline",
            "python",
            "query",
            "regex",
            "toml",
            "tsx",
            "typescript",
            "vim",
            "vimdoc",
            "yaml",
            "dart",
            "flutter",
          },
          auto_install = true, -- Automatically install missing parsers when opening new file types
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
          indent = {
            enable = true,
          },
        })
      end,
    },

    -- ---------------------------------------------------------------------- --
    -- 3. GIT INTEGRATION (gitsigns & vim-fugitive)
    -- ---------------------------------------------------------------------- --
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

          -- Hunk staging, preview, and reset
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
          map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle inline git blame")
          map("n", "<leader>hd", gs.diffthis, "Diff against index")
        end,
      },
    },

    {
      "tpope/vim-fugitive",
      cmd = { "Git", "Gdiffsplit", "Gvdiffsplit", "Gwrite", "Gread" },
      keys = {
        { "<leader>gs", "<cmd>Git<CR>", desc = "Git status summary window" },
        { "<leader>gd", "<cmd>Gdiffsplit<CR>", desc = "Git side-by-side diff" },
      },
    },
  },

  -- Colorscheme used during plugin installation
  install = { colorscheme = { "habamax" } },
  -- Automatically check for plugin updates
  checker = { enabled = true },
})
