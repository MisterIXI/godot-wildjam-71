extends Resource
class_name CarSettings

# vARIABLE STEERING AND DIRECTION
@export var cs_max_steering : float = 20.0
@export var cs_max_steering_handbrake : float =35.0

@export var cs_friction_slip : Vector2 = Vector2(1, 10.5)

# VARIABLE MOTOR
@export var cs_engine_force : float = 100
@export var cs_brake_force : float = 130
@export var cs_handbrake_power : float = 70