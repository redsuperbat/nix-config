{
  home.file.".gemini/settings.json" = {
    text = ''
      {
         "contextFileName": "AGENTS.md",
         "theme": "Default",
         "preferredEditor": "vim",
         "selectedAuthType": "oauth-personal",
         "usageStatisticsEnabled": false,
         "mcpServers": {
           "github": {
             "command": "docker",
             "args": [
               "run",
               "-i",
               "--rm",
               "-e",
               "GITHUB_PERSONAL_ACCESS_TOKEN",
               "ghcr.io/github/github-mcp-server"
             ],
             "env": {
               "GITHUB_PERSONAL_ACCESS_TOKEN": "$GITHUB_PAT"
             }
           }
         }
      }
    '';
  };
}
