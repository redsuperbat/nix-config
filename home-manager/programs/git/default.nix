{userConfig, ...}: {
  # Install git via home-manager module
  programs.git = {
    enable = true;
    userName = userConfig.fullName;
    userEmail = userConfig.email;
    delta = {
      enable = true;
      options = {
        color-only = true;
        dark = true;
        syntax-theme = "kanagawa";
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
