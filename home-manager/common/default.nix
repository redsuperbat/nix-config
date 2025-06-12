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
    actionlint
    alejandra
    bat
    biome
    black
    bottom
    cargo-nextest
    curl
    deno
    dig
    eslint_d
    eza
    fd
    ffmpeg
    delta
    fish
    fzf
    gh
    hadolint # Dockerfile linter
    jq
    kubectl
    lazydocker
    marksman
    ncspot # Spotify for the terminal
    pylint
    ripgrep
    shfmt
    moreutils # sponge etc
    sqlfluff
    stylua
    taplo # Toml toolkit
    terraform
    tmux
    tmux-sessionizer
    uv # Python package manager
    watch

    # Language servers
    lua-language-server
    rust-analyzer
    tailwindcss-language-server
    typescript-language-server
    vscode-langservers-extracted
    vue-language-server
    ruby-lsp
    gopls
    dockerfile-language-server-nodejs

    # Desktop applications
    slack
    bitwarden-desktop
    docker
    raycast
  ];
}
