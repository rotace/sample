% fft_sample2
clear
Fs = 1000 % Sampling frequency
T = 1/Fs  % Sampling Time
L = 1000  % Length of signal
t = (0:L-1)*T; % Time vector
NFFT = 2^nextpow2(L) %Next power of 2 from length of y
w = hanning(L); % hanning window
% Sum of a 50 Hz sinusoid and a 120Hz sinusoid
x = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);
y = x + 2*randn(size(t)); % Sinusoids plus noise
yw= y .* w';
plot(Fs*t(1:L),y(1:L))
hold on
plot(Fs*t(1:L),yw(1:L),"2")
title('Signal Corrupted with Zero-Mean Random Noise')
xlabel('time (milliseconds)')
hold off
pause


AC= sum(w)/L % Amplitude Correction Factor

Y = fft(y,NFFT)/L;
YF= fft(yw,NFFT)/L/AC;
f = Fs/2*linspace(0,1,NFFT/2+1);
df= Fs/NFFT

% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1)))
hold on
plot(f,2*abs(YF(1:NFFT/2+1)),"2")
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
hold off
pause



% comment
% ハニング窓を適用し，比較した例．
% ハニングの重み付け分だけ振幅が小さくなるので，補正が必要．
