# Battery segment in the tmux status bar. Only the laptop has a battery.
{
  pkgs,
  lib,
  ...
}: {
  programs.tmux.plugins = [pkgs.tmuxPlugins.battery];
  programs.tmux.extraConfig = lib.mkAfter ''
    set -ga status-right "#[bg=#{@thm_bg},fg=#{@thm_overlay_0}, none]│"
    set -ga status-right "#{?#{e|>=:10,#{battery_percentage}},#{#[bg=#{@thm_red},fg=#{@thm_bg}]},#{#[bg=#{@thm_bg},fg=#{@thm_pink}]}} #{battery_icon} #{battery_percentage} "
    run-shell ${pkgs.tmuxPlugins.battery}/share/tmux-plugins/battery/battery.tmux # run after status-right is set, so it can fill in the placeholders
  '';
}
