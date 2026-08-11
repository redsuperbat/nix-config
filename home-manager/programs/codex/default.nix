{
  config,
  configDir,
  ...
}: {
  home.file.".codex/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/nix-config/home-manager/programs/codex/config.toml";
}
