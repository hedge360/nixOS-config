{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #REMEMBER
    #Pinning a package is as shown below:
    #nixpkgs.url = "github:nixos/nixpkgs/<commit-hash>";
    #<commit-hash> replaces nixos-unstable

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
    arm-system = "aarch64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in
  {
    nixosConfigurations = {
      inspiron13-nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };

        modules = [
          ./hosts/inspiron13/configuration.nix
          {
            environment.systemPackages = [
              kwin-effects-better-blur-dx.packages.${system}.default
            ];
          }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
	      backupFileExtension = "backup";
              users.rommelvj = import ./hosts/inspiron13/home.nix;
	      sharedModules = [
	        inputs.caelestia-shell.homeManagerModules.default
	      ];
	      extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };

      #rpi5-nixos = nixpkgs.lib.nixosSystem {
	#code
      #};
    };
  };
}
