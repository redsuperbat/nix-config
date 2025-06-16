# Nix configuration for reproducible work machines

## Fresh install

```sh
make bootstrap-mac
```

select `no` when it prompts you for a determinate install, we want to manage our nix installation ourselves.

## Update configuration after install

```sh
make darwin-rebuild
```
