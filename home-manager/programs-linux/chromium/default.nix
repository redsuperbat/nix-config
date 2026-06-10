{...}: let
  # nixpkgs ships chromium's desktop entry as chromium-browser.desktop
  chromiumDesktop = "chromium-browser.desktop";
in {
  programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
    ];
  };

  # Make chromium the default browser
  home.sessionVariables.BROWSER = "chromium";

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = chromiumDesktop;
      "x-scheme-handler/http" = chromiumDesktop;
      "x-scheme-handler/https" = chromiumDesktop;
      "x-scheme-handler/about" = chromiumDesktop;
      "x-scheme-handler/unknown" = chromiumDesktop;
    };
  };
}
