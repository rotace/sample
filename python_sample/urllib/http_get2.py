# reference web
# https://qiita.com/furipon/items/ac7e1df18dc60e4d6782

import urllib.request
import urllib.parse

params = {"zipcode":"4200855"}
encodeParams = urllib.parse.urlencode(params)
print(encodeParams)

with urllib.request.urlopen("http://zipcloud.ibsnet.co.jp/api/search?" + encodeParams) as res:
    html = res.read().decode("utf-8")
    print(html)
