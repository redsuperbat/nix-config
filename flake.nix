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

    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pinned version for temp broken packages on unstable
    nixpkgs-pinned = {
      url = "github:NixOS/nixpkgs/a421ac6595024edcfbb1ef950a3712b89161c359";
    };

    helium = {
      url = "gitlab:ntgn/helium-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pinned to v2.1.87 (last released version before #42670 alt-screen scrollback regression;
    # 2.1.88 was skipped by Anthropic, regression landed in 2.1.89).
    # Bump when upstream ships a fix for #42670 / #55826.
    claude-code = {
      url = "github:sadjow/claude-code-nix?ref=v2.1.87";
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
    darwin,
    home-manager,
    nix-homebrew,
    rustproof,
    nixpkgs-pinned,
    workmux,
    helium,
    claude-code,
    ...
  }: let
    users = {
      maxnetterberg = {
        email = "max.netterberg@gmail.com";
        fullName = "Max Netterberg";
        name = "maxnetterberg";
      };
    };

    mkDarwinConfiguration = {
      system,
      username,
      hostname,
    }: let
      userConfig = users.${username};
      homeDir = "/Users/${userConfig.name}";
      configDir = "${homeDir}/Config"; # Directory where configuration will be stored
      workspaceDir = "${homeDir}/Workspace"; # Directory where git repositories will be stored
      nixpkgsOpts = {
        # Allow paid packages to be installed, without a MIT license etc
        config.allowUnfree = true;
        system = system;
      };
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
            nixpkgs.overlays = [
              (final: prev: {
                direnv = prev.direnv.overrideAttrs {doCheck = false;};
              })
              claude-code.overlays.default
            ];
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
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
            home-manager.users.${username} = ./home-manager/common;
            home-manager.extraSpecialArgs = {
              pkgs-pinned = import nixpkgs-pinned nixpkgsOpts;
              inherit userConfig configDir workspaceDir self homeDir hostname rustproof workmux helium;
            };
          }
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
  };
}
