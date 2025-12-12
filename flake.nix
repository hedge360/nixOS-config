{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #home-manager = {
    #  url = "github:nix-community/home-manager";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #Packages built from source
    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, home-manager, kwin-effects-forceblur, ... } @inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        {
          environment.systemPackages = [
            kwin-effects-forceblur.packages.x86_64-linux.default
          ];
        }
        #home-manager.nixosModules.home-manager
        #{
        #  home-manager.useGlobalPkgs = true;
        #  home-maneger.useUserPackages = true;
        #  home-manager.users.rommelvj = import ./home-manager.nix;
        #}
      ];
    };
  };
}
