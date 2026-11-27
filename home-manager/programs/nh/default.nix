{
  configDir,
  flakeAttr,
  config,
  lib,
  pkgs,
  ...
}: {
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };
  # Workaround for two home-manager bugs on darwin (fixed on master, not in release-26.05):
  # extraArgs is passed as ONE argument, and launchd's PATH has no `nix`.
  # TODO: remove both overrides after moving to a release that has the fix.
  launchd.agents.nh-clean.config.EnvironmentVariables.PATH = lib.mkIf pkgs.stdenv.isDarwin "/nix/var/nix/profiles/default/bin:/usr/bin:/bin";
  launchd.agents.nh-clean.config.ProgramArguments = lib.mkIf pkgs.stdenv.isDarwin (lib.mkForce [
    (lib.getExe config.programs.nh.package)
    "clean"
    "user"
    "--keep-since"
    "4d"
    "--keep"
    "3"
  ]);
  # Flake path for nh to work
  home.sessionVariables.NH_FLAKE = "${configDir}/nix-config#${flakeAttr}";
}
