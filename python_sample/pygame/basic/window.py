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

while True:
    screen.fill((0, 0, 255))
    pygame.display.update()
    for event in pygame.event.get():
        if event.type == pygame.locals.QUIT:
            sys.exit()

