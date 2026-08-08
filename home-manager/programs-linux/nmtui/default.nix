{pkgs, ...}: {
  xdg.desktopEntries.nmtui = {
    name = "nmtui";
    comment = "NetworkManager text user interface";
    icon = "network-wired";
    exec = "${pkgs.ghostty}/bin/ghostty -e ${pkgs.networkmanager}/bin/nmtui";
    categories = ["System" "Network"];
    settings.Keywords = "wifi;network;wireless";
  };
}

