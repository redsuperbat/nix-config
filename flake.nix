{
  description = "Nix config for my machine";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

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
  }: let
    users = {
      maxnetterberg = {
        email = "max.netterberg@gmail.com";
        fullName = "Max Netterberg";
        name = "maxnetterberg";
      };
    };

    mkHomeConfiguration = system: username: hostname:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {system = system;};
        specialArgs = {
          userConfig = users.${username};
        };
        modules = [
          ./home/${username}/${hostname}
        ];
      };

    mkDarwinConfiguration = system: username: hostname:
      darwin.lib.darwinSystem {
        system = system;
        specialArgs = {
          pkgs = import nixpkgs {system = system;};
          userConfig = users.${username};
        };
        modules = [
          ./hosts/${hostname}
          home-manager.darwinModules.home-manager
        ];
      };
  in {
    darwinConfigurations = {
      macbook-pro = mkDarwinConfiguration "aarch64-darwin" "maxnetterberg" "macbook-pro";
    };
    homeConfigurations = {
      "maxnetterberg@macbook-pro" = mkHomeConfiguration "aarch64-darwin" "maxnetterberg" "macbook-pro";
    };
  };
}
