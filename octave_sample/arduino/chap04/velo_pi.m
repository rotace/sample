function ret=velo_pi(is_arduino_enabled=false, is_velform_enabled=false)

    % 開発環境でqtのtoolkitがSegFaultするため、gnuplotのtoolkitへ変更
    graphics_toolkit("gnuplot")
    % gnuplotのtoolkitは大量のwarningを吐き出し処理速度を落とすため、warningを表示しない
    warning("off", "all")

    % パッケージをロード
    pkg load control
    pkg load arduino
    pkg load signal

    if is_arduino_enabled
        % arduinoにoctave通信用のコアライブラリと自作ライブラリを書き込み
        % arduinosetup('arduinobinary', '/home/yasu/Downloads/arduino-1.8.8/arduino', 'libraries', 'UserAddon/SingleEncoder')

        ar=arduino([], [], 'libraries', 'UserAddon/SingleEncoder', 'forcebuild', true);
        en=addon(ar, "UserAddon/SingleEncoder");

        % 制御対象初期化
        MOT_RF = "d5";
        MOT_RB = "d6";
        MOT_LF = "d9";
        MOT_LB = "d10";
        writePWMDutyCycle(ar, MOT_LF, 0);
        writePWMDutyCycle(ar, MOT_RF, 0);
        writePWMDutyCycle(ar, MOT_LB, 0);
        writePWMDutyCycle(ar, MOT_RB, 0);
    end


    % 演算周期[sec]
    dt = 0.1;

    % 目標値モデル(1回転=20cnt, 最大毎秒5回転=100cnt/sec, 周期2sec)
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

    % 制御対象同定(周波数スイープ)
    r = chirp(t, 0, 30, 1);
    r = (r+1)/2/2+0.5;

    r = r*50;

    % 制御対象モデル
    K=70;
    T=0.2;
    u_offset=0.125;
    G = ss(c2d(tf(K,[T,1]),dt));
    
    % 制御モデル
    Kp=0.031429;
    Ki=0.18286;
    Kp=0.0085714;
    Ki=0.045714;
    C = ss(c2d(pid(Kp,Ki), dt));

    % 記録用メモリ初期化
    g_x=zeros(length(G.A),1);
    c_x=zeros(length(C.A),1);
    c_y=0.0; c_y_old=0.0;
    g_u=0.0;
    g_y=0.0;
    du=0.0;
    y=zeros(1,n);% 制御量y
    u=zeros(1,n);% 操作量u
    e=zeros(1,n);% 偏差e

    unwind_protect
    for i=1:n
        tic
        e(i)=r(i)-g_y;

        % コントローラ
        c_x = C.A*c_x + C.B*e(i);
        c_y = C.C*c_x + C.D*e(i);

        % リセットワインドアップ対策
        if is_velform_enabled
            % ポジションフォームをベロシティフォームに変換
            du  = c_y - c_y_old; c_y_old = c_y;
            % ベロシティフォームをポジションフォームに変換
            g_u = g_u + du;
        else
            g_u = c_y;
        end

        % 制御対象へ入力
        if is_arduino_enabled
            % リミッタ
            g_u=max(g_u,0.0);g_u=min(g_u,1.0);

            % 制御入出力(about 30ms)
            u(i)= g_u;
            [cnt_l, cnt_r]=controlEncMotor(en, u(i), 0.0);
            g_y=double(cnt_l)/dt;
            y(i)= g_y;

            % 残り時間待機
            ptime = dt-toc;
            if ptime<0
                disp("pause time < 0")
            end
            pause(ptime)
        else
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

            % 制御対象モデル
            u(i)= g_u;
            g_x = G.A*g_x + G.B*g_u;
            g_y = G.C*g_x + G.D*g_u;
            y(i)= g_y;
        end
        
    end
    unwind_protect_cleanup
    if is_arduino_enabled
        writePWMDutyCycle(ar, MOT_LF, 0);
        writePWMDutyCycle(ar, MOT_RF, 0);
        writePWMDutyCycle(ar, MOT_LB, 0);
        writePWMDutyCycle(ar, MOT_RB, 0);
        clear en
        clear ar
    end
    end_unwind_protect

    clf
    subplot(2,1,1);
    plot(t,r, t,y, t,e);
    legend("r", "y", "e")
    subplot(2,1,2);
    plot(t,u);
    legend("u")
end