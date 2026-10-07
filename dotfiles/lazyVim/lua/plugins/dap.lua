return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    opts = function()
      -- This extends the built-in LazyVim signs table
      local signs = {
        DapBreakpoint = { text = "🛑", texthl = "DapBreakpoint" },
        DapBreakpointCondition = { text = "⚠️", texthl = "DapBreakpointCondition" },
        DapBreakpointRejected = { text = "🚫", texthl = "DapBreakpointRejected" },
        DapLogPoint = { text = "📝", texthl = "DapLogPoint" },
        DapStopped = { text = "➡️", texthl = "DapStopped" },
      }
      for name, sign in pairs(signs) do
        vim.fn.sign_define(name, sign)
      end
    end,
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local function is_flutter_project(config)
        local workspace = vim.fn.getcwd()
        local cwd = config.cwd and config.cwd:gsub("${workspaceFolder}", workspace) or workspace

        local pubspec = cwd .. "/pubspec.yaml"

        if vim.fn.filereadable(pubspec) == 0 then
          return false
        end

        local content = table.concat(vim.fn.readfile(pubspec), "\n")

        return content:match("\n%s*flutter:%s*\n")
          or content:match("\n%s*flutter:%s*$")
          or content:match("sdk:%s*flutter")
      end

      -- Disable exception breakpoints globally by default
      dap.defaults.fallback.exception_breakpoints = {}

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
