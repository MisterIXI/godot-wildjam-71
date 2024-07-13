class_name ModulateOnVisible
extends Node
## Modulates the opacity of the parent node when it turns visible on screen.

## Duration in seconds of the opacity fade animation.
@export_range(0.1, 3) var animation_duration: float = 0.15


var parent
func _ready():
	parent = get_parent()
	parent.visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed():
	if parent.visible:
		parent.modulate.a = 0
		var tween = get_tree().create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(parent, "modulate:a", 1, animation_duration)