{pkgs, ...}: {
  # App launcher used by the keybinds below
  home.packages = with pkgs; [
    fuzzel # wayland application launcher
    grim # screenshot
    slurp # region select for screenshots
    wl-clipboard # clipboard
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      "$term" = "ghostty";

      # Mirrors the macOS skhd workflow (f6 browser / f7 terminal / f8 slack)
      bind = [
        "$mod, Return, exec, $term"
        "F7, exec, $term"
        "F6, exec, chromium"
        "F8, exec, slack"
        "$mod, Q, killactive,"
        "CONTROL, Return, exec, fuzzel"
        "$mod, F, fullscreen,"
        "$mod, V, togglefloating,"
        "$mod, J, movefocus, l"
        "$mod, K, movefocus, r"
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"

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
