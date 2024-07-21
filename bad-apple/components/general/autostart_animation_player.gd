extends AnimationPlayer


func _ready():
	var _name = get_animation_list()[1]
	play(_name)
