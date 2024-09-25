return {
  -- add gruvbox
  { "sainnhe/everforest" },
  -- { "andersevenrud/nordic.nvim" },
  { "AlexvZyl/nordic.nvim" },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      background = "dark",
      colorscheme = "everforest",
    },
  },
}
