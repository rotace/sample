#!/bin/bash
source run.sh

proj=$1
freqs=$2
freqe=$3
freqd=$4
ver=$5
set=$6

if   [ ${set} = "0" ]; then
    style_st="style = default"
    style_w1="style = default"
    style_w2="style = default"
elif [ ${set} = "1" ]; then
    style_st="style = mode1_center"
    style_w1="style = mode1_front"
    style_w2="style = mode1_back"
else
    echo "Select style Number in makefile!!"
    exit 1
fi

### make feap file (at first!)
run cat "mesh_input/stfem.txt.in" > "mesh_input/stfem.txt"
run echo ${style_st} >> "mesh_input/stfem.txt"
run preproc-hexa${ver} -stfem "mesh_input/stfem.txt"
run mv structuremesh.fea ./I${proj}.fea

### make wbm file (at last!)
run cat "mesh_input/wbm1.txt.in" > "mesh_input/wbm1.txt"
run echo ${style_w1} >> "mesh_input/wbm1.txt"
run preproc-hexa${ver} -wbm "mesh_input/wbm1.txt"

run cat "mesh_input/wbm2.txt.in" > "mesh_input/wbm2.txt"
run echo ${style_w2} >> "mesh_input/wbm2.txt"
run preproc-hexa${ver} -wbm "mesh_input/wbm2.txt"

run cat mesh_input/wbmheader |\
    sed "s/{freqs}/${freqs}/g" |\
    sed "s/{freqe}/${freqe}/g" |\
    sed "s/{freqd}/${freqd}/g" > ${proj}.wbm
run cat mesh_input/wbm1.wbm >> ${proj}.wbm
run cat mesh_input/wbm2.wbm >> ${proj}.wbm


echo "pre-process finished"
