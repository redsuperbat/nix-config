{
  config,
  pkgs,
  configDir,
  himalaya-tui,
  ...
}: {
  home.packages = [himalaya-tui.packages.${pkgs.system}.default];

  # Out-of-store symlink so the Kanagawa-themed config can be edited live
  # without a rebuild. himalaya-tui loads $XDG_CONFIG_HOME/himalaya/config.toml.
  xdg.configFile."himalaya/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/nix-config/home-manager/programs/himalaya/config.toml";
}
