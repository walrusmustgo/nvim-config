return {
  {
    "QuickGD/quickgd.nvim",
    ft = { "gdshader", "gdshaderinc" },
    cmd = { "GodotRun", "GodotRunLast", "GodotStart" },
    -- Use opts if passing in settings else use config
    init = function()
      vim.filetype.add({
        extension = {
          gdshaderinc = "gdshaderinc",
        },
      })
    end,
    config = true,
    opts = {}, -- remove config and use this if changing settings.
  },
}
