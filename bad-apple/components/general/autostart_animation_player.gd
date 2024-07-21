extends AnimationPlayer

@export var animation_int = 1


func _ready():
	var _name = get_animation_list()[animation_int]
	play(_name)
