from dataclasses import dataclass
from typing import List
import pygame as pg
import numpy as np
import program as main

_prop = []
_colors = []

@dataclass
class Ball:
    x: float
    y: float
    vx: float
    vy: float
    r: float
    color : pg.Color

#creating balls:
def randomBall():
    r = np.random.uniform(_prop[4], _prop[5])
    x = np.random.uniform(0, 1920)
    y = np.random.uniform(0, 1080)
    vx = np.random.uniform(_prop[2], _prop[3])
    vy = np.random.uniform(_prop[0], _prop[1])
    return Ball(x, y, vx, vy, r, _randomColor())
def _randomColor():
    r = np.random.randint(0, 255)
    g = np.random.randint(0, 255)
    b = np.random.randint(0, 255)
    return pg.Color(r, g, b, 255)

def genBalls(balls, num):
    balls:List[Ball] = []
    for i in range(num):
        balls.append(genBall(balls))
  
    return balls

def genBall(balls):
    newBall = randomBall()
    while(_validate(balls, newBall) == False):
        newBall = randomBall()
    return newBall

def _validate(balls, newBall):
    for ball in balls:
        if(_getDistance(newBall, ball)  < newBall.r + ball.r ):
            return False
    return True

#simulatie, alles hier zorgt ervoor dat de ballen bewegen.
def updateBalls(balls):#oof het wordt er niet beter op.
    collisions:List[Ball] = []
    for  i in range(len(balls)):
        updatePos(balls[i])

        colision =_isNewCollision(collisions, balls, balls[i], i)
        if(colision != False):
            collisions.append(colision[0])
            collisions.append(colision[1])
    
    transform = _merge(collisions)
    if(transform != False):
        newBalls = []
     
        for ball in balls:
            if(ball not in transform[0]):
                newBalls.append(ball)
        
        #adding new balls
        for i in range(len(transform[1])):
            newBalls.append(transform[1][i])
        print(len(newBalls))
        return newBalls
    
    return balls

#methods for updating pos:
def updatePos(mb):
    newPosX = _checkBound(mb.x, mb.vx, mb.r, main.WIDTH)
    newPosY = _checkBound(mb.y, mb.vy, mb.r, main.HEIGHT)
    _setBall(mb, newPosX[0], newPosX[1], newPosY[0], newPosY[1], mb.r)

def _checkBound(pos, vol, radius, bound):
    pos += vol
    if(pos - radius < 0):
        return (radius + 1, np.abs(vol))
    elif(pos + radius > bound):
        return (bound - radius, -np.abs(vol))
    return (pos, vol)

#check for colision:
def _isNewCollision(collisions, balls, mb, index):
    newCollision = _checkCollision(balls, mb, index)
    if(newCollision != False):
        if(_isDuplecate(collisions, newCollision[0], newCollision[1]) == False):
            return newCollision
    return False

def _isDuplecate(collisions, mb1, mb2):
    for i in range(0, len(collisions) -1, 2):
        if(mb1 == collisions[i] and mb2 == collisions[i+1]):
            return True
        elif(mb2 == collisions[i] and mb1 == collisions[i+1]):
            return True
    return False

def _checkCollision(balls, mb, index):
    for i in range(len(balls)):
        if (_getDistance(mb, balls[i]) < mb.r + balls[i].r and index != i):
            return (mb, balls[i])
    return False

#methods for merging:
def _merge(colBall):#niet vergeten reavaluate te maken
    removeBalls:list[Ball] = []
    createBalls:list[Ball] = []

    for i in range(0, len(colBall)-1, 2):
        if(_isMerged(colBall[i], colBall[i+1]) != False):
            removeBalls.append(colBall[i])
            removeBalls.append(colBall[i+1])
            createBalls.append(_mergeBall(colBall[i], colBall[i+1]))
    
    if(removeBalls == [] or createBalls == []):
        return False
    
    return(removeBalls, createBalls)

def _isMerged(mb1, mb2):
    dist = _interpBalls(mb1, mb2, 0.025)
    if(dist < np.sqrt(2)*(mb1.r + mb2.r)/4):

        return (mb1, mb2)
    return False

def _interpBalls(mb1, mb2, rate):
    mb1.y = (mb1.y*(1-rate)+mb2.y*rate)+mb1.vx
    mb1.x = (mb1.x*(1-rate)+mb2.x*rate)+mb2.vy
    mb1.color = pg.Color.lerp(mb1.color, mb2.color, rate)
    return _getDistance(mb1, mb2)

def _mergeBall(mb1, mb2):
    r = np.sqrt(2)*(mb1.r /2 + mb2.r /2)
    vy = (mb1.vx + mb2.vx) / 2
    vx = (mb1.vy + mb2.vy) / 2
    return Ball(mb1.x,mb1.y,vx,vy,r, mb1.color)

#utility methods:
def _getDistance(mb1, mb2):
    dx = (mb1.x + mb1.r) - (mb2.x + mb2.r)
    dy = (mb1.y + mb1.r) - (mb2.y + mb2.r)
    return np.sqrt(dx*dx + dy * dy)
    
def _setBall(ball, x, vx, y, vy, r):
    ball.x= x
    ball.y = y
    ball.vx = vx
    ball.vy = vy
    ball.r = r

#public stuff
def setup(prop):
    global _prop
    _prop = prop