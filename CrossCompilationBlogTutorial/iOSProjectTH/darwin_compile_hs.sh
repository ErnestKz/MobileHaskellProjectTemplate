mkdir -p lib_x86
x86_64-apple-ios-ghc -fllvmng -staticlib -fPIC -o lib_x86/libhs.a -odir build/hs/x86_64 -hidir build/hs/x86_64 ./hs/Lib.hs

mkdir -p lib_arm
aarch64-apple-ios-ghc -fllvmng -staticlib -fPIC -o lib_arm/libhs.a -odir build/hs/aarch64 -hidir build/hs/aarch64 ./hs/Lib.hs

mkdir -p lib
lipo -create -output lib/libhs.a lib_arm/libhs.a lib_x86/libhs.a
