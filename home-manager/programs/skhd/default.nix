{pkgs, ...}: {
  services.skhd = {
    enable = pkgs.stdenv.isDarwin;
    # Since Ghostty is currently installed with hombrew we cannot reference it
    # through the store
    config = ''
      cmd - 1 : open -a "${pkgs.brave}/Applications/Brave Browser.app"
      cmd - 2 : open -a "/Applications/Ghostty.app"
      cmd - 3 : open -a "${pkgs.slack}/Applications/Slack.app"
    '';
  };
}
