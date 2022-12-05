{
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
  inputs.nobbz.url = "github:nobbz/nixos-config";
  inputs.parts.url = "github:hercules-ci/flake-parts";

  outputs = {
    self,
    nixpkgs,
    nobbz,
    parts,
  }:
    parts.lib.mkFlake {inherit self;} {
      imports = [./devpart.nix ./packages];
      systems = ["x86_64-linux"];

      perSystem = {
        pkgs,
        self',
        ...
      }: {
        legacyPackages.callPackages = pkgs.lib.callPackagesWith (pkgs // {inherit (self'.packages) idris2-bootstrap idris2 idris2-lsp idris-lsp-source;});
        legacyPackages.callPackage = pkgs.lib.callPackageWith (pkgs // {inherit (self'.packages) idris2-bootstrap idris2 idris2-lsp idris-lsp-source;});
      };
    };
}
