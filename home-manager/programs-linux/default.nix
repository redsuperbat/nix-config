{pkgs, ...}: {
  imports = map (name: ./${name}) (builtins.attrNames (removeAttrs (builtins.readDir ./.) ["default.nix"]));
  home.packages = with pkgs; [
    discord
    ghostty
    slack
    # Installed via homebrew cask on macOS: the nixpkgs build pins an LLVM-18
    # stdenv that fails to compile against the apple-sdk-26 / libc++ 21 headers.
    bitwarden-desktop
  ];
}
