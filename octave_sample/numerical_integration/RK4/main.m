dt = 0.01;			% sample time
x_k = [30/180*pi ;
       0         ];		% initial variable
x   = [];			% x variable
tim = [];			% time variable

for t = 0 : dt : 10
    k1 = myfun(x_k, t) * dt;
    k2 = myfun(x_k+k1/2, t+dt/2) * dt;
    k3 = myfun(x_k+k2/2, t+dt/2) * dt;
    k4 = myfun(x_k+k3,   t+dt  ) * dt;
    
    x_k1 = x_k + (k1 + 2*k2 + 2*k3 + k4) /6;
    x    = [x x_k];
    tim  = [tim t];
    x_k  = x_k1;
end

grid on;
axis([0 10 -1 1]);
plot(tim, x(1,:));
xlabel('time (s)');
ylabel('theta[rad]');

