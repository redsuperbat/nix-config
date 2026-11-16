{
  pkgs,
  tinycast,
  ...
}: {
  imports =
    [tinycast.homeManagerModules.default]
    ++ map (name: ./${name}) (builtins.attrNames (removeAttrs (builtins.readDir ./.) ["default.nix"]));

  # Launcher; the module also turns off Tinycast's built-in updater.
  programs.tinycast = {
    enable = true;
    launcherShortcut = "ctrl+return";
    launchAtLogin = true;
  };

  home.packages = with pkgs; [
    colima # Docker container runtime for macos
    coreutils-prefixed # GNU coreutils with a 'g' prefix
    xcodes
    cocoapods
  ];
}
