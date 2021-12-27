source $stdenv/setup

cmd="cabal"

echo $name >> $out
echo $cmd >> $out
echo $target >> $out
echo 

fcommon="--builddir=dist/${target}"
	  fcompile=" --with-ghc=${target}-ghc"
	  fcompile+=" --with-ghc-pkg=${target}-ghc-pkg"
	  fcompile+=" --with-gcc=${target}-clang"
	  fcompile+=" --with-ld=${target}-ld"
	  fcompile+=" --with-hsc2hs=${target}-hsc2hs"
	  fcompile+=" --hsc2hs-options=--cross-compile"
	  fconfig="--disable-shared --configure-option=--host=${target}"
	  case $1 in
	      configure|install) flags="${fcommon} ${fcompile} ${fconfig}" ;;
	      build)             flags="${fcommon} ${fcompile}" ;;
	      new-configure|new-install) flags="${fcompile} ${fconfig}" ;;
	      new-build)         flags="${fcompile}" ;;
	      list|info|update)  flags="" ;;
	      "")                flags="" ;;
	      *)                 flags=$fcommon ;;
	  esac;;
