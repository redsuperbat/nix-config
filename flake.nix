{
  description = "Nix config for my machine";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    workmux.url = "github:raine/workmux";

    rustproof.url = "github:redsuperbat/rustproof";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    # Pinned version for temp broken packages on unstable
    nixpkgs-pinned = {
      url = "github:NixOS/nixpkgs/a421ac6595024edcfbb1ef950a3712b89161c359";
    };

    # claude-code 2.1.88 was unpublished from npm, pin to nixpkgs with 2.1.86
    nixpkgs-claude-code.url = "github:NixOS/nixpkgs/8110df5ad7abf5d4c0f6fb0f8f978390e77f9685";

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
    nixpkgs,
    nix-homebrew,
    rustproof,
    nixpkgs-pinned,
    nixpkgs-claude-code,
    workmux,
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
        hostPlatform.system = system;
      };
    in
      darwin.lib.darwinSystem {
        system = system;
        specialArgs = {
          pkgs = import nixpkgs nixpkgsOpts;
          inherit userConfig homeDir;
        };
        modules = [
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
              pkgs-claude-code = import nixpkgs-claude-code nixpkgsOpts;
              inherit userConfig configDir workspaceDir self homeDir hostname rustproof workmux;
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
