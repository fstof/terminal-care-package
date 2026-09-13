return {
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      { "<leader>Fr", "<cmd>FlutterRun<CR>", desc = "Run Flutter App" },
      { "<leader>Fq", "<cmd>FlutterQuit<CR>", desc = "Quit Flutter App" },
      { "<leader>FR", "<cmd>FlutterRestart<CR>", desc = "Hot Restart" },
      { "<leader>fr", "<cmd>FlutterReload<CR>", desc = "Hot Reload" },
      { "<leader>Fd", "<cmd>FlutterDevices<CR>", desc = "Select Flutter Device" },
      { "<leader>Fe", "<cmd>FlutterEmulators<CR>", desc = "Select Flutter Emulator" },
      { "<leader>Fo", "<cmd>FlutterOutlineToggle<CR>", desc = "Toggle Widget Outline" },
      { "<leader>Ft", "<cmd>FlutterDevTools<CR>", desc = "Open Flutter DevTools" },
      { "<leader>Fl", "<cmd>FlutterLspRestart<CR>", desc = "Restart Dart LSP" },
      { "<leader>Fc", "<cmd>FlutterLogClear<CR>", desc = "Clear Dev Log" },
      { "<leader>Fp", "<cmd>Telescope flutter commands<CR>", desc = "Flutter Commands (Telescope)" },
      -- Handy function keys for rapid debugging
      { "<F5>", "<cmd>FlutterRun<CR>", desc = "Run Flutter" },
      { "<F6>", "<cmd>FlutterRestart<CR>", desc = "Hot Restart" },
      { "<F7>", "<cmd>FlutterReload<CR>", desc = "Hot Reload" },
    },
    config = function()
      local lsp_utils = require("config.lsp_utils")

      require("flutter-tools").setup({
        ui = {
          border = "rounded",
          notification_style = "native",
        },
        decorations = {
          statusline = {
            app_version = true,
            device = true,
            project_config = true,
          },
        },
        fvm = true, -- Flutter Version Management support
        widget_guides = {
          enabled = true,
        },
        closing_tags = {
          highlight = "Comment",
          prefix = "// ",
          enabled = true,
        },
        dev_log = {
          enabled = true,
          open_cmd = "15split",
          focus_on_open = false,
        },
        outline = {
          open_cmd = "30vnew",
          auto_open = false,
        },
        lsp = {
          capabilities = lsp_utils.get_capabilities(),
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            renameFilesWithClasses = "prompt",
            enableSnippets = true,
            updateImportsOnRename = true,
          },
        },
      })

      -- Load Telescope integration
      pcall(function()
        require("telescope").load_extension("flutter")
      end)
    end,
  },
}
