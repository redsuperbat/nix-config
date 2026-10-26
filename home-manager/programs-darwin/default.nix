{pkgs, ...}: {
  imports = map (name: ./${name}) (builtins.attrNames (removeAttrs (builtins.readDir ./.) ["default.nix"]));

  home.packages = with pkgs; [
    colima # Docker container runtime for macos
    coreutils-prefixed # GNU coreutils with a 'g' prefix
    xcodes
    cocoapods
    raycast
  ];
}
