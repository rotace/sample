function ret=velo_id_tc

    % 開発環境でqtのtoolkitがSegFaultするため、gnuplotのtoolkitへ変更
    graphics_toolkit("gnuplot")
    % gnuplotのtoolkitは大量のwarningを吐き出し処理速度を落とすため、warningを表示しない
    warning("off", "all")

    % パッケージをロード
    pkg load arduino

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

    dt = 0.1;
    m  = 10;
    n  = 100;
    u_ini=1.0;   % initial input
    r_const=0.3; % offset input
    p_const=0.7; % step input
    w_time =10;  % wait count
    s_time =50;  % step count

    u=zeros(m,n);
    y=zeros(m,n);

    for i=1:m
        for j=1:n
            tic;
            if     j==1
                writePWMDutyCycle(ar, MOT_LF, u_ini); tmp=u_ini;
            elseif j==w_time
                writePWMDutyCycle(ar, MOT_LF, r_const); tmp=r_const;
            elseif j==s_time
                writePWMDutyCycle(ar, MOT_LF, r_const+p_const); tmp=r_const+p_const;
            end
            [l,r]=readEncCount(en);

            u(i,j)=double(tmp);
            y(i,j)=double(l)/dt;

            ptime = dt-toc;
            if ptime<0
                disp("pause time < 0")
            end
            pause(ptime)
        end
    end

    writePWMDutyCycle(ar, MOT_LF, 0);
    writePWMDutyCycle(ar, MOT_RF, 0);
    writePWMDutyCycle(ar, MOT_LB, 0);
    writePWMDutyCycle(ar, MOT_RB, 0);

    t=[1:n]'*dt;
    u=mean(u)';
    y=mean(y)';

    clf
    hold on
    plot(t, u, "o-");
    plot(t, y, "x-");
    csvwrite("velo_id_tc.csv", [t, u, y]);

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