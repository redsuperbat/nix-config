{pkgs, ...}: {
  # Set default manpage viewer to neovim
  home.sessionVariables.CHROME_EXECUTABLE = "${pkgs.brave}";
  programs.brave = {
    enable = true;
    extensions = [
      {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden
      {id = "gppongmhjkpfnbhagpmjfkannfbllamg";} # Wappalyzer
      {id = "fmkadmapgofadopljbjfkapdkoienihi";} # React developer tools
      {id = "khncfooichmfjbepaaaebmommgaepoid";} # Unhook youtube shorts
    ];
  };
}
