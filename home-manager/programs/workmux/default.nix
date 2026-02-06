{
  workmux,
  pkgs,
  ...
}: {
  home.packages = [workmux.packages.${pkgs.system}.default];

  xdg.configFile."workmux/config.yaml".text = ''
    post_create:
      - direnv allow
    nerdfont: true
    merge_strategy: rebase
    agent: claude --dangerously-skip-permissions
    panes:
      - command: <agent>
        focus: true
        split: horizontal
  '';
}
