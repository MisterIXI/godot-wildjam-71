extends Camera3D

@export var car : VehicleBody3D  = null
@export var target_distance : float = 4.2
@export var target_height : float = 1.4 ### default 1.4

# CAMERA LERP SPEED
var camera_lerp_speed : float = 20.0
# FOLLOW TARGET 
var follow_target  =null

# LAST LOOKAT POSITION
var last_lookat

func _ready():
	follow_target = car
	last_lookat = follow_target.global_transform.origin

func _physics_process(_delta):
	followTargetPos(_delta)

func followTargetPos(_delta):
	var delta_v = global_transform.origin - follow_target.global_transform.origin
	var target_new_position = global_transform.origin

	delta_v.y = 0.0

	if(delta_v.length() > target_distance):
		delta_v= delta_v.normalized() * target_distance
		delta_v.y = target_height
		target_new_position = follow_target.global_transform.origin + delta_v
	
	else:
		target_new_position.y = follow_target.global_transform.origin.y + target_height
	
	# SET NEW POSITION
	global_transform.origin = global_transform.origin.lerp(target_new_position, _delta * camera_lerp_speed)
	last_lookat = last_lookat.lerp(follow_target.global_transform.origin, _delta * camera_lerp_speed)

	look_at(last_lookat, Vector3(0.0,1,0))
