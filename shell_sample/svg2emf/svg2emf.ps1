# load path
. D:\programing\powershellrc.ps1
# main
foreach ($f in $args)
{
$of=[System.IO.Path]::ChangeExtension($f, ".emf");
inkscape -z -f $f --export-emf $of
}
