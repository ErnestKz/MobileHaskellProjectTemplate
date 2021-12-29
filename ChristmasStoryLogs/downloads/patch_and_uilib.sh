aarch64dir=lib:mobile-core:smallAddressSpace:static.aarch64-darwin
x86dir=lib:mobile-core:static.x86_64-darwin

hslib=libHSmobile-core-0.1.0.0-HfUuggbqw4DC9ci8Blc8Tf-ghc8.10.7.a
ffilib=libffi.a
gmplib=libgmp.a
gmpxxlib=libgmpxx.a

mac2ios $aarch64dir/$hslib
mac2ios $aarch64dir/$ffilib
mac2ios $aarch64dir/$gmplib
mac2ios $aarch64dir/$gmpxxlib

mac2ios $x86dir/$hslib
mac2ios $x86dir/$ffilib
mac2ios $x86dir/$gmplib
mac2ios $x86dir/$gmpxxlib

mkdir -p lib

lipo -create -output lib/libhs.a $aarch64dir/$hslib $x86dir/$hslib
lipo -create -output lib/$ffilib $aarch64dir/$ffilib $x86dir/$ffilib
lipo -create -output lib/$gmplib $aarch64dir/$gmplib $x86dir/$gmplib
lipo -create -output lib/$gmpxxlib $aarch64dir/$gmpxxlib $x86dir/$gmpxxlib
