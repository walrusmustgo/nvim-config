return {
  "Civitasv/cmake-tools.nvim",
  opts = {
    -- Your existing cmake-tools options (if any)
  },
  keys = {
    { "<leader>kr", "<cmd>CMakeRun<cr>", desc = "CMake Run" },
    { "<leader>kd", "<cmd>CMakeDebug<cr>", desc = "CMake Debug" },
  },
}
