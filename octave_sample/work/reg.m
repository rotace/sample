
function rsys = reg(sys, k, l, sensors=[], known=[], controls=[])

  if (nargin < 3 || nargin > 6 || ! isa (sys, "lti"))
    print_usage ();
  endif

  [a, b, c, d, e] = dssdata (sys, []);
  [inn, stn, outn, ing, outg] = get (sys, "inname", "stname", "outname", "ingroup", "outgroup");

  if (isempty (sensors))
    sensors = 1 : rows (c); % y
  endif

  if (isempty (controls))
    controls = 1 : columns (b); % controls: u=-Kx,  known:ud
  endif

  assert( isequal( union(known, controls), (1:columns(b))(:) ) )

  bc= b(:,controls);
  bk= b(:,known);
  c = c(sensors,:);
  dc= d(sensors,controls);
  dk= d(sensors,known);

  stname = __labels__ (stn, "xhat");
  outname = vertcat (__labels__ (inn(controls(:)), "u"));
  inname = vertcat (__labels__ (inn(known(:)), "ud"), __labels__ (outn(sensors(:)), "y"));

  a = a-l*c-(bc-l*dc)*k;
  b = [bk-l*dk, l];
  c = -k;
  d = zeros(length(sensors), length(sensors)+length(known));

  rsys = ss(a, b, c, d);
  rsys = set (rsys, "inname", inname, "stname", stname, "outname", outname);
end
