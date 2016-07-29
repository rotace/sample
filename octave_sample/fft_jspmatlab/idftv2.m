%離散フーリエ変換を利用した逆変換
%出力 x=信号
%入力 X=離散フーリエ変換
function [x] = idftv2(X) 
N = length(X);              %信号の長さ
x =  conj(dft(conj(X)))/N;  %離散フーリエ逆変換の計算