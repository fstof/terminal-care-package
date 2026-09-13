-- ========================================================================== --
--                        NEOVIM CONFIGURATION ENTRYPOINT                     --
-- ========================================================================== --

-- Load general settings and options (vim.opt)
require("config.options")

-- Load basic keymaps (window movement, indent, etc.)
require("config.keymaps")

-- Bootstrap package manager and load plugins from lua/plugins/*
require("config.lazy")
