{
  description = "Nix config for my machine";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    workmux = {
      url = "github:raine/workmux";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rustproof = {
      url = "github:redsuperbat/rustproof";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Keyboard-centric PostgreSQL table viewer for the terminal.
    tablezz = {
      url = "github:redsuperbat/tablezz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Workmux agent dashboard (TUI), bound to prefix+w in tmux.
    wm-dash = {
      url = "github:redsuperbat/wm-dash";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Pinned version for temp broken packages on unstable
    nixpkgs-pinned = {
      url = "github:NixOS/nixpkgs/a421ac6595024edcfbb1ef950a3712b89161c359";
    };

    # Helium browser. Provides `pkgs.helium` via its overlay on all platforms.
    # Pins its own nixpkgs since it ships a prebuilt binary and uses that
    # nixpkgs only for runtime libs, so we don't follow.
    helium-browser = {
      url = "github:schembriaiden/helium-browser-nix-flake";
    };

    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    codex = {
      url = "github:sadjow/codex-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      # Track the release branch matching the stable nixpkgs base above.
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      # Track the release branch matching the stable nixpkgs base above.
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    darwin,
    home-manager,
    nix-homebrew,
    rustproof,
    tablezz,
    wm-dash,
    nixpkgs-pinned,
    workmux,
    helium-browser,
    claude-code,
    codex,
    ...
  }: let
    users = {
      maxnetterberg = {
        email = "max.netterberg@gmail.com";
        fullName = "Max Netterberg";
        name = "maxnetterberg";
      };
      maxn = {
        email = "max.netterberg@gmail.com";
        fullName = "Max Netterberg";
        name = "maxn";
      };
    };

    # Overlays shared across both nix-darwin and NixOS
    overlays = [
      (final: prev: {
        direnv = prev.direnv.overrideAttrs {doCheck = false;};
      })
      claude-code.overlays.default
    ];

    # nixpkgs settings shared across both nix-darwin and NixOS hosts.
    # `system` differs per host so it is passed in.
    mkNixpkgsModule = system: {
      nixpkgs.hostPlatform = system;
      nixpkgs.config.allowUnfree = true;
      # bitwarden-desktop pulls electron 39.8.10, currently flagged EOL.
      nixpkgs.config.permittedInsecurePackages = ["electron-39.8.10"];
      nixpkgs.overlays = overlays ++ [helium-browser.overlays.default];
    };

    # Wiring for the home-manager module that is identical on both platforms.
    # `homeDir` differs (/Users on darwin, /home on linux) so it is passed in.
    # `platformDir` holds the platform-specific home-manager programs.
    # `flakeAttr` is this host's flake output, e.g. "darwinConfigurations.macbook-pro".
    mkHomeManager = {
      system,
      username,
      homeDir,
      platformDir,
      flakeAttr,
    }: let
      userConfig = users.${username};
      configDir = "${homeDir}/Config"; # Directory where configuration will be stored
      workspaceDir = "${homeDir}/Workspace"; # Directory where git repositories will be stored
      nixpkgsOpts = {
        # Allow paid packages to be installed, without a MIT license etc
        config.allowUnfree = true;
        inherit system;
      };
    in {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "bak";
      home-manager.users.${username}.imports = [./home-manager/common platformDir];
      home-manager.extraSpecialArgs = {
        pkgs-pinned = import nixpkgs-pinned nixpkgsOpts;
        inherit userConfig configDir workspaceDir self homeDir flakeAttr rustproof workmux codex tablezz wm-dash;
      };
    };

    mkDarwinConfiguration = {
      system,
      username,
      hostname,
    }: let
      userConfig = users.${username};
      homeDir = "/Users/${userConfig.name}";
    in
      darwin.lib.darwinSystem {
        system = system;
        specialArgs = {
          inherit userConfig homeDir;
        };
        modules = [
          (mkNixpkgsModule system)
          ./hosts/${hostname}
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              autoMigrate = true;
              user = username;
            };
            homebrew = {
              enable = true;
              casks = [
                "ghostty"
                # nixpkgs build is only ad-hoc signed and lives at a rotating
                # /nix/store path, which orphans the macOS screen-recording TCC
                # grant on every update. The cask is signed and lives at a stable
                # /Applications path, so screen-sharing permission persists.
                "helium-browser"
                "signal"
                "linear-linear"
                "pinta" # Photo editor
                "slack" # install from here to make slack not owned by root
                # nixpkgs build pins an LLVM-18 stdenv that fails against the
                # apple-sdk-26 / libc++ 21 headers, so install the cask instead.
                "bitwarden"
                "llama-app" # llama.cpp menu bar app; not in nixpkgs
              ];
            };
          }
          home-manager.darwinModules.home-manager
          (mkHomeManager {
            inherit system username homeDir;
            platformDir = ./home-manager/programs-darwin;
            flakeAttr = "darwinConfigurations.${hostname}";
          })
        ];
      };

    mkNixosConfiguration = {
      system,
      username,
      hostname,
    }: let
      userConfig = users.${username};
      homeDir = "/home/${userConfig.name}";
    in
      nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {
          inherit userConfig homeDir;
        };
        modules = [
          (mkNixpkgsModule system)
          ./hosts/${hostname}
          home-manager.nixosModules.home-manager
          (mkHomeManager {
            inherit system username homeDir;
            platformDir = ./home-manager/programs-linux;
            flakeAttr = "nixosConfigurations.${hostname}";
          })
        ];
      };
  in {
    darwinConfigurations = {
      macbook-pro = mkDarwinConfiguration {
        system = "aarch64-darwin";
        username = "maxnetterberg";
        hostname = "macbook-pro";
      };
    };

    nixosConfigurations = {
      nixos-desktop = mkNixosConfiguration {
        system = "x86_64-linux";
        username = "maxn";
        hostname = "nixos-desktop";
      };
    };
  };
}
