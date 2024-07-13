extends Node
class_name SnakeSpawner

@export var snake_part_model: PackedScene
@onready var grid: SnakeGridManager = %SnakeGridManager

var spawned_snakes: Array[SnakePart] = []

## first and last positions are head and tail directions and will not spawn a body part
@export var snake_positions: Array[Vector2i] = [
	Vector2i(6,8),
	Vector2i(7,8),
	Vector2i(8,8),
	Vector2i(9,8),
	Vector2i(10,8),
	Vector2i(11,8),
]

func spawn_snake():
	var prev_part: SnakePart = null
	for i in snake_positions.size():
		if i == 0 or i == snake_positions.size() - 1:
			continue
		var snake_part: SnakePart = snake_part_model.instantiate()
		grid.grid_root.add_child(snake_part)
		snake_part.grid = grid
		snake_part.global_position = grid.get_pos_from_coord(snake_positions[i])
		snake_part.curr_tile = snake_positions[i]
		snake_part.prev_tile = snake_positions[i+1]
		snake_part.force_rotation()
		if prev_part != null:
			prev_part.back_part = snake_part
			snake_part.front_part = prev_part
			prev_part.update_model()
		if i == 1:
			snake_part.direction_input = snake_positions[0] - snake_positions[1]
		prev_part = snake_part
		snake_part.update_model()
		spawned_snakes.append(snake_part)

func spawn_part(prev_part: SnakePart):
	var snake_part: SnakePart = snake_part_model.instantiate()
	grid.grid_root.add_child(snake_part)
	snake_part.grid = grid
	snake_part.global_position = grid.get_pos_from_coord(prev_part.curr_tile)
	snake_part.curr_tile = prev_part.curr_tile
	snake_part.prev_tile = prev_part.prev_tile
	snake_part.force_rotation()
	prev_part.back_part = snake_part
	snake_part.front_part = prev_part
	snake_part.parts_to_spawn = prev_part.parts_to_spawn
	prev_part.parts_to_spawn = 0
	prev_part.update_model()
	snake_part.update_model()
	spawned_snakes.append(snake_part)

func _ready():
	spawn_snake()
	%SnakeAppleSpawner.spawn_apple.call_deferred()
