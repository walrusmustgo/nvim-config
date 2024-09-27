return {
  -- add gruvbox
  { "sainnhe/everforest" },
  { "joshdick/onedark.vim" },
  { "EdenEast/nightfox.nvim" },
  -- { "andersevenrud/nordic.nvim" },
  { "AlexvZyl/nordic.nvim" },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      background = "dark",
      colorscheme = "nightfox",
    },
  },
}
