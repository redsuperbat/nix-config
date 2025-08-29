{pkgs, ...}: {
  services.skhd = {
    enable = pkgs.stdenv.isDarwin;
    # Since Ghostty is currently installed with hombrew we cannot reference it
    # through the store
    config = ''
      f6 : open -a "${pkgs.brave}/Applications/Brave Browser.app"
      f7 : open -a "/Applications/Ghostty.app"
      f8 : open -a "${pkgs.slack}/Applications/Slack.app"
    '';
  };
}
