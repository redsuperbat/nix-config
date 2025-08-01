{
  description = "Nix config for my machine";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    rustproof = {
      url = "github:redsuperbat/rustproof";
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
    nixpkgs,
    nix-homebrew,
    rustproof,
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
    in
      darwin.lib.darwinSystem {
        system = system;
        specialArgs = {
          pkgs = import nixpkgs {
            system = system;
            # Allow paid packages to be installed, without a MIT license etc
            config.allowUnfree = true;
          };
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
                "linear-linear"
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
              rustproof = rustproof.packages.${system}.default;
              inherit userConfig configDir workspaceDir self homeDir hostname;
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
