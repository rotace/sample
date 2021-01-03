function ret=velo_pi_turning(Kp=0.02, Ki=0.01, Kd=0.0)

    clf
    % 開発環境でqtのtoolkitがSegFaultするため、gnuplotのtoolkitへ変更
    graphics_toolkit("gnuplot")
    % gnuplotのtoolkitは大量のwarningを吐き出し処理速度を落とすため、warningを表示しない
    warning("off", "all")

    % パッケージをロード
    pkg load control
    pkg load signal

    % 制御対象モデル
    K=70;
    T=0.2;
    u_offset=0.125;
    dt = 0.1;

    % ======極配置法=====
    % [連続時間系]
    G = tf(K, [T,1]);
    [Kp,Ki]=design_by_pole(K,T,-4);
    C1 = pid(Kp,Ki);
    [Kp,Ki]=design_by_pole(K,T,-8);
    C2 = pid(Kp,Ki);
    [Kp,Ki]=design_by_pole(K,T,-16);
    C3 = pid(Kp,Ki);

    % 極配置評価
    % C=C3; pzmap( C*G/(1+C*G) )

    % 応答性評価（r->yへの閉ループ）
    % step( C1*G/(1+C1*G), C2*G/(1+C2*G), C3*G/(1+C3*G) ,2)
    % bode( C1*G/(1+C1*G), C2*G/(1+C2*G), C3*G/(1+C3*G) )
    
    % 外乱抑制評価（w->yへの閉ループ）
    % step( G/(1+C1*G), G/(1+C2*G), G/(1+C3*G) ,2)
    % bode( G/(1+C1*G), G/(1+C2*G), G/(1+C3*G) )
    
    % legend("C1","C2","C3")

    % [離散時間系]
    dt=0.01;
    Gd1 = c2d(G,  dt);
    Cd1 = c2d(C1, dt);
    Cd2 = c2d(C2, dt);
    Cd3 = c2d(C3, dt);
    dt=0.1;
    Gd2 = c2d(G,  dt);
    Cd4 = c2d(C2, dt);

    % 応答性評価（r->yへの閉ループ）
    % step( Cd1*Gd1/(1+Cd1*Gd1), Cd2*Gd1/(1+Cd2*Gd1), Cd3*Gd1/(1+Cd3*Gd1), Cd4*Gd2/(1+Cd4*Gd2) ,2)
    % bode( Cd1*Gd1/(1+Cd1*Gd1), Cd2*Gd1/(1+Cd2*Gd1), Cd3*Gd1/(1+Cd3*Gd1), Cd4*Gd2/(1+Cd4*Gd2) )
    % ylim([-200,0])

    % 外乱抑制評価（w->yへの閉ループ）
    % step( Gd1/(1+Cd1*Gd1), Gd1/(1+Cd2*Gd1), Gd1/(1+Cd3*Gd1), Gd2/(1+Cd4*Gd2) ,2)
    % bode( Gd1/(1+Cd1*Gd1), Gd1/(1+Cd2*Gd1), Gd1/(1+Cd3*Gd1), Gd2/(1+Cd4*Gd2) )
    % ylim([-200,200])

    % legend("C1","C2","C3","C4")

    % 非線形性（オフセット、リミタ）シミュレーション
    t = [0:dt:30];
    n = length(t);
    r = max( [zeros(1,n);sawtooth(0.5*t)] );    % 三角波
    r = max( [zeros(1,n);square(0.5*t)] );      % 矩形波
    % r = max( [zeros(1,n);chirp(0.5*t)] );       % チャープ波
    % r = max( [zeros(1,n);sinc(0.5*t)] );        % sinc関数
    % r = max( [zeros(1,n);diric(0.5*t, 7)] );    % 周期的sinc関数
    % r = max( [zeros(1,n);tripuls(0.5*t)] );     % 三角波単パルス
    % r = max( [zeros(1,n);rectpuls(0.5*t)] );    % 方形波単パルス
    % r = max( [zeros(1,n);gauspuls(0.5*t)] );    % ガウスパルス
    % r = max( [zeros(1,n);pulstran(t, sin(0.5*t), "rectpuls")] );    % パルス列
    r = r*50;
    G = ss(Gd2);
    C = ss(Cd4);
    T = C*G/(1+C*G);
    % lsim( T, r )

    g_x=zeros(length(G.A),1);
    c_x=zeros(length(C.A),1);
    t_x=zeros(length(T.A),1);
    c_y=0.0;
    g_u=0.0;
    g_y=0.0;
    du=0.0;
    y=zeros(1,n);
    z=zeros(1,n);
    u=zeros(1,n);
    for i=1:n
        %%%%%%% 非線形閉ループシステム %%%%%%%

        % リセットワインドアップ対策
        % ベロシティフォームをポジションフォームに変換
        g_u = g_u+du;   % 微分有効
        % g_u = c_y;      % 微分無効


        % 簡易外乱モデル
        if g_y < 5
            % 静止摩擦
            g_u = g_u - 0.8;
        else
            % クーロン摩擦
            g_u = -u_offset*(1-g_u) + 1.0*g_u;
        end

        % リミッタ
        g_u=max(g_u,0.0);g_u=min(g_u,1.0);
        u(i)= g_u;

        % 制御対象モデル
        g_x = G.A*g_x + G.B*g_u;
        g_y = G.C*g_x + G.D*g_u;
        y(i)= g_y;

        e = r(i)-y(i);
        
        % コントローラ
        c_x = C.A*c_x + C.B*e;
        tmp = C.C*c_x + C.D*e;

        % リセットワインドアップ対策
        % ポジションフォームをベロシティフォームに変換
        du  = tmp-c_y;
        c_y = tmp;

        %%%%%%% 線形閉ループシステム %%%%%%%
        t_x = T.A*t_x + T.B*r(i);
        z(i)= T.C*t_x + T.D*r(i);
    end

    subplot(2,1,1);
    plot(t,r, t,y, t,z);
    subplot(2,1,2);
    plot(t,u);

end


function [Kp,Ki] = design_by_pole(K, T, p)
    % G(s) = K/(Ts+1)

    Kp = -(2*p*T+1)/K;
    Ki = p*p*T/K;
end