{pkgs, ...}: {
  programs.bat = {
    enable = true;
    themes = {
      kanagawa = {
        src = pkgs.fetchFromGitHub {
          owner = "rebelot";
          repo = "kanagawa.nvim";
          rev = "debe91547d7fb1eef34ce26a5106f277fbfdd109";
          sha256 = "sha256-i54hTf4AEFTiJb+j5llC5+Xvepj43DiNJSq0vPZCIAg=";
        };
        file = "extras/tmTheme/kanagawa.tmTheme";
      };
    };
    config = {
      theme = "kanagawa";
      style = "numbers";
      color = "always";
    };
  };
}
