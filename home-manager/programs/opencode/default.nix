{
  config,
  configDir,
  opencode,
  pkgs,
  ...
}: {
  programs.opencode.enable = true;
  programs.opencode.package = opencode.packages.${pkgs.stdenv.hostPlatform.system}.opencode;
  xdg.configFile."opencode/config.json".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/nix-config/home-manager/programs/opencode/opencode-config.json";
  xdg.configFile."opencode/tui.json".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/nix-config/home-manager/programs/opencode/opencode-tui.json";
  xdg.configFile."opencode/skill".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/nix-config/home-manager/programs/opencode/skills";
  xdg.configFile."opencode/command".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/nix-config/home-manager/programs/opencode/commands";
}
