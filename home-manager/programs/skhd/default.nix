{pkgs, ...}: {
  services.skhd = {
    enable = true;
    config = ''
      cmd - 1 : open -a "${pkgs.brave}"

      cmd - 3 : open -a "${pkgs.slack}"
    '';
  };
}
