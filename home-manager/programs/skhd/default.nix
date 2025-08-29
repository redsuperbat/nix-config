{pkgs, ...}: {
  services.skhd = {
    enable = pkgs.stdenv.isDarwin;
    # Since Ghostty is currently installed with hombrew we cannot reference it
    # through the store
    config = ''
      f1 : open -a "${pkgs.brave}/Applications/Brave Browser.app"
      f2 : open -a "/Applications/Ghostty.app"
      f3 : open -a "${pkgs.slack}/Applications/Slack.app"
    '';
  };
}
