foreach ($f in $args)
{
$s = identify -verbose $f
$s = $s | Select-String -CaseSensitive "Geometry:"
$s = $s | %{ $_.ToString()  -creplace "^[a-zA-Z0-9:_.\\]*\s*Geometry:\s*"}

$pxrow=$s -creplace "x\d*\+\d*\+\d*"
$pxcol=$s -creplace "^\d*x" | %{ $_ -creplace "\+\d*\+\d*$"}

$pxcel= ([int]$pxrow * [int]$pxcol)
$rate = [int](48000000 / [int]$pxcel)

echo "Geometry: $pxrow x $pxcol = $pxcel"
echo "ScaleRate: $rate"
convert -resize ${rate}% $f mod_$f
}
