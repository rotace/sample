#!/bin/bash
pushd `dirname $0` > /dev/null
##############################
### variable setting

###
rm -f result.dat

ATLAS=/usr/lib64/atlas/libsatlas.so.3
OPENBLAS=/home/usr/local/openblas-0.2.14/lib/libopenblas.so

# default
echo -n "run octave with default ..."
\octave benchmark.m "default" 1>/dev/null
echo "finished"

# atlas
echo -n "run octave with atlas ..."
env LD_PRELOAD=${ATLAS} \
    \octave benchmark.m "atlas" 1>/dev/null
echo "finished"

# openblas
echo -n "run octave with openblas ..."
env LD_PRELOAD=${OPENBLAS} \
    \octave benchmark.m "openblas" 1>/dev/null
echo "finished"

cat "result.dat" | awk '{print " time=",$1," GFLOPS=",$2}'


##############################
popd > /dev/null
