# x86_64-apple-ios
# aarch64-apple-ios
let
  sources = import ./nix/sources.nix {};
  pkgs = (import sources.nixpkgs-darwin {});
in 
rec {
  ghc-aarch64-apple-ios = (pkgs.callPackage
    ({ pkgs, stdenv, fetchurl }:
      stdenv.mkDerivation rec {
        name = "ghc-aarch64-apple-ios";
        src = fetchurl {
          url = "http://releases.mobilehaskell.org/x86_64-apple-darwin/9824f6e473/ghc-8.4.0.20180109-aarch64-apple-ios.tar.xz";
          sha256 = "sha256-Q9x/Yn9YNopFESE+6JpF+kyy86ufw1MuzJ9PRj6rzcw=";
        };
        builder = ./nixScripts/mobilehaskell_extract.sh;
      }) { });

  ghc-x86_64-apple-ios = (pkgs.callPackage
    ({ pkgs, stdenv, fetchurl }:
      stdenv.mkDerivation {
        name = "ghc-x86_64-apple-ios";
        src = fetchurl {
          url = "http://releases.mobilehaskell.org/x86_64-apple-darwin/9824f6e473/ghc-8.4.0.20180109-x86_64-apple-ios.tar.xz";
          sha256 = "sha256-DDrIhm6N4Gl/bV2rw9dJB0xgfjzIhEXBTEAQnJ4f6Jc=";
        };
        builder = ./nixScripts/mobilehaskell_extract.sh;
      }) { });
  
  cabal-cross = (pkgs.callPackage
    ({ pkgs, stdenv, fetchFromGitHub, writeShellScriptBin, writeScript
     , cabal-install
     , haskellPackages
     , darwin
     , xcbuild
     , target ? "aarch64-apple-ios"
     }: stdenv.mkDerivation rec {
       name = "${target}-cabal";
       wrappedCabal = let
         xcrun = "${xcbuild}/bin/xcrun";
         clang = "${xcbuild}/Toolchains/XcodeDefault.xctoolchain/bin/clang";
         ld = "${xcbuild}/Toolchains/XcodeDefault.xctoolchain/bin/ld";
         deps = { aarch64-apple-ios = { ghc = "${ghc-aarch64-apple-ios}/bin/aarch64-apple-ios-ghc $@";
                                        ghc-pkg = "${ghc-aarch64-apple-ios}/bin/aarch64-apple-ios-ghc-pkg $@";
                                        clang = "${xcrun} --sdk iphoneos ${clang} -arch arm64 $@";
                                        ld = "${xcrun} --sdk iphoneos ${ld} -arch arm64 $@";
                                        hsc2hs = "${ghc-aarch64-apple-ios}/bin/aarch64-apple-ios-hs2cs --cross-compile $@"; };
                  x86_64-apple-ios = { ghc = ghc-x86_64-apple-ios;
                                       ghc-pkg = "";
                                       clang = "";
                                       ld = "";
                                       hsc2hs = ""; }; };
         wrappedCommands' = builtins.mapAttrs (name: value: (writeShellScriptBin "${target}-${name}" value)) deps.${target};
         wrappedCommands = builtins.mapAttrs (name: value: "${value}/bin/${target}-${name}") wrappedCommands';
       in writeShellScriptBin name
         ''
         fcommon="--builddir=dist/${target}"
         fcompile=" --with-ghc=${wrappedCommands.ghc}"
         fcompile+=" --with-ghc-pkg=${wrappedCommands.ghc-pkg}"
         fcompile+=" --with-gcc=${wrappedCommands.clang}"
         fcompile+=" --with-ld=${wrappedCommands.ld}"
         fcompile+=" --with-hsc2hs=${wrappedCommands.hsc2hs}"
         fcompile+=" --hsc2hs-options=--cross-compile"
         fconfig="--disable-shared --configure-option=--host=${target}"

         case $1 in
	       configure|install) flags="''${fcommon} ''${fcompile} ''${fconfig}" ;;
	       build)             flags="''${fcommon} ''${fcompile}" ;;
	       new-configure|new-install) flags="''${fcompile} ''${fconfig}" ;;
	       new-build)         flags="''${fcompile}" ;;
	       list|info|update)  flags="" ;;
	       "")                flags="" ;;
	       *)                 flags=$fcommon ;;
         esac

         exec ${cabal-install}/bin/cabal $flags $@
         '';
       builder = writeScript "builder"
         ''
          source $stdenv/setup
          cp ${wrappedCabal}/bin/${name} $out
         '';
       buildInputs = [
          pkgs.llvmPackages_5.llvm # looks like does it does setup includes as well
          ghc-aarch64-apple-ios
          ghc-x86_64-apple-ios
          darwin.xcode
          # wrappedCabal
       ];
     }) { });
}
  
