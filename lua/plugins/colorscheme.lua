return {
  -- add gruvbox
  { "sainnhe/everforest" },
  { "joshdick/onedark.vim" },
  { "EdenEast/nightfox.nvim" },
  { "catppuccin/nvim" },
  -- { "andersevenrud/nordic.nvim" },
  { "AlexvZyl/nordic.nvim" },
  { "morhetz/gruvbox" },
  { "sainnhe/sonokai" },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      background = "dark",
      colorscheme = "sonokai",
    },
  },
}
