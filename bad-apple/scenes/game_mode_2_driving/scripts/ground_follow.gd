extends MeshInstance3D

@export var player_node : Node3D


func _process(_delta):
	global_transform.origin.x = player_node.global_position.x