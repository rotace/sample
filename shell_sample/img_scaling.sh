for f in $@
do
  pxrow=`identify -verbose $f | \
  sed -n 's/^\s*Geometry:\s\([0-9]*\)x\([0-9]*\)+[0-9]*+[0-9]$/\1/p' `
  pxcol=`identify -verbose $f | \
  sed -n 's/^\s*Geometry:\s\([0-9]*\)x\([0-9]*\)+[0-9]*+[0-9]$/\2/p' `
  pxcel=`expr $pxrow \* $pxcol`
  rate=`expr 48000000 / $pxcel`
  echo "Filename: $f"
  echo "Geometry: $pxrow x $pxcol = $pxcel"
  echo "ScaleRate: $rate"
  convert -resize ${rate}% $f small_$f
done
