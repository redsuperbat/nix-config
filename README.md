# Nix-darwin Configurations for My Machine

## Fresh install

Install nix from determinite systems:

```sh
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

select `no` when it propmts you for a determinite install, we want to manage our nix installation ourselves.

Install nix darwin and all macos settings with this command:

```sh
sudo nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#macbook-pro
```

## Update configuration after install

run:

```sh
sudo darwin-rebuild switch --flake <path-to-flake>#macbook-pro
```
