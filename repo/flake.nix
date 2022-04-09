{
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-21.11;
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      nixpkgsFor = flake-utils.lib.eachSystem [ flake-utils.lib.system.x86_64-linux ] (system: { nixpkgs = import nixpkgs { inherit system; }; });
    in
    flake-utils.lib.eachSystem [ flake-utils.lib.system.x86_64-linux ] (system:
      let pkgs = nixpkgsFor.nixpkgs.${system}; in
      rec
      {
        packages = {
          ms-dotnettools.csharp = pkgs.callPackage ./ms-dotnettools.csharp { };
        };
      });
}
