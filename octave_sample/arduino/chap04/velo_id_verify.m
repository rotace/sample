function ret=velo_id_verify

    % 開発環境でqtのtoolkitがSegFaultするため、gnuplotのtoolkitへ変更
    graphics_toolkit("gnuplot")
    % gnuplotのtoolkitは大量のwarningを吐き出し処理速度を落とすため、warningを表示しない
    warning("off", "all")

    % パッケージをロード
    pkg load control

    % 制御対象モデル
    K=70;
    T=0.2;
    u_offset=0.125;
    dt = 0.1;
    sys = c2d(ss(tf(K, [T,1])),dt);

    m  = 10;
    n  = 100;
    u_ini=1.0;   % initial input
    r_const=0.3; % offset input
    p_const=0.7; % step input
    w_time =10;  % wait count
    s_time =50;  % step count

    u=zeros(m,n);
    y=zeros(m,n);
    x=zeros(length(sys.A),1);

    for i=1:m
        for j=1:n
            tic;
            if     j==1
                tmp=u_ini;
            elseif j==w_time
                tmp=r_const;
            elseif j==s_time
                tmp=r_const+p_const;
            end


            u(i,j)=double(tmp)-u_offset;
            x     =sys.A*x + sys.B*u(i,j);
            y(i,j)=sys.C*x + sys.D*u(i,j);

        end
    end

    t=[1:n]'*dt;
    u=mean(u)';
    y=mean(y)';

    clf
    hold on
    plot(t, u, "o-");
    plot(t, y, "x-");
    csvwrite("velo_id_verify.csv", [t, u, y]);

    c1 = mean( y(w_time:s_time-10) );
    c2 = mean( y(s_time+10:end));
    K_id = (c2-c1)/p_const;
    u_offset = (K_id*r_const - c1)/K_id;

    y2 = y(s_time:end) - c1;
    t2 = t(s_time:end) - t(s_time);
    tc_idx = min( find(y2 > (c2-c1)*0.632) );
    T_id = t2(tc_idx);

    disp("== Results ==")
    disp( ["K        = ", num2str(K_id)] )
    disp( ["T        = ", num2str(T_id)] )
    disp( ["u_offset = ", num2str(u_offset)] )

    ret.t=t;
    ret.y=y;
end