
num = [1 0];
den = [1 2 10];
H = tf(num,den)

s = tf('s');
H = s / (s^2 + 2*s + 10)

z = 0;
p = [2 1+i 1-i];
k = -2;
H = zpk(z,p,k)

s = zpk('s');
H = -2*s /(s-2)/(s^2-2*s+2)

A=[0 1; -5 -2];
B=[0;3];
C=[1 0];
D=0;
H=ss(A,B,C,D)

freq=[10,30,50,100,500];
resp=[0.0021+0.0009i, 0.027+0.0029i, 0.0044+0.0052i, 0.02-0.004i, 0.0001-0.0021i];
H=frd(resp, freq)

s=tf('s');
H=[1/(s+1), 0; (s+1)/(s^2+s+3), -4*s/(s+2)]

% size(H)
% pole(H)
% isstable(H)
% step(H)

num=[1 -1];
den=[1 -1.85 0.9];
H = tf(num,den,0.1)

z = tf('z', 0.1);
H = (z-1) / (z^2 - 1.85*z + 0.9);

sys = ss(.5, 1, .2, 0, 0.1)

% H.Ts
% isdt(H)
% step(H)
% bode(H)

H1 = tf(2,[1 3 0])
H2 = zpk([],-5, -5)

H = H2*H1
H = series(H1,H2)

H = H1+H2
H = parallel(H1,H2)

H = [H1,H2]
H = [H1;H2]
H = append(H1,H2)

H = [H1, -tf(10,[1 10]) ; 0 , H2]
% sigma(H)

s = tf('s');
F = 1/(s+1);
G = 100/(s^2+5*s+100);
C = 20*(s^2+s+60)/s/(s^2+40*s+400);
S = 10/(s+10);

Sum1 = sumblk('e = r - y');
Sum2 = sumblk('u = uC + uF');

F.InputName = 'r'; F.OutputName = 'uF';
C.InputName = 'e'; C.OutputName = 'uC';
G.InputName = 'u'; G.OutputName = 'ym';
S.InputName = 'ym';S.OutputName = 'y';

T = connect(F,C,G,S,Sum1,Sum2,'r','ym');
step(T),grid
