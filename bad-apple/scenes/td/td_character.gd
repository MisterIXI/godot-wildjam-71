extends CharacterBody3D
class_name TDCharacter
@export var camera: Camera3D
@export var model: Node3D

@export var bullet: PackedScene

const CAMERA_VERT_OFFSET = 3.0
const CAMERA_CAGE_SIZE = 3
const SPEED = 10.0
const ACCELERATION = 125.0
const JUMP_VELOCITY = 4.5
var last_mouse_pos = Vector2(0, 0)
var mouse_position_3D = Vector3(0, 0, 0)
const SHOT_CD = 0.03
var shot_cd_left: float = 0.0
var is_dead = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta):
	if is_dead:
		return
	_handle_rotation()
	_handle_movement(delta)
	_move_camera(delta)
	_check_for_shooting(delta)

func _handle_movement(delta: float):
	var input_dir = Input.get_vector("left", "right", "up", "down").normalized()
	input_dir *= SPEED
	var input_3d = Vector3(input_dir.x, 0, input_dir.y)
	velocity = velocity.move_toward(input_3d, ACCELERATION * delta)
	
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
		mouse_position_3D.y = 0
		model.look_at(mouse_position_3D, Vector3.UP)

func _move_camera(delta):
	var target = Vector3(
			clamp(
				camera.global_position.x,
				model.global_position.x - CAMERA_CAGE_SIZE,
				model.global_position.x + CAMERA_CAGE_SIZE
			),
			16,
			clamp(
				camera.global_position.z,
				model.global_position.z - CAMERA_CAGE_SIZE + CAMERA_VERT_OFFSET,
				model.global_position.z + CAMERA_CAGE_SIZE + CAMERA_VERT_OFFSET
			)
	)
	target.z = clamp(target.z, -20, -2)
	target.x = clamp(target.x, -4, 4)
	camera.global_position = camera.global_position.move_toward(
		target,
		camera.global_position.distance_to(target) * 4 * delta
	)
	pass

func _check_for_shooting(delta: float):
	# check if lmb is down
	shot_cd_left = clamp(shot_cd_left - delta, 0, SHOT_CD)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if shot_cd_left == 0:
			shot_cd_left = SHOT_CD
			# shoot
			var new_bullet = bullet.instantiate() as Node3D
			get_parent().add_child(new_bullet)
			new_bullet.global_position = model.global_position - model.global_transform.basis.z * 1
			new_bullet.global_position += model.global_transform.basis.x * 0.27
			new_bullet.global_position.y = 0.9
			new_bullet.global_transform.basis = model.global_transform.basis
			new_bullet.is_flying = true
			new_bullet.speed = 20
			pass
	pass
func _input(event):
	if event is InputEventMouseMotion:
		last_mouse_pos = event.position

func kill_player():
	model.visible = false
	is_dead = true
	# TODO: add death particles

	pass