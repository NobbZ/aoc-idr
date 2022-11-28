_: let
  inherit (builtins) attrValues;
in {
  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    formatter = inputs'.nobbz.formatter;

    devShells.default = pkgs.mkShell {
      packages = attrValues {
        inherit (inputs'.nobbz.packages) nil alejandra;
        inherit (pkgs) idris2;
      };
    };
  };
}
