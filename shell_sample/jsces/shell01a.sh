#!/bin/bash

for name in *.txt ; do
    if( [ -f ${name} ] )then
	echo ${name}
    fi
done
