extends CharacterBody3D

@export var camera: Camera3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _physics_process(_delta):
	# look_at_mouse_position()
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


# func look_at_mouse_position():
# 	var mouse_position = get_viewport().get_mouse_position()
# 	var ray_start = camera.project_ray_origin(mouse_position)
# 	var ray_end = ray_start + camera.project_ray_normal(mouse_position) * 1000
# 	var space_state = get_world_3d().direct_space_state
# 	var result = space_state.intersect_ray(ray_start, ray_end)
# 	if result:
# 		var target_position = result.position
# 		var direction = (target_position - global_transform.origin).normalized()
# 		direction.y = 0 # Keep the character upright
# 		if direction.length() > 0:
# 			look_at(global_transform.origin + direction, Vector3.UP)