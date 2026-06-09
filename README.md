# Nix Configuration for Reproducible Work Machines

Supports both macOS (via [nix-darwin](https://github.com/LnL7/nix-darwin)) and
NixOS, sharing a single home-manager configuration.

- macOS host: `darwinConfigurations.macbook-pro` (`aarch64-darwin`)
- NixOS host: `nixosConfigurations.nixos-desktop` (`x86_64-linux`, Hyprland)

## macOS

### Fresh install

```sh
make bootstrap-mac
```

select `no` when it prompts you for a determinate install, we want to manage our nix installation ourselves.

### Update configuration after install

```sh
make darwin-rebuild
```

## NixOS

### Fresh install

1. Install NixOS normally and clone this repo to `~/Config/nix-config`.
2. Replace `hosts/nixos-desktop/hardware-configuration.nix` with the machine's
   real hardware config:

   ```sh
   nixos-generate-config --show-hardware-config > hosts/nixos-desktop/hardware-configuration.nix
   ```

3. Build and switch:

   ```sh
   make nixos-rebuild
   ```

### Update configuration after install

```sh
make nixos-rebuild
```

## Layout

- `home-manager/programs/` — cross-platform program modules (imported everywhere)
- `home-manager/programs-darwin/` — macOS-only modules (`skhd`, `helium`)
- `home-manager/programs-linux/` — Linux-only modules (`hyprland`)
- `home-manager/common/` — picks the right platform dir and guards packages by platform
