{pkgs, ...}: {
  xdg.desktopEntries.nmtui = {
    name = "nmtui";
    comment = "NetworkManager text user interface";
    settings.Keywords = "wifi;network;wireless;";
    exec = "${pkgs.networkmanager}/bin/nmtui";
    terminal = true;
    categories = ["System" "Network"];
  };
}
