{...}: {
  programs.gemini-cli = {
    enable = true;
    settings = {
      contextFileName = "AGENTS.md";
      theme = "Default";
      preferredEditor = "vim";
      selectedAuthType = "oauth-personal";
      usageStatisticsEnabled = false;
    };
  };
}
