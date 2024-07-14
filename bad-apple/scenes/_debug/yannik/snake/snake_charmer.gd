extends PathFollow3D
class_name SnakePathFollower

@onready var spawner: SnakeSpawner = %SnakeSpawner
@onready var parent_curve: Path3D = get_parent()
@export var snake_part: SnakePart
@export var self_scene: PackedScene
@export var spawn_with_parts: int = 5
var back_part: SnakePathFollower = null

func _ready():
	snake_part.is_controlled_externally = true
	var prev_part: SnakePathFollower = self
	for i in range(spawn_with_parts):
		var new_part: SnakePathFollower = self_scene.instantiate()
		parent_curve.add_child(new_part)
		prev_part.back_part = new_part
		prev_part.snake_part.back_part = new_part.snake_part
		new_part.snake_part.front_part = prev_part.snake_part
		prev_part.snake_part.update_model()
		prev_part = new_part
	prev_part.snake_part.update_model()
	


func _physics_process(delta):
	progress += delta * spawner.grid.settings.base_speed * spawner.grid.settings.grid_tile_size