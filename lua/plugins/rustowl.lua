return {
  { -- INFO: Visualizes ownership movement and lifetimes of variables
    "cordx56/rustowl",
    dependencies = { "neovim/nvim-lspconfig" },
    ft = { "rust" },
    config = function()
      -- Debug: Check if rustowl module is available
      local status, rustowl = pcall(require, "rustowl")
      if not status then
        print("Failed to load rustowl module:", rustowl)
      else
        print("Successfully loaded rustowl module")
      end

      local lspconfig = require("lspconfig")
      lspconfig.rustowl.setup({
        trigger = {
          hover = true,
        },
      })

      -- Only set up keybinding if module is available
      if status then
        vim.keymap.set("n", "<leader>co", rustowl.rustowl_cursor, { noremap = true, silent = false })

        -- Add command alternative
        vim.api.nvim_create_user_command("RustOwlShow", function()
          rustowl.rustowl_cursor()
        end, {})
      end
    end,
  },
}
