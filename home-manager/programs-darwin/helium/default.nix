{pkgs, ...}: {
  home.packages = [pkgs.helium];

  # Disable the "hold ⌘Q to quit" confirmation in Helium (Chromium-based).
  targets.darwin.defaults."net.imput.helium" = {
    ConfirmToQuitEnabled = false;
  };
}
