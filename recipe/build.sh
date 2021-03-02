#!/bin/sh

if [[ ! $BOOTSTRAPPING == yes ]]; then
  pushd build-aux
    rm config.guess
    curl -o config.guess 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD'
    rm config.sub
    curl -o config.sub 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD'
    popd
else
    export M4=$(which m4)
fi

./configure \
    --prefix=${PREFIX}        \
    --libdir=${PREFIX}/lib    \
    --build=${BUILD}          \
    --host=${HOST}            \
    PERL='/usr/bin/env perl'

make -j${CPU_COUNT} ${VERBOSE_AT}

if [[ ! $BOOTSTRAPPING == yes ]]; then
  if [[ "$build_platform" == "$target_platform" ]]; then
    make check || { cat tests/testsuite.log; exit 1; }
  fi
fi

make install
