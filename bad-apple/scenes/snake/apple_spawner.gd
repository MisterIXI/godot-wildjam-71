extends Node
class_name SnakeAppleSpawner

@export var apple_model: PackedScene
@onready var grid: SnakeGridManager = %SnakeGridManager
@onready var spawner: SnakeSpawner = %SnakeSpawner
@export var apple_label: Label

func spawn_apple():
	var positions: Array[Vector2i] = []
	for i in range(grid.settings.grid_dims.x):
		for j in range(grid.settings.grid_dims.y):
			positions.append(Vector2i(i,j))
	for snake in spawner.spawned_snakes:
		positions.erase(snake.curr_tile)
		positions.erase(snake.prev_tile)
	var apple_pos = positions[randi() % positions.size()]
	var apple = apple_model.instantiate()
	grid.grid_root.add_child(apple)
	apple.global_position = grid.get_pos_from_coord(apple_pos)
	apple.scale = Vector3.ONE * 0.01
	apple.create_tween().tween_property(apple, "scale", Vector3.ONE, 0.3)
	var tween = apple.create_tween()
	var v_offset = Vector3(0,0.25,0)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(apple, "position", apple.position + v_offset, 2)
	tween.tween_property(apple, "position", apple.position - v_offset, 2)
	tween.set_loops()
	tween = apple.create_tween()
	var rotator = func(value:float):
		apple.rotation_degrees.y = value
	tween.tween_method(rotator, 0,360.1,5)
	tween.set_loops()
