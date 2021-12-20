# Need to run download the binaries 'darwin_x86_download_binaries.sh' first in order to run these commands.
export PATH=$PWD/downloads/ghc-aarch64/bin:$PATH
export PATH=$PWD/downloads/ghc-x86_64/bin:$PATH
export PATH=$PWD/downloads/clang+llvm-5.0.0-x86_64-apple-darwin/bin:$PATH

(cd ./downloads/toolchain-wrapper && ./bootstrap)
export PATH=$PWD/downloads/toolchain-wrapper:$PATH
# Need to use 'source' rather than 'sh', since 'sh' creates a new shell environment to run the code while 'source' literally executes the source code 
