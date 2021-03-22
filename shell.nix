{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, HUnit, stdenv, test-framework
      , test-framework-hunit
      }:
      mkDerivation {
        pname = "unexceptionalio";
        version = "0.5.1";
        src = ./.;
        libraryHaskellDepends = [ base ];
        testHaskellDepends = [
          base HUnit test-framework test-framework-hunit
        ];
        homepage = "https://github.com/singpolyma/unexceptionalio";
        description = "IO without any non-error, synchronous exceptions";
        license = "unknown";
        hydraPlatforms = stdenv.lib.platforms.none;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
