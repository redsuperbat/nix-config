{configDir, ...}: {
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };
  home.sessionVariables.NH_FLAKE = "${configDir}/nix-config";
}
