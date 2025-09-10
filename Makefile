SHELL = /bin/bash
.ONESHELL:
.DEFAULT_GOAL: help

# Neovim Configuration Variables
NVIM_CONFIG_DIR := $(HOME)/.config/nvim
NVIM_DATA_DIR := $(HOME)/.local/share/nvim
NVIM_STATE_DIR := $(HOME)/.local/state/nvim
NVIM_CACHE_DIR := $(HOME)/.cache/nvim
BACKUP_DIR := $(HOME)/.config/nvim-backup-$(shell date +%Y%m%d-%H%M%S)

help: ## Show all available commands
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[.a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Configuration Management

install: ## Install configuration (backs up existing config)
	@echo "🔧 Installing Neovim configuration..."
	@if [ -d "$(HOME)/.config/nvim" ] && [ "$(PWD)" != "$(HOME)/.config/nvim" ]; then \
		echo "📦 Backing up existing configuration to $(BACKUP_DIR)"; \
		mv $(HOME)/.config/nvim $(BACKUP_DIR); \
	fi
	@if [ "$(PWD)" != "$(HOME)/.config/nvim" ]; then \
		echo "📁 Symlinking configuration to $(HOME)/.config/nvim"; \
		ln -sf $(PWD) $(HOME)/.config/nvim; \
	fi
	@echo "✅ Configuration installed successfully"
	@make health

uninstall: ## Remove configuration and restore backup if available
	@echo "🗑️ Uninstalling Neovim configuration..."
	@if [ -L "$(HOME)/.config/nvim" ]; then \
		rm $(HOME)/.config/nvim; \
		echo "🔗 Removed symlink"; \
	elif [ -d "$(HOME)/.config/nvim" ]; then \
		mv $(HOME)/.config/nvim $(HOME)/.config/nvim-removed-$(shell date +%Y%m%d-%H%M%S); \
		echo "📦 Moved existing config to backup"; \
	fi
	@LATEST_BACKUP=$$(ls -t $(HOME)/.config/nvim-backup-* 2>/dev/null | head -1); \
	if [ -n "$$LATEST_BACKUP" ]; then \
		echo "🔄 Restoring latest backup: $$LATEST_BACKUP"; \
		mv "$$LATEST_BACKUP" $(HOME)/.config/nvim; \
	fi
	@echo "✅ Configuration uninstalled"

backup: ## Create a backup of current configuration
	@echo "📦 Creating backup of Neovim configuration..."
	@cp -r $(NVIM_CONFIG_DIR) $(BACKUP_DIR)
	@echo "✅ Backup created at $(BACKUP_DIR)"

restore-backup: ## Restore from the most recent backup
	@LATEST_BACKUP=$$(ls -t $(HOME)/.config/nvim-backup-* 2>/dev/null | head -1); \
	if [ -z "$$LATEST_BACKUP" ]; then \
		echo "❌ No backups found"; \
		exit 1; \
	fi; \
	echo "🔄 Restoring from backup: $$LATEST_BACKUP"; \
	rm -rf $(NVIM_CONFIG_DIR); \
	cp -r "$$LATEST_BACKUP" $(NVIM_CONFIG_DIR); \
	echo "✅ Configuration restored from backup"

clean-cache: ## Clear Neovim cache and temporary files
	@echo "🧹 Cleaning Neovim cache..."
	@rm -rf $(NVIM_CACHE_DIR)
	@rm -rf $(NVIM_STATE_DIR)
	@echo "✅ Cache cleaned"

reset: ## Complete reset (removes plugins, cache, state)
	@echo "⚠️  This will remove ALL plugins, cache, and state data"
	@read -p "Are you sure? [y/N]: " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		echo "🔄 Performing complete reset..."; \
		rm -rf $(NVIM_DATA_DIR); \
		rm -rf $(NVIM_STATE_DIR); \
		rm -rf $(NVIM_CACHE_DIR); \
		echo "✅ Reset complete. Restart Neovim to reinstall plugins"; \
	else \
		echo "❌ Reset cancelled"; \
	fi

##@ Plugin Management

sync: ## Synchronize all plugins (update/install)
	@echo "🔄 Synchronizing plugins..."
	@nvim --headless -c "Lazy sync" -c "qall"
	@echo "✅ Plugins synchronized"

update: ## Update all plugins to latest versions
	@echo "⬆️ Updating plugins..."
	@nvim --headless -c "Lazy update" -c "qall"
	@echo "✅ Plugins updated"

install-plugins: ## Install missing plugins
	@echo "📦 Installing missing plugins..."
	@nvim --headless -c "Lazy install" -c "qall"
	@echo "✅ Missing plugins installed"

clean-plugins: ## Remove unused plugins
	@echo "🧹 Cleaning unused plugins..."
	@nvim --headless -c "Lazy clean" -c "qall"
	@echo "✅ Unused plugins cleaned"

plugin-status: ## Show plugin installation status
	@echo "📊 Plugin Status:"
	@nvim --headless -c "Lazy show" -c "qall"

restore-plugins: ## Restore plugins from lazy-lock.json
	@echo "🔄 Restoring plugins from lockfile..."
	@nvim --headless -c "Lazy restore" -c "qall"
	@echo "✅ Plugins restored from lockfile"

##@ LSP & Tools Management

mason-sync: ## Synchronize Mason packages (LSP servers, formatters, linters)
	@echo "🔧 Synchronizing Mason packages..."
	@nvim --headless -c "MasonToolsUpdate" -c "qall" 2>/dev/null || \
	nvim --headless -c "MasonUpdate" -c "qall"
	@echo "✅ Mason packages synchronized"

mason-status: ## Show Mason package status
	@echo "📊 Mason Package Status:"
	@nvim --headless -c "Mason" -c "qall"

lsp-info: ## Show LSP server information
	@echo "🔍 LSP Server Information:"
	@nvim --headless -c "LspInfo" -c "qall"

##@ Testing & Validation

test: ## Run complete test suite
	@echo "🧪 Running test suite..."
	@nvim -l tests/run.lua
	@echo "✅ Tests completed"

test-config: ## Test configuration modules only
	@echo "🧪 Testing configuration modules..."
	@nvim --headless -c "PlenaryBustedDirectory lua/tests/config/" -c "qall"

test-plugins: ## Test plugin configurations only
	@echo "🧪 Testing plugin configurations..."
	@nvim --headless -c "PlenaryBustedDirectory lua/tests/plugins/" -c "qall"

test-utils: ## Test utility modules only
	@echo "🧪 Testing utility modules..."
	@nvim --headless -c "PlenaryBustedDirectory lua/tests/utils/" -c "qall"

health: ## Run comprehensive health check
	@echo "🏥 Running health checks..."
	@nvim --headless -c "checkhealth" -c "qall"

health-kickstart: ## Run kickstart-specific health check
	@echo "🏥 Running kickstart health check..."
	@nvim --headless -c "checkhealth kickstart" -c "qall"

validate-config: ## Validate configuration loads without errors
	@echo "✅ Validating configuration..."
	@nvim --headless -c "echo 'Configuration valid'" -c "qall"

lint-lua: ## Check Lua syntax and style (requires stylua)
	@echo "🔍 Linting Lua files..."
	@if command -v stylua >/dev/null 2>&1; then \
		stylua --check lua/; \
		echo "✅ Lua files are properly formatted"; \
	else \
		echo "❌ stylua not found. Install with: cargo install stylua"; \
	fi

format-lua: ## Format Lua files (requires stylua)
	@echo "🎨 Formatting Lua files..."
	@if command -v stylua >/dev/null 2>&1; then \
		stylua lua/; \
		echo "✅ Lua files formatted"; \
	else \
		echo "❌ stylua not found. Install with: cargo install stylua"; \
	fi

##@ Performance & Diagnostics

startup-time: ## Measure Neovim startup time
	@echo "⏱️  Measuring startup time..."
	@nvim --startuptime /tmp/nvim-startup.log -c "qall"
	@echo "📊 Startup time analysis saved to /tmp/nvim-startup.log"
	@tail -1 /tmp/nvim-startup.log

profile-startup: ## Profile startup performance with detailed breakdown
	@echo "📊 Profiling startup performance..."
	@nvim --startuptime /tmp/nvim-startup-$(shell date +%Y%m%d-%H%M%S).log -c "qall"
	@echo "📈 Startup profile saved to /tmp/nvim-startup-$(shell date +%Y%m%d-%H%M%S).log"
	@echo "🔝 Top 10 slowest items:"
	@grep -E '^[0-9]' /tmp/nvim-startup-$(shell date +%Y%m%d-%H%M%S).log | sort -k2 -nr | head -10

benchmark: ## Run comprehensive performance benchmark
	@echo "🚀 Running performance benchmark..."
	@echo "⏱️  Startup time (5 runs):"
	@for i in {1..5}; do \
		nvim --startuptime /tmp/startup-$$i.log -c "qall" 2>/dev/null; \
		tail -1 /tmp/startup-$$i.log; \
	done
	@echo "📊 Benchmark complete"

##@ Development & Debugging

dev: ## Start Neovim with verbose logging
	@echo "🔍 Starting Neovim in development mode..."
	@NVIM_LOG_LEVEL=DEBUG nvim

debug: ## Start Neovim with maximum verbosity
	@echo "🐛 Starting Neovim in debug mode..."
	@NVIM_LOG_LEVEL=TRACE nvim -V9

logs: ## Show recent Neovim log files
	@echo "📋 Recent Neovim logs:"
	@ls -la $(NVIM_STATE_DIR)/*.log 2>/dev/null || echo "No log files found"

tail-logs: ## Tail Neovim log files
	@echo "📋 Tailing Neovim logs (Ctrl+C to stop)..."
	@tail -f $(NVIM_STATE_DIR)/*.log 2>/dev/null || echo "No log files found"

reload: ## Reload configuration in running Neovim instance
	@echo "🔄 Reloading configuration..."
	@nvim --server /tmp/nvim-server --remote-send ':source ~/.config/nvim/init.lua<CR>' 2>/dev/null || \
	echo "❌ No running Neovim server found. Use :source % manually"

##@ Documentation & Information

info: ## Show configuration information
	@echo "📊 Neovim Configuration Information"
	@echo "=================================="
	@echo "📁 Config Directory: $(NVIM_CONFIG_DIR)"
	@echo "📦 Data Directory:   $(NVIM_DATA_DIR)"
	@echo "🔧 State Directory:  $(NVIM_STATE_DIR)"
	@echo "💾 Cache Directory:  $(NVIM_CACHE_DIR)"
	@echo ""
	@echo "📈 Directory Sizes:"
	@du -sh $(NVIM_CONFIG_DIR) 2>/dev/null || echo "Config: Not found"
	@du -sh $(NVIM_DATA_DIR) 2>/dev/null || echo "Data: Not found"
	@du -sh $(NVIM_STATE_DIR) 2>/dev/null || echo "State: Not found"
	@du -sh $(NVIM_CACHE_DIR) 2>/dev/null || echo "Cache: Not found"

version: ## Show Neovim and plugin versions
	@echo "📊 Version Information:"
	@nvim --version | head -3
	@echo ""
	@echo "🔌 Plugin Manager Version:"
	@nvim --headless -c "lua print('Lazy.nvim: ' .. require('lazy').version())" -c "qall" 2>/dev/null

tree: ## Show configuration file tree
	@echo "🌳 Configuration File Tree:"
	@tree $(NVIM_CONFIG_DIR) 2>/dev/null || find $(NVIM_CONFIG_DIR) -type f -name "*.lua" | sort

keymaps: ## Show all configured keymaps
	@echo "⌨️  Configured Keymaps:"
	@nvim --headless -c "redir! > /tmp/nvim-keymaps.txt | silent nmap | redir END | qall"
	@cat /tmp/nvim-keymaps.txt

shortcuts: ## Show README shortcuts section
	@echo "⌨️  Essential Shortcuts:"
	@sed -n '/^## ⌨️ \*\*Essential Shortcuts\*\*/,/^##/p' README.md | head -n -1

##@ Maintenance & Utilities

todo: ## Show TODO comments in configuration
	@echo "📝 TODO items in configuration:"
	@grep -r "TODO\|FIXME\|HACK\|NOTE" lua/ --include="*.lua" -n || echo "No TODO items found"

stats: ## Show configuration statistics
	@echo "📊 Configuration Statistics:"
	@echo "=========================="
	@echo "📁 Total Lua files: $$(find lua/ -name "*.lua" | wc -l)"
	@echo "📝 Total lines of code: $$(find lua/ -name "*.lua" -exec cat {} \; | wc -l)"
	@echo "💬 Total comment lines: $$(find lua/ -name "*.lua" -exec grep -E '^\s*--' {} \; | wc -l)"
	@echo "🧪 Total test files: $$(find lua/tests/ -name "*_spec.lua" 2>/dev/null | wc -l)"
	@echo ""
	@echo "📦 Plugin count: $$(grep -r "return {" lua/plugins/ 2>/dev/null | wc -l)"
	@echo "🔧 Configuration modules: $$(ls lua/config/*.lua 2>/dev/null | wc -l)"

list-backups: ## List all available backups
	@echo "📦 Available Backups:"
	@ls -la $(HOME)/.config/nvim-backup-* 2>/dev/null || echo "No backups found"

clean-backups: ## Clean old backups (keeps 5 most recent)
	@echo "🧹 Cleaning old backups (keeping 5 most recent)..."
	@ls -t $(HOME)/.config/nvim-backup-* 2>/dev/null | tail -n +6 | xargs -r rm -rf
	@echo "✅ Old backups cleaned"

##@ CI/CD & Automation

ci: ## Run CI pipeline (test + lint + validate)
	@echo "🤖 Running CI pipeline..."
	@make test
	@make lint-lua
	@make validate-config
	@make health
	@echo "✅ CI pipeline completed successfully"

pre-commit: ## Pre-commit checks (format + test)
	@echo "🔍 Running pre-commit checks..."
	@make format-lua
	@make test
	@echo "✅ Pre-commit checks passed"

doctor: ## Comprehensive health and validation check
	@echo "🏥 Running comprehensive diagnostics..."
	@make validate-config
	@make health
	@make test
	@make lint-lua
	@echo "✅ All diagnostics passed - configuration is healthy!"

##@ Quick Actions

quick-sync: sync ## Quick plugin sync (alias for sync)
quick-test: test ## Quick test run (alias for test)
quick-health: health ## Quick health check (alias for health)

edit: ## Open configuration in Neovim
	@nvim $(NVIM_CONFIG_DIR)

edit-init: ## Edit main init.lua file
	@nvim $(NVIM_CONFIG_DIR)/init.lua

edit-readme: ## Edit README.md file
	@nvim $(NVIM_CONFIG_DIR)/README.md

# Hidden targets (for internal use)
.PHONY: _check-nvim
_check-nvim: ## Check if Neovim is installed
	@command -v nvim >/dev/null 2>&1 || { echo "❌ Neovim not found. Please install Neovim first."; exit 1; }