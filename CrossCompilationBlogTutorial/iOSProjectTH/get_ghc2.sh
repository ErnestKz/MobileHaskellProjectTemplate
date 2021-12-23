curl -L -O https://downloads.haskell.org/~ghc/8.4.4/ghc-8.4.4-src.tar.xz
tar xjf ghc-8.4.4-src.tar.xz


cd ghc-8.4.4/iserv/
aarch64-apple-ios-cabal install -flibrary
# x86_64-apple-ios-cabal install -flibrary


# aarch64-apple-ios-ghc -odir arm64 -hidir arm64 -staticlib -threaded -lffi -L/path/to/libffi/aarch64-apple-ios/lib -o hs-libs/arm64/libhs.a -package iserv-bin hs/LineBuff.hs
# x86_64-apple-ios-ghc -odir x86_64 -hidir x86_64 -staticlib -threaded -lffi -L/path/to/libffi/x86_64-apple-ios/lib -o hs-libs/x86_64/libhs.a -package iserv-bin hs/LineBuff.hs
#   x86_64-apple-ios-ghc -odir x86_64 -hidir x86_64 -staticlib -threaded -lffi -L/path/to/libffi/x86_64-apple-ios/lib -o hs-libs/x86_64/libhs.a -package iserv-bin hs/LineBuff.hs
#   lipo -create -output hs-libs/libhs.a hs-libs/arm64/libhs.a hs-libs/x86_64/libhs.a
