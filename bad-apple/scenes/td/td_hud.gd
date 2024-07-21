extends Control
class_name TDHUD
@export var health : int = 100
@export var shaker : Control = null
@export var foreground_bar : Control = null
@export var death_label: Control = null

var start_pos: float = 0

# THIS SIGNAL SHOULD BE OUTSIDE THE SCRIPT
signal snake_damaged(health : float)

func _ready():
	start_pos = foreground_bar.size.x
	snake_damaged.connect(_on_snake_damaged)


func _on_snake_damaged(_health : int) -> void:
	var tween = create_tween()
	tween.tween_property(foreground_bar, "size:x", start_pos * _health / 100, 0.2)
	health = _health

	var shaker_tween = create_tween()
	shaker_tween.tween_property(shaker, "position", Vector2(randi_range(-4,4), randi_range(-4,4)), 0.1)
	shaker_tween.tween_property(shaker, "position", Vector2(0, 0), 0.1)


# TEST FUNCTION PLS DELETE
func _input(event):
	if event.is_action_pressed("f"):
		snake_damaged.emit(health-1)
