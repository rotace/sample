"""
this is a test program.
"""
import sys

import pygame
import pygame.locals

SCREEN_SIZE = (640, 480)

pygame.init()
screen = pygame.display.set_mode(SCREEN_SIZE)
pygame.display.set_caption("Make Window")

sysfont = pygame.font.SysFont(None, 80)
hello1 = sysfont.render("Hello, world!", False, (0,0,0))
hello2 = sysfont.render("Hello, world!", True, (0,0,0))
hello3 = sysfont.render("Hello, world!", True, (255,0,0), (255,255,0))

while True:
    screen.fill((0, 0, 255))

    screen.blit(hello1, (20, 50))
    screen.blit(hello2, (20, 150))
    screen.blit(hello3, (20, 250))

    pygame.display.update()
    
    for event in pygame.event.get():
        if event.type == pygame.locals.QUIT:
            sys.exit()

