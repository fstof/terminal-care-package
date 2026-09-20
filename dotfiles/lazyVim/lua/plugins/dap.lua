return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Helper to inspect whether the target project is a Flutter app or pure Dart
      local function is_flutter_project(config)
        if config.type == "flutter" then
          return true
        end

        -- Check for Flutter-specific arguments
        if config.args then
          for _, arg in ipairs(config.args) do
            if arg == "--flavor" or arg:match("^--flavor=") or arg == "--no-enable-impeller" then
              return true
            end
          end
        end

        -- Resolve directory to find pubspec.yaml
        local workspace = vim.fn.getcwd()
        local cwd = config.cwd and vim.fn.expand(config.cwd:gsub("${workspaceFolder}", workspace)) or workspace
        local pubspec_path = cwd .. "/pubspec.yaml"

        -- If not directly in cwd, traverse upward from the program file
        if vim.fn.filereadable(pubspec_path) == 0 and config.program then
          local prog = vim.fn.expand(config.program:gsub("${workspaceFolder}", workspace))
          local prog_dir = vim.fn.fnamemodify(prog, ":p:h")
          local found = vim.fs.find("pubspec.yaml", { path = prog_dir, upward = true })
          if found and #found > 0 then
            pubspec_path = found[1]
          end
        end

        -- Check if pubspec.yaml declares Flutter
        if vim.fn.filereadable(pubspec_path) == 1 then
          local lines = vim.fn.readfile(pubspec_path)
          for _, line in ipairs(lines) do
            if line:match("^%s*flutter%s*:") or line:match("sdk:%s*flutter") then
              return true
            end
          end
        end

        return false
      end

      -- Standalone Flutter adapter
      dap.adapters.flutter = {
        type = "executable",
        command = "flutter",
        args = { "debug_adapter" },
      }

      -- Dynamic Dart adapter: mirrors VS Code Dart-Code behavior
      dap.adapters.dart = function(callback, config)
        if is_flutter_project(config) then
          callback({
            type = "executable",
            command = "flutter",
            args = { "debug_adapter" },
          })
        else
          callback({
            type = "executable",
            command = "dart",
            args = { "debug_adapter" },
          })
        end
      end

      -- Dart/Flutter CLI adapter
      -- dap.adapters.flutter = {
      --   type = "executable",
      --   command = "flutter", -- if you're using fvm, you'll need to provide the full path to flutter (flutter.bat for windows users), or you could prepend the fvm command
      --   args = { "debug_adapter" },
      -- }
      -- dap.adapters.dart = {
      --   type = "executable",
      --   command = "flutter", -- if you're using fvm, you'll need to provide the full path to flutter (flutter.bat for windows users), or you could prepend the fvm command
      --   args = { "debug_adapter" },
      -- }
      -- dap.adapters.dart = dap.adapters.flutter
      -- dap.configurations.dart = {
      --   {
      --     type = "flutter",
      --     request = "launch",
      --     name = "Launch flutter",
      --     dartSdkPath = "/Users/FrStofberg/fvm/default/bin/dart", -- ensure this is correct
      --     flutterSdkPath = "/Users/FrStofberg/fvm/default/bin/flutter", -- ensure this is correct
      --     program = "${workspaceFolder}/lib/main.dart", -- ensure this is correct
      --     cwd = "${workspaceFolder}",
      --   },
      --   {
      --     type = "dart",
      --     request = "launch",
      --     name = "Launch dart",
      --     dartSdkPath = "/Users/FrStofberg/fvm/default/bin/dart", -- ensure this is correct
      --     flutterSdkPath = "/Users/FrStofberg/fvm/default/bin/flutter", -- ensure this is correct
      --     program = "${workspaceFolder}/lib/main.dart", -- ensure this is correct
      --     cwd = "${workspaceFolder}",
      --   },
      -- }

      dapui.setup()

      -- Automatically open/close DAP UI during debugging sessions
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.after.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
}
