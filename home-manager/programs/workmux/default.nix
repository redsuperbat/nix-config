{
  workmux,
  pkgs,
  config,
  configDir,
  ...
}: {
  home.packages = [workmux.packages.${pkgs.stdenv.hostPlatform.system}.default];

  xdg.configFile."workmux/config.yaml".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/nix-config/home-manager/programs/workmux/config.yaml";
}
