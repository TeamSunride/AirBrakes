
"""Copied from the RocketPy tutorial --- testing how this works"""


from rocketpy import Environment, Flight, Rocket, SolidMotor
import datetime




#Function for passing drag properties when under no thrust
"""
The RocketPy module uses 'dragCoeff = self.rocket.powerOffDrag.getValueOpt(freestreamMach)' to figure out the drag,
since its a function of time, probably will need to call 'Flight.apogee' to use it in the simulation.
"""
def DragWithAirBrakes(obj=None, controlInput=None):
   file ="RocketPy_tutorial/powerOffDragCurve.csv" 
   return file 


#change to MRC later
env = Environment(railLength=5.2, latitude=32.990254, longitude=-106.974998, elevation=1400)

tomorrow = datetime.date.today() + datetime.timedelta(days=1)
env.setDate((tomorrow.year,tomorrow.month,tomorrow.day,12))
env.setAtmosphericModel(type="Forecast", file="GFS")

J460 = SolidMotor(
    thrustSource="AeroTech_J460T.eng",
    burnOut=1.8,
    grainNumber=3,
    grainSeparation=3 / 1000,
    grainDensity=1815,
    grainOuterRadius=22 / 1000,
    grainInitialInnerRadius=15 / 1000,
    grainInitialHeight= 230 / 1000,
    nozzleRadius=54 / 1000,
    throatRadius=0.0079502,
    interpolationMethod="linear",
)

Calisto = Rocket(
    motor=J460,
    radius=0.05,
    mass=4.25 - 0.415,
    inertiaI= 4.6,
    inertiaZ=0.035,
    distanceRocketNozzle=-0.7,
    distanceRocketPropellant=-0.5,
    powerOffDrag=DragWithAirBrakes(),
    powerOnDrag="RocketPy_tutorial/powerOnDragCurve.csv",
)

Calisto.setRailButtons([0.2, -0.5])

NoseCone = Calisto.addNose(length=0.55829, kind="vonKarman", distanceToCM=0.71971)

FinSet = Calisto.addTrapezoidalFins(
    n=4,
    rootChord=0.120,
    tipChord=0.040,
    span=0.100,
    distanceToCM=-0.54956,
    cantAngle=0,
    radius=None,
    airfoil=None,
)

"""

def drogueTrigger(p, y):
    # p = pressure
    # y = [x, y, z, vx, vy, vz, e0, e1, e2, e3, w1, w2, w3]
    # activate drogue when vz < 0 m/s.
    return True if y[5] < 0 else False


def mainTrigger(p, y):
    # p = pressure
    # y = [x, y, z, vx, vy, vz, e0, e1, e2, e3, w1, w2, w3]
    # activate main when vz < 0 m/s and z < 800 + 1400 m (+1400 due to surface elevation).
    return True if y[5] < 0 and y[2] < 800 + 1400 else False


Main = Calisto.addParachute(
    "Main",
    CdS=10.0,
    trigger=mainTrigger,
    samplingRate=105,
    lag=1.5,
    noise=(0, 8.3, 0.5),
)

Drogue = Calisto.addParachute(
    "Drogue",
    CdS=1.0,
    trigger=drogueTrigger,
    samplingRate=105,
    lag=1.5,
    noise=(0, 8.3, 0.5),
)


"""
TestFlight = Flight(rocket=Calisto, environment=env, inclination=85, heading=0, terminateOnApogee=True)
TestFlight.allInfo()