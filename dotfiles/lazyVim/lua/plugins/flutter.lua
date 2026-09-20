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
        root_patterns = { ".git", "pubspec.yaml" },
        debugger = {
          enabled = true,
          run_via_dap = true,
          fvm = true,

          register_configurations = function(_)
            local dap = require("dap")
            dap.load_launchjs()
          end,
        },
        dev_log = {
          enabled = true,
          open_cmd = "15split",
        },
      })
    end,
  },
}
