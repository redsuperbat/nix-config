{pkgs, ...}: {
  # source lua config from this repo
  xdg.configFile = {
    "ghostty/config" = {
      text = ''
        macos-titlebar-style = hidden
        macos-non-native-fullscreen = true
        fullscreen = true
        window-padding-y = 10,0
        command = ${pkgs.bash}/bin/bash -cl 'fish -c "tmux a"'
        font-family = JetBrains Mono
        font-family = Symbols Nerd Font Mono

        theme = Kanagawa Wave

        keybind = alt+shift+e=toggle_fullscreen
        keybind = alt+shift+r=reload_config
        keybind = global:unconsumed:alt+j=unbind
        keybind = global:unconsumed:alt+k=unbind
      '';
    };
  };
}
