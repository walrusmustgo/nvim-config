return {
  -- add gruvbox
  { "sainnhe/everforest" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      background = "dark",
      colorscheme = "everforest",
    },
  },
}
