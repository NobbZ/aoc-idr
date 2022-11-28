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
      rev = "dc7d3e5dc2ba0951014729fb32001ac30534f769";
      hash = "sha256-HhpnuzjlBRE+/QlOgYslaOTqtVp8zwvjtGJvUQX0Gd0=";
      fetchSubmodules = true;
    };
  };
}
