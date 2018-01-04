% regulator design for octave
% ref: https://jp.mathworks.com/help/control/getstart/design-an-lqg-regulator.html

pkg load control
addpath('../')


sys = ss(tf(100,[1 1 100])); % State-space plant model

% Design LQ-optimal gain K
K = lqry(sys,10,1);	 % u = -Kx minimizes J(u)

% Separate control input u and disturbance input d
P = sys(:,[1 1]);
% input [u;d], output y

% Design Kalman state estimator Kest.
sensors=[1];%y
known=[1];%u
unknown=setdiff(1:columns(P.b), known);
[Kest, L, X] = kalman(P,1,0.01,[],sensors,known);

% Form LQG regulator = LQ gain + Kalman filter.
F=reg(sys,K,L);

% out1=rows(Kest.c)-columns(Kest.c)+1:rows(Kest.c);
% in2 =1:columns(K);
% F = series(Kest, -K, out1, in2);
% feedout = 1:rows(K);
% feedin  = known;
% F = feedback(F, 1, feedin, feedout,'+');
% F = F(:,[2]);

% Close loop
clsys = feedback(sys,F,'+');
% Note positive feedback.

% Create the lowpass filter and add it in series with clsys.
s = tf('s');
lpf= 10/(s+10) ;
clsys_fin = lpf*clsys;

% Open- vs. closed-loop impulse responses
impulse(sys,'r--',clsys_fin,'b-');
