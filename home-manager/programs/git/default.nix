{userConfig, ...}: {
  # Install git via home-manager module
  programs.git = {
    enable = true;
    settings = {
      user = {
        email = userConfig.email;
        name = userConfig.fullName;
      };
      pull.rebase = "true";
    };
    signing = {
      format = "ssh";
      signByDefault = true;
      key = "~/.ssh/id_ed25519.pub";
    };
  };
}
