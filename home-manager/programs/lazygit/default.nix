{...}: {
  # Install lazygit via home-manager module
  programs.lazygit = {
    enable = true;

    settings = {
      promptToReturnFromSubprocess = false;
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --color-only --dark --paging=never";
        };
      };
    };
  };
}
