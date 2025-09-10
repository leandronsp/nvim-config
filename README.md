# 🚀 Modern Neovim Configuration

A **modular**, **well-tested**, and **thoroughly documented** Neovim configuration built on the solid foundation of kickstart.nvim. This setup prioritizes **maintainability**, **performance**, and **educational value** while providing a powerful development environment.

## ✨ Features

### 🎯 **Core Philosophy**
- **Modular Architecture** - Clean separation of concerns across organized modules
- **Educational Focus** - Every configuration explained with comprehensive comments  
- **Performance First** - Lazy loading and optimized startup times
- **Testing Coverage** - Unit tests ensure configuration reliability
- **Standards Compliant** - Follows 2024 Neovim and Lua best practices

### 🛠 **Built-in Tools**
- **LSP Integration** - rust-analyzer, lua_ls with automatic installation via Mason
- **Smart Completion** - nvim-cmp with LSP, snippets, paths, and AI suggestions
- **Advanced Search** - Telescope with fuzzy finding, live grep, and file navigation
- **Code Formatting** - Conform.nvim with support for 15+ languages
- **Git Integration** - Gitsigns with hunk navigation and visual indicators  
- **AI Assistance** - Supermaven for intelligent code completion
- **Modern UI** - Everforest theme with beautiful statusline and which-key hints

### 🚀 **Developer Experience**
- **Leader Key**: `;` (semicolon) - more ergonomic than space
- **Instant Feedback** - Sub-200ms completion and diagnostics
- **Smart Navigation** - Jump to definitions, references, implementations
- **Theme Toggle** - Switch between dark/light modes with `;tt`
- **File Explorer** - Neo-tree with `;n` toggle and `;k` reveal
- **Markdown Preview** - Live preview with `;mp`

## 📁 **Architecture**

```
~/.config/nvim/
├── 📄 init.lua                    # Clean entry point (87 lines)
├── 📄 init.lua.backup             # Original monolithic config preserved
├── 📄 README.md                   # This comprehensive guide
├── 🔧 lua/
│   ├── ⚙️  config/                # Core Neovim configuration  
│   │   ├── init.lua              # Module loader
│   │   ├── options.lua           # Vim options & settings
│   │   ├── keymaps.lua           # Key mappings & shortcuts
│   │   ├── autocmds.lua          # Auto commands & events
│   │   └── lazy.lua              # Plugin manager setup
│   ├── 🔌 plugins/               # Plugin configurations
│   │   ├── ui/                   # User interface (theme, statusline, etc.)
│   │   ├── editor/               # Text editing (telescope, treesitter, etc.)
│   │   ├── coding/               # Development tools (LSP, completion, etc.)
│   │   └── tools/                # Utilities (AI, markdown, etc.)
│   ├── 🧪 tests/                 # Unit tests for configuration
│   └── 🏛️  kickstart/            # Original kickstart plugins (preserved)
└── 📊 tests/                     # Test execution scripts
```

## 🚦 **Quick Start**

### **Prerequisites**
```bash
# Required system dependencies
brew install neovim ripgrep fd make gcc git

# Optional but recommended
brew install --cask font-jetbrains-mono-nerd-font
brew install stylua  # For Lua formatting (via Makefile)
```

### **Installation**
```bash
# Option 1: Using the Makefile (Recommended)
make install    # Automatically backs up existing config

# Option 2: Manual installation
mv ~/.config/nvim ~/.config/nvim.backup  # Backup existing config
git clone <your-fork-url> ~/.config/nvim
nvim  # Start Neovim - plugins install automatically
```

### **First Run**
```bash
# Using Makefile (Recommended)
make health          # Comprehensive health check
make sync            # Synchronize all plugins
make quick-test      # Run test suite

# Or manually
nvim
:checkhealth         # Verify system setup
:Lazy sync           # Install/update plugins
:Mason               # Verify LSP servers
```

### **Essential Makefile Commands**
```bash
make help           # Show all available commands
make sync           # Sync plugins and tools
make test           # Run test suite  
make health         # Run health checks
make doctor         # Full diagnostic check
make backup         # Create backup
make info           # Show config info
```

## ⌨️ **Essential Shortcuts**

### **Navigation & Search** (Leader: `;`)
| Shortcut | Action | Description |
|----------|---------|-------------|
| `;sf` | **Search Files** | Find files by name with fuzzy matching |
| `;sg` | **Search Grep** | Search text content across all files |  
| `;sh` | **Search Help** | Search Neovim help documentation |
| `;sk` | **Search Keymaps** | Find and explore all key mappings |
| `;sr` | **Search Resume** | Resume the last telescope search |
| `Ctrl+p` | **Quick Files** | Fast file search (alternative to `;sf`) |
| `Ctrl+f` | **Quick Grep** | Fast text search (alternative to `;sg`) |
| `Ctrl+i` | **Recent Files** | Search recently opened files |

### **File Management**
| Shortcut | Action | Description |
|----------|---------|-------------|
| `;n` | **Toggle Tree** | Show/hide Neo-tree file explorer |
| `;k` | **Reveal File** | Show current file in Neo-tree |
| `;cz` | **Copy Path** | Copy current file path to clipboard |

### **Code Development**
| Shortcut | Action | Description |
|----------|---------|-------------|
| `gd` | **Go Definition** | Jump to symbol definition |
| `gr` | **Go References** | Find all symbol references |
| `gI` | **Go Implementation** | Jump to implementation |
| `;rn` | **Rename** | Rename symbol across project |
| `;ca` | **Code Actions** | Show available code actions |
| `;f` | **Format** | Format current buffer |
| `K` | **Hover Docs** | Show documentation for symbol under cursor |

### **LSP & Diagnostics**
| Shortcut | Action | Description |
|----------|---------|-------------|
| `;ds` | **Doc Symbols** | Search symbols in current file |
| `;ws` | **Workspace Symbols** | Search symbols across project |
| `;sd` | **Search Diagnostics** | Find errors/warnings project-wide |
| `;q` | **Diagnostic List** | Open quickfix list with all diagnostics |
| `;th` | **Toggle Hints** | Toggle inlay type hints |

### **UI & Appearance**
| Shortcut | Action | Description |
|----------|---------|-------------|
| `;tt` | **Toggle Theme** | Switch dark/light theme |
| `;mp` | **Markdown Preview** | Live preview markdown files |

### **Completion & AI**
| Shortcut | Action | Description |
|----------|---------|-------------|
| `Tab` / `Shift+Tab` | **Navigate** | Navigate completion menu |
| `Enter` / `Ctrl+y` | **Accept** | Accept selected completion |
| `Ctrl+Space` | **Trigger** | Manually trigger completion |
| `Ctrl+A` | **Accept AI** | Accept Supermaven AI suggestion |
| `Ctrl+D` | **Clear AI** | Clear AI suggestion |
| `Ctrl+j` | **Accept Word** | Accept next word from AI |

### **Window Navigation**
| Shortcut | Action | Description |
|----------|---------|-------------|
| `Ctrl+h/j/k/l` | **Move Windows** | Navigate between split windows |
| `Escape` | **Clear Search** | Clear search highlighting |

## 🔧 **Configuration**

### **Add Language Servers**

Edit `lua/plugins/coding/lsp.lua`:

```lua
local servers = {
  rust_analyzer = { ... },  -- Already configured
  lua_ls = { ... },         -- Already configured
  
  -- Add new language servers:
  gopls = {},               -- Go
  pyright = {},             -- Python  
  ts_ls = {},               -- TypeScript
  clangd = {},              -- C/C++
}
```

### **Add Formatters**

Edit `lua/plugins/coding/formatting.lua`:

```lua
formatters_by_ft = {
  lua = { 'stylua' },
  python = { "isort", "black" },
  go = { "gofmt" },
  -- Add your language here
  your_language = { "your_formatter" },
}
```

### **Customize Keymaps**

Edit `lua/config/keymaps.lua` to add your own shortcuts:

```lua
-- Add custom keymaps
vim.keymap.set('n', '<leader>cc', '<cmd>your_command<CR>', { desc = 'Your Command' })
```

### **Add Plugins**

Create new files in appropriate plugin directories:

```lua
-- lua/plugins/tools/your-plugin.lua
return {
  'author/your-plugin',
  config = function()
    -- Your plugin configuration
  end,
}
```

## 🧪 **Testing**

Run the comprehensive test suite:

```bash
# Run all tests
nvim -l tests/run.lua

# Test specific aspects  
nvim --headless -c "PlenaryBustedDirectory lua/tests/config/"
nvim --headless -c "PlenaryBustedDirectory lua/tests/plugins/"
```

Tests verify:
- ✅ All configuration options are set correctly
- ✅ Essential keymaps are configured  
- ✅ LSP servers are properly configured
- ✅ Completion sources are available
- ✅ All modules load without errors
- ✅ File structure is correct

## 📚 **Commands Reference**

### **Plugin Management**
```vim
:Lazy                 " Open plugin manager
:Lazy sync            " Update all plugins  
:Lazy install         " Install missing plugins
:Lazy clean           " Remove unused plugins
:Mason                " Manage LSP servers and tools
```

### **LSP & Development**
```vim
:LspInfo              " Show LSP client information
:LspRestart           " Restart LSP servers
:ConformInfo          " Show formatter information
:Format               " Format buffer or selection
:ConformToggle        " Toggle format-on-save
```

### **Health & Diagnostics** 
```vim
:checkhealth          " System health check
:checkhealth kickstart " Kickstart-specific checks
:Telescope diagnostics " Browse all project diagnostics
```

### **Configuration Management**
```vim
:source ~/.config/nvim/init.lua    " Reload configuration
:edit ~/.config/nvim/lua/config/   " Edit configuration modules  
:Telescope find_files cwd=~/.config/nvim  " Browse config files
```

## 🦀 **Language-Specific Commands**

This configuration provides rich LSP support for multiple languages. Here are the most useful commands for each:

### **🦀 Rust Development**

The configuration includes comprehensive Rust support via rust-analyzer with Clippy integration:

**Essential Commands:**
```vim
" LSP Features
gd                    " Go to definition
gr                    " Find references  
gi                    " Go to implementation
K                     " Show documentation
;rn                   " Rename symbol
;ca                   " Code actions (implement traits, add imports, etc.)

" Rust-specific LSP features
;th                   " Toggle inlay hints (see types inline)
```

**Cargo Integration:**
```bash
# In terminal (with Rust PATH configured)
cargo check           # Fast compile check
cargo clippy          # Enhanced linting (configured in LSP)
cargo test            # Run tests
cargo run             # Run project
cargo build --release # Release build
```

**Key Features:**
- ✅ **Clippy integration** - Enhanced linting on save
- ✅ **All Cargo features** enabled
- ✅ **Procedural macros** support
- ✅ **Inlay hints** - See types and parameters inline
- ✅ **Auto-imports** and code actions

### **🐍 Python Development**

Add Python LSP server by editing `lua/plugins/coding/lsp.lua`:
```lua
-- In servers table, add:
pyright = {}, -- or pylsp = {} for alternative
```

**Essential Commands:**
```vim
gd                    " Go to definition
gr                    " Find references
;ca                   " Code actions (organize imports, etc.)
;f                    " Format with black/isort
K                     " Show documentation
```

**Python Tools:**
```bash
# Install via Mason (:Mason) or manually
pip install black isort     # Formatters
pip install flake8 mypy     # Linters
```

### **🐹 Go Development**

Add Go LSP server by editing `lua/plugins/coding/lsp.lua`:
```lua
-- In servers table, add:
gopls = {},
```

**Essential Commands:**
```vim
gd                    " Go to definition
;ca                   " Code actions (generate methods, etc.)
;f                    " Format with gofmt
gr                    " Find references
```

**Go Tools:**
```bash
# Standard Go commands work seamlessly
go run .              # Run current package
go test ./...         # Run all tests  
go build             # Build project
go mod tidy          # Clean dependencies
```

### **⚡ JavaScript/TypeScript**

Add TypeScript LSP server by editing `lua/plugins/coding/lsp.lua`:
```lua
-- In servers table, add:
ts_ls = {},
```

**Essential Commands:**
```vim
gd                    " Go to definition
;ca                   " Code actions (auto-imports, refactoring)
;f                    " Format with prettier
gr                    " Find references across project
;rn                   " Rename symbol
```

**Node.js Integration:**
```bash
npm run dev          # Development server
npm test             # Run tests
npm run build        # Build project
npm run lint         # ESLint checking
```

### **⚙️ C/C++ Development**

Add C/C++ LSP server by editing `lua/plugins/coding/lsp.lua`:
```lua
-- In servers table, add:
clangd = {},
```

**Essential Commands:**
```vim
gd                    " Go to definition/declaration
;ca                   " Code actions
;f                    " Format with clang-format
gr                    " Find references
```

### **🗄️ SQL Development**

Add SQL LSP server:
```lua
-- In servers table, add:
sqlls = {},
```

### **🐳 Docker & Configuration Files**

**Built-in support for:**
- **Dockerfile** - Syntax highlighting and LSP
- **YAML** - Perfect for Docker Compose, CI/CD
- **TOML** - Cargo.toml, pyproject.toml, etc.
- **JSON** - Package files, configs

**Essential Commands:**
```vim
;f                    " Format YAML/JSON/TOML
;ca                   " Code actions for configs
```

### **🌐 Adding New Languages**

To add support for any language:

1. **Add LSP server** in `lua/plugins/coding/lsp.lua`:
```lua
your_language_ls = {},
```

2. **Add formatter** in `lua/plugins/coding/formatting.lua`:
```lua
your_language = { "your_formatter" },
```

3. **Install tools via Mason:**
```vim
:Mason
```

See `:help lspconfig-all` for complete server list.

## 🎯 **Customization Examples**

### **Change Leader Key**

Edit `lua/config/options.lua`:

```lua
vim.g.mapleader = ' '        -- Use space instead of semicolon
vim.g.maplocalleader = ' '
```

### **Add Custom Theme**

Create `lua/plugins/ui/your-theme.lua`:

```lua
return {
  'your/theme-plugin',
  priority = 1000,
  config = function()
    vim.cmd.colorscheme 'your-theme'
  end,
}
```

### **Extend Telescope**

Add to `lua/plugins/editor/telescope.lua`:

```lua
-- Add custom telescope picker
vim.keymap.set('n', '<leader>sc', function()
  require('telescope.builtin').commands()
end, { desc = '[S]earch [C]ommands' })
```

## 🛠 **Troubleshooting**

### **Common Issues**

**Plugins not loading**
```bash
:Lazy sync
:checkhealth lazy
```

**LSP not working**
```bash
:LspInfo
:Mason
:checkhealth lsp
```

**Slow startup**
```bash
nvim --startuptime startup.log
# Review startup.log for bottlenecks
```

**Tests failing**  
```bash
nvim -l tests/run.lua
# Check specific test output
```

### **Reset Configuration**

```bash
# Nuclear option - start fresh
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim  
nvim  # Reinstalls everything
```

## 🤝 **Contributing**

1. **Fork** the repository
2. **Create** a feature branch
3. **Add tests** for new functionality
4. **Run** the test suite: `nvim -l tests/run.lua`
5. **Update** documentation if needed
6. **Submit** a pull request

## 🛠 **Makefile Reference**

This configuration includes a streamlined Makefile focused on routine commands:

### **Essential Commands**
```bash
make help           # Show all available commands
make sync           # Sync all plugins and tools  
make test           # Run complete test suite
make health         # Run health checks
make doctor         # Full diagnostic check
```

### **Plugin Management**
```bash
make install        # Install missing plugins
make update         # Update plugins to latest
make clean          # Remove unused plugins
make restore        # Restore from lazy-lock.json
```

### **Development**
```bash
make format         # Format Lua files (requires stylua)
make lint           # Check Lua code style
make startup-time   # Measure startup performance
make dev            # Start with debug logging
```

### **Maintenance**
```bash
make backup         # Create timestamped backup
make clean-cache    # Clear cache and state
make reset          # Full reset (removes all data)
make info           # Show config statistics
```

Run `make help` to see all available commands.

## 📄 **License**

MIT License - see original kickstart.nvim for details.

## 🙏 **Acknowledgments**

This configuration is a derivative work based on **[kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)** by the nvim-lua community. The original kickstart.nvim provides an excellent foundation for Neovim configuration development.

**Major additions and modifications by @leandronsp:**
- Complete architectural refactor from monolithic to modular design
- Comprehensive testing infrastructure with Plenary
- Professional development workflow with Makefile (40+ commands)
- Extensive documentation and inline comments
- Custom plugin configurations and keymaps

**Special thanks to:**
- **[kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)** - The excellent foundation
- **[lazy.nvim](https://github.com/folke/lazy.nvim)** - Modern plugin management
- **[plenary.nvim](https://github.com/nvim-lua/plenary.nvim)** - Testing framework
- **Neovim Community** - For the amazing ecosystem

---

**Happy coding!** 🎉

For questions or issues, check the [GitHub Issues](https://github.com/your-username/your-repo/issues) page.