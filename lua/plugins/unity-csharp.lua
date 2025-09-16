-- Unity C# Development Support with Roslyn Language Server
-- Following CGNvim approach: https://github.com/walcht/CGNvim

local fs = vim.fs

local sln_target = nil

---@param client vim.lsp.Client
---@param target string
local function on_init_sln(client, target)
  vim.notify(
    "Initializing: " .. target,
    vim.log.levels.INFO,
    { title = "Unity C# LSP" }
  )
  ---@diagnostic disable-next-line: param-type-mismatch
  client:notify("solution/open", {
    solution = vim.uri_from_fname(target),
  })
end

---@param client vim.lsp.Client
---@param project_files string[]
local function on_init_project(client, project_files)
  vim.notify(
    "Initializing: projects",
    vim.log.levels.INFO,
    { title = "Unity C# LSP", timeout = 10000 }
  )
  ---@diagnostic disable-next-line: param-type-mismatch
  client:notify("project/open", {
    projects = vim.tbl_map(function(file)
      return vim.uri_from_fname(file)
    end, project_files),
  })
end

local function roslyn_handlers()
  return {
    ["workspace/projectInitializationComplete"] = function(_, _, ctx)
      vim.notify(
        "Roslyn project initialization complete",
        vim.log.levels.INFO,
        { title = "Unity C# LSP" }
      )

      local buffers = vim.lsp.get_buffers_by_client_id(ctx.client_id)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      for _, buf in ipairs(buffers) do
        client:request(vim.lsp.protocol.Methods.textDocument_diagnostic, {
          textDocument = vim.lsp.util.make_text_document_params(buf),
        }, nil, buf)
      end
    end,
  }
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local servers = opts.servers or {}
      
      -- Check for Roslyn from flake environment
      local roslyn_path = os.getenv("ROSLYN_LSP_PATH")
      
      if roslyn_path and vim.fn.filereadable(roslyn_path .. "/Microsoft.CodeAnalysis.LanguageServer.dll") == 1 then
        -- Disable omnisharp when Roslyn is available
        servers.omnisharp_mono = nil
        
        -- Register roslyn as a custom server
        local lspconfig = require("lspconfig")
        local configs = require("lspconfig.configs")
        
        if not configs.roslyn then
          configs.roslyn = {
            default_config = {
              cmd = {
                "dotnet",
                roslyn_path .. "/Microsoft.CodeAnalysis.LanguageServer.dll",
                "--logLevel",
                "Information",
                "--extensionLogDirectory", 
                vim.fn.stdpath("cache") .. "/roslyn_ls/logs",
                "--stdio",
              },
              filetypes = { "cs" },
              root_dir = function(fname)
                local util = require("lspconfig.util")
                return util.root_pattern("*.sln", "*.csproj", "omnisharp.json", "function.json")(fname)
                  or util.find_git_ancestor(fname)
              end,
              on_init = function(client, _)
                -- Unity project initialization following CGNvim approach
                local root_dir = client.config.root_dir
                if not root_dir then
                  return
                end

                -- Look for solution files first
                local sln_files = fs.find(function(name)
                  return name:match("%.sln$")
                end, { path = root_dir, type = "file" })

                if #sln_files > 0 then
                  sln_target = sln_files[1]
                  on_init_sln(client, sln_target)
                  return
                end

                -- Fall back to project files
                local project_files = fs.find(function(name)
                  return name:match("%.csproj$")
                end, { path = root_dir, type = "file" })

                if #project_files > 0 then
                  on_init_project(client, project_files)
                end
              end,
              handlers = roslyn_handlers(),
              settings = {
                ["csharp|inlay_hints"] = {
                  csharp_enable_inlay_hints_for_implicit_object_creation = true,
                  csharp_enable_inlay_hints_for_implicit_variable_types = true,
                  csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                  csharp_enable_inlay_hints_for_types = true,
                  dotnet_enable_inlay_hints_for_indexer_parameters = true,
                  dotnet_enable_inlay_hints_for_literal_parameters = true,
                  dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                  dotnet_enable_inlay_hints_for_other_parameters = true,
                  dotnet_enable_inlay_hints_for_parameters = true,
                  dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                  dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                  dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
                },
              },
              init_options = {
                ["csharp|background_analysis"] = {
                  dotnet_analyzer_diagnostics_scope = "fullSolution",
                  dotnet_compiler_diagnostics_scope = "fullSolution",
                },
                ["csharp|code_lens"] = {
                  dotnet_enable_references_code_lens = true,
                },
              },
            },
          }
        end
        
        -- Enable the server
        servers.roslyn = {}
        
        -- Create logs directory if it doesn't exist
        vim.fn.mkdir(vim.fn.stdpath("cache") .. "/roslyn_ls/logs", "p")
        
        vim.notify("🎮 Unity C# Development: Using Roslyn Language Server", vim.log.levels.INFO)
      else
        vim.notify("🔧 C# Development: Roslyn not available (set ROSLYN_LSP_PATH)", vim.log.levels.WARN)
      end
      
      return opts
    end,
  },
  
  -- Unity-specific file type detection and treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.tbl_contains(opts.ensure_installed, "c_sharp") then
        table.insert(opts.ensure_installed, "c_sharp")
      end
      return opts
    end,
  },
  
  -- Unity project detection and environment setup
  {
    "nvim-lua/plenary.nvim",
    config = function()
      local function setup_unity_project()
        local cwd = vim.fn.getcwd()
        local unity_project_files = { "Assets", "ProjectSettings", "Library" }
        
        local is_unity_project = false
        for _, file in ipairs(unity_project_files) do
          if vim.fn.isdirectory(cwd .. "/" .. file) == 1 then
            is_unity_project = true
            break
          end
        end
        
        if is_unity_project then
          vim.env.UNITY_PROJECT_PATH = cwd
          
          -- Unity-specific commands
          vim.api.nvim_create_user_command("UnityRefreshAssets", function()
            vim.notify("Refreshing Unity assets...", vim.log.levels.INFO)
          end, { desc = "Refresh Unity assets" })
          
          vim.api.nvim_create_user_command("UnityBuild", function() 
            vim.notify("Building Unity project...", vim.log.levels.INFO)
          end, { desc = "Build Unity project" })
          
          -- Unity-specific key mappings for C# files
          vim.api.nvim_create_autocmd("FileType", {
            pattern = "cs",
            callback = function()
              vim.keymap.set("n", "<leader>ur", ":UnityRefreshAssets<CR>", 
                { desc = "Unity: Refresh Assets", buffer = true })
              vim.keymap.set("n", "<leader>ub", ":UnityBuild<CR>", 
                { desc = "Unity: Build Project", buffer = true })
            end,
          })
          
          vim.notify("🎮 Unity project detected: " .. vim.fn.fnamemodify(cwd, ":t"), vim.log.levels.INFO)
        end
      end
      
      vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
        callback = setup_unity_project,
      })
    end,
  },
}