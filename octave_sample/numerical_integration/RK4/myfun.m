function f = myfun( x, t )

m = 1;			% mass
l = 0.5;		% length
c = 0.5;		% air resister coef.

f = [ x(2);
      -9.8/l * sin( x(1) ) - c/m* x(2) ];

end
