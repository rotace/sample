#!/bin/sh

alias e="echo ====================="

sed -n '2,$p'         data.txt ; e
sed -n '/^$/,/^end/p' data.txt ; e
sed '1,4d'            data.txt ; e
sed '$d'              data.txt ; e
sed '1,/^$/d'         data.txt ; e
sed 's/JHON/GEORGE/g' data.txt


