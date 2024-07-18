extends VehicleBody3D

# CAR CONTROLLER , FUNCTIONS JUMP, STEER LEFT AND RIGHT, DISABLE
# IMPORT CARSETTINGS
@export var car_settings : CarSettings
@export var ui_controller: UI_Controller
@onready var grounded_object : Node3D = $Ground

# VARIABLES JUMPING
var is_jumping :bool = false
var current_jumps = 0
var is_current_jumping : bool = false
const MAX_JUMPS : int =1 
const JUMPOWER : float = 2.5
const ANGULAR_VELOCITY_DECAY : float = 0.96

# VARIABLE HEALTH
var current_health : float  = 1
const MAX_HEALTH : float = 1

# VARIABLE DISABLE
var current_driving : bool = true

# VARIABLE STEERINGS
var move_direction: Vector2 = Vector2.ZERO
var current_steering : float = 20.0
var last_pos : Vector3  = Vector3.ZERO
var current_speed_mps : float = 0.0
var start_rotation : Vector3  = Vector3.ZERO
var is_handbrake : bool = false
# EXPORT WHEELS
@export var wheel_rear_left : VehicleWheel3D
@export var wheel_rear_right : VehicleWheel3D

# EXPORT BRAKELIGHTS
@export var light_brake_left : OmniLight3D
@export var light_brake_right : OmniLight3D

# EXPORT STREET DIRT
@export var particles_left : CPUParticles3D
@export var particles_right: CPUParticles3D

# EXPORT HUD_KMH
@export var hud_kmh_text : Label  = null

######################################  INPUT ############################
func _input(_event):
	# GET INPUT AXIS TO VECTOR2D
	move_direction = Input.get_vector("right","left","down","up")
	if move_direction.y > 0:
		particles_left.lifetime = 0.12
		particles_right.lifetime = 0.12
	else:
		particles_left.lifetime = 0.01
		particles_right.lifetime = 0.01
	# SET JUMPING
	if _event.is_action_pressed("space"):
		if !is_grounded() && global_position.y < 1.6:
			global_rotation = start_rotation
			return
		if is_grounded():
			is_jumping = true
	if _event.is_action_released("space"):
		is_jumping = false


	if _event.is_action_pressed("shift"):
		print("handbrake")
		is_handbrake = true

	if _event.is_action_released("shift"):
		is_handbrake = false



################################ START
func _ready():
	start_rotation = global_rotation
	Driving_Stage_Manager.set_player(self)
	
func get_speed_kph():
	return current_speed_mps * 3600.0 /1000.0

func _process(_delta : float):
	var speed = get_speed_kph()
	
	ui_controller.set_tacho(speed)

func _physics_process(_delta):
	current_speed_mps = (global_position- last_pos).length() / _delta
	# DIABLE VEHICLE CONTROL CHECK
	if !current_driving:
		return
	handle_acceleration()
	handle_steering()
	handle_jumping()
	last_pos = global_position


func handle_acceleration():
	# ENGINE FORCE
	engine_force = move_direction.y * car_settings.cs_engine_force
	if is_handbrake:
		
		wheel_rear_left.engine_force = car_settings.cs_handbrake_power * move_direction.y
		wheel_rear_right.engine_force = car_settings.cs_handbrake_power * move_direction.y
	if !is_handbrake:
		wheel_rear_left.engine_force = car_settings.cs_engine_force * move_direction.y 
		wheel_rear_right.engine_force = car_settings.cs_engine_force * move_direction.y

	# BRAKE FORCE
	brake = move_direction.y * car_settings.cs_brake_force
	if move_direction.y < 0:
		light_brake_left.light_energy = 0.7
		light_brake_right.light_energy = 0.7
	else:
		light_brake_left.light_energy = 0
		light_brake_right.light_energy = 0

func get_hit_speed():
	apply_impulse(Vector3.RIGHT * 20000, Vector3.ZERO)
	


func handle_steering():
	if is_handbrake:
		current_steering = car_settings.cs_max_steering_handbrake
		wheel_rear_left.wheel_friction_slip = car_settings.cs_friction_slip.x
		wheel_rear_right.wheel_friction_slip = car_settings.cs_friction_slip.x
	if !is_handbrake:
		current_steering = car_settings.cs_max_steering
		wheel_rear_left.wheel_friction_slip = car_settings.cs_friction_slip.y
		wheel_rear_right.wheel_friction_slip = car_settings.cs_friction_slip.y

	steering = deg_to_rad(move_direction.x * current_steering)

func handle_jumping():
	## FLIP CAR 
	if(is_jumping and current_jumps < MAX_JUMPS):
		is_current_jumping = true
		current_jumps += 1
		linear_velocity += Vector3.UP * JUMPOWER
		
	elif is_grounded() :
		current_jumps = 0
		is_current_jumping = false
		


func is_grounded() -> bool :
	return grounded_object.global_position.y < 0
