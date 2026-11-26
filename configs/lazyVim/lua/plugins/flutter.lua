return {
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("flutter-tools").setup({
        fvm = true,
        root_patterns = { ".git", "pubspec.yaml" },
        debugger = {
          enabled = true,
          register_configurations = function(_)
            -- Leave empty or load launch.json if needed; nvim-dap automatically reads .vscode/launch.json
          end,
        },
        dev_log = {
          enabled = false,
          open_cmd = "15split",
        },
      })
    end,
  },
}
