

all: compile run

compile	:
	gcc -g image-viewer.c -o image-viewer `pkg-config --cflags --libs gtk+-2.0`

run	:
	./image-viewer images.jpeg

