{
  description = "Nix config for my machine";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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

    helium = {
      url = "gitlab:ntgn/helium-flake";
      inputs.nixpkgs.follows = "nixpkgs";
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
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
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
    nixpkgs-pinned,
    workmux,
    helium,
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
      })
      claude-code.overlays.default
    ];

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
        # Passed explicitly (not derived from pkgs.stdenv) so it can be used in
        # `imports` without triggering infinite recursion.
        isDarwin = nixpkgs.lib.hasSuffix "darwin" system;
        inherit userConfig configDir workspaceDir self homeDir hostname rustproof workmux helium himalaya-tui himalaya;
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
          {
            nixpkgs.hostPlatform = system;
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = overlays;
          }
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
          {
            nixpkgs.hostPlatform = system;
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = overlays;
          }
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
