-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Handle common binary files by opening them in the default OS application instead of trying to display them in Neovim.
vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = { "*.pdf", "*.png", "*.jpg", "*.jpeg", "*.webp", "*.mp4" },
  callback = function(ctx)
    local filepath = ctx.match

    -- Detect correct OS launcher command (macOS check first)
    local open_cmd = "open"
    if vim.fn.has("macunix") == 1 then
      open_cmd = "open"
    elseif vim.fn.has("win32") == 1 then
      open_cmd = "start"
    elseif vim.fn.has("unix") == 1 then
      open_cmd = "xdg-open"
    end

    -- Run completely detached from Neovim using the modern system API
    vim.system({ open_cmd, filepath }, { detach = true })

    -- Cleanly eliminate the blank text-pane placeholder
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(ctx.buf) then
        pcall(vim.api.nvim_buf_delete, ctx.buf, { force = true })
      end
    end)
  end,
})
