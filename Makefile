# Variables (override these as needed)
HOSTNAME ?= macbook-pro
FLAKE ?= .#$(HOSTNAME)
EXPERIMENTAL ?= --extra-experimental-features "nix-command flakes"

.PHONY: help install-nix install-nix-darwin flake-update flake-check bootstrap-mac

help:
	@echo "Available targets:"
	@echo "  install-nix          - Install the Nix package manager"
	@echo "  install-nix-darwin   - Install nix-darwin using flake $(FLAKE)"
	@echo "  flake-update         - Update flake inputs"
	@echo "  flake-check          - Check the flake for issues"
	@echo "  bootstrap-mac        - Install Nix and nix-darwin sequentially"

install-nix:
	@echo "Installing Nix..."
	@sudo curl -fsSL https://install.determinate.systems/nix | sh -s -- install
	@echo "Nix installation complete."

install-nix-darwin:
	@echo "Installing nix-darwin..."
	@sudo nix run nix-darwin $(EXPERIMENTAL) -- switch --flake $(FLAKE)
	@echo "nix-darwin installation complete."

flake-update:
	@echo "Updating flake inputs..."
	@nix flake update
	@echo "Flake update complete."

flake-check:
	@echo "Checking flake..."
	@nix flake check
	@echo "Flake check complete."

bootstrap-mac: install-nix install-nix-darwin
