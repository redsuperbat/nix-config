{
  userConfig,
  pkgs,
  ...
}: {
  imports =
    builtins.map (name: ../programs/${name}) (builtins.attrNames (builtins.readDir ../programs));

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
    claude-code # Vibin
    nur.repos.ryan4yin.gemini-cli
    codex

    # Desktop applications
    slack
    bitwarden-desktop
    raycast
  ];
}
