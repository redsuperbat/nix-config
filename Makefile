# Variables (override these as needed)
HOSTNAME ?= macbook-pro
NIXOS_HOSTNAME ?= nixos-desktop
FLAKE ?= .\#$(HOSTNAME)
SSH_KEY ?= ~/.ssh/id_ed25519

.PHONY: help install-nix install-nix-darwin flake-update flake-check bootstrap-mac darwin-rebuild nixos-rebuild test clean all

help:
	@echo "Available targets:"
	@echo "  bootstrap-mac        - Install Nix and nix-darwin sequentially"
	@echo "  flake-update         - Update flake inputs"
	@echo "  install-nix          - Install the Nix package manager"
	@echo "  install-nix-darwin   - Install nix-darwin using flake $(FLAKE)"
	@echo "  darwin-rebuild       - Rebuild and switch the macOS configuration"
	@echo "  nixos-rebuild        - Rebuild and switch the NixOS configuration"


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

darwin-rebuild:
	@echo "Rebuilding macOS configuration for $(HOSTNAME)..."
	@sudo darwin-rebuild switch --flake .#$(HOSTNAME)

nixos-rebuild:
	@echo "Rebuilding NixOS configuration for $(NIXOS_HOSTNAME)..."
	@sudo nixos-rebuild switch --flake .#$(NIXOS_HOSTNAME)

flake-update:
	@echo "Updating flake inputs..."
	@sudo nix flake update
	@echo "Flake update complete."

bootstrap-mac: install-nix install-nix-darwin
