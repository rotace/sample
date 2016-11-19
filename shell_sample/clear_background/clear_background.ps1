# load path
. D:\programing\powershellrc.ps1
# main
foreach ($f in $args)
{
$if=$f
$pf= Split-Path $f -Parent
$cf= Split-Path $f -Leaf
$cf= "mod_$cf"
$of= Join-Path $pf $cf
$if=$if -creplace "\\", "\\\\"
$of=$of -creplace "\\", "\\\\"
#cmd.exe /c "$gimp -i --batch `"(clear-background \`"$if\`" \`"$of\`")`" --batch `"(gimp-quit 0)`""
gimp -i --batch "(clear-background \`"$if\`" \`"$of\`")" --batch "(gimp-quit 0)"
}