{...}: let
  # nixpkgs ships chromium's desktop entry as chromium-browser.desktop
  chromiumDesktop = "chromium-browser.desktop";
in {
  # NOTE: extensions are NOT set here. home-manager's programs.chromium.extensions
  # is broken on Linux (Chromium only force-installs from system-managed policy
  # dirs). They are configured at the system level in hosts/nixos-desktop.
  programs.chromium.enable = true;

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
