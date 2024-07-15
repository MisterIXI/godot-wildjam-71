extends VehicleBody3D

############## VARIABLES ###########################

### exports

@export var MAX_STEERING : float = 30.0
@export var SPEED_STEERING_ANGLE : float = 10.0
@export var MAX_STEERING_SPEED : float = 120.0
@export  var MAX_STEERING_INPUT :float  = 90.0
@export var STEERING_SPEED : float = 1.0

@export var final_drive_ratio : float =3.38

@export var steer_curve : Curve = null

@export var MAX_ENGINE_FORCE : float = 700.0
@export var MAX_BRAKE_FORCE : float  = 50.0

@export var particles_left : CPUParticles3D
@export var particles_right: CPUParticles3D

@export var light_brake_left : OmniLight3D
@export var light_brake_right : OmniLight3D

@export var hud_kmh_text : Label  = null
#### onready
@onready var max_steering_angle_rad = deg_to_rad(MAX_STEERING)
@onready var speed_steering_angle_rad = deg_to_rad(SPEED_STEERING_ANGLE)
@onready var max_steering_input_rad = deg_to_rad(MAX_STEERING_INPUT)

@onready var last_pos : Vector3
### privates
var steer_target : float =0.0
var steer_angle : float = 0.0

var move_direction : Vector2 = Vector2.ZERO
var is_jumping : bool  = false
var current_speed_mps : float = 0.0
################################# INPUT
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
		is_jumping = true
	if _event.is_action_released("space"):
		is_jumping = false

################################# FUNCTIONS

func get_speed_kph():
	return current_speed_mps * 3600.0 /1000.0

func _process(_delta : float):
	var speed = get_speed_kph()
	var info = "%.0f km/h" % speed
	hud_kmh_text.text  = info


func _physics_process(delta):
	current_speed_mps = (global_position- last_pos).length() / delta
	var steer_val = clamp(move_direction.x, -1, 1)
	var throttle_val = 0.0
	if move_direction.y > 0.0:
		throttle_val = 1.0
	var brake_val = clamp(move_direction.y,-1,0.0)
	if brake_val == -1:
		brake_val = 1

	if(abs(steer_val) < 0.05):
		steer_val = 0.0
	elif steer_curve:
		if steer_val < 0.0:
			steer_val = -steer_curve.sample_baked(-steer_val)

		else:
			steer_val = steer_curve.sample_baked(steer_val)
	
	
	engine_force = throttle_val *  final_drive_ratio * MAX_ENGINE_FORCE
	if (throttle_val == 0):
		engine_force  = 0
	
	brake =  brake_val * MAX_BRAKE_FORCE

	light_brake_left.visible = brake_val == 1
	light_brake_right.visible = brake_val  == 1

	## reverse brake light   - linear_velocity.x < 0
	var max_steer_speed = MAX_STEERING_SPEED * 1000.0 / 3600.0
	var steer_speed_factor = clamp(current_speed_mps / max_steer_speed, 0.0, 1.0)

	steer_angle = steer_val * lerp(max_steering_angle_rad, speed_steering_angle_rad, steer_speed_factor)
	steering = steer_angle
	last_pos = global_position
