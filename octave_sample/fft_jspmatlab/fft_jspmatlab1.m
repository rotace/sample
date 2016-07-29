%基本的な信号の生成
clear;                             %作業スペースからすべての変数を消去
n = -4:6;                          %時刻の範囲
dlt = [zeros(1,4) 1 zeros(1,6)];   %単位インパルス
u0 = [zeros(1,4) ones(1,7)];       %単位ステップ
r = [zeros(1,4) (0:6)];            %ランプ信号
alpha = 0.5;			   %定数α
a = [zeros(1,4) alpha.^(0:6)];	   %実数値の指数関数

subplot(2,2,1); stem(n,dlt);	   %単位ステップの図示
xlabel('time n'); ylabel('unit impulse');

subplot(2,2,2); stem(n,u0);        %単位ステップの図示
xlabel('time n'); ylabel('unit step');

subplot(2,2,3); stem(n,r);	   %ランプ信号の図示
xlabel('time n'); ylabel('ramp');

subplot(2,2,4); stem(n,a);         %指数関数の表示
xlabel('time n'); ylabel('exponetial');

pause

%基本的な信号の組み合わせによって得られる信号
clear;                             %作業スペースからすべての変数を消去
n = -10:10;                        %時刻の範囲
x1 = unitimp(n)+unitimp(n-1)+unitimp(n-2);  %単位インパルスの和
x2 = unitstep(n)-unitstep(n-3);    %単位ステップの差
x3 = ramp(n)-ramp(n-3);            %ランプ信号の差
alpha = 0.5;                       %実定数α
x4 = realexp(alpha,n)-realexp(alpha,n-3);  %指数関数の差
subplot(2,2,1); stem(n,x1);                %x1の図示
xlabel('time n'); ylabel('x_1(n)'); grid;
subplot(2,2,2); stem(n,x2);                %x2の図示
xlabel('time n'); ylabel('x_2(n)'); grid;
subplot(2,2,3); stem(n,x3);                %x3の図示
xlabel('time n'); ylabel('x_3(n)'); grid;
subplot(2,2,4); stem(n,x4);                %x4の図示
xlabel('time n'); ylabel('x_4(n)'); grid;

pause

%余弦波と正弦波
clear;                             %作業スペースからすべての変数を消去
w = pi/8;                          %周波数
n = -20:20;                        %時刻の範囲
ejwn = exp(j*w*n);                 %周波数wの複素指数関数
emjwn = exp(-j*w*n);               %周波数-wの複素指数関数
coswn = (ejwn+emjwn)/2;            %余弦波
sinwn = (ejwn-emjwn)/(2j);         %正弦波
subplot(2,1,1); stem(n,coswn); grid;  %余弦波の図示
xlabel('time n'); ylabel('cos \omega n'); 
subplot(2,1,2); stem(n,sinwn); grid;  %正弦波の図示
xlabel('time n'); ylabel('sin \omega n');

pause

%白色ガウス信号(ホワイトノイズ)と正弦波信号
clear;                             %作業スペースからすべての変数を消去
n = 0:50;                          %時刻の範囲
mu = 0; sigma2 = 0.1;              %平均と分散
sigma = sqrt(sigma2);              %標準偏差
g = sigma*(randn(size(n))-mu);     %平均mu, 標準偏差sigmaの白色ガウス信号
w = pi/8;                          %周波数
s = sin(w*n);                      %正弦波
x = s+g;                           %白色ガウス信号が加わった正弦波
subplot(3,1,1); stem(n,g); grid;   %白色ガウス信号の図示
xlabel('time n'); ylabel('g(n)');
subplot(3,1,2); stem(n,s); grid;   %正弦波の図示
xlabel('time n'); ylabel('s(n)');
subplot(3,1,3); stem(n,x); grid;   %白色ガウス信号が加わった正弦波の図示
xlabel('time n'); ylabel('x(n)');

pause

%離散時間フーリエ変換の計算例
clear;                           %作業スペースからすべての変数を消去
x = [1 2 4 2 1]/10;              %信号x
n = -1:3;                        %時刻の範囲
w = linspace(-pi,pi,512);        %周波数[-π,π]を512等分
X = dtft(x,n,w);                 %信号xの離散時間フーリエ変換X
magX = abs(X); argX = angle(X);  %Xの振幅と位相
subplot(3,1,1); plot(n,x); grid;
xlabel('\time [s]'); ylabel('x');
subplot(3,1,2); plot(w,magX); grid;  %振幅スペクトル|X|の図示
xlabel('\omega [rad]'); ylabel('|X|');
subplot(3,1,3); plot(w,argX); grid;  %位相スペクトル∠Xの図示
xlabel('\omega [rad]'); ylabel('\angle X');
 
pause

%離散時間フーリエ変換の計算例
clear;                           %作業スペースからすべての変数を消去
alpha = 0.8;                     %定数
theta = pi/4;                    %周波数
n = 0:512;                       %時刻の範囲
a = realexp(alpha,n);            %指数関数a
w = linspace(-pi,pi,512);        %周波数[-π,π]を512点に等分
A = dtft(a,n,w); magA = abs(A);  %aの離散時間フーリエ変換と振幅スペクトル
x = realexp(alpha,n).*sin(theta*n);  %減衰する正弦波x
X = dtft(x,n,w); magX = abs(X);      %xの離散時間フーリエ変換と振幅
subplot(2,2,1); plot(n(1:50),a(1:50)); grid;  
xlabel('time [s]'); ylabel('x');
subplot(2,2,2); plot(n(1:50),x(1:50)); grid;  
xlabel('time [s]'); ylabel('x');
subplot(2,2,3); plot(w,magA); grid;  %振幅スペクトル|A|の図示
xlabel('\omega [rad]'); ylabel('|A|');
subplot(2,2,4); plot(w,magX); grid;  %振幅スペクトル|X|の図示
xlabel('\omega [rad]'); ylabel('|X|');

pause

%指数関数plot
subplot(2,2,1); plot(w,0.5*(A+conj(A))); grid;  
xlabel('\omega [rad]'); ylabel('realA');
subplot(2,2,2); plot(w,0.5*j*(A-conj(A))); grid;  
xlabel('\omega [rad]'); ylabel('imagA');
subplot(2,2,3); plot(w,abs(A)); grid;  %振幅スペクトル|A|の図示
xlabel('\omega [rad]'); ylabel('|A|');
subplot(2,2,4); plot(w,angle(A)); grid;  %振幅スペクトルangleXの図示
xlabel('\omega [rad]'); ylabel('angleA');

pause

%減衰関数plot
subplot(2,2,1); plot(w,0.5*(X+conj(X))); grid;  
xlabel('\omega [rad]'); ylabel('realX');
subplot(2,2,2); plot(w,0.5*j*(X-conj(X))); grid;  
xlabel('\omega [rad]'); ylabel('imagX');
subplot(2,2,3); plot(w,abs(X)); grid;  %振幅スペクトル|X|の図示
xlabel('\omega [rad]'); ylabel('|X|');
subplot(2,2,4); plot(w,angle(X)); grid;  %振幅スペクトルangleXの図示
xlabel('\omega [rad]'); ylabel('angleX');

pause

%離散時間フーリエ逆変換の動作確認
close;
clear;                          %作業スペースからすべての変数を消去
n = -1:2;                       %時刻の範囲
x = [-1 3 2 4]                  %信号
w = linspace(-pi,pi,1024);      %周波数[-π〜π]の区間を1024点に等分割
X = dtft(x,n,w);                %xの離散時間フーリエ変換Xを計算
xx = invdtft(X,w,n)             %Xの逆変換xxを計算
er = sqrt(sum(abs(xx-x).^2))/length(n)  %xxとxの平均誤差を計算

pause

%離散時間フーリエ逆変換の計算
clear;                             %作業スペースからすべての変数を消去
w = linspace(-pi,pi,512);          %周波数，[-π,π]を512等分
n = -10:10; %時刻の範囲
X1 = exp(-j*2*w).*(cos(w/2)).^4;   %周波数スペクトルX1
x1 = invdtft(X1,w,n);              %X1の逆変換
alpha = 0.5;                       %定数
X2 = alpha./(1-alpha*exp(-j*w));   %周波数スペクトルX2
x2 = invdtft(X2,w,n);              %X2の逆変換
subplot(2,2,1); plot(w,abs(X1)); grid;	%振幅スペクトル|X1|の図示
xlabel('\omega [rad]'); ylabel('|X_1|');
subplot(2,2,2); stem(n,real(x1)); grid; %信号x1の図示
xlabel('time n'); ylabel('x_1(n)');
subplot(2,2,3); plot(w,abs(X2)); grid;	%振幅スペクトル|X2|の図示
xlabel('\omega [rad]'); ylabel('|X_2|');
subplot(2,2,4); stem(n,real(x2)); grid; %信号x2の図示
xlabel('time n'); ylabel('x_2(n)');

pause

%パーセバルの関係の数値的な確認
close;
clear;                             %作業スペースからすべての変数を消去
printf('\n\nParsevals theorem\n')
n = 0:512;                         %時刻の範囲
alpha = 1/sqrt(2);                 %定数
x = realexp(alpha,n);              %信号x
w = linspace(-pi,pi,512);          %周波数，[-π,π]を512等分
dw = w(2)-w(1);                    %周波数のきざみ
X = dtft(x,n,w);                   %信号xの離散時間フーリエ変換
xxenergy = x*x'                    %信号xのエネルギー（時間領域）
XXenegy = 1/(2*pi)* X*X'*dw        %信号xのエネルギー（周波数領域）

pause
