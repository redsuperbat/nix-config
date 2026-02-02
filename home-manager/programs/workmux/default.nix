{
  workmux,
  pkgs,
  ...
}: {
  home.packages = [workmux.packages.${pkgs.system}.default];

  xdg.configFile."workmux/config.yaml".text = ''
    nerdfont: true
    merge_strategy: rebase
    agent: claude
    panes:
      - command: <agent>
        focus: true
      - split: horizontal
  '';
}
