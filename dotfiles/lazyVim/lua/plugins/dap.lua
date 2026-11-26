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
      local function get_project_cwd(config)
        local workspace = vim.fn.getcwd()
        return (config and config.cwd and config.cwd:gsub("${workspaceFolder}", workspace)) or workspace
      end

      local function is_flutter_project(config)
        local cwd = get_project_cwd(config)
        local pubspec = cwd .. "/pubspec.yaml"

        if vim.fn.filereadable(pubspec) == 0 then
          return false
        end

        local content = table.concat(vim.fn.readfile(pubspec), "\n")

        return content:match("\n%s*flutter:%s*\n")
          or content:match("\n%s*flutter:%s*$")
          or content:match("sdk:%s*flutter")
      end

      -- Resolve Flutter/Dart SDK paths from project FVM (.fvm/flutter_sdk or .fvmrc), falling back to PATH
      local function resolve_sdk_paths(config)
        local cwd = get_project_cwd(config)

        -- 1. Check .fvm/flutter_sdk symlink (created by `fvm use`)
        local fvm_dir = vim.fs.find(".fvm", { path = cwd, upward = true, type = "directory" })[1]
        local flutter_sdk = fvm_dir and vim.uv.fs_realpath(fvm_dir .. "/flutter_sdk") or nil

        -- 2. Fallback: Check .fvmrc (FVM 3+/4+) in case .fvm/flutter_sdk symlink wasn't created yet
        if not flutter_sdk then
          local fvmrc = vim.fs.find(".fvmrc", { path = cwd, upward = true, type = "file" })[1]
          if fvmrc and vim.fn.filereadable(fvmrc) == 1 then
            local ok, decoded = pcall(vim.json.decode, table.concat(vim.fn.readfile(fvmrc), "\n"))
            if ok and type(decoded) == "table" and type(decoded.flutter) == "string" then
              local fvm_home = vim.env.FVM_CACHE_PATH or (vim.uv.os_homedir() .. "/fvm")
              local candidate = fvm_home .. "/versions/" .. decoded.flutter
              if vim.fn.isdirectory(candidate) == 1 then
                flutter_sdk = vim.uv.fs_realpath(candidate) or candidate
              end
            end
          end
        end

        -- 3. Fallback: Resolve from global `flutter` binary in PATH
        if not flutter_sdk then
          local global_flutter = vim.fn.exepath("flutter")
          if global_flutter ~= "" then
            local real_flutter = vim.uv.fs_realpath(global_flutter) or global_flutter
            flutter_sdk = vim.fn.fnamemodify(real_flutter, ":h:h")
          end
        end

        if flutter_sdk then
          return {
            flutter_sdk = flutter_sdk,
            flutter_bin = flutter_sdk .. "/bin/flutter",
            dart_sdk = flutter_sdk .. "/bin/cache/dart-sdk",
            dart_bin = flutter_sdk .. "/bin/dart",
          }
        end

        return {
          flutter_bin = "flutter",
          dart_bin = "dart",
        }
      end

      -- Disable exception breakpoints globally by default
      dap.defaults.fallback.exception_breakpoints = {}

      -- Standalone Flutter adapter (FVM-aware)
      dap.adapters.flutter = function(callback, config)
        local paths = resolve_sdk_paths(config)
        callback({
          type = "executable",
          command = paths.flutter_bin,
          args = { "debug-adapter" },
          enrich_config = function(conf, on_config)
            local final_config = vim.deepcopy(conf)
            final_config.flutterSdkPath = final_config.flutterSdkPath or paths.flutter_sdk
            final_config.dartSdkPath = final_config.dartSdkPath or paths.dart_sdk
            on_config(final_config)
          end,
        })
      end

      -- Dynamic Dart adapter: mirrors VS Code Dart-Code behavior and honors project FVM
      dap.adapters.dart = function(callback, config)
        local paths = resolve_sdk_paths(config)
        if is_flutter_project(config) then
          callback({
            type = "executable",
            command = paths.flutter_bin,
            args = { "debug-adapter" },
            enrich_config = function(conf, on_config)
              local final_config = vim.deepcopy(conf)
              final_config.flutterSdkPath = final_config.flutterSdkPath or paths.flutter_sdk
              final_config.dartSdkPath = final_config.dartSdkPath or paths.dart_sdk
              on_config(final_config)
            end,
          })
        else
          callback({
            type = "executable",
            command = paths.dart_bin,
            args = { "debug_adapter" },
            enrich_config = function(conf, on_config)
              local final_config = vim.deepcopy(conf)
              final_config.dartSdkPath = final_config.dartSdkPath or paths.dart_sdk
              on_config(final_config)
            end,
          })
        end
      end

      -- Explicitly setup dap-ui with custom layouts and silence the LSP fields warning
      ---@diagnostic disable-next-line: missing-fields
      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl", size = 1.0 }, -- Full width bottom log panel
            },
            position = "bottom",
            size = 10,
          },
        },
      })

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

