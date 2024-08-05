return {
  -- add pyright to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        pyright = {},
        gdscript = {},
        gdshader_lsp = {},
        rust_analyzer = {},
        glsl_analyzer = {
          filetypes = { "glsl", "vert", "frag", "comp" },
        },
        wgsl_analyzer = {},
        gopls = {},
      },
    },
  },
  -- treesitter, mason and typescript.nvim. So instead of the above, you can use:
  { import = "lazyvim.plugins.extras.lang.typescript" },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "glsl",
        "wgsl",
        "dockerfile",
        "go",
      },
    },
  },
}
