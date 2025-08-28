{pkgs, ...}: {
  services.skhd = {
    enable = pkgs.stdenv.isDarwin;
    # Since Ghostty is currently installed with hombrew we cannot reference it
    # through the store
    config = ''
      cmd - j : open -a "${pkgs.brave}/Applications/Brave Browser.app"
      cmd - k : open -a "/Applications/Ghostty.app"
      cmd - l : open -a "${pkgs.slack}/Applications/Slack.app"
    '';
  };
}
