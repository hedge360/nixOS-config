{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #Packages built from source
    kwin-effects-better-blur-dx = {
      url = "github:xarblu/kwin-effects-better-blur-dx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, home-manager, kwin-effects-better-blur-dx, ... } @inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in
  {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs system; };

      modules = [
        ./configuration.nix
        {
          environment.systemPackages = [
            kwin-effects-better-blur-dx.packages.x86_64-linux.default
          ];
        }
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.rommelvj = import ./home.nix;
          };
        }
      ];
    };
  };
  };
}
