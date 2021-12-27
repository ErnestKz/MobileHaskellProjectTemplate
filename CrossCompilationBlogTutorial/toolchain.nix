with (import <nixpkgs> {});
rec {
  ghc-aarch64 = (pkgs.callPackage
    ({ pkgs, stdenv, fetchurl }:
      stdenv.mkDerivation {
        name = "ghc-aarch64";
        builder = ./null_builder.sh;
      }) { });

  ghc-x86_64 = (pkgs.callPackage
    ({ pkgs, stdenv, fetchurl }:
      stdenv.mkDerivation {
        name = "ghc-aarch64";
        builder = ./null_builder.sh;
      }) { });
  
  toolchain = (pkgs.callPackage
    
    ({ pkgs, stdenv, fetchurl }:
      stdenv.mkDerivation {
        name = "toolchain";

        # builder = ./null.sh;
        # overwriting the generic builder here
        # usually start the buld script with source $stdenv/setup

        buildInputs = [
          pkgs.llvmPackages_5.llvm # looks like does it does setup includes as well
          ghc-aarch64
        ];
        
        # $stdenv/setup uses the buildInputs env variable.
        # if package provides a bin subdirectory, it's added to PATH
        # if it has an include subdirectory, it's added to GCC's header search path; and so on

        # This is implemented in a modular way:
        # $stdenv/setup tries to source the file pkg/nix-support/setup-hook of all its dependencies
        # These "setup hooks" can set up whatever enviornment vars they want.
        # Setup hook for perl sets the PERL5LIB environment variable to contain the lib/site_perl directories of all inputs

        
        # setupHook = ./hello.sh;
        # this will only be sourced if this derivation is a part of the $buildInputs or $propagatedBuildInputs
        # this does not work the way I think it does.

        
      }) { });
}
  
