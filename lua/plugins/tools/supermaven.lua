-- ===================================================================
-- Supermaven AI Completion Configuration
-- ===================================================================
-- AI-powered code completion that works alongside nvim-cmp
-- See: https://github.com/supermaven-inc/supermaven-nvim

return {
  'supermaven-inc/supermaven-nvim',
  event = 'InsertEnter', -- Load when entering insert mode

  config = function()
    require('supermaven-nvim').setup {
      -- ===================================================================
      -- Keymaps for AI Suggestions
      -- ===================================================================
      keymaps = {
        accept_suggestion = '<C-A>', -- Accept the entire suggestion
        clear_suggestion = '<C-D>', -- Clear the current suggestion
        accept_word = '<C-j>', -- Accept only the next word
      },

      -- ===================================================================
      -- File Type Configuration
      -- ===================================================================
      -- File types to ignore (empty = enable for all file types)
      ignore_filetypes = {
        -- Uncomment to disable for specific file types:
        -- "gitcommit",
        -- "gitrebase",
        -- "help",
        -- "markdown",
      },

      -- ===================================================================
      -- Visual Configuration
      -- ===================================================================
      color = {
        suggestion_color = '#ffffff', -- Color for suggestion text
        cterm = 244, -- Terminal color code
      },

      -- ===================================================================
      -- Behavior Options
      -- ===================================================================
      -- Logging level: "off", "error", "warn", "info", "debug", "trace"
      log_level = 'info',

      -- Disable inline completion if you want to use only nvim-cmp
      disable_inline_completion = false,

      -- Disable built-in keymaps if you want complete manual control
      disable_keymaps = false,

      -- ===================================================================
      -- Advanced Options
      -- ===================================================================
      -- Condition function to determine when to show suggestions
      condition = function()
        -- Example: Don't show suggestions in comments
        -- local line = vim.api.nvim_get_current_line()
        -- return not line:match("^%s*[-#/]")
        return true
      end,
    }

    -- ===================================================================
    -- Custom Commands
    -- ===================================================================
    -- Add custom commands for controlling Supermaven
    vim.api.nvim_create_user_command('SupermavenToggle', function()
      -- This would toggle Supermaven if the plugin supports it
      -- Check plugin documentation for available commands
      vim.notify('Supermaven toggled', vim.log.levels.INFO)
    end, { desc = 'Toggle Supermaven AI completion' })

    -- ===================================================================
    -- Integration Notes
    -- ===================================================================
    -- Supermaven is designed to work alongside nvim-cmp, not replace it.
    -- - nvim-cmp handles structured completions (LSP, snippets, etc.)
    -- - Supermaven provides AI-powered inline suggestions
    -- - Both can be used simultaneously for the best experience

    -- The keymaps above don't conflict with nvim-cmp's default mappings:
    -- - <C-A> (accept AI suggestion) vs <Tab>/<CR> (cmp completion)
    -- - <C-D> (clear AI suggestion) vs <C-e> (cmp abort)
    -- - <C-j> (accept word) vs <C-n>/<C-p> (cmp navigation)
  end,
}
