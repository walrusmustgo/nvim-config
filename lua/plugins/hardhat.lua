return {
  {
    "TheSnakeWitcher/hardhat.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/neotest",
      "nvim-telescope/telescope.nvim",
      "stevearc/overseer.nvim",
    },
  },
  {
    "nvim-neotest/neotest",
    opts = { adapters = { "neotest-hardhat" } },
  },
}
