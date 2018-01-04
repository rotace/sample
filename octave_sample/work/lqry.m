
## -*- texinfo -*-
## @deftypefn {Function File} {[@var{g}, @var{x}, @var{l}] =} lqr (@var{sys}, @var{q}, @var{r})
## @deftypefnx {Function File} {[@var{g}, @var{x}, @var{l}] =} lqr (@var{sys}, @var{q}, @var{r}, @var{s})
## Linear-quadratic regulator.
##

function [g, x, l] = lqry (sys, q, r = [], s = [])

  if (nargin < 3 || nargin > 6)
    print_usage ();
  endif

  if (isa (sys, "lti"))
    [a, b, c, d, e, tsam] = dssdata (sys, []);
    nu=columns(b);
    nx=rows(b);
    ny=rows(c);

    if isequal(s,[])
      s=zeros(ny,nu);
    end

    assert(isequal(size(q),[ny,ny]));
    assert(isequal(size(r),[nu,nu]));
    assert(isequal(size(s),[ny,nu]));

    mat_l=[c',zeros(nx,nu);d',eye(nu)];
    mat_c=[q ,s;s',r];
    mat_r=[c ,d ;zeros(nu,nx),eye(nu)];
    mat  =mat_l*mat_c*mat_r;
    q    =mat(1:nx,1:nx);
    r    =mat(nx+1:end,nx+1:end);
    s    =mat(1:nx    ,nx+1:end);

  else
    print_usage ();
  endif

  if (issample (tsam, -1))
    [x, l, g] = dare (a, b, q, r, s, e);
  else
    [x, l, g] = care (a, b, q, r, s, e);
  endif

endfunction
