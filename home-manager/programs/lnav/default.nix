{pkgs, ...}: {
  home.packages = with pkgs; [lnav];
  # Taken from: https://neovim.discourse.group/t/more-structured-lsp-log/3914/2
  home.file.".lnav/formats/installed/nvim-lsp.json".source = ./nvim-lsp-format.json;
  home.file.".lnav/configs/installed/kanagawa.json".source = ./kanagawa-color-theme.json;
  home.file.".lnav/formats/local/config.theme.json".text = ''
    {
      "ui": {
        "theme": "kanagawa"
      }
    }
  '';
}
