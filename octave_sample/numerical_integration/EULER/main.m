dt = 0.01;			% sample time
x_k = 0;			% initial value
x = [];				% x variable
tim = [];			% time variable

for t = 0 : dt : 10
    x_k1 = x_k + ( - x_k + 1 ) * dt;
    x = [x x_k];
    tim = [tim t];
    x_k = x_k1;
end

grid on;
axis([0 10 0 1.5]);
plot(tim, x);
xlabel('time (s)');
ylabel('x');
