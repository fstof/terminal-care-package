-- ========================================================================== --
--                               GENERAL SETTINGS                             --
-- ========================================================================== --

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable netrw for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Line numbering
vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Relative line numbers for easier jumping

-- Tabs & Indentation (Flutter standard: 2 spaces)
vim.opt.expandtab = true       -- Convert tabs to spaces
vim.opt.shiftwidth = 2         -- Number of spaces for indentation
vim.opt.tabstop = 2            -- Number of spaces a tab counts for
vim.opt.softtabstop = 2
vim.opt.smartindent = true

-- UI & Editor ergonomics
vim.opt.termguicolors = true   -- 24-bit RGB colors
vim.opt.signcolumn = "yes"     -- Always show sign column (avoids jumping text with Git/LSP signs)
vim.opt.cursorline = true      -- Highlight current cursor line
vim.opt.scrolloff = 8          -- Keep 8 lines visible above/below cursor
vim.opt.wrap = false           -- Disable line wrap
vim.opt.ignorecase = true      -- Case-insensitive search
vim.opt.smartcase = true       -- Case-sensitive if uppercase entered
vim.opt.updatetime = 250       -- Faster completion & gitsigns updates
vim.opt.timeoutlen = 300       -- Faster which-key popup display

-- Window splits
vim.opt.splitright = true      -- Put new vertical splits to the right
vim.opt.splitbelow = true      -- Put new horizontal splits to the bottom

-- Clipboard (unnamedplus syncs with system clipboard)
vim.opt.clipboard = "unnamedplus"
