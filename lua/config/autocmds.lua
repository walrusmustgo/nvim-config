-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Add filetype support for glsl files
vim.filetype.add({
  extension = {
    vert = "glsl",
    frag = "glsl",
    comp = "glsl",
  },
})

-- Godot Pipe
local port = os.getenv("GDScript_Port") or "6005"
local cmd = vim.lsp.rpc.connect("127.0.0.1", port)
local pipe = "/tmp/godot.pipe" -- I use /tmp/godot.pipe

vim.lsp.start({
  name = "Godot",
  cmd = cmd,
  root_dir = vim.fs.dirname(vim.fs.find({ "project.godot", ".git" }, { upward = true })[1]),
  on_attach = function(client, bufnr)
    vim.api.nvim_command('echo serverstart("' .. pipe .. '")')
  end,
})
