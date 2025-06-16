{userConfig, ...}: {
  programs.bat = {
    enable = true;
    config = {
      theme = userConfig.syntaxTheme;
      style = "numbers";
      color = "always";
    };
  };
}
