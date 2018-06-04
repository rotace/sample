# coding: UTF-8
import urllib
from bs4 import BeautifulSoup

url = "http://www.nikkei.com/"

html = urllib.request.urlopen(url)

soup = BeautifulSoup(html, "html.parser")

title_tag = soup.title
title = title_tag.string
print(title_tag)
print(title)

