%実数値の指数関数を生成する関数
%出力変数  x=指数関数
%入力変数  alpha=実定数，n=時刻ベクトル
function x = realexp(alpha,n)
x = alpha.^n.*(n>=0);          %n>=0ならば，x=alpha^n, その他のときx=0