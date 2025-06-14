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

    mkDarwinConfiguration = system: username: hostname:
      darwin.lib.darwinSystem {
        system = system;
        specialArgs = {
          pkgs = import nixpkgs {
            system = system;
            # Allow unfree packages to be installed, without a MIT license etc
            config.allowUnfree = true;
          };
          userConfig = users.${username};
        };
        modules = [
          ./hosts/${hostname}
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
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
            home-manager.users.${username} = "${self}/home-manager/common";
            home-manager.extraSpecialArgs = {
              userConfig = users.${username};
              self = self;
              rustproof = rustproof.packages.${system}.default;
            };
          }
        ];
      };
  in {
    darwinConfigurations = {
      macbook-pro = mkDarwinConfiguration "aarch64-darwin" "maxnetterberg" "macbook-pro";
    };
  };
}
