{pkgs, ...}: {
  services.skhd = {
    enable = pkgs.stdenv.isDarwin;
    # Some programs are installed with homebrew and therefore we cannot reference them through the store
    config = ''
      f6 : open -a "~/Applications/Home Manager Apps/Helium.app"
      f7 : open -a "/Applications/Ghostty.app"
      f8 : open -a "/Applications/Slack.app"
    '';
  };
}
