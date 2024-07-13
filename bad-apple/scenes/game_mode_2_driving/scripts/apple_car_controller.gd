extends VehicleBody3D

# CAR CONTROLLER , FUNCTIONS JUMP, STEER LEFT AND RIGHT, DISABLE

# VARIABLES JUMPING
var is_jumping :bool = false
var current_jumps = 0
var is_current_jumping : bool = false
const MAX_JUMPS : int =1 
const JUMPOWER : float = 6.0
const ANGULAR_VELOCITY_DECAY : float = 0.96

# VARIABLE HEALTH
var current_health : float  = 1
const MAX_HEALTH : float = 1

# VARIABLE DISABLE
var current_driving : bool = true

# VARIABLE STEERINGS
const MAX_STEERING : float = 25.0
const MAX_STEERING_HANDBRAKE : float =50.0
var current_steering : float = 25.0
var move_direction: Vector2 = Vector2.ZERO
var friction_slip : Vector2 = Vector2(0.02, 0.845)

# VARIABLE MOTOR
const ENGINE_POWER : float = 1000
const BRAKE_POWER : float = 1000
const HANDBRAKE_POWER : float = 700

# EXPORT WHEELS
@export var wheel_rear_left : VehicleWheel3D
@export var wheel_rear_right : VehicleWheel3D

# EXPORT BRAKELIGHTS
@export var light_brake_left : OmniLight3D
@export var light_brake_right : OmniLight3D

# EXPORT STREET DIRT
@export var particles_left : CPUParticles2D
@export var particles_right: CPUParticles2D

######################################  INPUT ############################
func _input(_event):
	# GET INPUT AXIS TO VECTOR2D
	move_direction = Input.get_vector("right","left","down","up")
	
	# SET JUMPING
	if _event.is_action_pressed("space"):
		is_jumping = true
	if _event.is_action_released("space"):
		is_jumping = false

	# SET HANDBRAKE
	if _event.is_action_pressed("shift"):
		current_steering = MAX_STEERING_HANDBRAKE
		wheel_rear_left.wheel_friction_slip = friction_slip.x
		wheel_rear_right.wheel_friction_slip = friction_slip.x

		wheel_rear_left.engine_force = HANDBRAKE_POWER * move_direction.y
		wheel_rear_right.engine_force = HANDBRAKE_POWER * move_direction.y

	if _event.is_action_released("shift"):
		current_steering = MAX_STEERING
		wheel_rear_left.wheel_friction_slip = friction_slip.y
		wheel_rear_right.wheel_friction_slip = friction_slip.y

func _physics_process(_delta):

	# DIABLE VEHICLE CONTROL CHECK
	if !current_driving:
		return
	handle_acceleration()
	handle_steering()
	handle_jumping()

	# IF ALLREADY FLYING
	if is_current_jumping:
		handle_flying()

func handle_acceleration():
	# ENGINE FORCE
	engine_force = move_direction.y * ENGINE_POWER
	# BRAKE FORCE
	brake = move_direction.y * BRAKE_POWER
	if brake > 5:
		light_brake_left.light_energy = brake /2
		light_brake_right.light_energy = brake /2
	if brake < 5:
		light_brake_left.light_energy = 0.5
		light_brake_right.light_energy = 0.5
func handle_steering():
	steering = deg_to_rad(move_direction.x * current_steering)

func handle_jumping():
	if is_jumping && linear_velocity.x < 0.3 && linear_velocity.y < 0.3 && rotation.z != 0:
		rotation.z = 0

	elif(is_jumping and current_jumps < MAX_JUMPS):
		is_current_jumping = true
		current_jumps += 1
		linear_velocity += Vector3.UP * JUMPOWER
		
	elif linear_velocity.y < 0.3 :
		current_jumps = 0
		is_current_jumping = false
		


func handle_flying():
	add_constant_torque(Vector3.RIGHT * 8 * move_direction.y)
	angular_velocity *= ANGULAR_VELOCITY_DECAY