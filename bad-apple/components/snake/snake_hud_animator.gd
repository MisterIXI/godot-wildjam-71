extends Control

@export var score_label: Label
@export var died_label: Control
@export var died_effect: TextureRect
# func _ready():
# 	var tween = score_label.create_tween()
# 	tween.set_loops(true)
# 	tween.tween_property(score_label, "position", score_label.position + Vector2(0, 10), 1)
# 	tween.tween_property(score_label, "position", score_label.position - Vector2(0, 10), 1)
