_: {
  perSystem = {
    pkgs,
    inputs',
    self',
    ...
  }: let
    inherit (builtins) attrValues;
  in {
    packages.idris-lsp = pkgs.stdenv.mkDerivation (self: {
      pname = "idris2-lsp";
      version = "2022-11-27-unstable";

      nativeBuildInputs = attrValues {inherit (self'.packages) idris2;};
      buildInputs = attrValues {inherit (self'.packages) idris2;};

      src = self'.packages.idris-lsp-source;

      makeFlags = ["PREFIX=$(out)"];
      buildPhase = ''
        idris2 --version
        idris2 --list-packages
        make build
      '';
    });

    packages.idris-lsp-source = pkgs.fetchFromGitHub rec {
      name = "${owner}-${repo}-${rev}";
      owner = "idris-community";
      repo = "idris2-lsp";
      rev = "a2603b83124818eedca072269e8883cf8b7a3223";
      hash = "sha256-zVoo2YGv/96zF0W1mhODsZdkTS99FNEbTUQ6QMa5h98=";
      fetchSubmodules = true;
    };
  };
}
