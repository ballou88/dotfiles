{
  description = "Mike's Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

  };

  outputs = inputs@{ 
    self,
    nix-darwin,
    nixpkgs,
    nix-homebrew
    }: let
    username = "robertballou";
    system = "aarch64-darwin";
    hostname = "Roberts-MacBook-Pro";

    specialArgs =
      inputs
      // {
          inherit username hostname;
        };
  in {
# Build darwin flake using:
# $ darwin-rebuild build --flake .#Roberts-MacBook-Pro
    darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
      inherit system specialArgs;
      modules = [ 
      ./modules/nix-core.nix
      ./modules/system.nix
      ./modules/apps.nix
      ./modules/host-user.nix
    #   configuration
    #   nix-homebrew.darwinModules.nix-homebrew
    #     {
    #       nix-homebrew = {
    #         # Install Homebrew under the default prefix
    #         enable = true;
    #
    #         # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
    #         enableRosetta = true;
    #
    #         # User owning the Homebrew prefix
    #         user = "robertballou";
    #
    #         # Automatically migrate existing Homebrew installations
    #         autoMigrate = true;
    #       };
    #     }
      ];
    };
# nix code formatter
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
