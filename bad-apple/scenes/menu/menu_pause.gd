extends Control
class_name MenuPause

@export var BTNQuit: Button

func _ready():
	# check if web build
	if OS.get_name() == "Web":
		BTNQuit.disabled = true