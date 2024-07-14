extends MeshInstance3D

@export var player_object : Node3D = null

func _process(_delta):
	if player_object == null:
		return
	global_position.x = player_object.global_transform.origin.x 
	