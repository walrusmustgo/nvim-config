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
        -- gdshader_lsp = {},
        rust_analyzer = {},
        glsl_analyzer = {
          filetypes = { "glsl", "vert", "frag", "comp" },
        },
        wgsl_analyzer = {
          filetypes = { "wgsl" },
        },
        gopls = {},
        omnisharp_mono = {
          -- cmd = { "dotnet", "/home/walrusmustgo/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll" },
          enable_editorconfig_support = true,
          enable_ms_build_load_projects_on_demand = false,
          enable_roslyn_analyzers = false,
          organize_imports_on_format = true,
          enable_import_completion = true,
          sdk_include_prereleases = true,
          analyze_open_documents_only = false,
        },
        cypher_ls = {
          opts = {},
        },
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
        -- "gdshader",
        "vim",
        "yaml",
        "glsl",
        "wgsl",
        "dockerfile",
        "c_sharp",
        "go",
      },
    },
  },
}
