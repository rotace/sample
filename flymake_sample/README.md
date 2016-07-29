flymakeの動作確認プログラム群
============================

### 仕組み
1. flymakeモードは，ソースコードに変更があると，
ソースコード群を変数${CHK_SOURCES}に渡して，
make check-syntaxを実行する．
2. Makefile内に，ターゲットcheck-syntaxが実行されるように記述しておく．
このとき，シンタックスエラーのみを出力するように，
オプション-fsyntax-onlyをつけておく．
3. gcc/g++から出力されたシンタックスエラー情報をflymakeモードが解読し，
エラー箇所にハイライト表示を行う．

詳細はMakefile　OR　readmeを参照


#### test1
Makefileでflymake設定  
インクルードファイルなし

#### test2
elispでflymake設定  
→makefileに記述不要  
ソースコードがディレクトリをまたぐ場合，flymakeは外部ソースを含めてチェックできない．  
→elispの設定の使用上仕方ない  
インクルードファイルなし
  
#### test3
Makefileでflymake設定  
インクルードファイルあり  
