{pkgs, ...}: {
  # Raycast-like launcher (apps, clipboard, calc, emoji, extensions). Hyprland
  # starts the server and binds the toggle (see ../hyprland).
  home.packages = [pkgs.vicinae];

  # Vicinae's built-in "Log out" uses logind TerminateSession. That SIGTERMs
  # start-hyprland, which aborts (hyprwm/Hyprland discussion #15531) and leaves
  # SDDM on a black screen. Hide it and log out via hyprshutdown instead, which
  # makes Hyprland exit by itself. Vicinae's GUI can't save settings while
  # this file is managed here.
  xdg.configFile."vicinae/settings.json" = {
    force = true;
    text = builtins.toJSON {
      providers.power.entrypoints.logout.enabled = false;
    };
  };

  # logout.svg is Vicinae's built-in logout glyph (src/server/icons/logout.svg)
  # on a red tile, mimicking its red background tint, which script icons can't set.
  xdg.dataFile."vicinae/scripts/logout.sh" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      # @vicinae.schemaVersion 1
      # @vicinae.title Log Out
      # @vicinae.description Close all apps and log out of Hyprland
      # @vicinae.packageName Power Management
      # @vicinae.icon ${./logout.svg}
      # @vicinae.keywords ["logout", "sign out", "exit", "hyprshutdown"]
      # @vicinae.needsConfirmation true
      # @vicinae.mode silent
      # @vicinae.exec ["${pkgs.bash}/bin/bash"]
      exec ${pkgs.hyprshutdown}/bin/hyprshutdown
    '';
  };
}
