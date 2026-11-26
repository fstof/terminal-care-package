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
vim.keymap.set("n", "<leader>rc", function()
  require("dap").repl.clear()
end, { desc = "DAP: Clear REPL Console" })

-- Keymaps for flutter-tools
vim.keymap.set("n", "<leader>fr", ":FlutterRun<CR>", { desc = "Flutter Run" })
vim.keymap.set("n", "<leader>fq", ":FlutterQuit<CR>", { desc = "Flutter Quit" })
vim.keymap.set("n", "<leader>fR", ":FlutterReload<CR>", { desc = "Flutter Hot Reload" })
vim.keymap.set("n", "<leader>fd", ":FlutterDevices<CR>", { desc = "Select Flutter Device" })
vim.keymap.set("n", "<leader>fD", ":FlutterEmulators<CR>", { desc = "Select Flutter Emulator" })

-- Keymaps for multicursor.nvim
local mc = require("multicursor-nvim")
-- Add or skip cursor above/below the main cursor.
vim.keymap.set({ "n", "x" }, "<up>", function()
  mc.lineAddCursor(-1)
end, { desc = "Add cursor above" })
vim.keymap.set({ "n", "x" }, "<down>", function()
  mc.lineAddCursor(1)
end, { desc = "Add cursor below" })
vim.keymap.set({ "n", "x" }, "<leader><up>", function()
  mc.lineSkipCursor(-1)
end, { desc = "Skip cursor above" })
vim.keymap.set({ "n", "x" }, "<leader><down>", function()
  mc.lineSkipCursor(1)
end, { desc = "Skip cursor below" })

-- Add or skip adding a new cursor by matching word/selection
vim.keymap.set({ "n", "x" }, "<leader>n", function()
  mc.matchAddCursor(1)
end, { desc = "Match add cursor next" })
vim.keymap.set({ "n", "x" }, "<leader>s", function()
  mc.matchSkipCursor(1)
end, { desc = "Match skip cursor next" })
vim.keymap.set({ "n", "x" }, "<leader>N", function()
  mc.matchAddCursor(-1)
end, { desc = "Match add cursor prev" })
vim.keymap.set({ "n", "x" }, "<leader>S", function()
  mc.matchSkipCursor(-1)
end, { desc = "Match skip cursor prev" })

-- Add and remove cursors with control + left click.
vim.keymap.set("n", "<c-leftmouse>", mc.handleMouse)
vim.keymap.set("n", "<c-leftdrag>", mc.handleMouseDrag)
vim.keymap.set("n", "<c-leftrelease>", mc.handleMouseRelease)

-- Disable and enable cursors.
vim.keymap.set({ "n", "x" }, "<c-q>", mc.toggleCursor, { desc = "Toggle cursors" })

-- Toggle Auto Save
Snacks.toggle({
  name = "Auto Save",
  get = function()
    return vim.g.auto_save == true
  end,
  set = function(state)
    vim.g.auto_save = state
  end,
}):map("<leader>ua")

-- Filter LazyGit to the current file when opening it with <leader>gg
vim.keymap.set("n", "<leader>gg", function()
  local file = vim.api.nvim_buf_get_name(0)
  local rel_path = vim.fn.fnamemodify(file, ":.")

  -- Open standard Lazygit (defaults to the Files panel)
  local win = Snacks.lazygit()

  -- If the current buffer is a valid file, filter the Files panel to it
  if file ~= "" and vim.fn.filereadable(file) == 1 and win and win.buf then
    vim.defer_fn(function()
      if vim.api.nvim_buf_is_valid(win.buf) then
        local chan = vim.bo[win.buf].channel
        if chan and chan > 0 then
          -- Sends '/' to start filtering, types the relative path, and presses Enter
          vim.api.nvim_chan_send(chan, "/" .. rel_path .. "\r")
        end
      end
    end, 150)
  end
end, { desc = "Lazygit (Highlight Current File)" })


