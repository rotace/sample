#!/bin/bash
# profile: excuted by the command interpreter for login shells.

file=$1

## check last column
if expr "`tail -n 1 ${file}`" :  [A-Za-z0-9] >/dev/null; then
cat  >> ${file} <<EOF

EOF
fi

## write setting
cat >>  ${file} <<EOF
#!#! header( do not remove )


### USER SETTING (profile) ###


EOF

