{pkgs, ...}: {
  # App launcher used by the keybinds below
  home.packages = with pkgs; [
    vicinae # Raycast-like launcher (apps, clipboard, calc, emoji, extensions)
    grim # screenshot
    slurp # region select for screenshots
    wl-clipboard # clipboard
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      # Absolute store paths: Hyprland's exec runs via /bin/sh and the session
      # (launched by tuigreet, not a login shell) does not have the user
      # profile on PATH, so bare command names are not found.
      "$term" = "${pkgs.ghostty}/bin/ghostty";
      "$browser" = "${pkgs.chromium}/bin/chromium";
      "$slack" = "${pkgs.slack}/bin/slack";
      "$menu" = "${pkgs.vicinae}/bin/vicinae";

      # Start the Vicinae daemon with the session (omit if you switch to uwsm).
      "exec-once" = ["${pkgs.vicinae}/bin/vicinae server"];

      # Mirrors the macOS skhd workflow (f6 browser / f7 terminal / f8 slack)
      bind = [
        "$mod, Return, exec, $term"
        # Leading comma = no modifier. Without it Hyprland reads the key as the
        # modmask and the path as the dispatcher ("dispatcher does not exist").
        ", F7, exec, $term"
        ", F6, exec, $browser"
        ", F8, exec, $slack"
        "$mod, Q, killactive,"
        "CONTROL, Return, exec, $menu toggle"
        "$mod, F, fullscreen,"
        "$mod, V, togglefloating,"
        "$mod, J, movefocus, l"
        "$mod, K, movefocus, r"
        ", Print, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy"

        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
      ];

      # Move/resize windows with the mouse + $mod
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
      };

      decoration = {
        rounding = 6;
      };

      input = {
        kb_options = "caps:escape"; # match macOS remapCapsLockToEscape
        repeat_delay = 200;
        repeat_rate = 60;
      };
    };
  };
}
