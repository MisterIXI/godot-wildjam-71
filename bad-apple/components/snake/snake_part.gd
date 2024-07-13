extends Area3D
class_name SnakePart

var curr_tile: Vector2i = Vector2i.ZERO
var prev_tile: Vector2i = Vector2i.ZERO

var front_part: SnakePart = null
var back_part: SnakePart = null

var direction_input: Vector2i = Vector2i.ZERO
var direction_buffer: Array[Vector2i] = []

@onready var grid: SnakeGridManager = get_node("../%SnakeGridManager")
# var grid: SnakeGridManager = null
func is_head() -> bool: return front_part == null
func is_tail() -> bool: return back_part == null

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

func grow_parts(count: int) -> void:
	
	pass

func _process(_delta):
	var input: Vector2i = Vector2i.ZERO
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
	if is_head():
		var curr_part = self
		while curr_part != null:
			curr_part._process_movement(curr_part, delta)
			curr_part = curr_part.back_part

func _process_movement(snake_part: SnakePart, delta: float):
	if not is_head():
		if snake_part.front_part.prev_tile != snake_part.curr_tile:
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

	# move towards curr_tile_pos
	snake_part.global_position = snake_part.global_position.move_toward(target_pos, grid.settings.base_speed * delta)

func force_rotation():
	var move_dir = grid.get_pos_from_coord(curr_tile) - grid.get_pos_from_coord(prev_tile)
	var move_angle = rad_to_deg(atan2(move_dir.x, move_dir.z))
	rotation_degrees.y = move_angle
	