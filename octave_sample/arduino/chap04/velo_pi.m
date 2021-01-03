function ret=velo_pi(is_arduino_enabled=false)

    % 開発環境でqtのtoolkitがSegFaultするため、gnuplotのtoolkitへ変更
    graphics_toolkit("gnuplot")
    % gnuplotのtoolkitは大量のwarningを吐き出し処理速度を落とすため、warningを表示しない
    warning("off", "all")

    % パッケージをロード
    pkg load control
    pkg load arduino

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
    % 制御対象モデル
    K=70;
    T=0.2;
    u_offset=0.125;
    sys = ss(c2d(tf(K,[T,1]),dt));
    % 目標値モデル(1回転=20cnt, 最大毎秒5回転=100cnt/sec, 周期2secの方形波)
    r_max=50;
    sg.pri=1.0;
    % 制御モデル
    Kp=0.031429;
    Ki=0.18286;
    ctl = ss(c2d(pid(Kp,Ki), dt));

    % 記録用メモリ初期化
    n=uint32(10/dt);
    ret.r=zeros(1,n);% 目標値r
    ret.e=zeros(1,n);% 偏差e
    ret.u=zeros(1,n);% 操作量u
    ret.y=zeros(1,n);% 制御量y
    ret.ts=zeros(1,n);
    ret.te=zeros(1,n);

    % 変数初期化
    ctlx=zeros(length(ctl.A),1);
    sysx=zeros(length(sys.A),1);
    y=0.0; r=0.0; e=0.0; u=0.0;

    unwind_protect
    % while (true)
    for i=1:n
        tic
        % 制御量yの更新
        if is_arduino_enabled
            % about 30ms
            [l,r]=readEncCount(en);
            y=double(l)/dt;
        else
            x=sysx;
            x=sys.A*x + sys.B*u;
            y=sys.C*x + sys.D*u;
            sysx=x;
        end

        % 目標値rの更新
        sg=square_wave(sg,dt);
        r=sg.val*r_max;

        % 偏差eの更新
        e=r-y;

        % 操作量uの更新
        x=ctlx;
        x=ctl.A*x + ctl.B*e;
        u=ctl.C*x + ctl.D*e;
        ctlx=x;

        % 制御対象へ入力
        u=max(u,0.0);u=min(u,1.0);
        if is_arduino_enabled
            % about 30ms
            writePWMDutyCycle(ar, MOT_LF, u);

            % 残り時間待機
            ptime = dt-toc;
            if ptime<0
                disp("pause time < 0")
            end
            pause(ptime)
        end

        % 記録
        ret.r(i)=r;
        ret.e(i)=e;
        ret.u(i)=u;
        ret.y(i)=y;
        
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

    ret.ctl=ctl;

    clf
    subplot(2,1,1)
    hold on
    plot(ret.r, "*-")
    plot(ret.e, ".-")
    plot(ret.y, "d-")
    legend("r","e","y")
    subplot(2,1,2)
    plot(ret.u, "+-")
    legend("u")
end

function obj = square_wave(obj, dt)
    if ~isfield(obj, "is_init")
        obj.is_init=true;
        obj.t=0.0;
        obj.x=1.0;
    end
    if obj.t>=obj.pri
        obj.x=-obj.x;
        obj.t-=obj.pri;
    end
    obj.val = max(obj.x,0.0);
    obj.t+= dt;
end