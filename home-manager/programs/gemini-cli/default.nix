{
  config,
  configDir,
  ...
}: {
  programs.gemini-cli.enable = true;

  home.file.".gemini/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/nix-config/home-manager/programs/gemini-cli/settings.json";
}
