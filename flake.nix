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
      imports = [./devpart.nix ./lspart.nix ./packages/idris2.nix];
      systems = ["x86_64-linux"];
    };
}
