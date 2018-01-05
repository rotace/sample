
## -*- texinfo -*-
## @deftypefn {Function File} {[@var{g}, @var{x}, @var{l}] =} lqi (@var{sys}, @var{q}, @var{r})
## @deftypefnx {Function File} {[@var{g}, @var{x}, @var{l}] =} lqi (@var{sys}, @var{q}, @var{r}, @var{s})
## Linear-quadratic regulator.
##

function [g, x, l] = lqi (sys, q, r = [], s = [])

  if (nargin < 3 || nargin > 6)
    print_usage ();
  endif

  if (isa (sys, "lti"))
    [a, b, c, d, e, tsam] = dssdata (sys, []);
    nu=columns(b);
    nx=rows(b);
    ny=rows(c);

    a =[a,zeros(nx,ny); -c,zeros(ny,ny)];
    b =[b;-d];

    if isequal(s,[])
      s=zeros(nx+ny,nu);
    end

    assert(isequal(size(q),[nx+ny,nx+ny]));
    assert(isequal(size(r),[nu,nu]));
    assert(isequal(size(s),[nx+ny,nu]));

  else
    print_usage ();
  endif

  if (issample (tsam, -1))
    [x, l, g] = dare (a, b, q, r, s, e);
  else
    [x, l, g] = care (a, b, q, r, s, e);
  endif

endfunction
