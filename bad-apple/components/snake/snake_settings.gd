extends Resource
class_name SnakeSettings

# category snake vars
@export_subgroup("SnakeSettings")
## base speed in grid_tiles per second
@export var base_speed: float = 1
## turn speed in radians per second
@export var turn_speed: float = 8.143

@export_subgroup("GridSettings")
@export var grid_dims: Vector2i = Vector2i(16,16)
@export var grid_tile_size: float = 1