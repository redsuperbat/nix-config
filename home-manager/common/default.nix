{
  userConfig,
  pkgs,
  ...
}: {
  imports =
    builtins.map (name: ../programs/${name}) (builtins.attrNames (builtins.readDir ../programs));

  nixpkgs.config.allowUnfree = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Home-Manager configuration for the user's home environment
  home = {
    username = "${userConfig.name}";
    homeDirectory = "/Users/${userConfig.name}";
    shell.enableFishIntegration = true;
    stateVersion = "25.05";
  };

  home.sessionVariables = {
    # Set default manpage viewer to neovim
    MANPAGER = "nvim +Man!";
  };
  # Ensure common packages are installed
  home.packages = with pkgs; [
    bat
    biome
    black
    bottom
    cargo-nextest
    curl
    deno
    dig
    eza
    fd
    ffmpeg
    fzf
    gh
    jq
    kubectl
    lazydocker
    marksman
    ncspot # Spotify for the terminal
    pylint
    ripgrep
    shfmt
    moreutils # sponge etc
    tmux
    tmux-sessionizer
    uv # Python package manager
    watch
    terraform

    # Desktop applications
    slack
    bitwarden-desktop
    docker
    raycast
  ];
}
