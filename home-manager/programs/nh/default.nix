{
  configDir,
  hostname,
  ...
}: {
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };
  # Flake path for nh to work
  home.sessionVariables.NH_FLAKE = "${configDir}/nix-config#darwinConfigurations.${hostname}";
}
