extends Area3D

@export var make_visible : Node3D = null
@export var animation_player : AnimationPlayer = null
@export var next_scene : PackedScene = null

var color_rect : ColorRect = null

func _ready():
	area_entered.connect(_on_area_entered)

	
	color_rect = ColorRect.new()
	color_rect.set_deferred("size", Vector2(1280, 860))
	color_rect.set_deferred("color", Color(0, 0, 0, 1))
	color_rect.set_deferred("visible", false)
	add_child.call_deferred(color_rect)


func _on_area_entered(area):
	if area.is_in_group("PlayerHitbox"):
		make_visible.visible = true
		animation_player.play("fps_outro")
		await animation_player.animation_finished

		if next_scene:
			color_rect.visible = true
			get_tree().change_scene_to_packed(next_scene)