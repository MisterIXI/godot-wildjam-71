extends Node3D

# SNAKE SPEED CAN BE CHANGE BY DIFFICULT AND ON HIT
var snake_speed : float = 15
var default_speed : float =15
@export var is_active :bool = true

# TIMER
@onready var timer : Timer =$Timer
@onready var speed_timer: Timer =$SpeedTimer

@onready var animate : AnimationPlayer = $snek/AnimationPlayer
@onready var angry_animator : AnimationPlayer =$AngryPlayer
# Player
@export var player_node : Node3D  = null

func _ready():
	#initial settings
	#snake_speed = Driving_Stage_Manager.current_stage_difficult.snakeSpeed
	timer.timeout.connect(on_timer_timeout)
	speed_timer.timeout.connect(on_speedTimer_timeout)
	Driving_Stage_Manager.player_hit.connect(on_player_hit)


func _process(_delta):
	if !is_active:
		return
	# get player progre
	handle_movement(_delta)

# ON COOLDOWN ENDS SNAKE WILL START WALKING
func on_timer_timeout():
	print ("timeout and speed")
	snake_speed = default_speed
	animate.play("idle")
	is_active = true

# ON SPEED TIMER TIMEOUT GET NEW PLAYER SPEED
func on_speedTimer_timeout():
	if is_active:
		snake_speed = maxf(default_speed, player_node.global_position.distance_to(global_position)/3)
		angry_animator.play("set_fokus")
		print ("snake speed: %d" % snake_speed)

# ON PLAYER HIT SNAKE WILL STOP WALKING
func on_player_hit():
	animate.play("hurt")
	is_active = false
	snake_speed = 0
	timer.start()

# HANDLE MOVEMENT EQUALS THE DIFFICULT
func handle_movement(_delta : float):
	global_transform.origin = global_position + (Vector3.RIGHT *_delta * snake_speed)
