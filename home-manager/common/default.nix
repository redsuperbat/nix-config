{
  userConfig,
  pkgs,
  lib,
  homeDir,
  codex,
  tablezz,
  wm-dash,
  ...
}: let
  # Shared programs are imported on every platform. Platform-specific programs
  # (programs-darwin / programs-linux) are imported by the flake.
  shared = builtins.map (name: ../programs/${name}) (builtins.attrNames (builtins.readDir ../programs));

  scripts = [../scripts];
in {
  imports = shared ++ scripts;

  # Home-Manager configuration for the user's home environment
  home = {
    username = "${userConfig.name}";
    homeDirectory = homeDir;
    shell.enableFishIntegration = true;
    stateVersion = "25.05";
  };

  # Ensure common packages are installed
  home.packages = with pkgs; [
    biome
    black
    bottom
    cargo-nextest
    curl
    dig
    docker
    eza
    fd
    ffmpeg
    fzf
    gh
    glow # terminal markdown renderer
    google-cloud-sdk
    gws
    jq
    yq
    kubectl
    kubelogin
    lazydocker
    marksman
    moreutils # sponge etc
    ripgrep
    rsync
    tokei # Count lines of code
    uv # Python package manager
    viddy # Better watch
    tdf # terminal pdf viewer
    sd # Better sed
    presenterm # terminal based slideshow tool

    tree
    llm # cli tool for any language model
    dive # cli tool for viewing docker images

    ollama
    flutter

    # cli AI agents
    # claude wrapped so node.js is on PATH inside claude-code sessions
    (symlinkJoin {
      name = "claude-code-with-node";
      paths = [claude-code];
      nativeBuildInputs = [makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/claude \
          --prefix PATH : ${lib.makeBinPath [nodejs]}
      '';
    })
    codex.packages.${pkgs.system}.default

    tablezz.packages.${pkgs.system}.default # postgres table viewer
    wm-dash.packages.${pkgs.system}.default # workmux agent dashboard
  ];
}
