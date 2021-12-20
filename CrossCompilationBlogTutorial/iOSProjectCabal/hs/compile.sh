mkdir -p lib_x86
x86_64-apple-ios-cabal build
mv liba.a lib_x86

mkdir -p lib_arm
aarch64-apple-ios-cabal build
mv liba.a lib_arm

mkdir -p ../lib
lipo -create -output ../lib/liba.a lib_arm/liba.a lib_x86/liba.a
