-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Disable the default snacks.nvim keymap
vim.keymap.del("n", "<leader>n")

-- Add our new keymap for snacks.nvim
vim.keymap.set("n", "<leader>m", function()
  require("snacks").notifier.show_history()
end, { desc = "Notification History" })
