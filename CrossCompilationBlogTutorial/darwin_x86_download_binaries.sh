mkdir downloads

cd downloads

# llvm 
curl -L -O https://releases.llvm.org/5.0.0/clang+llvm-5.0.0-x86_64-apple-darwin.tar.xz
tar xjf clang+llvm-5.0.0-x86_64-apple-darwin.tar.xz

# cross compilers
curl -L -O http://releases.mobilehaskell.org/x86_64-apple-darwin/9824f6e473/ghc-8.4.0.20180109-aarch64-apple-ios.tar.xz
curl -L -O http://releases.mobilehaskell.org/x86_64-apple-darwin/9824f6e473/ghc-8.4.0.20180109-x86_64-apple-ios.tar.xz
mkdir ghc-x86_64
mkdir ghc-aarch64
tar xjf ghc-8.4.0.20180109-aarch64-apple-ios.tar.xz -C ghc-aarch64
tar xjf ghc-8.4.0.20180109-x86_64-apple-ios.tar.xz -C ghc-x86_64

# toolchain wrapper
git clone https://github.com/zw3rk/toolchain-wrapper.git

cd ..



