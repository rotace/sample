
clear;
x = 0:pi/100:2*pi;
y = sin(x);

figure
plot(x,y)

%pause

clear;
x = linspace(-2*pi,2*pi,100);
y1 = sin(x);
y2 = cos(x);

plot(x,y1,x,y2)

%pause

clear;
Y = magic(4);
plot(Y)

%pause

x = 0:pi/100:2*pi;
y1 = sin(x);
y2 = sin(x-0.25);
y3 = sin(x-0.5);

subplot(2,1,1); plot(x,y1,x,y2,'r.',x,y3,'gx')% matlab style
subplot(2,1,2); plot(x,y1,x,y2,'r.',x,y3,'g@x')% octave style

%pause

clear;
x = 0:pi/10:2*pi;
y1 = sin(x);
y2 = sin(x-0.25);
y3 = sin(x-0.5);
plot(x,y1,'g',x,y2,'b--o',x,y3,'c*')% matlab style

%pause

x = -pi:pi/10:pi;
y = tan(sin(x)) - sin(tan(x));

plot(x,y,'--gs',...
     'LineWidth',2,...
     'markerSize',10,...
     'MarkerEdgeColor','b',...
     'MarkerFaceColor',[0.5,0.5,0.5])
title('2-D Line Plot')
xlabel('x')
ylabel('y')

%pause
close;
clear;
s(1) = subplot(2,1,1);
s(2) = subplot(2,1,2);

x = linspace(0,3);
y1 = sin(5*x);
y2 = sin(15*x);

plot(s(1),x,y1)
%title(s(1),'Top Subplot') % matlab style
ylabel(s(1),'sin(5x)')

plot(s(2),x,y2)
%title(s(2),'Bottom Subplot') % matlab style
ylabel(s(2),'sin(15x)')

%pause

clear;
subplot(1,1,1);
x = linspace(-2*pi,2*pi);
y1 = sin(x);
y2 = cos(x);

h = plot(x,y1,x,y2);

pause

%h(1).LineWidth = 2; % matlab style 
%h(2).Marker = '*';  % matlab style
set(h(1),'LineWidth',2.0) % matlab & octave style
set(h(2),'Marker','*')	  % matlab & octave style

pause