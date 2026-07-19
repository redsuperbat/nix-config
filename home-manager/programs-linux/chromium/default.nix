{...}: let
  # Helium is an ungoogled-chromium fork; its desktop entry is helium.desktop
  heliumDesktop = "helium.desktop";
in {
  # Make helium the default browser
  home.sessionVariables.BROWSER = "helium";

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = heliumDesktop;
      "x-scheme-handler/http" = heliumDesktop;
      "x-scheme-handler/https" = heliumDesktop;
      "x-scheme-handler/about" = heliumDesktop;
      "x-scheme-handler/unknown" = heliumDesktop;
    };
  };
}
