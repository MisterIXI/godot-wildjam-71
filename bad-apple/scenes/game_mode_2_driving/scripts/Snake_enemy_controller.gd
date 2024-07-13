extends Node3D

# SNAKE SPEED CAN BE CHANGE BY DIFFICULT AND ON HIT
var snake_speed : float = 15
var default_speed : float =15


# TIMER
@onready var timer : Timer =$Timer
@onready var animate : AnimationPlayer = $snek/AnimationPlayer

func _ready():
	#initial settings
	#snake_speed = Driving_Stage_Manager.current_stage_difficult.snakeSpeed
	timer.timeout.connect(on_timer_timeout)
	Driving_Stage_Manager.player_hit.connect(on_player_hit)


func _process(_delta):
	# get player progre
	handle_movement(_delta)

# ON COOLDOWN ENDS SNAKE WILL START WALKING
func on_timer_timeout():
	print ("timeout and speed")
	snake_speed = default_speed
	animate.play("idle")

# ON PLAYER HIT SNAKE WILL STOP WALKING
func on_player_hit():
	animate.play("hurt",-1, 1)

	snake_speed = 0
	timer.start()

# HANDLE MOVEMENT EQUALS THE DIFFICULT
func handle_movement(_delta : float):
	global_transform.origin = global_position + (Vector3.RIGHT *_delta * snake_speed)