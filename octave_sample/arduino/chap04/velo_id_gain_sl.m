function ret=velo_id_gain_sl

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

    n = 10;
    u0 = 0.0;
    ret.u00.u1=zeros(n,1);
    ret.u00.y1=zeros(n,1);
    for i=1:n
        u1 = i/10;
        y = exp_steady(ar, en, u0, u1);
        ret.u00.u1(i)=u1;
        ret.u00.y1(i)=y;
    end

    u0 = 1.0;
    ret.u01.u1=zeros(n,1);
    ret.u01.y1=zeros(n,1);
    for i=1:n
        u1 = i/10;
        y1 = exp_steady(ar, en, u0, u1);
        ret.u01.u1(i)=u1;
        ret.u01.y1(i)=y1;
    end

    writePWMDutyCycle(ar, MOT_LF, 0);
    writePWMDutyCycle(ar, MOT_RF, 0);
    writePWMDutyCycle(ar, MOT_LB, 0);
    writePWMDutyCycle(ar, MOT_RB, 0);

    clf
    hold on
    plot(ret.u00.u1, ret.u00.y1, "o-");
    plot(ret.u01.u1, ret.u01.y1, "x-");
    csvwrite("velo_id_gain_sl.csv", [ret.u00.u1, ret.u00.y1, ret.u01.y1]);

end

function y = exp_steady(ar, en, u0, u1)
    MOT_RF = "d5";
    MOT_RB = "d6";
    MOT_LF = "d9";
    MOT_LB = "d10";

    dt=0.1;
    n=100;
    y=zeros(n,1);
    writePWMDutyCycle(ar, MOT_LF, u0);
    writePWMDutyCycle(ar, MOT_RF, 0);
    writePWMDutyCycle(ar, MOT_LB, 0);
    writePWMDutyCycle(ar, MOT_RB, 0);
    
    for i=1:n
        tic;
        if i==50
            writePWMDutyCycle(ar, MOT_LF, u1);
        end
        [l,r]=readEncCount(en);
        y(i)=double(l)/dt;
        ptime = dt-toc;
        if ptime<0
            disp("pause time < 0")
        end
        pause(ptime)
    end

    y=mean(y(60:end));

end
