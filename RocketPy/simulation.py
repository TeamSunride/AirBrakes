
"""
CG position needs to be validated
CD values need to be calculated (currently using values found online)
Solid motor propellent information needs to be added

"""


from rocketpy import Environment, Flight, Rocket, SolidMotor, GenericMotor
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
env = Environment(latitude=32.990254, longitude=-106.974998, elevation=1400)

tomorrow = datetime.date.today() + datetime.timedelta(days=1)
env.set_date((tomorrow.year,tomorrow.month,tomorrow.day,12))
env.set_atmospheric_model(type="Forecast", file="GFS")
'''

Pro75M1670 = SolidMotor(
    thrust_source="Cesaroni_M1670.eng",
    dry_mass=1.815,
    dry_inertia=(0.125, 0.125, 0.002),
    nozzle_radius=33 / 1000,
    grain_number=5,
    grain_density=1815,
    grain_outer_radius=33 / 1000,
    grain_initial_inner_radius=15 / 1000,
    grain_initial_height=120 / 1000,
    grain_separation=5 / 1000,
    grains_center_of_mass_position=0.397,
    center_of_dry_mass_position=0.317,
    nozzle_position=0,
    burn_time=3.9,
    throat_radius=11 / 1000,
    coordinate_system_orientation="nozzle_to_combustion_chamber",
)
'''
AeroTechK550W = GenericMotor(
   thrust_source="AeroTech_K550W.eng",
   chamber_radius=54/(2*1000),          # from thrustcurve.org
   chamber_height=438/1000,              # from thrustcurve.org
   chamber_position= +438/(2*1000),     # midpoint of chamber from origin (nozzle)
   dry_mass=1.487,                      # from thrustcurve.org
   propellant_initial_mass=0.889,       # from thrustcurve.org
   dry_inertia=(0.125, 0.125, 0.002), #copied from pro75M example need to find
   nozzle_radius= 54/(2*1000),          # dia = 54 mm
   burn_time=3.9,
   nozzle_position=0,
   coordinate_system_orientation="nozzle_to_combustion_chamber"
) 

x4 = Rocket(
    radius=9.8 / (2* 100),                      # dia = 9.8cm
    mass=3.597,                                 # OpenRocket estimate
    inertia=(6.321, 6.321, 0.034),              # copied from Rocketpy example
    power_off_drag="powerOffDragCurve.csv",     # drag needs change
    power_on_drag="powerOnDragCurve.csv",
    center_of_mass_without_motor=0,
    coordinate_system_orientation="tail_to_nose",
)

x4.add_motor(AeroTechK550W, position=-(1.33 - 0.686 - 41/(2*1000))) # position needs to be checked again [Total length - CG pos]

rail_buttons = x4.set_rail_buttons(
    upper_button_position=0.0818,
    lower_button_position=-0.2,
    angular_position=45,
)

NoseCone = x4.add_nose(length=0.30, kind="ogive", position=0.815)

fin_set = x4.add_trapezoidal_fins(
    n=4,
    root_chord= 15/100,         # from OR 15 cm
    tip_chord= (15 -6) / 100,
    span=15/100,
    position=-(1.33-0.687 - 15/(2*100)), # Total length - CG pos - midpoint of fin
    cant_angle=0,
    sweep_angle=21.8,           # OR fins only have forward sweep edit this
    airfoil=None,
)

""" tail = calisto.add_tail(
    top_radius=0.0635, bottom_radius=0.0435, length=0.060, position=-1.194656
) """


main = x4.add_parachute(
    name="main",
    cd_s=10.0,
    trigger=800,      # ejection altitude in meters
    sampling_rate=105,
    lag=1.5,
    noise=(0, 8.3, 0.5),
)

drogue = x4.add_parachute(
    name="drogue",
    cd_s=1.0,
    trigger="apogee",  # ejection at apogee
    sampling_rate=105,
    lag=1.5,
    noise=(0, 8.3, 0.5),
)

#x4.plots.static_margin()
#x4.draw()

test_flight = Flight(
    rocket=x4, environment=env, rail_length=5.2, inclination=85, heading=0
    )

test_flight.info()
test_flight.plots.trajectory_3d()