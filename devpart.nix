_: let
  inherit (builtins) attrValues;
in {
  perSystem = {
    self',
    pkgs,
    inputs',
    ...
  }: {
    formatter = inputs'.nobbz.formatter;

    devShells.default = pkgs.mkShell {
      packages = attrValues {
        inherit (inputs'.nobbz.packages) nil alejandra;
        inherit (self'.packages) idris-lsp idris2;
      };
    };
  };
}
