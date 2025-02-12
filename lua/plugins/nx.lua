return {
  {
    "Equilibris/nx.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("nx").setup({
        nx_cmd_root = "npx nx",
        -- Fix: use terminal_cmd() instead of terminal()
        command_runner = require("nx.command-runners").terminal_cmd(),
        form_renderer = require("nx.form-renderers").telescope(),
        read_init = true,
      })
    end,
    keys = {
      { "<leader>nx", "<cmd>Telescope nx actions<CR>", desc = "nx actions" },
      { "<leader>ng", "<cmd>Telescope nx generators<CR>", desc = "nx generators" },
    },
  },
}
