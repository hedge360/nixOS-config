{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kwin-effects-better-blur-dx = {
      url = "github:xarblu/kwin-effects-better-blur-dx";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak/latest";
  };

  outputs = { self, nixpkgs, home-manager, kwin-effects-better-blur-dx, caelestia-shell, flatpaks, ... } @inputs:
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
	    backupFileExtension = "backup";
            users.rommelvj = import ./home.nix;
	    sharedModules = [
	        inputs.caelestia-shell.homeManagerModules.default
	    ];
          };
        }
      ];
    };
  };
  };
}
