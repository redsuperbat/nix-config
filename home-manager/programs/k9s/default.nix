{...}: let
  skin = "kanagawa";
in {
  programs.k9s = {
    enable = true;
    settings.k9s.skin = skin;
    skins.${skin} = ./kanagawa-skin.yml;
  };
}
