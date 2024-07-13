class_name SnakeGridManager
extends Node
@export var grid_root: Node3D

# TODO: put this in global resource holder
@export var settings: SnakeSettings

func get_pos_from_coord(coord: Vector2i) -> Vector3:
	var result_pos: Vector3 = grid_root.global_position
	var tilesize = settings.grid_tile_size
	# offset by half grid
	result_pos -= _total_grid_size() / 2
	# offset half a tile
	result_pos += Vector3(1,0,1) * tilesize / 2
	# offset by tiles
	result_pos += Vector3(coord.x * tilesize, 0, coord.y * tilesize)
	return result_pos

func get_coord_from_pos(pos: Vector3) -> Vector2i:
	var tilesize = settings.grid_tile_size
	pos -= grid_root.global_position
	pos += _total_grid_size() / 2
	var x:int = int(pos.x / tilesize)
	var y:int = int(pos.z / tilesize)
	return Vector2i(x,y)

func _total_grid_size() -> Vector3:
	return Vector3(settings.grid_dims.x * settings.grid_tile_size, 0, settings.grid_dims.y * settings.grid_tile_size)
