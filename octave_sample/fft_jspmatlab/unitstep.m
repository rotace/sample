%単位ステップを生成する関数
%出力変数  x=単位ステップベクトル
%入力変数  n=時刻ベクトル
function x = unitstep(n)
x = n>=0;                 %n>=0ならば，x=1, その他のときx=0