# Variables (override these as needed)
HOSTNAME ?= macbook-pro
FLAKE ?= .\#$(HOSTNAME)
SSH_KEY ?= ~/.ssh/id_ed25519

.PHONY: help install-nix install-nix-darwin flake-update flake-check bootstrap-mac darwin-rebuild test clean all

help:
	@echo "Available targets:"
	@echo "  bootstrap-mac        - Install Nix and nix-darwin sequentially"
	@echo "  flake-update         - Update flake inputs"
	@echo "  install-nix          - Install the Nix package manager"
	@echo "  install-nix-darwin   - Install nix-darwin using flake $(FLAKE)"


$(SSH_KEY):
	@ssh-keygen -t ed25519 -f "$@"

install-nix:
	@echo "Installing Nix..."
	@sudo curl -fsSL https://install.determinate.systems/nix | sh -s -- install
	@echo "Nix installation complete."

install-nix-darwin: $(SSH_KEY)
	@echo "Installing nix-darwin..."
	@sudo nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake $(FLAKE)
	@echo "nix-darwin installation complete."

flake-update:
	@echo "Updating flake inputs..."
	@sudo nix flake update
	@echo "Flake update complete."

bootstrap-mac: install-nix install-nix-darwin
