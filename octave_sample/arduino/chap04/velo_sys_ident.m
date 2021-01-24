function ret = velo_sys_ident
    % ref1) https://qiita.com/fumiya_sato/items/dc6c37d4e620b514a1a4
    % ref2) http://idken.net/posts/2017-06-02-systemident/

    % 開発環境でqtのtoolkitがSegFaultするため、gnuplotのtoolkitへ変更
    graphics_toolkit("gnuplot")
    % gnuplotのtoolkitは大量のwarningを吐き出し処理速度を落とすため、warningを表示しない
    warning("off", "all")

    % パッケージをロード
    pkg load control
    pkg load arduino
    pkg load signal

    unwind_protect

        % arduinoにoctave通信用のコアライブラリと自作ライブラリを書き込み
        % arduinosetup('arduinobinary', '/home/yasu/Downloads/arduino-1.8.8/arduino', 'libraries', 'UserAddon/SingleEncoder')

        ar=arduino([], [], 'libraries', 'UserAddon/SingleEncoder', 'forcebuild', true);
        en=addon(ar, "UserAddon/SingleEncoder");

        % 制御対象初期化
        MOT_RF = "d5";
        MOT_RB = "d6";
        MOT_LF = "d9";
        MOT_LB = "d10";
        tic;writePWMDutyCycle(ar, MOT_LF, 0);toc
        tic;writePWMDutyCycle(ar, MOT_RF, 0);toc
        tic;writePWMDutyCycle(ar, MOT_LB, 0);toc
        tic;writePWMDutyCycle(ar, MOT_RB, 0);toc
        
        % 制御対象同定(PRBS信号)
        dt=0.1;
        rmin=0.3; rmax=1.0;
        u = prbs(50,5);
        u = (rmax-rmin)*(u+1)/2+rmin;
        u = [u(:),u(:)]'(:)';
        u1 = u; % システム同定用
        u2 = flip(u); % クロスバリデーション用

        % データ取得
        y1=systemIdent(en, u1);y1=double(y1/dt);
        controlEncMotor(en, 0.0, 0.0);
        pause(2);
        controlEncMotor(en, 0.0, 0.0);
        y2=systemIdent(en, u2);y2=double(y2/dt);

        ret.data1=iddata(y1(:), u1(:), dt);
        ret.data2=iddata(y2(:), u2(:), dt);

        % バイアス、トレンド除去
        ret.detr1=detrend(ret.data1);
        ret.detr2=detrend(ret.data2);

        % システム同定
        ret.sys = n4sid(ret.detr1, 10);
        ret.lsim1 = iddata( lsim( ret.sys, ret.detr1.u{1} ), ret.detr1.u{1} );
        ret.lsim2 = iddata( lsim( ret.sys, ret.detr2.u{1} ), ret.detr2.u{1} );
        
        % クロスバリデーション
        subplot(2,1,1);
        plot([1:100], ret.detr1.y{1}, [1:100], ret.lsim1.y{1})
        subplot(2,1,2);
        plot([1:100], ret.detr2.y{1}, [1:100], ret.lsim2.y{1})

    unwind_protect_cleanup

        writePWMDutyCycle(ar, MOT_LF, 0);
        writePWMDutyCycle(ar, MOT_RF, 0);
        writePWMDutyCycle(ar, MOT_LB, 0);
        writePWMDutyCycle(ar, MOT_RB, 0);
        clear en
        clear ar

    end_unwind_protect

end

function prbs_test(data, srnum)

    N=length(data);
    cnt0=zeros(1,N);
    cnt1=zeros(1,N);

    cnt0_old = 0;
    cnt1_old = 0;
    for i=1:N
        cnt0(i) = (cnt0_old+~data(i))*~data(i);
        cnt1(i) = (cnt1_old+ data(i))* data(i);
        cnt0_old = cnt0(i);
        cnt1_old = cnt1(i);
    end
    for i=1:N-1
        if cnt0(i+1)!=0
            cnt0(i) = 0;
        end
        if cnt1(i+1)!=0
            cnt1(i) = 0;
        end
    end

    disp(["Num of 1 actual: ",num2str(sum(data))  , "  expected: ", num2str(2^(srnum-1))   ] )
    disp(["Num of 0 actual: ",num2str(N-sum(data)), "  expected: ", num2str(2^(srnum-1)-1) ] )
    for k=1:srnum
        message = ["Num of Cont. Times ",num2str(k)];
        message = [message," actual0: ", num2str(sum(cnt0==k))];
        message = [message," actual1: ", num2str(sum(cnt1==k))];
        message = [message,"  expected:", num2str(2^(srnum-k-1))];
        disp(message)
    end

end

function output = prbs(time, srnum)
    % ref) https://qiita.com/Fuminori_Souma/items/847566b80c47ae7766c1

    % time:時間  srnum:シフトレジスタ数

    % シフトレジスタの数毎の、xorのタップ位置（最後のシフトレジスタと、どれかのシフトレジスタのxor）
    eachtap = [1 0 0 0 0 0 0 0 0;
               1 1 0 0 0 0 0 0 0;
               1 0 1 0 0 0 0 0 0;
               1 0 0 1 0 0 0 0 0;
               0 1 0 0 1 0 0 0 0;
               1 0 0 0 0 1 0 0 0;
               1 0 0 0 0 0 1 0 0;
               0 0 0 0 0 0 0 0 0; % シフトレジスタ数が8の時は、xor1つのみでは（n^2-1周期の信号を生成できない）
               0 0 0 1 0 0 0 0 1];
    z = eachtap(srnum, 1:srnum); % 選択したシフトレジスタの数に合わせたxorのタップ数を抽出
    postap = find(z==1, 1);      % 最後のシフトレジスタ以外のタップ位置を抽出
    output = 0;

    for i = 1 : time

        output(i) = xor(z(postap), z(srnum));

        % それぞれのシフトレジスタの出力を更新
        for j = srnum : -1 : 2

            z(j) = z(j - 1);
        end
        z(1) = output(i); % xor出力と直接繋がるシフトレジスタのみ、xorの出力で初期化
    end

    output(output == 0) = -1; % -1と1の二値信号にするため、0を-1に置換

%     plot(0:length(output) - 1, output); % テスト用

end
