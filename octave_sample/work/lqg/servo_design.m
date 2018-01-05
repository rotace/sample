% regulator design for octave
% ref: https://jp.mathworks.com/help/control/getstart/design-an-lqg-servo-controller.html

pkg load control
addpath('../')

A = [0 1 0;0 0 1;1 0 0];
B = [0.3 1;0 1;-0.3 0.9];
G = [-0.7 1.12; -1.17 1; .14 1.5];
C = [1.9 1.3 1];
D = [0.53 -0.61];
H = [-1.2 -0.89];
sysm = ss(A,B,C,D);
sys = ss(A,[B G],C,[D H]);

nx = 3;    %Number of states
ny = 1;    %Number of outputs
Q = blkdiag(0.1*eye(nx),eye(ny));
R = [1 0;0 2];
K = lqi(sysm,Q,R);% XXX fix

sensors=[1];%y
known=[1,2];%u
unknown=setdiff(1:columns(sysm.b), known);%w

Qn = [4 2;2 1];
Rn = 0.7;
[kest,L,X] = kalman(sys,Qn,Rn,[],sensors,known);

trksys=track(sysm,K,L)

% http://home.hiroshima-u.ac.jp/saeki/Appendix/ModernControl_Matlab.pdf
