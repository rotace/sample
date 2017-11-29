
A = [1.1269  -0.4940  0.1129;
     1.0000        0       0;
          0   1.0000       0];

B = [-0.3832;
      0.5919;
      0.5191];

C = [1 0 0];

Plant = ss(A,[B,B],C,0,-1, 'INNAME', {'u','w'}, 'OUTNAME', {'y'});

Q=1;
R=1;

[EST, G, X] = kalman(Plant, Q, R);

a = A;
b = [B B 0*B];
c = [C;C];
d = [0 0 0 ; 0 0 1];
P = ss(a,b,c,d,-1, 'INNAME', {'u','w','v'},'OUTNAME',{'y','yv'});
