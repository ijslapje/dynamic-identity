
from dataclasses import dataclass
from typing import List
import numpy as np
import program as main
import pygame as pg
import configparser as cfg
import balls_simulation as ball

@dataclass
class BallData:
    vx: float
    vy: float
    color : pg.Color

_numBalls = 1
_makeNewBall = 0
_balls: List[ball.Ball] = []
_original_data: List[BallData] = []
_radius = 0 # hacken

#interpolating all the balls;
def _interpolate_all(balls, targetVX, targetVY, targetColor, rate):
    for ball in balls:
        _interpolate_prop(ball, targetVX, targetVY, targetColor, rate)
    return balls
def _isDoneInterpolated(balls, targetVX, targetVY, targetColor):
    isDone = False
    for ball in balls:
        isDone = _isInterpolated(ball, targetVX, targetVY, targetColor)
    return isDone
   
def _interpolate_reset(balls, originalData, rate):
    for i in range(len(balls) - 1):
        _interpolate_prop(balls[i], originalData[i].vx, originalData[i].vy, originalData[i].color, rate)
    return balls
def _isReset(balls, originalData):
    isDone = False
    for i in range(len(balls) - 1):
        isDone = _isInterpolated(balls[i], originalData[i].vx, originalData[i].vy, originalData[i].color)
    return isDone

def _interpolate_prop(ball, targetVX, targetVY, targetColor, rate):
    ball.vx = (ball.vx*(1-rate)+targetVX*rate)
    ball.vy = (ball.vy*(1-rate)+targetVY*rate)
    ball.color = pg.Color.lerp(ball.color, targetColor, rate)

def _isInterpolated(ball, targetVX, targetVY, targetColor):
    isDone = True
    if(ball.vx - targetVX > 0.1):
        isDone = True
    if(ball.vy - targetVY > 0.1) :
        isDone = False
    if(_compareColor(ball.color, targetColor) > 16):
        isDone = False
    return isDone

def _compareColor(color, target):
    diff = np.abs(color.r - target.r)
    diff += np.abs(color.g - target.g)
    diff += np.abs(color.b - target.b)
    return diff / 3

def _getOriginalData(balls):
    ogData = []
    for ball in balls:
        ogData.append(BallData(ball.vx, ball.vy, ball.color))
    return ogData

#use outside of this class:
def setup(numBalls):
    global _balls, _numBalls
    _numBalls = numBalls
    _balls = ball.genBalls(_balls, _numBalls)

def getAmount():
    return len(_balls)

def newBall():
    global _makeNewBall, _original_data
    if(_makeNewBall == 0):
        _makeNewBall = 1
        _original_data.clear()
        _original_data =  _getOriginalData(_balls)

def update():
    global _balls, _makeNewBall, _original_data, _radius

    #wow dit is bad:
    if(_makeNewBall == 1):
        interpData = _interpolate_all(_balls, 0, 0, pg.Color(10,10,10,0), 0.03)
        if(_isDoneInterpolated(_balls, 0, 0, pg.Color(10,10,10,0)) == True):
            _balls.append(ball.genBall(_balls))
            _radius = _balls[len(_balls)-1].r
            _balls[len(_balls)-1].r = 0
            _makeNewBall = 2
        return getData(interpData)

    if(_makeNewBall == 2):
        _balls[len(_balls)-1].r += 1
        if(_balls[len(_balls)-1].r >= _radius):
            _makeNewBall = 3
        return getData(_balls)

    if(_makeNewBall == 3):
        interpData = _interpolate_reset(_balls, _original_data, 0.03)
        if(_isReset(_balls, _original_data)):
            _makeNewBall = 0
        return getData(interpData)

    _balls = ball.updateBalls(_balls)
    return getData(_balls)

#getting data:
def getData(balls):
    data: list[float] = []
    color: list[float] = []
    for  i in range(len(balls)):
        mb:ball.Ball = balls[i]
        data.append(mb.x)
        data.append(mb.y)
        data.append(mb.r)
        color.append(mb.color.r / 255)
        color.append(mb.color.g / 255)
        color.append(mb.color.b / 255)
        color.append(mb.color.a / 255)

    return (data, color)