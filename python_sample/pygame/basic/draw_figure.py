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

    pygame.draw.rect(screen, (255, 255, 0), pygame.locals.Rect(10, 10, 300, 200))
    pygame.draw.circle(screen, (255, 0, 0), (320, 240), 100)
    pygame.draw.ellipse(screen, (255, 0, 255), (400, 300, 200, 100))
    pygame.draw.line(screen, (255, 255, 255), (0, 0), (640, 480))

    pygame.display.update()
    for event in pygame.event.get():
        if event.type == pygame.locals.QUIT:
            sys.exit()

