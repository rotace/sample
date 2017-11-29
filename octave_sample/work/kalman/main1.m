clear all

x=0;
Xvec=0;
y=0;
Yvec=0;

for t=0:1000
  r = randn(1,1);
  x = 0.99*x + sqrt(1)*r;
  y = 0.9*y + sqrt(1)*r;
  Xvec = [Xvec; x];
  Yvec = [Yvec; y];
end

hold on
plot(Xvec,"r")
plot(Yvec,"b")
