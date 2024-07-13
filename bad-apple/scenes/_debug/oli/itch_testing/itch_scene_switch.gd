class_name ItchSceneSwitch
extends Node

## New scene to swap to when the button is clicked. (Needs swap_scenes to be enabled)
@export var new_scene : PackedScene


var _btn : Button
func _ready():
	_btn = get_parent()
	_btn.pressed.connect(_on_button_pressed)


func _on_button_pressed():
	get_tree().change_scene_to_packed(new_scene)