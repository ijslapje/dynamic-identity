import configparser as cfg
import balls_simulation as ballSim
import balls_data as ballData


def setup(cp):
    prop = []
    prop.append(float(cp.get("BALLZ", "velocityYMin")))
    prop.append(float(cp.get("BALLZ", "velocityYMax")))
    prop.append(float(cp.get("BALLZ", "velocityXMin")))
    prop.append(float(cp.get("BALLZ", "velocityXMax")))
    prop.append(float(cp.get("BALLZ", "radiusMin")))
    prop.append(float(cp.get("BALLZ", "radiusMax")))
    ballSim.setup(prop)
    ballData.setup(int(cp.get("BALLZ", "start_amount")))

def update():
    return ballData.update()

def newBall():
    ballData.newBall()

def getAmount():
    return ballData.getAmount()

