class_name BlockInputsOnVisible
extends Node


var parent
func _ready():
	parent = get_parent()
	parent.visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed():
	if parent.visible:
		set_process(false)
	else:
		set_process(true)