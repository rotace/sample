# load path
. D:\programing\powershellrc.ps1
# main
foreach ($f in $args)
{
$s = identify -verbose $f
$s = $s | Select-String -CaseSensitive "Geometry:"
$s = $s | %{ $_.ToString()  -creplace "^[a-zA-Z0-9:_.\\]*\s*Geometry:\s*"}

$pxrow=$s -creplace "x\d*\+\d*\+\d*"
$pxcol=$s -creplace "^\d*x" | %{ $_ -creplace "\+\d*\+\d*$"}

$ipx= ([int]$pxrow * [int]$pxcol)
$opx=[int]307200
$rate=[int]([Math]::Sqrt($opx/$ipx)*100)

$pf= Split-Path $f -Parent
$cf= Split-Path $f -Leaf
$cf= "mod_$cf"
$nf= Join-Path $pf $cf

echo "InFile:$f"
echo "OutFile:$nf"
echo "Convert Rate:${rate}%"

convert -resize ${rate}% $f $nf
}
