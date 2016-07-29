
all:


# 仮想シリアルポート(pseudo terminal:pty)の生成及び相互接続
#   検証用に仮想シリアルポートttyS0,ttyS1を生成し，
#   ポート同士をシリアル接続する．
# 
#   ttyS0 : octave用シリアルポート
#   ttyS1 : モニター端末用シリアルポート
# 
#   接続中はmakeターゲット実行ターミナルがロックされるので，
#   別ターミナルを立ち上げて実行すること．
#   コネクション切断はCtrl+C．
# 
#   以下，$ man socat より引用：

# PTY

#        Generates a pseudo terminal (pty) and uses its master side.
#        Another process may open the pty’s slave side using it 
#        like a serial line or terminal.  (example). If both the ptmx 
#        and the openpty mechanisms are available, ptmx is used (POSIX).

# PTY option group

#        These options are intended for use with the pty address type.

#        link=<filename>
#               Generates a symbolic link that points to the actual
#               pseudo terminal (pty). This might help to solve the
#               problem that ptys are generated with more or less  
#               unpredictable  names,  making  it difficult to directly
#               access the socat generated pty automatically. With 
#               this option, the user can specify a "fix" point in the
#               file hierarchy that helps him to access the actual pty 
#               (examｔple).  Beginning with socat version 1.4.3, 
#               the symbolic link is removed when the address  is  
#               closed  (but see option unlink-close).
connection:
	mkdir -p ~/dev
	socat -v PTY,link=${HOME}/dev/ttyS0 PTY,link=${HOME}/dev/ttyS1


# 仮想シリアルポートのモニター端末起動
#   ttyS1をscreenでモニターする．
#   接続中はmakeターゲット実行ターミナルがロックされるので，
#   別ターミナルを立ち上げて実行すること．
monitor:
	screen ${HOME}/dev/ttyS1 38400


# octaveの実行
run:
	octave sample_serial.m
