# Octave-Forge Instrument-Cotrol Package Tutorial

## 使い方  
1. 新しいターミナルを開き，仮想シリアルポート(ttyS0,ttyS1)を生成し，相互接続する  
    $ make connection
2. 新しいターミナルを開き，仮想シリアルポート(ttyS1)のモニター端末を起動する  
    $ make monitor
3. 新しいターミナルを開き，octaveでsample_serialを実行する  
    $ make run

