{pkgs, ...}: let
  # Move window focus, first dropping out of fullscreen if the active window
  # is fullscreen. Hyprland's movefocus won't exit fullscreen on its own in
  # 0.54 (neither movefocus_cycles_fullscreen=false nor on_focus_under_fullscreen
  # do it), so we explicitly clear the fullscreen state first.
  focusMove = pkgs.writeShellScript "hypr-focus-move" ''
    if [ "$(${pkgs.hyprland}/bin/hyprctl activewindow -j | ${pkgs.jq}/bin/jq -r .fullscreen)" != "0" ]; then
      ${pkgs.hyprland}/bin/hyprctl dispatch fullscreenstate 0 0
    fi
    ${pkgs.hyprland}/bin/hyprctl dispatch movefocus "$1"
  '';
in {
  # App launcher used by the keybinds below
  home.packages = with pkgs; [
    vicinae # Raycast-like launcher (apps, clipboard, calc, emoji, extensions)
    grim # screenshot
    slurp # region select for screenshots
    wl-clipboard # clipboard
    wireplumber # provides wpctl for the volume keybinds below
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
        "$mod, Return, fullscreen,"
        # Leading comma = no modifier. Without it Hyprland reads the key as the
        # modmask and the path as the dispatcher ("dispatcher does not exist").
        ", F7, exec, $term"
        ", F6, exec, $browser"
        ", F8, exec, $slack"
        "$mod, Q, killactive,"
        "CONTROL, Return, exec, $menu toggle"
        "$mod, F, fullscreen,"
        "$mod SHIFT, V, togglefloating,"
        # Ctrl+Shift+V pastes in terminals; GUI apps treat it as
        # paste-without-formatting, which still pastes.
        "$mod, V, sendshortcut, CTRL SHIFT, V, activewindow"
        # Vim-style window focus movement (exits fullscreen first; see focusMove)
        "$mod, H, exec, ${focusMove} l"
        "$mod, J, exec, ${focusMove} d"
        "$mod, K, exec, ${focusMove} u"
        "$mod, L, exec, ${focusMove} r"

        # Cycle through all windows on the workspace in layout order. (MRU
        # order via the hist flag only ping-pongs the two newest windows.)
        # The alterzorder bind (same combo = both run) raises the newly
        # focused window so floating windows don't stay buried.
        "$mod, Tab, cyclenext,"
        "$mod, Tab, alterzorder, top"
        "$mod SHIFT, Tab, cyclenext, prev"
        "$mod SHIFT, Tab, alterzorder, top"
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

      # Volume: bindel = repeats while held (e) and works when locked (l).
      # -l 1.0 caps the level at 100% so raising never overshoots.
      bindel = [
        ", XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];
      # Mute toggle: bindl = no repeat, still fires when locked.
      bindl = [
        ", XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
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
