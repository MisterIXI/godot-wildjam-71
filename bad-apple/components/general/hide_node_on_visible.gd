class_name HideNodeOnVisible
extends Node
## Hides the exported node when it turns visible on screen.


@export var node : Node


var parent
func _ready():
	parent = get_parent()
	parent.visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed():
	if parent.visible:
		node.hide()