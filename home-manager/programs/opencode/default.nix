{
  config,
  configDir,
  ...
}: {
  programs.opencode.enable = true;
  xdg.configFile."opencode/config.json".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/nix-config/home-manager/programs/opencode/opencode-config.json";
  xdg.configFile."opencode/tui.json".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/nix-config/home-manager/programs/opencode/opencode-tui.json";
}
