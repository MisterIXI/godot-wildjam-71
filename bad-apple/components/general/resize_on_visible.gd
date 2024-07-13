class_name ResizeOnVisible
extends Node
## Resizes the parent node when it turns visible on screen.

## Duration in seconds of the opacity fade animation.
@export_range(0.1, 3) var animation_duration: float = 1
## Target size to resize the parent node to standard is 1,1.
@export var max_size: Vector2 = Vector2(1.1, 1.1)
## Target size to resize the parent node to standard is 1,1.
@export var min_size: Vector2 = Vector2(0.9, 0.9)


var parent
func _ready():
	parent = get_parent()
	parent.scale = min_size
	parent.visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed():
	if parent.visible:
		var tween = get_tree().create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(parent, "scale", max_size, animation_duration)
		tween.tween_property(parent, "scale", min_size, animation_duration)
		await tween.finished
		_on_visibility_changed()
