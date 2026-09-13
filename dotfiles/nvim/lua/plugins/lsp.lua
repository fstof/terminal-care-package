return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      local lsp_utils = require("config.lsp_utils")

      -- Diagnostic styling and border
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          spacing = 4,
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      })

      -- Diagnostic gutter signs
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- Attach keybindings & document colors automatically on any LSP connection
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          lsp_utils.on_attach(client, ev.buf)

          -- Neovim 0.12+ native document color highlighting (great for Flutter Color(0x...) & Colors.amber)
          if client and client:supports_method("textDocument/documentColor") and vim.lsp.document_color then
            vim.lsp.document_color.enable(true, { bufnr = ev.buf })
          end
        end,
      })

      mason.setup({
        ui = {
          border = "rounded",
        },
      })

      local servers = {
        "lua_ls",
        "jsonls",
        "yamlls",
        "bashls",
      }

      mason_lspconfig.setup({
        ensure_installed = servers,
        automatic_enable = false,
      })

      local capabilities = lsp_utils.get_capabilities()

      local server_configs = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        },
        jsonls = {},
        yamlls = {},
        bashls = {},
      }

      for _, server_name in ipairs(servers) do
        local opts = server_configs[server_name] or {}
        opts.capabilities = capabilities
        vim.lsp.config[server_name] = opts
        vim.lsp.enable(server_name)
      end
    end,
  },
}
