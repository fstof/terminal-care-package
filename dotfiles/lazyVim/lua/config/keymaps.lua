-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Indent visual selection without losing selection
vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent selection" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Outdent selection" })
vim.keymap.set("i", "jj", "<escape>", { desc = "Escape insert mode" })
vim.keymap.set("i", "jk", "<escape>", { desc = "Escape insert mode" })

-- Keymaps for nvim-dap
vim.keymap.set("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dd", function()
  require("dap").disconnect()
end, { desc = "Debug: Disconnect" })
vim.keymap.set("n", "<F5>", function()
  require("dap").continue()
end, { desc = "Debug: Start/Continue" })
vim.keymap.set("n", "<F10>", function()
  require("dap").step_over()
end, { desc = "Debug: Step Over" })
vim.keymap.set("n", "<F11>", function()
  require("dap").step_into()
end, { desc = "Debug: Step Into" })
vim.keymap.set("n", "<F12>", function()
  require("dap").step_out()
end, { desc = "Debug: Step Out" })

vim.keymap.set("n", "<leader>dc", function()
  require("dap").continue()
end, { desc = "Debug: Start/Continue" })
vim.keymap.set("n", "<leader>do", function()
  require("dap").step_over()
end, { desc = "Debug: Step Over" })
vim.keymap.set("n", "<leader>di", function()
  require("dap").step_into()
end, { desc = "Debug: Step Into" })
vim.keymap.set("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "Debug: Toggle debug view" })

-- Keymaps for flutter-tools
vim.keymap.set("n", "<leader>fr", ":FlutterRun<CR>", { desc = "Flutter Run" })
vim.keymap.set("n", "<leader>fq", ":FlutterQuit<CR>", { desc = "Flutter Quit" })
vim.keymap.set("n", "<leader>fR", ":FlutterReload<CR>", { desc = "Flutter Hot Reload" })
vim.keymap.set("n", "<leader>fd", ":FlutterDevices<CR>", { desc = "Select Flutter Device" })
