{userConfig, ...}: {
  # Install git via home-manager module
  programs.git = {
    enable = true;
    userName = userConfig.fullName;
    userEmail = userConfig.email;
    signing = {
      format = "ssh";
      signByDefault = true;
    };
    extraConfig = {
      pull.rebase = "true";
    };
  };
}
