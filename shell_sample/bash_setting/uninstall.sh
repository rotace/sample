#!/bin/bash

file=$1

cat ${file} | awk '
	BEGIN {		# initial
		flag=0
	}
	/^#!#!/ {		# find header
		flag=1
	}
	flag==0 {		# copy
		print $0
	}
' > ${1}.tmp

mv ${1}.tmp ${1}