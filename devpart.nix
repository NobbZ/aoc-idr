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

      IDRIS2_PACKAGE_PATH = builtins.concatStringsSep ":" (let inherit (self'.packages.idris2) pname version; name = "${pname}-${version}"; in [
          "\\$HOME/.nix-profile/lib/${name}"
          "/run/current-system/sw/lib/${name}"
          "${self'.packages.idris2}/${name}"
        ]);
    };
  };
}
