{...}: {
  programs.brave = {
    enable = true;
    extensions = [
      {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden
      {id = "gppongmhjkpfnbhagpmjfkannfbllamg";} # Wappalyzer
      {id = "fmkadmapgofadopljbjfkapdkoienihi";} # React developer tools
    ];
  };
}
