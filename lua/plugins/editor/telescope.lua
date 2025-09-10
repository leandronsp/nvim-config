-- ===================================================================
-- Telescope - Fuzzy Finder Configuration
-- ===================================================================
-- Powerful fuzzy finder for files, text, LSP symbols, and much more
-- See: https://github.com/nvim-telescope/telescope.nvim

return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    -- Required dependency for telescope functionality
    'nvim-lua/plenary.nvim',

    -- FZF native integration for better performance (C implementation)
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      -- Only load if make is available
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },

    -- Use telescope for vim.ui.select (better UI selection)
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Web dev icons (if Nerd Font is available)
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },

  config = function()
    -- ===================================================================
    -- Telescope Setup and Configuration
    -- ===================================================================
    -- Telescope is more than just a file finder - it can search many
    -- different aspects of Neovim: workspace, LSP, git, and more!
    --
    -- Usage tips:
    -- - In any telescope picker, press <C-/> (insert) or ? (normal) for help
    -- - This shows all available keymaps for the current picker

    require('telescope').setup {
      defaults = {
        -- Configure default mappings for all pickers
        mappings = {
          i = {
            -- Disable default Ctrl-u and Ctrl-d to avoid conflicts
            ['<C-u>'] = false,
            ['<C-d>'] = false,

            -- Use Ctrl-j/k for navigation (more ergonomic)
            ['<C-j>'] = require('telescope.actions').move_selection_next,
            ['<C-k>'] = require('telescope.actions').move_selection_previous,
          },
        },

        -- File ignore patterns for better performance
        file_ignore_patterns = {
          'node_modules',
          '.git/',
          'target/',
          'build/',
          '*.o',
          '*.a',
          '*.out',
          '*.class',
          '*.pdf',
          '*.mkv',
          '*.mp4',
          '*.zip',
        },

        -- Preview window configuration
        preview = {
          treesitter = true, -- Enable treesitter highlighting in preview
          mime_hook = function(filepath, bufnr, opts)
            local is_image = function(filepath)
              local image_extensions = { 'png', 'jpg', 'jpeg', 'gif', 'bmp', 'tiff', 'webp' }
              local split_path = vim.split(filepath:lower(), '.', { plain = true })
              local extension = split_path[#split_path]
              return vim.tbl_contains(image_extensions, extension)
            end
            if is_image(filepath) then
              local term = vim.api.nvim_open_term(bufnr, {})
              local function send_output(_, data, _)
                for _, d in ipairs(data) do
                  vim.api.nvim_chan_send(term, d .. '\r\n')
                end
              end
              vim.fn.jobstart({
                'catimg',
                filepath, -- Terminal image viewer
              }, { on_stdout = send_output, stdout_buffered = true, pty = true })
            else
              require('telescope.previewers.utils').set_preview_message(bufnr, opts.winid, 'Binary cannot be previewed')
            end
          end,
        },
      },

      -- Picker-specific configuration
      pickers = {
        find_files = {
          -- Include hidden files but respect gitignore
          hidden = true,
          find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
        },
        live_grep = {
          -- Search in hidden files but respect gitignore
          additional_args = function(opts)
            return { '--hidden', '--glob', '!**/.git/*' }
          end,
        },
      },

      -- Extension configuration
      extensions = {
        ['ui-select'] = {
          -- Use dropdown theme for vim.ui.select
          require('telescope.themes').get_dropdown(),
        },

        fzf = {
          fuzzy = true, -- Enable fuzzy matching
          override_generic_sorter = true, -- Override the generic sorter
          override_file_sorter = true, -- Override the file sorter
          case_mode = 'smart_case', -- Smart case matching
        },
      },
    }

    -- ===================================================================
    -- Load Extensions
    -- ===================================================================
    -- Enable telescope extensions if they are available

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- ===================================================================
    -- Setup Keymaps
    -- ===================================================================
    -- Load keymaps from the keymaps module (cleaner separation)
    local keymaps = require 'config.keymaps'
    local builtin = require 'telescope.builtin'
    keymaps.setup_telescope_keymaps(builtin)
  end,
}
