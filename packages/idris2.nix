{lib, ...}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.idris2-bootstrap = pkgs.stdenv.mkDerivation (self: {
      pname = "idris2-bootstrap";
      version = "0.5.1";

      src = "${self'.packages.idris-lsp-source}/Idris2";

      strictDeps = true;

      nativeBuildInputs = builtins.attrValues {
        inherit (pkgs) makeWrapper clang chez;
      };
      buildInputs = builtins.attrValues {
        inherit (pkgs) chez gmp;
      };

      prePatch = ''
        patchShebangs --build tests
      '';

      makeFlags = ["PREFIX=$(out)"];

      # The name of the main executable of pkgs.chez is `scheme`
      buildFlags = ["bootstrap" "SCHEME=scheme"];

      checkTarget = "test";
      checkInputs = [pkgs.gambit pkgs.nodejs]; # racket ];
      checkFlags = ["INTERACTIVE="];

      # TODO: Move this into its own derivation, such that this can be changed
      #       without having to recompile idris2 every time.
      postInstall = let
        name = "idris2-${self.version}";
        globalLibraries = [
          "\\$HOME/.nix-profile/lib/${name}"
          "/run/current-system/sw/lib/${name}"
          "$out/${name}"
        ];
        globalLibrariesPath = builtins.concatStringsSep ":" globalLibraries;
      in ''
        # Remove existing idris2 wrapper that sets incorrect LD_LIBRARY_PATH
        rm $out/bin/idris2
        # The only thing we need from idris2_app is the actual binary
        mv $out/bin/idris2_app/idris2.so $out/bin/idris2
        rm $out/bin/idris2_app/*
        rmdir $out/bin/idris2_app
        # idris2 needs to find scheme at runtime to compile
        # idris2 installs packages with --install into the path given by
        #   IDRIS2_PREFIX. We set that to a default of ~/.idris2, to mirror the
        #   behaviour of the standard Makefile install.
        # TODO: Make support libraries their own derivation such that
        #       overriding LD_LIBRARY_PATH is unnecessary
        wrapProgram "$out/bin/idris2" \
          --set-default CHEZ "${pkgs.chez}/bin/scheme" \
          --run 'export IDRIS2_PREFIX=''${IDRIS2_PREFIX-"$HOME/.idris2"}' \
          --suffix IDRIS2_LIBS ':' "$out/${name}/lib" \
          --suffix IDRIS2_DATA ':' "$out/${name}/support" \
          --suffix IDRIS2_PACKAGE_PATH ':' "${globalLibrariesPath}" \
          --suffix DYLD_LIBRARY_PATH ':' "$out/${name}/lib" \
          --suffix LD_LIBRARY_PATH ':' "$out/${name}/lib"
      '';
    });

    packages.idris2 = pkgs.stdenv.mkDerivation {
      pname = "idris2";
      inherit (self'.packages.idris2-bootstrap) version src prePatch makeFlags checkInputs;

      nativeBuildInputs = [pkgs.makeWrapper self'.packages.idris2-bootstrap];
      buildInputs = [pkgs.gmp];

      buildFlags = ["all"];
      checkTarget = "test";

      postInstall =
        ''
          make install-with-src-libs PREFIX=$out
          HOME=$out make install-with-src-api

          mv $out/.idris2/idris2-0.5.1/* $out/idris2-0.5.1/
        ''
        + self'.packages.idris2-bootstrap.postInstall;
    };
  };
}
