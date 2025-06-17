{pkgs, ...}: {
  # Tmux terminal multiplexer configuration
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
    shortcut = "a";
    historyLimit = 5000;
    newSession = true;
    keyMode = "vi";
    mouse = true;
    terminal = "screen-256color";
    shell = "${pkgs.fish}/bin/fish";
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-capture-pane-contents 'on'"; # allow tmux-resurrect to capture pane contents
      }
      {
        plugin = continuum;
        extraConfig = "set -g @continuum-restore 'on'"; # enable tmux-continuum functionality
      }
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor "macchiato"
          set -g @catppuccin_status_background "none"
          set -g @catppuccin_window_status_style "none"
          set -g @catppuccin_pane_status_enabled "off"
          set -g @catppuccin_pane_border_status "off"
        '';
      }
      battery
    ];

    extraConfig = ''
      set -g allow-passthrough on                                                        # To render images in tmux panes

      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"  # Source config with <prefix>+r
      bind s popup -h 85% -w 85% -E "tms switch"                                         # Switch between sessions
      bind w popup -h 85% -w 85% -E "tms windows"                                        # Switch between windows
      bind F popup -E "tms"                                                              # Run tms to add new session
      bind G popup -E "github_tms"                                                       # Run function similar to tms but for github
      bind K run-shell "tms kill"                                                        # Kill current
      bind C-k respawn-pane -k                                                           # Restart current pane
      bind W command-prompt -p "Rename active session to: " "run-shell 'tms rename %1'". # Rename sessions
      bind v copy-mode                                                                   # Enter copy mode
      bind / copy-mode \; send C-r                                                       # Enter copy mode and start search
      bind -T copy-mode-vi v send -X begin-selection                                     # Bind 'v' in copy mode to begin selection (like Vim)
      bind -T copy-mode-vi y send -X copy-pipe-and-cancel "pbcopy"                       # bind y to copy into pbcopy
      bind -T copy-mode-vi Escape send -X cancel                                         # Escape takes you out of copy mode
      bind -r j resize-pane -D 5
      bind -r k resize-pane -U 5
      bind -r l resize-pane -R 5
      bind -r h resize-pane -L 5

      set -g renumber-windows on # renumber all windows when any window is closed
      set -g status-position top # macOS / darwin style

      set -g @thm_bg "#1f1f28"
      set -g popup-style "bg=#1f1f28"

      # Status left look and feel
      set -g status-left-length 100
      set -g status-left ""
      set -ga status-left "#{?client_prefix,#{#[bg=#{@thm_red},fg=#{@thm_bg},bold]  #S },#{#[bg=#{@thm_bg},fg=#{@thm_green}]  #S }}"
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]│"
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_maroon}]  #{pane_current_command} "
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]#{?window_zoomed_flag,│,}"
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_yellow}]#{?window_zoomed_flag,   ,}"
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]│"
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none] "

      # Status right look and feel
      set -g status-right-length 100
      set -g status-right "#[bg=#{@thm_bg},fg=#{@thm_mauve}, none] #(fish -c 'git branch --show-current | string shorten -m 50') "
      set -ga status-right "#[bg=#{@thm_bg},fg=#{@thm_overlay_0}, none]│"
      set -ga status-right "#[bg=#{@thm_bg},fg=#{@thm_blue}, none] 󱃾 #(kubectl config current-context) "
      set -ga status-right "#[bg=#{@thm_bg},fg=#{@thm_overlay_0}, none]│"
      set -ga status-right "#{?#{e|>=:10,#{battery_percentage}},#{#[bg=#{@thm_red},fg=#{@thm_bg}]},#{#[bg=#{@thm_bg},fg=#{@thm_pink}]}} #{battery_icon} #{battery_percentage} "
      set -ga status-right "#[bg=#{@thm_bg},fg=#{@thm_overlay_0}, none]│"
      set -ga status-right "#[bg=#{@thm_bg},fg=#{@thm_yellow}] 󰭦 %Y-%m-%d 󰅐 %H:%M "

      set -g mouse on # Allows scrolling in windows

      # Set new panes to open in current directory
      bind c new-window -c "#{pane_current_path}"
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      # Configure Tmux
      set -g status-position top
      set -g status-style "bg=#{@thm_bg}"
      set -g status-justify "left"

      # Pane border look and feel
      setw -g pane-border-status top
      setw -g pane-border-format ""
      setw -g pane-active-border-style "bg=#{@thm_bg},fg=#{@thm_overlay_0}"
      setw -g pane-border-style "bg=#{@thm_bg},fg=#{@thm_surface_0}"
      setw -g pane-border-lines single

      # Window look and feel
      set -wg automatic-rename on
      set -g automatic-rename-format "Window"

      set -g window-status-format " #I#{?#{!=:#{window_name},Window},: #W,} "
      set -g window-status-style "bg=#{@thm_bg},fg=#{@thm_rosewater}"
      set -g window-status-last-style "bg=#{@thm_bg},fg=#{@thm_peach}"
      set -g window-status-activity-style "bg=#{@thm_red},fg=#{@thm_bg}"
      set -g window-status-bell-style "bg=#{@thm_red},fg=#{@thm_bg},bold"
      set -gF window-status-separator "#[bg=#{@thm_bg},fg=#{@thm_overlay_0}]│"

      set -g window-status-current-format " #I#{?#{!=:#{window_name},Window},: #W,} "
      set -g window-status-current-style "bg=#{@thm_peach},fg=#{@thm_bg},bold"

      run-shell ${pkgs.tmuxPlugins.battery}/share/tmux-plugins/battery/battery.tmux # run this at the end because nix
    '';
  };
}
