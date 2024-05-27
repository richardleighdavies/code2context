# Define variables
SCRIPT_NAME=$(CURDIR)/source/code2context.sh
INSTALL_PATH=/usr/local/bin
SCRIPT_DEST=$(INSTALL_PATH)/code2context
BACKUP_SUFFIX=.bak
VERBOSE=false

# Default target
.DEFAULT_GOAL := help

# Help target to display usage information
help:
	@echo "Makefile for managing the installation of the code2context script"
	@echo ""
	@echo "Usage:"
	@echo "  make install    - Install the code2context script"
	@echo "  make uninstall  - Uninstall the code2context script"
	@echo "  make help       - Display this help message"
	@echo "  make verbose    - Enable verbose mode"
	@echo ""
	@echo "Variables:"
	@echo "  VERBOSE=true    - Enable verbose output (default: false)"

# Install target to move the script to the specified destination
install: check-sudo check-script ensure-install-dir
	@if [ -f "$(SCRIPT_DEST)" ]; then \
		echo "Existing installation found. Creating backup..."; \
		sudo mv $(SCRIPT_DEST) $(SCRIPT_DEST)$(BACKUP_SUFFIX); \
		[ $(VERBOSE) = true ] && echo "Backup created at $(SCRIPT_DEST)$(BACKUP_SUFFIX)"; \
	fi
	@echo "Installing $(SCRIPT_NAME) to $(SCRIPT_DEST)..."
	@sudo mv $(SCRIPT_NAME) $(SCRIPT_DEST)
	@[ $(VERBOSE) = true ] && echo "Installation complete."

# Uninstall target to remove the script from the specified destination
uninstall: check-sudo
	@echo "Uninstalling $(SCRIPT_DEST)..."
	@sudo rm -f $(SCRIPT_DEST)
	@[ $(VERBOSE) = true ] && echo "Uninstallation complete."

# Check if sudo is available
check-sudo:
	@command -v sudo > /dev/null 2>&1 || { echo >&2 "sudo is required but it's not installed. Aborting."; exit 1; }

# Check if the script file exists in the current directory
check-script:
	@test -f $(SCRIPT_NAME) || { echo "$(SCRIPT_NAME) not found. Aborting."; exit 1; }

# Ensure the install directory exists
ensure-install-dir:
	@if [ ! -d "$(INSTALL_PATH)" ]; then \
		echo "Creating install directory $(INSTALL_PATH)..."; \
		sudo mkdir -p $(INSTALL_PATH); \
		[ $(VERBOSE) = true ] && echo "Install directory created."; \
	fi

# Enable verbose mode
verbose:
	@$(MAKE) install VERBOSE=true

# Prevent make from considering these targets as files
.PHONY: help install uninstall check-sudo check-script ensure-install-dir verbose
