extends CharacterBody3D

@export var camera: Camera3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED


func _physics_process(_delta):
	_handle_rotation()
	_handle_movement()
	


func _handle_movement():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _handle_rotation():
	pass


func _input(event):
	if event is InputEventMouseMotion:
		print(event.position)
		look_at(camera.project_position(event.position, 1))
		rotation.x = 0
		rotation.z = 0