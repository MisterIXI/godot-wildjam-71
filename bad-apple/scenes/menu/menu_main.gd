extends Control
class_name MenuMain
@export var BTNStartGame: Button
@export var BTNOptions: Button
@export var BTNCredits: Button
@export var BTNQuit: Button

func _ready():
	# check if web build
	if OS.get_name() == "Web":
		BTNQuit.disabled = true
