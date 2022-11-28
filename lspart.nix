_: {
  perSystem = {
    pkgs,
    inputs',
    self',
    ...
  }: let
    inherit (builtins) attrValues;
  in {
    # packages.idris2 = pkgs.idris2.overrideAttrs (oa: let
    #   version = "0.5.1";
    # in {
    #   inherit version;
    #   src = "${src}/Idris2";
    #   postInstall = let
    #     platformChez =
    #       if pkgs.stdenv.system == "x86_64-linux"
    #       then pkgs.chez
    #       else pkgs.chez-racket;
    #     name = "${oa.pname}-${version}";
    #     globalLibraries = [
    #       "\\$HOME/.nix-profile/lib/${name}"
    #       "/run/current-system/sw/lib/${name}"
    #       "$out/${name}"
    #     ];
    #     globalLibrariesPath = builtins.concatStringsSep ":" globalLibraries;
    #   in ''
    #     make install-with-src-libs
    #     echo $(pwd)
    #     # PATH=$(pwd)/build/exec:$PATH make install-with-src-api
    #     # Remove existing idris2 wrapper that sets incorrect LD_LIBRARY_PATH
    #     rm $out/bin/idris2
    #     # The only thing we need from idris2_app is the actual binary
    #     mv $out/bin/idris2_app/idris2.so $out/bin/idris2
    #     rm $out/bin/idris2_app/*
    #     rmdir $out/bin/idris2_app
    #     # idris2 needs to find scheme at runtime to compile
    #     # idris2 installs packages with --install into the path given by
    #     #   IDRIS2_PREFIX. We set that to a default of ~/.idris2, to mirror the
    #     #   behaviour of the standard Makefile install.
    #     # TODO: Make support libraries their own derivation such that
    #     #       overriding LD_LIBRARY_PATH is unnecessary
    #     wrapProgram "$out/bin/idris2" \
    #       --set-default CHEZ "${platformChez}/bin/scheme" \
    #       --run 'export IDRIS2_PREFIX=''${IDRIS2_PREFIX-"$HOME/.idris2"}' \
    #       --suffix IDRIS2_LIBS ':' "$out/${name}/lib" \
    #       --suffix IDRIS2_DATA ':' "$out/${name}/support" \
    #       --suffix IDRIS2_PACKAGE_PATH ':' "${globalLibrariesPath}" \
    #       --suffix DYLD_LIBRARY_PATH ':' "$out/${name}/lib" \
    #       --suffix LD_LIBRARY_PATH ':' "$out/${name}/lib"
    #   '';
    # });
    packages.idris-lsp = pkgs.stdenv.mkDerivation (self: {
      pname = "idris2-lsp";
      version = "2022-11-27-unstable";

      nativeBuildInputs = attrValues {inherit (self'.packages) idris2;};
      buildInputs = attrValues {inherit (self'.packages) idris2;};

      src = self'.packages.idris-lsp-source;

      # phases = ["buildPhase" "installPhase"];
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
