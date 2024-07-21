extends Area3D
class_name SnakePart

@export var is_controlled_externally: bool = false

@export var snake_head: Node3D
@export var snake_body: Node3D
@export var snake_tail: Node3D
@export var animation_player: AnimationPlayer

var tween: Tween = null

var curr_tile: Vector2i = Vector2i.ZERO
var prev_tile: Vector2i = Vector2i.ZERO

var front_part: SnakePart = null
var back_part: SnakePart = null

var direction_input: Vector2i = Vector2i.ZERO
var direction_buffer: Array[Vector2i] = []

var parts_to_spawn: int = 0

var apples_eaten: int = 0
var is_alive = true

@onready var grid: SnakeGridManager = get_node("../%SnakeGridManager")
# var grid: SnakeGridManager = null
func is_head() -> bool: return front_part == null
func is_tail() -> bool: return back_part == null
func get_last_part() -> SnakePart:
	var curr_part = self
	while curr_part.back_part != null:
		curr_part = curr_part.back_part
	return curr_part

func _ready():
	pass

func head_set_new_tile() -> void:
	var prev_dir = curr_tile - prev_tile
	prev_tile = curr_tile
	var new_dir = direction_buffer.pop_front()
	if new_dir != null and not (
		(new_dir.x != 0 and direction_input.x == - new_dir.x) or
		(new_dir.y != 0 and direction_input.y == - new_dir.y)):
		direction_input = new_dir
	if direction_input.x == 0 and direction_input.y != 0:
		curr_tile.y += 1 if direction_input.y > 0 else - 1
	elif direction_input.x != 0 and direction_input.y == 0:
		curr_tile.x += 1 if direction_input.x > 0 else - 1
	else:
		curr_tile += prev_dir

func grow_parts(_count: int) -> void:
	get_last_part().parts_to_spawn += _count

func _process(_delta):
	var input: Vector2i = Vector2i.ZERO
	if is_head():
		if Input.is_action_just_pressed("space"):
			grow_parts(1)
			print("manually growing")
		if Input.is_action_just_pressed("r"):
			# var part_to_kill = back_part.back_part.back_part
			# var front = part_to_kill.front_part
			# var back = part_to_kill.back_part
			# part_to_kill.queue_free()
			# front.back_part = back
			# back.front_part = front
			if !is_alive:
				get_tree().paused = false
				get_tree().reload_current_scene()
	if Input.is_action_just_pressed("up"):
		input = Vector2i(0, -1)
	elif Input.is_action_just_pressed("down"):
		input = Vector2i(0, 1)
	elif Input.is_action_just_pressed("left"):
		input = Vector2i( - 1, 0)
	elif Input.is_action_just_pressed("right"):
		input = Vector2i(1, 0)
	if input != Vector2i.ZERO and direction_buffer.size() < 3 and (direction_buffer.is_empty() or direction_buffer[- 1] != input):
		direction_buffer.append(input)

func _physics_process(delta):
	if is_controlled_externally:
		return
	if is_head() and is_alive:
		var curr_part = self
		while curr_part != null:
			curr_part._process_movement(curr_part, delta)
			curr_part = curr_part.back_part

func _process_movement(snake_part: SnakePart, delta: float):
	if not is_head():
		if snake_part.front_part.prev_tile != snake_part.curr_tile:
			if parts_to_spawn > 0:
				parts_to_spawn -= 1
				get_node("../%SnakeSpawner").spawn_part(snake_part)
			snake_part.prev_tile = snake_part.curr_tile
			snake_part.curr_tile = snake_part.front_part.prev_tile
	var target_pos = grid.get_pos_from_coord(curr_tile)
	# check if tile will be reached
	if is_head() and snake_part.global_position.distance_to(target_pos) < grid.settings.base_speed * delta:
		# reached tile
		head_set_new_tile()
		target_pos = grid.get_pos_from_coord(snake_part.curr_tile)
	
	# turn towards direction
	var move_dir = target_pos - snake_part.global_position
	if move_dir.length() > 0.1:
		var move_angle = atan2(move_dir.x, move_dir.z)
		snake_part.rotation_degrees.y = rad_to_deg(rotate_toward(snake_part.rotation.y, move_angle, grid.settings.turn_speed * delta))
	var catchup_bonus = 1
	if not is_head():
		var distance = snake_part.global_position.distance_to(snake_part.front_part.global_position)
		if distance > 1.3:
			if distance > 3:
				catchup_bonus = 3
			else:
				catchup_bonus = 2
	# move towards curr_tile_pos
	snake_part.global_position = snake_part.global_position.move_toward(target_pos, grid.settings.base_speed * delta * catchup_bonus)

func force_rotation():
	var move_dir = grid.get_pos_from_coord(curr_tile) - grid.get_pos_from_coord(prev_tile)
	var move_angle = rad_to_deg(atan2(move_dir.x, move_dir.z))
	rotation_degrees.y = move_angle

func update_model():
	if is_head():
		snake_head.visible = true
		snake_body.visible = false
		snake_tail.visible = false
		animation_player.play("idle", -1, 1.5)
	elif is_tail():
		snake_head.visible = false
		snake_body.visible = false
		snake_tail.visible = true
	else:
		snake_head.visible = false
		snake_body.visible = true
		snake_tail.visible = false
	if tween != null:
		tween.kill()
	if not is_head():
		var body = snake_body if not is_tail() else snake_tail
		tween = body.create_tween()
		var tween_angle = 5
		var start_angle = randf() * tween_angle * 2
		var time_from_start = 0.5 * (start_angle / (tween_angle * 2))
		start_angle = start_angle - tween_angle
		print("Start_angle", start_angle, " tfs: ", time_from_start)
		tween.set_loops()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_LINEAR)
		if randf() > 0.5:
			# start to right
			tween.tween_property(body, "rotation_degrees:y", tween_angle, 0.5 - time_from_start).from(start_angle)
			tween.tween_property(body, "rotation_degrees:y", -tween_angle, 0.5)
			tween.tween_property(body, "rotation_degrees:y", start_angle, time_from_start)
		else:
			tween.tween_property(body, "rotation_degrees:y", -tween_angle, time_from_start).from(start_angle)
			tween.tween_property(body, "rotation_degrees:y", tween_angle, 0.5)
			tween.tween_property(body, "rotation_degrees:y", start_angle, 0.5 - time_from_start)

func die():
	print("died")
	animation_player.play("hurt")
	is_alive = false
	# Engine.time_scale = 0
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	var animator = get_parent().get_parent().get_node("%HUD")
	animator.died_effect.visible = true
	animator.died_label.visible = true

func _on_area_entered(area: Area3D):
	if not is_head():
		return
	if area.is_in_group("Apple"):
		grow_parts(1)
		area.queue_free()
		var apple_spawner = get_node("../%SnakeAppleSpawner")
		apple_spawner.spawn_apple()
		apples_eaten += 1
		apple_spawner.apple_label.text = str(apples_eaten)
		print("apples eaten: ", apples_eaten)
	### only in actual play mode below this
	if is_controlled_externally:
		return
	if area.is_in_group("DeathWall"):
		die()
	if area.is_in_group("SnakePart"):
		if back_part != area and (back_part != null and back_part.back_part != area):
			die()

func _exit_tree():
	var spawn_manager: SnakeSpawner = get_node("../%SnakeSpawner")
	if spawn_manager != null and spawn_manager.spawned_snakes.has(self):
		spawn_manager.spawned_snakes.erase(self)
