{...}: {
  programs.lazygit = {
    enable = true;
    settings = {
      promptToReturnFromSubprocess = false;
      git.overrideGpg = true;
      git.pagers = [
        {pager = "delta --paging=never";}
      ];
    };
  };
}
