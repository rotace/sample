# reference web
# https://qiita.com/furipon/items/ac7e1df18dc60e4d6782

import urllib.request

with urllib.request.urlopen("http://zipcloud.ibsnet.co.jp/api/search?zipcode=4200855") as res:
    html = res.read(t).decode("utf-8")
    print(html)