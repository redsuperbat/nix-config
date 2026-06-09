{
  config,
  pkgs,
  configDir,
  himalaya-tui,
  himalaya,
  ...
}: {
  home.packages = [
    himalaya-tui.packages.${pkgs.system}.default
    himalaya.packages.${pkgs.system}.default # himalaya CLI (v2 / 2.0.0-alpha)
  ];

  # Load the committed theme config first, then deep-merge a per-machine
  # account file on top. account.toml lives outside the repo and holds the
  # account + credentials
  home.sessionVariables.HIMALAYA_CONFIG = "${config.xdg.configHome}/himalaya/config.toml:${config.xdg.configHome}/himalaya/account.toml";

  xdg.configFile."himalaya/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/nix-config/home-manager/programs/himalaya/config.toml";
}
