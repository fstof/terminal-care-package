local M = {}

function M.on_attach(client, bufnr)
  local map = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
  end

  -- Navigation
  map("gd", vim.lsp.buf.definition, "Go to Definition")
  map("gD", vim.lsp.buf.declaration, "Go to Declaration")
  map("gr", function()
    local ok, builtin = pcall(require, "telescope.builtin")
    if ok then
      builtin.lsp_references()
    else
      vim.lsp.buf.references()
    end
  end, "Find References")

  map("gi", function()
    local ok, builtin = pcall(require, "telescope.builtin")
    if ok then
      builtin.lsp_implementations()
    else
      vim.lsp.buf.implementation()
    end
  end, "Go to Implementation")

  map("gt", function()
    local ok, builtin = pcall(require, "telescope.builtin")
    if ok then
      builtin.lsp_type_definitions()
    else
      vim.lsp.buf.type_definition()
    end
  end, "Type Definition")

  -- Documentation & Actions
  map("K", vim.lsp.buf.hover, "Hover Documentation")
  map("<leader>ca", vim.lsp.buf.code_action, "Code Action (Refactor/Widget)")
  map("<leader>cr", vim.lsp.buf.rename, "Rename Symbol")
  map("<leader>cd", vim.diagnostic.open_float, "Show Line Diagnostics")
  map("[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
  map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
end

function M.get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    capabilities = cmp_lsp.default_capabilities(capabilities)
  end
  return capabilities
end

return M
