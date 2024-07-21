extends CharacterBody3D

@export var camera: Camera3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var last_mouse_pos = Vector2(0,0)
var mouse_position_3D = Vector3(0,0,0)


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


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
	var viewport := get_viewport()
	var _mouse_position := viewport.get_mouse_position()
	var _camera := viewport.get_camera_3d()
	var origin := _camera.project_ray_origin(_mouse_position)
	var direction := _camera.project_ray_normal(_mouse_position)
	var ray_length := camera.far
	var end := origin + direction * ray_length
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	var result := space_state.intersect_ray(query)
	if not result.is_empty():
		mouse_position_3D = result["position"]
	print(mouse_position_3D)


	look_at(mouse_position_3D, Vector3.UP)
	rotation.x = 0
	rotation.z = 0


func _input(event):
	if event is InputEventMouseMotion:
		last_mouse_pos = event.position
