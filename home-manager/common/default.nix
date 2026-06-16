{
  userConfig,
  pkgs,
  pkgs-unstable,
  lib,
  helium,
  homeDir,
  isDarwin,
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
  platform = builtins.map (name: platformDir + "/${name}") (builtins.attrNames (builtins.readDir platformDir));

  scripts = [../scripts];
in {
  # Import all programs (shared + platform-specific). The helium home-manager
  # module is only needed by the darwin-only helium program.
  imports = shared ++ platform ++ scripts ++ lib.optionals isDarwin [helium.homeModules.helium];

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
      deno
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
      terraform
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
      claude-code
      codex
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
      ghostty # installed via homebrew on macOS, from nixpkgs on linux
      slack # installed via homebrew on macOS, from nixpkgs on linux
      # Installed via homebrew cask on macOS: the nixpkgs build pins an LLVM-18
      # stdenv that fails to compile against the apple-sdk-26 / libc++ 21 headers.
      bitwarden-desktop
      # browser: chromium is configured in programs-linux/chromium
    ];
}
