% fft_sample3
clear
Fs = 1000		% Sampling frequency
T = 1/Fs		% Sampling Time
L = 1000		% Length of signal
n = (0:L-1);		% discrete time vector
t = (0:L-1)*T;	% Time vector
f = (0:L-1)*Fs/L;	% Freq vector

% simple wave
Fw= 20;
x = 0.7*sin(2*pi*Fw*t); %.*exp(-20*t);

% original graph
subplot(1,1,1);
plot(t,x);
%pause


% FFT
Xf = fft(x);
Xfs= fftshift(Xf);
ffs= f.-Fs/2;
subplot(3,1,1);
plot(ffs,abs(Xfs)*2/L);

% DFT
Xd = dft(x);
Xds= fftshift(Xd);
fds= f.-Fs/2;
subplot(3,1,2);
plot(fds,abs(Xds)*2/L);

% DTFT
w = linspace(-pi,pi,512);		% 周波数[-π,π]を512等分
Xdt = dtft(x,n,w);
fdt = w / (2*pi) * Fs;		% Ωとfの関係式
subplot(3,1,3);
plot(fdt,abs(Xdt)*2/L);

% comment
% 2/Lで正規化を行ったが，DTFTは正しい値にならなかった．
% DTFTも，サンプリング数によって振幅が増大するが，決してL倍されるわけではないようだ．

pause

% IFFT
xf = ifft(Xf);
subplot(3,1,1);
plot(t,real(xf));

% IDFT
xd = idft(Xd);
subplot(3,1,2);
plot(t,real(xd));

% IDTFT
xdt = invdtft(Xdt,w,n);
subplot(3,1,3);
plot(t,real(xdt));

pause


