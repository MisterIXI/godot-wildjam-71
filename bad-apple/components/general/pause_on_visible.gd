class_name PauseOnVisible
extends Node
## Pauses the game when the parent node is visible and unpauses when becomes invisible again.

var parent
func _ready():
	parent = get_parent()
	parent.visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed():
	if parent.visible:
		get_tree().paused = true
	else:
		get_tree().paused = false
