{lib, ...}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: let
    idris2 = self'.legacyPackages.callPackages ./idris2 {};
  in {
    packages.idris2-bootstrap = idris2.bootstrap;
    packages.idris2 = idris2.ready;

    legacyPackages.buildIdris = idris2.buildPackage;
    legacyPackages.buildIdrisLib = idris2.buildLibrary;
  };
}
