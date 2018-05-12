#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys

import pygame
import pygame.locals

SCREEN_SIZE = (640, 480)

pygame.init()
screen = pygame.display.set_mode(SCREEN_SIZE)
pygame.display.set_caption(u"マウスイベント2")

backImg = pygame.image.load("moriyama.jpg").convert()
pythonImg = pygame.image.load("python.png").convert_alpha()

cur_pos = (0,0)    # 蛇の位置
pythons_pos = []   # コピーした蛇の位置リスト

while True:
    screen.blit(backImg, (0,0))

    # マウスクリックで蛇をコピー
    mouse_pressed = pygame.mouse.get_pressed()
    if mouse_pressed[0]:  # 左クリック
        x, y = pygame.mouse.get_pos()
        x -= pythonImg.get_width() / 2
        y -= pythonImg.get_height() / 2
        pythons_pos.append((x, y))  # 蛇の位置を追加

    # マウス移動で蛇を移動
    x, y = pygame.mouse.get_pos()
    x -= pythonImg.get_width() / 2
    y -= pythonImg.get_height() / 2
    cur_pos = (x, y)

    # 蛇を表示
    screen.blit(pythonImg, cur_pos)
    for i, j in pythons_pos:
        screen.blit(pythonImg, (i, j))
    pygame.display.update()

    for event in pygame.event.get():
        if event.type == pygame.locals.QUIT:
            sys.exit()
