source $stdenv/setup

(cd $src && ./bootstrap)
export PATH=$src:$PATH

mkdir $out
mv $src $out
