extends Camera3D

@export var epic_player :Node3D

var offset :Vector3 = Vector3.ZERO

func _ready():
	# GET PLAYER POSITION OFFSET
	offset = global_position - epic_player.global_position
	pass
func _process(_delta):
	global_position = epic_player.global_position + offset