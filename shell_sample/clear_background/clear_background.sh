for f in $@
do
  if=`readlink -f $f`
  of="`dirname $if`/mod_${f%.*}.png"
  script_fu="(clear-background \"$if\" \"$of\")"
  gimp -i --batch "$script_fu" --batch "(gimp-quit 0)"
done

