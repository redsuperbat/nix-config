{...}: {
  # Install lazygit via home-manager module
  programs.lazygit = {
    enable = true;

    settings = {
      promptToReturnFromSubprocess = false;
      git.paging.pager = "delta --paging=never";
    };
  };
}
