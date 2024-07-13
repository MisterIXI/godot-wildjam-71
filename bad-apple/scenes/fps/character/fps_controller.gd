extends CharacterBody3D

@export_group("Movement")
@export_range(1,15) var movement_speed :float = 8.0
@export_range(1,15) var movement_runon : float = 3
@export_range(1,15) var movement_falloff : float = 0.3
@export_range(1,15) var jump_velocity : float = 5
@export_range(1,50) var gravity : float = 15.0

@export_group("Direction")
@export_range(1,100) var mouse_sensitivity : float = 50
@export var clamp_angle : Vector2 = Vector2(-45, 45)

var _camera : Camera3D
var vel_x : float = 0
var vel_z : float = 0

func _ready():
	for child in get_children():
		if child is Camera3D:
			_camera = child
			break
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	_handle_movement(delta)


func _handle_movement(delta : float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = jump_velocity

	var input = Input.get_vector("left", "right", "up", "down")

	var max_speed = movement_speed
	if Input.is_action_pressed("shift"):
		max_speed /= 2

	if input.x:
		vel_x = move_toward(vel_x, input.x * max_speed, movement_runon)
	else:
		vel_x = move_toward(vel_x, 0, movement_falloff)

	if input.y:
		vel_z = move_toward(vel_z, input.y * max_speed, movement_runon)
	else:
		vel_z = move_toward(vel_z, 0, movement_falloff)

	velocity = transform.basis * Vector3(vel_x, velocity.y, vel_z)
	move_and_slide()


func _unhandled_input(event) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var mouse_delta = event.relative * -1

		rotate_y(mouse_delta.x * (mouse_sensitivity / 10000))
		_camera.rotate_x(mouse_delta.y * (mouse_sensitivity / 10000))
		_camera.rotation.x = clamp(_camera.rotation.x, deg_to_rad(clamp_angle.x), deg_to_rad(clamp_angle.y))
