%離散時間フーリエ変換
%出力変数  X=離散時間フーリエ変換
%入力変数  x=信号，n=時刻, w=周波数の格子点
function X = dtft(x,n,w)
X = zeros(1,length(w));		%Xを初期化
for q = 1:length(w)             
   X(q) = x*exp(-j*w(q)*n).';	%X(q)を求める
end
