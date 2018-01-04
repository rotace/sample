
function tsys = track(sys, k, l)

  if (nargin < 3 || nargin > 6 || ! isa (sys, "lti"))
    print_usage ();
  endif

  [a, b, c, d, e] = dssdata (sys, []);
  [inn, stn, outn, ing, outg] = get (sys, "inname", "stname", "outname", "ingroup", "outgroup");

  nx=columns(a);
  nu=columns(b);
  ny=rows(c);

  kx=k(:,1:nx);
  ki=k(:,nx+1:end);

  a = [a-b*kx-l*c+l*d*kx, -b*ki+l*d*ki; zeros(ny,nx), zeros(ny,ny)];
  b = [zeros(nx,ny), l; eye(ny), -eye(ny)];
  c = -k;
  d = zeros(rows(k), ny+ny);

  tsys = ss(a, b, c, d);
end
