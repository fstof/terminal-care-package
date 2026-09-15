return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            hidden = true, -- Always show hidden/dotfiles in the tree explorer
            ignored = true, -- Optional: set to true to also see .gitignore'd files
          },
          files = {
            hidden = true, -- Always show hidden files in the normal file finder (<leader><space>)
          },
        },
      },
    },
  },
}
