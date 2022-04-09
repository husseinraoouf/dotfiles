{
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-21.11;
  inputs.nixpkgs-unstable.url = github:NixOS/nixpkgs/nixos-unstable;
  inputs.home-manager = {
    url = github:nix-community/home-manager/release-21.11;
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.repo = {
    url = "./repo";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, repo }:
    let
      system = "x86_64-linux";
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit repo; };
        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hussein = import ./home.nix;
            home-manager.extraSpecialArgs = { inherit repo; };
          }
        ];
      };
    };
}
