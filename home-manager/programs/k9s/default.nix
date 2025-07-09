{...}: let
  skin = "kanagawa";
in {
  programs.k9s = {
    enable = true;
    settings.k9s.skin = skin;
    settings.k9s.logger.textWrap = true;
    skins.${skin} = ./kanagawa-skin.yml;
  };
}
