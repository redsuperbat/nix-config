{pkgs, ...}: {
  xdg.configFile."ghostty/config".text = ''
    macos-option-as-alt = false
    macos-titlebar-style = hidden
    macos-non-native-fullscreen = true
    fullscreen = true
    window-padding-y = 10,0
    command = ${pkgs.bash}/bin/bash -cl 'fish -c "tmux a"'
    font-family = JetBrains Mono
    font-family = Symbols Nerd Font Mono
    theme = Kanagawa Wave
    keybind = cmd+d=ignore
    keybind = cmd+shift+d=ignore
  '';
}
