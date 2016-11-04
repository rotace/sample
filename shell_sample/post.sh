#!/bin/bash
source run.sh

proj=$1
freqs=$2
freqe=$3
freqd=$4

for ((freq=${freqs}; freq<=${freqe}; freq+=${freqd}))
do

# input.mesh.file(vtk)
# input.FEMdata.file(csv)
# output.mesh.file(vtk)

#convert femData (postproc v2.0)
run postproc -stfem <<EOF
"structuremesh.vtk"
"${proj}_${freq}.0000_fe.csv"
"${proj}_${freq}.0000_structuremesh.vtk"
EOF


done

echo "post-process finished"
