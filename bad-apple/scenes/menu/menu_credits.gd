extends Control
class_name MenuCredits

@export var BTNBack: Button



func _on_secret_lvl_button_pressed():
	get_tree().change_scene_to_packed.call_deferred(GlobMenu.end_game_scene)
	GlobMenu._hide_all()
