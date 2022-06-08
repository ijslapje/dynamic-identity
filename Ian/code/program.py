from msilib.schema import Error
from numpy import true_divide
from pygame.locals import *
from OpenGL.GL import *
import pygame as pg
import graphics as graphics
import balls as balls
import configparser as cfg

WIDTH = 1920
HEIGHT = 1080
TARGET_FPS = 60
WINDOW_TITLE = "sjeff"
FULLSCREEN = "False"

#setting up:
def loadConfig(cp):
    global WIDTH, HEIGHT, TARGET_FPS, FULLSCREEN
    TARGET_FPS = int(cp.get("DEEZPLAY", "target_fps"))
    FULLSCREEN = cp.get("DEEZPLAY", "fullscreen")

def setUp():
    pg.init()
    pg.font.init()
    if(FULLSCREEN.lower() == "true"):
        pg.display.set_mode((WIDTH, HEIGHT), DOUBLEBUF|OPENGL|pg.FULLSCREEN)
    elif(FULLSCREEN.lower() == "false"):
        pg.display.set_mode((WIDTH, HEIGHT), DOUBLEBUF|OPENGL)
    pg.display.set_caption(f"{WINDOW_TITLE}: {WIDTH}x{HEIGHT}")  

#update:
def main():
    isRunning = True

    while isRunning  == True:
        pg.time.Clock().tick(TARGET_FPS)
        for event in pg.event.get():
            if event.type == pg.QUIT:
                pg.quit()
                return
            if event.type == pg.KEYDOWN:
                if event.key == pg.K_SPACE:
                    balls.newBall()
        #update balls.
        glClearColor(0.0, 0.0, 0.0, 1.0)
        glClear(GL_COLOR_BUFFER_BIT)
        
        data = balls.update()
        graphics.drawBalls(data, balls.getAmount())
        pg.display.flip()
    
#entry point:
if __name__ == "__main__":
    cp = cfg.ConfigParser()
    cp.read("config.ini")
    loadConfig(cp)
    setUp()
    graphics.setup()
    balls.setup(cp)
    main()