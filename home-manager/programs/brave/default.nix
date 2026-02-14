{pkgs, ...}: {
  home.sessionVariables.CHROME_EXECUTABLE = "${pkgs.brave}/bin/brave";
  programs.brave = {
    enable = true;
    extensions = [
      {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden
      {id = "gppongmhjkpfnbhagpmjfkannfbllamg";} # Wappalyzer
      {id = "fmkadmapgofadopljbjfkapdkoienihi";} # React developer tools
      {id = "khncfooichmfjbepaaaebmommgaepoid";} # Unhook youtube shorts
      {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} # Vimium
    ];
  };
}
