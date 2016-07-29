% fft_sample1
clear
Fs = 1000 % Sampling frequency
T = 1/Fs  % Sampling Time
L = 1000  % Length of signal
t = (0:L-1)*T; % Time vector
% Sum of a 50 Hz sinusoid and a 120Hz sinusoid
x = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);
y = x + 2*randn(size(t)); % Sinusoids plus noise
plot(Fs*t(1:50),y(1:50))
title('Signal Corrupted with Zero-Mean Random Noise')
xlabel('time (milliseconds)')
pause

NFFT = 2^nextpow2(L) %Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
df= Fs/NFFT

% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1)))
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
pause


% Plot double-sided amplitude spectrum.
f = Fs*linspace(0,1,NFFT);
plot(f,2*abs(Y(1:NFFT)))
title('Double-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
pause

% DFT,FFTの特性である, N/2+2~N が対称であることの確認．(double side)
