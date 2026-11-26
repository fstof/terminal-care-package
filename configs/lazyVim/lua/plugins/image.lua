return {
  {
    "folke/snacks.nvim",
    opts = {
      image = {
        enabled = true,
        doc = {
          -- Inline image rendering in supported documents (markdown, html, etc.)
          inline = true,
          -- Float window under cursor if inline is unsupported or off
          float = true,
          max_width = 80,
          max_height = 40,
        },
      },
    },
    init = function()
      local image_group = vim.api.nvim_create_augroup("SnacksImageBufferSwitch", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
        group = image_group,
        pattern = { "*.png", "*.jpg", "*.jpeg", "*.webp", "*.gif", "*.bmp", "*.avif", "*.ico" },
        callback = function(args)
          -- Defer until Neovim finishes drawing the buffer switch
          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(args.buf) or vim.api.nvim_get_current_buf() ~= args.buf then
              return
            end

            -- Retrieve the image instance attached to this buffer
            local img = vim.b[args.buf].snacks_image
            if img then
              if type(img.show) == "function" then
                img:show()
              elseif type(img.render) == "function" then
                img.rendered = false
                img:render()
              end
            else
              -- Fallback if the image instance was purged: re-trigger buffer read
              vim.cmd("edit")
            end
          end)
        end,
      })
    end,
  },
}
