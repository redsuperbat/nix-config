{
  userConfig,
  pkgs,
  ...
}: let
  programs = builtins.map (name: ../programs/${name}) (builtins.attrNames (builtins.readDir ../programs));
  scripts = [../scripts];
in {
  # Import all programs
  imports = programs ++ scripts;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Home-Manager configuration for the user's home environment
  home = {
    username = "${userConfig.name}";
    homeDirectory = "/Users/${userConfig.name}";
    shell.enableFishIntegration = true;
    stateVersion = "25.05";
  };

  # Ensure common packages are installed
  home.packages = with pkgs; [
    biome
    black
    bottom
    cargo-nextest
    colima # Docker container runtime for macos
    curl
    deno
    dig
    docker
    eza
    fd
    ffmpeg
    fzf
    gh
    google-cloud-sdk
    jq
    yq
    kubectl
    lazydocker
    marksman
    moreutils # sponge etc
    ripgrep
    rustup
    terraform
    tmux-sessionizer
    tokei
    uv # Python package manager
    watch
    tdf # terminal pdf viewer
    ollama
    flutter

    # cli AI agents
    claude-code
    gemini-cli
    codex
    opencode

    # Desktop applications
    slack
    bitwarden-desktop
    raycast
  ];
}
