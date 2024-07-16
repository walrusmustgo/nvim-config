return {
  {
    "pavanbhat1999/figlet.nvim",
    dependencies = { "numToStr/Comment.nvim" },
    config = function()
      local figlet = require("figlet")
      local font = "ANSI\\ Shadow" -- You can change this to any font you want
      local max_width = 1000 -- A very large width to prevent wrapping

      local function figlet_command(text)
        return string.format(":read !figlet -f %s -w %d %s", font, max_width, text)
      end

      figlet.GetLine = function()
        local curr_line = vim.api.nvim_win_get_cursor(0)[1]
        return curr_line
      end

      figlet.Fig = function(arg1)
        vim.api.nvim_command(figlet_command(arg1))
      end

      figlet.FigComment = function(arg1)
        vim.api.nvim_command(figlet_command(arg1))
        require("Comment.api").toggle.linewise("line")
      end

      figlet.FigCommentWithHighlight = function(arg1)
        local start_line = figlet.GetLine()
        vim.api.nvim_command(figlet_command(arg1))
        require("Comment.api").toggle.linewise("line")
        vim.api.nvim_command("normal o")
        vim.api.nvim_command("normal x")
        local stop_line = figlet.GetLine()
        for i = start_line, stop_line do
          vim.api.nvim_buf_add_highlight(0, -1, "ErrorMsg", i, 0, -1)
        end
      end

      figlet.FigSelect = function()
        local arg1 = vim.fn.getline(".")
        figlet.Fig(arg1)
      end

      figlet.FigSelectComment = function()
        local arg1 = vim.fn.getline(".")
        figlet.FigComment(arg1)
      end

      -- Disable line wrapping for the current buffer
      -- vim.api.nvim_command("set nowrap")
    end,
  },
}
