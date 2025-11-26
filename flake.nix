{
  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs/cb82756ecc37fa623f8cf3e88854f9bf7f64af93";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #change to nixos-unstable once fcitx5 build issue has been fixed
    #home-manager = {
    #  url = "github:nix-community/home-manager";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

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
