{pkgs, ...}: {
  xdg.desktopEntries.nmtui = {
    name = "nmtui";
    comment = "NetworkManager text user interface";
    icon = "network-wired";
    exec = "${pkgs.ghostty}/bin/ghostty --title=nmtui-wifi --config=fullscreen=false -e ${pkgs.networkmanager}/bin/nmtui";
    categories = ["System" "Network"];
    settings.Keywords = "wifi;network;wireless";
  };
}
