-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
local external_media_group = vim.api.nvim_create_augroup("ExternalMediaOpener", { clear = true })

-- List all non-text file patterns to delegate to the OS
local media_patterns = {
  -- Images
  "*.png",
  "*.jpg",
  "*.jpeg",
  "*.webp",
  "*.gif",
  "*.bmp",
  "*.avif",
  "*.ico",
  "*.tiff",
  "*.svg",

  -- Documents & Books
  "*.pdf",
  "*.epub",

  -- Video
  "*.mp4",
  "*.mkv",
  "*.mov",
  "*.avi",
  "*.webm",
  "*.m4v",

  -- Audio
  "*.mp3",
  "*.wav",
  "*.flac",
  "*.m4a",
  "*.aac",
  "*.ogg",
}

vim.api.nvim_create_autocmd("BufReadCmd", {
  group = external_media_group,
  pattern = media_patterns,
  callback = function(args)
    -- Guard: Skip execution if inside a floating preview window (e.g. Snacks/Telescope picker preview)
    local win = vim.api.nvim_get_current_win()
    local win_cfg = vim.api.nvim_win_get_config(win)
    if win_cfg.relative and win_cfg.relative ~= "" then
      return
    end

    local filepath = vim.fn.fnamemodify(args.file, ":p")

    -- Launch system default application asynchronously
    if vim.ui and vim.ui.open then
      vim.ui.open(filepath)
    else
      local opener = vim.fn.has("mac") == 1 and "open" or (vim.fn.has("win32") == 1 and "start" or "xdg-open")
      vim.fn.jobstart({ opener, filepath }, { detach = true })
    end

    -- Clean up: switch back to the previous buffer and wipe out the media buffer
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(args.buf) then
        local prev_buf = vim.fn.bufnr("#")
        if prev_buf > 0 and prev_buf ~= args.buf and vim.api.nvim_buf_is_loaded(prev_buf) then
          pcall(vim.api.nvim_set_current_buf, prev_buf)
        end
        pcall(vim.cmd, "bwipeout! " .. args.buf)
      end
    end)
  end,
})
