{...}: {
  # Install lazygit via home-manager module
  programs.lazygit = {
    enable = true;

    settings = {
      promptToReturnFromSubprocess = false;
    };
  };
}
