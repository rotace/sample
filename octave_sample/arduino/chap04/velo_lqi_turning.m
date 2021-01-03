function [sysm, trksys] = velo_lqi_turning

    pkg load control

    % 開発環境でqtのtoolkitがSegFaultするため、gnuplotのtoolkitへ変更
    graphics_toolkit("gnuplot")
    % gnuplotのtoolkitは大量のwarningを吐き出し処理速度を落とすため、warningを表示しない
    warning("off", "all")

    % 制御対象モデル
    K=70;
    T=0.2;
    u_offset=0.125;
    dt = 0.1;
    sysm = ss(tf(K, [T,1]));
    G = [1.0]; H = [0.0];
    sys = ss(sysm.A, [sysm.B,G], sysm.C, [sysm.D,H]);
    
    nx = 1;    %Number of states
    ny = 1;    %Number of outputs
    Q = blkdiag(eye(nx),eye(ny));
    R = [1.0];
    K = lqi(sysm,Q,R);

    sensors=[1];%y
    known=[1];%u
    unknown=setdiff(1:columns(sys.b), known);%w

    Qn = 1.0;
    Rn = 0.7;
    [kest,L,X] = kalman(sys,Qn,Rn,[],sensors,known);

    trksys = lqgtrack(sysm,K,L);

    sysm.InputName={"u"};
    sysm.OutputName={"y"};
    trksys.InputName={"r","y"};
    trksys.OutputName={"u"};
    step( connect(sysm, trksys, "r", "y"), 5)
end


function [g, x, l] = lqi (sys, q, r = [], s = [])

    if (nargin < 3 || nargin > 6)
      print_usage ();
    end
  
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
    end
  
    if (issample (tsam, -1))
      [x, l, g] = dare (a, b, q, r, s, e);
    else
      [x, l, g] = care (a, b, q, r, s, e);
    end
  
end


function tsys = lqgtrack(sys, k, l)

    if (nargin < 3 || nargin > 6 || ! isa (sys, "lti"))
      print_usage ();
    end
  
    [a, b, c, d, e, tsam] = dssdata (sys, []);
  
    nx=columns(a);
    nu=columns(b);
    ny=rows(c);
  
    kx=k(:,1:nx);
    ki=k(:,nx+1:end);
  
    a = [a-b*kx-l*c+l*d*kx, -b*ki+l*d*ki; zeros(ny,nx), zeros(ny,ny)];
    b = [zeros(nx,ny), l; eye(ny), -eye(ny)];
    c = -k;
    d = zeros(rows(k), ny+ny);

    if (issample (tsam, -1))
        tsys = ss(a, b, c, d, tsam);
    else
        tsys = ss(a, b, c, d);
    end
end
  