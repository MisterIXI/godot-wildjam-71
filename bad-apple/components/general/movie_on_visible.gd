extends Control
class_name MovieOnVisible


var parent
var rect_top = null
var rect_bot = null

func _ready():
	parent = get_parent()
	parent.visibility_changed.connect(_on_visibility_changed)
	

	rect_top = ColorRect.new()
	rect_top.set_deferred("size", Vector2(1280, 150))
	rect_top.set_deferred("color", Color(0, 0, 0, 1))
	rect_top.set_deferred("visible", false)
	parent.add_child.call_deferred(rect_top)

	rect_bot = ColorRect.new()
	rect_bot.set_deferred("size", Vector2(1280, 150))
	rect_bot.set_deferred("color", Color(0, 0, 0, 1))
	rect_bot.set_deferred("position", Vector2(0, 960 - 150))
	rect_bot.set_deferred("visible", false)
	parent.add_child.call_deferred(rect_bot)


func _on_visibility_changed():
	if parent.visible:
		rect_top.visible = true
		rect_top.position = Vector2(0, -160)
		var tween_top = get_tree().create_tween()
		tween_top.tween_property(rect_top, "position", Vector2(0, 0), 1)

		rect_bot.visible = true
		rect_bot.position = Vector2(0, 970)
		var tween_bot = get_tree().create_tween()
		tween_bot.tween_property(rect_bot, "position", Vector2(0, 960-150), 1)
	else:
		rect_top.visible = false
		rect_bot.visible = false
