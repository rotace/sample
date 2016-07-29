%再帰的に定義される高速フーリエ変換
%出力変数 X=離散フーリエ変換
%入力変数 x=信号
function [X] = recfft(x)
N = length(x);                      %信号の長さ
if 2^fix(log2(N)) ~= N              %Nが2のべき乗でなければ
   error('N is not a power of 2');  %エラーを表示して，停止
end;   
if N == 1                           %N=1ならば
     X = x;                         %Xにxを代入
   else                             %N=1でないならば
     m = 0:N/2-1;                   %時刻のインデックス
     x0 = x(2*m +1);                %偶数インデックスの信号 x0
     x1 = x(2*m+1 +1);              %奇数インデックスの信号 x1
     X0 = recfft(x0);               %x0のFFTを再帰的に計算
     X1 = recfft(x1);               %x1のFFTを再帰的に計算
     k = 0:N/2-1;                   %周波数のインデックス
     WNk = exp(-j*2*pi*k/N);        %回転因子
     WNkX1 = WNk.*X1;               %回転因子とX1の積
     X = [X0+WNkX1, X0-WNkX1];      %X0とX1の統合
end