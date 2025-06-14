{pkgs, ...}: {
  services.skhd = {
    enable = pkgs.stdenv.isDarwin;
    config = ''
      cmd - 1 : open -a "${pkgs.brave}/Applications/Brave Browser.app"

      cmd - 3 : open -a "${pkgs.slack}/Applications/Slack.app"
    '';
  };
}
