return {
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    keys = {
      { "<leader>as", "<cmd>ASToggle<CR>", desc = "Toggle Auto-Save" },
    },
    opts = {
      enabled = true,
      trigger_events = {
        immediate_save = { "FocusLost", "BufLeave" },
        defer_save = { "InsertLeave", "TextChanged" },
      },
      debounce_delay = 1000, -- Wait 1s after typing before saving
      condition = function(buf)
        local fn = vim.fn
        local utils = require("auto-save.utils.data")
        -- Only save modifiable, named buffers and skip special windows
        if fn.getbufvar(buf, "&modifiable") == 1
           and fn.expand("%") ~= ""
           and utils.not_in(fn.getbufvar(buf, "&filetype"), { "NvimTree", "TelescopePrompt", "gitcommit", "diffview" }) then
          return true
        end
        return false
      end,
    },
  },
}
