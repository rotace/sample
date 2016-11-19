# load path
. D:\programing\powershellrc.ps1
# main
foreach ($f in $args)
{
$nf="${f}.emf"
inkscape -z -f $f --export-emf $nf
}
