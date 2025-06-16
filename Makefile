# Variables (override these as needed)
HOSTNAME ?= macbook-pro
FLAKE ?= .\#$(HOSTNAME)
EXPERIMENTAL ?= --extra-experimental-features "nix-command flakes"

.PHONY: help install-nix install-nix-darwin flake-update flake-check bootstrap-mac darwin-rebuild

help:
	@echo "Available targets:"
	@echo "  bootstrap-mac        - Install Nix and nix-darwin sequentially"
	@echo "  darwin-rebuild       - Rebuild the nix-darwin configuration"
	@echo "  flake-check          - Check the flake for issues"
	@echo "  flake-update         - Update flake inputs"
	@echo "  install-nix          - Install the Nix package manager"
	@echo "  install-nix-darwin   - Install nix-darwin using flake $(FLAKE)"
	@echo "  uninstall-nix        - Uninstall the Nix package manager"

# Generate a ssh key if it does not exist
~/.ssh/id_ed25519:
	ssh-keygen -t ed25519 -f "$@"

install-nix:
	@echo "Installing Nix..."
	@sudo curl -fsSL https://install.determinate.systems/nix | sh -s -- install
	@echo "Nix installation complete."

install-nix-darwin: ~/.ssh/id_ed25519
	@echo "Installing nix-darwin..."
	@sudo nix run nix-darwin $(EXPERIMENTAL) -- switch --flake $(FLAKE)
	@echo "nix-darwin installation complete."

uninstall-nix:
	@echo "Uninstalling nix"
	@sudo /nix/nix-installer uninstall
	@echo "Nix uninstallation complete"

flake-update:
	@echo "Updating flake inputs..."
	@sudo nix flake update
	@echo "Flake update complete."

darwin-rebuild:
	@echo "Rebuilding darwin configuration..."
	@sudo darwin-rebuild switch --flake $(FLAKE)
	@echo "Darwin rebuild complete."

flake-check:
	@echo "Checking flake..."
	@sudo nix flake check
	@echo "Flake check complete."

bootstrap-mac: install-nix install-nix-darwin
