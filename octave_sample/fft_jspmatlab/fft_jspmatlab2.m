%離散フーリエ変換の計算例
clear;                                    %作業スペースからすべての変数を消去
x = [1 1 1 1 0 0 0 0];                    %信号x
n = 0:length(x)-1;                        %時刻の範囲
subplot(2,2,1);  
stem(n,x); grid;                          %信号xの図示
axis([0 length(n) min(x) max(x)]);
xlabel('time n'); ylabel('x(n)'); 
X = dft(x);                                %信号xの離散フーリエ変換X
magX = abs(X);                             %Xの振幅
k = n;                                    %周波数のインデックス
subplot(2,2,2); 
stem(k,magX); grid;                       %振幅|X|の図示
xlabel('frequency k'); ylabel('|X(k)|'); 
kshift = k-floor(length(k)/2);            %インデックスのシフト
Xshift = fftshift(X);                     %DFT X(k) のシフト
magXshift = abs(Xshift);                  %シフトされたDFTの振幅スペクトル
subplot(2,2,3); 
stem(kshift,magXshift); grid;             %シフトされた振幅スペクトルの図示
xlabel('frequency k'); ylabel('|X(k)|');

xi = idft(X);
subplot(2,2,4);
stem(n,real(xi)); grid;
xlabel('time n'); ylabel('x(n)');

pause

%dft.m とrecfft.m の計算量の測定
subplot(1,1,1);
clear;                               %作業スペースからすべての変数を消去
pmax = 9;                            %べきの最大値       
N = 2.^(0:pmax);                     %信号の長さの範囲
x = randn(1,N(end));                 %テスト用の正規白色雑音
%dft.m の計算量
for m = 1:(pmax+1)    
  tic();
  X = dft(x(1:N(m)));               %長さNの信号xのDFTを実行
  t=toc();
  dft_times(m) = t;
end
%recfft.m の計算量
for m = 1:(pmax+1)
  tic();
  X = recfft(x(1:N(m)));            %長さNの信号xのDFTを実行
  t=toc();
  recfft_times(m) = t;
end
%計算量の図示
loglog(N,dft_times,'o', N,recfft_times,'*');  %計算量の両対数での図示
xlabel('Length of signals N'); 
ylabel('Number of operations');
legend('dft.m','recfft.m',2); grid;  %凡例

pause

%fft.m の計算量の測定
clear;                           %作業スペースからすべての変数を消去
Nmax = 512;                      %信号の長さの上限
N = 1:Nmax;                      %信号の長さのベクトル
x = randn(1,Nmax);               %テスト用の正規白色雑音
fft_times = zeros(1,Nmax);       %FFTの計算量を格納するベクトルを初期化
%fft.m の計算量
for M = N
   tic();
   fft(x(1:M));                  %長さMのFFTの実行
   t=toc();
   fft_times(M) = t;
end
%計算量の図示
loglog(N,fft_times,'.');  grid;  %計算量の両対数での図示
xlabel('Length of signals N'); 
ylabel('Number of operations');

pause
