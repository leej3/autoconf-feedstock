#!/bin/sh

./configure --prefix=${PREFIX}        \
            --libdir=${PREFIX}/lib    \
            --build=${BUILD}          \
            --host=${HOST}            \
            PERL='/usr/bin/env perl'

make -j${CPU_COUNT} ${VERBOSE_AT}
make check || { cat tests/testsuite.log; exit 1; }
make install
