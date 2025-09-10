# 📋 Telescope → Snacks Migration Backup

## Current Telescope Keymaps (MUST PRESERVE)

| Keymap | Function | Description | Priority |
|--------|----------|-------------|----------|
| `;sh` | `builtin.help_tags` | Search Help | High |
| `;sk` | `builtin.keymaps` | Search Keymaps | High |  
| `;sf` | `builtin.find_files` | Search Files | Critical |
| `<C-p>` | `builtin.find_files` | Quick Files | Critical |
| `;ss` | `builtin.builtin` | Search Select Telescope | Medium |
| `;sw` | `builtin.grep_string` | Search current Word | High |
| `;sg` | `builtin.live_grep` | Search by Grep | Critical |
| `<C-f>` | `builtin.live_grep` | Quick Grep | Critical |
| `;sd` | `builtin.diagnostics` | Search Diagnostics | High |
| `;sr` | `builtin.resume` | Search Resume | Medium |
| `;s.` | `builtin.oldfiles` | Search Recent Files | High |
| `<C-i>` | `builtin.oldfiles` | Recent Files Alt | High |
| `;<leader>` | `builtin.buffers` | Find existing buffers | Critical |
| `;/` | `current_buffer_fuzzy_find` | Fuzzy search in current buffer | Medium |
| `;s/` | `live_grep` (open files) | Search in Open Files | Medium |
| `;sn` | `find_files` (config dir) | Search Neovim files | High |

## Advanced Features to Replicate

1. **Dropdown Theme**: Used in `;/` for current buffer search
2. **Open Files Only**: Used in `;s/` for grep in open files  
3. **Custom Directory**: Used in `;sn` for config directory search

## LSP Integration (handled separately)
- Definitions, References, Implementations
- Document/Workspace Symbols
- Called via `keymaps.setup_lsp_keymaps(event)`

## Current Dependencies
- `telescope.nvim`
- `telescope-fzf-native.nvim` 
- `telescope-ui-select.nvim`
- `plenary.nvim`

## Branch: migration/snacks-picker
**Backup Files Created**: 
- `telescope.lua.backup` - Original telescope configuration
- This document for reference