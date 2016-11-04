#!/bin/sh

alias e='echo ================='
awk -F , '$1=="JOHN" {print $1, $2, "("$4")"}' data.txt; e
awk -F , '$5>=2001   {print $1, $2, "("$5")"}' data.txt; e
awk -F , '/JOHN/ { sum++ } \
    END{ printf "num. of JHONS =%d\n", sum }'  data.txt; e
awk -F , '{print NR,$1,$2,"("$5")"}'           data.txt; e
sed -n '3,5p' data.txt | \
    awk -F , '{sum+=$4; print sum} \
    END{ printf "average=%f\n", sum/NR}'
