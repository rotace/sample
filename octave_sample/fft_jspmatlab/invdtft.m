%数値積分による離散時間フーリエ逆変換
%出力変数 x=信号
%入力変数 X=離散時間フーリエ変換のベクトル，w=周波数格子点のベクトル
%         n=時刻のベクトル
function x = invdtft(X,w,n)		
dw = w(2)-w(1);                           %周波数格子点の間隔
x = zeros(1,length(n));                   %信号の初期化
for p = 1:length(n)
   x(p) = 1/(2*pi)*X*exp(j*w*n(p)).'*dw;  %数値積分による逆変換の計算
end