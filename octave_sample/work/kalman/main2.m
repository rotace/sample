clear all

a = 0.99;
sigw2 = 0.25;
sigv2 = 1;
x = 0;
Xvec = 0;

hatxp = 0;
Pp = 1;
HatXf = [];

for t = 0:200
  x = a*x + sqrt(sigw2)*randn(1,1);
  Xvec = [Xvec; x];
end

Yvec = Xvec + sqrt(sigv2)*randn(size(Xvec));

N =  length(Xvec);

for i = 1:N
  K = Pp/(Pp+sigv2);
  hatxf = hatxp + K*(Yvec(i) - hatxp);
  Pf = Pp - K*Pp;
  hatxp = a*hatxf;
  Pp = a^2*Pf + sigw2;
  HatXf = [HatXf; hatxf];
end

plot(Xvec, 'b-')
hold on
plot(Yvec, 'g-')
plot(HatXf, 'r-')
