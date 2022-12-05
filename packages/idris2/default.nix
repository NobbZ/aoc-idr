{
  lib,
  stdenv,
  runCommand,
  idris-lsp-source,
  idris2-bootstrap,
  idris2,
  makeWrapper,
  clang,
  chez,
  gmp,
  gambit,
  nodejs,
  withSource ? false,
  idris2Inputs ? [],
}: let
  bootstrap = stdenv.mkDerivation (self: {
    pname = "idris2-bootstrap-unwrapped";
    version = "0.5.1";

    src = "${idris-lsp-source}/Idris2";

    strictDeps = true;

    nativeBuildInputs = [makeWrapper clang chez];
    buildInputs = [chez gmp];

    prePatch = ''
      patchShebangs --build tests
    '';

    makeFlags = ["PREFIX=$(out)"];

    # The name of the main executable of pkgs.chez is `scheme`
    buildFlags = ["bootstrap" "SCHEME=scheme"];

    checkTarget = "test";
    checkInputs = [gambit nodejs]; # racket ];
    checkFlags = ["INTERACTIVE="];

    postInstall = ''
      # Remove existing idris2 wrapper that sets incorrect LD_LIBRARY_PATH
      rm $out/bin/idris2
    '';

    passthru = {
      inherit chez;
      idrisName = "idris2-${self.version}";
    };
  });

  ready = stdenv.mkDerivation (self: {
    pname = "idris2-unwrapped";
    inherit (bootstrap) version src prePatch makeFlags checkInputs;

    nativeBuildInputs = [makeWrapper idris2-bootstrap];
    buildInputs = [gmp];

    buildFlags = ["all"];
    checkTarget = "test";

    postInstall = let
      libTarget =
        if withSource
        then "install-with-src-libs"
        else "install-libs";
      apiTarget =
        if withSource
        then "install-with-src-api"
        else "install-api";
    in
      ''
        make ${libTarget} PREFIX=$out
        HOME=$out make ${apiTarget}

        mv $out/.idris2/${self.passthru.idrisName}/* $out/${self.passthru.idrisName}/
      ''
      + bootstrap.postInstall;

    passthru = {
      inherit (bootstrap) chez idrisName;
    };
  });

  wrap = drv: let
    pname = lib.strings.removeSuffix "-unwrapped" drv.pname;
    inherit (drv) version idrisName;

    globalLibraries =
      (builtins.map (input: "${input}/${idrisName}") idris2Inputs)
      ++ [
        "\\$HOME/.nix-profile/lib/${idrisName}"
        "/run/current-system/sw/lib/${idrisName}"
        "${drv}/${idrisName}"
      ];
    globalLibrariesPath = builtins.concatStringsSep ":" globalLibraries;
  in
    runCommand "${pname}-${version}" {
      inherit pname version;
      inherit (drv) passthru;
      nativeBuildInputs = [makeWrapper];
    } ''
      # The only thing we need from idris2_app is the actual binary
      # idris2 needs to find scheme at runtime to compile
      # idris2 installs packages with --install into the path given by
      #   IDRIS2_PREFIX. We set that to a default of ~/.idris2, to mirror the
      #   behaviour of the standard Makefile install.
      # TODO: Make support libraries their own derivation such that
      #       overriding LD_LIBRARY_PATH is unnecessary
      makeWrapper "${drv}/bin/idris2_app/idris2.so" "$out/bin/idris2" \
        --set-default CHEZ "${drv.chez}/bin/scheme" \
        --run 'export IDRIS2_PREFIX=''${IDRIS2_PREFIX-"$HOME/.idris2"}' \
        --suffix IDRIS2_LIBS ':' "${drv}/${idrisName}/lib" \
        --suffix IDRIS2_DATA ':' "${drv}/${idrisName}/support" \
        --suffix IDRIS2_PACKAGE_PATH ':' "${globalLibrariesPath}" \
        --suffix DYLD_LIBRARY_PATH ':' "${drv}/${idrisName}/lib" \
        --suffix LD_LIBRARY_PATH ':' "${drv}/${idrisName}/lib"
    '';

  buildPackage = args:
    stdenv.mkDerivation (args
      // (let
        libDirs = lib.strings.makeSearchPath idris2.idrisName (args.idrisInputs or []);
        ipkgName = args.ipkg or "${args.pname}.ipkgs";
      in {
        inherit (args) pname version src;

        nativeBuildInputs = [idris2] ++ (args.nativeBuildInputs or []);

        configurePhase = ''
          runHook preConfigure
          export IDRIS2_PACKAGE_PATH=${libDirs}
          runHook postConfigure
        '';
        buildPhase = ''
          runHook preBuild
          idris2 --build ${ipkgName}
          runHook postBuild
        '';
        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin
          mv build/exec/* $out/bin
          runHook postInstall
        '';
      }));

  buildLibrary = args:
    stdenv.mkDerivation (args
      // (let
        libDirs = lib.strings.makeSearchPath idris2.idrisName (args.idrisInputs or []);
        ipkgName = args.ipkg or "${args.pname}.ipkgs";
        installFlag = "--install" + lib.optionalString withSource "-with-src";
      in {
        inherit (args) pname version src;

        nativeBuildInputs = [idris2] ++ (args.nativeBuildInputs or []);

        configurePhase = ''
          runHook preConfigure
          export IDRIS2_PACKAGE_PATH=${libDirs}
          runHook postConfigure
        '';
        buildPhase = "";
        installPhase = ''
          runHook preInstall
          mkdir -p $out/${idris2.idrisName}
          IDRIS2_PREFIX=$out idris2 ${installFlag} ${ipkgName}
          runHook postInstall
        '';
      }));
in {
  bootstrap = wrap bootstrap;
  ready = wrap ready;

  inherit buildPackage buildLibrary;
}
