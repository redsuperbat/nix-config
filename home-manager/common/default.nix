{
  userConfig,
  pkgs,
  lib,
  homeDir,
  isDarwin,
  codex-cli-nix,
  tablezz,
  ...
}: let
  isLinux = !isDarwin;

  # Shared programs are imported on every platform.
  shared = builtins.map (name: ../programs/${name}) (builtins.attrNames (builtins.readDir ../programs));

  # Platform-specific programs live in programs-darwin / programs-linux and are
  # only imported on the matching platform.
  platformDir =
    if isDarwin
    then ../programs-darwin
    else ../programs-linux;
  platform =
    if builtins.pathExists platformDir
    then builtins.map (name: platformDir + "/${name}") (builtins.attrNames (builtins.readDir platformDir))
    else [];

  scripts = [../scripts];
in {
  # Import all programs (shared + platform-specific).
  imports = shared ++ platform ++ scripts;

  # Home-Manager configuration for the user's home environment
  home = {
    username = "${userConfig.name}";
    homeDirectory = homeDir;
    shell.enableFishIntegration = true;
    stateVersion = "25.05";
  };

  # Ensure common packages are installed
  home.packages = with pkgs;
    [
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
      tmux-sessionizer
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
      codex-cli-nix.packages.${pkgs.system}.default

      tablezz.packages.${pkgs.system}.default # postgres table viewer
    ]
    ++ lib.optionals isDarwin [
      colima # Docker container runtime for macos
      coreutils-prefixed # GNU coreutils with a 'g' prefix
      # mac specfic apps
      xcodes
      cocoapods
      raycast
    ]
    ++ lib.optionals isLinux [
      discord
      ghostty # installed via homebrew on macOS, from nixpkgs on linux
      slack # installed via homebrew on macOS, from nixpkgs on linux
      # Installed via homebrew cask on macOS: the nixpkgs build pins an LLVM-18
      # stdenv that fails to compile against the apple-sdk-26 / libc++ 21 headers.
      bitwarden-desktop
    ];
}
