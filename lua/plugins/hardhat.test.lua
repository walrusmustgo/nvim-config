return {
  -- hardhat.nvim setup
  {
    "TheSnakeWitcher/hardhat.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/neotest",
      "nvim-telescope/telescope.nvim",
      "stevearc/overseer.nvim",
    },
  },
  -- neotest setup
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "TheSnakeWitcher/neotest-hardhat",
    },
    opts = {
      adapters = {
        ["neotest-hardhat"] = {
          filter_dir = function(name)
            return name ~= "node_modules"
          end,
          test_patterns = {
            "test/.*%.js$",
            "test/.*%.ts$",
          },
        },
      },
    },
    config = function(_, opts)
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)

      opts.consumers = opts.consumers or {}
      -- Refresh and add the overseer consumer
      opts.consumers.overseer = require("neotest.consumers.overseer")

      -- Setup neotest
      require("neotest").setup(opts)

      -- Load the hardhat extension for telescope
      require("telescope").load_extension("hardhat")
    end,
    -- stylua: ignore
    -- keys = {
    --   { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
    --   { "<leader>tT", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run All Test Files" },
    --   { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
    --   { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
    --   { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
    --   { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
    --   { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
    -- },
  },
}
