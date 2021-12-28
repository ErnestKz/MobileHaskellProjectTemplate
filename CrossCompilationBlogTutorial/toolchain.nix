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
    ({ pkgs, stdenv, fetchFromGitHub
     , cabal-install
     , haskellPackages
     , darwin
     , xcbuild
     , target ? "aarch64-apple-ios"
     }: stdenv.mkDerivation {
       name = "cabal-${target}";
       cabalWrapper = let
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
         deps2 = deps.${target};
         # need to make each of the deps a binary
       in ''
       fcommon="--builddir=dist/${target}"
       fcompile=" --with-ghc=${target}-ghc"
       fcompile+=" --with-ghc-pkg=${target}-ghc-pkg"
       fcompile+=" --with-gcc=${target}-clang"
       fcompile+=" --with-ld=${target}-ld"
       fcompile+=" --with-hsc2hs=${target}-hsc2hs"
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
       esac;;

       ${deps2.ghc}
       ${darwin.xcode}
       ${xcbuild}
       '';
       
       builder = ./nixScripts/init_toolchain.sh;
       buildInputs = [
          pkgs.llvmPackages_5.llvm # looks like does it does setup includes as well
          ghc-aarch64-apple-ios
          ghc-x86_64-apple-ios
          darwin.xcode
       ];
      }) { });
}
  
