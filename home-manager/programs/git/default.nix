{userConfig, ...}: {
  # Install git via home-manager module
  programs.git = {
    enable = true;
    userName = userConfig.fullName;
    userEmail = userConfig.email;
    delta = {
      enable = true;
      settings = {
        syntax-theme = userConfig.syntaxTheme;
      };
    };
    signing = {
      format = "ssh";
      signByDefault = true;
      key = "~/.ssh/id_ed25519.pub";
    };
    extraConfig = {
      pull.rebase = "true";
    };
  };
}
