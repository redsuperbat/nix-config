{
  description = "Nix config for my machine";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # Unstable channel - cherry-picked for packages we want newer than stable ships
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    workmux = {
      url = "github:raine/workmux";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rustproof = {
      url = "github:redsuperbat/rustproof";
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

    # Email TUI. Pins its own nixpkgs (until a crates.io fix is backported),
    # so we intentionally do not override its nixpkgs input here.
    himalaya-tui = {
      url = "github:pimalaya/himalaya-tui";
    };

    # Email CLI (v2, 2.0.0-alpha). Same config format as himalaya-tui; pins
    # its own nixpkgs for the same reason, so no follows override here.
    himalaya = {
      url = "github:pimalaya/himalaya";
    };

    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      # Track the release branch matching the stable nixpkgs base above.
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      # Track the release branch matching the stable nixpkgs base above.
      url = "github:LnL7/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    darwin,
    home-manager,
    nix-homebrew,
    rustproof,
    nixpkgs-pinned,
    workmux,
    helium-browser,
    himalaya-tui,
    himalaya,
    claude-code,
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
        # home-manager's release-26.05 tip ships a programs.antigravity-cli
        # module whose default package isn't backported to nixos-26.05 yet. HM
        # forces every module's package default during assertion evaluation, so
        # provide it from unstable to keep the config evaluating. Eval-only —
        # nothing builds unless the module is actually enabled.
        antigravity-cli =
          (import nixpkgs-unstable {
            inherit (prev) config;
            system = prev.stdenv.hostPlatform.system;
          })
          .antigravity-cli;
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
    mkHomeManager = {
      system,
      username,
      homeDir,
      hostname,
    }: let
      userConfig = users.${username};
      configDir = "${homeDir}/Config"; # Directory where configuration will be stored
      workspaceDir = "${homeDir}/Workspace"; # Directory where git repositories will be stored
      nixpkgsOpts = {
        # Allow paid packages to be installed, without a MIT license etc
        config.allowUnfree = true;
        system = system;
      };
    in {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "bak";
      home-manager.users.${username} = ./home-manager/common;
      home-manager.extraSpecialArgs = {
        pkgs-pinned = import nixpkgs-pinned nixpkgsOpts;
        pkgs-unstable = import nixpkgs-unstable nixpkgsOpts;
        # Passed explicitly (not derived from pkgs.stdenv) so it can be used in
        # `imports` without triggering infinite recursion.
        isDarwin = nixpkgs.lib.hasSuffix "darwin" system;
        inherit userConfig configDir workspaceDir self homeDir hostname rustproof workmux himalaya-tui himalaya;
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
                "signal"
                "linear-linear"
                "pinta" # Photo editor
                "slack" # install from here to make slack not owned by root
                # nixpkgs build pins an LLVM-18 stdenv that fails against the
                # apple-sdk-26 / libc++ 21 headers, so install the cask instead.
                "bitwarden"
              ];
            };
          }
          home-manager.darwinModules.home-manager
          (mkHomeManager {inherit system username homeDir hostname;})
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
          (mkHomeManager {inherit system username homeDir hostname;})
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
