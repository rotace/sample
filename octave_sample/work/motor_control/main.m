
% http://www.miyazaki-gijutsu.com/series/

JM = 8.3e-4;
TE = 0.9e-3;
TK = 6.4e-3;
KT = 5.5e-2;
KG = 5.5e-2;
RA = 2.4;
DN = 0.0;

s = tf('s');
A = 1/RA/(TE*s+1);
B = 1/(JM*s+DN);

model1 = feedback(KT*A*B, KT);
model2 = 1/KG/(TE*s+1)/(TK*s+1);

% bode(model1, model2), grid
