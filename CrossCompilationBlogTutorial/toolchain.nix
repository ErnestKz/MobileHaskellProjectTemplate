let
  sources = import ./nix/sources.nix {};
  pkgs = (import sources.nixpkgs-darwin {});
in 
rec {
  ghc-aarch64 = (pkgs.callPackage
    ({ pkgs, stdenv, fetchurl }:
      stdenv.mkDerivation rec {
        name = "ghc-aarch64";
        src = fetchurl {
          url = "http://releases.mobilehaskell.org/x86_64-apple-darwin/9824f6e473/ghc-8.4.0.20180109-aarch64-apple-ios.tar.xz";
          sha256 = "sha256-Q9x/Yn9YNopFESE+6JpF+kyy86ufw1MuzJ9PRj6rzcw=";
        };
        builder = ./nixScripts/mobilehaskell_extract.sh;
      }) { });

  ghc-x86_64 = (pkgs.callPackage
    ({ pkgs, stdenv, fetchurl }:
      stdenv.mkDerivation {
        name = "ghc-x86_64";
        src = fetchurl {
          url = "http://releases.mobilehaskell.org/x86_64-apple-darwin/9824f6e473/ghc-8.4.0.20180109-x86_64-apple-ios.tar.xz";
          sha256 = "sha256-DDrIhm6N4Gl/bV2rw9dJB0xgfjzIhEXBTEAQnJ4f6Jc=";
        };
        builder = ./nixScripts/mobilehaskell_extract.sh;
      }) { });

  # need to find out what the toolchain is actually doing
  
  toolchain = (pkgs.callPackage
    ({ pkgs, stdenv, fetchFromGitHub }:
      stdenv.mkDerivation {
        name = "toolchain";

        src = fetchFromGitHub {
          owner = "zw3rk";
          repo = "toolchain-wrapper";
          rev = "977f311a34d72df3816d9d64728f276d626b0417";
          sha256 = "sha256-H/lO8Hxk2e2TTRuVIBIvxS4MYOHs7sCY7MX+RNN4QX0=";
        };
        
        builder = ./nixScripts/init_toolchain.sh;
        buildInputs = [
          pkgs.llvmPackages_5.llvm # looks like does it does setup includes as well
          ghc-aarch64
          ghc-x86_64
        ];
      }) { });
}
  
